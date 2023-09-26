/// 网上套餐介绍主表
Class User.DHCPENetOrdSets Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_NetOrdSets ]
{

Parameter ClassName = "User.DHCPENetOrdSets";

/// his套餐ID
Property NOSHisSetsID As %String [ SqlFieldName = NOS_HisSetsID ];

/// 套餐描述
Property NOSDesc As %String [ Required, SqlFieldName = NOS_Desc ];

Index NOSDescIndex On NOSDesc [ Unique ];

/// 套餐价格
Property NOSPrice As %Integer [ SqlFieldName = NOS_Price ];

/// VIP等级
Property NOSVIPLevel As %String [ SqlFieldName = NOS_VIPLevel ];

/// 性别
Property NOSSex As %String [ SqlFieldName = NOS_Sex ];

/// 序号
Property NOSSort As %String [ SqlFieldName = NOS_Sort ];

/// 科室
Property NOSLocID As %String [ SqlFieldName = NOS_LocID ];

/// 激活
Property NOSActive As %String [ SqlFieldName = NOS_Active ];

/// 备注
Property NOSRemak As %String(MAXLEN = 100) [ SqlFieldName = NOS_Remak ];

/// 备用1
Property NOSNote1 As %String(MAXLEN = 100) [ SqlFieldName = NOS_Note1 ];

/// 备用2
Property NOSNote2 As %String(MAXLEN = 100) [ SqlFieldName = NOS_Note2 ];

/// His套餐ID索引
Index HisSetsIndex On NOSHisSetsID As AlphaUp;

/// 套餐包含项目分类
Relationship NOSItemTypeChild As User.DHCPENetSetsItemType [ Cardinality = children, Inverse = NSITParRef ];

/// 团体标志
Property NOSGIFlag As %String [ SqlFieldName = NOS_GIFlag ];

/// 更新日期
Property NOSUpdateDate As %Date [ SqlFieldName = NOS_UpdateDate ];

/// 更新时间
Property NOSUpdateTime As %Time [ SqlFieldName = NOS_UpdateTime ];

/// 更信人 指向SS_User
Property NOSUpdateUserDR As %String [ SqlFieldName = NOS_UpdateUserDR ];

/// 科室、序号索引
Index LocSort On (NOSLocID As AlphaUp, NOSSort As AlphaUp);

Storage Default
{
<Data name="DHCPENetOrdSetsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NOSHisSetsID</Value>
</Value>
<Value name="3">
<Value>NOSDesc</Value>
</Value>
<Value name="4">
<Value>NOSPrice</Value>
</Value>
<Value name="5">
<Value>NOSVIPLevel</Value>
</Value>
<Value name="6">
<Value>NOSSex</Value>
</Value>
<Value name="7">
<Value>NOSRemak</Value>
</Value>
<Value name="8">
<Value>NOSNote1</Value>
</Value>
<Value name="9">
<Value>NOSNote2</Value>
</Value>
<Value name="10">
<Value>NOSSort</Value>
</Value>
<Value name="11">
<Value>NOSLocID</Value>
</Value>
<Value name="12">
<Value>NOSGIFlag</Value>
</Value>
<Value name="13">
<Value>NOSActive</Value>
</Value>
<Value name="14">
<Value>NOSUpdateDate</Value>
</Value>
<Value name="15">
<Value>NOSUpdateTime</Value>
</Value>
<Value name="16">
<Value>NOSUpdateUserDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPENetOrdSetsD</DataLocation>
<DefaultData>DHCPENetOrdSetsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPENetOrdSetsD</IdLocation>
<IndexLocation>^User.DHCPENetOrdSetsI</IndexLocation>
<StreamLocation>^User.DHCPENetOrdSetsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
