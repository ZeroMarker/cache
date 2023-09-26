/// Descript:项目预约限额管理表
/// Creator:wangguoying
Class User.DHCPEArcimPreManager Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_ArcimPreManager ]
{

Parameter ClassName = "User.DHCPEArcimPreManager";

Property APMNode As User.DHCPEArcimPreTree [ Required, SqlColumnNumber = 2, SqlFieldName = APM_Node ];

/// 日期
Property APMDate As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = APM_Date ];

/// 日期
Property APMLoc As User.CTLoc [ Required, SqlColumnNumber = 4, SqlFieldName = APM_Loc ];

/// 数量
Property APMNum As %Integer [ Required, SqlColumnNumber = 5, SqlFieldName = APM_Num ];

/// 更新人
Property APMUpdateUserDR As User.SSUser [ SqlColumnNumber = 6, SqlFieldName = APM_UpdateUser_DR ];

/// 操作日期
Property APMUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = APM_UpdateDate ];

/// 更新时间
Property APMUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = APM_UpdateTime ];

Index LocNodeDateIndex On (APMLoc, APMNode, APMDate) [ Unique ];

Index NodeLocDateIndex On (APMNode, APMLoc, APMDate);

Method ToString()
{
	q:i%APMNode="" ""
	s conditionSub=$O(^User.DHCPEArcimPreTreeD(i%APMNode,"APTCondition",0))
	s desc = $lg(^User.DHCPEArcimPreTreeD(i%APMNode),3)
	s desc = desc_##class(web.DHCPE.ArcimPreManager).GetConditionDesc(i%APMNode_"||"_conditionSub)
	s ret = "节点：【"_desc_"】 "
	s ret = ret_"科室：【"_$P(^CTLOC(i%APMLoc),"^",2)_"】 "
	s ret = ret_"日期：【"_$ZD(i%APMDate,3)_"】 "
	s ret = ret_"数量：【"_i%APMNum_"】"
	q ret
}

Storage Default
{
<Data name="DHCPEArcimPreManagerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>APMNode</Value>
</Value>
<Value name="3">
<Value>APMDate</Value>
</Value>
<Value name="4">
<Value>APMLoc</Value>
</Value>
<Value name="5">
<Value>APMNum</Value>
</Value>
<Value name="6">
<Value>APMUpdateUserDR</Value>
</Value>
<Value name="7">
<Value>APMUpdateDate</Value>
</Value>
<Value name="8">
<Value>APMUpdateTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEArcimPreManagerD</DataLocation>
<DefaultData>DHCPEArcimPreManagerDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEArcimPreManagerD</IdLocation>
<IndexLocation>^User.DHCPEArcimPreManagerI</IndexLocation>
<StreamLocation>^User.DHCPEArcimPreManagerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
