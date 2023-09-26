Class dbo.RPCheckRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_CheckRecord ]
{

/// Foreign Key FKRPCheckRecordWorkGroupMachineDR created via DDL
ForeignKey FKRPCheckRecordWorkGroupMachineDR(WorkGroupMachineDR) References dbo.BTWorkGroupMachine(PKBTWORKGROUPMACHINE) [ SqlName = FK_RPCheckRecordWorkGroupMachineDR ];

/// Foreign Key FKRPCheckRecordVisitNumberDR created via DDL
ForeignKey FKRPCheckRecordVisitNumberDR(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER) [ SqlName = FK_RPCheckRecordVisitNumberDR ];

/// Foreign Key FKRPCheckRecordSaveUserDR created via DDL
ForeignKey FKRPCheckRecordSaveUserDR(SaveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPCheckRecordSaveUserDR ];

/// Foreign Key FKRPCheckRecordThrustExecDR created via DDL
ForeignKey FKRPCheckRecordThrustExecDR(ThrustExecDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPCheckRecordThrustExecDR ];

/// Foreign Key FKRPCheckRecordMachReviewExecDR created via DDL
ForeignKey FKRPCheckRecordMachReviewExecDR(MachReviewExecDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RPCheckRecordMachReviewExecDR ];

/// DDL Primary Key Specification
Index PKRPCheckRecord On RowID [ PrimaryKey, SqlName = PK_RP_CheckRecord, Type = index, Unique ];

Index IndexMaster On (VisitNumberDR, WorkGroupMachineDR, OrderNo) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSaveDate On (WorkGroupMachineDR, SaveDate) [ SqlName = Index_SaveDate, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 标本
Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 工作小组
Property WorkGroupMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 序号*	
Property OrderNo As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 推片
Property Thrust As %Library.Boolean [ SqlColumnNumber = 6 ];

/// 分类镜检相符
Property Microscopy As %Library.Boolean [ SqlColumnNumber = 7 ];

/// 未见幼稚细胞
Property NoBlasts As %Library.Boolean [ SqlColumnNumber = 8 ];

/// 白细胞总数相符
Property WBC As %Library.Boolean [ SqlColumnNumber = 9 ];

/// 血小板镜检相符
Property PLT As %Library.Boolean [ SqlColumnNumber = 10 ];

/// 内容
Property Context As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 11 ];

/// 上机复检
Property MachReview As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 状态复检
Property SpStatus As %Library.Boolean [ SqlColumnNumber = 13 ];

/// 图形复检
Property GraphReview As %Library.Boolean [ SqlColumnNumber = 14 ];

/// 保存人
Property SaveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 保存日期
Property SaveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 保存时间
Property SaveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 推片执行人
Property ThrustExecDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 推片执行日期
Property ThrustExecDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 推片执行时间
Property ThrustExecTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 复查执行人
Property MachReviewExecDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 复查执行日期
Property MachReviewExecDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 复查执行时间
Property MachReviewExecTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 尿白细胞
Property UrineWBC As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 24 ];

/// 尿红细胞
Property UrineRBC As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 25 ];

/// 尿管型
Property UrineCast As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 26 ];

/// 尿结晶
Property UrineCrystal As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 27 ];

/// 尿酵母菌
Property UrineXtal As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 28 ];

/// 尿上皮细胞
Property UrineUEC As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 29 ];

/// 尿其他
Property UrineOTH As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 30 ];

Storage Default
{
<Data name="RPCheckRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>WorkGroupMachineDR</Value>
</Value>
<Value name="4">
<Value>OrderNo</Value>
</Value>
<Value name="5">
<Value>Thrust</Value>
</Value>
<Value name="6">
<Value>Microscopy</Value>
</Value>
<Value name="7">
<Value>NoBlasts</Value>
</Value>
<Value name="8">
<Value>WBC</Value>
</Value>
<Value name="9">
<Value>PLT</Value>
</Value>
<Value name="10">
<Value>Context</Value>
</Value>
<Value name="11">
<Value>MachReview</Value>
</Value>
<Value name="12">
<Value>SpStatus</Value>
</Value>
<Value name="13">
<Value>GraphReview</Value>
</Value>
<Value name="14">
<Value>SaveUserDR</Value>
</Value>
<Value name="15">
<Value>SaveDate</Value>
</Value>
<Value name="16">
<Value>SaveTime</Value>
</Value>
<Value name="17">
<Value>ThrustExecDR</Value>
</Value>
<Value name="18">
<Value>ThrustExecDate</Value>
</Value>
<Value name="19">
<Value>ThrustExecTime</Value>
</Value>
<Value name="20">
<Value>MachReviewExecDR</Value>
</Value>
<Value name="21">
<Value>MachReviewExecDate</Value>
</Value>
<Value name="22">
<Value>MachReviewExecTime</Value>
</Value>
<Value name="23">
<Value>UrineWBC</Value>
</Value>
<Value name="24">
<Value>UrineRBC</Value>
</Value>
<Value name="25">
<Value>UrineCast</Value>
</Value>
<Value name="26">
<Value>UrineCrystal</Value>
</Value>
<Value name="27">
<Value>UrineXtal</Value>
</Value>
<Value name="28">
<Value>UrineUEC</Value>
</Value>
<Value name="29">
<Value>UrineOTH</Value>
</Value>
</Data>
<DataLocation>^dbo.RPCheckRecordD</DataLocation>
<DefaultData>RPCheckRecordDefaultData</DefaultData>
<IdLocation>^dbo.RPCheckRecordD</IdLocation>
<IndexLocation>^dbo.RPCheckRecordI</IndexLocation>
<StreamLocation>^dbo.RPCheckRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
