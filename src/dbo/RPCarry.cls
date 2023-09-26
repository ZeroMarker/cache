/// RPCarry
Class dbo.RPCarry Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_Carry, StorageStrategy = Default ]
{

/// Foreign Key FKCarryCreateUser created via DDL
ForeignKey FKCarryCreateUser(AddUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CarryCreateUser ];

/// Foreign Key FKCarryHospital created via DDL
ForeignKey FKCarryHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_CarryHospital ];

/// Foreign Key FKCarryReceiveUser created via DDL
ForeignKey FKCarryReceiveUser(ReceiveUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CarryReceiveUser ];

/// Foreign Key FKCarrylLocation created via DDL
ForeignKey FKCarrylLocation(LocationDR) References dbo.BTLocation(PKBTLOCATION) [ SqlName = FK_CarrylLocation ];

/// Foreign Key FKCarrylUser created via DDL
ForeignKey FKCarrylUser(CarryUserDR) References dbo.SYSUser(PKSYSUSER) [ SqlName = FK_CarrylUser ];

/// Foreign Key FKCarrylLocation created via DDL
ForeignKey FKCarrylExtLaboratory(ExtLaboratoryDR) References dbo.BTExtLaboratory(PKBTEXTLABORATORY) [ SqlName = PK_BTEXTLABORATORY ];

Index IndexCarryNo On CarryNo [ SqlName = Index_CarryNo, Type = index, Unique ];

Index IndexCarryUser On (CarryUserDR, AddDate, CarryType) [ SqlName = Index_CarryUser, Type = index ];

Index IndexCreateTime On (HospitalDR, AddDate, CarryType) [ SqlName = Index_CreateTime, Type = index ];

/// DDL Primary Key Specification
Index PKRPCARRY On RowID [ PrimaryKey, SqlName = PK_RP_CARRY, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 运送单号  
Property CarryNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

/// 创建日期  
Property AddDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 创建时间  
Property AddTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 创建用户  
Property AddUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 运送科室  
Property LocationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 容器编号  
Property ContainerNo As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ SqlColumnNumber = 9 ];

/// 运送用户  
Property CarryUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 运送人  
Property CarryUserName As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 11 ];

/// 接收日期  
Property ReceiveDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

/// 接收时间  
Property ReceiveTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 接收用户  
Property ReceiveUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 完成状态  
Property Status As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 15 ];

/// 运送类型  
Property CarryType As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 16 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 17 ];

/// 科室  
Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 18 ];

/// 第三方机构  
Property ExtLaboratoryDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 19 ];

Storage Default
{
<Data name="RPCarryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CarryNo</Value>
</Value>
<Value name="3">
<Value>HospitalDR</Value>
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
<Value>LocationDR</Value>
</Value>
<Value name="8">
<Value>ContainerNo</Value>
</Value>
<Value name="9">
<Value>CarryUserDR</Value>
</Value>
<Value name="10">
<Value>CarryUserName</Value>
</Value>
<Value name="11">
<Value>ReceiveDate</Value>
</Value>
<Value name="12">
<Value>ReceiveTime</Value>
</Value>
<Value name="13">
<Value>ReceiveUserDR</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>CarryType</Value>
</Value>
<Value name="16">
<Value>WorkGroupDR</Value>
</Value>
<Value name="17">
<Value>DepartmentDR</Value>
</Value>
<Value name="18">
<Value>ExtLaboratoryDR</Value>
</Value>
</Data>
<DataLocation>^dbo.RPCarryD</DataLocation>
<DefaultData>RPCarryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPCarryD</IdLocation>
<IndexLocation>^dbo.RPCarryI</IndexLocation>
<StreamLocation>^dbo.RPCarryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
