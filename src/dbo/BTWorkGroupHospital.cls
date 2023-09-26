Class dbo.BTWorkGroupHospital Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_WorkGroupHospital, StorageStrategy = Default ]
{

Index IndexMaster On (WorkGroupDR, HospitalDR) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexHospital On HospitalDR [ SqlName = Index_Hospital, Type = index ];

/// DDL Primary Key Specification
Index PKBTWORKGROUPHOSPITAL On RowID [ PrimaryKey, SqlName = PK_BT_WORKGROUPHOSPITAL, Type = index, Unique ];

/// Foreign Key FKLocationType created via DDL
ForeignKey FKBTWGHOSWorkGroup(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP) [ SqlName = FK_BTWGHosWorkGroup ];

/// Foreign Key FKLocationHospital created via DDL
ForeignKey FKBTWGHOSHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_BTWGHosHospital ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 工作组  
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 医院  
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTWorkGroupHospitalDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupDR</Value>
</Value>
<Value name="3">
<Value>HospitalDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTWorkGroupHospitalD</DataLocation>
<DefaultData>BTWorkGroupHospitalDefaultData</DefaultData>
<IdLocation>^dbo.BTWorkGroupHospitalD</IdLocation>
<IndexLocation>^dbo.BTWorkGroupHospitalI</IndexLocation>
<StreamLocation>^dbo.BTWorkGroupHospitalS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
