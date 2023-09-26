/// 名称: DHCWMR.SSService.VolStatusQry
/// 描述: 病案状态 查询服务
/// 编写者：zhufei
/// 编写日期: 2014-09-20
Class DHCWMR.SSService.VolStatusQry Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-09-20
/// Description:  查询病案卷列表
/// Table：       DHCWMR.SS.Volume
/// Input：       MrTypeID : 病案类型ID
///               WFItemID : 工作流项目
///               FromDate : 开始日期
///               ToDate : 结束日期
///               QryFlag : 查询标记
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.VolStatusQry","QryVolumeList","4","7","2||5","2015-03-23","2015-03-23","0","","","U")
Query QryVolumeList(aHospID As %String, aMrTypeID As %String, aWFItemID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String, aOperaUser As %String, aQryFlag As %String) As %Query(ROWSPEC = "IndexNo:%String,VolID:%String,EpisodeID:%String,PatientID:%String,MrNo:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmDate:%String,AdmTime:%String,DischDate:%String,BackDate:%String,StepDesc:%String,StatusDesc:%String,ChiefProfessor:%String,Professor:%String,VistingDoctor:%String,ResidentDoctor:%String,EncryptLevel:%String,PatLevel:%String")
{
}

ClassMethod QryVolumeListExecute(ByRef qHandle As %Binary, aHospID As %String, aMrTypeID As %String, aWFItemID As %String, aDateFrom As %String, aDateTo As %String, aLocGrpID As %String, aLocID As %String, aOperaUser As %String, aQryFlag As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//Set ^ZF=$lb(aHospID,aMrTypeID,aWFItemID,aDateFrom,aDateTo,aLocGrpID,aLocID,aOperaUser,aQryFlag)
	
	Quit:(aHospID="")||(aMrTypeID="")||(aWFItemID="") $$$OK
	Set:aHospID'="" aHospID=","_aHospID_","
	
	Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetObjById(aWFItemID)
	Quit:'$IsObject(objWFItem) $$$OK
	Quit:'$IsObject(objWFItem.WFIItem) $$$OK
	Set WFIItemID=objWFItem.WFIItem.%Id()
	Set WFIType=objWFItem.WFIType
	Set WFIPreStep=objWFItem.WFIPreStep
	Set WFIPostStep=objWFItem.WFIPostStep
	Set WFISysOpera=objWFItem.WFISysOpera
	Set WFIPreItems=objWFItem.WFIPreItems
	Set WFISubFlow=objWFItem.WFISubFlow
	Quit:(WFIItemID="")||(WFIType="") return
	
	Set aDateFrom=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCWMR.SSService.CommonSrv).DateHtmlToLogical(aDateTo)
	Set:aDateFrom'="" aDateFrom=+aDateFrom
	Set:aDateTo'="" aDateTo=+aDateTo
	
	If aLocID="" {
		Set aLocID=##Class(DHCWMR.SSService.LocGroupSrv).GetLocListByGroup(aLocGrpID)
	}
	Set:aLocID'="" aLocID="|"_aLocID_"|"
	
	If aQryFlag="U" {  //未处理病历查询
		If WFISubFlow="O" { //顺序操作流程
			Quit:WFIPreStep="" $$$OK
			Set xVolID=0
			For {
				Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexOrdStep"," "_WFIPreStep,xVolID))
				Quit:xVolID=""
				
				Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(xVolID)
				Continue:'$IsObject(objVol)
				Continue:(WFISysOpera="RC")&&(objVol.SVDischDate="")  //未回收病历查询
				Continue:(WFISysOpera="S")&&(objVol.SVOrdStep="S")    //未归档病历查询
				
				Set Data=..BuildVolume(xVolID)
				Continue:Data=""
				
				//检查病案操作完成情况
				Set IsFinish=0
				Set aMrCat=""
				For {
					Set aMrCat=$o(^DHCWMR.SS.VolumeI("VS","IndexStatusCate",xVolID,aMrCat))
					Quit:aMrCat=""
					Quit:IsFinish=1
					Set xSubID=0
					For {
						Set xSubID=$o(^DHCWMR.SS.VolumeI("VS","IndexStatusCate",xVolID,aMrCat,WFIItemID,xSubID))
						Quit:xSubID=""
						Quit:IsFinish=1
						Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(xVolID_"||"_xSubID)
						Continue:'$IsObject(objStatus)
						Continue:objStatus.VSUpdoOpera="U"
						//update by zf 20150403 非顺序流程不参与流程控制
						If objWFItem.WFISubFlow="O" {
							Continue:objWFItem.WFIPostStep'=objVol.SVOrdStep
						}
						Set IsFinish=1
					}
				}
				Continue:IsFinish=1
				
				Set IndexNo=xVolID
				Set ^CacheTemp(repid,ind)=$lb(IndexNo)_Data
				Set ind=ind+1
			}
		} Else { //借阅、复印、封存操作流程
			Quit:(aDateFrom="")||(aDateTo="") $$$OK
			Set xItemID=0
			For {
				Set xItemID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID))
				Quit:xItemID=""
			
				Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItem(aMrTypeID,xItemID)
				Continue:'$IsObject(objWFItem)
				Continue:objWFItem.WFISubFlow=""
				Continue:objWFItem.WFISubFlow'=WFISubFlow
				If WFISysOpera="B"{ //系统操作为突发还回(新版程序突发还回和突发操作不做维护)
					Continue
				}ElseIf WFISysOpera="LB"{ //系统操作为入库:借阅未还回
					Continue:objWFItem.WFISysOpera'="LL"
				}ElseIf WFISysOpera="SF"{ //系统操作为封存病历:未解封
					Continue:objWFItem.WFISysOpera'="LS"
				}Else{ //其他（不处理）
					Continue
				}
				Set xDate=aDateFrom-1
				For {
					Set xDate=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID,xDate))
					Quit:xDate=""
					Quit:xDate>aDateTo
				
					Set xTime=""
					For {
						Set xTime=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID,xDate,xTime))
						Quit:xTime=""
					
						Set xOperaID=0
						For {
							Set xOperaID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID,xDate,xTime,xOperaID))
							Quit:xOperaID=""
						
							Set objOpera=##class(DHCWMR.SS.Operation).GetObjById(xOperaID)
							Continue:'$IsObject(objOpera)
							Set BatchNumber=objOpera.OPBatchNumber
							Continue:BatchNumber=""
							
							If WFISysOpera="LB"{	//未还回按借阅结构处理
								Set LendID=$o(^DHCWMR.MO.LendRecordI("STATUS","IndexBatchNumber"," "_BatchNumber,""))
								Continue:LendID=""
								
								Set objLend=##class(DHCWMR.MO.LendRecord).GetObjById(LendID)
								Continue:'$isObject(objLend)
								Continue:(objLend.LRStatus="B")||(objLend.LRStatus="U") //作废记录、还回记录过滤
								
								For indLVol=1:1:objLend.ChildVol.Count() {
									Set objLVol=objLend.ChildVol.GetAt(indLVol)
									Continue:'$IsObject(objLVol)
									Set objVol=objLVol.RVolumeDr
									Continue:'$IsObject(objVol)
									Set xVolID=objVol.%Id()
									Set Data=..BuildVolume(xVolID)
									Continue:Data=""
									//检查卷操作是否有效
									Set xSub=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID,""),-1)
									Continue:xSub=""
									Set objVolStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(xVolID_"||"_xSub)
									Continue:'$IsObject(objVolStatus)
									Continue:objVolStatus.VSUpdoOpera'="" //撤销状态 作废或回置
							
									Set IndexNo=xVolID_"||"_xOperaID
									Set ^CacheTemp(repid,ind)=$lb(IndexNo)_Data
									Set ind=ind+1
								}
							}ElseIf WFISysOpera="SF"{	//未解封按封存结构处理
								Set SealID=$o(^DHCWMR.MO.SealRecordI("STATUS","IndexBatchNumber"," "_BatchNumber,""))
								Continue:SealID=""
								
								Set objSeal=##class(DHCWMR.MO.SealRecord).GetObjById(SealID)
								Continue:'$isObject(objSeal)
								Continue:(objSeal.SRStatus="F")||(objSeal.SRStatus="U") //作废记录、解封记录过滤
								
								For indSVol=1:1:objLRecord.ChildVol.Count() {
									Set objSVol=objLRecord.ChildVol.GetAt(indSVol)
									Continue:'$IsObject(objSVol)
									Set objVol=objSVol.RVolumeDr
									Continue:'$IsObject(objVol)
									Set xVolID=objVol.%Id()
									Set Data=..BuildVolume(xVolID)
									Continue:Data=""
									//检查卷操作是否有效
									Set xSub=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID,""),-1)
									Continue:xSub=""
									Set objVolStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(xVolID_"||"_xSub)
									Continue:'$IsObject(objVolStatus)
									Continue:objVolStatus.VSUpdoOpera'="" //撤销状态 作废或回置
							
									Set IndexNo=xVolID_"||"_xOperaID
									Set ^CacheTemp(repid,ind)=$lb(IndexNo)_Data
									Set ind=ind+1
								}
							}Else{}
						}
					}
				}
			}
		}
	} ElseIf aQryFlag="H" {  //历史状态查询
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		
		Set xDate=aDateFrom-1
		For {
			Set xDate=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,WFIItemID,xDate))
			Quit:xDate=""
			Quit:xDate>aDateTo
			
			Set xTime=""
			For {
				Set xTime=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,WFIItemID,xDate,xTime))
				Quit:xTime=""
				
				Set xOperaID=0
				For {
					Set xOperaID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,WFIItemID,xDate,xTime,xOperaID))
					Quit:xOperaID=""
					
					Set objOpera=##class(DHCWMR.SS.Operation).GetObjById(xOperaID)
					Continue:'$IsObject(objOpera)
					Set BatchNumber=objOpera.OPBatchNumber
					Continue:BatchNumber=""
					//过滤操作员 add 20150402
					Set OperaUser = objOpera.OPUserFrom
					Continue:(aOperaUser'="")&(aOperaUser'=OperaUser)
					
					Set xVolID=0
					For {
						Set xVolID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID))
						Quit:xVolID=""
						
						Set Data=..BuildVolume(xVolID)
						Continue:Data=""
						
						//检查卷操作是否有效
						Set xSub=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID,""),-1)
						Continue:xSub=""
						Set objVolStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(xVolID_"||"_xSub)
						Continue:'$IsObject(objVolStatus)
						Continue:objVolStatus.VSUpdoOpera'="" //撤销状态 作废或回置
						
						Set IndexNo=xVolID_"||"_xOperaID
						Set ^CacheTemp(repid,ind)=$lb(IndexNo)_Data
						Set ind=ind+1
					}
				}
			}
		}
	} ElseIf aQryFlag="E" {  //问题病历查询
		Set xQCLock=""
		For {
			Set xQCLock=$o(^DHCWMR.SS.VolumeI("IndexQCLock",xQCLock))
			Quit:xQCLock=""
			
			Set QCLock=+$e(xQCLock,2,$l(xQCLock))
			Continue:QCLock<1  //问题病历过滤
			
			Set xVolID=0
			For {
				Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexQCLock",xQCLock,xVolID))
				Quit:xVolID=""
				
				Set Data=..BuildVolume(xVolID)
				Continue:Data=""
				
				Set IndexNo=xVolID
				Set ^CacheTemp(repid,ind)=$lb(IndexNo)_Data
				Set ind=ind+1
			}
		}
	} ElseIf aQryFlag="C" {  //当前状态查询
		If WFISubFlow="O" {
			Quit:WFIPostStep="S" $$$OK
			Set xVolID=0
			For {
				Set xVolID=$o(^DHCWMR.SS.VolumeI("IndexSVStatus",WFIItemID,xVolID))
				Quit:xVolID=""
				
				Set Data=..BuildVolume(xVolID)
				Continue:Data=""
				
				Set IndexNo=xVolID
				Set ^CacheTemp(repid,ind)=$lb(IndexNo)_Data
				Set ind=ind+1
			}
		} Else { //质控病历、借阅病历、复印病历、封存病历
			//fix 不能查询出借阅状态
			Quit:'((WFISysOpera'="H")||(WFISysOpera'="CB")||(WFISysOpera'="CF")||(WFISysOpera'="CR")||(WFISysOpera'="CT")||(WFISysOpera'="LL")||(WFISysOpera'="LB")||(WFISysOpera'="QC")||(WFISysOpera'="QL")||(WFISysOpera'="SF")||(WFISysOpera'="SS")) $$$OK
			Quit:(aDateFrom="")||(aDateTo="") $$$OK
			Set xItemID=0
			For {
				Set xItemID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID))
				Quit:xItemID=""
				Continue:WFIItemID'=xItemID
				Set xDate=aDateFrom-1
				For {
					Set xDate=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID,xDate))
					Quit:xDate=""
					Quit:xDate>aDateTo
					
					Set xTime=""
					For {
						Set xTime=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID,xDate,xTime))
						Quit:xTime=""
						
						Set xOperaID=0
						For {
							Set xOperaID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",aMrTypeID,xItemID,xDate,xTime,xOperaID))
							Quit:xOperaID=""
							
							Set objOpera=##class(DHCWMR.SS.Operation).GetObjById(xOperaID)
							Continue:'$IsObject(objOpera)
							Set BatchNumber=objOpera.OPBatchNumber
							Continue:BatchNumber=""
							//过滤操作员	add 20150402
							Set OperaUser = objOpera.OPUserFrom
							Continue:(aOperaUser'="")&(aOperaUser'=OperaUser)
							
							Set xVolID=0
							For {
								Set xVolID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID))
								Quit:xVolID=""
								Continue:'$d(^DHCWMR.SS.VolumeI("IndexSVStatus",WFIItemID,xVolID)) //fix 不能查询出借阅状态

								Set Data=..BuildVolume(xVolID)
								Continue:Data=""
								
								//检查卷操作是否有效
								Set xSub=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolID,""),-1)
								Continue:xSub=""
								Set objVolStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(xVolID_"||"_xSub)
								Continue:'$IsObject(objVolStatus)
								Continue:objVolStatus.VSUpdoOpera'="" //撤销状态 作废或回置
								
								Set IndexNo=xVolID_"||"_xOperaID
								Set ^CacheTemp(repid,ind)=$lb(IndexNo)_Data
								Set ind=ind+1
							}
						}
					}
				}
			
			}
		}
	} Else {}
	
	Quit $$$OK
}

ClassMethod QryVolumeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVolumeListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryVolumeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVolumeListExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod BuildVolume(aVolID As %String) As %List
{
	Set return=""
	Quit:aVolID="" return
	
	Set objVol=##Class(DHCWMR.SS.Volume).GetObjById(aVolID)
	Quit:'$IsObject(objVol) return
	Quit:objVol.SVIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr) return
	Quit:objVol.SVMainDr.SMIsActive'=1 return
	Quit:'$IsObject(objVol.SVMainDr.SMMrType) return
	Quit:objVol.SVMainDr.SMMrType.%Id()'=aMrTypeID return
	Quit:'$IsObject(objVol.SVMainDr.SMMrType.MTMrClass) $$$OK
	
	Set MrClass=objVol.SVMainDr.SMMrType.MTMrClass.MCCode
	Set objMain=objVol.SVMainDr
	Set DischDate=objVol.SVDischDate
	if MrClass'="O"  //fix 门诊无出院时间
	{
		If aQryFlag'="H" { //add by mxp 20180316 根据操作日期查询“历史操作”记录，不需要检查出院日期
			If aDateFrom'="" {
				Quit:DischDate="" return
				Quit:DischDate<aDateFrom return
			}
			If aDateTo'="" {
				Quit:DischDate="" return
				Quit:DischDate>aDateTo return
			}
		}
	}
	Set OrdStep=objVol.SVOrdStep
	Set MrNo=objVol.SVMainDr.SMMrNo
	Set DischDate=objVol.SVDischDate
	Set:DischDate'="" DischDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(DischDate)
	Set BackDate=objVol.SVBackDate
	Set:BackDate'="" BackDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(BackDate)
	Set StatusDesc=objVol.SVStatus.WIDesc
	Set StepDesc=$s(OrdStep="A":"未回收",OrdStep="D":"回收",OrdStep="S":"归档",1:"临时")
	
	Set VolAdmStr=##Class(DHCWMR.SS.VolPaadm).GetAdmStrByVol(aVolID)
	Quit:VolAdmStr="" return
	Set VolAdmID=$p(VolAdmStr,",",1)
	Set EpisodeID=$p(VolAdmStr,",",2)
	Set AdmLoc=$p(VolAdmStr,",",3)
	Set AdmWard=$p(VolAdmStr,",",4)
	Set AdmHosp=$p(VolAdmStr,",",5)
    If (AdmHosp'="")&&(aHospID'="") {
		Quit:(aHospID'[(","_AdmHosp_",")) return  //检查院区是否符合
    }
	If aLocID'="" {
    	Quit:(aLocID'[("|"_AdmLoc_"|"))&&(aLocID'[("|"_AdmWard_"|")) return
    }
	
	Set objVolAdm=##Class(DHCWMR.SS.VolPaadm).GetPatObjByAdm("","",VolAdmID)
	Quit:'$IsObject(objVolAdm) return
	Set PatientID=objVolAdm.VPPatientID
	Set EpisodeID=objVolAdm.VPEpisodeID
	If EpisodeID'="" {
		Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
		Set VisitStatus=$p($g(^PAADM(+EpisodeID)),"^",20)
		Quit:VisitStatus="C" return
	}
	Set PapmiNo=""
	Set:PatientID'="" PapmiNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
	Set PatName=objVolAdm.VPPatName
	Set Sex=objVolAdm.VPSex
	Set Birthday=objVolAdm.VPBirthday
	Set IdentityCode=objVolAdm.VPIdentityCode
	Set Age=objVolAdm.VPAge
	
    Set AdmLoc=objVolAdm.VPAdmitDept
	Set AdmLocDesc=objVolAdm.VPAdmitDeptDesc
	Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
    Set AdmWard=objVolAdm.VPAdmitWard
	Set AdmWardDesc=objVolAdm.VPAdmitWardDesc
	Set:AdmWardDesc["-" AdmWardDesc=$p(AdmWardDesc,"-",2)
    Set DischDept=objVolAdm.VPDischDept
	Set DischDeptDesc=objVolAdm.VPDischDeptDesc
	Set:DischDeptDesc["-" DischDeptDesc=$p(DischDeptDesc,"-",2)
    Set DischWard=objVolAdm.VPDischWard
	Set DischWardDesc=objVolAdm.VPDischWardDesc
	Set:DischWardDesc["-" DischWardDesc=$p(DischWardDesc,"-",2)
	Set:DischDept'="" AdmLoc=DischDept
	Set:DischDeptDesc'="" AdmLocDesc=DischDeptDesc
	Set:DischWard'="" AdmWard=DischWard
	Set:DischWardDesc'="" AdmWardDesc=DischWardDesc
	Set AdmDate=objVolAdm.VPAdmitDate
	Set:AdmDate'="" AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=objVolAdm.VPAdmitTime
	Set:AdmTime'="" AdmTime=$zt(AdmDate,2)
	
	Set (EncryptLevel,PatLevel)=""
	Set SecretStr=##class(DHCWMR.IO.FromSecSrv).GetPatEncryptLevel(PatientID,.ErrMsg)
	Set:SecretStr'="" EncryptLevel=$p(SecretStr,"^",1)   //病人密级
	Set:SecretStr'="" PatLevel=$p(SecretStr,"^",2)		//病人级别
	
	Set (ChiefProfessor,Professor,VistingDoctor,ResidentDoctor)=""
	/* 标准版中不取值 项目上根据需要和实际情况取值	
	//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
	Set ChiefProfessor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.056",.ArrGlossary)	//科主任签名
	Set Professor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.137",.ArrGlossary)	//主任（副主任）医师签名
	Set VistingDoctor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.138",.ArrGlossary)	//主治医师签名
	Set ResidentDoctor=##class(DHCWMR.IO.FromEprSrv).GetEPRData(EpisodeID,"HDSD00.11.141",.ArrGlossary)	//住院医师签名
	*/
	If (MrClass="O")  //门诊就诊科室和日期为初诊科室和初诊日期
	{
		Set FirstLoc=objMain.SMFirstLoc
		Set AdmLocDesc=$p($g(^CTLOC(+FirstLoc)),"^",2)
		Set:AdmLocDesc["-" AdmLocDesc=$p(AdmLocDesc,"-",2)
		Set FirstDate=objMain.SMFirstDate
		Set AdmDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(FirstDate)
		Set FirstDoc=objMain.SMFirstDoc
		Set ResidentDoctor=$p($g(^CTPCP(+FirstDoc,1)),"^",2)
	}
	Set return=$lb(aVolID,EpisodeID,PatientID,MrNo,PapmiNo,PatName,Sex,Age)
	Set return=return_$lb(AdmLocDesc,AdmWardDesc,AdmDate,AdmTime,DischDate,BackDate,StepDesc,StatusDesc)
	Set return=return_$lb(ChiefProfessor,Professor,VistingDoctor,ResidentDoctor)
	Set return=return_$lb(EncryptLevel,PatLevel)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2014-12-04
/// Description:  查询病案卷状态列表
/// Table：       DHCWMR.SS.VolStatus
/// Input：       VolumeID : 卷ID
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCWMR.SSService.VolStatusQry","QryStatusList","8")
Query QryStatusList(aVolumeID As %String) As %Query(ROWSPEC = "StatusID:%String,ItemID:%String,ItemDesc:%String,UserID:%String,UserDesc:%String,ActDate:%String,ActTime:%String,ToUserID:%String,ToUserDesc:%String,BatchNumber:%String,UpdoOpera:%String,UpdoOperaDesc:%String,UpdoDate:%String,UpdoTime:%String,UpdoUserID:%String,UpdoUserDesc:%String,UpdoReason:%String,Resume:%String,RequestID:%String,ReqBatchNumber:%String,LnkOperaID:%String,LnkBatchNumber:%String")
{
}

ClassMethod QryStatusListExecute(ByRef qHandle As %Binary, aVolumeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aVolumeID="" $$$OK
	
	Set xSubID=0
	For {
		Set xSubID=$o(^DHCWMR.SS.VolumeD(aVolumeID,"S",xSubID))
		Quit:xSubID=""
		
		Set StatusID=aVolumeID_"||"_xSubID
		Set objStatus=##Class(DHCWMR.SS.VolStatus).GetObjById(StatusID)
		Continue:'$IsObject(objStatus)
		
		Set (ItemID,ItemDesc,UserID,UserDesc,ActDate,ActTime,ToUserID,ToUserDesc,BatchNumber)=""
		Set (UpdoOpera,UpdoOperaDesc,UpdoDate,UpdoTime,UpdoUserID,UpdoUserDesc,UpdoReason,Resume)=""
		Set (RequestID,ReqBatchNumber,LnkOperaID,LnkBatchNumber)=""
		
		If $IsObject(objStatus.VSStatus){
			Set ItemID=objStatus.VSStatus.%Id()
			Set ItemDesc=objStatus.VSStatus.WIDesc
		}
		Set UserID=objStatus.VSUserFrom
		Set:UserID'="" UserDesc=$p($g(^SSU("SSUSR",UserID)),"^",2)
		Set ActDate=objStatus.VSActDate
		Set:ActDate'="" ActDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(ActDate)
		Set ActTime=objStatus.VSActTime
		Set:ActTime'="" ActTime=$zt(ActTime,2)
		Set ToUserID=objStatus.VSUserTo
		Set:ToUserID'="" ToUserDesc=$p($g(^SSU("SSUSR",ToUserID)),"^",2)
		Set BatchNumber=objStatus.VSBatchNumber
		Set UpdoOpera=objStatus.VSUpdoOpera
		Set UpdoOperaDesc=$s(UpdoOpera="U":"作废",UpdoOpera="B":"回置",UpdoOpera="R":"修正",1:"")
		Set UpdoDate=objStatus.VSUpdoDate
		Set:UpdoDate'="" UpdoDate=##Class(DHCWMR.SSService.CommonSrv).DateLogicalToHtml(UpdoDate)
		Set UpdoTime=objStatus.VSUpdoTime
		Set:UpdoTime'="" UpdoTime=$zt(UpdoTime,2)
		Set UpdoUserID=objStatus.VSUpdoUser
		Set:UpdoUserID'="" UpdoUserDesc=$p($g(^SSU("SSUSR",UpdoUserID)),"^",2)
		Set UpdoReason=objStatus.VSUpdoReason
		Set Resume=objStatus.VSResume
		
		If $IsObject(objStatus.VSRequestDr){
			Set RequestID=objStatus.VSRequestDr.%Id()
			Set ReqBatchNumber=objStatus.VSRequestDr.RQBatchNumber
		}
		If $IsObject(objStatus.VSLnkOperaDr){
			Set LnkOperaID=objStatus.VSLnkOperaDr.%Id()
			Set LnkBatchNumber=objStatus.VSLnkOperaDr.OPBatchNumber
		}
		
		Set Data=$lb(StatusID,ItemID,ItemDesc,UserID,UserDesc,ActDate,ActTime,ToUserID,ToUserDesc,BatchNumber)
		Set Data=Data_$lb(UpdoOpera,UpdoOperaDesc,UpdoDate,UpdoTime,UpdoUserID,UpdoUserDesc,UpdoReason,Resume)
		Set Data=Data_$lb(RequestID,ReqBatchNumber,LnkOperaID,LnkBatchNumber)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryStatusListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStatusListExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryStatusListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStatusListExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
