Class EMRmeta.EMRDocRestriction.DocsInGroup Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//规则ID

Property GroupID As %String(TRUNCATE = 1);

//病历结构ID

Property DocID As %String(TRUNCATE = 1);

Index DocIDIdx On (DocID, GroupID) [ Unique ];

//若病历展现结构维护报错，请尝试修改  CONTAINID = 0 或  CONTAINID = 1

Query SelectAll(parGroupID As %String) As %Query(CONTAINID = 0, ROWSPEC = "ID:%String,GroupID:%String,DocID:%String,DocName:%String,ParentName:%String")
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary, parGroupID As %String) As %Status
{
	s result = ##class(%ResultSet).%New("EMRmeta.EMRDocRestriction.DocsInGroup:SelectAllDocsInGroup")
	//s sql = "SELECT ID,GroupID,DocID FROM EMRmeta_EMRDocRestriction.DocsInGroup WHERE GroupID=?"
	//d result.Prepare(sql)
	d result.Execute(parGroupID)

	Set qHandle = result
	Quit $$$OK
}

ClassMethod SelectAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectAllExecute ]
{
	d qHandle.Close()
	s qHandle=""
	Quit $$$OK
}

ClassMethod SelectAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectAllExecute ]
{
	set rowID = "", groupID = "", docID = ""

 	If (qHandle.Next()) {
	 	s rowID = qHandle.Data("ID")
	 	s groupID = qHandle.Data("GroupID")
	 	s docID = qHandle.Data("DocID")

	 	s objCurDoc = ##class(EMRmeta.EMRTemplateCategory).%OpenId(docID)
	 	if (objCurDoc = ""){Set Row=$lb(rowID, groupID, docID, "未知", "未知")}
	 	else
	 	{
			s docName = objCurDoc.CategoryName
			s docParentID = objCurDoc.ParentCategoryID
			d objCurDoc.%Close()
			k objCurDoc
			
			s objParentDoc = ""
			s docParentName = ""
			if (docParentID '= ""){s objParentDoc = ##class(EMRmeta.EMRTemplateCategory).%OpenId(docParentID)}
 			if (objParentDoc '= ""){s docParentName = objParentDoc.CategoryName}
 			
 			Set Row=$lb(rowID, groupID, docID, docName, docParentName)
		}
 	}
 	Else {
 		Set AtEnd=1
 		Set Row=""
 	}
	
	Quit $$$OK
}

Query SelectAllDocsInGroup(parGroupID As %String) As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,GroupID:%String,DocID:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_SelectAllDocsInGroup, SqlProc ]
{
	SELECT ID,GroupID,DocID FROM EMRmeta_EMRDocRestriction.DocsInGroup WHERE GroupID=:parGroupID
}

Storage Default
{
<Data name="DocsInGroupDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupID</Value>
</Value>
<Value name="3">
<Value>DocID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.DocRes.DocsInGroupD</DataLocation>
<DefaultData>DocsInGroupDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.DocRes.DocsInGroupD</IdLocation>
<IndexLocation>^DHCEMRM.DocRes.DocsInGroupI</IndexLocation>
<StreamLocation>^DHCEMRM.DocRes.DocsInGroupS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
