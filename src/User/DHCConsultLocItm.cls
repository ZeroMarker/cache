Class User.DHCConsultLocItm Extends %Persistent
{

Relationship RecParref As User.DHCConsultLoc [ Cardinality = parent, Inverse = ChildRec ];

Property Ctloc As User.CTLoc;

Index Ctloc On Ctloc;

Index GetChildloc On (RecParref, Ctloc);

/// condepid:会诊大科室id  locid:子科室id
ClassMethod Save(locid As %String, condepid As %String, rw As %String) As %String
{
	 q:((locid="")!(condepid=""))&(rw'="") "大科室或子科室为空"
	 s id=$o(^User.DHCConsultLocItmI("Ctloc",locid,""))
	 q:(id'="")&(rw="") "该科室已在大科中"
     TS
     if rw=""  s obj=##class(User.DHCConsultLocItm).%New()
     else  s obj=##class(User.DHCConsultLocItm).%OpenId(rw)
     s obj.Ctloc=##class(CTLoc).%OpenId(locid)
    
     s obj.RecParref=##class(User.DHCConsultLoc).%OpenId(condepid)
     s sc=obj.%Save()
     b ;1
     if $$$ISERR(sc) {
	  //Do $System.Status.DisplayError(sc)
      TRO
      q "error"
     }
     //d obj.%Save()
     Tc
     q 0
     ///q obj.%Id()
}

/// 删除表的内容
ClassMethod Delete(id As %String) As %String
{
 q:id="" ""
 TS
 s obj=##class(User.DHCConsultLocItm).%DeleteId(id)
  if $$$ISERR(obj) {
	  //Do $System.Status.DisplayError(obj)
	  TRO
      q "error"
  }
  Tc
  q 0
}

Storage Default
{
<Data name="DHCConsultLocItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Ctloc</Value>
</Value>
</Data>
<DataLocation>^User.DHCConsultLocItmD</DataLocation>
<DefaultData>DHCConsultLocItmDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildRec")</IdLocation>
<IndexLocation>^User.DHCConsultLocItmI</IndexLocation>
<StreamLocation>^User.DHCConsultLocItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
