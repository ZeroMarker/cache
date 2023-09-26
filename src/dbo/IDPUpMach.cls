/// 上机记录
Class dbo.IDPUpMach Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = IDP_UpMach ]
{

Index IndexMaster On IDPResultDR [ SqlName = Index_Master, Type = index ];

/// Foreign Key FKIDPUpMachIDPResultDR created via DDL
ForeignKey FKIDPUpMachIDPResultDR(IDPResultDR) References dbo.IDPResult(PKIDPRESULT) [ SqlName = FK_IDPUpMachIDPResultDR ];

/// Foreign Key FKIDPUpMachIDPMachDR created via DDL
ForeignKey FKIDPUpMachIDPMachDR(IDPMachDR) References dbo.BTIDPMach(PKBTIDPMACH) [ SqlName = FK_IDPUpMachIDPMachDR ];

/// Foreign Key FKIDPUpMachIDPSlatsDR created via DDL
ForeignKey FKIDPUpMachIDPSlatsDR(IDPSlatsDR) References dbo.BTIDPSlats(PKBTIDPSLATS) [ SqlName = FK_IDPUpMachIDPSlatsDR ];

/// Foreign Key FKIDPUpMachUpUserDR created via DDL
ForeignKey FKIDPUpMachUpUserDR(UpMachUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_IDPUpMachUpUserDR ];

/// Foreign Key FKIDPUpMachOperUserDR created via DDL
ForeignKey FKIDPUpMachOperUserDR(OperUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_IDPUpMachOperUserDR ];

/// DDL Primary Key Specification
Index PKIDPUPMACH On RowID [ PrimaryKey, SqlName = PK_IDP_UPMACH, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 鉴定结果主键
Property IDPResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 结果
Property Result As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 4 ];

/// 文本结果
Property TxtResult As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 5 ];

/// 上机仪器
Property IDPMachDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 板条
Property IDPSlatsDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 板条批号
Property SlatsNo As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ SqlColumnNumber = 8 ];

/// 上机备注
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 9 ];

/// 上机人
Property UpMachUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 上机日期
Property UpMachDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 上机时间
Property UpMachTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 上机备注2
Property Remark1 As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ SqlColumnNumber = 13 ];

/// 操作人
Property OperUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 操作日期
Property OperDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 操作时间
Property OperTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 上机号
Property UpID As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 17 ];

/// 打印数量
Property PrintNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

Storage Default
{
<Data name="IDPUpMachDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPResultDR</Value>
</Value>
<Value name="3">
<Value>Result</Value>
</Value>
<Value name="4">
<Value>TxtResult</Value>
</Value>
<Value name="5">
<Value>IDPMachDR</Value>
</Value>
<Value name="6">
<Value>IDPSlatsDR</Value>
</Value>
<Value name="7">
<Value>SlatsNo</Value>
</Value>
<Value name="8">
<Value>Remark</Value>
</Value>
<Value name="9">
<Value>UpMachUserDR</Value>
</Value>
<Value name="10">
<Value>UpMachDate</Value>
</Value>
<Value name="11">
<Value>UpMachTime</Value>
</Value>
<Value name="12">
<Value>Remark1</Value>
</Value>
<Value name="13">
<Value>OperUserDR</Value>
</Value>
<Value name="14">
<Value>OperDate</Value>
</Value>
<Value name="15">
<Value>OperTime</Value>
</Value>
<Value name="16">
<Value>UpID</Value>
</Value>
<Value name="17">
<Value>PrintNum</Value>
</Value>
</Data>
<DataLocation>^dbo.IDPUpMachD</DataLocation>
<DefaultData>IDPUpMachDefaultData</DefaultData>
<IdLocation>^dbo.IDPUpMachD</IdLocation>
<IndexLocation>^dbo.IDPUpMachI</IndexLocation>
<StreamLocation>^dbo.IDPUpMachS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
