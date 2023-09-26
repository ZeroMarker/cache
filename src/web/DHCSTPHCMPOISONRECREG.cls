/// 麻醉药品和第一类精神药品登记查询类
Class web.DHCSTPHCMPOISONRECREG Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:麻醉药品和第一类精神药品入库验收登记
/// W ##Class(web.DHCSTPHCMPOISONRECREG).jsonPoisonExaReg("2016-03-31^2016-03-31^240")
ClassMethod jsonPoisonExaReg(rows As %String, page As %String, strParam As %String) As %String
{
	n (rows,page,strParam)
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	
	s pid=..NewPid()
	d ..killTmpGlobal(pid)

	s StartDate=$p(strParam,"^",1)
	s EndDate=$p(strParam,"^",2)
	s LocID=$p(strParam,"^",3)
	s Inci=$p(strParam,"^",4)
	
	// 准备数据
	s Num=..GetPoisonExaReg(pid, StartDate, EndDate, LocID, Inci)
	
	i Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:Num="0"

	S ListTitle="srIngrDate^srInciDesc^srForm^srSpec^srUomDesc^srCertNo^srInQty^srBatNo^srExpDate^srManf^srVendor^srQuaCon^srExaRes^srExaUsr^srIngUsr"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPOISONRECREG","QueryPoisonExaReg",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMPOISONRECREG","QueryPoisonExaReg",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:麻醉药品和第一类精神药品入库验收登记
/// D ##Class(%ResultSet).RunQuery("web.DHCSTPHCMPOISONRECREG","QueryPoisonExaReg","2016-03-31","2016-03-31","240")
Query QueryPoisonExaReg(StartDate As %String, EndDate As %String, LocID As %String, Inci As %String) As %Query(ROWSPEC = "ingrDate:%String,InciDesc:%String,FormDesc:%String,Spec:%String,UomDesc:%String,ingrNo:%String,InQty:%String,BatNo:%String,ExpDate:%String,manfDesc:%String,vendor:%String,CheckPack:%String,ExaRes:%String,ingrAccUser:%String,ingrUser:%String") [ SqlProc ]
{
}

ClassMethod QueryPoisonExaRegExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LocID As %String, Inci As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)

	i StartDate="" Quit $$$OK
	i EndDate="" Quit $$$OK  
	
	s pid=..NewPid() //计数器
	D ..killTmpGlobal(pid) //k掉临时global
	
	// 准备数据
	D ..GetPoisonExaReg(pid, StartDate, EndDate, LocID, Inci)
 	
	//输出
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPOISONRECREG","QueryPoisonExaReg",pid,index)) Q:index=""  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTPHCMPOISONRECREG","QueryPoisonExaReg",pid,index))
	.Q:mdata=""
	.S ListData=$LISTFROMSTRING(mdata,"^")   //converted into a Cache list
	.Set ^CacheTemp(repid,ind)=ListData	
	.Set ind=ind+1
	
	D ..killTmpGlobal(pid) //k掉临时global
    Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPoisonExaRegClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPoisonExaRegExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryPoisonExaRegFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPoisonExaRegExecute ]
{
 
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Descript:查询一段时间内的麻醉药品和第一类精神药品的入库验收信息
ClassMethod GetPoisonExaReg(pid As %String, StartDate As %String, EndDate As %String, LocID As %String, Inciid As %String) As %String
{
	n (pid, StartDate, EndDate, LocID, Inciid)
	
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	
	s Num=0
	f dd=StartDate:1:EndDate d
	.s ingr=""
	.f  s ingr=$o(^DHCINGR(0,"CreateDate",dd,LocID,ingr)) q:ingr=""  d
	..s ingrNo=$p(^DHCINGR(ingr),"^",1)  	 ///单号
	..s vendor=""
	..s vendordr=$p(^DHCINGR(ingr),"^",3)    ///供应商
	..s:vendordr'="" vendor=$p(^APC("APCVM",vendordr),"^",3)
	..s ingrDate=$p(^DHCINGR(ingr),"^",14)   ///日期
	..s:ingrDate'="" ingrDate=$zd(ingrDate,3)
	..s ingrUser=""
	..s ingrUserID=$p(^DHCINGR(ingr),"^",8)  ///制单人
	..s:ingrUserID'="" ingrUser=$p(^SSU("SSUSR",ingrUserID),"^",2)
	..s ingrAccUser=""
	..s ingrAUserID=$p(^DHCINGR(ingr),"^",26) ///接受人
	..s:ingrAUserID'="" ingrAccUser=$p(^SSU("SSUSR",ingrAUserID),"^",2)
	..s itm=""
	..f  s itm=$o(^DHCINGR(ingr,"GRI",itm)) q:itm=""  d
	...s ingri=ingr_"||"_itm
	...s Inclb=$p(^DHCINGR(ingr,"GRI",itm),"^",1)
	...s Inci=$p(^DHCINGR(ingr,"GRI",itm),"^",25)
	...q:(Inciid'="")&(Inciid'=Inci)
	...s InciCode = $p(^INCI(Inci,1),"^",1)  ///药品代码
	...s InciDesc = $p(^INCI(Inci,1),"^",2)  ///药品名称
	...s tmpstkgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(Inci) ///类组
 	...s TmpStkGrpId=$p(tmpstkgrp,"^",5)
 	...s manfDesc=""
 	...s manfID=$p(^DHCINGR(ingr,"GRI",itm),"^",29)
 	...s:manfID'="" manfDesc=$P(^PHMNF(manfID),"^",2)
 	...s FormStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(Inci) ///剂型
 	...s FormDesc=$p(FormStr,"^",2)
 	...s InQty=$p(^DHCINGR(ingr,"GRI",itm),"^",4)   ///数量
 	...s UomID=$p(^DHCINGR(ingr,"GRI",itm),"^",10)  ///单位
 	...s UomDesc=""
 	...s:UomID'="" UomDesc=$p(^CT("UOM",UomID),"^",2)
 	...s TmpPoison=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(Inci)
	...s TmpPoisonId=$p(TmpPoison,"^",2)
	...q:'..CheckStrIfExistVar(TmpPoisonId)
	...s ExpDate=$p(^DHCINGR(ingr,"GRI",itm),"^",9) ///效期
 	...s:ExpDate'="" ExpDate=$zd(ExpDate,3)
 	...s BatNo=$p(^DHCINGR(ingr,"GRI",itm),"^",13)  ///批号
 	...s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",Inci)
 	...s CheckPack=$p(^DHCINGR(ingr,"GRI",itm),"^",41)  //包装质量
 	...s ExaRes="合格"
 	...
 	...s Num=Num+1
 	...s ListData=ingrDate_"^"_InciDesc_"^"_FormDesc_"^"_Spec_"^"_UomDesc_"^"_ingrNo_"^"_InQty_"^"_BatNo_"^"_ExpDate
 	...s ListData=ListData_"^"_manfDesc_"^"_vendor_"^"_CheckPack_"^"_ExaRes_"^"_ingrAccUser_"^"_ingrUser
 	...s ^TMP("DHCST","web.DHCSTPHCMPOISONRECREG","QueryPoisonExaReg",pid,Num)=ListData
 	..
 	q Num
}

/// Descript:按照管制分类过滤
ClassMethod CheckStrIfExistVar(InVal) As %String
{
	n (InVal)
	s InString="3,4,5,10,11"
	s InStrArrList=$LISTFROMSTRING(InString,",")
	q:$lv(InStrArrList)=0 "1"
	q:$lf(InStrArrList,InVal)=0 "0"
	q 1
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMPOISONRECREG","QueryPoisonExaReg",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMPOISONRECREG"))
}

}
