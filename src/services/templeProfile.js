// Turns one temple record into a "profile": the set of comparable facts we can
// recognise in ALL of its metadata — columns, the metadata JSON, and the free text
// (description / history / architecture / significance). Two temples are connected
// when their profiles share facts. Pure functions only (no network), so it is testable.

export const norm = (value = "") =>
  String(value).normalize("NFKD").replace(/[̀-ͯ]/g, "")
    .toLowerCase().replace(/[^a-z0-9]+/g, " ").trim();

const title = (s) => s.replace(/\b\w/g, (c) => c.toUpperCase());
const ordinal = (n) => {
  const v = n % 100;
  if (v >= 11 && v <= 13) return `${n}th`;
  return `${n}${({ 1: "st", 2: "nd", 3: "rd" })[n % 10] || "th"}`;
};
const GENERIC = new Set([
  "hindu", "hinduism", "temple", "hindu temple", "india", "unknown", "none", "n a", "na",
  "not specified", "not recorded", "other", "various", "mandir", "kovil", "devasthanam",
]);

// ---------------------------------------------------------------- rule tables
// [key, label, regex on NORMALISED text, extra keys to also emit]
const DEITIES = [
  ["shiva", "Shiva", /\b(?!venkat|vigne|vighne|ganes|muneesw|munesw)(?:shiva|siva|sivan|shivan|shiv|shankar|shankara|shankaran|sankar|sankara|sankaran|mahadev\w*|nataraj\w*|linga\w*|lingam|vishwanath|visvanath|vishvanath|kedarnath|somnath|somanath|amarnath|mallikarjun\w*|pashupati\w*|pasupathi\w*|pasupatheesw\w*|ardhanari\w*|rudra\w*|bhairav\w*|mahakal\w*|ekambar\w*|arunachal\w*|annamalai\w*|kailas\w*|ramanatha\w*|jambukes\w*|brihadis\w*|brihadees\w*|thyagara\w*|vaidyanath\w*|nageswar\w*|nageshwar\w*|trimbak\w*|omkar\w*|bhimashankar|ghrishn\w*|\w*(?:eswar|eshwar|ishwar|isvar|easwar)(?!i)\w*)\b/],
  ["vishnu", "Vishnu", /\b(?:vishnu|visnu|perumal|narayan\w*|venkat\w*|balaji|srinivas\w*|ranganath\w*|jagannath\w*|vithal\w*|vithoba|pandurang\w*|badrinath|dwarkadhish\w*|varadaraj\w*|varadharaj\w*|azhagar|alagar|kallazhagar|vaikunt\w*|padmanabh\w*|govind\w*|keshav\w*|madhav\w*|janardan\w*|achyut\w*|thiruvengad\w*|sarangapani|adikesava|chennakesava|channakeshava|hari|narasimh\w*|narsimh\w*|narasingh\w*|krishn\w*|gopal\w*|rama|raghunath\w*|ramachandra\w*|kodanda\w*|sri ram)\b/],
  ["krishna", "Krishna", /\b(?:krishn\w*|krsna|kanha|gopal\w*|radha\w*|govind\w*|banke bihari|dwarkadhish\w*|vithal\w*|vithoba|pandurang\w*)\b/],
  ["rama", "Rama", /\b(?:rama|raghunath\w*|ramachandra\w*|kodanda\w*|sri ram|ram mandir|sita ram|seetha|sita)\b/],
  ["narasimha", "Narasimha", /\b(?:narasimh\w*|narsimh\w*|narasingh\w*|nrusimha|nrisimha|ahobil\w*)\b/],
  ["venkateswara", "Venkateswara (Balaji)", /\b(?:venkat\w*|balaji|srinivas\w*|thiruvengad\w*|tirumala)\b/],
  ["jagannath", "Jagannath", /\bjagannath\w*\b/],
  ["murugan", "Murugan (Kartikeya)", /\b(?:murugan|murukan|kartikeya|karthikeya|kartik|skanda|\w*subr\w*manya\w*|\w*subramani\w*|kumara\w*|kumaran|arumugam|shanmukha|shanmuga\w*|velan|swaminatha\w*|dandayudhapani|palani|thiruchendur|thiruparankundram)\b/],
  ["ganesha", "Ganesha", /\b(?:ganesh\w*|ganapati\w*|ganapathy|vinayak\w*|pillaiyar|vigneshwar\w*|vighneshwar\w*|siddhivinayak)\b/],
  ["hanuman", "Hanuman", /\b(?:hanuman\w*|anjaney\w*|anjaneya|maruti|bajrang\w*|veeranjaney\w*)\b/],
  ["devi", "Devi (Shakti)", /\b(?:devi|amman|ambal|ambika|ambaji|parvati|parvathi|durga|kali|kalika|bhavani|bhagavath\w*|bhagwati|lakshmi|laxmi|mahalakshmi|saraswati|sarasvati|meenakshi|kamakshi|\w*(?:eswari|eshwari|ishwari|ishvari)|mariamman|mariyamman|renuka\w*|chamund\w*|vaishno|shakti|chandi|kanyakumari|yellamma|jagadamba|tripura\w*|lalita\w*|kamakhya|gowri|gauri|gouri|mata|mookambika|annapurna|pidari|bhadrakali|attukal)\b/],
  ["ayyappa", "Ayyappa (Sastha)", /\b(?:ayyapp\w*|sastha\w*|shasta|sabarimala|manikanta\w*|hariharaputra)\b/],
  ["surya", "Surya (Sun)", /\b(?:surya\w*|suriya\w*|aditya|arka|sun god|sun temple)\b/],
  ["navagraha", "Navagraha", /\b(?:navagraha\w*|shani|shanishwar\w*)\b/],
  ["guardian", "Village guardian deities", /\b(?:ayyanar|aiyanar|muniyappan|muneeswar\w*|karuppu\w*|karuppasamy|madurai veeran|veerabhadra\w*|kshetrapal\w*)\b/],
  ["naga", "Naga (serpent)", /\b(?:nagaraja\w*|nagaraj|nagadevata|sarpa\w*|mannarasala|nagathamman)\b/],
];
// Avatar / form deities also count as Vishnu (the page text says "related forms of the divine").
const ALSO_VISHNU = new Set(["krishna", "rama", "narasimha", "venkateswara", "jagannath"]);
const DEITY_TRADITION = {
  shiva: "Shaiva", vishnu: "Vaishnava", krishna: "Vaishnava", rama: "Vaishnava", narasimha: "Vaishnava",
  venkateswara: "Vaishnava", jagannath: "Vaishnava", devi: "Shakta", murugan: "Kaumaram",
  ganesha: "Ganapatya", surya: "Saura",
};

const DYNASTIES = [
  ["chola", "Chola", /\bchola\w*\b/], ["pandya", "Pandya", /\bpandy\w*\b/], ["pallava", "Pallava", /\bpallava\w*\b/],
  ["chera", "Chera", /\bchera\w*\b/], ["hoysala", "Hoysala", /\bhoysala\w*\b/],
  ["chalukya", "Chalukya", /\bchalukya\w*\b/], ["rashtrakuta", "Rashtrakuta", /\brashtrakuta\w*\b/],
  ["vijayanagara", "Vijayanagara", /\bvijayanagar\w*\b/], ["nayak", "Nayak", /\bnayak\w*\b|\bnayaka\w*\b/],
  ["kakatiya", "Kakatiya", /\bkakatiya\w*\b/], ["eastern ganga", "Eastern Ganga", /\beastern ganga\b/],
  ["western ganga", "Western Ganga", /\bwestern ganga\b/], ["gupta", "Gupta", /\bgupta\w*\b/],
  ["maurya", "Maurya", /\bmaurya\w*\b/], ["pala", "Pala", /\bpala (?:dynasty|empire|kings?|rulers?|period)\b/],
  ["chandela", "Chandela", /\bchandel\w*\b/], ["solanki", "Solanki (Chaulukya)", /\bsolanki\b|\bchaulukya\b/],
  ["paramara", "Paramara", /\bparamara\b|\bparmar\b/], ["kalachuri", "Kalachuri", /\bkalachuri\w*\b/],
  ["maratha", "Maratha", /\bmaratha\w*\b|\bpeshwa\w*\b|\bshivaji\b|\bholkar\b|\bscindia\b|\bsatara\b/],
  ["travancore", "Travancore (Venad)", /\btravancore\b|\bvenad\b|\bmarthanda varma\b/],
  ["zamorin", "Zamorin / Kozhikode", /\bzamorin\b|\bsamoothiri\b|\bsamuthiri\b/],
  ["cochin", "Cochin royal family", /\bcochin (?:royal|maharaja|kingdom)\b|\bperumpadappu\b/],
  ["kadamba", "Kadamba", /\bkadamba\w*\b/], ["satavahana", "Satavahana", /\bsatavahana\w*\b/],
  ["ahom", "Ahom", /\bahom\b/], ["gajapati", "Gajapati", /\bgajapati\w*\b/], ["reddy", "Reddy kings", /\breddy (?:kings?|dynasty|rulers?)\b|\breddi\b/],
  ["wodeyar", "Wodeyar (Mysore)", /\bwodeyar\w*\b|\bwadiyar\b|\bmysore (?:kingdom|rulers?|maharaja)\b/],
  ["sena", "Sena", /\bsena dynasty\b/], ["maukhari", "Maukhari", /\bmaukhari\b/],
  ["somavamshi", "Somavamshi", /\bsomavam\w*\b|\bkeshari\b/], ["tondaiman", "Tondaiman", /\btondaiman\b/],
  ["sethupathi", "Sethupathi", /\bsethupathi\w*\b|\bsetupati\b/], ["kongu", "Kongu", /\bkongu\w*\b/],
  ["rajput", "Rajput", /\brajput\w*\b|\bkachwaha\b|\bsisodia\b|\bmaharana\b/], ["tripuri", "Kalinga / Bhauma-Kara", /\bbhauma\b/],
];

const STYLES = [
  ["dravidian", "Dravidian", /\bdravid\w*\b/], ["nagara", "Nagara", /\bnagara style\b|\bnagara architecture\b|\bnagara\b(?! \w*pur)/],
  ["vesara", "Vesara", /\bvesara\b/], ["kalinga", "Kalinga (Odishan)", /\bkalinga (?:style|architecture|temple)\b|\bodishan\b|\bdeula\b|\brekha\b|\bpidha\b|\bkhakhara\b/],
  ["hoysala style", "Hoysala style", /\bhoysala (?:style|architecture)\b/], ["chalukyan", "Chalukyan style", /\bchalukya?n? (?:style|architecture)\b/],
  ["kerala", "Kerala style", /\bkerala (?:style|architecture|temple architecture)\b|\bnalambalam\b|\bkoothambalam\b|\bnamaskara mandap\w*\b|\bchuttambalam\b/],
  ["vijayanagara style", "Vijayanagara style", /\bvijayanagar\w* (?:style|architecture)\b/], ["nayak style", "Nayak style", /\bnayak\w* (?:style|architecture)\b/],
  ["maru gurjara", "Maru-Gurjara", /\bmaru gurjara\b|\bsolanki (?:style|architecture)\b/], ["pahari", "Pahari / Himalayan", /\bpahari\b|\bkatyuri\b|\bpagoda style\b|\bkath khuni\b/],
  ["bengal", "Bengal terracotta", /\bterracotta\b|\bat chala\b|\baat chala\b|\bchala roof\b|\bdo chala\b|\bek ratna\b|\bnavaratna\b/],
  ["bhumija", "Bhumija", /\bbhumija\b/], ["gopuram", "Gopuram (gateway towers)", /\bgopura\w*\b/], ["vimana", "Vimana", /\bvimana\w*\b/],
  ["shikhara", "Shikhara", /\bshikhara\w*\b|\bsikhara\w*\b|\bshikhar\b/], ["mandapa", "Mandapa halls", /\bmandap\w*\b|\bmantap\w*\b/],
  ["rock cut", "Rock-cut", /\brock cut\b|\bcave temple\w*\b|\bmonolith\w*\b/], ["tank", "Temple tank", /\btemple tank\b|\bpushkarini\b|\bteppakulam\b|\btheppakulam\b|\bkund\b|\bsacred tank\b/],
  ["gopura mukha", "Rajagopuram", /\brajagopura\w*\b|\braja gopura\w*\b/],
];
const MATERIALS = [
  ["granite", "Granite", /\bgranite\b/], ["sandstone", "Sandstone", /\bsandstone\b/], ["laterite", "Laterite", /\blaterite\b/],
  ["soapstone", "Soapstone", /\bsoapstone\b|\bchloritic schist\b/], ["basalt", "Basalt", /\bbasalt\b/],
  ["brick", "Brick", /\bbrick\w*\b/], ["wood", "Wood / timber", /\bwooden\b|\btimber\b|\bteak\b/],
  ["marble", "Marble", /\bmarble\b/], ["limestone", "Limestone", /\blimestone\b/], ["stucco", "Stucco", /\bstucco\b|\bplaster\b/],
];

const FESTIVALS = [
  ["brahmotsavam", "Brahmotsavam", /\bbrahmotsav\w*\b|\bbrahmotsava\w*\b/], ["navaratri", "Navaratri / Dussehra", /\bnavaratri\b|\bnavratri\b|\bdussehra\b|\bdasara\b|\bvijayadashami\b/],
  ["shivaratri", "Maha Shivaratri", /\bshivaratri\b|\bsivaratri\b|\bshivratri\b/], ["thaipusam", "Thaipusam", /\bthaipusam\b|\bthai poosam\b/],
  ["skanda shashti", "Skanda Shashti", /\bskanda s[ah]+shti\b|\bsoorasamharam\b|\bsurasamharam\b|\bkanda sashti\b/], ["panguni", "Panguni Uthiram", /\bpanguni uthiram\b/],
  ["kumbhabhishekam", "Kumbhabhishekam", /\bkumbh?abhishekam\b|\bkumbhabhisheka\b|\bmaha kumbhabhishekam\b/],
  ["rath yatra", "Rath Yatra / Car festival", /\brath?a yatra\b|\bcar festival\b|\bther thiruvizha\b|\bchariot festival\b|\bratholsavam\b|\bthiruther\b/],
  ["pongal", "Pongal", /\bpongal\b/], ["diwali", "Diwali / Deepavali", /\bdiwali\b|\bdeepavali\b/], ["onam", "Onam", /\bonam\b/], ["vishu", "Vishu", /\bvishu\b/],
  ["pooram", "Pooram", /\bpooram\b/], ["chithirai", "Chithirai festival", /\bchithirai\b|\bchittirai\b|\bchitrai\b/],
  ["karthigai", "Karthigai Deepam", /\bkarthigai\b|\bkarthika deepam\b|\bkarthikai\b|\bkartika purnima\b/], ["vaikunta ekadashi", "Vaikunta Ekadashi", /\bvaikunta ekadashi\b|\bvaikuntha ekadasi\b|\bmukkoti ekadashi\b/],
  ["ugadi", "Ugadi / New Year", /\bugadi\b|\bgudi padwa\b|\bputhandu\b/], ["ram navami", "Rama Navami", /\bram?a navami\b/], ["janmashtami", "Janmashtami", /\bjanmashtami\b|\bgokulashtami\b/],
  ["holi", "Holi", /\bholi\b/], ["sankranti", "Makar Sankranti", /\bsankranti\b|\bsankranthi\b|\buttarayan\b/], ["kumbh", "Kumbh Mela", /\bkumbh mela\b|\bmaha kumbh\b|\bpushkaram\b/],
  ["bonalu", "Bonalu", /\bbonalu\b/], ["ganesh chaturthi", "Ganesh Chaturthi", /\bganesh chaturthi\b|\bvinayaka chaturthi\b|\bvinayagar chaturthi\b/],
  ["hanuman jayanti", "Hanuman Jayanti", /\bhanuman jayanti\b/], ["aadi", "Aadi festivals", /\baadi (?:pooram|perukku|amavasai|festival|velli)\b|\bady (?:pooram|festival)\b/],
  ["margazhi", "Margazhi / Dhanurmasa", /\bmargazhi\b|\bdhanurmasa\b|\bdhanur masam\b/], ["arudra", "Arudra Darshan / Thiruvathira", /\barudra\b|\bthiruvathira\b|\bthiruvadhirai\b/],
  ["mandala", "Mandala Pooja / Makaravilakku", /\bmandala puja\b|\bmandalam\b|\bmakaravilakku\b|\bmakara jyothi\b/], ["float", "Float festival (Teppotsavam)", /\bfloat festival\b|\bteppotsavam\b|\bteppam\b|\btheppam\b/],
  ["annabhishekam", "Annabhishekam", /\bannabhishek\w*\b/], ["rathasaptami", "Ratha Saptami", /\bratha ?saptami\b/], ["maha kumbh", "Panguni / Phalguna festival", /\bphalguna\b|\bpanguni\b/],
  ["thiruvizha", "Annual temple festival", /\bannual (?:temple )?festival\b|\bthiruvizha\b|\butsavam\b|\butsav\b|\bjatara\b/],
];

const MYTHOLOGY = [
  ["ramayana", "Ramayana", /\bramayan\w*\b|\bravana\b|\blord rama\b|\bsri rama\b|\bsita\b|\blakshmana\b/], ["mahabharata", "Mahabharata", /\bmahabharat\w*\b|\bpandava\w*\b|\barjuna\b|\bkurukshetra\b|\byudhishthira\b|\bdraupadi\b/],
  ["skanda purana", "Skanda Purana", /\bskanda purana\b|\bsthala purana\b|\bsthalapurana\w*\b|\bsthala puranam\b/], ["shiva purana", "Shiva Purana", /\bshiva purana\b|\blinga purana\b/],
  ["vishnu purana", "Vishnu / Bhagavata Purana", /\bvishnu purana\b|\bbhagavata purana\b|\bbhagavatam\b/], ["devi purana", "Devi Mahatmya", /\bdevi mahatmya\b|\bdevi bhagavata\b|\bmahishasura\w*\b|\bchandi path\b/],
  ["purana", "Puranic tradition", /\bpurana\w*\b/], ["sacred tree", "Sacred tree (sthala vriksha)", /\bsthala vriksh\w*\b|\bsthalavriksh\w*\b|\bsacred (?:banyan|neem|peepal|bilva|tree)\b|\bholy tree\b/],
  ["agastya", "Sage Agastya", /\bagastya\w*\b|\bagathiyar\b/], ["parashurama", "Parashurama", /\bparashuram\w*\b|\bparasuram\w*\b/], ["markandeya", "Markandeya", /\bmarkandey\w*\b/],
  ["vyasa", "Sage Vyasa", /\bvyasa\b/], ["valmiki", "Sage Valmiki", /\bvalmiki\b/], ["vishwamitra", "Sage Vishwamitra", /\bvishwamitra\b|\bvisvamitra\b/], ["durvasa", "Sage Durvasa", /\bdurvasa\b/],
  ["samudra", "Churning of the ocean", /\bsamudra manthan\w*\b|\bchurning of (?:the )?(?:ocean|milk)\b/], ["daksha", "Daksha Yajna / Sati", /\bdaksha\b|\bsati devi\b/],
  ["tarakasura", "Surapadman / Tarakasura", /\bsurapadma\w*\b|\btarakasur\w*\b|\bsoorapadman\b/], ["bhasmasura", "Bhasmasura", /\bbhasmasur\w*\b/],
  ["nayanar", "Nayanar saints (Tevaram)", /\bnayan\w*mar\b|\bnayanar\w*\b|\btevaram\b|\bthevaram\b|\bappar\b|\bsambandar\b|\bsundarar\b|\bmanikkavacakar\b|\bmanikkavasagar\b/],
  ["alvar", "Alvar saints (Divya Prabandham)", /\balvar\w*\b|\bazhwar\w*\b|\bandal\b|\bnalayira divya\b|\bperiyalvar\b/],
  ["kailasa", "Mount Kailasa", /\bmount kailas\w*\b|\bmt kailas\w*\b/], ["hanuman legend", "Hanuman legends", /\bhanuman\w* (?:legend|carried|brought)\b/],
];

const HERITAGE = [
  ["unesco", "UNESCO World Heritage Site", /\bunesco\b|\bworld heritage\b/], ["asi", "ASI protected monument", /\barchaeological survey of india\b|\bprotected monument\b|\bmonument of national importance\b|\basi\b/],
  ["jyotirlinga", "Jyotirlinga", /\bjyotirlinga\w*\b|\bjyotirling\w*\b/], ["shakti peetha", "Shakti Peetha", /\bshakti ?peeth\w*\b|\bshakti pitha\b|\bshaktipith\w*\b/],
  ["divya desam", "Divya Desam", /\bdivya desam\w*\b|\bdivyadesam\b|\b108 (?:vishnu|divya)\b/], ["paadal petra", "Paadal Petra Sthalam", /\bpaadal petra\b|\bpadal petra\b|\bpaadal pet\w*\b|\b275 (?:shiva|temples)\b/],
  ["char dham", "Char Dham", /\bchar dham\b|\bchota char dham\b|\bchhota char dham\b/], ["pancha bhoota", "Pancha Bhoota Sthalam", /\bpancha ?bhoota\w*\b|\bpanchabhuta\w*\b|\bfive elements\b/],
  ["panch kedar", "Panch Kedar", /\bpanch kedar\b|\bpancha kedar\w*\b/], ["arupadai", "Arupadai Veedu", /\barupadai\w*\b|\baarupadai\w*\b|\bsix abodes\b|\bsix (?:sacred )?abodes of murugan\b/],
  ["navagraha sthalam", "Navagraha Sthalam", /\bnavagraha (?:sthalam|temples?)\b/], ["sapta puri", "Sapta Puri", /\bsapta puri\b|\bsapta ?puri\b|\bmoksha[- ]?puri\b/],
  ["pancharama", "Pancharama Kshetras", /\bpancharama\w*\b/], ["tirtha", "Tirtha (pilgrimage centre)", /\bsacred pilgrimage\b|\bpilgrimage centre\b|\bpilgrimage site\b|\bpilgrim centre\b|\btirtha\w*\b|\bkshetra\b/],
  ["state heritage", "Listed state heritage temple", /\bheritage temple\b|\bheritage structure\b|\bheritage building\b|\bheritage site\b/],
];

const TRADITIONS = [
  ["shaiva", "Shaiva", /\bshaiv\w*\b|\bsaiv\w*\b|\bshivaite\b/], ["vaishnava", "Vaishnava", /\bvaishnav\w*\b|\bvaisnav\w*\b/], ["shakta", "Shakta", /\bshakt(?:a|ism|as)\b/],
  ["smarta", "Smarta", /\bsmarta\b/], ["ganapatya", "Ganapatya", /\bganapaty\w*\b/], ["kaumaram", "Kaumaram", /\bkaumaram\b|\bkaumara\b/], ["saura", "Saura", /\bsaura\b/],
  ["pancharatra", "Pancharatra Agama", /\bpancharatr\w*\b|\bpancharathr\w*\b/], ["vaikhanasa", "Vaikhanasa Agama", /\bvaikhanas\w*\b|\bvaikhanasa\b/],
  ["shaiva siddhanta", "Shaiva Siddhanta", /\bshaiva siddhanta\b|\bsaiva siddhanta\b/], ["kashmir shaivism", "Kashmir Shaivism", /\bkashmir shaiv\w*\b|\btrika\b/],
  ["lingayat", "Lingayat / Veerashaiva", /\blingayat\w*\b|\bveerashaiv\w*\b|\bvirashaiv\w*\b/], ["madhva", "Madhva (Dvaita)", /\bmadhva\w*\b|\bdvaita\b|\bmadhvacharya\b/],
  ["sri vaishnava", "Sri Vaishnava", /\bsri vaishnav\w*\b|\bvishishtadvaita\b|\bramanuja\w*\b/], ["advaita", "Advaita", /\badvaita\b|\badi shankara\w*\b|\bshankaracharya\b|\bsringeri\b/],
  ["tantra", "Tantric tradition", /\btantr\w*\b/], ["agama", "Agama worship", /\bagama\w*\b/], ["vedic", "Vedic worship", /\bvedic\b/], ["bhakti", "Bhakti tradition", /\bbhakti\b/],
];

const RIVERS = /\b(ganga|ganges|yamuna|godavari|kaveri|cauvery|narmada|tungabhadra|brahmaputra|mahanadi|periyar|vaigai|tamiraparani|thamirabarani|pennar|sabarmati|gomti|sarayu|shipra|kshipra|bhagirathi|alaknanda|mandakini|pampa|bharathapuzha|krishna river|river krishna|palar|tapti|tapi|chambal|beas|sutlej|ghaggar|sone|son river|bhima)\b/g;
const STATE_WORDS = /^(the|in|at|of|a|an|located|situated|near|and|is)$/i;

// ---------------------------------------------------------------- profile
const DIM_IDS = ["deity", "dynasty", "tradition", "mythology", "architecture", "festival", "jatra", "heritage", "region", "period"];

function textOf(temple) {
  const m = temple.metadata || {};
  const d = temple.discovery_metadata || {};
  const flat = (...items) => items.flat(Infinity).filter((x) => typeof x === "string" && x.trim());
  return {
    name: flat(temple.name, temple.official_name, temple.local_name).join(" . "),
    lead: flat(String(temple.description || "").slice(0, 600)).join(" "),
    // Facts the catalogue itself recorded about the temple (strongest evidence).
    recorded: flat(
      temple.main_deity, temple.architectural_style, temple.historical_period, temple.religious_tradition, temple.temple_category,
      m.identity?.principal_deity, m.identity?.secondary_deities, m.identity?.religious_tradition, m.identity?.temple_category,
      m.religious?.consort_deity, m.religious?.associated_divine_figures, m.religious?.agama_tradition, m.religious?.worship_tradition,
      m.architecture?.architectural_style, m.architecture?.main_sanctum_type, m.architecture?.vimana_type, m.architecture?.pillar_carving_style,
      m.architecture?.sculptural_themes, m.architecture?.decorative_motifs, m.architecture?.construction_material, m.architecture?.materials,
      m.history?.original_dynasty, m.history?.major_ruling_dynasties, m.history?.patron_kings, m.history?.historical_period, m.history?.foundation_date,
      m.mythology?.associated_puranas, m.mythology?.associated_sages, m.mythology?.sacred_place_names,
      m.festivals?.major_annual_festivals, m.festivals?.festival_calendar, m.festivals?.jatra_names,
      m.conservation?.heritage_designation, m.conservation?.protected_monument_status,
      d.associated_deities, d.associated_dynasties, d.festivals, temple.materials, temple.construction_material,
    ).join(" . "),
    body: flat(temple.description, temple.history, temple.architecture_summary, temple.cultural_significance).join(" . "),
  };
}

function put(map, key, label, w = 1) {
  if (!key || key.length < 2 || GENERIC.has(key)) return;
  const prev = map.get(key);
  if (!prev || prev.w < w) map.set(key, { label, w });
}
function scan(map, table, text, w = 1, transform) {
  if (!text) return;
  for (const [key, label, re, extra] of table) {
    if (re.test(text)) {
      put(map, key, label, w);
      if (transform) transform(key);
    }
  }
}
function periodKeys(map, raw) {
  const centuries = new Set();
  for (const m of raw.matchAll(/(\d{1,2})(?:st|nd|rd|th)[\s-]+century(?:\s+(BCE|BC|CE|AD))?/gi)) {
    const n = Number(m[1]);
    if (n >= 1 && n <= 21) centuries.add(/BC/i.test(m[2] || "") ? -n : n);
  }
  for (const m of raw.matchAll(/\b(\d{3,4})\s*(?:CE|C\.E\.|AD|A\.D\.)\b/gi)) {
    const y = Number(m[1]); if (y >= 100 && y <= 2030) centuries.add(Math.ceil(y / 100));
  }
  for (const m of raw.matchAll(/\b(?:built|constructed|founded|established|erected|consecrated|rebuilt|dating(?: back)? to|dates? (?:back )?to|since|in the year)\s+(?:in\s+)?(?:the\s+)?(?:year\s+)?(\d{3,4})\b/gi)) {
    const y = Number(m[1]); if (y >= 400 && y <= 2030) centuries.add(Math.ceil(y / 100));
  }
  for (const c of centuries) {
    const label = c < 0 ? `${ordinal(-c)} century BCE` : `${ordinal(c)} century`;
    put(map, norm(label), label, 1);
    const n = Math.abs(c);
    const era = c < 0 ? "Ancient (BCE)" : n <= 5 ? "Ancient (before 6th century)" : n <= 10 ? "Early medieval (6th–10th century)"
      : n <= 15 ? "Medieval (11th–15th century)" : n <= 18 ? "Late medieval (16th–18th century)" : "Modern (19th century onward)";
    put(map, norm(era), era, 0.5);
  }
}

const cache = new Map();

export function profileOf(temple) {
  const sig = [temple.id, temple.name, temple.main_deity, temple.state, temple.latitude, temple.longitude,
    String(temple.description || "").length, String(temple.history || "").length,
    temple.architectural_style, temple.historical_period, (temple.festivals || []).length, (temple.jatras || []).length,
    JSON.stringify(temple.metadata || {}).length].join("|");
  const hit = cache.get(temple.id);
  if (hit && hit.sig === sig) return hit.profile;

  const profile = {};
  for (const id of DIM_IDS) profile[id] = new Map();
  profile.material = new Map();
  const t = textOf(temple);
  const nName = norm(t.name), nLead = norm(t.lead), nRec = norm(t.recorded), nBody = norm(t.body);

  // Deity: temple's own name and recorded fields are strong; the opening sentence of the description
  // counts too ("... dedicated to Murugan ..."). Later body text is NOT used (it mentions other gods).
  const addDeity = (text, w) => {
    for (const [key, label, re] of DEITIES) {
      if (key === "vishnu" && !/\b(vishnu|visnu|perumal|narayan\w*|hari|madhav\w*|keshav\w*|vaikunt\w*|padmanabh\w*|ranganath\w*|achyut\w*|janardan\w*)\b/.test(text)
        && !/\b(krishn|rama|narasimh|narsimh|venkat|balaji|srinivas|jagannath|vithal|govind|gopal|thiruvengad|raghunath|ramachandra|kodanda|sri ram)/.test(text)) continue;
      if (re.test(text)) {
        put(profile.deity, key, label, w);
        if (ALSO_VISHNU.has(key)) put(profile.deity, "vishnu", "Vishnu", w);
        const trad = DEITY_TRADITION[key]; if (trad) put(profile.tradition, norm(trad), trad, 0.8);
      }
    }
  };
  addDeity(nName, 1); addDeity(nRec, 1); addDeity(nLead, 0.8);
  // Rama / Krishna overlap with the broad Vishnu pattern only when their own regexes fire.
  if (!profile.deity.has("krishna")) {/* nothing */}

  // Dynasty / architecture / festival / mythology / heritage / tradition from recorded facts + all prose.
  for (const [text, w] of [[nRec, 1], [nBody, 0.8], [nName, 0.6]]) {
    scan(profile.dynasty, DYNASTIES, text, w);
    scan(profile.architecture, STYLES, text, w);
    scan(profile.material, MATERIALS, text, w);
    scan(profile.festival, FESTIVALS, text, w);
    scan(profile.mythology, MYTHOLOGY, text, w);
    scan(profile.heritage, HERITAGE, text, w);
    scan(profile.tradition, TRADITIONS, text, w);
  }
  for (const [k, v] of profile.material) put(profile.architecture, `material ${k}`, `${v.label} construction`, v.w * 0.8);

  // Raw recorded values (e.g. "Dravidian — Chola", "Shaiva") also count after splitting.
  const recordedRaw = [temple.architectural_style, temple.religious_tradition, temple.temple_category,
    temple.metadata?.architecture?.architectural_style, temple.metadata?.identity?.religious_tradition]
    .flat(Infinity).filter((x) => typeof x === "string");
  for (const raw of recordedRaw) {
    for (const part of raw.split(/[,;|\/–—&]|\band\b/gi)) {
      const label = part.trim(); const key = norm(label);
      if (key.length < 3 || GENERIC.has(key) || /\bhindu temple\b/.test(key)) continue;
      const dim = raw === temple.architectural_style || raw === temple.metadata?.architecture?.architectural_style ? profile.architecture : profile.tradition;
      put(dim, key, title(label), 0.9);
    }
  }

  // Festivals / Jatras recorded in the database.
  for (const f of temple.festivals || []) put(profile.festival, norm(f.canonical_name), f.canonical_name, 1);
  for (const j of temple.jatras || []) put(profile.jatra, norm(j.canonical_name), j.canonical_name, 1);
  if (/\bjatra\b/.test(nBody)) put(profile.jatra, "jatra tradition", "Jatra tradition", 0.5);

  // Region: state, city, district (from prose), rivers.
  if (temple.state) put(profile.region, `state ${norm(temple.state)}`, temple.state, 1);
  if (temple.city && norm(temple.city) !== norm(temple.state || "")) put(profile.region, `place ${norm(temple.city)}`, temple.city, 2);
  const rawText = [t.lead, t.body].join(" . ");
  for (const m of rawText.matchAll(/\b([A-Z][a-z]+)(?:\s([A-Z][a-z]+))?\s+(?:district|taluk|taluka)\b/g)) {
    let first = m[1], second = m[2];
    if (STATE_WORDS.test(first) && second) { first = second; second = undefined; }
    if (STATE_WORDS.test(first)) continue;
    const nm = second && !STATE_WORDS.test(second) ? `${first} ${second}` : first;
    put(profile.region, `district ${norm(nm)}`, `${nm} district`, 2.5);
  }
  const riverText = nBody.replace(/\b(eastern|western) ganga\b/g, " ").replace(/\bgupta\b/g, " ");
  for (const m of riverText.matchAll(RIVERS)) {
    const nm = m[1].replace(/ river|river /g, "");
    put(profile.region, `river ${nm}`, `${title(nm)} river`, 1.5);
  }

  // Period.
  periodKeys(profile.period, [t.recorded, t.body].join(" . "));
  if (temple.unesco) put(profile.heritage, "unesco", "UNESCO World Heritage Site", 1);

  cache.set(temple.id, { sig, profile });
  return profile;
}

export const firstLabel = (profile, dim, fallback) => {
  const entries = [...(profile[dim] || new Map()).values()].sort((a, b) => b.w - a.w);
  return entries[0]?.label || fallback;
};

// ---------------------------------------------------------------- scoring
export const DIMENSIONS = [
  { id: "deity", label: "Deity", weight: 4 },
  { id: "dynasty", label: "Dynasty & patrons", weight: 3 },
  { id: "tradition", label: "Religious tradition", weight: 2.5 },
  { id: "mythology", label: "Mythology & Puranas", weight: 3 },
  { id: "architecture", label: "Architecture", weight: 2 },
  { id: "festival", label: "Festivals", weight: 2 },
  { id: "jatra", label: "Jatras", weight: 2 },
  { id: "heritage", label: "Heritage status", weight: 2 },
  { id: "region", label: "Region & geography", weight: 1.5 },
  { id: "period", label: "Historical period", weight: 1 },
];

export const strengthOf = (score) => (score >= 10 ? "strong" : score >= 5 ? "moderate" : score > 0 ? "light" : "none");

export function haversineKm(a, b) {
  const la1 = Number(a.latitude), lo1 = Number(a.longitude), la2 = Number(b.latitude), lo2 = Number(b.longitude);
  if (![la1, lo1, la2, lo2].every(Number.isFinite)) return null;
  if ((la1 === 0 && lo1 === 0) || (la2 === 0 && lo2 === 0)) return null;
  const R = 6371, rad = (x) => (x * Math.PI) / 180;
  const dLa = rad(la2 - la1), dLo = rad(lo2 - lo1);
  const h = Math.sin(dLa / 2) ** 2 + Math.cos(rad(la1)) * Math.cos(rad(la2)) * Math.sin(dLo / 2) ** 2;
  return 2 * R * Math.asin(Math.min(1, Math.sqrt(h)));
}

/** Document frequency of every (dimension, key) so common facts count for less than rare ones. */
export function buildStats(profiles) {
  const df = new Map();
  for (const p of profiles) {
    for (const id of DIM_IDS) for (const k of p[id].keys()) df.set(`${id}|${k}`, (df.get(`${id}|${k}`) || 0) + 1);
  }
  return { df, n: Math.max(profiles.length, 1) };
}

export function scorePair(pa, pb, distKm, stats) {
  const rarity = (id, k) => 0.5 + 0.5 * (1 - Math.min(1, ((stats?.df.get(`${id}|${k}`) || 1) - 1) / stats.n));
  let score = 0;
  const dimensions = DIMENSIONS.map((dim) => {
    const A = pa[dim.id], B = pb[dim.id];
    const sharedKeys = [...A.keys()].filter((k) => B.has(k));
    const items = sharedKeys.map((k) => ({
      key: k, label: A.get(k).label, v: Math.min(A.get(k).w, B.get(k).w) * (stats ? rarity(dim.id, k) : 1),
    }));
    if (dim.id === "region" && distKm !== null && distKm !== undefined) {
      if (distKm <= 30) items.push({ key: "near30", label: `Nearby — about ${Math.max(1, Math.round(distKm))} km apart`, v: 2.5 });
      else if (distKm <= 100) items.push({ key: "near100", label: `Same area — about ${Math.round(distKm)} km apart`, v: 1.5 });
      else if (distKm <= 250 && !sharedKeys.some((k) => k.startsWith("state "))) items.push({ key: "near250", label: `Same region — about ${Math.round(distKm)} km apart`, v: 0.5 });
    }
    items.sort((x, y) => y.v - x.v);
    score += dim.weight * items.slice(0, 3).reduce((s, i) => s + i.v, 0);
    const covered = new Set(sharedKeys);
    return {
      ...dim,
      shared: items.map((i) => i.label),
      only_a: [...A.entries()].filter(([k]) => !covered.has(k)).sort((x, y) => y[1].w - x[1].w).slice(0, 6).map(([, v]) => v.label),
      only_b: [...B.entries()].filter(([k]) => !covered.has(k)).sort((x, y) => y[1].w - x[1].w).slice(0, 6).map(([, v]) => v.label),
      has_data: A.size > 0 || B.size > 0,
    };
  });
  return { dimensions, score: Math.round(score * 10) / 10 };
}

const REASON_TYPE = {
  deity: "deity", dynasty: "dynasty", architecture: "architecture", period: "period", region: "region",
  tradition: "story", mythology: "story", festival: "story", jatra: "story", heritage: "story",
};
const REASON_LABEL = {
  deity: "Shared deity", dynasty: "Shared dynasty or patrons", architecture: "Shared architecture",
  period: "Related historical period", region: "Same region", tradition: "Shared religious tradition",
  mythology: "Shared legends & Puranas", festival: "Shared festivals", jatra: "Shared Jatra",
  heritage: "Shared heritage status",
};

/** All temples -> for each temple, its strongest connections (never empty when coordinates or a state exist). */
export function buildConnections(temples, { perTemple = 40 } = {}) {
  const profiles = temples.map(profileOf);
  const stats = buildStats(profiles);
  const N = temples.length;
  const buckets = temples.map(() => []);
  for (let i = 0; i < N; i++) {
    for (let j = i + 1; j < N; j++) {
      const dist = haversineKm(temples[i], temples[j]);
      const { dimensions, score } = scorePair(profiles[i], profiles[j], dist, stats);
      if (score <= 0) continue;
      const reasons = dimensions.filter((d) => d.shared.length).sort((a, b) => b.weight - a.weight).map((d) => ({
        type: REASON_TYPE[d.id], dimension: d.id, label: REASON_LABEL[d.id],
        detail: d.shared.slice(0, 3).join(", "), matched_values: d.shared,
      }));
      buckets[i].push({ temple: temples[j], reasons, score, distance_km: dist });
      buckets[j].push({ temple: temples[i], reasons, score, distance_km: dist });
    }
  }
  return temples.map((temple, i) => {
    let connections = buckets[i].sort((a, b) => b.score - a.score || a.temple.name.localeCompare(b.temple.name));
    // Keep the best overall, but make sure each category (deity / architecture / traditions...) keeps its best matches too.
    const keep = new Set(connections.slice(0, perTemple));
    for (const type of ["deity", "architecture", "story", "dynasty", "period", "region"]) {
      connections.filter((c) => c.reasons.some((r) => r.type === type)).slice(0, 12).forEach((c) => keep.add(c));
    }
    connections = connections.filter((c) => keep.has(c));
    if (!connections.length) {
      // Last resort: nearest recorded temples, so no page is ever blank.
      connections = temples.map((other, j) => ({ other, d: j === i ? null : haversineKm(temple, other) }))
        .filter((x) => x.d !== null).sort((a, b) => a.d - b.d).slice(0, 5)
        .map((x) => ({
          temple: x.other, score: 0.5, distance_km: x.d,
          reasons: [{ type: "region", dimension: "region", label: "Nearest recorded temple", detail: `about ${Math.round(x.d)} km away`, matched_values: [] }],
        }));
    }
    return { temple, connections };
  });
}

export function compareOne(temples, anchorIdOrSlug) {
  const A = temples.find((t) => t.id === anchorIdOrSlug || t.slug === anchorIdOrSlug);
  if (!A) return null;
  const profiles = new Map(temples.map((t) => [t.id, profileOf(t)]));
  const stats = buildStats([...profiles.values()]);
  const rows = temples.filter((t) => t.id !== A.id).map((t) => {
    const { dimensions, score } = scorePair(profiles.get(A.id), profiles.get(t.id), haversineKm(A, t), stats);
    return { temple: t, score, strength: strengthOf(score), dimensions, matched: dimensions.filter((d) => d.shared.length).sort((x, y) => y.weight - x.weight) };
  }).sort((x, y) => y.score - x.score || x.temple.name.localeCompare(y.temple.name));
  return { a: A, rows };
}
