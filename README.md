# 🚲 local_bike_dbt_project

## Overview

This dbt project models and transforms data from a bike store data lake to support advanced customer analytics and personalization metrics. The project is organized into a **three-tiered structure**:

```
models/
├── 01_staging
├── 02_intermediate
└── 03_mart
```

Each layer builds upon the previous one to progressively clean, enrich, and expose business-ready data.

## 📁 Project Structure

### `01_staging/`
- **Purpose**: Standardizes raw data from the data lake
- **Schemas**:
  - `stg_local_bike_data_lake`: Staging models for categories, products, orders, etc.
  - `stg_gender_lookups`: Normalizes gender-related dimension tables

### `02_intermediate/`
- **Purpose**: Transforms staged data into business logic models
- **Schema**: `int_local_bike_data_lake`
- **Examples**:
  - Join orders with products and customers
  - Compute basic aggregations like `total_orders`, `total_spent`, etc.

### `03_mart/`
- **Purpose**: Produces business-ready datasets for analytics and dashboards
- **Materialization**: `table`
- **Key Model**:
  - `mart_customer_360`: Customer-level metrics including:
    - Order and spend history
    - Product diversity (e.g., `category_diversity_score`)
    - Brand and category purchase counts

## 🔧 Configuration

The `dbt_project.yml` is set up with:

- **Model paths**: all models reside under `models/`
- **Profile**: `default`
- **Materializations**:
  - Views for staging and intermediate layers
  - Tables for the mart layer
- **Documentation settings**:
  - Enabled for relations and columns

## 📈 Key Model: `mart_customer_360`

This model aggregates multiple dimensions per customer:

| Column Name | Description |
|-------------|-------------|
| `customer_id` | Unique customer identifier |
| `total_orders` | Total number of orders |
| `total_spent` | Total monetary amount spent |
| `avg_order_value` | Average order value |
| `first_order_date` | Date of the first order |
| `last_order_date` | Date of the last order |
| `total_items_purchased` | Sum of all items bought |
| `store_name` | Store associated with customer |
| `store_city` / `store_state` | Location details of the store |
| `categories_purchased` | Count of distinct categories purchased |
| `brands_purchased` | Count of distinct brands purchased |
| `category_diversity_score` | Diversity index (0–1) = distinct categories bought ÷ total categories |

## ✅ Getting Started

1. **Install dependencies:**
   ```bash
   dbt deps
   ```

2. **Run the project:**
   ```bash
   dbt build
   ```

3. **View docs:**
   ```bash
   dbt docs generate && dbt docs serve
   ```

## 🧪 Testing & Quality

- Schema files (`.yml`) include metadata and documentation
- Columns and models are documented using `+persist_docs`
- Structure supports `dbt test`, `dbt docs`, and lineage

## 📊 Data Lineage

The project follows a clear data lineage:
- **Raw Data** → **Staging Layer** → **Intermediate Layer** → **Mart Layer**
- Each transformation is documented and tested
- Dependencies are clearly defined in model files

## 🎯 Use Cases

This project enables:
- **Customer Segmentation**: Based on purchase behavior and diversity scores
- **Personalization**: Leveraging customer 360 metrics
- **Business Intelligence**: Ready-to-use datasets for dashboards
- **Analytics**: Historical trends and customer lifetime value analys