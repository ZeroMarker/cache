Class dbo.BDPackHandle Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BD_PackHandle, StorageStrategy = Default ]
{

/// Foreign Key FKBBBGCMGroup created via DDL
ForeignKey FKBDPackHandlePack(PackDR) References dbo.BDPack(PKBDPACK) [ SqlName = FK_BD_PackHandle_Pack ];

/// Foreign Key FKBBBGCMGroup created via DDL
ForeignKey FKBDPackHandleHandleWay(HandleWayDR) References dbo.BBHandleWay(PKBBHANDLEWAY) [ SqlName = FK_BD_PackHandle_HandleWay ];

/// Foreign Key FKBDAgreeFAddUser created via DDL
ForeignKey FKBDPackHandleAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PackHandle_AddUser ];

ForeignKey FKBDPackHandleOPUser(OPUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PackHandle_OPUser ];

ForeignKey FKBDPackHandleWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BD_PackHandle_WorkGroup ];

ForeignKey FKBDPackHandleLastUser(LastUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_BD_PackHandle_LastUser ];

Index IndexMaster On (PackDR, HandleWayDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

/// DDL Primary Key Specification
Index PKBDPACKHANDLE On RowID [ PrimaryKey, SqlName = PK_BDPACK_HANDLE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 血袋信息
Property PackDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 加工方式
Property HandleWayDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 登记日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 登记时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 登记用户
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 操作日期
Property OPDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 操作日期
Property OPTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 操作用户
Property OPUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 工作组
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 是否作废
Property IsCancel As %Library.Boolean [ SqlColumnNumber = 12 ];

/// 最后更新日期
Property LastDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 最后更新时间
Property LastTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 最后更新用户
Property LastUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="BDPackHandleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PackDR</Value>
</Value>
<Value name="3">
<Value>HandleWayDR</Value>
</Value>
<Value name="4">
<Value>AddDate</Value>
</Value>
<Value name="5">
<Value>AddTime</Value>
</Value>
<Value name="6">
<Value>AddUserDR</Value>
</Value>
<Value name="7">
<Value>OPDate</Value>
</Value>
<Value name="8">
<Value>OPTime</Value>
</Value>
<Value name="9">
<Value>OPUserDR</Value>
</Value>
<Value name="10">
<Value>WorkGroupDR</Value>
</Value>
<Value name="11">
<Value>IsCancel</Value>
</Value>
<Value name="12">
<Value>LastDate</Value>
</Value>
<Value name="13">
<Value>LastTime</Value>
</Value>
<Value name="14">
<Value>LastUserDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BDPackHandleD</DataLocation>
<DefaultData>BDPackHandleDefaultData</DefaultData>
<IdLocation>^dbo.BDPackHandleD</IdLocation>
<IndexLocation>^dbo.BDPackHandleI</IndexLocation>
<StreamLocation>^dbo.BDPackHandleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
