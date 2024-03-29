Gem::Specification.new do |s|
  s.name        = "cama_contact_form"
  s.version     = "0.0.23"
  s.authors     = ["Owen Peredo"]
  s.email       = ["owenperedo@gmail.com"]
  s.homepage    = ""
  s.summary     = "Contact Form Plugin for Camaleon CMS"
  s.description = "Permit to create unlimited of contact forms for Camaleon CMS"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "httparty", "0.15.6"
  s.add_dependency "stripe", "~> 3.11.0"
  s.add_development_dependency "sqlite3"
end
