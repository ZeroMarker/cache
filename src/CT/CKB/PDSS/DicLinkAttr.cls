Class CT.CKB.PDSS.DicLinkAttr Extends %Persistent [ SqlRowIdName = DLA_RowID, SqlTableName = DicLinkAttr ]
{

/// D ##class(CT.CKB.PDSS.DicLinkAttr).%BuildIndices()
/// 实体表id  
Property DLADicDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 2, SqlFieldName = DLA_Dic_Dr ];

/// DLA_AttrCode属性代码
Property DLAAttrCode As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 3, SqlFieldName = DLA_AttrCode ];

/// DLA_Attr_Dr 属性值
Property DLAAttrDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 4, SqlFieldName = DLA_Attr_Dr ];

/// DLA_Result 备注信息
Property DLAResult As %String(MAXLEN = 50000) [ SqlColumnNumber = 5, SqlFieldName = DLA_Result ];

/// DLA_GroupFlag 成组标识
Property DLAGroupFlag As %String(MAXLEN = 9999) [ SqlColumnNumber = 6, SqlFieldName = DLA_GroupFlag ];

/// /// DLA_TinyTag  富文本标签值
Property DLATinyTag As %Library.Text(MAXLEN = 50000) [ SqlColumnNumber = 7, SqlFieldName = DLA_TinyTag ];

Storage Default
{
<Data name="DicLinkAttrDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DLADicDr</Value>
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
<Value name="7">
<Value>DLATinyTag</Value>
</Value>
</Data>
<DataLocation>^CT.CKB.PDSS.DicLinkAttrD</DataLocation>
<DefaultData>DicLinkAttrDefaultData</DefaultData>
<IdLocation>^CT.CKB.PDSS.DicLinkAttrD</IdLocation>
<IndexLocation>^CT.CKB.PDSS.DicLinkAttrI</IndexLocation>
<StreamLocation>^CT.CKB.PDSS.DicLinkAttrS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

/// DLADicDr
/// DLAAttrCode
/// DLAAttrDr 
Index DicAttr On (DLADicDr As Exact, DLAAttrCode As Exact, DLAAttrDr As Exact);

Index LinkDicAttrCode On (DLADicDr As Exact, DLAAttrCode As Exact);

Index LinkAttr On DLAAttrDr As Exact;

Index LinkAttrCode On DLAAttrCode As Exact;

Index IndexLinkAttrCodeForDic On (DLAAttrCode As Exact, DLADicDr As Exact);

Index Reverse On (DLAAttrDr As Exact, DLAAttrCode As Exact);

Index LinkDic On DLADicDr As Exact;

}
