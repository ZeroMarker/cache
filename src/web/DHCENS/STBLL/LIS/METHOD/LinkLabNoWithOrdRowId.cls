Class web.DHCENS.STBLL.LIS.METHOD.LinkLabNoWithOrdRowId Extends (%RegisteredObject, %XML.Adaptor)
{

ClassMethod LaboratoryBarcode(inputContent As %GlobalCharacterStream) As %GlobalCharacterStream
{
	set $zt="Exception"
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	set RepObj=##class(web.DHCENS.STBLL.LIS.MODEL.Response).%New()
	set header=##class(web.DHCENS.STBLL.LIS.MODEL.Header).%New()
	set responseBody=##class(web.DHCENS.STBLL.LIS.MODEL.Respbody).%New()
	set header.MessageID=##class(web.DHCENS.STBLL.UTIL.Common).CreateMessageID(+$h)
	set header.SourceSystem="02"
	set RepObj.header=header
	set ResultCode=""
	set ResultContent=""
	if $$$ISERR(tSC) {
		set responseBody.ResultCode="-1"
		set responseBody.ResultContent=tSC
	}else{
		set (SpecimenID)=""
		set tSC=tDocument.EvaluateExpression("/Request/Body/LaboratoryBarcodeRt/SpecimenID","text()",.tRes)					
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
			set fieldValue=tRes.GetAt(1).Value
			set SpecimenID=$tr(fieldValue,$c(0),"")
		}		
		set tSC=tDocument.EvaluateExpression("/Request/Body/LaboratoryBarcodeRt/OEORIOrderItemIDs","count(OEORIOrderItemID)",.tRes)					
		s AmountInput=""
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set ordCount=tRes.GetAt(1).Value
			if ordCount="" {
				set responseBody.ResultCode="-1"
				set responseBody.ResultContent="医嘱信息为空"
			}
			else{
				set OrdRowIds=""
				for i=1:1:ordCount {
					set OrderItemID=""
					set tSC=tDocument.EvaluateExpression("/Request/Body/LaboratoryBarcodeRt/OEORIOrderItemIDs/OEORIOrderItemID["_i_"]","text()",.tRes)					
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
						set fieldValue=tRes.GetAt(1).Value
						set OrderItemID=$tr(fieldValue,$c(0),"")						
						if OrdRowIds'=""{
							set OrdRowIds=OrdRowIds_"^"_OrderItemID
						}
						else {
							set OrdRowIds=OrderItemID
						}
					}
				} 
				set responseBody=..InsertLinkLabNoWithOrdRowId(SpecimenID,OrdRowIds)	;关联
				if responseBody.ResultCode="0" {
					set tSC=tDocument.EvaluateExpression("/Request/Body/LaboratoryBarcodeRt/ChargeInfos","count(ChargeInfo)",.tRes)					
					if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
						set chargeCount=tRes.GetAt(1).Value
						if chargeCount="" {
							set responseBody.ResultCode="0"
							set responseBody.ResultContent="试管数量为空"
						}
						else{
							set AmountInput=""
							for j=1:1:chargeCount {
								set (ChargeCode,ChargeCount)=""
								set tSC=tDocument.EvaluateExpression("/Request/Body/LaboratoryBarcodeRt/ChargeInfos/ChargeInfo["_j_"]/ChargeCode","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set ChargeCode=$tr(fieldValue,$c(0),"")
								}
								set tSC=tDocument.EvaluateExpression("/Request/Body/LaboratoryBarcodeRt/ChargeInfos/ChargeInfo["_j_"]/ChargeCount","text()",.tRes)					
								if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
									set fieldValue=tRes.GetAt(1).Value
									set ChargeCount=$tr(fieldValue,$c(0),"")
								}
								if ((ChargeCode'="")&&(ChargeCount'="")){
									if (AmountInput=""){
										s AmountInput=ChargeCode_"+"_OrdRowIds_"+"_ChargeCount
									}
									else {
										s AmountInput=AmountInput_"###"_ChargeCode_"+"_OrdRowIds_"+"_ChargeCount
									}
								}
							}
							if AmountInput="" {
								s responseBody.ResultCode="-1"
								s responseBody.ResultContent="试管数量为0"
								s RepObj.Respbody=responseBody
								d RepObj.XMLExportToStream(.stream)
								Quit stream
							}
							set Result=..AddTubeOrdItem(AmountInput)
							if $p(Result,"^",1)=0 {
								s responseBody.ResultCode="0"
								s responseBody.ResultContent="成功"
							}
							else{
								s responseBody.ResultCode="-1"
								s responseBody.ResultContent="失败,"_$p(Result,"^",2)
							}
							s RepObj.Respbody=responseBody
							d RepObj.XMLExportToStream(.stream)
							Quit stream						
						}
					}
				}				
			} 
		} 			
		else {
			s responseBody.ResultCode="-1"
			s responseBody.ResultContent="医嘱信息为空"
			s RepObj.Respbody=responseBody
			d RepObj.XMLExportToStream(.stream)
			Quit stream
		}
	}
	s RepObj.Respbody=responseBody
	d RepObj.XMLExportToStream(.stream)
	Quit stream
	
Exception
	set stream=##class(%GlobalCharacterStream).%New()
	d stream.Write("-1^"_$ze)
	Quit stream
}

ClassMethod InsertLinkLabNoWithOrdRowId(LabNo As %String, OrdRowIds As %String) As web.DHCENS.STBLL.LIS.MODEL.Respbody
{
	s MainObj=##class(web.DHCENS.STBLL.LIS.MODEL.Respbody).%New()
	if ((LabNo'="")||(OrdRowIds'="")) {
		s Length=$L(OrdRowIds,"^")
		s errStr=""
		for i=1:1:Length {
			set RowID=$p(OrdRowIds,"^",i)
			if ##class(%Dictionary.MethodDefinition).%ExistsId("DHCDoc.Interface.Inside.ServiceOrd||UpdateLabEpisodeNo"){
				s rtn=##class(DHCDoc.Interface.Inside.ServiceOrd).UpdateLabEpisodeNo(RowID,LabNo)
				i rtn'=0{
	     			s errStr="更新条码号及其关联采血费、采血管费失败,错误代码:"_rtn
	     			q
     			}
			}
			else{
				&sql( UPDATE SQLUSER.oe_orditem SET OEORI_LabEpisodeNo=:LabNo WHERE OEORI_RowId=:RowID)
    	 		if SQLCODE'=0{
    	 			s errStr="更新条码号失败,错误代码:"_SQLCODE
	     			q
    	 		}
			}
			i errStr'=""{
				s MainObj.ResultCode=-1
				s MainObj.ResultContent=errStr
			}
			else{
				s MainObj.ResultCode=0
				s MainObj.ResultContent="成功"
			}
		}
	}
	else{
		s MainObj.ResultCode=-1
		s MainObj.ResultContent="输入信息有误"
	}
	Quit MainObj
}

ClassMethod AddTubeOrdItem(Input As %String) As %String
{
	set $ZTrap = "SendMessageET"
	set ResultFlag="0"
	set Length=$l(Input,"###")
	set AppDeptCode="",DoctorCode="",DoctorCode="",ARecDeptCode="",BBExtCode="",SPECCode="",InsertCode="False"
	ts
	/*
	for k=1:1:Length {
		set TmpTube=$p(Input,"###",k)
		set OrdRowIDs=$p(TmpTube,"+",2)
		set Rowid=$p(OrdRowIDs,"^",1)
		set OEORDRowId=$p(Rowid,"||",1)
		set OEORIChildsub=$p(Rowid,"||",2)
		set AdmRowId=$p(^OEORD(OEORDRowId),"^",1)
		set TmpLength=$L(OrdRowIDs,"^")
		set DoctorRowID=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,7),"^",1)
		set DoctorCode=$p(^SSU("SSUSR",DoctorRowID),"^",1)
		set DoctorCode=$$ALPHAUP^SSUTIL4(DoctorCode)
		set UserRowId=$o(^SSU("SSUSR",0,"SSUSR_Initials",DoctorCode,""),-1)
		for k1=1:1:TmpLength {
			set TmpRowId=$p(OrdRowIDs,"^",k1)
			if $d(^User.EnsAmountOfTubeI("IndexAdmRowIdAndLabRowId"," "_AdmRowId," "_TmpRowId)) {
				set TubeID=$O(^User.EnsAmountOfTubeI("IndexAdmRowIdAndLabRowId"," "_AdmRowId," "_TmpRowId,""))
				set ID=$List(^User.EnsAmountOfTubeD(TubeID),5)
				set BillState=$p($g(^OEORD($P(ID,"||",1),"I",$p(ID,"||",2),3)),"^",5)
				q:BillState="P"
				set retStr=##class(appcom.OEOrdItem).UnUseMulti(TmpRowId,UserRowId,"","N")
				&sql(Delete from SQLUSER.EnsAmountOfTube where Lab_RowId=:TmpRowId)
				if (SQLCODE'=0) {
					s ResultFlag="-1"
				}
			}
		}
	}
	if ResultFlag="-1" {
		tro
		Quit "-1^作废已经补录试管失败"
	}
	*/
	b ;11
	for i=1:1:Length {
		set TmpTube=$p(Input,"###",i)
		set arcimCode=$p(TmpTube,"+",1)
		set OrdRowIDs=$p(TmpTube,"+",2)
		set Rowid=$p(OrdRowIDs,"^",1)
		set OEORDRowId=$p(Rowid,"||",1)
		set OEORIChildsub=$p(Rowid,"||",2)
		set AdmRowId=$p(^OEORD(OEORDRowId),"^",1)
		b ;6565
		;Quit:$d(^User.EnsAmountOfTubeI("IndexAdmRowIdAndLabRowId"," "_AdmRowId," "_Rowid))
		continue:(($d(^User.EnsAmountOfTubeI("IndexAdmRowIdAndLabRowId"," "_AdmRowId," "_Rowid))&&(arcimCode'="F00000102473")))
		set qty=$p(TmpTube,"+",3)
		set ordDeptDr=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,7),"^",2)
		set AppDeptCode=$p(^CTLOC(ordDeptDr),"^",1)
		
		set recDeptDr=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,3),"^",6)
		set userDr=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,7),"^",1)
		set docDr=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",11)
		set DoctorCode=$p(^SSU("SSUSR",userDr),"^",1)
				
		set sub = $O(^ARCIM(0,"Code",arcimCode,""))
		set ver = $O(^ARCIM(0,"Code",arcimCode,sub,""))
		set itemMast = sub_"||"_ver //医嘱项Rowid
		/// 判断是否收取采血费，每次就诊只收入一次
		b ;454545
		;Quit:($d(^EnsAmountOfTubeI(AdmRowId,$zd(+$h,3),itemMast)))
		continue:($d(^EnsAmountOfTubeI(AdmRowId,$zd(+$h,3),itemMast)))
		set OrderSeqNo=1
		set itemCat=$p($g(^ARCIM(sub,ver,1)),"^",10)  //医嘱子类
		set OrderType=$p($g(^ARC("IC",itemCat)),"^",7)
		set BillTypeRowid="1"
		set (OrderDrugFormRowid,OrderDepProcNotes,OrderDoseQty,OrderDoseUOMRowid,OrderQtySum,OrderFreqRowid)=""
		set (OrderDurRowid,OrderInstrRowid,PHPrescType,OrderMasterSeqNo,OrderSkinTest,OrderPhSpecInstr,OrderCoverMainIns)=""
		set (OrderActionRowid,OrderARCOSRowid,OrderEndDate,OrderEndTime,OrderLabSpecRowid)=""
		set OrderStartDate=$zd(+$h,4)
		set OrderStartTime=$p($h,",",2)
		set:OrderStartTime'="" OrderStartTime=$p($zt(OrderStartTime,1),":",1,2)
		set OEORIPriorityCode=3 
		Set OrderItemStr=itemMast_"^"_OrderType_"^"_OEORIPriorityCode_"^"_OrderStartDate_"^"_OrderStartTime_"^"_qty_"^"_"" 
		Set OrderItemStr=OrderItemStr_"^"_ordDeptDr_"^"_BillTypeRowid_"^"_OrderDrugFormRowid_"^"_OrderDepProcNotes
		Set OrderItemStr=OrderItemStr_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderQtySum_"^"_OrderFreqRowid_"^"_OrderDurRowid_"^"_OrderInstrRowid
		Set OrderItemStr=OrderItemStr_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo_"^"_OrderSkinTest_"^"_OrderPhSpecInstr_"^"_OrderCoverMainIns
		Set OrderItemStr=OrderItemStr_"^"_OrderActionRowid_"^"_OrderARCOSRowid_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderLabSpecRowid

		set res = ##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(AdmRowId,OrderItemStr,userDr,ordDeptDr,docDr,"")
		
		if ($p(res,"*",2)'="") {
			set RowId = $P(res,"*",2)
			set TmpLength=$L(OrdRowIDs,"^")
			for j=1:1:TmpLength {
				set TmpRowId=$p(OrdRowIDs,"^",j)
				//set ExecFlag=##class(appcom.OEOrdItem).Execute(RowId,docDr)
				set obj=##class(User.EnsAmountOfTube).%New()
				set obj.AdmRowId=AdmRowId
				set obj.LabRowId=TmpRowId
				set obj.TubeItemCode=arcimCode
				set obj.TubeRowId=RowId
				set obj.IntInsDate=+$h
				set obj.IntInsTime=$p($h,",",2)
				set sc=obj.%Save()
			}
			set BillReturn=##class(web.UDHCJFBILLIP).BILL(AdmRowId,"","",0)
			
			if itemMast="5165||1" {
				set ^EnsAmountOfTubeI(AdmRowId,$zd(+$h,3),itemMast)=""
			}
		}
		else {
			set ResultFlag=-1
		}
	}
	if ResultFlag'="0" {
		tro
		Q "-1^计算失败"
	}
	else {
		tc 
		Q "0^成功"
	}
SendMessageET
	tro
    Quit "-1^"_$ze
}

}
