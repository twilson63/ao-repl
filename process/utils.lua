local utils = { _version = "0.0.1" }

utils.concat = function (a)
  return function (b) 
    assert(type(a) == "table", "first argument should be a table that is an array")
    assert(type(b) == "table", "second argument should be a table that is an array")
    local result = {}
    for i = 1, #a do
        result[#result + 1] = a[i]
    end
    for i = 1, #b do
        result[#result + 1] = b[i]
    end
    return result
  end
end

utils.reduce = function (fn)
  return function (initial)
    return function (t) 
      assert(type(fn) == "function", "first argument should be a function that accepts (result, value, key)")
      assert(type(t) == "table", "second argument should be a table that is an array")
      local result = initial
      for k, v in pairs(t) do
        if result == nil then
          result = v
        else
          result = fn(result, v, k)
        end
      end
      return result
    end
  end
end

utils.map = function (fn)
  assert(type(fn) == "function", "first argument should be a unary function")

  local function map (result, v, k)
    result[k] = fn(v)
    return result
  end

  return utils.reduce(map)({})
end

utils.filter = function (fn)
  assert(type(fn) == "function", "first argument should be a unary function")

  local function filter (result, v, _k)
    if fn(v) then
      table.insert(result, v)
    end
    return result
  end

  return utils.reduce(filter)({})
end

utils.find = function (fn)
  return function (t)
    assert(type(fn) == "function", "first argument should be a unary function")
    assert(type(t) == "table", "second argument should be a table that is an array")
    for _, v in pairs(t) do
      if fn(v) then
        return v
      end
    end
  end
end

utils.propEq = function (propName)
  return function (value)
    return function (object)
      assert(type(propName) == "string", "first argument should be a string")
      assert(type(value) == "string", "second argument should be a string")
      assert(type(object) == "table", "third argument should be a table<object>")
      return object[propName] == value
    end
  end
end

utils.compose = function(a,b) 
  return function (v) 
    return a(b(v))
  end
end

utils.prop = function (propName) 
  return function (object)
    return object[propName]
  end
end

return utils