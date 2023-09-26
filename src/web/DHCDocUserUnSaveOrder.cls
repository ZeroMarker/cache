Import SQLUser

Class web.DHCDocUserUnSaveOrder Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCDocUserUnSaveOrder).GetUserUnSaveInfo("3")
/// 都已经修改成对象方式获取和插入使用对象存储保持一致性,增加可读和可维护性
ClassMethod GetUserUnSaveInfo(UUSDRowId)
{
	Quit:UUSDRowId="" ""
	set UUSDInfo=$g(^DHCOEORDUUSD("UUSD",UUSDRowId)),delim="^"
	s arcimrowid=$p(UUSDInfo,delim,4)
	s arcimdesc=$p(^ARCIM(+arcimrowid,1,1),delim,2)
	s billtyperowid=$p(UUSDInfo,delim,16)
	s PHPrescType=$p(UUSDInfo,delim,17)
	//s ArcimLinkInsu=##class(web.DHCINSUPort).ArcimLinkInsu(arcimrowid,billtyperowid)
	s ArcimLinkInsu1=##class(web.DHCDocInPatPortalCommon).GetArcimLinkInsuInfo(arcimrowid,billtyperowid,"","",6)
	i (ArcimLinkInsu1'="")&&(arcimdesc'=""){
		;医保类别(甲,乙,丁等)
		i (PHPrescType'=3) {
			 s arcimdesc="("_ArcimLinkInsu1_")"_ arcimdesc
		}
	}	
	s genericname=$p(UUSDInfo,delim,56)
	s Retstr=arcimrowid_$c(1)_arcimdesc_$c(1)_genericname
	s packqty=$p(UUSDInfo,delim,5)
	s packuomrowid=$p(UUSDInfo,delim,23),packuom=""
	i packuomrowid'="" s packuom=$p(^CT("UOM",packuomrowid),delim,2)
	s Retstr=Retstr_"^"_packqty_$c(1)_packuom_$c(1)_packuomrowid
	s doseqty=$p(UUSDInfo,delim,6)
	s doseuom=$p(UUSDInfo,delim,7)
	s doseuomrowid=$p(UUSDInfo,delim,8)
	s Retstr=Retstr_"^"_doseqty_$c(1)_doseuom_$c(1)_doseuomrowid
	s recdeprowid=$p(UUSDInfo,delim,9)
	s recdepdesc=$p(^CTLOC(recdeprowid),delim,2)
	s openforallhosp=$p(UUSDInfo,delim,10)
	s Retstr=Retstr_"^"_recdeprowid_$c(1)_recdepdesc_$c(1)_openforallhosp
	s phcfrowid=$p(UUSDInfo,delim,11),phcfrdesc="",phcfrfactor="",phcfrinterval=""
	i phcfrowid'="" {
		s phcfrdesc=$p(^PHCFR(phcfrowid),delim,1)
		s phcfrfactor=$p(^PHCFR(phcfrowid),delim,2)
		s phcfrinterval=$p(^PHCFR(phcfrowid),delim,5)
	}
	s Retstr=Retstr_"^"_phcfrowid_$c(1)_phcfrdesc_$c(1)_phcfrfactor_$c(1)_phcfrinterval
	s phcinrowid=$p(UUSDInfo,delim,15),phcindesc=""
	i phcinrowid'="" s phcindesc=$p(^PHCIN(phcinrowid),delim,2)
	s Retstr=Retstr_"^"_phcinrowid_$c(1)_phcindesc
	s phcdurowid=$p(UUSDInfo,delim,12),phcducode="",phcdufactor=""
	i phcdurowid'=""{
		s phcducode=$p(^PHCDU(phcdurowid),delim,1)
		s phcdufactor=$p(^PHCDU(phcdurowid),delim,2)
	}
	s Retstr=Retstr_"^"_phcdurowid_$c(1)_phcducode_$c(1)_phcdufactor
	s oecprowid=$p(UUSDInfo,delim,13)
	s oecprowid=$case(oecprowid,"6":"1","8":"5","28":"5","29":"1",:oecprowid)
	s oecprdesc=$p(^OECPR(oecprowid),delim,2)
	s priorremark=$p(UUSDInfo,delim,47)
	s Retstr=Retstr_"^"_oecprowid_$c(1)_oecprdesc_$c(1)_priorremark
	s billtyperowid=$p(UUSDInfo,delim,16)
	s billtype=$p(^PAC("ADMREA",billtyperowid),delim,2)
	s Retstr=Retstr_"^"_billtyperowid_$c(1)_billtype
	s presctype=$p(UUSDInfo,delim,17)
	s ordertype=$p(UUSDInfo,delim,18)	
	s seqno=$p(UUSDInfo,delim,19)
	s masterseqno=$p(UUSDInfo,delim,20)
	s unitprice=$p(UUSDInfo,delim,21)
	s sum=$p(UUSDInfo,delim,22)
	s Retstr=Retstr_"^"_presctype_"^"_ordertype_"^"_seqno_"^"_masterseqno_"^"_unitprice_"^"_sum
	s labspec=$p(UUSDInfo,delim,24)
	s labepisodeno=$p(UUSDInfo,delim,25)
	s arcosrowid=$p(UUSDInfo,delim,26)
	s covermainins=$p(UUSDInfo,delim,29)
	s depprocnote=$p(UUSDInfo,delim,30)
	s notifyclinician=$p(UUSDInfo,delim,37)
	s Retstr=Retstr_"^"_labspec_"^"_labepisodeno_"^"_covermainins_"^"_depprocnote_"^"_arcosrowid_"^"_notifyclinician
	s skintest=$p(UUSDInfo,delim,27)
	s actionrowid=$p(UUSDInfo,delim,28)
	//s skindesc=
	s Retstr=Retstr_"^"_skintest_$c(1)_actionrowid
	s docrowid=$p(UUSDInfo,delim,31),docdesc=""
	i docrowid'="" s docdesc=$p(^CTPCP(docrowid,1),delim,2)
	s Retstr=Retstr_"^"_docrowid_$c(1)_docdesc
	s userdeprowid=$p(UUSDInfo,delim,33)
	s userdep=$p(^CTLOC(recdeprowid),delim,2)
	s Retstr=Retstr_"^"_userdeprowid_$c(1)_userdep
	s useradd=$p(UUSDInfo,delim,32)
	//同仁医院不允许预开医嘱
	s startdate=$p(UUSDInfo,delim,34)
	s starttime=$p(UUSDInfo,delim,35)
	if startdate>+$h {
		s startdate=$zd(startdate,4)
		s starttime=..%ZT(starttime,2)
	}elseif startdate=..%SysDate() {
		if starttime<..%SysTime() {
			s startdate=$zd(+$h,4)
			s starttime=..%ZT(..%SysTime(),2)
		}else{
			s startdate=$zd(startdate,4)
			s starttime=..%ZT(starttime,2)
		}
	}else{
		s startdate=$zd(+$h,4)
		s starttime=..%ZT(..%SysTime(),2)
	}
	s firstdaytimes=$p(UUSDInfo,delim,36)
	s Retstr=Retstr_"^"_startdate_"^"_starttime_"^"_useradd_"^"_firstdaytimes
	s diacatrowid=$p(UUSDInfo,delim,38)
	s Retstr=Retstr_"^"_diacatrowid_$c(1)_docdesc
	s insusignsym=$p(UUSDInfo,delim,39)
	s insusignsymcode=$p(UUSDInfo,delim,40)
	s Retstr=Retstr_"^"_insusignsym_$c(1)_insusignsymcode
	s insucat=$p(UUSDInfo,delim,41)
	s bodypart=$p(UUSDInfo,delim,42)
	s stagecode=$p(UUSDInfo,delim,43)
	s insuapprovetype=$p(UUSDInfo,delim,44)
	s materialbarcode=$p(UUSDInfo,delim,45)
	s needpivaflag=$p(UUSDInfo,delim,48)
	s byselfomflag=$p(UUSDInfo,delim,50)
	s Retstr=Retstr_"^"_insucat_"^"_bodypart_"^"_stagecode_"^"_insuapprovetype_"^"_needpivaflag_"^"_byselfomflag_"^"_materialbarcode
	s exceedreasonrowid=$p(UUSDInfo,delim,49)
	s Retstr=Retstr_"^"_exceedreasonrowid
	s usereasonrowid=$p(UUSDInfo,delim,51)
	s Retstr=Retstr_"^"_usereasonrowid_$c(1)_insusignsymcode
	s antiusereason=$p(UUSDInfo,delim,52)
	s useabledays=$p(UUSDInfo,delim,53)
	s cpwstepitemrowid=$p(UUSDInfo,delim,54)
	s orderconfac=$p(UUSDInfo,delim,55)
	s Retstr=Retstr_"^"_antiusereason_"^"_useabledays_"^"_cpwstepitemrowid_"^"_orderconfac
	s speedflowrate=$p(UUSDInfo,delim,57)
	s flowrateunit=$p(UUSDInfo,delim,58),flowrateunitdesc=""
	i flowrateunit'="" s flowrateunitdesc=$p($G(^OEC("SFR",flowrateunit)),delim,2)
	s Retstr=Retstr_"^"_speedflowrate_$c(1)_flowrateunitdesc_$c(1)_flowrateunit
	s localinfusionqty=$p(UUSDInfo,delim,59)
	s showtabstr=$p(UUSDInfo,delim,60)
	s antiapplyrowid=$p(UUSDInfo,delim,61)
	s hiddenpara=$p(UUSDInfo,delim,62)
	s multidate=$p(UUSDInfo,delim,63)
	s orderfile2=$p(UUSDInfo,delim,64)
	s Retstr=Retstr_"^"_localinfusionqty_"^"_showtabstr_"^"_antiapplyrowid_"^"_hiddenpara_"^"_multidate_"^"_orderfile2
	
	s myobj=##class(User.DHCOEORIUUSD).%OpenId(UUSDRowId)
	Quit:'$IsObject(myobj) ""
	s OtherExpStr=myobj.UUSDOtherExpStr
	s Retstr=Retstr_"^"_OtherExpStr
	
	Quit Retstr
}

/// w ##class(web.DHCDocUserUnSaveOrder).GetUserUnSaveData("")
ClassMethod GetUserUnSaveData(PAAdmType, PAAdmId, UserId)
{
	Quit:(PAAdmType="")||(PAAdmId="")||(UserId="") ""	
	s UUSDRowId="",UserUnSave=""
	for {
		s UUSDRowId=$o(^DHCOEORDUUSD(PAAdmType,"UUSDPAADM",PAAdmId,"UUSDSSUSR",UserId,UUSDRowId)) q:UUSDRowId=""
		s UserUnSaveData=..GetUserUnSaveInfo(UUSDRowId)
		i UserUnSave="" s UserUnSave=UserUnSaveData
		e  s UserUnSave=UserUnSave_$c(2)_UserUnSaveData
		//i UserUnSave="" s UserUnSave=UUSDRowId
		//e  s UserUnSave=UserUnSave_$c(2)_UUSDRowId		
	}
	
	Quit UserUnSave
}

/// w ##class(web.DHCDocUserUnSaveOrder).UserUnSaveData("")
ClassMethod UserUnSaveData(AdmData, UnsaveData)
{
	;Quit:UnsaveData=""
	s PAAdmId=$p(AdmData,"^",1)
	s UserId=$p(AdmData,"^",2)
	s PAAdmType=$p(AdmData,"^",3)
	
	i $d(^DHCOEORDUUSD(PAAdmType,"UUSDPAADM",PAAdmId,"UUSDSSUSR",UserId)) {
		s UUSDRowId=""
		for {
			s UUSDRowId=$o(^DHCOEORDUUSD(PAAdmType,"UUSDPAADM",PAAdmId,"UUSDSSUSR",UserId,UUSDRowId)) q:UUSDRowId=""
			&sql(delete from DHC_OEORIUUSD where UUSD_Rowid=:UUSDRowId)
			
		}
		d ..InsertUserUnSaveData(AdmData, UnsaveData)
	}else{d ..InsertUserUnSaveData(AdmData, UnsaveData)}
	Quit 0
}

/// w ##class(web.DHCDocUserUnSaveOrder).DeleteUserSavedData("")
ClassMethod DeleteUserSavedData(PAAdmType, PAAdmId, UserId)
{
	Quit:(PAAdmType="")||(PAAdmId="")||(UserId="") 
	i $d(^DHCOEORDUUSD(PAAdmType,"UUSDPAADM",PAAdmId,"UUSDSSUSR",UserId)) {
		s UUSDRowId=""
		for {
			s UUSDRowId=$o(^DHCOEORDUUSD(PAAdmType,"UUSDPAADM",PAAdmId,"UUSDSSUSR",UserId,UUSDRowId)) q:UUSDRowId=""
			&sql(delete from DHC_OEORIUUSD where UUSD_Rowid=:UUSDRowId)
			
		}
	}
	Quit 0
}

/// w ##class(web.DHCDocUserUnSaveOrder).InsertUserUnSaveData("")
ClassMethod InsertUserUnSaveData(AdmData, UnsaveData)
{
	Quit:UnsaveData=""
	s PAAdmId=$p(AdmData,"^",1)
	s UserId=$p(AdmData,"^",2)
	s PAAdmType=$p(AdmData,"^",3)
	s LocId=$p(AdmData,"^",4)
	
	for i=1:1:$l(UnsaveData,$c(2)) {
		s UnsaveDataItem=$p(UnsaveData,$c(2),i)
		s ArcimRowid=$p(UnsaveDataItem,"^",1)
		continue:ArcimRowid=""
		s packqty=$p(UnsaveDataItem,"^",2)
		s doseqtystr=$p(UnsaveDataItem,"^",3)
		s doseqty=$p(doseqtystr,$c(1),1)
		s doseuom=$p(doseqtystr,$c(1),2)
		s doseuomId=$p(doseqtystr,$c(1),3)
		s reclocstr=$p(UnsaveDataItem,"^",4)
		s reclocId=$p(reclocstr,$c(1),1)
		s openforallhosp=$p(reclocstr,$c(1),2)
		s freqstr=$p(UnsaveDataItem,"^",5)
		s phcfreqId=$p(freqstr,$c(1),2)
		s instrucstr=$p(UnsaveDataItem,"^",6)
		s instrucId=$p(instrucstr,$c(1),2)
		s dustr=$p(UnsaveDataItem,"^",7)
		s phcduId=$p(dustr,$c(1),2)
		s priorId=$p(UnsaveDataItem,"^",8)
		s labstr=$p(UnsaveDataItem,"^",9)
		s labspecId=$p(labstr,$c(1),1)
		s labepisodeno=$p(labstr,$c(1),2)
		s otherstr=$p(UnsaveDataItem,"^",10)
		s arcosId=$p(otherstr,$c(1),1)
		s skintest=$p(otherstr,$c(1),2)
		s covermainins=$p(otherstr,$c(1),3)
		s actionId=$p(otherstr,$c(1),4)
		s notifyclinician=$p(otherstr,$c(1),5)
		s depprocnote=$p(otherstr,$c(1),6)
		s insucatId=$p(otherstr,$c(1),7)
		s insucat=$p(otherstr,$c(1),8)
		s insusignsymcode=$p(otherstr,$c(1),9)
		s insusignsym=$p(otherstr,$c(1),10)
		s bodypart=$p(otherstr,$c(1),11)
		s stagecode=$p(otherstr,$c(1),12)
		s genericname=$p(otherstr,$c(1),13)
		s insuapprovetype=$p(otherstr,$c(1),14)
		s cpwstepitemId=$p(otherstr,$c(1),15)
		s materialbarcode=$p(otherstr,$c(1),16)
		s localinfusingqty=$p(otherstr,$c(1),17)
		s useabledays=$p(otherstr,$c(1),18)
		
		s hiddenpara=$p(UnsaveDataItem,"^",11)
		s multidate=$p(UnsaveDataItem,"^",12)
		s seqno=$p(UnsaveDataItem,"^",13)
		s masterseqno=$p(UnsaveDataItem,"^",14)
		s billtypeId=$p(UnsaveDataItem,"^",15)
		s diacatId=$p(UnsaveDataItem,"^",16)
		s firstdaytimes=$p(UnsaveDataItem,"^",17)
		s speedflowrate=$p(UnsaveDataItem,"^",18)
		s startdate=$p(UnsaveDataItem,"^",19)
		s starttime=$p(UnsaveDataItem,"^",20)
		i startdate["-" s startdate=$zdh(startdate,3)
		i startdate["/" s startdate=$zdh(startdate,4)
		i startdate'="" s starttime=..%ZTH(starttime,1)
		
		s Ordreclocstr=$p(UnsaveDataItem,"^",21)
		
		s flowrateunit=$p(UnsaveDataItem,"^",22)
		s orderdate=$p(UnsaveDataItem,"^",23)
		s ordertime=$p(UnsaveDataItem,"^",24)
		s needpivaflag=$p(UnsaveDataItem,"^",25)
		s antiapplyId=$p(UnsaveDataItem,"^",26)
		s antiusereason=$p(UnsaveDataItem,"^",27)
		s priorremark=$p(UnsaveDataItem,"^",28)
		s usereasonId=$p(UnsaveDataItem,"^",29)
		s showtabstr=$p(UnsaveDataItem,"^",30)
		s byselfomflag=$p(UnsaveDataItem,"^",31)
		s exceedreasonId=$p(UnsaveDataItem,"^",32)
		
		s OtherOrdData=$p(UnsaveDataItem,"^",33)
		s docId=$p(OtherOrdData,$c(1),1)
		i docId="" s docId=$p(^SSU("SSUSR",UserId),"^",14)
		s userdep=$p(OtherOrdData,$c(1),2)
		i userdep="" s userdep=LocId
		s useraddId=$p(OtherOrdData,$c(1),3)
		i useraddId="" s useraddId=UserId
		s packuomId=$p(OtherOrdData,$c(1),4)
		s baseuomId=$p(OtherOrdData,$c(1),5)
		s ordertype=$p(OtherOrdData,$c(1),6)
		s presctype=$p(OtherOrdData,$c(1),7)
		s orderprice=$p(OtherOrdData,$c(1),8)
		s ordersum=$p(OtherOrdData,$c(1),9)
		s drugformId=$p(OtherOrdData,$c(1),10)
		s ordconfac=$p(OtherOrdData,$c(1),11)
		s OrderFile2=$p(OtherOrdData,$c(1),13)
		s OtherExpStr=$p(UnsaveDataItem,"^",34)
			
		s myobj=##class(User.DHCOEORIUUSD).%New()
		
		d myobj.UUSDPAADMDRSetObjectId(PAAdmId)
		d myobj.UUSDSSUSRDRSetObjectId(UserId)
		s myobj.UUSDAdmType = PAAdmType

		d myobj.UUSDItmMastDRSetObjectId(ArcimRowid)
		
		s myobj.UUSDDocDR = docId
		s myobj.UUSDUserAdd = useraddId
		s myobj.UUSDUserDep = userdep
		s myobj.UUSDPackUOM = packuomId
		s myobj.UUSDBaseUOMDR = baseuomId
		s myobj.UUSDOrderType = ordertype
		s myobj.UUSDPHPrescType = presctype
		s myobj.UUSDUnitPrice = orderprice
		s myobj.UUSDSum = ordersum
		s myobj.UUSDOrderConFac =ordconfac
		
		s myobj.UUSDPackQty = packqty
		s myobj.UUSDDoseQty = doseqty
		s myobj.UUSDDoseUOM = doseuom
		s myobj.UUSDDoseUOMDR = doseuomId
		s myobj.UUSDRecDepDR = reclocId
		s myobj.UUSDOpenForAllHosp = openforallhosp
		s myobj.UUSDPHCFreqDR = phcfreqId
		s myobj.UUSDPHCDUDR = phcduId
		s myobj.UUSDInstrDR = instrucId
		s myobj.UUSDPriorityDR = priorId
		s myobj.UUSDBillTypeDR = billtypeId
		
		s myobj.UUSDLabSpecDR = labspecId
		s myobj.UUSDLabEpisodeNo = labepisodeno
		s myobj.UUSDARCOSDR = arcosId
		s myobj.UUSDSkinTest = skintest
		s myobj.UUSDActionDR = actionId
		s myobj.UUSDCoverMainIns = covermainins
		s myobj.UUSDNotifyClinician = notifyclinician
		s myobj.UUSDDepProcNote = depprocnote
		s myobj.UUSDInsuCat = insucatId
		s myobj.UUSDInsuSignSymptomCode = insusignsymcode
		s myobj.UUSDInsuSignSymptom= insusignsym
		s myobj.UUSDGenericName= genericname
		s myobj.UUSDInsuApproveType = insuapprovetype
		s myobj.UUSDCPWStepItemDR = cpwstepitemId
		s myobj.UUSDMaterialBarcode = materialbarcode
		s myobj.UUSDUseableDays = useabledays
		
		s myobj.UUSDSeqNo = seqno
		s myobj.UUSDMasterSeqNo = masterseqno
		s myobj.UUSDDIACatDR = diacatId
		s myobj.UUSDFirstDayTimes = firstdaytimes
		s myobj.UUSDSpeedFlowRate= speedflowrate
		s myobj.UUSDStartDate = startdate
		s myobj.UUSDStartTime = starttime
		s myobj.UUSDFlowRateUnit= flowrateunit
		s myobj.UUSDNeedPIVAFlag = needpivaflag
		s myobj.UUSDAntiUseReason = antiusereason    //
		s myobj.UUSDPriorRemarks = priorremark
		s myobj.UUSDUseReasonDR = usereasonId
		s myobj.UUSDBySelfOMFlag = byselfomflag
		s myobj.UUSDExceedReasonDR = exceedreasonId
		s myobj.UUSDBodyPart = bodypart
		s myobj.UUSDStageCode = stagecode	
		s myobj.UUSDLocalInfusionQty = localinfusingqty
		s myobj.UUSDShowTabStr = showtabstr
		s myobj.UUSDAntibApplyDR = antiapplyId
		s myobj.UUSDHiddenPara = hiddenpara
		s myobj.UUSDMultiDate = multidate
		s myobj.UUSDFile2 = OrderFile2
		s myobj.UUSDOtherExpStr = OtherExpStr
		
		s sc=myobj.%Save()
	
		If ($System.Status.IsError(sc)){
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-105"
		}
		d myobj.%Close()
		//&sql(insert into DHC_OEORIUUSD values PLIST())
	}
	Quit 0
}

}
