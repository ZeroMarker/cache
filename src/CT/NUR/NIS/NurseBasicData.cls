Class CT.NUR.NIS.NurseBasicData Extends (%Persistent, User.Abstract) [ SqlTableName = NurseBasicData ]
{

/// 数据编码
Property NBDCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = NBD_Code ];

/// 数据类型
Property NBDType As %String(DISPLAYLIST = ",患者信息,医嘱信息,执行记录信息,打印信息,护理计划,分娩信息", MAXLEN = 10, TRUNCATE = 1, VALUELIST = ",0,1,2,3,4,5") [ Required, SqlColumnNumber = 3, SqlFieldName = NBD_Type ];

/// 名称
Property NBDName As %String [ SqlColumnNumber = 4, SqlFieldName = NBD_Name ];

/// 备注
Property NBDNote As %String(MAXLEN = 200) [ SqlColumnNumber = 5, SqlFieldName = NBD_Note ];

/// 表达式
Property NBDExpression As %String(MAXLEN = 200) [ SqlColumnNumber = 6, SqlFieldName = NBD_Expression ];

/// 删除标记（0：未删除 1:删除）
Property NBDDeleteFlag As %String [ InitialExpression = "0", SqlColumnNumber = 7, SqlFieldName = NBD_DeleteFlag ];

Index Code On (NBDType, NBDCode);

Index Type On NBDType;

ClassMethod GetNBDTypeDesc(NBDType)
{
	q:NBDType="" NBDType
	q ..NBDTypeLogicalToDisplay(NBDType)
}

Storage Default
{
<Data name="NurseBasicDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>NBDCode</Value>
</Value>
<Value name="3">
<Value>NBDType</Value>
</Value>
<Value name="4">
<Value>NBDName</Value>
</Value>
<Value name="5">
<Value>NBDNote</Value>
</Value>
<Value name="6">
<Value>NBDExpression</Value>
</Value>
<Value name="7">
<Value>NBDDeleteFlag</Value>
</Value>
</Data>
<DataLocation>^CT.NUR.NIS.NurseBasicDataD</DataLocation>
<DefaultData>NurseBasicDataDefaultData</DefaultData>
<IdLocation>^CT.NUR.NIS.NurseBasicDataD</IdLocation>
<IndexLocation>^CT.NUR.NIS.NurseBasicDataI</IndexLocation>
<StreamLocation>^CT.NUR.NIS.NurseBasicDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
