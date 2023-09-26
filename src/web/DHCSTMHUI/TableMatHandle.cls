Import sqluser

Class web.DHCSTMHUI.TableMatHandle Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Description:检索医嘱信息
/// Creator:	lihui 20180918
/// Input:		Params(StartDate^EndDate^FVendorBox^ScgStk^IncId^RecLocId...)
/// Output:		
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.TableMatHandle","Query","","",^tmpli("Querymat"))
Query Query(Params As %String) As Query(ROWSPEC = "intr,vendordr,vendor,IncId,IncCode,IncDesc,Spec,SpecDesc,inclb,BatchNo,ExpDate,IngrUomId,IngrUom,RecQty:%Float,IngrNo,Rp:%Float,RpAmt:%Float,Sp:%Float,SpAmt:%Float,oeori,doctor,PatNo,paname,ingrFlag,InvNo,InvDate,InvMoney:%Float,ingritmid,inititmid")
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
    n (qHandle,Params,%session)
    s repid=$I(^CacheTemp)
    s ind=1
    s qHandle=$lb(0,repid,0)
    q:Params="" $$$OK
    s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
    d PJobj.%FromJSON(Params)
    s StartDate=PJobj.%Get("StartDate")
    s EndDate=PJobj.%Get("EndDate") 
	i StartDate'="" s StartDate=..DH2L(StartDate)
	i EndDate'="" s EndDate=..DH2L(EndDate)
	s Vendor=PJobj.%Get("FVendorBox") 
	s SCG=PJobj.%Get("ScgStk") 
	s Inci=PJobj.%Get("InciId") 
	s LocId=PJobj.%Get("RecLocId") 
	s INGRFlag=PJobj.%Get("RecStatusBox") 
	s OrdLocId=PJobj.%Get("OeriRecLocId") 
	s pHospId=..sssHospId(LocId)
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),LocId,SCG,pHospId)
	
	s IncId=0
	f  s IncId=$o(^INCI(IncId)) q:IncId=""  d
	.q:(+IncId'>0)||'$d(^INCI(IncId,1))
	.q:(Inci'="")&&(Inci'=IncId)
	.s tableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(IncId)
	.;q:tableFlag'="Y"
	.s incsc=$p(^INCI(IncId,2),"^",2)
	.q:(incsc="")||'$d(^INC("SC",incsc))
	.s incscType=$p(^INC("SC",incsc),"^",3)
	.q:incscType'=..sssCode()	;过滤不是物资的
	.s hvFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(IncId)
	.q:hvFlag="Y"				;滤掉高值
	.s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
	.s scg=$p(scgInfo,"^",5)
	.q:(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_scg_"^"))
	.f trDate=StartDate:1:EndDate d
	..s intr=0
	..f  s intr=$o(^DHCINTR(0,"INCI",IncId,trDate,intr)) q:intr=""  d
	...s intrInfo=^DHCINTR(intr)
	...s trType=$p(intrInfo,"^",1)
	...q:(trType'="P")&&(trType'="F")&&(trType'="MP")&&(trType'="MF")
	...s pointer=$p(intrInfo,"^",9)
	...;存在退回记录的,过滤
	...q:(trType="MP")&&($d(^DHCINTR(0,"TypePointer","MY",pointer)))
	...q:(trType="MF")&&($d(^DHCINTR(0,"TypePointer","MH",pointer)))
	...q:(trType="P")&&($d(^DHCINTR(0,"TypePointer","Y",pointer)))
	...q:(trType="F")&&($d(^DHCINTR(0,"TypePointer","H",pointer)))
	...s ingrFlag=..IfIngrFlag(intr)	;UpdFlag 用作记录补录标志
	...q:(INGRFlag="N")&&(ingrFlag="Y")
	...q:(INGRFlag="Y")&&(ingrFlag'="Y") 
	...s oeori=pointer
	...s ord=$p(oeori,"||",1),ch=$p(oeori,"||",2)
	...q:(ord="")||(ch="")||('$d(^OEORD(ord,"I",ch)))
	...s ordstatus=$p(^OEC("OSTAT",$p(^OEORD(ord,"I",ch,1),"^",13)),"^",1)
	...q:(ordstatus="C")||(ordstatus="U")||(ordstatus="D")	;撤销,作废,停止 的医嘱不再处理
	...s admloc=$p(^OEORD(ord,"I",ch,3),"^",6)		;医嘱接收科室
	...q:(OrdLocId'="")&&(OrdLocId'=admloc)
	...s inclb=$p(intrInfo,"^",7)
	...s il=$p(inclb,"||",2),lb=$p(inclb,"||",3)
	...s incib=$p(^INCI(IncId,"IL",il,"LB",lb),"^",1)
	...
	...s dhcIncib=$o(^DHCINCIB(0,"INCIB",incib,0))
	...s (vendordr,vendor,SpecDesc)=""
	...i dhcIncib'="" d
	....s SpecDesc=$p(^DHCINCIB(dhcIncib),"^",13)
	....s vendordr=$p(^DHCINCIB(dhcIncib),"^",8)
	....s vendor=$S(vendordr'="":$p(^APC("APCVM",vendordr),"^",3),1:"")
	...q:vendordr=""
	...q:(Vendor'="")&&(vendordr'=Vendor)
	...
	...s doctordr=$p($g(^OEORD(ord,"I",ch,7)),"^",1)
	...s doctor=$s(doctordr'="":$p($g(^SSU("SSUSR",doctordr)),"^",2),1:"")
	...s adm=$p(^OEORD(ord),"^",1)
	...s papmidr=$p($g(^PAADM(adm)),"^",1)
	...s pano=$p($g(^PAPER(papmidr,"PAT",1)),"^",1)	;登记号
	...s paname=$p($g(^PAPER(papmidr,"ALL")),"^",1)
	...
	...s RecQty=$p(intrInfo,"^",6)
	...s IngrNo=$p(intrInfo,"^",13)
	...s IngrUomId=$p(intrInfo,"^",10)
	...s IngrUom=$p(^CT("UOM",IngrUomId),"^",2)
	...s Rp=$p(intrInfo,"^",16)
	...s RpAmt=$p(intrInfo,"^",17)
	...s Sp=$p(intrInfo,"^",14)
	...s SpAmt=$p(intrInfo,"^",8)
	...s RecQty=-RecQty,RpAmt=-RpAmt,SpAmt=-SpAmt		;负负得正
	...
	...s IncCode=$p(^INCI(IncId,1),"^",1)
	...s IncDesc=$p(^INCI(IncId,1),"^",2)
	...s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
	...
	...s batExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(inclb)
	...s BatchNo=$p(batExp,"^",1)
	...s ExpDate=$p(batExp,"^",2)
	...s ingrtitmifno=..GetInritmidByintr(intr)
	...s ingritmid=$p(ingrtitmifno,"^",1)
	...s (InvNo,InvDate)=""
	...s InvMoney=0
	...if ingritmid'="" d
	....s ingrid=+ingritmid
	....s IngrNo=$p($g(^DHCINGR(ingrid)),"^",1)
	....s InvNo=$p($g(^DHCINGR(ingrid,"GRI",$p(ingritmid,"||",2))),"^",27)
	....s InvDate=$p($g(^DHCINGR(ingrid,"GRI",$p(ingritmid,"||",2))),"^",34)
	....s:InvDate'="" InvDate=..DL2H(InvDate)
	....s InvMoney=$p($g(^DHCINGR(ingrid,"GRI",$p(ingritmid,"||",2))),"^",26)
	...s inititmid=$p(ingrtitmifno,"^",2)
	...d OutPutRow
	Quit $$$OK

OutPutRow
	s Data=$lb(intr,vendordr,vendor,IncId,IncCode,IncDesc,Spec,SpecDesc,inclb,BatchNo,ExpDate,IngrUomId,IngrUom,RecQty,IngrNo,Rp,RpAmt,Sp,SpAmt,oeori,doctor,pano,paname,ingrFlag,InvNo,InvDate,InvMoney,ingritmid,inititmid)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 
/// Description:根据医嘱台帐信息,为库房生成入库单和相应出库单
/// CreateDate:	2016-12-08
/// Creator:	wangjibin
/// Input:		MainInfo(loc^资金来源^出库接收科室), ListDetail(intr^发票号^发票日期_$c(1)_...), 人员id
/// Output:	
ClassMethod Create(MainInfo As %String, ListDetail As %String) As %String
{
	n (MainInfo,ListDetail)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(MainInfo)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s p=..NewPid()
	k ^TMP(p,"MaterialCreateRec")
	
	s mainloc=PJObj.%Get("RecLocId")
	s admloc=PJObj.%Get("ReqLocId")
	s SourceOfFund=PJObj.%Get("SourceOfFund")
	i admloc="" d RtnObj.Err(-2,"","出库接收科室为空!","",0) q RtnObj.Json()
	s $ZT="CreateError"
	
	s ingrStr="",initStr=""
	s n=0
	s PJObjItm=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObjItm.%FromJSON(ListDetail)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","明细入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s Err=""
	While (RtnObj.success=0) {
		s ItmObj=PJObjItm.%Pop()
		q:ItmObj=""
		s intr=ItmObj.%Get("intr")
		s InvNo=ItmObj.%Get("InvNo")
		s InvDate=ItmObj.%Get("InvDate")
		s InvAmt=ItmObj.%Get("InvMoney")
		s intrInfo=^DHCINTR(intr)
		s intrType=$p(intrInfo,"^",1)
		s IngrFlag=$p(intrInfo,"^",5)				;使用INTR_UpdFlag字段记录是否补录
		s qty=-$p(intrInfo,"^",6)					;使用正数
		s inclb=$p(intrInfo,"^",7)
		s uom=$p(intrInfo,"^",10)
		s rp=$p(intrInfo,"^",16)
		s sp=$p(intrInfo,"^",14)
		q:(intrType'="MP")&&(intrType'="MF")
		q:IngrFlag="Y"								;已经补录单据的,过滤
		s IngrFlag=..IfIngrFlag(intr)	;UpdFlag 用作记录补录标志
		q:IngrFlag="Y"
		s oeori=$p(intrInfo,"^",9)
		s ord=+oeori,chl=$p(oeori,"||",2)
		q:(ord="")!(chl="")
		s ostat=$p(^OEORD(ord,"I",chl,1),"^",13)	;医嘱状态id
		s oeflag=$p(^OEC("OSTAT",ostat),"^",1)
		q:(oeflag="C")||(oeflag="U")||(oeflag="D")	;撤销,作废,停止 的医嘱不再处理
		;2017-09-01 不以医嘱接收科室取值
		;s admloc=$p(^OEORD(ord,"I",chl,3),"^",6)	;以医嘱接收科室为准
		;q:admloc=""
		s vendorInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetvendorInfoByInclb(inclb)
		s apcvm=$p(vendorInfo,"^",1)
		q:apcvm=""
		s inci=$p(inclb,"||",1),il=$p(inclb,"||",2),lb=$p(inclb,"||",3)
		q:(inci="")||(il="")||(lb="")
		s scgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
		s scg=$p(scgInfo,"^",5)
		q:scg=""
		s batExp=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(inclb)
		s incib=$p(^INCI(inci,"IL",il,"LB",lb),"^",1)
		s ib=$p(incib,"||",2)
		q:ib=""
		s batno=$p(^INCI(inci,"IB",ib),"^",1)
		s expdate=$p(^INCI(inci,"IB",ib),"^",2)
		s:expdate'="" expdate=$zd(expdate,3)
		s dhcIncib=$o(^DHCINCIB(0,"INCIB",incib,0))
		s manf="",SpecDesc=""
		i dhcIncib'="" d
		.s manf=$p(^DHCINCIB(dhcIncib),"^",7)
		.s SpecDesc=$p(^DHCINCIB(dhcIncib),"^",13)
		s IngriStr=inci_"^"_batno_"^"_expdate_"^"_manf_"^"_uom_"^"_qty_"^"_rp_"^"_sp_"^"_InvNo_"^"_InvDate_"^"_InvAmt_"^"_SpecDesc_"^"_sp
		
		s n=n+1
		s ^TMP(p,"MaterialCreateRec",mainloc,apcvm,admloc,scg,n)=intr_$c(1)_IngriStr
	}
	s Err=0
	ts
	s user=PJObj.%Get("gUserId")
	s TodayDate=+$h
	s InGrRemarks=""
	s mainloc=""
	f  s mainloc=$o(^TMP(p,"MaterialCreateRec",mainloc)) q:(mainloc="")||(RtnObj.success'=0)  d
	.s apcvm="" f  s apcvm=$O(^TMP(p,"MaterialCreateRec",mainloc,apcvm)) q:(apcvm="")||(RtnObj.success'=0)  d
	..s admloc=""  f  s admloc=$o(^TMP(p,"MaterialCreateRec",mainloc,apcvm,admloc)) q:(admloc="")||(RtnObj.success'=0)  d
	...s scg=""  f  s scg=$O(^TMP(p,"MaterialCreateRec",mainloc,apcvm,admloc,scg)) q:(scg="")||(RtnObj.success'=0)  d
	....s maindata=apcvm_"^"_mainloc_"^"_user_"^"_scg_"^"_InGrRemarks_"^"_SourceOfFund_"^"_admloc  ;生成主表
	....s maintitle="ApcvmDr^RecLoc^gUserId^StkGrpId^InGrRemarks^SourceOfFund^ReqLocId"
	....s maindataobj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(maindata,maintitle)
	....s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Insert(maindataobj)	//创建主表记录
	....q:RtnObj.success'=0
	....s ingr=RtnObj.rowid
	....i ingrStr="" d
	.....s ingrStr=ingr
	....e  d
	.....s ingrStr=ingrStr_","_ingr
	....s n=0
	....f  s n=$o(^TMP(p,"MaterialCreateRec",mainloc,apcvm,admloc,scg,n)) q:(n="")||(RtnObj.success'=0)  d
	.....s intr=$p(^TMP(p,"MaterialCreateRec",mainloc,apcvm,admloc,scg,n),$c(1),1)
	.....s listData=$p(^TMP(p,"MaterialCreateRec",mainloc,apcvm,admloc,scg,n),$c(1),2)  //明细数据
	.....s listTitle="IncId^BatchNo^ExpDate^ManfId^IngrUomId^RecQty^Rp^NewSp^InvNo^InvDate^InvMoney^SpecDesc^Sp"
	.....s listDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(listData,listTitle)
	.....s PJObjlistData=##class(web.DHCSTMHUI.Common.FromJson).%New()
	.....d PJObjlistData.%FromJSON(listDataObj)
	.....s RtnObj=##class(web.DHCSTMHUI.DHCINGdRecItm).Update(ingr,PJObjlistData)
	.....q:RtnObj.success'=0
	.....s ingri=RtnObj.rowid
	.....i ingri'="" d
	......s RtnObj=..RecordIntrIngrFlag(intr,ingri,user)
	.....;i ingri'="" d RecordIntrIngrFlag(intr)			;INTRUpdFlag记录补录标志
	....q:RtnObj.success'=0
	....s ParamData=user
	....s ParamTitle="gUserId"
	....s ParamDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(ParamData,ParamTitle)
	....s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).MakeComplete(ingr,ParamDataObj,"Y")
	....q:RtnObj.success'=0
	....s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Audit(ingr,ParamDataObj,"Y")			//2014-06-25 添加第3,4参数
	....q:RtnObj.success'=0
	....s RtnObj=##class(web.DHCSTMHUI.HVMatOrdItm).CreateTransferByIngr(ingr,admloc)  //自动出库
	....q:RtnObj.success'=0
	....s init=RtnObj.rowid
	....i initStr="" d
	.....s initStr=init
	....e  d
	.....s initStr=initStr_","_init
	....s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransOutAuditYes(init,user,"","N")
	....q:RtnObj.success'=0
	....s status=31
	....&sql(update DHC_InIsTrf set INIT_State=:status where %id=:init)
	....i SQLCODE<0 d RtnObj.Err(-3,"","出库接收更改标志失败!") q
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	s Delim="^"
	s RtnObj.rowid=ingrStr_Delim_initStr
	q RtnObj.Json()
CreateError
	trollback
	k ^TMP(p,"MaterialCreateRec")
	q -100
RecordIntrIngrFlag(intr)
	n (intr)
	s intrObj=##class(User.DHCINTRANS).%OpenId(intr)
	d intrObj.%Reload()
	s intrObj.INTRUpdFlag="Y"
	d intrObj.%Save()
	k intrObj
	q
}

/// Description: 判断医嘱信息是否补录
/// Creator: lihui
/// Input:	台账ID
/// Output:	Y 已补录; N 未补录	
/// d ##class(web.DHCSTMHUI.TableMatHandle).Query("0","9999","","","2016-09-19^2018-09-19^^^^392^0^193")
ClassMethod IfIngrFlag(IntrId As %String) As %String
{
	n (IntrId)
	q:IntrId="" "N"
	s flag="N"
	s NMHid=$o(^DHCNMHR(0,"INTRAN",IntrId,""))
	i NMHid'="" d
	.s ingrid=$p(^DHCNMHR(NMHid),"^",3)
	.s ingrflag=$p(^DHCNMHR(NMHid),"^",2)
	.i ((ingrid'="")&&(ingrflag="Y")) d
	..s flag="Y"
	i flag'="Y" d  
	.s IntringrFlag=$p(^DHCINTR(IntrId),"^",5)  ;最初补录标志判断
	.i IntringrFlag="Y" s flag="Y"
	q flag
}

/// Description: 处理补录标志
/// Creator: lihui
/// Input:	台账ID,入库单明细ID
/// Output:	Y 已补录; N 未补录	
/// d ##class(web.DHCSTMHUI.TableMatHandle).RecordIntrIngrFlag("0","9999","","","2016-09-19^2018-09-19^^^^392^0^193")
ClassMethod RecordIntrIngrFlag(IntrId As %String, IngrItmid As %String, Usrid As %String) As %String
{
	n (IntrId,IngrItmid,Usrid)
	s RtnObj=##class(RtnObj).%New()
	i ((IntrId="")||(IngrItmid="")) s Sc=RtnObj.Err(-1,"","入参为空!","",0) q RtnObj
	s ret=0
	s NMHid=$o(^DHCNMHR(0,"INTRAN",IntrId,""))
	s date=+$h
	s time=$p($h,",",2)
	s ingrflag="Y"
	i NMHid'="" d
	.&sql(UPDATE DHC_NorMatHandle SET NMH_IngrFlag=:ingrflag,NMH_INGRI_DR=:IngrItmid,NMH_Date=:date,NMH_Time=:time,NMH_SSUSR_DR=:Usrid  WHERE NMH_RowId=:NMHid)
	.i SQLCODE  s ret=-2
	e  d
	.&sql(INSERT INTO DHC_NorMatHandle (NMH_INTRAN_DR, NMH_Date, NMH_Time, NMH_SSUSR_DR, NMH_IngrFlag, NMH_INGRI_DR) 
		VALUES (:IntrId,:date,:time,:Usrid,:ingrflag,:IngrItmid))
	.i SQLCODE s Sc=RtnObj.Err(-2,"","插入补录标志失败!") q 
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// 批量撤销补录
/// Author: lihui
/// Date: 20190108
/// Return:	总共条数^成功条数
/// w ##class(web.DHCSTMHUI.TableMatHandle).CancelNorMatRecStr("8780","{""gUserId"":""6423"",""gLocId"":""106"",""gGroupId"":""277"",""gHospId"":""2""}")
ClassMethod CancelNorMatRecStr(intridstr As %String, Params As %String) As %String
{
	n (intridstr,Params)
	;S ^litmp("CancelMatRecStr")=$lb(intridstr,Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q $$$OK
	s UserId=PJObj.%Get("gUserId")
	s GroupId=PJObj.%Get("gGroupId")
	s gLocId=PJObj.%Get("gLocId")
	s sucess=0
	s AppParams=GroupId_"^"_gLocId_"^"_UserId
	s IfHavePermCancel=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("HVMatOrdItm","IfHavePermCancel",AppParams)
	i IfHavePermCancel'="Y" d
	.d RtnObj.Err(-1,"","您无权撤销！","",0)
	i RtnObj.success'=0 q RtnObj.Json()
	s del="^"
	s ret=0
	s len=$l(intridstr,del)
	f i=1:1:len  d
	.s IntrId=$p(intridstr,del,i)
	.q:'$d(^DHCINTR(IntrId))
	.s err=..HandleMainLocInfo(IntrId,UserId)
  	.i err=0 d
  	..s sucess=sucess+1
  	d RtnObj.Err(0,len_"^"_sucess,"")
  	q RtnObj.Json()
}

/// Description: 取消低值医嘱补录单据的处理
/// Creator:    lihui
/// CreatDate:	20190108
/// Table:		DHC_NorMatHandle,DHC_INGdRecItm,DHC_InIsTrfItm
/// Input:		台账ID
/// Return:		0,成功；非0，错误 
/// w ##class(web.DHCSTMHUI.TableMatHandle).HandleMainLocInfo(IntrId)
ClassMethod HandleMainLocInfo(IntrId As %String, UserId As %String) As %String
{
	n (IntrId,UserId)
	q:IntrId="" 0
	//step 1		判断是否已经实库补录
	s (Ingri,IngrFlag)=""
	s NMHId=$o(^DHCNMHR(0,"INTRAN",IntrId,""))
	s IntringrFlag="N"
	i NMHId="" d
	.s IntringrFlag=$p(^DHCINTR(IntrId),"^",5)
	s INTRUpdFlag="N"
	i IntringrFlag="Y" d
	.&sql(UPDATE DHC_INTRANS SET INTR_UpdFlag=:INTRUpdFlag WHERE INTR_RowId=:IntrId)
	q:NMHId="" 0
	s Ingri=$p(^DHCNMHR(NMHId),"^",3)
	s IngrFlag=$p(^DHCNMHR(NMHId),"^",2)
	;未进行实库补录的, 不处理
	q:(IngrFlag'="Y")||(Ingri="") 0
	//step 2		获取ingri和initi(通过ingri关联获取),删除台帐,或是创建退货单(已月报或已付款等)
	s ingr=+Ingri,ingrCh=$p(Ingri,"||",2)
	s inclb=$p(^DHCINGR(ingr,"GRI",ingrCh),"^",1)
	s initi=$p(^DHCINGR(ingr,"GRI",ingrCh),"^",44)
	s isMon=##class(web.DHCSTMHUI.PCHCOLLSRela).IfMakeMon(ingr)
	s isPay=##class(web.DHCSTMHUI.PCHCOLLSRela).IfPay(Ingri)
	s AppName=##class(web.DHCSTMHUI.DHCItmTrack).%GetParameter("AppName")
	s IngrLocId=$P(^DHCINGR(ingr),"^",13)
	s HospId=$s(IngrLocId'="":$p(^CTLOC(IngrLocId),"^",22),1:"")
	s Param="^"_IngrLocId_"^^"_HospId
	s DeleteWhileOeoriOver=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue(AppName,"DeleteWhileOeoriOver",Param)
	s RtnObj=##class(RtnObj).%New()
	ts
	i ((DeleteWhileOeoriOver'="Y")||(isMon=1)||(isPay=1)){
		;DeleteWhileOeoriOver参数不为Y, 或做了月报/付款的, 进行退货制单
		s ret=0
		l +^DHCINCLCBT(inclb):20  e  q -99
		;已接收的,不重复处理
		i '$d(^DHCINTR(0,"TypePointer","K",initi)) d
		.s ret=##class(web.DHCSTMHUI.PCHCOLLSRela).TransInAuditYesItm(initi,UserId)
		i ret'=0 tro  l -^DHCINCLCBT(inclb) q -1
		s RtnObj=##class(web.DHCSTMHUI.PCHCOLLSRela).CreateInIsTrf(initi,UserId)		;生成反向库存转移单,完成状态
		i RtnObj.success<0 tro  l -^DHCINCLCBT(inclb) q -2
		s Init=RtnObj.rowid
		s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransOutAuditYes(Init,UserId,"","Y")
		i RtnObj.success'=0 tro  l -^DHCINCLCBT(inclb) q -3
		;s RtnObj=##class(web.DHCSTMHUI.DHCINIsTrf).TransInAuditYes(Init,UserId)
		;i RtnObj.success'=0 tro  l -^DHCINCLCBT(inclb) q -4
		s ingrt=##class(web.DHCSTMHUI.PCHCOLLSRela).CreateINGdRet(Ingri,UserId)	;生成退货单
		i ingrt<0 tro  l -^DHCINCLCBT(inclb) q -5
		s obj=##class(User.DHCINGDRET).%OpenId(ingrt)
		s obj.INGRTCompleted="Y"
		s sc=obj.%Save()
		i $$$ISERR(sc) l -^DHCINCLCBT(inclb) q -6
		s tmpData=ingrt_"^"_UserId
		s tmpTitle="RowId^gUserId"
		s tmpDataObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmpData,tmpTitle)
		s RtnObj=##class(web.DHCSTMHUI.DHCINGdRet).Audit(tmpDataObj)
		i RtnObj.success'=0 tro  l -^DHCINCLCBT(inclb) q -7
		l -^DHCINCLCBT(inclb)
		s tmpingri="",tmpingrflag="N"
		&sql(UPDATE DHC_NorMatHandle SET NMH_IngrFlag=:tmpingrflag,NMH_INGRI_DR=:tmpingri WHERE NMH_RowId=:NMHId)
	}else{
		s ret=0
		;2018-03-21 跟台高值若进行了自动接收,则删除相应台帐(2018-08-06 医嘱台帐不删)
		i $d(^DHCINTR(0,"TypePointer","K",initi)) d
		.s ret=##class(web.DHCSTMHUI.Common.StockHandle).DelIntrs("K",initi)
		i ret'=0 tro  q -41
		s ret=##class(web.DHCSTMHUI.Common.StockHandle).DelIntrs("T",initi)
		i ret'=0 tro  q -41
		&sql(delete from DHC_INIsTrfItm where %id=:initi)
		s last=$o(^DHCINIT(+initi,"ITI",""),-1)
		i last=0 d
		.s init=+initi
		.&sql(delete from DHC_INIsTrf where %id=:init)
		//删除入库台帐,入库子表等
		s ret=##class(web.DHCSTMHUI.Common.StockHandle).DelIntrs("G",Ingri)
		i ret'=0 tro  q -42
		&sql(delete from DHC_INGdRecItm where %id=:Ingri)
		s last=$o(^DHCINGR(ingr,"GRI",""),-1)
		i last="" d
		.&sql(delete from DHC_INGdRec where %id=:ingr)
		s tmpingri="",tmpingrflag="N"
		&sql(UPDATE DHC_NorMatHandle SET NMH_IngrFlag=:tmpingrflag,NMH_INGRI_DR=:tmpingri WHERE NMH_RowId=:NMHId)
	}
	tc
	q 0
}

/// Description: 获取补录入库明细ID
/// Creator: lihui 20190805
/// Input:	台账ID
/// Output:	入库明细ID	
/// d ##class(web.DHCSTMHUI.TableMatHandle).GetInritmidByintr("")
ClassMethod GetInritmidByintr(IntrId As %String) As %String
{
	n (IntrId)
	q:IntrId="" ""
	s ingritmid=""
	s NMHid=$o(^DHCNMHR(0,"INTRAN",IntrId,""))
	i NMHid'="" d
	.s ingrid=$p(^DHCNMHR(NMHid),"^",3)
	.s ingritmid=$p(^DHCNMHR(NMHid),"^",3)
	s inititm=""
	i ingritmid'="" d
	.&sql(SELECT INITI_RowId into:inititm FROM DHC_InIsTrfItm WHERE INITI_INGRI_DR=:ingritmid)
	q ingritmid_"^"_inititm
}

}
