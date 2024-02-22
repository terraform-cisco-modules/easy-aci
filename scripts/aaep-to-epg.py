#!/usr/bin/env python3
def prRed(skk): print("\033[91m {}\033[00m" .format(skk))
import os, sys
script_path= os.path.dirname(os.path.realpath(sys.argv[0]))
sys.path.insert(0, f'{script_path}{os.sep}classes')
try:
    from classes import ezfunctions
    from dotmap import DotMap
    from operator import itemgetter
    import argparse, json, yaml
except ImportError as e:
    prRed(f'!!! ERROR !!!\n{e.__class__.__name__}')
    prRed(f" Module {e.name} is required to run this script")
    prRed(f" Install the module using the following: `pip install {e.name}`")
    sys.exit(1)

class MyDumper(yaml.Dumper):
    def increase_indent(self, flow=False, indentless=False):
        return super(MyDumper, self).increase_indent(flow, False)

def cli_arguments():
    Parser = argparse.ArgumentParser(description='Parsing JSON for AAEP to EPG Mappings')
    Parser.add_argument( '-j', '--json-file',                       help = 'The input JSON File.' )
    kwargs = DotMap()
    kwargs.args = Parser.parse_args()
    return kwargs


def main():
    kwargs = cli_arguments()
    #==============================================
    # Process the YAML input File
    #==============================================
    if (kwargs.args.json_file):
        jdict = DotMap(json.load(open(os.path.join(kwargs.args.json_file), 'r')))
    ydict = DotMap(yaml.safe_load(open(os.path.join('./interfaces.eza.yaml'), 'r')))
    aaepdict = ydict.access.policies['global'].attachable_access_entity_profiles
    adict = []
    for item in jdict.imdata:
        i = item.infraAttEntityP.attributes
        idict = dict(access_or_native_vlan = [], allowed_vlans = [], description = i.descr, infra_vlan = False,
                      instrumentation_immediacy = 'on-demand', name = i.name, physical_domains = [])
        vlans = []
        for children in item.infraAttEntityP.children:
            for k, v in children.items():
                if k == 'infraGeneric':
                    for e in v.children:
                        vlan_id = int((e.infraRsFuncToEpg.attributes.encap).split('-')[1])
                        vlans.append(vlan_id)
                        if e.infraRsFuncToEpg.attributes.mode == 'native': idict['access_or_native_vlan'].append(vlan_id)
        if len(idict['access_or_native_vlan']) == 1: idict['access_or_native_vlan'] = idict['access_or_native_vlan'][0]
        elif len(idict['access_or_native_vlan']) == 0: idict['access_or_native_vlan'] = 1
        else:
            print(f"Native VLAN List for {idict['name']} is {idict['access_or_native_vlan']}")
        idict['allowed_vlans'] = str(ezfunctions.vlan_list_format(vlans))
        if not idict['name'] == 'default':
            indx = next((index for (index, d) in enumerate(aaepdict) if d['name'] == idict['name']), None)
            if indx == None: print(idict)
            else:
                #print(aaepdict[indx])
                if aaepdict[indx].get('physical_domains'): idict['physical_domains'] = aaepdict[indx].physical_domains
                adict.append(idict)
    adict = sorted(adict, key=itemgetter('name'))
    print('checking physical domains')
    for e in adict:
        if len(e['physical_domains']) == 0: print(e)
    fdict = {'access':{'policies':{'global':{'attachable_access_entity_profiles':adict}}}}
    dest_dir = './'
    dest_file = 'example.eza.yaml'
    if not os.path.exists(os.path.join(dest_dir, dest_file)):
        create_file = f'type nul >> {os.path.join(dest_dir, dest_file)}'
        os.system(create_file)
    wr_file = open(os.path.join(dest_dir, dest_file), 'w')
    wr_file.write('---\n')
    wr_file = open(os.path.join(dest_dir, dest_file), 'a')
    dash_length = '='*(len('Tenants -> TNT-MICHMED') + 20)
    wr_file.write(f'#{dash_length}\n')
    wr_file.write(f'#   Tenants -> TNT-MICHMED - Variables\n')
    wr_file.write(f'#{dash_length}\n')
    wr_file.write(yaml.dump(fdict, Dumper=MyDumper, default_flow_style=False))
    wr_file.close()

if __name__ == '__main__':
    main()
