Class dbo.BBReqTypeUrgency Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BB_ReqTypeUrgency, StorageStrategy = Default ]
{

/// Foreign Key FKBBAgreeHospital created via DDL
ForeignKey FKBBReqTypeUrgReqType(ReqTypeDR) References dbo.BBReqType(PKBBREQTYPE) [ SqlName = FK_BB_ReqTypeUrg_ReqType ];

ForeignKey FKBBReqTypeUrgUrgency(UrgencyDR) References dbo.BBUrgency(PKBBURGENCY) [ SqlName = FK_BB_ReqTypeUrg_Urgency ];

Index IndexMaster On (ReqTypeDR, UrgencyDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSeqNum On (ReqTypeDR, SeqNum) [ SqlName = Index_SeqNum, Type = index ];

/// DDL Primary Key Specification
Index PKBBREQTYPEURGENCY On RowID [ PrimaryKey, SqlName = PK_BB_REQTYPEURGENCY, Type = index, Unique ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 申请单类型  
Property ReqTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 输血紧急程度  
Property UrgencyDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Storage Default
{
<Data name="BBReqTypeUrgencyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ReqTypeDR</Value>
</Value>
<Value name="3">
<Value>UrgencyDR</Value>
</Value>
<Value name="4">
<Value>SeqNum</Value>
</Value>
</Data>
<DataLocation>^dbo.BBReqTypeUrgencyD</DataLocation>
<DefaultData>BBReqTypeUrgencyDefaultData</DefaultData>
<IdLocation>^dbo.BBReqTypeUrgencyD</IdLocation>
<IndexLocation>^dbo.BBReqTypeUrgencyI</IndexLocation>
<StreamLocation>^dbo.BBReqTypeUrgencyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
