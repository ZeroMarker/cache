/// Creater:wangpf
/// Descriptions:科室业务学习记录
/// Date:2020-08-18
Class DHCINM.HB.MgLocBusStudy Extends %Persistent
{

/// 科室
Property BusLoc As CF.DHCINM.DB.MgWardLoc [ SqlColumnNumber = 2, SqlFieldName = Bus_Loc ];

/// 日期
Property BusDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Bus_Date ];

/// 级别 H:护理部 L:科室 W:病区
Property BusLevel As %String(DISPLAYLIST = ",护理部,科室,病区", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",H,L,W") [ SqlColumnNumber = 4, SqlFieldName = Bus_Level ];

/// 主题
Property BusTopic As %String [ SqlColumnNumber = 5, SqlFieldName = Bus_Topic ];

/// 主讲人
Property BusHost As CF.DHCINM.HR.Persons [ SqlColumnNumber = 6, SqlFieldName = Bus_Host ];

/// 培训对象
Property BusTarget As %String [ SqlColumnNumber = 7, SqlFieldName = Bus_Target ];

/// 应到人数
Property BusSupNum As %Integer [ SqlColumnNumber = 8, SqlFieldName = Bus_SupNum ];

/// 参与人
Property BusNurse As list Of %String [ SqlColumnNumber = 9, SqlFieldName = Bus_Nurse ];

/// 备注
Property BusRemark As %String [ SqlColumnNumber = 10, SqlFieldName = Bus_Remark ];

/// 内容
Property BusContent As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = Bus_Content ];

/// 文件
Property BusFile As %String(MAXLEN = 500) [ SqlColumnNumber = 12, SqlFieldName = Bus_File ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 13, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 14, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 15, SqlFieldName = Create_Time ];

Index ToolIndex On (BusDate, BusLoc, BusLevel);

Storage Default
{
<Data name="MgLocBusStudyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BusLoc</Value>
</Value>
<Value name="3">
<Value>BusDate</Value>
</Value>
<Value name="4">
<Value>BusLevel</Value>
</Value>
<Value name="5">
<Value>BusTopic</Value>
</Value>
<Value name="6">
<Value>BusHost</Value>
</Value>
<Value name="7">
<Value>BusTarget</Value>
</Value>
<Value name="8">
<Value>BusSupNum</Value>
</Value>
<Value name="9">
<Value>BusNurse</Value>
</Value>
<Value name="10">
<Value>BusRemark</Value>
</Value>
<Value name="11">
<Value>BusContent</Value>
</Value>
<Value name="12">
<Value>BusFile</Value>
</Value>
<Value name="13">
<Value>Creator</Value>
</Value>
<Value name="14">
<Value>CreateDate</Value>
</Value>
<Value name="15">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgLocBusStudyD</DataLocation>
<DefaultData>MgLocBusStudyDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgLocBusStudyD</IdLocation>
<IndexLocation>^DHCINM.HB.MgLocBusStudyI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgLocBusStudyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
