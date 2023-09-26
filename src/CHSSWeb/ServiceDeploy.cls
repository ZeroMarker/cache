Class CHSSWeb.ServiceDeploy Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

ClassMethod ServiceDeploy() As %String
{
	q ""
	q ""
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.CTSexService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.CommonDictService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.CommunityService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictAddressTypeService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictAnusService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictCardiacRhythmTypeService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictCheckResultService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictChestService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictChronicSymptomService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictCityService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictCommunityTypeService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictDentitionService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictDistrictService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictDyspneaService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictGLUService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictHospitalService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictKETService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictKideyPainService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictLowerExtremityEdemaService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictLymphNodesService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictMotorFunctionService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictOralLipsService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictPROService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictPersonalEventTypeService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictPoliceService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictProstate")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictProvinceService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictSectionService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictSkinService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictStreetService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictUHbService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictUserService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictVillageService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DictWheezingRaleService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.DrugDictService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.FHRService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.FamilyEarthquakeInfoService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.FamilySearchService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.FamilyService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.HISInfoService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PHRSearchService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PHRService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PYCAService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PYCRService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PYCSService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PersonEarthquakeInfoService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PersonHBVCheckHomeService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PersonHBVCheckRecordService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PersonHealthDiagnoseService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PersonLongTermDrugService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PersonLongTermProblemService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PersonTBCheckRecordService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PersonTBCheckService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PersonYearCheckHBVService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.PubModelListService")
	;w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.ServiceProviderInfoService")
	w ##class(%SYSTEM.OBJ).MakeClassDeployed("CHSSWeb.SystemIdService")
	q ""
}

Storage Default
{
<Data name="ServiceDeployDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.ServiceDeployD</DataLocation>
<DefaultData>ServiceDeployDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.ServiceDeployD</IdLocation>
<IndexLocation>^CHSSWeb.ServiceDeployI</IndexLocation>
<StreamLocation>^CHSSWeb.ServiceDeployS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
