/// 分组子归集
Class DHCWL.CodeCfg.SubGroup Extends (%Persistent, DHCWL.ABSCodeCFG) [ ClassType = persistent, Inheritance = right, SqlTableName = DHCWLCodeCfgSubGroup ]
{

/// 关联分类大组
Property SGrpGrpDr As DHCWL.CodeCfg.Group [ SqlColumnNumber = 2, SqlFieldName = SGrp_Grp_Dr ];

/// 代码
Property SGrpCode As %String [ SqlColumnNumber = 3, SqlFieldName = SGrp_Code ];

/// 描述
Property SGrpDesc As %String [ SqlColumnNumber = 4, SqlFieldName = SGrp_Desc ];

/// 排序
Property SGrpSort As %Integer [ SqlColumnNumber = 5, SqlFieldName = SGrp_Sort ];

/// 树节点
Property SGrpTreeCode As %String [ SqlColumnNumber = 6, SqlFieldName = SGrp_TreeCode ];

/// 父节点
Property SGrpPTreeCode As %String [ SqlColumnNumber = 7, SqlFieldName = SGrp_PTreeCode ];

/// 层级
Property SGrpLevel As %Integer [ SqlColumnNumber = 8, SqlFieldName = SGrp_Level ];

Index GrpDr On SGrpGrpDr;

Index Code On (SGrpGrpDr, SGrpCode);

Index GrpDrSort On (SGrpGrpDr, SGrpSort);

Index GrpTreeCode On (SGrpGrpDr, SGrpTreeCode);

Index GrpPTreeCode On (SGrpGrpDr, SGrpPTreeCode);

Index GrpLevel On (SGrpGrpDr, SGrpLevel);

Index GrpLevelSort On (SGrpGrpDr, SGrpLevel, SGrpSort);

///          d ##class(DHCWL.CodeCfg.SubGroup).%BuildIndices()
///    	   ^DHCWL.CodeCfg.SubGroupD
///  		   ^DHCWL.CodeCfg.SubGroupI

Storage Default
{
<Data name="SubGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SGrpCode</Value>
</Value>
<Value name="3">
<Value>SGrpDesc</Value>
</Value>
<Value name="4">
<Value>SGrpGrpDr</Value>
</Value>
<Value name="5">
<Value>SGrpSort</Value>
</Value>
<Value name="6">
<Value>SGrpTreeCode</Value>
</Value>
<Value name="7">
<Value>SGrpPTreeCode</Value>
</Value>
<Value name="8">
<Value>SGrpLevel</Value>
</Value>
</Data>
<DataLocation>^DHCWL.CodeCfg.SubGroupD</DataLocation>
<DefaultData>SubGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.CodeCfg.SubGroupD</IdLocation>
<IndexLocation>^DHCWL.CodeCfg.SubGroupI</IndexLocation>
<StreamLocation>^DHCWL.CodeCfg.SubGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
