/// Description:药库相关类报表
/// Creator:    hulihua
/// CreateDate: 2018-07-16
/// Table:
Class web.DHCST.ReportForms.DrugStorageStat Extends (%RegisteredObject, websys.Abstract, web.DHCST.StkTypeG) [ ClassType = "", ProcedureBlock ]
{

/// Author : zhaochangjing
/// CreatDate : 2018-01-08
/// Description : 出库数据查询
/// Input : StartDate - 开始日期 , EndDate - 截止日期 , PhaLocStr - 查询科室id串
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","QuerySecPhalocData","2020-02-01","2020-03-14","") 
Query QuerySecPhalocData(StartDate As %String = "", EndDate As %String = "", PhaLocStr As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "typedesc:%String,phaloc:%String,scgdesc:%String,scgamt:%Float") [ SqlProc ]
{
}

ClassMethod QuerySecPhalocDataExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", PhaLocStr As %String = "", HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	//s ^hlh($h)=$lb(StartDate, EndDate, PhaLocStr)
	;
	q:StartDate="" $$$OK			//必选条件
	q:EndDate="" $$$OK
	s PhaLocId="",PhaLocStr=""
	f  s PhaLocId=$o(^CTLOC(0,"LocType","D",PhaLocId)) q:PhaLocId=""  d
	.q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(PhaLocId),"^",22))  //按院区过滤
	.s dhclocdr=$o(^DHCLOC(0,"LOC",PhaLocId,""))
 	.s loctype=$s(dhclocdr'="":$p(^DHCLOC(dhclocdr),"^",5),1:"") //库房类别（"R"-"药库";"I"-"住院药房";"O"-"门诊药房";"A"-"器械材料";"G"-"总务药房";"E"-"其他";）
	.q:(loctype'="I")&&(loctype'="O")
	.s PhaLocStr=$s(PhaLocStr'="":PhaLocStr_","_PhaLocId,1:PhaLocId)
	q:PhaLocStr="" $$$OK
	s npid=..NewPid()
	d ..ClearTmp("QuerySecPhalocData",npid)
	s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s counter=0
	s type="T"	//转移出库^转移入库
	s PhaLocLen=$l(PhaLocStr,",")
	f PhaLocNum=1:1:PhaLocLen d
	.s PhaLoc=$p(PhaLocStr,",",PhaLocNum)
	.s PhaLocDesc=$p(^CTLOC(PhaLoc),"^",2)
	.s:PhaLocDesc["-" PhaLocDesc=$p(PhaLocDesc,"-",2)
	.f date=StartDate:1:EndDate d
 	..s intrid="" //遍历台账表 DHC_INTRANS
 	..f  s intrid=$o(^DHCINTR(0,"LOCTYPEDATE",PhaLoc,type,date,intrid)) q:intrid=""  d
 	...q:'$d(^DHCINTR(intrid))
    ...s inclb=$p(^DHCINTR(intrid),"^",7)
    ...q:inclb=""
	...s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
	...q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
    ...s inci=+inclb
    ...s stkcatdr=$p(^INCI(inci,2),"^",2)	//库存分类 INC_StkCat
	...q:stkcatdr="" 
	...s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	...S GrpType=$p(tmpstkgrp,"^",3)
	...q:GrpType'="G"
	...s INTRPointer=$p(^DHCINTR(intrid),"^",9)  ;指向的单据RowID
	...s INITParRef=$p(INTRPointer,"||",1)   ;主表id
	...s INITToLocDR=$p(^DHCINIT(INITParRef),"^",6)  ;请求科室ID 
    ...s INITFrLocDR=$p(^DHCINIT(INITParRef),"^",5)   ;供应科室ID
    ...s dhclocdr=$o(^DHCLOC(0,"LOC",INITToLocDR,""))
 	...s toloctype=$s(dhclocdr'="":$p(^DHCLOC(dhclocdr),"^",5),1:"") 
	...q:(toloctype="I")||(toloctype="O")||(toloctype="R")
	...s scgdesc=$p(tmpstkgrp,"^",2)	//类组描述
    ...s rpamt=$p(^DHCINTR(intrid),"^",17)	//进价金额
    ...s typedesc=$s(type="T":"调出药品金额",type="K":"调入药品金额",1:"")
    ...s counter=counter+1
    ...s ^TMP("DHCST",$this,"QuerySecPhalocData",npid,typedesc,PhaLocDesc,scgdesc,counter)=rpamt
    ..
    .
    q:counter=0 $$$OK
    s typedesc=""
    f  s typedesc=$o(^TMP("DHCST",$this,"QuerySecPhalocData",npid,typedesc)) q:typedesc=""  d
    .s phaloc=""
    .f  s phaloc=$o(^TMP("DHCST",$this,"QuerySecPhalocData",npid,typedesc,phaloc)) q:phaloc=""  d
    ..s scgdesc=""
    ..f  s scgdesc=$o(^TMP("DHCST",$this,"QuerySecPhalocData",npid,typedesc,phaloc,scgdesc)) q:scgdesc=""  d
    ...s scgamt=0
    ...s num=""
    ...f  s num=$o(^TMP("DHCST",$this,"QuerySecPhalocData",npid,typedesc,phaloc,scgdesc,num)) q:num=""  d
    ....s rpamt=$g(^TMP("DHCST",$this,"QuerySecPhalocData",npid,typedesc,phaloc,scgdesc,num))
    ....s scgamt=scgamt+rpamt
 	...d OutputSec
 	..
 	.
	d ..ClearTmp("QuerySecPhalocData",npid)
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK

OutputSec   
	s Data=$lb(typedesc,phaloc,scgdesc,scgamt)
	s ^CacheTemp(repid,ind)=Data    
	s ind=ind+1
	q
}

/// 赵常敬 2017-11-21
/// input：StDate开始日期  EndDate截止日期  PHALOCSTR四个库的串
/// output:领药单位  出库金额  类组
/// do ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","Lingyao","2019-06-01 09:41:51","2019-6-11 09:41:51")
Query Lingyao(StDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "Total:%Double,INITToLocDesc:%String,SCGDesc:%String") [ SqlProc ]
{
}

ClassMethod LingyaoExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:StDate="" $$$OK
 q:EndDate="" $$$OK
 s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
 s EDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 s StartTime=$p(StDate," ",2)
 s StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
 s ETime=$p(EndDate," ",2)
 s ETime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(ETime)
 s counter=0
 s PID=..NewPid()
 d ..ClearTmp("Lingyao",PID)
 s PhaLocId="",PHALOCSTR=""
 f  s PhaLocId=$o(^CTLOC(0,"LocType","D",PhaLocId)) q:PhaLocId=""  d
 .q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(PhaLocId),"^",22))  //按院区过滤
 .s dhclocdr=$o(^DHCLOC(0,"LOC",PhaLocId,""))
 .s loctype=$s(dhclocdr'="":$p(^DHCLOC(dhclocdr),"^",5),1:"") //库房类别（"R"-"药库";"I"-"住院药房";"O"-"门诊药房";"A"-"器械材料";"G"-"总务药房";"E"-"其他";）
 .q:(loctype'="R")&&(loctype'="I")&&(loctype'="O")
 .s PHALOCSTR=$s(PHALOCSTR'="":PHALOCSTR_","_PhaLocId,1:PhaLocId)
 q:PHALOCSTR="" $$$OK
 s count=$l(PHALOCSTR,",")  		//科室计数器
 s type="K"               		//转移类型
 s typecount=$l(type,",")   		//转移计数器
 f num=1:1:count d          		//科室自增
 .s PHALOC=$p(PHALOCSTR,",",num)   
 .f typenum=1:1:typecount d        //类型自增
 ..s INTRType=$p(type,",",typenum) //循环转移类型
 ..f phadate=StartDate:1:EDate d
 ...s pharowid=""
 ...f  s pharowid=$o(^DHCINTR(0,"LOCTYPEDATE",PHALOC,INTRType,phadate,pharowid)) q:pharowid=""  d
 ....s inclb=$p(^DHCINTR(pharowid),"^",7)
 ....q:inclb=""
 ....s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
 ....q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
 ....s Amount=($p(^DHCINTR(pharowid),"^",17))*(-1)  ;进价金额（出库金额）
 ....q:Amount=0
 ....s INTRTime=$p(^DHCINTR(pharowid),"^",3)      ;发生业务的时间
 ....S:INTRTime[":" INTRTime=$zth(INTRTime,3)
 ....s INTRPointer=$p(^DHCINTR(pharowid),"^",9)  ;指向的单据RowID
 ....s INTRNo=$p(^DHCINTR(pharowid),"^",13)  ;指向的单据号
 ....s INTRINCIDR=$p(^DHCINTR(pharowid),"^",15)   ;药品RowID
 ....s INITParRef=$p(INTRPointer,"||",1)   ;主表id 
 ....s INITToLocDR=$p(^DHCINIT(INITParRef),"^",6)  ;请求科室ID 
 ....s INITFrLocDR=$p(^DHCINIT(INITParRef),"^",5)   ;供应科室ID
 ....i INTRType="K" d  //转入
 .....s PhaLocID=INITToLocDR
 ....e  d              //转出
 .....s PhaLocID=INITToLocDR
 ....s INITTOLocDesc=$p($p(^CTLOC(INITToLocDR),"^",2),"-",2)  ;请求科室名称
 ....s IncStkCatGrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(INTRINCIDR)  ;类组代码^类组描述^类组类型
 ....s SCGDesc=$p(IncStkCatGrp,"^",2)
 ....s counter=counter+1
 ....s ^TMP("DHCST",$this,"Lingyao",PID,PhaLocID,SCGDesc,counter)=Amount

 q:counter=0 $$$OK
 s PhaLocID=""  //供给科室
 f  s PhaLocID=$o(^TMP("DHCST",$this,"Lingyao",PID,PhaLocID))  q:PhaLocID=""  d
 .s PhaLocDesc=$p($g(^CTLOC(PhaLocID)),"^",2)
 .s:PhaLocDesc["-" PhaLocDesc=$p(PhaLocDesc,"-",2)	//药房科室
 .s SCGDesc=""        
 .f  s SCGDesc=$o(^TMP("DHCST",$this,"Lingyao",PID,PhaLocID,SCGDesc))  q:SCGDesc=""  d
 ..s counter=""
 ..s Total=""
 ..f  s counter=$o(^TMP("DHCST",$this,"Lingyao",PID,PhaLocID,SCGDesc,counter))  q:counter=""  d
 ...s Amount=^TMP("DHCST",$this,"Lingyao",PID,PhaLocID,SCGDesc,counter)
 ...s Total=Total+Amount 
 ...q:Total=0
 ..d OutPutRow
 d ..ClearTmp("Lingyao",PID)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutPutRow 
 s Data=$lb(Total,PhaLocDesc,SCGDesc) 
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// Descript:   根据时间取得入库单明细信息
/// Creater:zhaozhiduan
/// CreateDate:2014-11-28
/// Input:入库主表id
/// Output:     
/// Return：入库子表id^批号^入库单位Id^入库单位^效期^批次id^订单子表id^加成^入库数量^备注^库存项id^库存项代码
/// ^库存项名称^发票金额^发票号^付款单号^厂商Id^厂商^进价^进价金额^售价^售价金额^发票日期^批次进价
/// ^质检单号^随行单号^摘要^入库售价^入库售价金额^定价类型id^定价类型^招标轮次id^招标轮次^基本单位Id^包装单位和基本单位转换率"
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","QueryDetailForCheck","2021-02-12","2021-07-16","") 
Query QueryDetailForCheck(StDate As %String = "", EndDate As %String = "", StkGrp As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "Ingri:%String,BatchNo:%String,IngrUomId:%String,IngrUom:%String,ExpDate:%String,Inclb:%String,Inpoi:%String,Margin:%String,RecQty:%String,Remarks:%String,IncId:%String,IncCode:%String,IncDesc:%String,InvMoney:%String,InvNo:%String,PayNo:%String,ManfId:%String,Manf:%String,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,InvDate:%String,BatRp:%Float,QualityNo:%String,SxNo:%String,NewSp:%Float,NewSpAmt:%Float,MtDr:%String,MtDesc:%String,PubBL:%String,PubDesc:%String,BUomId:%String,ConFacPur:%String,Spec:%String,stkbin:%String,goodName:%String,CheckRepDate:%String,CheckPack:%String,FormDesc:%String,InfoRemark:%String,CheckUser:%String,PurUser:%String,Vendor:%String,Quality:%String,AcceptCon:%String") [ SqlProc ]
{
}

ClassMethod QueryDetailForCheckExecute(ByRef qHandle As %Binary, StDate As %String = "", EndDate As %String = "", StkGrp As %String = "", HOSPID As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    q:(StDate="")||(EndDate="") $$$OK
    //s ^hlh($h)=$lb(StDate,EndDate,StkGrp)
 	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
 	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    f date=StDate:1:EndDate  d
    .s reclocid=""
    .f  s reclocid=$o(^DHCINGR(0,"CreateDate",date,reclocid))  q:reclocid=""  d
    ..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(reclocid),"^",22))  //按院区过滤
    ..s ingd=""
    ..f  s ingd=$o(^DHCINGR(0,"CreateDate",date,reclocid,ingd)) q:ingd=""  d
    ...s vendor=$p(^DHCINGR(ingd),"^",3)
    ...s vendorname=$S(vendor'="":$p(^APC("APCVM",vendor),"^",3),1:"")
    ...s Parref=ingd
    ...s sub=""
    ...f  s sub=$o(^DHCINGR(ingd,"GRI",sub)) q:sub=""  d
    ....s IncId = $p(^DHCINGR(ingd,"GRI",sub),"^",25)
   	....s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
	....S GrpType=$p(tmpstkgrp,"^",3)
	....q:GrpType'=..sssCode()
 	....s scg=$p(tmpstkgrp,"^",5)
	....q:(StkGrp'="")&&(scg'=StkGrp)
    ....s ingri=ingd_"||"_sub
    ....s BatchNo=$p(^DHCINGR(ingd,"GRI",sub),"^",13)
    ....s IngrUomId=$p(^DHCINGR(ingd,"GRI",sub),"^",10)
    ....s IngrUom=""
    ....s:IngrUomId'="" IngrUom=$p(^CT("UOM",IngrUomId),"^",2)
    ....s ExpDate=$p(^DHCINGR(ingd,"GRI",sub),"^",9)
  	....s ExpDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(ExpDate)
    ....s Inclb=$p(^DHCINGR(ingd,"GRI",sub),"^",1)
    ....s Inpoi=$p(^DHCINGR(ingd,"GRI",sub),"^",17)
    ....s Margin =$p(^DHCINGR(ingd,"GRI",sub),"^",18)
    ....s RecQty = $p(^DHCINGR(ingd,"GRI",sub),"^",4)
    ....s RecQty=RecQty_IngrUom
    ....s Remarks = $p($g(^DHCINGR(ingd,"GRI",sub,"REM",1)),"^",1)
    ....s IncCode = $p(^INCI(IncId,1),"^",1)
    ....s IncDesc = $p(^INCI(IncId,1),"^",2)
    ....s InvMoney = $p(^DHCINGR(ingd,"GRI",sub),"^",26)
    ....s InvNo = $p(^DHCINGR(ingd,"GRI",sub),"^",27)
    ....s PayNo = $p(^DHCINGR(ingd,"GRI",sub),"^",28)
    ....s ManfId =$p(^DHCINGR(ingd,"GRI",sub),"^",29)
    ....s Manf=""
    ....i ManfId'="" s Manf = $p(^PHMNF(ManfId),"^",2)
    ....s Rp = $p(^DHCINGR(ingd,"GRI",sub),"^",30)
    ....s RpAmt = $p(^DHCINGR(ingd,"GRI",sub),"^",31)
    ....s Sp = $p(^DHCINGR(ingd,"GRI",sub),"^",32)
    ....s SpAmt = $p(^DHCINGR(ingd,"GRI",sub),"^",50)
    ....s InvDate = $p(^DHCINGR(ingd,"GRI",sub),"^",34)
    ....s InvDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(InvDate)
    ....s BatRp = $p(^DHCINGR(ingd,"GRI",sub),"^",35)
    ....s QualityNo = $p(^DHCINGR(ingd,"GRI",sub),"^",37)
    ....s SxNo = $p(^DHCINGR(ingd,"GRI",sub),"^",38)
    ....s Remark =$p(^DHCINGR(ingd,"GRI",sub),"^",44)
    ....s NewSp = $p(^DHCINGR(ingd,"GRI",sub),"^",45)
    ....s NewSpAmt = $p(^DHCINGR(ingd,"GRI",sub),"^",46)
    ....s MtDr = $p(^DHCINGR(ingd,"GRI",sub),"^",47)     ;定价类型
    ....s:MtDr'="" MtDesc=$p(^DHCINMT(MtDr),"^",2)
    ....s PubBL =$p(^DHCINGR(ingd,"GRI",sub),"^",48)     ;招标轮次
    ....s CheckPort=$p(^DHCINGR(ingd,"GRI",sub),"^",41)     ;检测口岸
    ....s CheckRepNo=$p(^DHCINGR(ingd,"GRI",sub),"^",39)   ;检测报告
    ....s CheckRepDate=$p(^DHCINGR(ingd,"GRI",sub),"^",40)   ;报告日期
    ....s CheckRepDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(CheckRepDate)
    ....s AdmNo=$p(^DHCINGR(ingd,"GRI",sub),"^",42)    ;注册证号
    ....s AdmExpdate=$p(^DHCINGR(ingd,"GRI",sub),"^",43)       ;注册证有效期
    ....s AdmExpdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(AdmExpdate)
    ....s CheckPack=$p(^DHCINGR(ingd,"GRI",sub),"^",23)    ;包装合格
	....s:PubBL'="" PubDesc=$p(^DHCPBLIST(PubBL),"^",2)
    ....s BUomId=$p(^INCI(IncId,1),"^",10)
    ....s PurUomId=$p(^INCI(IncId,3),"^",6)
    ....s ConFac=##class(web.DHCST.Common.UtilCommon).UOMFac(PurUomId,BUomId)
    ....s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncId)
    ....s ctloc=$p(^DHCINGR(ingd,"GRI",sub),"^",3) 
    ....i ctloc'="" s ctloc=$p(^CTLOC(ctloc),"^",2)
    ....s stkbin=##class(web.DHCST.Common.DrugStkCommon).GetStkBin(ctloc,IncId)
    ....s stkbin=$p(stkbin,"^",1)                      ;库位码
    ....s goodName=##class(web.DHCST.Common.DrugInfoCommon).GetGoodName(IncId)	;商品名
    ....s formstr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(IncId)
    ....s formdesc=$p(formstr,"^",1) 
    ....s Info=$o(^DHCITMINFO(0,"INCI",IncId,0))
    ....s InfoRemark=""
    ....i Info'="" s InfoRemark=$p(^DHCITMINFO(Info),"^",10)
    ....i (InfoRemark["-")&&($p(InfoRemark,"-",1)="")&&($p(InfoRemark,"-",2)="") s InfoRemark=""
    ....s checkuserdr=$p(^DHCINGR(Parref),"^",26)
    ....q:checkuserdr=""
    ....s checkuser=$s(checkuserdr'="":$p(^SSU("SSUSR",checkuserdr),"^",2),1:"")
    ....s puruserdr=$p(^DHCINGR(Parref),"^",24)
    ....s puruser=""
    ....i puruserdr'="" s puruser=$p(^SSU("SSUSR",puruserdr),"^",2)
    ....s Quality="良好"
    ....s AcceptCon="合格"
	....d OutPutRow2
	...
	..
	.
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPutRow2
	s Data=$lb(Ingri,BatchNo,IngrUomId,IngrUom,ExpDate,Inclb,Inpoi,Margin,RecQty,Remarks,IncId,IncCode,IncDesc,InvMoney,InvNo,PayNo,ManfId,Manf,Rp,RpAmt,Sp,SpAmt,InvDate,BatRp,QualityNo,SxNo,NewSp,NewSpAmt,MtDr,$g(MtDesc),PubBL,$g(PubDesc),BUomId,ConFac,Spec,stkbin,goodName,CheckRepDate,CheckPack,formdesc,InfoRemark,checkuser,puruser,vendorname,Quality,AcceptCon)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 药房库存周转天数计算
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","QueryDRUGTransedays","96","2018-01")
Query QueryDRUGTransedays(ctlocId As %String = "", Date As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "result:%String,ctlocdesc:%String") [ SqlProc ]
{
}

ClassMethod QueryDRUGTransedaysExecute(ByRef qHandle As %Binary, ctlocId As %String = "", Date As %String = "", HOSPID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	//s ^hlh($h)=$lb(ctlocId,Date)
	;
	q:Date="" $$$OK
	q:$p(Date,"-",1)>$p($zd(+$h,3),"-",1) $$$OK
	q:($p(Date,"-",1)=$p($zd(+$h,3),"-",1))&&($p(Date,"-",2)>=$p($zd(+$h,3),"-",2)) $$$OK  ;大于等于当前年月的不让查
	s startDate=Date_"-01"                                                                 ;取入参月份的1号
	s startDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s:$p(Date,"-",2)'=12 endDate=$p(Date,"-",1)_"-"_($p(Date,"-",2)+1)_"-01"
	s:$p(Date,"-",2)=12 endDate=$p(Date,"-",1)+1_"-"_"01-01"
	s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)-1    			;取入参月份的月底
	s:$p(Date,"-",2)'=1 beforedate=$p(Date,"-",1)_"-"_($p(Date,"-",2)-1)_"-01"  			;取查询月份的上个月1号
	s:$p(Date,"-",2)=1 beforedate=$p(Date,"-",1)-1_"-12-01"
	s beforedate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(beforedate)
	s ctlocdesc=""
	s ctlocIdbak="" 
	f  s ctlocIdbak=$o(^CTLOC(0,"LocType","D",ctlocIdbak)) q:ctlocIdbak=""  d
	.q:(ctlocId'="")&&(ctlocId'=ctlocIdbak)
	.q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(ctlocIdbak),"^",22))  //按院区过滤
	.s TotalSpAmt=0		;合计售价金额
	.s HospId=$p(^CTLOC(ctlocIdbak),"^",22)
	.s ctlocdesc=$p(^CTLOC(ctlocIdbak),"^",2)
	.s:$F(ctlocdesc,"-") ctlocdesc=$p(ctlocdesc,"-",2)
	.s dhclocdr=$o(^DHCLOC(0,"LOC",ctlocIdbak,""))
 	.s loctype=$s(dhclocdr'="":$p(^DHCLOC(dhclocdr),"^",5),1:"") //库房类别（"R"-"药库";"I"-"住院药房";"O"-"门诊药房";"A"-"器械材料";"G"-"总务药房";"E"-"其他";）
	.i loctype'["R" d
	..f date=startDate:1:endDate  d
	...s Inci=0
	...f  s Inci=$o(^INCI("IL_LOC",ctlocIdbak,Inci)) q:Inci=""  d
	....s Chl=$o(^INCI("IL_LOC",ctlocIdbak,Inci,0))
	....s Incil=Inci_"||"_Chl
	....s SpAmt=##class(web.DHCST.Common.DrugStkCommon).GetSpAmt(Incil,date)
	....s TotalSpAmt=TotalSpAmt+SpAmt  ;算查询科室的库存金额累加
	.e  d
	..s datestr=startDate_"^"_endDate
	..s datelen=$l(datestr,"^")
	..f dateindex=1:1:datelen d
	...s date=$p(datestr,"^",dateindex)
	...q:date=""
	...s Inci=0
	...f  s Inci=$o(^INCI("IL_LOC",ctlocIdbak,Inci)) q:Inci=""  d
	....s Chl=$o(^INCI("IL_LOC",ctlocIdbak,Inci,0))
	....s Incil=Inci_"||"_Chl
	....s SpAmt=##class(web.DHCST.Common.DrugStkCommon).GetSpAmt(Incil,date)
	....s TotalSpAmt=TotalSpAmt+SpAmt  ;算查询科室的库存金额累加
	..s TotalSpAmt=(TotalSpAmt/2)*30
	.s beforesellmomeysp=0
	.i loctype'["R" d
	..&sql(SELECT (SUM(SMRD_DspP_Amount)+sum(SMRD_DspF_Amount)+sum(SMRD_PhaRetH_Amount)+sum(SMRD_PhaRetY_Amount)) into :beforesellmomeysp FROM SQLUser.DHC_StkMonStat WHERE SMRD_SMR_DR
	IN(SELECT SMR_Rowid FROM SQLUser.DHC_StkMonReport WHERE SMR_SM_Parref->DHCSM_Month=:startDate AND SMR_SM_Parref->DHCSM_CTLOC_DR=:ctlocIdbak ))
	.e  d
	..&sql(SELECT (SUM(SMRD_TrfI_Amount)+sum(SMRD_Trfo_Amount)) into :beforesellmomeysp FROM SQLUser.DHC_StkMonStat WHERE SMRD_SMR_DR
	IN(SELECT SMR_Rowid FROM SQLUser.DHC_StkMonReport WHERE SMR_SM_Parref->DHCSM_Month=:startDate AND SMR_SM_Parref->DHCSM_CTLOC_DR=:ctlocIdbak ))
	.s beforesellmomeysp=-beforesellmomeysp
	.s result=0
	.i beforesellmomeysp'=0 s result=TotalSpAmt/beforesellmomeysp
	.s result=$fn(result*0.85,"",2)_"%"
	.d QueryOutRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
QueryOutRow
	set Data=$lb(result,ctlocdesc)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// 统计采购完成情况  
/// mpf 20171106
/// 汇总某月的计划与实际入库数量信息.
/// input:科室ID,年,月.
/// D ##class(%ResultSet).RunQuery("web.DHCST.DHCReportForYNSDR","QueryTotalPurPlanAndIngrData","226","2017-11-02","2017-11-03")
/// 统计采购完成情况  D ##class(%ResultSet).RunQuery
/// D ##class(%ResultSet).RunQuery("web.DHCST.DHCReportForYNSDR","QueryTotalPurPlanAndIngrData","226","2017-11-02","2017-11-03")
Query QueryTotalPurPlanAndIngrData(DispLocId As %String = "", StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "TotalPlanQty,TotalPlanRp,TotalIngfQty,TotalIngfRp,complited,overfulfil,uncomplited") [ SqlProc ]
{
}

ClassMethod QueryTotalPurPlanAndIngrDataExecute(ByRef qHandle As %Binary, DispLocId As %String = "", StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    Set qHandle=$lb(0,repid,0)
    q:(StartDate="")||(EndDate="") $$$OK
    s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
    //----------------------------
    s result=..PurPlanAndIngrData(DispLocId,StartDate,EndDate,HOSPID)
    s TotalPlanQty=$p(result,"^",1)
    s TotalPlanRp=$p(result,"^",2)
    s TotalIngfQty=$p(result,"^",3)    
    s TotalIngfRp=$p(result,"^",4)
    s complited=$p(result,"^",5)
    s uncomplited=$p(result,"^",6)
    s overfulfil=$p(result,"^",7)    
	d outputreg
    //----------------------------    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
outputreg
    s data=$lb(TotalPlanQty,TotalPlanRp,TotalIngfQty,TotalIngfRp,complited,overfulfil,uncomplited)
    Set ^CacheTemp(repid,ind)=data
    Set ind=ind+1
    quit
}

/// 药库计划与实际进货药品数量对照
/// D ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","QueryComparePurPlanAndIngrData","320","2018-07-10","2018-08-10","0","11")
Query QueryComparePurPlanAndIngrData(tDispLocId As %String = "", tStartDate As %String = "", tEndDate As %String = "", QueryFlag As %String = "", OperateType As %String = "", Inci As %String = "") As websys.Query(ROWSPEC = "inci:%String,incicode:%String,incidesc:%String,gene:%String,spec:%String,vendor:%String,manf:%String,Uomdesc:%String,Uomdr:%String,PlanQty:%Float,IngfQty:%Float,PurPrice:%Float,RpAmount:%Float") [ SqlProc ]
{
}

ClassMethod QueryComparePurPlanAndIngrDataExecute(ByRef qHandle As %Binary, tDispLocId As %String = "", tStartDate As %String = "", tEndDate As %String = "", QueryFlag As %String = "", OperateType As %String = "", Inci As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	s ind=1
	q:(tDispLocId="")||(tStartDate="")||(tEndDate="") $$$OK
	s tStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tStartDate)
	s tEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tEndDate)
	s tStartDate=$zd(tStartDate,3)
	s tEndDate=$zd(tEndDate,3)
	s StrSql="select INPPI_Rowid as Rowid from IN_PurPlanItm where (INPPI_Parref->INPP_AuditDate between '"_tStartDate_"' and '"_tEndDate_"')"
	i tDispLocId'="" d
	.s StrSql=StrSql_" and INPPI_Parref->INPP_CTLOC_DR="_tDispLocId
	s json = ##class(Code.JsonObj).%New()
	s pid=..NewPid()
	d ..ClearTmp("QueryComparePurPlanAndIngrData",pid)
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	s json = ##class(Code.JsonObj).%New()  
	While(result.Next())
	{
		s Rowid = result.Data("Rowid")
		s PlanId=+Rowid
		s chl=$p(Rowid,"||",2)
		continue:'$d(^INPP(PlanId,"PPI",chl))		
		s inci=$p(^INPP(PlanId,"PPI",chl),"^",2)
		continue:(Inci'="")&&(Inci'=inci)
		continue:'$d(^INCI(inci,1))
		s bUomdr=$p($g(^INCI(inci,1)),"^",10)
		s Uomdr=$p(^INPP(PlanId,"PPI",chl),"^",4)
		s confac=##class(web.DHCSTCOMMONSRV).UOMFac(Uomdr,bUomdr)
		s qty=$p(^INPP(PlanId,"PPI",chl),"^",3)
		s bQty=qty*confac
		s OperateType1=$p(^INPP(PlanId),"^",14)
		//add by mpf 20171106增加计划与实际金额.
		s PurPrice=$p(^INPP(PlanId,"PPI",chl),"^",5)
		i $d(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci)) d
		.s $p(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci),"^",1)=+$p(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci),"^",1)+bQty
		.s $p(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci),"^",3)=+$p(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci),"^",3)+PurPrice
		.s $p(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci),"^",5)=OperateType1
		e   d 
		.s ^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci)=bQty_"^"_0_"^"_0_"^"_0
	}
	s tStartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tStartDate)
    s tEndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(tEndDate)
	s typestr="G"
	s len=$l(typestr,"^")
	f ii=1:1:len d
	.s type=$p(typestr,"^",ii)
	.f dd=tStartDate:1:tEndDate d
	..s intr=""
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,dd,intr)) q:intr=""  d
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...s inciLoc=$p($g(^INCI(+inclb,"IL",+$p(inclb,"||",2))),"^",1)
	...q:(tDispLocId'="")&&(tDispLocId'=inciLoc)
	...s inci=$p(^DHCINTR(intr),"^",15)
	...s qty=$p(^DHCINTR(intr),"^",6)
	...s bUomdr=$p(^INCI(inci,1),"^",10)
	...s Uomdr=$p(^DHCINTR(intr),"^",10)
	...s confac=##class(web.DHCSTCOMMONSRV).UOMFac(Uomdr,bUomdr)
	...s bQty=qty*confac
	...s RpAmount=$p(^DHCINTR(intr),"^",17)
	...i $d(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci)) d
	....s $p(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci),"^",2)=+$p(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci),"^",2)+bQty
	....s $p(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci),"^",4)=+$p(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci),"^",4)+RpAmount	//实际入库进价金额
	...e  s ^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci)=0_"^"_bQty_"^"_0_"^"_0
	
	s inci=""
	f  s inci=$o(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci)) q:inci=""  d
	.Q:(Inci'="")&&(Inci'=inci)
	.s qtystr=$g(^TMP("DHCST",$this,"QueryComparePurPlanAndIngrData",pid,"INCI",inci))
	.s incicode=$p(^INCI(inci,1),"^",1)
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.s genestr=##class(web.DHCST.Common.DrugInfoCommon).GetGene(inci)
	.s gene=$p(genestr,"^",2)
	.i gene="" s gene=incidesc
	.s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	.s vendorstr=##class(web.DHCST.Common.DrugStkCommon).GetLastVen(inci)
	.s vendor=$p(vendorstr,"^",2)
	.s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
	.S GrpType=$p(tmpstkgrp,"^",3) q:GrpType="M"
	.s manfstr=##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci)
	.s manf=$p(manfstr,"^",3)
	.s bUomDr=$p(^INCI(inci,1),"^",10)
	.s pUomDr=$p(^INCI(inci,3),"^",6)
	.s confac=##class(web.DHCSTCOMMONSRV).UOMFac(pUomDr,bUomDr)
	.s OperateType1=$p(qtystr,"^",5) 
	.;q:(OperateType)&&(OperateType1'=OperateType)
	.s bplanqty=$p(qtystr,"^",1)	//计划
	.s bingrqty=$p(qtystr,"^",2)	//实际
	.s PlanQty=bplanqty  ;q:PlanQty=0  //modify by mpf 计划为0时不退出,将计划当做0.
	.s IngfQty=bingrqty   //入库数量
	.s PurPrice=$p(qtystr,"^",3)	//计划金额
	.s RpAmount=$p(qtystr,"^",4)	//实际金额
	.s Uomdr="",Uomdesc=""
	.i (bplanqty#confac=0)&&(bingrqty#confac=0) d
	..s PlanQty=bplanqty/confac
	..s IngfQty=bingrqty/confac
	..s Uomdr=pUomDr
	.e  d
	..s Uomdr=bUomDr
	.s Uomdesc=$p(^CT("UOM",Uomdr),"^",2)
	.//add by mpf 增加按条件查询 2017-11-02
	.Q:(QueryFlag=0)&&(PlanQty'>IngfQty)
	.Q:(QueryFlag=1)&&(PlanQty'=IngfQty)
	.Q:(QueryFlag=2)&&(PlanQty'<IngfQty)
	.d OutRowItm
    d ..ClearTmp("QueryComparePurPlanAndIngrData",pid)
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowItm
	set Data=$lb(inci,incicode,incidesc,gene,spec,vendor,manf,Uomdesc,Uomdr,PlanQty,IngfQty,PurPrice,RpAmount)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// D ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","GetInciStkZZL","2020-12-01","2020-12-08","","2")
Query GetInciStkZZL(stdate As %String = "", enddate As %String = "", loc As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "incicode,incidesc,ststkspamt:%Float,edstkspamt:%Float,SpAmt:%Float,zzl:%String,zzts:%Float,date:%Float") [ SqlProc ]
{
}

ClassMethod GetInciStkZZLExecute(ByRef qHandle As %Binary, stdate As %String = "", enddate As %String = "", loc As %String = "", HOSPID As %String = "") As %Status
{
    s repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
    s ind=1
    q:(stdate="")||(enddate="") $$$OK
	s stdate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(stdate)
    s enddate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(enddate)
 	s pid=..GetQTy(stdate,enddate,loc)  //GetSpAmt
	s hospid=$p($g(^CTLOC(+loc)),"^",22)
 	s inci=0
 	f  s inci=$o(^INCI(inci)) q:inci=""  d
 	.s incil=0
 	.s incil=$o(^INCI(inci,"IL",incil)) q:incil=""  
 	.s incscdr=$p(^INCI(inci,2),"^",2)
 	.s stktype=$p(^INC("SC",incscdr),"^",3)
 	.q:stktype'="G"
 	.s tmploc=$P(^INCI(inci,"IL",incil),"^",1)
 	.q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
 	
 	.s incidesc=$p(^INCI(inci,1),"^",2)
 	.s incicode=$p(^INCI(inci,1),"^",1)
 	.s stqty=0,edqty=0
 	.s stqty=..QTYInci(stdate,inci,loc)
 	.s edqty=..QTYInci(enddate,inci,loc)
 	.s buomID=$p(^INCI(inci,1),"^",10)
 	.s bUomSp=0,ststkspamt=0,edstkspamt=0
 	.s bUomSp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inci,enddate,buomID,hospid,"G","")
 	.s ststkspamt=$g(stqty) //*$g(bUomSp)
 	.s edstkspamt=$g(edqty) //*$g(bUomSp)
 	.s SpAmt=0
 	.i ($d(^TMP("DHCST",$this,"GetSpAmt",pid,"INCIZZL",inci))) d
 	..s SpAmt=$p(^TMP("DHCST",$this,"GetSpAmt",pid,"INCIZZL",inci),"^",2)
 	..//i SpAmt<0 s SpAmt=(-1)*SpAmt
 	.s date=enddate-stdate+1
 	.s zzl=0,zzts=0
 	.//if (ststkspamt=0)&(edstkspamt=0) set ststkspamt=1 //不允许出现0分子
 	.//if SpAmt=0 set SpAmt=1 //不允许出现 0分母
 	.i SpAmt'=0  s zzl=$num(((ststkspamt+edstkspamt)/2)/SpAmt*100,2)_"%" //周转率
 	.i SpAmt'=0  s zzts=$num(((ststkspamt+edstkspamt)/2)/SpAmt*date,2) //周转天数
    .d OutRowItm2
    d ..ClearTmp("GetSpAmt",pid,"INCIZZL")
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRowItm2
	set Data=$lb(incicode,incidesc,ststkspamt,edstkspamt,SpAmt,zzl,zzts,date)    
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

/// -------yangsj----2019-10-28 ----报表内容集中整理------Start-------//////
/// 供应商付款单汇总统计
/// Author:zhwh
/// Date:2012-09-04
/// Argu:
///  StartDate-起始日期
///  EndDate-截止日期
///  Loc-科室RowId
///  Ven-供应商RowId=””
/// Return: 
///   供应商名称,付款单号,付款金额,入库(退货)进价金额 ,入库(退货)售价金额,进销差价金额 
///  d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","SumVendorPay","2019-09-01","2019-11-01","376","") 
Query SumVendorPay(StartDate As %String = "", EndDate As %String = "", Loc As %String = "", Ven As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "vendorName:%String,payNoStr:%String,payAmtSum:%Float,rpAmtSum:%Float,spAmtSum:%Float,rpspDiffAmt:%Float,LocDesc") [ SqlProc ]
{
}

ClassMethod SumVendorPayExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", Loc As %String = "", Ven As %String = "", HOSPID As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 ;
 q:Loc="" $$$OK
 s LocDesc=$P(^CTLOC(Loc),"^",2)
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 i EndDate["-" s EndDate=$zdh(EndDate,3)
 i StartDate["-" s StartDate=$zdh(StartDate,3)
 i EndDate["/" s EndDate=$zdh(EndDate,4)
 i StartDate["/" s StartDate=$zdh(StartDate,4)
 
 k ^TMP($zn,$j,"SumVendorPay")
 f dd=StartDate:1:EndDate d
 .s vendor=""
 .f  s vendor=$o(^DHCPAY(0,"DateLocVen",dd,Loc,vendor)) q:vendor=""  d
 ..i Ven'="" q:vendor'=Ven
 ..s vendorName=$p(^APC("APCVM",vendor),"^",3)
 ..s payNoStr="",payAmtSum=0,rpAmtSum=0,spAmtSum=0,rpspDiffAmtSum=0
 ..s pay=0 
 ..f  s pay=$O(^DHCPAY(0,"DateLocVen",dd,Loc,vendor,pay)) q:pay=""  d
 ...s payNo=$P(^DHCPAY(pay),"^",1)
 ...
 ...i payNoStr="" s payNoStr=payNo
 ...e  s payNoStr=payNoStr_","_payNo
 ...
 ...s ch=0 
 ...f  s ch=$O(^DHCPAY(pay,"I",ch))  q:ch=""  d
 ....s payi=pay_"||"_ch
 ....s type=$p(^DHCPAY(pay,"I",ch),"^",9)
 ....s pointer=$p(^DHCPAY(pay,"I",ch),"^",2)
 ....s amt=##Class(web.DHCST.DHCPayStat).GetTransAmt(pointer,type)
 ....s rpAmt=$p(amt,"^",1)
 ....s spAmt=$p(amt,"^",2)
 ....s rpAmtSum=rpAmtSum+rpAmt
 ....s spAmtSum=spAmtSum+spAmt
 ....s payAmt=$p(^DHCPAY(pay,"I",ch),"^",5)
 ....s payAmtSum=payAmtSum+payAmt
 ..s rpspDiffAmtSum=spAmtSum-rpAmtSum
 ..s ^TMP($zn,$j,"SumVendorPay",vendorName)=$lb(vendorName,payNoStr,payAmtSum,rpAmtSum,spAmtSum,rpspDiffAmt,LocDesc)
 
 s vendorName="" 
 f  s vendorName=$o(^TMP($zn,$j,"SumVendorPay",vendorName)) q:vendorName=""  d
 .s Data=^TMP($zn,$j,"SumVendorPay",vendorName)
 .d OutPutRow3
 
 k ^TMP($zn,$j,"SumVendorPay")
 Quit $$$OK
 
OutPutRow3
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

/// 加载安全组可以访问的科室
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","GetGroupDept","12")
Query GetGroupDept(groupid As %String = "") As websys.Query(ROWSPEC = "RowId:%String,Description:%String") [ SqlProc ]
{
}

ClassMethod GetGroupDeptExecute(ByRef qHandle As %Binary, groupid As %String = "") As %Status
{
	//s groupid=GROUPID
	s ^YSJTMP("GetGroupDeptExecute")=groupid
	Set repid=$I(^CacheTemp)
	;
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:groupid="" $$$OK
	&sql(declare ctlocs cursor for Select st_ctloc_dr,st_ctloc_dr->ctloc_desc into :RowId,:Description from SQLUser.ss_groupstocklocations where st_parref=:groupid)
	&sql(open ctlocs)
	f  &sql(fetch ctlocs into :RowId,:Description)  q:SQLCODE  d
	. d OutputCtLocs
	&sql(close ctlocs)    
 	Set qHandle=$lb(0,repid,0)
	q $$$OK
OutputCtLocs
	s Data=$lb(RowId,Description)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

Query QueryDrugTurnover(StDate As %String = "", EndDate As %String = "", PhaLoc As %String = "", QtyFlag As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "Inci:%String,InciCode:%String,InciDesc:%String,StkGrpDr:%String,StkGrpDesc:%String,DispBQty:%String,DispPQty:%String,StartStkQty:%String,EndStkQty:%String,DrugTurnover:%String") [ SqlProc ]
{
}

/// Description：统计某段时间内各药品的周转率(药品存货周转率=本期所有病人使用该药品的数量/((该药品期初数量+该药品期末数量)*2))（海南农垦三亚）
/// Creator：WangYaJun(统一根据基本单位数量计算)
/// CreateDate：2018-11-06
/// Input：开始日期、结束日期、科室ID、业务数量是否为0标志
/// OutPut：
/// Other:
/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","QueryDrugTurnover","2019-09-01","2019-11-01",376)
ClassMethod QueryDrugTurnoverExecute(ByRef QHandle As %Binary, StDate As %String = "", EndDate As %String = "", PhaLoc As %String = "", QtyFlag As %String = "", HOSPID As %String = "") As %Status
{
    Set repid=$I(^CacheTemp)
    Set QHandle=$lb(0,repid,0)
    s ind=1
    q:StDate="" $$$OK
    s:$f(StDate,"-") StDate=$ZDH(StDate,3)
    s:$f(EndDate,"-") EndDate=$ZDH(EndDate,3)
    s:EndDate="" EndDate=+$h
    q:StDate>EndDate $$$OK
    Q:PhaLoc="" $$$OK
    s HospDr=$p(^CTLOC($p(PhaLoc,"^",1)),"^",22)

    s TypeStr="P^Y^F^H"                          ;住院发药^住院退药^门诊发药^门诊退药
    s Inci=0
    f  s Inci=$o(^INCI("IL_LOC",PhaLoc,Inci)) q:Inci=""  d
    .s Sub=""
    .f  s Sub=$o(^INCI("IL_LOC",PhaLoc,Inci,Sub)) q:Sub=""  d
    ..s Incil=Inci_"||"_Sub
    ..s StkGroupInfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
    ..s StkGrpDesc=$p(StkGroupInfo,"^",2)
    ..s StkGrpDr=$p(StkGroupInfo,"^",5)
    ..s Buom=$p(^INCI(Inci,1),"^",10)
    ..s Puom=$p(^INCI(Inci,3),"^",6)
    ..s DispBQty=..GetIntrBQtyByDateType(StDate,EndDate,Incil,TypeStr)  ;记录消耗数量
    ..q:(QtyFlag="Y")&&(DispBQty=0)
    ..s InciCode=$p(^INCI(Inci,1),"^",1)
    ..s InciDesc=$p(^INCI(Inci,1),"^",2)
    ..s BuomDesc=$p(^CT("UOM",Buom),"^",2)
    ..s PuomDesc=$p(^CT("UOM",Puom),"^",2)
    ..s Fac=##class(web.DHCSTCOMMONSRV).UOMFac(Puom,Buom)
    ..s DispPQty=DispBQty/Fac
    ..s:$f(DispPQty,".") DispPQty=$fn(DispPQty,"",2)
    ..;获取库存
    ..s StartStkQty=0,EndStkQty=0
    ..s lbSub=""
    ..f  s lbSub=$o(^INCI(Inci,"IL",Sub,"LB",lbSub)) q:lbSub=""  d
    ...s Inclb=Inci_"||"_Sub_"||"_lbSub
    ...s StLbqty=##Class(web.DHCST.Common.DrugStkCommon).QtyINCLB(Inclb,StDate-1)   ;期初批次库存
    ...s EndLbqty=##Class(web.DHCST.Common.DrugStkCommon).QtyINCLB(Inclb,EndDate)   ;期初批次库存
    ...s StartStkQty=StartStkQty+StLbqty
    ...s EndStkQty=EndStkQty+EndLbqty
    ...;将库存转换为入库单位库存
    ...s StartStkQty=StartStkQty/Fac
    ...s EndStkQty=EndStkQty/Fac
    ...;库存数统一保留两位小数
    ...s:$f(StartStkQty,".") StartStkQty=$fn(StartStkQty,"",2)
    ...s:$f(EndStkQty,".") EndStkQty=$fn(EndStkQty,"",2)
    ..;计算周转率
    ..i (DispPQty>0)&&(StartStkQty+EndStkQty=0) s DrugTurnover=1
    ..e  i DispPQty=0 s DrugTurnover=0
    ..e  s DrugTurnover=DispPQty/(2*(StartStkQty+EndStkQty))
    ..s:$f(DrugTurnover,".") DrugTurnover=$fn(DrugTurnover,"",5)
    ..s Data=$lb(Inci,InciCode,InciDesc,StkGrpDr,StkGrpDesc,DispBQty,DispPQty,StartStkQty,EndStkQty,DrugTurnover)
    ..d OutPutRow
    Set QHandle=$lb(0,repid,0)
    Quit $$$OK
OutPutRow
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    Quit
}

/// -------yangsj----2019-10-28 ----报表内容集中整理------End-------//////
/// //================报表整理====yangsj====2019-10-31======Start==================/////////
/// Description 	:河北省中医医院采购基本药物品种统计报表
/// Creator 		:GuoFa
/// CreateDate 		:2019-09-23
/// Input 			:StartDate:开始日期、StartTime:开始时间、EndDate:结束日期、EndTime:结束时间
/// Output 			:药品名称、药品代码、数量、单位、进价、售价
///                 :剂型、规格、厂商、供应商、类型、基本药物标志
/// Table 			:
/// Others 			:
/// Debug 			:D ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","GetIngdRecBasic","2019-05-01","00:00:00","2019-11-05","23:59:59") 
/// 				 D ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","GetIngdRecBasic","2019-05-01","00:00:00","2019-10-30","23:59:59")
Query GetIngdRecBasic(StartDate As %String = "", StartTime As %String = "", EndDate As %String = "", EndTime As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "inciDesc:%String,inciCode:%String,qty:%String,buomDesc:%String,Rp:%Float,Sp:%Float,Form:%String,Spec:%String,Manf:%String,Vendor:%String,StkCat:%String,basicFlag:%String") [ SqlProc ]
{
}

ClassMethod GetIngdRecBasicExecute(ByRef qHandle As %Binary, StartDate As %String = "", StartTime As %String = "", EndDate As %String = "", EndTime As %String = "", HOSPID As %String = "") As %Status
{

 //s ^YSJTMP("GetIngdRecBasicExecute")=$LB(StartDate,StartTime,EndDate,EndTime)
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:(StartDate="")||(EndDate="") $$$OK			//必选条件
 s StartDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StartDate)
 s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
 q:StartDate>EndDate $$$OK
 s:StartTime'="" StartTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(StartTime)
 s:EndTime'="" EndTime=##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical(EndTime)
 s pid=..NewPid()
 f date=StartDate:1:EndDate d
 .s intrId=""
 .f  s intrId=$O(^DHCINTR(0,"TypeDate","G",date,intrId)) q:intrId=""  d
 ..s intrData=^DHCINTR(intrId)
 ..s inclb=$p(intrData,"^",7)
 ..q:inclb=""
 ..s tmploc=$P(^INCI(+inclb,"IL",$P(inclb,"||",2)),"^",1)
 ..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤
 ..s time=$P(intrData,"^",3)
 ..q:(StartTime'="")&&(EndTime'="")&&(((date=StartDate)&&(time<StartTime))||((date=EndDate)&&(time>EndTime)))
 ..s inci=$P(intrData,"^",15)
 ..s infoId=$O(^DHCITMINFO(0,"INCI",inci,""))
 ..s basicFlag=##class(web.DHCST.Common.DrugInfoCommon).GetBasicByInci(inci) //$P(^DHCITMINFO(infoId),"^",4) //基本药物标志
 ..s uom=$P(intrData,"^",10)
 ..s qty=$P(intrData,"^",6)
 ..s buomStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncBuom(inci)
 ..s buom=$P(buomStr,"^",1)
 ..s buomDesc=$P(buomStr,"^",2)
 ..i uom'=buom d
 ...s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(uom,buom)
 ...s qty=qty*fac
 ..s inciCode=$P(^INCI(inci,1),"^",1)
 ..s inciDesc=$P(^INCI(inci,1),"^",2)
 ..s Sp=$P(intrData,"^",14) //售价
 ..s Rp=$P(intrData,"^",16) //进价
 ..s Form=$P(##class(web.DHCST.Common.DrugInfoCommon).GetForm(inci),"^",2) //剂型
 ..s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 ..s Manf=$P(##class(web.DHCST.Common.DrugStkCommon).GetLastManf(inci),"^",2)
 ..s Vendor=$P(##class(web.DHCST.Common.DrugStkCommon).GetLastVen(inci),"^",2)
 ..s StkCatStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
 ..s StkCatType=$P(StkCatStr,"^",3)
 ..q:StkCatType'="G" 
 ..s StkCat=$P(StkCatStr,"^",2)

 ..s numFlag=1
 ..i basicFlag="Y" d 
 ...s numFlag=0
 ..i $d(^TMP("DHCST",$this,"GetIngdRecBasic",pid,numFlag,inci)) d
 ...s $P(^TMP("DHCST",$this,"GetIngdRecBasic",pid,numFlag,inci),"^",3)=$P(^TMP("DHCST",$this,"GetIngdRecBasic",pid,numFlag,inci),"^",3)+qty
 ..e  d
 ...s ^TMP("DHCST",$this,"GetIngdRecBasic",pid,numFlag,inci)=inciDesc_"^"_inciCode_"^"_qty_"^"_buomDesc_"^"_Rp_"^"_Sp_"^"_Form_"^"_Spec_"^"_Manf_"^"_Vendor_"^"_StkCat_"^"_basicFlag
 .
 
 s basicNum=0 //基本药物品种数
 i $d(^TMP("DHCST",$this,"GetIngdRecBasic",pid,0)) d
 .s inci=""
 .f  s inci=$O(^TMP("DHCST",$this,"GetIngdRecBasic",pid,0,inci)) q:inci=""  d
 ..s data=^TMP("DHCST",$this,"GetIngdRecBasic",pid,0,inci)
 ..s basicNum=basicNum+1
 ..d OutPutData
 s Data=$lb("基本药物品种数合计:",basicNum,"","","","","","","","","","")
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 
 s totalNum=0 //所有药物品种数
 s flagIndex=""
 f  s flagIndex=$O(^TMP("DHCST",$this,"GetIngdRecBasic",pid,flagIndex)) q:flagIndex=""  d
 .s index=""
 .f  s index=$O(^TMP("DHCST",$this,"GetIngdRecBasic",pid,flagIndex,index)) q:index=""  d
 ..s data=^TMP("DHCST",$this,"GetIngdRecBasic",pid,flagIndex,index)
 ..s totalNum=totalNum+1
 ..d OutPutData
 s Data=$lb("所有药物品种数合计:",totalNum,"","","","","","","","","","")
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 s percent=0
 s:totalNum'=0 percent=$fn((basicNum/totalNum),"",3)*100
 s percent=$fn(percent,"N")_"%"
 s Data=$lb("基本药物采购品种数占比:",percent,"","","","","","","","","","")
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
  
 k ^TMP("DHCST",$this,"GetIngdRecBasic",pid)
 Quit $$$OK
 
OutPutData
 s inciDesc=$P(data,"^",1)
 s inciCode=$P(data,"^",2)
 s qty=$P(data,"^",3)
 s buomDesc=$P(data,"^",4)
 s Rp=$P(data,"^",5)
 s Sp=$P(data,"^",6)
 s Form=$P(data,"^",7)
 s Spec=$P(data,"^",8)
 s Manf=$P(data,"^",9)
 s Vendor=$P(data,"^",10)
 s StkCat=$P(data,"^",11)
 s basicFlag=$P(data,"^",12)
 s Data=$lb(inciDesc,inciCode,qty,buomDesc,Rp,Sp,Form,Spec,Manf,Vendor,StkCat,basicFlag)
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

Query QueryStatIngrByVendor(StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "vendid:%String,Vendor:%String,PayedAmt:%String,restAmt:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","QueryStatIngrByVendor","2019-07-04","2019-12-11")
ClassMethod QueryStatIngrByVendorExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 //s ^zouxtmp("QueryStatIngrByVendor")=StartDate_","_EndDate
 i StartDate["-" s StartDate=$zdh(StartDate,3)
 i StartDate["/" s StartDate=$zdh(StartDate,4)
 i EndDate["-" s EndDate=$zdh(EndDate,3)
 i EndDate["/" s EndDate=$zdh(EndDate,4)
 s pid=..NewPid()
 k ^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor")
 
 f date=StartDate:1:EndDate d
 .s ingr=""
 .f  s ingr=$o(^DHCINGR(0,"DODate",date,ingr)) q:ingr=""  d
 ..q:'$d(^DHCINGR(ingr))

 ..s tmploc=$P(^DHCINGR(ingr),"^",13)
 ..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤	
 ..s stktype=$p(^DHCINGR(ingr),"^",30)
 ..q:stktype'="G"

 ..s vendid=$p(^DHCINGR(ingr),"^",3)
 ..s chl=""
 ..f  s chl=$o(^DHCINGR(ingr,"GRI",chl)) q:chl=""  d
 ...s ingri=ingr_"||"_chl
 ...s payid=$o(^DHCPAY(0,"TYPEGR","G",ingri,""))
 ...s payedFlag=0
 ...i payid'="" s payedFlag=1
 ...s RpAmt=$p($g(^DHCINGR(ingr,"GRI",chl)),"^",31)
 ...q:RpAmt=0
 ...s PayedAmt=##class(web.DHCST.DHCINGdRecInv).PayedAmtRecItm(ingri)
 ...s restAmt=RpAmt-PayedAmt
 ...i $d(^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid)) d
 ....s $p(^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid),"^",1)=+$p(^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid),"^",1)+PayedAmt
 ....s $p(^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid),"^",2)=+$p(^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid),"^",2)+restAmt
 ...e  s ^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid)=PayedAmt_"^"_restAmt
 f date=StartDate:1:EndDate d
 .s ingrt=""
 .f  s ingrt=$o(^INGRT(0,"AUDITDATE",date,ingrt)) q:ingrt=""  d
 ..q:'$D(^INGRT(ingrt))
 ..s tmploc=$P(^INGRT(ingrt),"^",7)
 ..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤	
 ..s stktype=$p(^INGRT(ingrt),"^",16) 
 ..q:stktype'="G"
 ..s vendid=$p(^INGRT(ingrt),"^",2)
 ..s chl=""
 ..f  s chl=$o(^INGRT(ingrt,"DHCGRR",chl)) q:chl=""  d
 ...s ingrti=ingrt_"||"_chl
 ...s payid=$o(^DHCPAY(0,"TYPEGR","R",ingrti,""))
 ...s payedFlag=0
 ...i payid'="" s payedFlag=1
 ...s RpAmt=$p($g(^INGRT(ingrt,"DHCGRR",chl)),"^",4)
 ...s PayedAmt=##class(web.DHCST.DHCINGdRecInv).PayedAmtRetItm(ingrti)
 ...s restAmt=-RpAmt-PayedAmt
 ...;i restAmt>0 s restAmt=(-1)*restAmt
 ...;i PayedAmt>0 s PayedAmt=(-1)*PayedAmt
 ...i $d(^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid)) d
 ....s $p(^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid),"^",1)=+$p(^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid),"^",1)+PayedAmt
 ....s $p(^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid),"^",2)=+$p(^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid),"^",2)+restAmt
 ...e  s ^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid)=PayedAmt_"^"_restAmt
 s vendid=""
 f  s vendid=$o(^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid)) q:vendid=""  d
 .s Vendor=$p($g(^APC("APCVM",vendid)),"^",3)
 .i Vendor["-" s Vendor=$p(Vendor,"-",2)
 .s data=^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor",vendid)
 .s PayedAmt=$p(data,"^",1)
 .s restAmt=$p(data,"^",2)
 .//q:(PayedAmt=0)&&(restAmt=0)
 .d OutPutRow5
 k ^TMP("DHCST","DHCPay","QueryStatIngrByVendor",pid,"Vendor")
 Quit $$$OK
OutPutRow5
 s Data=$lb(vendid,Vendor,PayedAmt,restAmt)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

Query QueryStatIngrVendDetail(StartDate As %String = "", EndDate As %String = "", VendId As %String = "", PayFlag As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "num,pointer:%String,inci:%String,incicode:%String,incidesc:%String,uomdesc:%String,qty:%String,Rp:%String,Sp:%String,spec:%String,PayedAmt:%Float,restAmt:%Float,No:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","QueryStatIngrVendDetail","2010-08-01","2019-11-11","","2")
ClassMethod QueryStatIngrVendDetailExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", VendId As %String = "", PayFlag As %String = "", HOSPID As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s qHandle=$lb(0,repid,0)
 q:StartDate="" $$$OK
 q:EndDate="" $$$OK
 //s ^zouxtmp("QueryStatIngrVendDetail")=$lb(StartDate,EndDate,VendId,PayFlag)
 i StartDate["-" s StartDate=$zdh(StartDate,3)
 i StartDate["/" s StartDate=$zdh(StartDate,4)
 i EndDate["-" s EndDate=$zdh(EndDate,3)
 i EndDate["/" s EndDate=$zdh(EndDate,4)
 s num=0
 s tolrestAmt=0,tolPayedAmt=0
 f date=StartDate:1:EndDate d
 .s ingr=""
 .f  s ingr=$o(^DHCINGR(0,"DODate",date,ingr)) q:ingr=""  d
 ..q:'$d(^DHCINGR(ingr))
 ..s tmploc=$P(^DHCINGR(ingr),"^",13)
 ..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤	
 ..s stktype=$p(^DHCINGR(ingr),"^",30)
 ..q:stktype'="G"
 ..s vendid=$p(^DHCINGR(ingr),"^",3)
 ..s No=$p(^DHCINGR(ingr),"^",1)
 ..q:(VendId'="")&&(vendid'=VendId)
 ..s chl=""
 ..f  s chl=$o(^DHCINGR(ingr,"GRI",chl)) q:chl=""  d
 ...s ingri=ingr_"||"_chl
 ...s payid=$o(^DHCPAY(0,"TYPEGR","G",ingri,""))
 ...s payedFlag=0
 ...i payid'="" s payedFlag=1
 ...s RpAmt=$p($g(^DHCINGR(ingr,"GRI",chl)),"^",31)
 ...q:RpAmt=0
 ...s PayedAmt=##class(web.DHCST.DHCINGdRecInv).PayedAmtRecItm(ingri)
 ...s restAmt=RpAmt-PayedAmt
 ...;q:restAmt'>0 
 ...s inci=$p($g(^DHCINGR(ingr,"GRI",chl)),"^",25)
 ...q:+inci=0
 ...s incicode=$p(^INCI(inci,1),"^",1)
 ...s incidesc=$p(^INCI(inci,1),"^",2)
 ...s uom=$p($g(^DHCINGR(ingr,"GRI",chl)),"^",10)
 ...s uomdesc=""
 ...i uom'="" s uomdesc=$p($g(^CT("UOM",uom)),"^",2)
 ...s qty=$p($g(^DHCINGR(ingr,"GRI",chl)),"^",4)
 ...s Rp=$p($g(^DHCINGR(ingr,"GRI",chl)),"^",30)
 ...s Sp=$p($g(^DHCINGR(ingr,"GRI",chl)),"^",45)
 ...s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 ...;b ;0
 ...q:(PayFlag=1)&(PayedAmt'=0)
 ...q:(PayFlag=2)&(restAmt'=0)
 ...;b ;1
 ...s type="入库"
 ...s tolrestAmt=tolrestAmt+restAmt
 ...s tolPayedAmt=tolPayedAmt+PayedAmt
 ...s num=num+1
 ...s pointer=ingr_"||"_chl
 ...d OutPutRow7
 
 f date=StartDate:1:EndDate d
 .s ingrt=""
 .f  s ingrt=$o(^INGRT(0,"AUDITDATE",date,ingrt)) q:ingrt=""  d
 ..q:'$D(^INGRT(ingrt))
 ..s tmploc=$P(^INGRT(ingrt),"^",7)
 ..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤	
 ..s stktype=$p(^INGRT(ingrt),"^",16) 
 ..q:stktype'="G"
 ..s vendid=$p(^INGRT(ingrt),"^",2)
 ..q:(VendId'="")&&(vendid'=VendId)
 ..s No=$p(^INGRT(ingrt),"^",1)
 ..s chl=""
 ..f  s chl=$o(^INGRT(ingrt,"DHCGRR",chl)) q:chl=""  d
 ...s ingrti=ingrt_"||"_chl
 ...s payid=$o(^DHCPAY(0,"TYPEGR","R",ingrti,""))
 ...s payedFlag=0
 ...i payid'="" s payedFlag=1
 ...s RpAmt=$p($g(^INGRT(ingrt,"DHCGRR",chl)),"^",4)
 ...s PayedAmt=##class(web.DHCST.DHCINGdRecInv).PayedAmtRetItm(ingrti)
 ...s restAmt=-RpAmt-PayedAmt
 ...;q:restAmt'>0 
 ...;i restAmt>0 s restAmt=(-1)*restAmt
 ...;i PayedAmt>0 s PayedAmt=(-1)*PayedAmt
 ...s inclb=$p($g(^INGRT(ingrt,"DHCGRR",chl)),"^",6)
 ...s inci=+inclb
 ...q:inci=0
 ...s incicode=$p(^INCI(inci,1),"^",1)
 ...s incidesc=$p(^INCI(inci,1),"^",2)
 ...s uom=$p($g(^INGRT(ingrt,"DHCGRR",chl)),"^",3)
 ...s uomdesc=""
 ...i uom'="" s uomdesc=$p($g(^CT("UOM",uom)),"^",2)
 ...s qty=$p($g(^INGRT(ingrt,"DHCGRR",chl)),"^",2)
 ...s Rp=$p($g(^INGRT(ingrt,"DHCGRR",chl)),"^",7)
 ...s Sp=$p($g(^INGRT(ingrt,"DHCGRR",chl)),"^",8)
 ...s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
 ...q:(PayFlag=1)&(PayedAmt'=0)
 ...q:(PayFlag=2)&(restAmt'=0)
 ...s type="退货"
 ...s tolrestAmt=tolrestAmt+restAmt
 ...s tolPayedAmt=tolPayedAmt+PayedAmt
 ...s num=num+1
 ...s pointer=ingrt_"||"_chl
 ...d OutPutRow7
 //s Data=$lb("","","","合计：","","","","","","",tolPayedAmt,tolrestAmt)   
 //s ^CacheTemp(repid,ind)=Data
 //s ind=ind+1
 Quit $$$OK
OutPutRow7
 s Data=$lb(num,pointer,inci,incicode,incidesc,uomdesc,qty,Rp,Sp,spec,PayedAmt,restAmt,No)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

Query QueryAspAmtStatByVendorLYEY(StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As websys.Query(ROWSPEC = "VendorId:%String,Vendor:%String,AspUpSpAmt:%Numeric,AspLowSpAmt:%Numeric,DiffSpAmt:%Numeric") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCST.ReportForms.DrugStorageStat","QueryAspAmtStatByVendorLYEY","2019-08-01","2019-11-11")
ClassMethod QueryAspAmtStatByVendorLYEYExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", HOSPID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:StartDate="" $$$OK
	q:EndDate="" $$$OK
	s StartDate=$zdh(StartDate,3)
	s EndDate=$zdh(EndDate,3)
	
	s pid=..NewPid()
	k ^TMP("DHCST","AspAmount","QueryAspAmtStatByVendorLYEY",pid)
	
	f dd=StartDate:1:EndDate d 
	.s aspadr=""
	.f  s aspadr=$o(^ASPA(0,"DATE",dd,aspadr)) q:aspadr=""  d
	..q:'$d(^ASPA(aspadr))
	..s tmploc=$P(^ASPA(aspadr),"^",2)
	..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(tmploc),"^",22))  //按院区过滤	
	..s Inci=$p(^ASPA(aspadr),"^",1)
	..s ScgStr=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	..s ScgType=$p(ScgStr,"^",3)
	..q:ScgType'="G"
	..s ScgDesc=$p(ScgStr,"^",4)
	..s Inclb=$p(^ASPA(aspadr),"^",14)
	..q:Inclb=""
	..s VendorInfo=##class(web.DHCST.Common.DrugStkCommon).GetInclbVend(Inclb,dd)
    ..s VendorId=$p(VendorInfo,"^",1)
    ..q:VendorId=""
    ..s AspSpAmt=+$p(^ASPA(aspadr),"^",5)
    ..q:AspSpAmt=0
    ..s AspUpSpAmt=0,AspLowSpAmt=0  //  调升/调降分开统计 
    ..i AspSpAmt>0 s AspUpSpAmt=AspSpAmt
    ..i AspSpAmt<0 s AspLowSpAmt=AspSpAmt
    ..i $d(^TMP("DHCST","AspAmount","QueryAspAmtStatByVendorLYEY",pid,"Vend",VendorId)) d
    ...s $p(^TMP("DHCST","AspAmount","QueryAspAmtStatByVendorLYEY",pid,"Vend",VendorId),"^",1)=+$p(^TMP("DHCST","AspAmount","QueryAspAmtStatByVendorLYEY",pid,"Vend",VendorId),"^",1)+AspUpSpAmt
    ...s $p(^TMP("DHCST","AspAmount","QueryAspAmtStatByVendorLYEY",pid,"Vend",VendorId),"^",2)=+$p(^TMP("DHCST","AspAmount","QueryAspAmtStatByVendorLYEY",pid,"Vend",VendorId),"^",2)+AspLowSpAmt
    ..e  s ^TMP("DHCST","AspAmount","QueryAspAmtStatByVendorLYEY",pid,"Vend",VendorId)=AspUpSpAmt_"^"_AspLowSpAmt
    
    s VendorId=""
    f  s VendorId=$o(^TMP("DHCST","AspAmount","QueryAspAmtStatByVendorLYEY",pid,"Vend",VendorId)) q:VendorId=""  d
    .s Vendor=$p($g(^APC("APCVM",VendorId)),"^",3)
    .q:Vendor="" 
    .i Vendor["-" s Vendor=$p(Vendor,"-",2)
    .s str=^TMP("DHCST","AspAmount","QueryAspAmtStatByVendorLYEY",pid,"Vend",VendorId)
    .s AspUpSpAmt=$p(str,"^",1)
    .s AspLowSpAmt=$p(str,"^",2)
    .s AspLowSpAmt=(-1)*AspLowSpAmt
    .s DiffSpAmt=AspUpSpAmt-AspLowSpAmt  //调升与调低的金额差
    .d OutPutRow4
    
    k ^TMP("DHCST","AspAmount","QueryAspAmtStatByVendorLYEY",pid)
	q $$$OK

  
OutPutRow4
	s Data=$lb(VendorId,Vendor,AspUpSpAmt,AspLowSpAmt,DiffSpAmt)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// //================报表整理====yangsj====2019-10-31======End==================/////////
/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
/// ///////////////////上面为Query方法,下面为过程函数,请按此规则////////////////////////////
/// ////////////////////// ////////////////////// ////////////////////// ///////////////////
ClassMethod QTYInci(da, inci, locdr = "")
{
	
	s da=da+1 q:da="" 0
	q:inci="" 0
	s qtysum=0
	s loc=""
	f  s loc=$o(^DHCLOCTOT(0,"LOCITMDATE",loc)) q:loc=""  d
	.q:((locdr'="")&&(locdr'=loc))
	.s dd=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,da),-1) q:dd="" 
	.s dayrowid=0
	.s dayrowid=$o(^DHCLOCTOT(0,"LOCITMDATE",loc,inci,dd,dayrowid)) q:dayrowid=""
	.s qtyend=0
	.s qtyend=$p(^DHCLOCTOT(dayrowid),"^",4)
	.s qtysum=qtysum+qtyend
	q qtysum
}

ClassMethod GetSpAmt(stdate, enddate, loc = "")
{
	s typestr="T^K"
	s sumsp=0
	s pid=..NewPid()
	d ..ClearTmp("GetSpAmt",pid,"INCIZZL")
	s cnt=$l(typestr,"^")
	f i=1:1:cnt d
	.s type=$p(typestr,"^",i)
	.f date=stdate:1:enddate d
	..s intr=0
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inci=$p(^DHCINTR(intr),"^",15)
	...s pointer=$p(^DHCINTR(intr),"^",9)  ;pointer
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...S LocID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
	...q:(loc'="")&&(LocID'=loc)
	...s amt=0
	...s amt=##class(web.DHCST.ReportForms.ReportCommon).GetAmt(type,pointer,intr)
	...s spamt=$p(amt,"^",2)
	...i type="K"  d
	....s spamt=-spamt
	...s data=inci_"^"_spamt
	...i '$d(^TMP("DHCST",$this,"GetSpAmt",pid,"INCIZZL",inci))  d
	....s ^TMP("DHCST",$this,"GetSpAmt",pid,"INCIZZL",inci)=data
	...e  d
	....s $p(^TMP("DHCST",$this,"GetSpAmt",pid,"INCIZZL",inci),"^",2)=$p(^TMP("DHCST",$this,"GetSpAmt",pid,"INCIZZL",inci),"^",2)+spamt
	...
	..
	.
	q pid
}

ClassMethod GetQTy(stdate, enddate, loc = "")
{
	//s typestr="T^K"
	s sumsp=0
	s pid=..NewPid()
	d ..ClearTmp("GetSpAmt",pid,"INCIZZL")
	//s cnt=$l(typestr,"^")
	s type=""
	f  s type=$o(^DHCINTR(0,"TypeDate",type)) q:type=""  d
	.f date=stdate:1:enddate d
	..s intr=0
	..f  s intr=$o(^DHCINTR(0,"TypeDate",type,date,intr)) q:intr=""  d
	...s inci=$p(^DHCINTR(intr),"^",15)
	...s pointer=$p(^DHCINTR(intr),"^",9)  ;pointer
	...s inclb=$p(^DHCINTR(intr),"^",7)
	...S LocID=$p(^INCI($p(inclb,"||",1),"IL",$p(inclb,"||",2)),"^",1)
	...q:(loc'="")&&(LocID'=loc)
	...s qty=$P(^DHCINTR(intr),"^",6)
	...s qty=qty*(-1)
	...s data=inci_"^"_qty
	...i '$d(^TMP("DHCST",$this,"GetSpAmt",pid,"INCIZZL",inci))  d
	....s ^TMP("DHCST",$this,"GetSpAmt",pid,"INCIZZL",inci)=data
	...e  d
	....s $p(^TMP("DHCST",$this,"GetSpAmt",pid,"INCIZZL",inci),"^",2)=$p(^TMP("DHCST",$this,"GetSpAmt",pid,"INCIZZL",inci),"^",2)+qty
	...
	..
	.
	q pid
}

/// w ##class(web.DHCST.ReportForms.DrugStorageStat).PurPlanAndIngrData(226,"2017-11-02","2017-11-06")
ClassMethod PurPlanAndIngrData(DispLocId, StartDate, EndDate, HOSPID = "")
{
	s INPPRowid="",Date=0
	s pid=..NewPid()
	d ..ClearTmp("PurPlanAndIngrData",pid)
	for Date=StartDate:1:EndDate  d
	.for  s INPPRowid=$o(^INPP(0,"DATE",Date,INPPRowid))  Q:INPPRowid=""  d
	..s LocID=$p(^INPP(INPPRowid),"^",7)
 	..q:(DispLocId'="")&&(DispLocId'=LocID)
 	..q:(HOSPID'="")&&(HOSPID'=$P(^CTLOC(LocID),"^",22))  //按院区过滤
	..s Rowid=""
	..for  s Rowid=$o(^INPP(INPPRowid,"PPI",Rowid))  Q:Rowid=""  d
	...s PlanId=+INPPRowid
	...s chl=Rowid ;$p(Rowid,"||",2)
	...Q:'$d(^INPP(PlanId,"PPI",chl))
	...s inci=$p(^INPP(PlanId,"PPI",chl),"^",2)
	...Q:'$d(^INCI(inci,1))
	...s bUomdr=$p($g(^INCI(inci,1)),"^",10)
	...s Uomdr=$p(^INPP(PlanId,"PPI",chl),"^",4)
	...s confac=##class(web.DHCSTCOMMONSRV).UOMFac(Uomdr,bUomdr)
	...s qty=$p(^INPP(PlanId,"PPI",chl),"^",3)
	...s bQty=qty*confac
	...//add by mpf 20171106增加计划与实际金额.
	...s PurPrice=$p(^INPP(PlanId,"PPI",chl),"^",5)
	...i $d(^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci)) d
	....s $p(^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci),"^",1)=+$p(^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci),"^",1)+bQty
	....s $p(^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci),"^",3)=+$p(^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci),"^",3)+PurPrice
	...e   d 
	....s ^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci)=bQty_"^"_0_"^"_PurPrice_"^"_0

	s type="G"
	f dd=StartDate:1:EndDate d
	.s intr=""
	.f  s intr=$o(^DHCINTR(0,"TypeDate",type,dd,intr)) q:intr=""  d
	..s inclb=$p(^DHCINTR(intr),"^",7)		//批次
 	..s LocID=$$LOC^ST01(inclb)
 	..q:(DispLocId'="")&&(DispLocId'=LocID)
	..s inci=$p(^DHCINTR(intr),"^",15)
	..s qty=$p(^DHCINTR(intr),"^",6)
	..s bUomdr=$p(^INCI(inci,1),"^",10)
	..s Uomdr=$p(^DHCINTR(intr),"^",10)
	..s confac=##class(web.DHCSTCOMMONSRV).UOMFac(Uomdr,bUomdr)
	..s bQty=qty*confac
	..s RpAmount=$p(^DHCINTR(intr),"^",17)
	..i $d(^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci)) d
	...s $p(^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci),"^",2)=+$p(^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci),"^",2)+bQty
	...s $p(^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci),"^",4)=+$p(^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci),"^",4)+RpAmount	//实际入库进价金额
	..e  d
	...s ^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci)=0_"^"_bQty_"^"_0_"^"_RpAmount
	..
	.
	s inci=""
	s TotalPlanQty=0,TotalIngfQty=0,TotalPlanRp=0,TotalIngfRp=0,complited=0,overfulfil=0,uncomplited=0
	f  s inci=$o(^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci)) q:inci=""  d
	.s qtystr=$g(^TMP("DHCST",$this,"PurPlanAndIngrData",pid,"INCI",inci))
	.s incicode=$p(^INCI(inci,1),"^",1)
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.s bUomDr=$p(^INCI(inci,1),"^",10)
	.s pUomDr=$p(^INCI(inci,3),"^",6)
	.s confac=##class(web.DHCSTCOMMONSRV).UOMFac(pUomDr,bUomDr)
	.s bplanqty=$p(qtystr,"^",1)	//计划
	.s bingrqty=$p(qtystr,"^",2)	//实际
	.s PlanQty=bplanqty  ;q:PlanQty=0  //modify by mpf 计划为0时不退出,将计划当做0.
	.s IngfQty=bingrqty   //入库数量
	.s PurPrice=$p(qtystr,"^",3)	//计划金额
	.s RpAmount=$p(qtystr,"^",4)	//实际金额
	.s Uomdr="",Uomdesc=""
	.i (bplanqty#confac=0)&&(bingrqty#confac=0) d
	..s PlanQty=bplanqty/confac
	..s IngfQty=bingrqty/confac
	..;统计信息
	.if PlanQty'=0   d 
	..s TotalPlanQty=TotalPlanQty+1
	..s TotalPlanRp=TotalPlanRp+PurPrice
	.if IngfQty'=0  d 
	..s TotalIngfQty=TotalIngfQty+1
	..s TotalIngfRp=TotalIngfRp+RpAmount
	.if PlanQty=IngfQty  d	
	..s complited=complited+1
	.else  if PlanQty>IngfQty  d
	..s uncomplited=uncomplited+1
	.else  if PlanQty<IngfQty  d
	..s overfulfil=overfulfil+1
	d ..ClearTmp("PurPlanAndIngrData",pid)
	s RetStr=TotalPlanQty_"^"_TotalPlanRp_"^"_TotalIngfQty_"^"_TotalIngfRp_"^"_complited_"^"_uncomplited_"^"_overfulfil
	Q RetStr
}

/// Description:新建临时global的计数器
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCST.DispPhcStat).NewPid()
ClassMethod NewPid() As %String
{
  q $I(^TMP("DHCST",$this))
}

/// Description:Kill临时global的公共方法
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCST.ReportForms.ReportCommon).ClearTmp()
ClassMethod ClearTmp(MethodName As %String, pid As %String, PAR As %String = "") As %String
{
	I PAR'="" D
	.K ^TMP("DHCST",$this,MethodName,pid,PAR)
	.K ^TEMP("DHCST",$this,MethodName,pid,PAR)
	E  D
	.K ^TMP("DHCST",$this,MethodName,pid)
	.K ^TEMP("DHCST",$this,MethodName,pid)
	Q ""
}

/// Description：获取某段时间内某业务某科室库存项发生的业务基本单位数量---
/// Creator：WangYaJun
/// CreateDate：2018-11-07
/// Input：开始日期、结束日期、科室库存项ID、业务类型串(^连接)
/// OutPut:业务发生基本单位总数量
/// Other:w ##class(web.WYJStat).GetIntrBQtyByDateType("2018-04-16","2018-04-16","5670||3","P^Y^F^H")
ClassMethod GetIntrBQtyByDateType(StDate, EndDate, Incil, TypeStr)
{
    q:(StDate="")||(EndDate="")||(Incil="")||(TypeStr="") 0
    s:$f(StDate,"-") StDate=$ZDH(StDate,3)
    s:$f(EndDate,"-") EndDate=$ZDH(EndDate,3)
    
    s TypeLen=$l(TypeStr,"^")
    s Inci=+Incil
    s BQtySum=0
    s Buom=$p(^INCI(Inci,1),"^",10)
    f i=1:1:TypeLen d
    .s Type=$p(TypeStr,"^",i)
    .f Date=StDate:1:EndDate d
    ..s Intr=""
    ..f  s Intr=$o(^DHCINTR(0,"ILTYPEDATE",Incil,Type,Date,Intr)) q:Intr=""  d
    ...s Uom=$p(^DHCINTR(Intr),"^",10)
    ...s Qty=(-1)*$p(^DHCINTR(Intr),"^",6) 
    ...s Fac=##class(web.DHCSTCOMMONSRV).UOMFac(Uom,Buom)
    ...s BQty=Qty*Fac 
    ...s BQtySum=BQtySum+BQty
    q BQtySum
}

}
