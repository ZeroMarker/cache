Import sqluser

/// creator:	yunhaibao
/// createdate: 2017-04-28
/// description:海虹表数据处理,用于接口入库
Class web.DHCST.HHImport Extends %RegisteredObject [ Not ProcedureBlock ]
{

Parameter Split = "|@|";

/// description: 获取海虹表主表数据
/// StrParam:开始日期^结束日期^供应商ID^入库科室ID^类组^是否入库
/// w ##class(web.DHCST.HHImport).JSQueryHHImport(0,30,"","","2017-04-28^2017-04-28^747^102^1^N")
ClassMethod JSQueryHHImport(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String)
{
	n (Start,Limit,Sort,Dir,StrParam)
	s $zt="ErrorJSQueryHHImport"
	s startdate=$p(StrParam,"^",1)
	i startdate["-" s startdate=$zdh(startdate,3)
	s enddate=$p(StrParam,"^",2)
	i enddate["-" s enddate=$zdh(enddate,3)
	s vendor=$p(StrParam,"^",3)
	s loc=$p(StrParam,"^",4)
	s stkcatgrp=$p(StrParam,"^",5)
	s importstat=$p(StrParam,"^",6)  //入库状态,选取是判断入库状态
	s End = Start+Limit 
	s Start=Start+1 
	s titleinfo="SCIOrderNo^SCIRecDate^LocDesc^VendorDesc^LocId^VendorId^HHImport"
	s count=0
	s date=""
	f date=startdate:1:enddate d
	.s dhchh=""  
	.f  s dhchh=$o(^DHCHI(0,"Date",date,dhchh)) q:dhchh=""  d
	..s hhvendor=$p(^DHCHI(dhchh),"^",5)
	..s hhrecloc=$p(^DHCHI(dhchh),"^",7)  //SCI入库科室
	..s hhreqloc=$p(^DHCHI(dhchh),"^",6)  //HIS订单科室
	..s hhinpo=$p(^DHCHI(dhchh),"^",8)
	..s hhsciorderno=$p(^DHCHI(dhchh),"^",2) 
	..s importflag=$p(^DHCHI(dhchh),"^",4)
	..q:(importstat="Y")&&(importflag'="Y")  //已入库
	..q:(importstat="N")&&(importflag="Y")   //未入库
	..s dhchhitm=$o(^DHCHI(dhchh,"I",""))
	..q:+dhchhitm=0
	..s hhincicode=$p(^DHCHI(dhchh,"I",dhchhitm),"^",1)
	..q:hhincicode=""
	..s hhinci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(hhincicode)
	..q:hhinci=""
	..s hhcatgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(hhinci)
	..s hhcatgrp=$p(hhcatgrp,"^",5)
	..q:(stkcatgrp'="")&&(stkcatgrp'=hhcatgrp)
	..q:(vendor'="")&(vendor'=hhvendor)  ;过滤供应商
	..q:hhvendor=""
	..q:'$d(^APC("APCVM",hhvendor))
	..s hhvendordesc=$p(^APC("APCVM",hhvendor),"^",3)
	..s hhdate=$p(^DHCHI(dhchh),"^",1)
	..i hhdate'="" s hhdate=$zd(hhdate,3)
	..q:(loc'="")&&(loc'=hhreqloc)
	..s reclocdesc=$p(^CTLOC(hhrecloc),"^",2)
	..i reclocdesc["-" s reclocdesc=$p(reclocdesc,"-",2)
	..s datainfo=hhsciorderno_"^"_hhdate_"^"_reclocdesc_"^"_hhvendordesc_"^"_hhrecloc_"^"_hhvendor_"^"_dhchh
	..s count=count+1
	..q:count<Start
	..q:count>End
	..i count=Start d
	...w "{rows:["
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(datainfo,titleinfo)
	...w retstring
	..e  d
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(datainfo,titleinfo)
	...w ","_retstring
	i count>0 w "],results:"_count_"}"
	e  w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q ""
ErrorJSQueryHHImport
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// description: 获取海虹表子表数据
/// StrParam:主表ID
/// w ##class(web.DHCST.HHImport).JSQueryHHImportDetail(0,30,"","","100000063")
ClassMethod JSQueryHHImportDetail(Start As %Integer, Limit As %Integer, Sort As %String, Dir As %String, StrParam As %String)
{
	n (Start,Limit,Sort,Dir,StrParam)
	s $zt="ErrorJSQueryHHImportDetail"
	s dhchh=$p(StrParam,"^",1)
	i dhchh="" w "{results:0,rows:[]}"
	q:dhchh="" ""
	s Title1="IncId^BatchNo^IngrUom^ExpDate^RecQty^Remarks^IncCode^IncDesc^InvNo^Manf"
	s Title2="Rp^RpAmt^Sp^SpAmt^InvDate^Spec^InvMoney^HHImportItm^ReqLocDesc"
	s Title=Title1_"^"_Title2
	s End = Start+Limit 
	s Start=Start+1
	s count=0
	s dhchhitm=""
	f  s dhchhitm=$o(^DHCHI(dhchh,"I",dhchhitm)) q:dhchhitm=""  d
	.q:+dhchhitm=0
	.s hhimportitm=dhchh_"||"_dhchhitm
	.s dhchhitminfo=^DHCHI(dhchh,"I",dhchhitm)
	.s incicode=$p(dhchhitminfo,"^",1)
	.q:incicode=""
	.s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
	.q:inci=""
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.s uomdesc=$p(dhchhitminfo,"^",3)  //单位描述
	.s batno=$p(dhchhitminfo,"^",4)
	.s expdate=$p(dhchhitminfo,"^",11)
	.i expdate'="" s expdate=$zd(expdate,3)
	.s rp=$p(dhchhitminfo,"^",5)
	.s qty=$p(dhchhitminfo,"^",7)
	.s invno=$p(dhchhitminfo,"^",9)
	.s invdate=$p(dhchhitminfo,"^",10)
	.i invdate'="" s invdate=$zd(invdate,3)
	.s invamt=$p(dhchhitminfo,"^",12)
	.s sp=$p(dhchhitminfo,"^",14)
	.s rpamt=qty*rp
	.s spamt=qty*sp
	.s remark=##class(web.DHCST.Common.DrugInfoCommon).GetInciRemark(inci)
	.s manf=##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci)
	.s manf=$p(manf,"^",3)
	.i manf["-" s manf=$p(manf,"-",2,$l(manf,"-"))
	.s spec=##class(web.DHCST.Common.DrugInfoCommon).GetSpec("",inci)
	.s reqloc="" //$p(dhchhitminfo,"^",24)
	.s reqlocdesc="" //$p(^CTLOC(reqloc),"^",2)
	.i reqlocdesc["-" s reqlocdesc=$p(reqlocdesc,"-",2)
	.s Data1=inci_"^"_batno_"^"_uomdesc_"^"_expdate_"^"_qty_"^"_remark_"^"_incicode_"^"_incidesc_"^"_invno_"^"_manf
	.s Data2=rp_"^"_rpamt_"^"_sp_"^"_spamt_"^"_invdate_"^"_spec_"^"_invamt_"^"_hhimportitm_"^"_reqlocdesc
	.s Data=Data1_"^"_Data2
	.s count=count+1
	.q:count<Start
	.q:count>End
	.i count=1 d
	..w "{rows:["
	..s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
	..w retstring
	.e  d
	..s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(Data,Title)
	..w ","_retstring
	i count>0 w "],results:"_count_"}"
	e  w ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q ""
	
ErrorJSQueryHHImportDetail
	s Error=$$Error^DHCSTERROR()
	q "{Error:'"_Error_"'}"
}

/// description: 获取海虹表子表数据
/// description: 插入User.DHC_HHImport
/// others:		 HHData-inpoid_"^"_locid_"^"_vendorid_"^"_purlocid_"^"_sciorderno
/// w ##class(web.DHCST.HHImport).InsertHHImport("1923^^^102^22",1)
ClassMethod InsertHHImport(HHData, UserId) As %String
{
	n (HHData,UserId)
	s hhobj=##class(User.DHCHHImport).%New()
	d hhobj.DHIDateSet(+$h)							 ; 日期
	d hhobj.DHIflagSet("N")							 ; 是否完成
	s hhobj.DHIfile=$p(HHData,"^",5)				 ; 第三方单号				
	d hhobj.DHIUserDRSetObjectId(UserId)			 ; 建单人
	d hhobj.DHIPoDrSetObjectId($p(HHData,"^",1))	 ; his订单ID
	d hhobj.DHIRecLocDRSetObjectId($p(HHData,"^",2)) ; 入库科室ID
	d hhobj.DHIReqLocDRSetObjectId($p(HHData,"^",4)) ; 请求科室ID
	d hhobj.DHIVendDRSetObjectId($p(HHData,"^",3))	 ; 供应商ID
	s sc=hhobj.%Save()
	i $$$ISERR(sc) d
	.s errinfo=$System.Status.GetErrorText(sc)
	.d ErrorRecord^DHCSTERROR("DHCSTIMPORT","User.DHCHHImport",errinfo)
	q hhobj.%Id()
}

/// description: 插入User.DHC_HHImportItm
ClassMethod InsertHHImportItm(HHMain, HHItmData) As %String
{
	n (HHItmData,HHMain)
	s hhitmobj=##class(User.DHCHHYTImportItm).%New()
	d hhitmobj.DHIIParrefSetObjectId(HHMain) 				; 关联主表
	s hhitmobj.DHIIChildSub=$o(^DHCHI(HHMain,"I",""),-1)+1
	s hhitmobj.DHIIincicode=$p(HHItmData,"^",1)				; 药品代码	
	s hhitmobj.DHIIincibarcode=$p(HHItmData,"^",8) 			; 条码
	s hhitmobj.DHIIrealqty=$p(HHItmData,"^",3)				; 入库数量
	s hhitmobj.DHIIbatno=$p(HHItmData,"^",4)				; 批号
	s hhitmobj.DHIIexpdate=$p(HHItmData,"^",5)				; 效期
	s hhitmobj.DHIIinvno=$p(HHItmData,"^",6)				; 发票号
	s hhitmobj.DHIIinvdate=$p(HHItmData,"^",7)				; 发票日期
	s hhitmobj.DHIIrprice=$p(HHItmData,"^",10)				; 进价
	s hhitmobj.DHIIExtPoID=$p(HHItmData,"^",13)			    ; 第三方子表ID
	d hhitmobj.DHIIPoDrSetObjectId($p(HHItmData,"^",9))		; HIS订单子表ID
	d hhitmobj.DHIIUomDrSetObjectId($p(HHItmData,"^",11))	; 单位ID
	s hhitmobj.DHIIuomdesc=$p(HHItmData,"^",12)				; 单位
	s hhitmobj.DHIIpoqty=$p(HHItmData,"^",14)				; 订单数量	
	s sc=hhitmobj.%Save()
	i $$$ISERR(sc) d
	.s errinfo=$System.Status.GetErrorText(sc)
	.d ErrorRecord^DHCSTERROR("DHCSTIMPORT","User.DHCHHImportItm",errinfo)
	q hhitmobj.%Id()
}

/// creator:yunhaibao
/// createdate:2017-04-28
/// description:根据海虹表数据生成入库单
/// input:海虹主表id
/// w ##class(web.DHCST.HHImport).CommitImport(100000081,1)
ClassMethod CommitImport(StrParam, userid)
{
	n (StrParam,userid)
	s dhchh=+$p(StrParam,"^",1)
	s split=..%GetParameter("Split")
	q:dhchh="" -1_split_"获取中间数据失败!"
	s hhvendor=$p(^DHCHI(dhchh),"^",5)
	s recloc=$p(^DHCHI(dhchh),"^",7)   //实际入库科室
	q:recloc="" -1_split_"获取不到入库科室！" 
	s hhreqloc=$p(^DHCHI(dhchh),"^",6)
	s hospotalid=$p(^CTLOC(recloc),"^",22)
	s hhinpo=$p(^DHCHI(dhchh),"^",8)
	s hhflag=$p(^DHCHI(dhchh),"^",4)
	Q:hhflag="Y" -1_split_"该数据已经提交入库!"
	q:hhvendor="" -1_split_"获取不到供应商!"
	s dhchhitm=$o(^DHCHI(dhchh,"I",""))
    q:+dhchhitm=0 -1_split_"明细数据为空!"
	s hhincicode=$p(^DHCHI(dhchh,"I",dhchhitm),"^",1)
	q:hhincicode="" -1_split_"获取不到药品类组信息!"
	s hhinci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(hhincicode)
	q:hhinci="" -1_split_"获取药品类组信息失败!"
	s hhcatgrp=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(hhinci)
	s hhcatgrp=$p(hhcatgrp,"^",5)
	s operatetype=..GetDefautRecType()
	s maininfo1 = hhvendor_"^"_recloc_"^"_userid_"^"_""_"^"_""
	s maininfo2=operatetype_"^"_"" _"^"_hhcatgrp_"^"_""_"^"_""
	s maininfo3=""_"^"_""_"^"_""
	s maininfo=maininfo1_"^"_maininfo2_"^"_maininfo3
	s dhchhitm=""  //重新定义
	s detailinfo=""
	f  s dhchhitm=$o(^DHCHI(dhchh,"I",dhchhitm)) q:dhchhitm=""  d
	.q:+dhchhitm=0
	.s hhimportitm=dhchh_"||"_dhchhitm
	.s dhchhitminfo=^DHCHI(dhchh,"I",dhchhitm)
	.s incicode=$p(dhchhitminfo,"^",1)
	.q:incicode=""
	.s inci=##class(web.DHCSTCOMMONSRV).ItemCodeToID(incicode)
	.q:inci=""
	.s incidesc=$p(^INCI(inci,1),"^",2)
	.s uomid=$p(dhchhitminfo,"^",23)
	.q:uomid=""
	.s batno=$p(dhchhitminfo,"^",4)
	.s expdate=$p(dhchhitminfo,"^",11)
	.i expdate'="" s expdate=$zd(expdate,3)
	.s rp=##class(web.DHCST.Common.PriceCommon).GetInciBasicRp(inci,+$h,uomid,hospotalid,"G","")
	.s qty=$p(dhchhitminfo,"^",7)
	.s invno=$p(dhchhitminfo,"^",9)
	.s invdate=$p(dhchhitminfo,"^",10)
	.i invdate'="" s invdate=$zd(invdate,3)
	.s invamt=$p(dhchhitminfo,"^",12)
	.s sp=##class(web.DHCST.Common.PriceCommon).GetPriceElse(inci,+$h,uomid,hospotalid,"G","")  //提交入库进售价以his为准
	.s rpamt=qty*rp
	.s spamt=qty*sp
	.s remark=##class(web.DHCST.Common.DrugInfoCommon).GetInciRemark(inci)
	.s manf=##class(web.DHCST.Common.DrugInfoCommon).GetManf(inci)
	.s manf=$p(manf,"^",1)
	.s reqloc=$p(dhchhitminfo,"^",24)
	.s sxno=""
	.s disc=""  //折扣,供应链入库取最后一次入库的折扣
	.s inpoi=$p(dhchhitminfo,"^",27)
    .s detail1=""_"^"_inci_"^"_batno_"^"_expdate_"^"_manf
    .s detail2=uomid_"^"_qty_"^"_rp_"^"_sp_"^"_sxno
    .s detail3=invno_"^"_invdate_"^"_inpoi_"^"_""_"^"_""
    .s detail4=""_"^"_""_"^"_""_"^"_""_"^"_""
    .s detail=detail1_"^"_detail2_"^"_detail3_"^"_detail4
    .i detailinfo="" s detailinfo=detail
    .e  s detailinfo=detailinfo_$c(1)_detail
	/*************如上汇总数据,如下带调用保存入库的方法**********/
	s saveret=##class(web.DHCST.DHCINGdRec).Save("",maininfo,detailinfo)
    q:saveret'>0 -1_split_"提交失败!错误代码:"_saveret
	/**************更新海虹表状态为已入库**********************/
	&SQL(UPDATE DHC_HHImport SET DHI_flag='Y' WHERE DHI_RowID=:dhchh)
	Q saveret
}

/// w ##class(web.DHCST.HHImport).GetDefautRecType()
ClassMethod GetDefautRecType()
{
	s opid="",realopid=""
	f  s opid=$o(^DHCOPTYPE(0,"Desc","正常入库",opid)) q:opid=""  d
	.q:$p(^DHCOPTYPE(opid),"^",3)["M"
	.s realopid=opid
	q realopid
}

}
