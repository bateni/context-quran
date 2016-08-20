#!/usr/local/bin/python

input_prefix = 'raw-'         # raw-99.txt
output_prefix = 'quran-text-' # quran-text-99.tex 
input_meta_data  = 'raw-meta.txt'
output_meta_data = 'quran-meta.lua'
verses_per_chunk = 100

# todo: read other meta information, e.g., chapter names

verses_in_chapter = {}

for chap in range(1,115):
    print 'Processing chapter', chap
    f = open(output_prefix + str(chap) + '.tex', 'w')
    ver = 0
    for line in open(input_prefix + str(chap) + '.txt'):
        line = line.decode('utf-8')
        line = line.strip('\n')
        ver = ver + 1
        if len(line) == 0:
            print 'error in verse', ver, 'of chapter', chap
        f.write('\\startbuffer[\\q:%d:%d]\n' % (chap, ver))
        f.write(line.encode('utf-8') + '\n')
        f.write('\\stopbuffer\n')
    verses_in_chapter[chap] = ver
    f.close()

print verses_in_chapter
f = open(output_meta_data, 'w')
f.write('return {\n')
f.write('  chapters = {\n')
for k,v in verses_in_chapter.iteritems():
    basmalah = 'true'
    if k == 1 or k == 10:
        basmalah = 'false'
    print k, v
    f.write('    [%d] = { basmalah = "%s", name = "%s", verses = %d, }\n' % (k, basmalah, '', v))
f.write('  }\n')
f.write('}\n')
f.close()
