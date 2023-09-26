Import sqluser

/// 高值材料执行情况查询
Class web.DHCSTMHUI.DHCItmTrackStat Extends (%RegisteredObject, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	已使用高值条码汇总
/// Creator:	lxt
/// CreateDate:	2018-09-11
/// Table:		DHC_HVMat_OrdItm
/// Input:		排序，查询条件
/// Return：	已使用高值条码汇总
/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.DHCItmTrackStat","QueryHvMat","{""Loc"":"""",""gUserId"":""16837"",""gLocId"":""7"",""gGroupId"":""99"",""gHospId"":""2"",""StartDate"":""2021-07-01"",""EndDate"":""2021-07-07"",""Vendor"":"""",""AddChargeFlag"":"""",""InciDesc"":"""",""Inci"":"""",""PamNo"":"""",""Label"":"""",""OriginalCode"":""""}")
Query QueryHvMat(Params As %Text) As Query(ROWSPEC = "orirowid,inci,inciCode,inciDesc,spec,uomDesc,barcode,BatNo,date,time,vendor,rp:%Float,sp:%Float,admloc,patname,adno,manf,expdate,Medicare,tel,orirecloc,model,qty:%Float") [ SqlProc ]
{
}

ClassMethod QueryHvMatExecute(ByRef qHandle As %Binary, Params As %Text) As %Status
{
	n (qHandle,Params)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s PJObj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJObj.%FromJSON(Params)
	s LocId=PJObj.%Get("Loc")
	s StartDate=PJObj.%Get("StartDate")
	s EndDate=PJObj.%Get("EndDate")
	s PVendorId=PJObj.%Get("Vendor")
	s PamNo=PJObj.%Get("PamNo")
	s Label=PJObj.%Get("Label")
	s OriginalCode=PJObj.%Get("OriginalCode")
	s Incid=PJObj.%Get("Inci")
	s TmpIncDesc=PJObj.%Get("InciDesc")
	s PInvNoFlag=PJObj.%Get("InvNoFlag")
	s gLocId=PJObj.%Get("gLocId")
	q:(StartDate="")||(EndDate="") $$$OK
	
	s StartDate=..DH2L(StartDate)
	s EndDate=..DH2L(EndDate)
	s StkGrpIdStr=##class(web.DHCSTMHUI.Util.DrugUtil).GetUserCatGrpStr("","",gLocId)
	
	s sqlStr="SELECT * FROM DHC_HVMat_OrdItm where ori_date between "_StartDate_" and "_EndDate
	s result=##class(%Library.ResultSet).%New()
	s result.RuntimeMode=0
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s orirowid=result.Data("ORI_RowId")
		s date=result.Data("ORI_OEORI_Date")
		s time=result.Data("ORI_OEORI_Time")
		s inci=result.Data("ORI_INCI_DR")
		s oeori=result.Data("ORI_OEORI_DR")
		s uom=result.Data("ORI_Unit_DR")
		s doctordr=result.Data("ORI_OEORI_UserAdd")
		s vendordr=result.Data("ORI_APCVM_DR")
		s BatNo=result.Data("ORI_BatNo")
		s expdate=result.Data("ORI_ExpDate")
		s qty=result.Data("ORI_Qty")
		s rp=result.Data("ORI_Rp")
		s sp=result.Data("ORI_Sp")
		s manfid=result.Data("ORI_MANF_DR")
		s admlocid=result.Data("ORI_AdmLoc_DR")			;就诊科室
		s InvNo=result.Data("ORI_InvNo")
		
		continue:(PVendorId'="")&&(vendordr'=PVendorId)
		continue:((PInvNoFlag="Y")&&(InvNo=""))||((PInvNoFlag="N")&&(InvNo'=""))
		s Ord=$p(oeori,"||",1),OrdCh=$p(oeori,"||",2)
		continue:(Ord="")||(OrdCh="")||'$d(^OEORD(Ord,"I",OrdCh))
		
		s orireclocid=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",6)
		continue:(LocId'="")&&(orireclocid'=LocId)	;医嘱接收科室
		s orirecloc=$s(orireclocid'="":$p(^CTLOC(orireclocid),"^",2),1:"")
		
		s barcode=$p(^DHCHVMORI(orirowid,1),"^",24)
		continue:barcode=""
		continue:((Label'="")&&(barcode'=Label))
		s dhcit=$o(^DHCIT(0,"LABEL",barcode,0))
		s:dhcit="" dhcit=$o(^DHCIT(0,"ORIGINALCODE",barcode,0))
		continue:dhcit=""
		
		continue:inci=""
		continue:((Incid'="")&&(Incid'=inci))
		s inciCode=$p(^INCI(inci,1),"^",1)
		s inciDesc=$p(^INCI(inci,1),"^",2)
		continue:((TmpIncDesc'="")&&(inciDesc'[TmpIncDesc))
		
		s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
		s ScgId=$p(ScgInfo,"^",5)
		continue:(StkGrpIdStr'="")&&(("^"_StkGrpIdStr_"^")'[("^"_ScgId_"^"))
		
		s (uomDesc,vendor,doctor,manf)=""
		s:uom'="" uomDesc=$p($g(^CT("UOM",uom)),"^",2)
		s:vendordr'="" vendor=$p(^APC("APCVM",vendordr),"^",3)
		s:doctordr'="" doctor=$p($g(^SSU("SSUSR",doctordr)),"^",2 )
		s:manfid'="" manf=$p(^PHMNF(manfid),"^",2)
		
		s:expdate'="" expdate=..DL2H(expdate)

		;病人信息
		s paadm=$p(^OEORD(+oeori),"^",1)
		s Painfo=##class(web.DHCSTMHUI.Common.AdmInfo).GetPatientInfoByAdm(paadm)
		s adno=Painfo.PatNo
		continue:((PamNo'="")&&(PamNo'=adno))
		s patname=Painfo.PatName
		s Medicare=Painfo.MrNo			;病人住院号
		s tel=Painfo.PatPhone				;电话号码
		s Adminfo=##class(web.DHCSTMHUI.Common.AdmInfo).GetAdmInfo(paadm)
		s ward=Adminfo.WardDesc
		s bed=Adminfo.BedNo
		
		s admloc=""
		s:admlocid'="" admloc=$p(^CTLOC(admlocid),"^",2)
		s admloc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(admloc)
		
		s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
		s model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(inci)
		s date=..DL2H(date)
		s time=..TL2H(time)
		d HVmatOutPutRow
	}
	
	;统计退回部分
	s sqlStr="SELECT * FROM DHC_HVMat_OrdItmRet where ORIR_Date between "_StartDate_" and "_EndDate
	s result=##class(%Library.ResultSet).%New()
	s result.RuntimeMode=0
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{
		s orirowid=result.Data("ORIR_RowId")
		s HVMId=result.Data("ORIR_ORI_DR")
		s date=result.Data("ORIR_Date")
		s time=result.Data("ORIR_Time")
		s inci=result.Data("ORIR_INCI_DR")
		s oeori=result.Data("ORIR_OEORI_DR")
		;s uom=result.Data("ORI_Unit_DR")
		;s doctordr=result.Data("ORI_OEORI_UserAdd")
		s vendordr=result.Data("ORIR_APCVM_DR")
		;s BatNo=result.Data("ORI_BatNo")
		;s expdate=result.Data("ORI_ExpDate")
		s qty=-result.Data("ORIR_Qty")						;取相反数(表内为正数)
		s rp=result.Data("ORIR_Rp")
		s sp=result.Data("ORIR_Sp")
		;s manfid=result.Data("ORI_MANF_DR")
		s admlocid=result.Data("ORIR_AdmLoc_DR")			;就诊科室
		
		s (uom,doctordr,BatNo,expdate,manfid)=""
		s HVMObj=##class(User.DHCHVMatOrdItm).%OpenId(HVMId)
		
		continue:HVMObj=""
		s doctordr=$p(^DHCHVMORI(HVMId,1),"^",4)
		s BatNo=$p(^DHCHVMORI(HVMId,1),"^",13)
		s expdate=$p(^DHCHVMORI(HVMId,1),"^",14)
		s manfid=$p(^DHCHVMORI(HVMId,1),"^",16)
		s uom=$p(^DHCHVMORI(HVMId,1),"^",18)
		s barcode=$p(^DHCHVMORI(HVMId,1),"^",24)
		s InvNo=$p(^DHCHVMORI(HVMId,1),"^",31)
		
		continue:barcode=""
		continue:(Label'="")&&(barcode'=Label)
		continue:(PVendorId'="")&&(vendordr'=PVendorId)
		continue:((PInvNoFlag="Y")&&(InvNo=""))||((PInvNoFlag="N")&&(InvNo'=""))
		s Ord=$p(oeori,"||",1),OrdCh=$p(oeori,"||",2)
		continue:(Ord="")||(OrdCh="")||'$d(^OEORD(Ord,"I",OrdCh))
		
		s orireclocid=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",6)
		continue:(LocId'="")&&(orireclocid'=LocId)	;医嘱接收科室
		s orirecloc=$s(orireclocid'="":$p(^CTLOC(orireclocid),"^",2),1:"")
		
		continue:inci=""
		continue:((Incid'="")&&(Incid'=inci))
		s inciCode=$p(^INCI(inci,1),"^",1)
		s inciDesc=$p(^INCI(inci,1),"^",2)
		continue:((TmpIncDesc'="")&&(inciDesc'[TmpIncDesc))
		
		s ScgInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp(inci)
		s ScgId=$p(ScgInfo,"^",5)
		continue:(StkGrpIdStr'="")&&(("^"_StkGrpIdStr_"^")'[("^"_ScgId_"^"))
		
		s (uomDesc,vendor,doctor,manf)=""
		s:uom'="" uomDesc=$p($g(^CT("UOM",uom)),"^",2)
		s:vendordr'="" vendor=$p(^APC("APCVM",vendordr),"^",3)
		s:doctordr'="" doctor=$p($g(^SSU("SSUSR",doctordr)),"^",2 )
		s:manfid'="" manf=$p(^PHMNF(manfid),"^",2)
		s:expdate'="" expdate=..DL2H(expdate)

		;病人信息
		s paadm=$p(^OEORD(+oeori),"^",1)
		s Painfo=##class(web.DHCSTMHUI.Common.AdmInfo).GetPatientInfoByAdm(paadm)
		s adno=Painfo.PatNo
		continue:((PamNo'="")&&(PamNo'=adno))
		s patname=Painfo.PatName
		s Medicare=Painfo.MrNo			;病人住院号
		s tel=Painfo.PatPhone				;电话号码
		s Adminfo=##class(web.DHCSTMHUI.Common.AdmInfo).GetAdmInfo(paadm)
		s ward=Adminfo.WardDesc
		s bed=Adminfo.BedNo
		
		
		s admloc=""
		s:admlocid'="" admloc=$p(^CTLOC(admlocid),"^",2)
		s admloc=##class(web.DHCSTMHUI.Util.DrugUtil).GetLocDesc(admloc)
		
		s spec=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetSpec("",inci)
		s model=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetModel(inci)
		s date=..DL2H(date)
		s time=..TL2H(time)
		d HVmatOutPutRow
	}
	Quit $$$OK
HVmatOutPutRow
	s Data=$lb(orirowid,inci,inciCode,inciDesc,spec,
		uomDesc,barcode,BatNo,date,time,
		vendor,rp,sp,admloc,patname,
		adno,manf,expdate,Medicare,tel,
		orirecloc,model,qty)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
