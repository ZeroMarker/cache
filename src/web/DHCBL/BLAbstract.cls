Class web.DHCBL.BLAbstract [ Abstract, ClassType = "", ProcedureBlock ]
{

/// /Single Class Storage Abstract
Parameter EntityClassName;

Parameter PersistentClassName;

Parameter ParentPersistentClassName;

ClassMethod DHCAuditDelete(RowID As %String) As %String
{
	s myrtn=0
	
	i $System.OBJ.IsValidClassname(..#PersistentClassName){
		s myobj=%SYSTEM.OBJ.Open(..#PersistentClassName, RowID)
		d myobj.%Delete()
		
	}
	
	q myrtn
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
		d myDataObj.%Close()
	}
	
	q myrtn
}

ClassMethod DHCAuditSaveChildServer(ParRowID As %String, XmlData As %String) As %String
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
		d myDataObj.%Close()
	}
	
	q myrtn
}

ClassMethod DTOTransObj(DTObj As %ObjectHandle) As %ObjectHandle
{
	q 0
}

ClassMethod DHCAuditInsert() As %String
{
}

ClassMethod DHCAuditUpdate(RowID As %String, ELObj As %ObjectHandle) As %String
{
}

}
