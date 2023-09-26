/// 术语范畴
Class EPRmeta.GlossaryCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 术语范畴名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术语范畴描述	
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 术语范畴父类ID
Property ParentID As %String(TRUNCATE = 1);

/// 该术语范畴下的术语数目
Property ResChildCount As %Integer;

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

/// 所属界面模板
Property TemplateCategroyID As %String(TRUNCATE = 1);

Index IdxOnInternalID On InternalID [ Unique ];

/// Desc:	获取第一线术语集合
/// Debug:	d ##Class(%ResultSet).RunQuery("EPRmeta.GlossaryCategory","SelectAll")
Query SelectAll() As %Query(ROWSPEC = "ID:%Integer, Name:%String, Description:%String, ParentID:%String, ResChildCount:%Integer, InternalID:%String,TemplateCategroyID:%String")
{
}

ClassMethod SelectAllExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $i(^CacheTemp)
	s ind = 1
	s qHandle = $lb(0,repid,0)

	
	s rowID = ""
	for {
		s rowID = $o(^DHCEPRM.GlossaryCategoryD(rowID))
		q:(rowID = "")	
	
		s objGlossaryCat = ##Class(EPRmeta.GlossaryCategory).%OpenId(rowID)
		q:(objGlossaryCat="")
		s name = objGlossaryCat.Name
		s desc = objGlossaryCat.Description
		s ParentID = objGlossaryCat.ParentID
		s ResChildCount = objGlossaryCat.ResChildCount
		s internalID = objGlossaryCat.InternalID
		s TemplateCategroyID = ""
				
		s sub = ""
		for {
			s sub = $o(^DHCEPRM.GlossarysTemplateIDI("IdxInternalID"," "_internalID,sub))
			q:(sub = "")
			s objGlossaryTem =##Class(EPRmeta.GlossarysTemplateID).%OpenId(sub)
			q:(objGlossaryTem ="")
			if (TemplateCategroyID="")
			{
				s TemplateCategroyID =objGlossaryTem.TemplateID 
			}
			else
			{
				s TemplateCategroyID = TemplateCategroyID_"^"_objGlossaryTem.TemplateID 
			}
		}
		
		s Data = $lb(rowID,name,desc,ParentID,ResChildCount,internalID,TemplateCategroyID)
		s ^CacheTemp(repid,ind) = Data
		s ind = ind + 1
	}
		
	q $$$OK
}

ClassMethod SelectAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectAllExecute ]
{
	s AtEnd=$list(qHandle,1)
 	s repid=$list(qHandle,2)
 	s ind=$list(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {	
 		s AtEnd=1
 		s Row=""
 		k ^CacheTemp(repid)
 	} else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod SelectAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectAllExecute ]
{
	s repid=$list(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Storage Default
{
<Data name="GlossaryCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>ParentID</Value>
</Value>
<Value name="5">
<Value>ResChildCount</Value>
</Value>
<Value name="6">
<Value>InternalID</Value>
</Value>
<Value name="7">
<Value>TemplateID</Value>
</Value>
<Value name="8">
<Value>TemplateCategroyID</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.GlossaryCategoryD</DataLocation>
<DefaultData>GlossaryCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.GlossaryCategoryD</IdLocation>
<IndexLocation>^DHCEPRM.GlossaryCategoryI</IndexLocation>
<StreamLocation>^DHCEPRM.GlossaryCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
