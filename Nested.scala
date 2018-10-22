val stringDf = spark.createDataset((Seq("{  \r\n    \"a\":\"a1\",\r\n    \"balances\":[  \r\n        {  \r\n            \"ba\":\"ba1\",\r\n            \"financeAccountRollup\":{  \r\n                \"fara\":\"fara1\"\r\n            }\r\n        },\r\n        {  \r\n            \"ba\":\"ba1\",\r\n            \"financeAccountRollup\":{  \r\n                \"farb\":\"farb1\"\r\n            }\r\n        }\r\n    ],\r\n    \"clients\":{  \r\n        \"cbb\":\"cbb1\"\r\n    }\r\n}"))).toDF("string_data")



val originalSchema  = StructType(
      Array(
        StructField("a", StringType),
        StructField("balances", ArrayType(StructType(Array(
          StructField("ba", StringType),
          StructField("financeAccountRollup", ArrayType(StructType(Array(StructField("farb", StringType)))))
        ))))
      )
    )
val nestedDf = stringDf.select(from_json($"string_data", originalSchema)).toDF("json_data")
