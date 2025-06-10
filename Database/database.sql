create database tana_di_paolo;
use tana_di_paolo;

create table cantine(
id int primary key auto_increment,
cantina varchar(100) unique not null
);

create table vitigni(
id int primary key auto_increment,
vitigno varchar(100) unique not null
);

create table invecchiamenti(
id int primary key auto_increment,
invecchiamento varchar(100) unique not null,
affinamento decimal(3,2) not null
);

create table tipologie(
id int primary key auto_increment,
tipologia varchar(100) unique not null
);

create table vini (
id int primary key auto_increment,
nome varchar(100) not null,
vitigno int not null,
tipologia int not null,
foreign key (vitigno) references vitigni(id),
foreign key (tipologia) references tipologie(id)
);

create table magazzino(
id int primary key auto_increment,
vino int not null,
aromi varchar(200) not null,
cantina int not null,
invecchiamento int not null,
alcol decimal(5,2) not null,
annata int not null,
maturazione int not null,
zuccheri_residui decimal(5,2) not null,
glicerolo decimal(5,2) not null,
passiti boolean not null,
acido_tartarico decimal(5,2) not null,
acido_malico decimal(5,2) not null,
acido_citrico decimal(5,2) not null,
acido_lattico decimal(5,2) not null,
tannini int not null,
qualita decimal(3,2) not null,
prezzo_acquisto decimal(10,2) not null,
prezzo_vendita decimal(10,2) not null,
immagine varchar(8) not null,
quantita int not null,
ordinabilita int not null,
foreign key (invecchiamento) references invecchiamenti(id),
foreign key (cantina) references cantine(id),
foreign key (vino) references vini(id) on delete cascade
);

create table abbonamenti(
id int primary key auto_increment,
titolo varchar(200) not null,
descrizione text not null,
prezzo decimal(10,2) not null
);

create table codici_sconto(
id int primary key auto_increment,
code varchar(100) unique not null,
percentuale int,
decimale decimal(10,2)
);

create table ruoli(
id int primary key auto_increment,
ruolo varchar(100) not null
);

create table utenti(
id int primary key auto_increment,
ruolo int not null,
email varchar(100) unique not null,
password varchar(200) not null,
nome varchar(100) not null,
cognome varchar(100) not null,
abbonamento int,
foreign key (ruolo) references ruoli(id),
foreign key (abbonamento) references abbonamenti(id)
);

-- Utenti non loggati
create table shadows(
id int primary key auto_increment,
expire datetime not null
);

create table righe_carrello(
id int primary key auto_increment,
utente int,
shadow int,
vino int not null,
quantita int not null,
unique (utente, shadow, vino),
foreign key (vino) references magazzino(id),
foreign key (utente) references utenti(id),
foreign key (shadow) references shadows(id) on delete cascade
);

create table righe_carrello_sconti(
id int primary key auto_increment,
utente int,
shadow int,
promocode int not null,
usato boolean not null default false,
unique (utente, promocode),
foreign key (promocode) references codici_sconto(id),
foreign key (utente) references utenti(id),
foreign key (shadow) references shadows(id) on delete cascade
);

create table ordini(
id int primary key auto_increment,
utente int not null,
totale decimal(10, 2) not null,
da_abbonamento int default 0,
data datetime not null,
foreign key (utente) references utenti(id)
);

create table righe_ordini(
id int primary key auto_increment,
ordine int not null,
vino int not null,
quantita int not null,
unique (ordine, vino),
foreign key (vino) references magazzino(id),
foreign key (ordine) references ordini(id)
);

create table questionari(
utente int primary key,
alcol decimal(3,2) default 0,
zuccheri_residui decimal(3,2) default 0,
glicerolo decimal(3,2) default 0,
acido_tartarico decimal(3,2) default 0,
acido_malico decimal(3,2) default 0,
acido_citrico decimal(3,2) default 0,
tannini decimal(3,2) default 0,
affinamento decimal(3,2) default 0,
passiti decimal(3,2) default 0,
maturazione decimal(3,2) default 0,
foreign key (utente) references utenti(id)
);

create table tipologie_preferite(
id int primary key auto_increment,
questionario int not null,
tipologia int not null,
unique(questionario, tipologia),
foreign key (questionario) references questionari(utente),
foreign key (tipologia) references tipologie(id)
);

insert into codici_sconto(code, percentuale, decimale) values
('JUSTAGAME', 10, 0),
('HATESOBERTY', 0, 20),
('JUSTPAOLO', 5, 10),
('PAOLOPAOLOPAOLOPAOLOPAOLO', 20, 10);

INSERT INTO abbonamenti (titolo, descrizione, prezzo) VALUES
('Abbonamento Base', 'Scopri una selezione curata di vini che si adattano ai tuoi gusti e alle stagioni. Ogni mese, il nostro algoritmo ti propone nuove etichette, pensate per offrirti una piacevole esperienza di degustazione. Perfetto per chi vuole esplorare il mondo del vino con semplicità e gusto.', 29.99),
('Abbonamento Premium', 'Esplora il meglio del panorama vinicolo con una selezione di vini esclusivi e di qualità superiore. Grazie all\'algoritmo, riceverai vini pregiati scelti per soddisfare i palati più raffinati, con etichette che raccontano storie uniche di terroir e tradizione.', 59.99),
('Abbonamento Esclusivo', 'Vivi un\'esperienza vinicola senza pari con un abbonamento pensato per i veri intenditori. I nostri esperti e l\'algoritmo selezionano per te vini unici, tra cui piccole produzioni e annate rare, per un viaggio sensoriale che arricchirà ogni momento della tua tavola.', 89.99);

INSERT INTO tana_di_paolo.ruoli (ruolo) VALUES
('Cliente'),
('Lavoratore'),
('Somelier'),
('Amministratore');

insert into utenti(email, password, nome, cognome, ruolo) values
("admin@pao.lo", "$2y$10$am2TScEQyGB1jNLZZ79Zw.A0firmcyDggha7nwxRpsBc3md7e1vAu", "Admin", "", 3);

INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('A. Christmann'),
('Aalto'),
('Albert Mann'),
('Aldo Conterno'),
('Allegrini'),
('Alois Lageder'),
('Alphonse Mellot'),
('Alvaro Palacios'),
('Anselmi'),
('Antinori');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Antonelli'),
('Argiolas'),
('Arnaldo Caprai'),
('August Kesseler'),
('Avignonesi'),
('Barberani'),
('Basilisco'),
('Bellavista'),
('Benanti'),
('Bercher');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Berlucchi'),
('Bernhard Huber'),
('Bertani'),
('Biondi-Santi'),
('Bollinger'),
('Bonneau du Martray'),
('Braida'),
('Bruno Giacosa'),
('Bucci'),
('Ca'' del Bosco');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Canalicchio di Sopra'),
('Cantele'),
('Cantina di Santadi'),
('Cantina Terlano'),
('Cantina Tramin'),
('Cantine del Notaio'),
('Capichera'),
('Carlo Hauner'),
('Casanova di Neri'),
('Castellare di Castellina');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Castello Banfi'),
('Castello di Ama'),
('Castello di Volpaia'),
('Cataldi Madonna'),
('Cavallotto'),
('Ceretto'),
('Château Carbonnieux'),
('Château de Beaucastel'),
('Château Haut-Brion'),
('Château Lafite Rothschild');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Château Latour'),
('Château Lynch-Bages'),
('Château Margaux'),
('Château Mouton Rothschild'),
('Château Palmer'),
('Château Pichon Baron'),
('Château Pichon Longueville'),
('Château Smith Haut Lafitte'),
('Clos Erasmus'),
('Clos Mogador');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Contadi Castaldi'),
('Conterno'),
('Contini'),
('Contino'),
('Cusumano'),
('CVNE'),
('Dal Forno Romano'),
('Dettori'),
('Didier Dagueneau'),
('Dom Pérignon');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Domaine de la Romanée-Conti'),
('Domaine de Montille'),
('Domaine des Baumard'),
('Domaine du Vieux Télégraphe'),
('Domaine Huet'),
('Domaine Leflaive'),
('Domaine Leroy'),
('Domaine Vacheron'),
('Domaine Weinbach'),
('Dominio de Pingus');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Donnafugata'),
('Dorigati'),
('Dr. Heger'),
('Dr. Loosen'),
('E. Guigal'),
('Egon Müller'),
('Elena Fucci'),
('Elena Walch'),
('Elio Altare'),
('Elisabetta Foradori');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Elvio Cogno'),
('Emidio Pepe'),
('Emilio Moro'),
('Fedrizzi'),
('Felline'),
('Ferrando'),
('Feudi di San Gregorio'),
('Feudi di San Marzano'),
('Feudo Arancio'),
('Firriato');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Fontodi'),
('Foradori'),
('Frescobaldi'),
('Friedrich Becker'),
('Fritz Haag'),
('Fuligni'),
('G.D. Vajra'),
('Gaja'),
('Garofoli'),
('Georg Breuer');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Giacomo Conterno'),
('Gianfranco Fino'),
('Gianfranco Soldera'),
('Gini'),
('Giuseppe Mascarello'),
('Giuseppe Rinaldi'),
('Graci'),
('Gravner'),
('Grifalco'),
('Guado al Tasso');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Guido Marsella'),
('Hacienda Monasterio'),
('Hauner'),
('Il Poggione'),
('Illuminati'),
('Inama'),
('Isole e Olena'),
('J. Hofstätter'),
('J.J. Prüm'),
('Jankara');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Jean-Louis Chave'),
('Jermann'),
('Josef Leitz'),
('Joseph Drouhin'),
('Josmeyer'),
('Karl H. Johner'),
('Keller'),
('Krug'),
('La Guardiense'),
('La Rioja Alta');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('La Scolca'),
('La Spinetta'),
('Leone de Castris'),
('Li Veli'),
('Livio Felluga'),
('Louis Jadot'),
('Louis Roederer'),
('Luciano Sandrone'),
('Lungarotti'),
('M. Chapoutier');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Maculan'),
('Malvirà'),
('Mar de Frades'),
('Marchesi di Barolo'),
('Marco Felluga'),
('Markus Molitor'),
('Marqués de Murrieta'),
('Marqués de Riscal'),
('Marquis d''Angerville'),
('Mas Martinet');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Mascarello'),
('Masciarelli'),
('Masi'),
('Masseria Li Veli'),
('Masseto'),
('Massolino'),
('Mastroberardino'),
('Michele Chiarlo'),
('Montevertine'),
('Muga');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Nicolas Joly'),
('Nikolaihof'),
('Ocone'),
('Ornellaia'),
('Pala'),
('Panizzi'),
('Paolo Bea'),
('Pascal Jolivet'),
('Passopisciaro'),
('Paternoster');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Patrick Piuze'),
('Paul Jaboulet Aîné'),
('Pazo de Señorans'),
('Pesquera'),
('Pieropan'),
('Pietracupa'),
('Pietradolce'),
('Pievalta'),
('Pio Cesare'),
('Planeta');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Poggio di Sotto'),
('Polvanera'),
('Pra'),
('Produttori del Barbaresco'),
('Prunotto'),
('Querciabella'),
('Quintarelli'),
('Quintodecimo'),
('R. López de Heredia'),
('Radikon');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Raveneau'),
('Renato Ratti'),
('Roagna'),
('Robert Weil'),
('Ronco del Gnemiz'),
('Salvatore Murana'),
('Salvioni'),
('Salwey'),
('San Felice'),
('Sandrone');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Sartarelli'),
('Sassicaia'),
('Schiopetto'),
('Schloss Johannisberg'),
('Sella & Mosca'),
('Suavia'),
('Tabarrini'),
('Taittinger'),
('Tasca d''Almerita'),
('Tedeschi');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Tenuta delle Terre Nere'),
('Tenuta San Guido'),
('Terras Gauda'),
('Terredora'),
('Terroir al Límit'),
('Tommasi'),
('Tormaresca'),
('Torre dei Beati'),
('Trimbach'),
('Umani Ronchi');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Valentini'),
('Vega Sicilia'),
('Veuve Clicquot'),
('Vie di Romans'),
('Vietti'),
('Villa Diamante'),
('Villa Matilde'),
('Villa Raiano'),
('Vincent Dauvissat'),
('Wagner-Stempel');
INSERT INTO tana_di_paolo.cantine (cantina) VALUES
('Walter Massa'),
('William Fèvre'),
('Wittmann'),
('Zenato'),
('Zind-Humbrecht');

INSERT INTO tana_di_paolo.invecchiamenti (invecchiamento,affinamento) VALUES
('Rovere francese',0.70),
('Acciaio',0.10),
('Rovere slavonia',0.60),
('Nessuno',0.00),
('Rovere americano',0.50),
('Anfora',0.30);

INSERT INTO tana_di_paolo.tipologie (tipologia) VALUES
('Bianco'),
('Passito'),
('Rosso'),
('Spumante');

INSERT INTO tana_di_paolo.vitigni (vitigno) VALUES
('Aglianico'),
('Albariño'),
('Arneis'),
('Barbera'),
('Cabernet Sauvignon, Cabernet Franc'),
('Cabernet Sauvignon, Merlot'),
('Cabernet Sauvignon, Merlot, Cabernet Franc'),
('Cabernet Sauvignon, Merlot, Petit Verdot'),
('Cabernet Sauvignon, Sangiovese'),
('Cannonau');
INSERT INTO tana_di_paolo.vitigni (vitigno) VALUES
('Cariñena'),
('Carricante'),
('Catarratto'),
('Chardonnay'),
('Chardonnay, Pinot Bianco'),
('Chardonnay, Pinot Nero'),
('Chardonnay, Pinot Nero, Pinot Bianco'),
('Chardonnay, Pinot Noir'),
('Chardonnay, Pinot Noir, Pinot Meunier'),
('Chenin Blanc');
INSERT INTO tana_di_paolo.vitigni (vitigno) VALUES
('Cortese'),
('Corvina, Rondinella'),
('Corvina, Rondinella, Molinara'),
('Corvina, Rondinella, Oseleta'),
('Dolcetto'),
('Dornfelder'),
('Erbaluce'),
('Falanghina'),
('Fiano'),
('Garganega');
INSERT INTO tana_di_paolo.vitigni (vitigno) VALUES
('Garganega, Trebbiano'),
('Garnacha'),
('Garnacha, Cariñena'),
('Garnacha, Cariñena, Syrah'),
('Garnacha, Syrah'),
('Gewürztraminer'),
('Glera'),
('Grauburgunder'),
('Greco'),
('Grenache, Mourvèdre, Syrah');
INSERT INTO tana_di_paolo.vitigni (vitigno) VALUES
('Grenache, Syrah, Mourvèdre'),
('Grillo'),
('Inzolia'),
('Lagrein'),
('Lemberger'),
('Malvasia'),
('Marsanne, Roussanne'),
('Mencía'),
('Merlot'),
('Merlot, Cabernet Sauvignon');
INSERT INTO tana_di_paolo.vitigni (vitigno) VALUES
('Montepulciano'),
('Müller-Thurgau'),
('Nascetta'),
('Nebbiolo'),
('Nerello Mascalese'),
('Nerello Mascalese, Nerello Cappuccio'),
('Nero d''Avola'),
('Pinot Grigio'),
('Pinot Nero, Chardonnay'),
('Pinot Noir');
INSERT INTO tana_di_paolo.vitigni (vitigno) VALUES
('Primitivo'),
('Ribolla Gialla'),
('Riesling'),
('Sagrantino'),
('Sangiovese'),
('Sangiovese, Cabernet Sauvignon'),
('Sangiovese, Malvasia Nera'),
('Sauvignon Blanc'),
('Sauvignon Blanc, Sémillon'),
('Sauvignon Blanc, Viognier');
INSERT INTO tana_di_paolo.vitigni (vitigno) VALUES
('Sémillon, Sauvignon Blanc'),
('Silvaner'),
('Spätburgunder'),
('Syrah'),
('Tempranillo'),
('Tempranillo, Cabernet Sauvignon'),
('Tempranillo, Garnacha'),
('Tempranillo, Graciano'),
('Tempranillo, Graciano, Garnacha'),
('Tempranillo, Merlot');
INSERT INTO tana_di_paolo.vitigni (vitigno) VALUES
('Teroldego'),
('Timorasso'),
('Trebbiano'),
('Trebbiano, Malvasia'),
('Verdicchio'),
('Vermentino'),
('Vermentino, Viognier'),
('Vernaccia'),
('Vespaiola'),
('Weissburgunder');
INSERT INTO tana_di_paolo.vitigni (vitigno) VALUES
('Zibibbo');

INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Aalto',45,3),
('Aalto PS',45,3),
('Aglianico',21,3),
('Aglianico del Vulture',21,3),
('Aglianico del Vulture Il Repertorio',21,3),
('Albariño',10,1),
('Alsace Grand Cru',45,1),
('Alsace Grand Cru Gewürztraminer',27,1),
('Alsace Grand Cru Riesling',45,1),
('Amarone della Valpolicella',25,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Amarone della Valpolicella Classico',25,3),
('Amarone della Valpolicella Classico Riserva',25,3),
('Arneis',23,1),
('Arneis Blangé',23,1),
('Arneis Roero',23,1),
('Barbaresco',43,3),
('Barbaresco Asili',43,3),
('Barbaresco Crichet Pajé',43,3),
('Barbaresco Gallina',43,3),
('Barbaresco Pajé',43,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Barbaresco Rabajà',43,3),
('Barbaresco Riserva',43,3),
('Barbaresco Sorì San Lorenzo',43,3),
('Barbaresco Sorì Tildìn',43,3),
('Barbera d''Alba',23,3),
('Barbera d''Alba Superiore',23,3),
('Barbera d''Alba Vigna Francia',23,3),
('Barbera d''Asti',23,3),
('Barbera d''Asti Bricco dell''Uccellone',23,3),
('Barbera d''Asti Superiore',23,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Barolo',43,3),
('Barolo Bricco Boschis',43,3),
('Barolo Brunate',43,3),
('Barolo Cannubi',43,3),
('Barolo Cerequio',43,3),
('Barolo Monfortino',43,3),
('Barolo Monprivato',43,3),
('Barolo Ravera',43,3),
('Barolo Riserva',43,3),
('Barolo Riserva Monfortino',43,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Barolo Rocche dell''Annunziata',43,3),
('Batàr',25,1),
('Bâtard-Montrachet',25,1),
('Bollinger La Grande Année',25,4),
('Brunello di Montalcino',45,3),
('Brunello di Montalcino Riserva',45,3),
('Cannonau',25,3),
('Cannonau di Sardegna',25,3),
('Cannonau di Sardegna Riserva',25,3),
('Carricante',25,1);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Catarratto',25,1),
('Cepparello',45,3),
('Chablis Grand Cru',25,1),
('Chablis Grand Cru Bougros',25,1),
('Chablis Grand Cru Les Clos',25,1),
('Chablis Grand Cru Les Preuses',25,1),
('Chablis Grand Cru Vaudésir',25,1),
('Chablis Premier Cru',25,1),
('Chablis Premier Cru Fourchaume',25,1),
('Chablis Premier Cru Montée de Tonnerre',25,1);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Chambertin',45,3),
('Champagne',25,4),
('Chardonnay',25,1),
('Château Carbonnieux Blanc',45,1),
('Château Haut-Brion',23,3),
('Château Haut-Brion Blanc',45,1),
('Château Lafite Rothschild',23,3),
('Château Latour',23,3),
('Château Lynch-Bages',23,3),
('Château Margaux',23,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Château Mouton Rothschild',23,3),
('Château Palmer',23,3),
('Château Pichon Baron',23,3),
('Château Pichon Longueville Comtesse de Lalande',23,3),
('Château Smith Haut Lafitte',23,3),
('Château Smith Haut Lafitte Blanc',45,1),
('Châteauneuf-du-Pape',27,3),
('Chenin Blanc',25,1),
('Chianti Classico Gran Selezione',45,3),
('Chianti Classico Riserva',45,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Clos de Vougeot',45,3),
('Clos Erasmus',27,3),
('Clos Mogador',27,3),
('Contino Reserva',45,3),
('Corton-Charlemagne',25,1),
('Côte-Rôtie',45,3),
('Côte-Rôtie La Landonne',45,3),
('Cristal',25,4),
('Cristiano',45,3),
('Custoza',27,1);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Dolcetto d''Alba',25,3),
('Dom Pérignon',25,4),
('Dornfelder',25,3),
('Erbaluce di Caluso',25,1),
('Etna Bianco',25,1),
('Etna Bianco Superiore',25,1),
('Etna Rosso',43,3),
('Etna Rosso Contrada Guardiola',43,3),
('Etna Rosso Contrada Rampante',43,3),
('Etna Rosso Contrada Santo Spirito',43,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Falanghina',25,1),
('Falanghina del Sannio',25,1),
('Fiano',27,1),
('Fiano di Avellino',27,1),
('Finca Dofí',27,3),
('Flaccianello della Pieve',45,3),
('Flor de Pingus',45,3),
('Franciacorta',25,4),
('Franciacorta Brut',25,4),
('Franciacorta Cuvée Annamaria Clementi',25,4);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Franciacorta Riserva',25,4),
('Franciacorta Rosé',43,4),
('Franciacorta Satèn',25,4),
('Garganega',27,1),
('Garnacha',27,3),
('Gavi dei Gavi',25,1),
('Gevrey-Chambertin',45,3),
('Gewürztraminer',27,1),
('Gewürztraminer Grand Cru',27,1),
('Gewürztraminer Sélection de Grains Nobles',27,1);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Gewürztraminer Vendange Tardive',27,1),
('Grauburgunder',27,1),
('Greco',27,1),
('Greco di Tufo',27,1),
('Grillo',27,1),
('Guidalberto',23,3),
('Hacienda Monasterio',45,3),
('Hacienda Monasterio Reserva',45,3),
('Hermitage',45,3),
('Hermitage Blanc',43,1);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Hermitage La Chapelle',45,3),
('I Sodi di San Niccolò',45,3),
('Inzolia',27,1),
('Krug Grande Cuvée',25,4),
('L''Ermita',27,3),
('La Tâche',45,3),
('Lagrein',43,3),
('Lagrein Riserva',43,3),
('Le Pergole Torte',45,3),
('Le Serre Nuove dell''Ornellaia',43,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Lemberger',43,3),
('Les Terrasses',27,3),
('Louis Roederer Cristal',25,4),
('Lugana',45,1),
('Malvasia delle Lipari',43,2),
('Mar de Frades',10,1),
('Mas Martinet',27,3),
('Masseto',43,3),
('Mencía',43,3),
('Merlot',43,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Meursault',25,1),
('Montefalco Sagrantino',45,3),
('Montepulciano d''Abruzzo',43,3),
('Montepulciano d''Abruzzo Riserva',43,3),
('Montrachet',25,1),
('Müller-Thurgau',43,1),
('Nascetta',43,1),
('Nebbiolo d''Alba',43,3),
('Nebbiolo Langhe',43,3),
('Nero d''Avola',43,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Occhio di Pernice',45,2),
('Ornellaia',23,3),
('Ornellaia Bianco',45,1),
('Passito di Pantelleria',91,2),
('Passito di Pantelleria Ben Ryé',91,2),
('Pavillon Blanc du Château Margaux',45,1),
('Pavillon Rouge du Château Margaux',23,3),
('Pazo de Señorans',10,1),
('Pesquera',45,3),
('Pesquera Gran Reserva',45,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Pesquera Reserva',45,3),
('Pingus',45,3),
('Pinot Grigio',43,1),
('Pinot Grigio Collio',43,1),
('Pinot Grigio Friuli Colli Orientali',43,1),
('Pinot Noir',45,3),
('Pomino Bianco',25,1),
('Pommard',45,3),
('Pommard Les Rugiens',45,3),
('Pouilly-Fuissé',25,1);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Pouilly-Fumé',45,1),
('Pouilly-Fumé Silex',45,1),
('Primitivo',45,3),
('Primitivo di Manduria',45,3),
('Primitivo di Manduria Es',45,3),
('Primitivo di Manduria Riserva',45,3),
('Primitivo di Manduria Sessantanni',45,3),
('Priorat',27,3),
('Prosecco',27,4),
('Puligny-Montrachet',25,1);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Recioto della Valpolicella',25,2),
('Recioto della Valpolicella Classico',25,2),
('Recioto di Soave',27,2),
('Recioto di Soave Classico',27,2),
('Ribera del Duero',45,3),
('Ribolla Gialla',45,1),
('Richebourg',45,3),
('Riesling',45,1),
('Riesling Auslese',45,1),
('Riesling Beerenauslese',45,1);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Riesling Eiswein',45,1),
('Riesling Grosses Gewächs',45,1),
('Riesling Kabinett',45,1),
('Riesling Smaragd',45,1),
('Riesling Spätlese',45,1),
('Riesling Trockenbeerenauslese',45,1),
('Rioja Gran Reserva',45,3),
('Rioja Gran Reserva 904',45,3),
('Rioja Reserva',45,3),
('Rioja Reserva Viña Ardanza',45,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Roero Arneis',23,1),
('Sagrantino',45,3),
('Sagrantino di Montefalco',45,3),
('Sagrantino di Montefalco 25 Anni',45,3),
('Sagrantino di Montefalco Collepiano',45,3),
('Sancerre',45,1),
('Sancerre Les Culs de Beaujeu',45,1),
('Sassicaia',23,3),
('Sauvignon Blanc',45,1),
('Savennières',25,1);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Savennières Coulée de Serrant',25,1),
('Savennières Roche aux Moines',25,1),
('Silvaner',45,1),
('Soave',27,1),
('Soave Classico',27,1),
('Soave Classico La Rocca',27,1),
('Soave Classico Monte Grande',27,1),
('Solaia',23,3),
('Spätburgunder',45,3),
('Syrah',45,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Taittinger Comtes de Champagne',25,4),
('Taurasi',21,3),
('Taurasi Radici',21,3),
('Taurasi Riserva',21,3),
('Tempranillo',45,3),
('Tenuta San Guido Sassicaia',23,3),
('Teroldego',45,3),
('Teroldego Rotaliano',45,3),
('Teroldego Rotaliano Granato',45,3),
('Teroldego Rotaliano Riserva',45,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Terrasses',27,3),
('Terroir al Límit',27,3),
('Terroir al Límit Arbossar',25,3),
('Tignanello',45,3),
('Timorasso',45,1),
('Torcolato',91,2),
('Trebbiano d''Abruzzo',45,1),
('Valpolicella Ripasso',25,3),
('Vega Sicilia Único',45,3),
('Vega Sicilia Valbuena 5°',45,3);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Verdicchio',91,1),
('Verdicchio dei Castelli di Jesi',91,1),
('Verdicchio dei Castelli di Jesi Classico Superiore',91,1),
('Verdicchio dei Castelli di Jesi Riserva',91,1),
('Verdicchio Riserva',91,1),
('Vermentino',91,1),
('Vermentino di Bolgheri',91,1),
('Vermentino di Gallura',91,1),
('Vermentino di Gallura Superiore',91,1),
('Vermentino di Sardegna',91,1);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Vernaccia di San Gimignano',91,1),
('Veuve Clicquot',25,4),
('Veuve Clicquot La Grande Dame',25,4),
('Vin Santo del Chianti Classico',91,2),
('Vistamare',91,1),
('Volnay',45,3),
('Volnay Clos des Ducs',45,3),
('Vouvray',25,1),
('Vouvray Demi-Sec',25,1),
('Vouvray Sec',25,1);
INSERT INTO tana_di_paolo.vini (nome,vitigno,tipologia) VALUES
('Weissburgunder',91,1);

INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(31,'fruttati: ciliegia, mora, prugna; speziati: pepe nero, tabacco; legnosi: vaniglia, caffè',61,1,14.20,2016,25,1.20,7.80,0,4.50,1.20,0.30,0.80,2100,0.46,12.73,20.37,'34.jpg',22,3),
(224,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi, fieno',237,2,12.50,2019,15,3.20,5.60,0,5.80,2.30,0.50,0.40,180,0.82,8.35,13.37,'17.jpg',115,3),
(68,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',61,1,13.80,2010,40,1.80,8.20,0,5.20,0.80,0.20,1.50,2400,0.62,8.54,13.67,'17.jpg',84,0),
(189,'fruttati: mela verde, pera, limone; speziati: fiori bianchi; yeast: lievito',211,2,11.50,2021,40,8.50,5.20,0,6.20,2.80,0.60,0.30,120,0.56,14.27,22.83,'8.jpg',187,0),
(45,'fruttati: ciliegia, prugna, mora; speziati: liquirizia, tabacco; legnosi: vaniglia, tostato',61,3,14.50,2015,25,1.50,8.50,0,4.80,0.90,0.20,1.80,2500,0.92,14.04,22.46,'35.jpg',171,3),
(198,'fruttati: mela verde, pesca, limone; speziati: fiori di acacia',156,4,11.50,2020,30,5.80,5.50,0,6.50,3.20,0.70,0.30,150,0.75,11.65,18.63,'10.jpg',9,1),
(10,'fruttati: ciliegia, prugna, mora; speziati: cannella, liquirizia; legnosi: cioccolato, tostato',7,1,15.00,2017,35,3.80,9.50,0,3.80,0.50,0.20,2.00,2200,0.49,9.34,14.94,'13.jpg',47,3),
(53,'fruttati: mela verde, agrumi, pera; legnosi: burro, vaniglia; yeast: brioche',156,1,13.50,2018,25,2.20,6.80,0,6.20,2.50,0.40,0.80,220,0.41,15.40,24.64,'15.jpg',174,2),
(160,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',237,5,13.80,2019,30,2.00,7.50,0,4.20,1.50,0.30,1.20,1800,0.76,9.77,15.64,'34.jpg',122,0),
(6,'fruttati: pesca, agrumi, ananas; speziati: fiori bianchi',237,2,12.80,2021,35,3.50,5.80,0,6.50,2.80,0.60,0.40,180,0.73,12.93,20.70,'13.jpg',144,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(39,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: caffè, cioccolato',237,1,14.50,2015,40,1.00,8.20,0,4.50,0.80,0.20,1.80,2600,0.75,9.13,14.61,'31.jpg',150,0),
(256,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',7,2,13.00,2020,40,2.80,6.00,0,5.80,2.50,0.50,0.50,150,0.41,12.76,20.41,'3.jpg',105,2),
(80,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',7,1,13.50,2018,40,1.50,7.20,0,4.80,1.20,0.30,1.50,1900,0.96,14.31,22.90,'1.jpg',99,2),
(118,'fruttati: pesca, litchi, agrumi; speziati: fiori bianchi, zenzero',237,4,13.50,2019,15,4.50,6.50,0,5.20,2.00,0.40,0.60,120,0.91,11.92,19.07,'2.jpg',24,0),
(248,'fruttati: ciliegia, prugna, mora; speziati: cannella; legnosi: vaniglia',237,3,14.00,2018,35,2.50,8.00,0,4.00,0.70,0.20,1.80,1800,0.79,9.04,14.46,'18.jpg',37,3),
(95,'fruttati: agrumi, pesca, mela verde; speziati: fiori bianchi',211,2,12.80,2020,10,2.20,5.80,0,6.00,2.80,0.50,0.40,180,0.50,9.78,15.65,'3.jpg',153,1),
(16,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',156,1,14.20,2017,10,1.20,8.00,0,4.50,1.00,0.20,1.50,2200,0.78,13.79,22.07,'21.jpg',139,2),
(180,'fruttati: mela verde, pera, agrumi; legnosi: burro, vaniglia; yeast: brioche',211,1,13.20,2019,35,2.50,6.20,0,5.80,2.20,0.40,0.80,200,0.60,10.58,16.93,'34.jpg',107,3),
(218,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',237,1,14.00,2016,25,1.50,8.50,0,4.80,0.90,0.20,1.60,2300,0.60,10.65,17.04,'15.jpg',167,2),
(125,'fruttati: agrumi, pesca, mela verde; speziati: fiori bianchi',156,2,12.50,2021,10,3.00,5.50,0,6.20,2.50,0.50,0.30,150,0.61,15.41,24.65,'22.jpg',1,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(183,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia',237,5,14.50,2019,35,2.80,8.20,0,4.00,1.20,0.30,1.50,1800,0.49,11.15,17.84,'27.jpg',197,1),
(173,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',211,2,13.00,2020,25,2.50,5.80,0,5.50,2.20,0.40,0.50,160,0.70,15.97,25.56,'3.jpg',94,3),
(46,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: caffè, cioccolato, tostato',61,1,14.80,2015,20,1.20,8.80,0,4.50,0.80,0.20,2.00,2700,0.41,10.21,16.34,'14.jpg',22,3),
(219,'fruttati: agrumi, pompelmo, pesca; speziati: fiori bianchi',237,2,12.80,2021,20,2.20,5.50,0,6.50,3.00,0.60,0.30,140,0.75,9.56,15.30,'33.jpg',92,1),
(25,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',61,1,13.80,2019,35,2.00,7.50,0,5.00,1.50,0.30,1.20,1700,0.84,8.64,13.83,'3.jpg',53,0),
(144,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',245,2,12.50,2021,30,3.20,5.50,0,6.00,2.50,0.50,0.40,150,0.82,8.77,14.03,'35.jpg',6,0),
(3,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, caffè',211,1,14.00,2017,40,1.50,8.00,0,4.80,1.00,0.20,1.50,2200,0.51,14.81,23.70,'20.jpg',75,3),
(205,'fruttati: pesca, mela verde, agrumi; speziati: fiori di acacia',237,4,11.00,2020,30,8.50,6.00,0,6.80,3.50,0.70,0.20,120,0.45,8.08,12.94,'34.jpg',177,2),
(153,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',211,3,13.50,2018,10,2.20,7.50,0,4.50,1.20,0.30,1.50,1800,0.57,12.27,19.64,'32.jpg',11,0),
(13,'fruttati: pera, pesca, mela verde; speziati: fiori bianchi',61,2,13.00,2020,35,2.50,5.80,0,5.80,2.50,0.50,0.40,160,0.42,12.91,20.66,'23.jpg',35,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(235,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, tostato',211,5,14.00,2017,40,1.80,7.80,0,4.20,1.00,0.20,1.80,2000,0.45,12.83,20.52,'32.jpg',47,1),
(63,'fruttati: mela verde, pera, agrumi; legnosi: burro, vaniglia; yeast: brioche',61,1,13.50,2019,40,2.00,6.50,0,5.50,2.00,0.40,0.80,180,0.58,11.86,18.98,'21.jpg',5,0),
(47,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',237,1,14.20,2018,15,2.00,8.00,0,4.00,1.20,0.30,1.50,1900,0.85,10.72,17.16,'2.jpg',90,1),
(103,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi, fieno',156,2,13.00,2020,10,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.95,13.95,22.32,'35.jpg',193,3),
(91,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',237,3,13.50,2020,40,2.20,7.00,0,4.80,1.50,0.30,1.00,1600,0.50,9.35,14.97,'15.jpg',156,2),
(251,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,12.80,2021,20,2.80,5.50,0,6.20,2.80,0.50,0.30,140,0.82,12.79,20.47,'11.jpg',74,0),
(230,'fruttati: mora, prugna, ribes nero; speziati: pepe nero, liquirizia; legnosi: caffè, tostato',156,1,14.50,2017,35,1.50,8.50,0,4.50,0.80,0.20,1.80,2400,0.65,12.69,20.30,'9.jpg',82,2),
(123,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,13.00,2020,25,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.51,14.90,23.84,'30.jpg',14,0),
(159,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia',237,1,14.00,2019,25,1.80,7.80,0,4.50,1.20,0.30,1.50,2000,0.52,11.40,18.25,'8.jpg',36,2),
(101,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,12.80,2021,35,3.00,5.50,0,6.20,2.80,0.50,0.30,140,0.92,14.06,22.50,'9.jpg',197,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(150,'fruttati: mora, prugna, ribes nero; speziati: tabacco; legnosi: cedro, cioccolato',61,1,14.20,2016,15,1.50,8.20,0,4.80,0.90,0.20,1.60,2200,0.57,12.95,20.73,'15.jpg',28,3),
(156,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',7,2,12.00,2021,20,3.50,5.20,0,6.50,3.00,0.60,0.20,120,0.49,13.16,21.05,'3.jpg',141,1),
(137,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',156,1,13.80,2019,25,2.00,7.50,0,4.50,1.20,0.30,1.50,1800,0.62,8.68,13.88,'25.jpg',98,2),
(196,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',211,2,13.00,2020,15,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.89,12.43,19.88,'15.jpg',196,1),
(115,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',7,1,14.50,2018,10,1.80,8.00,0,4.20,1.00,0.20,1.80,2100,0.89,15.42,24.67,'17.jpg',157,3),
(78,'fruttati: pesca, mela verde, agrumi; speziati: fiori bianchi, fieno',156,2,13.00,2019,20,3.50,6.00,0,6.20,2.50,0.50,0.50,160,0.43,9.66,15.45,'19.jpg',28,1),
(212,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, cioccolato',7,1,15.00,2016,25,1.20,9.00,0,4.00,0.70,0.20,2.00,2800,0.89,8.28,13.25,'16.jpg',150,1),
(50,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',237,2,12.80,2020,35,2.20,5.50,0,6.50,2.80,0.50,0.30,140,0.68,13.80,22.08,'8.jpg',192,3),
(237,'fruttati: mora, ciliegia, prugna; speziati: pepe nero; legnosi: vaniglia',156,1,13.50,2019,25,1.80,7.50,0,4.50,1.20,0.30,1.50,1900,0.70,10.29,16.46,'3.jpg',3,3),
(133,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',61,2,12.50,2021,35,2.80,5.50,0,6.00,2.50,0.50,0.40,130,0.69,10.90,17.44,'1.jpg',137,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(149,'fruttati: mora, ciliegia, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',156,1,14.00,2018,40,1.80,7.80,0,4.50,1.00,0.20,1.50,2000,0.59,13.29,21.26,'30.jpg',166,0),
(223,'fruttati: mela verde, pera, agrumi; speziati: fiori bianchi',245,2,12.50,2020,25,2.50,5.50,0,6.20,2.80,0.50,0.30,140,0.99,10.07,16.12,'27.jpg',40,1),
(162,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',211,1,14.50,2017,30,1.50,8.50,0,4.80,0.90,0.20,1.80,2400,0.90,10.96,17.54,'22.jpg',2,1),
(83,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, tostato',61,1,14.80,2016,20,1.20,8.80,0,4.20,0.80,0.20,2.00,2500,0.77,10.44,16.71,'30.jpg',149,3),
(176,'fruttati: ciliegia, mora, fragola; speziati: pepe nero; legnosi: vaniglia, cedro',156,1,13.50,2018,15,1.80,7.50,0,5.00,1.20,0.30,1.50,1800,0.76,14.07,22.52,'31.jpg',96,0),
(62,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane',61,4,12.00,2015,10,8.00,5.50,0,6.50,2.50,0.60,0.50,200,0.80,11.01,17.62,'14.jpg',34,3),
(264,'fruttati: albicocca secca, miele, frutta candita; speziati: zafferano; legnosi: caramello',7,1,15.50,2012,30,85.00,12.00,1,4.50,1.00,0.40,1.20,350,0.43,15.61,24.97,'23.jpg',134,2),
(225,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,12.80,2020,10,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.57,12.34,19.74,'8.jpg',49,1),
(34,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',211,1,14.50,2016,25,1.20,8.50,0,4.50,0.80,0.20,1.80,2600,0.87,11.41,18.26,'6.jpg',162,2),
(199,'fruttati: pesca, mela verde, albicocca; speziati: fiori di acacia; legnosi: miele',211,4,9.50,2018,10,45.00,7.50,1,6.80,3.00,0.70,0.20,100,0.93,12.53,20.05,'15.jpg',19,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(244,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia, cioccolato',7,1,14.00,2018,10,1.50,8.00,0,4.80,1.00,0.20,1.60,2200,0.42,13.36,21.37,'27.jpg',68,2),
(58,'fruttati: mela verde, agrumi, pera; legnosi: burro, vaniglia; yeast: brioche',211,1,13.00,2019,40,2.00,6.00,0,6.20,2.50,0.40,0.60,180,0.96,11.74,18.78,'10.jpg',21,1),
(11,'fruttati: ciliegia, prugna, mora; speziati: cannella, liquirizia; legnosi: cioccolato, tostato',61,1,15.00,2015,25,3.50,9.50,0,3.80,0.50,0.20,2.20,2300,0.64,11.81,18.89,'11.jpg',161,2),
(260,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',7,2,13.00,2021,40,2.80,5.80,0,6.00,2.50,0.50,0.40,150,0.87,14.79,23.67,'31.jpg',198,3),
(45,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',61,1,14.50,2016,15,1.20,8.50,0,4.50,0.80,0.20,1.80,2500,0.75,8.91,14.26,'12.jpg',5,3),
(118,'fruttati: litchi, pesca, agrumi; speziati: fiori bianchi, zenzero',245,4,13.50,2019,40,5.00,6.50,0,5.00,2.00,0.40,0.60,120,0.78,13.96,22.33,'5.jpg',195,2),
(22,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',61,1,14.20,2015,25,1.00,8.20,0,4.50,0.80,0.20,1.80,2400,0.46,12.21,19.54,'22.jpg',144,3),
(95,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',237,2,12.80,2020,20,2.20,5.80,0,6.20,2.80,0.50,0.40,160,0.81,9.65,15.45,'30.jpg',87,3),
(79,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',61,1,14.00,2017,10,1.50,8.00,0,4.80,1.00,0.20,1.60,2100,0.90,12.76,20.41,'13.jpg',136,0),
(181,'fruttati: agrumi, pompelmo, pesca; speziati: fiori bianchi',156,2,13.20,2019,15,2.00,6.00,0,6.50,2.80,0.50,0.40,150,1.00,12.74,20.38,'27.jpg',146,2);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(184,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia',156,5,14.80,2019,20,2.50,8.50,0,4.00,1.00,0.30,1.80,1900,0.78,15.07,24.11,'6.jpg',119,2),
(173,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',237,2,13.50,2020,20,2.20,6.00,0,5.50,2.20,0.40,0.50,160,0.42,11.66,18.66,'3.jpg',1,0),
(249,'fruttati: mora, prugna, ribes nero; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato, tostato',237,1,14.50,2012,15,1.20,8.80,0,4.50,0.70,0.20,2.00,2700,0.43,12.74,20.38,'14.jpg',37,2),
(219,'fruttati: agrumi, pompelmo, pesca; speziati: fiori bianchi',156,2,13.00,2020,35,2.00,5.80,0,6.50,3.00,0.60,0.30,140,0.85,8.93,14.30,'27.jpg',147,0),
(28,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',237,1,14.00,2019,15,2.20,7.80,0,5.00,1.50,0.30,1.20,1700,0.57,14.01,22.41,'24.jpg',162,0),
(144,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',245,2,12.50,2021,40,3.00,5.50,0,6.00,2.50,0.50,0.40,150,0.52,15.22,24.35,'19.jpg',144,1),
(232,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, caffè',211,1,14.20,2016,30,1.50,8.20,0,4.80,0.90,0.20,1.60,2300,0.48,10.40,16.64,'22.jpg',141,1),
(203,'fruttati: pesca, mela verde, agrumi; speziati: fiori di acacia; legnosi: miele',156,4,8.50,2020,15,35.00,6.50,1,7.00,3.50,0.80,0.20,100,0.61,8.83,14.13,'14.jpg',185,1),
(154,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',156,3,13.80,2015,35,1.80,8.00,0,4.50,1.00,0.20,1.80,2100,1.00,8.64,13.83,'14.jpg',84,1),
(13,'fruttati: pera, pesca, mela verde; speziati: fiori bianchi',61,2,13.00,2020,40,2.50,5.80,0,5.80,2.50,0.50,0.40,160,0.42,13.94,22.30,'11.jpg',108,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(207,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, tostato',211,5,14.00,2014,10,1.50,8.00,0,4.20,0.80,0.20,2.00,2200,0.74,8.71,13.94,'13.jpg',54,1),
(108,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane',7,4,12.50,2017,25,6.00,5.50,0,6.00,2.00,0.50,0.80,180,0.85,8.28,13.25,'28.jpg',14,1),
(49,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia, tostato',237,1,14.50,2016,40,1.80,8.20,0,4.00,1.00,0.20,1.80,2100,0.62,12.91,20.65,'7.jpg',2,1),
(104,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi, fieno',156,2,13.20,2020,25,2.20,5.80,0,6.00,2.50,0.50,0.40,150,0.94,12.94,20.71,'34.jpg',52,2),
(91,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',61,3,13.50,2020,10,2.00,7.00,0,4.80,1.50,0.30,1.00,1600,0.44,15.94,25.50,'6.jpg',181,0),
(252,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,13.00,2021,15,2.50,5.50,0,6.20,2.80,0.50,0.30,140,0.90,13.23,21.17,'4.jpg',155,3),
(86,'fruttati: mora, prugna, ribes nero; speziati: pepe nero, liquirizia; legnosi: caffè, tostato',156,1,14.50,2016,40,1.20,8.50,0,4.50,0.80,0.20,1.80,2400,0.94,9.98,15.97,'8.jpg',34,2),
(124,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,13.20,2020,30,2.20,5.80,0,6.00,2.50,0.50,0.40,150,0.42,12.83,20.52,'8.jpg',53,2),
(158,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia',237,1,14.00,2019,20,1.80,7.80,0,4.50,1.20,0.30,1.50,2000,0.41,12.08,19.33,'15.jpg',14,0),
(102,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,13.00,2020,30,2.80,5.50,0,6.20,2.80,0.50,0.30,140,0.51,8.96,14.33,'16.jpg',138,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(70,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',61,1,13.80,2015,35,1.50,8.50,0,4.80,0.80,0.20,1.80,2500,0.90,15.24,24.39,'28.jpg',148,3),
(156,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',61,2,12.20,2021,15,3.20,5.20,0,6.50,3.00,0.60,0.20,120,0.58,13.31,21.30,'18.jpg',14,0),
(137,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',211,1,13.80,2019,30,2.00,7.50,0,4.50,1.20,0.30,1.50,1800,0.73,8.96,14.34,'22.jpg',7,0),
(196,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,13.00,2020,15,2.50,5.80,0,6.00,2.50,0.50,0.40,150,1.00,12.86,20.57,'18.jpg',72,0),
(188,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',7,1,14.80,2017,25,1.50,8.50,0,4.00,0.80,0.20,2.00,2300,0.70,11.97,19.15,'9.jpg',190,1),
(268,'fruttati: pesca, mela verde, agrumi; speziati: fiori bianchi, fieno',156,2,12.50,2019,40,4.00,6.00,0,6.20,2.50,0.50,0.50,160,0.46,14.92,23.86,'25.jpg',99,2),
(152,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, cioccolato',7,1,15.00,2015,15,1.00,9.00,0,4.00,0.70,0.20,2.00,2800,0.52,15.22,24.36,'29.jpg',89,1),
(95,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',237,2,12.80,2020,35,2.20,5.50,0,6.50,2.80,0.50,0.30,140,0.97,10.14,16.22,'29.jpg',14,0),
(238,'fruttati: mora, ciliegia, prugna; speziati: pepe nero; legnosi: vaniglia',156,1,13.50,2019,20,1.80,7.50,0,4.50,1.20,0.30,1.50,1900,0.52,11.24,17.99,'25.jpg',29,0),
(133,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',156,2,12.50,2021,15,2.80,5.50,0,6.00,2.50,0.50,0.40,130,0.97,12.92,20.68,'28.jpg',66,3);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(195,'fruttati: mora, ciliegia, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',156,1,14.20,2018,40,1.50,8.00,0,4.50,1.00,0.20,1.50,2100,0.58,12.67,20.27,'4.jpg',114,3),
(122,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',7,2,13.00,2020,30,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.54,12.74,20.38,'25.jpg',152,2),
(228,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',7,1,14.50,2016,20,1.20,8.50,0,4.80,0.80,0.20,1.80,2500,0.79,9.36,14.98,'30.jpg',105,3),
(82,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, tostato',61,1,14.80,2015,20,1.00,8.80,0,4.00,0.70,0.20,2.00,2600,0.54,14.73,23.57,'16.jpg',84,0),
(89,'fruttati: ciliegia, fragola, mora; speziati: pepe nero; legnosi: vaniglia, cedro',156,1,13.80,2017,15,1.50,7.80,0,5.00,1.00,0.20,1.50,1900,0.63,8.98,14.37,'17.jpg',155,1),
(88,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane',211,4,12.00,2013,30,8.50,5.50,0,6.50,2.50,0.60,0.50,200,0.94,12.72,20.35,'14.jpg',122,1),
(164,'fruttati: albicocca secca, fico secco, miele; speziati: zafferano; legnosi: caramello',156,4,14.50,2018,30,120.00,12.50,1,4.00,1.00,0.40,1.00,300,0.83,13.32,21.31,'33.jpg',68,3),
(90,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',211,2,12.50,2021,25,2.80,5.50,0,6.00,2.50,0.50,0.40,150,0.99,9.92,15.87,'21.jpg',124,0),
(36,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè, cioccolato',61,1,14.80,2013,15,1.00,8.80,0,4.50,0.70,0.20,2.00,2700,0.85,13.61,21.77,'30.jpg',10,0),
(206,'fruttati: albicocca secca, miele, frutta candita; speziati: zafferano; legnosi: miele',156,4,8.00,2018,30,150.00,10.00,1,6.00,2.00,0.60,0.20,80,0.67,12.96,20.73,'13.jpg',151,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(106,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia, cioccolato',156,1,14.50,2017,25,1.20,8.50,0,4.80,0.90,0.20,1.80,2400,0.93,9.25,14.81,'17.jpg',52,3),
(151,'fruttati: mela verde, pera, agrumi; legnosi: burro, vaniglia; yeast: brioche',156,1,13.50,2018,10,2.00,6.50,0,5.80,2.20,0.40,0.80,180,0.40,13.99,22.38,'32.jpg',28,1),
(11,'fruttati: ciliegia, prugna, mora; speziati: cannella, liquirizia; legnosi: cioccolato, tostato, caffè',61,1,16.00,2013,25,3.80,10.00,0,3.50,0.40,0.20,2.50,2500,0.80,12.73,20.36,'22.jpg',7,1),
(258,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',61,2,13.50,2020,10,2.50,6.00,0,6.00,2.50,0.50,0.40,160,0.99,11.28,18.05,'10.jpg',140,2),
(46,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè, cioccolato',61,1,14.50,2013,15,1.00,8.80,0,4.50,0.70,0.20,2.00,2600,0.58,8.40,13.43,'34.jpg',95,3),
(7,'fruttati: pesca, mela verde, agrumi; speziati: fiori bianchi; legnosi: miele',237,4,13.80,2018,10,3.50,6.50,0,5.50,2.00,0.40,0.60,140,0.69,15.21,24.34,'31.jpg',39,3),
(17,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',156,1,14.50,2016,35,1.20,8.50,0,4.50,0.80,0.20,1.80,2400,0.82,15.31,24.50,'35.jpg',103,0),
(97,'fruttati: ciliegia, mora, fragola; speziati: pepe nero; legnosi: vaniglia',211,1,13.80,2019,40,1.80,7.50,0,4.80,1.20,0.30,1.50,1900,0.98,12.41,19.85,'4.jpg',122,2),
(80,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',156,1,14.00,2018,30,1.50,8.00,0,4.80,1.00,0.20,1.60,2100,0.66,8.12,12.99,'9.jpg',146,0),
(216,'fruttati: agrumi, pompelmo, pesca; speziati: fiori bianchi',237,2,13.00,2020,30,2.00,5.80,0,6.50,3.00,0.60,0.30,140,0.48,8.23,13.17,'8.jpg',80,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(186,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, cioccolato',237,5,15.00,2017,30,2.20,9.00,0,3.80,0.80,0.30,2.00,2100,0.60,14.10,22.55,'16.jpg',33,1),
(173,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',211,2,13.20,2020,15,2.50,5.80,0,5.50,2.20,0.40,0.50,160,0.85,13.67,21.86,'35.jpg',131,0),
(172,'fruttati: mora, prugna, ribes nero; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato, tostato',156,1,14.80,2015,35,1.00,9.00,0,4.20,0.70,0.20,2.00,2800,0.80,11.67,18.67,'19.jpg',151,1),
(181,'fruttati: agrumi, pompelmo, pesca; speziati: fiori bianchi',156,2,13.00,2020,15,2.00,5.80,0,6.50,3.00,0.60,0.30,140,0.65,9.18,14.68,'6.jpg',7,0),
(26,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',237,1,14.20,2018,25,2.00,8.00,0,5.00,1.20,0.30,1.50,1800,0.85,11.82,18.91,'24.jpg',72,1),
(225,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,12.80,2020,20,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.97,15.44,24.71,'21.jpg',168,3),
(234,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, caffè',156,1,14.50,2015,15,1.20,8.50,0,4.50,0.80,0.20,1.80,2500,0.91,15.67,25.07,'9.jpg',90,1),
(202,'fruttati: pesca, mela verde, agrumi; speziati: fiori di acacia',237,4,13.00,2019,20,6.50,6.00,0,6.50,2.80,0.60,0.30,130,0.58,15.47,24.76,'4.jpg',65,3),
(153,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',237,3,13.50,2016,30,1.80,7.80,0,4.50,1.00,0.20,1.80,2000,0.48,9.27,14.84,'14.jpg',165,2),
(15,'fruttati: pera, pesca, mela verde; speziati: fiori bianchi',61,2,13.20,2020,35,2.20,5.80,0,5.80,2.50,0.50,0.40,160,0.87,13.23,21.17,'35.jpg',100,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(209,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, tostato',61,5,14.00,2016,15,1.50,8.00,0,4.20,0.90,0.20,1.80,2100,0.71,11.22,17.95,'13.jpg',135,1),
(113,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane',61,4,12.50,2018,25,6.50,5.50,0,6.00,2.00,0.50,0.80,160,0.64,11.44,18.30,'26.jpg',81,3),
(48,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',7,1,14.00,2018,20,2.00,7.80,0,4.20,1.20,0.30,1.50,1900,0.43,12.97,20.75,'31.jpg',60,2),
(104,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi, fieno',237,2,13.50,2019,15,2.00,6.00,0,6.00,2.50,0.50,0.40,150,0.75,11.62,18.59,'4.jpg',132,0),
(91,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',61,3,13.50,2020,10,2.00,7.00,0,4.80,1.50,0.30,1.00,1600,0.70,8.06,12.89,'14.jpg',163,2),
(255,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,13.50,2019,20,2.20,6.00,0,6.00,2.50,0.50,0.40,160,0.41,15.51,24.82,'1.jpg',128,1),
(77,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',61,1,14.50,2017,30,1.50,8.50,0,4.20,0.80,0.20,1.80,2300,0.62,8.73,13.97,'30.jpg',156,2),
(124,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',211,2,13.00,2020,10,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.99,9.11,14.58,'13.jpg',186,3),
(159,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia',156,1,14.00,2019,40,1.80,7.80,0,4.50,1.20,0.30,1.50,2000,0.60,10.88,17.41,'24.jpg',23,2),
(101,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',156,2,12.80,2021,20,2.80,5.50,0,6.20,2.80,0.50,0.30,140,0.69,9.38,15.00,'31.jpg',24,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(67,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',61,1,13.50,2015,35,1.50,8.50,0,4.80,0.80,0.20,1.80,2500,0.78,15.33,24.53,'19.jpg',64,0),
(271,'fruttati: mela verde, pera, pesca; speziati: fiori bianchi',7,2,13.00,2020,15,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.79,12.64,20.22,'12.jpg',125,3),
(138,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia, caffè',156,1,14.00,2018,15,1.80,8.00,0,4.50,1.00,0.20,1.80,2000,0.71,14.75,23.61,'16.jpg',59,3),
(196,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',211,2,13.20,2020,40,2.20,5.80,0,6.00,2.50,0.50,0.40,150,0.52,14.59,23.35,'3.jpg',15,1),
(105,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',7,1,14.50,2017,20,1.50,8.50,0,4.00,0.80,0.20,2.00,2300,0.99,11.35,18.17,'33.jpg',92,1),
(220,'fruttati: pesca, mela verde, agrumi; speziati: fiori bianchi, fieno',156,2,13.50,2018,15,2.00,6.20,0,6.00,2.20,0.40,0.60,170,0.51,11.44,18.31,'5.jpg',187,0),
(213,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, cioccolato',237,1,15.00,2016,20,1.00,9.00,0,4.00,0.70,0.20,2.00,2800,0.92,12.77,20.43,'21.jpg',21,3),
(50,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',7,2,12.80,2020,30,2.20,5.50,0,6.50,2.80,0.50,0.30,140,0.56,13.11,20.97,'29.jpg',174,2),
(240,'fruttati: mora, ciliegia, prugna; speziati: pepe nero; legnosi: vaniglia, caffè',156,1,14.00,2017,20,1.50,8.00,0,4.50,1.00,0.20,1.80,2100,0.68,14.72,23.54,'1.jpg',151,2),
(51,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',61,2,12.50,2021,30,2.80,5.50,0,6.00,2.50,0.50,0.40,130,0.63,8.74,13.99,'6.jpg',150,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(2,'fruttati: mora, ciliegia, prugna; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato, cioccolato',98,1,14.50,2016,30,1.20,8.50,0,4.20,0.80,0.20,1.80,2400,0.65,9.56,15.30,'32.jpg',0,1),
(205,'fruttati: pesca, mela verde, albicocca; speziati: fiori di acacia; legnosi: miele',211,4,8.50,2019,10,40.00,7.00,1,6.80,3.00,0.70,0.20,110,0.41,12.07,19.32,'10.jpg',198,1),
(139,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia, cioccolato',211,1,14.00,2016,10,1.20,8.20,0,4.80,0.90,0.20,1.80,2300,0.43,15.83,25.32,'21.jpg',82,1),
(142,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia, tostato',7,1,14.50,2018,20,1.50,8.00,0,4.20,1.00,0.20,1.80,2100,0.57,10.87,17.39,'12.jpg',198,0),
(136,'fruttati: ciliegia, fragola, mora; speziati: pepe nero; legnosi: vaniglia, cedro',156,1,13.80,2016,30,1.50,7.80,0,5.00,1.00,0.20,1.50,1900,0.76,14.84,23.75,'18.jpg',61,0),
(134,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane, pasticceria',211,4,12.00,2012,30,8.00,5.50,0,6.50,2.50,0.60,0.50,200,0.87,10.48,16.76,'7.jpg',34,0),
(145,'fruttati: albicocca secca, fico secco, miele; speziati: zafferano; legnosi: caramello',211,4,14.00,2019,35,110.00,12.00,1,4.20,1.00,0.40,1.00,280,1.00,14.19,22.70,'27.jpg',167,2),
(114,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,12.50,2021,15,2.80,5.50,0,6.00,2.50,0.50,0.40,150,0.87,12.59,20.14,'17.jpg',97,0),
(35,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',211,1,14.50,2015,40,1.00,8.50,0,4.50,0.80,0.20,1.80,2500,0.82,14.15,22.63,'21.jpg',146,1),
(199,'fruttati: pesca, mela verde, albicocca; speziati: fiori di acacia; legnosi: miele',156,4,8.50,2018,10,45.00,7.00,1,6.80,3.00,0.70,0.20,100,0.99,15.71,25.14,'11.jpg',78,3);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(132,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia, cioccolato',61,1,14.50,2016,35,1.20,8.50,0,4.80,0.90,0.20,1.80,2400,0.73,12.21,19.54,'30.jpg',143,1),
(85,'fruttati: mela verde, pera, agrumi; legnosi: burro, vaniglia; yeast: brioche',211,1,13.50,2018,15,2.00,6.50,0,5.80,2.20,0.40,0.80,180,0.40,13.40,21.44,'30.jpg',161,2),
(191,'fruttati: ciliegia, prugna, uva passa; speziati: cannella; legnosi: cioccolato, caramello',237,1,14.00,2017,40,100.00,11.00,1,4.00,0.80,0.30,1.50,400,0.85,13.00,20.81,'20.jpg',122,2),
(260,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',61,2,13.00,2020,30,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.65,13.82,22.11,'7.jpg',177,1),
(45,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',61,1,14.50,2016,20,1.20,8.50,0,4.50,0.80,0.20,1.80,2500,0.95,15.43,24.68,'32.jpg',141,2),
(121,'fruttati: litchi, pesca, albicocca secca; speziati: fiori bianchi, zenzero; legnosi: miele',156,4,13.00,2018,35,35.00,7.00,1,5.00,1.80,0.40,0.50,120,0.72,8.87,14.19,'35.jpg',61,3),
(21,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',61,1,14.20,2016,25,1.20,8.20,0,4.50,0.80,0.20,1.80,2400,0.66,8.46,13.53,'17.jpg',193,1),
(97,'fruttati: ciliegia, mora, fragola; speziati: pepe nero; legnosi: vaniglia',237,1,13.50,2019,30,1.80,7.50,0,4.80,1.20,0.30,1.50,1900,0.71,14.26,22.81,'3.jpg',188,3),
(79,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',61,1,14.00,2017,25,1.50,8.00,0,4.80,1.00,0.20,1.60,2100,0.47,10.62,16.98,'12.jpg',118,0),
(55,'fruttati: mela verde, agrumi, pera; legnosi: burro, vaniglia; yeast: brioche',245,1,13.50,2018,10,2.00,6.50,0,6.00,2.20,0.40,0.80,180,0.86,11.80,18.87,'8.jpg',181,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(184,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia',211,5,14.80,2018,10,2.50,8.50,0,4.00,1.00,0.30,1.80,2000,0.61,14.99,23.99,'8.jpg',74,2),
(173,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',211,2,13.20,2020,35,2.50,5.80,0,5.50,2.20,0.40,0.50,160,0.87,8.07,12.91,'20.jpg',62,2),
(127,'fruttati: mora, prugna, ribes nero; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',211,1,14.50,2017,35,1.20,8.50,0,4.50,0.80,0.20,1.80,2300,0.58,15.42,24.68,'11.jpg',169,3),
(181,'fruttati: agrumi, pompelmo, pesca; speziati: fiori bianchi',156,2,13.00,2019,30,2.00,5.80,0,6.50,3.00,0.60,0.30,140,0.65,13.75,22.00,'29.jpg',143,2),
(30,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',61,1,14.50,2017,25,2.00,8.00,0,5.00,1.20,0.30,1.50,1800,0.40,12.53,20.05,'24.jpg',117,2),
(225,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',211,2,12.80,2020,10,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.52,10.03,16.05,'7.jpg',109,3),
(4,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, caffè',156,1,14.20,2017,25,1.50,8.20,0,4.50,0.90,0.20,1.80,2300,0.64,13.84,22.14,'5.jpg',157,2),
(203,'fruttati: pesca, mela verde, agrumi; speziati: fiori di acacia',211,4,8.00,2020,35,35.00,6.00,1,7.00,3.50,0.80,0.20,100,0.67,14.64,23.42,'14.jpg',134,1),
(154,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',237,3,14.00,2016,20,1.80,8.00,0,4.50,1.00,0.20,1.80,2100,0.90,11.63,18.61,'35.jpg',36,3),
(13,'fruttati: pera, pesca, mela verde; speziati: fiori bianchi',211,2,13.00,2020,20,2.50,5.80,0,5.80,2.50,0.50,0.40,160,0.84,11.92,19.07,'26.jpg',74,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(207,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, tostato',211,5,14.20,2014,20,1.20,8.20,0,4.20,0.80,0.20,2.00,2300,0.56,8.32,13.32,'23.jpg',103,2),
(112,'fruttati: fragola, ciliegia, agrumi; speziati: fiori; yeast: brioche, crosta di pane',7,4,12.50,2018,15,6.00,5.50,0,6.00,2.00,0.50,0.80,180,0.93,10.37,16.60,'35.jpg',193,1),
(49,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia, tostato',156,1,14.50,2016,10,1.80,8.20,0,4.00,1.00,0.20,1.80,2100,0.48,10.00,16.00,'31.jpg',33,2),
(104,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi, fieno',237,2,13.00,2020,30,2.20,5.80,0,6.00,2.50,0.50,0.40,150,0.82,8.08,12.93,'26.jpg',137,3),
(91,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',237,3,13.50,2020,20,2.00,7.00,0,4.80,1.50,0.30,1.00,1600,0.88,10.93,17.49,'31.jpg',78,1),
(254,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',61,2,13.50,2018,25,2.00,6.00,0,6.00,2.50,0.50,0.40,160,0.50,8.25,13.20,'8.jpg',110,3),
(129,'fruttati: mora, prugna, ribes nero; speziati: pepe nero, liquirizia; legnosi: caffè, tostato',211,1,14.50,2016,10,1.20,8.50,0,4.50,0.80,0.20,1.80,2500,0.97,12.72,20.36,'27.jpg',30,0),
(124,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,13.00,2020,10,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.73,9.70,15.51,'25.jpg',57,2),
(158,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia',237,1,14.00,2019,35,1.80,7.80,0,4.50,1.20,0.30,1.50,2000,0.47,10.42,16.67,'14.jpg',50,0),
(102,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',211,2,12.80,2021,20,2.80,5.50,0,6.20,2.80,0.50,0.30,140,0.99,8.49,13.59,'26.jpg',166,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(71,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',61,1,13.50,2015,10,1.50,8.50,0,4.80,0.80,0.20,1.80,2500,0.72,9.74,15.58,'25.jpg',29,2),
(156,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',61,2,12.20,2021,20,3.20,5.20,0,6.50,3.00,0.60,0.20,120,0.44,12.64,20.23,'14.jpg',108,3),
(137,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',61,1,13.80,2019,30,2.00,7.50,0,4.50,1.20,0.30,1.50,1800,0.50,14.58,23.33,'8.jpg',49,2),
(196,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,13.20,2019,10,2.20,6.00,0,6.00,2.50,0.50,0.40,150,0.96,8.61,13.78,'18.jpg',117,3),
(83,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, tostato',61,1,14.80,2016,40,1.00,8.80,0,4.00,0.70,0.20,2.00,2600,0.95,9.07,14.52,'1.jpg',31,1),
(270,'fruttati: pesca, mela verde, agrumi; speziati: fiori bianchi, fieno',156,2,13.00,2019,25,2.50,6.00,0,6.20,2.50,0.50,0.50,160,0.46,9.54,15.26,'11.jpg',170,1),
(214,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, cioccolato, tostato',7,1,15.00,2014,40,1.00,9.00,0,4.00,0.70,0.20,2.00,2800,0.53,8.13,13.01,'12.jpg',157,3),
(50,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',237,2,12.80,2020,30,2.20,5.50,0,6.50,2.80,0.50,0.30,140,0.41,14.44,23.10,'34.jpg',32,0),
(238,'fruttati: mora, ciliegia, prugna; speziati: pepe nero; legnosi: vaniglia',156,1,13.50,2019,30,1.80,7.50,0,4.50,1.20,0.30,1.50,1900,0.87,8.07,12.91,'19.jpg',52,1),
(133,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',156,2,12.50,2021,35,2.80,5.50,0,6.00,2.50,0.50,0.40,130,0.74,11.52,18.43,'11.jpg',109,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(171,'fruttati: mora, ciliegia, prugna; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',237,1,14.20,2016,15,1.50,8.20,0,4.50,0.90,0.20,1.80,2200,0.74,15.17,24.27,'14.jpg',22,1),
(223,'fruttati: mela verde, pera, agrumi; speziati: fiori bianchi',156,2,12.50,2020,20,2.50,5.50,0,6.20,2.80,0.50,0.30,140,0.45,10.43,16.69,'12.jpg',94,2),
(52,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia, cioccolato',211,1,14.00,2016,20,1.20,8.20,0,4.80,0.90,0.20,1.80,2300,0.53,11.98,19.17,'7.jpg',110,1),
(105,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia, tostato',7,1,14.50,2017,15,1.50,8.00,0,4.20,1.00,0.20,1.80,2100,0.79,13.62,21.80,'27.jpg',40,3),
(197,'fruttati: ciliegia, fragola, mora; speziati: pepe nero; legnosi: vaniglia, cedro',156,1,13.80,2016,10,1.50,7.80,0,5.00,1.00,0.20,1.50,1900,0.66,10.90,17.45,'19.jpg',23,2),
(263,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane, pasticceria',237,4,12.00,2012,20,8.00,5.50,0,6.50,2.50,0.60,0.50,200,0.65,11.59,18.55,'3.jpg',28,1),
(193,'fruttati: albicocca secca, miele, frutta candita; speziati: zafferano; legnosi: caramello',237,4,13.00,2018,10,90.00,11.00,1,4.50,1.20,0.40,1.00,300,0.72,15.94,25.51,'5.jpg',198,1),
(173,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',61,2,13.00,2021,15,2.50,5.80,0,5.50,2.20,0.40,0.50,160,0.83,11.02,17.63,'6.jpg',14,3),
(41,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',237,1,14.50,2015,20,1.00,8.50,0,4.50,0.80,0.20,1.80,2500,0.41,14.48,23.17,'23.jpg',24,1),
(205,'fruttati: pesca, mela verde, albicocca; speziati: fiori di acacia; legnosi: miele',211,4,8.50,2019,10,40.00,7.00,1,6.80,3.00,0.70,0.20,100,0.41,10.53,16.85,'18.jpg',150,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(218,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',237,1,14.00,2017,40,1.50,8.50,0,4.80,0.90,0.20,1.80,2400,0.68,11.67,18.67,'26.jpg',43,1),
(190,'fruttati: mela verde, pera, agrumi; legnosi: burro, vaniglia; yeast: brioche',211,1,13.50,2018,35,2.00,6.50,0,5.80,2.20,0.40,0.80,180,0.60,8.05,12.87,'16.jpg',119,3),
(192,'fruttati: ciliegia, prugna, uva passa; speziati: cannella; legnosi: cioccolato, caramello',7,1,14.00,2017,10,95.00,11.00,1,4.00,0.80,0.30,1.50,400,0.78,8.93,14.29,'3.jpg',171,1),
(259,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',61,2,13.50,2019,10,2.20,6.00,0,6.00,2.50,0.50,0.40,160,0.99,13.47,21.55,'18.jpg',66,0),
(46,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè, cioccolato',211,1,14.50,2015,15,1.00,8.80,0,4.50,0.70,0.20,2.00,2600,0.92,13.45,21.53,'21.jpg',96,2),
(9,'fruttati: pesca, mela verde, agrumi; speziati: fiori bianchi; legnosi: miele',245,4,13.50,2018,20,3.00,6.50,0,5.50,2.00,0.40,0.60,140,0.95,10.18,16.29,'27.jpg',33,2),
(23,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',156,1,14.50,2016,25,1.20,8.50,0,4.50,0.80,0.20,1.80,2400,0.44,15.91,25.46,'14.jpg',72,0),
(98,'fruttati: ciliegia, mora, fragola; speziati: pepe nero; legnosi: vaniglia',237,1,13.80,2018,20,1.80,7.50,0,4.80,1.20,0.30,1.50,1900,0.56,12.68,20.28,'4.jpg',187,1),
(80,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',156,1,14.00,2018,30,1.50,8.00,0,4.80,1.00,0.20,1.60,2100,0.52,10.00,16.00,'30.jpg',0,1),
(60,'fruttati: mela verde, agrumi, pera; legnosi: burro, vaniglia; yeast: brioche',237,1,13.20,2018,20,2.00,6.20,0,6.00,2.20,0.40,0.80,180,0.85,9.99,15.99,'20.jpg',146,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(186,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, cioccolato',211,5,15.00,2017,25,2.20,8.80,0,3.80,0.80,0.30,2.00,2100,0.80,13.60,21.76,'32.jpg',47,0),
(175,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',237,2,13.50,2019,10,2.20,6.00,0,5.50,2.20,0.40,0.50,160,0.50,13.60,21.76,'14.jpg',22,3),
(107,'fruttati: mora, prugna, ribes nero; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',156,1,14.50,2017,10,1.20,8.50,0,4.50,0.80,0.20,1.80,2300,0.74,8.12,12.99,'1.jpg',122,1),
(216,'fruttati: agrumi, pompelmo, pesca; speziati: fiori bianchi',156,2,13.00,2020,35,2.00,5.80,0,6.50,3.00,0.60,0.30,140,0.83,12.87,20.59,'32.jpg',130,0),
(26,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',156,1,14.20,2018,25,2.00,8.00,0,5.00,1.20,0.30,1.50,1800,0.69,10.17,16.26,'14.jpg',105,3),
(225,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',211,2,12.80,2020,35,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.42,11.07,17.71,'15.jpg',114,0),
(232,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, caffè',237,1,14.20,2016,30,1.50,8.20,0,4.50,0.90,0.20,1.80,2300,0.63,12.95,20.72,'25.jpg',183,3),
(202,'fruttati: pesca, mela verde, agrumi; speziati: fiori di acacia',245,4,13.00,2019,10,6.00,6.00,0,6.50,2.80,0.60,0.30,130,0.42,11.92,19.08,'29.jpg',98,2),
(153,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',211,3,13.80,2018,40,1.80,7.80,0,4.50,1.00,0.20,1.80,2000,0.92,8.61,13.77,'31.jpg',101,1),
(15,'fruttati: pera, pesca, mela verde; speziati: fiori bianchi',211,2,13.00,2020,35,2.50,5.80,0,5.80,2.50,0.50,0.40,160,0.55,10.39,16.62,'27.jpg',3,3);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(209,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, tostato',237,5,13.80,2015,10,1.50,8.00,0,4.20,0.90,0.20,1.80,2100,0.70,15.36,24.57,'20.jpg',33,0),
(109,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane',7,4,12.50,2018,35,6.00,5.50,0,6.00,2.00,0.50,0.80,160,1.00,10.41,16.66,'2.jpg',0,2),
(48,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',61,1,14.00,2018,35,2.00,7.80,0,4.20,1.20,0.30,1.50,1900,0.67,13.20,21.12,'24.jpg',188,2),
(104,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi, fieno',211,2,13.00,2020,15,2.20,5.80,0,6.00,2.50,0.50,0.40,150,0.99,15.59,24.94,'31.jpg',123,1),
(91,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',156,3,13.50,2020,15,2.00,7.00,0,4.80,1.50,0.30,1.00,1600,0.60,14.17,22.68,'33.jpg',122,3),
(252,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',156,2,13.00,2020,40,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.60,8.37,13.39,'23.jpg',53,3),
(77,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',211,1,14.50,2017,25,1.50,8.50,0,4.20,0.80,0.20,1.80,2300,0.91,9.56,15.29,'11.jpg',91,0),
(124,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',156,2,13.00,2020,25,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.79,15.07,24.11,'3.jpg',192,2),
(159,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia',156,1,14.00,2019,30,1.80,7.80,0,4.50,1.20,0.30,1.50,2000,0.76,13.54,21.66,'33.jpg',78,3),
(101,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',211,2,12.80,2021,10,2.80,5.50,0,6.20,2.80,0.50,0.30,140,0.55,13.47,21.56,'26.jpg',45,3);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(72,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',61,1,13.80,2015,15,1.50,8.50,0,4.80,0.80,0.20,1.80,2500,0.43,15.50,24.81,'27.jpg',94,3),
(156,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',156,2,12.50,2021,20,3.00,5.50,0,6.50,3.00,0.60,0.20,120,0.76,15.98,25.57,'28.jpg',119,0),
(137,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',7,1,13.80,2019,40,2.00,7.50,0,4.50,1.20,0.30,1.50,1800,0.47,11.13,17.80,'10.jpg',12,2),
(196,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',211,2,13.00,2020,40,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.85,13.02,20.83,'13.jpg',24,1),
(135,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, tostato, cioccolato',7,1,14.80,2016,10,1.00,9.00,0,4.00,0.70,0.20,2.00,2700,0.66,8.05,12.88,'35.jpg',83,1),
(222,'fruttati: pesca, mela verde, agrumi; speziati: fiori bianchi, fieno',156,2,13.50,2018,30,2.00,6.20,0,6.00,2.20,0.40,0.60,170,0.62,8.89,14.23,'31.jpg',116,1),
(213,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, cioccolato',7,1,15.00,2016,10,1.00,9.00,0,4.00,0.70,0.20,2.00,2800,0.94,8.01,12.82,'15.jpg',54,1),
(50,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',211,2,12.80,2020,20,2.20,5.50,0,6.50,2.80,0.50,0.30,140,0.99,13.77,22.03,'4.jpg',26,2),
(238,'fruttati: mora, ciliegia, prugna; speziati: pepe nero; legnosi: vaniglia',156,1,13.50,2019,10,1.80,7.50,0,4.50,1.20,0.30,1.50,1900,0.94,15.47,24.75,'7.jpg',23,0),
(51,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,12.50,2021,30,2.80,5.50,0,6.00,2.50,0.50,0.40,130,0.73,8.14,13.02,'29.jpg',84,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(84,'fruttati: mora, ciliegia, prugna; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',61,1,14.00,2016,20,1.50,8.20,0,4.50,0.90,0.20,1.80,2200,0.69,9.12,14.59,'4.jpg',90,0),
(271,'fruttati: mela verde, pera, pesca; speziati: fiori bianchi',156,2,13.00,2020,40,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.98,15.74,25.18,'14.jpg',111,1),
(42,'fruttati: mela verde, pera, agrumi; legnosi: burro, vaniglia; yeast: brioche',237,1,13.50,2018,30,2.50,6.50,0,5.80,2.20,0.40,0.80,180,0.70,10.11,16.18,'27.jpg',184,3),
(73,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',61,1,13.80,2016,30,1.50,8.50,0,4.80,0.80,0.20,1.80,2500,0.86,9.79,15.66,'16.jpg',3,1),
(61,'fruttati: ciliegia, fragola, mora; speziati: pepe nero; legnosi: vaniglia, cedro',156,1,13.80,2016,25,1.50,7.80,0,5.00,1.00,0.20,1.50,1900,0.80,12.53,20.04,'32.jpg',68,2),
(231,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane, pasticceria',237,4,12.00,2012,15,8.00,5.50,0,6.50,2.50,0.60,0.50,200,0.82,14.34,22.94,'1.jpg',193,3),
(246,'fruttati: albicocca secca, miele, frutta candita; speziati: zafferano; legnosi: caramello',211,1,13.00,2018,15,95.00,11.00,1,4.50,1.20,0.40,1.00,300,0.50,15.84,25.34,'32.jpg',51,0),
(247,'fruttati: mela verde, pesca, agrumi; legnosi: burro, nocciola; yeast: lievito',237,1,13.00,2018,25,2.00,6.00,0,6.20,2.50,0.50,0.40,160,0.93,15.63,25.01,'22.jpg',172,0),
(33,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',211,1,14.50,2015,40,1.00,8.50,0,4.50,0.80,0.20,1.80,2500,0.51,10.70,17.13,'34.jpg',118,2),
(200,'fruttati: albicocca secca, miele, frutta candita; speziati: zafferano; legnosi: miele',156,4,8.00,2018,35,120.00,9.00,1,6.00,2.00,0.60,0.20,90,0.48,15.22,24.36,'7.jpg',111,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(163,'fruttati: agrumi, pesca, mela verde; legnosi: burro, vaniglia; yeast: brioche',211,1,13.50,2018,15,2.00,6.50,0,5.80,2.20,0.40,0.80,180,0.80,12.90,20.64,'11.jpg',170,2),
(117,'fruttati: ciliegia, fragola, mora; speziati: pepe nero; legnosi: vaniglia, cedro',211,1,13.50,2018,15,1.80,7.50,0,5.00,1.20,0.30,1.50,1800,0.90,10.56,16.89,'26.jpg',181,3),
(12,'fruttati: ciliegia, prugna, mora; speziati: cannella, liquirizia; legnosi: cioccolato, tostato, caffè',245,1,15.50,2013,30,3.50,9.80,0,3.50,0.40,0.20,2.50,2600,0.86,14.47,23.15,'22.jpg',190,3),
(258,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,13.00,2020,30,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.50,12.94,20.70,'16.jpg',31,1),
(45,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè, cioccolato',237,1,14.50,2015,10,1.00,8.80,0,4.50,0.70,0.20,2.00,2600,0.75,8.13,13.00,'19.jpg',164,3),
(119,'fruttati: litchi, pesca, agrumi; speziati: fiori bianchi, zenzero; legnosi: miele',161,4,13.50,2018,20,8.00,6.50,0,5.00,1.80,0.40,0.50,120,0.91,9.64,15.42,'11.jpg',195,1),
(18,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',237,1,14.20,2014,15,1.00,8.20,0,4.50,0.80,0.20,1.80,2400,0.55,13.86,22.17,'13.jpg',112,2),
(96,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',7,2,13.00,2019,35,2.00,5.80,0,6.20,2.80,0.50,0.40,160,0.93,8.86,14.18,'34.jpg',50,0),
(79,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',237,1,14.00,2017,20,1.50,8.00,0,4.80,1.00,0.20,1.60,2100,0.78,13.53,21.65,'11.jpg',166,2),
(155,'fruttati: mela verde, pera, agrumi; legnosi: burro, vaniglia; yeast: brioche',156,1,13.80,2017,30,2.00,6.80,0,5.80,2.00,0.40,0.90,190,0.87,8.83,14.12,'10.jpg',83,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(187,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, cioccolato',156,5,14.80,2017,40,2.50,8.80,0,3.80,0.80,0.30,2.00,2100,0.69,8.29,13.27,'30.jpg',28,0),
(174,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',237,2,13.20,2020,25,2.20,5.80,0,5.50,2.20,0.40,0.50,160,0.95,9.33,14.92,'8.jpg',110,2),
(250,'fruttati: mora, prugna, ribes nero; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',237,1,14.50,2016,20,1.20,8.50,0,4.50,0.80,0.20,1.80,2400,0.91,11.90,19.04,'1.jpg',197,1),
(181,'fruttati: agrumi, pompelmo, pesca; speziati: fiori bianchi',237,2,13.00,2020,15,2.00,5.80,0,6.50,3.00,0.60,0.30,140,0.94,8.44,13.50,'35.jpg',22,0),
(29,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, cioccolato',61,1,14.50,2017,40,2.00,8.20,0,5.00,1.00,0.30,1.60,1900,0.47,12.27,19.63,'20.jpg',55,3),
(226,'fruttati: mela verde, pesca, agrumi; legnosi: nocciola, vaniglia',237,1,13.00,2019,10,2.20,6.00,0,6.00,2.50,0.50,0.40,160,0.66,15.55,24.89,'4.jpg',64,2),
(5,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, caffè',61,1,14.20,2017,15,1.50,8.20,0,4.50,0.90,0.20,1.80,2300,0.88,10.04,16.06,'12.jpg',18,2),
(204,'fruttati: pesca, mela verde, agrumi; speziati: fiori di acacia',211,4,13.00,2019,20,5.00,6.00,0,6.50,2.80,0.60,0.30,130,0.80,14.88,23.80,'22.jpg',122,0),
(154,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',211,3,14.00,2016,35,1.80,8.00,0,4.50,1.00,0.20,1.80,2100,0.87,15.56,24.89,'3.jpg',141,3),
(13,'fruttati: pera, pesca, mela verde; speziati: fiori bianchi',61,2,13.00,2020,35,2.50,5.80,0,5.80,2.50,0.50,0.40,160,0.41,13.01,20.82,'34.jpg',115,2);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(208,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, tostato, cedro',211,5,14.00,2011,35,1.20,8.20,0,4.20,0.80,0.20,2.00,2300,0.85,13.83,22.13,'23.jpg',12,0),
(110,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane, pasticceria',61,4,12.50,2011,20,5.00,5.80,0,6.00,2.00,0.50,0.80,180,0.40,15.63,25.01,'14.jpg',42,3),
(49,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia, tostato',7,1,14.20,2017,15,1.80,8.00,0,4.20,1.00,0.20,1.80,2000,0.57,9.21,14.74,'34.jpg',22,2),
(104,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi, fieno',237,2,13.20,2019,30,2.00,6.00,0,6.00,2.50,0.50,0.40,150,0.45,9.07,14.51,'19.jpg',192,0),
(91,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',211,3,13.50,2020,25,2.00,7.00,0,4.80,1.50,0.30,1.00,1600,0.72,12.27,19.63,'16.jpg',36,1),
(253,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',61,2,13.20,2019,40,2.20,5.80,0,6.00,2.50,0.50,0.40,150,0.51,13.53,21.65,'13.jpg',95,1),
(131,'fruttati: mora, prugna, ribes nero; speziati: pepe nero, liquirizia; legnosi: caffè, tostato',237,1,14.50,2015,25,1.20,8.50,0,4.50,0.80,0.20,1.80,2500,0.70,11.98,19.17,'35.jpg',198,3),
(124,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,13.00,2020,30,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.88,14.15,22.65,'22.jpg',127,1),
(158,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia',237,1,14.00,2019,10,1.80,7.80,0,4.50,1.20,0.30,1.50,2000,0.89,13.42,21.46,'1.jpg',134,0),
(102,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',156,2,12.80,2021,20,2.80,5.50,0,6.20,2.80,0.50,0.30,140,0.60,10.21,16.34,'28.jpg',91,3);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(69,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',61,1,13.50,2016,30,1.50,8.50,0,4.80,0.80,0.20,1.80,2500,0.72,10.42,16.67,'17.jpg',193,1),
(223,'fruttati: mela verde, pera, agrumi; speziati: fiori bianchi',245,2,12.50,2020,25,2.50,5.50,0,6.20,2.80,0.50,0.30,140,0.91,9.64,15.42,'34.jpg',22,2),
(137,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',61,1,13.80,2019,40,2.00,7.50,0,4.50,1.20,0.30,1.50,1800,0.97,10.68,17.09,'30.jpg',24,0),
(196,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',211,2,13.00,2020,35,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.49,10.22,16.35,'29.jpg',61,3),
(241,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia, tostato',7,1,14.50,2018,25,1.50,8.00,0,4.20,1.00,0.20,1.80,2100,0.96,11.96,19.13,'8.jpg',110,2),
(269,'fruttati: pesca, mela verde, albicocca; speziati: fiori bianchi, fieno; legnosi: miele',156,4,12.00,2019,10,15.00,6.50,1,6.00,2.00,0.40,0.50,150,0.90,10.25,16.39,'4.jpg',53,3),
(215,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, cioccolato',7,1,15.00,2016,25,1.00,9.00,0,4.00,0.70,0.20,2.00,2800,0.61,8.34,13.35,'1.jpg',76,2),
(50,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',237,2,12.80,2020,40,2.20,5.50,0,6.50,2.80,0.50,0.30,140,0.41,11.69,18.70,'21.jpg',134,2),
(239,'fruttati: mora, ciliegia, prugna; speziati: pepe nero; legnosi: vaniglia, caffè',156,1,13.80,2017,30,1.50,8.00,0,4.50,1.00,0.20,1.80,2100,0.92,11.28,18.05,'28.jpg',47,2),
(133,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,12.50,2021,35,2.80,5.50,0,6.00,2.50,0.50,0.40,130,0.77,15.43,24.70,'30.jpg',42,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(128,'fruttati: mora, ciliegia, prugna; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato, cioccolato',211,1,14.50,2015,30,1.20,8.50,0,4.20,0.80,0.20,1.80,2400,0.73,12.94,20.70,'6.jpg',198,2),
(122,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',172,2,13.00,2020,20,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.99,13.43,21.49,'27.jpg',85,2),
(265,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',156,2,13.00,2019,40,2.50,6.00,0,6.00,2.50,0.50,0.40,160,0.42,10.83,17.33,'6.jpg',150,0),
(76,'fruttati: agrumi, pesca, mela verde; legnosi: burro, vaniglia; yeast: brioche',61,1,13.50,2018,10,2.00,6.50,0,5.80,2.20,0.40,0.80,180,0.76,15.30,24.49,'10.jpg',156,0),
(81,'fruttati: ciliegia, fragola, mora; speziati: pepe nero; legnosi: vaniglia, cedro',156,1,13.80,2016,40,1.50,7.80,0,5.00,1.00,0.20,1.50,1900,0.53,10.29,16.46,'1.jpg',98,1),
(92,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane, pasticceria',156,4,12.00,2012,10,8.00,5.50,0,6.50,2.50,0.60,0.50,200,0.71,13.39,21.42,'3.jpg',172,3),
(161,'fruttati: ciliegia, prugna, uva passa; speziati: cannella; legnosi: cioccolato, caramello',7,1,15.00,2015,40,100.00,12.00,1,4.00,0.80,0.30,1.50,400,0.97,11.87,18.99,'24.jpg',135,3),
(261,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',211,2,13.00,2020,35,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.63,9.59,15.35,'23.jpg',138,0),
(37,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',211,1,14.50,2015,40,1.00,8.50,0,4.50,0.80,0.20,1.80,2500,0.70,12.17,19.47,'18.jpg',199,0),
(201,'fruttati: albicocca secca, miele, frutta candita; speziati: zafferano; legnosi: miele',156,4,7.50,2018,20,150.00,9.00,1,6.00,2.00,0.60,0.20,90,0.63,15.67,25.07,'12.jpg',67,2);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(140,'fruttati: ribes nero, mora, prugna; speziati: tabacco; legnosi: cedro, cioccolato',211,1,14.00,2018,20,1.50,8.00,0,4.80,1.00,0.20,1.60,2200,0.98,15.48,24.77,'10.jpg',157,3),
(178,'fruttati: ciliegia, fragola, mora; speziati: pepe nero; legnosi: vaniglia, cedro',211,1,13.50,2018,20,1.80,7.50,0,5.00,1.20,0.30,1.50,1800,0.63,12.13,19.41,'10.jpg',59,1),
(194,'fruttati: albicocca secca, miele, frutta candita; speziati: zafferano; legnosi: caramello',237,4,13.00,2018,10,90.00,11.00,1,4.50,1.20,0.40,1.00,300,0.78,8.13,13.01,'1.jpg',106,3),
(257,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',211,2,13.00,2020,10,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.83,11.10,17.76,'13.jpg',175,0),
(46,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè, cioccolato',156,1,14.50,2015,20,1.00,8.80,0,4.50,0.70,0.20,2.00,2600,0.64,15.13,24.20,'19.jpg',11,0),
(8,'fruttati: litchi, pesca, agrumi; speziati: fiori bianchi, zenzero; legnosi: miele',211,4,13.50,2018,35,8.00,6.50,0,5.00,1.80,0.40,0.50,120,0.68,8.40,13.44,'19.jpg',186,0),
(19,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',211,1,14.20,2016,20,1.20,8.20,0,4.50,0.80,0.20,1.80,2400,0.86,8.88,14.22,'8.jpg',96,3),
(100,'fruttati: ciliegia, mora, fragola; speziati: pepe nero; legnosi: vaniglia',237,1,13.80,2018,35,1.80,7.50,0,4.80,1.20,0.30,1.50,1900,0.41,13.04,20.87,'29.jpg',166,0),
(80,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',61,1,14.00,2018,35,1.50,8.00,0,4.80,1.00,0.20,1.60,2100,0.90,11.52,18.43,'22.jpg',182,1),
(57,'fruttati: mela verde, agrumi, pera; legnosi: burro, vaniglia; yeast: brioche',245,1,13.50,2018,10,2.00,6.50,0,6.00,2.20,0.40,0.80,180,0.74,10.36,16.57,'33.jpg',115,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(186,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, cioccolato',211,5,15.00,2017,35,2.20,8.80,0,3.80,0.80,0.30,2.00,2100,0.91,13.52,21.63,'5.jpg',128,0),
(174,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',237,2,13.50,2019,30,2.20,6.00,0,5.50,2.20,0.40,0.50,160,0.98,12.20,19.53,'25.jpg',14,3),
(1,'fruttati: mora, prugna, ribes nero; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',98,1,14.50,2017,25,1.20,8.50,0,4.50,0.80,0.20,1.80,2300,0.72,13.68,21.88,'29.jpg',0,0),
(217,'fruttati: agrumi, pompelmo, pesca; speziati: fiori bianchi',237,2,13.00,2019,35,2.00,5.80,0,6.50,3.00,0.60,0.30,140,0.69,14.35,22.96,'22.jpg',100,2),
(27,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',211,1,14.20,2018,35,2.00,8.00,0,5.00,1.20,0.30,1.50,1800,0.67,10.36,16.58,'32.jpg',100,1),
(227,'fruttati: mela verde, pesca, agrumi; legnosi: nocciola, vaniglia',237,1,13.00,2019,35,2.20,6.00,0,6.00,2.50,0.50,0.40,160,0.94,9.76,15.62,'21.jpg',116,1),
(233,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, caffè',211,1,14.20,2016,10,1.50,8.20,0,4.50,0.90,0.20,1.80,2300,0.83,13.49,21.59,'12.jpg',147,2),
(202,'fruttati: pesca, mela verde, agrumi; speziati: fiori di acacia',211,4,13.00,2019,35,5.00,6.00,0,6.50,2.80,0.60,0.30,130,0.48,14.94,23.91,'31.jpg',191,1),
(154,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',211,3,14.00,2016,35,1.80,8.00,0,4.50,1.00,0.20,1.80,2100,0.68,13.56,21.70,'33.jpg',15,2),
(14,'fruttati: pera, pesca, mela verde; speziati: fiori bianchi',61,2,13.00,2020,15,2.50,5.80,0,5.80,2.50,0.50,0.40,160,0.69,8.49,13.58,'10.jpg',81,2);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(210,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, tostato',211,5,14.00,2015,25,1.50,8.00,0,4.20,0.90,0.20,1.80,2100,0.51,12.61,20.17,'11.jpg',70,1),
(112,'fruttati: fragola, ciliegia, agrumi; speziati: fiori; yeast: brioche, crosta di pane',7,4,12.50,2018,30,6.00,5.50,0,6.00,2.00,0.50,0.80,180,0.84,11.73,18.77,'23.jpg',161,2),
(49,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia, tostato',7,1,14.20,2017,35,1.80,8.00,0,4.20,1.00,0.20,1.80,2000,0.80,13.46,21.53,'3.jpg',165,3),
(104,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi, fieno',211,2,13.20,2019,25,2.00,6.00,0,6.00,2.50,0.50,0.40,150,0.81,11.55,18.48,'31.jpg',68,0),
(91,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',211,3,13.50,2020,35,2.00,7.00,0,4.80,1.50,0.30,1.00,1600,0.77,10.65,17.04,'35.jpg',165,1),
(253,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,13.20,2019,40,2.20,5.80,0,6.00,2.50,0.50,0.40,150,0.57,15.71,25.14,'6.jpg',54,1),
(87,'fruttati: mora, prugna, ribes nero; speziati: pepe nero, liquirizia; legnosi: caffè, tostato',156,1,14.50,2015,25,1.20,8.50,0,4.50,0.80,0.20,1.80,2500,0.99,9.74,15.58,'11.jpg',55,2),
(124,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,13.00,2020,25,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.98,9.74,15.58,'14.jpg',88,2),
(158,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia',156,1,14.00,2019,40,1.80,7.80,0,4.50,1.20,0.30,1.50,2000,0.78,9.68,15.48,'2.jpg',47,1),
(102,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',211,2,12.80,2021,15,2.80,5.50,0,6.20,2.80,0.50,0.30,140,0.51,8.33,13.33,'20.jpg',95,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(65,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',61,1,13.50,2015,10,1.50,8.50,0,4.80,0.80,0.20,1.80,2500,0.53,10.75,17.20,'23.jpg',113,1),
(156,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',61,2,12.20,2021,35,3.20,5.20,0,6.50,3.00,0.60,0.20,120,0.48,14.20,22.71,'8.jpg',146,2),
(138,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia, caffè',211,1,14.00,2018,25,1.80,8.00,0,4.50,1.00,0.20,1.80,2000,0.73,14.44,23.11,'27.jpg',23,0),
(196,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi; yeast: lievito',211,6,13.50,2018,15,2.50,6.00,0,6.00,2.50,0.50,0.40,160,0.62,14.67,23.47,'5.jpg',132,3),
(147,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',211,1,14.50,2017,15,1.50,8.50,0,4.00,0.80,0.20,2.00,2300,0.69,11.76,18.82,'2.jpg',76,3),
(221,'fruttati: pesca, mela verde, agrumi; speziati: fiori bianchi, fieno; legnosi: miele',211,1,13.50,2018,20,2.00,6.20,0,6.00,2.20,0.40,0.60,170,0.61,13.32,21.32,'34.jpg',16,0),
(213,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, cioccolato',211,1,15.00,2016,35,1.00,9.00,0,4.00,0.70,0.20,2.00,2800,0.49,8.35,13.36,'14.jpg',90,0),
(50,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',7,2,12.80,2020,30,2.20,5.50,0,6.50,2.80,0.50,0.30,140,0.54,8.98,14.37,'26.jpg',34,2),
(238,'fruttati: mora, ciliegia, prugna; speziati: pepe nero; legnosi: vaniglia',156,1,13.50,2019,40,1.80,7.50,0,4.50,1.20,0.30,1.50,1900,0.76,13.91,22.25,'11.jpg',160,0),
(51,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',156,2,12.50,2021,30,2.80,5.50,0,6.00,2.50,0.50,0.40,130,0.77,11.45,18.33,'31.jpg',37,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(170,'fruttati: mora, ciliegia, prugna; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato, cedro',237,1,14.20,2014,25,1.20,8.50,0,4.20,0.80,0.20,2.00,2400,0.50,8.40,13.45,'23.jpg',153,1),
(93,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',156,1,13.00,2019,30,2.00,7.00,0,4.50,1.50,0.30,1.20,1700,0.61,13.72,21.94,'12.jpg',105,2),
(177,'fruttati: mela verde, pera, agrumi; legnosi: burro, vaniglia; yeast: brioche',156,1,13.00,2019,10,2.50,6.00,0,6.00,2.50,0.50,0.40,160,0.82,9.41,15.06,'9.jpg',22,1),
(64,'fruttati: agrumi, pesca, mela verde; legnosi: burro, vaniglia; yeast: brioche',61,1,13.20,2018,30,2.00,6.20,0,5.80,2.20,0.40,0.80,170,0.90,10.89,17.43,'2.jpg',22,1),
(266,'fruttati: ciliegia, fragola, mora; speziati: pepe nero; legnosi: vaniglia, cedro',156,1,13.50,2018,25,1.80,7.50,0,5.00,1.20,0.30,1.50,1800,0.57,13.02,20.84,'1.jpg',192,2),
(44,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane, pasticceria',61,4,12.00,2012,20,7.50,5.50,0,6.50,2.50,0.60,0.50,200,0.98,8.58,13.73,'9.jpg',117,2),
(165,'fruttati: albicocca secca, fico secco, miele; speziati: zafferano; legnosi: caramello',156,4,14.50,2018,15,120.00,12.50,1,4.00,1.00,0.40,1.00,300,0.59,10.18,16.28,'1.jpg',167,1),
(116,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',211,2,12.80,2020,30,2.20,5.50,0,6.20,2.80,0.50,0.30,140,0.40,8.34,13.35,'23.jpg',127,2),
(32,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',61,1,14.50,2016,35,1.00,8.50,0,4.50,0.80,0.20,1.80,2500,0.77,10.62,17.00,'10.jpg',87,2),
(206,'fruttati: albicocca secca, miele, frutta candita; speziati: zafferano; legnosi: miele',237,4,7.00,2018,35,180.00,10.00,1,5.50,1.80,0.50,0.20,80,0.97,15.36,24.58,'34.jpg',32,3);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(126,'fruttati: ribes nero, mora, prugna; speziati: tabacco; legnosi: cedro, cioccolato',237,1,14.00,2018,15,1.50,8.00,0,4.80,1.00,0.20,1.60,2200,0.99,11.17,17.87,'10.jpg',77,3),
(267,'fruttati: ciliegia, fragola, mora; speziati: pepe nero; legnosi: vaniglia, cedro',211,1,13.50,2018,30,1.80,7.50,0,5.00,1.20,0.30,1.50,1800,0.97,15.34,24.54,'12.jpg',161,2),
(246,'fruttati: albicocca secca, miele, frutta candita; speziati: zafferano; legnosi: caramello',211,1,13.00,2018,20,95.00,11.00,1,4.50,1.20,0.40,1.00,300,0.97,13.91,22.25,'4.jpg',152,2),
(258,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',211,2,13.00,2020,15,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.66,14.25,22.81,'12.jpg',166,1),
(45,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',61,1,14.50,2016,25,1.20,8.50,0,4.50,0.80,0.20,1.80,2500,0.61,9.95,15.92,'17.jpg',198,2),
(121,'fruttati: litchi, pesca, albicocca secca; speziati: fiori bianchi, zenzero; legnosi: miele',237,4,13.00,2018,15,35.00,7.00,1,5.00,1.80,0.40,0.50,120,0.90,12.08,19.32,'25.jpg',188,2),
(20,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',237,1,14.20,2016,40,1.20,8.20,0,4.50,0.80,0.20,1.80,2400,0.60,13.35,21.35,'14.jpg',54,1),
(97,'fruttati: ciliegia, mora, fragola; speziati: pepe nero; legnosi: vaniglia',237,1,13.80,2019,35,1.80,7.50,0,4.80,1.20,0.30,1.50,1900,0.85,11.22,17.95,'2.jpg',145,0),
(79,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',61,1,14.00,2017,25,1.50,8.00,0,4.80,1.00,0.20,1.60,2100,0.89,8.67,13.87,'21.jpg',17,2),
(59,'fruttati: mela verde, agrumi, pera; legnosi: burro, vaniglia; yeast: brioche',237,1,13.20,2018,20,2.00,6.20,0,6.00,2.20,0.40,0.80,180,0.44,13.25,21.19,'32.jpg',30,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(185,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, cioccolato',211,5,15.00,2017,35,2.20,8.80,0,3.80,0.80,0.30,2.00,2100,0.63,10.91,17.46,'20.jpg',30,2),
(173,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',211,2,13.50,2019,25,2.20,6.00,0,5.50,2.20,0.40,0.50,160,0.56,12.27,19.63,'21.jpg',108,2),
(242,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',237,1,14.50,2017,35,1.20,8.50,0,4.00,0.80,0.20,2.00,2300,0.66,9.23,14.77,'13.jpg',13,2),
(182,'fruttati: agrumi, pompelmo, pesca; speziati: fiori bianchi; legnosi: pietra focaia',156,1,13.20,2018,40,2.00,6.00,0,6.50,3.00,0.60,0.30,150,0.52,14.76,23.61,'6.jpg',25,0),
(30,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',211,1,14.20,2018,25,2.00,8.00,0,5.00,1.20,0.30,1.50,1800,0.59,14.04,22.47,'17.jpg',181,0),
(225,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,12.80,2020,35,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.45,14.84,23.74,'16.jpg',120,1),
(4,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, caffè',237,1,14.20,2017,25,1.50,8.20,0,4.50,0.90,0.20,1.80,2300,0.86,15.70,25.12,'5.jpg',167,1),
(203,'fruttati: pesca, mela verde, agrumi; speziati: fiori di acacia',211,4,8.50,2020,40,35.00,6.00,1,7.00,3.50,0.80,0.20,100,0.82,13.86,22.17,'34.jpg',111,0),
(153,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',61,3,13.80,2018,25,1.80,7.80,0,4.50,1.00,0.20,1.80,2000,0.90,8.03,12.84,'29.jpg',97,0),
(13,'fruttati: pera, pesca, mela verde; speziati: fiori bianchi',237,2,13.00,2020,40,2.50,5.80,0,5.80,2.50,0.50,0.40,160,0.93,13.45,21.52,'1.jpg',58,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(209,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, tostato',211,5,14.00,2016,30,1.50,8.00,0,4.20,0.90,0.20,1.80,2100,0.64,13.00,20.80,'16.jpg',184,3),
(109,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane',61,4,12.50,2018,15,6.00,5.50,0,6.00,2.00,0.50,0.80,160,0.92,15.99,25.58,'7.jpg',9,2),
(48,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',211,1,14.00,2018,30,2.00,7.80,0,4.20,1.20,0.30,1.50,1900,0.77,10.38,16.60,'14.jpg',62,1),
(104,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi, fieno',237,2,13.00,2020,20,2.20,5.80,0,6.00,2.50,0.50,0.40,150,0.74,13.51,21.62,'9.jpg',76,0),
(91,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',156,3,13.50,2020,30,2.00,7.00,0,4.80,1.50,0.30,1.00,1600,0.57,12.85,20.56,'33.jpg',141,2),
(252,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,13.00,2020,10,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.62,15.86,25.37,'13.jpg',0,0),
(130,'fruttati: pesca, albicocca, agrumi; legnosi: burro, vaniglia; yeast: brioche',211,1,13.50,2018,20,2.20,6.50,0,5.80,2.00,0.40,0.80,180,0.43,15.46,24.74,'18.jpg',163,3),
(124,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',211,2,13.00,2020,40,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.78,8.62,13.79,'33.jpg',47,0),
(158,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia',61,1,14.00,2019,10,1.80,7.80,0,4.50,1.20,0.30,1.50,2000,0.73,11.30,18.08,'9.jpg',141,2),
(101,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',156,2,12.80,2021,20,2.80,5.50,0,6.20,2.80,0.50,0.30,140,0.83,15.55,24.87,'11.jpg',177,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(166,'fruttati: agrumi, pesca, mela verde; legnosi: burro, vaniglia; yeast: brioche',61,1,13.50,2018,15,2.00,6.50,0,5.80,2.20,0.40,0.80,180,0.73,9.47,15.15,'8.jpg',87,2),
(122,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',237,2,13.00,2020,25,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.68,11.87,18.99,'9.jpg',178,1),
(137,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',7,1,13.80,2019,35,2.00,7.50,0,4.50,1.20,0.30,1.50,1800,0.73,14.58,23.33,'33.jpg',57,2),
(196,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi; yeast: lievito',237,6,13.50,2017,40,2.50,6.00,0,6.00,2.50,0.50,0.40,160,0.42,11.02,17.63,'20.jpg',0,0),
(243,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',237,1,14.50,2017,40,1.20,8.50,0,4.00,0.80,0.20,2.00,2300,0.95,11.13,17.81,'10.jpg',3,0),
(78,'fruttati: pesca, mela verde, agrumi; speziati: fiori bianchi, fieno',156,2,13.00,2019,10,2.50,6.00,0,6.20,2.50,0.50,0.50,160,0.98,11.88,19.02,'30.jpg',6,0),
(213,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, cioccolato',237,1,15.00,2015,30,1.00,9.00,0,4.00,0.70,0.20,2.00,2800,0.62,10.03,16.05,'9.jpg',150,1),
(50,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',237,2,12.80,2020,15,2.20,5.50,0,6.50,2.80,0.50,0.30,140,0.58,12.33,19.73,'4.jpg',132,3),
(238,'fruttati: mora, ciliegia, prugna; speziati: pepe nero; legnosi: vaniglia',156,1,13.50,2019,10,1.80,7.50,0,4.50,1.20,0.30,1.50,1900,0.76,15.86,25.37,'9.jpg',147,3),
(133,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',61,2,12.50,2021,25,2.80,5.50,0,6.00,2.50,0.50,0.40,130,0.63,13.68,21.88,'24.jpg',24,2);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(141,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',211,1,13.50,2018,20,1.80,7.50,0,4.50,1.20,0.30,1.50,1900,0.58,13.65,21.85,'9.jpg',83,1),
(94,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',156,2,12.80,2020,30,2.50,5.50,0,6.20,2.80,0.50,0.30,140,0.66,9.93,15.88,'33.jpg',181,3),
(66,'fruttati: agrumi, pesca, mela verde; legnosi: burro, vaniglia; yeast: brioche',61,1,13.50,2017,20,2.00,6.50,0,5.80,2.20,0.40,0.80,180,0.68,14.73,23.56,'9.jpg',43,3),
(179,'fruttati: ciliegia, fragola, mora; speziati: pepe nero; legnosi: vaniglia, cedro',156,1,13.50,2018,40,1.80,7.50,0,5.00,1.20,0.30,1.50,1800,0.67,11.24,17.99,'16.jpg',86,0),
(262,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane',237,4,12.00,2015,15,8.00,5.50,0,6.50,2.50,0.60,0.50,200,0.60,12.28,19.65,'16.jpg',44,1),
(145,'fruttati: albicocca secca, fico secco, miele; speziati: zafferano; legnosi: caramello',61,4,14.00,2019,25,110.00,12.00,1,4.20,1.00,0.40,1.00,280,0.48,15.66,25.05,'2.jpg',161,3),
(157,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',156,2,13.00,2020,35,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.45,12.60,20.16,'35.jpg',39,0),
(38,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',237,1,14.50,2016,20,1.00,8.50,0,4.50,0.80,0.20,1.80,2500,0.82,14.73,23.57,'32.jpg',183,1),
(199,'fruttati: pesca, mela verde, albicocca; speziati: fiori di acacia; legnosi: miele',211,4,8.50,2018,25,45.00,7.00,1,6.80,3.00,0.70,0.20,100,0.66,15.87,25.39,'20.jpg',110,1),
(148,'fruttati: mora, prugna, ribes nero; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',211,1,14.50,2016,20,1.50,8.80,0,4.80,0.90,0.20,1.80,2500,0.78,12.92,20.68,'19.jpg',60,2);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(85,'fruttati: mela verde, pera, agrumi; legnosi: burro, vaniglia; yeast: brioche',61,1,13.50,2018,25,2.00,6.50,0,5.80,2.20,0.40,0.80,180,0.65,13.90,22.25,'35.jpg',104,3),
(191,'fruttati: ciliegia, prugna, uva passa; speziati: cannella; legnosi: cioccolato, caramello',237,1,14.00,2015,15,100.00,11.00,1,4.00,0.80,0.30,1.50,400,0.47,8.33,13.33,'3.jpg',36,3),
(260,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',61,2,13.00,2020,25,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.50,8.14,13.03,'16.jpg',178,1),
(45,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè, cioccolato',237,1,14.50,2015,25,1.00,8.80,0,4.50,0.70,0.20,2.00,2600,0.57,13.09,20.95,'22.jpg',37,0),
(120,'fruttati: litchi, albicocca secca, miele; speziati: fiori bianchi, zenzero; legnosi: miele',245,4,10.00,2017,25,120.00,9.00,1,4.50,1.50,0.40,0.40,100,0.42,15.87,25.39,'31.jpg',100,1),
(21,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',237,1,14.20,2016,10,1.20,8.20,0,4.50,0.80,0.20,1.80,2400,0.45,9.34,14.95,'15.jpg',151,3),
(99,'fruttati: ciliegia, mora, fragola; speziati: pepe nero; legnosi: vaniglia',237,1,13.80,2018,35,1.80,7.50,0,4.80,1.20,0.30,1.50,1900,0.82,11.96,19.13,'10.jpg',131,2),
(80,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',156,1,14.00,2018,30,1.50,8.00,0,4.80,1.00,0.20,1.60,2100,0.75,11.41,18.25,'4.jpg',134,2),
(56,'fruttati: mela verde, agrumi, pera; legnosi: burro, vaniglia; yeast: brioche',237,1,13.50,2018,15,2.00,6.50,0,6.00,2.20,0.40,0.80,180,0.95,11.91,19.05,'12.jpg',108,3),
(184,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia',61,5,14.80,2018,40,2.50,8.50,0,4.00,1.00,0.30,1.80,2000,0.68,10.86,17.37,'35.jpg',10,3);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(173,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',237,2,13.50,2019,15,2.20,6.00,0,5.50,2.20,0.40,0.50,160,0.75,8.94,14.30,'17.jpg',141,1),
(146,'fruttati: pesca, agrumi, ananas; speziati: fiori bianchi',211,2,12.50,2021,10,3.00,5.50,0,6.50,3.00,0.60,0.30,140,0.98,9.06,14.50,'12.jpg',81,1),
(216,'fruttati: agrumi, pompelmo, pesca; speziati: fiori bianchi',7,2,13.00,2020,10,2.00,5.80,0,6.50,3.00,0.60,0.30,140,0.90,13.46,21.54,'18.jpg',39,1),
(25,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',211,1,14.20,2018,15,2.00,8.00,0,5.00,1.20,0.30,1.50,1800,0.97,15.15,24.24,'31.jpg',17,2),
(225,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',7,2,13.00,2020,15,2.20,5.80,0,6.00,2.50,0.50,0.40,150,0.94,15.58,24.93,'17.jpg',190,2),
(4,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, caffè',7,1,14.20,2017,15,1.50,8.20,0,4.50,0.90,0.20,1.80,2300,0.90,10.68,17.09,'33.jpg',97,1),
(202,'fruttati: pesca, mela verde, agrumi; speziati: fiori di acacia',7,4,13.00,2019,35,5.00,6.00,0,6.50,2.80,0.60,0.30,130,0.43,12.08,19.33,'29.jpg',30,2),
(153,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',156,3,13.80,2017,10,1.80,7.80,0,4.50,1.00,0.20,1.80,2000,0.55,11.44,18.30,'30.jpg',29,0),
(13,'fruttati: pera, pesca, mela verde; speziati: fiori bianchi',211,2,13.00,2020,25,2.50,5.80,0,5.80,2.50,0.50,0.40,160,0.56,11.71,18.74,'32.jpg',24,1),
(207,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, tostato, cedro',211,5,14.00,2014,15,1.20,8.20,0,4.20,0.80,0.20,2.00,2300,0.71,10.21,16.34,'32.jpg',26,2);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(111,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane, pasticceria',7,4,12.50,2013,30,6.00,5.50,0,6.00,2.00,0.50,0.80,180,0.87,15.66,25.06,'35.jpg',55,1),
(48,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',237,1,14.00,2018,20,2.00,7.80,0,4.20,1.20,0.30,1.50,1900,0.58,10.87,17.39,'9.jpg',185,2),
(104,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi, fieno',237,2,13.00,2020,40,2.20,5.80,0,6.00,2.50,0.50,0.40,150,0.54,10.31,16.49,'35.jpg',200,1),
(91,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',233,3,13.50,2020,30,2.00,7.00,0,4.80,1.50,0.30,1.00,1600,0.60,11.48,18.37,'31.jpg',72,0),
(252,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',156,2,13.00,2020,25,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.63,12.67,20.28,'35.jpg',76,1),
(77,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',156,1,14.50,2017,25,1.50,8.50,0,4.20,0.80,0.20,1.80,2300,0.84,12.46,19.93,'29.jpg',158,3),
(124,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,13.00,2020,40,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.41,13.92,22.27,'4.jpg',30,0),
(158,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia',237,1,14.00,2019,10,1.80,7.80,0,4.50,1.20,0.30,1.50,2000,0.92,11.87,19.00,'6.jpg',152,0),
(101,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',211,2,12.80,2021,40,2.80,5.50,0,6.20,2.80,0.50,0.30,140,0.54,8.86,14.17,'6.jpg',84,2),
(74,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',61,1,13.50,2016,40,1.50,8.50,0,4.80,0.80,0.20,1.80,2500,0.91,11.68,18.69,'11.jpg',147,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(223,'fruttati: mela verde, pera, agrumi; speziati: fiori bianchi',245,2,12.50,2020,15,2.50,5.50,0,6.20,2.80,0.50,0.30,140,0.96,10.51,16.81,'2.jpg',191,2),
(137,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',61,1,13.80,2019,40,2.00,7.50,0,4.50,1.20,0.30,1.50,1800,0.50,9.34,14.95,'9.jpg',10,1),
(196,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,13.00,2020,15,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.71,15.33,24.54,'26.jpg',102,1),
(188,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',211,1,14.50,2017,30,1.50,8.50,0,4.00,0.80,0.20,2.00,2300,0.96,14.61,23.37,'22.jpg',145,1),
(268,'fruttati: pesca, mela verde, agrumi; speziati: fiori bianchi, fieno',156,2,12.50,2019,20,4.00,6.00,0,6.20,2.50,0.50,0.50,160,0.82,8.26,13.21,'6.jpg',151,0),
(213,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, cioccolato',7,1,15.00,2016,35,1.00,9.00,0,4.00,0.70,0.20,2.00,2800,0.53,9.65,15.44,'3.jpg',150,2),
(50,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',7,2,12.80,2020,15,2.20,5.50,0,6.50,2.80,0.50,0.30,140,0.60,12.23,19.57,'17.jpg',152,3),
(238,'fruttati: mora, ciliegia, prugna; speziati: pepe nero; legnosi: vaniglia',156,1,13.50,2019,40,1.80,7.50,0,4.50,1.20,0.30,1.50,1900,0.48,12.89,20.63,'18.jpg',166,2),
(51,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',156,2,12.50,2021,30,2.80,5.50,0,6.00,2.50,0.50,0.40,130,0.46,11.04,17.67,'11.jpg',183,0),
(195,'fruttati: mora, ciliegia, prugna; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato, cioccolato',98,1,14.50,2017,40,1.20,8.50,0,4.50,0.80,0.20,1.80,2300,0.75,8.98,14.36,'14.jpg',71,2);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(229,'fruttati: ciliegia, fragola, mora; speziati: pepe nero; legnosi: vaniglia, cedro',7,1,13.50,2018,25,1.80,7.50,0,5.00,1.20,0.30,1.50,1800,0.64,12.68,20.29,'18.jpg',138,0),
(245,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',245,2,13.50,2019,30,2.00,6.00,0,6.20,2.50,0.50,0.40,160,0.67,8.83,14.13,'30.jpg',68,0),
(167,'fruttati: ribes nero, mora, prugna; speziati: tabacco; legnosi: cedro, cioccolato',61,1,13.50,2016,40,1.50,8.20,0,4.80,0.90,0.20,1.60,2300,0.43,9.44,15.10,'11.jpg',5,0),
(197,'fruttati: ciliegia, fragola, mora; speziati: pepe nero; legnosi: vaniglia, cedro',156,1,13.80,2016,10,1.50,7.80,0,5.00,1.00,0.20,1.50,1900,0.97,14.34,22.94,'7.jpg',79,0),
(143,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane, pasticceria',211,4,12.00,2012,15,8.00,5.50,0,6.50,2.50,0.60,0.50,200,0.63,8.08,12.92,'28.jpg',4,1),
(164,'fruttati: albicocca secca, fico secco, miele; speziati: zafferano; legnosi: caramello',237,4,14.50,2018,35,120.00,12.50,1,4.00,1.00,0.40,1.00,300,0.89,14.49,23.18,'35.jpg',156,2),
(211,'fruttati: pera, pesca, mela verde; speziati: fiori bianchi',61,2,13.00,2020,15,2.50,5.80,0,5.80,2.50,0.50,0.40,160,0.76,10.68,17.09,'13.jpg',141,1),
(40,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè, cioccolato',211,1,14.80,2013,10,1.00,8.80,0,4.50,0.70,0.20,2.00,2700,0.82,12.78,20.45,'21.jpg',34,3),
(206,'fruttati: albicocca secca, miele, frutta candita; speziati: zafferano; legnosi: miele',156,4,7.00,2018,20,180.00,10.00,1,5.50,1.80,0.50,0.20,80,0.49,10.39,16.63,'28.jpg',142,0),
(236,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',237,1,14.00,2017,10,1.50,8.50,0,4.80,0.90,0.20,1.80,2400,0.70,13.21,21.13,'27.jpg',33,3);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(43,'fruttati: mela verde, pera, agrumi; legnosi: burro, vaniglia; yeast: brioche',156,1,13.80,2017,15,2.00,6.80,0,5.80,2.00,0.40,0.90,190,0.48,14.95,23.92,'6.jpg',40,2),
(11,'fruttati: ciliegia, prugna, mora; speziati: cannella, liquirizia; legnosi: cioccolato, tostato, caffè',237,1,16.00,2012,20,3.80,10.00,0,3.50,0.40,0.20,2.50,2500,0.68,10.35,16.55,'11.jpg',177,0),
(259,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',211,2,13.50,2019,35,2.20,6.00,0,6.00,2.50,0.50,0.40,160,0.55,14.04,22.46,'26.jpg',68,0),
(46,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè, cioccolato',211,1,14.50,2013,20,1.00,8.80,0,4.50,0.70,0.20,2.00,2600,0.85,13.32,21.31,'20.jpg',108,3),
(9,'fruttati: pesca, mela verde, agrumi; speziati: fiori bianchi; legnosi: miele',161,4,13.50,2018,30,3.00,6.50,0,5.50,2.00,0.40,0.60,140,0.55,8.11,12.98,'27.jpg',124,3),
(24,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, caffè',156,1,14.50,2016,40,1.20,8.50,0,4.50,0.80,0.20,1.80,2400,0.90,8.68,13.89,'12.jpg',68,0),
(96,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',7,2,13.00,2019,40,2.00,5.80,0,6.20,2.80,0.50,0.40,160,0.56,13.21,21.13,'20.jpg',131,3),
(79,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',61,1,14.00,2017,25,1.50,8.00,0,4.80,1.00,0.20,1.60,2100,0.55,14.54,23.26,'26.jpg',182,1),
(54,'fruttati: mela verde, agrumi, pera; legnosi: burro, vaniglia; yeast: brioche',245,1,13.50,2018,30,2.00,6.50,0,6.00,2.20,0.40,0.80,180,0.99,11.60,18.55,'10.jpg',110,0),
(186,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, cioccolato',156,5,15.00,2017,25,2.20,8.80,0,3.80,0.80,0.30,2.00,2100,0.91,15.74,25.19,'33.jpg',161,3);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(173,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',211,2,13.50,2019,35,2.20,6.00,0,5.50,2.20,0.40,0.50,160,0.70,15.69,25.11,'5.jpg',18,2),
(168,'fruttati: pesca, agrumi, ananas; speziati: fiori bianchi',237,2,13.00,2020,25,2.50,5.80,0,6.50,3.00,0.60,0.30,140,0.61,11.51,18.41,'26.jpg',63,2),
(181,'fruttati: agrumi, pompelmo, pesca; speziati: fiori bianchi',237,2,13.00,2020,40,2.00,5.80,0,6.50,3.00,0.60,0.30,140,0.83,15.50,24.80,'13.jpg',168,2),
(30,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',211,1,14.20,2018,30,2.00,8.00,0,5.00,1.20,0.30,1.50,1800,0.95,8.44,13.50,'26.jpg',3,0),
(225,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',237,2,12.80,2020,20,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.76,10.23,16.37,'9.jpg',132,2),
(4,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: vaniglia, caffè',211,1,14.20,2017,30,1.50,8.20,0,4.50,0.90,0.20,1.80,2300,0.99,12.26,19.61,'3.jpg',138,1),
(203,'fruttati: pesca, mela verde, agrumi; speziati: fiori di acacia',156,4,8.50,2020,10,35.00,6.00,1,7.00,3.50,0.80,0.20,100,0.89,13.77,22.03,'23.jpg',117,1),
(154,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia, tostato',211,3,14.00,2016,35,1.80,8.00,0,4.50,1.00,0.20,1.80,2100,0.72,12.09,19.34,'16.jpg',130,1),
(13,'fruttati: pera, pesca, mela verde; speziati: fiori bianchi',237,2,13.00,2020,10,2.50,5.80,0,5.80,2.50,0.50,0.40,160,0.48,15.94,25.51,'18.jpg',116,0),
(209,'fruttati: ciliegia, mora, prugna; speziati: tabacco, liquirizia; legnosi: vaniglia, tostato',211,5,14.00,2016,30,1.50,8.00,0,4.20,0.90,0.20,1.80,2100,0.49,11.72,18.75,'28.jpg',80,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(113,'fruttati: mela verde, agrumi, pera; speziati: fiori bianchi; yeast: brioche, crosta di pane',7,4,12.50,2018,10,6.00,5.50,0,6.00,2.00,0.50,0.80,160,1.00,8.48,13.57,'19.jpg',117,3),
(49,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia, tostato',7,1,14.20,2017,30,1.80,8.00,0,4.20,1.00,0.20,1.80,2000,0.48,13.55,21.68,'16.jpg',127,0),
(104,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi, fieno',156,2,13.00,2020,15,2.20,5.80,0,6.00,2.50,0.50,0.40,150,0.78,12.98,20.77,'22.jpg',197,2),
(91,'fruttati: ciliegia, mora, prugna; speziati: pepe nero; legnosi: vaniglia',211,3,13.50,2020,30,2.00,7.00,0,4.80,1.50,0.30,1.00,1600,0.56,12.27,19.63,'25.jpg',71,1),
(253,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',61,2,13.20,2019,35,2.20,5.80,0,6.00,2.50,0.50,0.40,150,0.41,9.38,15.01,'33.jpg',46,0),
(129,'fruttati: mora, prugna, ribes nero; speziati: pepe nero, liquirizia; legnosi: caffè, tostato',211,1,14.50,2016,25,1.20,8.50,0,4.50,0.80,0.20,1.80,2500,0.40,10.25,16.39,'14.jpg',172,3),
(124,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,13.00,2020,15,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.42,11.55,18.48,'25.jpg',85,1),
(158,'fruttati: ciliegia, mora, prugna; speziati: tabacco; legnosi: vaniglia',211,1,14.00,2019,30,1.80,7.80,0,4.50,1.20,0.30,1.50,2000,0.98,12.06,19.29,'33.jpg',91,2),
(101,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,12.80,2021,15,2.80,5.50,0,6.20,2.80,0.50,0.30,140,0.45,13.48,21.57,'12.jpg',51,0),
(75,'fruttati: ribes nero, mora, prugna; speziati: tabacco, liquirizia; legnosi: cedro, cioccolato',61,1,13.50,2016,10,1.50,8.50,0,4.80,0.80,0.20,1.80,2500,0.52,11.99,19.19,'26.jpg',156,0);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(271,'fruttati: mela verde, pera, pesca; speziati: fiori bianchi',7,2,13.00,2020,20,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.83,9.51,15.22,'30.jpg',4,2),
(137,'fruttati: mora, prugna, ciliegia; speziati: pepe nero; legnosi: vaniglia',156,1,13.80,2019,35,2.00,7.50,0,4.50,1.20,0.30,1.50,1800,0.50,12.48,19.96,'1.jpg',187,3),
(196,'fruttati: mela verde, pesca, agrumi; speziati: fiori bianchi',211,2,13.00,2020,30,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.67,11.30,18.09,'28.jpg',164,1),
(82,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, tostato',61,1,14.80,2015,40,1.00,8.80,0,4.00,0.70,0.20,2.00,2600,0.85,8.27,13.24,'20.jpg',71,0),
(220,'fruttati: pesca, mela verde, agrumi; speziati: fiori bianchi, fieno',156,2,13.50,2018,10,2.00,6.20,0,6.00,2.20,0.40,0.60,170,0.75,13.25,21.20,'27.jpg',188,3),
(213,'fruttati: mora, prugna, ciliegia; speziati: pepe nero, liquirizia; legnosi: caffè, cioccolato',237,1,15.00,2016,10,1.00,9.00,0,4.00,0.70,0.20,2.00,2800,0.84,15.09,24.15,'14.jpg',199,0),
(50,'fruttati: agrumi, mela verde, pesca; speziati: fiori bianchi',211,2,12.80,2020,25,2.20,5.50,0,6.50,2.80,0.50,0.30,140,0.72,15.28,24.45,'5.jpg',21,3),
(238,'fruttati: mora, ciliegia, prugna; speziati: pepe nero; legnosi: vaniglia',156,1,13.50,2019,40,1.80,7.50,0,4.50,1.20,0.30,1.50,1900,0.99,14.82,23.72,'18.jpg',97,2),
(133,'fruttati: pesca, agrumi, mela verde; speziati: fiori bianchi',237,2,12.50,2021,35,2.80,5.50,0,6.00,2.50,0.50,0.40,130,0.70,12.14,19.42,'33.jpg',29,1),
(169,'fruttati: mora, ciliegia, prugna; speziati: pepe nero, liquirizia; legnosi: vaniglia, tostato',237,1,14.20,2017,35,1.50,8.20,0,4.50,0.90,0.20,1.80,2200,0.80,15.58,24.92,'35.jpg',123,1);
INSERT INTO tana_di_paolo.magazzino (vino,aromi,cantina,invecchiamento,alcol,annata,maturazione,zuccheri_residui,glicerolo,passiti,acido_tartarico,acido_malico,acido_citrico,acido_lattico,tannini,qualita,prezzo_acquisto,prezzo_vendita,immagine,quantita,ordinabilita) VALUES
(122,'fruttati: pera, mela verde, pesca; speziati: fiori bianchi',237,2,13.00,2020,30,2.50,5.80,0,6.00,2.50,0.50,0.40,150,0.93,14.30,22.88,'10.jpg',22,3);