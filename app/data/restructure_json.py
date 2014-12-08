#!/usr/bin/env python

import sys
import json

# {u'position': {u'y': 1097.33203125, u'x': 1724.5416259765625}, u'selected': False, u'data': {u'Viz_Family_Code': u'cau', u'Viz_Family_Name': u'Caucasian', u'Reference_Name': u'Abkhazian', u'Lang_Name': u'Abkhazian', u'id': u'4905', u'Status': u'A', u'Family_Name': u'Caucasian', u'Common_Twitter_Wiki_Code': u'ab', u'Primary_Family_Name': u'Caucasian', u'SUID': 4905, u'Final_Name': u'Abkhazian', u'selected': False, u'name': u'abk', u'__1': u'ab', u'__3': u'abk', u'__2': u'abk', u'shared_name': u'abk', u'Language_Type': u'L', u'Partner_Agency': u'JAC', u'Primary_Family_Code': u'cau', u'Documentation': u'SIL', u'Twitter_CLD_Only_Code': u'', u'__2_B': u'', u'Num_Speakers_M': 0.125, u'Element_Scope': u'I', u'Wiki_Only_Code': u'', u'LogNumSpeaker': 5.096910013008056, u'Family_Code': u'cau'}}
# {u'selected': False, u'data': {u'interaction': u'pp', u'TargetPopulations': 82772, u'target': u'4904', u'TargetLanguageName': u'Russian', u'SUID': 5450, u'Tstatistic': 8.59922041, u'selected': False, u'PhiCorrelation': 0.02699584, u'source': u'4905', u'SourceLanguageName': u'Abkhazian', u'SourcePopulation': 171, u'Coocurrences': 106, u'shared_interaction': u'pp', u'shared_name': u'abk (pp) rus', u'id': u'5450', u'name': u'abk (pp) rus'}}

def main():
	types = ['books', 'twitter', 'wikipedia']

	for type in types:
		final_data = []
		final_nodes = []
		final_edges = []

		data = json.load(open('%s_raw.json' % type))
		nodes = data['elements']['nodes']
		edges = data['elements']['edges']

		# Iterate through nodes
		for node in nodes:
			temp_node = node['position']
			temp_node['id'] = node['data']['id']
			final_nodes.append(temp_node)

			temp_datum = node['data']
			temp_datum['Family Name'] = temp_datum['Viz_Family_Name']
			temp_datum['Number of Speakers (millions)'] = 0.5 * temp_datum.get('Num_Speakers_M', 1)
			temp_datum['Log(Number of Speakers)'] = 0.5 * temp_datum.get('LogNumSpeaker', 1)
			final_data.append(temp_datum)

		# Iterate through edges
		min_co = sys.maxint
		max_co = -sys.maxint - 1

		min_t = sys.maxint
		max_t = -sys.maxint - 1
		for edge in edges:
			t = edge['data']['Tstatistic']
			if t > max_t:
				max_t = t
			if t < min_t:
				min_t = t

			co = edge['data']['Coocurrences']
			if co > max_co:
				max_co = co
			if co < min_co:
				min_co = co


		for edge in edges:
			temp_edge = edge['data']
			temp_edge['source'] = edge['data']['source']  # ['SourceLanguageName']
			temp_edge['target'] = edge['data']['target'] # ['TargetLanguageName']
			temp_edge['opacity'] = edge['data']['Tstatistic'] / max_t
			# temp_edge['size'] = 1000000000 * float(edge['data']['Coocurrences']) / max_co
			temp_edge['size'] = edge['data']['Coocurrences']
			temp_edge['coocurrences'] = edge['data']['Coocurrences']
			final_edges.append(temp_edge)

		final_object = {'data': final_data, 'nodes': final_nodes, 'edges': final_edges}

		output = open('%s_formatted.json' % type, 'w')
		output.write(json.dumps(final_object))
		output.close()


if __name__ == '__main__':
	main()
