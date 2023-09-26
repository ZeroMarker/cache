/// 就诊扩展医保信息表
/// 存储医保挂号、登记、结算等交易发生前,由个业务部门填写的信息
/// 20221210
Class User.INSUAdmExt Extends (%Persistent, User.Abstract) [ SqlTableName = INSU_AdmExt ]
{

/// 1	adm_dr 	就诊表Rowid
Property admDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = adm_dr ];

/// 2	mdtrt_grp_type	就诊人群类型	String	30	急诊或转诊的，必填
Property mdtrtGrpType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = mdtrt_grp_type ];

/// 3	otp_er_refl_flag	门诊急诊转诊标志	String	30	由医疗机构确认的人群类型，比如.国家突发公共事件相关人员（新冠）
Property otpErReflFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = otp_er_refl_flag ];

/// 4	ipt_type	住院类型	String	30	外伤就医时必填
Property iptType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ipt_type ];

/// 5	trum_flag	外伤标志	String	30	外伤就医时必填
Property trumFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = trum_flag ];

/// 6	rel_ttp_flag	涉及第三方标志	String	30	承诺是否涉及第三方，TRUM_FLAG外伤标志为“1”时，此项为必填
Property relTtpFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = rel_ttp_flag ];

/// 7	updt_id	更新操作员id	BigInt		ss_User.Rowid
Property updtId As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = updt_id ];

/// 8	updt_date	更新日期	Date	
Property updtDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 9, SqlFieldName = updt_date ];

/// 9	updt_time	更新时间	Time
Property updtTime As %Library.Time [ SqlColumnNumber = 10, SqlFieldName = updt_time ];

/// 10	er_flag	急诊标志	String	30	
Property erFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = er_flag ];

/// 11	need_ipt_flag	门诊转住院标志	String	30	
Property needIptFlag As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = need_ipt_flag ];

/// index admDr	就诊表Rowid
Index IdxadmDr On admDr As Exact;

/// index updtDate	更新日期
Index IdxupdtDate On updtDate As Exact;

Storage Default
{
<Data name="INSUAdmExtDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>admDr</Value>
</Value>
<Value name="3">
<Value>mdtrtGrpType</Value>
</Value>
<Value name="4">
<Value>otpErReflFlag</Value>
</Value>
<Value name="5">
<Value>iptType</Value>
</Value>
<Value name="6">
<Value>trumFlag</Value>
</Value>
<Value name="7">
<Value>relTtpFlag</Value>
</Value>
<Value name="8">
<Value>updtId</Value>
</Value>
<Value name="9">
<Value>updtDate</Value>
</Value>
<Value name="10">
<Value>updtTime</Value>
</Value>
<Value name="11">
<Value>erFlag</Value>
</Value>
<Value name="12">
<Value>needIptFlag</Value>
</Value>
</Data>
<DataLocation>^User.INSUAdmExtD</DataLocation>
<DefaultData>INSUAdmExtDefaultData</DefaultData>
<IdLocation>^User.INSUAdmExtD</IdLocation>
<IndexLocation>^User.INSUAdmExtI</IndexLocation>
<StreamLocation>^User.INSUAdmExtS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
