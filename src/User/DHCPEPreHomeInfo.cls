Class User.DHCPEPreHomeInfo Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PGADM_Home_RowId, SqlTableName = DHC_PE_PreHomeInfo ]
{

Parameter ClassName = "User.DHCPEPreHomeInfo";

/// PGADM_DR
Property PGADMDr As %Library.Integer [ SqlColumnNumber = 2, SqlFieldName = PGADM_DR ];

/// 主场开始日期
Property PGADMHomeBeginDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 3, SqlFieldName = PGADM_Home_BeginDate ];

/// 主场结束日期
Property PGADMHomeEndDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 4, SqlFieldName = PGADM_Home_EndDate ];

/// 男性人数
Property PGADMHomeMaleNum As %Library.Integer [ SqlColumnNumber = 5, SqlFieldName = PGADM_Home_Male_Num ];

/// 女性人数
Property PGADMHomeFemaleNum As %Library.Integer [ SqlColumnNumber = 6, SqlFieldName = PGADM_Home_Female_Num ];

/// 更新人
Property PGADMUpdateUserDR As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = PGADM_UpdateUser_DR ];

/// 更新日期
Property PGADMUpdateDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 8, SqlFieldName = PGADM_UpdateDate ];

/// 更新时间
Property PGADMUpdateTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = PGADM_UpdateTime ];

/// 日期
Property PGADMHomeDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 10, SqlFieldName = PGADM_Home_Date ];

/// 备注
Property PGADMHomeRemark As %String(MAXLEN = 1000) [ SqlColumnNumber = 12, SqlFieldName = PGADM_Home_Remark ];

/// 团体ID索引
Index PGADMDrIndex On PGADMDr;

/// 主场日期索引
Index PGADMHomeDateIndex On PGADMHomeDate;

/// 团体ID与日期索引
Index DateRPGADMDrIndex On (PGADMDr, PGADMHomeDate);

Relationship PGTimeInfo As User.DHCPEPreHomeTimeInfo [ Cardinality = children, Inverse = PHTParRef ];

/// 主场类型G：团体ID  C：合同ID
Property PGADMType As %String(MAXLEN = 2) [ SqlFieldName = PGADM_Type ];

Storage Default
{
<Data name="DHCPEPreHomeInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PGADMDr</Value>
</Value>
<Value name="3">
<Value>PGADMHomeBeginDate</Value>
</Value>
<Value name="4">
<Value>PGADMHomeEndDate</Value>
</Value>
<Value name="5">
<Value>PGADMHomeMaleNum</Value>
</Value>
<Value name="6">
<Value>PGADMHomeFemaleNum</Value>
</Value>
<Value name="7">
<Value>PGADMUpdateUserDR</Value>
</Value>
<Value name="8">
<Value>PGADMUpdateDate</Value>
</Value>
<Value name="9">
<Value>PGADMUpdateTime</Value>
</Value>
<Value name="10">
<Value>PGADMHomeDate</Value>
</Value>
<Value name="11">
<Value>PGADMType</Value>
</Value>
<Value name="12">
<Value>PGADMHomeRemark</Value>
</Value>
</Data>
<DataLocation>^User.DHCPEPreHomeInfoD</DataLocation>
<DefaultData>DHCPEPreHomeInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCPEPreHomeInfoD</IdLocation>
<IndexLocation>^User.DHCPEPreHomeInfoI</IndexLocation>
<StreamLocation>^User.DHCPEPreHomeInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
