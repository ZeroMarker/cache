/// 名称：CT.PHA.PREADT.DicItem
/// 描述：字典项目维护表
/// 字段：PDICode：代码，PDIDesc：名称，PDIActiveFlag：是否可用，PDIHospDr：集团化医院，PDITypeDr：父类指向 
/// 编写人：chenzhaobo
/// 编写时间：2021-09-01
Class CT.PHA.PREADT.DicItem Extends (%Persistent, User.Abstract) [ SqlRowIdName = PDI_RowID, SqlTableName = DicItem ]
{

/// PDI_Code  代码
Property PDICode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = PDI_Code ];

/// PDI_Desc  描述
Property PDIDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PDI_Desc ];

/// 是否可用  PDI_ActiveFlag
Property PDIActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PDI_ActiveFlag ];

/// 集团化医院  PDI_Hosp_Dr
Property PDIHospDr As User.CTHospital [ SqlColumnNumber = 5, SqlFieldName = PDI_Hosp_Dr ];

/// 类型指针  PDI_Type_Dr
Property PDITypeDr As CT.PHA.PREADT.DicType [ SqlColumnNumber = 6, SqlFieldName = PDI_Type_Dr ];

/// 父节点id   huanghongping 2021/11/3 用于树的操作
Property PDIParId As %Library.String [ SqlColumnNumber = 7, SqlFieldName = PDI_Par_Id ];

Index Code On PDICode As AlphaUp;

Index Desc On PDIDesc As AlphaUp;

Index Hosp On PDIHospDr As AlphaUp;

Index TypePar On PDITypeDr As AlphaUp;

Index parref On PDIParId As AlphaUp;

Index HospCode On (PDIHospDr, PDICode As AlphaUp);

Storage Default
{
<Data name="DHCPrescDicItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PDICode</Value>
</Value>
<Value name="3">
<Value>PDIDesc</Value>
</Value>
<Value name="4">
<Value>PDIActiveFlag</Value>
</Value>
<Value name="5">
<Value>PDIHospDr</Value>
</Value>
<Value name="6">
<Value>PDITypeDr</Value>
</Value>
<Value name="7">
<Value>PDIParId</Value>
</Value>
</Data>
<DataLocation>^CT.PHA.PREADT.DicItemD</DataLocation>
<IdLocation>^CT.PHA.PREADT.DicItemD</IdLocation>
<IndexLocation>^CT.PHA.PREADT.DicItemI</IndexLocation>
<StreamLocation>^CT.PHA.PREADT.DicItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
