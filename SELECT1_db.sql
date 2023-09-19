
--название и продолжительность самого длительного трека
SELECT name, duration
FROM single
ORDER BY duration DESC, name 
LIMIT 1;

--название треков, продолжительность которых не менее 3,5 минуты
SELECT name, duration
FROM single
WHERE duration > 3.5;

--названия сборников, вышедших в период с 2018 по 2020 год включительно
SELECT name, date_of_release
FROM music_collection
WHERE date_of_release BETWEEN 2018 AND 2020;

--исполнители, чье имя состоит из 1 слова
SELECT DISTINCT name
FROM music_artist
WHERE (LENGTH(name) - LENGTH(REPLACE(name, ' ', ''))+1) = 1;

--название треков, которые содержат слово "мой"/"my
SELECT name
FROM single
WHERE name LIKE '%мой%' OR name LIKE '%my%'; 


--количество исполнителей в каждом жанре
SELECT mg.name, COUNT(ma.music_artist_id)
FROM genre_artist 
JOIN music_genre mg USING(music_genre_id)
JOIN music_artist ma USING(music_artist_id)
GROUP BY mg.name;

--количество треков, вошедших в альбомы 2019-2020 годов
SELECT m.name, COUNT(s.single_id)
FROM single s
JOIN music_album m USING(music_album_id)
WHERE m.year_of_release BETWEEN 2019 AND 2020
GROUP BY m.name;

--средняя продолжительность треков по каждому альбом
SELECT m.name, AVG(s.duration)
FROM single s
JOIN music_album m USING(music_album_id)
GROUP BY m.name;

--все исполнители, которые не выпустили альбомы в 2020 году
SELECT DISTINCT a.name
FROM album_artist 
JOIN music_album m USING(music_album_id)
JOIN music_artist a USING(music_artist_id)
EXCEPT
SELECT a.name
FROM album_artist 
JOIN music_album m USING(music_album_id)
JOIN music_artist a USING(music_artist_id) 
WHERE m.year_of_release = 2020;

--названия сборников, в которых присутствует конкретный исполнитель (выберите сами)
SELECT mc.name, s.name
FROM single_collection 
JOIN music_collection mc USING(music_collection_id)
JOIN single s USING(single_id) 
JOIN music_album USING(music_album_id)
JOIN album_artist USING(music_album_id)
JOIN music_artist ma USING(music_artist_id)
WHERE ma.name = 'Баста';


--название альбомов, в которых присутствуют исполнители более 1 жанра;
SELECT ma.name, mar.name, COUNT(mg.name) count_genre
FROM album_artist 
JOIN music_album  ma USING(music_album_id)
JOIN music_artist mar USING(music_artist_id)
JOIN genre_artist  USING(music_artist_id)
JOIN music_genre mg USING(music_genre_id)
GROUP BY ma.name, mar.name
HAVING COUNT(mg.name) > 1;

--наименование треков, которые не входят в сборники
SELECT s.name, single_id, music_collection_id
FROM single AS s
LEFT JOIN single_collection  USING(single_id)
WHERE music_collection_id IS NULL

--исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько)
SELECT m.name, s.name, duration 
FROM album_artist 
JOIN music_artist AS m USING(music_artist_id) 
JOIN music_album USING(music_album_id)
JOIN single s USING(music_album_id)
WHERE duration = (SELECT MIN(duration) FROM single);

--название альбомов, содержащих наименьшее количество треков
SELECT m.name, COUNT(music_album_id) AS count_single
FROM music_album AS m
JOIN single USING(music_album_id)
GROUP BY m.name
HAVING COUNT(music_album_id) IN (
SELECT MIN(a.count_single )
FROM (SELECT COUNT(music_album_id) AS count_single FROM music_album 
JOIN single USING(music_album_id)
GROUP BY music_album_id) AS a);


