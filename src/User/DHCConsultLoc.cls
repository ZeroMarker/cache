Class User.DHCConsultLoc Extends %Persistent
{

Relationship ChildRec As User.DHCConsultLocItm [ Cardinality = children, Inverse = RecParref ];

Property ConsultDep As %String(TRUNCATE = 1);

Property CTLOCHospitalDR As CTHospital;

Property ItmMastDR As User.ARCItmMast;

Property ConsultDepCode As %String(TRUNCATE = 1);

Index ConsultDep On ConsultDep;

Index CTLOCHospitalDR On CTLOCHospitalDR;

Index ItmMastDR On ItmMastDR;

Index ConsultDepCode On ConsultDepCode;

ClassMethod Save(Hospitalid As %String, condep As %String, Itmmastdr As %String, rw As %String, condepcode As %String = "")
{
   q:((Hospitalid="")!(condep="")!(Itmmastdr="")!(condepcode=""))&(rw="") "院区或科室或编码或医嘱项为空" //
   //q ""
   s id=$O(^User.DHCConsultLocI("ConsultDep"," "_$zu(28,condep,5),""))
   b ;1
   q:(rw="")&(id'="") "该科室已添加"
   ///s condepcode=$zu(28,condepcode,6)  ///
   s condepcode=$replace(condepcode," ","") //
 TS
   if rw="" s obj=##class(User.DHCConsultLoc).%New()
   e  s obj=##class(User.DHCConsultLoc).%OpenId(rw)
   s obj.ConsultDep=condep
   s obj.CTLOCHospitalDR=##class(CTHospital).%OpenId(Hospitalid)
   s obj.ItmMastDR=##class(User.ARCItmMast).%OpenId(Itmmastdr)  //医嘱项
   s obj.ConsultDepCode=condepcode    ///科室编码
   s sc=obj.%Save()
   If $$$ISERR(sc) {
	  TRO
	  q "error"
   }
   //d obj.%Save()
   TC
   q 0
}

Storage Default
{
<Data name="DHCConsultLocDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ConsultDep</Value>
</Value>
<Value name="3">
<Value>CTLOCHospitalDR</Value>
</Value>
<Value name="4">
<Value>ItmMastDR</Value>
</Value>
<Value name="5">
<Value>ConsultDepCode</Value>
</Value>
</Data>
<DataLocation>^User.DHCConsultLocD</DataLocation>
<DefaultData>DHCConsultLocDefaultData</DefaultData>
<IdLocation>^User.DHCConsultLocD</IdLocation>
<IndexLocation>^User.DHCConsultLocI</IndexLocation>
<StreamLocation>^User.DHCConsultLocS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
