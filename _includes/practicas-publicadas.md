
<ol>
{%- for practica in site.practicas -%}
  {%- if practica.visible -%}
<li> 
  <a href="{{ practica.url }}">Descripción de la Práctica {{ practica.title }}</a>
  
</li>
  {%- endif -%}
{%- endfor -%}
</ol>
