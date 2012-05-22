module TranslationsHelper
  def js_translations(key)
    translations = I18n.backend.send(:translations)[I18n.locale]
    key.to_s.split('.').each do |k|
      translations = translations[k.to_sym]
    end
    translations.to_json
  end
end
