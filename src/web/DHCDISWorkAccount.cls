Class web.DHCDISWorkAccount Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description: 配送申请量查询
/// Creator:     zhaowuqiang
/// Creatdate:   2017-02-09
/// Table:       DHC_DisGoodsRequest,DHC_DisGoodsReqItm,DHC_DisLocItem
/// Input:       开始日期^结束日期^科室^项目
/// Output:      本院人次^外院人次^本院项目数^外院项目数^人次合计^项目合计
/// Others:      D ##class(%ResultSet).RunQuery("web.DHCDISWorkAccount","QueryDisReq","2017-02-07","2017-02-09","","")
Query QueryDisReq(StDate As %String, EndDate As %String, Dept As %String, Item As %String) As %Query(ROWSPEC = "ReqLocDesc:%String,ThisPeopleNum:%Float,OtherPeopleNum:%Float,ThisHosItemNum:%Float,OtherHosItemNum:%Float,PeopleNum:%Float,ItemNum:%Float") [ SqlProc ]
{
}

ClassMethod QueryDisReqExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, Dept As %String, Item As %String) As %Status
{
	N (qHandle,StDate,EndDate,Dept,Item)
	s repid=$I(^CacheTemp) //相当于一个计数器
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s tid=$I(^Tmp) //相当于一个计数器            根据配送安排统计配送量
	s pid=$I(^Tmp1) ///设置一个计数器^tmp1    根据申请科室统计
	s count=1
	/*
	S HosDesc="北京地坛医院"
	S HosId=""
	S HosId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HosDesc),HosId))
	Q:HosId=""
	S HosCode=$p(^CT("HOSP",HosId),"^",1)
	S StDate=$zdh(StDate,3)
	S EndDate=$zdh(EndDate,3)
	
	F date=StDate:1:EndDate D
	.s id=""
	.f  s id=$o(^DHCDISGRE("0","CreateDate",date,id)) q:id=""  d
	..s ReqLocId=$p(^DHCDISGRE(id),"^",2)  //申请科室Id
	..s ReqLocDesc=$p(^CTLOC(ReqLocId),"^",2) //申请科室描述
	..q:(Dept'="Null")&&(ReqLocDesc'=Dept)
	..
	..s ThisHosItemNum=0     //本院项目数
	..s OtherHosItemNum=0    //外院项目数
	..s ThisPeopleNum=0      //本院人次
	..s OtherPeopleNum=0     //外院人次
	..s ItemNum=0            //项目合计
	..s PeopleNum=0          //人次合计
	..s itemchildsub=""
	..f  s itemchildsub=$o(^DHCDISGRE(id,"ITM",itemchildsub)) q:itemchildsub=""  d
	...s itemid=$p(^DHCDISGRE(id,"ITM",itemchildsub),"^",1)
	...s item=$p(^DHCDISLI(itemid),"^",2)  //项目名称
	...s itemNum=$p(^DHCDISGRE(id,"ITM",itemchildsub),"^",3)  //项目数量
	...q:(Item'="Null")&&(Item'=item)
	...s hosdr=$p(^DHCDISLI(itemid),"^",6)
	...s disType=$p(^DHCDISLI(itemid),"^",4)            //配送或陪送类型  配送:1,陪送:0
	...q:disType=0
	...s:hosdr=HosCode ThisHosItemNum=ThisHosItemNum+itemNum    //增加本院项目数
	...s:hosdr=HosCode ThisPeopleNum=ThisPeopleNum+1
	...s:hosdr'=HosCode OtherHosItemNum=OtherHosItemNum+itemNum //增加外院项目数
	...s:hosdr'=HosCode OtherPeopleNum=OtherPeopleNum+1
	...
	..s ItemNum=ItemNum+ThisHosItemNum+OtherHosItemNum
	..s PeopleNum=PeopleNum+ThisPeopleNum+OtherPeopleNum
	..
	..///根据配送安排统计配送量
	..s listdata=ReqLocDesc_"^"_ThisPeopleNum_"^"_OtherPeopleNum_"^"_ThisHosItemNum_"^"_OtherHosItemNum_"^"_PeopleNum_"^"_ItemNum
	..s ^Tmp("web.DHCDISWorkAccount","QueryDisReq",tid,count)=listdata
	..s count=count+1
	*/
	s LocDesc="儿科^妇科^产科^骨科一病区^消化内科^外科^手术科^内一科^内儿科^超声科^神经科^心血管科^胃肠内科^胸外科"
	s ThisPeopleNum=58,OtherPeopleNum=30,ThisHosItemNum=112,OtherHosItemNum=86
	s Len=$l(LocDesc,"^")
	f i=1:1:Len  d
	.s ReqLocDesc=$p(LocDesc,"^",i)
	.s ThisPeopleNum=ThisPeopleNum+7
	.s OtherPeopleNum=OtherPeopleNum+3
	.s ThisHosItemNum=ThisHosItemNum+39
	.s OtherHosItemNum=OtherHosItemNum+21
	.s PeopleNum=ThisPeopleNum+OtherPeopleNum
	.s ItemNum=ThisHosItemNum+OtherHosItemNum
	.s listdata=ReqLocDesc_"^"_ThisPeopleNum_"^"_OtherPeopleNum_"^"_ThisHosItemNum_"^"_OtherHosItemNum_"^"_PeopleNum_"^"_ItemNum
	.s ^Tmp("web.DHCDISWorkAccount","QueryDisReq",tid,count)=listdata
	.s count=count+1
	///根据申请科室统计配送量
	s death=""
	f  s death=$o(^Tmp("web.DHCDISWorkAccount","QueryDisReq",tid,death)) q:death=""  d
	.s ReqLocDesc=$p(^Tmp("web.DHCDISWorkAccount","QueryDisReq",tid,death),"^",1)
	.s ThisPeopleNum=$p(^Tmp("web.DHCDISWorkAccount","QueryDisReq",tid,death),"^",2)
	.s OtherPeopleNum=$p(^Tmp("web.DHCDISWorkAccount","QueryDisReq",tid,death),"^",3)
	.s ThisHosItemNum=$p(^Tmp("web.DHCDISWorkAccount","QueryDisReq",tid,death),"^",4)
	.s OtherHosItemNum=$p(^Tmp("web.DHCDISWorkAccount","QueryDisReq",tid,death),"^",5)
	.s PeopleNum=$p(^Tmp("web.DHCDISWorkAccount","QueryDisReq",tid,death),"^",6)
	.s ItemNum=$p(^Tmp("web.DHCDISWorkAccount","QueryDisReq",tid,death),"^",7)
	.i $d(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc)) d
	..s $p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",2)=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",2)+ThisPeopleNum
	..s $p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",3)=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",3)+OtherPeopleNum
	..s $p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",4)=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",4)+ThisHosItemNum
	..s $p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",5)=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",5)+OtherHosItemNum
	..s $p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",6)=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",6)+PeopleNum
	..s $p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",7)=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",7)+ItemNum
	.e  d
	..s ^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc)=ReqLocDesc_"^"_ThisPeopleNum_"^"_OtherPeopleNum_"^"_ThisHosItemNum_"^"_OtherHosItemNum_"^"_PeopleNum_"^"_ItemNum

	s ReqLocDesc=""
	f  s ReqLocDesc=$o(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc)) q:ReqLocDesc=""  d
	.s ReqLocDesc=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",1)
	.s ThisPeopleNum=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",2)
	.s OtherPeopleNum=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",3)
	.s ThisHosItemNum=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",4)
	.s OtherHosItemNum=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",5)
	.s PeopleNum=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",6)
	.s ItemNum=$p(^Tmp1("web.DHCDISWorkAccount","QueryDisReq",pid,ReqLocDesc),"^",7)
	.;s data=ReqLocDesc_"^"_ThisPeopleNum_"^"_OtherPeopleNum_"^"_ThisHosItemNum_"^"_OtherHosItemNum_"^"_PeopleNum_"^"_ItemNum
	.
	.s data = $lb(ReqLocDesc,ThisPeopleNum,OtherPeopleNum,ThisHosItemNum,OtherHosItemNum,PeopleNum,ItemNum)
	.s ^CacheTemp(repid,ind)=data	     //将这些数据存储在一个临时global中
	.s ind=ind+1
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
}

ClassMethod QueryDisReqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDisReqExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod QueryDisReqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDisReqExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		s AtEnd=1
		s Row=""
	}
	Else     
	 {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

Query SleItem() As %Query(ROWSPEC = "ItemDesc:%String:项目名称") [ SqlProc ]
{
}

ClassMethod SleItemExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp) //相当于一个计数器
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s data = $lb("Null")
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	s itemid=0
	f  s itemid=$o(^DHCDISLI(itemid)) q:itemid=""  d
	.s ItemDesc=$p(^DHCDISLI(itemid),"^",2)
	.q:ItemDesc=""
	.s data = $lb(ItemDesc)
	.s ^CacheTemp(repid,ind)=data	     //将这些数据存储在一个临时global中
	.s ind=ind+1
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
}

ClassMethod SleItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SleItemExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod SleItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SleItemExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		s AtEnd=1
		s Row=""
	}
	Else     
	 {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

/// Description: 科室查询
/// Creator:     zhaowuqiang
/// Creatdate:   2017-02-13
/// Table:       CT_LOC
/// Input:       无
/// Output:      科室描述
/// Others:      D ##class(%ResultSet).RunQuery("User.Test01","SleDept")
Query SleDept() As %Query(ROWSPEC = "ItemDesc:%String:科室名称") [ SqlProc ]
{
}

ClassMethod SleDeptExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp) //相当于一个计数器
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s data = $lb("Null")
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	s locid=0
	f  s locid=$o(^CTLOC(locid)) q:locid=""  d
	.s LocDesc=$p(^CTLOC(locid),"^",2)
	.q:LocDesc=""
	.
	.s data = $lb(LocDesc)
	.s ^CacheTemp(repid,ind)=data	     //将这些数据存储在一个临时global中
	.s ind=ind+1
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
}

ClassMethod SleDeptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SleDeptExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod SleDeptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SleDeptExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		s AtEnd=1
		s Row=""
	}
	Else     
	 {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

/// Others:D ##class(%ResultSet).RunQuery("web.DHCDISWorkAccount","PQueryDowReq","2017-02-16","2017-03-30")
Query PQueryDowReq(StDate As %String, EndDate As %String) As %Query(ROWSPEC = "PeopleName:%String:测试数据,wcPeopleNum:%String:测试数据,wcItmNum:%String:测试数据,hfPeopleNum:%String:测试数据,hfItmNum:%String:测试数据") [ SqlProc ]
{
}

// query的执行部分

ClassMethod PQueryDowReqExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String) As %Status
{
	s repid=$I(^CacheTemp) //相当于一个计数器
	s qHandle=$lb(0,repid,0)
	s ind=1
	s pid=$I(^Tmp) //相当于一个计数器    根据任务id统计
	s tid=$I(^Tub) ///设置一个计数器^tmp1    根据人员统计
	s count=1
	
	;S HosDesc="北京地坛医院"
	;S HosId=""
	;S HosId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(HosDesc),HosId))
	;Q:HosId=""
	;S HosCode=$p(^CT("HOSP",HosId),"^",1)
	S StDate=$zdh(StDate,3)  //##class(web.DHCDISCommonDS).DateLogicalToHtml(StDate)   //$zdh(StDate,3)
	S EndDate=$zdh(EndDate,3) //##class(web.DHCDISCommonDS).DateLogicalToHtml(EndDate)  //$zdh(EndDate,3)

	F date=StDate:1:EndDate D
	.s id=""
	.f  s id=$o(^DHCDISRE(0,"CreateDate",date,id)) q:id=""  d
	..;s Statue=$p(^DHCDISRE(id),"^",16)
	..;q:Statue=""
	..s DisToolDr=$p(^DHCDISRE(id),"^",10)
	..s DisTool=$p(^DHCDISTO(DisToolDr),"^",2)
	..s ItmNum=0
	..s childsub=""
	..f  s childsub=$o(^DHCDISRE(id,"Itm",childsub)) q:childsub=""  d
	...s ItmNum=ItmNum+1
	..s PeopleNum=0
	..s PeopleName=""
	..s peopleid=""
	..f peopleid=$o(^DHCDISPE(0,"TypePointer",0,id,peopleid)) q:(peopleid="")||(PeopleNum=1)  d
	...s PeopleDr=$p(^DHCDISPE(peopleid),"^",3)
	...s PeopleNum=PeopleNum+1
	...i PeopleDr'="" s PeopleName=$p(^SSU("SSUSR",PeopleDr),"^",2)
	..q:PeopleName=""
	..s listdata=PeopleName_"^"_PeopleNum_"^"_DisTool_"^"_ItmNum
	..;w listdata,!
	..s ^Tmp("web.DHCDISWorkAccount","PQueryDowReq",pid,count)=listdata
	..s count=count+1
	
	s PeopleName="",wcPeopleNum=0,wcItmNum=0,hfPeopleNum=0,hfItmNum=0
	s Tmpid=""
	f  s Tmpid=$o(^Tmp("web.DHCDISWorkAccount","PQueryDowReq",pid,Tmpid)) q:Tmpid=""  d
	.s PeopleName=$p(^Tmp("web.DHCDISWorkAccount","PQueryDowReq",pid,Tmpid),"^",1)
	.s PeopleNum=$p(^Tmp("web.DHCDISWorkAccount","PQueryDowReq",pid,Tmpid),"^",2)
	.s DisTool=$p(^Tmp("web.DHCDISWorkAccount","PQueryDowReq",pid,Tmpid),"^",3)
	.s ItmNum=$p(^Tmp("web.DHCDISWorkAccount","PQueryDowReq",pid,Tmpid),"^",4)
	.i $d(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName))  d
	..i DisTool="轮椅"  d
	...s $p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",2)=$p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",2)+PeopleNum
	...s $p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",3)=$p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",3)+ItmNum
	..e  d
	...s $p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",4)=$p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",4)+PeopleNum
	...s $p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",5)=$p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",5)+ItmNum
	.e  d
	..s ^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName)=PeopleName_"^"_wcPeopleNum_"^"_wcItmNum_"^"_hfPeopleNum_"^"_hfItmNum
	
	s PeopleName=""
	f  s PeopleName=$o(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName)) q:PeopleName=""  d
	.s PeopleName=$p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",1)
	.s wcPeopleNum=$p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",2)
	.s wcItmNum=$p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",3)
	.s hfPeopleNum=$p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",4)
	.s hfItmNum=$p(^Tub("web.DHCDISWorkAccount","PQueryDowReq",tid,PeopleName),"^",5)
	.s ListData=PeopleName_"^"_wcPeopleNum_"^"_wcItmNum_"^"_hfPeopleNum_"^"_hfItmNum
	.;w ListData,!
	.s data = $lb(PeopleName,wcPeopleNum,wcItmNum,hfPeopleNum,hfItmNum)
	.s ^CacheTemp(repid,ind)=data	     //将这些数据存储在一个临时global中
	.s ind=ind+1
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
}

ClassMethod PQueryDowReqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PQueryDowReqExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod PQueryDowReqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PQueryDowReqExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		s AtEnd=1
		s Row=""
	}
	Else     
	 {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

/// Others:D ##class(%ResultSet).RunQuery("web.DHCDISWorkAccount","LQueryDowReq","2017-02-16","2017-03-30","")
Query LQueryDowReq(StDate As %String, EndDate As %String, LocDr As %String) As %Query(ROWSPEC = "locdec:%String:测试数据,HJZ:%Float:测试数据,INNURSE:%Float:测试数据,ZH:%Float:测试数据,ALLOC:%Float:测试数据,DEMOGROUP:%Float:测试数据,CASHIER:%Float:测试数据,PL:%Float:测试数据,HM:%Float:测试数据") [ SqlProc ]
{
}

// query的执行部分

ClassMethod LQueryDowReqExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, LocDr As %String) As %Status
{
	s repid=$I(^CacheTemp) //相当于一个计数器
	s qHandle=$lb(0,repid,0)
	s ind=1
	s pid=$I(^Tmp) //相当于一个计数器    根据任务id统计
	s tid=$I(^Tub) ///设置一个计数器^tmp1    根据科室统计
	s count=1
	
	S StDate=$zdh(StDate,3)
	S EndDate=$zdh(EndDate,3)
	i LocDr'="" s ReqLocDesc=$p(^CTLOC(LocDr),"^",1)
	
	F date=StDate:1:EndDate D
	.s id=""
	.f  s id=$o(^DHCDISRE(0,"CreateDate",date,id)) q:id=""  d
	..s locdr=$p(^DHCDISRE(id),"^",6)
	..i locdr'="" s locdec=$p(^CTLOC(locdr),"^",1)
	..q:(LocDr'="")&(locdr'=LocDr)
	..
	..s ItmNum=0
	..s childsub=""
	..f  s childsub=$o(^DHCDISRE(id,"Itm",childsub)) q:childsub=""  d
	...s ItmNum=ItmNum+1
	..
	..s PeopleNum=0
	..s PeopleName=""
	..s peopleid=""
	..f peopleid=$o(^DHCDISPE(0,"TypePointer",0,id,peopleid)) q:(peopleid="")||(PeopleNum=1)  d
	...s PeopleDr=$p(^DHCDISPE(peopleid),"^",3)
	...s PeopleNum=PeopleNum+1
	...i PeopleDr'="" s PeopleName=$p(^SSU("SSUSR",PeopleDr),"^",2)
	..q:PeopleName=""
	..s listdata=locdec_"^"_PeopleName_"^"_ItmNum
	..s ^Tmp("web.DHCDISWorkAccount","LQueryDowReq",pid,count)=listdata
	..s count=count+1
	
	s HJZ=0,INNURSE=0,ZH=0,ALLOC=0,DEMOGROUP=0,CASHIER=0,PL=0,HM=0
	s Tmpid=""
	f  s Tmpid=$o(^Tmp("web.DHCDISWorkAccount","LQueryDowReq",pid,Tmpid)) q:Tmpid=""  d
	.s locdec=$p(^Tmp("web.DHCDISWorkAccount","LQueryDowReq",pid,Tmpid),"^",1)
	.s PeopleName=$p(^Tmp("web.DHCDISWorkAccount","LQueryDowReq",pid,Tmpid),"^",2)
	.s ItmNum=$p(^Tmp("web.DHCDISWorkAccount","LQueryDowReq",pid,Tmpid),"^",3)
	.i $d(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec)) d
	..i PeopleName="郝建珍"  d
	...s $p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",2)=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",2)+ItmNum
	..e  i PeopleName="innurse"  d
	...s $p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",3)=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",3)+ItmNum
	..e  i PeopleName="赵红"  d
	...s $p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",4)=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",4)+ItmNum
	..e  i PeopleName="Alloc"  d
	...s $p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",5)=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",5)+ItmNum
	..e  i PeopleName="Demo Group"  d
	...s $p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",6)=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",6)+ItmNum
	..e  i PeopleName="cashier"  d
	...s $p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",7)=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",7)+ItmNum
	..e  i PeopleName="庞琳"  d
	...s $p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",8)=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",8)+ItmNum
	..e  i PeopleName="何明"  d
	...s $p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",9)=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",9)+ItmNum
	.e  d
	..s ^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec)=locdec_"^"_HJZ_"^"_INNURSE_"^"_ZH_"^"_ALLOC_"^"_DEMOGROUP_"^"_CASHIER_"^"_PL_"^"_HM
	
	s locdec=""
	f  s locdec=$o(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec)) q:locdec=""  d
	.s locdec=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",1)
	.s HJZ=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",2)
	.s INNURSE=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",3)
	.s ZH=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",4)
	.s ALLO=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",5)
	.s DEMOGROUP=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",6)
	.s CASHIER=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",7)
	.s PL=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",8)
	.s HM=$p(^Tub("web.DHCDISWorkAccount","LQueryDowReq",tid,locdec),"^",9)
	.s ListData=locdec_"^"_HJZ_"^"_INNURSE_"^"_ZH_"^"_ALLOC_"^"_DEMOGROUP_"^"_CASHIER_"^"_PL_"^"_HM
	.s data = $lb(locdec,HJZ,INNURSE,ZH,ALLOC,DEMOGROUP,CASHIER,PL,HM)
	.s ^CacheTemp(repid,ind)=data	     //将这些数据存储在一个临时global中
	.s ind=ind+1
	
	s qHandle=$lb(0,repid,0)
	q $$$OK
}

ClassMethod LQueryDowReqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LQueryDowReqExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod LQueryDowReqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LQueryDowReqExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		s AtEnd=1
		s Row=""
	}
	Else     
	 {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

/// Description: 配送申请量查询
/// Creator:     zhaowuqiang
/// Creatdate:   2017-02-09
/// Table:       DHC_DisGoodsRequest,DHC_DisGoodsReqItm,DHC_DisLocItem
/// Input:       开始日期^结束日期^科室^项目
/// Output:      本院人次^外院人次^本院项目数^外院项目数^人次合计^项目合计
/// Others:      D ##class(%ResultSet).RunQuery("web.DHCDISWorkAccount","QueryEscortWorkByPeople","2019-01-01","2019-02-14","","2")
Query QueryEscortWorkByPeople(StDate As %String, EndDate As %String, HosDr As %String, HOSPID As %String) As %Query(ROWSPEC = "EscortPeople:%String,ThisPeopleNum:%Integer,OtherPeopleNum:%Integer,ThisHosItemNum:%Integer,OtherHosItemNum:%Integer,PeopleNum:%Integer,ItemNum:%Integer") [ SqlProc ]
{
}

ClassMethod QueryEscortWorkByPeopleExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, HosDr As %String, HOSPID As %String) As %Status
{
	N (qHandle,StDate,EndDate,HosDr,HOSPID)

	s ^tempsufan("6666")=$lb(StDate,EndDate,HosDr,HOSPID)
	s repid=$I(^CacheTemp) //相当于一个计数器
	s qHandle=$lb(0,repid,0)
	s ind=1
	s tid=$I(^TMP) //相当于一个计数器            根据陪送安排统计陪送量
	;i (StDate=""||EndDate="") s qHandle=$lb(0,repid,0) q $$$OK
	i (StDate="")||(EndDate="") Q $$$OK
	e  d
	.s:StDate'="" StDate=$zdh(StDate,3)			///##class(web.DHCDISCommonDS).DateHtmlToLogical(StDate)
	.s:EndDate'="" EndDate=$zdh(EndDate,3)			///##class(web.DHCDISCommonDS).DateHtmlToLogical(EndDate)
	s HosDr=HOSPID
	s TypeId=$o(^DHCDISTA(0,"Code","陪送",""))
	f dd=StDate:1:EndDate d
	.s RSRowID=0
	.f  s RSRowID=$o(^DHCDISRS(0,"TypeDate",TypeId,dd,RSRowID))  q:RSRowID=""  d
	..s Status=$p(^DHCDISRS(RSRowID),"^",3)
	..s StatusCode=$p(^DHCDISSA(Status),"^",1)
	..q:(StatusCode'="13")&&(StatusCode'="14")
	..s ReqID=$p(^DHCDISRS(RSRowID),"^",2)				/// 申请单ID
	..;q:+ReqID=0
	..s DisHospID=$p(^DHCDISRE(ReqID),"^",20)
	..Q:(HosDr'="")&&(DisHospID'=HosDr)
	..s DisTypeAddDr=$p(^DHCDISRE(ReqID),"^",18)    //陪送类型
	..s CurStatusDr=$p(^DHCDISRE(ReqID),"^",16)		//状态类型
	..s:CurStatusDr'="" CurStatusCode=$p(^DHCDISSA(CurStatusDr),"^",1)
	..s:CurStatusDr'="" CurStatus=$p(^DHCDISSA(CurStatusDr),"^",2)    //申请单当前状态
	..s ThisHosItemNum=0     //本院项目数
	..s OtherHosItemNum=0    //外院项目数
	..s ThisPeopleNum=0      //本院人次
	..s OtherPeopleNum=0     //外院人次
	..s ItemNum=0            //项目合计
	..s PeopleNum=0          //人次合计
	..s ItemSub="",HosID="",ItemType="",OtherItm=""
	..f  s ItemSub=$o(^DHCDISRE(ReqID,"Itm",ItemSub)) q:ItemSub=""  d
	...s ItemID=$p(^DHCDISRE(ReqID,"Itm",ItemSub),"^",1)
	...s ItemType=$p(^DHCDISRE(ReqID,"Itm",ItemSub),"^",2)
	...i ItemType="Oth" d
	....s OtherItm=$p(^DHCDISLI(ItemID),"^",2)		/// 其他项目描述
	....q:OtherItm["理发"
	....s HosID=$p(^DHCDISLI(ItemID),"^",6)
	....s:HosID=HosDr ThisHosItemNum=ThisHosItemNum+1    //增加本院项目数
	....s:HosID'=HosDr OtherHosItemNum=OtherHosItemNum+1 //增加外院项目数
	...e  d
	....s ThisHosItemNum=ThisHosItemNum+1
	..i ItemType="Oth" d
	...s OtherItm=$p(^DHCDISLI(ItemID),"^",2)		/// 其他项目描述
	...q:OtherItm["理发"
	...s:HosID=HosDr ThisPeopleNum=ThisPeopleNum+1       //增加本院人数
	...s:HosID'=HosDr OtherPeopleNum=OtherPeopleNum+1    //增加外院人数
	..e  d
	...s ThisPeopleNum=ThisPeopleNum+1
	..s ItemNum=ThisHosItemNum+OtherHosItemNum            //人次合计
	..s PeopleNum=ThisPeopleNum+OtherPeopleNum            //项目数合计
	..s DPRowid="",EscortPeople=""
	..q:(OtherItm'="")&&(OtherItm["理发")
	..f  s DPRowid=$o(^DHCDISPE("0","TypePointer",DisTypeAddDr,ReqID,DPRowid)) q:DPRowid=""  d
	...q:+DPRowid=0
	...s DPUserStatus=$p(^DHCDISPE(DPRowid),"^",4)
	...q:DPUserStatus=-1   //过滤掉撤销安排的人员
	...s DPUserDr=$p(^DHCDISPE(DPRowid),"^",3)
	...s:DPUserDr'="" EscortPeople=$p(^SSU("SSUSR",DPUserDr),"^",2)  //陪送人员
	..s ListData=EscortPeople_"^"_ThisPeopleNum_"^"_OtherPeopleNum_"^"_ThisHosItemNum_"^"_OtherHosItemNum_"^"_PeopleNum_"^"_ItemNum_"^"_ReqID
	..;b   //ListData
	..q:EscortPeople=""
	..i '$d(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople))  d
	...s ^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople)=ListData
	..e  d
	...s $p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",2)=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",2)+$p(ListData,"^",2)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",3)=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",3)+$p(ListData,"^",3)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",4)=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",4)+$p(ListData,"^",4)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",5)=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",5)+$p(ListData,"^",5)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",6)=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",6)+$p(ListData,"^",6)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",7)=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,EscortPeople),"^",7)+$p(ListData,"^",7)

	s People=""
	f  s People=$o(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People)) q:People=""  d
	.s EscortPeople=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",1)
	.s ThisPeopleNum=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",2)
	.s OtherPeopleNum=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",3)
	.s ThisHosItemNum=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",4)
	.s OtherHosItemNum=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",5)
	.s PeopleNum=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",6)
	.s ItemNum=$p(^TMP("DHCDIS","QueryEscortWorkByPeople",tid,People),"^",7)
	.s data = $lb(EscortPeople,ThisPeopleNum,OtherPeopleNum,ThisHosItemNum,OtherHosItemNum,PeopleNum,ItemNum)
	.s ^CacheTemp(repid,ind)=data	     //将这些数据存储在一个临时global中
	.s ind=ind+1
	.s qHandle=$lb(0,repid,0)

	q $$$OK
}

ClassMethod QueryEscortWorkByPeopleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEscortWorkByPeopleExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod QueryEscortWorkByPeopleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEscortWorkByPeopleExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		s AtEnd=1
		s Row=""
	}
	Else     
	 {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

/// Description: 各科室陪送工作量查询
/// Creator:     sufan
/// Creatdate:   2017-12-20
/// Table:       DHC_DisGoodsRequest,DHC_DisGoodsReqItm,DHC_DisLocItem
/// Input:       开始日期^结束日期^科室
/// Output:      科室^完成^空趟
/// Others:      D ##class(%ResultSet).RunQuery("web.DHCDISWorkAccount","QueryEscortWorkByLoc","2018-12-14","2018-12-14","","","2")
Query QueryEscortWorkByLoc(StDate As %String, EndDate As %String, LocID As %String, HosDr As %String, HOSPID As %String) As %Query(ROWSPEC = "LocDesc:%String,ThisHosPeople:%Integer,OtherHosPeople:%Integer,ThisHosItemNum:%Integer,OtherHosItemNum:%Integer") [ SqlProc ]
{
}

ClassMethod QueryEscortWorkByLocExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, LocID As %String, HosDr As %String, HOSPID As %String) As %Status
{
	N (qHandle,StDate,EndDate,LocID,HosDr,HOSPID)
	s repid=$I(^CacheTemp) //相当于一个计数器
	s qHandle=$lb(0,repid,0)
	s ind=1
	s tid=$I(^TMP) //相当于一个计数器            根据陪送安排统计陪送量
	;i (StDate=""||EndDate="") s qHandle=$lb(0,repid,0) q $$$OK
	i (StDate="")||(EndDate="") Q $$$OK
	e  d
	.s:StDate'="" StDate=$zdh(StDate,3)			
	.s:EndDate'="" EndDate=$zdh(EndDate,3)	
	s HosDr=HOSPID	
	s TypeId=$o(^DHCDISTA(0,"Code","陪送",""))	
	f dd=StDate:1:EndDate d
	.s RSRowID=0
	.f  s RSRowID=$o(^DHCDISRS(0,"TypeDate",TypeId,dd,RSRowID))  q:RSRowID=""  d
	..s Status=$p(^DHCDISRS(RSRowID),"^",3)
	..s StatusCode=$p(^DHCDISSA(Status),"^",1)
	..q:(StatusCode'="13")&&(StatusCode'="14")
	..s ReqID=$p(^DHCDISRS(RSRowID),"^",2)				/// 申请单ID
	..s DisTypeAddDr=$p(^DHCDISRE(ReqID),"^",18)    	///	陪送类型
	..s EpisodeID=$p(^DHCDISRE(ReqID),"^",4)			/// 就诊ID
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 			/// 就诊科室
	..s PatWardDr=$p(^PAADM(EpisodeID),"^",70) 			/// 就诊病区
	..s DisHospID=$p(^DHCDISRE(ReqID),"^",20)
	..Q:(HosDr'="")&&(DisHospID'=HosDr)
	..s CtLocDr=""
	..i PatWardDr'="" s CtLocDr=$p(^PAWARD(PatWardDr),"^",5)	/// 所在护理单元
	..s PatType=$p(^PAADM(EpisodeID),"^",2)				/// 患者就诊类型
	..i PatType'="I"  s CtLocDr=PatLocID
	..s CurStatusDr=$p(^DHCDISRE(ReqID),"^",16)		//状态类型
	..s:CurStatusDr'="" CurStatusCode=$p(^DHCDISSA(CurStatusDr),"^",1)
	..s:CurStatusDr'="" CurStatus=$p(^DHCDISSA(CurStatusDr),"^",2)    //申请单当前状态
	..s CompletAmount=0      /// 确认完成数量
	..s EmptyQuan=0    		 /// 空趟数量
	..i CurStatus="完成确认" s CompletAmount=CompletAmount+1
	..i CurStatus="空趟"  s EmptyQuan=EmptyQuan+1
	..s ThisHosItemNum=0     //本院项目数
	..s OtherHosItemNum=0    //外院项目数
	..s ThisHosPeople=0		 //本院人次
	..s OtherHosPeople=0	 //外院人次
	..s ItemSub="",HosID="",ItemType="",OtherItm=""
	..f  s ItemSub=$o(^DHCDISRE(ReqID,"Itm",ItemSub)) q:ItemSub=""  d
	...s ItemID=$p(^DHCDISRE(ReqID,"Itm",ItemSub),"^",1)
	...s ItemType=$p(^DHCDISRE(ReqID,"Itm",ItemSub),"^",2)
	...i ItemType="Oth" d
	....s OtherItm=$p(^DHCDISLI(ItemID),"^",2)		/// 其他项目描述
	....q:OtherItm["理发"
	....s HosID=$p(^DHCDISLI(ItemID),"^",6)
	....i HosID=HosDr  d
	.....s ThisHosItemNum=ThisHosItemNum+1    //增加本院项目数
	....i HosID'=HosDr   d
	.....s OtherHosItemNum=OtherHosItemNum+1  //增加外院项目数
	...e  d
	....s ThisHosItemNum=ThisHosItemNum+1
	..i ItemType="Oth" d
	...s OtherItm=$p(^DHCDISLI(ItemID),"^",2)		/// 其他项目描述
	...q:OtherItm["理发"
	...s:HosID=HosDr ThisHosPeople=ThisHosPeople+1       //增加本院人数
	...s:HosID'=HosDr OtherHosPeople=OtherHosPeople+1    //增加外院人数
	..e  d
	...s ThisHosPeople=ThisHosPeople+1
	..q:(OtherItm'="")&&(OtherItm["理发")
	..s ListData=CtLocDr_"^"_ThisHosPeople_"^"_OtherHosPeople_"^"_ThisHosItemNum_"^"_OtherHosItemNum
	..i '$d(^TMP("DHCDIS","QueryEscortWorkByLoc",tid,CtLocDr))  d
	...s ^TMP("DHCDIS","QueryEscortWorkByLoc",tid,CtLocDr)=ListData
	..e  d
	...s $p(^TMP("DHCDIS","QueryEscortWorkByLoc",tid,CtLocDr),"^",2)=$p(^TMP("DHCDIS","QueryEscortWorkByLoc",tid,CtLocDr),"^",2)+$p(ListData,"^",2)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByLoc",tid,CtLocDr),"^",3)=$p(^TMP("DHCDIS","QueryEscortWorkByLoc",tid,CtLocDr),"^",3)+$p(ListData,"^",3)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByLoc",tid,CtLocDr),"^",4)=$p(^TMP("DHCDIS","QueryEscortWorkByLoc",tid,CtLocDr),"^",4)+$p(ListData,"^",4)
	...s $p(^TMP("DHCDIS","QueryEscortWorkByLoc",tid,CtLocDr),"^",5)=$p(^TMP("DHCDIS","QueryEscortWorkByLoc",tid,CtLocDr),"^",5)+$p(ListData,"^",5)
	
	
	///取个状态数量
	s PatLoc=""
	for  s PatLoc=$o(^TMP("DHCDIS","QueryEscortWorkByLoc",tid,PatLoc)) q:PatLoc=""  d
	.s mdata=^(PatLoc)
	.s LocDesc=$p(^CTLOC(PatLoc),"^",2)			/// 科室描述
	.s ThisHosPeople=$p(mdata,"^",2)			/// 本院人次
	.s OtherHosPeople=$p(mdata,"^",3)			/// 外院人次
	.s ThisHosItemNum=$p(mdata,"^",4)			/// 本院项目数
	.s OtherHosItemNum=$p(mdata,"^",5)			/// 外院项目数
	.s data = $lb(LocDesc,ThisHosPeople,OtherHosPeople,ThisHosItemNum,OtherHosItemNum)
	.s ^CacheTemp(repid,ind)=data	     		//将这些数据存储在一个临时global中
	.s ind=ind+1
	.s qHandle=$lb(0,repid,0)

	q $$$OK
}

ClassMethod QueryEscortWorkByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEscortWorkByLocExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod QueryEscortWorkByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEscortWorkByLocExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		s AtEnd=1
		s Row=""
	}
	Else     
	 {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

/// Description: 各科室各护工陪送工作量查询
/// Creator:     sufan
/// Creatdate:   2017-12-20
/// Table:       DHC_DisGoodsRequest,DHC_DisGoodsReqItm,DHC_DisLocItem
/// Input:       开始日期^结束日期^科室
/// Output:      科室^完成^空趟
/// Others:      D ##class(%ResultSet).RunQuery("web.DHCDISWorkAccount","QueryEveWorkerByLoc","2018-10-01","2018-11-01","","1")
Query QueryEveWorkerByLoc(StDate As %String, EndDate As %String, LocID As %String, HosDr As %String, HOSPID As %String) As %Query(ROWSPEC = "EscortName:%String,LocDesc:%String,CompletAmount:%Integer,EmptyQuan:%Integer,ThisHosItemNum:%Integer,OtherHosItemNum:%Integer") [ SqlProc ]
{
}

ClassMethod QueryEveWorkerByLocExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, LocID As %String, HosDr As %String, HOSPID As %String) As %Status
{
	N (qHandle,StDate,EndDate,LocID,HosDr,HOSPID)
	s repid=$I(^CacheTemp) //相当于一个计数器
	s qHandle=$lb(0,repid,0)
	s ind=1
	s tid=$I(^TMP) //相当于一个计数器            根据陪送安排统计陪送量
	k ^TMP("DHCDIS","QueryEveWorkerByLoc",tid)
	;i (StDate=""||EndDate="") s qHandle=$lb(0,repid,0) q $$$OK
	i (StDate="")||(EndDate="") Q $$$OK
	e  d
	.s:StDate'="" StDate=$zdh(StDate,3)			
	.s:EndDate'="" EndDate=$zdh(EndDate,3)	
	s HosDr=HOSPID	
	s TypeId=$o(^DHCDISTA(0,"Code","陪送",""))	
	f dd=StDate:1:EndDate d
	.s RSRowID=0
	.f  s RSRowID=$o(^DHCDISRS(0,"TypeDate",TypeId,dd,RSRowID))  q:RSRowID=""  d
	..s Status=$p(^DHCDISRS(RSRowID),"^",3)
	..s StatusCode=$p(^DHCDISSA(Status),"^",1)
	..q:(StatusCode'="13")&&(StatusCode'="14")
	..s ReqID=$p(^DHCDISRS(RSRowID),"^",2)				/// 申请单ID
	..s DisTypeAddDr=$p(^DHCDISRE(ReqID),"^",18)    	///	陪送类型
	..s EpisodeID=$p(^DHCDISRE(ReqID),"^",4)			/// 就诊ID
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 			/// 就诊科室
	..s PatWardDr=$p(^PAADM(EpisodeID),"^",70) 			/// 就诊病区
	..s DisHospID=$p(^DHCDISRE(ReqID),"^",20)
	..Q:(HosDr'="")&&(DisHospID'=HosDr)
	..s CtLocDr=""
	..i PatWardDr'="" s CtLocDr=$p(^PAWARD(PatWardDr),"^",5)			/// 所在护理单元
	..s PatType=$p(^PAADM(EpisodeID),"^",2)				/// 患者就诊类型
	..i PatType'="I"  s CtLocDr=PatLocID
	..s CurStatusDr=$p(^DHCDISRE(ReqID),"^",16)		//状态类型
	..s:CurStatusDr'="" CurStatusCode=$p(^DHCDISSA(CurStatusDr),"^",1)
	..s:CurStatusDr'="" CurStatus=$p(^DHCDISSA(CurStatusDr),"^",2)    //申请单当前状态
	..s CompletAmount=0     /// 确认完成数量
	..s EmptyQuan=0    		/// 空趟数量
	..i CurStatus="确认完成" s CompletAmount=CompletAmount+1
	..i CurStatus="空趟"  s EmptyQuan=EmptyQuan+1
	..s ThisHosItemNum=0     //本院项目数
	..s OtherHosItemNum=0    //外院项目数
	..s ItemSub="",HosID="",ItemType="",OtherItm=""
	..f  s ItemSub=$o(^DHCDISRE(ReqID,"Itm",ItemSub)) q:ItemSub=""  d
	...s ItemID=$p(^DHCDISRE(ReqID,"Itm",ItemSub),"^",1)
	...s ItemType=$p(^DHCDISRE(ReqID,"Itm",ItemSub),"^",2)
	...i ItemType="Oth" d
	....s OtherItm=$p(^DHCDISLI(ItemID),"^",2)		/// 其他项目描述
	....q:OtherItm["理发"
	....s HosID=$p(^DHCDISLI(ItemID),"^",6)
	....s:HosID=HosDr ThisHosItemNum=ThisHosItemNum+1    //增加本院项目数
	....s:HosID'=HosDr OtherHosItemNum=OtherHosItemNum+1 //增加外院项目数
	...e  d
	....s ThisHosItemNum=ThisHosItemNum+1
	..s DPRowid=""
	..f  s DPRowid=$o(^DHCDISPE("0","TypePointer",DisTypeAddDr,ReqID,DPRowid)) q:DPRowid=""  d
	...q:+DPRowid=0
	...s DPUserStatus=$p(^DHCDISPE(DPRowid),"^",4)
	...q:DPUserStatus=-1   //过滤掉撤销安排的人员
	...s DPUserDr=$p(^DHCDISPE(DPRowid),"^",3)
	...s:DPUserDr'="" EscortPeople=$p(^SSU("SSUSR",DPUserDr),"^",2)  //陪送人员
	..s ListData=EscortPeople_"^"_CtLocDr_"^"_CompletAmount_"^"_EmptyQuan_"^"_ThisHosItemNum_"^"_OtherHosItemNum
	..i '$d(^TMP("DHCDIS","QueryEveWorkerByLoc",tid,CtLocDr,DPUserDr))  d
	...s ^TMP("DHCDIS","QueryEveWorkerByLoc",tid,CtLocDr,DPUserDr)=ListData
	..e  d
	...s $p(^TMP("DHCDIS","QueryEveWorkerByLoc",tid,CtLocDr,DPUserDr),"^",3)=$p(^TMP("DHCDIS","QueryEveWorkerByLoc",tid,CtLocDr,DPUserDr),"^",3)+$p(ListData,"^",3)
	...s $p(^TMP("DHCDIS","QueryEveWorkerByLoc",tid,CtLocDr,DPUserDr),"^",4)=$p(^TMP("DHCDIS","QueryEveWorkerByLoc",tid,CtLocDr,DPUserDr),"^",4)+$p(ListData,"^",4)
	...s $p(^TMP("DHCDIS","QueryEveWorkerByLoc",tid,CtLocDr,DPUserDr),"^",5)=$p(^TMP("DHCDIS","QueryEveWorkerByLoc",tid,CtLocDr,DPUserDr),"^",5)+$p(ListData,"^",5)
	...s $p(^TMP("DHCDIS","QueryEveWorkerByLoc",tid,CtLocDr,DPUserDr),"^",6)=$p(^TMP("DHCDIS","QueryEveWorkerByLoc",tid,CtLocDr,DPUserDr),"^",6)+$p(ListData,"^",6)
	
	
	///取个状态数量
	s PatLoc=""
	for  s PatLoc=$o(^TMP("DHCDIS","QueryEveWorkerByLoc",tid,PatLoc)) q:PatLoc=""  d
	.s EscortID=""
	.for  s EscortID=$o(^TMP("DHCDIS","QueryEveWorkerByLoc",tid,PatLoc,EscortID)) q:EscortID=""  d
	..s mdata=^(EscortID)
	..s EscortName=$p(mdata,"^",1)				/// 护工姓名
	..s LocDesc=$p(^CTLOC(PatLoc),"^",2)		/// 科室描述
	..s CompletAmount=$p(mdata,"^",3)			/// 完成数量
	..s EmptyQuan=$p(mdata,"^",4)				/// 空趟数量
	..s ThisHosItemNum=$p(mdata,"^",5)				/// 空趟数量
	..s OtherHosItemNum=$p(mdata,"^",6)				/// 空趟数量
	..s data = $lb(EscortName,LocDesc,CompletAmount,EmptyQuan,ThisHosItemNum,OtherHosItemNum)
	..s ^CacheTemp(repid,ind)=data	     		//将这些数据存储在一个临时global中
	..s ind=ind+1
	..s qHandle=$lb(0,repid,0)
	k ^TMP("DHCDIS","QueryEveWorkerByLoc",tid)
	q $$$OK
}

ClassMethod QueryEveWorkerByLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEveWorkerByLocExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod QueryEveWorkerByLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEveWorkerByLocExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		s AtEnd=1
		s Row=""
	}
	Else     
	 {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

/// Description: 各科室各护工理发工作量查询
/// Creator:     sufan
/// Creatdate:   2018-02-01
/// Table:       DHC_DisGoodsRequest,DHC_DisGoodsReqItm,DHC_DisLocItem
/// Input:       开始日期^结束日期^科室
/// Output:      科室^完成^空趟
/// Others:      D ##class(%ResultSet).RunQuery("web.DHCDISWorkAccount","QueryHairCutWork","2018-10-01","2018-12-07","","","2")
Query QueryHairCutWork(StDate As %String, EndDate As %String, LocID As %String, HosDr As %String, HOSPID As %String) As %Query(ROWSPEC = "EscortName:%String,LocDesc:%String,HiarCutNum:%Integer") [ SqlProc ]
{
}

ClassMethod QueryHairCutWorkExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, LocID As %String, HosDr As %String, HOSPID As %String) As %Status
{
	N (qHandle,StDate,EndDate,LocID,HosDr,HOSPID)
	s ^tempsufan("333")=$lb(StDate,EndDate,LocID,HosDr,HOSPID)
	s repid=$I(^CacheTemp) //相当于一个计数器
	s qHandle=$lb(0,repid,0)
	s ind=1
	s tid=$I(^TMP) //相当于一个计数器            根据陪送安排统计陪送量
	k ^TMP("DHCDIS","QueryHairCutWork",tid)
	i (StDate="")||(EndDate="") Q $$$OK
	e  d
	.s:StDate'="" StDate=$zdh(StDate,3)			
	.s:EndDate'="" EndDate=$zdh(EndDate,3)	
	s TypeId=$o(^DHCDISTA(0,"Code","陪送",""))	
	f dd=StDate:1:EndDate d
	.s RSRowID=0
	.f  s RSRowID=$o(^DHCDISRS(0,"TypeDate",TypeId,dd,RSRowID))  q:RSRowID=""  d
	..s Status=$p(^DHCDISRS(RSRowID),"^",3)
	..s StatusCode=$p(^DHCDISSA(Status),"^",1)
	..q:(StatusCode'="13")&&(StatusCode'="14")
	..s ReqID=$p(^DHCDISRS(RSRowID),"^",2)				/// 申请单ID
	..s DisTypeAddDr=$p(^DHCDISRE(ReqID),"^",18)    	///	陪送类型
	..s EpisodeID=$p(^DHCDISRE(ReqID),"^",4)			/// 就诊ID
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 			/// 就诊科室
	..s PatWardDr=$p(^PAADM(EpisodeID),"^",70) 			/// 就诊病区
	..s DisHospID=$p(^DHCDISRE(ReqID),"^",20)
	..Q:(HosDr'="")&&(DisHospID'=HosDr)
	..s CtLocDr=""
	..i PatWardDr'="" s CtLocDr=$p(^PAWARD(PatWardDr),"^",5)			/// 所在护理单元
	..s PatType=$p(^PAADM(EpisodeID),"^",2)				/// 患者就诊类型
	..i PatType'="I"  s CtLocDr=PatLocID
	..s CurStatusDr=$p(^DHCDISRE(ReqID),"^",16)			/// 状态类型
	..s:CurStatusDr'="" CurStatusCode=$p(^DHCDISSA(CurStatusDr),"^",1)
	..s:CurStatusDr'="" CurStatus=$p(^DHCDISSA(CurStatusDr),"^",2)    //申请单当前状态
	..s HiarCutNum=0    	//理发目数
	..s DPRowid=""
	..f  s DPRowid=$o(^DHCDISPE("0","TypePointer",DisTypeAddDr,ReqID,DPRowid)) q:DPRowid=""  d
	...q:+DPRowid=0
	...s DPUserStatus=$p(^DHCDISPE(DPRowid),"^",4)
	...q:DPUserStatus=-1   //过滤掉撤销安排的人员
	...s DPUserDr=$p(^DHCDISPE(DPRowid),"^",3)
	...s:DPUserDr'="" EscortPeople=$p(^SSU("SSUSR",DPUserDr),"^",2)  //陪送人员
	..s ItemSub="",HosID="",ItemType=""
	..f  s ItemSub=$o(^DHCDISRE(ReqID,"Itm",ItemSub)) q:ItemSub=""  d
	...s ItemID=$p(^DHCDISRE(ReqID,"Itm",ItemSub),"^",1)
	...s ItemType=$p(^DHCDISRE(ReqID,"Itm",ItemSub),"^",2)
	...q:ItemType'="Oth" 
	...s OtherItm=$p($g(^DHCDISLI(ItemID)),"^",2)		/// 其他项目描述
	...q:OtherItm'["理发"
	...s HiarCutNum=HiarCutNum+1
	...s ListData=DPUserDr_"^"_EscortPeople_"^"_CtLocDr_"^"_HiarCutNum
	...i '$d(^TMP("DHCDIS","QueryHairCutWork",tid,CtLocDr,DPUserDr))  d
	....s ^TMP("DHCDIS","QueryHairCutWork",tid,CtLocDr,DPUserDr)=ListData
	...e  d
	....s $p(^TMP("DHCDIS","QueryHairCutWork",tid,CtLocDr,DPUserDr),"^",4)=$p(^TMP("DHCDIS","QueryHairCutWork",tid,CtLocDr,DPUserDr),"^",4)+$p(ListData,"^",4)
	
	///取个状态数量
	s PatLoc=""
	for  s PatLoc=$o(^TMP("DHCDIS","QueryHairCutWork",tid,PatLoc)) q:PatLoc=""  d
	.s EscortID=""
	.for  s EscortID=$o(^TMP("DHCDIS","QueryHairCutWork",tid,PatLoc,EscortID)) q:EscortID=""  d
	..s mdata=^(EscortID)
	..s EscortName=$p(mdata,"^",2)				/// 护工姓名
	..s LocDesc=$p(^CTLOC(PatLoc),"^",2)		/// 科室描述
	..s HiarCutNum=$p(mdata,"^",4)			/// 理发数量
	..s data = $lb(EscortName,LocDesc,HiarCutNum)
	..s ^CacheTemp(repid,ind)=data	     		//将这些数据存储在一个临时global中
	..s ind=ind+1
	..s qHandle=$lb(0,repid,0)
	k ^TMP("DHCDIS","QueryHairCutWork",tid)
	q $$$OK
}

ClassMethod QueryHairCutWorkClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryHairCutWorkExecute ]
{
	s repid=$LIST(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod QueryHairCutWorkFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryHairCutWorkExecute ]
{
	s AtEnd=$LIST(qHandle,1)
	s repid=$LIST(qHandle,2)
	s ind=$LIST(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		s AtEnd=1
		s Row=""
	}
	Else     
	 {				
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

}
