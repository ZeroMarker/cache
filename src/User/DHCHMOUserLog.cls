/// 4、用户站内活动记录表DHC_HM_OUserLog
Class User.DHCHMOUserLog Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_OUserLog ]
{

Parameter ClassName = "User.DHCHMOUserLog";

/// 2	UL_OBaseInfo_DR	用户					指向DHC_HM_OBaseInfo
Property ULOBaseInfoDR As User.DHCHMOBaseInfo [ Required ];

/// 3	UL_Type	类型	Text				详细见设置说明表
Property ULType As %String;

/// 4	UL_SourceID	数据源ID					可能根据类型不同指向不同表
Property ULSourceID As %String;

/// 	UL_Detail	内容					可能为空
Property ULDetail As %String(MAXLEN = 200);

/// 	UL_Subject	主题	
Property ULSubject As %String;

/// 	UL_Remark	备注	
Property ULRemark As %String(MAXLEN = 200);

/// 	UL_HM_DR	管理师					指向SS_User
Property ULHMDR As User.SSUser [ Required ];

/// 	UL_Date	发生日期	Date
Property ULDate As %Date;

/// 	UL_Time	发生时间	Time
Property ULTime As %Date;

/// UL_OBaseInfo_DR
Index ULOBaseInfoDRIndex On ULOBaseInfoDR;

///  UL_OBaseInfo_DR, UL_Type
Index OBaseInfoTypeIndex On (ULOBaseInfoDR, ULType);

///  UL_Date, UL_Time
Index DateTimeIndex On (ULDate, ULTime);

Storage Default
{
<Data name="DHCHMOUserLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ULDate</Value>
</Value>
<Value name="3">
<Value>ULDetail</Value>
</Value>
<Value name="4">
<Value>ULHMDR</Value>
</Value>
<Value name="5">
<Value>ULOBaseInfoDR</Value>
</Value>
<Value name="6">
<Value>ULRemark</Value>
</Value>
<Value name="7">
<Value>ULSourceID</Value>
</Value>
<Value name="8">
<Value>ULSubject</Value>
</Value>
<Value name="9">
<Value>ULTime</Value>
</Value>
<Value name="10">
<Value>ULType</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMOUserLogD</DataLocation>
<DefaultData>DHCHMOUserLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOUserLogD</IdLocation>
<IndexLocation>^User.DHCHMOUserLogI</IndexLocation>
<StreamLocation>^User.DHCHMOUserLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
