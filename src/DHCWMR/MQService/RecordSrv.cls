/// 名称: DHCWMR.MQService.RecordSrv
/// 描述: 病案综合数据采集
/// 编写者：zhufei
/// 编写日期: 2014-12-26
Class DHCWMR.MQService.RecordSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2016-04-12
/// Description:  综合查询自动任务：（滚病历数据:按回收） 配置项：MQAutoWorkDays
/// Table：       DHCWMR.MQ.DataMaster、DHCWMR.MQ.DataRecord
/// Return：      返回 OK
/// d ##class(DHCWMR.MQService.RecordSrv).MQAotoWork()
ClassMethod MQAotoWork()
{
	Set return=""
	
	Set $ZT="MQAotoWorkErr"
	Set xMrTypeID=""
	For {
		Set xMrTypeID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID))
		Quit:xMrTypeID=""
		
		Set objMrType = ##class(DHCWMR.SS.MrType).GetObjById(xMrTypeID)
		Continue:'$IsObject(objMrType)
		
		Set objWFItem=##class(DHCWMR.SS.WorkFItem).GetWFItemBySysOpera(xMrTypeID,"RC")	//回收系统操作
		Continue:'$IsObject(objWFItem)
		Continue:'$IsObject(objWFItem.WFIItem)
		
		Set WorkItemID=objWFItem.WFIItem.%Id()
		Set xItemID=""
		For {
			Set xItemID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xItemID))
			Quit:xItemID=""
			Continue:WorkItemID'=xItemID
			
			Set CrrentDate=+$H
			Set MQAutoWorkDays=##class(DHCWMR.SSService.ConfigSrv).GetValueByKeyHosp("MQAutoWorkDays","")
			Set MQAutoWorkDays=+MQAutoWorkDays
			Continue:MQAutoWorkDays=0
			
			Set DateFrom = CrrentDate-MQAutoWorkDays
			Set DateTo = CrrentDate-MQAutoWorkDays
			For xDate = DateFrom:1:DateTo{
				Set xTime=""
				For {
					Set xTime=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xItemID,xDate,xTime))
					Quit:xTime=""
					
					Set xOperaID=0
					For {
						Set xOperaID=$o(^DHCWMR.SS.OperationI("IndexItemDrDate",xMrTypeID,xItemID,xDate,xTime,xOperaID))
						Quit:xOperaID=""
					
						Set objOpera=##class(DHCWMR.SS.Operation).GetObjById(xOperaID)
						Continue:'$IsObject(objOpera)
						Set BatchNumber=objOpera.OPBatchNumber
						Continue:BatchNumber=""
						Continue:'$d(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber))
						
						Set xVolumeID=""
						For {
							Set xVolumeID=$o(^DHCWMR.SS.VolumeI("VS","IndexBatchNumber"," "_BatchNumber,xVolumeID))
							Quit:xVolumeID=""
							
							Set objVolume=##class(DHCWMR.SS.Volume).GetObjById(xVolumeID)
							Continue:'$IsObject(objVolume)
							Continue:objVolume.SVIsActive=0
							
							Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(xVolumeID)
							//w "EpisodeID:"_EpisodeID_"病案号:"_objVolume.SVMainDr.SMMrNo,!
							//导入首页数据
							Set flg = ..GetEPRRecords(EpisodeID)
						}
					}
				}
			}
		}
	}
	Quit "OK"
MQAotoWorkErr
	Quit "Error"
}

/// Creator：     zhufei
/// CreatDate：   2014-12-26
/// Description:  病历首页数据导入
/// Table：       PA_ADM、DHCWMR.MQ.DataMaster、DHCWMR.MQ.DataRecord
/// Input：       FromDate : 开始日期
///               ToDate : 结束日期
/// Return：      返回List
/// w ##class(DHCWMR.MQService.RecordSrv).ImportEprData(+$h-1,+$h-1)
ClassMethod ImportEprData(aFromDate As %String, aToDate As %String)
{
	New (aFromDate,aToDate)
	Set return=""
	Quit:(aFromDate="")||(aToDate="") return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aFromDate'="" aFromDate=+aFromDate
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set:aToDate'="" aToDate=+aToDate
	Set DischDateIndex=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateIndex() //update by pylian 2015-01-21 取出院时间索引
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^PAADMi(DischDateIndex,xDate))
		Quit:xDate=""
		Continue:xDate>aToDate
		
		Set xEpisodeID=""
		For {
			Set xEpisodeID=$o(^PAADMi(DischDateIndex,xDate,xEpisodeID))
			Quit:xEpisodeID=""
			Do ..GetEPRRecords(xEpisodeID)
		}
	}
	Quit "OK"
}

/// 取电子病历首页数据记录
/// w ##class(DHCWMR.MQService.RecordSrv).GetEPRRecords(3800)
ClassMethod GetEPRRecords(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:aEpisodeID="" return
	
	Quit:$p($g(^PAADM(aEpisodeID)),"^",20)'="D" return	//在院
	Quit:$p($g(^PAADM(aEpisodeID)),"^",2)'="I" return	//非住院就诊
	
	Set tmpDateTime=..GetDischDateTime(aEpisodeID)
	Quit:tmpDateTime="" return
	Set DischDate=$p(tmpDateTime,",",1)
	Set DischTime=$p(tmpDateTime,",",2)
	Quit:DischDate="" return
	Set PatientID=$p($g(^PAADM(aEpisodeID)),"^",1)
	Quit:PatientID="" return
	
	Set InputStr=aEpisodeID
	Set InputStr=InputStr_"^"_PatientID
	Set InputStr=InputStr_"^"_"D"
	Set InputStr=InputStr_"^"_DischDate
	Set InputStr=InputStr_"^"_DischTime
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_1
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.MQ.DataMaster).Update(InputStr,"^")
	Quit:(+flg)<1 return
	
	Set MasterID=+flg
	//三版电子病历，GetNewStdDataByGlossaryCategory方法为术语集调用接口
	Set ArrGlossary=##Class(%ArrayOfDataTypes).%New()
	Set Count=0
	Set xElCode=""
	For {
		Set xElCode=$o(^DHCWMR.MQ.DataItemsI("IndexDataSrcEleCode"," EPR",xElCode))
		Quit:xElCode=""
		
		Set xItemID=$o(^DHCWMR.MQ.DataItemsI("IndexDataSrcEleCode"," EPR",xElCode,0))
		Continue:xItemID=""
		Set objItem=##class(DHCWMR.MQ.DataItems).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Continue:objItem.IsActive'=1
		Set DataType=objItem.DataType
		Set ElementCode=objItem.ElementCode
		Continue:ElementCode=""
		//清除已有数据
		if $d(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefItem",MasterID,xItemID)){
			Set SubID=$o(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefItem",MasterID,xItemID,""))
			Set flg=##class(DHCWMR.MQ.DataRecord).DeleteById(MasterID_"||"_SubID)
		}
		//取值首页数据
		Set ItemValue=##class(DHCWMR.IO.FromEprSrv).GetEPRData(aEpisodeID,ElementCode,.ArrGlossary)
		//转换取值类型
		Set ItemValue = $tr(ItemValue," ","")
		Set ItemValue=..ChangeValType(ItemValue,DataType)
		Continue:ItemValue=""

		Set InputStr=MasterID
		Set InputStr=InputStr_"^"_xItemID
		Set InputStr=InputStr_"^"_ItemValue
		Set InputStr=InputStr_"^"_DataType
		Set InputStr=InputStr_"^"_1
		Set flg=##class(DHCWMR.MQ.DataRecord).Update(InputStr,"^")
		Continue:(+flg)<1
		Set Count=Count+1
	}
	Quit Count
}

/// Creator：     zhufei
/// CreatDate：   2014-12-26
/// Description:  病案编目数据导入
/// Table：       DHCWMR.FP.FrontPage、DHCWMR.MQ.DataMaster、DHCWMR.MQ.DataRecord
/// Input：       FromDate : 开始日期
///               ToDate : 结束日期
/// Return：      返回List
/// w ##class(DHCWMR.MQService.RecordSrv).ImportFpData(+$h-1,+$h-1)
ClassMethod ImportFpData(aFromDate As %String, aToDate As %String)
{
	New (aFromDate,aToDate)
	Set return=""
	Quit:(aFromDate="")||(aToDate="") return
	
	Set:aFromDate["-" aFromDate=$zdh(aFromDate,3)
	Set:aFromDate'="" aFromDate=+aFromDate
	Set:aToDate["-" aToDate=$zdh(aToDate,3)
	Set:aToDate'="" aToDate=+aToDate
	
	Set xDate=aFromDate-1
	For {
		Set xDate=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",1,xDate))
		Quit:xDate=""
		Quit:xDate>aToDate
		
		Set xTime=""
		For {
			Set xTime=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",1,xDate,xTime))
			Quit:xTime=""
			
			Set xFrontPageID=0
			For {
				Set xFrontPageID=$o(^DHCWMR.FP.FrontPageI("IndexUpdateDate",1,xDate,xTime,xFrontPageID))
				Quit:xFrontPageID=""
				Do ..GetFPRecords(xFrontPageID)
			}
		}
	}
	Quit "OK"
}

/// 取编目诊断手术数据记录
/// w ##class(DHCWMR.MQService.RecordSrv).GetFPRecords(3800)
ClassMethod GetFPRecords(aFrontPageID As %String) As %String
{
	New (aFrontPageID)
	Set Count=0
	Quit:aFrontPageID="" Count
	
	Set objFP=##class(DHCWMR.FP.FrontPage).GetObjById(aFrontPageID)
	Quit:'$IsObject(objFP) Count
	Quit:objFP.FPType'="F" Count
	Quit:'$IsObject(objFP.FPVolumeDr) Count
	Set VolumeID=objFP.FPVolumeDr.%Id()
	Set EpisodeID=##Class(DHCWMR.SS.Volume).GetEpisodeID(VolumeID)
	Quit:EpisodeID="" Count
	Set PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	Quit:PatientID="" Count
	Set BuildDate=objFP.FPBuildDate
	Set BuildTime=objFP.FPBuildTime
	
	Set InputStr=EpisodeID
	Set InputStr=InputStr_"^"_PatientID
	Set InputStr=InputStr_"^"_"F"
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_""
	Set InputStr=InputStr_"^"_BuildDate
	Set InputStr=InputStr_"^"_BuildTime
	Set InputStr=InputStr_"^"_1
	Set InputStr=InputStr_"^"_""
	Set flg=##class(DHCWMR.MQ.DataMaster).Update(InputStr,"^")
	Quit:(+flg)<1 Count
	Set MasterID=+flg
	
	Kill arrDataItems
	
	//处理编目数据项数据存入arrDataItems
	Set xElCode=""
	For {
		Set xElCode=$o(^DHCWMR.MQ.DataItemsI("IndexDataSrcEleCode"," FP",xElCode))
		Quit:xElCode=""
		
		Set xItemID=$o(^DHCWMR.MQ.DataItemsI("IndexDataSrcEleCode"," FP",xElCode,0))
		Continue:xItemID=""
		Set objItem=##class(DHCWMR.MQ.DataItems).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Continue:objItem.IsActive'=1
		Set DataType=objItem.DataType
		Set ElementCode=objItem.ElementCode
		Continue:ElementCode=""
		Continue:ElementCode["-"
		Set ElType=$e(ElementCode,1,1)
		Set arrDataItems(ElType,ElementCode)=$lb(xItemID,DataType)
		//清除已有数据
		if $d(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefItem",MasterID,xItemID)){
			Set SubID=$o(^DHCWMR.MQ.DataMasterI("DataRecord","IndexParRefItem",MasterID,xItemID,""))
			Set flg=##class(DHCWMR.MQ.DataRecord).DeleteById(MasterID_"||"_SubID)
		}	
	}
	//同步诊断数据
	Set MainDigIndex=0,SubDigIndex=0,PathDigIndex=0,OutDigIndex=0,PreDigIndex=0,PoiDigIndex=0,InfDigIndex=0
	For indRow=1:1:objFP.ChildDiagnos.Count() {
		Set objFPD=objFP.ChildDiagnos.GetAt(indRow)
		Continue:'$IsObject(objFPD)
		Continue:'$IsObject(objFPD.FPDType)
		Set TypeCode=objFPD.FPDType.SDCode
		Set TypeDesc=objFPD.FPDType.SDDesc
		If TypeCode=1{
			Set TypeCode=1,MainDigIndex=MainDigIndex+1	//主要诊断,条数
		}ElseIf TypeCode=2{
			Set TypeCode=2,SubDigIndex=SubDigIndex+1 	//其它诊断,条数
		}ElseIf TypeCode=3{
			Set TypeCode=7,InfDigIndex=InfDigIndex+1 	//医院感染诊断,条数	
		}ElseIf TypeCode=4{
			Set TypeCode=3,PathDigIndex=PathDigIndex+1 	//病理诊断,条数
		}ElseIf TypeCode=5{
			Set TypeCode=6,PoiDigIndex=PoiDigIndex+1 	//损伤中毒诊断,条数
		}ElseIf TypeCode=6{
			Set TypeCode=4,OutDigIndex=OutDigIndex+1 	//门急诊诊断,条数
		}ElseIf TypeCode=7{
			Set TypeCode=5,PreDigIndex=PreDigIndex+1 	//入院诊断,条数
		}else{}
				
		Set ICD10="",ICDDesc=""
		If $IsObject(objFPD.FPDICDDr){
			Set ICD10=objFPD.FPDICDDr.IDICD10
			Set ICDDesc=objFPD.FPDICDDr.IDDesc
		}
		Continue:ICDDesc=""
		Set AdmitCondDesc=""
		If $IsObject(objFPD.FPDAdmitCond){
			Set AdmitCondDesc=objFPD.FPDAdmitCond.SDDesc
		}
		Set DischCondDesc=""
		If $IsObject(objFPD.FPDDischCond){
			Set DischCondDesc=objFPD.FPDDischCond.SDDesc
		}
		Set IsDefiniteDesc=""
		If $IsObject(objFPD.FPDIsDefinite){
			Set IsDefiniteDesc=objFPD.FPDIsDefinite.SDDesc
		}
		Set DataIndex=objFPD.FPDIndex
		Set xElCode=""
		For {
			Set xElCode=$o(arrDataItems("D",xElCode))
			Quit:xElCode=""

			Set tmpItem=$g(arrDataItems("D",xElCode))
			Continue:tmpItem=""
			
			Set ItemID=$list(tmpItem,1)
			Set DataType=$list(tmpItem,2)
			Set Itemvalue=""
			If $e($P(xElCode,".",1),3)=TypeCode {
				//不符合诊断类型第几条退出
				Continue:(TypeCode=1)&&(MainDigIndex'=+$p(xElCode,".",3))  	//主要诊断
				Continue:(TypeCode=2)&&(SubDigIndex'=+$p(xElCode,".",3))   	//其它诊断
				Continue:(TypeCode=3)&&(PathDigIndex'=+$p(xElCode,".",3))	//病理诊断
				Continue:(TypeCode=4)&&(OutDigIndex'=+$p(xElCode,".",3))	//门急诊诊断
				Continue:(TypeCode=5)&&(PreDigIndex'=+$p(xElCode,".",3))	//入院诊断
				Continue:(TypeCode=6)&&(PoiDigIndex'=+$p(xElCode,".",3))	//损伤中毒诊断
				Continue:(TypeCode=7)&&(InfDigIndex'=+$p(xElCode,".",3))	//医院感染诊断	
				
				If $p(xElCode,".",2)="001" {
					Set Itemvalue=ICDDesc
				} ElseIf $p(xElCode,".",2)="002" {
					Set Itemvalue=ICD10
				} ElseIf $p(xElCode,".",2)="003" {
					Set Itemvalue=AdmitCondDesc
				} ElseIf $p(xElCode,".",2)="004" {
					Set Itemvalue=DischCondDesc
				} ElseIf $p(xElCode,".",2)="005" {
					Set Itemvalue=IsDefiniteDesc
				} Else {}
			}
			Set Itemvalue = $tr(Itemvalue," ","")
			Continue:Itemvalue=""			
			Set InputStr=MasterID
			Set InputStr=InputStr_"^"_ItemID
			Set InputStr=InputStr_"^"_Itemvalue
			Set InputStr=InputStr_"^"_DataType
			Set InputStr=InputStr_"^"_DataIndex
		 	Set flg=##class(DHCWMR.MQ.DataRecord).Update(InputStr,"^")
			Continue:(+flg)<1
			Set Count=Count+1	
		}
	}
	//同步手术操作数据
	Set OperIndex=0,ActIndex=0
	For indRow=1:1:objFP.ChildOperation.Count() {
		Set objFPO=objFP.ChildOperation.GetAt(indRow)
		Continue:'$IsObject(objFPO)
		Continue:'$IsObject(objFPO.FPOType)
		Set TypeCode=objFPO.FPOType.SDCode
		Set TypeDesc=objFPO.FPOType.SDDesc
		Set:TypeCode=1 OperIndex=OperIndex+1	//手术条数
 		Set:TypeCode=2 ActIndex=ActIndex+1 		//操作条数
		Set ICD10="",ICDDesc=""
		If $IsObject(objFPO.FPOICDDr){
			Set ICD10=objFPO.FPOICDDr.IDICD10
			Set ICDDesc=objFPO.FPOICDDr.IDDesc
		}
		Continue:ICDDesc=""
		
		Set SttDate=objFPO.FPOSttDate
		Set SttTime=objFPO.FPOSttTime
		Set EndDate=objFPO.FPOEndDate
		Set EndTime=objFPO.FPOEndTime
		Set OperatorTxt=objFPO.FPOOperatorTxt
		Set Assistant1Txt=objFPO.FPOAssistant1Txt
		Set Assistant2Txt=objFPO.FPOAssistant2Txt
		Set NarcosisDocTxt=objFPO.FPONarcosisDocTxt
		Set NarcosisTypeDesc=""
		If $IsObject(objFPO.FPONarcosisType){
			Set NarcosisTypeDesc=objFPO.FPONarcosisType.SDDesc
		}
		Set CutTypeDesc=""
		If $IsObject(objFPO.FPOCutType){
			Set CutTypeDesc=objFPO.FPOCutType.SDDesc
		}
		Set HealingDesc=""
		If $IsObject(objFPO.FPOHealing){
			Set HealingDesc=objFPO.FPOHealing.SDDesc
		}
		Set OperLevelDesc=""
		If $IsObject(objFPO.FPOOperLevel){
			Set OperLevelDesc=objFPO.FPOOperLevel.SDDesc
		}
		Set DataIndex=objFPO.FPOIndex
		Set xElCode=""
		For {
			Set xElCode=$o(arrDataItems("O",xElCode))
			Quit:xElCode=""
			
			Set tmpItem=$g(arrDataItems("O",xElCode))
			Continue:tmpItem=""
			Set ItemID=$list(tmpItem,1)
			Set DataType=$list(tmpItem,2)
			Set Itemvalue=""
			If $e($P(xElCode,".",1),3)=TypeCode {
				//不符合手术类型第几条退出
				Continue:(TypeCode=1)&&(OperIndex'=+$p(xElCode,".",3))  	//手术
				Continue:(TypeCode=2)&&(ActIndex'=+$p(xElCode,".",3))   	//操作
				If $p(xElCode,".",2)="001" {
					Set Itemvalue=ICDDesc
				} ElseIf $p(xElCode,".",2)="002" {
					Set Itemvalue=ICD10
				} ElseIf $p(xElCode,".",2)="003" {
					Set Itemvalue=SttDate
				} ElseIf $p(xElCode,".",2)="004" {
					Set Itemvalue=SttTime
				} ElseIf $p(xElCode,".",2)="005" {
					Set Itemvalue=EndDate
				} ElseIf $p(xElCode,".",2)="006" {
					Set Itemvalue=EndTime
				} ElseIf $p(xElCode,".",2)="007" {
					Set Itemvalue=OperatorTxt
				} ElseIf $p(xElCode,".",2)="008" {
					Set Itemvalue=Assistant1Txt
				} ElseIf $p(xElCode,".",2)="009" {
					Set Itemvalue=Assistant2Txt
				} ElseIf $p(xElCode,".",2)="010" {
					Set Itemvalue=NarcosisTypeDesc
				} ElseIf $p(xElCode,".",2)="011" {
					Set Itemvalue=NarcosisDocTxt
				} ElseIf $p(xElCode,".",2)="012" {
					Set Itemvalue=CutTypeDesc
				} ElseIf $p(xElCode,".",2)="013" {
					Set Itemvalue=HealingDesc
				} ElseIf $p(xElCode,".",2)="014" {
					Set Itemvalue=OperLevelDesc
				} Else {}
			}
			Set Itemvalue = $tr(Itemvalue," ","")
			Continue:Itemvalue=""
			Set InputStr=MasterID
			Set InputStr=InputStr_"^"_ItemID
			Set InputStr=InputStr_"^"_Itemvalue
			Set InputStr=InputStr_"^"_DataType
			Set InputStr=InputStr_"^"_DataIndex
			Set flg=##class(DHCWMR.MQ.DataRecord).Update(InputStr,"^")
			Continue:(+flg)<1
			Set Count=Count+1
		}
	}
	Kill arrDataItems
	
	Quit Count
}

/// 取值出院时间
ClassMethod GetDischDateTime(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set DischDate="",DischTime=""
	If DischDate="" {
		//Set DischDate=$p($g(^PAADM(aEpisodeID)),"^",17)  //最终结算日期
		//Set DischTime=$p($g(^PAADM(aEpisodeID)),"^",18)  //最终结算时间
		//update by pylian 2016-01-22
		Set DischDateTime=##Class(DHCWMR.IO.FromAdmSrv).GetDischDateTime(aEpisodeID)
		Set DischDate=$p(DischDateTime,"^",1)
		Set DischTime=$p(DischDateTime,"^",2)
	}
	Quit:DischDate="" return
	
	Set return=DischDate_","_DischTime
	Quit return
}

/// 转换取值类型
ClassMethod ChangeValType(aItemValue As %String, aToType As %String) As %String
{
	New (aItemValue,aToType)
	Set return=""
	Quit:(aItemValue="")||(aToType="") return
	If aToType="DATETIME" {
		Set return=##Class(DHCWMR.SSService.CommonSrv).GetCacheDateTime(aItemValue)
	} ElseIf aToType="DATE" {
		Set return=##class(DHCWMR.SSService.CommonSrv).GetCacheDate(aItemValue)
		Set return=$p(return,",",1)
	} ElseIf aToType="TIME" {
		Set return=##class(DHCWMR.SSService.CommonSrv).GetCacheTime(aItemValue)
		Set return=$p(return,",",2)
	} ElseIf aToType="NUMBER" {
		Set return=aItemValue
		Set:return'="" return=+aItemValue
	} Else {	//TEXT
		Set return=aItemValue
	}
	Quit return
}

}
