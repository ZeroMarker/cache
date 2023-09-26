/// 名称:DtPortal.Doctor.Discharge.DischgPatList
/// 描述:Portal医生角色 D01出院患者服务
/// 编写者：程鹏
/// 编写日期: 2014-07-11
Class DtPortal.Doctor.D01PatList.D0102DischgPat Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： 赵忠原  bmz20160419--增加取病案首页的参数HomePageId
/// CreatDate： 2014-7-10
/// Description: 查询出院患者列表
/// 服务号:		D01.02.01
/// Input：		QueryType : 查询单位(P:本人  PG 本主诊组  loc:科室 ward:病区); 
/// 			QureyID :   本人,主诊组为空,科室,病区为为CT_LOC表id 
/// 		   	StartDate：查询开始日期;
/// 		  	EndDate：查询结束日期
///             UserCode：用户code
/// Return： 	EstDischDate：出院日期(按最终结算日期)
/// 			DischgDate：医疗结算日期
/// 			BedNo：出院床号
/// 			PAAdmNo：就诊号   
/// 			MedicareNo：病案号
/// 			Name：姓名 
/// 			Sex：性别
/// 			Age：年龄
///             PAPMINO：登记号
///             InNum：住院次数
/// 			InDay：住院天数
/// 			ManagerDoc：主管医师
/// 			Ward: 病区 
/// 服务号:		D01.02.01    
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0102DischgPat","D010201DischgPat","P","","2017-01-01","2018-11-03","4829")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0102DischgPat","D010201DischgPat","PG","","2017-01-01","2018-11-03","4829")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0102DischgPat","D010201DischgPat","loc","104","2017-01-01","2018-11-03","4829")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0102DischgPat","D010201DischgPat","ward","193","2017-01-01","2018-11-03","4829")
/// d ##class(%ResultSet).RunQuery("DtPortal.Doctor.D01PatList.D0102DischgPat","D010201DischgPat","呼吸内科一二护理单元|193|2","2017-01-01","2018-11-03","4829")
Query D010201DischgPat(QueryType As %String, QureyID As %String, StartDate As %String, EndDate As %String, UserCode As %String) As DtPortal.Query(ROWSPEC = "EstimDischaDate,DischgDate,BedNo,MedicareNo,Name,Sex,Age,PAPMINO,InNum,InDay,ManagerDoc,Ward,UserCode,Dept,DisDiag,BillDateTime,HomePage,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId")
{
}

ClassMethod D010201DischgPatExecute(ByRef qHandle As %Binary, QueryType As %String, QureyID As %String, StartDate As %String, EndDate As %String, UserCode As %String) As %Status
{
	
	n (qHandle,QueryType,QureyID,StartDate,EndDate,UserCode,HomePageId)
	Set repid=$I(^||CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	//set StartDate="2017-01-01" //测试用
	set:StartDate["-" StartDate=$zdh(StartDate,3)
	set:EndDate["-" EndDate=$zdh(EndDate,3)
	
	Set PAADMRowID=""
	Set PAAdmNo=""
	if StartDate["-"  Set StartDate=$zdh(StartDate,3)
	if EndDate["-" Set EndDate=$zdh(EndDate,3)
	if StartDate="" Set StartDate=+$h
	if EndDate=""  Set EndDate=+$h
	s UserCode=$$ALPHAUP^SSUTIL4(UserCode)
	s UserId=##class(DtPortal.Common.PublicService).GetUserID(UserCode)
	if UserId="" Quit $$$OK
	s DocId=$P(^SSU("SSUSR",UserId),"^",14)
	if DocId="" Quit $$$OK
	
	//获得查询范围
	set UserId="",TypeLocId="",TypeWardId="",MUDocList=""
	set:QueryType="PG" MUDocList=##Class(DtPortal.Common.PublicService).GetMUDocList(DocId)
	set:QueryType="loc" TypeLocId=QureyID
	Set:QueryType="ward" TypeWardId=$o(^PAWARD(0,"WARD_LocationDR",QureyID,""))
	
	
	
	//病案首页展现ID取配置
	set HOMEPAGE=##Class(DtPortal.Common.PublicService).getValueByCode("HOMEPAGE")
	
	f Date=StartDate:1:EndDate  d
	.s PAAdm=""
	.f  s PAAdm=$o(^PAADMi("DischDate",Date,PAAdm)) q:PAAdm=""  d
	..s BedNo=""
	..s Age=""
	..s InDay=""
	..s EstimDischaDate=""
	..s EstimDischaTime=""
	..s DischgDate=""
	..s DischgTime=""
	..s EstimDischaDateT=""
	..s EstimDischaTimeT=""
	..s DischgDateT=""
	..s DischgTimeT=""
	..s ManagerDoc=""
	..s Ward=""
	..Set PatLoc=$P($g(^PAADM(PAAdm)),"^",4)
	..set paadmType=$P($g(^PAADM(PAAdm)),"^",2)
	..Quit:(paadmType'="I")
	..s AdmDocID=$p($g(^PAADM(PAAdm)),"^",9)     //主管医生
	..q:(QueryType="P")&(AdmDocID'=DocId)     //本人病人过滤
	..s AdmDocID1="^"_AdmDocID_"^"
	..q:(QueryType="PG")&(MUDocList'[AdmDocID1)     //医疗组过滤
	..Set PatLocName=$P(^CTLOC(PatLoc),"^",2)    //取科室名称，判断是否是传入的科室
	..i PatLocName["-" s PatLocName=$p(PatLocName,"-",2)
	..q:(QueryType="loc")&(PatLoc'=TypeLocId)    //按科室过滤
	..s WardID=$p(^PAADM(PAAdm),"^",70)

	..q:(QueryType="ward")&&(WardID'=TypeWardId)  //过滤病区
	..set DischgDateTimeStr=##class(DtPortal.Common.PaadmService).GetDischargeDateTime(PAAdm)
	..s DischgDate=$zd($p(DischgDateTimeStr,"^",1),3)
	..s DischgTime=$zt($p(DischgDateTimeStr,"^",2),2)
	..s DischgDate=DischgDate_"&nbsp;"_DischgTime
	
	..Set EstimDischaDateT=$P($g(^PAADM(PAAdm)),"^",59)  //取得医疗结算日期
	..if EstimDischaDateT'="" s EstimDischaDate=$zd(EstimDischaDateT,3)
	..e  s EstimDischaDate=""
	..Set EstimDischaTimeT=$P($g(^PAADM(PAAdm)),"^",60)  //取得医疗结算时间
	..if EstimDischaTimeT'="" s EstimDischaTime=$zt(EstimDischaTimeT,2)
	..e  s EstimDischaTime=""
	..Set EstimDischaDate=EstimDischaDate_"&nbsp;"_EstimDischaTime       
	..s patInfoStr=##class(DtPortal.Common.PaadmService).GetPatInfo(PAAdm)
	..s BedNo=$p(patInfoStr,"^",1)
	..s MedicareNo=$p(patInfoStr,"^",5)
	..s Name=$p(patInfoStr,"^",2)
	..s Sex=$p(patInfoStr,"^",3)
	..s Age=$p(patInfoStr,"^",4)
	..s AdmReason=$p(patInfoStr,"^",6)
	..Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	..set PatientID=$P($g(^PAADM(PAAdm)),"^",1)
	..Set Name=$P(^PAPER(PatientID,"ALL"),"^",1)
	..Set DobDate=$P($g(^PAPER(PatientID,"ALL")),"^",6)
	..Set PAPMINO=$P(^PAPER(PatientID,"PAT",1),"^",1)
	..s InNum=$P($g(^PAADM(PAAdm)),"^",29)
	..s PAAdmDate=$P($g(^PAADM(PAAdm)),"^",6)
	..s InDay=##class(DtPortal.Common.PaadmService).getInDayByOutPat(PAAdm)  //bmz20170810 出院患者在院天数取公共方法
	..s ManagerDocDr=$P($g(^PAADM(PAAdm)),"^",9)
	..i ManagerDocDr'="" s ManagerDoc=$p($g(^CTPCP(ManagerDocDr,1)),"^",2)
	..i WardID'="" s Ward=$p(^PAWARD(WardID),"^",2)
	..i Ward["-" s Ward=$p(Ward,"-",2)
	..s AdmId=PAAdm
	..;取病人当前科室 ---bmz
	..s DeptDr=$p(^PAADM(PAAdm),"^",4)
	..s Dept=$p(^CTLOC(DeptDr),"^",2)
	..i Dept["-" s Dept=$p(Dept,"-",2)
	
	..//病案首页---首页完成情况
	..//取项目电子病历首页病历展现结构id
	..s IfFinish=""
	..s rs=##class(%ResultSet).%New("DtPortal.Doctor.EMRInfoService:GetEMRHDSD0011")
	..d rs.Execute(PAAdm,HOMEPAGE)
	..f  Quit:'rs.Next()  d
	...f i=1:1:rs.GetColumnCount() d
	....s IfFinish=rs.%GetData(i)
	..d rs.Close()
	..s HomePage=""
	..i IfFinish'="" s HomePage="完成"
	..e  s HomePage="未完成"
	..;s obj=##class(%ResultSet).RunQuery("DtPortal.Doctor.EMRInfoService","GetEMRHDSD0011",PAAdm,"635")
	..//出院诊断---取统一接口
	..s DisDiag=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(PAAdm)
	..//取财务结算时间
	..s BillDateTime=..GetBillDateByAdm(PAAdm)
	..//获取打开电子病历所需要的参数
	..set EMRinfo=##class(DtPortal.Common.PaadmService).GetEMRParameter(PAAdm)
	..set EMRDocID=$p(EMRinfo,"^",1)
	..set EMRInstanceID=$p(EMRinfo,"^",2)
	..set locID=$p(EMRinfo,"^",3)
	..set PatientID=$p(EMRinfo,"^",4)
	..set EpisodeID=$p(EMRinfo,"^",5)

	..d OutPutRow
	Quit $$$OK
OutPutRow
	Set ^||CacheTemp(repid,ind)=$lb(EstimDischaDate,DischgDate,BedNo,MedicareNo,Name,Sex,Age,PAPMINO,InNum,InDay,ManagerDoc,Ward,UserCode,Dept,DisDiag,BillDateTime,HomePage,EMRDocID,EMRInstanceID,locID,PatientID,EpisodeID,UserId)
	Set ind=ind+1
	quit
}

// w ##class(DtPortal.Doctor.Discharge.DischgPatList).GetBillDateByAdm(821)

/// 根据Adm输出财务结算日期，时间
ClassMethod GetBillDateByAdm(Adm)
{
	
	n (Adm)
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
