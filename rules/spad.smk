rule spad:
    input:
        p1=os.path.join(TRIM_DIR, "{sample}_1_val_1.fq.gz"),
        p2=os.path.join(TRIM_DIR, "{sample}_2_val_2.fq.gz")
    output:
        outdir=directory(os.path.join(SPAD_DIR, "{sample}"))
    shell:
        "spades.py --isolate -1 {input.p1} -2 {input.p2} -o {output.outdir}"