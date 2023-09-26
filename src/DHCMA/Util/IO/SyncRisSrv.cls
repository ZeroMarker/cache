/// 名称: DHCMA.Util.IO.SyncRisSrv
/// 描述: RIS(v1.0)提供接口服务
/// 编写者：zhufei
/// 编写日期: 2019-09-26
Class DHCMA.Util.IO.SyncRisSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      zhufei
/// CreatDate：    2019-09-26
/// Description:   根据就诊号查询检验报告信息
/// Table：        无
/// Input：        aEpisodeID ：就诊号
///                aDateFrom  ：开始日期
///                aDateTo    ：截止日期
/// Output：       ROWSPEC=检查报告信息
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncLis1Srv","QryRisReportInfo","","","")
Query QryRisReportInfo(aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aARCCodes As %String = "") As %Query(ROWSPEC = "ID:%String,StatusCode:%String,StatusDesc:%String,StudyNo:%String,OEItemID:%String,OrdItemCode:%String,OrdItemDesc:%String,RegDate:%String,RegTime:%String,RegUserCode:%String,RegUserDesc:%String,RepDate:%String,RepTime:%String,RepUserCode:%String,RepUserDesc:%String,ExamDesc:%String,ExamResult:%String,Memo:%String")
{
}

ClassMethod QryRisReportInfoExecute(ByRef qHandle As %Binary, aEpisodeID As %String, aDateFrom As %String, aDateTo As %String, aARCCodes As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
	Quit:aEpisodeID="" $$$OK
	Set:aDateFrom["-" aDateFrom=$zdh(aDateFrom,3)
	Set:aDateTo["-" aDateTo=$zdh(aDateTo,3)
	Quit:(aDateFrom="")||(aDateTo="") $$$OK
	Set aARCCodes=$g(aARCCodes)
	
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
		
        //报告状态（有效状态V和S）
	 	//N^未写报告、I^已有图像、R^已录入、V^已审核、S^已发布、D^全科会诊
	 	Set StatusDr=$p(ReportData,"^",4)       
	 	Set StatusCode=$p($g(^DHCRBCStatus("ReportStatus",+StatusDr)),"^",1) 
	 	Set StatusDesc=$p($g(^DHCRBCStatus("ReportStatus",+StatusDr)),"^",2)  
 	    //Continue:(StatusCode'="V")&&(StatusCode'="S") 
 	    
	 	Set StudyNo=$p(ReportData,"^",1)        //检查号
	 	Set OEItemID=$p(ReportData,"^",15)      //医嘱ID
	 	Set ArcimID=$p(^OEORD(+OEItemID,"I",+$p(OEItemID,"||",2),1),"^",2)
	 	Continue:ArcimID=""
		Set OrdItemCode=$p($g(^ARCIM(+ArcimID,1,1)),"^",1)		           //检查项目代码
		Set OrdItemDesc=$p($g(^ARCIM(+ArcimID,1,1)),"^",2)	               //检查项目名称
		Continue:(aARCCodes'="")&((","_aARCCodes_",")'[(","_OrdItemCode_","))
	 	Set Memo=$g(^DHCRBStudy("Report",xID,"MemoEx"))              //备注信息
		Set ExamDesc=$g(^DHCRBStudy("Report",xID,"ExamDescEx"))      //检查所见
	    Set ExamResult=$g(^DHCRBStudy("Report",xID,"ResultDescEx"))  //诊断意见
    	
    	Set RepDate=$p(ReportData,"^",9)        //报告日期
	    Set RepTime=$p(ReportData,"^",10)       //报告时间
	    Set RepUserDr=$p(ReportData,"^",8)      //报告人
	    Set RepUserCode="",RepUserDesc=""
		If RepUserDr'="" {
			Set RepUserCode=$p($g(^SSU("SSUSR",RepUserDr)),"^",1)
			Set RepUserDesc=$p($g(^SSU("SSUSR",RepUserDr)),"^",2)
		}
		
		Set RegDate="",RegTime=""
		Set RegUserCode="",RegUserDesc=""
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
		
		Set Data=$lb(xID,StatusCode,StatusDesc,StudyNo,OEItemID,OrdItemCode,OrdItemDesc,RegDate,RegTime,RegUserCode,RegUserDesc,RepDate,RepTime,RepUserCode,RepUserDesc,ExamDesc,ExamResult,Memo)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryRisReportInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRisReportInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryRisReportInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRisReportInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator：      zhufei
/// CreatDate：    2020-03-06
/// Description:   查询检查项目字典
/// Table：        User.DHCAppPart
/// Input：        无
/// Output：       代码：Code、名称：Desc
/// d ##class(%ResultSet).RunQuery("DHCMA.Util.IO.SyncRisSrv","GetAppPartDic","")
Query GetAppPartDic(aID As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Desc:%String,LastID:%String,IsActive:%String,ArcStr:%String")
{
}

ClassMethod GetAppPartDicExecute(ByRef qHandle As %Binary, aID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	Set qHandle=$lb(0,repid,0)
 	
 	Kill ^TMP($zn,$j,"GetAppPartDic")
 	//构建临时索引
 	Set xAPID=0
 	For {
	 	Set xAPID=$o(^DHCAPARCL(xAPID))
	 	Quit:xAPID=""
	 	Set ArcDr=$p($g(^DHCAPARCL(xAPID)),"^",1)
	 	Set PartDr=$p($g(^DHCAPARCL(xAPID)),"^",2)
	 	Set ^TMP($zn,$j,"GetAppPartDic",PartDr,ArcDr)=xAPID
	}
 	
 	If aID'="" {
	 	Do BuildPartDicData(aID)
	} Else {
	 	Set xID=0
	 	For {
			Set xID=$o(^DHCAPPART(xID))
			Quit:xID=""
			
			Do BuildPartDicData(xID)
	 	}
	}
	Kill ^TMP($zn,$j,"GetAppPartDic")
	
	Quit $$$OK
 	
BuildPartDicData(xID)
	Set AppPartData=$g(^DHCAPPART(xID))
	Set PartCode=$p(AppPartData,"^",1)
	Set PartDesc=$p(AppPartData,"^",2)
	Set LastID=$p(AppPartData,"^",3)
	Set:LastID=0 LastID=""
	Set IsActive=$p(AppPartData,"^",5)
	Set IsActive=$s(IsActive="Y":1,1:0)
	Quit:(PartCode="")||(PartDesc="")
	
	Set ArcStr=""
	Set xArcID=0
	For {
		Set xArcID=$o(^TMP($zn,$j,"GetAppPartDic",xID,xArcID))
		Quit:xArcID=""
		
		Set ArcStr=ArcStr_"^"_xArcID
	}
	Set:ArcStr'="" ArcStr=$e(ArcStr,2,$l(ArcStr))
	
	set Data=$lb(xID,PartCode,PartDesc,LastID,IsActive,ArcStr)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetAppPartDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAppPartDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAppPartDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAppPartDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

}
