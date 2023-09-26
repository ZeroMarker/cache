Class User.DHCPEComplain Extends %Persistent [ SqlTableName = DHC_PE_Complain ]
{

/// 类型  Type:投诉 C，建议 S
Property CType As %String [ SqlFieldName = C_Type ];

/// 事件来源
Property CSource As %String [ SqlFieldName = C_Source ];

/// 投诉人
Property CComplainUser As User.SSUser [ SqlFieldName = C_ComplainUser ];

/// 投诉类型
Property CComplainType As %String [ SqlFieldName = C_ComplainType ];

/// 投诉对象
Property CComplainObject As %String [ SqlFieldName = C_ComplainObject ];

/// 投诉内容
Property CComplainContent As %String(MAXLEN = 500) [ SqlFieldName = C_ComplainContent ];

/// 事件时间
Property CEventTime As %Date [ SqlFieldName = C_EventTime ];

/// 投诉原因
Property CComplainCause As %String [ SqlFieldName = C_ComplainCause ];

/// 处置建议
Property CDisProposal As %String(MAXLEN = 500) [ SqlFieldName = C_DisProposal ];

/// 患者姓名
Property CName As %String [ SqlFieldName = C_Name ];

/// 登记号
Property CRegNo As %String [ SqlFieldName = C_RegNo ];

/// 身份证号
Property CIDCard As %String [ SqlFieldName = C_IDCard ];

/// 就诊记录
Property CRecord As User.DHCPEPreIADM [ SqlFieldName = C_Record ];

/// 申诉人姓名
Property CClaimantName As %String [ SqlFieldName = C_ClaimantName ];

/// 证件号
Property CClaimantNo As %String [ SqlFieldName = C_ClaimantNo ];

/// 与患者关系	
Property CRelation As %String [ SqlFieldName = C_Relation ];

/// 联系电话
Property CTel As %String [ SqlFieldName = C_Tel ];

/// 登记人
Property CUpdateUser As User.SSUser [ SqlFieldName = C_UpdateUser ];

/// 登记日期
Property CUpdateDate As %Date [ SqlFieldName = C_UpdateDate ];

/// 登记时间
Property CUpdateTime As %Time [ SqlFieldName = C_UpdateTime ];

/// 科室
Property CLoc As User.CTLoc [ SqlFieldName = C_Loc ];

/// 备注
Property CRemark As %String [ SqlFieldName = C_Remark ];

Index CRecordIndex On CRecord As AlphaUp;

Index CTypeUpdateDateIndex On (CType, CUpdateDate As AlphaUp);

Storage Default
{
<Data name="DHCPEComplainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CType</Value>
</Value>
<Value name="3">
<Value>CSource</Value>
</Value>
<Value name="4">
<Value>CComplainUser</Value>
</Value>
<Value name="5">
<Value>CComplainType</Value>
</Value>
<Value name="6">
<Value>CComplainObject</Value>
</Value>
<Value name="7">
<Value>CComplainContent</Value>
</Value>
<Value name="8">
<Value>CEventTime</Value>
</Value>
<Value name="9">
<Value>CComplainCause</Value>
</Value>
<Value name="10">
<Value>CDisProposal</Value>
</Value>
<Value name="11">
<Value>CName</Value>
</Value>
<Value name="12">
<Value>CRegNo</Value>
</Value>
<Value name="13">
<Value>CIDCard</Value>
</Value>
<Value name="14">
<Value>CRecord</Value>
</Value>
<Value name="15">
<Value>CClaimantName</Value>
</Value>
<Value name="16">
<Value>CClaimantNo</Value>
</Value>
<Value name="17">
<Value>CRelation</Value>
</Value>
<Value name="18">
<Value>CTel</Value>
</Value>
<Value name="19">
<Value>CUpdateUser</Value>
</Value>
<Value name="20">
<Value>CUpdateDate</Value>
</Value>
<Value name="21">
<Value>CUpdateTime</Value>
</Value>
<Value name="22">
<Value>CRemark</Value>
</Value>
<Value name="23">
<Value>CLoc</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEComplainD</DataLocation>
<DefaultData>DHCPEComplainDefaultData</DefaultData>
<IdLocation>^User.DHCPEComplainD</IdLocation>
<IndexLocation>^User.DHCPEComplainI</IndexLocation>
<StreamLocation>^User.DHCPEComplainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
