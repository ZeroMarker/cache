Class User.PALongICD Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_LongICD ]
{

Index LICDPAPMIDrIndex On LICDPAPMIDR;

Index LICDLICDDrIndex On LICDLICDDR;

Index LICDICDDrIndex On LICDICDDR;

Index LICDPatICDDRIndex On (LICDPAPMIDR, LICDICDDR);

/// 患者ID
Property LICDPAPMIDR As PAPatMas [ SqlColumnNumber = 2, SqlFieldName = LICD_PAPMI_DR ];

Property LICDLICDDR As PALongICD [ SqlColumnNumber = 3, SqlFieldName = LICD_LICD_DR ];

/// ICD 诊断ID
Property LICDICDDR As MRCICDDx [ SqlColumnNumber = 4, SqlFieldName = LICD_ICD_DR ];

/// 插入日期
Property LICDAddDate As %Date [ SqlColumnNumber = 5, SqlFieldName = LICD_AddDate ];

/// 插入时间
Property LICDAddTime As %Time [ SqlColumnNumber = 6, SqlFieldName = LICD_AddTime ];

/// 插入人
Property LICDAddUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = LICD_AddUser_DR ];

/// 最后更新日期
Property LICDUpdateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = LICD_UpdateDate ];

/// 最后更新时间
Property LICDUpdateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = LICD_UpdateTime ];

/// 最后更新人
Property LICDUpdateUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = LICD_UpdateUser_DR ];

/// 长效标识
Property LICDLongFlag As %String(DISPLAYLIST = ",Loc,Hosp", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",L,H") [ SqlColumnNumber = 11, SqlFieldName = LICD_LongFlag ];

/// 插入科室
Property LICDLocDR As CTLoc [ SqlColumnNumber = 12, SqlFieldName = LICD_Loc_DR ];

/// 结束日期
Property LICDEndDate As %Date [ SqlColumnNumber = 13, SqlFieldName = LICD_EndDate ];

/// 结束时间
Property LICDEndTime As %Date [ SqlColumnNumber = 14, SqlFieldName = LICD_EndTime ];

/// 结构化诊断信息
Property LICDSDSInfo As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = LICD_SDSInfo ];

Storage Default
{
<Data name="PALongICDDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LICDPAPMIDR</Value>
</Value>
<Value name="3">
<Value>LICDLICDDR</Value>
</Value>
<Value name="4">
<Value>LICDICDDR</Value>
</Value>
<Value name="5">
<Value>LICDAddDate</Value>
</Value>
<Value name="6">
<Value>LICDAddTime</Value>
</Value>
<Value name="7">
<Value>LICDAddUserDR</Value>
</Value>
<Value name="8">
<Value>LICDUpdateDate</Value>
</Value>
<Value name="9">
<Value>LICDUpdateTime</Value>
</Value>
<Value name="10">
<Value>LICDUpdateUserDR</Value>
</Value>
<Value name="11">
<Value>LICDLongFlag</Value>
</Value>
<Value name="12">
<Value>LICDLocDR</Value>
</Value>
<Value name="13">
<Value>LICDEndDate</Value>
</Value>
<Value name="14">
<Value>LICDEndTime</Value>
</Value>
<Value name="15">
<Value>LICDSDSInfo</Value>
</Value>
</Data>
<DataLocation>^User.PALongICDD</DataLocation>
<DefaultData>PALongICDDefaultData</DefaultData>
<IdLocation>^User.PALongICDD</IdLocation>
<IndexLocation>^User.PALongICDI</IndexLocation>
<StreamLocation>^User.PALongICDS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
