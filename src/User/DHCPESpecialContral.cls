/// 特殊项目权限维护
Class User.DHCPESpecialContral Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_SpecialContral ]
{

Parameter ClassName = "User.DHCPESpecialContral";

/// 科室（操作员所属科室） 指向CT_Loc
Property SCLocDR As %String [ SqlFieldName = SC_LocDR ];

/// 操作员 指向SS_User
Property SCUserDR As %String [ Required, SqlFieldName = SC_UserDR ];

/// 体检项目/站点项目
Property SCOrderDR As User.DHCPEStationOrder [ Required, SqlFieldName = SC_OrderDR ];

/// 作废标记
Property SCNoActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlFieldName = SC_NoActive ];

/// 更新日期
Property SCUpdateDate As %Date [ SqlFieldName = SC_UpdateDate ];

/// 更新时间
Property SCUpdateTime As %Time [ SqlFieldName = SC_UpdateTime ];

/// 更新人 指向SS_User
Property SCUpdateUserDR As %String [ SqlFieldName = SC_UpdateUserDR ];

/// 科室+操作员+体检项目 索引
Index IdxOfLocUserOrder On (SCLocDR, SCUserDR, SCOrderDR);

/// 操作员+体检项目 索引
Index IdxOfUserOrderDR On (SCUserDR, SCOrderDR);

Storage Default
{
<Data name="DefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SCLocDR</Value>
</Value>
<Value name="3">
<Value>SCUserDR</Value>
</Value>
<Value name="4">
<Value>SCOrderDR</Value>
</Value>
<Value name="5">
<Value>SCNoActive</Value>
</Value>
<Value name="6">
<Value>SCUpdateDate</Value>
</Value>
<Value name="7">
<Value>SCUpdateTime</Value>
</Value>
<Value name="8">
<Value>SCUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^CF.PE.SpecialContralD</DataLocation>
<DefaultData>DefaultData</DefaultData>
<IdLocation>^CF.PE.SpecialContralD</IdLocation>
<IndexLocation>^CF.PE.SpecialContralI</IndexLocation>
<StreamLocation>^User.DHCPESpecialContralS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
