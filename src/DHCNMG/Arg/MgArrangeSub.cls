/// creator:xbl
/// createdate:20170829
/// description:排班明细
Class DHCNMG.Arg.MgArrangeSub Extends %Persistent [ ClassType = persistent, Inheritance = left ]
{

/// 排班记录 
Property ArrangeDR As DHCNMG.Arg.MgArrange [ SqlColumnNumber = 2, SqlFieldName = Arrange_DR ];

/// 排班行记录
Property ArgRowDR As DHCNMG.Arg.MgArrangeRow [ SqlColumnNumber = 3, SqlFieldName = Arg_RowDR ];

/// 病区
Property ArgWardDR As DHCNMG.DB.MgWard [ SqlColumnNumber = 4, SqlFieldName = Arg_WardDR ];

/// 护士
Property ArgPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 5, SqlFieldName = Arg_PerDR ];

/// 日期
Property ArgDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Arg_Date ];

/// 班次id
Property ArgPostDR As DHCNMG.DB.MgArgWardPost [ SqlColumnNumber = 7, SqlFieldName = Arg_PostDR ];

/// 一阶段开始时间
Property ArgStTime1 As %String [ SqlColumnNumber = 8, SqlFieldName = Arg_StTime1 ];

/// 一阶段结束时间
Property ArgEndTime1 As %String [ SqlColumnNumber = 9, SqlFieldName = Arg_EndTime1 ];

/// 二阶段开始时间
Property ArgStTime2 As %String [ SqlColumnNumber = 10, SqlFieldName = Arg_StTime2 ];

/// 二阶段结束时间
Property ArgEndTime2 As %String [ SqlColumnNumber = 11, SqlFieldName = Arg_EndTime2 ];

/// 三阶段开始时间
Property ArgStTime3 As %String [ SqlColumnNumber = 12, SqlFieldName = Arg_StTime3 ];

/// 三阶段结束时间
Property ArgEndTime3 As %String [ SqlColumnNumber = 13, SqlFieldName = Arg_EndTime3 ];

/// 备注
Property ArgRemark As %String [ SqlColumnNumber = 14, SqlFieldName = Arg_Remark ];

/// 排班人
Property ArgEditUser As DHCNMG.HR.MgPersons [ SqlColumnNumber = 15, SqlFieldName = Arg_EditUser ];

/// 排班日期
Property ArgEditDate As %Date [ SqlColumnNumber = 16, SqlFieldName = Arg_EditDate ];

/// 排班时间 
Property ArgEditTime As %Time [ SqlColumnNumber = 17, SqlFieldName = Arg_EditTime ];

/// 休假时间【】
Property ArgHolidayTime As %String [ SqlColumnNumber = 18, SqlFieldName = Arg_HolidayTime ];

/// 班次确认人
Property ArgConfirmDR As %String [ SqlColumnNumber = 19, SqlFieldName = Arg_ConfirmDR ];

/// 班次确认日期
Property ArgConfirmDate As %Date [ SqlColumnNumber = 20, SqlFieldName = Arg_ConfirmDate ];

/// 班次确认时间
Property ArgConfirmTime As %Time [ SqlColumnNumber = 21, SqlFieldName = Arg_ConfirmTime ];

/// 班次分类w:白班，N:夜班；24：24h班
Property ArgCategory As %String [ SqlColumnNumber = 22, SqlFieldName = Arg_Category ];

/// 是否存在替班：1：有别人替班，2：有替别人上班
Property ArgIsReplace As %String [ SqlColumnNumber = 23, SqlFieldName = Arg_IsReplace ];

/// 替班或被替人员：
Property ArgReplaceDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 24, SqlFieldName = Arg_ReplaceDR ];

/// 二线班开始时间
Property ArgSecStTime As %String [ SqlColumnNumber = 25, SqlFieldName = Arg_SecStTime ];

/// 二线班结束时间
Property ArgSecEndTime As %String [ SqlColumnNumber = 26, SqlFieldName = Arg_SecEndTime ];

/// 排班类型【P正常班,Y加班。N：减班】
Property ArgType As %String [ SqlColumnNumber = 27, SqlFieldName = Arg_Type ];

/// 意愿排班id
Property ArgWishDR As %String [ SqlColumnNumber = 28, SqlFieldName = Arg_WishDR ];

Index Arrange On (ArrangeDR, ArgRowDR, ArgDate);

Index Ward On ArgWardDR;

Index Person On ArgPerDR;

Index Date On ArgDate;

Index WardDate On (ArgWardDR, ArgDate);

Index PerDate On (ArgPerDR, ArgDate);

Index WardPerDate On (ArgWardDR, ArgPerDR, ArgDate);

Index Post On ArgPostDR;

Index Arg On ArrangeDR;

Trigger OnInsert [ Event = INSERT, Order = 1, Time = AFTER ]
{
	NEW id,ret,obj
    SET id = {ID}
	s ret=##class(web.NurMgArgComm).GetArgSubById(id)
	s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	d ##class(web.NurMgLogComm).SaveLog("DHCNMG.Arg.MgArrangeSub","Insert","",ret,obj.ArgEditUser.%Id())
	q 0
}

Trigger OnBeforeUpdate [ Event = UPDATE, Order = 2 ]
{
	NEW id,ret,obj
    SET id = {ID}
	s ret=##class(web.NurMgArgComm).GetArgSubById(id)
	s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	d ##class(web.NurMgLogComm).SaveLog("DHCNMG.Arg.MgArrangeSub","Update",ret,"",obj.ArgEditUser.%Id())
	q 0
}

Trigger OnAfterUpdate [ Event = UPDATE, Order = 2, Time = AFTER ]
{
	NEW id,ret,obj
    SET id = {ID}
	s ret=##class(web.NurMgArgComm).GetArgSubById(id)
	s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	d ##class(web.NurMgLogComm).SaveLog("DHCNMG.Arg.MgArrangeSub","Update","",ret,obj.ArgEditUser.%Id())
	q 0
}

Trigger OnDelete [ Event = DELETE, Order = 3 ]
{
	NEW id,ret,obj
    SET id = {ID}
	s ret=##class(web.NurMgArgComm).GetArgSubById(id)
	s obj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(id)
	d ##class(web.NurMgLogComm).SaveLog("DHCNMG.Arg.MgArrangeSub","Delete",ret,"",obj.ArgEditUser.%Id())
	q 0
}

ClassMethod CopyArgToNew(subid) [ CodeMode = objectgenerator ]
{
	d %code.WriteLine(" s subObj=##class(DHCNMG.Arg.MgArrangeSub).%OpenId(subid)")
	d %code.WriteLine(" s subObjNew=##class(DHCNMG.Arg.MgArrangeSub).%New()")
    For i = 1:1:%compiledclass.Properties.Count() {
        s name=%compiledclass.Properties.GetAt(i).Name
		continue:name["%"
		continue:name["ArgWishDR"
        Do %code.WriteLine(" s subObjNew."_name_"=subObj."_name)
    }
    d %code.WriteLine(" s sc=subObjNew.%Save()")
    d %code.WriteLine(" q:$$$ISERR(sc) 0")
	d %code.WriteLine(" q subObjNew.%Id()")
	q $$$OK
}

Storage Default
{
<Data name="MgArrangeSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArrangeDR</Value>
</Value>
<Value name="3">
<Value>ArgRowDR</Value>
</Value>
<Value name="4">
<Value>ArgWardDR</Value>
</Value>
<Value name="5">
<Value>ArgPerDR</Value>
</Value>
<Value name="6">
<Value>ArgDate</Value>
</Value>
<Value name="7">
<Value>ArgPostDR</Value>
</Value>
<Value name="8">
<Value>ArgStTime1</Value>
</Value>
<Value name="9">
<Value>ArgEndTime1</Value>
</Value>
<Value name="10">
<Value>ArgStTime2</Value>
</Value>
<Value name="11">
<Value>ArgEndTime2</Value>
</Value>
<Value name="12">
<Value>ArgStTime3</Value>
</Value>
<Value name="13">
<Value>ArgEndTime3</Value>
</Value>
<Value name="14">
<Value>ArgRemark</Value>
</Value>
<Value name="15">
<Value>ArgEditUser</Value>
</Value>
<Value name="16">
<Value>ArgEditDate</Value>
</Value>
<Value name="17">
<Value>ArgEditTime</Value>
</Value>
<Value name="18">
<Value>ArgHolidayTime</Value>
</Value>
<Value name="19">
<Value>ArgConfirmDR</Value>
</Value>
<Value name="20">
<Value>ArgConfirmDate</Value>
</Value>
<Value name="21">
<Value>ArgConfirmTime</Value>
</Value>
<Value name="22">
<Value>ArgCategory</Value>
</Value>
<Value name="23">
<Value>ArgIsReplace</Value>
</Value>
<Value name="24">
<Value>ArgReplaceDR</Value>
</Value>
<Value name="25">
<Value>ArgSecStTime</Value>
</Value>
<Value name="26">
<Value>ArgSecEndTime</Value>
</Value>
<Value name="27">
<Value>ArgType</Value>
</Value>
<Value name="28">
<Value>ArgWishDR</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Arg.MgArrangeSubD</DataLocation>
<DefaultData>MgArrangeSubDefaultData</DefaultData>
<IdLocation>^DHCNMG.Arg.MgArrangeSubD</IdLocation>
<IndexLocation>^DHCNMG.Arg.MgArrangeSubI</IndexLocation>
<StreamLocation>^DHCNMG.Arg.MgArrangeSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
