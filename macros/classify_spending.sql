{% macro classify_spending(spending_type, category, subcategory) %}
    CASE
        -- Essential Food
        WHEN spending_type = 'Kebutuhan' AND category = 'Food' AND subcategory IN ('Breakfast', 'Lunch', 'Dinner', 'Beverages') THEN 'Essential Food'
        
        -- Discretionary Food
        WHEN spending_type = 'Keinginan' AND category = 'Food' AND subcategory IN ('Lunch', 'Dinner', 'Beverages') THEN 'Discretionary Food'
        
        -- Essential Transport
        WHEN spending_type = 'Kebutuhan' AND category = 'Transportation' AND subcategory IN ('Fuel', 'Motorcycle', 'Subway', 'Toll', 'Parking', 'Online Ride') THEN 'Essential Transport'
        
        -- Discretionary Transport
        WHEN spending_type = 'Keinginan' AND category = 'Transportation' AND subcategory IN ('Toll', 'Motorcycle', 'Parking', 'Taxi', 'Online Ride') THEN 'Discretionary Transport'
        
        -- Home & Living
        WHEN spending_type = 'Kebutuhan' AND category = 'Household' THEN 'Home & Living'
        
        -- Home Upgrades
        WHEN spending_type = 'Keinginan' AND category = 'Household' THEN 'Home Upgrades'
        
        -- Personal Care
        WHEN spending_type = 'Kebutuhan' AND category IN ('Beauty', 'Health', 'Apparel') THEN 'Personal Care'
        
        -- Pet Care
        WHEN spending_type = 'Keinginan' AND category = 'Pet' THEN 'Pet Care'
        
        -- Entertainment & Culture
        WHEN spending_type = 'Keinginan' AND category IN ('Culture', 'Communication, PC') AND subcategory IN ('Games', 'Apps', 'Music', 'Books', 'Sports', 'E-Books') THEN 'Entertainment & Culture'
        
        -- Connectivity
        WHEN spending_type = 'Kebutuhan' AND category = 'Communication, PC' AND subcategory IN ('Internet', 'Accessories') THEN 'Connectivity'
        
        -- Relationships & Social
        WHEN spending_type = 'Keinginan' AND category = 'Relationship' THEN 'Relationships & Social'
        
        -- Essential Giving
        WHEN spending_type = 'Kebutuhan' AND category IN ('Gift', 'Relationship') AND subcategory IN ('Charity', 'Parents', 'Friend') THEN 'Essential Giving'
        
        -- Wedding Preps
        WHEN spending_type = 'Keinginan' AND category = 'Life' AND subcategory = 'Wedding Preps' THEN 'Wedding Preps'
        
        -- Travel & Leisure
        WHEN spending_type = 'Keinginan' AND category = 'Life' AND subcategory IN ('Travel', 'Massage, Therapy') THEN 'Travel & Leisure'
        
        -- Work & Tools
        WHEN category = 'Life' AND subcategory = 'Work' THEN 'Work & Tools'
        
        -- Savings
        WHEN spending_type = 'Tabungan' THEN 'Savings'
        
        -- Other
        ELSE 'Other'
    END
{% endmacro %}