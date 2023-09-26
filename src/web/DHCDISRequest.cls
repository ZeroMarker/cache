Import SQLUser

/// Creator:    zhouxin
/// CreateDate: 2016-01-11
/// Descript:   陪送申请
Class web.DHCDISRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:     huaxiaoying
/// CreateDate:  2017-01-19
/// Description: 科室列表下拉
/// Table: 		 
/// Input:  	 HospID
/// Return： 	 
/// W ##Class(web.DHCDISRequest).GetApplayLoc("2")   
ClassMethod GetApplayLoc(HospID As %String)
{
	s Count=0
	s LocId=""
	f  s LocId = $o(^CTLOC(LocId)) q:LocId=""  d
	.s FromDate=$p(^CTLOC(LocId),"^",24)
	.s EndDate=$p(^CTLOC(LocId),"^",25)
	.q:(FromDate>+$h)&(FromDate'="")
	.q:(EndDate<+$h)&(EndDate'="")
	.s Hosp=$p(^CTLOC(LocId),"^",22)
	.q:Hosp'=HospID
	.s LocDesc = $p(^CTLOC(LocId),"^",2)
	.s:LocDesc["-" LocDesc = $p(LocDesc,"-",2)
	.s Count=Count+1
	.s tmp = LocId_"^"_LocDesc
	.i Count=1 d
	..w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Creator:    huaxiaoying
/// CreateDate: 2016-01-19
/// Descript:   陪送类型下拉列出
/// Table: 		DHC_DisType 
/// Return： 	
/// w ##Class(web.DHCDISRequest).DisTypeList()
ClassMethod DisTypeList(HospID = "")
{
	n (HospID)
    w "["
	s Count=0
	s DtId=""
	f  s DtId=$o(^DHCDISTY(DtId)) q:DtId=""  d
	.q:DtId=0
	.s flag=$p(^DHCDISTY(DtId),"^",3)   //zhl
	.q:flag'="Y"                        //zhl
	.s code=$p(^DHCDISTY(DtId),"^",1)
	.s desc=$p(^DHCDISTY(DtId),"^",2)
	.s hospital=$p(^DHCDISTY(DtId),"^",4)
	.q:(HospID'="")&&(HospID'=hospital)
	.s tmp=DtId_"^"_code_"^"_desc
	.s Count=Count+1
	.i Count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Creator:    huaxiaoying
/// CreateDate: 2016-01-23
/// Descript:   陪送方式下拉列出
/// Table: 		DHC_DisTool 
/// Return： 
/// w ##Class(web.DHCDISRequest).DisToolList(2)
ClassMethod DisToolList(HospID = "")
{
	n (HospID)
    w "["
	s Count=0	
	s DtId=""
	f  s DtId=$o(^DHCDISTO(DtId)) q:DtId=""  d
	.q:DtId=0
	.s code=$p(^DHCDISTO(DtId),"^",1)
	.s desc=$p(^DHCDISTO(DtId),"^",2)
	.s flag=$p(^DHCDISTO(DtId),"^",3)   //可用标志
	.q:flag'="Y"
	.s Hospital=$p(^DHCDISTO(DtId),"^",4)   //医院
	.q:(HospID'="")&&(HospID'=Hospital)
	.s tmp=DtId_"^"_desc
	.s Count=Count+1
	.i Count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Creator:    huaxiaoying
/// CreateDate: 2016-01-11
/// Descript:   陪送类型下拉列出bootstrap
/// Table: 		DHC_DisType 
/// Return： 
/// w ##Class(web.DHCDISRequest).DisTypeList()
ClassMethod DisTypeListB(search As %String)
{
    w "["
	s Count=0
	s DtId=""
	f  s DtId=$o(^DHCDISTY(DtId)) q:DtId=""  d
	.q:DtId=0
	.s code=$p(^DHCDISTY(DtId),"^",1)
	.s desc=$p(^DHCDISTY(DtId),"^",2)
	.s tmp=DtId_"^"_code_"^"_desc
	.q:(search'="")&(desc'[search)
	.s Count=Count+1
	.i Count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Creator:    huaxiaoying
/// CreateDate: 2016-01-11
/// Descript:   陪送方式下拉列出bootstrap
/// Table: 		DHC_DisTool 
/// Return： 
/// w ##Class(web.DHCDISRequest).DisToolList()
ClassMethod DisToolListB(search As %String)
{
    w "["
	s Count=0	
	s DtId=""
	f  s DtId=$o(^DHCDISTO(DtId)) q:DtId=""  d
	.q:DtId=0
	.s code=$p(^DHCDISTO(DtId),"^",1)
	.s desc=$p(^DHCDISTO(DtId),"^",2)
	.s tmp=DtId_"^"_desc
	.q:(search'="")&(desc'[search)
	.s Count=Count+1
	.i Count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// Creator:    huaxiaoying
/// CreateDate: 2016-01-11
/// Descript:   陪送人数下拉列出bootstrap/easyui
/// w ##Class(web.DHCDISRequest).DisNumlList()
ClassMethod DisNumlList()
{
    w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text","1^1人")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","2^2人")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","3^3人")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","4^4人")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","5^5人")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","6^6人")
	w "]"
	q ""
}

/// Creator:    huaxiaoying 
/// CreateDate: 2016-02-24
/// Descript:   当前人数
/// Table：     DHC_DisLocUser DHC_DisLocUserLinkItm
/// Return：
/// w ##Class(web.DHCDISRequest).GetNowReqNum(252)
ClassMethod GetNowReqNum(Loc)
{
	s LUid="",count=0
    f  s LUid=$o(^DHCDISLU(LUid))  q:LUid=""  d
    .q:LUid=0
	.s msg=$g(^DHCDISLU(LUid))
	.q:msg=""
	.s locdr=$p(msg,"^",1)
	.s userdr=$p(msg,"^",2)
	.s ActiveFlag=$p(msg,"^",3)
	.q:ActiveFlag'="Y"
	.s status=$p(msg,"^",4)
	.q:status'="0"
	.s count=count+1
	
	q """"_count_""""
	/*
	.s linkitem="",number=0
	.f  s linkitem=$o(^DHCDISLU(LUid,"LinkItm",linkitem)) q:linkitem=""  d
	..s submsg="",itemdr="",itemmsg=""
	..s submsg=^DHCDISLU(LUid,"LinkItm",linkitem)
	..i submsg'="" s itemdr=$p(submsg,"^",3)
	..i itemdr'="" s itemmsg=$g(^DHCDISLI(itemdr))
	..i itemmsg'="" s itemLoc=$p(itemmsg,"^",3) ;接收科室id
	..i ((itemLoc=Loc)!(itemLoc="")) s number=number+1
	.i number>0 s count=count+1


	q """"_count_""""
	*/
}

/// Creator:    huaxiaoying 
/// CreateDate: 2016-02-06
/// Descript:   已选项目列出
/// Table：     DHC_DisRequest、DHC_DisRequestItm
/// Input：    
/// Return：
/// w ##Class(web.DHCDISRequest).ListSelected(1,10,21)
ClassMethod ListSelected1(page = 1, rows = 10, RowId)
{
	s start=(page-1)*rows+1
    s end=page*rows
    s count=0
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
    w "{""rows"":["
	s Sub="",ReqDesc=""
	f  s Sub=$o(^DHCDISRE(RowId,"Itm",Sub)) q:Sub=""  d
	.s locDesc=""
	.s Item=$p(^DHCDISRE(RowId,"Itm",Sub),"^",1) //项目名称
	.s ExeLocDr=$p(^DHCDISRE(RowId,"Itm",Sub),"^",3)
	.s:ExeLocDr'="" locDesc=$p(^CTLOC(ExeLocDr),"^",2) //去向科室
	.s ItemType=$p(^DHCDISRE(RowId,"Itm",Sub),"^",2) //项目类型
	.i ItemType="Ord" d
	..s ord=$p(Item,"||",1),itm=$p(Item,"||",2)
	..s arcitmid=$p($g(^OEORD(ord,"I",itm,1)),"^",2) /// OEORI_ItmMast_DR
	..s itmmastid=$p(arcitmid,"||",1)
	..s itmmastver=$p(arcitmid,"||",2)
	..s ReqDesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱名称
	.e  d
	..s LIType=$p(^DHCDISLI(Item),"^",4)
	..q:LIType'=0
	..s ReqDesc=$p(^DHCDISLI(Item),"^",2)
	.
	.s tmp=ReqDesc_"^"_locDesc
	.s count=count+1
	.q:count<start
	.q:count>end
    .w $case(count,start:"",:",") 
	.w ##class(web.DHCAPPJsonCommon).getJsonData("ReqDesc^ExelocDesc",tmp)
	w "],""total"":"_count_"}"
	q ""
}

/// Creator:    huaxiaoying   zwq
/// CreateDate: 2016-02-06    2017-05-22
/// Descript:   已选项目列出
/// Table：     DHC_DisRequest、DHC_DisRequestItm
/// Input：    
/// Return：
/// w ##class(web.DHCDISRequest).ListSelected("1","30","4")
ClassMethod ListSelected(page = 1, rows = 30, AdmNo)
{
	s start=(page-1)*rows+1
    s end=page*rows
    s count=0
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
    w "{""rows"":["
    
    s ReqID=""
    f  s ReqID=$o(^DHCDISRE(ReqID),-1) q:ReqID=""  d
    .q:ReqID=0
    .s ReqAdmNo=$p(^DHCDISRE(ReqID),"^",4)  //就诊ID
    .q:ReqAdmNo'=AdmNo
    .s ReqExeDate=$p(^DHCDISRE(ReqID),"^",7)  //执行日期
    .s ReqExeDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(ReqExeDate)
    .s DateDay=$p(ReqExeDate,"/",1)
    .s DateMonth=$p(ReqExeDate,"/",2)
    .s ReqExeDate=DateMonth_"/"_DateDay
    .s ReqExeTime=$p(^DHCDISRE(ReqID),"^",8)  //执行时间
    .s:ReqExeTime'="" ReqExeTime=$zt(ReqExeTime,1)
    .s TimeHour=$p(ReqExeTime,":",1)
    .s TimeMunite=$p(ReqExeTime,":",2)
    .s ReqExeTime=TimeHour_":"_TimeMunite
    .s TimePoint=$p(^DHCDISRE(ReqID),"^",19)
    .s ReqEexDateTime=ReqExeDate_" "_TimePoint_" "_ReqExeTime
    .s ReqCreateDate=$p(^DHCDISRE(ReqID),"^",13) //申请日期
    .s ReqCreateDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(ReqCreateDate)
    .s DateDay=$p(ReqCreateDate,"/",1)
    .s DateMonth=$p(ReqCreateDate,"/",2)
    .s ReqCreateDate=DateMonth_"/"_DateDay
    .s ReqCreatTime=$p(^DHCDISRE(ReqID),"^",14) //申请时间
    .s ReqCreatTime=$zt(ReqCreatTime,1)
    .s TimeHour=$p(ReqCreatTime,":",1)
    .s TimeMunite=$p(ReqCreatTime,":",2)
    .s ReqCreatTime=TimeHour_":"_TimeMunite
    .s ReqCreatDateTime=ReqCreateDate_" "_ReqCreatTime
    .s ReqRecLocDesc=""
    .s ReqRecLocDr=$p(^DHCDISRE(ReqID),"^",6)  //接收科室
    .s:ReqRecLocDr'="" ReqRecLocDesc=$p(^CTLOC(ReqRecLocDr),"^",2)
    .s ReqCreatUserName=""
    .s ReqCreatUserDr=$p(^DHCDISRE(ReqID),"^",15) //创建人
    .s:ReqCreatUserDr'="" ReqCreatUserName=$p(^SSU("SSUSR",ReqCreatUserDr),"^",2)
    .s Sub="",ReqDesc=""
	.f  s Sub=$o(^DHCDISRE(ReqID,"Itm",Sub)) q:Sub=""  d
	..s locDesc=""
	..s Item=$p(^DHCDISRE(ReqID,"Itm",Sub),"^",1) //项目名称
	..s ExeLocDr=$p(^DHCDISRE(ReqID,"Itm",Sub),"^",3)
	..s:ExeLocDr'="" locDesc=$p(^CTLOC(ExeLocDr),"^",2) //去向科室
	..s:locDesc="" locDesc=ReqRecLocDesc
	..s ItemType=$p(^DHCDISRE(ReqID,"Itm",Sub),"^",2) //项目类型
	..i ItemType="Ord" d
	...s ord=$p(Item,"||",1),itm=$p(Item,"||",2)
	...s arcitmid=$p($g(^OEORD(ord,"I",itm,1)),"^",2) /// OEORI_ItmMast_DR
	...s itmmastid=$p(arcitmid,"||",1)
	...s itmmastver=$p(arcitmid,"||",2)
	...s ReqDesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱名称
	..e  d
	...s LIType=$p(^DHCDISLI(Item),"^",4)
	...q:LIType'=0
	...s ReqDesc=$p(^DHCDISLI(Item),"^",2)
	..s tmp=ReqDesc_"^"_locDesc_"^"_ReqEexDateTime_"^"_ReqCreatDateTime_"^"_ReqCreatUserName
	..s count=count+1
	..q:count<start
	..q:count>end
    ..w $case(count,start:"",:",") 
	..w ##class(web.DHCAPPJsonCommon).getJsonData("ReqDesc^ExelocDesc^ReqEexDateTime^ReqCreatDateTime^ReqCreatUserName",tmp)
    
    
    w "],""total"":"_count_"}"
	q ""
}

/// Creator：      huaxiaoying
/// CreatDate：    2017-02-07
/// Description:   其他项目可用列出   (陪送)
/// Table：        DHC_DisLocItem
/// Input：	       page：当前页数
///                rows：每页条数 
/// Return：     
/// w ##class(web.DHCDISRequest).ListLocItem("1","100","","","")
ClassMethod ListLocItem(page = 1, rows = 10, LICode = "", LIDesc = "", LgHospID = "")
{
	
	 s start=(page-1)*rows+1
	 s end=page*rows
	 s count=0
	 
	 s jsonObj=##class(web.DHCAPPJsonObject).%New()
	 w "{""rows"":["
	 s id=""
	 f  s id=$o(^DHCDISLI(id)) q:id=""  d
	 .q:id=0
	 .s msg=$g(^DHCDISLI(id))
	 .q:msg=""
	 .s locdr="",locdesc=""
	 .s code=$p(msg,"^",1)
	 .s desc=$p(msg,"^",2)
	 .;s locdr=$p(msg,"^",3)
	 .;i locdr'="" s locdesc=$p(^CTLOC(locdr),"^",1)
	 .s type=$p(msg,"^",7)
	 .s typecode=$p($g(^DHCDISTA(type)),"^",1)
	 .q:typecode'="陪送" //只要陪送
	 .s activeflag=$p(msg,"^",5)
	 .q:activeflag="N" //可用
	 .s HosptId=$p(msg,"^",6)
	 .q:(LgHospID'="")&&(HosptId'=LgHospID)
	 .s TypeFlag=$p(msg,"^",4)
	 .s Type="Oth"
	 .s RecLocFlag=$p(msg,"^",8)
	 .s tmp=id_"^"_code_"^"_desc_"^"_Type_"^"_TypeFlag_"^"_RecLocFlag
	 .q:(LICode'="")&(code'[$$ALPHAUP^SSUTIL4(LICode))
	 .q:(LIDesc'="")&(desc'[$$ALPHAUP^SSUTIL4(LIDesc))
	 .s count=count+1
	 .q:count<start
	 .q:count>end
	 .w $case(count,start:"",:",") 
	 .w ##class(web.DHCAPPJsonCommon).getJsonData("ID^LICode^LIDesc^Type^TypeFlag^RecLocFlag",tmp)
	 w "],""total"":"_count_"}"
	 q ""
}

/// Creator:    huaxiaoying
/// CreateDate: 2016-02-07
/// Descript:   医嘱列出
/// Table：     
/// Input：    
/// Return：
/// w ##Class(web.DHCDISRequest).ListOrd(1,10,"","")
ClassMethod ListOrd(page = 1, rows = 10, EpisodeID = "", arcItmDesc)
{
	
	s start=(page-1)*rows+1
	s end=page*rows
	s pid=$i(^DHCST("DHCDIS"))
	s count=0,h=0
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	Q:EpisodeID="" "{""rows"":[],""total"":0}"
	s PatWardDr=$p(^PAADM(EpisodeID),"^",70) 			/// 就诊病区
	s CtLocDr=""
	i PatWardDr'="" s CtLocDr=$p(^PAWARD(PatWardDr),"^",5)			/// 所在护理单元吧  
	
	s ord=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:ord="" "{""rows"":[],""total"":0}"
	s itm=0,Type="Ord"
	f  s itm=$o(^OEORD(ord,"I",itm)) q:itm=""  d
	.Q:'$D(^OEORD(ord,"I",itm,1))
	.s OrdStatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)  /// 医嘱状态
	.q:(OrdStatus'="V")&(OrdStatus'="E")
	.s seqNo=$p($g(^OEORD(ord,"I",itm,3)),"^",4)	/// OEORI_SeqNo
	.s arcitmid=$p($g(^OEORD(ord,"I",itm,1)),"^",2) /// OEORI_ItmMast_DR
	.s itmmastid=$p(arcitmid,"||",1)
	.s itmmastver=$p(arcitmid,"||",2)
	.s recLoc=$p($g(^OEORD(ord,"I",itm,3)),"^",6)
	.s itemCatID=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",10) /// 医嘱子类ID 
	.s priorid=$p($g(^OEORD(ord,"I",itm,1)),"^",8) /// OEORI_Priority_DR
	.q:priorid=""  /// 床位费和诊疗费没有医嘱优先级,也不需要显示
	.s ordPrior=$p($g(^OECPR(priorid)),"^",2)      ///医嘱优先级 
	.s OrderOrdLocDR=$p($g(^OEORD(ord,"I",itm,7)),"^",2)
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  /// 医嘱项名称
	.s ItemOrderType=$P(^ARC("IC",itemCatID),"^",7)         /// 医嘱类型 代码
	.s ARCICOrdCatDR=$P(^ARC("IC",itemCatID),"^",8)	 //2017-04-17 医嘱分类
    .s ARCICOrdCateDesc=$P(^OEC("ORCAT",ARCICOrdCatDR),"^",2) //2017-04-17
	.Q:(ARCICOrdCateDesc'["检查")&&(ARCICOrdCateDesc'["治疗") //只要检查2017-04-17
	.q:(CtLocDr'="")&&(CtLocDr=recLoc)
	.i seqNo["." s arcitmdesc="____"_arcitmdesc             /// 如果为子医嘱 名称前增加缩进
	.s oeori=ord_"||"_itm
	.s OrderStartDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)   /// 开始日期
	.q:OrderStartDate=""
	.s OrderStartTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10)  /// 开始时间
	.q:OrderStartTime=""
	.s recLoc=""
	.s recLocID=$p($g(^OEORD(ord,"I",itm,3)),"^",6)
	.i recLocID'="" s recLoc=$p($g(^CTLOC(recLocID)),"^",2)  /// 接收科室
	.s:recLoc["-" recLoc=$p(recLoc,"-",2)
	.q:(arcItmDesc'="")&(arcitmdesc'[$$ALPHAUP^SSUTIL4(arcItmDesc))
	.s h=h+1
	.s tmp=arcitmdesc_"^"_recLoc_"^"_OrderStartDate_"^"_OrderStartTime_"^"_oeori_"^"_Type_"^"_recLocID
	.s ^TMP("DHCST","web.DHCDISRequest","ListOrd",pid,OrderStartDate,OrderStartTime,h)=tmp 
	
	///取数据  sufan  2018-01-15 按检查时间逆序取医嘱
	w "{""rows"":["
	s date=""
	for  s date=$o(^TMP("DHCST","web.DHCDISRequest","ListOrd",pid,date),-1)  q:date=""  d
	.s time=""
	.for  s time=$o(^TMP("DHCST","web.DHCDISRequest","ListOrd",pid,date,time),-1)  q:time=""  d
	..s index=""
	..for  s index=$o(^TMP("DHCST","web.DHCDISRequest","ListOrd",pid,date,time,index))	q:index=""  d
	...s mdata=^(index) 
	...s arcitmdesc=$p(mdata,"^",1)				//医嘱项
	...s recLoc=$p(mdata,"^",2)					//接收科室
	...s OrderStartDate=$p(mdata,"^",3)			//医嘱开始日期
	...i OrderStartDate'="" s OrderStartDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(OrderStartDate) //2017-03-20 $zd(OrderStartDate,3)
	...;s OrderStartDate=$p(OrderStartDate,"/",1,2)
	...s OrderStartTime=$p(mdata,"^",4)			//医嘱开始时间
	...i OrderStartTime'="" s OrderStartTime=$zt(OrderStartTime,1)
	...s TimeHour=$p(OrderStartTime,":",1)
	...s TimeMunite=$p(OrderStartTime,":",2)
	...s OrderStartTime=TimeHour_":"_TimeMunite
	...s OrderExeDate=OrderStartDate_" "_OrderStartTime
	...s oeori=$p(mdata,"^",5)					//医嘱ID
	...s Type=$p(mdata,"^",6)						//类型
	...s recLocID=$p(mdata,"^",7)					//科室ID
	...s ListData=arcitmdesc_"^"_recLoc_"^"_OrderExeDate_"^"_oeori_"^"_Type_"^"_recLocID
	...s count=count+1
	...q:count<start
	...q:count>end
	...w $case(count,start:"",:",") 
	...w ##class(web.DHCAPPJsonCommon).getJsonData("arcItmDesc^recLoc^OrderExeDate^arcItmId^Type^recLocID",ListData)
	w "],""total"":"_count_"}"
	k ^TMP("DHCST","web.DHCDISRequest","ListOrd",pid)
	q ""
}

/// Creator:    zwq
/// CreateDate: 2017-05-18
/// Descript:   过滤已申请医嘱
/// Table：     DHC_DisRequestItm
/// Input：     就诊ID,医嘱ID
/// Return：
/// w ##Class(web.DHCDISRequest).GetSelectedOrder()
ClassMethod GetSelectedOrder(EpisodeID, oeori)
{
	n (EpisodeID, oeori)
	
	s ret=-1
	s reqID=""
	f  s reqID=$o(^DHCDISRE(reqID)) q:reqID=""  d
	.q:reqID=0
	.s reqAdm=$p(^DHCDISRE(reqID),"^",4)
	.q:reqAdm'=EpisodeID
	.s itmChildSub=""
	.f  s itmChildSub=$o(^DHCDISRE(reqID,"Itm",itmChildSub)) q:itmChildSub=""  d
	..s itmID=$p(^DHCDISRE(reqID,"Itm",itmChildSub),"^",1)
	..s:itmID=oeori ret=0
	
	q ret
}

/// Creator:    huaxiaoying 
/// CreateDate: 2016-02-04
/// Descript:   保存申请
/// Table：     DHC_DisRequest、DHC_DisRequestItm
/// Input：     str(form串串)、strObjs(项目串串)
/// Return：
/// w ##Class(web.DHCDISRequest).Save("579410^1^1||1^10^0000000010^^02/11/2017  上午^4^1^1^^122^4140","6||13^Ord^122$$")
/// w ##Class(web.DHCDISRequest).Save("147242^1^1||4^63^0000000043^2^03/06/2017  下午^4^1^1^^114^575","17^Oth^undefined$$")
ClassMethod Save(str, strObjs)
{
	s ^tempsufan("str")=$lb(str, strObjs)
	s REQNo=$p(str,"^",1)
    s REQWardDr=$p(str,"^",2)
    s REQWardBedDr=$p(str,"^",3)
    s REQAdm=$p(str,"^",4)
    s REQPapmiDr=$p(str,"^",5)
    s REQRecLocDr=$p(str,"^",6)
    s REQExeDate=$p($p(str,"^",7)," ",1)
    s REQExeTime=$p($p(str,"^",7)," ",2)
    s REQExeTimePoint=$p($p(str,"^",7)," ",3)
    s REQEscortTypeDr=$p(str,"^",8)
    s REQEscortToolDr=$p(str,"^",9)
    s REQNums=$p(str,"^",10)
    s REQRemarks=$p(str,"^",11)
    s REQCreateDate=$p($h,",",1)  
    s REQCreateTime=$p($h,",",2)
    s LgLocID=$p(str,"^",12)
    s LgUserID=$p(str,"^",13)
    s LgHospID=$p(str,"^",14)
    S REQCurStatus="",type="0",Desc="待处理",DisTypeAddRowId="",TypeDesc="陪送"
    &sql(select TA_RowID into :DisTypeAddRowId from SQLUser.DHC_DisTypeAdd where TA_Desc=:TypeDesc ) //2017-04-18 因表结构变动
    &sql(select SA_RowId into :REQCurStatus from SQLUser.DHC_DisStatusAdd where SA_Desc=:Desc and SA_Type=:DisTypeAddRowId) //2017-04-18
	;&sql(select SA_RowId into :REQCurStatus from SQLUser.DHC_DisStatusAdd where SA_Loc_Dr=:REQRecLocDr and SA_Desc=:Desc and SA_Type=:type) //2017-04-18
    ;s REQItem=$p(str,"^",12)
    ;s REQItemType=$p(str,"^",13)
    ;s REQExeLocDr=$p(str,"^",14)
    ;s ^h(1)=REQNo_"^"_REQWardDr_"^"_REQWardBedDr_"^"_REQAdm_"^"_REQPapmiDr_"^"_REQRecLocDr_"^"_REQExeDate_"^"_REQExeTime_"^"_REQEscortTypeDr_"^"_REQEscortToolDr_"^"_REQCreateDate_"$"_REQCreateTime_"^"_REQItem_"^"_REQItemType_"^"_REQExeLocDr
	
	TSTART	
		s TypeID=""
		s TypeID=$o(^DHCDISTA(0,"Code","陪送",TypeID))
		q:TypeID="" -1
		s obj=##class(User.DHCDisRequest).%New() //Q:$d(^DHCEMLEX(0,"Code",LEXCode)) 1
	    s obj.REQNo=REQNo
	    s obj.REQWardDr=##class(User.PACWard).%OpenId(REQWardDr) 
	    s obj.REQWardBedDr=##class(User.PACBed).%OpenId(REQWardBedDr)
		s obj.REQAdm=##class(User.PAAdm).%OpenId(REQAdm)
		s obj.REQPapmiDr=##class(User.PAPatMas).%OpenId(REQPapmiDr)
		s obj.REQRecLocDr=##class(User.CTLoc).%OpenId(REQRecLocDr)
		s obj.REQExeDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(REQExeDate)  //$zdh(REQExeDate,3) 
		s:REQExeTime'="" REQExeTime=$zth(REQExeTime,1)
		s obj.REQExeTime=REQExeTime
		s obj.REQExeTimePoint=REQExeTimePoint
		s obj.REQEscortTypeDr=##class(User.DHCDisType).%OpenId(REQEscortTypeDr)
		s obj.REQEscortToolDr=##class(User.DHCDisTool).%OpenId(REQEscortToolDr)
		s obj.REQNums=REQNums
		s obj.REQRemarks=REQRemarks
		s obj.REQCreateDate=REQCreateDate
		s obj.REQCreateTime=REQCreateTime
		s obj.REQTypeAddDr=##class(User.DHCDisTypeAdd).%OpenId(TypeID)
		s obj.REQCreateUser=##class(User.SSUser).%OpenId(LgUserID) 
		s obj.REQHospDr=##class(User.CTHospital).%OpenId(LgHospID) 
		;s obj.REQCurStatus=##class(User.DHCDisStatusAdd).%OpenId(REQCurStatus) 	 
		s sc=obj.%Save() //s REQParRefDr=obj.%Id()
	    If $System.Status.IsError(sc) {  //检查Save是否成功
   			Do $System.OBJ.DisplayError(sc)
   			Set REQParRefDr=-1
		} Else {
			Set REQParRefDr=obj.%Id()
		} //Do obj.%Close()
		
	If sc'=1 TROLLBACK
		s ReqID = obj.%Id()  //获取任务id  赵武强  2017-02-05
		;d ..saveCode(ReqID)  //保存验证码明细表

	    s len=$l(strObjs,"$$")-1
	    for i=1:1:len d 
	    .s strObj=$p(strObjs,"$$",i)
	    .s REQItem=$p(strObj,"^",1)
        .s REQItemType=$p(strObj,"^",2)
        .s REQExeLocDr=$p(strObj,"^",3)
		.s codeobj=##class(User.DHCDisRequestItm).%New()
		.s codeobj.REQParRefDr=##class(User.DHCDisRequest).%OpenId(REQParRefDr)
		.s REQChildSub=$o(^DHCDISRE(REQParRefDr,"Itm",""),-1)+1
		.s codeobj.REQChildSub=REQChildSub
		.s codeobj.REQItem=REQItem
		.s codeobj.REQItemType=REQItemType
		.s codeobj.REQExeLocDr=##class(User.CTLoc).%OpenId(REQExeLocDr) 
		.i REQExeLocDr="" s codeobj.REQExeLocDr=##class(User.CTLoc).%OpenId(REQRecLocDr)
		.s sc=codeobj.%Save()
	    
	If sc'=1 TROLLBACK
	
		///配送申请按配置安排护工
		//s backcode=..LinkLocUser(ReqID,TypeID,LgUserID,LgLocID,REQNums)
		//s ret=$p(backcode,"^",1)
		//s err=$p(backcode,"^",2)
	//If ret'=0 TROLLBACK
		///2017-02-25 zhaowuqiang 保存验证码明细表 
	    s Code = $p(^DHCDISRE(ReqID),"^",1)
		s ReqType = 0
		s CreateDate = $p(^DHCDISRE(ReqID),"^",13)
		s CreateTime = $p(^DHCDISRE(ReqID),"^",14)
		s CreateUser = $p(^DHCDISRE(ReqID),"^",15)
		s obj=##class(User.DHCDisRequestCode).%New()
		s obj.RCPointer=ReqID
		s obj.RCCode=Code
		s obj.RCReqType=ReqType
		s obj.RCCreateDate=CreateDate
		s obj.RCCreateTime=CreateTime
		s obj.RCCreateUser=##class(User.SSUser).%OpenId(CreateUser)
		s sc=obj.%Save()
	If sc'=1 TROLLBACK

	s nextStatus=##class(web.DHCDISRequestCom).getNextStatus(ReqID,TypeID,"Y","1","")
	s nextStatusCode=$p(^DHCDISSA(nextStatus),"^",1)
	s ret=##class(web.DHCDISRequestCom).updateStatus(ReqID,TypeID,nextStatusCode,CreateUser,"Y","1")
 	i ret'=0 TRollBack  q ret   //sufan 2017-11-28 若回滚，不q，提交会报错
	
	TCOMMIT
	
	q ReqID  		// sufan 2017-11-28 返回申请ID
}

ClassMethod LinkLocUser(ReqID, TypeID, lgUser, lgCtLocID, REQNums)
{
	n (ReqID, TypeID, lgUser, lgCtLocID, REQNums)
	
	;k ^zwq
	;s ^zwq=ReqID_"^"_TypeID_"^"_lgUser_"^"_lgCtLocID_"^"_REQNums
	s pid=##class(web.DHCDISEscortArrage).NewPid()
	//判断该护理单元有无需求护工数量
	s count=0,Auto=-1,ret=0,err=-1
	s ID=""
	f  s ID=$o(^DHCDISLU(ID)) q:ID=""  d
	.q:ID=0
	.s ReqLoc=$p(^DHCDISLU(ID),"^",1)
	.s UserStatu=$p(^DHCDISLU(ID),"^",4)
	.q:ReqLoc'=lgCtLocID
	.;q:UserStatu=1
	.s count=count+1
	q:count<REQNums ret_"^"_err
	s err=0
	//根据要求个数，交替安排护工
	s tid=0
	s LUWorkload=""
	f  s LUWorkload=$o(^DHCDISLU(0,"Workload",LUWorkload))  q:(LUWorkload="")||(tid=REQNums)  d 
	.s LocUserID=""
	.f  s LocUserID=$o(^DHCDISLU(0,"Workload",LUWorkload,LocUserID)) q:((LocUserID="")||(ret'=0)||(tid=REQNums))  d
	..q:LocUserID=0
	..s ReqLoc=$p(^DHCDISLU(LocUserID),"^",1)
	..s UserStatu=$p(^DHCDISLU(LocUserID),"^",4)
	..;q:UserStatu=1
	..q:ReqLoc'=lgCtLocID
	..s UserDr=$p(^DHCDISLU(LocUserID),"^",2)
	..s LUWorkloadNums=LUWorkload+1
	..&sql(insert into DHC_DisPeople (DP_ReqType,DP_Pointer,DP_User_Dr) values (:TypeID,:ReqID,:UserDr))
	..s ret=SQLCODE
	..q:SQLCODE'=0
	..s ^TMP("DHCDIS","web.DHCDISRequest","LinkLocUser",pid,LocUserID)=LocUserID
	..s tid=tid+1
	..s Auto=0
	q:ret'=0 ret_"^"_err
	//更新护工工作量
	s UserID=""
	f  s UserID=$o(^TMP("DHCDIS","web.DHCDISRequest","LinkLocUser",pid,UserID)) q:UserID=""  d
	.s Workload=$p(^DHCDISLU(UserID),"^",5)
	.s Workload = Workload+1
	.&sql(update DHC_DisLocUser set LU_Workload=:Workload where LU_RowId=:UserID)
	.s ret=SQLCODE
	.q:ret'=0
	//更新护工状态和操作流水表
	i Auto=0  d
	.s CurStatus=$o(^DHCDISSA("0","TypeCode",TypeID,"Y","Y",11,""))
	.q:CurStatus="" 
	.&sql(update DHC_DisRequest set REQ_CurStatus=:CurStatus where REQ_RowID=:ReqID)    //设置状态为 已安排
	.s ret=SQLCODE
	.q:ret'=0
	.s ret=##class(web.DHCDISRequestCom).updatePeopleStatus(ReqID,TypeID,CurStatus)
	.q:ret'=0
	.s ret=##class(web.DHCDISRequestCom).saveRequestSta(ReqID, TypeID, CurStatus, lgUser, "Y")
	.q:ret'=0
	k ^TMP("DHCDIS","web.DHCDISRequest","LinkLocUser",pid)
	
	q ret_"^"_err
}

/// Description:  陪送申请按配置安排护工
/// Creator:      zhaowuqiang  cy
/// CreatDate:    2017-03-28  2017-05-08
/// Table:        DHC_DisPeople、DHC_DisLocItem
/// Input:        陪送申请ID,项目数据串
/// Output:       SQLCODE
/// Other:        w ##class(web.DHCDISRequest).LinkLocUser1("152","10^Oth^$$11^Oth^86$$")
ClassMethod LinkLocUser1(ReqID, TypeID, strObjs, lgUser, lgCtLocID, REQNums)
{

	s ret=0,err=-1,Auto=-1
	s Length=$l(strObjs,"$$")-1   //获取陪送项目数据串
	s pid=##class(web.DHCDISEscortArrage).NewPid()
	s num=0
	f i=1:1:Length  d
	.s StrObj=$p(strObjs,"$$",i)
	.s ItmID=$p(StrObj,"^",1)
	.s LocDR=$p(StrObj,"^",3)
	.;q:LocDR=""
	.s id=""
	.f  s id=$o(^DHCDISLI(id)) q:(id="")  d  //与维护的陪送项目和去向作对比
	..q:id=0
	..s LocID=$p(^DHCDISLI(id),"^",3)
	..s Activeflag=$p(^DHCDISLI(id),"^",5)
	..s Type=$p(^DHCDISLI(id),"^",4)
	..q:Type'=0
	..q:LocID'=LocDR
	..q:Activeflag'="Y"
	..s LUWorkload=""
	..f  s LUWorkload=$o(^DHCDISLU(0,"Workload",LUWorkload))  q:(LUWorkload="")  d 
	...s locuserID=""
	...f  s locuserID=$o(^DHCDISLU(0,"Workload",LUWorkload,locuserID)) q:(locuserID="")  d
	....q:locuserID=0
	....q:num=REQNums
	....s linkchildsub="",Itmflag=0 ;cy  Itmflag 1 该申请单项目有配置陪送人员
	....f  s linkchildsub=$o(^DHCDISLU(locuserID,"LinkItm",linkchildsub)) q:(linkchildsub="")  d   //取维护的护工
	.....s ItemDR=$p(^DHCDISLU(locuserID,"LinkItm",linkchildsub),"^",3)
	.....s:ItemDR=ItmID Itmflag=1
	.....q:Itmflag=1
	....q:Itmflag'=1
	....s UserDR=$p(^DHCDISLU(locuserID),"^",2)
	....s DPRowid="",DPflag=0 ;cy  DPflag -1该申请单表示陪送人员重复
	....f  s DPRowid=$o(^DHCDISPE("0","TypePointer",TypeID,ReqID,DPRowid)) q:(DPRowid="")  d 
	.....s DPUserDr=$p(^DHCDISPE(DPRowid),"^",3)
	.....s:DPUserDr=UserDR DPflag=-1
	.....q:DPflag=-1
	....q:DPflag=-1
	....s Flag=$p(^DHCDISLU(locuserID),"^",3)
	....s LocUserStatue=$p(^DHCDISLU(locuserID),"^",4)
	....s LUWorkloadNums=LUWorkload+1
	....s RequestType=TypeID
	....q:Flag'="Y"
	....;q:LocUserStatue=1
	....s LocUserStatue=1
	....&sql(insert into DHC_DisPeople (DP_ReqType,DP_Pointer,DP_User_Dr) values (:RequestType,:ReqID,:UserDR))
	....s ret=SQLCODE
	....q:SQLCODE'=0
	....&sql(update DHC_DisLocUser set LU_Workload=:LUWorkloadNums,LU_Status=:LocUserStatue where LU_RowId=:locuserID)
	....s ret=SQLCODE
	....q:SQLCODE'=0
	....s num=num+1
	....s:num=REQNums Auto=0
	i Auto=0 d
	.s CurStatus=$o(^DHCDISSA("0","TypeCode",TypeID,"Y","Y",11,""))
	.q:CurStatus="" 
	.&sql(update DHC_DisRequest set REQ_CurStatus=:CurStatus where REQ_RowID=:ReqID)    //设置状态为 已安排
	.s ret=SQLCODE
	.q:ret'=0
	.s ret=##class(web.DHCDISRequestCom).saveRequestSta(ReqID, TypeID, CurStatus, lgUser, "Y")
	.q:ret'=0
	.s ret=##class(web.DHCDISRequestCom).updatePeopleStatus(ReqID,TypeID,CurStatus)
	.q:ret'=0
	.s err=0
	k ^TMP("DHCDIS","web.DHCDISRequest","LinkLocUser",pid)
	q ret_"^"_err
}

/// Creator:    zhaowuqiang 
/// CreateDate: 2017-02-25
/// Descript:   查询验证码明细
/// Table：     DHC_DisRequestCode
/// Input：     
/// Return
/// w ##class(web.DHCDISRequest).QueryCodeDetail("30","1","108")
ClassMethod QueryCodeDetail(rows As %String, page As %String, StrParam As %String)
{
	n (rows,page,StrParam)
	S pid=##class(web.DHCADVCOMMON).NewPid()
	D ..killTmpGlobal(pid)
	S QuitFlag=0
	S Num=0
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1     //开始行
	s DisRCCreateUser=""
	
	s id=""
	f  s id=$o(^DHCDISRC(0,"TypePointer",0,StrParam,id)) q:id=""  d
	.;q:'$d(^DHCDISRC(id))
	.s DisRCCode=$p(^DHCDISRC(id),"^",3)
	.s DisRCCreateDate=$p(^DHCDISRC(id),"^",4)
	.s DisRCCreateDate=##class(web.DHCDISCommonDS).DateLogicalToHtml(DisRCCreateDate) //2017-03-20 $zd(DisRCCreateDate,3)
	.s DisRCCreateTime=$p(^DHCDISRC(id),"^",5)
	.s DisRCCreateTime=$zt(DisRCCreateTime,2)
	.s DisRCCreateUserDr=$p(^DHCDISRC(id),"^",6)
	.i DisRCCreateUserDr'="" s DisRCCreateUser=$p(^SSU("SSUSR",DisRCCreateUserDr),"^",2)
	.s DisRCActiveFlag=$p(^DHCDISRC(id),"^",7)
	.S ListData=DisRCCode_"^"_DisRCCreateDate_"^"_DisRCCreateTime_"^"_DisRCCreateUser_"^"_DisRCActiveFlag
	.S Num=Num+1
	.S ^TMP("DHCDIS","web.DHCDISRequest","QueryCodeDetail",pid,Num)=ListData
	
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	W ##class(web.DHCADVJSONCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCDIS","web.DHCDISRequest","QueryCodeDetail",pid,index),-1) Q:(index="")||(quitflag=1)  D //wangxuejian 2016-10-09  逆序取值
	.S mdata=^TMP("DHCDIS","web.DHCDISRequest","QueryCodeDetail",pid,index)
	.S Title="DisRCCode^DisRCCreateDate^DisRCCreateTime^DisRCCreateUser^DisRCActiveFlag"
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage D
	..W ##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	.E  D
	..W ","_##class(web.DHCADVJSONCOMMON).getJsonData(Title,mdata)
	
	W ##class(web.DHCADVJSONCOMMON).getJsonEndSign() //输出json结尾符
	D ..killTmpGlobal(pid)
	Q ""
}

/// Creator:    huaxiaoying 
/// CreateDate: 2017-02-23
/// Descript:   获取陪送验证码
/// DO ##class(User.DHCDisStatusAdd).%BuildIndices()
/// w ##class(web.DHCDISRequest).getVerfiyCode()
ClassMethod getVerfiyCode(type)
{
	n (type)
	s text=""
	while text=""{
		s code=$r(999999)
		s code=$j(code,6)
		s code=$REPLACE(code," ",0)
		i $d(^DHCDISRC(0,"CreateDate",+$h,code))=0{
			s text=code	
		}	
	}
	//s text=$SYSTEM.Encryption.GenCryptRand(5,1)
 	//s text=$SYSTEM.Encryption.Base64Encode(text) 
	q text
}

/// Creator:    zwq
/// CreateDate: 2017-06-05
/// Descript:   根据选择条件获取病人列表
/// W ##Class(web.DHCDISRequest).SelByAdm("","1","200","197^^^^16/01/2019^16/01/2019","197","") 
ClassMethod SelByAdm(SelByAdm, page, rows, Str, LocID, WardID)
{
	n (SelByAdm,page,rows,Str,LocID,WardID)
	s ^tempsufan("111")=$lb(SelByAdm, page, rows, Str, LocID, WardID)
	i SelByAdm=""  d
	.d ..getWardPat(page,rows,"",Str,LocID,WardID)
	e  d
	.d ..GetEOPatient(Str,page,rows)
	
	q ""
}

/// Creator:    zhouxin
/// CreateDate: 2016-02-4
/// Descript:   获取登录病区下病人列表
/// W ##Class(web.DHCDISRequest).getWardPat("","1","200","236^^^","236","44") 
ClassMethod getWardPat(page, rows, InPatNo = "", Str, LocID, WardID)
{
	n (page,rows,InPatNo,Str,LocID,WardID)
	s End = page*rows
	s Start=(page-1)*rows+1
	s AdmVisDept=$p(Str,"^",1)		//科室
	s AdmVisDate=$p(Str,"^",2)		//时间
	s AdmVisName=$p(Str,"^",3)		//姓名
	s PatRegNo=$p(Str,"^",4)		//
	Set sessionWardID=WardID				//+%session.Get("LOGON.WARDID")
	s pid=$i(^DHCST("DHCDIS"))
	s bedpid=0
	s h=0
	b   //LocID
	///取最近一次就诊记录
	If (+sessionWardID=0)&(InPatNo'="") D
	.s papmi=$o(^PAPERi("PAPMI_PatNo",InPatNo,""))
	.q:papmi=""
	.s AdmDr=$o(^PAPERdr(papmi,"ADM","I",""),-1)
	.q:AdmDr=""
	.d getPatInfo
	E   d
	.s wardID=""
	.q:LocID=""
	.f  s wardID=$o(^PAWARD(0,"WARD_LocationDR",LocID,wardID)) Q:wardID=""  D
	..s curRoomDr=""
	..q:(+sessionWardID'=0)&&(sessionWardID'=wardID)
	..f  s curRoomDr=$o(^PAADMi("CurrWard",wardID,curRoomDr)) q:curRoomDr=""  d
	...s AdmDr=""
	...f  s AdmDr=$o(^PAADMi("CurrWard",wardID,curRoomDr,AdmDr)) q:AdmDr=""  d
    ....s patVisit=$p($g(^PAADM(AdmDr)),"^",20)
    ....q:(patVisit'="A")&&(patVisit'="P")
    ....q:$p(^PAADM(AdmDr),"^",2)'="I"
	....d getPatInfo
      
	  s count=0
	  w "{""rows"":["
	  s tmp=""
	  f  s tmp=$o(^TMP("DHCST","web.DHCDISRequest","getWardPat",pid,tmp)) q:tmp=""  d
	  .s bedindex=""
	  .for  s bedindex=$o(^TMP("DHCST","web.DHCDISRequest","getWardPat",pid,tmp,bedindex)) q:bedindex=""  d
	  ..s index=0
	  ..f  s index=$o(^TMP("DHCST","web.DHCDISRequest","getWardPat",pid,tmp,bedindex,index)) q:index=""  d
	  ...s count=count+1
	  ...q:count<Start
	  ...q:count>End
	  ...w $case(count,Start:"",:",")
	  ...s str=^TMP("DHCST","web.DHCDISRequest","getWardPat",pid,tmp,bedindex,index)
	  ...s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  ...d jsonObj.Put("ADMDate",$p(str,"^",1))
	  ...d jsonObj.Put("PatNo",$p(str,"^",3))
	  ...d jsonObj.Put("PatName",$p(str,"^",4))
	  ...d jsonObj.Put("PatBed",$p(str,"^",2))
	  ...d jsonObj.Put("Adm",$p(str,"^",5)) //hxy   就诊号对应ID
	  ...d jsonObj.Put("AdmWard",$p(str,"^",6)) //hxy
	  ...d jsonObj.Put("AdmWardDr",$p(str,"^",7)) //hxy
	  ...d jsonObj.Put("BedId",$p(str,"^",8)) //hxy
	  ...d jsonObj.Put("HosNo",$p(str,"^",9)) //zhl
	  ...d jsonObj.Put("ADMSex",$p(str,"^",10)) //zwq
	  ...w jsonObj.Json() 
	  w "],""total"":"_count_"}"
	  k ^TMP("DHCST","web.DHCDISRequest","getWardPat",pid)
	  q ""
getPatInfo
	s admdate=$p(^PAADM(AdmDr),"^",6) //就诊日期
	s admvisdept=$p(^PAADM(AdmDr),"^",4) //就诊科室
	;q:(AdmVisDept'="")&&(admvisdept'=AdmVisDept)
	s admvisdate=$p(^PAADM(AdmDr),"^",6) //就诊日期
	s:AdmVisDate'="" AdmVisDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(AdmVisDate)
	q:(AdmVisDate'="")&&(admvisdate'=AdmVisDate)
	s papmidr=$p(^PAADM(AdmDr),"^",1)  //患者基本信息表ID
	s papmisexdr=$p(^PAPER(papmidr,"ALL"),"^",7) //性别表ID
	s admsex=$p(^CT("SEX",papmisexdr),"^",2)  //患者性别
	s admtime=$p(^PAADM(AdmDr),"^",7) //就诊时间
	i admdate'="" s admdate=##class(web.DHCDISCommonDS).DateLogicalToHtml(admdate) //$zd(admdate,3)
	i admtime'="" s admtime=$zt(admtime,1)
	s admdate=admdate_" "_admtime
	s admward=""
	s admwarddr=$p(^PAADM(AdmDr),"^",70)  //病区
	i admwarddr'="" s admward=$p(^PAWARD(admwarddr),"^",2)
	s AdmLoc=""
	i admwarddr'="" s AdmLoc=$p(^PAWARD(admwarddr),"^",5)
	q:(AdmVisDept'="")&&(AdmLoc'=AdmVisDept)
	s bedBSequence=""
	S bedid=$p(^PAADM(AdmDr),"^",73) //床号
 I bedid="" S AdmBed=""
 E  d
 .S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
 .s bedBSequence=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",24)
	s admbed=""
	s papmi=$p(^PAADM(AdmDr),"^",1)
    s patname=$p(^PAPER(papmi,"ALL"),"^",1)  //患者姓名
    s patname2=$p(^PAPER(papmi,"ALL"),"^",2)  //患者姓名拼音首字母
    s AdmName=patname2_"-"_patname
    s AdmVisName=$$ALPHAUP^SSUTIL4(AdmVisName)
   	q:(AdmVisName'="")&&(AdmName'[AdmVisName)
    s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    q:(PatRegNo'="")&&(patno'=PatRegNo)
    s hosno=##class(web.DHCDISInterface).GetMrNoByEpisodeID(AdmDr)   //sufan 20200513
   	q:(InPatNo'="")&(InPatNo'=patno)
	s data=admdate_"^"_AdmBed_"^"_patno_"^"_patname_"^"_AdmDr_"^"_admward_"^"_admwarddr_"^"_bedid_"^"_hosno_"^"_admsex //hxy   加_"^"_AdmDr...;;;zhl  加_"^"_hosno
	s h=h+1
	i admwarddr'=""  d
	.s ^TMP("DHCST","web.DHCDISRequest","getWardPat",pid,admwarddr,+bedBSequence,h)=data
}

/// W ##Class(web.DHCDISRequest).GetEOPatient("^^","1","60")
ClassMethod GetEOPatient(Str, page = 1, rows = 60)
{
	s End = page*rows
	s Start=(page-1)*rows+1
	s pid=$i(^DHCST("DHCDIS"))
	s bedpid=0
	s h=0
	
	s AdmVisDept=$p(Str,"^",1)    //就诊科室
	s AdmVisDate=$p(Str,"^",2)	  //就诊日期
	s AdmVisName=$p(Str,"^",3)	  //患者姓名
	s PatRegNo=$p(Str,"^",4)	  //登记号
	s StDate=$p(Str,"^",5)		  //开始日期
	s EndDate=$p(Str,"^",6)		  //结束日期
	s StDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(StDate)
	s EndDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(EndDate)
	f DD=StDate:1:EndDate d
	.s AdmDr=""
	.f  s AdmDr=$o(^PAADMi("PAADM_AdmDate",DD,AdmDr)) q:AdmDr=""  d
	..s AdmType=$p(^PAADM(AdmDr),"^",2)  //就诊类型
	..q:AdmType="I"
	..s PatVisit=$p($g(^PAADM(AdmDr)),"^",20)
    ..q:PatVisit'="A"
    ..d getPatInfoo
	
	s count=0
	  w "{""rows"":["
	  s h=0
	  f  s h=$o(^TMP("DHCST","web.DHCDISRequest","getWardPat",pid,h)) q:h=""  d
	  .s count=count+1
	  .q:count<Start
	  .q:count>End
	  .w $case(count,Start:"",:",")
	  .s str=^TMP("DHCST","web.DHCDISRequest","getWardPat",pid,h)
	  .s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  .d jsonObj.Put("ADMDate",$p(str,"^",1))
	  .d jsonObj.Put("PatNo",$p(str,"^",3))
	  .d jsonObj.Put("PatName",$p(str,"^",4))
	  .d jsonObj.Put("PatBed",$p(str,"^",2))
	  .d jsonObj.Put("Adm",$p(str,"^",5)) //hxy   就诊号对应ID
	  .d jsonObj.Put("AdmWard",$p(str,"^",6)) //hxy
	  .d jsonObj.Put("AdmWardDr",$p(str,"^",7)) //hxy
	  .d jsonObj.Put("BedId",$p(str,"^",8)) //hxy
	  .d jsonObj.Put("HosNo",$p(str,"^",9)) //zhl
	  .d jsonObj.Put("ADMSex",$p(str,"^",10)) //zwq
	  .w jsonObj.Json() 
	  w "],""total"":"_count_"}"
	  k ^TMP("DHCST","web.DHCDISRequest","getWardPat",pid)
	  q ""
getPatInfoo
	
	s admdate=$p(^PAADM(AdmDr),"^",6) //就诊日期
	s admvisdept=$p(^PAADM(AdmDr),"^",4) //就诊科室
	;q:admvisdept'=AdmVisDept
	;q:(AdmVisDept'="")&&(admvisdept'=AdmVisDept)
	s admvisdate=$p(^PAADM(AdmDr),"^",6) //就诊日期
	s:AdmVisDate'="" AdmVisDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(AdmVisDate)
	q:(AdmVisDate'="")&&(admvisdate'=AdmVisDate)
	s papmidr=$p(^PAADM(AdmDr),"^",1)  //患者基本信息表ID
	s papmisexdr=$p(^PAPER(papmidr,"ALL"),"^",7) //性别表ID
	s admsex=$p(^CT("SEX",papmisexdr),"^",2)  //患者性别
	s admtime=$p(^PAADM(AdmDr),"^",7) //就诊时间
	i admdate'="" s admdate=##class(web.DHCDISCommonDS).DateLogicalToHtml(admdate) //$zd(admdate,3)
	i admtime'="" s admtime=$zt(admtime,1)
	s admdate=admdate_" "_admtime
	s admward=""
	s admwarddr=$p(^PAADM(AdmDr),"^",70)  //病区
	i admwarddr'="" s admward=$p(^PAWARD(admwarddr),"^",2)
	S bedid=$p(^PAADM(AdmDr),"^",73) //床号
    I bedid="" S AdmBed=""
    E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	s admbed=""
	s papmi=$p(^PAADM(AdmDr),"^",1)
    s patname=$p(^PAPER(papmi,"ALL"),"^",1)  //患者姓名
    s patname2=$p(^PAPER(papmi,"ALL"),"^",2)  //患者姓名拼音首字母
    s AdmName=patname2_"-"_patname
    s AdmVisName=$$ALPHAUP^SSUTIL4(AdmVisName)
    q:(AdmVisName'="")&&(AdmName'[AdmVisName)
    s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    q:(PatRegNo'="")&&(patno'=PatRegNo)
    s hosno=##class(web.DHCDISInterface).GetMrNoByEpisodeID(AdmDr)   //sufan 20200513
    ;q:(InPatNo'="")&(InPatNo'=patno)
	s data=admdate_"^"_AdmBed_"^"_patno_"^"_patname_"^"_AdmDr_"^"_admward_"^"_admwarddr_"^"_bedid_"^"_hosno_"^"_admsex //hxy   加_"^"_AdmDr...;;;zhl  加_"^"_hosno
	s h=h+1
	s ^TMP("DHCST","web.DHCDISRequest","getWardPat",pid,h)=data
	q 0
}

/// Creator:    zhouxin
/// CreateDate: 2016-02-4
/// Descript:   获取登录病区下已申请病人列表
/// W ##Class(web.DHCDISRequest).listRequest() 
ClassMethod listRequest(page = 1, rows = 60, st = "", ed = "")
{
	n (%session,page,rows,st,ed)
	s End = page*rows
	s Start=(page-1)*rows+1
	Set sessionWardID=+%session.Get("LOGON.WARDID")
    
	;s sessionWardID=54 //本应注释 1 ：鑫哥原本测试数据
	s st=$case(+st,0:+$h-10,:##class(web.DHCDISCommonDS).DateHtmlToLogical(st)) //$zdh(st,3)
	s ed=$case(+ed,0:+$h,:##class(web.DHCDISCommonDS).DateHtmlToLogical(ed)) //$zdh(ed,3)
	s count=0
	w "{""rows"":["
	f date=st:1:ed d
	.s req=""
	.f  s req=$o(^DHCDISRE("0","WardDate",sessionWardID,date,req)) q:req=""  d
	..
    ..s count=count+1
	..q:count<Start
	..q:count>End
	..w $case(count,Start:"",:",")
	..
	..s papmi=$p(^DHCDISRE(req),"^",5)
	..s bedid=+$p(^DHCDISRE(req),"^",3)
	..s createdate=##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISRE(req),"^",13)) //$zd($p(^DHCDISRE(req),"^",13),3)
	..s createtime=$zt($p(^DHCDISRE(req),"^",14))
	..s exedate=##class(web.DHCDISCommonDS).DateLogicalToHtml($p(^DHCDISRE(req),"^",7)) //$zd($p(^DHCDISRE(req),"^",7),3)
	..s exetime=$zt($p(^DHCDISRE(req),"^",8))
	..s AdmDr=$p(^DHCDISRE(req),"^",4)
	..S bedid=$p(^PAADM(AdmDr),"^",73) //床号
	..s patbed=$case(bedid,0:"",:$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1))
	..s patname=$p(^PAPER(papmi,"ALL"),"^",1)
    ..s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    ..s REQNo="",REQWard="",Remarks="" //hxy start
    ..s REQNo=$p(^DHCDISRE(req),"^",1) 
    ..s REQWardDr=$p(^DHCDISRE(req),"^",2) 
    ..i REQWardDr'="" s REQWard=$p(^PAWARD(REQWardDr),"^",2) 
    ..s REQRecLocDr=$p(^DHCDISRE(req),"^",6) 
    ..s EscortTypeDr=$p(^DHCDISRE(req),"^",9) 
    ..s EscortToolDr=$p(^DHCDISRE(req),"^",10) 
    ..s Nums=$p(^DHCDISRE(req),"^",11) 
    ..s Remarks=$p(^DHCDISRE(req),"^",12) //hxy end
    ..
	..s jsonObj=##class(web.DHCAPPJsonObject).%New()
	..d jsonObj.Put("CreateDate",createdate_" "_createtime)
	..d jsonObj.Put("ExeDate",exedate_" "_exetime)
	..d jsonObj.Put("PatNo",patno)
	..d jsonObj.Put("PatName",patname)
	..d jsonObj.Put("PatBed",patbed)
	..d jsonObj.Put("RowId",req) //hxy start
	..d jsonObj.Put("Adm",AdmDr) 
	..d jsonObj.Put("REQNo",REQNo) 
	..d jsonObj.Put("REQWard",REQWard) 
	..d jsonObj.Put("REQRecLocDr",REQRecLocDr) 
	..d jsonObj.Put("EscortTypeDr",EscortTypeDr) 
	..d jsonObj.Put("EscortToolDr",EscortToolDr) 
	..d jsonObj.Put("Nums",Nums) 
	..d jsonObj.Put("Remarks",Remarks) //hxy end
	..w jsonObj.Json()
	w "],""total"":"_count_"}"
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCDIS","web.DHCDISRequest","QueryCodeDetail",pid)
}

/// CreateDate: 2017-06-01
/// Creator:    zwq
/// Descript:   整半点时间combobox		
/// Return： 
/// w ##Class(web.DHCDISRequest).IntTime()
ClassMethod IntTime(search As %String = "")
{
    w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text","1^上午")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","2^下午")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","3^晚上")
	s Count=0
	s TimeHour=-1,TimeMinute=-30,j=1
	f i=4:1:52  d
	.s TimeMinute=TimeMinute+30
	.s:TimeMinute=60 TimeMinute="00"
	.s:j=1 TimeHour=TimeHour+1
	.s:$l(TimeMinute)=1 TimeMinute="0"_TimeMinute
	.s:$l(TimeHour)=1 TimeHour="0"_TimeHour
	.s j=j*(-1)
	.s Time=TimeHour_":"_TimeMinute
	.s tmp=i_"^"_Time
	.s Count=Count+1
	.w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text",tmp)
	w "]"
	q ""
}

/// CreateDate: 2017-06-01
/// Creator:    zwq
/// Descript:   时间段		
/// Return： 
/// w ##Class(web.DHCDISRequest).DisTimePart()
ClassMethod DisTimePart()
{
	w "["_##class(web.DHCAPPJsonCommon).getJsonData("id^text","1^上午")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","2^下午")
	w ","_##class(web.DHCAPPJsonCommon).getJsonData("id^text","3^晚上")
	w "]"
	
	q ""
}

/// CreateDate: 2017-11-23
/// Creator:    sufan
/// Descript:   自动安排，获取申请单信息
/// Input:		申请ID,陪送状态ID,操作人,申请科室,安排的护工
/// Return： 
/// w ##Class(web.DHCDISRequest).AutoArrangement("180","11","9","460","")
ClassMethod AutoArrangement(RepID As %String, StatusCode As %String, OperID As %String, RepLoc As %String, EscortPerID As %String) As %String
{
	n (RepID,StatusCode,OperID,RepLoc,EscortPerID)
	s ^temptets(11)=$lb(RepID,StatusCode,OperID,RepLoc,EscortPerID)
	s ret=0
	s RepWard=$p(^DHCDISRE(RepID),"^",2)    			// 申请病区
	s EscStatusID=$p(^DHCDISRE(RepID),"^",18)			// 陪送状态ID
	if EscortPerID="" d									// 此处走科室申请安排
	.s EscTime=$p(^DHCDISRE(RepID),"^",19)				// 陪送时间
	.q:'$d(^DHCDISLU(0,"Loc",RepLoc)) 					// 判断科室人员关联表是否存在数据
	.s LocUserID=$o(^DHCDISLU(0,"Loc",RepLoc,""))		// 科室人员关联表ID
	.s EscNursID=$p(^DHCDISLU(LocUserID),"^",2)			// 护工ID
	.s Active=$p(^DHCDISLU(LocUserID),"^",3)				//激活标志
	.b   //Active
	.q:Active'="Y"
	.s Sub=$o(^DHCDISRE(RepID,"Itm",""),-1)				// 申请子表sub
	.s RepItemType=$p(^DHCDISRE(RepID,"Itm",Sub),"^",2)	// 陪送类型（检查或者其他）
	.b   ///RepItemType
	.q:RepItemType'="Ord" 								// 其他项目需要手动安排
	.q:EscTime="晚上" 									// 晚上的项目需要手动安排
	.if EscTime="上午"  d
	..s ret=##class(web.DHCDISEscortArrage).ArrangeToo(RepID,EscStatusID,EscNursID,StatusCode,OperID)  //调安排方法
	.else  if (EscTime="下午") d
	..s ret=##class(web.DHCDISEscortArrage).ArrangeToo(RepID,EscStatusID,EscNursID,StatusCode,OperID)
	.else  d
	..s EscTime=$zth(EscTime,3)
	..if (EscTime>=$zth("09:00:00",3))&&(EscTime<=$zth("19:00:00",3)) d
	...s ret=##class(web.DHCDISEscortArrage).ArrangeToo(RepID,EscStatusID,EscNursID,StatusCode,OperID)
	e  d											// 陪送中心直接安排
	.s ret=##class(web.DHCDISEscortArrage).ArrangeToo(RepID,EscStatusID,EscortPerID,StatusCode,OperID)  //调安排方法
	q ret
}

/// CreateDate: 2017-12-27
/// Creator:    sufan
/// Descript:   判断陪送的项目是否重复
/// Return： 	重复项目的描述
/// w ##Class(web.DHCDISRequest).isReqItmRepeat("595066^21^21||13^2728^0000460757^^04/01/2018  晚上^4^1^1^^216^3084","2698||12^Ord^451$$")
ClassMethod isReqItmRepeat(str, strObjs)
{
	n (str,strObjs)
	s ItemList=""
	s REQAdm=$p(str,"^",4)		///就诊号
	s len=$l(strObjs,"$$")-1
	for i=1:1:len d 
	.s strObj=$p(strObjs,"$$",i)
	.s REQItem=$p(strObj,"^",1)
	.s ret=..GetRepeatItem(REQAdm,REQItem)		///取重复的项目
	.i ItemList="" s ItemList=ret
	.e  s ItemList=ItemList_"、"_ret
	q ItemList
}

/// CreateDate: 2017-12-27
/// Creator:    sufan
/// Descript:   取出所有重复的项目
/// Input:		就诊号,申请项目ID
/// Return： 	所有重复的项目 
/// w ##Class(web.DHCDISRequest).GetRepeatItem("1345","1281||3")
ClassMethod GetRepeatItem(Adm, ReqItem)
{
	n (Adm,ReqItem)
	s ReqID="",ItemDesc=""
	for  s ReqID=$o(^DHCDISRE(0,"Adm",Adm,ReqID)) q:ReqID=""  d		///陪送申请主表ID
	.s curStatusId = $p(^DHCDISRE(ReqID),"^",16)
	.s statusCode = $p(^DHCDISSA(curStatusId),"^",1)
	.Q:statusCode=100																																			///过滤掉已撤销的
	.s CH=""
	.for  s CH=$o(^DHCDISRE(ReqID,"Itm",CH)) q:CH=""  d				///子表		
	..s ItemType=$p(^DHCDISRE(ReqID,"Itm",CH),"^",2)				///陪送项目类型，'Oth'--其他,'Ord'--医嘱
	..s ItemID=$p(^DHCDISRE(ReqID,"Itm",CH),"^",1)
	..q:ReqItem'=ItemID
	..i ItemType="Oth" d
	...s ItemDesc=$p(^DHCDISLI(ItemID),"^",2)		///项目描述
	..e  d
	...s arcimid=$p(^OEORD($p(ItemID,"||",1),"I",$p(ItemID,"||",2),1),"^",2)		///医嘱项ID
	...s ItemDesc=$p(^ARCIM($p(arcimid,"||",1),$p(arcimid,"||",2),1),"^",2)			///医嘱项描述
	
	q ItemDesc
}

/// CreateDate: 2017-01-02
/// Creator:    sufan
/// Descript:   按接收科室查询患者列表
/// Input:		str
/// Return： 	患者信息json串
/// W ##Class(web.DHCDISRequest).getPatListByLoc("1","20","","26^^AA^") 
ClassMethod getPatListByLoc(page, rows, SelByAdm, Str)
{
	n (page,rows,SelByAdm,Str)
	s LocID=$p(Str,"^",1)   	///就诊科室
	s AdmDate=$p(Str,"^",2) 	///就诊日期
	s PatName=$p(Str,"^",3)		///姓名
	s RecLoc=$p(Str,"^",4)		///接收科室
	s PatNo=$p(Str,"^",5)		///登记号
	s End = page*rows
	s Start=(page-1)*rows+1
	s pid=$i(^DHCST("DHCDIS"))
	s bedpid=0
	s h=0
	i (LocID="")&&(PatNo'="") d
	.s PatientID=$O(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),""))
	.s Process=""
	.for  s Process=$o(^PAPRi("PAPMI",PatientID,Process))  q:Process=""  d
	..s AdmDr=""
	..for  s AdmDr=$o(^PAPRi("PAPMI",PatientID,Process,AdmDr))  q:AdmDr=""  d
	...s patVisit=$p($g(^PAADM(AdmDr)),"^",20)
    ...s AdmType=$p(^PAADM(AdmDr),"^",2)  //就诊类型
    ...q:(SelByAdm'="")&&(AdmType="I")
    ...q:patVisit'="A"
	...d getPatInfoByLoc
	e  d
	.s wardID=""
	.f  s wardID=$o(^PAWARD(0,"WARD_LocationDR",LocID,wardID)) Q:wardID=""  D
	..s curRoomDr=""
	..;q:(sessionWardID'=0)&&(sessionWardID'=wardID)
	..f  s curRoomDr=$o(^PAADMi("CurrWard",wardID,curRoomDr)) q:curRoomDr=""  d
	...s AdmDr=""
	...f  s AdmDr=$o(^PAADMi("CurrWard",wardID,curRoomDr,AdmDr)) q:AdmDr=""  d
    ....s patVisit=$p($g(^PAADM(AdmDr)),"^",20)
    ....s AdmType=$p(^PAADM(AdmDr),"^",2)  //就诊类型
    ....q:(SelByAdm'="")&&(AdmType="I")
    ....q:patVisit'="A"
	....d getPatInfoByLoc
      
	  s count=0
	  w "{""rows"":["
	  s tmp=""
	  f  s tmp=$o(^TMP("DHCST","web.DHCDISRequest","getPatListByLoc",pid,tmp)) q:tmp=""  d
	  .s h=0
	  .f  s h=$o(^TMP("DHCST","web.DHCDISRequest","getPatListByLoc",pid,tmp,h)) q:h=""  d
	  ..s count=count+1
	  ..q:count<Start
	  ..q:count>End
	  ..w $case(count,Start:"",:",")
	  ..s str=^TMP("DHCST","web.DHCDISRequest","getPatListByLoc",pid,tmp,h)
	  ..s jsonObj=##class(web.DHCAPPJsonObject).%New()
	  ..d jsonObj.Put("ADMDate",$p(str,"^",1))
	  ..d jsonObj.Put("PatNo",$p(str,"^",3))
	  ..d jsonObj.Put("PatName",$p(str,"^",4))
	  ..d jsonObj.Put("PatBed",$p(str,"^",2))
	  ..d jsonObj.Put("Adm",$p(str,"^",5)) 			//hxy   就诊号对应ID
	  ..d jsonObj.Put("AdmWard",$p(str,"^",6)) 		//hxy
	  ..d jsonObj.Put("AdmWardDr",$p(str,"^",7)) 	//hxy
	  ..d jsonObj.Put("BedId",$p(str,"^",8)) 		//hxy
	  ..d jsonObj.Put("HosNo",$p(str,"^",9)) 		//zhl
	  ..d jsonObj.Put("ADMSex",$p(str,"^",10)) 		//zwq
	  ..w jsonObj.Json() 
	  w "],""total"":"_count_"}"
	  k ^TMP("DHCST","web.DHCDISRequest","getPatListByLoc",pid)
	  q ""
getPatInfoByLoc
	s admdate=$p(^PAADM(AdmDr),"^",6) //就诊日期
	s admvisdept=$p(^PAADM(AdmDr),"^",4) //就诊科室
	s admvisdate=$p(^PAADM(AdmDr),"^",6) //就诊日期
	s:AdmDate'="" AdmDate=##class(web.DHCDISCommonDS).DateHtmlToLogical(AdmDate)
	q:(AdmDate'="")&&(admvisdate'=AdmDate)
	s papmidr=$p(^PAADM(AdmDr),"^",1)  //患者基本信息表ID
	s papmisexdr=$p(^PAPER(papmidr,"ALL"),"^",7) //性别表ID
	s admsex=$p(^CT("SEX",papmisexdr),"^",2)  //患者性别
	s admtime=$p(^PAADM(AdmDr),"^",7) //就诊时间
	i admdate'="" s admdate=##class(web.DHCDISCommonDS).DateLogicalToHtml(admdate) //$zd(admdate,3)
	i admtime'="" s admtime=$zt(admtime,1)
	s admdate=admdate_" "_admtime
	s admward=""
	s admwarddr=$p(^PAADM(AdmDr),"^",70)  //病区
	i admwarddr'="" s admward=$p(^PAWARD(admwarddr),"^",2)
	S bedid=$p(^PAADM(AdmDr),"^",73) //床号
    I bedid="" S AdmBed=""
    E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	s admbed=""
	s papmi=$p(^PAADM(AdmDr),"^",1)
    s patname=$p(^PAPER(papmi,"ALL"),"^",1)  //患者姓名
    s patname2=$p(^PAPER(papmi,"ALL"),"^",2)  //患者姓名拼音首字母
    s AdmName=patname2_"-"_patname
    s PatName=$$ALPHAUP^SSUTIL4(PatName)
    q:(PatName'="")&&(AdmName'[PatName)
    s patno=$p(^PAPER(papmi,"PAT",1),"^",1)
    q:(PatNo'="")&&(patno'=PatNo)
    s hosno=##class(web.DHCDISInterface).GetMrNoByEpisodeID(AdmDr)   //sufan 20200513
	s data=admdate_"^"_AdmBed_"^"_patno_"^"_patname_"^"_AdmDr_"^"_admward_"^"_admwarddr_"^"_bedid_"^"_hosno_"^"_admsex //hxy   加_"^"_AdmDr...;;;zhl  加_"^"_hosno
	s h=h+1
	i AdmBed'=""  d
	.s ^TMP("DHCST","web.DHCDISRequest","getPatListByLoc",pid,$p(AdmBed,"床",1),h)=data
}

// 状态默认值设置

ClassMethod getStatusValue(code)
{
	n (code)
	Q:code="" 0
	s ID=$O(^DHCDISSA(0,"Code",code,""))
	Q:ID="" 0
	Q ID
}

/// Creator:sufan
/// CreateDate:2018-11-02
/// Descript:日期和当前日期对比
/// return:1:日期大于等于当前日期 0:小于当前日期
/// w ##class(web.DHCDISRequest).JudgeDate("01/11/2018")
ClassMethod JudgeDate(Date)
{
	n (Date)
	q:Date="" ""
	s ret=1
	s Date=##class(web.DHCDISCommonDS).DateHtmlToLogical(Date)
	Q:Date<+$h 0
	Q ret
}

/// w ##class(web.DHCDISRequest).JudgeTime("")
ClassMethod JudgeTime(Date, Time)
{
	n (Date,Time)
	q:Time="" ""
	s Date=##class(web.DHCDISCommonDS).DateHtmlToLogical(Date)
	s ret=1
	Q:(Time["上午")&&((($p($h,",",2)>43200)&&($p($h,",",2)<86399))||(($p($h,",",2)>0)&&($p($h,",",2)<21600)))&&(Date=+$h) 0
	Q:(Time["下午")&&(($p($h,",",2)>0)&&($p($h,",",2)<43200))&&(Date=+$h) 0
	;Q:(Time["晚上")&&(($p($h,",",2)>21600)&&($p($h,",",2)<64800)) 0
	Q:(Time["上午")&&(Time["下午")&&(Time["晚上") ""
	s Time=Time_":00"
	s Time=$zth(Time,1)
	Q:(Time<$p($h,",",2))&&(Date=+$h) 0
	Q ret
}

}
