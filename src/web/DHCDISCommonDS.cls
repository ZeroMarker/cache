/// Creator:    zhouxin
/// CreateDate: 2016-01-24
/// Descript:   配送申请界面需要的公共数据源如，combgrid的数据;日期走配置公共方法;
Class web.DHCDISCommonDS Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Creator:    zhouxin
/// CreateDate: 2016-01-24
/// Descript: combogrid科室数据
/// w ##class(web.DHCDISCommonDS).LocComboGrid()
ClassMethod LocComboGrid(q, page = 1, rows = 10)
{
	n (q,page, rows,%session)	
	s End = page*rows
	s Start=(page-1)*rows+1
	s Count=0
	s q=$ZCONVERT(q,"U")
	s HospID=%session.Get("LOGON.HOSPID")
	 w "{""rows"":["
	s LocId=""
	f  s LocId = $o(^CTLOC(LocId)) q:LocId=""  d
	.s FromDate=$p(^CTLOC(LocId),"^",24)
	.s EndDate=$p(^CTLOC(LocId),"^",25)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s Hosp=$p(^CTLOC(LocId),"^",22)
	.q:Hosp'=HospID
	.s LocDesc = $p(^CTLOC(LocId),"^",2)
	.s LocDesc=$ZCONVERT(LocDesc,"U")
	.q:(q'="")&($f(LocDesc,q)=0)
	.s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",LocId_"^"_LocDesc)
	w "],""total"":"_Count_"}"
	q ""
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-24
/// Descript: combogrid科室项目数据
/// w ##class(web.DHCDISCommonDS).DisLocItmComboGrid("","1","10",1)
ClassMethod DisLocItmComboGrid(q, page = 1, rows = 10, type)
{
	s ^zwq=type
	n (q,page, rows,type,%session)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	s Count=0
	s q=$ZCONVERT(q,"U")
	s HospID=%session.Get("LOGON.HOSPID")
	w "{""rows"":["
	
	s DisItmID=""
	f  s DisItmID=$o(^DHCDISLI(DisItmID)) q:DisItmID=""  d
	.q:DisItmID=0
	.s Hosp=$p(^DHCDISLI(DisItmID),"^",6)
	.q:Hosp'=HospID
	.s Status=$p(^DHCDISLI(DisItmID),"^",5)
	.q:Status'="Y"
	.s DisType=$p(^DHCDISLI(DisItmID),"^",7)
	.q:(type'="")&&(DisType'=type)
	.s code=$p(^DHCDISLI(DisItmID),"^",1)
	.s desc=$p(^DHCDISLI(DisItmID),"^",2)
	.s desc=$ZCONVERT(desc,"U")
	.;取项目维护的科室个数
	.s LocNum=0,LocId=""
	.s ItmLocID=""
	.f  s ItmLocID=$o(^DHCDISLRE(ItmLocID)) q:ItmLocID=""  d
	..q:ItmLocID=0
	..s ParentID=$p(^DHCDISLRE(ItmLocID),"^",1)
	..q:ParentID'=DisItmID
	..s LocNum=LocNum+1
	..s LocId=$p(^DHCDISLRE(ItmLocID),"^",2)
	.q:(q'="")&&($f(desc,q)=0)
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.s tmp=DisItmID_"^"_code_"^"_desc_"^"_LocNum_"^"_LocId
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^code^desc^locnum^locid",tmp)
	w "],""total"":"_Count_"}"
	q ""
	
	
	/*
	s DisLoc=0
	f  s DisLoc = $o(^DHCDISLI(DisLoc)) q:DisLoc=""  d
	.s Hosp=$p(^DHCDISLI(DisLoc),"^",6)
	.q:Hosp'=HospID
	.s status=$p(^DHCDISLI(DisLoc),"^",5)
	.q:status'="Y"
	.s locType=$p(^DHCDISLI(DisLoc),"^",4)
	.q:(type'="")&&(type'=locType)
	.s LocId=$p(^DHCDISLI(DisLoc),"^",3)
	.q:(LocId'="")&&(LocId'=Loc)
	.;q:LocId=""   zhaowuqiang 2017-04-07
	.i LocId'="" s LocDesc = $p(^CTLOC(LocId),"^",2)
	.e  s LocDesc=""
	.s code=$p(^DHCDISLI(DisLoc),"^",1)
	.s desc=$p(^DHCDISLI(DisLoc),"^",2)
	.s desc=$ZCONVERT(desc,"U")
	.q:(q'="")&&($f(desc,q)=0)
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.s tmp=DisLoc_"^"_code_"^"_desc_"^"_LocId_"^"_LocDesc
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^code^desc^loc^locdesc",tmp)
	w "],""total"":"_Count_"}"
	q ""
	*/
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-24
/// Descript: combogrid科室配送人员
/// w ##class(web.DHCDISCommonDS).LocUserComboGrid()
ClassMethod LocUserComboGrid(q, page = 1, rows = 10)
{
	n (q,page, rows,%session)
	s End = page*rows
	s Start=(page-1)*rows+1
	s Count=0
	s q=$ZCONVERT(q,"U")
	w "{""rows"":["
	s su=0
	f  s su = $o(^DHCDISLU(su)) q:su=""  d
	.s status=$p(^DHCDISLU(su),"^",3)
	.q:status'="Y"
	.s id=$p(^DHCDISLU(su),"^",2)
	.s name=$p(^SSU("SSUSR",id),"^",2)
	.s name=$ZCONVERT(name,"U")
	.q:(q'="")&&($f(name,q)=0)
	.s status=$p(^DHCDISLU(su),"^",4)
	.s status=$case(status,1:"空闲",0:"忙碌",:",")
	.s loc=$p(^DHCDISLU(su),"^",1)
	.s locdesc=$p(^CTLOC(+loc),"^",2)
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.s tmp=id_"^"_name_"^"_status_"^"_locdesc
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^name^status^locdesc",tmp)
	w "],""total"":"_Count_"}"
	q ""
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-24
/// Descript: combox科室
/// w ##class(web.DHCDISCommonDS).LocCombo("hx","","")
ClassMethod LocCombo(q = "", HospID = "", DefLoc = "")
{
	n (q,HospID,DefLoc)	
	;s DefLocDesc=$p(^CTLOC(DefLoc),"^",2)
	s Start=1
	s Count=0
	s q=$ZCONVERT(q,"U")
	w "["
	s LocId=""
	f  s LocId = $o(^CTLOC(LocId)) q:LocId=""  d
	.q:LocId=0
	.s FromDate=$p(^CTLOC(LocId),"^",24)
	.s EndDate=$p(^CTLOC(LocId),"^",25)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s Hosp=$p(^CTLOC(LocId),"^",22)
	.q:(HospID'="")&&(Hosp'=HospID)
	.s LocType=$p(^CTLOC(LocId),"^",13)    //科室类型   sufan  2017-12-03
	.q:(LocType'="W")&&(LocType'="EM")
	.s LocNationCode = $p(^CTLOC(LocId),"^",2)
	.s LocContactName = $p(^CTLOC(LocId),"^",43)
	.s LocContactName=$ZCONVERT(LocContactName,"U")
	.s LocDesc = LocNationCode  //LocContactName_"-"_LocNationCode
	.;s LocDesc=$ZCONVERT(LocDesc,"U")
	.q:($f(LocContactName,q)=0)&&($f(LocDesc,q)=0)
	.s Count=Count+1
	.q:Count<Start
	.;q:Count>End
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",LocId_"^"_LocDesc)
	
	w "]"
	q ""
}

/// Creator:    zhaowuqiang
/// CreateDate: 2017-05-12
/// Descript:   配送项目科室
/// Other:      w ##class(web.DHCDISCommonDS).ItmLocCombo("37")
ClassMethod ItmLocCombo(itmid)
{
	n (itmid)
	
	s pid=##class(web.DHCDISRequestCom).getPid()
	k ^TMP("web.DHCDISCommonDS","ItmLoc",pid)
	s End = 20
	s Start=1
	s Count=0
	;s q=$SYSTEM.SQL.ALPHAUP(q)
	;s HospID=%session.Get("LOGON.HOSPID")
	w "["
	s Length=$l(itmid,"^")
	f i=1:1:Length  d
	.s itm=$p(itmid,"^",i)
	.s ItmLocID=""
	.f  s ItmLocID=$o(^DHCDISLRE(ItmLocID)) q:ItmLocID=""  d
	..q:ItmLocID=0
	..s ItmID=$p(^DHCDISLRE(ItmLocID),"^",1)
	..q:ItmID'=itm
	..s LocID=$p(^DHCDISLRE(ItmLocID),"^",2)
	..q:LocID=""
	..s LocDesc=$p(^CTLOC(LocID),"^",2)
	..q:$d(^TMP("web.DHCDISCommonDS","ItmLoc",pid,LocID,LocDesc))
	..s ^TMP("web.DHCDISCommonDS","ItmLoc",pid,LocID,LocDesc)=""
	..s Count=Count+1
	..q:Count<Start
	..q:Count>End
	..w $case(Count,Start:"",:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",LocID_"^"_LocDesc)
	w "]"
	k ^TMP("web.DHCDISCommonDS","ItmLoc")
	
	q ""
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-24
/// Descript: combox中转点
/// w ##class(web.DHCDISCommonDS).NodeLocCombo("MZX")
ClassMethod NodeLocCombo(q = "")
{
	n (q,%session)	
	s End = 10
	s Start=1
	s Count=0
	s q=$ZCONVERT(q,"U")
	s HospID=%session.Get("LOGON.HOSPID")
	w "["
	s node=0
	f  s node = $o(^DHCDISNL(node)) q:node=""  d
	.s name=$p(^DHCDISNL(node),"^",2)
	.s flag=$p(^DHCDISNL(node),"^",3)
	.q:flag'="Y"
	.s LocId=$p(^DHCDISNL(node),"^",4)
	.s Hosp=$p(^CTLOC(LocId),"^",22)
	.q:Hosp'=HospID
	.s name=$ZCONVERT(name,"U")
	.//q:$f(name,q)=0
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",node_"^"_name)
	w "]"
	q ""
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-24
/// Descript: combox中转点
/// w ##class(web.DHCDISCommonDS).TypeAddLocCombo("MZX")
ClassMethod TypeAddLocCombo(q = "")
{
	n (q,%session)	
	s End = 10
	s Start=1
	s Count=0
	s q=$ZCONVERT(q,"U")
	s HospID=%session.Get("LOGON.HOSPID")
	w "["
	s type=0
	f  s type = $o(^DHCDISTA(type)) q:type=""  d
	.s name=$p(^DHCDISTA(type),"^",2)
	.s flag=$p(^DHCDISTA(type),"^",3)
	.q:flag'="Y"
	.s Hosp=$p(^DHCDISTA(type),"^",4)
	.q:Hosp'=HospID
	.s name=$ZCONVERT(name,"U")
	.//q:$f(name,q)=0
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",type_"^"_name)
	w "]"
	q ""
}

/// Creator:    zhouxin
/// CreateDate: 2016-01-24
/// Descript: combox状态  (陪送)
/// w ##class(web.DHCDISCommonDS).StatusCombo()
ClassMethod StatusCombo()
{
	
	n (%session)
	s:$d(%session) HospID=%session.Get("LOGON.HOSPID") 
	s typecode="陪送"
	
	s End = 10
	s Start=1
	s Count=0
	w "["
	s sa=""
	f  s sa = $o(^DHCDISSA(sa)) q:sa=""  d
	.q:+sa=0
	.s tmptype=$p(^DHCDISSA(sa),"^",6)                 //修改   2017-05-15  zhaowuqiang
	.q:tmptype=""
	.s tmptypecode=$p(^DHCDISTA(tmptype),"^",1)
	.q:tmptypecode'=typecode
	.s active=$p(^DHCDISSA(sa),"^",3)
	.q:active'="Y"
	.s SAHospID=$p(^DHCDISSA(sa),"^",7) //hxy 2019-09-19 st
	.q:(HospID'="")&(SAHospID'=HospID)  //ed
	.s desc=$p(^DHCDISSA(sa),"^",2)
	.s desc=$ZCONVERT(desc,"U")
	.s Count=Count+1
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",sa_"^"_desc)
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","0"_"^"_"全部")
	w "]"
	q ""
}

/// Creator:    zhaowuqiang
/// CreateDate: 2016-05-16
/// Descript: combox状态  (配送)
/// w ##class(web.DHCDISCommonDS).StatusComboS()
ClassMethod StatusComboS()
{
	
	n (%session)
	
	s pid=##class(web.DHCDISRequestCom).getPid()
	k ^TMP("web.DHCDISCommonDS","StatusComboS",pid)
	s typecode="陪送"
	s End = 10
	s Start=1
	s Count=0
	w "["
	s sa=""
	f  s sa = $o(^DHCDISSA(sa)) q:sa=""  d
	.q:+sa=0
	.s tmptype=$p(^DHCDISSA(sa),"^",6)                 //修改   2017-05-15  zhaowuqiang
	.s tmptypecode=$p(^DHCDISTA(tmptype),"^",1)
	.q:tmptypecode=typecode
	.s active=$p(^DHCDISSA(sa),"^",3)
	.q:active'="Y"
	.s desc=$p(^DHCDISSA(sa),"^",2)
	.s desc=$ZCONVERT(desc,"U")
	.q:$d(^TMP("web.DHCDISCommonDS","StatusComboS",pid,desc))
	.s ^TMP("web.DHCDISCommonDS","StatusComboS",pid,desc)=""
	.s Count=Count+1
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",sa_"^"_desc)
	w "]"
	q ""
}

/// Descript: combox状态  (陪送安排界面)
/// w ##class(web.DHCDISCommonDS).StatusComboPart()
ClassMethod StatusComboPart()
{
	
	n (%session)
	s typecode="陪送"
	
	s End = 10
	s Start=1
	s Count=0
	w "["
	s sa=""
	f  s sa = $o(^DHCDISSA(sa)) q:sa=""  d
	.q:+sa=0
	.s tmptype=$p(^DHCDISSA(sa),"^",6)                 //修改   2017-05-15  zhaowuqiang
	.s tmptypecode=$p(^DHCDISTA(tmptype),"^",1)
	.q:tmptypecode'=typecode
	.s active=$p(^DHCDISSA(sa),"^",3)
	.q:active'="Y"
	.s desc=$p(^DHCDISSA(sa),"^",2)
	.s desc=$ZCONVERT(desc,"U")
	.;q:(desc'="待处理")&&(desc'="已安排")
	.s Count=Count+1
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",sa_"^"_desc)
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","0"_"^"_"全部")
	w "]"
	q ""
}

/// Creator:    zhaowuqiang
/// CreateDate: 2017-02-15
/// Descript: combox配送人员
/// w ##class(web.DHCDISCommonDS).DisPersonCombo()
ClassMethod DisPersonCombo(q = "")
{
	n (q,%session)	
	s End = 10
	s Start=1
	s Count=0
	s q=$ZCONVERT(q,"U")
	;s HospID=%session.Get("LOGON.HOSPID")
	w "["
	s id=0
	f  s id=$o(^DHCDISLU(id)) Q:id=""  D
	.s userid=$p(^DHCDISLU(id),"^",2)
	.s username=$p(^SSU("SSUSR",userid),"^",2)
	.s status=$p(^DHCDISLU(id),"^",4)
	.q:status=1
	.s username=$ZCONVERT(username,"U")
	.q:$f(username,q)=0
	.s Count=Count+1
	.q:Count<Start
	.q:Count>End
	.w $case(Count,Start:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",userid_"^"_username)
	w "]"
	q ""
}

/// Description: 公共 (页面日期 转为 M中的日期数字)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-20	 
/// Input:       页面日期  例如：2017-03-03、28/2/2017等
/// Output:  	 M中日期数字 64338
/// Others:	w ##class(web.DHCDISCommonDS).DateHtmlToLogical("2017-03-03")	
ClassMethod DateHtmlToLogical(date As %String) As %String
{
	N (date)
	q:date=""""
	s DHCDISCommonDate=""
	s DHCDISCommonDate=##class(websys.Conversions).DateHtmlToLogical(date)
	q DHCDISCommonDate
}

/// Description: 公共 (M中的日期数字 转为 demo配置日期)
/// Creator:     huaxiaoying
/// CreateDate:  2017-03-20	 
/// Input:       M中日期数字 64345
/// Output:  	 demo配置的日期格式
/// Others:	w ##class(web.DHCDISCommonDS).DateLogicalToHtml("64345")	
ClassMethod DateLogicalToHtml(date As %String) As %String
{
	N (date)
	q:date=""""
	s DHCDISCommonDate=""
	s DHCDISCommonDate=##class(websys.Conversions).DateLogicalToHtml(date)
	q DHCDISCommonDate
}

/// Description:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCADV("DHCADVBLDREPORT"))
}

/// Description:通过配送类型，获取配送项目
/// w ##class(web.DHCDISCommonDS).getDisItemByTypeId(1)
ClassMethod getDisItemByTypeId(TypeId)
{
	n (TypeId)
	s count = 0
	w "["
	s ID=TypeId
	s Text=$p(^DHCDISTA(ID),"^",2)
	w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text)
	w ",""items"":"
	w "["
	s DisItmID=""
	f  s DisItmID=$o(^DHCDISLI(DisItmID)) q:DisItmID=""  d
	.q:DisItmID=0
	.s Hosp=$p(^DHCDISLI(DisItmID),"^",6)
	.s Status=$p(^DHCDISLI(DisItmID),"^",5)
	.q:Status'="Y"
	.s DisType=$p(^DHCDISLI(DisItmID),"^",7)
	.q:(TypeId'="")&&(DisType'=TypeId)
	.s code=$p(^DHCDISLI(DisItmID),"^",1)
	.s desc=$p(^DHCDISLI(DisItmID),"^",2)
	.s desc=$ZCONVERT(desc,"U")
	.;取项目维护的科室个数
	.s LocNum=0,LocId=""
	.s ItmLocID=""
	.f  s ItmLocID=$o(^DHCDISLRE(ItmLocID)) q:ItmLocID=""  d
	..q:ItmLocID=0
	..s ParentID=$p(^DHCDISLRE(ItmLocID),"^",1)
	..q:ParentID'=DisItmID
	..s LocNum=LocNum+1
	..s LocId=$p(^DHCDISLRE(ItmLocID),"^",2)
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",DisItmID_"^"_desc)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",DisItmID_"^"_desc)
	w "]"
	w "}"
	w "]"
	q ""
}

}
