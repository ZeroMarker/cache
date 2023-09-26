/// 名称: DHCMA.Util.IO.EnsSyncLis2Srv
/// 描述: 东华数据中心--检验结果接口服务
/// 编写者：zhufei
/// 编写日期: 2020-03-06
Class DHCMA.Util.IO.EnsSyncLis2Srv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2020-03-06
/// Description:  查询检验结果信息
/// Table：       无
/// Input：       aEpisodeID ：就诊号
///               aDateFrom  ：开始日期
///               aDateTo    ：截止日期
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.Util.IO.EnsSyncLis2Srv","QryLabVisitRepItem","25","2020-01-01","2020-04-28")
Query QryLabVisitRepItem(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTCCodes As %String = "") As %Query(ROWSPEC = "ReportID:%String,VisitNumberID:%String,EpisodeID:%String,EpisodeNo:%String,SpecCode:%String,SpecDesc:%String,LocID:%String,LocDesc:%String,CollDate:%String,CollTime:%String,CollUserCode:%String,CollUserName:%String,RecDate:%String,RecTime:%String,RecUserCode:%String,RecUserName:%String,WardID:%String,WardDesc:%String,TestSetStr:%String,TestSetRow:%String,Order:%String,RepStatus:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserName:%String,AuthDate:%String,AuthTime:%String,AuthUserCode:%String,AuthUserName:%String,TCResultID:%String,TCID:%String,TCCode:%String,TCDesc:%String,TCRstFormat:%String,TCResult:%String,TCUnit:%String,TCTextRes:%String,TCAbFlag:%String,TCRefRanges:%String")
{
}

ClassMethod QryLabVisitRepItemExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aTCCodes As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aEpisodeID="" $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aTCCodes=$g(aTCCodes)
	
	Set AdmStr=$g(^PAADM(aEpisodeID))
	Set AdmType= $p(AdmStr,"^",2)	   //就诊类型
	Quit:(AdmType'="I")&(AdmType'="E")&(AdmType'="O")&(AdmType'="H") $$$OK
	
	Set xID=0
	For {
		Set xID=$o(^Busi.ENS.EnsLISReportResultI("LISRRVisitNumberIndex",aEpisodeID,xID))
		Quit:xID=""
		
		Set ReportData=$g(^Busi.ENS.EnsLISReportResultD(xID))
		Continue:ReportData=""
		Set Status=$lg(ReportData,117)       //状态（1审核、2取消审核、3作废）
		Continue:Status'=1
		Set CollectDate=$lg(ReportData,48)   //采集日期
		Set ReceiveDate=$lg(ReportData,65)   //接收日期
		Set CheckDate=$lg(ReportData,107)    //审核日期
		Set UpdateDate=$lg(ReportData,104)   //时间戳 更新日期
		//采集日期、接收日期和审核日期都不在查询日期范围内
		If (aDateFrom'=""){
			Continue:(CollectDate<aDateFrom)&(ReceiveDate<aDateFrom)&(CheckDate<aDateFrom)
		}
		If (aDateTo'=""){
			Continue:(CollectDate>aDateTo)&(ReceiveDate>aDateTo)&(CheckDate>aDateTo)
		}
		
		Set objReport=##class(User.EnsLISReportResult).%OpenId(xID)
		Continue:'$IsObject(objReport)
		Do objReport.%Close()
		
		Set TestSetCode   = ""                              // 检验医嘱代码
		Set TestSetDesc   = objReport.LISRROrderItemDesc	// 检验医嘱名称
		Set CollDate      = objReport.LISRRCollectDate	    // 采集日期
		Set CollTime      = objReport.LISRRCollectTime	    // 采集时间
		Set SpecCode      = objReport.LISRRSpecimenID	    // 标本代码
		Set SpecDesc      = objReport.LISRRSpecimenDesc	    // 标本名称
		Set EpisodeNo     = objReport.LISRRRequestNo        // 标本号(申请单号)
		Set LabResume     = objReport.LISRRReqNotes	        // 检验备注(申请备注)
		Set CollDocCode   = objReport.LISRRCollectUserCode	// 采集人代码
		Set CollDocDesc   = objReport.LISRRCollectUserDesc	// 采集人名称
		Set RecDate       = objReport.LISRRReceiveDate	    // 接收日期
		Set RecTime       = objReport.LISRRReceiveTime	    // 接收时间
		Set RecDocCode    = objReport.LISRRReceiveUserCode	// 接收人代码
		Set RecDocDesc    = objReport.LISRRReceiveUserDesc	// 接收人姓名
		Set RegDate       = objReport.LISRRFirstCheckDate	// 报告日期/录入日期/初审日期
		Set RegTime       = objReport.LISRRFirstCheckTime	// 报告时间/录入时间/初审时间
		Set AuthDate      = objReport.LISRRCheckDate	    // 审核日期
		Set AuthTime      = objReport.LISRRCheckTime	    // 审核时间
		Set AuthUserCode  = objReport.LISRRCheckUserCode	// 审核人代码
		Set AuthUserDesc  = objReport.LISRRCheckUserDesc	// 审核人姓名
		Set RepResume     = objReport.LISRRRemarks       	// 报告备注
		Set LabPurpose    = ""                          	// 检验目的
		Set LabResult     = objReport.LISRRIdentifition     // 检验结果/鉴定结果
		Set LabRepNo      = objReport.LISRROrder	        // 报告序号
		Set RepDepCode    = objReport.LISRRDeptCode	        // 报告科室代码
		Set RepDepDesc    = objReport.LISRRDeptName	        // 报告科室名称
		Set StatusCode    = objReport.LISRRStatus           // 报告状态代码
		Set StatusDesc    = $s(StatusCode=1:"审核",StatusCode=2:"取消审核",StatusCode=3:"作废",1:"") // 报告状态名称
		
		//取HIS的医嘱
		Set TestSetStr=""
		Set TestSetRow    = ""                              // 医嘱号
		Set VisitNumberID = ""                              // 接收记录ID
		Set ReportID      = objReport.LISRRReportID	        // 报告号
		//标本号
		Set xSpecimenID=""
		Set xSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_ReportID,""))
		Set xOEItemID=""
		For {
			Set xOEItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_ReportID,xSpecimenID,xOEItemID))
			Quit:xOEItemID=""
		
			Set ArcimCode="",ArcimDesc=""
			Set ArcimID=$p($g(^OEORD(+xOEItemID,"I",+$p(xOEItemID,"||",2),1)),"^",2)
			If ArcimID'="" {
				Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)		//医嘱项代码
				Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)		//医嘱项名称
			}
			Set TestSetStr=TestSetDesc_"#"_TestSetDesc_"#"_ArcimCode_"#"_ArcimDesc_"#"_xOEItemID
			
			Set TestSetRow=$p($g(^OEORD(+xOEItemID,"I",+$p(xOEItemID,"||",2),3)),"^",35)
		}
		Set:EpisodeNo="" EpisodeNo =$tr(xSpecimenID," ","")   //标本号(申请单号)
		
		Set ReportData=$lb(ReportID)                  // 报告ID
		Set ReportData=ReportData_$lb(VisitNumberID)  // 接收标本ID
		Set ReportData=ReportData_$lb(aEpisodeID)     // 就诊号
		Set ReportData=ReportData_$lb(EpisodeNo)      // 标本号
		Set ReportData=ReportData_$lb(SpecCode)       // 标本代码
		Set ReportData=ReportData_$lb(SpecDesc)       // 标本名称
		Set ReportData=ReportData_$lb(RepDepCode)     // 科室代码
		Set ReportData=ReportData_$lb(RepDepDesc)     // 科室名称
		Set ReportData=ReportData_$lb(CollDate)       // 采集日期
		Set ReportData=ReportData_$lb(CollTime)       // 采集时间
		Set ReportData=ReportData_$lb(CollDocCode)    // 采集人代码
		Set ReportData=ReportData_$lb(CollDocDesc)    // 采集人名称
		Set ReportData=ReportData_$lb(RecDate)        // 接收日期
		Set ReportData=ReportData_$lb(RecTime)        // 接收时间
		Set ReportData=ReportData_$lb(RecDocCode)     // 接收人代码
		Set ReportData=ReportData_$lb(RecDocDesc)     // 接收人名称
		Set ReportData=ReportData_$lb("")             // 病区代码
		Set ReportData=ReportData_$lb("")             // 病区名称
		Set ReportData=ReportData_$lb(TestSetStr)     // 检验医嘱信息
		Set ReportData=ReportData_$lb(OEItemID)       // 医嘱号
		Set ReportData=ReportData_$lb(indRep)         // 报告顺序号 Order
		Set ReportData=ReportData_$lb(StatusCode)     // 报告状态代码
		Set ReportData=ReportData_$lb(RegDate)        // 录入日期
		Set ReportData=ReportData_$lb(RegTime)        // 录入时间
		Set ReportData=ReportData_$lb("")             // 录入人代码
		Set ReportData=ReportData_$lb("")             // 录入人名称
		Set ReportData=ReportData_$lb(AuthDate)       // 审核日期
		Set ReportData=ReportData_$lb(AuthTime)       // 审核时间
		Set ReportData=ReportData_$lb(AuthUserCode)   // 审核人代码
		Set ReportData=ReportData_$lb(AuthUserName)   // 审核人姓名
		Set xTCCode=""
		For {
			Set xTCCode=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",ReportID,xTCCode))
			Quit:xTCCode=""
			
			Set xRstID=0
			For {
				Set xRstID=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",ReportID,xTCCode,xRstID))
				Quit:xRstID=""
				Set objResult=##class(User.EnsLISItemResult).%OpenId(xRstID)
				Continue:'$IsObject(objResult)
				Do objResult.%Close()
				
				Set TCCode    = objResult.LISIRItemCode         // 检验项目代码
				Set TCDesc    = objResult.LISIRItemDesc         // 检验项目名称
				Continue:(aTCCodes'="")&((","_aTCCodes_",")'[(","_TCCode_","))  //根据项目过滤
				Set RstFormat = objResult.LISIRResClass         // 结果类型
				Set Result    = objResult.LISIRResult           // 定量结果
				Set Unit      = objResult.LISIRUint             // 结果单位
				Set TextRes   = objResult.LISIRTextResult       // 定性结果
				Set RefRanges = objResult.LISIRRanges           // 参考值范围
				Set AbFlag    = objResult.LISIRAbnormalFlags    // 异常标志
				Continue:(Result="")&&(TextRes="")
				Set ResultID  = xRstID   // 检验结果ID
				
				Set ResultData=$lb(ResultID)                   // xResultID
				Set ResultData=ResultData_$lb("")              // xTID
				Set ResultData=ResultData_$lb(TCCode)          // 检验项目代码
				Set ResultData=ResultData_$lb(TCDesc)          // 检验项目名称
				Set ResultData=ResultData_$lb(RstFormat)       // 结果类型
				Set ResultData=ResultData_$lb(Result)          // 定量结果
				Set ResultData=ResultData_$lb(Unit)            // 结果单位
				Set ResultData=ResultData_$lb(TextRes)         // 定性结果
				Set ResultData=ResultData_$lb(AbFlag)          // 异常标志
				Set ResultData=ResultData_$lb(RefRanges)       // 参考值范围
			    
				Set ^CacheTemp(repid,ind)=ReportData_ResultData
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryLabVisitRepItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLabVisitRepItemExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLabVisitRepItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLabVisitRepItemExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2019-09-25
/// Description:  生成新的检验项目、检验医嘱字典
/// Table：       DHCMA.Util.EPx.TestCode、DHCMA.Util.EPx.TestSet
/// Input：       aInputStr    ：检验项目与检验医嘱信息
/// Output：      返回结果类型
/// w ##class(DHCMA.Util.IO.EnsSyncLis1Srv).NewTSAndTCDic(3,"D0700116^抗酸染色(直接涂片)^^^SP146^CVC(中心静脉导管)-C^细菌4^细菌4^V^^")
ClassMethod NewTSAndTCDic(aSYSDr As %String, aInputStr As %String) As %String
{
	New (aSYSDr,aInputStr)
	Set return=""
	Quit:(aSYSDr="")||(aInputStr="") return
	
	Set TSCode    = $p(aInputStr,"^",1)
	Set TSDesc    = $p(aInputStr,"^",2)
	Set:TSDesc="" TSDesc=TSCode
	Set:TSCode="" TSCode=TSDesc
	Set ARCCode   = $p(aInputStr,"^",3)
	Set ARCDesc   = $p(aInputStr,"^",4)
	Set SpecCode  = $p(aInputStr,"^",5)
	Set SpecDesc  = $p(aInputStr,"^",6)
	Set:SpecDesc="" SpecDesc=SpecCode
	Set:SpecCode="" SpecCode=SpecDesc
	Set TCCode    = $p(aInputStr,"^",7)
	Set TCDesc    = $p(aInputStr,"^",8)
	Set:TCDesc="" TCDesc=TCCode
	Set:TCCode="" TCCode=TCDesc
	Set RstFormat = $p(aInputStr,"^",9)
	Set AbFlag    = $p(aInputStr,"^",10)
	Set RefRanges = $p(aInputStr,"^",11)
	If (RstFormat="")||(RstFormat="T") {
		Set RstFormat="T"
		If RefRanges'="" {
			If $l(RefRanges,"-")=2 {
				If (RefRanges'["(-)"){
					Set RstFormat="N"
				}
			}
		}
	}
	Quit:(TCCode="") return
	
	Set $ZT="NewTSAndTCDicErr"
	
	TStart
	
	//生成检验项目字典
	Set TCOID=TCCode_"!!"_aSYSDr
	Set objTC=##class(DHCMA.Util.EP.TestCode).xGetByOID(TCOID)
	If $IsObject(objTC) {
		Set TCDr=objTC.%Id()
		Set AbFlagS=objTC.BTAbFlagS
		If (AbFlagS'[AbFlag)&&(AbFlag'="") {
			//处理异常标志
			If AbFlagS'="" {
				Set AbFlagS=AbFlagS_","_AbFlag
			} Else {
				Set AbFlagS=AbFlag
			}
			Set TCCode=objTC.BTCode
			Set TCDesc=objTC.BTDesc
			Set ClDiagnos=objTC.BTClDiagnos
			Set RefRanges=objTC.BTRefRanges
			Set RstFormat=objTC.BTRstFormat
			Set WCode=objTC.BTWCode
			Set IsActive=objTC.BTIsActive
			Set ActUserID=objTC.BTActUserID
			
			Set InputStr=""
			Set $p(InputStr,"^",1)=TCDr       //ID
			Set $p(InputStr,"^",2)=TCOID      //OID
			Set $p(InputStr,"^",3)=TCCode     //项目代码
			Set $p(InputStr,"^",4)=TCDesc     //项目名称
			Set $p(InputStr,"^",5)=RstFormat  //结果类型
			Set $p(InputStr,"^",6)=AbFlagS    //异常标志
			Set $p(InputStr,"^",7)=ClDiagnos  //临床意义
			Set $p(InputStr,"^",8)=RefRanges  //参考值范围
			Set $p(InputStr,"^",9)=WCode      //缩写码
			Set $p(InputStr,"^",10)=+IsActive //是否有效
			Set $p(InputStr,"^",11)=ActUserID //更新人
			Set flg=##class(DHCMA.Util.EPx.TestCode).Update(InputStr,"^")
			If (+flg)<1 {
				TRollback
				Quit return
			}
		}
	} Else {
		Set InputStr=""
		Set $p(InputStr,"^",1)=""         //ID
		Set $p(InputStr,"^",2)=TCOID      //OID
		Set $p(InputStr,"^",3)=TCCode     //项目代码
		Set $p(InputStr,"^",4)=TCDesc     //项目名称
		Set $p(InputStr,"^",5)=RstFormat  //结果类型
		Set $p(InputStr,"^",6)=AbFlag     //异常标志
		Set $p(InputStr,"^",7)=""         //临床意义
		Set $p(InputStr,"^",8)=RefRanges  //参考值范围
		Set $p(InputStr,"^",9)=""         //唯一码
		Set $p(InputStr,"^",10)=1         //是否有效
		Set $p(InputStr,"^",11)=""        //更新人
		Set flg=##class(DHCMA.Util.EPx.TestCode).Update(InputStr,"^")
		If (+flg)<1 {
			TRollback
			Quit return
		}
		Set TCDr=+flg
	}
	
	//生成检验医嘱字典
	Set TSDr=""
	If TSCode'="" {
		Set TSOID=TSCode_"!!"_aSYSDr
		Set objTS=##class(DHCMA.Util.EP.TestSet).xGetByOID(TCOID)
		If $IsObject(objTS) {
			Set TSDr=objTS.%Id()
		} Else {
			Set InputStr=""
			Set $p(InputStr,"^",1)=""        //ID
			Set $p(InputStr,"^",2)=TSOID     //OID
			Set $p(InputStr,"^",3)=TSCode    //检验医嘱代码
			Set $p(InputStr,"^",4)=TSDesc    //检验医嘱名称
			Set $p(InputStr,"^",5)=ARCCode   //医嘱代码
			Set $p(InputStr,"^",6)=ARCDesc   //医嘱名称
			Set $p(InputStr,"^",7)=1         //是否有效
			Set $p(InputStr,"^",8)=""        //更新人
			Set flg=##class(DHCMA.Util.EPx.TestSet).Update(InputStr,"^")
			If (+flg)<1 {
				TRollback
				Quit return
			}
			Set TSDr=+flg
		}
	}
	
	//生成检验项目与检验医嘱对照关系
	If (TSDr'="")&&(TCDr'="") {
		If '$d(^DHCMA.Util.EPx.TestSetTCI("IdxOfTestSetTC",TSDr,TCDr)){
			Set flg=##class(DHCMA.Util.EPx.TestSetTC).Update("^"_TSDr_"^"_TCDr,"^")
			If (+flg)<1 {
				TRollback
				Quit return
			}
		}
	}
	
	//生成送检标本字典
	If SpecCode'="" {
		Set SpecOID=SpecCode_"!!"_aSYSDr
		Set objSpec=##class(DHCMA.Util.EP.Specimen).xGetByOID(SpecOID)
		If $IsObject(objSpec) {
			Set SpecDr=objSpec.%Id()
		} Else {
			Set InputStr=""
			Set $p(InputStr,"^",1)=""        //ID
			Set $p(InputStr,"^",2)=SpecOID   //OID
			Set $p(InputStr,"^",3)=SpecCode  //标本代码
			Set $p(InputStr,"^",4)=SpecDesc  //标本名称
			Set $p(InputStr,"^",5)=1         //是否有效
			Set $p(InputStr,"^",6)=""        //更新人
			Set flg=##class(DHCMA.Util.EPx.Specimen).Update(InputStr,"^")
			If (+flg)<1 {
				TRollback
				Quit return
			}
			Set SpecDr=+flg
		}
	}
	
	TCommit
	
	Set return=TCDr
	Quit return
	
NewTSAndTCDicErr
	TRollback
	Quit ""
}

/// Creator：     zhufei
/// CreatDate：   2019-09-25
/// Description:  自动批量生成新的检验项目、检验医嘱字典
/// Table：       DHCMA.Util.EPx.TestCode、DHCMA.Util.EPx.TestSet
/// Input：       aInputStr    ：检验项目与检验医嘱信息
/// Output：      返回结果类型
/// w ##class(DHCMA.Util.IO.EnsSyncLis2Srv).AutoNewTSAndTCDic("2020-01-01","2020-04-28")
ClassMethod AutoNewTSAndTCDic(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:(aDateFrom="")||(aDateTo="") return
	Set aDateFrom=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateFrom)
	Set aDateTo=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(aDateTo)

	Set SYSDr=##class(DHCMA.Util.BTS.SYSTEMSrv).GetSYSDr("LIS01")
	Quit:SYSDr="" return
	
	Set xUpdateDate=aDateFrom-1
	For {
		Set xUpdateDate=$o(^Busi.ENS.EnsLISReportResultI("LISRRUpdateTimeIndex",xUpdateDate))
		Quit:xUpdateDate=""
		Quit:xUpdateDate>aDateTo
		
		Set xUpdateTime=""
		For {
			Set xUpdateTime=$o(^Busi.ENS.EnsLISReportResultI("LISRRUpdateTimeIndex",xUpdateDate,xUpdateTime))
			Quit:xUpdateTime=""
			
			Set xID=0
			For {
				Set xID=$o(^Busi.ENS.EnsLISReportResultI("LISRRUpdateTimeIndex",xUpdateDate,xUpdateTime,xID))
				Quit:xID=""
				
				Set objReport=##class(User.EnsLISReportResult).%OpenId(xID)
				Continue:'$IsObject(objReport)
				Do objReport.%Close()
				
				Set TestSetCode   = ""                              // 检验医嘱代码
				Set TestSetDesc   = objReport.LISRROrderItemDesc	// 检验医嘱名称
				Set SpecCode      = objReport.LISRRSpecimenID	    // 标本代码
				Set SpecDesc      = objReport.LISRRSpecimenDesc	    // 标本名称
				
				//取HIS的医嘱
				Set ArcimCode="",ArcimDesc=""
				Set ReportID      = objReport.LISRRReportID	        // 报告号
				
				//标本号
				Set xSpecimenID=""	
				Set xSpecimenID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_ReportID,""))
				Set xOEItemID=""
				For {
					Set xOEItemID=$o(^Busi.ENS.EnsLISSpecimenReportI("LISSPECIMENREPORTPKey"," "_ReportID,xSpecimenID,xOEItemID))
					Quit:xOEItemID=""
					
					Set ArcimID=$p($g(^OEORD(+xOEItemID,"I",+$p(xOEItemID,"||",2),1)),"^",2)
					If ArcimID'="" {
						Set ArcimCode=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",1)		//医嘱项代码
						Set ArcimDesc=$p($g(^ARCIM(+ArcimID,+$p(ArcimID,"||",2),1)),"^",2)		//医嘱项名称
					}
				}
				
				//检验项目
				Set xTCCode=""
				For {
					Set xTCCode=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",ReportID,xTCCode))
					Quit:xTCCode=""
					
					Set xRstID=0
					For {
						Set xRstID=$o(^Busi.ENS.EnsLISItemResultI("IndexReportItem",ReportID,xTCCode,xRstID))
						Quit:xRstID=""
						
						Set objResult=##class(User.EnsLISItemResult).%OpenId(xRstID)
						Continue:'$IsObject(objResult)
						Do objResult.%Close()
						
						Set TCCode    = objResult.LISIRItemCode         // 检验项目代码
						Set TCDesc    = objResult.LISIRItemDesc         // 检验项目名称
						Set RstFormat = objResult.LISIRResClass         // 结果类型
						Set Result    = objResult.LISIRResult           // 定量结果
						Set Unit      = objResult.LISIRUint             // 结果单位
						Set TextRes   = objResult.LISIRTextResult       // 定性结果
						Set RefRanges = objResult.LISIRRanges           // 参考值范围
						Set AbFlag    = objResult.LISIRAbnormalFlags    // 异常标志
						
						Set TSAndTCInfo=TestSetCode_"^"_TestSetDesc_"^"_ArcimCode_"^"_ArcimDesc  //检验医嘱
						Set TSAndTCInfo=TSAndTCInfo_"^"_SpecCode_"^"_SpecDesc  //送检标本
						Set TSAndTCInfo=TSAndTCInfo_"^"_TCCode_"^"_TCDesc_"^"_RstFormat_"^"_AbFlag_"^"_RefRanges  //检验项目
						Set flg=..NewTSAndTCDic(SYSDr,TSAndTCInfo)
						If (+flg)<1 {
							w TSAndTCInfo,!
						} Else {
							Set Count=Count+1
						}
					}
				}
			}
		}
	}
	
	Set return=Count
	Quit return
}

}
