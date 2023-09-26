Class EPRmeta.TemplatePriv.TemplatesInGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Relationship TemplateGroup As EPRmeta.TemplatePriv.TemplateGroup [ Cardinality = parent, Inverse = Templates ];

Property Template As %String(TRUNCATE = 1);

//EPRmeta.Template;

//Index PrivTempIdGroupId On (Template, TemplateGroup);

Query SelectAll(parGroupId As %String) As %Query(ROWSPEC = "ID:%String,childsub:%String,TemplateGroup:%String,Template:%String,TemplateDesc:%String,CategoryDesc:%String")
{
}

ClassMethod SelectAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectAllExecute ]
{
    s qHandle="" 
	Quit $$$OK
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, parGroupId As %String) As %Status
{
	S result = ##class(%Library.ResultSet).%New()
    S sql = "SELECT t.ID as ID,t.childsub as childsub,t.TemplateGroup as TemplateGroupId,t.Template as TemplateId,t.Template->Name as TemplateName,c.Name as CategoryName"_
		" FROM EPRmeta_TemplatePriv.TemplatesInGroup t, EPRmeta.TemplateCategory c"_
		" where TemplateGroup->ID = ? and t.Template->TemplateCategoryID = c.ID"
		
    d result.Prepare(sql)
    d result.Execute(parGroupId)
    
    s qHandle=result
    Quit $$$OK
}

ClassMethod SelectAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectAllExecute ]
{
	s IsEnd = 'qHandle.Next()
	if (IsEnd '= 1)
	{
        s ID = qHandle.Data("ID")
		s childsub = qHandle.Data("childsub")
		s TemplateGroupId = qHandle.Data("TemplateGroupId")
		s TemplateId = qHandle.Data("TemplateId")
		s TemplateName = qHandle.Data("TemplateName")
		s CategoryName = qHandle.Data("CategoryName")
		
		s RowList = $lb(ID,childsub,TemplateGroupId,TemplateId,TemplateName,CategoryName)
		
		s Row=RowList
		
	}
	elseif (IsEnd = 1)
	{
		d qHandle.Close()
		s qHandle = ""
		s Row = ""
		s AtEnd=1
	}
	
	Quit $$$OK
}

/// delete records by templateId
ClassMethod DeleteByTemplateId(parTemplateId As %String) As %Status
{
	k SQLCODE
	&sql(delete from EPRmeta_TemplatePriv.TemplatesInGroup
			 where Template=:parTemplateId)
	q:((SQLCODE=0)||(SQLCODE=100)||(SQLCODE=-106)) 1
	q 0
}

Storage Default
{
<Data name="TemplatesInGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupID</Value>
</Value>
<Value name="3">
<Value>TemplateID</Value>
</Value>
<Value name="4">
<Value>Template</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.Priv.TempsInGroupD</DataLocation>
<DefaultData>TemplatesInGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.Priv.TempsInGroupD</IdLocation>
<IndexLocation>^DHCEPRM.Priv.TempsInGroupI</IndexLocation>
<StreamLocation>^DHCEPRM.Priv.TempsInGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
