/// 检查报告信息服务类
Class DHCMA.CPW.SD.DataSrv.RisInfoSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 同步检查报告信息
/// w ##class(DHCMA.CPW.SD.DataSrv.RisInfoSrv).SynRisInfo("2299906","2020-02-24","2020-02-28")
ClassMethod SynRisInfo(aEpisodeID As %String, aDateFrom As %String = "", aDateTo As %String = "") As %String
{
	Set return=""
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aEpisodeID="")&&((aDateFrom="")||(aDateTo="")) return
	Set:aEpisodeID["!!" aEpisodeID=$p(aEpisodeID,"!!",1)
	Set Count=0
	If aEpisodeID'="" {
		Set AdmStr = $g(^PAADM(aEpisodeID))
		Set AdmType= $p(AdmStr,"^",2)       //就诊类型
		Quit:(AdmType'="I")&(AdmType'="E") $$$OK
		Set xID=0
		For {
			Set xID=$o(^DHCRBStudyi("Report-PAADMDR",aEpisodeID,xID))
			Quit:xID=""
			Set ReportData=$g(^DHCRBStudy("Report",xID))
			Continue:ReportData=""
			Set RecDate=$p(ReportData,"^",9)  //报告日期
			Continue:RecDate=""
			Continue:(aDateFrom'="")&&(RecDate<aDateFrom)
			Continue:(aDateTo'="")&&(RecDate>aDateTo)
			Set Data=..BuildRBReport(xID)
			Continue:Data=""
			Set ReportStr=$lts(Data,$c(1))
			Set OEORIStr=""
			Set StudyNo=$lg(Data,3)
			Set RARRowid=""
			For {
				//处理一次检查关联多个医嘱的情况
				Set RARRowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,RARRowid))
				Quit:RARRowid=""
				Set RegInfo=$g(^DHCPACRegInfo(RARRowid))
				Set OEItemID=$p(RegInfo,"^",11)
				Continue:OEItemID=""
				Set $p(ReportStr,$c(1),4)=OEItemID
				Set ArcimID=$p(^OEORD(+OEItemID,"I",+$p(OEItemID,"||",2),1),"^",2)
 				Continue:ArcimID=""
 				Set $p(ReportStr,$c(1),5)=ArcimID
				Set ret=##class(DHCMA.CPW.SD.Data.RisInfo).Update(ReportStr,$c(1))
				Set:ret>0 Count=Count+1
			}	
		}
	} Else {
		For xDate=aDateFrom:1:aDateTo {
			Set xID=0
			For {
				Set xID=$o(^DHCRBStudyi("ReportDate",xDate,xID))
				Quit:xID=""
				
				Set ReportData=$g(^DHCRBStudy("Report",xID))
				Continue:ReportData=""
				Set EpisodeID=$p(ReportData,"^",16)     //就诊号
				Continue:EpisodeID=""
				Set AdmStr = $g(^PAADM(+EpisodeID))
				Set AdmType= $p(AdmStr,"^",2)	        //就诊类型
				Continue:(AdmType'="I")&(AdmType'="E")
				Set Data=..BuildRBReport(xID)
				Continue:Data=""
				Set ReportStr=$lts(Data,$c(1))
				Set OEORIStr=""
				Set StudyNo=$lg(Data,3)
				Set RARRowid=""
				For {
					Set RARRowid=$o(^DHCPACRegInfoi("StudyNo",StudyNo,RARRowid))
					Quit:RARRowid=""
					Set RegInfo=$g(^DHCPACRegInfo(RARRowid))
					Set OEItemID=$p(RegInfo,"^",11)
					Continue:OEItemID=""
					Set $p(ReportStr,$c(1),4)=OEItemID
					Set ArcimID=$p(^OEORD(+OEItemID,"I",+$p(OEItemID,"||",2),1),"^",2)
	 				Continue:ArcimID=""
	 				Set $p(ReportStr,$c(1),5)=ArcimID
					Set ret=##class(DHCMA.CPW.SD.Data.RisInfo).Update(ReportStr,$c(1))
					Set:ret>0 Count=Count+1
				}	
			}
		}
	}
	Quit Count
}

/// Creator：     zhufei
/// CreatDate：   2017-09-07
/// Description:  组织Query输出检查报告
/// Input：       aReportID : 检查报告ID
/// Return：      返回List
/// w ##Class(DHCHAI.DI.DIO.FromPacsSrv).BuildRBReport(2)
ClassMethod BuildRBReport(aReportID As %String, ByRef errMsg As %String = "") As %List
{
	New (aReportID,errMsg)
	Set return=""
	Quit:(aReportID="") return
	
	Set $ZT="BuildRBReportErr"
	
	Set ReportData=$g(^DHCRBStudy("Report",aReportID))
	Quit:ReportData="" return
	Set EpisodeID=$p(ReportData,"^",16)     //就诊号
	Quit:EpisodeID="" return
 	Set StudyNo=$p(ReportData,"^",1)        //检查号
 	Set OEItemID=$p(ReportData,"^",15)      //医嘱ID

 	Set ArcimID=$p(^OEORD(+OEItemID,"I",+$p(OEItemID,"||",2),1),"^",2)
 	Quit:ArcimID="" return
	Set OrdItemCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)		           //检查项目代码
	Set OrdItemDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)	               //检查项目名称
 	Set Memo=$g(^DHCRBStudy("Report",aReportID,"MemoEx"))              //备注信息
	Set ExamDesc=$g(^DHCRBStudy("Report",aReportID,"ExamDescEx"))      //检查所见
	Set ExamDesc=$tr(ExamDesc,$c(10),"")
    Set ExamResult=$g(^DHCRBStudy("Report",aReportID,"ResultDescEx"))  //诊断意见
    Set RepDate=$p(ReportData,"^",9)        //报告日期
    Set RepTime=$p(ReportData,"^",10)       //报告时间
    Set RepUserDr=$p(ReportData,"^",8)      //报告人
    Set RepUserCode="",RepUserDesc=""
	If RepUserDr'="" {
		Set RepUserCode=$p($g(^SSU("SSUSR",RepUserDr)),"^",1)
		Set RepUserDesc=$p($g(^SSU("SSUSR",RepUserDr)),"^",2)
	}
	
	Set RegDate="",RegTime=""
	Set RepUserCode="",RepUserDesc=""
	Set RegInfoDr=$p(ReportData,"^",14)     //登记信息
	If RegInfoDr'="" {
		Set RegInfo=$g(^DHCPACRegInfo(RegInfoDr))
		Set RegDate=$p(RegInfo,"^",8)       //登记日期
		Set RegTime=$p(RegInfo,"^",9)       //登记时间
		Set RegUserDr=$p(RegInfo,"^",7)     //登记人
		If RegUserDr'="" {
			Set RegUserCode=$p($g(^SSU("SSUSR",RegUserDr)),"^",1)
			Set RegUserDesc=$p($g(^SSU("SSUSR",RegUserDr)),"^",2)
		}
	}
	
 	//报告状态（有效状态V和S）
 	//N^未写报告、I^已有图像、R^已录入、V^已审核、S^已发布、D^全科会诊
 	Set StatusDr=$p(ReportData,"^",4)       
 	Set StatusCode=$p($g(^DHCRBCStatus("ReportStatus",+StatusDr)),"^",1)  //处理StatusDr=0报错情况
 	Set StatusDesc=$p($g(^DHCRBCStatus("ReportStatus",+StatusDr)),"^",2)  //处理StatusDr=0报错情况
 	
 	Set return=$lb(EpisodeID)
	Set return=return_$lb(aReportID)
	Set return=return_$lb(StudyNo)
	Set return=return_$lb(OEItemID)
	Set return=return_$lb(ArcimID)
	Set return=return_$lb(RegDate)
	Set return=return_$lb(RegTime)
	Set return=return_$lb(RepDate)
	Set return=return_$lb(RepTime)
	Set return=return_$lb(StatusCode)
	Set return=return_$lb(StatusDesc)
	Set return=return_$lb(ExamDesc)
	Set return=return_$lb(ExamResult)
	Quit return
	
BuildRBReportErr
	Set errMsg="-999^"_$ZError
	Set return=""
	Quit return
}

/// 查询患者检查记录
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.CPW.SD.DataSrv.RisInfoSrv","QueryRisInfo","185",15,"1||262")
Query QueryRisInfo(aEpisodeID As %String, aMrListID As %String, aItemID As %String) As %Query(ROWSPEC = "RBRepID,ARCMastDesc,RBStudyNo,RepStatus,RepResult,RepDianog,RegDateT,RepDateT,OEItemID")
{
}

ClassMethod QueryRisInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aMrListID As %String, aItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	Quit:(aEpisodeID="") $$$OK
	Set ^tmpzhz10203=$lb(aEpisodeID,aMrListID,aItemID)
	Set return="",aDicID="",aOEItemID="",SourceField="",ResultFlg=0
 	If (aItemID'="") {
	 	//根据配置信息，获取关联信息
	 	Set ConfigID=$o(^DHCMA.CPW.SD.QCItemDataConfigI("IdxItem",aItemID,0))
	 	Set objConfig=##class(DHCMA.CPW.SD.QCItemDataConfig).GetObjById(ConfigID)
	 	If ($IsObject(objConfig)) {
		 	Set StandDic=objConfig.StandDic
		 	Set StandDicSub=objConfig.StandDicSub
		 	Set:$IsObject(StandDic) aDicID=StandDic.%Id()
		 	//检验信息 标准字典子项为结果相关
		 	Set:$IsObject(StandDicSub) ResultFlg=1
	 	}
		Set ESubID=$o(^DHCMA.CPW.SD.QCMrListI("Exec","IndexParrefItemDr",aMrListID,aItemID,""),-1)
 		If (ESubID'="") {
			Set ItemExecObj=##class(DHCMA.CPW.SD.QCItemExec).GetObjById(aMrListID_"||"_ESubID)
		 	Set ObjectID=ItemExecObj.ObjectID	
		 	Set:ObjectID["OE" aOEItemID=$p(ObjectID,":",2)
		 	Set:$IsObject(objConfig) SourceField=objConfig.SourceField
		}	
 	}
 	Set LinkOrder=##class(DHCMA.CPW.SD.StandSrv.OrderLinkSrv).GetDicOrderStr(aDicID)
 	Set LinkArcID=""
 	For OrdInd=1:1:$l(LinkOrder,"^") {
		Set EPOrderID=$P(LinkOrder,"^",OrdInd)
		Continue:EPOrderID=""
		Set objEPOrder=##class(DHCMA.Util.EPx.OrdMast).GetObjById(EPOrderID)
		Set ARCMastID=$p(objEPOrder.OID,"!!",1)
		Continue:ARCMastID=""
		Set LinkArcID=LinkArcID_","_ARCMastID
 	}
 	Set xStudyNo="",EpisodeID=$p(aEpisodeID,"!!",1)
 	For {
	 	Set xStudyNo=$o(^DHCMA.CPW.SD.Data.RisInfoI("IdxAdmStudy",EpisodeID,xStudyNo))
	 	Quit:xStudyNo=""
	 	Set xRowID=""
	 	For {
			Set xRowID=$o(^DHCMA.CPW.SD.Data.RisInfoI("IdxAdmStudy",EpisodeID,xStudyNo,xRowID))
			Quit:xRowID=""
			Set xobj=##class(DHCMA.CPW.SD.Data.RisInfo).GetObjById(xRowID)
			Continue:'$IsObject(xobj)
			Set OEItemID=xobj.OEItemID
			Set RegDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(xobj.RegDate)
			Set RegTime=$zt(xobj.RegTime)
			Set xobj.RegDateT=RegDate_" "_RegTime
			Set RepDate=##Class(DHCMA.Util.IO.FromHisSrv).DateLogicalToHtml(xobj.RepDate)
			Set RepTime=$zt(xobj.RepTime)
			Set xobj.RepDateT=RepDate_" "_RepTime
			//根据执行医嘱、输出字段，标记输出内容
			If (SourceField'="")&&(aOEItemID=OEItemID) {
				If (SourceField="RepResult")||(SourceField="RepDianog") {
					Set OEItemID="#"_OEItemID
					Set Content=$property(xobj,SourceField)
					Set xContent=##Class(DHCMA.CPW.SDS.IO.ToDocService).AnalyDHC(Content)
					Set xFlgLen=0  //标记符长度
					For xind=1:1:$l(xContent,$c(1)) {
						Set subContent=$p(xContent,$c(1),xind)
						Set TargeStart=$p(subContent,$c(2),7)+xFlgLen
						Set TargeEnd=$p(subContent,$c(2),8)+xFlgLen
						Set ResultType=$p(subContent,$c(2),2)
						Set OneWord=$p(subContent,$c(2),1)	
						If (ResultType["disease"){
							SET $e(Content,TargeStart-1,TargeEnd-1)=$c(3)_OneWord_$c(4)
							Set xFlgLen=xFlgLen+2
						}
					}
					Set Content=$Replace(Content,$c(3),"<span style=""background-color:orange"">")
					Set Content=$Replace(Content,$c(4),"</span>")
					Set $property(xobj,SourceField)=Content
				}else {
					Set $property(xobj,SourceField)="*"_$property(xobj,SourceField)	
				}
			}ElseIf(aOEItemID=OEItemID) {
				//没有具体字段输出内容，应当标记整条医嘱记录
				Set OEItemID="*"_OEItemID
			}
			Set RBStudyNo=xobj.RBStudyNo
			Set RBRepID=xobj.RBRepID
			Set ARCMastID=xobj.ARCMastID
			Continue:(LinkArcID'="")&&(LinkArcID'[ARCMastID)
			Set ARCMastDesc=$p($g(^ARCIM(+ARCMastID,$p(ARCMastID,"||",2),1)),"^",2)
			Set RepStatus=xobj.RepStatus
			Set RepResult=xobj.RepResult
			Set RepDianog=xobj.RepDianog
			Set RegDateT=xobj.RegDateT
			Set RepDateT=xobj.RepDateT
			Set Data=$lb(RBRepID,ARCMastDesc,RBStudyNo,RepStatus,RepResult,RepDianog,RegDateT,RepDateT,OEItemID)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1 
		}
	}
	Quit $$$OK
}

ClassMethod QueryRisInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRisInfoExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QueryRisInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRisInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 查询关联检查医嘱的检查项目
/// do ##class(%Library.ResultSet).RunQuery("DHCMA.CPW.SD.DataSrv.RisInfoSrv","QueryRBItem","*||*")
Query QueryRBItem(aDicID As %String) As %Query(ROWSPEC = "ReportID:%String,EpisodeID:%String,StudyNo:%String,StatusCode:%String,StatusDesc:%String,OrdItemCode:%String,OrdItemDesc:%String,ExamDesc:%String,ExamResult:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserDesc:%String,RepDate:%String,RepTime:%String,RepUserCode:%String,RepUserDesc:%String")
{
}

ClassMethod QueryRBItemExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//根据标准项目字典子项查找相关检查的项目信息
	Quit $$$OK
}

ClassMethod QueryRBItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryRBItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

ClassMethod QueryRBItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryRBItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
