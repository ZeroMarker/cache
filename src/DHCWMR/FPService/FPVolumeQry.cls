/// 名称: DHCWMR.FPService.FPVolumeQry
/// 描述: 病案编目列表查询
/// 编写者：zhufei
/// 编写日期: 2014-10-21
Class DHCWMR.FPService.FPVolumeQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-10-21
/// Description:  查询病案编目列表
/// Table：       DHCWMR.SS.Main、DHCWMR.SS.Volume
/// Input：       aFrontPageID : 编目记录ID
/// Return：      ROWSPEC=...
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.FPVolumeQry","QryVolumeList","4","7","F","","2014-07-01","2014-08-01","","","1")
Query QryVolumeList(aHospID As %String, aMrTypeID As %String, aFPType As %String, aMrNo As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String, aQryFlag As %String) As %Query(ROWSPEC = "IndexNo:%String,VolID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,BackDate:%String,StepDesc:%String,StatusDesc:%String,FrontPageID:%String,FPIsFinish:%String,FPBuildDate:%String,FPBuildTime:%String,FPUpdateDate:%String,FPUpdateTime:%String,EncryptLevel:%String,PatLevel:%String,PreStatus:%String") [ SqlProc ]
{
}

ClassMethod QryVolumeListExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aFPType As %String, aMrNo As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String, aQryFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	//Set ^ZF=$lb(aHospID,aMrTypeID,aFPType,aMrNo,aDateFrom,aDateTo,aLocID,aQryFlag)
 	
 	Quit:(aHospID="")||(aMrTypeID="")||(aFPType="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	If aLocID="" {
		Set aLocID=##Class(DHCWMR.SSService.LocGroupSrv).GetLocListByGroup(aLocGrpID)
	}
	Set:aLocID'="" aLocID="|"_aLocID_"|"
	
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	
 	If (aQryFlag=0) {  //病案号查找
 		Set aMrNo=##Class(DHCWMR.SSService.CommonSrv).ChangeMrNo(aMrNo)
 		Quit:aMrNo="" $$$OK
	 	If $l(aMrNo)=13 { //病案条码
			Set Barcode=aMrNo
			Set BarType=$e(Barcode,1,2)
			If BarType="01" {
				Set MainID=$o(^DHCWMR.SS.MainI("IndexTypeBarcodeAct",aMrTypeID," "_Barcode,1,0))
				Quit:MainID="" $$$OK
				Set xVolID=0
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",MainID,xVolID))
					Quit:xVolID=""
					
					Set Data=..BuildVolume(xVolID,aFPType,aMrTypeID,aHospID,aLocID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			} ElseIf BarType="02" {
				Set VolID=$o(^DHCWMR.SS.VolumeI("IndexBarcodeAct"," "_Barcode,1,0))
				Quit:VolID="" $$$OK
				Set Data=..BuildVolume(VolID,aFPType,aMrTypeID,aHospID,aLocID)
				Quit:Data="" $$$OK
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			} Else {
				Quit $$$OK
			}
		} Else { //病案号
			Set MrNo=$zcvt(aMrNo,"U")
			Quit:MrNo="" $$$OK
			
			Set xMainID=0
			For {
				Set xMainID=$o(^DHCWMR.SS.MainI("IndexTypeNoAct",aMrTypeID," "_MrNo,1,xMainID))
				Quit:xMainID=""
				
				Set xVolID=0
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVMainDr",xMainID,xVolID))
					Quit:xVolID=""
					
					Set Data=..BuildVolume(xVolID,aFPType,aMrTypeID,aHospID,aLocID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	} ElseIf (aQryFlag=1) {  //未编目查询
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Set xOrdStep=""
		For {
			Set xOrdStep=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xOrdStep))
			Quit:xOrdStep=""
			Continue:xOrdStep["C" //作废的卷过滤掉
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xOrdStep,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xVolID=0
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xOrdStep,xDate,xVolID))
					Quit:xVolID=""
					
					Set objSSVol=##class(DHCWMR.SS.Volume).GetObjById(xVolID)	//add by niepeng 20150205 过滤掉当前步骤非回收的病案
					Continue:'$IsObject(objSSVol)
					Set SVOrdStep=objSSVol.SVOrdStep
					Continue:(SVOrdStep'="D")&&(SVOrdStep'="S")
					
					//检查病案编目是否完成  
					Set xFpID=$o(^DHCWMR.FP.FrontPageI("IndexVolume",xVolID,aFPType,0))
					If xFpID'="" {
						Set objFP=##class(DHCWMR.FP.FrontPage).GetObjById(xFpID)
						Continue:'$IsObject(objFP)   //把未编目的也过滤了
						Continue:objFP.FPIsFinish=1  //完成退出
					}
					
					Set Data=..BuildVolume(xVolID,aFPType,aMrTypeID,aHospID,aLocID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	} ElseIf (aQryFlag=2) {  //出院查询
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Set xOrdStep=""
		For {
			Set xOrdStep=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xOrdStep))
			Quit:xOrdStep=""
			Continue:xOrdStep["C" //作废的卷过滤掉
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xOrdStep,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xVolID=0
				For {
					Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexDischDate",xOrdStep,xDate,xVolID))
					Quit:xVolID=""
					
					Set Data=..BuildVolume(xVolID,aFPType,aMrTypeID,aHospID,aLocID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	} ElseIf (aQryFlag=3) {  //编目查询
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Set xIsFinish=""
		For {
			Set xIsFinish=$o(^DHCWMR.FP.FrontPageI("IndexBuildDate",xIsFinish))
			Quit:xIsFinish=""
			Continue:xIsFinish=0  // add by pylian 2015-01-21 编目查询只查询编目状态“编目”
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCWMR.FP.FrontPageI("IndexBuildDate",xIsFinish,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime=""
				For {
					Set xTime=$o(^DHCWMR.FP.FrontPageI("IndexBuildDate",xIsFinish,xDate,xTime))
					Quit:xTime=""
					
					Set xFpID=0
					For {
						Set xFpID=$o(^DHCWMR.FP.FrontPageI("IndexBuildDate",xIsFinish,xDate,xTime,xFpID))
						Quit:xFpID=""
						
						Set objFP=##class(DHCWMR.FP.FrontPage).GetObjById(xFpID)
						Continue:'$IsObject(objFP)
						Continue:'$IsObject(objFP.FPVolumeDr)
						Set VolID=objFP.FPVolumeDr.%Id()
						Set Data=..BuildVolume(VolID,aFPType,aMrTypeID,aHospID,aLocID)
						Continue:Data=""
						Set ^CacheTemp(repid,ind)=Data
						Set ind=ind+1
					}
				}
			}
		}
	} ElseIf (aQryFlag=4) {  //当日查询
		Set xIsFinish=""
		For {
			Set xIsFinish=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",xIsFinish))
			Quit:xIsFinish=""
			
			Set xTime=""
			For {
				Set xTime=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",xIsFinish,+$h,xTime),-1)
				Quit:xTime=""
				
				Set xFpID=0
				For {
					Set xFpID=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",xIsFinish,+$h,xTime,xFpID))
					Quit:xFpID=""
					
					Set objFP=##class(DHCWMR.FP.FrontPage).GetObjById(xFpID)
					Continue:'$IsObject(objFP)
					Continue:'$IsObject(objFP.FPVolumeDr)
					Set VolID=objFP.FPVolumeDr.%Id()
					Set Data=..BuildVolume(VolID,aFPType,aMrTypeID,aHospID,aLocID)
					Continue:Data=""
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}
		}
	} Else {}
 	
	Quit $$$OK
}

ClassMethod QryVolumeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVolumeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVolumeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVolumeListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildVolume(aVolID As %String, aFPType As %String, aMrTypeID As %String, aHospID As %String, aLocID As %String) As %List
{
	New (aVolID,aFPType,aMrTypeID,aHospID,aLocID)
	Set return=""
	Quit:(aVolID="")||(aFPType="")||(aMrTypeID="") return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:objVol.SVMainDr.SMIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr.SMMrType) return
	Quit:objVol.SVMainDr.SMMrType.%Id()'=aMrTypeID return
	
	Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(aVolID)
	Quit:EpisodeID="" return
	Set VisitStatus=$p($g(^PAADM(+EpisodeID)),"^",20)
	Quit:VisitStatus="C" return
	Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
	Set AdmWard=$p($g(^PAADM(+EpisodeID)),"^",70)
	Set AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
	If aLocID'="" {
    	Quit:(aLocID'[("|"_AdmLoc_"|"))&&(aLocID'[("|"_AdmWard_"|")) return
    }
	Set AdmHospID=##class(DHCWMR.SSService.HospitalSrv).GetCTHospID(AdmLoc)
	Quit:(aHospID'="")&&(aHospID'[(","_AdmHospID_",")) return
	
	Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
	Quit:PatientID="" return
	Set PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
	Set PatName =$p($g(^PAPER(+PatientID,"ALL")),"^",1)
	Set Sex=$p($g(^PAPER(+PatientID,"ALL")),"^",7)
	Set:Sex'="" Sex=$p($g(^CT("SEX",+Sex)),"^",2)
	Set Birthday=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	
	//update by zf 20150228 统一调用年龄计算方法
	//Set tmpDate=$p($g(^PAADM(+EpisodeID)),"^",6)
	//Set tmpTime=$p($g(^PAADM(+EpisodeID)),"^",7)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
   	Set AdmDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set tmpDate=$p(AdmDateTime,"^",1)
	Set tmpTime=$p(AdmDateTime,"^",2)
	Set Age=##class(DHCWMR.IO.FromHisSrv).GetPapmiAge(PatientID,EpisodeID,tmpDate,tmpTime)	//返回“*岁*月*天”
	
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCWMR.IO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	
    Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
   	Set AdmLocDesc=$p($g(^CTLOC(+AdmLoc)),"^",2)
	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
	Set AdmWard=$p($g(^PAADM(+EpisodeID)),"^",70)
	Set AdmWard=$p($g(^PAWARD(+AdmWard)),"^",5)
	Set AdmWardDesc=$p($g(^CTLOC(+AdmWard)),"^",2)
	Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
	//Set AdmDate=$p($g(^PAADM(+EpisodeID)),"^",6)
	Set AdmDate=tmpDate
	Set:AdmDate'="" AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
	//Set AdmTime=$p($g(^PAADM(+EpisodeID)),"^",7)
	Set AdmTime=tmpTime
	Set:AdmTime'="" AdmTime=$zt(AdmDate,2)
	
	Set OrdStep=objVol.SVOrdStep
	Set MrNo=objVol.SVMainDr.SMMrNo
	Set DischDate=objVol.SVDischDate
	Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
	//update by zhouruimeng 2016-03-15 取首次回收的日期
	Set BackDateTime=##class(DHCWMR.SSService.VolumeSrv).GetBackDate(EpisodeID,"RC")
	Set BackDate=$p(BackDateTime," ",1)
	;Set BackDate=objVol.SVBackDate
	Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BackDate)
	Set StatusDesc=objVol.SVStatus.WIDesc
	Set StepDesc=$s(OrdStep="A":"未回收",OrdStep="D":"回收",OrdStep="S":"归档",1:"临时")
	
	Set (FrontPageID,FPIsFinish,FPBuildDate,FPBuildTime,FPUpdateDate,FPUpdateTime)=""
	Set FPIsFinish="未编目"  //FixBug:6492 病案管理系统-住院病案-病案编目-[导出Excel],导出的Excel中编目状态显示为数字
	Set xFpID=$o(^DHCWMR.FP.FrontPageI("IndexVolume",aVolID,aFPType,0))
	Set objFP=##class(DHCWMR.FP.FrontPage).GetObjById(xFpID)
	If $IsObject(objFP){
		Set FrontPageID=objFP.%Id()
		Set FPIsFinish=$S(objFP.FPIsFinish=0:"草稿",1:"编目") //FixBug:6492 病案管理系统-住院病案-病案编目-[导出Excel],导出的Excel中编目状态显示为数字
		Set FPBuildDate=objFP.FPBuildDate
		Set:FPBuildDate'="" FPBuildDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(FPBuildDate)
		Set FPBuildTime=objFP.FPBuildTime
		Set:FPBuildTime'="" FPBuildTime=$zt(FPBuildTime,1)
		Set FPUpdateDate=objFP.FPUpdateDate
		Set:FPUpdateDate'="" FPUpdateDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(FPUpdateDate)
		Set FPUpdateTime=objFP.FPUpdateTime
		Set:FPUpdateTime'="" FPUpdateTime=$zt(FPUpdateTime,1)
	}
	//add by zhouruimeng 2016-03-15 显示病历的上一个状态
	Set PreStatus=##class(DHCWMR.SSService.VolStatusSrv).GetPremStatus(EpisodeID)

	Set return=$lb(aVolID_"-"_FrontPageID,aVolID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age)
	Set return=return_$lb(AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,DischDate,BackDate,StepDesc,StatusDesc)
	Set return=return_$lb(FrontPageID,FPIsFinish,FPBuildDate,FPBuildTime,FPUpdateDate,FPUpdateTime)
	Set return=return_$lb(EncryptLevel,PatLevel,PreStatus)
	Quit return
}

}
