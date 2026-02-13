import os 
configfile: "config/envbhv0.yml"

# Directory shortcuts
DATA_DIR = "data/"
LOG_DIR = "logs/"
TRIM_DIR = "results/trimmed-reads/"  # the path to our trimmed reads and reports
MEGA_DIR = "results/mega-directories/"
SPAD_DIR = "results/spade-directories/"
MINI_DIR = "results/maps"

def get_samples():      
      counter = 0
      pair_tracker = 0    
      samples = []
      
      #alphabetical to ensure pairs stay together
      files = sorted(os.listdir("data"))	

      with open("metadata_names.tsv", "w") as tsv_file:
        for filename in files:
          if filename.endswith('.fastq.gz'):
	     #paired-ends stay associated
             if pair_tracker == 2:
               counter += 1
               pair_tracker = 0

             tsv_file.write(f"{filename}\t{counter}\n")
             parts = filename.split('_')
             last_part = parts[-1].rsplit('.', 1)[0]
             modified_filename = f"{counter}_{last_part}.gz"		

             original_file_path = os.path.join("data", filename)
             new_file_path = os.path.join("data", modified_filename)
             os.rename(original_file_path, new_file_path)

             samples.append(f"{counter}")
             pair_tracker += 1
        return samples

# Get modified filenames
SAMPLES = get_samples()

#for sample in SAMPLES:
#    print(sample)

wildcard_constraints:
        sample = "\d+"

# Include the modular rule files
include: "rules/trim.smk"
include: "rules/spad.smk"
include: "rules/mega.smk"
include: "rules/mini.smk"

rule all:
         input:
               expand(os.path.join(TRIM_DIR, "{sample}_1_val_1.fq.gz"), sample=SAMPLES),
               expand(os.path.join(TRIM_DIR, "{sample}_2_val_2.fq.gz"), sample=SAMPLES),
               expand(os.path.join(MEGA_DIR, "{sample}"), sample=SAMPLES),
               expand(os.path.join(SPAD_DIR, "{sample}"), sample=SAMPLES),
               expand(os.path.join(MINI_DIR, "{sample}_mega.sam"), sample=SAMPLES),
               expand(os.path.join(MINI_DIR, "{sample}_spade.sam"), sample=SAMPLES)
