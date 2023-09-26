/// ClassName:    DHCHAI.IO.ToDtPortal01
///               替换类DtPortal.DD.DD11HospInfectionWarning
/// Description:  根据检验报告ID同步服务
/// Creator：     zhufei
/// CreatDate:    2018-03-19
Class DHCHAI.IO.ToLisReport Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2018-08-07
/// Description:  根据报告 ID 同步 业务逻辑同 
/// w ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabRepByDate 保持一致
/// 			  aReportID：报告ID
/// Return：      处理数
/// w ##class(DHCHAI.IO.ToLisReport).SyncLabReport("123456")
ClassMethod SyncLabReport(aReportID As %String) As %String
{
	New (aReportID)
	Set return=0,Count=0
	Set:aSCode="" aSCode = "LIS01"
	Quit:(aReportID="") return
	Set $ZT="SyncLabReportErr"
		
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="LIS" return  //检验系统
	Set HISCode = "HIS01"
	
	Set LabRepVer=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVer")
	If LabRepVer="LIS1.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLis10Srv:QryLabVisitReportN")
	} Else {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLisSrv:QryLabVisitReportN")
	}
  	Set sc=rs.Execute(aReportID)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
  	 
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    //部分检验医嘱及项目存在回车换行符
	    Set TestSetStr=rs.Data("TestSetStr")
	    Set TestSetStr=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetStr,"^")
	    Set SpecDesc=rs.Data("SpecDesc")
	    Set SpecDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(SpecDesc)
	    
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(rs.Data("VisitNumberID"),"VisitNumberID")
	    Do rowData.SetAt(rs.Data("EpisodeID"),"EpisodeID")
	    
	    Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(HISCode_"||"_rs.Data("EpisodeID"))
		if '$IsObject(objAdm) {
			//增加判断是否同步了就诊信息
			Set EpisodeDr = ##class(DHCHAI.DI.DHS.SyncHisInfo).SyncAdmByEpisodeID(HISCode,rs.Data("EpisodeID"))
		}
		else
		{
			Set EpisodeDr=objAdm.%Id()
		}	    
		Do rowData.SetAt(EpisodeDr,"EpisodeDr")
	    Do rowData.SetAt(rs.Data("EpisodeNo"),"EpisodeNo")
	    Do rowData.SetAt(rs.Data("SpecCode"),"SpecCode")
	    Do rowData.SetAt(SpecDesc,"SpecDesc")
	    Do rowData.SetAt(rs.Data("LocCode"),"LocCode")
	    Do rowData.SetAt(rs.Data("LocDesc"),"LocDesc")
	    Do rowData.SetAt(rs.Data("CollDate"),"CollDate")
	    Do rowData.SetAt(rs.Data("CollTime"),"CollTime")
	    Do rowData.SetAt(rs.Data("CollUserCode"),"CollUserCode")
	    Do rowData.SetAt(rs.Data("CollUserName"),"CollUserName")
	    Do rowData.SetAt(rs.Data("RecDate"),"RecDate")
	    Do rowData.SetAt(rs.Data("RecTime"),"RecTime")
	    Do rowData.SetAt(rs.Data("RecUserCode"),"RecUserCode")
	    Do rowData.SetAt(rs.Data("RecUserName"),"RecUserName")
	    Do rowData.SetAt(rs.Data("WardCode"),"WardCode")
	    Do rowData.SetAt(rs.Data("WardDesc"),"WardDesc")
	    Do rowData.SetAt(TestSetStr,"TestSetStr")
	    
	    Do rowData.SetAt(rs.Data("ReportID"),"ReportID")
	    Do rowData.SetAt(rs.Data("TestSetRow"),"TestSetRow")
	    Do rowData.SetAt(rs.Data("Order"),"Order")
	    Do rowData.SetAt(rs.Data("RepStatus"),"RepStatus")
	    Do rowData.SetAt(rs.Data("RegDate"),"RegDate")
	    Do rowData.SetAt(rs.Data("RegTime"),"RegTime")
	    Do rowData.SetAt(rs.Data("RegUserCode"),"RegUserCode")
	    Do rowData.SetAt(rs.Data("RegUserName"),"RegUserName")
	    Do rowData.SetAt(rs.Data("AuthDate"),"AuthDate")
	    Do rowData.SetAt(rs.Data("AuthTime"),"AuthTime")
	    Do rowData.SetAt(rs.Data("AuthUserCode"),"AuthUserCode")
	    Do rowData.SetAt(rs.Data("AuthUserName"),"AuthUserName")
	    
		//审核A、登记R、作废U
	    Set RepStatus=rs.Data("RepStatus")
		Set MapStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"LabRepStatus",RepStatus)
		Set:MapStatus="" MapStatus=RepStatus
		
		//检验1.0（A审核）
		//检验2.0（1登记，2初审，3审核，4复查，5取消审核，6作废）
	    Set IsActive=0 
		Set:(MapStatus="A") IsActive=1
		Set:(MapStatus=2)||(MapStatus=3)||(MapStatus=4) IsActive=1
	 
	    Do rowData.SetAt(IsActive,"IsActive")  //是否有效
	    
		//标本记录检查
		Set XCode=rowData.GetAt("VisitNumberID")
		Set VisitNumberDr=""
		Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjByXCode(aSCode,XCode)
		If $IsObject(objVisitNumber){
			Set VisitNumberDr=objVisitNumber.%Id()
		} Else {
			//保存标本记录
			Set VisitNumberDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitNumber(rowData,aSCode)
			Continue:(+VisitNumberDr)<1
		}
		Continue:(+VisitNumberDr)<1
		Do rowData.SetAt(VisitNumberDr,"VisitNumberDr")
		 
		//保存检验医嘱
		Do ##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitTestSet(rowData,aSCode)
		
		//保存检验报告
		Set ReportDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitReport(rowData,aSCode)
		Continue:(+ReportDr)<1
		
		//保存检验结果
		Set LReportID=rowData.GetAt("ReportID")  //LIS报告ID
		Set TestSetStr=rowData.GetAt("TestSetStr")
		Set TSCode=$p(TestSetStr,"^",1)     //TSCode
		Set TSDesc=$p(TestSetStr,"^",2)     //TSDesc
		Set ArcimCode=$p(TestSetStr,"^",3)  //ArcimCode
		Set ArcimDesc=$p(TestSetStr,"^",4)  //ArcimDesc
		Set TestSetData=TSDesc_$c(1)_ArcimDesc
		
		If LabRepVer="LIS1.0" {
			Set ResultDatas=##Class(DHCHAI.DI.DIO.FromLis10Srv).GetRepResult(LReportID)
		} Else {
			Set ResultDatas=##Class(DHCHAI.DI.DIO.FromLisSrv).GetRepResult(LReportID)
		}
		For indRst=1:1:$listlength(ResultDatas) {
			Set ResultData=$listget(ResultDatas,indRst)
			Continue:ResultData=""
			
			Set ResultInfo=""
			Set $p(ResultInfo,"^",1)=ReportDr
			Set $p(ResultInfo,"^",2)=$p(ResultData,"^",2)   //TCCode
			Set $p(ResultInfo,"^",3)=$p(ResultData,"^",3)   //TCDesc
			Set $p(ResultInfo,"^",4)=$p(ResultData,"^",4)   //RstFormat
			Set $p(ResultInfo,"^",5)=$p(ResultData,"^",5)   //Result
			Set $p(ResultInfo,"^",6)=$p(ResultData,"^",6)   //TextRes
			Set $p(ResultInfo,"^",7)=$p(ResultData,"^",7)   //ResNoes
			Set $p(ResultInfo,"^",8)=$p(ResultData,"^",8)   //AbFlag
			Set $p(ResultInfo,"^",9)=$p(ResultData,"^",9)   //Unit
			Set $p(ResultInfo,"^",10)=$p(ResultData,"^",10) //RefRanges
			Set $p(ResultInfo,"^",11)=$p(ResultData,"^",11) //MDRResult
			Set $p(ResultInfo,"^",12)=TestSetData           //TestSetData
			Set $p(ResultInfo,"^",13)=EpisodeDr             //EpisodeDr
			Set ResultDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitRepResult(ResultInfo,aSCode)
			Continue:(+ResultDr)<1
			
			//保存药敏试验结果
			Set LResultID=$p(ResultData,"^",1)  //LIS结果ID
			
			If LabRepVer="LIS1.0" {
				Set TestSenDatas=##Class(DHCHAI.DI.DIO.FromLis10Srv).GetResultSen(LResultID)
			} Else {
				Set TestSenDatas=##Class(DHCHAI.DI.DIO.FromLisSrv).GetResultSen(LResultID)
			}
			For indTSS=1:1:$listlength(TestSenDatas) {
				Set TestSenData=$listget(TestSenDatas,indTSS)
				Continue:TestSenData=""
				
				Set TestSenInfo=""
				Set $p(TestSenInfo,"^",1)=ResultDr
				Set $p(TestSenInfo,"^",2)=$p(TestSenData,"^",1)   //AntCode
				Set $p(TestSenInfo,"^",3)=$p(TestSenData,"^",2)   //AntDesc
				Set $p(TestSenInfo,"^",4)=$p(TestSenData,"^",3)   //SenDesc
				Set $p(TestSenInfo,"^",5)=EpisodeDr               //EpisodeDr
				Set TestSenDr=##class(DHCHAI.DI.DHS.SyncLabInfo).SaveVisitRepRstSen(TestSenInfo,aSCode)
				Continue:(+TestSenDr)<1
			}
		}
		
		//计数
		Set Count=Count+1
    }
    
    Set return=Count
    Quit return	
	
SyncLabReportErr
	Set return="-1^"_$ZError
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2021-10-14
/// Description:  检验检出多耐调用,根据日期同步东华检验标本信息,检验医嘱和报告结果
/// 			  注意默认系统代码 检验 LIS01 医生站 HIS01
/// 			  aEpisodeIDX HIS系统患者就诊ID,aVistNo送检标本号
/// Return：      是否正常执行
/// w ##class(DHCHAI.IO.ToLisReport).SyncLabRep("108","")
ClassMethod SyncLabRep(aEpisodeIDX As %String, aVistNo As %String = "") As %String
{
	New (aEpisodeIDX,aVistNo)
	Set return=0
	Quit:aEpisodeIDX="" return
	Set ScHis = "HIS01",ScLis = "LIS01"
	Set xEpisodeID=ScHis_"||"_aEpisodeIDX
	Set xDateTo =+$h
	//测试截止日期调整
	//w "开始"_$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	Set xDateFrom =xDateTo-3
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(xEpisodeID)
	//当天入院无患者信息暂时不考虑-待定
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	//1-根据就诊号同步特定患者近三天的申请标本记录
	//(不考虑只同步特定报告是因为指定了患者和3天日期范围效率差别不大;
	//还有数据是通过数据中心同步，我们存的报告ID是数据中心的和检验系统的ID已经不一样了
	//同时调用和定时任务同步方法代码更统一)
	//送检+检验结果	
	Set ret =##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabVisitNumber(ScLis,xEpisodeID,xDateFrom,xDateTo)
	If (+ret)<0 {
		Set ErrClass  = "DHCHAI.IO.ToLisReport"
		Set ErrMethod = "SyncLabVisitNumber"
		Set ErrArgStr = $lb(ret)
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
    }	
	//2-根据就诊号同步指定患者近三天的申请报告结果
	Set ret = ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabRepByDate(ScLis,xEpisodeID,xDateFrom,xDateTo)
	If (+ret)<0 {
		Set ErrClass  = "DHCHAI.IO.ToLisReport"
		Set ErrMethod = "SyncLabRepByDate"
		Set ErrArgStr = $lb(ret)
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(xEpisodeID,ErrClass,ErrMethod,ErrArgStr)
    }
	//3-根据就诊号执行检出菌监控多耐筛查
	
	Set ItmMastID=##class(DHCHAI.IRC.CtrlResultSrv).GetActItmMastID("LAB-Bacteria")
	Set flg=##class(DHCHAI.IRC.LabBacteriaSrv).Check(EpisodeDr,xDateFrom,xDateTo,ItmMastID)
	//w "结束"_$zd(+$h,3)_" "_$zt($p($h,",",2),1)
	//执行正常结束
	Quit 1
}

}
