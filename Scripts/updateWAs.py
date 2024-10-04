import requests
from requests.auth import HTTPBasicAuth
import os

WAGO_API_ENDPOINT = "https://data.wago.io"

script_path = os.path.dirname(os.path.realpath(__file__))
mmwa_csv_path = os.path.join(script_path, "WAs.csv")
mmwa_path = os.path.join(script_path, "..", "WA")
mmwa_updates_path = os.path.join(script_path, "Updates.txt")
mmwa_was_path = os.path.join(mmwa_path, "MMWAs.lua")

# Read the csv file into a list of objects {namm, slug}
with open(mmwa_csv_path, "r") as f:
    csv = f.readlines()


# Read in a map of slugs to name, version, lua, and import
WAs = {}
for line in csv:
    name = line.split(",")[0].strip()
    uid = line.split(",")[1].strip()
    slug = line.split(",")[2].strip()
    version = line.split(",")[3].strip()
    wa = {
        "name": name,
        "uid" : uid,
        "version": version,
        "slug": slug,
    }
    # Push the object into the WAs list
    WAs[slug] = wa

def fetch_latest_version(endpoint, wa):
    # Fetch data from the endpoint using the API key
    print(f"Fetching data for {wa['name']} from {endpoint}")
    headers = {'User-Agent': 'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Mobile Safari/537.36'}
    response = requests.get(endpoint, headers=headers)
    if response.status_code == 200:
        data = response.json()      
        wa["name"] = data.get("name").replace(",", "")
        wa["id"] = data.get("_id")
        latest = data.get("versions").get("versions")[0]
        version = latest.get("version")
        versionString = latest.get("versionString")
        codeURL = data.get("codeURL")     

        print("-" * 40)
        print(f"Endpoint: {endpoint}")
        print(f"Name: {wa['name']}")
        print(f"Version: {latest}")
        print(f"Version String: {versionString}")
        print(f"Code URL: {codeURL}")
        print("-" * 40)

        endpoint = WAGO_API_ENDPOINT + codeURL
        response = requests.get(endpoint, headers=headers)
        if response.status_code == 200:        
            encoded = response.json().get("encoded")
            wa["embed"] = encoded
            wa["prvVersion"] = wa["version"]
            wa["version"] = version
            if int(version) > int(wa["prvVersion"]):
                wa["update"] = True
                return 1
        else:
            print(f"Failed to fetch data from {endpoint}. Status Code: {response.status_code}")
            return -1
        return 0
            
    else:
        print(f"Failed to fetch data from {endpoint}. Status Code: {response.status_code}")
        return -1

def main():
    # Iterate over each key value pair in the WAs dictionary
    updateFound = False
    for slug, wa in WAs.items():
        endpoint = WAGO_API_ENDPOINT + f'/lookup/wago?id={slug}'
        if fetch_latest_version(endpoint, wa) == 1:
            updateFound = True
            
    for slug, wa in WAs.items():
        if wa.get("update"):
            print(f"Updating {wa['name']} from {wa['prvVersion']} to {wa['version']}")
            # Write all update notes to file
            with open(mmwa_updates_path, "w") as f:
                f.write(f"{wa['name']} updated from {wa['prvVersion']} to {wa['version']}\n")

    if not updateFound:
        print("No updates found")
        with open(mmwa_updates_path, "a") as f:
                f.write("")
            
    # Write the updated json object to the list file
    with open(mmwa_was_path, "w") as f:
        f.write("MMWAs = {")
        i = 1
        for slug, wa in WAs.items():    
            f.write(f"\n\t[{i}] = {'{'}")
            f.write(f"\n\t\t[\"name\"] = \"{wa['name']}\",")
            f.write(f"\n\t\t[\"version\"] = {wa['version']},")
            f.write(f"\n\t\t[\"uid\"] = \"{wa['uid']}\",")           
            f.write(f"\n\t\t[\"embed\"] = \"{wa['embed']}\"")
            f.write("\n\t},")
            i += 1
        f.write("\r}")
        
    # Write the updated csv file
    with open(mmwa_csv_path, "w") as f:
        for slug, wa in WAs.items():
            f.write(f"{wa['name']}, {wa['uid']}, {slug}, {wa['version']}\n")  


    return 0

if __name__ == "__main__":
    main()