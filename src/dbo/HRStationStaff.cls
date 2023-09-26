Class dbo.HRStationStaff Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = HR_StationStaff, StorageStrategy = Default ]
{

Index IndexStation On (StationDR, StaffDR) [ SqlName = Index_Station, Type = index ];

Index IndexStaff On (StaffDR, StationDR) [ SqlName = Index_Staff, Type = index ];

Index IndexStationStaff On (CreateDate, CreateTime, StationDR, StaffDR) [ SqlName = Index_StationStaff, Type = index, Unique ];

Index IndexStaffStation On (CreateDate, CreateTime, StaffDR, StationDR) [ SqlName = Index_StaffStation, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKHRStationStaff On RowID [ PrimaryKey, SqlName = PK_HR_StationStaff, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property StationDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property StaffDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property Status As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property CreateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

Property CreateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

Property CreatorDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Property CheckDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Property CheckTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property CheckerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Property CancelDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Property CancelTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

Property CancellerDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="HRStationStaffDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StationDR</Value>
</Value>
<Value name="3">
<Value>StaffDR</Value>
</Value>
<Value name="4">
<Value>Status</Value>
</Value>
<Value name="5">
<Value>CreateDate</Value>
</Value>
<Value name="6">
<Value>CreateTime</Value>
</Value>
<Value name="7">
<Value>CreatorDR</Value>
</Value>
<Value name="8">
<Value>CheckDate</Value>
</Value>
<Value name="9">
<Value>CheckTime</Value>
</Value>
<Value name="10">
<Value>CheckerDR</Value>
</Value>
<Value name="11">
<Value>CancelDate</Value>
</Value>
<Value name="12">
<Value>CancelTime</Value>
</Value>
<Value name="13">
<Value>CancellerDR</Value>
</Value>
</Data>
<DataLocation>^dbo.HRStationStaffD</DataLocation>
<DefaultData>HRStationStaffDefaultData</DefaultData>
<IdLocation>^dbo.HRStationStaffD</IdLocation>
<IndexLocation>^dbo.HRStationStaffI</IndexLocation>
<StreamLocation>^dbo.HRStationStaffS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
