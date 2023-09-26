/// 名称: DHCHAI.IRS.VAEScreeningSrv
/// 描述: VAE筛查界面相关服务
/// 编写者: zhoubo
/// 编写日期: 2022-03-24
Class DHCHAI.IRS.VAEScreeningSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-03-31
/// Description:  根据就诊号查找患者一段期间触发VAE的信息--时序图-30天
/// Table：       DHCHAI.IR.VAEResult
/// Input：       aEpisodeID : 就诊号
///               aRstID : DHCHAI.IR.VAEResult.ID
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.VAEScreeningSrv","QrySequence","112","21")
Query QrySequence(aEpisodeID As %String, aRstID As %String) As %Query(ROWSPEC = "ItemDesc:%String,Item1:%String,Item2:%String,Item3:%String,Item4:%String,Item5:%String,Item6:%String,Item7:%String,Item8:%String,Item9:%String,Item10:%String,Item11:%String,Item12:%String,Item13:%String,Item14:%String,Item15:%String,Item16:%String,Item17:%String,Item18:%String,Item19:%String,Item20:%String,IRVAEDate:%String") [ SqlProc ]
{
}

ClassMethod QrySequenceExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aRstID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
	Quit:(aEpisodeID="")||(aRstID="") $$$OK

 	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode) $$$OK
	Set AdmDate=objEpisode.PAAdmDate
	Set DischDate=objEpisode.PADischDate
	Set DateFrom=AdmDate   //  ???????后面能用到  VAE 感染科室
	Set DateTo=DischDate
	Set:DateTo="" DateTo=+$h
	
	Set objRst=##class(DHCHAI.IR.VAEResult).GetObjById(aRstID)
	Quit:'$IsObject(objRst) $$$OK
	Set VAEDate      = objRst.VAEDate
	Set MonitVAEDate = objRst.MonitVAEDate
	Set:MonitVAEDate'="" VAEDate=MonitVAEDate
	Set objMonitItem = objRst.VAEMonitItemDr
	Quit:'$IsObject(objMonitItem) $$$OK
	Set aMonItemID = objMonitItem.%Id()
	
	Set aDateFrom = VAEDate-9
	Set aDateTo   = VAEDate+10
	
	Set IRVAEDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VAEDate)
	Set IRVAEDate=$Tr(IRVAEDate,"-","")
	Set IRVAEDate=$e(IRVAEDate,5,8)
	
	// 输出表头日期信息
	Set DateList=""
	Set ColNum=1
	For xDate=aDateFrom:1:aDateTo{
		
		Set ColDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(xDate)
		Quit:ColNum>20
		Set ColDate=$Tr(ColDate,"-","")
		Set ColDate=$e(ColDate,5,8)
		
		Set DateList = DateList_$lb(ColDate)
		Set ColNum=ColNum+1
	}
	Set Data=$lb("日期")_DateList
	Set ^CacheTemp(repid,ind)=Data_$lb(IRVAEDate)
	Set ind=ind+1
	
	//患者Peep
	Set ValueList=""
	Set ColNum=1
	For xDate=aDateFrom:1:aDateTo{
		Quit:ColNum>20
		//获取当天最小值
		Set MinPeepValue=""
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.DP.VAEICUPeepI("IndexEpisTypeDate",aEpisodeID,"PEEP",xDate,xID))
			Quit:(xID="")
			Set VaeData=$g(^DHCHAI.DP.VAEICUPeepD(xID))
			Continue:VaeData=""
			Set Result=+$li(VaeData,5)
			Continue:Result<=0
			Set:(MinPeepValue="") MinPeepValue = Result
			If (Result<MinPeepValue){
				Set MinPeepValue = Result
			}
		}
		Set ValueList = ValueList_$lb(MinPeepValue)
		Set ColNum=ColNum+1
	}
	Set Data=$lb("PEEP")_ValueList
	Set ^CacheTemp(repid,ind)=Data_$lb(IRVAEDate)
	Set ind=ind+1
	
	//患者FIO2
	Set ValueList=""
	Set ColNum=1
	For xDate=aDateFrom:1:aDateTo{
		Quit:ColNum>20
		//获取当天最小值
		Set MinPeepValue=""
		Set xID=""
		For {
			Set xID=$o(^DHCHAI.DP.VAEICUPeepI("IndexEpisTypeDate",aEpisodeID,"FIO2",xDate,xID))
			Quit:(xID="")
			Set VaeData=$g(^DHCHAI.DP.VAEICUPeepD(xID))
			Continue:VaeData=""
			Set Result=+$li(VaeData,5)
			Continue:Result<=0
			Set:(MinPeepValue="") MinPeepValue = Result
			If (Result<MinPeepValue){
				Set MinPeepValue = Result
			}
		}
		Set ValueList = ValueList_$lb(MinPeepValue)
		Set ColNum=ColNum+1
	}
	Set Data=$lb("FIO2")_ValueList
	Set ^CacheTemp(repid,ind)=Data_$lb(IRVAEDate)
	Set ind=ind+1
	
	//患者发热
	Set ValueList=""
	Set ColNum=1
	For xDate=aDateFrom:1:aDateTo{
		Quit:ColNum>20
		Set MaxValue=""
		Set xOBSIMMapID=""
		For {
			Set xOBSIMMapID = $o(^DHCHAI.DP.MROBSItemMapD(xOBSIMMapID))
			Quit:xOBSIMMapID=""
			
			Set objOBSIMMap = ##class(DHCHAI.DP.MROBSItemMap).GetObjById(xOBSIMMapID)
			Continue:'$isobject(objOBSIMMap)
			Continue:objOBSIMMap.BTIsActive'=1
			Continue:'$isobject(objOBSIMMap.BTMapItemDr)
			Continue:'$isobject(objOBSIMMap.BTMapItemDr.BTCatDr)
			Continue:(objOBSIMMap.BTMapItemDr.BTCatDr.BTDesc'="体温")
			
			Set ItemDesc = objOBSIMMap.BTItemDesc
			Continue:ItemDesc=""
			
			Set xSCode = ""
			For {
				Set xSCode = $o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode))
				Quit:xSCode=""
				
				Set xMRObsID = ""
				For {
					Set xMRObsID = $o(^DHCHAI.DP.MRObservationsI("IndexEpisodeItemDescDate",aEpisodeID,xSCode,ItemDesc,xDate,xMRObsID),-1)  //倒序查找体温，一个时刻多个体温，取最后一个
					Quit:xMRObsID=""
					
					Set objMRObs = ##class(DHCHAI.DP.MRObservations).GetObjById(xMRObsID)
					Continue:'$isobject(objMRObs)
					Continue:objMRObs.OBIsActive'=1
					Set ItemValue=objMRObs.OBItemValue    //结果
					Continue:ItemValue=""    //发热标准
					Set IsFever=##class(DHCHAI.IRS.CRuleOBSSrv).CheckIsFever(objMRObs)
					Continue:IsFever<1  //检查发热规则（不同科室、不同年龄可能不同）
					Set:(MaxValue="") MaxValue = ItemValue
					If (ItemValue>MaxValue){
						Set MaxValue = ItemValue
					}
				}
			}
		}
		Set:MaxValue>0 MaxValue=MaxValue_"℃"
		Set ValueList = ValueList_$lb(MaxValue)
		Set ColNum=ColNum+1
	}
	Set Data=$lb("发热")_ValueList
	Set ^CacheTemp(repid,ind)=Data_$lb(IRVAEDate)
	Set ind=ind+1
	
	//检出菌
	Set ValueList=""
	Set ColNum=1
	For xDate=aDateFrom:1:aDateTo{
		Quit:ColNum>20
		Set BacteriaDescs=""
		Set xItemID=""
		For {
			Set xItemID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID))
			Quit:xItemID=""
			
			Set objItem=##class(DHCHAI.IR.CCItmMast).GetObjById(xItemID)
			Continue:'$IsObject(objItem)
			Set ItemCode=objItem.CCCode
			Continue:(ItemCode'="LAB-Bacteria")&&(ItemCode'="LAB-TestAb")&&(ItemCode'="LAB-Submit")
			
			Set xID=""
			For {
	 			Set xID=$o(^DHCHAI.IR.CCResultI("IndexItemDrActDate",aEpisodeID,xItemID,xDate,xID))
				Quit:xID=""
				
				Set obj=##class(DHCHAI.IR.CCResult).GetObjById(xID)
				Continue:'$IsObject(obj)
				Continue:'$IsObject(obj.CCEpisodeDr)
				Continue:'$IsObject(obj.CCItemDr)
				Continue:obj.CCIsActive'=1
				
				Set SCode=obj.CCSCode
				Set Bacteria=obj.CCBacteria
				Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(SCode,Bacteria)
				If $IsObject(objBactMap){
					Continue:objBactMap.BTIsActive'=1
					If $IsObject(objBactMap.BTMapItemDr){
						Set Bacteria=objBactMap.BTMapItemDr.BTBacDesc
					}
				}
				Continue:Bacteria=""  //细菌
				
				Set Specimen=obj.CCSpecimen
				Set objStanSpec=##class(DHCHAI.DP.LabSpecMap).GetStanSpecByDesc(SCode,Specimen)
				If $IsObject(objStanSpec){
					Set Specimen=objStanSpec.BTSpecDesc
				}
				Set ActDate=obj.CCActDate
				Set RepDate = obj.CCRepDate
				Set ObjectID=obj.CCObjectID
				Continue:ActDate=""
				
				//多耐
				Set MRBTypeID="",MRBTypeDesc=""
				If $IsObject(obj.CCMRBTpDr) {
					Set MRBTypeID=obj.CCMRBTpDr.%Id()
					Set MRBTypeDesc=obj.CCMRBTpDr.BTDesc
				}
				
				If MRBTypeID'="" {
					Set ItemCode = "MDR"
					Set Result = Bacteria_"(多耐)【"_Specimen_"】"
				}else{
					Set ItemCode = "BUG"
					Set Result = Bacteria_"【"_Specimen_"】"
				}
				
				Set tActDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
				Set tRepDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
				Set Result=Result_" 送检日期:"_tActDate_" 报告日期:"_tRepDate
				
				If BacteriaDescs'="" {
					Set BacteriaDescs=BacteriaDescs_"&#13;"_Result
				} Else {
					Set BacteriaDescs=Result
				}
			}
			
		}
		Set:BacteriaDescs'="" BacteriaDescs=$e(BacteriaDescs,2,$l(BacteriaDescs))
		Set ValueList = ValueList_$lb(BacteriaDescs)
		Set ColNum=ColNum+1
	}
	Set Data=$lb("检出菌")_ValueList
	Set ^CacheTemp(repid,ind)=Data_$lb(IRVAEDate)
	Set ind=ind+1
	
	//抗生素
	Set ValueList=""
	Set ColNum=1
	For xDate=aDateFrom:1:aDateTo{
		Quit:ColNum>20
		Set AntDescs=""
		Set xScode = ""
		For {
			Set xScode=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode))
			Quit:xScode=""
			
			Set xSttDate = ""
			For {
				Set xSttDate=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate))
				Quit:xSttDate=""
				Continue:(xSttDate>aDateTo)
				
				Set xOrdItemID =""
				For {
					Set xOrdItemID=$o(^DHCHAI.DP.OEOrdItemI("IndexEpisAntUseSttDate",aEpisodeID,xScode,1,xSttDate,xOrdItemID))
					Quit:xOrdItemID=""
			
					Set OEOrdItemData=$g(^DHCHAI.DP.OEOrdItemD(xOrdItemID))
					Continue:$li(OEOrdItemData,25)=0
		            
		            Set SCode   = $li(OEOrdItemData,28)
		           	Set OrdDesc = $li(OEOrdItemData,4)	        
		           	Set AntiMapID=$o(^DHCHAI.DP.OEAntiMastMapI("IndexSCodeAnitDesc",SCode,OrdDesc,0))
					Continue:AntiMapID="" //过滤未对照
				    Set AntiMapData=$g(^DHCHAI.DP.OEAntiMastMapD(AntiMapID))
				    Continue:AntiMapData=""
				    Set MapItemDr=$lg(AntiMapData,3)
				    Continue:MapItemDr=""
		            Set AntiMastData=$g(^DHCHAI.DP.OEAntiMastD(MapItemDr))
		            Continue:AntiMastData=""
		            ;Continue:$lg(AntiMastData,7)'=1  //非重点药物过滤
		            Set AntiMapDesc=$lg(AntiMastData,3)  //抗菌药物标准名称
	               
		            Set SttDate = $li(OEOrdItemData,15)
		            Set SttTime = $li(OEOrdItemData,16)
					Set EndDate = $li(OEOrdItemData,17)
					Set EndTime	= $li(OEOrdItemData,18)
					
		            Set Priority = $li(OEOrdItemData,8)	//医嘱类型		
					Set PriorityMap =  ##class(DHCHAI.DP.PhraseMap).GetMapValue(xScode,"OEPriority",Priority)
					Continue:PriorityMap=""
					Continue:PriorityMap="OUT"
					
		            If PriorityMap="N"{
						Set EndDate = SttDate
						Set EndTime	= SttTime
					}
					Continue:(EndDate<xDate)&&(EndDate'="")  // 停药日期在转入日期前
					Continue:(SttDate>xDate)
				    Set Generic=$li(OEOrdItemData,19)
					Set Result=Generic
					Set:Result="" Result=OrdDesc
				    Set:Priority["长期" Result=Result_"（长期）"
				
					If AntDescs'="" {
						Set AntDescs=AntDescs_"&#13;"_Result
					} Else {
						Set AntDescs=Result
					}
				}
			}
		}
		Set ValueList = ValueList_$lb(AntDescs)
		Set ColNum=ColNum+1
	}
	Set Data=$lb("抗生素")_ValueList
	Set ^CacheTemp(repid,ind)=Data_$lb(IRVAEDate)
	Set ind=ind+1
	
	// 新的抗生素
	Set ValueList=""
	Set ArgInfo = ##class(DHCHAI.IRS.VAERuleConfigSrv).GetArgByCode(aMonItemID,"7")
	Set NewFlag = +$p(ArgInfo,"^",1)
	Set UseAntiDay = +$p(ArgInfo,"^",2)
	Set:UseAntiDay=0 UseAntiDay=4
	
	If (ArgInfo=""){
		Set NewFlag =1
		Set UseAntiDay=4
	}
	Set ColNum=1
	For xDate=aDateFrom:1:aDateTo{
		Quit:ColNum>20
		Set AntiNew=##class(DHCHAI.IRS.VAEFunctionSrv).GetNewAntiByDate(aEpisodeID,VAEDate,NewFlag,UseAntiDay)
		Set AntiNewFlag=$p(AntiNew,"^",1)
		Set StartDate=$p(AntiNew,"^",2)
		Set UseAntiNew=""
		If (AntiNewFlag=1){
			If (xDate<StartDate){
				Set UseAntiNew="否"
			}Else{
				Set:xDate<(StartDate+11) UseAntiNew="是"
			}
		}
		Set ValueList = ValueList_$lb(UseAntiNew)
		Set ColNum=ColNum+1
	}
	Set Data=$lb("新的抗生素")_ValueList
	Set ^CacheTemp(repid,ind)=Data_$lb(IRVAEDate)
	Set ind=ind+1
	
	// 白细胞计数
	Set ValueList=""
	Set ArgInfo  = ##class(DHCHAI.IRS.VAERuleConfigSrv).GetArgByCode(aMonItemID,"8")
	Set aTestSetArg = +$p(ArgInfo,"^",1)
	Set aSpecArg    = +$p(ArgInfo,"^",2)
	Set WbcCntArg   = +$p(ArgInfo,"^",3)
	Set:WbcCntArg=0 WbcCntArg=12000
	Set WbcCntArg=WbcCntArg/1000 //单位转换下，检验那边一般是L 
	//如果设置了检验医嘱包含，那必须是包含里面的检验医嘱才算。否则只设置排除
	Set ContOELabList=""
	Set ExclOELabList=""
	For i=1:1:$l(aTestSetArg,"#") {
		Set Arg=$p(aTestSetArg,"#",i)
		Continue:Arg=""
		
		Set LabID=$p(Arg,",",1)
		Set objLab=##class(DHCHAI.DP.LabTestSetMap).GetObjById(LabID)
		Continue:('$IsObject(objLab))
		Set TestSetDesc=objLab.BTTestSet
		
		Set DicID=$p(Arg,",",2)
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicID)
		Continue:('$IsObject(objDic))
		Set DicCode=objDic.BTCode
		
		If (DicCode=1){  // 包含
			Set ContOELabList=ContOELabList_$lb(TestSetDesc)
		}
		If (DicCode=2){  // 排除
			Set ExclOELabList=ExclOELabList_$lb(TestSetDesc)
		}
	}
	
	// 标本
	Set ContSpecList=""
	Set ExclSpecList=""
	For i=1:1:$l(aSpecArg,"#") {
		Set Arg=$p(aSpecArg,"#",i)
		Continue:Arg=""
		
		Set SpecID=$p(Arg,",",1)
		Set objSpec=##class(DHCHAI.DP.LabSpecimen).GetObjById(SpecID)
		Continue:('$IsObject(objSpec))
		Set BTSpecDesc=objSpec.BTSpecDesc
		
		Set DicID=$p(Arg,",",2)
		Set objDic=##class(DHCHAI.BT.Dictionary).GetObjById(DicID)
		Continue:('$IsObject(objDic))
		Set DicCode=objDic.BTCode
		
		If (DicCode=1){  // 包含
			Set ContSpecList=ContSpecList_$lb(BTSpecDesc)
		}
		If (DicCode=2){  // 排除
			Set ExclSpecList=ExclSpecList_$lb(BTSpecDesc)
		}
	}
	Set ColNum=1
	For xDate=aDateFrom:1:aDateTo{
		Quit:ColNum>20
		Set RetFlag=0
		Set SubWBCs=""
		// 白细胞计数
		Set xSCode=""
		For {
			Set xSCode=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDrRecDate",aEpisodeID,xSCode))
			Quit:xSCode=""
			
			Set xLabNumID=""
			For {
				Set xLabNumID=$o(^DHCHAI.DP.LabVisitNumberI("IndexEpisodeDrRecDate",aEpisodeID,xSCode,xDate,xLabNumID))
				Quit:xLabNumID=""

				Set objLabNum=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xLabNumID)
				Continue:'$IsObject(objLabNum)
				Continue:objLabNum.LabIsActive'=1
				Set EpisodeNo=objLabNum.LabEpisodeNo  //检验号/标本号
				Set LocDr=objLabNum.LabLocDr.%Id()    //送检科室
			    Set objLoc = ##class(DHCHAI.BT.Location).GetObjById(LocDr)
				Continue:'$IsObject(objLoc)
				Continue:'$IsObject(objLoc.BTHospDr)
			    
			    Set SCode    = objLabNum.LabSCode
				Set CollDate  = objLabNum.LabCollDate      //采集日期
				Set CollTime  = objLabNum.LabCollTime      //采集时间
		
				Set RecDate=objLabNum.LabRecDate		//接收日期
				Set RecTime=objLabNum.LabRecTime
		
				Set CollDate=$s(CollDate'="":CollDate,1:RecDate)		//送检日期优先用采集日期
				Set CollTime=$s(CollTime'="":CollTime,1:RecTime)
				//标本过滤
				Set Specimen = objLabNum.LabSpecimen	//标本名称[血.....]
				If (ContSpecList'=""){
					Continue:($lf(ContSpecList,Specimen)<1)
				}
				If (ExclSpecList'=""){
					Continue:($lf(ExclSpecList,Specimen)>0)
				}
				
				// 循环检验医嘱表[检查送检记录是否是(检出菌、常规检验、PCT（降钙素原）、CRP（C反应蛋白）、G试验、M试验)]
				Set OrdListDesc=""	//检验医嘱名称
				Set xTestSetDesc="",checkFlg=0,IsCom=0
				For {
					Set xTestSetDesc=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xLabNumID,xTestSetDesc))
					Quit:xTestSetDesc=""
					Set OrdListDesc=OrdListDesc_"+"_xTestSetDesc
					
					Set xID =""
					For {
						Set xID=$o(^DHCHAI.DP.LabVisitTestSetI("IndexVisitNumberTestSet",xLabNumID,xTestSetDesc,xID))
						Quit:xID=""
						Set LabVisitTestData=$g(^DHCHAI.DP.LabVisitTestSetD(xID))
						Continue:LabVisitTestData=""
						Set ComSetCode =$lg(LabVisitTestData,7)		
						Set:ComSetCode'="" IsCom=1			//合管检验医嘱代码
					}
					Continue:'$d(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc))		//排除未对照医嘱
					//对照后检验医嘱
					Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",SCode,xTestSetDesc,""))
					Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjById(TestSetMapID)
					Continue:'$isobject(objTestSetMap)
					Continue:'$isobject(objTestSetMap.BTMapItemDr)
					Continue:'$isobject(objTestSetMap.BTMapItemDr.BTCatDr)
					Set CatDesc=objTestSetMap.BTMapItemDr.BTCatDr.BTDesc
					Continue:(CatDesc'="常规检验")
					//检验医嘱过滤
					Set BTTestSet = objTestSetMap.BTTestSet
					If (ContOELabList'=""){
						Continue:($lf(ContOELabList,BTTestSet)<1)
					}
					If (ExclOELabList'=""){
						Continue:($lf(ExclOELabList,BTTestSet)>0)
					}
					Set TSMapItemDr=objTestSetMap.BTMapItemDr.%Id()
					Set checkFlg =1			
				}
				Continue:checkFlg'=1
				//循环检验报告表
				Set xTestSetDr=""
				For {
					Set xTestSetDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xLabNumID,xTestSetDr))
					Quit:xTestSetDr=""
					
					//最新检验报告
					Set xOrder = $o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xLabNumID,xTestSetDr,""),-1)
					Set xVisitReportDr=0
					For {
						Set xVisitReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitTestSetDrOrder",xLabNumID,xTestSetDr,xOrder,xVisitReportDr))
						Quit:xVisitReportDr=""
						
						Set objVisitReport=##class(DHCHAI.DP.LabVisitReport).GetReportByID(xVisitReportDr)
						Continue:'$IsObject(objVisitReport)
						
						Set Status = objVisitReport.LabStatus
						Set IsActive = objVisitReport.LabIsActive
						Continue:IsActive=0
						
						Set xResultID=""
						For {
							Set xResultID = $o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xVisitReportDr,xResultID))
							Quit:xResultID=""
							
							Set objResult = ##class(DHCHAI.DP.LabVisitRepResult).GetObjById(xResultID)
							Continue:'$isobject(objResult)
							
							Set TestDesc = objResult.LabTestDesc
							Continue:(TestDesc'["白细胞计数")
							Set Result =+objResult.LabResult
							
							If (Result>WbcCntArg){
								Set RetFlag=1
								If SubWBCs'="" {
									Set SubWBCs=SubWBCs_"&#13;"_TestDesc_"->"_objResult.LabResult_"("_Specimen_")"
								} Else {
									Set SubWBCs=TestDesc_"->"_objResult.LabResult_"("_Specimen_")"
								}
							}
						}
					}
				}
			}
		}
		Set ValueList = ValueList_$lb(SubWBCs)
		Set ColNum=ColNum+1
	}
	Set Data=$lb("白细胞计数")_ValueList
	Set ^CacheTemp(repid,ind)=Data_$lb(IRVAEDate)
	Set ind=ind+1
	
	Quit $$$OK
}

ClassMethod QrySequenceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySequenceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySequenceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySequenceExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2022-03-24
/// Description:  VAE筛查科室列表
/// Table：       DHCHAI.DP.PAAdm、 DHCHAI.IR.VAEResult
/// Input：       aTypeFlag : 查询类型（1在院、2出院）
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aHospIDs  : 医院代码 多值"^"分割
///               aViewFlag : 按科室/病区分组（1科室、2病区）
///               aLocID    : 科室
///               aShowType : 展示方式（1：待处理，2：已处理,9:全部）
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.VAEScreeningSrv","QrySuRuleLocList","1","","","","2","","1")
Query QrySuRuleLocList(aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aViewFlag As %String, aLocID As %String = "", aShowType As %String = "") As %Query(ROWSPEC = "LocID:%String,LocDesc:%String,HospID:%String,HospDesc:%String,InPatientCnt:%String,ScreeningCnt:%String,ScreenActCnt:%String,DealTodayCnt:%String") [ SqlProc ]
{
}

ClassMethod QrySuRuleLocListExecute(ByRef qHandle As %Binary, aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aViewFlag As %String, aLocID As %String = "", aShowType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
 	Quit:(aTypeFlag'=1)&((aDateFrom="")||(aDateTo="")) $$$OK
 	
 
 	Kill ^TMP($zn,$j)
	If aTypeFlag=1 {		
		Set xDays=-1
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")
			
			Set xDate=0
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
				Quit:xDate=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xID))
					Quit:xID=""
				
					Set EpisodeID=xID
					Do BuildVAEData
				}
			}
		}
	} ElseIf aTypeFlag=2 {
		//2出院病人
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Quit:(aDateTo-aDateFrom)<0 $$$OK
		
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime="" 
				For {
					Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime))
					Quit:xTime=""
					
					Set xID=0
					For {
						Set xID=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime,xID))
						Quit:xID=""
						
						Set EpisodeID=xID
						Do BuildVAEData
					}
				}
			}
		}
	} 

	Set xHospID=0
	For {
		Set xHospID=$o(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID))
		Quit:xHospID=""
		
		Set xLocID=0
		For {
			Set xLocID=$o(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID))
			Quit:xLocID=""
			
			Set tLoc=$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID))
			Continue:tLoc=""
			Set HospDesc=$listget(tLoc,1)
			Set LocDesc=$listget(tLoc,2)
			Set InPatientCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"InPatientCnt"))  //住院病人
			Set ScreeningCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"ScreeningCnt"))  //待处理
			Set ScreenActCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"ScreenActCnt"))  //已处理
			Set DealTodayCnt=+$g(^TMP($zn,$j,"ScreenLoc-Cnt",xHospID,xLocID,"DealTodayCnt"))  //今日处理病例
			
			//1：待处理，2：已处理,9:全部
			If (aShowType=1){
				Continue:(+ScreeningCnt=+0)&&(+DealTodayCnt=0)
			}
			If (aShowType=2){
				Continue:+ScreenActCnt=+0
			}
			Set Data=$lb(xLocID,LocDesc,xHospID,HospDesc,InPatientCnt,ScreeningCnt,ScreenActCnt,DealTodayCnt)
			Set ^CacheTemp(repid,ind)=Data
 			Set ind=ind+1
		}
	}
 	Kill ^TMP($zn,$j)
 	
	Quit $$$OK
	
BuildVAEData
	Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(EpisodeID))
	Quit:PAAdmData=""
	Set EpisodeIDx=$li(PAAdmData,2)
	
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus=$li(PAAdmData,19)
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院、退院、作废
	
	If aViewFlag=1 {
		Set LocID=$li(PAAdmData,22)
	} Else {
		Set LocID=$li(PAAdmData,23)
		//处理虚拟病区的问题
		Set AdmBedDr=$li(PAAdmData,25)
		If AdmBedDr'=""{
			Set AdmBedData=$g(^DHCHAI.BT.PACBedD(AdmBedDr))
			If AdmBedData'=""{
				Set LocID=$li(AdmBedData,11)
			}
		}
	}
	Quit:LocID=""
	Set AdmLocData=$g(^DHCHAI.BT.LocationD(LocID))
	Quit:(aLocID'="")&&(aLocID'=LocID)
	Set LocDesc=$li(AdmLocData,3)
	Set LocDesc2=$li(AdmLocData,4)
	Set:LocDesc2'="" LocDesc=LocDesc2
	Set IsICU = $li(AdmLocData,10)
	Quit:(IsICU'=1)
	Set HospID=$li(AdmLocData,8)
	Quit:HospID=""
	Set HospData = $g(^DHCHAI.BT.HospitalD(HospID))
	Set HospDesc=$li(HospData,3)
	Set HospDesc2=$li(HospData,4)
	Set:HospDesc2'="" HospDesc=HospDesc2
	Quit:(aHospIDs'="")&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))  //医院过滤
	
	Set ^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID)=$lb(HospDesc,LocDesc)       //科室信息
	Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"InPatientCnt"))      //住院病例
	
	
	Set PendingActInfo=..GetVAEActCnt(EpisodeID)
	Quit:PendingActInfo=""  // 没有触发VAE
	Set PendingFlag = +$p(PendingActInfo,"^",1)   // 待处理标志
	Set ActFlag     = +$p(PendingActInfo,"^",2)   // 已处理标志
   
    If PendingFlag=1 {//待处理
		Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"ScreeningCnt"))	
	}
	If ActFlag=1 {//已处理
		Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"ScreenActCnt"))	
	}
	Set IsDealToday = ..IsDealToday(EpisodeID)
	If IsDealToday=1 { //今日处理病例（包括未处理完）
		Set num=$i(^TMP($zn,$j,"ScreenLoc-Cnt",HospID,LocID,"DealTodayCnt"))
	}
	
	Quit
}

ClassMethod QrySuRuleLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRuleLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRuleLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRuleLocListExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2022-03-25
/// Description:  根据就诊号查找VAE筛查项目
/// Table：       DHCHAI.IR.VAEResult
/// Input：       aEpisodeID : 就诊号
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.VAEScreeningSrv","QrySuRuleResult","1")
Query QrySuRuleResult(aEpisodeID As %String) As %Query(ROWSPEC = "xItemID:%String,VAItmCode:%String,VAItmDesc:%String,TmpVAEDate:%String,xRstID:%String,VAEDate:%String,MonitVAEDate:%String,VAEType:%String,ActStatus:%String,ActStatusDesc:%String,FourteenFlag:%String,PendingFlag:%String,SItmDescs:%String,ExclReason:%String,VAEActDate:%String,ActUserDesc:%String") [ SqlProc ]
{
}

ClassMethod QrySuRuleResultExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:(aEpisodeID="") $$$OK

 	Set objEpisode=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objEpisode) $$$OK
	Set AdmDate=objEpisode.PAAdmDate
	Set DischDate=objEpisode.PADischDate
	Set DateFrom=AdmDate
	Set DateTo=DischDate
	Set:DateTo="" DateTo=+$h 
    //首先获取患者最近确诊的VAE日期
	Set VAEArray = ##Class(%ArrayOfDataTypes).%New()
	Set xItemID=""
   	For {
	   	Set xItemID=$o(^DHCHAI.IR.VAEResultI("IndexEpiMonitItem",aEpisodeID,xItemID))
	   	Quit:xItemID=""
	   	Set objItem=##class(DHCHAI.IR.VAEMonitItem).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
	   	Set xRstID=""
	   	For {
		   	Set xRstID=$o(^DHCHAI.IR.VAEResultI("IndexEpiMonitItem",aEpisodeID,xItemID,xRstID))
		   	Quit:xRstID=""
		   	Set objRst=##class(DHCHAI.IR.VAEResult).GetObjById(xRstID)
			Continue:'$IsObject(objRst)
			Set VAEIsActive  = +objRst.VAEIsActive
			Continue:(VAEIsActive'=1)
			Set MonitVAEDate = objRst.MonitVAEDate
			If (MonitVAEDate'=""){
				Do VAEArray.SetAt(MonitVAEDate,xItemID)
			}
	   	}
   	}
   	
    Set xItemID=""
   	For {
	   	Set xItemID=$o(^DHCHAI.IR.VAEResultI("IndexEpiMonitItem",aEpisodeID,xItemID))
	   	Quit:xItemID=""
	   	Set objItem=##class(DHCHAI.IR.VAEMonitItem).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set VAItmCode  = objItem.VAItmCode
		Set VAItmDesc  = objItem.VAItmDesc
		Set TmpVAEDate = VAEArray.GetAt(xItemID)
	   	Set xRstID=""
	   	For {
		   	Set xRstID=$o(^DHCHAI.IR.VAEResultI("IndexEpiMonitItem",aEpisodeID,xItemID,xRstID))
		   	Quit:xRstID=""
		   	Set objRst=##class(DHCHAI.IR.VAEResult).GetObjById(xRstID)
			Continue:'$IsObject(objRst)
			Set VAEIsActive  = +objRst.VAEIsActive
			Continue:(VAEIsActive'=1)
			Set VAEDate      = objRst.VAEDate
			Set MonitVAEDate = objRst.MonitVAEDate
			Set VAEType      = objRst.VAEType
			Set ActStatus    = objRst.ActStatus  //处置状态 1：确诊 2：排除
			Set ActStatusDesc= $s(ActStatus=1:"确诊",ActStatus=1:"排除",1:"")
			Set FourteenFlag=0,PendingFlag=0
			If (ActStatus=""){ // 说明这条记录未处理
				If (TmpVAEDate'=""){
					If ((TmpVAEDate+14>VAEDate)||(VAEDate<TmpVAEDate)){  // 14天内，不在触发
						Set FourteenFlag=1
					}Else{
						Set PendingFlag=1
					}
				}Else{
					Set PendingFlag=1
				}
			}
			//获取触发项目 多值#分割--DHCHAI.IR.VAESubItem
			Set VAEItemIDs = objRst.VAEItemIDs
			Set SItmDescs=""
			For xSubInd=1:1:$l(VAEItemIDs,"#"){
				Set xSubID=$p(VAEItemIDs,"#",xSubInd)
				Continue:xSubID=""
				Set objSub=##class(DHCHAI.IR.VAESubItem).GetObjById(xSubID)
				Set VASItmDesc = objSub.VASItmDesc  // 项目名称
				Set SItmDescs=SItmDescs_"，"_VASItmDesc
			}
			Set:SItmDescs'="" SItmDescs=$e(SItmDescs,2,$l(SItmDescs))
			Set ExclReason   = objRst.ExclReason
			Set VAEActDate   = objRst.VAEActDate
			Set VAEActUserDr = objRst.VAEActUserDr
			Set ActUser="",ActUserDesc=""
			If $IsObject(VAEActUserDr) {
				Set ActUser     = VAEActUserDr.BTCode
				Set ActUserDesc = VAEActUserDr.BTDesc
			}
			
			Set:VAEType="" VAEType=VAItmCode
			Set:MonitVAEDate="" MonitVAEDate=VAEDate
			Set:MonitVAEDate'="" MonitVAEDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(MonitVAEDate)
			Set:VAEDate'="" VAEDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VAEDate)
			Set:VAEActDate'="" VAEActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(VAEActDate)
			
			Set Data=$lb(xItemID,VAItmCode,VAItmDesc,TmpVAEDate,xRstID,VAEDate,MonitVAEDate,VAEType,ActStatus,ActStatusDesc,FourteenFlag,PendingFlag,SItmDescs,ExclReason,VAEActDate,ActUserDesc)
		
			Set ^CacheTemp(repid,ind)=Data
    		Set ind=ind+1
	   	}
   	}
    
	Quit $$$OK
}

ClassMethod QrySuRuleResultClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRuleResultExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRuleResultFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRuleResultExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2022-03-24
/// Description:  VAE筛查科室患者列表
/// Table：       DHCHAI.DP.PAAdm、 DHCHAI.IR.VAEResult
/// Input：       aTypeFlag : 查询类型（1在院、2出院）
///               aDateFrom : 开始日期
///               aDateTo   : 结束日期
///               aHospIDs  : 医院代码 多值"^"分割
///               aViewFlag : 按科室/病区分组（1科室、2病区）
///               aLocID    : 科室
///               aShowType : 展示方式（1：待处理，2：已处理,9:全部）
/// Return：      返回ROWSPEC 1^^^1|2^2^^1
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.VAEScreeningSrv","QrySuRulePatList","1","","","1|2","2","","1")
Query QrySuRulePatList(aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aViewFlag As %String, aLocID As %String = "", aShowType As %String = "") As %Query(ROWSPEC = "EpisodeID:%String,PapmiNo:%String,PatName:%String,Sex:%String,Age:%String,CurrLocDesc:%String,CurrBed:%String,VisitStatus:%String,InHospDate:%String,InHospLocID:%String,InHospLocDesc:%String,InLocDate:%String,CurrLocID:%String,CurrLocDesc:%String,FromLocID:%String,FromLocDesc:%String,OutHospDate:%String,AdmDocCode:%String,AdmDocDesc:%String,PendingFlag:%String,ActFlag:%String,IsDealToday:%String,ActItemFlag:%String,SuspendDesc:%String,ActStatusCode:%String") [ SqlProc ]
{
}

ClassMethod QrySuRulePatListExecute(ByRef qHandle As %Binary, aTypeFlag As %String, aDateFrom As %String, aDateTo As %String, aHospIDs As %String, aViewFlag As %String, aLocID As %String = "", aShowType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)

 	Quit:(aTypeFlag=2)&((aDateFrom="")||(aDateTo="")) $$$OK
 	
 	Kill ^TMP($zn,$j)
	If aTypeFlag=1 {		
		Set xDays=-1
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")
			
			Set xDate=0
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate))
				Quit:xDate=""
				
				Set xID=""
				For {
					Set xID=$o(^DHCHAI.DP.PAAdmI("IndexAdmDaysDate",xAdmType,xDays,xDate,xID))
					Quit:xID=""
				
					Set EpisodeID=xID
					Do BuildVAEPatData
				}
			}
		}
	} ElseIf aTypeFlag=2 {
		//2出院病人
		Quit:(aDateFrom="")||(aDateTo="") $$$OK
		Quit:(aDateTo-aDateFrom)<0 $$$OK
		
		Set xAdmType=""
		For {
			Set xAdmType=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType))
			Quit:xAdmType=""
			Continue:(xAdmType'="I")
			
			Set xDate=aDateFrom-1
			For {
				Set xDate=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate))
				Quit:xDate=""
				Quit:xDate>aDateTo
				
				Set xTime="" 
				For {
					Set xTime=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime))
					Quit:xTime=""
					
					Set xID=0
					For {
						Set xID=$o(^DHCHAI.DP.PAAdmI("IndexDischDateTime",xAdmType,xDate,xTime,xID))
						Quit:xID=""
						
						Set EpisodeID=xID
						Do BuildVAEPatData
					}
				}
			}
		}
	}
		
 	Kill ^TMP($zn,$j)
 	
	Quit $$$OK
	
BuildVAEPatData
	Set PAAdmData = $g(^DHCHAI.DP.PAAdmD(EpisodeID))
	Quit:PAAdmData=""
	Set EpisodeIDx=$li(PAAdmData,2)
	
	Set SCode = $p(EpisodeIDx,"||",1)
	Set VisitStatus=$li(PAAdmData,19)
	Set VisitStatusInfo=##class(DHCHAI.DP.PhraseMap).GetMapValueByPhrase(SCode,"VisitStatus",VisitStatus)
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",2)
	}
	Quit:(VisitStatus="P")||(VisitStatus="C")||(VisitStatus="U") //预住院、退院、作废
	If VisitStatusInfo'="" {
		Set VisitStatus=$p(VisitStatusInfo,"^",3)
	} Else {
		Set VisitStatus=$s(VisitStatus="A":"在院",VisitStatus="D":"出院",VisitStatus="P":"预住院",VisitStatus="C":"退院",VisitStatus="U":"作废",1:"其他")
	}
	Set LocID=$li(PAAdmData,22)
	Quit:LocID=""
	Set AdmLocData=$g(^DHCHAI.BT.LocationD(LocID))
	Set LocDesc=$li(AdmLocData,3)
	Set LocDesc2=$li(AdmLocData,4)
	Set:LocDesc2'="" LocDesc=LocDesc2
	Set WardID=$li(PAAdmData,23)
	//处理虚拟病区的问题
	Set (CurrBedDr,CurrBed,AdmBedData)=""           //床位
	Set CurrBedDr=$li(PAAdmData,25)
	If CurrBedDr'=""{
		Set AdmBedData=$g(^DHCHAI.BT.PACBedD(CurrBedDr))
		If AdmBedData'=""{
			Set WardID=$li(AdmBedData,11)
		}
	}
	Quit:WardID=""
	Set AdmWardData=$g(^DHCHAI.BT.LocationD(WardID))
	Set WardDesc=$li(AdmWardData,3)
	Set WardDesc2=$li(AdmWardData,4)
	Set:WardDesc2'="" WardDesc=WardDesc2
	Quit:(aLocID'="")&&(aLocID'=LocID)&(aLocID'=WardID)  //过滤科室、病区
	
	If aViewFlag=1 {
		Set ViewType="E"  //按科室显示
		Set CurrLocID=LocID
		Set HospID=$li(AdmLocData,8)
		Quit:HospID=""
	} Else {
		Set ViewType="W"  //按按病区显示
		Set CurrLocID=WardID
		Set HospID=$li(AdmWardData,8)
		Quit:HospID=""
	}
	Set HospData = $g(^DHCHAI.BT.HospitalD(HospID))
	Set HospDesc=$li(HospData,3)
	Set HospDesc2=$li(HospData,4)
	Set:HospDesc2'="" HospDesc=HospDesc2
	Quit:(aHospIDs'="")&(("|"_aHospIDs_"|")'[("|"_HospID_"|"))  //医院过滤
    
	Set PapmiNo=$li(PAAdmData,4)     //登记号
	Set MrNo=$li(PAAdmData,5)        //病案号
	Set PatName=$li(PAAdmData,6)     //姓名
	Set Sex=$li(PAAdmData,7)             //性别
	Set Sex=$s(Sex="M":"男",Sex="F":"女",1:"其他")
	Set Birthday=$li(PAAdmData,9)   //出生日期
	Set Age=$li(PAAdmData,37)             //年龄
	Set:Birthday'="" Birthday = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(Birthday)
	Set AdmDate=$li(PAAdmData,20)     //就诊日期
	Set:AdmDate'="" AdmDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(AdmDate)
	Set AdmTime=$li(PAAdmData,21)     //就诊时间
	Set:AdmTime'="" AdmTime=$zt(AdmTime)
	Set DischDate=$li(PAAdmData,26) //出院日期
	Set:DischDate'="" DischDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(DischDate)
	Set OutHospDate = ""
	If DischDate'=""{
		Set OutHospDate = DischDate
	}
	Set DischTime=$li(PAAdmData,27) //出院时间
	Set:DischTime'="" DischTime=$zt(DischTime)
	Set:AdmBedData'="" CurrBed=$li(AdmBedData,3)
	Set:CurrBed'["床" CurrBed=CurrBed_"床"
	
	Set PAAdmDoc=$li(PAAdmData,39)
	Set AdmDocCode=$p(PAAdmDoc,"|",2)  //医生工号
	Set AdmDocDesc=$p(PAAdmDoc,"|",3)  //医生姓名
	If aViewFlag=1 {
		Set ViewType="E"  //按科室显示
	} Else {
		Set ViewType="W"
	}
	//入院日期、入院科室、入科日期、当前科室、入科来源信息
	Set TransLocInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransLocInfo(EpisodeID,ViewType)
	Quit:TransLocInfo=""
	Set InHospDate=$p(TransLocInfo,"^",1)
	Set InHospLocID=$p(TransLocInfo,"^",2)
	Set InHospLocDesc=$p(TransLocInfo,"^",3)
	Set InLocDate=$p(TransLocInfo,"^",4)
	Set CurrLocID=$p(TransLocInfo,"^",5)
	Set CurrLocDesc=$p(TransLocInfo,"^",6)
	Set FromLocID=$p(TransLocInfo,"^",7)
	Set FromLocDesc=$p(TransLocInfo,"^",8)
	
	Set:InHospDate'="" InHospDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InHospDate)
	Set:InLocDate'="" InLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InLocDate)
	
	Set PendingActInfo=..GetVAEActCnt(EpisodeID)
	Quit:PendingActInfo=""  // 没有触发VAE
	Set PendingFlag = +$p(PendingActInfo,"^",1)     // 待处理标志
	Set ActFlag     = +$p(PendingActInfo,"^",2)     // 已处理标志
	Set ActItemFlag = +$p(PendingActInfo,"^",3)     // 有触发VAE标志
	Set ActStatusCode = +$p(PendingActInfo,"^",4)   // 患者最终处置状态1确诊 2排除，有一个项目确诊都算确诊
	Set IsDealToday = ..IsDealToday(EpisodeID)
    If (aShowType=1){
		Quit:((PendingFlag'=1)&&(IsDealToday'=1))
	}
	If (aShowType=2){
		Quit:(ActFlag'=1)
	}
	Set SuspendDesc = $s(PendingFlag=1:"待处理",ActFlag=1:"已处理",1:"")
	
 	//就诊号、登记号/病案号、姓名、性别、年龄、当前科室、床号、入院日期、入院科室、入科日期、入科来源、需关注病例、出院日期
 	Set Data=$lb(EpisodeID,PapmiNo,PatName,Sex,Age,CurrLocDesc,CurrBed,VisitStatus,InHospDate,InHospLocID,InHospLocDesc,InLocDate,CurrLocID,CurrLocDesc,FromLocID,FromLocDesc,OutHospDate,AdmDocCode,AdmDocDesc,PendingFlag,ActFlag,IsDealToday,ActItemFlag,SuspendDesc,ActStatusCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	
	Quit
}

ClassMethod QrySuRulePatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySuRulePatListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySuRulePatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySuRulePatListExecute ]
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

/// Creator：     zhoubo
/// CreatDate：   2022-03-25
/// Description:  获取患者是否今日处理
/// Table：       DHCHAI.IR.VAEResult
/// Input：       aEpisodeID:就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.VAEScreeningSrv).IsDealToday("27")
ClassMethod IsDealToday(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	
	Set IsToday =0
	
	Set xItemID=""
   	For {
	   	Set xItemID=$o(^DHCHAI.IR.VAEResultI("IndexEpiMonitItem",aEpisodeID,xItemID))
	   	Quit:xItemID=""
	   	Quit:IsToday=1
	   	Set objItem=##class(DHCHAI.IR.VAEMonitItem).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
	   	Set xRstID=""
	   	For {
		   	Set xRstID=$o(^DHCHAI.IR.VAEResultI("IndexEpiMonitItem",aEpisodeID,xItemID,xRstID))
		   	Quit:xRstID=""
		   	Set objRst=##class(DHCHAI.IR.VAEResult).GetObjById(xRstID)
			Continue:'$IsObject(objRst)
			Set VAEIsActive  = +objRst.VAEIsActive
			Continue:(VAEIsActive'=1)
			Set VAEActDate = objRst.VAEActDate
			Set IsToday =1
			Quit:VAEActDate=+$h
			Set IsToday =0
	   	}
   	}
   	Set return = IsToday
   	Quit return
}

/// Creator：     zhoubo
/// CreatDate：   2022-03-24
/// Description:  获取患者VAE处置状态
/// Table：       DHCHAI.IR.VAEResult
/// Input：       aEpisodeID:就诊号
/// Return：      返回String
/// w ##class(DHCHAI.IRS.VAEScreeningSrv).GetVAEActCnt("1")
ClassMethod GetVAEActCnt(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set return=0
	Quit:(aEpisodeID="") return
	//首先获取患者最近确诊的VAE日期
	Set VAEArray = ##Class(%ArrayOfDataTypes).%New()
	Set xItemID=""
   	For {
	   	Set xItemID=$o(^DHCHAI.IR.VAEResultI("IndexEpiMonitItem",aEpisodeID,xItemID))
	   	Quit:xItemID=""
	   	Set objItem=##class(DHCHAI.IR.VAEMonitItem).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
	   	Set xRstID=""
	   	For {
		   	Set xRstID=$o(^DHCHAI.IR.VAEResultI("IndexEpiMonitItem",aEpisodeID,xItemID,xRstID))
		   	Quit:xRstID=""
		   	Set objRst=##class(DHCHAI.IR.VAEResult).GetObjById(xRstID)
			Continue:'$IsObject(objRst)
			Set VAEIsActive  = +objRst.VAEIsActive
			Continue:(VAEIsActive'=1)
			Set MonitVAEDate = objRst.MonitVAEDate
			If (MonitVAEDate'=""){
				Do VAEArray.SetAt(MonitVAEDate,xItemID)
			}
	   	}
   	}
   	// PendingFlag：待处理 ActFlag：已处理  ActItemFlag:有触发VAE ActStatusCode:患者最终处置状态1确诊 2排除，有一个项目确诊都算确诊
   	Set PendingFlag=0,ActFlag=0,ActItemFlag=0,ActStatusCode="",ActStatusCode1=""
	Set xItemID=""
   	For {
	   	Set xItemID=$o(^DHCHAI.IR.VAEResultI("IndexEpiMonitItem",aEpisodeID,xItemID))
	   	Quit:xItemID=""
	   	Set objItem=##class(DHCHAI.IR.VAEMonitItem).GetObjById(xItemID)
		Continue:'$IsObject(objItem)
		Set VAItmCode  = objItem.VAItmCode
		Set VAItmDesc  = objItem.VAItmDesc
		Set TmpVAEDate = VAEArray.GetAt(xItemID)
	   	Set xRstID=""
	   	For {
		   	Set xRstID=$o(^DHCHAI.IR.VAEResultI("IndexEpiMonitItem",aEpisodeID,xItemID,xRstID))
		   	Quit:xRstID=""
		   	Set objRst=##class(DHCHAI.IR.VAEResult).GetObjById(xRstID)
			Continue:'$IsObject(objRst)
			Set VAEIsActive  = +objRst.VAEIsActive
			Continue:(VAEIsActive'=1)
			Set VAEDate      = objRst.VAEDate
			Set MonitVAEDate = objRst.MonitVAEDate
			Set ActItemFlag  = 1
			If (MonitVAEDate'=""){
				Set VAEDate = MonitVAEDate
			}
			Set ActStatus = objRst.ActStatus  //处置状态 1：确诊 2：排除
			Set:ActStatus'="" ActFlag=1
			If (ActStatus=1){
				Set ActStatusCode=1
			}ElseIf(ActStatus=2){
				Set ActStatusCode1=1   //说明有排除
			}
			Continue:ActStatus'=""
			
			If (TmpVAEDate'=""){
				If (TmpVAEDate+14>VAEDate){  // 14天内，不在触发
					
				}Else{
					Set PendingFlag=1
				}
			}Else{
				Set PendingFlag=1
			}
			
	   	}
   	}
   	If (ActStatusCode'=1)&&(ActStatusCode1=1){
	   Set ActStatusCode=2
	}
	Set:PendingFlag=1 ActFlag=0
	
	Set return=PendingFlag_"^"_ActFlag_"^"_ActItemFlag_"^"_ActStatusCode
	
	Quit return
}

}
