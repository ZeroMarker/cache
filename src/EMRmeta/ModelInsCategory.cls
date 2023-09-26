/// 范例病历的目录表
Class EMRmeta.ModelInsCategory Extends %Persistent
{

/// d ##class(EMRmeta.ModelInsCategory).%BuildIndices()
Index IdxUsrParentSeq On (CreateUser, ParentID, Sequence);

Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

Property ParentID As %String(TRUNCATE = 1);

Property ResChildCount As %Integer;

Property Sequence As %Integer;

Property CreateUser As %String(TRUNCATE = 1);

/// First Letter of Pinyin
Property FPinyin As %String;

/// d ##class(EMRmeta.ModelInsCategory).AddSequence()
ClassMethod AddSequence()
{
	s id=""
	for{
		s id = $O(^DHCEMRM.ModelInsCategoryD(id))
		q:(id="")
		s obj = ##Class(EMRmeta.ModelInsCategory).%OpenId(id)
		s obj.FPinyin=##class(web.DHCINSUPort).GetCNCODE($tr(obj.Name," ",""),4,"")
		s obj.Sequence=obj.%Id()
		s obj.ModelInsCategoryID=0
		d obj.%Save()
	}
}

Storage Default
{
<Data name="ModelInsCategoryDefaultData">
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
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>CreateUser</Value>
</Value>
<Value name="8">
<Value>FPinyin</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.ModelInsCategoryD</DataLocation>
<DefaultData>ModelInsCategoryDefaultData</DefaultData>
<IdLocation>^DHCEMRM.ModelInsCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.ModelInsCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.ModelInsCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
