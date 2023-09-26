/// 名称: 电子病历树形展现界面模板表
/// 描述: 用于保存构造打印模板（或结构）下的界面模板的节点信息
/// 编写者：chenwenjun
/// 编写日期: 09/04/21
/// 
Class EPRmeta.EPRTemplate Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 界面Category名称（注：显示的不是界面模板名称）
Property EPRTemplateName As %String(TRUNCATE = 1);

/// EPRmeta.EPRTemplateCategory节点的DocID
Property EPRCategoryID As %String(TRUNCATE = 1);

/// 在同级节点的显示次序
Property EPRTemplateSeq As %Integer;

/// 绑定的界面模板ID
Property BindTemplateID As %String(TRUNCATE = 1);

/// 绑定的界面模板的CategoryID
Property BindTemplateCategoryID As %String(TRUNCATE = 1);

/// 是否是对应EPRCategoryID下的必填项(0--否 1--是)
Property NecessaryTemplate As %String(TRUNCATE = 1);

/// 加载界面模板对应规则定义.(EPRmeta.Privilege.PrivRule.Name)
Property PrivRuleDR As %String(TRUNCATE = 1);

Index IdxEPRCategoryID On EPRCategoryID;

Index IdxBindTemplateCategoryID On (BindTemplateCategoryID, EPRCategoryID);

Index IdxPrivRuleDR On PrivRuleDR;

Index IdxEPRTemplateSeq On (EPRCategoryID, EPRTemplateSeq);

Index IdxBindTemplateID On BindTemplateID;

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,EPRTemplateName:%String,EPRCategoryID:%String,EPRTemplateSeq:%Integer,BindTemplateID:%String,BindTemplateCategoryID:%String,NecessaryTemplate:%String")
{
	SELECT ID,EPRTemplateName,EPRCategoryID,EPRTemplateSeq,BindTemplateID,BindTemplateCategoryID,NecessaryTemplate
	FROM EPRmeta.EPRTemplate
	ORDER BY EPRTemplateSeq
}

ClassMethod GetBindTempIDByEPRCategory(argEPRCategoryID) As %String
{
	q:(argEPRCategoryID="") ""
	
	s allBindTemplateIDList = ""
	
	s count = $L(argEPRCategoryID,"^")
	for i=1:1:count
	{
		s categoryID = $P(argEPRCategoryID,"^",i)
		if allBindTemplateIDList=""
		{	s allBindTemplateIDList = $$GetBindTemplateID(categoryID)}
		else
		{	s allBindTemplateIDList = allBindTemplateIDList_"#"_$$GetBindTemplateID(categoryID)}
	}
	
	q allBindTemplateIDList
	
GetBindTemplateID(categoryID)
	s bindTemplateIDList = ""
	s id = "" 
	for {
		s id = $O(^DHCEPRM.EPRTemplateI("IdxEPRCategoryID", " "_categoryID, id))
		q:(id="")
		s obj = ##class(EPRmeta.EPRTemplate).%OpenId(id)
		s:(obj'="") bindTemplateIDList = bindTemplateIDList_"^"_obj.BindTemplateID	
	}
	if bindTemplateIDList'=""
	{	s bindTemplateIDList = $E(bindTemplateIDList,2,$L(bindTemplateIDList))}	
	q bindTemplateIDList
}

/// add by zhuj on 2009-12-15
ClassMethod GetTemplateIDByDocID(TemplateDocID As %String) As %String
{
  	s category = ##class(EPRmeta.EPRTemplate).%OpenId(TemplateDocID)
	s bindTemplateID = category.BindTemplateID
	d category.%Close()
	s category = ""	
	q bindTemplateID
}

Storage Default
{
<Data name="EPRTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BindTemplateCategoryid</Value>
</Value>
<Value name="3">
<Value>BindTemplateid</Value>
</Value>
<Value name="4">
<Value>NecessaryTemplate</Value>
</Value>
<Value name="5">
<Value>NodeName</Value>
</Value>
<Value name="6">
<Value>NodeSeq</Value>
</Value>
<Value name="7">
<Value>PrintNodeid</Value>
</Value>
<Value name="8">
<Value>EPRCategoryid</Value>
</Value>
<Value name="9">
<Value>EPRTemplateName</Value>
</Value>
<Value name="10">
<Value>EPRTemplateSeq</Value>
</Value>
<Value name="11">
<Value>BindTemplateCategoryID</Value>
</Value>
<Value name="12">
<Value>BindTemplateID</Value>
</Value>
<Value name="13">
<Value>EPRCategoryID</Value>
</Value>
<Value name="14">
<Value>PrivRuleDR</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.EPRTemplateD</DataLocation>
<DefaultData>EPRTemplateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.EPRTemplateD</IdLocation>
<IndexLocation>^DHCEPRM.EPRTemplateI</IndexLocation>
<StreamLocation>^DHCEPRM.EPRTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
