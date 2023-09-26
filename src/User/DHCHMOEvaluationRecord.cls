/// 2、人员评估记录表DHC_HM_OEvaluationRecord
Class User.DHCHMOEvaluationRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_OEvaluationRecord ]
{

Parameter ClassName = "User.DHCHMOEvaluationRecord";

/// 	Q_OBaseInfo_DR	患者			NOTNULL		DHC_HM_OBaseInfo
Property QOBaseInfoDR As User.DHCHMOBaseInfo [ Required ];

/// Q_CServiceClass_DR
Property QCServiceClassDR As User.DHCHMCServiceClass;

/// 9	Q_COccupation_DR	职业					DHC_HM_CCodeTable
Property QCOccupationDR As User.DHCHMCCodeTable;

/// 13	Q_CEducation_DR	学历					DHC_HM_CCodeTable
Property QCEducationDR As User.DHCHMCCodeTable;

/// 7	Q_CMarital_DR	婚姻状况					DHC_HM_CCodeTable
Property QCMaritalDR As User.DHCHMCCodeTable;

/// 8	Q_Doc_DR	责任医生					指向SS_User
Property QDocDR As User.SSUser;

/// 	Q_HM_DR	健康管理师					指向SS_User
Property QHMDR As User.SSUser;

/// 	Q_PostCode	邮编
Property QPostCode As %String;

/// 	Q_Remark	备注	Text	200	
Property QRemark As %String(MAXLEN = 200);

/// 	Q_AddUser_DR	添加人					SS_User
Property QAddUserDR As User.SSUser [ Required ];

/// 12	Q_AddDate	添加日期	Date
Property QAddDate As %Date;

/// 12	Q_AddTime	添加时间	Time	
Property QAddTime As %Time;

/// Q_OBaseInfo_DR
Index QOBaseInfoDRIndex On QOBaseInfoDR;

/// Q_COccupation_DR
Index QCOccupationDRIndex On QCOccupationDR;

/// Q_CEducation_DR
Index QCEducationDRIndex On QCEducationDR;

/// Q_CMarital_DR
Index QCMaritalDRIndex On QCMaritalDR;

/// Q_Doc_DR
Index QDocDRIndex On QDocDR;

/// Q_HM_DR
Index QHMDRIndex On QHMDR;

Index QAddDate On QAddDate;

Relationship DHCHMOQEQuestion As DHCHMOQEQuestion [ Cardinality = children, Inverse = QEQParRef ];

Storage Default
{
<Data name="DHCHMOEvaluationRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>QAddDate</Value>
</Value>
<Value name="3">
<Value>QAddTime</Value>
</Value>
<Value name="4">
<Value>QAddUserDR</Value>
</Value>
<Value name="5">
<Value>QCEducationDR</Value>
</Value>
<Value name="6">
<Value>QCMaritalDR</Value>
</Value>
<Value name="7">
<Value>QCOccupationDR</Value>
</Value>
<Value name="8">
<Value>QDocDR</Value>
</Value>
<Value name="9">
<Value>QHMDR</Value>
</Value>
<Value name="10">
<Value>QOBaseInfoDR</Value>
</Value>
<Value name="11">
<Value>QPostCode</Value>
</Value>
<Value name="12">
<Value>QRemark</Value>
</Value>
<Value name="13">
<Value>QCServiceClassDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMOEvaluationRecordD</DataLocation>
<DefaultData>DHCHMOEvaluationRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMOEvaluationRecordD</IdLocation>
<IndexLocation>^User.DHCHMOEvaluationRecordI</IndexLocation>
<StreamLocation>^User.DHCHMOEvaluationRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
