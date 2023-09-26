Class web.DHCDocSignVerify Extends (DHCDoc.Util.RegisteredObject, %XML.Adaptor) [ Inheritance = right, Not ProcedureBlock ]
{

/// w ##Class(web.DHCDocSignVerify).InsertSignBatchSignRecord($lg(^Templx("InsertSign"),1),$lg(^Templx("InsertSign"),2),$lg(^Templx("InsertSign"),3),$lg(^Templx("InsertSign"),4),$lg(^Templx("InsertSign"),5),$lg(^Templx("InsertSign"),6),$lg(^Templx("InsertSign"),7),$lg(^Templx("InsertSign"),8)) 
ClassMethod InsertSignBatchSignRecord(CurrOrderItemStr As %String, UserID As %String, OperationType As %String = "", OrdItemsHashVal As %String, MainSignCertCode As %String, MainSignValue As %String, ExpStr As %String = "", MainSignCertNo As %String = "")
{
   s ^Templx("InsertSign")=$lb(CurrOrderItemStr,UserID,OperationType,OrdItemsHashVal,MainSignCertCode,MainSignValue,ExpStr,MainSignCertNo)
	s ret=0
	f i=1:1:$l(CurrOrderItemStr,"^") q:ret'=0  d
	.s OrderIdStr=$p(CurrOrderItemStr,"^",i)
	.s OrderOperationType=$p(OrderIdStr,$c(1))
	.s OrderId=$p(OrderIdStr,$c(1),2)
	.q:(OrderId="")||(OrderOperationType="") 
	.s OEORIItemsHashVal=$p(OrdItemsHashVal,"&&&&&&&&&&",i)
	.s OrderMainSignValue=$p(MainSignValue,"&&&&&&&&&&",i)
	.s ret=..Insert(OrderId,UserID,OrderOperationType,OEORIItemsHashVal,MainSignCertCode,OrderMainSignValue,MainSignCertNo,ExpStr)
	q ret
}

/// w ##class(web.DHCDocSignVerify).Insert($lg(^Templx("Insert"),1),$lg(^Templx("Insert"),2),$lg(^Templx("Insert"),3),$lg(^Templx("Insert"),4),$lg(^Templx("Insert"),5),$lg(^Templx("Insert"),6),$lg(^Templx("Insert"),7),$lg(^Templx("Insert"),8)) 
ClassMethod Insert(newOrdIdDR As %String, UserID As %String, OperationType As %String = "", OEORIItemHash As %String = "", MainSignCertCode As %String = "", MainSignValue As %String = "", MainSignCertNo As %String = "", ExpStr As %String = "") As %String
{
	;1.得到医嘱相关的主要信息,其它信息
	;2.将数据组织成XML格式
	;3.插入到User.DHCDocSignVerify
	;4.ExpStr="StopUser_$C(1)_Info_$C(1)_OtherSignCert_$C(1)_OtherSignValue_$C(2)_UpdateUser_$C(1)_Info_$C(1)_OtherSignCert_$C(1)_OtherSignValue_$C(4)_Other"
	;"OSVSignResTypeDR_$C(1)_OSVInfo_$C(1)_OSVSignCert_$C(1)_OSVSignValue_$C(2)_OSVSignResTypeDR_$C(1)_OSVInfo_$C(1)_OSVSignCert_$C(1)_OSVSignValue_$C(4)_Other"
    s $ZT="ERROR^DHCSSERR"
    ;w ##Class(web.DHCDocSignVerify).Insert()  
    s ^Templx("Insert")=$lb(newOrdIdDR,UserID,OperationType,OEORIItemHash,MainSignCertCode,MainSignValue,ExpStr,MainSignCertNo)
   
    s myrtn=0
	s (SignTable,SignTableID,DiagnoseDR)=""
	;治疗相关CA获取对应表名
    if ((",CR,CA,CCR,DCA,CS,DCS,")[(","_OperationType_",")){
		s SignTableID=newOrdIdDR 
		s SignTable=$case(OperationType,"CR":"DHC_DocCureRecode","CCR":"DHC_DocCureRecode",
		"CA":"DHC_DocCureAssessment","DCA":"DHC_DocCureAssessment",
		"CS":"DHC_DocCureAssScore","DCS":"DHC_DocCureAssScore")
		s newOrdIdDR=""
	}
	elseif ((OperationType="D")||(OperationType="DD")){
		s DiagnoseDR=newOrdIdDR
		s SignTableID=newOrdIdDR 
		s SignTable="MR_Diagnos"
		s newOrdIdDR=""
	}
	
	TS
	s ret=##Class(CA.DigitalSignatureService).Sign(MainSignCertCode,"DOC",OEORIItemHash,MainSignValue,MainSignCertNo)
	s retcode=$p(ret,"^")
	if (+retcode'=1)
	{
		tro 
		q "-100"
	}
	s signID=$p(ret,"^",2)
	;在医嘱状态表保存签名表CA.DigitalSignature 的外键 和 操作类型
	s Object=##class(User.DHCDocSignVerify).%New()
	if newOrdIdDR'="" Do Object.SVOEORIDRSetObjectId(newOrdIdDR)
	s Object.SVOEORIMainInfo=OEORIItemHash
	s Object.SVOEORIMainSignCert=MainSignCertCode
	s Object.SVOEORIMainSignValue=MainSignValue
	s Object.SVOEORIMainSignTimeStamp=""
	s Object.SVCreateUserDR=UserID
	s Object.SVOperationType=OperationType
	Do Object.SVDigitalSignatureDRSetObjectId(signID)
	s Object.SVCreateDate=..%SysDate()
	s Object.SVCreateTime=..%SysTime()
	if DiagnoseDR'="" Do Object.SVDiagnosDRSetObjectId(DiagnoseDR)
	s Object.SVSignTable=SignTable
	s Object.SVSignTableID=SignTableID
	s sc=Object.%Save()
	If ($System.Status.IsError(sc))
		{   TRO
			Do $System.Status.DisplayError(sc)
			Set myrtn = "-100"
		}else{
		TC
	    }
	s sc=Object.%Save()
	Q myrtn
}

/// 需要签名的医嘱串。
/// w ##Class(web.DHCDocSignVerify).GetOEORIItemsXML("636||1","A") 
ClassMethod GetOEORIItemsXML(OrderItemStr As %String, OperationType As %String = "") As %String
{
	q:OrderItemStr="" ""
	s OEORIItemsXMLHash=""
	f i=1:1:$l(OrderItemStr,"^") d
	.s OrderId=$p(OrderItemStr,"^",i)
	.q:OrderId="" 
	.;s OrderIdXMLHash=..HashOEORIItemXML(OrderId,OperationType)
	.Q:OrderIdXMLHash=""
	.i OEORIItemsXMLHash="" s OEORIItemsXMLHash=OrderIdXMLHash
	.e  s OEORIItemsXMLHash=OEORIItemsXMLHash_"&&&&&&&&&&"_OrderIdXMLHash
	i OEORIItemsXMLHash'="" s OEORIItemsXMLHash=OEORIItemsXMLHash_"&&&&&&&&&&"
    q OEORIItemsXMLHash
}

ClassMethod GetOEORIItemXML(newOrdIdDR As %String, OperationType As %String = "") As %String
{
	n (newOrdIdDR,OperationType)
	Q:newOrdIdDR="" ""
	if ((OperationType="Diag")||(OperationType="DeDiag")){
		s MRADMID=$P(newOrdIdDR,"||",1)
		s Sub=$P(newOrdIdDR,"||",2)
		s Str=$G(^MR(MRADMID,"DIA",Sub))
		s Rowid=MRADMID_"||"_Sub
		s CodeRowid=$P(Str,"^",1)
		s MRDiagnosDate=$P(Str,"^",7)
		s MRdiagnosTime=$P(Str,"^",8)
		s MRCIDCode="",Desc="",MRDesc=""
		if (CodeRowid'="") d
		.s MRCIDCode=$P(^MRC("ID",CodeRowid),"^",4)
		.s Desc=$P(^MRC("ID",CodeRowid),"^",2)
		s MRDescDr=$O(^MR(MRADMID,"DIA",Sub,"DES",""),-1)
		if (+MRDescDr'=0) d
		.s MRDesc=$g(^MR(MRADMID,"DIA",Sub,"DES",MRDescDr))
		s MRDiagnosTypeDesc=""
		s MRDiagnosTypeDr=""
		S MRdiagnosNoteDr=""
		S MRdiagnosNoteDesc=""
		s MRdiagnosNoteSubRowid=""
		S SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
		if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
		I MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
		S MRdiagnosNoteSubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",0))
		I +MRdiagnosNoteSubRowid'=0 Set MRdiagnosNoteDesc=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",MRdiagnosNoteSubRowid))
		I MRDiagnosDate'="" Set MRDiagnosDate=..%ZD(MRDiagnosDate)
		I MRdiagnosTime'="" Set MRdiagnosTime=..%ZT(MRdiagnosTime,2)
		s BillFlag1="" 
		s BillFlag3=""
		s DiagnosCat=""
		i CodeRowid'="" d
		.s BillFlag1=$P($G(^MRC("ID",+CodeRowid)),"^",13)
		.s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)
		.i BillFlag3'="Y" d
		..s DiagnosCat="西医"
		.else  if (BillFlag3="Y")&&(BillFlag1'="Y") d
		..s DiagnosCat="中医"
		.else  d
		..s DiagnosCat="证候"
		e  d
		.s Questionnaire=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
		.i Questionnaire=1 d
		..s DiagnosCat="西医"
		.else  if (Questionnaire=2) d
		..s DiagnosCat="中医"
		.else  if (Questionnaire=3) d
		..s DiagnosCat="证候"
		if ($LISTVALID(MRDesc)'=0)&&(MRDesc'="") s MRDesc=$LIST(MRDesc,1)
		s DiagStat=""
		s DiagStatDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",9)
		s DiagnosLeavel=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",1) //取诊断级别
		s DiagnosNumber=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",2) //取顺序号
		s MainMRDiagnoeRowId=$P($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",15)
		s:MainMRDiagnoeRowId'="" DiagnosNumber=$P($G(^MR($P(MainMRDiagnoeRowId,"||",1),"DIA",$P(MainMRDiagnoeRowId,"||",2),"EPR")),"^",2)
		s DIAOnsetDate=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",35) //取发病日期
		s:DIAOnsetDate'="" DIAOnsetDate=..%ZD(DIAOnsetDate) //取发病日期
		if DiagStatDr'="" s DiagStat=$p($g(^MRC("DSTAT",DiagStatDr)),"^",2)
		s Object=##class(web.DHCEntity.DHCDocDiagnoseMain).%New()
		s Object.MRCIDCode=MRCIDCode
		s Object.Desc=Desc
		s Object.MRDesc=MRDesc
		s Object.MRDiagnosTypeDesc=MRDiagnosTypeDesc
		s Object.MRdiagnosNoteDesc=MRdiagnosNoteDesc
		s Object.DiagnosCat=DiagnosCat
		s Object.MRDiagnosDate=MRDiagnosDate
		s Object.MRdiagnosTime=MRdiagnosTime
		s Object.DIAOnsetDate=DIAOnsetDate
		s OEORIMainXML=""
		d Object.XMLExportToString(.OEORIMainXML)
		s OperationType=$case(OperationType,"DeDiag":"DD","Diag":"D")	
		q OperationType_$c(1)_OEORIMainXML
	}elseif(OperationType["Cure"){
		s XmlInfo=##Class(DHCDoc.DHCDocCure.Service).GetCureXMLToCA(newOrdIdDR,.OperationType)
		q OperationType_$c(1)_XmlInfo
	}/*elseif((OperationType="CureRecord")||(OperationType="CancelCureRecord")){
		s XmlInfo=##Class(DHCDoc.DHCDocCure.Service).GetCureRecordXMLToCA(newOrdIdDR)
		s OperationType=$case(OperationType,"CureRecord":"CR","CancelCureRecord":"CCR")
		q OperationType_$c(1)_XmlInfo
	}elseif((OperationType="CureAss")||(OperationType="DelCureAss")){
		s XmlInfo=##Class(DHCDoc.DHCDocCure.Service).GetCureAssessmentXMLToCA(newOrdIdDR)
		s OperationType=$case(OperationType,"CureAss":"CA","DelCureAss":"DCA")
		q OperationType_$c(1)_XmlInfo
	}elseif((OperationType="CureScale")||(OperationType="CancelCureScale")){
		s XmlInfo=##Class(DHCDoc.DHCDocCure.Service).GetCureAssScaleXMLToCA(newOrdIdDR)
		s OperationType=$case(OperationType,"CureScale":"CS","CancelCureScale":"DCS")
		q OperationType_$c(1)_XmlInfo
	}*/else{
		s OrderRowid=$P(newOrdIdDR,"||",1)
		s ChildSub=$P(newOrdIdDR,"||",2)
		s ordstr1=$g(^OEORD(OrderRowid,"I",ChildSub,1))
		s ordstr2=$g(^OEORD(OrderRowid,"I",ChildSub,2))
		s ordstr3=$g(^OEORD(OrderRowid,"I",ChildSub,3))
		s ordstr5=$g(^OEORD(OrderRowid,"I",ChildSub,5))
		s ordstr7=$g(^OEORD(OrderRowid,"I",ChildSub,7))
		s ordstr9=$g(^OEORD(OrderRowid,"I",ChildSub,9))
		s ordstr11=$g(^OEORD(OrderRowid,"I",ChildSub,11))
		;主要信息
		s ArcimId=$p(ordstr1,"^",2)		     ;医嘱名称
		s ArcimId1=$p(ArcimId,"||",1),ArcimId2=$p(ArcimId,"||",2)
		s BaseUOM=""
		s INCIRowid=$o(^INCI(0,"ARCIM_DR",ArcimId1,""))
		s:INCIRowid'="" BaseUOM=$p($g(^INCI(INCIRowid,1)),"^",10)
		s:BaseUOM'="" BaseUOM=$P($g(^CT("UOM",BaseUOM)),"^",2)
		s ArcimDesc=$p($G(^ARCIM(ArcimId1,ArcimId2,1)),"^",2)
		s OrdCreateDate=$p(ordstr3,"^",7)    ;下医嘱日期
		s:OrdCreateDate'="" OrdCreateDate=..%ZD(OrdCreateDate)
		s OrdCreateTime=$p(ordstr1,"^",17)   ;下医嘱时间
		s:OrdCreateTime'="" OrdCreateTime=..%ZT(OrdCreateTime,2)
		s OrdStartDate=$p(ordstr1,"^",9)     ;医嘱开始日期
		s:OrdStartDate'="" OrdStartDate=..%ZD(OrdStartDate)
		s OrdStartTime=$p(ordstr1,"^",10)    ;医嘱开始时间
		s:OrdStartTime'="" OrdStartTime=..%ZT(OrdStartTime,2)
		s PrescNo=$p(ordstr1,"^",14)	     ;处方号
		s DoseQty=$p(ordstr2,"^",1)		     ;单次剂量
		s DoseUnit=$p(ordstr2,"^",3)	     ;单次剂量单位
		s:DoseUnit'="" DoseUnit=$p(^CT("UOM",DoseUnit),"^",2)
		s Priority=$p(ordstr1,"^",8)	     ;医嘱优先级
		s:Priority'="" Priority=$p($G(^OECPR(Priority)),"^",2)
		s Freq=$p(ordstr2,"^",4)	
		s:Freq'="" Freq=$P($G(^PHCFR(Freq)),"^",2)
		s Instr=$p(ordstr2,"^",7)			;用法
		s:Instr'="" Instr=$P($G(^PHCIN(Instr)),"^",2)
		s Dura=$p(ordstr2,"^",6)			;疗程
		s:Dura'="" Dura=$p($G(^PHCDU(Dura)),"^",2)
		s Doctor=$p(ordstr1,"^",11)		;下医嘱医生
		s:Doctor'="" Doctor=$p($g(^CTPCP(Doctor,1)),"^",1)
		s OrdEndDate=$p(ordstr9,"^",9)		;预停日期
		s:OrdEndDate'="" OrdEndDate=..%ZD(OrdEndDate)
		s OrdEndTime=$p(ordstr9,"^",10)		;预停时间
		s:OrdEndTime'="" OrdEndTime=..%ZT(OrdEndTime,2)
		s QtyPackUOM=$p(ordstr9,"^",4)		;整包娤
		s BillUOM=$p($g(^ARCIM(ArcimId1,ArcimId2,8)),"^",14) ; ;整包娤单位
		s:BillUOM'="" BillUOM=$p($g(^CT("UOM",BillUOM)),"^",2)
		s UseAdd=$p(ordstr7,"^",1)		;下医嘱用户
		s:UseAdd'="" UseAdd=$p($g(^SSU("SSUSR",UseAdd)),"^",1)
		s LabEpisodeNo=$p(ordstr3,"^",20) 	;标本号
		s OrdSkinTest=$p(ordstr5,"^",2)	  	;皮试
		s OrdLoc=$p(ordstr1,"^",3)		    ;就诊科室
		s:OrdLoc'="" OrdLoc=$p(^CTLOC(OrdLoc),"^",2)
		s PhQtyOrd=$p(ordstr1,"^",12)	  ;基本单位数量
		s FirstTimes=$p(ordstr1,"^",18)		  ;长期药品医嘱首日次数
		s CoverMainIns=$p(ordstr3,"^",3)		;医保标识
		s SeqNo=$p(ordstr3,"^",4)				;医嘱序号
		s RecDep=$p(ordstr3,"^",6)			 ;接收科室
		s:RecDep'="" RecDep=$p(^CTLOC(RecDep),"^",2)
		s ArcosId=$p(ordstr3,"^",10)			;医嘱套关联
		s UserDepartment=$p(ordstr7,"^",2)	;开单科室
		s:UserDepartment'="" UserDepartment=$p(^CTLOC(UserDepartment),"^",2)
		s StopDoctor=$p(ordstr3,"^",29)		;停医嘱人
		s:StopDoctor'="" StopDoctor=$p($g(^CTPCP(StopDoctor,1)),"^",1)
		s StopDate=$p(ordstr3,"^",34) 		;停医嘱日期
		s:StopDate'="" StopDate=..%ZD(StopDate)
		s StopTime=$p(ordstr2,"^",15) 		;停医嘱时间
		s:StopTime'="" StopTime=..%ZT(StopTime,2)
		s OrdStatus=$p(ordstr1,"^",13)       ;医嘱状态
		s:$g(OrdStatus)'="" OrdStatus=$p(^OEC("OSTAT",OrdStatus),"^",2)
		s BillType=$p(ordstr11,"^",18)     	;医嘱费别
		s:BillType'="" BillType=$p($g(^PAC("ADMREA",BillType)),"^",9)
		s OrdOEORIDR=$p(ordstr11,"^",39) 	;组合医嘱的的ID
		//s FillerNo=$p(ordstr9,"^",12)
		s OrderRevokeId=$o(^OEC("OSTAT",0,"Code","U",""))
		s (OrderRevokeDate,OrderRevokeTime,OrderRevokeUser)=""
		s StChild=""  f  s StChild=$o(^OEORD(OrderRowid,"I",ChildSub,"ST",StChild))  q:(OrderRevokeDate'="")||(StChild="")  d
		.s ordstrST=$G(^OEORD(OrderRowid,"I",ChildSub,"ST",StChild))
		.s UpdateState=$p(ordstrST,"^",3)
		.q:OrderRevokeId'=UpdateState
		.s OrderRevokeDate=$p(ordstrST,"^",1)
	    .s OrderRevokeTime=$p(ordstrST,"^",2)
	    .s OrderRevokeUser=$p(ordstrST,"^",4)
	    s:OrderRevokeDate'="" OrderRevokeDate=..%ZD(OrderRevokeDate)
	    s:OrderRevokeTime'="" OrderRevokeTime=..%ZT(OrderRevokeTime,2)
	    s:OrderRevokeUser'="" OrderRevokeUser=$p($g(^SSU("SSUSR",OrderRevokeUser)),"^",1) 
		s OEORIMainXML=""
		s OrdItemStr=Priority_"^"_ArcimDesc_"^"_OrdCreateDate_"^"_OrdCreateTime_"^"_OrdStartDate_"^"_OrdStartTime
		s OrdItemStr=OrdItemStr_"^"_DoseQty_"^"_DoseUnit_"^"_Freq_"^"_Instr_"^"_Dura_"^"_PhQtyOrd_"^"_BaseUOM_"^"_QtyPackUOM_"^"_BillUOM_"^"_OrdStatus
		s OrdItemStr=OrdItemStr_"^"_SeqNo_"^"_OrdLoc_"^"_UserDepartment_"^"_RecDep_"^"_Doctor_"^"_UseAdd
		s OrdItemStr=OrdItemStr_"^"_OrdOEORIDR_"^"_FirstTimes_"^"_BillType
		s OrdItemStr=OrdItemStr_"^"_ArcosId_"^"_OrdSkinTest_"^"_PrescNo_"^"_LabEpisodeNo
		s OrdItemStr=OrdItemStr_"^"_CoverMainIns_"^"_StopDoctor_"^"_StopDate_"^"_StopTime
		s OrdItemStr=OrdItemStr_"^"_OrderRevokeDate_"^"_OrderRevokeTime_"^"_OrderRevokeUser_"^"_OrdEndDate_"^"_OrdEndTime
		d ..GetOEORIMainXML(OrdItemStr,OperationType,.OEORIMainXML)
		s TempOEORIMainXML=OperationType_$c(1)_OEORIMainXML
		s OEORIMainXML="",PreOEORIMainXML=""
		///A 下医嘱,S 停医嘱,E 执行医嘱,I 作废医嘱,C 审核抗生素生效,O 其它,P 预停医嘱
		if ((OperationType="A")||(OperationType="S"))&&(OrdEndDate'="")  d
		.d ..GetOEORIMainXML(OrdItemStr,"P",.OEORIMainXML)
		.s PreOEORIMainXML="P"_$c(1)_OEORIMainXML
		s:PreOEORIMainXML'="" TempOEORIMainXML=TempOEORIMainXML_$c(2)_PreOEORIMainXML
		q TempOEORIMainXML
	}
}

ClassMethod GetOEORIMainXML(OrdItemStr As %String, OperationType As %String = "", ByRef OEORIMainXML As %String = "") As %String
{
	n (OrdItemStr,OperationType,OEORIMainXML)
	i OperationType=""  s OperationType="A"
	i OperationType="A"  
	{
	s Object=##class(web.DHCEntity.DHCDocOEORIMain).%New()
	s Object.Priority=$p(OrdItemStr,"^",1)
	s Object.ArcimDesc=$p(OrdItemStr,"^",2)
	s Object.OrdCreateDate=$p(OrdItemStr,"^",3)
	s Object.OrdCreateTime=$p(OrdItemStr,"^",4)
	s Object.OrdStartDate=$p(OrdItemStr,"^",5)
	s Object.OrdStartTime=$p(OrdItemStr,"^",6)
	s Object.DoseQty=$p(OrdItemStr,"^",7)
	s Object.DoseUnit=$p(OrdItemStr,"^",8)
	s Object.Freq=$p(OrdItemStr,"^",9)
	s Object.Instr=$p(OrdItemStr,"^",10)
	s Object.Dura=$p(OrdItemStr,"^",11)
	s Object.PhQtyOrd=$p(OrdItemStr,"^",12)
	s Object.BaseUOM=$p(OrdItemStr,"^",13)
	s Object.QtyPackUOM=$p(OrdItemStr,"^",14)
	s Object.BillUOM=$p(OrdItemStr,"^",15)
	s Object.SeqNo=$p(OrdItemStr,"^",17)
	s Object.OrdDept=$p(OrdItemStr,"^",18)
	s Object.UserDepartment=$p(OrdItemStr,"^",19)
	s Object.RecDep=$p(OrdItemStr,"^",20)
	s Object.Doctor=$p(OrdItemStr,"^",21)
	s Object.UseAdd=$p(OrdItemStr,"^",22)
	s Object.OrdOEORIDR=$p(OrdItemStr,"^",23)
	s Object.FirstTimes=$p(OrdItemStr,"^",24)
	s Object.BillType=$p(OrdItemStr,"^",25)
	s Object.ArcosId=$p(OrdItemStr,"^",26)
	s Object.OrdSkinTest=$p(OrdItemStr,"^",27)
	s Object.PrescNo=$p(OrdItemStr,"^",28)
	s Object.LabEpisodeNo=$p(OrdItemStr,"^",29)
	s Object.CoverMainIns=$p(OrdItemStr,"^",30)
	d Object.XMLExportToString(.OEORIMainXML)
	}elseif (OperationType="S"){
	s Object=##class(web.DHCEntity.DHCDocOEORIMain).%New()
	s Object.OrdStopDoctor=$p(OrdItemStr,"^",31)
	s Object.OrdStopDate=$p(OrdItemStr,"^",32)
	s Object.OrdStopTime=$p(OrdItemStr,"^",33)
	s Object.ArcimDesc=$p(OrdItemStr,"^",2)
	d Object.XMLExportToString(.OEORIMainXML)	
	}elseif (OperationType="I"){
	s Object=##class(web.DHCEntity.DHCDocOEORIMain).%New()
	s Object.OrdRevokeUser=$p(OrdItemStr,"^",34)
	s Object.OrdRevokeDate=$p(OrdItemStr,"^",35)
	s Object.OrdRevokeTime=$p(OrdItemStr,"^",36)
	s Object.ArcimDesc=$p(OrdItemStr,"^",2)
	d Object.XMLExportToString(.OEORIMainXML)	
	}elseif (OperationType="P"){
	s Object=##class(web.DHCEntity.DHCDocOEORIMain).%New()
	s Object.OrdStopDoctor="" //$p(OrdItemStr,"^",21)  滚医嘱时预停 看有没有置停医嘱医生 
	s Object.OrdStopDate=$p(OrdItemStr,"^",37)
	s Object.OrdStopTime=$p(OrdItemStr,"^",38)
	s Object.ArcimDesc=$p(OrdItemStr,"^",2)
	d Object.XMLExportToString(.OEORIMainXML)	
	}
	Q OEORIMainXML
}

/// 判断CA是否开放  调用电子病历接口控制科室,也可以控制用户
/// Debug:         w ##Class(web.DHCDocSignVerify).GetCAServiceStatus(62,24170) 
ClassMethod GetCAServiceStatus(LocID As %String, UserID As %String = "") As %String
{
	set $ZTRAP = "SOAPError"
	s ret=##class(CA.DigitalSignatureService).IsCACTLoc(LocID, UserID)
    ;s ret=##Class(CA.DigitalSignatureService).GetCAServiceStatus(LocID)
    q:ret'="1" 0
 	s:UserID'="" DoctorType=##class(web.SSUser).GetDefaultCareProviderType(UserID)
 	;Q:$G(DoctorType)'="DOCTOR" 0 
	q 1
SOAPError
  quit 0
}

/// Creator:nk
/// CreateDate:
/// Description:通过UserID获取签名图
/// Input:用户ID
/// Output:指定用户签名图的Base64字符串，若指定用户未绑定有效UKey，则返回空值
/// Debug:w ##class(web.DHCDocSignVerify).GetImageByUserID(para)
ClassMethod GetImageByUserID(UserID As %String)
{
	Q ##class(CA.BICAService).GetImageByUserID(UserID)
}

/// d ##class(%ResultSet).RunQuery("web.DHCDocSignVerify","FindNeedCASignOrder",94,4634,"ALL")
Query FindNeedCASignOrder(EpisodeID As %String, UserID As %String, ViewAll As %String) As websys.Query(ROWSPEC = "OrderId:%String,StDate:%String,Doctor:%String,StopDate:%String,StopDoctor:%String,ItemStatDesc:%String,OrderDesc:%String,OperationTypList:%String")
{
}

ClassMethod FindNeedCASignOrderExecute(ByRef qHandle As %Binary, EpisodeID As %String, UserID As %String, ViewAll As %String) As %Status
{
	set repid = $I(^CacheTemp)
	if $g(ind) = "" set ind = 0
	s OrderID=$o(^OEORD(0,"Adm",EpisodeID,""))
	s SubID=0
	for {
		s SubID=$O(^OEORD(OrderID,"I",SubID))
		q:(SubID="")
		continue:'$D(^OEORD(OrderID,"I",SubID,1))
		s UserAdd=$p($g(^OEORD(OrderID,"I",SubID,7)),"^",1)
		s DoctorID=$p(^OEORD(OrderID,"I",SubID,1),"^",11)
		continue:(ViewAll'="ALL")&&(UserAdd'="")&&(UserAdd'=UserID)
		s OrderStatusDR=$p(^OEORD(OrderID,"I",SubID,1),"^",13)
		s:+OrderStatusDR>0 ItemStatCode = $p(^OEC("OSTAT",OrderStatusDR),"^",1)
		///A 下医嘱,S 停医嘱,E 执行医嘱,I 作废医嘱,C 审核抗生素生效,O 其它,P 预停医嘱
		i (ItemStatCode="V")||(ItemStatCode="E"){
			s OperationTypList="A"
		}elseif (ItemStatCode="D"){
			s OperationTypList="AS"
		}elseif (ItemStatCode="U"){
			continue
			s OperationTypList="AI"
		}else{
			continue
		}
		s SVRowid=""
		for {
			s SVRowid=$O(^DHCDocSignVerify(0,"OEORI",OrderID_"||"_SubID,SVRowid))
			q:(SVRowid="")
			s OperationType=$P(^DHCDocSignVerify(SVRowid),"^",9)
			s OperationTypList=$replace(OperationTypList,OperationType,"")
			
		}
		continue:(OperationTypList="")
		s OrderId=OrderID_"||"_SubID
		continue:('##class(web.DHCDocMainOrderInterface).IsOrdBillOE(OrderID,SubID)) /// 医嘱单
		s StDate = ..%ZD($p(^OEORD(OrderID,"I",SubID,1),"^",9))
		s StTime = ..%ZT($p(^OEORD(OrderID,"I",SubID,1),"^",10),1)
		s StDate=StDate_" "_StTime
		s ItemStatDesc=$p(^OEC("OSTAT",OrderStatusDR),"^",2)
		s DoctorDr=$p(^OEORD(OrderID,"I",SubID,1),"^",11)
		i DoctorDr'="" s Doctor=$p(^CTPCP(DoctorDr,1),"^",2)
		
		s StopDate = $p($G(^OEORD(OrderID,"I",SubID,3)),"^",34)
		s StopTime = $p($G(^OEORD(OrderID,"I",SubID,2)),"^",15)
		s:StopDate'="" StopDate=..%ZD(StopDate) //$zd(TStopDate,3)
		s:StopTime'="" StopTime=..%ZT(StopTime,2) 
		s StopDate=StopDate_" "_StopTime
		s StopDoctorDR = $p($G(^OEORD(OrderID,"I",SubID,3)),"^",29)
		s:+StopDoctorDR>0 StopDoctor = $p(^CTPCP(StopDoctorDR,1),"^",2)
		s ItmMastDR = $p($G(^OEORD(OrderID,"I",SubID,1)),"^",2)
		s OrderDesc=$p(^ARCIM(+ItmMastDR,$p(ItmMastDR,"||",2),1),"^",2)
		d OutPutNeedCAOrder
	}
	
	
	set qHandle = $lb(0,repid,0)
	Q $$$OK
Initialize
	s (OrderId,StDate,Doctor,StopDate,StopDoctor,ItemStatDesc,OrderDesc,OperationTypList)=""
	q
OutPutNeedCAOrder
	s ind=ind+1
	s ^CacheTemp(repid,ind) = $lb(OrderId,StDate,Doctor,StopDate,StopDoctor,ItemStatDesc,OrderDesc,OperationTypList)
	q
}

}
