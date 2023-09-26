Class CHSS.PersonBookingCheck Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = BookingRowId, SqlTableName = PersonBookingCheck ]
{

/// 个人档案主键
Property PersonRowId As CHSS.PersonHealthRecordMain;

/// 预约类型
Property BookingType As %Integer;

/// 预约日期
Property DateOfBooking As %Date;

/// 随访记录号
Property HDFPRecord As %Integer;

/// 预约检查状态
Property CheckStatus As %Integer;

/// 社区编码
Property CommunityCode As %String(MAXLEN = 50, TRUNCATE = 1);

Index HDFPRecordIndex On (PersonRowId, BookingType, HDFPRecord);

Storage Default
{
<Data name="PersonBookingCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BookingType</Value>
</Value>
<Value name="3">
<Value>CheckStatus</Value>
</Value>
<Value name="4">
<Value>CommunityCode</Value>
</Value>
<Value name="5">
<Value>DateOfBooking</Value>
</Value>
<Value name="6">
<Value>HDFPRecord</Value>
</Value>
<Value name="7">
<Value>PersonRowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonBookingCheckD</DataLocation>
<DefaultData>PersonBookingCheckDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonBookingCheckD</IdLocation>
<IndexLocation>^CHSS.PersonBookingCheckI</IndexLocation>
<StreamLocation>^CHSS.PersonBookingCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
