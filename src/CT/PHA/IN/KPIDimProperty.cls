/// CT_PHA_IN.KPIDimProperty
Class CT.PHA.IN.KPIDimProperty Extends (%Persistent, User.Abstract) [ SqlRowIdName = DimProp_RowID, SqlTableName = KPIDimProperty, StorageStrategy = ObjStorage ]
{

Relationship DimProParref As CT.PHA.IN.KPIDimension [ Cardinality = parent, Inverse = ChildDimProp, Required, SqlFieldName = DimPro_Parref ];

Property DimProCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = DimPro_Code ];

Property DimProDesc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DimPro_Desc ];

Property DimProExeCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = DimPro_ExeCode ];

Property DimProDefaultFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 5, SqlFieldName = DimPro_DefaultFlag ];

Index PropCodeI On (DimProParref, DimProCode As Exact);

Index PropDefaultI On (DimProParref, DimProDefaultFlag As Exact);

Storage ObjStorage
{
<Data name="KPIDimPropertyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DimProCode</Value>
</Value>
<Value name="3">
<Value>DimProDesc</Value>
</Value>
<Value name="4">
<Value>DimProExeCode</Value>
</Value>
<Value name="5">
<Value>DimProDefaultFlag</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("PROP")</DataLocation>
<DefaultData>KPIDimPropertyDefaultData</DefaultData>
<IdLocation>{%%PARENT}("PROP")</IdLocation>
<IndexLocation>^CT.PHA.IN.KPIDimI</IndexLocation>
<StreamLocation>^CT.PHA.IN.KPIDimS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
