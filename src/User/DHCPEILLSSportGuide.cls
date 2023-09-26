/// 疾病关联运动指导
Class User.DHCPEILLSSportGuide Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_ILLSSportGuide ]
{

Parameter ClassName = "User.DHCPEILLSSportGuide";

/// 疾病维护表
Property ISGILLSDR As User.DHCPEIllnessStandard [ Required, SqlFieldName = ISG_ILLS_DR ];

/// 运动指导
Property ISGSportGuide As %String(MAXLEN = 500) [ SqlFieldName = ISG_SportGuide ];

/// 作废标记
Property ISGNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = ISG_NoActive ];

/// 更新日期
Property ISGUpdateDate As %Date [ SqlFieldName = ISG_UpdateDate ];

/// 更新时间
Property ISGUpdateTime As %Time [ SqlFieldName = ISG_UpdateTime ];

/// 更信人 指向SS_User
Property ISGUpdateUserDR As %String [ SqlFieldName = ISG_UpdateUserDR ];

/// 疾病 索引
Index IdxOfILLSDR On ISGILLSDR;

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ISGILLSDR</Value>
</Value>
<Value name="3">
<Value>ISGSportGuide</Value>
</Value>
<Value name="4">
<Value>ISGNoActive</Value>
</Value>
<Value name="5">
<Value>ISGUpdateDate</Value>
</Value>
<Value name="6">
<Value>ISGUpdateTime</Value>
</Value>
<Value name="7">
<Value>ISGUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.ILLSSportGuideD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.ILLSSportGuideD</IdLocation>
<IndexLocation>^CF.PE.ILLSSportGuideI</IndexLocation>
<StreamLocation>^User.DHCPEILLSSportGuideS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
