/// 疾病关联疾病解释
Class User.DHCPEILLSExplain Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_ILLSExplain ]
{

Parameter ClassName = "User.DHCPEILLSExplain";

/// 疾病维护表
Property IEILLSDR As User.DHCPEIllnessStandard [ Required, SqlFieldName = IE_ILLS_DR ];

/// 疾病解释
Property IEIllExplain As %String(MAXLEN = 500) [ SqlFieldName = IE_IllExplain ];

/// 作废标记
Property IENoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = IE_NoActive ];

/// 更新日期
Property IEUpdateDate As %Date [ SqlFieldName = IE_UpdateDate ];

/// 更新时间
Property IEUpdateTime As %Time [ SqlFieldName = IE_UpdateTime ];

/// 更信人 指向SS_User
Property IEUpdateUserDR As %String [ SqlFieldName = IE_UpdateUserDR ];

/// 疾病 索引
Index IdxOfILLSDR On IEILLSDR;

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IEILLSDR</Value>
</Value>
<Value name="3">
<Value>IEIllExplain</Value>
</Value>
<Value name="4">
<Value>IENoActive</Value>
</Value>
<Value name="5">
<Value>IEUpdateDate</Value>
</Value>
<Value name="6">
<Value>IEUpdateTime</Value>
</Value>
<Value name="7">
<Value>IEUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.ILLSExplainD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.ILLSExplainD</IdLocation>
<IndexLocation>^CF.PE.ILLSExplainI</IndexLocation>
<StreamLocation>^User.DHCPEILLSExplainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
