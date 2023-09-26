Class User.DHCDocConfigFind Extends (%Persistent, %XML.Adaptor) [ SqlTableName = DHCDoc_ConfigFind ]
{

/// 产品线
Property productLine As %String(COLLATION = "EXACT") [ SqlColumnNumber = 2, SqlFieldName = productLine ];

/// 主页面csp
Property mainCSPCode As %String [ SqlColumnNumber = 3, SqlFieldName = mainCSPCode ];

/// 主页面名称
Property mainCSPName As %String [ SqlColumnNumber = 4, SqlFieldName = mainCSPName ];

/// 元素所在页csp
Property itemCSPCode As %String(COLLATION = "EXACT", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = itemCSPCode ];

/// 元素所在页名称
Property itemCSPName As %String [ SqlColumnNumber = 6, SqlFieldName = itemCSPName ];

/// 元素所在单元ID
Property itemUnitCode As %String [ SqlColumnNumber = 7, SqlFieldName = itemUnitCode ];

/// 元素所在单元描述
Property itemUnitName As %String(COLLATION = "EXACT") [ SqlColumnNumber = 8, SqlFieldName = itemUnitName ];

/// 元素ID
Property itemID As %String(COLLATION = "EXACT") [ SqlColumnNumber = 9, SqlFieldName = itemID ];

/// 元素名称
Property itemName As %String(COLLATION = "EXACT") [ SqlColumnNumber = 10, SqlFieldName = itemName ];

/// 元素说明
Property itemRemarks As %String(MAXLEN = "") [ SqlColumnNumber = 11, SqlFieldName = itemRemarks ];

/// 主页面是否为链接页面
Property mainCSPIsLink As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 12, SqlFieldName = mainCSPIsLink ];

/// 页面说明
Property itemCSPRemarks As %String(MAXLEN = "") [ SqlColumnNumber = 13, SqlFieldName = itemCSPRemarks ];

/// 界面是否激活，N代表失效，其他代表有效
Property itemActive As %String(COLLATION = "EXACT", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = itemActive ];

Index productLine On productLine;

Index mainCSPCode On (productLine, mainCSPCode);

Index itemCSPCode On (productLine, mainCSPCode, itemCSPCode);

Index itemUnitCode On (productLine, mainCSPCode, itemCSPCode, itemUnitCode);

Index itemName On itemName;

Index itemID On (itemCSPCode, itemID);

Storage Default
{
<Data name="DHCDocConfigFindDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>productLine</Value>
</Value>
<Value name="3">
<Value>mainCSPCode</Value>
</Value>
<Value name="4">
<Value>mainCSPName</Value>
</Value>
<Value name="5">
<Value>itemCSPCode</Value>
</Value>
<Value name="6">
<Value>itemCSPName</Value>
</Value>
<Value name="7">
<Value>itemUnitCode</Value>
</Value>
<Value name="8">
<Value>itemUnitName</Value>
</Value>
<Value name="9">
<Value>itemID</Value>
</Value>
<Value name="10">
<Value>itemName</Value>
</Value>
<Value name="11">
<Value>itemRemarks</Value>
</Value>
<Value name="12">
<Value>mainCSPIsLink</Value>
</Value>
<Value name="13">
<Value>itemCSPRemarks</Value>
</Value>
<Value name="14">
<Value>itemActive</Value>
</Value>
</Data>
<DataLocation>^User.DHCDocConfigFindD</DataLocation>
<DefaultData>DHCDocConfigFindDefaultData</DefaultData>
<IdLocation>^User.DHCDocConfigFindD</IdLocation>
<IndexLocation>^User.DHCDocConfigFindI</IndexLocation>
<StreamLocation>^User.DHCDocConfigFindS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
