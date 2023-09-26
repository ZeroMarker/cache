Import SQLUser

Class web.DHCBPCAnticoagulantDrug Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPCAnticoagulantDrug","FindAnticoagulantDrug")
Query FindAnticoagulantDrug(hospId As %String = "") As %Query(ROWSPEC = "tID:%String,tBPCADCode:%String,tBPCADDesc:%String,tBPCADAmount:%String,tBPCADConcentration:%String,tBPCADUomDr:%String,tBPCADFirstAmount:%String,tBPCADDose:%String,tBPCADFrequency:%String,tBPCADNote:%String,tBPCAMIdList:%String,tBPCAMDescList:%String,tBPCDeptId:%String,tBPCDept:%String,tBPCADUomDesc:%String,tBPCADrSUDr:%String,tBPCADrSUDesc:%String,tBPCADDuration:%String,tBPCADIntervalMinute:%String,tBPCADCatDr:%String,tBPCADCatDesc:%String,tBPCADAmountDesc:%String,tBPCADConcentrationDesc:%String,tBPCADFirstAmountDesc:%String,tBPCADDoseDesc:%String,tBPCADFrequencyDesc:%String,tBPCADDurationDesc:%String,tBPCADIntervalMinuteDesc:%String,tBPCADNoteDesc:%String")
{
}

ClassMethod FindAnticoagulantDrugExecute(ByRef qHandle As %Binary, hospId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tID=0
	f  s tID=$o(^DHCBPC("AnticoagulantDrug",tID)) q:tID=""  d
	.s hospitalId=""
	.s DataAttributionDr=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),16)
	.i DataAttributionDr'="" s hospitalId=$li(^DHCBPC("DataAttribution",DataAttributionDr),1)
	.q:((hospitalId'="")&(hospId'=hospitalId))
	.s tBPCADCode=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),1)
	.s tBPCADDesc=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),2)
	.s tBPCADAmount=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),3)
	.s tBPCADAmountDesc=""
	.i tBPCADAmount="-1" s tBPCADAmountDesc="不显示"
	.s tBPCADConcentration=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),4)
	.s tBPCADConcentrationDesc=""
	.i tBPCADConcentration="-1" s tBPCADConcentrationDesc="不显示"
	.s tBPCADUomDr=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),5)
	.s tBPCADUomDesc=""
	.i tBPCADUomDr'="" s tBPCADUomDesc=$p(^CT("UOM",tBPCADUomDr),"^",2)
	.s tBPCADFirstAmount=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),6)
	.s tBPCADFirstAmountDesc=""
	.i tBPCADFirstAmount="-1" s tBPCADFirstAmountDesc="不显示"
	.s tBPCADDose=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),7)
	.s tBPCADDoseDesc=""
	.i tBPCADDose="-1" s tBPCADDoseDesc="不显示"
	.s tBPCADFrequency=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),8)
	.s tBPCADFrequencyDesc=""
	.i tBPCADFrequency="-1" s tBPCADFrequencyDesc="不显示"
	.s tBPCADNote=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),9)
	.s tBPCADNoteDesc=""
	.i tBPCADNote="-1" s tBPCADNoteDesc="不显示"
	.s tBPCADrSUDr=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),10)
	.s tBPCADrSUDesc=""
	.i tBPCADrSUDr'="" s tBPCADrSUDesc=$p(^DHCBPC("SUnit",tBPCADrSUDr),"^",2)
	.s tBPCADDuration=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),11)
	.s tBPCADDurationDesc=""
	.i tBPCADDuration="-1" s tBPCADDurationDesc="不显示"
	.s tBPCADIntervalMinute=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),12)
	.s tBPCADIntervalMinuteDesc=""
	.i tBPCADIntervalMinute="-1" s tBPCADIntervalMinuteDesc="不显示"
	.s tBPCADCatDr=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),13)
	.s tBPCADCatDesc=""
	.i tBPCADCatDr="1" s tBPCADCatDesc="组1"
	.i tBPCADCatDr="2" s tBPCADCatDesc="组2"
	.i tBPCADCatDr="3" s tBPCADCatDesc="组3"
	.i tBPCADCatDr="4" s tBPCADCatDesc="组4"
	.i tBPCADCatDr="5" s tBPCADCatDesc="组5"
	.i tBPCADCatDr="6" s tBPCADCatDesc="组6"
	.i tBPCADCatDr="7" s tBPCADCatDesc="组7"
	.i tBPCADCatDr="8" s tBPCADCatDesc="组8"
	.i tBPCADCatDr="9" s tBPCADCatDesc="组9"
	.i tBPCADCatDr="10" s tBPCADCatDesc="组10"
	.s tBPCDeptId=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),14)
	.s tBPCDept="" 
	.i tBPCDeptId'="" s tBPCDept=$p($g(^CTLOC(tBPCDeptId)),"^",2)
	.s retStr=..GetModeByDrugID(tID)
	.s tBPCAMIdList=$p($g(retStr),"/",1)
	.s tBPCAMDescList=$p($g(retStr),"/",2)
	.d OutputRow1   
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tID,tBPCADCode,tBPCADDesc,tBPCADAmount,tBPCADConcentration,tBPCADUomDr,tBPCADFirstAmount,tBPCADDose,tBPCADFrequency,tBPCADNote,tBPCAMIdList,tBPCAMDescList,tBPCDeptId,tBPCDept,tBPCADUomDesc,tBPCADrSUDr,tBPCADrSUDesc,tBPCADDuration,tBPCADIntervalMinute,tBPCADCatDr,tBPCADCatDesc,tBPCADAmountDesc,tBPCADConcentrationDesc,tBPCADFirstAmountDesc,tBPCADDoseDesc,tBPCADFrequencyDesc,tBPCADDurationDesc,tBPCADIntervalMinuteDesc,tBPCADNoteDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindAnticoagulantDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAnticoagulantDrugExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindAnticoagulantDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAnticoagulantDrugExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 
/// 参数：bpcADInfoList=BPCADCode^BPCADDesc^BPCADAmount^BPCADConcentration^BPCADUomDr^
///    					BPCADFirstAmount^BPCADDose^BPCADFrequency^BPCADNote^bpcAMIdList
/// 		药品信息=药品代码^药品名^总量^浓度^单位^首推量^剂量^频率^备注^抗凝方式
/// 返回：插入结果
ClassMethod InsertAnticoagulantDrug(bpcADInfoList As %String, hospId As %String = "")
{
	q:bpcADInfoList="" "输入的信息为空"
	k PLIST
	TSTART
    s PLIST(2)=$p(bpcADInfoList,"^",1)
	s PLIST(3)=$p(bpcADInfoList,"^",2)
	s PLIST(4)=$p(bpcADInfoList,"^",3)
	s PLIST(5)=$p(bpcADInfoList,"^",4)
	s PLIST(6)=$p(bpcADInfoList,"^",5)
	s PLIST(7)=$p(bpcADInfoList,"^",6)
	s PLIST(8)=$p(bpcADInfoList,"^",7)
	s PLIST(9)=$p(bpcADInfoList,"^",8)
	s PLIST(10)=$p(bpcADInfoList,"^",9)
	s PLIST(15)=$p(bpcADInfoList,"^",11)
	s PLIST(11)=$p(bpcADInfoList,"^",12)
	s PLIST(12)=$p(bpcADInfoList,"^",13)
	s PLIST(13)=$p(bpcADInfoList,"^",14)
	s PLIST(14)=$p(bpcADInfoList,"^",15)

	&SQL(insert into DHC_BPC_AnticoagulantDrug values:PLIST())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	
	s tRowid=%ROWID
	s Error=0
	s bpcAMDrList=$p(bpcADInfoList,"^",10)
	i bpcAMDrList'="" d
	f i=1:1:$l(bpcAMDrList,",") q:Error'=0  d
	.s bpcAMDr=$p(bpcAMDrList,",",i)
	.&SQL(insert into DHC_BPC_AnticoagulantModeDrug Values(:bpcAMDr,:tRowid))
	.s Error=SQLCODE
	i Error'=0  Trollback
	q:Error'=0 Error	
    TCOMMIT
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCAnticoagulantDrug")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPCAnticoagulantDrug",tRowid,hospId)
    }
	q Error
}

/// 参数：bpcADInfoList=BPCADCode^BPCADDesc^BPCADAmount^BPCADConcentration^BPCADUomDr^
///    					BPCADFirstAmount^BPCADDose^BPCADFrequency^BPCADNote^bpcAMIdList
/// 		药品信息=药品代码^药品名^总量^浓度^单位^首推量^剂量^频率^备注^抗凝方式
/// 返回：插入结果
/// 
ClassMethod UpdateAnticoagulantDrug(bpcADInfoList As %String, hospId As %String = "")
{
	q:bpcADInfoList="" "输入的信息为空"
	s bpcADId=$p(bpcADInfoList,"^",1)
	q:bpcADId="" "ID不能为空"
	K PLIST
	TSTART	
    s PLIST(1)=$p(bpcADInfoList,"^",1)
	s PLIST(2)=$p(bpcADInfoList,"^",2)
	s PLIST(3)=$p(bpcADInfoList,"^",3)
	s PLIST(4)=$p(bpcADInfoList,"^",4)
	s PLIST(5)=$p(bpcADInfoList,"^",5)
	s PLIST(6)=$p(bpcADInfoList,"^",6)
	s PLIST(7)=$p(bpcADInfoList,"^",7)
	s PLIST(8)=$p(bpcADInfoList,"^",8)
	s PLIST(9)=$p(bpcADInfoList,"^",9)
	s PLIST(10)=$p(bpcADInfoList,"^",10)
	s PLIST(15)=$p(bpcADInfoList,"^",12)
	s PLIST(11)=$p(bpcADInfoList,"^",13)
	s PLIST(12)=$p(bpcADInfoList,"^",14)
	s PLIST(13)=$p(bpcADInfoList,"^",15)
	s PLIST(14)=$p(bpcADInfoList,"^",16)
	&SQL(update DHC_BPC_AnticoagulantDrug values:PLIST() where ID=:bpcADId)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE	
	}
	s oldbpcAMDrList=..GetModeByDrugID(bpcADId)
	i oldbpcAMDrList'="" s oldbpcAMDrList=$p(oldbpcAMDrList,"/",1)
	s bpcAMDrList=$p(bpcADInfoList,"^",11)
	
	s Error=0,flag=0
	i bpcAMDrList'="" d
	.f i=1:1:$l(bpcAMDrList,",") q:Error'=0  d
	..s bpcAMDr=$p(bpcAMDrList,",",i)
	..s tID="",flag=0
	..f j=1:1:$l(oldbpcAMDrList,",") q:flag=1  d
	...s oldbpcAMDr=$p(oldbpcAMDrList,",",j)
	...i oldbpcAMDr=bpcAMDr s flag=1
	..i flag'=1  d
	...&SQL(insert into DHC_BPC_AnticoagulantModeDrug Values(:bpcAMDr,:bpcADId))
	...s Error=SQLCODE
	i Error'=0  Trollback
	q:Error'=0 Error
	
	s flag=0
	i oldbpcAMDrList'=""  d
	.f i=1:1:$l(oldbpcAMDrList,",") q:Error'=0  d
	..s oldbpcAMDr=$p(oldbpcAMDrList,",",i)
	..s flag=0
	..f j=1:1:$l(bpcAMDrList,",") q:flag=1  d
	...s bpcAMDr=$p(bpcAMDrList,",",j)
	...i bpcAMDr=oldbpcAMDr s flag=1 
	..i flag'=1  d
	...&SQL(delete from DHC_BPC_AnticoagulantModeDrug where BPCAMD_BPCAM_Dr=:oldbpcAMDr and BPCAMD_BPCAD_Dr=:bpcADId)
	...s Error=SQLCODE
	i Error'=0  Trollback
	q:Error'=0 Error
    TCOMMIT
    if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCAnticoagulantDrug")
	{
		do ##class(web.DHCBPCTablePermission).BindAttribution("User.DHCBPCAnticoagulantDrug",bpcADId,hospId)
    }
	q SQLCODE
}

/// d ##class(web.DHCBPCConsumable).DeleteConsumable(29)
ClassMethod DeleteAnticoagulantDrug(bpcADId) As %String
{
	q:bpcADId="" "ID不能为空!"
	TSTART
	i bpcADId'=""  d
	.s Error=0
	.&SQL(delete from DHC_BPC_AnticoagulantModeDrug where BPCAMD_BPCAD_Dr=:bpcADId)
	.s Error=SQLCODE
	.i Error'=0 TROLLBACK
	.i Error=0 &SQL(delete from DHC_BPC_AnticoagulantDrug  where ID=:bpcADId)
	.s Error=SQLCODE
	.i Error'=0 TROLLBACK
	TCOMMIT
	if ##class(web.DHCBPCTablePermission).IsPrivate("User.DHCBPCAnticoagulantDrug")
	{
		do ##class(web.DHCBPCTablePermission).UnbindAttribution("User.DHCBPCAnticoagulantDrug",bpcADId)
    }
	q Error
}

/// 通过药品ID查找
/// w ##class(web.DHCBPCAnticoagulantDrug).GetModeByDrugID("14")
ClassMethod GetModeByDrugID(drugId) As %String
{
	q:drugId="" ""
	s tMDRowid=0,retMId="",retMDesc=""
	f  s tMDRowid=$o(^DHCBPC("AnticoagulantModeDrug",tMDRowid)) q:tMDRowid=""  d
	.s tDrugDr=$lg($g(^DHCBPC("AnticoagulantModeDrug",tMDRowid)),2)
	.q:(drugId'=tDrugDr)
	.s tModeDr=$lg($g(^DHCBPC("AnticoagulantModeDrug",tMDRowid)),1)
	.s tModeDesc=""
	.i tModeDr'="" s tModeDesc=$lg($g(^DHCBPC("AnticoagulantMode",tModeDr)),2)
    .i retMDesc="" s retMDesc=tModeDesc
    .e  d  s retMDesc=retMDesc_","_tModeDesc
    .i retMId="" s retMId=tModeDr
    .e  d  s retMId=retMId_","_tModeDr
    q retMId_"/"_retMDesc
}

/// d ##class(%ResultSet).RunQuery("web.DHCBPCAnticoagulantDrug","GetAnticoagulantDrug")
Query GetAnticoagulantDrug(locId As %String = "") As %Query(ROWSPEC = "Id:%String,Code:%String,Description:%String,Amount:%String,Concentration:%String,UomId:%String,UomDesc:%String,FirstAmount:%String,Dose:%String,Frequency:%String,Note:%String,SpeedUnitId:%String,SpeedUnitDesc:%String,Duration:%String,IntervalMinute:%String,CatId:%String")
{
}

ClassMethod GetAnticoagulantDrugExecute(ByRef qHandle As %Binary, locId As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s locIdList=##Class(web.DHCBPCom).GetLinkLocByLocId(locId) //科室关联
 	s tID=0
	f  s tID=$o(^DHCBPC("AnticoagulantDrug",tID)) q:tID=""  d
	.s Code=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),1)
	.s Description=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),2)
	.s Amount=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),3)
	.s Concentration=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),4)
	.s UomId=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),5)
	.i UomId'="" s UomDesc=$p($g(^CT("UOM",UomId)),"^",2)
	.s FirstAmount=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),6)
	.s Dose=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),7)
	.s Frequency=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),8)
	.s Note=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),9)	
	.s SpeedUnitId=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),10)
	.i SpeedUnitId'="" s SpeedUnitDesc=$p($g(^DHCBPC("SUnit",SpeedUnitId)),"^",2)
	.s Duration=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),11)	
	.s IntervalMinute=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),12)
	.s CatId=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),13)
	.s LocDr=$lg($g(^DHCBPC("AnticoagulantDrug",tID)),14)
	.q:(LocDr'="")&&(locIdList'="")&&(("^"_locIdList_"^")'[("^"_LocDr_"^"))	
	.s Id=tID
	.d OutputRow1   
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(Id,Code,Description,Amount,Concentration,UomId,UomDesc,FirstAmount,Dose,Frequency,Note,SpeedUnitId,SpeedUnitDesc,Duration,IntervalMinute,CatId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetAnticoagulantDrugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAnticoagulantDrugExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod GetAnticoagulantDrugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAnticoagulantDrugExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// 给表User.DHCBPArrangeAnticoagulantDrug添加索引
/// w ##class(web.DHCBPCAnticoagulantDrug).SaveAnticoagulantDrugIndex("")
ClassMethod SaveAnticoagulantDrugIndex(drugId) As %String
{
	s tID=0
	f  s tID=$o(^DHCBPArrangeAnticoagulantDrug(tID)) q:tID=""  d
	.s arrangeId=$lg(^DHCBPArrangeAnticoagulantDrug(tID),1)
	.s ^DHCBPArrangeAnticoagulantDrug(0,"Arrange",arrangeId,tID) = "" 
	q "1"
}

}
