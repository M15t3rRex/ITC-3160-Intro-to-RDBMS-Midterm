//1 Display the titles of all artworks located in ‘Gallery A’ whose estimated value is above 1,000,000. Use the location name (‘Gallery A’) as the condition, not the location_id. (10points) 
SELECT
    a.title,
    a.est_value
FROM
         mc_artwork a
    JOIN mc_location loc ON a.current_loc = loc.location_id
WHERE
    a.est_value > 1000000 AND loc.name = 'Gallery A';

//2 Retrieve the details of any exhibition whose total estimated value of included artworks exceeds 100,000,000. (10points) 
SELECT
    e.title,
    SUM(a.est_value)
FROM
         mc_exhibition e
    INNER JOIN mc_artwork_exh ae ON e.exhibition_id = ae.exhibition_id
    INNER JOIN mc_artwork     a ON a.artwork_id = ae.artwork_id
GROUP BY
    e.title
HAVING
    SUM(a.est_value) > 100000000;

//3 Assuming est_value reflects a 5-year insurance plan, find each artwork’s artwork_id, title, and its annual insured value (est_value / 5), rounded to two decimals. (10points) 
SELECT
    ROUND(a.est_value/5/2),
    a.artwork_id,
    a.title
FROM
    mc_artwork a;

//4 Display an alphabetical list (by artist name) of all artists whose artworks are included in the exhibition ‘Modern Voices’ (use the title as the condition), showing the artist full name and artwork title. (10points) 
SELECT
    ar.full_name
FROM
         mc_artist ar
    INNER JOIN mc_artwork     a ON a.artist_id = ar.artist_id
    INNER JOIN mc_artwork_exh ae ON a.artwork_id = ae.artwork_id
    INNER JOIN mc_exhibition  e ON e.exhibition_id = ae.exhibition_id
WHERE
    e.title = 'Modern Voices'
ORDER BY
    ar.full_name; 
    
//5 Display the titles of all artworks in the ‘Museum Permanent Collection’ whose est_value is above the average value within that same collection. (10points) 
SELECT
    a.title
FROM
         mc_artwork a
    INNER JOIN mc_collection col ON a.collection_id = col.collection_id
WHERE
        col.title = 'Museum Permanent Collection'
    AND a.est_value > (
        SELECT
            AVG(a.est_value)
        FROM
                 mc_artwork a
            INNER JOIN mc_collection col ON a.collection_id = col.collection_id
        WHERE
            col.title = 'Museum Permanent Collection'
    );

//6 Display the details of the exhibition with the minimum duration (measured as end_date - start_date) . (8points) 
SELECT
    *
FROM
    mc_exhibition
WHERE
    ( start_date - end_date ) = (
        SELECT
            MAX(start_date - end_date)
        FROM
            mc_exhibition
    );
    
//7 Display the titles of all artworks and their current location names for the exhibition with exhibition_id = 3001. (8points) 
SELECT
    a.title,
    loc.name
FROM
         mc_artwork a
    INNER JOIN mc_location    loc ON a.current_loc = loc.location_id
    INNER JOIN mc_artwork_exh ae ON a.artwork_id = ae.artwork_id
WHERE
    ae.exhibition_id = 3001;

//8 Display an alphabetical list (by artwork title) of the artwork titles and their label_text for any exhibition curated by ‘Maria Pappas’. Use the curator’s name parts ‘Maria’ and ‘Pappas’ as conditions, not the curator_id. (10points) 
SELECT
    a.title,
    ae.label_text
FROM
         mc_artwork a
    INNER JOIN mc_artwork_exh ae ON a.artwork_id = ae.artwork_id
    INNER JOIN mc_exhibition  e ON ae.exhibition_id = e.exhibition_id
    INNER JOIN mc_curator     cu ON e.curator_id = cu.curator_id
WHERE
    cu.full_name LIKE '%Maria%'
    AND cu.full_name LIKE '%Pappas%'
ORDER BY
    a.title;

//9 Create a view that lists each exhibition’s exhibition_id and title along with the artwork_id and artwork title of every artwork included in it. (12points) 
CREATE OR REPLACE VIEW ex9 AS (
SELECT e.exhibition_id, e.title AS title_e, a.artwork_id, a.title FROM mc_artwork a
    INNER JOIN mc_artwork_exh ae ON a.artwork_id = ae.artwork_id
    INNER JOIN mc_exhibition e ON ae.exhibition_id = e.exhibition_id);

//10 Using the view from Q9, find the number of exhibitions that artwork 1001 appears in. (12points) 
SELECT
    COUNT(artwork_id)
FROM
    ex9
WHERE
    artwork_id = 1001;
   