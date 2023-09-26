Class dbo.BBSpecialReqReason Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_SpecialReqReason ]
{

/// Foreign Key FKBBAgreeHospital created via DDL
ForeignKey FKBBSpecialReqReasonHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BB_SpecialReqReason_Hospital ];

Index IndexCode On (HospitalDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSeqNum On (HospitalDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBSPECIALREQREASON On RowID [ PrimaryKey, SqlName = PK_BB_SPECIALREQREASON, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码  
Property Code As %Library.String(MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 名称  
Property CName As %Library.String(MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 激活  {1:是,0:否}
Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Storage Default
{
<Data name="BBSpecialReqReasonDefaultData">
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
<Value>HospitalDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BBSpecialReqReasonD</DataLocation>
<DefaultData>BBSpecialReqReasonDefaultData</DefaultData>
<IdLocation>^dbo.BBSpecialReqReasonD</IdLocation>
<IndexLocation>^dbo.BBSpecialReqReasonI</IndexLocation>
<StreamLocation>^dbo.BBSpecialReqReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
