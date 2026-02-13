rule mini:
    input:
       mega = os.path.join(MEGA_DIR, "{sample}"),
       spade = os.path.join(SPAD_DIR, "{sample}")        
    output:
       mega_sam = os.path.join(MINI_DIR, "{sample}_mega.sam"),
       spade_sam = os.path.join(MINI_DIR, "{sample}_spade.sam")
    params:
        ref=config["reference"]
    threads: 32
    shell:
        """
        minimap2 -ax asm5 -t {threads} {params.ref} "{input.mega}"/final.contigs.fa > {output.mega_sam}
        minimap2 -ax asm5 -t {threads} {params.ref} "{input.spade}"/contigs.fasta > {output.spade_sam}
        """