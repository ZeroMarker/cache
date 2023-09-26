Class web.UDHCFavItemNew Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creater lxz
/// desc 获取新医嘱套维护界面的comb维护数据公共Comb
/// CombName 获取Comb的名字
/// d ##class(%ResultSet).RunQuery("web.UDHCFavItemNew","CombListFind","DHCDocOrderStage","","","")
/// ,selected:%Boolean
Query CombListFind(CombName As %String, Inpute1 As %String, Inpute2 As %String, Inpute3 As %String, Inpute4 As %String = "", Inpute5 As %String = "", Inpute6 As %String = "") As %Query(ROWSPEC = "CombDesc:%String,CombValue:%String,CombCode:%String,CombValueInfo:%String")
{
}

ClassMethod CombListFindExecute(ByRef qHandle As %Binary, CombName As %String, Inpute1 As %String, Inpute2 As %String, Inpute3 As %String, Inpute4 As %String = "", Inpute5 As %String = "", Inpute6 As %String = "") As %Status
{
	;s $ZT="ErrorCombListFind"
	k TempList
	s ^lxz("CombList",CombName)=CombName_"^"_Inpute1_"^"_Inpute2_"^"_Inpute3
	s LogonLocRowId=%session.Get("LOGON.CTLOCID")
	s LogonHospDr=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId("")
	Set langid=..%LanguageID()
	if CombName="Category"{
		;医嘱大类
	  	Set rset=##class(%ResultSet).%New("web.OECOrderCategory:LookUpCat")
		do rset.Execute("","","","","")
		 While (rset.Next()) {
			s CombDesc=rset.GetData(1)
			s CombValue=rset.GetData(2)
			continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("OEC_OrderCategory",CombValue,LogonHospDr)="N"
			s DefaultComb="0"
			if CombDesc["医嘱套" s DefaultComb="1"
			s Sub=$O(TempList(""),-1)+1
			Set CombDesc= ##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc",CombDesc,langid)
			s TempList(Sub)=CombDesc_"^"_CombValue_"^"_DefaultComb
		 }
	 	d rset.Close()
	}elseif(CombName="SubCategory"){
		s CMFlag=Inpute2
		if (CMFlag'=""){
			s CNMedItemCatStr=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr(LogonHospDr)
			i CNMedItemCatStr'="" s CNMedItemCatStr="^"_CNMedItemCatStr_"^"
		}
		;医嘱子类
		s CatID=Inpute1
	 	Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpSubCat")
	 	do rset.Execute(CatID,"","","")
	 	While (rset.Next()) {
			s CombDesc=rset.GetData(1)
			s CombValue=rset.GetData(2)
			continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItemCat",CombValue,LogonHospDr)="N"
			continue:(CMFlag="CM")&&(CNMedItemCatStr'[("^"_CombValue_"^"))
			continue:(CMFlag="XY")&&(CNMedItemCatStr[("^"_CombValue_"^"))
			s DefaultComb=0
			if CombDesc="个人医嘱套" s DefaultComb="1"
			s Sub=$O(TempList(""),-1)+1
			Set CombDesc= ##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",CombDesc,langid)
			s TempList(Sub)=CombDesc_"^"_CombValue_"^"_DefaultComb
		}
	 	d rset.Close()
	 	
	}elseif(CombName="Conditiones"){
		s DocMedUnit=Inpute1
		s TempList(1)=##class(websys.Translation).Get("udhcfavitem.edit.hui.csp","个人")_"^"_1_"^"_1
		s TempList(2)=##class(websys.Translation).Get("udhcfavitem.edit.hui.csp","科室")_"^"_2_"^"_0
		s TempList(3)=##class(websys.Translation).Get("udhcfavitem.edit.hui.csp","全院")_"^"_3_"^"_0
		s:DocMedUnit'="" TempList(4)=##class(websys.Translation).Get("udhcfavitem.edit.hui.csp","组")_"^"_4_"^"_0
	}elseif(CombName="ItemFrequence"){
		s desc=$$ALPHAUP^SSUTIL4(Inpute2)
		//频次
		s ReturnMesag=##class(web.DHCDocItemDefault).ReadItemFrequenceNew(Inpute1)
		s LenR=$L(ReturnMesag,"^")
		s JNO=0
		for J=1:1:LenR{
			s SUStr=$P(ReturnMesag,"^",J)
			s SRowID=$P(SUStr,$C(1),1)
			Continue:SRowID=""
			Continue:##class(web.DHCDocOrderCommon).CheckDataValid("PHCFreq", "", SRowID, LogonLocRowId)="0"
			s SDesc1=$P(SUStr,$C(1),2)
			s Code=$P(SDesc1,"-",2)
			s SDesc=$P(SDesc1,"-",1)
			s SDesc=$Replace(SDesc,"***","-")
			s FindFlag=1
			i desc'=""  {
				s FindFlag=0
				s SubCode=$$ALPHAUP^SSUTIL4(Code)
				s subDesc1=$$ALPHAUP^SSUTIL4(SDesc)
				i ((SubCode=desc)||(subDesc1[desc))  {
					s FindFlag=1
				}
				i FindFlag'=1  {
					s SubID=0  
					for {
						s SubID=$O(^User.BDPAliasI("DataRef","PHC_Freq",SRowID,SubID)) Q:SubID=""  
						i $D(^User.BDPAliasD(SubID)) {
							s SUbCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
							i SUbCode[desc  s FindFlag=1
						}
					}
				}
			}
			Continue:FindFlag'=1
			/*s Code=$P(SDesc1,"-",2)
			s Code=$Replace(Code,"?","")
			s Code=$Replace(Code,"***","")
			if (Code'=""){s Code=Code_"-"}*/
			Set SDesc= ##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",SDesc,langid)
			s JNO=JNO+1
			s TempList(JNO)=SDesc_"^"_SRowID_"^0^"_Code_"^"_##class(web.DHCDocUtil).Replace($g(^PHCFR(SRowID)),"^","!")
			//s TempList(JNO)=SDesc_"^"_SRowID_"^"_0
		}
	}elseif(CombName="ItemInstruction"){
		s desc=$$ALPHAUP^SSUTIL4(Inpute2)
		//用法
		s ReturnMesag=##class(web.DHCDocItemDefault).ReadItemInstrNew(Inpute1)
		s LenR=$L(ReturnMesag,"^")
		s JNO=0
		for J=1:1:LenR{
			s SUStr=$P(ReturnMesag,"^",J)
			s SRowID=$P(SUStr,$C(1),1)
			Continue:SRowID=""
			Continue:##class(web.DHCDocOrderCommon).CheckDataValid("PHCInstruc", "", SRowID, LogonLocRowId)="0"
			s SDesc1=$P(SUStr,$C(1),2)
			s SDesc=$P(SDesc1,"-",1)
			s SDesc=$Replace(SDesc,"***","-")
			s Code=$P(SDesc1,"-",2)
			s Code=$Replace(Code,"?","")
			
			s FindFlag=1
			i desc'=""  {
				s FindFlag=0
				s SubCode=$$ALPHAUP^SSUTIL4(Code)
				s subDesc1=$$ALPHAUP^SSUTIL4(SDesc)
				i ((SubCode=desc)||(subDesc1[desc))  {
					s FindFlag=1
				}
				i FindFlag'=1  {
					s SubID=0  
					for {
						s SubID=$O(^User.BDPAliasI("DataRef","PHC_Instruc",SRowID,SubID)) Q:SubID=""  
						i $D(^User.BDPAliasD(SubID)) {
							s SUbCode=$$ALPHAUP^SSUTIL4($list(^User.BDPAliasD(SubID),2))
							i SUbCode[desc  s FindFlag=1
						}
					}
				}
			}
			Continue:FindFlag'=1
			
			Set SDesc= ##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",SDesc,langid)
			//if (Code'=""){s Code=Code_"-"}
			s JNO=JNO+1
			//s TempList(JNO)=SDesc_"^"_SRowID_"^"_0
			s TempList(JNO)=SDesc_"^"_SRowID_"^0^"_Code
			//s TempList(JNO)=SDesc_"^"_SRowID_"^"_0
		}
	}
	elseif(CombName="ItemDuration"){
		 //疗程
		 s JNO=0	
		 s CMFlag=$P(Inpute1,"^",2) //取草药标志lxz
		 s desc=$P(Inpute1,"^",1)
		 Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpDuration")
		 do rset.Execute(desc)
		 While (rset.Next()) {
			s Desc=rset.GetData(2)
			s Desc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",Desc,langid)
			s value=rset.GetData(1)
			s DateFrom=$P(^PHCDU(value),"^",5)
			continue:(DateFrom'="")&&(DateFrom>+$h)
			s DateTo=$P(^PHCDU(value),"^",6)
			continue:(DateTo'="")&&(DateTo<=..%SysDate())
			s mydes2=""
			if value'="" s mydes2=$p(^PHCDU(value),"^",4)
			Continue:(CMFlag="Y")&&(mydes2'="饮片")  //lxz
			Continue:(CMFlag="N")&&(mydes2="饮片")  //lxz
			Continue:(CMFlag="Clear")
			s JNO=JNO+1
		    s TempList(JNO)=Desc_"^"_value_"^"_0
		 }
		 d rset.Close()
	}elseif(CombName="OrderPriorRemarks"){
		//医嘱类型
		s ReturnMesag=##class(web.DHCDocItemDefault).GetPriorRemarks(Inpute1)
		s LenR=$L(ReturnMesag,"^")
		s JNO=0
		for J=1:1:LenR{
			s SUStr=$P(ReturnMesag,"^",J)
			s SRowID=$P(SUStr,$C(1),1)
			Continue:SRowID=""
			s SDesc1=$P(SUStr,$C(1),2)
			s SDesc=$P(SDesc1,"-",1)
			s Code=$P(SDesc1,"-",2)
			s SDesc=##class(websys.Translation).Get("udhcfavitem.edit.newedit.csp",SDesc)
			if (Code'=""){s Code=Code_"-"}
			s JNO=JNO+1
			s TempList(JNO)=Code_SDesc_"^"_SRowID_"^"_0
		}
	}elseif(CombName="ItemDoseUOM"){
		//剂量单位 
		s ARCIMRowid=Inpute1
		if ARCIMRowid'=""{
		s DrgFormRowid=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",12)
		s PHCDRowid=+$P(DrgFormRowid,"||",1)
	    s ChildSub=+$P(DrgFormRowid,"||",2)
	    s JNO=0
		if (PHCDRowid'=0)&&(ChildSub'=0){
			s FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
	 		s FormDoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
	  		s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
	  		if (FormDoseUOMRowid'="")||(FormDoseUOMDesc=""){
	  			s JNO=JNO+1 s Def=0
	  			//i (Inpute2="")&&(JNO=1) s Def=1 
	  			//else  i Inpute2=FormDoseUOMRowid  s Def=1
	  			i Inpute2=FormDoseUOMRowid  s Def=1
	  			s TempList(JNO)=FormDoseUOMDesc_"^"_FormDoseUOMRowid_"^"_Def
	  		}
	  		s leq=0
	  	    f  s leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)) Q:leq=""  d
	  		.s eqrec=^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)
	  		.s FormDoseUOMRowid=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2),eqdefaultqty=$p(eqrec,"^",3)
	  		.Q:FormDoseUOMRowid=""
	 	 	.if eqdefaultqty'="" s FormDoseQty=eqdefaultqty
	  		.e  s FormDoseQty=eqqty
	  		.s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
	  		.Q:FormDoseUOMDesc=""
	  		.s JNO=JNO+1 s Def=0
	  		.i (Inpute2="")&&(JNO=1) s Def=1 
	  		.else  i Inpute2=FormDoseUOMRowid  s Def=1
	  		.s TempList(JNO)=FormDoseUOMDesc_"^"_FormDoseUOMRowid_"^"_Def
		  }
		}
		
	}elseif(CombName="sampleType"){
		//标本
		s ArcimDr=Inpute1
		i ArcimDr'="" {
			s ReturnMesag=##class(web.DHCDocOrderCommon).GetLabSpec(ArcimDr)
			s ^tmpgry("ReturnMesag")=ReturnMesag_","_ArcimDr
			s LenR=$L(ReturnMesag,$C(2))
			s JNO=0
			for J=1:1:LenR{
				s SUStr=$P(ReturnMesag,$C(2),J)
				s SDesc=$P(SUStr,$C(3),2)
				s SRowID=$P(SUStr,$C(3),1)
				Continue:SRowID=""
				s JNO=JNO+1
				s Def=0
				i (Inpute2'=""){ if (SRowID=Inpute2) s Def=1}
				else{
					if (Inpute3=1){
						if JNO=1 s Def=1
					}
                }
				//i SRowID="SP02" s SRowID="11"
				s TempList(JNO)=SDesc_"^"_SRowID_"^"_Def
			}
		}
		b ;11
	}
	elseif(CombName="DHCDocOrderType"){
		//医嘱类型
		s JNO=0
		if (Inpute1="RC"){ //草药
			s CMPriorStr=..%GetConfig("CNMedPrior")
			s Count=$LENGTH(CMPriorStr,"^")
			For i = 1:1:Count {
				s PriorRowid=$P(CMPriorStr,"^",i)
				s PriorDesc=$P(^OECPR(PriorRowid),"^",2)
				s PriorDesc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",PriorDesc,langid)
				s JNO=JNO+1
				s TempList(JNO)=PriorDesc_"^"_PriorRowid_"^"_0
			}
		}else{
			Set rset=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpDHCDocOrderType")
		 	do rset.Execute("")
		 	While (rset.Next()) {
				s Desc=rset.GetData(2)
				s Desc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",Desc,langid)
				s value=rset.GetData(1)
				s JNO=JNO+1
				s TempList(JNO)=Desc_"^"_value_"^"_0
			}
			d rset.Close()
		}
	}elseif(CombName="DHCDocOrderStage"){
		//医嘱阶段
		s JNO=0
		s OrderStageStr=##class(web.DHCDocOrderCommon).GetOrderStage("")
		s LenR=$L(OrderStageStr,"^")
		s JNO=0
		for J=1:1:LenR{
			s SUStr=$P(OrderStageStr,"^",J)
			s SRowID=$P(SUStr,$C(1),1)
			Continue:SRowID=""
			s SDesc=$P(SUStr,$C(1),2)
			s SDesc=##class(websys.Translation).Get("oeorder.oplistcustom.new.csp",SDesc)
			s JNO=JNO+1
			s TempList(JNO)=SDesc_"^"_SRowID_"^"_0
		}
	}
	elseif(CombName="remark"){
		//备注信息
		if Inpute1["Y" {
		s ReturnMesag=##class(web.DHCDocItemDefault).PhSpecInstrList()
		s LenR=$L(ReturnMesag,"^")
		s JNO=0
		for J=1:1:LenR{
			s SUStr=$P(ReturnMesag,"^",J)
			s SRowID=$P(SUStr,$C(1),1)
			Continue:SRowID=""
			s SDesc1=$P(SUStr,$C(1),2)
			s SDesc=$P(SDesc1,"-",1)
			s Code=$P(SDesc1,"-",2)
			if (Code'=""){s Code=Code_"-"}
			s SDesc=##class(websys.Translation).Get("udhcfavitem.edit.newedit.csp",SDesc)
			s JNO=JNO+1
			s TempList(JNO)=SDesc_"^"_SRowID_"^"_0 //Code_
		}
		}
	}elseif(CombName="ItemBillUOM"){
		k TempListArr($j)
		s ArcimRowid=Inpute2
		s JNO=0
		if (Inpute1'="Y")&&(ArcimRowid'="") {
			s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimRowid)
			if (INCIRowid'="") {
				;接收科室不为空
				if (Inpute3'="") {
					s LocRowid=Inpute3
					s ChildSub=$o(^INCI("IL_LOC",LocRowid,INCIRowid,0))
					s INCILocRowid=INCIRowid_"||"_ChildSub
					s Rowid=0
					for {
						s Rowid=$o(^DHCILDU(0,"INCIL",INCILocRowid,Rowid)) q:Rowid=""
						s DispUomDR=$p($g(^DHCILDU(Rowid)),"^",1)
						continue:DispUomDR=""
						continue:$d(TempListArr($j,DispUomDR))
						s ActiveFlag=$p($g(^DHCILDU(Rowid)),"^",2) ;激活标志
						continue:ActiveFlag'="Y"
						s StDate=$p($g(^DHCILDU(Rowid)),"^",3) ;有效日期
						continue:(StDate'="")&&(StDate>+$H)
						s EnDate=$p($g(^DHCILDU(Rowid)),"^",4)
						continue:(EnDate'="")&&(EnDate<+$H)
						s DispUomDesc=$p($g(^CT("UOM",DispUomDR)),"^",2)
						s DispUomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",DispUomDesc,langid)
						s JNO=JNO+1
						;是否传入默认单位
						i (Inpute4'="") {
							i (DispUomDR=Inpute4) s selected=1
							e  s selected=0
						}else{
							i JNO=1 s selected=1
							e  s selected=0
						}
						s TempList(JNO)=DispUomDesc_"^"_DispUomDR_"^"_selected
						s TempListArr($j,DispUomDR)=1
					}
				}else{
					s ChildSub=0
					for {
						s ChildSub=$o(^INCI(INCIRowid,"IL",ChildSub)) Q:ChildSub=""
						s INCILocRowid=INCIRowid_"||"_ChildSub
						s Rowid=0
						for {
							s Rowid=$o(^DHCILDU(0,"INCIL",INCILocRowid,Rowid)) q:Rowid=""
							s DispUomDR=$p($g(^DHCILDU(Rowid)),"^",1)
							continue:DispUomDR=""
							continue:$d(TempListArr($j,DispUomDR))
							s ActiveFlag=$p($g(^DHCILDU(Rowid)),"^",2) ;激活标志
							continue:ActiveFlag'="Y"
							s StDate=$p($g(^DHCILDU(Rowid)),"^",3) ;有效日期
							continue:(StDate'="")&&(StDate>+$H)
							s EnDate=$p($g(^DHCILDU(Rowid)),"^",4)
							continue:(EnDate'="")&&(EnDate<+$H)
							s DispUomDesc=$p($g(^CT("UOM",DispUomDR)),"^",2)
							s DispUomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",DispUomDesc,langid)
							s JNO=JNO+1
							;是否传入默认单位
							i (Inpute4'="") {
								i (DispUomDR=Inpute4) s selected=1
								e  s selected=0
							}else{
								i JNO=1 s selected=1
								e  s selected=0
							}
							s TempList(JNO)=DispUomDesc_"^"_DispUomDR_"^"_selected
							s TempListArr($j,DispUomDR)=1
						}
					}
				}
			}
			s OPBillUOMRowID=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimRowid,"O")
			s EPBillUOMRowID=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimRowid,"E")
			s IPBillUOMRowID=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimRowid,"I")
			s BillUOMStr=OPBillUOMRowID_"^"_EPBillUOMRowID_"^"_IPBillUOMRowID
			for LoopI=1:1:3 {
				s BillUOMRowid=$P(BillUOMStr,"^",LoopI)
				continue:(BillUOMRowid="")
				continue:$d(TempListArr($j,BillUOMRowid))
				s BillUOMDesc=$p($g(^CT("UOM",BillUOMRowid)),"^",2)
				s BillUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",BillUOMDesc,langid)
				s JNO=JNO+1
				;是否传入默认单位
				i (Inpute4'="") {
					i (BillUOMRowid=Inpute4) s selected=1
					e  s selected=0
				}else{
					i JNO=1 s selected=1
					e  s selected=0
				}
				s TempList(JNO)=BillUOMDesc_"^"_BillUOMRowid_"^"_selected
				s TempListArr($j,BillUOMRowid)=1
			}
		}
		k TempListArr($j)
	}elseif(CombName="DHCDocOrderRecLoc"){
		s ARCIMRowid=Inpute1
		s ReturnMesag=##class(web.DHCARCOrdSets).GetLocRecLoc(ARCIMRowid)
		s LenR=$L(ReturnMesag,$c(2))
		s JNO=0
		for J=1:1:LenR{
			s SUStr=$P(ReturnMesag,$c(2),J)
			s SRowID=$P(SUStr,$C(1),1)
			Continue:SRowID=""
			s SDesc=$P(SUStr,$C(1),2)
			s Default=$P(SUStr,$C(1),3)
			if (Inpute3=1) {
				if (Inpute2=SRowID) s Default=1
				else  s Default=0
			}else{
				//if (Default="Y") s Default=1
			    //e  s Default=0
			    s Default=0 //默认or不默认？
			}
			continue:##class(web.DHCOPAdmReg).CheckLocDesc(SRowID,Inpute4)=0
			s SDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",SDesc,langid)
			s JNO=JNO+1
			s TempList(JNO)=SDesc_"^"_SRowID_"^"_Default
		}
	}elseif(CombName="OrderFlowRateUnit"){
		s JNO=0
		s rowid=0 f  s rowid=$o(^OEC("SFR",rowid)) q:rowid=""  d
		.s code=$p($g(^OEC("SFR",rowid)),"^",1)
		.s desc=$p($g(^OEC("SFR",rowid)),"^",2)
		.s desc=##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",desc,langid)
		.s desc=##class(web.DHCDocUtil).EvalJSON(desc)
		.s JNO=JNO+1
		.s TempList(JNO)=desc_"^"_rowid_"^"_0
	}elseif((CombName="OrderAction")){
		s JNO=0
		s rowid=0 f  s rowid=$o(^OEC("ACT",rowid)) q:rowid=""  d
		.s DateFrom=$p($g(^OEC("ACT",rowid)),"^",3)
		.Q:(DateFrom'="")&&(DateFrom>+$h)
		.s DateTo=$p($g(^OEC("ACT",rowid)),"^",4)
		.Q:(DateTo'="")&&(DateTo<=..%SysDate())
		.s code=$p($g(^OEC("ACT",rowid)),"^",1)
		.s desc=$p($g(^OEC("ACT",rowid)),"^",2)
		.s desc =##class(User.OECAction).GetTranByDesc("ACTDesc",desc,langid)
		.s desc=##class(web.DHCDocUtil).EvalJSON(desc)
		.s JNO=JNO+1
		.s TempList(JNO)=desc_"^"_rowid_"^"_0_"^"_code
		}
	kill ^TempListValue
	//统一输出接口
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Sub0=0
 	f  s Sub0=$O(TempList(Sub0)) Q:Sub0=""  d
 	.s CombDesc=$P($G(TempList(Sub0)),"^",1)
 	.s CombValue=$P($G(TempList(Sub0)),"^",2)
 	.s DefaultComb=$P($G(TempList(Sub0)),"^",3)
 	.s CombCode=$P($G(TempList(Sub0)),"^",4)
 	.s CombValueInfo=$P($G(TempList(Sub0)),"^",5)
 	.q:($d(^TempListValue($j,CombValue)))
 	.s ^TempListValue($j,CombValue)=1
 	.d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(CombDesc,CombValue,CombCode,$g(CombValueInfo)) //,DefaultComb
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
ErrorCombListFind
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod CombListFindFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CombListFindExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {		
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod CombListFindClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CombListFindExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取一条医嘱套内医嘱详细信息
/// w ##class(web.UDHCFavItemNew).GetOneARCOSItem("224||1||3","5251||1")
ClassMethod GetOneARCOSItem(ARCOSItemRowid As %String, ARCIMRowid As %String) As %String
{
 Q:(ARCOSItemRowid="")||(ARCIMRowid="") ""
 Set langid=..%LanguageID()
 if (ARCIMRowid["||"){
	 s OrderDoseStr=""
	 s s=$G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3)))
	 S ARCIMRowid=$p(s,"^",1)
	 s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	 s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
	 ;帐单单位--该字段在前台暂时没有使用
	 //s BillUOMDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
	 //s ARCOSItemBillUOM=""
	 //i BillUOMDR'="" s ARCOSItemBillUOM=$p($g(^CT("UOM",BillUOMDR)),"^",2) 
	 s ARCOSItemBillUOMDr=$p(s,"^",23)
	 s ARCOSItemBillUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(ARCOSItemBillUOMDr)
	 s ARCOSItemQty=$p(s,"^",2)
	 ;疗程
	 s ARCOSItemDuration=""
	 s ARCOSItemDurationDR=$p(s,"^",7)
	 i ARCOSItemDurationDR'="" s ARCOSItemDuration=$p($g(^PHCDU(ARCOSItemDurationDR)),"^",3)
	 ;频率
	 s ARCOSItemFrequence=""
	 s ARCOSItemFrequenceDR=$p(s,"^",8)
	 s FreqValidFlag=##class(web.DHCDocOrderCommon).CheckDataValid("PHCFreq","",ARCOSItemFrequenceDR,%session.Get("LOGON.CTLOCID"))
	 if (FreqValidFlag="0") s ARCOSItemFrequenceDR=""
	 i ARCOSItemFrequenceDR'="" s ARCOSItemFrequence=$p($g(^PHCFR(ARCOSItemFrequenceDR)),"^",3)
	 ;用法
	 s ARCOSItemInstruction=""
	 s ARCOSItemInstructionDR=$p(s,"^",9)
	 s FreqValidFlag=##class(web.DHCDocOrderCommon).CheckDataValid("PHCInstruc","",ARCOSItemInstructionDR,%session.Get("LOGON.CTLOCID"))
	 if (FreqValidFlag="0") s ARCOSItemInstructionDR=""
	 i ARCOSItemInstructionDR'="" s ARCOSItemInstruction=$p($g(^PHCIN(ARCOSItemInstructionDR)),"^",2)
	 ;剂量单位
	 s ARCOSItemUOM=""
	 s ARCOSItemUOMDR=$p(s,"^",10)
	 i ARCOSItemUOMDR'="" s ARCOSItemUOM=$p($g(^CT("UOM",ARCOSItemUOMDR)),"^",2)
	 ;剂量
	 s ARCOSItemDoseQty=$p(s,"^",13)
	 s CMSubCategory=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr()
	 s CMSubCategory="^"_CMSubCategory_"^"
	 s CMSubCategoryFlag=0
	 ;医嘱大类/子类/类型
	 s ARCOSItemSubCatDR="",ARCOSItemCatDR="",ARCOSItemOrderType=""
	 s ARCOSItemSubCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	 i ARCOSItemSubCatDR'="" d
	 .s ARCOSItemCatDR=$p($g(^ARC("IC",ARCOSItemSubCatDR)),"^",8)
	 .s ARCOSItemOrderType=$p($g(^ARC("IC",ARCOSItemSubCatDR)),"^",7)
	 .i CMSubCategory[("^"_ARCOSItemSubCatDR_"^") s CMSubCategoryFlag=1
	 ;关联
	 s ARCOSItmLinkDoctor=$p(s,"^",14)
	 s Tremark=$g(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3),"NOTES",1))
	 s OECPRRowId=$p($G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3),"DHC")),"^",1)
	 ;标本
	 s SampleID=$p($G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3),"DHC")),"^",2)
	 s:SampleID'="" SampleDesc=$p($G(^TTAB("SPEC",SampleID)),"\",1)
	 s:SampleID="" SampleDesc=""
	 ;附加说明
	 s OrderPriorRemarks=""
	 s OrderPriorRemarksDR=$p($G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3),"DHC")),"^",3)
	 s OrderPriorRemarks=$CASE(OrderPriorRemarksDR,"ONE":"取药医嘱","OUT":"出院带药","PRN":"PRN","OM":"自备药","ZT":"嘱托","":"")
	 
	 s ARCOSDHCDocOrderTypeDR=OECPRRowId
	 i (OECPRRowId'=""){s ARCOSDHCDocOrderType=$P(^OECPR(OECPRRowId),"^",2)}  
	 i (OECPRRowId="") s ARCOSDHCDocOrderType="" 
	 s ITMSerialNo=$p(s,"^",20)
	 s DHCDocOrdRecLoc=$p(s,"^",21)
	 s DHCDocOrderStageCode=$p(s,"^",22)
	 s PackQtyUomRowId=$p(s,"^",23) //整包装数量单位
	 ;是否必开
	 s OrderMustEnter=""
	 s OrderMustEnter=$p($G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3),"DHC")),"^",4)
	 s SpeedFlowRate=$p($G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3),"DHC")),"^",5)
	 s FlowRateUnit=$p($G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3),"DHC")),"^",6)
	 
	 s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ARCIMRowid)
	 s FindDoseQtyUomFlag=0
	 i DrgformRowid'="" {
		  s PHCDRowid=$P(DrgformRowid,"||",1)
		  s ChildSub=$P(DrgformRowid,"||",2)
		  ;剂量
		  s FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
		  s FormDoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
		  i ARCOSItemUOMDR=FormDoseUOMRowid s FindDoseQtyUomFlag=1
		  s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
		  s OrderDoseStr=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid
		  s leq=0
		  for {
			  s leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)) Q:leq=""
			  s eqrec=^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)
			  s FormDoseUOMRowid=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2),eqdefaultqty=$p(eqrec,"^",3)
			  if eqdefaultqty'="" s FormDoseQty=eqdefaultqty
			  e  s FormDoseQty=eqqty
			  s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
			  i ARCOSItemUOMDR=FormDoseUOMRowid s FindDoseQtyUomFlag=1 
			  s OrderDoseStr=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid_$C(2)_OrderDoseStr
		  }
		  /*s leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",0))
		  i leq'="" d
		  .s eqrec=^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)
		  .s FormDoseUOMRowid=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2),eqdefaultqty=$p(eqrec,"^",3)
		  .if eqdefaultqty'="" s FormDoseQty=eqdefaultqty
		  .e  s FormDoseQty=eqqty
		  .s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
		  .i ARCOSItemUOMDR=FormDoseUOMRowid s FindDoseQtyUomFlag=1 
		  .s OrderDoseStr=FormDoseQty_$C(1)_FormDoseUOMDesc_$C(1)_FormDoseUOMRowid_$C(2)_OrderDoseStr*/
	}
	 i FindDoseQtyUomFlag=0 s ARCOSItemUOMDR="",ARCOSItemUOM=""
	 s OrderBodyPartLabel=$p($G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3),"DHC")),"^",7)
	 s OrderBodyPartLabelText=##Class(web.DHCAPPExaReportQuery).GetPartLabel($TR(OrderBodyPartLabel,"*","^"))
	 //皮试及皮试备注
	 s SkinTest=$p(s,"^",24)
	 s SkinTestAction=$p(s,"^",25)
	 //加急标志 40
	 s NotifyClinician=$p($G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3),"DHC")),"^",8)
	 ;是否可以使用紧急标志 39
	 s Sensitive=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),9)),"^",18)
	 //快速例外
	 s RemoveCeler=$p($G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3),"DHC")),"^",9)
	 //同频次不同剂量串
	 s ITMFreqTimeDoseQtyStr=$p($G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3),"DHC")),"^",10)
	 if (ITMFreqTimeDoseQtyStr'="") s ARCOSItemDoseQty=##class(web.DHCARCOrdSets).CalFreqTimeDoseQtyStr(ITMFreqTimeDoseQtyStr)
	 //不规则频次信息
	 s OrderFreqDispTimeStr=$p($G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"ITM",$p(ARCOSItemRowid,"||",3),"DHC")),"^",11)
     i ARCOSItemFrequence="" s OrderFreqDispTimeStr=""
	 if (OrderFreqDispTimeStr'="") {
		 s OrderFreqOtherInfo=##class(web.DHCOEOrdItem).GetOrderFreqOtherInfo(ARCOSItemFrequenceDR,OrderFreqDispTimeStr)
		 s ARCOSItemFrequence=ARCOSItemFrequence_"-"_OrderFreqOtherInfo
	 }
     
     
     ;同频次不同剂量医嘱
	s SameFreqDifferentDosesFlag="N"
	s DARCIMRowid=$o(^DHCItmMast("0","ARCIM",ARCIMRowid,""))
	if (DARCIMRowid'=""){
		s AllowOnlyOnce=$P(^DHCItmMast(DARCIMRowid),"^",13)
		s SameFreqDifferentDosesFlag=$P(^DHCItmMast(DARCIMRowid),"^",22)
	}
	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ARCOSItemSubCatDR,"",ARCIMRowid)
 }else{
	 s s=$G(^ARCOS(+ARCOSItemRowid,"DATE",$p(ARCOSItemRowid,"||",2),"OS",$p(ARCOSItemRowid,"||",3)))
	 s ARCIMRowid=$p(s,"^",1)
	 s ARCIMDesc=$P(^ARCOS(ARCIMRowid),"^",2)
 }
 //存储数据
 s Data1=ARCIMDesc_"^"_$g(ARCOSItemQty)_"^"_$g(ARCOSItemBillUOM)_"^"_$g(ARCOSItemDoseQty)_"^"_$g(ARCOSItemUOM)_"^"_$g(ARCOSItemFrequence)
 s Data1=Data1_"^"_$g(ARCOSItemDuration)_"^"_$g(ARCOSItemInstruction)_"^"_$g(ARCOSItemRowid)_"^"_$g(ARCIMRowid)_"^"_$g(ARCOSItemUOMDR)
 s Data1=Data1_"^"_$g(ARCOSItemFrequenceDR)_"^"_$g(ARCOSItemDurationDR)_"^"_$g(ARCOSItemInstructionDR)_"^"_$g(ARCOSItemCatDR)
 s Data1=Data1_"^"_$g(ARCOSItemSubCatDR)_"^"_$g(ARCOSItemOrderType)_"^"_$g(ARCOSItmLinkDoctor)_"^"_$g(Tremark)_"^"_$g(ARCOSDHCDocOrderType)
 s Data1=Data1_"^"_$g(ARCOSDHCDocOrderTypeDR)_"^"_$g(SampleID)_"^"_$g(SampleDesc)_"^"_$g(ITMSerialNo)_"^"_$g(OrderPriorRemarksDR)
 s Data1=Data1_"^"_$g(OrderPriorRemarks)_"^"_$g(CMSubCategoryFlag)_"^"_$g(DHCDocOrdRecLoc)_"^"_$g(DHCDocOrderStageCode)_"^"_$g(OrderMustEnter)_"^"_$g(OrderDoseStr)_"^"_$g(PackQtyUomRowId)
 s Data1=Data1_"^"_$g(SpeedFlowRate)_"^"_$g(FlowRateUnit)_"^"_$g(OrderBodyPartLabel)_"^"_$g(OrderBodyPartLabelText)
 s Data1=Data1_"^"_$g(SkinTest)_"^"_$g(SkinTestAction)
 s Data1=Data1_"^"_$g(Sensitive)_"^"_$g(NotifyClinician)_"^"_$g(RemoveCeler)_"^"_$g(ITMFreqTimeDoseQtyStr)_"^"_$g(OrderFreqDispTimeStr)
  s Data1=Data1_"^"_$g(SameFreqDifferentDosesFlag)_"^"_$g(PHPrescType)
 q Data1
}

ClassMethod ChangeQty(Qty As %String) As %String
{
	s Qty=+Qty
	i (Qty>0)&&(Qty<1) s Qty=0_Qty
	q Qty
}

/// 获取该医嘱套能够维护的医嘱子类
/// w ##Class(web.UDHCFavItemNew).GetARCOSPrescType(2842)
ClassMethod GetARCOSPrescType(ARCOSItemRowid As %String, CurLogonHosp As %String = "") As %String
{
	n (ARCOSItemRowid,CurLogonHosp,%session)
	s CurLogonHosp=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(CurLogonHosp)
	s ARCOSOrdCatDR=$P(^ARCOS(+ARCOSItemRowid),"^",9)
	s FormulaItemCat=..%GetConfig("FormulaItemCat",CurLogonHosp)
	s CNMedItemCat=##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr(CurLogonHosp)
	i (("^"_CNMedItemCat_"^")[("^"_ARCOSOrdCatDR_"^"))||(("^"_FormulaItemCat_"^")[("^"_ARCOSOrdCatDR_"^")){
		s ARCOSPrescTypeCode=$P(^ARCOS(+ARCOSItemRowid),"^",26)
		if ARCOSPrescTypeCode'="" {
			s PrescTypeCode=ARCOSPrescTypeCode
			s PrescType=$P($g(^DHCDocConfig("HospDr_"_CurLogonHosp,"CMPrescTypeList",PrescTypeCode)),"^",1)
			s DoseQtyId=$P(^ARCOS(+ARCOSItemRowid),"^",28)
			s DoseQty=""
			i DoseQtyId s DoseQty=$P(^PHCDO(DoseQtyId),"^",3)
			s FreqFac="",Freq=""
			s FreqId=$P(^ARCOS(+ARCOSItemRowid),"^",21)
			if (FreqId){
				s FreqFac=$P(^PHCFR(FreqId),"^",2)
				s Freq=$P(^PHCFR(FreqId),"^",3)
			}
			s InstrId=$P(^ARCOS(+ARCOSItemRowid),"^",27)
			s Instr=""
			if (InstrId) s Instr=$P(^PHCIN(InstrId),"^",2)
			s DuratId=$P(^ARCOS(+ARCOSItemRowid),"^",20)
			s Durat="",DuratFac=""
			if (DuratId){
				s Durat=$P(^PHCDU(DuratId),"^",3)
				s DuratFac=$P(^PHCDU(DuratId),"^",2)
			}
			s Notes=$P(^ARCOS(+ARCOSItemRowid),"^",25)
			s dim1="^",dim2=$C(2)
			s CNInfoStr=PrescTypeCode_dim1_PrescType
			s CNInfoStr=CNInfoStr_dim2_DoseQtyId_dim1_DoseQty
			s CNInfoStr=CNInfoStr_dim2_Freq_dim1_dim1_FreqFac_dim1_dim1_FreqId
			s CNInfoStr=CNInfoStr_dim2_InstrId_dim1_Instr
			s CNInfoStr=CNInfoStr_dim2_DuratId_dim1_Durat_dim1_dim1_DuratFac
			s CNInfoStr=CNInfoStr_dim2_Notes
			Q CNInfoStr
		}
	}
	s PrescTypeCodeStr=..GetARCOSPrescTypeCodeStr(ARCOSItemRowid,CurLogonHosp)
	Q PrescTypeCodeStr
}

/// 获取中草药医嘱套满足的处方类型串,针对那些没选择处方类型的草药医嘱套
ClassMethod GetARCOSPrescTypeCodeStr(ARCOSItemRowid As %String, CurLogonHosp As %String = "")
{
	n (ARCOSItemRowid,CurLogonHosp,%session)
	Q:ARCOSItemRowid="" ""
	s CurLogonHosp=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(CurLogonHosp)
	s CNMedItemCat="^"_##Class(web.DHCDocOrderCommon).GetCNMedItemCatStr(CurLogonHosp)_"^"
	s ARCOSOrdCatDR=$P(^ARCOS(+ARCOSItemRowid),"^",9)
	Q:CNMedItemCat'[("^"_ARCOSOrdCatDR_"^") "Other"
	d ##class(DHCDoc.DHCDocConfig.CMDocConfig).GetCatPrescTypeList(.CatList,CurLogonHosp)
	if (ARCOSItemRowid'["||"){
		s ARCOSItemRowid=##class(web.DHCARCOrdSets).GetOrderSetDate(ARCOSItemRowid)
	}
	Q:+ARCOSItemRowid=0 "CNMedItem"
	s OSRowid=+ARCOSItemRowid,DateSub=$p(ARCOSItemRowid,"||",2)
	s Item=0 for {
		s Item=$O(^ARCOS(OSRowid,"DATE",DateSub,"ITM",Item)) Q:Item=""
		S ARCIMRowid=$p(^ARCOS(OSRowid,"DATE",DateSub,"ITM",Item),"^",1)
		continue:(ARCIMRowid="")
		s ItemCat=$p(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1),"^",10)
		s CatList(ItemCat)=1
	}
	//找出满足所有项目子类的处方类型代码
	s CatCount=0
	s ItemCat=0 for{
		s ItemCat=$O(CatList(ItemCat)) Q:ItemCat=""
		continue:$G(CatList(ItemCat))'=1
		s CatCount=CatCount+1
		s PrescTypeCode="" for{
			s PrescTypeCode=$O(CatList(ItemCat,PrescTypeCode)) Q:PrescTypeCode=""
			s PrescTypeCodeList(PrescTypeCode)=$G(PrescTypeCodeList(PrescTypeCode))+1
		}
	}
	s PrescTypeCodeStr=""
	s PrescTypeCode="" for{
		s PrescTypeCode=$O(PrescTypeCodeList(PrescTypeCode)) Q:PrescTypeCode=""
		if PrescTypeCodeList(PrescTypeCode)=CatCount{
			if PrescTypeCodeStr="" s PrescTypeCodeStr=PrescTypeCode
			else  s PrescTypeCodeStr=PrescTypeCodeStr_"!"_PrescTypeCode
		}
	}
	Q:PrescTypeCodeStr="" "CNMedItem"
	Q PrescTypeCodeStr
}

}
