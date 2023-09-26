/// 错误信息记录
Class User.CSSDErrorRegistration Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDER_Rowid, SqlTableName = CSSD_ErrorRegistration ]
{

/// 关联trans表
Property CSSDSRTransDR As User.CSSDTrans [ SqlColumnNumber = 2, SqlFieldName = CSSDER_Trans_DR ];

Property CSSDSRDate As %Date [ SqlColumnNumber = 4, SqlFieldName = CSSDER_Date ];

/// 清洗单号
Property CSSDERCleanNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 5, SqlFieldName = CSSDER_CleanNo ];

/// 清洗人
Property CSSDERCleanUserDr As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = CSSDER_Clean_User_DR ];

/// 灭菌单号
Property CSSDERSterNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 7, SqlFieldName = CSSDER_Ster_No ];

/// 灭菌人
Property CSSDERSterUserDr As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = CSSDER_Ster_User_DR ];

/// 消毒包Dr
Property CSSDERPackageDr As User.CSSDPackage [ SqlColumnNumber = 9, SqlFieldName = CSSDER_Package_DR ];

/// 原有清洗方式
Property CSSDERFCleanMethodDr As User.CSSDCleanType [ SqlColumnNumber = 10, SqlFieldName = CSSDER_FCleanMethod_DR ];

/// 更正后清洗方式
Property CSSDERSCleanMethodDr As User.CSSDCleanType [ SqlColumnNumber = 11, SqlFieldName = CSSDER_SCleanMethod_DR ];

/// 原有灭菌方式
Property CSSDERFSterMethodDr As %String(COLLATION = "Exact") [ SqlColumnNumber = 12, SqlFieldName = CSSDER_FSterMethod_DR ];

/// 更正后灭菌方式
Property CSSDERSSterMethodDr As %String(COLLATION = "Exact") [ SqlColumnNumber = 13, SqlFieldName = CSSDER_SSterMethod_DR ];

/// 灭菌人
Property CSSDERUpdateUserDr As User.SSUser [ SqlColumnNumber = 14, SqlFieldName = CSSDER_Update_User_DR ];

/// 备注
Property CSSDERRemark As %String(COLLATION = "Exact", MAXLEN = 2000) [ SqlColumnNumber = 15, SqlFieldName = CSSDER_Remark ];

/// 清洗机器号
Property CSSDSRCleanMachineNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 17, SqlFieldName = CSSDER_CleanMachineNo ];

/// 灭菌机器号
Property CSSDSRSterMachineNo As %String(COLLATION = "Exact") [ SqlColumnNumber = 18, SqlFieldName = CSSDER_SterMachineNo ];

Property CSSDSRTime As %Time [ SqlColumnNumber = 19, SqlFieldName = CSSDSR_Time ];

Index IndexCSSDSRTransDR On CSSDSRTransDR As Exact;

Storage Default
{
<Data name="CSSDErrorRegistrationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSRTransDR</Value>
</Value>
<Value name="3"/>
<Value name="4">
<Value>CSSDSRDate</Value>
</Value>
<Value name="5">
<Value>CSSDERCleanNo</Value>
</Value>
<Value name="6">
<Value>CSSDERCleanUserDr</Value>
</Value>
<Value name="7">
<Value>CSSDERSterNo</Value>
</Value>
<Value name="8">
<Value>CSSDERSterUserDr</Value>
</Value>
<Value name="9">
<Value>CSSDERPackageDr</Value>
</Value>
<Value name="10">
<Value>CSSDERFCleanMethodDr</Value>
</Value>
<Value name="11">
<Value>CSSDERSCleanMethodDr</Value>
</Value>
<Value name="12">
<Value>CSSDERFSterMethodDr</Value>
</Value>
<Value name="13">
<Value>CSSDERSSterMethodDr</Value>
</Value>
<Value name="14">
<Value>CSSDERUpdateUserDr</Value>
</Value>
<Value name="15">
<Value>CSSDERRemark</Value>
</Value>
<Value name="16"/>
<Value name="17">
<Value>CSSDSRCleanMachineNo</Value>
</Value>
<Value name="18">
<Value>CSSDSRSterMachineNo</Value>
</Value>
<Value name="19">
<Value>CSSDSRTime</Value>
</Value>
</Data>
<DataLocation>^User.CSSDErrorRegistrationD</DataLocation>
<DefaultData>CSSDErrorRegistrationDefaultData</DefaultData>
<IdLocation>^User.CSSDErrorRegistrationD</IdLocation>
<IndexLocation>^User.CSSDErrorRegistrationI</IndexLocation>
<SqlRowIdName>CSSDER_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDErrorRegistrationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
