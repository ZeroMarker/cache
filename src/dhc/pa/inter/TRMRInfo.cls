Class dhc.pa.inter.TRMRInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = TRMR_RowID, SqlTableName = TRMRInfo ]
{

//病案号

Property BAID As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = TRMR_BAID ];

//住院次数

Property zycs As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = TRMR_zycs ];

//入院日期

Property ryrq As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = TRMR_ryrq ];

//入院科室

Property ryks As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = TRMR_ryks ];

//出院日期

Property cyrq As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = TRMR_cyrq ];

//抢救次数

Property qjcs As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = TRMR_qjcs ];

//抢救成功次数

Property cgcs As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = TRMR_cgcs ];

//手术切口等级

Property zyssqkdj As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = TRMR_zyssqkdj ];

//确诊日期

Property qzrq As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 10, SqlFieldName = TRMR_qzrq ];

//手术日期

Property zyssrq As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 11, SqlFieldName = TRMR_zyssrq ];

//病案首页ID

Property BARowID As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = TRMR_BARowID ];

//出院科室

Property cyks As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = TRMR_cyks ];

//合计费用

Property hjf As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = TRMR_hjf ];

//付费方式(1,2 代表医保患者)

Property fffs As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 15, SqlFieldName = TRMR_fffs ];

//西药费

Property xyf As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = TRMR_xyf ];

//中成药费

Property zcyf As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 17, SqlFieldName = TRMR_zcyf ];

//草药费

Property cyf As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 18, SqlFieldName = TRMR_cyf ];

//住院天数

Property zyts As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 20, SqlFieldName = TRMR_zyts ];

//入院途径

Property rytj As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 21, SqlFieldName = TRMR_rytj ];

//入院科别

Property rykb As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 22, SqlFieldName = TRMR_rykb ];

//病房

Property bf As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 23, SqlFieldName = TRMR_bf ];

//出院情况

Property cyqk As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 24, SqlFieldName = TRMR_cyqk ];

//病案质量

Property bazl As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 25, SqlFieldName = TRMR_bazl ];

//门诊出院符合情况

Property mzcyfhqk As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 26, SqlFieldName = TRMR_mzcyfhqk ];

//抢救成功次数

Property qjcgcs As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 27, SqlFieldName = TRMR_qjcgcs ];

//入院出院诊断符合情况

Property zdfhqk As %Library.String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 0) [ SqlColumnNumber = 28, SqlFieldName = TRMR_zdfhqk ];

Index cyrq On cyrq As Exact;

Storage Default
{
<Data name="TRMRInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BAID</Value>
</Value>
<Value name="3">
<Value>BMSettleDate</Value>
</Value>
<Value name="4">
<Value>zycs</Value>
</Value>
<Value name="5">
<Value>ryrq</Value>
</Value>
<Value name="6">
<Value>ryks</Value>
</Value>
<Value name="7">
<Value>cyrq</Value>
</Value>
<Value name="8">
<Value>cgcs</Value>
</Value>
<Value name="9">
<Value>qjcs</Value>
</Value>
<Value name="10">
<Value>qzrq</Value>
</Value>
<Value name="11">
<Value>zyssqkdj</Value>
</Value>
<Value name="12">
<Value>zyssrq</Value>
</Value>
<Value name="13">
<Value>BARowID</Value>
</Value>
<Value name="14">
<Value>cyks</Value>
</Value>
<Value name="15">
<Value>hjf</Value>
</Value>
<Value name="16">
<Value>fffs</Value>
</Value>
<Value name="17">
<Value>cyf</Value>
</Value>
<Value name="18">
<Value>xyf</Value>
</Value>
<Value name="19">
<Value>zcyf</Value>
</Value>
<Value name="20">
<Value>zyts</Value>
</Value>
<Value name="21">
<Value>rytj</Value>
</Value>
<Value name="22">
<Value>rykb</Value>
</Value>
<Value name="23">
<Value>bf</Value>
</Value>
<Value name="24">
<Value>cyqk</Value>
</Value>
<Value name="25">
<Value>bazl</Value>
</Value>
<Value name="26">
<Value>mzcyfhqk</Value>
</Value>
<Value name="27">
<Value>qjcgcs</Value>
</Value>
<Value name="28">
<Value>zdfhqk</Value>
</Value>
</Data>
<DataLocation>^DHCJXPAMRInfoD</DataLocation>
<DefaultData>TRMRInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXPATRMRInfoD</IdLocation>
<IndexLocation>^DHCCJXPATRMRInfoI</IndexLocation>
<StreamLocation>^dhc.pa.inter.TRMRInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
