/// 服务日志
Class dbo.OTServiceLog Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = OT_ServiceLog ]
{

Index IndexMaster On (IsSuccess, ServiceCode, AddDate, AddTime) [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKOTServiceLogLastOperUserDR created via DDL
ForeignKey FKOTServiceLogLastOperUserDR(LastOperUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_OTServiceLogLastOperUserDR ];

/// DDL Primary Key Specification
Index PKOTSERVICELOG On RowID [ PrimaryKey, SqlName = PK_OT_SERVICELOG, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 服务代码
Property ServiceCode As %Library.String(COLLATION = "EXACT", MAXLEN = 40) [ SqlColumnNumber = 3 ];

/// 服务名称
Property ServiceCName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 4 ];

/// 服务关键字
Property ServiceKeyWord As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 5 ];

/// 调用类
Property CallClass As %Library.String(COLLATION = "EXACT", MAXLEN = 120) [ SqlColumnNumber = 6 ];

/// 调用方法
Property CallMethod As %Library.String(COLLATION = "EXACT", MAXLEN = 60) [ SqlColumnNumber = 7 ];

/// P0
Property P0 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 8 ];

/// P1
Property P1 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 9 ];

/// P2
Property P2 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 10 ];

/// P3
Property P3 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 11 ];

/// P4
Property P4 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 12 ];

/// P5
Property P5 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 13 ];

/// P6
Property P6 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 14 ];

/// P7
Property P7 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 15 ];

/// P8
Property P8 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 16 ];

/// P9
Property P9 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 17 ];

/// P10
Property P10 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 18 ];

/// P11
Property P11 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 19 ];

/// P12
Property P12 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 20 ];

/// P13
Property P13 As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 21 ];

/// 会话
Property Sessions As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 22 ];

/// IP
Property IP As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 23 ];

/// 调用返回值
Property CallRet As %Library.String(COLLATION = "Exact", MAXLEN = 32678) [ SqlColumnNumber = 24 ];

/// 是否成功
Property IsSuccess As %Library.Boolean [ SqlColumnNumber = 25 ];

/// 添加日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 26 ];

/// 添加时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 27 ];

/// 最后操作日期
Property LastOperDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 28 ];

/// 最后操作时间
Property LastOperTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 29 ];

/// 最后操作人
Property LastOperUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 30 ];

/// 调用次数
Property CallNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 31 ];

/// 调用命名空间
Property NameSpace As %Library.String(COLLATION = "Exact", MAXLEN = 12) [ SqlColumnNumber = 32 ];

/// 入参格式类型，多个之间有逗号分隔
Property InputParamType As %String(MAXLEN = 2000) [ SqlColumnNumber = 33 ];

/// 返回值判断类
Property RetCheckClass As %String(MAXLEN = 100) [ SqlColumnNumber = 34 ];

Storage Default
{
<Data name="OTServiceLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ServiceCode</Value>
</Value>
<Value name="3">
<Value>ServiceCName</Value>
</Value>
<Value name="4">
<Value>ServiceKeyWord</Value>
</Value>
<Value name="5">
<Value>CallClass</Value>
</Value>
<Value name="6">
<Value>CallMethod</Value>
</Value>
<Value name="7">
<Value>P0</Value>
</Value>
<Value name="8">
<Value>P1</Value>
</Value>
<Value name="9">
<Value>P2</Value>
</Value>
<Value name="10">
<Value>P3</Value>
</Value>
<Value name="11">
<Value>P4</Value>
</Value>
<Value name="12">
<Value>P5</Value>
</Value>
<Value name="13">
<Value>P6</Value>
</Value>
<Value name="14">
<Value>P7</Value>
</Value>
<Value name="15">
<Value>P8</Value>
</Value>
<Value name="16">
<Value>P9</Value>
</Value>
<Value name="17">
<Value>P10</Value>
</Value>
<Value name="18">
<Value>P11</Value>
</Value>
<Value name="19">
<Value>P12</Value>
</Value>
<Value name="20">
<Value>P13</Value>
</Value>
<Value name="21">
<Value>Sessions</Value>
</Value>
<Value name="22">
<Value>IP</Value>
</Value>
<Value name="23">
<Value>CallRet</Value>
</Value>
<Value name="24">
<Value>IsSuccess</Value>
</Value>
<Value name="25">
<Value>AddDate</Value>
</Value>
<Value name="26">
<Value>AddTime</Value>
</Value>
<Value name="27">
<Value>LastOperDate</Value>
</Value>
<Value name="28">
<Value>LastOperTime</Value>
</Value>
<Value name="29">
<Value>LastOperUserDR</Value>
</Value>
<Value name="30">
<Value>CallNum</Value>
</Value>
<Value name="31">
<Value>NameSpace</Value>
</Value>
<Value name="32">
<Value>InputParamType</Value>
</Value>
<Value name="33">
<Value>OutputParamType</Value>
</Value>
<Value name="34">
<Value>RetCheckClass</Value>
</Value>
</Data>
<DataLocation>^dbo.OTServiceLogD</DataLocation>
<DefaultData>OTServiceLogDefaultData</DefaultData>
<IdLocation>^dbo.OTServiceLogD</IdLocation>
<IndexLocation>^dbo.OTServiceLogI</IndexLocation>
<StreamLocation>^dbo.OTServiceLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
