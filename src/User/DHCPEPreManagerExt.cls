/// Descript:项目预约限额管理表---全程医疗
/// Creator:wangguoying
Class User.DHCPEPreManagerExt Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ SqlTableName = DHC_PE_PreManagerExt ]
{

Parameter ClassName = "User.DHCPEPreManagerExt";

Relationship PMEDetail As User.DHCPEPreManagerDetail [ Cardinality = children, Inverse = PMEDParRef ];

/// 科室
Property PMELocDR As User.CTLoc [ Required, SqlColumnNumber = 2, SqlFieldName = PME_Loc_DR ];

/// 日期
Property PMEDate As %Date [ Required, SqlColumnNumber = 3, SqlFieldName = PME_Date ];

/// 限额类型 T：按总数限额 S：按性别  A：按年龄 IG：个团  M：金额
Property PMEType As %String(COLLATION = "ALPHAUP", VALUELIST = ",T,S,A,IG,M") [ Required, SqlColumnNumber = 4, SqlFieldName = PME_Type ];

/// 状态
Property PMEStatus As %String(COLLATION = "ALPHAUP", VALUELIST = ",Y,N") [ Required, SqlColumnNumber = 5, SqlFieldName = PME_Status ];

/// 总数量
Property PMENumTotal As %Integer [ SqlColumnNumber = 6, SqlFieldName = PME_NumTotal ];

/// 男性数量
Property PMENumMale As %Integer [ SqlColumnNumber = 7, SqlFieldName = PME_NumMale ];

/// 女性数量
Property PMENumFemale As %Integer [ SqlColumnNumber = 8, SqlFieldName = PME_NumFemale ];

/// 个人数量
Property PMENumPerson As %Integer [ SqlColumnNumber = 9, SqlFieldName = PME_NumPerson ];

/// 团体数量
Property PMENumGroup As %Integer [ SqlColumnNumber = 10, SqlFieldName = PME_NumGroup ];

/// 更新人
Property PMEUpdateUserDR As User.SSUser [ SqlColumnNumber = 11, SqlFieldName = PME_UpdateUser_DR ];

/// 操作日期
Property PMEUpdateDate As %Date [ SqlColumnNumber = 12, SqlFieldName = PME_UpdateDate ];

/// 更新时间
Property PMEUpdateTime As %Time [ SqlColumnNumber = 13, SqlFieldName = PME_UpdateTime ];

Index LocDateTypeIndex On (PMELocDR, PMEDate, PMEType) [ Unique ];

Storage Default
{
<Data name="DHCPEPreManagerExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PMELocDR</Value>
</Value>
<Value name="3">
<Value>PMEDate</Value>
</Value>
<Value name="4">
<Value>PMEType</Value>
</Value>
<Value name="5">
<Value>PMEStatus</Value>
</Value>
<Value name="6">
<Value>PMENumTotal</Value>
</Value>
<Value name="7">
<Value>PMENumMale</Value>
</Value>
<Value name="8">
<Value>PMENumFemale</Value>
</Value>
<Value name="9">
<Value>PMENumPerson</Value>
</Value>
<Value name="10">
<Value>PMENumGroup</Value>
</Value>
<Value name="11">
<Value>PMEUpdateUserDR</Value>
</Value>
<Value name="12">
<Value>PMEUpdateDate</Value>
</Value>
<Value name="13">
<Value>PMEUpdateTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEPreManagerExtD</DataLocation>
<DefaultData>DHCPEPreManagerExtDefaultData</DefaultData>
<IdLocation>^User.DHCPEPreManagerExtD</IdLocation>
<IndexLocation>^User.DHCPEPreManagerExtI</IndexLocation>
<StreamLocation>^User.DHCPEPreManagerExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
