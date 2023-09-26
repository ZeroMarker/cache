Class dbo.STQISpecTAT Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = ST_QISpecTAT ]
{

Index IndexMaster On (HospCode, OPPeriod, OPDate, ReqType, TimeInterval) [ SqlName = Index_Master, Type = index ];

Index IndexType On (HospCode, OPPeriod, OPDate, OPDataType, OPDataCode, ReqType, TimeInterval) [ SqlName = Index_Type, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSTQISpecTAT On RowID [ PrimaryKey, SqlName = PK_ST_QISpecTAT, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 999999999999999999, MINVAL = -999999999999999999) [ Identity, Required, SqlColumnNumber = 2 ];

/// 医院代码
Property HospCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 3 ];

/// 操作阶段1：检验前，2：实验中）
Property OPPeriod As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ Required, SqlColumnNumber = 4 ];

/// 1:申请科室,2:病房   
/// 3:医嘱              
/// 4:审核用户，5:工作小组
/// 6:医嘱组
/// 7:血培养标本总数，8:血培养污染标本总数，
/// 9:抗凝容器标本总数
/// 10:按细菌结果汇总
/// 11:按条码号汇总
Property OPDataType As %Library.String(COLLATION = "Exact", MAXLEN = 2) [ Required, SqlColumnNumber = 5 ];

/// 汇总代码
Property OPDataCode As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 6 ];

/// 检验前：接收日期，检验中：检验日期
Property OPDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 患者类型
Property ReqType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 8 ];

/// A	<=30
/// B	>30,<=60
/// C	>60,<=90
/// D	>90,<=120
/// E	>120,<=150
/// F	>150,<=180
/// G	>180,<=210
/// H	>210,<=240
/// I	>240,<=300
/// J	>300,<=360
/// K	>360,<=420
/// L	>420,<=480
/// M	>480,<=1440
/// N	>1440,<=2880
/// O	>2880
/// 时间间隔代码
Property TimeInterval As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 9 ];

/// 标本量汇总
Property SPSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 报告量汇总
Property ReportSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

Storage Default
{
<Data name="STQISpecTATDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospCode</Value>
</Value>
<Value name="3">
<Value>OPPeriod</Value>
</Value>
<Value name="4">
<Value>OPDataType</Value>
</Value>
<Value name="5">
<Value>OPDataCode</Value>
</Value>
<Value name="6">
<Value>OPDate</Value>
</Value>
<Value name="7">
<Value>ReqType</Value>
</Value>
<Value name="8">
<Value>TimeInterval</Value>
</Value>
<Value name="9">
<Value>SPSum</Value>
</Value>
<Value name="10">
<Value>ReportSum</Value>
</Value>
</Data>
<DataLocation>^dbo.STQISpecTATD</DataLocation>
<DefaultData>STQISpecTATDefaultData</DefaultData>
<IdLocation>^dbo.STQISpecTATD</IdLocation>
<IndexLocation>^dbo.STQISpecTATI</IndexLocation>
<StreamLocation>^dbo.STQISpecTATS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
