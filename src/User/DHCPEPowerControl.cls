/// 表记录授权管理
Class User.DHCPEPowerControl Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_PowerControl ]
{

Parameter ClassName = "User.DHCPEPowerControl";

/// 表名称
Property PCTableDR As User.DHCPEPowerTableList [ Required, SqlFieldName = PC_TableDR ];

/// 表记录ID
Property PCRecordID As %String [ Required, SqlFieldName = PC_RecordID ];

/// 授权科室组/科室组默认科室 指向CT_Loc
Property PCLocGrpDR As %String [ SqlFieldName = PC_LocGrpDR ];

/// 是否单独授权
Property PCEmpower As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = PC_Empower ];

/// 授权科室 指向CT_Loc
Property PCLocDR As %String [ SqlFieldName = PC_LocDR ];

/// 是否有效授权
Property PCEffPower As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = PC_EffPower ];

/// 更新日期
Property PCUpdateDate As %Date [ SqlFieldName = PC_UpdateDate ];

/// 更新时间
Property PCUpdateTime As %Time [ SqlFieldName = PC_UpdateTime ];

/// 更新人 指向SS_User
Property PCUpdateUserDR As %String [ SqlFieldName = PC_UpdateUserDR ];

/// 别名
Property PCDesc2 As %String [ SqlFieldName = PC_Desc2 ];

/// 外部码/扩展码
Property PCExCode As %String [ SqlFieldName = PC_ExCode ];

/// 备注说明
Property PCRemark As %String(MAXLEN = 500) [ SqlFieldName = PC_Remark ];

/// 表+表记录+科室组+有效授权+是否单独授权 索引
Index IdxOfLocGrpPower On (PCTableDR, PCRecordID As Exact, PCLocGrpDR As Exact, PCEffPower As Exact, PCEmpower As Exact);

/// 表+表记录+科室+有效授权 索引
Index IdxOfLocPower On (PCTableDR, PCRecordID As Exact, PCLocDR As Exact, PCEffPower As Exact);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PCTableDR</Value>
</Value>
<Value name="3">
<Value>PCRecordID</Value>
</Value>
<Value name="4">
<Value>PCLocGrpDR</Value>
</Value>
<Value name="5">
<Value>PCEmpower</Value>
</Value>
<Value name="6">
<Value>PCLocDR</Value>
</Value>
<Value name="7">
<Value>PCEffPower</Value>
</Value>
<Value name="8">
<Value>PCUpdateDate</Value>
</Value>
<Value name="9">
<Value>PCUpdateTime</Value>
</Value>
<Value name="10">
<Value>PCUpdateUserDR</Value>
</Value>
<Value name="11">
<Value>PCDesc2</Value>
</Value>
<Value name="12">
<Value>PCExCode</Value>
</Value>
<Value name="13">
<Value>PCRemark</Value>
</Value>
</Data>
<DataLocation>^CF.PE.PowerControlD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.PowerControlD</IdLocation>
<IndexLocation>^CF.PE.PowerControlI</IndexLocation>
<StreamLocation>^User.DHCPEPowerControlS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
