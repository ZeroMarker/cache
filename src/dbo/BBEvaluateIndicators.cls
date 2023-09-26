/// 申请单不合格评价指标
Class dbo.BBEvaluateIndicators Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_EvaluateIndicators, StorageStrategy = Default ]
{

/// Foreign Key FKBBEIHospital created via DDL
ForeignKey FKBBEIHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_EI_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBEVALUATEINDICATORS On RowID [ PrimaryKey, SqlName = PK_BB_EVALUATEINDICATORS, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 浓度水平  
Property LevelNo As %Library.SmallInt [ SqlColumnNumber = 6 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 是否合格
Property IsQualified As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BBEvaluateIndicatorsDefaultData">
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
<Value>LevelNo</Value>
</Value>
<Value name="6">
<Value>SeqNum</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>IsQualified</Value>
</Value>
</Data>
<DataLocation>^dbo.BBEvaluateIndicatorsD</DataLocation>
<DefaultData>BBEvaluateIndicatorsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBEvaluateIndicatorsD</IdLocation>
<IndexLocation>^dbo.BBEvaluateIndicatorsI</IndexLocation>
<StreamLocation>^dbo.BBEvaluateIndicatorsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
