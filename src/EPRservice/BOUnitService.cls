/// EPRservice.BOUnitService
Class EPRservice.BOUnitService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://10.10.141.189/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "UnitService";

ClassMethod CreateUnit(AEUnit As EPRservice.entity.EUnit) As %String [ WebMethod ]
{
 set objUnit = ##class(EPRmeta.Unit).%New()
 Set objUnit.CHSMeasurementName = AEUnit.CHSMeasurementName
 Set objUnit.Code = AEUnit.Code
 Set objUnit.Coefficient = AEUnit.Coefficient
 Set objUnit.Conversion = AEUnit.Conversion
 // standard 1  ,  expand    0
 if (AEUnit.DefaultUnit ="1")
 {
 S CheckResult= ##class(EPRmeta.Unit).CheckUniqueUnit(AEUnit.Code)
 if CheckResult=1
 {
	Quit -1	
 }
 }
 Set objUnit.DefaultUnit = AEUnit.DefaultUnit

 Set objUnit.ENGMeasurementName = AEUnit.ENGMeasurementName
 Set objUnit.Symbol = AEUnit.Symbol


 if '(objUnit.%Save())
 {
	Quit "0" }

 quit objUnit.%Id()
}

ClassMethod CreateUnitType(AEUnitType As EPRservice.entity.EUnitType) As %String [ WebMethod ]
{
 set objUnitType = ##class(EPRmeta.UnitType).%New()
 Set objUnitType.CHSName = AEUnitType.CHSName
 Set CheckCodeUnique = ##class(EPRmeta.UnitType).CheckTypeCodeUnique(AEUnitType.Code)
 if (CheckCodeUnique=1)
 {
	Quit "-1" } 
 Set objUnitType.Code = AEUnitType.Code
 Set objUnitType.ENGName = AEUnitType.ENGName
 if '(objUnitType.%Save())
 {
	Quit "0" }

 quit objUnitType.%Id()
}

ClassMethod DeleteUnit(AID As %String) As %Boolean [ WebMethod ]
{
 set objUnit = ##class(EPRmeta.Unit).%OpenId(AID)
 Quit objUnit.%DeleteId(AID)
}

ClassMethod DeleteUnitType(AID As %String) As %Boolean [ WebMethod ]
{
 set objUnitType = ##class(EPRmeta.UnitType).%OpenId(AID)
 Quit objUnitType.%DeleteId(AID)
}

/// TODO: add arguments and implementation.
/// Test
ClassMethod GetAllUnitType() As EPRservice.dataset.EUnitTypeDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EUnitTypeDataset).%New()
 // Do result.SetArgs(ATemplateId)
 Quit result
}

ClassMethod GetUnits() As EPRservice.dataset.EUnitDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EUnitDataset).%New()
 //Do result.SetArgs()
 Quit result
}

ClassMethod GetUnitsByCode(ACode As %String) As EPRservice.dataset.EUnitByCodeDataset [ WebMethod ]
{
 Set result=##class(EPRservice.dataset.EUnitByCodeDataset).%New()
 Do result.SetArgs(ACode)
 Quit result
}

ClassMethod UpdateUnit(AEUnit As EPRservice.entity.EUnit) As %String [ WebMethod ]
{
 set objUnit = ##class(EPRmeta.Unit).%OpenId(AEUnit.ID)
 Set objUnit.CHSMeasurementName = AEUnit.CHSMeasurementName
 Set objUnit.Code = AEUnit.Code
 Set objUnit.Coefficient = AEUnit.Coefficient
 Set objUnit.Conversion = AEUnit.Conversion

 s TempDefaultUnit = objUnit.DefaultUnit 
 if '(TempDefaultUnit = AEUnit.DefaultUnit)
 {
 if (AEUnit.DefaultUnit ="1")
 {
 S CheckResult= ##class(EPRmeta.Unit).CheckUniqueUnit(AEUnit.Code)
 if CheckResult=1
 {
	 Quit "-1"	
 }
 }
 }
 Set objUnit.DefaultUnit = AEUnit.DefaultUnit

 Set objUnit.ENGMeasurementName = AEUnit.ENGMeasurementName
 Set objUnit.Symbol = AEUnit.Symbol


 if '(objUnit.%Save())
 {
	Quit "0" }
 Quit "1"
}

ClassMethod UpdateUnitType(AEUnitType As EPRservice.entity.EUnitType) As %String [ WebMethod ]
{
 set objUnitType = ##class(EPRmeta.UnitType).%OpenId(AEUnitType.ID)
 Set objUnitType.CHSName = AEUnitType.CHSName
 set TempCode = objUnitType.Code
 if (TempCode '= AEUnitType.Code)
 {
	 
 Set CheckCodeUnique = ##class(EPRmeta.UnitType).CheckTypeCodeUnique(AEUnitType.Code)
 if CheckCodeUnique=1
 {
	Quit "-1" }
}
 Set objUnitType.Code = AEUnitType.Code
 if (TempCode '= AEUnitType.Code)
 {
 do ##class(EPRmeta.Unit).UpdateCode(TempCode,AEUnitType.Code)	
	 }


 Set objUnitType.ENGName = AEUnitType.ENGName
 if '(objUnitType.%Save())
 {
	Quit "0" }
 Quit "1"
}

}
