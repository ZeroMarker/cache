/// 采集部位
Class dbo.BTAnatomicalSite Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_AnatomicalSite, StorageStrategy = Default ]
{

/// Foreign Key FKAnatomicalSiteHospital created via DDL
ForeignKey FKAnatomicalSiteHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_AnatomicalSiteHospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSequence On (HospitalDR, Sequence) [ SqlName = Index_Sequence, Type = index ];

/// DDL Primary Key Specification
Index PKBTANATOMICALSITE On RowID [ PrimaryKey, SqlName = PK_BT_ANATOMICALSITE, Type = index, Unique ];

/// 状态  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 序号  
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 状态  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BTAnatomicalSiteDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>HospitalDR</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTAnatomicalSiteD</DataLocation>
<DefaultData>BTAnatomicalSiteDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTAnatomicalSiteD</IdLocation>
<IndexLocation>^dbo.BTAnatomicalSiteI</IndexLocation>
<StreamLocation>^dbo.BTAnatomicalSiteS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
