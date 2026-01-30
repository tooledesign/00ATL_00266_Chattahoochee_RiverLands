
# This script will set up templates for various types of analysis in your
# project folder and in the project database. It is designed to be run from
# an Anaconda prompt. It will create analysis directories under whichever folder
# your prompt is in so under most circumstances you would want to run this with
# the prompt in your main project folder.
import os, sys
import argparse
from tooles.project_template import folder_template, make_recommendations_table
from tooles.project_template.folder import replace_text_in_file


def main(argv):
    parser = argparse.ArgumentParser(description="Set up templates for various types of analysis in your project folder and in the project database.")
    parser.add_argument("-f",dest="dir",help="Folder to create the template in (defaults to current directory)")
    parser.add_argument("-H",dest="host",help="Database host")
    parser.add_argument("-d",dest="db",help="Database name")
    parser.add_argument("--nodb",dest="nodb",action="store_true",help="Don't create datasets in the database")
    parser.add_argument("--nofolder",dest="nofolder",action="store_true",help="Don't create templates in the project folder")
    parser.add_argument("--bna",dest="bna",action="store_true",help="Include the BNA folder template")
    parser.add_argument("--lts",dest="lts",action="store_true",help="Include the LTS folder template")
    parser.add_argument("--crash",dest="crash",action="store_true",help="Include the crashes folder template")
    parser.add_argument("--conflation",dest="conflation",action="store_true",help="Include the conflation folder template")
    parser.add_argument("--web",dest="web",action="store_true",help="Include the website template")
    parser.add_argument("--srid",dest="srid",help="SRID for the project")
    parser.add_argument("--style",dest="style",help="Recommendation style one of ['standard','california',nostyle] or a list")
    args = parser.parse_args()

    # set vars
    dir = args.dir if args.dir else os.getcwd()
    host = args.host if args.host else None
    db = args.db if args.db else None
    nodb = args.nodb if args.nodb else False
    nofolder = args.nofolder if args.nofolder else False
    bna = args.bna if args.bna else False
    lts = args.lts if args.lts else False
    crash = args.crash if args.crash else False
    conflation = args.conflation if args.conflation else False
    srid = args.srid if args.srid else None
    style = args.style if args.style else 'standard'

    # validate
    if not nodb and (host is None or db is None):
        raise ValueError("Host and db name are required")

    # process
    analysis_type = []
    if bna + lts + crash + conflation == 0:
        analysis_type = None
    else:
        if bna:
            analysis_type.append("bna")
        if lts:
            analysis_type.append("lts")
        if crash:
            analysis_type.append("crash")
        if conflation:
            analysis_type.append("conflation")
        if web:
            analysis_type.append("web")

    if not nofolder:
        folder_proceed = input("Will create template folders at {}. Proceed? (y/n) ".format(dir))
        if folder_proceed.lower().strip() == 'y':
            folder_template(dir=dir,analysis_type=analysis_type,srid=srid,host=host,db=db)

    if not nodb:
        db_proceed = input("Will create tdg_bikeways table on {} in {} database. Proceed? (y/n) ".format(host,db))
        if db_proceed.lower().strip() == 'y':
            make_recommendations_table(host=host,db_name=db,srid=srid,style=style)


if __name__ == "__main__":
    main(sys.argv[1:])
