Class CKB.PDSS.DicExtLinkAttr Extends (%Persistent, User.Abstract) [ SqlCategory = INTEGER, SqlRowIdName = DLA_RowID, SqlTableName = DicExtLinkAttr ]
{

/// D ##class(CKB.PDSS.DicExtLinkAttr).%BuildIndices()
/// 实体表id  // CKB.PDSS.ExtDiction
Property DLADicExtDr As %String [ SqlColumnNumber = 2, SqlFieldName = DLA_DicExt_Dr ];

/// DLA_AttrCode属性代码
Property DLAAttrCode As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 3, SqlFieldName = DLA_AttrCode ];

/// DLA_Attr_Dr 属性值
Property DLAAttrDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 4, SqlFieldName = DLA_Attr_Dr ];

/// DLA_Result 备注信息
Property DLAResult As %String(MAXLEN = 50000) [ SqlColumnNumber = 5, SqlFieldName = DLA_Result ];

/// DLA_GroupFlag 成组标识
Property DLAGroupFlag As %String(MAXLEN = 9999) [ SqlColumnNumber = 6, SqlFieldName = DLA_GroupFlag ];

Index AttrAll On (DLADicExtDr As Exact, DLAAttrCode As Exact, DLAAttrDr As Exact);

Index LinkDicAttrCode On (DLADicExtDr As Exact, DLAAttrCode As Exact);

Storage Default
{
<Data name="DicExtLinkAttrDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DLADicExtDr</Value>
</Value>
<Value name="3">
<Value>DLAAttrCode</Value>
</Value>
<Value name="4">
<Value>DLAAttrDr</Value>
</Value>
<Value name="5">
<Value>DLAResult</Value>
</Value>
<Value name="6">
<Value>DLAGroupFlag</Value>
</Value>
</Data>
<DataLocation>^CKB.PDSS.DicExtLinkAttrD</DataLocation>
<DefaultData>DicExtLinkAttrDefaultData</DefaultData>
<IdLocation>^CKB.PDSS.DicExtLinkAttrD</IdLocation>
<IndexLocation>^CKB.PDSS.DicExtLinkAttrI</IndexLocation>
<StreamLocation>^CKB.PDSS.DicExtLinkAttrS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
