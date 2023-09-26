Class DHCMed.EPDService.ILIPrintService Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     YK
/// CreatDate：   2016-03-27
/// Description:  打印流感样标本登记表
/// Table：       DHCMed.EPD.ERReportILI
/// Input：       
/// Return：      
/// w ##class(DHCMed.EPDService.ILIPrintService).ExportERRepILI("fillxlSheet","1")
ClassMethod ExportERRepILI(itmjs As %String, strArguments As %String) As %String
{
	New (itmjs,strArguments)
	Set Count=0
	
	Set RepID=+$p(strArguments,"^",1)
	Set objRep=##class(DHCMed.EPD.ERReportILI).GetObjById(RepID)
	Quit:'$IsObject(objRep) Count
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERReportNum,"O","JS")_"',3,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERRegNo,"O","JS")_"',3,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERPatName,"O","JS")_"',6,4);"
	&javascript<#(retval)#>
	
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERPatSex,"O","JS")_"',6,10);"
	&javascript<#(retval)#>
	Set PatAge=""
	If (objRep.ERAge'="") {
		Set PatAge=objRep.ERAge_"岁"
	} ElseIf (objRep.ERAgeMonth'="") {
		Set PatAge=objRep.ERAgeMonth_"月"
	} ElseIf (objRep.ERAgeDay'="") {
		Set PatAge=objRep.ERAgeDay_"天"
	}
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(PatAge,"O","JS")_"',6,14);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERTelephone,"O","JS")_"',6,21);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERParent,"O","JS")_"',8,4);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERCurrProvince.ShortDesc,"O","JS")_"',10,7);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERCurrCity.ShortDesc,"O","JS")_"',10,11);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERCurrCounty.ShortDesc,"O","JS")_"',10,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERCurrTown.ShortDesc,"O","JS")_"',10,19);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERCurrVillage,"O","JS")_"',10,24);"
	&javascript<#(retval)#> 
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERCurrAddress,"O","JS")_"',12,6);"    
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERSpecimenType.Description,"O","JS")_"',16,5);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERSpecimenClnArea,"O","JS")_"',16,23);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERSpecimenSource.Description,"O","JS")_"',18,5);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERIncident,"O","JS")_"',18,23);"
	&javascript<#(retval)#>
	
	Set SickDate=objRep.ERSickDate
	Set:SickDate'="" SickDate=$zd(SickDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(SickDate,"O","JS")_"',20,5);"
	&javascript<#(retval)#>
	Set AdmitDate=objRep.ERAdmitDate
	Set:AdmitDate'="" AdmitDate=$zd(AdmitDate,3)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(AdmitDate,"O","JS")_"',20,15);"
	&javascript<#(retval)#>
	
	Set AdmLocID=objRep.ERAdmLoc
	set DescStr=$p($g(^CTLOC(+AdmLocID)),"^",2)
	set:$p(DescStr,"-",2)'="" DescStr=$p(DescStr,"-",2)
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(DescStr,"O","JS")_"',22,5);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERDoctorName,"O","JS")_"',22,15);"
	&javascript<#(retval)#>
	Set retval=itmjs_"(xlSheet,'"_$ZCVT(objRep.ERHospital,"O","JS")_"',22,23);"
	&javascript<#(retval)#>
	
	q Count
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
/// 	w ##Class(DHCMed.CDService.PrintService).GetServerInfo()
ClassMethod GetServerInfo()
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    //Set Server=Config.WebServer
    Set Server=$p(Config.LayoutManager,":",2)
    Set Path=Config.PathToReports
    Set LayOutManager=Config.LayoutManager
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
   // Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q s
}

}
