/// 标本类型
Class dbo.BTSpecimen Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_Specimen, StorageStrategy = Default ]
{

/// Foreign Key FKSpecimenClass created via DDL
ForeignKey FKSpecimenClass(SpecimenGroupDR) References dbo.BTSpecimenGroup(PKBTSPECIMENGROUP) [ SqlName = FK_SpecimenClass ];

/// Foreign Key FKSpecimenHospital created via DDL
ForeignKey FKSpecimenHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_SpecimenHospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTSPECIMEN On RowID [ PrimaryKey, SqlName = PK_BT_SPECIMEN, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 内部名称  
Property IName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 外部名称  
Property XName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 5 ];

/// 英文名称  
Property EName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// HIS对照码  
Property HISCode As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 8 ];

/// Whonet码  
Property WCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 9 ];

/// 标本组  
Property SpecimenGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 是否激活  {1:True,0:False}
Property Active As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 采集注意事项  
Property CollectPrompt As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 13 ];

/// Whonet类型  
Property WhonetType As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 14 ];

/// 标本归类（血，尿）
Property SpecimenType As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BTSpecimenDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>IName</Value>
</Value>
<Value name="4">
<Value>XName</Value>
</Value>
<Value name="5">
<Value>EName</Value>
</Value>
<Value name="6">
<Value>HospitalDR</Value>
</Value>
<Value name="7">
<Value>HISCode</Value>
</Value>
<Value name="8">
<Value>WCode</Value>
</Value>
<Value name="9">
<Value>SpecimenGroupDR</Value>
</Value>
<Value name="10">
<Value>Sequence</Value>
</Value>
<Value name="11">
<Value>Active</Value>
</Value>
<Value name="12">
<Value>CollectPrompt</Value>
</Value>
<Value name="13">
<Value>WhonetType</Value>
</Value>
<Value name="14">
<Value>SpecimenType</Value>
</Value>
</Data>
<DataLocation>^dbo.BTSpecimenD</DataLocation>
<DefaultData>BTSpecimenDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTSpecimenD</IdLocation>
<IndexLocation>^dbo.BTSpecimenI</IndexLocation>
<StreamLocation>^dbo.BTSpecimenS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
