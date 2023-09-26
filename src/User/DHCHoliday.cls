/// DHCHoliday  科室对照 d ##class(User.DHCHoliday).%BuildIndices()
Class User.DHCHoliday Extends %Persistent [ SqlTableName = DHCHoliday ]
{

/// 节假日代码
Property DHCHolidayCode As %Date [ SqlColumnNumber = 2, SqlFieldName = DHCHoliday_Code ];

/// 半天标识1
Property DHCHolidayHalf1 As %String [ SqlColumnNumber = 3, SqlFieldName = DHCHoliday_Half1 ];

/// 半天标识2
Property DHCHolidayHalf2 As %String [ SqlColumnNumber = 4, SqlFieldName = DHCHoliday_Half2 ];

/// 用户
Property DHCHolidayUser As %String [ SqlColumnNumber = 5, SqlFieldName = DHCHoliday_User ];

/// 备注
Property DHCHolidayRemark As %String [ SqlColumnNumber = 6, SqlFieldName = DHCHoliday_Remark ];

Index DHCHolidayCode On DHCHolidayCode As Exact;

Index DHCHolidayHalf1 On DHCHolidayHalf1 As Exact;

Index DHCHolidayHalf2 On DHCHolidayHalf2 As Exact;

Index DHCHolidayRemark On DHCHolidayRemark As Exact;

Storage Default
{
<Data name="DHCHolidayDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DHCHolidayCode</Value>
</Value>
<Value name="3">
<Value>DHCHolidayHalf1</Value>
</Value>
<Value name="4">
<Value>DHCHolidayHalf2</Value>
</Value>
<Value name="5">
<Value>DHCHolidayUser</Value>
</Value>
<Value name="6">
<Value>DHCHolidayRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCHolidayD</DataLocation>
<DefaultData>DHCHolidayDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHolidayD</IdLocation>
<IndexLocation>^User.DHCHolidayI</IndexLocation>
<StreamLocation>^User.DHCHolidayS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
