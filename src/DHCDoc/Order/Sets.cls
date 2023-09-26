Class DHCDoc.Order.Sets Extends DHCDoc.Util.RegisteredObject
{

ClassMethod GetLocAuth(GroupID = "", HospID = "") As %Boolean
{
	s:GroupID="" GroupID=%session.Get("LOGON.GROUPID")
	s:HospID="" HospID=%session.Get("LOGON.HOSPID")
	Q +..%GetConfig1("OrdSetLocAuth",GroupID,HospID)
}

ClassMethod GetHospAuth(GroupID = "", HospID = "") As %Boolean
{
	s:GroupID="" GroupID=%session.Get("LOGON.GROUPID")
	s:HospID="" HospID=%session.Get("LOGON.HOSPID")
	Q +..%GetConfig1("OrdSetHospAuth",GroupID,HospID)
}

ClassMethod CopyToOtherAuth(ASCOSRowids, UserID, LocID, HospID, ToType)
{
	s ret=0
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	TS
	for i=1:1:$L(ASCOSRowids,"^"){
		s OldARCOSRowid=$P(ASCOSRowids,"^",i)
		continue:OldARCOSRowid=""
		s ARCOSCode=$p(^ARCOS(OldARCOSRowid),"^",1)_"RS"
		s ARCOSDesc=$p(^ARCOS(OldARCOSRowid),"^",2)
		s ARCOSCatID=$p(^ARCOS(OldARCOSRowid),"^",8)
		s ARCOSSubCatID=$p(^ARCOS(OldARCOSRowid),"^",9)
		s ARCOSEffectDate=$p(^ARCOS(OldARCOSRowid),"^",15)
		s ARCOSAlias=""
		s ARCOSAliasRowid="" for{
			s ARCOSAliasRowid=$O(^ARC("ALIAS",0,"ARCOS",OldARCOSRowid,ARCOSAliasRowid)) Q:ARCOSAliasRowid=""
			s oneAlias=$P(^ARC("ALIAS",ARCOSAliasRowid),"^",6)
			i ARCOSAlias="" s ARCOSAlias=oneAlias
			e  s ARCOSAlias=ARCOSAlias_$C(2)_oneAlias
		}
		s FavRowId=$O(^DHCFavItems(0,"ItemRowid",OldARCOSRowid,0))
		s FavCelerType=$p($G(^DHCFavItems(+FavRowId)),"^",10)
		s ret=##class(web.DHCUserFavItems).InsertUserARCOS(UserID,ARCOSCode,ARCOSDesc,ARCOSCatID,ARCOSSubCatID,ARCOSEffectDate,ARCOSAlias,UserID,LocID,"",HospID,FavCelerType,HospID,"","",ToType)
		if ret<0{
			Q
		}
		s ARCOSRowid=$p(ret,$C(1),2)
		s FavRowid=$p(ret,$C(1),1)
		&SQL(select ARCOS_PrescTypeCode,ARCOS_DurationDR, 
			ARCOS_FrequencyDR, ARCOS_Instr_DR, ARCOS_InstrLinkDosage_DR,ARCOS_Notes
			into :PrescTypeCode,:DuratId,:FreqId,:InstrId,:DoseQtyId,:Notes
			from SQLUser.ARC_OrdSets
			WHERE ARCOS_RowId1=:OldARCOSRowid)
		s ret=##class(DHCDoc.DHCDocConfig.OrdSets).SaveOSCNInfo(ARCOSRowid, PrescTypeCode, DoseQtyId, DuratId, FreqId, InstrId, Notes)
		Q:ret'=0
		s OldARCOSDateRowid=##class(web.DHCARCOrdSets).GetOrderSetDate(OldARCOSRowid)
		kill ^TempArcosSerialNo
		if (+OldARCOSDateRowid'=0) {
			s NO=1
			s item=0 
			for {
				s item=$o(^ARCOS(+OldARCOSDateRowid,"DATE",$p(OldARCOSDateRowid,"||",2),"ITM",item)) q:item=""  s s=^(item) d
				s ARCIMRowid=$p(s,"^",1)
				s ITMSerialNo=$p($G(^ARCOS(+OldARCOSDateRowid,"DATE",$p(OldARCOSDateRowid,"||",2),"ITM",item)),"^",20)
				s ^TempArcosSerialNo($J,NO)=ITMSerialNo_"^"_OldARCOSDateRowid_"||"_item_"^"_ARCIMRowid  s NO=NO+1
			}
			s item=0 
			for {
				s item=$o(^ARCOS(+OldARCOSDateRowid,"DATE",$p(OldARCOSDateRowid,"||",2),"OS",item)) q:item=""  s s=^(item) d
				s ARCIMRowid=$p(s,"^",1)
				s SerialNo=$p(s,"^",3)
				s ^TempArcosSerialNo($J,NO)=SerialNo_"^"_OldARCOSDateRowid_"||"_item_"^"_ARCIMRowid  s NO=NO+1
			}
			s NO=0
			for {
				s NO=$O(^TempArcosSerialNo($J,NO)) q:NO=""
				s data=$g(^TempArcosSerialNo($J,NO))
				s SerialNo1=$p(data,"^",1)
				s NO1=NO
				f {
					s NO1=$O(^TempArcosSerialNo($J,NO1)) q:NO1=""
					s data1=$g(^TempArcosSerialNo($J,NO))
					s SerialNo2=$p(data1,"^",1)
					i (SerialNo1>SerialNo2) {
						s ^TempArcosSerialNo($J,NO)=data1
						s ^TempArcosSerialNo($J,NO1)=data
						s SerialNo1=SerialNo2
					}
				}
			}
			s NO=0
			for {
				s NO=$O(^TempArcosSerialNo($J,NO)) q:NO=""
				s data=$g(^TempArcosSerialNo($J,NO))
				s ARCIMRowID=$p(data,"^",3)
				s ItemRowid=$p(data,"^",2)
				if (ARCIMRowID["||"){
					&SQL(DECLARE DateItemCursor CURSOR FOR
						select ITM_ParRef,ITM_ARCIM_DR,ITM_Qty,ITM_DoseQty,ITM_UOM_DR,ITM_Freq_DR,ITM_Durat_DR,ITM_Instruc_DR,ITM_LinkDoctor,ITM_SerialNo,ITM_RecLoc_DR,ITM_Stage,ITM_PackQtyUom_DR,ITM_SkinTest,ITM_SkinTestAction,
						ITM_Priority_DR,ITM_SampleId,ITM_PriorRemarksDR,ITM_MustEnter,ITM_SpeedFlowRate,ITM_FlowRateUnit_DR,ITM_OrderBodyPartLabel,
						ITM_NotifyClinician,ITM_RemoveCeler,ITM_FreqTimeDoseQtyStr,ITM_FreqWeekStr
						into :ARCOSDateRowid,:ARCIMRowid,:ItemQty,:ItemDoseQty,:ItemDoseUOMID,:ItemFrequenceID,:ItemDurationID,:ItemInstructionID,:ItmLinkDoctor,:ARCOSItemNO,:DHCDocOrderRecLoc,:DHCDocOrderStageID,:ITMPackQtyUomRowId,:SkinTest,:SkinTestActiong,
						:DHCDocOrderTypeID,:SampleId,:OrderPriorRemarksDR,:MustEnter,:SpeedFlowRate,:FlowRateUnit,:OrderBodyPartLabel,
						:NotifyClinician,:RemoveCeler,:OrderFreqTimeDoseStr,:OrderFreqWeekStr
						from sqluser.ARC_OrdSetDateItem 
						where ITM_RowId=:ItemRowid)
					&SQL(OPEN DateItemCursor)
				}else{
					s (ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,DHCDocOrderRecLoc,DHCDocOrderStageID,ITMPackQtyUomRowId,SkinTest,SkinTestActiong)=""
					&SQL(DECLARE DateItemCursor1 CURSOR FOR
						select OS_ParRef,OS_OrderSet_DR,OS_SerialNo
						into :ARCOSDateRowid,:ARCIMRowid,:ARCOSItemNO
						from sqluser.ARC_OrdSetDateOS where OS_RowId=:ItemRowid)
						&SQL(OPEN DateItemCursor1)
				}
				FOR {
					if (ARCIMRowID["||"){
						&SQL(FETCH DateItemCursor)
					}else{
						&SQL(FETCH DateItemCursor1)
					}
					q:SQLCODE 
					s remark=$g(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"NOTES",1))
					s ExpStr=$g(DHCDocOrderStageID)_"^"_$g(MustEnter)_"^"_$g(ITMPackQtyUomRowId)_"^"_$g(SpeedFlowRate)_"^"_$g(FlowRateUnit)_"^"_$g(OrderBodyPartLabel)_"^"_$g(SkinTest)_"^"_$g(SkinTestActiong)_"^"_$g(NotifyClinician)_"^"_$g(RemoveCeler)_"^"_$g(OrderFreqTimeDoseStr)_"^"_$g(OrderFreqWeekStr)
					s InsertItem=##class(web.DHCARCOrdSets).InsertItem(ARCOSRowid,ARCIMRowid,ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,remark,DHCDocOrderTypeID,SampleId,ARCOSItemNO,OrderPriorRemarksDR,DHCDocOrderRecLoc,ExpStr)
					if (SQLCODE'=0){
						set ^TEMP("DHCUserFavItems:SaveAsUser","Error",$J,+$h)=SQLCODE
					}
				}
				if (ARCIMRowID["||"){
					&sql(CLOSE DateItemCursor)
				}else{
					&sql(CLOSE DateItemCursor1)
				}
			}
			//婢跺秴鍩楅崠鍛帮拷鍛�鐜�閺嶏拷
			s PRICEChildsub=0
			for {
				s PRICEChildsub=$o(^ARCOS(OldARCOSRowid,"PRICE",PRICEChildsub)) Q:PRICEChildsub=""
				s str=$g(^ARCOS(OldARCOSRowid,"PRICE",PRICEChildsub))
				continue:str=""
				s Tariff=$p(str,"^",3)
				s DateFrom=$p(str,"^",1)
				s DateTo=$p(str,"^",2)
				s Price=$p(str,"^",4)
				s Hospital=$p(str,"^",7)
				d ##class(web.DHCUserFavItemPrice).insert(ARCOSRowid,DateFrom,DateTo,Tariff,Price,Hospital)
			}
		}
	}
	if ret'=0 TRO
	else  TC
	Q ret
}

}
