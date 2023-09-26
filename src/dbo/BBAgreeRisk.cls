///     
Class dbo.BBAgreeRisk Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_AgreeRisk, StorageStrategy = Default ]
{

/// Foreign Key FKBBAgreeHospital created via DDL
ForeignKey FKBBAgreeHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_Agree_Hospital ];

/// Foreign Key FKBBAgreeRisk created via DDL
ForeignKey FKBBAgreeRisk(RiskDR) References dbo.BBRisk(PKBBRISK) [ SqlName = FK_BB_Agree_Risk ];

Index IndexCode On (HospitalDR, RiskDR) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBAGREERISK On RowID [ PrimaryKey, SqlName = PK_BB_AGREERISK, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property RiskDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBAgreeRiskDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospitalDR</Value>
</Value>
<Value name="3">
<Value>RiskDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBAgreeRiskD</DataLocation>
<DefaultData>BBAgreeRiskDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BBAgreeRiskD</IdLocation>
<IndexLocation>^dbo.BBAgreeRiskI</IndexLocation>
<StreamLocation>^dbo.BBAgreeRiskS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
