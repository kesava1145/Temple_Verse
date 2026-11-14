-- TempleVerse content backfill
-- Run ONCE after schema.sql, seed.sql and metadata migration.
-- Uses reviewed application content modules; does not invent translations.
begin;


update public.temples set
      description='A masterpiece of Chola architecture, completed around 1010 CE. It is famed for its 66-metre granite vimana, its vast walled courtyard and the very large Shiva lingam in its sanctum.',
      history='Brihadeeswarar Temple — known in Tamil as Peruvudaiyar Kovil or Thanjai Periya Kovil — was built under the Chola emperor Raja Raja Chola I and completed around 1010 CE. The temple''s own walls carry an exceptional body of inscriptions recording endowments of land, gold and cattle, and the appointment of temple staff, musicians and dancers. It was inscribed by UNESCO in 1987 as part of the Great Living Chola Temples, and it remains an active place of worship administered today by the Tamil Nadu HR&CE department.',
      architecture_summary='The temple is built almost entirely of granite on a scale unmatched in its period. Its pyramidal vimana rises in thirteen diminishing storeys above the sanctum, crowned by a large monolithic capstone. The plan is strictly axial: an outer gateway, an inner gateway, an open Nandi pavilion, a long pillared hall and the sanctum, all enclosed by a rectangular walled courtyard lined with cloistered corridors.',
      cultural_significance='The temple is a living record of Chola state religion, economy and the performing arts. Its inscriptions name the musicians and dancers attached to it, making it one of the most important sources for the cultural history of medieval South India. It remains central to Thanjavur''s religious calendar.',
      image_url='https://images.pexels.com/photos/37862810/pexels-photo-37862810.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200',
      image_credit='Roman Saienko / Pexels — Brihadeeswarar Temple, Thanjavur'
    where slug='brihadeeswarar';

update public.temples set
      description='A vast temple complex at the heart of Madurai, enclosing fourteen towered gateways, long pillared halls, a sacred tank and the twin shrines of the goddess Meenakshi and her consort Sundareswarar.',
      history='Madurai is one of the oldest continuously inhabited cities in India, and its temple is deeply embedded in Tamil literature — the classical epic Silappatikaram is set in the city. The complex as it stands today was largely built and expanded between the 16th and 17th centuries under the Nayak rulers of Madurai, who added most of its gopurams and mandapas. The temple is administered by the Tamil Nadu HR&CE department and remains one of the busiest pilgrimage centres in South India.',
      architecture_summary='Unlike a single-axis temple, Meenakshi Amman is a concentric temple-city: rectangular enclosures nested within one another, each pierced by gateway towers. Fourteen gopurams rise above the walls, the tallest on the south side. Within, long colonnaded halls connect the two principal shrines, and a stepped tank forms the ceremonial centre of the complex.',
      cultural_significance='The temple gives Madurai its identity. Its annual Chithirai festival, which enacts the marriage of Meenakshi and Sundareswarar, draws immense crowds and shapes the city''s calendar. The complex has also long functioned as a centre for Tamil music, dance and scholarship.',
      image_url='https://images.pexels.com/photos/10271157/pexels-photo-10271157.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200',
      image_credit='Sharath G. / Pexels — Meenakshi Temple gopura, Madurai'
    where slug='meenakshi';

update public.temples set
      description='A 13th-century temple conceived as the colossal chariot of the sun god — with twenty-four carved stone wheels and teams of horses — and covered from base to roof in sculpture.',
      history='The Sun Temple at Konark was built in the mid-13th century under King Narasimhadeva I of the Eastern Ganga dynasty. Its principal sanctuary tower has collapsed, but the jagamohana (audience hall) survives, along with the vast sculpted chariot platform. The site was inscribed by UNESCO as a World Heritage Site in 1984 and is conserved by the Archaeological Survey of India.',
      architecture_summary='The temple was laid out as a chariot: the plinth carries twenty-four richly carved wheels along its sides, and teams of horses were placed at the front. Behind the entrance stand a detached hall and the great jagamohana with its three-tiered pyramidal roof, and beyond it the ruined base of the sanctuary tower. Almost every surface is carved — with deities, musicians, dancers, animals, and scenes of everyday life.',
      cultural_significance='Konark is one of the supreme achievements of Indian temple sculpture and a defining monument of Odishan identity; its wheel is used as a national emblem of Indian heritage. The annual Konark Dance Festival, held before the monument, continues its long association with the performing arts.',
      image_url='https://images.pexels.com/photos/31598958/pexels-photo-31598958.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200',
      image_credit='Rajneesh Narula / Pexels — carved wheel, Konark Sun Temple'
    where slug='konark';

update public.temples set
      description='A hill temple in the Tirumala range dedicated to Venkateswara, a form of Vishnu. It is among the most visited pilgrimage destinations in the world and is administered by Tirumala Tirupati Devasthanams.',
      history='The temple stands on the Tirumala hills above Tirupati. Its walls and copper plates preserve a long series of inscriptions and endowments beginning in the early medieval period, recording gifts from Pallava, Chola, Pandya and — most extensively — Vijayanagara rulers. Krishnadevaraya of Vijayanagara was among its most celebrated patrons in the early 16th century. Since 1933 the temple and its associated institutions have been administered by Tirumala Tirupati Devasthanams (TTD).',
      architecture_summary='The temple follows a Dravidian plan of concentric enclosures. Pilgrims pass through the main gateway tower into an outer circumambulatory path, then an inner one, before reaching the sanctum. The sanctum is crowned by the gilded vimana known as Ananda Nilayam. Two successive doorways — a silver one and a gilded one — mark the final approach to the deity.',
      cultural_significance='Tirumala is one of the largest centres of pilgrimage anywhere in the world, receiving very large numbers of devotees daily. Its practices of hair-offering (mundan), the queue system, and the distribution of the Tirupati laddu — which holds a Geographical Indication tag — are known throughout India.',
      image_url='https://images.pexels.com/photos/28310432/pexels-photo-28310432.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200',
      image_credit='Mihran Kes / Pexels — Sri Venkateswara Temple architecture'
    where slug='tirumala';

update public.temples set
      description='An early 8th-century Pallava temple built of cut granite blocks beside the Bay of Bengal, part of the UNESCO-listed Group of Monuments at Mahabalipuram.',
      history='The Shore Temple was built in the early 8th century CE during the reign of the Pallava king Narasimhavarman II, known as Rajasimha. It marks an important transition in South Indian architecture, from the rock-cut caves and monolithic rathas of the earlier Pallava period to fully structural temples built from dressed stone. It stands within the Group of Monuments at Mahabalipuram, inscribed by UNESCO in 1984 and conserved by the Archaeological Survey of India.',
      architecture_summary='Unusually, the complex contains three shrines: two dedicated to Shiva, facing east and west, and between them a shrine housing a reclining Vishnu carved from the living rock. The tiered pyramidal towers are slender and steeply stepped, and the surrounding compound wall is topped by rows of seated bull (Nandi) figures. Centuries of sea wind have softened much of the exterior carving.',
      cultural_significance='Mahabalipuram was a port city of the Pallavas and a great workshop of stone carving whose influence spread across South and Southeast Asia. The Shore Temple is the emblem of that achievement, and the wider site — with its rathas, cave temples and giant open-air relief — is one of the most important collections of early Dravidian art anywhere.',
      image_url='https://images.pexels.com/photos/37584854/pexels-photo-37584854.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200',
      image_credit='Roman Saienko / Pexels — Shore Temple, Mahabalipuram'
    where slug='shore-temple';

update public.temple_locations l set
      story='The gateway carries the name Keralanthakan, a title associated with Raja Raja Chola I. Gateways in Chola temples were not merely doors: their names, inscriptions and sculpture announced the king''s achievements to everyone who entered.',
      architecture='A gateway of two storeys with a barrel-vaulted roof, deliberately modest in height. Because the gateways are low, the vimana beyond dominates the skyline as the visitor advances — a carefully designed sequence.',
      rituals='Processions during festivals pass along this axis. Devotees traditionally pause at the threshold before stepping into the temple precinct.',
      significance='This is the boundary between the city and the sacred enclosure — the first of a series of thresholds that structure the pilgrim''s approach to the sanctum.',
      description='The outer gateway of the temple, named after a title borne by Raja Raja Chola I. It is the first of two gateways on the temple''s east–west axis.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/37809042/pexels-photo-37809042.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Roman Saienko / Pexels — gateway architecture, Thanjavur'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='brihadeeswarar' and l.display_order=1;

update public.temple_locations l set
      story='Named directly for Raja Raja Chola I, this second gateway is richer in sculpture than the outer one. Passing through it, the visitor emerges into the full expanse of the courtyard with the vimana rising ahead.',
      architecture='The gateway is flanked by very large guardian figures (dvarapalas) carved in high relief, and its walls carry niches with sculpted deities characteristic of mature Chola work.',
      rituals='Festival chariots and processional images are carried through this gateway. It is the point at which many devotees first join their hands in greeting to the deity.',
      significance='The two gateways create a rhythm of compression and release — a narrow passage followed by an immense open court — that is central to how the temple is experienced.',
      description='The inner and more elaborately carved of the two gateways, opening directly onto the great courtyard.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/37826466/pexels-photo-37826466.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Roman Saienko / Pexels — gateway, Brihadeeswarar Temple'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='brihadeeswarar' and l.display_order=2;

update public.temple_locations l set
      story='In Shaiva tradition Nandi is the mount and foremost devotee of Shiva, always turned towards his lord. The Nandi at Thanjavur is among the largest monolithic examples in India. The pavilion sheltering it is a later addition to the Chola core.',
      architecture='A raised, open colonnaded pavilion carrying a painted ceiling. The Nandi itself is carved from a single block of stone and measures several metres in length.',
      rituals='Devotees circumambulate the Nandi and offer flowers and sacred ash. It is decorated during major festivals.',
      significance='Nandi models the attitude of the devotee: patient, attentive, and turned always toward the divine. Standing behind it aligns the visitor''s gaze directly with the sanctum.',
      description='An open pillared pavilion in the courtyard sheltering a very large monolithic Nandi, the bull, facing the sanctum.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='brihadeeswarar' and l.display_order=3;

update public.temple_locations l set
      story='The sanctum houses one of the largest Shiva lingams in any Indian temple, worshipped here as Peruvudaiyar — the Great Lord. It was consecrated around 1010 CE under Raja Raja Chola I, and the temple has remained in worship since.',
      architecture='A square chamber of massive granite blocks, set within a two-storeyed structure and surrounded by a wide circumambulatory passage. Colossal guardian figures flank the approach.',
      rituals='Worship follows a fixed daily cycle of pujas, including abhishekam — ritual bathing of the lingam with water, milk and other offerings — followed by the waving of lamps.',
      significance='Every axis of the temple converges here. The sequence of gateways, courtyard, Nandi and hall exists to prepare the visitor for this single point.',
      description='The sanctum at the heart of the temple, enshrining a very large Shiva lingam beneath the great tower.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='brihadeeswarar' and l.display_order=4;

update public.temple_locations l set
      story='For centuries these walls were known only for their later paintings. Conservation work revealed an earlier layer of Chola-period murals beneath, making this one of the most important surviving groups of medieval Indian wall painting.',
      architecture='A narrow, low passage running around the sanctum within the thickness of the walls. Its darkness protected the pigments; today access is restricted for conservation reasons.',
      rituals='The passage was built for pradakshina — circumambulation of the sanctum, performed clockwise as an act of reverence.',
      significance='The murals are a rare direct glimpse of Chola painting, an art form otherwise almost entirely lost, and they sit beneath later work that records how the temple kept changing.',
      description='A dark circumambulatory passage around the sanctum whose walls preserve rare Chola-period paintings, later overlaid with Nayak-period work.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='brihadeeswarar' and l.display_order=5;

update public.temple_locations l set
      story='When it was completed the vimana was among the tallest structures in India. A widely repeated local tradition holds that its capstone was hauled up a long earthen ramp; this account is part of local memory rather than documented record, and how the stones were raised is still discussed by historians.',
      architecture='Thirteen diminishing storeys of granite rise to an octagonal crown carrying a large monolithic capstone. The upper courses are fitted with remarkable precision, without mortar.',
      rituals='The tower is venerated as the crown of the temple and is illuminated during major festivals.',
      significance='The vimana expresses the idea of the temple as a sacred mountain — a vertical axis joining the earth to the heavens.',
      description='The pyramidal tower above the sanctum, roughly 66 metres tall and among the tallest temple towers of its kind.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/37862812/pexels-photo-37862812.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Roman Saienko / Pexels — Brihadeeswarar Temple stonework'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='brihadeeswarar' and l.display_order=6;

update public.temple_locations l set
      story='The courtyard holds several shrines built at different times. The Goddess shrine and the shrine of Chandeshvara belong to the older layers; a Subrahmanya shrine and others were added by later dynasties, so the courtyard records centuries of patronage.',
      architecture='Each is a compact shrine with its own tower — in effect a miniature of the great vimana, using the same architectural vocabulary at a smaller scale.',
      rituals='The Goddess receives special worship on Fridays and during Navaratri. In Shaiva practice Chandeshvara is honoured at the close of the main worship.',
      significance='Together the shrines present the temple as a complete sacred household, with the principal deity, the Goddess and the attendant figures each in their place.',
      description='Smaller shrines within the courtyard, including those of the Goddess (Brihannayaki) and of Chandeshvara, together with later additions.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='brihadeeswarar' and l.display_order=7;

update public.temple_locations l set
      story='The inscriptions cut into the courtyard walls are the temple''s archive. They record grants of land and gold, the names of villages, and the appointment of temple servants, musicians and dancers — an extraordinary window into the Chola economy.',
      architecture='A rectangular enclosure of high granite walls, roughly 240 by 120 metres, with continuous colonnaded cloisters along the inner face and rows of small lingams set within them.',
      rituals='Circumambulating the entire courtyard is a traditional act of devotion, observed particularly during the Tamil month of Margazhi and on festival days.',
      significance='The prakara is the temple''s civic space, where worship, festival, music and community life have met for a thousand years.',
      description='The vast walled courtyard enclosing the temple, lined on all sides by cloistered pillared corridors.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/5138790/pexels-photo-5138790.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Aadhithyan Pandian / Pexels — the walled courtyard'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='brihadeeswarar' and l.display_order=8;

update public.temple_locations l set
      story='The gopurams are covered with thousands of brightly painted stucco figures — deities, guardians, dancers and scenes from the Puranas — repainted at each consecration ceremony. Together they form an enormous open-air narrative visible from across the city.',
      architecture='Each gopuram is a trapezoidal tower rising in diminishing storeys over a stone base, built up in brick and stucco above. The density of figures is far greater than in earlier Dravidian gateways.',
      rituals='The temple gates are opened each morning with ceremony. The towers are illuminated during festivals, and they are refreshed with new paint at the periodic kumbhabhishekam.',
      significance='The gopuram is the first darshan — the first sight of the sacred — and it announces the temple-city long before a visitor reaches its walls.',
      description='Fourteen towered gateways rise above the temple walls; the southern tower, roughly 52 metres high, is the tallest.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/10271157/pexels-photo-10271157.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Sharath G. / Pexels — Meenakshi Temple gopura, Madurai'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='meenakshi' and l.display_order=1;

update public.temple_locations l set
      story='This is the first hall most pilgrims enter. Its pillars carry sculptures of eight forms of Shakti, together with panels illustrating episodes associated with the goddess of Madurai — an introduction, in stone, to the temple''s story.',
      architecture='A Nayak-period colonnaded hall with sculpted piers, forming a transition between the bustle of the street and the enclosed spaces beyond.',
      rituals='Pilgrims pass through this hall on the way to the shrines; vendors of flowers and offerings traditionally occupy the approach outside.',
      significance='The hall introduces the theological heart of the temple: this is a place where the goddess, not her consort, is the principal deity.',
      description='The pillared hall just inside the eastern entrance, named for its sculptures of eight forms of the goddess.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='meenakshi' and l.display_order=2;

update public.temple_locations l set
      story='The hall is traditionally associated with Ariyanatha Mudaliar, a minister of the Nayak court, whose equestrian sculpture stands near its entrance. Visitors have long been struck by its slender ''musical pillars'', which sound different notes when struck.',
      architecture='Rows of carved piers — commonly counted as 985 — bearing figures of deities, warriors, dancers and rearing yali creatures. Part of the hall today houses a temple art museum.',
      rituals='The hall is used for temple ceremonies and for music and dance performances, continuing a long association between the temple and the performing arts.',
      significance='It shows the temple as more than a place of worship: it was also an academy of sculpture, music and dance.',
      description='A 16th-century hall celebrated for its forest of intricately carved pillars, including columns that ring with musical notes.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='meenakshi' and l.display_order=3;

update public.temple_locations l set
      story='According to the temple''s traditional accounts, Meenakshi was born to the ruler of Madurai and later married Shiva, who came to the city as Sundareswarar. The goddess is depicted green in colour with a parrot, and she — not her consort — is the temple''s principal deity, which is unusual among major Shaiva temples.',
      architecture='The shrine stands within its own enclosure, its tower gilded. The surrounding halls include some of the older carved pillars in the complex.',
      rituals='Daily worship includes abhishekam and alankaram, the ceremonial adorning of the image. Fridays are especially associated with the goddess.',
      significance='Meenakshi is understood as the sovereign of Madurai. The city''s festivals, and much of its civic identity, are organised around her.',
      description='The sanctum of the goddess Meenakshi, the presiding deity of Madurai and the focus of the whole complex.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='meenakshi' and l.display_order=4;

update public.temple_locations l set
      story='In the temple''s traditional accounts, Shiva came to Madurai as Sundareswarar to marry Meenakshi. Within this part of the complex stands the Kanaka Sabha, a hall associated with the dance of Shiva.',
      architecture='The shrine has its own gilded tower and enclosure, entered through a series of halls whose pillars carry finely carved figures.',
      rituals='Worship follows the Shaiva daily cycle, ending with the ceremonial procession in which the deity is carried to the goddess''s chamber for the night.',
      significance='The two shrines together express the temple''s central theme — the union of the goddess and her consort — which is re-enacted publicly each year in the Chithirai festival.',
      description='The shrine of Sundareswarar — ''the beautiful lord'' — the form in which Shiva is worshipped at Madurai.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='meenakshi' and l.display_order=5;

update public.temple_locations l set
      story='Every Friday the processional images of Meenakshi and Sundareswarar are brought to this hall and placed on a swing, while musicians perform. The neighbouring Kilikoottu Mandapam takes its name from the parrot cages once kept there — the parrot being the goddess''s emblem.',
      architecture='A columned hall beside the sacred tank, with a golden swing suspended at its centre and painted ceiling panels above.',
      rituals='The weekly swing ceremony is one of the temple''s most attended regular observances, open to devotees who gather around the hall.',
      significance='The ritual expresses an intimate, domestic register of devotion: the deities are not only cosmic powers but a divine couple who are honoured, entertained and rested.',
      description='The hall containing the ceremonial swing on which the images of the deities are placed each Friday evening.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='meenakshi' and l.display_order=6;

update public.temple_locations l set
      story='The tank''s name means ''tank of the golden lotus''. Tradition links it to the literary academies of ancient Madurai, and holds that the marriage of Meenakshi and Sundareswarar took place at its edge. These are traditional accounts rather than documented events.',
      architecture='A rectangular stepped tank lined with stone, ringed by colonnaded corridors whose ceilings carry painted panels. The gopurams are reflected in its surface.',
      rituals='Devotees traditionally take a ritual dip before darshan. The surrounding corridors are used for rest, prayer and festival gatherings.',
      significance='Water marks the boundary of purification in temple practice; the tank sets the pilgrim''s inner preparation at the literal centre of the complex.',
      description='The stepped sacred tank at the centre of the complex, surrounded by pillared corridors.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='meenakshi' and l.display_order=7;

update public.temple_locations l set
      story='During the Chithirai festival, the marriage of Meenakshi and Sundareswarar is celebrated here before enormous crowds, and the deities are then carried in procession through the streets of Madurai. The festival is among the largest in Tamil Nadu.',
      architecture='A Nayak-period hall with carved piers and painted ceilings depicting the marriage and the rulers who endowed the temple.',
      rituals='The hall is prepared each year for the marriage ceremony; at other times it serves temple functions and gatherings.',
      significance='The festival binds the temple to the city: the divine marriage is treated as a civic event in which the whole of Madurai participates.',
      description='The ceremonial hall in which the annual re-enactment of the divine marriage is prepared and celebrated.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='meenakshi' and l.display_order=8;

update public.temple_locations l set
      story='Two great lions, each shown above an elephant, guard the eastern approach. The motif of a lion over an elephant is common in Odishan temple sculpture and is traditionally read as the triumph of power over pride.',
      architecture='Massive freestanding sculptures carved from local stone, framing the route from the entrance towards the temple platform.',
      rituals='The temple no longer holds regular worship, but the eastern approach remains the way visitors are intended to arrive — with the whole monument opening before them.',
      significance='The gate sets the scale of what follows: the visitor is meant to feel small before the chariot of the sun.',
      description='The eastern approach to the temple, marked by large sculpted lions set above crouching elephants.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='konark' and l.display_order=1;

update public.temple_locations l set
      story='Standing apart from the main structure, this hall completes the standard sequence of an Odishan temple. Its retaining walls carry lively carvings of musicians, dancers and everyday scenes.',
      architecture='A raised, open platform reached by steps on each side, with rows of carved pillars and richly sculpted mouldings around the base.',
      rituals='In an active Odishan temple, the bhoga mandapa is where food offerings to the deity are arranged before being presented.',
      significance='The hall shows that Konark was planned as a complete, functioning temple, not merely a monument of sculpture.',
      description='A detached pillared platform near the entrance, understood as the hall in which food offerings were prepared and presented.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='konark' and l.display_order=2;

update public.temple_locations l set
      story='This platform served as the temple''s stage. Its walls preserve hundreds of figures of dancers and drummers, giving an unusually detailed picture of the performing arts of 13th-century Odisha.',
      architecture='A raised square platform approached by stairways, with sculpted friezes running continuously around its base and the stumps of carved pillars at the corners.',
      rituals='Dance and music were offered as forms of worship. The tradition is echoed today by the Konark Dance Festival held annually before the monument.',
      significance='It records a world in which artistic performance was itself an act of devotion, not entertainment placed alongside it.',
      description='The roofless pillared platform in front of the main structure, its walls covered with figures of musicians and dancers.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/37437098/pexels-photo-37437098.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Krishnendu Biswas / Pexels — sculptural bands at Konark'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='konark' and l.display_order=3;

update public.temple_locations l set
      story='The whole temple was conceived as a chariot drawn by horses. Each wheel is about three metres across, carved with spokes, a decorated hub and medallions between the spokes. Visitors and guides have long noted that the wheels can be read as sundials by the shadow the spokes cast.',
      architecture='Twelve pairs of wheels are set along the plinth, richly ornamented with foliage, beadwork and figurative medallions. Of the horses, a small number survive.',
      rituals='The temple faces east so that the rising sun reaches the sanctuary — the orientation is itself an act of worship built into the plan.',
      significance='The wheel has become an emblem of Indian heritage. It expresses the temple''s central idea: the movement of the sun, and therefore of time itself, carved in stone.',
      description='Twenty-four elaborately carved wheels line the temple platform, with teams of horses at the front — the temple is the sun god''s chariot.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/37437100/pexels-photo-37437100.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Krishnendu Biswas / Pexels — carved chariot wheel, Konark'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='konark' and l.display_order=4;

update public.temple_locations l set
      story='The jagamohana was the assembly hall in front of the sanctuary. It is the one major element of the temple to survive largely intact; in the early twentieth century its interior was filled with sand and stone to prevent collapse, and it has remained sealed since.',
      architecture='A tall hall whose roof rises in three receding tiers, each edged with rows of sculpted figures of musicians. Large images of Surya stand in niches on three sides.',
      rituals='Regular worship no longer takes place at the monument, though the site remains meaningful to local devotees and visitors.',
      significance='The hall is the surviving measure of the temple''s ambition — and its sealed interior is a reminder that conservation sometimes means choosing what cannot be seen.',
      description='The great pyramidal hall that still stands — the largest surviving structure of the temple.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/12871861/pexels-photo-12871861.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Suman Sutradhar / Pexels — the jagamohana at Konark'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='konark' and l.display_order=5;

update public.temple_locations l set
      story='The navagraha slab shows the nine graha deities seated in a row. Once part of the temple''s architecture, it was later moved for protection and is now displayed within the site.',
      architecture='A single long slab of chlorite, carved in deep relief with nine seated figures, each with its distinguishing attributes.',
      rituals='The nine grahas are widely propitiated in Indian ritual practice, and panels of this kind were placed where worshippers would pass beneath them.',
      significance='The panel connects the temple''s solar theme to the wider astronomical symbolism that runs through its design.',
      description='A large carved slab depicting the nine planetary deities, originally set above a doorway of the temple.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/37437099/pexels-photo-37437099.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Krishnendu Biswas / Pexels — carved figures at Konark'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='konark' and l.display_order=6;

update public.temple_locations l set
      story='The sanctuary tower once rose high above the jagamohana. It has collapsed, and the reasons are still debated by historians — structural failure, damage, and the removal of stone have all been proposed. What survives is the platform and the lower walls.',
      architecture='A square sanctuary built on the Kalinga deul plan, designed for a curvilinear tower. The surviving walls carry large images of Surya in the cardinal niches.',
      rituals='Worship of the sun follows the daily cycle; sunrise here has always been the significant moment.',
      significance='Even ruined, the sanctuary does what it was built to do — it draws the eye upward, from the ground toward the sky.',
      description='The base of the sanctuary tower that once housed the image of Surya; the tower itself no longer stands.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='konark' and l.display_order=7;

update public.temple_locations l set
      story='A smaller ruined temple within the enclosure is conventionally called the Mayadevi Temple, though its original dedication is uncertain and debated among scholars. Sculptures recovered from the site are displayed in the Archaeological Survey of India''s museum nearby.',
      architecture='The smaller temple follows the same Kalinga plan at reduced scale. Its style has led some scholars to suggest it may be earlier than the main temple.',
      rituals='The site is a protected monument rather than an active temple. The Konark Dance Festival is held here each year.',
      significance='The grounds show that Konark was a complete sacred precinct — a planned complex, of which the famous chariot is only the centrepiece.',
      description='The wider enclosure containing subsidiary structures, including the ruined shrine known as the Mayadevi Temple.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/32888176/pexels-photo-32888176.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Prabin Kumar / Pexels — the Sun Temple complex'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='konark' and l.display_order=8;

update public.temple_locations l set
      story='The great gateway marks the entry into the temple proper after the long ascent of the hills. For most pilgrims this is the emotional beginning of the visit, often after many hours in the queue complexes outside.',
      architecture='A Dravidian gateway tower over a stone base, its upper storeys carrying sculpted figures. It pierces the outer enclosure wall of the temple.',
      rituals='Pilgrims traditionally offer their first salutation here. Many complete the ascent of the hill on foot as a vow.',
      significance='The gateway divides the ordinary world from the temple; the scale of the crowds passing through it makes it one of the busiest thresholds in the world.',
      description='The principal gateway tower through which pilgrims enter the temple, also known as the Padikavali.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/36771235/pexels-photo-36771235.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Vijay Richhiya / Pexels — the temple at Tirupati'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='tirumala' and l.display_order=1;

update public.temple_locations l set
      story='The outer circuit contains a number of mandapas built at different periods, including halls associated with Vijayanagara patronage. Inscriptions on these structures record the gifts that sustained the temple over centuries.',
      architecture='A broad open passage running around the inner enclosure, bordered by pillared halls whose columns carry sculpted figures.',
      rituals='Circumambulation is performed clockwise. Certain festival processions move along this circuit.',
      significance='The passage preserves the temple''s institutional memory: its inscriptions are the record of who supported the shrine and when.',
      description='The outer circumambulatory passage between the first and second enclosure walls, lined with halls and shrines.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='tirumala' and l.display_order=2;

update public.temple_locations l set
      story='The flagstaff stands in line with the deity. At the start of the annual Brahmotsavam festival, a flag is hoisted here in a ceremony that formally opens the celebrations.',
      architecture='A tall metal-clad post set on a stone base, aligned on the temple''s principal axis together with the bali pitha (offering pedestal).',
      rituals='Devotees prostrate before the flagstaff on entering. The flag-hoisting ceremony marks the beginning of the temple''s great annual festival.',
      significance='The flagstaff is the temple''s signal to the world that a festival is under way — a public, visible act of invitation.',
      description='The gilded flagstaff standing on the temple''s central axis, directly before the sanctum.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='tirumala' and l.display_order=3;

update public.temple_locations l set
      story='Pilgrims pass through two successive doorways on the final approach — a silver one and then this gilded one. Its plates carry figures associated with Vishnu, and passing through it is, for many, the most charged moment of the whole pilgrimage.',
      architecture='A doorway faced with sheets of gilded metal worked in relief, set within the inner enclosure that surrounds the sanctum.',
      rituals='The doorway is opened and closed according to the fixed daily schedule of worship, which begins before dawn with the Suprabhatam.',
      significance='The sequence of thresholds gives the pilgrimage its rhythm: each doorway narrows the world further until only the sanctum remains.',
      description='The gilded doorway forming the final entrance to the innermost chamber before the sanctum.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='tirumala' and l.display_order=4;

update public.temple_locations l set
      story='The standing image of Venkateswara is the focus of the entire pilgrimage. Devotees typically have only moments before it, moving through in a continuous stream. The tower above the sanctum is covered in gilded plates and is visible across the temple.',
      architecture='A square sanctum within concentric enclosures, surmounted by a vimana faced with gilded copper plates and topped by a finial.',
      rituals='Worship begins in the early hours with the Suprabhatam, the hymn that awakens the deity, and continues through a fixed sequence of daily services.',
      significance='This is the destination of one of the largest continuous streams of pilgrims anywhere in the world — a place defined as much by its human scale as by its architecture.',
      description='The sanctum housing the image of Venkateswara, crowned by the gilded tower known as Ananda Nilayam.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/28310432/pexels-photo-28310432.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Mihran Kes / Pexels — Sri Venkateswara Temple architecture'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='tirumala' and l.display_order=5;

update public.temple_locations l set
      story='The tank lies immediately north of the temple. Bathing here before entering is a long-standing practice, and the tank is the setting for the float festival, when processional images are taken out on a decorated raft.',
      architecture='A large stepped tank enclosed by stone walls, with pavilions at its edge and a mandapa at the centre used during the float festival.',
      rituals='Ritual bathing before darshan; the annual Teppotsavam (float festival) is held on its waters.',
      significance='The tank provides the moment of pause and preparation before the intensity of the sanctum.',
      description='The temple tank beside the shrine, where pilgrims traditionally bathe before darshan.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/36771239/pexels-photo-36771239.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Vijay Richhiya / Pexels — the sacred tank at Tirupati'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='tirumala' and l.display_order=6;

update public.temple_locations l set
      story='The Varahaswami shrine stands beside the Swami Pushkarini. By long-established custom, worship and the first offering are made here before visiting the main temple — an order of precedence maintained in the temple''s daily practice.',
      architecture='A compact shrine of traditional plan facing the tank, smaller and plainer than the main temple.',
      rituals='Offerings are presented here first; many pilgrims complete this visit before joining the queue for the principal shrine.',
      significance='The custom preserves an older layer of worship on the hill and reminds pilgrims that the site''s sanctity is not attached to one shrine alone.',
      description='A separate shrine on the bank of the temple tank, dedicated to Varaha, the boar incarnation of Vishnu.',
      image_url=coalesce(l.image_url, NULL),
      image_credit=coalesce(l.image_credit, NULL),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='tirumala' and l.display_order=7;

update public.temple_locations l set
      story='The temple stands directly on the shore, and its silhouette against the sea is among the most recognised images of South Indian architecture. It belongs to the wider Group of Monuments at Mahabalipuram, inscribed by UNESCO in 1984.',
      architecture='A compact walled complex whose two tiered towers rise in steep pyramidal stages. Unlike the earlier monuments here, it is built from dressed and jointed granite blocks rather than carved from living rock.',
      rituals='The temple is a protected monument and is no longer in regular worship, though it remains an important cultural site.',
      significance='It marks a decisive change in Indian architecture: the moment when the Pallavas moved from carving temples out of rock to building them from cut stone.',
      description='The walled seaside enclosure containing the three shrines, seen as a single composition against the Bay of Bengal.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/38412970/pexels-photo-38412970.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Roman Saienko / Pexels — the Shore Temple'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='shore-temple' and l.display_order=1;

update public.temple_locations l set
      story='Rows of seated Nandi figures line the top of the compound wall, weathered smooth by centuries of salt wind. They frame the temple and mark it clearly as a Shaiva foundation.',
      architecture='A low granite wall carrying regularly spaced seated bulls, with sculpted pilasters and panels along its faces.',
      rituals='The bulls face the shrines, echoing the standard placement of Nandi before a Shiva sanctum.',
      significance='The erosion of these figures is itself part of the site''s story — a visible record of what the sea has done to the monument over thirteen centuries.',
      description='The low enclosure wall around the temple, topped by rows of seated bull figures.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/24246704/pexels-photo-24246704.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Ankit Bhattacharjee / Pexels — carving detail, Shore Temple'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='shore-temple' and l.display_order=2;

update public.temple_locations l set
      story='The principal shrine faces east, so that it opens toward the sunrise over the Bay of Bengal. Its dedication is recorded in inscriptions using titles of the Pallava king Rajasimha.',
      architecture='A slender tower of several receding tiers over a small sanctum, crowned by an octagonal finial — a form that would influence later Dravidian temple towers.',
      rituals='As a protected monument the shrine is no longer in daily worship; its original orientation to the rising sun remains legible in the plan.',
      significance='This is the tower that gives the Shore Temple its famous outline and set a pattern followed across South India for centuries.',
      description='The taller of the two Shiva shrines, facing east towards the sea.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/37584854/pexels-photo-37584854.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Roman Saienko / Pexels — the Shore Temple at sunset'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='shore-temple' and l.display_order=3;

update public.temple_locations l set
      story='Between the two Shiva shrines lies a low chamber containing an image of Vishnu reclining on the serpent. It is cut from the natural rock, and is thought to be older than the structural shrines built around it.',
      architecture='A rectangular chamber without a tower, its image carved directly from the living rock rather than built up in blocks — a survival of the earlier rock-cut tradition.',
      rituals='The shrine''s presence between two Shiva sanctums makes the complex unusual among Pallava temples.',
      significance='It shows two architectural eras meeting in a single monument: the older rock-cut practice enclosed within the new structural temple.',
      description='A shrine set between the two Shiva sanctums, containing a reclining Vishnu carved from the bedrock.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/35307623/pexels-photo-35307623.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Dhinesh Kumar / Pexels — Shore Temple stone carving'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='shore-temple' and l.display_order=4;

update public.temple_locations l set
      story='The five rathas are named after the Pandava brothers and Draupadi of the Mahabharata, though the names are conventional and later. Each was cut from the living rock, and several were left unfinished.',
      architecture='Five monolithic shrines, each experimenting with a different roof form and plan — a remarkable catalogue of the architectural ideas available to the Pallava workshops.',
      rituals='They are protected monuments and were probably never consecrated for regular worship.',
      significance='The rathas are effectively architectural models in stone, and they explain where the forms of later South Indian temples came from.',
      description='Five temples, each carved from a single outcrop of granite, standing a short distance inland.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/38198563/pexels-photo-38198563.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Roman Saienko / Pexels — stone monuments at Mahabalipuram'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='shore-temple' and l.display_order=5;

update public.temple_locations l set
      story='The relief covers a huge rock face with figures of gods, sages, celestial beings, and a famous procession of elephants. Its subject is debated: it is read either as Arjuna''s austerities or as the descent of the Ganges to earth. Both readings are traditional interpretations rather than settled fact.',
      architecture='A relief carved across two boulders separated by a natural cleft, which is thought to have been used to channel water down the centre of the composition.',
      rituals='It is a protected monument rather than a place of worship.',
      significance='It is one of the great narrative works of Indian art, and the finest surviving demonstration of Pallava sculptors working at monumental scale.',
      description='An immense open-air bas-relief carved across two adjoining boulders — one of the largest such reliefs in the world.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/33516545/pexels-photo-33516545.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'M Shah / Pexels — rock carvings at Mahabalipuram'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='shore-temple' and l.display_order=6;

update public.temple_locations l set
      story='The Olakkanesvara temple sits on the boulder above the Mahishasuramardini cave, whose panels include a celebrated relief of the goddess Durga in combat and a reclining Vishnu. In the colonial period the hilltop structure was used as a lighthouse.',
      architecture='A small structural shrine, now without its tower, standing above rock-cut cave temples whose interiors carry deeply carved narrative panels.',
      rituals='The cave shrines and hilltop temple are protected monuments and are no longer in regular worship.',
      significance='From here the whole site can be read at once — caves, monolithic shrines, the great relief and the Shore Temple, the full span of Pallava achievement.',
      description='A hilltop shrine above the Mahishasuramardini cave, overlooking the town and the sea.',
      image_url=coalesce(l.image_url, 'https://images.pexels.com/photos/38412969/pexels-photo-38412969.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940'),
      image_credit=coalesce(l.image_credit, 'Roman Saienko / Pexels — Mahabalipuram stone architecture'),
      audio_url=NULL
    from public.temples t
    where l.temple_id=t.id and t.slug='shore-temple' and l.display_order=7;

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000002', 'बृहदीश्वर मंदिर', 'चोल स्थापत्य की उत्कृष्ट कृति, जो लगभग 1010 ईस्वी में पूर्ण हुई। यह अपने 66 मीटर ऊँचे ग्रेनाइट विमान, विशाल प्राचीर-आँगन और गर्भगृह के अत्यंत बड़े शिवलिंग के लिए प्रसिद्ध है।', 'शिव, यहाँ पेरुवुडैयार / बृहदीश्वर के रूप में पूजित', 'द्रविड़ — चोल शैली' from public.temples t where t.slug='brihadeeswarar'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000002', 'मीनाक्षी अम्मन मंदिर', 'मदुरै के हृदय में स्थित विशाल मंदिर परिसर, जिसमें चौदह गोपुरम, लंबे स्तंभ-मंडप, एक पवित्र सरोवर तथा देवी मीनाक्षी और सुंदरेश्वर के युगल मंदिर हैं।', 'मीनाक्षी (पार्वती) और सुंदरेश्वर (शिव)', 'द्रविड़ — नायक शैली' from public.temples t where t.slug='meenakshi'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000002', 'कोणार्क सूर्य मंदिर', '13वीं शताब्दी का मंदिर, जिसे सूर्यदेव के विशाल रथ के रूप में गढ़ा गया — चौबीस पहिये, घोड़ों की टोलियाँ, और आधार से शिखर तक मूर्तिकला से आच्छादित।', 'सूर्य', 'कलिंग (ओडिशा) शैली' from public.temples t where t.slug='konark'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000002', 'श्री वेंकटेश्वर मंदिर, तिरुमला', 'तिरुमला पहाड़ियों पर स्थित मंदिर, जो विष्णु के स्वरूप वेंकटेश्वर को समर्पित है। यह विश्व के सर्वाधिक दर्शनीय तीर्थस्थलों में से एक है और तिरुमला तिरुपति देवस्थानम द्वारा संचालित है।', 'वेंकटेश्वर (विष्णु), जिन्हें श्रीनिवास और बालाजी भी कहा जाता है', 'द्रविड़ शैली' from public.temples t where t.slug='tirumala'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000002', 'तट मंदिर, महाबलिपुरम', 'बंगाल की खाड़ी के तट पर 8वीं शताब्दी के आरंभ में पल्लवों द्वारा तराशे गए ग्रेनाइट खंडों से निर्मित मंदिर; यूनेस्को सूचीबद्ध महाबलिपुरम स्मारक समूह का भाग।', 'शिव (दो मंदिर) और अनंतशयन विष्णु (एक मंदिर)', 'द्रविड़ — पल्लव शैली' from public.temples t where t.slug='shore-temple'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, history, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000004', 'பெருவுடையார் கோயில்', 'சோழர் கட்டிடக்கலையின் தலைசிறந்த படைப்பு. கி.பி. 11ஆம் நூற்றாண்டின் தொடக்கத்தில் கட்டப்பட்ட இக்கோயில், 66 மீட்டர் உயர விமானம், பரந்த கருங்கல் திடல் மற்றும் பெரிய சிவலிங்கத்திற்கு புகழ்பெற்றது.', 'சோழ மன்னன் முதலாம் இராஜராஜ சோழனால் கட்டப்பட்டு கி.பி. 1010-இல் நிறைவடைந்த இக்கோயில், அக்காலத்தின் மிகப் பெரிய கோயிலாக விளங்கியது. சுவர்களில் உள்ள நூற்றுக்கணக்கான கல்வெட்டுகள் அரசரின் கொடைகள், நடனம், இசை மற்றும் தினசரி வழிபாடுகளை பதிவு செய்கின்றன. 1987-இல் யுனெஸ்கோ உலக பாரம்பரிய தளமாக அறிவிக்கப்பட்ட இது, இன்றும் உயிருள்ள வழிபாட்டுத் தலமாக உள்ளது.', 'சிவபெருமான் (பெருவுடையார்)', 'திராவிட (சோழர்) பாணி' from public.temples t where t.slug='brihadeeswarar'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), history=coalesce(excluded.history, public.temple_translations.history), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, history, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000004', 'மீனாட்சி அம்மன் கோயில்', 'மதுரையின் மாட்சிமிகு கோயில் நகரம் — 14 உயர்ந்த கோபுரங்கள், செதுக்கப்பட்ட தூண்களின் காடு, பொற்றாமரைக் குளம் மற்றும் மீனாட்சி தாயாரின் புகழ்பெற்ற சன்னதி.', 'மதுரை இந்தியாவின் மிகப் பழமையான நகரங்களில் ஒன்று; பண்டைய தமிழ் இலக்கியமான சிலப்பதிகாரம் (கி.பி. 2ஆம் நூற்றாண்டு) இந்நகரின் தெருக்களில் நடைபெறுகிறது. தற்போதைய கோயில் வளாகம், கோபுரங்கள் உட்பட, 16–17ஆம் நூற்றாண்டுகளில் நாயக்கர் ஆட்சியில் பெரும்பாலும் மீண்டும் கட்டப்பட்டது. இக்கோயில் இன்றும் வழிபாடு, திருவிழாக்கள் மற்றும் தமிழ் கலாச்சாரத்தின் மையமாக உள்ளது.', 'மீனாட்சி அம்மன் & சுந்தரேஸ்வரர் (சிவன்)', 'திராவிட (நாயக்கர்) பாணி' from public.temples t where t.slug='meenakshi'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), history=coalesce(excluded.history, public.temple_translations.history), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, history, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000004', 'கொனார்க் சூரியன் கோயில்', '13ஆம் நூற்றாண்டின் சூரியக் கடவுளின் பிரம்மாண்ட தேராக செதுக்கப்பட்ட கோயில் — 24 கல் சக்கரங்கள், ஏழு குதிரைகள், ஒரு காலத்தின் கதையைச் சொல்லும் சிற்பங்கள்.', 'கிழக்கு கங்க மன்னன் முதலாம் நரசிம்மதேவனால் கி.பி. 13ஆம் நூற்றாண்டின் நடுப்பகுதியில் சூரியக் கடவுளுக்காக கட்டப்பட்டது. மூலக் கோபுரம் இன்று இல்லை; ஆனால் ஜகமோகனம் (சபாமண்டபம்) இன்னும் நிற்கிறது. 1984-இல் யுனெஸ்கோ உலக பாரம்பரிய தளமாக அறிவிக்கப்பட்ட இது, இந்திய தொல்லியல் துறையால் பாதுகாக்கப்படுகிறது.', 'சூரியன் (சூரியக் கடவுள்)', 'கலிங்க (ஒடிசா) பாணி' from public.temples t where t.slug='konark'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), history=coalesce(excluded.history, public.temple_translations.history), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000004', 'திருமலை ஸ்ரீ வேங்கடேஸ்வரர் கோயில்', 'திருமலை மலைகளில் அமைந்த, விஷ்ணுவின் வடிவமான வேங்கடேஸ்வரருக்கு அர்ப்பணிக்கப்பட்ட கோயில். உலகிலேயே அதிக பக்தர்கள் வரும் திருத்தலங்களில் ஒன்று; திருமலை திருப்பதி தேவஸ்தானத்தால் நிர்வகிக்கப்படுகிறது.', 'வேங்கடேஸ்வரர் (விஷ்ணு), ஸ்ரீனிவாசர் மற்றும் பாலாஜி எனவும் அழைக்கப்படுபவர்', 'திராவிட பாணி' from public.temples t where t.slug='tirumala'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000004', 'கடற்கரைக் கோயில், மாமல்லபுரம்', 'வங்கக் கடலின் கரையில், கி.பி. 8ஆம் நூற்றாண்டின் தொடக்கத்தில் பல்லவர்களால் கருங்கல் தொகுதிகளால் கட்டப்பட்ட கோயில். யுனெஸ்கோ பட்டியலிடப்பட்ட மாமல்லபுர நினைவுச்சின்னக் குழுவின் ஒரு பகுதி.', 'சிவன் (இரு சன்னதிகள்) மற்றும் அனந்தசயன விஷ்ணு (ஒரு சன்னதி)', 'திராவிட — பல்லவர் பாணி' from public.temples t where t.slug='shore-temple'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000003', 'బృహదీశ్వరాలయం', 'సుమారు క్రీ.శ. 1010లో పూర్తయిన చోళ శిల్పకళా అద్భుతం. 66 మీటర్ల ఎత్తైన గ్రానైట్ విమానం, విశాలమైన ప్రాకార ప్రాంగణం, గర్భగుడిలోని అతిపెద్ద శివలింగం దీని ప్రత్యేకత.', 'శివుడు, ఇక్కడ పెరువుడైయార్ / బృహదీశ్వరుడిగా పూజలందుకుంటాడు', 'ద్రావిడ — చోళ శైలి' from public.temples t where t.slug='brihadeeswarar'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000003', 'మీనాక్షి అమ్మన్ ఆలయం', 'మధురై నడిబొడ్డున ఉన్న విశాల ఆలయ సముదాయం — పద్నాలుగు గోపురాలు, పొడవైన స్తంభ మండపాలు, పవిత్ర కోనేరు, మీనాక్షి-సుందరేశ్వరుల జంట సన్నిధులు.', 'మీనాక్షి (పార్వతి) మరియు సుందరేశ్వరుడు (శివుడు)', 'ద్రావిడ — నాయక శైలి' from public.temples t where t.slug='meenakshi'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000003', 'కోణార్క్ సూర్య దేవాలయం', '13వ శతాబ్దపు ఆలయం, సూర్యభగవానుని బృహత్ రథంగా చెక్కబడింది — ఇరవై నాలుగు రాతి చక్రాలు, గుర్రాల బృందాలు, పునాది నుంచి శిఖరం వరకు శిల్పకళ.', 'సూర్యుడు', 'కళింగ (ఒడిశా) శైలి' from public.temples t where t.slug='konark'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000003', 'శ్రీ వేంకటేశ్వర స్వామి ఆలయం, తిరుమల', 'తిరుమల కొండలపై వెలసిన, విష్ణువు స్వరూపమైన వేంకటేశ్వరునికి అంకితమైన ఆలయం. ప్రపంచంలోనే అత్యధిక భక్తులు సందర్శించే పుణ్యక్షేత్రాలలో ఒకటి; తిరుమల తిరుపతి దేవస్థానముల ఆధ్వర్యంలో నడుస్తుంది.', 'వేంకటేశ్వరుడు (విష్ణువు), శ్రీనివాసుడు మరియు బాలాజీ అని కూడా పిలుస్తారు', 'ద్రావిడ శైలి' from public.temples t where t.slug='tirumala'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000003', 'తీర దేవాలయం, మహాబలిపురం', 'బంగాళాఖాతం తీరాన 8వ శతాబ్దం ఆరంభంలో పల్లవులు చెక్కిన గ్రానైట్ దిమ్మెలతో నిర్మించిన ఆలయం; యునెస్కో గుర్తింపు పొందిన మహాబలిపురం స్మారక సముదాయంలో భాగం.', 'శివుడు (రెండు సన్నిధులు) మరియు అనంతశయన విష్ణువు (ఒక సన్నిధి)', 'ద్రావిడ — పల్లవ శైలి' from public.temples t where t.slug='shore-temple'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000005', 'ബൃഹദീശ്വര ക്ഷേത്രം', 'ഏകദേശം ക്രി.വ. 1010-ൽ പൂർത്തിയായ ചോള വാസ്തുവിദ്യയുടെ മാസ്റ്റർപീസ്. 66 മീറ്റർ ഉയരമുള്ള ഗ്രാനൈറ്റ് വിമാനം, വിശാലമായ മതിൽക്കെട്ട് മുറ്റം, ശ്രീകോവിലിലെ വലിയ ശിവലിംഗം എന്നിവയ്ക്ക് പ്രശസ്തം.', 'ശിവൻ, ഇവിടെ പെരുവുടൈയാർ / ബൃഹദീശ്വരൻ എന്ന പേരിൽ ആരാധിക്കപ്പെടുന്നു', 'ദ്രാവിഡ — ചോള ശൈലി' from public.temples t where t.slug='brihadeeswarar'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000005', 'മീനാക്ഷി അമ്മൻ ക്ഷേത്രം', 'മധുരയുടെ ഹൃദയഭാഗത്തുള്ള വിശാലമായ ക്ഷേത്രസമുച്ചയം — പതിനാല് ഗോപുരങ്ങൾ, നീണ്ട തൂൺമണ്ഡപങ്ങൾ, പവിത്ര കുളം, മീനാക്ഷിയുടെയും സുന്ദരേശ്വരന്റെയും ഇരട്ട ശ്രീകോവിലുകൾ.', 'മീനാക്ഷി (പാർവതി), സുന്ദരേശ്വരൻ (ശിവൻ)', 'ദ്രാവിഡ — നായക്ക ശൈലി' from public.temples t where t.slug='meenakshi'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000005', 'കൊണാർക്ക് സൂര്യക്ഷേത്രം', 'സൂര്യദേവന്റെ കൂറ്റൻ രഥമായി കൊത്തിയെടുത്ത പതിമൂന്നാം നൂറ്റാണ്ടിലെ ക്ഷേത്രം — ഇരുപത്തിനാല് ശിലാചക്രങ്ങൾ, കുതിരക്കൂട്ടങ്ങൾ, അടിത്തറ മുതൽ മേൽക്കൂര വരെ ശിൽപങ്ങൾ.', 'സൂര്യൻ', 'കലിംഗ (ഒഡീഷ) ശൈലി' from public.temples t where t.slug='konark'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000005', 'ശ്രീ വെങ്കടേശ്വര ക്ഷേത്രം, തിരുമല', 'തിരുമല മലനിരകളിൽ വിഷ്ണുവിന്റെ രൂപമായ വെങ്കടേശ്വരന് സമർപ്പിച്ച ക്ഷേത്രം. ലോകത്തിലെ ഏറ്റവും കൂടുതൽ തീർഥാടകർ എത്തുന്ന കേന്ദ്രങ്ങളിലൊന്ന്; തിരുമല തിരുപ്പതി ദേവസ്ഥാനം ഭരണം നിർവഹിക്കുന്നു.', 'വെങ്കടേശ്വരൻ (വിഷ്ണു), ശ്രീനിവാസൻ, ബാലാജി എന്നും അറിയപ്പെടുന്നു', 'ദ്രാവിഡ ശൈലി' from public.temples t where t.slug='tirumala'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.temple_translations (temple_id, language_id, name, description, main_deity, architectural_style)
select t.id, '10000000-0000-4000-8000-000000000005', 'ഷോർ ടെമ്പിൾ, മഹാബലിപുരം', 'ബംഗാൾ ഉൾക്കടലിന്റെ തീരത്ത് എട്ടാം നൂറ്റാണ്ടിന്റെ തുടക്കത്തിൽ പല്ലവർ ഗ്രാനൈറ്റ് കട്ടകൾ കൊണ്ട് നിർമിച്ച ക്ഷേത്രം; യുനെസ്കോ പട്ടികയിലുള്ള മഹാബലിപുരം സ്മാരകസമുച്ചയത്തിന്റെ ഭാഗം.', 'ശിവൻ (രണ്ട് ശ്രീകോവിലുകൾ), അനന്തശയന വിഷ്ണു (ഒന്ന്)', 'ദ്രാവിഡ — പല്ലവ ശൈലി' from public.temples t where t.slug='shore-temple'
on conflict (temple_id, language_id) do update set name=coalesce(excluded.name, public.temple_translations.name), description=coalesce(excluded.description, public.temple_translations.description), main_deity=coalesce(excluded.main_deity, public.temple_translations.main_deity), architectural_style=coalesce(excluded.architectural_style, public.temple_translations.architectural_style);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'केरलांतकन तिरुवासल (बाहरी प्रवेशद्वार)', 'मंदिर का बाहरी गोपुरम, जिसका नाम राजराज चोल प्रथम की एक उपाधि पर रखा गया है। यह पूर्व-पश्चिम अक्ष के दो द्वारों में पहला है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'राजराजन तिरुवासल (भीतरी प्रवेशद्वार)', 'दोनों द्वारों में भीतरी और अधिक अलंकृत द्वार, जो सीधे विशाल आँगन में खुलता है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'नंदी मंडप', 'आँगन में खुला स्तंभ-मंडप, जिसमें गर्भगृह की ओर मुख किए एक विशाल एकाश्म नंदी विराजमान है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'गर्भगृह (मुख्य मंदिर)', 'मंदिर के केंद्र में स्थित गर्भगृह, जिसमें विशाल विमान के नीचे अत्यंत बड़ा शिवलिंग प्रतिष्ठित है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'चोल भित्तिचित्र गलियारा', 'गर्भगृह के चारों ओर अंधकारमय प्रदक्षिणा पथ, जिसकी दीवारों पर दुर्लभ चोलकालीन भित्तिचित्र सुरक्षित हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'महान विमान', 'गर्भगृह के ऊपर पिरामिडाकार शिखर, लगभग 66 मीटर ऊँचा — अपनी श्रेणी के सबसे ऊँचे मंदिर शिखरों में से एक।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'उप-मंदिर', 'आँगन के भीतर छोटे मंदिर, जिनमें देवी (बृहन्नायकी) और चंडेश्वर के मंदिर तथा बाद के निर्माण सम्मिलित हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'विशाल प्राकार (आँगन)', 'मंदिर को घेरता विशाल प्राचीर-आँगन, जिसके चारों ओर स्तंभयुक्त गलियारे बने हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=8
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'गोपुरम (प्रवेश शिखर)', 'मंदिर की दीवारों पर चौदह गोपुरम खड़े हैं; दक्षिणी गोपुरम लगभग 52 मीटर ऊँचा और सबसे ऊँचा है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'अष्ट शक्ति मंडप', 'पूर्वी प्रवेश के ठीक भीतर स्थित स्तंभ-मंडप, जिसका नाम देवी के आठ स्वरूपों की मूर्तियों पर पड़ा है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'सहस्र स्तंभ मंडप', '16वीं शताब्दी का मंडप, जो अपने सूक्ष्म नक्काशीदार स्तंभों और संगीत-ध्वनि देने वाले स्तंभों के लिए प्रसिद्ध है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'मीनाक्षी मंदिर', 'देवी मीनाक्षी का गर्भगृह — मदुरै की अधिष्ठात्री देवी और पूरे परिसर का केंद्र।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'सुंदरेश्वर मंदिर', 'सुंदरेश्वर का मंदिर — मदुरै में शिव जिस रूप में पूजे जाते हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'ऊंजल मंडप (झूला मंडप)', 'वह मंडप जहाँ प्रत्येक शुक्रवार संध्या को देवताओं की उत्सव-मूर्तियाँ झूले पर विराजित की जाती हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'पोट्रामरै कुलम (स्वर्ण कमल सरोवर)', 'परिसर के केंद्र में सीढ़ीदार पवित्र सरोवर, चारों ओर स्तंभयुक्त गलियारों से घिरा।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'कल्याण मंडप (विवाह मंडप)', 'वह मंडप जहाँ प्रतिवर्ष दिव्य विवाह का आयोजन और उत्सव होता है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=8
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'सिंह द्वार', 'मंदिर का पूर्वी प्रवेश, जहाँ हाथियों के ऊपर विशाल सिंह-प्रतिमाएँ स्थापित हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'भोग मंडप (नैवेद्य मंडप)', 'प्रवेश के निकट अलग खड़ा स्तंभयुक्त चबूतरा, जिसे नैवेद्य तैयार करने और अर्पित करने का मंडप माना जाता है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'नाट्य मंडप (नृत्य मंडप)', 'मुख्य संरचना के सामने छत रहित स्तंभयुक्त चबूतरा, जिसकी दीवारें नर्तकों और वादकों से भरी हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'रथ के पहिये और अश्व', 'मंदिर के चबूतरे पर चौबीस अलंकृत पहिये और सामने अश्वों की टोलियाँ — पूरा मंदिर ही सूर्य का रथ है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'जगमोहन (सभा मंडप)', 'आज भी खड़ा विशाल पिरामिडाकार मंडप — मंदिर की सबसे बड़ी शेष संरचना।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'नवग्रह पट्ट', 'नौ ग्रह देवताओं को दर्शाती बड़ी उत्कीर्ण शिला, जो मूलतः मंदिर के द्वार के ऊपर स्थापित थी।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'देउल (गर्भगृह अवशेष)', 'उस गर्भगृह का आधार जिसमें कभी सूर्य की प्रतिमा थी; शिखर अब शेष नहीं है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'मंदिर परिसर और मायादेवी मंदिर', 'व्यापक परिसर, जिसमें मायादेवी मंदिर नामक भग्न मंदिर सहित सहायक संरचनाएँ हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=8
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'महाद्वार (मुख्य प्रवेशद्वार)', 'मुख्य गोपुर द्वार जिससे होकर तीर्थयात्री मंदिर में प्रवेश करते हैं; इसे पडिकावली भी कहते हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'सम्पंगी प्रदक्षिणम् (बाहरी परिक्रमा)', 'पहली और दूसरी प्राचीर के बीच का बाहरी परिक्रमा पथ, जिसके किनारे मंडप और मंदिर हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'ध्वजस्तंभ', 'गर्भगृह के ठीक सामने, मंदिर के मुख्य अक्ष पर खड़ा स्वर्णमंडित ध्वजस्तंभ।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'बंगारु वाकिली (स्वर्ण द्वार)', 'गर्भगृह से पहले भीतरी कक्ष का अंतिम स्वर्णमंडित प्रवेशद्वार।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'आनंद निलयम (गर्भगृह और स्वर्ण विमान)', 'वेंकटेश्वर की प्रतिमा का गर्भगृह, जिसके ऊपर आनंद निलयम नामक स्वर्णमंडित विमान है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'स्वामी पुष्करिणी (पवित्र सरोवर)', 'मंदिर के निकट का सरोवर, जहाँ तीर्थयात्री दर्शन से पूर्व स्नान करते हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'वराहस्वामी मंदिर', 'सरोवर के तट पर स्थित पृथक मंदिर, जो विष्णु के वराह अवतार को समर्पित है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'तट मंदिर परिसर', 'तीन मंदिरों वाला प्राचीरयुक्त समुद्रतटीय परिसर, जो बंगाल की खाड़ी की पृष्ठभूमि में एक ही रचना के रूप में दिखता है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'नंदी प्राचीर', 'मंदिर के चारों ओर नीची प्राचीर, जिसके ऊपर बैठे हुए नंदियों की पंक्तियाँ हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'क्षत्रियसिंहेश्वर (मुख्य शिव मंदिर)', 'दोनों शिव मंदिरों में ऊँचा, जो पूर्व दिशा में समुद्र की ओर मुख किए है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'अनंतशयन विष्णु मंदिर', 'दोनों शिव मंदिरों के बीच स्थित मंदिर, जिसमें मूल शिला से तराशे गए शयन विष्णु हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'पंच रथ', 'कुछ दूरी पर स्थित पाँच मंदिर, जिनमें प्रत्येक एक ही ग्रेनाइट शिला से तराशा गया है।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'अर्जुन की तपस्या (गंगावतरण)', 'दो विशाल शिलाओं पर उकेरा गया विशाल खुला भित्ति-उत्कीर्णन — विश्व के सबसे बड़े उत्कीर्णनों में से एक।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000002', 'ओलक्कणेश्वर मंदिर और गुफा मंदिर', 'महिषासुरमर्दिनी गुफा के ऊपर पहाड़ी पर स्थित मंदिर, जहाँ से नगर और समुद्र दिखाई देते हैं।' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'நுழைவு கோபுரம் (கேரளாந்தகன் திருவாசல்)', 'இராஜராஜ சோழனின் பட்டப்பெயரால் அழைக்கப்படும் இரண்டு அடுக்கு கோபுரத்தின் வழியாக கிழக்கு நுழைவாயில் திறக்கிறது.', 'கேரளாந்தகன் திருவாசல் என்ற பெயர், போர்களுக்குப் பிறகு முதலாம் இராஜராஜ சோழன் ஏற்றுக்கொண்ட பட்டப்பெயரை நினைவூட்டுகிறது. உள்ளூர் மரபுப்படி, அரச ஊர்வலங்கள் இந்த வழியாகவே கோயிலுக்குள் நுழைந்தன; இன்றும் திருவிழா ஊர்வலங்கள் அதே பாதையைப் பின்பற்றுகின்றன.', 'இரண்டு அடுக்கு கொண்ட, வளைவு கூரையுடைய கோபுரம். வேண்டுமென்றே எளிமையான அளவில் கட்டப்பட்டதால், அதற்கு அப்பால் உள்ள பிரம்மாண்ட விமானம் இன்னும் உயர்ந்ததாகத் தோன்றுகிறது.', 'தினசரி பூஜை ஊர்வலங்களும் திருவிழா தேர்ப் பாதைகளும் இந்த வாயில் வழியாகச் செல்கின்றன. பக்தர்கள் கோயிலுக்குள் நுழையும் முன் வாசற்படியில் வணங்குவது மரபு.', 'நகரத்திலிருந்து புனித வளாகத்திற்குச் செல்லும் முதல் எல்லை இது — சிவ சன்னதியை நோக்கிய பயணத்தில் பக்தரை தயார்படுத்தும் முதல் வாயில்.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'நந்தி மண்டபம்', 'கருவறையை நோக்கி அமர்ந்துள்ள பிரம்மாண்ட ஒற்றைக்கல் நந்தியைக் கொண்ட திறந்த தூண் மண்டபம்.', 'இந்து மரபில், நந்தி சிவனின் வாகனமும் முதன்மையான பக்தனும் ஆவான்; எப்போதும் தன் இறைவனையே நோக்கியிருப்பான். தஞ்சை நந்தி, இந்தியாவிலேயே மிகப்பெரிய ஒற்றைக்கல் நந்தி சிலைகளில் ஒன்று.', 'செதுக்கப்பட்ட கருங்கல் தூண்களுடன் உயர்த்தப்பட்ட மண்டபம். நந்தி சுமார் 5 மீட்டர் நீளமுள்ளது; வழவழப்பாக மெருகேற்றப்பட்ட மேற்பரப்பு ஒளியை பிரதிபலிக்கிறது.', 'பக்தர்கள் நந்தியை வலம் வந்து, பூக்களும் விபூதியும் அளித்து வழிபடுகின்றனர். வருடாந்திர திருவிழாவின் போது நந்தி சிறப்பாக அலங்கரிக்கப்படுகிறது.', 'நந்தி பக்தியையும் உண்மையையும் குறிக்கிறான். இங்கு நிற்கும் பக்தன், இறைவனை அணுக வேண்டிய மனநிலையைக் கற்றுக்கொள்கிறான் — பொறுமை, பக்தி, இறைநோக்கு.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'கருவறை', 'கோயிலின் இதயம் — உயர்ந்த விமானத்தின் கீழ் பெரிய சிவலிங்கத்தைக் கொண்ட பரந்த கருவறை.', 'கருவறையில் சிவபெருமான் பெருவுடையார் என்ற திருநாமத்துடன் லிங்க வடிவில் எழுந்தருளியுள்ளார். கி.பி. 11ஆம் நூற்றாண்டின் தொடக்கத்தில் இராஜராஜ சோழனால் இக்கோயில் கட்டி முடிக்கப்பட்டது. இருண்ட கருவறைக்குச் செல்லும் வழியில் சோழர் காலத்திய சிறந்த ஓவியங்கள் உள்ளன.', 'பிரம்மாண்ட கருங்கல் கற்களால் கட்டப்பட்ட சதுர அறை; மேலே 66 மீட்டர் உயர விமானம். சுற்றிலும் அகலமான பிரகாரமும், நுழைவாயிலில் பிரம்மாண்ட துவாரபாலகர் சிலைகளும் உள்ளன.', 'நாள்தோறும் பல கால பூஜைகள் நடைபெறுகின்றன — பால், நீர், விபூதியால் அபிஷேகமும் தொடர்ந்து தீபாராதனையும். இங்கு புகழ்பெற்ற நடராஜர் திருவுருவமும் உள்ளது.', 'கருவறை கோயிலின் ஆன்மீக அச்சு — எல்லா பாதைகளும், மண்டபங்களும் இங்கே சங்கமிக்கின்றன; ஆன்மா இறைவனை நோக்கிய பயணத்தின் அடையாளம் இது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'பெரிய விமானம் (கோபுரம்)', 'சுமார் 66 மீட்டர் உயரமுள்ள முடிசூடிய கோபுரம் — உலகின் மிக உயர்ந்தவற்றில் ஒன்று.', 'கி.பி. 1010-இல் நிறைவடைந்தபோது, இந்தியாவின் அக்கால கட்டிடங்களிலேயே மிக உயர்ந்ததாக இருந்தது. உள்ளூர் மரபுப்படி, உச்சியில் உள்ள கருங்கல் கும்பம் சுமார் 80 டன் எடையுள்ளது; அது நீண்ட சரிவு பாதை வழியாக இழுத்துச் செல்லப்பட்டதாகக் கூறப்படுகிறது — இது மரபு வழியான கதையே தவிர பதிவு செய்யப்பட்ட வரலாறு அல்ல.', 'பதின்மூன்று அடுக்குகளாக குறுகி, எண்கோண உச்சியை அடையும் பிரமிடு வடிவ கோபுரம். கிட்டத்தட்ட முழுவதும் கருங்கல்லால் கட்டப்பட்ட இதன் மேல் அடுக்குகள் வியக்கத்தக்க துல்லியத்துடன் பொருத்தப்பட்டுள்ளன.', 'கோபுரம் கோயிலின் மகுடமாக வணங்கப்படுகிறது. மாலை வேளைகளில் வளாகம் முழுவதும் விளக்குகள் ஏற்றப்படுகின்றன; பெரிய திருவிழாக்களில் விமானம் ஒளியூட்டப்படுகிறது.', 'விமானம், கோயிலை தேவர்களின் மலையாகக் கண்ட சோழர்களின் தொலைநோக்கை உணர்த்துகிறது — பூமியையும் வானத்தையும் இணைக்கும் செங்குத்து அச்சு.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'துணை சன்னதிகள் (தேவி & சண்டிகேஸ்வரர்)', 'தேவிக்கும், சைவ பக்தரான சண்டிகேஸ்வரருக்கும் அர்ப்பணிக்கப்பட்ட திடலில் உள்ள சிறிய சன்னதிகள்.', 'சோழ மரபில், சிவனின் துணைவியார் தனி சன்னதியில் எழுந்தருளியுள்ளார். தென்னிந்திய சைவக் கோயில்களில் வணங்கப்படும் சண்டிகேஸ்வரர், சைவ ஆகமங்களில் சிவ பக்தர்களின் காவலராக நினைவுகூரப்படுகிறார்.', 'செதுக்கப்பட்ட தூண்களுடன் கூடிய கச்சிதமான சன்னதிகள் — பெரிய விமானத்தின் சிறு பிரதிகள் போல, அதே கட்டிடக்கலையை சிறிய அளவில் காட்டுகின்றன.', 'வெள்ளிக்கிழமைகளிலும் நவராத்திரியின் போதும் தேவிக்கு சிறப்பு பூஜைகள் நடைபெறுகின்றன. சைவ மரபில் முக்கிய சடங்குகளுக்கு முன் சண்டிகேஸ்வரரை வணங்குவர்.', 'துணை சன்னதிகள், சோழர் கோயிலை ஒரு சிறு பிரபஞ்சமாகக் காட்டுகின்றன — தெய்வ குடும்பத்திற்கும் பரிவாரங்களுக்கும் புனித வரிசையில் இடம் உண்டு.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'கோயில் திடல் (பிரகாரம்)', 'சுமார் 240 மீட்டர் நீளமுள்ள பரந்த சுவர் சூழ்ந்த திடல்; நூற்றுக்கணக்கான சிறு லிங்கங்களுடன் தூண் மண்டபங்கள்.', 'இந்தியாவின் மிகப்பெரிய திடல்களில் இதுவும் ஒன்று. கல்வெட்டுகளின்படி, இராஜராஜ சோழன் கோயிலுக்கு நடனமங்கையர், இசைக்கலைஞர்கள், நிலக்கொடைகளை அளித்தான்; சுற்று மண்டபங்கள் வலம் வருதலுக்கும் திருவிழாக்களுக்கும் பயன்பட்டன.', 'பிரம்மாண்ட கருங்கல் சுவர்கள் திடலைச் சூழ்ந்துள்ளன. நுழைவு கோபுரங்களுக்கும் நந்தி மண்டபத்திற்கும் இடையே தூண் மண்டபங்கள் நீள்கின்றன; திறந்த வெளியில் சிறிய சன்னதிகள் உள்ளன.', 'முழு திடலையும் வலம் வருவது (பிரதட்சணை) பாரம்பரிய பக்தி செயலாகும்; மார்கழி மாதத்திலும் திருவிழா நாட்களிலும் இது சிறப்பாக அனுசரிக்கப்படுகிறது.', 'பிரகாரம் கோயிலின் சடங்கு மற்றும் சமூக இதயம் — ஆயிரம் ஆண்டுகளாக பக்தியும், திருவிழாவும், இசையும், வாழ்க்கையும் சந்திக்கும் இடம்.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=8
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'கோயில் கோபுரங்கள் (நுழைவு)', 'உயர்ந்த கோபுரங்கள் வழியாக கோயிலுக்குள் நுழையலாம் — தெற்கு கோபுரம் சுமார் 52 மீட்டர் உயரம், இந்தியாவின் மிக உயர்ந்தவற்றில் ஒன்று.', 'பதினான்கு கோபுரங்கள் கோயில் சுவர்களை முடிசூடுகின்றன; மிக உயர்ந்த தெற்கு கோபுரம் 16ஆம் நூற்றாண்டில் நாயக்கர் காலத்தில் கட்டி முடிக்கப்பட்டது. கோபுரங்கள் சுதையால் ஆன ஆயிரக்கணக்கான தெய்வங்கள், நடனமங்கையர், புராண காட்சிகள் நிறைந்தவை — உள்ளூர் மரபுப்படி ஒவ்வொரு சிலையும் ஒரு கதை சொல்கிறது.', 'கோபுரங்கள் அடுக்கடுக்காக குறுகும் பிரமிடு வடிவ கோபுரங்கள்; வண்ண சுதை சிலைகளால் நிரம்பியவை. சிற்பங்களின் அடர்த்தி இவற்றை ''கல்லில் எழுதிய கதைப் புத்தகங்களாக'' ஆக்குகிறது.', 'தினமும் காலையில் சடங்குகளுடன் கோயில் வாயில்கள் திறக்கப்படுகின்றன. பக்தர்கள் கோபுரங்களின் கீழ் சென்று வணங்குகின்றனர்; திருவிழா காலங்களில் கோபுரங்கள் ஒளியூட்டப்படுகின்றன.', 'கோபுரமே முதல் தரிசனம் — தூரத்திலிருந்தே கோயில் நகரை அறிவிக்கும் தெய்வீக சந்திப்பு.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'ஆயிரம் கால் மண்டபம்', '985 செதுக்கப்பட்ட தூண்கள் கொண்ட மாட்சிமிகு 16ஆம் நூற்றாண்டு மண்டபம்; இசை தரும் ''இசைத் தூண்களுக்கு'' புகழ்பெற்றது.', 'நாயக்கர் காலத்தில் கட்டப்பட்ட இம்மண்டபம், திருமலை நாயக்கரின் திறமையான மந்திரி அரியநாத முதலியாருடன் தொடர்புடையது; அவரது சிலை நுழைவாயிலில் உள்ளது. தட்டினால் வெவ்வேறு இசை ஒலிகளை எழுப்பும் ''இசைத் தூண்கள்'' பார்வையாளர்களை எப்போதும் வியப்பில் ஆழ்த்துகின்றன.', '985 தூண்கள் கொண்ட கல் காடு இது — ஒவ்வொன்றிலும் தெய்வங்கள், வீரர்கள், இசைக்கலைஞர்களின் சிற்பங்கள். இசைத் தூண்கள் பெரிய தூண்களுக்குள் அமைந்த சிறு தூண்கள்; யாளி தூண்கள் நாயக்கர் சிற்பக்கலையின் தலைசிறந்த படைப்புகள்.', 'கோயில் விழாக்கள், இசை நிகழ்ச்சிகள், கலாச்சார நிகழ்வுகளுக்கு இம்மண்டபம் பயன்படுகிறது. மண்டபத்தின் ஒரு பகுதியில் கோயில் கலை மற்றும் வெண்கல சிலைகளின் அருங்காட்சியகம் உள்ளது.', 'கலை, இசை, பக்தி ஒன்றிணைந்த கலாச்சார கல்விக்கூடமாக கோயில் இருந்ததை இம்மண்டபம் காட்டுகிறது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'மீனாட்சி சன்னதி', 'மதுரையின் அதிபதியான மீனாட்சி தாயாரின் கருவறை.', 'உள்ளூர் மரபுப்படி, மீனாட்சி மூன்று மார்பகங்களுடன் பிறந்தாள்; சிவனைச் சந்தித்தபோது மூன்றாவது மறைந்தது. பச்சை நிறத்தில் கிளியுடன் காட்சியளிக்கும் தாயார் திருவுருவம் மதுரையின் அடையாளம்; கோயிலின் இதயம் இந்த சன்னதியே.', 'தாயாரின் விமானம் தங்க முலாம் பூசப்பட்டது; சுற்றியுள்ள மண்டபங்களில் கோயிலின் பழமையான செதுக்கப்பட்ட தூண்கள் உள்ளன.', 'தினசரி பூஜைகளில் அபிஷேகமும் அலங்காரமும் அடங்கும்; வெள்ளிக்கிழமைகள் சிறப்பானவை. தாயாரின் திருக்கல்யாணம் நிகழ்த்தப்படும் சித்திரை திருவிழாதான் கோயிலின் மிகப்பெரிய கொண்டாட்டம்.', 'மீனாட்சி மதுரையின் ராணி — நகரின் வாழ்க்கையும், திருவிழாக்களும், அடையாளமும் அவளைச் சுற்றியே உள்ளன.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'சுந்தரேஸ்வரர் சன்னதி', 'மதுரையின் சிவனான சுந்தரேஸ்வரரின் (''அழகிய இறைவன்'') சன்னதி.', 'கோயிலின் தலபுராணப்படி, மீனாட்சியை மணக்க சிவன் சுந்தரேஸ்வரராக மதுரைக்கு வந்தார். மரபுப்படி, திருமணம் பொற்றாமரைக் குளக்கரையில் நடந்தது; சித்திரை திருவிழாவில் ஆண்டுதோறும் நிகழ்த்தப்படுகிறது. இங்குள்ள பொன்னம்பலமான கனக சபை, சிவனின் கூத்து (நடராஜர்) உடன் தொடர்புடையது.', 'சன்னதியின் விமானமும் சுற்று மண்டபங்களும் செழுமையான சிற்ப வேலைப்பாடு கொண்டவை. கனக சபை கோயில் வளாகத்தின் மிக அழகிய இடங்களில் ஒன்று.', 'காலை பூஜைகள், அபிஷேகம், மாலை தீபாராதனை என சைவ மரபுப்படி வழிபாடு நடைபெறுகிறது. திருவிழா ஊர்வலங்களில் இரு தெய்வங்களின் திருவுருவங்களும் மதுரை தெருக்களில் எழுந்தருளுகின்றன.', 'மீனாட்சியும் சுந்தரேஸ்வரரும் சேர்ந்தே மதுரையின் தெய்வ தம்பதி — ஒவ்வொரு மண்டபத்திலும் திருவிழாவிலும் அவர்களின் இணைவை கோயில் வெளிப்படுத்துகிறது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'பொற்றாமரைக் குளம்', 'பக்தர்கள் நீராடும் புனித கோயில் குளம்; மரபுப்படி திருக்கல்யாணம் நடந்த இடம்.', 'பொற்றாமரைக் குளம் என்று அழைக்கப்படும் இந்த குளம், மதுரையின் தமிழ் சங்கங்களுடன் தொடர்புடையது. புராணக்கதைப்படி, சிறந்த கவிஞர்கள் வந்தபோது தாமரைகள் பொன்னிறமாக மலரும்; மீனாட்சி-சுந்தரேஸ்வரர் திருக்கல்யாணம் இக்கரையில் நடந்ததாகச் சொல்லப்படுகிறது.', 'செதுக்கப்பட்ட தூண்களுடன் கூடிய மண்டபங்களால் சூழப்பட்ட குளம்; அமைதியான நீரில் கோபுரங்களின் பிரதிபலிப்பு கோயிலின் மிக அழகிய காட்சிகளில் ஒன்று.', 'தரிசனத்திற்கு முன் பக்தர்கள் நீராடுகின்றனர், குறிப்பாக திருவிழா நாட்களில். குளத்தின் மண்டபங்கள் ஓய்வு, பிரார்த்தனை, விழா கூட்டங்களுக்கு பயன்படுகின்றன.', 'நீர் கோயில் மரபில் மாபெரும் தூய்மையாக்கி; உள்ளத் தூய்மையே வழிபாட்டின் முதல் படி என்பதை குளம் நினைவூட்டுகிறது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'கல்யாண மண்டபம்', 'திருக்கல்யாண ஓவியங்களால் அலங்கரிக்கப்பட்ட சடங்கு மண்டபம் — கோயிலின் பல திருவிழா இடங்களில் ஒன்று.', 'கல்யாண மண்டபத்தின் முகட்டு ஓவியங்கள் மீனாட்சி-சுந்தரேஸ்வரர் திருக்கல்யாணத்தையும், கோயிலை ஆதரித்த நாயக்க மன்னர்களின் செயல்களையும் விவரிக்கின்றன. மரபுப்படி, சித்திரை திருவிழாவின் போது திருக்கல்யாண ஏற்பாடுகள் இம்மண்டபத்தில் நடைபெறுகின்றன.', 'நாயக்கர் காலத்திய தூண் மண்டபம்; வண்ண முகட்டு ஓவியங்களும் செதுக்கப்பட்ட தூண்களும் 17ஆம் நூற்றாண்டு மதுரைக் கலையின் பெருமையை காட்டுகின்றன.', 'வருடாந்திர திருவிழாவின் போது தெய்வங்களின் சடங்கு ஏற்பாடுகளுக்கு இம்மண்டபம் பயன்படுகிறது; பக்தர்களின் திருமணங்களும் இத்தகைய மண்டபங்களில் நடைபெறுகின்றன.', 'மனித வாழ்க்கையின் ஒவ்வொரு மைல்கல்லையும் கோயில் தழுவுவதை இம்மண்டபம் காட்டுகிறது — பிறப்பு, திருமணம், திருவிழா, வழிபாடு அனைத்திற்கும் புனித வளாகத்தில் இடம் உண்டு.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=8
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'சிம்ஹ துவாரம் (சிங்க வாயில்)', 'கோயில் வளாகத்தின் கிழக்கு நுழைவாயில்; பிரம்மாண்ட சிங்கங்களும் யானைச் சிற்பங்களும் காவல் புரிகின்றன.', 'சிம்ஹ துவாரம் என்றால் ''சிங்க வாயில்''. யானைகளை மிதிக்கும் பிரம்மாண்ட சிங்கங்கள் கிழக்கு நுழைவில் நிற்கின்றன. உள்ளூர் மரபுப்படி, யானையை அழுத்தும் சிங்கம், உலக பெருமையின் மீது தெய்வீக சக்தியின் வெற்றியைக் குறிக்கிறது.', 'உள்ளூர் கல்லால் கட்டப்பட்ட வாயில்; கலிங்க சிற்பப்பாணியின் சுருள் வேலைப்பாடுகளும் இலை கொடி சிற்பங்களும் சூழ்ந்துள்ளன.', 'கட்டிடக் கலைஞர்கள் கருதியபடி, முழு கோயிலையும் ஒரே பார்வையில் காண பக்தர்கள் வாயிலில் நின்று பார்க்கும் வழக்கம் உள்ளது.', 'சிங்க வாயில் கோயிலின் முன்னோட்டம் — கலை வலிமையை அறிவித்து, பக்தரின் பார்வையை உதய சூரியனை நோக்கி திருப்புகிறது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'கல் தேர் (சக்கரங்கள் & குதிரைகள்)', 'கோயில் மேடை, 24 செதுக்கப்பட்ட சக்கரங்களும் ஏழு குதிரைகளும் கொண்ட பிரம்மாண்ட தேராக வடிவமைக்கப்பட்டுள்ளது.', 'சூரியக் கடவுளின் தேராக கோயில் வடிவமைக்கப்பட்டது — இருபுறமும் பன்னிரண்டு சக்கரங்கள், ஏழு குதிரைகள். சுமார் 3 மீட்டர் விட்டமுள்ள ஒவ்வொரு சக்கரமும் ஆரங்களுடன் செதுக்கப்பட்டுள்ளது. சக்கரங்களை சூரியக் கடிகாரமாக வாசிக்கலாம் என்று பார்வையாளர்களும் அறிஞர்களும் நீண்ட காலமாக கூறுகின்றனர்.', 'சக்கரங்கள் இலை கொடி, மணிகள், மேடாலியன் சிற்பங்களால் அலங்கரிக்கப்பட்ட கல் சிற்பக் கலைகள். ஏழு குதிரைகளில் இன்று இரண்டு மட்டுமே உள்ளன.', 'தேர் வடிவம் கோயிலை சூரியனின் பயணத்துடன் இணைக்கிறது. சூரிய உதயத்தில் முதல் கதிர்கள் கருவறையில் விழும்படி வழிபாடு நேரம் காணப்பட்டது.', 'சூரியனின் நித்திய பயணமும் காலமே கல்லில் வடிக்கப்பட்டுள்ளது என்பதை தேர் உணர்த்துகிறது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'ஜகமோகனம் (சபா மண்டபம்)', 'கருவறைக்கு முன்னால் உள்ள எஞ்சியிருக்கும் பிரமிடு கூரை மண்டபம்; வழிபாடும் இசையும் நடந்த இடம்.', 'முழுமையாக நிற்கும் முக்கிய கட்டிடம் ஜகமோகனம் ஒன்றே. மரபுப்படி, சூரியன் திருவுருவின் முன் பக்தி இசையும் நடனமும் நிகழ்த்தப்பட்ட கூட்டு மண்டபம் இது. மூன்று திசை கோட்டங்களில் சூரியனின் பெரிய சிலைகள் இன்னும் உள்ளன.', 'மூன்று அடுக்கு பிரமிடு கூரையுடன் எழும் மண்டபம்; நடனமங்கையர், இசைக்கலைஞர்கள், புராண உயிரினங்களின் சிற்பங்கள் நிறைந்தது.', 'இன்றும் இங்கு பிரார்த்தனை நடைபெறுகிறது — பக்தர்கள் விளக்கேற்றி மலர் சமர்ப்பிக்கின்றனர்; மாலை வழிபாடு சுற்று மேடையில் நடைபெறுகிறது.', 'மண்ணுலக நுழைவுக்கும் மறைந்த கருவறைக்கும் இடையிலான பாலம் ஜகமோகனம் — கோயிலின் முன்னாள் பெருமையை நினைவூட்டுகிறது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'மூலக் கருவறை (டியூல்)', 'சூரியன் திருவுருவைக் கொண்டிருந்த கருவறை — கோபுரம் வீழ்ந்துவிட்டது; ஆனால் அடித்தளம் இன்னும் பெருமை பேசுகிறது.', 'மூலக் கோபுரம் (டியூல்) ஒரு காலத்தில் ஜகமோகனத்திற்கு மேலே உயர்ந்து நின்றது. அது இன்று இல்லை — பிற்கால நூற்றாண்டுகளில் இடிந்து வீழ்ந்ததாக நம்பப்படுகிறது; வீழ்ந்த கற்கள் பிற கட்டிடங்களில் பயன்படுத்தப்பட்டதாக வரலாற்று பதிவுகள் கூறுகின்றன. அறிஞர்களின் கணிப்புப்படி மூல கோபுரம் 60 மீட்டருக்கும் மேல் உயர்ந்திருந்தது.', 'கலிங்க டியூல் அமைப்பு — அடுக்கடுக்காக குறுகும் கோபுரத்திற்கான சதுர கருவறை. எஞ்சிய சுவர்களில் சூரியனின் பெரிய உருவங்களும் நவக்கிரக சிற்பங்களும் உள்ளன.', 'சூரிய வழிபாடு பகலின் ஓட்டத்தைப் பின்பற்றுகிறது; சூரிய உதயத்தில் செய்யும் பிரார்த்தனை மங்களகரமானதாகக் கருதப்படுகிறது.', 'இடிந்த நிலையிலும், பக்தரின் பார்வையை பூமியிலிருந்து சூரியனை நோக்கி உயர்த்தும் நோக்கத்தை கருவறை வெளிப்படுத்துகிறது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'நாட்ய மண்டபம் (நடன மண்டபம்)', 'ஜகமோகனத்திற்கு முன்னால் உள்ள கூரையில்லா மண்டபம்; இசையையும் நடனத்தையும் கொண்டாடும் சிற்பங்கள்.', 'கோயிலின் மேடையாக இருந்தது நாட்ய மண்டபம் — தெய்வத்தின் முன் நடனமும் இசையும் நிகழ்ந்தன. சுவர்களில் நூற்றுக்கணக்கான நடனமங்கையர், மத்தளம் கொட்டுவோர், இசைக்கலைஞர்களின் சிற்பங்கள் உள்ளன — 13ஆம் நூற்றாண்டு ஒடிசா கலை உலகின் காட்சி.', 'உயர்த்தப்பட்ட மேடையின் சுவர்கள் இசைக்கலைஞர்கள் மற்றும் நடனமங்கையரின் தொடர் சிற்பங்கள்; மூலைகளில் மெல்லிய தூண்கள்.', 'நடனமும் இசையும் மரபாக வழிபாட்டின் ஒரு வடிவம். ஒடிசி நடன மரபு இக்கோயில் சிற்பங்களின் பாரம்பரியத்தைத் தொடர்கிறது என்று பலர் நம்புகின்றனர்.', 'கோயில் உலகில் கலை என்பது பொழுதுபோக்கல்ல, சமர்ப்பணம் — அழகே ஒரு வழிபாட்டு வடிவம் என்பதை நடன மண்டபம் நினைவூட்டுகிறது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description, story, architecture, rituals, significance)
select l.id, '10000000-0000-4000-8000-000000000004', 'கோயில் வளாகம் & மாயாதேவி கோயில்', 'பரந்த வளாகத்தில் மாயாதேவி கோயில் உள்ளிட்ட துணை சன்னதிகளும், வெளிச்சுவர்களின் எச்சங்களும் உள்ளன.', 'வளாகத்திற்குள் தொல்லியல் அறிஞர்கள் மாயாதேவி கோயில் என்று அழைக்கும் சிறிய இடிந்த கோயில் உள்ளது; அதன் மூல தெய்வம் குறித்து கருத்து வேறுபாடு உள்ளது — சில அறிஞர்கள் சூரியனின் துணைவியருடன் தொடர்புபடுத்துகின்றனர். அருகிலுள்ள தொல்லியல் அருங்காட்சியகம், இந்திய தொல்லியல் துறையால் பராமரிக்கப்படுகிறது.', 'மாயாதேவி கோயில் கலிங்க பாணியிலேயே சிறிய அளவில் அமைந்துள்ளது; அதன் சிற்ப பாணி முதன்மைக் கோயிலுக்கு முற்பட்டதாக இருக்கலாம் என்றாலும், அறிஞர்களின் கருத்துக்கள் வேறுபடுகின்றன.', 'வளாகம் பாதுகாக்கப்பட்ட நினைவுச்சின்னம்; எஞ்சிய சன்னதிகளில் உள்ளூர் பக்தர்கள் தொடர்ந்து வழிபடுகின்றனர். ஒவ்வொரு டிசம்பரிலும் நடக்கும் கொனார்க் நடன விழா, நடனத்தை சமர்ப்பணமாக்கும் மரபை மீட்டெடுக்கிறது.', 'கோயில் ஒரு முழுமையான புனித நகரம் என்பதை வளாகம் காட்டுகிறது — ஒரு கட்டிடம் அல்ல, கல்லில் வடிக்கப்பட்ட ஒரு உலகம்.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=8
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description), story=coalesce(excluded.story, public.location_translations.story), architecture=coalesce(excluded.architecture, public.location_translations.architecture), rituals=coalesce(excluded.rituals, public.location_translations.rituals), significance=coalesce(excluded.significance, public.location_translations.significance);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'ராஜராஜன் திருவாசல் (உள் வாயில்)', 'இரு வாயில்களில் உட்புறமானதும் மிகுந்த சிற்ப வேலைப்பாடு கொண்டதுமான வாயில்; நேரடியாக பெரிய திடலுக்குத் திறக்கிறது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'சோழர் ஓவிய நடைபாதை', 'கருவறையைச் சுற்றியுள்ள இருண்ட பிரகார நடைபாதை; அரிய சோழர் கால ஓவியங்களைத் தன் சுவர்களில் பாதுகாத்து வைத்துள்ளது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'அஷ்ட சக்தி மண்டபம்', 'கிழக்கு நுழைவாயிலுக்கு உள்ளே அமைந்த தூண் மண்டபம்; தேவியின் எட்டு வடிவங்களின் சிற்பங்களால் பெயர் பெற்றது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'ஊஞ்சல் மண்டபம்', 'ஒவ்வொரு வெள்ளிக்கிழமை மாலையும் தெய்வங்களின் திருவுருவங்கள் ஊஞ்சலில் எழுந்தருளும் சடங்கு மண்டபம்.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'போக மண்டபம் (நைவேத்திய மண்டபம்)', 'நுழைவுக்கு அருகில் தனித்து நிற்கும் தூண் மேடை; உணவு நைவேத்தியம் தயாரித்து சமர்ப்பிக்கப்பட்ட மண்டபமாகக் கருதப்படுகிறது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'நவகிரக பலகை', 'ஒன்பது கிரக தெய்வங்களைச் சித்தரிக்கும் பெரிய செதுக்கப்பட்ட கல் பலகை; முதலில் கோயில் வாயிலின் மேல் அமைக்கப்பட்டிருந்தது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'மகாத்வாரம் (பிரதான வாயில்)', 'பக்தர்கள் கோயிலுக்குள் நுழையும் முதன்மை கோபுர வாயில்; படிகாவலி என்றும் அழைக்கப்படுகிறது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'சம்பங்கி பிரதட்சிணம் (வெளிச் சுற்று)', 'முதல் மற்றும் இரண்டாம் மதில்களுக்கு இடையிலான வெளிப் பிரகாரம்; மண்டபங்களும் சன்னதிகளும் நிறைந்தது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'த்வஜஸ்தம்பம் (கொடிமரம்)', 'கருவறைக்கு நேர் எதிரே, கோயிலின் மைய அச்சில் நிற்கும் தங்க முலாம் பூசப்பட்ட கொடிமரம்.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'பங்காரு வாகிலி (தங்க வாயில்)', 'கருவறைக்கு முன்பான உட்புற அறையின் இறுதி நுழைவாயில்; தங்கத் தகடுகளால் மூடப்பட்டது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'ஆனந்த நிலயம் (கருவறை மற்றும் தங்க விமானம்)', 'வேங்கடேஸ்வரரின் திருவுருவம் எழுந்தருளியுள்ள கருவறை; மேலே ஆனந்த நிலயம் எனும் தங்க விமானம்.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'ஸ்வாமி புஷ்கரிணி (புனித தீர்த்தம்)', 'கோயிலுக்கு அருகிலுள்ள தீர்த்தக் குளம்; தரிசனத்திற்கு முன் பக்தர்கள் நீராடும் இடம்.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'வராகசுவாமி கோயில்', 'தீர்த்தக் கரையில் அமைந்த தனி சன்னதி; விஷ்ணுவின் வராக அவதாரத்திற்கு அர்ப்பணிக்கப்பட்டது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'கடற்கரைக் கோயில் வளாகம்', 'மூன்று சன்னதிகளைக் கொண்ட மதில் சூழ்ந்த கடற்கரை வளாகம்; வங்கக் கடலை பின்னணியாகக் கொண்ட ஒற்றைக் காட்சி.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'நந்தி மதில் சுவர்', 'கோயிலைச் சுற்றியுள்ள தாழ்வான மதில்; மேலே வரிசையாக அமர்ந்த நந்தி சிற்பங்கள்.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'க்ஷத்ரியசிம்மேஸ்வரர் (முதன்மை சிவன் சன்னதி)', 'இரு சிவ சன்னதிகளில் உயரமானது; கிழக்கு நோக்கி கடலை எதிர்கொள்கிறது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'அனந்தசயன விஷ்ணு சன்னதி', 'இரு சிவ சன்னதிகளுக்கு இடையே அமைந்த சன்னதி; இயற்கைப் பாறையிலேயே செதுக்கப்பட்ட சயன விஷ்ணு.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'பஞ்ச ரதங்கள்', 'சற்று உள்நோக்கி அமைந்த ஐந்து கோயில்கள்; ஒவ்வொன்றும் ஒற்றைக் கருங்கல் பாறையிலிருந்து செதுக்கப்பட்டவை.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'அர்ஜுனன் தபசு (கங்கை அவதரணம்)', 'இரு பாறைகளில் செதுக்கப்பட்ட மாபெரும் திறந்தவெளி சிற்பப் பலகை; உலகின் மிகப்பெரியவற்றுள் ஒன்று.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000004', 'ஒலக்கண்ணேஸ்வரர் கோயில் மற்றும் குகைக் கோயில்கள்', 'மகிஷாசுரமர்த்தினி குகைக்கு மேலே அமைந்த மலை உச்சி சன்னதி; ஊரையும் கடலையும் நோக்கியது.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'కేరళాంతకన్ తిరువాసల్ (బాహ్య ద్వారం)', 'రాజరాజ చోళుని బిరుదు పేరిట ఉన్న ఆలయ బాహ్య గోపురం. తూర్పు-పడమర అక్షంలోని రెండు ద్వారాలలో ఇది మొదటిది.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'రాజరాజన్ తిరువాసల్ (అంతర్ ద్వారం)', 'రెండు ద్వారాలలో లోపలిది, మరింత శిల్పకళాయుతమైనది; నేరుగా విశాల ప్రాంగణంలోకి తెరుచుకుంటుంది.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'నంది మండపం', 'ప్రాంగణంలోని బహిరంగ స్తంభ మండపం; గర్భగుడి వైపు చూస్తున్న అతిపెద్ద ఏకశిలా నందిని కలిగి ఉంది.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'గర్భగృహం (ప్రధాన సన్నిధి)', 'ఆలయ హృదయంలోని గర్భగుడి; బృహత్ విమానం క్రింద అతిపెద్ద శివలింగం ప్రతిష్ఠితమై ఉంది.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'చోళ కుడ్యచిత్ర మార్గం', 'గర్భగుడి చుట్టూ ఉన్న చీకటి ప్రదక్షిణ మార్గం; గోడలపై అరుదైన చోళకాలపు కుడ్యచిత్రాలు భద్రంగా ఉన్నాయి.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'మహా విమానం', 'గర్భగుడిపై పిరమిడ్ ఆకారపు శిఖరం, సుమారు 66 మీటర్ల ఎత్తు — ఈ తరహాలో ఎత్తైన ఆలయ శిఖరాలలో ఒకటి.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'ఉప సన్నిధులు', 'ప్రాంగణంలోని చిన్న సన్నిధులు — అమ్మవారు (బృహన్నాయకి), చండేశ్వరుడు మరియు తరువాతి కాలపు నిర్మాణాలు.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'మహా ప్రాకారం (ప్రాంగణం)', 'ఆలయాన్ని చుట్టుముట్టిన విశాల ప్రాకార ప్రాంగణం; అన్ని వైపులా స్తంభ మండప వరుసలు.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=8
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'గోపురాలు (ద్వార శిఖరాలు)', 'ఆలయ ప్రాకారాలపై పద్నాలుగు గోపురాలు; దక్షిణ గోపురం సుమారు 52 మీటర్లతో అత్యంత ఎత్తైనది.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'అష్ట శక్తి మండపం', 'తూర్పు ద్వారం లోపల ఉన్న స్తంభ మండపం; అమ్మవారి ఎనిమిది రూపాల శిల్పాల పేరిట పిలువబడుతుంది.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'వేయి స్తంభాల మండపం', '16వ శతాబ్దపు మండపం; సూక్ష్మంగా చెక్కిన స్తంభాలు, సంగీత ధ్వనులిచ్చే స్తంభాలకు ప్రసిద్ధి.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'మీనాక్షి సన్నిధి', 'మధురై అధిదేవత మీనాక్షి అమ్మవారి గర్భగుడి; మొత్తం సముదాయానికి కేంద్రం.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'సుందరేశ్వర సన్నిధి', 'సుందరేశ్వరుని సన్నిధి — మధురైలో శివుడు కొలువైన రూపం.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'ఊంజల్ మండపం (ఊయల మండపం)', 'ప్రతి శుక్రవారం సాయంత్రం ఉత్సవ మూర్తులను ఊయలపై ఉంచే మండపం.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'పొట్రామరై కుళం (స్వర్ణ కమల కోనేరు)', 'సముదాయం మధ్యలోని మెట్ల కోనేరు; చుట్టూ స్తంభ మండపాలు.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'కల్యాణ మండపం', 'ప్రతి సంవత్సరం దివ్య కల్యాణం జరిగే ఉత్సవ మండపం.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=8
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'సింహ ద్వారం', 'ఆలయ తూర్పు ప్రవేశం; ఏనుగులపై నిలిచిన పెద్ద సింహ శిల్పాలు కాపలా ఉన్నాయి.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'భోగ మండపం (నైవేద్య మండపం)', 'ప్రవేశం దగ్గర విడిగా నిలిచిన స్తంభ వేదిక; నైవేద్యాలు సిద్ధం చేసి సమర్పించే మండపంగా భావిస్తారు.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'నాట్య మండపం', 'ప్రధాన నిర్మాణం ముందు కప్పులేని స్తంభ వేదిక; గోడలపై నర్తకులు, వాద్యకారుల శిల్పాలు.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'రథ చక్రాలు మరియు అశ్వాలు', 'ఆలయ వేదికపై ఇరవై నాలుగు అలంకృత చక్రాలు, ముందు అశ్వ బృందాలు — ఆలయమే సూర్యుని రథం.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'జగమోహన (సభా మండపం)', 'నేటికీ నిలిచిన బృహత్ పిరమిడ్ మండపం — ఆలయంలో మిగిలిన అతిపెద్ద నిర్మాణం.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'నవగ్రహ ఫలకం', 'తొమ్మిది గ్రహ దేవతలను చిత్రించిన పెద్ద శిలాఫలకం; మొదట ఆలయ ద్వారంపై ఉండేది.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'దేవుల్ (గర్భగుడి శిథిలాలు)', 'ఒకప్పుడు సూర్య విగ్రహం ఉన్న గర్భగుడి పునాది; శిఖరం ఇప్పుడు లేదు.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'ఆలయ ప్రాంగణం మరియు మాయాదేవి ఆలయం', 'మాయాదేవి ఆలయంగా పిలిచే శిథిల సన్నిధితో సహా ఉపనిర్మాణాలున్న విశాల ప్రాంగణం.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=8
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'మహాద్వారం', 'భక్తులు ఆలయంలోకి ప్రవేశించే ప్రధాన గోపుర ద్వారం; పడికావళి అని కూడా అంటారు.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'సంపంగి ప్రదక్షిణం', 'మొదటి, రెండవ ప్రాకారాల మధ్య బాహ్య ప్రదక్షిణ మార్గం; ఇరువైపులా మండపాలు, సన్నిధులు.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'ధ్వజస్తంభం', 'గర్భగుడికి నేరుగా ఎదురుగా, ఆలయ ప్రధాన అక్షంపై నిలిచిన బంగారు తాపడపు ధ్వజస్తంభం.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'బంగారు వాకిలి', 'గర్భగుడికి ముందున్న అంతర మందిరపు చివరి బంగారు తాపడపు ద్వారం.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'ఆనంద నిలయం (గర్భగుడి మరియు బంగారు విమానం)', 'వేంకటేశ్వరుని మూలవిరాట్ కొలువైన గర్భగుడి; పైన ఆనంద నిలయం అనే బంగారు విమానం.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'స్వామి పుష్కరిణి', 'ఆలయం పక్కనే ఉన్న కోనేరు; భక్తులు దర్శనానికి ముందు స్నానం చేస్తారు.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'వరాహస్వామి ఆలయం', 'పుష్కరిణి ఒడ్డున ఉన్న ప్రత్యేక సన్నిధి; విష్ణువు వరాహ అవతారానికి అంకితం.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'తీర దేవాలయ సముదాయం', 'మూడు సన్నిధులున్న ప్రాకారయుత సముద్రతీర సముదాయం; బంగాళాఖాతం నేపథ్యంలో ఒకే దృశ్యంగా కనిపిస్తుంది.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'నంది ప్రాకారం', 'ఆలయం చుట్టూ ఉన్న పొట్టి ప్రాకారం; పైన వరుసగా కూర్చున్న నంది శిల్పాలు.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'క్షత్రియసింహేశ్వరుడు (ప్రధాన శివ సన్నిధి)', 'రెండు శివ సన్నిధులలో ఎత్తైనది; తూర్పు వైపు సముద్రాన్ని చూస్తూ ఉంటుంది.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'అనంతశయన విష్ణు సన్నిధి', 'రెండు శివ సన్నిధుల మధ్య ఉన్న సన్నిధి; సహజ శిలలోనే చెక్కిన శయన విష్ణువు.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'పంచ రథాలు', 'కొద్ది దూరంలో ఉన్న ఐదు ఆలయాలు; ప్రతి ఒక్కటీ ఒకే గ్రానైట్ శిల నుంచి చెక్కబడింది.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'అర్జున తపస్సు (గంగావతరణం)', 'రెండు పెద్ద శిలలపై చెక్కిన బృహత్ బహిరంగ శిల్పఫలకం — ప్రపంచంలోని అతిపెద్దవాటిలో ఒకటి.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000003', 'ఒలక్కణేశ్వర ఆలయం మరియు గుహాలయాలు', 'మహిషాసురమర్దిని గుహపై కొండ శిఖరాన ఉన్న సన్నిధి; పట్టణాన్ని, సముద్రాన్ని చూడవచ్చు.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'കേരളാന്തകൻ തിരുവാസൽ (പുറം കവാടം)', 'രാജരാജ ചോളന്റെ ഒരു സ്ഥാനപ്പേരിൽ അറിയപ്പെടുന്ന ക്ഷേത്രത്തിന്റെ പുറം ഗോപുരം. കിഴക്ക്-പടിഞ്ഞാറ് അക്ഷത്തിലെ രണ്ട് കവാടങ്ങളിൽ ആദ്യത്തേത്.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'രാജരാജൻ തിരുവാസൽ (അകം കവാടം)', 'രണ്ട് കവാടങ്ങളിൽ അകത്തേതും കൂടുതൽ ശിൽപഭംഗിയുള്ളതും; നേരിട്ട് വിശാലമായ മുറ്റത്തേക്ക് തുറക്കുന്നു.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'നന്ദി മണ്ഡപം', 'മുറ്റത്തെ തുറന്ന തൂൺമണ്ഡപം; ശ്രീകോവിലിന് അഭിമുഖമായി ഒറ്റക്കല്ലിൽ തീർത്ത വലിയ നന്ദി.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ഗർഭഗൃഹം (പ്രധാന ശ്രീകോവിൽ)', 'ക്ഷേത്രഹൃദയത്തിലെ ശ്രീകോവിൽ; വലിയ വിമാനത്തിന് താഴെ വളരെ വലിയ ശിവലിംഗം പ്രതിഷ്ഠിച്ചിരിക്കുന്നു.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ചോള ചുവർചിത്ര ഇടനാഴി', 'ശ്രീകോവിലിന് ചുറ്റുമുള്ള ഇരുണ്ട പ്രദക്ഷിണവഴി; ചുവരുകളിൽ അപൂർവമായ ചോളകാല ചുവർചിത്രങ്ങൾ.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'മഹാ വിമാനം', 'ശ്രീകോവിലിന് മുകളിലുള്ള പിരമിഡ് ആകൃതിയിലുള്ള ഗോപുരം, ഏകദേശം 66 മീറ്റർ ഉയരം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ഉപക്ഷേത്രങ്ങൾ', 'മുറ്റത്തിനുള്ളിലെ ചെറിയ ശ്രീകോവിലുകൾ — ദേവി (ബൃഹന്നായകി), ചണ്ഡേശ്വരൻ, പിൽക്കാല നിർമിതികൾ.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'മഹാ പ്രാകാരം (മുറ്റം)', 'ക്ഷേത്രത്തെ ചുറ്റുന്ന വിശാലമായ മതിൽക്കെട്ട് മുറ്റം; നാലുവശവും തൂൺ ഇടനാഴികൾ.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='brihadeeswarar' and l.display_order=8
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ഗോപുരങ്ങൾ', 'ക്ഷേത്രമതിലുകൾക്ക് മുകളിൽ പതിനാല് ഗോപുരങ്ങൾ; തെക്കേ ഗോപുരം ഏകദേശം 52 മീറ്ററോടെ ഏറ്റവും ഉയരമുള്ളത്.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'അഷ്ട ശക്തി മണ്ഡപം', 'കിഴക്കേ പ്രവേശനത്തിന് ഉള്ളിലുള്ള തൂൺമണ്ഡപം; ദേവിയുടെ എട്ട് രൂപങ്ങളുടെ ശിൽപങ്ങളിൽ നിന്ന് പേര്.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ആയിരം കാൽ മണ്ഡപം', 'പതിനാറാം നൂറ്റാണ്ടിലെ മണ്ഡപം; സൂക്ഷ്മമായി കൊത്തിയ തൂണുകൾക്കും സംഗീതസ്വരം പുറപ്പെടുവിക്കുന്ന തൂണുകൾക്കും പ്രശസ്തം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'മീനാക്ഷി ശ്രീകോവിൽ', 'മധുരയുടെ അധിദേവതയായ മീനാക്ഷിയുടെ ശ്രീകോവിൽ; സമുച്ചയത്തിന്റെ കേന്ദ്രം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'സുന്ദരേശ്വര ശ്രീകോവിൽ', 'സുന്ദരേശ്വരന്റെ ശ്രീകോവിൽ — മധുരയിൽ ശിവൻ ആരാധിക്കപ്പെടുന്ന രൂപം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ഊഞ്ഞാൽ മണ്ഡപം', 'എല്ലാ വെള്ളിയാഴ്ച വൈകുന്നേരവും ദേവന്മാരുടെ ഉത്സവവിഗ്രഹങ്ങൾ ഊഞ്ഞാലിൽ വയ്ക്കുന്ന മണ്ഡപം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'പൊറ്റാമരൈ കുളം (സ്വർണതാമര കുളം)', 'സമുച്ചയത്തിന്റെ മധ്യത്തിലുള്ള പടിക്കെട്ട് കുളം; ചുറ്റും തൂൺ ഇടനാഴികൾ.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'കല്യാണ മണ്ഡപം', 'എല്ലാ വർഷവും ദിവ്യവിവാഹം ആഘോഷിക്കുന്ന ചടങ്ങുമണ്ഡപം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='meenakshi' and l.display_order=8
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'സിംഹ ദ്വാരം', 'ക്ഷേത്രത്തിന്റെ കിഴക്കേ പ്രവേശനം; ആനകൾക്ക് മുകളിൽ വലിയ സിംഹശിൽപങ്ങൾ.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ഭോഗ മണ്ഡപം', 'പ്രവേശനത്തിനടുത്ത് വേറിട്ട് നിൽക്കുന്ന തൂൺവേദി; നിവേദ്യം ഒരുക്കി സമർപ്പിച്ചിരുന്ന മണ്ഡപമായി കരുതപ്പെടുന്നു.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'നാട്യ മണ്ഡപം', 'പ്രധാന ഘടനയ്ക്ക് മുന്നിലുള്ള മേൽക്കൂരയില്ലാത്ത തൂൺവേദി; ചുവരുകൾ നർത്തകരും വാദ്യക്കാരും നിറഞ്ഞത്.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'രഥചക്രങ്ങളും കുതിരകളും', 'ക്ഷേത്രവേദിയിൽ ഇരുപത്തിനാല് അലങ്കൃത ചക്രങ്ങൾ, മുന്നിൽ കുതിരക്കൂട്ടങ്ങൾ — ക്ഷേത്രം തന്നെ സൂര്യന്റെ രഥം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ജഗമോഹന (സഭാമണ്ഡപം)', 'ഇന്നും നിലനിൽക്കുന്ന വലിയ പിരമിഡ് മണ്ഡപം — ക്ഷേത്രത്തിൽ അവശേഷിക്കുന്ന ഏറ്റവും വലിയ ഘടന.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'നവഗ്രഹ ഫലകം', 'ഒൻപത് ഗ്രഹദേവതകളെ ചിത്രീകരിക്കുന്ന വലിയ കൊത്തുപലക; ആദ്യം ക്ഷേത്രവാതിലിന് മുകളിലായിരുന്നു.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ദേവുൾ (ശ്രീകോവിൽ അവശിഷ്ടം)', 'ഒരുകാലത്ത് സൂര്യവിഗ്രഹം ഉണ്ടായിരുന്ന ശ്രീകോവിലിന്റെ അടിത്തറ; ഗോപുരം ഇന്ന് നിലവിലില്ല.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ക്ഷേത്രപരിസരവും മായാദേവി ക്ഷേത്രവും', 'മായാദേവി ക്ഷേത്രം എന്നറിയപ്പെടുന്ന തകർന്ന ശ്രീകോവിൽ ഉൾപ്പെടെയുള്ള ഉപഘടനകൾ.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='konark' and l.display_order=8
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'മഹാദ്വാരം', 'തീർഥാടകർ ക്ഷേത്രത്തിൽ പ്രവേശിക്കുന്ന പ്രധാന ഗോപുരവാതിൽ; പടികാവലി എന്നും അറിയപ്പെടുന്നു.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'സമ്പംഗി പ്രദക്ഷിണം', 'ഒന്നും രണ്ടും മതിലുകൾക്കിടയിലുള്ള പുറം പ്രദക്ഷിണവഴി; ഇരുവശവും മണ്ഡപങ്ങളും ശ്രീകോവിലുകളും.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ധ്വജസ്തംഭം', 'ശ്രീകോവിലിന് നേരെ മുന്നിൽ, ക്ഷേത്രത്തിന്റെ പ്രധാന അക്ഷത്തിൽ നിൽക്കുന്ന സ്വർണം പൊതിഞ്ഞ കൊടിമരം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ബംഗാരു വാകിലി (സ്വർണവാതിൽ)', 'ശ്രീകോവിലിന് മുൻപുള്ള അകത്തെ അറയുടെ അവസാന സ്വർണവാതിൽ.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ആനന്ദ നിലയം', 'വെങ്കടേശ്വരന്റെ വിഗ്രഹമുള്ള ശ്രീകോവിൽ; മുകളിൽ ആനന്ദ നിലയം എന്ന സ്വർണവിമാനം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'സ്വാമി പുഷ്കരിണി', 'ക്ഷേത്രത്തിനടുത്തുള്ള കുളം; ദർശനത്തിന് മുൻപ് തീർഥാടകർ സ്നാനം ചെയ്യുന്നു.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'വരാഹസ്വാമി ക്ഷേത്രം', 'കുളക്കരയിലുള്ള പ്രത്യേക ശ്രീകോവിൽ; വിഷ്ണുവിന്റെ വരാഹ അവതാരത്തിന് സമർപ്പിതം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='tirumala' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ഷോർ ടെമ്പിൾ സമുച്ചയം', 'മൂന്ന് ശ്രീകോവിലുകളുള്ള മതിൽക്കെട്ട് കടലോര സമുച്ചയം; ബംഗാൾ ഉൾക്കടലിന്റെ പശ്ചാത്തലത്തിൽ ഒറ്റ ദൃശ്യം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=1
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'നന്ദി മതിൽ', 'ക്ഷേത്രത്തെ ചുറ്റുന്ന താഴ്ന്ന മതിൽ; മുകളിൽ ഇരിക്കുന്ന നന്ദി ശിൽപങ്ങളുടെ നിരകൾ.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=2
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ക്ഷത്രിയസിംഹേശ്വരൻ (പ്രധാന ശിവ ശ്രീകോവിൽ)', 'രണ്ട് ശിവ ശ്രീകോവിലുകളിൽ ഉയരമുള്ളത്; കിഴക്ക് കടലിന് അഭിമുഖം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=3
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'അനന്തശയന വിഷ്ണു ശ്രീകോവിൽ', 'രണ്ട് ശിവ ശ്രീകോവിലുകൾക്കിടയിലുള്ള ശ്രീകോവിൽ; സ്വാഭാവിക പാറയിൽ കൊത്തിയ ശയന വിഷ്ണു.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=4
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'പഞ്ച രഥങ്ങൾ', 'അൽപം ഉള്ളിലായി നിൽക്കുന്ന അഞ്ച് ക്ഷേത്രങ്ങൾ; ഓരോന്നും ഒറ്റ ഗ്രാനൈറ്റ് പാറയിൽ നിന്ന് കൊത്തിയത്.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=5
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'അർജുനന്റെ തപസ്സ് (ഗംഗാവതരണം)', 'രണ്ട് വലിയ പാറകളിൽ കൊത്തിയ കൂറ്റൻ തുറന്ന ശിൽപഫലകം — ലോകത്തിലെ ഏറ്റവും വലുതിൽ ഒന്ന്.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=6
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.location_translations (location_id, language_id, name, description)
select l.id, '10000000-0000-4000-8000-000000000005', 'ഒലക്കണേശ്വര ക്ഷേത്രവും ഗുഹാക്ഷേത്രങ്ങളും', 'മഹിഷാസുരമർദിനി ഗുഹയ്ക്ക് മുകളിൽ കുന്നിൻമുകളിലുള്ള ശ്രീകോവിൽ; നഗരവും കടലും കാണാം.' from public.temple_locations l join public.temples t on t.id=l.temple_id
where t.slug='shore-temple' and l.display_order=7
on conflict (location_id, language_id) do update set name=coalesce(excluded.name, public.location_translations.name), description=coalesce(excluded.description, public.location_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'मंदिर प्रवेश', 'हम वहीं से आरंभ करते हैं जहाँ हर तीर्थयात्री करता है — बाहरी द्वार पर। ध्यान दें यह कितना नीचा है; यह जानबूझकर है, ताकि आगे का शिखर चलते-चलते बड़ा होता जाए।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'नंदी मंडप', 'यहाँ नंदी विराजमान हैं, एक ही शिला से तराशे गए और गर्भगृह की ओर देखते हुए। उनके पीछे खड़े होइए और आपकी दृष्टि सीधे मंदिर तक जाएगी।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'मुख्य गर्भगृह', 'भीतर किसी भी भारतीय मंदिर के सबसे बड़े शिवलिंगों में से एक है। कक्ष जानबूझकर अंधकारमय रखा गया है, ताकि केवल दीपक का प्रकाश ही दिखे।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'महान विमान', 'अब ऊपर देखिए। छियासठ मीटर ग्रेनाइट, तेरह मंज़िलें, बिना गारे के जुड़ी हुईं। यही उपलब्धि तंजावुर को प्रसिद्ध बनाती है।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'उप-मंदिर', 'आँगन के चारों ओर सदियों में जोड़े गए छोटे मंदिर हैं — देवी, चंडेश्वर, और बाद के निर्माण। हर एक बड़े शिखर की छोटी प्रतिध्वनि है।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'विशाल आँगन', 'हम प्राकार में समाप्त करते हैं। दीवारों को ध्यान से देखिए — उन पर उकेरे शिलालेख ही मंदिर का हज़ार वर्ष पुराना अभिलेखागार हैं।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'गोपुरम', 'हम शिखरों के नीचे से आरंभ करते हैं। दीवारों पर चौदह गोपुरम उठते हैं, हज़ारों रंगीन मूर्तियों से ढके। ये मंदिर पहुँचने से बहुत पहले दिख जाते हैं।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'सहस्र स्तंभ मंडप', 'नक्काशीदार स्तंभों का वन — प्रायः 985 गिने जाते हैं। कुछ पतले स्तंभ थपथपाने पर संगीत के स्वर देते हैं।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'मीनाक्षी मंदिर', 'मदुरै का हृदय। एक असामान्य बात ध्यान दें: यहाँ देवी, न कि उनके पति, मंदिर की प्रधान देवता हैं।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'सुंदरेश्वर मंदिर', 'उनके पास सुंदरेश्वर के रूप में शिव विराजमान हैं। दोनों मंदिर मिलकर पूरे परिसर की योजना निर्धारित करते हैं।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'स्वर्ण कमल सरोवर', 'केंद्र में सीढ़ीदार सरोवर। परंपरा इसे मदुरै की प्राचीन साहित्य सभाओं से जोड़ती है — एक कथा जो नगर बहुत लंबे समय से कहता आया है।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'विवाह मंडप', 'हम वहाँ समाप्त करते हैं जहाँ नगर एकत्र होता है। प्रतिवर्ष यहाँ दिव्य विवाह मनाया जाता है और पूरा मदुरै उसमें सम्मिलित होता है।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'सिंह द्वार', 'पूर्व से आइए, जैसा निर्माताओं ने चाहा था। हाथियों के ऊपर दो विशाल सिंह — यहाँ आने वाले को सबसे पहले यही दिखना था।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'रथ के पहिये', 'चबूतरे पर चौबीस पहिये हैं। पूरा मंदिर एक रथ है, और छाया के आधार पर इन पहियों को सूर्य-घड़ी की तरह पढ़ा जा सकता है।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'नृत्य मंडप', 'यह खुला चबूतरा मंदिर का रंगमंच था। इसकी दीवारें नर्तकों और वादकों से भरी हैं — तेरहवीं शताब्दी की प्रस्तुति का चित्र।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'जगमोहन', 'वह विशाल मंडप जो आज भी खड़ा है। तीन दिशाओं के आलों में सूर्य की प्रतिमाएँ देखिए — वे बची रहीं, जबकि शिखर नहीं बचा।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'गर्भगृह अवशेष', 'यहाँ कभी गर्भगृह का शिखर उठता था। वह क्यों गिरा, इस पर इतिहासकार आज भी विचार करते हैं। जो शेष है वह भी दृष्टि को ऊपर ले जाता है।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'व्यापक परिसर', 'हम परिसर में छोटे मायादेवी मंदिर के साथ समाप्त करते हैं। कोणार्क कभी एक इमारत नहीं था — यह एक नियोजित पवित्र परिसर था।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'मुख्य प्रवेशद्वार', 'हमारी यात्रा महाद्वार से आरंभ होती है। अधिकांश तीर्थयात्रियों के लिए यह क्षण घंटों की प्रतीक्षा और पहाड़ी चढ़ने के बाद आता है।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'बाहरी परिक्रमा', 'हम बाहरी परिक्रमा करते हैं। चारों ओर के मंडपों पर सदियों के दानों के शिलालेख हैं, जिनमें कई विजयनगर शासकों के हैं।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'ध्वजस्तंभ', 'स्वर्णमंडित ध्वजस्तंभ ठीक देवता की सीध में खड़ा है। वार्षिक उत्सव आरंभ होने पर यहीं ध्वज फहराया जाता है।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'स्वर्ण द्वार', 'दो द्वार शेष हैं — पहले रजत, फिर यह स्वर्ण द्वार। हर देहरी संसार को थोड़ा और सीमित करती जाती है।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'आनंद निलयम', 'स्वर्ण विमान के नीचे गर्भगृह। यहाँ पूजा भोर से पहले सुप्रभातम् से आरंभ होती है।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'पवित्र सरोवर', 'हम स्वामी पुष्करिणी पर समाप्त करते हैं, जहाँ तीर्थयात्री दर्शन से पूर्व स्नान करते हैं और प्रतिवर्ष तेप्पोत्सवम् होता है।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'तट मंदिर', 'हम समुद्र की पृष्ठभूमि में पूरी आकृति से आरंभ करते हैं। याद रखिए: यह तराशे हुए खंडों से बना है, शिला से काटा नहीं गया — और इसी ने सब बदल दिया।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'नंदी प्राचीर', 'प्राचीर पर बैठे नंदियों की पंक्तियाँ हैं, जो नमकीन हवा से घिस चुकी हैं। यह क्षरण भी स्मारक के इतिहास का भाग है।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'मुख्य मंदिर', 'ऊँचा शिखर पूर्व की ओर, बंगाल की खाड़ी के सूर्योदय की ओर मुख किए है। यह आकृति सदियों तक दक्षिण भारत में दोहराई गई।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'शयन विष्णु', 'दोनों शिव मंदिरों के बीच मूल शिला से तराशे गए विष्णु हैं — उनके चारों ओर बनी दीवारों से भी पुराने।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'पंच रथ', 'पाँच मंदिर, प्रत्येक एक ही शिला से, प्रत्येक भिन्न छत के साथ। ये पत्थर में किए गए स्थापत्य प्रयोग हैं।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000002', 'अर्जुन की तपस्या', 'हम विशाल उत्कीर्णन पर समाप्त करते हैं। यह क्या दर्शाता है — अर्जुन की तपस्या या गंगावतरण — इस पर विद्वान आज भी विचार करते हैं।' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'கோயில் நுழைவு', 'எல்லா பக்தர்களும் தொடங்கும் இடத்திலிருந்து தொடங்குங்கள்: கேரளாந்தகன் திருவாசல் கோபுரத்தின் கீழ் கிழக்கு வாயில்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'நந்தி மண்டபம்', 'கருவறையை நோக்கிய திறந்த மண்டபத்தில் பெரிய நந்தியை சந்தியுங்கள் — பக்தர்களைப் போல ஒரு கணம் மனதை அமைதிப்படுத்துங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'கருவறை', 'இருண்ட கருவறைக்குள் நடந்து, கோயிலின் இதயமான பெருவுடையார் சிவலிங்கத்தின் முன் நில்லுங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'பெரிய விமானம்', '66 மீட்டர் உயர கோபுரத்தை நிமிர்ந்து பாருங்கள் — சோழர் பொறியியலின் முடிசூடா படைப்பு, தேவர்களின் மலை.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'துணை சன்னதிகள்', 'தேவி மற்றும் சண்டிகேஸ்வரரின் சிறிய சன்னதிகளுக்குச் சென்று, தெய்வ குடும்பம் திடலை எவ்வாறு நிரப்புகிறது என்பதைக் காணுங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'கோயில் திடல்', 'பரந்த பிரகாரத்தை வலம் வந்து, ஆயிரம் ஆண்டு திருவிழாக்களையும் இசையையும் சுற்று மண்டபங்களில் உணருங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'கோயில் கோபுரங்கள்', 'உயர்ந்த தெற்கு கோபுரத்தின் கீழ் நுழையுங்கள் — கோயில் நகரை அறிவிக்கும் வண்ண சிற்ப மலை.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'ஆயிரம் கால் மண்டபம்', '985 செதுக்கப்பட்ட தூண்களின் காட்டில் நடந்து, இசைக்கருவிகள் போல ஒலிக்கும் இசைத் தூண்களைக் கேளுங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'மீனாட்சி சன்னதி', 'மதுரையின் இதயத்தை அடையுங்கள் — நகரம் சுழலும் மீனாட்சி தாயாரின் கருவறை.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'சுந்தரேஸ்வரர் சன்னதி', 'அரசியின் அருகில் எழுந்தருளியுள்ள மதுரையின் சிவனான அழகிய இறைவனை வணங்குங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'பொற்றாமரைக் குளம்', 'மரபுப்படி திருக்கல்யாணம் நடந்த புனித குளக்கரையில் ஓய்வெடுங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'கல்யாண மண்டபம்', 'சடங்கு மண்டபத்தில் திருக்கல்யாண ஓவியங்களைக் கண்டு, சித்திரை திருவிழாவின் பெருமையை கற்பனை செய்யுங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'சிங்க வாயில்', 'கட்டிடக் கலைஞர்கள் கருதியபடியே கோயிலை அணுகுங்கள் — கிழக்கு சிம்ஹ துவாரம் வழியாக.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'கல் தேர்', 'சூரியக் கடவுளின் தேரின் பெரிய சக்கரங்களை வலம் வந்து, கல்லில் அமைந்த புகழ்பெற்ற கடிகாரத்தைக் காணுங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'நாட்ய மண்டபம்', 'ஆயிரம் ஆண்டுகளுக்கு முன் சூரியனுக்கு இசையும் நடனமும் சமர்ப்பிக்கப்பட்ட மேடையில் நில்லுங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'ஜகமோகனம்', 'எஞ்சியிருக்கும் சபா மண்டபத்திற்குள் நுழைந்து, திசை கோட்டங்களில் செதுக்கப்பட்ட சூரியனைப் பாருங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'மூலக் கருவறை', 'மறைந்த மூலக் கோபுரத்தின் அடித்தளத்தை அடைந்து, ஒரு காலத்தில் உயர்ந்து நின்ற டியூலை கற்பனை செய்யுங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'கோயில் வளாகம்', 'மாயாதேவி கோயிலையும் பரந்த புனித திடலையும் ஆராய்ந்து, கல்லில் வடிக்கப்பட்ட உலகைக் காணுங்கள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'பிரதான வாயில்', 'நமது பயணம் மகாத்வாரத்தில் தொடங்குகிறது. பெரும்பாலான பக்தர்களுக்கு இக்கணம் பல மணி நேர காத்திருப்புக்குப் பின், மலையேறியப் பின் வருகிறது.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'வெளிச் சுற்று', 'வெளிப் பிரகாரத்தை வலம் வருகிறோம். சுற்றியுள்ள மண்டபங்களில் நூற்றாண்டுகளின் கொடைகளைப் பதிவு செய்யும் கல்வெட்டுகள் உள்ளன.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'கொடிமரம்', 'தங்கக் கொடிமரம் மூலவருக்கு நேர் எதிரே நிற்கிறது. ஆண்டு பிரம்மோற்சவம் தொடங்கும்போது இங்கு கொடி ஏற்றப்படுகிறது.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'தங்க வாயில்', 'இரு வாயில்கள் மீதம் — ஒன்று வெள்ளி, பின் இந்தத் தங்க வாயில். ஒவ்வொரு வாயிலும் உலகைச் சுருக்குகிறது.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'ஆனந்த நிலயம்', 'தங்க விமானத்தின் கீழ் கருவறை. விடியலுக்கு முன் சுப்ரபாதத்துடன் வழிபாடு தொடங்குகிறது.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'புனித தீர்த்தம்', 'ஸ்வாமி புஷ்கரிணியில் நிறைவு — தரிசனத்திற்கு முன் பக்தர்கள் நீராடும், ஆண்டுதோறும் தெப்போற்சவம் நடக்கும் இடம்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'கடற்கரைக் கோயில்', 'கடலை பின்னணியாகக் கொண்ட முழு உருவத்துடன் தொடங்குகிறோம். இது பாறையில் செதுக்கப்படவில்லை — வெட்டப்பட்ட கற்களால் கட்டப்பட்டது.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'நந்தி மதில்', 'வரிசையாக அமர்ந்த நந்திகள் மதிலை அலங்கரிக்கின்றன; உப்புக் காற்றால் மென்மையாகத் தேய்ந்தவை.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'முதன்மை சன்னதி', 'உயரமான கோபுரம் கிழக்கு நோக்கி, வங்கக் கடலின் சூரிய உதயத்தை எதிர்கொள்கிறது.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'சயன விஷ்ணு', 'இரு சிவ சன்னதிகளுக்கு இடையே இயற்கைப் பாறையில் செதுக்கப்பட்ட சயன விஷ்ணு — சுற்றிக் கட்டப்பட்ட சுவர்களை விடப் பழையது.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'பஞ்ச ரதங்கள்', 'ஐந்து சன்னதிகள், ஒவ்வொன்றும் ஒற்றைப் பாறையில், ஒவ்வொன்றும் வெவ்வேறு கூரை வடிவம் — கல்லில் செய்யப்பட்ட கட்டிடச் சோதனைகள்.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000004', 'அர்ஜுனன் தபசு', 'மாபெரும் சிற்பப் பலகையில் நிறைவு. அது என்ன காட்டுகிறது என்பதில் அறிஞர்களிடையே இன்றும் விவாதம் உள்ளது.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'ఆలయ ప్రవేశం', 'ప్రతి భక్తుడు మొదలుపెట్టే చోటే మనమూ మొదలుపెడదాం — బాహ్య ద్వారం. ఇది ఎంత పొట్టిగా ఉందో చూడండి; ఇది ఉద్దేశపూర్వకమే, ముందున్న శిఖరం నడుస్తున్న కొద్దీ పెద్దదిగా కనిపించాలని.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'నంది మండపం', 'ఇక్కడ ఒకే శిలతో చెక్కిన నంది గర్భగుడి వైపు చూస్తూ కూర్చున్నాడు. ఆయన వెనుక నిలబడితే మీ చూపు నేరుగా సన్నిధికి చేరుతుంది.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'ప్రధాన గర్భగుడి', 'లోపల భారతదేశపు అతిపెద్ద శివలింగాలలో ఒకటి ఉంది. గది ఉద్దేశపూర్వకంగా చీకటిగా ఉంచబడింది — దీపకాంతి మాత్రమే కనిపించేలా.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'మహా విమానం', 'ఇప్పుడు పైకి చూడండి. అరవై ఆరు మీటర్ల గ్రానైట్, పదమూడు అంతస్తులు, సున్నం లేకుండా అమర్చినవి. ఇదే తంజావూరుకు కీర్తి తెచ్చిన ఘనత.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'ఉప సన్నిధులు', 'ప్రాంగణం చుట్టూ శతాబ్దాలుగా చేర్చిన చిన్న సన్నిధులు — అమ్మవారు, చండేశ్వరుడు, తరువాతి నిర్మాణాలు. ప్రతి ఒక్కటీ మహా విమానానికి చిన్న ప్రతిధ్వని.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'మహా ప్రాంగణం', 'ప్రాకారంలో ముగిద్దాం. గోడలను నిశితంగా చూడండి — వాటిపై చెక్కిన శాసనాలే ఆలయపు వెయ్యేళ్ల పురాతన రికార్డు.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'గోపురాలు', 'గోపురాల క్రింద నుంచి మొదలుపెడదాం. ప్రాకారాలపై పద్నాలుగు గోపురాలు, వేలాది రంగుల శిల్పాలతో. ఆలయం చేరకముందే ఇవి కనిపిస్తాయి.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'వేయి స్తంభాల మండపం', 'చెక్కిన స్తంభాల అరణ్యం — సాధారణంగా 985గా లెక్కిస్తారు. కొన్ని సన్నని స్తంభాలు తట్టినప్పుడు సంగీత స్వరాలిస్తాయి.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'మీనాక్షి సన్నిధి', 'మధురై హృదయం. ఒక విశేషం గమనించండి: ఇక్కడ అమ్మవారే ప్రధాన దేవత, ఆమె భర్త కాదు.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'సుందరేశ్వర సన్నిధి', 'ఆమె పక్కనే సుందరేశ్వరుడిగా శివుడు కొలువై ఉన్నాడు. ఈ రెండు సన్నిధులే మొత్తం సముదాయ నిర్మాణాన్ని నిర్ణయిస్తాయి.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'స్వర్ణ కమల కోనేరు', 'మధ్యలోని మెట్ల కోనేరు. మధురై ప్రాచీన సాహిత్య సభలతో సంప్రదాయం దీన్ని ముడిపెడుతుంది — నగరం చాలాకాలంగా చెప్పుకుంటున్న కథ.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'కల్యాణ మండపం', 'నగరం సమావేశమయ్యే చోట ముగిద్దాం. ప్రతి సంవత్సరం ఇక్కడ దివ్య కల్యాణం జరుగుతుంది, మధురై మొత్తం పాల్గొంటుంది.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'సింహ ద్వారం', 'నిర్మాతలు ఉద్దేశించినట్టే తూర్పు నుంచి రండి. ఏనుగులపై రెండు పెద్ద సింహాలు — ఇక్కడికి వచ్చినవారు మొదట చూడాల్సింది ఇదే.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'రథ చక్రాలు', 'వేదికపై ఇరవై నాలుగు చక్రాలు. ఆలయమే ఒక రథం, నీడలను బట్టి ఈ చక్రాలను సూర్య గడియారంగా చదవవచ్చు.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'నాట్య మండపం', 'ఈ బహిరంగ వేదిక ఆలయ రంగస్థలం. గోడలు నర్తకులు, మృదంగ వాద్యకారులతో నిండి ఉన్నాయి — పదమూడవ శతాబ్దపు ప్రదర్శన చిత్రం.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'జగమోహన', 'నేటికీ నిలిచిన బృహత్ మండపం. మూడు దిక్కుల గూళ్లలో సూర్య విగ్రహాలను చూడండి — శిఖరం పోయినా అవి మిగిలాయి.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'గర్భగుడి శిథిలాలు', 'ఇక్కడ ఒకప్పుడు గర్భగుడి శిఖరం ఉండేది. అది ఎందుకు కూలిందనేది చరిత్రకారులు ఇప్పటికీ చర్చిస్తారు. మిగిలినది కూడా చూపును పైకి లాగుతుంది.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'విశాల ప్రాంగణం', 'చిన్న మాయాదేవి ఆలయంతో ప్రాంగణంలో ముగిద్దాం. కోణార్క్ ఎప్పుడూ ఒక్క కట్టడం కాదు — అది ఒక ప్రణాళికాబద్ధ పవిత్ర క్షేత్రం.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'మహాద్వారం', 'మన యాత్ర మహాద్వారం వద్ద మొదలవుతుంది. చాలామంది భక్తులకు ఈ క్షణం గంటల నిరీక్షణ తర్వాత, కొండ ఎక్కిన తర్వాత వస్తుంది.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'బాహ్య ప్రదక్షిణం', 'బాహ్య ప్రదక్షిణ చేద్దాం. చుట్టూ ఉన్న మండపాలపై శతాబ్దాల దానాలను నమోదు చేసిన శాసనాలున్నాయి — చాలావరకు విజయనగర రాజులవి.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'ధ్వజస్తంభం', 'బంగారు ధ్వజస్తంభం స్వామివారికి నేరుగా ఎదురుగా ఉంది. వార్షిక బ్రహ్మోత్సవాలు మొదలైనప్పుడు ఇక్కడే ధ్వజారోహణం జరుగుతుంది.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'బంగారు వాకిలి', 'రెండు ద్వారాలు మిగిలాయి — ముందు వెండి, తర్వాత ఈ బంగారు వాకిలి. ప్రతి గడప ప్రపంచాన్ని మరింత కుదిస్తుంది.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'ఆనంద నిలయం', 'బంగారు విమానం క్రింద గర్భగుడి. ఇక్కడ పూజ తెల్లవారుజామున సుప్రభాతంతో మొదలవుతుంది.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'స్వామి పుష్కరిణి', 'పుష్కరిణి వద్ద ముగిద్దాం — భక్తులు దర్శనానికి ముందు స్నానం చేసే, ఏటా తెప్పోత్సవం జరిగే చోటు.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'తీర దేవాలయం', 'సముద్ర నేపథ్యంలో మొత్తం రూపంతో మొదలుపెడదాం. గుర్తుంచుకోండి: ఇది శిలను చెక్కి కాదు, కోసిన దిమ్మెలతో కట్టినది — అదే అన్నింటినీ మార్చింది.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'నంది ప్రాకారం', 'ప్రాకారంపై వరుసగా కూర్చున్న నందులు, ఉప్పు గాలికి అరిగిపోయాయి. ఆ క్షయం కూడా ఈ స్మారక చరిత్రలో భాగమే.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'ప్రధాన సన్నిధి', 'ఎత్తైన శిఖరం తూర్పు వైపు, బంగాళాఖాతంలో సూర్యోదయం వైపు చూస్తుంది. ఈ రూపం శతాబ్దాలపాటు దక్షిణ భారతమంతా అనుకరించబడింది.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'శయన విష్ణువు', 'రెండు శివ సన్నిధుల మధ్య సహజ శిలలో చెక్కిన విష్ణువు — చుట్టూ కట్టిన గోడల కంటే పురాతనమైనవాడు.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'పంచ రథాలు', 'ఐదు సన్నిధులు, ప్రతి ఒక్కటీ ఒకే శిల నుంచి, ప్రతి ఒక్కటీ వేరే కప్పు ఆకారంతో. ఇవి రాతిలో చేసిన నిర్మాణ ప్రయోగాలు.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000003', 'అర్జున తపస్సు', 'బృహత్ శిల్పఫలకం వద్ద ముగిద్దాం. ఇది ఏమి చూపిస్తుందనే దానిపై పండితులు ఇప్పటికీ చర్చిస్తున్నారు.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'ക്ഷേത്ര പ്രവേശനം', 'എല്ലാ തീർഥാടകരും തുടങ്ങുന്നിടത്ത് നമ്മളും തുടങ്ങാം — പുറം കവാടത്തിൽ. അത് എത്ര താഴ്ന്നതാണെന്ന് ശ്രദ്ധിക്കൂ; അത് മനഃപൂർവമാണ്.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'നന്ദി മണ്ഡപം', 'ഒറ്റക്കല്ലിൽ തീർത്ത നന്ദി ശ്രീകോവിലിന് അഭിമുഖമായി ഇരിക്കുന്നു. അദ്ദേഹത്തിന് പിന്നിൽ നിന്നാൽ നിങ്ങളുടെ കണ്ണ് നേരെ ശ്രീകോവിലിലെത്തും.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'പ്രധാന ശ്രീകോവിൽ', 'ഇന്ത്യൻ ക്ഷേത്രങ്ങളിലെ ഏറ്റവും വലിയ ശിവലിംഗങ്ങളിൽ ഒന്ന് ഇവിടെയുണ്ട്. വിളക്കിന്റെ വെളിച്ചം മാത്രം കാണാൻ പാകത്തിൽ അറ ഇരുണ്ടതാക്കിയിരിക്കുന്നു.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'മഹാ വിമാനം', 'ഇനി മുകളിലേക്ക് നോക്കൂ. അറുപത്തിയാറ് മീറ്റർ ഗ്രാനൈറ്റ്, പതിമൂന്ന് നിലകൾ, കുമ്മായമില്ലാതെ ചേർത്തത്. ഇതാണ് തഞ്ചാവൂരിനെ പ്രശസ്തമാക്കിയത്.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'ഉപക്ഷേത്രങ്ങൾ', 'മുറ്റത്ത് നൂറ്റാണ്ടുകളായി കൂട്ടിച്ചേർത്ത ചെറിയ ശ്രീകോവിലുകളുണ്ട് — ദേവി, ചണ്ഡേശ്വരൻ, പിൽക്കാല നിർമിതികൾ.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'മഹാ മുറ്റം', 'പ്രാകാരത്തിൽ അവസാനിപ്പിക്കാം. ചുവരുകൾ സൂക്ഷ്മമായി നോക്കൂ — അവയിലെ ശിലാലിഖിതങ്ങളാണ് ക്ഷേത്രത്തിന്റെ ആയിരം വർഷം പഴക്കമുള്ള രേഖാശേഖരം.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='brihadeeswarar' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'ഗോപുരങ്ങൾ', 'ഗോപുരങ്ങൾക്ക് താഴെ നിന്ന് തുടങ്ങാം. മതിലുകൾക്ക് മുകളിൽ പതിനാല് ഗോപുരങ്ങൾ, ആയിരക്കണക്കിന് ചായംപൂശിയ ശിൽപങ്ങളാൽ നിറഞ്ഞത്.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'ആയിരം കാൽ മണ്ഡപം', 'കൊത്തുപണിയുള്ള തൂണുകളുടെ വനം — സാധാരണ 985 എന്ന് എണ്ണപ്പെടുന്നു. ചില തൂണുകൾ തട്ടുമ്പോൾ സംഗീതസ്വരം പുറപ്പെടുവിക്കുന്നു.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'മീനാക്ഷി ശ്രീകോവിൽ', 'മധുരയുടെ ഹൃദയം. ഒരു പ്രത്യേകത ശ്രദ്ധിക്കൂ: ഇവിടെ ദേവിയാണ് പ്രധാന പ്രതിഷ്ഠ, അവളുടെ ഭർത്താവല്ല.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'സുന്ദരേശ്വര ശ്രീകോവിൽ', 'അവൾക്കരികിൽ സുന്ദരേശ്വരനായി ശിവൻ. രണ്ട് ശ്രീകോവിലുകളും ചേർന്നാണ് സമുച്ചയത്തിന്റെ മുഴുവൻ രൂപരേഖയും നിശ്ചയിക്കുന്നത്.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'സ്വർണതാമര കുളം', 'മധ്യത്തിലെ പടിക്കെട്ട് കുളം. പാരമ്പര്യം ഇതിനെ മധുരയുടെ പ്രാചീന സാഹിത്യസഭകളുമായി ബന്ധിപ്പിക്കുന്നു.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'കല്യാണ മണ്ഡപം', 'നഗരം ഒത്തുകൂടുന്നിടത്ത് അവസാനിപ്പിക്കാം. എല്ലാ വർഷവും ഇവിടെ ദിവ്യവിവാഹം ആഘോഷിക്കുന്നു, മധുര മുഴുവൻ പങ്കെടുക്കുന്നു.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='meenakshi' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'സിംഹ ദ്വാരം', 'നിർമാതാക്കൾ ഉദ്ദേശിച്ചതുപോലെ കിഴക്കുനിന്ന് വരൂ. ആനകൾക്ക് മുകളിൽ രണ്ട് വലിയ സിംഹങ്ങൾ — ഇവിടെയെത്തുന്നവർ ആദ്യം കാണേണ്ടത് ഇതാണ്.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'രഥചക്രങ്ങൾ', 'വേദിയിൽ ഇരുപത്തിനാല് ചക്രങ്ങൾ. ക്ഷേത്രം മുഴുവൻ ഒരു രഥമാണ്, നിഴൽ നോക്കി ഈ ചക്രങ്ങളെ സൂര്യഘടികാരമായി വായിക്കാം.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'നാട്യ മണ്ഡപം', 'ഈ തുറന്ന വേദി ക്ഷേത്രത്തിന്റെ അരങ്ങായിരുന്നു. ചുവരുകൾ നർത്തകരും ചെണ്ടക്കാരും നിറഞ്ഞത് — പതിമൂന്നാം നൂറ്റാണ്ടിലെ അവതരണത്തിന്റെ ചിത്രം.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'ജഗമോഹന', 'ഇന്നും നിലനിൽക്കുന്ന വലിയ മണ്ഡപം. മൂന്ന് വശങ്ങളിലെ മാടങ്ങളിൽ സൂര്യന്റെ വിഗ്രഹങ്ങൾ നോക്കൂ — ഗോപുരം പോയിട്ടും അവ അവശേഷിക്കുന്നു.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'ശ്രീകോവിൽ അവശിഷ്ടങ്ങൾ', 'ഇവിടെ ഒരുകാലത്ത് ശ്രീകോവിൽ ഗോപുരം ഉയർന്നുനിന്നിരുന്നു. അത് എന്തുകൊണ്ട് വീണു എന്നത് ചരിത്രകാരന്മാർ ഇന്നും ചർച്ച ചെയ്യുന്നു.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'വിശാല പരിസരം', 'ചെറിയ മായാദേവി ക്ഷേത്രത്തോടെ പരിസരത്ത് അവസാനിപ്പിക്കാം. കൊണാർക്ക് ഒരിക്കലും ഒറ്റ കെട്ടിടമായിരുന്നില്ല.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='konark' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'മഹാദ്വാരം', 'നമ്മുടെ യാത്ര മഹാദ്വാരത്തിൽ തുടങ്ങുന്നു. മിക്ക തീർഥാടകർക്കും ഈ നിമിഷം മണിക്കൂറുകളുടെ കാത്തിരിപ്പിനും മലകയറ്റത്തിനും ശേഷമാണ് വരുന്നത്.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'പുറം പ്രദക്ഷിണം', 'പുറം പ്രദക്ഷിണം നടത്താം. ചുറ്റുമുള്ള മണ്ഡപങ്ങളിൽ നൂറ്റാണ്ടുകളുടെ ദാനങ്ങൾ രേഖപ്പെടുത്തിയ ശിലാലിഖിതങ്ങളുണ്ട്.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'ധ്വജസ്തംഭം', 'സ്വർണം പൊതിഞ്ഞ കൊടിമരം ദേവന് നേരെ മുന്നിലാണ്. വാർഷിക ഉത്സവം തുടങ്ങുമ്പോൾ ഇവിടെയാണ് കൊടിയേറ്റം.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'സ്വർണവാതിൽ', 'രണ്ട് വാതിലുകൾ ബാക്കി — ആദ്യം വെള്ളി, പിന്നെ ഈ സ്വർണവാതിൽ. ഓരോ പടിയും ലോകത്തെ കുറേക്കൂടി ചുരുക്കുന്നു.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'ആനന്ദ നിലയം', 'സ്വർണവിമാനത്തിന് താഴെ ശ്രീകോവിൽ. ഇവിടെ പൂജ പുലർച്ചെ സുപ്രഭാതത്തോടെ ആരംഭിക്കുന്നു.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'സ്വാമി പുഷ്കരിണി', 'പുഷ്കരിണിയിൽ അവസാനിപ്പിക്കാം — ദർശനത്തിന് മുൻപ് തീർഥാടകർ സ്നാനം ചെയ്യുന്ന, എല്ലാ വർഷവും തെപ്പോത്സവം നടക്കുന്ന സ്ഥലം.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='tirumala' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'ഷോർ ടെമ്പിൾ', 'കടലിന്റെ പശ്ചാത്തലത്തിൽ മുഴുവൻ രൂപത്തിൽ തുടങ്ങാം. ഓർക്കുക: ഇത് പാറ കൊത്തിയതല്ല, മുറിച്ച കട്ടകൾ കൊണ്ട് പണിതതാണ്.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=1
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'നന്ദി മതിൽ', 'മതിലിന് മുകളിൽ ഇരിക്കുന്ന നന്ദികളുടെ നിരകൾ, ഉപ്പുകാറ്റിൽ തേഞ്ഞവ. ആ തേയ്മാനവും സ്മാരകത്തിന്റെ ചരിത്രത്തിന്റെ ഭാഗമാണ്.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=2
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'പ്രധാന ശ്രീകോവിൽ', 'ഉയരമുള്ള ഗോപുരം കിഴക്കോട്ട്, ബംഗാൾ ഉൾക്കടലിലെ സൂര്യോദയത്തിന് അഭിമുഖം. ഈ രൂപം നൂറ്റാണ്ടുകളോളം ദക്ഷിണേന്ത്യയിൽ അനുകരിക്കപ്പെട്ടു.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=3
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'ശയന വിഷ്ണു', 'രണ്ട് ശിവ ശ്രീകോവിലുകൾക്കിടയിൽ സ്വാഭാവിക പാറയിൽ കൊത്തിയ വിഷ്ണു — ചുറ്റും പണിത ചുവരുകളേക്കാൾ പഴക്കമുള്ളത്.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=4
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'പഞ്ച രഥങ്ങൾ', 'അഞ്ച് ശ്രീകോവിലുകൾ, ഓരോന്നും ഒറ്റ പാറയിൽ നിന്ന്, ഓരോന്നും വ്യത്യസ്ത മേൽക്കൂരയോടെ. കല്ലിൽ നടത്തിയ വാസ്തുപരീക്ഷണങ്ങൾ.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=5
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

insert into public.guided_step_translations (step_id, language_id, title, description)
select gs.id, '10000000-0000-4000-8000-000000000005', 'അർജുനന്റെ തപസ്സ്', 'കൂറ്റൻ ശിൽപഫലകത്തിൽ അവസാനിപ്പിക്കാം. ഇത് എന്താണ് കാണിക്കുന്നതെന്ന് പണ്ഡിതർ ഇന്നും ചർച്ച ചെയ്യുന്നു.' from public.guided_steps gs join public.temples t on t.id=gs.temple_id
where t.slug='shore-temple' and gs.step_number=6
on conflict (step_id, language_id) do update set title=coalesce(excluded.title, public.guided_step_translations.title), description=coalesce(excluded.description, public.guided_step_translations.description);

commit;
