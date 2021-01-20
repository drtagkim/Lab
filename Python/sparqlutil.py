from SPARQLWrapper import SPARQLWrapper, JSON
class QueryBuilder:
	def __init__(self,url:str):
		self.init_url=url
		self.sq=SPARQLWrapper(url)
		self.prefix=[
			"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>",
			"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>",
			"PREFIX owl: <http://www.w3.org/2002/07/owl#>",
			"PREFIX xsd: <http://www/w3.org/2001/XMLSchema#>",
			"PREFIX wgs: <http://www.w3.org/2003/01/geo/wgs84_pos#>",
			"PREFIX skos: <http://www.w3.org/2004/02/skos/core#>",
			"PREFIX foaf: <http://xmlns.com/foaf/0.1>",
			"PREFIX dc: <http://purl.org/dc/elements/1.1/>",
			"PREFIX kto: <http://data.visitkorea.or.kr/ontology/>",
			"PREFIX ktop: <http://data.visitkorea.or.kr/property/>",
			"PREFIX ids: <http://data.visitkorea.or.kr/resource/>",
			"PREFIX vi: <http://www.saltlux.com/transformer/views#>",
			"PREFIX geo: <http://www.saltlux.com/geo/property#>",
			"PREFIX pf: <http://www.saltlux.com/DARQ/property#>"
		]
	def add_prefix(self,namespace:str,uri:str):
		new_prefix='PREFIX %s: <%s>'%(namespace,uri)
		self.prefix.append(new_prefix)
	def query(self,q):
		sparql=self.sq
		prefix="\n".join(self.prefix)
		query="%s\n%s"%(prefix,q)
#print(query)
		sparql.setQuery(query)
		sparql.setReturnFormat(JSON)
		results=sparql.query().convert()
		hasOutput="results" in results
		if hasOutput:
			hasOutput=hasOutput & ("bindings" in results['results'])
		if hasOutput:
			return results['results']['bindings']
		return None

