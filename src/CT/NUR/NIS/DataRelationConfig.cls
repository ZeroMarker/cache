/// 数据关系配置
Class CT.NUR.NIS.DataRelationConfig Extends (%Persistent, User.Abstract) [ SqlTableName = DataRelationConfig ]
{

/// 描述
Property DRCDesc As %String [ SqlColumnNumber = 2, SqlFieldName = DRC_Desc ];

/// 编码
Property DRCCode As %String [ Required, SqlColumnNumber = 3, SqlFieldName = DRC_Code ];

/// 医嘱Code串
Property DRCArcimCodeS As %String [ SqlColumnNumber = 4, SqlFieldName = DRC_ArcimCodeS ];

/// 类别
Property DRCType As %String(DISPLAYLIST = ",护理级别,病情级别,处置状态", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",1,2,3") [ SqlColumnNumber = 5, SqlFieldName = DRC_Type ];

/// 数据来源
Property DRCSource As %String(DISPLAYLIST = ",医嘱", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",1") [ SqlColumnNumber = 6, SqlFieldName = DRC_Source ];

/// 删除标记（0：未删除 1:删除）
Property DRCDelFlag As %String(MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",1") [ SqlColumnNumber = 7, SqlFieldName = DRC_DelFlag ];

/// 医院ID
Property DRCHospDR As User.CTHospital [ SqlColumnNumber = 8, SqlFieldName = DRC_HospDR ];

Index Code On (DRCHospDR, DRCCode);

Index Hosp On DRCHospDR;

Storage Default
{
<Data name="DataRelationConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DRCDesc</Value>
</Value>
<Value name="3">
<Value>DRCCode</Value>
</Value>
<Value name="4">
<Value>DRCArcimCodeS</Value>
</Value>
<Value name="5">
<Value>DRCType</Value>
</Value>
<Value name="6">
<Value>DRCSource</Value>
</Value>
<Value name="7">
<Value>DRCDelFlag</Value>
</Value>
<Value name="8">
<Value>DRCHospDR</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.NIS.DataRelationConfigD</DataLocation>
<DefaultData>DataRelationConfigDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.DataRelationConfigD</IdLocation>
<IndexLocation>^CT.NUR.NIS.DataRelationConfigI</IndexLocation>
<SqlRowIdName>DRC_RowID</SqlRowIdName>
<StreamLocation>^CT.NUR.NIS.DataRelationConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
