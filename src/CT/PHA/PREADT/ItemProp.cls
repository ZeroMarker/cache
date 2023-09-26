/// 名称：User.DHCPrescItemProp
/// 描述：字典项目属性表
/// 字段：PIPCode：代码，PIPDesc：名称，PIPActiveFlag：是否可用，PIPItemDr：父类指向
/// 编写人：chenzhaobo
/// 编写时间：2021-09-01
Class CT.PHA.PREADT.ItemProp Extends (%Persistent, User.Abstract) [ SqlRowIdName = PIP_RowID, SqlTableName = ItemProp ]
{

/// PIP_Code  代码
Property PIPCode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = PIP_Code ];

/// PIP_Desc  描述
Property PIPDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = PIP_Desc ];

/// 是否可用  PDI_ActiveFlag
Property PIPActiveFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = PIP_ActiveFlag ];

/// 类型指针  PIP_Item_Dr
Property PIPItemDr As CT.PHA.PREADT.DicItem [ SqlColumnNumber = 6, SqlFieldName = PIP_Item_Dr ];

Index Code On (PIPCode As AlphaUp, PIPItemDr);

Index Desc On (PIPDesc As AlphaUp, PIPItemDr);

Index ItemPar On PIPItemDr As AlphaUp;

Storage Default
{
<Data name="DHCPrescItemPropDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PIPCode</Value>
</Value>
<Value name="3">
<Value>PIPDesc</Value>
</Value>
<Value name="4">
<Value>PIPActiveFlag</Value>
</Value>
<Value name="5">
<Value>PIPItemDr</Value>
</Value>
</Data>
<DataLocation>^CT.PHA.PREADT.ItemPropD</DataLocation>
<IdLocation>^CT.PHA.PREADT.ItemPropD</IdLocation>
<IndexLocation>^CT.PHA.PREADT.ItemPropI</IndexLocation>
<StreamLocation>^CT.PHA.PREADT.ItemPropS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
