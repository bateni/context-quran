if not modules then modules = { } end modules ['p-quran-text'] = {
    version   = 1.010,
    comment   = "companion to p-quran-text.mkiv",
    author    = "Mohammad Hossein Bateni",
    copyright = "Mohammad Hossein Bateni",
    license   = "GNU General Public License v3"
}

moduledata.qurantext           = moduledata.database            or {}
moduledata.qurantext.instances = moduledata.qurantext.instances or {}

local qurantext = moduledata.qurantext
local instances = qurantext.instances

-- Lua does not need to know the name of the construct.
-- It only processes the meta data from the prefix.
local function init(prefix)
   if instances[prefix] then
      return
   end
   metafile = resolvers.findfile(prefix .. '-meta.lua')
   if not metafile or metafile == '' then
      error('bad prefix ' .. prefix)
      return
   end
   instances[prefix] = dofile(metafile)
   local instance = instances[prefix]

   instance.psum = {}
   local psum = 0
   for chap, info in ipairs(instance.chapters) do
      psum = psum + info.verses
      instance.psum[chap] = psum
   end
end

local function error(msg)
  print('quran-text error:', msg)
end


local function loadversechunk(prefix,chap,ver)
   init(prefix)
   local instance = instances[prefix]
   if not instance then
      return
   end
   local my_chap = instance.chapters[chap]
   if not my_chap then
      error('invalid chapter number ' .. chap)
      return
   end
   if ver < 1 or ver > my_chap.verses then
      error('invalid verse number ' .. ver .. ' in chapter ' .. chap)
      return
   end
   local global_verse = instance.psum[chap - 1] or 0
   global_verse = global_verse + ver - 1
   local chunk = math.floor(global_verse / instance.verses_per_chunk)
   context.begingroup()
   context("\\def\\q{" .. prefix .. "-text}")
   context.input(prefix .. '-text-' .. chunk .. '.tex')
   context.endgroup()  
end

qurantext.loadversechunk = loadversechunk

