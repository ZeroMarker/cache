/// 名称:DHCMed.NINFService.CSS.ClinRepPrt
/// 描述:横断面临床报告打印
/// 编写者：zhufei
/// 编写日期: 2014-06-16
Class DHCMed.NINFService.CSS.ClinRepPrt Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 打印北京2014横断面报告
/// w ##Class(DHCMed.NINFService.CSS.ClinRepPrt).PrintCSSReport2014BJ("fillxlSheet",5)
ClassMethod PrintCSSReport2014BJ(itmjs As %String, aReportID As %String) As %String
{
	new (itmjs,aReportID)
	set return=0
	quit:aReportID="" return
	
	set objReport=##class(DHCMed.NINF.CSS.ClinReport).GetObjById(aReportID)
	quit:'$IsObject(objReport) return
	set EpisodeID=objReport.CREpisodeID
	quit:EpisodeID="" return
	set AdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
	quit:AdmLoc="" return
	set CTHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
	quit:CTHospID="" return
	set SSHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCode(CTHospID,"NINF")
	quit:SSHospCode="" return
	
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRLoc,"O","JS")_"',"_3_",3);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRBed,"O","JS")_"',"_3_",12);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRMRNo,"O","JS")_"',"_3_",18);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRAdmDate,"O","JS")_"',"_3_",26);"
	&javascript<#(retval)#>
	
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRName,"O","JS")_"',"_4_",3);"
	&javascript<#(retval)#>
	set Sex=..GetDicList("NINFCSSSex",objReport.CRSex)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_4_",12);"
	&javascript<#(retval)#>
	set Age=objReport.CRAgeY_"岁"_objReport.CRAgeM_"月"_objReport.CRAgeD_"天"
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_4_",20);"
	&javascript<#(retval)#>
	
	set Diagnos=objReport.CRDiagnos
	set Diagnos1=$p(Diagnos,"#",1)
	set Diagnos2=$p(Diagnos,"#",2)
	set Diagnos3=$p(Diagnos,"#",3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Diagnos1,"O","JS")_"',"_6_",3);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Diagnos2,"O","JS")_"',"_7_",3);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Diagnos3,"O","JS")_"',"_8_",3);"
	&javascript<#(retval)#>
	
	set AddOns4=..GetDicList("NINFCSSBoolean",objReport.CRAddOns4)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AddOns4,"O","JS")_"',"_9_",13);"
	&javascript<#(retval)#>
	
	set IsInfection=..GetDicList("NINFCSSBoolean",objReport.CRIsInfection)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(IsInfection,"O","JS")_"',"_11_",5);"
	&javascript<#(retval)#>
	
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRInfPos1,"O","JS")_"',"_13_",2);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRInfDate1,"O","JS")_"',"_13_",8);"
	&javascript<#(retval)#>
	set Pathogen1=objReport.CRPathogen1
	set PathogenA=$p(Pathogen1,"#",1)
	set PathogenB=$p(Pathogen1,"#",2)
	set PathogenC=$p(Pathogen1,"#",3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenA,"O","JS")_"',"_13_",13);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenB,"O","JS")_"',"_13_",19);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenC,"O","JS")_"',"_13_",25);"
	&javascript<#(retval)#>
	
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRInfPos2,"O","JS")_"',"_14_",2);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRInfDate2,"O","JS")_"',"_14_",8);"
	&javascript<#(retval)#>
	set Pathogen2=objReport.CRPathogen2
	set PathogenA=$p(Pathogen2,"#",1)
	set PathogenB=$p(Pathogen2,"#",2)
	set PathogenC=$p(Pathogen2,"#",3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenA,"O","JS")_"',"_14_",13);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenB,"O","JS")_"',"_14_",19);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenC,"O","JS")_"',"_14_",25);"
	&javascript<#(retval)#>
	
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRInfPos3,"O","JS")_"',"_15_",2);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRInfDate3,"O","JS")_"',"_15_",8);"
	&javascript<#(retval)#>
	set Pathogen3=objReport.CRPathogen3
	set PathogenA=$p(Pathogen3,"#",1)
	set PathogenB=$p(Pathogen3,"#",2)
	set PathogenC=$p(Pathogen3,"#",3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenA,"O","JS")_"',"_15_",13);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenB,"O","JS")_"',"_15_",19);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenC,"O","JS")_"',"_15_",25);"
	&javascript<#(retval)#>
	
	set Anti1=..GetDicList("NINFCSSBoolean",objReport.CRAnti1)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Anti1,"O","JS")_"',"_17_",7);"
	&javascript<#(retval)#>
	set Anti2=..GetDicList("NINFCSSMedObj",objReport.CRAnti2)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Anti2,"O","JS")_"',"_18_",4);"
	&javascript<#(retval)#>
	set Anti3=..GetDicList("NINFCSSDrugCom",objReport.CRAnti3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Anti3,"O","JS")_"',"_19_",4);"
	&javascript<#(retval)#>
	set Anti4=..GetDicList("NINFCSSBoolean",objReport.CRAnti4)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Anti4,"O","JS")_"',"_20_",11);"
	&javascript<#(retval)#>
	
	set Oper1=..GetDicList("NINFCSSBoolean",objReport.CROper1)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Oper1,"O","JS")_"',"_22_",4);"
	&javascript<#(retval)#>
	set Oper2=..GetDicList("NINFCSSBoolean",objReport.CROper2)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Oper2,"O","JS")_"',"_23_",8);"
	&javascript<#(retval)#>
	set Oper3=..GetDicList("NINFCSSOperCut",objReport.CROper3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Oper3,"O","JS")_"',"_24_",7);"
	&javascript<#(retval)#>
	set Oper4=..GetDicList("NINFCSSBoolean",objReport.CROper4)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Oper4,"O","JS")_"',"_25_",11);"
	&javascript<#(retval)#>
	
	set AddOns1=..GetDicList("NINFCSSBoolean",objReport.CRAddOns1)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AddOns1,"O","JS")_"',"_27_",6);"
	&javascript<#(retval)#>
	set AddOns2=..GetDicList("NINFCSSBoolean",objReport.CRAddOns2)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AddOns2,"O","JS")_"',"_28_",6);"
	&javascript<#(retval)#>
	set AddOns3=..GetDicList("NINFCSSBoolean",objReport.CRAddOns3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AddOns3,"O","JS")_"',"_29_",6);"
	&javascript<#(retval)#>
	
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRSurvUser,"O","JS")_"',"_31_",4);"
	&javascript<#(retval)#>
	set SurvDate=objReport.CRSurvDate
	set SurvDate=$zd(SurvDate,3)
	set SurvDate=$p(SurvDate,"-",1)_"年"_$p(SurvDate,"-",2)_"月"_$p(SurvDate,"-",3)_"日"
	set retval=itmjs_"(xlSheet,'"_$ZCVT(SurvDate,"O","JS")_"',"_31_",14);"
	&javascript<#(retval)#>
	
	set return=1
	quit return
}

/// 打印全国2014横断面报告
/// w ##Class(DHCMed.NINFService.CSS.ClinRepPrt).PrintCSSReport2014("fillxlSheet",3)
ClassMethod PrintCSSReport2014(itmjs As %String, aReportID As %String) As %String
{
	new (itmjs,aReportID)
	set return=0
	quit:aReportID="" return
	
	set objReport=##class(DHCMed.NINF.CSS.ClinReport).GetObjById(aReportID)
	quit:'$IsObject(objReport) return
	set EpisodeID=objReport.CREpisodeID
	quit:EpisodeID="" return
	set AdmLoc=$p($g(^PAADM(EpisodeID)),"^",4)
	quit:AdmLoc="" return
	set CTHospID=##class(DHCMed.SSService.HospitalSrv).GetCTHospID(AdmLoc)
	quit:CTHospID="" return
	set SSHospCode=##class(DHCMed.SSService.HospitalSrv).GetSSHospCode(CTHospID,"NINF")
	quit:SSHospCode="" return
	
	set Row=3
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRPatNo,"O","JS")_"',"_Row_",4);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRLoc,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRBed,"O","JS")_"',"_Row_",21);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRMRNo,"O","JS")_"',"_Row_",27);"
	&javascript<#(retval)#>
	
	set Row=4
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRName,"O","JS")_"',"_Row_",4);"
	&javascript<#(retval)#>
	set Sex=..GetDicList("NINFCSSSex",objReport.CRSex)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Sex,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set Age=objReport.CRAgeY_"岁"_objReport.CRAgeM_"月"_objReport.CRAgeD_"天"
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Age,"O","JS")_"',"_Row_",21);"
	&javascript<#(retval)#>
	
	set Row=5
	set Diagnos=objReport.CRDiagnos
	set Diagnos1=$p(Diagnos,"#",1)
	set Diagnos2=$p(Diagnos,"#",2)
	set Diagnos3=$p(Diagnos,"#",3)
	set Diagnos=""
	set:Diagnos1'="" Diagnos=Diagnos_"、"_Diagnos1
	set:Diagnos2'="" Diagnos=Diagnos_"、"_Diagnos2
	set:Diagnos3'="" Diagnos=Diagnos_"、"_Diagnos3
	set:Diagnos'="" Diagnos=$e(Diagnos,2,$l(Diagnos))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Diagnos,"O","JS")_"',"_Row_",4);"
	&javascript<#(retval)#>
	
	set Row=6
	set Oper1=..GetDicList("NINFCSSBoolean",objReport.CROper1)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Oper1,"O","JS")_"',"_Row_",4);"
	&javascript<#(retval)#>
	set Oper3=..GetDicList("NINFCSSOperCut",objReport.CROper3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Oper3,"O","JS")_"',"_Row_",14);"
	&javascript<#(retval)#>
	
	set Row=8
	set IsInfection=..GetDicList("NINFCSSBoolean1",objReport.CRIsInfection)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(IsInfection,"O","JS")_"',"_Row_",5);"
	&javascript<#(retval)#>
	set IsInfection=..GetDicList("NINFCSSInfCategory",objReport.CRInfCategory)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(IsInfection,"O","JS")_"',"_Row_",19);"
	&javascript<#(retval)#>
	
	set Row=10
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRInfPos1,"O","JS")_"',"_Row_",2);"
	&javascript<#(retval)#>
	set Pathogen=objReport.CRPathogen1
	set PathogenA=$p(Pathogen,"#",1)
	set PathogenB=$p(Pathogen,"#",2)
	set PathogenC=$p(Pathogen,"#",3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenA,"O","JS")_"',"_Row_",10);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenB,"O","JS")_"',"_Row_",17);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenC,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set Row=11
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRInfPos2,"O","JS")_"',"_Row_",2);"
	&javascript<#(retval)#>
	set Pathogen=objReport.CRPathogen2
	set PathogenA=$p(Pathogen,"#",1)
	set PathogenB=$p(Pathogen,"#",2)
	set PathogenC=$p(Pathogen,"#",3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenA,"O","JS")_"',"_Row_",10);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenB,"O","JS")_"',"_Row_",17);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenC,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set Row=12
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRInfPos3,"O","JS")_"',"_Row_",2);"
	&javascript<#(retval)#>
	set Pathogen=objReport.CRPathogen3
	set PathogenA=$p(Pathogen,"#",1)
	set PathogenB=$p(Pathogen,"#",2)
	set PathogenC=$p(Pathogen,"#",3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenA,"O","JS")_"',"_Row_",10);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenB,"O","JS")_"',"_Row_",17);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenC,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set Row=13
	set AddOns5=..GetDicList("NINFCSSBoolean1",objReport.CRAddOns5)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AddOns5,"O","JS")_"',"_Row_",6);"
	&javascript<#(retval)#>
	
	set Row=15
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRComInfPos1,"O","JS")_"',"_Row_",2);"
	&javascript<#(retval)#>
	set Pathogen=objReport.CRComPathogen1
	set PathogenA=$p(Pathogen,"#",1)
	set PathogenB=$p(Pathogen,"#",2)
	set PathogenC=$p(Pathogen,"#",3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenA,"O","JS")_"',"_Row_",10);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenB,"O","JS")_"',"_Row_",17);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenC,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set Row=16
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRComInfPos2,"O","JS")_"',"_Row_",2);"
	&javascript<#(retval)#>
	set Pathogen=objReport.CRComPathogen2
	set PathogenA=$p(Pathogen,"#",1)
	set PathogenB=$p(Pathogen,"#",2)
	set PathogenC=$p(Pathogen,"#",3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenA,"O","JS")_"',"_Row_",10);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenB,"O","JS")_"',"_Row_",17);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenC,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set Row=17
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRComInfPos3,"O","JS")_"',"_Row_",2);"
	&javascript<#(retval)#>
	set Pathogen=objReport.CRComPathogen3
	set PathogenA=$p(Pathogen,"#",1)
	set PathogenB=$p(Pathogen,"#",2)
	set PathogenC=$p(Pathogen,"#",3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenA,"O","JS")_"',"_Row_",10);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenB,"O","JS")_"',"_Row_",17);"
	&javascript<#(retval)#>
	set retval=itmjs_"(xlSheet,'"_$ZCVT(PathogenC,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set BugsAntiSen=objReport.CRBugsAntiSen
	
	set tmpBugs=$p(BugsAntiSen,"#",1)
	set Row=19
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",2),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",3),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set tmpBugs=$p(BugsAntiSen,"#",2)
	set Row=20
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",2),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",3),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set tmpBugs=$p(BugsAntiSen,"#",3)
	set Row=21
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",2),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",3),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set tmpBugs=$p(BugsAntiSen,"#",4)
	set Row=22
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",2),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",3),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set tmpBugs=$p(BugsAntiSen,"#",5)
	set Row=23
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",2),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",3),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set tmpBugs=$p(BugsAntiSen,"#",6)
	set Row=24
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",2),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",3),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	set Row=25
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",4),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	
	set tmpBugs=$p(BugsAntiSen,"#",7)
	set Row=26
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",2),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",3),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	set Row=27
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",4),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	
	set tmpBugs=$p(BugsAntiSen,"#",8)
	set Row=28,Col=0
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",2),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",3),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	set Row=29
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",4),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",5),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	set Row=30
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",6),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",7),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set tmpBugs=$p(BugsAntiSen,"#",9)
	set Row=31
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",2),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set AntiSen=..GetDicList("NINFCSSAntiSen",$p($p(tmpBugs,"||",3),":",2))
	set retval=itmjs_"(xlSheet,'"_$ZCVT(AntiSen,"O","JS")_"',"_Row_",24);"
	&javascript<#(retval)#>
	
	set Row=33
	set Anti1=..GetDicList("NINFCSSBoolean",objReport.CRAnti1)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Anti1,"O","JS")_"',"_Row_",8);"
	&javascript<#(retval)#>
	set Row=34
	set Anti2=..GetDicList("NINFCSSMedObj",objReport.CRAnti2)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Anti2,"O","JS")_"',"_Row_",8);"
	&javascript<#(retval)#>
	set Row=35
	set Anti3=..GetDicList("NINFCSSDrugCom",objReport.CRAnti3)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Anti3,"O","JS")_"',"_Row_",8);"
	&javascript<#(retval)#>
	set Row=36
	set Anti4=..GetDicList("NINFCSSBoolean",objReport.CRAnti4)
	set retval=itmjs_"(xlSheet,'"_$ZCVT(Anti4,"O","JS")_"',"_Row_",8);"
	&javascript<#(retval)#>
	
	set Row=37
	set retval=itmjs_"(xlSheet,'"_$ZCVT(objReport.CRSurvUser,"O","JS")_"',"_Row_",12);"
	&javascript<#(retval)#>
	set SurvDate=objReport.CRSurvDate
	set SurvDate=$zd(SurvDate,3)
	set SurvDate=$p(SurvDate,"-",1)_"年"_$p(SurvDate,"-",2)_"月"_$p(SurvDate,"-",3)_"日"
	set retval=itmjs_"(xlSheet,'"_$ZCVT(SurvDate,"O","JS")_"',"_Row_",22);"
	&javascript<#(retval)#>
	
	set return=1
	quit return
}

/// w ##Class(DHCMed.NINFService.CSS.ClinReport).GetDicList("NINFCSSSex","男")
ClassMethod GetDicList(aDicType As %String, aDicDesc As %String)
{
	New (aDicType,aDicDesc)
	Set return=""
	Quit:aDicType="" return
	
	Set xID=0,Number=0,IsHave=0
 	For {
	 	Set xID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_$zcvt(aDicType,"U"),xID))
	 	Quit:xID=""
	 	
	 	Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(xID)
	 	Continue:'$IsObject(objDic)
	 	
		Set IsActive=objDic.Active
		Continue:IsActive'=1
	 	Set Code=objDic.Code
		Set Description=objDic.Description
		Set Type=objDic.Type
		Continue:aDicType'=Type
		
		Set Number=Number+1
		Set:Number>1 return=return_"  "
		
		If aDicDesc=Description {
			Set return=return_"√"_Description
			Set IsHave=1
		} Else {
			Set return=return_"□"_Description
		}
	}
	If (IsHave=0)&&(aDicDesc'="") {
		Set return=return_"√"_aDicDesc
	}
	Quit return
}

}
