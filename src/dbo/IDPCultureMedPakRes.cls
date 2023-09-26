/// 培养基组结果
Class dbo.IDPCultureMedPakRes Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = IDP_CultureMedPakRes ]
{

Index IndexMaster On (IDPResultDR, IDPCultureMedPakDR) [ SqlName = Index_Master, Type = index, Unique ];

/// Foreign Key FKIDPCultureMedPakResIDPResultDR created via DDL
ForeignKey FKIDPCultureMedPakResIDPResultDR(IDPResultDR) References dbo.IDPResult(PKIDPRESULT) [ SqlName = FK_IDPCultureMedPakResIDPResultDR ];

/// Foreign Key FKIDPCultureMedPakResIDPCultureMedPakDR created via DDL
ForeignKey FKIDPCultureMedPakResIDPCultureMedPakDR(IDPCultureMedPakDR) References dbo.BTIDPCultureMedPak(PKBTIDPCULTUREMEDPAK) [ SqlName = FK_IDPCultureMedPakResIDPCultureMedPakDR ];

/// Foreign Key FKIDPCultureMedPakResInoculatUserDR created via DDL
ForeignKey FKIDPCultureMedPakResInoculatUserDR(InoculatUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_IDPCultureMedPakResInoculatUserDR ];

/// Foreign Key FKIDPCultureMedPakResIDPMachDR created via DDL
ForeignKey FKIDPCultureMedPakResIDPMachDR(IDPMachDR) References dbo.BTIDPMach(PKBTIDPMACH) [ SqlName = FK_IDPCultureMedPakResIDPMachDR ];

/// Foreign Key FKIDPCultureMedPakResOperUserDR created via DDL
ForeignKey FKIDPCultureMedPakResOperUserDR(OperUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_IDPCultureMedPakResOperUserDR ];

/// DDL Primary Key Specification
Index PKIDPCULTUREMEDPAKRES On RowID [ PrimaryKey, SqlName = PK_IDP_CULTUREMEDPAKRES, Type = index, Unique ];

/// 主键
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 鉴定结果主键
Property IDPResultDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 培养基组
Property IDPCultureMedPakDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 瓶子代码
Property BottleCode As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 5 ];

/// 接种人
Property InoculatUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 接种日期
Property InoculatDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 接种时间
Property InoculatTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 培养日期
Property TrainDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 培养时间
Property TrainTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 位置
Property Position As %Library.String(COLLATION = "Exact", MAXLEN = 128) [ SqlColumnNumber = 11 ];

/// 生长情况
Property GrowthInfo As %Library.String(COLLATION = "Exact", MAXLEN = 128) [ SqlColumnNumber = 12 ];

/// 培养仪器
Property IDPMachDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 累计小时
Property TotalHours As %Library.String(COLLATION = "Exact", MAXLEN = 128) [ SqlColumnNumber = 14 ];

/// 仪器日期
Property MachDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 仪器时间
Property MachTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 打印次数
Property PrintNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 操作人
Property OperUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 操作日期
Property OperDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 操作时间
Property OperTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

Storage Default
{
<Data name="IDPCultureMedPakResDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDPResultDR</Value>
</Value>
<Value name="3">
<Value>IDPCultureMedPakDR</Value>
</Value>
<Value name="4">
<Value>BottleCode</Value>
</Value>
<Value name="5">
<Value>InoculatUserDR</Value>
</Value>
<Value name="6">
<Value>InoculatDate</Value>
</Value>
<Value name="7">
<Value>InoculatTime</Value>
</Value>
<Value name="8">
<Value>TrainDate</Value>
</Value>
<Value name="9">
<Value>TrainTime</Value>
</Value>
<Value name="10">
<Value>Position</Value>
</Value>
<Value name="11">
<Value>GrowthInfo</Value>
</Value>
<Value name="12">
<Value>IDPMachDR</Value>
</Value>
<Value name="13">
<Value>TotalHours</Value>
</Value>
<Value name="14">
<Value>MachDate</Value>
</Value>
<Value name="15">
<Value>MachTime</Value>
</Value>
<Value name="16">
<Value>PrintNum</Value>
</Value>
<Value name="17">
<Value>OperUserDR</Value>
</Value>
<Value name="18">
<Value>OperDate</Value>
</Value>
<Value name="19">
<Value>OperTime</Value>
</Value>
</Data>
<DataLocation>^dbo.IDPCultureMedPakResD</DataLocation>
<DefaultData>IDPCultureMedPakResDefaultData</DefaultData>
<IdLocation>^dbo.IDPCultureMedPakResD</IdLocation>
<IndexLocation>^dbo.IDPCultureMedPakResI</IndexLocation>
<StreamLocation>^dbo.IDPCultureMedPakResS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
