describe "Inflector", ->
  describe "sluggify", ->
    it "should not change lowercased English word", ->
      expect(Inflector.sluggify "foo").toEqual "foo"

    it "should downcase and transliterate Latvian word", ->
      expect(Inflector.sluggify "Glāžšķūņu Rūķītis").toEqual "glazskunu-rukitis"
