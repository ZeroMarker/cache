/// 住院患者床头卡信息
Class web.DHCNurBedCard Extends %RegisteredObject
{

/// 将病人信息传递到xml
/// Test: ##class(web.DHCNurBedCard).transPatInfo(315)
ClassMethod transPatInfo(episodeID)
{
	s patInfo=""
	s pat=##class(Nur.CommonInterface.Patient).getPatient(episodeID)
	if $IsObject(pat) 
  	{  
	    s key=""   
	    s typeData=pat.%ClassName()
	    if typeData="%ArrayOfDataTypes" 
	    {
	      s key=""
	      s i=0
	      F {
		      	s i=i+1
		        s pData=pat.GetNext(.key)
		        q:key=""
		        s val=pat.GetAt(key)
		        s info=key_"@"_val
		        i patInfo'="" s patInfo=patInfo_"^"_info
		        e  s patInfo=info
	      } 
	    }
	}
	q patInfo
}

}
