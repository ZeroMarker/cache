Class web.DHCAPPArcDisc Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(web.DHCAPPArcDisc).QueryDisc()
/// 查询打折系数
ClassMethod QueryDisc(rows = 10, page = 1, pointer = "", HospID = "")
{
	
		s ^tempqujian("QueryDisc")=pointer _","_HospID
		s start=(page-1)*rows+1
	    s end=page*rows
	    s count=0
	    w "{""rows"":["
		s disc=""
		f  s disc=$o(^DHCAPARCDIS(disc)) q:disc=""  d
		.q:+disc=0
		.q:'$d(^DHCAPARCDIS(disc))
		.q:$d(^DHCAPARCDIS(disc))=10
		.s arc=$p(^DHCAPARCDIS(disc),"^",1)
		.q:pointer'=arc
		.q:$p(^DHCAPARCDIS(disc),"^",12)'=HospID
		.s PartNum=$p(^DHCAPARCDIS(disc),"^",2)
		.s Discount=$p(^DHCAPARCDIS(disc),"^",3)
		.s:$p(Discount,".")="" Discount=0_Discount
		.s StartDate=$p(^DHCAPARCDIS(disc),"^",4)
		.s EndDate=$p(^DHCAPARCDIS(disc),"^",6)
		.s:EndDate=0 EndDate=""  //sufan  2016年7月11日
		.s UpdUser=$p(^DHCAPARCDIS(disc),"^",8)
		.s UpdDate=$p(^DHCAPARCDIS(disc),"^",9)
		.s UpdTime=$p(^DHCAPARCDIS(disc),"^",10)
		.s count=count+1
		.q:count<start
		.q:count>end
	    .w $case(count,start:"",:",")
	    .s tmpObj=##class(web.DHCAPPJsonObject).%New()
	    .d tmpObj.Put("PartNum",PartNum)
	    .d tmpObj.Put("Discount",Discount)
	    .d tmpObj.Put("ADArcDr",arc)
	    .d tmpObj.Put("StartDate",$case(+StartDate,0:0,:##class(web.DHCAPPCommonUtil).DateLogicalToHtml(StartDate))) //$zd(StartDate,3)
	    .d tmpObj.Put("EndDate",$case(EndDate,"":"",:##class(web.DHCAPPCommonUtil).DateLogicalToHtml(EndDate))) //hxy $zd(EndDate,3)  //sufan  2016年7月11日
	    .d tmpObj.Put("UpdDate",$case(+UpdDate,0:0,:##class(web.DHCAPPCommonUtil).DateLogicalToHtml(UpdDate))) //$zd(UpdDate,3)
	    .d tmpObj.Put("UpdTime",$case(+UpdTime,0:0,:..%ZT(UpdTime,3)))
	    .d tmpObj.Put("UpdUser",$p(^SSU("SSUSR",UpdUser),"^",2))
	    .d tmpObj.Put("OutFlag",$p(^DHCAPARCDIS(disc),"^",11))
	    .d tmpObj.Put("ID",disc)
		.w tmpObj.Json()
		w "],""total"":"_count_"}"
		q ""
}

// 保存打折系数

// w ##class(web.DHCAPPArcDisc).saveOrUpdate("0^9461||1^123^123^2016-05-20^2016-05-19^2^0^0^0")

ClassMethod saveOrUpdate(str, HospID)
{
	 s ID=$p(str,"^",1)
	 s arc=$p(str,"^",2)
	 s PartNum=$p(str,"^",3)
	 s Discount=$p(str,"^",4)
	 s TarStart=$p(str,"^",5)
	 s TarEnd=$p(str,"^",6)
	 s OutFlag=$p(str,"^",7)
	 i +ID=0 d
	 .s obj=##class(User.DHCAppArcDisc).%New()
	 e  d
	 .s obj=##class(User.DHCAppArcDisc).%OpenId(ID)
	 .d obj.%Reload()
	 s obj.ADArcDr=##class(User.ARCItmMast).%OpenId(arc)
	 s obj.ADDiscount=Discount
	 s obj.ADPartNum=PartNum
	 s obj.ADStartDate=$case(+TarStart,0:0,:##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarStart)) //hxy $zdh(TarStart,3)
	 s obj.ADEndDate=$case(+TarEnd,0:0,:##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarEnd)) // $zdh(TarEnd,3)
	 s obj.ADUpdDate=..%SysDate()
	 s obj.ADUpdTime=..%SysTime()
	 s obj.ADUpdUserDr=##class(User.SSUser).%OpenId(%session.Get("LOGON.USERID"))
	 s obj.ADHospital=##class(User.CTHospital).%OpenId(HospID)
	 s obj.ADOutFlag=OutFlag
	 s sc=obj.%Save()
	 i $$$ISERR(sc) q -2
	 q 0
}

// d ##class(web.DHCAPPArcDisc).save()

ClassMethod save(params, HospID)
{
	s $Zt="Err"
  	TStart
  	s ret=0
  	s len=$l(params,"$$")
  	for i=1:1:len d
  	.q:ret<0
  	.s str=$p(params,"$$",i)
  	.;s ret=..CompareFlagandPartnum(str)    // 判断某保存类型下部位数是否冲突
  	.;q:ret'=0
  	.s ret=..CompareTime(str)  //结束时间是否大于开始时间
	.q:ret'=0
	.s ret=..GetIsItmDisc(str,HospID) /// 检查当前是否存在打折系数比待保存系数小的记录
	.Q:ret'=0
  	.s ret=..saveOrUpdate(str,HospID)
	i ret<0 TRollback
	TCOMMIT
	q ret
Err
	TRollback
	q ret
}

/// Creator : sufan 
/// Date    : 2017-4-13
/// Descript: 判断保存类型和部位数
/// Reason  : 当存在结束日期时，不能重复保存
/// Others  ：w ##class(web.DHCAPPArcDisc)。PromptData("0^9058||1^2^1^2017-01-17^^0^0^0^0")
ClassMethod PromptData(params)
{
  	s ret=0
  	s pid=##Class(web.DHCAPPExaRepCom).NewPid()	 
  	s len=$l(params,"&&")
  	for i=1:1:len d
  	.s str=$p(params,"&&",i)
  	.s ret=..CompareFlagandPartnum(str)    // 判断某保存类型下部位数是否冲突
  	.i ret'=0 d
  	..s ^TempData("DHCST",pid,i)=i_"&"_ret	// 将重复数据存如临时global
  	i ('$d(^TempData("DHCST"))) q 0	// 判断是否存在异常数据
  	else  d
  	.s id="",Datalist=""
  	.for  s id=$o(^TempData("DHCST",pid,id)) q:id=""  d			// 取异常值和异常值的顺序号
  	..s errdata=$p(^TempData("DHCST",pid,id),"&",2)
  	..s tmpstr=id_"!"_errdata
  	..i Datalist=""  s Datalist=tmpstr
  	..e  s Datalist=Datalist_"&"_tmpstr				// 将异常值拼串
  	k ^TempData("DHCST",pid)
	q Datalist
}

/// Creator : sufan 
/// Date    : 2017-1-17
/// Descript: 判断保存类型和部位数
/// Reason  : 当存在结束日期时，不能重复保存
/// Others  ：w ##class(web.DHCAPPArcDisc).CompareFlagandPartnum("0^9058||1^2^1^2017-01-17^^0^0^0^0")
ClassMethod CompareFlagandPartnum(str)
{
	s ID=$p(str,"^",1)
	s arc=$p(str,"^",2)
	s PartNum=$p(str,"^",3)
	s OutFlag=$p(str,"^",7)
	s HospID=$p(str,"^",8)
	s ret=0
	s IPartnum="",OPartnum="",ALLPartnum=""
	if +ID=0
	{
		s Flag=""
		for  s Flag=$o(^DHCAPARCDIS(0,"Arc",arc,Flag))  q:Flag=""  d
		.s TarStart=""
		.for  s TarStart=$o(^DHCAPARCDIS(0,"Arc",arc,Flag,TarStart))  q:TarStart=""  d
		..s dddDisID=""
		..for  s dddDisID=$o(^DHCAPARCDIS(0,"Arc",arc,Flag,TarStart,dddDisID)) q:dddDisID=""  d
		...s Partnum=$p(^DHCAPARCDIS(dddDisID),"^",2)
		...q:($p(^DHCAPARCDIS(dddDisID),"^",12)'=HospID)
		...if (Flag=0) d
		....s OPartnum=OPartnum_"^"_Partnum
		...else  if (Flag=1) d
		....s IPartnum=IPartnum_"^"_Partnum
		...else  if (Flag=2) d
		....s ALLPartnum=ALLPartnum_"^"_Partnum
		if (OutFlag=0)&&($f(OPartnum,PartNum)>0)  s ret=-3
		if (OutFlag=1)&&($f(IPartnum,PartNum)>0)  s ret=-3
		if (OutFlag=2)&&($f(ALLPartnum,PartNum)>0)  s ret=-3
		if ((OutFlag=0)||(OutFlag=1))&&($f(ALLPartnum,PartNum)>0)  s ret=-3
		if (OutFlag=2)&&(($f(OPartnum,PartNum)>0)||($f(IPartnum,PartNum)>0))  s ret=-3
	}
	else { s ret=0}
	q ret
}

/// d ##class(web.DHCAPPArcDisc).listOutFlag()
ClassMethod listOutFlag()
{
  
  s jsonObj=##class(web.DHCAPPJsonObject).%New()
  s listObj=##class(%ListOfObjects).%New()
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","0").Put("text","门诊"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","1").Put("text","住院"))
  d listObj.Insert(##class(web.DHCAPPJsonObject).%New().Put("value","2").Put("text","全部"))
  w jsonObj.ListToJson(listObj)	
  q ""
}

/// Creator:     qunianpeng
/// CreateDate:  2016-06-29
/// Description: 检查医嘱项与收费项关联[检查结束时间是否大于开始时间]
/// Table:		 DHC_AppArcDisc
/// Return: 	 是 0,否 非0
/// Others:		 w ##class(web.DHCAPPArcDisc).CompareTime("0^9058||1^1^1^2016-06-29^2016-06-28^0^0^0^0")
ClassMethod CompareTime(str)
{
	
	s TarStart=$p(str,"^",5)
	s TarEnd=$p(str,"^",6)
	s flag=0	
	s:TarStart'="" TarStart=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarStart) //hxy $zdh(TarStart,3)
	s:(TarEnd'="")&(TarEnd'=0) TarEnd=##class(web.DHCAPPCommonUtil).DateHtmlToLogical(TarEnd) //hxy 2017-03-02 $zdh(TarEnd,3)
	s:(TarEnd>0)&(TarStart>TarEnd) flag=-11
	
	q flag
}

/// Creator:    bianshuai
/// CreateDate: 2017-02-25
/// Descript:   检查当前是否存在打折系数比待保存系数小的记录
/// Input:      itmmastid-医嘱项、DiscType-类型、PartNum-部位数、Disc-系数
/// Output:     0 - 不存在、1 - 存在
/// w ##Class(web.DHCAPPArcDisc).GetIsItmDisc("3844||1","0","3","0.95")
ClassMethod GetIsItmDisc(mListData As %String, HospID As %String) As %String
{
	n (mListData,HospID)
	
	s QuitFlag=0
	s arcimid=$p(mListData,"^",2)   /// itmmastid-医嘱项
	s DiscType=$p(mListData,"^",7)  /// DiscType-类型
	Q:$p(mListData,"^",6)'="" 0
	s PartNum=$p(mListData,"^",3)   /// PartNum-部位数
	s Disc=$p(mListData,"^",4)      /// Disc-系数
	s TmpDiscType=$Case(DiscType,"0":"2^0","1":"2^1",:"2^1^0")
	F i=1:1:$L(TmpDiscType,"^") Q:QuitFlag=1  D
	.s DiscType=$p(TmpDiscType,"^",i)
	.s QuitFlag=##Class(web.DHCAPPArcDisc).CheckItmDisc(arcimid, DiscType, PartNum, Disc,HospID )
	.
	i QuitFlag'=0 s QuitFlag="-101"
	Q QuitFlag
}

/// Creator:    bianshuai
/// CreateDate: 2017-02-25
/// Descript:   检查当前是否存在打折系数比待保存系数小的记录
/// Input:      itmmastid-医嘱项、DiscType-类型、PartNum-部位数、Disc-系数
/// Output:     0 - 不存在、1 - 存在
/// W ##Class(web.DHCAPPArcDisc).CheckItmDisc("","","","")
ClassMethod CheckItmDisc(itmmastid As %String, DiscType As %String, PartNum As %String, Disc As %String, HospID As %String) As %String
{
	n (itmmastid, DiscType, PartNum, Disc, HospID)
	s StartDate="",QuitFlag=0
	F  s StartDate=$o(^DHCAPARCDIS(0,"Arc",itmmastid,DiscType,StartDate)) Q:(StartDate="")||(QuitFlag=1)  D
	.//Q:StartDate>+$H
	.s LkDiscID=""
	.F  s LkDiscID=$o(^DHCAPARCDIS(0,"Arc",itmmastid,DiscType,StartDate,LkDiscID)) Q:(LkDiscID="")||(QuitFlag=1)  D
	..s EndDate=$p(^DHCAPARCDIS(LkDiscID),"^",6) /// 结束日期
	..Q:(+EndDate'=0)&&(EndDate<+$h)
	..s LkPartNum=$p(^DHCAPARCDIS(LkDiscID),"^",2)   /// 部位数
	..Q:LkPartNum>PartNum
	..s LinkDisc=$p(^DHCAPARCDIS(LkDiscID),"^",3)    /// 系数
	..Q:+LinkDisc=0
	..Q:LinkDisc>Disc
	..q:HospID'=$p(^DHCAPARCDIS(LkDiscID),"^",12)
	..s QuitFlag=1
	.
	Q QuitFlag
}

}
