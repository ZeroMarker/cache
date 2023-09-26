/// 名称: DHCWMR.FPService.FPOperationSrv
/// 描述: 编目手术信息相关服务
/// 编写者：zhufei
/// 编写日期: 2014-10-24
Class DHCWMR.FPService.FPOperationSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-10-24
/// Description:  查询手术信息
/// Table：       DHCWMR.FP.FPOperation
/// Input：       aFrontPageID : 编目ID
///               aVolumeID : 卷ID
/// Return：      ROWSPEC=...
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.FPOperationSrv","QryICDList","","256226",1)
Query QryICDList(aFrontPageID As %String, aVolumeID As %String, aFPItemID As %String) As %Query(ROWSPEC = "RowNumber:%String,VolumeID:%String,EpisodeID:%String,FrontPageID:%String,FPSubID:%String,ICDVerID:%String,ICDVerCode:%String,RowIndex:%String,ICDID:%String,ICD10:%String,ICDDesc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,OperSttDate:%String,OperSttTime:%String,OperEndDate:%String,OperEndTime:%String,OperatorID:%String,OperatorName:%String,Ass1ID:%String,Ass1Name:%String,Ass2ID:%String,Ass2Name:%String,NarTypeID:%String,NarTypeDesc:%String,NarDocID:%String,NarDocName:%String,CutTypeID:%String,CutTypeDesc:%String,HealingID:%String,HealingDesc:%String,OperLevelID:%String,OperLevelDesc:%String,DataSource:%String,EprRowNo:%String") [ SqlProc ]
{
}

ClassMethod QryICDListExecute(ByRef qHandle As %Binary, aFrontPageID As %String, aVolumeID As %String, aFPItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aFrontPageID="")&&(aVolumeID="") $$$OK
 	
 	//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
 	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
 	
 	If aFrontPageID'="" {
		Set RowNumber=0,VolumeID="",EpisodeID="",FrontPageID=aFrontPageID,FPSubID=""
		Set objFrontPage=##class(DHCWMR.FP.FrontPage).GetObjById(aFrontPageID)
	 	Quit:'$IsObject(objFrontPage) $$$OK
	 	Quit:'$IsObject(objFrontPage.FPVolumeDr) $$$OK
	 	Set VolumeID=objFrontPage.FPVolumeDr.%Id()
	 	Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolumeID)
 		Quit:EpisodeID="" $$$OK
 		
	 	Set xIndex=""
	 	For {
		 	Set xIndex=$o(^DHCWMR.FP.FrontPageI("FPO","IndexFPOIndex",aFrontPageID,xIndex))
		 	Quit:xIndex=""
		 	Set xSubID=0
		 	For {
				Set xSubID=$o(^DHCWMR.FP.FrontPageI("FPO","IndexFPOIndex",aFrontPageID,xIndex,xSubID))
				Quit:xSubID=""
				
				Set FPSubID=xSubID
				Set obj=##class(DHCWMR.FP.FPOperation).GetObjById(aFrontPageID_"||"_xSubID)
				Continue:'$IsObject(obj)
				
				Set (TypeID,TypeCode,TypeDesc,ICDID,ICD10,ICDDesc,ICDVerID,ICDVerCode)=""
				Set (OperSttDate,OperSttTime,OperEndDate,OperEndTime,OperatorID,OperatorCode,OperatorName)=""
				Set (Ass1ID,Ass1Code,Ass1Name,Ass2ID,Ass2Code,Ass2Name)=""
				Set (NarTypeID,NarTypeDesc,NarDocID,NarDocCode,NarDocName)=""
				Set (CutTypeID,CutTypeDesc,HealingID,HealingDesc,OperLevelID,OperLevelDesc)=""
				
				Set TempData=obj.FPOTempData
				If TempData'="" {
					Set TypeID=$p(TempData,"^",1)
					Set TypeDesc=$p(TempData,"^",2)
					If TypeID'="" {
						Set objType=##class(DHCWMR.SS.Dictionary).GetObjById(TypeID)
						If $IsObject(objType){
							Set TypeCode=objType.SDCode
						}
					}
					Set ICDID=$p(TempData,"^",3)
					Set ICD10=$p(TempData,"^",4)
					Set ICDDesc=$p(TempData,"^",5)
					If ICDID'="" {
						Set objICD=##class(DHCWMR.FP.ICDDx).GetObjById(ICDID)
						If $IsObject(obj){
							Set ICD10=objICD.IDICD10
							If $IsObject(objICD.IDVCode){
								Set ICDVerID=objICD.IDVCode.%Id()
								Set ICDVerCode=objICD.IDVCode.IVCode
							}
						}
					}
					Set OperSttDate=$p(TempData,"^",6)  //格式2014-01-01
					Set OperSttTime=$p(TempData,"^",7)  //格式12:10:10
					Set OperEndDate=$p(TempData,"^",8)  //格式2014-01-01
					Set OperEndTime=$p(TempData,"^",9)  //格式12:10:10
					Set OperatorID=$p(TempData,"^",10)
					Set OperatorName=$p(TempData,"^",11)
					Set Ass1ID=$p(TempData,"^",12)
					Set Ass1Name=$p(TempData,"^",13)
					Set Ass2ID=$p(TempData,"^",14)
					Set Ass2Name=$p(TempData,"^",15)
					Set NarTypeID=$p(TempData,"^",16)
					Set NarTypeDesc=$p(TempData,"^",17)
					Set NarDocID=$p(TempData,"^",18)
					Set NarDocName=$p(TempData,"^",19)
					Set CutTypeID=$p(TempData,"^",20)
					Set CutTypeDesc=$p(TempData,"^",21)
					Set HealingID=$p(TempData,"^",22)
					Set HealingDesc=$p(TempData,"^",23)
					Set OperLevelID=$p(TempData,"^",24)
					Set OperLevelDesc=$p(TempData,"^",25)
				} Else {
					If $IsObject(obj.FPOType){
						Set TypeID=obj.FPOType.%Id()
						Set TypeCode=obj.FPOType.SDCode
						Set TypeDesc=obj.FPOType.SDDesc
					}
					If $IsObject(obj.FPOICDDr){
						Set ICDID=obj.FPOICDDr.%Id()
						Set ICD10=obj.FPOICDDr.IDICD10
						Set ICDDesc=obj.FPOICDDr.IDDesc
						If $IsObject(obj.FPOICDDr.IDVCode){
							Set ICDVerID=obj.FPOICDDr.IDVCode.%Id()
							Set ICDVerCode=obj.FPOICDDr.IDVCode.IVCode
						}
					}
					Set OperSttDate    = obj.FPOSttDate
					Set:OperSttDate'="" OperSttDate=$zd(OperSttDate,3)
					Set OperSttTime    = obj.FPOSttTime
					Set:OperSttTime'="" OperSttTime=$zt(OperSttTime,2)
					Set OperEndDate    = obj.FPOEndDate
					Set:OperEndDate'="" OperEndDate=$zd(OperEndDate,3)
					Set OperEndTime    = obj.FPOEndTime
					Set:OperEndTime'="" OperEndTime=$zt(OperEndTime,2)
					Set OperatorID     = obj.FPOOperator
					Set OperatorName   = obj.FPOOperatorTxt
					Set Ass1ID   = obj.FPOAssistant1
					Set Ass1Name = obj.FPOAssistant1Txt
					Set Ass2ID   = obj.FPOAssistant2
					Set Ass2Name = obj.FPOAssistant2Txt
					If $IsObject(obj.FPONarcosisType){
						Set NarTypeID=obj.FPONarcosisType.%Id()
						Set NarTypeDesc=obj.FPONarcosisType.SDDesc
					}
					Set NarDocID  = obj.FPONarcosisDoc
					Set NarDocName= obj.FPONarcosisDocTxt
					If $IsObject(obj.FPOCutType){
						Set CutTypeID=obj.FPOCutType.%Id()
						Set CutTypeDesc=obj.FPOCutType.SDDesc
					}
					If $IsObject(obj.FPOHealing){
						Set HealingID=obj.FPOHealing.%Id()
						Set HealingDesc=obj.FPOHealing.SDDesc
					}
					If $IsObject(obj.FPOOperLevel){
						Set OperLevelID=obj.FPOOperLevel.%Id()
						Set OperLevelDesc=obj.FPOOperLevel.SDDesc
					}
				}
				
				Set RowIndex=obj.FPOIndex
				Set DataSource=obj.FPODataSource
				Set EprRowNo=$p(DataSource,"#",1)
				
				Set RowNumber=RowNumber+1
				Set Data=$lb(RowNumber,VolumeID,EpisodeID,FrontPageID,FPSubID,RowIndex)
				Set Data=Data_$lb(ICDVerID,ICDVerCode,ICDID,ICD10,ICDDesc,TypeID,TypeCode,TypeDesc)
				Set Data=Data_$lb(OperSttDate,OperSttTime,OperEndDate,OperEndTime,OperatorID,OperatorName)
				Set Data=Data_$lb(Ass1ID,Ass1Name,Ass2ID,Ass2Name)
				Set Data=Data_$lb(NarTypeID,NarTypeDesc,NarDocID,NarDocName)
				Set Data=Data_$lb(CutTypeID,CutTypeDesc,HealingID,HealingDesc,OperLevelID,OperLevelDesc)
				Set Data=Data_$lb(DataSource,EprRowNo)
				Set ^CacheTemp(repid,ind)=Data
	 			Set ind=ind+1
			}
		}
	} Else {
		Set RowNumber=0,VolumeID=aVolumeID,EpisodeID="",FrontPageID="",FPSubID=""
		Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolumeID)
 		Quit:EpisodeID="" $$$OK
 		
		Set objFPItem=##class(DHCWMR.FP.WorkFItem).GetObjById(aFPItemID)
		Quit:'$IsObject(objFPItem) $$$OK
		Set FPICDVerID=objFPItem.WIOprVer.%Id()
		Quit:FPICDVerID="" $$$OK
 		
 		Set HISICDVerID=""
		Set objVersion=##class(DHCWMR.FP.ICDVersion).GetObjByCode("HIS-O")
		If $IsObject(objVersion){
			Set HISICDVerID=objVersion.%Id()
		}
 		
		Set IsEprFrontPageSaveICD10=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("IsEprFrontPageSaveICD10")
		Set IsEprFrontPageSaveICD10=+IsEprFrontPageSaveICD10
		
 		For indType=1:1:2 {
	 		Set TypeCode=""
	 		Set:indType=1 TypeCode=1 //手术
	 		Set:indType=2 TypeCode=2 //操作
	 		Continue:TypeCode=""
	 		
	 		Set TypeID="",TypeDesc=""
	 		Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("FPOpeType",TypeCode,"")
			If $IsObject(objDic){
				Set TypeID=objDic.%Id()
				Set TypeCode=objDic.SDCode
				Set TypeDesc=objDic.SDDesc
			}
			Continue:(TypeID="")||(TypeDesc="")
			
	 		For indRow=1:1:20 {
				Set (ICDVerID,ICDVerCode,RowIndex,ICDID,ICD10,ICDDesc)=""
				Set (OperSttDate,OperSttTime,OperEndDate,OperEndTime,OperatorID,OperatorCode,OperatorName)=""
				Set (Ass1ID,Ass1Code,Ass1Name,Ass2ID,Ass2Code,Ass2Name)=""
				Set (NarTypeID,NarTypeDesc,NarDocID,NarDocCode,NarDocName)=""
				Set (CutTypeID,CutTypeDesc,HealingID,HealingDesc,OperLevelID,OperLevelDesc)=""
				
				Set xTypeIndex=$s($l(indType)=1:"0"_indType,1:indType)
				Set xRowIndex=$s($l(indRow)=1:"0"_indRow,1:indRow)
				Set DECode="O"_xTypeIndex_".000."_xRowIndex
				Set RowNo=DECode
				
				Set $p(DECode,".",2)="001"
				Set ICDDesc  = ..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)         //手术
				Continue:(ICDDesc="")||(ICDDesc="-")
				
				Set $p(DECode,".",2)="002"
				Set ICD10=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)              //手术CM3
				Set $p(DECode,".",2)="001"
				Set:ICD10="" ICD10=..GetEPRData(EpisodeID,DECode,"C",.ArrGlossary) //手术CM3
				If ICD10'="" {
					If IsEprFrontPageSaveICD10=1 {  //标示存储的ICD10
						Set objICD=##class(DHCWMR.FP.ICDDx).GetObjByICD10(FPICDVerID,ICD10)
						If $IsObject(objICD){
							If objICD.IDDesc=ICDDesc {
								Set ICD10=objICD.IDICD10
								Set ICDID=objICD.%Id()
								Set ICDVerID=objICD.IDVCode.%Id()
								Set ICDVerCode=objICD.IDVCode.IVCode
							}
						}
					} Else {
						Set objICD=##class(DHCWMR.FP.ICDDx).GetObjByORCDr(ICD10)
						If $IsObject(objICD){
							If objICD.IDDesc=ICDDesc {
								Set ICD10=objICD.IDICD10
								Set ICDID=objICD.%Id()
								Set ICDVerID=objICD.IDVCode.%Id()
								Set ICDVerCode=objICD.IDVCode.IVCode
							}
						} Else {
							Set ICD10=""
						}
						If (ICDVerID'="")&&(FPICDVerID'=ICDVerID) {
							Set objICD=##class(DHCWMR.FP.ICDDx).GetObjByICD10(FPICDVerID,ICD10)
							If $IsObject(objICD){
								If objICD.IDDesc=ICDDesc {
									Set ICD10=objICD.IDICD10
									Set ICDID=objICD.%Id()
									Set ICDVerID=objICD.IDVCode.%Id()
									Set ICDVerCode=objICD.IDVCode.IVCode
								} Else {
									Set ICD10=""
									Set ICDID=""
									Set ICDVerID=""
									Set ICDVerCode=""
								}
							}
						}
					}
				}
				
				Set $p(DECode,".",2)="003"
				Set tmpDateTime=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)        //手术开始日期
				Set OperSttDate=$p(tmpDateTime," ",1)
				Set OperSttDate=$tr(OperSttDate,"年","-")
				Set OperSttDate=$tr(OperSttDate,"月","-")
				Set OperSttDate=$tr(OperSttDate,"日","")
				Set OperSttTime=$p(tmpDateTime," ",2)
				If (OperSttDate'="")&&(OperSttTime="") {
					Set $p(DECode,".",2)="004"
					Set OperSttTime=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)    //手术开始时间
					Set:OperSttTime[" " OperSttTime=$p(OperSttTime," ",2)
				}
				
				Set $p(DECode,".",2)="005"
				Set tmpDateTime=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)        //手术结束日期
				Set OperEndDate=$p(tmpDateTime," ",1)
				Set OperEndDate=$tr(OperEndDate,"年","-")
				Set OperEndDate=$tr(OperEndDate,"月","-")
				Set OperEndDate=$tr(OperEndDate,"日","")
				Set OperEndTime=$p(tmpDateTime," ",2)
				If (OperEndDate'="")&&(OperEndTime="") {
					Set $p(DECode,".",2)="006"
					Set OperEndTime=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)    //手术结束时间
					Set:OperEndTime[" " OperEndTime=$p(OperEndTime," ",2)
				}
				
				Set $p(DECode,".",2)="015"
				Set OperatorID=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)       //术者工号
				Set $p(DECode,".",2)="007"
				Set:OperatorID="" OperatorID=..GetEPRData(EpisodeID,DECode,"C",.ArrGlossary)   //术者工号
				Set OperatorName=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)       //术者姓名
				If OperatorID'="" {
					Set UserName=##Class(DHCWMR.FPService.SSUserSrv).GetUserNameByID(OperatorID)
					If UserName'=OperatorName {
						Set OperatorID=""
					}
				}
				
				Set $p(DECode,".",2)="016"
				Set Ass1ID=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)           //1助工号
				Set $p(DECode,".",2)="008"
				Set:Ass1ID="" Ass1Code=..GetEPRData(EpisodeID,DECode,"C",.ArrGlossary)           //1助工号
				Set Ass1Name=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)           //1助姓名
				If Ass1ID'="" {
					Set UserName=##Class(DHCWMR.FPService.SSUserSrv).GetUserNameByID(Ass1ID)
					If UserName'=Ass1Name {
						Set Ass1ID=""
					}
				}
				
				Set $p(DECode,".",2)="017"
				Set Ass2ID=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)           //2助工号
				Set $p(DECode,".",2)="009"
				Set:Ass2ID="" Ass2ID=..GetEPRData(EpisodeID,DECode,"C",.ArrGlossary)           //2助工号
				Set Ass2Name=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)           //2助姓名
				If Ass2ID'="" {
					Set UserName=##Class(DHCWMR.FPService.SSUserSrv).GetUserNameByID(Ass2ID)
					If UserName'=Ass2Name {
						Set Ass2ID=""
					}
				}
				
				Set $p(DECode,".",2)="010"
				Set NarTypeDesc=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)        //麻醉方式
				If NarTypeDesc'="" {
					Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeDesc("NarcosisType",NarTypeDesc)
					Set:$IsObject(objDic) NarTypeID=objDic.%Id()
				}
				
				Set $p(DECode,".",2)="018"
				Set NarDocID=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)     //麻醉医师工号
				Set $p(DECode,".",2)="011"
				Set:NarDocID="" NarDocID=..GetEPRData(EpisodeID,DECode,"C",.ArrGlossary)       //麻醉医师工号
				Set NarDocName=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)         //麻醉医师姓名
				If NarDocID'="" {
					Set UserName=##Class(DHCWMR.FPService.SSUserSrv).GetUserNameByID(NarDocID)
					If UserName'=NarDocName {
						Set NarDocID=""
					}
				}
				
				Set $p(DECode,".",2)="012"
				Set tmpDesc=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)            //切口类型
				Set CutTypeDesc=$p(tmpDesc,"/",1)
				Set HealingDesc=$p(tmpDesc,"/",2)
				If HealingDesc="" {
					Set $p(DECode,".",2)="013"
					Set HealingDesc=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)    //愈合情况
				}
				
				//update by liuyh 2017-03-23
				if (HealingDesc["/")
				{
					Set CutTypeDesc=$p(HealingDesc,"/",1)
					Set HealingDesc=$p(HealingDesc,"/",2)
				}
				
				Set:CutTypeDesc=0 CutTypeDesc="无"
				Set:HealingDesc=0 HealingDesc="无"
				If CutTypeDesc'="" {
					Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeDesc("FPCutType",CutTypeDesc)
					Set:$IsObject(objDic) CutTypeID=objDic.%Id()
				}
				If HealingDesc'="" {
					Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeDesc("FPHealing",HealingDesc)
					Set:$IsObject(objDic) HealingID=objDic.%Id()
				}
				
				Set $p(DECode,".",2)="014"
				Set OperLevelDesc=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)      //手术等级
				If OperLevelDesc'="" {
					Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeDesc("OperationRank",OperLevelDesc)
					Set:$IsObject(objDic) OperLevelID=objDic.%Id()
				}
				
				Set DataSource=RowNo_"#"_TypeDesc_"#"_ICD10_"#"_ICDDesc_"#"_OperSttDate_"#"_OperatorName_"#"_Ass1Name_"#"_Ass2Name_"#"_NarTypeDesc_"#"_NarDocName_"#"_CutTypeDesc_"#"_HealingDesc_"#"_OperLevelDesc
				Set EprRowNo=$p(DataSource,"#",1)
				If $IsObject(objICD){
						Set ICD10=objICD.IDICD10
						Set ICDID=objICD.%Id()
						Set ICDDesc=objICD.IDDesc
						Set ICDVerID=objICD.IDVCode.%Id()
						Set ICDVerCode=objICD.IDVCode.IVCode
				}
				Set RowNumber=RowNumber+1
				Set Data=$lb(RowNumber,VolumeID,EpisodeID,FrontPageID,FPSubID,RowIndex)
				Set Data=Data_$lb(ICDVerID,ICDVerCode,ICDID,ICD10,ICDDesc,TypeID,TypeCode,TypeDesc)
				Set Data=Data_$lb(OperSttDate,OperSttTime,OperEndDate,OperEndTime,OperatorID,OperatorName)
				Set Data=Data_$lb(Ass1ID,Ass1Name,Ass2ID,Ass2Name)
				Set Data=Data_$lb(NarTypeID,NarTypeDesc,NarDocID,NarDocName)
				Set Data=Data_$lb(CutTypeID,CutTypeDesc,HealingID,HealingDesc,OperLevelID,OperLevelDesc)
				Set Data=Data_$lb(DataSource,EprRowNo)
				Set ^CacheTemp(repid,ind)=Data
	 			Set ind=ind+1
		 	}
	 	}
	}
	
	Quit $$$OK
}

ClassMethod QryICDListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICDListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICDListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICDListExecute ]
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

ClassMethod GetEPRData(aEpisodeID As %String, aElCode As %String, aVType As %String = "", ByRef ArrGlossary As %ArrayOfDataTypes) As %String
{
	New (aEpisodeID,aElCode,aVType,ArrGlossary)
	Set return=##Class(DHCWMR.FPService.DataItemSrv).GetEPRData(aEpisodeID,aElCode,aVType,.ArrGlossary)
	Quit return
}

}
