/// 名称: DHCCPW.MRC.FORM.LnkArcimSrv
/// 描述: 关联医嘱处理相关服务
/// 编写者：chenjb
/// 编写日期: 2018-09-18
Class DHCMA.CPW.BTS.LinkArcimSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2015-06-18
/// Description:  判断医嘱（药品）是否有库存（From医生站）
/// Input：       ArcimID : 医嘱项
/// Return:		  返回return=1：有库存，return=0：无库存
/// w ##class(DHCMA.CPW.BTS.LinkArcimSrv).CheckArcimInci("","")
ClassMethod CheckArcimInci(aEpisodeID As %String, aArcimID As %String) As %String
{
	New (aEpisodeID,aArcimID)
	Set return=0
	Quit:(aEpisodeID="")||(aArcimID="") return
	Set $ZT="CheckArcimInciErr"
	Set ret=##Class(web.DHCDocOrderEntry).GetStockQty(aEpisodeID,aArcimID)
	Set return=$s(+ret>0:1,1:0)
	Quit return
CheckArcimInciErr
	Quit 0
}

/// Creator:     chenjb
/// CreatDate:   2018-06-12
/// Description: 查询医嘱项默认 单次剂量,剂量单位,频次,用法,疗程
/// w ##class(DHCMA.CPW.BTS.LinkArcimSrv).GetArcimInfoById("2477||1")
ClassMethod GetArcimInfoById(aArcimID As %String, aHospID As %String = "") As %String
{
	New (aArcimID,aHospID,%session)
	Set return=""
	Quit:aArcimID="" return
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Set:(aHospID="")&&$d(%session) aHospID=$g(%session.Data("LOGON.HOSPID"))
	If $l(aArcimID,"||")=2 {
		Set (FormDoseUOMID,FormDoseUOMDesc,FormFreqID,FormFreqDesc,FormInstrID,FormInstrDesc,FormDurID,FormDurDesc,FormDoseQty)=""
		Set (PHCGeneID,PHCGeneDesc,PHCSpecDesc,PHCFormID,PHCFormDesc)=""
		Set (OrderPackUOMID,OrderPackUOM)=""
		
		Set ItemCatRowid=$p($g(^ARCIM(+aArcimID,+$p(aArcimID,"||",2),1)),"^",10)
		Set OrderType=$p($g(^ARC("IC",+ItemCatRowid)),"^",7)
		If OrderType="R"{
			Set PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(+ItemCatRowid,+aHospID)	//处方类别代码:1:西药,2:中成药3:草药4:有频次的处置治疗5:精神二类药
			If PHPrescType="" Set PHPrescType="1"
		}Else{
			Set PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(+ItemCatRowid,+aHospID)	//处方类别代码:1:西药,2:中成药3:草药4:有频次的处置治疗5:精神二类药
		}
		Set ARCICOrderType=$p($g(^ARC("IC",+ItemCatRowid)),"^",7)
		
		Set ArcimDesc=$p($g(^ARCIM(+aArcimID,+$p(aArcimID,"||",2),1)),"^",2)    //医嘱名称
		Set:ArcimDesc'="" ArcimDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCItmMast","ARCIMDesc",ArcimDesc,Languages)
		Set PHCGeneID=$p($g(^ARCIM(+aArcimID,+$p(aArcimID,"||",2),8)),"^",20)   //通用名
		Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)
		Set:PHCGeneDesc'="" PHCGeneDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCGeneric","PHCGEName",PHCGeneDesc,Languages)
		Set:PHCGeneDesc="" PHCGeneDesc=ArcimDesc   //医嘱名称
		
		Set DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(aArcimID)     //药学项
		If DrgformRowid'="" {
			Set PHCDRowid=$p(DrgformRowid,"||",1)
		  	Set ChildSub=$p(DrgformRowid,"||",2)
			Set FormFreqID=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)    //频次
			Set FormInstrID=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",5)   //用法
			Set FormDurID=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)     //疗程
			Set PHCFormID=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",1)     //剂型
			
			//剂量及单位优先级：默认等效>等效>药学基本单位 fix by yankai 20190804
			Set PHUseEqQty=##Class(web.DHCDocConfig).GetConfigNode("PHUseEqQty",+aHospID)
			Set leq=0,FormDoseQty="",FormDoseUOMID=""
			For {
				Set leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)) 
				Quit:leq=""
				
				Set eqrec=^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)
	  			Set FormDoseUOMRowid=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2),eqdefaultqty=$p(eqrec,"^",3)
	  			If eqdefaultqty'=""{ 
	  				Set FormDoseQty=eqdefaultqty
	  				Set FormDoseUOMID=FormDoseUOMRowid
	  			}
	  			If FormDoseQty=""{
		  			Set FormDoseQty=eqqty
		  			Set FormDoseUOMID=FormDoseUOMRowid
		  		}
	  			If (FormDoseQty'="")&(FormDoseQty<1)&(FormDoseQty'=0){
		  			Set FormDoseQty="0"_FormDoseQty
		  		} 
			}
			If ('PHUseEqQty) {
				Set FormDoseUOMID=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4) //剂量单位
				Set FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5)   //剂量
			}
		}Else{
			If (PHPrescType="4"){	//有频次的处置操作
				Set FormDoseUOMID=$p($g(^ARCIM(+aArcimID,$p(aArcimID,"||",2),8)),"^",14)		//剂量单位
			}	
		}
		Set Inci=$o(^INCI(0,"ARCIM_DR",+aArcimID,""))  //库存项
		If Inci'="" {
			Set InciInfo=$o(^DHCITMINFO(0,"INCI",Inci,""))
			Set PHCSpecDesc=$p($g(^DHCITMINFO(+InciInfo)),"^",27)
			Set:PHCSpecDesc'="" PHCSpecDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.DHCItmAddionInfo","INFOSpec",PHCSpecDesc,Languages)
			/*	$p($g(^INCI(Inci,3)),"^",9)取值为条码字段，此处赋值疑似有误，暂注释	
			If PHCSpecDesc="" {
				Set PHCSpecDesc=$p($g(^INCI(Inci,3)),"^",9)                  //规格
			}*/
		}
		
		If PHPrescType="4" {
			Set FormFreqID=##class(web.DHCDocConfig).GetConfigNode("FrequencedItemFreq",+aHospID)
			Set FormDurID=##class(web.DHCDocConfig).GetConfigNode("FrequencedItemDur",+aHospID)
		}
		//Set CPWHospitalCode=##class(User.DHCMRCBaseConfig).GetValueByCode("CPWHospitalCode")
		//Set:CPWHospitalCode="BJ_FXYY" FormDurID=""
		
		Set:FormDoseUOMID'="" FormDoseUOMDesc=$p($g(^CT("UOM",FormDoseUOMID)),"^",2)
		Set:FormDoseUOMDesc'="" FormDoseUOMDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTUOM","CTUOMDesc",FormDoseUOMDesc,Languages)
		Set:FormFreqID'="" FormFreqDesc=$p($g(^PHCFR(FormFreqID)),"^",3)
		Set:FormFreqDesc'="" FormFreqDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCFreq","PHCFRDesc2",FormFreqDesc,Languages)
		Set:FormInstrID'="" FormInstrDesc=$p($g(^PHCIN(FormInstrID)),"^",2)
		Set:FormInstrDesc'="" FormInstrDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCInstruc","PHCINDesc1",FormInstrDesc,Languages)
		Set:FormDurID'="" FormDurDesc=$p($g(^PHCDU(FormDurID)),"^",3)
		Set:FormDurDesc'="" FormDurDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCDuration","PHCDUDesc1",FormDurDesc,Languages)
		Set:PHCFormID'="" PHCFormDesc=$p($g(^PHCF(PHCFormID)),"^",2)
		Set:PHCFormDesc'="" PHCFormDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.PHCForm","PHCFDesc",PHCFormDesc,Languages)
		
		//数量单位：药品取库存项表住院药房发药单位，其他取医嘱项表计价单位 Modified by yankai 2022-01-11
		Set retQtyUom=##Class(DHCMA.CPW.IO.FromDoc).GetQtyUomByArcimID(aArcimID)
		Set OrderPackUOMID=$p(retQtyUom,"^",1)
		Set OrderPackUOM=$p(retQtyUom,"^",2)
		Set:OrderPackUOM'="" OrderPackUOM=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.CTUOM","CTUOMDesc",OrderPackUOM,Languages)
		
		Set return=aArcimID_"^"_OrderType_"^"_PHPrescType
		Set return=return_"^"_FormDoseQty_"^"_FormDoseUOMID_"^"_FormDoseUOMDesc   //单次剂量、单位
		Set return=return_"^"_FormDurID_"^"_FormDurDesc      //疗程
		Set return=return_"^"_FormFreqID_"^"_FormFreqDesc    //频次
		Set return=return_"^"_FormInstrID_"^"_FormInstrDesc  //用法
		Set return=return_"^"_PHCFormID_"^"_PHCFormDesc      //规格
		Set return=return_"^"_PHCGeneID_"^"_PHCGeneDesc_"^"_PHCSpecDesc  //通用名、剂型
		Set return=return_"^"_OrderPackUOMID_"^"_OrderPackUOM    //整包装单位
		Set return=return_"^"_ArcimDesc          //20医嘱名称
		Set return=return_"^"_ARCICOrderType	//医嘱类型
	} Else {
		Set ARCOSDesc=$p($g(^ARCOS(+aArcimID)),"^",2)
		Set:ARCOSDesc'="" ARCOSDesc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ARCOrdSets","ARCOSDesc",ARCOSDesc,Languages)
		Quit:ARCOSDesc="" return
		
		Set return=aArcimID_"^"_""_"^"_""
		Set return=return_"^"_""_"^"_""_"^"_""   //单次剂量、单位
		Set return=return_"^"_""_"^"_""          //疗程
		Set return=return_"^"_""_"^"_""          //频次
		Set return=return_"^"_""_"^"_""          //用法
		Set return=return_"^"_""_"^"_""          //规格
		Set return=return_"^"_""_"^"_ARCOSDesc_"^"_""  //通用名、剂型
		Set return=return_"^"_""_"^"_""          //整包装单位
		Set return=return_"^"_ARCOSDesc          //20医嘱套名称
		Set return=return_"^"_""	//医嘱类型
	}
	
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2018-06-11
/// Description:  取医嘱类型（长期医嘱、临时医嘱、自备要医嘱等）
/// Input：       无
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.LinkArcimSrv","QryOECPriority")
Query QryOECPriority() As %Query(ROWSPEC = "OECPRID:%String,OECPRCode:%String,OECPRDesc:%String")
{
}

ClassMethod QryOECPriorityExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set OECPRID=""
	For {
		Set OECPRID=$o(^OECPR(OECPRID))
		Quit:OECPRID=""
		Set OECPRCode=$p($g(^OECPR(OECPRID)),"^",1)
		Set OECPRDesc=$p($g(^OECPR(OECPRID)),"^",2)
		Set Data=$lb(OECPRID,OECPRCode,OECPRDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryOECPriorityClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOECPriorityExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOECPriorityFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOECPriorityExecute ]
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

/// Creator：     chenjb
/// CreatDate：   2018-06-11
/// Description:  别名检索医嘱项
/// Table:        SQLUSER.ARC_ItmMast
/// Input：       q ：别名关键字，aHospID:院区id, aIsShowOrdSet:是否返回医嘱套（1：是，0：否）, aFlag:是否检查有效性（1：是，""：否）
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.LinkArcimSrv","QryArcimByAlias","5%葡萄糖氯化钠注射液(塑瓶)","2","","")
Query QryArcimByAlias(q As %String = "", aHospID As %String = "", aIsShowOrdSet As %String = "1", aFlag As %String = "") As %Query(ROWSPEC = "ArcimID:%String,ArcimCode:%String,ArcimDesc:%String,OrdPrice:%String")
{
}

ClassMethod QryArcimByAliasExecute(ByRef qHandle As %Binary, q As %String = "", aHospID As %String = "", aIsShowOrdSet As %String = "1", aFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	Set aAlias = q
	Set aHospID=$p(aHospID,"!!",1)
	Quit:(aHospID="")||(q="") $$$OK
	
	Set isFuzSearch=0
	Set aLastChar=$e(aAlias,$l(aAlias),$l(aAlias))
	If (aLastChar=".")||(aLastChar="。") {
		Set isFuzSearch=1
		Set aAlias=$e(aAlias,1,$l(aAlias)-1)
	}
	s JIndex=$j,ZIndex=$zn
	
	//关联医嘱项
	k ^TMP(ZIndex,JIndex,"ARCItemMast")
	
	//医嘱别名查询医嘱项
	//^ARC("ALIAS",0,"Desc",$$ALPHAUP({ALIAS_Text})_" ",$$ALPHAUP({ALIAS_Desc}),{ALIAS_RowId},1)
	//s aAlias=$zcvt(aAlias,"U")
	Set aAlias=$$ALPHAUP^SSUTIL4(aAlias)
	s Alias="" 													//$o(^ARC("ALIAS",0,"Desc",aAlias),-1)
	f  s Alias=$o(^ARC("ALIAS",0,"Desc",Alias)) q:(Alias="")  d
	.q:(isFuzSearch=0)&&($e(Alias,1,$l(aAlias))'=aAlias)
	.q:(isFuzSearch=1)&&(Alias'[aAlias)
	.s ARCDesc=""
	.f  s ARCDesc=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc)) q:ARCDesc=""  d
	..s ARCRowid=0
	..f  s ARCRowid=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc,ARCRowid)) q:ARCRowid=""  d
	...q:'$d(^ARC("ALIAS",ARCRowid))
	...s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
	...q:ARCType'="ARCIM"
	...s ARCAlias=$p(^ARC("ALIAS",ARCRowid),"^",6)
	...s ARCAlias=$zcvt(ARCAlias,"U")
	...q:(isFuzSearch=0)&&($e(ARCAlias,1,$l(aAlias))'=aAlias)
	...q:(isFuzSearch=1)&&(ARCAlias'[aAlias)
	...s ARCItemID=$p(^ARC("ALIAS",ARCRowid),"^",1)
	...q:ARCItemID=""
	...q:$d(^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID))
	...d BuildDataToARCIM
	...s ^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID)=""
	
	//医嘱名称查询医嘱项
	//^ARCIM(0,"Desc",$$ALPHAUP({ARCIM_Desc}),{ARCIM_Subscript},{ARCIM_Version})
	//Set aAlias = $zcvt(q,"U")
	//Set aAlias=$$ALPHAUP^SSUTIL4(q)
	//s Alias=$o(^ARCIM(0,"Desc",aAlias),-1)
	s Alias=""
	f  s Alias=$o(^ARCIM(0,"Desc",Alias)) q:(Alias="")  d		//($e(Alias,1,$l(aAlias))'=aAlias)  d
	.q:(isFuzSearch=0)&&($e(Alias,1,$l(aAlias))'=aAlias)
	.q:(isFuzSearch=1)&&(Alias'[aAlias)
	.s ItemSub=0
	.f  s ItemSub=$o(^ARCIM(0,"Desc",Alias,ItemSub)) q:ItemSub=""  d
	..s ItemVer=0
	..f  s ItemVer=$o(^ARCIM(0,"Desc",Alias,ItemSub,ItemVer)) q:ItemVer=""  d
	...s ARCItemID=ItemSub_"||"_ItemVer
	...q:$d(^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID))
	...d BuildDataToARCIM
	...s ^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID)=""
	
	k ^TMP(ZIndex,JIndex,"ARCItemMast")
	
	If aIsShowOrdSet="1"{
	//根据配置判断是否允许关联检验医嘱套
	//只有Medtrak程序才允许关联医嘱套(安贞、友谊、复兴等)
	//If IsLinkLabARCOS="Y" {
		k ^TMP(ZIndex,JIndex,"ARCOrdSet")
		
		//医嘱套别名查询
		//^ARC("ALIAS",0,"Desc",$$ALPHAUP({ALIAS_Text})_" ",$$ALPHAUP({ALIAS_Desc}),{ALIAS_RowId},1)
		//Set aAlias = q
		//s aAlias=$zcvt(aAlias,"U")
		Set aAlias=$$ALPHAUP^SSUTIL4(aAlias)
		s Alias="" 							//$o(^ARC("ALIAS",0,"Desc",aAlias),-1)
		f  s Alias=$o(^ARC("ALIAS",0,"Desc",Alias)) q:(Alias="")  d
		.q:(isFuzSearch=0)&&($e(Alias,1,$l(aAlias))'=aAlias)
		.q:(isFuzSearch=1)&&(Alias'[aAlias)
		.s ARCDesc=""
		.f  s ARCDesc=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc)) q:ARCDesc=""  d
		..s ARCRowid=0
		..f  s ARCRowid=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc,ARCRowid)) q:ARCRowid=""  d
		...q:'$d(^ARC("ALIAS",ARCRowid))
		...s ARCAlias=$p(^ARC("ALIAS",ARCRowid),"^",6)
		...s ARCAlias=$zcvt(ARCAlias,"U")
		...s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
		...q:ARCType'="ARCOS"
		...s ARCOrdSetID=$p(^ARC("ALIAS",ARCRowid),"^",2)
		...q:ARCOrdSetID=""
		...q:$d(^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID))
		...d BuildDataToARCOS
		...s ^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID)=""
		
		//医嘱套名称查询
		//^ARCOS(0,"Desc",$$ALPHAUP({ARCOS_Desc}),{ARCOS_RowId})
		//Set aAlias = $zcvt(q,"U")
		Set aAlias=$$ALPHAUP^SSUTIL4(aAlias)
		s Alias=""
		f  s Alias=$o(^ARCOS(0,"Desc",Alias)) q:(Alias="")  d
		.q:(isFuzSearch=0)&&($e(Alias,1,$l(aAlias))'=aAlias)
		.q:(isFuzSearch=1)&&(Alias'[aAlias)
		.s ARCOrdSetID=0
		.f  s ARCOrdSetID=$o(^ARCOS(0,"Desc",Alias,ARCOrdSetID)) q:ARCOrdSetID=""  d
		..q:$d(^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID))
		..d BuildDataToARCOS
		..s ^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID)=""
		
		k ^TMP(ZIndex,JIndex,"ARCOrdSet")
	//}
	}
	Quit $$$OK
	
BuildDataToARCIM
	//医嘱项院区检查
	/*
	s showFlg=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",ARCItemID,aHospID)	//调用基础数据平台组检查院区显示权限
	q:showFlg="N"
	*/
	s showFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("ARC_ItmMast",ARCItemID,aHospID)	////调用封装的基础数据平台组检查院区显示权限接口
	q:showFlg'="Y"
	
	s ARCItemSub=$p(ARCItemID,"||",1)
	s ARCItemVer=$p(ARCItemID,"||",2)
	q:(ARCItemSub="")||(ARCItemVer="")
	s ARCItemCode=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",1)
	s ARCItemDesc=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",2)
	s ARCItemCode=$tr(ARCItemCode,$c(13),"")
	s ARCItemCode=$tr(ARCItemCode,$c(13),"")
	s ARCItemDesc=$tr(ARCItemDesc,$c(13),"")
	s ARCItemDesc=$tr(ARCItemDesc,$c(10),"")
	q:ARCItemDesc=""
	s OrderOnItsOwn=$p($g(^ARCIM(ARCItemSub,ARCItemVer,7)),"^",13)
	//q:(IsLinkLabARCOS="Y")&&(OrderOnItsOwn'["Y")
	q:(OrderOnItsOwn'["Y")
	s ARCItemEffDateTo=$p($g(^ARCIM(ARCItemSub,ARCItemVer,7)),"^",1)
	//update by zqy 20220602
	//判断医嘱项是否需要判断有效
	if (aFlag=""){
		q:(ARCItemEffDateTo'="")&(ARCItemEffDateTo<=$p($h,",",1))
		//**********************************************
		//update by zf 20110902
		//判断医嘱项是否有效(有效日期,截止日期)
		s effDateFrom=$p($g(^ARCIM(ARCItemSub,ARCItemVer,1)),"^",13)
		s:effDateFrom'="" effDateFrom=$p(effDateFrom,"Z",1)
		s effDateTo=$p($g(^ARCIM(ARCItemSub,ARCItemVer,7)),"^",1)
		s currDate=+$h
		q:((effDateFrom'="")&&(effDateFrom>currDate))
		q:((effDateTo'="")&&(effDateTo<currDate))
	}
    //检查临床路径与航天HIS医嘱项数据一致性
	//s flg=##Class(web.DHCCPW.MR.InterfaceToPrj).CheckArcimConsistency(ARCItemID)
	//s:flg'="" ARCItemDesc="(!)"_ARCItemDesc_","_flg
	//q:flg'=""
	//**********************************************
	Set OrdPrice = ##class(DHCMA.CPW.BTS.BudgetCostSrv).GetOrderDispensePrice(ARCItemID,+aHospID)
	Set OrdPrice = $p(OrdPrice,"^",1)
	
	s Data=$lb(ARCItemID,ARCItemCode,ARCItemDesc,OrdPrice)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
	
BuildDataToARCOS
	//医嘱套院区检查
	/*
	s FavRowID="",chkFlg=0
	f  s FavRowID=$o(^DHCFavItems(0,"ItemRowid",ARCOrdSetID,FavRowID)) q:(FavRowID="")  d
	.s xHospID=$p($g(^DHCFavItems(FavRowID)),"^",9)
	.s:(xHospID="")||(xHospID=aHospID) chkFlg=1
	q:chkFlg=0
	*/
	s showFlg=##class(DHCMA.Util.IO.MultiHospInterface).IsShowOneDataByHosp("ARC_OrdSets",ARCOrdSetID,aHospID)	////调用封装的基础数据平台组检查院区显示权限接口
	q:showFlg'="Y"
	
	s ARCOrdSetCode=$p($g(^ARCOS(ARCOrdSetID)),"^",1)
	s ARCOrdSetDesc=$p($g(^ARCOS(ARCOrdSetID)),"^",2)
	s ARCOrdSetCode=$tr(ARCOrdSetCode,$c(13),"")
	s ARCOrdSetCode=$tr(ARCOrdSetCode,$c(13),"")
	s ARCOrdSetDesc=$tr(ARCOrdSetDesc,$c(13),"")
	s ARCOrdSetDesc=$tr(ARCOrdSetDesc,$c(10),"")
	q:ARCOrdSetDesc=""
	s ARCOrdSetDesc="[医嘱套]"_ARCOrdSetDesc
	;s LabSetNo=$p($g(^ARCOS(+ARCOrdSetID)),"^",11)
	;q:LabSetNo=""
	//**********************************************
	//update by zqy 20220602
	//判断医嘱套是否需要判断有效
	if (aFlag=""){
		//update by zf 20110902
		//判断医嘱套是否有效(有效日期,截止日期)
		s effDateFrom=$p($g(^ARCOS(ARCOrdSetID)),"^",15)
		s effDateTo=$p($g(^ARCOS(ARCOrdSetID)),"^",16)
		s currDate=+$h
		q:((effDateFrom'="")&&(effDateFrom>currDate))
		q:((effDateTo'="")&&(effDateTo<currDate))
	}
	//**********************************************
	Set OrdPrice = ""
	
	s Data=$lb(ARCOrdSetID,ARCOrdSetCode,ARCOrdSetDesc,OrdPrice)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QryArcimByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryArcimByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryArcimByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryArcimByAliasExecute ]
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

/// Creator:     chenjb
/// CreatDate:   2018-06-11
/// Description: 剂量单位
/// Table:       SQLUSER.ARC_ItmMast
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.LinkArcimSrv","QryDoseUomByArcim","9986||1")
Query QryDoseUomByArcim(aArcimID As %String, aHospID As %String = "") As %Query(ROWSPEC = "DoseUomID:%String,DoseUomDesc:%String")
{
}

ClassMethod QryDoseUomByArcimExecute(ByRef qHandle As %Binary, aArcimID As %String, aHospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(aArcimID="")||(aArcimID'["||") $$$OK
	
	Set ItemCatRowid=$p($g(^ARCIM(+aArcimID,+$p(aArcimID,"||",2),1)),"^",10)
	Set PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(+ItemCatRowid, +aHospID)	//处方类别代码:1:西药,2:中成药3:草药4:有频次的处置治疗5:精神二类药
	
	Set (UOMRowid1,UOMDesc)=""
	If PHPrescType'=4{
		Set DrgFormRowid=$p($g(^ARCIM(+aArcimID,$p(aArcimID,"||",2),1)),"^",12)  //剂量
		Set:DrgFormRowid=-1 DrgFormRowid=""
		If DrgFormRowid'="" {
			Set PHCDRowid=$P(DrgFormRowid,"||",1)
			Set ChildSub=$P(DrgFormRowid,"||",2)
			Set UserLanguage=""
			Set UOMRowid1=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
			If UserLanguage="EN" {
				Set UOMDesc=$p($g(^CT("UOM",UOMRowid1)),"^",3)
			}Else{
				Set UOMDesc=$p($g(^CT("UOM",UOMRowid1)),"^",2)
			}
			
			Set Data=$lb(UOMRowid1,UOMDesc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		 	
			Set leq=0
			For {
				Set leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq))
				Quit:leq=""
				Set eqrec=$g(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq))
				Set UOMRowid=$p(eqrec,"^",1)
				If UserLanguage="EN" {
					Set UOMDesc=$p($g(^CT("UOM",UOMRowid)),"^",3)
				}Else{
					Set UOMDesc=$p($g(^CT("UOM",UOMRowid)),"^",2)
				}
				Continue:UOMRowid1=UOMRowid   //dsp 过滤显示重复剂量单位 2020-01-15
				
				Set Data=$lb(UOMRowid,UOMDesc)
			 	Set ^CacheTemp(repid,ind)=Data
			 	Set ind=ind+1
			}
		}Else{
			Set Data=$lb(UOMRowid,UOMDesc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}	
	}Else{
		Set UOMRowid1=$p($g(^ARCIM(+aArcimID,$p(aArcimID,"||",2),8)),"^",14)		//剂量单位
		Set:UOMRowid1'="" UOMDesc=$p($g(^CT("UOM",UOMRowid1)),"^",2)
		
		Set Data=$lb(UOMRowid1,UOMDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1	
	}
	
	
	Quit $$$OK
}

ClassMethod QryDoseUomByArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDoseUomByArcimExecute ]
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
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryDoseUomByArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDoseUomByArcimExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:     chenjb
/// CreatDate:   2018-06-11
/// Description: 查询疗程
/// Table:       SQLUSER.PHC_Duration
/// d ##Class(%ResultSet).RunQuery("DHCCPW.MRC.FORM.LnkArcimSrv","QryPHCDuration","1")
Query QryPHCDuration(q As %String) As %Query(ROWSPEC = "DuratID:%String,DuratDesc:%String")
{
}

ClassMethod QryPHCDurationExecute(ByRef qHandle As %Binary, q As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:q="" $$$OK
	
	Set PHCDuratList=..GetPHCDurat(q)
	Quit:PHCDuratList="" $$$OK
	For indDurat=1:1:$listlength(PHCDuratList) {
		Set tmpDuratInfo=$list(PHCDuratList,indDurat)
		Continue:tmpDuratInfo=""
		Set DuratID=$p(tmpDuratInfo,"^",1)
		Set DuratDesc=$p(tmpDuratInfo,"^",2)
		Set Data=$lb(DuratID,DuratDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryPHCDurationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPHCDurationExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryPHCDurationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPHCDurationExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetPHCDurat(aDesc As %String) As %List
{
	New (aDesc)
	Set return=""
	Quit:aDesc="" return
	
	Set rs=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpDuration")
	Do rs.Execute(aDesc)
	While (rs.Next()) {
		Set DuratID=rs.GetData(1)	// RowId
		Set DuratDesc=rs.GetDataByName("CTPCPDesc")	// Desc
		Set return=return_$lb(DuratID_"^"_DuratDesc)
	}
	Do rs.Close()
	
	Quit return
}

/// Creator:     chenjb
/// CreatDate:   2018-06-11
/// Description: 查询频次
/// Table:       SQLUSER.PHC_Freq
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.LinkArcimSrv","QryPHCFreq","q")
Query QryPHCFreq(q As %String) As %Query(ROWSPEC = "FreqID:%String,FreqDesc:%String")
{
}

ClassMethod QryPHCFreqExecute(ByRef qHandle As %Binary, q As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:q="" $$$OK
	
	Set PHCFreqList=..GetPHCFreq(q)
	Quit:PHCFreqList="" $$$OK
	For indFreq=1:1:$listlength(PHCFreqList) {
		Set tmpFreqInfo=$list(PHCFreqList,indFreq)
		Continue:tmpFreqInfo=""
		Set FreqID=$p(tmpFreqInfo,"^",1)
		Set FreqDesc=$p(tmpFreqInfo,"^",2)
		Set Data=$lb(FreqID,FreqDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryPHCFreqFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPHCFreqExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryPHCFreqClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPHCFreqExecute ]
{
	Set repid=$LIST($g(qHandle),2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetPHCFreq(aDesc As %String) As %List
{
	New (aDesc)
	Set return=""
	Quit:aDesc="" return
	
	Set rs=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpFrequency")
	Do rs.Execute(aDesc)
	While (rs.Next()) {
		Set FreqID=rs.GetData(5)	// RowId
		//Set FreqDesc=rs.GetDataByName("CTPCPDesc")	// Desc  江苏省中医院查询返回结果为：CTPCPDesc



		Set FreqDesc=rs.GetDataByName("Desc")	// Desc
		Set return=return_$lb(FreqID_"^"_FreqDesc)
	}
	Do rs.Close()
	
	Quit return
}

/// Creator:     chenjb
/// CreatDate:   2018-06-11
/// Description: 查询用法。
/// Table:       SQLUSER.PHC_Instruc
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.LinkArcimSrv","QryPHCInstruc","", "1033||1")
Query QryPHCInstruc(Instruc As %String, OrdID As %String) As %Query(ROWSPEC = "InstrucID:%String,InstrucDesc:%String,InstrucAlias:%String")
{
}

ClassMethod QryPHCInstrucExecute(ByRef qHandle As %Binary, Instruc As %String, OrdID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set id = 0, data="", desc="", code="",Alias=""
	Set Instruc = $ZConvert(Instruc,"U")
	
	Set isCNMed = ##class(DHCMA.CPW.IO.FromDoc).IsCPWCNMedItem(OrdID)
	For {
		Set id = $Order(^PHCIN(id))
		Quit:id=""
	
		Set data = $Get(^PHCIN(id))
		Set desc = $Piece(data, "^", 2)
		Set desc2 = $Piece(data, "^", 3)
		Continue:(desc["停用")||(desc2="UNUSE")
		Continue:(isCNMed=1)&&(desc2'="饮片")
		Continue:(isCNMed'=1)&&(desc2="饮片")
		Set BDPAliasID = $o(^User.BDPAliasI("DataRef","PHC_Instruc",id,""),-1)
		Set:BDPAliasID'="" Alias = $li($g(^User.BDPAliasD(BDPAliasID)),2)	//平台组表结构获取别名	
		Continue:(Instruc'="")&&(desc'[Instruc)&&(Alias'[Instruc)
		Set Data = $lb(id,desc,Alias)
		Set ^CacheTemp(repid,ind) = Data
		Set ind = ind+1
	}
	
	Quit $$$OK
}

ClassMethod QryPHCInstrucFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPHCInstrucExecute ]
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
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QryPHCInstrucClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPHCInstrucExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPHCInstruc(aDesc As %String) As %List
{
	New (aDesc)
	Set return=""
	Quit:aDesc="" return
	
	Set rs=##class(%ResultSet).%New("web.DHCDocOrderCommon:LookUpInstr")
	Do rs.Execute(aDesc)
	While (rs.Next()) {
		Set InstrucID=rs.GetData(1)	// RowId
		Set InstrucDesc=rs.GetDataByName("Desc")	// Desc
		Set return=return_$lb(InstrucID_"^"_InstrucDesc)
	}
	Do rs.Close()
	
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2019-07-16
/// Description:  别名检索协定方
/// Table:        SQLUSER.ARC_OrdSets
/// Input：       aPathTCMDr ：中药方剂ID
///               aAlias ：别名
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.LinkArcimSrv","QryTCMOSByAlias",2,"")
Query QryTCMOSByAlias(aPathTCMDr As %String, aAlias As %String) As %Query(ROWSPEC = "ARCOSID:%String,ARCOSCode:%String,ARCOSDesc:%String,IsPathTCMOS:%String")
{
}

ClassMethod QryTCMOSByAliasExecute(ByRef qHandle As %Binary, aPathTCMDr As %String, aAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Quit:aPathTCMDr="" $$$OK
	
	Set aAlias=$tr(aAlias," ","")
	Set PathARCOSList=""
	Set xARCOSID=""
	For {
		Set xARCOSID=$o(^DHCMA.CPW.BT.PathTCMOSI("IdxPathTCMOS",aPathTCMDr,xARCOSID))
		Quit:xARCOSID=""
		
		Set xID=""
		For {
			Set xID=$o(^DHCMA.CPW.BT.PathTCMOSI("IdxPathTCMOS",aPathTCMDr,xARCOSID,xID))
			Quit:xID=""
			
			Set objTCMOS=##class(DHCMA.CPW.BT.PathTCMOS).GetObjById(xID)
			Continue:'$IsObject(objTCMOS)
			Continue:objTCMOS.TOIsActive'=1
			Set ARCOSID=objTCMOS.TOARCOSID
			Continue:ARCOSID=""
			Set PathARCOSList=PathARCOSList_$lb(ARCOSID)
		}
	}
	
	Set xID=0
	For {
		Set xID=$o(^ARCOS(xID))
		Quit:xID=""
		
		Set ARCOSTypeDr=$p($g(^ARCOS(xID)),"^",9)
		Continue:ARCOSTypeDr=""
		Set ARCOSTypeDesc=$p($g(^ARC("IC",ARCOSTypeDr)),"^",2)
		Continue:(ARCOSTypeDesc'["协定处方")&&(ARCOSTypeDesc'["协定方")
		Set ARCOSDesc=$p($g(^ARCOS(xID)),"^",2)
		Continue:(aAlias'="")&&(ARCOSDesc'[aAlias)
		
		Set IsPathTCMOS=0
		If $listfind(PathARCOSList,xID)>0 {
			Set IsPathTCMOS=1
		}
		Continue:IsPathTCMOS>0
		
		Set ARCOrdSetID=xID
		Do BuildDataToARCOS2
	}
	Quit $$$OK
	
BuildDataToARCOS2
	s ARCOrdSetCode=$p($g(^ARCOS(ARCOrdSetID)),"^",1)
	s ARCOrdSetDesc=$p($g(^ARCOS(ARCOrdSetID)),"^",2)
	s ARCOrdSetCode=$tr(ARCOrdSetCode,$c(13),"")
	s ARCOrdSetCode=$tr(ARCOrdSetCode,$c(13),"")
	s ARCOrdSetDesc=$tr(ARCOrdSetDesc,$c(13),"")
	s ARCOrdSetDesc=$tr(ARCOrdSetDesc,$c(10),"")
	q:ARCOrdSetDesc=""
	//**********************************************
	s effDateFrom=$p($g(^ARCOS(ARCOrdSetID)),"^",15)
	s effDateTo=$p($g(^ARCOS(ARCOrdSetID)),"^",16)
	s currDate=+$h
	q:((effDateFrom'="")&&(effDateFrom>currDate))
	q:((effDateTo'="")&&(effDateTo<currDate))
	//**********************************************
	Set:ARCOrdSetDesc'="" ARCOrdSetDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.pathtcmedit.csp",ARCOrdSetDesc,LangID)	
	s Data=$lb(ARCOrdSetID,ARCOrdSetCode,ARCOrdSetDesc,IsPathTCMOS)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod QryTCMOSByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryTCMOSByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryTCMOSByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryTCMOSByAliasExecute ]
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

/// Creator：     zhufei
/// CreatDate：   2019-07-16
/// Description:  获取中药方剂对应协定处方
/// Table:        SQLUSER.ARC_OrdSets
/// Input：       aPathTCMDr ：中药方剂ID
/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.LinkArcimSrv","QryPathTCMOS",2)
Query QryPathTCMOS(aPathTCMDr As %String) As %Query(ROWSPEC = "TCMOSDr:%Integer,ARCOSID:%String,ARCOSCode:%String,ARCOSDesc:%String")
{
}

ClassMethod QryPathTCMOSExecute(ByRef qHandle As %Binary, aPathTCMDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
	
	Quit:aPathTCMDr="" $$$OK
	
	Set xARCOSID=""
	For {
		Set xARCOSID=$o(^DHCMA.CPW.BT.PathTCMOSI("IdxPathTCMOS",aPathTCMDr,xARCOSID))
		Quit:xARCOSID=""
		
		Set xID=""
		For {
			Set xID=$o(^DHCMA.CPW.BT.PathTCMOSI("IdxPathTCMOS",aPathTCMDr,xARCOSID,xID))
			Quit:xID=""
			
			Set objTCMOS=##class(DHCMA.CPW.BT.PathTCMOS).GetObjById(xID)
			Continue:'$IsObject(objTCMOS)
			Continue:objTCMOS.TOIsActive'=1
			Set ARCOSID=objTCMOS.TOARCOSID
			Continue:ARCOSID=""
			
			Set ARCOSCode=$p($g(^ARCOS(ARCOSID)),"^",1)
			Set ARCOSDesc=$p($g(^ARCOS(ARCOSID)),"^",2)
			
			Set:ARCOSDesc'="" ARCOSDesc = ##class(DHCMA.CPW.IO.CommonRef).GetTranByCsp("dhcma.cpw.bt.pathtcmedit.csp",ARCOSDesc,LangID)	

			Set Data=$lb(xID,ARCOSID,ARCOSCode,ARCOSDesc)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit $$$OK
}

ClassMethod QryPathTCMOSClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryPathTCMOSExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryPathTCMOSFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryPathTCMOSExecute ]
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

/// d ##Class(%ResultSet).RunQuery("DHCMA.CPW.BTS.LinkArcimSrv","QryGetDiag","ngs","9","2")
Query QryGetDiag(aDesc As %String, aUser As %String, aHosp As %String) As %Query(ROWSPEC = "desc,code") [ SqlProc ]
{
}

ClassMethod QryGetDiagExecute(ByRef qHandle As %Binary, aDesc As %String, aUser As %String, aHosp As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set DiagArray=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("web.DHCDocDiagnosEntryV8","LookUpWithAlias",aDesc,"","","","0",aUser,"","","",aHosp)
	For DiagIndex=1:1:DiagArray.Count() {
		Set DiagInfo=DiagArray.GetAt(DiagIndex)
		Set code=DiagInfo.GetAt("code")
		Set desc=DiagInfo.GetAt("desc")
		Set Data=$lb(desc,code)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryGetDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetDiagExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：        zqy
/// CreatDate：      2022-3-8
/// Description：    查询手术字典 参考CIS.AN.BL.Admission FindMRCDiagnosis
/// Table：          MRC_ICDx
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.LinkArcimSrv","QryGetOper","治疗性超声",114)
Query QryGetOper(filterDesc As %String, aLoc As %String = "") As %Query(ROWSPEC = "code,desc") [ SqlProc ]
{
}

ClassMethod QryGetOperExecute(ByRef qHandle As %Binary, filterDesc As %String, aLoc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
	
	Set OperArray=##class(DHCMA.Util.IO.CommonSrv).GetArrayOfQueryData("CIS.AN.BL.Operation","FindOperation",filterDesc,"",aLoc,"")
	
	For OperIndex=1:1:OperArray.Count() {
		Set OperInfo=OperArray.GetAt(OperIndex)
		Set code=OperInfo.GetAt("ICDCode")
		Set desc=OperInfo.GetAt("Description")
		Set Data=$lb(code,desc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryGetOperFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryGetOperExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod QryGetOperClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryGetOperExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// Creator：        zqy
/// CreatDate：      2022-3-8
/// Description：    查询诊断
/// Table：          MRC_ICDx
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.LinkArcimSrv","QryMDiag",18,"ngs","")
Query QryMDiag(Parref As %String, argArea As %String, aType As %String) As %Query(ROWSPEC = "BTID:%String,ICD:%String,Desc:%String,checked:%String,AdmitID:%String") [ SqlProc ]
{
}

ClassMethod QryMDiagExecute(ByRef qHandle As %Binary, Parref As %String, argArea As %String, aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:Parref="" -1
 	
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Set argArea=$ZCONVERT(argArea,"U")
 	if ($d(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",Parref," M")))&&(aType="Y"){
	 	Set SubID=""
			For{
				Set SubID=$o(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",Parref," M",SubID))	
				Quit:SubID=""
				Set obj=##class(DHCMA.CPW.BT.PathAdmitOrds).GetObjById(Parref_"||"_SubID)
				Quit:'$IsObject(obj)
				Set Rowid=obj.OrdMORcID
				Set len=$l(Rowid,",")
				For index=1:1:len{
					Set MrcID=$p(Rowid,",",index)
					Continue:MrcID=""
					Set ICD=$p(^MRC("ID",MrcID),"^",4)		//ICD
					Set Desc=$p(^MRC("ID",MrcID),"^",2)		//描述
					Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.MRCICDDx","MRCIDDesc",Desc,Languages)
					Set Data=$lb(MrcID,ICD,Desc,1,Parref)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
				
			}
	}else{
		Set xID="0"
		For{
			Set xID=$o(^MRC("ID",xID))
			Quit:xID=""
			Continue:$p(^MRC("ID",xID),"^",27)="N"
			Set DateFrom=$p(^MRC("ID",xID),"^",6)
			Continue:(DateFrom'="")&&(DateFrom>+$h)
			Set DateTo=$p(^MRC("ID",xID),"^",7)
			Continue:(DateTo'="")&&(DateTo<+$h)
			Set ICD=$p(^MRC("ID",xID),"^",4)		//ICD
			Set Type=##class(DHCMA.CPW.IO.FromDoc).GetDiagnosCat(ICD,"")
			Continue:Type="证候"
			Set Desc=$p(^MRC("ID",xID),"^",2)		//描述
			Set flag=..ArcFlag(argArea,xID) 		//别名
			Continue:(Desc'[argArea)&&(ICD'[argArea)&&(flag=0)
			if ($d(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",Parref," M"))){
				Set SubID=""
				For{
					Set SubID=$o(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",Parref," M",SubID))	
					Quit:SubID=""
					Set obj=##class(DHCMA.CPW.BT.PathAdmitOrds).GetObjById(Parref_"||"_SubID)
					Quit:'$IsObject(obj)
					Set Rowid=obj.OrdMORcID
			 		Set checked=""
			 		Set:(","_Rowid_",")[(","_xID_",") checked=1
			 		Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.MRCICDDx","MRCIDDesc",Desc,Languages)
			 		Set Data=$lb(xID,ICD,Desc,checked,Parref)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}elseIf(argArea'=""){
				Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.MRCICDDx","MRCIDDesc",Desc,Languages)
				Set Data=$lb(xID,ICD,Desc,checked,Parref)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryMDiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryMDiagExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod QryMDiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryMDiagExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// 判断别名是否符合
/// w ##class(DHCMA.CPW.BTS.LinkArcimSrv).ArcFlag()
ClassMethod ArcFlag(txt As %String, aID As %String = "") As %String
{
	Set Itm="0",ret=0
	For{
		Set Itm=$o(^MRC("ID",xID,"ALIAS",Itm))
		Quit:Itm=""
		Set arg=$g(^MRC("ID",xID,"ALIAS",Itm))
		Continue:arg'[txt
		Set ret=1
	}
	quit ret
}

/// Creator：        zqy
/// CreatDate：      2022-3-8
/// Description：    查询手术诊断
/// Table：          
/// Return：         ResultSet
/// d ##class(%ResultSet).RunQuery("DHCMA.CPW.BTS.LinkArcimSrv","QryODiag","18","","")
Query QryODiag(Parref As %String, argArea As %String, aType As %String) As %Query(ROWSPEC = "BTID:%String,ICD:%String,Desc:%String,checked:%String,AdmitID:%String") [ SqlProc ]
{
}

ClassMethod QryODiagExecute(ByRef qHandle As %Binary, Parref As %String, argArea As %String, aType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:Parref="" -1
 	
 	Set LangID= 20,Languages= "CH"
	If ($d(%session)){
		Set LangID=+$g(%session.Data("LOGON.LANGID"))
		Set:LangID'="" Languages=$p($g(^SS("LAN",LangID)),"^",1)
	}
 	
 	Set argArea=$ZCONVERT(argArea,"U")
 	if ($d(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",Parref," O")))&&(aType="Y"){
	 	Set SubID=""
			For{
				Set SubID=$o(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",Parref," O",SubID))	
				Quit:SubID=""
				Set obj=##class(DHCMA.CPW.BT.PathAdmitOrds).GetObjById(Parref_"||"_SubID)
				Quit:'$IsObject(obj)
				Set Rowid=obj.OrdMORcID
				Set len=$l(Rowid,",")
				For index=1:1:len{
					Set OrcID=$p(Rowid,",",index)
					Continue:OrcID=""
					Set ICD=$p(^ORC("OPER",OrcID),"^",1)		//ICD
					Set Desc=$p(^ORC("OPER",OrcID),"^",2)		//描述
					Set Data=$lb(OrcID,ICD,Desc,1,Parref)
					Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ORCOperation","OPERDesc",Desc,Languages)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
				
			}
	}else{
	 	Set xID="0"
		For{
			Set xID=$o(^ORC("OPER",xID))
			Quit:xID=""
			Continue:$p(^ORC("OPER",xID),"^",22)="N"
			Set DateFrom=$p(^ORC("OPER",xID),"^",5)
			Continue:(DateFrom'="")&&(DateFrom>+$h)
			Set DateTo=$p(^ORC("OPER",xID),"^",6)
			Continue:(DateTo'="")&&(DateTo<+$h)
			Set Desc=$p(^ORC("OPER",xID),"^",2)		//描述 
			Set ICD=$p(^ORC("OPER",xID),"^",1)		//ICD
			Set flag=..OArcFlag(argArea,xID) 		//别名
			Continue:(Desc'[argArea)&&(ICD'[argArea)&&(flag=0)
			if ($d(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",Parref," O"))){
				Set SubID=""
				For{
					Set SubID=$o(^DHCMA.CPW.BT.PathAdmit("ORD","IdxofParrType",Parref," O",SubID))	
					Quit:SubID=""
					Set obj=##class(DHCMA.CPW.BT.PathAdmitOrds).GetObjById(Parref_"||"_SubID)
					Quit:'$IsObject(obj)
					Set Rowid=obj.OrdMORcID
			 		Set checked=""
			 		Set:(","_Rowid_",")[(","_xID_",") checked=1
			 		Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ORCOperation","OPERDesc",Desc,Languages)
			 		Set Data=$lb(xID,ICD,Desc,checked,Parref)
					Set ^CacheTemp(repid,ind)=Data
					Set ind=ind+1
				}
			}elseIf(argArea'=""){
				Set:Desc'="" Desc=##class(DHCMA.CPW.IO.CommonRef).GetTranByUserClass("User.ORCOperation","OPERDesc",Desc,Languages)
				Set Data=$lb(xID,ICD,Desc,checked,Parref)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryODiagFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryODiagExecute ]
{
    s AtEnd=$li(qHandle,1)
    s repid=$li(qHandle,2)
    s ind=$li(qHandle,3)
    //
    s ind=$o(^CacheTemp(repid,ind))
    i ind="" {              // if there are no more rows, finish fetching
    s AtEnd=1
    s Row=""
    }
    else      {             // fetch row
    s Row=^CacheTemp(repid,ind)
    }
    // Save QHandle
    s qHandle=$lb(AtEnd,repid,ind)
    q $$$OK
}

ClassMethod QryODiagClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryODiagExecute ]
{
    s repid=$li(qHandle,2)
    k ^CacheTemp(repid)
    q $$$OK
}

/// 判断别名是否符合
/// w ##class(DHCMA.CPW.BTS.LinkArcimSrv).OArcFlag()
ClassMethod OArcFlag(txt As %String, aID As %String = "") As %String
{
	Set Itm="0",ret=0
	For{
		Set Itm=$o(^ORC("OPER",xID,"ALIAS",Itm))
		Quit:Itm=""
		Set arg=$g(^ORC("OPER",xID,"ALIAS",Itm))
		Continue:arg'[txt
		Set ret=1
	}
	quit ret
}

}
