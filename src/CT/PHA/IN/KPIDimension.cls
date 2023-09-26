/// 2022.3 
Class CT.PHA.IN.KPIDimension Extends (%Persistent, User.Abstract) [ SqlRowIdName = Dim_RowID, SqlTableName = KPIDimension, StorageStrategy = ObjStorage ]
{

Relationship ChildDimProp As CT.PHA.IN.KPIDimProperty [ Cardinality = children, Inverse = DimProParref ];

/// Hosp医院院/PLoc药房科室/AdmLoc就诊科室/AdmType就诊类型/StkCatGrp库存类组/User人员/PWin发药窗口
/// 代码
Property DimCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = Dim_Code ];

/// 描述
Property DimDesc As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = Dim_Desc ];

/// 执行代码
Property DimExeCode As %String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = Dim_ExeCode ];

/// 创建日期
Property DimUpdateDate As %Date [ SqlColumnNumber = 5, SqlFieldName = Dim_UpdateDate ];

/// 备注
Property DimRemark As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = Dim_Remark ];

Index CodeI On DimCode As Exact;

Storage ObjStorage
{
<Data name="KPIDimensionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DimCode</Value>
</Value>
<Value name="3">
<Value>DimDesc</Value>
</Value>
<Value name="4">
<Value>DimExeCode</Value>
</Value>
<Value name="5">
<Value>DimUpdateDate</Value>
</Value>
<Value name="6">
<Value>DimRemark</Value>
</Value>
</Data>
<DataLocation>^CT.PHA.IN.KPIDimD</DataLocation>
<DefaultData>KPIDimensionDefaultData</DefaultData>
<IdLocation>^CT.PHA.IN.KPIDimD</IdLocation>
<IndexLocation>^CT.PHA.IN.KPIDimI</IndexLocation>
<StreamLocation>^CT.PHA.IN.KPIDimS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
