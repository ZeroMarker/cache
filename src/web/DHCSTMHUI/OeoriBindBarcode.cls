Import sqluser

/// Descript:	将高值医嘱(医嘱包类型比如"关节置换手术")存和高值条码绑定
/// Creator:    wangjiabin
/// CreateDate: 2015-06-17
Class web.DHCSTMHUI.OeoriBindBarcode Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCITMTRACKM";

/// Descript:	将inclb和高值条码进行绑定
/// Creator:	wangjiabin
/// CreateDate:	2015-06-17
/// Oeori:%String,ArcimCode:%String,ArcimDesc:%String,PaAdmNo:%String,PaAdmName:%String,RecLoc:%String,RecLocDesc:%String,OeoriDate:%String,OeoriTime:%String,UserAddName:%String,BarCode:%String,Inci:%String
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.OeoriBindBarcode","QueryOeori","26")
Query QueryOeori(Params As %String) As Query(ROWSPEC = "Oeori,ArcimCode,ArcimDesc,PaAdmNo,PaAdmName,RecLoc,RecLocDesc,OeoriDate,OeoriTime,UserAddName,BarCode,Inci,OeoriPrices:%Float,OeoriStatus,OrderPackQty:%Float") [ SqlProc ]
{
}

ClassMethod QueryOeoriExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle, Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s startdate=PJobj.%Get("StartDate")
	s enddate=PJobj.%Get("EndDate")
	s paadmno=PJobj.%Get("PapmiNo")
	s papmi=""
	s:paadmno'="" papmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(paadmno),0))
	s recloc=PJobj.%Get("LocId")
	s arcitemcat=PJobj.%Get("oeorcat")
	s barcode=PJobj.%Get("BarCode")
	s excludeInci=PJobj.%Get("excludeInci")
	s packFlag=PJobj.%Get("packFlag")
	s Oeoriname=PJobj.%Get("oeoriName")
	s pHospId=PJobj.%Get("gHospId")
	q:startdate="" $$$OK
	q:enddate="" $$$OK
	s:startdate'="" startdate=..DH2L(startdate)
	s:enddate'="" enddate=..DH2L(enddate)
	s BedFeeArcicStr=..GetBedFeeArcicStr()		;床位滚出来的医嘱子类
	k ArcimInfoArr		;临时"数组"
	
	f Date=startdate:1:enddate d
	.s Oeord=0
	.f  s Oeord=$o(^OEORDi(0,"ItemDate",Date,Oeord)) q:Oeord=""  d
	..q:'$d(^OEORD(Oeord))
	..s PaAdm=$p(^OEORD(Oeord),"^",1)
	..s Papmi=$p($g(^PAADM(PaAdm)),"^",1)
	..q:(papmi'="")&&(Papmi'=papmi)				;就诊号过滤
	..&sql(select papmi_no,papmi_name into :PaAdmNo,:PaAdmName from pa_patmas where %id=:Papmi)
	..s Ch=0
	..f  s Ch=$o(^OEORDi(0,"ItemDate",Date,Oeord,Ch)) q:Ch=""  d
	...q:'$d(^OEORD(Oeord,"I",Ch))
	...s Oeori=Oeord_"||"_Ch
	...s OroriState=""
	...s OroriStateDr=$p(^OEORD(Oeord,"I",Ch,1),"^",13) ;医嘱状态
	...s:OroriStateDr'="" OroriState=$p(^OEC("OSTAT",OroriStateDr),"^",1)
	...;q:(OroriState'="V")&&(OroriState'="E") ;过滤非核实或者非执行状态的医嘱 20170828lihui
	...s BarCode=""
	...&sql(select OEORI_MaterialNo into :BarCode from OE_OrdItemExt where OEORI_RowId=:Oeori)
	...q:(barcode'="")&(barcode'=BarCode)
	...s RecLoc=$p(^OEORD(Oeord,"I",Ch,3),"^",6)
	...q:(recloc'="")&&(recloc'=RecLoc)			;医嘱接收科室
	...s hospid=..sssHospId(RecLoc)
	...q:(hospid'=pHospId)
	...q:(##class(web.DHCSTMHUI.CTLOC).LocOfHosp(RecLoc,pHospId)'=0)
	...s RecLocDesc=""
	...s:RecLoc'="" RecLocDesc=$p(^CTLOC(RecLoc),"^",2)
	...s RecLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(RecLocDesc)
	...s arcitm=$p(^OEORD(Oeord,"I",Ch,1),"^",2)
	...q:arcitm=""
	...i '$d(ArcimInfoArr(arcitm)) d
	....s ArcimCode=$p(^ARCIM(+arcitm,$p(arcitm,"||",2),1),"^",1)
	....s ArcimDesc=$p(^ARCIM(+arcitm,$p(arcitm,"||",2),1),"^",2)
	....s Arcic=$p(^ARCIM(+arcitm,$p(arcitm,"||",2),1),"^",10)
	....s Inci=$o(^INCI(0,"ARCIM_DR",$p(arcitm,"||",1),0))
	....s ArcimInfoArr(arcitm)=ArcimCode_"^"_ArcimDesc_"^"_Arcic_"^"_Inci
	...e  d
	....s ArcimInfo=ArcimInfoArr(arcitm)
	....s ArcimCode=$p(ArcimInfo,"^",1)
	....s ArcimDesc=$p(ArcimInfo,"^",2)
	....s Arcic=$p(ArcimInfo,"^",3)
	....s Inci=$p(ArcimInfo,"^",4)
	...q:(excludeInci="Y")&&(Inci'="")					;有库存项的过滤
	...s PackFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPackChargeFlag(Inci)
	...q:(packFlag="Y")&&((Inci="")||(PackFlag'="Y"))	;检查是否为"包",inci为空的过滤
	...q:(arcitemcat'="")&&(Arcic'=arcitemcat)			;医嘱子类
	...q:BedFeeArcicStr[("^"_Arcic_"^")					;床位滚出的医嘱子类的过滤
	...
	...s priority=$p(^OEORD(Oeord,"I",Ch,1),"^",8)
	...q:'$d(^OECPR(priority))
	...s priorCode=$p(^OECPR(priority),"^",1)
	...q:priorCode'="NORM"								;不是临时医嘱的,过滤
	...q:(Oeoriname'="")&&(ArcimDesc'[Oeoriname)		;医嘱项名称模糊过滤
	...s UserAdd=$p($g(^OEORD(Oeord,"I",Ch,7)),"^",1)	;开医嘱人
	...s UserAddName=$s(UserAdd'="":$p($g(^SSU("SSUSR",UserAdd)),"^",2),1:"")
	...
	...s OeoriDate=Date
	...s OeoriDate=..DL2H(OeoriDate)
	...s OeoriTime=$p(^OEORD(Oeord,"I",Ch,3),"^",15)
	...s OeoriTime=..TL2H(OeoriTime)
	...s OeoriData=##class(web.DHCSTMHUI.Common.ServiceCommon).GetOrderMesage(Oeori)
	...s OeoriPrices=$p(OeoriData,"^",3)
	...s OeoriStatus=$p($p(OeoriData,"^",10),",",2)
	...s OrderPackQty=$p(OeoriData,"^",4)
	...s Data1=Oeori_"^"_ArcimCode_"^"_ArcimDesc_"^"_PaAdmNo_"^"_PaAdmName
	...s Data2=RecLoc_"^"_RecLocDesc_"^"_OeoriDate_"^"_OeoriTime_"^"_UserAddName
	...s Data3=BarCode_"^"_Inci_"^"_OeoriPrices_"^"_OeoriStatus_"^"_OrderPackQty
	...d OutPutRow
	
	Quit $$$OK

OutPutRow
	s Data=$lb(Oeori,ArcimCode,ArcimDesc,PaAdmNo,PaAdmName,RecLoc,RecLocDesc,OeoriDate,OeoriTime,UserAddName,BarCode,Inci,OeoriPrices,OeoriStatus,OrderPackQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

Query QueryItem(Params As %String) As Query(ROWSPEC = "RowId,invno,invdate,invamt:%Float,code,desc,orddate,ordtime,qty:%Float,uomdr,uomdesc,oeori,vendordr,manfdr,vendor,manf,rp:%Float,batno,expdate,sp:%Float,feestatus,feeamt:%Float,date,time,user,ingno,dateofmanu,canceled,usercanceled,datecanceled,timecanceled,barcode,inci,IngrFlag,dhcit,vendordr,specdesc,originalcode,IngriModify,IngriModifyNo") [ SqlProc ]
{
}

ClassMethod QueryItemExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle, Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s Oeori=PJobj.%Get("Oeori")
	s Ord=$p(Oeori,"||",1),Itm=$p(Oeori,"||",2)
	i (Ord="")||(Itm="")||('$d(^OEORD(Ord,"I",Itm))) q $$$OK
	s OeoriArcim=$p(^OEORD(Ord,"I",Itm,1),"^",2)
	
	s sqlStr = "select * from DHC_HVMat_OrdItm where ORI_OEORI_DR='"_Oeori_"'"    

	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q ""
	While(result.Next())
	{
		s RowId = result.Data("ORI_RowId")
		s oeori = result.Data("ORI_OEORI_DR")
		s orddate = result.Data("ORI_OEORI_Date")
		s:orddate'="" orddate=..DL2H(orddate)
		s ordtime = result.Data("ORI_OEORI_Time")
		s:ordtime'="" ordtime=$zt(ordtime,1)
		s feestatus = result.Data("ORI_FeeStatus")
		s feeamt = result.Data("ORI_FeeAmt")
		continue:'$d(^OEORD(+oeori,"I",$p(oeori,"||",2)))

		s date = result.Data("ORI_Date")
		s time = result.Data("ORI_Time")
		s:date'="" date=..DL2H(date)
		s:time'="" time=$zt(time,1)
		s userdr = result.Data("ORI_SSUSR_DR")
		s scg = result.Data("ORI_SCG_DR")
		
		s ingri = result.Data("ORI_INGRI_DR")
		s ingr=$p(ingri,"||",1)
		continue:(ingr'="")&&('$d(^DHCINGR(+ingr)))
		s ingno=""
		i ingr'="" s ingno=$p(^DHCINGR(ingr),"^",1)
		
		s batno = result.Data("ORI_BatNo")
		s expdate = result.Data("ORI_ExpDate")
		s:expdate'="" expdate=..DL2H(expdate)
		s dateofmanu = result.Data("ORI_DateOfManu")
		s:dateofmanu'="" dateofmanu=..DL2H(dateofmanu)
		s manfdr = result.Data("ORI_MANF_DR")
		s vendordr = result.Data("ORI_APCVM_DR")
		s uomdr = result.Data("ORI_Unit_DR")
		s qty = result.Data("ORI_Qty")
		s rp = result.Data("ORI_Rp")
		s sp = result.Data("ORI_Sp")
		s rpamt = result.Data("ORI_RpAmt")
		s spamt = result.Data("ORI_SpAmt")
		s barcode = result.Data("ORI_BarCode")
		s canceled = result.Data("ORI_Canceled")
		s usercanceled = result.Data("ORI_UserCanceled_DR")
		s datecanceled = result.Data("ORI_DateCanceled")
		s timecanceled = result.Data("ORI_TimeCanceled")
		s:datecanceled'="" datecanceled=..DL2H(datecanceled)
		s:timecanceled'="" timecanceled=$zt(timecanceled,1)
		s invno = result.Data("ORI_InvNo")
		s invdate = result.Data("ORI_InvDate")
		s:invdate'="" invdate=..DL2H(invdate)
		s invamt = result.Data("ORI_InvAmt")
		s:invamt="" invamt=rpamt			;缺省
		s inci = result.Data("ORI_INCI_DR")
		continue:inci=""
		continue:##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPackChargeFlag(inci)="Y"   ////过滤包
		s Arcim=$p(^INCI(inci,1),"^",3)
		continue:(Arcim=OeoriArcim)				;与医嘱相同的arcim,过滤
		s IngrFlag = result.Data("ORI_IngrFlag")
		s IngriModify=result.Data("ORI_Ingri_Modify_DR")						;补录入库子表dr
		s IngriModifyNo=""
		s:+IngriModify'=0 IngriModifyNo=$p($g(^DHCINGR(+IngriModify)),"^",1)	;补录入库单单号

		s code=$p(^INCI(inci,1),"^",1) ;物资名称
		s desc=$p(^INCI(inci,1),"^",2) ;物资名称
		
		s (manf,vendor,user,usercanceled,uomdesc)=""
		s:manfdr'="" manf=$p(^PHMNF(manfdr),"^",2)
		s:vendordr'="" vendor=$p(^APC("APCVM",vendordr),"^",3)
		i userdr'="" s user=$p($g(^SSU("SSUSR",userdr)),"^",2 )
		i usercanceled'="" s usercanceled=$p($g(^SSU("SSUSR",userdr)),"^",2)
		i uomdr'="" s uomdesc=$p($g(^CT("UOM",uomdr)),"^",2)
		
		s dhcit="",specdesc="",originalcode=""
		s:barcode'="" dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
		s:dhcit'="" specdesc=$P(^DHCIT(dhcit),"^",19)
		s:dhcit'="" originalcode=$P(^DHCIT(dhcit),"^",13)
		d OutPutQueryItem
	}
	
	Quit $$$OK

OutPutQueryItem

	s Data=$lb(RowId,invno,invdate,invamt,code,desc,orddate,ordtime,qty,uomdr,uomdesc,oeori,vendordr,manfdr,vendor,manf,rp,batno,expdate,sp,feestatus,feeamt,date,time,user,ingno,dateofmanu,canceled,usercanceled,datecanceled,timecanceled,barcode,inci,IngrFlag,dhcit,vendordr,specdesc,originalcode,IngriModify,IngriModifyNo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// RowId:%String,Dhcit:%String,BarCode:%String,Inclb:%String,InciCode:%String,InciDesc:%String,BatExp:%String,Vendor:%String,Rp:%String,Manf:%String,AckFlag:%String,OBBDate:%String,OBBTime:%String,OBBUser:%String,OBBAckDate:%String,OBBAckTime:%String,OBBAckUser:%String,CancelDate:%String,CancelTime:%String,CancelSSUSR:%String
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCItmTrack","QueryItmTrackItem","26")
Query QueryDetail(oeori As %String) As Query(ROWSPEC = "RowId,Dhcit,BarCode,Inclb,InciCode,InciDesc,BatExp,Vendor,Rp:%Float,Manf,AckFlag,OBBDate,OBBTime,OBBUser,OBBAckDate,OBBAckTime,OBBAckUser,CancelDate,CancelTime,CancelSSUSR") [ SqlProc ]
{
}

ClassMethod QueryDetailExecute(ByRef qHandle As %Binary, oeori As %String) As %Status
{
	n (qHandle, oeori)
	s ^TMPHOUS("faf")=oeori
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
    s Oeori=oeori
	s StrSql = "SELECT DHCOBB_RowId RowId, DHCOBB_ItmTrack_DR Dhcit, DHCOBB_ItmTrack_DR->DHCIT_Label BarCode, DHCOBB_AckFlag AckFlag, DHCOBB_Date OBBDate,"
		_" DHCOBB_Time OBBTime, DHCOBB_SSUSR_DR OBBUser, DHCOBB_AckDate OBBAckDate, DHCOBB_AckTime OBBAckTime, DHCOBB_AckSSUSR_DR OBBAckUser,"
		_" DHCOBB_CancelDate CancelDate,DHCOBB_CancelTime CancelTime, DHCOBB_CancelSSUSR_DR CancelSSUSRdr "
		_" from DHC_OeoriBindBarCode where DHCOBB_OEORI_DR='"_Oeori_"'"      

	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err q ""
	While(result.Next())
	{
		s RowId=result.Data("RowId")
		s Dhcit=result.Data("Dhcit")
		s BarCode=result.Data("BarCode")
		s Inclb=$p(^DHCIT(Dhcit),"^",12)
		s Inci=$p(^DHCIT(Dhcit),"^",1)
		s InciCode=$p(^INCI(Inci,1),"^",1)
		s InciDesc=$p(^INCI(Inci,1),"^",2)
		s Incib=$p(^INCI(+Inclb,"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
		s (BatchNo,ExpDate,Rp,Manf)=""
		i Incib'="" d
		.s BatchNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
		.s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
		.s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		.s dhcIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
		.i dhcIncib'="" d
		..s Rp=$p(^DHCINCIB(dhcIncib),"^",3)
		..s Manf=$p(^DHCINCIB(dhcIncib),"^",7)
		..s:Manf'="" Manf=$p(^PHMNF(Manf),"^",2)
		..s Vendor=$p(^DHCINCIB(dhcIncib),"^",8)
		..s:Vendor'="" Vendor=$p(^APC("APCVM",Vendor),"^",3)
		
		s BatExp=BatchNo_"~"_ExpDate
		s AckFlag=result.Data("AckFlag")
		s OBBDate=result.Data("OBBDate")
		s:OBBDate'="" OBBDate=..DL2H(OBBDate)
		s OBBTime=result.Data("OBBTime")
		s:OBBTime'="" OBBTime=..TL2H(OBBTime)
		s OBBUser=result.Data("OBBUser")
		s:OBBUser'="" OBBUser=$p(^SSU("SSUSR",OBBUser),"^",2)
		s OBBAckDate=result.Data("OBBAckDate")
		s:OBBAckDate'="" OBBAckDate=..DL2H(OBBAckDate)
		s OBBAckTime=result.Data("OBBAckTime")
		s:OBBAckTime'="" OBBAckTime=..TL2H(OBBAckTime)
		s OBBAckUser=result.Data("OBBAckUser")
		s:OBBAckUser'="" OBBAckUser=$p(^SSU("SSUSR",OBBAckUser),"^",2)
		s CancelDate=result.Data("CancelDate")
		s:CancelDate'="" CancelDate=..DL2H(CancelDate)
		s CancelTime=result.Data("CancelTime")
		s:CancelTime'="" CancelTime=..TL2H(CancelTime)
		s CancelSSUSRdr=result.Data("CancelSSUSRdr")
		s CancelSSUSR=""
		s:CancelSSUSRdr'="" CancelSSUSR=$p(^SSU("SSUSR",CancelSSUSRdr),"^",2)
    	
    	s DataStr=RowId_"^"_Dhcit_"^"_BarCode_"^"_Inclb_"^"_InciCode
			_"^"_InciDesc_"^"_BatExp_"^"_Vendor_"^"_Rp_"^"_Manf
			_"^"_AckFlag_"^"_OBBDate_"^"_OBBTime_"^"_OBBUser_"^"_OBBAckDate
			_"^"_OBBAckTime_"^"_OBBAckUser_"^"_CancelDate_"^"_CancelTime_"^"_CancelSSUSR
		d OutPutRowDetail
	}
	
	Quit $$$OK

OutPutRowDetail
	s Data=$lb(RowId,Dhcit,BarCode,Inclb,InciCode,InciDesc,BatExp,Vendor,Rp,Manf,AckFlag,OBBDate,OBBTime,OBBUser,OBBAckDate,OBBAckTime,OBBAckUser,CancelDate,CancelTime,CancelSSUSR)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// w ##class(web.DHCSTMHUI.OeoriBindBarcode).Save("","","")
/// Descript:	将inclb和高值条码进行绑定
/// Creator:	wangjiabin
/// CreateDate:	2015-06-17
/// Input:		oeori, rowid^dhcit_$c(1)_...
/// Output:     
/// Return：	"":保存正确, 非空:错误信息	
ClassMethod Save(Params, oeori, ListDetail) As %Library.String
{
	n (Params,oeori,ListDetail)
	s RtnObj=##class(RtnObj).%New()
	i ListDetail=""  d
	.s Sc=RtnObj.Err(-1,"","没有需要保存的明细","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s ParamsObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=ParamsObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","主参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s ListDetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=ListDetailObj.%FromJSON(ListDetail)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","主参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s UserId=ParamsObj.%Get("gUserId")
	s Oeori=oeori
	i Oeori=""  d
	.s Sc=RtnObj.Err(-1,"","请选择一条医嘱","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s Dhcobb=$o(^DHCOBB(0,"OEORI",Oeori,0))
	s AckFlag=$s(Dhcobb'="":$p(^DHCOBB(Dhcobb),"^",3),1:"")
	i AckFlag="Y" d RtnObj.Err(-2,"","该医嘱已确认,不允许增加明细!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s recloc=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",6)  ;医嘱接收科室
	s ret=0
	s d=+$h,t=$p($h,",",2)
	ts
	While (RtnObj.success=0) {
		s ItmObj=ListDetailObj.%Pop()
		q:ItmObj=""
		
		s dhcobb=ItmObj.%Get("RowId")
		s dhcit=ItmObj.%Get("Dhcit")
		s barcode=ItmObj.%Get("BarCode")
		s ExitInLoc=$P(##class(web.DHCSTMHUI.PCHCOLLSM).GetArcimByLabel(barcode),"^",6)
		i recloc'=ExitInLoc s Sc=RtnObj.Err(-3,"",barcode_"条码不属于该医嘱接收科室!","",0) q
		i dhcobb="" d
		.s obj=##class(User.DHCOeoriBindBarCode).%New()
		e  d
		.s obj=##class(User.DHCOeoriBindBarCode).%OpenId(dhcobb)
		.d obj.%Reload()
		d obj.DHCOBBOEORIDRSetObjectId(Oeori)
		d obj.DHCOBBItmTrackDRSetObjectId(dhcit)
		s obj.DHCOBBDate=d
		s obj.DHCOBBTime=t
		d obj.DHCOBBSSUSRDRSetObjectId(UserId)
		s sc=obj.%Save()
		i $$$ISERR(sc) s Sc=RtnObj.Err(-2,"",barcode_"保存失败!") q
		q:RtnObj.success'=0
	}
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	s RtnObj.rowid=0
	s RtnObj.msg="保存成功！"
	q RtnObj.Json()
}

/// Descript:	审核医嘱绑定的条码信息,消减库存
/// Creator:	wangjiabin
/// CreateDate:	2015-06-24
/// Input:		oeori
/// Output:     
/// Return：	"":正确, 非空:错误信息	
/// w ##class(web.DHCSTMHUI.OeoriBindBarcode).Audit("67||15","")
ClassMethod Audit(oeori, Params) As %Library.String
{
	n (oeori,Params)
	s RtnObj=##class(RtnObj).%New()
	s ParamsObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=ParamsObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","主参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()
	s UserId=ParamsObj.%Get("gUserId")
	s Oeori=oeori
	i Oeori="" s Sc=RtnObj.Err(-1,"","参数为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s Ret=..GetStatus(Oeori)
	i Ret'=0 s Sc=RtnObj.Err(-2,"","没有需要审核的明细","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s d=+$h,t=$p($h,",",2)
	s AckYes="Y"
	s ret=0
	ts
	s dhcobb=0
	f  s dhcobb=$o(^DHCOBB(0,"OEORI",Oeori,dhcobb)) q:(dhcobb="")||(ret'=0)  d
	.s AckFlag=$p(^DHCOBB(dhcobb),"^",3)
	.q:AckFlag="Y"
	.s CancelDate=$p(^DHCOBB(dhcobb),"^",10)
	.;q:CancelDate'=""  ;已经控制只允许取消一次 然后重新审核 lihui20191105
	.s Dhcit=$p(^DHCOBB(dhcobb),"^",2)
	.s HVBarCode=$p(^DHCIT(Dhcit),"^",2)
	.s result=##class(web.DHCSTMHUI.PCHCOLLSM).DispHVByDhcit(Oeori,Dhcit)
	.i result'=0 s ret=result_"^"_HVBarCode d RtnObj.Err(-3,"","处理跟踪台账失败!")
	.q:result'=0
	.&sql(update DHC_OeoriBindBarCode set DHCOBB_AckFlag=:AckYes,DHCOBB_AckDate=:d,DHCOBB_AckTime=:t,DHCOBB_AckSSUSR_DR=:UserId
		where %id=:dhcobb)
	.i SQLCODE s ret=-1
	.i SQLCODE s Sc=RtnObj.Err(-2,"","更新失败!")
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	///高值医嘱是否实时补录实库 lihui20170831
	s recloc=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",6)  ;医嘱接收科室
	s HospitalId=$p($G(^CTLOC(recloc)),"^",22)
	s AppParam="^^^"_HospitalId
	s AutoRecHVFlag=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCITMTRACKM","DispAutoRecHV",AppParam)
	i ((AutoRecHVFlag="Y")&&(ret="")) d
	.d ##class(web.DHCSTMHUI.HVMatOrdItm).NightRunCreateRecHV()
	s RtnObj.rowid=0
	s RtnObj.msg="审核成功！"
	q RtnObj.Json()
}

/// Descript:	判断医嘱是否存在未审核明细
/// Creator:	lxt
/// CreateDate:	2019-02-16
/// Input:		Oeori
/// Output:     
/// Return：	0存在  -1不存在（没有明细或都已审核）
/// w ##class(web.DHCSTMHUI.OeoriBindBarcode).GetStatus("67||15")
ClassMethod GetStatus(Oeori As %String) As %Library.String
{
	n (Oeori)
	s dhcobb=0
	s ret=-1
	f  s dhcobb=$o(^DHCOBB(0,"OEORI",Oeori,dhcobb)) q:(dhcobb="")||(ret=0)  d
	.s AckFlag=$p(^DHCOBB(dhcobb),"^",3)
	.s:AckFlag="" AckFlag="N"
	.s:AckFlag="N" ret=0
	q ret
}

/// Description:删除高值条码绑定明细信息
/// Creator:	tsr
/// CreatDate:	2019-03-24
/// Table:		DHC_OeoriBindBarCode
/// Input:		
/// Return:		
ClassMethod Delete(Params As %String) As %Library.String
{
	n (Params)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj
	s Obj=PJObj.%Pop()
	s RowId=Obj.%Get("RowId")
	s Dhcit=$p(^DHCOBB(RowId),"^",2)
	s HVBarCode=$p(^DHCIT(Dhcit),"^",2)
	s AckFlag=$p(^DHCOBB(RowId),"^",3)
	i AckFlag="Y" d RtnObj.Err(-2,RowId,HVBarCode_"已审核,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s CancelDate=$p(^DHCOBB(RowId),"^",10)
	i CancelDate'="" d RtnObj.Err(-3,RowId,HVBarCode_"已取消审核,不允许删除!","",0)
	q:RtnObj.success'=0 RtnObj.Json()

	ts
	&sql(delete from DHC_OeoriBindBarCode where %id=:RowId)
	i SQLCODE'=0 d RtnObj.Err(-4,RowId,HVBarCode_"删除失败!")
	i RtnObj.success'=0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	获取根据床位或床位类型滚出的医嘱子类Str(^隔开)
/// Creator:	wangjiabin
/// CreateDate:	2015-10-21
/// Table:		DHC_PAC_BedFeeItem(床位费用设置), DHC_PAC_BedTypeFeeItem(床位类型费用设置)
/// Input:		
/// Output:     
/// Return：	"":正确, 非空:错误信息
/// w ##class(web.DHCSTMHUI.OeoriBindBarcode).GetBedFeeArcicStr()
ClassMethod GetBedFeeArcicStr() As %Library.String
{
	new
	s ArcicStr=""
	
	k TMPArcicArr
	;DHC_PAC_BedFeeItem
	s BedId=0
	f  s BedId=$o(^PAWARD(BedId)) q:BedId=""  d
	.s BedCh=0
	.f  s BedCh=$o(^PAWARD(BedId,"BED",BedCh)) q:BedCh=""  d
	..s FeeCh=0
	..f  s FeeCh=$o(^PAWARD(BedId,"BED",BedCh,"FEE",FeeCh)) q:FeeCh=""  d
	...s Arcim=$p($g(^PAWARD(BedId,"BED",BedCh,"FEE",FeeCh)),"^",2)
	...s ArcimId=+Arcim,ArcimCh=$p(Arcim,"||",2)
	...q:(ArcimId="")||(ArcimCh="")
	...q:'$d(^ARCIM(ArcimId,ArcimCh))
	...s Arcic=$p($g(^ARCIM(ArcimId,ArcimCh,1)),"^",10)
	...q:Arcic=""
	...q:$d(TMPArcicArr(Arcic))
	...s TMPArcicArr(Arcic)=""
	...s ArcicStr=ArcicStr_"^"_Arcic
	
	;DHC_PAC_BedTypeFeeItem
	s BedTypeId=0
	f  s BedTypeId=$o(^PAC("BEDTP",BedTypeId)) q:BedTypeId=""  d
	.s BedTypeCh=0
	.f  s BedTypeCh=$o(^PAC("BEDTP",BedTypeId,"FEE",BedTypeCh)) q:BedTypeCh=""  d
	..s Arcim=$p($g(^PAC("BEDTP",BedTypeId,"FEE",BedTypeCh)),"^",2)
	..s ArcimId=+Arcim,ArcimCh=$p(Arcim,"||",2)
	..q:(ArcimId="")||(ArcimCh="")
	..q:'$d(^ARCIM(ArcimId,ArcimCh))
	..s Arcic=$p($g(^ARCIM(ArcimId,ArcimCh,1)),"^",10)
	..q:$d(TMPArcicArr(Arcic))
	..s TMPArcicArr(Arcic)=""
	..s ArcicStr=ArcicStr_"^"_Arcic
	
	i ArcicStr'="" s ArcicStr=ArcicStr_"^"
	k TMPArcicArr
	q ArcicStr
}

/// Description:取消审核医嘱高值条码绑定信息
/// Creator:	tsr
/// CreatDate:	2019-04-24
/// Table:		DHC_OeoriBindBarCode
ClassMethod CancelAudit(Params As %String, UserId As %String) As %Library.String
{
	n (Params,UserId)
	s RtnObj=##class(RtnObj).%New()
	s ParamsObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=ParamsObj.%FromJSON(Params)
	i Sc'=0 d RtnObj.Err(-1,"","入参解析失败!")
	q:RtnObj.success'=0 RtnObj.Json()

	s Obj=ParamsObj.%Pop()
	s RowId=Obj.%Get("RowId")
	i RowId="" d RtnObj.Err(-2,"","请选择需要取消审核的明细!","",0)
	q:RtnObj.success'=0 RtnObj.Json()

	s AckFlag=$p(^DHCOBB(RowId),"^",3)
	i AckFlag="N" d RtnObj.Err(-3,RowId,"已取消审核,无需再次取消审核!","",0)
	q:RtnObj.success'=0 RtnObj.Json()

	s Dhcit=$p(^DHCOBB(RowId),"^",2)
	s Oeori=$p(^DHCOBB(RowId),"^",1)
	s ifExitCancel=..IfExitCancelRecord(Dhcit,Oeori)
	i ifExitCancel'=0 d RtnObj.Err(-4,RowId,"已在医嘱中撤销,不能取消审核!","",0)
	q:RtnObj.success'=0 RtnObj.Json()

	s Date=+$h,Time=$p($h,",",2)
	s AckYes="N"
	s HVBarCode=$p(^DHCIT(Dhcit),"^",2)
	ts
	s result=##class(web.DHCSTMHUI.PCHCOLLSM).ReturnHVByDhcit(Oeori,Dhcit)
	i result'=0 d
	.d RtnObj.Err(-5,RowId,"取消审核失败!")
	.tro
	q:RtnObj.success'=0 RtnObj.Json()
	
	&sql(delete from DHC_HVMat_OrdItm where ORI_OEORI_DR=:Oeori and ORI_BarCode=:HVBarCode)
	i SQLCODE'=0 d
	.d RtnObj.Err(-7,RowId,"删除医嘱提取表失败!"_SQLCODE)
	.tro
	q:RtnObj.success'=0 RtnObj.Json()

	&sql(update DHC_OeoriBindBarCode set
	DHCOBB_AckFlag=:AckYes,DHCOBB_CancelDate=:Date,DHCOBB_CancelTime=:Time,DHCOBB_CancelSSUSR_DR=:UserId
	where %id=:RowId)
	i SQLCODE'=0 d
	.d RtnObj.Err(-6,RowId,"更新取消审核记录失败!"_SQLCODE)
	.tro
	q:RtnObj.success'=0 RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	判断某个条码在某个医嘱中是否撤销过
/// Creator:	lihui
/// CreateDate:	2017-08-29
/// Table :     DHC_OeoriBindBarCode,DHC_ItmTrackDetail
/// Input:		DHC_ItmTrack表ID,医嘱ID
/// Output:     
/// Return：	-1 存在；0不存在；	
/// w ##class(web.DHCSTMHUI.OeoriBindBarcode).IfExitCancelRecord(15674,)
ClassMethod IfExitCancelRecord(Dhcit As %String, Oeori As %String) As %Library.String
{
	n (Dhcit,Oeori)
	q:Dhcit="" 0
	q:Oeori="" 0
	s type="",chl="",ret=0,oeorid=""
	f  s chl=$o(^DHCITD(Dhcit,"I",chl)) q:((chl="")||(ret=-1))  d
	.q:'$d(^DHCITD(Dhcit,"I",chl))
	.s type=$p(^DHCITD(Dhcit,"I",chl),"^",2)
	.s pionter=$p(^DHCITD(Dhcit,"I",chl),"^",1)
	.s:(((type="Y")||(type="H"))&&(pionter=Oeori)) ret=-1
	q ret
}

}
