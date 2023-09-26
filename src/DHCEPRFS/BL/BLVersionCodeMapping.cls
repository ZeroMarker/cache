Class DHCEPRFS.BL.BLVersionCodeMapping Extends %RegisteredObject [ ProcedureBlock ]
{

ClassMethod GetVersionBySchemeType(ASchemeType As %String) As %String
{
	q:(ASchemeType="")||(ASchemeType=$c(0)) "0"
	
	q:(ASchemeType="CREATEPRIVACY01") "1"
	q:(ASchemeType="CREATEPRIVACY02") "2"
	
	q "0"
	
	/*
	s Version = "0"
	if (AVersionCode '= "")
	{
		s Version = $o(^DHCEPRFS.META.VersionCodeI("IdxVersion"," "_AVersionCode,""))
		s Version = $TR(Version," ","")
	}
	*/
}

ClassMethod GetVersionByTypeCode(AVersionTypeCode As %String) As %String
{
	q:(AVersionTypeCode="")||(AVersionTypeCode=$c(0)) "0"
	
	s Version = $o(^DHCEPRFS.META.VersionCodeI("IdxVersionCode"," "_AVersionTypeCode,""))
	s Version = $TR(Version," ","")
	q Version
}

ClassMethod GetVersionByCode(AVersionCode As %String) As %String
{
	q:((AVersionCode="")||(AVersionCode=$c(0))) "0"
	
	q:(AVersionCode="CREATEPRIVACY01") "1"
	q:(AVersionCode="CREATEPRIVACY02") "2"
	
	q "0"
}

}
