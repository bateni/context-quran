if not modules then modules = { } end modules ['p-quran-text'] = {
    version   = 1.001,
    comment   = "companion to p-quran-text.mkiv",
    author    = "Mohammad Hossein Bateni",
    copyright = "Mohammad Hossein Bateni",
    license   = "GNU General Public License v3"
}

moduledata.qurantext     = moduledata.database     or { }

local qurantext = moduledata.qurantext

local function init(name)
  qurantext.data = dofile(resolvers.findfile('quran-meta.lua'))
  qurantext.psum = {}
  local psum = 0
  for chap, info in ipairs(qurantext.data.chapters) do
    psum = psum + info.verses
    qurantext.psum[chap] = psum
  end
end

local function error(msg)
  print('quran-text error:', msg)
end

-- TODO: add initializer with cache on lua side
local function loadversechunk(name,chap,ver)
  local my_chap = qurantext.data.chapters[chap]
  if not my_chap then
    error('invalid chapter number ' .. chap)
    return
  end
  if ver < 1 or ver > my_chap.verses then
    error('invalid verse number ' .. ver .. ' in chapter ' .. chap)
    return
  end
  local global_verse = qurantext.psum[chap - 1] or 0
  global_verse = global_verse + ver - 1
  local chunk = math.floor(global_verse / qurantext.data.verses_per_chunk)
  context.begingroup()
  context("\\def\\q{quran-text}")
  context.input('quran-text-' .. chunk .. '.tex')
  context.endgroup()  
end

qurantext.loadversechunk = loadversechunk

init('')
