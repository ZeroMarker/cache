/// 名称：CT.PHA.PREADT.DicType
/// 描述：字典类型维护表
/// 字段：PDSCode：代码，PDSDesc：名称，PDSActiveFlag：是否可用，PDSHospDr：集团化医院
/// 编写人：chenzhaobo
/// 编写时间：2021-09-01
Class CT.PHA.PREADT.DicType Extends (%Persistent, User.Abstract) [ SqlRowIdName = PDS_RowID, SqlTableName = DicType ]
{

/// 代码
Property PDSCode As %String [ SqlColumnNumber = 2, SqlFieldName = PDS_Code ];

/// 名称
Property PDSDesc As %String [ SqlColumnNumber = 3, SqlFieldName = PDS_Desc ];

/// 是否可用
Property PDSActiveFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 4, SqlFieldName = PDS_ActiveFlag ];

/// 集团化医院
Property PDSHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = PDS_Hosp_Dr ];

Index Code On (PDSCode As AlphaUp, PDSHospDr);

Index Desc On (PDSDesc As AlphaUp, PDSHospDr);

Index Hosp On PDSHospDr As AlphaUp;

Storage Default
{
<Data name="DHCPrescDicTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PDSCode</Value>
</Value>
<Value name="3">
<Value>PDSDesc</Value>
</Value>
<Value name="4">
<Value>PDSActiveFlag</Value>
</Value>
<Value name="5">
<Value>PDSHospDr</Value>
</Value>
</Data>
<DataLocation>^CT.PHA.PREADT.DicTypeD</DataLocation>
<IdLocation>^CT.PHA.PREADT.DicTypeD</IdLocation>
<IndexLocation>^CT.PHA.PREADT.DicTypeI</IndexLocation>
<StreamLocation>^CT.PHA.PREADT.DicTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
