/// 科室站点细项扩展表
Class User.DHCPEOrderDetailSet Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_OrderDetailSet ]
{

Parameter ClassName = "User.DHCPEOrderDetailSet";

/// 站点细项
Property ODSOrderDtlDR As User.DHCPEOrderDetail [ SqlFieldName = ODS_OrderDtlDR ];

/// 科室
Property ODSLocDR As %String [ SqlFieldName = ODS_LocDR ];

/// 是否进入小结
Property ODSSummary As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = ODS_Summary ];

/// 是否有建议项
Property ODSAdvice As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = ODS_Advice ];

/// 说明2
Property ODSExplain2 As %String(MAXLEN = 200) [ SqlFieldName = ODS_Explain2 ];

/// 顺序号
Property ODSSequence As %Numeric(SCALE = 0) [ SqlFieldName = ODS_Sequence ];

/// 检验项目编码2
Property ODSLabtrakCode2 As %String [ SqlFieldName = ODS_LabtrakCode2 ];

/// 英文对照
Property ODSZhToEn As %String [ SqlFieldName = ODS_ZhToEn ];

/// 不打印
Property ODSNoPrint As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = ODS_NoPrint ];

/// 报告中对比
Property ODSHistoryFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = ODS_HistoryFlag ];

/// 特殊范围
Property ODSRange As %String [ SqlFieldName = ODS_Range ];

/// 婚姻
Property ODSMarriedDR As %String [ SqlFieldName = ODS_Married_DR ];

/// 作废标记
Property ODSNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = ODS_NoActive ];

/// 更新日期
Property ODSUpdateDate As %Date [ SqlFieldName = ODS_UpdateDate ];

/// 更新时间
Property ODSUpdateTime As %Time [ SqlFieldName = ODS_UpdateTime ];

/// 更新人 指向SS_User
Property ODSUpdateUserDR As %String [ SqlFieldName = ODS_UpdateUserDR ];

/// 科室+站点细项 索引
Index IdxOfLocOrdDtl On (ODSLocDR, ODSOrderDtlDR) [ Unique ];

/// 科室+结果对比标志+站点细项 索引
Index IdxOfLocODHistory On (ODSLocDR, ODSHistoryFlag, ODSOrderDtlDR);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ODSOrderDtlDR</Value>
</Value>
<Value name="3">
<Value>ODSLocDR</Value>
</Value>
<Value name="4">
<Value>ODSSummary</Value>
</Value>
<Value name="5">
<Value>ODSAdvice</Value>
</Value>
<Value name="6">
<Value>ODSExplain2</Value>
</Value>
<Value name="7">
<Value>ODSSequence</Value>
</Value>
<Value name="8">
<Value>ODSLabtrakCode2</Value>
</Value>
<Value name="9">
<Value>ODSZhToEn</Value>
</Value>
<Value name="10">
<Value>ODSNoPrint</Value>
</Value>
<Value name="11">
<Value>ODSHistoryFlag</Value>
</Value>
<Value name="12">
<Value>ODSRange</Value>
</Value>
<Value name="13">
<Value>ODSMarriedDR</Value>
</Value>
<Value name="14">
<Value>ODSNoActive</Value>
</Value>
<Value name="15">
<Value>ODSUpdateDate</Value>
</Value>
<Value name="16">
<Value>ODSUpdateTime</Value>
</Value>
<Value name="17">
<Value>ODSUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.OrderDetailSetD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.OrderDetailSetD</IdLocation>
<IndexLocation>^CF.PE.OrderDetailSetI</IndexLocation>
<StreamLocation>^User.DHCPEOrderDetailSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
