/// 名称: DHCHAI.DI.DHS.SyncLabInfo
/// 描述: 同步东华检验数据
/// 编写者：liyi
/// 编写日期: 2017-07-04
Class DHCHAI.DI.DHS.SyncLabInfo Extends (%RegisteredObject, DHCHAI.Abstract, User.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liyi
/// CreatDate：   2017-08-09
/// Description:  根据日期同步东华检验标本信息,检验医嘱
/// 			  aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// 			  aHospCode：医院代码
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabVisitNumber("LIS01","HIS01||108","2019-02-01","2019-10-29")
ClassMethod SyncLabVisitNumber(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	Set $ZT="SyncLabVisitNumberErr"
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="LIS" return  //检验系统
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	// 版本说明：
	// LIS1.0  ：从东华检验（CS版）直接获取检验报告信息
	// LIS2.0  ：从东华检验（BS版）直接获取检验报告信息
	// LISC1.0 ：从平台（文档）获取检验报告信息
	// LISC2.0 ：从平台（结构化）获取检验报告信息
	Set LabRepVer=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVer")
	Quit:(LabRepVer'="LIS1.0")&&(LabRepVer'="LIS2.0")&&(LabRepVer'="LISC1.0")&&(LabRepVer'="LISC2.0") return
	If LabRepVer="LIS1.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLis10Srv:QryLabVisitNumber")
	} ElseIf LabRepVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLisSrv:QryLabVisitNumber")
	} ElseIf LabRepVer="LISC1.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.EnsFromLis1Srv:QryLabVisitNumber")
	} ElseIf LabRepVer="LISC2.0" {
		//Set rs=##Class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISItemListByDate")
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.EnsFromLis2Srv:SelectLISItemListByDate")
	}
  	Set sc=rs.Execute(EpisodeID,aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    Do rowData.Clear()  //清空数组
	    If (LabRepVer'="LISC2.0"){
		    //部分检验医嘱及项目存在回车换行符
		    Set TestSetStr=rs.Data("TestSetStr")
		    Set TestSetStr=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetStr,"^")
		    Set SpecDesc=rs.Data("SpecDesc")
		    Set SpecDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(SpecDesc)
		    Do rowData.SetAt(rs.Data("VisitNumberID"),"VisitNumberID")
		    Do rowData.SetAt(rs.Data("EpisodeID"),"EpisodeID")
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
		    Do rowData.SetAt(rs.Data("ReqNotes"),"ReqNotes")   //医嘱备注  add 20230424
		    Do rowData.SetAt(TestSetStr,"TestSetStr")
	    }Else{
			//部分检验医嘱及项目存在回车换行符
		    Set TestSetStr=rs.Data("TestSetStr")
		    Set TestSetStr=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetStr,"^")
		    Set SpecDesc=rs.Data("SpecimenDesc")
		    Set SpecDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(SpecDesc)
		    // 标本号作为标本ID，平台无此字段
		    Do rowData.SetAt(rs.Data("LabEpisodeNo"),"VisitNumberID")
		    Do rowData.SetAt(EpisodeID,"EpisodeID")
			Do rowData.SetAt(EpisodeDr,"EpisodeDr")
		    Do rowData.SetAt(rs.Data("LabEpisodeNo"),"EpisodeNo")
		    Do rowData.SetAt(rs.Data("SpecimenCode"),"SpecCode")
		    Do rowData.SetAt(SpecDesc,"SpecDesc")
		    Do rowData.SetAt(rs.Data("LocCode"),"LocCode")
		    Do rowData.SetAt(rs.Data("LocDesc"),"LocDesc")
		    Do rowData.SetAt(rs.Data("CollectionDate"),"CollDate")
		    Do rowData.SetAt(rs.Data("CollectionTime"),"CollTime")
		    Do rowData.SetAt(rs.Data("CollectUserCode"),"CollUserCode")
		    Do rowData.SetAt(rs.Data("CollectUserName"),"CollUserName")
		    Do rowData.SetAt(rs.Data("ReceiveDate"),"RecDate")
		    Do rowData.SetAt(rs.Data("ReceiveTime"),"RecTime")
		    Do rowData.SetAt(rs.Data("ReceiveUserCode"),"RecUserCode")
		    Do rowData.SetAt(rs.Data("ReceiveUserName"),"RecUserName")
		    Do rowData.SetAt(rs.Data("WardCode"),"WardCode")
		    Do rowData.SetAt(rs.Data("WardDesc"),"WardDesc")
		    Do rowData.SetAt(rs.Data("ReqNotes"),"ReqNotes")   //医嘱备注  add 20230424
		    Do rowData.SetAt(TestSetStr,"TestSetStr")
		}
	    Set IsActive=1 //是否有效
	    Do rowData.SetAt(IsActive,"IsActive")
	    
		//保存标本记录
		Set VisitNumberDr=..SaveVisitNumber(rowData,aSCode)
		Continue:(+VisitNumberDr)<1
		Do rowData.SetAt(VisitNumberDr,"VisitNumberDr")
		
		//保存检验医嘱
		Do ..SaveVisitTestSet(rowData,aSCode)
		
		//计数
		Set Count=Count+1
    }
    
    Set return=Count
    Quit return
    
SyncLabVisitNumberErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     liyi
/// CreatDate：   2017-07-23
/// Description:  根据日期同步东华检验报告信息
/// 			  aDateTo：结束日期
/// 			  aDateFrom : 开始日期
/// 			  aHospCode：医院代码
/// Return：      处理报告数
/// w ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncLabRepByDate("LIS01","HIS01||108","2019-02-01","2019-10-29")
ClassMethod SyncLabRepByDate(aSCode As %String, aEpisodeIDX As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aEpisodeIDX,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aEpisodeIDX="")||(aDateFrom="")||(aDateTo="") return
	Set $ZT="SyncLabRepByDateErr"
	
	Set EpisodeID=$p(aEpisodeIDX,"||",2)
	Set HISCode=$p(aEpisodeIDX,"||",1)
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Quit:HISCode'=objSYS.BTHISCode return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="LIS" return  //检验系统
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Set objAdm=##class(DHCHAI.DP.PAAdm).GetObjByEpisodeIDX(aEpisodeIDX)
	Quit:'$IsObject(objAdm) return
	Set EpisodeDr=objAdm.%Id()
	
	// 版本说明：
	// LIS1.0  ：从东华检验（CS版）直接获取检验报告信息
	// LIS2.0  ：从东华检验（BS版）直接获取检验报告信息
	// LISC1.0 ：从平台（文档）获取检验报告信息
	// LISC2.0 ：从平台（结构化）获取检验报告信息
	Set LabRepVer=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVer")
	Quit:(LabRepVer'="LIS1.0")&&(LabRepVer'="LIS2.0")&&(LabRepVer'="LISC1.0")&&(LabRepVer'="LISC2.0") return
	If LabRepVer="LIS1.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLis10Srv:QryLabVisitReport")
	} ElseIf LabRepVer="LIS2.0" {
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.FromLisSrv:QryLabVisitReport")
	} ElseIf LabRepVer="LISC1.0" {
		Set rs=##Class(%ResultSet).%New("DHCMA.Util.IO.EnsSyncLis1Srv:QryLabVisitRepItem")
	} ElseIf LabRepVer="LISC2.0" {
		//Set rs=##Class(%ResultSet).%New("web.DHCENS.STBLL.Method.PostReportInfo:SelectLISItemListByDate")
		Set rs=##Class(%ResultSet).%New("DHCHAI.DI.DIO.EnsFromLis2Srv:SelectLISItemListByDate")
	}
  	Set sc=rs.Execute(EpisodeID,aDateFrom,aDateTo)
  	If $$$ISERR(sc) {
	  	Do $System.Status.DisplayError(sc)
	  	Quit return
  	}
  	
	Set rowData=##Class(%ArrayOfDataTypes).%New()
	If rowData'="" Do rowData.%Close()
    While (rs.Next()){
	    If (LabRepVer'="LISC2.0"){
		    //部分检验医嘱及项目存在回车换行符
		    Set TestSetStr=rs.Data("TestSetStr")
		    Set TestSetStr=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetStr,"^")
		    Set SpecDesc=rs.Data("SpecDesc")
		    Set SpecDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(SpecDesc)
		    
		    Do rowData.Clear()  //清空数组
		    Do rowData.SetAt(rs.Data("VisitNumberID"),"VisitNumberID")
		    Do rowData.SetAt(rs.Data("EpisodeID"),"EpisodeID")
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
	    }Else {
			//部分检验医嘱及项目存在回车换行符
		    Set TestSetStr=rs.Data("TestSetStr")
		    Set TestSetStr=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TestSetStr,"^")
		    Set SpecDesc=rs.Data("SpecimenDesc")
		    Set SpecDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(SpecDesc)
		    // 标本号作为标本ID，平台无此字段
		    Do rowData.SetAt(rs.Data("LabEpisodeNo"),"VisitNumberID")
		    Do rowData.SetAt(EpisodeID,"EpisodeID")
			Do rowData.SetAt(EpisodeDr,"EpisodeDr")
		    Do rowData.SetAt(rs.Data("LabEpisodeNo"),"EpisodeNo")
		    Do rowData.SetAt(rs.Data("SpecimenCode"),"SpecCode")
		    Do rowData.SetAt(SpecDesc,"SpecDesc")
		    Do rowData.SetAt(rs.Data("LocCode"),"LocCode")
		    Do rowData.SetAt(rs.Data("LocDesc"),"LocDesc")
		    Do rowData.SetAt(rs.Data("CollectionDate"),"CollDate")
		    Do rowData.SetAt(rs.Data("CollectionTime"),"CollTime")
		    Do rowData.SetAt(rs.Data("CollectUserCode"),"CollUserCode")
		    Do rowData.SetAt(rs.Data("CollectUserName"),"CollUserName")
		    Do rowData.SetAt(rs.Data("ReceiveDate"),"RecDate")
		    Do rowData.SetAt(rs.Data("ReceiveTime"),"RecTime")
		    Do rowData.SetAt(rs.Data("ReceiveUserCode"),"RecUserCode")
		    Do rowData.SetAt(rs.Data("ReceiveUserName"),"RecUserName")
		    Do rowData.SetAt(rs.Data("WardCode"),"WardCode")
		    Do rowData.SetAt(rs.Data("WardDesc"),"WardDesc")
		    Do rowData.SetAt(TestSetStr,"TestSetStr")
		    
		    Do rowData.SetAt(rs.Data("VisitNumberReportDR"),"ReportID")
		    Do rowData.SetAt(rs.Data("TestSetRow"),"TestSetRow")
		    Do rowData.SetAt(rs.Data("Order"),"Order")
		    Do rowData.SetAt(rs.Data("RepStatus"),"RepStatus")
		    Do rowData.SetAt(rs.Data("RegDate"),"RegDate")
		    Do rowData.SetAt(rs.Data("RegTime"),"RegTime")
		    Do rowData.SetAt(rs.Data("RegUserCode"),"RegUserCode")
		    Do rowData.SetAt(rs.Data("RegUserName"),"RegUserName")
		    Do rowData.SetAt(rs.Data("AuthorisationDate"),"AuthDate")
		    Do rowData.SetAt(rs.Data("AuthorisationTime"),"AuthTime")
		    Do rowData.SetAt(rs.Data("AuthUserCode"),"AuthUserCode")
		    Do rowData.SetAt(rs.Data("AuthUserName"),"AuthUserName")
		    //审核A、登记R、作废U
	   		Set RepStatus=rs.Data("RepStatus")
		}
		
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
			Set VisitNumberDr=..SaveVisitNumber(rowData,aSCode)
			Continue:(+VisitNumberDr)<1
		}
		Continue:(+VisitNumberDr)<1
		Do rowData.SetAt(VisitNumberDr,"VisitNumberDr")
		 
		//保存检验医嘱
		Do ..SaveVisitTestSet(rowData,aSCode)
		
		//保存检验报告
		Set ReportDr=..SaveVisitReport(rowData,aSCode)
		Continue:(+ReportDr)<1
		
		//保存检验结果
		Set LReportID=rowData.GetAt("ReportID")  //LIS报告ID
		Set:LabRepVer="LIS1.0" LReportID=rowData.GetAt("TestSetRow")
		Set TestSetStr=rowData.GetAt("TestSetStr")
		Set TSCode=$p(TestSetStr,"^",1)     //TSCode
		Set TSDesc=$p(TestSetStr,"^",2)     //TSDesc
		Set ArcimCode=$p(TestSetStr,"^",3)  //ArcimCode
		Set ArcimDesc=$p(TestSetStr,"^",4)  //ArcimDesc
		Set TestSetData=TSDesc_$c(1)_ArcimDesc
		
		If LabRepVer="LIS1.0" {
			Set ResultDatas=##Class(DHCHAI.DI.DIO.FromLis10Srv).GetRepResult(LReportID)
		} ElseIf (LabRepVer="LIS2.0"){
			Set ResultDatas=##Class(DHCHAI.DI.DIO.FromLisSrv).GetRepResult(LReportID)
		} ElseIf (LabRepVer="LISC1.0"){
			Set ResultDatas=##Class(DHCHAI.DI.DIO.EnsFromLis1Srv).GetRepResult(LReportID)
		} ElseIf (LabRepVer="LISC2.0"){
			Set ResultDatas=##Class(DHCHAI.DI.DIO.EnsFromLis2Srv).GetRepResult(LReportID)
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
			Set $p(ResultInfo,"^",14)=$p(ResultData,"^",12) //MultipleRes   //add 20230423

			Set ResultDr=..SaveVisitRepResult(ResultInfo,aSCode)
			Continue:(+ResultDr)<1
			
			//保存药敏试验结果
			Set LResultID=$p(ResultData,"^",1)  //LIS结果ID
			
			If LabRepVer="LIS1.0" {
				Set TestSenDatas=##Class(DHCHAI.DI.DIO.FromLis10Srv).GetResultSen(LResultID)
			} ElseIf (LabRepVer="LIS2.0"){
				Set TestSenDatas=##Class(DHCHAI.DI.DIO.FromLisSrv).GetResultSen(LResultID)
			} ElseIf (LabRepVer="LISC1.0"){
				Set TestSenDatas=##Class(DHCHAI.DI.DIO.EnsFromLis1Srv).GetResultSen(LResultID)
			} ElseIf (LabRepVer="LISC2.0"){
				Set TestSenDatas=##Class(DHCHAI.DI.DIO.EnsFromLis2Srv).GetResultSen(LResultID)
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
				Set TestSenDr=..SaveVisitRepRstSen(TestSenInfo,aSCode)
				Continue:(+TestSenDr)<1
			}
			
			//保存耐药机制结果
			If LabRepVer="LIS1.0" {
				Set RstResDatas=""
			} ElseIf (LabRepVer="LIS2.0"){
				Set RstResDatas=##Class(DHCHAI.DI.DIO.FromLisSrv).GetRepRstRes(LResultID)
			} ElseIf (LabRepVer="LISC1.0"){
				Set RstResDatas=""
			} ElseIf (LabRepVer="LISC2.0"){
				//Set RstResDatas=##Class(web.DHCENS.STBLL.Method.PostReportInfo).GetRepRstRes(LResultID)
				Set RstResDatas=##Class(DHCHAI.DI.DIO.EnsFromLis2Srv).GetRepRstRes(LResultID)
			}
			
			For indRes=1:1:$listlength(RstResDatas) {
				Set RstResData=$listget(RstResDatas,indRes)
				Continue:RstResData=""
			
				Set RstResInfo=""
				Set $p(RstResInfo,"^",1)=ResultDr
				Set $p(RstResInfo,"^",2)=$p(RstResData,"^",3)   //ResItemCode
				Set $p(RstResInfo,"^",3)=$p(RstResData,"^",4)   //ResItemName
				Set $p(RstResInfo,"^",4)=$p(RstResData,"^",6)   //RstCode
				Set $p(RstResInfo,"^",5)=$p(RstResData,"^",7)   //RstName
				Set $p(RstResInfo,"^",6)=EpisodeDr             //EpisodeDr
				Set RstResDr=..SaveVisitRepRstRes(RstResInfo,aSCode)
				Continue:(+RstResDr)<1
			}
		}
		
		//计数
		Set Count=Count+1
    }
    
    Set return=Count
    Quit return
    
SyncLabRepByDateErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod SaveVisitNumber(rd As %ArrayOfDataTypes, aSCode As %String) As %String
{
	New (rd,aSCode)
	Set return=0
	Quit:(rd="")||(aSCode="") return
	
	Set $ZT="SaveVisitNumberErr"
	
	Set XCode=rd.GetAt("VisitNumberID")
	Set EpisodeID = rd.GetAt("EpisodeID")
	Set EpisodeDr = rd.GetAt("EpisodeDr")
	Set EpisodeNo=rd.GetAt("EpisodeNo")
	Set SpecCode=rd.GetAt("SpecCode")
	Set SpecDesc=rd.GetAt("SpecDesc")
	Set LocCode=rd.GetAt("LocCode")
	Set LocDesc=rd.GetAt("LocDesc")
	Set CollDate=rd.GetAt("CollDate")
	Set CollTime=rd.GetAt("CollTime")
	Set CollUserID=""
	Set CollUserCode=rd.GetAt("CollUserCode")
	Set CollUserName=rd.GetAt("CollUserName")
	Set RecDate=rd.GetAt("RecDate")
	Set RecTime=rd.GetAt("RecTime")
	Set RecUserID=""
	Set RecUserCode=rd.GetAt("RecUserCode")
	Set RecUserName=rd.GetAt("RecUserName")
	Set IsActive=rd.GetAt("IsActive")
	Set WardCode=rd.GetAt("WardCode")
	Set WardDesc=rd.GetAt("WardDesc")
	Set ReqNotes=rd.GetAt("ReqNotes")
	Quit:(XCode="")||(EpisodeDr="") return
	
	//申请病区
	Set WardDr=""
	Set objWard=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,WardCode)
	If $IsObject(objWard) {
		Set WardDr=objWard.%Id()
	}
	//检验BT_Location有部分数据Code与HISCode的存储是反的
	If (WardDr="") {
		Set objWard=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,WardCode)
		If $IsObject(objWard) {
			Set WardDr=objWard.%Id()
		}
	}
	//如果申请病区为空，按接收时间所在病区计
	If (WardDr =""){
		Set TransInfo=##class(DHCHAI.DPS.PAAdmTransSrv).GetTransInfoByDate(EpisodeDr,RecDate,RecTime)
		Set WardDr =$p(TransInfo,"^",2)
	}
	
	//申请科室
	Set LocationDr=""
	Set objLocation=##class(DHCHAI.BT.Location).GetObjByLocCode(aSCode,LocCode)
	If $IsObject(objLocation) {
		Set LocationDr=objLocation.%Id()
	}
	//检验BT_Location有部分数据Code与HISCode的存储是反的
	If (LocationDr="") {
		Set objLocation=##class(DHCHAI.BT.Location).GetObjByXCode(aSCode,LocCode)
		If $IsObject(objLocation) {
			Set LocationDr=objLocation.%Id()
		}
	}
	//索引码
	Set VisitNumberDr=""
	Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjByXCode(aSCode,XCode)
	If $IsObject(objVisitNumber){
		Set VisitNumberDr=objVisitNumber.%Id()
	}
	
	//1.保存标本记录
	Set InputStr = VisitNumberDr
	Set InputStr = InputStr_"^"_EpisodeDr
	Set InputStr = InputStr_"^"_EpisodeNo	// 检验号/标本号
	Set InputStr = InputStr_"^"_SpecDesc	// 标本
	Set InputStr = InputStr_"^"_LocationDr	// 申请科室|送检科室？
	Set InputStr = InputStr_"^"_CollDate	// 采集日期
	Set InputStr = InputStr_"^"_CollTime	// 采集时间
	Set InputStr = InputStr_"^"_CollUserID_"|"_CollUserCode_"|"_CollUserName  // 采集者
	Set InputStr = InputStr_"^"_RecDate	    // 接收日期
	Set InputStr = InputStr_"^"_RecTime	    // 接收时间
	Set InputStr = InputStr_"^"_RecUserID_"|"_RecUserCode_"|"_RecUserName    // 接收者
	Set InputStr = InputStr_"^"_aSCode
	Set InputStr = InputStr_"^"_XCode
	Set InputStr = InputStr_"^"_IsActive
	Set InputStr = InputStr_"^"_+$h
	Set InputStr = InputStr_"^"_+$p($h,",",2)
	Set InputStr = InputStr_"^"_WardDr
	Set InputStr = InputStr_"^"_ReqNotes  //医嘱备注 add 20230424
	Set VisitNumberDr = ##class(DHCHAI.DP.LabVisitNumber).Update(InputStr,"^")
	If (+VisitNumberDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.LabVisitNumber"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Set return=VisitNumberDr
	
	//2.保存标本对照（重复记录不再处理）
	If (SpecDesc'="") {
		Set objSpecMap=##class(DHCHAI.DP.LabSpecMap).GetObjBySpecimen(aSCode,SpecDesc)
		If '$IsObject(objSpecMap){
			Set MapItemDr=""
			Set objSpecimen=##class(DHCHAI.DP.LabSpecimen).GetObjByCodeDesc("",SpecDesc)
			Set:$IsObject(objSpecimen) MapItemDr=objSpecimen.%Id()
			
			Set InputStr = ""
			Set InputStr = InputStr_"^"_SpecDesc	    //标本名称
			Set InputStr = InputStr_"^"_MapItemDr		//标准标本名称
			Set InputStr = InputStr_"^"_""				//标准备注
			Set InputStr = InputStr_"^"_aSCode			//子系统代码
			Set InputStr = InputStr_"^"_1				//有效标志
			Set InputStr = InputStr_"^"_""				//处置日期
			Set InputStr = InputStr_"^"_""				//处置时间
			Set InputStr = InputStr_"^"_""				//处置人
			Set SpecMapDr=##class(DHCHAI.DP.LabSpecMap).Update(InputStr,"^")
			If (+SpecMapDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DP.LabSpecMap"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	
	Quit return
	
SaveVisitNumberErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod SaveVisitTestSet(rd As %ArrayOfDataTypes, aSCode As %String) As %String
{
	New (rd,aSCode)
	Set return=0
	Quit:(rd="")||(aSCode="") return
	
	Set $ZT="SaveVisitTestSetErr"
	
	Set EpisodeDr = rd.GetAt("EpisodeDr")
	Set VisitNumberDr=rd.GetAt("VisitNumberDr")
	Set TestSetStr=rd.GetAt("TestSetStr")
	Quit:(VisitNumberDr="")||(TestSetStr="") return
	
	//合管医嘱
	Set ComTestCode=""
	If ($l(TestSetStr,"!!")>1) {
		For indTS=1:1:$l(TestSetStr,"!!") {
			Set TestSetData=$p(TestSetStr,"!!",indTS)
			Continue:TestSetData=""
		
			Set TSCode=$p(TestSetData,"^",1)     //TSCode
		    Set ComTestCode=ComTestCode_","_TSCode
		}
		Set:ComTestCode'="" ComTestCode=$e(ComTestCode,2,$l(ComTestCode)) 
	}

	//2.保存检验医嘱
	For indTS=1:1:$l(TestSetStr,"!!") {
		Set TestSetData=$p(TestSetStr,"!!",indTS)
		Continue:TestSetData=""
		
		Set TSCode=$p(TestSetData,"^",1)     //TSCode
		Set TSDesc=$p(TestSetData,"^",2)     //TSDesc
		Set ArcimCode=$p(TestSetData,"^",3)  //ArcimCode
		Set ArcimDesc=$p(TestSetData,"^",4)  //ArcimDesc
		Continue:(TSDesc="")
		
		Set TSDesc=##Class(DHCHAI.Utils.CommonSrv).ChangeKeyStr(TSDesc)  //去掉特殊字符
		Continue:TSDesc=""
		
		//保存LIS检验医嘱记录（重复记录不再处理）
		Set objVisitTestSet=##class(DHCHAI.DP.LabVisitTestSet).GetObjByDesc(VisitNumberDr,TSDesc)
		If '$IsObject(objVisitTestSet){
			Set InputStr = ""
			Set InputStr = InputStr_"^"_VisitNumberDr
			Set InputStr = InputStr_"^"_TSDesc
			Set InputStr = InputStr_"^"_TSCode
			Set InputStr = InputStr_"^"_ArcimDesc
			Set InputStr = InputStr_"^"_ArcimCode
			Set InputStr = InputStr_"^"_ComTestCode
			Set VisitTestSetDr=##class(DHCHAI.DP.LabVisitTestSet).Update(InputStr,"^")
			If (+VisitTestSetDr)<0 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DP.LabVisitTestSet"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
		
		//保存LIS检验医嘱对照（重复记录不再处理）
		Set objTestSetMap=##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(aSCode,TSDesc)
		If '$IsObject(objTestSetMap){
			Set MapItemDr=""
			Set objTestSet=##class(DHCHAI.DP.LabTestSet).GetObjByCodeDesc("",TSDesc)
			Set:$IsObject(objTestSet) MapItemDr=objTestSet.%Id()
			
			Set InputStr = ""
			Set InputStr = InputStr_"^"_TSDesc    				//检验医嘱名称
			Set InputStr = InputStr_"^"_ArcimDesc    			//医嘱项名称
			Set InputStr = InputStr_"^"_MapItemDr				//标准医嘱名称
			Set InputStr = InputStr_"^"_""						//标准备注
			Set InputStr = InputStr_"^"_aSCode					//子系统代码
			Set InputStr = InputStr_"^"_1						//有效标志
			Set InputStr = InputStr_"^"_""						//处置日期
			Set InputStr = InputStr_"^"_""						//处置时间
			Set InputStr = InputStr_"^"_""						//处置人
			Set TestSetMapDr=##class(DHCHAI.DP.LabTestSetMap).Update(InputStr,"^")
			If (+TestSetMapDr)<0 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DP.LabTestSetMap"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	
	Set return=1
	Quit return
	
SaveVisitTestSetErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod SaveVisitReport(rd As %ArrayOfDataTypes, aSCode As %String) As %String
{
	New (rd,aSCode)
	Set return=0
	Quit:(rd="")||(aSCode="") return
	
	Set $ZT="SaveVisitReportErr"
	
	Set EpisodeDr = rd.GetAt("EpisodeDr")
	Set VisitNumberDr = rd.GetAt("VisitNumberDr")
	Set ReportID = rd.GetAt("ReportID")
	Set RepOrder = rd.GetAt("Order")
	Set XCode = ReportID_"||"_RepOrder
	Set TestSetRow = rd.GetAt("TestSetRow")
	Set RepStatus = rd.GetAt("RepStatus")
	Set RegDate = rd.GetAt("RegDate")
	Set RegTime = rd.GetAt("RegTime")
	Set RegUserID=""
	Set RegUserCode = rd.GetAt("RegUserCode")
	Set RegUserName = rd.GetAt("RegUserName")
	Set AuthDate = rd.GetAt("AuthDate")
	Set AuthTime = rd.GetAt("AuthTime")
	Set AuthUserID=""
	Set AuthUserCode = rd.GetAt("AuthUserCode")
	Set AuthUserName = rd.GetAt("AuthUserName")
	Set IsActive = rd.GetAt("IsActive")
	Quit:(VisitNumberDr="")||(XCode="") return
	Quit:(AuthDate="")||(AuthTime="") return
	
	Set TestSetStr=rd.GetAt("TestSetStr")
	Set TSDesc=$p(TestSetStr,"^",2)  //TSDesc
	Set VisitTestSetDr=""
	Set objVisitTestSet=##class(DHCHAI.DP.LabVisitTestSet).GetObjByDesc(VisitNumberDr,TSDesc)
	If $IsObject(objVisitTestSet){
		Set VisitTestSetDr=objVisitTestSet.%Id()
	}
	
	Set VisitReportDr=""
	Set objVisitReport = ##class(DHCHAI.DP.LabVisitReport).GetObjByXCode(aSCode,XCode)
	If $IsObject(objVisitReport){
		Set VisitReportDr=objVisitReport.%Id()
	}
	
	Set InputStr = VisitReportDr
	Set InputStr = InputStr_"^"_VisitNumberDr
	Set InputStr = InputStr_"^"_ReportID
	Set InputStr = InputStr_"^"_RepOrder
	Set InputStr = InputStr_"^"_TestSetRow
	Set InputStr = InputStr_"^"_RepStatus
	Set InputStr = InputStr_"^"_RegDate
	Set InputStr = InputStr_"^"_RegTime
	Set InputStr = InputStr_"^"_RegUserID_"|"_RegUserCode_"|"_RegUserName
	Set InputStr = InputStr_"^"_AuthDate
	Set InputStr = InputStr_"^"_AuthTime
	Set InputStr = InputStr_"^"_AuthUserID_"|"_AuthUserCode_"|"_AuthUserName
	Set InputStr = InputStr_"^"_VisitTestSetDr
	Set InputStr = InputStr_"^"_aSCode
	Set InputStr = InputStr_"^"_XCode
	Set InputStr = InputStr_"^"_IsActive
	Set InputStr = InputStr_"^"_+$h
	Set InputStr = InputStr_"^"_+$p($h,",",2)
	
	Set VisitReportDr = ##class(DHCHAI.DP.LabVisitReport).Update(InputStr,"^")
	If (+VisitReportDr)<0 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.LabVisitReport"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Quit:(+VisitReportDr)<0 return
	Set return=VisitReportDr
	
	
	Quit return
	
SaveVisitReportErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod SaveVisitRepResult(aInputStr As %String, aSCode As %String) As %String
{
	New (aInputStr,aSCode)
	Set return=0
	Quit:(aInputStr="")||(aSCode="") return
	
	Set $ZT="SaveVisitRepResultErr"
	
	Set ReportDr     = $p(aInputStr,"^",1)
	Set TCCode       = $p(aInputStr,"^",2)
	Set TCDesc       = $p(aInputStr,"^",3)
	Set RstFormat    = $p(aInputStr,"^",4)
	Set Result       = $p(aInputStr,"^",5)
	Set TextRes      = $p(aInputStr,"^",6)
	Set ResNoes      = $p(aInputStr,"^",7)
	Set AbFlag       = $p(aInputStr,"^",8)
	Set Unit         = $p(aInputStr,"^",9)
	Set RefRanges    = $p(aInputStr,"^",10)
	Set MDRResult    = $p(aInputStr,"^",11)
	Set TestSetData  = $p(aInputStr,"^",12)
	Set EpisodeDr    = $p(aInputStr,"^",13)
	Set MultipleRes  = $p(aInputStr,"^",14)   //add 20230423
	Quit:(ReportDr="")||(TCCode="")||(TCDesc="") return
	
	Set VisitRepResultDr=""
	Set objVisitRepResult=##class(DHCHAI.DP.LabVisitRepResult).GetObjByTestCode(ReportDr,TCCode)
	If $IsObject(objVisitRepResult){
		Set VisitRepResultDr=objVisitRepResult.%Id()
	}
	
	Set InputStr = VisitRepResultDr
	Set InputStr = InputStr_"^"_ReportDr
	Set InputStr = InputStr_"^"_TCCode        //检验项目名称
	Set InputStr = InputStr_"^"_TCDesc        //检验项目代码
	Set InputStr = InputStr_"^"_RstFormat	  //结果类型
	Set InputStr = InputStr_"^"_Result	      //检测结果
	Set InputStr = InputStr_"^"_TextRes	      //定性结果
	Set InputStr = InputStr_"^"_ResNoes	      //结果说明(备注)
	Set InputStr = InputStr_"^"_AbFlag	      //异常提示
	Set InputStr = InputStr_"^"_Unit	      //单位
	Set InputStr = InputStr_"^"_RefRanges	  //参考范围
	Set InputStr = InputStr_"^"_MDRResult	  //多耐结果
	Set InputStr = InputStr_"^"_""
	Set InputStr = InputStr_"^"_""
	Set InputStr = InputStr_"^"_MultipleRes   //多耐类型 //add 20230423
	Set VisitRepResultDr = ##class(DHCHAI.DP.LabVisitRepResult).Update(InputStr,"^")
	If (+VisitRepResultDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.LabVisitRepResult"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Quit:(+VisitRepResultDr)<1 return
	Set return=VisitRepResultDr
	
	//保存检验项目（重复记录不再处理）
	Set objTCMap=##class(DHCHAI.DP.LabTCMap).GetObjByTestCode(aSCode,TCCode)
	If '$IsObject(objTCMap){
		Set InputStr = ""
		Set InputStr = InputStr_"^"_TCCode	   //检验项目代码
		Set InputStr = InputStr_"^"_TCDesc	   //检验项目名称
		Set InputStr = InputStr_"^"_RstFormat  //结果类型
		Set InputStr = InputStr_"^"_AbFlag     //异常标志（L,H,N集合）
		Set InputStr = InputStr_"^"_aSCode
		Set InputStr = InputStr_"^"_1
		Set InputStr = InputStr_"^"_""
		Set InputStr = InputStr_"^"_""
		Set InputStr = InputStr_"^"_""
		Set TCMapDr = ##class(DHCHAI.DP.LabTCMap).Update(InputStr,"^")
		If (+TCMapDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DP.LabTCMap"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	} Else {
		Set TCMapDr=objTCMap.%Id()
		Set RstFormat=objTCMap.BTRstFormat
	}
	Quit:(+TCMapDr)<1 return
	
	//保存检验医嘱（重复记录不再处理）
	Set TSDesc=$p(TestSetData,$c(1),1)
	Set ArcimDesc=$p(TestSetData,$c(1),2)
	If TSDesc'="" {
		Set TSMapDr=""
		Set objTSMap=##class(DHCHAI.DP.LabTestSetMap).GetObjByTestSet(aSCode,TSDesc)
		If $IsObject(objTSMap) {
			Set TSMapDr=objTSMap.%Id()
		}
		Set objTCMapTS=##class(DHCHAI.DP.LabTCMapTS).GetObjByTSMapDr(TCMapDr,TSMapDr)
		If '$IsObject(objTCMapTS){
			Set InputStr=""
			Set $p(InputStr,"^",1) = ""
			Set $p(InputStr,"^",2) = TCMapDr
			Set $p(InputStr,"^",3) = TSMapDr
			Set TCMapTSDr=##class(DHCHAI.DP.LabTCMapTS).Update(InputStr,"^")
			If (+TCMapTSDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DP.LabTCMapTS"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	
	//保存检验结果类型对照（重复记录不再处理）
	If RstFormat'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="LABRstFormat"
		Set $p(InputStr,"^",2)=RstFormat
		Set $p(InputStr,"^",3)=RstFormat
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		If (+PhraseMapDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	//保存结果类型字典（重复记录不再处理）
	Set tRstFormat=##class(DHCHAI.DP.PhraseMap).GetMapValue(aSCode,"LABRstFormat",RstFormat)
	Set:tRstFormat'="" RstFormat=tRstFormat
	If RstFormat="M" {
		Set Bacteria=Result    //细菌
		Set Bacteria2=TextRes  //细菌2
		If Bacteria'="" {
			Set objBactMap=##class(DHCHAI.DP.LabBactMap).GetObjByBacteria(aSCode,Bacteria)
			If '$IsObject(objBactMap){
				Set MapItemDr=""
				Set objBacteria=##class(DHCHAI.DP.LabBacteria).GetObjByCodeDesc("",Bacteria)
				Set:$IsObject(objBacteria) MapItemDr=objBacteria.%Id()
				
				Set InputStr = ""
				Set InputStr = InputStr_"^"_Bacteria			    //细菌名称
				Set InputStr = InputStr_"^"_MapItemDr				//标准细菌名称					
				Set InputStr = InputStr_"^"_""						//标准备注
				Set InputStr = InputStr_"^"_aSCode					//子系统代码
				Set InputStr = InputStr_"^"_1	
				Set InputStr = InputStr_"^"_""
				Set InputStr = InputStr_"^"_""
				Set InputStr = InputStr_"^"_""
				Set BactMapDr = ##class(DHCHAI.DP.LabBactMap).Update(InputStr,"^")
				If (+BactMapDr)<1 {
					//记录错误日志
					Set ErrClass  = "DHCHAI.DP.LabBactMap"
					Set ErrMethod = "Update"
					Set ErrArgStr = $lb(InputStr,"^")
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
				}
			}
		}
	} ElseIf (RstFormat="S")||(RstFormat="R")||(RstFormat="A") {
		Set TestResult=Result    //列表
		Set TestResult2=TextRes  //列表2
		Set:TestResult2'="" TestResult=TestResult2
		If TestResult'="" {
			Set objTCMapRst=##class(DHCHAI.DP.LabTCMapRst).GetObjByTCMapID(TCMapDr,TestResult)
			If '$IsObject(objTCMapRst){
				Set InputStr = ""
				Set InputStr = InputStr_"^"_TCMapDr			//检验项目对照
				Set InputStr = InputStr_"^"_TestResult      //定性结果
				Set InputStr = InputStr_"^"_""				//标准结果（阴性、阳性等）				
				Set InputStr = InputStr_"^"_""				//标准备注
				Set InputStr = InputStr_"^"_1	
				Set InputStr = InputStr_"^"_""
				Set InputStr = InputStr_"^"_""
				Set InputStr = InputStr_"^"_""
				Set TestResultMapDr=##class(DHCHAI.DP.LabTCMapRst).Update(InputStr,"^")
				If (+TestResultMapDr)<1 {
					//记录错误日志
					Set ErrClass  = "DHCHAI.DP.LabTCMapRst"
					Set ErrMethod = "Update"
					Set ErrArgStr = $lb(InputStr,"^")
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
				}
			}
		}
	}ElseIf (RstFormat="T") {  //add 20210512 处理检验结果为“+/-”或“阴性、阳性”的文本类结果
		Set TestResult=Result    //列表
		Set TestResult2=TextRes  //列表2
		Set:TestResult2'="" TestResult=TestResult2
		If ((TestResult="+")||(TestResult="-")||(TestResult="阳性")||(TestResult="阴性")){
			Set objTCMapRst=##class(DHCHAI.DP.LabTCMapRst).GetObjByTCMapID(TCMapDr,TestResult)
			If '$IsObject(objTCMapRst){
				Set InputStr = ""
				Set InputStr = InputStr_"^"_TCMapDr			//检验项目对照
				Set InputStr = InputStr_"^"_TestResult      //定性结果
				Set InputStr = InputStr_"^"_""				//标准结果（阴性、阳性等）				
				Set InputStr = InputStr_"^"_""				//标准备注
				Set InputStr = InputStr_"^"_1	
				Set InputStr = InputStr_"^"_""
				Set InputStr = InputStr_"^"_""
				Set InputStr = InputStr_"^"_""
				Set TestResultMapDr=##class(DHCHAI.DP.LabTCMapRst).Update(InputStr,"^")
				If (+TestResultMapDr)<1 {
					//记录错误日志
					Set ErrClass  = "DHCHAI.DP.LabTCMapRst"
					Set ErrMethod = "Update"
					Set ErrArgStr = $lb(InputStr,"^")
					Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
				}
			}
		}
	
	} Else {}
	
	//保存异常标志字典（重复记录不再处理）
	If AbFlag'="" {
		Set objTestAbFlagMap=##class(DHCHAI.DP.LabTCMapAb).GetObjByTCMapID(TCMapDr,AbFlag)
		If '$IsObject(objTestAbFlagMap){
			Set InputStr = ""
			Set InputStr = InputStr_"^"_TCMapDr			//检验项目对照
			Set InputStr = InputStr_"^"_AbFlag					//异常标志
			Set InputStr = InputStr_"^"_""						//异常标志（H、L等）				
			Set InputStr = InputStr_"^"_""						//标准备注
			Set InputStr = InputStr_"^"_1						//有效标志
			Set InputStr = InputStr_"^"_""						//处置日期
			Set InputStr = InputStr_"^"_""						//处置时间
			Set InputStr = InputStr_"^"_""						//处置人
			Set TestAbFlagMapDr=##class(DHCHAI.DP.LabTCMapAb).Update(InputStr,"^")
			If (+TestAbFlagMapDr)<1 {
				//记录错误日志
				Set ErrClass  = "DHCHAI.DP.LabTCMapAb"
				Set ErrMethod = "Update"
				Set ErrArgStr = $lb(InputStr,"^")
				Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
			}
		}
	}
	
	Quit return
	
SaveVisitRepResultErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod SaveVisitRepRstSen(aInputStr As %String, aSCode As %String) As %String
{
	New (aInputStr,aSCode)
	Set return=0
	Quit:(aInputStr="")||(aSCode="") return
	
	Set $ZT="SaveVisitRepRstSenErr"
	
	Set ResultDr   = $p(aInputStr,"^",1)
	Set AntCode    = $p(aInputStr,"^",2)
	Set AntDesc    = $p(aInputStr,"^",3)
	Set SenDesc    = $p(aInputStr,"^",4)
	Set EpisodeDr  = $p(aInputStr,"^",5)
	Quit:(ResultDr="")||(AntDesc="") return
	
	//保存药敏试验结果
	Set VisitRepRstSenDr=""
	Set objVisitRepRstSen=##class(DHCHAI.DP.LabVisitRepRstSen).GetObjByAntDesc(ResultDr,AntDesc)
	If $IsObject(objVisitRepRstSen){
		Set VisitRepRstSenDr=objVisitRepRstSen.%Id()
	}
	Set InputStr = VisitRepRstSenDr
	Set InputStr = InputStr_"^"_ResultDr			//检验结果
	Set InputStr = InputStr_"^"_AntCode				//抗生素代码
	Set InputStr = InputStr_"^"_AntDesc				//抗生素名称
	Set InputStr = InputStr_"^"_SenDesc    			//药敏结果
	Set VisitRepRstSenDr=##class(DHCHAI.DP.LabVisitRepRstSen).Update(InputStr,"^")
	If (+VisitRepRstSenDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.LabVisitRepRstSen"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Quit:(+VisitRepRstSenDr)<1 return
	Set return=VisitRepRstSenDr
	
	//保存抗生素对照（重复记录不再处理）
	Set objAntiMap=##class(DHCHAI.DP.LabAntiMap).GetObjByAntDesc(aSCode,AntDesc)
	If '$IsObject(objAntiMap){
		Set MapItemDr = ""
		Set objLabAntibiotic = ##class(DHCHAI.DP.LabAntibiotic).GetObjByCodeDesc("",AntDesc)
		Set:$IsObject(objLabAntibiotic) MapItemDr = objLabAntibiotic.%Id()
		
		Set InputStr = ""
		Set InputStr = InputStr_"^"_AntDesc			//抗生素名称
		Set InputStr = InputStr_"^"_MapItemDr		//标准抗生素名称					
		Set InputStr = InputStr_"^"_""				//标准备注
		Set InputStr = InputStr_"^"_aSCode			//子系统代码
		Set InputStr = InputStr_"^"_1	
		Set InputStr = InputStr_"^"_""
		Set InputStr = InputStr_"^"_""
		Set InputStr = InputStr_"^"_""
		Set AntiMapDr = ##class(DHCHAI.DP.LabAntiMap).Update(InputStr,"^")
		If (+AntiMapDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DP.LabAntiMap"
			Set ErrMethod = "Update"
			Set ErrArgStr = $lb(InputStr,"^")
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	//保存药敏类型对照（重复记录不再处理）
	If SenDesc'="" {
		Set InputStr=""
		Set $p(InputStr,"^",1)="LABTestRstSen"
		Set $p(InputStr,"^",2)=SenDesc
		Set $p(InputStr,"^",3)=SenDesc
		Set PhraseMapDr=##class(DHCHAI.DPS.PhraseMapSrv).SavePhraseMap(InputStr,aSCode)
		If (+PhraseMapDr)<1 {
			//记录错误日志
			Set ErrClass  = "DHCHAI.DPS.PhraseMapSrv"
			Set ErrMethod = "SavePhraseMap"
			Set ErrArgStr = $lb(InputStr,aSCode)
			Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
		}
	}
	
	Quit return
	
SaveVisitRepRstSenErr
	Set return="-999^"_$ZError
	Quit return
}

ClassMethod SaveVisitRepRstRes(aInputStr As %String, aSCode As %String) As %String
{
	New (aInputStr,aSCode)
	Set return=0
	Quit:(aInputStr="")||(aSCode="") return
	
	Set $ZT="SaveVisitRepRstResErr"

	Set ResultDr     = $p(aInputStr,"^",1)
	Set ResItemCode  = $p(aInputStr,"^",2)
	Set ResItemName  = $p(aInputStr,"^",3)
	Set ResRstCode   = $p(aInputStr,"^",4)
	Set ResRstName   = $p(aInputStr,"^",5)
	Set EpisodeDr    = $p(aInputStr,"^",6)
	Quit:(ResultDr="")||(EpisodeDr="") return
	
	//保存耐药机制
	Set VisitRepRstResDr=""
	Set objVisitRepRstRes=##class(DHCHAI.DP.LabVisitRepRstRes).GetObjByItemCode(ResultDr,ResItemCode)
	If $IsObject(objVisitRepRstRes){
		Set VisitRepRstResDr=objVisitRepRstRes.%Id()
	}
	Set InputStr = VisitRepRstResDr
	Set InputStr = InputStr_"^"_ResultDr			    //检验结果
	Set InputStr = InputStr_"^"_ResItemCode				//耐药项目代码
	Set InputStr = InputStr_"^"_ResItemName				//耐药项目名称
	Set InputStr = InputStr_"^"_ResRstCode    			//结果代码
	Set InputStr = InputStr_"^"_ResRstName    			//结果描述
	Set VisitRepRstResDr=##class(DHCHAI.DP.LabVisitRepRstRes).Update(InputStr,"^")
	If (+VisitRepRstResDr)<1 {
		//记录错误日志
		Set ErrClass  = "DHCHAI.DP.LabVisitRepRstRes"
		Set ErrMethod = "Update"
		Set ErrArgStr = $lb(InputStr,"^")
		Do ##class(DHCHAI.DPS.SyncErrLogSrv).SaveErrLog(EpisodeDr,ErrClass,ErrMethod,ErrArgStr)
	}
	Quit:(+VisitRepRstResDr)<1 return
	
	Set return=1
	Quit return
	
SaveVisitRepRstResErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2018-07-09
/// Description:  根据接收日期同步检验标本病区数据
/// 			  aEpisodeNo：检验号/标本号
///               DHCHAI.DP.LabVisitNumber
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncVisitNumberByDate("LIS01","2018-07-09","2018-07-09")
ClassMethod SyncVisitNumberByDate(aSCode As %String, aDateFrom As %String, aDateTo As %String) As %String
{
	New (aSCode,aDateFrom,aDateTo)
	Set return=0,Count=0
	Quit:aSCode="" return
	Quit:(aDateFrom="")||(aDateTo="") return
	Set $ZT="SyncVisitNumberByDateErr"
	
	Set objSYS=##class(DHCHAI.BT.SystemMap).GetObjByCode(aSCode)
	Quit:'$IsObject(objSYS) return
	Quit:'$IsObject(objSYS.BTTypeDr) return
	Set SYSType=objSYS.BTTypeDr.BTCode
	Quit:SYSType'="LIS" return  //检验系统
	
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Set CurrTime = $h
	
	// 版本说明：
	// LIS1.0  ：从东华检验（CS版）直接获取检验报告信息
	// LIS2.0  ：从东华检验（BS版）直接获取检验报告信息
	// LISC1.0 ：从平台（文档）获取检验报告信息
	// LISC2.0 ：从平台（结构化）获取检验报告信息
	Set LabRepVer=##class(DHCHAI.BT.Config).GetValByCode("DPLabReportVer")
	Quit:(LabRepVer'="LIS1.0")&&(LabRepVer'="LIS2.0")&&(LabRepVer'="LISC1.0")&&(LabRepVer'="LISC2.0") return
	
	Set xRecDate=aDateFrom-1
	For {
		Set xRecDate=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime"," "_aSCode,xRecDate))
		Quit:xRecDate=""
		Quit:xRecDate>aDateTo
		Set xTime=""    //update 2022-01-20  Time=0，0点病人会遗漏
		For {
			Set xTime=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime"," "_aSCode,xRecDate,xTime))
			Quit:xTime=""
		
			Set xID=0
			For {
				Set xID=$o(^DHCHAI.DP.LabVisitNumberI("IndexRecDateTime"," "_aSCode,xRecDate,xTime,xID))
				Quit:xID=""
				
				Set objVisitNumber=##class(DHCHAI.DP.LabVisitNumber).GetObjById(xID)
				Continue:'$IsObject(objVisitNumber)
				
				Set EpisodeNo=objVisitNumber.LabEpisodeNo
				If LabRepVer="LIS1.0" {
					Set flg=##Class(DHCHAI.DI.DIO.FromLis10Srv).SyncVisitNumber(aSCode,EpisodeNo)
				} ElseIf LabRepVer="LIS2.0" {
					Set flg=##Class(DHCHAI.DI.DIO.FromLisSrv).SyncVisitNumber(aSCode,EpisodeNo)
				} ElseIf LabRepVer="LISC1.0" {
					Set flg=##Class(DHCHAI.DI.DIO.EnsFromLis1Srv).SyncVisitNumber(aSCode,EpisodeNo)
				} ElseIf LabRepVer="LISC2.0" {
					Set flg=##Class(DHCHAI.DI.DIO.EnsFromLis2Srv).SyncVisitNumber(aSCode,EpisodeNo)
				}
				//计数
				If (flg>0){
					Set Count=Count+1
				}
				
			}
		}
    }
    Write "用时："_($p($h,",",2)-$p(CurrTime,",",2))_"s",!
    
    Set return=Count
    Quit return
	
SyncVisitNumberByDateErr
	Set return="-999^"_$ZError
	Quit return
}

/// Creator：     pylian
/// CreatDate：   2022-03-07
/// Description:  根据报告日期同步检验污染标本数据
/// 			  
///               DHCHAI.DP.LabVisitReport、DHCHAI.DP.LabVisitRepResult
/// Return：      处理数
/// w ##class(DHCHAI.DI.DHS.SyncLabInfo).SyncInfTypeByDate("2022-03-01","2022-03-09")
ClassMethod SyncInfTypeByDate(aDateFrom As %String, aDateTo As %String) As %String
{
	New (aDateFrom,aDateTo)
	Set return=0,Count=0

	Quit:(aDateFrom="")||(aDateTo="") return
	Set $ZT="SyncInfTypeByDateErr"
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	
	Kill arrResult
	For xDate = aDateFrom:1:aDateTo {		
		Set xTime = ""
		For {
			Set xTime = $o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime))
			Quit:xTime=""
			
			Set xReportDr=""
			For {
				Set xReportDr=$o(^DHCHAI.DP.LabVisitReportI("IndexAuthDateTime",xDate,xTime,xReportDr))
				Quit:xReportDr=""
				
				Set LabReportData = $g(^DHCHAI.DP.LabVisitReportD(xReportDr))
				Continue:LabReportData=""				
				Set LabIsActive	=$lg(LabReportData,18)
				Continue:LabIsActive'=1
				
				Set xResultDr=""
				For {
					Set xResultDr=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabRstFormat",xReportDr,"M",xResultDr))
					Quit:xResultDr=""
					
					Set LabResultData = $g(^DHCHAI.DP.LabVisitRepResultD(xResultDr))
					Continue:LabResultData=""		
				    Set InfType=$lg(LabResultData,13)
					Continue:InfType'=4          //非污染细菌不记录
					
					Set arrResult("LabReport",xReportDr,xResultDr)=""
				}
			}
		}
	}  
	
    Set xReportID=""
    For {
	   	Set xReportID=$o(arrResult("LabReport",xReportID))
       	Quit:xReportID=""
       	      
       	Set xResultID=""
		For {
			Set xResultID=$o(^DHCHAI.DP.LabVisitRepResultI("IndexLabRstFormat",xReportID,"M",xResultID))
			Quit:xResultID=""
			Continue:$d(arrResult("LabReport",xReportID,xResultID))    //初始已标记记录不修改
			
			Set obj=##class(DHCHAI.DP.LabVisitRepResult).%OpenId(xResultID)
			Continue:'$IsObject(obj)
			Set obj.LabMakeInfType=4
		
			Set sc=obj.%Save()
			if $system.Status.IsError(sc) {        //检查Save是否成功
		   		Do $system.OBJ.DisplayError(sc)
		   		Set return=-1
			}else{
				Set return=obj.%Id()
				Set Count=Count+1
			}
			Do obj.%Close()	
				
		}
    }
	
    Kill arrResult
    Set return=Count
    Quit return
	
SyncInfTypeByDateErr
	Set return="-999^"_$ZError
	Quit return
}

}
