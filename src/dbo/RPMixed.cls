Class dbo.RPMixed Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_Mixed, StorageStrategy = Default ]
{

Index IndexMixNo On MixNo [ SqlName = Index_MixNo, Type = index, Unique ];

Index IndexAddDate On AddDate [ SqlName = Index_AddDate, Type = index ];

Index IndexAddHospital On (AddHospitalDR, AddDate) [ SqlName = Index_AddHospital, Type = index ];

Index IndexAddUser On (AddUserDR, AddDate) [ SqlName = Index_AddUser, Type = index ];

Index IndexTakeUser On (TakeUserDR, TakeDate) [ SqlName = Index_TakeUser, Type = index ];

Index IndexTakeDate On TakeDate [ SqlName = Index_TakeDate, Type = index ];

Index IndexCollUser On (CollUserDR, StartDate) [ SqlName = Index_CollUser, Type = index ];

Index IndexStartDate On StartDate [ SqlName = Index_StartDate, Type = index ];

Index IndexPlace On (PlaceDR, StartDate) [ SqlName = Index_Place, Type = index ];

Index IndexCollHospital On (CollHospitalDR, StartDate) [ SqlName = Index_CollHospital, Type = index ];

Index IndexCancelDate On CancelDate [ SqlName = Index_CancelDate, Type = index ];

Index IndexCancelUser On (CancelUserDR, CancelDate) [ SqlName = Index_CancelUser, Type = index ];

Index IndexStatus On (Status, AddDate) [ SqlName = Index_Status, Type = index ];

Index IndexCollStatus On (CollUserDR, Status) [ SqlName = Index_CollStatus, Type = index ];

Index PKRPMIXED On RowID [ PrimaryKey, SqlName = PK_RP_MIXED, Type = index, Unique ];

/// Foreign Key FKRPMixedAddUser created via DDL
ForeignKey FKRPMixedAddUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_MixedAddUser ];

/// Foreign Key FKRPMixedAddHospital created via DDL
ForeignKey FKRPMixedAddHospital(AddHospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_RP_MixedAddHospital ];

/// Foreign Key FKRPMixedTakeUser created via DDL
ForeignKey FKRPMixedTakeUser(TakeUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_MixedTakeUser ];

/// Foreign Key FKRPMixedCollType created via DDL
ForeignKey FKRPMixedCollType(CollTypeDR) References dbo.BTMixCollType(PKBTMIXCOllTYPE) [ SqlName = FK_RP_MixedCollType ];

/// Foreign Key FKRPMixedTubeType created via DDL
ForeignKey FKRPMixedTubeType(TubeTypeDR) References dbo.BTMixTubeType(PKBTMIXTUBETYPE) [ SqlName = FK_RP_MixedTubeType ];

/// Foreign Key FKRPMixedPlace created via DDL
ForeignKey FKRPMixedPlace(PlaceDR) References dbo.BTMixPlace(PKBTMIXPLACE) [ SqlName = FK_RP_MixedPlace ];

/// Foreign Key FKRPMixedCollUser created via DDL
ForeignKey FKRPMixedCollUser(CollUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_MixedCollUser ];

/// Foreign Key FKRPMixedCollHospital created via DDL
ForeignKey FKRPMixedCollHospital(CollHospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_RP_MixedCollHospital ];

/// Foreign Key FKRPMixedCollUser created via DDL
ForeignKey FKRPMixedCancelUser(CancelUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_RP_MixedCancelUser ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 混检号
Property MixNo As %Library.String(COLLATION = "EXACT", MAXLEN = 20) [ Required, SqlColumnNumber = 3 ];

/// 生成日期
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 生成时间
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 生成用户
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 生成医院
Property AddHospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 领取日期
Property TakeDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 领取时间
Property TakeTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 领取用户
Property TakeUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 采集类型
Property CollTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 试管类型
Property TubeTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 采集地点
Property PlaceDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 开始采集日期
Property StartDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 开始采集时间
Property StartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 采集用户
Property CollUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 16 ];

/// 采集医院
Property CollHospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 结束采集日期
Property EndDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 结束采集时间
Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

/// 作废日期
Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 作废时间
Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 21 ];

/// 作废用户
Property CancelUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 22 ];

/// 状态 {1:创建，2：领出，3：采集中，4：完成采集，5：作废}
Property Status As %Library.TinyInt [ SqlColumnNumber = 23 ];

Storage Default
{
<Data name="RPMixedDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MixNo</Value>
</Value>
<Value name="3">
<Value>AddDate</Value>
</Value>
<Value name="4">
<Value>AddTime</Value>
</Value>
<Value name="5">
<Value>AddUserDR</Value>
</Value>
<Value name="6">
<Value>AddHospitalDR</Value>
</Value>
<Value name="7">
<Value>TakeDate</Value>
</Value>
<Value name="8">
<Value>TakeTime</Value>
</Value>
<Value name="9">
<Value>TakeUserDR</Value>
</Value>
<Value name="10">
<Value>CollTypeDR</Value>
</Value>
<Value name="11">
<Value>TubeTypeDR</Value>
</Value>
<Value name="12">
<Value>PlaceDR</Value>
</Value>
<Value name="13">
<Value>StartDate</Value>
</Value>
<Value name="14">
<Value>StartTime</Value>
</Value>
<Value name="15">
<Value>CollUserDR</Value>
</Value>
<Value name="16">
<Value>CollHospitalDR</Value>
</Value>
<Value name="17">
<Value>EndDate</Value>
</Value>
<Value name="18">
<Value>EndTime</Value>
</Value>
<Value name="19">
<Value>CancelDate</Value>
</Value>
<Value name="20">
<Value>CancelTime</Value>
</Value>
<Value name="21">
<Value>CancelUserDR</Value>
</Value>
<Value name="22">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^dbo.RPMixedD</DataLocation>
<DefaultData>RPMixedDefaultData</DefaultData>
<IdLocation>^dbo.RPMixedD</IdLocation>
<IndexLocation>^dbo.RPMixedI</IndexLocation>
<StreamLocation>^dbo.RPMixedS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
