/// 名称: DHCMed.NINFService.Aim.EPRReprotSrv
/// 描述: EPR临床上报报告信息查询
/// 编写者：lyh
/// 编写日期: 2012-04-24
Class DHCMed.NINFService.Aim.EPRReprotSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod QryProjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryProjectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryProjectExecute(ByRef qHandle As %Binary, PrjCodes As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s Rowid=0
	f  s Rowid=$o(^DHCMed.CR.ProjectD(Rowid)) q:Rowid=""  d
	.s obj=##class(DHCMed.CR.Project).%OpenId(Rowid)
	.q:'$IsObject(obj)
	.s Active=obj.Active
	.q:Active'="Y"
	.s Code=obj.Code
	.s flag=0
	.f i=1:1:$l(PrjCodes,"|") d
	..s PrjCode=$p(PrjCodes,"|",i)
	..s:PrjCode=Code flag=1
	.q:flag=0
	.s s=##class(DHCMed.CR.Project).GetById(Rowid)
    .d Builddata
	Quit $$$OK
Builddata
	//s data=$lb(id,code,desc,InsDesc,ICD9CM_Code)
	s data=$lb("")
 	f iBuild=1:1:6 d
 	.q:$p(s,"^",5)'="Y"
 	.s $li(data,iBuild)=$p(s,"^",iBuild)
 	s ^CacheTemp(repid,ind)=data
 	s ind=ind+1
 	q
}

ClassMethod QryProjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryProjectExecute ]
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

/// d ##Class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.EPRReprotSrv","QryProject","1|2")
Query QryProject(PrjCodes As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Description:%String,TemplateID:%String,Active:%String,Resume:%String")
{
}

/// Creator：     lyh
/// CreatDate：   2012-4-24
/// Description:  根据综合条件查询临床报告
/// Table：       DHCMed.CR.Report
/// Input：       argDateFrom 开始时间
///               argDateTo   结束时间
///               argLocID    科室
///               argStatus   状态
///               argPrjID 临床上报项目IDs
/// Return：      $lb(临床上报相关信息)
/// d ##Class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.EPRReprotSrv","QueryCRReport","2010-04-21","2012-08-27","","/1/2","*D*Y*")
Query QueryCRReport(argDateFrom As %String, argDateTo As %String, argLocID As %String, argRepType As %String, argStatus As %String, argWardID As %String) As %Query(ROWSPEC = "ReportID:%String,InstanceID:%String,ProjectID:%String,EpisodeID:%String,ReportNo:%String,ReportStatus:%String,RepLocDesc:%String,RepUser:%String,RepDate:%String,RepTime:%String,CheckUser:%String,CheckDate:%String,CheckTime:%String,ReturnRes:%String,Text1:%String,Text2:%String,Resume:%String,PatientID:%String,RegNo:%String,PatName:%String,PatSex:%String,PatAge:%String,ProjectDesc:%String,TemplateCatID:%String,PrtTemplateID:%String")
{
}

ClassMethod QueryCRReportExecute(ByRef qHandle As %Binary, argDateFrom As %String, argDateTo As %String, argLocID As %String, argRepType As %String, argStatus As %String, argWardID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)

	//同步电子病历与临床上报数据
	Set flg=##class(DHCMed.CRService.Interface).SyncDataEPRToCR("")
	Quit:flg<0 $$$OK
	
    Set:argDateFrom["/" argDateFrom=$zdh(argDateFrom,4)
    Set:argDateTo["/" argDateTo=$zdh(argDateTo,4)
    Set:argDateFrom["-" argDateFrom=$zdh(argDateFrom,3)
    Set:argDateTo["-" argDateTo=$zdh(argDateTo,3)
    Set:argDateFrom'="" argDateFrom=+argDateFrom
    Set:argDateTo'="" argDateTo=+argDateTo
    Quit:(argDateFrom="")||(argDateTo="") $$$OK
    Quit:argDateFrom>argDateTo $$$OK
    
    Quit:argRepType="" $$$OK
    
    For i=1:1:$l(argRepType,"/")-1  Do
    .Set argPrjID=$p(argRepType,"/",i+1)
    .Quit:argPrjID=""
    .Set ProjectInfo=##Class(DHCMed.CR.Project).GetById(argPrjID)
	.Set ProjectDesc=$p(ProjectInfo,"^",3)
	.Set TemplateCatID=$p(ProjectInfo,"^",6)     //界面模板ID
	.Set PrtTemplateID=$p(ProjectInfo,"^",4)     //打印模板ID
	.Set xRepDate=argDateFrom-1 
	.For  Set xRepDate=$o(^DHCMed.CR.ReportI("DateLoc",xRepDate)) Quit:(xRepDate="")||(xRepDate>argDateTo)  Do
	..Set xRepLoc=""
	..For  Set xRepLoc=$o(^DHCMed.CR.ReportI("DateLoc",xRepDate,xRepLoc)) Quit:xRepLoc=""  Do
	...Set xReportID=0
	...For  Set xReportID=$o(^DHCMed.CR.ReportI("DateLoc",xRepDate,xRepLoc,xReportID)) Quit:xReportID=""  Do
	....Set ReportStatus=##Class(DHCMed.CRService.Interface).GetStatusByRepID(xReportID)
	....Set ReportStr=##Class(DHCMed.CR.Report).GetById(xReportID)
	....Set ReportID=$p(ReportStr,"^",1)
	....Set InstanceID=$p(ReportStr,"^",2)
	....Set ProjectID=$p(ReportStr,"^",3)
	....Quit:ProjectID'=argPrjID
	....Set EpisodeID=$p(ReportStr,"^",4)
	....Set ReportStatus=$p(ReportStr,"^",5)
	....Quit:(argStatus'="")&&(argStatus'[ReportStatus)
	....Set:ReportStatus'="R" $p(ReportStr,"^",12)=""
	....Set ReportStatus=$s(ReportStatus="D":"待审",ReportStatus="Y":"已审",ReportStatus="R":"退回",ReportStatus="S":"删除",1:"")
	....Set RepUser=$p(ReportStr,"^",6)    //报告人
	....If RepUser'="" Do
	.....Set UserInfo=##class(DHCMed.CRService.CommonFun).GetLogUserInfo(+RepUser)
	.....Set RepUser=$p(UserInfo,"^",3)
	....Set RepDate=$p(ReportStr,"^",7)
	....Set ReportNo=$p($p(ReportStr,"^",7),"-")_$tr($justify($p(ReportStr,"^",1),4)," ",0)   //报告编号
	....Set RepTime=$p(ReportStr,"^",8)
	....Set CheckUser=$p(ReportStr,"^",9)  //审核人
	....If CheckUser'="" Do
	.....Set UserInfo=##class(DHCMed.CRService.CommonFun).GetLogUserInfo(+CheckUser)
	.....Set CheckUser=$p(UserInfo,"^",3)
	....Set CheckDate=$p(ReportStr,"^",10)
	....Set CheckTime=$p(ReportStr,"^",11)
	....Set ReturnRes=$p(ReportStr,"^",12)
	....Set Text1=$p(ReportStr,"^",13)
	....Set Text2=$p(ReportStr,"^",14)
	....Set Resume=$p(ReportStr,"^",15)
	....Set RepLocDesc=$p(ReportStr,"^",16)
	....//就诊科室代替报告科室
	....Set AdmLoc=$p($g(^PAADM(+EpisodeID)),"^",4)
	....Set AdmWrd=$p($g(^PAADM(+EpisodeID)),"^",70)
	....Quit:(argLocID'="")&&(argLocID'=AdmLoc)
	....;Quit:(argWardID'="")&&(argWardID'=AdmWard)
	....Set RepLocDesc=$p($g(^CTLOC(+AdmLoc)),"^",2)
	....Set:$p(RepLocDesc,"-",2)'="" RepLocDesc=$p(RepLocDesc,"-",2)
	....Set PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)
	....Set RegNo=$p($g(^PAPER(+PatientID,"PAT",1)),"^",1)
	....Set PatName=$p($g(^PAPER(+PatientID,"ALL")),"^",1)
	....Set PatSex=$p($g(^PAPER(+PatientID,"ALL")),"^",7)
	....If PatSex'="" Do
	.....Set PatSex=$p($g(^CT("SEX",+PatSex)),"^",2)
	....Set PatAge=0
	....Set BirthDay=$p($g(^PAPER(+PatientID,"ALL")),"^",6)
	....If BirthDay'="" Do
	.....Set PatAge= (+$zd(+$h,3))-(+$zd(BirthDay,3))
	.....Set:PatAge<1 PatAge=1
	....Set $li(data,1)=ReportID
	....Set $li(data,2)=InstanceID
	....Set $li(data,3)=ProjectID
	....Set $li(data,4)=EpisodeID
	....Set $li(data,5)=ReportNo
	....Set $li(data,6)=ReportStatus
	....Set $li(data,7)=RepLocDesc
	....Set $li(data,8)=RepUser
	....Set $li(data,9)=RepDate
	....Set $li(data,10)=RepTime
	....Set $li(data,11)=CheckUser
	....Set $li(data,12)=CheckDate
	....Set $li(data,13)=CheckTime
	....Set $li(data,14)=ReturnRes
	....Set $li(data,15)=Text1
	....Set $li(data,16)=Text2
	....Set $li(data,17)=Resume
	....Set $li(data,18)=PatientID
	....Set $li(data,19)=RegNo
	....Set $li(data,20)=PatName
	....Set $li(data,21)=PatSex
	....Set $li(data,22)=PatAge
	....Set $li(data,23)=ProjectDesc
	....Set $li(data,24)=TemplateCatID
	....Set $li(data,25)=PrtTemplateID
	....Set ^CacheTemp(repid,ind)=data
	....Set ind=ind+1
	
    Quit $$$OK
}

ClassMethod QueryCRReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCRReportExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

ClassMethod QueryCRReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCRReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 取电子病历入院诊断 
/// 调用 ##class(%ResultSet).RunQuery("EPRservice.SpecialData","GetAdmDiagnosInfoHX",paadm)
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.EPRReprotSrv","QueryEPRDiag",3012579)
Query QueryEPRDiag(Paadm As %String) As %Query(ROWSPEC = "Diag1:%String,Diag2:%String,Diag3:%String")
{
}

ClassMethod QueryEPRDiagExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:Paadm="" $$$OK
	
	Set Diag=""
	Set rset = ##class(%ResultSet).%New()
	Set rset.ClassName = "EPRservice.SpecialData"
	Set rset.QueryName = "GetAdmDiagnosInfoHX"
	Set sc = rset.Execute(Paadm)
	Quit:rset.Next()="" $$$OK
	Do rset.Next(1)
	
	Set Diag1=rset.Data("AdmDiagnosOne")
	Set Diag2=rset.Data("AdmDiagnosTwo")
	Set Diag3=rset.Data("AdmDiagnosThree")
	
	Set:Diag1["^" Diag1=$p(Diag1,"^",2)
	Set:Diag2["^" Diag2=$p(Diag2,"^",2)
	Set:Diag3["^" Diag3=$p(Diag3,"^",2)
	
	Set $li(data,1)=Diag1
	Set $li(data,2)=Diag2
	Set $li(data,3)=Diag3
	Set ^CacheTemp(repid,ind)=data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QueryEPRDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEPRDiagExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryEPRDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEPRDiagExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// 取电子病历最后一次手术记录单中手术名称 
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.EPRReprotSrv","QueryOpeName",3012579,200)
Query QueryOpeName(EpisodeID As %String, CategoryID As %String = "") As %Query(ROWSPEC = "OpeName:%String")
{
}

ClassMethod QueryOpeNameExecute(ByRef qHandle As %Binary, EpisodeID As %String, CategoryID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:CategoryID="" CategoryID=200
	Quit:(EpisodeID="")||(CategoryID="") $$$OK
	Quit:'$d(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_EpisodeID)) $$$OK
	Quit:'$d(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_EpisodeID," "_CategoryID)) $$$OK
	
	
	Set ECRecordId = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_EpisodeID," "_CategoryID,""))
	;取最后一次报告
 	Set instanceDataId=ECRecordId_"||"_$tr($o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordId,""),-1)," ","")
	
	Quit:instanceDataId="" $$$OK
	
	Set OpeName=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID, "手术名称I0019#TYPE:Simple#TID:396#TVER:0#SCODE:I0019#VTYPE:V" ,instanceDataId)
	
	Set $li(data,1)=OpeName
	Set ^CacheTemp(repid,ind)=data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QueryOpeNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOpeNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOpeNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOpeNameExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// 取电子病历最后一次手术记录单中手术名称、手术日期、术后诊断
/// d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.EPRReprotSrv","QueryOpeDocName",3012579,200)
Query QueryOpeDocName(EpisodeID As %String, CategoryID As %String = "") As %Query(ROWSPEC = "OpeDocName:%String,OpeDate:%String,AfterDiag:%String,OSBItemRst:%String")
{
}

ClassMethod QueryOpeDocNameExecute(ByRef qHandle As %Binary, EpisodeID As %String, CategoryID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set:CategoryID="" CategoryID=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("INFOpeCategoryID","")
	Quit:(EpisodeID="")||(CategoryID="") $$$OK
	Quit:'$d(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_EpisodeID)) $$$OK
	Quit:'$d(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_EpisodeID," "_CategoryID)) $$$OK
	
	
	Set ECRecordId = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDCategoryID"," "_EpisodeID," "_CategoryID,""))
	;取最后一次报告
 	Set instanceDataId=ECRecordId_"||"_$tr($o(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ECRecordId,""),-1)," ","")
	
	Quit:instanceDataId="" $$$OK
	
	Set OpeDocName=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID, "主刀医师签字S0013#TYPE:Simple#TID:396#TVER:0#SCODE:S0013#VTYPE:V" ,instanceDataId)
	Set OpeDate=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID, "手术时间#TYPE:Simple#TID:396#TVER:0#SCODE:D0003#VTYPE:V" ,instanceDataId)
	Set AfterDiag=##class(EPRservice.BOScatterData).GetEPRMultipleData(EpisodeID, "术后诊断#TYPE:TextDesc#TID:396#TVER:0#ECODE:E0009" ,instanceDataId)
	
	Set OpeDate=$tr(OpeDate,"年","-")
	Set OpeDate=$tr(OpeDate,"月","-")
	Set OpeDate=$tr(OpeDate,"日","")
	
	Set:$l($p(OpeDate,"-",2))=1 $p(OpeDate,"-",2)=0_$p(OpeDate,"-",2)
	Set:$l($p(OpeDate,"-",3))=1 $p(OpeDate,"-",3)=0_$p(OpeDate,"-",3)
	
	Set sOpeDate=$zdh(OpeDate,3)
	
	Set MRAdm=##class(DHCMed.CCService.Lib.Common).GetMRAdm(EpisodeID)
	Quit:MRAdm="" return
	
	Set tmpOBSL=36
	Set tmpOBSH=37.7
	Set SubID=0,OSBItemRst=""
    For {
		Set SubID=$o(^MR(MRAdm,"OBS",SubID))
		Quit:SubID=""
		Set ItemDR=$p($g(^MR(MRAdm,"OBS",SubID)),"^",1)
		Continue:'$d(^MRC("OBITM",+ItemDR))
		Set ItemDesc=$p($g(^MRC("OBITM",+ItemDR)),"^",2)
    	Continue:(ItemDesc'="体温")&&(ItemDesc'="腋温")&&(ItemDesc'="口温")&&(ItemDesc'="肛温")
    	Set Value=+$p($g(^MR(MRAdm,"OBS",SubID)),"^",2)
    	Continue:(Value>=tmpOBSL)&&(Value<=tmpOBSH)
    	Set OSBDate=$p($g(^MR(MRAdm,"OBS",SubID)),"^",3)
    	Set OSBTime=$p($g(^MR(MRAdm,"OBS",SubID)),"^",4)
    	Set OSBUser=$p($g(^MR(MRAdm,"OBS",SubID)),"^",5)
    	
    	Continue:(OSBDate-sOpeDate<2)	//术后48小时
    	Set:OSBDate'="" OSBDate=$zd(OSBDate,3)
    	Set:OSBTime'="" OSBTime=$zt(OSBTime,2)
    
    	Set:OSBUser'="" OSBUser=$p($g(^SSU("SSUSR",OSBUser)),"^",2)
    	Set:OSBItemRst'="" OSBItemRst=OSBItemRst_" ; "_Value_"度("_OSBDate_" "_OSBTime_" "_OSBUser_")"
		Set:OSBItemRst="" OSBItemRst=Value_"度("_OSBDate_" "_OSBTime_" "_OSBUser_")"
	}
	
	Set $li(data,1)=OpeDocName
	Set $li(data,2)=OpeDate
	Set $li(data,3)=AfterDiag
	Set $li(data,4)=OSBItemRst
	Set ^CacheTemp(repid,ind)=data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QueryOpeDocNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryOpeDocNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryOpeDocNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryOpeDocNameExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2012-06-14
/// Description:  查询病人抗生素的信息
/// Table：       DHCMed.Base.OrdItem
/// Input：       Paadm ： 就诊
/// output:       符合条件的项            
/// Return：      d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.EPRReprotSrv","QueryArcimByPaadm","3012579")
Query QueryArcimByPaadm(Paadm As %String) As %Query(ROWSPEC = "DrugInfo:%String")
{
}

ClassMethod QueryArcimByPaadmExecute(ByRef qHandle As %Binary, Paadm As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
 	
 	Quit:Paadm="" $$$OK
 	
 	Set ZIndex=$zn,JIndex=$j
 	Kill ^TMP(ZIndex,JIndex,"QryArcimByPaadm")
 	
 	Set OrderID=$o(^OEORD(0,"Adm",Paadm,""))
 	Set ArcimID=""
 	For {
	 	Set ArcimID=$o(^OEORDi(0,"ARCIM",+OrderID,ArcimID),-1)
	 	Quit:ArcimID=""
	 	Set objArcim=##class(DHCMed.Base.Arcim).GetObjById(ArcimID)
	 	Continue:'$IsObject(objArcim)
	 	Set ARCICOrderType=objArcim.ARCICOrderType
	 	Continue:ARCICOrderType'="R"
	 	Set ARCIMPHCDFDR=objArcim.ARCIMPHCDFDR
	 	Set objPhc=##class(DHCMed.Base.PHC).GetObjById(ARCIMPHCDFDR)
	 	//Continue:(DrugFlag'="")&((objPhc.PHCCDesc'["抗感染")&(objPhc.PHCCDesc'["抗生素")&(objPhc.PHCCDesc'["抗微生物"))

		Continue:((objPhc.PHCSCDesc'["抗感染")&(objPhc.PHCSCDesc'["抗生素")&(objPhc.PHCSCDesc'["抗微生物药"))
		Set StartDate=+$h-10	//最近10的抗生素信息
		For {
			Set StartDate=$o(^OEORDi(0,"ARCIM",+OrderID,ArcimID,StartDate))
			Quit:StartDate=""
			Set SubID=0
			For {
				Set SubID=$o(^OEORDi(0,"ARCIM",+OrderID,ArcimID,StartDate,SubID))
				Quit:SubID=""
				
				Set FillerNo=$p($g(^OEORD(OrderID,"I",SubID,9)),"^",12)
				If FillerNo'="" {
					Set OEOrdID=$p(FillerNo,"!!",1)
				}Else{
					Set OEOrdID=OrderID_"||"_SubID
				}
				Continue:OEOrdID=""
				
				Set xDate=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",34)
				Continue:(+xDate)'=0  //停止的医嘱过滤掉
				
				Set ^TMP(ZIndex,JIndex,"QryArcimByPaadm",OEOrdID,SubID)=FillerNo
				//w OEOrdID_"///"_OrderID_"||"_SubID,!
			}
		}
	}
	
	Set OEOrdID="",DrugInfo=""
	For {
		Set OEOrdID=$o(^TMP(ZIndex,JIndex,"QryArcimByPaadm",OEOrdID))
		Quit:OEOrdID=""
		
	    Set DrugsRoute="" ,DrugsRouteCode="",checked="",childSub="",AdmDrugs="" , AdmDrugsCode=""
	    Set InfAdmDrugsGoal="" ,InfAdmDrugsGoalCode="",CureAdmDrugsType="" ,CureAdmDrugsTypeCode=""
	    Set DefendAdmDrugsType="" ,DefendAdmDrugsTypeCode="",IndicationDesc="" ,Indication=""
	    Set Effect="" ,EffectCode="",UnionDrug="" ,UnionDrugCode="",AroundOpeDrugDesc="" ,AroundOpeDrug=""
	    Set BeforeOpeDate="" ,AfterOpeDate="",Rationality="" ,RationalityCode="",Irrationality="" ,IrrationalityCode=""
	    Set CurativeEffect="" ,CurativeEffectCode="",ResumeText=""
	    Set OprBeforInfo="",OprBeforInfoDesc="",OprAfterInfo="",OprAfterInfoDesc="",Text1=""
		
		Set OEOrdStartTime=0,OEOrdEndTime=0
		
		Set FstSubID=0,LstSubID=0,OEOrdStartDate=0,OEOrdEndDate=0,StartDateList=""
		Set SubID=0
		For {
			Set SubID=$o(^TMP(ZIndex,JIndex,"QryArcimByPaadm",OEOrdID,SubID))
			Quit:SubID=""
			
			Set OEORIID=(+OEOrdID)_"||"_SubID
			Set objOEORI=##class(DHCMed.Base.OrdItem).GetObjById(OEORIID)
			Continue:'$IsObject(objOEORI)
			
			Set OEORIDoseQty=objOEORI.OEORIDoseQty  //剂量
			Set CTUOMDesc=objOEORI.CTUOMDesc	//剂量单位
			Set OEORIDoseQty=OEORIDoseQty_" "_CTUOMDesc
			Set OEORIPHFreqDR=objOEORI.OEORIPHFreqDR	//频率
			Set:OEORIPHFreqDR'="" OEORIPHFreqDR=$p($g(^PHCFR(OEORIPHFreqDR)),"^",1)
			
			Set tmpStartDate=objOEORI.OEORISttDat
			Set tmpStartTime=objOEORI.OEORISttTim
			
			Continue:(+tmpStartDate)=0
			
			If (FstSubID=0)||(SubID<FstSubID) {
				Set FstSubID=SubID
			}
			If (LstSubID=0)||(SubID>LstSubID) {
				Set LstSubID=SubID
			}
			Set tmpStartDate=+tmpStartDate
			If (OEOrdStartDate=0)||(tmpStartDate<OEOrdStartDate) {
				Set OEOrdStartDate=tmpStartDate
				Set OEordStartTime=tmpStartTime
			}
			If (OEOrdEndDate=0)||(tmpStartDate>OEOrdEndDate) {
				Set OEOrdEndDate=tmpStartDate
				Set OEOrdEndTime=tmpStartTime
			}
			If $listfind(StartDateList,tmpStartDate)<1 {
				Set StartDateList=StartDateList_$lb(tmpStartDate)
			}
		}

		Set OEOrdStartDate=$zd(+OEOrdStartDate,3)
		
		Set OEOrdEndDate=$zd(+OEOrdEndDate,3)
		Set OEORIDays=$listlength(StartDateList)

		Set OEordStartTime=$zt(+OEordStartTime,2)
		Set OEOrdEndTime=$zt(+OEOrdEndTime,2)
		Set OEOrdStartDate=OEOrdStartDate_" "_OEordStartTime
		Set OEOrdEndDate=OEOrdEndDate_" "_OEOrdEndTime
		
		Set FstOEORIID=(+OEOrdID)_"||"_FstSubID
		Set objOEORI=##class(DHCMed.Base.OrdItem).GetObjById(FstOEORIID)
		Continue:'$IsObject(objOEORI)
		Set OEORIItmMastDR=objOEORI.OEORIItmMastDR
		Set OEORIItmMast=$p($g(^ARCIM(+OEORIItmMastDR,+$p(OEORIItmMastDR,"||",2),1)),"^",2)
		Continue:OEORIItmMast=""
		Set OEORIInstrDR=objOEORI.OEORIInstrDR  //PHC_Instruc  用法
		Set OEORIInstr=$p($g(^PHCIN(+OEORIInstrDR)),"^",2)
		Set:$p(OEORIInstr,"-",2)'="" OEORIInstr=$p(OEORIInstr,"-",2)
		Set DrugsRouteCode=OEORIInstr
		Set AricmSumInfo=objOEORI.OEORIDoseQty_"/"_objOEORI.CTUOMDesc_";"_objOEORI.PHCFRDesc1_";"_objOEORI.PHCDUDesc1_";"_objOEORI.PHCINDesc1
		
		
		Set:DrugInfo'="" DrugInfo=DrugInfo_" 名称："_OEORIItmMast_" 开始日期："_OEOrdStartDate_ " 结束日期："_OEOrdEndDate
		Set:DrugInfo="" DrugInfo="名称："_OEORIItmMast_" 开始日期："_OEOrdStartDate_ " 结束日期："_OEOrdEndDate
	   
	}
	Kill ^TMP(ZIndex,JIndex,"QryArcimByPaadm")
	
    Set Data=$lb("")
	Set $li(Data,1)=DrugInfo //抗菌药物医嘱信息
	    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QueryArcimByPaadmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryArcimByPaadmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryArcimByPaadmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryArcimByPaadmExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// Creator：     liuyh
/// CreatDate：   2012-06-15
/// Description:  通过就诊号查询该患者半年内是否住过院
/// Input：       EpisodeID ： 就诊
/// output:       是/否            
/// Return：      d ##class(%ResultSet).RunQuery("DHCMed.NINFService.Aim.EPRReprotSrv","QuerySixMonthInHosp","3012579") 
Query QuerySixMonthInHosp(EpisodeID As %String) As %Query(ROWSPEC = "SixMonthInHosp:%String")
{
}

ClassMethod QuerySixMonthInHospExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set SixMonthInHosp="否"
	Quit:EpisodeID="" $$$OK
	
	Set Papmi=$p($g(^PAADM(EpisodeID)),"^",1)
	Quit:Papmi="" $$$OK
	
	Quit:'$d(^PAPERdr(Papmi)) $$$OK
	Quit:'$d(^PAPERdr(Papmi,"ADM","I")) $$$OK
	Quit:'$d(^PAPERdr(Papmi,"ADM","I",EpisodeID)) $$$OK
	
	Set LastIEpisodeID=$o(^PAPERdr(Papmi,"ADM","I",EpisodeID),-1)
	Quit:LastIEpisodeID="" $$$OK
	
	//Set CurrAdmDate=$p($g(^PAADM(EpisodeID)),"^",6)
	//Set LastAdmDate=$p($g(^PAADM(LastIEpisodeID)),"^",6)
	//upadte by pylian 2016-02-18 修改入院时间取值方式
    Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(EpisodeID)
	Set CurrAdmDate=$p(AdmDateTime,"^",1)
	Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(LastIEpisodeID)
	Set LastAdmDate=$p(AdmDateTime,"^",1)
	Set:(CurrAdmDate'="")&(LastAdmDate'="")&(CurrAdmDate-LastAdmDate<182) SixMonthInHosp="是"
	
	Set Data=$lb("")
	Set $li(Data,1)=SixMonthInHosp //6个月内是否住院
	    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QuerySixMonthInHospClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySixMonthInHospExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QuerySixMonthInHospFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySixMonthInHospExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

Storage Default
{
<Data name="EPRReprotSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.INFServ5C1.EPRReprotSrvD</DataLocation>
<DefaultData>EPRReprotSrvDefaultData</DefaultData>
<IdLocation>^DHCMed.INFServ5C1.EPRReprotSrvD</IdLocation>
<IndexLocation>^DHCMed.INFServ5C1.EPRReprotSrvI</IndexLocation>
<StreamLocation>^DHCMed.INFServ5C1.EPRReprotSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
