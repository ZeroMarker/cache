/// 名称: DHCMed.EPDService.ILIUpadateService
/// 描述: 流感样病例报卡信息保存服务
/// 编写者：yk
/// 编写日期: 2016-03-13
Class DHCMed.EPDService.ILIUpadateService Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     yk
/// CreatDate：   2016-03-16
/// Description:  保存报卡信息
/// Table：       DHCMed.EPD.ERReportILI
/// Input：       RepInfo:报卡信息
/// Return：      返回String
/// w ##class(DHCMed.EPDService.ILIUpadateService).SaveRepData("23^265^185^ILI^1^0000000185^李聪(考试)^女^24^11374^13112341112^^372^595^612^615^21^2131^11364^231^11368^2131^2016-03-14^2016-03-21^117^med manager^北京地坛医院^12312")
ClassMethod SaveRepData(RepInfo As %String) As %String
{
	New (RepInfo)
	Set return="0^数据不全"
    Quit:(RepInfo="") return
    
    Set return="-1^报卡信息保存错误"	
	Set InputStr=$p(RepInfo,"^",1)				      //ERReportID
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",2)	      //EREpisodeID
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",3)	      //ERPatID
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",5)       //ERReportStatus
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",6)	      //ERRegNo
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",7)	      //ERPatName
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",8)	      //ERPatSex
	Set InputStr=InputStr_"^"_""	                  //ERBirthday
	Set (AgeS,AgeY,AgeT)=""                           
	Set Age=$p(RepInfo,"^",9)
	Set AgeDW=$P(RepInfo,"^",10)
	//Set:(+AgeDW)'=0 AgeDW=##class(DHCMed.SS.Dictionary).GetObjById(AgeDW).Description
	If (AgeDW="岁"){
		Set AgeS=Age
		Set AgeY=""
		Set AgeT=""
	} ElseIf (AgeDW="月"){
		Set AgeY=Age
		Set AgeS=""
		Set AgeT=""
	} Else {
		Set AgeT=Age
		Set AgeY=""
		Set AgeS=""
		}
	Set InputStr=InputStr_"^"_AgeS                  //ERAge        
	Set InputStr=InputStr_"^"_AgeY                  //ERAgeMonth
	Set InputStr=InputStr_"^"_AgeT                  //ERAgeDay
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",18)	//ERCurrAddress
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",13)	//ERCurrProvince
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",14)	//ERCurrCity
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",15)	//ERCurrCounty
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",16)	//ERCurrTown
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",17)	//ERCurrVillage
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",11)	//ERTelephone
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",12)	//ERParent
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",26)	//ERDoctorName    20
	Set InputStr=InputStr_"^"_""	                //ERDoctorNo
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",23)	//ERSickDate
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",24)	//ERAdmitDate
	Set CurTime=$H
	Set InputStr=InputStr_"^"_$p(CurTime,",",1)	    //ERReportDate
	Set InputStr=InputStr_"^"_$p(CurTime,",",2)	    //ERReportTime
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",19)	//ERSpecimenType
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",20)	//ERSpecimenClnArea
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",21)	//ERSpecimenSource
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",22)    //ERIncident
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",25)	//ERAdmLoc             30
	Set InputStr=InputStr_"^"_$p(RepInfo,"^",27)    //ERHospital
	Set InputStr=InputStr_"^"_""	                //ERCheckUser
	Set InputStr=InputStr_"^"_""	                //ERCheckDate
	Set InputStr=InputStr_"^"_""                 	//ERCheckTime          34
	Set InputStr=InputStr_"^"_""                 	//ERCheckFlag
	Set InputStr=InputStr_"^"_""                 	//ERExportFlag
	Set InputStr=InputStr_"^"_""                 	//ERExportUser
	Set InputStr=InputStr_"^"_""                 	//ERExportDate
	Set InputStr=InputStr_"^"_""                    //ERExportTime
	Set InputStr=InputStr_"^"_""	                //ERText1
	Set InputStr=InputStr_"^"_""	                //ERText2
	Set InputStr=InputStr_"^"_""	                //ERText3
	Set InputStr=InputStr_"^"_""    //ERReportNum
 	Set ret=##class(DHCMed.EPD.ERReportILI).Update(InputStr,"^")
	Quit:ret<1 return
	
	
	Set return="-2.4^日志信息保存错误"
	Set RepID=ret
	Set InputStrLOG=RepID
	Set InputStrLOG=InputStrLOG_"^"_$p(RepInfo,"^",5)
	Set InputStrLOG=InputStrLOG_"^"_$p(RepInfo,"^",25)
	Set InputStrLOG=InputStrLOG_"^"_$p(RepInfo,"^",26)
	Set InputStrLOG=InputStrLOG_"^"_+$H
	Set InputStrLOG=InputStrLOG_"^"_$p($H,",",2)
	Set InputStrLOG=InputStrLOG_"^"_"UPDATE"
	Set retlog=##class(DHCMed.EPD.ILIReportLOG).Update(InputStrLOG,"^")
	Quit:retlog<1 return
	
	Set return=ret    	//RepID
	Quit return
}

}
