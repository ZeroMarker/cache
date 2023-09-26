Import SQLUser

Class web.DHCBL.OPINVREP.SuAvailbHospital Extends (%RegisteredObject, %XML.Adaptor, web.DHCBL.BLAbstract) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

/// /Single Class Storage Abstract
Parameter EntityClassName = "web.DHCEntity.OPINVREP.DHCSuAvailbHospital";

Parameter PersistentClassName = "User.DHCSuAvailbHospital";

ClassMethod DTOTransObj(DTObj As %ObjectHandle) As %ObjectHandle
{
	i DTObj.SAHRowID="" {
		s myPObj=##class(User.DHCSuAvailbHospital).%New()
	}else{
		s myPObj=##class(User.DHCSuAvailbHospital).%OpenId(DTObj.SAHRowID)
	}
	
	s myPObj.SAHCode=DTObj.SAHCode
	s myPObj.SAHDesc=DTObj.SAHDesc
	s myPObj.SAHActiveFlag=DTObj.SAHActiveFlag
	s myPObj.SAHDefaultFlag=DTObj.SAHDefaultFlag
	if DTObj.SAHHospitalDR'="" {
		d myPObj.SAHHospitalDRSetObjectId(DTObj.SAHHospitalDR)
	}
	
	q myPObj
}

ClassMethod DHCAuditSaveDataToServer(XmlData As %String) As %String
{
	s ^TMPXmlData=XmlData
	s myrtn=0
	
	;s myobj=##class().%New()
	i $System.OBJ.IsValidClassname(..#EntityClassName){
		Set myDataObj = $System.OBJ.New(..#EntityClassName)
		d myDataObj.XMLDeserialize(.myDataObj, XmlData)
		
		s myPObj=..DTOTransObj(myDataObj)
		if ('$IsObject(myPObj)){
			s myrtn=-102
			b	;;no Object
		}
		if (+myrtn=0){
			s sc=myPObj.%Save()
			If $System.Status.IsError(sc) {
				s myErr=sc
				s myrtn=-102
				b	;;Error
			}
		}
		
		if ((+myrtn=0)&&(myPObj.SAHDefaultFlag="Y")){
			
		}
		
		d myDataObj.%Close()
	}
	
	q myrtn
}

Query SelectAll() As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,SAH_Code,SAH_Desc,SAH_ActiveFlag,SAH_DefaultFlag,SAH_Hospital_DR->%ID,SAH_Hospital_DR->HOSP_Desc FROM DHC_SuAvailbHospital
}

Query SelectSubAvailHospitalByCode(Code As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT SAH_Desc, %ID, SAH_Code
FROM DHC_SuAvailbHospital
where SAH_Desc %STARTSWITH :Code or SAH_Code %STARTSWITH :Code
}

}
