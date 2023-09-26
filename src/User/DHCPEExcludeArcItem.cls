/// 科室排斥项目维护表
Class User.DHCPEExcludeArcItem Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_ExcludeArcItem ]
{

Parameter ClassName = "User.DHCPEExcludeArcItem";

///  医嘱项
Property EAArcItemDR As User.ARCItmMast [ Required, SqlFieldName = EA_ArcItemDR ];

///  排斥医嘱项
Property EAExArcItemDR As User.ARCItmMast [ Required, SqlFieldName = EA_ExArcItemDR ];

/// 更新日期
Property EAUpdateDate As %Date [ SqlFieldName = EA_UpdateDate ];

/// 更新时间
Property EAUpdateTime As %Time [ SqlFieldName = EA_UpdateTime ];

/// 更信人 指向SS_User
Property EAUpdateUserDR As %String [ SqlFieldName = EA_UpdateUserDR ];

///  医嘱项索引
Index EAArcItemIndex On EAArcItemDR;

///  排斥医嘱项索引
Index EAExArcItemIndex On EAExArcItemDR;

Storage Default
{
<Data name="DHCPEExcludeArcItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EAArcItemDR</Value>
</Value>
<Value name="3">
<Value>EAExArcItemDR</Value>
</Value>
<Value name="4">
<Value>EAUpdateDate</Value>
</Value>
<Value name="5">
<Value>EAUpdateTime</Value>
</Value>
<Value name="6">
<Value>EAUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEExcludeArcItemD</DataLocation>
<DefaultData>DHCPEExcludeArcItemDefaultData</DefaultData>
<IdLocation>^User.DHCPEExcludeArcItemD</IdLocation>
<IndexLocation>^User.DHCPEExcludeArcItemI</IndexLocation>
<StreamLocation>^User.DHCPEExcludeArcItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
