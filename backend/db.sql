--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2
-- Dumped by pg_dump version 16.2

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
-- Name: adminpack; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION adminpack; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: dishes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dishes (
    id integer NOT NULL,
    title text NOT NULL,
    description text,
    image_url text,
    author_id integer,
    type text,
    side_dish boolean,
    category text,
    cuisine text,
    season text,
    cooking_time integer,
    dinner_time text,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    edited timestamp without time zone,
    is_moderated boolean DEFAULT false
);


ALTER TABLE public.dishes OWNER TO postgres;

--
-- Name: dishes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.dishes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.dishes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ingredients (
    id integer NOT NULL,
    dish_id integer,
    index integer,
    name text,
    measurement text,
    amount real,
    category text,
    is_main boolean
);


ALTER TABLE public.ingredients OWNER TO postgres;

--
-- Name: ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.ingredients ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ingredients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: menus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.menus (
    id integer NOT NULL,
    user_id integer,
    title text,
    dishes text,
    dinner_category text,
    dinner_time text,
    cooking_time text,
    saved timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    removed timestamp without time zone
);


ALTER TABLE public.menus OWNER TO postgres;

--
-- Name: menus_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.menus ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.menus_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: moderation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.moderation (
    id integer NOT NULL,
    dish_id integer,
    moderator_id integer,
    published timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.moderation OWNER TO postgres;

--
-- Name: moderation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.moderation ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.moderation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: steps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.steps (
    id integer NOT NULL,
    dish_id integer,
    index integer,
    description text
);


ALTER TABLE public.steps OWNER TO postgres;

--
-- Name: steps_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.steps ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.steps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    email text,
    role text DEFAULT 'user'::text NOT NULL,
    created timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    edited timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Data for Name: dishes; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dishes (id, title, description, image_url, author_id, type, side_dish, category, cuisine, season, cooking_time, dinner_time, created, edited, is_moderated) FROM stdin;
112	Grafsky Ruins Cake	Grafsky Ruins Cake is a decadent dessert made of layers of meringue, rich buttercream, prunes, and walnuts, all drizzled with a luscious chocolate glaze. This cake is a delightful combination of textures and flavors, perfect for special occasions.	05380c4a-721f-4319-b564-584be77cdd3d.jpg	7	desert	f	festive, guest	european, slavic, mediterranean, italian	all seasons	3	tomorrow	2024-06-07 23:39:17.763209	2024-06-08 00:37:46.596028	t
26	Simple Cooked Quinoa	Quinoa is a nutritious grain that cooks up light and fluffy, similar to couscous but with a slightly nutty flavor. It is an excellent side dish that complements a wide array of meals, making it a versatile addition to any menu.\r\n\r\n\r\n\r\n\r\n\r\n	6fcdfbc0-ffa2-494a-831b-9f375500500a.jpg	3	side dish	f	weeknight, family, guest, festive, romantic	european, east asian, mediterranean, italian, tex-mex	all seasons	1	now, today, tomorrow	2024-05-12 19:21:28.235891	2024-05-12 19:52:10.785018	t
30	Easy Apple Pie with Optional Cranberries	This delightful apple pie pairs sweet apples with optional cranberries, fresh or frozen. Quick to prepare, enjoy this versatile dessert year-round, with or without the cranberries.	50e47193-541b-4455-bd16-ba78b6c237a8.jpg	4	desert	f	family, guest	universal	all seasons	1	today, tomorrow, now	2024-05-14 13:21:46.889063	2024-05-14 21:28:54.693945	t
34	Salmon, Feta, and Broccoli Quiche	This quiche marries the rich flavors of salmon, feta, and broccoli in a creamy custard, encased in a buttery crust. It's an elegant hot starter, perfect for beginning a meal with sophistication. Whether served warm or cooled, this quiche ensures a delightful culinary experience.	9b5fb63c-2c40-425e-a181-d0f8dfb2b076.jpg	4	hot starter	f	guest, festive, family	european, mediterranean, slavic, italian, tex-mex	all seasons	4	tomorrow, today	2024-05-14 23:37:21.859736	2024-05-15 00:09:27.241097	t
48	Cheese Roll with Creamy Filling	This cheese roll with a creamy filling is a delightful appetizer featuring a smooth blend of cream cheese, garlic, and dill, complemented by slices of deli meats. It's perfect for special occasions and can be prepared in advance for easy serving.	07ce20d7-3e9f-4e7f-8f9c-de21d5e2102c.jpg	4	starter	f	family, guest, festive	european, mediterranean, slavic, italian, tex-mex	all seasons	3	today, tomorrow	2024-05-16 21:11:56.912532	2024-05-16 22:10:58.554729	t
53	Unusual Egg Starter	This unusual egg starter combines hard-boiled eggs with golden fried onions, seasoned with salt and pepper, and dressed with aromatic oil. It's a simple yet flavorful dish that's perfect for adding a touch of originality to your meal.	g8d4f497-dab7-5a76-3jfh-c0d8bda0a762.jpg	4	starter	f	family	universal	all seasons	1	now, today, tomorrow	2024-05-17 00:53:49.898418	2024-05-17 01:40:44.51341	t
44	Simple Tomato and Feta Salad Cups	This elegant tomato and feta salad served in cups is perfect for a romantic dinner for two. Fresh greens, zesty homemade dressing, and a sprinkle of pine nuts create a delightful starter that's simple yet sophisticated.	dc9ddc74-d051-4961-8245-54de9267582e.jpeg	3	salad	f	romantic	european, mediterranean, italian, tex-mex	all seasons	1	now, today, tomorrow	2024-05-16 15:07:14.452377	2024-05-16 23:26:05.769481	t
43	Stuffed Sweet Peppers with Brined Cheese	These stuffed sweet peppers are a delightful and colorful appetizer, perfect for any gathering. Filled with a flavorful mix of brined cheese, garlic, and herbs, each pepper is baked until perfectly tender.	ac7e47fd-fbc6-43c4-955a-3b5afff28825.jpg	3	appetizer	f	family, guest, festive, romantic	european, mediterranean, slavic, italian, tex-mex	all seasons	1	today, now, tomorrow	2024-05-16 14:53:19.982834	2024-05-16 23:23:07.454257	t
5	Chocolate soufflé	This airy chocolate and cream dessert is very easy to prepare. Even someone who has never cooked desserts in their life can cook it.	30a8b418-4650-4dcf-97dd-562d9b13b812.jpg	3	desert	f	festive, romantic	universal	all seasons	3	today, tomorrow	2024-05-07 16:28:11.037	2024-05-16 19:07:04.171374	t
8	Chicken Stuffed with Buckwheat	When we stuff the chicken with buckwheat and bake it, we create a wonderful fusion of flavors that transforms it into both a main dish and a side dish. The end result is a visually stunning and uniquely delicious plate that is surprisingly simple to prepare.	77decb56-c52c-406b-8114-f7c25d63e45c.jpg	3	main dish	f	family, guest, festive	italian, slavic, european, mediterranean	all seasons	3	today, tomorrow	2024-05-07 20:36:25.03474	2024-05-09 14:39:15.058283	t
36	Strawberry Trifle - A Popular English Dessert	This Strawberry Trifle is a visually stunning and decadent dessert layered with smooth creams, fresh strawberries, crunchy nuts, and rich cocoa. Perfect for a special occasion, each spoonful offers a delightful mix of textures and flavors that are sure to impress.	45161f8a-e6af-4a7d-86e3-32076faf8c24.jpg	3	desert	f	festive, romantic	european, mediterranean, slavic, italian, tex-mex	autumn, spring, summer	2	today, tomorrow	2024-05-16 01:58:49.944338	2024-05-16 19:09:32.614967	t
40	Cucumber Rolls with Tuna and Avocado	These cucumber rolls are a delightful appetizer, featuring a vibrant mix of tuna, avocado, and chili encased in crisp cucumber slices. The combination of rich and spicy filling with the freshness of cucumber makes these rolls a perfect choice for a light and elegant starter.	49f7567e-0574-4b0a-8621-c7a0b428e252.jpg	3	appetizer	f	family, guest, festive, romantic	universal	all seasons	1	today, tomorrow	2024-05-16 04:05:26.778217	2024-05-16 22:09:19.274547	t
422	Canapés with Herring and Beet Pesto	These canapés combine the savory flavor of herring with the earthy sweetness of beetroot pesto, all served on a crisp or chewy base. They make a delicious and visually appealing appetizer.	35ab1689-f9d2-4da1-a309-f42fd74d213e.jpeg	7	appetizer	f	guest, festive	slavic, european	all seasons	1	now, today, tomorrow	2024-06-22 17:44:02.224823	\N	t
427	Stuffed Mushrooms with Chicken Julienne	Stuffed Mushrooms with Chicken Julienne is a delightful appetizer that features large mushrooms filled with a creamy chicken and mushroom mixture, topped with melted cheese. This dish is perfect for entertaining guests or as a tasty starter for a special meal.	a4d52199-beed-45ed-bf07-8d82d9ad23cf.jpeg	9	hot starter	f	family, festive, guest	european, mediterranean, slavic, italian	all seasons	1	now, today, tomorrow	2024-06-22 18:29:59.40822	\N	t
435	Arabic Stuffed Zucchini in Tomato Sauce	This traditional Arabic dish features small zucchinis stuffed with a flavorful mixture of ground beef and rice, cooked in a rich tomato sauce. The addition of warm spices and herbs makes this a comforting and aromatic meal.	3a4f683a-142e-4d67-a939-b0deb04bd2dd.jpg	3	main dish	f	weeknight, family, guest	mediterranean	autumn, spring, summer	2	today, tomorrow	2024-06-22 19:28:47.195388	\N	t
440	Lithuanian Cold Beet Soup for Hot Summer Days	Lithuanian Cold Beet Soup, known as "Šaltibarščiai," is a refreshing and vibrant dish perfect for hot summer days. Traditionally served with hot potatoes, this chilled soup offers a delightful contrast in temperatures, making it a unique and satisfying meal.	76e89582-f51c-4f78-9111-457154e9d939.jpeg	7	soup	f	weeknight, family, guest	european, slavic	summer	2	today, tomorrow	2024-06-22 19:57:34.534626	\N	t
113	Crispy Bacon and Cherry Tomatoes Salad	This delicious salad features crispy bacon, juicy cherry tomatoes, and fresh Frisée lettuce, all brought together with a zesty lemon dressing and topped with toasted pine nuts. It's a delightful and refreshing dish that's perfect for any occasion.	08a335ee-7922-460e-825c-da6a1718ff89.jpeg	9	salad	f	family, guest, festive, weeknight	european, slavic, mediterranean, italian, tex-mex	all seasons	1	today, tomorrow	2024-06-07 23:57:56.265469	2024-06-09 23:30:31.141443	t
376	Simple Vegetable Salad with Sour Cream	This Simple Vegetable Salad with Sour Cream is a quick and refreshing side dish, perfect for any meal. Made with fresh cucumbers, radishes, green onions, dill, and lettuce leaves, it’s topped with a creamy sour cream dressing for a light and healthy addition to your table.	default_img.jpg	3	\N	\N	\N	\N	\N	\N	\N	2024-06-19 02:00:35.57836	2024-06-22 17:29:26.233792	f
108	Tom Yum with Shrimp	Tom Yum is a popular Thai soup that combines the succulent flavors of shrimp with the creamy richness of coconut milk. It is known for its intriguing and unique sour-spicy taste that tantalizes the palate. This soup is both refreshing and comforting, making it a perfect dish for any occasion.	ee8924ce-96d2-4af9-8892-24c8e9a6df03.jpg	4	soup	f	weeknight, family, guest	east asian	all seasons	2	today, tomorrow, now	2024-06-07 21:56:11.698066	2024-06-08 04:43:16.288348	t
436	Salmon with Berry Sauce	Salmon with Berry Sauce is a delicious and elegant dish that pairs the rich flavor of salmon with the sweet and tangy notes of mixed berries. This dish is perfect for a special occasion or a delightful dinner, bringing together the freshness of berries and the savory taste of perfectly cooked salmon.	65ff71b8-ca67-4429-93a7-593f38665760.jpeg	3	main dish	t	guest, festive	italian, slavic, mediterranean, european	summer	1	now, tomorrow, today	2024-06-22 19:35:31.982329	\N	t
441	Fettuccine with Sicilian Chicken Marsala	Fettuccine with Sicilian Chicken Marsala is a rich and creamy pasta dish that combines tender chicken with the deep flavors of Marsala wine and earthy mushrooms. The addition of mascarpone cheese and Dijon mustard gives the sauce a luxurious texture and a tangy kick, making it a perfect choice for a special dinner.	0fe3fbbb-e1a6-4a4b-9a7d-bfd911c5bd1a.jpeg	7	main dish	f	family, guest, romantic	european, mediterranean, slavic, italian	all seasons	2	now, today, tomorrow	2024-06-22 20:05:04.591668	\N	t
423	Irish Beef Stew with Dark Beer and Beans	This hearty Irish stew combines tender beef, red beans, and a rich dark beer sauce, infused with spices and slow-cooked to perfection. Perfect for a comforting and filling meal.	b38849fd-b7cb-4207-b846-3d06a8b2e69e.jpg	7	main dish	f	family, guest, festive	european, mediterranean, slavic, tex-mex	all seasons	4	tomorrow	2024-06-22 17:49:19.231029	\N	t
35	 Cheesy Ham Roll-Ups	These roll-ups make a delicious and easy-to-prepare starter. Combining the richness of cheese and the freshness of dill with the savory taste of ham, these roll-ups are perfect for entertaining guests or enjoying as a flavorful snack.	77a44e70-405a-44cf-895e-e10b15fdda82.jpg	3	starter	f	family, guest	european, mediterranean, slavic, italian, tex-mex	all seasons	1	now, tomorrow, today	2024-05-14 23:56:14.394574	2024-05-15 00:12:55.050673	t
428	Spicy Turkish Tomato Salad	This salad is a vibrant and flavorful dish that combines fresh tomatoes, peppers, and a blend of spices to create a refreshing yet spicy salad. Perfect as a side dish or a light appetizer, this salad is a great way to add a bit of heat to your meal.	64a9234b-f2d9-464e-8b57-dbd558c1d8ee.jpeg	9	salad	f	weeknight, family, guest	universal	autumn, spring, summer	1	today, tomorrow, now	2024-06-22 18:38:02.092366	\N	t
446	Sardine Spread with Sun-Dried Tomatoes	Sardine Spread with Sun-Dried Tomatoes is a savory and flavorful spread, perfect for making delicious sandwiches or appetizers. Combining the rich taste of sardines with the intense flavor of sun-dried tomatoes, this spread is enhanced with natural yogurt for a creamy texture.	3161c272-f107-4dc0-8236-9673b288a980.jpeg	9	appetizer	f	guest, festive, romantic	european, mediterranean, slavic, italian	all seasons	1	now, today, tomorrow	2024-06-22 20:44:43.200779	\N	t
19	Chicken Escalopes in Honey-Apple Sauce	Chicken with fruit sauces is not only a delightful flavor combo but also a mood-boosting table decoration. These chicken escalopes take under 40 minutes to make, perfect for entertaining or treating yourself on a regular day.	d0f77969-fe81-45b1-84bf-81934dd1d361.jpg	7	main dish	t	weeknight, family, guest, festive, romantic	european, east asian, mediterranean, italian, tex-mex	all seasons	1	now, today, tomorrow	2024-05-09 17:12:03.036879	2024-05-09 18:06:59.429257	t
432	Warm Salad with Liver and Balsamic Onions	This warm salad combines tender chicken liver with caramelized apples, balsamic onions, and fresh arugula, topped with cherry tomatoes and toasted pine nuts. It’s a delicious and sophisticated dish that can be enjoyed as a main course or a hearty appetizer.	deea5d70-9784-4fb3-bec2-4d9c4909df58.jpg	9	salad	f	guest, festive, romantic	european, mediterranean, slavic, italian	all seasons	2	today, tomorrow	2024-06-22 19:04:40.629544	\N	t
424	Pork with Soba (Buckwheat Noodles)	Pork with Soba is a delicious and quick stir-fry dish featuring tender pork, fresh vegetables, mushrooms, and buckwheat noodles, all brought together with soy sauce and a sprinkle of sesame seeds. Perfect for a satisfying and healthy meal.	e5bfe1e0-25bd-4554-b876-72ba6abaa04e.jpg	7	main dish	f	weeknight, family, guest	east asian, european	all seasons	1	now, today, tomorrow	2024-06-22 17:54:21.959184	\N	t
27	Country Style Potatoes	These seasoned potato wedges are baked to a golden crisp, combining a soft interior with a crunchy exterior. Garlic, paprika, and fresh dill enhance the flavor, making them a delightful side dish.	a32dd5fa-f826-4046-be75-85569d1399c6.jpg	3	side dish	f	weeknight, family	european, slavic, italian, tex-mex	all seasons	1	now, today, tomorrow	2024-05-12 19:51:23.537713	2024-05-12 19:53:39.330137	t
41	Simple Cheese and Deli Meat Canapés	These simple canapés feature cheese and thinly sliced deli meat, such as prosciutto or salami, paired with crisp cucumber. Each bite-sized piece is artfully arranged on a toothpick, making them perfect for effortless entertaining.	42cdb15a-b2a4-45a8-8468-125d3dc428c9.jpg	3	appetizer	f	festive, romantic	european, mediterranean, slavic, italian	all seasons	1	today, now, tomorrow	2024-05-16 14:01:41.753485	2024-05-26 17:36:32.525162	t
20	Asian-style Pork Chops on the Bone in Orange Marinade	This recipe offers an exciting and easy way to prepare a unique pork dish. Your family and friends will be pleasantly surprised as they most likely have never tried anything like it before.	95d2732b-c94d-454a-92db-a337029f5286.jpg	7	main dish	t	family, guest, weeknight	east asian, mediterranean, italian, tex-mex, european	all seasons	2	now, today, tomorrow	2024-05-09 18:05:29.230881	2024-05-09 18:09:52.902191	t
114	Shrimp and Pineapple Canapés	These shrimp and pineapple canapés are a delightful and refreshing appetizer, perfect for any occasion. Easy to prepare and visually appealing, they are sure to impress your guests.	d45c54d9-ace0-4b58-a073-2b3546fdb9bf.jpeg	9	appetizer	f	festive, romantic	european, east asian, mediterranean, italian, tex-mex	all seasons	1	now, today, tomorrow	2024-06-08 00:06:19.403767	2024-06-08 04:27:05.208411	t
109	Versatile Vegetable and Avocado Salad	This vegetable and avocado salad is perfect for any occasion. Fresh and vibrant, it's a delightful mix of creamy avocado, juicy tomatoes, and crisp cucumbers, all brought together with a zesty lemon dressing.	cf66da54-eb2b-4182-adc7-fb7b8b7fd340.jpeg	4	salad	f	family, guest	european, east asian, mediterranean, italian, tex-mex	all seasons	1	now, today, tomorrow	2024-06-07 22:03:53.21629	2024-06-08 04:56:18.874962	t
429	Crostini with Ricotta and Roasted Tomatoes	Crostini with Ricotta and Roasted Tomatoes is a delicious appetizer that combines creamy ricotta with the sweet and tangy flavor of roasted cherry tomatoes. Topped with fresh basil, this elegant dish is perfect for entertaining or a delightful snack.	8f0bf479-5012-493b-a98e-9edc6cf5ef0d.jpeg	9	appetizer	f	festive, romantic	european, mediterranean, slavic, italian, tex-mex	all seasons	\N	today, tomorrow, now	2024-06-22 18:43:54.611195	\N	t
14	Cheese Spread Appetizers on Crackers	This is one of the easiest appetizers to make. It uses a combination of tomatoes and cheese that will please all guests. It can be prepared almost instantly using a blender. Cooking speed is very important if you want to serve many different dishes for your festive dinner.	bd8c272b-f86a-4b03-943c-12ba031d4356.jpg	3	appetizer	f	festive, romantic	european, mediterranean, slavic, italian	all seasons	1	today, tomorrow, now	2024-05-08 18:42:03.609476	2024-05-30 15:20:23.086054	t
31	Delicate Cottage Cheese Cookies	\r\nThese delicate cottage cheese cookies offer a tender, melt-in-your-mouth texture, combining rich margarine and light cottage cheese. Perfect for a sweet snack or dessert, these crescents are simple to make and deliciously comforting.	df9f9758-adb2-439a-bd7a-9ab1869c03b5.jpg	3	desert	f	family, guest	european, mediterranean, slavic, italian	all seasons	3	today, tomorrow	2024-05-14 13:57:01.790803	2024-05-14 21:32:20.435122	t
437	Chinese Smashed Cucumbers	Chinese smashed cucumbers are a flavorful and refreshing appetizer. This dish features lightly smashed cucumbers tossed with garlic, chili, and a tangy sesame-soy dressing, garnished with fresh cilantro.	5c469203-afd5-41a8-b9c5-09bacb211548.jpeg	3	salad	f	family, guest, weeknight	east asian	all seasons	1	now, today, tomorrow	2024-06-22 19:42:11.929524	2024-06-22 21:37:36.168692	t
442	Vegetable Salad with Peanut Dressing	This vibrant vegetable salad is tossed with a flavorful peanut dressing. It combines the crunchiness of fresh vegetables with the tangy, slightly spicy dressing made from roasted peanuts, herbs, and a touch of honey.	2f6399f3-0126-46f9-8bc4-3c68481b41e3.jpeg	9	salad	f	family, guest, festive	east asian, european, mediterranean	all seasons	1	now, today, tomorrow	2024-06-22 20:22:47.073187	\N	t
447	Grilled Vegetables	A simple and delicious way to enjoy a variety of vegetables with a smoky, charred flavor. Perfect as a side dish or a light main course, these grilled vegetables are both healthy and satisfying.	default_img.jpg	3	side dish	f	weeknight, family, guest, festive, romantic	european, mediterranean, slavic, italian, tex-mex	all seasons	1	now, today	2024-06-22 21:29:55.764688	\N	t
10	Chicken with Garlic and Crispy Bacon	It is widely recognized that chicken pairs beautifully with garlic, cream, and bacon. This dish combines all of these elements harmoniously, resulting in a flavor profile that is simply enchanting. The chicken is incredibly tender, while the garlic adds a delightful hint of piquancy to the overall taste.	8a8b9235-908e-4f72-8f06-d4f75049a982.jpg	4	main dish	t	family, guest	european, mediterranean, slavic, italian	all seasons	2	today, tomorrow	2024-05-07 22:34:16.49738	2024-05-09 16:02:36.774117	t
430	Perfect White Rice	Perfect White Rice is a versatile side dish that complements both European and Eastern cuisines. Simple and fluffy, it serves as a great base for a variety of main dishes.	default_img.jpg	9	side dish	f	weeknight, family, guest, festive, romantic	universal	all seasons	1	now, today, tomorrow	2024-06-22 18:47:41.303697	\N	t
115	Ham, Cheese, and Olive Canapés	These ham, cheese, and olive canapés are a perfect bite-sized appetizer, ideal for any gathering or party. The combination of savory ham, creamy cheese, crisp cucumber, and tangy olives provides a delightful variety of flavors and textures in every bite.	236732aa-a607-4c64-b1d2-6dbfc73f4a27.jpg	9	appetizer	f	romantic, festive	european, mediterranean, slavic, italian	all seasons	1	today, tomorrow, now	2024-06-08 00:11:31.61769	2024-06-09 22:46:06.629798	t
9	Greek Style Chicken Legs in Tomato Sauce	The classic tomato sauce infused with aromatic herbs imparts a rich taste and delightful aroma to the chicken. This combination of flavors creates a truly inviting dish that is both comforting and satisfying.	a330f1be-b4d9-4cd5-ab99-eabba9e1bccb.jpg	3	main dish	t	family, guest	universal	all seasons	2	today, tomorrow	2024-05-07 21:35:35.216747	2024-05-09 16:18:37.531707	t
110	Braised Pork with Mushrooms and Apples	This braised pork dish combines the savory flavors of tender pork and earthy mushrooms with the sweet and tart notes of apples. Slow-cooked to perfection, it’s a hearty and comforting meal that’s perfect for any occasion.	972d0385-cf6d-4683-a8bd-32407c56677b.jpeg	4	main dish	t	family, guest	european, mediterranean, slavic, italian, tex-mex	all seasons	2	tomorrow, today	2024-06-07 22:12:35.025105	2024-06-10 07:36:16.403818	t
17	Provencal-style Stewed Beans with Vegetables	This versatile side dish complements a wide variety of main courses, including meat, fish, and chicken. Its simple preparation process involves soaking the beans overnight, ensuring they are tender and ready to be cooked the next day. 	0e234480-1025-4b69-85f9-e81e5d329a96.jpg	3	side dish	f	family, guest, festive	european, mediterranean, slavic, italian, tex-mex	all seasons	2	tomorrow	2024-05-09 01:22:12.547406	2024-05-09 16:30:39.3517	t
123	Thai Chicken with Rice and Pineapple	This Thai-inspired dish combines tender chicken, fragrant jasmine rice, and sweet pineapple with a blend of spices and cashews for a delicious and exotic meal. It's a perfect balance of savory, sweet, and spicy flavors that will transport your taste buds to Thailand.	48e9f3ef-3ecb-4387-8080-de494cee9d72.jpg	3	main dish	f	weeknight, family, guest	east asian	all seasons	2	now, today, tomorrow	2024-06-14 14:53:12.399625	2024-06-14 16:27:41.568249	t
21	Colorful Bean and Corn Salad	This salad showcases the beauty of simplicity, using the most basic ingredients to create a dish that's both delicious and easy to prepare.	8e0a62d4-b027-4acc-aef1-959328e6c1ae.jpg	3	salad	f	weeknight, family, guest	universal	all seasons	1	now, today, tomorrow	2024-05-09 19:33:29.486868	2024-05-09 21:33:42.630623	t
23	Parmentier: A Delicate Soup with a Zesty Touch	Leeks play the starring role in Parmentier, so make sure to use plenty of them – not just one stalk. However, the onion flavor is not harsh, but only adds a bit of zest.	17a2c3c0-dbdc-4880-9185-c4cf1350d6af.jpg	3	soup	f	weeknight, family, romantic	european, slavic, italian, mediterranean	all seasons	1	now, today, tomorrow	2024-05-09 20:29:42.439131	2024-05-09 21:39:52.731745	t
24	Carrot Salad with Garlic	This salad contains just three simple ingredients and can be prepared in less than 10 minutes. It's the best option when you're tired or don't have time to cook something complex.	b0cb04f2-2634-4ec1-b258-342368dab1a8.jpg	4	salad	f	weeknight	european, mediterranean, slavic, italian	all seasons	1	now, today, tomorrow	2024-05-11 12:37:33.377324	2024-05-11 13:21:45.100922	t
25	Spicy Tomato Starter	Preparing this starter is incredibly simple, but it needs time to marinate. Therefore, it's best to prepare it the day before or in the morning on a non-working day so that it's ready by dinner time.	c49fa05d-e3f6-4188-b130-cc70daa22ac5.jpg	4	starter	f	weeknight, family, guest	universal	autumn, spring, summer	1	tomorrow	2024-05-11 13:06:17.563175	2024-05-11 13:31:58.048678	t
383	Madras Chicken Curry	Madras Chicken Curry is a spicy and aromatic dish hailing from Southern India. This flavorful curry combines tender chicken with a blend of spices, tomatoes, and chilies to create a rich and satisfying meal.	4600f999-0b9d-49e1-a07c-df908a2d3500.jpg	7	\N	\N	\N	\N	\N	\N	\N	2024-06-20 21:16:20.816768	2024-06-21 20:17:57.057017	f
396	Famous Israeli Hummus	Israeli hummus is a creamy, rich, and flavorful dip made from chickpeas, tahini, lemon juice, and garlic. It's perfect for serving with pita bread, vegetables, or as part of a mezze platter. This recipe ensures a smooth and authentic taste.	c4b18e99-3e68-4470-ba38-e0a261f3410b.jpg	3	\N	\N	\N	\N	\N	\N	\N	2024-06-21 20:45:12.426699	\N	f
1	Tuna Salad with Vegetables	This salad is not only delicious but also healthy, as it does not contain mayonnaise. The dressing is made with olive oil and lemon juice.	a040c36b-3f68-419c-812f-ab07068930bb.jpg	4	salad	f	weeknight, family, guest, festive	universal	all seasons	1	now, today, tomorrow	2024-05-07 10:57:54.858165	2024-05-09 15:57:21.042568	t
28	Chicken a la Caprese	This dish combines the beloved flavors of a classic Italian Caprese salad with chicken, making for a delightful meal. With mozzarella, cherry tomatoes, and basil, it’s a quick yet impressive option perfect for a weeknight dinner after work.	ef9ae747-c5a5-4ed7-b21c-ff7f1adc0580.jpg	7	main dish	t	weeknight, family	european, mediterranean, italian	all seasons	1	now, today, tomorrow	2024-05-13 00:22:04.932888	2024-05-13 00:45:19.451745	t
32	Herb-Infused Pork Carbonade	This succulent pork starter is marinated with a rich blend of herbs including rosemary, cilantro, and parsley, enhanced with honey and mustard. Slow-baked to perfection, it offers a savory introduction to any meal, perfect for serving hot or cooled.	2cb19c89-0679-4f91-b224-9f7eb4a36f78.jpg	3	starter	f	family, guest, festive	european, tex-mex, italian, slavic	all seasons	3	tomorrow	2024-05-14 22:58:12.923512	2024-05-14 22:59:32.027544	t
2	Fettuccine with Salmon	An exquisite Italian-style dish that anyone can prepare. A delicate lemon-cream sauce turns this simple dish into a special pleasure that you can give to yourself and your loved ones even after a working day. The salmon, pasta and sauce are cooked at the same time, so you can start dinner as quickly as possible.	50961f17-fc3c-4bd5-8748-d52e4137aa94.jpg	3	main dish	f	weeknight, family, guest, romantic	european, mediterranean, italian	all seasons	1	now, today, tomorrow	2024-05-07 11:06:37.504028	2024-05-08 14:50:12.431414	t
4	Chicken Thighs with Rice in One Pan	Incredibly juicy chicken thighs are cooked together with a side dish in one frying pan. The rice is soaked in chicken juices and becomes very fragrant.	fb2b739e-8d39-4e33-9c9e-7decc2e35224.jpg	4	main dish	f	weeknight, family	universal	all seasons	1	now, today, tomorrow	2024-05-07 12:17:16.091745	2024-05-08 01:10:19.352837	t
11	Glossy Pork Marinated in Asian Style	The meat in this recipe turns out incredibly juicy, and the marinade gives the pork an Asian flavor. As for the spiciness, despite the large amount of ginger and chili pepper, it is practically not felt in the finished dish.	9b52d153-2064-4294-b64d-63f5316dc0fc.jpg	4	main dish	t	weeknight, family, guest	east asian, mediterranean, tex-mex	all seasons	2	today, tomorrow	2024-05-07 23:04:28.508743	2024-05-08 15:14:27.874695	t
3	Simple and Delicious Salad with Cod Liver	This dish features cod liver as its main ingredient, renowned as a culinary delicacy cherished by gourmets. With its exquisite taste and appeal, this salad is suitable for any occasion, guaranteed to impress your guests and leave a lasting impression.	a29fb593-81b3-4d83-9450-41d85aa76ba6.jpg	4	salad	f	weeknight, family, guest, festive	european, mediterranean, slavic, italian	all seasons	1	now, today, tomorrow	2024-05-07 11:43:56.55677	2024-05-09 16:24:31.467151	t
6	Tuna Salad with Rice	This is a very filling and simple salad. It contains only five ingredients, including dressing. This salad is best left in the fridge for several hours before serving. But if you don’t have time, you can serve the salad right away, it will also be delicious.	893d795a-c03a-44e4-bccc-42c661412d45.jpg	7	salad	f	family, guest, festive	european, slavic	all seasons	1	today, tomorrow	2024-05-07 18:18:53.081055	2024-05-07 18:34:16.87812	t
12	Finnish Salmon Soup	This smooth and creamy fish soup cooks faster than any soup you've ever tried. It's hard to believe that preparing such a delicious dish will take you less than 40 minutes.	e5d4f497-dab7-4c98-9d7b-c0d8bda0a766.jpg	7	soup	f	weeknight, family, guest	european, mediterranean, slavic	all seasons	1	now, today, tomorrow	2024-05-08 00:08:32.613604	2024-05-08 01:14:32.387082	t
13	Hungarian goulash	Hearty meat soup is ideal for the cold season. When there is a snowstorm or rain outside, a plate of goulash is the best thing that can await you at home. This soup must contain a lot of meat, parsley and paprika.	8fa677ac-299e-4aa3-8713-28c496087adc.jpg	7	soup	f	guest, family	european, slavic, italian, mediterranean	winter, autumn, spring	3	today, tomorrow	2024-05-08 00:55:33.258101	2024-05-09 15:46:15.037911	t
22	Tomato and Feta Salad with Pomegranate	The classic combination of tomatoes and feta cheese is elevated with the addition of pomegranate seeds for a zesty and visually appealing salad.	869426b0-d4a7-4a62-bd38-a0858d7aac33.jpg	3	salad	f	weeknight, family	universal	autumn, spring, summer	1	now, today, tomorrow	2024-05-09 19:52:43.91052	2024-05-11 13:23:51.684153	t
37	Fruit Salad with Pine Nuts	This refreshing fruit salad, dressed in natural yogurt and topped with pine nuts, is simple to prepare and perfect for a light, healthy treat. Enjoy this effortlessly delicious dessert without any heavy creams or oils.	2289c603-5b77-4cb6-9f91-c940ed9cca17.jpg	9	desert	f	festive, romantic, family, guest	universal	autumn, summer	1	today, tomorrow, now	2024-05-16 02:18:19.972262	2024-05-16 19:12:29.806189	t
46	Shrimp and Pineapple Cocktail	This refreshing shrimp and pineapple cocktail is perfect for a light appetizer. Combining the crispness of iceberg lettuce, the sweetness of pineapple, and the savory taste of shrimp, it's dressed with a zesty lemon garlic vinaigrette.	7aabf666-2193-4db1-aa0b-9e908b2f151d.jpg	4	salad	f	romantic	european, mediterranean, italian	all seasons	1	now, today, tomorrow	2024-05-16 20:08:52.364099	2024-05-16 23:27:40.008986	t
49	Chicken Wrapped in Bacon Appetizer	This chicken wrapped in bacon appetizer is a savory delight, combining juicy chicken fillet with crispy bacon. Paired with fresh cherry tomatoes, these bite-sized treats are perfect for any gathering, offering a tasty and easy-to-make option for your appetizer spread.	bc761f86-6664-4a14-a9a1-bfc9a84e5b95.jpeg	4	appetizer	f	festive, romantic	european, mediterranean, slavic, italian, tex-mex	all seasons	1	today, tomorrow	2024-05-16 21:25:48.956449	2024-05-16 23:29:31.501304	t
15	Eggs Stuffed with Cod Liver Pate	This is one of the most popular ways to use cod liver to make appetizer. This delicacy goes best with eggs, but there are other reasons for serving it this way. Stuffed eggs look beautiful on the table and guests will be comfortable eating them.	ba531129-4c37-4603-a852-fcf8198b12f0.jpg	3	appetizer	f	festive, romantic	european, mediterranean, italian, slavic	all seasons	1	today, tomorrow	2024-05-08 20:13:09.775432	2024-05-16 23:31:53.109824	t
45	Cherry Tomatoes Stuffed with Cheese and Topped with Shrimp	These cherry tomatoes stuffed with a cheese mixture and topped with succulent shrimp make an elegant and flavorful appetizer. Perfect for any occasion, they offer a delightful combination of textures and tastes in every bite.	23161c76-3c2f-4369-99d2-8908ab3ed8da.jpg	4	appetizer	f	festive, romantic	east asian, european, mediterranean, italian	all seasons	2	today, tomorrow	2024-05-16 19:54:00.771149	2024-05-21 16:08:18.901756	t
29	Fried Fish Milanese Style	This Milanese-style fried fish features a golden breadcrumb crust enhanced with lemon and parsley. Crispy on the outside and tender inside, it offers a flavorful and elegant twist on a classic dish, ideal for a delightful meal.	0c69cf61-c136-41ac-b472-9a470561f734.jpg	7	main dish	t	weeknight, family, guest, romantic	european, mediterranean, slavic, italian, tex-mex	all seasons	1	now, today, tomorrow	2024-05-13 00:43:17.359441	2024-05-13 00:47:18.734284	t
33	Chicken Rolls with Cheese and Spinach	These savory chicken rolls are stuffed with creamy cheese and fresh spinach, wrapped in bacon for an extra layer of flavor. Perfectly baked to create a delightful blend of textures and tastes, they make a great starter or main dish for any meal.	921c7b68-57ee-4fb3-b27d-fccb295fc4bb.jpg	4	hot starter	f	family, guest, festive, romantic	european, mediterranean, slavic, italian, tex-mex	all seasons	1	now, today, tomorrow	2024-05-14 23:14:54.223766	2024-05-15 00:11:23.165592	t
18	Fragrant Oven-Roasted Potatoes	Crispy on the outside and tender on the inside, the potatoes are filled with the aroma of rosemary and garlic. These potatoes take longer to cook than you might be used to, but the results are worth every minute you spend.	f2f291d4-4b37-4fc6-8863-54ed4fa5432c.jpg	3	side dish	f	weeknight, family, guest, festive, romantic	european, mediterranean, slavic, italian	all seasons	2	today, tomorrow	2024-05-09 01:56:04.858288	2024-05-09 15:05:54.106825	t
47	Appetizer Rolls with Salmon	These appetizer rolls combine the creamy texture of cheese with the fresh taste of dill and the rich flavor of salmon, all wrapped in a soft tortilla. Perfect for any gathering, they are easy to prepare and delightful to serve.	853252c0-e192-43ad-ae31-2ff49a9d6c53.jpg	4	appetizer	f	festive, romantic	european, mediterranean, slavic, italian, tex-mex	all seasons	1	today, tomorrow	2024-05-16 20:43:29.60057	2024-05-16 22:14:59.543892	t
38	Zesty Salmon Bites	These zesty salmon bites are marinated in a flavorful mix of soy sauce, ginger, and chili, then cooked in a thickened honey-sesame sauce. Each bite delivers a burst of bold flavors, making these salmon bites a perfect appetizer for any gathering or special occasion.	b16d6866-1aa3-4333-a463-a7a930660a06.jpg	9	appetizer	f	festive, romantic, guest	european, east asian, mediterranean, italian, tex-mex	all seasons	1	today, tomorrow	2024-05-16 03:28:11.510701	2024-05-16 22:18:12.896391	t
56	Soft Homemade Cinnamon Rolls	These soft and buttery homemade cinnamon rolls are filled with a sweet and fragrant cinnamon filling, making them perfect for a delightful breakfast or snack. They are easy to make and bring a cozy, comforting aroma to your kitchen.	c5fee956-7d96-432b-bcf5-c74426900938.jpg	7	desert	f	family, guest	universal	all seasons	3	tomorrow, today	2024-05-29 02:07:40.052284	2024-06-09 23:33:53.147681	t
39	Classic Deviled Eggs with Tuna	These classic deviled eggs are filled with a creamy mixture of tuna and soft cheese, making them a delightful addition to any celebration. Each bite offers a perfect balance of rich flavor and smooth texture, topped with a sprinkle of paprika for a hint of spice.	4c1d6b7a-f449-4e82-82b2-d8a02a40f807.jpg	9	appetizer	f	festive, romantic	european, mediterranean, slavic, italian	all seasons	1	today, tomorrow	2024-05-16 03:44:27.779061	2024-05-16 23:40:52.624482	t
42	Fruit Canapés with Feta Cheese	These vibrant fruit canapés pair the crumbly texture of feta cheese with the sweetness of mango and grapes. Skewered on toothpicks, each ingredient complements the others beautifully, creating an easy-to-eat appetizer that's perfect for parties or as a refreshing snack.	8af263fd-12d5-448b-a894-d7f01e11d736.jpg	3	appetizer	f	festive, romantic	universal	all seasons	1	today, tomorrow	2024-05-16 14:24:27.91416	2024-05-16 23:42:19.2968	t
52	Everyday Radish Salad	This light and refreshing radish salad is perfect for everyday meals. Combining crunchy radishes with green onions and creamy sour cream, it's a simple yet delicious dish that can be prepared in minutes.	81d2a75c-3203-41be-8fcf-94689e3ac120.jpg	4	salad	f	weeknight	european, mediterranean, slavic, italian	autumn, spring, summer	1	now, today, tomorrow	2024-05-17 00:40:28.130012	2024-05-17 01:38:49.662364	t
50	Pearl Barley Risotto with Green Peas	This creamy pearl barley risotto with green peas combines the nutty flavor of pearl barley with the sweetness of green peas, enriched with butter and Parmesan. It's a comforting and satisfying dish perfect for any occasion.	cbd04802-35bf-4687-8ab8-acdc5b605879.jpeg	4	side dish	f	family, guest, festive, romantic	european, mediterranean, slavic, italian	all seasons	2	today, tomorrow	2024-05-16 23:56:20.096548	2024-05-17 01:30:09.941456	t
54	Braised Osso Buco with Rice	This dish is the best proof that beef shanks can be used not just for economy, but for the wonderful taste of braised meat. Beef shanks develop a unique flavor when slow-cooked. The meat becomes so tender it practically falls apart, making it perfect for preparing in advance. 	5780e88e-2427-4c03-9a52-66bee4e27061.jpg	4	main dish	f	family, guest	european, central asian, east asian, slavic	all seasons	4	tomorrow	2024-05-17 01:27:07.668217	2024-05-17 01:35:26.829042	t
51	Simple and Stylish Salad with Chicken, Pear, and Spinach	This simple yet stylish salad features tender chicken, sweet pear, and fresh spinach, enhanced with dried cranberries and crunchy walnuts. The honey-Dijon dressing ties everything together for a delightful and sophisticated dish, perfect for any meal.	63558781-8f2a-47ce-a541-dbca46aae1a4.jpeg	4	salad	f	family, guest, festive	universal	all seasons	1	today, tomorrow	2024-05-17 00:34:25.684824	2024-05-17 01:32:41.225032	t
55	Spanish Stew with Turkey Meatballs	This Spanish stew with turkey meatballs is a hearty and flavorful dish, combining tender turkey meatballs with a rich blend of vegetables, chickpeas, and smoky paprika. Perfect for a comforting meal, this stew brings together vibrant flavors and wholesome ingredients for a satisfying culinary experience.	3c7383a0-39f6-402a-ba57-9de597950e9e.jpeg	7	main dish	f	family, guest	european, mediterranean, slavic, italian, tex-mex	all seasons	2	today, tomorrow	2024-05-28 02:05:34.556745	2024-05-28 02:07:29.694058	t
58	Everyday Cherry Tomato and Bean Salad	This everyday salad combines juicy cherry tomatoes, hearty white beans, and fresh parsley, dressed with a simple lemon and olive oil vinaigrette. It's a quick, healthy, and delicious option for any meal.	941a9819-a234-4a4a-9081-b2f796b16a38.jpg	3	salad	f	weeknight, family	universal	all seasons	1	now, today, tomorrow	2024-06-02 20:05:47.221204	2024-06-10 00:29:58.414076	t
107	Spring Rolls with Spicy Peanut Sauce	These spring rolls, filled with fresh vegetables and surimi, are paired with a spicy peanut sauce that adds a delightful kick. They can be served either hot or cold, making them a versatile and delicious starter.	4abcebd4-2f10-4c71-a9df-1d795568db7d.jpeg	7	starter	f	family, guest	east asian	all seasons	2	today, tomorrow	2024-06-07 21:21:11.007248	2024-06-08 04:46:48.310158	t
402	Exquisite French Chicken Liver Pâté	This Exquisite French Chicken Liver Pâté is a luxurious and creamy spread, perfect for a sophisticated appetizer or a special treat. Made with chicken liver, mushrooms, and a touch of cognac, it delivers rich and delicate flavors that are sure to impress.	459ac6bc-801e-457a-8f5c-d4fb2411494e.jpg	3	\N	\N	\N	\N	\N	\N	\N	2024-06-21 22:30:14.74789	\N	f
420	Strawberry and Mozzarella Salad	This fresh and colorful salad features the peppery taste of arugula paired with sweet strawberries and creamy mozzarella, topped with crunchy walnuts and a tangy honey-lemon dressing. It’s a delightful blend of flavors and textures perfect for any occasion.	df153455-5fd4-413d-924d-13ba6bea5806.jpg	3	salad	f	family, guest, festive, romantic	european, mediterranean, slavic, italian	spring, summer	1	now, today, tomorrow	2024-06-22 17:02:37.764923	2024-06-22 17:22:44.332001	t
433	Spicy Mexican Tortilla Soup	Spicy Mexican Tortilla Soup is a bold and flavorful dish perfect for those who enjoy a kick in their meals. This soup combines the rich taste of vegetables and beans with the heat of chili and spices, topped with fresh parsley and crispy tortilla chips for a delightful texture contrast.	1c403be8-495d-468d-8fb5-d7907666be0a.jpg	3	soup	f	weeknight, family	tex-mex, european	all seasons	2	today, tomorrow	2024-06-22 19:16:07.66066	\N	t
410	Italian Minestrone Soup	Minestrone is a classic Italian vegetable soup, known for its rich and hearty flavors. This versatile dish can be made with a variety of seasonal vegetables, beans, and pasta, creating a comforting and nourishing meal.	414aba48-6af1-4498-b938-83ee48916c24.jpeg	4	\N	\N	\N	\N	\N	\N	\N	2024-06-22 00:20:13.948881	\N	f
412	Peach and Mozzarella Salad	This refreshing salad combines the sweetness of peaches with the creaminess of mozzarella and the crunch of celery and pumpkin seeds. The tangy honey-mustard dressing adds a perfect finishing touch.	fbd6078b-2866-4986-91f4-bfe596b85d8e.jpeg	4	\N	\N	\N	\N	\N	\N	\N	2024-06-22 00:38:29.217225	2024-06-22 17:28:47.68798	f
425	Sweet Potato Casserole with Glazed Pecans	Sweet Potato Casserole with Glazed Pecans is a delightful dish that combines the natural sweetness of roasted sweet potatoes and bananas with a crunchy, buttery pecan topping. Perfect for a comforting side dish or dessert.	9a2b0baf-8b59-4044-ae91-5e60eee4b9b0.jpeg	7	side dish	f	family, guest, festive, romantic	european, mediterranean, italian, tex-mex	all seasons	2	today, tomorrow	2024-06-22 18:13:36.467691	2024-06-22 18:17:25.948186	t
445	Liver with Pumpkin and Apples	This dish combines tender chicken liver with sweet pumpkin and apples, creating a flavorful and nutritious meal. Enhanced with the warmth of cinnamon and a splash of white wine, it's a perfect dish for autumn or any time you crave comfort food.	4065c037-ab93-47fc-bc53-c842c9f574e1.jpg	9	main dish	f	weeknight, family	european, mediterranean, slavic, italian	autumn, summer	1	now, today, tomorrow	2024-06-22 20:41:07.60669	\N	t
443	Turkey Escalopes in Mandarin Marinade	Turkey Escalopes in Mandarin Marinade is a delightful dish that combines the tender texture of turkey with the sweet and tangy flavors of mandarin and a touch of heat from chili. This dish is perfect for a special dinner, offering a unique and flavorful twist on traditional turkey escalopes.	c6a6f23b-a786-4717-ae61-8e83d77d7bd4.jpg	9	main dish	t	weeknight, family, guest, festive, romantic	european, mediterranean, slavic, italian	all seasons	1	now, today, tomorrow	2024-06-22 20:29:09.89516	\N	t
438	Italian "Wedding" Soup with Spinach and Meatballs	Italian "Wedding" Soup is named not because it's traditionally served at weddings, but because of the beautiful "marriage" of flavors and ingredients that blend harmoniously together. The combination of hearty meatballs, nutritious spinach, and flavorful broth creates a delightful and comforting soup perfect for any occasion.	dd8e3295-dc16-46bb-8fa1-204681252fe9.jpeg	7	soup	f	family, guest	european, mediterranean, italian, slavic	all seasons	2	today, tomorrow	2024-06-22 19:47:32.55082	\N	t
406	Lamb with Prunes in Clay Pots	This traditional dish combines tender lamb, hearty potatoes, and sweet prunes, slow-cooked to perfection in individual clay pots. The flavors meld together beautifully, creating a rich and comforting meal.	eea26ed3-dcc3-4b04-a360-6194e9c0fbb3.jpg	4	main dish	f	family, guest	european, slavic, central asian	all seasons	3	today, tomorrow	2024-06-21 23:21:35.094339	2024-06-22 13:17:00.535193	t
408	Bright and Colorful Mediterranean Salad	This vibrant Mediterranean salad is packed with fresh vegetables, lentils, and herbs, offering a delightful mix of flavors and textures. Topped with feta and a tangy dressing, it's a perfect light and healthy meal.	k3hj-kj43-fkti-fjdh3495.jpg	4	\N	\N	\N	\N	\N	\N	\N	2024-06-21 23:39:39.060358	2024-06-22 13:35:44.306723	f
414	Fish in Tomato Sauce	This dish features tender white fish fillets cooked in a rich and flavorful tomato sauce with vegetables and herbs. It’s a delightful and hearty meal that’s perfect for a family dinner.	f1b17520-e512-48bf-9a87-81f7fa6b5514.jpeg	4	\N	\N	\N	\N	\N	\N	\N	2024-06-22 01:05:05.748403	\N	f
421	Salad with Young Radishes and Cucumbers	This fresh and vibrant salad features crisp radishes, juicy cucumbers, and creamy feta, topped with toasted pumpkin seeds. It's a perfect light and healthy dish for any meal.	b3d95e26-6667-41ba-bffe-36d9aa789ee7.jpg	3	salad	f	weeknight, family	european, mediterranean, slavic, italian	spring, summer	1	now, today, tomorrow	2024-06-22 17:36:33.322275	\N	t
434	Pumpkin Cream Soup with Curry and Honey	Pumpkin Cream Soup with Curry and Honey is a comforting and flavorful dish perfect for the fall season. The sweetness of honey complements the warmth of curry, creating a rich and aromatic soup. Topped with natural yogurt and pumpkin seeds, this soup is both nourishing and delicious.	b83afefd-4ca3-4fff-a2e6-9e8df26ffe54.jpg	3	soup	f	weeknight, family, romantic	european, mediterranean, slavic, tex-mex	all seasons	1	now, today, tomorrow	2024-06-22 19:20:05.019001	\N	t
431	Creamy Mashed Potatoes	Creamy Mashed Potatoes are a classic side dish that pairs well with a variety of main courses. Made with buttery, smooth potatoes, this comforting dish is perfect for family meals and special occasions.	f0184623-e2af-4514-ae4c-9cb8cf99227b.jpg	9	side dish	f	weeknight, family, guest, festive, romantic	european, mediterranean, slavic, italian, tex-mex	all seasons	1	now, today, tomorrow	2024-06-22 18:51:46.767417	\N	t
444	Thai Caramel Chicken	Thai Caramel Chicken is a delicious and flavorful dish featuring tender chicken, colorful vegetables, and chewy glass noodles all coated in a sweet and savory caramel sauce. Quick to cook and bursting with flavor, this dish is perfect for a vibrant meal.	f5658fa9-7384-4280-828d-8ad142d623ac.jpeg	9	main dish	f	weeknight, family, guest	east asian	all seasons	1	now, today, tomorrow	2024-06-22 20:33:05.400745	\N	t
426	Russian Aspic Meat	Russian Aspic Meat is a traditional cold dish made with beef, chicken, and a clear, flavorful broth set with gelatin. It's beautifully garnished with vegetables and herbs, making it a visually appealing and delicious appetizer.	6aa555f5-fafc-4b5c-b2a5-a8353136219c.jpg	9	starter	f	guest, festive	european, slavic	all seasons	4	tomorrow	2024-06-22 18:25:41.458157	\N	t
439	Classic Borscht for Family and Friends	Classic Borscht is a rich and flavorful Ukrainian soup made with beef bones and meat, a variety of vegetables, and a unique blend of spices. This hearty dish is perfect for family gatherings and friendly get-togethers, offering a comforting and satisfying meal.	daf254f0-c8ca-42d9-9270-bfacfd374791.jpg	7	soup	f	family, guest	european, slavic	all seasons	3	today, tomorrow	2024-06-22 19:53:54.795266	\N	t
415	Sprats with Avocado Cream on Rye Toasts	This elegant appetizer features crispy rye toasts topped with creamy avocado, flavorful sprats, and tangy pickled cucumbers. Perfect for a sophisticated snack or a light meal.	c279c1ed-65a2-40b8-860f-51634916c9d0.jpg	9	appetizer	f	family, guest, festive	european, slavic, mediterranean	all seasons	1	now, today, tomorrow	2024-06-22 01:37:40.28203	2024-06-22 01:40:19.738978	t
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ingredients (id, dish_id, index, name, measurement, amount, category, is_main) FROM stdin;
41	4	11	pepper	tsp	0.3	seasoning	f
42	4	12	chicken broth	cup	3	other	f
85	10	1	chicken fillets	g	600	chicken	t
44	4	14	green onion feathers		4	greenery	f
18	2	7	lemon		0.5	fruits	f
19	2	8	olive oil	tbsp	2.5	sauces	f
20	2	9	dill sprigs		3	greenery	f
21	2	10	parsley sprigs		3	greenery	f
22	2	11	salt	tsp	0.3	seasoning	f
23	2	12	pepper	tsp	0.3	seasoning	f
63	8	3	carrot		1	vegetables	f
64	8	4	buckwheat	g	100	cereal	f
65	8	5	butter	g	50	dairy	f
66	8	6	salt	tsp	1	seasoning	f
67	8	7	pepper	tsp	0.5	seasoning	f
68	8	8	vegetable oil	tbsp	2	sauces	f
69	8	9	parsley sprigs		4	greenery	f
25	3	2	frisee salad	g	100	greenery	f
49	5	5	sugar	g	80	sweets	f
50	5	6	gelatin	tsp	1.6	baking supplies	f
51	5	7	berries (optional)	g	50	fruits	f
86	10	2	chicken broth	ml	500	other	f
87	10	3	bacon strips		6	deli meats	f
88	10	4	garlic clove		3	vegetables	f
89	10	5	light cream	ml	200	dairy	f
90	10	6	soy sauce	tsp	1	sauces	f
91	10	7	flour	tbsp	4	cereal	f
92	10	8	parmesan	g	50	cheese	f
93	10	9	parsley sprigs		4	greenery	f
94	10	10	thyme	tsp	1	seasoning	f
95	10	11	dry mustard	tsp	1	seasoning	f
96	10	12	salt	tsp	0.3	seasoning	f
52	6	1	canned tuna	g	200	canned fish	t
53	6	2	rice	cup	0.75	rice	t
54	6	3	onion		1	vegetables	f
55	6	4	eggs		4	eggs	f
56	6	5	mayonnaise	g	250	sauces	f
57	6	6	salt	tsp	0.2	seasoning	f
61	8	1	whole chicken	g	1800	chicken	t
62	8	2	onion		1	vegetables	f
31	4	1	chicken thighs		5	chicken	t
32	4	2	onion		1	vegetables	f
33	4	3	carrot		3	vegetables	f
34	4	4	celery stalk		3	vegetables	f
35	4	5	lemon		0.5	fruits	f
36	4	6	garlic cloves		2	vegetables	f
37	4	7	rice	cup	1	rice	t
38	4	8	thyme sprigs		3	greenery	f
39	4	9	paprika	tbsp	1	seasoning	f
40	4	10	salt	tsp	0.3	seasoning	f
43	4	13	vegetable oil	tbsp	2	sauces	f
1	1	1	canned tuna	g	180	canned fish	t
2	1	2	tomato		2	vegetables	f
3	1	3	feta cheese	g	100	cheese	f
4	1	4	red onion		0.5	vegetables	f
5	1	5	frisee salad	g	100	greenery	f
12	2	1	salmon fillets	g	250	fish	t
13	2	2	fettuccine pasta	g	200	pasta	t
14	2	3	green beans	g	100	vegetables	f
15	2	4	cream cheese	g	90	cheese	f
16	2	5	tomato paste	tbsp	1	sauces	f
17	2	6	garlic clove		1	vegetables	f
6	1	6	pumpkin seeds	tbsp	2	dry food	f
7	1	7	olive oil	tbsp	3	sauces	f
8	1	8	lemon		0.5	fruits	f
9	1	9	mustard	tsp	1	sauces	f
10	1	10	salt	tsp	0.3	seasoning	f
11	1	11	pepper	tsp	0.3	seasoning	f
70	9	1	chicken legs	kg	1	chicken	t
71	9	2	onions		2	vegetables	f
72	9	3	garlic cloves		3	vegetables	f
73	9	4	tomatoes		3	vegetables	f
74	9	5	canned tomatoes	g	400	canned goods	f
75	9	6	dry white wine	ml	100	other	f
76	9	7	thyme	tsp	0.5	seasoning	f
77	9	8	oregano	tsp	0.5	seasoning	f
78	9	9	sugar	tsp	0.25	sweets	f
79	9	10	tomato paste	tbsp	1	sauces	f
80	9	11	grated parmesan	tbsp	2	cheese	f
81	9	12	parsley sprigs		4	greenery	f
82	9	13	salt	tsp	0.5	seasoning	f
83	9	14	pepper	tsp	0.5	seasoning	f
84	9	15	vegetable oil	tbsp	2	sauces	f
24	3	1	cod liver	g	200	seafood	t
26	3	3	quail eggs		8	eggs	f
27	3	4	cherry tomato		10	vegetables	f
28	3	5	olive oil	tbsp	1	sauces	f
29	3	6	salt	tsp	0.2	seasoning	f
30	3	7	pepper	tsp	0.2	seasoning	f
45	5	1	bitter chocolate	g	320	sweets	t
46	5	2	35% heavy cream	ml	320	dairy	f
47	5	3	milk	ml	800	dairy	f
48	5	4	eggs		5	eggs	f
108	12	1	salmon fillets	g	250	fish	t
109	12	2	salmon heads and tails	g	350	fish	f
110	12	3	potato	g	400	potato	f
111	12	4	onions		2	vegetables	f
112	12	5	carrot		1	vegetables	f
113	12	6	light cream	ml	200	dairy	f
114	12	7	dill sprigs		3	greenery	f
115	12	8	bay leaves		2	seasoning	f
116	12	9	salt	tsp	0.5	seasoning	f
157	17	9	chicken broth	l	1	other	f
99	11	1	pork tenderloin	g	500	meat	t
100	11	2	garlic cloves		5	vegetables	f
101	11	3	chili pepper		2	vegetables	f
102	11	4	ginger	g	2	vegetables	f
103	11	5	honey	tsp	1	sauces	f
104	11	6	oyster sauce	tbsp	2	sauces	f
105	11	7	soy sauce	tbsp	2	sauces	f
106	11	8	Sesame oil	tbsp	1	sauces	f
107	11	9	cilantro sprigs		2	greenery	f
117	12	10	vegetable oil	tbsp	1	sauces	f
160	18	1	potatoes	g	800	potato	t
161	18	2	garlic cloves		8	vegetables	f
162	18	3	rosemary sprigs		2	greenery	f
163	18	4	olive oil	tbsp	3	sauces	f
164	18	5	salt	tsp	0.3	seasoning	f
118	13	1	beef	g	800	meat	t
119	13	2	onions		2	vegetables	f
120	13	3	carrot		1	vegetables	f
121	13	4	potatoes	g	800	potato	f
122	13	5	bell peppers		2	vegetables	f
123	13	6	tomato		1	vegetables	f
124	13	7	garlic clove		1	vegetables	f
125	13	8	tomato paste	tsp	2	vegetables	f
126	13	9	parsley sprigs		10	greenery	f
127	13	10	bay leaves		3	seasoning	f
128	13	11	paprika	tbsp	2	seasoning	f
129	13	12	salt	tsp	1	seasoning	f
130	13	13	peppercorns		8	seasoning	f
131	13	14	butter	g	30	dairy	f
97	10	13	pepper	tsp	0.3	seasoning	f
98	10	14	vegetable oil	tbsp	1	sauces	f
149	17	1	white beans	g	400	beans	t
150	17	2	onion		1	vegetables	f
151	17	3	carrots		2	vegetables	f
152	17	4	celery stalk		2	vegetables	f
153	17	5	garlic cloves		3	vegetables	f
154	17	6	parsley sprigs		6	greenery	f
155	17	7	thyme sprigs		3	greenery	f
156	17	8	parmesan	g	20	cheese	f
158	17	10	olive oil	tbsp	2	sauces	f
159	17	11	salt	tsp	0.5	seasoning	f
165	19	1	chicken fillets	g	500	chicken	t
166	19	2	shallots		3	vegetables	f
167	19	3	garlic cloves		3	vegetables	f
168	19	4	apple		1	fruits	f
169	19	5	dry white wine	ml	70	other	f
170	19	6	honey	tbsp	1	sauces	f
171	19	7	thyme sprigs		3	greenery	f
172	19	8	parsley sprigs		3	greenery	f
173	19	9	salt	tsp	0.3	seasoning	f
174	19	10	pepper	tsp	0.3	seasoning	f
175	19	11	vegetable oil	tbsp	2	sauces	f
176	20	1	Pork chops on the bone		4	meat	t
177	20	2	ginger	g	2	vegetables	f
178	20	3	garlic cloves		3	vegetables	f
179	20	4	orange		1	fruits	f
180	20	5	brown sugar	tbsp	2	sweets	f
181	20	6	rice vinegar	tbsp	2	sauces	f
182	20	7	sriracha sauce	tbsp	1	sauces	f
183	20	8	vegetable oil	tbsp	4	sauces	f
184	20	9	sesame oil	tbsp	0.5	sauces	f
185	20	10	cilantro sprigs		2	greenery	f
186	20	11	green onion stalk		2	greenery	f
187	21	1	canned red beans	g	100	canned beans	t
188	21	2	canned corn	g	100	canned goods	f
189	21	3	salad greens	g	100	greenery	f
190	21	4	cucumber		1	vegetables	f
191	21	5	red onion		0.5	vegetables	f
192	21	6	walnuts	g	50	dry food	f
193	21	7	parsley sprigs		4	greenery	f
194	21	8	olive oil	tbsp	3	sauces	f
195	21	9	white wine vinegar	tbsp	1	sauces	f
196	21	10	oregano	tsp	1	seasoning	f
197	21	11	salt	tsp	0.3	seasoning	f
198	21	12	pepper	tsp	0.3	seasoning	f
206	23	1	leeks		3	vegetables	t
207	23	2	potatoes		3	potato	f
208	23	3	cauliflower	g	250	vegetables	f
209	23	4	light cream	tbsp	3	dairy	f
210	23	5	green onion feathers		6	greenery	f
212	23	7	salt	tsp	0.3	seasoning	f
199	22	1	tomatoes		2	tomato	t
200	22	2	shallots		3	vegetables	f
201	22	3	pomegranate		0.25	fruits	f
203	22	5	olive oil	tbsp	2	sauces	f
204	22	6	salt	tsp	0.3	seasoning	f
205	22	7	pepper	tsp	0.3	seasoning	f
142	15	1	cod liver	g	200	seafood	t
144	15	3	red onion		0.5	vegetables	f
145	15	4	mayonnaise	tsp	1	sauces	f
147	15	6	pepper	tsp	0.25	seasoning	f
143	15	2	eggs		5	eggs	t
211	23	6	baguette		0.5	other	f
213	23	8	pepper	tsp	0.3	seasoning	f
214	24	1	carrots		3	carrot	t
215	24	2	garlic clove		1	vegetables	f
216	24	3	walnut	g	50	dry food	f
217	24	4	mayonnaise	g	90	sauces	f
218	24	5	salt	tsp	0.2	seasoning	f
202	22	4	feta cheese	g	100	cheese	f
219	25	1	tomatoes		4	tomato	t
220	25	2	bell pepper		1	vegetables	f
221	25	3	garlic cloves		3	vegetables	f
222	25	4	chili peppers		1	vegetables	f
223	25	5	cilantro sprigs		5	greenery	f
224	25	6	parsley sprigs		5	greenery	f
225	25	7	wine vinegar	tbsp	1	sauces	f
226	25	8	vegetable oil	tbsp	1	sauces	f
227	25	9	sugar	tsp	1	seasoning	f
228	25	10	salt	tsp	1	sweets	f
229	26	1	quinoa	cup	1	cereal	t
230	26	2	salt	tsp	0.3	seasoning	f
231	27	1	potatoes	g	500	potato	t
232	27	2	garlic cloves 		2	vegetables	f
233	27	3	salt	tsp	0.3	seasoning	f
234	27	4	pepper	tsp	0.3	seasoning	f
235	27	5	paprika	tsp	1	seasoning	f
136	14	5	dill sprigs		5	greenery	f
137	14	6	tomatoes		3	tomato	t
139	14	8	walnuts	g	40	dry food	f
140	14	9	salt	tsp	0.2	seasoning	f
141	14	10	pepper	tsp	0.2	seasoning	f
132	14	1	cheese	g	200	cheese	t
134	14	3	garlic clove		3	vegetables	f
236	27	6	dill sprigs		5	greenery	f
237	27	7	vegetable oil	tbsp	2	sauces	f
238	28	1	 chicken breast		1	chicken	t
239	28	2	cherry tomatoes	g	150	tomato	f
240	28	3	mozzarella ball		1	cheese	f
241	28	4	flour	tbsp	2	cereal	f
242	28	5	egg		1	eggs	f
243	28	6	crackers	g	100	other	f
246	28	9	salt	tsp	0.3	seasoning	f
247	28	10	pepper	tsp	0.3	seasoning	f
248	28	11	oregano	tsp	0.5	seasoning	f
249	28	12	basil sprigs 		4	greenery	f
250	29	1	white fish fillets	g	600	fish	t
251	29	2	eggs		3	eggs	f
252	29	3	white bread	g	150	other	f
253	29	4	flour	tbsp	3	cereal	f
254	29	5	milk	cup	1.5	dairy	f
255	29	6	lemon		1	fruits	f
256	29	7	parsley sprigs 		6	greenery	f
257	29	8	salt	tsp	0.3	seasoning	f
258	29	9	pepper	tsp	0.3	seasoning	f
259	29	10	vegetable oil	tbsp	1	sauces	f
260	30	1	apples		2	fruits	t
261	30	2	cranberries	g	60	fruits	f
262	30	3	sour cream	g	100	dairy	f
263	30	4	butter	g	100	dairy	f
264	30	5	sugar	tbsp	2	sweets	f
265	30	6	vinegar	tbsp	1	seasoning	f
266	30	7	flour	cup	1.5	cereal	f
267	31	1	flour	cup	3	cereal	f
268	31	2	margarine	g	250	dairy	f
269	31	3	egg		1	eggs	f
270	31	4	cottage cheese	g	250	dairy	t
271	31	5	baking soda	tsp	0.5	other	f
272	31	6	vinegar	tbsp	1	sauces	f
273	31	7	sugar 	tbsp	10	sweets	f
274	32	1	pork loin	g	800	meat	t
275	32	2	onion		1	vegetables	f
276	32	3	garlic cloves 		2	vegetables	f
277	32	4	cilantro sprigs 		10	greenery	f
278	32	5	parsley sprigs 		10	greenery	f
279	32	6	rosemary sprigs 		4	greenery	f
280	32	7	honey	tbsp	1	sauces	f
281	32	8	mustard	tbsp	2	sauces	f
282	32	9	coriander seeds	tbsp	1	seasoning	f
283	32	10	Salt	tsp	1	seasoning	f
284	32	11	Pepper	tsp	1	seasoning	f
297	34	6	eggs		3	eggs	f
292	34	1	salmon fillet	g	250	fish	t
293	34	2	feta cheese	g	100	cheese	f
294	34	3	broccoli	g	300	vegetables	f
295	34	4	flour	g	260	cereal	f
296	34	5	butter	g	150	dairy	f
298	34	7	light cream	ml	200	dairy	f
299	34	8	Parmesan cheese	g	40	cheese	f
300	34	9	Salt	tsp	0.5	seasoning	f
301	34	10	Pepper	tsp	0.3	seasoning	f
285	33	1	Chicken breast		1	chicken	t
286	33	2	bacon	g	50	deli meats	f
287	33	3	soft cheese	g	100	cheese	f
288	33	4	spinach	g	70	greenery	f
289	33	5	bell pepper		0.5	vegetables	f
290	33	6	Salt	tsp	0.3	seasoning	f
291	33	7	Pepper	tsp	0.3	sauces	f
302	35	1	cheese	g	250	cheese	t
303	35	2	eggs		2	eggs	f
304	35	3	garlic cloves		3	vegetables	f
305	35	4	mayonnaise	g	100	sauces	f
306	35	5	dill sprigs 		5	greenery	f
307	35	6	ham	g	150	deli meats	f
308	35	7	salt	tsp	0.2	seasoning	f
309	35	8	pepper	tsp	0.2	seasoning	f
310	36	1	cream cheese	g	400	cheese	f
311	36	2	heavy cream	g	480	dairy	t
312	36	3	powdered sugar	tbsp	8	baking supplies	f
313	36	4	cocoa powder	tbsp	12	baking supplies	f
314	36	5	strawberries	g	400	fruits	f
316	36	7	walnuts	g	40	dry food	f
317	36	8	hazelnuts	g	40	dry food	f
318	36	9	shortbread cookies	g	400	sweets	f
319	37	1	melon	g	600	fruits	t
320	37	2	apricots	g	320	fruits	f
322	37	4	natural yogurt	g	400	dairy	f
315	36	6	almonds	g	40	dry food	f
321	37	3	strawberries	g	340	fruits	f
323	37	5	pine nuts	tbsp	4	dry food	f
339	40	1	canned tuna	g	200	canned fish	t
340	40	2	cucumbers		2	vegetables	f
341	40	3	avocado		0.5	vegetables	f
342	40	4	chili pepper		1	vegetables	f
343	40	5	celery stalk		1	vegetables	f
344	40	6	parsley sprigs 		4	greenery	f
345	40	7	mustard	tsp	1	sauces	f
346	40	8	hot sauce	tsp	1	sauces	f
347	40	9	salt	tsp	0.2	seasoning	f
348	40	10	pepper	tsp	0.2	seasoning	f
389	48	1	cheese	g	300	cheese	t
390	48	2	soft cheese	g	200	cheese	f
391	48	3	deli meats	g	50	deli meats	f
392	48	4	garlic cloves 		2	vegetables	f
393	48	5	dill sprigs		5	greenery	f
394	48	6	Salt	tsp	0.2	seasoning	f
395	48	7	Pepper	tsp	0.2	seasoning	f
327	38	4	chili peppers		2	vegetables	f
328	38	5	soy sauce	ml	120	sauces	f
329	38	6	honey	tbsp	2	sauces	f
330	38	7	sesame seeds	tbsp	2	dry food	f
385	47	1	cream cheese	g	200	cheese	f
386	47	2	lightly salted salmon	g	180	fish	f
387	47	3	dill sprigs		10	greenery	f
138	14	7	large crackers	g	180	other	f
349	41	1	thinly sliced deli meat	g	100	deli meats	t
350	41	2	cheese	g	150	cheese	t
351	41	3	cucumbers		3	fruits	f
388	47	4	large tortilla		1	other	t
331	38	8	green onions scallions		2	greenery	f
355	43	1	small sweet peppers		6	vegetables	f
356	43	2	brined cheese	g	120	cheese	t
146	15	5	salt	tsp	0.25	seasoning	f
332	39	1	eggs		6	eggs	t
333	39	2	canned tuna	g	180	canned fish	t
334	39	3	soft cheese	tsp	4	cheese	t
335	39	4	mayonnaise 	tsp	1	sauces	f
324	38	1	salmon fillet	g	240	fish	t
325	38	2	ginger	g	2	vegetables	f
326	38	3	garlic cloves 		2	vegetables	f
357	43	3	garlic cloves 		2	vegetables	f
358	43	4	parsley sprigs		6	greenery	f
359	43	5	pepper 	tsp	0.2	seasoning	f
360	43	6	Olive oil	tsp	2	sauces	f
361	44	1	cherry tomatoes	g	80	tomato	t
362	44	2	feta cheese	g	50	cheese	t
363	44	3	salad leaves	g	50	greenery	f
364	44	4	Olive oil	tbsp	2	sauces	f
365	44	5	Lemon juice	tbsp	0.5	sauces	f
366	44	6	Salt	tsp	0.2	seasoning	f
367	44	7	Pepper	tsp	0.2	seasoning	f
376	46	1	Shrimp	g	100	seafood	t
377	46	2	canned pineapple	g	120	canned goods	f
378	46	3	Cherry tomatoes	g	100	tomato	f
379	46	4	iceberg lettuce	g	90	greenery	f
380	46	5	Lemon juice	tbsp	1	sauces	f
381	46	6	garlic clove		1	vegetables	f
382	46	7	Olive oil	tbsp	3	sauces	f
383	46	8	Salt	tsp	0.2	seasoning	f
384	46	9	Pepper	tsp	0.2	seasoning	f
396	49	1	chicken fillet	g	300	chicken	t
397	49	2	bacon	g	150	deli meats	f
398	49	3	cherry tomatoes	g	200	tomato	f
336	39	5	Salt	tsp	0.2	seasoning	f
337	39	6	Pepper	tsp	0.2	seasoning	f
352	42	1	feta cheese	g	100	cheese	f
353	42	2	mango		1	fruits	t
354	42	3	grapes	g	120	fruits	f
399	50	1	pearl barley	cup	1	cereal	t
400	50	2	butter	g	100	dairy	f
401	50	3	onion		1	vegetables	f
402	50	4	dry white wine	ml	80	other	f
403	50	5	vegetable broth	l	1	other	f
404	50	6	frozen green peas	g	120	other	f
405	50	7	Parmesan	g	20	cheese	f
406	51	1	chicken fillet	g	300	chicken	t
407	51	2	pear		1	fruits	f
408	51	3	spinach	g	100	greenery	f
409	51	4	dried cranberries	tbsp	2	dry food	f
410	51	5	walnuts	tbsp	2	dry food	f
411	51	6	olive oil	tbsp	2	sauces	f
412	51	7	apple cider vinegar	tbsp	2	sauces	f
413	51	8	honey	tbsp	2	sauces	f
414	51	9	Dijon mustard	tbsp	0.5	sauces	f
415	51	10	Salt	tsp	0.3	seasoning	f
416	51	11	Pepper	tsp	0.3	seasoning	f
417	51	12	Paprika	tsp	0.5	seasoning	f
418	51	13	Vegetable oil	tbsp	1	sauces	f
429	54	1	osso buco	g	700	meat	t
419	52	1	radishes	g	200	vegetables	t
420	52	2	green onions	g	50	vegetables	f
421	52	3	sour cream	g	120	dairy	f
422	52	4	salt	tsp	0.3	seasoning	f
423	53	1	eggs		4	eggs	t
424	53	2	onion		1	vegetables	f
425	53	3	Salt	tsp	0.3	seasoning	f
426	53	4	Pepper	tsp	0.3	seasoning	f
427	53	5	Aromatic oil	tbsp	1	sauces	f
428	53	6	Vegetable oil	tbsp	1	sauces	f
368	45	1	Cherry tomatoes	g	200	tomato	f
369	45	2	Shrimp	g	180	seafood	t
370	45	3	Cheese	g	200	cheese	t
371	45	4	Garlic clove		1	vegetables	f
372	45	5	Mayonnaise	g	60	sauces	f
373	45	6	dill sprigs		2	cereal	f
374	45	7	Salt	tsp	0.2	seasoning	f
375	45	8	Pepper	tsp	0.2	seasoning	f
430	54	2	onion		1	vegetables	f
431	54	3	carrots		2	vegetables	f
432	54	4	celery stalks		2	vegetables	f
433	54	5	garlic cloves		2	vegetables	f
434	54	6	mushrooms	g	200	mushrooms	f
435	54	7	rice	cup	0.75	rice	t
436	54	8	tomato paste	tbsp	1	sauces	f
437	54	9	dry red wine	ml	250	other	f
438	54	10	chicken broth	ml	580	other	f
439	54	11	thyme sprigs		3	greenery	f
440	54	12	sage sprigs		2	greenery	f
441	54	13	parsley sprigs		6	greenery	f
442	54	14	Salt	tsp	1	seasoning	f
443	54	15	Pepper	tsp	1	seasoning	f
444	54	16	Vegetable oil	tbsp	1	sauces	f
445	54	17	butter	g	40	dairy	f
244	28	7	balsamic vinegar	tbsp	2	sauces	f
245	28	8	olive oil	tbsp	3	sauces	f
338	39	7	Paprika	tsp	0.5	seasoning	f
458	56	1	milk	ml	250	dairy	f
446	55	1	turkey	g	550	turkey	t
447	55	2	onion		1	vegetables	f
448	55	3	carrots		2	vegetables	f
449	55	4	garlic cloves		5	vegetables	f
450	55	5	canned chickpeas	g	400	canned beans	f
451	55	6	canned diced tomatoes	g	400	canned goods	f
452	55	7	chicken broth	cup	2	other	f
453	55	8	parsley sprigs		4	greenery	f
454	55	9	smoked paprika	tsp	1	seasoning	f
455	55	10	salt	tsp	0.5	seasoning	f
456	55	11	pepper	tsp	0.5	seasoning	f
457	55	12	olive oil	tbsp	2	sauces	f
459	56	2	flour	g	600	cereal	f
533	108	8	lime		1	fruits	f
534	108	9	coconut milk	ml	200	canned goods	f
133	14	2	eggs		2	eggs	f
135	14	4	mayonnaise	g	90	sauces	f
535	108	10	chicken broth	ml	350	other	f
536	108	11	oyster sauce	tbsp	1	sauces	f
537	108	12	hot sauce	tbsp	0.5	sauces	f
538	108	13	sugar	tbsp	1	sweets	f
539	108	14	butter	g	25	dairy	f
511	107	1	rice paper	g	300	other	f
512	107	2	glass noodles	g	100	pasta	f
513	107	3	bell pepper		1	vegetables	t
514	107	4	cucumbers		2	vegetables	f
515	107	5	carrots		3	carrot	f
516	107	6	surimi	g	200	seafood	f
517	107	7	cilantro sprigs		16	greenery	f
518	107	8	vegetable oil	tbsp	2	sauces	f
1339	436	1	salmon fillet	g	700	fish	t
1340	436	2	raspberries	cup	0.5	fruits	f
1341	436	3	strawberries	cup	0.5	fruits	f
1342	436	4	blackberries	cup	0.5	fruits	f
1343	436	5	blueberries	cup	0.5	fruits	f
1344	436	6	brown sugar	tbsp	1	sweets	f
1345	436	7	balsamic vinegar	tbsp	1	sauces	f
1346	436	8	dry red wine	cup	0.5	other	f
1347	436	9	thyme sprigs		8	greenery	f
1348	436	10	lemon		1	fruits	f
1349	436	11	Salt 	tsp	0.3	seasoning	f
1350	436	12	pepper	tsp	0.3	seasoning	f
1351	436	13	Olive oil	tbsp	2	sauces	f
1269	430	1	white rice	cup	1	rice	t
1270	430	2	Salt	tsp	0.5	seasoning	f
1403	441	2	mushrooms	g	400	mushrooms	f
519	107	9	garlic cloves		10	vegetables	f
520	107	10	peanuts	g	70	dry food	f
521	107	11	soy sauce	cup	0.5	sauces	f
522	107	12	sesame oil	cup	0.25	sauces	f
523	107	13	hot sauce	tbsp	1	sauces	f
1404	441	3	fettuccine pasta	g	400	pasta	t
1405	441	4	onion		1	vegetables	f
1406	441	5	garlic cloves		2	vegetables	f
1407	441	6	mascarpone cheese	g	220	cheese	f
1408	441	7	dry Marsala wine	cup	1	other	f
1409	441	8	Dijon mustard	tbsp	1	sauces	f
549	110	1	pork	g	400	meat	t
466	56	9	ground cinnamon	tsp	2	baking supplies	f
467	58	1	cherry tomatoes	g	300	tomato	t
524	107	14	rice vinegar	tbsp	0.5	sauces	f
525	107	15	sugar	tbsp	5	sweets	f
540	109	1	avocado		1	vegetables	t
541	109	2	tomatoes		2	vegetables	f
542	109	3	cucumbers		2	vegetables	f
543	109	4	red onion		1	vegetables	f
544	109	5	lemon		1	fruits	f
545	109	6	olive oil	tbsp	2	sauces	f
546	109	7	Salt	tsp	0.3	seasoning	f
547	109	8	Pepper	tsp	0.3	seasoning	f
548	109	9	cilantro sprigs		5	greenery	f
550	110	2	brown mushrooms	g	100	mushrooms	f
551	110	3	onion		1	vegetables	f
552	110	4	apples		2	fruits	f
468	58	2	canned white beans	g	200	canned beans	t
469	58	3	parsley sprigs		5	greenery	f
470	58	4	olive oil	tbsp	2	sauces	f
471	58	5	lemon		0.5	fruits	f
553	110	5	flour	tbsp	2	cereal	f
526	108	1	shrimp	g	350	seafood	t
527	108	2	cherry tomatoes		10	tomato	f
528	108	3	ginger	g	6	vegetables	f
529	108	4	garlic cloves		2	vegetables	f
530	108	5	lemongrass stalks		2	greenery	f
531	108	6	green onion stalks		3	greenery	f
532	108	7	cilantro sprigs		4	greenery	f
1410	441	9	butter	g	70	dairy	f
1411	441	10	parsley sprigs		4	greenery	f
1412	441	11	salt	tsp	0.5	seasoning	f
1413	441	12	pepper	tsp	0.5	seasoning	f
1459	446	1	canned sardines 	g	200	canned fish	t
1460	446	2	sun-dried tomatoes		6	canned goods	f
1461	446	3	natural yogurt	tbsp	1	dairy	f
1462	446	4	salt	tsp	0.3	seasoning	f
1463	446	5	pepper	tsp	0.3	seasoning	f
1464	446	6	Bread	g	300	other	f
1465	446	7	dried berries	tbsp	1	dry food	f
1204	424	3	leek stalk		0.5	vegetables	f
1205	424	4	red onion		1	vegetables	f
460	56	3	fresh yeast	g	25	baking supplies	f
461	56	4	eggs		2	eggs	f
462	56	5	butter	g	80	dairy	f
463	56	6	vegetable oil		1	sauces	f
464	56	7	salt	tsp	0.3	seasoning	f
465	56	8	sugar	tsp	8	sweets	t
472	58	6	salt	tsp	0.3	seasoning	f
473	58	7	pepper	tsp	0.3	seasoning	f
554	110	6	apple cider	g	100	other	f
555	110	7	chicken broth	ml	500	other	f
556	110	8	Salt	tsp	0.5	seasoning	f
557	110	9	pepper	tsp	0.5	seasoning	f
558	110	10	vegetable oil	tbsp	2	sauces	f
1206	424	5	bell pepper		0.5	vegetables	f
1207	424	6	soba 	g	200	pasta	f
1208	424	7	soy sauce	tbsp	3	sauces	f
1209	424	8	sesame seeds	tbsp	2	baking supplies	f
1210	424	9	Vegetable oil	tbsp	2	sauces	f
580	112	1	egg		4	eggs	f
581	112	2	butter	g	150	dairy	f
582	112	3	milk	ml	70	dairy	f
583	112	4	sugar	cup	1	sweets	t
584	112	5	powdered sugar	g	125	baking supplies	f
585	112	6	dark chocolate	g	70	sweets	f
586	112	7	prunes	g	50	dry food	f
587	112	8	walnuts	g	50	dry food	f
588	112	9	vegetable oil	tbsp	1	sauces	f
610	123	1	chicken fillet	g	500	chicken	f
611	123	2	jasmine rice	cup	1	rice	f
612	123	3	pineapple		1	fruits	f
613	123	4	ginger	g	6	vegetables	f
614	123	5	garlic cloves		2	vegetables	f
615	123	6	chili pepper		1	vegetables	f
616	123	7	cashews	g	50	dry food	f
617	123	8	soy sauce	tbsp	4	sauces	f
618	123	9	Lemon juice	tbsp	2	sauces	f
619	123	10	turmeric	tsp	1	seasoning	f
620	123	11	brown sugar	tsp	1	sweets	f
1419	442	6	parsley sprigs		5	greenery	f
1420	442	7	peanuts	tbsp	4	dry food	f
600	115	1	Cheese	g	120	cheese	f
601	115	2	Cucumber		1	vegetables	f
602	115	3	Ham	g	80	deli meats	t
603	115	4	Olives	g	60	canned goods	f
1421	442	8	chili pepper		1	vegetables	f
1422	442	9	ginger	g	6	vegetables	f
1423	442	10	garlic cloves		2	vegetables	f
1424	442	11	rice vinegar	tbsp	2	sauces	f
1425	442	12	lemon juice	tbsp	1	sauces	f
1426	442	13	soy sauce	tbsp	4	sauces	f
1427	442	14	honey	tbsp	1	sauces	f
1428	442	15	Sesame seeds	tbsp	2	baking supplies	f
589	113	1	bacon slices		4	deli meats	t
590	113	2	cherry tomatoes	g	150	tomato	f
591	113	3	Frisée lettuce	g	100	greenery	f
592	113	4	pine nuts	tbsp	1	dry food	f
593	113	5	olive oil	tbsp	3	sauces	f
594	113	6	lemon juice	tbsp	1	sauces	f
595	113	7	Salt		0.3	seasoning	f
596	113	8	Pepper		0.3	seasoning	f
1466	447	1	zucchini		1	vegetables	t
1467	447	2	bell pepper		1	vegetables	f
1468	447	3	red onion		1	vegetables	f
1469	447	4	eggplant		1	vegetables	f
1352	437	1	cucumbers		5	vegetables	t
597	114	1	Shrimp	g	240	seafood	t
598	114	2	Pineapple		1	fruits	f
599	114	3	Vegetable oil	tbsp	1	sauces	f
1353	437	2	garlic cloves		3	vegetables	f
1354	437	3	chili pepper		1	vegetables	f
1355	437	4	sesame oil	tbsp	1	sauces	f
1211	425	1	sweet potatoes		2	potato	t
1212	425	2	bananas		2	fruits	f
1213	425	3	pecans	g	100	dry food	f
1214	425	4	honey	tbsp	1	sauces	f
1215	425	5	flour	tbsp	2	cereal	f
1216	425	6	brown sugar	tbsp	3	sweets	f
1217	425	7	butter	g	120	dairy	f
1218	425	8	salt	tsp	0.3	seasoning	f
1219	425	9	pepper	tsp	0.3	seasoning	f
1356	437	5	rice vinegar	tbsp	2	sauces	f
1357	437	6	soy sauce	tbsp	2	sauces	f
1358	437	7	cilantro sprigs		6	greenery	f
1414	442	1	napa cabbage		0.5	vegetables	t
1415	442	2	cucumber		1	vegetables	f
1416	442	3	carrot		1	vegetables	f
1417	442	4	bell pepper		0.5	vegetables	f
1418	442	5	cilantro sprigs		5	greenery	f
1470	447	5	olive oil	tbsp	2	sauces	f
1471	447	6	balsamic vinegar	tbsp	2	sauces	f
1472	447	7	salt	tsp	0.5	seasoning	f
1473	447	8	pepper	tsp	0.5	seasoning	f
1271	431	1	potatoes	kg	1	potato	t
1272	431	2	butter	g	100	dairy	f
1273	431	3	milk	ml	200	dairy	f
1274	431	4	Green onion stalks		3	greenery	f
1275	431	5	salt	tsp	0.5	seasoning	f
1276	431	6	pepper	tsp	0.5	seasoning	f
1284	432	8	olive oil	tbsp	5	sauces	f
1285	432	9	balsamic vinegar	tbsp	2	sauces	f
1286	432	10	raspberry jam	tbsp	2	sweets	f
1287	432	11	sugar	tbsp	2	sweets	f
1288	432	12	salt	tsp	0.5	seasoning	f
1289	432	13	pepper	tsp	0.5	seasoning	f
1359	438	1	chicken broth	l	1.5	other	f
1360	438	2	onion		1	vegetables	f
1361	438	3	carrots		3	carrot	f
1362	438	4	celery stalk		1	vegetables	f
1363	438	5	garlic cloves		4	vegetables	f
1364	438	6	spinach	g	100	greenery	f
1365	438	7	chicken fillet	g	400	chicken	t
1366	438	8	milk	tbsp	2	dairy	f
1164	420	1	strawberries	g	200	fruits	t
1165	420	2	arugula	g	80	greenery	f
1166	420	3	mozzarella ball		1	cheese	f
1167	420	4	walnuts	g	40	dry food	f
1168	420	5	lemon		1	fruits	f
1169	420	6	olive oil	tbsp	1	sauces	f
1170	420	7	honey	tbsp	0.5	sauces	f
743	376	1	cucumbers		2	vegetables	f
744	376	2	radishes		5	vegetables	f
745	376	3	green onion stalks		3	\N	f
746	376	4	dill sprigs		3	\N	f
747	376	5	lettuce leaves	g	100	\N	f
748	376	6	sour cream	cup	1	\N	f
749	376	7	Salt	tsp	0.3	\N	f
750	376	8	pepper	tsp	0.3	\N	f
1429	443	1	turkey fillet	g	400	turkey	t
1430	443	2	mandarins		5	fruits	f
1431	443	3	ginger	g	6	vegetables	f
1432	443	4	chili pepper		1	vegetables	f
1433	443	5	soy sauce	tbsp	3	sauces	f
1434	443	6	honey	tbsp	1	sauces	f
1435	443	7	flour	tbsp	1	cereal	f
1436	443	8	butter	g	20	dairy	f
1437	443	9	olive oil	tbsp	1	sauces	f
1438	443	10	salt	tsp	0.3	seasoning	f
1439	443	11	pepper	tsp	0.3	seasoning	f
1202	424	1	pork tenderloin	g	400	meat	t
1203	424	2	mushrooms	g	200	mushrooms	f
1277	432	1	chicken liver	g	100	liver	t
1278	432	2	arugula	g	100	greenery	f
1279	432	3	apple		1	fruits	f
1280	432	4	red onion		1	vegetables	f
1281	432	5	cherry tomatoes		8	vegetables	f
1282	432	6	pine nuts	tbsp	1	dry food	f
1283	432	7	butter	g	30	dairy	f
1367	438	9	breadcrumbs	tbsp	1	other	f
1368	438	10	oregano	tsp	0.5	seasoning	f
1369	438	11	salt	tsp	0.5	seasoning	f
1370	438	12	pepper	tsp	0.5	seasoning	f
1371	438	13	chili	tsp	0.25	seasoning	f
1372	438	14	Olive oil	tbsp	2	sauces	f
1220	426	1	beef on the bone	g	500	meat	t
1221	426	2	chicken leg quarter		1	chicken	f
1222	426	3	carrot		1	carrot	f
1223	426	4	onion		1	vegetables	f
1224	426	5	Parsley root		1	vegetables	f
1225	426	6	celery root		1	vegetables	f
1226	426	7	Herb stems		10	greenery	f
1227	426	8	Salt		0.5	seasoning	f
1228	426	9	Black peppercorns		8	seasoning	f
1229	426	10	Allspice peppercorns		5	seasoning	f
1230	426	11	Bay leaf		1	seasoning	f
1231	426	12	gelatin	g	20	baking supplies	f
1232	426	13	parsley sprigs		3	greenery	f
1233	426	14	frozen green peas	tbsp	1	other	f
1171	421	1	cucumbers		2	vegetables	t
1172	421	2	radishes		8	vegetables	f
1173	421	3	salad greens	g	150	greenery	f
1174	421	4	feta cheese	g	100	cheese	f
1175	421	5	Pumpkin seeds	tbsp	2	dry food	f
1176	421	6	lemon		0.5	fruits	f
1177	421	7	Olive oil	tbsp	2	sauces	f
1178	421	8	salt	tsp	0.3	seasoning	f
1179	421	9	pepper	tsp	0.3	seasoning	f
1180	421	10	sugar	tsp	0.2	sweets	f
1234	427	1	large mushrooms		8	mushrooms	t
1235	427	2	chicken fillet	g	250	chicken	t
1236	427	3	onion		1	vegetables	f
1237	427	4	flour	tbsp	1	cereal	f
1238	427	5	sour cream	tbsp	2	dairy	f
1239	427	6	cheese	g	50	cheese	f
1240	427	7	nutmeg 	tsp	0.5	seasoning	f
1241	427	8	salt	tsp	0.3	seasoning	f
1242	427	9	pepper	tsp	0.3	seasoning	f
1243	427	10	Butter 	g	30	dairy	f
1244	427	11	vegetable oil	tbsp	1	sauces	f
1440	444	1	chicken fillet	g	500	chicken	t
1441	444	2	bell peppers		2	vegetables	f
1442	444	3	carrots		2	carrot	f
1443	444	4	cucumber		1	vegetables	f
1444	444	5	glass noodles	g	150	pasta	f
1445	444	6	sesame oil	tbsp	4	sauces	f
1446	444	7	soy sauce	tbsp	4	sauces	f
1447	444	8	brown sugar	tbsp	4	sweets	f
1448	444	9	sesame seeds	tbsp	2	baking supplies	f
1290	433	1	bell pepper		1	vegetables	t
1291	433	2	red onion		1	vegetables	f
1292	433	3	chili pepper		1	vegetables	f
1293	433	4	garlic cloves		3	vegetables	f
1294	433	5	canned tomatoes	g	200	canned goods	f
1295	433	6	chicken broth	ml	500	other	f
1296	433	7	canned red beans	g	200	canned beans	f
1297	433	8	paprika	tbsp	2	seasoning	f
1298	433	9	chili 	tbsp	0.5	seasoning	f
1299	433	10	coriander	tsp	1	seasoning	f
1300	433	11	Olive oil	tbsp	2	sauces	f
1301	433	12	parsley sprigs		3	greenery	f
1302	433	13	salt	tsp	0.3	seasoning	f
1303	433	14	pepper	tsp	0.3	seasoning	f
1304	433	15	Corn tortilla chips	g	100	other	f
1373	439	1	beef bones	g	500	meat	f
1374	439	2	beef	g	500	meat	t
819	383	1	chicken fillet	g	600	chicken	f
820	383	2	onions		2	vegetables	f
821	383	3	tomatoes	g	400	\N	f
822	383	4	garlic clove		1	\N	f
823	383	5	chili pepper		2	\N	f
824	383	6	Madras curry powder	tbsp	2	\N	f
825	383	7	garam masala	tsp	1	\N	f
826	383	8	turmeric	tsp	0.5	\N	f
827	383	9	ground chili	tsp	0.25	\N	f
828	383	10	Salt 	tsp	0.3	\N	f
829	383	11	Vegetable oil	tbsp	2	\N	f
1375	439	3	onions		2	vegetables	f
1376	439	4	carrots		2	carrot	f
1377	439	5	potatoes		3	potato	f
1378	439	6	beets		2	vegetables	f
1379	439	7	tomato		1	tomato	f
1380	439	8	cabbage	g	700	vegetables	f
1381	439	9	pork fat	g	100	deli meats	f
1382	439	10	garlic cloves		3	vegetables	f
1383	439	11	dill sprigs 		3	greenery	f
1384	439	12	parsley sprigs 		3	greenery	f
1385	439	13	Black peppercorns		5	seasoning	f
1386	439	14	Allspice peppercorns		8	seasoning	f
1387	439	15	Bay leaf		1	seasoning	f
1388	439	16	Salt	tsp	0.7	seasoning	f
1389	439	17	sugar	tbsp	1	sweets	f
1390	439	18	lemon juice	tbsp	1	sauces	f
1391	439	19	flour	tbsp	1	cereal	f
944	396	1	dried small chickpeas	cup	1	\N	\N
945	396	2	concentrated tahini paste	ml	100	\N	\N
946	396	3	onion		1	\N	\N
947	396	4	garlic cloves		4	\N	\N
948	396	5	lemon juice	tbsp	3	\N	\N
949	396	6	baking soda	tsp	1	\N	\N
950	396	7	salt	tsp	0.5	\N	\N
951	396	8	Olive oil	tbsp	1	\N	\N
952	396	9	fresh herbs leaves		6	\N	\N
1449	445	1	chicken liver	g	300	liver	t
1450	445	2	pumpkin	g	250	vegetables	f
1007	402	1	chicken liver	g	400	\N	\N
1008	402	2	mushrooms	g	200	\N	\N
1009	402	3	onion		1	\N	\N
1010	402	4	carrot		1	\N	\N
1011	402	5	garlic cloves		2	\N	\N
1012	402	6	butter	g	100	\N	\N
1013	402	7	sour cream	tbsp	2	\N	\N
1014	402	8	cognac	tbsp	3	\N	\N
1015	402	9	nutmeg	tsp	0.5	\N	\N
1016	402	10	Salt 	tsp	0.5	\N	\N
1017	402	11	pepper 	tsp	0.5	\N	\N
1451	445	3	apples		2	fruits	f
1452	445	4	onion		1	vegetables	f
1453	445	5	cinnamon stick		1	seasoning	f
1454	445	6	dry white wine	ml	50	other	f
1455	445	7	Vegetable oil 	tbsp	2	sauces	f
1456	445	8	parsley sprigs		3	greenery	f
1457	445	9	salt	tsp	0.3	seasoning	f
1458	445	10	pepper	tsp	0.3	seasoning	f
1181	422	1	herring fillet	g	150	fish	t
1182	422	2	beetroot		1	vegetables	f
1183	422	3	walnuts	tbsp	2	dry food	f
1184	422	4	garlic cloves		2	vegetables	f
1185	422	5	mayonnaise	tbsp	2	sauces	f
1186	422	6	Black bread	g	300	other	f
1187	422	7	parsley sprigs		3	greenery	f
1188	422	8	salt	tsp	0.3	seasoning	f
1189	422	9	pepper	tsp	0.3	seasoning	f
1305	434	1	pumpkin	g	500	vegetables	t
1306	434	2	carrot		1	carrot	f
1307	434	3	leek stalk		1	vegetables	f
1308	434	4	garlic cloves		2	vegetables	f
1309	434	5	ginger	g	6	vegetables	f
1310	434	6	chicken broth	l	1	other	f
1311	434	7	curry powder	tbsp	1	seasoning	f
1312	434	8	honey	tbsp	2	sauces	f
1313	434	9	Olive oil	tbsp	2	sauces	f
1314	434	10	salt	tsp	0.3	seasoning	f
1315	434	11	pepper	tsp	0.3	seasoning	f
1316	434	12	Pumpkin seeds	tbsp	2	dry food	f
1317	434	13	Natural yogurt	g	100	dairy	f
1392	440	1	pickled beets	g	500	canned goods	f
1393	440	2	eggs		5	eggs	f
1394	440	3	cucumbers		2	vegetables	t
1395	440	4	green onion stalks		6	greenery	f
1396	440	5	dill sprigs		6	greenery	f
1397	440	6	kefir	l	1.5	dairy	f
1398	440	7	potatoes		8	potato	t
1399	440	8	salt	tsp	0.3	seasoning	f
1400	440	9	pepper	tsp	0.3	seasoning	f
1401	440	10	butter	g	20	dairy	f
1245	428	1	tomatoes		4	tomato	t
1246	428	2	bell pepper		1	vegetables	f
1247	428	3	onion		1	vegetables	f
1053	406	5	prunes		10	dry food	f
1055	406	7	parsley root		1	vegetables	f
1056	406	8	Vegetable oil	tbsp	1	sauces	f
1057	406	9	salt	tsp	0.5	seasoning	f
1058	406	10	pepper	tsp	0.5	seasoning	f
1248	428	4	garlic cloves		4	vegetables	f
1049	406	1	lamb with bone	g	600	meat	t
1050	406	2	potatoes		6	potato	f
1249	428	5	chili pepper		1	vegetables	f
1250	428	6	tomato paste	tbsp	2	sauces	f
1251	428	7	cumin	tsp	2	seasoning	f
1252	428	8	paprika	tsp	2	seasoning	f
1253	428	9	sugar	tsp	2	sweets	f
1254	428	10	salt	tsp	1	seasoning	f
1255	428	11	cilantro sprigs		8	greenery	f
1256	428	12	lemon juice	tbsp	1	sauces	f
1257	428	13	vinegar	tbsp	2	sauces	f
1069	408	4	bell pepper		0.5	\N	f
1070	408	5	red onion		0.5	\N	f
1071	408	6	chili pepper		1	\N	f
1072	408	7	pomegranate		0.25	\N	f
1258	428	14	Vegetable oil	tbsp	2	sauces	f
1067	408	2	tomato		1	\N	f
1318	435	1	small zucchinis		15	vegetables	f
1319	435	2	ground beef	g	200	meat	t
1320	435	3	rice	g	150	rice	t
1321	435	4	onion		0.5	vegetables	f
1322	435	5	garlic cloves		3	vegetables	f
1323	435	6	canned diced tomatoes	g	600	canned goods	f
1324	435	7	beef or chicken broth	cup	1	other	f
1325	435	8	pomegranate syrup	tbsp	1	sauces	f
1326	435	9	olive oil	tbsp	1	sauces	f
1327	435	10	cumin	tsp	0.5	seasoning	f
1092	410	1	onion		1	\N	\N
1093	410	2	carrots		2	\N	\N
1094	410	3	red bell pepper		1	\N	\N
1095	410	4	zucchini		1	\N	\N
1096	410	5	tomatoes		2	\N	\N
1097	410	6	potato		1	\N	\N
1098	410	7	garlic cloves		2	\N	\N
1099	410	8	olive oil	tbsp	4	\N	\N
1100	410	9	crushed tomatoes	g	200	\N	\N
1101	410	10	small pasta	cup	0.5	\N	\N
1102	410	11	Salt	tsp	0.5	\N	\N
1103	410	12	pepper 	tsp	0.5	\N	\N
1104	410	13	basil sprigs		2	\N	\N
1105	410	14	Parmesan cheese	g	30	\N	\N
1328	435	11	nutmeg	tsp	0.5	seasoning	f
1329	435	12	dried chilies		2	seasoning	f
1330	435	13	cloves		4	seasoning	f
1331	435	14	dried mint	tbsp	1	seasoning	f
1332	435	15	bay leaf		1	seasoning	f
1333	435	16	sugar	tbsp	1	sweets	f
1114	412	1	peaches		2	fruits	f
1115	412	2	mozzarella ball		1	dairy	f
1116	412	3	celery stalk		1	vegetables	f
1117	412	4	Swiss chard	g	100	greenery	f
1118	412	5	olive oil	tbsp	3	sauces	f
1119	412	6	lemon juice	tbsp	1	sauces	f
1120	412	7	honey	tbsp	0.5	sauces	f
1121	412	8	mustard	tbsp	0.5	sauces	f
1131	414	1	white fish fillets 	g	400	\N	\N
1132	414	2	anned tomatoes	g	400	\N	\N
1133	414	3	onions		2	\N	\N
1134	414	4	carrot		1	\N	\N
1135	414	5	frozen peas	cup	0.5	\N	\N
1136	414	6	flour	tbsp	4	\N	\N
1137	414	7	sugar	tsp	2	\N	\N
1138	414	8	oregano	tsp	0.5	\N	\N
1139	414	9	basil	tsp	0.5	\N	\N
1140	414	10	salt	tsp	0.5	\N	\N
1141	414	11	pepper	tsp	0.5	\N	\N
1142	414	12	Vegetable oil	tbsp	2	\N	\N
1143	414	13	parsley sprigs		3	\N	\N
1145	415	2	avocado		1	vegetables	f
1149	415	6	Vegetable oil	tbsp	1	sauces	f
1150	415	7	cream cheese	tbsp	1	cheese	f
1334	435	17	Salt 	tsp	0.3	seasoning	f
1335	435	18	pepper	tsp	0.3	seasoning	f
1336	435	19	cilantro sprigs 		2	greenery	f
1337	435	20	dill sprigs 		2	greenery	f
1338	435	21	parsley sprigs 		2	greenery	f
1402	441	1	chicken fillet	g	600	chicken	t
1190	423	1	beef	g	600	meat	t
1191	423	2	red beans	cup	1	beans	f
1051	406	3	onion		2	vegetables	f
1052	406	4	garlic cloves		4	vegetables	f
1054	406	6	cilantro sprigs		6	greenery	f
1066	408	1	green lentils	g	100	\N	f
1068	408	3	cucumber		1	\N	f
1073	408	8	feta cheese	g	100	\N	f
1074	408	9	garlic cloves		2	\N	f
1075	408	10	parsley sprigs 		6	\N	f
1076	408	11	mint sprigs 		6	\N	f
1077	408	12	olive oil	tbsp	4	\N	f
1078	408	13	wine vinegar	tbsp	2	\N	f
1079	408	14	honey	tsp	1	\N	f
1080	408	15	Salt 	tsp	0.5	\N	f
1081	408	16	pepper	tsp	0.5	\N	f
1192	423	3	onion		1	vegetables	f
1193	423	4	celery stalk		1	vegetables	f
1194	423	5	garlic cloves		2	vegetables	f
1195	423	6	dark beer	ml	500	other	f
1196	423	7	flour	tbsp	2	cereal	f
1197	423	8	bay leaves		2	seasoning	f
1198	423	9	paprika	tsp	1	seasoning	f
1199	423	10	coriander	tsp	1	seasoning	f
1200	423	11	salt	tsp	0.5	seasoning	f
1201	423	12	pepper	tsp	0.5	seasoning	f
1259	429	1	cherry tomatoes	g	150	tomato	t
1260	429	2	ricotta cheese	g	250	dairy	t
1261	429	3	olive oil	tbsp	2	sauces	f
1262	429	4	balsamic vinegar	tbsp	1	sauces	f
1263	429	5	honey	tbsp	1	sauces	f
1264	429	6	garlic clove		1	vegetables	f
1265	429	7	basil leaves		8	seasoning	f
1266	429	8	baguette		0.5	other	f
1267	429	9	salt	tsp	0.3	seasoning	f
1268	429	10	pepper	tsp	0.3	seasoning	f
1144	415	1	sprats	g	200	canned fish	t
1146	415	3	garlic clove		1	vegetables	f
1147	415	4	Pickled cucumbers		2	canned goods	f
1148	415	5	Rye bread	g	300	other	f
\.


--
-- Data for Name: menus; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.menus (id, user_id, title, dishes, dinner_category, dinner_time, cooking_time, saved, removed) FROM stdin;
2	5	Try on weekend	51, 12, 11, 17	family	tomorrow	2	2024-05-27 18:55:59.137652	\N
3	5	Birthday party menu	39, 42, 38, 1, 51, 3, 32, 48, 43, 8, 5	festive	later	4	2024-05-27 18:56:25.75246	\N
4	5	Simple romantic	47, 39, 42, 49, 46, 37	romantic	today	2	2024-05-27 18:56:45.102827	2024-05-27 19:22:00.216406
1	5	Chicken&rice	1, 4	weeknight	now	1	2024-05-27 18:55:27.848935	2024-05-27 19:47:40.503656
5	4	Spanish style dinner	3, 23, 55	family	today	2	2024-05-28 02:12:17.6206	\N
6	5	Fish dinner	3, 29, 26	weeknight	today	1	2024-05-28 02:29:33.705665	\N
7	4	for weekend	22, 35, 23, 29, 26	family	today	3	2024-05-28 02:42:09.648968	\N
8	4	Asian style for guests	21, 3, 25, 43, 11, 26, 37	guest	tomorrow	3	2024-05-28 02:43:11.329492	\N
9	2	Chiken with apples	21, 19, 27	weeknight	now	1	2024-05-28 18:27:36.633963	2024-05-30 09:58:02.051519
10	2	Chicken&Beens	3, 6, 43, 9, 17, 31	guest	tomorrow	3	2024-05-30 09:59:24.416861	\N
13	2	for next party	41, 49, 15, 38, 6, 1, 3, 43, 48, 19, 50, 37	festive	later	4	2024-05-30 16:16:38.840314	\N
12	2	quick pasta	23, 2	weeknight	now	1	2024-05-30 16:12:00.193029	2024-05-30 16:30:19.935481
11	2	3-appetizer dinner	49, 47, 39, 44, 29, 26, 37	romantic	later	3	2024-05-30 13:10:39.677261	2024-05-30 16:30:22.396567
14	2	Fish milanese	21, 29, 27	weeknight	now	1	2024-06-02 15:02:18.396871	\N
15	2	Pasta dinner	1, 23, 2	family	today	2	2024-06-02 15:03:19.098435	2024-06-04 17:01:25.478973
16	2	Next dinner whith pasta	51, 43, 23, 2	family	tomorrow	3	2024-06-04 17:02:53.733963	2024-06-17 16:13:45.036764
18	2	Pork chops dinner	109, 12, 20, 18	family	today	2	2024-06-17 16:31:53.286884	\N
17	2	romantic with trifle	40, 15, 38, 42, 44, 33, 2, 36	romantic	later	4	2024-06-17 16:12:21.569147	2024-06-17 16:32:29.198625
19	1	Garlic chiken	21, 12, 10, 18	family	today	2	2024-06-18 17:42:22.335145	\N
20	1	romantic with shrimps	15, 42, 45, 44, 33, 37	romantic	tomorrow	3	2024-06-18 20:04:51.308266	\N
21	1	Party dinner with cake	114, 43, 42, 115, 113, 3, 51, 34, 19, 50, 112	festive	later	4	2024-06-18 20:06:30.598688	\N
22	1	cook tomorrow	22, 4	weeknight	today	1	2024-06-18 20:07:29.830943	\N
23	2	Tai dinner	1, 108, 123	family	today	2	2024-06-18 21:57:26.447443	\N
24	1	for next week	129, 109, 51, 25, 19, 375, 37	guest	tomorrow	3	2024-06-19 01:47:11.843887	\N
\.


--
-- Data for Name: moderation; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.moderation (id, dish_id, moderator_id, published) FROM stdin;
1	6	2	2024-05-07 18:36:07.196119
2	4	8	2024-05-08 01:12:40.207272
3	12	8	2024-05-08 01:17:02.140353
4	2	2	2024-05-08 14:51:00.788405
5	11	2	2024-05-08 15:15:52.735346
6	8	2	2024-05-09 14:40:59.580676
7	18	2	2024-05-09 15:07:34.292364
8	13	2	2024-05-09 15:48:13.535175
9	1	8	2024-05-09 15:59:31.416847
10	10	8	2024-05-09 16:05:23.219488
11	9	8	2024-05-09 16:19:58.213138
12	3	8	2024-05-09 16:25:39.932832
13	17	2	2024-05-09 16:32:04.822682
14	19	2	2024-05-09 18:08:26.282776
15	20	2	2024-05-09 18:10:54.711875
16	21	2	2024-05-09 21:37:54.226648
17	23	2	2024-05-09 21:43:24.579918
18	24	8	2024-05-11 13:22:59.243254
19	22	8	2024-05-11 13:25:13.431657
20	25	8	2024-05-11 13:36:55.068018
21	26	2	2024-05-12 19:52:52.390395
22	27	2	2024-05-12 19:55:08.219588
23	28	2	2024-05-13 00:46:10.807582
24	29	2	2024-05-13 00:47:51.651446
25	30	2	2024-05-14 21:31:09.314251
26	31	2	2024-05-14 21:33:23.367698
27	32	2	2024-05-14 23:01:01.984337
28	34	8	2024-05-15 00:10:40.351127
29	33	8	2024-05-15 00:12:08.439331
30	35	8	2024-05-15 00:13:33.224453
31	5	2	2024-05-16 19:08:15.875134
32	36	2	2024-05-16 19:11:37.180292
33	37	2	2024-05-16 19:13:21.138565
34	40	8	2024-05-16 22:09:54.21081
35	48	8	2024-05-16 22:11:41.269453
36	47	8	2024-05-16 22:15:30.675465
37	38	8	2024-05-16 22:18:48.329047
38	43	2	2024-05-16 23:24:32.79339
39	44	2	2024-05-16 23:26:42.134095
40	46	2	2024-05-16 23:27:57.591122
41	49	2	2024-05-16 23:31:01.620826
42	15	2	2024-05-16 23:32:21.393032
43	39	2	2024-05-16 23:41:29.926059
44	42	2	2024-05-16 23:42:43.175531
45	50	8	2024-05-17 01:31:11.621876
46	51	8	2024-05-17 01:33:39.452879
47	54	8	2024-05-17 01:37:19.968765
48	52	8	2024-05-17 01:39:59.35201
49	53	8	2024-05-17 01:41:39.395581
50	45	2	2024-05-21 16:08:53.252076
51	41	2	2024-05-26 17:37:09.196933
52	55	8	2024-05-28 02:08:45.628228
53	14	2	2024-05-30 15:21:17.791342
54	112	8	2024-06-08 00:38:51.526487
55	114	2	2024-06-08 04:28:23.823665
56	108	8	2024-06-08 04:44:45.251228
57	107	8	2024-06-08 04:47:23.340835
58	109	2	2024-06-08 04:57:03.659368
59	115	2	2024-06-09 22:47:06.110658
60	113	2	2024-06-09 23:31:55.995173
61	56	2	2024-06-09 23:34:45.945574
62	58	2	2024-06-10 00:30:50.334723
63	110	2	2024-06-10 07:36:16.243807
67	123	2	2024-06-14 16:27:46.015187
106	406	2	2024-06-22 13:18:55.796467
114	420	2	2024-06-22 17:27:22.939969
115	421	8	2024-06-22 17:38:01.826131
116	425	2	2024-06-22 18:17:36.153902
117	445	508	2024-06-22 21:31:21.399685
118	422	508	2024-06-22 21:32:29.494133
119	427	508	2024-06-22 21:36:09.645228
120	437	508	2024-06-22 21:38:12.924708
121	436	2	2024-06-22 21:41:06.606762
122	442	2	2024-06-22 21:42:51.354711
123	430	2	2024-06-22 21:43:19.376664
124	435	2	2024-06-22 21:45:38.521776
125	434	2	2024-06-22 21:47:14.854544
126	447	2	2024-06-22 21:48:22.122038
127	441	8	2024-06-22 21:58:45.68305
128	440	8	2024-06-22 22:01:25.753659
129	431	8	2024-06-22 22:02:27.786731
130	423	8	2024-06-22 22:09:53.421762
131	443	8	2024-06-22 22:11:06.065093
132	428	8	2024-06-22 22:12:35.721982
133	446	8	2024-06-22 22:13:33.345633
134	424	8	2024-06-22 22:14:41.23614
135	429	8	2024-06-22 22:15:54.813805
136	432	8	2024-06-22 22:17:34.333919
137	444	8	2024-06-22 22:18:42.148804
138	438	8	2024-06-22 22:20:00.563113
139	433	8	2024-06-22 22:22:16.475327
140	426	8	2024-06-22 22:23:53.083152
141	439	8	2024-06-22 22:26:05.756466
142	415	8	2024-06-22 22:28:38.05441
\.


--
-- Data for Name: steps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.steps (id, dish_id, index, description) FROM stdin;
46	6	1	Boil the rice until done and cool.
47	6	2	Boil the eggs hard.
48	6	3	Drain the tuna and mash with a fork.
49	6	4	Chop the onion and eggs as finely as possible.
15	2	9	Place the fettuccine in a frying pan and stir. If necessary, add a little water in which the pasta was cooked.
16	2	10	Place the salmon fillet on top of the fettuccine and break it into portions.
17	2	11	When serving, sprinkle the pasta with salmon with chopped dill and parsley.
24	4	1	Place a deep frying pan on high heat. Heat one tablespoon of vegetable oil.
1	1	1	Mix olive oil, lemon juice, mustard, salt and pepper until smooth.
2	1	2	Place frisee salad in a salad bowl with your hands, pour in about a quarter of the dressing and mix with your hands.
3	1	3	Cut the tomatoes into large slices, the cheese into cubes, and the onion into feathers.
4	1	4	Separate the tuna into large flakes by hand.
5	1	5	Place all ingredients in a salad bowl.
42	5	6	Add the yolks to the milk and heat the entire mixture, then leave to cool. The milk should never boil.
43	5	7	Whip the cream with a mixer, add to the cooled milk and mix well.
44	5	8	Pour into bowls and refrigerate for at least 4 hours.
45	5	9	Before serving, garnish with grated chocolate or fresh berries.
6	1	6	Pour in the remaining dressing over the salad and sprinkle with pumpkin seeds.
18	3	1	Pour cold water over the quail eggs, bring to a boil and cook for 5 minutes.
19	3	2	Tear the frisee salad with your hands and place on a plate.
7	2	1	Preheat the oven to 180 degrees.
8	2	2	Salt and pepper the salmon and sprinkle with olive oil.
9	2	3	Bake the fish in the oven for 15 minutes. This time is enough to prepare the sauce.
10	2	4	Cut the garlic into petals and fry for one minute in olive oil.
11	2	5	Pour in half a glass of hot water, add tomato paste and thin slices of lemon zest.
12	2	6	When the water boils, add lemon juice, add green beans and cook for 5 minutes.
13	2	7	At the same time, cook the pasta al dente.
14	2	8	Add cream cheese to the pan and stir well.
25	4	2	Rub the chicken thighs with salt, pepper and paprika.
26	4	3	Place the chicken thighs in a frying pan, skin side down, fry for 3 minutes until golden brown and place on a plate.
27	4	4	Cut carrots and celery stalks into slices half a centimeter wide.
28	4	5	Cut the onion into large cubes.
29	4	6	Reduce the heat, add another spoonful of oil and fry the vegetables for 7-8 minutes until soft.
30	4	7	Finely chop the garlic and add to the frying pan.
31	4	8	Grate the lemon zest and add it to the pan.
32	4	9	Tear off the thyme leaves and add to the frying pan.
33	4	10	Stir and fry for one minute.
34	4	11	Place rice in a frying pan, add salt and pepper. Fry for 2 minutes, stirring until the grains of rice are coated with oil.
35	4	12	Return the chicken to the frying pan, add broth and a tablespoon of lemon juice, cover with a lid and simmer for 20 minutes.
36	4	13	When serving, sprinkle the dish with chopped green onions.
20	3	3	Chop the cod liver into medium pieces with a knife and place on frisee salad leaves in the middle of the plate.
21	3	4	Cut quail eggs and cherry tomatoes in half. We place them around the cod liver.
22	3	5	Salt and pepper the salad.
23	3	6	Season with olive oil and cod liver fat in equal proportions.
37	5	1	Soak the gelatin in a tablespoon of water until it swells.
38	5	2	Separate the yolks from the whites. Grind the yolks with sugar until they become almost white. Egg whites are not needed for this dish.
39	5	3	Pour milk into a saucepan, break chocolate into it.
40	5	4	Heat the milk until the chocolate is completely melted.
41	5	5	Heat the swollen gelatin until it becomes liquid and pour it into a saucepan with milk.
1337	445	1	Heat some vegetable oil in a skillet over medium-high heat.
1339	445	3	In another skillet, heat some vegetable oil over medium heat.
1340	445	4	Slice the onion into quarter rings and sauté until soft and translucent.
1200	432	1	In a jar, combine 3 tbsp olive oil, 1 tbsp balsamic vinegar, and 2 tbsp raspberry jam. Close the lid tightly and shake well.
1201	432	2	Mix three-quarters of the dressing with the arugula and place it in the center of a large plate.
1202	432	3	Peel and slice the apple into wedges.
1203	432	4	In a small saucepan, heat 1 tbsp olive oil, add the apple slices and 1 tbsp sugar.
1204	432	5	Cook until the sugar melts and the apples are caramelized. Place the caramelized apple slices on top of the arugula.
1205	432	6	Clean the chicken liver, removing any sinews and membranes.
1206	432	7	In a skillet, heat the butter until it sizzles. Add salt and pepper.
1207	432	8	Add the liver pieces and cook for 3 minutes on each side. Place the cooked liver on top of the arugula.
1208	432	9	Slice the red onion into thin wedges.
1209	432	10	In a saucepan, heat 1 tbsp olive oil and add the onion. Sauté for 1 minute over low heat.
1210	432	11	Add 1 tbsp sugar and 1 tbsp balsamic vinegar. Continue to cook, stirring frequently, until the onions are soft and caramelized.
1211	432	12	Distribute the caramelized onions around the liver on the plate.
1212	432	13	Cut the cherry tomatoes in half and add them to the salad.
1213	432	14	Toast the pine nuts in a dry skillet until golden brown. Sprinkle them over the salad.
1214	432	15	Drizzle the remaining dressing over the salad and serve immediately.
50	6	5	Combine tuna, eggs, onions and rice in a salad bowl.
51	6	6	Add salt, season with mayonnaise and mix.
108	12	1	Fill the salmon heads and tails with two liters of water, add salt, bay leaves and a whole onion.
109	12	2	Cook the broth for 15 minutes, periodically removing the foam.
110	12	3	At this time, cut the second onion and carrot into small cubes.
119	13	1	Melt a piece of butter in a pot.
112	12	5	Peel the potatoes, cut them into medium cubes, and add them to the vegetables.
113	12	6	Strain the fish broth into the pot and cook for 10 minutes.
114	12	7	Cut the salmon fillet into medium pieces.
115	12	8	Add salmon pieces to the soup and cook for 7 minutes.
116	12	9	Remove a third of the potatoes from the soup, mash with a fork and return to the pot.
117	12	10	Add the cream and heat everything together for about a minute.
118	12	11	Sprinkle with chopped dill and serve.
96	11	1	Cut the pork tenderloin into 8-9 pieces.
97	11	2	Grate the ginger and garlic on a fine grater.
98	11	3	Cut one chili pepper into thin rings.
99	11	4	Mix sesame oil, soy sauce, oyster sauce and honey in a bowl.
100	11	5	Add ginger, garlic and chili.
101	11	6	Place the pork in the marinade, mix everything well and leave for an hour.
102	11	7	Heat the frying pan over high heat.
103	11	8	Shake off the stuck ginger and garlic from the pieces of meat.
104	11	9	Place the pieces of meat in the frying pan so that there are two centimeters between them.
105	11	10	Fry the meat for 4 minutes on one side.
106	11	11	Fry the meat on all sides until golden brown.
107	11	12	When serving, sprinkle the dish with cilantro and chopped chili pepper.
54	8	1	Cut the onion into cubes.
55	8	2	Heat vegetable oil in a frying pan over medium heat.
56	8	3	Fry the onion for 5 minutes.
57	8	4	Grate the carrot on a coarse grater.
58	8	5	Place the carrot in the frying pan with the onions and fry for another 5 minutes.
59	8	6	Wash the buckwheat, add to the frying and mix.
60	8	7	Pour in 100 ml of water, add salt and cook for 10 minutes until half cooked.
61	8	8	Preheat the oven to 170 degrees.
62	8	9	Cut off the tail of the chicken carcass to avoid an unpleasant taste. Stuff the chicken, then peel off the chicken skin with toothpicks.
63	8	10	Tie the chicken legs and wrap the tips of the wings in foil to prevent them from burning.
64	8	11	Melt the butter, add salt and pepper. Place the chicken in a baking dish and brush with melted butter.
65	8	12	Place the chicken in the oven for two hours. At this time, periodically scoop oil from the bottom and pour on top.
66	8	13	For the last 15 minutes, increase the temperature to 220 degrees to get a crispy crust.
67	8	14	When serving, cut the chicken, sprinkle the filling with chopped parsley and pour oil from the baking dish.
111	12	4	Take another pot and fry the vegetables for 4 minutes in the oil.
120	13	2	Cut the onion into quarter rings and fry in a pot until soft.
81	10	1	Place whole strips of bacon in a frying pan, fry on both sides until bright brown and place on a napkin.
82	10	2	Cut the chicken fillet lengthwise into two flat slices, and then cut each crosswise into smaller slices.
83	10	3	Pour two tablespoons of flour into a plate.
84	10	4	Pound the chicken, salt, pepper and coat in flour.
85	10	5	Add oil to the pan where the bacon was fried.
86	10	6	Fry the chicken over high heat for 3 minutes on each side until golden brown, then place on a warm dish.
87	10	7	Grate the garlic cloves on a fine grater and fry for a minute over medium heat.
88	10	8	Add two tablespoons of flour and fry for another minute.
89	10	9	Pour the broth into the frying pan, stir until smooth and bring to a low boil.
90	10	10	Add soy sauce and stir again.
91	10	11	Pour in the cream and heat the sauce for a few minutes until it is almost boiling.
93	10	13	Return the chicken to the pan and simmer for 5 minutes.
94	10	14	Remove the pan from the heat, break the bacon strips into medium pieces and add to the sauce.
95	10	15	Sprinkle the finished dish with the remaining parmesan and chopped parsley.
68	9	1	Heat vegetable oil in a frying pan over high heat.
69	9	2	Rub the chicken with salt and pepper and fry until golden brown. Transfer the fried chicken to a baking dish.
70	9	3	Finely chop two onions and two cloves of garlic.
71	9	4	Fry vegetables for 8 minutes over medium heat in the same frying pan in which the chicken was fried.
72	9	5	Pour wine into the frying pan, increase the heat and evaporate half the liquid.
73	9	6	Now take the tomatoes, scald them with boiling water, peel them, and cut them into cubes.
74	9	7	Add canned tomatoes to fresh tomatoes and puree with a blender.
75	9	8	Preheat the oven to 170 degrees.
76	9	9	Place the chopped tomatoes in a frying pan with the onions and garlic, add thyme and oregano, tomato paste and sugar.
77	9	10	Simmer the sauce for 10 minutes until it thickens a little, and then put it in a baking dish with the chicken.
78	9	11	Cover the baking dish with foil and place in the oven for an hour.
79	9	12	After an hour, remove the foil, increase the temperature to 210 degrees and bake the chicken for another 15 minutes.
80	9	13	Sprinkle the finished dish with chopped garlic clove, grated parmesan and chopped parsley.
157	18	1	Peel potatoes. Leave small potatoes whole, and cut large ones in half.
158	18	2	Boil the potatoes for 10 minutes.
159	18	3	Then drain in a colander and let the water drain.
160	18	4	Pour a tablespoon of olive oil into the bottom of the baking dish. Place the potatoes in one layer, add salt.
161	18	5	Place in the oven at 200 degrees for half an hour.
162	18	6	At this time, mix the unpeeled garlic cloves, chopped rosemary and two tablespoons of olive oil.
163	18	7	Remove the baking dish from the oven and press the potatoes to the bottom of the baking dish so that the contact area is as large as possible.
164	18	8	Top the potatoes with oil, garlic and rosemary and return to the oven for half an hour.
121	13	3	Cut the meat into cubes 2 centimeters wide and add to the onion. At this point, juice will begin to release from the meat.
122	13	4	When the meat juice boils, add paprika. Then cover the pan with a lid and simmer the meat for 2 hours on the lowest heat.
123	13	5	While the meat is stewing, cut the potatoes into medium cubes and the carrots into slices.
124	13	6	Pour a liter of boiling water into the pan, add carrots and potatoes, salt, peppercorns and bay leaves.
125	13	7	Cook vegetables for 15 minutes.
126	13	8	At this time, cut the bell peppers into strips.
127	13	9	Peel the tomatoes and cut into small cubes.
128	13	10	Finely chop the garlic clove.
129	13	11	Place bell peppers, garlic and tomatoes in a saucepan with meat and vegetables.
130	13	12	Cook the soup for another 7 minutes.
131	13	13	When serving, add chopped parsley to each plate.
92	10	12	Add salt, spices and two-thirds of grated parmesan to the sauce. Heat the sauce until the cheese is completely melted.
148	17	1	Soak the beans overnight.
149	17	2	Drain the water, transfer the beans to the pan and pour in the chicken broth.
150	17	3	Bring the broth to a boil, add salt and cook the beans for 30 minutes.
151	17	4	Cut the onion, celery and carrots into small cubes.
152	17	5	Fry vegetables in olive oil for 10 minutes over medium heat.
153	17	6	Finely chop the garlic, thyme and half the parsley, add to the vegetables and fry for another minute.
154	17	7	Drain the broth from the beans into a bowl and transfer the beans to the vegetables. Don't pour out the broth; you'll need it later.
155	17	8	Pour 2 cups of the broth in which the beans were cooked into the frying pan and simmer for 15 minutes.
156	17	9	Finally, add the grated Parmesan and the other half of the parsley, stir and serve.
165	19	1	Wash chicken fillets, pat them dry with paper towels, and place them on a cutting board.
166	19	2	Pressing each fillet with one hand against the cutting board, while using the other hand to slice it into two thinner slices.
167	19	3	Rub each resulting escalope with salt and pepper.
168	19	4	Heat vegetable oil in a skillet and sear the escalopes over high heat until golden brown, about 2 minutes on each side.
169	19	5	Cut the garlic cloves into slices. Cut the shallot bulbs into quarters.
170	19	6	Take the chicken out of the skillet, add the garlic and shallots, and fry over medium-low heat for 5 minutes.
171	19	7	Add the apple and fry for another 2 minutes.
172	19	8	Pour the wine into the skillet, increase the heat, and simmer until half of the liquid evaporates.
173	19	9	Reduce the heat, add a spoon of honey to the sauce, stir, and return the chicken escalopes to the skillet.
174	19	10	Add sprigs of thyme, cover the skillet with a lid, and simmer for 20 minutes over low heat.
175	19	11	Before serving, remove the thyme, and sprinkle the finished dish with chopped parsley.
176	20	1	Grate ginger, garlic and orange zest on a fine grater.
326	40	1	Finely chop the avocado, celery, and chili pepper. 
138	15	1	Boil the eggs hard and peel them.
139	15	2	Cut each egg crosswise into two parts.
133	14	2	Add garlic and dill to the blender bowl. Grind all ingredients in a blender, but not until smooth.
135	14	4	Cut the tomatoes into slices half a centimeter wide.
136	14	5	Place a tomato round on each cracker and top with a tablespoon of cheese spread. This should be done immediately before serving.
137	14	6	Coarsely chop the walnuts and sprinkle them on top of each appetizer.
140	15	3	Remove the yolks, place them in a bowl and mash them with a fork.
141	15	4	Using a knife, lightly trim the bottoms of the egg white halves to create a flat surface so that they stand evenly and do not tip over.
142	15	5	Take a teaspoon and enlarge the cavities in the egg white halves to accommodate more filling.
143	15	6	Mash the cod liver with a fork and add to the bowl with the yolks.
144	15	7	Finely chop the red onion and add to the cod liver with yolks.
145	15	8	Add salt, pepper and mayonnaise to the pate. Stir the pate with a fork.
146	15	9	Stuff the egg halves with cod liver pate and serve.
132	14	1	Cut the cheese and eggs into large pieces and place them in a blender bowl.
134	14	3	Add salt, pepper and mayonnaise to the resulting cheese spread, mix with a fork.
1217	433	3	Add garlic and chili pepper, cooking for another 2-3 minutes.
1218	433	4	Add all the spices and stir well to combine.
1219	433	5	Dice the bell pepper and add it to the pot. Sauté for another 5 minutes.
1221	433	7	Heat the mixture for a couple of minutes, then add the chicken broth and bring to a boil.
1222	433	8	Add the can of red beans in tomato sauce and simmer for 3 minutes.
1223	433	9	Serve the soup hot, garnished with coarsely chopped fresh parsley and a handful of corn tortilla chips.
177	20	2	Add 3 tablespoons of vegetable oil, sesame oil, sriracha sauce, rice vinegar, orange juice and sugar.
178	20	3	Pour all ingredients into a blender bowl and blend for 15 seconds.
179	20	4	Take a sturdy zip-lock bag, place the pork chops in it, and pour in half of the marinade. Close it and put it in the refrigerator for at least an hour.
180	20	5	Pour a tablespoon of oil into a frying pan and heat over very high heat.
181	20	6	Fry the pork chops for 2 minutes on each side to get a nice crust.
182	20	7	Preheat the oven to 190 degrees and place the meat in there for 20 minutes.
183	20	8	Pour the remaining marinade into a small saucepan, place it over low heat.
184	20	9	Simmer the sauce for 7-8 minutes until it thickens slightly.
185	20	10	Take the pork chops out of the oven, place them on plates, and pour the sauce over each one.
186	21	1	Tear the salad greens into bite-sized pieces.
187	21	2	Thinly slice the red onion.
188	21	3	Drain and rinse the canned red beans and corn, and add them to the salad bowl.
189	21	4	Cut the cucumber into quarter-rings and add it to the salad bowl.
190	21	5	Chop the parsley and add it to the salad bowl.
191	21	6	In a small bowl, whisk together the olive oil, rice vinegar, oregano, salt, and pepper.
192	21	7	Pour the dressing over the salad and toss to coat.
193	21	8	Sprinkle with chopped walnuts and serve immediately.
200	23	1	Cut the leeks and potatoes into medium pieces.
201	23	2	Break the cauliflower into florets.
202	23	3	Add enough water to cover the vegetables completely.
203	23	4	Tie the thyme sprigs together with a string and add them to the vegetables.
204	23	5	Simmer over low heat for 40 minutes.
205	23	6	Remove the thyme sprigs and discard them.
206	23	7	Blend the vegetables with a hand blender until smooth, then add salt and pepper to taste.
207	23	8	If you prefer a smoother consistency, you can optionally pass the soup through a fine-mesh sieve.
208	23	9	Add the cream and whisk until smooth.
209	23	10	Toast the baguette slices and serve with the soup, garnished with green onions and leek rings.
210	24	1	Peel the carrots and grate them on a coarse grater.
211	24	2	Crush the garlic or grate it on a fine grater.
212	24	3	Chop the walnuts with a knife.
213	24	4	Mix everything in a salad bowl and add salt.
214	24	5	Dress the salad with mayonnaise and stir well.
194	22	1	Cut the tomatoes into large wedges (about 8 pieces each).
195	22	2	Halve the shallots lengthwise and then slice them into petals.
196	22	3	Break the feta cheese into small chunks by hand.
197	22	4	Combine the tomatoes, shallots, and feta cheese in a salad bowl.
198	22	5	Sprinkle the pomegranate seeds over the salad.
199	22	6	Season with salt, pepper, and olive oil.
215	25	1	Roughly chop the bell peppers and chili peppers.
216	25	2	Blend the bell peppers, chili peppers, garlic, cilantro, and parsley in a blender.
217	25	3	Add wine vinegar, oil, sugar, and salt; mix well.
218	25	4	Cut the tomatoes into quarters and place them in a bowl.
219	25	5	Pour the marinade over the tomatoes.
220	25	6	Cover the bowl with plastic wrap and refrigerate for at least 5 hours.
221	26	1	Place the quinoa in a fine-mesh strainer and rinse under cold water for a minute.
222	26	2	Combine the rinsed quinoa, 2 cups of water, and salt in a medium saucepan. 
223	26	3	Bring the mixture to a boil over high heat.
224	26	4	Once boiling, reduce the heat to low and cover the pot.
225	26	5	 Simmer for about 15 minutes, or until the quinoa has absorbed all the water.
226	26	6	Remove the pot from heat and let it sit, covered, for 5 minutes. 
227	26	7	Fluff the quinoa gently with a fork and serve.
228	27	1	Wash the potatoes and cut each one into 4-8 wedges, depending on their size.
229	27	2	Preheat the oven to 200 degrees Celsius.
230	27	3	Place the potato wedges in a plastic bag. Press the garlic cloves and add them to the bag along with salt, pepper, paprika, and the finely chopped dill.
231	27	4	Pour two tablespoons of vegetable oil into the bag.
232	27	5	Twist the top of the bag, trying to keep some air inside so the bag inflates slightly. Shake the bag vigorously for a few minutes to evenly coat the potatoes with the seasoning.
233	27	6	Line a baking tray with parchment paper. Spread the seasoned potatoes on the tray and bake for 25-30 minutes until golden and crispy.
234	28	1	Cut the cherry tomatoes in half, place them in a bowl, season with salt and pepper, and add one tablespoon each of olive oil and balsamic vinegar.
235	28	2	Set up three plates - one with flour, another with the crushed crackers seasoned with salt, pepper, and oregano, and a third with the beaten egg.
236	28	3	Slice the chicken breast lengthwise to make two flat pieces.
237	28	4	Coat each piece first in flour, then dip in the egg, and finally coat with the cracker mixture.
238	28	5	Heat the olive oil in a skillet and fry the chicken on both sides until golden brown.
1091	420	4	Break the walnuts into 2-3 pieces each and sprinkle them over the salad.
1093	420	6	Drizzle the dressing over the salad.
1089	420	2	Cut the strawberries in half or into quarters, depending on their size, so the pieces are roughly uniform.
1090	420	3	Place the mozzarella ball on a cutting board and break it into bite-sized pieces using a fork. 
1225	434	2	Add minced garlic and ginger, and sauté for an additional 3 minutes.
239	28	6	Slice the mozzarella ball and place slices on top of the fried chicken.
240	28	7	Cover and simmer on low heat for about 5 minutes.
241	28	8	Add the cherry tomatoes and a tablespoon of balsamic vinegar to the skillet. Cover and cook for another 3 minutes.
242	28	9	Add torn basil leaves and some freshly ground pepper. Serve hot.
243	29	1	Cut the white fish fillets into 4 pieces, soak them in milk for 15 minutes.
244	29	2	Preheat the oven to 220 degrees Celsius.
245	29	3	On a plate, mix flour with salt and pepper.
246	29	4	n a separate bowl, beat the eggs with a fork.
247	29	5	Make breadcrumbs from the bread, add finely chopped parsley and the zest of half a lemon to them.
248	29	6	Remove the fish from the milk, dredge in flour, then dip in beaten eggs, and finally coat with the breadcrumbs.
249	29	7	Fry the fish until it has a bright golden crust, about 2-3 minutes on each side.
250	29	8	Transfer the fish to a baking dish and bake in the oven for 8 minutes.
251	29	9	Serve the Milanese-style fish with the remaining half of the lemon.
252	30	1	Preheat the oven to 200 degrees Celsius.
253	30	2	Remove the butter from the refrigerator, let it soften slightly, then cream it together with the sour cream.
254	30	3	Add flour and vinegar to the creamed mixture and knead until the dough is uniform. Once done, wrap it in plastic wrap and refrigerate for 15 minutes.
255	30	4	Cut the apples into quarters, remove the cores and seeds, and slice them.
256	30	5	Roll out the dough and place it into a round pie form. Layer the sliced apples and cranberries over the dough, and sprinkle with sugar.
257	30	6	Shape the edges of the pie decoratively and bake in the oven for 25-30 minutes.
258	31	1	Sift the flour.
259	31	2	Add margarine: Cut the margarine into small pieces and chop it together with the flour using a knife.
260	31	3	Mix in the egg, stir well.
261	31	4	 Mash the cottage cheese with a fork and add it to the mixture.
262	31	5	Mix baking soda and vinegartogether and then add to the dough.
263	31	6	Knead the dough. Divide it into five equal parts, rolling each into a ball.
264	31	7	 Place the dough balls in the refrigerator for one hour.
265	31	8	Preheat the oven to 180 degrees Celsius.
266	31	9	Take a dough ball, roll it into a 0.5 cm thick circle, evenly sprinkle with 2 tablespoons of sugar, and then roll it out thinly.
267	31	10	Divide the circle into 6 sectors and roll each into a crescent.
268	31	11	Do the same with the remaining dough balls.
269	31	12	Bake the cookies for 20 minutes until golden.
270	32	1	Place the pork loin in a plastic bag. Add rosemary leaves, whole coriander seeds, salt, and pepper to the bag.
271	32	2	Finely chop the cilantro and parsley stems and add them to the bag. 
272	32	3	Crush the garlic and grate the onion on a fine grater, then add both to the pork.
273	32	4	Ensure all ingredients are evenly distributed around the meat. Seal the bag and refrigerate for 20-24 hours.
274	32	5	The next day, preheat the oven to 160 degrees Celsius.
275	32	6	Remove the pork from the bag, coat it thoroughly with honey and mustard, and wrap it in foil.
276	32	7	Place the pork in the oven and bake for 2 hours.
1343	445	7	Add the cinnamon stick and stir well.
1344	445	8	Pour in the white wine and let it reduce by half, about 2 minutes.
1088	420	1	Spread the arugula leaves evenly on a serving plate or in a salad bowl.
1092	420	5	In a small jar, combine the olive oil, honey, and lemon juice. Close the lid tightly and shake well until the dressing is well mixed.
1341	445	5	In the skillet used for the liver, add more vegetable oil if needed and sauté the pumpkin, cut into cubes, for about 5 minutes until slightly tender.
1342	445	6	Add the apples, also cut into cubes, to the skillet with the pumpkin.
1345	445	9	Return the liver to the skillet with the pumpkin and apples.
1346	445	10	Add the sautéed onion. Mix everything well and let it cook together for 2-3 minutes to blend the flavors.
1347	445	11	Remove the cinnamon stick. Season with salt and pepper to taste. Garnish with coarsely chopped parsley
1226	434	3	Add the pumpkin, cut into cubes, and sauté for 3 more minutes. Then, pour in the broth until it covers the vegetables.
1227	434	4	Season with salt and pepper, cover, and simmer for 20 minutes until the vegetables are tender.
1228	434	5	Blend the soup until smooth. Add honey and curry powder, mix well, and heat through for a couple of minutes.
1229	434	6	Serve the soup with a drizzle of natural yogurt, a splash of olive oil, and a sprinkle of pumpkin seeds.
277	32	8	The pork can be served hot as a hearty starter or allowed to cool first if preferred.
285	34	1	Combine butter with flour, mix in one egg, add sour cream and a pinch of salt. 
286	34	2	Knead the dough, wrap it in plastic, and refrigerate for 4 hours.
287	34	3	Preheat the oven to 180 degrees Celsius.
288	34	4	Let the chilled dough thaw slightly, then roll it out and fit it into a pie dish.
289	34	5	Cover the dough with parchment paper and fill with dry beans or lentils.
290	34	6	Bake for 10 minutes, then remove the parchment and beans.
291	34	7	Cut salmon and feta into medium cubes. Break broccoli into florets and arrange them with salmon and feta in the pie dish.
292	34	8	Whisk two eggs with cream, add salt, pepper, and grated Parmesan. Pour this mixture over the filling.
293	34	9	Return to the oven and bake for another 30 minutes. For a golden top, switch to grill mode for the last 5 minutes.
294	34	10	Let the quiche cool slightly before removing from the dish. It can be enjoyed both warm and cold.
278	33	1	Preheat the oven to 180 degrees Celsius.
279	33	2	Slice the chicken breast lengthwise, open it like a book, and pound it flat. Season with salt and pepper.
280	33	3	Finely chop the spinach and mix it with the soft cheese.
281	33	4	Spread the cheese and spinach mixture over the chicken. Place a few strips of bell pepper on one edge.
282	33	5	Tightly roll the chicken around the filling. Wrap the roll with bacon.
283	33	6	Place the roll in the oven and bake for 30 minutes.
284	33	7	Carefully slice the roll into not-too-thin slices, ensuring the filling stays intact.
295	35	1	Cut the cheese and eggs into large pieces and place them in a blender. Add garlic and dill.
296	35	2	Pulse the ingredients in the blender until combined but not completely smooth.
297	35	3	Transfer the cheese mixture to a bowl. Add salt, pepper, and mayonnaise, mixing everything together with a fork.
298	35	4	Cut the ham into thin slices. 
299	35	5	Place about 2 tablespoons of the filling on one edge of each ham slice and roll them up tightly.
300	36	1	In a large mixing bowl, beat together the heavy cream, cream cheese, and powdered sugar until smooth. 
301	36	2	Reserve two-thirds of this cream mixture, then add cocoa powder to the remaining third and beat for another minute to make the chocolate cream.
302	36	3	Spread half of the plain cream mixture into the bottom of individual serving glasses or a large glass bowl.
303	36	4	Break the shortbread cookies into large chunks and press them into the cream layer.
304	36	5	Cut half of the strawberries into small cubes and layer them over the cream.
305	36	6	Sprinkle a mix of chopped almonds, walnuts, and hazelnuts over the strawberries.
306	36	7	Spread all of the chocolate cream over the nuts and press more cookie pieces into this layer. Sprinkle with nuts again.
307	36	8	Spread the remaining plain cream over the top and add another layer of cookie pieces.
308	36	9	Decorate the top with the remaining strawberries and a sprinkling of mixed nuts.
309	36	10	Refrigerate the trifle for several hours to allow the flavors to meld before serving.
310	37	1	Remove the rind from the melon and cut it into medium pieces, about 2 cm each.
311	37	2	Slice the apricots and strawberries into 6-8 wedges each, depending on their size.
312	37	3	Dress the fruit with natural yogurt, mix well, and refrigerate for about 30 minutes to chill.
313	37	4	Just before serving, sprinkle the salad with pine nuts.
526	112	3	Begin beating the egg whites at low speed. Once they increase in volume, switch to high speed and beat until stiff peaks form.
527	112	4	Gradually add the sugar, continuing to beat at medium speed until fully incorporated.
528	112	5	Line a baking sheet with parchment paper and lightly grease it with vegetable oil.
314	38	1	Cut the salmon into bite-sized cubes.
315	38	2	In a bowl, mix soy sauce with finely chopped ginger, garlic, and half a chopped chili pepper.
316	38	3	Stir the marinade well, add the salmon pieces, cover the bowl with plastic wrap, and let it sit for 20 minutes.
439	58	3	Finely chop the parsley and add it to the salad.
441	58	5	Pour the dressing over the salad, mix well, and serve.
529	112	6	Spoon the meringue onto the parchment paper in tablespoon-sized dollops, spaced slightly apart.
530	112	7	Bake the meringues for 1.5 hours, then let them cool in the oven.
531	112	8	For the buttercream beat the softened butter with powdered sugar at high speed for 10 minutes.
532	112	9	Gradually add 50ml of milk, continuing to beat until smooth and creamy.
533	112	10	Cut the prunes in half and chop the walnuts into medium-sized pieces.
534	112	11	Place a layer of meringues on a serving dish, adding a few pieces of prunes and walnuts.
438	58	2	Drain the liquid from the canned white beans and add them to the cherry tomatoes.
440	58	4	Combine the juice of half a lemon, olive oil, salt, and pepper in a small bowl. Mix until well combined.
1095	421	2	Cut each radish into quarters. Cut the cucumbers into large, irregular pieces.
1096	421	3	Add the radishes and cucumbers to the bowl with the salad greens.
1097	421	4	Crumble the feta cheese with your hands over the vegetables.
1098	421	5	Toast the pumpkin seeds in a dry skillet until they are golden brown and fragrant.
1099	421	6	Sprinkle the toasted pumpkin seeds over the salad.
1100	421	7	In a small jar, combine the juice of half a lemon, olive oil, salt, pepper, and a pinch of sugar. Close the jar tightly and shake well until the dressing is emulsified.
1101	421	8	Serve the salad with the dressing on the side, allowing everyone to add the dressing just before eating to keep the salad fresh and crisp.
1094	421	1	Tear the salad greens into small pieces and place them in a large salad bowl.
327	40	2	Mash the tuna with a fork and combine it with the chopped ingredients. 
328	40	3	Season with salt and pepper, and add a dash of mustard and hot sauce.
329	40	4	Cut the cucumbers into long, thin slices, ideally using a vegetable slicer for uniform thickness.
330	40	5	Place a tablespoon of the filling at the edge of a cucumber slice and roll it up tightly.
370	48	2	Roll out the melted cheese with a rolling pin directly through the bag. Carefully cut the bag open along the edges and lay it flat.
371	48	3	In a bowl, mix the soft cheese with pressed garlic, finely chopped dill, salt, and pepper.
372	48	4	Evenly spread the filling over the cheese, leaving a 2 cm border without filling. Place slices of deli meats on top of the soft cheese mixture.
373	48	5	Using the plastic bag for assistance, tightly roll up the cheese to avoid any gaps inside. Wrap the roll in the same plastic bag and refrigerate for at least 2 hours.
374	48	6	Just before serving, remove the roll from the refrigerator, take off the plastic, and slice into beautiful pieces about half a centimeter thick.
362	47	2	Cut the tortilla into two pieces.
363	47	3	Spread half of the cream cheese on the first piece of tortilla.
364	47	4	Sprinkle the chopped dill evenly over the cheese.
365	47	5	Cover with the second piece of tortilla. 
366	47	6	Spread the remaining cream cheese on top and evenly distribute the salmon slices over the cheese.
367	47	7	Tightly roll up the tortilla, place it in the refrigerator for half an hour.
368	47	8	Remove from the refrigerator and cut the roll into portion-sized pieces, about 1.5 cm in length.
318	38	5	Once the sauce thickens, stir in the honey and half of the sesame seeds.
361	47	1	Finely chop the dill and slice the salmon thinly.
319	38	6	 Lay the salmon pieces in a single layer in the skillet and cook in the sauce on all sides until they turn a beautiful bronze color, about 10 minutes.
320	38	7	Place the cooked salmon on a plate, sprinkle with the remaining sesame seeds, chopped green onions, and chili pepper rings.
337	43	1	Preheat the oven to 180 degrees Celsius.
317	38	4	Remove the salmon from the marinade. Pour the marinade into a hot skillet, bring it to a boil, and let it simmer vigorously for 1-2 minutes until it thickens slightly.
338	43	2	Cut the peppers in half, remove the membranes and seeds, and drizzle with olive oil.
339	43	3	Place them in the oven for 5 minutes to soften slightly.
340	43	4	Mash the cheese with a fork, press the garlic into it.
341	43	5	Finely chop the herbs and add them to the cheese along with some ground pepper.
342	43	6	Fill the pepper halves with the cheese mixture, and drizzle again with olive oil.
343	43	7	Return the stuffed peppers to the oven and bake for an additional 10 minutes.
344	44	1	Tear the salad leaves by hand and distribute them evenly across the cups.
345	44	2	Slice the cherry tomatoes in half and place them into the cups.
346	44	3	Crumble the feta cheese into pieces by hand and add it to the tomatoes.
347	44	4	In a small bowl, mix together olive oil with of lemon juice. Season with salt and pepper to taste.
348	44	5	Drizzle the dressing over the salad in each cup.
349	44	6	Sprinkle pine nuts over the top for added texture and flavor.
356	46	1	Prepare the dressing: combine olive oil, lemon juice, pressed garlic, and salt. Mix well.
357	46	2	Cut iceberg lettuce into bite-sized pieces and place them in glasses. Halve the cherry tomatoes and add them to the salad.
358	46	3	Boil the shrimp for 5 minutes, then peel and chop them. Add the chopped shrimp to the salad, reserving a few whole shrimp for garnish.
359	46	4	Cut the pineapple rings into 4-6 pieces and add them to the salad, reserving a few pieces for garnish.
360	46	5	Pour the dressing over the salad, mix well, garnish with reserved shrimp and pineapple pieces, and serve.
375	49	1	Preheat the oven to 180 degrees Celsius.
376	49	2	Cut the chicken fillet into medium-sized cubes.
377	49	3	Wrap each piece of chicken with a slice of bacon.
378	49	4	Place the bacon-wrapped chicken pieces in the oven and bake for 25 minutes.
379	49	5	Allow the chicken to cool slightly.
380	49	6	Skewer cherry tomatoes onto toothpicks and combine them with the pieces of chicken.
321	39	1	Hard boil the eggs, then cut them in half and remove the yolks.
322	39	2	Arrange the egg white halves on a plate. If they wobble, trim a small slice from the bottom of each to create a flat base.
323	39	3	In a blender, combine the egg yolks, tuna, soft cheese, mayonnaise, salt, and pepper. Blend until smooth.
324	39	4	Spoon or pipe the mixture back into the egg white halves.
325	39	5	Sprinkle the filled eggs with paprika and serve.
333	42	1	Cut the feta into medium-sized cubes.
334	42	2	Cut the mango into bite-sized pieces of arbitrary shape.
335	42	3	Start by skewering a grape onto a toothpick.
336	42	4	Add a piece of mango and then a cube of feta on top.
350	45	1	In a blender, blend cheese with garlic and fresh herbs.
351	45	2	Season with salt and pepper, then mix in mayonnaise.
352	45	3	Cut off the tops of the cherry tomatoes and scoop out the pulp with a teaspoon. Slice a small piece off the bottom of each tomato so they stand upright.
353	45	4	Fill the hollowed cherry tomatoes with the cheese mixture.
354	45	5	Fry the shrimp until cooked.
355	45	6	Skewer each shrimp on a toothpick and place it on top of the stuffed cherry tomatoes.
331	41	1	Cut the cheese and cucumbers into bite-sized pieces.
332	41	2	Start with a slice of deli meat. Skewer it onto a toothpick, followed by a piece of cucumber and then a piece of cheese.
369	48	1	Place the block of cheese in a plastic bag, squeeze out the air, and tie the bag. Place the bag in a pot of boiling water and cook for 10-15 minutes until the cheese melts. Remove the cheese and place it on a large cutting board.
381	50	1	In a deep skillet, melt half of the butter.
382	50	2	Dice the onion and sauté it in the butter for 5 minutes.
383	50	3	Add the pearl barley to the onion and cook for a couple of minutes, stirring constantly to coat all the grains with butter.
384	50	4	Pour in the wine and cook until it is reduced by half.
385	50	5	Add a cup of broth to the barley mixture and cook until most of the broth is absorbed.
386	50	6	Continue adding the broth one ladle at a time, allowing it to absorb before adding the next, until all the broth is used.
387	50	7	Stir in the green peas and mix well.
388	50	8	Turn off the heat, add the remaining 50g of butter, and sprinkle with the grated parmesan cheese.
389	51	1	Cut the chicken fillet into medium-sized cubes or strips. Season with salt, pepper, and paprika, and mix well.
390	51	2	Heat a couple of tablespoons of vegetable oil in a skillet and fry the chicken pieces on all sides until cooked through. Transfer the cooked chicken to a plate.
391	51	3	Place the spinach in a salad bowl. Slice the pear into thin wedges and add to the spinach. Add the dried cranberries and chopped walnuts.
392	51	4	Add the fried chicken pieces to the salad. Pour any remaining juices and oil from the plate into the salad as well.
393	51	5	In a small bowl, combine the olive oil, apple cider vinegar, honey, and Dijon mustard. Add salt and pepper, and whisk until smooth.
394	51	6	Pour the dressing over the salad, mix well, and serve.
404	54	1	Heat vegetable oil and butter in a heavy-bottomed pot. Sear the beef shank on all sides until browned. Remove from the pot.
405	54	2	Dice the onion into large cubes, slice the carrots into half-moons, and cut the celery into rounds.
406	54	3	Sauté the vegetables in the pot over medium heat for 10 minutes.
407	54	4	Add finely chopped garlic, tomato paste, salt, and pepper to the vegetables. Stir and cook for another 2 minutes.
408	54	5	Pour in half the wine, stir, and return the beef to the pot.
409	54	6	Tie the thyme, sage, and 2 sprigs of parsley together with kitchen string and add to the pot.
410	54	7	Add the remaining wine and a cup of broth. Bring the sauce to a boil, cover the pot, reduce the heat to low, and simmer for 3-4 hours until the meat is tender.
411	54	8	While the meat simmers, slice the mushrooms and sauté in butter until golden brown.
412	54	9	Cook the rice in the chicken broth.
413	54	10	Remove the meat from the sauce, discard the bones, and shred the meat.
414	54	11	Return the meat to the sauce, add the mushrooms, and stir.
415	54	12	Mix the cooked rice into the meat and mushroom mixture. Heat everything together for a few minutes.
416	54	13	Roughly chop the remaining parsley and add just before serving.
395	52	1	Cut each radish in half and slice them thinly.
396	52	2	Slice the green onions and mix them with the radishes.
397	52	3	Add salt to taste.
398	52	4	Mix the salad with sour cream and serve.
399	53	1	Hard boil the eggs.
400	53	2	Dice the onion and fry it in vegetable oil until golden brown.
401	53	3	Finely chop the boiled eggs and mix them with the fried onions.
402	53	4	Add salt and pepper to taste.
403	53	5	Dress the mixture with aromatic oil and serve.
417	55	1	Dice the onion and garlic finely and sauté in olive oil until soft, about 5-7 minutes.
418	55	2	Grind the turkey meat, add half of the sautéed onion and garlic mixture, salt, and pepper. Mix the ground turkey thoroughly.
419	55	3	Dice the carrots and add them to the skillet, sautéing for 5 minutes. Add the smoked paprika, stir, and cook for another minute.
420	55	4	Add the diced tomatoes to the skillet. Drain and rinse the chickpeas, then add them to the vegetables.
421	55	5	Pour the chicken broth into the skillet, bring to a boil, season with salt and pepper, and simmer for 10 minutes uncovered over medium-low heat.
422	55	6	Wet your hands with water and form the turkey mixture into small meatballs. Place the meatballs in the simmering sauce, cover, and cook for 7-8 minutes.
423	55	7	Turn the meatballs, cover the skillet again, and cook for an additional 7 minutes.
424	55	8	Sprinkle the finished dish with roughly chopped parsley before serving.
430	56	6	Punch down the dough and knead it again. Return it to a warm place to rise until it doubles in size once more.
431	56	7	Once risen, divide the dough into 2 equal parts. Preheat the oven to 180°C.
432	56	8	Melt the remaining butter. Roll out each part of the dough into a rectangle. Brush the rectangle with melted butter, sprinkle with 3 tablespoons of sugar and one teaspoon of cinnamon.
433	56	9	Roll the rectangle into a log lengthwise, stretch the log with your hands, and cut it into 10-12 pieces. Repeat with the remaining dough.
434	56	10	Pinch one side of each small roll to form a bottom and place the formed rolls on a baking sheet lined with parchment paper.
435	56	11	Beat the remaining egg and brush it over the rolls.
436	56	12	Bake the rolls in the preheated oven for 20 minutes until golden brown.
437	58	1	Cut the cherry tomatoes into halves or quarters, depending on their size.
425	56	1	If using frozen yeast, thaw it first. Warm the milk to 40°C
427	56	3	Add half of the flour to the milk mixture and mix well.
429	56	5	Cover the dough with a towel and let it rise in a warm place until it doubles in size.
1103	422	2	Lightly toast the walnuts in a dry skillet until fragrant, then finely chop them in a blender.
524	112	1	Preheat the oven to 100°C.
1231	435	2	Cook the rice until half done.
495	108	7	In a separate saucepan, combine the chicken broth and coconut milk. Add the oyster sauce, hot sauce, and sugar.
1105	422	4	Press the garlic into the beetroot and walnut mixture, then add salt, pepper and mayonnaise. Mix well to combine.
1106	422	5	Choose your preferred base for the canapés: black bread, crackers, or crispbreads. Cut into round shapes if desired.
1107	422	6	Generously spread the beet pesto on each piece of bread or cracker.
1108	422	7	Place a piece of herring fillet on top of the beet pesto.
1109	422	8	Add a leaf of parsley to each canapé. Sprinkle with additional chopped walnuts for a finishing touch.
1232	435	3	Finely chop the onion and mix it with the ground beef and rice.
1233	435	4	Add olive oil, salt, pepper, cumin, and half of the dried mint to the beef and rice mixture. Mix well.
1234	435	5	Fill the zucchinis with the beef and rice mixture, leaving about 1 cm of space at the top to prevent bursting during cooking.
1235	435	6	Place the stuffed zucchinis in a large pot.
1236	435	7	In a bowl, combine the diced tomatoes and broth, then pour this mixture over the zucchinis. 
1237	435	8	Bring to a boil, then reduce to a simmer.
1238	435	9	Add sugar, chili powder or dried chilies, and cloves to the pot. Cover and simmer for 30 minutes.
1239	435	10	Crush the garlic cloves with the flat side of a knife and slice them thinly. Add to the pot.
1240	435	11	Add the pomegranate syrup, bay leaf, and remaining dried mint to the sauce. Simmer for another 5-7 minutes.
1241	435	12	Remove the bay leaf and cloves. Sprinkle with chopped cilantro, dill, and parsley before serving.
1348	446	1	Remove the sardines from the can and place them in a blender along with the sun-dried tomatoes.
1349	446	2	Blend the sardines and sun-dried tomatoes until smooth.
1350	446	3	Add the natural yogurt, salt, and pepper. Blend again until well combined.
1351	446	4	Allow the spread to rest in the refrigerator for about an hour to let the flavors meld.
1352	446	5	Spread the sardine mixture onto bread to make sandwiches or appetizers.
496	108	8	Heat this broth until it's almost boiling, then pour it into the skillet.
497	108	9	Allow the ingredients in the soup to simmer together for a few minutes to blend the flavors.
498	108	10	Squeeze the juice of one lime into the soup, ladle the soup into bowls, and garnish with chopped cilantro.
479	107	1	Soak the glass noodles in water for 5 minutes. Drain and cut them with scissors to about 10 cm in length.
482	107	4	Soak each rice paper sheet in hot, nearly boiling water for 2 minutes, then place on a board.
483	107	5	Place a few strips of surimi, carrots, cucumbers, and bell pepper on one edge of the rice paper sheet.
508	110	4	Cut the mushrooms into large pieces to ensure they retain their shape during the long braising process. Small mushrooms can be halved, while larger ones can be quartered.
489	108	1	Melt the butter in a deep skillet or wok.
490	108	2	Finely chop the garlic and ginger. Slice the chili pepper into rings and cut the lemongrass into 2-3 cm sticks.
491	108	3	Sauté the garlic, ginger, chili pepper, and lemongrass in the butter for 2 minutes.
492	108	4	Add the shrimp and sauté until they turn pink. If using pre-cooked shrimp, sauté for no more than two minutes.
493	108	5	Cut the cherry tomatoes in half, add them to the skillet, and sauté for another minute.
480	107	2	Cut the bell pepper, cucumbers, and carrots into thin strips. Roughly chop half of the cilantro.
481	107	3	Unroll the surimi into sheets and cut them into thin strips.
484	107	6	Add some cilantro and roll up tightly, folding in the sides.
485	107	7	Heat the vegetable oil in a pan and fry the spring rolls on both sides until golden brown. Place them on a paper towel to remove excess oil.
494	108	6	Roughly chop the green onion stalks and add them to the skillet.
486	107	8	In a blender, combine the garlic, peanuts, soy sauce, sesame oil, hot sauce, rice vinegar, remaining cilantro, and sugar. Blend until smooth.
487	107	9	Transfer the sauce to a saucepan, bring to a boil, then remove from heat.
488	107	10	The spring rolls can be served hot or cold with the spicy peanut sauce.
499	109	1	Cut the avocado in half and remove the pit. Use a tablespoon to scoop the flesh out of the skin.
500	109	2	Dice the avocado into medium-sized cubes and drizzle with the juice of half a lemon to prevent browning.
501	109	3	Cut the tomatoes and cucumbers into medium-sized pieces. Slice the red onion into thin wedges.
502	109	4	In a large bowl, combine the avocado, tomatoes, cucumbers, and red onion. Sprinkle with roughly chopped cilantro.
503	109	5	In a small bowl, mix together salt, pepper, the juice of the remaining half lemon, and olive oil.
504	109	6	Pour the dressing over the salad, toss gently, and serve.
509	110	5	Increase the heat and sauté the mushrooms for 5 minutes until they are browned.
510	110	6	Add the flour to the skillet, mix well, and cook for 1 minute.
511	110	7	Pour in the apple cider, bring to a boil, and simmer for 2 minutes.
426	56	2	In a small bowl, beat one egg. In a large mixing bowl, combine the warm milk, yeast, salt, 2 tablespoons of sugar, and the beaten egg. Stir until well combined.
505	110	1	Preheat your oven to 160°C.
506	110	2	Cut the pork into medium-sized cubes, about 3 cm wide. Fry the pork on high heat for 5 minutes until it develops a golden crust.
507	110	3	Dice the onion and add it to the skillet with the pork. Reduce the heat and sauté the onion for 5 minutes until it softens.
512	110	8	Season the mixture with salt and pepper. Pour in the chicken broth, bring to a boil, cover, and transfer to the preheated oven. Cook for 1.5 hours.
513	110	9	Cut the apples into wedges, add them to the sauce, and return the dish to the oven for another 10 minutes.
525	112	2	Separate the egg whites from the yolks; set the yolks aside (they won't be needed).
535	112	12	Take another meringue, generously coat the bottom with buttercream, and randomly attach it to the first layer of meringues.
536	112	13	Continue layering meringues, prunes, and walnuts, using the buttercream to adhere the meringues not only to the top but also to the sides of the cake.
537	112	14	Melt the chocolate in a double boiler and add the remaining 20ml of milk, stirring until smooth.
538	112	15	Drizzle the glaze over the cake, letting it flow down the sides. Sprinkle the remaining walnuts on top.
539	112	16	Allow the cake to sit in the refrigerator for at least 24 hours to let the flavors meld and the cake to set.
558	123	1	Cook the jasmine rice and let it cool.
559	123	2	Lightly toast the cashews in a dry skillet.
560	123	3	If using fresh pineapple, cut out the flesh and dice it into approximately 3 cm cubes.
561	123	4	Cut the chicken into small cubes, place them in a bowl, and marinate with 2 tablespoons of soy sauce for 20 minutes.
562	123	5	Heat a little vegetable oil in a skillet, add the chicken with the soy sauce, and quickly fry until golden brown.
563	123	6	Grate the garlic and ginger, remove the seeds from the chili pepper, and chop it finely.
564	123	7	Add the chili, garlic, and ginger to the chicken, sprinkle with turmeric, and stir-fry everything together for about a minute.
547	114	1	Sauté the shrimp in vegetable oil until they turn pink.
548	114	2	Cut the pineapple into bite-sized cubes.
549	114	3	Skewer a shrimp onto a toothpick with the tail facing upwards, then add a piece of pineapple.
565	123	8	Add the pineapple chunks, sprinkle with brown sugar, squeeze in the lemon juice, and stir-fry for another 2-3 minutes.
566	123	9	Add the cooled rice to the skillet with the chicken and pineapple, breaking up any clumps. Pour in the remaining 2 tablespoons of soy sauce and stir-fry for a couple more minutes.
567	123	10	Serve the Thai chicken in pineapple halves, garnished with toasted cashews.
550	115	1	Cut the cheese into bite-sized pieces and slice the cucumber into rounds. The shapes do not need to be perfectly uniform.
551	115	2	Cut the ham into wide, thin slices.
552	115	3	On a toothpick, skewer an olive first, followed by a randomly folded slice of ham, a cucumber slice, and finally a piece of cheese.
540	113	1	Fry the bacon in a skillet over low heat until it is crispy and golden. Place the cooked bacon on a paper towel to remove excess grease.
541	113	2	Tear the Frisée lettuce into bite-sized pieces and place them in a salad bowl.
542	113	3	Cut the cherry tomatoes in half and add them to the lettuce.
543	113	4	Once the bacon has cooled, break each slice into 3-4 pieces and add them to the salad.
544	113	5	Combine the olive oil, lemon juice, salt, and pepper in a small bowl. Mix until well combined.
545	113	6	Pour the dressing over the salad and toss gently to combine.
546	113	7	Lightly toast the pine nuts in a dry skillet over medium heat until golden brown, then sprinkle them over the salad.
428	56	4	Melt 50g of butter and add it to the dough along with the vegetable oil. Gradually add the remaining flour, kneading until you have a soft dough.
1242	436	1	Heat olive oil in a saucepan over medium heat. Add the berries and lightly sauté them. Reserve some berries for garnishing the finished dish.
1243	436	2	Depending on the season, you can use fresh or frozen berries. For example, I used frozen raspberries and fresh strawberries and blueberries.
1244	436	3	If the strawberries are larger than the other berries, cut them into quarters.
1245	436	4	Add the brown sugar to the berries and stir until it dissolves.
1246	436	5	Pour in the balsamic vinegar and red wine, add 4 sprigs of thyme, and simmer for 15 minutes.
1247	436	6	Season the salmon fillets with salt and pepper. Brush them with the liquid from the berry sauce.
1248	436	7	Grill or bake the salmon for 20 minutes.
1249	436	8	To serve, spoon the berry sauce over the salmon. Garnish with lemon wedges, fresh berries, and thyme sprigs.
1110	423	1	Soak the red beans in water for at least 4 hours or overnight.
1111	423	2	Mix the coriander, paprika, salt, and pepper.
1112	423	3	Cut the beef into large chunks, pat dry with paper towels, and rub with the spice mixture.
1113	423	4	Heat a heavy ovenproof pot over high heat.
1114	423	5	Brown the beef on all sides to form a crust. Remove the beef and set aside on a warm plate
1115	423	6	Finely chop the onion, garlic, and celery.
1116	423	7	In the same pot, sauté the vegetables over medium heat until soft, about 7-8 minutes.
1117	423	8	Pour the dark beer into the pot with the vegetables.
1118	423	9	Bring to a boil, scraping up any browned bits from the bottom and sides of the pot.
1119	423	10	Return the beef to the pot along with any accumulated juices.
1120	423	11	Add the soaked and drained beans, bay leaves, and flour. Stir well to combine.
1121	423	12	Preheat the oven to 150°C.
1122	423	13	Cover the pot tightly with a lid and place it in the oven.
1123	423	14	Cook for 4 hours until the beef is tender and the beans are cooked through.
1353	446	6	Garnish with your choice of nuts, seeds, dried berries, chopped green onions, or other herbs.
1250	437	1	Trim the ends of the cucumbers and place them in a sturdy zip-lock bag. Use a mallet or rolling pin to lightly smash the cucumbers, similar to tenderizing meat.
1251	437	2	Remove the cucumbers from the bag. Cut them lengthwise, then slice each half into 3-4 pieces at a 45-degree angle.
1252	437	3	Crush the garlic cloves with the flat side of a knife, then chop them roughly. Slice the chili pepper into rings.
1253	437	4	Add the garlic and chili to the cucumbers.
1254	437	5	In a small bowl, mix the sesame oil, rice vinegar, and soy sauce.
1255	437	6	Pour the dressing over the cucumbers. Sprinkle with chopped cilantro and mix well.
1256	437	7	The salad is ready to serve immediately.
1354	447	1	Slice the zucchini and eggplant into thick rounds. Cut the bell pepper into large pieces. Slice the red onion into thick rings.
1355	447	2	Toss the vegetables with olive oil, salt, and pepper.
1356	447	3	Preheat the grill to medium-high heat.
1357	447	4	Grill the vegetables for about 4-5 minutes on each side, until they are tender and have nice grill marks.
1358	447	5	Drizzle the vegetables with balsamic vinegar.
1124	424	1	Slice the pork tenderloin into thin strips.
1125	424	2	Marinate the pork in soy sauce while you prepare the other ingredients.
1126	424	3	Slice the mushrooms into wedges. Cut the leek into rings. Slice the red onion into thin strips. Cut the bell pepper into thin strips.
1127	424	4	Heat some vegetable oil in a wok over high heat. Stir-fry the marinated pork for about 5 minutes until browned.
1128	424	5	Add the mushrooms to the wok and stir-fry for another 3 minutes, keeping the heat high.
1129	424	6	Add the sliced red onion, bell pepper, and leek to the wok.
1130	424	7	Stir-fry everything together for another 3 minutes until the vegetables are tender-crisp.
1131	424	8	Cook the soba noodles according to the package instructions, usually no more than 10 minutes. Drain the noodles well.
1132	424	9	Add the cooked soba noodles to the wok. Sprinkle with sesame seeds and mix everything thoroughly to combine.
671	376	1	Slice the cucumbers and radishes into thin rounds. Chop the green onions and dill finely.
672	376	2	Tear the lettuce leaves into bite-sized pieces.
673	376	3	In a large bowl, combine the cucumbers, radishes, green onions, dill, and lettuce leaves.
674	376	4	Add the sour cream to the bowl with the vegetables. Mix gently until all the vegetables are well coated with the sour cream.
675	376	5	Season the salad with salt and pepper to taste. Mix gently to combine.
1143	425	11	Use your hands to mix and crumble the ingredients together until evenly distributed and crumbly.
1144	425	12	Sprinkle the pecan mixture evenly over the sweet potato and banana puree.
1145	425	13	Bake in the oven for 20 minutes, or until the pecan topping is golden brown and crispy.
1338	445	2	Sear the chicken liver for 5-6 minutes until it develops a nice, golden crust. Remove from the skillet and set aside.
1257	438	1	Cut the chicken fillet into small pieces and place them in a blender. Add 2 garlic cloves and coarsely chop.
1258	438	2	Add milk, breadcrumbs, oregano, chili, salt, and pepper to the blender. Blend everything together until the mixture is smooth.
1259	438	3	Wet your hands with cold water and form meatballs the size of walnuts. Also, wet the plate or board you will place the meatballs on with cold water.
1260	438	4	Dice the onion, carrots, celery, and the remaining garlic cloves into small cubes. Sauté in olive oil until soft, about 5-7 minutes.
1261	438	5	Pour in half of the chicken broth, add salt, and simmer for 30 minutes.
1262	438	6	Blend the vegetables with an immersion blender until smooth, creating a liquid puree.
1263	438	7	Add the remaining broth, stir well, and bring to a boil.
1264	438	8	Add the meatballs to the pot and simmer on low heat, covered, for 10 minutes.
1265	438	9	Wash the fresh spinach thoroughly and chop it roughly.
1133	425	1	Preheat the oven to 190°C.
1134	425	2	Pierce the sweet potatoes all over with a fork and place them in the oven. Roast for 30 minutes.
1135	425	3	Add the unpeeled bananas to the oven and roast everything together for an additional 15 minutes.
1136	425	4	Let the sweet potatoes cool slightly so they can be handled comfortably. Cut the sweet potatoes in half and scoop out the flesh into a bowl.
1137	425	5	Peel the bananas and add them to the bowl with the sweet potato flesh.
1138	425	6	Add 50g of softened butter, honey, salt, and pepper.
1139	425	7	Mash and mix the sweet potatoes and bananas together until smooth and well combined.
1140	425	8	Transfer the mixture to a baking dish, spreading it out evenly and smoothing the surface.
1141	425	9	Coarsely chop the pecans.
1142	425	10	In a bowl, combine the pecans, flour, remaining 70g of butter, and brown sugar.
1266	438	10	Add the chopped spinach to the pot and cook the soup for an additional 5 minutes.
1102	422	1	Boil the beetroot in its skin until tender, then let it cool. Peel the beetroot and cut into medium pieces.
1104	422	3	Add the cooled beetroot pieces to the blender with the chopped walnuts and blend until smooth.
1146	426	1	Place the beef on the bone in a large pot. Remove fat and skin from the chicken leg quarter and add to the pot.
1147	426	2	Fill the pot with water, bring to a boil, then drain the water.
1148	426	3	Refill the pot with water and bring to a gentle boil without letting it bubble vigorously.
1149	426	4	Reduce the heat to the minimum and carefully skim off any foam until it stops forming.
1150	426	5	Cover the pot and let the broth simmer on the lowest heat for 2 hours to keep it clear.
1151	426	6	Add the onion, carrot, parsley root and celery root, and herb stems to the broth. Simmer for another hour.
1152	426	7	Towards the end, add salt, black peppercorns, allspice peppercorns, and a bay leaf. Cook for another 15 minutes, then remove from heat and let it cool.
1153	426	8	Shred the beef and chicken meat into thin strips. Strain the broth. Reserve the carrot for garnishing.
1154	426	9	Prepare the gelatin according to the package instructions and mix it into the strained broth.
1155	426	10	Place the shredded meat into a mold and pour in most of the broth. Refrigerate until it starts to set.
1156	426	11	Once partially set, decorate with carrot slices, parsley leaves, and green peas.
1157	426	12	Carefully pour in the remaining broth and refrigerate until completely set.
1267	439	1	Place beef bones and meat in a pot, cover with water, and bring to a boil. Let it boil for a few minutes, then drain the water and refill the pot with fresh water.
1268	439	2	Add one partially peeled onion, one carrot, and the stems of the herbs to the broth.
1269	439	3	Bring to a boil, skim off the foam, cover, and simmer for 2 hours on low heat.
1270	439	4	Finely chop the remaining onion and grate the second carrot.
1271	439	5	Render half of the pork fat in a pan and sauté the onion and carrot for 10 minutes over medium heat.
1272	439	6	Scald the tomato with boiling water, peel, and cut into medium cubes. Place in a small pot.
1273	439	7	Dice the beets and add to the pot with the tomato.
1274	439	8	Add lemon juice, sugar, a pinch of salt, and 3-4 tablespoons of the meat broth.
1275	439	9	Cover and simmer on low heat for 40 minutes, adding more broth if needed.
1276	439	10	Boil one whole potato in the broth, then remove and mash it with a fork. Set aside for later.
1277	439	11	Remove the meat, bones, onion, carrot, and herb stems from the broth.
747	383	1	Dice the onions and sauté in vegetable oil over medium heat for a few minutes until they become soft.
748	383	2	Finely chop the garlic and chilies, add them to the onions, and sauté for another minute.
749	383	3	In a small bowl, mix the Madras curry powder with a little vinegar and a tablespoon of water to form a paste.
750	383	4	Add the paste to the sautéed vegetables and cook, stirring, for an additional minute.
751	383	5	Cut the chicken into medium-sized pieces, about 3 cm each, and add them to the skillet with the vegetables.
752	383	6	Sauté the chicken for 2-3 minutes until it starts to brown.
753	383	7	Dice the tomatoes to the same size as the chicken pieces and add them to the skillet.
754	383	8	Add the ground chili, turmeric, salt, and garam masala.
755	383	9	Pour in 300ml of water, bring to a boil, then reduce the heat to just below medium, cover, and simmer for 20 minutes.
756	383	10	After 20 minutes, remove the lid and simmer for an additional 10 minutes to thicken the sauce.
1278	439	12	Cut the remaining potatoes into small slices and cook in the broth for 10-12 minutes.
1279	439	13	Add salt, black peppercorns, allspice peppercorns, and a couple of bay leaves to the broth.
1280	439	14	Thinly slice the cabbage and add it to the soup, cooking for another 5 minutes.
1281	439	15	Cut the meat into pieces and return to the pot.
1282	439	16	Add the beet mixture and sautéed onion and carrot to the soup. 
1283	439	17	Cook for a few minutes to combine flavors, then let it stand covered for 10 minutes.
1284	439	18	Finely chop the remaining pork fat, garlic cloves, and herbs together.
1285	439	19	Serve the borscht with a tablespoon of the garnish in each bowl.
1158	427	1	Preheat the oven to 190°C.
1159	427	2	Separate the mushroom stems from the caps. Place the caps on a baking sheet and bake for 15 minutes.
1160	427	3	Dice the onion and sauté in a mixture of butter and vegetable oil until translucent.
1161	427	4	Dice the mushroom stems and add them to the onion. Sauté for 5 minutes.
1162	427	5	Cook the chicken fillet by baking, boiling, or grilling. Once cooked, dice the chicken and add it to the onion and mushroom mixture.
1163	427	6	Add the flour to the skillet, stir, and cook for 1 minute.
1164	427	7	Add the sour cream, salt, pepper, and nutmeg. Stir well and cook for another 2-3 minutes until the mixture thickens slightly.
1165	427	8	Fill the mushroom caps with the chicken julienne mixture. Top each stuffed mushroom with grated cheese.
1166	427	9	Return the stuffed mushrooms to the oven and bake until the cheese melts and turns golden brown, about 5-7 minutes.
1230	435	1	Cut off the ends of the zucchinis and carefully hollow out the insides using a thin knife and the handle of a teaspoon.
1286	440	1	If the beets are whole, grate them coarsely. Add just enough cold water to cover the beets and refrigerate for an hour.
1287	440	2	After an hour, remove the beets from the refrigerator. Add grated cucumber and two hard-boiled eggs (grated) to the pot.
1288	440	3	Finely chop the dill and green onions. Add them to the soup along with salt and pepper to taste.
1289	440	4	Pour in the kefir and refrigerate the soup for another half hour.
1290	440	5	Boil the potatoes for about 10 minutes until half-cooked. Then, cut them into halves or quarters, place them in a baking dish, and coat with butter.
1291	440	6	Bake at 200°C until they develop a golden, crispy crust.\r\n
1292	440	7	Serve each portion of cold beet soup with a halved boiled egg. Place the hot potatoes on a separate plate alongside the soup.
860	396	1	Place the dried chickpeas in a large bowl and cover with plenty of water, about 1 liter.
861	396	2	Soak for at least 12 hours or up to 24 hours.
862	396	3	Drain the soaked chickpeas and transfer them to a pot. Add fresh water and the baking soda.
863	396	4	Bring to a gentle boil over medium heat and cook until the chickpeas are soft, about 2-3 hours. Add more water as needed during cooking.
864	396	5	Halfway through cooking, add the onion (cut in half) and 3 garlic cloves for added flavor.
865	396	6	To check for doneness, try mashing a chickpea between your fingers; it should mash easily.
866	396	7	Drain the cooked chickpeas, reserving a few tablespoons of chickpeas for garnish.
867	396	8	Remove any skins that have floated to the surface.
868	396	9	Discard the onion and garlic used during cooking.
1224	434	1	Slice the leek and carrot into rounds and sauté in olive oil for 5 minutes.
1293	441	1	Cut the chicken breasts crosswise into 3 parts. Season with salt and pepper.
1294	441	2	Sear the chicken pieces on high heat for about 3 minutes on each side until they develop a golden crust. Cook in batches to avoid overcrowding the pan.
1295	441	3	Remove the chicken from the pan and set aside to cool. Reduce the heat and melt the butter in the same pan.
1296	441	4	Dice the onion and sauté in the butter until translucent, about 5 minutes. Finely chop the garlic.
1297	441	5	Cut the mushrooms into large pieces (4-6 parts) to ensure they remain chunky in the sauce.
1298	441	6	Add the garlic and mushrooms to the onions and sauté until all the liquid evaporates, about 10 minutes.
1299	441	7	Pour in the Marsala wine, bring to a boil, and reduce by half.
1300	441	8	Add the mascarpone cheese and Dijon mustard to the pan. Stir well and heat the sauce until it becomes smooth and creamy.
1301	441	9	Slice the chicken thinly (about 1 cm thick) and add it to the sauce, along with any juices left on the plate.
1302	441	10	Add finely chopped parsley and simmer the chicken in the sauce until fully cooked, about 10 minutes.
1303	441	11	Meanwhile, cook the fettuccine in a large pot of salted boiling water according to package instructions.
1304	441	12	Serve the Sicilian Chicken Marsala over the fettuccine, garnished with additional chopped parsley.
1167	428	1	Finely chop the garlic cloves and chili pepper. Add them to a skillet along with the cumin and paprika.
1168	428	2	Add a few tablespoons of vegetable oil, preferably a mix of regular refined oil with a little olive oil for aroma.
1169	428	3	Sauté the garlic, chili, and spices over medium-high heat for 2-3 minutes until fragrant.
1170	428	4	Grate the tomatoes, holding them by the skin, and add the grated pulp to the skillet.
1171	428	5	Add the salt, sugar, tomato paste, and lemon juice to the tomatoes. Simmer over low heat for 10 minutes, stirring occasionally.
1172	428	6	Cut the bell pepper into small cubes and add to the tomatoes. Simmer for another 2 minutes until the bell pepper is slightly softened but not fully cooked.
1173	428	7	Turn off the heat and let the tomato and pepper mixture cool.
1174	428	8	Finely chop the onion and the cilantro and parsley. Place them in a bowl and add the vinegar.
1175	428	9	Once the tomato mixture has cooled, combine it with the onion and herb mixture.
936	402	1	Dice the onion and carrot into small cubes.
937	402	2	Melt 50g of butter in a skillet over medium heat and sauté the vegetables for about 7 minutes until they are soft.
938	402	3	Clean the chicken liver by removing any membranes and cutting it into medium-sized pieces.
939	402	4	Add the liver to the skillet with the sautéed vegetables and cook for about 5 minutes.
940	402	5	Slice the mushrooms and add them to the skillet with the liver. Stir and cook for another 2 minutes.
941	402	6	Pour in the cognac and sour cream, season with salt and pepper. Stir well to combine.
942	402	7	Cover the skillet and let the mixture simmer for 30 minutes.
943	402	8	Add the nutmeg and finely chopped garlic, cover again, and simmer for an additional 15 minutes.
944	402	9	Turn off the heat and let the mixture cool slightly. Add the remaining butter to the skillet.
945	402	10	Transfer the contents to a blender and blend until smooth and creamy.
946	402	11	Transfer the pâté to a serving dish or storage container. Refrigerate for at least 3 hours before serving to allow the flavors to meld.
1305	442	1	Roast all the peanuts in a dry skillet until golden brown. Set aside 1 tbsp for the salad and 3 tbsp for the dressing.
1306	442	2	Thinly slice the napa cabbage. Cut the cucumber, carrot, and bell pepper into thin strips.
1307	442	3	Chop the cilantro or parsley (use half for the salad and half for the dressing).
1308	442	4	In a blender, combine 3 tbsp roasted peanuts, chopped chili pepper, ginger, garlic, and the remaining cilantro or parsley.
1309	442	5	Blend until finely chopped. Add soy sauce, rice vinegar, honey, and lemon juice to the blender.
1310	442	6	Blend until smooth. If the dressing is too thick, add a few tablespoons of water to reach the desired consistency.
1311	442	7	In a large bowl, combine the napa cabbage, cucumber, carrot, bell pepper, 1 tbsp roasted peanuts, and half of the chopped cilantro or parsley.
1312	442	8	Pour the dressing over the salad and toss well to combine.
1313	442	9	Sprinkle sesame seeds on top for garnish.
1176	429	1	Preheat the oven to 190°C.
1177	429	2	Cut the cherry tomatoes in half and place them in a bowl.
1178	429	3	Add the honey, balsamic vinegar, 1 tbsp olive oil, salt, and pepper. Mix well to coat the tomatoes.
1179	429	4	Spread the tomatoes on a baking sheet and roast for 25 minutes until they are soft and caramelized.
1180	429	5	Slice the baguette into thin slices and place them on a baking sheet.
1181	429	6	Drizzle with olive oil, and season with salt and pepper.
1182	429	7	Toast in the oven for about 15 minutes until golden brown.
1183	429	8	In a bowl, mix the ricotta cheese with 1 tbsp olive oil.
1184	429	9	Add the grated garlic clove or garlic powder and stir until well combined.
1185	429	10	Allow the toasted baguette slices to cool slightly.
1186	429	11	Spread a generous amount of the ricotta mixture on each slice.
1187	429	12	Top with roasted tomatoes and garnish with sliced basil leaves.
1215	433	1	Slice the onion into thin strips and the chili pepper into rings. Crush the garlic cloves with the flat side of a knife and slice into thin pieces.
984	406	3	Cut the lamb meat into large chunks, about 4 cm each.
985	406	4	Heat vegetable oil in a skillet over high heat and brown the lamb pieces. Divide the browned meat among the clay pots.
986	406	5	Slice the onion into quarter rings.
987	406	6	In the same skillet, sauté the onion until lightly golden. Divide half of the sautéed onion among the clay pots, placing it over the lamb.
988	406	7	Peel the potatoes and cut them into 3-4 pieces each, depending on their size.
989	406	8	Add the potato pieces to the clay pots.
990	406	9	Finely chop the garlic cloves and add them to the clay pots. Season with salt and freshly ground pepper.
991	406	10	Cut large and medium prunes in half, leaving small ones whole. Add the prunes to the clay pots along with the remaining sautéed onion.
992	406	11	Fill the clay pots with the prepared broth up to the "shoulders" of the pots.
993	406	12	Cover the pots with their lids and place them in a preheated oven at 150°C.
1216	433	2	Sauté the onion in olive oil in a pot over medium heat for 5 minutes.
982	406	1	Cut the lamb meat off the bone and set aside.
983	406	2	Place the bone in a pot with water and add  onion and parsley root. Simmer to make a broth. 
1220	433	6	Add the canned tomatoes. If using whole tomatoes, crush them with a spatula directly in the pot.
1045	412	1	Remove the thick stems from the Swiss chard leaves and place the leaves in a salad bowl.
1046	412	2	Slice the celery stalk crosswise into thin pieces.
1026	410	1	Cut all the vegetables into small, even-sized cubes. Remove the soft, seedy centers from the tomatoes and zucchini. 
1027	410	2	Slice the garlic into thin petals.
1028	410	3	Heat 4 tablespoons of olive oil in a skillet over low heat. Add the diced carrots and onions and sauté for 5 minutes.
1029	410	4	Add the sliced garlic and diced bell pepper, and continue to sauté for another 5 minutes, stirring occasionally to coat the vegetables in oil.
1030	410	5	Add the diced zucchini and an additional tablespoon of olive oil. Sauté for 15 minutes, ensuring all vegetables are evenly coated with oil.
1031	410	6	Finally, add the diced tomatoes and sauté for another 5 minutes.
1032	410	7	Transfer the sautéed vegetables to a large pot. Add 1200ml of water and the diced potato. Bring to a boil, then reduce the heat and simmer for 15 minutes.
1033	410	8	If you have a heavy-bottomed pot, you can sauté the vegetables directly in it, avoiding the need to transfer.
1034	410	9	Using a slotted spoon, remove half of the vegetables from the pot. 
1035	410	10	Roughly purée the remaining vegetables in the pot with an immersion blender. Return the reserved vegetables to the pot.
1036	410	11	Add the small pasta to the pot and cook for a few minutes until al dente.
1037	410	12	Season the soup with salt and pepper to taste.
1038	410	13	Ladle the soup into bowls. Garnish with chopped fresh parsley or basil and sprinkle with grated Parmesan cheese.
1047	412	3	Cut the peaches into medium-sized cubes and add them to the salad bowl.
1048	412	4	Break the mozzarella ball into bite-sized pieces using a fork and add to the salad.
1049	412	5	Sprinkle the pumpkin seeds over the salad
1050	412	6	In a small jar, combine the mustard, honey, lemon juice, and olive oil.
1051	412	7	Close the lid tightly and shake well until the dressing is well mixed and emulsified.
1052	412	8	Dress the salad with the honey-mustard dressing just before serving, or serve the dressing on the side for individual preference.
1188	430	1	Rinse the rice under cold water until the water runs clear. This removes excess starch and prevents the rice from becoming sticky.
1189	430	2	In a medium saucepan, bring 2 cups of water to a boil. 
1190	430	3	Add the rinsed rice to the boiling water. Stir once, then reduce the heat to low and cover the saucepan with a tight-fitting lid.
1191	430	4	Simmer for 15-18 minutes, or until all the water is absorbed and the rice is tender. Avoid lifting the lid during cooking.
1192	430	5	Remove the saucepan from the heat and let it sit, covered, for 5 minutes. Fluff the rice with a fork before serving.
1314	443	1	Slice the turkey fillet across the grain into escalopes about 1.5-2 cm thick. Alternatively, you can buy pre-sliced escalopes.
1315	443	2	Squeeze the mandarins to get about a cup of juice.
1316	443	3	Mix the mandarin juice with soy sauce, grated ginger, and finely chopped chili pepper.
1317	443	4	Place the escalopes in the marinade and refrigerate for 20-30 minutes.
1318	443	5	Heat olive oil and butter in a skillet over high heat.
1319	443	6	Remove the turkey from the marinade, pat dry with a paper towel, and fry for 3-4 minutes on each side until golden brown.
1320	443	7	Cook the escalopes in batches if necessary to avoid overcrowding the skillet. Transfer the cooked escalopes to a warm plate.
1321	443	8	In the same skillet, fry the flour for one minute
1322	443	9	Strain the marinade and gradually add it to the skillet, stirring with a whisk.
1007	408	3	Dice the tomato into small cubes.
994	406	13	Cook the pots in the oven for 2 hours until the meat and potatoes are tender and the flavors are well combined.
995	406	14	Before serving, sprinkle the dish with chopped cilantro.
1008	408	4	Dice the cucumber into small cubes and add to the bowl with the tomato.
1009	408	5	Dice the bell pepper and red onion into small cubes and add to the salad.
1010	408	6	Roughly chop the parsley and mint leaves. Add them to the salad bowl.
1011	408	7	Slice the chili pepper into rings and add to the salad.
1012	408	8	In a small bowl, mix together the olive oil, wine vinegar, honey, minced garlic, salt, and pepper.
1013	408	9	Pour two-thirds of the dressing over the salad and mix well.
1014	408	10	Peel the pomegranate and remove the seeds. Add about one-third of the seeds to the salad.
1015	408	11	Crumble the feta cheese with your hands and add to the salad.
1016	408	12	Pour the remaining dressing over the salad and give it a gentle toss.
1323	443	10	Bring the sauce to a boil, then reduce the heat and return the turkey escalopes to the skillet.
1005	408	1	Soak the lentils in water for 30 minutes.
1006	408	2	Rinse and cook the lentils according to the package instructions until tender. Drain and let cool.
1324	443	11	Simmer for 2-3 minutes until the turkey is heated through and the sauce thickens slightly.
1325	443	12	Serve the turkey escalopes hot, drizzled with the mandarin sauce.
1062	414	1	Slice the onions lengthwise into thin strips. Heat some vegetable oil in a heavy-bottomed pot or sauté pan over medium heat.
1063	414	2	Sauté the onions for about 15 minutes until soft. Add the sliced carrot and cook for another 5 minutes.
1064	414	3	Add canned tomatoes, breaking them up with a spatula. Stir in sugar, salt, pepper, oregano, and basil.
1065	414	4	Partially cover and simmer over low heat for 45 minutes, stirring occasionally.
1066	414	5	Cut fish fillets into small portions. Season the flour with salt and coat the fish pieces.
1067	414	6	Fry in vegetable oil for 2-3 minutes on each side until golden brown.
1068	414	7	Preheat oven to 180°C.
1069	414	8	In a baking dish, layer a third of the tomato sauce, half the fish, and half the peas. Repeat layers, finishing with the remaining sauce.
1070	414	9	Bake for 30 minutes. 
1071	414	10	Garnish with chopped parsley before serving.
1193	431	1	Peel the potatoes and cut them into evenly-sized chunks.
1194	431	2	Place the potatoes in a large pot and cover with cold water. Add a pinch of salt.
1195	431	3	Bring to a boil, then reduce the heat and simmer for about 20 minutes, or until the potatoes are tender.
1196	431	4	Drain the potatoes well and return them to the pot.
1197	431	5	Add the butter to the potatoes and mash until smooth. Gradually add the milk, continuing to mash, until the potatoes reach your desired creaminess.
1198	431	6	Season with salt and pepper to taste.
1199	431	7	Serve hot, garnished with sliced green onion stalks if desired.
1326	444	1	Cut the chicken into small cubes.
1327	444	2	Slice the bell peppers, carrots, and cucumber into thin strips.
1328	444	3	Soak the glass noodles in hot water according to the package instructions.
1329	444	4	Heat the sesame oil in a wok or large skillet over high heat.
1330	444	5	Add the cane sugar and stir until it melts and starts to caramelize.
1331	444	6	Add the minced garlic and soy sauce, stirring quickly.
1332	444	7	Add the chicken cubes and stir constantly to coat them in the sauce.
1333	444	8	Once the chicken is caramelized and cooked through, add the carrots and bell peppers.
1334	444	9	Stir-fry for about 5 minutes until the vegetables are tender-crisp.
1335	444	10	Add the cucumber strips and stir-fry for an additional minute.
1336	444	11	Add the soaked glass noodles to the wok, sprinkle with sesame seeds, and toss everything together until well mixed.
1072	415	1	Slice the rye bread into rectangular pieces. Lightly fry the bread slices in vegetable oil until crispy.
1073	415	2	Scoop the avocado flesh into a bowl and mash it with a fork.
1074	415	3	Crush the garlic clove and mix it into the avocado mash.
1075	415	4	Mix in some cream cheese for extra creaminess.
1076	415	5	Spread the avocado and garlic mixture onto the toasted bread slices.
1077	415	6	Place a sprat on top of each toast.
1078	415	7	Slice the pickled cucumbers into rings and arrange them on top of the sprats.
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, password, email, role, created, edited, last) FROM stdin;
8	expert89	8989	expert89@tasty.com	moderator	2024-05-07 19:03:22.496065	2024-06-14 12:55:27.024784	2024-06-22 21:48:36.072657
5	Emily	4444	emily@emily.com	user	2024-05-02 02:22:04.494836	2024-05-02 02:22:04.494836	2024-05-02 02:22:04.494836
10	user2108	2108	u@uuu.com	user	2024-06-02 21:13:16.346478	2024-06-02 21:13:16.346478	2024-06-02 21:13:16.346478
11	t4n	t4n	t@t.t	user	2024-06-17 20:29:27.752756	2024-06-17 20:29:27.752756	2024-06-17 20:29:27.752756
7	cook142	142	v@v.com	author	2024-05-07 16:30:20.545531	2024-05-07 16:30:20.545531	2024-06-22 19:42:26.176343
9	master_chef	qwerty	master@chef.com	author	2024-05-16 02:01:23.026419	2024-05-16 02:01:23.026419	2024-06-22 20:10:02.056754
504	moderator1	777	m@m.com	moderator	2024-06-22 20:54:06.21898	2024-06-22 20:54:06.21898	2024-06-22 20:54:06.21898
507	author1	555	a@a.com	author	2024-06-22 20:59:53.609258	2024-06-22 20:59:53.609258	2024-06-22 20:59:53.609258
1	admin	admin	admin@gmail.com	admin	2024-05-02 02:10:26.818141	2024-06-18 19:08:34.95541	2024-06-22 21:08:58.74224
3	Mary	222	mary@mary.com	author	2024-05-02 02:19:00.435603	2024-05-02 02:19:00.435603	2024-06-22 21:21:18.814614
503	Dina	111	d.zelikina@gmail.com	user	2024-06-20 14:40:43.306985	2024-06-20 14:40:43.306985	2024-06-21 20:18:22.766823
508	alex	alex	alex@tr.tr	moderator	2024-06-22 21:09:36.366556	2024-06-22 21:09:36.366556	2024-06-22 21:30:09.388715
2	nick23	2323	nick23@nick.com	moderator	2024-05-02 02:14:46.040054	2024-06-18 18:28:35.841195	2024-06-22 21:38:24.982268
4	John	333	john@john.com	author	2024-05-02 02:19:32.177183	2024-05-02 02:19:32.177183	2024-06-21 23:03:40.176881
\.


--
-- Name: dishes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dishes_id_seq', 447, true);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 1473, true);


--
-- Name: menus_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.menus_id_seq', 24, true);


--
-- Name: moderation_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.moderation_id_seq', 142, true);


--
-- Name: steps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.steps_id_seq', 1358, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 508, true);


--
-- Name: dishes dishes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dishes
    ADD CONSTRAINT dishes_pkey PRIMARY KEY (id);


--
-- Name: dishes dishes_title_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dishes
    ADD CONSTRAINT dishes_title_key UNIQUE (title);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: menus menus_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_pkey PRIMARY KEY (id);


--
-- Name: moderation moderation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderation
    ADD CONSTRAINT moderation_pkey PRIMARY KEY (id);


--
-- Name: steps steps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: dishes dishes_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dishes
    ADD CONSTRAINT dishes_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.users(id);


--
-- Name: ingredients ingredients_dish_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dishes(id);


--
-- Name: menus menus_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.menus
    ADD CONSTRAINT menus_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: moderation moderation_dish_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderation
    ADD CONSTRAINT moderation_dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dishes(id);


--
-- Name: moderation moderation_moderator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.moderation
    ADD CONSTRAINT moderation_moderator_id_fkey FOREIGN KEY (moderator_id) REFERENCES public.users(id);


--
-- Name: steps steps_dish_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.steps
    ADD CONSTRAINT steps_dish_id_fkey FOREIGN KEY (dish_id) REFERENCES public.dishes(id);


--
-- PostgreSQL database dump complete
--

