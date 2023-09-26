Class dbo.RPTransit Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_Transit, StorageStrategy = Default ]
{

Index IndexTransitNo On TransitNo [ SqlName = Index_TransitNo, Type = index, Unique ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexStatus On (Status, AddDate) [ SqlName = Index_Status, Type = index ];

Index IndexLocation On (LocationDR, AddDate) [ SqlName = Index_Location, Type = index ];

Index IndexToWorkGroup On (ToWorkGroupDR, AddDate) [ SqlName = Index_ToWorkGroup, Type = index ];

Index IndexArriveDate On ArriveDate [ SqlName = Index_ArriveDate, Type = index ];

Index IndexReceiveDate On ReceiveDate [ SqlName = Index_ReceiveDate, Type = index ];

Index IndexContainerNo On (ContainerNo, AddDate) [ SqlName = Index_ContainerNo, Type = index ];

Index PKRPTRANSIT On RowID [ PrimaryKey, SqlName = PK_RP_TRANSIT, Type = index, Unique ];

/// Foreign Key FKTransitLocation created via DDL
ForeignKey FKTransitLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_TransitLocation ];

/// Foreign Key FKTransitWorkGroupDR created via DDL
ForeignKey FKTransitToWorkGroup(ToWorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_TransitToWorkGroup ];

/// Foreign Key FKTransitAddUser created via DDL
ForeignKey FKTransitAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TransitAddUser ];

/// Foreign Key FKTransitArriveUser created via DDL
ForeignKey FKTransitArriveUser(ArriveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TransitArriveUser ];

/// Foreign Key FKTransitRecWorkGroup created via DDL
ForeignKey FKTransitRecWorkGroup(RecWorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_TransitRecWorkGroup ];

/// Foreign Key FKTransitReceiveUser created via DDL
ForeignKey FKTransitReceiveUser(ReceiveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TransitReceiveUser ];

/// Foreign Key FKTransitArrWindow created via DDL
ForeignKey FKTransitArrWindow(ArrWindowDR) References dbo.BTWindow(PKBTWINDOW) [ SqlName = FK_TransitArrWindow ];

/// Foreign Key FKTransitOpenUser created via DDL
ForeignKey FKTransitOpenUser(OpenUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_TransitOpenUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 运送单号
Property TransitNo As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 运送科室
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 送往工作组
Property ToWorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 容器编号
Property ContainerNo As %Library.String(COLLATION = "EXACT", MAXLEN = 15) [ SqlColumnNumber = 6 ];

/// 备注
Property Remark As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 7 ];

/// 创建日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 创建时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 创建用户
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 完成状态 1:未完成,2:部分完成（部分送达）,3:完成（送达）,4:接收，5：开箱
Property Status As %Library.String(COLLATION = "EXACT", MAXLEN = 1) [ SqlColumnNumber = 11 ];

/// 送达日期
Property ArriveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 送达时间
Property ArriveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 送达人
Property ArriveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 接收工作组
Property RecWorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 接收日期
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 接收时间
Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 接收人
Property ReceiveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 交接说明
Property Notes As %Library.String(COLLATION = "EXACT", MAXLEN = 200) [ SqlColumnNumber = 19 ];

/// 送达窗口
Property ArrWindowDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 开箱日期
Property OpenDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 开箱时间
Property OpenTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 开箱人
Property OpenUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 23 ];

/// 标本采集类型 1：Normal常规标本，2：Mix混采标本
Property CollectType As %Library.String(COLLATION = "EXACT", MAXLEN = 1) [ SqlColumnNumber = 24 ];

Storage Default
{
<Data name="RPTransitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TransitNo</Value>
</Value>
<Value name="3">
<Value>LocationDR</Value>
</Value>
<Value name="4">
<Value>ToWorkGroupDR</Value>
</Value>
<Value name="5">
<Value>ContainerNo</Value>
</Value>
<Value name="6">
<Value>Remark</Value>
</Value>
<Value name="7">
<Value>AddDate</Value>
</Value>
<Value name="8">
<Value>AddTime</Value>
</Value>
<Value name="9">
<Value>AddUserDR</Value>
</Value>
<Value name="10">
<Value>Status</Value>
</Value>
<Value name="11">
<Value>ArriveDate</Value>
</Value>
<Value name="12">
<Value>ArriveTime</Value>
</Value>
<Value name="13">
<Value>ArriveUserDR</Value>
</Value>
<Value name="14">
<Value>RecWorkGroupDR</Value>
</Value>
<Value name="15">
<Value>ReceiveDate</Value>
</Value>
<Value name="16">
<Value>ReceiveTime</Value>
</Value>
<Value name="17">
<Value>ReceiveUserDR</Value>
</Value>
<Value name="18">
<Value>Notes</Value>
</Value>
<Value name="19">
<Value>ArrWindowDR</Value>
</Value>
<Value name="20">
<Value>OpenDate</Value>
</Value>
<Value name="21">
<Value>OpenTime</Value>
</Value>
<Value name="22">
<Value>OpenUserDR</Value>
</Value>
<Value name="23">
<Value>CollectType</Value>
</Value>
</Data>
<DataLocation>^dbo.RPTransitD</DataLocation>
<DefaultData>RPTransitDefaultData</DefaultData>
<IdLocation>^dbo.RPTransitD</IdLocation>
<IndexLocation>^dbo.RPTransitI</IndexLocation>
<StreamLocation>^dbo.RPTransitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
