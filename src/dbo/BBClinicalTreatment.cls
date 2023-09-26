/// 临床处理情况
Class dbo.BBClinicalTreatment Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ClinicalTreatment, StorageStrategy = Default ]
{

/// Foreign Key FKBBClinicalTreatmentTreatTypeDR created via DDL
ForeignKey FKBBClinicalTreatmentTreatTypeDR(TreatTypeDR) References dbo.BBTreatType(PKBBTREATTYPE) [ SqlName = FK_BBClinicalTreatmentTreatTypeDR ];

Index IndexCode On Code [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On SeqNum [ SqlName = Index_SeqNum, Type = index ];

Index IndexTreatType On TreatTypeDR [ SqlName = Index_TreatType, Type = index ];

/// DDL Primary Key Specification
Index PKBBCLINICALTREATMENT On RowID [ PrimaryKey, SqlName = PK_BB_CLINICALTREATMENT, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Property TreatTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property DataType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BBClinicalTreatmentDefaultData">
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
<Value>SeqNum</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
<Value name="6">
<Value>TreatTypeDR</Value>
</Value>
<Value name="7">
<Value>DataType</Value>
</Value>
</Data>
<DataLocation>^dbo.BBClinicalTreatmentD</DataLocation>
<DefaultData>BBClinicalTreatmentDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBClinicalTreatmentD</IdLocation>
<IndexLocation>^dbo.BBClinicalTreatmentI</IndexLocation>
<StreamLocation>^dbo.BBClinicalTreatmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
