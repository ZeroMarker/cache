/// Creater:wangpf
/// Descriptions:专业会诊
/// Date:2020-07-29
Class DHCINM.Special.SpecialConsult Extends %Persistent
{

Relationship ChildSub As DHCINM.Special.SpecialConsSub [ Cardinality = children, Inverse = Parref ];

/// 会诊类型 C:平会诊 E:急会诊
Property ConsultType As %String [ SqlColumnNumber = 2, SqlFieldName = Consult_Type ];

/// 会诊级别 H:全院 L:科室 W:病区
Property ConsultLevel As %String [ SqlColumnNumber = 3, SqlFieldName = Consult_Level ];

/// 患者主表
Property ConsultPAPatMas As User.PAPatMas [ SqlColumnNumber = 4, SqlFieldName = Consult_PAPatMas ];

/// 登记号
Property ConsultRegNo As %String [ SqlColumnNumber = 5, SqlFieldName = Consult_RegNo ];

/// 患者姓名
Property ConsultPatName As %String [ SqlColumnNumber = 6, SqlFieldName = Consult_PatName ];

/// 患者性别
Property ConsultPatSex As %String [ SqlColumnNumber = 7, SqlFieldName = Consult_PatSex ];

/// 患者年龄
Property ConsultPatAge As %String [ SqlColumnNumber = 8, SqlFieldName = Consult_PatAge ];

/// 所属科室
Property ConsultCTLoc As User.CTLoc [ SqlColumnNumber = 9, SqlFieldName = Consult_CTLoc ];

/// 所属科室描述
Property ConsultCTLocDesc As %String [ SqlColumnNumber = 10, SqlFieldName = Consult_CTLocDesc ];

/// 诊断
Property ConsultSituation As %String(MAXLEN = 1000) [ SqlColumnNumber = 11, SqlFieldName = Consult_Situation ];

/// 会诊日期
Property ConsultDate As %Date [ SqlColumnNumber = 12, SqlFieldName = Consult_Date ];

/// 会诊时间
Property ConsultTime As %Time [ SqlColumnNumber = 13, SqlFieldName = Consult_Time ];

/// 联系人
Property ConsultContector As %String [ SqlColumnNumber = 14, SqlFieldName = Consult_Contector ];

/// 联系方式
Property ConsultPhone As %String [ SqlColumnNumber = 15, SqlFieldName = Consult_Phone ];

/// 申请人(创建人)
Property Creator As %String [ SqlColumnNumber = 16, SqlFieldName = Creator ];

/// 申请病区
Property ConsultWard As CF.DHCINM.DB.MgWard [ SqlColumnNumber = 17, SqlFieldName = Consult_Ward ];

/// 病情摘要
Property ConsultAbstract As %String(MAXLEN = 1000) [ SqlColumnNumber = 18, SqlFieldName = Consult_Abstract ];

/// 理由要求
Property ConsultReason As %String(MAXLEN = 1000) [ SqlColumnNumber = 19, SqlFieldName = Consult_Reason ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 20, SqlFieldName = Create_Date ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 21, SqlFieldName = Create_Time ];

/// 状态 N:保存 Y:发布 A:完成
Property ConsultStatus As %String [ SqlColumnNumber = 22, SqlFieldName = Consult_Status ];

Index ToolIndex On (ConsultDate, ConsultStatus, ConsultWard, ConsultType, ConsultLevel);

Storage Default
{
<Data name="SpecialConsultDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConsultType</Value>
</Value>
<Value name="3">
<Value>ConsultLevel</Value>
</Value>
<Value name="4">
<Value>ConsultPAPatMas</Value>
</Value>
<Value name="5">
<Value>ConsultRegNo</Value>
</Value>
<Value name="6">
<Value>ConsultPatName</Value>
</Value>
<Value name="7">
<Value>ConsultPatSex</Value>
</Value>
<Value name="8">
<Value>ConsultPatAge</Value>
</Value>
<Value name="9">
<Value>ConsultCTLoc</Value>
</Value>
<Value name="10">
<Value>ConsultCTLocDesc</Value>
</Value>
<Value name="11">
<Value>ConsultSituation</Value>
</Value>
<Value name="12">
<Value>ConsultDate</Value>
</Value>
<Value name="13">
<Value>ConsultTime</Value>
</Value>
<Value name="14">
<Value>ConsultContector</Value>
</Value>
<Value name="15">
<Value>ConsultPhone</Value>
</Value>
<Value name="16">
<Value>Creator</Value>
</Value>
<Value name="17">
<Value>ConsultWard</Value>
</Value>
<Value name="18">
<Value>ConsultAbstract</Value>
</Value>
<Value name="19">
<Value>ConsultReason</Value>
</Value>
<Value name="20">
<Value>CreateDate</Value>
</Value>
<Value name="21">
<Value>CreateTime</Value>
</Value>
<Value name="22">
<Value>ConsultStatus</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Special.SpecialConsultD</DataLocation>
<DefaultData>SpecialConsultDefaultData</DefaultData>
<IdLocation>^DHCINM.Special.SpecialConsultD</IdLocation>
<IndexLocation>^DHCINM.Special.SpecialConsultI</IndexLocation>
<StreamLocation>^DHCINM.Special.SpecialConsultS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
