Class web.DHCANOPTransfer Extends %RegisteredObject
{

/// Creator:yq
/// CreatDate:2017-06-02
/// Description:获取手术病人调度列表信息
/// Input:stdate开始日期，enddate结束日期，stat手术状态，oproom手术间，Dept科室，MedCareNo病案号，NurWardId护士病区，operType手术间楼层， ifAllLoc是否全部科室
/// Output:oproomdes术间,opaId,patName病人姓名,age年龄,sex性别,regNo登记号,locdes科室,opstdate手术日期,opsttime手术时间,status手术状态,
/// receiveAppDate申请接病人日期,receiveAppTime申请接病人时间,receiveAppUser申请者,receiveBackDate病人报到日期,receiveBackTime病人报到时间,
/// receiveDate安排接病人日期,receiveTime安排接病人时间,receiveUser接人者,sendBackData护工报到日期,sendBackTime护工报到时间,sendAppDate申请送病人日期,
/// sendAppTime申请送病人时间,sendAppUser申请者,sendDate安排送病人日期,sendTime送病人事假,sendUser送人者
/// d ##class(%ResultSet).RunQuery("web.DHCANOPTransfer","GetANOPTransferList","28/8/2017","15/12/2017","","","","","","","N","566");
/// d ##class(%ResultSet).RunQuery("web.DHCANOPTransfer","GetANOPTransferList","21/10/2018","21/11/2018","","","","","","","","","")
Query GetANOPTransferList(stdate As %String, enddate As %String, stat As %String, oproom As %String, Dept As %String, MedCareNo As %String = "", NurWardId As %String = "", operType As %String = "", ifAllLoc As %String = "", EpisodeID As %String) As %Query(ROWSPEC = "oproomdes,opaId,patName,age,sex,regNo,locdes,opstdate,opsttime,status,receiveAppDate,receiveAppTime,receiveAppUser,receiveAssDate,receiveAssTime,receiveBackDate,receiveBackTime,receiveDate,receiveTime,receiveUser,sendAssDate,sendAssTime,sendBackDate,sendBackTime,sendAppDate,sendAppTime,sendAppUser,sendDate,sendTime,sendUser")
{
}

ClassMethod GetANOPTransferListExecute(ByRef qHandle As %Binary, stdate As %String, enddate As %String, stat As %String, oproom As %String, Dept As %String, MedCareNo As %String = "", NurWardId As %String = "", operType As %String = "", ifAllLoc As %String = "", EpisodeID As %String) As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 
 s ^TEMPyq("0806")=stdate_"^"_enddate_"^"_stat_"^"_ oproom_"^"_Dept_"^"_ MedCareNo_"^"_NurWardId_"^"_operType_"^"_ifAllLoc_"^"_EpisodeID

 i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
 e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate) 	
 s SubNode="SDate"
 f date=sdate:1:edate
 {   
    s opaId="",floorId="",opaRowId=""
	f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
	.q:$d(^DHCANOPArrange(opaId))<1
	.s opstdate=$P(^DHCANOPArrange(opaId),"^",14)				//手术开始日期	
	.s opsttime=$P(^DHCANOPArrange(opaId),"^",15)				//手术开始时间
	.s opstdate=$ZD(opstdate,4)
	.s opsttime=$ZT(opsttime)
	.s openddate=$P(^DHCANOPArrange(opaId),"^",16)				//手术结束日期
	.s opendtime=$P(^DHCANOPArrange(opaId),"^",17)				//手术结束时间
	.s adm=$P(^DHCANOPArrange(opaId),"^",1),admId=adm			//就诊号
	.q:adm=""
	.q:(EpisodeID'="")&&(EpisodeID'=adm)
	.s papmiId=$p($g(^PAADM(admId)),"^",1)
	.s paadmtype=$p($g(^PAADM(admId)),"^",2)
	.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)					//登记号
	.;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	.s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(admId,paadmtype,.ErrMsg)
	.;s medCareNo= ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(adm , .ErrMsg)			
	.q:(medCareNo'=MedCareNo)&(MedCareNo'="")
	.s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)					//姓名
	.s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	.;s age=##class(web.UDHCANOPArrange).CalAge(birth,opstdate)		//年龄  弃用 YuanLin 20170830
	.s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,admId)
	.s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	.s admLocId=$p($g(^PAADM(admId)),"^",4)
	.q:admLocId=""
	.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
	.s qFlag=1
	.i ifAllLoc="Y" s qFlag=0
	.q:(("^"_Dept_"^")'[("^"_appLocId_"^"))&(Dept'="")&(("^"_Dept_"^")'[("^"_admLocId_"^"))&(admLocId'="")&(qFlag)
	.s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)					//手术间
	.i oproomdr'="" s oproomdes=$p($g(^DHCANC("OPRoom",oproomdr)),"^",2)
	.q:(oproomdr'=oproom)&(oproom'="")
	.i oproomdr'="" s floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
	.;q:(floorId'=oprFloorId)&(oprFloorId'="")&(floorId'="")
	.s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	.q:(opaStatus'=stat)&(stat'="")
	.s opaPatStatus=$P(^DHCANOPArrange(opaId),"^",23)				//病人状态
	.s status=""													//手术状态
	.i opaStatus="A" s status="申请"
	.i (opaStatus="D")&(opaPatStatus'="I") s status="拒绝"
	.i opaStatus="R" s status="安排"
	.i opaStatus="N" s status="非预约"
	.i opaStatus="I" s status="术中"
	.i opaStatus="P" s status="恢复室"
	.i opaStatus="L" s status="术毕"
	.i opaStatus="F" s status="完成"
	.i (opaStatus="D")&(opaPatStatus="I") s status="撤销"
	.s admLocId=$p($g(^PAADM(adm)),"^",4)							//病人所在科室
	.q:admLocId=""
	.s loc=$p($g(^DHCANOPArrange(opaId)),"^",54)
	.s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)				//申请科室
	.s qFlag=1
	.i (ifAllLoc="Y")  s qFlag=0
	.q:(("^"_Dept_"^")'[("^"_appLocId_"^"))&(Dept'="")&(("^"_Dept_"^")'[("^"_admLocId_"^"))&(qFlag)	
	.i +loc=0 s loc=admLocId
	.i +loc=0 s locdes=""
	.e  s locdes=$P($g(^CTLOC(loc)),"^",2)
	.i (loc'="")&(admLocId'=loc)&(paadmtype'="O") s locdes=locdes_"(借)"
	.i $l(locdes,"-")>1 s locdes=$p(locdes,"-",2)
	.i paadmtype="O" s locdes=locdes_"(门)"
	.s chl=$P($P(^DHCANOPArrange(opaId),"^",2),"||",2)
	.b
	.s jz=$P(^OR(adm,"ANA",chl),"^",32)
	.q:(operType'="")&((operType'="A")&(jz'=operType))
	.b	;
	.s receiveAppDate="",receiveAppTime="",receiveAppUserId="",receiveAppUser="",receiveDate="",receiveTime="",receiveUserIdStr="",receiveAssDate="",receiveAssTime="",receiveBackDate="",receiveBackTime=""
	.s sendAppDate="",sendAppTime="",sendAppUserId="",sendAppUser="",sendDate="",sendTime="",sendUserIdStr="",sendAssDate="",sendAssTime="",sendBackDate="",sendBackTime=""                             
	.s receiveAppDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAppDate")   	//申请接病人日期
	.i receiveAppDateStr'="" s receiveAppDate=$p(receiveAppDateStr,$c(3),1)
    .s receiveAppTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAppTime")   	//申请接病人时间
    .i receiveAppTimeStr'="" s receiveAppTime=$p(receiveAppTimeStr,$c(3),1)
    .s receiveAppUserIdStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAppUser")  //接病人申请单填写人
    .i receiveAppUserIdStr'="" s receiveAppUserId=$p(receiveAppUserIdStr,$c(3),1)
    .i receiveAppUserId'="" s receiveAppUser=$p($g(^SSU("SSUSR",receiveAppUserId)),"^",2)
    .s receiveDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveDate")       	//安排的接病人日期
    .i receiveDateStr'="" s receiveDate=$p(receiveDateStr,$c(3),1) 
    .s receiveTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveTime")	    	//安排的接病人日期
    .i receiveTimeStr'="" s receiveTime=$p(receiveTimeStr,$c(3),1)
    .s receiveUserStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveUser")  		//接人者
    .i receiveUserStr'="" s receiveUserIdStr=$p(receiveUserStr,$c(3),1)
    .s num=$p(receiveUserIdStr,",")
    .s receiveUser=""
    .f i=1:1:num d
    ..s receiveUserId=$p(receiveUserIdStr,",",i)
    ..q:receiveUserId=""
    ..s receiveUserEve=$p($g(^SSU("SSUSR",receiveUserId)),"^",2)
    ..i receiveUser="" s receiveUser=receiveUserEve
    ..e  s receiveUser=receiveUser_","_receiveUserEve
    .s receiveAssDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAssDate")	//接病人护工报到日期
    .i receiveAssDateStr'="" s receiveAssDate=$p(receiveAssDateStr,$c(3),1)
    .s receiveAssTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAssTime")	//接病人护工报到时间
    .i receiveAssTimeStr'="" s receiveAssTime=$p(receiveAssTimeStr,$c(3),1)
    .s receiveBackDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveBackDate")	//入手术间日期
    .i receiveBackDateStr'="" s receiveBackDate=$p(receiveBackDateStr,$c(3),1)
    .s receiveBackTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveBackTime")	//入手术间时间
    .i receiveBackTimeStr'="" s receiveBackTime=$p(receiveBackTimeStr,$c(3),1)
    .s sendAppDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAppDate") 			//申请送病人日期
    .i sendAppDateStr'="" s sendAppDate=$p(sendAppDateStr,$c(3),1)
    .s sendAppTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAppTime") 			//申请送病人时间
    .i sendAppTimeStr'="" s sendAppTime=$p(sendAppTimeStr,$c(3),1)    
    .s sendAppUserIdStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAppUser") 		//送病人申请单填写人
    .i sendAppUserIdStr'="" s sendAppUserId=$p(sendAppUserIdStr,$c(3),1)
    .i sendAppUserId'="" s sendAppUser=$p($g(^SSU("SSUSR",sendAppUserId)),"^",2)
    .s sendDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendDate")				//安排送病人日期
    .i sendDateStr'="" s sendDate=$p(sendDateStr,$c(3),1) 
    .s sendTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendTime")				//安排送病人时间
    .i sendTimeStr'="" s sendTime=$p(sendTimeStr,$c(3),1)
    .s sendUserStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendUser")	    		//安排送人者
    .i sendUserStr'="" s sendUserIdStr=$p(sendUserStr,$c(3),1)
    .s m=$p(sendUserIdStr,",")
    .s sendUser=""
    .f i=1:1:m d
    ..s sendUserId=$p(sendUserIdStr,",",i)
    ..q:sendUserId=""
    ..s sendUserEve=$p($g(^SSU("SSUSR",sendUserId)),"^",2)
    ..i sendUser="" s sendUser=sendUserEve
    ..e  s sendUser=sendUser_","_sendUserEve
    .s sendAssDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAssDate")          //送病人护工报到日期
    .i sendAssDateStr'="" s sendAssDate=$p(sendAssDateStr,$c(3),1)
    .s sendAssTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAssTime")			//送病人护工报到时间
    .i sendAssTimeStr'="" s sendAssTime=$p(sendAssTimeStr,$c(3),1)
    .s sendBackDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendBackDate")		//出手术间日期
    .i sendBackDateStr'="" s sendBackData=$p(sendBackDateStr,$c(3),1)
    .s sendBackTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendBackTime")		//出手术间时间
    .i sendBackTimeStr'="" s sendBackTime=$p(sendBackTimeStr,$c(3),1)
    .q:(receiveAppTime="")&&(sendAppTime="")
    .s patwardId=$P($G(^DHCANOPArrange(opaId)),"^",32)				//手术病人病区
	.//s ^TEMPYY("GroupId",opaId)=NurWardId_"^"_ patwardId
	.q:(NurWardId'=patwardId)&(NurWardId'="")    
    .d OutputRow8
 }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputRow8
	set Data=$lb(oproomdes,opaId,patName,age,sex,regNo,locdes,opstdate,opsttime,status,receiveAppDate,receiveAppTime,receiveAppUser,receiveAssDate,receiveAssTime,receiveBackDate,receiveBackTime,receiveDate,receiveTime,receiveUser,sendAssDate,sendAssTime,sendBackData,sendBackTime,sendAppDate,sendAppTime,sendAppUser,sendDate,sendTime,sendUser)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod GetANOPTransferListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetANOPTransferListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

ClassMethod GetANOPTransferListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetANOPTransferListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:yq
/// CreatDate:2017-06-01
/// Description:申请接病人
/// Input:opaId手术号，str申请接病人日期^申请接病人时间^申请者,userId操作者
/// d ##class(web.DHCANOPTransfer).insertReceiveApp(334,"16/8/2017^13:30",69)
ClassMethod insertReceiveApp(opaId As %String, str1 As %String, userId As %String) As %String
{
	q:opaId="" "请先选择一条手术"
	q:($p(str1,"^",1)="") "请选择接病人日期"
	q:($p(str1,"^",2)="") "请选择接病人时间"
	s receiveSystemDate=$ZD($p($h,",",1),3)
    s receiveSystemTime=$ZT($p($h,",",2),2)
	s receiveAppDate= $p(str1,"^",1)
	s receiveAppTime=$p(str1,"^",2)
	s receiveAppUser=$p(str1,"^",3)
	i receiveAppDate'="" s ReceiveAppDate=##class(web.DHCANOPCom).ConvertToDateH(receiveAppDate)
	i receiveAppTime'="" s ReceiveAppTime=##class(web.DHCANOPCom).ConvertToTimeH(receiveAppTime)
	q:ReceiveAppDate<$p($h,",",1) "申请日期不能早于系统当前日期"
	q:((ReceiveAppDate=$p($h,",",1))&&(ReceiveAppTime<$p($h,",",2))) "申请时间不能早于系统当前时间"
	
	s receiveAppDateId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"receiveAppDate",receiveAppDate,"",userId) //申请接病人日期
	q:receiveAppDateId<0 "申请失败"
	s receiveAppTimeId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"receiveAppTime",receiveAppTime,"",userId) //申请接病人时间
	q:receiveAppTimeId<0 "申请失败"
	s receiveAppUserId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"receiveAppUser",receiveAppUser,"",userId)
	q:receiveAppUserId<0 "申请失败"
	s receiveSystemDateId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"receiveSystemDate",receiveSystemDate,"",userId) //记录申请接病人操作的系统日期
	q:receiveSystemDateId<0 "申请失败"
	s receiveSystemTimeId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"receiveSystemTime",receiveSystemTime,"",userId) //记录申请接病人操作的系统时间
	q:receiveSystemTimeId<0 "申请失败"
	
	s ^DHCANOPArrangepolling(2)=1
	q 0
}

/// Creator:yq
/// CreatDate:2014-08-06
/// Description:申请送病人
/// Input:opaId手术号，str申请送病人日期^申请送病人时间^申请者
/// Return:0申请成功，-1没有选择手术，-2参数不能为空，申请日期不能早于系统当前日期，申请时间不能早于系统当前时间
ClassMethod insertSendApp(opaId As %String, str1 As %String, userId As %String) As %String
{
	q:opaId="" "请先选择一条手术"
	q:($p(str1,"^",1)="") "请选择送病人日期"
	q:($p(str1,"^",2)="") "请选择送病人时间"
	s sendSystemDate=$ZD($p($h,",",1),3)
    s sendSystemTime=$ZT($p($h,",",2),2)
	s sendAppDate=$p(str1,"^",1)
	s sendAppTime=$p(str1,"^",2)
	s sendAppUser=$p(str1,"^",3)
	i sendAppDate'="" s SendAppDate=##class(web.DHCANOPCom).ConvertToDateH(sendAppDate)
	i sendAppTime'="" s SendAppTime=##class(web.DHCANOPCom).ConvertToTimeH(sendAppTime)
	q:SendAppDate<$p($h,",",1) "申请日期不能早于系统当前日期"
	q:((SendAppDate=$p($h,",",1))&&(SendAppTime<$p($h,",",2))) "申请时间不能早于系统当前时间"

	s sendAppDateId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"sendAppDate",sendAppDate,"",userId) //申请送病人日期
	q:sendAppDateId<0 "申请失败"
	s sendAppTimeId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"sendAppTime",sendAppTime,"",userId) //申请送病人时间
	q:sendAppTimeId<0 "申请失败"
	s sendAppUserId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"sendAppUser",sendAppUser,"",userId)
	q:sendAppUserId<0 "申请失败"
	s sendSystemDateId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"sendSystemDate",sendSystemDate,"",userId) //记录申请送病人操作的系统日期
	q:sendSystemDateId<0 "申请失败"
	s sendSystemTimeId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"sendSystemTime",sendSystemTime,"",userId) //记录申请送病人操作的系统时间
	q:sendSystemTimeId<0 "申请失败"
	
	s ^DHCANOPArrangepolling(1)=1
	q 0
}

/// Creator:yq
/// CreatDate:2017-06-01
/// Description:获取已填写申请单的信息
/// Input:opaId手术号
/// Return:申请接病人日期^申请接病人时间^申请送病人日期^申请送病人时间
ClassMethod getAppStr(opaId As %String) As %String
{
	q:opaId="" "请先选择一条手术"
	
	s receiveAppDate="",receiveAppTime="",sendAppDate="",sendAppTime=""
	s receiveAppDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAppDate")
	s receiveAppDate=$p(receiveAppDateStr,$c(3),1)
	s receiveAppTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAppTime")
	s receiveAppTime=$p(receiveAppTimeStr,$c(3),1)
	
	s sendAppDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAppDate")
	s sendAppDate=$p(sendAppDateStr,$c(3),1)
	s sendAppTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAppTime")
	s sendAppTime=$p(sendAppTimeStr,$c(3),1)
	
	s Str=receiveAppDate_"^"_receiveAppTime_"^"_sendAppDate_"^"_sendAppTime
	
	q Str
}

/// Creator:yq
/// CreatDate:2017-06-01
/// Description:安排接病人日期和时间
/// Input:opaId手术号，receiveTime安排时间，userId操作人
/// Return:0申请成功，-1没有选择手术，-2参数不能为空，-3先申请才能安排接病人日期，-100保存到手术扩展表失败
ClassMethod updateReceiveTime(opaId As %String, receiveTime As %String, userId As %String) As %String
{
	q:opaId="" "请先选择一条手术"
	q:receiveTime="" "安排时间不能为空！"
	s receiveAppDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAppDate")
	s receiveAppDate=$p(receiveAppDateStr,$c(3),1)
	q:receiveAppDate="" "接病人日期不能为空！"                                    //先申请才能安排接病人日期
	s receiveDateId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"receiveDate",receiveAppDate,"",userId)	//安排接病人日期		
	q:receiveDateId<0 "申请失败"	                                //安排接病人日期默认为申请接病人日期
	s receiveTimeId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"receiveTime",receiveTime,"",userId)	//安排接病人时间		
	q:receiveTimeId<0 "申请失败"		                            	
	q 0
}

/// Creator:yq
/// CreatDate:2017-06-01
/// Description:安排接人者
/// Input:opaId手术号
/// Return:0申请成功，-1没有选择手术，-2参数不能为空，-3先安排接病人日期和时间
ClassMethod updateReceiveUser(opaId As %String, receiveUserStr As %String, userId As %String) As %String
{
	//s ^TEMPYQ("1120")=opaId_"^"_receiveUserStr
	q:opaId="" "请先选择一条手术"
	q:receiveUserStr="" "接人者不能为空"	
	s receiveDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveDate")		
	s receiveDate=$p(receiveDateStr,$c(3),1)
	s receiveTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveTime")		
	s receiveTime=$p(receiveTimeStr,$c(3),1)
	q:((receiveDate="")!(receiveTime="")) "请先安排接病人日期和时间"					//先安排接病人日期和时间
		//接人者	
	s receiveUserStrId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"receiveUser",receiveUserStr,"",userId)
	q:receiveUserStrId<0 "申请失败"
	q 0
}

/// Creator:yq
/// CreatDate:2017-06-02
/// Description:安排送病人时间
/// Input:opaId手术号
/// Return:0申请成功，-1没有选择手术，-2参数不能为空，-3先申请才能安排送病人日期
ClassMethod updateSendTime(opaId As %String, sendTime As %String, userId As %String) As %String
{
	q:opaId="" "请先选择一条手术"
	q:sendTime="" "送病人时间不能为空"
	s sendAppDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAppDate")		
	s sendAppDate=$p(sendAppDateStr,$c(3),1)
	q:sendAppDate="" "请先申请才能安排送病人日期"  						//先申请才能安排送病人日期
		
	s sendDateId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"sendDate",sendAppDate,"",userId)  //安排送病人日期
	q:sendDateId<0 "申请失败"                                           //安排送病人日期默认为申请送病人日期
	s sendTimeId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"sendTime",sendTime,"",userId)			//安排送病人时间
	q:sendTimeId<0 "申请失败"
	q 0
}

/// Creator:yq
/// CreatDate:2017-06-02
/// Description:安排送人者
/// Input:opaId手术号
/// Return:0申请成功，-1没有选择手术，-2参数不能为空，-3先安排送病人日期和时间
ClassMethod updateSendUser(opaId As %String, sendUserStr As %String, userId As %String) As %String
{
	q:opaId="" "请先选择一条手术"
	q:sendUserStr="" "送人者不能为空"
	s sendDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendDate")
	s sendDate=$p(sendDateStr,$c(3),1)
	s sendTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendTime")
	s sendTime=$p(sendTimeStr,$c(3),1)
	q:(sendDate="")!(sendTime="") "请先安排送病人日期和时间"					//先安排接病人日期和时间	
	s sendUserId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"sendUser",sendUserStr,"",userId)		//送人者
	q:sendUserId<0 "申请失败"
	q 0
}

/// Creator:yq
/// CreatDate:2017-06-02
/// Description:判断是否已申请
/// Input:opaId手术号
/// Return:接病人申请标志^送病人申请标志
ClassMethod ifAppFlag(opaId As %String) As %String
{
	q:opaId="" "请先选择一条手术"
    s receiveAppFlag=0,sendAppFlag=0 	
	s receiveAppDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAppDate")
	s receiveAppDate=$p(receiveAppDateStr,$c(3),1)
	s receiveAppTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAppTime")
	s receiveAppTime=$p(receiveAppTimeStr,$c(3),1)
	i receiveAppDate'="" s receiveAppFlag=1						//已申请接病人
	
	s sendAppDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAppDate")
	s sendAppDate=$p(sendAppDateStr,$c(3),1)
	s sendAppTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAppTime")
	s sendAppTime=$p(sendAppTimeStr,$c(3),1)
	i sendAppDate'="" s sendAppFlag=1							//已申请送病人
		
	q receiveAppFlag_"^"_sendAppFlag
}

/// Creator:yq
/// CreatDate:2017-06-02
/// Description:接病人护工调度室报到时间
/// Input:opaId手术号
/// Return:0确认成功，-1没有选择手术，-100保存到手术扩展表失败
ClassMethod insertReceiveAss(opaId As %String, userId As %String) As %String
{
	q:opaId="" "请先选择一条手术"
	s receiveAssDate=$p($h,",",1)
	s receiveAssDate=$ZD(receiveAssDate,3)
	s receiveAssTime=$p($h,",",2)
	s receiveAssTime=$ZT(receiveAssTime,2)
	s receiveAssDateId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"receiveAssDate",receiveAssDate,"",userId)
	q:receiveAssDateId<0 "申请失败"
	s receiveAssTimeId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"receiveAssTime",receiveAssTime,"",userId)
	q:receiveAssTimeId<0 "申请失败"
	q 0
}

/// Creator:yq
/// CreatDate:2017-06-02
/// Description:送病人护工调度室报到时间
/// Input:opaId手术号
/// Return:0确认成功，-1没有选择手术，-100保存到手术扩展表失败
ClassMethod insertSendAss(opaId As %String, userId As %String) As %String
{
	q:opaId="" "请先选择一条手术"
	s sendAssDate=$p($h,",",1)
	s sendAssDate=$ZD(sendAssDate,3)
	s sendAssTime=$p($h,",",2)
	s sendAssTime=$ZT(sendAssTime,2)
	s sendAssDateId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"sendAssDate",sendAssDate,"",userId)
	q:sendAssDateId<0 "申请失败"
	s sendAssTimeId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"sendAssTime",sendAssTime,"",userId)
	q:sendAssTimeId<0 "申请失败"
	q 0
}

/// Creator:yq
/// CreatDate:2017-06-02
/// Description:确认病人入手术间时间
/// Input:opaId手术号
/// Return:0确认成功，-1没有选择手术 ,-100保存到手术扩展表失败
ClassMethod insertPatInRoom(opaId As %String, userId As %String) As %String
{
	q:opaId="" "请先选择一条手术记录"
	s receiveBackDate=$p($h,",",1)	//接人者回操作的系统日期
	s receiveBackDate=$ZD(receiveBackDate,3)
	s receiveBackDateId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"receiveBackDate",receiveBackDate,"",userId)
	q:receiveBackDateId<0 "填写入手术间日期失败"
	s receiveBackTime=$p($h,",",2)	//接人者回操作的系统时间
	s receiveBackTime=$ZT(receiveBackTime,2)
	s receiveBackTimeId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"receiveBackTime",receiveBackTime,"",userId)
	q:receiveBackTimeId<0 "填写入手术间时间失败"
	q 0
}

/// Creator:yq
/// CreatDate:2017-06-02
/// Description:确认出手术室时间
/// Input:opaId手术号
/// Return:0确认成功，-1没有选择手术
ClassMethod insertPatOutRoom(opaId As %String, userId As %String) As %String
{
	q:opaId="" "请先选择一条手术记录"
	s sendBackData=$p($h,",",1)	//送人者回操作的系统日期
	s sendBackData=$ZD(sendBackData,3)
	s sendBackDataId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"sendBackDate",sendBackData,"",userId)
	q:sendBackData<0 "填写出手术间日期失败"
	s sendBackTime=$p($h,",",2)
	s sendBackTime=$ZT(sendBackTime,2)
	s sendBackTimeId=##class(web.DHCANOPArrangeExtend).SaveSingleArrangeExtend(opaId,"sendBackTime",sendBackTime,"",userId)	//送人者回操作的系统时间
	q:sendBackTimeId<0 "填写出手术间时间失败"
	q 0
}

/// Creator:yq
/// CreatDate:2017-06-08
/// Description:手术室护士申请接病人病区床位图上图标显示
/// Input:EpisodeID就诊号
/// Return:1显示图标,0不显示图标
ClassMethod ifInsertReceiveApp(EpisodeID) As %String
{
	q:EpisodeID=""
	s ^tempyq("insert")=EpisodeID
	s opaId="",ret=0
	s receiveAppDate="",receiveAppTime="",receiveAssDate="",receiveAssTime=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
	.s receiveAppDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAppDate")   	//申请接病人日期
	.i receiveAppDateStr'="" s receiveAppDate=$p(receiveAppDateStr,$c(3),1)
	.i receiveAppDate'="" s receiveAppDate=##class(web.DHCANOPCom).ConvertToDateH(receiveAppDate)
    .s receiveAppTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAppTime")   	//申请接病人时间
    .i receiveAppTimeStr'="" s receiveAppTime=$p(receiveAppTimeStr,$c(3),1)
    .i receiveAppTime'="" s receiveAppTime=##class(web.DHCANOPCom).ConvertToTimeH(receiveAppTime)
    .s receiveAssDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAssDate")	//接病人护工报到日期
    .i receiveAssDateStr'="" s receiveAssDate=$p(receiveAssDateStr,$c(3),1)
    .i receiveAssDate'="" s receiveAssDate=##class(web.DHCANOPCom).ConvertToDateH(receiveAssDate)
    .s receiveAssTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAssTime")	//接病人护工报到时间
    .i receiveAssTimeStr'="" s receiveAssTime=$p(receiveAssTimeStr,$c(3),1)
    .i receiveAssTime'="" s receiveAssTime=##class(web.DHCANOPCom).ConvertToTimeH(receiveAssTime)
    .s curDate=$p($h,",",1)
    .s curTime=$p($h,",",2) 
    .i (curDate=receiveAppDate)&&(receiveAppTime'="") s ret=1                                    			//手术室护士申请接病人显示图标
    .i (curDate=receiveAssDate)&&(receiveAssTime'="") s ret=0	       										//护工报到不显示图标
	
	q ret
}

/// Creator:yq
/// CreatDate:2017-06-08
/// Description:接病人护工调度室报到病区床位图上图标显示
/// Input:EpisodeID就诊号
/// Return:1显示图标,0不显示图标
ClassMethod ifInsertReceiveAss(EpisodeID) As %String
{
	q:EpisodeID=""
    s opaId="",ret=0
    s receiveAssDate="",receiveAssTime="",receiveBackDate="",receiveBackTime=""
    f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
    .s receiveAssDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAssDate")	//接病人护工报到日期
    .i receiveAssDateStr'="" s receiveAssDate=$p(receiveAssDateStr,$c(3),1)
    .i receiveAssDate'="" s receiveAssDate=##class(web.DHCANOPCom).ConvertToDateH(receiveAssDate)
    .s receiveAssTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAssTime")	//接病人护工报到时间
    .i receiveAssTimeStr'="" s receiveAssTime=$p(receiveAssTimeStr,$c(3),1)
    .i receiveAssTime'="" s receiveAssTime=##class(web.DHCANOPCom).ConvertToTimeH(receiveAssTime)
    .s receiveBackDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveBackDate")	//入手术间日期
    .i receiveBackDateStr'="" s receiveBackDate=$p(receiveBackDateStr,$c(3),1)
    .i receiveBackDate'="" s receiveBackDate=##class(web.DHCANOPCom).ConvertToDateH(receiveBackDate)
    .s receiveBackTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveBackTime")	//入手术间时间
    .i receiveBackTimeStr'="" s receiveBackTime=$p(receiveBackTimeStr,$c(3),1)
    .i receiveBackTime'="" s receiveBackTime=##class(web.DHCANOPCom).ConvertToTimeH(receiveBackTime)
    .s curDate=$p($h,",",1)
    .s curTime=$p($h,",",2) 
    .i (curDate=receiveAssDate)&&(receiveAssTime'="") s ret=1      											//护工确认报到后显示图标
    .i (curDate=receiveBackDate)&&(receiveBackTime'="") s ret=0	   											//病人入手术室确认后不显示图标
	q ret
}

/// Creator:yq
/// CreatDate:2017-06-08
/// Description:手术室护士申请送病人病区床位图上图标显示
/// Input:EpisodeID就诊号
/// Return:1显示图标,0不显示图标
ClassMethod ifInsertSendApp(EpisodeID) As %String
{
	q:EpisodeID=""
	s opaId="",ret=0
	s sendAppDate="",sendAppTime="",sendAssDate="",sendAssTime=""
	f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
	.s sendAppDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAppDate")   	//申请送病人日期
	.i sendAppDateStr'="" s sendAppDate=$p(sendAppDateStr,$c(3),1)
	.i sendAppDate'="" s sendAppDate=##class(web.DHCANOPCom).ConvertToDateH(sendAppDate)
    .s sendAppTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAppTime")   	//申请送病人时间
    .i sendAppTimeStr'="" s sendAppTime=$p(sendAppTimeStr,$c(3),1)
    .i sendAppTime'="" s sendAppTime=##class(web.DHCANOPCom).ConvertToTimeH(sendAppTime)
    .s sendAssDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAssDate")	//送病人护工报到日期
    .i sendAssDateStr'="" s sendAssDate=$p(sendAssDateStr,$c(3),1)
    .i sendAssDate'="" s sendAssDate=##class(web.DHCANOPCom).ConvertToDateH(sendAssDate)
    .s sendAssTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAssTime")	//送病人护工报到时间
    .i sendAssTimeStr'="" s sendAssTime=$p(sendAssTimeStr,$c(3),1)
    .i sendAssTime'="" s sendAssTime=##class(web.DHCANOPCom).ConvertToTimeH(sendAssTime)
    .s curDate=$p($h,",",1)
    .s curTime=$p($h,",",2) 
    .i (curDate=sendAppDate)&&(sendAppTime'="") s ret=1                                    			//手术室护士申请送病人显示图标
    .i (curDate=sendAssDate)&&(sendAssTime'="") s ret=0	       										//护工报到不显示图标
	q ret
}

/// Creator:yq
/// CreatDate:2017-06-08
/// Description:送病人护工调度室报到病区床位图上图标显示
/// Input:EpisodeID就诊号
/// Return:1显示图标,0不显示图标
ClassMethod ifInsertSendAss(EpisodeID) As %String
{
	q:EpisodeID=""
    s opaId="",ret=0
    s sendAssDate="",sendAssTime="",sendBackDate="",sendBackTime=""
    f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
    .s sendAssDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAssDate")	//接病人护工报到日期
    .i sendAssDateStr'="" s sendAssDate=$p(sendAssDateStr,$c(3),1)
    .i sendAssDate'="" s sendAssDate=##class(web.DHCANOPCom).ConvertToDateH(sendAssDate)
    .s sendAssTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAssTime")	//接病人护工报到时间
    .i sendAssTimeStr'="" s sendAssTime=$p(sendAssTimeStr,$c(3),1)
    .i sendAssTime'="" s sendAssTime=##class(web.DHCANOPCom).ConvertToTimeH(sendAssTime)
    .s sendBackDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendBackDate")	//入手术间日期
    .i sendBackDateStr'="" s sendBackDate=$p(sendBackDateStr,$c(3),1)
    .i sendBackDate'="" s sendBackDate=##class(web.DHCANOPCom).ConvertToDateH(sendBackDate)
    .s sendBackTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendBackTime")	//入手术间时间
    .i sendBackTimeStr'="" s sendBackTime=$p(sendBackTimeStr,$c(3),1)
    .i sendBackTime'="" s sendBackTime=##class(web.DHCANOPCom).ConvertToTimeH(sendBackTime)
    .s curDate=$p($h,",",1)
    .s curTime=$p($h,",",2) 
    .i (curDate=sendAssDate)&&(sendAssTime'="") s ret=1      											//护工确认报到后显示图标
    .i (curDate=sendBackDate)&&(sendBackTime'="") s ret=0	   											//病人入手术室确认后不显示图标
	q ret
}

/// Creator:yq
/// CreatDate:2014-08-07
/// Description:获取临时的护工的安全组信息
/// Input:安全组ID
/// Output:护工ID，护工姓名
/// d ##class(%ResultSet).RunQuery("web.DHCANOPTransfer","GetTempGroup","")
Query GetTempGroup(GroupId) As %Query(ROWSPEC = "ctcpId,ctcpDesc")
{
}

ClassMethod GetTempGroupExecute(ByRef qHandle As %Binary, GroupId As %String = "") As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 //安全组取demo配置 YuanLin 20170811
 i GroupId="" s GroupId=$g(^DHCCLSet("AnOp","NursingWorker"))
 i GroupId'="" d
 .s ctcpId="" f  s ctcpId=$o(^SSU("SSUSR",ctcpId)) q:ctcpId=""  d
 ..s exist="N"
 ..s OTHLLRowId=0 f  s OTHLLRowId=$o(^SSU("SSUSR",ctcpId,"OTHLL",OTHLLRowId)) q:OTHLLRowId=""  d
 ...s OTHLLgroupId=$p(^SSU("SSUSR",ctcpId,"OTHLL",OTHLLRowId),"^",2)
 ...q:(OTHLLgroupId'=GroupId)
 ...s exist="Y"
 ..i exist="Y" d
 ...s ctcpDesc=$p(^SSU("SSUSR",ctcpId),"^",2)
 ...d OutTempGroup
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK

OutTempGroup
	set Data=$lb(ctcpId,ctcpDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTempGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTempGroupExecute ]
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

ClassMethod GetTempGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTempGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetNurseLoc(userId) As %String
{
	q:userId="" ""
	i +userId=0 s userId=%session.Data("LOGON.USERID")
	s ctlocId=%session.Data("LOGON.CTLOCID")
	;s ctlocId=22
	//s ctlocId=$P(^SSU("SSUSR",+userId),"^",4)
	s function="",ctlocDesc=""
	if ctlocId'=""
	{
	  s ctlocDesc=$P(^CTLOC(ctlocId),"^",2)
	  s function=$P(^CTLOC(ctlocId),"^",13)
	}
	if (function'="W")
	{
		s ctlocId="",ctlocDesc=""
	} 
     
	else
	{
		s locId=""
		s locId=$o(^CTLOC(ctlocId,"LINK",0,"Loc",locId))
		q:locId=""
		s ctlocId=locId
		s ctlocDesc=$P(^CTLOC(+ctlocId),"^",2)
        
	}	
	q ctlocDesc_"^"_ctlocId
}

Query GetWardByLocDr(locId) As %Query(ROWSPEC = "rw,desc")
{
}

ClassMethod GetWardByLocDrExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 
 //s ^tempyq("2015")=locId
 i locId="" d
 .s curlocwardId=%session.Data("LOGON.CTLOCID")
 .s curlocIdstr=..GetNurseLoc(curlocwardId)
 .s curlocId=$p(curlocIdstr,"^",2)
 e  s curlocId=locId
 s subwardID=""
 f  s subwardID=$o(^CTLOC(curlocId,"LINK",subwardID)) q:subwardID=""  d
 .s linkwardId=$p($g(^CTLOC(curlocId,"LINK",subwardID)),"^",1)
 .s warddesc=$p(^CTLOC(+linkwardId),"^",2)
 .s function=$p(^CTLOC(+linkwardId),"^",13)
 .q:(function'="")&&(function'="W")
 	.d Outward
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

Outward
	set Data=$lb(linkwardId,warddesc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod GetWardByLocDrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetWardByLocDrExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

ClassMethod GetWardByLocDrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetWardByLocDrExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod SendPolling(stdate As %String, enddate As %String) As %String
{
 	i (stdate="")!(enddate="") s sdate=+$H,edate=+$H
 	e  s sdate=##Class(web.DHCANOPCom).ConvertToDateH(stdate),edate=##Class(web.DHCANOPCom).ConvertToDateH(enddate) 	
 	s inum=0,jnum=0
 	s SubNode="SDate"
 	f date=sdate:1:edate
 	{   
    	s opaId=""
		f  s opaId=$O(^DHCANOPArrange(0,SubNode,date,opaId)) q:opaId=""  d
		.q:$d(^DHCANOPArrange(opaId))<1
		.s receiveAppTime="",sendAppTime=""
		
		.s receiveAppTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAppTime")   	//申请接病人时间
    	.i receiveAppTimeStr'="" s receiveAppTime=$p(receiveAppTimeStr,$c(3),1) //申请接病人时间
   	 	.s:(receiveAppTime'="") inum=inum+1
   
  	 	.s sendAppTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAppTime") 			//申请送病人时间
    	.i sendAppTimeStr'="" s sendAppTime=$p(sendAppTimeStr,$c(3),1)          //申请送病人时间
   	 	.s:(sendAppTime'="") jnum=jnum+1
	}	
	s ret=0
	if ($g(^tmpmadi("i"))'=inum)||($g(^tmpmadi("j"))'=jnum)
	{
		s ret=1
	}
	s ^tmpmadi("i")=inum
	s ^tmpmadi("j")=jnum
	q ret
}

/// Creator:yq
/// CreatDate:2017-06-11
/// Description:接/送病人护工调度室报到
/// Input:EpisodeID就诊号
/// Return:0默认,0病人入手术间，0病人出手术间,1接病人护工确认,2送病人护工确认
ClassMethod IfTransferFlag(EpisodeID As %String) As %String
{
	q:EpisodeID=""
    s opaId="",ret=0
    s receiveAssDate="",receiveAssTime="",receiveBackDate="",receiveBackTime=""
    s sendAssDate="",sendAssTime="",sendBackDate="",sendBackTime=""
    f  s opaId=$o(^DHCANOPArrange(0,"Adm",EpisodeID,opaId)) q:opaId=""  d
    .s receiveAssDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAssDate")	//接病人护工报到日期
    .i receiveAssDateStr'="" s receiveAssDate=$p(receiveAssDateStr,$c(3),1)
    .i receiveAssDate'="" s receiveAssDate=##class(web.DHCANOPCom).ConvertToDateH(receiveAssDate)
    .s receiveAssTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveAssTime")	//接病人护工报到时间
    .i receiveAssTimeStr'="" s receiveAssTime=$p(receiveAssTimeStr,$c(3),1)
    .i receiveAssTime'="" s receiveAssTime=##class(web.DHCANOPCom).ConvertToTimeH(receiveAssTime)
    .s receiveBackDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveBackDate")	//入手术间日期
    .i receiveBackDateStr'="" s receiveBackDate=$p(receiveBackDateStr,$c(3),1)
    .i receiveBackDate'="" s receiveBackDate=##class(web.DHCANOPCom).ConvertToDateH(receiveBackDate)
    .s receiveBackTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"receiveBackTime")	//入手术间时间
    .i receiveBackTimeStr'="" s receiveBackTime=$p(receiveBackTimeStr,$c(3),1)
    .i receiveBackTime'="" s receiveBackTime=##class(web.DHCANOPCom).ConvertToTimeH(receiveBackTime)
    .s curDate=$p($h,",",1)
    .s curTime=$p($h,",",2) 
    .i (curDate=receiveAssDate)&&(receiveAssTime'="") s ret=1      											//护工确认报到后显示图标
    .i (curDate=receiveBackDate)&&(receiveBackTime'="") s ret=0	  
    
    .s sendAssDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAssDate")	//送病人护工报到日期
    .i sendAssDateStr'="" s sendAssDate=$p(sendAssDateStr,$c(3),1)
    .i sendAssDate'="" s sendAssDate=##class(web.DHCANOPCom).ConvertToDateH(sendAssDate)
    .s sendAssTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendAssTime")	//送病人护工报到时间
    .i sendAssTimeStr'="" s sendAssTime=$p(sendAssTimeStr,$c(3),1)
    .i sendAssTime'="" s sendAssTime=##class(web.DHCANOPCom).ConvertToTimeH(sendAssTime)
    .s sendBackDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendBackDate")	//出手术间日期
	.s sendBackDateStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendBackDate")	//入手术间日期
    .i sendBackDateStr'="" s sendBackDate=$p(sendBackDateStr,$c(3),1)
    .i sendBackDate'="" s sendBackDate=##class(web.DHCANOPCom).ConvertToDateH(sendBackDate)
    .s sendBackTimeStr=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"sendBackTime")	//入手术间时间
    .i sendBackTimeStr'="" s sendBackTime=$p(sendBackTimeStr,$c(3),1)
    .i sendBackTime'="" s sendBackTime=##class(web.DHCANOPCom).ConvertToTimeH(sendBackTime)
    .s curDate=$p($h,",",1)
    .s curTime=$p($h,",",2) 
    .i (curDate=sendAssDate)&&(sendAssTime'="") s ret=2      											//护工确认报到后显示图标
    .i (curDate=sendBackDate)&&(sendBackTime'="") s ret=0
    
    q ret
}

/// Creator:YuanLin
/// CreatDate:2017-09-22
/// Description:获取病人信息(申请科室、状态、病人病区、手术间楼层、病案号)
/// Input:opaId
/// Return:申请科室_"^"_状态_"^"_病人病区_"^"_手术间楼层_"^"_病案号
/// w ##class(web.DHCANOPTransfer).GetPatInfo(251)
ClassMethod GetPatInfo(opaId) As %String
{
    q:opaId="" ""
    s appLocDesc="",status="",patWard="",floorId="",oprFloor="",medCareNo="",dataStr=""
    //申请科室
	s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
	i appLocId'="" s appLocDesc=$P($g(^CTLOC(appLocId)),"^",2)
	//状态
    s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
    i opaStatus="A" s status="申请"
    i opaStatus="D" s status="拒绝"
	i opaStatus="R" s status="安排"
	i opaStatus="N" s status="非预约"
	i opaStatus="I" s status="术中"
	i opaStatus="P" s status="恢复室"
	i opaStatus="L" s status="术毕"
	i opaStatus="F" s status="完成"
	i opaStatus="C" s status="撤销"
	//病区
	s patWardId=$P($G(^DHCANOPArrange(opaId)),"^",32)
	i patWardId'="" s patWard=$P($G(^PAWARD(patWardId)),"^",2)
	//手术间楼层
	s oproomdr=$P(^DHCANOPArrange(opaId),"^",20)
	i oproomdr'="" s floorId=$p($g(^DHCANC("OPRoom",oproomdr)),"^",4)
	i floorId'="" s oprFloor=$P($G(^DHCANC("Floor",floorId)),"^",2)
	//病案号
    s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
    //i EpisodeID'="" s medCareNo= ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID , .ErrMsg)
	i EpisodeID'="" s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	s dataStr=appLocDesc_"^"_status_"^"_patWard_"^"_oprFloor_"^"_medCareNo
	q dataStr
}

/// w ##class(web.DHCANOPArrangeDayOper).GetPatBaseInfo(246,"194","","In")
ClassMethod GetPatBaseInfo(EpisodeID, opaId, userId, type) As %String
{
	s ward="",operLocId="",operLocDesc="",appDocId="",appDocDesc="",bedCode=""
	s opDescStr="",anMethodStr="",preDiagStr="",otherinfo="",postinfo="",outinfo=""
	s admReasonDr=$p($g(^PAADM(EpisodeID,1)),"^",7)
	i admReasonDr'="" s admReason=$P(^PAC("ADMREA",admReasonDr),"^",2) //费别
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	i curWardId'="" s ward=$P($G(^PAWARD(curWardId)),"^",2)
	i $l(ward,"-")>1 s ward=$p(ward,"-",2)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
		s SecretLevel="",secretCode=""	;病人密级级别
	s SecretLevel=##class(web.DHCClinicCom).GetPatLevelByPapmiId(EpisodeID)
	;secretCode:密级,patLevel:级别
	i SecretLevel'="" s secretCode=$p($g(SecretLevel),"^",4),patLevel=$p($g(SecretLevel),"^",2)

	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	
	s locId=$P($g(^PAADM(EpisodeID)),"^",4)
	s locDes=$P(^CTLOC(locId),"^",2)
	i $l(locDes,"-")>1 s locDes=$p(locDes,"-",2)
	i type="In" d
		.s IPDefOpLocId=$g(^DHCCLSet("AnOp","IPDefOpLoc"))
		.i IPDefOpLocId'="" d
			..s operLocId=IPDefOpLocId
			..s operLocDesc=$p(^CTLOC(operLocId),"^",2)
	s operLoc=operLocId_"!"_operLocDesc
	i userId'="" d
		.s appDocId=$p($g(^SSU("SSUSR",userId)),"^",14)
		.q:appDocId=""
		.s appDocDesc=##class(web.DHCANOPCom).GetNameById(appDocId)
	s appDoc=appDocId_"!"_appDocDesc
	s appLoc=locId_"!"_locDes
	i opaId="" d SetRetData1 q retStr
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	s EpisodeID=$P(anaId,"||",1)
	s opSub=0 f  s opSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub)) q:(opSub="")  d
		.s preDigDrStr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",4)     ;ANAOP_PreopDiag_DR 术前诊断S //zhangtao add
		.s num=$l(preDigDrStr,"|")
		.f di=1:1:num d
			..s dr=$p(preDigDrStr,"|",di)
			..q:dr=""
			..s desc=$P(^MRC("ID",dr),"^",2)
			..s item=desc
			..i preDiagStr="" s preDiagStr=item
			..e  s preDiagStr=preDiagStr_","_item
	.s opDes=""
	.s opDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",6)         ;ANAOP_Type_DR     ；手术名称
	.i opDr'="" d
		..i $D(^ORC("OPER",opDr)) d
			...s opDes=$P(^ORC("OPER",opDr),"^",2)
		..i opDescStr'=""  s opDescStr=opDescStr_","_opDes
		..e  s opDescStr=opDes
	
	s anMethDr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)       ;ANA_Method	麻醉方法
	i anMethDr'="" d
		.s anMethNum=$l(anMethDr,"|")
		.f i=1:1:anMethNum d
		..s anMethId=$p(anMethDr,"|",i)
		..q:anMethId=""
		..s anMethDesc=$p($g(^ORC("ANMET",anMethId)),"^",2)
		..i $P(anMethDesc,"-",2)'="" s anMethDesc=$P(anMethDesc,"-",2)
		..i anMethodStr="" s anMethodStr=anMethId_"!"_anMethDesc
		..e  s anMethodStr=anMethodStr_","_anMethId_"!"_anMethDesc	
	s opRoomDr=$P($g(^DHCANOPArrange(opaId)),"^",20)
	s opRoomDesc=""
	i opRoomDr'="" s opRoomDesc=$P($G(^DHCANC("OPRoom",opRoomDr)),"^",2)
	
	s opaSeq=$P(^DHCANOPArrange(opaId),"^",26) 	
	d SetRetData1 q retStr
SetRetData1
	//病人基本信息
	s patientBaseInfo=EpisodeID_"^"_patName_"^"_regNo_"^"_sex_"^"_age_"^"_locDes_"^"_ward_"^"_bedCode_"^"_admReason_"^"_SecretLevel_"^"_secretCode
    s operInfo=anMethodStr_"^"_opDescStr_"^"_preDiagStr_"^"_opRoomDesc_"^"_opaSeq
    //
    s retStr=patientBaseInfo_"@"_operInfo
}

}
