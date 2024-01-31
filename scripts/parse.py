#!/usr/bin/env python3
def prRed(skk): print("\033[91m {}\033[00m" .format(skk))
import os, sys
script_path= os.path.dirname(os.path.realpath(sys.argv[0]))
sys.path.insert(0, f'{script_path}{os.sep}classes')
try:
    from dotmap import DotMap
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
    Parser = argparse.ArgumentParser(description='Intersight Converged Infrastructure Deployment Module')
    Parser.add_argument( '-y', '--yaml-file',                       help = 'The input YAML File.' )
    kwargs = DotMap()
    kwargs.args = Parser.parse_args()
    return kwargs


def main():
    kwargs = cli_arguments()
    #==============================================
    # Process the YAML input File
    #==============================================
    if (kwargs.args.yaml_file):
        yfile = open(os.path.join(kwargs.args.yaml_file), 'r')
        ydict = DotMap(yaml.safe_load(yfile))
    count = 0
    tcount = 0
    for i in ydict.tenants:
        for e in i.networking.bridge_domains:
            if e.vlans:
                ydict.tenants[tcount].networking.bridge_domains[count].application_epg.vlans = e.vlans
                ydict.tenants[tcount].networking.bridge_domains[count].pop('vlans')
            count += 1
        tcount += 1
    #print(json.dumps(ydict, indent=4))
    ydict = ydict.toDict()
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
    wr_file.write(yaml.dump(ydict, Dumper=MyDumper, default_flow_style=False))
    wr_file.close()

if __name__ == '__main__':
    main()
