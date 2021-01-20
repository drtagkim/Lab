from sparqlutil import QueryBuilder

def test1():
	qb=QueryBuilder('http://data.visitkorea.or.kr/sparql') #end point
	results=qb.query("""
SELECT *
WHERE {
?resource a kto:Place ;
wgs:lat ?lat1 ;
wgs:long ?long ;
rdfs:label ?name .
FILTER contains(str(?name),'일민미술관')
}
LIMIT 10
""")
	return results
def test2():
	qb=QueryBuilder('http://data.visitkorea.or.kr/sparql')
	results=qb.query("""
SELECT ?name ?near_name ?distance
WHERE {
	ids:729811 wgs:lat ?lat1 ;
		wgs:long ?long1 ;
		rdfs:label ?name .
	(?near ?distance) geo:nearby(?lat1 ?long1 "1600") .
		?near rdfs:label ?near_name ;
	ktop:category ids:A05020100 .
	}
LIMIT 10
""")
	print(results)
	for r in results:
		name=r['name']['value']
		near_name=r['near_name']['value']
		distance=r['distance']['value']
		print('%s\t%s\t%s'%(name,near_name,distance,))
if __name__=="__main__":
	test2()
