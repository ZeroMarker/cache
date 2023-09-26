Class CKB.PDSS.MonMaster Extends (%Persistent, User.Abstract) [ SqlRowIdName = CM_RowID, SqlTableName = MonMaster ]
{

// w ##class(CKB.PDSS.MonMaster).%BuildIndices()

/// 就诊标识   CM_Adm_Dr
Property CMAdmDr As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CM_Adm_Dr ];

/// 创建日期  CM_CreateDate
Property CMCreateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = CM_CreateDate ];

/// 创建时间  CM_CreateTime
Property CMCreateTime As %Library.Time [ SqlColumnNumber = 4, SqlFieldName = CM_CreateTime ];

/// 创建人  CM_CreateUser
Property CMCreateUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = CM_CreateUser ];

/// 科室  CM_LocDesc
Property CMLocDesc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CM_LocDesc ];

/// 审查结果  CM_PassFlag(0-不通过,1或空通过)
Property CMPassFlag As %Library.String [ SqlColumnNumber = 7, SqlFieldName = CM_PassFlag ];

/// 管理级别  CM_ManLev_Dr
Property CMManLevDr As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CM_ManLev_Dr ];

/// 审查内容   CM_ExaParam
Property CMExaParam As %Library.String(COLLATION = "Exact", MAXLEN = 99999, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CM_ExaParam ];

/// 审查结果   CM_ExaRes
Property CMExaRes As %Library.String(COLLATION = "Exact", MAXLEN = 99999, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CM_ExaRes ];

/// IP地址   CM_Ip
Property CMIp As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = CM_Ip ];

/// 医院   CM_Hosp
Property CMHosp As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = CM_Hosp ];

/// 规则来源 CM_Source(本表id||来源) --(院内规则Own,药事云Pha,市医保Med,省监管Pro)
Property CMSource As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = CM_Source ];

/// 调用场景类型 Doc(医生)/Pha(药师)/Nur(护士) 2021-06-18
Property CMUserType As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = CM_UserType ];

/// 通过类型 (合理通过P,强制审核通过R,药师复核通过,药师拒绝) 2021-06-18
Property CMPassType As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = CM_PassType ];

/// 是否生成处方标志(Y/N) Y-生成处方,N没有生成处方 2021-06-18
Property CMPrescFlag As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = CM_PrescFlag ];

/// 审核原因(勾选) 2021-06-18
Property CMAduitReason As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = CM_AduitReason ];

/// 关联上一次的日志id(流转信息用) 2021-06-18
Property CMLastId As %Library.String(COLLATION = "Exact", MAXLEN = 99, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = CM_LastId ];

/// 审核原因(备注) 2021-06-18
Property CMAduitNotes As %Library.String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 0) [ SqlColumnNumber = 19, SqlFieldName = CM_AduitNotes ];

Index CreateDate On CMCreateDate As Exact;

Index DatePass On (CMCreateDate As Exact, CMPassFlag As Exact);

Storage Default
{
<Data name="MonMasterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CMAdmDr</Value>
</Value>
<Value name="3">
<Value>CMCreateDate</Value>
</Value>
<Value name="4">
<Value>CMCreateTime</Value>
</Value>
<Value name="5">
<Value>CMCreateUser</Value>
</Value>
<Value name="6">
<Value>CMLocDesc</Value>
</Value>
<Value name="7">
<Value>CMPassFlag</Value>
</Value>
<Value name="8">
<Value>CMManLevDr</Value>
</Value>
<Value name="9">
<Value>CMExaParam</Value>
</Value>
<Value name="10">
<Value>CMExaRes</Value>
</Value>
<Value name="11">
<Value>CMIp</Value>
</Value>
<Value name="12">
<Value>CMHosp</Value>
</Value>
<Value name="13">
<Value>CMSource</Value>
</Value>
<Value name="14">
<Value>CMUserType</Value>
</Value>
<Value name="15">
<Value>CMPassType</Value>
</Value>
<Value name="16">
<Value>CMPrescFlag</Value>
</Value>
<Value name="17">
<Value>CMAduitReason</Value>
</Value>
<Value name="18">
<Value>CMLastId</Value>
</Value>
<Value name="19">
<Value>CMAduitNotes</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.MonMasterD</DataLocation>
<DefaultData>MonMasterDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.MonMasterD</IdLocation>
<IndexLocation>^CKB.PDSS.MonMasterI</IndexLocation>
<StreamLocation>^CKB.PDSS.MonMasterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
