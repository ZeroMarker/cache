Include webimport

IncludeGenerator webimport

Class web.DHCSTPCHCOLLS5 Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

//

ClassMethod GetDispenWardList(phaloc As %String, d1 As %String, d2 As %String)
{
	n (phaloc,d1,d2)
	;
	s datefrom=d1
	s dateto=d2 
	s n=0
	k ^TMP($j)
	f dd=d1:1:d2  d 
	.s WardId=""
	.f  s WardId=$o(^DHCCLNurseExec("SendMedic",phaloc,dd,WardId,dispcat,orditm))  q:WardId=""  d
	. . s dispcat="",dispcatlist="" 
	. . f  s dispcat=$o(^DHCCLNurseExec("SendMedic",phaloc,dd,WardId,dispcat,orditm)) q:dispcat=""  d
	. . . i '$d(^TMP($j,WardId,dispcat)) d
	. . . . s n=n+1
	. . . . s ^TMP($j,WardId,dispcat)=""
	q n
}

ClassMethod GetDispWardClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDispWardExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDispWardExecute(ByRef qHandle As %Binary, displocrowid As %String, StartDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, wardrowid As %String, pri, locgrpid) As %Status
{
	//s ^zdm("GetDispWardExecute")=displocrowid_"^"_StartDate_"^"_EndDate_"^"_StartTime_"^"_EndTime_"^"_wardrowid_"^"_pri_"^"_locgrpid
	//add wyx 增加locgrpid科室组
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	
	q:displocrowid="" $$$OK
	
	;q:StartDate="" $$$OK
	;q:EndDate="" $$$OK
	s TCat0="",TCat1="",TCat2="",TCat3="",TCat4="",TCat5="",TCat6="",TCat7="",TCat8="",TCat9=""
	s TCat0Code="",TCat1Code="",TCat2Code="",TCat3Code="",TCat4Code="",TCat5Code="",TCat6Code="",TCat7Code="",TCat8Code="",TCat9Code=""
	s TWard="病区"
	s TSelect="选择"
	;------------旧版用------
	;获取设置
    s DisplayOut=##Class(web.DHCSTKUTIL).GetPhaConfig("Con_DisplayOut")
    ;s DisplayOut=1
	;s allcats=..GetAllDispCats(displocrowid)
	;q:allcats="" $$$OK
	;
	;i DisplayOut=1 d
	;.s outcat="OUT"_"@"_"出院带药"
	;.s emy="EMY"_"@"_"急煎"
	;.s allcats=allcats_"^"_outcat_"^"_emy
 	;-----------------------
 	s allcats=##class(web.DHCSTPHALOC).GetPhaLocDispType(displocrowid)
 	q:allcats="" $$$OK
	s cnt=$l(allcats,"^")
	f i=1:1:cnt d
	.s cat=$p(allcats,"^",i)
	.d setcatcode(i,cat)
	;d outputrow
	
	s d1=StartDate
	s d2=EndDate
	s t1=StartTime
	s t2=EndTime
	s phaloc=displocrowid
	s result=..DispensingWards(phaloc,d1,d2,t1,t2,pri)	
	s cnt=$p(result,"^",1)
	s pid=$p(result,"^",2)
	q:cnt=0 $$$OK
    ;-------------------------------------
	;药品类别显示
	s WardId=""
	f  s WardId=$o(^TMP(pid,"DISPWARDCATS",WardId)) q:WardId=""  d
	. d resetvariables
	. q:(wardrowid'="")&&(wardrowid'=WardId)
	. q:##class(web.DHCSTCNTSIPMONITOR).CheckWard(locgrpid,WardId)=0 //add wyx 2014-12-08 科室组的过滤
	. &sql(select ward_locationdr into :locdr from pac_ward where ward_rowid=:WardId)
	. q:$g(locdr)="" 
	. s TWard=$p(^CTLOC(locdr),"^",2)
	.
	. ;s TCat0="",TCat1="",TCat2="",TCat3="",TCat4="",TCat5="",TCat6="",TCat7="",TCat8="",TCat9=""
	. s dispcat=""
	. f  s dispcat=$o(^TMP(pid,"DISPWARDCATS",WardId,dispcat)) q:dispcat=""  d
	. .s ^TMP(pid,"WARDCATS",TWard,dispcat)=""
	;-------------------------------------
	;其它显示:出院带药 , 加急
	s TWard=""
	f  s TWard=$o(^TMP(pid,"WARDCATS",TWard)) q:TWard=""  d
	.s WardId=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(TWard),"")) 
	. s TCat0="",TCat1="",TCat2="",TCat3="",TCat4="",TCat5="",TCat6="",TCat7="",TCat8="",TCat9=""
	. s cat=""
	. f  s cat=$o(^TMP(pid,"WARDCATS",TWard,cat)) q:cat=""  d
	. .i ((cat="EMY") || (cat="OUT")) s onplay=1
	. .d seekcat(cat) 
	. s TWardRowid=WardId
	.d outputrow
	d openplay  ;调用player	
	k ^TMP(pid,"WARDCATS")
	k ^TMP(pid,"DISPWARDCATS")
	;k ^TMP(pid,"WAITOUT")
	k ^TMP(pid,"WAITOTHER")
	Quit $$$OK
	
outputrow
	s TMPWard=TWard
	i TMPWard["-" s TMPWard=$p(TMPWard,"-",2)
	s Data=$lb(TMPWard,TCat0,TCat1,TCat2,TCat3,TCat4,TCat5,TCat6,TCat7,TCat8,TCat9,TWardRowid)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
resetvariables
	s (TWard,TCat0,TCat1,TCat2,TCat3,TCat4,TCat5,TCat6,TCat7,TCat8,TCat9,TWardRowid)=""
	q
seekcat(catcode)
   ; s TCat0="",TCat1="",TCat2="",TCat3="",TCat4="",TCat5="",TCat6="",TCat7="",TCat8="",TCat9=""
    s flag="Yes"
    s flag="1"
    ;i $d(^DHCDispWard(pid,"WAITOUT",WardId,catcode)) &(DisplayOut=1) d
    ;.s catcode="OUT"
    ;.
	i catcode=TCat0Code s TCat0=flag q
	i catcode=TCat1Code s TCat1=flag q
	i catcode=TCat2Code s TCat2=flag q
	i catcode=TCat3Code s TCat3=flag q
	i catcode=TCat4Code s TCat4=flag q
	i catcode=TCat5Code s TCat5=flag q
	i catcode=TCat6Code s TCat6=flag q
	i catcode=TCat7Code s TCat7=flag q
	i catcode=TCat8Code s TCat8=flag q
	i catcode=TCat9Code s TCat9=flag q
	q

setcatcode(i,result)
	s i=i-1
	i i=0  d
	.s TCat0Code=$p(result,"@",1)
	.s TCat0=$p(result,"@",2)
	i i=1  d
	.s TCat1Code=$p(result,"@",1)
	.s TCat1=$p(result,"@",2)
	i i=2  d
	.s TCat2Code=$p(result,"@",1)
	.s TCat2=$p(result,"@",2)
	i i=3  d
	.s TCat3Code=$p(result,"@",1)
	.s TCat3=$p(result,"@",2)
	i i=4  d
	.s TCat4Code=$p(result,"@",1)
	.s TCat4=$p(result,"@",2)
	i i=5  d
	.s TCat5Code=$p(result,"@",1)
	.s TCat5=$p(result,"@",2)
	i i=6  d
	.s TCat6Code=$p(result,"@",1)
	.s TCat6=$p(result,"@",2)
	i i=7  d
	.s TCat7Code=$p(result,"@",1)
	.s TCat7=$p(result,"@",2)
	i i=8  d
	.s TCat8Code=$p(result,"@",1)
	.s TCat8=$p(result,"@",2)
	i i=9  d
	.s TCat9Code=$p(result,"@",1)
	.s TCat9=$p(result,"@",2)
	q
openplay
    Write !,"<SCRIPT language=""Javascript"">",!
	w "playfalg=0;",!
	i $g(onplay)=1  w "playfalg=1;",!
	w "</SCRIPT>"
	q
}

ClassMethod GetDispWardFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDispWardExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetDispWard(displocrowid As %String, StartDate As %String, EndDate As %String, StartTime As %String, EndTime As %String, wardrowid As %String, pri, locgrpid) As %Query(ROWSPEC = "TWard:%String,TCat0:%String,TCat1:%String,TCat2:%String,TCat3:%String,TCat4:%String,TCat5:%String,TCat6:%String,TCat7:%String,TCat8:%String,TCat9:%String,TWardRowid:%String")
{
}

ClassMethod GetZTS() As %String
{
	s a=$$ALPHAUP^SSUTIL4($ZTIMESTAMP)
	s a1=$p(a,",",1)
	s a2=$p(a,",",2)
	s a=$j_a1_a2
	q a
}

ClassMethod GetAllDispCats(loc As %String) As %String
{
 s pl=$o(^DHCPL(0,"Loc",loc,""))
 q:pl="" ""        
 s ch=0
 s i=0
 s result=""
 f   s ch=$o(^DHCPL(pl,"DIS",ch)) q:ch=""  d
 . s i=i+1
 . s distype=$p(^DHCPL(pl,"DIS",ch),"^",1)
 . s catcode=$p(^DHCSTDRUGGRP(distype),"^",1) 
 . s catdesc=$p(^DHCSTDRUGGRP(distype),"^",2)    
 . s sdg=catcode_"@"_catdesc
 . i result=""  s result=sdg
 . e  s result=result_"^"_sdg
  q result
 
 ;&sql(declare xx cursor for select sdg_code,sdg_desc From DHCStkDrugGroup)
 ;s result=""
 ;&sql(open xx)
 ;f  &sql(fetch xx into :catcode,:catdesc) q:SQLCODE  d
 ;. s sdg=catcode_"@"_catdesc
 ;. i result=""  s result=sdg
 ;. e  s result=result_"^"_sdg
 ;. .
 ;&sql(close xx)
 ;q result
}

ClassMethod GetDispCatCode(oeori As %String) As %String
{
 n (oeori)
 s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
 q:ord="" "" q:itm="" "" q:'$d(^OEORD(ord,"I",itm,1)) ""
 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2) q:arcim="" ""
 s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
 q:sub="" "" q:ver="" "" q:'$d(^ARCIM(sub,ver,1))
 s arcic=$p(^ARCIM(sub,ver,1),"^",10) q:arcic="" ""
 &sql(select sdgi_sdg_parref->sdg_code into :sdgcode 
	 From DHCStkDrugGrpitm where sdgi_ordercat_dr=:arcic)
 q $g(sdgcode)
}

ClassMethod GetDispWardCnt(displocrowid As %String, startdate As %String, enddate As %String) As %String
{
 //Retrieve the wards that have dispensing requests 
 n (startdate,enddate,displocrowid)
 s d1=$zdh(startdate,4)
 s d2=$zdh(enddate,4)
 s phaloc=displocrowid
 s wardnum=0
 f dd=d1:1:d2  d 
 .s WardId=""
 .f  s WardId=$o(^DHCCLNurseExec("SendMedic",phaloc,dd,WardId))  q:WardId=""  d
 . . s wardnum=wardnum+1
 q wardnum
}

ClassMethod DispensingWards(phaloc As %String, sd As %String, ed As %String, st As %String, et As %String, pri) As %String
{
 n (phaloc,sd,ed,st,et,pri)
 s pid=$i(^DHCDispWard("WAITING"))
 ;s DisplayOut=##Class(web.DHCSTKUTIL).GetPhaConfig("Con_DisplayOut")
 ;s DisplayOut=1
 ;i ##class(web.DHCSTPCHCOLLS2).GetOrderTimeHXY() s ed=ed+1 //华西医院医嘱时间控制
 s HospId=$p($g(^CTLOC(phaloc)),"^",22)
 s Params="^"_phaloc_"^^"_HospId
 s NeedSkinTest=##class(web.DHCST.Common.AppCommon).GetAppPropValue("DHCSTORDDISP","SKINTESTFLAG",Params) //皮试配置,为Y时需要判断,yunhaibao20160531
 s i=0
 s n=0
 f Date=sd:1:ed d
 .s WardLoc="" 
 .f  s WardLoc=$o(^DHCOEDISQTY(0,"REC",phaloc,Date,"TC",WardLoc)) q:WardLoc=""  d
 ..s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLoc,""))
  ..q:WardId=""
 ..s Cat=0
 ..f  s Cat=$o(^DHCOEDISQTY(0,"REC",phaloc,Date,"TC",WardLoc,Cat)) q:Cat=""  d
 ...q:$d(^TMP(pid,"DISPWARDCATS",WardId,Cat))       ;如果存在该病区该类别的发药记录，则不再处理该病区下相同类别的医嘱
 ...s Flag=0      ;标识某病区某类别是否已经存在发药记录
 ...s DspId=0
 ...f  s DspId=$o(^DHCOEDISQTY(0,"REC",phaloc,Date,"TC",WardLoc,Cat,DspId)) q:(DspId="")!(Flag=1)  d
 ....s OrdItmRowid=$p(^DHCOEDISQTY(DspId),"^",1)     ;OE_OrdItem表指针
 ....s OrdExeRowid=$p(^DHCOEDISQTY(DspId),"^",3)     ;OE_OrdExec表指针
 ....s Ord=+OrdExeRowid
 ....s Chl=$p(OrdExeRowid,"||",2)
 ....s OreChl=$p(OrdExeRowid,"||",3)
 ....q:Ord=""
 ....q:Chl=""
 ....q:'$d(^OEORD(Ord))
 ....q:'$d(^OEORD(Ord,"I",Chl))
 ....s arcim=$p(^OEORD(Ord,"I",Chl,1),"^",2)
 ....s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
 ....s arcimcat=$P(^ARCIM(sub,ver,1),"^",10)
 ....q:arcimcat="" 
 ....s ArcCatCode=$p(^ARC("IC",arcimcat),"^",1)                       			;医嘱子类代码
 ....s AdmDr=$p(^DHCOEDISQTY(DspId),"^",26)
 ....q:AdmDr=""
 ....s AdmWard=$p(^PAADM(AdmDr),"^",70)  		;病人当前病房
 ....s AdmType=$p($g(^PAADM(AdmDr)),"^",2)
 ....q:AdmType'="I"  							;过滤非住院病人     
 ....q:##class(web.DHCSTCOMMONSRV).GetOrdState(OrdExeRowid)=0  ;判断执行记录状态是否可配药
 ....s TimeDosing=$p(^DHCOEDISQTY(DspId),"^",20)  ;分发时间
 ....q:(Date=sd)&(TimeDosing'="")&(st'="")&(TimeDosing<st)
 ....q:(Date=ed)&(TimeDosing'="")&(et'="")&(TimeDosing>et)
 ....
 ....s PriorDr=$p(^OEORD(Ord,"I",Chl,1),"^",8) 
 ....q:PriorDr=""    									;优先级不存在的不予发放 2006-05-27 
 ....s Priority=$p(^OECPR(PriorDr),"^",1) 			;医嘱优先级代码              
 ....q:Priority["OM" ;自备以及嘱托
 ....//护士领药审核控制
 ....q:##class(web.DHCSTCOMMONSRV).IfAuditByPriority(DspId)=0  ;需要审核但是配药记录未审核则不发药
 ....s SkinTest=##class(web.DHCSTPCHCOLLS2).SkinTest(Ord_"||"_Chl)
 ....q:(NeedSkinTest="Y")&&(SkinTest<0)
 ....s AmtFlag=##class(web.DHCSTPCHCOLLS2).IfCollectDrugAllowed(AdmDr,arcimcat_"^"_Priority)  ;最终结算,则不发药
 ....q:AmtFlag=0
 ....q:##class(web.DHCSTPCHCOLLS2).HaveBeenRefused(DspId)   ;被拒绝发放
 ....i pri'="" q:##Class(web.DHCSTPCHCOLLS5).CheckPrioDispCat(pri,Priority_"#"_Cat)=0  //zhwh 2010-01-02增加
 ....s DoctorLoc=$p(^OEORD(Ord,"I",Chl,7),"^",2)   		;060725
 ....q:##class(web.DHCSTPCHCOLLS).DoctorLocRefuse(phaloc,DoctorLoc)=1 				;病区发药时过滤掉医生科室
 ....q:##class(web.DHCSTKUTIL).GetOrdAuditResult(DspId)'="Y" //禁忌审核不通过	zhouyg 20150108 改为按DspId
 ....//q:##class(web.DHCSTKUTIL).GetOrdAuditResult(Ord_"||"_Chl)'="Y" //禁忌审核不通过
 ....;出院带药
 ....;q:(DisplayOut=0)&(Priority="OUT")
 ....;i (Priority="OUT")&(DisplayOut=1)  s ^TMP(pid,"WAITOTHER",WardId,"OUT")="" q
 ....;加急
 ....s prescno=$p(^OEORD(Ord,"I",Chl,1),"^",14)
 ....;s emy=##class(web.DHCSTPCHCOLLS).GetEmy(prescno)
 ....;i (emy="Y")&(DisplayOut=1)  s ^TMP(pid,"WAITOTHER",WardId,"EMY")=""
 ....;w !,DspId
 ....i '$d(^TMP(pid,"DISPWARDCATS",WardId,Cat)) d
 .....s n=n+1
 .....s ^TMP(pid,"DISPWARDCATS",WardId,Cat)=""
 .....s Flag=1
 ....s i=i+1
 ...
 ..
 .
 i (n=0) & ($d(^TMP(pid,"WAITOTHER"))) s n=1
 q n_"^"_pid
	
DispStatus(ord,itm)
 n (ord,itm)
 s orditm=ord_"||"_itm
 s dsp=$o(^DHCOEDISQTY(0,"OEORI",orditm,"") ) q:dsp="" ""
 s status=$p(^DHCOEDISQTY(dsp),"^",7)
 q status
 
dispcat(arcimcat)
 n (arcimcat)
 s r=$o(^DHCSTDRUGGRP(0,"ORDCAT",arcimcat,""))
 q:r="" ""
 s dispcat=$p(^DHCSTDRUGGRP(r),"^",1)
 q $g(dispcat)
 
OrdStatus(ord,itm)
 n (ord,itm)
 q:ord="" ""
 q:itm="" ""
 q:'$d(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13))) ""
 s oeflag=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",itm,1),"^",13)),"^",1)          ;医嘱核实、未核实、停止状态
 q $g(oeflag)
OrdItmRefused(ord,itm)
 s oi=ord_"||"_itm
 s stdf=""
 s stdf=$o(^STDF(0,"ORDITM",oi,""))
 q:stdf 1
 q 0
}

ClassMethod cstatus(ord As %String, itm As %String) As %String
{
 n (ord,itm)
 s exe=0
 s ret=""
 f  s exe=$o(^OEORD(ord,"I",itm,"X",exe) ) q:(exe="")!(ret'="")  d
 .s dsp=$o(^OEORD(ord,"I",itm,"X",exe,"D",0))
 .;w dsp,!
 .i dsp'="" s ret=$p(^OEORD(ord,"I",itm,"X",exe,"D",dsp),"^",6)
 q $g(ret)
}

ClassMethod OrderTimeBJDT(orditem As %String) As %String
{
 // 北京地坛的医嘱时间规则
 // 当日10:30之后的医嘱不摆药;当日10:30之前的才摆药
 // 返回: 1 -  不摆药  0 - 可摆药
  n (orditem)
 s ret=0
 s timelevel=$zth("10:30")
 s ord=$p(orditem,"||",1) q:ord="" 1
 s itm=$p(orditem,"||",2) q:itm="" 1
 //
 s pr=$p($g(^OEORD(ord,"I",itm,1)),"^",8) 
 q:pr="" 1
 s priority=$p($g(^OECPR(pr)),"^",1)
 q:priority'="S" ret  //非长嘱不予控制
 //
 s orddate=$p(^OEORD(ord,"I",itm,3),"^",7)
 q:orddate'=+$h ret
 s ordtime=$p(^OEORD(ord,"I",itm,1),"^",17)
 q:ordtime'>timelevel ret   //当日10:30之前 
 s arcim=$p(^OEORD(ord,"I",itm,1),"^",2)
 s sub=$p(arcim,"||",1),ver=$p(arcim,"||",2)
 s arcimcat=$P(^ARCIM(sub,ver,1),"^",10)
 s dispcat=$o(^DHCSTDRUGGRP(0,"ORDCAT",arcimcat,""))
 q:dispcat="" ret
 s dispcatcode=$P($g(^DHCSTDRUGGRP(dispcat)),"^",1)
 i dispcatcode="KFBY"  s ret=1 
 q ret
}

ClassMethod ReadFromTxt(file) As %String
{
	 n line,del,onerow
	 s pid=$I(^DHCSTREADTXT("TXT"))
	 ;s del="^"
	 o file:"RS":2
	 u file
	 s end=0
	 d $ZU(68,40,1)
	 f  d  q:end'=0
	 .R onerow
	 .s end=$ZEOF
	 .q:end'=0
	 .q:onerow=""
	 .;s datastr=$tr(onerow,$c(9),del)
	 .s datastr=onerow
	 .s line=$o(^TMPDHCPHATXT("dhcpha",pid,""),-1)+1
	 .s ^TMPDHCPHATXT("dhcpha",pid,line)=datastr
	 .
	 c file
	 q line_"^"_pid
}

ClassMethod GetTxtSetup(code, pid) As %String
{
  n (code,pid)
  s ret=0	
  s line=""
  f  s line=$o(^TMPDHCPHATXT("dhcpha",pid,line)) q:line=""  d
  .s datastr=^TMPDHCPHATXT("dhcpha",pid,line)
  .i $f(datastr,code) d
  ..s ret=1
  q ret
}

/// Description:检查优先级和发药类别是否符合查询条件
/// Input:优先级1#发药类别1~发药类别2~发药类别3~发药类别4^优先级2#发药类别1~发药类别2.....
/// Input:优先级#发药类别
/// Output:1 符合条件,0 非
ClassMethod CheckPrioDispCat(PrioDispCatStr As %String, PrioCat As %String) As %String
{
	n (PrioDispCatStr,PrioCat)
	s PrioDispCatStr=$tr(PrioDispCatStr,"@","#")
	s Priority=$P(PrioCat,"#",1)
	s DispCat=$P(PrioCat,"#",2)
	s ret=0
    q:PrioDispCatStr="" 1
    s cnt=$l(PrioDispCatStr,"^")
    f i=1:1:cnt q:ret=1  d
    .s tmpPriStr=$p(PrioDispCatStr,"^",i)
    .s tmpPrio=$p(tmpPriStr,"#",1)
    .q:tmpPrio'=Priority
    .s tmpCatStr=$p(tmpPriStr,"#",2)
    .s catcnt=$l(tmpCatStr,"~")
    .f xx=1:1:catcnt q:ret=1  d
    ..q:DispCat'=$p(tmpCatStr,"~",xx)
    ..s ret=1
    q ret
}

/// 以下是yury20130913根据中山三院库增加
/// Description:根据本地配置文件数据创造发药条件(病区,发药临界时刻,医嘱优先级,发药分类)
/// CreatedBy : zhwh
/// Create Date:2010-12-09
ClassMethod MakeDispCondition(npid, wardtimeString, priorityString, phaloc) As %String
{
    n (npid,wardtimeString,priorityString,phaloc)
    //s npid=10000
    //s wardtimeString="23#8:00~10:00~15:00^24#8:00~11:00~15:00^25#8:00~11:00~15:00^33#8:00~11:00~15:00^22#8:00~11:00~15:00^30#8:00~11:00~15:00^1#21:00~22:00~23:00^28#8:00~11:00~15:00"
    //s priorityString="STAT#KFBY^NORM#KFBY~JSDM~ZJWYY~ZCY~DSY~ZCHY^ONE#KFBY~JSDM~ZJWYY~ZCY~DSY~ZCHY^S#KFBY~JSDM~ZJWYY~ZCY~DSY~ZCHY^OUT#KFBY~JSDM~ZJWYY~ZCY~DSY~ZCHY^PRN#KFBY~JSDM~ZJWYY~ZCY~DSY~ZCHY"
    //s phaloc=9    
    k ^TMP("dhcpha",npid)
    q:wardtimeString="" ""
    q:phaloc="" ""
    q:priorityString="" ""
    i $f(wardtimeString,"^") d
    .s cnt=$l(wardtimeString,"^")
    e  d
    .s cnt=1
    f i=1:1:cnt d
    .
    .s wardstr=$p(wardtimeString,"^",i)
    .s wardrowid=wardstr
    .//s wardrowid=$p(wardstr,"#",1)
    .q:wardrowid="" 
    .s ^TMP("dhcpha",npid,wardrowid,1)=""
    .  
    i $f(priorityString,"^") d
    .s cnt=$l(priorityString,"^")
    e  d
    .s cnt=1
    f i=1:1:cnt d
    .s priorityStr=$p(priorityString,"^",i)
    .s priority=$p(priorityStr,"#",1) q:priority=""
    .s catStr=$p(priorityStr,"#",2) q:catStr=""
    .s tcnt=$l(catStr,"~")
    .f j=1:1:tcnt d
    ..s cat=$p(catStr,"~",j)
    ..i cat'="" s ^TMP("dhcpha",npid,priority,cat)=""
    q npid
}

}
