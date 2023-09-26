/// 名称: DHCHAI.DI.DHS.SyncPacsInfo
/// 描述: 同步东华Pacs数据
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DHS.SyncPacsInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chengpengju
/// CreatDate：   2017-09-06
/// Description:  根据日期同步东华检查报告
/// Input：       aEpisodeIDX ：就诊号
///               aDateFrom : 开始日期
/// 			  aDateTo ：结束日期
/// Return：      处理同步手麻的数量
/// w ##class(DHCHAI.DI.DHS.SyncPacsInfo).SyncPacsByDateAdm("RIS01","HIS01||108","2019-02-01","2019-10-29")
ClassMethod SyncPacsByDateAdm(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	Set $ZT="SyncPacsByDateAdmErr"
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="RIS" return  //检查系统
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	//就诊记录检查
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	//add by zhoubo 2019-10-30 从平台直接取值
	Set RisRepVer=##class(DHCHAI.BT.Config).GetValByCode("DPRisReportVer")
	If (RisRepVer="RISC1.0"){ 
		Set rs=##Class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:QueryRBReport")
	}ElseIf (RisRepVer="RISC2.0"){ 
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.EnsFromRis2Srv:QueryRBReport")
	}Else {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromPacsSrv:QueryRBReport")
	}
  	Set sc=rs.Execute(EpisodeID,aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    //部分检验医嘱及项目存在回车换行符
	    Set ExamDesc=rs.Data("ExamDesc")
	    Set ExamDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(ExamDesc)
	    Set ExamResult=rs.Data("ExamResult")
	    Set ExamResult=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(ExamResult)
	    Do rowData.Clear()  //清空数组
	    Do rowData.SetAt(EpisodeID,"EpisodeID")
	    Do rowData.SetAt(EpisodeDr,"EpisodeDr")
	    Do rowData.SetAt(rs.Data("ReportID"),"ReportID")		// 报告ID
	    Do rowData.SetAt(rs.Data("StudyNo"),"StudyNo")         	// 检查号
		Do rowData.SetAt(rs.Data("StatusCode"),"StatusCode")    // 状态代码
		Do rowData.SetAt(rs.Data("StatusDesc"),"StatusDesc")    // 状态名称
		Do rowData.SetAt(rs.Data("OrdItemDesc"),"OrdItemDesc")  // 医嘱名称
		Do rowData.SetAt(ExamDesc,"ExamDesc")     	            // 检查所见
		Do rowData.SetAt(ExamResult,"ExamResult")   	        // 诊断意见
		Do rowData.SetAt(rs.Data("RegDate"),"RegDate")      	// 录入日期
		Do rowData.SetAt(rs.Data("RegTime"),"RegTime")   		// 录入时间
		Do rowData.SetAt(rs.Data("RegUserCode"),"RegUserCode") 	// 录入人
		Do rowData.SetAt(rs.Data("RegUserDesc"),"RegUserDesc")
		Do rowData.SetAt(rs.Data("RepDate"),"RepDate")        	// 报告日期
		Do rowData.SetAt(rs.Data("RepTime"),"RepTime") 	        // 报告时间
		Do rowData.SetAt(rs.Data("RepUserCode"),"RepUserCode") 	// 报告人
		Do rowData.SetAt(rs.Data("RepUserDesc"),"RepUserDesc")
		
		//未写报告N、已审核V、已发布S
	    Set StatusCode=rs.Data("StatusCode")
		Set MapStatus=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"RBRepStatus",StatusCode)
		Set:MapStatus="" MapStatus=StatusCode
		//N^未写报告、I^已有图像、R^已录入、V^已审核、S^已发布、D^全科会诊
		Set IsActive=0
		Set:(MapStatus="V")||(MapStatus="S") IsActive=1
		Do rowData.SetAt(IsActive,"IsActive")  // 是否有效
		
		//检查报告是否有效
		Set OrdItemDesc=rowData.GetAt("OrdItemDesc")
		Set objItmMastMap=##class(DHCHAI.DP.RBItmMastMap).GetObjByItemDesc(aSCode,OrdItemDesc)
		If $IsObject(objItmMastMap) {
			Continue:objItmMastMap.BTIsActive'=1
		}
		
		//保存检查报告
		Set PacsDr=..SavePacsInfo(rowData,aSCode)
		Continue:(+PacsDr)<1
		
		//计数
		Set Count=Count+1
    }
	Set return=Count
	Quit return
	
SyncPacsByDateAdmErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod SavePacsInfo(rd As %ArrayOfDataTypes, aSCode As %String) As %String
{
	New (rd,aSCode)
	Set return=0
	Quit:(rd="")||(aSCode="") return
	
	Set $ZT="SavePacsInfoErr"
	
	Set XCode    	= rd.GetAt("ReportID")
	Set EpisodeID	= rd.GetAt("EpisodeID")
	Set EpisodeDr	= rd.GetAt("EpisodeDr")
	Set StudyNo     = rd.GetAt("StudyNo")
	Set StatusCode  = rd.GetAt("StatusCode")
	Set StatusDesc  = rd.GetAt("StatusDesc")
	Set OrdItemCode = rd.GetAt("OrdItemCode")
	Set OrdItemDesc = rd.GetAt("OrdItemDesc")
	Set ExamDesc    = rd.GetAt("ExamDesc")
	Set ExamResult  = rd.GetAt("ExamResult")
	Set RegDate     = rd.GetAt("RegDate")
	Set RegTime   	= rd.GetAt("RegTime")
	Set RegUserID   = ""
	Set RegUserCode = rd.GetAt("RegUserCode")
	Set RegUserDesc = rd.GetAt("RegUserDesc")
	Set RepDate 	= rd.GetAt("RepDate")
	Set RepTime 	= rd.GetAt("RepTime")
	Set RepUserID   = ""
	Set RepUserCode	= rd.GetAt("RepUserCode")
	Set RepUserDesc	= rd.GetAt("RepUserDesc")
	Set IsActive	= rd.GetAt("IsActive")
	Quit:(XCode="") return
	
	Set ReportDr=""
	Set objReport = ##class(DHCHAI.DP.RBReport).GetObjByXCode(aSCode,XCode)
	If $IsObject(objReport){
		Set ReportDr=objReport.%Id()
	}
	Set InputStr = ReportDr
	Set InputStr = InputStr_"^"_EpisodeDr
	Set InputStr = InputStr_"^"_StudyNo
	Set InputStr = InputStr_"^"_StatusCode
	Set InputStr = InputStr_"^"_OrdItemDesc
	Set InputStr = InputStr_"^"_ExamDesc
	Set InputStr = InputStr_"^"_ExamResult
	Set InputStr = InputStr_"^"_RegDate
	Set InputStr = InputStr_"^"_RegTime
	Set InputStr = InputStr_"^"_RegUserID_"|"_RegUserCode_"|"_RegUserDesc  //登记人
	Set InputStr = InputStr_"^"_RepDate
	Set InputStr = InputStr_"^"_RepTime
	Set InputStr = InputStr_"^"_RepUserID_"|"_RepUserCode_"|"_RepUserDesc  //报告人
	Set InputStr = InputStr_"^"_aSCode
	Set InputStr = InputStr_"^"_XCode
	Set InputStr = InputStr_"^"_IsActive
	Set InputStr = InputStr_"^"_+$h
	Set InputStr = InputStr_"^"_+$p($h,",",2)
	Set ReportDr = ##class(DHCHAI.DP.RBReport).Update(InputStr,"^")
	If (+ReportDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.RBReport"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Quit:(+ReportDr)<1 return
	Set return=ReportDr
	
	//保存检查分类对照
	Set objRBItmMastMap = ##class(DHCHAI.DP.RBItmMastMap).GetObjByItemDesc(aSCode,OrdItemDesc)
	If '$isobject(objRBItmMastMap){
		Set MapItemDr=""
		Set objRBItmMast=##class(DHCHAI.DP.RBItmMast).GetObjByCodeName("",OrdItemDesc)
		Set:$isobject(objRBItmMast) MapItemDr=objRBItmMast.%Id()
		Set InputStr = ""
		Set InputStr = InputStr_"^"_OrdItemDesc				    // 检查项目名称
		Set InputStr = InputStr_"^"_MapItemDr					// 标准项目名称
		Set InputStr = InputStr_"^"_""							// 标准备注
		Set InputStr = InputStr_"^"_aSCode						// 子系统代码
		Set InputStr = InputStr_"^"_1							// 有效标志
		Set InputStr = InputStr_"^"_""							// 处置日期
		Set InputStr = InputStr_"^"_""							// 处置时间
		Set InputStr = InputStr_"^"_""							// 处置人
		Set ItmMastMapDr=##class(DHCHAI.DP.RBItmMastMap).Update(InputStr,"^")
		If (+ItmMastMapDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DP.RBItmMastMap"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	Quit return
	
SavePacsInfoErr
	Set return="-999^"_$ZError
	Quit return
}

}
