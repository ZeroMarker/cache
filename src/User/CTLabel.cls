/// 名称:标签字典
/// 编写者:sunfengchao 
/// 编写日期:2021-05-08
Class User.CTLabel Extends (%Persistent, User.Abstract) [ SqlTableName = CT_Label ]
{

/// 标签代码
Property LabelCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Label_Code ];

/// 标签名称
Property LabelName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = Label_Name ];

/// 是否激活，Y、N
Property LabelActiveFlag As %String(DISPLAYLIST = ",Yes,No", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = Label_ActiveFlag ];

/// 备注
Property LabelRemark As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = Label_Remark ];

/// 表名 
Property LabelTableName As %String [ Required, SqlColumnNumber = 6, SqlFieldName = Label_TableName ];

/// 分类
Property LabelCategory As %String(MAXLEN = "") [ SqlColumnNumber = 7, SqlFieldName = Label_Category ];

Index TableIdx On LabelTableName;

Index TableLabelCodeIdx On (LabelTableName, LabelCode);

Index TableLabelNameIdx On (LabelTableName, LabelName);

Storage Default
{
<Data name="CTLabelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LabelCode</Value>
</Value>
<Value name="3">
<Value>LabelName</Value>
</Value>
<Value name="4">
<Value>LabelActiveFlag</Value>
</Value>
<Value name="5">
<Value>LabelRemark</Value>
</Value>
<Value name="6">
<Value>LabelTableName</Value>
</Value>
<Value name="7">
<Value>LabelCategory</Value>
</Value>
</Data>
<DataLocation>^User.CTLabelD</DataLocation>
<DefaultData>CTLabelDefaultData</DefaultData>
<IdLocation>^User.CTLabelD</IdLocation>
<IndexLocation>^User.CTLabelI</IndexLocation>
<StreamLocation>^User.CTLabelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
