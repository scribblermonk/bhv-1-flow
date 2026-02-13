rule trim:
    input:
        p1="data/{sample}_1.fastq.gz",
        p2="data/{sample}_2.fastq.gz"
    output:
        o1=os.path.join(TRIM_DIR, "{sample}_1_val_1.fq.gz"),
        o2=os.path.join(TRIM_DIR, "{sample}_2_val_2.fq.gz")
    threads: 4
    shell:
        "trim_galore -j {threads} --no_report_file --paired {input.p1} {input.p2} -o {TRIM_DIR}"

