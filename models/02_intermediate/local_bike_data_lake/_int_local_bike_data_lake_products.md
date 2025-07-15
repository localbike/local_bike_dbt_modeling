{% docs int_local_bike_data_lake__products %}

## Description

This model provides an **enriched view of products** by joining product details with their associated **brand**, **category**, and current **stock quantity**. It serves as a core dimension table for analytics related to product catalog, inventory, and product segmentation.

## Data Sources

- `stg_local_bike_data_lake__products`: Base product information.
- `stg_local_bike_data_lake__categories`: Category labels for each product.
- `stg_local_bike_data_lake__brands`: Brand names associated with each product.
- `stg_local_bike_data_lake__stocks`: Current stock levels per product.

## Fields

| Field | Description |
|-------|-------------|
| `product_id` | Unique identifier for the product. |
| `product_name` | Product's full name (may include model and year). |
| `product_gender` | Target gender segment for the product (e.g., Male, Female, Unisex). |
| `brand_id` | Foreign key to the brand. |
| `brand_name` | Name of the brand associated with the product. |
| `category_id` | Foreign key to the category. |
| `category_name` | Descriptive name of the product category (e.g., Road, Mountain, Kids). |
| `model_year` | The year the product model was released. |
| `list_price` | The listed price of the product. |
| `product_quantity` | The current quantity in stock for the product. |

## Use Cases

- Building a product dimension table for downstream marts.
- Analyzing product assortment and availability.
- Joining with sales or orders to understand product performance.

## Notes

- The model uses `DISTINCT` to ensure no duplicate records, which can occur due to joins with the `stocks` table.
- This model is typically used in conjunction with sales or order data to compute KPIs like product conversion rate, inventory turnover, etc.

---

Souhaitez-vous que je génère également un `description` block pour le fichier `.yml` DBT (pour les docs dans `dbt docs` et lineage) ?


{% enddocs %}