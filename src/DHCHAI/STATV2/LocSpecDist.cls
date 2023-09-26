/// 名称: DHCHAI.STATV2.LocSpecDist
/// 描述: 科室标本分布统计
/// 编写者: zhoubo
/// 编写日期: 2021-04-02
Class DHCHAI.STATV2.LocSpecDist Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ShenC
/// CreatDate：   2023-04-13
/// Description:  科室标本分布统计
/// Table：       DHCHAI.IR.CCResult
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1:送检日期,2:报告日期
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aSpecID    : 标本字典ID
///               aStatNum   : 统计数量
///               aStatUnit  : 统计单位 1：病区2：科室
///               aLocDesc   : 科室名称(Desc)
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.LocSpecDist","QryLocSpecDist","1","1","2022-01-01","2022-01-31","","5","1","")
Query QryLocSpecDist(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aStatNum As %String, aStatUnit As %String, aLocDesc As %String = "", aLocIDs As %Text = "") As %Query(ROWSPEC = "SortSum:%String,xLocDesc:%String,xSpec:%String,SpecNum:%Integer,SpecNumSum:%Integer,SpecYNum:%Integer,SpecYNumSum:%Integer,SpecNNum:%Integer,SpecNNumSum:%Integer") [ SqlProc ]
{
}

ClassMethod QryLocSpecDistExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aStatNum As %String, aStatUnit As %String, aLocDesc As %String = "", aLocIDs As %Text = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//转换院区"1|3"->"$lb("1","3")"
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
    //转换日期
    Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
	//统计前aStatNum标本(默认5)
 	Set:aStatNum="" aStatNum=5
   	//统计维度(病区W|科室E)
    Set aLocType="W"
    Set:aStatUnit'="1" aLocType="E"
    Set LocCount=$l(aLocIDs,",")  //科室、病区入参个数
    
    Set NIndex="QryLocSpecDist"
	Kill ^TMP($zn,$j,NIndex)
	
	//日期类型为送检日期
	If (aDateType=1){
		//按'接受日期'循环日期范围内检验标本表 
		For xDate = aDateFrom:1:aDateTo{
			Set xTime = ""
			For {
				Set xTime = $o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime"," LIS01",xDate,xTime))
				Quit:xTime=""
				
				Set xVisitNumberDr=""
				For {
					Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime"," LIS01",xDate,xTime,xVisitNumberDr))
					Quit:xVisitNumberDr=""
				
					//检验标本表	
					Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))	
					Continue:VisitData=""
					//过滤无效数据
					Set LabIsActive = $li(VisitData,18)
					Continue:LabIsActive'=1
				
					Set LabSpecimen = $lg(VisitData,6)			//标本原始记录
					Set LabSCode    = $lg(VisitData,14)			//子系统代码
					//过滤未对照标本
					Set SpecMapID   = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",LabSCode,LabSpecimen,0))
					Continue:SpecMapID=""
					Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpecMapID))
					Continue:SpecMapData=""
					Set BTMapItemDr = $lg(SpecMapData,3)		
					Continue:BTMapItemDr=""
					//过滤标本
					Continue:(aSpecID'="")&&(aSpecID'=BTMapItemDr)
					Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(BTMapItemDr))	
					Set SpecDesc = $lg(SpecData,3)				//标本标准名
					//过滤院区
					Set AdmID = $lg(VisitData,2)		//患者就诊号
					Set CollDate = $lg(VisitData,8)		//采集日期
					Set CollTime = $lg(VisitData,9)		//采集时间
					Set RecDate = $lg(VisitData,11)		//接收日期
					Set RecTime = $lg(VisitData,12)		//接收日期
					Set ActDate=CollDate,ActTime=CollTime
					If (ActDate=""){					//送检日期优先取采集日期,采集日期为空取报告日期
						Set ActDate=RecDate
						Set ActTime=RecTime
					}
					Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,ActDate,ActTime)
					Set ActLocID = $p(TransInfo,"^",1)		//送检科室ID
					Set ActWardID = $p(TransInfo,"^",2)		//送检病区ID
					Continue:(ActLocID="")||(ActWardID="")
					If (aLocType="W"){
						Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActWardID))
						Quit:(aLocIDs'="")&((","_aLocIDs_",")'[(","_ActWardID_","))
					}
					else{
						Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActLocID))
						Quit:(aLocIDs'="")&((","_aLocIDs_",")'[(","_ActLocID_","))
					}
					Set HospID = $lg(ActLocData,8)			//送检院区
					Set LocDesc  = $lg(ActLocData,3)		//送检科室(病区)
					Set LocDesc2 = $lg(ActLocData,4)
					Set:LocDesc2'="" LocDesc=LocDesc2
					Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1) 	
				
					//循环标本对应检验报告+检验结果
					Set xRepDate=""
					For {
						Set xRepDate=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitUpdateDate",xVisitNumberDr,xRepDate))
						Quit:xRepDate=""
						
						Set xRepID=0
						For {
							Set xRepID=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitUpdateDate",xVisitNumberDr,xRepDate,xRepID))
							Quit:xRepID=""
						
							//检验报告表
							Set ReportData=$g(^DHCHAI.DP.LabVisitReportD(xRepID))		
							Continue:ReportData=""
							//过滤无效数据
							Set IsActive=$lg(ReportData,18)
							Continue:IsActive'=1
							
							Set CheckFlg =0  							//'微生物送检'标志
							
							Set LabTestSetDr=$lg(ReportData,13)		
							Continue:LabTestSetDr=""
							Set TestSetDesc=$lg($g(^DHCHAI.DP.LabVisitTestSetD(LabTestSetDr)),3)		//检验医嘱
							Set TestSetDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetDesc)  	//去掉特殊字符
							Continue:TestSetDesc=""
							//取对照后检验医嘱
							Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",LabSCode,TestSetDesc,0))
							Continue:TestSetMapID=""
							Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
							Continue:TestSetMapData=""
							Set TestSet = $lg(TestSetMapData,4)			//对照后检验医嘱
							If (TestSet'="") {   
								Set MapTSDesc=$lg($g(^DHCHAI.DP.LabTestSetD(TestSet)),3)
								Set BTCatDr=$lg($g(^DHCHAI.DP.LabTestSetD(TestSet)),4)
								If (BTCatDr'=""){
									Set MapTSCatDesc=$lg($g(^DHCHAI.DP.LabTestSetCatD(BTCatDr)),3)
									Set:(MapTSCatDesc="微生物送检") CheckFlg=1							//微生物送检
								}
							}
							//过滤非微生物送检
							Continue:CheckFlg'=1
							
							//获取检验结果(细菌名称)BacDescList
							Set BacDescList=""
							Set xRstID=""
							For{
								Set xRstID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xRepID,xRstID))
								Quit:xRstID=""
								
								//检验结果表
								Set RstData=$g(^DHCHAI.DP.LabVisitRepResultD(xRstID))
								Continue:RstData=""
								//过滤非细菌类型结果
								Set RstFormat=$lg(RstData,5)		//结果类型
								Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(LabSCode,"LABRstFormat",RstFormat)
								Continue:MapRstFormat'="M"
								
								Set Bacteria=$lg(RstData,6)			//原始细菌
								Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
								Continue:Bacteria=""
								
								Set BacDesc=""						//标准细菌名
								Set MapItemDr=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria","LIS01",Bacteria,""))
								If MapItemDr'="" {
									Set BactMapData=$g(^DHCHAI.DP.LabBactMapD(MapItemDr))
									If BactMapData'=""{
										Set IsActive = $li(BactMapData,7)
										Continue:IsActive'=1
										Set BacID=$li(BactMapData,3)
										If (BacID'=""){
											Set LabBacteriaData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
											Set:LabBacteriaData'="" BacDesc=$li(LabBacteriaData,3)	//细菌标准名
										}
									}
								}
								Continue:BacDesc="" 			// 过滤未对照细菌
								Set BacDescList=BacDescList_","_BacDesc
							}
							
							Set num=$i(^TMP($zn,$j,NIndex,"SpecStat","A全院"))		//全院标本总数
							Set num=$i(^TMP($zn,$j,NIndex,"SpecStat",LocDesc))		//各科室标本总数
				
							Set num=$i(^TMP($zn,$j,NIndex,"SpecStat","A全院",LabSpecimen))	//全院各标本数目
							Set num=$i(^TMP($zn,$j,NIndex,"SpecStat",LocDesc,LabSpecimen))	//各科室各标本总数
							
							//阳性标本数
							If (BacDescList'=""){
								Set num=$i(^TMP($zn,$j,NIndex,"SpecStatY","A全院"))					//全院标本总数[阳]
								Set num=$i(^TMP($zn,$j,NIndex,"SpecStatY",LocDesc))					//各科室标本总数[阳]
								
								Set num=$i(^TMP($zn,$j,NIndex,"SpecStatY","A全院",LabSpecimen))		//全院各标本总数[阳性]
								Set num=$i(^TMP($zn,$j,NIndex,"SpecStatY",LocDesc,LabSpecimen)) 	//各科室各标本总数[阳性]
							}
							//阴性标本数
							else{
								Set num=$i(^TMP($zn,$j,NIndex,"SpecStatN","A全院"))					//全院标本总数[阴]
								Set num=$i(^TMP($zn,$j,NIndex,"SpecStatN",LocDesc))					//各科室标本总数[阴]
								
								Set num=$i(^TMP($zn,$j,NIndex,"SpecStatN","A全院",LabSpecimen))		//全院各标本总数[阴性]
								Set num=$i(^TMP($zn,$j,NIndex,"SpecStatN",LocDesc,LabSpecimen)) 	//各科室各标本总数[阴性]
							}
						}
					}
				}
			}
    	}
	}
	//日期类型为报告日期
	else{
		//按'审核日期'循环日期范围内检验报告表 
		For xDate = aDateFrom:1:aDateTo{
			Set xTime=""
			For{
				Set xTime=$o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime))
				Quit:xTime=""

				Set xRepID=""
				For{
					Set xRepID=$o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime,xRepID))
					Quit:xRepID=""
					
					//检验报告表
					Set ReportData=$g(^DHCHAI.DP.LabVisitReportD(xRepID))		
					Continue:ReportData=""
					//过滤无效数据
					Set IsActive=$lg(ReportData,18)
					Continue:IsActive'=1
					
					//'报告'关联'标本'
					Set VisitNumberDr=$lg(ReportData,2)
					//检验标本表	
					Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(VisitNumberDr))	
					Continue:VisitData=""
					//过滤标本无效数据
					Set LabIsActive = $li(VisitData,18)
					Continue:LabIsActive'=1
					//过滤院区
					Set AdmID = $lg(VisitData,2)			//患者就诊号
					Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,xDate,xTime)
					Set RepLocID = $p(TransInfo,"^",1)		//报告科室ID
					Set RepWardID = $p(TransInfo,"^",2)		//报告病区ID
					Continue:(RepLocID="")||(RepWardID="")
					If (aLocType="W"){
						Set RepLocData  = $g(^DHCHAI.BT.LocationD(RepWardID))
						Quit:(aLocIDs'="")&((","_aLocIDs_",")'[(","_ActWardID_","))
					}
					else{
						Set RepLocData  = $g(^DHCHAI.BT.LocationD(RepLocID))
						Quit:(aLocIDs'="")&((","_aLocIDs_",")'[(","_ActLocID_","))
					}
					Set HospID = $lg(RepLocData,8)			//报告院区
					Set LocDesc  = $lg(RepLocData,3)		//送检科室(病区)
					Set LocDesc2 = $lg(RepLocData,4)
					Set:LocDesc2'="" LocDesc=LocDesc2
					Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1) 
					
					//过滤未对照标本
					Set LabSpecimen = $lg(VisitData,6)			//标本原始记录
					Set LabSCode    = $lg(VisitData,14)			//子系统代码
					Set SpecMapID   = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",LabSCode,LabSpecimen,0))
					Continue:SpecMapID=""
					Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpecMapID))
					Continue:SpecMapData=""
					Set BTMapItemDr = $lg(SpecMapData,3)		
					Continue:BTMapItemDr=""
					//过滤标本
					Continue:(aSpecID'="")&&(aSpecID'=BTMapItemDr)
					Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(BTMapItemDr))	
					Set SpecDesc = $lg(SpecData,3)				//标本标准名
					
					Set CheckFlg =0  							//'微生物送检'标志
					Set LabTestSetDr=$lg(ReportData,13)		
					Continue:LabTestSetDr=""
					Set TestSetDesc=$lg($g(^DHCHAI.DP.LabVisitTestSetD(LabTestSetDr)),3)		//检验医嘱
					Set TestSetDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetDesc)  	//去掉特殊字符
					Continue:TestSetDesc=""
					//取对照后检验医嘱
					Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",LabSCode,TestSetDesc,0))
					Continue:TestSetMapID=""
					Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
					Continue:TestSetMapData=""
					Set TestSet = $lg(TestSetMapData,4)			//对照后检验医嘱
					If (TestSet'="") {   
						Set MapTSDesc=$lg($g(^DHCHAI.DP.LabTestSetD(TestSet)),3)
						Set BTCatDr=$lg($g(^DHCHAI.DP.LabTestSetD(TestSet)),4)
						If (BTCatDr'=""){
							Set MapTSCatDesc=$lg($g(^DHCHAI.DP.LabTestSetCatD(BTCatDr)),3)
							Set:(MapTSCatDesc="微生物送检") CheckFlg=1							//微生物送检
						}
					}
					//过滤非微生物送检
					Continue:CheckFlg'=1
							
					//获取检验结果(细菌名称)BacDescList
					Set BacDescList=""
					Set xRstID=""
					For{
						Set xRstID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xRepID,xRstID))
						Quit:xRstID=""
								
						//检验结果表
						Set RstData=$g(^DHCHAI.DP.LabVisitRepResultD(xRstID))
						Continue:RstData=""
						//过滤非细菌类型结果
						Set RstFormat=$lg(RstData,5)		//结果类型
						Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(LabSCode,"LABRstFormat",RstFormat)
						Continue:MapRstFormat'="M"
								
						Set Bacteria=$lg(RstData,6)			//原始细菌
						Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
						Continue:Bacteria=""
								
						Set BacDesc=""						//标准细菌名
						Set MapItemDr=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria","LIS01",Bacteria,""))
						If MapItemDr'="" {
							Set BactMapData=$g(^DHCHAI.DP.LabBactMapD(MapItemDr))
							If BactMapData'=""{
								Set IsActive = $li(BactMapData,7)
								Continue:IsActive'=1
								Set BacID=$li(BactMapData,3)
								If (BacID'=""){
									Set LabBacteriaData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
									Set:LabBacteriaData'="" BacDesc=$li(LabBacteriaData,3)	//细菌标准名
								}
							}
						}
						Continue:BacDesc="" 			// 过滤未对照细菌
						Set BacDescList=BacDescList_","_BacDesc
					}
							
					Set num=$i(^TMP($zn,$j,NIndex,"SpecStat","A全院"))		//全院标本总数
					Set num=$i(^TMP($zn,$j,NIndex,"SpecStat",LocDesc))		//各科室标本总数
				
					Set num=$i(^TMP($zn,$j,NIndex,"SpecStat","A全院",LabSpecimen))	//全院各标本数目
					Set num=$i(^TMP($zn,$j,NIndex,"SpecStat",LocDesc,LabSpecimen))	//各科室各标本总数
							
					//阳性标本数
					If (BacDescList'=""){
						Set num=$i(^TMP($zn,$j,NIndex,"SpecStatY","A全院"))					//全院标本总数[阳]
						Set num=$i(^TMP($zn,$j,NIndex,"SpecStatY",LocDesc))					//各科室标本总数[阳]
								
						Set num=$i(^TMP($zn,$j,NIndex,"SpecStatY","A全院",LabSpecimen))		//全院各标本总数[阳性]
						Set num=$i(^TMP($zn,$j,NIndex,"SpecStatY",LocDesc,LabSpecimen)) 	//各科室各标本总数[阳性]
					}
					//阴性标本数
					else{
						Set num=$i(^TMP($zn,$j,NIndex,"SpecStatN","A全院"))					//全院标本总数[阴]
						Set num=$i(^TMP($zn,$j,NIndex,"SpecStatN",LocDesc))					//各科室标本总数[阴]
								
						Set num=$i(^TMP($zn,$j,NIndex,"SpecStatN","A全院",LabSpecimen))		//全院各标本总数[阴性]
						Set num=$i(^TMP($zn,$j,NIndex,"SpecStatN",LocDesc,LabSpecimen)) 	//各科室各标本总数[阴性]
					}
				}
			}
		}
	}
	
	// 阳性标本数排序
	Set xLocDesc=""
	For {
		Set xLocDesc=$o(^TMP($zn,$j,NIndex,"SpecStat",xLocDesc))
		Quit:xLocDesc=""
		
		Set xSpec=""
		For {
			Set xSpec=$o(^TMP($zn,$j,NIndex,"SpecStat",xLocDesc,xSpec))
			Quit:xSpec=""
			
			Set SpecYNum    = +$g(^TMP($zn,$j,NIndex,"SpecStatY",xLocDesc,xSpec))	//科室各标本数量[阳]
			Set SpecYNumSum = +$g(^TMP($zn,$j,NIndex,"SpecStatY",xLocDesc))			//科室标本数量[阳]
			Set SpecNNum    = +$g(^TMP($zn,$j,NIndex,"SpecStatN",xLocDesc,xSpec))	//科室各标本数量[阴]
			Set SpecNNumSum = +$g(^TMP($zn,$j,NIndex,"SpecStatN",xLocDesc))			//科室标本数量[阴]
			Set SpecNum    = +$g(^TMP($zn,$j,NIndex,"SpecStat",xLocDesc,xSpec))		//科室各标本数量
			Set SpecNumSum = +$g(^TMP($zn,$j,NIndex,"SpecStat",xLocDesc))			//科室标本数量
			
			Set tmpLocDesc  = xLocDesc
			Set:xLocDesc="A全院" tmpLocDesc="全院"
			Set:(xLocDesc="A全院")&&(aLocIDs'="") tmpLocDesc="全部"
			
			Set Data = $lb(tmpLocDesc,xSpec,SpecNum,SpecNumSum,SpecYNum,SpecYNumSum,SpecNNum,SpecNNumSum)
			
			Set ^TMP($zn,$j,NIndex,"BactNum",xLocDesc,SpecYNum,xSpec)=Data
		}
	}
	// 输出
	Set SortSum=0
	Set xLocDesc=""
	For {
		Set xLocDesc=$o(^TMP($zn,$j,NIndex,"BactNum",xLocDesc))
		Quit:xLocDesc=""
		
		Set Count=0
		Set SortSum=SortSum+1
		Set (tLocDesc,SpecDesc,OtherSpecNum,SpecNumSum,OtherSpecYNum,SpecYNumSum,OtherSpecNNum,SpecNNumSum)=""
		Set xSpecNum=""
		For {
			Set xSpecNum=$o(^TMP($zn,$j,NIndex,"BactNum",xLocDesc,xSpecNum),-1)
			Quit:xSpecNum=""
            
			Set xSpecimen=""
			For {
				Set xSpecimen=$o(^TMP($zn,$j,NIndex,"BactNum",xLocDesc,xSpecNum,xSpecimen))
				Quit:xSpecimen=""
				
				Set Data = $g(^TMP($zn,$j,NIndex,"BactNum",xLocDesc,xSpecNum,xSpecimen))
				Set Count=Count+1
				
				//超过'aStatNum'归类到其他
                if Count>aStatNum {
                    Set tLocDesc=$lg(Data,1)				//科室名称
                    Set SpecDesc=SpecDesc_$lg(Data,2)_","	//标本名称
                    
                    Set SpecSum=$lg(Data,3)					//科室各标本数量
                    Set OtherSpecNum=OtherSpecNum+SpecSum	//科室其他标本数量
                    Set SpecNumSum=$lg(Data,4)				//科室标本总数
                    
                    Set SpecYNum=+$lg(Data,5)					//科室各标本数量[阳]			
                    Set OtherSpecYNum=OtherSpecYNum+SpecYNum	//科室其他标本数量[阳]			
                    Set SpecYNumSum=+$lg(Data,6)				//科室标本总数[阳]
                    
                    Set SpecNNum=+$lg(Data,7)					//科室各标本数量[阴]	
                    Set OtherSpecNNum=OtherSpecNNum+SpecNNum	//科室其他标本数量[阴]	
                    Set SpecNNumSum=+$lg(Data,6)				//科室标本总数[阴]
                    	
                    continue
                }
				Set ^CacheTemp(repid,ind)=$lb(SortSum)_Data
				Set ind=ind+1
			}
        }
        if OtherSpecNum>0 {
             Set SpecDesc=$e(SpecDesc,1,*-1)
             Set ^CacheTemp(repid,ind)=$lb(SortSum)_$lb(tLocDesc,"其他,"_SpecDesc,OtherSpecNum,SpecNumSum,OtherSpecYNum,SpecYNumSum,OtherSpecNNum,SpecNNumSum)
             Set ind=ind+1
		}
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryLocSpecDistClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocSpecDistExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocSpecDistFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocSpecDistExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2023-04-14
/// Description:  科室标本分布统计数据明细
/// Table：       DHCHAI.DP.LabVisitReport
/// Input:        aHospIDs   : 多个医院用"|"连接
///               aDateType  : 日期类型 1:送检日期,2:报告日期
/// 			  aDateFrom  ：开始日期
/// 			  aDateTo    : 结束日期
///               aSpecID    : 标本字典ID
///               aStatNum   : 统计数量
///               aStatUnit  : 统计单位 1：病区2：科室
///               aLocDesc   : 科室名称(Desc)
///               aSpecDesc  : 标本名称(Desc)
///               aYSpecFlag : 阳性标本标示 2：阴性标本数
/// do ##class(%Library.ResultSet).RunQuery("DHCHAI.STATV2.LocSpecDist","QryLocSpecDistDtl","1|2|3","1","2022-01-01","2022-01-31","","5","1","ICU","","1")
Query QryLocSpecDistDtl(aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aStatNum As %String, aStatUnit As %String, aLocDesc As %String, aSpecDesc As %String, aYSpecFlag As %String) As %Query(ROWSPEC = "DimensDesc:%String,AdmTimes:%String,EpisodeID:%Integer,PapmiNo:%String,MrNo:%String,PatName:%String,Sex:%String,Age:%String,AdmType:%String,VisitStatus:%String,AdmDateTime:%String,AdmLocDesc:%String,AdmWardDesc:%String,AdmRoom:%String,AdmBed:%String,DischDateTime:%String,DishLocDesc:%String,DishWardDesc:%String,TransID:%String,GroupID:%String,GroupDesc:%String,LocID:%String,TransLocDesc:%String,TransDateTime:%String,OutLocDateTime:%String,ResID:%String,LabEpisodeNo:%String,LabTestSet:%String,ActDateTime:%String,RepDateTime:%String,MRBDesc:%String,SpeDesc:%String,BacDesc:%String,InfType:%String") [ SqlProc ]
{
}

ClassMethod QryLocSpecDistDtlExecute(ByRef qHandle As %Binary, aHospIDs As %String, aDateType As %String, aDateFrom As %String, aDateTo As %String, aSpecID As %String, aStatNum As %String, aStatUnit As %String, aLocDesc As %String, aSpecDesc As %String, aYSpecFlag As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//转换院区"1|3"->"$lb("1","3")"
    Set aHospIDs=##class(DHCHAI.Utils.CommonSrv).ListFromString(aHospIDs,"|")
	//转换日期
   	Quit:(aDateFrom="")||(aDateTo="") $$$OK
    Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) $$$OK
 	//统计前aStatNum标本(默认5)
 	Set:aStatNum="" aStatNum=5
    //统计维度(病区W|科室E)
    Set aLocType="W"
    Set:aStatUnit'="1" aLocType="E"
    //标本名称
    Set aSpecDesc=$replace(aSpecDesc,"其他,","")
    Set listSpec=$listfromstring(aSpecDesc,",")			//转换"1|3"->"$lb("1","3")"
   	//科室名称
    Set:aLocDesc="全院" aLocDesc=""
    Set:aLocDesc="全部" aLocDesc=""
    
    Set NIndex="QryLocSpecDistDtl"
	Kill ^TMP($zn,$j,NIndex)
	
	//日期类型为送检日期
	If (aDateType=1){
		//按'接受日期'循环日期范围内检验标本表 
	    For xDate = aDateFrom:1:aDateTo{
			Set xTime = ""
			For {
				Set xTime = $o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime"," LIS01",xDate,xTime))
				Quit:xTime=""
				Set xVisitNumberDr=""
				For {
					Set xVisitNumberDr=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime"," LIS01",xDate,xTime,xVisitNumberDr))
					Quit:xVisitNumberDr=""
					
					//检验标本表	
					Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(xVisitNumberDr))
					Continue:VisitData=""
					//过滤无效数据
					Set LabIsActive = $li(VisitData,18)
					Continue:LabIsActive'=1
					
					Set LabSpecimen = $lg(VisitData,6)		//标本原始记录
					Set LabSCode    = $lg(VisitData,14)		//子系统代码
					//过滤未对照标本
					Set SpecMapID   = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",LabSCode,LabSpecimen,0))
					Continue:SpecMapID=""
					Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpecMapID))
					Continue:SpecMapData=""
					Set BTMapItemDr = $lg(SpecMapData,3)
					Continue:BTMapItemDr=""   				
					//过滤标本ID
					Continue:(aSpecID'="")&&(aSpecID'=BTMapItemDr)
					Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(BTMapItemDr))	
					Set SpecDesc = $lg(SpecData,3)				//标本标准名
					//过滤标本Desc
					Continue:($ll(listSpec)>0)&&'($lf(listSpec,SpecDesc)>0)
					//过滤院区
					Set AdmID = $lg(VisitData,2)		//患者就诊号
					Set CollDate = $lg(VisitData,8)		//采集日期
					Set CollTime = $lg(VisitData,9)		//采集时间
					Set RecDate = $lg(VisitData,11)		//接收日期
					Set RecTime = $lg(VisitData,12)		//接收日期
					Set ActDate=CollDate,ActTime=CollTime
					If (ActDate=""){					//送检日期优先取采集日期,采集日期为空取报告日期
						Set ActDate=RecDate
						Set ActTime=RecTime
					}
					Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,ActDate,ActTime)
					Set ActLocID = $p(TransInfo,"^",1)		//送检科室ID
					Set ActWardID = $p(TransInfo,"^",2)		//送检病区ID
					Continue:(ActLocID="")||(ActWardID="")
					If (aLocType="W"){
						Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActWardID))
					}
					else{
						Set ActLocData  = $g(^DHCHAI.BT.LocationD(ActLocID))
					}
					Set HospID = $lg(ActLocData,8)			//送检院区
					Set LocDesc  = $lg(ActLocData,3)		//送检科室(病区)
					Set LocDesc2 = $lg(ActLocData,4)
					Set:LocDesc2'="" LocDesc=LocDesc2
					Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1) 	
					//过滤科室
					Continue:(aLocDesc'="")&&(LocDesc'=aLocDesc)	
					
					Set LabEpisodeNo	= $lg(VisitData,3)	//标本号
					
					//循环标本对应检验报告+检验结果
					Set xRepDate=""
					For {
						Set xRepDate=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitUpdateDate",xVisitNumberDr,xRepDate))
						Quit:xRepDate=""
						
						Set xRepID=0
						For {
							Set xRepID=$o(^DHCHAI.DP.LabVisitReportI("IndexVisitUpdateDate",xVisitNumberDr,xRepDate,xRepID))
							Quit:xRepID=""
							
							//检验报告表
							Set ReportData=$g(^DHCHAI.DP.LabVisitReportD(xRepID))		
							Continue:ReportData=""
							//过滤无效数据
							Set IsActive=$lg(ReportData,18)
							Continue:IsActive'=1
							
							Set CheckFlg =0  							//'微生物送检'标志
							
							Set LabTestSetDr=$lg(ReportData,13)		
							Continue:LabTestSetDr=""
							Set TestSetDesc=$lg($g(^DHCHAI.DP.LabVisitTestSetD(LabTestSetDr)),3)		//检验医嘱
							Set TestSetDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetDesc)  	//去掉特殊字符
							Continue:TestSetDesc=""
							//取对照后检验医嘱
							Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",LabSCode,TestSetDesc,0))
							Continue:TestSetMapID=""
							Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
							Continue:TestSetMapData=""
							Set TestSet = $lg(TestSetMapData,4)			//对照后检验医嘱
							If (TestSet'="") {   
								Set MapTSDesc=$lg($g(^DHCHAI.DP.LabTestSetD(TestSet)),3)
								Set BTCatDr=$lg($g(^DHCHAI.DP.LabTestSetD(TestSet)),4)
								If (BTCatDr'=""){
									Set MapTSCatDesc=$lg($g(^DHCHAI.DP.LabTestSetCatD(BTCatDr)),3)
									Set:(MapTSCatDesc="微生物送检") CheckFlg=1							//微生物送检
								}
							}
							//过滤非微生物送检
							Continue:CheckFlg'=1
							
							//获取检验结果(细菌名称)
							Set (BacDescList,MRBDescList,InfType)=""			//细菌+多耐+感染类型
							Set xRstID=""
							For{
								Set xRstID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xRepID,xRstID))
								Quit:xRstID=""
								
								//检验结果表
								Set RstData=$g(^DHCHAI.DP.LabVisitRepResultD(xRstID))
								Continue:RstData=""
								//过滤非细菌类型结果
								Set RstFormat=$lg(RstData,5)		//结果类型
								Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(LabSCode,"LABRstFormat",RstFormat)
								Continue:MapRstFormat'="M"
								
								Set Bacteria=$lg(RstData,6)			//原始细菌
								Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
								Continue:Bacteria=""
								
								Set BacDesc=""						//标准细菌名
								Set MapItemDr=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria","LIS01",Bacteria,""))
								If MapItemDr'="" {
									Set BactMapData=$g(^DHCHAI.DP.LabBactMapD(MapItemDr))
									If BactMapData'=""{
										Set IsActive = $li(BactMapData,7)
										Continue:IsActive'=1
										Set BacID=$li(BactMapData,3)
										If (BacID'=""){
											Set LabBacteriaData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
											Set:LabBacteriaData'="" BacDesc=$li(LabBacteriaData,3)	//细菌标准名
										}
									}
								}
								Continue:BacDesc="" 			// 过滤未对照细菌
								//细菌
								Set BacDescList=BacDescList_","_BacDesc
								//多耐类型
								//MRBDescList
								//感染类型
								Set MakeInfType=$lg(RstData,13)	
								Set:MakeInfType="1" MakeInfType="HA(院内感染)"
								Set:MakeInfType="2" MakeInfType="CA(社区感染)"
								Set:MakeInfType="3" MakeInfType="定植"
								Set:MakeInfType="4" MakeInfType="污染"
								Set:MakeInfType="5" MakeInfType="HA重复"
								Set:MakeInfType="6" MakeInfType="CA重复"
								Set:MakeInfType="7" MakeInfType="定植重复"
								Set InfType=InfType_","_MakeInfType
							}
							Set:InfType'="" InfType=$e(InfType,2,$l(InfType))
							Set RepDate=$lg(ReportData,10)
							Set RepTime=$lg(ReportData,11)
							
							//过滤标本类型
							Continue:((aYSpecFlag=1)&&(BacDescList=""))		//阳性
							Continue:((aYSpecFlag=2)&&(BacDescList'=""))	//阴性
							
							//输出1-患者基本信息
							Set PatData =..BuildPaadmData(AdmID)
							Continue:PatData=""
							Set AdmData   = $g(^DHCHAI.DP.PAAdmD(AdmID))
							Continue:AdmData=""
							Set AdmTimes = $lg(AdmData,38)   	//就诊次数
							//输出2-患者转科信息
							Set TransInfo=##class(DHCHAI.STATV2.BactDrugfast).GetLocInfoByDate(AdmID,aLocType,ActDate,ActTime)
							
							Set TransID		=$p(TransInfo,"^",1)
							Set GroupID		=$p(TransInfo,"^",2)
							Set GroupDesc	=$p(TransInfo,"^",3)
							Set TransLocID	=$p(TransInfo,"^",4)
							Set TransLocDesc=$p(TransInfo,"^",5)
							Set TransDate	= $p(TransInfo,"^",6)
							Set OutLocDate	= $p(TransInfo,"^",7)
							Set TransTime	= $p(TransInfo,"^",8)
							Set OutLocTime	= $p(TransInfo,"^",9)
							//转换转科日期格式
							Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
							Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
							Set:TransTime'="" TransTime=$zt(TransTime)
							Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
							Set TransDateTime =TransDate_" "_TransTime
							Set OutLocDateTime =OutLocDate_" "_OutLocTime
							
							Set TransInfo=$lb(TransID,GroupID,GroupDesc,TransLocID,TransLocDesc,TransDateTime,OutLocDateTime)
							//输出3-患者送检信息
							//采样时间(日期+时间)
							Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
							Set:ActTime'="" ActTime=$zt(ActTime,1)
							Set ActDateTime=ActDate_" "_ActTime
							//报告时间(日期+时间)
							Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
							Set:RepTime'="" RepTime=$zt(RepTime,1)
							Set RepDateTime=RepDate_" "_RepTime
					
							Set LabInfo=$lb(xVisitNumberDr,LabEpisodeNo,TestSetDesc,ActDateTime,RepDateTime,MRBDescList,SpecDesc,BacDescList,InfType)
							
							Set Data = $lb(LocDesc,AdmTimes)_PatData_TransInfo_LabInfo
							Set ^CacheTemp(repid,ind)=Data
							Set ind=ind+1
						}
					}
				}
			}
	    }
	}
	//日期类型为报告日期
	Else{
	    //按'审核日期'循环日期范围内检验报告表 
		For xDate = aDateFrom:1:aDateTo{
			Set xTime=""
			For{
				Set xTime=$o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime))
				Quit:xTime=""

				Set xRepID=""
				For{
					Set xRepID=$o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime,xRepID))
					Quit:xRepID=""
					
					//检验报告表
					Set ReportData=$g(^DHCHAI.DP.LabVisitReportD(xRepID))		
					Continue:ReportData=""
					//过滤无效数据
					Set IsActive=$lg(ReportData,18)
					Continue:IsActive'=1
					
					//'报告'关联'标本'
					Set VisitNumberDr=$lg(ReportData,2)
					//检验标本表	
					Set VisitData=$g(^DHCHAI.DP.LabVisitNumberD(VisitNumberDr))	
					Continue:VisitData=""
					//过滤标本无效数据
					Set LabIsActive = $li(VisitData,18)
					Continue:LabIsActive'=1
					//过滤院区
					Set AdmID = $lg(VisitData,2)			//患者就诊号
					Set CollDate = $lg(VisitData,8)			//采集日期
					Set CollTime = $lg(VisitData,9)			//采集时间
					Set RecDate = $lg(VisitData,11)			//接收日期
					Set RecTime = $lg(VisitData,12)			//接收日期
					Set ActDate=CollDate,ActTime=CollTime
					If (ActDate=""){						//送检日期优先取采集日期,采集日期为空取报告日期
						Set ActDate=RecDate
						Set ActTime=RecTime
					}
					Set TransInfo  = ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(AdmID,xDate,xTime)
					Set RepLocID = $p(TransInfo,"^",1)		//报告科室ID
					Set RepWardID = $p(TransInfo,"^",2)		//报告病区ID
					Continue:(RepLocID="")||(RepWardID="")
					If (aLocType="W"){
						Set RepLocData  = $g(^DHCHAI.BT.LocationD(RepWardID))
					}
					else{
						Set RepLocData  = $g(^DHCHAI.BT.LocationD(RepLocID))
					}
					Set HospID = $lg(RepLocData,8)			//报告院区
					Set LocDesc  = $lg(RepLocData,3)		//送检科室(病区)
					Set LocDesc2 = $lg(RepLocData,4)
					Set:LocDesc2'="" LocDesc=LocDesc2
					Quit:(aHospIDs'="")&&($listfind(aHospIDs,HospID)<1) 
					//过滤科室
					Continue:(aLocDesc'="")&&(LocDesc'=aLocDesc)	
					
					//过滤未对照标本
					Set LabSpecimen = $lg(VisitData,6)			//标本原始记录
					Set LabSCode    = $lg(VisitData,14)			//子系统代码
					Set SpecMapID   = $o(^DHCHAI.DP.LabSpecMapI("IndexSCodeSpecDesc",LabSCode,LabSpecimen,0))
					Continue:SpecMapID=""
					Set SpecMapData = $g(^DHCHAI.DP.LabSpecMapD(SpecMapID))
					Continue:SpecMapData=""
					Set BTMapItemDr = $lg(SpecMapData,3)		
					Continue:BTMapItemDr=""
					//过滤标本ID
					Continue:(aSpecID'="")&&(aSpecID'=BTMapItemDr)
					Set SpecData=$g(^DHCHAI.DP.LabSpecimenD(BTMapItemDr))	
					Set SpecDesc = $lg(SpecData,3)				//标本标准名
					//过滤标本Desc
					Continue:($ll(listSpec)>0)&&'($lf(listSpec,SpecDesc)>0)
					
					Set CheckFlg =0  							//'微生物送检'标志
					Set LabTestSetDr=$lg(ReportData,13)		
					Continue:LabTestSetDr=""
					Set TestSetDesc=$lg($g(^DHCHAI.DP.LabVisitTestSetD(LabTestSetDr)),3)		//检验医嘱
					Set TestSetDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetDesc)  	//去掉特殊字符
					Continue:TestSetDesc=""
					//取对照后检验医嘱
					Set TestSetMapID=$o(^DHCHAI.DP.LabTestSetMapI("IndexSCodeTestSet",LabSCode,TestSetDesc,0))
					Continue:TestSetMapID=""
					Set TestSetMapData=$g(^DHCHAI.DP.LabTestSetMapD(TestSetMapID))
					Continue:TestSetMapData=""
					Set TestSet = $lg(TestSetMapData,4)			//对照后检验医嘱
					If (TestSet'="") {   
						Set MapTSDesc=$lg($g(^DHCHAI.DP.LabTestSetD(TestSet)),3)
						Set BTCatDr=$lg($g(^DHCHAI.DP.LabTestSetD(TestSet)),4)
						If (BTCatDr'=""){
							Set MapTSCatDesc=$lg($g(^DHCHAI.DP.LabTestSetCatD(BTCatDr)),3)
							Set:(MapTSCatDesc="微生物送检") CheckFlg=1							//微生物送检
						}
					}
					//过滤非微生物送检
					Continue:CheckFlg'=1
					
					Set LabEpisodeNo	= $lg(VisitData,3)	//标本号		
					//获取检验结果(细菌名称)BacDescList
					Set (BacDescList,MRBDescList,InfType)=""			//细菌+多耐+感染类型
					Set xRstID=""
					For{
						Set xRstID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabReportDr",xRepID,xRstID))
						Quit:xRstID=""
								
						//检验结果表
						Set RstData=$g(^DHCHAI.DP.LabVisitRepResultD(xRstID))
						Continue:RstData=""
						//过滤非细菌类型结果
						Set RstFormat=$lg(RstData,5)		//结果类型
						Set MapRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(LabSCode,"LABRstFormat",RstFormat)
						Continue:MapRstFormat'="M"
								
						Set Bacteria=$lg(RstData,6)			//原始细菌
						Set Bacteria=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(Bacteria)  //去掉特殊字符
						Continue:Bacteria=""
								
						Set BacDesc=""						//标准细菌名
						Set MapItemDr=$o(^DHCHAI.DP.LabBactMapI("IndexSCodeBacteria","LIS01",Bacteria,""))
						If MapItemDr'="" {
							Set BactMapData=$g(^DHCHAI.DP.LabBactMapD(MapItemDr))
							If BactMapData'=""{
								Set IsActive = $li(BactMapData,7)
								Continue:IsActive'=1
								Set BacID=$li(BactMapData,3)
								If (BacID'=""){
									Set LabBacteriaData=$g(^DHCHAI.DP.LabBacteriaD(BacID))
									Set:LabBacteriaData'="" BacDesc=$li(LabBacteriaData,3)	//细菌标准名
								}
							}
						}
						Continue:BacDesc="" 			// 过滤未对照细菌
						//细菌
						Set BacDescList=BacDescList_","_BacDesc
						//多耐类型
						//MRBDescList
						//感染类型
						Set MakeInfType=$lg(RstData,13)	
						Set:MakeInfType="1" MakeInfType="HA(院内感染)"
						Set:MakeInfType="2" MakeInfType="CA(社区感染)"
						Set:MakeInfType="3" MakeInfType="定植"
						Set:MakeInfType="4" MakeInfType="污染"
						Set:MakeInfType="5" MakeInfType="HA重复"
						Set:MakeInfType="6" MakeInfType="CA重复"
						Set:MakeInfType="7" MakeInfType="定植重复"
						Set InfType=InfType_","_MakeInfType
					}
					Set:InfType'="" InfType=$e(InfType,2,$l(InfType))
					Set RepDate=$lg(ReportData,10)
					Set RepTime=$lg(ReportData,11)
							
					//过滤标本类型
					Continue:((aYSpecFlag=1)&&(BacDescList=""))		//阳性
					Continue:((aYSpecFlag=2)&&(BacDescList'=""))	//阴性
					
					//输出1-患者基本信息
					Set PatData =..BuildPaadmData(AdmID)
					Continue:PatData=""
					Set AdmData   = $g(^DHCHAI.DP.PAAdmD(AdmID))
					Continue:AdmData=""
					Set AdmTimes = $lg(AdmData,38)   	//就诊次数
					//输出2-患者转科信息
					Set TransInfo=##class(DHCHAI.STATV2.BactDrugfast).GetLocInfoByDate(AdmID,aLocType,RepDate,RepTime)
							
					Set TransID		=$p(TransInfo,"^",1)
					Set GroupID		=$p(TransInfo,"^",2)
					Set GroupDesc	=$p(TransInfo,"^",3)
					Set TransLocID	=$p(TransInfo,"^",4)
					Set TransLocDesc=$p(TransInfo,"^",5)
					Set TransDate	= $p(TransInfo,"^",6)
					Set OutLocDate	= $p(TransInfo,"^",7)
					Set TransTime	= $p(TransInfo,"^",8)
					Set OutLocTime	= $p(TransInfo,"^",9)
					//转换转科日期格式
					Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
					Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
					Set:TransTime'="" TransTime=$zt(TransTime)
					Set:OutLocTime'="" OutLocTime=$zt(OutLocTime)
					Set TransDateTime =TransDate_" "_TransTime
					Set OutLocDateTime =OutLocDate_" "_OutLocTime
							
					Set TransInfo=$lb(TransID,GroupID,GroupDesc,TransLocID,TransLocDesc,TransDateTime,OutLocDateTime)
					//输出3-患者送检信息
					//采样时间(日期+时间)
					Set:ActDate'="" ActDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(ActDate)
					Set:ActTime'="" ActTime=$zt(ActTime,1)
					Set ActDateTime=ActDate_" "_ActTime
					//报告时间(日期+时间)
					Set:RepDate'="" RepDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(RepDate)
					Set:RepTime'="" RepTime=$zt(RepTime,1)
					Set RepDateTime=RepDate_" "_RepTime
					
					Set LabInfo=$lb(xVisitNumberDr,LabEpisodeNo,TestSetDesc,ActDateTime,RepDateTime,MRBDescList,SpecDesc,BacDescList,InfType)
							
					Set Data = $lb(LocDesc,AdmTimes)_PatData_TransInfo_LabInfo
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1		
				}
			}
		}
				
	}
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryLocSpecDistDtlClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLocSpecDistDtlExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLocSpecDistDtlFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLocSpecDistDtlExecute ]
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
