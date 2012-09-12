class stack::database {
  include postgres
  #class{ 'postgres': stage => setup_infra; }
}
