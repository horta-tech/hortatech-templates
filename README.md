# COMO USAR OS TEMPLATES:

## Basta executar o código abaixo, substituindo "name" pelo nome do projeto


# RAILS BASE TEMPLATE

### - Componentes Horta
### - Bootstrap 4
### - Webpack

```
rails new \
  -T \
  --database postgresql \
  --webpack \
  --skip-coffee \
  --skip-turbolinks \
  --skip-spring \
  -m https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/templates/base-template.rb \
  name
```


# RAILS BASE REACT TEMPLATE

### - Componentes Horta
### - Bootstrap 4
### - Webpack
### - React

```
rails new \
  -T \
  --database postgresql \
  --webpack=react \
  --skip-coffee \
  -m https://raw.githubusercontent.com/rayancastro/hortatech-templates/master/templates/base-react-template.rb \
  name
```
