/// Descript:项目预约管理树结构
/// Creator:wangguoying
Class User.DHCPEArcimPreTree Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract, User.Abstract) [ SqlTableName = DHC_PE_ArcimPreTree ]
{

Parameter ClassName = "User.DHCPEArcimPreTree";

/// 代码
Property APTCode As %String(COLLATION = "AlphaUp", MAXLEN = 8) [ Required, SqlColumnNumber = 2, SqlFieldName = APT_Code ];

/// 描述
Property APTDesc As %String [ Required, SqlColumnNumber = 3, SqlFieldName = APT_Desc ];

/// 父节点
Property APTParentNode As %String [ SqlColumnNumber = 4, SqlFieldName = APT_ParentNode ];

/// 类型  A：医嘱项   S：自定分类  
Property APTType As %String(VALUELIST = ",A,S") [ Required, SqlColumnNumber = 5, SqlFieldName = APT_Type ];

/// 类型为 A时指向 ARC_ItmMast
Property APTSourceDR As %String [ SqlColumnNumber = 6, SqlFieldName = APT_Source_DR ];

/// 备注  备用字段
Property APTRemark As %String [ SqlColumnNumber = 7, SqlFieldName = APT_Remark ];

/// 更新人
Property APTUpdateUserDR As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = APT_UpdateUser_DR ];

/// 操作日期
Property APTUpdateDate As %Date [ SqlColumnNumber = 9, SqlFieldName = APT_UpdateDate ];

/// 更新时间
Property APTUpdateTime As %Time [ SqlColumnNumber = 10, SqlFieldName = APT_UpdateTime ];

/// 分类条件 
Relationship APTCondition As User.DHCPEArcimNodeCondition [ Cardinality = children, Inverse = ANCParRef ];

/// 科室ID
Property APTLocDR As User.CTLoc [ Required, SqlColumnNumber = 11, SqlFieldName = APT_Loc_DR ];

Index CodeIndex On APTCode [ Unique ];

Index ParentNodeIndex On APTParentNode;

Index LocTypeSourceIndex On (APTLocDR, APTType, APTSourceDR);

/// Index LocTypeSourceIndex On (APTLocDR, APTType, APTSourceDR);
Storage Default
{
<Data name="DHCPEArcimPreTreeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>APTCode</Value>
</Value>
<Value name="3">
<Value>APTDesc</Value>
</Value>
<Value name="4">
<Value>APTParentNode</Value>
</Value>
<Value name="5">
<Value>APTType</Value>
</Value>
<Value name="6">
<Value>APTSourceDR</Value>
</Value>
<Value name="7">
<Value>APTRemark</Value>
</Value>
<Value name="8">
<Value>APTUpdateUserDR</Value>
</Value>
<Value name="9">
<Value>APTUpdateDate</Value>
</Value>
<Value name="10">
<Value>APTUpdateTime</Value>
</Value>
<Value name="11">
<Value>APTLocDR</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEArcimPreTreeD</DataLocation>
<DefaultData>DHCPEArcimPreTreeDefaultData</DefaultData>
<Description>
<![CDATA[Index LocTypeSourceIndex On (APTLocDR, APTType, APTSourceDR);]]></Description>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEArcimPreTreeD</IdLocation>
<IndexLocation>^User.DHCPEArcimPreTreeI</IndexLocation>
<StreamLocation>^User.DHCPEArcimPreTreeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
