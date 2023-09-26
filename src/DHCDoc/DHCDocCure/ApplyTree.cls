Class DHCDoc.DHCDocCure.ApplyTree Extends DHCDoc.Util.RegisteredObject
{

/// 生成治疗申请单  审核单和医嘱一对一  
/// 1.生成申请单,先预生成申请单,医嘱审核后,更新关联的医嘱ID
/// 2.待更新字段:DCAOEORIDR  DCAApplyExec
/// w ##class(DHCDoc.DHCDocCure.ApplyTree).CreateCureApply("781","3073||1","90","12175","","","2","1")
ClassMethod CreateCureApply(EpisodeID As %String, ArcimID As %String, ReLocId As %String, UserID As %String, ApplyPlan As %String, ApplyRemark As %String, HospID As %String, AssScaleID As %String = "", POAJson As %String = "", ExpStr As %String = "") As %String
{
	s ^TMP("SaveCureApply")=$lb(EpisodeID,ArcimID,ReLocId,UserID,ApplyPlan,ApplyRemark,HospID,AssScaleID,POAJson,ExpStr)
	Quit:EpisodeID="" 100
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	s DoSourceType=""
	if ExpStr'=""{
		s DoSourceType=$p(ExpStr,"^",1)	
	}
	s err=0
	Ts
	if AssScaleID'=""{
		s PatientID=$P(^PAADM(EpisodeID),"^",1)
		k PLIST
		s PLIST(2)=EpisodeID
		s PLIST(3)=PatientID
		s PLIST(4)=NowDate
		s PLIST(5)=NowTime
		s PLIST(6)=UserID
		s PLIST(7)="D"
		s PLIST(8)=AssScaleID
		s PLIST(11)="A"
		&sql(insert into SQLUser.DHC_DocCureAssScore values :PLIST())
		s ErrMsg="插入治疗评定表失败"_"$"_EpisodeID_","_AssScaleID_","_UserID
	}else{
	    s CureItemFlag=##class(DHCDoc.DHCDocCure.Service).CheckItem(ArcimID,ReLocId)
	    Quit:(CureItemFlag'=1) 100
		
		Lock ^DHCDocCureApply("NO",+$H)
		s NO=$I(^DHCDocCureApply("NO",+$H))
		Lock -^DHCDocCureApply("NO",+$H)
		s DCANO=$tr($ZD(NowDate,3),"-","")_$E("0000",1,4-$L(NO))_NO ;申请单号
		s ApplyExec="N"
		s IsGenExeFlag=0 ;$$CureItemIsGenExe^DHCOEOrdExec(OrderId)
		if IsGenExeFlag=0 s ApplyExec="Y"
		i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")	
		s AppAllowExec=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig("","CureLocAppAllowExec",ReLocId,HospID)
		if AppAllowExec=1 s AppAllowExec="Y"
		else  s AppAllowExec="N"
		;1.新增申请单
		k PLIST
		s PLIST(2)=EpisodeID
		s PLIST(3)=""
		s PLIST(4)="A"
		s PLIST(5)=UserID
		s PLIST(6)=NowDate
		s PLIST(7)=NowTime
		s PLIST(11)=ApplyRemark
		s PLIST(12)=ApplyPlan
		s PLIST(19)=DCANO
		s PLIST(20)=ApplyExec
		s PLIST(21)=AppAllowExec
		s PLIST(26)=ReLocId
		s PLIST(27)=DoSourceType
		b ;PLIST
		&sql(insert into SQLUser.DHC_DocCureApp values :PLIST())
		s ErrMsg="插入治疗申请表失败"_"$"_EpisodeID_","_""_","_UserID
	}
	if SQLCODE 
	{
		Tro
		s err=SQLCODE
		d ##class(DHCDoc.Log.Common).General("Insert","DHCDoc.DHCDocCure.Apply","CreateCureApply",ErrMsg,"",err) 
		Q err
	}else{
		s CureAppID=%ROWID
		s ErrMsg=""
		if POAJson'=""{
			d ##class(DHCDoc.Util.FromJSON).FromJSONToArr(POAJson,.POAJsonArr)	
			s loop=0
			for{
				s loop=$o(POAJsonArr(loop))	
				Q:loop=""
				s CPGSRowid=POAJsonArr(loop,"CPGSRowid")
				s CPSRowid=POAJsonArr(loop,"CPSRowid")
				if CPSRowid["-"{
					s CPSRowid=$p(CPSRowid,"-",3)	
				}
				k PLISTP
				s PLISTP(2)=CureAppID
				s PLISTP(3)=CPSRowid
				s PLISTP(4)=CPGSRowid
				&sql(insert into SQLUser.DHC_DocCure_AppPart values :PLISTP())
				
				if SQLCODE{
					s ErrMsg="插入治疗申请部位穴位表失败:"_SQLCODE
					Q	
				}
			}
			if ErrMsg'=""{
				Tro
				Q ErrMsg
			}
		}	
	}
	Tc
  	Q err_"^"_$g(CureAppID)
}

/// Description: 	医嘱审核成功后将医嘱ID更新至治疗申请单,前台无法将绑定的医嘱与治疗医嘱进行关联,,但又需要有所关联,方便停医嘱找得到,启用OE_OrdItemExt表的OEORIServiceOrdDR字段
/// Input:			DCARowId:ChildDCA & MainDCA
/// 				ChildDCA ChildDCA#AssScaleID 包含当前(绑定关联的)医嘱的治疗申请ID(DCARowID)#治疗评定申请ID
/// 	     		MainDCA  MainDCA#AssScaleID  被关联的治疗申请ID(MainDCARowID,绑定的医嘱可能不会生成治疗申请)#治疗评定申请ID
/// Dubug:w ##class(DHCDoc.DHCDocCure.ApplyTree).GetCureApply(867)
ClassMethod CureApplyRelateOrder(DCARowId As %String, OrderID As %String) As %String
{
	s ret=0
	Quit:(DCARowId="")||(OrderID="") ret
	s MainDCARowID=$p(DCARowId,"&",2)
	s DCARowId=$p(DCARowId,"&",1)
	s UserAdd=$p($g(^OEORD(+OrderID,"I",$p(OrderID,"||",2),7)),"^",1)
	if DCARowId'=""{
		s AssScaleID=$p(DCARowId,"#",2)
		s DCARowId=$p(DCARowId,"#",1)
		if AssScaleID'=""{
			s ToCDRType="CUREASP"
			k PLIST
			s PLIST(10)=OrderID
			&sql(update SQLUser.DHC_DocCureAssScore values :PLIST() where DCAS_RowID=:DCARowId)
			s ret=SQLCODE
		}elseif DCARowId'=""{
			s ToCDRType="CUREAP"
			;更新申请单
			s ApplyExec="N"
			s IsGenExeFlag=##class(DHCDoc.DHCDocCure.Service).CureItemIsGenExe(OrderID)
			if IsGenExeFlag=0 s ApplyExec="Y"
			s OrderRecLocID=$p($g(^OEORD(+OrderID,"I",$p(OrderID,"||",2),3)),"^",6)
			s OrderDepProcNotes=$g(^OEORD(+OrderID,"I",$p(OrderID,"||",2),"DEP",1))
			s ApplyRemarks=$p($g(^DHCDocCure(DCARowId)),"^",10)
			s DoSourceType=$p($g(^DHCDocCure(DCARowId)),"^",23)
			s Notes=""
			if DoSourceType="OEOrdEntry"{
				;医嘱录入[治疗申请]按钮弹出,备注以医嘱备注为准
				s Notes=OrderDepProcNotes
			}elseif DoSourceType="OEOrdEntryUpdate"{
				;医嘱录入审核弹出,备注以治疗备注为准
				s Notes=ApplyRemarks
			}
			if Notes=""{
				s:OrderDepProcNotes'="" Notes=OrderDepProcNotes
				s:ApplyRemarks'="" Notes=ApplyRemarks
			}
			s OrderDepProcNotes=$lb(Notes)
			
			k PLIST
			s PLIST(3)=OrderID
			s PLIST(11)=Notes
			s PLIST(20)=ApplyExec
			s PLIST(26)=OrderRecLocID
			&sql(update SQLUser.DHC_DocCureApp values :PLIST() where DCA_RowId=:DCARowId)
			&sql(update SQLUser.OE_OrdItem set OEORI_DepProcNotes=:OrderDepProcNotes where OEORI_RowId=:OrderID)	
			s ret=SQLCODE
		}
		if $g(ToCDRType)'=""{
			s CDRPara=+DCARowId_"^^"_""_"^"_ToCDRType_"^"_UserAdd
			Job ##class(DHCDoc.DHCDocCure.Invoke).InputDataToCDR(CDRPara)
		}
	}
	;MainDCARowID不为空,说明是绑定关联的医嘱,需要更新OE_OrdItemExt表的OEORIServiceOrdDR字段
	;需要保证治疗医嘱是先插入的,否则ServiceOrdDR可能找不到
	if MainDCARowID'=""{
		s MainDCARowID=$p(MainDCARowID,"#",1)
		s ServiceOrdDR=$p($g(^DHCDocCure(MainDCARowID))	,"^",2)
		if ServiceOrdDR'=""{
			&sql(update SQLUser.OE_OrdItem set OEORI_OEORI_DR=:ServiceOrdDR where OEORI_RowId=:OrderID)	
			&sql(update SQLUser.OE_OrdItemExt set OEORI_ServiceOrd_DR=:ServiceOrdDR,OEORI_BindSource="CA" where OEORI_RowId=:OrderID)	
			s ret=SQLCODE
		}
	}
	Q ret
}

ClassMethod UpdateOrderStr(EpisodeID As %String, OrderStr As %String, LogonHosp As %String = "")
{
	s fOrderStr=""
	s OutOrderPriorRowid=$O(^OECPR(0,"Code","OUT",0))
	s IPDefaultDurRowId=##Class(web.DHCDocConfig).GetConfigNode("IPDefaultDuration",LogonHosp)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s OrderStrLen=$l(OrderStr,$c(1))
	for OrderCount=1:1:OrderStrLen{
		s oneOrderStr=$p(OrderStr,$c(1),OrderCount)
		s ArcimRowid=$p(oneOrderStr,"^",1)
		s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatRowid,LogonHosp,ArcimRowid)
		i OrderType="R"{
			i PHPrescType="" s PHPrescType="1"
		}
		s PriorRowid=$p(oneOrderStr,"^",3)
		s PriorFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorRowid)
		if (PAAdmType="I"){
			if (PriorFlag'="1")&&(OutOrderPriorRowid'=PriorRowid){
		        s $p(oneOrderStr,"^",16)=IPDefaultDurRowId
			}
		}
		s OrderDate=$zd(+$h,4)
		s OrderTime=$zt($p($h,",",2),1)
		s OrderDate=$p(oneOrderStr,"^",46)
		s OrderTime=$p(oneOrderStr,"^",47)
		if OrderDate'="" s OrderDate=##class(websys.Conversions).DateHtmlToLogical(OrderDate)
		else  s OrderDate=+$h
		if OrderTime'="" s OrderTime=$zth(OrderTime,1)
		else  s OrderTime=$p($h,",",2)
		s OrderStartDate=$p(oneOrderStr,"^",4)
		s OrderStartTime=$p(oneOrderStr,"^",5)
		s OrderStartDate=##class(websys.Conversions).DateHtmlToLogical(OrderStartDate)
		s OrderStartTime=$zth(OrderStartTime,1)
		if (OrderStartDate<OrderDate)!((OrderStartDate=OrderDate)&&(OrderStartTime<OrderTime)){
			s OrderDate=OrderStartDate
			s OrderTime=OrderStartTime
		}
		s $p(oneOrderStr,"^",46)=##class(websys.Conversions).DateLogicalToHtml(OrderDate)
		s $p(oneOrderStr,"^",47)=$zt(OrderTime,1)
		s OrderRecDepRowid=$p(oneOrderStr,"^",8)
		s OrderPackUOMRowid=$p(oneOrderStr,"^",55)
		s UnitPrice=##class(DHCDoc.DHCDocCure.Apply).GetPrice(EpisodeID,ArcimRowid,OrderRecDepRowid,OrderPackUOMRowid,"")
		s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
		s OrderCoverMainIns="N"
		s $p(oneOrderStr,"^",2)=OrderType
		s $p(oneOrderStr,"^",7)=UnitPrice
		s $p(oneOrderStr,"^",10)=OrderDrugFormRowid
		s $p(oneOrderStr,"^",18)=PHPrescType
		if fOrderStr=""{
			s fOrderStr=oneOrderStr	
		}else{
			s fOrderStr=fOrderStr_$c(1)_oneOrderStr	
		}
	}
	Q fOrderStr
}

/// w ##class(DHCDoc.DHCDocCure.ApplyTree).InsertCureApply($lg(^tmpnk("InsertCureApply"),1),$lg(^tmpnk("InsertCureApply"),2),$lg(^tmpnk("InsertCureApply"),3),$lg(^tmpnk("InsertCureApply"),4),$lg(^tmpnk("InsertCureApply"),5),$lg(^tmpnk("InsertCureApply"),6))
ClassMethod InsertCureApply(EpisodeID, OrderStr, USERID, CTLOCID, GroupID, ExpStr)
{
	s ^tmplog("InsertCureApply")=$lb(EpisodeID,OrderStr,USERID,CTLOCID,GroupID,ExpStr)
	s PPRowId=$P(ExpStr,"^",1)
	s LogonDep=$p(ExpStr,"^",2)
	s LogonHosp=$P(ExpStr,"^",3)
	s NotAdmTypeLimit=$P(ExpStr,"^",4)

	;s ChkRet=##class(DHCDoc.DHCDocCure.Apply).CheckAfterInit(EpisodeID,USERID_"^"_CTLOCID_"^"_GroupID,"",NotAdmTypeLimit)
	;q:ChkRet'=0 "-1!"_ChkRet
	
	s OrderStr=..UpdateOrderStr(EpisodeID, OrderStr,LogonHosp)
	s DocID=$p(^SSU("SSUSR",USERID),"^",14)
	s LogonLocAdmTypeLimit="Y"
	s ErrMsg=""
	s insret="0"
	s OrderOpenForAllHosp="" 
	s AutoVirtualLongInsertFlag="" ;虚拟长期自动生成标志
	s OrdStr=""
	S NewExpStr="0^^^Y^"_PPRowId_"^"_LogonDep_"^"_OrderOpenForAllHosp_"^"_AutoVirtualLongInsertFlag_"^"_NotAdmTypeLimit
	s Ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(EpisodeID,OrderStr,USERID,CTLOCID,DocID,"",NewExpStr,.ErrMsg)
	b ;Ret
	If (Ret'=0)&&(Ret'=100){
		f k=1:1:$l(Ret,"^")-1 {
			s OrdID=$p($p(Ret,"^",k),"*",2)
			i OrdID="" continue
			if OrdStr="" s OrdStr=$p(Ret,"^",k)
			else  s OrdStr=OrdStr_"^"_$p(Ret,"^",k)
		}
	}else{
		s insret="100!"_..%Translate("doccure.applytree.hui.csp","治疗申请失败,保存医嘱失败")_":"_ErrMsg
	}

	q insret_"!"_OrdStr
}

/// CreatDate:    2019.06.30
/// Description:  得到将审核医嘱中需要做治疗申请的医嘱项目与序号
/// Table:       
/// Input:        InStr:将审核医嘱字符串
/// Others:       为需要手动申请的自动弹出治疗申请单,自动申请的将在审核医嘱后调用web.DHCOEOrdItem.SaveDHCDocCureApply方法插入申请单
/// Return:       需要做治疗申请的数据, 空
/// Debug: w ##class(DHCDoc.DHCDocCure.ApplyTree).GetCureItemARCIMStr("3078","6438||1^N^3^2019-08-14^19:05:41^^10.0000^10^1^^^^^2^9^0^^4^^1^N^^N^^^^^^^N^^^0^^^^undefined^^^^^^^^^2019-08-14^19:05:41^N^^^^^N^^116^^N^^^^^^^^N^1^^0^N^^^20.00","11103","10")
ClassMethod GetCureItemARCIMStr(EpisodeID As %String, OrderItemStr As %String, DoctorID As %String, LocID As %String, HospID As %String = "") As %String
{
	s ^tmplog("GetCureItemARCIMStr")=$lb(EpisodeID,OrderItemStr,DoctorID,LocID,HospID)
	s ARCIMStr=""
	Q:OrderItemStr="" ""
	i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	Set OrdItemCount=$L(OrderItemStr,$c(1))
	for i=1:1:OrdItemCount {
		s OrdItem=$p(OrderItemStr,$c(1),i)
		continue:OrdItem=""
		s ARCIMRowid=$p(OrdItem,"^",1)
		continue:ARCIMRowid=""
		s OrderMasterSeqNo=$p(OrdItem,"^",19)
		s OrderSeqNo=$p(OrdItem,"^",20)
		s RecDepRowid=$p(OrdItem,"^",8)
		s OrderDHCAADr=$p(OrdItem,"^",60)
		continue:OrderDHCAADr'="" ;已经生成治疗申请的不需要再弹出
		s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	    s CureItemFlag=##class(DHCDoc.DHCDocCure.Service).CheckItem(ARCIMRowid,RecDepRowid)
    	continue:(CureItemFlag'=1)
	    
	    ;取用是否手动申请配置
		s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ARCIMRowid,HospID)
		s ManualApply=""
		if DDCISRowid'=""{
			s ManualApply=$p(^DHCDocCureItemSet(DDCISRowid),"^",8)
		}
		continue:ManualApply'="Y"
		if ARCIMStr=""{
			s ARCIMStr=OrdItem	
		}else{
			s ARCIMStr=ARCIMStr_$c(1)_OrdItem	
		}
	}
	s BaseInfo=EpisodeID_"^"_DoctorID_"^"_LocID
	;if ARCIMStr'="" s ARCIMStr=BaseInfo_"!"_ARCIMStr
	s Job=""
    if ARCIMStr'=""{
        S Job=$J
        s ^TMP("DHCDoc.DHCDocCure.ApplyTree","GetCureItemARCIMStr",Job,EpisodeID,DoctorID)=ARCIMStr
    }
    Q Job
}

ClassMethod GetCureItemARCIMInfo(OrderItemStr As %String, HospID As %String = "", langid As %String = "")
{
	Q:OrderItemStr="" ""
	i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	i ($g(langid)="")&&($d(%session)) s langid=%session.Get("LOGON.LANGID")
	s HOSPCode=$p(^CT("HOSP",HospID),"^",1)
	s CureItemARCIMInfo=""
	Set OrdItemCount=$L(OrderItemStr,$c(1))
	for i=1:1:OrdItemCount {
		s OrdItem=$p(OrderItemStr,$c(1),i)
		continue:OrdItem=""
		s ARCIMRowid=$p(OrdItem,"^",1)
		continue:ARCIMRowid=""
		s OrderMasterSeqNo=$p(OrdItem,"^",19)
		s OrderSeqNo=$p(OrdItem,"^",20)
		s RecDepRowid=$p(OrdItem,"^",8)
		s OrderDHCAADr=$p(OrdItem,"^",60)
		continue:OrderDHCAADr'="" ;已经生成治疗申请的不需要再弹出
		set ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		set OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
		set ARCIMDesc=##class(web.DHCDocOrderCommon).GetFormateOrderName(ARCIMRowid)
		set ARCIMDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ARCIMDesc,langid)
		set PHPrescType=$p(OrdItem,"^",18)
		set INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
		set OrderPackUOMRowid=$p(OrdItem,"^",55)
		set ConFac=1	
		if (INCIRowid'="") {
			set ConFac=##class(web.DHCDocOrderEntry).GetConFac(ARCIMRowid,INCIRowid,OrderPackUOMRowid)
		}
		set CureItemConFac=ConFac
		set OrderType=$p(OrdItem,"^",2)	
		set OrderDoseStr=##class(DHCDoc.DHCDocCure.Config).GetDoseStr(ARCIMRowid)
		set PriorRowid=$p(OrdItem,"^",3)
		If PriorRowid="" Set PriorRowid=$o(^OECPR(0))
		set PriorDesc=$p($g(^OECPR(PriorRowid)),"^",2)
		set PriorDesc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",PriorDesc,langid)
		set FreqStr=""
		set FreqRowid=$p(OrdItem,"^",15)
		set FreqDispTimeStr=$p(OrdItem,"^",67) ;周频次对应的使用周信息
		set FreqFreeTimeStr=$p(OrdItem,"^",83) ;不规则频次分发时间列表
		set PHCFRFactor="",PHCFRDesc="",PHCFRInterval=""
		if +FreqRowid>0 {
			s PHCFRFactor=$P(^PHCFR(FreqRowid),"^",2)
			s PHCFRDesc=$P(^PHCFR(FreqRowid),"^",3)
			s PHCFRInterval=$P(^PHCFR(FreqRowid),"^",5)
			s PHCFRDesc=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",PHCFRDesc,langid)
			if (FreqDispTimeStr'="")||(FreqFreeTimeStr'="") {
				s tmpFreqDispTimeStr=##Class(web.DHCOEOrdItem).GetOrderFreqDispTimeStr(FreqRowid,FreqDispTimeStr,##Class(web.DHCOEOrdItem).FormFreqFreeTimeHtmlToLogical(FreqFreeTimeStr))
				s FreqDispTimeStr=tmpFreqDispTimeStr
				s FreqDispTimeStr=$replace(FreqDispTimeStr,$c(1),"^")
				s FreqDispTimeStr=$replace(FreqDispTimeStr,$c(2),"#")
				if (tmpFreqDispTimeStr'=""){
					s OrderFreqOtherInfo=##Class(web.DHCOEOrdItem).GetOrderFreqOtherInfo(FreqRowid,tmpFreqDispTimeStr)
					s PHCFRDesc=PHCFRDesc_" "_OrderFreqOtherInfo
				}
			}
			s FreqStr=FreqRowid_$c(1)_PHCFRFactor_$c(1)_PHCFRDesc_$c(1)_PHCFRInterval
		}
		
		set DurStr=""
		set PHCDurFactor="",PHCDurDesc=""
		set DurRowid=$p(OrdItem,"^",16)
		if +DurRowid>0{
			s PHCDurFactor=$P(^PHCDU(DurRowid),"^",2)
			s PHCDurDesc=$P(^PHCDU(DurRowid),"^",1)
			s PHCDurDesc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",PHCDurDesc,langid)
			s DurStr=DurRowid_$c(1)_PHCDurFactor_$c(1)_PHCDurDesc
		}
		
		set PackQty=$p(OrdItem,"^",6)
		if OrderType'="R"{s PackQty=$p(OrdItem,"^",14)}
		set RecDepRowid=$p(OrdItem,"^",8)
		set RecDepDesc=##class(web.DHCDocOrderCommon).GetLocDesc(RecDepRowid)
		set OrderDepProcNotes=$p(OrdItem,"^",11)
		set DoseQty=$p(OrdItem,"^",12)
		set DoseUOMRowid=$p(OrdItem,"^",13)
		set startdate=$p(OrdItem,"^",4)
		set starttime=$p(OrdItem,"^",5)
		set startdate=startdate_" "_starttime
		set OrderCoverMainIns=$p(OrdItem,"^",23)
		set Enddate=$p(OrdItem,"^",26)
		set Endttime=$p(OrdItem,"^",27)
		set:Enddate'="" Enddate=Enddate_" "_Endttime
		set AdmReason=$replace($p(OrdItem,"^",9),$c(10),"")
		set FirstDayTimes=$p(OrdItem,"^",33)
		set FindRecLocByLogonLocFlag=$p(OrdItem,"^",68)
		set OrderSum=$p(OrdItem,"^",72)
		set ChronicDiagCode=$p(OrdItem,"^",82)
		set OrderOpenForAllHosp=$p(OrdItem,"^",92)
		set ChronicInfo=##class(insuqc.service.ServicePort).GetChronicNameByCode(ChronicDiagCode, AdmReason, HOSPCode)
		set OrderChronicDiagDesc=$p(ChronicInfo,"^",2)      //病种描述
		set DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ARCIMRowid,HospID)
		set OrderDate=$p(OrdItem,"^",46)
		set OrderTime=$p(OrdItem,"^",47)
		set:OrderDate'="" OrderDate=OrderDate_" "_OrderTime
		set HiddenParaObj={}
		set HiddenParaObj.FindRecLocByLog=FindRecLocByLogonLocFlag
		set HiddenParaObj.OpenForAllHosp=OrderOpenForAllHosp
		set JsonData={}
		do JsonData.%Set("CureItemRowid",ARCIMRowid)
		do JsonData.%Set("CureItemArcDesc",ARCIMDesc)
		do JsonData.%Set("OrderPHPrescType",PHPrescType)
		do JsonData.%Set("CureItemConFac",CureItemConFac)
		do JsonData.%Set("OrderType",OrderType)
		do JsonData.%Set("OrderDoseStr",OrderDoseStr)
		do JsonData.%Set("CureItemPrior",PriorDesc)
		do JsonData.%Set("CureItemPriorRowid",PriorRowid)
		do JsonData.%Set("CureItemFreq",$g(PHCFRDesc))
		do JsonData.%Set("CureItemFreqRowid",FreqRowid)
		do JsonData.%Set("CureItemFreqInterval",$g(PHCFRInterval))
		do JsonData.%Set("CureItemFreqFactor",$g(PHCFRFactor))
		do JsonData.%Set("CureItemFreqDispTimeStr",$g(FreqDispTimeStr))
		do JsonData.%Set("CureItemDurRowid",DurRowid)
		do JsonData.%Set("CureItemDur",$g(PHCDurDesc))
		do JsonData.%Set("CureItemDurFactor",$g(PHCDurFactor))
		do JsonData.%Set("CureItemDoseQty",DoseQty)
		do JsonData.%Set("CureItemDoseUOM",DoseUOMRowid)
		do JsonData.%Set("CureItemRecLocRowid",RecDepRowid)
		do JsonData.%Set("CureItemRecLoc",RecDepDesc)
		do JsonData.%Set("CureItemPackQty",PackQty)
		do JsonData.%Set("CureItemPackUOM",OrderPackUOMRowid)
		do JsonData.%Set("CureItemPrice",OrderSum)
		do JsonData.%Set("CureItemStartDate",startdate)
		do JsonData.%Set("CureItemEndDate",Enddate)
		do JsonData.%Set("CureItemBillTypeRowId",AdmReason)
		do JsonData.%Set("CureItemFirstDayTimes",FirstDayTimes)
		do JsonData.%Set("DDCISRowid",DDCISRowid)
		do JsonData.%Set("CureItemSeqNo",OrderSeqNo)				
		do JsonData.%Set("CureItemMasterSeqNo",OrderMasterSeqNo)				
		do JsonData.%Set("CureItemCoverMainIns",OrderCoverMainIns)
		do JsonData.%Set("CureItemChronicDiagCode",ChronicDiagCode)	
		do JsonData.%Set("CureItemOrderChronicDiagDesc",OrderChronicDiagDesc)				
		do JsonData.%Set("CureItemOrderDate",OrderDate)
		do JsonData.%Set("CureItemApplyRemark",OrderDepProcNotes)
		do JsonData.%Set("CureItemHiddenPara",HiddenParaObj)
		s JsonInfo=""
		s obj=##class(%Stream.GlobalCharacter).%New()
		do JsonData.%ToJSON(obj)
		While 'obj.AtEnd { 
			s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
		}
		;s JsonInfo=$replace(JsonInfo,"""","'")
		s JsonInfo=##class(ext.util.String).EvalJSON(JsonInfo)
		s JsonInfo=##class(ext.util.String).Replace(JsonInfo,"'", "\'")
		s OutOneARCIMStr=JsonInfo
		i CureItemARCIMInfo="" {
			s CureItemARCIMInfo=OutOneARCIMStr
		}else{
			s CureItemARCIMInfo=CureItemARCIMInfo_"@"_OutOneARCIMStr
		}
	}
	
	q CureItemARCIMInfo
}

ClassMethod GetInciRowid(ARCIMRowid)
{
	s ItemCatDR=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ARCIMRowid)
	q OrderType_"^"_INCIRowid
}

ClassMethod CheckNotDrugUpdate(Adm As %String, OrdItem As %String, ExpStr As %String = "") As %String
{
	s OutInfo=""
	s (SessionUser,SessionDept,SessionGroup,SessionHosp,PPRowId,AdmReason)=""
	if ExpStr'=""{
		s SessionUser=$p(ExpStr,"^",1)
		s SessionDept=$p(ExpStr,"^",2)
		s SessionGroup=$p(ExpStr,"^",3)
		s SessionHosp=$p(ExpStr,"^",4)
		s PPRowId=$p(ExpStr,"^",5)
		s AdmReason=$p(ExpStr,"^",6)
		s SessionLangID=$p(ExpStr,"^",7)
	}elseif $d(%session){
		s SessionUser=%session.Get("LOGON.USERID")
		s SessionDept=%session.Get("LOGON.CTLOCID")
		s SessionGroup=%session.Get("LOGON.GROUPID")
		s SessionHosp=%session.Get("LOGON.HOSPID")
		s SessionLangID=%session.Get("LOGON.LANGID")
	}
	s CspName="doccure.applytree.hui.csp"
	s ExpStr=SessionUser_"^"_SessionDept_"^"_SessionGroup_"^"_PPRowId_"^"_AdmReason_"^"_SessionLangID_"^"_CspName
	
	s PAADMType=$p($g(^PAADM(Adm)),"^",2)
	s PAADMInsType=$P(^PAADM(Adm,1),"^",7)
	s OrdItemLen=$l(OrdItem,$c(1))
	for loop=1:1:OrdItemLen{
		s oneOrdItem=$p(OrdItem,$c(1),loop)
		s ARCIMRowid=$P(oneOrdItem,"^",1)
		s OrderType=$P(oneOrdItem,"^",2)
		s PriorRowid=$p(oneOrdItem,"^",3)
		s FreqRowid=$p(oneOrdItem,"^",4)
		s MainARCIMRowid=$p(oneOrdItem,"^",5)
		s ArcimDesc=$p(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1),"^",2)
		s ArcimDesc=##class(DHCDoc.Common.Translate).GetTransARCIM(ArcimDesc,SessionLangID)
		s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
		s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
		if OrderType'="R"{
			s MainItemCatRowid=""
			s FreqItemCat=##Class(web.DHCDocConfig).GetConfigNode("FrequencedItemCat")
			s:MainARCIMRowid'="" MainItemCatRowid=$p($g(^ARCIM(+MainARCIMRowid,$p(MainARCIMRowid,"||",2),1)),"^",10)
		    if (MainItemCatRowid="")!(("^"_FreqItemCat_"^")[("^"_MainItemCatRowid_"^")){
			    s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
			    s IsHourItem=##Class(web.DHCDocOrderCommon).IsHourItem(ARCIMRowid)
				if ("^"_FreqItemCat_"^"[("^"_ItemCatRowid_"^"))&&(FreqRowid="")&&(IsHourItem'="1"){
					s ErrMsg=ArcimDesc_","_##class(websys.Translation).Get(CspName,"请录入频次!")
					s ErrCode="-1"
					s OutInfo=##class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg^SetFocusItem",ErrCode_"^"_ErrMsg_"^OrderFreq")
					q
				}
		    }
		}
		s OrdMsgArc=##class(DHCDoc.DHCDocCure.Apply).CheckBeforeInsert(Adm,ARCIMRowid,ExpStr)
		s JsonObj={}.%FromJSON(OrdMsgArc)
		s ErrCode=JsonObj.ErrCode
		s ErrMsg=JsonObj.ErrMsg
		if ErrCode'=0{
			s OutInfo=OrdMsgArc
			Q		
		}
	}
    
    if OutInfo=""{
	    s ErrCode=0
	    s ErrMsg=""
	   	s OutInfo=##class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg",ErrCode_"^"_ErrMsg) 
	}
    q OutInfo
}

}
