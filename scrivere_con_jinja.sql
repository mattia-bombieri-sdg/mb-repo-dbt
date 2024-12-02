/*
-- comemnti in Jinjia
{# ... #}

-- codice Jinjia
{% ... %}
{-% ... %}
{% ... %-}
{-% ... %-}

-- specie di ptint() per ... che sono variabili costruite in set
{{ ... }}

-- tutto ciò che non è scritto in {} è stampato

-- costruzione di variabili
{% set nome_variabile = {
	corpo della variabile
}
%}

-- cicli for
{% for condizione_del_ciclo_for %}
	corpo del ciclo for
{% endfor %}

-- condizionale if
{% if condizione_del_blocco_if %}
	corpo della condizione if
{%%}
	corpo della condizione else
{% endif %}

-- Oss: il codice Jinjia non ha bisogno di , però se messo in codice SQL bisogna stare attenti
		a quando si è in cicli for, consigliato mettere queste righe di codice:
		{%- if not loop.last -%}, {% endif -%}

*/

/*
-- ALCUNI ESEMPI PRATICI
{#
{% for i in range (10) %}
    select {{i}} as number {% if not loop.last %} union all {% endif %}
{% endfor %}


{% set person = {
    ‘name’: ‘me’,
    ‘number’: 3
} %}
{{ person.name }}
--stampa: me
{{ person[‘number’] }}
--stampa: 3



{% set self = [‘me’, ‘myself’] %}
{{ self[0] }}
--stampa: me


{% set temperature = 80.0 %}
On a day like this, I especially like
{% if temperature > 70.0 %}
    a refreshing mango sorbet.
{% else %}
    A decadent chocolate ice cream.
{% endif %}
--stampa: On a day like this, I especially like a refreshing mango sorbet


{% set flavors = [‘chocolate’, ‘vanilla’, ‘strawberry’] %}
{% for flavor in flavors %}
    Today I want {{ flavor }} ice cream!
{% endfor %}
--stampa: 

Today I want chocolate ice cream!
Today I want vanilla ice cream!
Today I want strawberry ice cream!



{% macro hoyquiero(flavor, dessert = ‘ice cream’) %}
    Today I want {{ flavor }} {{ dessert }}!
{% endmacro %}
{{ hoyquiero(flavor = ‘chocolate’) }}
--stampa: Today I want chocolate ice cream!
{{ hoyquiero(mango, sorbet) }}
--stampa: Today I want mango sorbet!
#}
-- Codice SQL originale
with

    payments as (
		select
			*
		from
			{{ ref("stg_payments") }}
	),
	
    final as (
        select
            order_id,
            sum(
                case when payment_method = 'bank_transfer' then amount else 0 end
            ) as bank_transfer_amount,
            sum(
                case when payment_method = 'credit_card' then amount else 0 end
            ) as credit_card_amount,
            sum(
                case when payment_method = 'coupon' then amount else 0 end
            ) as coupon_amount,
            sum(
                case when payment_method = 'gift_card' then amount else 0 end
            ) as gift_card_amount

        from < code class = "language-sql" > payments < / code >
        group by 1
    )
select *
from
    final

    -- stesso codice con l'aiuto di Jinjia
    {%- set payment_methods = [
        "bank_transfer",
        "credit_card",
        "coupon",
        "gift_card",
    ] -%}
with
    payments as (select * from {{ ref("stg_payments") }}),
    final as (
        select
            order_id,
            {% for payment_method in payment_methods -%}
                sum(
                    case
                        when payment_method = '{{ payment_method }}' then amount else 0
                    end
                ) as {{ payment_method }}_amount
                {%- if not loop.last -%}, {% endif -%}
            {%- endfor %}
        from < code class = "language-sql" > payments < / code >
        group by 1
    )
select *
from final
*/