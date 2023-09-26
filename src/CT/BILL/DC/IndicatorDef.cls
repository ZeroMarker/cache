Class CT.BILL.DC.IndicatorDef Extends (%Persistent, %XML.Adaptor, %ZEN.DataModel.Adaptor) [ SqlRowIdName = RowId, StorageStrategy = NewStorage1 ]
{

/// 指标代码
Property Code As %String(CAPTION = "指标代码", COLLATION = "EXACT") [ Required, SqlColumnNumber = 2, SqlFieldName = Code ];

/// 指标名称
Property Name As %String(CAPTION = "指标名称", COLLATION = "EXACT") [ SqlColumnNumber = 3, SqlFieldName = Name ];

/// 指标类型
Property IndicatorTypeId As %String(CAPTION = "指标类型", COLLATION = "EXACT") [ SqlColumnNumber = 4, SqlFieldName = IndicatorTypeId ];

/// 核查类型
Property CheckType As %String(CAPTION = "指标业务类型", COLLATION = "EXACT") [ Required, SqlColumnNumber = 5, SqlFieldName = CheckType ];

/// 异常等级
Property EXlevelId As %String(CAPTION = "异常等级", COLLATION = "EXACT") [ SqlColumnNumber = 6, SqlFieldName = EXlevelId ];

/// 监控点说明
Property Description As %String(CAPTION = "监控点说明", COLLATION = "EXACT", MAXLEN = 10000) [ SqlColumnNumber = 7, SqlFieldName = Description ];

/// 有效标志
Property ActiveFlag As %String(CAPTION = "有效标志", COLLATION = "EXACT") [ Required, SqlColumnNumber = 8, SqlFieldName = ActiveFlag ];

/// 执行类名
Property ExecClass As %String(CAPTION = "执行类名", COLLATION = "EXACT") [ SqlColumnNumber = 9, SqlFieldName = ExecClass ];

/// 执行类方法名
Property ExecClassMethod As %String(CAPTION = "执行类方法名", COLLATION = "EXACT") [ SqlColumnNumber = 10, SqlFieldName = ExecClassMethod ];

/// 院区
Property HospDr As %String(CAPTION = "院区", COLLATION = "EXACT") [ Required, SqlColumnNumber = 11, SqlFieldName = HospDr ];

/// -----
/// 创建人
Property OpterId As %String(CAPTION = "创建人", COLLATION = "EXACT") [ SqlColumnNumber = 12, SqlFieldName = OpterId ];

/// 创建日期
Property OptDate As %Library.Date(CAPTION = "创建日期") [ SqlColumnNumber = 13, SqlFieldName = OptDate ];

/// 创建时间
Property OptTime As %Library.Time(CAPTION = "创建时间") [ SqlColumnNumber = 14, SqlFieldName = OptTime ];

/// 更新人
Property UpdtId As %String(CAPTION = "更新人", COLLATION = "EXACT") [ SqlColumnNumber = 15, SqlFieldName = UpdtId ];

/// 更新日期
Property UpdtDate As %Library.Date(CAPTION = "更新日期") [ SqlColumnNumber = 16, SqlFieldName = UpdtDate ];

/// 更新时间
Property UpdtTime As %Library.Time(CAPTION = "更新时间") [ SqlColumnNumber = 17, SqlFieldName = UpdtTime ];

/// 指标业务类型
Property BusinessTypeCode As %String(CAPTION = "指标业务类型", COLLATION = "EXACT") [ Required, SqlColumnNumber = 18, SqlFieldName = BusinessTypeCode ];

/// HIS版本号
Property HISVer As %String(CAPTION = "HIS版本号", COLLATION = "EXACT", MAXLEN = 200) [ Required, SqlColumnNumber = 19, SqlFieldName = HISVer ];

/// HIS参考版本号
Property ReferenceHISVer As %String(CAPTION = "HIS参考版本号", COLLATION = "EXACT", MAXLEN = 500) [ SqlColumnNumber = 20, SqlFieldName = ReferenceHISVer ];

Index IndexHospActCheckType On (HospDr As Exact, ActiveFlag As Exact, CheckType As Exact);

/// 唯一索引
Index IndexUnique On (HospDr As Exact, ActiveFlag As Exact, BusinessTypeCode As Exact, Code As Exact);

Storage NewStorage1
{
<Data name="DataMaster">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>IndicatorTypeId</Value>
</Value>
<Value name="4">
<Value>CheckType</Value>
</Value>
<Value name="5">
<Value>EXlevelId</Value>
</Value>
<Value name="6">
<Value>Description</Value>
</Value>
<Value name="7">
<Value>ActiveFlag</Value>
</Value>
<Value name="8">
<Value>ExecClass</Value>
</Value>
<Value name="9">
<Value>ExecClassMethod</Value>
</Value>
<Value name="10">
<Value>HospDr</Value>
</Value>
<Value name="11">
<Value>OpterId</Value>
</Value>
<Value name="12">
<Value>OptDate</Value>
</Value>
<Value name="13">
<Value>OptTime</Value>
</Value>
<Value name="14">
<Value>UpdtId</Value>
</Value>
<Value name="15">
<Value>UpdtDate</Value>
</Value>
<Value name="16">
<Value>UpdtTime</Value>
</Value>
<Value name="17">
<Value>BusinessTypeCode</Value>
</Value>
<Value name="18">
<Value>HISVer</Value>
</Value>
<Value name="19">
<Value>ReferenceHISVer</Value>
</Value>
<Value name="20">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CT.BILL.DC.IndicatorDefD</DataLocation>
<DefaultData>DataMaster</DefaultData>
<IdLocation>^CT.BILL.DC.IndicatorDefD</IdLocation>
<IndexLocation>^CT.BILL.DC.IndicatorDefI</IndexLocation>
<StreamLocation>^CT.BILL.DC.IndicatorDefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
