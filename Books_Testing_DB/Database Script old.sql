--
-- PostgreSQL database dump
--

-- Dumped from database version 15.0
-- Dumped by pg_dump version 15rc2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: BooksShop; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "BooksShop" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE "BooksShop" OWNER TO postgres;

\connect "BooksShop"

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: blog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blog (
    blog_id character varying(200) DEFAULT concat('a', public.uuid_generate_v4()) NOT NULL,
    blog_title character varying(200) NOT NULL,
    description text NOT NULL,
    date_posted date DEFAULT (now())::date,
    user_id character varying(200),
    book_id character varying(200),
    CONSTRAINT blog_description_check CHECK ((description <> ''::text)),
    CONSTRAINT blog_title_check CHECK (((blog_title)::text <> ''::text))
);


ALTER TABLE public.blog OWNER TO postgres;

--
-- Name: book; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book (
    book_id character varying(200) DEFAULT concat('a', public.uuid_generate_v4()) NOT NULL,
    price real NOT NULL,
    title character varying(200) NOT NULL,
    date_published date DEFAULT (now())::date NOT NULL,
    chapters integer DEFAULT 1,
    sequel character varying(200),
    part integer DEFAULT 1,
    rating smallint DEFAULT 5,
    age_rating smallint DEFAULT 1,
    accepted boolean DEFAULT false,
    is_borrow boolean DEFAULT false,
    description text NOT NULL,
    photo text DEFAULT 'https://www.adobe.com/express/discover/ideas/media_110fb8e290d4ad589cc095e1477bc30064f972deb.png?width=750&format=png&optimize=medium'::text,
    CONSTRAINT book_age_rating_check CHECK ((age_rating > 0)),
    CONSTRAINT book_chapters_check CHECK ((chapters > 0)),
    CONSTRAINT book_description_check CHECK ((description <> ''::text)),
    CONSTRAINT book_part_check CHECK ((part > 0)),
    CONSTRAINT book_price_check CHECK ((price > (0)::double precision)),
    CONSTRAINT book_rating_check CHECK (((rating >= 0) AND (rating <= 5))),
    CONSTRAINT book_sequel_check CHECK (((sequel)::text <> ''::text)),
    CONSTRAINT book_title_check CHECK (((title)::text <> ''::text))
);


ALTER TABLE public.book OWNER TO postgres;

--
-- Name: book_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.book_tag (
    book_id character varying(200) NOT NULL,
    tag_id character varying(50) NOT NULL
);


ALTER TABLE public.book_tag OWNER TO postgres;

--
-- Name: borrow; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.borrow (
    user_id character varying(200) NOT NULL,
    book_id character varying(200) NOT NULL,
    return_date date DEFAULT ((now())::date + 7) NOT NULL,
    returned boolean DEFAULT false
);


ALTER TABLE public.borrow OWNER TO postgres;

--
-- Name: events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.events (
    event_id character varying(200) DEFAULT concat('a', public.uuid_generate_v4()) NOT NULL,
    place character varying(200) NOT NULL,
    tickets integer NOT NULL,
    ticket_price real NOT NULL,
    title character varying(200) NOT NULL,
    due_to date NOT NULL,
    description text NOT NULL,
    event_photo text DEFAULT 'https://i.ibb.co/NsqDXy2/Jill-Wide-Crowd-Good.jpg'::text,
    CONSTRAINT events_description_check CHECK ((description <> ''::text)),
    CONSTRAINT events_place_check CHECK (((place)::text <> ''::text)),
    CONSTRAINT events_ticket_price_check CHECK ((ticket_price > (0)::double precision)),
    CONSTRAINT events_tickets_check CHECK ((tickets > 0)),
    CONSTRAINT events_title_check CHECK (((title)::text <> ''::text))
);


ALTER TABLE public.events OWNER TO postgres;

--
-- Name: go_to; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.go_to (
    event_id character varying(200) NOT NULL,
    user_id character varying(200) NOT NULL,
    no_tickets integer NOT NULL,
    CONSTRAINT go_to_no_tickets_check CHECK ((no_tickets > 0))
);


ALTER TABLE public.go_to OWNER TO postgres;

--
-- Name: my_order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.my_order (
    order_id character varying(200) DEFAULT concat('a', public.uuid_generate_v4()) NOT NULL,
    user_id character varying(200),
    book_id character varying(200),
    assign_date date DEFAULT (now())::date,
    is_completed boolean DEFAULT false NOT NULL,
    qty smallint DEFAULT 1 NOT NULL,
    CONSTRAINT my_order_qty_check CHECK ((qty >= 1))
);


ALTER TABLE public.my_order OWNER TO postgres;

--
-- Name: rate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rate (
    user_id character varying(200) NOT NULL,
    book_id character varying(200) NOT NULL,
    rate smallint NOT NULL,
    CONSTRAINT rate_rate_check CHECK (((rate >= 0) AND (rate <= 5)))
);


ALTER TABLE public.rate OWNER TO postgres;

--
-- Name: reader; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.reader (
    user_id character varying(200) DEFAULT concat('a', public.uuid_generate_v4()) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    username character varying(50) NOT NULL,
    pass character varying(500) NOT NULL,
    birthdate date NOT NULL,
    balance integer DEFAULT 0,
    gender boolean NOT NULL,
    profile_pic text DEFAULT 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png'::text,
    cover text DEFAULT 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg'::text,
    user_type character varying(50) DEFAULT 'reader'::character varying,
    city character varying(50),
    join_date date DEFAULT CURRENT_DATE,
    CONSTRAINT reader_balance_check CHECK ((balance >= 0)),
    CONSTRAINT reader_birthdate_check CHECK ((birthdate < (now())::date)),
    CONSTRAINT reader_city_check CHECK (((city)::text <> ''::text)),
    CONSTRAINT reader_first_name_check CHECK ((((first_name)::text ~ '^[a-zA-Z0-9.,-]+$'::text) AND ((first_name)::text <> ''::text))),
    CONSTRAINT reader_last_name_check CHECK ((((last_name)::text ~ '^[a-zA-Z0-9.,-]+$'::text) AND ((last_name)::text <> ''::text))),
    CONSTRAINT reader_pass_check CHECK (((pass)::text <> ''::text)),
    CONSTRAINT reader_username_check CHECK (((username)::text <> ''::text))
);


ALTER TABLE public.reader OWNER TO postgres;

--
-- Name: review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review (
    review_id character varying(200) DEFAULT concat('a', public.uuid_generate_v4()) NOT NULL,
    user_id character varying(200),
    book_id character varying(200),
    review_content text NOT NULL,
    review_date date DEFAULT (now())::date,
    CONSTRAINT review_review_content_check CHECK ((review_content <> ''::text))
);


ALTER TABLE public.review OWNER TO postgres;

--
-- Name: session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.session (
    sid character varying NOT NULL,
    sess json NOT NULL,
    expire timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.session OWNER TO postgres;

--
-- Name: stat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stat (
    vist_date date DEFAULT (now())::date NOT NULL,
    seconds integer DEFAULT 0,
    no_visits integer DEFAULT 0
);


ALTER TABLE public.stat OWNER TO postgres;

--
-- Name: ttt; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ttt
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ttt OWNER TO postgres;

--
-- Name: tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tag (
    tag_id character varying(50) DEFAULT ('T'::text || nextval('public.ttt'::regclass)) NOT NULL,
    tag_name character varying(50) NOT NULL
);


ALTER TABLE public.tag OWNER TO postgres;

--
-- Name: user_tag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_tag (
    user_id character varying(200) NOT NULL,
    tag_id character varying(50) NOT NULL
);


ALTER TABLE public.user_tag OWNER TO postgres;

--
-- Name: writes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.writes (
    author_id character varying(200) NOT NULL,
    book_id character varying(200) NOT NULL
);


ALTER TABLE public.writes OWNER TO postgres;

--
-- Data for Name: blog; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.blog VALUES
	('ac68da7d3-ef45-4e5f-b28e-8389149fe446', 'Harry Potter and the Goblet of Fire and What I wished', 'CONSTANT VIGILANCE From a Behind-the-Scenes documentary found on the DVD Extras, we hear Moody say his famous "Constant Vigilance" line. This scene is also found in the script where it is extended. After asking about the Unforgivable Curses, Moody reveals that he has done background checks on the entire class. He calls Hermione out for being top of the class, naturally inquisitive, socially inept and Muggle born. kill me please', '2022-12-12', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba'),
	('a1f4b79b0-fd3a-4b7a-9b51-6a42104b42f1', 'Harry Potter and the Order of the Phoenix, the dark side', 'If there was only one thing I was allowed to say about this novel, it would be this: "I hate Delores Umbridge!!!" a sentiment, I know, is shared by many, if not all, Potterheads. Unlike the first four novels in this enticing series, I was less familiar with the many events that take place in this fifth installment, as it’s the longest book and also the worst movie, in my opinion. The movie itself was excessively choppy and off-kilter, as far as I’m concerned, so I didn’t watch it as much as the first four movies. But, where the movie is stifling and inconsistent, the novel contains in-depth detail and really brings home the many atrocities and difficulties that Harry and his true friends face during their fifth year at Hogwarts, and re-reading this novel has given me a new appreciation for the storyline that the movie so vastly failed to portray.', '2022-10-14', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1'),
	('a03d34408-e087-4838-9aaf-f9bab3d4e090', 'Book Review – Harry Potter and the Deathly Hallows', 'Harry Potter is about a boy whose parents were killed by one of the most powerful wizards, Voldemort, and Harry and his two best friends, Ron Weasley and Hermione Granger from Hogwarts School of Witchcraft and Wizardry, are out for revenge and to kill Voldemort. But Voldemort split his soul into 7 pieces and hid them; those pieces are called horcruxes, and Harry has to find them and destroy them.', '2022-11-03', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'af60e0930-c4c8-4bea-ba38-e5723cdfe8d4'),
	('a570221f8-6d37-4505-ab2c-dcda3823ed80', 'The Best Fantasy Book EVER', 'Imagine trying to study for a test, not only at a regular school, but one for wizards, and also fearing that a monster will petrify you. That’s how Harry Potter feels. The Chamber of Secrets is open, muggle wizards are being petrified, and there’s a mysterious person who might know something about this. Also, could Harry be the descendant of Slytherin? All these thoughts and more are appearing in your mind as you read Harry Potter and the Chamber of Secrets. This book was written by J.K. Rowling and was published 1998. The synopsis of the plot is that Harry is back at Hogwarts and is again in the crosshairs of evil. With the Chamber of Secrets, known to be a legend in itself, open, muggle wizards are in a petrified state. Now it is up to Harry, Ron, and Hermione to save the school once again from a certain evil. When I was reading this book it was like a roller coaster of surprises that would leave anyone with a gaping mouth from a shocking twist. The characters are mostly the same as we have seen them. With Harry, being what seems to be on the outside an average boy, but as the book says “Harry Potter wasn’t a normal boy. As a matter of fact, he was not normal as it is possible to be.”', '2022-12-17', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'abc1faf97-ff30-4a1a-bf5d-578696825258'),
	('a84691c47-50da-420d-ae50-a49b9dc53f9b', 'Death Note', 'A two-hour "Director s Cut" compilation television film, titled Death Note: Relight: Visions of a God, aired on NTV a few months after the anime concluded.[3] Although advertised to be the "complete conclusion", the popularity of the series inspired the release of a second TV special, titled Death Note: Relight 2: L s Successors nearly a year later. These specials recap the first and second arcs of the anime, respectively, with new scenes added to fill in any plot holes resulted from omitted footage &lt;script&gt;alert( hello )&lt;/script&gt;', '2022-12-27', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a5c5ccab2-c9eb-436f-9167-80e84b1bb897'),
	('a96a1545c-8a7a-42a7-ad6a-2bc09f5d34ee', 'best book ever', 'this blog is a test ', '2023-09-30', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a448f1202-a573-4817-a201-12442c695ef1');


--
-- Data for Name: book; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.book VALUES
	('a448f1202-a573-4817-a201-12442c695ef1', 140, 'Harry Potter And The Order Of The Phoenix', '2003-06-21', 38, 'Harry Potter and the Goblet of Fire', 1, 5, 5, true, false, 'The fifth adventure in the spellbinding Harry Potter saga – the series that changed the world of books forever. Dark times have come to Hogwarts. After the Dementors’ attack on his cousin Dudley, Harry Potter knows that Voldemort will stop at nothing to find him. There are many who deny the Dark Lord’s return, but Harry is not alone: a secret order gathers at Grimmauld Place to fight against the Dark forces. Harry must allow Professor Snape to teach him how to protect himself from Voldemort’s savage assaults on his mind. But they are growing stronger by the day and Harry is running out of time. These classic editions of J.K. Rowling’s internationally bestselling, multi-award-winning series feature thrilling jackets by Jonny Duddle, bringing Harry Potter to the next generation of young readers. Its time to PASS THE MAGIC ON', 'https://m.media-amazon.com/images/I/71+TMmKfv9L.jpg'),
	('a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', 590, 'Harry Potter and the Prisoner of Azkaban', '1999-07-08', 22, 'Harry Potter and the Chamber of Secrets', 1, 3, 5, true, false, 'This special edition of HARRY POTTER AND THE PRISONER OF AZKABAN has a gorgeous new cover illustrated by Kazu Kibuishi. Inside is the full text of the original novel, with decorations by Mary GrandPre. For twelve long years, the dread fortress of Azkaban held an infamous prisoner named Sirius Black. Convicted of killing thirteen people with a single curse, he was said to be the heir apparent to the Dark Lord, Voldemort. Now he has escaped, leaving only two clues as to where he might be headed: Harry Potter’s defeat of You-Know-Who was Black’s downfall as well. And the Azkaban guards heard Black muttering in his sleep, "He’s at Hogwarts... he’s at Hogwarts." Harry Potter isn’t safe, not even within the walls of his magical school, surrounded by his friends. Because on top of it all, there may be a traitor in their midst.', 'https://m.media-amazon.com/images/I/714hT0XFZpL.jpg'),
	('abc1faf97-ff30-4a1a-bf5d-578696825258', 175, 'Harry Potter and the Chamber of Secrets', '1998-07-02', 18, 'Harry Potter and the Philosopher Stone', 1, 2, 5, true, false, 'The Dursleys were so mean and hideous that summer that all Harry Potter wanted was to get back to the Hogwarts School for Witchcraft and Wizardry. But just as he\s packing his bags, Harry receives a warning from a strange, impish creature named Dobby who says that if Harry Potter returns to Hogwarts, disaster will strike. And strike it does. For in Harry\s second year at Hogwarts, fresh torments and horrors arise, including an outrageously stuck-up new professor, Gilderoy Lockheart, a spirit named Moaning Myrtle who haunts the girls bathroom, and the unwanted attentions of Ron Weasley\s younger sister, Ginny. But each of these seem minor annoyances when the real trouble begins, and someone—or something—starts turning Hogwarts students to stone. Could it be Draco Malfoy, a more poisonous rival than ever? Could it possibly be Hagrid, whose mysterious past is finally told? Or could it be the one everyone at Hogwarts most suspects...Harry Potter himself?', 'https://m.media-amazon.com/images/I/91HHqVTAJQL.jpg'),
	('a964791fc-da74-4fc3-829b-a7dd08badcf5', 400, 'Game of Thrones: A Storm of Swords', '2000-08-08', 82, 'Game of Thrones: A Clash of Kings', 1, 3, 5, true, false, 'Here is the third volume in George R. R. Martin’s magnificent cycle of novels that includes A Game of Thrones and A Clash of Kings. As a whole, this series comprises a genuine masterpiece of modern fantasy, bringing together the best the genre has to offer. Magic, mystery, intrigue, romance, and adventure fill these pages and transport us to a world unlike any we have ever experienced. Already hailed as a classic, George R. R. Martin’s stunning series is destined to stand as one of the great achievements of imaginative fiction. A STORM OF SWORDS. Of the five contenders for power, one is dead, another in disfavor, and still the wars rage as violently as ever, as alliances are made and broken. Joffrey, of House Lannister, sits on the Iron Throne, the uneasy ruler of the land of the Seven Kingdoms. His most bitter rival, Lord Stannis, stands defeated and disgraced, the victim of the jealous sorceress who holds him in her evil thrall. But young Robb, of House Stark, still rules the North from the fortress of Riverrun. Robb plots against his despised Lannister enemies, even as they hold his sister hostage at King’s Landing, the seat of the Iron Throne. Meanwhile, making her way across a blood-drenched continent is the exiled queen, Daenerys, mistress of the only three dragons still left in the world. But as opposing forces maneuver for the final titanic showdown, an army of barbaric wildlings arrives from the outermost line of civilization. In their vanguard is a horde of mythical Others—a supernatural army of the living dead whose animated corpses are unstoppable. As the future of the land hangs in the balance, no one will rest until the Seven Kingdoms have exploded in a veritable storm of swords.', 'https://m.media-amazon.com/images/I/91d-77kn-dL.jpg'),
	('a3f72645a-13e8-4592-888e-5b8ae3f6a796', 10, 'Harry Potter', '2006-12-15', 106, 'hs', 1, 1, 5, true, false, 'lol', 'https://i.ibb.co/tQqW6qM/New-WOrld-299x449.jpg'),
	('a5c5ccab2-c9eb-436f-9167-80e84b1bb897', 300, 'Death Note', '2006-10-15', 106, '\N', 1, 1, 3, true, false, 'A high school student named Light Turner discovers a mysterious notebook that has the power to kill anyone whose name is written within its pages, and launches a secret crusade to rid the world of criminals.Light Turner, a bright student, stumbles across a mystical notebook that has the power to kill any person whose name he writes in it. Light decides to launch a secret crusade to rid the streets of criminals. Soon, the student-turned-vigilante finds himself pursued by a famous detective known only by the alias L.', 'https://i.ibb.co/kHPYSxR/51514203.jpg'),
	('ad94b33ea-34b9-4cad-a5d8-383b18eccc26', 170, 'Harry Potter and the Philosopher Stone', '1997-06-26', 17, '\N', 1, 1, 4, true, false, 'The first adventure in the spellbinding Harry Potter saga – the series that changed the world of books forever. Harry Potter has never even heard of Hogwarts when the letters start dropping on the doormat at number four, Privet Drive. Addressed in green ink on yellowish parchment with a purple seal, they are swiftly confiscated by his grisly aunt and uncle. Then, on Harry’s eleventh birthday, a great beetle-eyed giant of a man called Rubeus Hagrid bursts in with some astonishing news: Harry Potter is a wizard, and he has a place at Hogwarts School of Witchcraft and Wizardry. An incredible adventure is about to begin! These classic editions of J.K. Rowling’s internationally bestselling, multi-award-winning series feature thrilling jackets by Jonny Duddle, bringing Harry Potter to the next generation of young readers.time to PASS THE MAGIC ON', 'https://catalogue.immateriel.fr/resources/dd/e5/8b4eb256331805a7ba3bf4f18c182d253197d4d97853c0ef3347911b6340.jpg'),
	('aa640c333-89c7-4a23-b5fe-486b7873c136', 500, 'Palace of Desire', '1957-05-15', 16, '\N', 1, 1, 4, true, false, 'The plot continues the story of al-Sayyid Ahmad s family as the patriarch loosens his once strangling grip of control over his wife and children. His sons grapple with love and loss and their place in the changing world of colonial Egypt. The father is forced to confront his age and difficulties that come with having adult children you can no longer control.', 'https://i.ibb.co/yhNvdYY/images.jpg'),
	('a9b700fd0-9713-4c0a-9145-55d5bfa0e000', 280, 'The Things We Cannot Say: A heart-breaking, inspiring novel of hope and a love to defy all odds in World War Two', '2019-02-26', 14, '\N', 1, 1, 5, true, false, 'In 1942, Europe remains in the relentless grip of war. Just beyond the tents of the refugee camp she calls home, a young woman speaks her wedding vows. It’s a decision that will alter her destiny…and it’s a lie that will remain buried until the next century. Since she was nine years old, Alina Dziak knew she would marry her best friend, Tomasz. Now fifteen and engaged, Alina is unconcerned by reports of Nazi soldiers at the Polish border, believing her neighbors that they pose no real threat, and dreams instead of the day Tomasz returns from college in Warsaw so they can be married. But little by little, injustice by brutal injustice, the Nazi occupation takes hold, and Alina’s tiny rural village, its families, are divided by fear and hate. Then, as the fabric of their lives is slowly picked apart, Tomasz disappears. Where Alina used to measure time between visits from her beloved, now she measures the spaces between hope and despair, waiting for word from Tomasz and avoiding the attentions of the soldiers who patrol her parents’ farm. But for now, even deafening silence is preferable to grief.', 'https://i.ibb.co/4TGN3F5/9780733639197.jpg'),
	('aee18d3bb-b473-454f-a429-4ef9d85d4275', 400, 'Game of Thrones: A Dance with Dragons', '2011-07-12', 73, 'Game of Thrones: A Feast for Crows', 1, 5, 5, true, false, 'Dubbed “the American Tolkien” by Time magazine, George R. R. Martin has earned international acclaim for his monumental cycle of epic fantasy. Now the #1 New York Times bestselling author delivers the fifth book in his landmark series—as both familiar faces and surprising new forces vie for a foothold in a fragmented empire. A DANCE WITH DRAGONS In the aftermath of a colossal battle, the future of the Seven Kingdoms hangs in the balance—beset by newly emerging threats from every direction. In the east, Daenerys Targaryen, the last scion of House Targaryen, rules with her three dragons as queen of a city built on dust and death. But Daenerys has thousands of enemies, and many have set out to find her. As they gather, one young man embarks upon his own quest for the queen, with an entirely different goal in mind. Fleeing from Westeros with a price on his head, Tyrion Lannister, too, is making his way to Daenerys. But his newest allies in this quest are not the rag-tag band they seem, and at their heart lies one who could undo Daenerys’s claim to Westeros forever. Meanwhile, to the north lies the mammoth Wall of ice and stone—a structure only as strong as those guarding it. There, Jon Snow, 998th Lord Commander of the Night’s Watch, will face his greatest challenge. For he has powerful foes not only within the Watch but also beyond, in the land of the creatures of ice. From all corners, bitter conflicts reignite, intimate betrayals are perpetrated, and a grand cast of outlaws and priests, soldiers and skinchangers, nobles and slaves, will face seemingly insurmountable obstacles. Some will fail, others will grow in the strength of darkness. But in a time of rising restlessness, the tides of destiny and politics will lead inevitably to the greatest dance of all.', 'https://m.media-amazon.com/images/I/81e1rZDeBBL.jpg'),
	('a17973a0f-28f5-487c-9d16-5d03f27232e6', 400, 'Ribbons of Scarlet: A Novel of the French Revolution s Women', '2019-10-01', 20, '\N', 1, 1, 5, true, false, 'Ribbons of Scarlet is a timely story of the power of women to start a revolution—and change the world. In late eighteenth-century France, women do not have a place in politics. But as the tide of revolution rises, women from gilded salons to the streets of Paris decide otherwise—upending a world order that has long oppressed them. Blue-blooded Sophie de Grouchy believes in democracy, education, and equal rights for women, and marries the only man in Paris who agrees. Emboldened to fight the injustices of King Louis XVI, Sophie aims to prove that an educated populace can govern itself but one of her students, fruit-seller Louise Audu, is hungrier for bread and vengeance than learning. When the Bastille falls and Louise leads a women’s march to Versailles, the monarchy is forced to bend, but not without a fight. The king’s pious sister Princess Elisabeth takes a stand to defend her brother, spirit her family to safety, and restore the old order, even at the risk of her head. But when fanatics use the newspapers to twist the revolution’s ideals into a new tyranny, even the women who toppled the monarchy are threatened by the guillotine. Putting her faith in the pen, brilliant political wife Manon Roland tries to write a way out of France’s blood-soaked Reign of Terror while pike-bearing Pauline Leon and steely Charlotte Corday embrace violence as the only way to save the nation. With justice corrupted by revenge, all the women must make impossible choices to survive unless unlikely heroine and courtesan’s daughter Emilie de Sainte-Amaranthe can sway the man who controls France’s fate: the fearsome Robespierre.', 'https://i.ibb.co/gT2v49M/9158u9-QZhd-L.jpg'),
	('a4d0ebcef-d918-482e-96f2-e0781d8cc401', 130, 'The Things We Cannot Say', '2019-02-26', 9, '\N', 1, 1, 5, true, false, 'In 1942, Europe remains in the relentless grip of war. Just beyond the tents of the refugee camp she calls home, a young woman speaks her wedding vows. It’s a decision that will alter her destiny…and it’s a lie that will remain buried until the next century. Since she was nine years old, Alina Dziak knew she would marry her best friend, Tomasz. Now fifteen and engaged, Alina is unconcerned by reports of Nazi soldiers at the Polish border, believing her neighbors that they pose no real threat, and dreams instead of the day Tomasz returns from college in Warsaw so they can be married. But little by little, injustice by brutal injustice, the Nazi occupation takes hold, and Alina’s tiny rural village, its families, are divided by fear and hate. Then, as the fabric of their lives is slowly picked apart, Tomasz disappears. Where Alina used to measure time between visits from her beloved, now she measures the spaces between hope and despair, waiting for word from Tomasz and avoiding the attentions of the soldiers who patrol her parents’ farm. But for now, even deafening silence is preferable to grief.', 'https://i.ibb.co/4TGN3F5/9780733639197.jpg'),
	('afaf05d6d-6e86-4505-90ae-9de4c3a0c5aa', 120, 'Eat That Frog!', '2017-12-20', 12, '\N', 1, 1, 5, true, false, 'There just isn’t enough time for everything on our ‘To Do’ list – and there never will be. Successful people don’t try to do everything. They learn to focus on the most important tasks and make sure they get done.', 'https://i.ibb.co/sWcN3Bv/9781444765427.jpg'),
	('a18eac441-660b-44d5-89e7-b8d918690545', 320, 'Game of Thrones: A Game of Thrones', '1996-08-01', 73, '\N', 1, 3, 5, true, false, 'Winter is coming. Such is the stern motto of House Stark, the northernmost of the fiefdoms that owe allegiance to King Robert Baratheon in far-off King’s Landing. There Eddard Stark of Winterfell rules in Robert’s name. There his family dwells in peace and comfort: his proud wife, Catelyn; his sons Robb, Brandon, and Rickon; his daughters Sansa and Arya; and his bastard son, Jon Snow. Far to the north, behind the towering Wall, lie savage Wildings and worse—unnatural things relegated to myth during the centuries-long summer, but proving all too real and all too deadly in the turning of the season. Yet a more immediate threat lurks to the south, where Jon Arryn, the Hand of the King, has died under mysterious circumstances. Now Robert is riding north to Winterfell, bringing his queen, the lovely but cold Cersei, his son, the cruel, vainglorious Prince Joffrey, and the queen’s brothers Jaime and Tyrion of the powerful and wealthy House Lannister—the first a swordsman without equal, the second a dwarf whose stunted stature belies a brilliant mind. All are heading for Winterfell and a fateful encounter that will change the course of kingdoms. Meanwhile, across the Narrow Sea, Prince Viserys, heir of the fallen House Targaryen, which once ruled all of Westeros, schemes to reclaim the throne with an army of barbarian Dothraki—whose loyalty he will purchase in the only coin left to him: his beautiful yet innocent sister, Daenerys.', 'https://m.media-amazon.com/images/I/A1MExOEakfL.jpg'),
	('a2c6d5466-b154-47b1-b23b-63a73ec9f76c', 400, 'Game of Thrones: A Feast for Crows', '2005-10-17', 46, 'Game of Thrones: A Storm of Swords', 1, 4, 5, true, false, 'Few books have captivated the imagination and won the devotion and praise of readers and critics everywhere as has George R. R. Martin’s monumental epic cycle of high fantasy. Now, in A Feast for Crows, Martin delivers the long-awaited fourth book of his landmark series, as a kingdom torn asunder finds itself at last on the brink of peace . . . only to be launched on an even more terrifying course of destruction.\n\nA FEAST FOR CROWS\n\nIt seems too good to be true. After centuries of bitter strife and fatal treachery, the seven powers dividing the land have decimated one another into an uneasy truce. Or so it appears. . . . With the death of the monstrous King Joffrey, Cersei is ruling as regent in King’s Landing. Robb Stark’s demise has broken the back of the Northern rebels, and his siblings are scattered throughout the kingdom like seeds on barren soil. Few legitimate claims to the once desperately sought Iron Throne still exist—or they are held in hands too weak or too distant to wield them effectively. The war, which raged out of control for so long, has burned itself out.\n\nBut as in the aftermath of any climactic struggle, it is not long before the survivors, outlaws, renegades, and carrion eaters start to gather, picking over the bones of the dead and fighting for the spoils of the soon-to-be dead. Now in the Seven Kingdoms, as the human crows assemble over a banquet of ashes, daring new plots and dangerous new alliances are formed, while surprising faces—some familiar, others only just appearing—are seen emerging from an ominous twilight of past struggles and chaos to take up the challenges ahead.\n\nIt is a time when the wise and the ambitious, the deceitful and the strong will acquire the skills, the power, and the magic to survive the stark and terrible times that lie before them. It is a time for nobles and commoners, soldiers and sorcerers, assassins and sages to come together and stake their fortunes . . . and their lives. For at a feast for crows, many are the guests—but only a few are the survivors.', 'https://m.media-amazon.com/images/I/81MylCMYnVL.jpg');


--
-- Data for Name: book_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.book_tag VALUES
	('ad94b33ea-34b9-4cad-a5d8-383b18eccc26', 'T1001'),
	('a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', 'T1001'),
	('a964791fc-da74-4fc3-829b-a7dd08badcf5', 'T1029'),
	('a964791fc-da74-4fc3-829b-a7dd08badcf5', 'T1001'),
	('a18eac441-660b-44d5-89e7-b8d918690545', 'T1029'),
	('a18eac441-660b-44d5-89e7-b8d918690545', 'T1001'),
	('a2c6d5466-b154-47b1-b23b-63a73ec9f76c', 'T1029'),
	('a2c6d5466-b154-47b1-b23b-63a73ec9f76c', 'T1001'),
	('aee18d3bb-b473-454f-a429-4ef9d85d4275', 'T1029'),
	('aee18d3bb-b473-454f-a429-4ef9d85d4275', 'T1001'),
	('a448f1202-a573-4817-a201-12442c695ef1', 'T1004'),
	('af60e0930-c4c8-4bea-ba38-e5723cdfe8d4', 'T1004'),
	('a5bf054bd-1ef9-48bb-9822-89ef233e2672', 'T1004'),
	('aff44ed70-623b-465f-a2d9-d01161c29eba', 'T1004'),
	('a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', 'T1004'),
	('ad94b33ea-34b9-4cad-a5d8-383b18eccc26', 'T1004'),
	('a5c5ccab2-c9eb-436f-9167-80e84b1bb897', 'T1004'),
	('a5c5ccab2-c9eb-436f-9167-80e84b1bb897', 'T1001'),
	('a5c5ccab2-c9eb-436f-9167-80e84b1bb897', 'T1009'),
	('a5c5ccab2-c9eb-436f-9167-80e84b1bb897', 'T1008'),
	('a5c5ccab2-c9eb-436f-9167-80e84b1bb897', 'T1029'),
	('a3f72645a-13e8-4592-888e-5b8ae3f6a796', 'T1017'),
	('a3f72645a-13e8-4592-888e-5b8ae3f6a796', 'T1006'),
	('a3f72645a-13e8-4592-888e-5b8ae3f6a796', 'T1016'),
	('a3f72645a-13e8-4592-888e-5b8ae3f6a796', 'T1007'),
	('a3f72645a-13e8-4592-888e-5b8ae3f6a796', 'T1025'),
	('a3f72645a-13e8-4592-888e-5b8ae3f6a796', 'T1002'),
	('a3f72645a-13e8-4592-888e-5b8ae3f6a796', 'T1024'),
	('aa640c333-89c7-4a23-b5fe-486b7873c136', 'T1017'),
	('aa640c333-89c7-4a23-b5fe-486b7873c136', 'T1015'),
	('aa640c333-89c7-4a23-b5fe-486b7873c136', 'T1029'),
	('aa640c333-89c7-4a23-b5fe-486b7873c136', 'T1005'),
	('a436d387f-e238-4706-82e5-8f23f1192fe7', 'T1029'),
	('a436d387f-e238-4706-82e5-8f23f1192fe7', 'T1005'),
	('a17973a0f-28f5-487c-9d16-5d03f27232e6', 'T1012'),
	('ad4463d0f-5ff1-453d-95a4-211fa84a02eb', 'T1024'),
	('ad4463d0f-5ff1-453d-95a4-211fa84a02eb', 'T1009'),
	('ad4463d0f-5ff1-453d-95a4-211fa84a02eb', 'T1008'),
	('ad4463d0f-5ff1-453d-95a4-211fa84a02eb', 'T1029'),
	('ad4463d0f-5ff1-453d-95a4-211fa84a02eb', 'T1023'),
	('a203f12d4-db96-4579-8b6f-0280fd42c420', 'T1005'),
	('a9b700fd0-9713-4c0a-9145-55d5bfa0e000', 'T1017'),
	('a9b700fd0-9713-4c0a-9145-55d5bfa0e000', 'T1008'),
	('a9b700fd0-9713-4c0a-9145-55d5bfa0e000', 'T1026'),
	('a9b700fd0-9713-4c0a-9145-55d5bfa0e000', 'T1005'),
	('a4d0ebcef-d918-482e-96f2-e0781d8cc401', 'T1017'),
	('a4d0ebcef-d918-482e-96f2-e0781d8cc401', 'T1026'),
	('a4d0ebcef-d918-482e-96f2-e0781d8cc401', 'T1005'),
	('afaf05d6d-6e86-4505-90ae-9de4c3a0c5aa', 'T1019'),
	('afaf05d6d-6e86-4505-90ae-9de4c3a0c5aa', 'T1025'),
	('afaf05d6d-6e86-4505-90ae-9de4c3a0c5aa', 'T1024'),
	('afaf05d6d-6e86-4505-90ae-9de4c3a0c5aa', 'T1018');


--
-- Data for Name: borrow; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.borrow VALUES
	('a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a5c5ccab2-c9eb-436f-9167-80e84b1bb897', '2023-10-07', true),
	('a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aee18d3bb-b473-454f-a429-4ef9d85d4275', '2023-10-07', true);


--
-- Data for Name: events; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.events VALUES
	('ab02903df-eeb3-4378-a0d5-9658bc232fcf', 'tokyo,japan', 1998, 500, 'Tokyo Goul Cosplay Event', '2023-04-23', 'Tokyo Ghoul (Japanese: µ¥▒Σ║¼σû░τ¿«πâêπâ╝πé¡πâºπâ╝πâ╝πé░πâ╝πâ½, Hepburn: T┼ìky┼ì G┼½ru) is a Japanese dark fantasy manga series written and illustrated by Sui Ishida. It was serialized in Shueisha s seinen manga magazine Weekly Young Jump between September 2011 and September 2014, and was collected in fourteen tank┼ìbon volumes. A prequel, titled Tokyo Ghoul [Jack], ran online on Jump Live in 2013 and was collected in a single tank┼ìbon volume. A sequel, titled Tokyo Ghoul:re, was serialized in Weekly Young Jump between October 2014 and July 2018, and was collected in sixteen tank┼ìbon volumes. The story is set in a world where humans and vicious species, known as ghouls, creatures that look like normal people but can only survive by eating human flesh, live among the human population in secrecy.', 'https://i.ibb.co/Dzyd1gn/1969348.jpg'),
	('a57c7ba28-8061-4ab4-ae7b-89d79eb36ea9', 'Pyramids,Giza,Egypt', 500, 1000, 'J. K. Rowling Signing Books!!', '2022-12-31', 'The amazing author of the Harry Potter series is coming to Egypt to make a great festival and sign books for fans.', 'https://i.ibb.co/NsqDXy2/Jill-Wide-Crowd-Good.jpg'),
	('a82a4040c-0734-4760-a02f-86498e19057c', 'Haram,giza', 199, 30, 'Night of the sky in darkness', '2023-02-10', 'Night (also described as night time, unconventionally spelled as "nite") is the period of ambient darkness from sunset to sunrise during each 24-hour day, when the Sun is below the horizon. The exact time when night begins and ends depends on the location and varies throughout the year, based on factors such as season and latitude.\r\n\r\nThe word can be used in a different sense as the time between bedtime and morning. In common communication, the word night is used as a farewell ("good night", sometimes shortened to "night"), mainly when someone is going to sleep or leaving.[1]\r\n\r\nAstronomical night is the period between astronomical dusk and astronomical dawn when the Sun is between 18 and 90 degrees below the horizon and does not illuminate the sky. As seen from latitudes between about 48.56┬░ and 65.73┬░ north or south of the Equator, complete darkness does not occur around the summer solstice because, although the Sun sets, it is never more than 18┬░ below the horizon at lower culmination, ΓêÆ90┬░ Sun angles occur at the Tropic of Cancer on the December solstice and Tropic of Capricorn on the June solstice, and at the equator on equinoxes. And as seen from latitudes greater than 72┬░ north or south of the equator, complete darkness does not occur both equinoxes because, although the Sun sets, it is never more than 18┬░ below the horizon.', 'https://i.ibb.co/L6gpPcC/5462979.jpg'),
	('a26b8bac8-136a-4196-9a5d-a33a8f4c2fed', 'Elkolia', 10, 12, 'Youm Taslem El Project', '2022-12-30', 'Rabna ya3diha 3la 5eir\r\nkan nefsy a7ot 5 tickets bs lakn samy 3amlha min = 10 7asbi allah fih\r\n', 'https://i.ibb.co/CQSLfqF/image.jpg'),
	('a6afa766c-ce9d-4d44-abad-df251fdacce0', 'Tokyo, Japan', 200, 50, 'IN-PERSON: AN EVENING WITH ROY FIRESTONE', '2023-05-18', 'Broadcaster, journalist, and entertainer Roy Firestone offers original observations, essays, profiles, storytelling, and revealing interviews in a fast-paced, bite-sized, breezy style. Firestone tells stories with some amazing surprise endings, reflecting on his life, his 40-year career in broadcasting, and the people heΓÇÖs most admired along the way', 'https://i.ibb.co/WyG48NS/Untitled-2160-1080-px-46-2.png'),
	('a55c8a538-8680-47fd-847f-48179bf43123', 'el dokki,Giza,Egypt', 1497, 200, 'Death Note', '2023-10-15', 'No matter how authentic your description is, itΓÇÖs still only content. When you present an event description that is well designed and eye-catching and pair your content strategy with in-person events you are organising, both tactics will be more effective and will result in an increase in your event attendance.Events, by their very nature, are about connections. Through your bright event description, you can boost attendance, sponsorship, or hosting of an event; make new connections; or strengthen the old ones. Learn how to write an event description that will attract the mediaΓÇÖs attention.', 'https://i.ibb.co/NsqDXy2/Jill-Wide-Crowd-Good.jpg'),
	('af22b29a3-3184-4423-aa93-57cc7ed1803e', 'Giza', 398, 100, 'test', '2023-11-12', 'data base test', 'https://i.ibb.co/LNxdpG5/download.jpg');


--
-- Data for Name: go_to; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.go_to VALUES
	('af22b29a3-3184-4423-aa93-57cc7ed1803e', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 1);


--
-- Data for Name: my_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.my_order VALUES
	('a42f24d8e-0987-40c4-bff9-25aaae1f8b2b', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('a449aa0b4-bb5d-4547-a9cb-8f1468b62063', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 1),
	('a5cf32693-dd9e-4e61-8fb9-43d588d357cd', 'a83636a7e-4e55-4db3-bd04-0ea2032f557a', 'af60e0930-c4c8-4bea-ba38-e5723cdfe8d4', '2022-12-20', true, 5),
	('a72d48883-a542-44a3-848d-6ef4a4bbc5c0', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aee18d3bb-b473-454f-a429-4ef9d85d4275', '2022-12-18', true, 4),
	('a647a2a2f-6f79-4cc1-bf3a-f4b1f5a9cffd', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 4),
	('a7fc406ec-6edb-4f13-9466-c3d34452036f', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1', '2022-12-20', true, 5),
	('ab8e86b42-cc5e-4f4c-9878-18d8cce4c0b4', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'abc1faf97-ff30-4a1a-bf5d-578696825258', '2022-12-17', true, 3),
	('aa4465379-2146-473e-bb26-95bc618f03da', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 9),
	('aa0f5fe73-708e-4c4f-b31a-8c3f127c1b1d', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 1),
	('ae3019740-a6bc-4b92-9783-957662974218', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aee18d3bb-b473-454f-a429-4ef9d85d4275', '2022-12-18', true, 4),
	('a98505d55-9ddd-4c24-a479-b1b68bd5423f', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 7),
	('a969e9b2d-a917-42c0-b1e8-4383a019c130', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aee18d3bb-b473-454f-a429-4ef9d85d4275', '2022-12-18', true, 4),
	('a8d4c231b-fbde-4246-a864-b01f1a918438', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a448f1202-a573-4817-a201-12442c695ef1', '2022-12-20', true, 1),
	('ac65b5a32-937f-4a1c-b13f-0ca5b5c3a122', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'aee18d3bb-b473-454f-a429-4ef9d85d4275', '2022-12-18', true, 2),
	('af2076aa7-2f42-45d4-bf8d-4773e8a2ed82', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 2),
	('a7f445f25-2d23-4501-ae2e-8c18083e18d1', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 3),
	('a91635259-7b70-48c5-9b09-40a346b90c45', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 5),
	('a92f6d21c-7e2d-4aa0-aa0f-676a57a842e1', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 5),
	('aae5c1c66-4a0d-47cc-b4df-5241ac02da18', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 2),
	('aeb4a80a2-b0cb-44f4-a2d5-2d9d754c7d42', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 3),
	('aeafd548c-7522-468b-8d21-3da676f0eb69', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1', '2022-12-20', true, 4),
	('ad4deea8e-1b86-4464-8c77-4ad0f5bc3a14', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('af6f68bde-e26d-48c1-8ee9-0a08814715c7', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('afddd1ca2-8ab0-4e36-a3a5-c2a9da2358bf', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 1),
	('a8a56ea7e-77f5-4d7e-b00e-c3c03d321e36', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 3),
	('a9c774d93-0912-49b6-8fe9-2eacac809e58', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 2),
	('aecc1ee2e-f9b2-4f74-ba4a-88786cb8e511', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 3),
	('a4d3e09d2-01f0-45b0-a2fc-9f2ab5a35ac7', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 4),
	('a3edf288f-14a1-4ae5-b012-9e4315ccbd5c', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 1),
	('aa5bf5b6b-3d62-4a3f-80ed-03e6e2d0bca8', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 6),
	('a1d6b9bde-6b13-4b90-a5e0-3a70b5dfe59b', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 5),
	('aaac5e686-58e6-4c3a-b7b8-52571b71e165', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('ab6d26f1c-937a-4f93-9ef3-85aa5f5a43c8', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('aebc27c8a-0073-4ea9-9d24-0c15816ec935', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1', '2022-12-20', true, 4),
	('aafbeefb0-cc95-4404-b740-d79b147eb668', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('a6f5ceac4-65e2-4d75-b41b-e4db5a86d18d', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('aae5c1c66-4a0d-47cc-b4df-5241ac02da18', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 2),
	('aeb4a80a2-b0cb-44f4-a2d5-2d9d754c7d42', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 3),
	('aeafd548c-7522-468b-8d21-3da676f0eb69', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1', '2022-12-20', true, 4),
	('ad4deea8e-1b86-4464-8c77-4ad0f5bc3a14', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('af6f68bde-e26d-48c1-8ee9-0a08814715c7', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('afddd1ca2-8ab0-4e36-a3a5-c2a9da2358bf', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 1),
	('a8a56ea7e-77f5-4d7e-b00e-c3c03d321e36', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 3),
	('a9c774d93-0912-49b6-8fe9-2eacac809e58', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 2),
	('aecc1ee2e-f9b2-4f74-ba4a-88786cb8e511', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 3),
	('a4d3e09d2-01f0-45b0-a2fc-9f2ab5a35ac7', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 4),
	('a3edf288f-14a1-4ae5-b012-9e4315ccbd5c', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 1),
	('aa5bf5b6b-3d62-4a3f-80ed-03e6e2d0bca8', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 6),
	('a1d6b9bde-6b13-4b90-a5e0-3a70b5dfe59b', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 5),
	('aaac5e686-58e6-4c3a-b7b8-52571b71e165', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('ab6d26f1c-937a-4f93-9ef3-85aa5f5a43c8', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('aebc27c8a-0073-4ea9-9d24-0c15816ec935', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1', '2022-12-20', true, 4),
	('aafbeefb0-cc95-4404-b740-d79b147eb668', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('a6f5ceac4-65e2-4d75-b41b-e4db5a86d18d', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('aae5c1c66-4a0d-47cc-b4df-5241ac02da18', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 2),
	('aeb4a80a2-b0cb-44f4-a2d5-2d9d754c7d42', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 3),
	('aeafd548c-7522-468b-8d21-3da676f0eb69', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1', '2022-12-20', true, 4),
	('ad4deea8e-1b86-4464-8c77-4ad0f5bc3a14', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('af6f68bde-e26d-48c1-8ee9-0a08814715c7', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('afddd1ca2-8ab0-4e36-a3a5-c2a9da2358bf', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 1),
	('a8a56ea7e-77f5-4d7e-b00e-c3c03d321e36', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 3),
	('a9c774d93-0912-49b6-8fe9-2eacac809e58', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 2),
	('aecc1ee2e-f9b2-4f74-ba4a-88786cb8e511', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 3),
	('a4d3e09d2-01f0-45b0-a2fc-9f2ab5a35ac7', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 4),
	('a3edf288f-14a1-4ae5-b012-9e4315ccbd5c', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 1),
	('aa5bf5b6b-3d62-4a3f-80ed-03e6e2d0bca8', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 6),
	('a1d6b9bde-6b13-4b90-a5e0-3a70b5dfe59b', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 5),
	('aaac5e686-58e6-4c3a-b7b8-52571b71e165', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('ab6d26f1c-937a-4f93-9ef3-85aa5f5a43c8', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('aebc27c8a-0073-4ea9-9d24-0c15816ec935', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1', '2022-12-20', true, 4),
	('aafbeefb0-cc95-4404-b740-d79b147eb668', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('a6f5ceac4-65e2-4d75-b41b-e4db5a86d18d', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('aae5c1c66-4a0d-47cc-b4df-5241ac02da18', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 2),
	('aeb4a80a2-b0cb-44f4-a2d5-2d9d754c7d42', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 3),
	('aeafd548c-7522-468b-8d21-3da676f0eb69', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1', '2022-12-20', true, 4),
	('ad4deea8e-1b86-4464-8c77-4ad0f5bc3a14', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('af6f68bde-e26d-48c1-8ee9-0a08814715c7', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('afddd1ca2-8ab0-4e36-a3a5-c2a9da2358bf', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 1),
	('a8a56ea7e-77f5-4d7e-b00e-c3c03d321e36', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 3),
	('a9c774d93-0912-49b6-8fe9-2eacac809e58', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 2),
	('aecc1ee2e-f9b2-4f74-ba4a-88786cb8e511', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 3),
	('a4d3e09d2-01f0-45b0-a2fc-9f2ab5a35ac7', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 4),
	('a3edf288f-14a1-4ae5-b012-9e4315ccbd5c', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 1),
	('aa5bf5b6b-3d62-4a3f-80ed-03e6e2d0bca8', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 6),
	('a1d6b9bde-6b13-4b90-a5e0-3a70b5dfe59b', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 5),
	('aaac5e686-58e6-4c3a-b7b8-52571b71e165', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('ab6d26f1c-937a-4f93-9ef3-85aa5f5a43c8', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('aebc27c8a-0073-4ea9-9d24-0c15816ec935', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1', '2022-12-20', true, 4),
	('aafbeefb0-cc95-4404-b740-d79b147eb668', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('a6f5ceac4-65e2-4d75-b41b-e4db5a86d18d', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('aae5c1c66-4a0d-47cc-b4df-5241ac02da18', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 2),
	('aeb4a80a2-b0cb-44f4-a2d5-2d9d754c7d42', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 3),
	('aeafd548c-7522-468b-8d21-3da676f0eb69', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1', '2022-12-20', true, 4),
	('ad4deea8e-1b86-4464-8c77-4ad0f5bc3a14', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('af6f68bde-e26d-48c1-8ee9-0a08814715c7', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('afddd1ca2-8ab0-4e36-a3a5-c2a9da2358bf', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 1),
	('a8a56ea7e-77f5-4d7e-b00e-c3c03d321e36', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 3),
	('a9c774d93-0912-49b6-8fe9-2eacac809e58', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 2),
	('aecc1ee2e-f9b2-4f74-ba4a-88786cb8e511', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 3),
	('a4d3e09d2-01f0-45b0-a2fc-9f2ab5a35ac7', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 4),
	('a3edf288f-14a1-4ae5-b012-9e4315ccbd5c', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 1),
	('aa5bf5b6b-3d62-4a3f-80ed-03e6e2d0bca8', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aff44ed70-623b-465f-a2d9-d01161c29eba', '2022-12-20', true, 6),
	('a1d6b9bde-6b13-4b90-a5e0-3a70b5dfe59b', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 5),
	('aaac5e686-58e6-4c3a-b7b8-52571b71e165', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('ab6d26f1c-937a-4f93-9ef3-85aa5f5a43c8', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('aebc27c8a-0073-4ea9-9d24-0c15816ec935', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a448f1202-a573-4817-a201-12442c695ef1', '2022-12-20', true, 4),
	('aafbeefb0-cc95-4404-b740-d79b147eb668', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2022-12-20', true, 2),
	('a6f5ceac4-65e2-4d75-b41b-e4db5a86d18d', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 2),
	('ab8e86b42-cc5e-4f4c-9878-18d8cce4c0b4', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'abc1faf97-ff30-4a1a-bf5d-578696825258', '2022-12-17', true, 3),
	('aa0f5fe73-708e-4c4f-b31a-8c3f127c1b1d', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26', '2022-12-17', true, 1),
	('a32127104-b2f3-4db6-8d8e-ceae69a53665', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 2),
	('a647a2a2f-6f79-4cc1-bf3a-f4b1f5a9cffd', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', '2022-12-17', true, 6),
	('a30030011-7b7a-405b-a1f2-4b116380511c', 'a06dd3e9b-e999-43e1-99bd-d0314f7e381f', 'af60e0930-c4c8-4bea-ba38-e5723cdfe8d4', '2023-09-25', false, 1),
	('a265ae60e-5f80-4301-bfff-ecb582d21426', 'a06dd3e9b-e999-43e1-99bd-d0314f7e381f', 'a18eac441-660b-44d5-89e7-b8d918690545', '2023-09-25', false, 1),
	('a2152d98e-356d-4181-b81e-ab24c5298c6d', 'a06dd3e9b-e999-43e1-99bd-d0314f7e381f', 'aee18d3bb-b473-454f-a429-4ef9d85d4275', '2023-09-25', false, 1),
	('affec1a19-3b56-4731-9e8c-90be1b6ed4a9', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a4d0ebcef-d918-482e-96f2-e0781d8cc401', '2023-09-29', true, 3),
	('af8aa4b67-13b7-4a31-b078-f332a51b5ef7', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a5c5ccab2-c9eb-436f-9167-80e84b1bb897', '2023-09-30', true, 1),
	('a2039d2ef-7054-44c2-8270-fea4c57da075', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aee18d3bb-b473-454f-a429-4ef9d85d4275', '2023-09-30', true, 4),
	('a7b86dacb-500b-4d62-9d84-52ce2f0c3842', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', '2023-09-30', true, 6),
	('a24a5b1b6-65da-4360-9d05-a6b6d35834ed', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a18eac441-660b-44d5-89e7-b8d918690545', '2023-09-30', true, 5),
	('ad3566b62-2723-4e08-b995-1b86913635a8', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aee18d3bb-b473-454f-a429-4ef9d85d4275', '2023-09-30', true, 4),
	('aef2ef3a9-36d1-435a-88ff-7166dd170a56', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a5c5ccab2-c9eb-436f-9167-80e84b1bb897', '2023-09-30', true, 2);


--
-- Data for Name: rate; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.rate VALUES
	('a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a18eac441-660b-44d5-89e7-b8d918690545', 5),
	('a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', 5),
	('a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aee18d3bb-b473-454f-a429-4ef9d85d4275', 5);


--
-- Data for Name: reader; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.reader VALUES
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2','Joanne','Rowling London', 'J. K. Rowling','$2b$12$nYuYvFPTiBwqt7vS4ouw4eeFH9YLYuBdmPy2jVN/DGqDPNYcFjLeG','1965-07-31','500000','false','	https://www.biography.com/.image/ar_1:1%2Cc_fill%2Ccs_srgb%2Cfl_progressive%2Cq_auto:good%2Cw_1200/MTc5OTUwMTA3MzE4Mjk3OTQ0/gettyimages-1061157246.jpg'	,'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg'	,'Author', 'New York','2022-12-22'),
	('a96029942-2a80-49f2-9160-e4c8ebefe967', 'Mo', 'At', 'Atef', '$2b$12$J2UQQaJlGdzekOXRjVywH.4rshovHxc6TcrClMLZXjKQyKrCTZiQ6', '2002-08-30', 855, true, 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460__480.png', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Reader', 'Giza', '2022-12-29'),
	('a9649899d-f632-467a-85b6-f989dbcfde6c', 'Lauren', 'Willig', 'Lauren Willig', '$2b$12$Uwa0Xeta1sUvb0u.Z2h5XuqzPkrjJPiLKCtRXtIkbEaaE7NiURdUm', '1977-03-28', 41000, false, 'https://i.ibb.co/Tq2GBrh/41-A2o98k-IOL.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Author', 'New York', '2022-12-29'),
	('a0b0ff508-1b00-41e0-92a7-e6f2e006518b', 'Samy', 'Samir', 'Samy', '$2b$12$k9z2ClIBAPkdzQdyLsDYkeq0VqsgRYSoR.mwwfZzEQOX5ouLqQY0.', '2012-12-30', 9990, true, 'https://i.ibb.co/6bHRZPG/download2.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Reader', 'Cairo', '2022-12-29'),
	('ab513a485-275a-4f37-9779-46c1c664abd3', 'Karen', 'White', 'Karen White', '$2b$12$YL36Zt9yjTVBzQcatzdNl.RCx1Iu7p3bZjWUfY7UylnE4fAqc.snS', '1964-05-30', 98000, false, 'https://i.ibb.co/hMq3qcX/images.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Author', 'New York', '2022-12-29'),
	('af0cd7987-4b09-4763-a810-c4649d868f78', 'George', 'Raymond', 'George R. R. Martin', '$2b$12$/X7IEYSfibhCdQFxKXM0E.V/JMfk9SLpethsubPSBxa1AEuP372fK', '1948-09-20', 1498000, true, 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f9/George_R.R._Martin_at_Archipelacon.jpg/800px-George_R.R._Martin_at_Archipelacon.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Author', 'New Jersey', '2022-12-22'),
	('a83636a7e-4e55-4db3-bd04-0ea2032f557a', 'Mohamed', 'Atef', 'MOAtef', '$2b$12$pNRKnLPh1MUsKden/udqW.6jUCvoYYWIwjGGchN.TFNyFGYNtd3/a', '2002-08-30', 3800, true, 'https://i.ibb.co/kcgBjkt/Whats-App-Image-2022-12-20-at-18-38-28.jpg', 'https://i.ibb.co/wdq1FyJ/5462979.jpg', 'Admin', 'Giza', '2022-12-22'),
	('acddcc57c-f65b-4d2b-9a03-251efb9815a1', 'Ahmed', 'Note', 'Ahmed', '$2b$12$65b9zNKFImf5o0700A/h..HbqUEP0KG/frFAmPcva52JMHpmHebI2', '2001-12-05', 50, true, 'https://i.ibb.co/bNhgbWK/274a58efcc1fe3a43be7313832306c51.jpg', 'https://i.ibb.co/mcsdp2c/sunset-anime-girl-hd-wallpaper-1080x608.jpg', 'Reader', 'London', '2022-12-28'),
	('ac3d1ea08-3104-43ed-91c3-b055d2a17537', 'Naguib', 'Mahfouz', 'nageb', '$2b$12$iNYO2efCxebBG7d61YsKsuZRtCJ0XjiYfX4XB/gWuIqFP8j1h95/G', '1982-10-16', 50000, true, 'https://i.ibb.co/hXnXmnM/naguib-mahfouz.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Author', 'Cairo', '2022-12-27'),
	('aa53f3d5e-d450-4589-b7fc-7868830b9a55', 'Collen', 'Hoover', 'Collen Hoover', '$2b$12$73jQn7RlVEyv7hpNGfJsL.W13AL8/jdC.tNkiji6d3u/VeQxwDHdS', '1979-12-11', 20000, false, 'https://i.ibb.co/TRFqxJt/Screenshot-2022-12-28-204429.png', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Author', 'New York', '2022-12-28'),
	('a9fd81137-e9db-4237-bde1-584256eb1173', 'Laura', 'Kaye', 'Laura Komie', '$2b$12$6Xv1NIA2L6nw3hIcQ5ry2ehc21a4hro6WrXDDO3DwnOq.GipdmLVa', '1970-08-27', 40000, false, 'https://i.ibb.co/xmDFKrp/Screenshot-2022-12-28-232749.png', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Author', 'New York', '2022-12-28'),
	('a67fd6b24-c0de-4ec6-9566-67ee387bc468', 'Maro', 'Mohamed', 'Maram.mohamed01@eng-st.cu.edu.eg', '$2b$12$ePjlPjqD0z6szjeaC0dpbO6GAoN2SX/M7mz0W3z8ytWoM8/uYlb1.', '2001-12-27', 0, false, 'https://i.ibb.co/PwDZx4c/Whats-App-Image-2022-10-10-at-6-21-16-PM-1.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Reader', 'Cairo', '2023-01-01'),
	('a7bdb966d-ac6c-4fbd-894b-735a2ade7502', 'Kate', 'Quinn', 'Kate Quinn', '$2b$12$cGe2r3/l2dZtwEr65uxUnONmVRTL2CCS3YyUfiFyNd6iUr4anES0u', '1981-11-30', 60000, false, 'https://i.ibb.co/dPnqk0R/Screenshot-2022-12-28-232120.png', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Author', 'New York', '2022-12-28'),
	('a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'Seif', 'Hany', 'Sofa', '$2b$12$hD1090ELWOcJhXnlEmCHAOPL0EZuXvqu9vkAex1UkVHYbNo7pI/pm', '2002-10-01', 2930, true, 'https://i.ibb.co/BqGzsC9/Doctor-Strange-Poster-810x1200.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Admin', 'Cairo', '2022-12-22'),
	('ae310befb-000a-4a40-967a-1203e1316d10', 'Seif', 'Hany2', 'sofaaa', '$2b$12$eonemwczPQOMtFekN7gBr.Dw6L5YYn6y0lz4hh70BUz7T5XytTFt.', '2002-10-01', 1500, true, NULL, 'https://i.ibb.co/Y3nTmDT/download.jpg', 'Reader', 'Cairo', '2022-12-28'),
	('aed7653f6-2930-4a8f-aeee-a516ed91df7a', 'Marwan', 'Emad', 'Scorpion', '$2b$12$INxJfCdgspooyGVd7G.H5ukSGuz8rl/y1GhneHVTUwwuaufCQFW7C', '2002-01-01', 500003660, true, 'https://i.ibb.co/qnnRRft/319343104-1726269541104056-8366902101057821703-n.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Admin', 'Cairo', '2022-12-22'),
	('ae25bddc4-8b59-47ed-aba8-2af11d8c1909', 'Kelly', 'Rimmer', 'Kelly Rimmer', '$2b$12$jVbivOAGWNVV6nmnuH9aEuvjw2Y5Iu1UT4n/QLsb2KM6nOUZokXt.', '1992-10-14', 1550, false, 'https://i.ibb.co/4s6cPPV/Kelly-Rimmer.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Admin', 'NY', '2022-12-29'),
	('a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'Marwan', 'Samy', 'Marwan Kun', '$2b$12$xsi9rkPw/WD.DvzrMYnhQOEO7aKVPkVk8ERYjVPDE5YAc1tYSkJ5G', '2002-07-19', 8380, true, 'https://i.ibb.co/HCcv5QG/01eab91ff04ea5832a33040f7ebdb3d0.jpg', 'https://i.ibb.co/RP6HSsC/5462979.jpg', 'Admin', 'Giza', '2022-12-22'),
	('ac78e9bb6-42aa-4167-b291-f3bd280faa9f', 'test', 'dog', 'test', '$2b$12$VCiaGFEYE2W86zAj3oiseuxlY.KBHbsVwh0CnqwCEkwtdRHHgGgXq', '2000-07-05', 1500, true, 'https://i.ibb.co/RPhD5wz/istockphoto-513133900-612x612.jpg', 'https://uploads-ssl.webflow.com/5a885600d9716c0001a422b2/6262ccfc99b9de80dbdf73f7_types-of-books-p-1080.jpeg', 'Reader', 'giza', '2023-09-30');


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.review VALUES
	('a2f3891f6-b9dd-437c-ab4a-82bd5134a7a8', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a18eac441-660b-44d5-89e7-b8d918690545', 'i like it', '2023-09-30'),
	('a27166da4-7440-45ab-91f3-c693f420342b', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'abc1faf97-ff30-4a1a-bf5d-578696825258', 'I hope to buy this book soon I cant wait', '2022-10-20'),
	('aa88431ce-bf41-4b43-9c32-a40fa84de820', 'a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', 'ya rab', '2022-12-18'),
	('a7da26534-4066-444f-bd28-dbea3a1c1f62', 'af0cd7987-4b09-4763-a810-c4649d868f78', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', 'WTF', '2022-12-18'),
	('ae734780f-322b-4c51-b4ee-2a8d7ead5b72', 'a83636a7e-4e55-4db3-bd04-0ea2032f557a', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50', 'Awesome I love it', '2022-12-17'),
	('a334dea8f-69c1-4d21-ab75-11f36b1a1fbf', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', 'OMG I LOVE IT', '2023-09-30'),
	('aa6cc080f-c94f-4595-9513-29768ace14d9', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'aee18d3bb-b473-454f-a429-4ef9d85d4275', 'best book', '2023-09-30'),
	('a3726128f-8f36-4929-9bd1-61a3cf14ec8f', 'a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a5c5ccab2-c9eb-436f-9167-80e84b1bb897', 'one of my lovely anime', '2022-12-22'),
	('a684028db-b1b7-409c-b5cf-48f06aa31faa', 'aed7653f6-2930-4a8f-aeee-a516ed91df7a', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c', 'best book', '2022-12-28');


--
-- Data for Name: session; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.session VALUES
	('keG_CVLPlnRNwq6e4UYDGC8wTKY6U5y6', '{"cookie":{"originalMaxAge":null,"expires":null,"httpOnly":true,"path":"/"},"user_In":{"user_id":"a3ddb1e7c-2bbd-4306-a121-af6ba28387fa","first_name":"Marwan","last_name":"Samy","username":"Marwan Kun","pass":"$2b$12$xsi9rkPw/WD.DvzrMYnhQOEO7aKVPkVk8ERYjVPDE5YAc1tYSkJ5G","birthdate":"2002-07-18T21:00:00.000Z","gender":true,"profile_pic":"https://i.ibb.co/HCcv5QG/01eab91ff04ea5832a33040f7ebdb3d0.jpg","cover":"https://i.ibb.co/RP6HSsC/5462979.jpg","user_type":"Admin","city":"Giza","join_date":"2022-12-21T22:00:00.000Z","balance":54454585},"flash":{}}', '2023-10-01 19:12:29'),
	('fq0OKQi80y9jqcd17rdt0qtNhhKsI47L', '{"cookie":{"originalMaxAge":null,"expires":null,"httpOnly":true,"path":"/"},"user_In":{"user_id":"a3ddb1e7c-2bbd-4306-a121-af6ba28387fa","first_name":"Marwan","last_name":"Samy","username":"Marwan Kun","pass":"$2b$12$xsi9rkPw/WD.DvzrMYnhQOEO7aKVPkVk8ERYjVPDE5YAc1tYSkJ5G","birthdate":"2002-07-18T21:00:00.000Z","balance":8380,"gender":true,"profile_pic":"https://i.ibb.co/HCcv5QG/01eab91ff04ea5832a33040f7ebdb3d0.jpg","cover":"https://i.ibb.co/RP6HSsC/5462979.jpg","user_type":"Admin","city":"Giza","join_date":"2022-12-21T22:00:00.000Z"},"flash":{}}', '2023-10-01 20:10:54');


--
-- Data for Name: stat; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.stat VALUES
	('2023-09-28', 9513, 5),
	('2022-12-29', 3246, 789),
	('2022-12-27', 2799, 259),
	('2022-12-28', 11306, 1024),
	('2023-03-05', 34, 199),
	('2023-09-30', 2990, 0),
	('2023-09-29', 1662, -2276);


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.tag VALUES
	('T1001', 'Fantasy'),
	('T1002', 'Fiction'),
	('T1003', 'Nonfiction'),
	('T1004', 'Adventure'),
	('T1005', 'Romance'),
	('T1006', 'Contemporary'),
	('T1007', 'Dystopian'),
	('T1008', 'Mystery'),
	('T1009', 'Horror'),
	('T1010', 'Thriller'),
	('T1011', 'Paranormal'),
	('T1012', 'Historical Fiction'),
	('T1013', 'Science Fiction'),
	('T1014', 'Children'),
	('T1015', 'Memoir'),
	('T1016', 'Cookbook'),
	('T1017', 'Art'),
	('T1018', 'Self Help'),
	('T1019', 'Development'),
	('T1020', 'Motivational'),
	('T1021', 'Health'),
	('T1022', 'History'),
	('T1023', 'Travel'),
	('T1024', 'Guide'),
	('T1025', 'Families'),
	('T1026', 'Relationships'),
	('T1027', 'Humor'),
	('T1028', 'Western'),
	('T1029', 'Novel');


--
-- Data for Name: user_tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.user_tag VALUES
	('a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'T1010'),
	('a1d5b0581-aedb-451b-9af0-16c69b6d6254', 'T1019'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'T1001'),
	('a83636a7e-4e55-4db3-bd04-0ea2032f557a', 'T1005'),
	('a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'T1009'),
	('ac3d1ea08-3104-43ed-91c3-b055d2a17537', 'T1017'),
	('ac3d1ea08-3104-43ed-91c3-b055d2a17537', 'T1022'),
	('ac3d1ea08-3104-43ed-91c3-b055d2a17537', 'T1015'),
	('ac3d1ea08-3104-43ed-91c3-b055d2a17537', 'T1029'),
	('aa53f3d5e-d450-4589-b7fc-7868830b9a55', 'T1002'),
	('aa53f3d5e-d450-4589-b7fc-7868830b9a55', 'T1029'),
	('aa53f3d5e-d450-4589-b7fc-7868830b9a55', 'T1026'),
	('aa53f3d5e-d450-4589-b7fc-7868830b9a55', 'T1005'),
	('ae310befb-000a-4a40-967a-1203e1316d10', 'T1021'),
	('ae310befb-000a-4a40-967a-1203e1316d10', 'T1012'),
	('ae310befb-000a-4a40-967a-1203e1316d10', 'T1022'),
	('ae310befb-000a-4a40-967a-1203e1316d10', 'T1009'),
	('ae310befb-000a-4a40-967a-1203e1316d10', 'T1027'),
	('acddcc57c-f65b-4d2b-9a03-251efb9815a1', 'T1014'),
	('acddcc57c-f65b-4d2b-9a03-251efb9815a1', 'T1007'),
	('acddcc57c-f65b-4d2b-9a03-251efb9815a1', 'T1022'),
	('acddcc57c-f65b-4d2b-9a03-251efb9815a1', 'T1015'),
	('a9fd81137-e9db-4237-bde1-584256eb1173', 'T1002'),
	('a9fd81137-e9db-4237-bde1-584256eb1173', 'T1005'),
	('a96029942-2a80-49f2-9160-e4c8ebefe967', 'T1004'),
	('a96029942-2a80-49f2-9160-e4c8ebefe967', 'T1016'),
	('a96029942-2a80-49f2-9160-e4c8ebefe967', 'T1007'),
	('a96029942-2a80-49f2-9160-e4c8ebefe967', 'T1001'),
	('a96029942-2a80-49f2-9160-e4c8ebefe967', 'T1012'),
	('a96029942-2a80-49f2-9160-e4c8ebefe967', 'T1027'),
	('a96029942-2a80-49f2-9160-e4c8ebefe967', 'T1020'),
	('a9649899d-f632-467a-85b6-f989dbcfde6c', 'T1005'),
	('ab513a485-275a-4f37-9779-46c1c664abd3', 'T1005'),
	('ae25bddc4-8b59-47ed-aba8-2af11d8c1909', 'T1017'),
	('ae25bddc4-8b59-47ed-aba8-2af11d8c1909', 'T1020'),
	('ae25bddc4-8b59-47ed-aba8-2af11d8c1909', 'T1026'),
	('ae25bddc4-8b59-47ed-aba8-2af11d8c1909', 'T1005'),
	('a0b0ff508-1b00-41e0-92a7-e6f2e006518b', 'T1004'),
	('a0b0ff508-1b00-41e0-92a7-e6f2e006518b', 'T1001'),
	('a0b0ff508-1b00-41e0-92a7-e6f2e006518b', 'T1012'),
	('a0b0ff508-1b00-41e0-92a7-e6f2e006518b', 'T1022'),
	('a0b0ff508-1b00-41e0-92a7-e6f2e006518b', 'T1005'),
	('a0b0ff508-1b00-41e0-92a7-e6f2e006518b', 'T1023'),
	('a67fd6b24-c0de-4ec6-9566-67ee387bc468', 'T1004'),
	('a67fd6b24-c0de-4ec6-9566-67ee387bc468', 'T1017'),
	('a67fd6b24-c0de-4ec6-9566-67ee387bc468', 'T1014'),
	('a67fd6b24-c0de-4ec6-9566-67ee387bc468', 'T1001'),
	('a67fd6b24-c0de-4ec6-9566-67ee387bc468', 'T1022'),
	('a67fd6b24-c0de-4ec6-9566-67ee387bc468', 'T1009'),
	('a67fd6b24-c0de-4ec6-9566-67ee387bc468', 'T1008'),
	('a67fd6b24-c0de-4ec6-9566-67ee387bc468', 'T1029'),
	('a67fd6b24-c0de-4ec6-9566-67ee387bc468', 'T1013'),
	('ac78e9bb6-42aa-4167-b291-f3bd280faa9f', 'T1017'),
	('ac78e9bb6-42aa-4167-b291-f3bd280faa9f', 'T1012'),
	('ac78e9bb6-42aa-4167-b291-f3bd280faa9f', 'T1026');


--
-- Data for Name: writes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.writes VALUES
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'a4607e8dc-7ec3-4449-94fb-ec8b8a9c0f50'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'ad94b33ea-34b9-4cad-a5d8-383b18eccc26'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'abc1faf97-ff30-4a1a-bf5d-578696825258'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'aff44ed70-623b-465f-a2d9-d01161c29eba'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'a448f1202-a573-4817-a201-12442c695ef1'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'a5bf054bd-1ef9-48bb-9822-89ef233e2672'),
	('a62a6d457-4e7b-4d4f-a830-11c0884344c2', 'af60e0930-c4c8-4bea-ba38-e5723cdfe8d4'),
	('af0cd7987-4b09-4763-a810-c4649d868f78', 'a104d6e47-c5f9-4203-806d-f34110985b98'),
	('af0cd7987-4b09-4763-a810-c4649d868f78', 'aee18d3bb-b473-454f-a429-4ef9d85d4275'),
	('af0cd7987-4b09-4763-a810-c4649d868f78', 'a2c6d5466-b154-47b1-b23b-63a73ec9f76c'),
	('af0cd7987-4b09-4763-a810-c4649d868f78', 'a18eac441-660b-44d5-89e7-b8d918690545'),
	('af0cd7987-4b09-4763-a810-c4649d868f78', 'a964791fc-da74-4fc3-829b-a7dd08badcf5'),
	('a7bdb966d-ac6c-4fbd-894b-735a2ade7502', 'a17973a0f-28f5-487c-9d16-5d03f27232e6'),
	('ab513a485-275a-4f37-9779-46c1c664abd3', 'a203f12d4-db96-4579-8b6f-0280fd42c420'),
	('aa53f3d5e-d450-4589-b7fc-7868830b9a55', 'a436d387f-e238-4706-82e5-8f23f1192fe7'),
	('ae25bddc4-8b59-47ed-aba8-2af11d8c1909', 'a4d0ebcef-d918-482e-96f2-e0781d8cc401'),
	('a3ddb1e7c-2bbd-4306-a121-af6ba28387fa', 'a5c5ccab2-c9eb-436f-9167-80e84b1bb897'),
	('ac3d1ea08-3104-43ed-91c3-b055d2a17537', 'aa640c333-89c7-4a23-b5fe-486b7873c136');


--
-- Name: ttt; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ttt', 1029, true);


--
-- Name: book book_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_pkey PRIMARY KEY (book_id);


--
-- Name: book book_title_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.book
    ADD CONSTRAINT book_title_key UNIQUE (title);


--
-- Name: borrow borrow_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrow
    ADD CONSTRAINT borrow_pkey PRIMARY KEY (book_id, user_id, return_date);


--
-- Name: go_to go_to_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_to
    ADD CONSTRAINT go_to_pkey PRIMARY KEY (event_id, user_id);


--
-- Name: rate rate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate
    ADD CONSTRAINT rate_pkey PRIMARY KEY (user_id, book_id);


--
-- Name: reader reader_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reader
    ADD CONSTRAINT reader_pkey PRIMARY KEY (user_id);


--
-- Name: reader reader_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.reader
    ADD CONSTRAINT reader_username_key UNIQUE (username);


--
-- Name: review review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (review_id);


--
-- Name: session session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.session
    ADD CONSTRAINT session_pkey PRIMARY KEY (sid);


--
-- Name: stat stat_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stat
    ADD CONSTRAINT stat_pkey PRIMARY KEY (vist_date);


--
-- Name: tag tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (tag_id);


--
-- Name: tag tag_tag_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tag
    ADD CONSTRAINT tag_tag_name_key UNIQUE (tag_name);


--
-- Name: IDX_session_expire; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX "IDX_session_expire" ON public.session USING btree (expire);


--
-- Name: borrow borrow_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrow
    ADD CONSTRAINT borrow_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE CASCADE;


--
-- Name: borrow borrow_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.borrow
    ADD CONSTRAINT borrow_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.reader(user_id) ON DELETE CASCADE;


--
-- Name: go_to go_to_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.go_to
    ADD CONSTRAINT go_to_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.reader(user_id) ON DELETE CASCADE;


--
-- Name: rate rate_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate
    ADD CONSTRAINT rate_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE CASCADE;


--
-- Name: rate rate_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rate
    ADD CONSTRAINT rate_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.reader(user_id) ON DELETE CASCADE;


--
-- Name: review review_book_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_book_id_fkey FOREIGN KEY (book_id) REFERENCES public.book(book_id) ON DELETE CASCADE;


--
-- Name: review review_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.reader(user_id) ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

