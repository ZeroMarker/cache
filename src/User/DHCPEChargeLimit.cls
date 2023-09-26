/// 体检收费特权维护
Class User.DHCPEChargeLimit Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_ChargeLimit ]
{

Parameter ClassName = "User.DHCPEChargeLimit";

/// 科室（操作员所属科室） 指向CT_Loc
Property CLLocDR As %String [ SqlFieldName = CL_LocDR ];

/// 操作员 指向SS_User
Property CLUserDR As %String [ Required, SqlFieldName = CL_UserDR ];

/// 允许最大折扣
Property CLChargeLimit As %Integer [ SqlFieldName = CL_ChargeLimit ];

/// 优惠打折
Property CLOPFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = CL_OPFlag ];

/// 视同收费授权
Property CLASChargedFlag As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = CL_ASChargedFlag ];

/// 视同收费授权分类（0：都不允许  1：个人允许 2：团体允许 3：个人和团体都允许）
Property CLOPChargeLimit As %String(DISPLAYLIST = ",都不允许,个人允许,团体允许,个人和团体都允许", TRUNCATE = 1, VALUELIST = ",0,1,2,3") [ SqlFieldName = CL_OPChargeLimit ];

/// 凑整费（上限不能超过多少）
Property CLRoundingFeeMode As %Integer [ SqlFieldName = CL_RoundingFeeMode ];

/// 作废标记
Property CLNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = CL_NoActive ];

/// 更新日期
Property CLUpdateDate As %Date [ SqlFieldName = CL_UpdateDate ];

/// 更新时间
Property CLUpdateTime As %Time [ SqlFieldName = CL_UpdateTime ];

/// 更新人 指向SS_User
Property CLUpdateUserDR As %String [ SqlFieldName = CL_UpdateUserDR ];

/// 定额卡支付
Property CLSetASCharged As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = CL_SetASCharged ];

/// 全退申请
Property CLALLRefund As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = CL_ALLRefund ];

/// 科室+操作员 索引
Index IdxOfLocUser On (CLLocDR, CLUserDR);

// Index IdxOfUserDR On CLUserDR [ Unique ];

/// 操作员 索引
Index IdxOfUserDR On CLUserDR;

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CLLocDR</Value>
</Value>
<Value name="3">
<Value>CLUserDR</Value>
</Value>
<Value name="4">
<Value>CLChargeLimit</Value>
</Value>
<Value name="5">
<Value>CLOPFlag</Value>
</Value>
<Value name="6">
<Value>CLOPChargeLimit</Value>
</Value>
<Value name="7">
<Value>CLRoundingFeeMode</Value>
</Value>
<Value name="8">
<Value>CLNoActive</Value>
</Value>
<Value name="9">
<Value>CLUpdateDate</Value>
</Value>
<Value name="10">
<Value>CLUpdateTime</Value>
</Value>
<Value name="11">
<Value>CLUpdateUserDR</Value>
</Value>
<Value name="12">
<Value>CLASChargedFlag</Value>
</Value>
<Value name="13">
<Value>CLSetASCharged</Value>
</Value>
<Value name="14">
<Value>CLALLRefund</Value>
</Value>
</Data>
<DataLocation>^CF.PE.ChargeLimitD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.ChargeLimitD</IdLocation>
<IndexLocation>^CF.PE.ChargeLimitI</IndexLocation>
<StreamLocation>^User.DHCPEChargeLimitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
