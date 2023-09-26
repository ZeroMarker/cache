/// Description:  套餐限额管理
/// Created by wangguoying
Class web.DHCPE.SetsPreTemplate Extends %RegisteredObject
{

/// Description:设置默认时间段，修改程序后需要运行一遍
/// Input:   
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-07-16
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).SetPreTimeTemplate()
ClassMethod SetPreTimeTemplate()
{
	// 体检预约时段
	s ^DHCPELocPreTimeTemplate(304,1)="08:00:01-08:30:00"
    s ^DHCPELocPreTimeTemplate(304,3)="08:30:01-09:00:00"
    s ^DHCPELocPreTimeTemplate(304,4)="10:00:01-10:30:00"    
    q "Over"
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.SetsPreTemplate","SerchPreNum","",340)
Query SerchPreNum(OrdSetsId As %String, LocID As %String = "") As websys.Query(ROWSPEC = "TOrdSetsId:%String,TOrdSetsDesc:%String:套餐,NUM1:%String:周一,NUM2:%String:周二,NUM3:%String:周三,NUM4:%String:周四,NUM5:%String:周五,NUM6:%String:周六,NUM0:%String:周日")
{
}

ClassMethod SerchPreNumExecute(ByRef qHandle As %Binary, OrdSetsId As %String, LocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i LocID=""
 	{
		s:$D(%session) LocID=%session.Get("LOGON.CTLOCID")
		s:LocID="" LocID=304
 	}
 	i (OrdSetsId'="")&&('$D(^User.DHCPEOrdSetsPreTemplateI("SetsLocWeekIndex",OrdSetsId,LocID)))
 	{
	 	Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	i OrdSetsId'=""
 	{
	 	s setsId = OrdSetsId
	 	s setsDesc = $P(^ARCOS(OrdSetsId),"^",2)
	 	s num1=..GetTemplateNum(OrdSetsId,LocID,1)
 		s num2=..GetTemplateNum(OrdSetsId,LocID,2)
 		s num3=..GetTemplateNum(OrdSetsId,LocID,3)
 		s num4=..GetTemplateNum(OrdSetsId,LocID,4)
 		s num5=..GetTemplateNum(OrdSetsId,LocID,5)
 		s num6=..GetTemplateNum(OrdSetsId,LocID,6)
 		s num0=..GetTemplateNum(OrdSetsId,LocID,0)
 		d FindBuild	
 	}else{
 		s setsId = ""
 		f  s setsId = $O(^User.DHCPEOrdSetsPreTemplateI("SetsLocWeekIndex",setsId)) q:setsId=""  d
 		.s setsDesc = $P(^ARCOS(setsId),"^",2)
	 	.s num1=..GetTemplateNum(setsId,LocID,1)
 		.s num2=..GetTemplateNum(setsId,LocID,2)
 		.s num3=..GetTemplateNum(setsId,LocID,3)
 		.s num4=..GetTemplateNum(setsId,LocID,4)
 		.s num5=..GetTemplateNum(setsId,LocID,5)
 		.s num6=..GetTemplateNum(setsId,LocID,6)
 		.s num0=..GetTemplateNum(setsId,LocID,0)
 		.d FindBuild	
 	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(setsId,setsDesc,num1,num2,num3,num4,num5,num6,num0)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.SetsPreTemplate","SerchTimeInfo","T","17")
Query SerchTimeInfo(Type As %String = "", ParRef As %String = "") As websys.Query(ROWSPEC = "TParRef:%String,TID:%String,TStartTime:%String,TEndTime:%String,TNum:%String,THadNum:%String")
{
}

ClassMethod SerchTimeInfoExecute(ByRef qHandle As %Binary, Type As %String = "", ParRef As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Sub=0
 	s LocID=""
 	i ParRef'=""
 	{
	 	s:Type="T" LocID = $lg(^User.DHCPEOrdSetsPreTemplateD(ParRef),3)
	 	s:Type="M" LocID = $lg(^User.DHCPEOrdSetsPreManagerD(ParRef),3)
 	}
 	i LocID=""
 	{
 		s:$D(%session) LocID=%session.Get("LOGON.CTLOCID")
		s:LocID="" LocID=304
 	}
 	i Type="T" do
 	.i (ParRef'="")&&($D(^User.DHCPEOrdSetsPreTemplateD(ParRef,"OSPTTime")))  d
 	..f  s Sub=$O(^User.DHCPEOrdSetsPreTemplateD(ParRef,"OSPTTime",Sub)) q:Sub=""  d
 	...s ID=ParRef_"||"_Sub
 	...s ListInfo=^User.DHCPEOrdSetsPreTemplateD(ParRef,"OSPTTime",Sub)
	...d OneBuild
	.e  d
	..d SetDefaultTime
	
	i Type="M" do
 	.i (ParRef'="")&&($D(^User.DHCPEOrdSetsPreManagerD(ParRef,"OSPMTime")))  d
 	..f  s Sub=$O(^User.DHCPEOrdSetsPreManagerD(ParRef,"OSPMTime",Sub)) q:Sub=""  d
 	...s ID=ParRef_"||"_Sub
 	...s ListInfo=^User.DHCPEOrdSetsPreManagerD(ParRef,"OSPMTime",Sub)
	...d OneBuild
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneBuild
	s StartTime=$LG(ListInfo,2)
	//s StartTime=$ZT(StartTime)
	s StartTime=##class(websys.Conversions).TimeLogicalToHtml(StartTime)
	s EndTime=$LG(ListInfo,3)
	//s EndTime=$ZT(EndTime)
	s EndTime=##class(websys.Conversions).TimeLogicalToHtml(EndTime)
	s Num=$LG(ListInfo,4)
	s HadNum = 0 
	
	
	d FindBuild
	q
SetDefaultTime
	s HadNum = 0 
	s id = ""
	f  s id = $O(^DHCPELocPreTimeTemplate(LocID,id))  q:id=""  d
	.s StartTime = $P(^DHCPELocPreTimeTemplate(LocID,id),"-",1)
	.s EndTime = $P(^DHCPELocPreTimeTemplate(LocID,id),"-",2)
	.s Num=0
	.s ID=""
	.d FindBuild
	q
FindBuild      
	set Data=$lb(ParRef,ID,StartTime,EndTime,Num,HadNum)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description:得到模板ID
/// Input:   
/// 				OrdSetsID: 套餐ID
/// 				LocID：科室ID
/// 				WeekNum：星期
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-07-14
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).GetTemplateID(1)
ClassMethod GetTemplateID(OrdSetsID, LocID, WeekNum)
{
	q $O(^User.DHCPEOrdSetsPreTemplateI("SetsLocWeekIndex",OrdSetsID,LocID,WeekNum,""))
}

/// Description:得到模板数量
/// Input:   
/// 				OrdSetsID: 套餐ID
/// 				LocID：科室ID
/// 				WeekNum：星期
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-07-14
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).GetTemplateNum(1)
ClassMethod GetTemplateNum(OrdSetsID, LocID, WeekNum)
{
	s id = ..GetTemplateID(OrdSetsID,LocID,WeekNum)
	q:id="" 0
	q $lg(^User.DHCPEOrdSetsPreTemplateD(id),4)
}

/// Description:新增套餐
/// Input:   
/// 				OrdSetsID: 套餐ID
/// 				LocID：科室ID
/// Return: 0  成功  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2021-07-16
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).GetTemplateNum(1)
ClassMethod AddOrdSets(OrdSetsID, LocID)
{
	q:$D(^User.DHCPEOrdSetsPreTemplateI("SetsLocWeekIndex",OrdSetsID,LocID)) "-1^模板中已存在该套餐"
	TS
	s ret = 0
	f i=0:1:6  q:ret'=0  d
	.s values = OrdSetsID_"^"_LocID_"^0^"_i
	.s properties = "OSPTOrdSets^OSPTLoc^OSPTNum^OSPTWeekNum"
	.s save = ##class(User.DHCPEOrdSetsPreTemplate).SaveData("",values,properties)
	.i +save<0  s ret=save
	i +ret<0 tro 	
	TC
	q ret
}

/// Description:删除套餐
/// Input:   
/// 				OrdSetsIDs: 套餐ID^
/// 				LocID：科室ID
/// Return: 0  成功  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2021-07-20
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).DeleteOrdSets(1)
ClassMethod DeleteOrdSets(OrdSetsIDs, LocID)
{
	TS
	s ret = 0
	f i=1:1:$L(OrdSetsIDs,"^")  q:ret'=0  d
	.s sets = $p(OrdSetsIDs,"^",i)
	.q:sets=""
	.q:'$D(^User.DHCPEOrdSetsPreTemplateI("SetsLocWeekIndex",sets,LocID))
	.f k=0:1:6  q:ret'=0  d
	..s id = ..GetTemplateID(sets,LocID,k)
	..s ret = ##class(User.DHCPEOrdSetsPreTemplate).Delete(id)
	..i +ret=0  s ret=0
	i +ret<0 tro 	
	TC
	q ret
}

/// Description:删除时间段
/// Input:   
/// 				Type: T：模板 M：限额管理
/// 				ID：
/// Return: 0  成功  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2021-07-16
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).DeleteTimeInfo(1)
ClassMethod DeleteTimeInfo(Type, ID)
{
	i Type="M" d
	.&SQL(Delete From Sqluser.DHC_PE_PreTimeManager where ID=:ID)
	i Type="T" d
	.&SQL(Delete From Sqluser.DHC_PE_OSPreTimeTemplate where ID=:ID)
	q SQLCODE
}

/// Descript:更新时间段  
/// Input:
/// 			ParRef ：父表ID
/// 			TotalNum : 模板总数量
/// 			Info : 时间段ID,开始时间,结束时间,数量^
/// Return:		0：成功  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2021-07-20
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).UpdateTemplateTimeInfo("10","26","10||1,08:00:01,08:30:00,3^10||2,08:30:01,09:00:00,23^10||3,10:00:01,10:30:00,0")
ClassMethod UpdateTemplateTimeInfo(ParRef, TotalNum, Info)
{
	s ^tmpwgy("TemplateTime")=$lb(ParRef, TotalNum, Info )
	q:ParRef="" "-1^父记录为空 "
	Ts
	s $zt= "UpdateTimeInfoErr"
	s ParRefObj = ##class(User.DHCPEOrdSetsPreTemplate).%OpenId(ParRef)
	
	s ParRefObj.OSPTNum = TotalNum
	
	s sc = ParRefObj.%Save()
	i $$$ISERR(sc) tro  q "-1^"_$System.Status.GetErrorText(sc)
	
	s ParRef = ParRefObj.%Id()
	
	s err=""
	f i=1:1:$L(Info,"^")  q:err'=""  d
	.s info = $p(Info,"^",i)
	.s ID = $P(info,",",1)
	.s obj=""
	.i ID="" d
	..s obj=##class(User.DHCPEOSPreTimeTemplate).%New()
	..d obj.OSPTTParRefSetObjectId(ParRef)
	.e  d
	..s obj=##class(User.DHCPEOSPreTimeTemplate).%OpenId(ID)
	.s obj.OSPTTStartTime= $ZTH($P(info,",",2))
	.s obj.OSPTTEndTime=$ZTH($P(info,",",3))
	.s obj.OSPTTNum=$P(info,",",4)
	
	.s sc=obj.%Save()
	.i $$$ISERR(sc) s err="-1^"_$System.Status.GetErrorText(sc)  q
	i err'=""  tro  q err
	TC
	q 0
UpdateTimeInfoErr
	s $zt=""
	tro 
	q "-1^"_$ZE
}

/// Descript:更新时间段  
/// Input:
/// 			ParRef ：父表ID
/// 			TotalNum : 模板总数量
/// 			Info : 时间段ID,开始时间,结束时间,数量^
/// 				ExtStr : 套餐ID^科室ID^日期
/// Return:		0：成功  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2021-07-20
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).UpdateManagerTimeInfo("","23",",08:00:01,08:30:00,23","3458^304^65945")
ClassMethod UpdateManagerTimeInfo(ParRef, TotalNum, Info, ExtStr = "", UserID = "")
{
	s ^tmpwgy("TemplateTime")=$lb(ParRef, TotalNum, Info,ExtStr )
	q:(ParRef="")&&(ExtStr="") "-1^父记录为空 "
	i UserID=""
	{
		s:$D(%session) UserID=%session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	Ts
	s $zt= "UpdateMTimeInfoErr"
	i ParRef = ""
	{
		s ret = ..SaveManager($P(ExtStr,"^",1),$P(ExtStr,"^",2),$P(ExtStr,"^",3),TotalNum)
		i +ret<0  tro q ret
		s ParRef = +ret
	}
	s ParRefObj = ##class(User.DHCPEOrdSetsPreManager).%OpenId(ParRef)
	s hadNum = ..GetPreNumForXH(ParRefObj.OSPMOrdSets.%Id(),ParRefObj.OSPMLoc.%Id(),ParRefObj.OSPMDate)
	i hadNum>TotalNum  Tro  Q "-1^总数量【"_TotalNum_"】不能小于已预约数量【"_hadNum_"】"
	s ParRefObj.OSPMNum = TotalNum
	
	s sc = ParRefObj.%Save()
	i $$$ISERR(sc) tro  q "-1^"_$System.Status.GetErrorText(sc)
	
	s ParRef = ParRefObj.%Id()
	
	s err=""
	f i=1:1:$L(Info,"^")  q:err'=""  d
	.s info = $p(Info,"^",i)
	.s ID = $P(info,",",1)
	.s obj=""
	.i ID="" d
	..s obj=##class(User.DHCPEOSPreTimeManager).%New()
	..d obj.OSPMTParRefSetObjectId(ParRef)
	.e  d
	..s obj=##class(User.DHCPEOSPreTimeManager).%OpenId(ID)
	.s obj.OSPMTStartTime= $ZTH($P(info,",",2))
	.s obj.OSPMTEndTime=$ZTH($P(info,",",3))
	.s obj.OSPMTNum=$P(info,",",4)
	.s obj.OSPMTUpdateDate = +$H
	.s obj.OSPMTUpdateTime = $P($H,",",2)
	.d obj.OSPMTUpdateUserDRSetObjectId(UserID)
	.s sc=obj.%Save()
	.i $$$ISERR(sc) s err="-1^"_$System.Status.GetErrorText(sc)  q
	i err'=""  tro  q err
	TC
	q 0
UpdateMTimeInfoErr
	s $zt=""
	tro 
	q "-1^"_$ZE
}

/// Description:得到号源ID
/// Input:   
/// 				OrdSetsID: 套餐ID
/// 				LocID：科室ID
/// 				Date：+$H
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-07-21
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).GetTemplateID(1)
ClassMethod GetManagerID(OrdSetsID, LocID, Date)
{
	q $O(^User.DHCPEOrdSetsPreManagerI("LocDateSetsIndex",LocID,Date,OrdSetsID,""))
}

/// Description:更新号源信息
/// Input:   
/// 				OrdSetsID: 套餐ID
/// 				LocID：科室ID
/// 				Date：+$H
/// 				Num：数量
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-07-21
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).SaveManager(1)
ClassMethod SaveManager(OrdSetsID, LocID, Date, Num)
{
	s hadNum = ..GetPreNumForXH(OrdSetsID,LocID,Date)
	q:hadNum>Num "-1^数量【"_Num_"】不能少于已预约数量【"_hadNum_"】"
	s id = ..GetManagerID(OrdSetsID, LocID, Date)
	s properties = "OSPMOrdSets^OSPMLoc^OSPMNum^OSPMDate"
	s vals = OrdSetsID_"^"_LocID_"^"_Num_"^"_Date
	q ##class(User.DHCPEOrdSetsPreManager).SaveData(id,vals,properties)
}

/// Description:更新号源时段信息
/// Input:   
/// 				ParRef ：DHC_PE_OrdSetsPreManager
/// Return:
/// Creater:	wangguoying
/// CreateDate:	2021-07-21
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).SaveManager(1)
ClassMethod SaveManagerTime(ParRef, ID, StartTime, EndTime, Num, UserID = "")
{
	q:StartTime>EndTime "-1^开始时间不能大于结束时间"
	i UserID=""
	{
		s:$D(%session) UserID=%session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	s properties = "OSPMTParRef^OSPMTStartTime^OSPMTEndTime^OSPMTNum^OSPMTUpdateDate^OSPMTUpdateTime^OSPMTUpdateUserDR"
	s vals = ParRef_"^"_StartTime_"^"_EndTime_"^"_Num_"^"_+$H_"^"_$P($H,",",2)_"^"_UserID
	q ##class(User.DHCPEOSPreTimeManager).SaveData(ID,vals,properties)
}

/// Description:创建号源时段信息
/// Input:   
/// 				ManagerID ：DHC_PE_OrdSetsPreManager
/// 				TemplateID : DHC_PE_OrdSetsPreTemplate
/// Return:     0：成功  非0^失败
/// Creater:	wangguoying
/// CreateDate:	2021-07-21
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).SaveManager(1)
ClassMethod CreateManagerTime(ManagerID, TemplateID, UserID = "")
{
	//先判断  时段是否已使用，已使用的不能使用模板批量创建
	s templateNum = $LG(^User.DHCPEOrdSetsPreManagerD(ManagerID),4)
	s setsId = $LG(^User.DHCPEOrdSetsPreManagerD(ManagerID),2)
	s locId = $LG(^User.DHCPEOrdSetsPreManagerD(ManagerID),3)
	s date = $LG(^User.DHCPEOrdSetsPreManagerD(ManagerID),5)
	s hadNum = ..GetPreNumForXH(setsId,locId,date)
	q:hadNum>templateNum "-1^【"_$zd(date,3)_"】模板总数量【"_templateNum_"】少于已预约数量【"_hadNum_"】,创建失败"
	&sql(Delete From Sqluser.DHC_PE_OSPreTimeManager where OSPMTParRef=:ManagerID)
	q:(SQLCODE'=0)&&(SQLCODE'=100) "-1^"_"【"_SQLCODE_"】"_$G(%msg)
	s err = ""
	s Sub=0
	f  s Sub=$O(^User.DHCPEOrdSetsPreTemplateD(TemplateID,"OSPTTime",Sub)) q:(Sub="")||(err'="")  d
 	.s ID=TemplateID_"||"_Sub
 	.s ListInfo=^User.DHCPEOrdSetsPreTemplateD(TemplateID,"OSPTTime",Sub)
 	.s ret = ..SaveManagerTime(ManagerID,"",$LG(ListInfo,2),$LG(ListInfo,3),$LG(ListInfo,4),UserID)
 	.i +ret<0 s err = ret 
 	q:err'="" err
 	q 0
}

/// Description:根据模板创建号源
/// Input:   
/// 				StartDate：2021-07-21  开始日期
/// 				EndDate：2021-07-21  	结束日期
/// 				OrdSetIds：套餐ID
/// 				LocID：		科室
/// 				UserID：	操作用户
/// Return: 	0：成功 非0^失败
/// Creater:	wangguoying
/// CreateDate:	2021-07-21
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).CreateRecord("2021-07-22","2021-07-29","3456","304","11849")
ClassMethod CreateRecord(StartDate, EndDate, OrdSetIds, LocID = "", UserID = "")
{
	s ^tmpwgy("CreateRecord")=$lb(StartDate, EndDate, OrdSetIds, LocID, UserID)
	q:(StartDate="")||(EndDate="") "-1^日期都不能为空"
	q:OrdSetIds="" "-1^套餐不能为空 "
	i UserID=""
	{
		s:$D(%session) UserID=%session.Get("LOGON.USERID")
		s:UserID="" UserID=1
	}
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s:OrdSetIds'="" OrdSetIds = "^"_OrdSetIds_"^"
	i LocID=""
 	{
		s:$D(%session) LocID=%session.Get("LOGON.CTLOCID")
		s:LocID="" LocID=304
 	}
	TS
	s $zt = "CreateRecordErr"
	s err=""
	f date=StartDate:1:EndDate  d
	.s week=$ZD(date,10)
	.s setId = ""
	.f  s setId = $o(^User.DHCPEOrdSetsPreTemplateI("SetsLocWeekIndex",setId)) q:(setId="")||(err'="")  d 
	..q:OrdSetIds'[(("^"_setId_"^"))
	..s templateId = ..GetTemplateID(setId,LocID,week)
	..s num = $lg(^User.DHCPEOrdSetsPreTemplateD(templateId),4)
	..q:+num<=0
	..s ret=..SaveManager(setId,LocID,date,num)
	..i +ret<0 s err = ret  q
	..s ret = ..CreateManagerTime(ret,templateId,UserID)
	..i +ret<0 s err = ret  q
	i err'="" Tro  q err
	TC
	q 0
CreateRecordErr
	s $Zt = ""
	Tro
	q "-100^"_$ZE
}

/// Description:获取指定日期所在周的日期范围
/// Input:   
/// 				Date：2021-07-21
/// 				RtnType: HTML Logical
/// Return: 	周一到周天的指定格式
/// Creater:	wangguoying
/// CreateDate:	2021-07-21
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).GetWeekDateRange("2021-07-21")
ClassMethod GetWeekDateRange(Date, RtnType = "HTML")
{
	i Date=""
 	{
	 	s Date = $H
 	}else{
		s Date = ##class(websys.Conversions).DateHtmlToLogical(Date)
 	}
	s week =  $ZD(Date,10)
	s:week=0 week=7
	s week1 = Date-(week-1)
	s week7 = Date+(7-week)
	s ret = ""
	f date=week1:1:week7
	{
		i RtnType = "Logical"
		{
			s:ret'="" ret = ret_"^"_date
			s:ret="" ret = date
		}else{
			s:ret'="" ret = ret_"^"_$ZD(date,3)
			s:ret="" ret = $ZD(date,3)
		}
	}
	q ret
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.SetsPreTemplate","SerchPreManagerNum","2021-07-21",304)
Query SerchPreManagerNum(Date As %String, LocID As %String = "") As websys.Query(ROWSPEC = "TOrdSetsId:%String,TOrdSetsDesc:%String:套餐,NUM1:%String:周一,NUM2:%String:周二,NUM3:%String:周三,NUM4:%String:周四,NUM5:%String:周五,NUM6:%String:周六,NUM0:%String:周日")
{
}

ClassMethod SerchPreManagerNumExecute(ByRef qHandle As %Binary, Date As %String, LocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	i LocID=""
 	{
		s:$D(%session) LocID=%session.Get("LOGON.CTLOCID")
		s:LocID="" LocID=304
 	}
 	i Date=""
 	{
	 	s Date = ##class(websys.Conversions).DateLogicalToHtml(+$H)
 	}
 	s dateStr = ..GetWeekDateRange(Date,"Logical")
 	s setsId = ""
 	f  s setsId = $O(^User.DHCPEOrdSetsPreManagerI("LocSetsDateIndex",LocID,setsId)) q:setsId=""  d
 	.s setsDesc = $P(^ARCOS(setsId),"^",2)
 	.k numList(setsId)
 	.s flag = 0  //套餐在指定时段内 是否有预约记录或这限额信息
 	.f i=1:1:$l(dateStr,"^")  d
 	..s date = $P(dateStr,"^",i)
	..s managerId = $O(^User.DHCPEOrdSetsPreManagerI("LocSetsDateIndex",LocID,setsId,date,""))	
	..s num = 0
	..i managerId'=""  d
	...s num = $lg(^User.DHCPEOrdSetsPreManagerD(managerId),4)
	...s flag = 1
	..s hadNum = ..GetPreNumForXH(setsId,LocID,date)
	..s:hadNum>0 flag=1
	..s numList(setsId,i)=num_"^"_hadNum
	
 	.d:flag=1 ManagerBuild	
 
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ManagerBuild      
	set Data=$lb(setsId,setsDesc,$G(numList(setsId,1)),$G(numList(setsId,2)),$G(numList(setsId,3)),$G(numList(setsId,4)),$G(numList(setsId,5)),$G(numList(setsId,6)),$G(numList(setsId,7)))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

/// Description:统计某天某科室已预约套餐总额  北京协和
/// Input:   
/// 				OrdSetsID：套餐
/// 				Date：逻辑值
/// 				LocID: 科室
/// Return: 	已预约数量
/// Creater:	wangguoying
/// CreateDate:	2021-07-22
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).GetWeekDateRange("2021-07-21")
ClassMethod GetPreNumForXH(OrdSetsID, LocID, Date)
{
	s hadNum = 0
	s time = ""
	f  s time = $O(^DHCPEIADM(0,"AdmDateTime",Date,time))  q:time=""  d
	.s iadm = ""
	.f  s iadm = $O(^DHCPEIADM(0,"AdmDateTime",Date,time,iadm))  q:iadm=""  d
	..s status = $P(^DHCPEIADM(iadm),"^",8)
	..q:status="CACNCELPE"
	..q:(status'="ARRIVED")&&(Date<+$H)
	..s locFlag = ##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",iadm,LocID)
	..q:locFlag=1
	..s piadm = $P(^DHCPEIADM(iadm),"^",4)
	..s ordSetsInfo = ##class(web.DHCPE.Query.IAdmItemStatus).GetArcSetDesc(piadm,"Y")
	..q:ordSetsInfo=""
	..q:("+"_ordSetsInfo_"+")'[("+"_OrdSetsID_"+")
	..s hadNum = hadNum+1
	q hadNum
}

/// Description:获取套餐剩余名额  如果未设置限额，返回9999
/// Input:   
/// 				OrdSetsID：套餐
/// 				Date：逻辑值
/// 				LocID: 科室
/// Return: 	剩余数量
/// Creator:	wangguoying
/// CreateDate:	2021-07-22
/// Debug: w ##class(web.DHCPE.SetsPreTemplate).GetWeekDateRange("2021-07-21")
ClassMethod GetAavilNum(OrdSetsID, LocID, Date)
{
	s managerId = $O(^User.DHCPEOrdSetsPreManagerI("LocSetsDateIndex",LocID,OrdSetsID,Date,""))	
	q:managerId="" 9999
	s mNum = $lg(^User.DHCPEOrdSetsPreManagerD(managerId),4)
	s pNum = ..GetPreNumForXH(OrdSetsID,LocID,Date)
	q mNum-pNum
}

}
