/// d ##class(DHCWL.MKPI.MMgrRptCfg).%BuildIndices()
/// DHCWL_MKPI.MMgrRptCfg
Class DHCWL.MKPI.MMgrRptCfg Extends %Persistent [ SqlRowIdName = RptCfg_RowID, SqlTableName = MMgrRptCfg ]
{

Parameter EXTENTSIZE = 250;

/// RptCfg_Code
Property RptCfgCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = RptCfg_Code ];

/// RptCfg_Desc
Property RptCfgDesc As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = RptCfg_Desc ];

/// RptCfg_Name
Property RptCfgName As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RptCfg_Name ];

/// RptCfg_TreeCode
Property RptCfgTreeCode As %Library.String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = RptCfg_TreeCode ];

//Index DatasetMCodeIdx On (RptCfgTreeCode, RptCfgCode);这个索引的命名不规范，修改为：RptMCodeIdx

Index RptMCodeIdx On (RptCfgTreeCode, RptCfgCode);

ClassMethod InsertOrUpdateData(ByRef aryParam) As %String
{
	//n (aryParam)
	s ret=""
	s treeCode=aryParam("RptCfgTreeCode")
	s code=aryParam("RptCfgCode")
	if $d(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,code)) {
		//如果已存在则更新
		s ID=$o(^DHCWL.MKPI.MMgrRptCfgI("RptMCodeIdx",treeCode,code,""))
		q:$G(ID)="" ret
		s obj=##class(DHCWL.MKPI.MMgrRptCfg).%OpenId(ID)
		if $isobject(obj) {
			s obj.RptCfgDesc=aryParam("RptCfgDesc")
			s obj.RptCfgName=aryParam("RptCfgName")
			s sc=obj.%Save()
			If $$$ISERR(sc) {
				s ret=$System.Status.GetErrorText(sc)
			}else{
				s ret="success"
			} 
		}else{
			q "打开报表对象："_code_"失败！"
		}
		
	}else{
		s treeCode=aryParam("RptCfgTreeCode")
		if '$d(^DHCWL.MKPI.MMgrModuleCfgI("ModuleCfgTreeCodeUnqIdx1",treeCode)) {
			//如果父节点不存在，返回错误信息	
			q "报表对象："_treeCode_"的父节点不存在！"
		}else{
			//添加新数据
			s obj=##class(DHCWL.MKPI.MMgrRptCfg).%New()
			if $isobject(obj) {
				s obj.RptCfgCode=aryParam("RptCfgCode")
				s obj.RptCfgDesc=aryParam("RptCfgDesc")
				s obj.RptCfgName=aryParam("RptCfgName")
				s obj.RptCfgTreeCode=aryParam("RptCfgTreeCode")
				s sc=obj.%Save()
				If $$$ISERR(sc) {
					s ret=$System.Status.GetErrorText(sc)
				}else{
					s ret="success"
				} 
			}else{
				q "新建报表对象："_aryParam("RptCfgCode")_"失败！"
			}
		}
	}
	q ret
}

Storage Default
{
<Data name="MMgrRptCfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>RptCfgCode</Value>
</Value>
<Value name="3">
<Value>RptCfgDesc</Value>
</Value>
<Value name="4">
<Value>RptCfgName</Value>
</Value>
<Value name="5">
<Value>RptCfgTreeCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MMgrRptCfgD</DataLocation>
<DefaultData>MMgrRptCfgDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCWL.MKPI.MMgrRptCfgD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MMgrRptCfgI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MMgrRptCfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
