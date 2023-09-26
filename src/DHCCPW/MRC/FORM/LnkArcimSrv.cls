/// 名称: DHCCPW.MRC.FORM.LnkArcimSrv
/// 描述: 关联医嘱处理相关服务
/// 编写者：zhufei
/// 编写日期: 2015-05-27
Class DHCCPW.MRC.FORM.LnkArcimSrv Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod UpdateIsMain(aGeneID As %String, aValue As %String) As %String
{
	New (aGeneID, aValue)
	Set return=##class(User.DHCMRCClinPathWaysItmGene).UpdateIsMain(aGeneID,aValue)
	Quit return
}

ClassMethod UpdateIsDefault(aGeneID As %String, aIGASub As %String, aValue As %String) As %String
{
	New (aGeneID, aIGASub, aValue)
	Set return=##class(User.DHCMRCClinPathWaysItmGene).UpdateIsDefault(aGeneID,aIGASub,aValue)
	Quit return
}

ClassMethod UpdateIsActive(aGeneID As %String, aIGASub As %String, aValue As %String) As %String
{
	New (aGeneID, aIGASub, aValue)
	Set return=##class(User.DHCMRCClinPathWaysItmGene).UpdateIsActive(aGeneID,aIGASub,aValue)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-06-13
/// Description:  检查合并关联医嘱（一个通用名下，不允许有相同医嘱项）
/// Table：       User.DHCMRCClinPathWaysItmGene
/// Input：       FromGeneID : User.DHCMRCClinPathWaysItmGene.ID
///               ToGeneID : User.DHCMRCClinPathWaysItmGene.ID
/// Return：      return>0:成功  return<=0:失败
/// w ##Class(DHCCPW.MRC.FORM.LnkArcimSrv).CheckMergeArcim("79||1||1||11||46","79||1||1||11||35")
ClassMethod CheckMergeArcim(aFromGeneID As %String, aToGeneID As %String) As %String
{
	New (aFromGeneID,aToGeneID)
	Set return=0
	Quit:(aFromGeneID="")||(aToGeneID="") return
	
	Set objFromGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(aFromGeneID)
	Quit:'$IsObject(objFromGene) return
	Set objToGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(aToGeneID)
	Quit:'$IsObject(objToGene) return
	
	Set return=-1
	Set CountX=objFromGene.IGArcimList.Count()
	For indArcX=1:1:CountX {
		Set objArcimX=objFromGene.IGArcimList.GetAt(indArcX)
		Continue:'$IsObject(objArcimX)
		Set ArcimIDX=objArcimX.ITMARCIMDR
		Continue:ArcimIDX=""
		
		Set CountY=objToGene.IGArcimList.Count()
		For indArcY=1:1:CountY {
			Set objArcimY=objToGene.IGArcimList.GetAt(indArcY)
			Continue:'$IsObject(objArcimY)
			Set ArcimIDY=objArcimY.ITMARCIMDR
			Continue:ArcimIDY=""
			Set:ArcimIDX=ArcimIDY return=1
		}
	}
	Quit return
}

ClassMethod MergeArcim(aFromGeneID As %String, aToGeneID As %String) As %String
{
	New (aFromGeneID, aToGeneID)
	Set return=0
	Quit:(aFromGeneID="")||(aToGeneID="") return
	
	Set IsError=0
	Set objFromGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(aFromGeneID)
	If $IsObject(objFromGene){
		For indArc=1:1:objFromGene.IGArcimList.Count() {
			Quit:IsError=1
			Set objTmpArcim=objFromGene.IGArcimList.GetAt(indArc)
			Continue:'$IsObject(objTmpArcim)
			Set tmpArcimID=objTmpArcim.ITMARCIMDR
			Continue:tmpArcimID=""
			Set:$l(tmpArcimID,"||")=1 IsError=1
		}
	}
	Set objToGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(aToGeneID)
	If $IsObject(objToGene){
		For indArc=1:1:objToGene.IGArcimList.Count() {
			Quit:IsError=1
			Set objTmpArcim=objToGene.IGArcimList.GetAt(indArc)
			Continue:'$IsObject(objTmpArcim)
			Set tmpArcimID=objTmpArcim.ITMARCIMDR
			Continue:tmpArcimID=""
			Set:$l(tmpArcimID,"||")=1 IsError=1
		}
	}
	Quit:IsError>0 return  //关联医嘱套不允许按通用名合并
	
	Set return=##class(User.DHCMRCClinPathWaysItmGene).MergeArcim(aFromGeneID,aToGeneID)
	Quit return
}

ClassMethod ChangeIGNo(aFromGeneID As %String, aToGeneID As %String) As %String
{
	New (aFromGeneID, aToGeneID)
	Set return=0
	Quit:(aFromGeneID="")||(aToGeneID="") return
	Set return=##class(User.DHCMRCClinPathWaysItmGene).ChangeIGNo(aFromGeneID,aToGeneID)
	Quit return
}

/// Creator:     zhufei
/// CreatDate:   2015-06-12
/// Description: 查询医嘱项默认 单次剂量,剂量单位,频次,用法,疗程
/// w ##class(DHCCPW.MRC.FORM.LnkArcimSrv).GetArcimInfoById("4")
ClassMethod GetArcimInfoById(aArcimID As %String) As %String
{
	New (aArcimID)
	Set return=""
	Quit:aArcimID="" return
	
	If $l(aArcimID,"||")=2 {
		Set (FormDoseUOMID,FormDoseUOMDesc,FormFreqID,FormFreqDesc,FormInstrID,FormInstrDesc,FormDurID,FormDurDesc,FormDoseQty)=""
		Set (PHCGeneID,PHCGeneDesc,PHCSpecDesc,PHCFormID,PHCFormDesc)=""
		Set (OrderPackUOMID,OrderPackUOM)=""
		
		Set ItemCatRowid=$p($g(^ARCIM(+aArcimID,+$p(aArcimID,"||",2),1)),"^",10)
		Set OrderType=$p($g(^ARC("IC",+ItemCatRowid)),"^",7)
		If OrderType="R"{
			Set PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(+ItemCatRowid)
			If PHPrescType="" Set PHPrescType="1"
		}Else{
			Set PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(+ItemCatRowid)
		}
		
		Set ArcimDesc=$p($g(^ARCIM(+aArcimID,+$p(aArcimID,"||",2),1)),"^",2)    //医嘱名称
		Set PHCGeneID=$p($g(^ARCIM(+aArcimID,+$p(aArcimID,"||",2),8)),"^",20)   //通用名
		Set:PHCGeneID'="" PHCGeneDesc=$p($g(^PHCGE("GE",PHCGeneID)),"^",2)
		Set:PHCGeneDesc="" PHCGeneDesc=ArcimDesc   //医嘱名称
		Set DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(aArcimID)     //药学项
		If DrgformRowid'="" {
			Set PHCDRowid=$p(DrgformRowid,"||",1)
		  	Set ChildSub=$p(DrgformRowid,"||",2)
			Set FormDoseUOMID=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4) //剂量单位
			Set FormFreqID=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",4)    //频次
			Set FormInstrID=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",5)   //用法
			Set FormDurID=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)     //疗程
			Set FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5)   //剂量
			Set PHCFormID=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",1)     //剂型
		}
		Set Inci=$o(^INCI(0,"ARCIM_DR",+aArcimID,""))  //库存项
		If Inci'="" {
			Set InciInfo=$o(^DHCITMINFO(0,"INCI",Inci,""))
			Set PHCSpecDesc=$p($g(^DHCITMINFO(+InciInfo)),"^",27)
			If PHCSpecDesc="" {
				Set PHCSpecDesc=$p($g(^INCI(Inci,3)),"^",9)                  //规格
			}
		}
		
		If PHPrescType="4" {
			Set FormFreqID=##class(web.DHCDocConfig).GetConfigNode("FrequencedItemFreq")
			Set FormDurID=##class(web.DHCDocConfig).GetConfigNode("FrequencedItemDur")
		}
		Set CPWHospitalCode=##class(User.DHCMRCBaseConfig).GetValueByCode("CPWHospitalCode")
		Set:CPWHospitalCode="BJ_FXYY" FormDurID=""
		
		Set:FormDoseUOMID'="" FormDoseUOMDesc=$p($g(^CT("UOM",FormDoseUOMID)),"^",3)
		Set:FormFreqID'="" FormFreqDesc=$p($g(^PHCFR(FormFreqID)),"^",3)
		Set:FormInstrID'="" FormInstrDesc=$p($g(^PHCIN(FormInstrID)),"^",2)
		Set:FormDurID'="" FormDurDesc=$p($g(^PHCDU(FormDurID)),"^",3)
		Set:PHCFormID'="" PHCFormDesc=$p($g(^PHCF(PHCFormID)),"^",2)
		
		//整包装单位
		Set OrderPackUOMID=$p($g(^ARCIM(+aArcimID,$p(aArcimID,"||",2),8)),"^",14)
		Set:OrderPackUOMID'="" OrderPackUOM=$p($g(^CT("UOM",OrderPackUOMID)),"^",2)
		
		Set return=aArcimID_"^"_OrderType_"^"_PHPrescType
		Set return=return_"^"_FormDoseQty_"^"_FormDoseUOMID_"^"_FormDoseUOMDesc   //单次剂量、单位
		Set return=return_"^"_FormDurID_"^"_FormDurDesc      //疗程
		Set return=return_"^"_FormFreqID_"^"_FormFreqDesc    //频次
		Set return=return_"^"_FormInstrID_"^"_FormInstrDesc  //用法
		Set return=return_"^"_PHCFormID_"^"_PHCFormDesc      //规格
		Set return=return_"^"_PHCGeneID_"^"_PHCGeneDesc_"^"_PHCSpecDesc  //通用名、剂型
		Set return=return_"^"_OrderPackUOMID_"^"_OrderPackUOM    //整包装单位
		Set return=return_"^"_ArcimDesc          //20医嘱名称
	} Else {
		Set ARCOSDesc=$p($g(^ARCOS(+aArcimID)),"^",2)
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
	}
	
	Quit return
}

/// w ##Class(DHCCPW.MRC.FORM.LnkArcimSrv).DeleteLnkArcim("79||1||1||11||1",3)
ClassMethod DeleteLnkArcim(aGeneID As %String, aIGASub As %String) As %String
{
	New (aGeneID,aIGASub)
	Set return=##class(User.DHCMRCClinPathWaysItmGene).DeleteById(aGeneID,aIGASub)
	Quit return
}

/// 保存关联医嘱
/// w ##Class(DHCCPW.MRC.FORM.LnkArcimSrv).SaveLnkArcim("79||1||1||11^53^1^3^79||1||1||11||50^864||1^1^17^4^4^63^^0^1^^9")
ClassMethod SaveLnkArcim(aInputStr As %String) As %String
{
	New (aInputStr)
	Set return=0
	Quit:aInputStr="" return
	
	//Set ^ZF=aInputStr
	
	Set ItemID = $p(aInputStr,"^",1)
	Set IGSub = $p(aInputStr,"^",2)
	Set IGASub = $p(aInputStr,"^",3)
	Set IGNo = $p(aInputStr,"^",4)          // 序号
	Set PriorityID = $p(aInputStr,"^",5)
	Set LinkNo = $p(aInputStr,"^",6)
	Set IsMain = +$p(aInputStr,"^",7)
	Set IsMain=$s(IsMain=1:"Y",1:"N")       //主医嘱
	Set ArcimID = $p(aInputStr,"^",8)
	Set DoseQty = $p(aInputStr,"^",9)
	Set DoseUomID = $p(aInputStr,"^",10)
	Set FreqID = $p(aInputStr,"^",11)
	Set InstrucID = $p(aInputStr,"^",12)
	Set DurationID = $p(aInputStr,"^",13)
	Set PackQty = $p(aInputStr,"^",14)
	Set IsDefault = +$p(aInputStr,"^",15)   //首选医嘱
	Set IsDefault=$s(IsDefault=1:"Y",1:"N")
	Set IsActive = +$p(aInputStr,"^",16)    //是否有效
	Set IsActive=$s(IsActive=1:"Y",1:"N")
	Set ItmResume = $p(aInputStr,"^",17)
	Set UpdateUser = $p(aInputStr,"^",18)
	
	Set InputStr=ItemID
	Set InputStr=InputStr_"^"_IGSub
	Set InputStr=InputStr_"^"_IGASub
	Set InputStr=InputStr_"^"_IGNo
	Set InputStr=InputStr_"^"_LinkNo
	Set InputStr=InputStr_"^"_PriorityID
	Set InputStr=InputStr_"^"_IsMain
	Set InputStr=InputStr_"^"_ArcimID
	Set InputStr=InputStr_"^"_DoseQty
	Set InputStr=InputStr_"^"_DoseUomID
	Set InputStr=InputStr_"^"_DurationID
	Set InputStr=InputStr_"^"_FreqID
	Set InputStr=InputStr_"^"_InstrucID
	Set InputStr=InputStr_"^"_PackQty
	Set InputStr=InputStr_"^"_ItmResume
	Set InputStr=InputStr_"^"_IsDefault
	Set InputStr=InputStr_"^"_IsActive
	Set InputStr=InputStr_"^"_UpdateUser
	Set InputStr=InputStr_"^"_+$h
	Set InputStr=InputStr_"^"_$p($h,",",2)
	Set return=##class(User.DHCMRCClinPathWaysItmGene).Update(InputStr)
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2015-06-11
/// Description:  查询表单项目关联医嘱
/// Table：       User.DHCMRCClinPathWaysItmGene
/// Input：       ItemID : 表单项目
/// Return：      返回Query
/// do ##class(%Library.ResultSet).RunQuery("DHCCPW.MRC.FORM.LnkArcimSrv","QryLnkArcimByItm","79||1||1||11")
Query QryLnkArcimByItm(aItemID As %String) As %Query(ROWSPEC = "IGNo:%String,IGLinkNo:%String,IGPriority:%String,IGPriorityDesc:%String,IGIsMain:%String,IGAIndex:%String,IGAArcimDR:%String,IGAArcimDesc:%String,PHCGeneDesc:%String,PHCSpecDesc:%String,PHCFormDesc:%String,IGAPackQty:%String,IGAFreqDR:%String,IGAFreqDesc:%String,IGADuratDR:%String,IGADuratDesc:%String,IGAInstrucDR:%String,IGAInstrucDesc:%String,IGADoseQty:%String,IGADoseUomDR:%String,IGADoseUomDesc:%String,IGADefault:%String,IGAIsActive:%String,IGAResume:%String,IGASign:%String")
{
}

ClassMethod QryLnkArcimByItmExecute(ByRef qHandle As %Binary, aItemID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aItemID="" $$$OK
	Set FormID=$p(aItemID,"||",1)
	Set EpSub=$p(aItemID,"||",2)
	Set StepSub=$p(aItemID,"||",3)
	Set ItemSub=$p(aItemID,"||",4)
	Quit:(FormID="")||(EpSub="")||(StepSub="")||(ItemSub="") $$$OK
	
	Kill arrArcimList
	
	Set xIGNo=0
	For {
		Set xIGNo=$o(^DHCMRCi("CPW",0,"GENE","IndexGeneNo",FormID,EpSub,StepSub,ItemSub,xIGNo))
		Quit:xIGNo=""
		
		Set xGeneSub=0
		For {
			Set xGeneSub=$o(^DHCMRCi("CPW",0,"GENE","IndexGeneNo",FormID,EpSub,StepSub,ItemSub,xIGNo,xGeneSub))
			Quit:xGeneSub=""
			
			Set GeneID=FormID_"||"_EpSub_"||"_StepSub_"||"_ItemSub_"||"_xGeneSub
			Set objGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(GeneID)
			Continue:'$IsObject(objGene)
			
			Set IGNo=objGene.IGNo              //序号
			Set IGPriority=objGene.IGPriority  //医嘱类型
			Set IGPriorityDesc=$p($g(^OECPR(IGPriority)),"^",2)
			Set IGIsMain=objGene.IGIsMain      //主医嘱
			Set IGIsMain=$s(IGIsMain["Y":1,1:0)
			Set IGLinkNo=objGene.IGLinkNo      //关联号
			If IGLinkNo'="" {
				Set objLnkGene=##class(User.DHCMRCClinPathWaysItmGene).GetObjById(IGLinkNo)
				If $IsObject(objLnkGene) {
					Set IGLinkNo=objLnkGene.IGNo
				} Else {
					Set IGLinkNo=""
				}
			}
			
			//关联通用名
			Set GeneData=$lb(IGNo,IGLinkNo,IGPriority,IGPriorityDesc,IGIsMain)
			If IGLinkNo'="" {
				Set OrderSeqNo=+IGLinkNo
				Set OrderSeqSub=+IGNo
			} Else {
				Set OrderSeqNo=+IGNo
				Set OrderSeqSub=0
			}
			Set arrArcimList(OrderSeqNo,OrderSeqSub)=GeneData
			
			For indArc=1:1:objGene.IGArcimList.Count() {
				Set objArcim=objGene.IGArcimList.GetAt(indArc)
				Continue:'$IsObject(objArcim)
				Set ArcimDR = objArcim.ITMARCIMDR
				Continue:ArcimDR=""
				
				Set ArcimInfo=##class(DHCCPW.MRC.FORM.LnkArcimSrv).GetArcimInfoById(ArcimDR)
				Continue:ArcimInfo=""
				Set OrderType=$p(ArcimInfo,"^",2)
				Set PrescType=$p(ArcimInfo,"^",3)
				Set PHCFormDR=$p(ArcimInfo,"^",13)
				Set PHCFormDesc=$p(ArcimInfo,"^",14)
				Set PHCGeneDR=$p(ArcimInfo,"^",15)
				Set PHCGeneDesc=$p(ArcimInfo,"^",16)
				Set PHCSpecDesc=$p(ArcimInfo,"^",17)
				Set ArcimDesc=$p(ArcimInfo,"^",20)
				If $l(ArcimDR,"||")=1 {
					Set ArcimDesc="[医嘱套]"_ArcimDesc
				}
				
				Set IGAPackQty = objArcim.ITMQty
				Set IGAFreqDR = objArcim.ITMFreqDR
				Set IGAFreqDesc=""
				Set:IGAFreqDR'="" IGAFreqDesc=$p($g(^PHCFR(IGAFreqDR)),"^",3)
				Set IGADuratDR = objArcim.ITMDuratDR
				Set IGADuratDesc=""
				Set:IGADuratDR'="" IGADuratDesc=$p($g(^PHCDU(IGADuratDR)),"^",3)
				Set IGAInstrucDR = objArcim.ITMInstrucDR
				Set IGAInstrucDesc=""
				Set:IGAInstrucDR'="" IGAInstrucDesc=$p($g(^PHCIN(IGAInstrucDR)),"^",2)
				Set IGADoseQty = objArcim.ITMDoseQty
				Set IGADoseUomDR = objArcim.ITMUOMDR
				Set IGADoseUomDesc=""
				Set:IGADoseUomDR'="" IGADoseUomDesc=$p($g(^CT("UOM",IGADoseUomDR)),"^",2)
				Set IGADefault=objArcim.ITMDefault    //首选医嘱
				Set IGADefault=$s(IGADefault["Y":1,1:0)
				Set IGAIsActive = objArcim.ITMIsActive
				Set IGAIsActive=$s(IGAIsActive["Y":1,1:0)
				Set IGAResume = objArcim.ITMResume
				
				Set IGAIndex=GeneID_"-"_indArc
				Set ArcData=$lb(IGAIndex,ArcimDR,ArcimDesc,PHCGeneDesc,PHCSpecDesc,PHCFormDesc,IGAPackQty,IGAFreqDR,IGAFreqDesc,IGADuratDR,IGADuratDesc,IGAInstrucDR,IGAInstrucDesc,IGADoseQty,IGADoseUomDR,IGADoseUomDesc,IGADefault,IGAIsActive,IGAResume)
				Set arrArcimList(OrderSeqNo,OrderSeqSub,indArc)=ArcData
			}
		}
	}
	
	Set xSeqNo=""
	For {
		Set xSeqNo=$o(arrArcimList(xSeqNo))
		Quit:xSeqNo=""
		
		Set xSubNo=""
		For {
			Set xSubNo=$o(arrArcimList(xSeqNo,xSubNo))
			Quit:xSubNo=""
			
			//通用名信息
			Set GeneData=$g(arrArcimList(xSeqNo,xSubNo))
			
			Set xArcNo="",ArcCount=0
			For {
				Set xArcNo=$o(arrArcimList(xSeqNo,xSubNo,xArcNo))
				Quit:xArcNo=""
				
				Set ArcCount=ArcCount+1
				If ArcCount>1 {
					If $o(arrArcimList(xSeqNo,xSubNo,xArcNo))="" {
						Set IGASign=2
					} Else {
						Set IGASign=0
					}
				} Else {
					If $o(arrArcimList(xSeqNo,xSubNo,xArcNo))="" {
						Set IGASign=3
					} Else {
						Set IGASign=1
					}
				}
				
				//医嘱信息
				Set ArcimData=$g(arrArcimList(xSeqNo,xSubNo,xArcNo))
				Set ArcimData=ArcimData_$lb(IGASign) //增加启止符号
				
				Set ^CacheTemp(repid,ind)=GeneData_ArcimData
				Set ind=ind+1
			}
		}
	}
	Kill arrArcimList
	
	Quit $$$OK
}

ClassMethod QryLnkArcimByItmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryLnkArcimByItmExecute ]
{
	set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryLnkArcimByItmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryLnkArcimByItmExecute ]
{
	set AtEnd=$LIST(qHandle,1)
 	set repid=$LIST(qHandle,2)
 	set ind=$LIST(qHandle,3)
 	set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		set AtEnd=1
 		set Row=""
 	}
 	Else      {				// fetch row
 		set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     zhufei
/// CreatDate：   2015-06-11
/// Description:  取医嘱类型（长期医嘱、临时医嘱、自备要医嘱等）
/// Input：       无
/// d ##Class(%ResultSet).RunQuery("DHCCPW.MRC.FORM.LnkArcimSrv","QryOECPriority")
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

/// Creator：     zhufei
/// CreatDate：   2015-06-11
/// Description:  别名检索医嘱项
/// Table:        SQLUSER.ARC_ItmMast
/// Input：       aAlias ：别名
/// d ##Class(%ResultSet).RunQuery("DHCCPW.MRC.FORM.LnkArcimSrv","QryArcimByAlias","丙型肝炎")
Query QryArcimByAlias(aAlias As %String) As %Query(ROWSPEC = "ArcimID:%String,ArcimCode:%String,ArcimDesc:%String")
{
}

ClassMethod QryArcimByAliasExecute(ByRef qHandle As %Binary, aAlias As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Set IsLinkLabARCOS=##class(User.DHCMRCBaseConfig).GetValueByCode("IsLinkLabARCOS")
	
	s JIndex=$j,ZIndex=$zn
	
	//关联医嘱项
	k ^TMP(ZIndex,JIndex,"ARCItemMast")
	
	//医嘱别名查询医嘱项
	//^ARC("ALIAS",0,"Desc",$$ALPHAUP({ALIAS_Text})_" ",$$ALPHAUP({ALIAS_Desc}),{ALIAS_RowId},1)
	s aAlias=$$ALPHAUP^SSUTIL4(aAlias)
	s Alias=$o(^ARC("ALIAS",0,"Desc",aAlias),-1)
	f  s Alias=$o(^ARC("ALIAS",0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(aAlias))'=aAlias)  d
	.s ARCDesc=""
	.f  s ARCDesc=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc)) q:ARCDesc=""  d
	..s ARCRowid=0
	..f  s ARCRowid=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc,ARCRowid)) q:ARCRowid=""  d
	...q:'$d(^ARC("ALIAS",ARCRowid))
	...s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
	...q:ARCType'="ARCIM"
	...s ARCAlias=$p(^ARC("ALIAS",ARCRowid),"^",6)
	...s ARCAlias=$$ALPHAUP^SSUTIL4(ARCAlias)
	...q:$e(ARCAlias,1,$l(aAlias))'=aAlias
	...s ARCItemID=$p(^ARC("ALIAS",ARCRowid),"^",1)
	...q:ARCItemID=""
	...q:$d(^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID))
	...d BuildDataToARCIM
	...s ^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID)=""
	
	//医嘱名称查询医嘱项
	//^ARCIM(0,"Desc",$$ALPHAUP({ARCIM_Desc}),{ARCIM_Subscript},{ARCIM_Version})
	s Alias=$o(^ARCIM(0,"Desc",aAlias),-1)
	f  s Alias=$o(^ARCIM(0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(aAlias))'=aAlias)  d
	.s ItemSub=0
	.f  s ItemSub=$o(^ARCIM(0,"Desc",Alias,ItemSub)) q:ItemSub=""  d
	..s ItemVer=0
	..f  s ItemVer=$o(^ARCIM(0,"Desc",Alias,ItemSub,ItemVer)) q:ItemVer=""  d
	...s ARCItemID=ItemSub_"||"_ItemVer
	...q:$d(^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID))
	...d BuildDataToARCIM
	...s ^TMP(ZIndex,JIndex,"ARCItemMast",ARCItemID)=""
	
	k ^TMP(ZIndex,JIndex,"ARCItemMast")
	
	//根据配置判断是否允许关联检验医嘱套
	//只有Medtrak程序才允许关联医嘱套(安贞、友谊、复兴等)
	If IsLinkLabARCOS="Y" {
		k ^TMP(ZIndex,JIndex,"ARCOrdSet")
		
		//医嘱套别名查询
		//^ARC("ALIAS",0,"Desc",$$ALPHAUP({ALIAS_Text})_" ",$$ALPHAUP({ALIAS_Desc}),{ALIAS_RowId},1)
		s aAlias=$$ALPHAUP^SSUTIL4(aAlias)
		s Alias=$o(^ARC("ALIAS",0,"Desc",aAlias),-1)
		f  s Alias=$o(^ARC("ALIAS",0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(aAlias))'=aAlias)  d
		.s ARCDesc=""
		.f  s ARCDesc=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc)) q:ARCDesc=""  d
		..s ARCRowid=0
		..f  s ARCRowid=$o(^ARC("ALIAS",0,"Desc",Alias,ARCDesc,ARCRowid)) q:ARCRowid=""  d
		...q:'$d(^ARC("ALIAS",ARCRowid))
		...//s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
		...//q:ARCType'="ARCIM"
		...s ARCAlias=$p(^ARC("ALIAS",ARCRowid),"^",6)
		...s ARCAlias=$$ALPHAUP^SSUTIL4(ARCAlias)
		...q:$e(ARCAlias,1,$l(aAlias))'=aAlias
		...s ARCType=$p(^ARC("ALIAS",ARCRowid),"^",5)
		...q:ARCType'="ARCOS"
		...s ARCOrdSetID=$p(^ARC("ALIAS",ARCRowid),"^",2)
		...q:ARCOrdSetID=""
		...q:$d(^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID))
		...d BuildDataToARCOS
		...s ^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID)=""
		
		//医嘱套名称查询
		//^ARCOS(0,"Desc",$$ALPHAUP({ARCOS_Desc}),{ARCOS_RowId})
		s Alias=$o(^ARCOS(0,"Desc",aAlias),-1)
		f  s Alias=$o(^ARCOS(0,"Desc",Alias)) q:(Alias="")||($e(Alias,1,$l(aAlias))'=aAlias)  d
		.s ARCOrdSetID=0
		.f  s ARCOrdSetID=$o(^ARCOS(0,"Desc",Alias,ARCOrdSetID)) q:ARCOrdSetID=""  d
		..q:$d(^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID))
		..d BuildDataToARCOS
		..s ^TMP(ZIndex,JIndex,"ARCOrdSet",ARCOrdSetID)=""
		
		k ^TMP(ZIndex,JIndex,"ARCOrdSet")
	}
	
	Quit $$$OK
	
BuildDataToARCIM
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
    //检查临床路径与航天HIS医嘱项数据一致性
	s flg=##Class(web.DHCCPW.MR.InterfaceToPrj).CheckArcimConsistency(ARCItemID)
	//s:flg'="" ARCItemDesc="(!)"_ARCItemDesc_","_flg
	q:flg'=""
	//**********************************************
	s Data=$lb(ARCItemID,ARCItemCode,ARCItemDesc)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
	
BuildDataToARCOS
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
	//update by zf 20110902
	//判断医嘱套是否有效(有效日期,截止日期)
	s effDateFrom=$p($g(^ARCOS(ARCOrdSetID)),"^",15)
	s effDateTo=$p($g(^ARCOS(ARCOrdSetID)),"^",16)
	s currDate=+$h
	q:((effDateFrom'="")&&(effDateFrom>currDate))
	q:((effDateTo'="")&&(effDateTo<currDate))
	//**********************************************
	s Data=$lb(ARCOrdSetID,ARCOrdSetCode,ARCOrdSetDesc)
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

/// Creator:     zhufei
/// CreatDate:   2015-06-11
/// Description: 剂量单位
/// Table:       SQLUSER.ARC_ItmMast
/// d ##Class(%ResultSet).RunQuery("DHCCPW.MRC.FORM.LnkArcimSrv","QryDoseUomByArcim","13217||1")
Query QryDoseUomByArcim(aArcimID As %String) As %Query(ROWSPEC = "DoseUomID:%String,DoseUomDesc:%String")
{
}

ClassMethod QryDoseUomByArcimExecute(ByRef qHandle As %Binary, aArcimID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:aArcimID="" $$$OK
	
	Set (UOMRowid,UOMDesc)=""
	Set DrgFormRowid=$p($g(^ARCIM(+aArcimID,$p(aArcimID,"||",2),1)),"^",12)  //剂量
	Set:DrgFormRowid=-1 DrgFormRowid=""
	If DrgFormRowid'="" {
		Set PHCDRowid=$P(DrgFormRowid,"||",1)
		Set ChildSub=$P(DrgFormRowid,"||",2)
		Set UserLanguage=""
		Set UOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
		If UserLanguage="EN" {
			Set UOMDesc=$p($g(^CT("UOM",UOMRowid)),"^",3)
		}Else{
			Set UOMDesc=$p($g(^CT("UOM",UOMRowid)),"^",2)
		}
		
		Set Data=$lb(UOMRowid,UOMDesc)
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
			
			Set Data=$lb(UOMRowid,UOMDesc)
		 	Set ^CacheTemp(repid,ind)=Data
		 	Set ind=ind+1
		}
	}Else{
		Set Data=$lb(UOMRowid,UOMDesc)
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

/// Creator:     zhufei
/// CreatDate:   2015-06-11
/// Description: 查询疗程
/// Table:       SQLUSER.PHC_Duration
/// d ##Class(%ResultSet).RunQuery("DHCCPW.MRC.FORM.LnkArcimSrv","QryPHCDuration","1")
Query QryPHCDuration(aDesc As %String) As %Query(ROWSPEC = "DuratID:%String,DuratDesc:%String")
{
}

ClassMethod QryPHCDurationExecute(ByRef qHandle As %Binary, aDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:aDesc="" $$$OK
	
	Set PHCDuratList=..GetPHCDurat(aDesc)
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
		Set DuratDesc=rs.Get("CTPCPDesc")	// Desc
		Set return=return_$lb(DuratID_"^"_DuratDesc)
	}
	Do rs.Close()
	
	Quit return
}

/// Creator:     zhufei
/// CreatDate:   2015-06-11
/// Description: 查询频次
/// Table:       SQLUSER.PHC_Freq
/// d ##Class(%ResultSet).RunQuery("DHCCPW.MRC.FORM.LnkArcimSrv","QryPHCFreq","q")
Query QryPHCFreq(aDesc As %String) As %Query(ROWSPEC = "FreqID:%String,FreqDesc:%String")
{
}

ClassMethod QryPHCFreqExecute(ByRef qHandle As %Binary, aDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:aDesc="" $$$OK
	
	Set PHCFreqList=..GetPHCFreq(aDesc)
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
		Set FreqDesc=rs.Get("CTPCPDesc")	// Desc
		Set return=return_$lb(FreqID_"^"_FreqDesc)
	}
	Do rs.Close()
	
	Quit return
}

/// Creator:     zhufei
/// CreatDate:   2015-06-11
/// Description: 查询用法。
/// Table:       SQLUSER.PHC_Instruc
/// d ##Class(%ResultSet).RunQuery("DHCCPW.MRC.FORM.LnkArcimSrv","QryPHCInstruc","po")
Query QryPHCInstruc(aDesc As %String) As %Query(ROWSPEC = "InstrucID:%String,InstrucDesc:%String")
{
}

ClassMethod QryPHCInstrucExecute(ByRef qHandle As %Binary, aDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:aDesc="" $$$OK
	
	Set PHCInstrucList=..GetPHCInstruc(aDesc)
	Quit:PHCInstrucList="" $$$OK
	For indInstruc=1:1:$listlength(PHCInstrucList) {
		Set tmpInstrucInfo=$list(PHCInstrucList,indInstruc)
		Continue:tmpInstrucInfo=""
		Set InstrucID=$p(tmpInstrucInfo,"^",1)
		Set InstrucDesc=$p(tmpInstrucInfo,"^",2)
		Set Data=$lb(InstrucID,InstrucDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
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
		Set InstrucDesc=rs.Get("Desc")	// Desc
		Set return=return_$lb(InstrucID_"^"_InstrucDesc)
	}
	Do rs.Close()
	
	Quit return
}

}
