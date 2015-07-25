import os

from whoosh.index import create_in
from whoosh.fields import *
from whoosh.analysis.filters import LowercaseFilter
from whoosh.analysis import IDAnalyzer
from whoosh.analysis.tokenizers import RegexTokenizer
from whoosh.query import *

current_dir_path = os.path.dirname(os.path.realpath(__file__))

def field_booster(fieldname, factor=2.0):
   def booster_fn(obj):
     if obj.is_leaf() and obj.field() == fieldname:
       obj = obj.copy()
       obj.boost *= factor
       return obj
     else:
       return obj
   return booster_fn

def PropertiesTokenizedKeyAnalyzer():
  return RegexTokenizer(r"[_\.]+", True) | LowercaseFilter()

def SearchPhraseAnalyzer():
  return RegexTokenizer(r"[_\. ]+", True) | LowercaseFilter()

class PropertyIndexer(object):
  def __init__(self, docs):
    self.schema = Schema(
      file=ID(
        stored=True
      ),
      key=ID(
        stored=True,
        field_boost=1000.0,
        analyzer=IDAnalyzer(lowercase=True)
      ),
      tokenized=TEXT(
        analyzer=PropertiesTokenizedKeyAnalyzer()
      ),
    )

    self.index_dir = self._create_index_dir("indexes")
    self.index = self._create_index()
    self._add_documents(docs)

    self.search_analyzer = SearchPhraseAnalyzer()

  def _create_index_dir(self, index_dir):
    index_dir_path = os.path.join(current_dir_path, index_dir)
    if not os.path.exists(index_dir_path):
      os.makedirs(index_dir_path)

    return index_dir_path

  def _create_index(self):
    return create_in(self.index_dir, self.schema)

  def _add_documents(self, docs):
    writer = self.index.writer()

    for doc in docs:
      prop_file = unicode(doc[0])
      prop_key = unicode(doc[1])
      writer.add_document(file=prop_file, key=prop_key, tokenized=prop_key)

    writer.commit()

  def search(self, s):
    s = unicode(s.strip().lower())

    if not s:
      return []

    with self.index.searcher() as searcher:
      tokens = [token.text for token in self.search_analyzer(s)]

      query1 = And([Prefix("tokenized", token) for token in tokens])
      query2 = And([FuzzyTerm("tokenized", token, maxdist=2, prefixlength=1) for token in tokens])
      query3 = Prefix("key", s)
      query = Or([query3, query1, query2])

      results = searcher.search(query)

      ret = []
      for hit in results:
        ret.append(hit.fields())

      return ret