Class User.DHCPERoom Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ Inheritance = right, SqlTableName = DHC_PE_Room ]
{

Parameter ClassName = "User.DHCPERoom";

Relationship RParref As User.DHCPEArea [ Cardinality = parent, Inverse = ChildRoom ];

Relationship childSpecimen As User.DHCPERoomSpecimen [ Cardinality = children, Inverse = RSParRef ];

Relationship childIP As User.DHCPERoomIP [ Cardinality = children, Inverse = RIParRef ];

Relationship childSpecialRoom As User.DHCPERoomSpecialRoom [ Cardinality = children, Inverse = RSRParRef ];

Relationship childRoomPlace As User.DHCPERoomRoomPlace [ Cardinality = children, Inverse = parrefRoom ];

Relationship childRoomItem As User.DHCPERoomItem [ Cardinality = children, Inverse = RITMParRef ];

/// 代码
Property RCode As %String [ Required, SqlFieldName = R_Code ];

/// 描述
Property RDesc As %String [ Required, SqlFieldName = R_Desc ];

/// 序号
Property RSort As %String [ Required, SqlFieldName = R_Sort ];

/// 性别
Property RSex As %String [ SqlFieldName = R_Sex ];

/// 饭前饭后标志
Property RDiet As %String [ SqlFieldName = R_Diet ];

Property RDietFlag As %String [ SqlFieldName = R_DietFlag ];

/// 憋尿、排尿标志
Property REmictionFlag As %String [ SqlFieldName = R_EmictionFlag ];

/// 站点
Property RStationDR As %String [ SqlFieldName = R_Station_DR ];

/// 备注
Property RRemark As %String [ SqlFieldName = R_Remark ];

/// 花费时间
Property RMinute As %String [ SqlFieldName = R_Minute ];

Property RDoctor As %String [ SqlFieldName = R_Doctor ];

Property RActiveFlag As %String [ SqlFieldName = R_ActiveFlag ];

Property RShowNum As %String [ SqlFieldName = R_ShowNum ];

Property RBindFlag As %String [ SqlFieldName = R_BindFlag ];

Property RPEType As %String [ SqlFieldName = R_PEType ];

Property RSpecimenDR As %String [ SqlFieldName = R_SpecimenDR ];

/// / 主队列诊室 用于多个诊室一个队列的情况 
Property RMainManagerRoom As User.DHCPERoom [ SqlFieldName = R_MainManagerRoom ];

/// / 优先人数 设置诊室优先人数，少于设置人数，直接分诊到此诊室
Property RPriorNum As %String [ SqlFieldName = R_PriorNum ];

/// 更新日期
Property RUpdateDate As %Date [ SqlFieldName = R_UpdateDate ];

/// 更新时间
Property RUpdateTime As %Time [ SqlFieldName = R_UpdateTime ];

/// 更信人 指向SS_User
Property RUpdateUserDR As %String [ SqlFieldName = R_UpdateUserDR ];

/// 优先时间 
Property RPriorTime As %String [ SqlFieldName = R_PriorTime ];

Index RCodeIndex On RCode;

Index RDoctorIndex On RDoctor [ Unique ];

Index RStationIndex On RStationDR As AlphaUp;

Index RMainManagerRoomIndex On RMainManagerRoom;

Storage Default
{
<Data name="DHCPERoomDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RCode</Value>
</Value>
<Value name="3">
<Value>RDesc</Value>
</Value>
<Value name="4">
<Value>RDiet</Value>
</Value>
<Value name="5">
<Value>RSex</Value>
</Value>
<Value name="6">
<Value>RSort</Value>
</Value>
<Value name="7">
<Value>RStationDR</Value>
</Value>
<Value name="8">
<Value>RDietFlag</Value>
</Value>
<Value name="9">
<Value>REmictionFlag</Value>
</Value>
<Value name="10">
<Value>RSpecimenDR</Value>
</Value>
<Value name="11">
<Value>RRemark</Value>
</Value>
<Value name="12">
<Value>RMinute</Value>
</Value>
<Value name="13">
<Value>RDoctor</Value>
</Value>
<Value name="14">
<Value>RActiveFlag</Value>
</Value>
<Value name="15">
<Value>RShowNum</Value>
</Value>
<Value name="16">
<Value>RBindFlag</Value>
</Value>
<Value name="17">
<Value>RPEType</Value>
</Value>
<Value name="18">
<Value>RMainManagerRoom</Value>
</Value>
<Value name="19">
<Value>RPriorNum</Value>
</Value>
<Value name="20">
<Value>RUpdateDate</Value>
</Value>
<Value name="21">
<Value>RUpdateTime</Value>
</Value>
<Value name="22">
<Value>RUpdateUserDR</Value>
</Value>
<Value name="23">
<Value>RPriorTime</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("ChildRoom")</DataLocation>
<DefaultData>DHCPERoomDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEAreaC("ChildRoom")</IdLocation>
<IndexLocation>^User.DHCPERoomI</IndexLocation>
<StreamLocation>^User.DHCPERoomS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
