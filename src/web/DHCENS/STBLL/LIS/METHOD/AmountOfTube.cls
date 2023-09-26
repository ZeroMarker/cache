Class web.DHCENS.STBLL.LIS.METHOD.AmountOfTube Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：WuXianPu
/// CreatDate：2016—07-03
/// Description：获取医嘱相关信息
/// Table：
/// Input： 医嘱RowID^医嘱RowID
/// Return：试管数量,条码与医嘱绑定信息
/// Others: w ##class(web.DHCENS.STBLL.LIS.METHOD.AmountOfTube).AmountOfTube("425||11","")
ClassMethod AmountOfTube(Input As %String, DeptCode As %String) As %String
{
	s $ZTrap = "SendMessageET"
	Quit:Input="" "-1^医嘱信息为空"
	set Length=$L(Input,"^")
	set i=0,specInfo="",Result=-1
	f i=1:1:Length {
		set tmpInfo=""
		set TmpRowId=$p(Input,"^",i)
		set ord=+TmpRowId
		set sub=$p(TmpRowId,"||",2)
		set (StatusCode,ArcimCode,RecDeptCode,SpecCode)=""
		set ordstr1 = $g(^OEORD(ord,"I",sub,1))
		set ordstr3 = $g(^OEORD(ord,"I",sub,3))
	    set ordStatusRowID = $P(ordstr1,"^",13)   
	    if ordStatusRowID'="" { 
			set StatusCode=$p($g(^OEC("OSTAT",ordStatusRowID)),"^",1)
	    }
		set SpecDr=$o(^OEORD(ord,"I",sub,"SPEC",""),-1)
		if ((SpecDr'="") && (StatusCode'="D")) {
			set SpecCode=$p(^OEORD(ord,"I",sub,"SPEC",SpecDr),"^",1)
		    set arcimId = $P(ordstr1,"^",2)
		    set arcSub = $P(arcimId,"||",1)
		    set arcVer = $P(arcimId,"||",2)
		    if (arcimId '= "") {
			    set ArcimCode=$p($g(^ARCIM(arcSub,arcVer,1)),"^",1)
		    }
		    set RecDeptRowID = $P(ordstr3,"^",6)
		    if (RecDeptRowID '= "") {
			    set RecDeptCode = $p($g(^CTLOC(RecDeptRowID)),"^",1)
		    }
		    set tmpInfo=$g(specInfo(RecDeptCode))
		    set specInfo(RecDeptCode)=tmpInfo_ArcimCode_","_SpecCode_","_RecDeptCode_",0,"_TmpRowId_";"
		}
	}
	/// 调用Lis方法获取试管数量
	set inserRel="-1^收费时传入信息错误"
	set soap=##class(web.DHCENS.STBLL.LIS.SOAP.PUB0008Soap).%New()
	set RecDeptCode="" for  set RecDeptCode=$o(specInfo(RecDeptCode))  q:RecDeptCode=""  d
	.set tmpInfo=specInfo(RecDeptCode)
	.set stream=##class(%GlobalCharacterStream).%New()
	.d stream.Write(tmpInfo)
	.set ResultStr=##class(%GlobalCharacterStream).%New()
	.set ResultStr=soap.GetAmountOfTube("T0052",stream)
	.set Result=..GetTubeAndRowId(ResultStr,RecDeptCode)
	/*	
	.if DeptCode'="" d
	..set Result=..GetTubeAndRowId(ResultStr,DeptCode)
	.else  d
	..set Result=..GetTubeAndRowId(ResultStr,RecDeptCode)
	*/
	Quit Result
SendMessageET
	Quit "-1^"_$ze
}

/// Creator：WuXianPu
/// CreatDate：2016—07-03
/// Description：解析LIS返回试管信息
/// Table：
/// Input： 
/// Return：试管数量,条码与医嘱绑定信息
/// Others: w ##class(web.DHCENS.BLL.Lis.Method.AmountOfTube).GetTubeAndRowId("<Response><ResultCode>0</ResultCode><ErrorMsg/><Amount>1</Amount><Tubes><Tube><ItemCode>CL100067</ItemCode><OrdRowIDs>21139_3</OrdRowIDs></Tube></Tubes></Response>")
ClassMethod GetTubeAndRowId(inputContent As %GlobalCharacterStream, DeptCode As %String) As %String
{
	s $ZTrap = "SendMessageET"
	
	set tSC=##class(%XML.XPATH.Document).CreateFromStream(inputContent,.tDocument)
	d inputContent.Rewind()
	if $$$ISERR(tSC) {
		Quit "-1^"_tSC
	}else{
		set tSC=tDocument.EvaluateExpression("/HtResponse/ChargeRules","count(ChargeRule)",.tRes)
		if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
			set hsCount=tRes.GetAt(1).Value
			set AmountInput=""
			f i=1:1:hsCount {
				set FeeItemCode="",Qty="0",OrdRowIDs=""
				set tSC=tDocument.EvaluateExpression("/HtResponse/ChargeRules/ChargeRule["_i_"]/FeeItemCode","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set FeeItemCode=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/HtResponse/ChargeRules/ChargeRule["_i_"]/Qty","text()",.tRes)					
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
					set fieldValue=tRes.GetAt(1).Value
					set Qty=$tr(fieldValue,$c(0),"")
				}
				set tSC=tDocument.EvaluateExpression("/HtResponse/ChargeRules/ChargeRule["_i_"]/HisRecords","count(HisRecordID)",.tRes)
				if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){
					set ordCount=tRes.GetAt(1).Value
					for ii=1:1:ordCount {
						set tSC=tDocument.EvaluateExpression("/HtResponse/ChargeRules/ChargeRule["_i_"]/HisRecords/HisRecordID["_ii_"]","text()",.tRes)					
						if ($$$ISOK(tSC)&&(tRes.GetAt(1)'="")){					
							set fieldValue=tRes.GetAt(1).Value
							set OrdRowID=$tr(fieldValue,$c(0),"")
						}
						if OrdRowIDs'="" {
							set OrdRowIDs=OrdRowIDs_"^"_OrdRowID
						}
						else {
							set OrdRowIDs=OrdRowID
						}
					}
				}
				if (AmountInput="") {
					s AmountInput=FeeItemCode_"+"_OrdRowIDs_"+"_Qty
				}
				else {
					s AmountInput=AmountInput_"###"_FeeItemCode_"+"_OrdRowIDs_"+"_Qty
				}
			}
		}
	}
	Quit:AmountInput="" "0^试管数量为0"
	set Result=..AddTubeOrdItem(AmountInput,DeptCode)
	Quit Result
SendMessageET
    Quit "-1^"_$ze
}

ClassMethod AddTubeOrdItem(Input As %String, DeptCode As %String) As %String
{
	set $ZTrap = "SendMessageET"
	set ResultFlag="0"
	set TubeOrdRowIDs=""
	set Length=$l(Input,"###")
	set AppDeptCode="",DoctorCode="",DoctorCode="",ARecDeptCode="",BBExtCode=""
	set SPECCode="",InsertCode="False"
	ts
	for k=1:1:Length {
		set TmpTube=$p(Input,"###",k)
		set OrdRowIDs=$p(TmpTube,"+",2)
		Quit:OrdRowIDs=""
		set Rowid=$p(OrdRowIDs,"^",1)
		set OEORDRowId=$p(Rowid,"||",1)
		set OEORIChildsub=$p(Rowid,"||",2)
		set AdmRowId=$p(^OEORD(OEORDRowId),"^",1)
		set AdmTypeCode=$p($g(^PAADM(AdmRowId)),"^",2)
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
				if AdmTypeCode="I" {
					set retStr=##class(appcom.OEOrdItem).UnUseMulti(ID,UserRowId,"","N")
				}
				else {
					set retStr=##class(web.DHCOEOrdItem).Stop(ID,UserRowId)
				}
				&sql(Delete from SQLUSER.EnsAmountOfTube where Lab_RowId=:TmpRowId)
				if (SQLCODE'=0) {
					s ResultFlag="-1"
				}
			}
		}
	}
	if ResultFlag="-1" {
		tro
		Quit "-1^失败"
	}
	
	for i=1:1:Length {
		set TmpTube=$p(Input,"###",i)
		set arcimCode=$p(TmpTube,"+",1)
		if arcimCode="" {
			set ResultFlag="LIS系统返回收费项目代码为空"
			Quit
		}
		set OrdRowIDs=$p(TmpTube,"+",2)
		set Rowid=$p(OrdRowIDs,"^",1)
		set OEORDRowId=$p(Rowid,"||",1)
		set OEORIChildsub=$p(Rowid,"||",2)
		set AdmRowId=$p(^OEORD(OEORDRowId),"^",1)
		set qty=$p(TmpTube,"+",3)
		set ordDeptDr=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,7),"^",2)
		set AppDeptCode=$p(^CTLOC(ordDeptDr),"^",1)
		
		set recDeptDr=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(DeptCode),""))  ;$P(^OEORD(OEORDRowId,"I",OEORIChildsub,3),"^",6)
		set CareProvDr=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",11)
		set userDr=$o(^SSU("SSUSR",0,"CTPCP",CareProvDr,""))
		set docDr=CareProvDr
		set DoctorCode=$p(^SSU("SSUSR",userDr),"^",1)
		set sub = $O(^ARCIM(0,"Code",arcimCode,""))
		set ver = $O(^ARCIM(0,"Code",arcimCode,sub,""))
		set itemMast = sub_"||"_ver //医嘱项Rowid
		/// 判断是否收取采血费，每次就诊只收入一次
		Quit:($d(^EnsAmountOfTubeI(AdmRowId,itemMast)))
		set OrderSeqNo=1
		set itemCat=$p($g(^ARCIM(sub,ver,1)),"^",10)  //医嘱子类
		set OrderType=$p($g(^ARC("IC",itemCat)),"^",7)
		set BillTypeRowid=$P(^OEORD(OEORDRowId,"I",OEORIChildsub,11),"^",18)
		set (OrderDrugFormRowid,OrderDepProcNotes,OrderDoseQty,OrderDoseUOMRowid,OrderQtySum,OrderFreqRowid)=""
		set (OrderDurRowid,OrderInstrRowid,PHPrescType,OrderMasterSeqNo,OrderSkinTest,OrderPhSpecInstr,OrderCoverMainIns)=""
		set (OrderActionRowid,OrderARCOSRowid,OrderEndDate,OrderEndTime,OrderLabSpecRowid)=""
		set OrderStartDate=$zd(+$h,4)
		set OrderStartTime=$p($h,",",2)
		set:OrderStartTime'="" OrderStartTime=$p($zt(OrderStartTime,1),":",1,2)
		set OEORIPriorityCode=3 
		set OrderQtySum=qty
		Set OrderItemStr=itemMast_"^"_OrderType_"^"_OEORIPriorityCode_"^"_OrderStartDate_"^"_OrderStartTime_"^"_qty_"^"_"" 
		Set OrderItemStr=OrderItemStr_"^"_recDeptDr_"^"_BillTypeRowid_"^"_OrderDrugFormRowid_"^"_OrderDepProcNotes
		Set OrderItemStr=OrderItemStr_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderQtySum_"^"_OrderFreqRowid_"^"_OrderDurRowid_"^"_OrderInstrRowid
		Set OrderItemStr=OrderItemStr_"^"_PHPrescType_"^"_OrderMasterSeqNo_"^"_OrderSeqNo_"^"_OrderSkinTest_"^"_OrderPhSpecInstr_"^"_OrderCoverMainIns
		Set OrderItemStr=OrderItemStr_"^"_OrderActionRowid_"^"_OrderARCOSRowid_"^"_OrderEndDate_"^"_OrderEndTime_"^"_OrderLabSpecRowid

		set res = ##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(AdmRowId,OrderItemStr,userDr,ordDeptDr,docDr,"")
		if ($p(res,"*",2)'="") {
			set TubeRowId = $P(res,"*",2)
			set TmpLength=$L(OrdRowIDs,"^")
			for j=1:1:TmpLength {
				set TmpRowId=$p(OrdRowIDs,"^",j)
				s obj=##class(User.EnsAmountOfTube).%New()
				s obj.AdmRowId=AdmRowId
				s obj.LabRowId=TmpRowId
				s obj.TubeItemCode=arcimCode
				s obj.TubeRowId=TubeRowId
				s obj.IntInsDate=+$h
				s obj.IntInsTime=$p($h,",",2)
				s sc=obj.%Save()
				i sc=1
				{
					i TubeOrdRowIDs=""
					{
						s TubeOrdRowIDs=TubeRowId
					}
					else
					{
						s TubeOrdRowIDs=TubeOrdRowIDs_"#"_TubeRowId
					}
				}
			}
			if itemMast="5165||1" {
				set ^EnsAmountOfTubeI(AdmRowId,itemMast)=""
			}
		}
		else {
			set ResultFlag=-1
		}
	}
	if ResultFlag'="0" {
		tro
		Q "-1^"_ResultFlag
	}
	else {
		tc 
		Q "0^成功^"_TubeOrdRowIDs
	}
SendMessageET
	tro
    Quit "-1^"_$ze
}

}
