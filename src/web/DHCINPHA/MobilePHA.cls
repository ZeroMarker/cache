Import sqluser

Class web.DHCINPHA.MobilePHA Extends (%RegisteredObject, %XML.Adaptor) [ Not ProcedureBlock ]
{

/// Drescript:	验证用户名密码并且返回可以登录的科室
/// Creater:	zhouyg
/// CreateDate:	2016-08-09
/// Input:		用户工号,密码
/// Return：	Json格式字符串
/// w ##class(web.DHCINPHA.MobilePHA).logon("dthealth","130")
ClassMethod logon(userName As %String, password As %String) As %String
{
		n (userName , password )
		s $zt="errorLogon"
		s userId=##class(web.SSUser).IsValidUser(userName,password)
		s json=##class(%ArrayOfDataTypes).%New()
		i userId<0 d
		.s errorInfo=$s(userId="-100":"用户不存在",userId="-101":"密码不正确",userId="-102":"用户没有激活",1:"")
		s sscode="",ssname="" 
		i +userId>0 d
		.s sscode=$p(^SSU("SSUSR",userId),"^",1)
		.s ssname=$p(^SSU("SSUSR",userId),"^",2)
		.s sspwd=$p(^SSU("SSUSR",userId),"^",3)
		.s errorInfo=""
		s chkloc=1
		s locJson=..getUserLoc(userId)
		d json.SetAt($g(errorInfo),"ErrorInfo")
		d json.SetAt($g(locJson),"Locs")
		d json.SetAt(userId,"UserID")
		d json.SetAt(sscode,"UserCode")
		d json.SetAt(ssname,"UserName")
		//d json.SetAt($g(sspwd),"UserPwd")
		i ($g(errorInfo)="")&&(locJson.Count()=0) d
		.s errorInfo="用户没有可登陆的科室"
		.d json.SetAt($g(errorInfo),"ErrorInfo")
		q ##class(Nur.JSON).Encode(json)
errorLogon
	s error=$ze
	s json=##class(%ArrayOfDataTypes).%New()
	d json.SetAt($g(error),"ErrorInfo")
	q ##class(Nur.JSON).Encode(json)
}

/// Descript: 	取用户科室列表
/// Creater：	zhouyg
/// CreateDate：2016-08-09
/// Table：		SS_User
/// Input：		UserID:SS_User表ID
/// Return：	
ClassMethod getUserLoc(userId As %String) As %ListOfDataTypes
{
		n (userId)
		s locJson=##class(%ListOfDataTypes).%New()
		q:+userId=0 locJson
		q:'$d(^SSU("SSUSR",userId)) locJson

		s ssuser=userId
		s ctlocdr=$p(^SSU("SSUSR",ssuser),"^",4)
		s ctloc=$p(^CTLOC(ctlocdr),"^",2)
		i $f(ctloc,"-") s ctloc=$p(ctloc,"-",2)
		s grpdr=$p(^SSU("SSUSR",ssuser),"^",5)
		s grpdesc=$p(^SSU("SSGRP",grpdr),"^",1)
		//
		s locChildJson=##class(%ArrayOfDataTypes).%New()
		d locChildJson.SetAt(ctlocdr,"ctlocdr")
		d locChildJson.SetAt(ctloc,"ctloc")
		d locChildJson.SetAt(grpdr,"grpdr")
		d locChildJson.SetAt(grpdesc,"grpdesc")
		d locJson.Insert(locChildJson)
		
		s chl=""
		f  s chl=$o(^SSU("SSUSR",ssuser,"OTHLL",chl)) q:chl=""  d
		.s ctlocdr=$p(^SSU("SSUSR",ssuser,"OTHLL",chl),"^",1)
		.q:ctlocdr=""
		.s ctloc=$p(^CTLOC(ctlocdr),"^",2)
		.i $f(ctloc,"-") s ctloc=$p(ctloc,"-",2)
		.s grpdr=$p(^SSU("SSUSR",ssuser,"OTHLL",chl),"^",2)
		.q:grpdr=""
		.s grpdesc=$p(^SSU("SSGRP",grpdr),"^",1)
		.s locChildJson=##class(%ArrayOfDataTypes).%New()
		.d locChildJson.SetAt(ctlocdr,"ctlocdr")
		.d locChildJson.SetAt(ctloc,"ctloc")
		.d locChildJson.SetAt(grpdr,"grpdr")
		.d locChildJson.SetAt(grpdesc,"grpdesc")
		.d locJson.Insert(locChildJson)
		
		q locJson
}

/// Drescript:	取当前需配药病区列表
/// Creater:	zhouyg
/// CreateDate:	2016-08-09
/// Input:		药房科室ID
/// Return:		病区科室描述^病人科室ID^病区ID
/// D ##class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","GetDispWard","94") 
Query GetDispWard(displocrowid As %String) As websys.Query(ROWSPEC = "WardDesc:%String,WardLocID:%String,WardID:%String,DrawType:%String,DispType:%String") [ SqlProc ]
{
}

ClassMethod GetDispWardExecute(ByRef qHandle As %Binary, displocrowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:displocrowid="" $$$OK
	s result=..DispensingWards(displocrowid)
	s num=$p(result,"^",1)
	s wardPid=$p(result,"^",2)
	q:num=0 $$$OK
	s WardLoc=""
	f  s WardLoc=$o(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","DispensingWards",wardPid,WardLoc)) q:WardLoc=""  d
	.s DispType=""
	.f  s DispType=$o(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","DispensingWards",wardPid,WardLoc,DispType)) q:DispType=""  d
	..s WardDesc=$p(^CTLOC(WardLoc),"^",2)
	..s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLoc,""))
	..s DispTypeDesc=$select(DispType=1:"送药",DispType=2:"取药")
	..d outputrow
	k ^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","DispensingWards",wardPid)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
outputrow
	i WardDesc["-" s WardDesc=$p(WardDesc,"-",2)
	s Data=$lb(WardDesc,WardLoc,WardId,DispTypeDesc,DispType)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// Descript：	取待配药病区列表
/// Input：		phaloc-药房科室ID
/// 
ClassMethod DispensingWards(phaloc As %String) As %String
{
 n (phaloc)
 //s ^hlh($h)=$lb(phaloc)
 s pid=..GetWardPid()
 k ^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","DispensingWards",pid)
 s n=0
 s WardLoc="" 
 f  s WardLoc=$o(^DHCOEDISQTY(0,"STATUS",phaloc,"TC",WardLoc)) q:WardLoc=""  d
 .q:$d(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","DispensingWards",pid,WardLoc))
 .s WardId=$o(^PAWARD(0,"WARD_LocationDR",WardLoc,""))
 .q:WardId=""
 .s Flag=0
 .s Cat=0
 .f  s Cat=$o(^DHCOEDISQTY(0,"STATUS",phaloc,"TC",WardLoc,Cat)) q:(Cat="")!(Flag=1)   d
 ..s datedosing=""
 ..f  s datedosing=$o(^DHCOEDISQTY(0,"STATUS",phaloc,"TC",WardLoc,Cat,datedosing)) q:(datedosing="")!(Flag=1)   d
 ...s DspId=0
 ...f  s DspId=$o(^DHCOEDISQTY(0,"STATUS",phaloc,"TC",WardLoc,Cat,datedosing,DspId)) q:(DspId="")!(Flag=1)  d
 ....q:$d(^DHCPHDRAWi("DSP",DspId))
 ....s DispFlag=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetDispFlag(DspId)
 ....q:DispFlag=0
 ....s DispType=1	//暂时写死 送药模式
 ....s ^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","DispensingWards",pid,WardLoc,DispType)=""
 ....s Flag=1
 ....s n=n+1
 q n_"^"_pid
}

ClassMethod GetWardPid() As %String
{
 q $I(^DHCSTPHARMACY("DispWard"))
}

/// Drescript:	取当前备药单药品列表(备药界面)
/// Creater:	zhouyg
/// CreateDate:	2016-08-09
/// Input:		备药单ID
/// Return:		备药单药品明细
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","GetDrawItm","56210")
Query GetDrawItm(DrawID As %String) As websys.Query(ROWSPEC = "IncDesc:%String,IncQty:%String,IncID:%String,DWIncID:%String,CompFlag:%String,Spec:%String,IncCode:%String,drawSortID:%String,StkBinDesc:%String,IncDescSpecManf:%String,DrawType:%String,applyNum:%String") [ SqlProc ]
{
}

ClassMethod GetDrawItmExecute(ByRef qHandle As %Binary, DrawID As %String) As %Status
{
	
	k ^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmExecute")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:DrawID="" $$$OK
	s phalocID=$p(^DHCPHDRAW(DrawID),"^",2)
	s drawSortID=$p(^DHCPHDRAW(DrawID),"^",16)
	s DrawType=$p(^DHCPHDRAW(DrawID),"^",4)
	s DrawIncSub=0
	f  s DrawIncSub=$o(^DHCPHDRAW(DrawID,"INC",DrawIncSub)) q:DrawIncSub=""  d
	.s IncID=$p(^DHCPHDRAW(DrawID,"INC",DrawIncSub),"^",1)
	.s applyNum=$p(^DHCPHDRAW(DrawID,"INC",DrawIncSub),"^",2)
	.s QtyTotal=applyNum	
	.s CompFlag=$p(^DHCPHDRAW(DrawID,"INC",DrawIncSub),"^",5)	//是否备药完成
	.s PackFlag=$p(^DHCPHDRAW(DrawID,"INC",DrawIncSub),"^",13)
	.s:PackFlag="" PackFlag=1
	.s phdwuomdr=$p(^DHCPHDRAW(DrawID,"INC",DrawIncSub),"^",4)
	.s BinStr=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocIncBin(phalocID,IncID)
	.s Bin=$p(BinStr,",",1) //货位ID
	.i Bin=""  d
	..s StkBinDesc=""
	.e  d
	..s StkBinDesc=$p($g(^INC("SB",Bin)),"^",2)
	.
	.i Bin="" d
	..s SortSN="99999"
	.e  d
	..s PHDWSIChildSub=$o(^DHCPHDWSORT(0,"PHDINCSB",Bin,drawSortID,""))
	..i PHDWSIChildSub=""  d
	...s SortSN="99999"
	..e  d
	...s SortSN=+$p(^DHCPHDWSORT(drawSortID,"I",PHDWSIChildSub),"^",1)
	.i CompFlag="Y" d
	..s SortComp=0
	.e  d
	..s SortComp=1
	.s IncDesc=$p(^INCI(IncID,1),"^",2)	
	.S Spec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",IncID)
	.s IncCode=$p(^INCI(IncID,1),"^",1)
	.s DWIncID=DrawID_"||"_DrawIncSub
	.s PHDrawOrderSub=""
	.f  s PHDrawOrderSub=$o(^DHCPHDRAW(DrawID,"INC",DrawIncSub,"ORDER",PHDrawOrderSub))  q:PHDrawOrderSub=""  d
	..s PHDWORefFlag=$p(^DHCPHDRAW(DrawID,"INC",DrawIncSub,"ORDER",PHDrawOrderSub),"^",3)
	..s PHDWOStopFlag=$p(^DHCPHDRAW(DrawID,"INC",DrawIncSub,"ORDER",PHDrawOrderSub),"^",4)
	..s PHDWOQty=$p(^DHCPHDRAW(DrawID,"INC",DrawIncSub,"ORDER",PHDrawOrderSub),"^",2)
	..s PHDWOPHRIDr=$p(^DHCPHDRAW(DrawID,"INC",DrawIncSub,"ORDER",PHDrawOrderSub),"^",5)
	..s PHRIStatus=$p(^DHCINPHREQ(+PHDWOPHRIDr,"I",$p(PHDWOPHRIDr,"||",2)),"^",2)
	..i PHDWORefFlag="Y" d 
	...s QtyTotal=QtyTotal-PHDWOQty
	..
	.;整包装按照入库单位显示，散包装按照备药单位显示
	.i PackFlag=1 d
	..s IncQty=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(IncID,QtyTotal)
	..s applyNum=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(IncID,applyNum)
	.e  d
	..s IncQty=QtyTotal_##class(web.DHCINPHA.MTCommon.PublicCallMethod).ReplaceBracket($p(^CT("UOM",phdwuomdr),"^",2))
	..s applyNum=applyNum_##class(web.DHCINPHA.MTCommon.PublicCallMethod).ReplaceBracket($p(^CT("UOM",phdwuomdr),"^",2))
	.s ^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmExecute",repid,SortComp,PackFlag,SortSN,DWIncID)=IncDesc_"^"_IncQty_"^"_IncID_"^"_DWIncID_"^"_CompFlag_"^"_Spec_"^"_IncCode_"^"_DrawType_"^"_applyNum_"^"_StkBinDesc
	.
	
	s SortComp=""
	f  s SortComp=$o(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmExecute",repid,SortComp)) q:SortComp=""  d
	.s PackFlag=""
	.f  s PackFlag=$o(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmExecute",repid,SortComp,PackFlag),-1) q:PackFlag=""  d
	..s SortSN=0
	..f  s SortSN=$o(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmExecute",repid,SortComp,PackFlag,SortSN)) q:SortSN=""  d
	...s DWIncID=0
	...f  s DWIncID=$o(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmExecute",repid,SortComp,PackFlag,SortSN,DWIncID)) q:DWIncID=""  d
	....s gstr=^(DWIncID)
	....s IncDesc=$p(gstr,"^",1)
	....s IncQty=$p(gstr,"^",2)
	....s IncID=$p(gstr,"^",3)
	....s GoodName=##Class(web.DHCST.Common.DrugInfoCommon).GetGoodName(IncID)  
	....s Generic=$p(IncDesc,"[",1)
	....s:GoodName'="" Generic=Generic_"-"_GoodName
	....s DWIncID=$p(gstr,"^",4)
	....s CompFlag=$p(gstr,"^",5)
	....s Spec=$p(gstr,"^",6)
	....s IncCode=$p(gstr,"^",7)
	....s DrawType=$p(gstr,"^",8)
	....s applyNum=$p(gstr,"^",9)
	....s StkBinDesc=$p(gstr,"^",10)
	....d outputrowDI
	...
	..
	.
	Set qHandle=$lb(0,repid,0)	
	Quit $$$OK	
outputrowDI	
	s Data=$lb(Generic,IncQty,IncID,DWIncID,CompFlag,Spec,IncCode,drawSortID,StkBinDesc,IncDesc,DrawType,applyNum)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// Drescript:	取当前备药单药品的医嘱明细
/// Creater:	zhouyg
/// CreateDate:	2016-08-09
/// Input:		备药单药品汇总表ID
/// Return:		备药单医嘱明细
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","GetDrawItmOrder","1||1")
Query GetDrawItmOrder(DrawIncID As %String) As websys.Query(ROWSPEC = "IPNo:%String,PatName:%String,BedNo:%String,OrdDateTime:%String,DspQty:%String,DrawOrderID:%String") [ SqlProc ]
{
}

ClassMethod GetDrawItmOrderExecute(ByRef qHandle As %Binary, DrawIncID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:DrawIncID="" $$$OK
	s DrawID=$p(DrawIncID,"||",1)
	s DrawIncSub=$p(DrawIncID,"||",2)
	q:(DrawID="")!(DrawIncSub="") $$$OK
	s DrawOrderSub=0
	f  s DrawOrderSub=$o(^DHCPHDRAW(DrawID,"INC",DrawIncSub,"ORDER",DrawOrderSub)) q:DrawOrderSub=""  d
	.s DrawOrderStr=^(DrawOrderSub)
	.s RefFlag=$p(DrawOrderStr,"^",3)
	.s StopFlag=$p(DrawOrderStr,"^",4)
	.q:RefFlag="Y"
	.//q:StopFlag="Y"
	.s DspBatchID=$p(DrawOrderStr,"^",1)
	.s DspID=+DspBatchID
	.s DspQty=$p(DrawOrderStr,"^",2)
	.s DrawOrderID=DrawID_"||"_DrawIncSub_"||"_DrawOrderSub
	.d outputrowDIO
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
outputrowDIO
	s (IPNo,PatName,BedNo)=""
	s oeoritmID=$p(^DHCOEDISQTY(DspID),"^",1)
	s dateDosing=$p(^DHCOEDISQTY(DspID),"^",21)
	s timeDosing=$p(^DHCOEDISQTY(DspID),"^",20)
	i dateDosing'="" s dateDosing=$zd(dateDosing,3)
	i timeDosing'="" s timeDosing=$zt(timeDosing,1)
	s OrdDateTime=dateDosing_" "_timeDosing
	s oeord=$p(oeoritmID,"||",1)
	s oesub=$p(oeoritmID,"||",2)
	s admID=$p(^OEORD(oeord),"^",1)
	s papmi=$p(^PAADM(admID),"^",1)
	i papmi'="" d
	.s PatName=$p(^PAPER(papmi,"ALL"),"^",1)
	.s IPNo=$p(^PAPER(papmi,"PAT",1),"^",1)
	s AdmWard=$p(^PAADM(admID),"^",70)
	s AdmLoc=""
	i AdmWard'="" d
	.s AdmLoc=$p($g(^PAWARD(AdmWard)),"^",5)
	s dspWardLoc=$p(^DHCOEDISQTY(DspID),"^",22)
	i AdmLoc=dspWardLoc d
	.s BedId=$p(^PAADM(admID),"^",73)
	.s BedWID=$p(BedId,"||",1)
	.s BedSub=$p(BedId,"||",2)
	.q:(BedWID="")!(BedSub="")
	.s BedNo=$p($g(^PAWARD(BedWID,"BED",BedSub)),"^",1)
	s IncID=$p(^DHCPHDRAW(DrawID,"INC",DrawIncSub),"^",1)
	s IncDesc=$p(^INCI(IncID,1),"^",2)
	s buomID=$p(^INCI(IncID,1),"^",10)
	s puomID=$p(^INCI(IncID,3),"^",6)
	s uomFac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomID,buomID)
	i uomFac=0 d
	.s IncQty=DspQty
	.s uomDesc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).ReplaceBracket($p(^CT("UOM",buomID),"^",2))
	e  d
	.s remainQty=DspQty#uomFac
	.i remainQty=0 d
	..s IncQty=DspQty/uomFac
	..s uomDesc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).ReplaceBracket($p(^CT("UOM",puomID),"^",2))
	.e  d
	..s IncQty=DspQty
	..s uomDesc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).ReplaceBracket($p(^CT("UOM",buomID),"^",2))
	s Data=$lb(IPNo,PatName,BedNo,OrdDateTime,IncQty_uomDesc,DrawOrderID)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// Drescript:	取当前未完成备药单列表(备药界面)
/// Editor:	yaoxin
/// CreateDate:	2017-03-20
/// Input:		药房科室ID(必须)
/// Return:		备药单药品明细
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","GetDrawList","94")
Query GetDrawList(PhaLocID As %String) As websys.Query(ROWSPEC = "DrawID:%String,DrawNo:%String,WardLocDesc:%String,DrawType:%String,DrawStatus:%String,CreateDate:%String,CreateUser:%String") [ SqlProc ]
{
}

ClassMethod GetDrawListExecute(ByRef qHandle As %Binary, PhaLocID As %String) As %Status
{
	//s ^tmpyx("GetDrawListExecute")=PhaLocID
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:PhaLocID="" -1
	s DrawID=0
	f  s DrawID=$o(^DHCPHDRAWi("Status",PhaLocID,25,DrawID)) q:DrawID=""  d
	.s DrawStatus=$p(^DHCPHDRAW(DrawID),"^",5)
	.s sDrawStatus=$select(DrawStatus="25":"暂停中",1:"")
	.s DrawNo=$p(^DHCPHDRAW(DrawID),"^",1)
	.s swardLocDr=$p(^DHCPHDRAW(DrawID),"^",3)
	.s WardLocDesc=$p(^CTLOC(swardLocDr),"^",51)
	.s:WardLocDesc="" WardLocDesc=$p(^CTLOC(swardLocDr),"^",2)
	.s DrawType=$p(^DHCPHDRAW(DrawID),"^",4)
	.s sDrawType=$select(DrawType=1:"送药",DrawType=2:"取药",DrawType=3:"毒麻",DrawType=4:"精神",1:"")
	.s sCreateUser=$p(^DHCPHDRAW(DrawID),"^",6)
	.s CreateUserName=$p($g(^SSU("SSUSR",sCreateUser)),"^",2)
	.s DateCreate=$p(^DHCPHDRAW(DrawID),"^",9)
	.s TimeCreate=$p(^DHCPHDRAW(DrawID),"^",10)
	.s sDateCreate=$zd(DateCreate,3)
	.s sTimeCreate=$zt(TimeCreate,1)
	.s DateTime=sDateCreate_" "_sTimeCreate
	.d outputrowDrawList
	s DrawID=0
	f  s DrawID=$o(^DHCPHDRAWi("Status",PhaLocID,20,DrawID)) q:DrawID=""  d
	.s DrawStatus=$p(^DHCPHDRAW(DrawID),"^",5)
	.s sDrawStatus=$select(DrawStatus="20":"备药中",1:"")
	.s DrawNo=$p(^DHCPHDRAW(DrawID),"^",1)
	.s swardLocDr=$p(^DHCPHDRAW(DrawID),"^",3)
	.s WardLocDesc=$p(^CTLOC(swardLocDr),"^",51)
	.s:WardLocDesc="" WardLocDesc=$p(^CTLOC(swardLocDr),"^",2)
	.s DrawType=$p(^DHCPHDRAW(DrawID),"^",4)
	.s sDrawType=$select(DrawType=1:"送药",DrawType=2:"取药",DrawType=3:"毒麻",DrawType=4:"精神",1:"")
	.s sCreateUser=$p(^DHCPHDRAW(DrawID),"^",6)
	.s CreateUserName=$p($g(^SSU("SSUSR",sCreateUser)),"^",2)
	.s DateCreate=$p(^DHCPHDRAW(DrawID),"^",9)
	.s TimeCreate=$p(^DHCPHDRAW(DrawID),"^",10)
	.s sDateCreate=$zd(DateCreate,3)
	.s sTimeCreate=$zt(TimeCreate,1)
	.s DateTime=sDateCreate_" "_sTimeCreate
	.d outputrowDrawList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
outputrowDrawList
	s Data=$lb(DrawID,DrawNo,WardLocDesc,sDrawType,sDrawStatus,DateTime,CreateUserName)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// Drescript:	取备药单药品列表(装箱核对界面)
/// Creator:	yaoxin
/// CreateDate:	2017-03-22
/// Input:		备药单ID
/// Return:		备药单药品明细
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","GetDrawItmCK","102"," ","227")
Query GetDrawItmCK(DispLocId As %String, DistinguishFlag As %String, WardLocId As %String) As websys.Query(ROWSPEC = "IncDesc:%String,ApplyQtyUom:%String,DrawQtyUom:%String,IncID:%String,DrawIdStr:%String,CompPackFlag:%String,Spec:%String,OtherName:%String,ApplyQty:%String,DrawQty:%String") [ SqlProc ]
{
}

ClassMethod GetDrawItmCKExecute(ByRef qHandle As %Binary, DispLocId As %String, DistinguishFlag As %String, WardLocId As %String) As %Status
{
	n (qHandle,DispLocId,DistinguishFlag,WardLocId)
	k ^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmCKExecute")
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	q:DispLocId="" $$$OK
	q:WardLocId="" $$$OK
	//s ^hlh($h)=$lb(DispLocId,DistinguishFlag,WardLocId)
	s PHDWRowID=""
	s DrawIncIdStr=""
	s DrawIdStr=""
	f  s PHDWRowID=$o(^DHCPHDRAWi("Status",DispLocId,"40",PHDWRowID)) q:PHDWRowID=""  d
	.s PHDWWardLocDr=$p(^DHCPHDRAW(PHDWRowID),"^",3)
	.q:PHDWWardLocDr'=WardLocId //过滤病区
	.s PHDWType=$p(^DHCPHDRAW(PHDWRowID),"^",4)
	.q:PHDWType'=1 //过滤类型	
	.i DrawIdStr="" d
	..s DrawIdStr=PHDWRowID
	.e  d
	..s DrawIdStr=DrawIdStr_"#"_PHDWRowID
	.s PHDWIChildSub=""	
	.f  s PHDWIChildSub=$o(^DHCPHDRAW(PHDWRowID,"INC",PHDWIChildSub)) q:PHDWIChildSub=""  d
	..s PHDWIRowID=PHDWRowID_"||"_PHDWIChildSub
	..s PHDWIInciDr=$p(^DHCPHDRAW(PHDWRowID,"INC",PHDWIChildSub),"^",1)
	..s IncDesc=$p(^INCI(PHDWIInciDr,1),"^",2)
	..s INCAROWID=$o(^INCALIAS(0,"INCI",PHDWIInciDr,""))
	..s INCATEXT=""
	..s:INCAROWID="" INCATEXT=""
	..s:INCAROWID'="" INCATEXT=$p(^INCALIAS(INCAROWID),"^",4)
	..S Spec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",PHDWIInciDr)
	..s PHDWICompFlag=$p(^DHCPHDRAW(PHDWRowID,"INC",PHDWIChildSub),"^",5)
	..q:PHDWICompFlag'="Y"
	..s PHDWICompPackFlag=$p(^DHCPHDRAW(PHDWRowID,"INC",PHDWIChildSub),"^",12)
	..b
	..q:(DistinguishFlag="1")&&(PHDWICompPackFlag="Y")
	..i PHDWICompPackFlag="Y" d
	...s CompPackFlag=0 //完成审核
	..e  d
	...s CompPackFlag=1 //未成审核
	..s DrawOrderSub=""
	..s DrawQty=0
	..s ApplyQty=0
	..i DrawIncIdStr="" d
	...s DrawIncIdStr=PHDWIRowID
	..e  d
	...s DrawIncIdStr=DrawIncIdStr_"#"_PHDWIRowID
	..f  s DrawOrderSub=$o(^DHCPHDRAW(PHDWRowID,"INC",PHDWIChildSub,"ORDER",DrawOrderSub)) q:DrawOrderSub=""  d
	...s PHDWORowID=PHDWRowID_"||"_PHDWIChildSub_"||"_DrawOrderSub
	...s DrawOrderStrs=^(DrawOrderSub)
	...s PHDWOQty=$p(DrawOrderStrs,"^",2)
	...s PHDWOPHRIDr=$p(DrawOrderStrs,"^",5)
	...s PHRRowID=$p(PHDWOPHRIDr,"||",1)
	...s PHRIChildSub=$p(PHDWOPHRIDr,"||",2)	
	...s PHRIDspBatchDr=$p(^DHCPHDRAW(PHDWRowID,"INC",PHDWIChildSub,"ORDER",DrawOrderSub),"^",1)
	...s PHRIDspDr=+PHRIDspBatchDr
	...s DSPQty=$p(^DHCOEDISQTY(PHRIDspDr,"I",$p(PHRIDspBatchDr,"||",2)),"^",2)
	...s RefFlag=$p(DrawOrderStrs,"^",3)
	...i RefFlag'="Y" d
	....s DrawQty=DrawQty+PHDWOQty //备药数量
	...;q:RefFlag="Y"
	...;s DrawQty=DrawQty+PHDWOQty //备药数量
	...s PHRIStatus=$p(^DHCINPHREQ(PHRRowID,"I",PHRIChildSub),"^",2) 
	...q:PHRIStatus="05" //撤销发药
	...s ApplyQty=ApplyQty+DSPQty //申请数量 放在备药过滤之后	
	..i '$d(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmCKExecute",repid,CompPackFlag,PHDWIInciDr)) d
	...s ^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmCKExecute",repid,CompPackFlag,PHDWIInciDr)=PHDWIInciDr_"^"_IncDesc_"^"_ApplyQty_"^"_DrawQty_"^"_DrawIdStr_"^"_DrawIncIdStr_"^"_CompPackFlag_"^"_Spec_"^"_INCATEXT
	..e  d
	...s $p(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmCKExecute",repid,CompPackFlag,PHDWIInciDr),"^",3)=$p(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmCKExecute",repid,CompPackFlag,PHDWIInciDr),"^",3)+ApplyQty
	...s $p(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmCKExecute",repid,CompPackFlag,PHDWIInciDr),"^",4)=$p(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmCKExecute",repid,CompPackFlag,PHDWIInciDr),"^",4)+DrawQty
	..
	.
	s CompPackFlag=""
	f  s CompPackFlag=$o(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmCKExecute",repid,CompPackFlag))  q:CompPackFlag=""  d
	.s InciId=""
	.f  s InciId=$o(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetDrawItmCKExecute",repid,CompPackFlag,InciId))  q:InciId=""  d
	..s InciIdStr=^(InciId)
	..s Inci=$p(InciIdStr,"^",1)
	..s IncDesc=$p($p(InciIdStr,"^",2),"[",1)
	..s Generic=##class(web.DHCST.Common.DrugInfoCommon).GetGene(Inci)
	..s Generic=$p(Generic,"^",2)
	..s GoodName=##Class(web.DHCST.Common.DrugInfoCommon).GetGoodName(Inci)  
	..s:GoodName'="" IncDesc=IncDesc_"-"_GoodName	
	..s ApplyQty=$p(InciIdStr,"^",3)
	..s DrawQty=$p(InciIdStr,"^",4)
	..s DrawIdStr=DrawIdStr // 多次装箱核对 串一起 备药ID
	..s CompPackFlag=$p(InciIdStr,"^",7)
	..s Spec=$p(InciIdStr,"^",8)
	..s OtherName=$p(InciIdStr,"^",9)
	..d outputrowDICK
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
outputrowDICK
	s ApplyQtyStr=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(Inci,ApplyQty)
	s ApplyQtyUom=$p(ApplyQtyStr,"^",1)_##class(web.DHCINPHA.MTCommon.PublicCallMethod).ReplaceBracket($p(ApplyQtyStr,"^",2))
	s DrawQtyStr=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(Inci,DrawQty)
	s DrawQtyUom=$p(DrawQtyStr,"^",1)_##class(web.DHCINPHA.MTCommon.PublicCallMethod).ReplaceBracket($p(DrawQtyStr,"^",2))
	s Data=$lb(IncDesc,ApplyQtyUom,DrawQtyUom,Inci,DrawIdStr,CompPackFlag,Spec,OtherName,ApplyQty,DrawQty)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// Drescript:	转换发药数量及单位
/// Creater:	zhouyg
/// CreateDate:	2016-08-01
/// Input:		库存项ID,基本单位数量
/// Return:		数量^单位
ClassMethod ConvertQtyUom(IncID As %String, bQty As %String) As %String
{
	n (IncID,bQty)
	q:IncID="" ""
	q:'$d(^INCI(IncID,1)) ""
	s buomID=$p(^INCI(IncID,1),"^",10)
	s puomID=$p($g(^INCI(IncID,3)),"^",6)
	s uomFac=+##Class(web.DHCSTCOMMONSRV).UOMFac(puomID,buomID)
	s remainQty=bQty#uomFac
	i remainQty=0 d
	.s IncQty=bQty/uomFac
	.s uomDesc=$p(^CT("UOM",puomID),"^",2)
	.i uomDesc["[" s uomDesc=$p(uomDesc,"[")
	e  d
	.s billUomStr=##Class(web.DHCSTCOMMARC).GetArcBuomByInc(IncID)
	.s billUomID=$p(billUomStr,"^",1)
	.s billUomDesc=$p(billUomStr,"^",2)
	.i billUomDesc["[" s billUomDesc=$p(billUomDesc,"[")
	.s billuomFac=+##Class(web.DHCSTCOMMONSRV).UOMFac(billUomID,buomID)
	.s bremainQty=bQty#billuomFac
	.i bremainQty=0 d
	..s IncQty=bQty/billuomFac
	..s uomDesc=billUomDesc
	.e  d
	..s IncQty=bQty
	..s uomDesc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).ReplaceBracket($p(^CT("UOM",buomID),"^",2))
	..i uomDesc["[" s uomDesc=$p(uomDesc,"[")
	q IncQty_"^"_uomDesc
}

/// Drescript:	获取病区信息（请领单手动选择界面病区列表显示）
/// Creator:	yaoxin
/// CreateDate:	2017-03-06
/// Input:	
/// Return:	    病区明细
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","GetWardInfo")
Query GetWardInfo() As websys.Query(ROWSPEC = "WardCode:%String,WardId:%String,WardLocId:%String") [ SqlProc ]
{
}

ClassMethod GetWardInfoExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1
	s CTLOCRowID=""
	f  s CTLOCRowID=$o(^CTLOC(0,"LocType","W",CTLOCRowID)) q:CTLOCRowID=""  d
	.Q:'$D(^DHCPHSLi("PHLOC",311,CTLOCRowID))
	.S WardCode=$p(^CTLOC(CTLOCRowID),"^",51)
	.s:WardCode="" WardCode=$p(^CTLOC(CTLOCRowID),"^",2)
	.s WardRowId=$o(^PAWARD(0,"WARD_LocationDR",CTLOCRowID,""),-1)
	.d OutPutGetWardInfo
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
OutPutGetWardInfo
	s Data=$lb(WardCode,WardRowId,CTLOCRowID)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// Drescript:	获取请领单信息（请领单界面）
/// Creator:	yaoxin
/// CreateDate:	2017-03-08
/// Input:		ConnectNo(关联单号),WardLocDr(病区科室ID),ReqType(请领类型)
/// Return:	    PHRNo(请领单号),PHRConnectNo(关联单号),ReqDateTime(请领日期时间),ReqCount(请领笔数)
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","GetApplicationInfo"," ","227","1")
Query GetApplicationInfo(ConnectNo As %String, WardLocDr As %String, ReqType As %String) As websys.Query(ROWSPEC = "PHRNo:%String,PHRConnectNo:%String,ReqDateTime:%String,ReqCount:%String,PHRRowID:%String,PHRWardLocDr:%String,PHRReqType:%String,WardCode:%String,WPGGroupDesc:%String") [ SqlProc ]
{
}

ClassMethod GetApplicationInfoExecute(ByRef qHandle As %Binary, ConnectNo As %String, WardLocDr As %String, ReqType As %String) As %Status
{
	n (qHandle,ConnectNo,WardLocDr,ReqType)
	//s ^yxtmp("GetApplicationInfo")=ConnectNo_"^"_WardLocDr_"^"_ReqType
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1	
	k ^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetApplicationInfo")	
	s PHRRowID=0
	f  s PHRRowID=$o(^DHCINPHREQ(PHRRowID)) q:PHRRowID=""  d
	.s PHRStatus=$p($g(^DHCINPHREQ(PHRRowID)),"^",8)
	.q:PHRStatus=""
	.q:PHRStatus'=10
	.s PHRConnectNo=$p(^DHCINPHREQ(PHRRowID),"^",13)
	.q:(ConnectNo'=" ")&&(ConnectNo'=PHRConnectNo)
	.s PHRWardLocDr=$p($g(^DHCINPHREQ(PHRRowID)),"^",2)
	.q:PHRWardLocDr=""
	.s WardRowId=$o(^PAWARD(0,"WARD_LocationDR",PHRWardLocDr,""),-1)
	.s WardCode=$p(^PAWARD(WardRowId),"^",2)
	.q:(WardLocDr'=" ")&&(WardLocDr'=PHRWardLocDr)
	.s PHRReqType=$p(^DHCINPHREQ(PHRRowID),"^",7)
	.s PHRReqTypeDesc=""
	.s:PHRReqType=3 PHRReqTypeDesc="-毒性"   
	.s:PHRReqType=4 PHRReqTypeDesc="-麻醉"  
	.s:PHRReqType=5 PHRReqTypeDesc="-精一" 
	.s:PHRReqType=6 PHRReqTypeDesc="-精二"
	.s:PHRReqType=3 PHRReqType=2   //精神毒麻 都是取药
	.s:PHRReqType=4 PHRReqType=2  //精神毒麻 都是取药
	.s:PHRReqType=5 PHRReqType=2  //精神毒麻 都是取药
	.s:PHRReqType=6 PHRReqType=2  //精神毒麻 都是取药
	.q:(ReqType'=" ")&&(ReqType'=PHRReqType)
	.s PHRNo=$p(^DHCINPHREQ(PHRRowID),"^",1)
	.s PHRReqDate=$zd($p(^DHCINPHREQ(PHRRowID),"^",5),3)
	.s PHRReqTime=$zt($p(^DHCINPHREQ(PHRRowID),"^",6),1)
	.s ReqDateTime=PHRReqDate_" "_PHRReqTime
	.s PHRWardGroupDR=$p($g(^DHCINPHREQ(PHRRowID)),"^",14)
	.s WPGGroupDesc=""
	.i PHRWardGroupDR'="" s WPGGroupDesc=$p(^DHCWardProGroup(PHRWardGroupDR),"^",2)	
	.s PHRIChildSub="",ReqCount=0
	.f  s PHRIChildSub=$o(^DHCINPHREQ(PHRRowID,"I",PHRIChildSub)) q:PHRIChildSub=""  d
	..s PHRIStatus=$p(^DHCINPHREQ(PHRRowID,"I",PHRIChildSub),"^",2)
	..q:PHRIStatus'=10
	..s ReqCount=ReqCount+1
	.i PHRConnectNo="" s PHRConnectNo=" "
	.s ^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetApplicationInfo",repid,PHRConnectNo,PHRRowID)=PHRNo_PHRReqTypeDesc_"^"_PHRConnectNo_"^"_ReqDateTime_"^"_ReqCount_"^"_PHRRowID_"^"_PHRWardLocDr_"^"_PHRReqType_"^"_WardCode_"^"_WPGGroupDesc	
	s PHRConnectNo=""
	f  s PHRConnectNo=$o(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetApplicationInfo",repid,PHRConnectNo))  q:PHRConnectNo=""  d
	.s PHRRowID=""
	.f  s PHRRowID=$o(^TMP("DHCINPHA","web.DHCINPHA.MobilePHA","GetApplicationInfo",repid,PHRConnectNo,PHRRowID))  q:PHRRowID=""  d
	..s str=^(PHRRowID)
	..s PHRNo=$p(str,"^",1)
	..s PHRConnectNo=$p(str,"^",2)
	..s ReqDateTime=$p(str,"^",3)
	..s ReqCount=$p(str,"^",4)
	..s PHRRowID=$p(str,"^",5)
	..s PHRWardLocDr=$p(str,"^",6)
	..s PHRReqType=$p(str,"^",7)
	..s WardCode=$p(str,"^",8)
	..s WPGGroupDesc=$p(str,"^",9)
	..d OutPutGetApplicationInfo
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
OutPutGetApplicationInfo
	s Data=$lb(PHRNo,PHRConnectNo,ReqDateTime,ReqCount,PHRRowID,PHRWardLocDr,PHRReqType,WardCode,WPGGroupDesc)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// Drescript:	拒绝发药原因(备药界面)
/// Creator:	yaoxin
/// CreateDate:	2017-03-16
/// Input:		
/// Return:	    RFRowid(拒绝ID),RFCode(拒绝代码),RFDesc(拒绝描述)
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","GetRefuseReason")
Query GetRefuseReason() As websys.Query(ROWSPEC = "RFRowid:%String,RFCode:%String,RFDesc:%String") [ SqlProc ]
{
}

ClassMethod GetRefuseReasonExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1	
	s RFRowid=0
	f  s RFRowid=$o(^DHCRFREASON(RFRowid)) q:RFRowid=""  d
	.s RFCode=$p(^DHCRFREASON(RFRowid),"^",1)
	.s RFDesc=$p(^DHCRFREASON(RFRowid),"^",2)	
	.d OutPutGetRefuseReason
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
OutPutGetRefuseReason
	s Data=$lb(RFRowid,RFCode,RFDesc)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// Drescript:	排序绑定下拉框(备药界面)
/// Creator:	yaoxin
/// CreateDate:	2017-03-17
/// Input:		
/// Return:	    PHDWSRowID(线路ID),PHDWSDesc(线路名称)
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","GetSortInfo","94")
Query GetSortInfo(DispLocId As %String) As websys.Query(ROWSPEC = "PHDWSRowID:%String,PHDWSDesc:%String") [ SqlProc ]
{
}

ClassMethod GetSortInfoExecute(ByRef qHandle As %Binary, DispLocId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
	Set ind=1	
	s PHDWSRowID=0
	f  s PHDWSRowID=$o(^DHCPHDWSORTi("PHLoc",DispLocId,PHDWSRowID)) q:PHDWSRowID=""  d
	.s PHDWSDesc=$p(^DHCPHDWSORT(PHDWSRowID),"^",1)
	.d OutPutGetSortInfo
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
OutPutGetSortInfo
	s Data=$lb(PHDWSRowID,PHDWSDesc)
	s ^CacheTemp(repid,ind)=Data	
	s ind=ind+1
	q
}

/// Descript: 	更新备药单状态 (备药界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-17
/// Table：		DHC_PHDraw
/// Input：		DrawId(备药主表ID),Status(备药单状态)
/// Return：	>0，成功;<0，错误	
/// d ##Class(web.DHCINPHA.MobilePHA).UpdatePHDrawStatus("7")
ClassMethod UpdatePHDrawStatus(DrawId As %String, Status As %String) As %Library.String
{
	//s ^tmpyx("UpdatePHDrawStatus")=DrawId_"^"_Status
	n (DrawId,Status)
	s Err=0
	q:DrawId="" -201
	&SQL(Update DHC_PHDraw set PHDW_Status=:Status where PHDW_RowID=:DrawId)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_PHDraw",DrawId,SQLCODE_":"_$g(%msg))
    .s Err=-200
	.q:SQLCODE'=0
	q:SQLCODE'=0 Err
	q Err
}

/// Descript: 	仅备药完成时用 (备药界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-17
/// Table：		DHC_PHDraw
/// Input：		DrawId(备药主表ID),Status(备药单状态)
/// Return：	>0，成功;<0，错误	
/// d ##Class(web.DHCINPHA.MobilePHA).UpdatePHDrawStatus("7")
ClassMethod UpdateDrawCompData(DrawId As %String, Status As %String, UserId As %String) As %Library.String
{
	//s ^tmpyx("UpdatePHDrawStatus")=DrawId_"^"_Status_"^"_UserId
	n (DrawId,Status,UserId)
	s Err=0
	q:DrawId="" -201
	q:Status="" -202
	q:UserId="" -203
	s PHDWDateCreate=$p($h,",",1)
	s PHDWTimeCreate=$p($h,",",2)
	&SQL(Update DHC_PHDraw set PHDW_Status=:Status,PHDW_UserComp_Dr=:UserId,PHDW_DateComp=:PHDWDateCreate,PHDW_TimeComp=:PHDWTimeCreate where PHDW_RowID=:DrawId)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_PHDraw",DrawId,SQLCODE_":"_$g(%msg))
    .s Err=-200
	.q:SQLCODE'=0
	q:SQLCODE'=0 Err
	q Err
}

/// Descript: 	扫码查找备药单状态
/// Creator：	yaoxin
/// CreateDate：2017-03-17
/// Table：		DHC_PHDraw
/// Input：		DrawId(备药主表ID),Status(备药单状态)
/// Return：	>0，成功;<0，错误	
/// w ##Class(web.DHCINPHA.MobilePHA).DrawStatus("CB42A11C1","94")
/// 如果有备药单号 证明关联单号 状态是>20 如果没有备药单号，证明没有生成备药单<20
/// 如果有备药单号 状态是25 那么此备药单是暂停状态，20 此状态在备药中，30备药完成。等等
ClassMethod DrawStatus(ConnectNo As %String, DispLocId As %String) As %Library.String
{
	n (ConnectNo,DispLocId)
	q:ConnectNo="" -1
	q:DispLocId="" -2
	s PHRRowID=$o(^DHCINPHREQi(0,"DispLocConnectNo",DispLocId,ConnectNo,""),-1)
	q:PHRRowID="" -3
	s PHRDrawDr=$p(^DHCINPHREQ(PHRRowID),"^",9)
	q:PHRDrawDr="" -4
	s PHRStatus=$p(^DHCINPHREQ(PHRRowID),"^",8)
	s WardLoc=$p(^DHCINPHREQ(PHRRowID),"^",2)
	s WardDesc=$p(^CTLOC(WardLoc),"^",2)
	s PHDWStatus=$p(^DHCPHDRAW(PHRDrawDr),"^",5)
	q PHDWStatus_"^"_PHRDrawDr_"^"_WardDesc
}

/// Descript: 	判断是否有暂停中的备药单
/// Creator：	yaoxin
/// CreateDate：2017-03-20
/// Table：		DHC_PHDraw
/// Input：		DispLocId(发药科室ID)
/// Return		返回1，成功 ""没有
/// d ##Class(web.DHCINPHA.MobilePHA).PauseDraw("94")
/// d ##class(User.DHCPHDraw).%BuildIndices()
ClassMethod PauseDraw(DispLocId As %String) As %Library.String
{
	n (DispLocId)
	s RetVal=""
	q:DispLocId="" -1
	s PHRRowID=""
	f  s PHRRowID=$o(^DHCPHDRAWi("DispLocId",DispLocId,PHRRowID))  q:PHRRowID=""  d
	.s PHDWStatus=$p(^DHCPHDRAW(PHRRowID),"^",5)
	.i PHDWStatus=25 d
	..s RetVal=1
	.q:PHDWStatus=25
	.i PHDWStatus=20 d
	..s RetVal=1
	.q:PHDWStatus=20
	q RetVal
}

/// Descript: 	通过条码取药品ID
/// Creator：	yaoxin
/// CreateDate：2017-03-21
/// Table：		INC_ALIAS
/// Input：		BarCode(条码)
/// Return		InciId 药品ID
/// d ##Class(web.DHCINPHA.MobilePHA)BarCodeByInciId("94")
ClassMethod BarCodeByInciId(BarCode As %String) As %Library.String
{
	n (BarCode)
	s InciId=""
	q:BarCode="" -1
	s INCADesc=""
	f  s INCADesc=$o(^INCALIAS(0,"ALIAS",$$ALPHAUP^SSUTIL4(BarCode),$$ALPHAUP^SSUTIL4(INCADesc)))  q:INCADesc=""  d
	.s INCAROWID=""
	.f  s INCAROWID=$o(^INCALIAS(0,"ALIAS",$$ALPHAUP^SSUTIL4(BarCode),$$ALPHAUP^SSUTIL4(INCADesc),INCAROWID))  q:INCAROWID=""  d
	..s INCAINCIDR=$p(^INCALIAS(INCAROWID),"^",1)
	..i INCAINCIDR'="" d
	...s InciId=INCAINCIDR	
	q InciId
}

/// Descript: 	备药确认药品置标志(备药界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-21
/// Table：		DHC_PHDrawInc
/// Input：		BarCode(条码)
/// Return		InciId 药品ID
/// w ##Class(web.DHCINPHA.MobilePHA).ConfirmDrug("5||1","4638")
/// w ##class(web.DHCINPHA.MTCommon.PublicServiceMethod).HandleDispStock("19||2","5773")
ClassMethod ConfirmDrug(PHDWIRowID As %String, UserId As %String) As %Library.String
{
	
	n (PHDWIRowID,UserId)
	s Err=0
	q:PHDWIRowID="" -1
	q:UserId="" -1
	;s $ZT="Error^DHCSTERROR"
	s $zt = "OnCreateErrorHandler"
	s pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid($this)
	s PHDWRowID=$p(PHDWIRowID,"||",1)
	s PHDWIChildSub=$p(PHDWIRowID,"||",2)	
	tstart
	s PHDWIQtyTotal=$p(^DHCPHDRAW(PHDWRowID,"INC",PHDWIChildSub),"^",2) //备药数量
	s ActualQty=0
	s PHDWOChildSub=""
	f  s PHDWOChildSub=$o(^DHCPHDRAW(PHDWRowID,"INC",PHDWIChildSub,"ORDER",PHDWOChildSub))  q:(PHDWOChildSub="")||(Err'=0)  d
	.s PHDWOPHRIDr=$p(^DHCPHDRAW(PHDWRowID,"INC",PHDWIChildSub,"ORDER",PHDWOChildSub),"^",5)
	.s Err=..UpdateInPhReqItmStatus(PHDWOPHRIDr,"30")
	.q:Err<0 
	.s PHDWORefFlag=$p(^DHCPHDRAW(PHDWRowID,"INC",PHDWIChildSub,"ORDER",PHDWOChildSub),"^",3)
	.q:PHDWORefFlag="Y"
	.s PHDWOQty=$p(^DHCPHDRAW(PHDWRowID,"INC",PHDWIChildSub,"ORDER",PHDWOChildSub),"^",2)
	.s ActualQty=ActualQty+PHDWOQty
	.s PHDWORowID=PHDWRowID_"||"_PHDWIChildSub_"||"_PHDWOChildSub
	.s Err=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).HandleDispStock(PHDWORowID,UserId,pid) //	;减库存操作
	.q:Err<0 
	i Err<0  tro  
	q:Err<0 Err
	s Err=..UpdatePHDrawIncCompFlag(PHDWIRowID,UserId,ActualQty)
	i Err<0  tro  
	q:Err<0 Err
	tcommit
	q Err
OnCreateErrorHandler
	TROLLBACK
	q Err
}

/// Descript: 	更新请领表子表明细状态 (备药界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-21
/// Table：		DHC_InPhReqItm
/// Input：		PHRIRowID(请领发药子表ID),Status(状态)
/// Return：	>0，成功;<0，错误	
/// d ##Class(web.DHCINPHA.MobilePHA).UpdateInPhReqItmStatus("7||1","30")
ClassMethod UpdateInPhReqItmStatus(PHRIRowID As %String, Status As %String) As %Library.String
{
	
	n (PHRIRowID,Status)
	s Err=0
	q:PHRIRowID="" -201
	q:Status="" -202
	s PHRRowID=$p(PHRIRowID,"||",1)
	s PHRIChildSub=$p(PHRIRowID,"||",2)
	s PHRIStatus=$p(^DHCINPHREQ(PHRRowID,"I",PHRIChildSub),"^",2)
	q:PHRIStatus="05" 0 //撤销状态不可更改		
	&SQL(Update DHC_InPhReqItm set PHRI_Status=:Status where PHRI_RowID=:PHRIRowID)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_InPhReqItm",PHRIRowID_"^"_Status,SQLCODE_":"_$g(%msg))
    .s Err=-200
	.q:SQLCODE'=0
	q:SQLCODE'=0 Err
	q Err
}

/// Descript: 	更新请备药子表完成标志 (备药界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-21
/// Table：		DHC_PHDrawInc
/// Input：		CompFlag(备药发药子表ID)
/// Return：	>0，成功;<0，错误	
/// d ##Class(web.DHCINPHA.MobilePHA).UpdateInPhReqItmStatus("7")
ClassMethod UpdatePHDrawIncCompFlag(PHDWIRowID As %String, UseRId As %String, QtyActual As %String) As %Library.String
{
	
	n (PHDWIRowID,UseRId,QtyActual)
	s Err=0
	q:PHDWIRowID="" -201
	q:UseRId="" -202
	q:QtyActual="" -203
	s PHDWIDateComp=$p($h,",",1)
	s PHDWITimeComp=$p($h,",",2)
	&SQL(Update DHC_PHDrawInc set PHDWI_CompFlag='Y',PHDWI_DateComp=:PHDWIDateComp,PHDWI_TimeComp=:PHDWITimeComp,PHDWI_UserComp_Dr=:UseRId,PHDWI_QtyActual=:QtyActual where PHDWI_RowID=:PHDWIRowID)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_PHDrawInc",PHDWIRowID,SQLCODE_":"_$g(%msg))
    .s Err=-200
	.q:SQLCODE'=0
	q:SQLCODE'=0 Err
	q Err
}

/// Drescript:	备药单完成时更改备药单主表请领单主表状态
/// Creator:	yaoxin
/// CreateDate:	2017-03-21
/// Input:		DispLocId(发药科室ID),DrawID(备药单主表ID)
/// Return:	    0成功
/// w ##Class(web.DHCINPHA.MobilePHA).ConfirmDrugMainTable("7","94",11)
/// d ##class(User.DHCInPhReq).%BuildIndices()
ClassMethod ConfirmDrugMainTable(DrawID As %String, DispLocId As %String, UserId As %String) As %Library.String
{
	n (DrawID,DispLocId,UserId)
	q:DrawID="" -1
	q:DispLocId="" -2
	q:UserId="" -3
	s $ZT="Error^DHCSTERROR"
	tstart
	s Err=""	
	s Err=..UpdateDrawCompData(DrawID,"30",UserId)
	i Err<0 trollback  q Err
	s PHRRowID=""
	f  s PHRRowID=$o(^DHCINPHREQi("DispLocDrawId",DispLocId,DrawID,PHRRowID)) q:PHRRowID=""  d
	.s Err=..UpdateDHCInPhReqStatus(PHRRowID,"30")
	.q:Err<0  
	i Err<0  tro  q Err
	tcommit
	q Err
}

/// Drescript:	备药单完成更新请领单主表状态
/// Creator:	yaoxin
/// CreateDate:	2017-03-21
/// Input:		PHRRowID(请领表ID),Status(请领表状态)
/// Return:	    0成功
/// d ##Class(web.DHCINPHA.MobilePHA).UpdateDHCInPhReqStatus("7")
ClassMethod UpdateDHCInPhReqStatus(PHRRowID As %String, Status As %Text)
{
	n (PHRRowID,Status)
	q:Status="" -201	
	q:PHRRowID="" -202
	s Err=""
	&SQL(Update DHC_InPhReq set PHR_Status=:Status where PHR_RowID=:PHRRowID)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_InPhReq",PHRRowID_"^"_Status,SQLCODE_":"_$g(%msg))
    .s Err=-200
	q:SQLCODE'=0 
	q Err
}

/// Drescript:	把备药完成的备药单和请领单置成装箱中状态(装箱核对)
/// Creator:	yaoxin
/// CreateDate:	2017-03-22
/// Table:		DHC_PHDraw DHC_InPhReq
/// Input:		DispLocId(发药科室ID)
/// Return:	    0成功
/// w ##Class(web.DHCINPHA.MobilePHA).UpdateDrawInPhReqStatusCheckBox("94")
ClassMethod UpdateDrawInPhReqStatusCheckBox(DispLocId As %String, WardLocId As %String) As %Library.String
{
	n (DispLocId,WardLocId)
	q:DispLocId="" -1
	q:WardLocId="" -2
	s $ZT="Error^DHCSTERROR"
	tstart
	s Err=""
	s PHDWRowID=""
	f  s PHDWRowID=$o(^DHCPHDRAWi("Status",DispLocId,"30",PHDWRowID)) q:(PHDWRowID="")||(Err<0)  d
	.s PHDWWardLocDr=$p(^DHCPHDRAW(PHDWRowID),"^",3)
	.q:PHDWWardLocDr'=WardLocId //过滤病区
	.s PHDWType=$p(^DHCPHDRAW(PHDWRowID),"^",4)
	.q:PHDWType'=1 //过滤类型
	.s Err=..UpdatePHDrawStatus(PHDWRowID,"40")
	.q:Err<0
	.s PHRRowID=""
	.f  s PHRRowID=$o(^DHCINPHREQi("DispLocDrawId",DispLocId,PHDWRowID,PHRRowID)) q:(PHRRowID="")||(Err<0)  d
	..s PHRWardLocDr=$p(^DHCINPHREQ(PHRRowID),"^",2)
	..q:PHRWardLocDr'=WardLocId
	..s PHRReqType=$p(^DHCINPHREQ(PHRRowID),"^",7)
	..q:PHRReqType'=1
	..s Err=..UpdateDHCInPhReqStatus(PHRRowID,"40")
	..q:Err<0
	i Err<0  tro  q Err
	tcommit
	q Err
}

/// Drescript:	把备药完成的备药单和请领单置成装箱中状态(装箱核对)
/// Creator:	yaoxin
/// CreateDate:	2017-03-22
/// Table:		DHC_PHDraw DHC_InPhReq
/// Input:		DispLocId(发药科室ID)
/// Return:	    0成功
/// w ##Class(web.DHCINPHA.MobilePHA).SaveSendDispDataCheckBox("82","114","94","1847")
ClassMethod SaveSendDispDataCheckBox(DrawStr As %String, WardLocId As %String, DispLocId As %String, UserId As %String) As %Library.String
{
	n (DrawStr,WardLocId,DispLocId,UserId)
	q:DrawStr="" -1
	q:WardLocId="" -2
	q:DispLocId="" -3
	q:UserId="" -4
	s Params=DispLocId_"^"_UserId_"^"_"1"
	s Err=""
	s Err=##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).SaveSendDispData(WardLocId,Params,DrawStr)
	q Err
}

/// Drescript:	核对汇总药品子表置状态(装箱核对)
/// Creator:	yaoxin
/// CreateDate:	2017-03-23
/// Table:		DHC_PHDrawInc DHC_InPhReqItm
/// Input:		InciId(药品ID)，UserId(操作人)，DrawStr(备药主表ID串)
/// Return:	    0成功
/// w ##Class(web.DHCINPHA.MobilePHA).UpdateDrawReqCompStatus("2339","5782","56210","256447")
ClassMethod UpdateDrawReqCompStatus(InciId As %String, UserId As %String, DrawStr As %String, PhaRowId As %String) As %Library.String
{
	n (InciId,UserId,DrawStr,PhaRowId)
	//s ^hlh($h)=$lb(InciId,UserId,DrawStr,PhaRowId)
	q:InciId="" -1
	q:UserId="" -2
	q:DrawStr="" -3
	q:PhaRowId="" -4
	tstart
	s $ZT="Error^DHCSTERROR"
	s Err=0
	s ActualQty=0
	s DrawNum=$l(DrawStr,"#")
	f index=1:1:DrawNum d
	.s DrawId=$p(DrawStr,"#",index)
	.s PHDWIChildSub=""
	.f  s PHDWIChildSub=$o(^DHCPHDRAWi("INCI",InciId,DrawId,PHDWIChildSub))  q:(PHDWIChildSub="")||(Err<0)  d
	..s PHDWIRowID=DrawId_"||"_PHDWIChildSub
	..s PHDWIQtyActual=$p(^DHCPHDRAW(DrawId,"INC",PHDWIChildSub),"^",3)
	..s PHDWICompPackFlag=$p(^DHCPHDRAW(DrawId,"INC",PHDWIChildSub),"^",12)  //20171219 yx add 多个备药单 可能有先后顺序 备过的药得过滤掉 会有装箱过
	..q:PHDWICompPackFlag="Y"
	..s ApplyQty=0
	..s PHDWOChildSub=""
	..f  s PHDWOChildSub=$o(^DHCPHDRAW(DrawId,"INC",PHDWIChildSub,"ORDER",PHDWOChildSub)) q:(PHDWOChildSub="")||(Err<0)  d
	...s PHDWOPHRIDr=$p(^DHCPHDRAW(DrawId,"INC",PHDWIChildSub,"ORDER",PHDWOChildSub),"^",5)
	...s PHRRowID=$p(PHDWOPHRIDr,"||",1)
	...s PHRIChildSub=$p(PHDWOPHRIDr,"||",2)
	...s PHRIStatus=$p(^DHCINPHREQ(PHRRowID,"I",PHRIChildSub),"^",2) 
	...s PHDWORowID=DrawId_"||"_PHDWIChildSub_"||"_PHDWOChildSub
	...s Err=##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).SaveSendDispDetail(PhaRowId,PHDWORowID) ;增库存
	...q:Err<0
	...q:PHRIStatus="05" //撤销发药
	...s PHRIDspDr=$p(^DHCINPHREQ(PHRRowID,"I",PHRIChildSub),"^",1)
	...s DSPQty=$p(^DHCOEDISQTY(PHRIDspDr),"^",11)
	...s ApplyQty=ApplyQty+DSPQty //申请数量 放在备药过滤之后
	...s Err=..UpdateInPhReqItmStatus(PHDWOPHRIDr,"50")
	...q:Err<0 
	..i Err<0  tro 
	..q:Err<0
	..
	..i PHDWIQtyActual>ApplyQty  d
	...s ActualQty=ApplyQty 
	..i ApplyQty>PHDWIQtyActual  d
	...s ActualQty=PHDWIQtyActual
	..i ApplyQty=PHDWIQtyActual  d
	...s ActualQty=PHDWIQtyActual
	..s Err=..UpdateDrawIncPackFlag(PHDWIRowID,UserId,ActualQty) 
	..i Err<0  tro
	..q:Err<0 
	.
	i Err<0  tro  
	q:Err<0 Err
	tcommit
	q Err
}

/// Descript: 	更新请备药子表装箱核对标志 (装箱核对)
/// Creator：	yaoxin
/// CreateDate：2017-03-23
/// Table：		DHC_PHDrawInc
/// Input：		CompFlag(备药发药子表ID)
/// Return：	>0，成功;<0，错误	
/// d ##Class(web.DHCINPHA.MobilePHA).UpdateInPhReqItmStatus("7")
ClassMethod UpdateDrawIncPackFlag(PHDWIRowID As %String, UserId As %String, ActualQty As %String) As %Library.String
{
	
	n (PHDWIRowID,UserId,ActualQty)
	s Err=0
	q:PHDWIRowID="" -201
	q:UserId="" -202
	q:ActualQty="" -203
	s PHDWIDatePack=$p($h,",",1)
	s PHDWITimePack=$p($h,",",2)
	s SqlStr=PHDWIRowID_"^"_UserId_"^"_ActualQty
	&SQL(Update DHC_PHDrawInc set PHDWI_CompPackFlag='Y',PHDWI_DatePack=:PHDWIDatePack,PHDWI_TimePack=:PHDWITimePack,PHDWI_UserPack_Dr=:UserId,PHDWI_QtyActual=:ActualQty where PHDWI_RowID=:PHDWIRowID)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_PHDrawInc",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-200
	.q:SQLCODE'=0
	q:SQLCODE'=0 Err
	q Err
}

/// Drescript:	核对汇总药品主表置状态(装箱核对)
/// Creator:	yaoxin
/// CreateDate:	2017-03-24
/// Table:		DHC_PHDraw DHC_InPhReq
/// Input:		UserId(操作人)，DrawStr(备注主表ID串)
/// Return:	    0成功
/// w ##Class(web.DHCINPHA.MobilePHA).UpdateMainDrawReqCompStatus("11","7#8")
/// d ##class(User.DHCPHDrawInc).%BuildIndices()
ClassMethod UpdateMainDrawReqCompStatus(UserId As %String, DrawStr As %String) As %Library.String
{
	n (UserId,DrawStr)
	q:UserId="" -1
	q:DrawStr="" -2	
	s $ZT="Error^DHCSTERROR"
	tstart
	s Err=""	
	s DrawNum=$l(DrawStr,"#")
	f index=1:1:DrawNum d
	.s DrawId=$p(DrawStr,"#",index)
	.s Err=..UpdateDrawPackData(DrawId,"50",UserId)
	.q:Err<0  
	.s DispLocId=$p(^DHCPHDRAW(DrawId),"^",2)
	.s PHRRowID=""
	.f  s PHRRowID=$o(^DHCINPHREQi("DispLocDrawId",DispLocId,DrawId,PHRRowID)) q:PHRRowID=""  d
	..s Err=..UpdateDHCInPhReqStatus(PHRRowID,"50")
	..q:Err<0  
	i Err<0  tro  q Err
	tcommit
	q Err
}

/// Descript: 	仅核对完成时用 (装箱核对)
/// Creator：	yaoxin
/// CreateDate：2017-03-24
/// Table：		DHC_PHDraw
/// Input：		DrawId(备药主表ID),Status(备药单状态)
/// Return：	>0，成功;<0，错误	
/// d ##Class(web.DHCINPHA.MobilePHA).UpdatePHDrawStatus("7")
ClassMethod UpdateDrawPackData(DrawId As %String, Status As %String, UserId As %String) As %Library.String
{
	//s ^tmpyx("UpdatePHDrawStatus")=DrawId_"^"_Status_"^"_UserId
	n (DrawId,Status,UserId)
	s Err=0
	q:DrawId="" -201
	q:Status="" -202
	q:UserId="" -203
	s PHDWDatePack=$p($h,",",1)
	s PHDWTimePack=$p($h,",",2)
	s SqlStr=DrawId_"^"_Status_"^"_UserId
	&SQL(Update DHC_PHDraw set PHDW_Status=:Status,PHDW_UserPack_Dr=:UserId,PHDW_DatePack=:PHDWDatePack,PHDW_TimePack=:PHDWTimePack where PHDW_RowID=:DrawId)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_PHDraw",SqlStr,SQLCODE_":"_$g(%msg))
    .s Err=-200
	.q:SQLCODE'=0
	q:SQLCODE'=0 Err
	q Err
}

/// Drescript:	封箱插入装箱表(装箱核对)
/// Creator:	yaoxin
/// CreateDate:	2017-03-24
/// Table:		DHC_PHDraw DHC_PHBox     
/// Input:		BoxNum(操作人)，DispLocId(药房ID)，WardLocId(病区ID)，UserId(操作人)，DrawStr(备药主表ID串)
/// Return:	    0成功
/// w ##Class(web.DHCINPHA.MobilePHA).CheckedIntoBox("2","94","114","11","7#8")
ClassMethod CheckedIntoBox(BoxNum As %String, DispLocId As %String, WardLocId As %String, UserId As %String, DrawStr As %String) As %Library.String
{
	
	n (BoxNum,DispLocId,WardLocId,UserId,DrawStr)	
	//s ^hlh($h)=$lb(BoxNum,DispLocId,WardLocId,UserId,DrawStr)	
	q:BoxNum="" -1	
	q:DispLocId="" -2	
	q:WardLocId="" -3	
	q:UserId="" -4	
	q:DrawStr="" -5
	s BoxNo=""
	s Err=0
	s $ZT="Error^DHCSTERROR"
	tstart
	s SqlStr=DispLocId_"^"_WardLocId_"^"_BoxNum_"^"_UserId
	s Err=..UpdateMainDrawReqCompStatus(UserId,DrawStr)
	s BoxIdStr=##class(web.DHCINPHA.MTBinBox.SqlDbBinBox).InsertBox(SqlStr)
	s BoxId=$p(BoxIdStr,"#",1)
	s BoxNo=$p(BoxIdStr,"#",2)	
	i BoxId<0  tro  q BoxId
	s DrawNum=$l(DrawStr,"#")
	f index=1:1:DrawNum d
	.s DrawId=$p(DrawStr,"#",index)
	.s Err=..UpdateDrawBoxData(DrawId,BoxId)
	.q:Err<0  	
	i Err<0  tro  q Err
	d ##class(web.DHCST.Common.AppCommon).UnLock("PHBoxNo") 
	tcommit	
	s Count=..WardSumBox(WardLocId,DispLocId)
	//以下为调用配送接口
	s HospId=$p($g(^CTLOC(DispLocId)),"^",22)
	s Params="^"_DispLocId_"^"_UserId_"^"_HospId
	s ParamPropStr=##class(web.DHCINPHA.MTCommon.PublicServiceMethod).GetParamProp(Params)
	s InvokPatchFlag=$p(ParamPropStr,"^",6)
	s PatchProCodeStr=$p(ParamPropStr,"^",7)
	i (InvokPatchFlag="Y")&&(PatchProCodeStr'="")  d
	.s ProCodeLen=$L(PatchProCodeStr,"&")
	.f j=1:1:ProCodeLen  d
	..s PatchProCode=$p(PatchProCodeStr,"&",j)
	..s ProjectID=$o(^DHCDISLI(0,"Code",$$ALPHAUP^SSUTIL4(PatchProCode),""),-1)
	..q:ProjectID=""
	..d ##class(web.DHCSTInterfacePH).SendToDispatch(BoxId,ProjectID)	
	q Err_"#"_BoxNo_"#"_Count
}

/// Drescript:	病区总装笔数(装箱核对)
/// Creator:	yaoxin
/// CreateDate:	2017-04-5
/// Table:		DHC_PHBox     
/// Input:		BoxNum(操作人)，DispLocId(药房ID)
/// Return:	    总笔数
/// w ##Class(web.DHCINPHA.MobilePHA).WardSumBox("114","94")
ClassMethod WardSumBox(WardLocId As %String, DispLocId As %String) As %Library.String
{
	n (WardLocId,DispLocId)
	q:WardLocId="" -11
	q:DispLocId="" -12	
	s PHBRowIDs="",Count=0
	f  s PHBRowIDs=$o(^DHCPHBOXi("Ward",WardLocId,PHBRowIDs)) q:PHBRowIDs=""  d
	.s PHBFLocDr=$p(^DHCPHBOX(PHBRowIDs),"^",15)
	.q:PHBFLocDr'=DispLocId
	.s PHBDateCreate=$p(^DHCPHBOX(PHBRowIDs),"^",18)
	.q:PHBDateCreate'=$p($h,",",1)
	.s Count=Count+1	
	q Count
}

/// Descript: 	封箱时给备药主表更新装箱ID(装箱核对)
/// Creator：	yaoxin
/// CreateDate：2017-03-24
/// Table：		DHC_PHDraw
/// Input：		DrawId(备药主表ID),BoxId(装箱ID)
/// Return：	>0，成功;<0，错误	
/// d ##Class(web.DHCINPHA.MobilePHA).UpdatePHDrawStatus("7")
ClassMethod UpdateDrawBoxData(DrawId As %String, BoxId As %String) As %Library.String
{
	//s ^tmpyx("UpdateDrawBoxData")=DrawId_"^"_BoxId
	n (DrawId,BoxId)
	s Err=0
	q:DrawId="" -201
	q:BoxId="" -202
	&SQL(Update DHC_PHDraw set PHDW_PHBox_Dr=:BoxId where PHDW_RowID=:DrawId)
	i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_PHDraw",BoxId,SQLCODE_":"_$g(%msg))
    .s Err=-200
	.q:SQLCODE'=0
	q:SQLCODE'=0 Err
	q Err
}

/// Descript: 	扫箱返回科室总批数(装箱界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-27
/// Table：		DHC_PHBOX
/// Input：		BoxNoNum(扫码),DispLocId(药房ID)
/// Return：	返回字符串
/// w ##Class(web.DHCINPHA.MobilePHA).GetWardBoxNum("ZX201703270032","94")
/// d ##class(User.DHCPHBox).%BuildIndices()
ClassMethod GetWardBoxNum(BoxNoNum As %String, DispLocId As %String) As %Library.String
{
	//s ^tmpyx("GetWardBoxNum")=BoxNoNum_"^"_DispLocId
	n (BoxNoNum,DispLocId)	
	q:BoxNoNum="" -1
	q:DispLocId="" -2
	s Str=""
	s BoxNum=$e(BoxNoNum,*)
	s BoxNo=$e(BoxNoNum,*-13,*-1)	
	s PHBRowID="" 
	s PHBRowID=$o(^DHCPHBOXi("No",BoxNo,""))
	q:PHBRowID="" -3
	s PHBStatus=$p(^DHCPHBOX(PHBRowID),"^",13)
	q:PHBStatus'=10 -4
	s PHBTLocDr=$p(^DHCPHBOX(PHBRowID),"^",16)
	s WardCode=$p(^CTLOC(PHBTLocDr),"^",51)
	s:WardCode="" WardCode=$p(^CTLOC(PHBTLocDr),"^",2)
	s PHBNum=$p(^DHCPHBOX(PHBRowID),"^",2)
	q:BoxNoNum>PHBNum -5
	s PHBRowIDs="",Count=0
	f  s PHBRowIDs=$o(^DHCPHBOXi("Ward",PHBTLocDr,PHBRowIDs)) q:PHBRowIDs=""  d
	.s PHBFLocDr=$p(^DHCPHBOX(PHBRowIDs),"^",15)
	.q:PHBFLocDr'=DispLocId
	.s PHBDateCreate=$p(^DHCPHBOX(PHBRowIDs),"^",18)
	.q:PHBDateCreate'=$p($h,",",1)
	.s Count=Count+1	
	s Str=WardCode_BoxNum_"/"_PHBNum_"箱-"_Count_"批" _"#"_WardCode_"#"_PHBRowID
	q Str
}

/// Descript: 	发放时操作(装箱界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-27
/// Table：		DHC_PHBOX DHC_InPhReq DHC_InPhReqItm
/// Input：		BoxStr(扫码),DispLocId(药房ID)，UserId(药房人员ID)，LogisticsLd(物流人员ID)
/// Return：	0成功 <0失败
/// w ##Class(web.DHCINPHA.MobilePHA).HandOutMethod("78","94","2754","1847")
ClassMethod HandOutMethod(BoxStr As %String, DispLocId As %String, UserId As %String, LogisticsLd As %String) As %Library.String
{
	//s ^tmpyx("HandOutMethod")=BoxStr_"^"_DispLocId_"^"_UserId_"^"_LogisticsLd
	n (BoxStr,DispLocId,UserId,LogisticsLd)
	q:BoxStr="" -1
	q:DispLocId="" -2
	q:UserId="" -3
	q:LogisticsLd="" -4
	s $ZT="Error^DHCSTERROR"
	tstart
	s Err=0
	s BoxNum=$l(BoxStr,"#")
	f index=1:1:BoxNum d
	.s BoxId=$p(BoxStr,"#",index)
	.s SqlStr=BoxId_"^"_UserId_"^"_LogisticsLd
	.s Err=##Class(web.DHCINPHA.MTBinBox.SqlDbBinBox).UpdateBoxData(SqlStr)
	.q:Err<0  
	.s PHDWRowID=""
	.f  s PHDWRowID=$o(^DHCPHDRAWi("Box",BoxId,PHDWRowID))  q:PHDWRowID=""  d
	..s PhaRowId=$p(^DHCPHDRAW(PHDWRowID),"^",17)
	..s Err=##class(web.DHCINPHA.MTTakeDrugDisp.InPhDrawDispQuery).UpdatePhac(PhaRowId,UserId,LogisticsLd,PHDWRowID)
	..q:Err<0 
	..s PHDWType=$p(^DHCPHDRAW(PHDWRowID),"^",4)
	..q:PHDWType'=1
	..s PHRRowID=""
	..f  s PHRRowID=$o(^DHCINPHREQi("DispLocDrawId",DispLocId,PHDWRowID,PHRRowID))  q:PHRRowID=""  d
	...s PHRReqType=$p(^DHCINPHREQ(PHRRowID),"^",7)
	...q:PHRReqType'=1
	...s Err=..UpdateDHCInPhReqStatus(PHRRowID,"60")
	...q:Err<0  
	...s PHRIChildSub=0
	...f  s PHRIChildSub=$o(^DHCINPHREQ(PHRRowID,"I",PHRIChildSub))  q:PHRIChildSub=""  d
	....s PHRIRowID=PHRRowID_"||"_PHRIChildSub
	....s Err=..UpdateInPhReqItmStatus(PHRIRowID,"60")
	....q:Err<0
	i Err<0  tro  q Err
	tcommit
	q Err
}

/// Descript: 	根据药品别名找药品信息(维护界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-30
/// Table：		INC_ALIAS
/// Input：		OrterName(药品别名)
/// Return：	药品信息
/// w ##Class(web.DHCINPHA.MobilePHA).FindDrugInfoByOrterName("1","LYX")
/// w ##Class(web.DHCINPHA.MobilePHA).FindDrugInfoByOrterName(" ","24362")
/// d ##class(User.INCALIAS).%BuildIndices()
ClassMethod FindDrugInfoByOrterName(inci As %String, OrterName As %String) As %Library.String
{
	n (inci,OrterName)
	//s ^yaoxin("FindDrugInfoByOrterName")=inci_"#"_OrterName	
	s IsTrue=0
	s INCAROWID=""
	s InciId=""
	s Spec=""
	s inciDesc=""
	s inciCode=""
	i inci'=" " d
	.f  s INCAROWID=$o(^INCALIAS(0,"INCI",inci,INCAROWID))  q:INCAROWID=""  d
	..s INCATEXT=$p(^INCALIAS(INCAROWID),"^",4)
	..i INCATEXT=+OrterName d
	...s IsTrue=1
	...s inciDesc=$p(^INCI(inci,1),"^",2)
	...s inciCode=$p(^INCI(inci,1),"^",1)
	...S Spec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	...s InciId=inci
	e  d
	.s InciId=$o(^INCI(0,"Code",+OrterName,InciId)) 
	.i InciId'="" d
	..s IsTrue=1
	..s inciDesc=$p(^INCI(InciId,1),"^",2)
	..s inciCode=$p(^INCI(InciId,1),"^",1)
	..S Spec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciId)
	q:IsTrue=0 0
	q IsTrue_"#"_InciId_"#"_Spec_"#"_inciDesc_"#"_inciCode
}

/// Descript: 	检索盘点主表明细记录
/// Creator：	yaoxin
/// CreateDate：2017-04-07
/// Input：		Loc - 科室RowId
/// Return：	>0，成功;<0，错误	
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","DHCSTINStkTk","102")
Query DHCSTINStkTk(Loc As %String) As websys.Query(ROWSPEC = "inst:%String,instNo:%String,date:%String,time:%String,user:%String,userName:%String,status:%String,loc:%String,locDesc:%String,comp:%String,stktkComp:%String,adjComp:%String,adj:%String,manFlag:%String,freezeUom:%String,includeNotUse:%String,onlyNotUse:%String,scg:%String,scgDesc:%String,sc:%String,scDesc:%String,frSb:%String,toSb:%String,InputType:%String,inputTypeDesc:%String") [ SqlProc ]
{
}

ClassMethod DHCSTINStkTkExecute(ByRef qHandle As %Binary, Loc As %String) As %Status
{
 	s repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)
 	q:Loc="" $$$OK
    s sql=" select %id rowid,"
    s sql=sql_"inst_no instNo,"
    s sql=sql_"inst_date d,"
    s sql=sql_"inst_time t,"
    s sql=sql_"inst_ssusr_dr instUser,"
    s sql=sql_"inst_ssusr_dr->ssusr_name userName,"
    s sql=sql_"inst_ctloc_dr loc,"
    s sql=sql_"inst_ctloc_dr->ctloc_desc locDesc,"
    s sql=sql_"inst_status status,"
    s sql=sql_"inst_completed comp,"
    s sql=sql_"inst_stocktakecomplete stktkComp,"
    s sql=sql_"inst_adjustmentComplete adjComp,"
    s sql=sql_"inst_inad_dr adj,"
    s sql=sql_"inst_manaflag manFlag,"
    s sql=sql_"inst_freezeuom freezeUom,"
    s sql=sql_"inst_includenotuse includeNotUse,"
    s sql=sql_"inst_onlynotuse onlyNotUse,"
    s sql=sql_"inst_scg_dr scg,"
    s sql=sql_"inst_scg_dr->scg_desc scgDesc,"
    s sql=sql_"inst_incsc_dr incsc,"
    s sql=sql_"inst_incsc_dr->incsc_desc incscDesc,"
    s sql=sql_"inst_frstkbin frSb,"
    s sql=sql_"inst_tostkbin toSb,"
    s sql=sql_"INST_InputType inputType"
    s sql=sql_" from dhc_instktk where inst_ctloc_dr="_Loc
	s xrs=##class(%Library.ResultSet).%New()
	d xrs.Prepare(sql)
	s sc=xrs.Execute()
	i $$$ISERR(sc) q $$$OK
	while (xrs.Next())
	{
	s inst=xrs.Data("rowid")
	s instNo=xrs.Data("instNo")
	s date=xrs.Data("d")
	;i date'="" s date=$zd(date,3)
	s time=xrs.Data("t")
	;i date'="" s date=$zd(date,3)
	;i time'="" s time=$zt(time)

	s user=xrs.Data("instUser")
	s userName=xrs.Data("userName")
	s status=xrs.Data("status")
	s loc=xrs.Data("loc")
	s locDesc=xrs.Data("locDesc")
	;
	s comp=xrs.Data("comp")
	s:comp="" comp="N"
	continue:(comp'="Y")
	s:comp="Y" comp="完成"
	s stktkComp=xrs.Data("stktkComp")
	s:stktkComp="" stktkComp="N"
	continue:(stktkComp'="N")
	s adjComp=xrs.Data("adjComp")
	s:adjComp="" adjComp="N"
	continue:(adjComp'="N")
	;
	s adj=xrs.Data("adj")
	s manFlag=xrs.Data("manFlag")
	s freezeUom=xrs.Data("freezeUom")
	s includeNotUse=xrs.Data("includeNotUse")
	s onlyNotUse=xrs.Data("onlyNotUse")
	s scg=xrs.Data("scg")
	s scgDesc=xrs.Data("scgDesc")
	s sc=xrs.Data("incsc")
	s scDesc=xrs.Data("incscDesc")
	s frSb=xrs.Data("frSb")
	i frSb'="" s frSb=$p(^INC("SB",frSb),"^",2)
	s toSb=xrs.Data("toSb")
	i toSb'="" s toSb=$p(^INC("SB",toSb),"^",2)	
	s stp=$o(^DHCINST(inst,"STP",0))
	s inputTypeDesc=""
	s inputType=xrs.Data("inputType")
	i inputType=6  d
	.s inputType=1
	.s inputTypeDesc="按批次"
	e  i inputType=5 d
	.s inputType=2
	.s inputTypeDesc="按品种"
	d OutPurRow1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutPurRow1
	s Data=$lb(inst,instNo,date,time,user,userName,status,loc,locDesc,comp,stktkComp,adjComp,adj,manFlag,freezeUom,includeNotUse,onlyNotUse,scg,scgDesc,sc,scDesc,frSb,toSb,inputType,inputTypeDesc)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript: 	根据药品别名找药品盘点信息按批次(盘点界面)
/// Creator：	yaoxin
/// CreateDate：2017-04-06
/// Input：		OrterName(药品别名)DispLocId(盘点科室)UserId(操作人)
/// Return：	InciId(药品ID)Spec(规格)Generic(药品通用名)FreezeQty(冻结数量)PuomDesc(入库单位)
/// 			BuomDesc(基本单位)bQty(基本单位数量)pQty(入库数量)StkBinDesc(货位)insti(DHC_InStkTkItm表ID)instw(DHC_InStkTkItmWd表ID)
/// w ##Class(web.DHCINPHA.MobilePHA).InStkTkInfoByOrterNameBat("5","2731","102","08:D4:0C:D4:BE:49","2731||1||1")
ClassMethod InStkTkInfoByOrterNameBat(InStkTkId As %String, InciId As %String, DispLocId As %String, WindowDesc As %String, INCLBID As %String) As %Library.String
{
	S ^tmpyx("InStkTkInfoByOrterNameBat")=InStkTkId_"^"_InciId_"^"_DispLocId_"^"_WindowDesc_"^"_INCLBID
	n (InStkTkId,InciId,DispLocId,WindowDesc,INCLBID)
	q:InStkTkId="" -1
	q:InciId="" -2
	q:DispLocId="" -3
	q:INCLBID="" -4
	s WindowId=""
	i WindowDesc'=""  d
	.s WindowId=$o(^DHCSTTKW(0,"LOCDESC",DispLocId,WindowDesc,""))	
	s Generic=##class(web.DHCST.Common.DrugInfoCommon).GetGene(InciId)
	s Generic=$p(Generic,"^",2)
	i Generic="" s Generic=$p(^INCI(InciId,1),"^",2)
	S Spec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciId)
	s INSTIFreezeQty=""
	S PuomStr=..GetIncPuom(InciId)		//入库单位串
 	S PuomDr=$P(PuomStr,"^",1)			//入库单位ID
 	S PuomDesc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).ReplaceBracket($P(PuomStr,"^",2))		//入库单位描述
 	S BuomStr=..GetIncBuom(InciId)		//基本单位串
 	S BuomDr=$P(BuomStr,"^",1)			//基本单位ID
 	S BuomDesc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).ReplaceBracket($P(BuomStr,"^",2))		//基本单位描述
 	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(PuomDr,BuomDr)
 	s bQty="" //基本单位
 	s pQty="" //入库单位
 	s insti=""
 	s instw=""
 	s sumbQty=0,sumpQty=0
 	s INSTIChildSub=""
	f  s INSTIChildSub=$o(^DHCINST(InStkTkId,"STI",0,INCLBID,INSTIChildSub))  q:INSTIChildSub=""  d
	.s insti=InStkTkId_"||"_INSTIChildSub
	.s INSTIFreezeQty=$p(^DHCINST(InStkTkId,"STI",INSTIChildSub),"^",2)
	.s INSTWChildSub=""
	.f  s INSTWChildSub=$o(^DHCINST(InStkTkId,"STI",INSTIChildSub,"STW",INSTWChildSub))  q:INSTWChildSub=""  d
	..s bQty=$p(^DHCINST(InStkTkId,"STI",INSTIChildSub,"STW",INSTWChildSub),"^",9)
	..i bQty=""  d
	...s bQty=0
  	..s pQty=$p(^DHCINST(InStkTkId,"STI",INSTIChildSub,"STW",INSTWChildSub),"^",8)
  	..i pQty=""  d
	...s pQty=0
	..s changeQtyBuom=$p(^DHCINST(InStkTkId,"STI",INSTIChildSub,"STW",INSTWChildSub),"^",12)
	..i changeQtyBuom="" s changeQtyBuom=0
	..s changepackqty=changeQtyBuom\fac //入库单位数量
	..s changerestqty=changeQtyBuom-(changepackqty*fac) //基本单位数量
	..s sumbQty=sumbQty+bQty+changerestqty
	..s sumpQty=sumpQty+pQty+changepackqty
	..s instw=InStkTkId_"||"_INSTIChildSub_"||"_INSTWChildSub
	s FreezeQty=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(InciId,INSTIFreezeQty)
	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(PuomDr,BuomDr)
	s packqty=INSTIFreezeQty\fac //入库单位数量
	s restqty=INSTIFreezeQty-(packqty*fac) //基本单位数量
	s BinStr=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocIncBin(DispLocId,InciId)
	s Bin=$p(BinStr,",",1) //货位ID
	i Bin=""  d
	.s StkBinDesc=""
	e  d
	.s StkBinDesc=$p($g(^INC("SB",Bin)),"^",2)
	q InciId_"#"_Spec_"#"_Generic_"#"_FreezeQty_"#"_PuomDesc_"#"_BuomDesc_"#"_sumbQty_"#"_sumpQty_"#"_StkBinDesc_"#"_Bin_"#"_BuomDr_"#"_packqty_"#"_restqty_"#"_insti_"#"_instw
}

/// Descript: 	根据药品别名找药品盘点信息按品种(盘点界面)
/// Creator：	yaoxin
/// CreateDate：2017-04-06
/// Input：		OrterName(药品别名)DispLocId(盘点科室)UserId(操作人)
/// Return：	InciId(药品ID)Spec(规格)Generic(药品通用名)FreezeQty(冻结数量)PuomDesc(入库单位)
/// 			BuomDesc(基本单位)bQty(基本单位数量)pQty(入库数量)StkBinDesc(货位)insti(DHC_InStkTkItm表ID)instw(DHC_InStkTkItmWd表ID)
/// w ##Class(web.DHCINPHA.MobilePHA).InStkTkInfoByOrterNameType("7","2517",102,"08:D4:0C:D4:BE:49")
ClassMethod InStkTkInfoByOrterNameType(InStkTkId As %String, InciId As %String, DispLocId As %String, WindowDesc As %String) As %Library.String
{
	n (InStkTkId,InciId,DispLocId,WindowDesc)
	q:InStkTkId="" -1
	q:InciId="" -2
	q:DispLocId="" -3
	s Generic=##class(web.DHCST.Common.DrugInfoCommon).GetGene(InciId)
	s Generic=$p(Generic,"^",2)
    i Generic="" s Generic=$p(^INCI(InciId,1),"^",2)  
	S Spec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciId)
	s WindowId=""
	i WindowDesc'=""  d
	.s WindowId=$o(^DHCSTTKW(0,"LOCDESC",DispLocId,WindowDesc,""))
	s INSTIFreezeQty=""
	S PuomStr=..GetIncPuom(InciId)		//入库单位串
 	S PuomDr=$P(PuomStr,"^",1)			//入库单位ID
 	S PuomDesc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).ReplaceBracket($P(PuomStr,"^",2))		//入库单位描述
 	S BuomStr=..GetIncBuom(InciId)		//基本单位串
 	S BuomDr=$P(BuomStr,"^",1)			//基本单位ID
 	S BuomDesc=##class(web.DHCINPHA.MTCommon.PublicCallMethod).ReplaceBracket($P(BuomStr,"^",2))		//基本单位描述
 	s bQty="" //基本单位
 	s pQty="" //入库单位
 	s insti=""
 	s instw=""
 	s INSTIFreezeQty=..SumFreQty(InStkTkId,InciId) 
 	s fac=##class(web.DHCSTCOMMONSRV).UOMFac(PuomDr,BuomDr)
	s packqty=INSTIFreezeQty\fac //入库单位数量
	s restqty=INSTIFreezeQty-(packqty*fac) //基本单位数量
	s sumbQty=0,sumpQty=0
	s INSTIChildSub=""
	f  s INSTIChildSub=$o(^DHCINST(InStkTkId,"STP",0,InciId,INSTIChildSub))  q:INSTIChildSub=""  d
	.s bQty=$p(^DHCINST(InStkTkId,"STP",INSTIChildSub),"^",9)
	.i bQty=""  d
	..s bQty=0
 	.s pQty=$p(^DHCINST(InStkTkId,"STP",INSTIChildSub),"^",8)
  	.i pQty=""  d
	..s pQty=0
	.s changeQtyBuom=$p(^DHCINST(InStkTkId,"STP",INSTIChildSub),"^",11)
	.i changeQtyBuom="" s changeQtyBuom=0
	.s changepackqty=changeQtyBuom\fac //入库单位数量
	.s changerestqty=changeQtyBuom-(changepackqty*fac) //基本单位数量
	.s sumbQty=sumbQty+bQty+changerestqty
	.s sumpQty=sumpQty+pQty+changepackqty	
	s INSTRowId=InStkTkId_"||"_INSTIChildSub
	s FreezeQty=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(InciId,INSTIFreezeQty)
	s BinStr=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetLocIncBin(DispLocId,InciId)
	s Bin=$p(BinStr,",",1) //货位ID
	i Bin=""  d
	.s StkBinDesc=""
	e  d
	.s StkBinDesc=$p($g(^INC("SB",Bin)),"^",2)	
	q InciId_"#"_Spec_"#"_Generic_"#"_FreezeQty_"#"_PuomDesc_"#"_BuomDesc_"#"_sumbQty_"#"_sumpQty_"#"_StkBinDesc_"#"_Bin_"#"_BuomDr_"#"_packqty_"#"_restqty_"#"_INSTRowId
}

/// 批量保存实盘表记录
/// Editor:	yaoxin
/// EditorDate:	2017-04-10
/// Table:DHC_InStkTkInput
/// Input:实盘表id^盘点主表id^药品id^单位id^实盘数^实盘人id，
/// 实盘表id^盘点主表id^药品id^单位id^实盘数^实盘人id，
/// Output:		
/// Return：成功：0；
/// -2   ;保存失败
/// -1   ;盘点id不能为空
/// "3^3||1582^1^4002^1847^70:5A:0F:19:AB:7C^0^94"
/// w ##class(web.DHCINPHA.MobilePHA).SaveInStkTkInput("7||^7^2517^1000^4238^08:D4:0C:D4:BE:49^1^102^1^1000")
/// d ##class(User.DHCINTRANS).%BuildIndices()
ClassMethod SaveInStkTkInput(ListData As %String) As %String
{
	//s ^tmpyx("SaveInStkTkInput")=ListData
	n (ListData)
	q:ListData="" -1
	s Rowid=$p(ListData,"^",1)
	s Inst=$p(ListData,"^",2)
	s Inci=$p(ListData,"^",3)
	s PCountQty=$p(ListData,"^",4)
	s UserId=$p(ListData,"^",5)
	s WindowDesc=$p(ListData,"^",6)
	s BCountQty=$p(ListData,"^",7)
	s DispLocId=$p(ListData,"^",8)
	s sumbQty=$p(ListData,"^",9)
	s sumpQty=$p(ListData,"^",10)
	s WindowId=""
	i WindowDesc'=""  d
	.s WindowId=$o(^DHCSTTKW(0,"LOCDESC",DispLocId,WindowDesc,""))
	s Err=0
	s inputType=$p(^DHCINST(Inst),"^",31)
	i inputType=""  d
	.s INSTRowId=Inst
	.&SQL(Update DHC_InStkTk set INST_InputType=5 where INST_RowId=:INSTRowId)
	.i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_InStkTk",INSTRowId,SQLCODE_":"_$g(%msg))
    ..s Err=-200
	..q:SQLCODE'=0
	q:Err'=0 Err	
	s CountDate=+$h
	s CountTime=$p($h,",",2)
	s buom=$p(^INCI(Inci,1),"^",10)
	s puom=$p(^INCI(Inci,3),"^",6)
	s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
	s TotalCountQty=$s((BCountQty'="")||(PCountQty'=""):+BCountQty+(+PCountQty*fac),1:"")
	s Err=0
	s Chl=+$o(^DHCINST(Inst,"STP",""),-1)+1	
	s ChangeQty=0
	s DHCSTIChildSub=$o(^DHCINST(Inst,"STP",0,Inci,""),-1)
	i DHCSTIChildSub'=""  d
	.s LastDate=$p(^DHCINST(Inst,"STP",DHCSTIChildSub),"^",4)
	.s LastTime=$p(^DHCINST(Inst,"STP",DHCSTIChildSub),"^",5)
	.s input=LastDate_"^"_LastTime_"^"_DispLocId_"^"_Inci_"^"_""
	.s ChangeQty=..CalculateStockQty(input)
	&sql(insert into DHC_InStkTkInput(DHCSTI_Parref,DHCSTI_ChildSub,DHCSTI_INCI_DR,
		 DHCSTI_Uom_Dr,DHCSTI_CountQty,DHCSTI_CountUser_Dr,DHCSTI_CountDate,DHCSTI_CountTime,DHCSTI_PHW_DR,DHCSTI_QtyPuom,DHCSTI_QtyBuom,DHCSTI_ChangePQty,DHCSTI_ChangeBQty) 
		 values (:Inst,:Chl,:Inci,:buom,:TotalCountQty,:UserId,:CountDate,:CountTime,:WindowId,:PCountQty,:BCountQty,0,:ChangeQty))
	i SQLCODE'=0  d
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_InStkTkInput",Inst,SQLCODE_":"_%msg)
	.s Err=-3
	q:Err'=0 -3    ;保存失败
	q 0							;保存成功
}

/// 动态盘点计算变量
/// Editor:	yaoxin
/// EditorDate:	2017-12-13
/// Table:DHC_INTRANS 
/// Input:上次盘点日期^上次盘点时间^药品id^批次ID
/// Output:	变动数量	
/// Return：变动数量
/// w ##class(web.DHCINPHA.MobilePHA).CalculateStockQty("2017-12-13^13:00:34^102^2253^") 按品种 ★阿托伐他汀钙片[10mg*7片][阿乐]
/// w ##class(web.DHCINPHA.MobilePHA).CalculateStockQty("2017-12-13^17:27:48^102^2319^") 按品种 碳酸钙D3片[600mg/125IU*30片][钙尔奇D]
/// w ##class(web.DHCINPHA.MobilePHA).CalculateStockQty("64630^46318^102^^2254||4||1") 按批次 ★阿莫西林胶囊[0.25g*50粒]
ClassMethod CalculateStockQty(input As %String) As %String
{
	n (input)
	q:input="" -1
	//s ^yaoxin("CalculateStockQty")=input
	s LastDate=$p(input,"^",1)
	s LastTime=$p(input,"^",2)
	s DispLocId=$p(input,"^",3)
	s Inci=$p(input,"^",4)
	s INCLB=$p(input,"^",5)
	s NowDate=+$h
	s NowTime=$p($h,",",2)	
	i LastDate["-" s LastDate=$zdh(LastDate,3)
	i LastTime[":" s LastTime=$zth(LastTime,1)
	s SumQty=0
	i Inci'="" d
	.f Date=LastDate:1:NowDate  d
	..s INTRRowId=""
	..f  s INTRRowId=$o(^DHCINTR(0,"INCI",Inci,Date,INTRRowId))  q:INTRRowId=""  d
	...s INTRTime=$p(^DHCINTR(INTRRowId),"^",3)
	...q:(Date=LastDate)&&(INTRTime<LastTime)
	...q:(Date=NowDate)&&(INTRTime>NowTime)
	...s Inclb=$p(^DHCINTR(INTRRowId),"^",7)
	...s Incil=$p(Inclb,"||",1,2)
	...s INCILCTLOCDR=$p(^INCI(+Incil,"IL",$p(Incil,"||",2)),"^",1)
	...q:(INCILCTLOCDR'=DispLocId)
	...s INTRType=$p(^DHCINTR(INTRRowId),"^",1)
	...i INTRType="P" d //住院发药
	....s INTRQty=$p(^DHCINTR(INTRRowId),"^",6)
	....s SumQty=SumQty+INTRQty
	...i INTRType="Y" d //住院退药
	....s INTRQty=$p(^DHCINTR(INTRRowId),"^",6)
	....s SumQty=SumQty+INTRQty
	i INCLB'="" d
	.f Date=LastDate:1:NowDate  d
	..s INTRRowId=""
	..f  s INTRRowId=$o(^DHCINTR(0,"INCLB",INCLB,Date,INTRRowId))  q:INTRRowId=""  d
	...s INTRTime=$p(^DHCINTR(INTRRowId),"^",3)
	...q:(Date=LastDate)&&(INTRTime<LastTime)
	...q:(Date=NowDate)&&(INTRTime>NowTime)
	...s Incil=$p(INCLB,"||",1,2)
	...s INCILCTLOCDR=$p(^INCI(+Incil,"IL",$p(Incil,"||",2)),"^",1)
	...q:(INCILCTLOCDR'=DispLocId)
	...s INTRType=$p(^DHCINTR(INTRRowId),"^",1)
	...i INTRType="P" d //住院发药
	....s INTRQty=$p(^DHCINTR(INTRRowId),"^",6)
	....s SumQty=SumQty+INTRQty
	...i INTRType="Y" d //住院退药
	....s INTRQty=$p(^DHCINTR(INTRRowId),"^",6)
	....s SumQty=SumQty+INTRQty
	q -SumQty
}

/// 查询盘点单中inci的账盘数(基本单位)
/// Input: inst 盘点单rowid, inci 库存项
ClassMethod SumFreQty(inst As %String, inci As %String) As %String
{
	n (inst,inci)
	q:inst="" 0
	q:inci="" 0
	s sumFreQty=0
	s ch=0
	f  s ch=$o(^DHCINST(inst,"STI1",0,"INCI",inci,ch)) q:ch=""  d
	.s freQty=$p(^DHCINST(inst,"STI",ch),"^",2)
	.s sumFreQty=sumFreQty+freQty
	q sumFreQty
}

/// Descript:	根据库存项ID取基本单位
/// Creator:	yaoxin
/// CreatDate:	2017-04-07
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	基本单位ID^基本单位描述
ClassMethod GetIncBuom(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S buomdr=$P(^INCI(InciDr,1),"^",10)
 Q:buomdr="" ""
 Q:'$D(^CT("UOM",buomdr)) ""
 S buomdesc=$P(^CT("UOM",buomdr),"^",2)
 Q buomdr_"^"_buomdesc
}

/// Descript:	根据库存项ID取入库单位
/// Creator:	yaoxin
/// CreatDate:	2017-04-07
/// Input:		InciDr-inci_rowid
/// Output:		Return
/// Return：	入库单位ID^入库单位描述
ClassMethod GetIncPuom(InciDr)
{
 N (InciDr)
 Q:InciDr="" ""
 Q:'$D(^INCI(InciDr)) ""
 S puomdr=$P(^INCI(InciDr,3),"^",6)
 Q:puomdr="" ""
 Q:'$D(^CT("UOM",puomdr)) ""
 S puomdesc=$P(^CT("UOM",puomdr),"^",2)
 Q puomdr_"^"_puomdesc
}

/// Descript: 	插入或更新实盘表记录
/// Editor：	yaoxin
/// EditDate：	2017-04-07
/// Input：		instw - 实盘表记录rowid	
/// 			insti -实盘表父表记录rowid(DHC_INStkTkItm)	
/// 			data - 实盘表记录数据串("^"分隔: 实盘人rowid^实盘单位^基本单位数量^入库单位数量^货位描述^实盘窗口^小单位总数量^大单位总数量^科室ID)
/// Return：	>0，成功;<0，错误	
/// w ##class(web.DHCINPHA.MobilePHA).UpdateINStkTkItm("5||353","5||353","4238^35^0^1001^1凉1-1^08:D4:0C:D4:BE:49^0^1001")
ClassMethod UpdateINStkTkItm(instw As %String, insti As %String, data As %String) As %String
{
	n (instw,insti,data)
	s user=$p(data,"^",1)   //实盘人rowid
	s uom=$p(data,"^",2)  //　实盘单位（基本单位）
	s bQty=$p(data,"^",3)  //　基本单位数量
	s pQty=$p(data,"^",4)  //　入库单位数量
	s stkbin=$p(data,"^",5)  //　货位描述
	s WindowDesc=$p(data,"^",6)  //　　实盘窗口
	s sumbQty=$p(data,"^",7)  //　　基本单位总数量
	s sumpQty=$p(data,"^",8)  //　　入库单位总数量
	s DispLocId=$p(data,"^",9)
	s inclb=$p(data,"^",10)
	s Err=0
	s inputType=$p(^DHCINST(+insti),"^",31)
	i inputType=""  d
	.s INSTRowId=+insti
	.&SQL(Update DHC_InStkTk set INST_InputType=6 where INST_RowId=:INSTRowId)
	.i SQLCODE'=0  d
    ..s rett=$$ErrorRecord^DHCSTERROR("Update:DHC_InStkTk",INSTRowId,SQLCODE_":"_$g(%msg))
    ..s Err=-200
	..q:SQLCODE'=0
	q:Err'=0 Err	
	s WindowId=""
	i WindowDesc'=""  d
	.s WindowId=$o(^DHCSTTKW(0,"LOCDESC",DispLocId,WindowDesc,""))
	s ChangeQty=0
	s INSTWChildSub=$o(^DHCINST(+insti,"STI",$p(insti,"||",2),"STW",""),-1)
	i INSTWChildSub'=""  d
	.s LastDate=$p(^DHCINST(+insti,"STI",$p(insti,"||",2),"STW",INSTWChildSub),"^",4)
	.s LastTime=$p(^DHCINST(+insti,"STI",$p(insti,"||",2),"STW",INSTWChildSub),"^",5)
	.s input=LastDate_"^"_LastTime_"^"_DispLocId_"^"_""_"^"_inclb
	.s ChangeQty=..CalculateStockQty(input)
	s qty=$p(..CacuInstwData(instw,pQty,bQty),"^",1)
	s obj=##class(User.DHCInStkTkItmWd).%New()
	d obj.INSTWINSTIParrefSetObjectId(insti)
	s inst=+insti,ch=$p(insti,"||",2)
	s chw=$o(^DHCINST(inst,"STI",ch,"STW",""),-1)+1
	s obj.INSTWChildSub=chw
	s obj.INSTWStkBinDesc=stkbin
	s obj.INSTWPHWDR=##class(User.DHCInStkTkWindow).%OpenId(WindowId,0)
	s obj.INSTWCountDate=+$h
	s obj.INSTWCountTime=$p($h,",",2)
	d obj.INSTWCountPersonDRSetObjectId(user)
	s obj.INSTWCountQty=qty
	d obj.INSTWCTUOMDRSetObjectId(uom)	
	s obj.INSTWQtyBuom=bQty
	s obj.INSTWQtyPuom=pQty
	s obj.INSTWChangeBQty=ChangeQty
	s obj.INSTWChangePQty=0	
	s sc=obj.%Save()
	i $$$ISERR(sc) q -1
	q obj.%Id()
}

/// Creator:yaoxin
/// CreatDate:2017-04-07
/// description:盘点方式一,行信息修改后,后台计算数据更新前台,后台计算精准灵活
/// input:instwid,实盘入库单位数量,实盘基本单位数量
/// output:基本单位总数^进价合计^售价合计^数量差异(基本单位)^进价差额^售价差额
ClassMethod CacuInstwData(instwd, pqty, bqty)
{
	n (instwd,bqty,pqty)
	s bqty=+bqty
	s pqty=+pqty
	s retstring="^^^^^"
	q:+instwd="0" retstring
	q:$p(instwd,"||",2)="" retstring
	q:'$d(^DHCINST(+instwd,"STI",$p(instwd,"||",2))) retstring
	s inci=+$p(^DHCINST(+instwd,"STI",$p(instwd,"||",2)),"^",1)
	q:inci=0 retstring
	s buom=$p(^INCI(inci,1),"^",10)
	s puom=$p(^INCI(inci,3),"^",6)
	s fac=##class(web.DHCST.Common.UtilCommon).UOMFac(puom,buom)
	s bcountqty=pqty*fac+bqty  //基本单位总数
	s rp=+$p(^DHCINST(+instwd,"STI",$p(instwd,"||",2)),"^",30)
	s sp=+$p(^DHCINST(+instwd,"STI",$p(instwd,"||",2)),"^",28)
	s rpamt=rp*bqty  //实盘进价金额
	s spamt=sp*bqty	 //实盘售价金额
	s freezeqty=+$p(^DHCINST(+instwd,"STI",$p(instwd,"||",2)),"^",2)
	s diffqty=bcountqty-freezeqty
	s diffrpamt=diffqty*rp
	s diffspamt=diffqty*sp
	s retstring=bcountqty_"^"_rpamt_"^"_spamt_"^"_diffqty_"^"_diffrpamt_"^"_diffspamt
	q retstring
}

/// 判断某一盘点单是否选择了实盘方式（1：分批次：2：按品种）
/// Creator:yaoxin
/// CreatDate:2017-04-07
/// Argu:
///  inst - 盘点主表记录rowid
/// Return：
///  1：分批次：2：按品种
/// 
ClassMethod CheckItmWd(inst) As %String
{
    n (inst)
    s flag=0   ;没按批次进行实盘 
	s stp=$o(^DHCINST(inst,"STP",0))
    q:stp'="" 2
    s chl=0
    f  s chl=$o(^DHCINST(inst,"STI",chl))  q:(chl="")!(flag'=0)  d
    .s sub=0
    .f  s sub=$o(^DHCINST(inst,"STI",chl,"STW",sub))  q:(sub="")!(flag'=0)  d
    ..s flag=1
    .
    q flag
}

/// Creator:yaoxin
/// CreatDate:2017-04-07
/// Description:生成批次信息
/// Input:库存项rowid，批号，效期，进价，单位,生产厂家ID
/// Table:inc_itmbat,dhc_incitmbat
/// OutPut:
/// Return:inc_itmbat的rowid
ClassMethod GetBatNo(inci, bat, exp, rp, uom, mnf, vendor = "", sp) As %Library.String
{
    n (inci,bat,exp,rp,uom,mnf,vendor,sp)
    q:inci="" ""
    q:rp="" ""
    q:uom="" ""
    s incib=""
    i exp["-" s exp=$zdh(exp,3)
    i (bat="")!(exp="")  d
    .s incib=..CheckNullIncibExist(inci,bat,exp,rp,uom,mnf,vendor,sp)
    e  d
    .s incib=..CheckIncibExist(inci,bat,exp,rp,uom,mnf,vendor,sp)
    q:incib'="" incib       ;返回已有的批次记录rowid
    //s chl=+$o(^INCI(inci,"IB",""),-1)+1
    s Err=0
    &sql(insert into inc_itmbat(INCIB_INCI_ParRef,INCIB_No,INCIB_ExpDate) values (:inci,:bat,:exp))
    i SQLCODE'=0  d
    .s rett=$$ErrorRecord^DHCSTERROR("GetBatNo:inc_itmbat","inci:"_inci,SQLCODE_":"_%msg)
    .s Err=-1
    q:Err'=0 ""
    s incib=$p($g(%ROWID),$c(1))
    q incib
}

/// Creator:yaoxin
/// CreatDate:2017-04-07
/// Description:检查inc_itmbat中是否存在空批号、空效期、进价相同的记录
/// Input:库存项rowid，批号，效期，进价，单位,厂家
/// Table:inc_itmbat,dhc_incitmbat
/// OutPut:
/// Return:inc_itmbat的rowid(存在);""(不存在)
ClassMethod CheckNullIncibExist(inci, batno, expdate, rp, uom, mnf, vendor = "", sp) As %String
{
     n (inci,batno,expdate,rp,uom,mnf,vendor,sp)
     q:inci="" ""
     s uomflag=##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckInciUom(inci,uom)
     s incib=""
     ;
     &sql(declare seekBat cursor for  select incib_rowid  From inc_itmbat 
       where incib_inci_parref=:inci and nvl(incib_no,"")=:batno)
      //  and nvl(incib_expdate,"")=:expdate )	//zhouyg 20141118 nvl对有效期不起作用,改到循环内
     &sql(open seekBat)
     s ret=""  
     f  &sql(fetch seekBat into :incib)  q:SQLCODE!(ret'="")  d
     .s ibSub=$p(incib,"||",2)
     .s ibExp=$p(^INCI(inci,"IB",ibSub),"^",2)
     .q:ibExp'=expdate
     .s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
     .q:dhcincib=""
     .s tmprp=0
     .s tmpsp=0
     .i uomflag=1 d
     ..s tmprp=+$P(^DHCINCIB(dhcincib),"^",4)
     ..s tmpsp=+$P(^DHCINCIB(dhcincib),"^",6)
     .e  d
     ..s tmprp=+$P(^DHCINCIB(dhcincib),"^",3)
     ..s tmpsp=+$P(^DHCINCIB(dhcincib),"^",5)
     .//厂家
     .s tmpmnf=$p(^DHCINCIB(dhcincib),"^",7)
     .s tmpvendor=$p(^DHCINCIB(dhcincib),"^",8)
     .i (tmprp=rp)&(tmpmnf=mnf)&(tmpvendor=vendor)&(tmpsp=sp) d
     ..s ret=incib              ;存在相同记录
     .
     &sql(close seekBat)
     q ret
}

/// Creator:yaoxin
/// CreatDate:2017-04-07
/// Description:检查inc_itmbat中是否存在批号、效期、进价相同的记录
/// Input:库存项rowid，批号，效期，进价，单位,厂家id
/// Table:inc_itmbat,dhc_incitmbat
/// OutPut:
/// Return:inc_itmbat的rowid(存在);""(不存在)
ClassMethod CheckIncibExist(inci, batno, expdate, rp, uom, mnf, vendor = "", sp) As %Library.String
{
 
    n (inci,batno,expdate,rp,uom,mnf,vendor,sp)
    q:inci="" ""
    q:batno="" ""
    q:expdate="" ""
    s uomflag=##class(web.DHCINPHA.MTCommon.PublicCallMethod).CheckInciUom(inci,uom)
    s ret=""
    s sub=0
    f  s sub=$o(^INCI("IB_NoX",expdate,batno,inci,sub))  q:(sub="")!(ret'="")  d
    .s incib=inci_"||"_sub
    .s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
    .q:dhcincib=""
    .s tmprp=0
    .s tmpsp=0
    .//进价
    .i uomflag=1  d
    ..s tmprp=+$p(^DHCINCIB(dhcincib),"^",4)     ;包装单位对应的进价
    ..s tmpsp=+$P(^DHCINCIB(dhcincib),"^",6)
    .e  i uomflag=0  d
    ..s tmprp=+$p(^DHCINCIB(dhcincib),"^",3)     ;基本单位对应的进价
    ..s tmpsp=+$P(^DHCINCIB(dhcincib),"^",5)
    .//厂家
    .s tmpvendor=$p(^DHCINCIB(dhcincib),"^",8)
    .s tmpmnf=$p(^DHCINCIB(dhcincib),"^",7)
    .i (tmprp=rp)&(tmpmnf=mnf)&(tmpvendor=vendor)&(tmpsp=sp) d
    ..s ret=incib               ;存在相同记录
    .q:ret'=""
    q ret
}

/// Descript: 	模糊查询药品
/// Creator：	yaoxin
/// CreateDate：2017-04-07
/// Input：		Input - 药品别名 Loc - 科室RowId
/// Return：	药品信息
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","FindDrug","TSGD3KL","94")
Query FindDrug(Input As %String, Locdr As %String) As websys.Query(ROWSPEC = "InciDr:%String,InciItem:%String,InciCode:%String,InciDesc:%String,Spec:%String,ManfName:%String,PuomDr:%String,PuomDesc:%String,pRp:%String,pSp:%String,PuomQty:%String,BuomDr:%String,BuomDesc:%String,bRp:%String,bSp:%String,BuomQty:%String,BillUomDesc:%String,BillRp:%String,BillSp:%String,BillUomQty:%String,PhcFormDesc:%String,GoodName:%String,GeneName:%String,NotUse:%String,PFac:%String,HVFlag:%String") [ SqlProc ]
{
}

ClassMethod FindDrugExecute(ByRef qHandle As %Binary, Input As %String, Locdr As %String) As %Status
{
	
 	s repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)
 	q:Input="" $$$OK
 	s result = ##class(%Library.ResultSet).%New()
 	s Locdr=Locdr
 	s Input="%"_$$ALPHAUP^SSUTIL4(Input)_"%"
	s sqlStr ="select distinct inca_inci_dr from inc_alias " _
            "where %ALPHAUP(inca_text) like '"_Input_"'"
 	d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    s count=0
    s HospID=$p(^CTLOC(Locdr),"^",22)
    s StkGrpType="G"
    While(result.Next())
    {   
        s TInci = result.Data("INCA_INCI_DR")
        CONTINUE:'$D(^INCI(TInci))
        ;科室
        I Locdr'="" 
        {
            CONTINUE:'$D(^INCI("IL_LOC",Locdr,TInci))
        }
     
        ;b ;2
        ;取当前库存量
        s stkQty = 0
        if Locdr '= "" d
        .s stkQty=##Class(web.DHCST.Common.DrugStkCommon).IL(TInci,Locdr,+$h)
        //CONTINUE:(QtyFlag="1")&(stkQty'>0)
        s count = count+1
        S InciDr= TInci
        S InciItem=$P(^INCI(InciDr,1),"^",3)                //编号
        S InciCode=$P(^INCI(InciDr,1),"^",1)                //代码
        S InciDesc=$P(^INCI(InciDr,1),"^",2)                //名称
        S Spec=##Class(web.DHCST.Common.DrugInfoCommon).GetSpec("",InciDr)      //规格
        S ManfStr=##Class(web.DHCST.Common.DrugInfoCommon).GetManf(InciDr)      //厂家
        S Manfdr=$P(ManfStr,"^",1)                                  //厂家ID
        S ManfCode=$P(ManfStr,"^",2)                                    //厂家代码
        S ManfName=$P(ManfStr,"^",3)                                    //厂家名称
        S PuomDr=$P(^INCI(InciDr,3),"^",6)                                  //入库单位ID
        s PuomDesc=""
        CONTINUE:'$d(^CT("UOM",PuomDr))
        S:PuomDr'="" PuomDesc=$P(^CT("UOM",PuomDr),"^",2)                                   //入库单位描述
        //S pRp=##Class(web.DHCST.Common.PriceCommon).GetInciLRp(InciDr,PuomDr,HospID,StkGrpType)            //入库单位进价
        //S pSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,PuomDr,HospID,StkGrpType)  //入库单位售价
        S pRp=##Class(web.DHCST.Common.PriceCommon).GetInciBasicRp(InciDr,+$H,PuomDr,HospID,StkGrpType,"")            //入库单位进价
        S pSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,PuomDr,HospID,StkGrpType,"")  //入库单位售价
        S BuomStr=##Class(web.DHCST.Common.DrugInfoCommon).GetIncBuom(InciDr)                   //基本单位串
        S BuomDr=$P(BuomStr,"^",1)                                  //基本单位ID
        S BuomDesc=$P(BuomStr,"^",2)                                    //基本单位描述
        //S bRp=##Class(web.DHCST.Common.PriceCommon).GetInciLRp(InciDr,BuomDr,HospID,StkGrpType)            //基本单位进价
        //S bSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,BuomDr,HospID,StkGrpType)  //基本单位售价
        S bRp=##Class(web.DHCST.Common.PriceCommon).GetInciBasicRp(InciDr,+$H,BuomDr,HospID,StkGrpType,"")            //基本单位进价
        S bSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,BuomDr,HospID,StkGrpType,"")  //基本单位售价
        S BillUomStr=##Class(web.DHCST.Common.DrugInfoCommon).GetArcBuomByInc(InciDr)           //计价单位串
        S BillUomDr=$P(BillUomStr,"^",1)                                //计价单位ID
        S BillUomDesc=$P(BillUomStr,"^",2)                          //计价单位描述
        //S BillRp=##Class(web.DHCST.Common.PriceCommon).GetInciLRp(InciDr,BillUomDr,HospID,StkGrpType)      //计价单位进价
        //S BillSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,BillUomDr,HospID,StkGrpType)    //计价单位售价
        S BillRp=##Class(web.DHCST.Common.PriceCommon).GetInciBasicRp(InciDr,+$H,BillUomDr,HospID,StkGrpType,"")      //计价单位进价
        S BillSp=##Class(web.DHCST.Common.PriceCommon).GetPriceElse(InciDr,+$H,BillUomDr,HospID,StkGrpType,"")    //计价单位售价
        S PhcFormStr=##Class(web.DHCST.Common.DrugInfoCommon).GetForm(InciDr)                   //剂型串
        S PhcFormCode=$P(PhcFormStr,"^",1)                          //剂型代码
        S PhcFormDesc=$P(PhcFormStr,"^",2)                          //剂型描述
        S GoodName=##Class(web.DHCST.Common.DrugInfoCommon).GetGoodName(InciDr)                 //商品名
        S GeneStr=##Class(web.DHCST.Common.DrugInfoCommon).GetGene(InciDr)                      //通用名
        S GeneCode=$P(GeneStr,"^",1)                                    //通用名代码
        S GeneName=$P(GeneStr,"^",2)                                    //通用名描述
        S BuomQty = 0
        if Locdr '= "" d
        .S BuomQty=##Class(web.DHCST.Common.DrugStkCommon).IL(InciDr,Locdr,+$H)                 //基本单位数量
        S PFac=##Class(web.DHCST.Common.UtilCommon).UOMFac(PuomDr,BuomDr)
        S PuomQty=0
        I PFac'=0 S PuomQty=BuomQty/PFac                                //入库单位数量
        S BillFac=##Class(web.DHCST.Common.UtilCommon).UOMFac(PuomDr,BuomDr)
        S BillUomQty=0
        I BillFac'="" S BillUomQty=BuomQty/BillFac                  //计价单位数量
        S NotUse=$P(^INCI(InciDr,2),"^",9)                      //是否使用  
        i NotUse="Y"  d
        .s NotUse=1
        e  d
        .s NotUse=0
        s HVFlag=##class(web.DHCST.Common.DrugInfoCommon).GetIncHighValueFlag(InciDr)
        s tmp=InciDr_"^"_InciItem_"^"_InciCode_"^"_InciDesc_"^"_Spec_"^"_ManfName_"^"_PuomDr_"^"_PuomDesc_"^"_pRp_"^"_pSp_"^"_PuomQty_"^"_BuomDr_"^"_BuomDesc_"^"_bRp_"^"_bSp_"^"_BuomQty_"^"_BillUomDesc_"^"_BillRp_"^"_BillSp_"^"_BillUomQty_"^"_PhcFormDesc_"^"_GoodName_"^"_GeneName_"^"_NotUse_"^"_PuomDr_"^"_PFac_"^"_HVFlag

		d OutInfo
    }
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutInfo
	s Data=$lb(InciDr,InciItem,InciCode,InciDesc,Spec,ManfName,PuomDr,PuomDesc,pRp,pSp,PuomQty,BuomDr,BuomDesc,bRp,bSp,BuomQty,BillUomDesc,BillRp,BillSp,BillUomQty,PhcFormDesc,GoodName,GeneName,NotUse,PFac,HVFlag)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript: 	根据inci找批次
/// Creator：	yaoxin
/// CreateDate：2017-04-11
/// Input：		Input - 药品别名 Loc - 科室RowId
/// Return：	批号 批次ID 效期
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","FindDrugBat","1","94")
Query FindDrugBat(InciId As %String, DispLocId As %String) As websys.Query(ROWSPEC = "INCIBNo:%String,INCLBRowId:%String,INCIBExpDate:%String,INCLBPhyQty:%String") [ SqlProc ]
{
}

ClassMethod FindDrugBatExecute(ByRef qHandle As %Binary, InciId As %String, DispLocId As %String) As %Status
{
 	s repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)
 	q:InciId="" $$$OK
 	q:DispLocId="" $$$OK
	s INCILChildSub=""
	f  s INCILChildSub=$o(^INCI("IL_LOC",DispLocId,InciId,INCILChildSub)) q:INCILChildSub=""  d
	.s INCLBChildSub=0
	.f  s INCLBChildSub=$o(^INCI(InciId,"IL",INCILChildSub,"LB",INCLBChildSub))  q:INCLBChildSub=""  d
	..s INCLBINCIBDR=$p(^INCI(InciId,"IL",INCILChildSub,"LB",INCLBChildSub),"^",1)
	..s INCLBPhyQty=$p(^INCI(InciId,"IL",INCILChildSub,"LB",INCLBChildSub),"^",2)
	..s INCLBPhyQty=##Class(web.DHCSTPCHCOLLPRN).getPackQty(InciId,INCLBPhyQty)
	..s INCIBNo=$p(^INCI(InciId,"IB",INCLBChildSub),"^",1)
	..s INCIBExpDate=$p(^INCI(InciId,"IB",INCLBChildSub),"^",2)
	..s INCIBExpDate=$zd(INCIBExpDate,3)
	..s INCLBRowId=InciId_"||"_INCILChildSub_"||"_INCLBChildSub
	..d OutInfoBat
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutInfoBat
	s Data=$lb(INCIBNo,INCLBRowId,INCIBExpDate,INCLBPhyQty)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Drescript:	保存请领单信息生成备药单信息（请领单界面）
/// Creator:	yaoxin
/// CreateDate:	2017-03-10
/// Input:		ApplyStr(请领单字符串),PhaLocID(发药科室ID),WardLocDr(病区科室ID),ReqType(请领类型),UserID(备药人ID)
/// Return:	    插入DHC_PHDraw，DHC_PHDrawInc，DHC_PHDrawOrder 更新DHC_InPhReq
/// w ##Class(web.DHCINPHA.MobilePHA).SavePrepareDurg("236","102","405","2","5772")
ClassMethod SavePrepareDurg(ApplyStr As %Text, PhaLocID As %String, WardLocID As %String, DrawType As %String, UserID As %String) As %String
{
	n (ApplyStr,PhaLocID,WardLocID,DrawType,UserID)
	//s ^hlh($h)=$lb(ApplyStr,PhaLocID,WardLocID,DrawType,UserID)
	s ret=##class(web.DHCINPHA.MTPHDraw.SqlDbPHDraw).SavePrepareDurg(ApplyStr,PhaLocID,WardLocID,DrawType,UserID)
	q ret
}

/// Descript: 	拒绝发药(备药界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-16
/// Table：		Update:DHC_PHDrawOrder，Insert:DHC_STDRUGREFUSE
/// Input：		DrawIncId(备药单子表),DrawOrderID(备药单孙表),LocId(发药科室ID),RefReasonId(拒绝发药原因ID),UserId(操作人ID)
/// Return：	>0，成功;<0，错误	
/// d ##Class(web.DHCINPHA.MobilePHA).RefuseReason(" ","7||1||2","94","56","11")
/// d ##Class(web.DHCINPHA.MobilePHA).RefuseReason("7||1"," ","94","56","11")
ClassMethod RefuseReason(DrawIncId As %String, DrawOrderID As %String, LocId As %String, RefReasonId As %String, UserId As %String) As %String
{
	n (DrawIncId,DrawOrderID,LocId,RefReasonId,UserId)
	s ret=##class(web.DHCINPHA.MTPHDraw.SqlDbPHDraw).RefuseReason(DrawIncId,DrawOrderID,LocId,RefReasonId,UserId)
	q ret
}

/// Descript: 	切换备药单排序规则(备药界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-16
/// Table：		DHC_PHDraw
/// Input：		DrawId(备药主表ID),SortId(排序序号)
/// Return：	>0，成功;<0，错误	
/// d ##Class(web.DHCINPHA.MobilePHA).UpdatePHDrawSort("7","2")
ClassMethod UpdatePHDrawSort(DrawId As %String, SortId As %String) As %Library.String
{
	n (DrawId,SortId)
	s ret=##class(web.DHCINPHA.MTPHDraw.SqlDbPHDraw).UpdatePHDrawSort(DrawId,SortId)
	q ret
}

/// Descript: 	根据ID找姓名(工牌界面)
/// Creator：	yaoxin
/// CreateDate：2017-03-30
/// Table：		SS_User
/// Input：		UserId
/// Return：	UserName
/// w ##Class(web.DHCINPHA.MobilePHA).FindUserNameByUserId("1")
ClassMethod FindUserNameByUserId(UserId As %String) As %Library.String
{
	n (UserId)
	q:UserId="" -1
	s UserName=$p(##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserInfoById(UserId),"^",2)
	q UserName
}

/// Descript: 	根据Code找USERID(工牌界面)
/// Creator：	yaoxin
/// CreateDate：2017-06-05
/// Table：		SS_User
/// Input：		UserId
/// Return：	UserName
/// w ##Class(web.DHCINPHA.MobilePHA).FindUseIdyUserCode("910302611950885875418549861655")
ClassMethod FindUseIdyUserCode(LogUserCode As %String) As %Library.String
{
	n (LogUserCode)
	q:LogUserCode="" -1
	s UserId=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetUserIdByLogCode(LogUserCode)
	q UserId
}

/// Descript: 	药品盘点明细
/// Creator：	yaoxin
/// CreateDate：2017-12-14
/// Input：		Input - 药品别名 Loc - 科室RowId
/// Return：	药品信息
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","InventoryDetail","7^2254")   //按品种
/// d ##Class(%ResultSet).RunQuery("web.DHCINPHA.MobilePHA","InventoryDetail","5||3^2254")   //按品种
Query InventoryDetail(Input) As websys.Query(ROWSPEC = "DateTime:%String,windowCode:%String,LastQty:%String,ChangeBQty:%String,CountQty:%String,SumQty:%String") [ SqlProc ]
{
}

ClassMethod InventoryDetailExecute(ByRef qHandle As %Binary, Input As %String) As %Status
{
	n (qHandle,Input)
 	s repid=$I(^CacheTemp)
 	s ind=1
 	s qHandle=$lb(0,repid,0)
 	q:Input="" $$$OK
 	s inst=$p(Input,"^",1)
 	s inci=$p(Input,"^",2)	
 	s type=$p(^DHCINST(+inst),"^",31)
 	q:type="" $$$OK	
    s SumQty=0
 	i type=5 d //按品种
 	.s chi=""
 	.f  s chi=$o(^DHCINST(inst,"STP",0,inci,chi)) q:chi=""  d
 	..s CountDate=$p(^DHCINST(inst,"STP",chi),"^",4)
 	..s CountTime=$p(^DHCINST(inst,"STP",chi),"^",5)
 	..s CountDate=$zd(CountDate,3)
 	..s CountTime=$zt(CountTime,1)
 	..s DateTime=CountDate_" "_CountTime
 	..s windowID=$p(^DHCINST(inst,"STP",chi),"^",7)
 	..s windowCode=$p(^DHCSTTKW(windowID),"^",2)
 	..s CountQty=$p(^DHCINST(inst,"STP",chi),"^",2)     //手工输入
 	..s ChangeBQty=$p(^DHCINST(inst,"STP",chi),"^",11)	//中间变动
 	..s SumQty=SumQty+ChangeBQty+CountQty						//盘点库存
 	..s LastQty=SumQty-ChangeBQty-ChangeBQty			//前次盘点
 	..s CountQtyUom=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(inci,CountQty)
 	..s ChangeBQtyUom=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(inci,ChangeBQty)
 	..s SumQtyUom=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(inci,SumQty)
 	..s LastQtyUom=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(inci,LastQty)
	..d OutInfoData
	.
	i type=6 d //按批次
 	.s chi=""
 	.s itm=$p(inst,"||",2)
 	.s inst=+inst
 	.f  s chi=$o(^DHCINST(inst,"STI",itm,"STW",chi)) q:chi=""  d
 	..s CountDate=$p(^DHCINST(inst,"STI",itm,"STW",chi),"^",4)
 	..s CountTime=$p(^DHCINST(inst,"STI",itm,"STW",chi),"^",5)
 	..s CountDate=$zd(CountDate,3)
 	..s CountTime=$zt(CountTime,1)
 	..s DateTime=CountDate_" "_CountTime
 	..s windowID=$p(^DHCINST(inst,"STI",itm,"STW",chi),"^",7)
 	..s windowCode=$p(^DHCSTTKW(windowID),"^",2)
 	..s CountQty=$p(^DHCINST(inst,"STI",itm,"STW",chi),"^",2)     //手工输入
 	..s ChangeBQty=$p(^DHCINST(inst,"STI",itm,"STW",chi),"^",12)	//中间变动
 	..s SumQty=SumQty+ChangeBQty+CountQty						//盘点库存
 	..s LastQty=SumQty-ChangeBQty-ChangeBQty			//前次盘点
 	..s CountQtyUom=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(inci,CountQty)
 	..s ChangeBQtyUom=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(inci,ChangeBQty)
 	..s SumQtyUom=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(inci,SumQty)
 	..s LastQtyUom=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(inci,LastQty)
	..d OutInfoData
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutInfoData
	s Data=$lb(DateTime,windowCode,LastQtyUom,ChangeBQtyUom,CountQtyUom,SumQtyUom)   
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod getPackQty(IncID, applyNum) As %Library.String
{
	n (IncID,applyNum)
	q:IncID="" -1
	q:applyNum="" -2
	s QtyUom=##class(web.DHCINPHA.MTCommon.PublicCallMethod).getPackQty(IncID,applyNum)
	q QtyUom
}

}
