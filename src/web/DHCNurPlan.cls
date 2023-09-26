Include Nur.DateFormat

/// 护理计划生成、执行、显示
Class web.DHCNurPlan Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 获取病人某段时间内临床路径要求填写的护理病历
/// Table：
/// Input：EpisodeID:病人就诊ID StaDate:开始日期 EndDate:结束日期
/// Return：护理病历单据名称串
/// w ##class(web.DHCNurPlan).GetNurEmrPlan(14,"","")
ClassMethod GetNurEmrPlan(EpisodeID As %String, StaDate As %String, EndDate As %String)
{
	n (EpisodeID,StaDate,EndDate)
	s rtnStr=""
	i StaDate="" s StaDate=$$$zd(+$h,3)
	i EndDate="" s EndDate=$$$zd(+$h,3)
	s a=##class(web.DHCCPW.MR.Interface).chkNursingHistoryItem(EpisodeID,StaDate,EndDate)
	s flag=$p(a,$c(1))
	s EmrStr=$p(a,$c(1),2)
	i flag>0 s rtnStr=$tr(EmrStr,"^"," , ")
	//s rtnStr="一般护理记录单,入院评估单"  //
	q rtnStr
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 获取某病人某段时间内临床路径是否有规范要求填写某护理病历单据
/// Table：
/// Input：EpisodeID:病人就诊ID StaDate:开始日期 EndDate:结束日期 EmrName:护理病历单据名称
/// Return：flag>0 有要求,其他 无要求
ClassMethod GetNurEmrPlanByName(EpisodeID As %String, StaDate As %String, EndDate As %String, EmrName As %String)
{
	n (EpisodeID,StaDate,EndDate,EmrName)
	
	i StaDate="" s StaDate=$$$zd(+$h,3)
	i EndDate="" s EndDate=$$$zd(+$h,3)
	s a=##class(web.DHCCPW.MR.Interface).chkNursingHistoryItem(EpisodeID,StaDate,EndDate,EmrName)
	s flag=$p(a,$c(1))
	q flag
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 查询某病人某段时间的护理计划
/// Table：
/// Input：EpisodeID:病人就诊ID StaDate:开始日期 EndDate:结束日期 
/// Return：itemdesc:项目描述,plandate:计划日期,triggerdesc:触发情况描述,completedesc:完成情况描述,statusdesc:当前状态
/// d ##class(%ResultSet).RunQuery("web.DHCNurPlan","FindNurPlanList",23,"!2!3!")
ClassMethod FindNurPlanListExecute(ByRef qHandle As %Binary, EpisodeID As %String, CurStatus As %String = "", StaDate As %String = "", EndDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^pstmp("FindNurPlanList")=EpisodeID_"^"_CurStatus
 	
 	i EpisodeID="" Set qHandle=$lb(0,repid,0) Quit $$$OK
 	
 	
 	
 	i StaDate="" s StaDate=+$h
	i EndDate="" s EndDate=+$h
	
	f dat=StaDate:1:EndDate
	{
		s id="" f  s id=$O(^DHCNurPlani("Rec",0,"EpisodeDate"," "_EpisodeID,dat,id)) q:id=""  d
		.s Plandata=^DHCNurPlan("Rec",id)
	    .s plandat=$$$zd(dat,3)
	    .s itemid=$Listget(Plandata,6)
	    .i itemid'="" s itemdesc=$listget(^DHCNurPlan("Item",itemid),3)
	    .s TriggerDesc=$Listget(Plandata,10)
	    .s CompleteDesc=$Listget(Plandata,9)
	    .s status=$Listget(Plandata,8)
	    .i status'="" d
	    ..s statusid=$o(^DHCNurPlani("Status",0,"Code"," "_status,""))
	    ..s statuscode=$listget(^DHCNurPlan("Status",statusid),2)
	    ..s statusdesc=$listget(^DHCNurPlan("Status",statusid),3)
	    .b ;01
	    .q:(CurStatus'="")&($g(statuscode)'="")&(CurStatus'[("!"_$g(statuscode)_"!"))
	    .q:(CurStatus="")&($g(statuscode)'="A")
 	    .Do OutputRow
	}
	 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(id,$g(itemdesc),plandat,TriggerDesc,CompleteDesc,$g(statusdesc),itemid,$g(statuscode))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindNurPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNurPlanListExecute ]
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

ClassMethod FindNurPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNurPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindNurPlanList(EpisodeID As %String, CurStatus As %String = "", StaDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "id:%String,itemdesc:%String,plandate:%String,triggerdesc:%String,completedesc:%String,statusdesc:%String,itemid:%String,statuscode:%String")
{
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 获取科室表中类型为病区的所有科室
/// Table：
/// Input：
/// Return：科室JSON串
ClassMethod GetLocList() As %String
{
	s retJson=##class(%ListOfDataTypes).%New()
	s rs=##class(%ResultSet).%New("web.DHCNurPlanItemMast:FindLocList")
	d rs.Execute()
	while(rs.Next()){
		s LocId=rs.GetDataByName("rw")
		s Loccode=rs.GetDataByName("code")
		s Locdesc=rs.GetDataByName("desc")
		s Loctyp=rs.GetDataByName("loctyp")
		continue:(Loctyp'="W")
		
		s retChildJson=##class(%ArrayOfDataTypes).%New()
		d retChildJson.SetAt(LocId,"ID")
		d retChildJson.SetAt(Locdesc,"Desc")
		d retJson.Insert(retChildJson)
	}
	q ##class(Nur.JSON).Encode(retJson)
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 根据科室获取病人列表
/// Table：
/// Input：LocID:科室ID
/// Return：病区所有病人的就诊号、登记号、床号、姓名(含等候区)
ClassMethod FindCurWardPatsExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	
	i LocID=""  s qHandle=$lb(0,repid,0) Quit $$$OK
		
	s LocType=$p($g(^CTLOC(LocID)),"^",13)
	i LocType="W" d
	.s WardID=$o(^PAWARD(0,"WARD_LocationDR",LocID,""))
	
	i $g(WardID)=""  s qHandle=$lb(0,repid,0) Quit $$$OK
	
	s curRoomId=0 f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	..s patRegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	..s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..i bedSub'="" d
	...s curWardId=$P(bedSub,"||",1)
	...s curBedSub=$P(bedSub,"||",2)
	...s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
    
	..d OutRowReg1
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutRowReg1
	s Data=$lb(EpisodeID,patRegNo,$g(bedCode),patName)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindCurWardPatsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurWardPatsExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCurWardPatsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurWardPatsExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

Query FindCurWardPats(LocID As %String) As %Query(ROWSPEC = "EpisodeID:%String,patRegNo:%String,bedCode:%String,patName:%String")
{
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 获取科室内病人列表的JSON串
/// Table：
/// Input：LocID:科室ID
/// Return：病人就诊号、姓名的JSON串
ClassMethod GetPatientList(LocID As %String) As %String
{
	s retJson=##class(%ListOfDataTypes).%New()
	s rs=##class(%ResultSet).%New("web.DHCNurPlan:FindCurWardPats")
	d rs.Execute(LocID)
	while(rs.Next()){
		s EpisodeID=rs.GetDataByName("EpisodeID")
		s bedCode=rs.GetDataByName("bedCode")
	    s patName=rs.GetDataByName("patName")
		
		i bedCode="" s bedCode="等候区"
		s patName=bedCode_"-"_patName
		s retChildJson=##class(%ArrayOfDataTypes).%New()
		d retChildJson.SetAt(EpisodeID,"EpisodeID")
		d retChildJson.SetAt(patName,"PatName")
		d retJson.Insert(retChildJson)
	}
	q ##class(Nur.JSON).Encode(retJson)
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 根据项目配置生成某病人的护理计划,插入到护理计划业务表中
/// Table：
/// Input： EpisodeID:就诊ID
/// Return：0:成功,1：失败
/// w ##class(web.DHCNurPlan).MakeSinglePersonNurPlan(450)
ClassMethod MakeSinglePersonNurPlan(EpisodeID As %String)
{
	s errflag=0
	s itmcat="" f  s itmcat=$o(^DHCNurPlani("Item",0,"ItemCat",itmcat)) q:(itmcat="")  d
	.s id=""  f  s id=$o(^DHCNurPlani("Item",0,"ItemCat",itmcat,id)) q:id=""  d
	..s adata=^DHCNurPlan("Item",id) 
	..s fromdate=$listget(adata,6)
    ..q:(fromdate>+$h)
    ..s todate=$listget(adata,7)
    ..q:(todate'="")&&(todate<+$h)
	..s itemtyp=$listget(adata,4)
	..i itemtyp'="" s itemtypDesc=$listget(^DHCNurPlan("ItemType",itemtyp),3)
	..s itemloc=$listget(adata,9)
	..i itemloc'="" s itemward=$o(^PAWARD(0,"WARD_LocationDR",itemloc,""))
	..s AdmWard=$p($g(^PAADM(EpisodeID)),"^",70)
	..q:($g(itemtypDesc)["专科")&(AdmWard'=$g(itemward))  //专科部分不是此科室的退出
	..s itemdesc=$listget(adata,3)
	..;取出病人诊断和当前符合事件
	..;
	
	..s Triggerid=""  f  s Triggerid=$o(^DHCNurPlan("Item",id,"ItemTrigger",Triggerid)) q:Triggerid=""  d
 	...s Triggerdata=^DHCNurPlan("Item",id,"ItemTrigger",Triggerid)
    ...s factorId=$listget(Triggerdata,5)
    ...q:factorId=""
    ...s factorcode=$listget(^DHCNurPlan("Factors",factorId),2)
    ...s factordesc=$listget(^DHCNurPlan("Factors",factorId),3)
    ...s freqId=$listget(Triggerdata,17)
    ...i freqId'="" s freqdesc=$P(^PHCFR(freqId),"^",3)
    ...s cusfreq=$listget(Triggerdata,18)
    ...i freqId="" s freqdesc=cusfreq
    ...;关联医嘱
    ...i factorcode="ORDER" d
    ....s arcimId=$listget(Triggerdata,2)
    ....q:arcimId=""
    ....s rtnExistorder=..IfOrddailyExist(EpisodeID,arcimId)
    ....s oeoreId=$p(rtnExistorder,"^")
    ....s oeoredesc=$p(rtnExistorder,"^",2)
    ....s oeorefreq=$p(rtnExistorder,"^",3)
    ....i (oeorefreq="")&(freqdesc'="") s oeorefreq=freqdesc
    ....s rtnSaveOrder=..InsertTriggerData(EpisodeID,id,id_"||"_Triggerid,factorcode,factordesc,oeoreId,oeoredesc,oeorefreq,"A","")
    ....i $g(rtnSaveOrder)'["||" s errflag=1
    
    ...;关联事件
    ...i factorcode="EVENT" d
    ....s eventId=$listget(Triggerdata,3)
    ....s eventdesc=$listget(^DHCNurPlan("Event",eventId),3)
    ....s eventfunc=$listget(^DHCNurPlan("Event",eventId),6)
    ....s eventpara=$listget(^DHCNurPlan("Event",eventId),7)
    ....s eventfunctyp=$listget(^DHCNurPlan("Event",eventId),8)
    ....i eventfunctyp="M" s rtnEventExsit=..ExcuteInterfaceMethod(eventfunc,eventpara,EpisodeID)
    ....e  s rtnEventExsit=..ExcuteInterfaceQuery(eventfunc,eventpara,EpisodeID)
    ....;b ;event
    ....i rtnEventExsit=0 s rtnEventExsit=""
    ....i rtnEventExsit=1 s rtnEventExsit=eventdesc_" "_itemdesc
    ....s rtninfo=..InsertTriggerData(EpisodeID,id,id_"||"_Triggerid,factorcode,factordesc,"",rtnEventExsit,freqdesc,"A","")
    ....i rtninfo'["||" s errflag=1
    
    ...;关联诊断
    ...i factorcode="DIAG" d
    ....s DiagId=$listget(Triggerdata,4)
    
    ...;关联接口
    ...i factorcode="INTERFACE" d
    ....s func=$listget(Triggerdata,10)
    ....s para=$listget(Triggerdata,11)
    ....s functyp=$listget(Triggerdata,16)
    ....i functyp="M" s rtnintface=..ExcuteInterfaceMethod(func,para,EpisodeID)
    ....e  s rtnintface=..ExcuteInterfaceQuery(func,para,EpisodeID)
    ....i rtnintface=0 s rtnintface=""
    ....i rtnintface=1 s rtnintface=itemdesc
    ....s rtninfo=..InsertTriggerData(EpisodeID,id,id_"||"_Triggerid,factorcode,factordesc,"",rtnintface,freqdesc,"A","")
    ....i rtninfo'["||" s errflag=1
    
    ..s Completeid=""  f  s Completeid=$o(^DHCNurPlan("Item",id,"ItemComplete",Completeid)) q:Completeid=""  d
 	...s Completedata=^DHCNurPlan("Item",id,"ItemComplete",Completeid)
    ...s factorId=$listget(Completedata,6)
    ...q:factorId=""
    ...s factorcode=$listget(^DHCNurPlan("Factors",factorId),2)
    ...s factordesc=$listget(^DHCNurPlan("Factors",factorId),3)
    ...s factorEmrCode=$listget(^DHCNurPlan("Factors",factorId),6)
    
    ...s EmrCode=$listget(Completedata,7)
    ...s ElementCode=$listget(Completedata,8)
    ...s ConTyp=$listget(Completedata,9)
    ...s ConValue=$listget(Completedata,10)
    
    ...;体温单填写
    ...i factorcode="OBSER" d
    ....q:ElementCode=""
    ....;b ;001
    ....s rtnExsitData=..IfEmrDataExist(EpisodeID,factorcode,factorEmrCode,ElementCode,ConTyp,ConValue,+$H,"")
    ....s rtnRecNum=$p(rtnExsitData,"^")
    ....s rtnRecTim=$p(rtnExsitData,"^",2)
    ....i +rtnRecNum>0 d
    .....s TipInfo="已测"_rtnRecNum_"次"
    .....s Status="D"
    ....e  s Status="A"
    ....;b ;01
    ....s rtninfo=..InsertCompleteData(EpisodeID,id,id_"||"_Completeid,factorcode,factordesc,"",factorEmrCode,ElementCode,$g(TipInfo),rtnRecTim,$g(Status),"")
    ....i rtninfo'["||" s errflag=1
    
    ...;执行医嘱
    ...i factorcode="ORDER" d
    ....s ArcimID=$listget(Completedata,2)
    ....q:ArcimID=""
    ....s rtnExecOrder=..IfOrderExec(EpisodeID,ArcimID)
    ....s oeoreId=$p(rtnExecOrder,"^")
    ....s oeoredesc=$p(rtnExecOrder,"^",2)
    ....s oeorefreq=$p(rtnExecOrder,"^",3)
    ....s oeoreStatus=$p(rtnExecOrder,"^",4)
    ....i oeoreStatus="F" s Status="E"
    ....e  s Status="A"
    ....;b ;02
    ....i oeoredesc'="" s oeoredesc="已执行"_""""_oeoredesc_""""
    ....s rtninfo=..InsertCompleteData(EpisodeID,id,id_"||"_Completeid,factorcode,factordesc,oeoreId,"","",oeoredesc,oeorefreq,Status,"")
    ....i rtninfo'["||" s errflag=1
    
    ...;护理病历填写
    ...i factorcode="NUREMR" d
    ....q:EmrCode=""
    ....i id=7 b ;001
    ....s rtnExsitData=..IfEmrDataExist(EpisodeID,factorcode,EmrCode,ElementCode,ConTyp,ConValue,+$H,"")
    ....i id=7 b ;002
    ....s rtnRecNum=$p(rtnExsitData,"^")
    ....s rtnRecTim=$p(rtnExsitData,"^",2)
    ....i id=7 b ;003
    ....i +rtnRecNum>0 d
    .....s TipInfo="已记录"_rtnRecNum_"条"
    .....s Status="D"
    ....i rtnRecNum="Y" d
    .....s TipInfo="已录入"
    .....s Status="D"
    ....i (rtnRecNum=0)!(rtnRecNum="")  s Status="A"
    ....s rtninfo=..InsertCompleteData(EpisodeID,id,id_"||"_Completeid,factorcode,factordesc,"",EmrCode,ElementCode,$g(TipInfo),rtnRecTim,$g(Status),"")
    ....i rtninfo'["||" s errflag=1
    
    
    ..;循环该项目所有触发数据汇总一个状态和提示信息
    ..s ^pstmp("UpdateRecParentStatus")=EpisodeID_"^"_id
    ..s rtninfo=..UpdateRecParentStatus(EpisodeID,id,"")
    ..i rtninfo'>0 s errflag=1
       
    q errflag
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 执行接口方法
/// Table：
/// Input： func:(类名:函数名),para:(参数1,参数2),EpisodeID:就诊ID
/// Return：func的返回值 
/// w ##class(web.DHCNurPlan).ExcuteInterfaceMethod("web.DHCNurPlan:GetNurEmrPlan","EpisodeID,,",14)
ClassMethod ExcuteInterfaceMethod(func As %String, para As %String, EpisodeID As %String)
{
	q:func="" ""
	s className=$p(func,":")
	s methodName=$p(func,":",2)
	q:(className="")!(methodName="") ""
	
	
	s x="s ret=##class("_className_")."_methodName_"("
	s ParaCount=##class(web.DHCNurPlanGetData).GetParaCount(className,methodName)
	f i=1:1:ParaCount
	{
		s ParaValue=$p(para,",",i)
		i ParaValue="EpisodeID" s ParaValue=EpisodeID
		s x=x_""""_ParaValue_""""
		i i'=ParaCount s x=x_","
	}
	s x=x_")"
	x x
	q ret
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 执行Query
/// Table：
/// Input： 
/// Return： 
/// w ##class(web.DHCNurPlan).ExcuteInterfaceQuery()
ClassMethod ExcuteInterfaceQuery(func As %String, para As %String, EpisodeID As %String)
{
	q ""
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 判断病人是否新入院病人
/// Table：
/// Input： EpisodeID:就诊ID 
/// Return：0：否 1：是
/// w ##class(web.DHCNurPlan).IfNewPatient()
ClassMethod IfNewPatient(EpisodeID) As %String
{
    q:EpisodeID="" 0
    s ret=0
    q:'$d(^PAADM(EpisodeID)) 0
    if $p(^PAADM(EpisodeID),"^",6)=+$h s ret=1
    q ret
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 判断病人是否符合某事件,某段时间是否存在某医嘱
/// Note：以医嘱开的医嘱为依据
/// Input： EpisodeID:就诊ID ,ArcCodes：医嘱项代码,StDays：与今天的相隔天数,EdDays：今天后几天
/// Return：0：不符合 1：符合
/// w ##class(web.DHCNurPlan).IfEventExsit()
ClassMethod IfEventExsit(EpisodeID, ArcCodes, StDays, EdDays) As %String
{
	 q:(EpisodeID="")!(ArcCodes="") 0
	 s retflag=0
	 
	 s CDate=+$h
	 i StDays="" s StDays=0
	 i EdDays="" s EdDays=0
	 
	
	 s stdate=CDate+StDays
     s tdate=CDate+EdDays
    
     
     s Oew=$o(^OEORD(0,"Adm",EpisodeID,""))
     q:Oew="" 0
     
     s chl=""
     for date=stdate:1:tdate
     {
	     s len=$l(ArcCodes,"^")
	     f i=1:1:len
	     {
		    s ArcCode=$p(ArcCodes,"^",i)
		    q:ArcCode=""
		    s ArcimID=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcCode),""))
		    q:ArcimID=""
		    s ArcimID=ArcimID_"||"_"1"
		    s OrdSub="" 
	        f 
	        {
		       s OrdSub=$O(^OEORDi(0,"ARCIM",Oew,ArcimID,date,OrdSub))
		       b ;01
		       q:OrdSub=""
		       q:chl'=""
		       b ;02
		       s OrdStatDR=$P($G(^OEORD(Oew,"I",OrdSub,1)),"^",13) 
		       s OrdStat=""
		       i OrdStatDR'="" s OrdStat=$P(^OEC("OSTAT",OrdStatDR),"^",1)
		       q:OrdStat="D"
		       s chl=OrdSub
	        }
	        q:chl'=""
	     }
	   
     }
     i chl'="" s retflag=1
     q retflag
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 判断病人当天是否存在某些医嘱
/// Note：
/// Input： EpisodeID:就诊ID ,StrArcRowIds：医嘱项ID串,用^分割
/// Return：0：不存在 1：存在
/// w ##class(web.DHCNurPlan).IfOrddailyExist()
ClassMethod IfOrddailyExist(EpisodeID, StrArcRowIds) As %String
{
 n (EpisodeID, StrArcRowIds)
 
 s num=$l(StrArcRowIds,"^")
 s ret=""
 for i=1:1:num d
 .q:ret'=""
 .s rowid=$p(StrArcRowIds,"^",i)
 .q:rowid=""
 .s ord=$o(^OEORD(0,"Adm",EpisodeID,""))
 .q:ord=""
 .s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime)) q:(ordSttTime="")!(ret'="")  d
 ..s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub)) q:(OrdSub="")!(ret'="")  d
 ...s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub,OreSub)) q:(OreSub="")!(ret'="")  d
 ....s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 ....s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 ....q:(ordStat'="V")&(ordStat'="E")
 ....s arcId=$p(^OEORD(ord,"I",OrdSub,1),"^",2)
 ....q:rowid'=arcId
 ....s arcimdes=$P(^ARCIM($p(arcId,"||"),$p(arcId,"||",2),1),"^",2)
 ....s arcimdes=$p(arcimdes,"[")   //For WF 不要规格
 ....s freq=$p($g(^OEORD(ord,"I",OrdSub,2)),"^",4)
 ....i freq'="" s freqdesc=$p($g(^PHCFR(freq)),"^",3)
 ....s oeoreId=ord_"||"_OrdSub_"||"_OreSub
 ....s ret=oeoreId_"^"_arcimdes_"^"_$g(freqdesc)
 q ret
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 判断医嘱是否存在,且已被执行
/// Note：
/// Input： EpisodeID:就诊ID ,StrArcRowIds：医嘱项ID串,用^分割
/// Return：空：不存在或未执行 1：存在并且已执行
/// w ##class(web.DHCNurPlan).IfOrderExec()
ClassMethod IfOrderExec(EpisodeID, StrArcRowIds) As %String
{
 n (EpisodeID, StrArcRowIds)
 
 s num=$l(StrArcRowIds,"^")
 s ret=""
 for i=1:1:num d
 .q:ret'=""
 .s rowid=$p(StrArcRowIds,"^",i)
 .q:rowid=""
 .s ord=$o(^OEORD(0,"Adm",EpisodeID,""))
 .q:ord=""
 .s ordSttTime="" f  s ordSttTime=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime)) q:(ordSttTime="")!(ret'="")  d
 ..s OrdSub=0 f  s OrdSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub)) q:(OrdSub="")!(ret'="")  d
 ...s OreSub=0 f  s OreSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub,OreSub)) q:(OreSub="")!(ret'="")  d
 ....s ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 ....s ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 ....q:(ordStat'="V")&(ordStat'="E")
 ....s arcId=$p(^OEORD(ord,"I",OrdSub,1),"^",2)
 ....q:rowid'=arcId
 ....s oeoreStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub)),"^",16)
 ....i oeoreStatusId'="" s oeoreStatusCode=$p(^OEC("STAT",oeoreStatusId),"^",1)
 ....q:$g(oeoreStatusCode)'="F"
 ....s arcimdes=$P(^ARCIM($p(arcId,"||"),$p(arcId,"||",2),1),"^",2)
 ....s arcimdes=$p(arcimdes,"[")   //For WF 不要规格
 ....s freq=$p($g(^OEORD(ord,"I",OrdSub,2)),"^",4)
 ....i freq'="" s freqdesc=$p($g(^PHCFR(freq)),"^",3)
 ....s oeoreId=ord_"||"_OrdSub_"||"_OreSub
 ....s ret=oeoreId_"^"_arcimdes_"^"_$g(freqdesc)_"^"_$g(oeoreStatusCode)
 q ret
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 判断某病人某日期某时间是否录入了体温单的某数据,或护理病历某单据的数据
/// Note:简单说就是护士是否填写了护理病历或体温单
/// Table：
/// Input： EpisodeID:就诊ID,Factor:因素Code,EmCode:单据关键字,EleCode:项目关键字,ConTyp:条件,ConValue:条件值,CareDat:病历日期,CareTim:病历时间
/// Return：空:无数据,不空：记录条数及时间点
/// w ##class(web.DHCNurPlan).IfEmrDataExist(240,"NUREMR","DHCNURXH12","","E","",+$H,"")
ClassMethod IfEmrDataExist(EpisodeID, Factor, EmCode, EleCode, ConTyp, ConValue, CareDat, CareTim) As %String
{
	q:(EpisodeID="") 0
	
	s rtnStr=""
	s Mradm=$P(^PAADM(EpisodeID),"^",61) 
	q:(Mradm="")&(Factor="OBSER") 0
	
	i CareDat="" s CareDat=+$h
	i $l(CareTim,":")>1 s CareTim=$zth(CareTim)
	
	i Factor="OBSER" d
	.s ItmDr=""  f  s ItmDr=$O(^MR(Mradm,"OBS",0,"Date",CareDat,ItmDr)) q:ItmDr=""  d
	..q:'$D(^MRC("OBITM",ItmDr))
	..s code=$P(^MRC("OBITM",ItmDr),"^",1)
	..q:code'=EleCode
	..s chl=""  f  s chl=$O(^MR(Mradm,"OBS",0,"Date",CareDat,ItmDr,chl)) q:chl=""  d
    ...s OBSTime = $p(^MR(Mradm,"OBS",chl),"^",4)
    ...q:(CareTim'="")&(OBSTime'=CareTim)
    ...s OBSvalue= $p(^MR(Mradm,"OBS",chl),"^",2)
    ...i (ConTyp="E")&(OBSvalue'="")  d
    ....s ^TMPOBSData(Mradm,OBSTime)=""
    
    .s i=0
    .s r="" f  s r=$o(^TMPOBSData(Mradm,r)) q:r=""  d
    ..s i=i+1
    ..i rtnStr="" s rtnStr=$zt(r,2)
    ..e  s rtnStr=rtnStr_","_$zt(r,2)
    .s rtnStr=i_"^"_rtnStr
    .k ^TMPOBSData(Mradm)
	e  d 
	.s j=0
	.s RecTyp=$ZConvert(EmCode,"U")
	.s tim="" f  s tim=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,CareDat,tim)) q:tim=""  d
	..s par="" f  s par=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,CareDat,tim,par)) q:par=""  d
	...s rw="" f  s rw=$O(^Nur.DHCNurseRecSubI("TypDatTim"," "_RecTyp,CareDat,tim,par,rw)) q:rw=""  d
	....s arr=$G(^Nur.DHCNurseRecSubD(par,rw))
	....s CancelUser=$listget(arr,67)
	....q:CancelUser'=""
	....s j=j+1
	....i rtnStr="" s rtnStr=$zt(tim,2)
    ....e  s rtnStr=rtnStr_","_$zt(tim,2)
    .s rtnStr=j_"^"_rtnStr
    .i j=0 d
    ..s rtnStr=""
    ..s rw=$O(^Nur.DHCMoudDataI("EmrCode"," "_RecTyp," "_EpisodeID,""))
    ..q:rw=""
    ..s arr=$G(^Nur.DHCMoudDataD(rw))
    ..s EmrDat=$listget(arr,4)
    ..s EmrTim=$listget(arr,5)
    ..s sub="" f  s sub=$o(^Nur.DHCMoudDataD(rw,"ChildRec",sub)) q:sub=""  d
    ...s arrsub=$G(^Nur.DHCMoudDataD(rw,"ChildRec",sub))
    ...s EmrsubDat=$listget(arrsub,2)
    ...s EmrsubTim=$listget(arrsub,3)
    ...i rw=32 b ;001
    ...q:(EmrsubDat'=CareDat)
    ...s j=j+1
    ...i rtnStr="" s rtnStr=$zt(EmrsubTim,2)
    ...e  s rtnStr=rtnStr_","_$zt(EmrsubTim,2)
    ..i rtnStr'="" s rtnStr=j_"^"_rtnStr
    ..q:rtnStr'="" 
    
    ..q:(EmrDat'=CareDat)
	..s rtnStr="Y"_"^"_$zt(EmrTim,2)
	
	q rtnStr
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 获取某病人某项目当天的护理计划ID,有则取出ID,无则插入一条记录,取出ID
/// Table：
/// Input： EpisodeID:就诊ID,itemid：项目ID,user:记录人
/// Return：DHC_NurPlan_ItemMast的ID 
/// w ##class(web.DHCNurPlan).getparentid()
ClassMethod getparentid(episodeid As %String, itemid As %String, user As %String)
{
   s rw=""  s rw=$O(^DHCNurPlani("Rec",0,"EpisodeDateItem"," "_episodeid,+$h," "_itemid,rw))
   
   if rw=""  s a=##class(User.DHCNurPlanRecParent).%New()
   e  q rw
   s a.RPEpisodeID=episodeid
   s a.RPItemID=itemid
   s a.RPPlanDate=+$h
   s a.RPRecDate=+$h
   s a.RPRecTime=$p($h,",",2)
   s a.RPRecUser=user
   d a.%Save()
   q a.%Id()
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 生成数据插入到护理计划触发数据表中
/// Table：
/// Input： EpisodeID:就诊ID
/// Return：DHC_NurPlan_ItemMast的ID 
/// w ##class(web.DHCNurPlan).InsertTriggerData()
ClassMethod InsertTriggerData(EpisodeID As %String, ItemId As %String, ItemTriggerId As %String, FactorCode As %String, FactorDesc As %String, OeoreId As %String, TipInfo As %String, FreqDesc As %String, ExecStatus As %String, User As %String)
{
	s par=..getparentid(EpisodeID,ItemId,User)
	
	
   s sub=""  s sub=$O(^DHCNurPlani("RecTrigger",0,"ItemTrigger"," "_ItemTriggerId,par,sub))
   
   if sub=""  s a=##class(User.DHCNurPlanRecTriggerSub).%New()
   e  s a=##class(User.DHCNurPlanRecTriggerSub).%OpenId(par_"||"_sub)
   
   i (FactorCode="INTERFACE")!(FactorCode="EVENT")&(TipInfo="") s ExecStatus="N",FreqDesc="" //接口类型返回空,则为无计划状态
   i (FactorCode="ORDER")&(OeoreId="") s ExecStatus="N",TipInfo="",FreqDesc="" //接口类型返回空,则为无计划状态
   if sub=""  s a.RTSParRef=##class(User.DHCNurPlanRecParent).%OpenId(par)
   
   s a.RTSItemTriggerID=ItemTriggerId
   s a.RTSTriggerFactor=FactorDesc
   
   s a.RTSOrder=OeoreId
   s a.RTSEvent=""
   s a.RTSDiag=""
   s a.RTSEmrCode=""
   s a.RTSElementCode=""
   
   
   s a.RTSDescription=TipInfo
   s a.RTSFreq=FreqDesc
   s a.RTSStatus=ExecStatus
  
   s a.RTSUpdateDate=+$h
   s a.RTSUpdateTime=$p($h,",",2)
   s a.RTSUpdateUser=User
   
   d a.%Save()
   q a.%Id()
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 生成数据插入到护理计划完成数据表中
/// Table：
/// Input： EpisodeID:就诊ID
/// Return：0 
/// w ##class(web.DHCNurPlan).InsertCompleteData()
ClassMethod InsertCompleteData(EpisodeID As %String, ItemId As %String, ItemCompleteId As %String, FactorCode As %String, FactorDesc As %String, OeoreId As %String, EmCode As %String, EleCode As %String, TipInfo As %String, FreqDesc As %String, ExecStatus As %String, User As %String)
{
	s ^pstmp("InsertCompleteData")=EpisodeID_"^"_ItemId_"^"_ItemCompleteId_"^"_FactorCode_"^"_FactorDesc_"^"_OeoreId_"^"_TipInfo_"^"_FreqDesc_"^"_ExecStatus_"^"_User
	s par=..getparentid(EpisodeID,ItemId,User)
	
	
   s sub=""  s sub=$O(^DHCNurPlani("RecComplete",0,"ItemComplete"," "_ItemCompleteId,par,sub))
   
   if sub=""  s a=##class(User.DHCNurPlanRecCompleteSub).%New()
   e  s a=##class(User.DHCNurPlanRecCompleteSub).%OpenId(par_"||"_sub)
   
   if sub=""  s a.RCSParRef=##class(User.DHCNurPlanRecParent).%OpenId(par)
   
   s a.RCSItemCompleteID=ItemCompleteId
   s a.RCSCompleteFactor=FactorDesc
   
   s a.RCSOrder=OeoreId
   s a.RCSEmrCode=EmCode
   s a.RCSElementCode=EleCode
  
   
   s a.RCSDescription=TipInfo
   s a.RCSFreq=FreqDesc
   s a.RCSStatus=ExecStatus
  
   s a.RCSUpdateDate=+$h
   s a.RCSUpdateTime=$p($h,",",2)
   s a.RCSUpdateUser=User
   
   d a.%Save()
   q a.%Id()
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 循环该项目所有触发和完成数据汇总一个状态和提示信息更新护理计划主表
/// Table：
/// Input： EpisodeID:就诊ID,ItemId:项目ID,User:更新用户
/// Return：DHC_NurPlan_ItemMast的ID
/// w ##class(web.DHCNurPlan).UpdateRecParentStatus(384,22,"")
ClassMethod UpdateRecParentStatus(EpisodeID As %String, ItemId As %String, User As %String)
{

	s par=..getparentid(EpisodeID,ItemId,User)
	 
   s TipStrs=""
   s i=1
   s sub=""  f  s sub=$O(^DHCNurPlan("Rec",par,"RecTrigger",sub)) q:sub=""  d
   .s Triggerdata=^DHCNurPlan("Rec",par,"RecTrigger",sub)
   .s Status=$listget(Triggerdata,14)
   .s Factor=$listget(Triggerdata,5)
   .s TipInfo=$listget(Triggerdata,12)
   .s Freq=$listget(Triggerdata,11)
   .;b ;01
   .i Status'="N" d
   ..i TipStrs="" s TipStrs=i_":"_TipInfo_"("_Freq_");"  //_Factor_"-"
   ..e  s TipStrs=TipStrs_"     "_i_":"_TipInfo_"("_Freq_")"  //Factor_"-"_
   ..s i=i+1
   
   s CompTipStrs=""
   s j=1
   s Compsub=""  f  s Compsub=$O(^DHCNurPlan("Rec",par,"RecComplete",Compsub)) q:Compsub=""  d
   .s Compdata=^DHCNurPlan("Rec",par,"RecComplete",Compsub)
   .s CompStatus=$listget(Compdata,11)
   .s CompFactor=$listget(Compdata,5)
   .s CompTipInfo=$listget(Compdata,10)
   .s CompFreq=$listget(Compdata,9)
   .i (EpisodeID=223)&(ItemId=13) b ;003
   .i (CompStatus="E")!(CompStatus="D") d
   ..i CompTipStrs="" s CompTipStrs=j_":"_CompTipInfo_"("_CompFreq_");"  //_CompFactor_"-"
   ..e  s CompTipStrs=CompTipStrs_"     "_j_":"_CompTipInfo_"("_CompFreq_")"  //_CompFactor_"-"_
   ..s j=j+1
   
   i (EpisodeID=223)&(ItemId=13) b ;002
   i TipStrs'="" s ExecStatus="A"
   e  s ExecStatus="N"
   
   i CompTipStrs'="" s ExecStatus="D"
   
   s a=##class(User.DHCNurPlanRecParent).%OpenId(par)
   
   s OldStatus=a.RPStatus
   
   ;i OldStatus'="E" s a.RPStatus=ExecStatus
   i (OldStatus'="E")&&(OldStatus'="U") s a.RPStatus=ExecStatus
   //s a.RPStatus=ExecStatus
   s a.RPTriggerDesc=TipStrs
   s a.RPCompleteDesc=CompTipStrs
   s a.RPRecDate=+$h
   s a.RPRecTime=$p($h,",",2)
   s a.RPRecUser=User
   
   d a.%Save()
   q a.%Id()
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 病区所有病人生成护理计划,插入到护理计划表中
/// Table：
/// Input：LocID:科室ID 
/// Return：0：成功,1：失败,有错误
/// w ##class(web.DHCNurPlan).MakeLocNurPlan()
ClassMethod MakeLocNurPlan(LocID As %String)
{
	s errflag=0
		
	s LocType=$p($g(^CTLOC(LocID)),"^",13)
	i LocType="W" d
	.s WardID=$o(^PAWARD(0,"WARD_LocationDR",LocID,""))
	
	q:$g(WardID)="" ""
	
	s curRoomId=0 f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s rtnstr=..MakeSinglePersonNurPlan(EpisodeID)
	..i rtnstr=1 s errflag=1
   
    q errflag
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 批量生成全院所有病区的病人的护理计划,插入到护理计划表中,要做任务
/// Table：
/// Input：
/// Return：0:成功,1：失败 
/// w ##class(web.DHCNurPlan).MakeAllNurPlan()
ClassMethod MakeAllNurPlan()
{
	s ^pstmp("MakeAllNurPlan")=""
	s errflag=0
	s rs=##class(%ResultSet).%New("web.DHCNurPlanItemMast:FindLocList")
	d rs.Execute()
	while(rs.Next()){
		s LocId=rs.GetDataByName("rw")
		s Loccode=rs.GetDataByName("code")
		s Locdesc=rs.GetDataByName("desc")
		s Loctyp=rs.GetDataByName("loctyp")
		continue:(Loctyp'="W")
		
		s rtnstr=..MakeLocNurPlan(LocId)
		i rtnstr=1 s errflag=1
	}
	q errflag
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 更改计划状态,执行计划或撤销执行
/// Table：
/// Input：RecID:记录ID,StatusCode:状态Code,User:更新人
/// Return：0 
/// w ##class(web.DHCNurPlan).UpdatePlanStatus("75||1","D")
ClassMethod UpdatePlanStatus(RecID As %String, StatusCode As %String, User As %String)
{
	q:RecID="" ""
	
	
   s a=##class(User.DHCNurPlanRecParent).%OpenId(RecID)

   s OldStatus=a.RPStatus
   
   i (OldStatus="E")!(OldStatus="D")&(StatusCode="E") q "该记录已执行,不能再执行!"
   i (OldStatus="N")&(StatusCode="U") q "该记录无计划,不能撤销!"
   i (OldStatus="A")!(OldStatus="U")&(StatusCode="U") q "该记录待执行或已撤销,不能再撤销!"
   s ^TT(11)=StatusCode
   s a.RPStatus=StatusCode
   s a.RPRecDate=+$h
   s a.RPRecTime=$p($h,",",2)
   s a.RPRecUser=User
   
   d a.%Save()
   
   s RecLog=##class(User.DHCNurPlanRecLog).%New()

   s RecLog.RLParRef=##class(User.DHCNurPlanRecParent).%OpenId(RecID)
   s ^TT(22)=StatusCode
   s RecLog.RLStatus=StatusCode
   s RecLog.RLUpdateDate=+$h
   s RecLog.RLUpdateTime=$p($h,",",2)
   s RecLog.RLUpdateUser=User
   d RecLog.%Save()
   q RecLog.%Id()
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 获取病人列表,Tree形式
/// Table：
/// Input：ctlocDr:科室ID,adm:就诊号
/// Return：病人列表格式串 
/// w ##class(web.DHCNurPlan).GetTree()
ClassMethod GetTree(ctlocDr As %String, adm As %String = "") As %String
{
	s rtnStr=""
	s rtnHead="[{"_"""id"""_":"_"""totalward"""_","_"""text"""_":"_"""全病区"""_","_"""children"""_":[{"_"""id"""_":"_"""allbeds"""_","_"""text"""_":"_"""床位"""
	s rtnEnd="}]}]"
	q:ctlocDr="" ""
	s WardID=$o(^PAWARD(0,"WARD_LocationDR",ctlocDr,""))
	q:WardID="" ""
	s curRoomId="" f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..i pavisit'="A" q
	..s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	..s patRegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	..s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)  
    ..s sex=$p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..i bedSub'="" d
	...s curWardId=$P(bedSub,"||",1)
	...s curBedSub=$P(bedSub,"||",2)
	...s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
	..i $g(bedCode)="" s bedCode="等候区"
	..i rtnStr="" s rtnStr=","_"""children"""_":[{"_"""id"""_":"_EpisodeID_","_"""text"""_":"_""""_$g(bedCode)_" "_patName_""""_","_"""iconCls"""_":"_"""icon-reload"""_"}"
	..e  s rtnStr=rtnStr_",{"_"""id"""_":"_EpisodeID_","_"""text"""_":"_""""_bedCode_" "_patName_""""_","_"""iconCls"""_":"_"""icon-reload"""_"}"
    i rtnStr'="" s rtnStr=rtnHead_rtnStr_"]"_rtnEnd
    
   q rtnStr
}

/// Creator: panshuai
/// CreatDate: 2015-01-12
/// Description: 获取病人今日需测体温时间点
/// Table：
/// Input：EpisodeID:病人就诊ID StaDate:开始日期 EndDate:结束日期
/// Return：
/// w ##class(web.DHCNurPlan).GetNeedMeasureTemp(14,"","")
ClassMethod GetNeedMeasureTemp(EpisodeID As %String, StaDate As %String, StaTim As %String)
{
	q:EpisodeID="" ""
	i StaDate="" s StaDate=+$h
	q ""
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, Sdesc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	
    s rw="" f  s rw=$O(^CTLOC(rw)) q:rw=""  d
    .s code=$P(^CTLOC(rw),"^")
    .s desc=$P(^CTLOC(rw),"^",2)
    .q:desc=""
    .s loctyp=$P(^CTLOC(rw),"^",13)
    .q:loctyp'="W"
    .q:(Sdesc'="")&(desc'[$$ALPHAUP^SSUTIL4(Sdesc))
 	.Do Output
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Output
	set Data=$lb(rw,code,desc,loctyp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocListExecute ]
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

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query FindLocList(Sdesc As %String = "") As %Query(ROWSPEC = "rw:%String,code:%String,desc:%String,loctyp:%String")
{
}

}
