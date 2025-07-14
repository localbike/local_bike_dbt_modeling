{% macro hash_256(hash_column) %}
    TO_HEX(SHA256(LOWER(TRIM({{ hash_column }}))))
{% endmacro %}
