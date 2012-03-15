# exmaple configuration file

config :block do
  "example block config"
end

config :text, %{
  example text config
}

profile :yaml do
  config :example, %{
    ---
    name: Tommy
    age:  42
  }, :type=>:yaml
end

