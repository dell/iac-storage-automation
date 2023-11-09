import json

with open('../output-json/api_output.json') as f:
    data = json.load(f)

for item in data['json']['AttributeGroups'][0]['SubAttributeGroups']:
    
    #if item['DisplayName'].find("Email") >-1:
        print('\n')
        print(item['DisplayName'])
        print('-------------------------')
        for subitem in item['Attributes']:
            print(subitem['DisplayName'])
        
