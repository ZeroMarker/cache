/// Description:备药单查询操作相关
/// Creator:    hulihua
/// CreateDate: 2017-03-21
/// Table:      DHC_PHDraw、DHC_PHDrawInc、DHC_PHDrawOrder
Class web.DHCINPHA.MTPHDraw.PHDrawQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:查询备药单主表信息
/// Creator:	hulihua
/// CreateDate:	2016-10-21
/// Table:      DHC_PHDraw
/// Input:		每页行数、页数、药房科室ID
/// Output:		备药单ID、备药单号、备药单日期、备药单时间、备药人
/// Return：    
/// w ##class(web.DHCINPHA.MTNurseCheck.NurseCheckQuery).GetInPhDrawList("50","1","26/03/2017^26/03/2017^94")
ClassMethod GetInPhDrawList(rows, page, params) As %String
{
	n (rows, page,params)
	//s ^hlh($h)=$lb(rows, page,params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s StartDate=$p(params,"^",1)
	s EndDate=$p(params,"^",2)
	i StartDate["-"	 s StartDate=$zdh(StartDate,3)
	i EndDate["-"	 s EndDate=$zdh(EndDate,3)
	i StartDate["/"	 s StartDate=$zdh(StartDate,4)
	i EndDate["/"	 s EndDate=$zdh(EndDate,4)
	s PhLoc=$p(params,"^",3)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTNurseCheck.NurseCheckQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawList",pid)
	s n=0
	f Date=StartDate:1:EndDate d
	.s phdwid="" 
	.f  s phdwid=$o(^DHCPHDRAWi("LocDate",PhLoc,Date,phdwid)) q:phdwid=""  d
	..s phdwno=$p(^DHCPHDRAW(phdwid),"^",1)
	..s phdwdate=$p(^DHCPHDRAW(phdwid),"^",9)
	..s:phdwdate'="" phdwdate=$zd(phdwdate,3)
	..s phdwtime=$p(^DHCPHDRAW(phdwid),"^",10) 
	..s:phdwtime'="" phdwtime=$zt(phdwtime,1)
	..s phdwcompuser=$p(^DHCPHDRAW(phdwid),"^",7)
	..s phdwcompuser=$s(phdwcompuser'="":$p(^SSU("SSUSR",phdwcompuser),"^",2),1:"")
	..s n=n+1
	..s data=$g(phdwid)_"^"_$g(phdwno)_"^"_$g(phdwdate)_"^"_$g(phdwtime)_"^"_$g(phdwcompuser)
	..s ^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawList",pid,n)=data
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawList",pid,h)) q:h=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawList",pid,h)
	.s count = count+1
	.s Title="TPhdwID^TPhdwNo^TPhdwDate^TPhdwTime^TPhdwCompUser"
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)

	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawList",pid)
	q ""
}

/// Description:查询备药单药品汇总信息
/// Creator:	hulihua
/// CreateDate:	2016-10-21
/// Table:      DHC_PHDraw、DHC_PHDrawInc
/// Input:		每页行数、页数、备药单主表ID
/// Output:		备药单ID、备药单号、备药单日期、备药单时间、备药人
/// Return：    
/// w ##class(web.DHCINPHA.MTNurseCheck.NurseCheckQuery).GetInPhDrawIncList("50","1","1")
ClassMethod GetInPhDrawIncList(rows, page, params) As %String
{
	n (rows, page,params)
	//s ^hlh($h)=$lb(rows, page,params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s phdwid=params
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTNurseCheck.NurseCheckQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawIncList",pid)
	s phdwch="",n=0 
	f  s phdwch=$o(^DHCPHDRAW(phdwid,"INC",phdwch)) q:phdwch=""  d
	.s phdwi=phdwid_"||"_phdwch
	.s inci=$p(^DHCPHDRAW(phdwid,"INC",phdwch),"^",1)
	.q:inci=""
	.s incicode = $p(^INCI(inci,1),"^",1)								//药品代码								
	.s incidesc = $p(^INCI(inci,1),"^",2)								//药品名称
	.s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)	//规格
	.s qtytotal=$p(^DHCPHDRAW(phdwid,"INC",phdwch),"^",2)				//备药数量
	.s qtyactual=$p(^DHCPHDRAW(phdwid,"INC",phdwch),"^",3)				//实发数量
	.s phdwuomdr=$p(^DHCPHDRAW(phdwid,"INC",phdwch),"^",4)				//单位ID
	.s phdwuom=$p(^CT("UOM",phdwuomdr),"^",2)
	.s n=n+1
	.s data=$g(phdwi)_"^"_$g(incidesc)_"^"_$g(spec)_"^"_$g(qtytotal)_"^"_$g(qtyactual)_"^"_$g(phdwuom)
	.s ^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawIncList",pid,n)=data
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawIncList",pid,h)) q:h=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawIncList",pid,h)
	.s count = count+1
	.s Title="TPhdwiID^TInciDesc^TSpec^TQtyTotal^TQtyActual^TPhdwUom"
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)

	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawIncList",pid)
	q ""
}

/// Description:查询备药单药品汇总信息
/// Creator:	hulihua
/// CreateDate:	2016-10-21
/// Table:      DHC_PHDraw、DHC_PHDrawInc
/// Input:		每页行数、页数、备药单主表ID
/// Output:		备药单ID、备药单号、备药单日期、备药单时间、备药人
/// Return：    
/// w ##class(web.DHCINPHA.MTNurseCheck.NurseCheckQuery).GetInPhDrawOrderList("50","1","1||1")
ClassMethod GetInPhDrawOrderList(rows, page, params) As %String
{
	n (rows, page,params)
	//s ^hlh($h)=$lb(rows, page,params)
	q:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
	i $g(page)="" s page=1
	i $g(rows)="" s rows=50
	s End = page*rows
	s Start=(page-1)*rows+1
	s phdwid=$p(params,"||",1)
	s phdwch=$p(params,"||",2)
	S pid=##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid("web.DHCINPHA.MTNurseCheck.NurseCheckQuery")
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawOrderList",pid)
	s phdwsub="",n=0 
	f  s phdwsub=$o(^DHCPHDRAW(phdwid,"INC",phdwch,"ORDER",phdwsub)) q:phdwsub=""  d
	.s DspId=$p(^DHCPHDRAW(phdwid,"INC",phdwch,"ORDER",phdwsub),"^",1)
	.q:DspId=""
	.s oeori=$p(^DHCOEDISQTY(DspId),"^",1)
	.s AdmDr=$p(^OEORD(+oeori),"^",1)
	.s PapmiId=$p(^PAADM(AdmDr),"^",1) 
	.s PatName=$p(^PAPER(PapmiId,"ALL"),"^",1)												//姓名 
	.s PatNo=$p(^PAPER(PapmiId,"PAT",1),"^",1)												//登记号
	.s OldWardStr=##class(web.DHCSTPCHCOLLS).getOrdWard(oeori)    		
	.s BedId=$p(OldWardStr,"^",2)
	.s Bed=$s(BedId'="":$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1),1:"")	//病人床号 
	.s DspQty=$p(^DHCOEDISQTY(DspId),"^",5)												//应发数量
	.s Qty=$p(^DHCPHDRAW(phdwid,"INC",phdwch,"ORDER",phdwsub),"^",2)						//备药数量
	.s dspuomid=$p(^DHCOEDISQTY(DspId),"^",6)												//单位ID
	.s DspUom=$p(^CT("UOM",dspuomid),"^",2)
	.s n=n+1
	.s data=$g(PatNo)_"^"_$g(PatName)_"^"_$g(Bed)_"^"_$g(DspUom)_"^"_$g(DspQty)_"^"_$g(Qty)
	.s ^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawOrderList",pid,n)=data
	q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串
	s maxrow=n
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawOrderList",pid,h)) q:h=""  d
	.s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawOrderList",pid,h)
	.s count = count+1
	.s Title="TPatNo^TPatName^TBed^TDspUom^TDspQty^TQty"
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)

	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	d ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp("web.DHCINPHA.MTNurseCheck.NurseCheckQuery","GetInPhDrawOrderList",pid)
	q ""
}

Storage Default
{
<Data name="PHDrawQueryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCINPHA.M87F8.PHDrawQueryD</DataLocation>
<DefaultData>PHDrawQueryDefaultData</DefaultData>
<IdLocation>^web.DHCINPHA.M87F8.PHDrawQueryD</IdLocation>
<IndexLocation>^web.DHCINPHA.M87F8.PHDrawQueryI</IndexLocation>
<StreamLocation>^web.DHCINPHA.M87F8.PHDrawQueryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
