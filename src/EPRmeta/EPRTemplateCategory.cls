/// 名称: 电子病历树形展现结构表
/// 描述: 用于保存构造展现树形的节点信息（只保存结构及打印模板）
/// 编写者：chenwenjun
/// 编写日期: 09/04/21
Class EPRmeta.EPRTemplateCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 节点名称
Property CategoryName As %String(TRUNCATE = 1);

/// 节点类型 Category:目录 	CategoryChapter:章（挂靠打印模板的目录）	PrtTemplate:打印模板  TempCate:挂靠界面模板的目录
Property CategoryType As %String(TRUNCATE = 1);

/// 父节点的ID
Property ParentCategoryID As %String(TRUNCATE = 1);

/// 在同级节点中的显示次序
Property CategorySeq As %Integer;

/// 绑定的打印模板ID(如果节点类型是结构，该项为空)
Property BindPrnTemplateID As %String(TRUNCATE = 1);

/// 绑定的打印模板的CategoryID(如果节点类型是结构，该项为空)
Property BindPrnTemplateCategoryID As %String(TRUNCATE = 1);

Index IdxParentCategoryID On ParentCategoryID;

Index IdxParentCateogryIDAndSeq On (ParentCategoryID, CategorySeq);

Query SelectAll() As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,CategoryName:%String,CategoryType:%String,ParentCategoryID:%String,CategorySeq:%Integer,BindPrnTemplateID:%String,BindPrnTemplateCategoryID:%String")
{
SELECT ID,CategoryName,CategoryType,ParentCategoryID,CategorySeq,BindPrnTemplateID,BindPrnTemplateCategoryID
FROM EPRmeta.EPRTemplateCategory
ORDER BY ID
}

/// CreateTime: 2009-08-14
/// CreateUser: houj
/// Desc: 根据父节点类型获取其下所有PrtTemplate类型的节点
/// Input: 	parentCategoryId: Category类型父节点Id
/// 			parentCategoryChapterId：CategoryChapter类型父节点Id
/// Return：PrtTemplate类型的节点rowid序列，rowid1^rowid2^rowid3
ClassMethod GetSubPrtTemplateCategory(parentCategoryId As %String, parentCategoryChapterId As %String) As %String
{
	q:(($d(parentCategoryId)=0)||($d(parentCategoryChapterId)=0)) ""
	q:((parentCategoryId="")&&(parentCategoryChapterId="")) ""
	
	s retValue = ""
	s parentIDs = ""
	
	//取CategoryChapter类型节点Id
	if (parentCategoryChapterId '= "")
	{	s parentIDs = parentCategoryChapterId}
	else
	{	
		s rowid = ""
		
		&sql( declare myCursor cursor for
		select ID into :rowid from EPRmeta.EPRTemplateCategory 
		where  ParentCategoryID = :parentCategoryId and CategoryType = 'CategoryChapter')
	
		&sql(open myCursor)
		for {
			&sql(fetch myCursor)
			q:SQLCODE
			
			if parentIDs = ""
			{	s parentIDs = rowid}
			else
			{	s parentIDs = parentIDs_"^"_rowid}
		}
		
		&sql(close myCursor)
	}
	
	q:(parentIDs="") ""
	
	for i=1:1:$L(parentIDs,"^")
	{
		s parentID = $P(parentIDs,"^",i)
		s rowid = ""
		&sql( declare myCursor2 cursor for
			select ID into :rowid from EPRmeta.EPRTemplateCategory 
			where  ParentCategoryID = :parentID and CategoryType = 'PrtTemplate')
		
		&sql(open myCursor2)
		for {
			&sql(fetch myCursor2)
			q:SQLCODE
			
			if retValue = ""
			{	s retValue = rowid}
			else
			{	s retValue = retValue_"^"_rowid}
		}
		
		&sql(close myCursor2)
	}
	
	q retValue
}

/// CreateTime: 2009-09-21
/// CreateUser: gaojb
/// Desc: 根据节点ID取父节点ID
/// Input: parDocID：节点Id
/// Return：父节点ID，如果没有父节点或者参数错误等返回空串
ClassMethod GetParentIDByDocID(parDocID As %String) As %String
{
	q:(($d(parDocID)=0)||(parDocID="")) ""
	
	s instance=""
	s instance=##class(EPRmeta.EPRTemplateCategory).%OpenId(parDocID)
	q:(instance="") ""
	
	s result=instance.ParentCategoryID
	d instance.%Close()
	s instance=""
	
	///如果是最上一层节点，会返回0，这里也转为空串处理
	q:(result=0) ""	
	q result
}

Storage Default
{
<Data name="EPRTemplateCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BindPrintTemplateCategoryid</Value>
</Value>
<Value name="3">
<Value>BindPrintTemplateid</Value>
</Value>
<Value name="4">
<Value>NodeName</Value>
</Value>
<Value name="5">
<Value>NodeSeq</Value>
</Value>
<Value name="6">
<Value>NodeType</Value>
</Value>
<Value name="7">
<Value>ParentNodeid</Value>
</Value>
<Value name="8">
<Value>CategoryName</Value>
</Value>
<Value name="9">
<Value>CategorySeq</Value>
</Value>
<Value name="10">
<Value>CategoryType</Value>
</Value>
<Value name="11">
<Value>ParentCategoryid</Value>
</Value>
<Value name="12">
<Value>BindPrnTemplateCategoryId</Value>
</Value>
<Value name="13">
<Value>BindPrnTemplateId</Value>
</Value>
<Value name="14">
<Value>ParentCategoryId</Value>
</Value>
<Value name="15">
<Value>BindPrnTemplateCategoryID</Value>
</Value>
<Value name="16">
<Value>BindPrnTemplateID</Value>
</Value>
<Value name="17">
<Value>ParentCategoryID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.EPRTemplateCategoryD</DataLocation>
<DefaultData>EPRTemplateCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.EPRTemplateCategoryD</IdLocation>
<IndexLocation>^DHCEPRM.EPRTemplateCategoryI</IndexLocation>
<StreamLocation>^DHCEPRM.EPRTemplateCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
