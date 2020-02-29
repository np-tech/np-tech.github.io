---
layout: default
title: NPTechs
permalink: /nptechs/
---

{% layout layout: "jumbo_box" class: "nptechs" %}
# #NPTechs
Here is a list of some of curated #NPTech individuals.
{% endlayout %}

{% layout layout: "bootstrap/section" cname:"nopadding-bottom" %}
{% layout layout: "bootstrap/container" %}
{% layout layout: "bootstrap/row" %}

{% layout layout: "bootstrap/column" cname: "col-sm-12" %}
# header
some info
{% endlayout %}

{% endlayout %}
{% endlayout %}
{% endlayout %}


{% layout layout: "bootstrap/section" cname:"nopadding-top"  %}
{% layout layout: "bootstrap/container" cname:"flexbox" %}

{% assign people = site.nptechs | sort: 'lastname' %}
{% for person in people %}
{% include profile.html person=person %}
{% endfor %}

{% endlayout %}
{% endlayout %}