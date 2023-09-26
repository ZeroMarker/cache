/// 名称: DHCHAI.DPS.PAAdmTransSrv
/// 描述: 转科相关服务
/// 编写者：zhufei
/// 编写日期: 2017-05-27
Class DHCHAI.DPS.PAAdmTransSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhoubo
/// CreatDate：   2022-09-06
/// Description:  取患者当前科室(最近一次)的入科日期时间信息
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aEpisodeID : 就诊号
///               aLocType : 科室类型(E科室、W病区)
/// Return：      返回%List
/// w ##class(DHCHAI.DPS.PAAdmTransSrv).GetCurrLocInfo("612","E")
ClassMethod GetCurrLocInfo(aEpisodeID As %String, aLocType As %String) As %String
{
	New (aEpisodeID,aLocType)
	Set return=""
	Quit:(aEpisodeID="")||(aLocType="") return
	
	Set aLocType=$zcvt(aLocType,"U")
	Quit:(aLocType'="E")&&(aLocType'="W") return
	
	Set xID=""
	For {
		Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",aEpisodeID,xID),-1)
		Quit:xID=""
		
		Set TranData=$g(^DHCHAI.DP.PAAdmTransD(xID))
		Continue:TranData=""
		Set LocID = $lg(TranData,5)
		Continue:LocID=""
		Set TranLocData = $g(^DHCHAI.BT.LocationD(LocID))
		Continue:TranLocData=""
		Set LocDesc  = $lg(TranLocData,3)
		Set LocDesc2 = $lg(TranLocData,4)
		Set:LocDesc2'="" LocDesc=LocDesc2
		Set TransDate   = $lg(TranData,7)
		Set PATransTime = $lg(TranData,8)
		Set TransType   = $lg(TranData,4)
		Continue:aLocType'=TransType
		
		Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
		Set:PATransTime'="" PATransTime = $zt(PATransTime,1)
		
		Set return = LocID_"^"_LocDesc_"^"_TransDate_"^"_PATransTime
		Quit
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-27
/// Description:  取转科科室信息
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aEpisodeID : 就诊号
///               aLocType : 科室类型(E科室、W病区)
/// Return：      返回String=入院科室_"^"_当前科室_"^"_入科日期_"^"_入科来源
/// w ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransLocInfo(612,"E")
ClassMethod GetTransLocInfo(aEpisodeID As %String, aLocType As %String) As %String
{
	New (aEpisodeID,aLocType)
	Set return=""
	Quit:(aEpisodeID="")||(aLocType="") return
	
	Set aLocType=$zcvt(aLocType,"U")
	Quit:(aLocType'="E")&&(aLocType'="W") return
	
	//取入院科室、入院日期信息
	Set InHospDate="",InHospLocID="",InHospLocDesc=""
	//取入科日期、入院来源
	Set CurrLocID="",CurrLocDesc="",InLocDate="",FromLocID="",FromLocDesc=""
	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate))
		Quit:xDate=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate,xID))
			Quit:xID=""
			Set TranData=$g(^DHCHAI.DP.PAAdmTransD(xID))
			Set LocID=$lg(TranData,5)
			Continue:LocID=""
			Set TranLocData=$g(^DHCHAI.BT.LocationD(LocID))
			Set BTTypeDr=$lg(TranLocData,5)
			Continue:BTTypeDr=""
			Set TypeData=$g(^DHCHAI.BT.DictionaryD(BTTypeDr))
			Set LocType=$lg(TypeData,2)
			Set LocDesc=$lg(TranLocData,3)
			Set LocDesc2=$lg(TranLocData,4)
			Set:LocDesc2'="" LocDesc=LocDesc2
			Set TransDate=$lg(TranData,7)
			//Set:TransDate'="" TransDate=$zd(TransDate,3)
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			
			If InHospLocID="" {
				Set InHospDate=TransDate
				Set InHospLocID=LocID
				Set InHospLocDesc=LocDesc
			}
			
			If CurrLocID'=LocID {
				Set FromLocID=CurrLocID
				Set FromLocDesc=CurrLocDesc
				Set CurrLocID=LocID
				Set CurrLocDesc=LocDesc
				Set InLocDate=TransDate
			}
		}
	}
	
	Set return=InHospDate
	Set return=return_"^"_InHospLocID_"^"_InHospLocDesc
	Set return=return_"^"_InLocDate
	Set return=return_"^"_CurrLocID_"^"_CurrLocDesc
	Set return=return_"^"_FromLocID_"^"_FromLocDesc
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-05-27
/// Description:  取转科科室列表
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aEpisodeID : 就诊号
///               aLocType : 科室类型(E科室、W病区)
/// Return：      返回%List
/// w ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransLocList("14109","E")
ClassMethod GetTransLocList(aEpisodeID As %String, aLocType As %String) As %List
{
	New (aEpisodeID,aLocType)
	Set return=""
	Quit:(aEpisodeID="")||(aLocType="") return
	
	Set aLocType=$zcvt(aLocType,"U")
	Quit:(aLocType'="E")&&(aLocType'="W") return
	
	Set PreLocDesc=""
	Set xID=0
	For {
		Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",aEpisodeID,xID))
		Quit:xID=""
		
		Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xID)
		Continue:'$IsObject(objTrans)
		Continue:'$IsObject(objTrans.PATransLocDr)
		Set TransType=objTrans.PATransType
		Continue:aLocType'=TransType
		Set objLoc=objTrans.PATransLocDr
		Set LocID=objLoc.%Id()
		Set LocCode=objLoc.BTCode
		Set LocDesc=objLoc.BTDesc
		Set LocDesc2=objLoc.BTDesc2
		Set:LocDesc2'="" LocDesc=LocDesc2
		Continue:PreLocDesc=LocDesc
		Set PreLocDesc=LocDesc
		
		Set TransDate=objTrans.PATransDate
		//Set:TransDate'="" TransDate=$zd(TransDate,3)
		Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)

		Set return=return_$lb($lb(xID,LocID,LocCode,LocDesc,TransDate))
	}
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-25
/// Description:  取每日新入、在院、出院就诊接口
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aLocType : 科室类型（科室E、病区W）
///               aLocID : 科室/病区ID（DHCHAI.BT.Location.ID）
/// Return：      返回%List
/// w ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate("2018-04-11","2018-04-11","W","638","I")
ClassMethod GetTransEpisByLocDate(aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocID As %String, aAdmType As %String, ByRef aMsgErr As %String = "") As %Library.ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aLocType,aLocID,aAdmType,aMsgErr)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:(aLocType="")&&(aLocID="") return
	
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set ZIndex=$zn,JIndex=$j,NIndex="GetTransEpisByLocDate"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set $ZT="GetTransEpisByLocDateErr"
	
	If aLocID'="" {
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
		Quit:'$IsObject(objLoc) return
		Quit:'$IsObject(objLoc.BTTypeDr) return
		Set aLocType=objLoc.BTTypeDr.BTCode
	} Else {
		Set aLocType=$zcvt(aLocType,"U")
		Quit:(aLocType'="W")&(aLocType'="E") return
	}
	
	Set:aAdmType'="" aAdmType="|"_aAdmType_"|"
	
	Set xTransType=""
	For {
		Set xTransType=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType))
		Quit:xTransType=""
		Continue:xTransType="B" //转床信息
		Continue:(aLocType'="")&&(xTransType'=aLocType)
		
		Set xTransDays=""
		For {
			Set xTransDays=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays))
			Quit:xTransDays=""
			
			//xTransDays<0 表示在科病人
			Set xTransDate=""
			//xTransDays>0 表示出科病人
			Set:xTransDays>=0 xTransDate=aDateFrom-xTransDays
			For {
				Set xTransDate=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate))
				Quit:xTransDate=""
				Quit:xTransDate>aDateTo  //转入日期大于截止日期
				
				Set xTransID=""
				For {
					Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate,xTransID))
					Quit:xTransID=""
					
					Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
					Continue:'$isobject(objTrans)
					Continue:'$isobject(objTrans.PAEpisodeDr)
					Set AdmType=objTrans.PAEpisodeDr.PAAdmType
					Continue:(aAdmType'="")&(aAdmType'[("|"_AdmType_"|"))  //EP急诊留观、I住院、O门诊、E急诊流水
					Continue:'$isobject(objTrans.PATransLocDr)
					Continue:'$isobject(objTrans.PATransLocDr.BTTypeDr)
					Set TransLocDr=objTrans.PATransLocDr.%Id()
					Continue:(aLocID'="")&&(TransLocDr'=aLocID)
					
					Set EpisodeDr=objTrans.PAEpisodeDr.%Id()
					Set TransDate=objTrans.PATransDate
					Set TransTime=objTrans.PATransTime
					Set TransTime=+TransTime
					Set:TransTime=0 TransTime=1
					Set OutLocDate=objTrans.PAOutLocDate
					Set OutLocTime=objTrans.PAOutLocTime
					If OutLocDate="" {
						Set TransXDate=+$h
					} Else {
						Set OutLocTime=+OutLocTime
						Set:OutLocTime=0 OutLocTime=1
						Set TransXDate=OutLocDate
					}
					
					For xDate=TransDate:1:TransXDate {
						Continue:xDate<aDateFrom
						Quit:xDate>aDateTo
						
						If (xDate'=TransDate)&&(xDate'=OutLocDate) {      //在科A
							Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,EpisodeDr,TransLocDr,"A",TransTime,xTransID)=""
						} ElseIf (xDate=TransDate)&&(xDate=OutLocDate) {  //在科A2
							Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,EpisodeDr,TransLocDr,"A2",TransTime,xTransID)=""
						} Else {
							If xDate=TransDate {   //入科
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,EpisodeDr,TransLocDr,"I"))
								Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,EpisodeDr,TransLocDr,"I",TransTime,xTransID)=""
							}
							If xDate=OutLocDate {  //出科
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,EpisodeDr,TransLocDr,"O"))
								Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,EpisodeDr,TransLocDr,"O",OutLocTime,xTransID)=""
							}
						}
					}
				}
			}
		}
	}
	
	Set Count=0
	Set xDate=""
	For {
		Set xDate=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate))
		Quit:xDate=""
		
		Set xEpisodeDr=0
		For {
			Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr))
			Quit:xEpisodeDr=""
			
			Set xLocDr=""
			For {
				Set xLocDr=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr))
				Quit:xLocDr=""
				
				Set TransID=""
				Set ICnt=+$g(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,"I"))
				Set OCnt=+$g(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,"O"))
				If ICnt>OCnt {
					Set xStatus="I"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,xTime,""))
				} ElseIf ICnt<OCnt {
					Set xStatus="O"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,""),-1)
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,xTime,""),-1)
				} ElseIf (ICnt=OCnt)&(ICnt>0) {
					//说明：先出再入，并且"转入次数=转出次数"，这种算在院A
					//      先入再出，并且"转入次数=转出次数"，这种算在院A2
					Set tStatus="O",xStatus="A"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,tStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,tStatus,xTime,""))
				} Else {
					Set xStatus="A"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,xTime,""))
					If TransID="" {
						Set xStatus="A2"
						Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,""))
						Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,xTime,""))
					}
				}
				Continue:TransID=""
				
				Set TransInfo=$lb(xDate,xEpisodeDr,xStatus,xLocDr,TransID)
				Set Count=Count+1
				Do return.SetAt(TransInfo,Count)
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
	
GetTransEpisByLocDateErr
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-25
/// Description:  取虚拟病区每日新入、在院、出院就诊接口
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aLocType : 科室类型（科室E、病区W）
///               aLocID : 科室/病区ID（DHCHAI.BT.Location.ID）
/// Return：      返回%List
/// w ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLocDate2("2016-08-10","2016-08-31","W","","I")
ClassMethod GetTransEpisByLocDate2(aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocID As %String, aAdmType As %String, ByRef aMsgErr As %String = "") As %Library.ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aLocType,aLocID,aAdmType,aMsgErr)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:(aLocType="")&&(aLocID="") return
	
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set ZIndex=$zn,JIndex=$j,NIndex="GetTransEpisByLocDate2"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set $ZT="GetTransEpisByLocDate2Err"
	
	If aLocID'="" {
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
		Quit:'$IsObject(objLoc) return
		Quit:'$IsObject(objLoc.BTTypeDr) return
		Set aLocType=objLoc.BTTypeDr.BTCode
	} Else {
		Set aLocType=$zcvt(aLocType,"U")
	}
	Quit:(aLocType'="W") return
	
	Set:aAdmType'="" aAdmType="|"_aAdmType_"|"
	
	Set xTransType=""
	For {
		Set xTransType=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType))
		Quit:xTransType=""
		Continue:xTransType'="B" //转床信息
		
		Set xTransDays=""
		For {
			Set xTransDays=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays))
			Quit:xTransDays=""
			
			//xTransDays<0 表示在科病人
			Set xTransDate=""
			//xTransDays>0 表示出科病人
			Set:xTransDays>=0 xTransDate=aDateFrom-xTransDays
			For {
				Set xTransDate=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate))
				Quit:xTransDate=""
				Quit:xTransDate>aDateTo  //转入日期大于截止日期
				
				Set xTransID=""
				For {
					Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate,xTransID))
					Quit:xTransID=""
					
					Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
					Continue:'$isobject(objTrans)
					Continue:'$isobject(objTrans.PAEpisodeDr)
					Set AdmType=objTrans.PAEpisodeDr.PAAdmType
					Continue:(aAdmType'="")&(aAdmType'[("|"_AdmType_"|"))  //EP急诊留观、I住院、O门诊、E急诊流水
					Continue:'$isobject(objTrans.PATransLocDr)
					Continue:'$isobject(objTrans.PATransBedDr)
					If $isobject(objTrans.PATransBedDr.BTXLocDr){
						Set TransLocDr=objTrans.PATransBedDr.BTXLocDr.%Id()  //床位科室
					} Else {
						Set TransLocDr=objTrans.PATransLocDr.%Id()
					}
					Continue:(aLocID'="")&&(TransLocDr'=aLocID)
					
					Set EpisodeDr=objTrans.PAEpisodeDr.%Id()
					Set TransDate=objTrans.PATransDate
					Set TransTime=objTrans.PATransTime
					Set TransTime=+TransTime
					Set:TransTime=0 TransTime=1
					Set OutLocDate=objTrans.PAOutLocDate
					Set OutLocTime=objTrans.PAOutLocTime
					If OutLocDate="" {
						Set TransXDate=+$h
					} Else {
						Set OutLocTime=+OutLocTime
						Set:OutLocTime=0 OutLocTime=1
						Set TransXDate=OutLocDate
					}
					
					For xDate=TransDate:1:TransXDate {
						Continue:xDate<aDateFrom
						Quit:xDate>aDateTo
						
						If (xDate'=TransDate)&&(xDate'=OutLocDate) {      //在科A
							Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,EpisodeDr,TransLocDr,"A",TransTime,xTransID)=""
						} ElseIf (xDate=TransDate)&&(xDate=OutLocDate) {  //在科A2
							Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,EpisodeDr,TransLocDr,"A2",TransTime,xTransID)=""
						} Else {
							If xDate=TransDate {   //入科
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,EpisodeDr,TransLocDr,"I"))
								Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,EpisodeDr,TransLocDr,"I",TransTime,xTransID)=""
							}
							If xDate=OutLocDate {  //出科
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,EpisodeDr,TransLocDr,"O"))
								Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,EpisodeDr,TransLocDr,"O",OutLocTime,xTransID)=""
							}
						}
					}
				}
			}
		}
	}
	
	Set Count=0
	Set xDate=""
	For {
		Set xDate=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate))
		Quit:xDate=""
		
		Set xEpisodeDr=0
		For {
			Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr))
			Quit:xEpisodeDr=""
			
			Set xLocDr=""
			For {
				Set xLocDr=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr))
				Quit:xLocDr=""
				
				Set TransID=""
				Set ICnt=+$g(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,"I"))
				Set OCnt=+$g(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,"O"))
				If ICnt>OCnt {
					Set xStatus="I"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,xTime,""))
				} ElseIf OCnt>ICnt {
					Set xStatus="O"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,""),-1)
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,xTime,""),-1)
				} ElseIf (ICnt=OCnt)&(ICnt>0) {
					//说明：先出再入，并且"转入次数=转出次数"，这种算在院A
					//      先入再出，并且"转入次数=转出次数"，这种算在院A2
					Set tStatus="O",xStatus="A"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,tStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,tStatus,xTime,""))
				} Else {
					Set xStatus="A"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,xTime,""))
					If TransID="" {
						Set xStatus="A2"
						Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,""))
						Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xDate,xEpisodeDr,xLocDr,xStatus,xTime,""))
					}
				}
				Continue:TransID=""
				
				Set TransInfo=$lb(xDate,xEpisodeDr,xStatus,xLocDr,TransID)
				Set Count=Count+1
				Do return.SetAt(TransInfo,Count)
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
	
GetTransEpisByLocDate2Err
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-25
/// Description:  取科室在科病人就诊接口
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aLocType : 科室类型（科室E、病区W）
///               aLocID : 科室/病区ID（DHCHAI.BT.Location.ID）
/// Return：      返回%List
/// w ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransEpisByLoc("2016-07-01","2016-08-31","W","","I")
ClassMethod GetTransEpisByLoc(aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocID As %String, aAdmType As %String, ByRef aMsgErr As %String = "") As %Library.ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aLocType,aLocID,aAdmType,aMsgErr)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:(aLocType="")&&(aLocID="") return
	
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	Quit:(aDateFrom>aDateTo) return
	Set $ZT="GetTransEpisByLocErr"
	
	If aLocID'="" {
		Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
		Quit:'$IsObject(objLoc) return
		Quit:'$IsObject(objLoc.BTTypeDr) return
		Set aLocType=objLoc.BTTypeDr.BTCode
	} Else {
		Set aLocType=$zcvt(aLocType,"U")
		Quit:(aLocType'="W")&(aLocType'="E") return
	}
	
	Set:aAdmType'="" aAdmType="|"_aAdmType_"|"
	
	Set Count=0
	Set xTransType=""
	For {
		Set xTransType=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType))
		Quit:xTransType=""
		Continue:xTransType="B" //转床信息
		Continue:(aLocType'="")&&(xTransType'=aLocType)
		
		Set xTransDays=""
		For {
			Set xTransDays=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays))
			Quit:xTransDays=""
			
			//xTransDays<0 表示在科病人
			Set xTransDate=""
			//xTransDays>0 表示出科病人
			Set:xTransDays>=0 xTransDate=aDateFrom-xTransDays
			For {
				Set xTransDate=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate))
				Quit:xTransDate=""
				Quit:xTransDate>aDateTo  //转入日期大于截止日期
				
				Set xTransID=""
				For {
					Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType,xTransDays,xTransDate,xTransID))
					Quit:xTransID=""
					
					Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
					Continue:'$isobject(objTrans)
					Continue:'$isobject(objTrans.PAEpisodeDr)
					Set AdmType=objTrans.PAEpisodeDr.PAAdmType
					Continue:(aAdmType'="")&(aAdmType'[("|"_AdmType_"|"))  //EP急诊留观、I住院、O门诊、E急诊流水
					Continue:'$isobject(objTrans.PATransLocDr)
					Continue:'$isobject(objTrans.PATransLocDr.BTTypeDr)
					Set LocType=objTrans.PATransLocDr.BTTypeDr.BTCode
					Set TransLocDr=objTrans.PATransLocDr.%Id()
					Continue:(aLocID'="")&&(TransLocDr'=aLocID)
					
					Set EpisodeDr=objTrans.PAEpisodeDr.%Id()
					Set TransDate=objTrans.PATransDate
					Set TransTime=objTrans.PATransTime
					Set TransTime=+TransTime
					Set:TransTime=0 TransTime=1
					Set OutLocDate=objTrans.PAOutLocDate
					Set OutLocTime=objTrans.PAOutLocTime
					If OutLocDate'="" {
						Set OutLocTime=+OutLocTime
						Set:OutLocTime=0 OutLocTime=1
					}
					
					Set TransInfo=$lb(EpisodeDr,TransLocDr,xTransID)
					Set Count=Count+1
					Do return.SetAt(TransInfo,Count)
				}
			}
		}
	}
	Quit return
	
GetTransEpisByLocErr
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2017-09-23
/// Description:  根据日期时间点，获取某日患者住院科室/病区/床位
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aEpisodeDr : 就诊号
///               aDate : 日期
///               aTime : 时间
/// Return：      返回%String
/// w ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate("638","2018-04-11","")
ClassMethod GetTransInfoByDate(aEpisodeDr As %String, aDate As %String, aTime As %String = "") As %Library.ArrayOfDataTypes
{
	New (aEpisodeDr,aDate,aTime)
	Set return=""
	Quit:(aEpisodeDr="")||(aDate="") return
	
	//Set:aDate["-" aDate=$zdh(aDate,3)
	Set aDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
	Set:aTime[":" aTime=$zth(aTime,1)
	Set:aTime="" aTime=$zth("00:00:01",1)  //默认时间点为23:59:59  //默认时间点改为00:00:01
	
	Set TransLocDr="",TransWardDr="",TransBedDr="",TransWardID="",TransLocDesc=""
	Set xTransType=""
	For {
		Set xTransType=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType))
		Quit:xTransType=""
		
		Set xDate=aDate+1
		For {
			Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xTransType,aEpisodeDr,xDate),-1)
			Quit:xDate=""
			Quit:(xTransType="E")&(TransLocDr'="")  //科室
			Quit:(xTransType="W")&(TransWardDr'="") //病区
			Quit:(xTransType="B")&(TransBedDr'="")  //床位
			
			Set xTime=$s(xDate=aDate:(+aTime+1),1:"")
			For {
				Set xTime=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xTransType,aEpisodeDr,xDate,xTime),-1)
				Quit:xTime=""
				Quit:(xTransType="E")&(TransLocDr'="")  //科室
				Quit:(xTransType="W")&(TransWardDr'="") //病区
				Quit:(xTransType="B")&(TransBedDr'="")  //床位
				
				Set xTransID=""
				For {
					Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xTransType,aEpisodeDr,xDate,xTime,xTransID),-1)
					Quit:xTransID=""
					Quit:(xTransType="E")&(TransLocDr'="")  //科室
					Quit:(xTransType="W")&(TransWardDr'="") //病区
					Quit:(xTransType="B")&(TransBedDr'="")  //床位
					
					Set TransData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
					Continue:TransData=""
					Continue:$lg(TransData,5)=""
					Set TransDate=$lg(TransData, 7)
					Set TransTime=$lg(TransData, 8)
					Set TransType=$lg(TransData, 4)
					
					If TransType="E" {
						Set TransLocDr=$lg(TransData,5)
						Set TransLocDesc=$lg($g(^DHCHAI.BT.LocationD(TransLocDr)),3)
					} ElseIf TransType="W" {
						Set TransWardDr=$lg(TransData,5)
						Set:TransWardDr'="" TransWardID=xTransID
					} ElseIf TransType="B" {
						//根据转床找病区，防止最新的被覆盖 add by 20171205 chenjb
						Set tTransWardDr=$lg(TransData,5)
						Set:tTransWardDr'="" TransWardDr=tTransWardDr
						Set:TransWardDr'="" TransWardID=xTransID
						Set:($lg(TransData,6)'="")&(TransBedDr="") TransBedDr=$lg(TransData, 6)
					}
				}
			}
		}
	}
	
	Set TransTypeList=""
	Set:TransLocDr="" TransTypeList=TransTypeList_$lb("E")  //科室
	Set:TransWardDr="" TransTypeList=TransTypeList_$lb("W") //病区
	Set:TransBedDr="" TransTypeList=TransTypeList_$lb("B")  //床位
	
	If TransTypeList'="" {
		For indTT=1:1:$listlength(TransTypeList) {
			Set xTransType=$listget(TransTypeList,indTT)
			Continue:xTransType=""
			
			Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xTransType,aEpisodeDr,""))
			Continue:xDate=""
			Set xTime=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xTransType,aEpisodeDr,xDate,""))
			Continue:xTime=""
			Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisTransDateTime",xTransType,aEpisodeDr,xDate,xTime,0))
			Continue:xTransID=""
			
			Set TransData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
			Continue:TransData=""
			Continue:$lg(TransData,5)=""
			Set TransDate=$lg(TransData,7)
			Set TransTime=$lg(TransData,8)
			Set TransType=$lg(TransData,4)
			
			If TransType="E" {
				Set TransLocDr=$lg(TransData,5)
				Set TransLocDesc=$lg($g(^DHCHAI.BT.LocationD(TransLocDr)),3)
			} ElseIf TransType="W" {
				Set TransWardDr=$lg(TransData,5)
				Set:TransWardDr'="" TransWardID=xTransID
			} ElseIf TransType="B" {
				//根据转床找病区，防止最新的被覆盖 add by 20171205 chenjb
				Set tTransWardDr=$lg(TransData,5)
				Set:tTransWardDr'="" TransWardDr=tTransWardDr
				Set:TransWardDr'="" TransWardID=xTransID
				Set:($lg(TransData,6)'="")&(TransBedDr="") TransBedDr=$lg(TransData,6)
			}
		}
	}
	Set (BedDesc,BedLocDr)=""
	Set BedLocDr=TransWardDr
	If TransBedDr'="" {
		Set BedData=$g(^DHCHAI.BT.PACBedD(TransBedDr))
		If (BedData'=""){
			Set BedDesc=$lg(BedData, 3)
			If ($lg(BedData,11)'=""){
				Set BedLocDr=$lg(BedData,11)
			}
		}
	}
	Set return=TransLocDr_"^"_TransWardDr_"^"_TransBedDr_"^"_BedDesc_"^"_BedLocDr_"^"_TransWardID_"^"_TransLocDesc
	Quit return
}

/// Creator：     mayanpeng
/// CreatDate：   2018-05-24
/// Description:  取转科记录信息
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aEpisodeID : 就诊号
///               aLocID : DHCHAI.DP.PAAdmTrans.ID
///               aLocType : 科室类型(E科室、W病区)
/// Return：      返回String=入院日期_"^"_出院日期_"^"_入科日期_"^"_出科日期
/// w ##class(DHCHAI.DPS.PAAdmTransSrv).GetTransDateInfo(1905,1020,"2017-12-29")
ClassMethod GetTransDateInfo(aEpisodeID As %String, aLocID As %String, aDate As %String) As %String
{
	New (aEpisodeID,aLocID,aDate)
	Set return=""
	Quit:(aEpisodeID="")||(aLocID="")||(aDate="") return
	
	Set aDate=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDate)
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$IsObject(objAdm) return
	Set InHospDate=objAdm.PAAdmDate
	Set:InHospDate'="" InHospDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InHospDate)
	Set OutHospDate=objAdm.PADischDate
	Set:OutHospDate'="" OutHospDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutHospDate)
	
	Set objLoc=##class(DHCHAI.BT.Location).GetObjById(aLocID)
	Quit:'$IsObject(objLoc) return
	If '$IsObject(objLoc.BTTypeDr){
		Quit InHospDate_"^"_OutHospDate_"^^"
	}
	Set LocType=objLoc.BTTypeDr.BTCode //科室类型
	
	Set InLocDate="",OutLocDate=""
	Set xDate="",IsFlag=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",LocType,aEpisodeID,xDate),-1)
		Quit:xDate=""
		Continue:xDate>aDate
		If (xDate<=aDate){
			Set IsFlag=1
			Quit
		}
	}
	//转科表无当前时间的转科
	Quit:(IsFlag=0) InHospDate_"^"_OutHospDate_"^^"
	
	Set xID="",IsFlag=0
	For {
		Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",LocType,aEpisodeID,xDate,xID),-1)
		Quit:xID=""
		Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xID)
		Continue:'$IsObject(objTrans)
		Continue:'$IsObject(objTrans.PATransLocDr)
		Set objLoc=objTrans.PATransLocDr
		Continue:'$IsObject(objLoc.BTTypeDr)
		Set LocID=objLoc.%Id()
		//过滤科室
		If (aLocID=LocID){
			Set IsFlag=1
			Quit
		}
	}
	//转科表当前时间无该科室
	Quit:IsFlag=0 InHospDate_"^"_OutHospDate_"^^"
	
	Set LocDesc=objLoc.BTDesc
	Set LocDesc2=objLoc.BTDesc2
	Set:LocDesc2'="" LocDesc=LocDesc2
	Set InLocDate=objTrans.PATransDate
	Set:InLocDate'="" InLocDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InLocDate)
	Set OutLocDate=objTrans.PAOutLocDate
	Set:OutLocDate'="" OutLocDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
	Quit InHospDate_"^"_OutHospDate_"^"_InLocDate_"^"_OutLocDate
}

/// Creator：     zhufei
/// CreatDate：   2017-09-25
/// Description:  取横断面科室就诊列表
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aLocType : 科室类型（科室E、病区W）
///               aLocID : 科室/病区ID（DHCHAI.BT.Location.ID）
/// Return：      返回%List
/// w ##class(DHCHAI.DPS.PAAdmTransSrv).GetCSSEpisByLocDate("W","2016-02-01","2016-02-01","631")
ClassMethod GetCSSEpisByLocDate(aStatType As %String, aDateFrom As %String, aDateTo As %String, aLocID As %String, ByRef aMsgErr As %String = "") As %Library.ArrayOfDataTypes
{
	New (aStatType,aDateFrom,aDateTo,aLocID,aMsgErr)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aStatType="")||(aDateFrom="")||(aDateTo="") return
	
	Set:aStatType'="W" aStatType="E"  //不是病区就是科室
	
	//Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	//Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set aDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(aDateTo)
	
	Set ZIndex=$zn,JIndex=$j,NIndex="GetCSSEpisByLocDate"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set $ZT="GetCSSEpisByLocDateErr"
	
	Set Count=0
	Set xTransDays=""
	For {
		Set xTransDays=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",aStatType,xTransDays))
		Quit:xTransDays=""
		
		//xTransDays<0 表示在科病人
		Set xTransDate=""
		//xTransDays>0 表示出科病人
		Set:xTransDays>=0 xTransDate=aDateFrom-xTransDays
		For {
			Set xTransDate=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",aStatType,xTransDays,xTransDate))
			Quit:xTransDate=""
			Quit:xTransDate>aDateTo  //转入日期大于截止日期
			
			Set xTransID=""
			For {
				Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",aStatType,xTransDays,xTransDate,xTransID))
				Quit:xTransID=""
				
				Set TransData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
				Continue:TransData=""
				Set PAEpisodeDr=$lg(TransData,3)
				Continue:PAEpisodeDr=""
				Set AdmType=$lg($g(^DHCHAI.DP.PAAdmD(PAEpisodeDr)),18)
				Continue:AdmType'="I"	//EP急诊留观、I住院、O门诊、E急诊流水
				Set EpisodeDr=PAEpisodeDr
				
				//避免重复处理相同就诊记录
				Continue:$d(^TMP(ZIndex,JIndex,NIndex,"CSSEpis",EpisodeDr))
				Set ^TMP(ZIndex,JIndex,NIndex,"CSSEpis",EpisodeDr)=""
				
				//横断面调查范围（当天在院病人，包括当天出院，不包括当天入院+当天入当天出）
				Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(PAEpisodeDr)),20)
				Set DischDate=$lg($g(^DHCHAI.DP.PAAdmD(PAEpisodeDr)),26)
				//剔除当天入院
				Continue:AdmDate>=aDateTo
				//Continue:(AdmDate=aDateTo)&&(DischDate'=AdmDate) //当天入院出院有效
				
				//横断面调查科室、调查病区
				Set cTransInfo=..GetCSSTransLoc(aStatType,EpisodeDr,aDateFrom,aDateTo)
				Set cTransID=$p(cTransInfo,"^",1)
				Set cTransLocDr=$p(cTransInfo,"^",2)
				Set cLinkLocDr=$p(cTransInfo,"^",3)
				Continue:(cTransID="")||(cTransLocDr="")
				Continue:(aLocID'="")&&(cTransLocDr'=aLocID)&&(cLinkLocDr'=aLocID)
				Set CSSEpisInfo=$lb(EpisodeDr,cTransID,cTransLocDr,cLinkLocDr)
				Set Count=Count+1
				Do return.SetAt(CSSEpisInfo,Count)
			}
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
	
GetCSSEpisByLocDateErr
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

/// 取横断面调查科室病区
/// w ##class(DHCHAI.DPS.PAAdmTransSrv).GetCSSTransLoc("E",5393,$zdh("2016-09-27",3),$zdh("2016-09-27",3))
ClassMethod GetCSSTransLoc(aStatType As %String, aEpisodeDr As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aStatType,aEpisodeDr,aDateFrom,aDateTo)
	Set return=""
	Quit:(aStatType="")||(aEpisodeDr="")||(aDateFrom="")||(aDateTo="") return
	
	Kill arrAdmTrans
	Set xTransID=0
	For {
		Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDr",aEpisodeDr,xTransID))
		Quit:xTransID=""
		
		// Add by zhaoyj 2022-06-17 Global方式
		Set TransData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
		Continue:TransData=""
		Set TransType=$lg(TransData,4)
		Continue:(TransType'=aStatType)
		Continue:$lg(TransData,5)=""
		Set TransLocDr=$lg(TransData, 5)              //科室或病区
		Set LinkLocDr=""
		If ($lg(TransData,14)'=""){
			Set LinkLocDr=$lg(TransData,14)          //关联科室
		}
		Continue:(TransType="W")&(LinkLocDr="")
		Set TransDate=$lg(TransData,7)
		Continue:TransDate>aDateTo
		Set TransTime=$lg(TransData,8)
		Set TransTime=+TransTime
		Set:TransTime=0 TransTime=1
		Set OutLocDate=$lg(TransData,10)
		Set OutLocTime=$lg(TransData, 11)
		Continue:(OutLocDate'="")&&(OutLocDate<aDateFrom)
		//Continue:(OutLocDate'="")&&(OutLocDate=aDateFrom)
		//剔除当天入科
		Continue:TransDate=aDateFrom
		
		Set arrAdmTrans(TransDate,TransTime)=$lb(xTransID,TransLocDr,LinkLocDr,TransDate,TransTime,OutLocDate,OutLocTime)
	}
	
	Set xTransDate=$o(arrAdmTrans(""))
	Set xTransTime=$o(arrAdmTrans(+xTransDate,""))
	Set TransInfo=$g(arrAdmTrans(+xTransDate,+xTransTime))
	Kill arrAdmTrans
	
	Set return=$listtostring(TransInfo,"^")
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2019-12-12
/// Description:  查询患者转科记录
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aEpisodeID : 就诊号
///               aLocType : 科室类型(E科室、W病区)
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.PAAdmTransSrv","QryTransLocInfo","1")
Query QryTransLocInfo(aEpisodeID As %String, aLocType As %String = "E") As %Query(ROWSPEC = "TransID:%String,LocDesc:%String,TransDate:%String,TransTime:%String,OutLocDate:%String,OutLocTime:%String")
{
}

ClassMethod QryTransLocInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aLocType As %String = "E") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aEpisodeID="" $$$OK
	Set aLocType=$zcvt(aLocType,"U")
	Quit:(aLocType'="E")&&(aLocType'="W") $$$OK

	Set xDate=0
	For {
		Set xDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate))
		Quit:xDate=""
		
		Set xID=0
		For {
			Set xID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",aLocType,aEpisodeID,xDate,xID))
			Quit:xID=""
	
			Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xID)
			Continue:'$IsObject(objTrans)
			Continue:'$IsObject(objTrans.PATransLocDr)
			Set objLoc=objTrans.PATransLocDr
			Continue:'$IsObject(objLoc.BTTypeDr)
			Set LocType=objLoc.BTTypeDr.BTCode
			Set LocID=objLoc.%Id()
			Set LocDesc=objLoc.BTDesc
			Set LocDesc2=objLoc.BTDesc2
			Set:LocDesc2'="" LocDesc=LocDesc2
			//多语言
			Set LocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",LocDesc,"User.CTLoc")
			Set TransDate=objTrans.PATransDate
			Set:TransDate'="" TransDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(TransDate)
			Set TransTime=objTrans.PATransTime
			Set:TransTime'="" TransTime =$zt(TransTime,1)
			Set OutLocDate=objTrans.PAOutLocDate
			Set:OutLocDate'="" OutLocDate = ##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(OutLocDate)
			Set OutLocTime=objTrans.PAOutLocTime
			Set:OutLocTime'="" OutLocTime =$zt(OutLocTime,1)
		
			Set Data=$lb(xID,LocDesc,TransDate,TransTime,OutLocDate,OutLocTime)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
			
		}
	}
	Quit $$$OK
}

ClassMethod QryTransLocInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTransLocInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTransLocInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTransLocInfoExecute ]
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

/// Creator：     ShenC
/// CreatDate：   2021-08-10
/// Description:  查询患者[本地+例次]转科记录--[1.入病区2.入科3.分床4.转病区5.转科6.转床7.出病区8.出科9.离床]
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aEpisodeID:就诊号
/// Return：      返回ROWSPEC
/// do ##class(%ResultSet).RunQuery("DHCHAI.DPS.PAAdmTransSrv","QryTransInfoByID","22")
Query QryTransInfoByID(aEpisodeID As %String) As %Query(ROWSPEC = "xCount:%String,EpisodeID:%String,xAdmTime:%String,AdmDateTime:%String,DischDateTime:%String,TransDateTime:%String,OutLocDateTime:%String,PAAdmDoc:%String,TransLocDesc:%String,TransWardDesc:%String,TransBedDesc:%String,Explain:%String,SumAdmTime:%String")
{
}

ClassMethod QryTransInfoByIDExecute(ByRef qHandle As %Binary, aEpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Quit:aEpisodeID="" $$$OK			//就诊号[入参]不能为空
 	Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(aEpisodeID)
	Quit:'$isobject(objPaadm) $$$OK	
 	//定义临时Global
	Set NIndex="QryTransInfoByID"
	Kill ^TMP($zn,$j,NIndex)
 	
	//患者就诊记录(本次+历次)
	Set PatientIDx = objPaadm.PAPatientIDx
	Set xEpisodeID=""
	For {
		Set xEpisodeID = $o(^DHCHAI.DP.PAAdmI("IndexPatientIDx",PatientIDx,xEpisodeID))
		Quit:xEpisodeID=""
		
		Set objPaadm = ##class(DHCHAI.DP.PAAdm).GetObjById(xEpisodeID)
		Continue:'$isobject(objPaadm)
		
		Set AdmTimes=objPaadm.PAAdmTimes	//住院次数
		Set AdmDate=objPaadm.PAAdmDate		//入院日期
		Set AdmTime=objPaadm.PAAdmTime		//入院时间
		Set DischDate=objPaadm.PADischDate	//出院日期
		Set DischTime=objPaadm.PADischTime	//出院时间
		//存储数据
		Set ^TMP($zn,$j,NIndex,"AdmTimes",AdmTimes)=$lb(xEpisodeID,AdmDate,AdmTime,DischDate,DischTime,OutLocDate,OutLocTime)
		
		//转科类型(转病区:W,转科:E,转床:B)
		Set LocTypeList="W,E,B"
		For xInd=1:1:3{
			Set LocType=$p(LocTypeList,",",xInd)
			//循环转科表
			Set xTransDate=""
			For{
				Set xTransDate=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",LocType,xEpisodeID,xTransDate))
				Quit:xTransDate=""
				
				Set xTransID=0
				For {
					Set xTransID=$o(^DHCHAI.DP.PAAdmTransI("IndexEpisodeDrTransDate",LocType,xEpisodeID,xTransDate,xTransID))
					Quit:xTransID=""
					
					Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
					Continue:'$IsObject(objTrans)
					Continue:'$IsObject(objTrans.PATransLocDr)
					
					Set TransDate=objTrans.PATransDate		//转科日期
					Set TransTime=objTrans.PATransTime		//转科时间
					Set OutLocDate=objTrans.PAOutLocDate	//出科日期
					Set OutLocTime=objTrans.PAOutLocTime	//出科时间
					Set PAAdmDoc=$p(objTrans.PAAdmDoc,"|",3)			//管床医生
					//多语言
					Set PAAdmDoc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("SSUSRName",PAAdmDoc,"User.SSUser")
					//存储数据
					Set TransList=TransDate_"^"_TransTime_"^"_OutLocDate_"^"_OutLocTime_"^"_PAAdmDoc_"^"_xEpisodeID
					Set ^TMP($zn,$j,NIndex,"AdmTimes",AdmTimes,"TranList",TransList,"LocType",LocType)=""
				}
			}
		}
	}
	
	//输出(处理)数据
	Set SumAdmTime=$o(^TMP($zn,$j,NIndex,"AdmTimes",""),-1)		//总住院次数
	Set xAdmTime=""
	For{
		Set xAdmTime=$o(^TMP($zn,$j,NIndex,"AdmTimes",xAdmTime),-1)		//住院次数[倒序]
		Quit:xAdmTime=""
		
		Set Count=0						//计数
		Set xTransList=""
		For{
			Set xTransList=$o(^TMP($zn,$j,NIndex,"AdmTimes",xAdmTime,"TranList",xTransList))
			Quit:xTransList=""
			
			//患者基本信息
			Set PAAData=$g(^TMP($zn,$j,NIndex,"AdmTimes",xAdmTime))
			Set AdmDate=$lg(PAAData,2)		//入院日期
			Set AdmTime=$lg(PAAData,3)		//入院时间
			Set DischDate=$lg(PAAData,4)	//出院日期
			Set DischTime=$lg(PAAData,5)	//出院时间
			//转科基本信息
			Set TransDate=$p(xTransList,"^",1)		//转科日期
			Set TransTime=$p(xTransList,"^",2)		//转科时间
			Set OutLocDate=$p(xTransList,"^",3)		//出科日期
			Set OutLocTime=$p(xTransList,"^",4)		//出科时间 
			Set PAAdmDoc=$p(xTransList,"^",5)		//管床医生
			Set Explain=""			//描述(1.入病区2.入科3.分床4.转病区5.转科6.转床7.出病区8.出科9.离床)
			Set xTransType=""
			For{
				Set xTransType=$o(^TMP($zn,$j,NIndex,"AdmTimes",xAdmTime,"TranList",xTransList,"LocType",xTransType))
				Quit:xTransType=""
					
				if ( (TransDate<AdmDate)||((TransDate=AdmDate)&&(TransTime<=AdmTime)) ){		//转科日期小于(或等于)入院日期
					Set:xTransType["W" Explain=Explain_"/"_##class(websys.Translation).Get("dhcma.hai.ir.view.admhistory.csp","入病区")
					Set:xTransType["E" Explain=Explain_"/"_##class(websys.Translation).Get("dhcma.hai.ir.view.admhistory.csp","入科")
					Set:xTransType["B" Explain=Explain_"/"_##class(websys.Translation).Get("dhcma.hai.ir.view.admhistory.csp","分床")
				}
				elseif ( (DischDate'="")&&((OutLocDate>DischDate)||((OutLocDate=DischDate)&&(OutLocTime>=DischTime))) ){	//出科日期大于(或等于)出院日期
					Set:xTransType["W" Explain=Explain_"/"_##class(websys.Translation).Get("dhcma.hai.ir.view.admhistory.csp","出病区")
					Set:xTransType["E" Explain=Explain_"/"_##class(websys.Translation).Get("dhcma.hai.ir.view.admhistory.csp","出科")
					Set:xTransType["B" Explain=Explain_"/"_##class(websys.Translation).Get("dhcma.hai.ir.view.admhistory.csp","离床")
				}
				else{
					Set:xTransType["W" Explain=Explain_"/"_##class(websys.Translation).Get("dhcma.hai.ir.view.admhistory.csp","转病区")
					Set:xTransType["E" Explain=Explain_"/"_##class(websys.Translation).Get("dhcma.hai.ir.view.admhistory.csp","转科")
					Set:xTransType["B" Explain=Explain_"/"_##class(websys.Translation).Get("dhcma.hai.ir.view.admhistory.csp","转床")
				}
			}
			Set Explain=$e(Explain,"2",$l(Explain))
			//转科时间所在科室-病区-床位
			Set EpisodeID=$p(xTransList,"^",6)
			Set TransData=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeID,TransDate,TransTime)
			Continue:TransData=""
			Set (TransLocDesc,TransWardDesc,TransBedDesc)=""	
			Set TransLocID=$p(TransData,"^",1)
			Set:TransLocID'="" TransLocDesc=$lg(^DHCHAI.BT.LocationD(TransLocID),3)	//所在科室
			Set TransWardID=$p(TransData,"^",2)
			Set:TransWardID'="" TransWardDesc=$lg(^DHCHAI.BT.LocationD(TransWardID),3)	//所在病区
			Set TransBedID=$p(TransData,"^",3)
			Set:TransBedID'="" TransBedDesc=$lg(^DHCHAI.BT.PACBedD(TransBedID),3)		//所在床位
				
			//转换日期
			Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
			Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
			Set AdmDateTime=AdmDate_" "_AdmTime
			Set:DischDate'="" DischDate=$zd(DischDate,3)
			Set:DischTime'="" DischTime=$zt(DischTime,1)
			Set DischDateTime=DischDate_" "_DischTime
			Set:TransDate'="" TransDate=$zd(TransDate,3)
			Set:TransTime'="" TransTime=$zt(TransTime,1)
			Set TransDateTime=TransDate_" "_TransTime
			Set:OutLocDate'="" OutLocDate=$zd(OutLocDate,3)
			Set:OutLocTime'="" OutLocTime=$zt(OutLocTime,1)
			Set OutLocDateTime=OutLocDate_" "_OutLocTime
			
			//多语言
			Set TransLocDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",TransLocDesc,"User.CTLoc")
			Set TransWardDesc=##Class(DHCHAI.Abstract).HAIGetTranByDesc("CTLOCDesc",TransWardDesc,"User.CTLoc")	
			
			Set Count=Count+1
			Set ^CacheTemp(repid,ind)=$lb(Count,EpisodeID,xAdmTime,AdmDateTime,DischDateTime,TransDateTime,OutLocDateTime,PAAdmDoc,TransLocDesc,TransWardDesc,TransBedDesc,Explain,SumAdmTime)
			Set ind=ind+1
		}
	}		
	Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryTransInfoByIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTransInfoByIDExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTransInfoByIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTransInfoByIDExecute ]
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

}
