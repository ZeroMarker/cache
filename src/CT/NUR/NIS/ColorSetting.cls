/// 颜色配置
Class CT.NUR.NIS.ColorSetting Extends (%Persistent, User.Abstract) [ SqlRowIdName = CS_RowID, SqlTableName = ColorSetting ]
{

/// 类别
Property CSType As %String(DISPLAYLIST = ",护理级别,病情级别,处置状态,医保类型,性别,其他", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",1,2,3,4,5,6") [ Required, SqlColumnNumber = 2, SqlFieldName = CS_Type ];

/// 配置项
Property CSItemDR As CT.NUR.NIS.DataRelationConfig [ Required, SqlColumnNumber = 3, SqlFieldName = CS_ItemDR ];

/// 项目编码
Property CSItemCode As %String [ Required, SqlColumnNumber = 4, SqlFieldName = CS_ItemCode ];

/// 颜色
Property CSItemColor As %String [ SqlColumnNumber = 5, SqlFieldName = CS_ItemColor ];

/// 删除标记（0：未删除 1:删除）
Property CSDelFlag As %String(MAXLEN = 8, TRUNCATE = 1, VALUELIST = ",1") [ SqlColumnNumber = 6, SqlFieldName = CS_DelFlag ];

/// 医院ID
Property CSHospDR As User.CTHospital [ SqlColumnNumber = 7, SqlFieldName = CS_HospDR ];

Index Code On (CSHospDR, CSItemCode);

Index Hosp On CSHospDR;

Storage Default
{
<Data name="ColorSettingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSType</Value>
</Value>
<Value name="3">
<Value>CSItemDR</Value>
</Value>
<Value name="4">
<Value>CSItemCode</Value>
</Value>
<Value name="5">
<Value>CSItemColor</Value>
</Value>
<Value name="6">
<Value>CSDelFlag</Value>
</Value>
<Value name="7">
<Value>CSHospDR</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.NIS.ColorSettingD</DataLocation>
<DefaultData>ColorSettingDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.ColorSettingD</IdLocation>
<IndexLocation>^CT.NUR.NIS.ColorSettingI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.ColorSettingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
