Class User.DHCPEDelayRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_DelayRecord ]
{

Parameter ClassName = "User.DHCPEDelayRecord";

/// 就诊ID
Property DRPAADM As %String(COLLATION = "AlphaUp") [ Required, SqlColumnNumber = 2, SqlFieldName = DR_PAADM ];

/// OE_OrdItem
Property DROEORI As %String [ Required, SqlColumnNumber = 3, SqlFieldName = DR_OEORI ];

/// 待重新生成    可当作是否有效使用
Property DRNoGenFlag As %String(COLLATION = "AlphaUp", VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 4, SqlFieldName = DR_NoGenFlag ];

/// 备注  备用
Property DRRemark As %String [ SqlColumnNumber = 5, SqlFieldName = DR_Remark ];

/// 是否全部做完再总检  
Property DRIfComplateAll As %String(COLLATION = "AlphaUp", VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 6, SqlFieldName = DR_IfComplateAll ];

/// 延期日期
Property DRDate As %Date [ Required, SqlColumnNumber = 7, SqlFieldName = DR_Date ];

Index OEORIIndex On DROEORI [ Unique ];

Index FlagADMOEORIIndex On (DRNoGenFlag, DRPAADM, DROEORI);

Index DateFlagADMOEORIIndex On (DRDate, DRNoGenFlag, DRPAADM, DROEORI);

Storage Default
{
<Data name="DHCPEDelayRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DRPAADM</Value>
</Value>
<Value name="3">
<Value>DROEORI</Value>
</Value>
<Value name="4">
<Value>DRNoGenFlag</Value>
</Value>
<Value name="5">
<Value>DRRemark</Value>
</Value>
<Value name="6">
<Value>DRIfComplateAll</Value>
</Value>
<Value name="7">
<Value>ARMDate</Value>
</Value>
<Value name="8">
<Value>DRDate</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEDelayRecordD</DataLocation>
<DefaultData>DHCPEDelayRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEDelayRecordD</IdLocation>
<IndexLocation>^User.DHCPEDelayRecordI</IndexLocation>
<StreamLocation>^User.DHCPEDelayRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
