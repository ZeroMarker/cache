Import sqluser

/// creator:	 yunhaibao
/// createdate:	 201605011
/// descirpiton: 门诊药房退药
Class web.DHCOUTPHA.Return Extends %RegisteredObject [ ProcedureBlock ]
{

/// creator:yunhaibao
/// createdate:20160511
/// descirpiton:获取门诊药房退药原因
/// w ##class(web.DHCOUTPHA.Return).jsGetReturnReason()
ClassMethod jsGetReturnReason(style = "")
{
	s result=##class(%Library.ResultSet).%New("web.DHCOutPhReturn:QueryRetReas")
	s sc=result.Execute()
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s colNameStr="RowId^Desc"
	i style["select2" s colNameStr="id^text"
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		s ret=result.%GetData(2)_"^"_result.%GetData(1)
		s countrecords=countrecords+1
		I countrecords=1 d
		.w "["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160511
/// descirpiton:获取门诊药房退药申请列表
/// input:科室id,登记号
/// w ##class(web.DHCOUTPHA.Return).jsGetReqListByRegNo("243^0000000165")
ClassMethod jsGetReqListByRegNo(params)
{
	s phaLoc=$p(params,"^",1)
	s patNo=$p(params,"^",2)
	q:(phaLoc="")||(patNo="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNameStr="reqNo^invNo^prescNo^reqRowId^reqUser^reqReason^reqReasonDesc"
	s reqinfostr=##class(web.DHCOutPhReturn).GetReqNo(phaLoc,patNo)
	s reqlength=$l(reqinfostr,"&")
	s countrecords=0
	f reqi=1:1:reqlength d
	.s reqinfo=$p(reqinfostr,"&",reqi)
	.s reqNo=$p(reqinfo,"^",1)
	.s reqRowId=$p(reqinfo,"^",2)
	.q:reqRowId=""
	.s invNo=$p(reqinfo,"^",4)
	.s prescNo=$p(reqinfo,"^",5)
	.s reqUser=$p(^DHCPHREQ(reqRowId),"^",17)
	.s:reqUser'="" reqUser=$p($g(^SSU("SSUSR",reqUser)),"^",2)
	.s reqReason=$p(^DHCPHREQ(reqRowId),"^",13)
	.s reqReasonDesc=$s(reqReason'="":$p($g(^DHCINVOPREFR(reqReason)),"^",2),1:"")
	.s countrecords=countrecords+1
	.s outputdata=reqNo_"^"_invNo_"^"_prescNo_"^"_reqRowId_"^"_reqUser_"^"_reqReason_"^"_reqReasonDesc
	.i countrecords=1 d
	..w "["
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160511
/// descirpiton:获取门诊药房退药列表
/// input:退药申请id
/// w ##class(web.DHCOUTPHA.Return).jsGetReturnListByReq("7")
ClassMethod jsGetReturnListByReq(params)
{
	s reqRowId=$p(params,"^",1)
	q:(reqRowId="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNameStr1="TPhdesc^TPhUom^TPrice^TDispQty^TDispMoney"
	s colNameStr2="TRetQty^TRetMoney^TPhgg^TIncDispBatCode^TIncRetBatCode"
	s colNameStr3="TPhdItm^TPhUomid^TReqItm^TRefuse^TPhdLbRowId"
	s colNameStr4="TDodisBatch^TCantRetReason^TCyFlag^TRefuseFlag"
	s colNameStr=colNameStr1_"^"_colNameStr2_"^"_colNameStr3_"^"_colNameStr4
	s retinfostr=##class(web.DHCOutPhReturn).GetRetInf(reqRowId)
	s retlength=$l(retinfostr,$c(1))
	s countrecords=0
	f reti=1:1:retlength d
	.s retinfo=$p(retinfostr,$c(1),reti)
	.s incidesc=$p(retinfo,"^",1)
	.s retuomdesc=$p(retinfo,"^",2)
	.s price=$p(retinfo,"^",3)
	.s dispqty=$p(retinfo,"^",4)
	.i (dispqty<1)&&($p(dispqty,".",1)="") s dispqty=0_dispqty
	.s dispmoney=$p(retinfo,"^",5)
	.s reqqty=$p(retinfo,"^",6)
	.i (reqqty<1)&&($p(reqqty,".",1)="") s reqqty=0_reqqty
	.s retqty=reqqty
	.i (retqty<1)&&($p(retqty,".",1)="") s retqty=0_retqty
	.s retmoney=$p(retinfo,"^",7)
	.s spec=$p(retinfo,"^",10)
	.s dispbatno=$p(retinfo,"^",12)
	.s phditm=$p(retinfo,"^",8)
	.s retuomid=$p(retinfo,"^",9)
	.s reqitm=$p(retinfo,"^",13)
	.s refusereason=$p(retinfo,"^",14)
	.s phdlbrowid=$p(retinfo,"^",15)
	.s dspbatchid=$p(retinfo,"^",16)
	.s cantretreason=$p(retinfo,"^",17)
	.s countrecords=countrecords+1
	.s returnbatno=dispbatno
	.i dispbatno["欠药" s returnbatno=""
	.s cyflag=$p(retinfo,"^",18)
	.s refuseFlag=$p(retinfo,"^",19)
	.s outputdata=incidesc_"^"_retuomdesc_"^"_price_"^"_dispqty_"^"_dispmoney
	.s outputdata=outputdata_"^"_retqty_"^"_retmoney_"^"_spec_"^"_dispbatno_"^"_returnbatno
	.s outputdata=outputdata_"^"_phditm_"^"_retuomid_"^"_reqitm_"^"_refusereason_"^"_phdlbrowid
	.s outputdata=outputdata_"^"_dspbatchid_"^"_cantretreason_"^"_cyflag_"^"_refuseFlag
	.i countrecords=1 d
	..w "["
	..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160511
/// descirpiton:获取门诊药房退药原因
/// w ##class(web.DHCOUTPHA.Return).jsGetInvListForReturn("100^0000000111^06/03/2017 - 06/03/2017")
ClassMethod jsGetInvListForReturn(params)
{
	s phaLoc=$p(params,"^",1)
	s patNo=$p(params,"^",2)
	s phaDateRange=$p(params,"^",3)
	s phaDate=$p(phaDateRange," - ",1)
	s endDate=$p(phaDateRange," - ",2)
	i phaDate'="" s phaDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(phaDate)
	e  s phaDate=""
	i endDate'="" s endDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	q:(phaLoc="")||(patNo="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s result=##class(%Library.ResultSet).%New("web.DHCOutPhReturn:QueryPRT")
	s sc=result.Execute(phaLoc,phaDate,patNo,endDate)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr="newInvNo^patName^invDate^invId^prescNo^newInvId^invNo"
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		s ret=result.%GetData(1)_"^"_result.%GetData(2)_"^"_result.%GetData(3)_"^"_result.%GetData(4)_"^"_result.%GetData(5)
		s ret=ret_"^"_result.%GetData(6)_"^"_result.%GetData(7)
		s countrecords=countrecords+1
		I countrecords=1 d
		.w "["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// w ##class(%ResultSet).RunQuery("web.DHCOutPhReturn","QueryRetPh","100","","O15110200005","")
/// creator:yunhaibao
/// createdate:20160511
/// descirpiton:获取门诊药房需退药列表
/// w ##class(web.DHCOUTPHA.Return).jsGetNeedReturnList("^E181108000038^309")
ClassMethod jsGetNeedReturnList(params)
{
	//s ^yunhaibao($this,"jsGetNeedReturnList")=params
	s phaLoc=$p(params,"^",3)
	s invRowId=$p(params,"^",1)
	s prescNo=$p(params,"^",2)
	q:(phaLoc="")||(prescNo="") ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s result=##class(%Library.ResultSet).%New("web.DHCOutPhReturn:QueryRetPh")
	s sc=result.Execute(phaLoc,invRowId,prescNo)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1
		I countrecords=1 d
		.w "["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,ret)
	}
	q:countrecords=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// creator:yunhaibao
/// createdate:20160513
/// descirption:退药打印
/// w ##class(web.DHCOUTPHA.Return).GetPrintReturnInfo(129)
ClassMethod GetPrintReturnInfo(retrowid)
{
	s ^tmpdhy("GetPrintReturnInfo")=retrowid
	q:retrowid="" ""
	s prt=+$p(^DHCPHRET(retrowid),"^",9)
	i prt'="0" s prt=$p(^DHCINVPRT(prt),"^",14)
	s retuser=+$p(^DHCPHRET(retrowid),"^",8)
	s username=$p(^DHCPHPER(retuser),"^",2)
	i username["#" s username=$p(username,"#",2)
	s retdate=$p(^DHCPHRET(retrowid),"^",2)
	s rettime=$p(^DHCPHRET(retrowid),"^",10)
	i retdate'="" s retdate=$zd(retdate,3)
	i rettime'="" s rettime=$zt(rettime,1)
	s retphloc=$p(^DHCPHRET(retrowid),"^",7)
	s retloc=$p(^DHCPHLOC(retphloc),"^",1)
	s retloc=$p($g(^CTLOC(retloc)),"^",2)
	i retloc["-" s retloc=$p(retloc,"-",2)
	s retreason=+$p(^DHCPHRET(retrowid),"^",13)
	s reqno=""
    i (retreason'="0")&($d(^DHCINVOPREFR(retreason))) s retreason=$p(^DHCINVOPREFR(retreason),"^",2)
	s totalmoney=0,patname="",patno=""
	s maininfo=prt_"^"_username_"^"_retdate_"^"_rettime_"^"_retreason_"^"_reqno_"^"_totalmoney_"^"_patno_"^"_patname_"^"_retloc_"^"_$zdt($h,3)
	s retsub="",retsubstring=""
    f  s retsub=$o(^DHCPHRTI(retrowid,"RTI",retsub)) q:retsub=""  d
	.s retmoney=+$p(^DHCPHRTI(retrowid,"RTI",retsub),"^",1)
    .s retqty=$p(^DHCPHRTI(retrowid,"RTI",retsub),"^",3)
    .s retqty=$p(retqty,$c(1),1)
    .s retuomid=$p(^DHCPHRTI(retrowid,"RTI",retsub),"^",4)
    .s retuomid=$p(retuomid,$c(1),1)
	.s retoeori=$p(^DHCPHRTI(retrowid,"RTI",retsub),"^",2)
	.s price=$p(^DHCPHRTI(retrowid,"RTI",retsub),"^",6)
	.s ord="",itm="",itmmast="",inci=""
	.s ord=$p(retoeori,"||",1)
	.s itm=$p(retoeori,"||",2)
	.q:(+ord=0)||(+itm=0)
	.s adm=+$p(^OEORD(ord),"^",1)
	.s papmi=$p(^PAADM(adm),"^",1)
	.s patname=$p(^PAPER(papmi,"ALL"),"^",1)
	.s patno=$p(^PAPER(papmi,"PAT",1),"^",2)
	.i $p(maininfo,"^",8)="" s $p(maininfo,"^",8)=patno
	.i $p(maininfo,"^",9)="" s $p(maininfo,"^",9)=patname
	.s itmmast=$p(^OEORD(ord,"I",itm,1),"^",2)
	.s itmmastid="",itmmastver=""
	.s itmmastid=$p(itmmast,"||",1)
	.s itmmastver=$p(itmmast,"||",2)
	.q:+itmmastid=0
	.//s billuomid=$p(^ARCIM(itmmastid,itmmastver,8),"^",14)
	.s inclb=$p(^DHCPHRTI(retrowid,"RTI",retsub),"^",13)
	.s inci=+inclb
	.s billuomid=$p(^INCI(inci,1),"^",12)
	.s puomid=$p(^INCI(inci,3),"^",6)
	.s buomid=+$p(^INCI(inci,1),"^",10)
    .s confac=1,conrow=""
    .i billuomid=retuomid  s confac=1
    .e  d
    ..s conrow=$o(^CT("CTCF",0,"UOM",billuomid,buomid,conrow))
    ..s confac=+$p(^CT("CTCF",conrow),"^",3)  
    .i retuomid'="" s retuom=$p($g(^CT("UOM",retuomid)),"^",2)
    .e  s retuom=""
	.s incidesc=$p(^INCI(inci,1),"^",2)
    .s totalmoney=totalmoney+retmoney
    .s getnum=$p((retqty/confac),".",1)
    .i getnum="" s getnum=0
	.s dispuomdr=$p($g(^OEORD(ord,"I",itm,"DHC")),"^",13)
	.i (dispuomdr'="")&(dispuomdr'=billuomid)&(dispuomdr'=buomid)  d
	..s Fac=##class(web.DHCSTCOMMONSRV).UOMFac(dispuomdr,buomid)
	..s retqty=retqty/Fac
	..s retuom=$p($g(^CT("UOM",dispuomdr)),"^",2)
	..s price=price*Fac
	.e  d	 
	..i getnum=(retqty/confac) d
	...s retuom=$p($g(^CT("UOM",billuomid)),"^",2)
	...s retqty=getnum
	...s price=price*confac
	..e  d
	...s retuom=$p($g(^CT("UOM",buomid)),"^",2)
	...s qty=retqty
	...s price=price*confac
	.i (retqty<1)&&(retqty>0) s retqty="0"_+retqty
	.i (retmoney<1)&&(retmoney>0) s retmoney="0"_+retmoney
	.i (price<1)&&(price>0) s price="0"_+price
    .s tmpretsubinfo=incidesc_"^"_retqty_"^"_retuom_"^"_retmoney_"^"_price
    .i retsubstring="" s retsubstring=tmpretsubinfo
    .e  s retsubstring=retsubstring_"!!"_tmpretsubinfo
    .
	i (totalmoney<1)&&(totalmoney>0) s totalmoney="0"_+totalmoney
    s $p(maininfo,"^",7)=totalmoney
    s returninfo=maininfo_"&&"_retsubstring
    q returninfo
}

/// desciption:门诊药房退药单查询
/// w ##class(web.DHCOUTPHA.Return).jsQueryReturn(1,111,"2016-05-01^2016-05-25^100")
ClassMethod jsQueryReturn(page, rows, params)
{
	//s ^yunhaibao("jsQueryReturn")=params
    q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s CDateSt=$p(params,"^",1)
	s CDateEnd=$p(params,"^",2)
	i CDateSt["-" s CDateSt=$zdh(CDateSt,3)
	i CDateEnd["-" s CDateEnd=$zdh(CDateEnd,3)
	s ctloc=$p(params,"^",3)
	s pid=..NewPid()
    s $zt="ErrorjsQueryReturn"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhRetrieve:QueryGRETDJCX")
	s sc=result.Execute(CDateSt,CDateEnd,ctloc)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturn",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturn",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturn",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturn",pid)
	q ""
ErrorjsQueryReturn
	k ^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturn",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

// 门诊药房退药单查询明细

// w ##class(web.DHCOUTPHA.Return).jsQueryReturnDetail(1,20,"142")

ClassMethod jsQueryReturnDetail(page, rows, params)
{
    q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s ret=$p(params,"^",1)
	s pid=..NewPid()
    s $zt="ErrorjsQueryReturnDetail"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhRetrieve:QueryGRetPh")
	s sc=result.Execute(ret)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturnDetail",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturnDetail",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturnDetail",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturnDetail",pid)
	q ""
ErrorjsQueryReturnDetail
	k ^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturnDetail",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

// 退药药品汇总列表

ClassMethod jsQueryReturnTotal(page, rows, sort, order, params)
{
    q:params="" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s ctloc=$p(params,"^",1)
	s CDateSt=$p(params,"^",2)
	s CDateEnd=$p(params,"^",3)
	i CDateSt["-" s CDateSt=$zdh(CDateSt,3)
	i CDateEnd["-" s CDateEnd=$zdh(CDateEnd,3)
	s CDepCode=$p(params,"^",4)
	s CDoctor=$p(params,"^",5)
	s pid=..NewPid()
    s $zt="ErrorjsQueryReturnTotal"
    s result=##class(%Library.ResultSet).%New("web.DHCOutPhRetrieve:QueryGRetPhHZ")
	s sc=result.Execute(ctloc , CDateSt , CDateEnd , CDepCode , CDoctor)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.i ret="" s ret=result.%GetData(i)
		.e   s ret=ret_"^"_result.%GetData(i)
		s retqty=result.%GetData(3)
		s retamt=result.%GetData(4)
		s index=999999
		i sort="TRetQty" s index=retqty
		e  i sort="TRetMoney" s index=+retamt
		i index="" s index=999999
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturnTotal",pid,index,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	i order="desc" s orderflag="-1"
	e  s orderflag="1"
	s outputi=""
	f  s outputi=$o(^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturnTotal",pid,outputi),orderflag) q:outputi=""  d
	.s outputj=""
	.f  s outputj=$o(^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturnTotal",pid,outputi,outputj),orderflag) q:outputj=""  d
	..s outputdata=^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturnTotal",pid,outputi,outputj)
	..s count=count+1
	..q:count<stpage
    ..q:count>endpage
	..I count=stpage d
	...w ##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(countrecords)
	...W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	..e  d
	...W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,outputdata)
	..i count=endpage w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign()
	k ^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturnTotal",pid)
	q ""
ErrorjsQueryReturnTotal
	k ^TMP("DHCST","web.DHCOUTPHA.Return","jsQueryReturnTotal",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

/// creator:yunhaibao
/// createdate:20160616
/// descirpiton:获取门诊药房拒绝退药原因
/// w ##class(web.DHCOUTPHA.Return).jsGetReturnRefuseReason()
ClassMethod jsGetReturnRefuseReason(style = "")
{
	i style["select2" s Title="id^text"
	e  s Title="RowId^Desc"
	s h=0
	s phrid=0
	f  s phrid=$o(^PHRREFUSE(phrid)) q:phrid=""  d
	.s phrdesc=$p(^PHRREFUSE(phrid),"^",2)
	.s h=h+1
	.s tmpstr=phrid_"^"_phrdesc
	.I h=1 d
	..w "["
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,tmpstr)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,tmpstr)
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

/// creator:	yunhaibao
/// createdate:	2018-09-27
/// deccription:可退药的处方列表
/// d ##class(%ResultSet).RunQuery("web.DHCOUTPHA.Return","GetPrescForRet","309^0000000532^03/11/2018 - 03/12/2018")
Query GetPrescForRet(inputStr = "") As websys.Query(ROWSPEC = "prescNo:%String,fyDate:%String,hasReq:%String")
{
}

ClassMethod GetPrescForRetExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.Return","GetPrescForRet")=inputStr
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s LocId=$p(inputStr,"^",1)
	s PatNo=$p(inputStr,"^",2)
	s PhaDateRange=$p(inputStr,"^",3)
	s StDate=$p(PhaDateRange," - ",1)
	s EdDate=$p(PhaDateRange," - ",2)
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EdDate)
	q:(LocId="")||(PatNo="") $$$OK
	s HospId=$p($g(^CTLOC(+LocId)),"^",22)
	s PhLocId=$o(^DHCPHLOCi("LOC",LocId,""))
	q:PhLocId="" $$$OK
	s PayModeFlag=##class(PHA.FACE.IN.Com).IStayPayModeByEpisodeID(HospId)
	// 跨科室退药设置
	s BaseLocId=""
	s OthLocRetFlag=$p($G(^DHCPHLOC(PhLocId)),"^",8)
	s BasePhLocId=##class(web.DHCOutPhAdd).GetTwoPhlFrThree(PhLocId)
	i BasePhLocId'="" s BaseLocId=+$p(^DHCPHLOC(BasePhLocId),"^",1)
	s PatId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),""))
	/*******如上为常量*********/
	s phdId=0
	f  s phdId=$o(^DHCPHDISPi("PAPMI",PatId,phdId)) q:(phdId="")!(phdId="0")   d
	.q:'$d(^DHCPHDISP(phdId))
	.s fyFlag=$p(^DHCPHDISP(phdId),"^",4)
	.q:fyFlag'="1"
	.s phLocId=+$p(^DHCPHDISP(phdId,1),"^",1)
	.s basePhLocId=##class(web.DHCOutPhAdd).GetTwoPhlFrThree(phLocId)
	.q:(OthLocRetFlag'="Y")&&(BasePhLocId'="")&&(basePhLocId'=BasePhLocId)
	.s locId=$p(^DHCPHLOC(phLocId),"^",1)
	.s hospId=+$p($g(^CTLOC(+locId)),"^",22)
	.// 过滤-院区
	.q:(+HospId'=0)&&(+HospId'=hospId) 
	.s fyDate=$p(^DHCPHDISP(phdId),"^",3)
	.q:(fyDate>EdDate)||(fyDate<StDate)
	.s existFlag=""
	.s phdItm=""
	.f  s phdItm=$o(^DHCPHDI(phdId,"PHDI",phdItm)) q:(phdItm="")!(existFlag'="")  d
	..q:'$d(^DHCPHDI(phdId,"PHDI",phdItm))
	..s phdItmData=^DHCPHDI(phdId,"PHDI",phdItm)
	..s oeori=$p(phdItmData,"^",5)
	..q:##class(web.DHCOutPhCommon).PrtOPToIP(oeori)=1	// 门诊转住院
	..s emLGflag=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),"DHC")),"^",17)
	..q:(PayModeFlag="1")&&(emLGflag="1")
	..s phdSub=""
	..f  s phdSub=$o(^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdSub))  q:(phdSub="")!(existFlag'="")  d
	...q:'$d(^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdSub))
	...s dispQty=0,retedQty=0,canRetQty=0
	...s phdSubData=^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdSub)
	...s dispQty=+$p(phdSubData,"^",1)
	...s retedQty=+$p(phdSubData,"^",2)
	...s canRetQty=dispQty-retedQty
	...q:canRetQty<=0
	...s existFlag=1
	..
	.q:existFlag=""
	.s prescNo=$p(^DHCPHDISP(phdId,2),"^",1)
	.s fyDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(fyDate)
	.s GetPrescForRetData(prescNo)=prescNo_"^"_fyDateHtml
	s outputI=""
	f  s outputI=$o(GetPrescForRetData(outputI)) q:outputI=""  d
	.s data=GetPrescForRetData(outputI)
	.s prescNo=$p(data,"^",1)
	.s ftDateHtml=$p(data,"^",2)
	.s hasReq=##class(web.DHCOutPhReturn).CheckPrescHasReq(prescNo)
	.s hasReq=$s(hasReq="":"",1:"申请退药")
	.s Data=$lb(prescNo,ftDateHtml,hasReq)
	.s ^CacheTemp(repid,ind)=Data    
	.s ind=ind+1
	q $$$OK
}

/// creator:	yunhaibao
/// createdate:	2018-09-27
/// deccription:可退药的处方列表下拉json
/// w ##class(web.DHCOUTPHA.Return).jsGetPrescForRet("309^0000000171^2018-10-17 - 2018-11-16","")
ClassMethod jsGetPrescForRet(inputStr = "", combotext = "")
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.Return","jsGetPrescForRet")=$lb(inputStr,combotext)
	s result=##class(%Library.ResultSet).%New("web.DHCOUTPHA.Return:GetPrescForRet")
	s sc=result.Execute(inputStr)
	i $$$ISERR(sc) q ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	s colNameStr="id^text"
	s count=0
	While(result.Next())
	{ 
		s retData=result.%Get("prescNo")_"^"_result.%Get("prescNo")_"  "_result.%Get("fyDate")_"  "_result.%Get("hasReq")
		s count=count+1
		I count=1 d
		.w "["
		.W ##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,retData)
		e  d
		.W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(colNameStr,retData)
	}
	q:count=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(0) 
	w "]"
	q ""
}

ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"OP")
}

}
