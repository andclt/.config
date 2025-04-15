require("andclt.mappings")
require("andclt.lazy_init")
require("andclt.set")
local helpers = require("andclt.helpers")

-- I keep work specific configuration in a private work repo and connect it via symlinks.
if helpers.isModuleAvailable("andclt.stripe") then
  require("andclt.stripe").setup()
end
