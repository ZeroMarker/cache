/// 名称: web.DHCPE.TransResultTask
/// 描述: 体检结果补传任务
/// 编写者：zhufei
/// 编写日期: 2022-04-19
Class web.DHCPE.TransResultTask Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// w ##class(web.DHCPE.TransResultTask).TransMain($zdh("2022-01-01",3),$zdh("2022-04-20",3))
ClassMethod TransMain(aDateFrom As %String, aDateTo As %String)
{
	do ..TransLISResult(aDateFrom,aDateTo)
	do ..TransRISResult(aDateFrom,aDateTo)
	Quit "OK"
}

/// 写任务补本院体检不收表、总检，要求回传结果的需求（检验）
/// w ##class(web.DHCPE.TransResultTask).TransLISResult($zdh("2022-03-01",3),$zdh("2022-03-01",3))
ClassMethod TransLISResult(aDateFrom As %String, aDateTo As %String)
{
	Set LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	Set RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
	Set RisStationPT="8^13"
	Set RisStation="^"_RisStation_"^"
	Set RisStationPT="^"_RisStationPT_"^"
	Set LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion"))
	Set TransResultFlag="PG" //##class(web.DHCPE.HISUICommon).GetSettingByLoc(%session.Get("LOGON.CTLOCID"),"TransResult")
	//^DHCPESetting("DHCPE","TransResult",1)="PT"     //集成平台接口
	//^DHCPESetting("DHCPE","TransResult",92)="PG"    //产品组接口
	//^DHCPESetting("DHCPE","TransResult",380)="PG"   //产品组接口
	//^DHCPESetting("DHCPE","TransResult",816)="PG"   //产品组接口
	//^DHCPESetting("DHCPE","TransResult",1343)="PG"  //产品组接口
	
	Set userId=1,Count=0
	Set xWorkGroupMachineDR=""
	For {
		Set xWorkGroupMachineDR=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",xWorkGroupMachineDR))
		Quit:xWorkGroupMachineDR=""
		
		Set xDate=$tr($zd(aDateFrom,3),"-","")-1
		For {
			Set xDate=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",xWorkGroupMachineDR,xDate))
			Quit:xDate=""
			Quit:xDate>$tr($zd(aDateTo,3),"-","")
			
			Set xID=0
			For {
				Set xID=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",xWorkGroupMachineDR,xDate,xID))
				Quit:xID=""
				
				Set xTestSetDR=""
				For {
					Set xTestSetDR=$o(^dbo.RPVisitNumberTestSetI("IndexReportID",xID,xTestSetDR))
					Quit:xTestSetDR=""
					
					Set VNTSID=$o(^dbo.RPVisitNumberTestSetI("IndexReportID",xID,xTestSetDR,0))
					Quit:VNTSID=""
					Set OEItemRowID=$lg($g(^dbo.RPVisitNumberTestSetD(VNTSID)),10)
					Continue:OEItemRowID=""
				    Set Paadm=$p($g(^OEORD(+OEItemRowID)),"^",1)
				    Continue:Paadm=""
				    Set AdmType=$p($g(^PAADM(Paadm)),"^",2)
				    Continue:AdmType'="H"  //体检就诊
				    
				    Set ordItmId=OEItemRowID  //医嘱ID
				    Set admId=Paadm           //就诊号
				    Set CurData=$G(^OEORD(+ordItmId,"I",+$p(ordItmId,"||",2),1))
					Continue:CurData=""
					Set ItemMastId=$p(CurData,"^",2)
					Set StationId=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,0))
					Continue:StationId=""
					Set RLTRowid=$o(^DHCPERLT(0,"OEORI",OEItemRowID,0))  //需要核实一下
					Continue:RLTRowid'=""  //如果有结果，表示结果回传过了
					
					w xDate_" OEItemRowID="_OEItemRowID_",admId="_admId,!
				    Set Count=Count+1
				    
				    Set ret=##class(web.DHCPE.TransResult).TransALabItemNew(admId,userId,ordItmId)
				}
			}
		}
	}
	Quit "OK:"_Count
}

/// 写任务补本院体检不收表、总检，要求回传结果的需求（检查）
/// w ##class(web.DHCPE.TransResultTask).TransRISResult($zdh("2022-03-01",3),$zdh("2022-03-01",3))
ClassMethod TransRISResult(aDateFrom As %String, aDateTo As %String)
{
	Set LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	Set RisStation=$g(^DHCPESetting("DHCPE","StationId_Ris"))
	Set RisStationPT="8^13"
	Set RisStation="^"_RisStation_"^"
	Set RisStationPT="^"_RisStationPT_"^"
	Set LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion"))
	Set TransResultFlag=""  //##class(web.DHCPE.HISUICommon).GetSettingByLoc(%session.Get("LOGON.CTLOCID"),"TransResult")
	//^DHCPESetting("DHCPE","TransResult",1)="PT"     //集成平台接口
	//^DHCPESetting("DHCPE","TransResult",92)="PG"    //产品组接口
	//^DHCPESetting("DHCPE","TransResult",380)="PG"   //产品组接口
	//^DHCPESetting("DHCPE","TransResult",816)="PG"   //产品组接口
	//^DHCPESetting("DHCPE","TransResult",1343)="PG"  //产品组接口
	
	Set userId=1,Count=0
	Set xDate=aDateFrom-1
	For {
		Set xDate=$o(^Busi.ENS.EnsRISReportResultI("RISRUpdateTimeIndex",xDate))
		Quit:xDate=""
		Quit:xDate>aDateTo
		
		Set xTime=0
		For {
			Set xTime=$o(^Busi.ENS.EnsRISReportResultI("RISRUpdateTimeIndex",xDate,xTime))
			Quit:xTime=""
			
			Set xID=0
			For {
				Set xID=$o(^Busi.ENS.EnsRISReportResultI("RISRUpdateTimeIndex",xDate,xTime,xID))
				Quit:xID=""
				
				Set OEItemRowID=$lg($g(^Busi.ENS.EnsRISReportResultD(xID)),4)
				Continue:OEItemRowID=""
			    Set Paadm=$p($g(^OEORD(+OEItemRowID)),"^",1)
			    Continue:Paadm=""
			    Set AdmType=$p($g(^PAADM(Paadm)),"^",2)
			    Continue:AdmType'="H"  //体检就诊
			    
			    Set IsStatus=0
				Set EnsStatusRowid=""
				For {
					Set EnsStatusRowid=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemID"," "_OEItemRowID,EnsStatusRowid))
					Quit:EnsStatusRowid=""
				    
				    Set StudyNo=$lg($g(^Busi.ENS.EnsStatusD(EnsStatusRowid)),3)
				    Continue:StudyNo=""
				    Set Status=$lg($g(^Busi.ENS.EnsStatusD(EnsStatusRowid)),9)
				    Continue:(Status'="RP")&&(Status'="RD")
				    Set IsStatus=1
				}
				Continue:IsStatus<1
				
			    Set ordItmId=OEItemRowID  //医嘱ID
			    Set admId=Paadm           //就诊号
			    Set CurData=$G(^OEORD(+ordItmId,"I",+$p(ordItmId,"||",2),1))
				Continue:CurData=""
				Set ItemMastId=$p(CurData,"^",2)
				Set StationId=$o(^DHCPEST(0,"STORD_ARCIM",ItemMastId,0))
				Continue:StationId=""
				Set RLTRowid=$o(^DHCPERLT(0,"OEORI",OEItemRowID,0))  //需要核实一下
				Continue:RLTRowid'=""  //如果有结果，表示结果回传过了
				
				w $zd(xDate,3)_" OEItemRowID="_OEItemRowID_",admId="_admId,!
			    Set Count=Count+1
			    
			    Set ret=##class(web.DHCPE.TransResult).TransARisItemByPT(admId,ordItmId,userId)
			}
		}
	}
	Quit "OK:"_Count
}

}
