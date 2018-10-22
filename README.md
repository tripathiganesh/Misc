# Misc
In Nested.scala 
stringDf is the raw nested json
originalSchema is the schema of the json
nestedDf is the nested dataframe
```
scala> nestedDf.printSchema()
root
 |-- json_data: struct (nullable = true)
 |    |-- a: string (nullable = true)
 |    |-- balances: array (nullable = true)
 |    |    |-- element: struct (containsNull = true)
 |    |    |    |-- ba: string (nullable = true)
 |    |    |    |-- financeAccountRollup: array (nullable = true)
 |    |    |    |    |-- element: struct (containsNull = true)
 |    |    |    |    |    |-- farb: string (nullable = true)
 
 ```
 
 ```
 
 scala> nestedDf.dropNestedColumn("json_data.balances.financeAccountRollup.farb").printSchema()
root
 |-- json_data: struct (nullable = false)
 |    |-- a: string (nullable = true)
 |    |-- balances: struct (nullable = false)
 |    |    |-- ba: array (nullable = true)
 |    |    |    |-- element: string (containsNull = true)
 |    |    |-- financeAccountRollup: struct (nullable = false)
```
