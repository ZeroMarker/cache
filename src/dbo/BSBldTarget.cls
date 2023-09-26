/// 单病种指标汇总
Class dbo.BSBldTarget Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlTableName = BS_BldTarget ]
{

Index IndexMaster On (HospDR, DateTypeId, TargetTypeId, TargetType, DataType) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKBSBldTargetId On RowID [ PrimaryKey, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医院代码
Property HospDR As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 3 ];

/// 日期类型 CHARGE：出院日期，MEDICAL：病案归档
Property DateTypeId As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

/// 指标类型  Y：年，M：月，Q：季度
Property TargetTypeId As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 5 ];

/// 指标值
Property TargetType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 6 ];

/// 数据类型 1出院人次,11出院人次(NO-HOSP)，2出院人数，
/// 16输血人次;161输血人次(NO-HOSP)，162输血人数，163输血人数(NO-HOSP)，
/// 5不良反应人次 51不良反应人次(NO-HOSP)
/// 6自体输血例数，
/// 7输血总量(出院日期)
/// 8红细胞总量,81红细胞总量(NO-HOSP)
/// 9全血总量,91全血总量(NO-HOSP)
/// 10年度用血总单位数据,101年度用血总单位数据(NO-HOSP)
/// 11接受申请单数量,111接受申请单数量(NO-HOSP)
/// 12合格申请单数量,121合格申请单数量(NO-HOSP)
/// 13一级和二级手术总台次,131一级和二级手术用血总单位数,132一级和二级手术总台次(NO-HOSP)133一级和二级手术总台次(NO-HOSP)
/// 14三级和四级手术总台次,141三级和四级手术用血总单位数,142一级和二级手术总台次(NO-HOSP)144三级和四级手术总台次(NO-HOSP)
/// 151手术患者自体输血回收总单位数,152手术患者自体输血回输总单位数,153手术患者自体输血例数
///  ,154贮存自体血总单位数,155贮存自体血自体输血例数
/// 20输血科(血库)专职专业技术人员数
/// 30受者血液标本复查血型数 31同期接收的受血者血液标本总数
/// 40开展室内质控的输血相容性检测项目数 41开展的输血相容性检测项目总数
/// 500参加室间质评的输血相容性检测项目数 501所参加的室间质评机构输血相容性检测室间质评项目总数
Property DataType As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 统计数量
Property StatValue As %Library.Float(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 填报数量
Property ReportedValue As %Library.Float(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 填报人
Property ReportUser As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

/// 填报日期
Property ReportDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

/// 填报时间
Property ReportTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BSBldTargetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospDR</Value>
</Value>
<Value name="3">
<Value>DateTypeId</Value>
</Value>
<Value name="4">
<Value>TargetTypeId</Value>
</Value>
<Value name="5">
<Value>TargetType</Value>
</Value>
<Value name="6">
<Value>DataType</Value>
</Value>
<Value name="7">
<Value>StatValue</Value>
</Value>
<Value name="8">
<Value>ReportedValue</Value>
</Value>
<Value name="9">
<Value>ReportUser</Value>
</Value>
<Value name="10">
<Value>ReportDate</Value>
</Value>
<Value name="11">
<Value>ReportTime</Value>
</Value>
</Data>
<DataLocation>^dbo.BSBldTargetD</DataLocation>
<DefaultData>BSBldTargetDefaultData</DefaultData>
<IdLocation>^dbo.BSBldTargetD</IdLocation>
<IndexLocation>^dbo.BSBldTargetI</IndexLocation>
<StreamLocation>^dbo.BSBldTargetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
