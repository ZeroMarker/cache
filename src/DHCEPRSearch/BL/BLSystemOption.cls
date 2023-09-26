Class DHCEPRSearch.BL.BLSystemOption Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SetData(AName As %String, AValue As %String, ADesc As %String, AIsVisible As %String) As %String
{
	s result = ""
	q:(AName = "") result
	s Id = $o(^DHCEPRSearch.META.SystemOptionI("IndexName"," "_$ZCVT(AName,"U"),""))
	if (Id = "")
	{
		s obj = ##Class(DHCEPRSearch.META.SystemOption).%New()
	}else
	{
        s obj = ##Class(DHCEPRSearch.META.SystemOption).%OpenId(Id)
	}

	s obj.Description = ADesc
	s obj.Name = AName
	s obj.OptionValue = AValue
	s obj.IsVisible = AIsVisible
	s sc = obj.%Save()
	s:($$$ISOK(sc)) result = obj.%Id()
	q result
}

ClassMethod GetValueByName(ASysName As %String) As %String
{
	q:(ASysName="") ""
	
	s Id = $o(^DHCEPRSearch.META.SystemOptionI("IndexName"," "_$ZCVT(ASysName,"U"),""))
	q:(Id="") ""
	
	s obj = ##Class(DHCEPRSearch.META.SystemOption).%OpenId(Id)
	q:(obj = "") ""
	
	q obj.OptionValue
}

ClassMethod UpdateValueByName(AName As %String, ANewValue As %String) As %String
{
	q:(AName="") ""

	s rowID = $o(^DHCEPRSearch.META.SystemOptionI("IndexName"," "_$ZCVT(AName,"U"),""))
	q:(rowID="") 
	s obj = ##Class(DHCEPRSearch.META.SystemOption).%OpenId(rowID)
	q:(obj="")
	s obj.OptionValue = ANewValue
	s status = obj.%Save()
	q:($$$ISOK(status)) "1"

	q "-1"
}

}
