Class CT.CKB.PDSS.DrugLibaryRef Extends %Persistent [ SqlRowIdName = ID, SqlTableName = DrugLibaryRef ]
{

// w ##class(CT.CKB.PDSS.DrugLibaryRef).%BuildIndices()

/// 药品id   DLR_Drug_Dr
Property DLRDrugDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 2, SqlFieldName = DLR_Drug_Dr ];

/// 规则目录id  DLR_Libary_Dr
Property DLRLibaryDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 3, SqlFieldName = DLR_Libary_Dr ];

/// 规则id  DLR_Rule_Dr
Property DLRRuleDr As CT.CKB.PDSS.Rule [ SqlColumnNumber = 4, SqlFieldName = DLR_Rule_Dr ];

/// 药品字典id  DLR_DicParref_Dr
Property DLRDicParrefDr As CT.CKB.PDSS.CommonDiction [ SqlColumnNumber = 5, SqlFieldName = DLR_DicParref_Dr ];

/// 规则序号(规则排序用)  DLR_OrderNum
Property DLROrderNum As %Library.String [ SqlColumnNumber = 6, SqlFieldName = DLR_OrderNum ];

Index DrugLibRule On (DLRDrugDr, DLRLibaryDr, DLRRuleDr) [ Unique ];

Index ParrefLibRule On (DLRDicParrefDr, DLRLibaryDr, DLRRuleDr);

Index DrugRule On (DLRDrugDr, DLRRuleDr);

Index LibaryRule On (DLRLibaryDr, DLRRuleDr);

Storage Default
{
<Data name="DrugLibaryRefDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DLRDrugDr</Value>
</Value>
<Value name="3">
<Value>DLRLibaryDr</Value>
</Value>
<Value name="4">
<Value>DLRRuleDr</Value>
</Value>
<Value name="5">
<Value>DLRDicParrefDr</Value>
</Value>
<Value name="6">
<Value>DLROrderNum</Value>
</Value>
</Data>
<DataLocation>^CT.CKB.PDSS.DrugLibaryRefD</DataLocation>
<DefaultData>DrugLibaryRefDefaultData</DefaultData>
<IdLocation>^CT.CKB.PDSS.DrugLibaryRefD</IdLocation>
<IndexLocation>^CT.CKB.PDSS.DrugLibaryRefI</IndexLocation>
<StreamLocation>^CT.CKB.PDSS.DrugLibaryRefS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
