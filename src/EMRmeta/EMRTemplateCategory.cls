/// 名称:EMRmeta.EMRTemplate
/// 描述:病历展现结构-模板目录表
/// 编写者：Guozongtao
/// 编写日期: 2014-01-03
Class EMRmeta.EMRTemplateCategory Extends %Persistent
{

Index IdxParentCategoryID On ParentCategoryID;

Index IdxParentCateogryIDAndSeq On (ParentCategoryID, CategorySeq);

Index IdxInternalID On InternalID;

/// 节点名称
Property CategoryName As %String(MAXLEN = 200, TRUNCATE = 1);

/// 节点类型 Category:目录 	CategoryChapter:章（挂靠打印模板的目录）  TempCate:挂靠界面模板的目录
Property CategoryType As %String(TRUNCATE = 1);

/// 父节点的ID
Property ParentCategoryID As %String(TRUNCATE = 1);

/// 互斥标示
Property IsMutex As %String(TRUNCATE = 1);

/// 引导框标示
Property IsLeadframe As %String(TRUNCATE = 1);

/// 待签，0或空：显示待签，1：不显示待签.
Property IsWaitsign As %String(TRUNCATE = 1);

/// 小图标路径
Property ImageUrl As %String(TRUNCATE = 1);

/// 在同级节点中的显示次序
Property CategorySeq As %Integer;

/// 内部表示符
Property InternalID As %String(MAXLEN = 5000, TRUNCATE = 1);

/// 模板描述简拼
Property JaneSpell As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板描述全拼
Property FullFight As %String(MAXLEN = 200, TRUNCATE = 1);

/// 起始日期(docID初次添加到模板组时间)
Property StartDate As %Date;

/// 起始时间(docID初次添加到模板组时间)
Property StartTime As %Time;

/// 废止时间(docID从模板组全部移除时间)
Property EndDate As %Date;

/// 废止时间(docID从模板组全部移除时间)
Property EndSaveTime As %Time;

Query SelectAll() As %SQLQuery(CONTAINID = 0, ROWSPEC = "ID:%String,CategoryName:%String,CategoryType:%String,ParentCategoryID:%String,CategorySeq:%Integer,IsMutex:%String,IsLeadframe:%String,IsWaitsign:%String,ImageUrl:%String,InternalID:%String")
{
SELECT ID,CategoryName,CategoryType,ParentCategoryID,CategorySeq,IsMutex,IsLeadframe,IsWaitsign,ImageUrl,InternalID
FROM EMRmeta.EMRTemplateCategory
ORDER BY ID
}

Storage Default
{
<Data name="EMRTemplateCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryName</Value>
</Value>
<Value name="3">
<Value>CategoryType</Value>
</Value>
<Value name="4">
<Value>ParentCategoryID</Value>
</Value>
<Value name="5">
<Value>CategorySeq</Value>
</Value>
<Value name="6">
<Value>IsMutex</Value>
</Value>
<Value name="7">
<Value>IsLeadframe</Value>
</Value>
<Value name="8">
<Value>ImageUrl</Value>
</Value>
<Value name="9">
<Value>InternalID</Value>
</Value>
<Value name="10">
<Value>JaneSpell</Value>
</Value>
<Value name="11">
<Value>FullFight</Value>
</Value>
<Value name="12">
<Value>IsWaitsign</Value>
</Value>
<Value name="13">
<Value>StartDate</Value>
</Value>
<Value name="14">
<Value>StartTime</Value>
</Value>
<Value name="15">
<Value>EndDate</Value>
</Value>
<Value name="16">
<Value>EndSaveTime</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRTemplateCategoryD</DataLocation>
<DefaultData>EMRTemplateCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.EMRTemplateCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.EMRTemplateCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRTemplateCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
