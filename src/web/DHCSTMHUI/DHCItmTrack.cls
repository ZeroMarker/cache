Import sqluser

/// Descript:高值跟踪
/// Creator:    wangjiabin
/// CreateDate: 2013-05-14
Class web.DHCSTMHUI.DHCItmTrack Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

Parameter AppName [ Final ] = "DHCITMTRACKM";

/// Description:入库审核保存入库单中高值材料条码信息等
/// Table:		dhc_itmtrack,dhc_itmtrackdetail
/// Input:		type(跟踪标志Reg,G,T,K,A,D,P,Y等), pointer(业务子表), label, operData(locId^userId^inci^incib^vendor^inclb),
/// Output:		RtnObj
ClassMethod Update(type As %String, pointer As %String, label As %String, operData As %String, rowid = "") As RtnObj
{
	n (type,pointer,label,operData,rowid,%session)
	s RtnObj=##class(RtnObj).%New()
	i ((rowid="")&&(label=""))||(type="")||(pointer="") q RtnObj.Err(-1,"","参数错误!")
	
	s loc=$p(operData,"^",1)
	s user=$p(operData,"^",2)
	s inci=$p(operData,"^",3)
	s incib=$p(operData,"^",4)
	s vendor=$p(operData,"^",5)
	s inclb=$p(operData,"^",6)
	i (incib="")&(inclb'="") d
	.s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
	i (inci="")&&(incib'="") d
	.s inci=$p(incib,"||",1)
	
	i rowid="" d
	.s rowid=$o(^DHCIT(0,"LABEL",label,""))
	.s:rowid="" rowid=$o(^DHCIT(0,"ORIGINALCODE",label,""))
	i rowid="" q RtnObj.Err(-10,"","rowid为空","",0)
	
	s obj=##class(User.DHCItmTrack).%OpenId(rowid)
	s OriginalStatus=obj.DHCITOriginalStatus
	s dhcitStatus=obj.DHCITStatus
	//批次码可多次入库且只处理入库状态
	q:(type="G")&&(dhcitStatus'="")&&(OriginalStatus'="NotUnique") RtnObj.Err(-9,rowid,"条码"_label_"已入库!","",0)
	s dhcitInci=$p(^DHCIT(rowid),"^",1)
	i (inci'="")&&(dhcitInci'=inci) d RtnObj.Err(-8,rowid,"条码与物资不符","",0) q
	
	//唯一码判断条件
	i OriginalStatus'="NotUnique" d
	.s lastCh=+$o(^DHCITD(rowid,"I",""),-1)
	.i lastCh>0 d
	..s lastChInfo=..IsDetailAudit(rowid_"||"_lastCh)
	..s isAudit=$p(lastChInfo,"^",1)
	..i ((isAudit'="Y")&&(OriginalStatus'="NotUnique")) d RtnObj.Err(-7,rowid,"有未审核的明细","",0) q
	.
	.i type="T" d
	..i dhcitStatus'="Enable" d RtnObj.Err(-21,rowid,"条码不可用:状态错误","",0) q
	..s dhcitInclb=obj.DHCITINCLBDRGetObjectId()
	..i dhcitInclb="" d RtnObj.Err(-22,rowid,"条码不可用:批次为空","",0) q
	..s Init=$p(pointer,"||",1),InitCh=$p(pointer,"||",2)
	..i (Init="")||(InitCh="") d RtnObj.Err(-22,rowid,"参数错误!","",0) q
	..s pointerInclb=$p(^DHCINIT(Init,"ITI",InitCh),"^",3)
	..;批次不一致的,过滤
	..i (pointerInclb'=dhcitInclb) d RtnObj.Err(-23,rowid,"数据错误:批次信息不一致","",0) q
	.e  i type="C" d
	..i dhcitStatus'="Enable" d RtnObj.Err(-21,rowid,"条码不可用:状态错误","",0) q
	.e  i type="L" d
	..i dhcitStatus'="InDisp" d RtnObj.Err(-21,rowid,"条码不是发放状态,不可退回!","",0) q
	q:RtnObj.success<0 RtnObj
	
	
	i type="G" d   ;入库时,修改供应商(因注册在前)
	.s obj.DHCITStatus="Enable"
	.d obj.DHCITAPCVMDRSetObjectId(vendor)
	e  i type="K" d
	.d obj.DHCITINCLBDRSetObjectId(inclb)
	
	//批次码管理的高值条码只处理入库状态
	i OriginalStatus'="NotUnique" d
	.i type="R" d   ;退货时,更新status
	..s obj.DHCITStatus="Return"
	.
	.e  i type="T" d
	..s obj.DHCITStatus="InIsTrf"	;出库中...
	.
	.e  i type="K" d   ;转移入库接收时,更新inclb
	..d obj.DHCITINCLBDRSetObjectId(inclb)
	..s obj.DHCITStatus="Enable"
	.
	.e  i (type="P")||(type="F")||(type="MP")||(type="MF") d  ;医嘱审核时,修改"已使用"状态
	..s obj.DHCITStatus="Used"
	.
	.e  i (type="Y")||(type="H")||(type="MY")||(type="MH") d  ;废除审核时,修改"可使用"状态
	..i OriginalStatus="Temp" d
	...s obj.DHCITStatus=OriginalStatus
	..e  d
	...s obj.DHCITStatus="Enable"
	.
	.e  i type="D" d  ;报损时,更新status
	..s obj.DHCITStatus="InScrap"
	.
	.e  i type="A" d  ;报损时,更新status
	..s obj.DHCITStatus="InAdj"
	..i inclb'="" d obj.DHCITINCLBDRSetObjectId(inclb)
	.
	.i type="C" d  ;发放时,更新status
	..s:OriginalStatus'="NotUnique" obj.DHCITStatus="InDisp"
	.
	.i type="L" d  ;发放退回
	..s:OriginalStatus'="NotUnique" obj.DHCITStatus="Enable"
	s sc=obj.%Save()
	i $$$ISERR(sc) d RtnObj.Err(-5,rowid,"跟踪信息保存失败") q
	
	s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).Save(rowid,type,pointer,user)
	q:RtnObj.success<0 RtnObj
	
	q RtnObj
}

/// 根据dhc_itmtrack主表rowid取当前位置信息(科室或患者)
/// 取最后一条有效记录
/// 2015-05-07: P,F时为患者,其他取科室
ClassMethod GetTypeLoc(dhcit As %String) As %String
{
	n (dhcit,%session)
	s lastCh=$$GetValidLastCh(dhcit)
	i lastCh="" s loc=$p(^DHCIT(dhcit),"^",26)
	q:lastCh="" "^"_loc_"^^"
	s type=$p(^DHCITD(dhcit,"I",lastCh),"^",2)
	s pointer=$p(^DHCITD(dhcit,"I",lastCh),"^",1)

	s loc="",currentLoc=""
	i type="G" d
	.s loc=$p($g(^DHCINGR(+pointer)),"^",13)
	e  i type="T" d
	.s loc=$p($g(^DHCINIT(+pointer)),"^",5)
	e  i type="K" d
	.s loc=$p($g(^DHCINIT(+pointer)),"^",6)
	e  i type="R" d
	.s loc=$p($g(^INGRT(+pointer)),"^",7)
	e  i type="A" d
	.s loc=$p($g(^DHCINAD(+pointer)),"^",16)
	e  i type="D" d
	.s loc=$p($g(^DHCINSP(+pointer)),"^",5)
	e  i (type="P")||(type="F")||(type="MP")||(type="MF") d
	.s loc=""				;医嘱已消耗,当前科室不再传值
	.s (paNo,paName)=""
	.&sql(select oeord_adm_dr->paadm_papmi_dr->papmi_no,oeord_adm_dr->paadm_papmi_dr->papmi_name
		into :paNo,:paName from oe_order where %id=+:pointer)
	.s currentLoc=paNo_", "_paName
	e  i (type="Y")||(type="H") d
	.s loc=$p($g(^OEORD(+pointer,"I",$p(pointer,"||",2),3)),"^",6)

	s:(currentLoc="")&&(loc'="") currentLoc=$p($g(^CTLOC(loc)),"^",2),currentLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(currentLoc)

	s lastDate=$p(^DHCITD(dhcit,"I",lastCh),"^",3)

	q type_"^"_loc_"^"_currentLoc_"^"_lastDate

GetValidLastCh(dhcit)
	s isOK="",LastCh=""
	s childSub=""
	f  s childSub=$o(^DHCITD(dhcit,"I",childSub),-1) q:(childSub="")||(isOK="Y")  d
	.s:childSub="" isOK="Y"
	.q:childSub=""
	.s type=$p(^DHCITD(dhcit,"I",childSub),"^",2)
	.s pointer=$p(^DHCITD(dhcit,"I",childSub),"^",1)
	.s rowid=+pointer,ch=$p(pointer,"||",2)
	.q:(rowid="")||(ch="")
	.s isData=1
	.i type="G" d
	..s isData=$d(^DHCINGR(rowid,"GRI",ch))
	.e  i (type="T")||(type="K") d
	..s isData=$d(^DHCINIT(rowid,"ITI",ch))
	.e  i type="R" d
	..s isData=$d(^INGRT(rowid,"DHCGRR",ch))
	.e  i type="D" d
	..s isData=$d(^DHCINSP(rowid,"I",ch))
	.e  i type="A" d
	..s isData=$d(^DHCINAD(rowid,"ADI",ch))
	.e  i (type="P")||(type="Y")||(type="F")||(type="H")||(type="MP")||(type="MY")||(type="MF")||(type="MH") d
	..s isData=$d(^OEORD(rowid,"I",ch))
	.s:isData LastCh=childSub,isOK="Y"
	
	q LastCh
}

/// 打印明细取值添加query函数
/// 2013-06-24
/// d ##Class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCItmTrack","Query",^tempxj)
Query Query(Params As %String) As Query(ROWSPEC = "RowId,InciId,InciCode,InciDesc,Spec,UomDesc,BarCode,Incib,BatExp,CurrentLoc,Status,DhcitDate,DhcitTime,DhcitUser,VendorDesc,DateTime,OriginalCode,ManfId,ManfDesc,Rp:%Float,SpecDesc,PrintFlag,BatNo,ExpDate,RetOriFlag,BatchCode,UsedPatInfo,UsedDateTime") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s gLocId=PJobj.%Get("gLocId")
	s gHospId=PJobj.%Get("gHospId")
	s pHospId=##class(web.DHCSTMHUI.MatForBDPData).GetBDPHospId("",gHospId)
	
	s PVendor=PJobj.%Get("Vendor")
	s PStartDate=PJobj.%Get("StartDate")
	s PEndDate=PJobj.%Get("EndDate")
	s POriginalCode=PJobj.%Get("OrgianlBarCode")
	s PStatus=PJobj.%Get("Status")
	s PDateFlag=PJobj.%Get("DateFlag")		// "":不考虑, 1-按注册日期, 2-按医嘱日期
	
	s PPapmiNo=PJobj.%Get("wardno")
	s PCurrPhaLoc=PJobj.%Get("LocId")
	s PBatchNo=PJobj.%Get("BatchNo")
	s PPrintStatus=PJobj.%Get("PrintStatus")
	s PInciId=PJobj.%Get("InciId")
	s PInciDesc=PJobj.%Get("InciDesc")
	s PSluggishFlag=PJobj.%Get("outed")
	s PSluggishGap=PJobj.%Get("DayNum")
	s PBarCode=PJobj.%Get("BarCode")
	s PBatchCode=PJobj.%Get("BatchCode")
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	q:PEndDate<PStartDate $$$OK
	
	s hvm="",oeori="",labels="'"_PBarCode_"'"
	i PBarCode'="" d
	.s hvm=$O(^DHCHVMORI(0,"BARCODE",PBarCode,""),-1)
	.s:hvm'="" oeori=$p(^DHCHVMORI(hvm,1),"^",1)
	s hvm=""
	i oeori'="" d
	.f  s hvm=$O(^DHCHVMORI(0,"OEORI",oeori,hvm)) q:hvm=""  d
	..s barcode=$p(^DHCHVMORI(hvm,1),"^",24)
	..q:barcode=PBarCode
	..s labels=labels_",'"_barcode_"'"

	s dhcitStr=""
	i PPapmiNo'="" d
	.s papmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PPapmiNo),0))
	.q:papmi=""
	.s process=""
	.f  s process=$o(^PAPRi("PAPMI",papmi,process)) q:process=""  d
	..s paadm=0
	..f  s paadm=$o(^PAPRi("PAPMI",papmi,process,paadm)) q:paadm=""  d
	...s oeord=0
	...f  s oeord=$o(^OEORD(0,"Adm",paadm,oeord)) q:oeord=""  d
	....s ch=0
	....f  s ch=$o(^OEORD(oeord,"I",ch)) q:ch=""  d
	.....s oeori=oeord_"||"_ch
	.....s dhcitId=0
	.....f  s dhcitId=$o(^DHCITD(0,"Type","MP","Pointer",oeori,dhcitId)) q:dhcitId=""  d
	......i dhcitStr="" d
	.......s dhcitStr=dhcitId
	......e  d
	.......s dhcitStr=dhcitStr_","_dhcitId
	.....
	.....s dhcitId=0
	.....f  s dhcitId=$o(^DHCITD(0,"Type","MF","Pointer",oeori,dhcitId)) q:dhcitId=""  d
	......i dhcitStr="" d
	.......s dhcitStr=dhcitId
	......e  d
	.......s dhcitStr=dhcitStr_","_dhcitId
	;传入登记号,且找不到记录的,退出
	q:(PPapmiNo'="")&&(dhcitStr="") $$$OK
	
	s sqlStr="select DHCIT_Rowid RowId,DHCIT_INCI_DR InciId,DHCIT_INCI_DR->INCI_Code InciCode,DHCIT_INCI_DR->INCI_Desc InciDesc,"
			_"DHCIT_Label BarCode,DHCIT_Status Status,DHCIT_INCIB_DR Incib,DHCIT_Date DhcitDate,DHCIT_Time DhcitTime,"
			_"DHCIT_SSUSR_DR->SSUSR_Name DhcitUser,DHCIT_APCVM_DR->APCVM_Name VendorDesc,DHCIT_INCLB_DR Inclb,DHCIT_OriginalCode OriginalCode,"
			_"DHCIT_BatchNo BatchNo,DHCIT_ExpDate ExpDate,DHCIT_SpecList SpecDesc,DHCIT_PrintFlag PrintFlag,DHCIT_PHMNF_DR,DHCIT_BatchCode BatchCode"
			_" from DHC_ItmTrack where 1=1"
	i (PDateFlag="1")&&(PStartDate'="")&&(PEndDate'="") d
	.s sqlStr=sqlStr_" and DHCIT_Date between "_PStartDate_" and "_PEndDate
	i PBarCode'="" d
	.s sqlStr=sqlStr_" and DHCIT_Label in ("_labels_")"
	i PVendor'="" d
	.s sqlStr=sqlStr_" and DHCIT_APCVM_DR='"_PVendor_"'"
	i dhcitStr'="" d
	.s sqlStr=sqlStr_" and %id in ("_dhcitStr_")"
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	s result.RuntimeMode=0
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(result.Next())
	{
		s RowId=result.Data("RowId")
		s DhcitDate=result.Data("DhcitDate")
		;continue:(PDateFlag="1")&&(PStartDate'="")&&(DhcitDate<PStartDate)
		;continue:(PDateFlag="1")&&(PEndDate'="")&&(DhcitDate>PEndDate)
		s InciId=result.Data("InciId")
		s BarCode=result.Data("BarCode")
		s Status=result.Data("Status")
		s OriginalStatus=$p(^DHCIT(RowId),"^",35)
		i (PStatus'="")&&(OriginalStatus'="NotUnique") {
			continue:(PStatus="Reg")&&(Status'="")
			continue:((PStatus="Enable")||(PStatus="Used"))&&(Status'=PStatus)
			continue:(PStatus="Else")&&((Status="")||(Status="Reg")||(Status="Enable")||(Status="Used"))
		}
		i (PStatus'="")&&(OriginalStatus="NotUnique") {
			;获取有几类特殊状态(如Used,Return等)
			s StatusStr=..GetBatchStatus(RowId)
			continue:(PStatus="Reg")&&(Status'="")
			;continue:(PStatus="Enable")&&(StatusStr'["Enable")		;Enable要判断个数,不好控制
			continue:(PStatus="Used")&&(StatusStr'["Used")
			continue:(PStatus="Else")&&'((StatusStr["Inadj")||(StatusStr["Inscrap")||(StatusStr["Return"))
		}
		
		s typeLoc=..GetTypeLoc(RowId)
		s CurrentLocId=$p(typeLoc,"^",2)
		
		s Inclb=result.Data("Inclb")
		;当前科室按照inclb取值进行过滤
		i Inclb'="" d
		.s CurrentLocId=$p(^INCI($p(Inclb,"||",1),"IL",$p(Inclb,"||",2)),"^",1)
		s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(InciId)
		i (TableFlag="Y")&&(CurrentLocId="") d
		.s orireclocid=..GetRecLocByBarcode(BarCode)
		.i orireclocid'="" s CurrentLocId=orireclocid
		continue:(PCurrPhaLoc'="")&&(CurrentLocId'=PCurrPhaLoc)
		continue:##class(web.DHCSTMHUI.CTLOC).LocOfHosp(CurrentLocId,pHospId)'=0
		s CurrentLoc=$s(CurrentLocId'="":$p(^CTLOC(CurrentLocId),"^",2),1:"")
		s CurrentLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(CurrentLoc)
		
		
		s BatchCode=result.Data("BatchCode")
		continue:(PBatchCode'="")&&(PBatchCode'=BatchCode)
		s OriginalCode=result.Data("OriginalCode")
		s OldOriginalCode=$p(^DHCIT(RowId),"^",30)
		continue:(POriginalCode'="")&&((OriginalCode'[POriginalCode)&&(OldOriginalCode'[POriginalCode))
		s hvm=$o(^DHCHVMORI(0,"BARCODE",BarCode,""),-1)
		s:(hvm="")&&(OriginalCode'="") hvm=$o(^DHCHVMORI(0,"BARCODE",OriginalCode,""),-1)
		s ordate=$s(hvm'="":$p(^DHCHVMORI(hvm,1),"^",2),1:"")
		continue:(PDateFlag="2")&&(PStartDate'="")&&(ordate<PStartDate)
		continue:(PDateFlag="2")&&(PEndDate'="")&&(ordate>PEndDate)
		
		s lastDate=$p(typeLoc,"^",4)
		;最后一条跟踪信息早于+$h特定天数的,认为是呆滞(同时,呆滞仅查询可用的)
		i ((PSluggishFlag="Y")&&(+PSluggishGap>0)) {
			continue:(status'="Enable")||(lastDate="")||((+$h-lastDate)<=PSluggishGap)
		}
		
		continue:(InciId="")||'$d(^INCI(InciId))
		continue:(PInciId'="")&&(InciId'=PInciId)
		s InciCode=result.Data("InciCode")
		s InciDesc=result.Data("InciDesc")
		continue:(PInciId="")&&(PInciDesc'="")&&(InciDesc'[PInciDesc)
		
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s UomDesc=$p($g(^CT("UOM",BUomId)),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		
		s Incib=result.Data("Incib")
		s DhcitDate=..DL2H(DhcitDate)
		s DhcitTime=result.Data("DhcitTime")
		s DhcitTime=..TL2H(DhcitTime)
		s DateTime=DhcitDate_" "_DhcitTime
		s DhcitUser=result.Data("DhcitUser")
		s VendorDesc=result.Data("VendorDesc")
		
		s (BatExp,BatNo,ExpDate,ManfId,ManfDesc,Rp,SpecDesc)=""
		i Incib'="" d
		.s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
		.s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
		.s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		.s BatExp=BatNo_"~"_ExpDate
		.s dhcincib=$o(^DHCINCIB(0,"INCIB",Incib,""))
		.i dhcincib'="" d
		..s ManfId=$p(^DHCINCIB(dhcincib),"^",7)
		..s:ManfId'="" ManfDesc=$p(^PHMNF(ManfId),"^",2)
		..s Rp=$p(^DHCINCIB(dhcincib),"^",3)
		..s SpecDesc=$p(^DHCINCIB(dhcincib),"^",13)
		e  d
		.;incib不存在的时候,批号效期取值
		.s BatNo=result.Data("BatchNo")
		.s ExpDate=result.Data("ExpDate")
		.s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		.s BatExp=BatNo_"~"_ExpDate
		.s SpecDesc=result.Data("SpecDesc")
		.s ManfId=result.Data("DHCIT_PHMNF_DR")
		.s:ManfId'="" ManfDesc=$p(^PHMNF(ManfId),"^",2)
		.s Rp=$p(^DHCIT(RowId),"^",16)
		.s SpecDesc=result.Data("SpecDesc")
		continue:(PBatchNo'="")&&(BatNo'[PBatchNo)
		s PrintFlag=result.Data("PrintFlag")
		continue:(PPrintStatus="Y")&&(PrintFlag'="Y")
		continue:(PPrintStatus="N")&&(PrintFlag="Y")
		s RetOriFlag=$s(hvm'="":$p($G(^DHCHVMORI(hvm,2)),"^",22),1:"N")
		s:RetOriFlag="" RetOriFlag="N"
		s UsedPatStr=..GetPatientInfo(RowId)
		s UsedPatInfo=$p(UsedPatStr,"^",1)
		s UsedDateTime=$p(UsedPatStr,"^",2)
		d OutPutRowItmTrack
	}
	Quit $$$OK

OutPutRowItmTrack
	s Data=$lb(RowId,InciId,InciCode,InciDesc,Spec,
		UomDesc,BarCode,Incib,BatExp,CurrentLoc,
		Status,DhcitDate,DhcitTime,DhcitUser,VendorDesc,
		DateTime,OriginalCode,ManfId,ManfDesc,Rp,
		SpecDesc,PrintFlag,BatNo,ExpDate,RetOriFlag,
		BatchCode,UsedPatInfo,UsedDateTime)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 这里的排序功能需要加强
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCItmTrack","QueryItmTrackItem","441")
Query QueryItmTrackItem(Parref As %String) As Query(ROWSPEC = "RowId,Pointer,Type,OperNo,Date,Time,User,OperOrg,IntrFlag,IntrQty:%Float") [ SqlProc ]
{
}

ClassMethod QueryItmTrackItemExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle, Parref,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s (PoItmId,PPItmId,ReqItmId)=""
	s PoItmId=$p(^DHCIT(Parref),"^",14)
	s (IntrFlag,IntrQty)=""
	i PoItmId'="" d
	.s Rowid = PoItmId
	.s Pointer = PoItmId
	.s main=+Pointer
	.s Type = "POD"
	.s OperNoInfo=..GetOperNo(Type,Pointer)
	.s OperNo=$p(OperNoInfo,"^",1)
	.s OperOrg = $p(OperNoInfo,"^",2)
	.s Date = $p(^INPO(main),"^",3)
	.s:Date'="" Date=..DL2H(Date)
	.s Time =""
	.s:Time'="" Time=..TL2H(Time)
	.s User = $p(^INPO(main),"^",7)
	.s:User'="" User=$p(^SSU("SSUSR",User),"^",2)
	.s tmp=Rowid_"^"_Pointer_"^"_Type_"^"_OperNo_"^"_Date_"^"_Time_"^"_User_"^"_OperOrg
	.d OutPutRowItmTrackS
	.&sql(select INPPI_Rowid into :PPItmId from IN_PURPLANITM where INPPI_INPOI_DR=:Pointer)
	i PPItmId'="" d
	.s Rowid = PPItmId
	.s Pointer = PPItmId
	.s main=+Pointer
	.s Type = "PD"
	.s OperNoInfo=..GetOperNo(Type,Pointer)
	.s OperNo=$p(OperNoInfo,"^",1)
	.s OperOrg = $p(OperNoInfo,"^",2)
	.s Date = $p(^INPP(main),"^",2)
	.s:Date'="" Date=..DL2H(Date)
	.s Time = $p(^INPP(main),"^",9)
	.s:Time'="" Time=..TL2H(Time)
	.s User = $p(^INPP(main),"^",3)
	.s:User'="" User=$p(^SSU("SSUSR",User),"^",2)
	.s tmp=Rowid_"^"_Pointer_"^"_Type_"^"_OperNo_"^"_Date_"^"_Time_"^"_User_"^"_OperOrg
	.d OutPutRowItmTrackS
	.&sql(select PPREQI_REQITM_DR into :ReqItmId from DHC_INPPReqItm where PPREQI_INPPI_Parref=:Pointer)
	i ReqItmId'="" d
	.s Rowid = ReqItmId
	.s Pointer = ReqItmId
	.s main=+Pointer
	.s Type = "RD"
	.s OperNoInfo=..GetOperNo(Type,Pointer)
	.s OperNo=$p(OperNoInfo,"^",1)
	.s OperOrg = $p(OperNoInfo,"^",2)	;业务机构信息(科室或患者)
	.s Date = $p(^INRQ(main),"^",2)
	.s:Date'="" Date=..DL2H(Date)
	.s Time = $p(^INRQ(main),"^",3)
	.s:Time'="" Time=..TL2H(Time)
	.s User = $p(^INRQ(main),"^",4)
	.s:User'="" User=$p(^SSU("SSUSR",User),"^",2)
	.s tmp=Rowid_"^"_Pointer_"^"_Type_"^"_OperNo_"^"_Date_"^"_Time_"^"_User_"^"_OperOrg
	.d OutPutRowItmTrackS
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s sqlStr = "SELECT DHCITD_Rowid as Rowid,DHCITD_ChildSub as Ch,DHCITD_Pointer as Pointer,DHCITD_Type as Type,"_
		"DHCITD_Date,DHCITD_Time,DHCITD_SSUSR_DR"_
		" FROM dhc_itmtrackdetail where DHCITD_Parref = "_Parref
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s Rowid = result.Data("Rowid")
		s Ch = result.Data("Ch")
		s Pointer = result.Data("Pointer")
		s Type = result.Data("Type")
		s Type=$s(Type="SG":"G",Type="ST":"T",Type="SK":"K",Type="SR":"R",Type="SP":"P",Type="SY":"Y",1:Type)		;2018-03-22 补录内容
		
		s OperNoInfo=..GetOperNo(Type,Pointer)
		s OperNo = $p(OperNoInfo,"^",1)
		s OperOrg = $p(OperNoInfo,"^",2)	;业务机构信息(科室或患者)
		s IntrFlag=$p(OperNoInfo,"^",3)
		s IntrQty=$p(OperNoInfo,"^",4)
		;continue:(OperNo="")&&(OperOrg="")
		s Date = result.Data("DHCITD_Date")
		s:Date'="" Date=..DL2H(Date)
		s Time = result.Data("DHCITD_Time")
		s:Time'="" Time=..TL2H(Time)
		s User = result.Data("DHCITD_SSUSR_DR")
		s:User'="" User=$p($g(^SSU("SSUSR",User)),"^",2)
		i (Type="MY")||(Type="MH") d
		.s oeorich=$p(Pointer,"||",2)
		.s StopUser=$p(^OEORD(+Pointer,"I",oeorich,3),"^",29)
		.s:+StopUser>0 User=$P(^CTPCP(StopUser,1),"^",2)
		s tmp=Rowid_"^"_Pointer_"^"_Type_"^"_OperNo_"^"_Date
			_"^"_Time_"^"_User_"^"_OperOrg_"^"_IntrFlag_"^"_IntrQty
		d OutPutRowItmTrackS
		
		;补录信息(附加表)
		s dhcitda=0,cnt=0
		f  s dhcitda=$o(^DHCITD(0,"DHCITD",Rowid,dhcitda)) q:dhcitda=""  d
		.s cnt=cnt+1
		.s sortCh=Ch+(cnt*0.01)
		.s dhcitdaInfo=^DHCITD("IA",dhcitda)
		.s Pointer=$p(dhcitdaInfo,"^",1)
		.s Type=$p(dhcitdaInfo,"^",2)
		.s Date=$p(dhcitdaInfo,"^",3)
		.s Time=$p(dhcitdaInfo,"^",4)
		.s User=$p(dhcitdaInfo,"^",5)
		.s:Date'="" Date=..DL2H(Date)
		.s:Time'="" Time=..TL2H(Time)
		.s:User'="" User=$p($g(^SSU("SSUSR",User)),"^",2)
		.s intrType=$s(Type="SG":"G",Type="ST":"T",Type="SK":"K",Type="SR":"R",Type="SP":"P",1:Type)
		.q:'$d(^DHCINTR(0,"TypePointer",intrType,Pointer))
		.s OperNoInfo=..GetOperNo(intrType,Pointer)
		.s OperNo=$p(OperNoInfo,"^",1)
		.s OperOrg=$p(OperNoInfo,"^",2)
		.s IntrFlag=$p(OperNoInfo,"^",3)
		.s IntrQty=$p(OperNoInfo,"^",4)
		.
		.s Data=$lb(dhcitda,Pointer,Type,OperNo,Date,Time,User,OperOrg,IntrFlag,IntrQty)
		.s ^CacheTemp(repid,ind)=Data
		.s ind=ind+1
	}
	d result.Close()
	
	Quit $$$OK
	
OutPutRowItmTrackS
	s Data=$lb(Rowid,Pointer,Type,OperNo,Date,Time,User,OperOrg,IntrFlag,IntrQty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// 查询高值材料明细
ClassMethod QueryItem(Start As %String, Limit As %String, Sort As %String, Dir As %String, Parref As %String) As %String
{
	n (Start,Limit,Sort,Dir,Parref,%session)
	q:Parref="" ""
	s pid=..NewPid()
	k ^TMP("DHCSTM.DHCItmTrack",pid)
	
	s (PoItmId,PPItmId,ReqItmId)=""
	s PoItmId=$p(^DHCIT(Parref),"^",14)
	i PoItmId'="" d
	.s Rowid = PoItmId
	.s Pointer = PoItmId
	.s main=+Pointer
	.s Type = "POD"
	.s OperNoInfo=..GetOperNo(Type,Pointer)
	.s OperNo=$p(OperNoInfo,"^",1)
	.s OperOrg = $p(OperNoInfo,"^",2)
	.s Date = $p(^INPO(main),"^",3)
	.s:Date'="" Date=..DL2H(Date)
	.s Time =""
	.s:Time'="" Time=..TL2H(Time)
	.s User = $p(^INPO(main),"^",7)
	.s:User'="" User=$p(^SSU("SSUSR",User),"^",2)
	.s tmp=Rowid_"^"_Pointer_"^"_Type_"^"_OperNo_"^"_Date_"^"_Time_"^"_User_"^"_OperOrg
	.s ^TMP("DHCSTM.DHCItmTrack",pid,-10)=tmp
	.&sql(select INPPI_Rowid into :PPItmId from IN_PURPLANITM where INPPI_INPOI_DR=:Pointer)
	i PPItmId'="" d
	.s Rowid = PPItmId
	.s Pointer = PPItmId
	.s main=+Pointer
	.s Type = "PD"
	.s OperNoInfo=..GetOperNo(Type,Pointer)
	.s OperNo=$p(OperNoInfo,"^",1)
	.s OperOrg = $p(OperNoInfo,"^",2)
	.s Date = $p(^INPP(main),"^",2)
	.s:Date'="" Date=..DL2H(Date)
	.s Time = $p(^INPP(main),"^",9)
	.s:Time'="" Time=..TL2H(Time)
	.s User = $p(^INPP(main),"^",3)
	.s:User'="" User=$p(^SSU("SSUSR",User),"^",2)
	.s tmp=Rowid_"^"_Pointer_"^"_Type_"^"_OperNo_"^"_Date_"^"_Time_"^"_User_"^"_OperOrg
	.s ^TMP("DHCSTM.DHCItmTrack",pid,-20)=tmp
	.&sql(select PPREQI_REQITM_DR into :ReqItmId from DHC_INPPReqItm where PPREQI_INPPI_Parref=:Pointer)
	i ReqItmId'="" d
	.s Rowid = ReqItmId
	.s Pointer = ReqItmId
	.s main=+Pointer
	.s Type = "RD"
	.s OperNoInfo=..GetOperNo(Type,Pointer)
	.s OperNo=$p(OperNoInfo,"^",1)
	.s OperOrg = $p(OperNoInfo,"^",2)	;业务机构信息(科室或患者)
	.s Date = $p(^INRQ(main),"^",2)
	.s:Date'="" Date=..DL2H(Date)
	.s Time = $p(^INRQ(main),"^",3)
	.s:Time'="" Time=..TL2H(Time)
	.s User = $p(^INRQ(main),"^",4)
	.s:User'="" User=$p(^SSU("SSUSR",User),"^",2)
	.s tmp=Rowid_"^"_Pointer_"^"_Type_"^"_OperNo_"^"_Date_"^"_Time_"^"_User_"^"_OperOrg
	.s ^TMP("DHCSTM.DHCItmTrack",pid,-30)=tmp

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT DHCITD_Rowid as Rowid,DHCITD_ChildSub as Ch,DHCITD_Pointer as Pointer,DHCITD_Type as Type,"_
		"DHCITD_Date,DHCITD_Time,DHCITD_SSUSR_DR"_
		" FROM dhc_itmtrackdetail where DHCITD_Parref = "_Parref
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s Rowid = result.Data("Rowid")
		s Ch = result.Data("Ch")
		s Pointer = result.Data("Pointer")
		s Type = result.Data("Type")
		s Type=$s(Type="SG":"G",Type="ST":"T",Type="SK":"K",Type="SR":"R",Type="SP":"P",Type="SY":"Y",1:Type)		;2018-03-22 补录内容
		s OperNoInfo=..GetOperNo(Type,Pointer)
		s OperNo = $p(OperNoInfo,"^",1)
		s OperOrg = $p(OperNoInfo,"^",2)	;业务机构信息(科室或患者)
		s IntrFlag=$p(OperNoInfo,"^",3)
		continue:(OperNo="")&&(OperOrg="")
		s Date = result.Data("DHCITD_Date")
		s:Date'="" Date=..DL2H(Date)
		s Time = result.Data("DHCITD_Time")
		s:Time'="" Time=..TL2H(Time)
		s User = result.Data("DHCITD_SSUSR_DR")
		s:User'="" User=$p($g(^SSU("SSUSR",User)),"^",2)
		s tmp=Rowid_"^"_Pointer_"^"_Type_"^"_OperNo_"^"_Date
			_"^"_Time_"^"_User_"^"_OperOrg_"^"_IntrFlag
		s ^TMP("DHCSTM.DHCItmTrack",pid,Ch)=tmp
		d GetItmTrackDetailAddion(Rowid,pid)
	}
	d result.Close()
	
	s count = 0
	s End = Start+Limit
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
	s:Dir="" Dir="ASC"
	s DirFlag=$s(Dir="ASC":1,1:-1)
	s sub=""
	f  s sub=$o(^TMP("DHCSTM.DHCItmTrack",pid,sub),DirFlag) q:sub=""  d
	.s count=count+1
	.q:(count<(Start+1))||(count>End)
	.s str=^TMP("DHCSTM.DHCItmTrack",pid,sub)
	.d json.InsertRowData(str)
	d json.getJsonData("RowId^Pointer^Type^OperNo^Date^Time^User^OperOrg^IntrFlag",count)
	k json
	k ^TMP("DHCSTM.DHCItmTrack",pid)

GetItmTrackDetailAddion(dhcitd,pid)
	n (dhcitd,pid,%session)
	q:dhcitd=""
	s ch=$p(dhcitd,"||",2)
	s dhcitda=0,cnt=0
	f  s dhcitda=$o(^DHCITD(0,"DHCITD",dhcitd,dhcitda)) q:dhcitda=""  d
	.s cnt=cnt+1
	.;按此规则,方便排序
	.s sortCh=ch+(cnt*0.01)
	.s dhcitdaInfo=^DHCITD("IA",dhcitda)
	.s Pointer=$p(dhcitdaInfo,"^",1)
	.s Type=$p(dhcitdaInfo,"^",2)
	.s Date=$p(dhcitdaInfo,"^",3)
	.s Time=$p(dhcitdaInfo,"^",4)
	.s User=$p(dhcitdaInfo,"^",5)
	.s:Date'="" Date=..DL2H(Date)
	.s:Time'="" Time=..TL2H(Time)
	.s:User'="" User=$p($g(^SSU("SSUSR",User)),"^",2)
	.
	.s intrType=$s(Type="SG":"G",Type="ST":"T",Type="SK":"K",Type="SR":"R",Type="SP":"P",1:Type)
	.q:'$d(^DHCINTR(0,"TypePointer",intrType,Pointer))
	.s OperNoInfo=..GetOperNo(intrType,Pointer)
	.s OperNo=$p(OperNoInfo,"^",1)
	.s OperOrg=$p(OperNoInfo,"^",2)
	.s IntrFlag=$p(OperNoInfo,"^",3)
	.s str1=dhcitda_"^"_Pointer_"^"_Type_"^"_OperNo_"^"_Date
	.s str2=Time_"^"_User_"^"_OperOrg_"^"_IntrFlag
	.s str=str1_"^"_str2
	.s ^TMP("DHCSTM.DHCItmTrack",pid,sortCh)=str
	
	q
}

/// 取处理号,业务单位等信息
/// Return: 业务单号(医嘱显示就诊号和患者姓名)^业务单位(科室或患者)^台帐标记(Y/N)^台账数量
ClassMethod GetOperNo(type, pointer) As %String
{
	n (type,pointer,%session)
	q:(type="")||(pointer="") ""
	s main=+pointer
	s operNo="",operOrgId="",operOrg=""
	i type="G" d
	.s operNo=$p(^DHCINGR(main),"^",1)
	.s operOrgId=$p(^DHCINGR(main),"^",13)
	.s:operOrgId'="" operOrg=$p($g(^CTLOC(operOrgId)),"^",2),operOrg=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(operOrg)
	e  i type="R" d
	.s operNo=$p(^INGRT(main),"^",1)
	.s operOrgId=$p(^INGRT(main),"^",7)
	.s:operOrgId'="" operOrg=$p($g(^CTLOC(operOrgId)),"^",2),operOrg=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(operOrg)
	e  i type="T" d
	.s operNo=$p(^DHCINIT(main),"^",1)
	.s operOrgId=$p(^DHCINIT(main),"^",5)
	.s:operOrgId'="" operOrg=$p($g(^CTLOC(operOrgId)),"^",2),operOrg=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(operOrg)
	e  i type="K" d
	.s operNo=$p(^DHCINIT(main),"^",1)
	.s operOrgId=$p(^DHCINIT(main),"^",6)
	.s:operOrgId'="" operOrg=$p($g(^CTLOC(operOrgId)),"^",2),operOrg=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(operOrg)
	e  i type="A" d
	.s operNo=$p(^DHCINAD(main),"^",1)
	.s operOrgId=$p(^DHCINAD(main),"^",16)
	.s:operOrgId'="" operOrg=$p($g(^CTLOC(operOrgId)),"^",2),operOrg=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(operOrg)
	e  i type="D" d
	.s operNo=$p(^DHCINSP(main),"^",1)
	.s operOrgId=$p(^DHCINSP(main),"^",5)
	.s:operOrgId'="" operOrg=$p($g(^CTLOC(operOrgId)),"^",2),operOrg=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(operOrg)
	e  i (type="P")||(type="F")||(type="MP")||(type="MF")  d
	.&sql(select OEORI_OEORD_ParRef->OEORD_Adm_DR->PAADM_ADMNo,oeori_oeord_parref->oeord_adm_dr->paadm_papmi_dr->papmi_no,oeori_oeord_parref->oeord_adm_dr->paadm_papmi_dr->papmi_name
		into :operNo,:paNo,:paName from oe_orditem where %id=:pointer)
	.q:SQLCODE
	.s operOrg=paNo_", "_paName
	e  i (type="Y")||(type="H")||(type="MY")||(type="MH")||(type="SMY")||(type="SMH") d
	.s adm=$p($g(^OEORD(+pointer)),"^",1)
	.s:adm'="" operNo=$p($g(^PAADM(adm)),"^",81)
	.s operOrgId=$p($g(^OEORD(+pointer,"I",$p(pointer,"||",2),3)),"^",6)
	.s:operOrgId'="" operOrg=$p($g(^CTLOC(operOrgId)),"^",2),operOrg=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(operOrg)
	e  i type="RD"  d
	.s operNo=$p(^INRQ(main),"^",1)
	.s operOrgId=$p(^INRQ(main),"^",6)
	.s:operOrgId'="" operOrg=$p($g(^CTLOC(operOrgId)),"^",2),operOrg=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(operOrg)
	e  i type="PD" d
	.s operNo=$p(^INPP(main),"^",1)
	.s operOrgId=$p(^INPP(main),"^",7)
	.s:operOrgId'="" operOrg=$p($g(^CTLOC(operOrgId)),"^",2),operOrg=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(operOrg)
	e  i type="POD" d
	.s operNo=$p(^INPO(main),"^",1)
	.s dhcpoid=$o(^DHCINPO(0,"INPO",main,0))
	.i dhcpoid'="" s operOrgId=$p(^DHCINPO(dhcpoid),"^",2)
	.s:operOrgId'="" operOrg=$p($g(^CTLOC(operOrgId)),"^",2),operOrg=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(operOrg)
	e  i type="C" d
	.s operNo=$p(^DHCINDS(main),"^",1)
	.s operOrgId=$p(^DHCINDS(main),"^",22)
	.s:operOrgId'="" operOrg=$p($g(^CTLOC(operOrgId)),"^",2),operOrg=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(operOrg)
	e  i type="L" d
	.s operNo=$p(^DHCINDSR(main),"^",1)
	.s operOrgId=$p(^DHCINDSR(main),"^",13)
	.s:operOrgId'="" operOrg=$p($g(^CTLOC(operOrgId)),"^",2),operOrg=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(operOrg)
	s intrtype=$s(type="SMY":"MY",type="SMH":"MH",1:type)
	s IntrFlag=$s($d(^DHCINTR(0,"TypePointer",intrtype,pointer)):"Y",1:"N")
	s IntrQty=""
	i IntrFlag="Y" d
	.s IntrId=$o(^DHCINTR(0,"TypePointer",intrtype,pointer,0))
	.q:IntrId=""
	.s IntrQty=$p(^DHCINTR(IntrId),"^",6)
	q operNo_"^"_operOrg_"^"_IntrFlag_"^"_IntrQty
}

/// CreatDate:2013-05-18
/// Description:根据业务子表rowid取inci,batno,qty(buom)
/// Table:dhc_ingdrecitm,dhc_ingrtitm等
/// Input:业务子表rowid
/// OutPut:
/// Return: inci^batno^qty(buom)^vendor^inclb
ClassMethod GetInfoByPointer(type As %String, pointer As %String) As %String
{
	n (type,pointer,%session)
	q:type=""
	q:pointer=""

	s main=+pointer
	s ch=$p(pointer,"||",2)
	s qty=0
	s inci="",incib="",vendor=""
	//入库
	i type="G" d
	.s inclb=$p(^DHCINGR(main,"GRI",ch),"^",1)
	.s qty=$p(^DHCINGR(main,"GRI",ch),"^",4)
	.s puom=$p(^DHCINGR(main,"GRI",ch),"^",10)
	.s inci=$p(^DHCINGR(main,"GRI",ch),"^",25)
	.s vendor=$p(^DHCINGR(main),"^",3)
	.
	//退货
	i type="R" d
	.s inclb=$p(^INGRT(main,"DHCGRR",ch),"^",6)
	.s qty=$p(^INGRT(main,"DHCGRR",ch),"^",2)
	.s puom=$p(^INGRT(main,"DHCGRR",ch),"^",3)
	.s vendor=$p(^INGRT(main),"^",2)
	.
	i ((type="T")||(type="K")) d
	.s qty=$p(^DHCINIT(main,"ITI",ch),"^",1)
	.s inclb=$p(^DHCINIT(main,"ITI",ch),"^",3)
	.s puom=$p(^DHCINIT(main,"ITI",ch),"^",7)
	.s il=$p(inclb,"||",2)
	.s lb=$p(inclb,"||",3)
	.s incib=$p(^INCI(+inclb,"IL",il,"LB",lb),"^",1)
	.q:incib=""
	.s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	.q:dhcincib=""
	.s vendor=$p(^DHCINCIB(dhcincib),"^",8)
	.
	i type="A" d
	.s inclb=$p(^DHCINAD(main,"ADI",ch),"^",1)
	.s qty=$p(^DHCINAD(main,"ADI",ch),"^",2)
	.s puom=$p(^DHCINAD(main,"ADI",ch),"^",5)
	.s il=$p(inclb,"||",2)
	.s lb=$p(inclb,"||",3)
	.s incib=$p(^INCI(+inclb,"IL",il,"LB",lb),"^",1)
	.q:incib=""
	.s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	.q:dhcincib=""
	.s vendor=$p(^DHCINCIB(dhcincib),"^",8)
	.
	i type="D" d
	.s inclb=$p(^DHCINSP(main,"I",ch),"^",1)
	.s puom=$p(^DHCINSP(main,"I",ch),"^",2)
	.s qty=$p(^DHCINSP(main,"I",ch),"^",3)
	.s il=$p(inclb,"||",2)
	.s lb=$p(inclb,"||",3)
	.s incib=$p(^INCI(+inclb,"IL",il,"LB",lb),"^",1)
	.q:incib=""
	.s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	.q:dhcincib=""
	.s vendor=$p(^DHCINCIB(dhcincib),"^",8)
	.

	s:inci="" inci=+inclb
	s buom=$p(^INCI(inci,1),"^",10)
	s fac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(puom,buom)
	s qty=qty*fac

	i inclb'="" d
	.s il=$p(inclb,"||",2)
	.s lb=$p(inclb,"||",3)
	.s incib=$p(^INCI(+inclb,"IL",il,"LB",lb),"^",1)
	.
	s highFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(inci)
	i highFlag'="Y" s qty=0     ;对于不是高值材料的,另其需添加条码的数量qty=0

	i qty<0 s qty=-qty      ;对于调整,报损等,需要将负数改为正数
	q inci_"^"_incib_"^"_qty_"^"_vendor_"^"_inclb
}

/// CreatDate:2013-05-16
/// Description:维护批号信息
/// Table:dhc_itmtrack
/// Input:业务类型(G,K等),业务rowid,批号
/// OutPut:
/// Return:0 成功; <0 维护失败
ClassMethod MaintainBatNo(type, pointer, inclb) As %String
{
	n (type,pointer,inclb,%session)
	s RtnObj=##class(RtnObj).%New()
	i ((type="")||(pointer="")||(inclb="")) s Sc=RtnObj.Err(-1,"","更新高值批次信息入参为空!","",0) q RtnObj
	s $ZT=..sssError()
	s il=$p(inclb,"||",2)
	s lb=$p(inclb,"||",3)
	s incib=$p(^INCI(+inclb,"IL",il,"LB",lb),"^",1)

	s Err=0
	s dhcit=""
	f  s dhcit=$o(^DHCITD(0,"Type",type,"Pointer",pointer,dhcit)) q:(dhcit="")!(Err'=0)  d
	.s oldIncib=$p(^DHCIT(dhcit),"^",7)
	.;q:oldIncib'=""     ;已有批次信息的,不作维护	;2014-06-05 wangjiabin rem 取消审核后再入库有修改incib,inclb的必要
	.&sql(update dhc_itmtrack set DHCIT_INCIB_DR=:incib,DHCIT_INCLB_DR=:inclb where DHCIT_Rowid=:dhcit)
	.i SQLCODE'=0 d
	..s Err=-4
	.
	i (Err'=0) s Sc=RtnObj.Err(-2,"","更新高值批次信息失败!","",0) q RtnObj
	q RtnObj
}

/// CreatDate:2013-05-17
/// Description:验证条码是否与库存项相符,初次录条码提示
/// Table:dhc_itmtrack,dhc_itmtrackdetail
/// Input:条码desc, 库存项id
/// OutPut:
/// Return:0 条码与库存项相符;  -10 初次录入条码, -11 条码与库存项不符
ClassMethod Compare(label As %String, inci As %String) As %String
{
	n (label,inci,%session)
	q:label="" -1
	q:inci="" -2

	s dhcit=$o(^DHCIT(0,"LABEL",label,""))
	q:dhcit="" -10
	s tmpInci=$p(^DHCIT(dhcit),"^",1)
	q:tmpInci'=inci -11

	q 0
}

/// CreatDate:2013-05-17
/// Description:注销高值条码
/// Table:dhc_itmtrack
/// Input:dhcit_rowid
/// OutPut:
/// Return: "" 成功; 其他 删除失败
ClassMethod DeleteLabel(Params As %String) As %String
{
	n (Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	q:Sc'=0 RtnObj.Err(-1,"","参数解析错误!").Json()
	
	s barcodes="",HospId=""
	ts
	while(RtnObj.success=0){
		s Obj=PJObj.%Pop()
		q:Obj=""
		s dhcit=Obj.%Get("RowId")
		q:dhcit=""
		s barcode=$p(^DHCIT(dhcit),"^",2)
		s status=$p(^DHCIT(dhcit),"^",4)
		s OrderDetailSubId=$p(^DHCIT(dhcit),"^",25)
		s DhcitLoc=$p(^DHCIT(dhcit),"^",26)
		s HospId=..sssHospId(DhcitLoc)
		q:status'=""
		q:$d(^DHCITD(dhcit,"I"))
		&sql(delete from dhc_itmtrack where DHCIT_Rowid=:dhcit)
		i SQLCODE'=0 d RtnObj.Err(-1,,$ClassName()_".DeleteLabel:SQLCODE"_SQLCODE_":"_$g(%msg)) q
		i OrderDetailSubId'="" d
		.i barcodes="" d
		..s barcodes=barcode
		.e  d
		..s barcodes=barcodes_"^"_barcode
	}
	i RtnObj.success=0 d
	.tc
	else  d
	.tro
	i barcodes'="" d
	.d ##class(web.DHCSTMHUI.ServiceForSCI).updateHvOrder("D",barcodes)
	.d ##class(web.DHCSTMHUI.ServiceForECS).DeleteHVBarCode(barcodes,HospId)
	q RtnObj.Json()
}

/// CreatDate:	2018-07-22
/// Description:检查单据中高值材料是否正确录入条码
/// Input:		业务台帐类型, 业务主表rowid
/// OutPut:
/// Return:		"":录入完全;  非空(inciDesc串):,录入不完整
ClassMethod CheckLabelsByPointer(Type As %String, Main As %String) As %String
{
	n (Type,Main,%session)
	q:Main="" ""

	s Ret=""
	s Ch=0
	i Type="G" d
	.f  s Ch=$o(^DHCINGR(Main,"GRI",Ch))  q:(Ch="")||(Ret'="")  d
	..s Pointer=Main_"||"_Ch
	..s Ret=$$CheckByPointer(Type,Pointer)
	e  i Type="R" d
	.f  s Ch=$o(^INGRT(Main,"DHCGRR",Ch)) q:(Ch="")||(Ret'="")  d
	..s Pointer=Main_"||"_Ch
	..s Ret=$$CheckByPointer(Type,Pointer)
	e  i ((Type="T")||(Type="K")) d
	.f  s Ch=$o(^DHCINIT(Main,"ITI",Ch)) q:(Ch="")||(Ret'="")  d
	..s Pointer=Main_"||"_Ch
	..s Ret=$$CheckByPointer(Type,Pointer)
	e  i Type="A" d
	.f  s Ch=$o(^DHCINAD(Main,"ADI",Ch)) q:(Ch="")||(Ret'="")  d
	..s Pointer=Main_"||"_Ch
	..s Ret=$$CheckByPointer(Type,Pointer)
	e  i Type="D" d
	.f  s Ch=$o(^DHCINSP(Main,"I",Ch)) q:(Ch="")||(Ret'="")  d
	..s Pointer=Main_"||"_Ch
	..s Ret=$$CheckByPointer(Type,Pointer)

	q Ret
 
CheckByPointer(Type,Pointer)
	n (Type,Pointer,%session)
	s ChInfo=..GetInfoByPointer(Type,Pointer)
	s Inci=$p(ChInfo,"^",1)
	s Qty=$p(ChInfo,"^",3)
	q:Inci=""
	s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(Inci)
	q:HVFlag'="Y" ""
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s LabelCount=$$CountLabel(Type,Pointer)
	s OriginalStatus=..GetOriginalStatus(Type,Pointer) //20190525
	q:((LabelCount'=Qty)&&(OriginalStatus'="NotUnique")) InciDesc
	q ""
 
CountLabel(Type,Pointer)
	n (Type,Pointer,%session)
	q:Pointer="" 0
	s Count=0
	s ITId=""
	f  s ITId=$o(^DHCITD(0,"Type",Type,"Pointer",Pointer,ITId)) q:ITId=""  d
	.s BarCode=$p(^DHCIT(ITId),"^",2)
	.q:BarCode=""
	.s Count=Count+1
	q Count
}

/// CreatDate:2013-05-28
/// Description:查询业务rowid对应的label串
/// Table:dhc_itmtrack,dhc_itmtrackdetail
/// Input:业务类型(G,K等),业务子表rowid,inclb(或incil或inci)
/// OutPut:
/// Return:label串, 用#隔开
/// ##class(web.DHCSTMHUI.DHCINGdRet).Audit有调用
/// 2015-11-16 rem 添加inclb参数(缺省为空),也可为incil或inci
/// 2015-12-10 rem 高值包,医嘱绑定条码模式,使得一个医嘱可能对应多个条码,为不影响调用后的json输出,改成用#隔开
ClassMethod GetLabelsStr(type As %String, pointer As %String, inclb As %String = "") As %String
{
	n (type,pointer,inclb,%session)
	q:type="" ""
	q:pointer="" ""

	s (INCIL,INCLB)=""
	s INCI=$p(inclb,"||",1),il=$p(inclb,"||",2),lb=$p(inclb,"||",3)
	s:il'="" INCIL=INCI_"||"_il
	s:lb'="" INCLB=INCI_"||"_il_"||"_lb

	s labelStr=""
	s dhcit=""
	f  s dhcit=$o(^DHCITD(0,"Type",type,"Pointer",pointer,dhcit)) q:dhcit=""  d
	.s Inclb=$p(^DHCIT(dhcit),"^",12)
	.s Incil=$p(Inclb,"||",1,2)
	.s Inci=$p(^DHCIT(dhcit),"^",1)
	.
	.q:(INCLB'="")&&(Inclb'=INCLB)
	.q:(INCIL'="")&&(Incil'=INCIL)
	.q:(INCI'="")&&(Inci'=INCI)
	.
	.s label=$p(^DHCIT(dhcit),"^",2)
	.i labelStr'="" d
	..s labelStr=labelStr_"#"_label		;2015-12-10 分隔符由^改为#
	.e  d
	..s labelStr=label
	.

	q labelStr
}

/// CreatDate: 	2015-11-05
/// Description:生成高值条码 (独立出来, 便于其他地方调用)
/// Input:		StrParam(类组id^科室id)
/// OutPut:		
/// Return:		条码:成功, 空:失败
ClassMethod CreateBarCode(StrParam As %String) As %String
{
	n (StrParam,%session)
	s StkGrpId=$p(StrParam,"^",1)
	s LocId=$p(StrParam,"^",2)
	s AppName=..%GetParameter("AppName")
	s BarCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(AppName,StkGrpId,LocId)
	q BarCode
}

/// CreatDate:2013-09-18
/// Description:查询高值条码
/// Table:dhc_itmtrack
/// Input: Start,Limit,Param(高值条码^类组id^inci^开始日期^截止日期^time^供应商^请求科室^批号^HospId^生成人员)
/// OutPut:成功返回$h失败返回负数
/// Return:日期时间
/// barcode
/// w ##class(web.DHCSTMHUI.DHCItmTrack).queryRegHV(0,30,"^12^^2017-02-13^^2017-02-13^^^^2^^153^6")
ClassMethod queryRegHV(Start As %String, Limit As %String, Param As %String) As %String
{
	n (Start,Limit,Param,%session)
	q:Param="" ""
	s BarCodeField=$P(Param,"^",1)
	s StkGrpType=$P(Param,"^",2)
	s inciDr=$P(Param,"^",3)
	s startDate=$P(Param,"^",4)
	s endDate=$P(Param,"^",6)
	s time=$P(Param,"^",5)
	s startDate=$zdh(startDate,3)
	s endDate=$zdh(endDate,3)
	s:time'="" time=$zth(time,3)
	s vendor=$P(Param,"^",7)
	s reqloc=$P(Param,"^",8)
	s batno=$P(Param,"^",9)
	s HospId=$P(Param,"^",10)
	s CreateUser=$p(Param,"^",11)
	s LogId=$p(Param,"^",12)
	s CreatLoc=$p(Param,"^",13)
	s regflag=$p(Param,"^",14)

	s Sklocid=""
	&sql(select DHCLoc_MainLoc_DR into :Sklocid from DHCST_CTloc where DHCLoc_Ctloc_dr=:LogId)
	i SQLCODE=0 d
	.s LogId=Sklocid

	s StkGrpType=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),"",StkGrpType,HospId)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr=""
	i regflag="Y" d
	.s sqlStr="select * from dhc_itmtrack where DHCIT_Status='Enable' and DHCIT_Date between '"_startDate_"' and '"_endDate_"'"
	.i BarCodeField'="" d
	..s sqlStr = "select * from dhc_itmtrack where DHCIT_Status='Enable' and DHCIT_Label='"_BarCodeField_"'"
	.i time'="" d
	..s sqlStr ="select * from dhc_itmtrack where DHCIT_Status='Enable' and DHCIT_Date='"_startDate_"' and DHCIT_Time='"_time_"'"
	e  d
	.s sqlStr="select * from dhc_itmtrack where DHCIT_Status is null and DHCIT_Date between '"_startDate_"' and '"_endDate_"'"
	.i BarCodeField'="" d
	..s sqlStr = "select * from dhc_itmtrack where DHCIT_Status is null and DHCIT_Label='"_BarCodeField_"'"
	.i time'="" d
	..s sqlStr ="select * from dhc_itmtrack where DHCIT_Status is null and DHCIT_Date='"_startDate_"' and DHCIT_Time='"_time_"'"


	i inciDr'="" d
	.s sqlStr=sqlStr_" and DHCIT_INCI_DR="_inciDr
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s resultString = ""
	s end = Start+Limit
	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	While(result.Next())
	{
		s InctrackId = result.Data("DHCIT_Rowid")
		s IncId = result.Data("DHCIT_INCI_DR")
		s VendorId=result.Data("DHCIT_APCVM_DR")
		continue:(vendor'="")&(vendor'=VendorId)
		s VendorDesc=$s(VendorId'="":$p($g(^APC("APCVM",VendorId)),"^",3),1:"")
		s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(IncId)
		s SCG=$p(ScgInfo,"^",5)
		continue:(StkGrpType'="")&&(("^"_StkGrpType_"^")'[("^"_SCG_"^"))
		s IncCode=$P(^INCI(IncId,1),"^",1)
		s IncDesc=$P(^INCI(IncId,1),"^",2)
		s BarCode = result.Data("DHCIT_Label")
		s Date = result.Data("DHCIT_Date")
		s:Date'="" Date=..DL2H(Date)
		s Time = result.Data("DHCIT_Time")
		s:Time'="" Time=..TL2H(Time)
		s User = result.Data("DHCIT_SSUSR_DR")
		continue:(CreateUser'="")&&(User'=CreateUser)
		s:User'="" User=$p(^SSU("SSUSR",User),"^",2)
		s Qty=1
		s PoItmId=result.Data("DHCIT_INPOI_DR")
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",IncId)
		s OriginalCode=$p(^DHCIT(InctrackId),"^",13)
		s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(IncId)
		s inreqi=##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).GetInrqi(PoItmId,"PO")
		s ReqNo=""
		s:+inreqi>0 ReqNo=$p(^INRQ(+inreqi),"^",1)
		s ReqLoc="",ReqLocDesc=""
		i +inreqi>0 d 
		.s inreq=+inreqi
		.&sql(select INRQ_RecLoc_DR,INRQ_RecLoc_DR->CTLOC_Desc into :ReqLoc,:ReqLocDesc from IN_Request  where INRQ_RowId=:inreq)
		s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		continue:(reqloc'="")&(reqloc'=ReqLoc)
		s BatNo=result.Data("DHCIT_BatchNo")
		continue:(batno'="")&(batno'=BatNo)
		s ExpDate=result.Data("DHCIT_ExpDate")
		s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		s SpecDesc=result.Data("DHCIT_SpecList")
		s PurUomId=$p(^INCI(IncId,3),"^",6)
		s BUomId=$p(^INCI(IncId,1),"^",10)
		s (PurUom,BUom,Ingri)=""
		s:PurUomId'="" PurUom=$p(^CT("UOM",PurUomId),"^",2)
		s:BUomId'="" BUom=$p(^CT("UOM",BUomId),"^",2)
		s PbRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPbRp(IncId,BUomId)
		s ProduceDate=result.Data("DHCIT_ProduceDate")
		s:ProduceDate'="" ProduceDate=..DL2H(ProduceDate)
		s CerNo=result.Data("DHCIT_CertNo")
		s CerExpDate=result.Data("DHCIT_CertExpDate")
		s:CerExpDate'="" CerExpDate=..DL2H(CerExpDate)
		s Rp=result.Data("DHCIT_RealPrice")
		i +Rp=0 d
		.s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(IncId,BUomId,HospId)
		;s Sp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(IncId,+$h,"",HospId,"",Rp)
		s Sp=##class(web.DHCSTMHUI.DHCINGdRec).GetSpForRec(IncId,BUomId,Rp,..sssParamStr())
		s Marginnow=$s(+Rp>0:Sp/Rp-1,1:"")
		s:Marginnow'="" Marginnow=$fn(Marginnow,"",3)
		s ManfId=result.Data("DHCIT_PHMNF_DR")
		s ManfDesc=$s(ManfId'="":$p($g(^PHMNF(ManfId)),"^",2),1:"")
		s DhcitLoc=$p(^DHCIT(InctrackId),"^",26)
		;传入生成科室时,按该科室过滤,否则按登录科室过滤
		continue:(CreatLoc'="")&(CreatLoc'=DhcitLoc)
		continue:(CreatLoc="")&&(LogId'="")&&(DhcitLoc'="")&&(LogId'=DhcitLoc)
		s sxno=result.Data("DHCIT_SxNo")
		s BatchReq=$p(^INCI(IncId,2),"^",10)
		s ExpReq=$p(^INCI(IncId,2),"^",11)
		&sql(select dhcitd_pointer into :Ingri from dhc_itmtrackdetail where dhcitd_parref->dhcit_label=:BarCode and dhcitd_type='G')
		s tmp=InctrackId_"^"_IncId_"^"_IncCode_"^"_IncDesc_"^"_Qty
			_"^"_BarCode_"^"_User_"^"_Date_"^"_Spec_"^"_OriginalCode
			_"^"_PoItmId_"^"_ReqNo_"^"_Brand_"^"_BatNo_"^"_ExpDate
			_"^"_Sp_"^"_ReqLocDesc_"^"_SpecDesc_"^"_PbRp_"^"_Marginnow
			_"^"_ProduceDate_"^"_CerNo_"^"_CerExpDate_"^"_Rp_"^"_PurUomId
			_"^"_Marginnow_"^"_BUomId_"^"_ManfId_"^"_ManfDesc_"^"_VendorId
			_"^"_VendorDesc_"^"_sxno_"^"_BatchReq_"^"_ExpReq_"^"_Time_"^"_PurUom_"^"_BUom_"^"_Ingri

		s count = count+1   
		CONTINUE:count<(Start+1)
		CONTINUE:count>end  
		d json.InsertRowData(tmp)
	}
	d result.Close()
	s TitleStr="InctrackId^IncId^IncCode^IncDesc^Qty"
		_"^BarCode^User^Date^Spec^OriginalCode"
		_"^PoItmId^ReqNo^Brand^BatNo^ExpDate"
		_"^Sp^ReqLocDesc^SpecDesc^PbRp^Marginnow"
		_"^ProduceDate^CerNo^CerExpDate^Rp^PurUomId"
		_"^Marginnow^BUomId^ManfId^ManfDesc^VendorId"
		_"^VendorDesc^SxNo^BatchReq^ExpReq^Time^PurUom^BUom^Ingri"
	d json.getJsonData(TitleStr,count)
	k json
}

///  CreatDate:2013-09-23
///  Description:根据条码查询材料信息
///  Table:dhc_itmtrack
///  Input:barcode(高值条码)
///  OutPut:
///  Return:    dhcit_status^最后一条明细状态^最后明细的单据号^inci^inciCode^inciDesc^inclb^ingri^ingrti
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetItmByBarcode("797449719100829")
ClassMethod GetItmByBarcode(BarCode As %String) As %String
{
	n (BarCode,%session)
	s BarCode=$tr(BarCode,"|")
	s RtnObj=##class(RtnObj).%New()
	i BarCode="" s Sc=RtnObj.Err(-1,"","条码不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()

	s dhcit=$o(^DHCIT(0,"LABEL",BarCode,0))
	s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",BarCode,0))
	i dhcit="" s Sc=RtnObj.Err(-1,"","没查询到条码信息!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	i OriginalStatus'="NotUnique" d
	.s tmpid="",AckFlag="Y"
	.&sql(SELECT %id into :tmpid FROM DHC_OeoriBindBarCode WHERE DHCOBB_ItmTrack_DR=:dhcit and DHCOBB_AckFlag=:AckFlag)
	.i tmpid'="" s Sc=RtnObj.Err(-2,"","该条码已被绑定医嘱!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	
	s Inci=$p(^DHCIT(dhcit),"^",1)
	s Code=$p(^INCI(Inci,1),"^",1)
	s Description=$p(^INCI(Inci,1),"^",2)
	s BUomId=$p(^INCI(Inci,1),"^",10)
	s Status=$p(^DHCIT(dhcit),"^",5)
	s Inclb=$p(^DHCIT(dhcit),"^",12)
	s Incib="",RecallFlag="N"
	s:Inclb'="" Incib=$p(^INCI($p(Inclb,"||",1),"IL",$p(Inclb,"||",2),"LB",$p(Inclb,"||",3)),"^",1)
	s:(Incib'="")&&(OriginalStatus'="NotUnique") RecallFlag=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",3)   ///锁定标志
	s Poi=$p(^DHCIT(dhcit),"^",14)
	s BRp=$p(^DHCIT(dhcit),"^",16)
	s HospId=""
	i +BRp=0 d
	.s BRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(Inci,BUomId,HospId)
	s Sp=##class(web.DHCSTMHUI.DHCINGdRec).GetSpForRec(Inci,BUomId,BRp,..sssParamStr())
	s Marginnow=$s(+BRp>0:Sp/BRp-1,1:"")
	s:Marginnow'="" Marginnow=$fn(Marginnow,"",3)
	i Inclb'="" d
	.s BatExpInfo=##class(web.DHCSTMHUI.Common.DrugStkCommon).Bat(Inclb)
	.s BatNo=$p(BatExpInfo,"^",1)
	.s ExpDate=$p(BatExpInfo,"^",2)
	e  d
	.s BatNo=$p(^DHCIT(dhcit),"^",17)
	.s ExpDate=$p(^DHCIT(dhcit),"^",18)
	.s ExpDate=..DL2H(ExpDate)
	s CertNo=$p(^DHCIT(dhcit),"^",22)
	s CertExpDate=$p(^DHCIT(dhcit),"^",23)
	s CertExpDate=..DL2H(CertExpDate)
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(Inci)
	s ScgStk=$p(ScgInfo,"^",5)
	s ScgStkDesc=$p(ScgInfo,"^",2)
	s (Type,Pointer,Ingri,Ingrti,Initi,Inadi,Inspi,INDispItmId,INDispRetItmId)=""
	s ch=0 
	s dhcitd=""
	f  s ch=$o(^DHCITD(dhcit,"I",ch)) q:ch=""  d
	.s dhcitd=dhcit_"||"_ch
	.s Pointer=$p(^(ch),"^",1)
	.s Type=$p(^(ch),"^",2)		;记录最后一条明细的信息
	.s:Type="G" Ingri=Pointer
	.s:Type="R" Ingrti=Pointer
	.s:(Type="T")!(Type="K") Initi=Pointer
	.s:Type="A" Inadi=Pointer
	.s:Type="D" Inspi=Pointer
	.s:Type="C" INDispItmId=Pointer
	.s:Type="L" INDispRetItmId=Pointer
	s (IsAudit,OperNo)=""
	i dhcitd'="" d
	.s IsAuditInfo=..IsDetailAudit(dhcitd)
	.s IsAudit=$p(IsAuditInfo,"^",1)
	.s OperNo=$p(IsAuditInfo,"^",2)
	.s NoDesc=$S(Type="G":"入库单",(Type="T")!(Type="K"):"库存转移单",Type="R":"退货单",Type="D":"报损单",Type="A":"库存调整单",(Type="P")!(Type="Y")!(Type="F")!(Type="H")!(Type="MP")!(Type="MY")!(Type="MF")!(Type="MH"):"物资医嘱",Type="C":"发放单",Type="L":"发放退回单",1:Type)
	.s OperNo=NoDesc_":"_OperNo
	
	s:Type="" Type="Reg"
	s:IsAudit="" IsAudit="Y"
	
	s LocId="",LocDesc=""
	i Inclb'="" d
	.s il=$p(Inclb,"||",2)
	.s LocId=$p(^INCI(+Inclb,"IL",il),"^",1)
	.s LocDesc=$p($g(^CTLOC(LocId)),"^",2)

	s Reqi=##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).GetInrqi(Poi,"PO")
	s ReqLoc="",ReqLocDesc=""
	s:+Reqi>0 Reqloc=$p(^INRQ(+Reqi),"^",6)
	s:ReqLoc'="" ReqLocDesc=$p(^CTLOC(ReqLoc),"^",2)
	s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
	s dhcitLocId=$p(^DHCIT(dhcit),"^",26)
	s ManfId=$p(^DHCIT(dhcit),"^",15)
	s ManfDesc=$s(ManfId'="":$p($g(^PHMNF(ManfId)),"^",2),1:"")
	s SpecDesc=$p(^DHCIT(dhcit),"^",19)
	s VendorId=$p(^DHCIT(dhcit),"^",11)
	s VendorDesc=$s(VendorId'="":$p($g(^APC("APCVM",VendorId)),"^",3),1:"")
	s SxNo=$p(^DHCIT(dhcit),"^",31)
	s SterilizedNo=$p(^DHCIT(dhcit),"^",32)
	s SterilizedDate=$p(^DHCIT(dhcit),"^",33)
	s:+SterilizedDate'=0 SterilizedDate=..DL2H(SterilizedDate)
	s ProduceDate=$p(^DHCIT(dhcit),"^",20)
	s:+ProduceDate'=0 ProduceDate=..DL2H(ProduceDate)
	s OrigiBarCode=$p(^DHCIT(dhcit),"^",13)
	s ExitInLoc=$P(##class(web.DHCSTMHUI.PCHCOLLSM).GetArcimByLabel(BarCode),"^",6) ;接收科室
	
	s Data=Status_"^"_Type_"^"_IsAudit_"^"_OperNo_"^"_Inclb_"^"_Inci_"^"_Code_"^"_Description_"^"_ScgStk_"^"_ScgStkDesc
		_"^"_Ingri_"^"_Ingrti_"^"_Initi_"^"_Inadi_"^"_Inspi_"^"_Poi_"^"_BatNo_"^"_ExpDate_"^"_LocId_"^"_LocDesc
		_"^"_ReqLoc_"^"_ReqLocDesc_"^"_CertNo_"^"_CertExpDate_"^"_RecallFlag_"^"_BRp_"^"_dhcit_"^"_dhcitLocId_"^"_ManfId_"^"_ManfDesc
		_"^"_SpecDesc_"^"_SxNo_"^"_SterilizedDate_"^"_SterilizedNo_"^"_ProduceDate_"^"_OrigiBarCode_"^"_Sp_"^"_Marginnow_"^"_ExitInLoc
		_"^"_VendorId_"^"_VendorDesc_"^"_OriginalStatus_"^"_INDispItmId_"^"_INDispRetItmId
	s Title="Status^Type^IsAudit^OperNo^Inclb^Inci^Code^Description^ScgStk^ScgStkDesc"
			_"^Ingri^Ingrti^Initi^Inadi^Inspi^Poi^BatNo^ExpDate^LocId^LocDesc"
			_"^ReqLoc^ReqLocDesc^CertNo^CertExpDate^RecallFlag^BRp^dhcit^dhcitLocId^ManfId^ManfDesc"
			_"^SpecDesc^SxNo^SterilizedDate^SterilizedNo^ProduceDate^OrigiBarCode^Sp^Marginnow^ExitInLoc"
			_"^VendorId^VendorDesc^OriginalStatus^INDispItmId^INDispRetItmId"
	s Rtn=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(Data,Title)
	q Rtn
}

/// Descript:   判断明细是否审核
/// Creator:    wangjiabin
/// CreateDate: 2013-11-14
/// Input:      dhcitd
/// Output:     
/// Return： (Y/N) ^ 未审核时的单据信息
ClassMethod IsDetailAudit(dhcitd) As %Library.String
{
	n (dhcitd,%session)
	s isAudit="Y"
	s sub=$p(dhcitd,"||",2)
	s pointer=$p(^DHCITD(+dhcitd,"I",sub),"^",1)
	s type=$p(^DHCITD(+dhcitd,"I",sub),"^",2)

	//K不需判断, 入库接收后保存的高值信息; P,Y不需判断
	s ch=$p(pointer,"||",2)
	i type="G" d
	.s inclb=$p(^DHCINGR(+pointer,"GRI",ch),"^",1)
	.s:inclb="" isAudit="N"
	e  i type="T" d
	.s status=$p(^DHCINIT(+pointer),"^",14)
	.s:(status'=21)&(status'=31) isAudit="N"
	e  i type="R" d
	.s isAudit=$p(^INGRT(+pointer),"^",15)
	e  i type="A" d
	.s isAudit=$p(^DHCINAD(+pointer),"^",14)
	.s:isAudit="" isAudit="N"
	e  i type="D" d
	.s isAudit=$p(^DHCINSP(+pointer),"^",14)
	.s:isAudit="" isAudit="N"
	e  i type="C" d
	.s isAudit=$p(^DHCINDS(+pointer),"^",17)
	.s:isAudit="" isAudit="N"
	e  i type="L" d
	.s isAudit=$p(^DHCINDSR(+pointer),"^",6)
	.s:isAudit="" isAudit="N"
	s operNoInfo=..GetOperNo(type,pointer)
	s operNo=$p(operNoInfo,"^",1)

	q isAudit_"^"_operNo
}

/// Descript:   根据业务类型和业务主表rowid删除高值跟踪明细信息
/// Creator:    wangjiabin
/// CreateDate: 2013-10-17
/// Table:      dhc_itmtrack,dhc_itmtrackdetail
/// Input:      业务类型,业务主表表rowid
/// Output:     
/// Return:		
ClassMethod DelByPointer(type As %String, rowid As %String) As RtnObj
{
	n (type,rowid,%session)
	s RtnObj=##class(RtnObj).%New()
	i (type="")||(rowid="") q RtnObj.Err(-2,"","参数错误!")

	s ch=0
	ts
	i type="G" d
	.f  s ch=$o(^DHCINGR(rowid,"GRI",ch)) q:(ch="")||(RtnObj.success<0)  d
	..s pointer=rowid_"||"_ch
	..s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer(type,pointer)
	..q:RtnObj.success<0
	i RtnObj.success<0 tro  q RtnObj

	i type="T" d
	.f  s ch=$o(^DHCINIT(rowid,"ITI",ch)) q:(ch="")||(RtnObj.success<0)  d
	..s pointer=rowid_"||"_ch
	..s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer(type,pointer)
	..q:RtnObj.success<0
	i RtnObj.success<0 tro  q RtnObj

	i type="R" d
	.f  s ch=$o(^INGRT(rowid,"DHCGRR",ch)) q:(ch="")||(RtnObj.success<0)  d
	..s pointer=rowid_"||"_ch
	..s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer(type,pointer)
	..q:RtnObj.success<0
	i RtnObj.success<0 tro  q RtnObj

	i type="D" d
	.f  s ch=$o(^DHCINSP(rowid,"I",ch)) q:(ch="")||(RtnObj.success<0)  d
	..s pointer=rowid_"||"_ch
	..s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer(type,pointer)
	..q:RtnObj.success<0
	i RtnObj.success<0 tro  q RtnObj

	i type="A" d
	.f  s ch=$o(^DHCINAD(rowid,"ADI",ch)) q:(ch="")||(RtnObj.success<0)  d
	..s pointer=rowid_"||"_ch
	..s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer(type,pointer)
	..q:RtnObj.success<0
	i RtnObj.success<0 tro  q RtnObj
	
	i type="C" d
	.f  s ch=$o(^DHCINDS(rowid,"DSI",ch)) q:(ch="")||(RtnObj.success<0)  d
	..s pointer=rowid_"||"_ch
	..s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer(type,pointer)
	..q:RtnObj.success<0
	i RtnObj.success<0 tro  q RtnObj
	
	i type="L" d
	.f  s ch=$o(^DHCINDSR(rowid,"I",ch)) q:(ch="")||(RtnObj.success<0)  d
	..s pointer=rowid_"||"_ch
	..s RtnObj=##class(web.DHCSTMHUI.DHCItmTrackDetail).DelByPointer(type,pointer)
	..q:RtnObj.success<0
	i RtnObj.success<0 tro  q RtnObj
	
	tc

	q RtnObj
}

/// 2018-09-04 传入inclb也可,但至少传入incil
/// Descript:   根据incil取出当前处于可用状态的高值条码
/// Creator:    wxj
/// Table:      dhc_itmtrack,dhc_itmtrackdetail
/// d ##class(web.DHCSTMHUI.DHCItmTrack).GetEnableBarcodes(1,20,"10395||3")
ClassMethod GetEnableBarcodes(page As %String, rows As %String, incil As %String) As %Library.String
{
	n (page,rows,incil,%session)
	s Start=(page-1)*rows
	s Limit=rows
	q:incil="" ""
	s end=Start+Limit
	s inci=+incil,il=$p(incil,"||",2),lb=$p(incil,"||",3)
	q:'$d(^INCI(inci,"IL",il)) ""
	s INCIL=$p(incil,"||",1,2)		;参数传入incil或inclb,要处理一下
	s INCLB=$s(lb'="":INCIL_"||"_lb,1:"")
	s InciCode=$p(^INCI(inci,1),"^",1)
	s InciDesc=$p(^INCI(inci,1),"^",2)

	s json = ##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s count=0
	s BatchCodeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBatchCodeFlag(inci)
	i BatchCodeFlag'="Y" {
		s dhcit=0
		f  s dhcit=$o(^DHCIT(0,"INCI",inci,dhcit)) q:dhcit=""  d
		.s status=$p(^DHCIT(dhcit),"^",5)
		.q:status'="Enable"
		.s inclb=$p(^DHCIT(dhcit),"^",12)
		.q:(inclb="")||((INCLB'="")&&(inclb'=INCLB))	;若传入inclb,按其过滤
		.s tmpInclb=$p(inclb,"||",1,2)
		.q:tmpInclb'=INCIL
		.s HVBarcode=$p(^DHCIT(dhcit),"^",2)
		.s count=count+1
		.q:count<(Start+1)
		.q:count>end
		.s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
		.s BatchNo=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",1)
		.s ExpDate=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",2)
		.s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		.s Ch=0,IngrDate=""
		.f  s Ch=$o(^DHCITD(dhcit,"I",Ch)) q:(Ch="")||(IngrDate'="")  d
		..s Type=$p(^DHCITD(dhcit,"I",Ch),"^",2)
		..q:Type'="G"
		..s IngrDate=$p(^DHCITD(dhcit,"I",Ch),"^",3)
		..s:IngrDate'="" IngrDate=..DL2H(IngrDate)
		.s rowData1=dhcit_"^"_HVBarcode_"^"_BatchNo_"^"_ExpDate_"^"_IngrDate
		.s rowData2=InciCode_"^"_InciDesc
		.s rowData=rowData1_"^"_rowData2
		.d json.InsertRowData(rowData)
		s TitleStr="dhcit^HVBarCode^BatchNo^ExpDate^IngrDate"
			_"^InciCode^InciDesc"
	}else{
		;批次码逻辑区分
		s LB=0
		f  s LB=$o(^INCI(inci,"IL",il,"LB",LB)) q:LB=""  d
		.q:(lb'="")&&(lb'=LB)
		.s Incib=$p(^INCI(inci,"IL",il,"LB",LB),"^",1)
		.s PhyQty=$p(^INCI(inci,"IL",il,"LB",LB),"^",2)
		.q:Incib=""
		.q:PhyQty'>0
		.s DHCIncib=$o(^DHCINCIB(0,"INCIB",Incib,0))
		.q:DHCIncib=""
		.s BatchCode=$p(^DHCINCIB(DHCIncib),"^",17)
		.q:BatchCode=""
		.s dhcit=$o(^DHCIT(0,"LABEL",BatchCode,0))
		.q:dhcit=""
		.s inclb=inci_"||"_il_"||"_LB
		.
		.s HVBarcode=$p(^DHCIT(dhcit),"^",2)
		.s count=count+1
		.q:count<(Start+1)
		.q:count>end
		.s incib=$p(^INCI(+inclb,"IL",$p(inclb,"||",2),"LB",$p(inclb,"||",3)),"^",1)
		.s BatchNo=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",1)
		.s ExpDate=$p(^INCI(+incib,"IB",$p(incib,"||",2)),"^",2)
		.s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		.s Ch=0,IngrDate=""
		.f  s Ch=$o(^DHCITD(dhcit,"I",Ch)) q:(Ch="")||(IngrDate'="")  d
		..s Type=$p(^DHCITD(dhcit,"I",Ch),"^",2)
		..q:Type'="G"
		..s IngrDate=$p(^DHCITD(dhcit,"I",Ch),"^",3)
		..s:IngrDate'="" IngrDate=..DL2H(IngrDate)
		.s rowData1=dhcit_"^"_HVBarcode_"^"_BatchNo_"^"_ExpDate_"^"_IngrDate
		.s rowData2=InciCode_"^"_InciDesc
		.s rowData=rowData1_"^"_rowData2
		.d json.InsertRowData(rowData)
		s TitleStr="dhcit^HVBarCode^BatchNo^ExpDate^IngrDate"
			_"^InciCode^InciDesc"
	}
	d json.getJsonData(TitleStr,count)
	k json
	q ""
}

/// Input:		Incil(兼容Inci/Incil/Inclb)
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetEnableCount("4440||2||2")
ClassMethod GetEnableCount(IncilId)
{
	n (IncilId,%session)
	
	s (INCI,INCIL,INCLB)=""
	s INCI=$p(IncilId,"||",1)
	i $l(IncilId,"||")=2 s INCIL=IncilId
	i $l(IncilId,"||")=3 s INCIL=$p(IncilId,"||",1,2),INCLB=IncilId
	q:INCI="" 0
	
	s Count=0
	s RowId=0
	f  s RowId=$o(^DHCIT(0,"StatusInci","Enable",INCI,RowId)) q:RowId=""  d
	.
	.s Inclb=$p(^DHCIT(RowId),"^",12)
	.q:(INCLB'="")&&(INCLB'=Inclb)
	.s Incil=$p(Inclb,"||",1,2)
	.q:(INCIL'="")&&(INCIL'=Incil)
	.
	.s Count=Count+1
	
	q Count
}

/// CreatDate:2015-04-15
/// Creator:zhangxiao
/// Description:查询跟踪主表信息
/// Table:dhc_itmtrack
/// Input:条码
/// OutPut:
/// Return: 
/// w ##class(web.DHCSTMHUI.DHCItmTrack).Select("DHSZHYYZYGZ20200710001")
ClassMethod Select(label As %String) As %String
{
	n (label,%session)
	q:label="" ""
	s itmtrackid=""
	s itmtrackid=$o(^DHCIT(0,"LABEL",label,0))
	q:itmtrackid="" ""
	s inci=$p(^DHCIT(itmtrackid),"^",1)
	q:inci="" ""
	
	s status=$p(^DHCIT(itmtrackid),"^",5)
	s locid=$p(^DHCIT(itmtrackid),"^",6)
	s incib=$p(^DHCIT(itmtrackid),"^",7)
	s vendor=$p(^DHCIT(itmtrackid),"^",11) ;供应商id
	s inclb=$p(^DHCIT(itmtrackid),"^",12)
	s OriginalCode=$p(^DHCIT(itmtrackid),"^",13)
	s OldOriginalCode=$p(^DHCIT(itmtrackid),"^",30)	;原有自带条码
	s expdate=$p(^DHCIT(itmtrackid),"^",18)	
	s batno=$p(^DHCIT(itmtrackid),"^",17)
	s incidesc=$p(^INCI(inci,1),"^",2) ;物资名称
	s incicode=$p(^INCI(inci,1),"^",1) ;物资代码
	s dhcitm=""   ;库存项附加表
	s dhcitm=$o(^DHCITMINFO(0,"INCI",inci,0))
	s inforemark=""
	i dhcitm'="" d
	.s inforemark=$p(^DHCITMINFO(dhcitm),"^",10) ;物资注册证号
	
	s (manf,manfdesc,BusinessRegNo,sp,rp,vendordec)=""
	i incib'="" d
	.s batno=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",1)  ;批号
	.s expdate=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",2) ;效期
	.s dhcincib=""
	.s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	.i dhcincib'="" d
	..s sp=$p(^DHCINCIB(dhcincib),"^",5)  ;售价
	..s rp=$p(^DHCINCIB(dhcincib),"^",3)  ;进价
	..s manf=$p(^DHCINCIB(dhcincib),"^",7) ;生产厂家id
	..i manf'="" d
	...s manfdesc=$p(^PHMNF(manf),"^",2)
	...s manfadd=$o(^DHCMANF(0,"MANF",manf,0))
	...i manfadd'="" d
	....s BusinessRegNo=$p(^DHCMANF(manfadd),"^",11) ;生产厂家工商注册证号
	
	i vendor'="" d
	.s vendordec=$p(^APC("APCVM",vendor),"^",3)
	s uom=$p(^INCI(inci,1),"^",10)
	s uomDesc=$p($g(^CT("UOM",uom)),"^",2) ;单位
	s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci) ;规格
	i sp="" d
	.s sp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$H,uom,"")
	s:+expdate'=0 expdate=..DL2H(expdate)
	s SpecDesc=$p(^DHCIT(itmtrackid),"^",19)
	i inclb'="" d
	.s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(inclb)
	s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(inci)
	s Data={}
	s Data.incidesc=incidesc
	s Data.manfdesc=manfdesc
	s Data.BusinessRegNo=BusinessRegNo
	s Data.vendordec=vendordec
	s Data.inforemark=inforemark
	s Data.batno=batno
	s Data.expdate=expdate
	s Data.spec=spec
	s Data.sp=sp
	s Data.rp=rp
	s Data.incicode=incicode
	s Data.itmtrackid=itmtrackid
	s Data.inclb=inclb
	s Data.SpecDesc=SpecDesc
	s Data.Brand=Brand
	s Data.OriginalCode=OriginalCode
	s Data.OldOriginalCode=OldOriginalCode
	s Data=Data.%ToJSON()
	q Data
}

/// Descript:取某订单明细对应的条码数量
/// Creater:	ZhangDongmei
/// CreateDate:	2012-08-03
/// Table:IN_PoItm，dhc_itmtrack
/// Input:采购计划明细id
/// Output:		
/// Return：条码数量
ClassMethod GetBarcodeQty(PoItmId As %String) As %Library.String
{
	n (PoItmId,%session)
	q:PoItmId="" 0
	s TotalQty=0
	;
	s Rowid=0
	f  s Rowid=$o(^DHCIT(0,"INPOI",PoItmId,Rowid)) q:Rowid=""  d
		.s TotalQty=TotalQty+1
	q TotalQty
}

/// Descript:根据条码产生新条码
/// Creater:	XuChao
/// CreateDate:	2015-07-22
/// Table:dhc_itmtrack
/// Input:barcode
/// Output:		
/// w ##class(web.DHCSTMHUI.DHCItmTrack).NewBarcode("GZ20180910001")
ClassMethod NewBarcode(Params As %String) As %Library.String
{
	n (Params,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","参数解析错误!")
	q:RtnObj.success'=0 RtnObj.Json()
	s user=PJObj.%Get("gUserId")
	s barcode=PJObj.%Get("OldBarCode")
	s d=+$h
	s t=$p($h,",",2)
	i barcode="" d RtnObj.Err(-1,"","原始条码错误,不能为空!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
	i dhcit="" d RtnObj.Err(-1,"","原始条码错误!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s dhcitDR=$p(^DHCIT(dhcit),"^",28)
	s:dhcitDR'="" dhcit=dhcitDR				;获取重生成前最原始的条码
	s orgbarcode=$p(^DHCIT(dhcit),"^",2)
	s Status=$p(^DHCIT(dhcit),"^",5)
	i Status="Return" d RtnObj.Err(-1,"","条码"_orgbarcode_"已退货制单!","",0)
	i Status="InScrap" d RtnObj.Err(-1,"","条码"_orgbarcode_"已报损制单!","",0)
	i Status="InAdj" d RtnObj.Err(-1,"","条码"_orgbarcode_"已调整制单!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s NewSerial=$$GetNewSerial(dhcit)
	s nbarcode=orgbarcode_"-"_NewSerial

	s (InciId,Rp,BatNo,ExpDate,SpecDesc,OwnLocId,CertNo,CertExpDate,ManfId,VendorId,ProduceDate,Qty,OriginalCode)=""
	&sql(select DHCIT_INCI_DR,DHCIT_RealPrice,DHCIT_BatchNo,DHCIT_ExpDate,DHCIT_SpecList,DHCIT_OwnLoc_DR,
		DHCIT_CertNo,DHCIT_CertExpDate, DHCIT_PHMNF_DR, DHCIT_APCVM_DR,DHCIT_ProduceDate,DHCIT_Qty,DHCIT_OriginalCode 
		into :InciId,:Rp,:BatNo,:ExpDate,:SpecDesc,:OwnLocId,:CertNo,:CertExpDate,:ManfId,:VendorId,:ProduceDate,:Qty,:OriginalCode 
		from dhc_itmtrack
		where %id=:dhcit)
	S InciDesc=$P(^INCI(InciId,1),"^",2)
	s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(InciId)
	i TableFlag="Y" d RtnObj.Err(-1,"",InciDesc_"现已更改为跟台高值,不允许重生成条码!","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s ndate=d
	s ntime=t
	s nuser=user
	s ndhcitdr=dhcit
	&SQL(Insert Into dhc_itmtrack(
		DHCIT_INCI_DR,DHCIT_RealPrice,DHCIT_BatchNo,DHCIT_ExpDate,DHCIT_SpecList,DHCIT_OwnLoc_DR,DHCIT_CertNo,
		DHCIT_CertExpDate, DHCIT_PHMNF_DR, DHCIT_APCVM_DR,DHCIT_ProduceDate,DHCIT_Qty,DHCIT_OriginalCode,
		DHCIT_Label,DHCIT_Date,DHCIT_Time,DHCIT_SSUSR_DR,DHCIT_DHCIT_DR ) 
		Values (:InciId,:Rp,:BatNo,:ExpDate,:SpecDesc,:OwnLocId,:CertNo,
		:CertExpDate,:ManfId,:VendorId,:ProduceDate,:Qty,:OriginalCode,
		:nbarcode,:ndate,:ntime,:nuser,:ndhcitdr))
	Q:SQLCODE'=0 RtnObj.Err(-1,"","重生成条码失败!").Json()
	s itmtrackid=%ROWID
	
	s User=""
	s IncCode=$p(^INCI(InciId,1),"^",1)
	s IncDesc=$p(^INCI(InciId,1),"^",2)
	s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	s Date=..DH2L(ndate)
	s:nuser'="" User=$p(^SSU("SSUSR",nuser),"^",2)
	s Brand=##Class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(InciId)
	s:ExpDate'="" ExpDate=..DH2L(ExpDate)
	s dataStr=itmtrackid_"^"_InciId_"^"_IncCode_"^"_IncDesc_"^"_Spec_"^"_nbarcode_"^"_OriginalCode_"^"_Date_"^"_Brand_"^"_BatNo_"^"_ExpDate_"^"_SpecDesc_"^"_Qty_"^"_User
	s titleStr="InctrackId^IncId^IncCode^IncDesc^Spec^BarCode^OriginalCode^Date^Brand^BatNo^ExpDate^SpecDesc^Qty^User"
	s result=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(dataStr,titleStr)
	s RtnObj.keyValue=result
	q RtnObj.Json()

GetNewSerial(dhcitDR)
	n (dhcitDR,%session)
	q:dhcitDR="" 0
	s Ser=0    ;设置初值
	s dhcit=0
	f  s dhcit=$o(^DHCIT(0,"DHCIT",dhcitDR,dhcit)) q:dhcit=""  d
	.s SerBarcode=$p(^DHCIT(dhcit),"^",2)
	.s Serial=+$P(SerBarcode,"-",2)
	.i Serial>Ser d
	..s Ser=Serial
	s NewSerial=Ser+1
	q NewSerial
}

/// Description:保存条码打印标记
/// Creator:	Lihui
/// CreatDate:	2015-10-16
/// Table:		dhc_itmtrack
/// Input:		PrintFlag
/// Return:		
ClassMethod SavePrintFlag(PrintFlag As %String, Barcode As %String) As %String
{
	n (PrintFlag,Barcode,%session)
	;s ^tmpli("SavePrintFlag")=PrintFlag_","_Barcode
	q:PrintFlag="" "" 
	q:Barcode="" ""
	&sql(UPDATE DHC_ItmTrack SET DHCIT_PrintFlag=:PrintFlag WHERE DHCIT_Label=:Barcode)
	q 0
}

/// Description:注册一个高值条码
/// Creator:	wangjiabin
/// CreatDate:	2015-07-28
/// Table:		dhc_itmtrack
/// Input:		data(inci^barcode), user, scg, date, time
/// Return:		rowid:成功, <0:失败
ClassMethod RegOne(data As %String, CreateUser As %String, StkGrpId As %String, Date As %String, Time As %String, HospId = "") As %String
{
	n (data,CreateUser,StkGrpId,Date,Time,HospId,%session)
	s appName=..%GetParameter("AppName")
	
	s IncId=$p(data,"^",1)
	s BarCode=$p(data,"^",2)
	s ret=0
	i BarCode="" d
	.s BarCode=##class(web.DHCSTMHUI.Common.AppCommon).GetAppNo(appName,StkGrpId,"",HospId)
	.i BarCode="" s ret=-99
	q:ret<0 ret
	
	s dhcit=$o(^DHCIT(0,"LABEL",BarCode,0))
	i dhcit'="" s ret=-1_"^"_BarCode
	q:dhcit'="" -1		;条码重复
	s obj=##class(User.DHCItmTrack).%New()
	s obj.DHCITINCIDR=##class(User.INCItm).%OpenId(IncId,0)
	s obj.DHCITLabel=BarCode
	s obj.DHCITDate=Date
	s obj.DHCITTime=Time
	s obj.DHCITSSUSRDR=##class(User.SSUser).%OpenId(CreateUser)
	s sc=obj.%Save()
	i $$$ISERR(sc) s ret=-5 q ret
	q obj.%Id()
}

/// Description:根据供应商打印的条码,获取具体信息
/// 			望京:为方便区分各段信息,条码使用-隔开(供应商前缀-InciCode-效期-打印日期-流水号)
/// 			批号如需添加,建议放在后面(主要是考虑到批号内经常存在一些特殊字符)
/// Creator:	wangjiabin
/// CreatDate:	2016-04-25
/// Input:		供应商打印的高值条码
/// Return:		+Str<0:失败, 其他:信息串
/// W ##class(web.DHCSTMHUI.DHCItmTrack).GetItmInfoByBarCode("SHDS-M00157-220105-111000-123-2201050007")
ClassMethod GetItmInfoByBarCode(BarCode As %String, Params As %String) As %String
{
	n (BarCode,Params,%session)
	s RtnObj=##class(RtnObj).%New()
	i BarCode="" q RtnObj.Err(-1,"","参数错误!","",0).Json()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","参数解析错误!").Json()
	s LocId=PJObj.%Get("LocId")
	s HospId=$s(LocId'="":$p(^CTLOC(LocId),"^",22),1:"")
	i HospId="" q RtnObj.Err(-1,"","科室信息有误!","",0).Json()
	
	&sql(select %id from DHC_ItmTrack where DHCIT_Label=:BarCode)
	i SQLCODE=0 q RtnObj.Err(-99,"","该条码已存在!","",0).Json()
	
	s Len=$l(BarCode,"-")
	s VendorPre=$p(BarCode,"-",1)
	s InciCode=$p(BarCode,"-",2)
	s ExpDate=$p(BarCode,"-",3)			;(6位日期格式yymmdd)
	s BatchNo=$p(BarCode,"-",4)
	s SpecDesc=$p(BarCode,"-",5)
	i (ExpDate'="")&&($l(ExpDate)=6) s ExpDate="20"_ExpDate
	i ExpDate'="" d
	.s ExpDate=$zdh(ExpDate,8)
	.s ExpDate=..DL2H(ExpDate)
	
	&sql(select %id,Inci_Code,Inci_Desc into :InciId,:InciCode,:InciDesc from INC_Itm where INCI_Code=:InciCode)
	i SQLCODE'=0 q RtnObj.Err(-1,"","物资信息错误!","",0).Json()
	
	s VendorId=##class(web.DHCSTMHUI.APCVenNew).GetVendorId("BARCODE",VendorPre,HospId,"M")
	i VendorId="" q RtnObj.Err(-2,"","供应商信息错误!","",0).Json()
	s VendorDesc=$p(^APC("APCVM",VendorId),"^",3)
	
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	s ScgDesc=$p(ScgInfo,"^",2)
	s ScgId=$p(ScgInfo,"^",5)
	
	s DataStr=InciId_"^"_InciCode_"^"_InciDesc_"^"_VendorId_"^"_VendorDesc
		_"^"_ExpDate_"^"_ScgId_"^"_ScgDesc_"^"_BatchNo_"^"_SpecDesc
	s TitleStr="InciId^InciCode^InciDesc^VendorId^VendorDesc"
		_"^ExpDate^ScgId^ScgDesc^BatchNo^SpecDesc"
	s InfoStr=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(DataStr,TitleStr)
	q InfoStr
}

/// Descrpiton:库房确认高值
/// Date:20160530
/// W ##class(web.DHCSTMHUI.DHCItmTrack).SaveHv("WJWS20170314001")
ClassMethod SaveHv(label) As %String
{
	n (label,%session)
	s RtnObj=##class(RtnObj).%New()
	s DHCITRet="Y"
	s hvm=$o(^DHCHVMORI(0,"BARCODE",label,""),-1)
	i hvm="" d
	.s dhcit=$o(^DHCIT(0,"LABEL",label,0))
	.s:(dhcit'="") label=$p($g(^DHCIT(dhcit)),"^",13) //自带条码
	.s:(label'="") hvm=$o(^DHCHVMORI(0,"BARCODE",label,""),-1)
	i hvm="" d RtnObj.Err(-1,"","不存在高值提取记录","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	s RetFlag=""
	&sql(select ORI_RetOriFlag into :RetFlag from dhc_hvmat_orditm where ORI_RowId=:hvm)
	i RetFlag="Y" d RtnObj.Err(-2,"","已确认","",0)
	q:RtnObj.success'=0 RtnObj.Json()
	&sql(update dhc_hvmat_orditm set ORI_RetOriFlag=:DHCITRet where ORI_RowId=:hvm)	
	i SQLCODE'=0 d RtnObj.Err(-3,"","更新标志失败!")
	q RtnObj.Json()
}

/// Description:获取高值包下关联的物资的条码,效期等信息
/// Creator:	wangjiabin
/// CreatDate:	2016-09-01
/// Table:		DHC_ItmTrackPackItm
/// Input:		
/// Return:		
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetPackItm("{""DHCIT"":585}")
ClassMethod GetPackItm(Params As %String) As %String
{
	n (Params,%session)
	s RtnObj=##class(RtnObj).%New()
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Params)
	i Sc'=0 q RtnObj.Err(-1,"","参数解析错误!").Json()
	
	s DHCIT=PJObj.%Get("DHCIT")
	i DHCIT="" w $$$NullJson q
	s InciStr=..GetPackInciStr(DHCIT)
	i InciStr="" w $$$NullJson q
	
	s Count=0
	s json=##class(web.DHCSTMHUI.Common.JsonObj).%New()
	s Len=$l(InciStr,"^")
	f i=1:1:Len d
	.s Inci=$p(InciStr,"^",i)
	.s InciCode=$p(^INCI(Inci,1),"^",1)
	.s InciDesc=$p(^INCI(Inci,1),"^",2)
	.s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",Inci)
	.s (RowId,OriginalCode,BatchNo,ExpDate,ManfId,ManfDesc)=""
	.
	.i '$d(^DHCIT(0,"PACKINCI",Inci,DHCIT)) d
	..d InsertPackItmRowData
	.e  d
	..s Ch=0
	..f  s Ch=$o(^DHCIT(0,"PACKINCI",Inci,DHCIT,Ch)) q:Ch=""  d
	...s RowId=DHCIT_"||"_Ch
	...s ItmInfo=^DHCIT(DHCIT,"PACKITM",Ch)
	...s OriginalCode=$p(ItmInfo,"^",2)
	...s BatchNo=$p(ItmInfo,"^",3)
	...s ExpDate=$p(ItmInfo,"^",4)
	...s ManfId=$p(ItmInfo,"^",5)
	...s:ExpDate'="" ExpDate=..DL2H(ExpDate)
	...s:ManfId'="" ManfDesc=$p(^PHMNF(ManfId),"^",2)
	...d InsertPackItmRowData
	
	s TitleStr="RowId^InciId^InciCode^InciDesc^OriginalCode"
		_"^BatchNo^ExpDate^ManfId^ManfDesc^Spec"
	d json.getJsonData(TitleStr,Count)
InsertPackItmRowData
	s Data1=RowId_"^"_Inci_"^"_InciCode_"^"_InciDesc_"^"_OriginalCode
	s Data2=BatchNo_"^"_ExpDate_"^"_ManfId_"^"_ManfDesc_"^"_Spec
	s DataStr=Data1_"^"_Data2
	s Count=Count+1
	d json.InsertRowData(DataStr)
	q
}

/// Description:获取高值包下关联的物资的InciId串(^隔开)
/// Creator:	wangjiabin
/// CreatDate:	2017-04-05
/// Table:		DHC_ItmTrackPackItm
/// Input:		高值条码rowid
/// Return:		
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetPackInciStr(263)
ClassMethod GetPackInciStr(dhcit As %String) As %String
{
	n (dhcit,%session)
	q:dhcit="" ""
	s dhcitInci=$p(^DHCIT(dhcit),"^",1)
	q:dhcitInci="" ""
	
	s InciStr=""
	s PCLRowId=0
	f  s PCLRowId=$o(^DHCPCL(0,"PACK",dhcitInci,PCLRowId)) q:PCLRowId=""  d
	.s inci=$p(^DHCPCL(PCLRowId),"^",2)
	.i InciStr="" d
	..s InciStr=inci
	.e  d
	..q:("^"_InciStr_"^")[("^"_inci_"^")
	..s InciStr=InciStr_"^"_inci
	
	s ch=0
	f  s ch=$o(^DHCIT(dhcit,"PACKITM",ch)) q:ch=""  d
	.s inci=$p(^DHCIT(dhcit,"PACKITM",ch),"^",1)
	.i InciStr="" d
	..s InciStr=inci
	.e  d
	..q:("^"_InciStr_"^")[("^"_inci_"^")
	..s InciStr=InciStr_"^"_inci
	
	q InciStr
}

/// Description:记录高值包下的物资的批号等信息
/// Creator:	wangjiabin
/// CreatDate:	2016-09-01
/// Table:		DHC_ItmTrackPackItm
/// Input:		dhcit(dhc_itmtrack的RowId), ListDetail明细信息(dhcitpi^inci^自带条码^批号^效期^生产厂家id_$c(1)_...)
/// Return:		
/// w ##class(web.DHCSTMHUI.DHCItmTrack).SavePackItm
ClassMethod SavePackItm(DHCIT As %String, Detail As %String) As %String
{
	n (DHCIT,Detail,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i (DHCIT="")||(Detail="") q RtnObj.Err(-1,"","参数错误!","",0).Json()
	s Status=$p(^DHCIT(DHCIT),"^",5)
	i (Status'="")&&(Status'="Enable") q RtnObj.Err(-2,DHCIT,"条码不是可用状态,不可修改!","",0).Json()
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=PJObj.%FromJSON(Detail)
	i Sc'=0 q RtnObj.Err(-5,DHCIT,"参数解析错误!").Json()
	ts
	while(RtnObj.success=0){
		s Obj=##class(web.DHCSTMHUI.Common.FromJson).%New()
		s Obj=PJObj.%Pop()
		q:Obj=""
		
		s RowId=Obj.%Get("RowId")
		s InciId=Obj.%Get("InciId")
		s OriginalCode=Obj.%Get("OriginalCode")
		s BatchNo=Obj.%Get("BatchNo")
		s ExpDate=Obj.%Get("ExpDate")
		s:ExpDate'="" ExpDate=..DH2L(ExpDate)
		s ManfId=Obj.%Get("ManfId")
	
		i RowId'="" d
		.s PackItmObj=##class(User.DHCItmTrackPackItm).%OpenId(RowId)
		e  d
		.s PackItmObj=##class(User.DHCItmTrackPackItm).%New()
		.s PackItmObj.DHCITPIDHCITParref=##class(User.DHCItmTrack).%OpenId(DHCIT)
		.s Ch=1+$o(^DHCIT(DHCIT,"PACKITM",""),-1)
		.s PackItmObj.DHCITPIChildSub=Ch
		.d PackItmObj.DHCITPIINCIDRSetObjectId(InciId)
		
		s PackItmObj.DHCITPIOriginalCode=OriginalCode
		s PackItmObj.DHCITPIBatchNo=BatchNo
		s PackItmObj.DHCITPIExpDate=ExpDate
		d PackItmObj.DHCITPIPHMNFDRSetObjectId(ManfId)
		s Sc=PackItmObj.%Save()
		i $$$ISERR(Sc) d RtnObj.Err(-10,DHCIT,"保存失败:"_$g(%msg))
		q:RtnObj.success<0
	}
	i RtnObj.success<0 tro  q RtnObj.Json()
	tc
	q RtnObj.Json()
}

/// Descript:	质量跟踪打印
/// Creator:	xuchao
/// CreateDate:	2017-04-28
/// Table:		DHC_ItmTrack
/// Input:		trackId(主表rowid)
/// Output:     
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCItmTrack","GetTrackInfo",2)
Query GetTrackInfo(TrackId As %String) As Query(ROWSPEC = "incidesc,manfdesc,BusinessRegNo,vendordec,inforemark,batno,expdate,spec,sp:%Float,rp:%Float,incicode,itmtrackid,paNo,paName,paLocDesc,paDate,paSex,paAge,origin") [ SqlProc ]
{
}

ClassMethod GetTrackInfoExecute(ByRef qHandle As %Binary, TrackId As %String) As %Status
{
	n (qHandle,TrackId,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:TrackId="" $$$OK
	s inci=$p(^DHCIT(TrackId),"^",1)
	q:inci="" ""
	
	s status=$p(^DHCIT(TrackId),"^",5)
	s locid=$p(^DHCIT(TrackId),"^",6)
	s incib=$p(^DHCIT(TrackId),"^",7)
	s vendor=$p(^DHCIT(TrackId),"^",11) ;供应商id
	s inclb=$p(^DHCIT(TrackId),"^",12)
	s TrackDetailId=$O(^DHCITD(TrackId,"I",""),-1)
	s pointer=""
	s type=""
	i TrackDetailId'="" d
	.s pointer=$P(^DHCITD(TrackId,"I",TrackDetailId),"^",1)
	.s type=$P(^DHCITD(TrackId,"I",TrackDetailId),"^",2)
	s (operNo,paNo,paName,paLocDesc,paDate,paSex,dob)=""
	i (type="P")||(type="F")||(type="MP")||(type="MF") d
	.&sql(select OEORI_PrescNo,oeori_oeord_parref->oeord_adm_dr->paadm_papmi_dr->papmi_no,oeori_oeord_parref->oeord_adm_dr->paadm_papmi_dr->papmi_name,OEORI_AdmLoc_DR->CTLoc_Desc,OeOri_Date,oeori_oeord_parref->oeord_adm_dr->paadm_papmi_dr->papmi_sex_dr->ctsex_desc,oeori_oeord_parref->oeord_adm_dr->paadm_papmi_dr->PAPMI_DOB
		into :operNo,:paNo,:paName,:paLocDesc,:paDate,:paSex,:dob from oe_orditem where %id=:pointer)
	s incidesc=$p(^INCI(inci,1),"^",2) ;物资名称
	s incicode=$p(^INCI(inci,1),"^",1) ;物资代码
	s dhcitm=""   ;库存项附加表
	s dhcitm=$o(^DHCITMINFO(0,"INCI",inci,0))
	s inforemark="",origin=""
	s:dhcitm'="" origin=$p(^DHCITMINFO(dhcitm),"^",100)
	s:origin'="" origin=$p(^DHCSTORI(origin),"^",2)
	s INFOMatRegCertDR=$p(^DHCITMINFO(dhcitm,1),"^",18)
	s:INFOMatRegCertDR'="" inforemark=$p(^DHCMRCT(INFOMatRegCertDR),"^",12) ;物资注册证号
	
	s (batno,expdate,manf,manfdesc,BusinessRegNo,sp,rp,vendordec)=""
	i incib'="" d
	.s batno=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",1)  ;批号
	.s expdate=$p(^INCI($p(incib,"||",1),"IB",$p(incib,"||",2)),"^",2) ;效期
	.s dhcincib=""
	.s dhcincib=$o(^DHCINCIB(0,"INCIB",incib,0))
	.i dhcincib'="" d
	..s sp=$p(^DHCINCIB(dhcincib),"^",5)  ;售价
	..s rp=$p(^DHCINCIB(dhcincib),"^",3)  ;进价
	..s manf=$p(^DHCINCIB(dhcincib),"^",7) ;生产厂家id
	..i manf'="" d
	...s manfdesc=$p(^PHMNF(manf),"^",2)
	...s manfadd=$o(^DHCMANF(0,"MANF",manf,0))
	...i manfadd'="" d
	....s BusinessRegNo=$p(^DHCMANF(manfadd),"^",11) ;生产厂家工商注册证号
	
	i vendor'="" d
	.s vendordec=$p(^APC("APCVM",vendor),"^",3)
	s uom=$p(^INCI(inci,1),"^",10)
	s uomDesc=$p($g(^CT("UOM",uom)),"^",2) ;单位
	s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci) ;规格
	i sp="" d
	.s sp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(inci,+$H,uom,"")
	s:+expdate'=0 expdate=..DL2H(expdate)
	s:+paDate'=0 paDate=..DL2H(paDate)
	s paAge=""
	s:dob'="" paAge=$SYSTEM.SQL.DATEDIFF("yyyy",dob,+$h)

	;物资名称^生产厂家^生产厂家工商注册证号^供应商名称^物资注册证号^批号^效期^规格^售价^进价
	d OutPut
	Quit $$$OK
	
OutPut
	s Data=$lb(incidesc,manfdesc,BusinessRegNo,vendordec,inforemark,
		batno,expdate,spec,sp,rp,
		incicode,itmtrackid,paNo,paName,paLocDesc,paDate,paSex,paAge,origin)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Description:记录台账ID到高值跟踪明细
/// Creator:	lihui
/// CreatDate:	2017-08-31
/// Table:		DHC_ItmTrackDetail
/// Input:		DHCIT( DHC_ItmTrack 的RowId),台账ID,业务类型type,业务ID
/// Return:		0 成功;其他 错误;
/// w ##class(web.DHCSTMHUI.DHCItmTrack).UpdateDhcitIntrID(15687,80183,"P","371||1390")
ClassMethod UpdateDhcitIntrID(DHCIT As %String, Intrid As %String, Type As %String, Pionter As %String) As %String
{
	n (DHCIT,Intrid,Type,Pionter,%session)
	q:DHCIT="" -1
	q:Intrid="" -1
	q:Type="" -1
	q:Pionter="" -1 
	
	s ret=0
	s chl=$o(^DHCITD(0,"Type",Type,"Pointer",Pionter,DHCIT,""),-1)
	q:chl="" -2
	s dhcitd=DHCIT_"||"_chl
	q:'$d(^DHCITD(DHCIT,"I",chl)) -2
	s obj=##class(User.DHCItmTrackDetail).%OpenId(dhcitd)
	d obj.%Reload()
	d obj.DHCITDINTRDRSetObjectId(Intrid)
	s sc=obj.%Save()
	i $$$ISERR(sc) s ret=-3
	i ret'="" q ret
	q ret
}

/// Description:获取跟踪明细记录中台账ID
/// Creator:	lihui
/// CreatDate:	2017-08-31
/// Table:		DHC_ItmTrackDetail
/// Input:		DHCIT( DHC_ItmTrack 的RowId),业务类型type,业务ID
/// Return:		台账ID 成功;其他 错误;
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetDhcitIntrID(15687,"P","371||1390")
ClassMethod GetDhcitIntrID(DHCIT As %String, Type As %String, Pionter As %String) As %String
{
	n (DHCIT,Type,Pionter,%session)
	q:DHCIT="" -1
	q:Type="" -1
	q:Pionter="" -1 
	
	s ret=0
	s chl=$o(^DHCITD(0,"Type",Type,"Pointer",Pionter,DHCIT,""),-1)
	q:chl="" -2
	s dhcitd=DHCIT_"||"_chl
	q:'$d(^DHCITD(DHCIT,"I",chl)) -2
	s obj=##class(User.DHCItmTrackDetail).%OpenId(dhcitd)
	d obj.%Reload()
	s intrid=obj.DHCITDINTRDRGetObjectId()
	q intrid
}

/// Descrpiton: 判断条码是否重复
/// Date: 20171111
/// return: 0 则不重复,1 则重复
/// W ##class(web.DHCSTMHUI.DHCItmTrack).UpOriBarToOldOriBar("WJWSGZ20161020002")
ClassMethod OriBarIfExit(OriBarcode As %String) As %String
{
	n (OriBarcode,%session)
	q:OriBarcode="" 0
	s ret=0
	s DHCITid=$o(^DHCIT(0,"ORIGINALCODE",OriBarcode,""))
	if DHCITid'="" d
	.s ret=1	
	q ret
}

/// Descrpiton: 处理高值退货自带条码保存到新的字段
/// Date: 20171110
/// return: 0 成功,非0 失败
/// W ##class(web.DHCSTMHUI.DHCItmTrack).UpOriBarToOldOriBar("WJWSGZ20161020002")
ClassMethod UpOriBarToOldOriBar(label) As %String
{
	n (label,%session)
	q:label="" 0
	s ret=0,tmporibar=""
	s DHCITid=$o(^DHCIT(0,"LABEL",label,""))
	q:'$d(^DHCIT(DHCITid)) 0
	s oribarcode=$p(^DHCIT(DHCITid),"^",13)
	q:oribarcode="" 0
	&sql(UPDATE DHC_ItmTrack SET DHCIT_OldOriginalBarcode=:oribarcode, DHCIT_OriginalCode=:tmporibar WHERE DHCIT_Rowid=:DHCITid)
	if SQLCODE d
	.s ret=-1	
	q ret
}

/// Description:高值条码注册
/// InPut:		
/// Output:		{success:**,rowid:RowIdStr,....}
/// w ##class(web.DHCSTMHUI.DHCItmTrack).RegHV(^templxt("1111111"),^templxt("222222"))
ClassMethod jsRegHV(MainInfo As %String, ListDetail) As %String
{
	n (MainInfo,ListDetail,%session)
	s RtnObj=##class(RtnObj).%New()
	s RtnObj=..RegHV(MainInfo,ListDetail)
	q RtnObj.Json()
}

/// Description:高值条码注册
/// InPut:		
/// Output:		{success:**,rowid:RowIdStr,....}
/// w ##class(web.DHCSTMHUI.DHCItmTrack).RegHV(^templxt("1111111"),^templxt("222222"))
ClassMethod RegHV(MainInfo As %String, ListDetail) As %String
{
	n (MainInfo,ListDetail,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	i (MainInfo="")||(ListDetail="") q RtnObj.Err(-1,"","参数错误!","",0)
	
	s MainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainObj.%FromJSON(MainInfo)
	q:Sc'=0 RtnObj.Err(-1,"","参数解析错误!")
	
	s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc2=DetailObj.%FromJSON(ListDetail)
	q:Sc2'=0 Sc2=RtnObj.Err(-1,"","参数解析错误!")

	s CreateUser=MainObj.%Get("gUserId")
	s StkGrpId=MainObj.%Get("ScgId")
	s InGdRecLocId=MainObj.%Get("InGdRecLocId")
	s gLocId=MainObj.%Get("gLocId")
	s LogID=MainObj.%Get("RecLocId")
	s:LogID="" LogID=gLocId  ;高值紧急给科室使用 保存后导致无法查询出来数据
	s:LogID="" LogID=InGdRecLocId
	s HospId=..sssHospId(LogID)
	s Date=+$h
	s Time=$p($h,",",2)
	s RowIdStr="",barcodes=""
	ts
	While(RtnObj.success=0) {
		s ItmObj=DetailObj.%Pop()
		q:ItmObj=""
		
		s RowId=ItmObj.%Get("RowId")
		s InciId=ItmObj.%Get("InciId")
		q:InciId=""

		i RowId="" d
		.s RtnObj=..UpdateReg(ItmObj,CreateUser,StkGrpId,Date,Time,LogID,.barcodes)
		.s RowId=RtnObj.rowid
		e  d
		.s RtnObj=..UpdateBarcode(ItmObj,CreateUser,Date,Time)
		q:RtnObj.success<0
		
		i RowIdStr="" s RowIdStr=RowId
		e  s RowIdStr=RowIdStr_","_RowId
	}
	i RtnObj.success'=0 tro  q RtnObj
	tc
	i barcodes'="" d
	.d ##class(web.DHCSTMHUI.ServiceForSCI).updateHvOrder("T",barcodes)
	.d ##class(web.DHCSTMHUI.ServiceForECS).SaveHVBarCode(barcodes,HospId)
	s RtnObj.rowid=RowIdStr
	q RtnObj
}

/// CreatDate:	2015-04-14
/// Description:修改条码信息
/// Table:		dhc_itmtrack
/// Input:		data(dhcit^inci^高值条码^条码数量^自带条码^inpoi^批号^效期^具体规格^生产日期^注册证号^注册证日期^进价^生产厂家id_$c(1)_...),
/// 			修改人,操作日期,操作时间
/// OutPut:		0:成功, 其他:失败
ClassMethod UpdateBarcode(ItmObj, CreateUser, Date, Time) As RtnObj [ Private ]
{
	n (ItmObj,CreateUser,Date,Time,%session)
	s RtnObj=##class(RtnObj).%New()
	
	s RowId=ItmObj.%Get("RowId")
	s BarCode=ItmObj.%Get("BarCode")
	s OriginalCode=ItmObj.%Get("OriginalCode")
	s BatchNo=ItmObj.%Get("BatchNo")
	s ExpDate=ItmObj.%Get("ExpDate")
	s:ExpDate'="" ExpDate=..DH2L(ExpDate)
	s SpecDesc=ItmObj.%Get("SpecDesc")
	s ProduceDate=ItmObj.%Get("ProduceDate")
	s:ProduceDate'="" ProduceDate=..DH2L(ProduceDate)
	s CertNo=ItmObj.%Get("CertNo")
	s CertExpDate=ItmObj.%Get("CertExpDate")
	s:CertExpDate'="" CertExpDate=..DH2L(CertExpDate)
	s Rp=ItmObj.%Get("Rp")
	s ManfId=ItmObj.%Get("ManfId")
	s VendorId=ItmObj.%Get("VendorId")
	s BatchCode=ItmObj.%Get("BatchCode")
	s Qty=ItmObj.%Get("Qty")
	
	i OriginalCode'="" d
	.&sql(select %id into :dhcit from DHC_ItmTrack where DHCIT_Label=:OriginalCode or DHCIT_OriginalCode=:OriginalCode)
	.i (SQLCODE=0)&&(dhcit'="")&&(dhcit'=RowId) d RtnObj.Err(-21,RowId,"自带条码"_OriginalCode_"重复!","",0)
	q:RtnObj.success<0 RtnObj
	
	i BatchCode'="" d
	.s InciId=$p(^DHCIT(RowId),"^",1)
	.&sql(select %id from DHC_ItmTrack where DHCIT_BatchCode=:BatchCode and DHCIT_INCI_DR<>:InciId)
	.i (SQLCODE=0) d RtnObj.Err(-21,RowId,"批次条码"_OriginalCode_"重复!","",0) q
	
	s obj=##class(User.DHCItmTrack).%OpenId(RowId)
	s obj.DHCITOriginalCode=OriginalCode
	s obj.DHCITDate=Date
	s obj.DHCITTime=Time
	d obj.DHCITPHMNFDRSetObjectId(ManfId)
	s obj.DHCITRealPrice=Rp
	s obj.DHCITBatchNo=BatchNo
	s obj.DHCITExpDate=ExpDate
	s obj.DHCITSpecList=SpecDesc
	s obj.DHCITProduceDate=ProduceDate
	s obj.DHCITCertNo=CertNo
	s obj.DHCITCertExpDate=CertExpDate
	d obj.DHCITAPCVMDRSetObjectId(VendorId)
	s obj.DHCITBatchCode=BatchCode
	s obj.DHCITQty=Qty
	s sc=obj.%Save()
	i $$$ISERR(sc) d RtnObj.Err(-22,"","注册条码失败") q RtnObj
	q RtnObj
}

/// Description:注册条码(将送货单id拼成串发送到平台20180116lihui)
/// Table:		dhc_itmtrack
/// Input:		data(dhcit^inci^高值条码^条码数量^自带条码^inpoi^批号^效期^具体规格^生产日期^注册证号^注册证日期^进价^生产厂家id_$c(1)_...),
/// 			注册人id, 类组id, 日期, 时间
/// OutPut:		0:成功, <0:失败
/// w ##class(web.DHCSTMHUI.DHCItmTrack).UpdateRegNew("^1422^^1^^^^^^^^^400^630^660^",541,12,64327,56575,153)
ClassMethod UpdateReg(ItmObj, CreateUser, StkGrpId, Date, Time, RegLocId, barcodes) As RtnObj
{
	n (ItmObj,CreateUser,StkGrpId,Date,Time,RegLocId,barcodes,%session)
	s RtnObj=##class(RtnObj).%New()
	;dhcit_ownloc_dr(条码注册所属科室,按实库记录)
	s MainLoc=""
	&sql(select DHCLoc_MainLoc_DR into :MainLoc from DHCST_CTloc where DHCLoc_Ctloc_dr=:RegLocId)
	i (SQLCODE=0)&&(MainLoc'="") d
	.s RegLocId=MainLoc
	
	s InciId=ItmObj.%Get("InciId")
	s BatchReq=$p(^INCI(InciId,2),"^",10)
	s ExpReq=$p(^INCI(InciId,2),"^",11)
	s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
	s ScgId=$p(ScgInfo,"^",5)
	s BarCodeParam=ScgId_"^"_RegLocId
	
	s BarCode=ItmObj.%Get("BarCode")
	s Qty=ItmObj.%Get("Qty")
	s:Qty="" Qty=1
	s OriginalCode=ItmObj.%Get("OriginalCode")
	s Inpoi=ItmObj.%Get("Inpoi")
	s BatchNo=ItmObj.%Get("BatchNo")
	q:(BatchReq="R")&&(BatchNo="") RtnObj.Err(-11,"",BarCode_":批号不允许为空!","",0)
	s ExpDate=ItmObj.%Get("ExpDate")
	q:(ExpReq="R")&&(ExpDate="") RtnObj.Err(-12,"",BarCode_":有效期不允许为空!","",0)
	s:ExpDate'="" ExpDate=..DH2L(ExpDate)
	s SpecDesc=ItmObj.%Get("SpecDesc")
	s ProduceDate=ItmObj.%Get("ProduceDate")
	s:ProduceDate'="" ProduceDate=..DH2L(ProduceDate)
	s CertNo=ItmObj.%Get("CertNo")
	s CertExpDate=ItmObj.%Get("CertExpDate")
	s:CertExpDate'="" CertExpDate=..DH2L(CertExpDate)
	s Rp=ItmObj.%Get("Rp")
	s ManfId=ItmObj.%Get("ManfId")
	s VendorId=ItmObj.%Get("VendorId")
	s OrderDetailSubId=ItmObj.%Get("OrderDetailSubId")
	s SxNo=ItmObj.%Get("SxNo")
	s BatchCode=ItmObj.%Get("BatchCode")
	s Status=ItmObj.%Get("Status")
	s:Status'="Temp" Status=""	//Temp大批量导入高值时的临时状态
	s BatchCodeFlag=ItmObj.%Get("BatchCodeFlag")
	q:(BatchCodeFlag="Y")&&(BatchCode="") RtnObj.Err(-13,"","批次码管理的高值自带批次码不能为空!","",0)
	
	s RowIdStr=""
	i BatchCodeFlag="Y" d
	.s BarCode=BatchCode
	.;i BarCode="" s BarCode=..CreateBarCode(BarCodeParam)
	.;判断条码是否重复
	.&sql(select %id from DHC_ItmTrack where DHCIT_Label=:BarCode or DHCIT_OriginalCode=:BarCode)
	.i (SQLCODE=0) d RtnObj.Err(-14,"","批次条码"_BarCode_"重复!","",0) q
	.
	.i OriginalCode'="" d
	..&sql(select %id from DHC_ItmTrack where DHCIT_Label=:OriginalCode or DHCIT_OriginalCode=:OriginalCode)
	..i (SQLCODE=0) d RtnObj.Err(-15,"","自带条码"_OriginalCode_"重复!","",0) q
	.
	.s OriginalStatus="NotUnique"
	.s obj=##class(User.DHCItmTrack).%New()
	.d obj.DHCITINCIDRSetObjectId(InciId)
	.s obj.DHCITLabel=BarCode
	.s obj.DHCITOriginalCode=OriginalCode
	.s obj.DHCITDate=Date
	.s obj.DHCITTime=Time
	.d obj.DHCITSSUSRDRSetObjectId(CreateUser)
	.d obj.DHCITINPOIDRSetObjectId(Inpoi)
	.d obj.DHCITPHMNFDRSetObjectId(ManfId)
	.s obj.DHCITRealPrice=Rp
	.s obj.DHCITBatchNo=BatchNo
	.s obj.DHCITExpDate=ExpDate
	.s obj.DHCITSpecList=SpecDesc
	.s obj.DHCITProduceDate=ProduceDate
	.s obj.DHCITCertNo=CertNo
	.s obj.DHCITCertExpDate=CertExpDate
	.d obj.DHCITAPCVMDRSetObjectId(VendorId)
	.s obj.DHCITOrderDetailSubId=OrderDetailSubId
	.d obj.DHCITOwnLocDRSetObjectId(RegLocId)
	.s obj.DHCITSxNo=SxNo
	.s obj.DHCITBatchCode=BatchCode
	.s obj.DHCITStatus=Status
	.s obj.DHCITOriginalStatus=OriginalStatus
	.s obj.DHCITQty=Qty
	.s sc=obj.%Save()
	.i $$$ISERR(sc) d RtnObj.Err(-16,"","注册条码失败") q
	.s RowId=obj.%Id()
	.s RowIdStr=RowId
	.i OrderDetailSubId'="" d  ;平台订单操作同步条码状态
	..s barcodes=BarCode
	e  d
	.f i=1:1:Qty d
	..i (BarCode="")||(Qty'=1) d
	...s BarCode=..CreateBarCode(BarCodeParam)
	...i BarCode="" d RtnObj.Err(-17,"","条码生成失败!")
	..q:RtnObj.success<0
	..
	..;判断条码是否重复
	..&sql(select %id from DHC_ItmTrack where DHCIT_Label=:BarCode or DHCIT_OriginalCode=:BarCode)
	..i (SQLCODE=0) d RtnObj.Err(-18,"","生成条码"_BarCode_"重复!","",0) q
	..
	..i OriginalCode'="" d
	...&sql(select %id from DHC_ItmTrack where DHCIT_Label=:OriginalCode or DHCIT_OriginalCode=:OriginalCode)
	...i (SQLCODE=0) d RtnObj.Err(-18,"","自带条码"_OriginalCode_"重复!","",0) q
	..
	..i BatchCode'="" d
	...&sql(select %id from DHC_ItmTrack where DHCIT_BatchCode=:BatchCode and DHCIT_INCI_DR<>:InciId)
	...i (SQLCODE=0) d RtnObj.Err(-18,"","批次条码"_OriginalCode_"重复!","",0) q
	..
	..s TmpQty=1
	..s obj=##class(User.DHCItmTrack).%New()
	..d obj.DHCITINCIDRSetObjectId(InciId)
	..s obj.DHCITLabel=BarCode
	..s obj.DHCITOriginalCode=OriginalCode
	..s obj.DHCITDate=Date
	..s obj.DHCITTime=Time
	..d obj.DHCITSSUSRDRSetObjectId(CreateUser)
	..d obj.DHCITINPOIDRSetObjectId(Inpoi)
	..d obj.DHCITPHMNFDRSetObjectId(ManfId)
	..s obj.DHCITRealPrice=Rp
	..s obj.DHCITBatchNo=BatchNo
	..s obj.DHCITExpDate=ExpDate
	..s obj.DHCITSpecList=SpecDesc
	..s obj.DHCITProduceDate=ProduceDate
	..s obj.DHCITCertNo=CertNo
	..s obj.DHCITCertExpDate=CertExpDate
	..d obj.DHCITAPCVMDRSetObjectId(VendorId)
	..s obj.DHCITOrderDetailSubId=OrderDetailSubId
	..d obj.DHCITOwnLocDRSetObjectId(RegLocId)
	..s obj.DHCITSxNo=SxNo
	..s obj.DHCITBatchCode=BatchCode
	..s obj.DHCITStatus=Status
	..s obj.DHCITOriginalStatus=Status
	..s obj.DHCITQty=TmpQty
	..s sc=obj.%Save()
	..i $$$ISERR(sc) d RtnObj.Err(-19,"","注册条码失败") q
	..
	..s RowId=obj.%Id()
	..i RowIdStr="" s RowIdStr=RowId
	..e  s RowIdStr=RowIdStr_","_RowId
	..
	..i OrderDetailSubId'="" d  ;平台订单操作同步条码状态
	...i barcodes="" d
	....s barcodes=BarCode
	...e  d
	....s barcodes=barcodes_"^"_BarCode
	i RtnObj.success<0 q RtnObj
	
	s RtnObj.rowid=RowIdStr
	q RtnObj
}

/// CreatDate:2013-09-18
/// update: 20181114
/// Description:查询高值条码
/// Table:dhc_itmtrack
/// Input: Start,Limit,Param(高值条码^类组id^inci^开始日期^截止日期^time^供应商^请求科室^批号^HospId^生成人员)
/// OutPut:成功返回$h失败返回负数
/// Return:条码信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCItmTrack","queryRegHVs","{""ScgId"":"""",""gUserId"":""6423"",""gLocId"":""326"",""gGroupId"":""277"",""gHospId"":""2"",""RecLocId"":"""",""StartDate"":""2020-02-24"",""ReqLocId"":"""",""EndDate"":""2020-02-25"",""FVendorBox"":"""",""Status"":""Temp"",""Inci"":"""",""OriginalStatus"":""Temp"",""BarCodeText"":"""",""InciDesc"":"""",""RowIdStr"":""""}")
Query queryRegHVs(Params As %String) As Query(ROWSPEC = "RowId,InciId,InciCode,InciDesc,Qty:%Float,BarCode,User,Date,Spec,OriginalCode,ReqNo,Brand,BatchNo,ExpDate,Sp:%Float,ReqLocDesc,SpecDesc,PbRp:%Float,MarginNow,ProduceDate,CertNo,CertExpDate,Rp:%Float,PurUomId,BUomId,ManfId,Manf,VendorId,VendorDesc,BatchReq,ExpReq,Time,PurUom,BUom,Ingri,OldOriginalCode,BatchReq,ExpReq,BatchCode,OrderDetailSubId,BatchCodeFlag,OriginalStatus,TableFlag,RpAmt")
{
}

ClassMethod queryRegHVsExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)

	q:Params="" $$$OK
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s PBarCodeText=PJobj.%Get("BarCodeText")
	s PScgId=PJobj.%Get("ScgId")
	s PInciDesc=PJobj.%Get("InciDesc")
	s PStartDate=PJobj.%Get("StartDate")
	s PEndDate=PJobj.%Get("EndDate")
	s PRowIdStr=PJobj.%Get("RowIdStr")
	s PVendorId=PJobj.%Get("VendorId")
	s PReqLocId=PJobj.%Get("ReqLocId")
	s PBatchNo=PJobj.%Get("BatchNo")
	s PStatus=PJobj.%Get("Status")
	
	s gHospId=PJobj.%Get("gHospId")
	s CreateUser=PJobj.%Get("gUserId")
	s gLocId=PJobj.%Get("gLocId")
	s PCreateLoc=PJobj.%Get("CreateLoc")
	s:PCreateLoc="" PCreateLoc=gLocId
	
	s POriginalCode=PJobj.%Get("OriginalCode")
	s PBatchCode=PJobj.%Get("BatchCode")
	s POriginalStatus=PJobj.%Get("OriginalStatus")		;条码类型（NotUnique批次码，""唯一码）
	s pBatchCodeFlag=PJobj.%Get("BatchCodeFlag")
	
	s PStartDate=..DH2L(PStartDate)
	s PEndDate=..DH2L(PEndDate)
	s ParamStr="^"_gLocId_"^^"_gHospId
	
	s MainLoc=""
	&sql(select DHCLoc_MainLoc_DR into :MainLoc from DHCST_CTloc where DHCLoc_Ctloc_dr=:PCreateLoc)
	i SQLCODE=0 d
	.s:MainLoc'="" PCreateLoc=MainLoc
	
	s HospId=..sssHospId(PCreateLoc)
	s:HospId="" HospId=gHospId
	s ScgStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(CreateUser,..sssCode(),PCreateLoc,PScgId,HospId)
	
	s sqlStr="select * from dhc_itmtrack where isnull(DHCIT_Status,'')='"_PStatus_"'"
	
	i PRowIdStr'="" d
	.s sqlStr=sqlStr_" and DHCIT_RowId in ("_PRowIdStr_")"
	e  i PBarCodeText'="" d
	.s sqlStr=sqlStr_" and DHCIT_Label='"_PBarCodeText_"'"
	e  d
	.s sqlStr=sqlStr_" and (DHCIT_Date between '"_PStartDate_"' and '"_PEndDate_"')"
	
	i PInciDesc'="" d
	.s sqlStr=sqlStr_" and DHCIT_INCI_DR->INCI_Desc like '%"_PInciDesc_"%'"
	
	s result = ##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	s result.RuntimeMode=0
	d result.Execute()
	While(result.Next())
	{
		s InctrackId = result.Data("DHCIT_Rowid")
		s OriginalStatus=$p(^DHCIT(InctrackId),"^",35)
		continue:(POriginalStatus'="")&&(OriginalStatus'=POriginalStatus)
		
		s OriginalCode=$p(^DHCIT(InctrackId),"^",13)
		s OldOriginalCode=$p(^DHCIT(InctrackId),"^",30)
		continue:(POriginalCode'="")&&((OriginalCode'[POriginalCode)&&(OldOriginalCode'[POriginalCode))
		
		s DhcitLoc=$p(^DHCIT(InctrackId),"^",26)
		;传入生成科室时,按该科室过滤,否则按登录科室过滤
		continue:(PCreateLoc'="")&&(DhcitLoc'="")&&(PCreateLoc'=DhcitLoc)
		
		s BatchCode=result.Data("DHCIT_BatchCode")
		continue:(PBatchCode'="")&&(BatchCode'[PBatchCode)
		
		s InciId = result.Data("DHCIT_INCI_DR")
		s VendorId=result.Data("DHCIT_APCVM_DR")
		continue:(PVendorId'="")&(PVendorId'=VendorId)
		
		s VendorDesc=$s(VendorId'="":$p($g(^APC("APCVM",VendorId)),"^",3),1:"")
		s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
		s SCG=$p(ScgInfo,"^",5)
		continue:(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_SCG_"^"))
		
		s InciCode=$P(^INCI(InciId,1),"^",1)
		s InciDesc=$P(^INCI(InciId,1),"^",2)
		s BarCode = result.Data("DHCIT_Label")
		s Date = result.Data("DHCIT_Date")
		s Date=..DL2H(Date)
		s Time = result.Data("DHCIT_Time")
		s Time=..TL2H(Time)
		s User = result.Data("DHCIT_SSUSR_DR")
		continue:(CreateUser'="")&&(User'=CreateUser)
		
		s:User'="" User=$p(^SSU("SSUSR",User),"^",2)
		s Qty = result.Data("DHCIT_Qty")
		s:Qty="" Qty=1
		s PoItmId=result.Data("DHCIT_INPOI_DR")
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		
		s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(InciId)
		s inreqi=##class(web.DHCSTMHUI.DHCINReqItmMoveStatus).GetInrqi(PoItmId,"PO")
		s (ReqNo,ReqLoc,ReqLocDesc)=""
		i +inreqi>0 d
		.s inreq=+inreqi
		.s ReqNo=$p(^INRQ(inreq),"^",1)
		.s ReqLoc=$p(^INRQ(inreq),"^",6)
		.s ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc("",ReqLoc)
		continue:(PReqLocId'="")&&(PReqLocId'=ReqLoc)
		
		s BatchNo=result.Data("DHCIT_BatchNo")
		continue:(PBatchNo'="")&&(BatchNo'[PBatchNo)
		
		s ExpDate=result.Data("DHCIT_ExpDate")
		s ExpDate=..DL2H(ExpDate)
		s SpecDesc=result.Data("DHCIT_SpecList")
		s PurUomId=$p(^INCI(InciId,3),"^",6)
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s (PurUom,BUom,Ingri)=""
		s:PurUomId'="" PurUom=$p(^CT("UOM",PurUomId),"^",2)
		s:BUomId'="" BUom=$p(^CT("UOM",BUomId),"^",2)
		s PbRp=##class(web.DHCSTMHUI.Common.PriceCommon).GetPbRp(InciId,BUomId)
		s ProduceDate=result.Data("DHCIT_ProduceDate")
		s ProduceDate=..DL2H(ProduceDate)
		s CertNo=result.Data("DHCIT_CertNo")
		s CertExpDate=result.Data("DHCIT_CertExpDate")
		s CertExpDate=..DL2H(CertExpDate)
		s Rp=result.Data("DHCIT_RealPrice")
		i +Rp=0 d
		.;s Rp=##class(web.DHCSTMHUI.Common.PriceCommon).GetInciLRp(InciId,BUomId,HospId)
		s RpAmt=Rp*Qty
		s Sp=##class(web.DHCSTMHUI.DHCINGdRec).GetSpForRec(InciId,BUomId,Rp,ParamStr)
		s MarginNow=$s(+Rp>0:Sp/Rp-1,1:"")
		s:MarginNow'="" MarginNow=$fn(MarginNow,"",3)
		s ManfId=result.Data("DHCIT_PHMNF_DR")
		s ManfDesc=$s(ManfId'="":$p($g(^PHMNF(ManfId)),"^",2),1:"")
		
		s sxno=result.Data("DHCIT_SxNo")
		s OriginalStatus=result.Data("DHCIT_OriginalStatus")
		s BatchReq=$p(^INCI(InciId,2),"^",10)
		s ExpReq=$p(^INCI(InciId,2),"^",11)
		&sql(select dhcitd_pointer into :Ingri from dhc_itmtrackdetail where dhcitd_parref->dhcit_label=:BarCode and dhcitd_type='G')
		s OrderDetailSubId=$p(^DHCIT(InctrackId),"^",25)
		s BatchCodeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBatchCodeFlag(InciId)
		s TableFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetTableFlag(InciId)
		continue:(pBatchCodeFlag'="")&&(pBatchCodeFlag'=BatchCodeFlag)
		d OutPutRow
	}
	Quit $$$OK

OutPutRow
	s Data=$lb(InctrackId,InciId,InciCode,InciDesc,Qty,
		BarCode,User,Date,Spec,OriginalCode,
		ReqNo,Brand,BatchNo,ExpDate,Sp,
		ReqLocDesc,SpecDesc,PbRp,MarginNow,ProduceDate,
		CertNo,CertExpDate,Rp,PurUomId,
		BUomId,ManfId,ManfDesc,VendorId,VendorDesc,
		BatchReq,ExpReq,Time,PurUom,BUom,
		Ingri,OldOriginalCode,BatchReq,ExpReq,BatchCode,
		OrderDetailSubId,BatchCodeFlag,OriginalStatus,TableFlag,RpAmt)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// w ##class(web.DHCSTMHUI.DHCItmTrack).CreatIngr("","")
ClassMethod CreatIngr(MainInfo As %String, ListDetail) As %String
{
	n (MainInfo,ListDetail,%session)
	s $ZT=..sssError()
	s RtnObj=##class(RtnObj).%New()
	s MainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainObj.%FromJSON(MainInfo)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","参数解析错误!")
	q:RtnObj.success'=0 RtnObj.Json()

	s Sc=DetailObj.%FromJSON(ListDetail)
	i Sc'=0 d
	.s Sc=RtnObj.Err(-1,"","参数解析错误!")
	q:RtnObj.success'=0 RtnObj.Json()

	s ApcvmDr=MainObj.%Get("InGdReqVendor")
	s RecLoc=MainObj.%Get("InGdRecLocId")
	s gUserId=MainObj.%Get("gUserId") 
	s ReqLocId=MainObj.%Get("InGdReqLocId")
	s Source=MainObj.%Get("Source")
	s StkGrpId=MainObj.%Get("ScgId")

	s maintitle="IngrId^ApcvmDr^RecLoc^gUserId^GiftFlag^AdjCheque^IngrTypeId^PurchaseUser^StkGrpId^PoId^InGrRemarks^SourceOfFund^ReqLocId^SynBarcode^InitId^AcceptUserId^OeriRecflag"
	s maindata="^"_ApcvmDr_"^"_RecLoc_"^"_gUserId_"^^^^^"_StkGrpId_"^^^"_Source_"^"_ReqLocId_"^^^^"
	s nMainInfo=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(maindata,maintitle)

	s detailtitle="RowId^IncId^BatchNo^ExpDate^ManfId^IngrUomId^Rp^HVBarCode^RecQty^NewSp^SxNo^InvNo^InvDate^Inpoi^Remark^Remarks"
		_"^QualityNo^MtDr^SterilizedNo^AdmNo^AdmExpdate^InvMoney^SpecDesc^OrderDetailSubId^reqLocId^Sp^Tax^ProduceDate"
	s nndetail="["
	s count=0
	While (RtnObj.success=0) {
		s ItmObj=DetailObj.%Pop()
		q:ItmObj=""
		
		s (InvNo,InvDate,InvMoney,Remark,Remarks,QualityNo,MtDr,SterilizedNo,Tax)=""
		
		s dhcitd=ItmObj.%Get("RowId")
		s barcode=ItmObj.%Get("BarCode")
		s IncId=$P(^DHCIT(dhcitd),"^",1)
		//s BatchNo=$P(^DHCIT(dhcitd),"^",17)
		//s ExpDate=..DL2H($P(^DHCIT(dhcitd),"^",18))
		//s ManfId=$P(^DHCIT(dhcitd),"^",15)
		//s Rp=$P(^DHCIT(dhcitd),"^",16)
		s BatchNo=ItmObj.%Get("BatchNo")
		s ExpDate=..DL2H(ItmObj.%Get("ExpDate"))
		s ManfId=ItmObj.%Get("ManfId")
		s IngrUomId=ItmObj.%Get("BUomId")
		s RecQty=ItmObj.%Get("Qty")
		s Rp=ItmObj.%Get("Rp")
		s NewSp=ItmObj.%Get("Sp")
		s Sp=ItmObj.%Get("Sp")
		s SxNo=ItmObj.%Get("SxNo")
		s Inpoi=ItmObj.%Get("Inpoi")
		s ProduceDate=ItmObj.%Get("ProduceDate")
		s AdmNo=ItmObj.%Get("CertNo")
		s AdmExpdate=ItmObj.%Get("CertExpDate")
		s SpecDesc=ItmObj.%Get("SpecDesc")
		s OrderDetailSubId=ItmObj.%Get("OrderDetailSubId")
		s Status=$P(^DHCIT(dhcitd),"^",5)
		s OriginalStatus=ItmObj.%Get("OriginalStatus")
		i (Status'="")&&(OriginalStatus'="NotUnique") d RtnObj.Err(-2,"","条码"_barcode_"已入库") q
		
		s data="^"_IncId_"^"_BatchNo_"^"_ExpDate_"^"_ManfId_"^"_IngrUomId_"^"_Rp_"^"_barcode
			_"^"_RecQty_"^"_NewSp_"^"_SxNo_"^"_InvNo_"^"_InvDate_"^"_Inpoi_"^"_Remark_"^"_Remarks
			_"^"_QualityNo_"^"_MtDr_"^"_SterilizedNo_"^"_AdmNo_"^"_AdmExpdate_"^"_InvMoney_"^"_SpecDesc_"^"_OrderDetailSubId
			_"^"_""_"^"_Sp_"^"_Tax_"^"_ProduceDate
		s nDetailObj=##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(data,detailtitle)
		i count=0 d
		.s nndetail=nndetail_nDetailObj
		e  d
		.s nndetail=nndetail_","_nDetailObj
		s count=count+1

	}
	q:RtnObj.success'=0 RtnObj.Json()

	s nndetail=nndetail_"]"
	s RtnObj=##class(web.DHCSTMHUI.DHCINGdRec).Save(nMainInfo,nndetail)
	q RtnObj.Json()
}

/// Input:开始行,一页显示记录数,排序字段,排序方向,
/// 开始日期^截止日期^订单号^供应商id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)^库存项id^是否包含支配科室
/// ^请求科室^人员rowid^过滤无明细订单（明细删除/明细撤销，过滤Y，不过滤N，缺省N）
/// Output:		
/// Return：订单主表id^订单号^供应商^订购科室^订单状态^订单日期
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCItmTrack","QueryPo",^templxt("QueryPo"))
Query QueryPo(Params As %String) As Query(ROWSPEC = "RowId,PoNo,VendorId,VendorDesc,PoLocId,PoLocDesc,PoStatus,PoDate,PurUserId,PurUserName,StkGrpId,CompFlag,ReqLocId,ReqLocDesc,AuditFlag,AuditUserName,AuditDate,CancelReasonId,CancelReasonDesc")
{
}

ClassMethod QueryPoExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Params="" $$$OK

	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s pStartDate=PJobj.%Get("PoStartDate")  ;开始日期
	s pEndDate=PJobj.%Get("PoEndDate")   ;截止日期
	s pPoNo=PJobj.%Get("PoNo")  //订单号
	s pVendorId=PJobj.%Get("PoVendorBox")  //供应商id
	s pLocId=PJobj.%Get("PoRecLoc")  //科室id
	s pScgId=PJobj.%Get("Scg")
	s pIncscId=PJobj.%Get("Incsc")
	q:pLocId="" $$$OK

	s pCompFlag=PJobj.%Get("CompleteFlag")  //完成标志
	s pAuditFlag=PJobj.%Get("AuditFlag")  //审核标志
	s pStatus=PJobj.%Get("Status")  //订单状态
	s pInciId=PJobj.%Get("IncId") 
	s pIncludeDefLocPP=PJobj.%Get("IncludeDefLocPP") //是否包含支配科室
	s pReqLocId=PJobj.%Get("RequestPhaLoc")
	s pUserId=PJobj.%Get("UserId")
	s pFilterDetail=PJobj.%Get("FilterDetail")  //是否过滤无明细订单
	s pIncludeCancelInPo=PJobj.%Get("IncludeCancelInPo")
	
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)
	s HospId=..sssHospId(pLocId)
	s StkGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr(pUserId,..sssCode(),pLocId,pScgId,HospId)
	i pIncludeDefLocPP="Y" d
	.s domiLocs=##class(web.DHCSTMHUI.Common.UtilCommon).GetDominLoc(pLocId)
	.s pLocId=pLocId_","_domiLocs
	
	s sqlStr = "select IN_PO as RowId,INPO_No PoNo,INPO_APCVM_DR VendorId,INPO_APCVM_DR->APCVM_Name as VendorDesc,"
		_"INPO_Date PoDate,INPO_Completed CompFlag,INPO_Approved AuditFlag,INPO_ReasonCancFullFilled_DR as CancelReasonId,INPO_ReasonCancFullFilled_DR->CFR_Desc as CancelReasonDesc"
		_" from IN_PO"
		_" where INPO_No like '%"_pPoNo_"%'"
	i (pStartDate'="")&&(pEndDate'="") d
	.s sqlStr=sqlStr_"and (INPO_Date between "_pStartDate_" and "_pEndDate_")"

	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(sqlStr)
	s sc=result.Execute()
	i $$$ISERR(sc) q $$$OK
	While(result.Next())
	{
		s (PoLocDesc,ReqLocDesc,AuditUserName,PurUserName)=""
		
		s RowId=result.Data("RowId")
		s PoNo=result.Data("PoNo")
		s CancelReasonId=result.Data("CancelReasonId")
		s CancelReasonDesc=result.Data("CancelReasonDesc")
		s PoDate=result.Data("PoDate")
		s:PoDate'="" PoDate=..DL2H(PoDate)
		
		s CompFlag=result.Data("CompFlag")
		s:CompFlag="" CompFlag="N"
		CONTINUE:(pCompFlag'="")&(CompFlag'=pCompFlag)
		
		s AuditFlag=result.Data("AuditFlag")
		s:AuditFlag="" AuditFlag="N"
		CONTINUE:(pAuditFlag'="")&(AuditFlag'=pAuditFlag)
		
		s VendorId=result.Data("VendorId")
		CONTINUE:(pVendorId'="")&(VendorId'=pVendorId)
		s VendorDesc=result.Data("VendorDesc")
		
		s DhcPoId=$o(^DHCINPO(0,"INPO",RowId,""),-1)
		CONTINUE:DhcPoId=""		//过滤没有附加表订单
		
		s PoLocId =$p(^DHCINPO(DhcPoId),"^",2)
		CONTINUE:("^"_pLocId_"^")'[("^"_PoLocId_"^")
		s:PoLocId'="" PoLocDesc=$p(^CTLOC(PoLocId),"^",2),PoLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(PoLocDesc)
		
		s ReqLocId=$p(^DHCINPO(DhcPoId),"^",5)
		CONTINUE:(pReqLocId'="")&&(pReqLocId'=ReqLocId)
		s:ReqLocId'="" ReqLocDesc=$p(^CTLOC(ReqLocId),"^",2),ReqLocDesc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(ReqLocDesc)
		
		s Type=$p(^DHCINPO(DhcPoId),"^",4)
		CONTINUE:(Type'=..sssCode())
		
		s StkGrpId=$p(^DHCINPO(DhcPoId),"^",3)
		CONTINUE:(StkGrpId'="")&&(StkGrpStr'="")&&(("^"_StkGrpStr_"^")'[("^"_StkGrpId_"^"))
		
		s CancelFlag=$p(^INPO(RowId),"^",18)
		s:CancelFlag="" CancelFlag="N"
		CONTINUE:((pIncludeCancelInPo'="Y")&(CancelFlag="Y"))
		
		s PoStatus=##class(web.DHCSTMHUI.INPO).GetPoStatus(RowId)
		CONTINUE:(pStatus'="")&('$f(pStatus,PoStatus))
		
		s EffecQty=$p(##class(web.DHCSTMHUI.INPO).GetPoDetailQty(RowId),"^",2)
		CONTINUE:(pFilterDetail="Y")&(EffecQty=0)
		
		CONTINUE:((pInciId'="")||(pIncscId'="")||(StkGrpStr'=""))&&($$ChkInci(pInciId_"^"_pIncscId,StkGrpStr,RowId)="N")

		s AuditDate=$p(^DHCINPO(DhcPoId),"^",7)
		s:AuditDate'="" AuditDate=..DL2H(AuditDate)
		s AuditUserId=$p(^DHCINPO(DhcPoId),"^",6)
		s:AuditUserId'="" AuditUserName=$p(^SSU("SSUSR",AuditUserId),"^",2)
		s PurUserId=$p(^INPO(RowId),"^",7)
		s:PurUserId'="" PurUserName=$p(^SSU("SSUSR",PurUserId),"^",2)
		
		d OutPutRowPo
	}
	Quit $$$OK
OutPutRowPo
	s Data=$lb(RowId,PoNo,VendorId,VendorDesc,PoLocId,PoLocDesc,PoStatus,PoDate,PurUserId,PurUserName,
	StkGrpId,CompFlag,ReqLocId,ReqLocDesc,AuditFlag,AuditUserName,AuditDate,CancelReasonId,CancelReasonDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
ChkInci(inciStr,ScgStr,inpp)
	;检查某订单中是否包含某库存项
	;return : 0 - 否 1 -是
	n (inciStr,ScgStr,inpp,%session)
	s Inci=$p(inciStr,"^",1)
	s Incsc=$p(inciStr,"^",2)
	s ch=0
	s Flag="N"
	f  s ch=$o(^INPO(inpp,"POI",ch)) q:(ch="")!(Flag="Y")  d
	.s PoiInci=$p(^INPO(inpp,"POI",ch),"^",1)
	.s PoiIncsc=$p(^INCI(PoiInci,2),"^",2)
	.s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(PoiInci)
	.s PoiScg=$p(ScgInfo,"^",5)
	.q:(Inci'="")&&(PoiInci'=Inci)
	.q:(Incsc'="")&&(PoiIncsc'=Incsc)
	.q:(ScgStr'="")&&(("^"_ScgStr_"^")'[("^"_PoiScg_"^"))
	.s Flag="Y"
	q Flag
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCItmTrack","INPOItmQuery",^templxt("INPOItmQuery"))
Query INPOItmQuery(Parref As %String) As Query(ROWSPEC = "RowId,InciId,InciCode,InciDesc,UomId,UomDesc,AvaQty:%Float,Rp:%Float,PurQty:%Float,ImpQty:%Float,Spec,ManfId,ManfDesc,RpAmt:%Float,SpecDesc,BUomId,ConFac:%Float,CertNo,CertExpDate,ImpQtyAudited:%Float,AvaQty:%Float,Cancleflag,BatchCodeFlag") [ SqlProc ]
{
}

ClassMethod INPOItmQueryExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle, Parref,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	
	s StrSql = "SELECT IN_POItm as RowId,INPOI_Childsub as Ch, INPOI_INCI_DR InciId,INPOI_INCI_DR->inci_code as InciCode,"
		_"INPOI_INCI_DR->inci_desc as InciDesc, INPOI_CTUOM_DR UomId,INPOI_CTUOM_DR->ctuom_desc as UomDesc,"
		_"INPOI_UnitCost Rp,INPOI_Pur_Qty PurQty,INPOI_GrossAmt RpAmt "
		_"FROM IN_PoItm WHERE IN_PO= "_Parref
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	d result.Prepare(StrSql)
	s sc=result.Execute()
	s err=$$$ISERR(sc)
	If err  q $$$OK
	While(result.Next())
	{
		s (SpecDesc,Cancleflag)=""
		s RowId = result.Data("RowId")
		s InciId = result.Data("InciId")
		continue:InciId=""
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
		continue:HVFlag'="Y"
		s UomId = result.Data("UomId")
		s UomDesc=result.Data("UomDesc")
		s Rp=result.Data("Rp")
		s RpAmt=result.Data("RpAmt")
		s PurQty =+ result.Data("PurQty")  ;订购数量
		s ImpQtyInfo=##class(web.DHCSTMHUI.INPOItm).GetImpQty(RowId,UomId)  ;到货数量
		s ImpQty=$p(ImpQtyInfo,"^",1)			;入库制单数量
		s ImpQtyAudited=$p(ImpQtyInfo,"^",2)	;入库审核数量
		s AvaQty=PurQty-ImpQty    ;还可以入库的数量		;未到货数量
		s InciCode=result.Data("InciCode")
		s InciDesc=result.Data("InciDesc")
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		s ManfStr=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetManf(InciId)
		s ManfId=$p(ManfStr,"^",1)
		s ManfDesc=$p(ManfStr,"^",3)
		s BUomId=$p(^INCI(InciId,1),"^",10)
		s ConFac=##class(web.DHCSTMHUI.Common.UtilCommon).UOMFac(UomId,BUomId)
		s dhcpoi=$o(^DHCINPOI(0,"INPOI",RowId,""),-1)
		i dhcpoi'="" d
		.s SpecDesc=$p(^DHCINPOI(dhcpoi),"^",5)
		.s Cancleflag=$p(^DHCINPOI(dhcpoi),"^",4)
		.s:Cancleflag="" Cancleflag="N"
		s CertInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(InciId)
		s CertNo=$p(CertInfo,"^",1)
		s CertExpDate=$p(CertInfo,"^",2)
		s BatchCodeFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBatchCodeFlag(InciId)
		d OutPutRowPoDetail
	}
	Quit $$$OK

OutPutRowPoDetail
	s Data=$lb(RowId,InciId,InciCode,InciDesc,UomId,UomDesc,AvaQty,Rp,PurQty,ImpQty,Spec,ManfId,ManfDesc,RpAmt,
	SpecDesc,BUomId,ConFac,CertNo,CertExpDate,ImpQtyAudited,AvaQty,Cancleflag,BatchCodeFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	查询高值条码信息
/// Creator:	lxt
/// CreateDate:	2018-09-28
/// Table:		DHC_ItmTrack
/// Input:		排序，查询条件
/// Return：	查询高值条码信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCItmTrack","QueryTrack","{""PhaLoc"":""164"",""gUserId"":""6423"",""gLocId"":""163"",""gGroupId"":""277"",""gHospId"":""2"",""MENUID"":""57970"",""Vendor"":""7"",""CurrLoc"":""114"",""StkScg"":""1"",""InciDesc"":"""",""Inci"":"""",""StartDate"":""2022-11-23"",""EndDate"":""2023-01-17"",""BarCode"":"""",""Status"":""Enable""}")
Query QueryTrack(Params As %String) As Query(ROWSPEC = "RowId,InciId,InciCode,InciDesc,Spec,UomDesc,Label,Incib,IncibNo,CurrentLoc,Status,DhcitDate,DhcitTime,DhcitUser,VendorDesc,OriginalCode,ManfId,ManfDesc,Rp:%Float,SpecDesc,PrintFlag,BatNo,ExpDate,RetOriFlag,Qty:%Float,Inclb") [ SqlProc ]
{
}

ClassMethod QueryTrackExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle,Params,%session)
	;s ^tmpzx(23)=Params
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s pPhaLocId=PJObj.%Get("PhaLoc")
	s pStartDate=PJObj.%Get("StartDate")
	s pVendorId=PJObj.%Get("Vendor")
	s pInciId=PJObj.%Get("Inci")
	s pInciDesc=PJObj.%Get("InciDesc")
	s pCurrLocId=PJObj.%Get("CurrLoc")
	s pEndDate=PJObj.%Get("EndDate")
	s pStkScgId=PJObj.%Get("StkScg")
	s pStatus=PJObj.%Get("Status")
	s pBarCode=PJObj.%Get("BarCode")
	s gHospId=PJObj.%Get("gHospId")
	s HospId=..sssHospId(pCurrLocId)
	s:HospId="" HospId=gHospId
	s StkGrpStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("",..sssCode(),pCurrLocId,pStkScgId,HospId)
	s:pStartDate'="" pStartDate=..DH2L(pStartDate)
	s:pEndDate'="" pEndDate=..DH2L(pEndDate)

	s SqlStr="select DHCIT_RowId RowId,"
	s SqlStr=SqlStr_"DHCIT_INCI_DR InciId,DHCIT_INCI_DR->INCI_Code InciCode,DHCIT_INCI_DR->INCI_Desc InciDesc,"
	s SqlStr=SqlStr_"DHCIT_Label Label,DHCIT_Status Status,"
	s SqlStr=SqlStr_"DHCIT_INCIB_DR Incib,DHCIT_INCLB_DR Inclb,"
	s SqlStr=SqlStr_"DHCIT_Date DhcitDate,DHCIT_Time DhcitTime,DHCIT_SSUSR_DR->SSUSR_Name DhcitUser,"
	s SqlStr=SqlStr_"DHCIT_APCVM_DR->APCVM_Name VendorDesc,DHCIT_OriginalCode OriginalCode,"
	s SqlStr=SqlStr_"DHCIT_BatchNo BatNo,DHCIT_ExpDate ExpDate,DHCIT_SpecList SpecDesc,"
	s SqlStr=SqlStr_"DHCIT_PrintFlag PrintFlag,DHCIT_OriginalStatus OriginalStatus "
	s SqlStr=SqlStr_" from DHC_ItmTrack where 1=1"
	i pVendorId'="" d
	.s SqlStr=SqlStr_" and DHCIT_APCVM_DR='"_pVendorId_"'"
	i pBarCode'="" d
	.s SqlStr=SqlStr_" and (DHCIT_Label='"_pBarCode_"' OR DHCIT_OriginalCode='"_pBarCode_"')" 
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s RowId=Result.Data("RowId")
		s InciId=Result.Data("InciId")
		s InciCode=Result.Data("InciCode")
		s InciDesc=Result.Data("InciDesc")
		s Label=Result.Data("Label")
		s Status=Result.Data("Status")
		s Incib=Result.Data("Incib")
		s Inclb=Result.Data("Inclb")
		s DhcitDate=Result.Data("DhcitDate")
		s DhcitTime=Result.Data("DhcitTime")
		s DhcitUser=Result.Data("DhcitUser")
		s VendorDesc=Result.Data("VendorDesc")
		s OriginalCode=Result.Data("OriginalCode")
		s PrintFlag=Result.Data("PrintFlag")
		s OriginalStatus=Result.Data("OriginalStatus")
		s Qty=1
		i OriginalStatus="NotUnique" d
		.s Qty=0
		.s Inclb=##class(web.DHCSTMHUI.DHCItmTrack).GetInclbByBarCode(pCurrLocId,Label)
		.s:Inclb'="" Qty=##class(web.DHCSTMHUI.Common.DrugStkCommon).QtyINCLB(Inclb,+$H)
		continue:Qty=0
		continue:(pStartDate'="")&&(DhcitDate<pStartDate)
		continue:(pEndDate'="")&&(DhcitDate>pEndDate)
		i pStatus'=""
		{
			continue:(pStatus="Reg")&&(Status'="")
			continue:((pStatus="Enable")||(pStatus="Used"))&&(Status'=pStatus)
			continue:(pStatus="Else")&&((Status="")||(Status="Reg")||(Status="Enable")||(Status="Used"))
		}
		s TypeLoc=..GetTypeLoc(RowId)
		s CurrentLocId=$p(TypeLoc,"^",2)
		;s CurrentLoc=$p(TypeLoc,"^",3)
		i Inclb'="" s CurrentLocId=$p(^INCI($p(Inclb,"||",1),"IL",$p(Inclb,"||",2)),"^",1)
		continue:(pCurrLocId'="")&&(CurrentLocId'=pCurrLocId)
		s CurrentLoc=$s(CurrentLocId'="":$p(^CTLOC(CurrentLocId),"^",2),1:"")
		S CurrentLoc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(CurrentLoc)
		s HvmId=$o(^DHCHVMORI(0,"BARCODE",Label,""),-1)
		s:(HvmId="")&&(OriginalCode'="") HvmId=$o(^DHCHVMORI(0,"BARCODE",OriginalCode,""),-1)
		s RetOriFlag=$s(HvmId'="":$p($G(^DHCHVMORI(HvmId,2)),"^",22),1:"N")
		s:RetOriFlag="" RetOriFlag="N"
		s IfFromLoc="Y"
		i pPhaLocId'="" s IfFromLoc=..IfFromLoc(Label,pPhaLocId) ;判断条码是否来自此库房
		continue:IfFromLoc="N"
		s LastDate=$p(TypeLoc,"^",4)
		continue:InciId=""
		continue:(pInciId'="")&&(pInciId'=InciId)
		continue:(pInciDesc'="")&&(InciDesc'[pInciDesc)
		continue:'$d(^INCI(InciId))
		s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(InciId)
		s StkScgId=$p(ScgInfo,"^",5)
		continue:(StkScgId'="")&&(StkGrpStr'="")&&(("^"_StkGrpStr_"^")'[("^"_StkScgId_"^"))
		s UomId=$p(^INCI(InciId,1),"^",10)
		s UomDesc=$p($g(^CT("UOM",UomId)),"^",2)
		s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
		
		s (IncibNo,BatNo,ExpDate,ManfId,ManfDesc,RpPurUom,SpecDesc)=""
		i Incib'="" d
		.s BatNo=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",1)
		.s ExpDate=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",2)
		.s DhcIncib=$o(^DHCINCIB(0,"INCIB",Incib,""))
		.i DhcIncib'="" d
		..s ManfId=$p(^DHCINCIB(DhcIncib),"^",7)
		..s:ManfId'="" ManfDesc=$p(^PHMNF(ManfId),"^",2)
		..s Rp=$p(^DHCINCIB(DhcIncib),"^",4)
		..s SpecDesc=$p(^DHCINCIB(DhcIncib),"^",13)
		e  d
		.s BatNo=Result.Data("BatNo")
		.s ExpDate=Result.Data("ExpDate")
		.s SpecDesc=Result.Data("SpecDesc")
		s:ExpDate'="" ExpDate=..DL2H(ExpDate)
		s IncibNo=BatNo_"~"_ExpDate
		s:DhcitDate'="" DhcitDate=..DL2H(DhcitDate)
		s:DhcitTime'="" DhcitTime=..TL2H(DhcitTime)

		d OutPutTrack
	}
	Quit $$$OK
OutPutTrack
	s Data=$lb(RowId,InciId,InciCode,InciDesc,Spec,
			UomDesc,Label,Incib,IncibNo,CurrentLoc,
			Status,DhcitDate,DhcitTime,DhcitUser,VendorDesc,
			OriginalCode,ManfId,ManfDesc,Rp,
			SpecDesc,PrintFlag,BatNo,ExpDate,RetOriFlag,Qty,Inclb)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// Descript:	判断此条码是否来着此库房
/// Creator:	lxt
/// CreateDate:	2018-09-28
/// Table:		IN_Purplan
/// Input:		条码，库房
/// Return：	是 否
ClassMethod IfFromLoc(Barcode, LocId) As %Library.String
{
	n (Barcode,LocId,%session)
	q:Barcode="" "N"
	q:LocId="" "N"
	s ret="N"
	s dhcit=$o(^DHCIT(0,"LABEL",Barcode,""))
	s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",Barcode,""))
	q:dhcit="" ret
	s InitItmId="",type="T"
	&sql(SELECT TOP 1 DHCITD_Pointer into:InitItmId FROM DHC_ItmTrackDetail WHERE DHCITD_Parref=:dhcit AND DHCITD_Type=:type ORDER BY DHCITD_ChildSub ASC)
	q:SQLCODE ret
	s FromLoc=$p(^DHCINIT(+InitItmId),"^",5)
	i (FromLoc=LocId) d
	.s ret="Y"
	q ret
}

/// Descript:	查询高值条码跟踪信息
/// Creator:	lxt
/// CreateDate:	2018-09-28
/// Table:		DHC_ItmTrack
/// Input:		排序，查询条件
/// Return：	查询高值条码跟踪信息
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCItmTrack","QueryTrackItm","")
Query QueryTrackItm(Parref As %String) As Query(ROWSPEC = "RowId,Pointer,Type,OperNo,Date,Time,UserDesc,OperOrg,IntrFlag") [ SqlProc ]
{
}

ClassMethod QueryTrackItmExecute(ByRef qHandle As %Binary, Parref As %String) As %Status
{
	n (qHandle,Parref,%session)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:Parref="" $$$OK
	
	s Pid=..NewPid()
	k ^TMP("DHCSTM.DHCItmTrack",Pid)
	s num=0
	
	//订单
	s PoItmId=""
	s PoItmId=$p(^DHCIT(Parref),"^",14)
	i PoItmId'="" d
	.s (PoUserDesc)=""
	.s PoId=+PoItmId
	.s Type = "POD"
	.s OperNoInfo=..GetOperNo(Type,PoItmId)
	.s OperNo=$p(OperNoInfo,"^",1)
	.s OperOrg = $p(OperNoInfo,"^",2)
	.s PoDate = $p(^INPO(PoId),"^",3)
	.s PoTime =""
	.s PoUserId = $p(^INPO(PoId),"^",7)
	.s:PoUserId'="" PoUserDesc=$p(^SSU("SSUSR",PoUserId),"^",2)
	.s tmp=PoItmId_"^"_PoItmId_"^"_Type_"^"_OperNo_"^"_PoDate_"^"_PoTime_"^"_PoUserDesc_"^"_OperOrg
	.s num=num+1
	.s ^TMP("DHCSTM.DHCItmTrack",Pid,num)=tmp
	//采购
	s PPItmId=""
	&sql(select INPPI_Rowid into :PPItmId from IN_PURPLANITM where INPPI_INPOI_DR=:PoItmId)
	i PPItmId'="" d
	.s (PPUserDesc)=""
	.s PPId=+PPItmId
	.s Type = "PD"
	.s OperNoInfo=..GetOperNo(Type,PPItmId)
	.s OperNo=$p(OperNoInfo,"^",1)
	.s OperOrg = $p(OperNoInfo,"^",2)
	.s PPDate = $p(^INPP(PPId),"^",2)
	.s PPTime = $p(^INPP(PPId),"^",9)
	.s PPUserId = $p(^INPP(PPId),"^",3)
	.s:PPUserId'="" PPUserDesc=$p(^SSU("SSUSR",PPUserId),"^",2)
	.s tmp=PPItmId_"^"_PPItmId_"^"_Type_"^"_OperNo_"^"_PPDate_"^"_PPTime_"^"_PPUserDesc_"^"_OperOrg
	.s num=num+1
	.s ^TMP("DHCSTM.DHCItmTrack",Pid,num)=tmp
	//请求
	s ReqItmId=""
	&sql(select PPREQI_REQITM_DR into :ReqItmId from DHC_INPPReqItm where PPREQI_INPPI_Parref=:PPItmId)
	i ReqItmId'="" d
	.s (ReqUserDesc)=""
	.s ReqId=+ReqItmId
	.s Type = "RD"
	.s OperNoInfo=..GetOperNo(Type,ReqItmId)
	.s OperNo=$p(OperNoInfo,"^",1)
	.s OperOrg = $p(OperNoInfo,"^",2)	;业务机构信息(科室或患者)
	.s ReqDate = $p(^INRQ(ReqId),"^",2)
	.s ReqTime = $p(^INRQ(ReqId),"^",3)
	.s ReqUserId = $p(^INRQ(ReqId),"^",4)
	.s:ReqUserId'="" ReqUserDesc=$p(^SSU("SSUSR",ReqUserId),"^",2)
	.s tmp=ReqItmId_"^"_ReqItmId_"^"_Type_"^"_OperNo_"^"_ReqDate_"^"_ReqTime_"^"_ReqUserDesc_"^"_OperOrg
	.s num=num+1
	.s ^TMP("DHCSTM.DHCItmTrack",Pid,num)=tmp
	//明细
	s SqlStr="SELECT DHCITD_Rowid as RowId,DHCITD_ChildSub as Ch,"
	s SqlStr=SqlStr_"DHCITD_Pointer as Pointer,DHCITD_Type as Type,"
	s SqlStr=SqlStr_"DHCITD_Date,DHCITD_Time,DHCITD_SSUSR_DR UserId "
	s SqlStr=SqlStr_" FROM dhc_itmtrackdetail "
	s SqlStr=SqlStr_" where DHCITD_Parref = "_Parref
	s Result=##class(%Library.ResultSet).%New()
	d Result.RuntimeModeSet(0)
	d Result.Prepare(SqlStr)
	d Result.Execute()
	While(Result.Next())
	{
		s (UserDesc)=""
		s RowId = Result.Data("RowId")
		s Pointer = Result.Data("Pointer")
		s Type = Result.Data("Type")
		s Type=$s(Type="SG":"G",Type="ST":"T",Type="SK":"K",Type="SR":"R",Type="SP":"P",Type="SY":"Y",1:Type)		;2018-03-22 补录内容
		s OperNoInfo=..GetOperNo(Type,Pointer)
		s OperNo = $p(OperNoInfo,"^",1)
		s OperOrg = $p(OperNoInfo,"^",2)
		s IntrFlag=$p(OperNoInfo,"^",3)
		continue:(OperNo="")&&(OperOrg="")
		s Date = Result.Data("DHCITD_Date")
		s Time = Result.Data("DHCITD_Time")
		s UserId = Result.Data("UserId")
		s:UserId'="" UserDesc=$p($g(^SSU("SSUSR",UserId)),"^",2)
		s tmp=RowId_"^"_Pointer_"^"_Type_"^"_OperNo_"^"_Date_"^"_Time_"^"_UserDesc_"^"_OperOrg_"^"_IntrFlag
		s num=num+1
		s ^TMP("DHCSTM.DHCItmTrack",Pid,num)=tmp
		
		//明细附加
		s dhcitda=0,cnt=0
		f  s dhcitda=$o(^DHCITD(0,"DHCITD",RowId,dhcitda)) q:dhcitda=""  d
		.s (UserDesc)=""
		.s dhcitdaInfo=^DHCITD("IA",dhcitda)
		.s Pointer=$p(dhcitdaInfo,"^",1)
		.s Type=$p(dhcitdaInfo,"^",2)
		.s Date=$p(dhcitdaInfo,"^",3)
		.s Time=$p(dhcitdaInfo,"^",4)
		.s UserId=$p(dhcitdaInfo,"^",5)
		.s:UserId'="" UserDesc=$p($g(^SSU("SSUSR",UserId)),"^",2)
		.s intrType=$s(Type="SG":"G",Type="ST":"T",Type="SK":"K",Type="SR":"R",Type="SP":"P",1:Type)
		.q:'$d(^DHCINTR(0,"TypePointer",intrType,Pointer))
		.s OperNoInfo=..GetOperNo(intrType,Pointer)
		.s OperNo=$p(OperNoInfo,"^",1)
		.s OperOrg=$p(OperNoInfo,"^",2)
		.s IntrFlag=$p(OperNoInfo,"^",3)
		.s tmp=dhcitda_"^"_Pointer_"^"_Type_"^"_OperNo_"^"_Date_"^"_Time_"^"_UserDesc_"^"_OperOrg_"^"_IntrFlag
		.s num=num+1
		.s ^TMP("DHCSTM.DHCItmTrack",Pid,num)=tmp
	}
	
	s DirFlag=1
	s sub="",count=0
	f  s sub=$o(^TMP("DHCSTM.DHCItmTrack",Pid,sub),DirFlag) q:sub=""  d
	.s count=count+1
	.s str=^TMP("DHCSTM.DHCItmTrack",Pid,sub)
	.s RowId=$p(str,"^",1)
	.s Pointer=$p(str,"^",2)
	.s Type=$p(str,"^",3)
	.s OperNo=$p(str,"^",4)
	.s Date=$p(str,"^",5)
	.s Time=$p(str,"^",6)
	.s:Date'="" Date=..DL2H(Date)
	.s:Time'="" Time=..TL2H(Time)
	.s UserDesc=$p(str,"^",7)
	.s OperOrg=$p(str,"^",8)
	.s IntrFlag=$p(str,"^",9)
	.d OutPutRowDetail
	
	k ^TMP("DHCSTM.DHCItmTrack",Pid)
	Quit $$$OK
OutPutRowDetail
	s Data=$lb(RowId,Pointer,Type,OperNo,Date,Time,UserDesc,OperOrg,IntrFlag)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

/// CreatDate:2015-04-15
/// Creator:zhangxiao
/// Description:查询跟踪主表信息
/// Table:dhc_itmtrack
/// Input:条码
/// OutPut:
/// Return: 
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetPrintBarcodeInfo("WJWSGZ20180504001")
ClassMethod GetPrintBarcodeInfo(Barcode As %String) As %String
{
	n (Barcode,%session)
	s ItmTrackId=$o(^DHCIT(0,"LABEL",Barcode,0))
	q:ItmTrackId="" ""
	q:'$d(^DHCIT(ItmTrackId)) ""
	s itmtrackinfo=^DHCIT(ItmTrackId)
	s InciId=$p(itmtrackinfo,"^",1)
	s Status=$p(itmtrackinfo,"^",5)
	s LodId=$p(itmtrackinfo,"^",6)
	s Incib=$p(itmtrackinfo,"^",7)
	s VendorId=$p(itmtrackinfo,"^",11)
	s VendorDesc=$s(VendorId'="":$p(^APC("APCVM",VendorId),"^",3),1:"")
	s Inclb=$p(itmtrackinfo,"^",12)
	s OriginalCode=$p(itmtrackinfo,"^",13)
	s OldOriginalCode=$p(itmtrackinfo,"^",30)
	s ExpDate=$p(itmtrackinfo,"^",18)	
	s BatNo=$p(itmtrackinfo,"^",17)
	s PrintFlag=$p(itmtrackinfo,"^",21) ;打印标志
	s PrintFlagDesc=$s(PrintFlag="Y":"补",1:PrintFlag)
	s InciDesc=$p(^INCI(InciId,1),"^",2)
	s InciCode=$p(^INCI(InciId,1),"^",1)
	s (dhcitm,inforemark)=""
	s dhcitm=$o(^DHCITMINFO(0,"INCI",InciId,0))
	s InfoRemark=""
	i dhcitm'="" d
	.s InfoRemark=$p(^DHCITMINFO(dhcitm),"^",10)
	s SpecDesc=$p(itmtrackinfo,"^",19)
	s ManfId=$p(itmtrackinfo,"^",15)
	s ManfDesc=$s(ManfId'="":$p(^PHMNF(ManfId),"^",2),1:"")
	
	;取未审核入库明细中批号效期
	s chl="",ingri=""
	f  s chl=$o(^DHCITD(ItmTrackId,"I",chl)) q:(chl="")!(ingri'="")  d
	.s Trackitminfo=^DHCITD(ItmTrackId,"I",chl)
	.s type=$p(Trackitminfo,"^",2)
	.s pointer=$p(Trackitminfo,"^",1)
	.i type="G" s ingri=pointer
	i ingri'="" d
	.q:'$d(^DHCINGR(+ingri,"GRI",$p(ingri,"||",2)))
	.s ingritminfo=^DHCINGR(+ingri,"GRI",$p(ingri,"||",2))
	.s ExpDate=$p(ingritminfo,"^",9)	
	.s BatNo=$p(ingritminfo,"^",13)
	s (BusinessRegNo,Sp,Rp)=""
	i Incib'="" d
	.s BatNo=$p(^INCI($p(Incib,"||",1),"IB",$p(Incib,"||",2)),"^",1)
	.s ExpDate=$p(^INCI($p(Incib,"||",1),"IB",$p(Incib,"||",2)),"^",2)
	.s SpecDesc=##class(web.DHCSTMHUI.Common.DrugStkCommon).GetSpecDescByInclb(Inclb)
	.s dhcincib=""
	.s dhcincib=$o(^DHCINCIB(0,"INCIB",Incib,0))
	.i dhcincib'="" d
	..s Sp=$p(^DHCINCIB(dhcincib),"^",5)
	..s Rp=$p(^DHCINCIB(dhcincib),"^",3)
	..s VendorId=$p(^DHCINCIB(dhcincib),"^",8)
	..s VendorDesc=$s(VendorId'="":$p(^APC("APCVM",VendorId),"^",3),1:"")
	..s ManfId=$p(^DHCINCIB(dhcincib),"^",7)
	..i ManfId'="" d
	...s ManfDesc=$p(^PHMNF(ManfId),"^",2)
	...s ManfAddId=$o(^DHCMANF(0,"MANF",ManfId,0))
	...i ManfAddId'="" d
	....s BusinessRegNo=$p(^DHCMANF(ManfAddId),"^",11) ;生产厂家工商注册证号
	
	s UomId=$p(^INCI(InciId,1),"^",10)
	s UomDesc=$p($g(^CT("UOM",UomId)),"^",2) ;单位
	s Spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",InciId)
	i Sp="" d
	.s Sp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(InciId,+$H,UomId,"")
	s:+ExpDate'=0 ExpDate=..DL2H(ExpDate)
	s Brand=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetBrand(InciId)
	s InciDesc1=$e(InciDesc,1,25)
	s InciDesc2=$e(InciDesc,26,$l(InciDesc))
	s Title="IncCode^IncDesc^BarCode^VendorDesc^ManfDesc^ExpDate^BatNo^Spec^SpecDesc^Brand^OriginalCode^OldOriginalCode^Rp^Sp^PrintFlag^PrintFlagDesc^IncDesc1^IncDesc2"
	s Data=InciCode_"^"_InciDesc_"^"_Barcode_"^"_VendorDesc_"^"_ManfDesc_"^"_ExpDate_"^"_BatNo_"^"_Spec_"^"_SpecDesc_"^"_Brand_"^"_OriginalCode_"^"_OldOriginalCode_"^"_Rp_"^"_Sp_"^"_PrintFlag_"^"_PrintFlagDesc_"^"_InciDesc1_"^"_InciDesc2
	s PrintData=##class(web.DHCSTMHUI.Common.UtilCommon).GetXmlPrintData(Title,Data)
	q PrintData
}

/// CreatDate:20190525
/// Description:根据业务类型和指针获取条码类型
/// OriginalStatus NotUnique  或者 "" 
ClassMethod GetOriginalStatus(type As %String, pointer As %String) As %String
{
	n (type,pointer,%session)
	q:((type="")||(pointer="")) ""
	s dhcit=$o(^DHCITD(0,"Type",type,"Pointer",pointer,0))
	q:dhcit="" ""
	s OriginalStatus=""
	s OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	q OriginalStatus
}

/// 20190525
/// 入库审核时批次管理的高值条码作为批次生成的依据，批次管理的高值条码返回条码，其他返回空
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetLabelsForRec("G","679||1")
ClassMethod GetLabelsForRec(type As %String, pointer As %String, inclb As %String = "") As %String
{
	n (type,pointer,inclb,%session)
	q:type="" ""
	q:pointer="" ""

	s (INCIL,INCLB)=""
	s INCI=$p(inclb,"||",1),il=$p(inclb,"||",2),lb=$p(inclb,"||",3)
	s:il'="" INCIL=INCI_"||"_il
	s:lb'="" INCLB=INCI_"||"_il_"||"_lb

	s labelStr=""
	s dhcit=""
	f  s dhcit=$o(^DHCITD(0,"Type",type,"Pointer",pointer,dhcit)) q:dhcit=""  d
	.s Inclb=$p(^DHCIT(dhcit),"^",12)
	.s Incil=$p(Inclb,"||",1,2)
	.s Inci=$p(^DHCIT(dhcit),"^",1)
	.q:(INCLB'="")&&(Inclb'=INCLB)
	.q:(INCIL'="")&&(Incil'=INCIL)
	.q:(INCI'="")&&(Inci'=INCI)
	.
	.s label=$p(^DHCIT(dhcit),"^",2)
	.s OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	.q:OriginalStatus'="NotUnique"
	.i labelStr'="" d
	..s labelStr=labelStr_"#"_label		;2015-12-10 分隔符由^改为#
	.e  d
	..s labelStr=label
	.
	i labelStr="" d
	.s hvm=$o(^DHCHVMORI(0,"INGRIModify",pointer,0))
	.q:hvm=""
	.s HVBarCode=$p(^DHCHVMORI(hvm,1),"^",24)
	.s dhcit=$o(^DHCIT(0,"LABEL",HVBarCode,0))
	.q:dhcit=""
	.s OriginalStatus=$p(^DHCIT(dhcit),"^",35)
	.q:OriginalStatus'="NotUnique"
	.s labelStr=HVBarCode
	q labelStr
}

/// 根据 inclb 获取某科室对应批次的inclb
/// 20190525
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetInclbByInclb("1218","4746||2||2")
ClassMethod GetInclbByInclb(LocId As %String, Inclb As %String) As %String
{
	n (LocId,Inclb,%session)
	;s ^zx(222)=$lb(LocId,Inclb)
	s ToInclb=""
	s:LocId="" ToInclb=Inclb
	q:LocId="" ToInclb
	
	s Inci=+Inclb
	s IL=$p(Inclb,"||",2)
	s LB=$p(Inclb,"||",3)
	
	s Incil=Inci_"||"_IL
	s TmpLoc=$p(^INCI(Inci,"IL",IL),"^",1)
	i TmpLoc=LocId d
	.s ToInclb=Inclb  ;科室一致批次不变
	
	q:ToInclb'="" ToInclb
	
	s Incib=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",1) ;库存批次
	q:Incib="" Inclb
	
	s InciId=0
	f  s InciId=$o(^INCI("LB_IB",Incib,InciId)) q:InciId=""  d
	.s TmpIL=0
	.f  s TmpIL=$o(^INCI("LB_IB",Incib,InciId,TmpIL)) q:TmpIL=""  d
	..s Loc=$p(^INCI(InciId,"IL",TmpIL),"^",1)
	..q:Loc'=LocId
	..s TmpLB=0
	..f  s TmpLB=$o(^INCI("LB_IB",Incib,InciId,TmpIL,TmpLB)) q:TmpLB=""  d
	...s ToInclb=InciId_"||"_TmpIL_"||"_TmpLB
	
	
	q ToInclb
}

/// 根据 BarCode 获取某科室对应有可用库存批次的inclb
/// 20190525
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetInclbByBarCode("392","3333")
ClassMethod GetInclbByBarCode(LocId As %String, BarCode As %String) As %String
{
	n (LocId,BarCode,%session)
	;s ^zx(222)=$lb(LocId,BarCode)
	s ToInclb=""
	q:LocId="" ToInclb
	q:BarCode="" ToInclb
	
	s dhcit=$o(^DHCIT(0,"LABEL",BarCode,0))
	s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",BarCode,0))
	q:dhcit="" ToInclb
	s Inci=$p(^DHCIT(dhcit),"^",1)
	
	s TmpToInclb=""
	s Incib=0
	f  s Incib=$o(^DHCINCIB(0,"BarCode",Incib))  q:(Incib="")||(ToInclb'="")  d
	.s RecallFlag=$p(^INCI(+Incib,"IB",$p(Incib,"||",2)),"^",3)
	.q:RecallFlag="Y"
	.s dhIncib=0
	.f  s dhIncib=$o(^DHCINCIB(0,"BarCode",Incib,BarCode,dhIncib)) q:(dhIncib="")||(ToInclb'="")  d
	..s Inci=+Incib
	..s IL=0
	..f  s IL=$o(^INCI("LB_IB",Incib,Inci,IL)) q:(IL="")||(ToInclb'="")  d
	...s TmpLoc=$p(^INCI(Inci,"IL",IL),"^",1)
	...q:TmpLoc'=LocId
	...s LB=0
	...f  s LB=$o(^INCI("LB_IB",Incib,Inci,IL,LB)) q:(LB="")||(ToInclb'="")  d
	....
	....s Inclb=Inci_"||"_IL_"||"_LB
	....s:TmpToInclb="" TmpToInclb=Inclb
	....s PhQty=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",2)
	....s DirtyQty=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",3)
	....s AvaQty=PhQty-DirtyQty
	....q:AvaQty=0
	....s ToInclb=Inclb
	
	i (ToInclb="")&&(TmpToInclb'="") d
	.s ToInclb=TmpToInclb
	q ToInclb
}

/// 根据 BarCode 和inclb获取某科室对应最后一个ingri
/// 20190525
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetIngriByBarCode("392","3333","30||3||3")
ClassMethod GetIngriByBarCode(LocId As %String, BarCode As %String, Inclb As %String) As %String
{
	n (LocId,BarCode,Inclb,%session)
	;s ^zx(223)=$lb(LocId,BarCode,Inclb)
	s Ingri=""
	q:LocId="" Ingri
	q:BarCode="" Ingri
	q:Inclb="" Ingri
	
	s dhcit=$o(^DHCIT(0,"LABEL",BarCode,0))
	s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",BarCode,0))
	q:dhcit="" Ingri
	s ch=""
	f  s ch=$o(^DHCITD(dhcit,"I",ch),-1) q:((ch="")||(Ingri'=""))  d
	.s Pointer=$p(^(ch),"^",1)
	.s Type=$p(^(ch),"^",2) 
	.q:Type'="G"
	.s Ingr=+Pointer
	.s Sub=$p(Pointer,"||",2)
	.s Loc=$p(^DHCINGR(Ingr),"^",13)
	.q:Loc'=LocId
	.s TmpInclb=$p(^DHCINGR(Ingr,"GRI",Sub),"^",1)
	.q:TmpInclb'=Inclb
	.s Ingri=Pointer

	q Ingri
}

/// 根据 Barcode,loc ,qty 获取某科室对应库存足够的inclb
/// 有批次库存足够返回此批次，所有批次库存都不够返回第一个有库存的批次，所有批次库存为0返回最后一个批次
/// 20201105
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetInclbByBarcodeQty("326","3333",3)
ClassMethod GetInclbByBarcodeQty(LocId As %String, BarCode As %String, Qty As %String) As %String
{
	n (LocId,BarCode,Qty,%session)
	;s ^zx(222)=$lb(LocId,Inclb)
	s ToInclb=""
	q:LocId="" ToInclb
	q:BarCode="" ToInclb
	
	s dhcit=$o(^DHCIT(0,"LABEL",BarCode,0))
	s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",BarCode,0))
	q:dhcit="" ToInclb
	s Inci=$p(^DHCIT(dhcit),"^",1)
	
	s TmpToInclb="",TmpToInclb2=""
	s Incib=0
	f  s Incib=$o(^DHCINCIB(0,"BarCode",Incib))  q:(Incib="")||(ToInclb'="")  d
	.s dhIncib=0
	.f  s dhIncib=$o(^DHCINCIB(0,"BarCode",Incib,BarCode,dhIncib)) q:(dhIncib="")||(ToInclb'="")  d
	..s Inci=+Incib
	..s IL=0
	..f  s IL=$o(^INCI("LB_IB",Incib,Inci,IL)) q:(IL="")||(ToInclb'="")  d
	...s TmpLoc=$p(^INCI(Inci,"IL",IL),"^",1)
	...q:TmpLoc'=LocId
	...s LB=0
	...f  s LB=$o(^INCI("LB_IB",Incib,Inci,IL,LB)) q:(LB="")||(ToInclb'="")  d
	....
	....s Inclb=Inci_"||"_IL_"||"_LB
	....s TmpToInclb=Inclb
	....s PhQty=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",2)
	....s DirtyQty=$p(^INCI(Inci,"IL",IL,"LB",LB),"^",3)
	....s AvaQty=PhQty-DirtyQty
	....i (AvaQty>0)&&(TmpToInclb2="") d
	.....s TmpToInclb2=Inclb
	....q:AvaQty<Qty
	....s ToInclb=Inclb
	
	i (ToInclb="")&&(TmpToInclb2'="") d
	.s ToInclb=TmpToInclb2     ;如果没有库存满足的批次取第一个可用库存大于0的批次
	
	i (ToInclb="")&&(TmpToInclb'="") d
	.s ToInclb=TmpToInclb      ;如果所有批次都没有库存则取最后一个批次 
	q ToInclb
}

/// 获取批次码可能存在的状态(如Used,Return等)
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetBatchStatus(441)
ClassMethod GetBatchStatus(DHCIT)
{
	n (DHCIT,%session)
	s StatusList=""
	s Ch=0
	f  s Ch=$o(^DHCITD(DHCIT,"I",Ch)) q:Ch=""  d
	.s DHCITDInfo=^DHCITD(DHCIT,"I",Ch)
	.s Type=$p(DHCITDInfo,"^",2)
	.
	.s Status=$s((Type="MP")||(Type="MF"):"Used",Type="R":"Return",Type="A":"Inadj",Type="D":"Inscrap",1:"")
	.q:Status=""
	.q:$lf(StatusList,Status)>0
	.s $list(StatusList,*+1)=Status
	
	q $lts(StatusList,"^")
}

/// PDA注册条码 20210831 lihui
ClassMethod RegLabelByPDA(MainInfo, ListData As %String) As %Library.String
{
	n (MainInfo,ListData,%session)
	s RtnObj=##class(RtnObj).%New()
	i (MainInfo="")||(ListDetail="") q RtnObj.Err(-1,"","参数错误!","",0)
	s MainObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc=MainObj.%FromJSON(MainInfo)
	q:Sc'=0 RtnObj.Err(-1,"","参数解析错误!")
	s DetailObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	s Sc2=DetailObj.%FromJSON(ListData)
	q:Sc2'=0 Sc2=RtnObj.Err(-1,"","参数解析错误!")
	s incidStr=""
	While(RtnObj.success=0) {
		s ItmObj=DetailObj.%Pop()
		q:ItmObj=""
		s RowId=ItmObj.%Get("RowId")
		s InciId=ItmObj.%Get("InciId")
		q:InciId=""
		s HVFlag=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncHighValueFlag(InciId)
		q:HVFlag'="Y"
		i incidStr="" d
		.s incidStr=InciId
		e  d
		.s incidStr=incidStr_"^"_InciId
	}
	i incidStr="" q RtnObj
	s RtnObj=..RegHV(MainInfo,ListData)
	q:RtnObj.success'=0 RtnObj
	q RtnObj
}

/// 根据使用过的条码获取医嘱接收科室 lihui 20211208
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetRecLocByBarcode("MGZ202112060004")
ClassMethod GetRecLocByBarcode(Barcode As %String) As %Library.String
{
	n (Barcode,%session)
	q:Barcode="" ""
	s orihvid=$o(^DHCHVMORI(0,"BARCODE",Barcode,""),-1)
	q:orihvid="" ""
	s Oeori=$p(^DHCHVMORI(orihvid,1),"^",1)
	q:Oeori="" ""
	s Oeord=$p(Oeori,"||",1),OeoriCh=$p(Oeori,"||",2)
	q:(Oeord="")||(OeoriCh="")||'$d(^OEORD(Oeord,"I",OeoriCh)) ""
	s RecLocId=$p(^OEORD(Oeord,"I",OeoriCh,3),"^",6)
	q RecLocId
}

/// 20220427 lihui
/// Return: 根据高值条码获取病人信息
/// w ##class(web.DHCSTMHUI.DHCItmTrack).GetPatientInfo(141)
ClassMethod GetPatientInfo(RowId) As %String
{
	n (RowId,%session)
	q:RowId="" ""
	s Status=$p(^DHCIT(RowId),"^",5)
	q:Status'="Used" ""
	s TypeStr="^P^F^MP^MF^"
	s PatStr=""
	
	s Ch=""
	f  s Ch=$o(^DHCITD(RowId,"I",Ch),-1) q:(Ch="")||(PatStr'="")  d
	.s ItmInfo=^DHCITD(RowId,"I",Ch)
	.s Pointer=$p(ItmInfo,"^",1)
	.s Type=$p(ItmInfo,"^",2)
	.s Date=$p(ItmInfo,"^",3)
	.s Time=$p(ItmInfo,"^",4)
	.q:TypeStr'[("^"_Type_"^")
	.
	.s Ord=$p(Pointer,"||",1)
	.s AdmId=$p(^OEORD(Ord),"^",1)
	.s Papmi=$p(^PAADM(AdmId),"^",1)
	.q:Papmi=""
	.s PaNo=$p(^PAPER(Papmi,"PAT",1),"^",1)		;登记号
	.s PaName=$p(^PAPER(Papmi,"ALL"),"^",1)
	.s PatientInfo=PaNo_", "_PaName
	.s DateTime=..DL2H(Date)_" "_..TL2H(Time)
	.s PatStr=PatientInfo_"^"_DateTime
	
	q PatStr
}

///  w ##class(web.DHCSTMHUI.DHCItmTrack).GetInciMsg("GZ00060","","东华标准版数字化医院[总院]")
ClassMethod GetInciMsg(InciCode As %String, Manf As %String, Hospital As %String) As %Library.String
{
	n (InciCode,Manf,Hospital,%session)
	q:InciCode="" ""
	s HospId=$o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(Hospital),0))
	q:HospId="" ""
	s Inci=##class(web.DHCSTMHUI.MatForBDPData).CodeDescGetId("CODE",InciCode,"INC_Itm",HospId)
	q:Inci="" ""
	s InciDesc=$p(^INCI(Inci,1),"^",2)
	s UomInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncBuom(Inci)
	s BUomId=$p(UomInfo,"^",1)
	s BUomDesc=$p(UomInfo,"^",2)
	s (Spec,Model,ManfId,ManfDesc)=""
	s AddInfo=$O(^DHCITMINFO(0,"INCI",Inci,0))
	i AddInfo'="" d
	.s AddInfoData=^DHCITMINFO(AddInfo)
	.s Spec=$p(AddInfoData,"^",27)
	.s Model=$p(AddInfoData,"^",59)
	.s ManfId=$p(AddInfoData,"^",25)
	.s:ManfId'="" ManfDesc=$P($g(^PHMNF(ManfId)),"^",2)
	s VendorInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetPbVendor(Inci)
	s Vendor=$p(VendorInfo,"^",1)
	s VendorDesc=$p(VendorInfo,"^",2)
	s defaRp=##class(web.DHCSTMHUI.Common.AppCommon).GetAppPropValue("DHCSTDRUGMAINTAINM","ItmQueryDefaRp","")
	s bRp=##class(web.DHCSTMHUI.DrugInfoMaintain).Rp(Inci,BUomId,HospId,defaRp)
	s bSp=##Class(web.DHCSTMHUI.Common.PriceCommon).GetPriceElse(Inci,+$H,BUomId,HospId)
	s CertInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetCert(Inci)
	s CertNo=$p(CertInfo,"^",1)
	s CerExpDate=$p(CertInfo,"^",2)
	q Inci_"^"_ManfId_"^"_BUomId_"^"_Spec_"^"_Model_"^"_ManfDesc_"^"_Vendor_"^"_VendorDesc_"^"_BUomDesc_"^"_bRp_"^"_bSp_"^"_CertNo_"^"_InciDesc_"^"_CerExpDate
}

}
