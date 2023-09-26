Class dhc.bonus.module.DrgsItem Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlRowIdName = DrgsItemID ]
{

//项目编码

Property DrgsCode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3 ];

//项目名称

Property DrgsName As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4 ];

//上级指标ID

Property SuperDrgsID As dhc.bonus.module.DrgsItem [ SqlColumnNumber = 5 ];

//CMI权重

Property CMIRate As %Library.Float [ SqlColumnNumber = 6 ];

//费率

Property CostRate As %Library.Float [ SqlColumnNumber = 7 ];

//是否有效

Property IsValid As %Library.Integer [ SqlColumnNumber = 8 ];

//更新日期

Property UpdateDate As %Library.Date [ SqlColumnNumber = 9 ];

//末级标志

Property LastStage As %Library.Integer [ Required, SqlColumnNumber = 10 ];

Index DrgsCode On DrgsCode As Exact;

Storage Default
{
<Data name="DrgsItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DrgsCode</Value>
</Value>
<Value name="3">
<Value>DrgsName</Value>
</Value>
<Value name="4">
<Value>CMIRate</Value>
</Value>
<Value name="5">
<Value>CostRate</Value>
</Value>
<Value name="6">
<Value>IsValid</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>SuperDrgsID</Value>
</Value>
<Value name="9">
<Value>LastStage</Value>
</Value>
</Data>
<DataLocation>^dhcbsmoduleDrgsItemD</DataLocation>
<DefaultData>DrgsItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcbsmoduleDrgsItemD</IdLocation>
<IndexLocation>^dhcbsmoduleDrgsItemI</IndexLocation>
<StreamLocation>^dhcbsmoduleDrgsItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
