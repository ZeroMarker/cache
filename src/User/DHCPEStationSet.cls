/// 科室站点详情表
Class User.DHCPEStationSet Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_StationSet ]
{

Parameter ClassName = "User.DHCPEStationSet";

/// 站点
Property SSStationDR As User.DHCPEStation [ SqlFieldName = SS_StationDR ];

/// 科室 指向CT_Loc
Property SSLocDR As %String [ SqlFieldName = SS_LocDR ];

/// 站点所在位置
Property SSPlace As %String [ SqlFieldName = SS_Place ];

/// 总检顺序
Property SSSequence As %Integer [ SqlFieldName = SS_Sequence ];

/// 自动审核
Property SSAutoAudit As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SS_AutoAudit ];

/// 界面类型
Property SSLayoutType As %String [ SqlFieldName = SS_LayoutType ];

/// 按钮类型
Property SSButtonType As %String [ SqlFieldName = SS_ButtonType ];

/// 报告顺序
Property SSReportSequence As %Integer [ SqlFieldName = SS_ReportSequence ];

/// 总检显示所有结果
Property SSAllResultShow As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SS_AllResultShow ];

/// 激活
Property SSActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SS_Active ];

/// 更新日期
Property SSUpdateDate As %Date [ SqlFieldName = SS_UpdateDate ];

/// 更新时间
Property SSUpdateTime As %Time [ SqlFieldName = SS_UpdateTime ];

/// 更新人 指向SS_User
Property SSUpdateUserDR As %String [ SqlFieldName = SS_UpdateUserDR ];

/// 单独排队站点
Property SSSingleQueue As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SS_SingleQueue ];

/// 科室+站点 索引
Index IdxOfLocStation On (SSLocDR, SSStationDR);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SSStationDR</Value>
</Value>
<Value name="3">
<Value>SSLocDR</Value>
</Value>
<Value name="4">
<Value>SSPlace</Value>
</Value>
<Value name="5">
<Value>SSSequence</Value>
</Value>
<Value name="6">
<Value>SSAutoAudit</Value>
</Value>
<Value name="7">
<Value>SSLayoutType</Value>
</Value>
<Value name="8">
<Value>SSButtonType</Value>
</Value>
<Value name="9">
<Value>SSReportSequence</Value>
</Value>
<Value name="10">
<Value>SSAllResultShow</Value>
</Value>
<Value name="11">
<Value>SSActive</Value>
</Value>
<Value name="12">
<Value>SSUpdateDate</Value>
</Value>
<Value name="13">
<Value>SSUpdateTime</Value>
</Value>
<Value name="14">
<Value>SSUpdateUserDR</Value>
</Value>
<Value name="15">
<Value>SSSingleQueue</Value>
</Value>
</Data>
<DataLocation>^CF.PE.StationSetD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.StationSetD</IdLocation>
<IndexLocation>^CF.PE.StationSetI</IndexLocation>
<StreamLocation>^User.DHCPEStationSetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
