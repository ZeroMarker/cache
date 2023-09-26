Class web.Util.DHCTTLanguageChinese Extends web.Util.DHCTTLanguage [ ProcedureBlock ]
{

ClassMethod initFindTableStructure(ByRef t)
{
	s t("find") = "查找"
	s t("find table structure") = "查找表结构"
	s t("table index structure")="表索引结构"
	s t("index info")="索引的详细信息"
	s t("pn") = "包名"
	s t("tn") = "表名"
	s t("ct") = "子表列表"
	s t("pt") = "父表"
	s t("history table")="历史列表"
	s t("Index Type")="索引类型"
	s t("Map Name")="索引名"
	s t("Index Detail")="索引结构"
	s t("Property Name")="属性名"
	s t("Node")="附加节点"
	s t("Delimiter")="分割符"
	s t("Piece")="分割位"
	s t("Type")="类型"
	s t("Field")="字段名"
	s t("PList")="PList位置"
	s t("Property Name Filter Tip")="输入属性名, 回车过滤列表."
	s t("Property Node Filter Tip")="输入附加节点, 回车过滤列表."
	s t("Piece Filter Tip")="输入分割位, 回车过滤列表"
	s t("Property Type Filter Tip")="输入属性类型, 回车过滤列表"
	s t("Field Filter Tip")="输入字段名, 回车过滤列表"
	s t("PList Filter Tip")="输入plist位置, 回车过滤列表"
}

ClassMethod initConfigPage(ByRef t)
{
	s t("history list")="显示《查询表结构》界面的历史列表"
	s t("Chinese")="汉语"
	s t("English")="英文"
	s t("CacheTT Config Title")="Cache工具配置"
	s t("Language Select")="语言选择"
	s t("AuthorizeDelTables")="允许《SQL》界面删除的表名集"
	s t("Submit")="提交"
}

ClassMethod initFindGlobal(ByRef t)
{
	s t("pn") = "包名"
	s t("gn") = "Global名"
	s t("findGlobal")= "查询Global"
	s t("find") = "查找"
	s t("Find Global Title")="查询Global"
	s t("ClassAndGlobal")="类与Global信息"
	s t("ClassAllName")="类名"
	s t("TableName")="表名"
	s t("SubScriptString")="Global详情" 
	s t("IndexType")="索引类型"
	s t("ClassAllName Tip")="输入类名, 回车过滤列表."
	s t("TableName Tip")="输入表名, 回车过滤列表."
	s t("SubScriptString Tip")="输入Global, 回车过滤列表."
	s t("IndexType Tip")="输入索引类型, 回车过滤列表."
}

ClassMethod initProject(ByRef t)
{
	s t("projectmanager") = "工程管理"
}

ClassMethod initXMLExport(ByRef t)
{
}

ClassMethod initXMLImport(ByRef t)
{
}

ClassMethod initXMLPrintEdit(ByRef t)
{
}

}
