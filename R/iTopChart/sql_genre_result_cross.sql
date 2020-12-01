/*genre and result*/

SELECT r.id, r.name,r.nation
FROM itunes_genre AS g, itunes_result AS r
WHERE g.id=r.id AND
  g.nation='australia' and
  g.type='movie'
GROUP BY r.id;