local lapis = require("lapis")
local Model = require("lapis.db.model").Model
local app_helpers = require("lapis.application")
local preload = require("lapis.db.model").preload
local validate = require("lapis.validate")
local capture_errors = app_helpers.capture_errors
local app = lapis.Application()
myluna = require 'lunajson'

app:get('/', function(self)
  local objecttoconvert = { ["/shares/?id "] = "db entry for table shares with id", ["/types/?id"] = "db entry for table types with id", ["/shares/delete/?id=12"] = "delete share id", ["/shares/create/?id=15&name=IPShares8&bid=33&ask=34&typeid=3"] = "create share id", ["/shares/update/?id=15&name=IPShares8&bid=33&ask=34&typeid=3"] = "update share id" }
  return { json = objecttoconvert, status = 200 } 
end)
app:get("/shares", function(self)
  local Shares = Model:extend("shares")
  local Equities = Shares.select("* from shares")
  return { Equities, status = 200 }
end)
app:get("/shares/read/:id", function(self)
  local shareid = self.params.id
  local shares = Model:extend("shares")
  local share = shares:find(shareid)

  if share then
    return { json = share, status = 200 }
  else
    return { json = { code = "404", message = "Share not found" }, status = 404 }
  end
end)

app:get("/types/read/:id", function(self)
  local typeid = self.params.id
  local types = Model:extend("types")
  local _type = types:find(typeid)

  if _type then
    return { json = _type, status = 200 }
  else
    return { json = { code = "404", message = "Type not found" }, status = 404 }
  end
end);
app:post("/shares/create/", capture_errors({
  on_error = function(self)
    return { json = { code = "400", message = "Error 400 wrong input" }, status = 400}
  end, 
  function(self)
    validate.assert_valid(self.params, {
      { "id", exists = true },
      { "name", exists = true },
      { "bid", exists = true },
      { "ask", exists = true },
      { "typeid", exists = true }
    })

    local Types = Model:extend("types")
    local typ = Types:find({id = self.params.typeid})

    if typ then
      local Shares = Model:extend("shares")
      local Share = Shares:create({
        id = self.params.id,
        name = self.params.name,
        bid = self.params.bid,
        ask = self.params.ask,
        typeid = self.params.typeid
      });

      return {
        json = Share,
        status = 201
      }
    end

    return { json = { code = "400", message = "Error 400 wrong execution" }, status = 400 }
  end
}));
app:post("/shares/delete/", capture_errors({
  on_error = function(self)
    return { json = { code = "400", message = "Error 400 wrong input" }, status = 400}
  end, 
  function(self)
    validate.assert_valid(self.params, {
      { "id", exists = true }
    })
    local Shares = Model:extend("shares")
    local Share = Shares:find(self.params.id)
    if (Share) then
      Share.delete()
      return {
        json = Share,
        status = 201
      }
    end

    return { json = { code = "400", message = "Error 400 wrong execution" }, status = 400 }
  end
}));
app:post("/shares/update/", capture_errors({
  on_error = function(self)
    return { json = { code = "400", message = "Error 400 wrong input" }, status = 400}
  end, 
  function(self)
    validate.assert_valid(self.params, {
      { "id", exists = true },
      { "name", exists = true },
      { "bid", exists = true },
      { "ask", exists = true },
      { "typeid", exists = true }
    })

    local Types = Model:extend("types")
    local typ = Types:find({id = self.params.typeid})

    if typ then
      local Shares = Model:extend("shares")
      local Share = Shares:find(self.params.id)
      local Share = Share:update({      
        id = self.params.id,
        name = self.params.name,
        bid = self.params.bid,
        ask = self.params.ask,
        typeid = self.params.typeid
      });

      return {
        json = Share,
        status = 201
      }
    end

    return { json = { code = "400", message = "Error 400 wrong execution" }, status = 400 }
  end
}));
return app