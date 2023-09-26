/// 麻醉药品和第一类精神药品登记查询类
Class web.DHCSTPHCMPOIDRUGINOUTLOC Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:麻醉药品和第一类精神药品入库验收登记
/// W ##Class(web.DHCSTPHCMPOIDRUGINOUTLOC).jsonPoisonInOutStock("30","1","2016-04-25^2016-05-06^1302^")
ClassMethod jsonPoisonInOutStock(rows As %String, page As %String, strParam As %String) As %String
{
	n (rows,page,strParam)
	s ^huang("page")=page_","_rows
	s EndPage=page*rows  //结束行
	s StPage=((page-1)*rows)+1     //开始行
	s pid=..NewPid()
	d ..killTmpGlobal(pid)
	s StartDate=$p(strParam,"^",1)
	s EndDate=$p(strParam,"^",2)
	s LocID=$p(strParam,"^",3)
	s Inci=$p(strParam,"^",4)
	
	// 准备数据
	s Num=..GetTimeOut(pid, StartDate, EndDate, LocID, Inci)
	
	i Num="0" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	q:Num="0"

	S ListTitle="srIngrDate^srInciDesc^srForm^srSpec^srCertNo^srVendor^srUomDesc^srInQty^srOutQty^srResQty^srBatNo^srExpDate^srManf^srSendFlag^srExaUsr^srIngUsr"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPOIDRUGINOUTLOC","QueryPoisonExaReg",pid,index)) Q:(index="")||(quitflag=1)  D
	.S ListData=^TMP("DHCST","web.DHCSTPHCMPOIDRUGINOUTLOC","QueryPoisonExaReg",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.q:Num>EndPage
	.//S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:麻醉药品和第一类精神药品入库验收登记
/// D ##Class(%ResultSet).RunQuery("web.DHCSTPHCMPOIDRUGINOUTLOC","QueryPoisonExaReg","2016-03-31","2016-03-31","240")
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
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPOIDRUGINOUTLOC","QueryPoisonExaReg",pid,index)) Q:index=""  D
	.S mdata=$g(^TMP("DHCST","web.DHCSTPHCMPOIDRUGINOUTLOC","QueryPoisonExaReg",pid,index))
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
/// w ##class(web.DHCSTPHCMPOISONINOUTSTOCK).GetPoisonExaReg("0","2016-04-01","2016-05-06","1302","")
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
	..s:vendor["-" vendor=$p(vendor,"-",2)
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
 	...s:manfDesc["-" manfDesc=$p(manfDesc,"-",2)
 	...s FormStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(Inci) ///剂型
 	...s FormDesc=$p(FormStr,"^",2)
 	...s InQty=$p(^DHCINGR(ingr,"GRI",itm),"^",4)   ///数量
    ...s OutQty=""
    ...s ResQty=##class(web.DHCST.Common.DrugStkCommon).IL(Inci,LocID,dd)  //基本单位数量当天
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
 	...s InisUser=""
 	...s ToLocDesc=$P(^CTLOC(LocID),"^",2)
 	...s Num=Num+1
 	...s ListData=ingrDate_"^"_InciDesc_"^"_FormDesc_"^"_Spec_"^"_ingrNo_"^"_vendor_"/"_ToLocDesc_"^"_UomDesc_"^"_InQty_"^"_OutQty_"^"_ResQty_"^"_BatNo_"^"_ExpDate
 	...s ListData=ListData_"^"_manfDesc_"^"_InisUser_"^"_ingrUser_"^"_ingrAccUser
 	...s ^TMP("DHCST","web.DHCSTPHCMPOIDRUGINOUTLOC","QueryPoisonExaReg",pid,Num)=ListData
 	q Num
}

/// /查询转出明细
/// /w ##class(web.DHCSTPHCMPOISONINOUTSTOCK).GetTransferOutDetail("0","2016-04-01","2016-05-06","1302","")
ClassMethod GetTransferOutDetail(pid As %String, StartDate As %String, EndDate As %String, LocID As %String, Inciid As %String) As %Library.String
{

	n (pid,StartDate,EndDate,LocID,Inciid)
	
	q:StartDate="" ""
	q:EndDate="" ""
	q:LocID="" ""
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
	s i=..GetPoisonExaReg(pid, StartDate, EndDate, LocID, Inciid)
	f date=StartDate:1:EndDate d
 	.s intrid="" 
 	.f  s intrid=$o(^DHCINTR(0,"TypeDate","T",date,intrid)) q:intrid=""  d
 	..q:'$d(^DHCINTR(intrid))
 	..s pointer=$p(^DHCINTR(intrid),"^",9)
 	..s MainId=+pointer
 	..s Chl=$p(pointer,"||",2)
 	..q:'$d(^DHCINIT(MainId))
 	..q:'$d(^DHCINIT(MainId,"ITI",Chl))
 	..s FromLocId=$p(^DHCINIT(MainId),"^",5)   ;出库科室	
 	..s ToLocId=$p(^DHCINIT(MainId),"^",6)   ;接收科室
 	..q:ToLocId'=LocID   ;非统计科室
 	..s:ToLocId'="" ToLocDesc=$p(^CTLOC(ToLocId),"^",2)
 	..s:FromLocId'="" FromLocDesc=$p(^CTLOC(FromLocId),"^",2)
 	..s inclbid=$p(^DHCINTR(intrid),"^",7)
 	..q:inclbid=""
 	..s inciid=$p(inclbid,"||",1)
 	..q:(Inciid'="")&(Inciid'=inciid)			;库存项不符
 	..q:'$d(^INCI(inciid,1))
 	..q:'$d(^INCI(inciid,2))
 	..q:'$d(^INCI(inciid,3))
 	..s InciDesc=$p(^INCI(inciid,1),"^",2)     //药品名称
 	..s TmpPoison=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inciid)
	..s TmpPoisonId=$p(TmpPoison,"^",2)
	..q:'..CheckStrIfExistVar(TmpPoisonId)    //过滤麻精药品
 	..s manfinfo=##class(web.DHCST.Common.DrugStkCommon).GetManfInfoByInclb(inclbid)
 	..s gmanfid=$p(manfinfo,"^",1)
 	..s ManfDesc=$p(manfinfo,"^",2)             
 	..s:ManfDesc["-" ManfDesc=$p(ManfDesc,"-",2)           //生产厂商
 	..s FormStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inciid)
 	..s FormDesc=$p(FormStr,"^",2)           //剂型
 	..s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inciid)   //规格
 	..s VenInfo=##class(web.DHCST.Common.DrugStkCommon).GetInclbVend(inclbid,date)
 	..s apcvmid=$p(VenInfo,"^",1)
 	..s vendor=$p(VenInfo,"^",2)            
    ..s:vendor["-" vendor=$p(vendor,"-",2)   //供应商
 	..s TmpBat=##class(web.DHCST.Common.DrugStkCommon).Bat(inclbid)
 	..s BatNo=$p(TmpBat,"^",1)              //批号
 	..s ExpDate=$p(TmpBat,"^",2)            //效期
    ..s InQty=$p(^DHCINTR(intrid),"^",6)        //数量
    ..s:InQty<0 InQty=-InQty
    ..s OutQty=""        
    ..s ResQty=##class(web.DHCST.Common.DrugStkCommon).IL(inciid,LocID,date)  //基本单位数量当天
	..s Uomdr=$p(^DHCINTR(intrid),"^",10)      
	..s:Uomdr'="" UomDesc=$p(^CT("UOM",Uomdr),"^",2)
	..s InisUserID=$p(^DHCINIT(MainId),"^",8)                //发药人
	..s InisUser=$p(^SSU("SSUSR",InisUserID),"^",2)
	..s AckUserID=$p(^DHCINIT(MainId),"^",17)               //复核人
	..s AckUser=$p(^SSU("SSUSR",AckUserID),"^",2) 
	..s reqdr=$p(^DHCINIT(MainId),"^",7)
	..i reqdr'="" d  
	...s ingUseR=$p($G(^INRQ(reqdr)),"^",4)                                          //领用人
	...s ingUser=$p(^SSU("SSUSR",ingUseR),"^",2) 
	..e   d
	...s ingUser=""
	..s IntrNo=$p(^DHCINTR(intrid),"^",13)  
 	..s TrDate=date
 	..s TrDate=$zd(TrDate,3)
 	..s i=i+1
 	..s ListData=TrDate_"^"_InciDesc_"^"_FormDesc_"^"_Spec_"^"_IntrNo_"^"_vendor_"/"_ToLocDesc_"^"_UomDesc_"^"_InQty_"^"_OutQty_"^"_ResQty_"^"_BatNo_"^"_ExpDate
 	..s ListData=ListData_"^"_ManfDesc_"^"_InisUser_"^"_AckUser_"^"_ingUser
 	..s ^TMP("DHCST","web.DHCSTPHCMPOIDRUGINOUTLOC","QueryPoisonExaReg",pid,i)=ListData 	
 	q i
}

/// descript:获取药房发药信息
/// w ##class(web.DHCSTPHCMPOIDRUGINOUTLOC).GetTimeOut("0","64054","64054","982","")
ClassMethod GetTimeOut(pid As %String, StartDate As %String, EndDate As %String, LocID As %String, Inciid As %String) As %Library.String
{
	n (pid,StartDate,EndDate,LocID,Inciid)

    q:StartDate="" ""
	q:EndDate="" ""
	q:LocID="" ""
	s:StartDate["-" StartDate=$zdh(StartDate,3)
	s:EndDate["-" EndDate=$zdh(EndDate,3)
    s i=..GetTransferOutDetail(pid,StartDate, EndDate, LocID, Inciid)
    s phl=""
    s phl=$o(^DHCPHLOCi("LOC",LocID,""))
    q:phl=""
 	f phddate=StartDate:1:EndDate  d
	.s phdrow = ""
	.f  s phdrow=$o(^DHCPHDISPi(phddate,phl,phdrow)) q:phdrow=""  d
    ..q:'$d(^DHCPHDISP(phdrow))
    ..s prescno=$p(^DHCPHDISP(phdrow,2),"^",1)   //处方号
    ..s pmi=""
    ..s pmi=+$p(^DHCPHDISP(phdrow),"^",7)
    ..s pname=$p(^PAPER(pmi,"ALL"),"^",1)  //姓名
    ..s phdi=""
    ..f  s phdi=$o(^DHCPHDI(phdrow,"PHDI",phdi)) q:phdi=""  d
    ...s orditm=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",5) 
    ...s ItemMast=$p(^OEORD(+orditm,"I",$p(orditm,"||",2),1),"^",2) //医嘱项ID
    ...s inciid=""
    ...s inciid=$o(^INCI(0,"ARCIM_DR",$p(ItemMast,"||",1),inciid))
    ...q:(Inciid'="")&(inciid'=Inciid)
    ...s InciDesc=$p(^INCI(inciid,1),"^",2)     //药品名称
    ...s TmpPoison=##class(web.DHCST.Common.DrugInfoCommon).GetMangerDrug(inciid)
	...s TmpPoisonId=$p(TmpPoison,"^",2)
	...q:'..CheckStrIfExistVar(TmpPoisonId)    //过滤麻精药品
    ...s FormStr=##class(web.DHCST.Common.DrugInfoCommon).GetForm(inciid)
    ...s FormDesc=$p(FormStr,"^",2)           //剂型
    ...s Spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inciid)   //规格
    ...s VenInfo=##class(web.DHCST.Common.DrugStkCommon).GetLastVen(inciid) 
    ...s vendor=$p(VenInfo,"^",2)            
    ...s:vendor["-" vendor=$p(vendor,"-",2)   //供应商
    ...s Manfinfo=##class(web.DHCST.Common.DrugStkCommon).GetLastManf(inciid) 
    ...s ManfDesc=$p(Manfinfo,"^",2)       //厂商
    ...s ToLocDesc=""
    ...s OutQty=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",4) //发药数量
    ...s phaditm=phdrow_"||"_phdi
    ...s intrid=""
    ...s intrid=$o(^DHCINTR(0,"TypePointer","F",phaditm,intrid)) 
    ...s OutQty=$p(^DHCPHDI(phdrow,"PHDI",phdi),"^",4)     //数量
    ...s:OutQty<0 OutQty=-OutQty
    ...s InQty=""
    ...s ResQty=##class(web.DHCST.Common.DrugStkCommon).IL(inciid,LocID,phddate)  //基本单位数量当天
    ...s Uomdr=$p(^INCI(inciid,1),"^",10)      
	...s:Uomdr'="" UomDesc=$p(^CT("UOM",Uomdr),"^",2)     //单位
	...s BatNo=""
	...s ExpDate=""
	...s InisUserID=+$p(^DHCPHDISP(phdrow,1),"^",2)
	...i $d(^DHCPHPER(InisUserID))  s InisUser=$p(^DHCPHPER(InisUserID),"^",2)    //发药人 
	...s AckUser=InisUser    //复核人
	...s ingUser=pname        //领用人
	...s TrDate=phddate
 	...s TrDate=$zd(TrDate,3)
 	...s IntrNo=prescno
 	...s i=i+1
	...s ListData=TrDate_"^"_InciDesc_"^"_FormDesc_"^"_Spec_"^"_IntrNo_"^"_vendor_"/"_ToLocDesc_"^"_UomDesc_"^"_InQty_"^"_OutQty_"^"_ResQty_"^"_BatNo_"^"_ExpDate
 	...s ListData=ListData_"^"_ManfDesc_"^"_InisUser_"^"_AckUser_"^"_ingUser
	...s ^TMP("DHCST","web.DHCSTPHCMPOIDRUGINOUTLOC","QueryPoisonExaReg",pid,i)=ListData

	q i
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
	k ^TMP("DHCST","web.DHCSTPHCMPOIDRUGINOUTLOC","QueryPoisonExaReg",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMPOIDRUGINOUTLOC"))
}

}
