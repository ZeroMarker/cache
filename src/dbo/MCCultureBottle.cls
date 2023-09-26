/// 血培养瓶
Class dbo.MCCultureBottle Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = MC_CultureBottle ]
{

/// Foreign Key FKMCCultureBottleAddUserDR created via DDL
ForeignKey FKMCCultureBottleAddUserDR(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MCCultureBottleAddUserDR ];

/// Foreign Key FKMCCultureBottleInUserDR created via DDL
ForeignKey FKMCCultureBottleInUserDR(InUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MCCultureBottleInUserDR ];

/// Foreign Key FKMCCultureBottleOutUserDR created via DDL
ForeignKey FKMCCultureBottleOutUserDR(OutUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MCCultureBottleOutUserDR ];

/// Foreign Key FKMCCultureBottleLocationDR created via DDL
ForeignKey FKMCCultureBottleLocationDR(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_MCCultureBottleLocationDR ];

/// Foreign Key FKMCCultureBottleUseUserDR created via DDL
ForeignKey FKMCCultureBottleUseUserDR(UseUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_MCCultureBottleUseUserDR ];

/// Foreign Key FKMCCultureBottleWorkGroupDR created via DDL
ForeignKey FKMCCultureBottleWorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_MCCultureBottleWorkGroupDR ];

/// DDL Primary Key Specification
Index PKMCCULTUREBOTTLE On RowID [ PrimaryKey, SqlName = PK_MC_CULTUREBOTTLE, Type = index, Unique ];

Index IndexMaster On BotBarcode [ SqlName = Index_Master, Type = index, Unique ];

Index IndexAddDate On (WorkGroupDR, AddDate) [ SqlName = Index_AddDate, Type = index ];

Index IndexInDate On (WorkGroupDR, InDate) [ SqlName = Index_InDate, Type = index ];

Index IndexOutDate On (WorkGroupDR, OutDate) [ SqlName = Index_OutDate, Type = index ];

Index IndexUseDate On (WorkGroupDR, UseDate) [ SqlName = Index_UseDate, Type = index ];

Index IndexStatus On (WorkGroupDR, Status, AddDate) [ SqlName = Index_Status, Type = index ];

Index IndexLabNo On LabNo [ SqlName = Index_LabNo, Type = index ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 瓶身条码号  
Property BotBarcode As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 3 ];

/// 批号  
Property LotNo As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 4 ];

/// 效期  
Property ExpiredDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 创建日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 创建时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 创建用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

/// 入库日期  
Property InDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 入库时间  
Property InTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 入库用户  
Property InUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 出库日期  
Property OutDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 出库时间  
Property OutTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 出库用户  
Property OutUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 科室       
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// 领出人  
Property OutUser As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 16 ];

/// 使用日期  
Property UseDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 使用时间  
Property UseTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 使用标本号  
Property LabNo As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 19 ];

/// 使用用户  
Property UseUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20 ];

/// 状态  {C:创建,I:入库,O:领用,U:使用}
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 21 ];

/// 类型  
Property BotType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ SqlColumnNumber = 22 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 23 ];

Storage Default
{
<Data name="MCCultureBottleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BotBarcode</Value>
</Value>
<Value name="3">
<Value>LotNo</Value>
</Value>
<Value name="4">
<Value>ExpiredDate</Value>
</Value>
<Value name="5">
<Value>AddDate</Value>
</Value>
<Value name="6">
<Value>AddTime</Value>
</Value>
<Value name="7">
<Value>AddUserDR</Value>
</Value>
<Value name="8">
<Value>InDate</Value>
</Value>
<Value name="9">
<Value>InTime</Value>
</Value>
<Value name="10">
<Value>InUserDR</Value>
</Value>
<Value name="11">
<Value>OutDate</Value>
</Value>
<Value name="12">
<Value>OutTime</Value>
</Value>
<Value name="13">
<Value>OutUserDR</Value>
</Value>
<Value name="14">
<Value>LocationDR</Value>
</Value>
<Value name="15">
<Value>OutUser</Value>
</Value>
<Value name="16">
<Value>UseDate</Value>
</Value>
<Value name="17">
<Value>UseTime</Value>
</Value>
<Value name="18">
<Value>LabNo</Value>
</Value>
<Value name="19">
<Value>UseUserDR</Value>
</Value>
<Value name="20">
<Value>Status</Value>
</Value>
<Value name="21">
<Value>BotType</Value>
</Value>
<Value name="22">
<Value>WorkGroupDR</Value>
</Value>
</Data>
<DataLocation>^dbo.MCCultureBottleD</DataLocation>
<DefaultData>MCCultureBottleDefaultData</DefaultData>
<IdLocation>^dbo.MCCultureBottleD</IdLocation>
<IndexLocation>^dbo.MCCultureBottleI</IndexLocation>
<StreamLocation>^dbo.MCCultureBottleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
