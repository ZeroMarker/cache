/// 名称:EMRmeta.EMRTemplate
/// 描述:病历展现结构-模板表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRmeta.EMRTemplate Extends (%Persistent, User.Abstract)
{

Index IdxCategoryID On CategoryID;

Index IdxPrivRuleDR On PrivRuleDR;

Index IdxBindTemplateID On BindTemplateID;

Index IdxTemplateSeq On (CategoryID, TemplateSeq);

Index IdxBindTemplateCategoryID On (BindTemplateCategoryID, CategoryID);

Index IdxCategoryTemplate On (CategoryID, BindTemplateID);

Index IdxInternalID On (InternalID, CategoryID);

/// 界面Category名称（注：显示的不是界面模板名称）
Property TemplateName As %String(MAXLEN = 200, TRUNCATE = 1);

/// EMRmeta.EMRTemplateCategory节点的DocID
Property CategoryID As %String(TRUNCATE = 1);

/// 在同级节点的显示次序
Property TemplateSeq As %Integer;

/// 绑定的界面模板ID
Property BindTemplateID As %String(TRUNCATE = 1);

/// 绑定的界面模板的CategoryID
Property BindTemplateCategoryID As %String(TRUNCATE = 1);

/// 是否是对应EMRCategoryID下的必填项(0--否 1--是)
Property NecessaryTemplate As %String(TRUNCATE = 1);

/// 加载界面模板对应规则定义.(EMRmeta.Privilege.PrivRule.Name)
Property PrivRuleDR As %String(TRUNCATE = 1);

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

Query SelectAll() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%String,TemplateName:%String,CategoryID:%String,TemplateSeq:%Integer,BindTemplateID:%String,BindTemplateCategoryID:%String,NecessaryTemplate:%String,InternalID:%String")
{
	SELECT ID,TemplateName,CategoryID,TemplateSeq,BindTemplateID,BindTemplateCategoryID,NecessaryTemplate,InternalID
	FROM EMRmeta.EMRTemplate
	ORDER BY TemplateSeq
}

ClassMethod GetBindTempIDByEMRCategory(argEMRCategoryID) As %String
{
	q:(argEMRCategoryID="") ""
	
	s allBindTemplateIDList = ""
	
	s count = $L(argEMRCategoryID,"^")
	for i=1:1:count
	{
		s categoryID = $P(argEMRCategoryID,"^",i)
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
		s id = $O(^DHCEMRM.EMRTemplateI("IdxEMRCategoryID", " "_categoryID, id))
		q:(id="")
		s obj = ##class(EMRmeta.EMRTemplate).%OpenId(id)
		s:(obj'="") bindTemplateIDList = bindTemplateIDList_"^"_obj.BindTemplateID	
	}
	if bindTemplateIDList'=""
	{	s bindTemplateIDList = $E(bindTemplateIDList,2,$L(bindTemplateIDList))}	
	q bindTemplateIDList
}

/// add by zhuj on 2009-12-15
ClassMethod GetTemplateIDByDocID(TemplateDocID As %String) As %String
{
  	s category = ##class(EMRmeta.EMRTemplate).%OpenId(TemplateDocID)
	s bindTemplateID = category.BindTemplateID
	d category.%Close()
	s category = ""	
	q bindTemplateID
}

Storage Default
{
<Data name="EMRTemplateDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateName</Value>
</Value>
<Value name="3">
<Value>CategoryID</Value>
</Value>
<Value name="4">
<Value>TemplateSeq</Value>
</Value>
<Value name="5">
<Value>BindTemplateID</Value>
</Value>
<Value name="6">
<Value>BindTemplateCategoryID</Value>
</Value>
<Value name="7">
<Value>NecessaryTemplate</Value>
</Value>
<Value name="8">
<Value>PrivRuleDR</Value>
</Value>
<Value name="9">
<Value>EMRTemplateName</Value>
</Value>
<Value name="10">
<Value>EMRCategoryID</Value>
</Value>
<Value name="11">
<Value>EMRTemplateSeq</Value>
</Value>
<Value name="12">
<Value>InternalID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRTemplateD</DataLocation>
<DefaultData>EMRTemplateDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.EMRTemplateD</IdLocation>
<IndexLocation>^DHCEMRM.EMRTemplateI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRTemplateS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
