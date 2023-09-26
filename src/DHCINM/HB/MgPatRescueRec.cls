/// Creater:wangpf
/// Descriptions:抢救危重病人记录
/// Date:2020-07-12
Class DHCINM.HB.MgPatRescueRec Extends %Persistent
{

/// 抢救病区
Property RescueWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 2, SqlFieldName = Rescue_Ward ];

/// 抢救日期
Property RescueDate As %Date [ SqlColumnNumber = 3, SqlFieldName = Rescue_Date ];

/// 抢救开始时间
Property RescueStTime As %Time [ SqlColumnNumber = 4, SqlFieldName = Rescue_StTime ];

/// 抢救结束时间
Property RescueEndTime As %Time [ SqlColumnNumber = 5, SqlFieldName = Rescue_EndTime ];

/// 患者就诊Id
Property RescuePatAdm As User.PAAdm [ SqlColumnNumber = 6, SqlFieldName = Rescue_PatAdm ];

/// 患者性别
Property RescuePatSex As %String [ SqlColumnNumber = 7, SqlFieldName = Rescue_PatSex ];

/// 患者年龄
Property RescuePatAge As %String [ SqlColumnNumber = 8, SqlFieldName = Rescue_PatAge ];

/// 患者床号
Property RescuePatBed As %String [ SqlColumnNumber = 9, SqlFieldName = Rescue_PatBed ];

/// 患者登记号
Property RescuePatNo As %String [ SqlColumnNumber = 10, SqlFieldName = Rescue_PatNo ];

/// 患者诊断
Property RescuePatDiag As %String(MAXLEN = 2000) [ SqlColumnNumber = 11, SqlFieldName = Rescue_PatDiag ];

/// 抢救结果 N:失败 Y:成功
Property RescueResult As %String(DISPLAYLIST = ",失败,成功", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 12, SqlFieldName = Rescue_Result ];

/// 状态 N:保存 Y:提交
Property RescueStatus As %String(DISPLAYLIST = ",保存,提交", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 13, SqlFieldName = Rescue_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 14, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 15, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 16, SqlFieldName = Create_Time ];

Index ToolIndex On (RescueDate, RescueWard, RescueStatus);

Storage Default
{
<Data name="MgPatRescueRecDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RescueWard</Value>
</Value>
<Value name="3">
<Value>RescueDate</Value>
</Value>
<Value name="4">
<Value>RescueStTime</Value>
</Value>
<Value name="5">
<Value>RescueEndTime</Value>
</Value>
<Value name="6">
<Value>RescuePatAdm</Value>
</Value>
<Value name="7">
<Value>RescuePatSex</Value>
</Value>
<Value name="8">
<Value>RescuePatAge</Value>
</Value>
<Value name="9">
<Value>RescuePatBed</Value>
</Value>
<Value name="10">
<Value>RescuePatNo</Value>
</Value>
<Value name="11">
<Value>RescuePatDiag</Value>
</Value>
<Value name="12">
<Value>RescueResult</Value>
</Value>
<Value name="13">
<Value>RescueStatus</Value>
</Value>
<Value name="14">
<Value>Creator</Value>
</Value>
<Value name="15">
<Value>CreateDate</Value>
</Value>
<Value name="16">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgPatRescueRecD</DataLocation>
<DefaultData>MgPatRescueRecDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgPatRescueRecD</IdLocation>
<IndexLocation>^DHCINM.HB.MgPatRescueRecI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgPatRescueRecS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
