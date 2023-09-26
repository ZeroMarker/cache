Import SQLUser

/// Creator:	 cjb
/// Description: 基于电子病历的临床报告公共函数
/// Updater:     
/// UpdateDate： 2010-03-08
Class DHCMed.CRService.ReportCtl Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 36;

/// Creator：     cjb
/// CreatDate：   2009-06-15
/// Description:  根据综合条件查询临床报告
/// Table：       
/// Input：       时间段，报告科室 报告状态
///               DateFrom 开始时间
///               DateTo   结束时间
///               CtLoc    科室
///               Status   状态
///               PrjIDVal 临床上报项目IDs
/// Return：      $lb(临床上报相关信息)
/// d ##Class(%ResultSet).RunQuery("DHCMed.CRService.ReportCtl","QueryReport","","","","","")
Query QueryReport(DateFrom As %String, DateTo As %String, CtLoc As %String, Status As %String, PrjIDVal As %String) As %Query(ROWSPEC = "Rowid:%String,InstanceID:%String,ProjectID:%String,EpisodeID:%String,RepStatus:%String,RepDoc:%String,RepDate:%String,RepTime:%String,CheckUser:%String,CheckDate:%String,CheckTime:%String,ReturnRes:%String,Text1:%String,Text2:%String,Resume:%String,RepCtloc:%String,RegNo:%String,Papmi:%String,PatName:%String,CatID:%String,docPrintID:%String,RepNo:%String,ProjectDesc:%String")
{
}

ClassMethod QueryReportExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, CtLoc As %String, Status As %String, PrjIDVal As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	//同步电子病历与临床上报数据
	Set flg=##class(DHCMed.CRService.Interface).SyncDataEPRToCR("")
	Quit:flg<0 $$$OK
	
    Set:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    Set:DateTo["/" DateTo=$zdh(DateTo,4)
    Set:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    Set:DateTo["-" DateTo=$zdh(DateTo,3)
    Set:DateFrom'="" DateFrom=+DateFrom
    Set:DateTo'="" DateTo=+DateTo
    Quit:(DateFrom="")||(DateTo="") $$$OK
    Quit:DateFrom>DateTo $$$OK
    
    //Index DateLoc On (RepDate As Exact, RepCtloc As SqlString);
    Set RepDate=DateFrom-1
    For {
		Set RepDate=$o(^DHCMed.CR.ReportI("DateLoc",RepDate))
		Quit:(RepDate="")||(RepDate>DateTo)
		Set RepLoc=""
		For {
			Set RepLoc=$o(^DHCMed.CR.ReportI("DateLoc",RepDate,RepLoc))
			Quit:RepLoc=""
			Quit:(CtLoc'="")&&($e(RepLoc,2,$l(RepLoc))'=CtLoc)
			Set ReportID=0
			For {
				Set ReportID=$o(^DHCMed.CR.ReportI("DateLoc",RepDate,RepLoc,ReportID))
				Quit:ReportID=""
				
				//同步电子病历与临床上报状态数据
				Set RepStatus=##Class(DHCMed.CRService.Interface).GetStatusByRepID(ReportID)
				
				Set ReportStr=##Class(DHCMed.CR.Report).GetById(ReportID)
				Set ProjectID=$p(ReportStr,"^",3)
				Continue:(PrjIDVal'="")&&(("|"_PrjIDVal_"|")'[("|"_ProjectID_"|"))
				Set EpisodeID=$p(ReportStr,"^",4)
				Set RepStatus=$p(ReportStr,"^",5)
				Continue:(Status'="")&&(Status'[RepStatus)
				Set:RepStatus'="R" $p(ReportStr,"^",12)=""
				Set RepStatus=$s(RepStatus="D":"待审",RepStatus="Y":"已审",RepStatus="R":"退回",RepStatus="S":"删除",1:"")
				Set $p(ReportStr,"^",5)=RepStatus
				Set RepNo=$p($p(ReportStr,"^",7),"-")_$tr($justify($p(ReportStr,"^",1),4)," ",0)   //报告编号
				Set RepUser=$p(ReportStr,"^",6)    //报告人
				Set UserInfo=##class(DHCMed.CRService.CommonFun).GetLogUserInfo(+RepUser)
				Set $p(ReportStr,"^",6)=$p(UserInfo,"^",3)
				Set CheckUser=$p(ReportStr,"^",9)  //审核人
				Set UserInfo=##class(DHCMed.CRService.CommonFun).GetLogUserInfo(+CheckUser)
				Set $p(ReportStr,"^",9)=$p(UserInfo,"^",3)
				
				Set Papmi=$p($g(^PAADM(+EpisodeID)),"^",1)
				Set RegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
				Set PatName=$p(^PAPER(Papmi,"ALL"),"^",1)
				
				Set ProjectInfo=##Class(DHCMed.CR.Project).GetById(ProjectID)
				Set ProjectDesc=$p(ProjectInfo,"^",3)
				Set CatID=$p(ProjectInfo,"^",6)     //界面模板ID
				Set DocID=$p(ProjectInfo,"^",4)     //打印模板ID
				
				Set tmp=ReportStr_"^"_RegNo_"^"_Papmi_"^"_PatName_"^"_CatID_"^"_DocID_"^"_RepNo_"^"_ProjectDesc
				Set Data=$lb("")
				For iBuild=1:1:$l(tmp,"^") {
					Set $li(Data,iBuild)=$p(tmp,"^",iBuild)
				}
			 	Set ^CacheTemp(repid,ind)=Data
			 	Set ind=ind+1
			}
		}
	}
	
    Quit $$$OK
}

ClassMethod QueryReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryReportExecute ]
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
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// Creator：    cjb
/// CreatDate：  2010-03-05
/// Description：临床报告打印列表数据
/// Query：      QueryReport
/// Input：      itmjs：js处理返回值函数
/// 			 strArguments：Query入参，"^"分隔。stDt+"^"+enDT+"^"statusStr"^"+ctLoc
/// Return：     返回值交由js中itmjs方法处理
/// Debug:       w ##Class(web.DHCWMRVolumeQry).QueryCurrStatusByDateToPrint(itmjs,strArguments)
ClassMethod QueryRepToPrint(itmjs As %Library.String = "", strArguments As %String) As %Status
{
	n (itmjs,strArguments)
	s Count=0
	
	s stDT=$p(strArguments,"^",1)
	s endDT=$p(strArguments,"^",2)
	s ctLoc=$p(strArguments,"^",3)
	s statusStr=$p(strArguments,"^",4)
    s PrjIDVal=$p(strArguments,"^",5)
	s ds = ##class(%Library.ResultSet).%New("DHCMed.CRService.ReportCtl.QueryReport")
	d ds.Execute(stDT,endDT,ctLoc,statusStr,PrjIDVal)
	s StartRow=4
	while(ds.Next())
	{
		s RepNo=ds.Data("RepNo")						//报告编号
		s RegNo=ds.Data("RegNo")				        //登记号
		s PatName=ds.Data("PatName") 	                //姓名
		s RepStatus=ds.Data("RepStatus") 		        //报告状态
		s RepDoc=ds.Data("RepDoc")	                    //报告医生
		s RepDate=ds.Data("RepDate")		            //报告日期
		s CheckUser=ds.Data("CheckUser")			    //审核人
		s CheckDate=ds.Data("CheckDate")				//审核日期

		s valCells=RepNo_$c(1)_RegNo_$c(1)_PatName_$c(1)_RepStatus_$c(1)_RepDoc_$c(1)_RepDate_$c(1)_CheckUser_$c(1)_CheckDate
	 	s retval=itmjs_"(xlSheet,'"_$ZCVT(valCells,"O","JS")_"',"_StartRow_",1);"
		&javascript<#(retval)#>
		s Count=Count+1
		s StartRow=StartRow+1
	}
	d ds.Close()
	q Count
}

ClassMethod CheckReport(Rowid, chkUser)
{
	n (Rowid, chkUser)
	set:Rowid'="" obj=##class(DHCMed.CR.Report).%OpenId(+Rowid)
	s st=obj.RepStatus
	q:st="Y" -1000
	set obj.CheckUser=chkUser
	set obj.RepStatus="Y"
    set obj.CheckDate = +$h
    set obj.CheckTime = $p($h,",",2)
    set rt=obj.%Save()
	If ($$$ISERR(rt)) {
		w !,"Error="_rt
		s id="-1"_rt
	}
	else
	{
		s id=obj.%Id()
		s sbChild=##class(DHCMed.CR.RepStatus).Update(id_"^^Y^"_chkUser_"^^^")
		if +sbChild<0 s id="-1"_id
		}
	d obj.%Close()
	q id
}

ClassMethod ReturnReport(Rowid, ReturnRes, userName)
{
	n (Rowid, ReturnRes,userName)
	set:Rowid'="" obj=##class(DHCMed.CR.Report).%OpenId(+Rowid)
	s st=obj.RepStatus
	q:st="Y" -1000
	set obj.RepStatus="R"
	set obj.ReturnRes=ReturnRes
    set rt=obj.%Save()
	If ($$$ISERR(rt)) {
		w !,"Error="_rt
		s id="-1"_rt
	}
	else
	{
		s id=obj.%Id()
		s sbChild=##class(DHCMed.CR.RepStatus).Update(id_"^^R^"_userName_"^^^")
		if +sbChild<0 s id="-1"_id
		}
	d obj.%Close()
	q id
}

ClassMethod DeleteReport(Rowid, ReturnRes, userName)
{
	n (Rowid, ReturnRes,userName)
	set:Rowid'="" obj=##class(DHCMed.CR.Report).%OpenId(+Rowid)
	s st=obj.RepStatus
	q:st="Y" -1000
	set obj.RepStatus="S"
	set obj.ReturnRes=ReturnRes
    set rt=obj.%Save()
	If ($$$ISERR(rt)) {
		w !,"Error="_rt
		s id="-1"_rt
	}
	else
	{
		s id=obj.%Id()
		s sbChild=##class(DHCMed.CR.RepStatus).Update(id_"^^S^"_userName_"^^^")
		if +sbChild<0 s id="-1"_id
		}
	d obj.%Close()
	q id
}

}
