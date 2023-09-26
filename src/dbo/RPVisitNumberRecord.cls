/// 标本操作记录
Class dbo.RPVisitNumberRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberRecord, StorageStrategy = Default ]
{

Index IndexMaster On (VisitNumberDR, OperateDate, OperateTime) [ SqlName = Index_Master, Type = index ];

Index IndexOperateDate On (OperateDate, OperateTypeDR) [ SqlName = Index_OperateDate, Type = index ];

Index IndexOperateType On (VisitNumberDR, OperateTypeDR) [ SqlName = Index_OperateType, Type = index ];

Index IndexOptTypeWorkGroup On (VisitNumberDR, OperateTypeDR, WorkGroupDR) [ SqlName = Index_OptTypeWorkGroup, Type = index ];

/// DDL Primary Key Specification
Index PKRPVISITNUMBERRECORD On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERRECORD, Type = index, Unique ];

/// Foreign Key FKVisitNumberRecord created via DDL
ForeignKey FKVisitNumberRecord(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_VisitNumberRecord ];

/// Foreign Key FKVisitNumberRecordOpType created via DDL
ForeignKey FKVisitNumberRecordOpType(OperateTypeDR) References dbo.BTOperatorType(PKBTOPERATORTYPE) [ SqlName = FK_VisitNumberRecordOpType ];

/// Foreign Key FKVisitNumberRecordOperator created via DDL
ForeignKey FKVisitNumberRecordOperator(OperateUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_VisitNumberRecordOperator ];

/// Foreign Key FKVisitNumberRecordRejectType created via DDL
ForeignKey FKVisitNumberRecordRejectType(RejectTypeDR) References dbo.BTRejectType(PKBTREJECTTYPE) [ SqlName = FK_VisitNumberRecordRejectType ];

/// Foreign Key FKVisitNumberRecordWorkGroup created via DDL
ForeignKey FKVisitNumberRecordWorkGroup(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_VisitNumberRecordWorkGroup ];

ForeignKey FKVisitNumberRecordWG(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_VisitNumberRecordWG ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本  
Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 操作日期  
Property OperateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 操作时间  
Property OperateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 操作者  
Property OperateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 操作说明  
Property OperateNotes As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

/// 操作类型  
Property OperateTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 工作小组  
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 标本拒收类型  
Property RejectTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// IP地址  
Property IPAddress As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 12 ];

/// 报告主键  
Property VisitNumberReportID As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 13 ];

Storage Default
{
<Data name="RPVisitNumberRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>OperateDate</Value>
</Value>
<Value name="4">
<Value>OperateTime</Value>
</Value>
<Value name="5">
<Value>OperateUserDR</Value>
</Value>
<Value name="6">
<Value>OperateNotes</Value>
</Value>
<Value name="7">
<Value>OperateTypeDR</Value>
</Value>
<Value name="8">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="9">
<Value>RejectTypeDR</Value>
</Value>
<Value name="10">
<Value>WorkGroupDR</Value>
</Value>
<Value name="11">
<Value>IPAddress</Value>
</Value>
<Value name="12">
<Value>VisitNumberReportID</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberRecordD</DataLocation>
<DefaultData>RPVisitNumberRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberRecordD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberRecordI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
