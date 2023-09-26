/// 名称: DHCHAI.IRS.WardDetailsSrv
/// 描述: 病区详情相关服务
/// 编写者：zzl
/// 编写日期: 2022-09-23
Class DHCHAI.IRS.WardDetailsSrv Extends DHCHAI.STATV2.AbstractComm [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zzl
/// CreatDate：   2022-09-23
/// Description:  查询在院患者每月详情信息
/// Input:        aLocID:科室ID
/// 		 	  aYYMM：在院年月
/// do ##class(%ResultSet).RunQuery("DHCHAI.IRS.WardDetailsSrv","QryPaadmRepByMonth","2022-10","516")
Query QryPaadmRepByMonth(aYYMM As %String, aLocDr As %String) As %Query(ROWSPEC = "BedNum:%String,PaadmID:%String,Name:%String,BH:%String,Sex:%String,Age:%String,Date1:%String,Date2:%String,Date3:%String,Date4:%String,Date5:%String,Date6:%String,Date7:%String,Date8:%String,Date9:%String,Date10:%String,Date11:%String,Date12:%String,Date13:%String,Date14:%String,Date15:%String,Date16:%String,Date17:%String,Date18:%String,Date19:%String,Date20:%String,Date21:%String,Date22:%String,Date23:%String,Date24:%String,Date25:%String,Date26:%String,Date27:%String,Date28:%String,Date29:%String,Date30:%String,Date31:%String") [ SqlProc ]
{
}

ClassMethod QryPaadmRepByMonthExecute(ByRef qHandle As %Binary, aYYMM As %String, aLocDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)	
	Quit:(aYYMM="")||(aLocDr="") $$$OK
    // 取当前月的最大天数
    Set DateFromAndTo=##class(DHCHAI.Utils.CommonSrv).GetMonthStaLastDay(aYYMM)
    Set xDateFrom=$p(DateFromAndTo,"^",1)
	Set xDateTo=$p(DateFromAndTo,"^",2)
    //转换日期
	Set xDateFrom=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(xDateFrom)
	Set xDateTo=##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical(xDateTo)
	//1.获取在该科室当月的患者信息
	//同期在科/病区:某段时间的在科人数
    Set ListLocArray=..GetLocEpisByDate2(xDateFrom,xDateTo,"W",aLocDr,"I")
	//获取患者在当月每天的状态
	For index1=1:1:ListLocArray.Count() {
		Set (BedNum,Paadm,Name,BH,Sex,Age,AdmDate)=""
		Set TransInfo=ListLocArray.GetAt(index1)	
		Continue:TransInfo=""
		
		Set Paadm      = $lg(TransInfo,1)
		Set LocID      = $lg(TransInfo,2)
		Set TransType  = $lg(TransInfo,3)
		Set TransDates = $lg(TransInfo,4)
		Set LnkLocDr   = $lg(TransInfo,5)
		Set TransIDs   = $lg(TransInfo,6)
		Set PaadmInfo=^DHCHAI.DP.PAAdmD(Paadm)
		Continue:PaadmInfo=""
		Set AdmBedID=$lg(PaadmInfo,25)
	    Set:AdmBedID'="" BedNum = $lg(^DHCHAI.BT.PACBedD(AdmBedID),3)
	    Set Name=$lg(PaadmInfo,6)
	    Set BH=$lg(PaadmInfo,5) //病案号
	    Set Sex=$Case($lg(PaadmInfo,7),"M":"男","F":"女",:"")
	    Set Age=$lg(PaadmInfo,37)
	    Set AdmDate=$lg(PaadmInfo,20)  //入院日期    
		Set Data=$lb(BedNum,Paadm,Name,BH,Sex,Age)
		//在DataX中输出 社区感染|上月医院感染且尚未治愈|本月新发医院感染|本月新发另一感染部位|患者在院 0|0|0|0|0
        Set Index11=0
        Set InfPos=""
    	For xDate=xDateFrom:1:xDateTo {
	    	Set InfDateList=""				
			Set PosDescList=""
	    	Set Index11=Index11+1
	    	Set DateX=""
			Quit:(xDate>(+$h))||(xDate>xDateTo)
			//是否在院
			Set InHospital=0
		    If (TransDates[xDate){
			   Set InHospital=1	
		    }
		    //是否发生社区感染
		    Set IsCA=0
		    //本月新发医院感染
		    Set IsHA=0
		    //本月新发另一感染部位
	        Set IsAnother=0
		    Set InfPosDescs =..GetInfPosInfo(Paadm,xDate,xDate)

			If (InfPosDescs'="") {
				for InfNo=1:1:$L(InfPosDescs,"|") {
					Set InfPosMsg=$p(InfPosDescs,"|",InfNo)
	
					continue:InfPosMsg=""
					
					Set DiagID	= $p(InfPosMsg,"^",1)
					Set InfDate	= $p(InfPosMsg,"^",3)
					Set InfType	= $p(InfPosMsg,"^",7)
					Set PosDesc=$p(InfPosMsg,"^",6) //感染部位
					Set InfEffect=$p(InfPosMsg,"^",5) //转归情况
					Set:InfPos="" InfPos=PosDesc
					Set PosDescList=PosDescList_","_PosDesc
					
					Set InfDate=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml(InfDate)
					//Set InfDateList=InfDateList_","_InfDate					
#;					Set:PosDescList'="" PosDescList = $e(PosDescList,2,$l(PosDescList))
#;					Set:InfDateList'="" InfDateList = $e(InfDateList,2,$l(InfDateList))
					If (PosDesc'=InfPos){
						Set IsAnother=1
						Set PosDescList=PosDesc
						Set InfDateList=InfDate
						}
					If (InfType="社区感染"){
						Set IsCA=1
						Set PosDescList=PosDesc
						Set InfDateList=InfDate
						}
					elseif(InfType="医院感染"){
						Set IsHA=1
						Set PosDescList=PosDesc
						Set InfDateList=InfDate
						}
				}
			}
		    //上月医院感染且尚未治愈
		    Set IsNotCure=0  
		    If (Index11=1){
			    Set IsNotCureStr=..GetInfPosState(Paadm,xDate-1)
			    Set IsNotCure=$p(IsNotCureStr,"&",1)
			    If (IsNotCure=1){
				   Set PosDescList=$p(IsNotCureStr,"&",2)
				   Set InfDateList=##Class(DHCHAI.IO.FromHisSrv).DateLogicalToHtml($p(IsNotCureStr,"&",3))
				}
		    }
	        Set DateX=IsCA_"|"_IsNotCure_"|"_IsHA_"|"_IsAnother_"|"_InHospital_"|"_PosDescList_"|"_InfDateList
	        Set Data=Data_$lb(DateX)
   		}
		Set ^CacheTemp(repid,ind)=Data
    	Set ind=ind+1
	}
	//Kill ^TMP($zn,$j,NIndex)
	Quit $$$OK
}

ClassMethod QryPaadmRepByMonthClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPaadmRepByMonthExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryPaadmRepByMonthFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPaadmRepByMonthExecute ]
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

/// Creator：     zzl
/// CreatDate：   2022-09-30
/// Description:  判断患者是否处于感染状态(治愈或死亡)s
/// Table：       DHCHAI.DP.PAAdm、DHCHAI.IR.INFReport
/// Input:        aEpisodeID：就诊ID
/// return:       感染部位信息
/// w ##class(DHCHAI.IRS.WardDetailsSrv).GetInfPosStae("664",##Class(DHCHAI.IO.FromHisSrv).DateHtmlToLogical("2020-06-31"))
ClassMethod GetInfPosState(aEpisodeID As %String, aDate As %String) As %String
{
	New (aEpisodeID,aDate)
	Set return=""
	Quit:(aEpisodeID="") return
	Quit:(aDate="")
	Set RepType=""
	Set InfSate=0 //0为治愈 1为未治愈
	For {
		Set RepType=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType))
		Quit:RepType=""
		Continue:(RepType'="1") //1为院感报告
		Set xID = ""
		For {
			Set xID=$o(^DHCHAI.IR.INFReportI("IndexPaadmType",aEpisodeID,RepType,xID))
			Quit:xID=""
			// Add by zhaoyj 2022-06-15 Global方式
			Set INFRepData=$g(^DHCHAI.IR.INFReportD(xID))
			Quit:INFRepData=""
			Set RepStatus=$lg(INFRepData,8)
			Continue:RepStatus=""        //1 保存 2 提交 3 审核 4 作废
			Continue:$lg($g(^DHCHAI.BT.DictionaryD(RepStatus)),2)'="3"
			// 感染诊断信息
			Set LinkDiags=""
			Set xSub=0
			For {
				Set xSub=$o(^DHCHAI.IR.INFReportI("EXT","IndexDataType"," "_$zcvt("DHCHAI.IR.INFDiagnos","U"),xID,xSub))
				Quit:xSub=""
		
				Set INFRepExtData=$g(^DHCHAI.IR.INFReportD(xID,"EXT",xSub))
				Continue:INFRepExtData=""
				Set DataID=$lg(INFRepExtData,3)
				Continue:DataID=""
				Set LinkDiags=LinkDiags_","_DataID
			}
			Set:LinkDiags'="" LinkDiags=$e(LinkDiags,2,$l(LinkDiags))
			
			For indx = 1:1:$l(LinkDiags,","){
				Set xDiagID = $p(LinkDiags,",",indx)
				Continue:xDiagID=""
				
				Set DiagsData = $g(^DHCHAI.IR.INFDiagnosD(xDiagID))
				Continue:DiagsData=""
				Continue:$lg(DiagsData,3)=""  //20211217 处理感染诊断变化导致的bug	
                //转归情况
                Set InfEffect=""
                Set IRInfEffectDr=$lg(DiagsData,8)
                If (IRInfEffectDr'=""){
                    Set IRInfEffectData=$g(^DHCHAI.BT.DictionaryD(IRInfEffectDr))
                    Set:IRInfEffectData'="" InfEffect = $lg(IRInfEffectData,3)
                }
                //感染类别
				Set InfType="医院感染"
				Set InfTypeCode=$lg($g(^DHCHAI.IR.INFDiagnosD(xDiagID)),18)
				if (InfTypeCode'=""){
					Set:InfTypeCode=0 InfType="社区感染"
				}else{
					Set AdmDate=$lg($g(^DHCHAI.DP.PAAdmD(aEpisodeID)),20)
			   		Set:InfDate-AdmDate<2 InfType="社区感染"  //社区感染判断
				}
				// 感染日期
				Set InfDate  = $lg(DiagsData,5)
				// 感染诊断
				Set InfPos = $lg(DiagsData,3)
				Set InfPosData=$g(^DHCHAI.BT.InfPosD(InfPos))
				Continue:InfPosData=""
				Set PosCode=$lg(InfPosData,2)
				Set BigCode=$e(PosCode,1,2)
				Set PosDiagData=""
				Set PosDr=$o(^DHCHAI.BT.InfPosI("IdxofCode",BigCode,0))
				Set:PosDr'="" PosDiagData=$g(^DHCHAI.BT.InfPosD(PosDr))
				Set PosDesc=$lg(PosDiagData,3)
				//转归日期
				Set InfXDate  = $lg(DiagsData,7)
                Continue:(aDate'="")&&(InfDate>aDate)                   //感染日期大于调查结束日期表明感染还未开始
#;                If ((InfType="医院感染")&&((InfEffect="治愈")||(InfEffect="死亡"))){    //只有治愈和死亡才算结束
#;                    Set:+InfXDate'=0 InfSate=0
#;                }
                  If ((InfType="医院感染")&&((InfEffect'="治愈")&&(InfEffect'="死亡"))){
	                Set InfSate=1_"&"_PosDesc_"&"_InfDate
	                }	
			}
		}
	}
    Set return=InfSate
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2022-06-08
/// Description:  取科室一段时间新入、在院、出院就诊接口
/// Table：       DHCHAI.DP.PAAdmTrans
/// Input：       aDateFrom : 开始日期
///               aDateTo : 结束日期
///               aLocType : 科室类型（科室E、病区W）
///               aLocID : 科室/病区ID（DHCHAI.BT.Location.ID）
///               aAdmType : 就诊类型（住院I、门诊O）
///               aOutType : 输出类型（A在科、A2在科、I入科、O出科）
/// Return：      返回%List 调整住院人数规则 当天入科计入住院人数，天数不计入
/// zw ##class(DHCHAI.STATV2.AbstractComm).GetLocEpisByDate2($zdh("2020-05-25",3),$zdh("2020-05-25",3),"W","29","I")
ClassMethod GetLocEpisByDate2(aDateFrom As %String, aDateTo As %String, aLocType As %String, aLocID As %String, aAdmType As %String, aOutType As %String = "", ByRef aMsgErr As %String = "") As %Library.ArrayOfDataTypes
{
	New (aDateFrom,aDateTo,aLocType,aLocID,aAdmType,aOutType,aMsgErr)
	Set return=##Class(%Library.ArrayOfDataTypes).%New()
	Quit:(aDateFrom="")||(aDateTo="") return
	Quit:(aLocType="")&&(aLocID="") return
	
	Set ZIndex=$zn,JIndex=$j,NIndex="GetLocEpisByLocDate"
	Kill ^TMP(ZIndex,JIndex,NIndex)
	
	Set $ZT="GetLocEpisByLocDateErr"
	
	If aLocID'="" {
		Set LocData=$g(^DHCHAI.BT.LocationD(aLocID))
		Quit:LocData="" return
		Set BTTypeDr=$lg(LocData,5)
		Quit:BTTypeDr="" return
		Set LocType=$lg($g(^DHCHAI.BT.DictionaryD(BTTypeDr)),2)
		Quit:LocType'=aLocType return
	} Else {
		Set aLocType=$zcvt(aLocType,"U")
		Quit:(aLocType'="W")&(aLocType'="E") return
	}
	
	Set:aAdmType'="" aAdmType="|"_aAdmType_"|"
	//Set:aOutType="" aOutType="A|A2|O"  //默认输出在科+出科，不输出入科
	Set:aOutType="" aOutType="A|A2|O|I"  //默认输出在科+出科+入科 调整20210705
	Set:aOutType'="" aOutType="|"_aOutType_"|"
   
	//启用虚拟病区查询
	Set IsStatParWard=##class(DHCHAI.BT.Config).GetValByCode("StatParWard")	
	Set xTransType=""
	For {
		Set xTransType=$o(^DHCHAI.DP.PAAdmTransI("IndexTransDaysDate",xTransType))
		Quit:xTransType=""
		Continue:(xTransType="B")&&(IsStatParWard'=1) //转床信息
		Continue:(aLocType'="")&&(xTransType'=aLocType)&&(IsStatParWard'=1)
		Continue:(xTransType="W")&&(IsStatParWard=1)
		
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
					
					;Set objTrans=##class(DHCHAI.DP.PAAdmTrans).GetObjById(xTransID)
					;Continue:'$isobject(objTrans)
					;Continue:'$isobject(objTrans.PAEpisodeDr)
					Set TranData=$g(^DHCHAI.DP.PAAdmTransD(xTransID))
					Continue:TranData=""
					Set EpisodeDr=$lg(TranData,3)	//objTrans.PAEpisodeDr.%Id()
					Continue:EpisodeDr=""
					//没有分配床位的不算
					//Continue:'$d(^DHCHAI.DP.PAAdmTransI("IndexTransID","B",EpisodeDr))  //update 20230207 日间病房患者存在不分床的患者，就诊结束为D
					Set AdmData=$g(^DHCHAI.DP.PAAdmD(EpisodeDr))
					Continue:AdmData=""
					Set AdmStatus=$lg(AdmData,19)
					Continue:(AdmStatus="C")||(AdmStatus="P") //update 20230207 入院未分床的患者统一处理为预住院的患者
					Set AdmDate =$lg(AdmData,20)
					Set AdmType=$lg(AdmData,18)	;objTrans.PAEpisodeDr.PAAdmType
					Continue:(aAdmType'="")&(aAdmType'[("|"_AdmType_"|"))  //EP急诊留观、I住院、O门诊、E急诊流水
					;Continue:'$isobject(objTrans.PATransLocDr)
					;Continue:'$isobject(objTrans.PATransLocDr.BTTypeDr)
					;Set TransLocDr=objTrans.PATransLocDr.%Id()
					Set TransLocDr=$lg(TranData,5)	;objTrans.PATransLocDr.%Id()
					Continue:TransLocDr=""
					Continue:$lg($g(^DHCHAI.BT.LocationD(TransLocDr)),5)=""	
					If (IsStatParWard=1)&&(aLocType'="E") {
						Set TransBedDr=$lg(TranData,6)	
						Continue:TransBedDr=""
						Set TransBedInfo = $g(^DHCHAI.BT.PACBedD(TransBedDr))
						Continue:TransBedInfo=""
						Set TransLocDr = $lg(TransBedInfo,11)
						Continue:TransLocDr=""
					}									
					Continue:(aLocID'="")&&(TransLocDr'=aLocID)
					
					;Set EpisodeDr=objTrans.PAEpisodeDr.%Id()
					Set TransDate=$lg(TranData,7)	;objTrans.PATransDate
					Set:TransDate<AdmDate TransDate=AdmDate    //按分床取入院时，转入科室日期早于入院日期不计入统计
					Set TransTime=$lg(TranData,8)	;objTrans.PATransTime
					Set TransTime=+TransTime
					Set:TransTime=0 TransTime=1
					Set OutLocDate=$lg(TranData,10)	;objTrans.PAOutLocDate
					Set OutLocTime=$lg(TranData,11)	;objTrans.PAOutLocTime
					//add 20221028 处理出院后转科未结束或出院后再产生的转科记录
					Set DischDate = $lg(AdmData,26)
					Continue:(AdmStatus="D")&(AdmDate>DischDate)
					Set:(AdmStatus="D")&(OutLocDate="") OutLocDate=DischDate
					Set:(AdmStatus="D")&(OutLocDate>DischDate) OutLocDate=DischDate  	
					
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
	                   	//Continue:(xTransType="W")&&($d(^TMP(ZIndex,JIndex,NIndex,"InvTransEpis",EpisodeDr,xDate)))
						Set ^TMP(ZIndex,JIndex,NIndex,"TransLocEpis",EpisodeDr,TransLocDr,xDate,xTransID)=""
						 
						If (xDate'=TransDate)&&(xDate'=OutLocDate) {      //在科A
							Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"A",TransTime,xTransID)=""
						} ElseIf (xDate=TransDate)&&(xDate=OutLocDate) {  //在科A2
							Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"A2",TransTime,xTransID)=""
						} Else {
							If xDate=TransDate {   //入科
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"I"))
								Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"I",TransTime,xTransID)=""
							}
							If xDate=OutLocDate {  //出科
								Set num=$i(^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"O"))
								Set ^TMP(ZIndex,JIndex,NIndex,"TransEpis",EpisodeDr,TransLocDr,xDate,"O",OutLocTime,xTransID)=""
							}
						}
					}
				}
			}
		}
	}
	
	Set Count=0
	Set xEpisodeDr=0
	//增加过滤特定患者如测试患者支持登记号、姓名、病案号 chenjb 20210714
	//w ##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
	Set aExPaAdm=##class(DHCHAI.BT.Config).GetValByCode("ExceptPaAdm")
	For {
		Set xEpisodeDr=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr))
		Quit:xEpisodeDr=""		
		If aExPaAdm'="" 
		{
			Set anPAAdmData=$g(^DHCHAI.DP.PAAdmD(xEpisodeDr))
			Continue:anPAAdmData=""			
			Set anPapmiNo = $lg(anPAAdmData,4)  //登记号
			Set anMrNo = $lg(anPAAdmData,5)     //病案号
			Set anPatName = $lg(anPAAdmData,6)  //姓名
			Continue:(anPapmiNo'="")&(aExPaAdm[anPapmiNo)			
			Continue:(anMrNo'="")&(aExPaAdm[anMrNo)
			Continue:(anPatName'="")&(aExPaAdm[anPatName)
		}
		Set xLocDr=""
		For {
			Set xLocDr=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr))
			Quit:xLocDr=""
			
			Set TransDates="",LnkLocDr="",TransIDs=""
			Set xDate=""
			For {
				Set xDate=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate))
				Quit:xDate=""
				
				Set TransID=""
				Set ICnt=+$g(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,"I"))
				Set OCnt=+$g(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,"O"))
				If ICnt>OCnt {
					Set xStatus="I"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,xTime,""))
				} ElseIf ICnt<OCnt {
					Set xStatus="O"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,""),-1)
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,xTime,""),-1)
				} ElseIf (ICnt=OCnt)&(ICnt>0) {
					//说明：先出再入，并且"转入次数=转出次数"，这种算在院A
					//      先入再出，并且"转入次数=转出次数"，这种算在院A2
					Set tStatus="O",xStatus="A"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,tStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,tStatus,xTime,""))
				} Else {
					Set xStatus="A"
					Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,""))
					Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,xTime,""))
					If TransID="" {
						Set xStatus="A2"
						Set xTime=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,""))
						Set:xTime'="" TransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransEpis",xEpisodeDr,xLocDr,xDate,xStatus,xTime,""))
					}
				}
				Continue:TransID=""
				Continue:aOutType'[("|"_xStatus_"|")
				
				If aLocType="W" {
					Set TranData=$g(^DHCHAI.DP.PAAdmTransD(TransID))
					Set LnkLocDr=$lg(TranData,14)
				}
				//增加判断入科当天不算住院日天数,住院天数按零点计算
				if (xStatus'="I")&&(xStatus'="A2") {   
					Set:TransDates'="" TransDates=TransDates_","_xDate
					Set:TransDates="" TransDates=xDate
				}
				//附带每个在科记录的相关转科信息
				Set:(","_TransIDs_",")'[(","_TransID_",") TransIDs=TransIDs_","_TransID
				Set xTransID=""
				For {
					Set xTransID=$o(^TMP(ZIndex,JIndex,NIndex,"TransLocEpis",xEpisodeDr,xLocDr,xDate,xTransID))
					Quit:xTransID=""
					Continue:xTransID=TransID
					Set:(","_TransIDs_",")'[(","_xTransID_",") TransIDs=TransIDs_","_xTransID
				}
			}

			//Continue:TransDates=""  //如果是当天入科的，非当天出不返回
			Set:TransIDs'="" TransIDs=$e(TransIDs,2,$l(TransIDs))
			Set Count=Count+1
		    Set LocEpidInfo=$lb(xEpisodeDr,xLocDr,aLocType,TransDates,LnkLocDr,TransIDs)
			Do return.SetAt(LocEpidInfo,Count)
		}
	}
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Quit return
	
GetLocEpisByLocDateErr
    Set $ZT=""
	Set aMsgErr=$Zerror
	Kill ^TMP(ZIndex,JIndex,NIndex)
	Do return.Clear()
	Quit return
}

}
