Import sqluser

/// Descript:单号生成规则维护
Class web.DHCSTMHUI.Common.DHCStkSysCounter Extends (%RegisteredObject, web.DHCSTMHUI.StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:   保存/更新单号生成规则
/// Creator:    wangjiabin
/// CreateDate: 2012-06-06
/// Table:		DHC_StkSysCounter
/// Input:		数据串Json:(rowid,应用程序id,医院标志,科室标志,类组标志,单号前缀,年,月,日,序号长度,是否按科室)
/// Output:     
/// Return:		RtnObj.Json()
ClassMethod Save(Params As %String, Main As %String = "") As %Library.String
{
	n (Params,Main)
	s $ZT=..sssError()
	s RtnObj=##class(web.DHCSTMHUI.RtnObj).%New()
	s PJObj1=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc1=PJObj1.%FromJSON(Main)
	i Sc1'=0 q RtnObj.Err(-1,"","入参解析失败!").Json()
	s gHospId=PJObj1.%Get("gHospId")
	s pHospId=PJObj1.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","入参解析失败!").Json()
	ts
	While(RtnObj.success=0){
		s RowObj=PJObj.%Pop()
		q:RowObj=""
		
		s RowId=RowObj.%Get("RowId")
		s AppId=RowObj.%Get("AppId")
		s Hosp=RowObj.%Get("Hosp")
		s Loc=RowObj.%Get("Loc")
		s CatGrp=RowObj.%Get("CatGrp")
		s Prefix=RowObj.%Get("Prefix")
		s Year=RowObj.%Get("Year")
		s Month=RowObj.%Get("Month")
		s Day=RowObj.%Get("Day")
		s NoLength=RowObj.%Get("NoLength")
		s CountByLoc=RowObj.%Get("CountByLoc")
		i CountByLoc="Y",Loc'="Y"  s Loc="Y"	//按科室Count时，"科室"前缀自动设置为"Y"
		i (AppId="") d RtnObj.Err(-2,"","入参错误!","",0)
		continue:RtnObj.success<0
		s Description=$p(^DHCSSA(AppId),"^",2)
		i RowId="" d
		.s Obj=##class(User.DHCStkSysCounter).%New()
		.d Obj.SSCSSAParrefSetObjectId(AppId)
		.s Ch=$o(^DHCSSA(AppId,"SSC",""),-1)+1
		.s Obj.SSCChildSub=Ch
		e  d
		.s Obj=##class(User.DHCStkSysCounter).%OpenId(RowId)
		s Obj.SSCHosp=Hosp
		s Obj.SSCLoc=Loc
		s Obj.SSCCatGrp=CatGrp
		s Obj.SSCPrefix=Prefix
		s Obj.SSCYear=Year
		s Obj.SSCMonth=Month
		s Obj.SSCDay=Day
		s Obj.SSCNoLength=NoLength
		s Obj.SSCCountByLoc=CountByLoc
		s Sc=Obj.%Save()
		i $$$ISERR(Sc) d
		.s Sc=$tr($System.Status.GetErrorText(Sc),$c(13,10,0,9))
		.d RtnObj.Err(-2,RowId,"保存失败:"_Sc)
		continue:RtnObj.success<0
		s:RowId="" RowId=Obj.%Id()
		s ret=##class(web.DHCSTMHUI.MatForBDPData).SaveHOSP("DHC_StkSysCounter",RowId,pHospId)
		i +ret<0 d RtnObj.Err(-5,"",Description_"关联院区失败!")
		continue:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:   查询单号规则信息
/// Creater:    ZhangDongmei
/// CreateDate: 2012-06-06
/// Table:DHC_StkSysCounter
/// Input:库存类型(G,M,O)
/// Output:     
/// Return：RowId^应用程序id^应用程序代码^应用程序描述^医院^科室^类组^
/// 单号前缀^年^月^日^单号长度
/// w ##class(web.DHCSTMHUI.Common.DHCStkSysCounter).SelectAll("M","{""BDPHospital"":""2"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2""}")
ClassMethod SelectAll(StkType As %String = "M", Params)
{
	n (StkType,Params)
	q:StkType="" $$$NullJson
	s Pid=..NewPid()
	k ^TMPDHCSTM(Pid,"SelectSysApp")
	s Count=0
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 $$$NullJson
	s gHospId=PJObj.%Get("gHospId")
	s pHospId=PJObj.%Get("BDPHospital")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(pHospId,gHospId)
	s json=##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s AppId=0,Num=0
	f  s AppId=$o(^DHCSSA(0,"AGTYPE",StkType,AppId)) q:AppId=""  d
	.s AppSortNum=$p(^DHCSSA(AppId),"^",6)
	.s Num=Num+1
	.s Sub=AppSortNum
	.s:Sub="" Sub="*"
	.s ^TMPDHCSTM(Pid,"SelectSysApp",Sub,Num)=AppId
	
	s SysSub=""
	f  s SysSub=$o(^TMPDHCSTM(Pid,"SelectSysApp",SysSub)) q:SysSub=""  d
	.s SysNum=""
	.f  s SysNum=$o(^TMPDHCSTM(Pid,"SelectSysApp",SysSub,SysNum)) q:SysNum=""  d
	..s SysAppId=$p(^TMPDHCSTM(Pid,"SelectSysApp",SysSub,SysNum),"^",1)
	..s SysAppCode=$p(^DHCSSA(SysAppId),"^",1)
	..s SysAppDesc=$p(^DHCSSA(SysAppId),"^",2)
	..s Chl=0,CNum=0
	..f  s Chl=$o(^DHCSSA(SysAppId,"SSC",Chl))  q:Chl=""  d
	...s Rowid=SysAppId_"||"_Chl
	...s ShowDataFlag=##class(web.DHCSTMHUI.MatForBDPData).GetShowDataFlag("DHC_StkSysCounter",Rowid,pHospId)
	...q:ShowDataFlag'="Y"
	...s Hosp=$p(^DHCSSA(SysAppId,"SSC",Chl),"^",1) 
	...s Loc=$p(^DHCSSA(SysAppId,"SSC",Chl),"^",2)
	...s CatGrp=$p(^DHCSSA(SysAppId,"SSC",Chl),"^",3)
	...s Prefix=$p(^DHCSSA(SysAppId,"SSC",Chl),"^",4)
	...s Year=$p(^DHCSSA(SysAppId,"SSC",Chl),"^",5)
	...s Month=$p(^DHCSSA(SysAppId,"SSC",Chl),"^",6)
	...s Day=$p(^DHCSSA(SysAppId,"SSC",Chl),"^",7)
	...s NoLength=$p(^DHCSSA(SysAppId,"SSC",Chl),"^",8)
	...s CountByLoc=$p(^DHCSSA(SysAppId,"SSC",Chl),"^",15)
	...s Data1=Rowid_"^"_SysAppId_"^"_SysAppCode_"^"_SysAppDesc_"^"_Hosp
	...s Data2=Loc_"^"_CatGrp_"^"_Prefix_"^"_Year_"^"_Month
	...s Data3=Day_"^"_NoLength_"^"_CountByLoc
	...s Data=Data1_"^"_Data2_"^"_Data3
	...s Count=Count+1
	...s CNum=CNum+1
	... 
	...d json.InsertRowData(Data)
	..i CNum=0 d
	...s Rowid=""
	...s Hosp="N"
	...s Loc="N"
	...s CatGrp="N"
	...s Prefix=""
	...s Year="N"
	...s Month="N"
	...s Day="N"
	...s NoLength=""
	...s CountByLoc="N"
	...s Data1=Rowid_"^"_SysAppId_"^"_SysAppCode_"^"_SysAppDesc_"^"_Hosp
	...s Data2=Loc_"^"_CatGrp_"^"_Prefix_"^"_Year_"^"_Month
	...s Data3=Day_"^"_NoLength_"^"_CountByLoc
	...s Data=Data1_"^"_Data2_"^"_Data3
	...s Count=Count+1
	...d json.InsertRowData(Data)
	s TitleStr="RowId^AppId^AppCode^AppDesc^Hosp"
		_"^Loc^CatGrp^Prefix^Year^Month"
		_"^Day^NoLength^CountByLoc"
	d json.getJsonData(TitleStr,Count)
	k json
	q ""
}

/// Description: 更新当前单号
/// Creater:    ZhangDongmei
/// CreateDate: 2012-07-30
/// Input:rowid,当前年份,当前月份,当前日期,当前序号
/// Output:
/// Return:0:成功
ClassMethod UpdateCounterNo(AppName As %String, CurrentYear As %String, CurrentMon As %String, CurrentDay As %String, CurrentNo As %String, HospId = "")
{
	N (AppName,CurrentYear,CurrentMon,CurrentDay,CurrentNo,HospId)
	Q:AppName="" -2
	S AppName=$$ALPHAUP^SSUTIL4(AppName)
	S AppId=$O(^DHCSSA(0,"ACODE",AppName,""))
	Q:AppId="" -2
	
	s Rowid=..GetAppCounterIdhosp(AppName,HospId)
	s Err=0
	&sql(Update DHC_StkSysCounter set SSC_CurrentYear=:CurrentYear,SSC_CurrentMonth=:CurrentMon,
	SSC_CurrentDay=:CurrentDay,SSC_CurrentNo=:CurrentNo where SSC_Rowid=:Rowid)
	i SQLCODE'=0  d
	.s Err=-1
	q Err
}

/// 插入科室数据DHC_StkSysCounterLoc
/// Author:zhwh
/// Date:2014-10-15
/// Arg:
///    SSC - RowId of DHC_StkSysCounter
///    LocId -科室RowId
/// Return:
///   0 - success
///   <0 - 失败
ClassMethod InsertCounterLoc(SSC As %String, LocId As %String) As %String
{
	n (SSC,LocId)
	s d=$zd(+$h,3)
	s currentYear=+$p(d,"-",1)
	s currentMonth=+$p(d,"-",2)
	s crrrentDay=+$p(d,"-",3)
	&sql(insert into dhc_stksyscounterLoc
		(sscloc_ssc_parref,sscloc_ctloc_dr,sscloc_currentyear,sscloc_currentmonth,sscloc_currentday)
		values
		(:SSC,:LocId,:currentYear,:currentMonth,:crrrentDay)
	)
	q SQLCODE
}

/// 插入科室数据DHC_StkSysCounterLoc
/// Author:zhwh
/// Date:2022-02-23
/// Arg:
///    SSC - RowId of DHC_StkSysCounter
///    Info -数据串("L1C2"代表科室1类组2)
/// Return:
///   0 - success
///   <0 - 失败
ClassMethod InsertCounterInfo(SSC As %String, LocId As %String, Info As %String) As %String
{
	n (SSC,LocId,Info)
	s d=$zd(+$h,3)
	s currentYear=+$p(d,"-",1)
	s currentMonth=+$p(d,"-",2)
	s crrrentDay=+$p(d,"-",3)
	&sql(insert into dhc_stksyscounterLoc
		(sscloc_ssc_parref,sscloc_ctloc_dr,SSCLOC_CurrentInfo,sscloc_currentyear,sscloc_currentmonth,sscloc_currentday)
		values
		(:SSC,:LocId,:Info,:currentYear,:currentMonth,:crrrentDay)
	)
	q SQLCODE
}

/// 更新DHC_StkSysCounterLoc
/// Author:zhwh
/// Date:2014-10-15
/// Arg:
///    SSC - RowId of DHC_StkSysCounter
///    Info -数据串("L1C2"代表科室1类组2)
/// Return:
///    当前序号
ClassMethod GetCounterByInfo(SSC As %String, LocId As %String, Info As %String)
{
	n (SSC,LocId,Info,%session)
	s PreNo=""
	&sql(select sscloc_ssc_parref->ssc_ssa_parref->ssa_code,
			sscloc_currentyear,sscloc_currentmonth,sscloc_currentday,sscloc_currentno
		into :AppName,:CurrentYear,:CurrentMon,:CurrentDay,:CurrentNo 
		from dhc_stksyscounterloc
		where sscloc_ssc_parref=:SSC and SSCLOC_CurrentInfo=:Info
	)
	s HospId=..sssHospId(LocId)
	s HospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(HospId,HospId,"Y","DHC_StkSysCounter")
	S AppName=$$ALPHAUP^SSUTIL4(AppName)
	s Rowid=..GetAppCounterIdhosp(AppName,HospId)
	q:Rowid="" ""
	s ssa=+Rowid
	s sscsub=$p(Rowid,"||",2)
	S coustr=^DHCSSA(ssa,"SSC",sscsub)
	
	s YearFlag=$P(coustr,"^",5)
	s MonthFlag=$P(coustr,"^",6)
	s DayFlag=$P(coustr,"^",7)
	S NoLen=+$P(coustr,"^",8)
	s Today=$zd(+$h,3)
	s Year=$p(Today,"-",1)
	s Month=+$p(Today,"-",2)
	s Day=+$p(Today,"-",3)
	;flag=1,表示CurrentNo即为前一个单号
	;flag=0,表示目前没有相应的单号记录，新单号需要从1开始记
	s Flag=1   
	i (YearFlag="Y")&(CurrentYear'=Year)  d
	.s Flag=0
	i (MonthFlag="Y")&(CurrentMon'=Month)  d
	.s Flag=0
	i (DayFlag="Y")&(CurrentDay'=Day)  d
	.s Flag=0
	;
	i Flag=1  d
	.s PreNo=1+CurrentNo
	e  d
	.s PreNo=1
	
	q PreNo
}

/// 更新DHC_StkSysCounterLoc
/// Author:zhwh
/// Date:2014-10-15
/// Arg:
///    SSC - RowId of DHC_StkSysCounter
///    LocId -科室RowId
/// Return:
///    当前序号
ClassMethod GetCounterByLoc(SSC As %String, LocId As %String)
{
	n (SSC,LocId,%session)
	s PreNo=""
	&sql(select sscloc_ssc_parref->ssc_ssa_parref->ssa_code,
			sscloc_currentyear,sscloc_currentmonth,sscloc_currentday,sscloc_currentno
		into :AppName,:CurrentYear,:CurrentMon,:CurrentDay,:CurrentNo 
		from dhc_stksyscounterloc
		where sscloc_ssc_parref=:SSC and sscloc_ctloc_dr=:LocId
	)
	s HospId=..sssHospId(LocId)
	s HospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId(HospId,HospId,"Y","DHC_StkSysCounter")
	S AppName=$$ALPHAUP^SSUTIL4(AppName)
	s Rowid=..GetAppCounterIdhosp(AppName,HospId)
	q:Rowid="" ""
	s ssa=+Rowid
	s sscsub=$p(Rowid,"||",2)
	S coustr=^DHCSSA(ssa,"SSC",sscsub)
	
	s YearFlag=$P(coustr,"^",5)
	s MonthFlag=$P(coustr,"^",6)
	s DayFlag=$P(coustr,"^",7)
	S NoLen=+$P(coustr,"^",8)
	s Today=$zd(+$h,3)
	s Year=$p(Today,"-",1)
	s Month=+$p(Today,"-",2)
	s Day=+$p(Today,"-",3)
	;flag=1,表示CurrentNo即为前一个单号
	;flag=0,表示目前没有相应的单号记录，新单号需要从1开始记
	s Flag=1   
	i (YearFlag="Y")&(CurrentYear'=Year)  d
	.s Flag=0
	i (MonthFlag="Y")&(CurrentMon'=Month)  d
	.s Flag=0
	i (DayFlag="Y")&(CurrentDay'=Day)  d
	.s Flag=0
	;
	i Flag=1  d
	.s PreNo=1+CurrentNo
	e  d
	.s PreNo=1
	
	q PreNo
}

/// 按科室取单号
/// Author:zhwh
/// Date:2014-10-15
/// Arg:
///   AppName - 应用代码
///   LocId - 科室RowId
/// Return:
///    单号字符串
ClassMethod GetAppNoByLoc(AppName As %String, LocId As %String) As %String
{
	n (AppName,LocId)
	s Info="L"_LocId //可以修改为按照科室和类组拆分如"L1C2"
	s ret=##class(web.DHCSTMHUI.Common.AppCommon).Lock(AppName_"NO")
	&sql(select ssc_rowid,ssc_nolength into :SSC,:noLen from dhc_stksyscounter where  ssc_ssa_parref->ssa_code=:AppName)
	i SSC="" d ulk q ""
	s rowid="",ret=0
	&sql(select %id into :rowid from sqluser.dhc_stksyscounterloc 
		where sscloc_ssc_parref=:SSC and SSCLOC_CurrentInfo=:Info)
	s:SQLCODE=100 rowid=""	
	i rowid="" d
	.s ret=..InsertCounterInfo(SSC,LocId,Info)
	i ret'=0 d ulk q ""

	s newNo=..GetCounterByInfo(SSC,LocId,Info)
	i newNo="" d ulk q ""

	///记录新的单号
	s Today=$zd(+$h,3)
	s Year=$p(Today,"-",1)
	s Month=+$p(Today,"-",2)
	s Day=+$p(Today,"-",3)
	&sql(update dhc_stksyscounterloc set sscloc_currentyear=:Year,sscloc_currentmonth=:Month,sscloc_currentday=:Day,
	sscloc_currentno=:newNo where sscloc_ssc_parref=:SSC  and SSCLOC_CurrentInfo=:Info) 
	i SQLCODE'=0 d ulk q "" 
	d ulk
	s newNo=$tr($j(newNo,noLen)," ","0")
	q newNo
ulk
	d ##class(web.DHCSTMHUI.Common.AppCommon).UnLock(AppName_"NO")
	q
}

/// Description: 根据exe名称以及院区取单号id
/// Input:AppName-应用程序名称
/// Output:
/// Return:返回规则字符串 
/// w ##class(web.DHCSTMHUI.Common.DHCStkSysCounter).GetAppCounterIdhosp("DHCSTADJSPM",2)
ClassMethod GetAppCounterIdhosp(AppName, HospId)
{
	N (AppName,HospId)
	Q:AppName="" ""
	S AppName=$$ALPHAUP^SSUTIL4(AppName)
	S ssa=$O(^DHCSSA(0,"ACODE",AppName,""))
	Q:ssa="" ""

	s HospAutFlag=##class(web.DHCSTMHUI.MatForBDPData).GetHospAutFlag()

	s retRowid=""
	i (HospAutFlag="Y")&&(HospId'="") d
	.s tmpsscsub=0,tableName="DHC_StkSysCounter"
	.f  s tmpsscsub=$O(^DHCSSA(ssa,"SSC",tmpsscsub)) q:(tmpsscsub="")!(retRowid'="")  d
	..s Rowid=ssa_"||"_tmpsscsub
	..s BDPMapId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPMapId(tableName,HospId,Rowid)
	..i BDPMapId>0 s retRowid=Rowid
	..q:retRowid'=""
	e  d
	.S Chl=$O(^DHCSSA(ssa,"SSC","0"))
	.Q:Chl=""
	.s retRowid=ssa_"||"_Chl

	q retRowid
}

}
