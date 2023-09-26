/// 名称: DHCWMR.FPService.FPDiagnosSrv
/// 描述: 编目诊断信息相关服务
/// 编写者：zhufei
/// 编写日期: 2014-08-25
Class DHCWMR.FPService.FPDiagnosSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2014-08-25
/// Description:  查询诊断信息
/// Table：       DHCWMR.FP.FPDiagnos
/// Input：       aFrontPageID : 编目ID
///               aVolumeID : 卷ID
/// Return：      ROWSPEC=...
/// D ##class(%ResultSet).RunQuery("DHCWMR.FPService.FPDiagnosSrv","QryICDList","","121","1")
Query QryICDList(aFrontPageID As %String, aVolumeID As %String, aFPItemID As %String) As %Query(ROWSPEC = "RowNumber:%String,VolumeID:%String,EpisodeID:%String,FrontPageID:%String,FPSubID:%String,RowIndex:%String,ICDVerID:%String,ICDVerCode:%String,ICDID:%String,ICD10:%String,ICDDesc:%String,TypeID:%String,TypeCode:%String,TypeDesc:%String,AdmitCondID:%String,AdmitCondDesc:%String,DischCondID:%String,DischCondDesc:%String,IsDefiniteID:%String,IsDefiniteDesc:%String,DataSource:%String,EprRowNo:%String") [ SqlProc ]
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
		 	Set xIndex=$o(^DHCWMR.FP.FrontPageI("FPD","IndexFPDIndex",aFrontPageID,xIndex))
		 	Quit:xIndex=""
		 	
		 	Set xSubID=0
		 	For {
				Set xSubID=$o(^DHCWMR.FP.FrontPageI("FPD","IndexFPDIndex",aFrontPageID,xIndex,xSubID))
				Quit:xSubID=""
				
				Set FPSubID=xSubID
				Set obj=##class(DHCWMR.FP.FPDiagnos).GetObjById(aFrontPageID_"||"_xSubID)
				Continue:'$IsObject(obj)
				
				Set (TypeID,TypeCode,TypeDesc,ICDID,ICD10,ICDDesc,ICDVerID,ICDVerCode)=""
				Set (AdmitCondID,AdmitCondDesc,DischCondID,DischCondDesc,IsDefiniteID,IsDefiniteDesc)=""
				
				Set TempData=obj.FPDTempData
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
					Set AdmitCondID=$p(TempData,"^",6)
					Set AdmitCondDesc=$p(TempData,"^",7)
					Set DischCondID=$p(TempData,"^",8)
					Set DischCondDesc=$p(TempData,"^",9)
					Set IsDefiniteID=$p(TempData,"^",10)
					Set IsDefiniteDesc=$p(TempData,"^",11)
				} Else {
					If $IsObject(obj.FPDType){
						Set TypeID=obj.FPDType.%Id()
						Set TypeCode=obj.FPDType.SDCode
						Set TypeDesc=obj.FPDType.SDDesc
					}
					If $IsObject(obj.FPDICDDr){
						Set ICDID=obj.FPDICDDr.%Id()
						Set ICD10=obj.FPDICDDr.IDICD10
						Set ICDDesc=obj.FPDICDDr.IDDesc
						If $IsObject(obj.FPDICDDr.IDVCode){
							Set ICDVerID=obj.FPDICDDr.IDVCode.%Id()
							Set ICDVerCode=obj.FPDICDDr.IDVCode.IVCode
						}
					}
					If $IsObject(obj.FPDAdmitCond){
						Set AdmitCondID=obj.FPDAdmitCond.%Id()
						Set AdmitCondDesc=obj.FPDAdmitCond.SDDesc
					}
					If $IsObject(obj.FPDDischCond){
						Set DischCondID=obj.FPDDischCond.%Id()
						Set DischCondDesc=obj.FPDDischCond.SDDesc
					}
					If $IsObject(obj.FPDIsDefinite){
						Set IsDefiniteID=obj.FPDIsDefinite.%Id()
						Set IsDefiniteDesc=obj.FPDIsDefinite.SDDesc
					}
				}
				
				Set RowIndex=obj.FPDIndex
				Set DataSource=obj.FPDDataSource
				Set EprRowNo=$p(DataSource,"#",1)
				
				Set RowNumber=RowNumber+1
				Set Data=$lb(RowNumber,VolumeID,EpisodeID,FrontPageID,FPSubID,RowIndex)
				Set Data=Data_$lb(ICDVerID,ICDVerCode,ICDID,ICD10,ICDDesc,TypeID,TypeCode,TypeDesc)
				Set Data=Data_$lb(AdmitCondID,AdmitCondDesc,DischCondID,DischCondDesc,IsDefiniteID,IsDefiniteDesc)
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
		Set FPICDVerID=objFPItem.WIICDVer.%Id()
		Quit:FPICDVerID="" $$$OK
 		
 		Set HISICDVerID=""
		Set objVersion=##class(DHCWMR.FP.ICDVersion).GetObjByCode("HIS-D")
		If $IsObject(objVersion){
			Set HISICDVerID=objVersion.%Id()
		}
 		
		Set IsEprFrontPageSaveICD10=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("IsEprFrontPageSaveICD10")
		Set IsEprFrontPageSaveICD10=+IsEprFrontPageSaveICD10
 		
 		For indType=1:1:7 {
	 		Set TypeCode=""
	 		Set:indType=1 TypeCode=1 //主要诊断
	 		Set:indType=2 TypeCode=2 //其它诊断
	 		Set:indType=3 TypeCode=4 //病理诊断
	 		Set:indType=4 TypeCode=6 //门急诊诊断
	 		Set:indType=5 TypeCode=7 //入院诊断
	 		Set:indType=6 TypeCode=5 //损伤中毒诊断
	 		Set:indType=7 TypeCode=3 //医院感染诊断
	 		Continue:TypeCode=""
	 		
	 		Set TypeID="",TypeDesc="",IsActive=0
	 		Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeCode("FPICDType",TypeCode,"")
			If $IsObject(objDic){
				Set TypeID=objDic.%Id()
				Set TypeCode=objDic.SDCode
				Set TypeDesc=objDic.SDDesc
				Set IsActive=objDic.SDIsActive
			}
			Continue:(TypeID="")||(TypeDesc="")
			Continue:IsActive'=1
			
	 		For indRow=1:1:25 {
				Set (ICDVerID,ICDVerCode,ICDID,ICD10,ICDDesc)=""
				Set (AdmitCondID,AdmitCondDesc,DischCondID,DischCondDesc,IsDefiniteID,IsDefiniteDesc)=""
				
				Set xTypeIndex=$s($l(indType)=1:"0"_indType,1:indType)
				Set xRowIndex=$s($l(indRow)=1:"0"_indRow,1:indRow)
				Set DECode="D"_xTypeIndex_".000."_xRowIndex
				Set RowNo=DECode
				
				Set $p(DECode,".",2)="001"
				Set ICDDesc=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)            //诊断
				Continue:(ICDDesc="")||(ICDDesc="-")
				
				//大部分医院诊断异常字段存储的诊断表ID，需要特殊处理一下
				Set $p(DECode,".",2)="002"
				Set ICD10=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)              //ICD10
				Set $p(DECode,".",2)="001"
				Set:ICD10="" ICD10=..GetEPRData(EpisodeID,DECode,"C",.ArrGlossary) //ICD10
			
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
						Set objICD=##class(DHCWMR.FP.ICDDx).GetObjByMRCDr(ICD10)
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
				Set AdmitCondDesc=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)      //入院病情
			
				If AdmitCondDesc'="" {
					Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeDesc("DiseaseResult",AdmitCondDesc)
					Set:$IsObject(objDic) AdmitCondID=objDic.%Id()
				}
				
				Set $p(DECode,".",2)="004"
				Set DischCondDesc=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)      //出院情况
				If DischCondDesc'="" {
					Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeDesc("Prognosis",DischCondDesc)
					Set:$IsObject(objDic) DischCondID=objDic.%Id()
				}
				
				Set $p(DECode,".",2)="005"
				Set IsDefiniteDesc=..GetEPRData(EpisodeID,DECode,"",.ArrGlossary)     //怀疑诊断
				Set:IsDefiniteDesc="" IsDefiniteDesc="确诊"
				If IsDefiniteDesc'="" {
					Set objDic=##class(DHCWMR.SS.Dictionary).GetByTypeDesc("QuestionDiagnose",IsDefiniteDesc)
					Set:$IsObject(objDic) IsDefiniteID=objDic.%Id()
				}
				
				Set DataSource=RowNo_"#"_TypeDesc_"#"_ICD10_"#"_ICDDesc_"#"_AdmitCondDesc_"#"_DischCondDesc_"#"_IsDefiniteDesc
				Set EprRowNo=$p(DataSource,"#",1)
				//诊断描述和编码对照
				Set objICD = ##class(DHCWMR.FPService.FPMappingSrv).GetMapString(EpisodeID,"D",FPICDVerID,ICD10,ICDDesc)
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
				Set Data=Data_$lb(AdmitCondID,AdmitCondDesc,DischCondID,DischCondDesc,IsDefiniteID,IsDefiniteDesc)
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
