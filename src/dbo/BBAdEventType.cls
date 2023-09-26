Class dbo.BBAdEventType Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_AdEventType, StorageStrategy = Default ]
{

/// Foreign Key FKBBBPorductHospital created via DDL
ForeignKey FKBBAdEventTypeHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_AdEventType_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBADEVENTTYPE On RowID [ PrimaryKey, SqlName = PK_BB_ADEVENTTYPE, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 危害说明  
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 5 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBAdEventTypeDefaultData">
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
<Value>Remark</Value>
</Value>
<Value name="5">
<Value>HospitalDR</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BBAdEventTypeD</DataLocation>
<DefaultData>BBAdEventTypeDefaultData</DefaultData>
<IdLocation>^dbo.BBAdEventTypeD</IdLocation>
<IndexLocation>^dbo.BBAdEventTypeI</IndexLocation>
<StreamLocation>^dbo.BBAdEventTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
