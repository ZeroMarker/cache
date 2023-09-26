/// 3、用户站内信息记录表DHCHMOUserMessage
Class User.DHCHMOUserMessage Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_OUserMessage ]
{

Parameter ClassName = "User.DHCHMOUserMessage";

/// 2	UM_OBaseInfo_DR	发送/接收用户					指向DHC_HM_OBaseInfo
Property UMOBaseInfoDR As User.DHCHMOBaseInfo [ Required ];

/// 3	UM_Desc	标题	Text	
Property UMDesc As %String;

/// 4	UM_Details	内容
Property UMDetails As %String(MAXLEN = 512);

/// 	UM_CTUser_DR	接收/发送用户					指向SS_User
Property UMCTUserDR As User.SSUser [ Required ];

/// 	UM_Date	发送日期	
Property UMDate As %Date;

/// 	UM_Time	发送时间
Property UMTime As %Time;

/// 	UM_CTLoc_DR	接收/发送部门					指向CT_Loc
Property UMCTLocDR As User.CTLoc [ Required ];

/// 	UM_HM_DR	接收/发送管理师					指向SS_User
Property UMHMDR As User.SSUser [ Required ];

///  	UM_InitialsID	回复原消息ID					指向DHC_HM_OUserMessage
Property UMInitialsID As User.DHCHMOUserMessage [ Required ];

///  	UM_Readflag	已读标识	Y/N	
Property UMReadflag As %String;

///  	UM_Direction	流向标识					Ue-用户接收
Property UMDirection As %String;

///  He-His接收
///  	UM_Type	信息分类
Property UMType As %String;

///  	UM_Remark	备注			
Property UMRemark As %String(MAXLEN = 200);

///   UM_Direction, UM_Date, UM_Time,UM_OBaseInfo_DR,UM_HM_DR
Index Message1Index On (UMDirection, UMDate, UMTime, UMOBaseInfoDR, UMHMDR);

///   UM_Direction, UM_Date, UM_Time,UM_HM_DR,UM_OBaseInfo_DR
Index Message2Index On (UMDirection, UMDate, UMTime, UMHMDR, UMOBaseInfoDR);

Storage Default
{
<Data name="DHCHMOUserMessageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>UMCTUserDR</Value>
</Value>
<Value name="3">
<Value>UMHMDR</Value>
</Value>
<Value name="4">
<Value>UMOBaseInfoDR</Value>
</Value>
<Value name="5">
<Value>UMCTLocDR</Value>
</Value>
<Value name="6">
<Value>UMDate</Value>
</Value>
<Value name="7">
<Value>UMDesc</Value>
</Value>
<Value name="8">
<Value>UMDetails</Value>
</Value>
<Value name="9">
<Value>UMDirection</Value>
</Value>
<Value name="10">
<Value>UMInitialsID</Value>
</Value>
<Value name="11">
<Value>UMReadflag</Value>
</Value>
<Value name="12">
<Value>UMRemark</Value>
</Value>
<Value name="13">
<Value>UMTime</Value>
</Value>
<Value name="14">
<Value>UMType</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMOUserMessageD</DataLocation>
<DefaultData>DHCHMOUserMessageDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOUserMessageD</IdLocation>
<IndexLocation>^User.DHCHMOUserMessageI</IndexLocation>
<StreamLocation>^User.DHCHMOUserMessageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
