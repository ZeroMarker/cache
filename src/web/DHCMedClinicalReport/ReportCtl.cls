Import SQLUser

/// Creator:	 cjb
/// Description: 基于电子病历的临床报告公共函数
/// Updater:     
/// UpdateDate： 2010-03-08
Class web.DHCMedClinicalReport.ReportCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

ClassMethod QryRepByPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryRepByPatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryRepByPatExecute(ByRef qHandle As %Binary, PrjRowid, TemplateID) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s Rowid=0
	s s="1^2010-02-23^待审"
    d BuildData
    s s="2^2010-02-23^待审"
    d BuildData
    s s="3^2010-02-21^已审"
    d BuildData
	Quit $$$OK
BuildData
	//set Data=$lb(id,code,desc,InsDesc,ICD9CM_Code)
	set Data=$lb("")
 	f iBuild=1:1:3 d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QryRepByPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryRepByPatExecute ]
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

/// 根据别名查询HIS诊断字典
/// d ##Class(%ResultSet).RunQuery("web.DHCMedInjuryRep","QryInjDiagByAlias","11")
Query QryRepByPat(PrjRowid, TemplateID) As %Query(ROWSPEC = "Rowid:%String,RepDate:%String,RepStatus:%String")
{
}

ClassMethod QueryReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryReportExecute(ByRef qHandle As %Binary, DateFrom As %String, DateTo As %String, CtLoc As %String, Status As %String, PrjIDVal As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)

    //s:DateFrom'="" DateFrom=$zd($zdh(DateFrom,4),3)
    //s:DateTo'="" DateTo=$zd($zdh(DateTo,4),3)
    
    s:DateFrom["/" DateFrom=$zdh(DateFrom,4)
    s:DateTo["/" DateTo=$zdh(DateTo,4)
    s:DateFrom["-" DateFrom=$zdh(DateFrom,3)
    s:DateTo["-" DateTo=$zdh(DateTo,3)
    
	s:DateFrom'="" DateFrom=$zd(DateFrom,3)
	s:DateTo'="" DateTo=$zd(DateTo,3)
	q:(DateFrom="")!(DateTo="") $$$OK
	s Ret=..QueryA(DateFrom, DateTo, CtLoc, Status,PrjIDVal)
	q:+Ret<0 $$$OK
	s iCount=+Ret
	s JIndex=$p(Ret,"^",2)
	f IndexApp=0:1:iCount d
	.s s=..GetDataByIndex(JIndex,IndexApp)
	.s:$p(s,"^",5)="D" $p(s,"^",5)="待审"
	.s:$p(s,"^",5)="Y" $p(s,"^",5)="已审"
	.s:$p(s,"^",5)="R" $p(s,"^",5)="退回"
	.//=$p(rs.GetDataByName("ReportDate"),"-")_$tr($justify(rs.GetDataByName("Rowid"),4)," ",0)
	.//s $p(s,"^",2)=$p($p(s,"^",16),"-")_$tr($justify($p(s,"^",1),4)," ",0)
	.s admInfStr=##class(web.DHCMedClinicalReport.CommonFun).GetBaseAdmInfo($p(s,"^",4))
	.//s RegNo=$p(admInfStr,"^",3)
	.s Papmi=$p(admInfStr,"^",6)
	.s RegNo=$p(^PAPER(Papmi,"PAT",1),"^",1)
	.s PatName=$p(admInfStr,"^",15)
	.s PrjInfoStr=##class(User.DHCMedClinicalReport.Project).GetById($p(s,"^",3))
	.s CatID=$p(PrjInfoStr,"^",6)     //备注字段
	.s docPrintID=$p(PrjInfoStr,"^",4)
	.s RepNo=$p($p(s,"^",7),"-")_$tr($justify($p(s,"^",1),4)," ",0)   //报告编号
	.s s=s_"^"_RegNo_"^"_Papmi_"^"_PatName_"^"_CatID_"^"_docPrintID_"^"_RepNo
	.d BuildDataRep
	.s ind=ind+1
    
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildDataRep
	set Data=$lb("") 	
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     cjb
/// CreatDate：   2009-06-15
/// Description:  根据综合条件查询临床报告
/// Table：       表
/// Input：       时间段，报告科室 报告状态
/// Output：      模糊查询出的临床报告集
/// Return：      
/// Others： 
Query QueryReport(DateFrom As %String, DateTo As %String, CtLoc As %String, Status As %String, PrjIDVal As %String) As %Query(ROWSPEC = "Rowid:%String,InstanceID:%String,ProjectID:%String,EpisodeID:%String,RepStatus:%String,RepDoc:%String,RepDate:%String,RepTime:%String,CheckUser:%String,CheckDate:%String,CheckTime:%String,ReturnRes:%String,Text1:%String,Text2:%String,Resume:%String,RepCtloc:%String,RegNo:%String,Papmi:%String,PatName:%String,CatID:%String,docPrintID:%String,RepNo:%String")
{
}

/// 名称: QueryA
/// 描述: 取一段时间 CtLoc报告科室 cStatus报告状态
/// 
/// 查询：获得符合条件临床报告
/// 编写者：cjb 
/// 编写日期: 2010-02-24 
ClassMethod QueryA(DateFrom, DateTo, CtLoc, cStatus, PrjIDVal)
{
  n (DateFrom, DateTo, CtLoc, cStatus,PrjIDVal) 
  s i=0
  k PLIST,MLIST
  k ^CacheTemp($zn,$j)
  q:(DateTo="")!(DateFrom="") -1
  s DateFrom=$zdh(DateFrom,3)
  s DateTo=$zdh(DateTo,3)
  s cDate=DateFrom-1
  q:DateTo<DateFrom -100
    
  i CtLoc'=""  d GetByLoc // 某科报告的临床报告
  i CtLoc="" d GetAll     // 所有室报告的临床报告
  
  q i-1_"^"_$j  
 
  ///名称: GetByLoc
  ///描述: 查询某科室报告的临床报告
  ///查询：获得符合条件的临床报告
  ///编写者：cjb 
  ///编写日期: 2010-02-24  
  ///^DHCMClin.ReportI("DateLoc",61780," 1094",1)=^DHCMClin.ReportD
GetByLoc
  s CtLoc=" "_CtLoc
  f  s cDate=$o(^DHCMClin.ReportI("DateLoc",cDate)) q:(cDate="")!(cDate>DateTo)  d
  .q:'$d(^DHCMClin.ReportI("DateLoc",cDate,CtLoc)) 
  .s Rowid=""
  .f  s Rowid=$o(^DHCMClin.ReportI("DateLoc",cDate,CtLoc,Rowid)) q:Rowid=""  d
  ..s s=$g(^DHCMClin.ReportD(Rowid))   //Rowid
  ..s Status=$li(s,5)
  ..q:PrjIDVal'=$li(s,3)
  ..q:(cStatus'[Status)
  ..s ^CacheTemp("DHCMedCL",$j,i)=Rowid
  ..s i=i+1
  q
 
  ///名称: GetAll
  ///描述: 查询所有科室报告的临床报告
  ///查询：获得符合条件的临床报告
  ///编写者：cjb 
  ///编写日期: 2010-02-24     
GetAll
  f  s cDate=$o(^DHCMClin.ReportI("DateLoc",cDate)) q:(cDate="")!(cDate>DateTo)  d
  .s CtLoc=""  f  s CtLoc=$o(^DHCMClin.ReportI("DateLoc",cDate,CtLoc)) q:CtLoc=""  d
  ..s Rowid=""
  ..f  s Rowid=$o(^DHCMClin.ReportI("DateLoc",cDate,CtLoc,Rowid)) q:Rowid=""  d
  ...s s=$g(^DHCMClin.ReportD(Rowid))
  ...s Status=$li(s,5)
  ...q:PrjIDVal'=$li(s,3)
  ...q:(cStatus'[Status)
  ...s ^CacheTemp("DHCMedCL",$j,i)=Rowid
  ...s i=i+1
  q
}

ClassMethod TestFun()
{
	//d ##class(%ResultSet).RunQuery("web.DHCMedClinicalReport.ReportCtl","QueryReport","2010-02-24","2010-02-24","1094","D")

	d ##class(%ResultSet).RunQuery("web.DHCMedClinicalReport.ReportCtl","QueryReport","2010-02-21","2010-02-24","","D")
}

/// 名称: GetDataByIndex
/// 描述: 根据进程号，取某条临时Global的临床报告rowid
/// 查询：获得符合条件的临床报告
/// 编写者：cjb 
/// 编写日期: 2010-02-24
ClassMethod GetDataByIndex(JIndex, CIndex)
{
     n (JIndex,CIndex)
     q:'$d(^CacheTemp("DHCMedCL",JIndex,CIndex)) ""
     s Rowid=$g(^CacheTemp("DHCMedCL",JIndex,CIndex))
     q:+Rowid=0 ""
     s tempIndex=$o(^CacheTemp("DHCMedCL",JIndex,""),-1)     
     i $g(^CacheTemp("DHCMedCL",JIndex,tempIndex))=Rowid k ^CacheTemp("DHCMedCL",JIndex)
     s s=##Class(User.DHCMedClinicalReport.Report).GetById(Rowid)
     q s
}

ClassMethod CheckReport(Rowid, chkUser)
{
	n (Rowid, chkUser)
	set:Rowid'="" obj=##class(User.DHCMedClinicalReport.Report).%OpenId(+Rowid)
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
		s sbChild=##class(User.DHCMedClinicalReport.RepStatus).Update(id_"^^Y^"_chkUser_"^^^")
		if +sbChild<0 s id="-1"_id
		}
	d obj.%Close()
	q id
}

ClassMethod ReturnReport(Rowid, ReturnRes, userName)
{
	n (Rowid, ReturnRes,userName)
	set:Rowid'="" obj=##class(User.DHCMedClinicalReport.Report).%OpenId(+Rowid)
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
		s sbChild=##class(User.DHCMedClinicalReport.RepStatus).Update(id_"^^R^"_userName_"^^^")
		if +sbChild<0 s id="-1"_id
		}
	d obj.%Close()
	q id
}

ClassMethod InitRepData(PrjID, stDate, endDate, ctLocId)
{
	 n (PrjID, stDate, endDate, ctLocId)
	 s ret=1
	 Set $ZT="ERROR"		       //定义错误处理函数
	 TSTART     		           //开始一个事务
	 q:PrjID="" -ret 
	 //s PrjID=1
	 s prtDocId=$p(##class(User.DHCMedClinicalReport.Project).GetById(PrjID),"^",4)
	 s stDate = $zdh(stDate,3)
	 s endDate = $zdh(endDate,3)
	 Set rset = ##class(%ResultSet).%New("EPRservice.interface.InstanceDataInfo:GetMultiListByDate")
	 Set columns = rset.GetColumnCount()
	 Set sc = rset.Execute(prtDocId,stDate,endDate,ctLocId)
	 // Now fetch the results
	 While (rset.Next()) {
	 //Write "------------------------",!
	 //rset.Data("NeedPrint")
	 //ROWSPEC = "InstanceDataID:%String, EpisodeID:%String, CreateDate:%String,
	 // CreateTime:%String, CreateUserID:%String, CreateCtLocID:%String,
	 // HappenDate:%String, HappenTime:%String, Status:%String"
	 s InstanceID=rset.Data("InstanceDataID")
	 s InstanceID=$tr(InstanceID," ")
	 s EpisodeID=rset.Data("EpisodeID")
	 s CreateDate=rset.Data("CreateDate")
	 s CreateTime=rset.Data("CreateTime")
	 s CreateUserID=rset.Data("CreateUserID")
	 s ModiDate=rset.Data("ModifyDate")
	 s ModiTime=rset.Data("ModifyTime")
	 //ModifyDate:%String, ModifyTime
	 s userInfo=##class(web.DHCMedClinicalReport.CommonFun).GetLogUserInfo(CreateUserID)
	 //b //ee
	 s CreateCtLocID=rset.Data("CreateCtLocID")
	 s:CreateCtLocID="" CreateCtLocID=0   //0 代替为空的数据
	 s InstanceIDI=" "_InstanceID       
	 //同步数据时现只判断了，而项目id存在否不管实例id存在就同步
	 i '$d(^DHCMClin.ReportI("InstanceID",InstanceIDI)) d
	 .s inputString="^"_InstanceID_"^"_PrjID_"^"_EpisodeID_"^D^"_$p(userInfo,"^",3)_"^"_CreateDate_"^"_CreateTime_"^^^^^^^^"_CreateCtLocID
	 .//w inputString,!
	 .s retRowid=##class(User.DHCMedClinicalReport.Report).Update(inputString)
	 .If retRowid<0 TROLLBACK
	 .s sbChild=##class(User.DHCMedClinicalReport.RepStatus).Update(retRowid_"^^D^"_$p(userInfo,"^",3)_"^"_CreateDate_"^"_CreateTime_"^")
	 .if +sbChild<0 TROLLBACK
	 e  d
	 .//如果是退回状态的报告处理
	 .s Rowid=$o(^DHCMClin.ReportI("InstanceID",InstanceIDI,0))
	 .s retModiStatus=..ModifyStatus(Rowid,"D","",ModiDate,ModiTime)
	 }
	 Do rset.Close()
	 TCOMMIT
	 q ret
ERROR	; 
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit ret     //返回错误消息 ;
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
	s ds = ##class(%Library.ResultSet).%New("web.DHCMedClinicalReport.ReportCtl.QueryReport")
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

ClassMethod ModifyStatus(Rowid, Status, UserName, ModiDate, ModiTime)
{
	n (Rowid,Status,UserName,ModiDate,ModiTime)
	q:Rowid="" -1
	set:Rowid'="" obj=##class(User.DHCMedClinicalReport.Report).%OpenId(+Rowid)
	q:obj.RepStatus'="R" -2
	s childSub=$o(^DHCMClin.RepStatusD(Rowid,""),-1)
	q:+childSub=0 -3
	set objSB=##class(User.DHCMedClinicalReport.RepStatus).%OpenId(Rowid_"||"_childSub)
	q:(ModiDate<objSB.UpdateDate) -10
	q:((ModiTime-objSB.UpdateTime)<60) -11    //时间误差控制在1分钟内
	set obj.RepStatus=Status
	s:UserName="" UserName=obj.RepDoc
    set rt=obj.%Save()
	If ($$$ISERR(rt)) {
		w !,"Error="_rt
		s id="-1"_rt
	}
	else
	{
		s id=obj.%Id()
		s sbChild=##class(User.DHCMedClinicalReport.RepStatus).Update(id_"^^"_Status_"^"_UserName_"^"_ModiDate_"^"_ModiTime_"^")
		if +sbChild<0 s id="-1"_id
		}
	d obj.%Close()
	q id
}

}
