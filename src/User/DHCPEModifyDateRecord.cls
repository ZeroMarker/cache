/// 修改体检日期记录
Class User.DHCPEModifyDateRecord Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_ModifyDateRecord ]
{

Parameter ClassName = "User.DHCPEModifyDateRecord";

/// 预约记录ID
Property MDRPreIADMDR As User.DHCPEPreIADM [ SqlFieldName = MDR_PreIADM_DR ];

/// 体检日期
Property MDRCheckDate As %Date [ Required, SqlFieldName = MDR_CheckDate ];

/// User.DHCPEPreTimeManager表ID
Property NPRPreTimeMangerDR As User.DHCPEPreTimeManager [ SqlFieldName = NPR_PreTimeManger_DR ];

/// User.DHCPEPreHomeTimeInfo
Property NPRPreHomeTimeDR As User.DHCPEPreHomeTimeInfo [ SqlFieldName = NPR_PreHomeTime_DR ];

/// 更新日期
Property MDRUpdateDate As %Date [ Required, SqlFieldName = MDR_UpdateDate ];

/// 更新人
Property MDRUpdateUserDR As User.SSUser [ SqlFieldName = MDR_UpdateUser_DR ];

/// 网上预约记录ID
Property MDRNetPreRecordDR As User.DHCPENetPreRecord [ SqlFieldName = MDR_NetPreRecord_DR ];

/// 体检日期索引
Index CheckDateIndex On MDRCheckDate;

/// 预约记录索引
Index PreIADMIndex On MDRPreIADMDR;

/// 网上预约记录索引
Index NetPreRecordIndex On MDRNetPreRecordDR;

Storage Default
{
<Data name="DHCPEModifyDateRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MDRPreIADMDR</Value>
</Value>
<Value name="3">
<Value>MDRCheckDate</Value>
</Value>
<Value name="4">
<Value>MDRUpdateDate</Value>
</Value>
<Value name="5">
<Value>MDRUpdateUserDR</Value>
</Value>
<Value name="6">
<Value>NPRPreTimeMangerDR</Value>
</Value>
<Value name="7">
<Value>MDRNetPreRecordDR</Value>
</Value>
<Value name="8">
<Value>NPRPreHomeTimeDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEModifyDateRecordD</DataLocation>
<DefaultData>DHCPEModifyDateRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEModifyDateRecordD</IdLocation>
<IndexLocation>^User.DHCPEModifyDateRecordI</IndexLocation>
<StreamLocation>^User.DHCPEModifyDateRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
