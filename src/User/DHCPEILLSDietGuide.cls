/// 疾病关联饮食指导
Class User.DHCPEILLSDietGuide Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_ILLSDietGuide ]
{

Parameter ClassName = "User.DHCPEILLSDietGuide";

/// 疾病维护表
Property IDGILLSDR As User.DHCPEIllnessStandard [ Required, SqlFieldName = IDG_ILLS_DR ];

/// 饮食指导
Property IDGDietGuide As %String(MAXLEN = 500) [ SqlFieldName = IDG_DietGuide ];

/// 作废标记
Property IDGNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = IDG_NoActive ];

/// 更新日期
Property IDGUpdateDate As %Date [ SqlFieldName = IDG_UpdateDate ];

/// 更新时间
Property IDGUpdateTime As %Time [ SqlFieldName = IDG_UpdateTime ];

/// 更信人 指向SS_User
Property IDGUpdateUserDR As %String [ SqlFieldName = IDG_UpdateUserDR ];

/// 疾病 索引
Index IdxOfILLSDR On IDGILLSDR;

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IDGILLSDR</Value>
</Value>
<Value name="3">
<Value>IDGDietGuide</Value>
</Value>
<Value name="4">
<Value>IDGNoActive</Value>
</Value>
<Value name="5">
<Value>IDGUpdateDate</Value>
</Value>
<Value name="6">
<Value>IDGUpdateTime</Value>
</Value>
<Value name="7">
<Value>IDGUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.ILLSDietGuideD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.ILLSDietGuideD</IdLocation>
<IndexLocation>^CF.PE.ILLSDietGuideI</IndexLocation>
<StreamLocation>^User.DHCPEILLSDietGuideS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
