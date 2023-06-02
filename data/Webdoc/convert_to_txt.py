import argparse
import os
from resiliparse.extract.html2text import extract_plain_text



if __name__ == '__main__':

    parser = argparse.ArgumentParser()
    parser.add_argument("-i", "--input_folder", default="crawl/warc", help="The folder where files would be input")
    parser.add_argument("-o", "--output_folder", default="crawl/txt", help="The folder where files would be output")

    args = parser.parse_args()

    input_folder = args.input_folder
    output_folder = args.output_folder

    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # iterate over subfolders
    for subfolder in os.listdir(input_folder):
        print("converting", subfolder)
        subfolder_path = os.path.join(input_folder, subfolder)
        out_path = os.path.join(output_folder, subfolder)
        if not os.path.exists(out_path):
            os.makedirs(out_path)
        if os.path.isdir(subfolder_path):
            # iterate over files in subfolder
            for filename in os.listdir(subfolder_path):
                input_file = os.path.join(subfolder_path, filename)
                output_file = os.path.join(output_folder, subfolder, filename + ".txt")
                with open(input_file, "r") as f:
                    in_file = f.read()
                txt = extract_plain_text(in_file, preserve_formatting=False,  alt_texts=False)
                with open(output_file, "w") as f:
                    f.write(txt)

        else:
            print("skipping", subfolder)