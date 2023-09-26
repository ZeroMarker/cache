Class DtPortal.Doctor.D01PatList.D0101AtHostPat Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： 	程鹏
/// CreatDate： 2014-7-9
/// Description: 查询在院患者列表
/// Input：		QueryType : 查询单位(P:本人  PG 本主诊组  loc:科室 ward:病区); 
/// 			QureyID :   本人,主诊组为空,科室,病区为为CT_LOC表id 
/// 		   	StartDate：查询开始日期;
/// 		  	EndDate：查询结束日期
///             UserCode：用户code
///             NurseLevelType：医嘱配置code
/// Return： 	BedNo：床号
/// 			AdmNo：就诊号
/// 			PAPMINo：登记号   
/// 			MedicareNo：病案号
/// 			Name：姓名 
/// 			InTime：入科时间（分床时间） 
/// 			InDay：入院天数
/// 			InNum：入院次数
/// 			Sex：性别
/// 			Age：年龄
/// 			ManagerDoc：主管医师
/// 			ChargeDoc：主治医师
/// 			DirDoc：主任医师
/// 			DiagnoseDesc：诊断
/// 			AdmReason：费用类型
/// 			Ward: 病区  
/// 			EpisodeID：就诊ID   
/// 服务号:		D01.01.01
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0101AtHostPat","D010101InPat","P","","4829","NURSELEVEL")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0101AtHostPat","D010101InPat","PG","","4829","NURSELEVEL")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0101AtHostPat","D010101InPat","loc","104","4829","NURSELEVEL")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0101AtHostPat","D010101InPat","ward","193","4829","NURSELEVEL")
Query D010101InPat(QueryType As %String, QureyID As %String, UserCode As %String, NurseLevelType As %String = "") As DtPortal.Query(ROWSPEC = "ind,BedNo,AdmNo,PAPMINo,MedicareNo,Name,InDate,InTime,InDay,InNum,Sex,Age,ManagerDoc,ChargeDoc,DirDoc,DiagnoseDesc,AdmReason,Ward,PatientID,DocCode,patCurrDept,PathWay,DeptDesc,ArrearageFlag,TotalCost,Balance,NurseLevelDesc,EMRDocID,EMRInstanceID,locID,EpisodeID,UserId,ifNewIn") [ SqlProc ]
{
}

ClassMethod D010101InPatExecute(ByRef qHandle As %Binary, QueryType As %String, QureyID As %String, UserCode As %String, NurseLevelType As %String) As %Status
{
	
	new (qHandle,QueryType,QureyID,UserCode,NurseLevelType)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	quit:((QueryType'["P")&&(QureyID="")) $$$OK
	//获得查询范围
	set rangeType=1,UserId=""
	s UserId=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	if QueryType="ward"
	{
		set wardID=$o(^PAWARD(0,"WARD_LocationDR",QureyID,""))
		set QureyID=wardID
		
	}
	
	//根据配置医嘱code取医嘱ID
	set ArcIDs=##Class(DtPortal.Configure.arcim).getArcImID(NurseLevelType,1)	//获取code

	set admPatList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(QueryType,UserId,QureyID)
	
	quit:admPatList="" $$$OK
	for admIndex=1:1:$L(admPatList,"^")
	{
		set admId=$p(admPatList,"^",admIndex)
		Set AdmWardID=$p($g(^PAADM(admId)),"^",70)    //病区
		s wardDesc=$p(^PAWARD(AdmWardID),"^",2)
		i wardDesc["-" s wardDesc=$p(wardDesc,"-",2)
		s PatientID=$P($g(^PAADM(admId)),"^",1)
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(admId)
		s BedNo=$p(patInfoStr,"^",1)
		s MedicareNo=$p(patInfoStr,"^",5)
		s Name=$p(patInfoStr,"^",2)
		s Sex=$p(patInfoStr,"^",3)
		s Age=$p(patInfoStr,"^",4)
		s AdmReason=$p(patInfoStr,"^",6)
		
		s AdmNo=$p(^PAADM(admId),"^",81)
		s PAPMINo=$p(patInfoStr,"^",7)

		;判断护理级别 Start DanPj 2015-11-24
		set NurseLevel=""
		//判断是否有护理级别医嘱,有则返回医嘱描述
		set isNur=##class(DtPortal.Common.PaadmService).IsHaveArc(admId,ArcIDs)
		continue:((NurseLevelType'="NURSELEVEL")&&(isNur=""))
		set NurseLevelDesc=isNur
		
		set ArrearageFlag=1,TotalCost=0,Balance=0
		//判断是否欠费
		set IsArrearsStr= ##class(DtPortal.Common.PaadmService).IsArrears(admId)
		
		set ArrearageFlag=$p(IsArrearsStr,"^",1)
		set TotalCost=$p(IsArrearsStr,"^",2)
		set Balance=$p(IsArrearsStr,"^",3)
		
		//调用统一取入院时间的接口
		s inDateTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(admId)
		s InDate=$p(inDateTimeStr,"^",1)
		s InTime=$p(inDateTimeStr,"^",2)
		i InDate'="" s InDate=$zd(InDate,3)
		i InTime'="" s InTime=$zt(InTime,2)
		s InTime=InDate_"&nbsp;"_InTime   //加空格，用于前台显示
		
		s PAAdmDate=$ZD($P($g(^PAADM(admId)),"^",6),3)
		
		s InDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(admId)  //bmz20170810 在院患者在院天数取公共方法
		
		s outDateTimeStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(admId)
		s outDate=$p(outDateTimeStr,"^",1)   //出院日期
		//continue:+outDate'=0
		
		//是否新入院  1-新入院    2-非新入院
		s ifNewIn="2"
		
		if ((InDay=1)&&(+outDate="0")){
			s ifNewIn="1"
		}
		
		s InNum=$P($g(^PAADM(admId)),"^",29)
		s ManagerDoc=""
		s UserDr=""
		s DocDr=$P($g(^PAADM(admId)),"^",9)
		s:DocDr'="" UserDr=$o(^SSU("SSUSR",0,"CTPCP",DocDr,0))
		
		
		set ManagerDoc=""
		//获取主管医生
		s:DocDr'="" ManagerDoc=$p($g(^CTPCP(DocDr,1)),"^",2)
		//取诊断---先取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
		s DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(admId)

		;取病人当前科室 ---bmz
		s LocID=$p(^PAADM(admId),"^",4)
		//w !,LocID
		//w !,^CTLOC(LocID)
		//continue:LocID'=113
		s DeptDesc=$p(^CTLOC(LocID),"^",2)
		i DeptDesc["-" s DeptDesc=$p(DeptDesc,"-",2)
		s Ward=wardDesc
		//临床路径
		s PathWay=##class(DtPortal.Doctor.D01PatList.D0106CpWayPat).IsInPathWay(admId)
		set PathWay=$p(PathWay,"^",1)
		//获取打开电子病历所需要的参数
		set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(admId)
		set EMRDocID=$p(EMRinfo,"^",1)
		set EMRInstanceID=$p(EMRinfo,"^",2)
		set locID=$p(EMRinfo,"^",3)
		set PatientID=$p(EMRinfo,"^",4)
		set EpisodeID=$p(EMRinfo,"^",5)
	
		Set ^||CacheTemp(repid,ind)=$lb(ind,BedNo,AdmNo,PAPMINo,MedicareNo,Name,InDate,InTime,InDay,InNum,Sex,Age,ManagerDoc,ChargeDoc,DirDoc,DiagnoseDesc,AdmReason,Ward,PatientID,DocCode,patCurrDept,PathWay,DeptDesc,ArrearageFlag,TotalCost,Balance,NurseLevelDesc,EMRDocID,EMRInstanceID,locID,EpisodeID,UserId,ifNewIn)
		Set ind=ind+1

	}
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0101AtHostPat","D010102","P","ys01")
Query D010102(id As %String, userCode As %String) As DtPortal.Query(ROWSPEC = "ind,BedNo,AdmNo,PAPMINo,MedicareNo,Name,InDate,InTime,InDay,InNum,Sex,Age,ManagerDoc,ChargeDoc,DirDoc,DiagnoseDesc,AdmReason,Ward,PatientID,DocCode,patCurrDept,PathWay,DeptDesc,ArrearageFlag,TotalCost,Balance,NurseLevelDesc,EMRDocID,EMRInstanceID,locID,EpisodeID,UserId,ifNewIn") [ SqlProc ]
{
}

ClassMethod D010102Execute(ByRef qHandle As %Binary, id As %String, userCode As %String) As %Status
{
	new (qHandle,id,userCode)

	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s UserId=##class(DtPortal.Common.PublicService).GetUserID(userCode)
	quit:UserId="" $$$OK
	
	s admPatList=""
	
	if ((id="P")||(id="PG")){
		set admPatList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(id,UserId,"")
	}else{
		set admPatList=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("loc","",id)
	}
	
	//按床号正序排序
	set admPatList=##Class(DtPortal.Common.PaadmService).GetSortAdmIdStr(admPatList,"1","0")
	
	
	//根据配置医嘱code取医嘱ID
	set ArcIDs=##Class(DtPortal.Configure.arcim).getArcImID("NURSELEVEL",1)	//获取code
	
	quit:admPatList="" $$$OK
	for admIndex=1:1:$L(admPatList,"^")
	{
		set admId=$p(admPatList,"^",admIndex)
		Set AdmWardID=$p($g(^PAADM(admId)),"^",70)    //病区
		s wardDesc=$p(^PAWARD(AdmWardID),"^",2)
		i wardDesc["-" s wardDesc=$p(wardDesc,"-",2)
		s PatientID=$P($g(^PAADM(admId)),"^",1)
		s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(admId)
		s BedNo=$p(patInfoStr,"^",1)
		s MedicareNo=$p(patInfoStr,"^",5)
		s Name=$p(patInfoStr,"^",2)
		s Sex=$p(patInfoStr,"^",3)
		s Age=$p(patInfoStr,"^",4)
		s AdmReason=$p(patInfoStr,"^",6)
		
		s AdmNo=$p(^PAADM(admId),"^",81)
		s PAPMINo=$p(patInfoStr,"^",7)

		;判断护理级别 Start DanPj 2015-11-24
		set NurseLevel=""
		//判断是否有护理级别医嘱,有则返回医嘱描述
		set isNur=##class(DtPortal.Common.PaadmService).IsHaveArc(admId,ArcIDs)
		set NurseLevelDesc=isNur
		
		set ArrearageFlag=1,TotalCost=0,Balance=0
		//判断是否欠费
		set IsArrearsStr= ##class(DtPortal.Common.PaadmService).IsArrears(admId)
		
		set ArrearageFlag=$p(IsArrearsStr,"^",1)
		set TotalCost=$p(IsArrearsStr,"^",2)
		set Balance=$p(IsArrearsStr,"^",3)
		
		//调用统一取入院时间的接口
		s inDateTimeStr=##class(DtPortal.Common.PaadmService).GetAdminDateTime(admId)
		s InDate=$p(inDateTimeStr,"^",1)
		//是否新入院  1-新入院    其他-非新入院
		s ifNewIn="99"
		if (InDate=+$h){
			s ifNewIn="1"
		}
		s InTime=$p(inDateTimeStr,"^",2)
		i InDate'="" s InDate=$zd(InDate,3)
		i InTime'="" s InTime=$zt(InTime,2)
		s InTime=InDate_"&nbsp;"_InTime   //加空格，用于前台显示
		
		s PAAdmDate=$ZD($P($g(^PAADM(admId)),"^",6),3)
		
		s InDay=##class(DtPortal.Common.PaadmService).getInDayByInPat(admId)  //bmz20170810 在院患者在院天数取公共方法
		
		s outDateTimeStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(admId)
		s outDate=$p(outDateTimeStr,"^",1)   //出院日期
		//continue:+outDate'=0
		
		
		
		s InNum=$P($g(^PAADM(admId)),"^",29)
		s ManagerDoc=""
		s UserDr=""
		s DocDr=$P($g(^PAADM(admId)),"^",9)
		s:DocDr'="" UserDr=$o(^SSU("SSUSR",0,"CTPCP",DocDr,0))
		
		
		set ManagerDoc=""
		//获取主管医生
		s:DocDr'="" ManagerDoc=$p($g(^CTPCP(DocDr,1)),"^",2)
		//取诊断---先取主诊断，主诊断没有再取入院诊断，都没有就取初步诊断
		s DiagnoseDesc=##class(DtPortal.Common.PaadmService).GetMainDiagnosis(admId)

		;取病人当前科室 ---bmz
		s LocID=$p(^PAADM(admId),"^",4)
		//w !,LocID
		//w !,^CTLOC(LocID)
		//continue:LocID'=113
		s DeptDesc=$p(^CTLOC(LocID),"^",2)
		i DeptDesc["-" s DeptDesc=$p(DeptDesc,"-",2)
		s Ward=wardDesc
		//临床路径
		s PathWay=##class(DtPortal.Doctor.D01PatList.D0106CpWayPat).IsInPathWay(admId)
		set PathWay=$p(PathWay,"^",1)
		//获取打开电子病历所需要的参数
		set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(admId)
		set EMRDocID=$p(EMRinfo,"^",1)
		set EMRInstanceID=$p(EMRinfo,"^",2)
		set locID=$p(EMRinfo,"^",3)
		set PatientID=$p(EMRinfo,"^",4)
		set EpisodeID=$p(EMRinfo,"^",5)
	
		Set ^||CacheTemp(repid,ind)=$lb(ind,BedNo,AdmNo,PAPMINo,MedicareNo,Name,InDate,InTime,InDay,InNum,Sex,Age,ManagerDoc,ChargeDoc,DirDoc,DiagnoseDesc,AdmReason,Ward,PatientID,DocCode,patCurrDept,PathWay,DeptDesc,ArrearageFlag,TotalCost,Balance,NurseLevelDesc,EMRDocID,EMRInstanceID,locID,EpisodeID,UserId,ifNewIn)
		Set ind=ind+1

	}
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0101AtHostPat","D010002","P","ys01")
Query D010002(queryType As %String, userCode As %String) As DtPortal.Query(ROWSPEC = "locId,locDesc,num") [ SqlProc ]
{
}

ClassMethod D010002Execute(ByRef qHandle As %Binary, queryType As %String, userCode As %String) As %Status
{
	new (qHandle,queryType,userCode)
	Set repidE1=$I(^||CacheTemp)
	Set qHandle=$lb(0,repidE1,0)
	Set ind=1
	set (locId,locDesc,num)=""
	
	if (queryType="P"){
		s locId="P",locDesc="本人"
		
	}elseif (queryType="PG"){
		s locId="PG",locDesc="主诊组"
	}
	s UserId=##class(DtPortal.Common.PublicService).GetUserID(userCode)
	q:UserId="" $$$OK
	s admIDStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList(queryType,UserId,"")
	s num=0
	if admIDStr'="" s num=$l(admIDStr,"^")
	d outPutD010002
	
	
	s locStr=##class(DtPortal.Doctor.D00CommonService).GetLocByUserCode(userCode)
	q:locStr="" $$$OK
	for i=1:1:$l(locStr,"^"){
		set locId=$p(locStr,"^",i)
		if locId="" continue
		s locType=##class(DtPortal.Common.PublicService).getDeptType(locId)
		if locType'["I" continue  
		s locDesc=##class(DtPortal.Common.PublicService).getLocDesc(locId)
		s admIDStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("loc","",locId)
		s num=0
		if admIDStr'="" s num=$l(admIDStr,"^")
		if num=0 continue
		d outPutD010002
	}
	
	q $$$OK
outPutD010002
    s Data=$lb(locId,locDesc,num)
 	s ^||CacheTemp(repidE1,ind)=Data	
 	s ind=ind+1
	q
}

}
