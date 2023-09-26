/// 类名: DtPortal.ND.ND01.ND0103DischgPat
/// Creator： 程鹏
/// CreatDate： 2018-12-12
/// Description: 查询护理部重点关注出院患者列表
Class DtPortal.ND.ND01.ND0103DischgPat Extends %RegisteredObject
{

/// Creator： 程鹏
/// CreatDate： 2018-12-13
/// Description: 查询全院各病区某天出院人数
/// Input：  Date      
/// Return： 
/// 服务编码：ND01.03.01
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND01.ND0103DischgPat","ND010301","2018-12-13","2019-12-13")
Query ND010301(startDate As %String, endDate As %String) As DtPortal.Query(ROWSPEC = "name:%String,y:%String,WardId:%String")
{
}

ClassMethod ND010301Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	if (startDate="")||(endDate="") q $$$OK ///日期不能为空
	
	set:startDate["-" startDateNum=$zdh(startDate,3)
	set:endDate["-" endDateNum=$zdh(endDate,3)
	for i=startDateNum:1:endDateNum{
		set PAAdm=""
		for
		{
			set PAAdm=$o(^PAADMi("DischDate",i,PAAdm))
			quit:PAAdm=""
			
			set PatWardId=$p(^PAADM(PAAdm),"^",70)
			continue:PatWardId=""
			
			set ^||TMPPortalND010301(PatWardId)=+$g(^||TMPPortalND010301(PatWardId))+1
		}
		
	}
	
	
	set Ward=""	
	for
	{
		set Ward=$o(^||TMPPortalND010301(Ward))
		quit:Ward=""
		
		set WardNum1=$g(^||TMPPortalND010301(Ward))
		set WardDesc=$p(^PAWARD(Ward),"^",2)
    	set:WardDesc["-" WardDesc=$p(WardDesc,"-",2)
    	
    	set Data=$lb(WardDesc,WardNum1,Ward)
 		set ^||CacheTemp(repid,ind)=Data	
 		set ind=ind+1
	}

  	q $$$OK
}

/// Creator： 程鹏
/// CreatDate： 2018-12-13
/// Description: 查询某病区出院人数详情
/// Input：  WardId      病区ID
/// 		 Date      日期 格式 2018-11-12    
/// Return： 
/// 服务编码：ND01.03.02
/// d ##class(%ResultSet).RunQuery("DtPortal.ND.ND01.ND0103DischgPat","ND010302",1,"2018-12-13","2019-12-13")
Query ND010302(WardId As %String, startDate As %String, endDate As %String) As DtPortal.Query(ROWSPEC = "BedCode,Name,Sex,Age,MedicareNo,AdmReason,Diag,Disdiag,EstimDischaDate,BillDateTime,InTime")
{
}

ClassMethod ND010302Execute(ByRef qHandle As %Binary, WardId As %String, startDate As %String, endDate As %String) As %Status
{
	Set repid=$I(^||CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	
	if (startDate="")||(endDate="") q $$$OK ///日期不能为空
	
	set:startDate["-" startDateNum=$zdh(startDate,3)
	set:endDate["-" endDateNum=$zdh(endDate,3)
	
	for i=startDateNum:1:endDateNum{
		
		set PAAdm=""
		for
		{
			set PAAdm=$o(^PAADMi("DischDate",i,PAAdm))
			quit:PAAdm=""
			
			set PatWardId=$p(^PAADM(PAAdm),"^",70)
			continue:PatWardId'=WardId
			
			set patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
	 		set BedCode=$p(patInfoStr,"^",1)
	 		set Name=$p(patInfoStr,"^",2)
	 		set Sex=$p(patInfoStr,"^",3)
	 		set Age=$p(patInfoStr,"^",4)
	 		set MedicareNo=$p(patInfoStr,"^",5)   //病案号
	 		set AdmReason=$p(patInfoStr,"^",6)    //费用类型
	 		set Diag=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(PAAdm)  //取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
		 
		 	//出院诊断---取统一接口
			set Disdiag=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(PAAdm)
			
			//调用统一取入院时间的接口
			set inDateTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(PAAdm)
			set InDate=$p(inDateTimeStr,"^",1)
			set InTime=$p(inDateTimeStr,"^",2)
			i InDate'="" s InDate=$zd(InDate,3)
			i InTime'="" s InTime=$zt(InTime,2)
			s InTime=InDate_"&nbsp;"_InTime   //加空格，用于前台显示
			
			//调用统一取出院时间的接口
			set DischaDateStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(PAAdm)
			set DisDate=$p(DischaDateStr,"^",1)
			set DisTime=$p(DischaDateStr,"^",2)
			i DisDate'="" s DisDate=$zd(DisDate,3)
			i DisTime'="" s DisTime=$zt(DisTime,2)
			s EstimDischaDate=DisDate_"&nbsp;"_DisTime   //加空格，用于前台显示
			
			//取财务结算时间
			s BillDateTime=..GetBillDateByAdm(PAAdm)
		 	s Data=$lb(BedCode,Name,Sex,Age,MedicareNo,AdmReason,Diag,Disdiag,EstimDischaDate,BillDateTime,InTime)
	 		s ^||CacheTemp(repid,ind)=Data	
	 		s ind=ind+1
			
		}
	}
	
	

  	q $$$OK
}

/// 根据Adm输出财务结算日期，时间
ClassMethod GetBillDateByAdm(Adm)
{
	
	q:Adm="" "^"
	s PrtDate="",PrtTime=""
	s BillFlag=$p(^PAADM(Adm),"^",45)
	i BillFlag="Y" d
	.s PrtRowID=$o(^DHCINVPRTZY(0,"ADM",Adm,""),-1)
	.i PrtRowID'="" d
	..s PrtDate=$p(^DHCINVPRTZY(PrtRowID),"^",2)
	..s PrtTime=$p(^DHCINVPRTZY(PrtRowID),"^",3)
	..s PrtDate=$zd(PrtDate,3)
	..s PrtTime=$zt(PrtTime,2)
	;q PrtDate_"^"_PrtTime
	i PrtDate'="" s ret=PrtDate_"&nbsp;"_PrtTime
	e  s ret=""
	q ret
}

}
