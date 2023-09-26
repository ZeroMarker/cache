Class web.DHCARCOrdSets Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod DeleteARCOS(ARCOSRowid As %String) As %String
{
	;&SQL(Delete From sqluser.ARC_OrdSets Where ARCOS_Rowid=:ARCOSRowid)
	//删除医嘱套科室授权
	&SQL(Delete From SQLUSER.ARC_OrdSetsAuthorize Where AuthARCOSDR=:ARCOSRowid)
	//删除其他医嘱套明细嵌套该医嘱套的数据
	&SQL(delete FROM SQLUSER.ARC_OrdSetDateOS WHERE OS_OrderSet_DR=:ARCOSRowid)
	//删除医嘱套 只要截止就行,因为是删除所以直接截止到上一天,立即生效
	Set EffDateTo=..%SysDate()-1
	Set ARCOSCode=$p($g(^ARCOS(ARCOSRowid)),"^",1)
	Set ARCOSCode=ARCOSCode_"UNUSE"_ARCOSRowid
	&SQL(update  sqluser.ARC_OrdSets set ARCOS_EffDateTo=:EffDateTo,ARCOS_Code=:ARCOSCode Where ARCOS_Rowid=:ARCOSRowid)
	Q:SQLCODE -1
	Q SQLCODE
}

ClassMethod DeleteItem(ARCOSItemRowid As %String, ARCIMRowid As %String) As %String
{
	if (ARCIMRowid["||"){
		&SQL(Delete From sqluser.ARC_OrdSetDateItem Where ITM_Rowid=:ARCOSItemRowid)
	}else{
		&SQL(Delete From sqluser.ARC_OrdSetDateOS Where OS_RowId=:ARCOSItemRowid)
	}
	Q:SQLCODE -1
	Q SQLCODE
}

ClassMethod FindARCOSAliasBroker(itmjs As %String, ARCOSRowid As %String) As %String
{
	Set rset=##class(%ResultSet).%New("web.DHCARCOrdSets:FindARCOSAlias")
	do rset.Execute(ARCOSRowid)
	Set columns = rset.GetColumnCount()
	While (rset.Next()) {
		For col = 1:1:columns {
			;Write rset.GetColumnName(col),":",rset.GetData(col)
		}
		s value=rset.GetData(1)
		s desc=rset.GetData(2)
		s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"','"_$ZCVT(value,"O","JS")_"');"
		&javascript<#(retval)#>
	}
	d rset.Close()
	Q 1
}

ClassMethod FindOSItemBroker(itmjs As %String, ARCOSRowid As %String)
{
	s ^RP("FindOSItemBroker")=ARCOSRowid
	;1137
	;w ##class(web.DHCARCOrdSets).FindOSItemBroker("",1137)
	;Rowid:OrderName:,StartDate:SeqNo:DoseQty:DoseUOM:Priority:Status:Frequence:Instruction:Duration:PackQty:RecDep:Billed")
	Set rset=##class(%ResultSet).%New("web.DHCARCOrdSets:FindOSItem")
	do rset.Execute(ARCOSRowid,"1")
	Set columns = rset.GetColumnCount()
	set int=1
	While (rset.Next()) {
		For col = 1:1:columns {
			;Write rset.GetColumnName(col),":"
			if col=1 set value=rset.GetData(col)
			e  s value=value_"^"_rset.GetData(col)
		}
		s retval=itmjs_"('"_$ZCVT(value,"O","JS")_"');"
		
		set int=int+1
		&javascript<#(retval)#>
	}
	d rset.Close()
	Q 1
}

ClassMethod FindOSItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOSItemExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCARCOrdSets","FindOSItem","3798","1")
ClassMethod FindOSItemExecute(ByRef qHandle As %Binary, ARCOSRowid As %String, QueryFlag As %String) As %Status
{
 
 Set repid=$I(^CacheTemp)
 If $g(ind)="" Set ind=1
 s ^tempFindOSItem=ARCOSRowid_","_QueryFlag
 s LogonHospDr=%session.Get("LOGON.HOSPID")
 Set langid=..%LanguageID()
 s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("ARC_ItmMast",LogonHospDr)
 s ARCIMDesc="",ARCOSItemQty="",ARCOSItemBillUOM="",ARCOSItemDoseQty="",ARCOSItemUOM="",ARCOSItemFrequence="",ARCOSItemDuration="",ARCOSItemInstruction="",ARCIMRowid="",ARCOSItemUOMDR="",ARCOSItemFrequenceDR="",ARCOSItemDurationDR="",ARCOSItemInstructionDR="",ARCOSItemCatDR="",ARCOSItemSubCatDR="",ARCOSItemOrderType="",Tremark="",OECPRRowId="",ITMSerialNo="",NO=""
 k ^TempARCOSSerialNo
 set RowCount=0
 if (QueryFlag="1") d
 .S ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid) 
 .Q:'ARCOSDateRowid  
 .s NO=1
 .S item=0 f  s item=$o(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item)) q:item=""  s s=^(item) d
 ..S ARCIMRowid=$p(s,"^",1)
 ..Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ARCIMRowid,DefHospId)="N"
 ..s ArcimClassification=""
 ..;帐单单位
 ..s ARCOSItemBillUOM=""
 ..s BillUOMDR=$p(s,"^",23)  
 ..i BillUOMDR="" s BillUOMDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
 ..i (BillUOMDR'="") s ARCOSItemBillUOM=$p($g(^CT("UOM",BillUOMDR)),"^",2) //&&(ArcimClassification="RW")
 ..s ARCOSItemBillUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",ARCOSItemBillUOM,langid)
 ..s ARCOSItemRowid=ARCOSDateRowid_"||"_item
 ..s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
 ..s ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
 ..s ARCOSItemQty=$p(s,"^",2)
 ..s:(ARCOSItemQty[".")&&($p(ARCOSItemQty,".",1)="") ARCOSItemQty="0"_ARCOSItemQty
 ..;疗程
 ..s ARCOSItemDuration=""
 ..s ARCOSItemDurationDR=$p(s,"^",7)
 ..i ARCOSItemDurationDR'="" s ARCOSItemDuration=$p($g(^PHCDU(ARCOSItemDurationDR)),"^",3)
 ..s ARCOSItemDuration=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",ARCOSItemDuration,langid)
 ..;频率
 ..s ARCOSItemFrequence=""
 ..s ARCOSItemFrequenceDR=$p(s,"^",8)
 ..i ARCOSItemFrequenceDR'="" s ARCOSItemFrequence=$p($g(^PHCFR(ARCOSItemFrequenceDR)),"^",3)
 ..s ARCOSItemFrequence=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",ARCOSItemFrequence,langid)
 ..;用法
 ..s ARCOSItemInstruction=""
 ..s ARCOSItemInstructionDR=$p(s,"^",9)
 ..i ARCOSItemInstructionDR'="" s ARCOSItemInstruction=$p($g(^PHCIN(ARCOSItemInstructionDR)),"^",2)
 ..s ARCOSItemInstruction=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",ARCOSItemInstruction,langid)
 ..;剂量单位
 ..s ARCOSItemUOM=""
 ..s ARCOSItemUOMDR=$p(s,"^",10)
 ..i ARCOSItemUOMDR'="" s ARCOSItemUOM=$p($g(^CT("UOM",ARCOSItemUOMDR)),"^",2)
 ..s ARCOSItemUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",ARCOSItemUOM,langid)
 ..;剂量
 ..s ARCOSItemDoseQty=$p(s,"^",13)
 ..s:(ARCOSItemDoseQty[".")&&($p(ARCOSItemDoseQty,".",1)="") ARCOSItemDoseQty="0"_ARCOSItemDoseQty
 
 ..s ArcimClassification=##class(web.DHCDocOrderCommon).GetArcimClassification(ARCIMRowid)
 ..if (ArcimClassification="RC") d
 ...s ARCOSItemBillUOM=""
 ..;医嘱大类?子类?类型
 ..s ARCOSItemSubCatDR="",ARCOSItemCatDR="",ARCOSItemOrderType=""
 ..s ARCOSItemSubCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
 ..i ARCOSItemSubCatDR'="" d
 ...s ARCOSItemCatDR=$p($g(^ARC("IC",ARCOSItemSubCatDR)),"^",8)
 ...s ARCOSItemOrderType=$p($g(^ARC("IC",ARCOSItemSubCatDR)),"^",7)
 ..s ARCOSItmLinkDoctor=$p(s,"^",14)
 ..//$p(^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"NOTES"),1)
 ..s Tremark=$g(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item,"NOTES",1))
 ..s OECPRRowId=$p($G(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item,"DHC")),"^",1)
 ..s SampleID=$p($G(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item,"DHC")),"^",2)
 ..i ($g(HospitalCode)="")&&($d(%session)) s HospitalCode=%session.Get("LOGON.HOSPID")
 ..i $d(^DHCLISBSVersion(1))&&(SampleID'="") d
 ...s HospitalCode=$g(HospitalCode)
 ...s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
 ...i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
 ...i $l(HospitalDR) d
 ....s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,##Class(LIS.Util.Common).IndexData(SampleID),""))
 ....s:SpecimenDR'="" SampleDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
 ..e  d
 ...s:SampleID'="" SampleDesc=$p($G(^TTAB("SPEC",SampleID)),"\",1)
 ...s:SampleID="" SampleDesc=""
 ..;lxz
 ..s SampleDesc=##class(web.DHCBL.Authorize.BDPTranslation).GetTransDesc("dbo.BTSpecimen","IName","",SampleDesc)
 ..s OrderPriorRemarks=""
 ..s OrderPriorRemarksDR=$p($G(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item,"DHC")),"^",3)
 ..s OrderPriorRemarks=$CASE(OrderPriorRemarksDR,"ONE":"取药医嘱","OUT":"出院带药","PRN":"PRN","OM":"自备药","ZT":"嘱托",:"")
 ..s OrderPriorRemarks=##class(websys.Translation).Get("doc.arcositemlist.hui.csp",OrderPriorRemarks)
 ..;
 ..s ARCOSDHCDocOrderTypeDR=OECPRRowId
 ..i (OECPRRowId'=""){s ARCOSDHCDocOrderType=$P(^OECPR(OECPRRowId),"^",2)}  
 ..i (OECPRRowId="") s ARCOSDHCDocOrderType="" 
 ..s ARCOSDHCDocOrderType=##class(User.OECPriority).GetTranByDesc("OECPRDesc",ARCOSDHCDocOrderType,langid)
 ..s ITMSerialNo=$p($G(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item)),"^",20)
 ..s DHCDocOrdRecLocDR=$p(s,"^",21)
 ..i DHCDocOrdRecLocDR'="" d
 ...s DHCDocOrdRecLoc=$p($g(^CTLOC(DHCDocOrdRecLocDR)),"^",2)
 ...s DHCDocOrdRecLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",DHCDocOrdRecLoc,langid)
 ...s DHCDocOrdRecLoc=##class(web.DHCOPAdmReg).LocDescFormate(DHCDocOrdRecLoc)
 ..e  s DHCDocOrdRecLoc=""
 ..s DHCDocOrdStage=$p(s,"^",22)
 ..i DHCDocOrdStage="SQ" s DHCDocOrdStage="术前"
 ..i DHCDocOrdStage="SZ" s DHCDocOrdStage="术中"
 ..i DHCDocOrdStage="SH" s DHCDocOrdStage="术后"
 ..i DHCDocOrdStage="CZ" s DHCDocOrdStage="产中"
 ..s DHCDocOrdStage=##class(websys.Translation).Get("doc.arcositemlist.hui.csp",DHCDocOrdStage)
 ..;是否必开
 ..s OrderMustEnter=""
 ..s OrderMustEnter=$p($G(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item,"DHC")),"^",4)
 ..s:OrderMustEnter="Y" OrderMustEnter="是"
 ..s:(OrderMustEnter="N")!(OrderMustEnter="") OrderMustEnter="否"
 ..s OrderMustEnter=##class(websys.Translation).Get("doc.arcositemlist.hui.csp",OrderMustEnter)
 ..s SpeedFlowRate=$p($G(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item,"DHC")),"^",5)
 ..s FlowRateUnitDr=$p($G(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item,"DHC")),"^",6)
 ..if (FlowRateUnitDr'="") s FlowRateUnit=$p($g(^OEC("SFR",FlowRateUnitDr)),"^",2)
 ..else  s FlowRateUnit=""
 ..s FlowRateUnit=##class(User.OECSpeedFlowRate).GetTranByDesc("SFRDesc",FlowRateUnit,langid)
 ..s OrderBodyPartLabel=$p($G(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item,"DHC")),"^",7)
 ..s PartInfo=##Class(web.DHCAPPExaReportQuery).GetPartLabel($TR(OrderBodyPartLabel,"*","^"))
 ..s ITMFreqTimeDoseQtyStr=$p($G(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item,"DHC")),"^",10)
 ..if (ITMFreqTimeDoseQtyStr'="") s ARCOSItemDoseQty=..CalFreqTimeDoseQtyStr(ITMFreqTimeDoseQtyStr)
 ..s OrderFreqDispTimeStr=$p($G(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",item,"DHC")),"^",11)
 ..i ARCOSItemFrequenceDR="" s OrderFreqDispTimeStr=""
 ..if (OrderFreqDispTimeStr'="") d
 ...s OrderFreqOtherInfo=##class(web.DHCOEOrdItem).GetOrderFreqOtherInfo(ARCOSItemFrequenceDR,OrderFreqDispTimeStr)
 ...s:OrderFreqOtherInfo'="" ARCOSItemFrequence=ARCOSItemFrequence_"-"_OrderFreqOtherInfo
 ..;医嘱项是否有效
 ..s datefrom=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",13)
 ..s dateto=$p($g(^ARCIM(+ARCIMRowid,1,7)),"^",1)
 ..;开始日期和结束日期当天应该都算有效数据
 ..s ValidItemFlag=(datefrom<=+$H)&&(datefrom'="")&&((dateto="")||(dateto>=+$H))
 ..;存储数据
 ..s Data1=ARCIMDesc_PartInfo_"^"_ARCOSItemQty_"^"_ARCOSItemBillUOM_"^"_ARCOSItemDoseQty_"^"_ARCOSItemUOM_"^"_ARCOSItemFrequence_"^"_ARCOSItemDuration_"^"_ARCOSItemInstruction_"^"_ARCOSItemRowid_"^"_ARCIMRowid_"^"_ARCOSItemUOMDR_"^"_ARCOSItemFrequenceDR_"^"_ARCOSItemDurationDR_"^"_ARCOSItemInstructionDR_"^"_ARCOSItemCatDR_"^"_ARCOSItemSubCatDR_"^"_ARCOSItemOrderType_"^"_ARCOSItmLinkDoctor_"^"_Tremark_"^"_ARCOSDHCDocOrderType_"^"_ARCOSDHCDocOrderTypeDR_"^"_SampleID_"^"_SampleDesc_"^"_ITMSerialNo_"^"_OrderPriorRemarksDR_"^"_OrderPriorRemarks_"^"_DHCDocOrdRecLoc_"^"_DHCDocOrdStage_"^"_OrderMustEnter_"^"_SpeedFlowRate_"^"_FlowRateUnit_"^"_ValidItemFlag
 ..s ^TempARCOSSerialNo(ARCOSRowid,$J,item,NO)=Data1  s NO=NO+1
 
 .;输出医嘱套明细中的医嘱套
 .s ChildSub=0 f  s ChildSub=$O(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"OS",ChildSub)) q:ChildSub=""  d
 ..s ARCOSDr=$P(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"OS",ChildSub),"^",1)
 ..Q:ARCOSDr=""
 ..s ARCOSCode=$P(^ARCOS(ARCOSDr),"^",1)
 ..s ARCOSDesc=$P(^ARCOS(ARCOSDr),"^",2)
 ..s SerialNo=$P($g(^ARCOS(ARCOSRowid,"DATE",$p(ARCOSDateRowid,"||",2),"OS",ChildSub)),"^",3)
 ..s data=ARCOSDesc
 ..s $p(data,"^",24)=SerialNo,$p(data,"^",9)=ARCOSDateRowid_"||"_ChildSub,$p(data,"^",10)=ARCOSDr
 ..s datefrom=$p($g(^ARCOS(+ARCOSDr)),"^",15)
 ..s dateto=$p($g(^ARCOS(+ARCOSDr)),"^",16)
 ..s ValidItemFlag=(datefrom<=+$H)&&(datefrom'="")&&((dateto="")||(dateto>=+$H))
 ..s $P(data,"^",32)=ValidItemFlag
 ..s ^TempARCOSSerialNo(ARCOSRowid,$J,ChildSub,NO)=data,NO=NO+1
 .s NO34=1
 .k ^Tempzong
 .//排序
 .s RowID=0 f  s RowID=$O(^TempARCOSSerialNo(ARCOSRowid,$J,RowID)) q:RowID=""  d
 ..s NO=0
 ..f  s NO=$O(^TempARCOSSerialNo(ARCOSRowid,$J,RowID,NO)) q:NO=""  d
 ...s SerialNo1=$P(^TempARCOSSerialNo(ARCOSRowid,$J,RowID,NO),"^",24)
 ...s RowID2=RowID
 ...f  s RowID2=$O(^TempARCOSSerialNo(ARCOSRowid,$J,RowID2)) q:RowID2=""  d
 ....s NO1=0
 ....f  s NO1=$O(^TempARCOSSerialNo(ARCOSRowid,$J,RowID2,NO1)) q:NO1=""  d
 .....s SerialNo2=$P(^TempARCOSSerialNo(ARCOSRowid,$J,RowID2,NO1),"^",24)
 .....i (SerialNo1>SerialNo2) d
 ......s Str=$G(^TempARCOSSerialNo(ARCOSRowid,$J,RowID,NO))  
 ......s ^TempARCOSSerialNo(ARCOSRowid,$J,RowID,NO)=$G(^TempARCOSSerialNo(ARCOSRowid,$J,RowID2,NO1))
 ......s ^TempARCOSSerialNo(ARCOSRowid,$J,RowID2,NO1)=Str
 ......s SerialNo1=SerialNo2
 
 
 .//输出
 .s NO=0
 .s RowID3=0 f  s RowID3=$O(^TempARCOSSerialNo(ARCOSRowid,$J,RowID3)) q:RowID3=""  d
 ..s index=0 f  s index=$O(^TempARCOSSerialNo(ARCOSRowid,$J,RowID3,index)) q:index=""  d
 ...s Str=$G(^TempARCOSSerialNo(ARCOSRowid,$J,RowID3,index))
 ...s NO=NO+1
 ...s ARCIMDesc=$P(Str,"^",1)
 ...s ARCIMDesc=##class(web.DHCDocUtil).EvalJSON(ARCIMDesc)
 ...s ARCOSItemQty=$P(Str,"^",2)
 ...s ARCOSItemBillUOM=$P(Str,"^",3)
 ...s ARCOSItemDoseQty=$P(Str,"^",4)
 ...s ARCOSItemUOM=$P(Str,"^",5)
 ...s ARCOSItemFrequence=$P(Str,"^",6)
 ...s ARCOSItemDuration=$P(Str,"^",7)
 ...s ARCOSItemInstruction=$P(Str,"^",8)
 ...s ARCOSItemRowid=$P(Str,"^",9)
 ...s ARCIMRowid=$P(Str,"^",10)
 ...s ARCOSItemUOMDR=$P(Str,"^",11)
 ...s ARCOSItemFrequenceDR=$P(Str,"^",12)
 ...s ARCOSItemDurationDR=$P(Str,"^",13)
 ...s ARCOSItemInstructionDR=$P(Str,"^",14)
 ...s ARCOSItemCatDR=$P(Str,"^",15)
 ...s ARCOSItemSubCatDR=$P(Str,"^",16)
 ...s ARCOSItemOrderType=$P(Str,"^",17)
 ...s ARCOSItmLinkDoctor=$P(Str,"^",18)
 ...s Tremark=$P(Str,"^",19)
 ...s ARCOSDHCDocOrderType=$P(Str,"^",20)
 ...s ARCOSDHCDocOrderTypeDR=$P(Str,"^",21)
 ...s SampleID=$P(Str,"^",22)
 ...s SampleDesc=$P(Str,"^",23)
 ...s ITMSerialNo=$P(Str,"^",24)
 ...s OrderPriorRemarksDR=$P(Str,"^",25)
 ...s OrderPriorRemarks=$P(Str,"^",26)
 ...s DHCDocOrdRecLoc=$P(Str,"^",27)
 ...s DHCDocOrdStage=$P(Str,"^",28)
 ...s DHCMustEnter=$P(Str,"^",29)
 ...s SpeedFlowRate=$P(Str,"^",30)
 ...s FlowRateUnit=$P(Str,"^",31)
 ...s ValidItemFlag=$P(Str,"^",32)
 ...Do OutputRow2 	
 else  Do
 .//do ResetVariables2
 .//Do OutputRow2 	
 /*
 ..s SerialNo1=$P(^TempARCOSSerialNo(ARCOSRowid,$J,RowID),"^",24)
 ..s RowID2=RowID
 ..f  s RowID2=$O(^TempARCOSSerialNo(ARCOSRowid,$J,RowID2)) q:RowID2=""  d
 ...s SerialNo2=$P(^TempARCOSSerialNo(ARCOSRowid,$J,RowID2),"^",24)
 ...s ^Tempzong(NO34)=RowID_"^"_SerialNo1_"^"_RowID2_"^"_SerialNo2 s NO34=NO34+1
 ...i (SerialNo1>SerialNo2) d 
 ....s Str=$G(^TempARCOSSerialNo(ARCOSRowid,$J,RowID))  
 ....s ^TempARCOSSerialNo(ARCOSRowid,$J,RowID)=$G(^TempARCOSSerialNo(ARCOSRowid,$J,RowID2))
 ....s ^TempARCOSSerialNo(ARCOSRowid,$J,RowID2)=Str
 ....s SerialNo1=SerialNo2
 */
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
 set ARCIMDesc=##class(ext.util.String).EvalJSON(ARCIMDesc)
 set Tremark=##class(ext.util.String).EvalJSON(Tremark)
 set Data=$lb(ARCIMDesc,ARCOSItemQty,ARCOSItemBillUOM,ARCOSItemDoseQty,ARCOSItemUOM,ARCOSItemFrequence,ARCOSItemDuration,ARCOSItemInstruction,ARCOSItemRowid,ARCIMRowid,ARCOSItemUOMDR,ARCOSItemFrequenceDR,ARCOSItemDurationDR,ARCOSItemInstructionDR,ARCOSItemCatDR,ARCOSItemSubCatDR,ARCOSItemOrderType,ARCOSItmLinkDoctor,Tremark,ARCOSDHCDocOrderType,ARCOSDHCDocOrderTypeDR,SampleID,SampleDesc,ITMSerialNo,NO,OrderPriorRemarksDR,OrderPriorRemarks,DHCDocOrdRecLoc,DHCDocOrdStage,DHCMustEnter,SpeedFlowRate,FlowRateUnit,ValidItemFlag)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 Quit
ResetVariables2
 Set (ARCIMDesc,ARCOSItemQty,ARCOSItemBillUOM,ARCOSItemDoseQty,ARCOSItemUOM,ARCOSItemFrequence,ARCOSItemDuration,ARCOSItemInstruction,ARCOSItemRowid,ARCIMRowid,ARCOSItemUOMDR,ARCOSItemFrequenceDR,ARCOSItemDurationDR,ARCOSItemInstructionDR,ARCOSItemCatDR,ARCOSItemSubCatDR,ARCOSItemOrderType,ARCOSItmLinkDoctor,Tremark,ARCOSDHCDocOrderType,ARCOSDHCDocOrderTypeDR,SampleDesc,SampleID,ITMSerialNo,NO,OrderPriorRemarksDR,OrderPriorRemarks,DHCDocOrdRecLoc,DHCDocOrdStage,DHCMustEnter,SpeedFlowRate,FlowRateUnit,ValidItemFlag)=""
 Quit
}

ClassMethod FindOSItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOSItemExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

/// w ##class(web.DHCARCOrdSets).GetOrderSetDate(256)
ClassMethod GetOrderSetDate(ARCOSRowid As %String) As %String
{
	n drow
	s DATE=$g(DATE) s:'DATE DATE=..%SysDate()
	s ord=+$g(ARCOSRowid) q:'ARCOSRowid 0 
	s dfrom=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",.1+DATE),-1) q:'dfrom 0
	s drow=$o(^ARCOS(ARCOSRowid,"DATE",0,"DateFrom",dfrom,"")) q:'drow 0
	s dto=$p($g(^ARCOS(ARCOSRowid,"DATE",drow)),"^",2) i dto,dto<DATE q 0
	q ARCOSRowid_"||"_drow
}

ClassMethod InsertARCAlias(AliasType As %String, Rowid As %String, Alias As %String) As %String
{
	s DateFrom=..%SysDate()
	if AliasType="ARCOS" d
	.s Desc=$p($g(^ARCOS(Rowid)),"^",2)
	.s SubCatID=$p($g(^ARCOS(Rowid)),"^",9)
	.&SQL(insert into sqluser.ARC_Alias (ALIAS_ARCOS_DR,ALIAS_Text,ALIAS_Desc,ALIAS_OrderSubCat_DR,ALIAS_Type,ALIAS_DateFrom) Values (:Rowid,:Alias,:Desc,:SubCatID,:AliasType,:DateFrom))
	e  d
	.s Desc=$p($g(^ARCIM(+Rowid,$p(Rowid,"||",2),1)),"^",2)
	.s SubCatID=$p($g(^ARCIM(+Rowid,$p(Rowid,"||",2),1)),"^",10)
	.&SQL(insert into sqluser.ARC_Alias (ALIAS_ARCIM_DR,ALIAS_Text,ALIAS_Desc,ALIAS_OrderSubCat_DR,ALIAS_Type,ALIAS_DateFrom) Values (:Rowid,:Alias,:Desc,:SubCatID,:AliasType,:DateFrom))
	Q:'SQLCODE %ROWID
	Q -1
}

ClassMethod InsertARCOS(ARCOSCode As %String, ARCOSDesc As %String, ARCOSCatID As %String, ARCOSSubCatID As %String, ARCOSEffectDate As %String, LogonUserID As %String = "", ARCOSEffectDateTo As %String = "") As %String
{
	;1,doctor-1,15,90,61801
    k ^RP("InsertARCOS")
	s ^RP("InsertARCOS")=ARCOSCode_","_ARCOSDesc_","_ARCOSCatID_","_ARCOSSubCatID_","_ARCOSEffectDate
	s CurDate=..%SysDate(),CurTime=..%SysTime()
	&SQL(insert into sqluser.ARC_OrdSets (ARCOS_Code,ARCOS_Desc,ARCOS_OrdCat_DR,ARCOS_OrdSubCat_DR,ARCOS_EffDateFrom,ARCOS_AddUserDR,ARCOS_AddDate,ARCOS_AddTime,ARCOS_EffDateTo)
	 Values (:ARCOSCode,:ARCOSDesc,:ARCOSCatID,:ARCOSSubCatID,:ARCOSEffectDate,:LogonUserID,:CurDate,:CurTime,:ARCOSEffectDateTo))
	s:SQLCODE'=0 ^RP("InsertARCOS","SQLCODE",+$h)=SQLCODE
	Q:'SQLCODE %ROWID
	Q -1
}

/// d ##class(web.DHCARCOrdSets).InsertItem(1306,"138||1","",1,156,"","","","","","","","","")
ClassMethod InsertItem(ARCOSRowid As %String, ARCIMRowid As %String, ItemQty As %String, ItemDoseQty As %String, ItemDoseUOMID As %String, ItemFrequenceID As %String, ItemDurationID As %String, ItemInstructionID As %String, ItmLinkDoctor As %String, remark As %String, DHCDocOrderTypeID As %String = "", SampleId As %String = "", ARCOSItemNO As %String = "", OrderPriorRemarksDR As %String = "", DHCDocOrderRecLoc As %String = "", ExpStr As %String = "") As %String
{
	n (ARCOSRowid,ARCIMRowid,ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,remark,DHCDocOrderTypeID,SampleId,ARCOSItemNO,OrderPriorRemarksDR,DHCDocOrderRecLoc,ExpStr)
	set $zt="InsertItemError"
	//设置Flag值区分增加和插入的医嘱项
	s Flag=1
	set ^TEMP("DHCARCOrdSets:InsertOrdItem",$j)=ARCOSRowid_","_ARCIMRowid_","_ItemQty_","_ItemDoseQty_","_ItemDoseUOMID_","_ItemFrequenceID_","_ItemDurationID_","_ItemInstructionID_","_ItmLinkDoctor_","_remark_","_DHCDocOrderTypeID_","_SampleId_","_ARCOSItemNO_","_OrderPriorRemarksDR_","_DHCDocOrderRecLoc_","_ExpStr
	;ARCOSRowid
	q:ARCOSRowid="" -1
	q:$g(^ARCOS(ARCOSRowid))="" -1
	set:$ascii(ItmLinkDoctor)<33 ItmLinkDoctor=""
	set:$ascii(remark)<33 remark=""
	set:$ascii(DHCDocOrderTypeID)<33 DHCDocOrderTypeID=""
    s ItemDoseQty=$P($tr(ItemDoseQty," ",""),"@")	;同频次不同剂量 医嘱套不保存首日例外剂量
    s remark=$tr(remark," ","")
	S ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid)
	i ((ARCOSDateRowid="")!(ARCOSDateRowid="0")){
		 s ARCOSDateRowid=..InsertOrderSetDate(ARCOSRowid)
	}
	//增加的直接付给最大值+1
	i (ARCOSItemNO="") {
		s MaxItemNO=..GetMaxItemNo(ARCOSDateRowid)
		s ARCOSItemNO=MaxItemNO+1 
		s Flag=""
	}
	s MustEnter="",SpeedFlowRate="",FlowRateUnit="",OrderBodyPartLabel="",NotifyClinician="",RemoveCeler="",OrderFreqTimeDoseStr="",OrderFreqWeekStr=""
	if (ARCIMRowid["||"){
		s DHCDocOrderStageID=$p(ExpStr,"^",1)
		s MustEnter=$p(ExpStr,"^",2)
		s ITMPackQtyUomRowId=$p(ExpStr,"^",3)
		s SpeedFlowRate=$p(ExpStr,"^",4)
		s FlowRateUnit=$p(ExpStr,"^",5)
		s OrderBodyPartLabel=$p(ExpStr,"^",6)
		s SkinTest=$p(ExpStr,"^",7)
		s SkinTestActiong=$p(ExpStr,"^",8)
		s NotifyClinician=$p(ExpStr,"^",9)
		s RemoveCeler=$p(ExpStr,"^",10)
		s OrderFreqTimeDoseStr=$P($p(ExpStr,"^",11),"@")
		s OrderFreqDispTimeStr=$p(ExpStr,"^",12)
		&SQL(insert into sqluser.ARC_OrdSetDateItem (ITM_ParRef,ITM_ARCIM_DR,ITM_Qty,ITM_DoseQty,ITM_UOM_DR,ITM_Freq_DR,ITM_Durat_DR,ITM_Instruc_DR,ITM_LinkDoctor,ITM_SerialNo,ITM_RecLoc_DR,ITM_Stage,ITM_PackQtyUom_DR,ITM_SkinTest,ITM_SkinTestAction,
		ITM_Priority_DR,ITM_SampleId,ITM_PriorRemarksDR,ITM_MustEnter,ITM_SpeedFlowRate,ITM_FlowRateUnit_DR,ITM_OrderBodyPartLabel,
		ITM_NotifyClinician,ITM_RemoveCeler,ITM_FreqTimeDoseQtyStr,ITM_FreqWeekStr)
		Values (:ARCOSDateRowid,:ARCIMRowid,:ItemQty,:ItemDoseQty,:ItemDoseUOMID,:ItemFrequenceID,:ItemDurationID,:ItemInstructionID,:ItmLinkDoctor,:ARCOSItemNO,:DHCDocOrderRecLoc,:DHCDocOrderStageID,:ITMPackQtyUomRowId,:SkinTest,:SkinTestActiong,
		:DHCDocOrderTypeID,:SampleId,:OrderPriorRemarksDR,:MustEnter,:SpeedFlowRate,:FlowRateUnit,:OrderBodyPartLabel,
		:NotifyClinician,:RemoveCeler,:OrderFreqTimeDoseStr,:OrderFreqDispTimeStr))
		//插入成功
		i SQLCODE=0{
			 s ItemRowid=$p(%ROWID,$C(1))
			 i ($p(ItemRowid,"||",1))'=""{    //当插入一条医嘱时医嘱向下的序号次序递加
			 	 i Flag'="" s val=..ChangeItemNo(ItemRowid,ARCOSItemNO) //如果是插入的，则将插入位置和比插入值大的都加1
				 s ^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"NOTES",1)=remark
			     /*s $p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",1)=DHCDocOrderTypeID
			     s $p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",2)=$g(SampleId)
			     ;插入附加说明
			     s $p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",3)=$g(OrderPriorRemarksDR)
			 	 ;插入是否必开
			 	 s $p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",4)=$g(MustEnter)
			 	 ;插入输液流速
			 	 s $p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",5)=$g(SpeedFlowRate)
			 	 ;插入流速单位
			 	 s $p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",6)=$g(FlowRateUnit)
			 	 ;插入检查申请单相关信息
			 	 s $p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",7)=$g(OrderBodyPartLabel)
			 	 ;加急标志
			 	 s $p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",8)=$g(NotifyClinician)
				 ;快速例外
				 s $p(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",$p(ItemRowid,"||",3),"DHC"),"^",9)=$g(RemoveCeler)*/
			 }
		}
		else{
			 s ^TEMP("DHCARCOrdSets:InsertOrdItem","error",$j,+$h)=ARCOSDateRowid_","_SQLCODE
		}
	}else{
		//医嘱套嵌套
		&SQL(insert into sqluser.ARC_OrdSetDateOS (OS_ParRef,OS_OrderSet_DR,OS_SerialNo)
		Values (:ARCOSDateRowid,:ARCIMRowid,:ARCOSItemNO))
	}
	Q:'SQLCODE %ROWID
	Q -1
InsertItemError
   set ^TEMP("DHCARCOrdSets:InsertOrdItem","error",$h_"")=$ze
   set $ze=""
   q ""
}

ClassMethod InsertOrderSetDate(ARCOSRowid As %String) As %String
{
	
	s DateFrom=..%SysDate()
	&SQL(Insert into sqluser.ARC_OrdSetDate (DATE_ParRef,DATE_DateFrom) values (:ARCOSRowid,:DateFrom))
	 
	Q:'SQLCODE %ROWID
	Q -1
}

ClassMethod UpdateARCOS(ARCOSRowid As %String, ARCOSCode As %String, ARCOSDesc As %String, ARCOSCatID As %String, ARCOSSubCatID As %String, ARCOSEffectDate As %String, ARCOSEffectDateTo As %String = "") As %String
{
   
   //,ARCOS_EffDateFrom=:ARCOSEffectDate
	&SQL(Update sqluser.ARC_OrdSets set ARCOS_Code=:ARCOSCode,ARCOS_Desc=:ARCOSDesc,ARCOS_OrdCat_DR=:ARCOSCatID,ARCOS_OrdSubCat_DR=:ARCOSSubCatID,ARCOS_EffDateTo=:ARCOSEffectDateTo Where ARCOS_Rowid=:ARCOSRowid)
	Q:'SQLCODE SQLCODE
	Q -1
}

ClassMethod UpdateItem(ARCOSItemRowid As %String, ARCIMRowid As %String, ItemQty As %String, ItemDoseQty As %String, ItemDoseUOMID As %String, ItemFrequenceID As %String, ItemDurationID As %String, ItemInstructionID As %String, ItmLinkDoctor As %String, remark As %String, DHCDocOrderTypeID As %String, SampleID As %String, OrderPriorRemarksDR As %String, DHCDocOrderRecLoc As %String, ExpStr As %String = "") As %String
{
 
  s ARCOSRowid=$P(ARCOSItemRowid,"||",1)  s ITM1=$P(ARCOSItemRowid,"||",2) s ITM3=$P(ARCOSItemRowid,"||",3)
  if (ARCIMRowid["||"){
		  //if (remark'=""){s ^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"NOTES",1)=remark} 
		  //if (DHCDocOrderTypeID'="") s $p(^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"DHC"),"^",1)=DHCDocOrderTypeID
		  s DHCDocOrderStageID=$p(ExpStr,"^",1)
		  s MustEnter=$p(ExpStr,"^",2)
		  s ITMPackQtyUomRowId=$p(ExpStr,"^",3)
		  s SpeedFlowRate=$p(ExpStr,"^",4)
		  s FlowRateUnit=$p(ExpStr,"^",5)
		  s OrderBodyPartLabel=$p(ExpStr,"^",6)
		  s SkinTest=$p(ExpStr,"^",7)
		  s SkinTestActiong=$p(ExpStr,"^",8)
		  s NotifyClinician=$p(ExpStr,"^",9)
		  s RemoveCeler=$p(ExpStr,"^",10)
		  s OrderFreqTimeDoseStr=$p(ExpStr,"^",11)
		  s OrderFreqWeekStr=$p(ExpStr,"^",12)
		  s ^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"NOTES",1)=remark
		  /*s $p(^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"DHC"),"^",1)=DHCDocOrderTypeID
		  s $p(^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"DHC"),"^",3)=OrderPriorRemarksDR
		  s $p(^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"DHC"),"^",2)=$g(SampleID)
		  s $p(^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"DHC"),"^",4)=$g(MustEnter)
		  s $p(^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"DHC"),"^",5)=$g(SpeedFlowRate)
		  s $p(^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"DHC"),"^",6)=$g(FlowRateUnit)
		  s $p(^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"DHC"),"^",7)=$g(OrderBodyPartLabel)
		  s $p(^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"DHC"),"^",8)=$g(NotifyClinician)
		  s $p(^ARCOS(ARCOSRowid,"DATE",ITM1,"ITM",ITM3,"DHC"),"^",9)=$g(RemoveCeler)*/

		 &SQL(Update sqluser.ARC_OrdSetDateItem set ITM_ARCIM_DR=:ARCIMRowid,ITM_Qty=:ItemQty,ITM_DoseQty=:ItemDoseQty,ITM_UOM_DR=:ItemDoseUOMID,
			 ITM_Freq_DR=:ItemFrequenceID,ITM_Durat_DR=:ItemDurationID,ITM_Instruc_DR=:ItemInstructionID,
			 ITM_LinkDoctor=:ItmLinkDoctor,ITM_RecLoc_DR=:DHCDocOrderRecLoc,ITM_Stage=:DHCDocOrderStageID,
			 ITM_PackQtyUom_DR=:ITMPackQtyUomRowId ,ITM_SkinTest=:SkinTest,ITM_SkinTestAction=:SkinTestActiong,
			 ITM_Priority_DR=:DHCDocOrderTypeID,ITM_SampleId=:SampleID,ITM_PriorRemarksDR=:OrderPriorRemarksDR,
			 ITM_MustEnter=:MustEnter,ITM_SpeedFlowRate=:SpeedFlowRate,ITM_FlowRateUnit_DR=:FlowRateUnit,
			 ITM_OrderBodyPartLabel=:OrderBodyPartLabel,ITM_NotifyClinician=:NotifyClinician,ITM_RemoveCeler=:RemoveCeler,
			 ITM_FreqTimeDoseQtyStr=:OrderFreqTimeDoseStr,ITM_FreqWeekStr=:OrderFreqWeekStr
			 Where ITM_Rowid=:ARCOSItemRowid)
	 }else{
		 &SQL(Update sqluser.ARC_OrdSetDateOS set OS_OrderSet_DR=:ARCIMRowid Where OS_Rowid=:ARCOSItemRowid)
	 }
	Q:'SQLCODE SQLCODE
	Q -1
}

ClassMethod GetDHCDocOrderType(EpisodeType As %String = "") As %String
{
	s ret=""
	s rowid=0 f  s rowid=$o(^OECPR(rowid)) q:rowid=""  d
	.s code=$p($g(^OECPR(rowid)),"^",1)
	.s priority=$p($g(^OECPR(rowid)),"^",3)
	.;为0就不显示?因为有些医嘱类型有些医院用不上
	.Q:priority=0
	.Q:(EpisodeType="O")&&((code="OMST")||(code="S")||(code="OUT")||(code="STAT")||(code="PRN")||(code="ONE"))
	.s desc=$p($g(^OECPR(rowid)),"^",2)
	.i ret="" s ret=rowid_$C(1)_code_$C(1)_desc
	.e  s ret=ret_"^"_rowid_$C(1)_code_$C(1)_desc
	q ret
}

Query FindARCOSAlias(ARCOSRowid As %Library.String) As %SQLQuery(CONTAINID = "", ROWSPEC = "Rowid:%String,Desc:%String")
{
	SELECT ALIAS_Rowid,ALIAS_Text FROM sqluser.ARC_Alias Where ALIAS_ARCOS_DR=:ARCOSRowid and ALIAS_Type="ARCOS"
}

Query FindOSItem(ARCOSRowid As %String, QueryFlag As %String) As %Library.Query(CONTAINID = "", ROWSPEC = "ARCIMDesc:%String,ARCOSItemQty:%String,ARCOSItemBillUOM:%String,ARCOSItemDoseQty:%String,ARCOSItemUOM:%String,ARCOSItemFrequence:%String,ARCOSItemDuration:%String,ARCOSItemInstruction:%String,ARCOSItemRowid:%String,ARCIMRowid:%String,ARCOSItemUOMDR:%String,ARCOSItemFrequenceDR:%String,ARCOSItemDurationDR:%String,ARCOSItemInstructionDR:%String,ARCOSItemCatDR:%String,ARCOSItemSubCatDR:%String,ARCOSItemOrderType:%String,ARCOSItmLinkDoctor:%String,Tremark:%String,ARCOSDHCDocOrderType:%String,ARCOSDHCDocOrderTypeDR:%String,SampleID:%String,SampleDesc:%String,ITMSerialNo:%String,NO:%String,OrderPriorRemarksDR:%String,OrderPriorRemarks:%String,DHCDocOrdRecLoc:%String,DHCDocOrdStage:%String,DHCMustEnter:%String,SpeedFlowRate:%String,FlowRateUnit:%String,ValidItemFlag:%String")
{
}

Query LookUpItem(Item As %String, GroupID As %String, OrderPrescType As %String, SearchLimitType As %String = "", ParamARCOSRowid As %Library.String = "", HospID As %String = "") As %Query(CONTAINID = 0, ROWSPEC = "ARCIMDesc:%String:医嘱名称,ArcimRowID:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String:医嘱子类,ItemPrice:%String:价格,HIDDEN:%String:基本药物,HIDDEN:%String:计价单位,HIDDEN:%String:库存数,HIDDEN:%String:打包数,HIDDEN:%String:通用名,HIDDEN:%String:在途数,HIDDEN:%String:收费规定,HIDDEN:%String:医保类别,HIDDEN:%String:自付比例,HIDDEN:%String:接收科室,HIDDEN:%String:代码")
{
}

ClassMethod LookUpItemClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	 // Clean up by purging the temporary node in ^CacheTemp global
	 New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCARCOrdSets","LookUpItem","csyzt",29,"Other")
ClassMethod LookUpItemExecute(ByRef QHandle As %Binary, Item As %String = "", GroupID As %Library.String = "", OrderPrescType As %Library.String = "", SearchLimitType As %Library.String = "", ParamARCOSRowid As %Library.String = "", HospID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	n OEOrderRS
	if (Item=""){
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if OrderPrescType="Other" {
		s Form=%session.Get("LOGON.CTLOCID")_$C(3)_HospID
		set OEOrderRS=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem") 
		d OEOrderRS.Execute(Item,GroupID,"","","","","","","","",%session.Get("LOGON.USERID"),"","",Form,"","1^1")
		Set columns = OEOrderRS.GetColumnCount()
		If $SYSTEM.Status.IsOK(OEOrderRS){
			while (OEOrderRS.Next()){
				s OrderType1=OEOrderRS.GetData(4)
				continue:(SearchLimitType'="")&&(OrderType1'=SearchLimitType)
				//continue:OEOrderRS.GetData(4)="ARCOS"
				s Data=""	
				for i=1:1:columns {
					s $List(Data,i)=OEOrderRS.GetData(i)
				}
				if (OrderType1="ARCIM"){
					s ArcimRowid1=OEOrderRS.GetData(2)
					s ItemCatRowid1=$p($g(^ARCIM(+ArcimRowid1,$p(ArcimRowid1,"||",2),1)),"^",10)
				}else{
					s ArcosRowid1=OEOrderRS.GetData(2)
					s ItemCatRowid1=$p($g(^ARCOS(ArcosRowid1)),"^",9)
					if (ParamARCOSRowid'="") {
						continue:ArcosRowid1=ParamARCOSRowid
						s AllARCOSItemStr=..OpenAllARCOSItem(ArcosRowid1)
						continue:(AllARCOSItemStr'="")&&(("^"_AllARCOSItemStr_"^")[("^"_ParamARCOSRowid_"^"))
					}
				}
				s $List(Data,17)=ItemCatRowid1
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		d OEOrderRS.Close()
		s OEOrderRS=""
	}else{ 
		n OEOrderRS
		if (OrderPrescType["CNMedItem"){
			s LUCategoryDesc="ALL"
		}else{
			s LUCategoryDesc=OrderPrescType
		}
		set OEOrderRS=##class(%ResultSet).%New("web.DHCDocOrderEntryCM:LookUpItem")
		d OEOrderRS.Execute(Item,GroupID,"","","",LUCategoryDesc,"","","","","","","","","","1")
		Set columns = OEOrderRS.GetColumnCount()
		If $SYSTEM.Status.IsOK(OEOrderRS){
			while (OEOrderRS.Next()){
				continue:OEOrderRS.GetData(4)="ARCOS"
				s Data=""	
				for i=1:1:columns {
					s $List(Data,i)=OEOrderRS.GetData(i)
				}
				s ArcimRowid1=OEOrderRS.GetData(2)
				s ItemCatRowid1=$p($g(^ARCIM(+ArcimRowid1,$p(ArcimRowid1,"||",2),1)),"^",10)
				s $List(Data,17)=ItemCatRowid1
				s $List(Data,20)=""
				s $List(Data,21)=OEOrderRS.GetData(20)
				s $List(Data,22)=OEOrderRS.GetData(21)
				s $List(Data,23)=OEOrderRS.GetData(22)
				Set ^CacheTemp(repid,ind)=Data
				Set ind=ind+1
			}
		}
		d OEOrderRS.Close()
		s OEOrderRS=""
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod OpenAllARCOSItem(ARCOSRowid As %String)
{
	d ..CloseGetAllARCOSItem()
	d ..GetAllARCOSItem(ARCOSRowid)
	s AllARCOSItemStr=""
	s count=0
	for {
		s count=$o(^CacheTemp("ARCOIS",$j,count)) Q:count=""
		s ARCOSRowid=$g(^CacheTemp("ARCOIS",$j,count))
		i AllARCOSItemStr=ARCOSRowid
		e  s AllARCOSItemStr=AllARCOSItemStr_"^"_ARCOSRowid
	}
	d ..CloseGetAllARCOSItem()
	Q AllARCOSItemStr
}

ClassMethod GetAllARCOSItem(ARCOSRowid As %String)
{
	n (ARCOSRowid)
	q:$g(ARCOSRowid)=""  
	s ARCOSDateRowid=##class(web.DHCDocOrderEntry).GetOrderSetDate(ARCOSRowid) 
	Q:'ARCOSDateRowid
	s count=$o(^TMP("ARCOIS",$j,""),-1)+1
	s ^CacheTemp("ARCOIS",$j,count)=ARCOSRowid
	;下面是调出医嘱套里的医嘱套?属于嵌套调用
	s it=0 f  s it=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"OS",it)) q:it=""  s s=^(it) d
	.d ..GetAllARCOSItem(+s)
	Q 0
}

ClassMethod CloseGetAllARCOSItem()
{
	K ^CacheTemp("ARCOIS",$j)
}

ClassMethod LookUpItemFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpItemExecute ]
{
	// This fetch method should never have to change. 
	
	// repid - Report ID
	// ind   - sequence index which represents each row
	
	New repid,ind
	
	// Restore QHandle
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		 // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		 // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

// d ##class(web.DHCARCOrdSets).SetARCOSItemNo("1")

// 给医嘱套表所有医嘱项付初值

ClassMethod SetARCOSItemNo(value As %String) As %String
{
	s i=1
	if value="1"
	{
	s ARCOSRowid=0 f  s ARCOSRowid=$O(^ARCOS(ARCOSRowid)) q:ARCOSRowid=""  d 
	.s NO=1
	.s DATEChildsub=0 f  s DATEChildsub=$O(^ARCOS(ARCOSRowid,"DATE",DATEChildsub)) q:DATEChildsub=""  d
	..S item=0 f  s item=$o(^ARCOS(ARCOSRowid,"DATE",DATEChildsub,"ITM",item)) q:item=""  s s=^(item) d
	...S ARCIMRowid=$p(s,"^",1)
    ...s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
    ...s $P(^ARCOS(ARCOSRowid,"DATE",DATEChildsub,"ITM",item),"^",20)=NO s NO=NO+1
    ...s ITMSerialNo=$P(^ARCOS(ARCOSRowid,"DATE",DATEChildsub,"ITM",item),"^",20)
    ...s ^Tempzong1(i)=ARCIMRowid_"^"_ARCIMDesc_"^"_ITMSerialNo_"YY" s i=i+1
 
	}
}

// d ##class(web.DHCARCOrdSets).ChangeItemNo("2428||1||19","4")

// 将比插入项目ARCOSItemNO大的和相等的号码都加1.

ClassMethod ChangeItemNo(ItemRowid As %String, ARCOSItemNO As %String) As %String
{
  //s ^Tempzong11=ItemRowid_"^"_ARCOSItemNO
     i ($p(ItemRowid,"||",1))'=""
	 {    //当插入一条医嘱时医嘱向下的序号次序递加
	 	
	     s sub=0 f  s sub=$O(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",sub)) q:sub=""  d
	 	    .q:sub=$p(ItemRowid,"||",3)
	 	    .s ItemNO=$P(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",sub),"^",20) 
	 	    .i (ItemNO>ARCOSItemNO) s $P(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",sub),"^",20)=ItemNO+1
			.i (ItemNO=ARCOSItemNO) s $P(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",sub),"^",20)=ItemNO+1
	
	}
	q "OK"
}

// d ##class(web.DHCARCOrdSets).ChangeItemNo("2428||1||19","4")

// 找到ARCOSItemNO最大的并返回

// w ##class(web.DHCARCOrdSets).GetMaxItemNo("2454||1||21")

// ---------------------------

ClassMethod GetMaxItemNo(ItemRowid As %String) As %String
{
  s ItemNO=0
  i ($p(ItemRowid,"||",1))'=""{    //当插入一条医嘱时医嘱向下的序号次序递加
     s sub=0 f  s sub=$O(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",sub)) q:sub=""  d
     .s ItemNO1=$P(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"ITM",sub),"^",20) 
     .i ItemNO=0 s ItemNO=ItemNO1
     .i ((ItemNO'=0)&&(ItemNO1>ItemNO)) s ItemNO=ItemNO1
     //医嘱套嵌套
	 s sub=0
	 f  s sub=$O(^ARCOS(+ItemRowid,"DATE",$p(ItemRowid,"||",2),"OS",sub)) q:sub=""  d
	 .s ItemNO1=$P(^ARCOS($p(ItemRowid,"||",1),"DATE",$p(ItemRowid,"||",2),"OS",sub),"^",3)  
	 .i ItemNO=0 s ItemNO=ItemNO1
     .i ((ItemNO'=0)&&(ItemNO1>ItemNO)) s ItemNO=ItemNO1
  }
  q ItemNO
}

/// creator:郭荣勇
/// date:2015-10-23
/// 更新医嘱套项目的序号
ClassMethod UpdateItemSerialNo(ARCOSItemRowid As %String, ItemSerialNo As %String, ArcimId As %String) As %String
{
	n (ARCOSItemRowid,ItemSerialNo,ArcimId)
	if (ArcimId["||"){
		&SQL(Update sqluser.ARC_OrdSetDateItem set ITM_SerialNo=:ItemSerialNo Where ITM_Rowid=:ARCOSItemRowid)
	}else{
		&SQL(Update sqluser.ARC_OrdSetDateOS set OS_SerialNo=:ItemSerialNo Where OS_RowId=:ARCOSItemRowid)
		
	}
	Q SQLCODE
}

/// creator:宋春丽
/// date:2016-06-21
/// 取接收科室
Query GetRecLoc(Arcim As %String) As %Query(CONTAINID = 0, ROWSPEC = "RecLocRowId:%String,RecLocDesc:%String,selected:%Boolean")
{
}

ClassMethod GetRecLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = GetRecLocExecute ]
{
	 // Clean up by purging the temporary node in ^CacheTemp global
	 New repid
	 Set repid=$li(QHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCARCOrdSets","GetRecLoc","1284||1")
ClassMethod GetRecLocExecute(ByRef QHandle As %Binary, Arcim As %String) As %Status
{
	
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
   s OpenForAllHosp=1

   s ret=""
   s ret=..GetLocRecLocByItem(Arcim,OpenForAllHosp)
   if (ret'=""){
	  d OutPutData
	  Set QHandle=$lb(0,repid,0)
      Quit $$$OK
   }
   
   s ItemCat=$P($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10 )
   if (ItemCat="") {
	  Set QHandle=$lb(0,repid,0)
      Quit $$$OK
   }
   
   s ret=..GetLocRecLocByItemCat(ItemCat,OpenForAllHosp)
   if (ret'=""){
	  d OutPutData
	  Set QHandle=$lb(0,repid,0)
      Quit $$$OK
   }
    s OrderCat=$P($g(^ARC("IC",ItemCat)),"^",8)
	if (OrderCat="") {
	  Set QHandle=$lb(0,repid,0)
      Quit $$$OK
	}
	s ret=..GetLocRecLocByCat(OrderCat,OpenForAllHosp)
    if (ret'=""){
	  d OutPutData
	  Set QHandle=$lb(0,repid,0)
      Quit $$$OK
    }
   Set QHandle=$lb(0,repid,0)
   Quit $$$OK
OutPutData
  for i=1:1:$l(ret,$c(2)) {
	   s oneRecLocStr=$p(ret,$c(2),i)
	   s RecLocRowId=$p(oneRecLocStr,$c(1),1)
	   s RecLocDesc=$p(oneRecLocStr,$c(1),2)
	   s DefaultFlag=$p(oneRecLocStr,$c(1),3)
	   if (DefaultFlag="Y") s DefaultFlag=1
	   e  s DefaultFlag=0
	   Do OutputRowRecLoc
  }
OutputRowRecLoc
    set Data=$lb($g(RecLocRowId),$g(RecLocDesc),$g(DefaultFlag))
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetRecLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRecLocExecute ]
{
	// This fetch method should never have to change. 
	
	// repid - Report ID
	// ind   - sequence index which represents each row
	
	New repid,ind
	
	// Restore QHandle
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {
		 // if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else      {
		 // fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	
	// Save QHandle
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetLocRecLocByItem(Arcim As %String, OpenForAllHosp As %String = "") As %String
{
	n (Arcim,OpenForAllHosp)
	s ret="",ret1=""
	s Today=..%SysDate()
	s ToTime=..%SysTime()
	
	//s HospitalID=$P(^CTLOC(EpLoc),"^",22)
	
	s DefaultOrdLocRecLoc="",OrdLocRecLoc="",DefaultNoOrdLocRecLoc="",NoOrdLocRecLoc=""
	s sub=0  f  s sub= $O(^ARCRL(+Arcim,sub))  Q:(sub="")  d 
	. s OrdLoc=$P($g(^ARCRL(+Arcim,sub)),"^", 1)
	. //Q:(EpLoc'=OrdLoc)&&(OrdLoc'="")
	. s TimeFrom=$P($g(^ARCRL(+Arcim,sub)),"^", 5)
	. s TimeTo=$P($g(^ARCRL(+Arcim,sub)),"^", 6)
	. s DateFrom=$P($g(^ARCRL(+Arcim,sub)),"^", 8)
	. s DateTo=$P($g(^ARCRL(+Arcim,sub)),"^", 9)
	. Q:(DateTo'="")&&(DateTo<Today)
	. Q:((TimeFrom'="")&(ToTime<TimeFrom))!((TimeTo'="")&(ToTime>TimeTo))
	. s Default=$P($g(^ARCRL(+Arcim,sub)),"^", 4)
	. s RecLoc=$P($g(^ARCRL(+Arcim,sub)),"^", 2)
	. Q:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(RecLoc)
	. s RecLocDesc=##class(web.DHCDocOrderCommon).GetLocDesc(RecLoc)  
	. s OrderPriority=$P($g(^ARCRL(+Arcim,sub)),"^", 10)
	
	. //s RecLocHospitalID=$P($g(^CTLOC(RecLoc)),"^",22)
	. //Q:(OpenForAllHosp'=1)&&(RecLocHospitalID'=HospitalID)
	
	 . i OrderPriority="" d
	 . . i ret=""  s ret=RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_OrderPriority
	 . . e  d
	 . . .i ret'[(RecLoc_$C(1)_RecLocDesc) s ret=ret_$C(2)_RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_OrderPriority
	 . . i OrdLoc'="" d
	 . . . i Default="Y" d
	 . . . . i DefaultOrdLocRecLoc="" s DefaultOrdLocRecLoc=RecLoc
	 . . . e  d 
	 . . . . i OrdLocRecLoc="" s OrdLocRecLoc=RecLoc
	 . . e  d
	 . . . i Default="Y" d
	 . . . . i DefaultNoOrdLocRecLoc="" s DefaultNoOrdLocRecLoc=RecLoc
	 . . . e  d 
	 . . . . i NoOrdLocRecLoc="" s NoOrdLocRecLoc=RecLoc
	 . e  d
	 . . i $d(recloc(OrderPriority,RecLoc)) d
	 . . . i Default="Y" s recloc(OrderPriority,RecLoc)=RecLoc_$C(1)_RecLocDesc_$C(1)_Default_$C(1)_OrderPriority
	 . . e  s recloc(OrderPriority,RecLoc)=RecLoc_$C(1)_RecLocDesc_$C(1)_Default_$C(1)_OrderPriority
	 
	 ;优先级顺序:默认的有就诊科室,有就诊科室,默认无就诊科室,无接受科室
	 i DefaultOrdLocRecLoc'="" s DefaultRecloc=DefaultOrdLocRecLoc
	 e  d
	 . i OrdLocRecLoc'="" s DefaultRecloc=OrdLocRecLoc
	 . e  d
	 . . i DefaultNoOrdLocRecLoc'="" s DefaultRecloc=DefaultNoOrdLocRecLoc
	 . . e  d
	 . . . i NoOrdLocRecLoc'="" s DefaultRecloc=NoOrdLocRecLoc
	 s priority=0
	 
	 i $d(recloc) {
		 s priority=$O(recloc(0))
		 while ( priority'=""){

			 s FindDefault="N"
			 s recloc=$O(recloc(priority,0))
			 while (recloc'=""){
				S FindDefault=$P(recloc(priority,recloc),$C(1),3)
				i FindDefault="Y" Quit
				s recloc=$O(recloc(priority,recloc))
			 }
			 
			 i FindDefault="N" {
				S recloc=$O(recloc(priority,0))
				S $P(recloc(priority,recloc),$C(1),3)="Y"
			 }
			 s priority=$O(recloc(priority))
		 }
		 
		 s priority=$O(recloc(0))
		 while ( priority'=""){
			s recloc=0  for  Set recloc=$O(recloc(priority,recloc)) Quit:recloc=""  do
				.i ret1="" s ret1=recloc(priority,recloc)
				.e  s ret1=ret1_$C(2)_recloc(priority,recloc)
			 s priority=$O(recloc(priority))
		 }
	 }
	 if ret'="" {
		 s RecLocCount=$LENGTH(ret,$C(2))
		 F i=1:1:RecLocCount {
			 S RecLocStr=$P(ret,$C(2),i)
			 if DefaultRecloc=$P(RecLocStr,$C(1),1) d
			 .s $P(ret,$C(2),i)=$P(RecLocStr,$C(1),1,2)_$C(1)_"Y"_$C(1)_$P(RecLocStr,$C(1),4)
			 e  s $P(ret,$C(2),i)=$P(RecLocStr,$C(1),1,2)_$C(1)_"N"_$C(1)_$P(RecLocStr,$C(1),4)
		 }
		 i ret1'="" s ret=ret1_$C(2)_ret
	 }else{
		 s ret=ret1
	 }

	 Q ret
}

ClassMethod GetLocRecLocByItemCat(ItemCat As %String, OpenForAllHosp As %String = "") As %String
{
	n (ItemCat,OpenForAllHosp)
	s ret="",ret1=""
	s Today=..%SysDate()
	s ToTime=..%SysTime()

	//s HospitalID=$P($g(^CTLOC(EpLoc)),"^",22)
	
	s DefaultOrdLocRecLoc="",OrdLocRecLoc="",DefaultNoOrdLocRecLoc="",NoOrdLocRecLoc=""
	 
	 s rl=0  f  s rl=$O(^ARC("IC",ItemCat,"RL",rl)) q:(rl="")  d
	 . s OrdLoc=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",2)
	 . //Q:(EpLoc'=OrdLoc)&&(OrdLoc'="")
	 . s TimeFrom=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",5)
	 . s TimeTo=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",6)
	 . s DateFrom=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",8)
	 . s DateTo=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",9)
	 . Q:(DateTo'="")&&(DateTo<Today)
	 . Q:((TimeFrom'="")&(ToTime<TimeFrom))!((TimeTo'="")&(ToTime>TimeTo))
	 . s RecLoc=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",3)
	 . Q:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(RecLoc)
	 . s Default=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",4)
	 . s RecLocDesc=##class(web.DHCDocOrderCommon).GetLocDesc(RecLoc)
	 . s OrderPriority=$P($g(^ARC("IC",ItemCat,"RL",rl)),"^",10)
	 . //s RecLocHospitalID=$P(^CTLOC(RecLoc),"^",22)
	 . //Q:(OpenForAllHosp'=1)&&(RecLocHospitalID'=HospitalID)
	 .; 
	 . i OrderPriority="" d
	 . . i ret=""  s ret=RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_OrderPriority
	 . . e  d
	 . . .i ret'[(RecLoc_$C(1)_RecLocDesc) s ret=ret_$C(2)_RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_OrderPriority
	 . . i OrdLoc'="" d
	 . . . i Default="Y" d
	 . . . . i DefaultOrdLocRecLoc="" s DefaultOrdLocRecLoc=RecLoc
	 . . . e  d 
	 . . . . i OrdLocRecLoc="" s OrdLocRecLoc=RecLoc
	 . . e  d
	 . . . i Default="Y" d
	 . . . . i DefaultNoOrdLocRecLoc="" s DefaultNoOrdLocRecLoc=RecLoc
	 . . . e  d 
	 . . . . i NoOrdLocRecLoc="" s NoOrdLocRecLoc=RecLoc
	 . e  d
	 . . i $d(recloc(OrderPriority,RecLoc)) d
	 . . . i Default="Y" s recloc(OrderPriority,RecLoc)=RecLoc_$C(1)_RecLocDesc_$C(1)_Default_$C(1)_OrderPriority
	 . . e  s recloc(OrderPriority,RecLoc)=RecLoc_$C(1)_RecLocDesc_$C(1)_Default_$C(1)_OrderPriority
	 
	 ;优先级顺序:默认的有就诊科室,有就诊科室,默认无就诊科室,无接受科室
	 i DefaultOrdLocRecLoc'="" s DefaultRecloc=DefaultOrdLocRecLoc
	 e  d
	 . i OrdLocRecLoc'="" s DefaultRecloc=OrdLocRecLoc
	 . e  d
	 . . i DefaultNoOrdLocRecLoc'="" s DefaultRecloc=DefaultNoOrdLocRecLoc
	 . . e  d
	 . . . i NoOrdLocRecLoc'="" s DefaultRecloc=NoOrdLocRecLoc
	 s priority=0
	 
	 i $d(recloc) {
		 s priority=$O(recloc(0))
		 while ( priority'=""){

			 s FindDefault="N"
			 s recloc=$O(recloc(priority,0))
			 while (recloc'=""){
				S FindDefault=$P(recloc(priority,recloc),$C(1),3)
				i FindDefault="Y" Quit
				s recloc=$O(recloc(priority,recloc))
			 }
			 
			 i FindDefault="N" {
				S recloc=$O(recloc(priority,0))
				S $P(recloc(priority,recloc),$C(1),3)="Y"
			 }
			 s priority=$O(recloc(priority))
		 }
		 
		 s priority=$O(recloc(0))
		 while ( priority'=""){
			 	s recloc=0  for  Set recloc=$O(recloc(priority,recloc)) Quit:recloc=""  do
				.i ret1="" s ret1=recloc(priority,recloc)
				.e  s ret1=ret1_$C(2)_recloc(priority,recloc)
			 s priority=$O(recloc(priority))
		 }
	 }
	 if ret'="" {
		 s RecLocCount=$LENGTH(ret,$C(2))
		 F i=1:1:RecLocCount {
			 S RecLocStr=$P(ret,$C(2),i)
			 if DefaultRecloc=$P(RecLocStr,$C(1),1) d
			 .s $P(ret,$C(2),i)=$P(RecLocStr,$C(1),1,2)_$C(1)_"Y"_$C(1)_$P(RecLocStr,$C(1),4)
			 e  s $P(ret,$C(2),i)=$P(RecLocStr,$C(1),1,2)_$C(1)_"N"_$C(1)_$P(RecLocStr,$C(1),4)
		 }
		 i ret1'="" s ret=ret1_$C(2)_ret
	 }else{
		 s ret=ret1
	 }
	 Q ret
}

ClassMethod GetLocRecLocByCat(OrderCat As %String, OpenForAllHosp As %String = "") As %String
{
	n (OrderCat,OpenForAllHosp)
	s ret="",ret1=""
	s Today=..%SysDate()
	s ToTime=..%SysTime()
	
	//s HospitalID=$P(^CTLOC(EpLoc),"^",22)
	
	s DefaultOrdLocRecLoc="",OrdLocRecLoc="",DefaultNoOrdLocRecLoc="",NoOrdLocRecLoc=""
	s sub=0  f  s sub=$O(^OEC("ORCAT",OrderCat,"RL",sub)) Q:(sub="")  d
	. s OrdLoc=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 2)
	. //Q:(EpLoc'=OrdLoc)&&(OrdLoc'="")
	. s TimeFrom=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 5)
	. s TimeTo=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 6)
	. s DateFrom=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 8)
	. s DateTo=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 9)
	. Q:(DateTo'="")&&(DateTo<Today)
	. Q:((TimeFrom'="")&(ToTime<TimeFrom))!((TimeTo'="")&(ToTime>TimeTo))
	. s Default=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 4)
	. s RecLoc=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^", 3)
	. Q:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(RecLoc)
	. s RecLocDesc=##class(web.DHCDocOrderCommon).GetLocDesc(RecLoc)  
	. s OrderPriority=$P($g(^OEC("ORCAT",OrderCat,"RL",sub)),"^",10)
	. //s RecLocHospitalID=$P($g(^CTLOC(RecLoc)),"^",22)
	. //Q:(OpenForAllHosp'=1)&&(RecLocHospitalID'=HospitalID)
	
	. i OrderPriority="" d
	. . i ret=""  s ret=RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_OrderPriority
	. . e  d
	. . .i ret'[(RecLoc_$C(1)_RecLocDesc) s ret=ret_$C(2)_RecLoc_$C(1)_RecLocDesc_$C(1)_"N"_$C(1)_OrderPriority
	. . i OrdLoc'="" d
	. . . i Default="Y" d
	. . . . i DefaultOrdLocRecLoc="" s DefaultOrdLocRecLoc=RecLoc
	. . . e  d 
	. . . . i OrdLocRecLoc="" s OrdLocRecLoc=RecLoc
	. . e  d
	. . . i Default="Y" d
	. . . . i DefaultNoOrdLocRecLoc="" s DefaultNoOrdLocRecLoc=RecLoc
	. . . e  d 
	. . . . i NoOrdLocRecLoc="" s NoOrdLocRecLoc=RecLoc
	 . e  d
	 . . i $d(recloc(OrderPriority,RecLoc)) d
	 . . . i Default="Y" s recloc(OrderPriority,RecLoc)=RecLoc_$C(1)_RecLocDesc_$C(1)_Default_$C(1)_OrderPriority
	 . . e  s recloc(OrderPriority,RecLoc)=RecLoc_$C(1)_RecLocDesc_$C(1)_Default_$C(1)_OrderPriority
	 ;优先级顺序:默认的有就诊科室,有就诊科室,默认无就诊科室,无接受科室
	 i DefaultOrdLocRecLoc'="" s DefaultRecloc=DefaultOrdLocRecLoc
	 e  d
	 . i OrdLocRecLoc'="" s DefaultRecloc=OrdLocRecLoc
	 . e  d
	 . . i DefaultNoOrdLocRecLoc'="" s DefaultRecloc=DefaultNoOrdLocRecLoc
	 . . e  d
	 . . . i NoOrdLocRecLoc'="" s DefaultRecloc=NoOrdLocRecLoc
	 
	 i $d(recloc) {
		 s priority=$O(recloc(0))
		 while ( priority'=""){

			 s FindDefault="N"
			 s recloc=$O(recloc(priority,0))
			 while (recloc'=""){
				S FindDefault=$P(recloc(priority,recloc),$C(1),3)
				i FindDefault="Y" Quit
				s recloc=$O(recloc(priority,recloc))
			 }
			 
			 i FindDefault="N" {
				S recloc=$O(recloc(priority,0))
				S $P(recloc(priority,recloc),$C(1),3)="Y"
			 }
			 s priority=$O(recloc(priority))
		 }
		 
		 s priority=$O(recloc(0))
		 while ( priority'=""){
			s recloc=0  for  Set recloc=$O(recloc(priority,recloc)) Quit:recloc=""  do
				.i ret1="" s ret1=recloc(priority,recloc)
				.e  s ret1=ret1_$C(2)_recloc(priority,recloc)
			 
			 s priority=$O(recloc(priority))
		 }
	 }
	 if ret'="" {
		 s RecLocCount=$LENGTH(ret,$C(2))
		 F i=1:1:RecLocCount {
			 S RecLocStr=$P(ret,$C(2),i)
			 if DefaultRecloc=$P(RecLocStr,$C(1),1) d
			 .s $P(ret,$C(2),i)=$P(RecLocStr,$C(1),1,2)_$C(1)_"Y"_$C(1)_$P(RecLocStr,$C(1),4)
			 e  s $P(ret,$C(2),i)=$P(RecLocStr,$C(1),1,2)_$C(1)_"N"_$C(1)_$P(RecLocStr,$C(1),4)
		 }
		 i ret1'="" s ret=ret1_$C(2)_ret
	 }else{
		 s ret=ret1
	 }

	 Q ret
}

ClassMethod GetLocRecLoc(Arcim As %String, OpenForAllHosp As %String = "") As %String
{
	n ret
	s ret=""
    Q:Arcim="" ret
	s ret=..GetLocRecLocByItem(Arcim,OpenForAllHosp)
	Q:ret'="" ret
	;
	s ItemCat=$P($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10 )
	Q:ItemCat="" ""
	s ret=..GetLocRecLocByItemCat(ItemCat,OpenForAllHosp)
	Q:ret'="" ret

	s OrderCat=$P($g(^ARC("IC",ItemCat)),"^",8)
	Q:OrderCat="" ""
	s ret=..GetLocRecLocByCat(OrderCat,OpenForAllHosp)

	Q ret
}

ClassMethod CheckARCOSItemRecLoc(PassRecLocStr As %String, ARCOSOrdRecLocDR As %String) As %String
{
	Q:PassRecLocStr="" ""
	/*if (PassRecLocStr="") {
		s ARCOSOrdRecLocDesc=##class(web.DHCDocOrderCommon).GetLocDesc(ARCOSOrdRecLocDR)
		s PassRecLocStr=PassRecLocStr_$c(2)_ARCOSOrdRecLocDR_$c(1)_ARCOSOrdRecLocDesc_$c(1)_"Y"_$c(1)_""
		Q PassRecLocStr
	}*/
	Set langid=..%LanguageID()
	s ret=""
	s Find=0
	s RecLocCount=$LENGTH(PassRecLocStr,$C(2))
	F i=1:1:RecLocCount {
		S RecLocStr=$P(PassRecLocStr,$C(2),i)
		s ReclocRowId=$P(RecLocStr,$C(1),1)
		continue:'##class(DHCDoc.DHCDocConfig.LocExt).LocActive(ReclocRowId)
		s ReclocDesc=$P(RecLocStr,$C(1),2)
		s ReclocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",ReclocDesc,langid)
		s Default=$P(RecLocStr,$C(1),3)
		s OrderPriority=$P(RecLocStr,$C(1),4)
		if (ReclocRowId=ARCOSOrdRecLocDR){
			s Find=1
			s Default="Y"
			if ret="" {
				s ret=ReclocRowId_$c(1)_ReclocDesc_$c(1)_Default_$c(1)_$P(RecLocStr,$C(1),4,*)
			}else{
				s ret=ret_$C(2)_ReclocRowId_$c(1)_ReclocDesc_$c(1)_Default_$c(1)_$P(RecLocStr,$C(1),4,*)
			}
		}else{
			s Default="N"
			if ret="" {
				s ret=ReclocRowId_$c(1)_ReclocDesc_$c(1)_Default_$c(1)_$P(RecLocStr,$C(1),4,*)
			}else{
				s ret=ret_$C(2)_ReclocRowId_$c(1)_ReclocDesc_$c(1)_Default_$c(1)_$P(RecLocStr,$C(1),4,*)
			}
		}
	}
	if (Find=0){
		Q PassRecLocStr
	}
	/*if (Find=0){
		 s ARCOSOrdRecLocDesc=##class(web.DHCDocOrderCommon).GetLocDesc(ARCOSOrdRecLocDR)
		 s PassRecLocStr=PassRecLocStr_$c(2)_ARCOSOrdRecLocDR_$c(1)_ARCOSOrdRecLocDesc_$c(1)_"N"_$c(1)_""
		 Q PassRecLocStr
	}*/
	Q ret
}

/// 验证医嘱套中关联序号是否存在重复
/// 验证是否能进行关联
/// 空 可关联 
/// w ##class(web.DHCARCOrdSets).ItmLinkUnique(3814,"2.1","","2353||1")
ClassMethod ItmLinkUnique(ARCOSRowid, ItmLinkDoctor, ARCOSItemRowid, ARCIMRowid)
{
	s ^tempscl("ItmLinkUnique")=ARCOSRowid_","_ItmLinkDoctor_","_ARCOSItemRowid_","_ARCIMRowid
	s Msg="",MainArcosRowid=""
	q:(ARCOSRowid="")!(ItmLinkDoctor="") Msg
	S ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid)
	Q:ARCOSDateRowid=0 Msg
	Set langid=..%LanguageID()
	s ArcosId=+ARCOSDateRowid
	s ArcosSub=$p(ARCOSDateRowid,"||",2)
	s ItemChild=$p(ARCOSItemRowid,"||",3)
	s ItmSub=0 f  s ItmSub=$o(^ARCOS(ArcosId,"DATE",ArcosSub,"ITM",ItmSub)) q:(ItmSub="")!(Msg'="")  d
	.q:(ItemChild=ItmSub)&&(ItemChild'="")
	.s LinkNo=$p(^ARCOS(ArcosId,"DATE",ArcosSub,"ITM",ItmSub),"^",14)
	.i $p(ItmLinkDoctor,".",1)=LinkNo s MainArcosRowid=ArcosId_"||"_ArcosSub_"||"_ItmSub
	.q:LinkNo'=ItmLinkDoctor
	.s Msg=..%Translate("udhcfavitem.edit.newedit.csp","关联序号已存在!",langid)
	if (MainArcosRowid'="")&&(ItmLinkDoctor["."){
		s MainARCIMRowId=$p($g(^ARCOS(ArcosId,"DATE",ArcosSub,"ITM",$p(MainArcosRowid,"||",3))),"^",1)
		s MainItemCatRowid=$p($g(^ARCIM(+MainARCIMRowId,$p(MainARCIMRowId,"||",2),1)),"^",10)
		s MainOrderType=$P(^ARC("IC",MainItemCatRowid),"^",7)
		s MainPHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(MainItemCatRowid,"",MainARCIMRowId)
		s SubARCIMRowId=ARCIMRowid
		s SubItemCatRowid=$p($g(^ARCIM(+SubARCIMRowId,$p(SubARCIMRowId,"||",2),1)),"^",10)
		s SubOrderType=$P(^ARC("IC",SubItemCatRowid),"^",7)
		s SubPHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(SubItemCatRowid,"",SubARCIMRowId)
		s SubARCIMDesc=$p($g(^ARCIM(+SubARCIMRowId,$p(SubARCIMRowId,"||",2),1)),"^",2)
		s SubARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",SubARCIMDesc,langid)
		if (MainOrderType'="R")&&(MainPHPrescType'="4"){
			if (SubOrderType="R")||(SubPHPrescType="4"){
				s Msg=SubARCIMDesc_..%Translate("udhcfavitem.edit.newedit.csp","子医嘱必须选择频次和疗程,不能关联!",langid)
			}
		}
		//可选择用法的非药品子分类
		s inputInstrNotDrugCat=..%GetConfig("SelectInstrNotDrugCat")
		s inputInstrNotDrugCat="^"_inputInstrNotDrugCat_"^"
		if (MainOrderType'="R")&&(inputInstrNotDrugCat'[("^"_MainItemCatRowid_"^")){
			if (SubOrderType="R")||(inputInstrNotDrugCat[("^"_SubItemCatRowid_"^")){
				s Msg=SubARCIMDesc_..%Translate("udhcfavitem.edit.newedit.csp","子医嘱必须选择用法,不能关联!",langid)
			}
		}
		
	}
	q Msg
}

/// 获取医嘱最大关联数
ClassMethod GetArcosMaxLinkSeqNo(ARCOSRowid As %String)
{
	q:ARCOSRowid="" -1
	S ARCOSDateRowid=..GetOrderSetDate(ARCOSRowid)
	q:((ARCOSDateRowid="")!(ARCOSDateRowid="0")) -1
	s MaxLinkSeqNo=-1 
	s ItmSub=0 f  s ItmSub=$o(^ARCOS(+ARCOSDateRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",ItmSub)) q:ItmSub=""  d
	.s LinSeqNo=+$p(^ARCOS(+ARCOSDateRowid,"DATE",$p(ARCOSDateRowid,"||",2),"ITM",ItmSub),"^",14)
	.s LinSeqNo=$p(LinSeqNo,".",1)
	.s:LinSeqNo>MaxLinkSeqNo MaxLinkSeqNo=LinSeqNo
	Q MaxLinkSeqNo
}

ClassMethod CalFreqTimeDoseQtyStr(ITMFreqTimeDoseQtyStr As %String) As %String
{
	Q:ITMFreqTimeDoseQtyStr="" ""
	s FreqTimeDoseQtyStr=""
	for i=1:1:$l(ITMFreqTimeDoseQtyStr,"!") {
		s oneStr=$p(ITMFreqTimeDoseQtyStr,"!",i)
		s DoseQty=$p(oneStr,"$",2)
		i FreqTimeDoseQtyStr="" s FreqTimeDoseQtyStr=DoseQty
		e  s FreqTimeDoseQtyStr=FreqTimeDoseQtyStr_"-"_DoseQty
	}
	Q FreqTimeDoseQtyStr
}

ClassMethod CalFreqWeekStr(ITMFreqWeekStr As %String) As %String
{
	Q:ITMFreqWeekStr=""
	s OrderFreqWeekStr=""
	for i=1:1:$l(ITMFreqWeekStr,$C(1)) {
		s oneStr=$p(ITMFreqWeekStr,$C(1),i)
		s DispWeek=$p(oneStr,$C(2),2)
		i OrderFreqWeekStr="" s OrderFreqWeekStr=DispWeek
		e  s OrderFreqWeekStr=OrderFreqWeekStr_""_DispWeek
	}
	Q OrderFreqWeekStr
}

/// 查询医嘱大类
Query ordcatlookup(desc As %String, HospId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod ordcatlookupExecute(ByRef qHandle As %Binary, desc As %String, HospId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	Set langid=..%LanguageID()
	if (HospId="") set HospId=%session.Get("LOGON.HOSPID")
	set desc=$$ALPHAUP^SSUTIL4(desc)
	
	set rowId=0
	while($o(^OEC("ORCAT",rowId))) {
		set rowId=$o(^OEC("ORCAT",rowId))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("OEC_OrderCategory", rowId, HospId)
		continue:(showFlag="N")
		set cateData=$g(^OEC("ORCAT",rowId))
		continue:(cateData="")
		set cateDesc=$p(cateData,"^",2)
		set aliasExistFlag=##class(DHCDoc.Util.Base).CheckAliasByTableName("OEC_OrderCategory", rowId, desc)
		continue:((desc'="")&&($$ALPHAUP^SSUTIL4(cateDesc)'[desc)&&('aliasExistFlag))
		Set cateDesc= ##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc",cateDesc,langid)
		do OutputOrdCat
	}
 	
	quit $$$OK
    
OutputOrdCat
	set Data=$lb(rowId,cateDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 查询医嘱子类
Query ordsubcatlookup(ordCatId As %String, desc As %String, HospId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod ordsubcatlookupExecute(ByRef qHandle As %Binary, ordCatId As %String, desc As %String, HospId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	Set langid=..%LanguageID()
 	if (HospId="") set HospId=%session.Get("LOGON.HOSPID")
 	if (desc'="") set desc=$$ALPHAUP^SSUTIL4(desc)
	
	set rowId=0
	while($o(^ARC("IC",rowId))) {
		set rowId=$o(^ARC("IC",rowId))
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat", rowId, HospId)
		continue:(showFlag="N")
		set arcicData=$g(^ARC("IC",rowId))
		continue:(arcicData="")
		set ordCatDR=$p(arcicData,"^",8)
		continue:((ordCatId'="")&&(ordCatId'=ordCatDR))
		set arcicDesc=$p(arcicData,"^",2)
		set aliasExistFlag=##class(DHCDoc.Util.Base).CheckAliasByTableName("ARC_ItemCat", rowId, desc)
		continue:(desc'="")&&($$ALPHAUP^SSUTIL4(arcicDesc)'[desc)&&('aliasExistFlag)
		Set arcicDesc= ##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",arcicDesc,langid)
		do OutputSubcat
	}
	
	quit $$$OK
    
OutputSubcat
	set Data=$lb(rowId,arcicDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query FindOrdForHUI(Cat As %String, SubCat As %String, OrderStatus As %String, Alias As %String, Desc As %String, type As %String, SessionStr As %String = "", ExptStr As %String = "") As %Query(ROWSPEC = "ordtype2,ordchildtype,ordname2,isARCOS,OrdAlias1,ordprice2,lj,DrgGdesc,ordcode,ordExternalCode,ordExternalDesc,id,tjob,ArcItmLimitInfo")
{
}

ClassMethod FindOrdForHUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrdForHUIExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOrdForHUIClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrdForHUIExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCARCOrdSets","FindOrdForHUI","","","0","YZT","","All","17331^28^80^2^^20^62815")
ClassMethod FindOrdForHUIExecute(ByRef qHandle As %Binary, Cat As %String, SubCat As %String, OrderStatus As %String, Alias As %String, Desc As %String, type As %String, SessionStr As %String = "", ExptStr As %String = "") As %Status
{
	s ^tmp("FindOrdForHUIExecute")=$LB(Cat, SubCat, OrderStatus, Alias, Desc, type, SessionStr, ExptStr)
	Set repid=$I(^CacheTemp)
	kill ^TMP("UDHCJFOrdPriceSearch")
	kill ^TMP("UDHCJFOrdPriceSearch2",$j)
	If $g(ind)="" Set ind=1
	Set langid=..%LanguageID()
	s HospId=$P(SessionStr,"^",4)
    s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("ARC_ItmMast",HospId)
	s ordcode="",ordname2="",ordtype2="",ordprice2="",arcim="",itmname="",itmnum="",itmprice="",ordchildtype="",OrdAlias1="",DrgGdesc="" ,ordExternalCode="", ordExternalDesc=""
	s ORCATDesc=""
	s ORSUBCATDesc=""
	
	if Cat'="" s ORCATDesc= $p(^OEC("ORCAT",Cat),"^",2) ;$$ALPHAUP^SSUTIL4(Cat)
	if SubCat'="" s ORSUBCATDesc=$p(^ARC("IC",SubCat),"^",2) ;$$ALPHAUP^SSUTIL4(SubCat)
	s ORCATDesc=$$ALPHAUP^SSUTIL4(ORCATDesc)
	s ORSUBCATDesc=$$ALPHAUP^SSUTIL4(ORSUBCATDesc)
	s OrdNameDesc=$$ALPHAUP^SSUTIL4(Desc)
	s OrdAliasDesc=$$ALPHAUP^SSUTIL4(Alias)
	
    s PHCCatID=$p(ExptStr,"^",1)    ;药学分类ID
	s UserID=$P(SessionStr,"^",1)
	s LocId=$P(SessionStr,"^",3)
	k ArrArc
	if (type="ARCIM"){
		//只查询医嘱项
		d ARCIMList
	}elseif(type="ARCOS"){
		//只查询医嘱套
		d ARCOSList
	}else{
		//查询全部
		d ARCIMList
		d ARCOSList
	}
	kill ^TMP("UDHCJFOrdPriceSearch2",$j)
	Set qHandle=$lb(0,repid,0)
    quit $$$OK
OutputRow1
	set tjob=$j
	q:$d(^TMP("UDHCJFOrdPriceSearch2",$j,arcitmrow))
	s ^TMP("UDHCJFOrdPriceSearch2",$j,arcitmrow)=1
	
    set Data=$lb(ordtype2,ordchildtype,ordname2,isARCOS,OrdAlias1,ordprice2,"",DrgGdesc,ordcode,ordExternalCode,ordExternalDesc,arcitmrow,tjob,ArcItmLimitInfo)
 	Set ^CacheTemp(repid,ind)=Data
 	//Set ^TMP("UDHCJFOrdPriceSearch",$j,ind)=$g(ordcode)_"^"_$g(ordname2)_"^"_$g(ordtype2)_"^"_$g(ordprice2)_"^"_$g(arcitmrow)_"^"_$g(itmname)_"^"_$g(itmnum)_"^"_$g(itmprice)_"^"_$g(ordchildtype)_"^"_$g(OrdAlias1)_"^"_$g(DrgGdesc)_"^"_$g(itmcode)_"^"_$g(ordExternalCode)_"^"_$g(ordExternalDesc)
 	Set ind=ind+1
	quit
ARCIMList
	if (ORCATDesc'=""){
		s ORSUBCATRowIdStr=""
		i ORSUBCATDesc'="" {
			s ORSUBCATRowId=0
			for {
				s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,ORSUBCATRowId)) Q:ORSUBCATRowId
				i ORSUBCATRowIdStr="" s ORSUBCATRowIdStr=ORSUBCATRowId
				else  s ORSUBCATRowIdStr=ORSUBCATRowIdStr_"^"_ORSUBCATRowId
			}
			i ORSUBCATRowIdStr'="" s ORSUBCATRowIdStr="^"_ORSUBCATRowIdStr_"^"	
		}
		s ORCATRowId=0
		for {
			s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,ORCATRowId)) Q:ORCATRowId=""
			s ARCICRowId=0
			for {
				s ARCICRowId=$o(^ARC("IC",0,"OrdCat",ORCATRowId,ARCICRowId)) Q:ARCICRowId=""
				continue:(ORSUBCATRowIdStr'="")&&(ORSUBCATRowIdStr'[("^"_ARCICRowId_"^"))
				s arcrow="0" 
				for {
					 s arcrow=$o(^ARCIM(0,"ARCIC_DR",ARCICRowId,arcrow)) q:arcrow=""
					 s sub=$o(^ARCIM(0,"ARCIC_DR",ARCICRowId,arcrow,""))
					 s arcitmrow=arcrow_"||"_sub
					 d oneARCIMLIst(arcitmrow)
				}
			}
		}
		/*s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
		s arccat=""  f  s arccat=$o(^ARCIM(0,"ARCIC_DR",arccat)) q:arccat=""  d
		.s oeccat=$p(^ARC("IC",arccat),"^",8)
		.q:(oeccat'=ORCATRowId)
		.s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow)) q:arcrow=""  d
		..s sub=$o(^ARCIM(0,"ARCIC_DR",arccat,arcrow,""))
		..s ORSUBCATRowId=""
		..i ORSUBCATDesc'="" s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
		..s arcitmcat=$p(^ARCIM(arcrow,sub,1),"^",10)
		..q:((arcitmcat'=ORSUBCATRowId)&(ORSUBCATRowId'=""))
		..s arcitmrow=arcrow_"||"_sub
		..d oneARCIMLIst(arcitmrow)*/
		quit
	}
	if (ORSUBCATDesc'=""){
		s ARCICRowId=0
		for {
			s ARCICRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,ARCICRowId)) Q:ARCICRowId=""
			s arcrow="0" 
			for {
				 s arcrow=$o(^ARCIM(0,"ARCIC_DR",ARCICRowId,arcrow)) q:arcrow=""
				 s sub=$o(^ARCIM(0,"ARCIC_DR",ARCICRowId,arcrow,""))
				 s arcitmrow=arcrow_"||"_sub
				 d oneARCIMLIst(arcitmrow)
			}
		}
		/*s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
		s arcsubcat=""  f  s arcsubcat=$o(^ARCIM(0,"ARCIC_DR",arcsubcat)) q:arcsubcat=""  d
		.q:(arcsubcat'=ORSUBCATRowId)
		.s arcrow="0" f  s arcrow=$o(^ARCIM(0,"ARCIC_DR",arcsubcat,arcrow)) q:arcrow=""  d
		..s sub=$o(^ARCIM(0,"ARCIC_DR",arcsubcat,arcrow,""))
		..s arcitmrow=arcrow_"||"_sub
		..q:arcitmrow=""
		..d oneARCIMLIst(arcitmrow)*/
		quit
	}
	if (OrdAliasDesc'=""){
		k ^CHHTEMP("ALIASBJ")
		s OrdAliasDesc=$g(OrdAliasDesc)
		s tempOrdAlias=""
		s id="0" f  s id=$o(^ARC("ALIAS",id)) q:id=""  d
		.s symbo=0
		.s text=$p(^ARC("ALIAS",id),"^",6)
		.s text=$$ALPHAUP^SSUTIL4(text)
		.q:(text '[ OrdAliasDesc)
		.s AliasType=$p(^ARC("ALIAS",id),"^",5)
		.q:AliasType'="ARCIM"
		.s arcitmrow=$p(^ARC("ALIAS",id),"^",1)
		.q:arcitmrow=""
		.d oneARCIMLIst(arcitmrow)
		quit
	}
	s id1=0 f  s id1=$o(^ARCIM(id1)) q:id1=""  d
	.s id2=0 f  s id2=$o(^ARCIM(id1,id2)) q:id2=""  d
	..s arcitmrow=id1_"||"_id2
	..d oneARCIMLIst(arcitmrow)
	quit
oneARCIMLIst(arcitmrow)
	Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",arcitmrow,DefHospId)="N"
	Q:'($d(^ARCIM(+arcitmrow,$p(arcitmrow,"||",2),1)))
	q:$d(ArrArc(arcitmrow))
	s valFlag=$$valrownew(arcitmrow)
	Quit:(valFlag)&&(OrderStatus=1)
	Quit:('valFlag)&&(OrderStatus=2)
    s ExitPHCCatID=0
    s OrderType=##class(web.DHCDocOrderCommon).GetOrderType(arcitmrow)
    if OrderType="R"{
        s InciID=##class(web.DHCDocOrderEntry).GetINCI(+arcitmrow)  
        s PhaCatAllstr=##class(web.DHCST.Common.DrugInfoCommon).GetPhaCatAll(InciID)
        s PhaCatAlls=$p(PhaCatAllstr,"^",1)
        s ExitPHCCatID=##class(web.DHCST.Common.DrugInfoCommon).CheckNewCatId(PHCCatID,PhaCatAlls)
    }
    Quit:(PHCCatID'="")&(ExitPHCCatID=0) 
    s ordname2=$p(^ARCIM(+arcitmrow,1,1),"^",2)
	s ordname2=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ordname2,langid)
	q:(ordname2'[OrdNameDesc)&&(OrdNameDesc'="")
	s ordOnItOwn=$p($g(^ARCIM(+arcitmrow,1,7)),"^",13)
    q:$g(ordOnItOwn)="N"
	s lei=$p(^ARCIM(+arcitmrow,1,1),"^",10)
	if (ORSUBCATDesc'=""){
		s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
		q:(ORSUBCATRowId'="")&&(ORSUBCATRowId'=lei)
	}
	i lei'="" s ordchildtype=$p(^ARC("IC",lei),"^",2)
	Set ordchildtype= ##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",ordchildtype,langid)
	s daleicode=$p(^ARC("IC",lei),"^",8)
	i daleicode'="" s ordtype2=$p(^OEC("ORCAT",daleicode),"^",2)
	Set ordtype2= ##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc",ordtype2,langid)
	s arcitmrow=$g(arcitmrow)
	s i=0,text="",AllAlias=""
	s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCIM",arcitmrow,aid))  q:aid=""  d
	.s tmpalias=$p(^ARC("ALIAS",aid),"^",6)
	.s tmpalias=$$ALPHAUP^SSUTIL4(tmpalias)
	.i AllAlias="" s AllAlias=tmpalias
	.e  s AllAlias=AllAlias_"/"_tmpalias
	.q:(tmpalias '[ OrdAliasDesc)&&(OrdAliasDesc'="")
	.i text'=""  d
	..s text=text_"/"_tmpalias
	.e  d
	..s text=tmpalias
	q:text=""
	s text=AllAlias
	s ArrArc(arcitmrow)=arcitmrow
	s OrdAlias1=$g(text)
    s DrgGdr="",DrgGdesc="",DrgFormRowid="",DrgMastRowid=""
	s DrgFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(arcitmrow)
	i DrgFormRowid'="" d
	.s DrgMastRowid=$p(DrgFormRowid,"||",1)
	i DrgMastRowid'="" d
	.i $d(^PHCD(DrgMastRowid,4)) d
	..s DrgGdr=$p($g(^PHCD(DrgMastRowid,4)),"^",1)
	..i $g(DrgGdr)'="" s DrgGdesc=$p($g(^PHCGE("GE",DrgGdr)),"^",2)
	..Set DrgGdesc= ##class(User.PHCGeneric).GetTranByDesc("PHCGEName",DrgGdesc,langid)
	s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",arcitmrow,+$H,"","","","",HospId)
	s ordprice2=$j($p(tmpprice,"^",1),3,6)
	s ordExternalCode="",ordExternalDesc=""
	s chl="" f  s chl=$o(^ARCIM(+arcitmrow,1,"EXT",chl)) q:chl=""  d
	.s tod=$p($g(^ARCIM(+arcitmrow,1,"EXT",chl)),"^",2)
	.q:(tod'="")&(tod<+$h)
	.s ordExternalCode=$p($g(^ARCIM(+arcitmrow,1,"EXT",chl)),"^",4)
	.s ordExternalDesc=$p($g(^ARCIM(+arcitmrow,1,"EXT",chl)),"^",6)
	s ordcode=$p(^ARCIM(+arcitmrow,1,1),"^",1)
	s isARCOS="No",price=0
	s ArcItmLimitInfo=..GetArcItmLimitInfo(arcitmrow, "", SessionStr)
	//ordtype2,ordchildtype,ordname2,isARCOS,OrdAlias1,ordprice2,"",DrgGdesc,ordcode,ordExternalCode,ordExternalDesc,arcitmrow
	do OutputRow1
	quit
ARCOSList
    Quit:(PHCCatID'="")
	if (ORCATDesc'=""){
		s ORCATRowId=$o(^OEC("ORCAT",0,"Desc",ORCATDesc,""))
		if (ORCATRowId="") quit
		s ARCOSRowId=0
		f  s ARCOSRowId=$o(^ARCOS(0,"OrdCat",ORCATRowId,ARCOSRowId)) q:ARCOSRowId=""  d
		.d oneARCOSList(ARCOSRowId)
		quit
	}
	if (ORSUBCATDesc'=""){
		s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
		if ORSUBCATRowId="" quit
		s ARCOSRowId=0
		f  s ARCOSRowId=$o(^ARCOS(0,"ItemCat",ORSUBCATRowId,ARCOSRowId)) q:ARCOSRowId=""  d
		.d oneARCOSList(ARCOSRowId)
		quit
	}
	if (OrdAliasDesc'=""){
		s AliasText=$o(^ARC("ALIAS",0,"Desc",OrdAliasDesc),-1)
		f  s AliasText=$o(^ARC("ALIAS",0,"Desc",AliasText)) q:(AliasText="")!(AliasText'[OrdAliasDesc)  d
		.s ALiasDesc=""
		.f  s ALiasDesc=$o(^ARC("ALIAS",0,"Desc",AliasText,ALiasDesc))  q:ALiasDesc=""  d
		..s AliasRowID=""
		..f  s AliasRowID=$o(^ARC("ALIAS",0,"Desc",AliasText,ALiasDesc,AliasRowID))  q:AliasRowID=""  d
		...q:$d(^ARC("ALIAS",AliasRowID))=0
		...s AliasType=$p(^ARC("ALIAS",AliasRowID),"^",5)
		...q:AliasType'="ARCOS"
		...s ARCOSRowID=$p(^ARC("ALIAS",AliasRowID),"^",2)
		...d oneARCOSList(ARCOSRowID)
		//模糊检索需要屏蔽此处代码退出
		//quit
	}
	if (OrdNameDesc'=""){
		s desc=$o(^ARCOS(0,"Desc",OrdNameDesc),-1)
		f  s desc=$o(^ARCOS(0,"Desc",desc)) q:(desc="")||(desc'[OrdNameDesc)  d
		.s ARCOSRowID=""
		.f  s ARCOSRowID=$o(^ARCOS(0,"Desc",desc,ARCOSRowID)) q:(ARCOSRowID="")  d
		..d oneARCOSList(ARCOSRowID)
		//模糊检索需要屏蔽此处代码退出
		//quit
	}
	s ARCOSRowID=""
	f  s ARCOSRowID=$o(^ARCOS(ARCOSRowID)) q:ARCOSRowID=""  d
	.d oneARCOSList(ARCOSRowID)
	quit
oneARCOSList(ARCOSRowId)
	s FavRowId=$o(^DHCFavItems(0,"ItemRowid",ARCOSRowId,""))
	q:FavRowId=""
	;医嘱套使用院区,非本院区不可见
	s FavUseHospDr=$p($g(^DHCFavItems(FavRowId)),"^",11)
	i (FavUseHospDr'=HospId) s find=1 Q
	s valFlag=$$valarcosnew(ARCOSRowId)
	Quit:((valFlag)&&(OrderStatus=1))
	Quit:((valFlag=0)&&(OrderStatus=2))
	s FavHospDr=$p(^DHCFavItems(FavRowId),"^",9)
	s FavUserDr=$p(^DHCFavItems(FavRowId),"^",2)
	s FavDepDr=$p(^DHCFavItems(FavRowId),"^",4)
	q:(FavHospDr'="")&&(FavHospDr'=HospId)
	q:(FavUserDr'="")&&(FavUserDr'=UserID)
	q:(FavDepDr'="")&&(FavDepDr'=LocId)
	s ARCOSDateRowid=..GetOrderSetDate(ARCOSRowId) 
	q:'ARCOSDateRowid
	s ordname2=$p(^ARCOS(ARCOSRowId),"^",2)
	q:($$ALPHAUP^SSUTIL4(ordname2)'[OrdNameDesc)&&(OrdNameDesc'="")
	s ARCOSPrice=0
	s item=0 f  s item=$o(^ARCOS(ARCOSRowId,"DATE",ARCOSDateRowid,"ITM",item)) q:item=""  s s=^(item) d
	.s ARCIMRowid=$p(s,"^",1)
	.q:..ValARCItem(ARCIMRowid)
	.s ARCOSItemQty=$p(s,"^",2)
	.if ARCOSItemQty="" s ARCOSItemQty=1
	.s tmpprice=##class(web.UDHCJFPRICE).GetOrderPrice("","",ARCIMRowid,+$H,"","","","",HospId)
	.s ordprice2=$j($p(tmpprice,"^",1),3,2)
	.s ARCOSPrice=ARCOSPrice+(ordprice2*ARCOSItemQty)
	
	//ordtype2,ordchildtype,ordname2,isARCOS,OrdAlias1,ordprice2,"",DrgGdesc,ordcode,ordExternalCode,ordExternalDesc,arcitmrow
	s ARCOSOrdCatDR=$p(^ARCOS(ARCOSRowId),"^",8)
	s ordtype2=$p(^OEC("ORCAT",ARCOSOrdCatDR),"^",2)
	s ARCOSItemTypeDR=$p(^ARCOS(ARCOSRowId),"^",9)
	s ordchildtype=$p(^ARC("IC",ARCOSItemTypeDR),"^",2)
	if (ORSUBCATDesc'=""){
		s ORSUBCATRowId=$o(^ARC("IC",0,"Desc",ORSUBCATDesc,""))
		q:(ORSUBCATRowId'="")&&(ORSUBCATRowId'=ARCOSItemTypeDR)
	}
	Set ordchildtype= ##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",ordchildtype,langid)
	Set ordtype2= ##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc",ordtype2,langid)
	s isARCOS="Yes"
	s i=0,text="",AllAlias=""
	s aid="0" f  s aid=$o(^ARC("ALIAS",0,"ARCOS",ARCOSRowId,aid))  q:aid=""  d
	.s tmpalias=$p(^ARC("ALIAS",aid),"^",6)
	.s tmpalias=$$ALPHAUP^SSUTIL4(tmpalias)
	.i AllAlias="" s AllAlias=tmpalias
	.e  s AllAlias=AllAlias_"/"_tmpalias
	.q:(tmpalias '[ OrdAliasDesc)&&(OrdAliasDesc'="")
	.i text'=""  d
	..s text=text_"/"_tmpalias
	.e  d
	..s text=tmpalias
	q:text=""
	s text=AllAlias
	s OrdAlias1=$g(text)
	s ordprice2=$fn(ARCOSPrice,"",2)
	s DrgGdesc=""
	s ordcode=$p(^ARCOS(ARCOSRowId),"^",1)
	s ordExternalCode="",ordExternalDesc=""
	s arcitmrow=ARCOSRowId
	s ArcItmLimitInfo="" //##class(web.DHCDocOrderEntry).GetArcItmLimitInfo(arcitmrow, "", SessionStr)
	do OutputRow1 
valrownew(row) ;validate if arcim is active 0-active,1-not active
	 n (row)
	 s datefrom=$p($g(^ARCIM(+row,1,1)),"^",13)
	 s dateto=$p($g(^ARCIM(+row,1,7)),"^",1)
	 i datefrom>+$h q 1
	 i dateto,dateto<+$h q 1
	 s ordOnItOwn=$p($g(^ARCIM(+row,1,7)),"^",13)
	 Quit:ordOnItOwn="N" 1
	 q 0
valarcosnew(row) ;validate if arcos is active 0-active,1-not active
	n (row)
	s datefrom=$p($g(^ARCOS(+row)),"^",15)
	s dateto=$p($g(^ARCOS(+row)),"^",16)
	i datefrom>+$h q 1
	i dateto,dateto<+$h q 1
	q 0
}

ClassMethod ValARCItem(ARCIMRowid As %String) As %String
{
	;validate if arcim is active 0-active,1-not active
	s datefrom=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",13)
	s dateto=$p($g(^ARCIM(+ARCIMRowid,1,7)),"^",1)
	i datefrom>$h q 1
	i dateto,dateto<$h q 1
	q 0
}

ClassMethod InsertByOrdItems(ARCOSRowid, OrdItemIDStr, UserID, LogonHospID = "")
{
	;s ^Wqy("OS","InsertByOrdItems")=$LB(ARCOSRowid, OrdItemIDStr, UserID,LogonHospID)
	Q:ARCOSRowid="" "医嘱套不能为空"
	d ##class(web.DHCDocInPatPortalCommon).OrdItemIDStrToList(OrdItemIDStr,LogonHospID,.OrdList)
	Q:'$D(OrdList) "医嘱不能为空"
	;出院带药医嘱
	s OutOrderPriorRowid=$O(^OECPR(0,"Code","OUT",0))
	;长期医嘱
	s LongOrderPriorRowid=$O(^OECPR(0,"Code","S",0))
	;临时医嘱
	s ShortOrderPriorRowid=$O(^OECPR(0,"Code","NORM",0))
	s SuccessCount=0,FailCount=0
	s ret=""
	s OrdItemID="" for{
		s OrdItemID=$O(OrdList(OrdItemID)) Q:OrdItemID=""
		s CMFlag=##class(DHCDoc.Order.Common).IsCNOrdItem(OrdItemID,LogonHospID)
		s Ord=+OrdItemID,Sub=$P(OrdItemID,"||",2)
		s ItmLinkDoctor=""	;OrderMasterSeqNo
		;草药医嘱套不需要关联序号
		if 'CMFlag&&$O(OrdList(OrdItemID,0))>0{
			s MaxLinkSeqNo=..GetArcosMaxLinkSeqNo(ARCOSRowid)
			i +MaxLinkSeqNo<=0 s ItmLinkDoctor=1
			e  s ItmLinkDoctor=MaxLinkSeqNo+1
		}
		d OneOrdItem
		s Sub=0 for{
			s Sub=$O(OrdList(OrdItemID,Sub)) Q:Sub=""
			s:'CMFlag ItmLinkDoctor=ItmLinkDoctor+0.1
			d OneOrdItem
		}
	}
	Q:'SuccessCount ret
	Q 0
OneOrdItem
	s ARCIMRowid=$P(^OEORD(Ord,"I",Sub,1),"^",2)
	s remark=$CASE(CMFlag,1:$P($G(^OEORD(Ord,"I",Sub,2)),"^",8),:$g(^OEORD(Ord,"I",Sub,"DEP",1)))
	s ItemDoseQty=$P($G(^OEORD(Ord,"I",Sub,2)),"^",1)
	s ItemDoseUOMID=$P($G(^OEORD(Ord,"I",Sub,2)),"^",3)
	s ItemQty=""
	s ItemFrequenceID=""
	s ItemDurationID=""
	s ItemInstructionID=""
	s OrderPriorID=$P($G(^OEORD(Ord,"I",Sub,1)),"^",8)
	s OrderPriorCode=$P($G(^OECPR(+OrderPriorID)),"^",1)
	;医嘱类型拆分
	s DHCDocOrderTypeID=ShortOrderPriorRowid
	if ##class(appcom.OEOrdItem).ISLongOrderPrior(OrderPriorID) s DHCDocOrderTypeID=LongOrderPriorRowid
	s OrderPriorRemarksDR=""
	if 'CMFlag{
		if OrderPriorCode="OUT" s DHCDocOrderTypeID=OutOrderPriorRowid
		s OrderPriorRemarksDR=$SELECT(OrderPriorCode="ONE":"ONE",OrderPriorCode["ZT":"ZT",OrderPriorCode["OM":"OM",1:"")
		s OrderType=##class(web.DHCDocOrderCommon).GetOrderType(ARCIMRowid)
		if OrderType="R"{
			s ItemQty=$P($G(^OEORD(Ord,"I",Sub,9)),"^",4)
		}else{
			s ItemQty=$P($G(^OEORD(Ord,"I",Sub,1)),"^",12)
		}
		s ItemFrequenceID=$P($G(^OEORD(Ord,"I",Sub,2)),"^",4)
		s ItemDurationID=$P($G(^OEORD(Ord,"I",Sub,2)),"^",6)
		s ItemInstructionID=$P($G(^OEORD(Ord,"I",Sub,2)),"^",7)
	}
	s SampleId=$p($g(^OEORD(Ord,"I",Sub,"SPEC",1)),"^",1)
	s ARCOSItemNO=""
	s DHCDocOrderRecLoc=$P($G(^OEORD(Ord,"I",Sub,3)),"^",6)
	;ExpStr
	s OrderStageCode=$P($G(^OEORD(Ord,"I",Sub,"DHC")),"^",8)
	s MustEnter="N"
	s OrderPackUOM=$P($G(^OEORD(Ord,"I",Sub,"DHC")),"^",13)
	s OrderSpeedFlowRate=$P($G(^OEORD(Ord,"I",Sub,3)),"^",17)
	s OrderFlowRateUnitRowId=$P($G(^OEORD(Ord,"I",Sub,6)),"^",8)
	s OrderBodyPartLabel=##Class(DHCDoc.OPDoc.CopyOrderItemList).GetReqPartID(Ord_"||"_Sub)
	s OrderSkinTest=$P($G(^OEORD(Ord,"I",Sub,5)),"^",2)
	s OrderActionRowid=$P($G(^OEORD(Ord,"I",Sub,11)),"^",21)
	s Urgent=$P($G(^OEORD(Ord,"I",Sub,11)),"^",55)
	s OrderFreqTimeDoseStr=$P($G(^OEORD(Ord,"I",Sub,"DHC")),"^",59)
	s OrderFreqWeekStr=##class(web.DHCOEOrdItem).GetOrdFrqTimeInfoForEntry(Ord_"||"_Sub)
	s ExpStr=OrderStageCode_"^"_MustEnter_"^"_OrderPackUOM
	s ExpStr=ExpStr_"^"_OrderSpeedFlowRate_"^"_OrderFlowRateUnitRowId_"^"_OrderBodyPartLabel_"^"_OrderSkinTest_"^"_OrderActionRowid_"^"_Urgent
	s ExpStr=ExpStr_"^"_"^"_OrderFreqTimeDoseStr_"^"_OrderFreqWeekStr	; //同频次不同剂量、周频次
	s ret=..InsertItem(ARCOSRowid,ARCIMRowid,ItemQty,ItemDoseQty,ItemDoseUOMID,ItemFrequenceID,ItemDurationID,ItemInstructionID,ItmLinkDoctor,remark,DHCDocOrderTypeID,SampleId,ARCOSItemNO,OrderPriorRemarksDR,DHCDocOrderRecLoc,ExpStr)
	if $P(ret,"^")>0{
		s SuccessCount=SuccessCount+1
	}else{
		s FailCount=FailCount+1
	}
	Q
}

/// / ##class(web.DHCARCOrdSets).GetArcItmLimitInfo("67||1","","17331^28^80^2")
ClassMethod GetArcItmLimitInfo(OrderARCIMRowid, EpisodeID, SessionStr)
{
	s ^tmp("GetArcItmLimitInfo")=$LB(OrderARCIMRowid, EpisodeID, SessionStr)
    s OutInfo=""
	s OrderItemCatRowid=$p($g(^ARCIM(+OrderARCIMRowid,$p(OrderARCIMRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",OrderItemCatRowid),"^",7)
    //s SessionStr=USERID_"^"_GROUPID_"^"_CurLogonDep_"^"_HOSPID
    s USERID=$P(SessionStr,"^",1)
    s CareProvType=##class(web.DHCDocOrderCommon).GetCareProvType(USERID)
    s CareProvType=$zcvt(CareProvType,"U")
    
    //s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
   // s CurrentDischargeStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
    s CTLOCID=$P(SessionStr,"^",3)
    s GROUPID=$P(SessionStr,"^",2)
    s HOSPID=$P(SessionStr,"^",4)
	s langid=$P(SessionStr,"^",6)
    //s OEOrderRowID=$o(^OEORD(0,"Adm",EpisodeID,""))
    
    s Valid=##class(web.DHCDocOrderEntry).AddControl(OrderARCIMRowid,GROUPID)
    if (Valid=1) {
        s OutInfo="没有权限开此医嘱!"
    }
    s OrderItemInValid=##Class(web.DHCDocOrderEntry).ValARCItem(OrderARCIMRowid)
	
    if (1=OrderItemInValid){
        s OutInfo="医嘱项目无效!"
    }
	
    //"web.DHCDocRegConfigDataCheck","GetLocRecLoc"
    
	s ReclocDescStr=##class(web.DHCDocRegConfigDataCheck).GetLocRecLoc(OrderARCIMRowid,HOSPID)
    if (""=ReclocDescStr){
        s OutInfo="没有接收科室"
    }
    
   
    if ("L"=OrderType){
		s LabSpec=##class(web.DHCDocOrderCommon).GetLabSpec(OrderARCIMRowid,HOSPID)
        if (LabSpec="") {
            s OutInfo="检验标本没有维护"
        }
    }
        
    
    s IncItmHighValueFlag=##Class(web.DHCDocOrderCommon).GetIncItmHighValueFlag(OrderARCIMRowid)
    if (IncItmHighValueFlag="Y"){
        s HighValueControl=##class(web.DHCDocConfig).GetDHCCTLOCFieldValue(CTLOCID,13)
        if (HighValueControl'=1){
            s OutInfo="所登录的科室没有录入高值材料的权限"
        }
    }
    
    s CheckArcimTypeStr=##class(web.DHCDocOrderCommon).CheckArcimType(OrderARCIMRowid,EpisodeID)  
    ;按照医嘱项上的门诊用药、急诊用药、住院用药标志来检测医嘱项是否可用
    if (CheckArcimTypeStr'=""){
        s OutInfo=CheckArcimTypeStr
    }
    //i OutInfo'="" s OutInfo="<p style='color:red'>"_OutInfo_"</p>"
	s OutInfo=..%Translate("doc.arcimquery.hui.csp",OutInfo,langid)
	
    q OutInfo
}

}
