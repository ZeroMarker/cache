/// 疾病关联疾病解释 疾病关联项目表 用于判断疾病的总人数
Class User.DHCPEILLItem Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_ILLItem ]
{

Parameter ClassName = "User.DHCPEILLItem";

/// 疾病维护表
Property IIILLSDR As User.DHCPEIllnessStandard [ Required, SqlFieldName = II_ILLS_DR ];

/// 疾病解释
Property IIIllItem As %String(MAXLEN = 500) [ SqlFieldName = II_IllItem ];

/// 作废标记
Property IINoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = II_NoActive ];

/// 更新日期
Property IIUpdateDate As %Date [ SqlFieldName = II_UpdateDate ];

/// 更新时间
Property IIUpdateTime As %Time [ SqlFieldName = II_UpdateTime ];

/// 更信人 指向SS_User
Property IIUpdateUserDR As %String [ SqlFieldName = II_UpdateUserDR ];

/// 疾病 索引
Index IdxOfILLSDR On IIILLSDR;

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IIILLSDR</Value>
</Value>
<Value name="3">
<Value>IIIllItem</Value>
</Value>
<Value name="4">
<Value>IINoActive</Value>
</Value>
<Value name="5">
<Value>IIUpdateDate</Value>
</Value>
<Value name="6">
<Value>IIUpdateTime</Value>
</Value>
<Value name="7">
<Value>IIUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.ILLItemD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.ILLItemD</IdLocation>
<IndexLocation>^CF.PE.ILLItemI</IndexLocation>
<StreamLocation>^User.DHCPEILLItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
