Class DHCINM.HR.MgNurseResign Extends %Persistent
{

/// 人员档案id
Property ResignName As CF.DHCINM.HR.Persons [ SqlColumnNumber = 2, SqlFieldName = Resign_Name ];

/// 人员类型【正式（N）、进修（S）、实习（P）、护理员（W）】
Property ResignType As %String [ SqlColumnNumber = 3, SqlFieldName = Resign_Type ];

/// 离职日期
Property ResignDate As %Date [ SqlColumnNumber = 4, SqlFieldName = Resign_Date ];

/// 申请说明
Property ResignReason As %String(MAXLEN = 2000) [ SqlColumnNumber = 5, SqlFieldName = Resign_Reason ];

/// 创建人
Property ResignCreater As %String [ SqlColumnNumber = 6, SqlFieldName = Resign_Creater ];

/// 创建日期
Property CreateDate As %Date [ InitialExpression = {+$p($h,",",1)}, Required, SqlColumnNumber = 7, SqlFieldName = CreateDate ];

/// 更新人
Property UpdateUser As %String [ SqlColumnNumber = 8, SqlFieldName = Update_User ];

/// 更新日期
Property ResignUpdate As %Date [ SqlColumnNumber = 9, SqlFieldName = Resign_Update ];

/// 状态【未提交：N 	 提交：Y  	审核：A	 驳回：B】
Property ResignStatus As %String [ SqlColumnNumber = 10, SqlFieldName = Resign_Status ];

/// 所在病区
Property ResignWard As %String [ SqlColumnNumber = 11, SqlFieldName = Resign_Ward ];

/// 审核意见
Property ResignOpinion As %String [ SqlColumnNumber = 12, SqlFieldName = Resign_Opinion ];

/// 其他
Property ResignOther As %String [ SqlColumnNumber = 13, SqlFieldName = Resign_Other ];

/// 聘任职称
Property ResignDuty As %String [ SqlColumnNumber = 14, SqlFieldName = Resign_Duty ];

/// 学历
Property ResignAcademic As %String [ SqlColumnNumber = 15, SqlFieldName = Resign_Academic ];

/// 离职或退休
Property ResignReStatus As %String [ SqlColumnNumber = 16, SqlFieldName = Resign_ReStatus ];

Index type On (ResignType, ResignDate);

Index ssid On ResignName;

Storage Default
{
<Data name="MgNurseResignDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ResignName</Value>
</Value>
<Value name="3">
<Value>ResignType</Value>
</Value>
<Value name="4">
<Value>ResignDate</Value>
</Value>
<Value name="5">
<Value>ResignReason</Value>
</Value>
<Value name="6">
<Value>ResignCreater</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>UpdateUser</Value>
</Value>
<Value name="9">
<Value>ResignUpdate</Value>
</Value>
<Value name="10">
<Value>ResignStatus</Value>
</Value>
<Value name="11">
<Value>ResignWard</Value>
</Value>
<Value name="12">
<Value>ResignOpinion</Value>
</Value>
<Value name="13">
<Value>ResignOther</Value>
</Value>
<Value name="14">
<Value>ResignDuty</Value>
</Value>
<Value name="15">
<Value>ResignAcademic</Value>
</Value>
<Value name="16">
<Value>ResignReStatus</Value>
</Value>
</Data>
<DataLocation>^DHCINM.HR.MgNurseResignD</DataLocation>
<DefaultData>MgNurseResignDefaultData</DefaultData>
<IdLocation>^DHCINM.HR.MgNurseResignD</IdLocation>
<IndexLocation>^DHCINM.HR.MgNurseResignI</IndexLocation>
<StreamLocation>^DHCINM.HR.MgNurseResignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
