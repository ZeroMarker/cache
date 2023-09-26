/// Creater:wangpf
/// Descriptions:护理查房
/// Date:2020-07-03
Class DHCINM.HB.MgRoomCheck Extends %Persistent
{

/// 查房类型 1:业务查房 2:行政查房 3:教学查房 4:专科查房 5:循证查房
Property CheckType As %Integer [ SqlColumnNumber = 2, SqlFieldName = Check_Type ];

/// 查房级别 H:全院 L:科室 W:病区
Property CheckLevel As %String [ SqlColumnNumber = 3, SqlFieldName = Check_Level ];

/// 主查人
Property CheckMainChecker As CF.DHCINM.HR.Persons [ SqlColumnNumber = 4, SqlFieldName = Check_MainChecker ];

/// 汇报人
Property CheckReporter As CF.DHCINM.HR.Persons [ SqlColumnNumber = 5, SqlFieldName = Check_Reporter ];

/// 查房日期
Property CheckDate As %Date [ SqlColumnNumber = 6, SqlFieldName = Check_Date ];

/// 查房主题
Property CheckTopic As %String [ SqlColumnNumber = 7, SqlFieldName = Check_Topic ];

/// 查房课件
Property CheckFile As %String(MAXLEN = 100) [ SqlColumnNumber = 8, SqlFieldName = Check_File ];

/// 参与人
Property CheckChecker As list Of %String [ SqlColumnNumber = 9, SqlFieldName = Check_Checker ];

/// 患者主表
Property CheckPAPatMas As User.PAPatMas [ SqlColumnNumber = 10, SqlFieldName = Check_PAPatMas ];

/// 登记号
Property CheckRegNo As %String [ SqlColumnNumber = 11, SqlFieldName = Check_RegNo ];

/// 患者姓名
Property CheckPatientName As %String [ SqlColumnNumber = 12, SqlFieldName = Check_PatientName ];

/// 患者性别
Property CheckPatientSex As %String [ SqlColumnNumber = 13, SqlFieldName = Check_PatientSex ];

/// 患者年龄
Property CheckPatientAge As %String [ SqlColumnNumber = 14, SqlFieldName = Check_PatientAge ];

/// 所属科室
Property CheckCTLoc As User.CTLoc [ SqlColumnNumber = 15, SqlFieldName = Check_CTLoc ];

/// 所属科室描述
Property CheckCTLocDesc As %String [ SqlColumnNumber = 16, SqlFieldName = Check_CTLocDesc ];

/// 诊断
Property CheckSituation As %String(MAXLEN = 100) [ SqlColumnNumber = 17, SqlFieldName = Check_Situation ];

/// 记录
Property CheckRecord As %String(MAXLEN = 10000) [ SqlColumnNumber = 18, SqlFieldName = Check_Record ];

/// 状态 N:保存 Y:提交 B:驳回
Property CheckStatus As %String(DISPLAYLIST = ",保存,提交,驳回", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y,B") [ SqlColumnNumber = 19, SqlFieldName = Check_Status ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 20, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 21, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 22, SqlFieldName = Create_Time ];

/// 记录
Property CheckContentExt As %Stream.GlobalCharacter [ SqlColumnNumber = 23, SqlFieldName = Check_ContentExt ];

Index CTLoc On CheckCTLoc;

Storage Default
{
<Data name="MgRoomCheckDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckType</Value>
</Value>
<Value name="3">
<Value>CheckLevel</Value>
</Value>
<Value name="4">
<Value>CheckMainChecker</Value>
</Value>
<Value name="5">
<Value>CheckReporter</Value>
</Value>
<Value name="6">
<Value>CheckDate</Value>
</Value>
<Value name="7">
<Value>CheckTopic</Value>
</Value>
<Value name="8">
<Value>CheckFile</Value>
</Value>
<Value name="9">
<Value>CheckChecker</Value>
</Value>
<Value name="10">
<Value>CheckPAPatMas</Value>
</Value>
<Value name="11">
<Value>CheckRegNo</Value>
</Value>
<Value name="12">
<Value>CheckPatientName</Value>
</Value>
<Value name="13">
<Value>CheckPatientSex</Value>
</Value>
<Value name="14">
<Value>CheckPatientAge</Value>
</Value>
<Value name="15">
<Value>CheckCTLoc</Value>
</Value>
<Value name="16">
<Value>CheckCTLocDesc</Value>
</Value>
<Value name="17">
<Value>CheckSituation</Value>
</Value>
<Value name="18">
<Value>CheckRecord</Value>
</Value>
<Value name="19">
<Value>CheckStatus</Value>
</Value>
<Value name="20">
<Value>Creator</Value>
</Value>
<Value name="21">
<Value>CreateDate</Value>
</Value>
<Value name="22">
<Value>CreateTime</Value>
</Value>
<Value name="23">
<Value>CheckContentExt</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HB.MgRoomCheckD</DataLocation>
<DefaultData>MgRoomCheckDefaultData</DefaultData>
<IdLocation>^DHCINM.HB.MgRoomCheckD</IdLocation>
<IndexLocation>^DHCINM.HB.MgRoomCheckI</IndexLocation>
<StreamLocation>^DHCINM.HB.MgRoomCheckS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
