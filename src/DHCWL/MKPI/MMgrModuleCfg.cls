/// DHCWL_MKPI.MMgrModuleCfg
Class DHCWL.MKPI.MMgrModuleCfg Extends %Persistent [ ClassType = persistent, SqlRowIdName = ModuleCfg_RowID, SqlTableName = MMgrModuleCfg ]
{

Parameter EXTENTSIZE = 250;

/// ModuleCfg_Code
Property ModuleCfgCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = ModuleCfg_Code ];

/// ModuleCfg_Desc
Property ModuleCfgDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ModuleCfg_Desc ];

/// ModuleCfg_TreeCode
Property ModuleCfgTreeCode As %Library.String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = ModuleCfg_TreeCode ];

Property ModuleCfgPTreeCode As %Library.String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = ModuleCfg_PTreeCode ];

Index ModuleCfgTreeCodeUnqIdx1 On ModuleCfgTreeCode [ Unique ];

Index ModuleCfgPTreeCodeIndex On ModuleCfgPTreeCode;

ClassMethod InsertOrUpdateData(ByRef aryParam) As %String
{
	//n (aryParam)
	s treeCode=aryParam("ModuleCfgTreeCode")
	s ret=""
	if $d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",treeCode)) {
		//如果已存在则更新
		s ID=$o(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",treeCode,""))
		q:$G(ID)="" ret
		s obj=##class(DHCWL.MKPI.MMgrModuleCfg).%OpenId(ID)
		if $isobject(obj) {
			s obj.ModuleCfgDesc=aryParam("ModuleCfgDesc")
			s sc=obj.%Save()
			If $$$ISERR(sc) {
				s ret=$System.Status.GetErrorText(sc)
			}else{
				s ret="success"
			} 
		}else{
			q "打开模块对象："_treeCode_"失败！"
		}
		
	}else{
		s pTreeCode=aryParam("ModuleCfgPTreeCode")
		if ((pTreeCode'="root") && ('$d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",pTreeCode)))) {
			//如果父节点不存在，返回错误信息	
			q "模块对象："_treeCode_"的父节点:"_pTreeCode_"不存在！"
		}else{
			//添加新数据
			s obj=##class(DHCWL.MKPI.MMgrModuleCfg).%New()
			if $isobject(obj) {
				s obj.ModuleCfgDesc=aryParam("ModuleCfgDesc")
				s obj.ModuleCfgCode=aryParam("ModuleCfgCode")
				s obj.ModuleCfgTreeCode=aryParam("ModuleCfgTreeCode")
				s obj.ModuleCfgPTreeCode=pTreeCode
				s sc=obj.%Save()
				If $$$ISERR(sc) {
					s ret=$System.Status.GetErrorText(sc)
				}else{
					s ret="success"
				} 
			}else{
				q "新建模块对象："_treeCode_"失败！"
			}
		}
	}
	q ret
}

Storage Default
{
<Data name="MMgrModuleCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModuleCfgCode</Value>
</Value>
<Value name="3">
<Value>ModuleCfgDesc</Value>
</Value>
<Value name="4">
<Value>ModuleCfgTreeCode</Value>
</Value>
<Value name="5">
<Value>ModuleCfgPTreeCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MMgrModuleCfgD</DataLocation>
<DefaultData>MMgrModuleCfgDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCWL.MKPI.MMgrModuleCfgD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MMgrModuleCfgI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MMgrModuleCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
