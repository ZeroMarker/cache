/// Creater:dhh
/// Descriptions:发表论文备案
/// Date:2020-07-21
Class DHCINM.SM.Thesis Extends %Persistent
{

/// 论文题目
Property ThesisTitle As %String [ SqlColumnNumber = 2, SqlFieldName = Thesis_Title ];

/// 作者类型,姓名,病区及row
Property ThesisAuthor As list Of %String(MAXLEN = 5000) [ SqlColumnNumber = 3, SqlFieldName = Thesis_Author ];

/// 期刊名称
Property ThesisName As %String [ SqlColumnNumber = 4, SqlFieldName = Thesis_Name ];

/// 是否专科(Y:是,N:否)
Property ThesisSpec As %String(DISPLAYLIST = ",否,是", MAXLEN = 1, TRUNCATE = 1, VALUELIST = ",N,Y") [ SqlColumnNumber = 5, SqlFieldName = Thesis_Spec ];

/// 期刊类别
Property ThesisLevel As %String [ SqlColumnNumber = 6, SqlFieldName = Thesis_Level ];

/// 论文类型
Property ThesisType As %String [ SqlColumnNumber = 7, SqlFieldName = Thesis_Type ];

/// 年,卷(期):页码
Property ThesisPage As %String [ SqlColumnNumber = 8, SqlFieldName = Thesis_Page ];

/// 发表日期
Property ThesisPublic As %Date [ SqlColumnNumber = 9, SqlFieldName = Thesis_Public ];

/// 创建人
Property Creator As %String [ SqlColumnNumber = 10, SqlFieldName = Creator ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 11, SqlFieldName = Create_Date ];

/// 附件
Property ThesisPic As %String(MAXLEN = 2000) [ SqlColumnNumber = 12, SqlFieldName = Thesis_Pic ];

/// 状态(Y:提交,N:保存,B:驳回,S:审核)
Property ThesisStatus As %String [ SqlColumnNumber = 13, SqlFieldName = Thesis_Status ];

/// 驳回意见
Property Reason As %String [ SqlColumnNumber = 14, SqlFieldName = Reason ];

/// 审核人
Property Auditor As %String [ SqlColumnNumber = 15, SqlFieldName = Auditor ];

/// 审核日期
Property AuditDate As %Date [ SqlColumnNumber = 16, SqlFieldName = AuditDate ];

/// 审核时间
Property AuditTime As %Time [ SqlColumnNumber = 17, SqlFieldName = AuditTime ];

/// 创建时间
Property CreateTime As %Time [ InitialExpression = {$p($h,",",2)}, SqlColumnNumber = 18, SqlFieldName = Create_Time ];

Storage Default
{
<Data name="ThesisDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ThesisTitle</Value>
</Value>
<Value name="3">
<Value>ThesisAuthor</Value>
</Value>
<Value name="4">
<Value>ThesisName</Value>
</Value>
<Value name="5">
<Value>ThesisSpec</Value>
</Value>
<Value name="6">
<Value>ThesisLevel</Value>
</Value>
<Value name="7">
<Value>ThesisType</Value>
</Value>
<Value name="8">
<Value>ThesisPage</Value>
</Value>
<Value name="9">
<Value>ThesisPublic</Value>
</Value>
<Value name="10">
<Value>Creator</Value>
</Value>
<Value name="11">
<Value>CreateDate</Value>
</Value>
<Value name="12">
<Value>ThesisPic</Value>
</Value>
<Value name="13">
<Value>ThesisStatus</Value>
</Value>
<Value name="14">
<Value>Reason</Value>
</Value>
<Value name="15">
<Value>Auditor</Value>
</Value>
<Value name="16">
<Value>AuditDate</Value>
</Value>
<Value name="17">
<Value>AuditTime</Value>
</Value>
<Value name="18">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCINM.SM.ThesisD</DataLocation>
<DefaultData>ThesisDefaultData</DefaultData>
<IdLocation>^DHCINM.SM.ThesisD</IdLocation>
<IndexLocation>^DHCINM.SM.ThesisI</IndexLocation>
<StreamLocation>^DHCINM.SM.ThesisS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
