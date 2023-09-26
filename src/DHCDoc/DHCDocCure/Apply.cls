Class DHCDoc.DHCDocCure.Apply Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 判断医嘱是否是治疗项目
/// w ##class(DHCDoc.DHCDocCure.Apply).CheckItem("8935||1")
ClassMethod CheckItem(ItemMastId As %String, LocId As %String, HospID As %String = "")
{
	n (ItemMastId, LocId,HospID,%session)
	s Flag=0
	q:(ItemMastId="")||(LocId="") Flag
	
	i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	if HospID=""{
		s HospID=$p(^CTLOC(LocId),"^",22)	
	}
	
	s ItemFlag=..GetCureItemFlag(ItemMastId,HospID)
	if ItemFlag=1{
		s LocFlag=..GetCureLocFlag(LocId,ItemMastId,"Y",HospID)
		if LocFlag=1{
			s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ItemMastId,HospID)
			if DDCISRowid'=""{
				/*s ManualApply=$p(^DHCDocCureItemSet(DDCISRowid),"^",8)
				if ManualApply'="Y" s Flag=1*/
				s Flag=1
			}
		}
	}
	
	q Flag
}

/// 判断医嘱是否是治疗项目
/// w ##class(DHCDoc.DHCDocCure.Apply).GetCureItemFlag("8935||1")
ClassMethod GetCureItemFlag(ARCIMRowId As %String, HospID As %String = "") As %String
{
	n (ARCIMRowId,HospID,%session)
	i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	s Flag=0
	q:ARCIMRowId="" Flag
	s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowId,$p(ARCIMRowId,"||",2),1)),"^",10)
	q:ItemCatRowid="" Flag
	s DHCDocCureItemCatStr=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureItemCat",HospID)
	if ("^"_DHCDocCureItemCatStr_"^")[("^"_ItemCatRowid_"^") s Flag=1
	s Flag=1
	s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ARCIMRowId,HospID)
	if DDCISRowid=""{
		s Flag=0
	}else{
		s DDCISActive=$p(^DHCDocCureItemSet(DDCISRowid),"^",10)	
		if DDCISActive'="Y" s Flag=0
	}
	q Flag
}

/// 判断科室是否是治疗科室
/// Input:LocId 科室ID; ArcitemID 医嘱项ID; 
///       DoFlag Y:只判断到定义到的配置 其他：按照医嘱项-医嘱子类-治疗科室分类依次判断
/// w ##class(DHCDoc.DHCDocCure.Apply).GetCureLocFlag(40,"6610||1")
ClassMethod GetCureLocFlag(LocId As %String, ArcitemID As %String = "", DoFlag As %String = "", HospID As %String = "") As %String
{
	n (LocId,ArcitemID,DoFlag,HospID,%session)
	s Flag=0
	q:LocId="" Flag
	i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	s Find=0
	if ArcitemID'=""{
		if $d(^DHCDocCureArcCat(0,"LIMMAST1",ArcitemID)){
			s ParRef="" 
			for{
				s ParRef=$o(^DHCDocCureArcCat(0,"LIMMAST1",ArcitemID,ParRef)) Q:ParRef=""
				s ArcCatHosp=$p(^DHCDocCureArcCat(ParRef),"^",3)
				continue:(HospID'=ArcCatHosp)	
				s ChildSub=0
				for{
					s ChildSub=$o(^DHCDocCureArcCat(0,"LIMMAST1",ArcitemID,ParRef,"I",ChildSub)) Q:ChildSub=""
					s ChildId=0
					for{
						s ChildId=$o(^DHCDocCureArcCat(ParRef,"LIM",ChildSub,"L",ChildId)) Q:ChildId=""
						s ConfigLoc=$p($g(^DHCDocCureArcCat(ParRef,"LIM",ChildSub,"L",ChildId)),"^",1)
						continue:ConfigLoc=""
						s:ConfigLoc'="" Find=1
						if ConfigLoc=LocId{
							s Flag=1
						}
					}  
				}
			}	
			if (DoFlag="Y")&&(Find=1){
				Q Flag
			}
		}
		if Flag=0{
			s ItemCatRowid=$p($g(^ARCIM(+ArcitemID,$p(ArcitemID,"||",2),1)),"^",10)
			if $d(^DHCDocCureArcCat(0,"LICCAT1",ItemCatRowid)){
				s ParRef="" 
				for{
					s ParRef=$o(^DHCDocCureArcCat(0,"LICCAT1",ItemCatRowid,ParRef)) Q:ParRef=""
					s ArcCatHosp=$p(^DHCDocCureArcCat(ParRef),"^",3)
					continue:(HospID'=ArcCatHosp)	
					s ChildSub=0
					for{
						s ChildSub=$o(^DHCDocCureArcCat(0,"LICCAT1",ItemCatRowid,ParRef,"I",ChildSub)) Q:ChildSub=""
						s ChildId=0
						for{
							s ChildId=$o(^DHCDocCureArcCat(ParRef,"LIC",ChildSub,"L",ChildId)) Q:ChildId=""
							s ConfigLoc=$p($g(^DHCDocCureArcCat(ParRef,"LIC",ChildSub,"L",ChildId)),"^",1)
							continue:ConfigLoc=""
							s:ConfigLoc'="" Find=1
							if ConfigLoc=LocId{
								s Flag=1
							}
						}  
					}
				}
				if (DoFlag="Y")&&(Find=1){
					Q Flag
				}	
			}
		}
	}else{
		s ParRef=""
		for {
			s ParRef=$o(^DHCDocCureArcCat(0,"LIMMASTLOC",ParRef))
			Q:ParRef=""
			s ArcCatHosp=$p(^DHCDocCureArcCat(ParRef),"^",3)
			continue:(HospID'=ArcCatHosp)	
			s ChildSub=""
			for {
				s ChildSub=$o(^DHCDocCureArcCat(0,"LIMMASTLOC",ParRef,ChildSub))
				Q:ChildSub=""
				s Find=1
				if $d(^DHCDocCureArcCat(0,"LIMMASTLOC",ParRef,ChildSub,LocId)){
					s Flag=1	
				}
			}
		}
		if (DoFlag="Y")&&(Find=1){
			Q Flag
		}
		
		if Flag=0{
			s ParRef=""
			for {
				s ParRef=$o(^DHCDocCureArcCat(0,"LICCATLOC",ParRef))
				Q:ParRef=""
				s ArcCatHosp=$p(^DHCDocCureArcCat(ParRef),"^",3)
				continue:(HospID'=ArcCatHosp)	
				s ChildSub=""
				for {
					s ChildSub=$o(^DHCDocCureArcCat(0,"LICCATLOC",ParRef,ChildSub))
					Q:ChildSub=""
					s Find=1
					if $d(^DHCDocCureArcCat(0,"LICCATLOC",ParRef,ChildSub,LocId)){
						s Flag=1	
					}
				}
			}
			if (DoFlag="Y")&&(Find=1){
				Q Flag
			}
		}
	}
	if Flag=0{
		s CureLocStr=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureLocStr",HospID) ;$g(^DHCDocConfig("DHCDocCureLocStr")) 
		;if CureLocStr="" s Flag=1 q Flag
		if CureLocStr'=""{
			if ("^"_CureLocStr_"^")[("^"_LocId_"^") s Flag=1
		}
	}
	q Flag
}

/// 自动生成治疗申请单
ClassMethod SaveDHCDocCureApply(EpisodeID As %String, OrdItemStr As %String, UserID As %String) As %String
{
    n (EpisodeID,OrdItemStr,UserID)
    f k=1:1:$l(OrdItemStr,"^")-1 {
		s OrdID=$p($p(OrdItemStr,"^",k),"*",2)
		i OrdID="" continue
		s DCARowId=$o(^DHCDocCure(0,"OEORI",OrdID,""))
		;8.3版本治疗申请是先插入的,医嘱插入完成后将医嘱与治疗申请进行关联
		if (DCARowId=""){
			s ArcimID=$P($G(^OEORD(+OrdID,"I",$P(OrdID,"||",2),1)),"^",2)
			s ReLocId=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),3)),"^",6)
			set OrderAddDeptDr="",HospID=""
			Set OrderAddDeptDr=$p($g(^OEORD(+OrdID,"I",$p(OrdID,"||",2),7)),"^",2)
			if OrderAddDeptDr'=""{
				s HospID=$p(^CTLOC(OrderAddDeptDr),"^",22)	
			}
			s CureItemFlag=..CheckItem(ArcimID,ReLocId,HospID)
			;取用是否手动申请配置
			s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimID,HospID)
			s ManualApply=""
			if DDCISRowid'=""{
				s ManualApply=$p(^DHCDocCureItemSet(DDCISRowid),"^",8)
			}
			if (CureItemFlag=1)&&(ManualApply'="Y"){
				d ..CreateCureApply(EpisodeID,OrdID,UserID,"",HospID)
			}
      	}
    }
    Q 0
}

/// 生成治疗申请单  审核单和医嘱一对一  
/// 1.生成申请单
/// w ##class(DHCDoc.DHCDocCure.Apply).CreateCureApply(2318,"1989||6",1)
ClassMethod CreateCureApply(EpisodeID As %String, OrderId As %String, UserID As %String, GenFlag As %String = "", HospID As %String = "") As %String
{
	n (EpisodeID,OrderId,UserID,GenFlag,%session,HospID)
	s ^TMP("SaveCureApply")=EpisodeID_","_UserID_","_OrderId
	Quit:EpisodeID="" 0
	Quit:OrderId="" 0
	s err=0
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	Lock ^DHCDocCureApply("NO",+$H)
	s NO=$I(^DHCDocCureApply("NO",+$H))
	Lock -^DHCDocCureApply("NO",+$H)
	s DCANO=$tr($ZD(NowDate,3),"-","")_$E("0000",1,4-$L(NO))_NO ;申请单号
	s ApplyExec="N"
	s IsGenExeFlag=##class(DHCDoc.DHCDocCure.Service).CureItemIsGenExe(OrderId)
	if IsGenExeFlag=0 s ApplyExec="Y"
	if GenFlag="Y" s ApplyExec="Y" ;造数据 默认直接执行
	s (OrderRecLocID,OrderDepProcNote)=""
	if OrderId'=""{
		s OrderRecLocID=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
		s OrderDepProcNote=$g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),"DEP",1))
		if OrderRecLocID'="" {
			if HospID=""{
				s HospID=$p($g(^CTLOC(OrderRecLocID)),"^",22)	
				i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
			}
		}
	}else{
		i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")	
	}
	s AppAllowExec=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig("","CureLocAppAllowExec",OrderRecLocID,HospID)
	if AppAllowExec=1 s AppAllowExec="Y"
	else  s AppAllowExec="N"
	;1.新增申请单
	k PLIST
	s PLIST(2)=EpisodeID
	s PLIST(3)=OrderId
	s PLIST(4)="A"
	s PLIST(5)=UserID
	s PLIST(6)=+$h
	s PLIST(7)=$p($h,",",2)
	s PLIST(11)=OrderDepProcNote
	s PLIST(19)=DCANO
	s PLIST(20)=ApplyExec
	s PLIST(21)=AppAllowExec
	s PLIST(26)=OrderRecLocID
	;b ;PLIST
	&sql(insert into SQLUser.DHC_DocCureApp values :PLIST())
	if SQLCODE 
	{
		s err=SQLCODE
		s ErrMsg="插入治疗申请单表失败"_"$"_EpisodeID_","_OrderId_","_UserID
		d ##class(DHCDoc.Log.Common).General("Insert","DHCDoc.DHCDocCure.Apply","CreateCureApply",ErrMsg,OrderId,err) 
		Q err
	}
	s DCARowId=%ROWID
	s CDRPara=DCARowId_"^^"_""_"^"_"CUREAP"_"^"_UserID
	Job ##class(DHCDoc.DHCDocCure.Invoke).InputDataToCDR(CDRPara)
  	Q err_"^"_DCARowId
}

/// w ##class(DHCDoc.DHCDocCure.Apply).CheckAfterInit(1961,"10209^6^28")
/// 治疗申请单界面初始化完成后,返回给界面的一些提示信息.
ClassMethod CheckAfterInit(EpisodeID As %String, ExpStr As %String, EmConsultItm As %String = "", NotAdmTypeLimit As %String = "")
{
	n (EpisodeID,ExpStr,EmConsultItm,%session,NotAdmTypeLimit)
	s ^tmplog("CheckAfterInit")=EpisodeID_","_ExpStr
	s ret=0
	if (EpisodeID=""){
		s ret="就诊信息为空"
		q ret
	}
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	if (PAAdmType'="I"){
		s ExaNoCheckinDocCanRecAdm=""
		s Status=##class(web.DHCDocTransfer).GetQueStatusByAdm(EpisodeID)
		s ExaNoCheckinDocCanRecAdm=##class(web.DHCDocTransfer).GetExaNoCheckinDocCanRecAdm(EpisodeID)
		if ((Status="报到")&&(ExaNoCheckinDocCanRecAdm'="Y")){
			s ret="未报到患者不能进行治疗申请!"
			q ret
		}
	}
	s warning=##class(web.DHCDocViewDataInit).GetOrdWarning(EpisodeID,..%SessionStr(),EmConsultItm,"N",NotAdmTypeLimit)
	s:warning'="" ret=##class(web.DHCDocUtil).EvalJSON(warning)
	
	q ret
}

/// w ##class(DHCDoc.DHCDocCure.Apply).CheckBeforeInsert(6087,"5487||1","6^7^126")
/// 治疗申请插医嘱前的判断.
ClassMethod CheckBeforeInsert(EpisodeID As %String, ArcimRowid As %String, ExpStr As %String)
{
	n (EpisodeID,ArcimRowid,ExpStr,%session)
	s USERID=$p(ExpStr,"^",1)
	s CTLOCID=$p(ExpStr,"^",2)
	s GroupID=$p(ExpStr,"^",3)
	s PPRowId=$p(ExpStr,"^",4)
	s AdmReason=$p(ExpStr,"^",5)
	s langid=$p(ExpStr,"^",6)
	s CspName=$p(ExpStr,"^",7)
	if CspName="" s CspName="doccure.applytree.hui.csp"
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ErrCode=0, ErrMsg=""
	if (EpisodeID=""){
		s ErrCode="-1"
		s ErrMsg=##class(websys.Translation).Get(CspName,"就诊信息为空",langid)
	}
	
	s PAPMIRowid=$P(^PAADM(EpisodeID),"^",1)
	s ArcimDesc=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",2)
	s ArcimDesc=##class(DHCDoc.Common.Translate).GetTransARCIM(ArcimDesc,langid)
	if ErrCode=0{
		;按照医嘱项上的门诊用药、急诊用药、住院用药标志来检测医嘱项是否可用
		s CheckArcimTypeStr=##class(web.DHCDocOrderCommon).CheckArcimType(ArcimRowid,EpisodeID)
		if CheckArcimTypeStr'=""{
			s ErrCode="-1"
			s ErrMsg=##class(websys.Translation).Get(CspName,CheckArcimTypeStr,langid)
		}
	}
	if ErrCode=0{
		;得到医嘱的性别/年龄限制 1 限制,0非限制
		s PatDOB=$P($G(^PAPER(PAPMIRowid,"ALL")),"^",6)
		s SexId=$P($G(^PAPER(PAPMIRowid,"ALL")),"^",7)
		s Age=$$CalAge^at182(PatDOB,+$H,"","","")
		s Age=$p(Age,"|",12)
		s ASCheckStr=##class(web.DHCDocOrderCommon).GetItemAgeSexRestriction(ArcimRowid,SexId,Age)
		if ("1"=$p(ASCheckStr,$c(2),1)){
			s ASCheckSex=$p(ASCheckStr,$c(2),2)
			s ASCheckAgeRange=$p(ASCheckStr,$c(2),3)
			if (ASCheckAgeRange'=""){
				s ErrMsg=ArcimDesc_","_##class(websys.Translation).Get(CspName,"被限制使用：",langid)_ASCheckAgeRange
				s ErrCode="-1"
			}else{
				s ErrMsg=ArcimDesc_","_##class(websys.Translation).Get(CspName,"被限制使用："_ASCheckSex,langid)
				s ErrCode="-1"
			}
		}
	}
	if ErrCode=0{
		s ValOrdFlag=##class(web.DHCDocOrderEntry).ValOrd("ARCIM",GroupID, ArcimRowid, "", "", USERID,CTLOCID,"","",PAPMIRowid)
		i ValOrdFlag=0{
			s ErrMsg=ArcimDesc_","_##class(websys.Translation).Get(CspName,"没有权限开立此医嘱",langid)
			s ErrCode="-1"
		}
	}
 	if ErrCode=0{
 		s OrdMsgArc=##Class(web.DHCAPPExaReport).GetPatNotTakOrdMsgArc(EpisodeID,ArcimRowid,PPRowId,AdmReason)
 		s OrdMsgArcObj={}.%FromJSON(OrdMsgArc)
 		s ArcErrMsg=OrdMsgArcObj.ErrMsg
 		s:ArcErrMsg'="" ArcErrMsg=ArcimDesc_","_##class(websys.Translation).Get(CspName,ArcErrMsg,langid)
 		s OrdMsgArcObj.ErrMsg=ArcErrMsg
 		s OrdMsgArc=OrdMsgArcObj.%ToJSON()
 	}else{
	 	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg",ErrCode_"^"_ErrMsg))
	 	s OrdMsgArc=Stream.Read()
 	}
 	Q OrdMsgArc
}

/// w ##class(DHCDoc.DHCDocCure.Apply).InsertCureApply(671,"6610||1",2,116,44,2,1,4634,7,"4^28")
ClassMethod InsertCureApply(EpisodeID, ArcimRowid, OrderQty, BillingUOM, OrderRecDepRowid, ApplyPlan, ApplyRemark, USERID, CTLOCID, ExpStr)
{
	s ^tmpnk("InsertCureApply")=EpisodeID_","_ArcimRowid_","_OrderQty_","_BillingUOM_","_OrderRecDepRowid_","_ApplyPlan_","_ApplyRemark_","_USERID_","_CTLOCID_","_ExpStr
	s CureItemFlag="",CureLocFlag="",ManualApply=""
	s BillTypeRowid=$p(ExpStr,"^",1)
	s GroupID=$p(ExpStr,"^",2)
	s check=$$CheckInsert(EpisodeID,ArcimRowid,OrderRecDepRowid)
	if check'=0 q check
	s ItemCatRowid=$p($g(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1)),"^",10)
	s OrderType=$P(^ARC("IC",ItemCatRowid),"^",7)
	s OrderPriorRowid=$o(^OECPR(0,"Code","NORM",0))
	s OrderDate=$zd(+$h,4)
	s OrderTime=$zt($p($h,",",2),1)
	s OrderCoverMainIns="N"
	s OrderPackUOMRowid=BillingUOM
	s OrderPriorRowid=$p(ExpStr,"^",3)
	s OrderFreqRowId=$p(ExpStr,"^",4)
	s OrderDurRowid=$p(ExpStr,"^",5)
	s OrderDoseQty=$p(ExpStr,"^",6)
	s OrderDoseUOMRowid=$p(ExpStr,"^",7)
	s OrderStartDate=$p(ExpStr,"^",8)
	if OrderStartDate=""{
		s OrderSDate=OrderDate
		s OrderSTime=OrderTime	
	}else{
		s OrderSDate=$p(OrderStartDate," ",1)
		s OrderSTime=$p(OrderStartDate," ",2)	
	}
	s AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	s Hospital=##Class(web.DHCDocConfig).GetConfigNode("CurrentHospital")
 	i Hospital'="" s HospitalCode=$P(Hospital,"^",1)
 	e  s HospitalCode=""
	if (OrderFreqRowId="")&&(AdmType'="I"){
		 s STFreqRowid=$O(^PHCFR(0,"Desc1","ST",0))
		 i HospitalCode="ZGYKDFSYY" s STFreqRowid=$O(^PHCFR(0,"Code","ST",0))
		 i HospitalCode="SDWFYY"    s STFreqRowid=$O(^PHCFR(0,"Code","ST",0))
		 s OrderFreqRowId=STFreqRowid
	}
 	s UnitPrice=..GetPrice(EpisodeID,ArcimRowid,OrderRecDepRowid,OrderPackUOMRowid,"")
	s OrderDrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(ArcimRowid)
	s Orderprice=""
	s OrderItem=ArcimRowid_"^"_OrderType_"^"_OrderPriorRowid_"^"_OrderSDate_"^"_OrderSTime
	s OrderItem=OrderItem_"^"_OrderQty_"^"_UnitPrice_"^"_OrderRecDepRowid_"^"_BillTypeRowid_"^"_OrderDrugFormRowid
	s OrderItem=OrderItem_"^"_""_"^"_OrderDoseQty_"^"_OrderDoseUOMRowid_"^"_OrderQty_"^"_OrderFreqRowId
	s OrderItem=OrderItem_"^"_OrderDurRowid_"^"_""_"^"_""_"^"_""_"^"_"1"
	s OrderItem=OrderItem_"^"_"N"_"^"_""_"^"_OrderCoverMainIns_"^"_""_"^"_""
	s OrderItem=OrderItem_"^"_""_"^"_""_"^"_""_"^"_""_"^"_"N"
	s OrderItem=OrderItem_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	s OrderItem=OrderItem_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	s OrderItem=OrderItem_"^"_""_"^"_""_"^"_""_"^"_""_"^"_""
	s OrderItem=OrderItem_"^"_OrderDate_"^"_OrderTime_"^"_"N"_"^"_""_"^"_""
	s OrderItem=OrderItem_"^"_""_"^"_""_"^"_"N"_"^"_""_"^"_OrderPackUOMRowid
	s DCARowIDRet=""
	s DocID=$p(^SSU("SSUSR",USERID),"^",14)
	Ts
	s insret="0^"
	s Ret=##class(DHCDoc.Interface.Inside.ServiceOrd).SaveOrderItems(EpisodeID,OrderItem,USERID,CTLOCID,DocID,"","0^^")
	If (Ret'=0)&&(Ret'=100){
		f k=1:1:$l(Ret,"^")-1 {
	      s OrdID=$p($p(Ret,"^",k),"*",2)
	      i OrdID="" continue
	      ;if (CureItemFlag=1)&&(CureLocFlag=1)&&(ManualApply="Y"){
		  if (CureItemFlag=1)&&(CureLocFlag=1){		
		      ;s insret=..CreateCureApply(EpisodeID,OrdID, USERID)
		      ;s DCARowID=$p(insret,"^",2)
		      s DCARowID=$o(^DHCDocCure(0,"OEORI",OrdID,""))
		      s insret="0^"_DCARowID
		      if DCARowID="" s insret="101^插入申请单失败"
		      else  d ##class(DHCDoc.DHCDocCure.Apply).SaveCureApply(DCARowID,ApplyPlan, ApplyRemark, USERID)
		  }
		}
	}else{
		s insret="100^插入医嘱失败"	
	}
	if +insret'=0{
		tro	
	}else{
		tc	
	}
	q insret
CheckInsert(Adm,arcim,recdepid)
	;n (Adm,arcim,recdepid)
	s ret=0
	s CheckExpStr=USERID_"^"_CTLOCID_"^"_GroupID
	s ret=..CheckAfterInit(Adm,CheckExpStr)
 	if (ret'=0){
	 	s ret="1002^"_ret
 		q ret
 	}
 	s HospID=$p(^CTLOC(CTLOCID),"^",22)	
 	
	;取用是否手动申请配置
	s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(arcim,HospID)
	s ManualApply=""
	if DDCISRowid'=""{
		s ManualApply=$p(^DHCDocCureItemSet(DDCISRowid),"^",8)
		;if (ManualApply'="Y") s ret="1003^该医嘱项非需手动申请治疗类医嘱"
	}
	s CureItemFlag=##class(DHCDoc.DHCDocCure.Apply).GetCureItemFlag(arcim)
	s CureLocFlag=##class(DHCDoc.DHCDocCure.Apply).GetCureLocFlag(recdepid)
	if (CureItemFlag=0) s ret="1004^该医嘱项所属子类非治疗类医嘱"
	if (CureLocFlag=0) s ret="1005^所选接收科室非治疗类接收科室"
	q ret
}

ClassMethod GetPrice(EpisodeID, ArcimRowid, OrderRecDepRowid, OrderPackUOMRowid, OrdRowID)
{
	n (EpisodeID, ArcimRowid, OrderRecDepRowid, OrderPackUOMRowid,OrdRowID)
	s OrderPriorRowid=$o(^OECPR(0,"Code","NORM",0))
	s AdmReasonDR=$p(^PAADM(EpisodeID,1),"^",7)
	s PatType=$P(^PAADM(EpisodeID,1),"^",6)  //PAADM_Epissubtype_DR
	s PatType=##class(web.UDHCJFBILL).GetPatTypeByRecLoc(PatType,OrderRecDepRowid)
	s PAADMRegConDisDR=$P($G(^PAADM(EpisodeID,"DHC")),"^",25)
	s itmPriceExpStr=""
	s oeore=""
	s itmPriceExpStr=OrdRowID_"^"_oeore_"^"_EpisodeID_"^"_OrderRecDepRowid_"^"_""
	s UnitPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, AdmReasonDR, ArcimRowid, +$h, OrderPriorRowid, "", "", "",PAADMRegConDisDR,OrderPackUOMRowid,itmPriceExpStr) 
	s UnitPrice=$p(UnitPrice,"^",1)
 	s UnitPrice=$tr(UnitPrice," ","")
 	q UnitPrice
}

/// w ##class(DHCDoc.DHCDocCure.Apply).CancelCureApplyByStopOrd("644||3","17275")
ClassMethod CancelCureApplyByStopOrd(OEORDRowId As %String, UserID As %String, ByRef ErrMsg As %String = "")
{
	n (OEORDRowId,UserID,ErrMsg,%session)
	s ^tmplog("CancelCureApplyByStopOrd")=$lb(OEORDRowId,UserID,ErrMsg)
	s ret=0
	q:OEORDRowId="" ret
	s DCARowID=$o(^DHCDocCure(0,"OEORI",OEORDRowId,""))	;治疗申请
	s DCASRowID=$o(^User.DHCDocCureAssScoreI("DCASOEORIDRIndex",OEORDRowId,"")) ;治疗评定
	
	s OrderID=+OEORDRowId
	s OrderChild=+$p(OEORDRowId,"||",2)
	if DCARowID'=""{
		;计费先停，状态改为了D，这会调用了停医嘱方法，之后又会判断是否部分退,把医嘱状态改回V
		;计费部分退费不会调用本组停医嘱方法，不会再修改医嘱状态 20220718
		s OrderAdm=$p($g(^OEORD(OrderID)),"^",1)
		s AdmType=$p($g(^PAADM(OrderAdm)),"^",2)
		if (AdmType'="I"){
			s OrderStatusCode=""
			s BillFlag=$p($g(^OEORD(OrderID,"I",OrderChild,3)),"^",5)
			s OrdStatusDR=$p($g(^OEORD(OrderID,"I",OrderChild,1)),"^",13)
			s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
			s AppRefQty=##class(BILL.Interface.Inside.Method).GetAppRefundQty(OEORDRowId, "")
			s OERQRowID=$o(^DHCOERefundQTY(0,"OEORI",OEORDRowId,""),-1)
			if (OERQRowID'=""){
				s DealRtn=0
				Ts
				s OrderExecChild=""
				for{
					s OrderExecChild=$o(^OEORD(OrderID,"I",OrderChild,"X",OrderExecChild),-1)
					Q:(OrderExecChild="")!(AppRefQty'>0)
					s OEOREDR=OEORDRowId_"||"_OrderExecChild
					s execdata=$g(^OEORD(OrderID,"I",OrderChild,"X",OrderExecChild))
					s OEOREStatus=$p(execdata,"^",16)
					s OEOREStatusCode=""
					s:OEOREStatus'="" OEOREStatusCode=$p(^OEC("STAT",OEOREStatus),"^",1)
					continue:(OEOREStatusCode="F")!(OEOREStatusCode="D")
					s CureAppStatus=##class(DHCDoc.DHCDocCure.Appointment).GetExecResultAppStatus(OEOREDR)
					continue:CureAppStatus=1
					s OEOREQty=##class(DHCDoc.DHCDocCure.ExecApply).GetQtyByExecID(OEOREDR)
					;申请退费数量大于等于当前执行数量 则将执行记录停止执行
					;申请退费数量小于当前执行数量 则将执行记录更新数量
					if OEOREQty'>AppRefQty{
						s DealRtn=##class(appcom.OEOrdExec).UpdateStatus(OEOREDR,"D",UserID,"","","","")
					}else{
						s UpdateQty=OEOREQty-AppRefQty
						s DealRtn=##class(DHCDoc.DHCDocCure.ExecApply).ReplaceOneOrdExec(OEOREDR,UpdateQty,UserID)
					}
					if DealRtn'=0{
						Quit
					}
					s AppRefQty=AppRefQty-OEOREQty
				}
				if DealRtn'=0{
					Tro
				}else{
					Tc	
				}
				Q DealRtn	
			}else{
				d ##Class(appcom.OEOrdExec).DiscontinueAll(OEORDRowId,UserID,"1","N","Y")	
			}
		}
		s CureData=$g(^DHCDocCure(DCARowID)) 
		s ApplyStatus=$p(CureData,"^",3)
		Q:ApplyStatus="C" 0 //已撤销申请治疗单的不再调用
		s ret=..CancelCureApply(DCARowID,UserID,"Y",.ErrMsg)
	}elseif DCASRowID'=""{
		s ret=##Class(DHCDoc.DHCDocCure.AssScale).UpdScoreStat(DCASRowID,"C")
	}
	q ret
}

ClassMethod CancelTriaged(DCARowId As %String, UserID As %String)
{
	n (DCARowId,UserID)
	s TriChildSub=0
	for  s TriChildSub=$o(^DHCDocCureTRI(DCARowId,"Triage",TriChildSub)) Q:TriChildSub=""  d
	.s TRIRowID=DCARowID_"||"_TriChildSub
	.d ##class(DHCDoc.DHCDocCure.Triage).CancelTriaged(TRIRowID,UserID)
	q 0
}

/// w ##class(DHCDoc.DHCDocCure.Apply).CancelCureApply(43,6)
ClassMethod CancelAppBroker(DCARowId As %String, UserID As %String, NotNeedCheck As %String = "")
{
	n (DCARowId,UserID,NotNeedCheck,%session)
	s ret=..CancelCureApply(DCARowId,UserID,NotNeedCheck,.ErrMsg)
	Q ret_"^"_ErrMsg
}

ClassMethod CancelCureApply(DCARowId As %String, UserID As %String, NotNeedCheck As %String = "", ByRef ErrMsg As %String = "")
{
	n (DCARowId,UserID,NotNeedCheck,ErrMsg,%session)
	Q:DCARowId="" 0
	if NotNeedCheck'="Y"{
		s ret=..CheckData(DCARowId,"C","",.ErrMsg)
		q:$g(ret)'="" ret
	}
	//停医嘱
	/*
	Set CureAppInfo=$g(^DHCDocCure(DCARowId))
	Set EpisodeID=$p(CureAppInfo,"^",1)
	//Set DCAOEORIDR=$p(CureAppInfo,"^",7)
	//Set DCAText1=$p(CureAppInfo,"^",8) //治疗项目附加费用
	s ret=0
	s DCACChildSub=0
	for{
		s DCACChildSub=$o(^DHCDocCure(DCARowId,"CureItem",DCACChildSub))
		q:DCACChildSub=""
		s DCAOEORIDR=$p($g(^DHCDocCure(DCARowId,"CureItem",DCACChildSub)),"^",1)
		q:ret'=0
		if (DCAOEORIDR'=""){
			s Adm=$p(^OEORD(+DCAOEORIDR),"^")
			s AdmType=$p(^PAADM(Adm),"^",2)
			if (AdmType="I"){
				s ret=##class(appcom.OEOrdItem).UnUse(DCAOEORIDR,UserID)
			}else{
				s ret=##class(web.DHCOEOrdItem).Stop(DCAOEORIDR,UserID)
			}
		}
		
	}
	Q:ret'=0 ret
	;账单
	d ##Class(web.UDHCJFBILL).BILLN(EpisodeID,UserID,"")
	*/
	s CureDate=+$h
	s CureTime=$p($h,",",2)
	&sql(update SQLUser.DHC_DocCureApp set DCA_Status="C",DCA_UpdateDate=:CureDate,DCA_UpdateTime=:CureTime,DCA_UpdateUser_DR=:UserID where DCA_RowId=:DCARowId)
	if SQLCODE{
		s ErrMsg="更新治疗申请单状态失败"	
	}else{
		s CDRPara=+DCARowId_"^^"_""_"^"_"CURECAP"_"^"_UserID
		Job ##class(DHCDoc.DHCDocCure.Invoke).InputDataToCDR(CDRPara)
	}
	Q SQLCODE
}

/// 取单个治疗申请单剩余的可预约次数
/// w ##class(DHCDoc.DHCDocCure.Apply).GetApplyNoAppTimes(681)
ClassMethod GetApplyNoAppTimes(DCARowId As %String, SessionStr As %String = "") As %String
{
	n (DCARowId,SessionStr,%session)
	s HOSPID=$p(SessionStr,"^",4)
	s:(HOSPID="")&&($d(%session)) HOSPID=%session.Get("LOGON.HOSPID")
	
	Quit:DCARowId="" 0
	s CureAppInfo=""
	s CureData=$g(^DHCDocCure(DCARowId))
	s Adm=$p(CureData,"^",1)
	Q:Adm="" 0
	s OrderId=$p(CureData,"^",2)
	Q:OrderId="" 0
	s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	Q:ArcimId="" 0
	s CureAppVersion=##Class(DHCDoc.DHCDocCure.Config).GetCureConfigPara("CureAppVersion",HOSPID)
	s OrderQty=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",12)
	s ActiveQtyStr=##class(DHCDoc.DHCDocCure.Apply).GetOrderActiveQty(OrderId)
	s OrderQty=$p(ActiveQtyStr,"^",1)
	s ApplyAppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowId)
	s ApplyAppedTimes=$case(CureAppVersion,"V1":+$p(ApplyAppInfo,"^",1),:+$p(ApplyAppInfo,"^",2))
	s ApplyExecTimes=+$p(ApplyAppInfo,"^",3)
	s ApplyNoAppTimes=+OrderQty-ApplyAppedTimes-ApplyExecTimes
	
	q ApplyNoAppTimes
}

ClassMethod GetSimpleCureApply(DCARowId, HospID As %String = "", ExpStr As %String = "") As %String
{
	new (DCARowId,HospID,ExpStr,%session)
	Quit:DCARowId="" ""
	Set:HospID="" HospID=$p(ExpStr,"^",1)
	Set langid=$p(ExpStr,"^",2)
	Set cspName=$p(ExpStr,"^",3)
	Set:cspName="" cspName="doccure.emr.cureapplist.hui.csp"
	Set CureData=$g(^DHCDocCure(DCARowId))
	Set DCAAdmID=$p(CureData,"^",1)
	Quit:DCAAdmID="" ""
	Set PatientId=$P($G(^PAADM(DCAAdmID)),"^",1)
	Set OrderId=$p(CureData,"^",2)
	Quit:OrderId="" ""
	Set ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	Quit:ArcimId="" ""
	Set ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
	Set ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
	Set ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	Set OrderStatus="",OrderStatusCode=""
	Set OrdStatusDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",13)
	Set:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
	Set DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByOrd(OrderId)
	Set ServiceGroupDR=""
	if DDCISRowid'=""{
		Set ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
	}
	Set OrderReLoc=""
	Set OrdReLocId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
	if OrdReLocId'=""{
		Set OrderReLoc=##class(DHCDoc.DHCDocCure.WordReport).GetLocDesc(OrdReLocId,langid)
	}
	Set PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
	Set ISLongOrdFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
	;该申请单是否直接执行，防止中途修改治疗医嘱项是否直接执行配置影响数据
	Set ApplyExecFlag=$p(CureData,"^",19)
	Set ApplyExec=$case(ApplyExecFlag,"Y":"直接执行",:"可预约")
	Set ApplyExec=ApplyExec_$case(ISLongOrdFlag,"1":"(长期)",:"")
	Set ApplyExec=##class(websys.Translation).Get(cspName,ApplyExec)
	
	Set ActiveQtyStr=##class(DHCDoc.DHCDocCure.Apply).GetOrderActiveQty(OrderId)
	Set OrderQty=$p(ActiveQtyStr,"^",1)
	Set BillingUOM=$p(ActiveQtyStr,"^",2)
 	Set UnitPrice=##class(DHCDoc.DHCDocCure.Apply).GetPrice(DCAAdmID,ArcimId,OrdReLocId,"",OrderId)
 	Set UnitPrice=$p(UnitPrice,"^",1)
 	Set UnitPrice=$j($g(UnitPrice),11,2)
 	Set UnitPrice=$tr(UnitPrice," ","")
 	Set OrdPrice=$j($g(UnitPrice)*OrderQty,11,2)
 	Set OrdPrice=$tr(OrdPrice," ","")
 	Set:ISLongOrdFlag="1" OrdPrice="-"
 	
	Set ApplyStatus=$p(CureData,"^",3)
	Set ApplyStatus=..GetApplyStatus(DCARowId,cspName)
	Set ApplyUser=$p(CureData,"^",4)
	Set:ApplyUser'="" ApplyUser=$P(^SSU("SSUSR",ApplyUser),"^",2)
	Set ApplyUser =##class(DHCDoc.Common.Translate).GetTransUser(ApplyUser,langid)
	Set ApplyDate=$p(CureData,"^",5)
	Set ApplyTime=$p(CureData,"^",6)
	Set ApplyDate=##class(websys.Conversions).DateLogicalToHtml(ApplyDate)
	Set ApplyTime=$zt(ApplyTime)
	Set ApplyDate=ApplyDate_" "_ApplyTime
	Set ApplyNo=$p(CureData,"^",18)	
	Set PatientInfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(PatientId,DCAAdmID)
	Set AdmInfo=""
	if DCAAdmID'=""{
		s AdmType=$P(^PAADM(DCAAdmID),"^",2)
		s AdmType=##class(DHCDoc.Common.Translate).GetTransAdmType(DCAAdmID,cspName,langid)
		s AdmDepId=$p($g(^PAADM(DCAAdmID)),"^",4)
		s AdmDep=##class(DHCDoc.DHCDocCure.WordReport).GetLocDesc(AdmDepId,langid)
		s AdmInfo=AdmType_"^"_AdmDep
	}
	
	Set CureAppInfo=ArcimDesc_"^"_OrderId_"^"_OrderStatus_"^"_OrderQty_"^"_BillingUOM
	Set CureAppInfo=CureAppInfo_"^"_UnitPrice_"^"_OrdReLocId_"^"_ApplyStatus_"^"_ApplyUser_"^"_ApplyDate
	Set CureAppInfo=CureAppInfo_"^"_OrdPrice_"^"_DDCISRowid_"^"_ApplyNo_"^"_OrderReLoc
	
	Set Info=PatientInfo_$C(1)_CureAppInfo_$C(1)_AdmInfo
	Quit Info
}

ClassMethod GetCureBilled(DCARowId As %String)
{
	Set BilledFlag=0
	Set CureData=$g(^DHCDocCure(DCARowId))
	Set Adm=$p(CureData,"^",1)
	Quit:Adm="" BilledFlag
	Set PatientId=$P($G(^PAADM(Adm)),"^",1)
	Set OrderId=$p(CureData,"^",2)
	Quit:OrderId="" BilledFlag
	Set AdmType=$p($g(^PAADM(Adm)),"^",2)
	Set BilledFlag=1
	Set Ordbilled=$p(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3),"^",5)
	if (AdmType'="I"){
		if (Ordbilled="P") s BilledFlag=1
	}
	Quit BilledFlag
}

/// w ##class(DHCDoc.DHCDocCure.Apply).GetCureApply(250)
/// Desc:  根据申请单ID获取申请单信息
/// Input: DCARowId申请单ID SpecFlag特殊处理,传1医嘱名拼写停止信息
/// OutPut:
ClassMethod GetCureApply(DCARowId, SpecFlag As %String = "", ExpStr As %String = "") As %String
{
	new (DCARowId,SpecFlag,ExpStr,%session)
	Quit:DCARowId="" ""
	Set HospID=$p(ExpStr,"^",1)
	Set langid=$p(ExpStr,"^",2)
	Set cspName=$p(ExpStr,"^",3)
    Set:langid="" langid=..%LanguageID()
    Set:cspName="" cspName="doccure.emr.cureapplist.hui.csp"
	Set CureAppInfo=""
	Set CureData=$g(^DHCDocCure(DCARowId))
	Set Adm=$p(CureData,"^",1)
	Quit:Adm="" ""
	Set OrderId=$p(CureData,"^",2)
	Quit:OrderId="" ""
	;就诊信息-患者信息
	Set PatientId=$P($G(^PAADM(Adm)),"^",1)
	Set AdmType=$p($g(^PAADM(Adm)),"^",2)
	Set PAAdmWard=""
	Set WardDr=$P($g(^PAADM(Adm)),"^",70)
	if WardDr'="" {
		Set PAAdmWard=$P($g(^PAWARD(WardDr)),"^",2)
		Set PAAdmWard=##class(User.PACWard).GetTranByDesc("WARDDesc",PAAdmWard,langid)
	}
	Set BedId=$P($g(^PAADM(Adm)),"^",73)
	if BedId'="" Set PAAdmBed=$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)
	else  Set PAAdmBed=""
	;医嘱信息
	Set ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	Quit:ArcimId="" ""
	Set ArcimDesc=$p(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1),"^",2)
	Set ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
	Set ArcimDesc=##class(ext.util.String).EvalJSON(ArcimDesc)
	Set OrderAddDept=""
	Set OrderAddDeptDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",2)
	if OrderAddDeptDr'="" {
		Set OrderAddDept=$P($G(^CTLOC(OrderAddDeptDr)),"^",2)
		Set OrderAddDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OrderAddDept,langid)
		if $P(OrderAddDept,"-",2)'="" s OrderAddDept=$P(OrderAddDept,"-",2)
		if HospID=""{
			s HospID=$p($g(^CTLOC(OrderAddDeptDr)),"^",22)	
			i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
		}
	}
	Set OrderStatus="",OrderStatusCode=""
	Set OrdStatusDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",13)
	Set:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
	Set OrderStatus=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",OrderStatus,langid)
	if SpecFlag="1"{
		if (OrderStatusCode'="V") && (OrderStatusCode'="E") {
			Set ArcimDesc=ArcimDesc_"<font color=red>"_"("_OrderStatus_")"_"</font>"
		}
	}
	Set ServiceGroupDR="",DDCRSServiceGroupDesc=""
	Set DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByOrd(OrderId)
	Set:DDCISRowid'="" ServiceGroupDR=$p($g(^DHCDocCureItemSet(DDCISRowid)),"^",3)
	Set:ServiceGroupDR'="" DDCRSServiceGroupDesc=$P($G(^DHCDocCureRBCServiceGroupSet(ServiceGroupDR)),"^",2)
	Set DDCRSServiceGroupDesc=##class(User.DHCDocCureRBCServiceGroupSet).GetTranByDesc("DDCSGSDesc",DDCRSServiceGroupDesc,langid)
	Set OrderReLoc=""
	Set OrdReLocId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
	if OrdReLocId'=""{
		Set OrderReLoc=$P($G(^CTLOC(OrdReLocId)),"^",2)
		Set OrderReLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OrderReLoc,langid)
		if $P(OrderReLoc,"-",2)'="" s OrderReLoc=$P(OrderReLoc,"-",2)
	}
	Set PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
	Set ISLongOrdFlag=##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)
	;该申请单是否直接执行，防止中途修改治疗医嘱项是否直接执行配置影响数据
	Set ApplyExecFlag=$p(CureData,"^",19)
	Set ApplyExec=$case(ApplyExecFlag,"Y":"直接执行",:"可预约")
	Set ApplyExec=ApplyExec_$case(ISLongOrdFlag,"1":"(长期)",:"")
	Set ApplyExec=..%Translate(cspName,ApplyExec,langid)
	
	Set Ordbilled=..GetOrderBilled(OrderId,cspName)	
	Set ActiveQtyStr=..GetOrderActiveQty(OrderId)
	Set OrderQty=$p(ActiveQtyStr,"^",1)
	Set BillingUOM=$p(ActiveQtyStr,"^",2)
	Set BillingUOM=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",BillingUOM,langid)
 	Set UnitPrice=..GetPrice(Adm,ArcimId,OrdReLocId,"",OrderId)
 	Set UnitPrice=$p(UnitPrice,"^",1)
 	Set UnitPrice=$j($g(UnitPrice),11,2)
 	Set UnitPrice=$tr(UnitPrice," ","")
 	Set Subscript=$p(ArcimId,"||",1)
 	Set Version=$p(ArcimId,"||",2)
 	Set ItemCat=$p(^ARCIM(Subscript,Version,1),"^",10) //取子分类
 	Set OrderType=$p(^ARC("IC",ItemCat),"^",7)
 	Set ItemCatDesc=$p(^ARC("IC",ItemCat),"^",2)
 	if OrderType="P" s UnitPrice=$p($G(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",25)
 	Set OrderBillType=""
 	Set OrderBillTypeRowid=$p($G(^OEORD(+OrderId,"I",$p(OrderId,"||",2),11)),"^",18)
	Set:OrderBillTypeRowid'="" OrderBillType=$P(^PAC("ADMREA",OrderBillTypeRowid),"^",2)
 	Set OrderBillType =##class(User.PACAdmReason).GetTranByDesc("READesc",OrderBillType,langid)
 	Set OrdPrice=$j($g(UnitPrice)*OrderQty,11,2)
 	Set OrdPrice=$tr(OrdPrice," ","")
 	Set:ISLongOrdFlag="1" OrdPrice="-"
	Set ApplyStatusCode=$p(CureData,"^",3)
	Set ApplyStatus=..GetApplyStatus(DCARowId,cspName)
	
	Set ApplyUser=$p(CureData,"^",4)
	Set:ApplyUser'="" ApplyUser=$P(^SSU("SSUSR",ApplyUser),"^",2)
	Set ApplyUser =##class(User.SSUser).GetTranByDesc("SSUSRName",ApplyUser,langid)
	Set ApplyDate=$p(CureData,"^",5)
	Set ApplyTime=$p(CureData,"^",6)
	Set ApplyDate=##class(websys.Conversions).DateLogicalToHtml(ApplyDate)
	Set ApplyTime=$zt(ApplyTime)
	Set ApplyDate=ApplyDate_" "_ApplyTime
	
	Set LongApplyAppInfo=##class(DHCDoc.DHCDocCure.ExecApply).GetLongCureApplyInfo(DCARowId)
	Set ApplyFinishTimes=$p(LongApplyAppInfo,"^",1)
	Set ApplyNoFinishTimes=$p(LongApplyAppInfo,"^",2)
	Set ApplyAppedTimes="-"
	Set ApplyNoAppTimes="-"
		
	if ISLongOrdFlag'=1,ApplyExecFlag'="Y"{
		Set ApplyAppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowId)
		Set ApplyAppedTimes=+$p(ApplyAppInfo,"^",1)
		Set ApplyExecTimes=+$p(ApplyAppInfo,"^",3)
		Set ApplyNoAppTimes=+OrderQty-ApplyAppedTimes-ApplyExecTimes ;总数量-预约数量-直接执行数量
		Set ApplyNoFinishTimes=+OrderQty-ApplyFinishTimes ;总数量-执行数量
		Set:ApplyNoAppTimes<0 ApplyNoAppTimes=0
	}
	
	Set ApplyRemarks=$p(CureData,"^",10)
	Set ApplyPlan=$p(CureData,"^",11)
	Set FinishUserDr=$p(CureData,"^",12)
	Set FinishUser=""
	Set:FinishUserDr'="" FinishUser=$P(^SSU("SSUSR",FinishUserDr),"^",2)
	Set CallStatus=""
	Set CallStatusFlag=$p(CureData,"^",16)
	if CallStatusFlag="Y" s CallStatus="正在呼叫"
	else  if CallStatusFlag="N" s CallStatus="过号"
	Set HistoryRes=##class(DHCDoc.DHCDocCure.Triage).GetHistoryRes(DCARowId)
	if HistoryRes'=""{
		Set TRData=$g(^DHCDocCureTR(+HistoryRes,"TR",$p(HistoryRes,"||",2)))
		Set DDCTRCTLocDr=$p(TRData,"^",1)
		Set DDCTRCTLoc=$p($G(^CTLOC(DDCTRCTLocDr)),"^",2)
		if DDCTRCTLoc["-" s DDCTRCTLoc=$p(DDCTRCTLoc,"-",2)
		Set DDCTRResDr=$p(TRData,"^",2)
		Set DDCTRCTPCPDr=$p($G(^RB("RES",DDCTRResDr)),"^",2)
		Set DDCTRCTPCP=$p($G(^CTPCP(DDCTRCTPCPDr,1)),"^",2)
		Set HistoryRes=DDCTRCTLoc_"-"_DDCTRCTPCP
	}
	Set ApplyNo=$p(CureData,"^",18)
	Set CurrentDate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	Set CurrentTime=$zt($p($h,",",2),2)
	Set SysCurrentDateTime=CurrentDate_" "_CurrentTime
	Set PatientInfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(PatientId,Adm)
	Set OrderOtherInfo=..GetOrderOtherInfo(OrderId)
	Set CureAppInfo=ArcimDesc_"^"_OrderStatus_"^"_OrderQty_"^"_BillingUOM_"^"_OrderReLoc
	Set CureAppInfo=CureAppInfo_"^"_OrdReLocId_"^"_ApplyStatus_"^"_ApplyUser_"^"_ApplyDate_"^"_ApplyAppedTimes
	Set CureAppInfo=CureAppInfo_"^"_ApplyNoAppTimes_"^"_ApplyFinishTimes_"^"_ApplyNoFinishTimes_"^"_ApplyRemarks_"^"_ApplyPlan
	Set CureAppInfo=CureAppInfo_"^"_Adm_"^"_OrdPrice_"^"_Ordbilled_"^"_UnitPrice_"^"_FinishUser
	Set CureAppInfo=CureAppInfo_"^"_ServiceGroupDR_"^"_CallStatus_"^"_ApplyExec_"^"_ApplyExecFlag_"^"_HistoryRes
	Set CureAppInfo=CureAppInfo_"^"_OrderAddDept_"^"_OrderBillType_"^"_SysCurrentDateTime_"^"_DDCISRowid_"^"_ItemCatDesc
	Set CureAppInfo=CureAppInfo_"^"_ApplyNo_"^"_PAAdmWard_"^"_PAAdmBed_"^"_OrderStatusCode_"^"_DDCRSServiceGroupDesc
	Set CureAppInfo=CureAppInfo_"^"_ApplyStatusCode
	Quit PatientInfo_$c(1)_CureAppInfo_$c(1)_OrderOtherInfo
}

ClassMethod GetApplyStatus(DCARowId As %String, cspName As %String = "doccure.cureapplist.hui.csp")
{
	Set ApplyStatus=$p($g(^DHCDocCure(DCARowId)),"^",3)
	Set ApplyStatus=$case(ApplyStatus,
	"A":##class(websys.Translation).Get(cspName,"申请"),
	"V":##class(websys.Translation).Get(cspName,"到达"),
	"C":##class(websys.Translation).Get(cspName,"取消"),
	"F":##class(websys.Translation).Get(cspName,"完成"),
	"D":##class(websys.Translation).Get(cspName,"已分配"),
	:"")
	Q ApplyStatus
}

ClassMethod GetOrderBilled(OrderId, cspName = "", langid = "")
{
	new (OrderId,cspName,langid,%session)
	s:cspName="" cspName="doccure.emr.cureapplist.hui.csp"
	s:langid="" langid=..%LanguageID()
	Set EpisodeID=$p(^OEORD(+OrderId),"^",1)
	Set AdmType=$p($g(^PAADM(EpisodeID)),"^",2)
	Set Ordbilled=$p(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3),"^",5)
	
	Set AdmStatus=$P($g(^PAADM(EpisodeID)),"^",20)
	Set GetStayStatusFlag=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
	if (AdmType'="I"){
		if (" 1 2 "[(" "_GetStayStatusFlag_" ")) {
			s Ordbilled=..%Translate(cspName,"留观",langid)
		}else{
			if (Ordbilled'="P") s Ordbilled=..%Translate(cspName,"否",langid)
			else  Set Ordbilled=..%Translate(cspName,"是",langid)
		}
	}else{
		Set Ordbilled=..%Translate(cspName,"在院")
		if AdmStatus="D" s Ordbilled=..%Translate(cspName,"已出院",langid)
	}
	
	Q Ordbilled
}

/// w ##class(DHCDoc.DHCDocCure.Apply).GetOrderOtherInfo("479||13")
ClassMethod GetOrderOtherInfo(OrderId)
{
	n (OrderId,%session)
	Set langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
	s OrderMainId=+OrderId
	s OrderSubId=+$p(OrderId,"||",2)
	Q:'$d(^OEORD(+OrderId,"I",OrderSubId,1)) ""
	;s OrderDoseQty=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),2)),"^",1)
	s OrderDoseQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(OrderId)
	s OrderDoseUnitID=$p($g(^OEORD(+OrderId,"I",OrderSubId,2)),"^",3)
	s OrderDoseUnit=""
	s:OrderDoseUnitID'="" OrderDoseUnit=$p(^CT("UOM",OrderDoseUnitID),"^",2)
	s OrderDoseUnit=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",OrderDoseUnit,langid)
	s PriorityDesc=""
	s PriorityDR=$p($g(^OEORD(+OrderId,"I",OrderSubId,1)),"^",8)
	s PriorityDesc=$p($g(^OECPR(PriorityDR)),"^",2)
	s PriorityDesc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",PriorityDesc,langid)
	s OrdFreqInfo=##class(DHCDoc.Interface.Inside.ServiceOrd).GetOrdFreqInfo(OrderId,"",langid)
	s PHFreqDr=$List(OrdFreqInfo,1)
	s PHFreqDesc1=$List(OrdFreqInfo,2)
	s PHFreqCode=$List(OrdFreqInfo,5)
	
	s instrDesc1=""
	s instrDr = $p($g(^OEORD(+OrderId,"I",OrderSubId,2)),"^",7)
	s:+instrDr'=0 instrDesc1=$p(^PHCIN(instrDr),"^",2)
	s instrDesc1=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",instrDesc1,langid)
	s DuratDesc=""
	s DuratDR = $p($g(^OEORD(+OrderId,"I",OrderSubId,2)),"^",6)
	s:+DuratDR'=0 DuratDesc=$p(^PHCDU(DuratDR),"^",3)	
	s DuratDesc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",DuratDesc,langid)
	s StDate=$p($g(^OEORD(+OrderId,"I",OrderSubId,1)),"^",9)
	s StDate = ##class(websys.Conversions).DateLogicalToHtml(StDate)
	s StTime = $zt($p(^OEORD(+OrderId,"I",OrderSubId,1),"^",10),1)
	s StDate=StDate_" "_StTime
	s EndDate=""
	s EndDate=$p($g(^OEORD(+OrderId,"I",OrderSubId,9)),"^",9)
	s EndDate = ##class(websys.Conversions).DateLogicalToHtml(EndDate)
	s EndTime = $p($g(^OEORD(+OrderId,"I",OrderSubId,9)),"^",10)
	s:EndTime'="" EndTime=$zt(EndTime,2)
	s:EndDate'="" EndDate=EndDate_" "_EndTime
	s FirstDayTimes=$p($g(^OEORD(+OrderId,"I",OrderSubId,1)),"^",18)
	/*i PHFreqDr'="" d
	.s WeekFlag=$P(^PHCFR(PHFreqDr),"^",9)
	.i WeekFlag="Y" d
	..s OrderFreqWeek=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),"DHC")),"^",55)
	..s PHFreqDesc1=PHFreqDesc1_" "_$TR(OrderFreqWeek,"|","")*/
	s CoverMainInsFlag=$p($g(^OEORD(+OrderId,"I",OrderSubId,3)),"^",3)
	s ret=OrderDoseQty_"^"_OrderDoseUnitID_"^"_OrderDoseUnit_"^"_PriorityDR_"^"_PriorityDesc
	s ret=ret_"^"_PHFreqDr_"^"_PHFreqDesc1_"^"_instrDr_"^"_instrDesc1_"^"_DuratDR
	s ret=ret_"^"_DuratDesc_"^"_StDate_"^"_FirstDayTimes_"^"_EndDate_"^"_PHFreqCode
	s ret=ret_"^"_CoverMainInsFlag
	Q ret
}

/// w ##class(DHCDoc.DHCDocCure.Apply).GetOrderActiveQty("1057||90")
ClassMethod GetOrderActiveQty(OrderId)
{
	n (OrderId,%session)
	s OrderAdm=$p(^OEORD(+OrderId),"^",1)
	s AdmType=$p($g(^PAADM(OrderAdm)),"^",2)
	s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	q:ArcimId="" ""
	s OrderDoseQty=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",12)
	s OrderDoseUnitID=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),2)),"^",3)
	s OrderDoseUnit=""
	s:OrderDoseUnitID'="" OrderDoseUnit=##class(web.DHCDocOrderCommon).GetUOMDesc(OrderDoseUnitID)
	s OrderPackQty=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),9)),"^",4)
	s BillingUOM="",OrderQty=0,PackUOMDesc=""
	
	s BillingUOMDR=##Class(web.DHCDocOrderCommon).GetOrdPackUOMDR(OrderId)
	s BillingUOM=##class(web.DHCDocOrderCommon).GetUOMDesc(BillingUOMDR)
	s BaseUOMDesc=""
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+ArcimId)
	i INCIRowid'="" {
		s BaseUOMRowid=$p($g(^INCI(INCIRowid,1)),"^",10)
		s BaseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(BaseUOMRowid)
	}
	s PriorityDR=$p($g(^OEORD(+OrderId,"I",+$p(OrderId,"||",2),1)),"^",8)
	s convFac=##class(appcom.OEDispensing).convFac(ArcimId,BillingUOMDR)
	s OrderAddDeptDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",2)
	s HospID=$p($g(^CTLOC(OrderAddDeptDr)),"^",22)	
	i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	s FreqItemCat=##Class(web.DHCDocConfig).GetConfigNode("FrequencedItemCat",HospID)
	if AdmType="I"  {
		if (##class(appcom.OEOrdItem).ISLongOrderPrior(PriorityDR)){
			s OrderQty=""
			s ItemCatRowid=$p($g(^ARCIM(+ArcimId,$p(ArcimId,"||",2),1)),"^",10)
			if ("^"_FreqItemCat_"^"'[("^"_ItemCatRowid_"^")){
				s OrderQty=OrderDoseQty
			}
		}else{
			if (OrderPackQty'=""){
				s OrderQty=OrderPackQty
			}else{
				s OrderPackQty=OrderDoseQty
				s OrderQty=OrderDoseQty
				s:OrderDoseUnit'="" BillingUOM=OrderDoseUnit
			}
		}
	}else{
		i (+OrderPackQty'=0) {
			s OrderQty=OrderPackQty*convFac
			s:BaseUOMDesc'="" BillingUOM=BaseUOMDesc
		}else{
			s OrderQty=OrderDoseQty
			s:OrderDoseUnit'="" BillingUOM=OrderDoseUnit
		}
		s pqty=""
		s pbrowid=0
		for {
			s pbrowid=$o(^DHCPBi(0,"OEORI",OrderId,pbrowid)) 
			q:pbrowid=""
			continue:$d(^DHCPB(pbrowid))=10
			continue:$d(^DHCPB(pbrowid))=0 
			s confdr=$o(^DHCIPBillPatFeeConfirmi(0,"Bill",+pbrowid,""))
			s pb=pbrowid
			s pbosub=0
			for {
				s pbosub=$o(^DHCPBi(0,"OEORI",OrderId,pbrowid,pbosub))
				q:pbosub=""
				continue:$d(^DHCPB(pbrowid,"O",pbosub))=10
				s pbo=^DHCPB(pbrowid,"O",pbosub)
				s pbbillqty=$p(pbo,"^",5)
				s pbrefundqty=$p(pbo,"^",6)
				s pqty=pqty+pbbillqty+pbrefundqty
			}
		}
		i +pqty'=0 s OrderQty=pqty
		s appRefInfo=##class(web.DHCOPBillOERefundQty).GetRefundQTY(OrderId, "")
		s appQty=+$p(appRefInfo,"^",2)
		s OrderQty=OrderQty-appQty
	}
	q OrderQty_"^"_BillingUOM
}

/// w ##class(DHCDoc.DHCDocCure.Apply).CheckActiveExec("1534||83")
ClassMethod CheckActiveExec(OEOrdID)
{
	n (OEOrdID)
	s ret=1
	s order=+OEOrdID
	s AdmID=$p(^OEORD(order),"^",1)
	s AdmType=$p($g(^PAADM(AdmID)),"^",2)
	s ordItem=$p(OEOrdID,"||",2)
	s OrderStatus="",OrderStatusCode=""
	s OrdStatusDR=$p($g(^OEORD(order,"I",ordItem,1)),"^",13)
	s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1),OrderStatus=$p(^OEC("OSTAT",OrdStatusDR),"^",2)
	if (OrderStatusCode'="V") && (OrderStatusCode'="E") {
		if AdmType'="I"{
			s ret=0	
		}else{
			s ret=0	
			s orderExecId=""
			f  s orderExecId=$O(^OEORD(order,"I",ordItem,"X",orderExecId),-1) q:(orderExecId="")!(ret=1)  d
			.q:orderExecId=0
			.s str = ^OEORD(order,"I",ordItem,"X",orderExecId)	
			.s ExecStateDR= $p(str,"^",16)
			.i +ExecStateDR>0 s TExecState = $p(^OEC("STAT",ExecStateDR),"^",2),TExecStateCode=$p(^OEC("STAT",ExecStateDR),"^",1)	;OEC_Order_AdminStatus
			.e  s TExecState = "未执行",TExecStateCode="未执行"
			.if (TExecState="未执行")!("F C"[TExecStateCode) s ret=1
		}
	}	
	q ret
}

ClassMethod GetCureAppPatInfo(Adm As %String)
{
	Q:Adm="" ""
	Set PatientId=$P($G(^PAADM(Adm)),"^",1)	
	s PatientInfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(PatientId)
	Q PatientInfo
}

/// w ##class(DHCDoc.DHCDocCure.Apply).GetPatientBaseInfo("",214)
ClassMethod GetPatientBaseInfo(DCARowId, adm)
{
	s ^tmpnk("GetPatientBaseInfo")=DCARowId_"^"_adm
	n (DCARowId,adm,%session)
	s name="",bedno="",age="",sex="",weight="",ipno="",insu="",ipdate=""
	q:(DCARowId="")&&(adm="") "{}"
	if (DCARowId'=""){
		Set CureData=$g(^DHCDocCure(DCARowId))
		Set Adm=$p(CureData,"^",1)
		if adm="" s adm=Adm
	}
	s papmi = +^PAADM(adm)
	s JsonInfo=##class(web.PAAdm).GetPatientBaseInfo(papmi,adm)
	;s JsonInfo=$replace(JsonInfo,"""","'")
	Quit JsonInfo
}

ClassMethod GetHospitalDesc(HosID As %String)
{
	Q:HosID="" ""
	Set Hospital=$P($G(^CT("HOSP",HosID)),"^",2)	
	Q Hospital
}

/// w ##class(DHCDoc.DHCDocCure.Apply).GetApplyPrintInfo(22,2)
ClassMethod GetApplyPrintInfo(DCARowId As %String, HosID As %String)
{
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s Hospital=""
	s Hospital=..GetHospitalDesc(HosID)
	
	s BodySetJson=##class(DHCDoc.DHCDocCure.BodySet).GetBodySet(DCARowId)
	d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData("BodySetJson^Hospital",BodySetJson_"^"_Hospital))
	s PrintInfo=""
	While (Stream.AtEnd = 0) {
        s len = 1000
        s PrintInfo=PrintInfo_Stream.Read(.len)
    }
	    
	Q PrintInfo
}

/// 更新治疗申请单信息 --用于病人申请单列表
/// 在治疗申请单查询界面的更新只能更新对应备注信息和治疗计划
/// w ##class(DHCDoc.DHCDocCure.Apply).GetCureApply(867)
ClassMethod SaveCureApply(DCARowId As %String, ApplyPlan As %String, ApplyRemark As %String, UserID As %String) As %String
{
	Quit:DCARowId="" 0
	;更新申请单
	k PLIST
	s PLIST(8)=UserID
	s PLIST(9)=+$h
	s PLIST(10)=$p($h,",",2)
	s PLIST(11)=ApplyRemark
	s PLIST(12)=ApplyPlan
	&sql(update SQLUser.DHC_DocCureApp values :PLIST() where DCA_RowId=:DCARowId)
	Q SQLCODE
}

/// Creator：      郭宝平
/// CreatDate：    2014-12-20
/// Description:： 查询单个病人治疗申请单列表
/// Table: 		  	DHC_DocCureApp
/// Input：        EpisodeID:就诊ID  PatientID  LongOnLoc 按照传入的登录科室和接收科室作比较 outCancel 是否输出已经撤销的申请
/// 修改 lxz 2017-05-12  
Query FindCureApplyList(EpisodeID As %String, PatientID As %String = "", LongOnLoc As %String = "", outCancel As %String = "", DocApplayNo As %String = "", FinishDis As %String = "") As %Query(ROWSPEC = "DCARowId:%String,ArcimDesc:%String,OrdStatus:%String,OrdQty:%String,OrdBillUOM:%String,OrdReLoc:%String,OrdReLocId:%String,ApplyStatus:%String,ApplyUser:%String,ApplyDateTime:%String,ApplyAppedTimes:%String,ApplyNoAppTimes:%String,ApplyFinishTimes:%String,ApplyNoFinishTimes:%String,ApplyRemarks:%String,ApplyPlan:%String,Adm:%String,AppLoc:%String,InsertDate:%String,InsertTime:%String,DocCurNO:%String,PapmiNo:%String,PatName:%String,Sex:%String,Pattype:%String,Tel:%String,GovNo:%String")
{
}

ClassMethod FindCureApplyListExecute(ByRef qHandle As %Binary, EpisodeID As %String, PatientID As %String = "", LongOnLoc As %String = "", outCancel As %String = "", DocApplayNo As %String = "", FinishDis As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindCureApplyList",13349882)
	Set repid=$I(^CacheTemp)
	Set ind=1
	
	k OnePerson
	if DocApplayNo'=""  d
	.s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"DCANO",DocApplayNo,DCARowId)) q:DCARowId=""  d
	..s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	..s OnePerson(DCARowId)=1
	else  if PatientID'=""  d
	.;传入患者ID按照患者查询订单
	.s PAPMIID=PatientID
	.Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
	..Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
	...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	...Quit:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
	...s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""  d
	....s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	....Q:(outCancel="Y")&(ApplyStatus'="C")
	....Q:(FinishDis="Y")&(ApplyStatus'="F")
	....Q:((outCancel'="Y")&&(FinishDis'="Y")&&(ApplyStatus'="A"))
	....s OnePerson(DCARowId)=1
	else  if EpisodeID'=""  d
	.;传入就诊按照就诊查询患者所有订单
	.s PAPMIID=$P(^PAADM(EpisodeID),"^",1)
	.Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
	..Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
	...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	...Quit:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
	...s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""  d
	....s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	....Q:(outCancel="Y")&(ApplyStatus'="C")
	....Q:(FinishDis="Y")&(ApplyStatus'="F") 
	....Q:((outCancel'="Y")&&(FinishDis'="Y")&&(ApplyStatus'="A"))
	....s OnePerson(DCARowId)=1
	else  d
	.;为空查询半年内的预约治疗单
	.for DateAplay=(+$H-(30*6)):1:+$H  d
	..s DCARowId=0
	..f  s DCARowId=$O(^DHCDocCure(0,"ApplyDate",DateAplay,DCARowId)) Q:DCARowId=""  d
	...Set CureData=$g(^DHCDocCure(DCARowId))
	...Q:CureData=""
	...Set PAAdm=$p(CureData,"^",1)
	...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	...Quit:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
	...s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	...Q:(outCancel="Y")&(ApplyStatus'="C")
	...Q:(FinishDis="Y")&(ApplyStatus'="F") 
	...Q:((outCancel'="Y")&&(FinishDis'="Y")&&(ApplyStatus'="A"))
	...s OnePerson(DCARowId)=1
	
	s DCARowId=""
	f  s DCARowId=$O(OnePerson(DCARowId),-1) Q:DCARowId=""  d
	.s rtn=..GetCureApply(DCARowId,"1")
	.Q:rtn="" 
	.s CureAppInfo=$p(rtn,$c(1),2)
	.s ArcimDesc=$p(CureAppInfo,"^")
	.s OrderStatus=$p(CureAppInfo,"^",2)
	.s OrderQty=$p(CureAppInfo,"^",3)
	.s BillingUOM=$p(CureAppInfo,"^",4)
	.s OrderReLoc=$p(CureAppInfo,"^",5)
	.s OrdReLocId=$p(CureAppInfo,"^",6)
	.Q:(LongOnLoc'="")&&(LongOnLoc'=OrdReLocId)&&(DocApplayNo="")
	.s ApplyStatus=$p(CureAppInfo,"^",7)
	.s ApplyUser=$p(CureAppInfo,"^",8)
	.s ApplyDate=$p(CureAppInfo,"^",9)
	.s ApplyAppedTimes=$p(CureAppInfo,"^",10)
	.s ApplyNoAppTimes=$p(CureAppInfo,"^",11)
	.s ApplyFinishTimes=$p(CureAppInfo,"^",12)
	.s ApplyNoFinishTimes=$p(CureAppInfo,"^",13)
	.s ApplyRemarks=$p(CureAppInfo,"^",14)
	.s ApplyPlan=$p(CureAppInfo,"^",15)
	.s Adm=$p(CureAppInfo,"^",16)
	.s AppLoc=$p(CureAppInfo,"^",17)
	.s InsertDate=$p(CureAppInfo,"^",18)
	.s InsertTime=$p(CureAppInfo,"^",19)
	.s DocCurNO=$p(CureAppInfo,"^",20)
	.
	.s PatMesage=$p(rtn,$c(1),1)
	.s PapmiNo=$P(PatMesage,"^",2)
	.s PatName=$P(PatMesage,"^",3)
	.s Sex=$P(PatMesage,"^",4)
	.s Pattype=$P(PatMesage,"^",7)
	.s Tel=$P(PatMesage,"^",25)
	.s GovNo=$P(PatMesage,"^",24)
	.d OutputRowApply
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowApply 
	set Data=$lb(DCARowId,ArcimDesc,OrderStatus,OrderQty,BillingUOM,OrderReLoc,OrdReLocId,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,ApplyRemarks,ApplyPlan,Adm,AppLoc,InsertDate,InsertTime,DocCurNO,PapmiNo,PatName,Sex,Pattype,Tel,GovNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindCureApplyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureApplyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureApplyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureApplyListExecute ]
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

/// Creator：      nikang
/// CreatDate：    2018-03-20
/// Description:   审查是否有权限查看治疗申请单,若启用分诊,则只能查询到分配到本人名下的申请单。
/// Table: 		   DHC_DocCureApp
/// Input：        DCARowID:申请单ID TriageFlag:分诊标记
/// OutPut: 	   0-无权限 1-可以查看
/// Debug:		   w ##class(DHCDoc.DHCDocCure.Apply).CheckCureApplyPermission(201,7,4636)
ClassMethod CheckCureApplyPermission(DCARowId As %String, CheckLocID As %String, LogonUerID As %String, LogonLocIDStr As %String = "")
{
	n (DCARowId,CheckLocID,LogonUerID,LogonLocIDStr,%session)
	Q:DCARowId="" 0
	s HospID=$p($g(^CTLOC(CheckLocID)),"^",22)	
	;是否启用分诊配置
	s DHCDocCureNeedTriage=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig(DCARowId,"CureLocNeedTriage",CheckLocID,HospID)
	Q:DHCDocCureNeedTriage'=1 1
	s LogonCTPCPID=$p(^SSU("SSUSR",LogonUerID),"^",14)
	Q:LogonCTPCPID="" 0
	s:LogonLocIDStr="" LogonLocIDStr=CheckLocID
	s ret=0
	s DDCTChildSub=0
	for  s DDCTChildSub=$o(^DHCDocCureTRI(DCARowId,"Triage",DDCTChildSub)) Q:DDCTChildSub=""  d
	.s DDCTRBASDR=$p(^DHCDocCureTRI(DCARowId,"Triage",DDCTChildSub),"^",1)
	.s DDCTRParRef=+DDCTRBASDR
	.s DDCTRChildSub=$p(DDCTRBASDR,"||",2)
	.s DDCTStatus=$p(^DHCDocCureTRI(DCARowId,"Triage",DDCTChildSub),"^",5)
	.Q:DDCTStatus="C"
	.s TRData=$g(^DHCDocCureTR(DDCTRParRef,"TR",DDCTRChildSub))
	.s RowID=DDCTRParRef_"||"_DDCTRChildSub
	.s DDCTRServiceGroup=$p(^DHCDocCureRBCServiceGroupSet(DDCTRParRef),"^",2)
	.s DDCTRCTLocDr=$p(TRData,"^",1)
	.s DDCTRResDr=$p(TRData,"^",2)
	.s DDCTRCTPCPDr=$p($G(^RB("RES",DDCTRResDr)),"^",2)
	.if (("^"_LogonLocIDStr_"^")[("^"_DDCTRCTLocDr_"^"))&&(LogonCTPCPID=DDCTRCTPCPDr) s ret=1
	q ret
}

/// lxz 通过就诊获取患者基本信息-医生填写申请单使用
ClassMethod getPatMesageByPaadm(PAADM As %String) As %String
{
	Q:PAADM=""
	s PatientId=$P($G(^PAADM(PAADM)),"^",1)
	Q:PatientId=""
	s PatientInfo=##class(web.DHCDocOrderEntry).GetPatientByRowid(PatientId)
	q PatientInfo
}

/// Creator：      lxz
/// CreatDate：    2014-12-20
/// Description:： 医生站和治疗工作室查询就诊记录进行就诊记录的诊疗计划预约
/// Table: 		   PAAMD
/// Input：        PatientID:患者ID StartDate 就诊开始日期 EndDate 就诊结束日期
/// 
Query FindAdm(PatientID As %String, StartDate As %String, EndDate As %String) As %Query(ROWSPEC = "PAAdm:%String,PatientID:%String,Name:%String,PAPMINO:%String,Sex:%String,Phone:%String,Age:%String,AdmType:%String,AdmLoc:%String,AdmDoc:%String,AdmDate:%String,DCANum:%String,DiaDesc:%String")
{
}

ClassMethod FindAdmExecute(ByRef qHandle As %Binary, PatientID As %String, StartDate As %String, EndDate As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindAdm",123,"","")
	s ^TMP("FindAdm")=PatientID_","_StartDate_","_EndDate
	Set repid=$I(^CacheTemp)
	Set ind=1
	s:StartDate["-" StartDate=$ZDH(StartDate,3)
	s:StartDate["/" StartDate=$ZDH(StartDate,4)
	s:EndDate["-" EndDate=$ZDH(EndDate,3)
	s:EndDate["/" EndDate=$ZDH(EndDate,4)
	s (Name,PAPMINO,Sex,Phone,Age)=""
	k AdmList
	
	//查询患者所有的就诊
	if PatientID'=""  d
	.s PatStr=##class(web.DHCDocOrderEntry).GetPatientByRowid(PatientID)
	.s Name=$P(PatStr,"^",3)
	.s PAPMINO=$P(PatStr,"^",2)
	.s Sex=$P(PatStr,"^",4)
	.s Phone=$P(PatStr,"^",25)
	.s Age=$P(PatStr,"^",5)
	.
	.Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PatientID,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
	..Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PatientID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
	...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	...Quit:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
	...s AdmDate=$P($G(^PAADM(PAAdm)),"^",6)
	...s AdmList(AdmDate,PAAdm)=1
	
	//倒序输出就诊
	s AdmDateub=""
	f  s AdmDateub=$O(AdmList(AdmDateub),-1) Q:AdmDateub=""  d
	.s PAAdm=""
	.f  s PAAdm=$O(AdmList(AdmDateub,PAAdm),-1) Q:PAAdm=""  d
	..s AdmLoc=""
	..s AdmLocID=$P($G(^PAADM(PAAdm)),"^",4)
	..s:AdmLocID'="" AdmLoc=$P($G(^CTLOC(AdmLocID)),"^",2)
	..s AdmType=$P($G(^PAADM(PAAdm)),"^",2)
	..Q:"OEI"'[AdmType
	..s AdmType=$case(AdmType,"O":"门诊","E":"急诊","I":"住院",:"其他")
	..s AdmDoc=""
	..s AdmDocDr=$P($G(^PAADM(PAAdm)),"^",9)
	..s:AdmDocDr'="" AdmDoc=$P(^CTPCP(AdmDocDr,1),"^",2)
	..Q:(StartDate'="")&&(AdmDate<StartDate)
	..Q:(EndDate'="")&&(AdmDate>EndDate)
	..s:AdmDateub'="" AdmDate=$zd(AdmDateub,3)
	..s DCANum=0
	..s DCAID=0
	..f  s DCAID=$O(^DHCDocCure(0,"Adm",PAAdm,DCAID)) Q:DCAID=""  d
	...s Statu=$P(^DHCDocCure(DCAID),"^",3)
	...Q:Statu'="A"
	...s DCANum=(DCANum+1)
	..s DiaDesc=$$getAllDia(PAAdm)
	..d OutputRowAdm
	
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowAdm
	
	set Data=$lb(PAAdm,PatientID,Name,PAPMINO,Sex,Phone,Age,AdmType,AdmLoc,AdmDoc,AdmDate,DCANum,DiaDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
getAllDia(Adm)
	s MrDiaDesc="" 
	s MrID=$P($G(^PAADM(Adm)),"^",61)
	s SubID=0
	f  s SubID=$O(^MR(MrID,"DIA",SubID)) Q:SubID=""  d
	.s Diagid=$P(^MR(MrID,"DIA",SubID),"^",1)
	.if Diagid'=""  d
	..if MrDiaDesc="" s MrDiaDesc=$P($G(^MRC("ID",Diagid)),"^",2)
	..else  s MrDiaDesc=MrDiaDesc_","_$P($G(^MRC("ID",Diagid)),"^",2)
	.else  d
	..s Note=$P(^MR(MrID,"DIA",SubID,"DES",1),"^",1)
	..Q:Note=""
	..if MrDiaDesc="" s MrDiaDesc=Note
	..else  s MrDiaDesc=MrDiaDesc_","_Note
	q MrDiaDesc
}

ClassMethod FindAdmClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAdmFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmExecute ]
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

/// Creator：      lxz
/// CreatDate：    2014-12-20
/// Description:： 治疗申请单查询医嘱项目使用
/// Table: 		   Arcim
/// Input：        Desc 项目描述 可以为空
/// 
Query FindArcim(Desc As %String = "") As %Query(ROWSPEC = "Arcim:%String,ArcimID:%String")
{
}

ClassMethod FindArcimExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindArcim","")
	s ^TMP("FindArcim")=Desc
	Set repid=$I(^CacheTemp)
	Set ind=1
	i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	s DHCDocCureItemCatStr=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureItemCat",HospID)
	for i=1:1:$L(DHCDocCureItemCatStr,"^")  d
	.s SubCat=$P(DHCDocCureItemCatStr,"^",i)
	.Q:SubCat=""  
	.s Sub1=0
	.f  s Sub1=$O(^ARCIM(0,"ARCIC_DR",SubCat,Sub1)) Q:Sub1=""  d
	..s Sub2=0
	..f  s Sub2=$O(^ARCIM(0,"ARCIC_DR",SubCat,Sub1,Sub2)) Q:Sub2=""  d
	...s ArcimID=Sub1_"||"_Sub2
	...s Arcim=$P(^ARCIM(Sub1,Sub2,1),"^",2)
	...s stopdate=+$p($G(^ARCIM(Sub1,Sub2,7)),"^",1)
	...Q:(stopdate'=0)&&(stopdate<+$H)
	...s Find="N"
	...if Desc="" d
	....s Find="Y"
	...else  d
	....s Sub3=0
	....f  s Sub3=$O(^ARC("ALIAS",0,"ARCIM",Sub1_"||"_Sub2,Sub3)) Q:Sub3=""  d
	.....s SubDesc=$P(^ARC("ALIAS",Sub3),"^",6)
	.....if $E($ZCVT(SubDesc,"U"),1,$L($ZCVT(Desc,"U")))=$ZCVT(Desc,"U")  d
	......s Find="Y"
	....if Find="N"  d
	.....s:$E($ZCVT(Arcim,"U"),1,$L($ZCVT(Desc,"U")))=$ZCVT(Desc,"U") Find="Y"
	...Q:Find'="Y"
	...
	...d OutputRowArcim
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowArcim
	
	set Data=$lb(Arcim,ArcimID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindArcimClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcimFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimExecute ]
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

/// Creator：      lxz
/// CreatDate：    2014-12-20
/// Description:： 治疗申请单查询医嘱项目使用接收科室
/// Table: 		   Arcim
/// Input：        Desc 项目描述 可以为空
/// 
Query FindArcimReloc(ArcimID As %String = "", AdmID As %String = "", UserID As %String = "", LocID As %String = "") As %Query(ROWSPEC = "RelocDesc:%String,Reloc:%String,selected:%Boolean")
{
}

ClassMethod FindArcimRelocExecute(ByRef qHandle As %Binary, ArcimID As %String = "", AdmID As %String = "", UserID As %String = "", LocID As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	s ^lxz1=ArcimID_","_AdmID_","_UserID_","_LocID
	///4893||1,,,110
	//d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindArcimReloc","4893||1","","",110)
	if (ArcimID'="")&&(LocID'="")  d
	.s CureLocStr=$g(^DHCDocConfig("DHCDocCureLocStr")) 
	.s RecLocStr=##class(web.DHCDocOrderCommon).GetLocRecLoc(LocID,ArcimID,"")
	.s Leng1=$L(RecLocStr,$C(2))
	.b ;1
	.//医嘱项目下医嘱接收科室
	.for i=1:1:Leng1  d
	..s SubReloc=$P(RecLocStr,$C(2),i)
	..s Reloc=$P(SubReloc,$C(1),1)
	..s RelocDesc=$P(SubReloc,$C(1),2)
	..s Default=$P(SubReloc,$C(1),3)
	..s Defaul=$case(Default,"Y":1,1:1,:0)
	..s Defaul=1
	..Q:("^"_CureLocStr_"^")'[("^"_Reloc_"^")
	..d OutputRowArcimRelLoc
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowArcimRelLoc
	set Data=$lb(RelocDesc,Reloc,Defaul)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindArcimRelocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindArcimRelocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcimRelocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcimRelocExecute ]
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

/// lxz 撤销 申请单 
ClassMethod CancelCureApplyNew(DCARowId As %String, UserID As %String) As %String
{
	Q:DCARowId="" "-1^订单信息不能传入为空"
	Q:'$D(^DHCDocCure(DCARowId)) "-1^不存在订单信息"
	Q:UserID="" "-1^操作员信息不存在"
	s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	Q:ApplyStatus="C" "-1^已经是撤销状态"
	s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	Q:ApplyStatus="F" "-1^已经完成的申请单不能撤销"
	
	s Str=..CheckData(DCARowId,"C")
	s FindArriveNum=+$P(Str,"^",2)
	Q:(FindArriveNum>0) "-1^申请单的预约治疗记录已经存在到达的记录，如有需要请联系治疗室设置申请记录为完成。不能进行撤销操作!"
	
	
	s Statu="C"
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	&sql(update SQLUser.DHC_DocCureApp set DCA_Status= :Statu,DCA_UpdateUser_DR=:UserID,
	DCA_UpdateDate=:NowDate,DCA_UpdateTime=:NowTime where DCA_RowId=:DCARowId)
	q SQLCODE
}

/// lxz 完成 申请单 
ClassMethod FinishCureApply(DCARowId As %String, UserID As %String, Type As %String = "") As %String
{
	Q:DCARowId="" "-1^申请单信息不能为空"
	Q:'$D(^DHCDocCure(DCARowId)) "-1^不存在该申请单信息"
	Q:UserID="" "-1^操作员信息不存在"
	if Type="" s Type="F"
	s ret=..CheckData(DCARowId,Type)
	Q:ret'="" ret
	
	if Type="CF"{
		;撤消完成的时候 应该置为 A 还是 D
		s DHCDocCureNeedTriage=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig(DCARowId,"CureLocNeedTriage")
		if DHCDocCureNeedTriage=1{
			s Type="D"	
		}else{
			s Type="A"	
		}
	}
	
	s Statu=Type
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	&sql(update SQLUser.DHC_DocCureApp set DCA_Status= :Statu,DCA_UpdateUser_DR=:UserID,
	DCA_UpdateDate=:NowDate,DCA_UpdateTime=:NowTime,DCA_FinishDate=:NowDate,DCA_FinishTime=:NowTime where DCA_RowId=:DCARowId)
	q SQLCODE
}

/// lxz 增加申请单医嘱记录  在选中预约记录的时候录入医嘱
/// input DCAARowId 预约ID  OrderID医嘱ID
ClassMethod InsertAppOrder(DCAARowId As %String, OrderID As %String) As %String
{
	s $ZT="InsertAppOrderError"
	n (DCAARowId,OrderID)
	Q:DCAARowId="" 0
	Q:OrderID="" 0
	s NowDate=+$H
	s NowTime=$P($H,",",2)
	s ParRef=+DCAARowId
	s Adduser=$P(^OEORD(+OrderID,"I",$P(OrderID,"||",2),7),"^",2)
	&sql(insert into SQLUser.DHC_DocCureAppOrder 
	(DCAO_ParRef,DCAO_EORI_DR,DCAO_UpdateUserDR,DCAO_UpdateDate,DCAO_UpdateTime,DCAO_AplayDr)
	values(:ParRef,:OrderID,:Adduser,:NowDate,:NowTime,:DCAARowId)
	)
	q SQLCODE
InsertAppOrderError
	q 0
}

/// desc DCAARowId 申请单ID  Statu 将要设置的申请单状态 PAPMIID 患者ID InsertStr 申请单新增时的新增数据
/// 当Statu=A时申请单新增 匹配接收科室下是否还存在有效的申请单
/// 当Statu=C 或者F 的时候提示 申请单信息
/// w ##class(DHCDoc.DHCDocCure.Apply).CheckData(14,"F","")
ClassMethod CheckData(DCARowId As %String, Statu As %String, InsertStr As %String = "", ByRef ErrMsg As %String = "") As %String
{
	n (DCARowId,Statu,InsertStr,ErrMsg,%session)
	Set CureData=$g(^DHCDocCure(DCARowId))
	if (Statu="A"){
		;插入预约单的时候查询是否存在相同接收科室的申请单
		s PAPMIID=""
		s DCAAdmDR=$P(InsertStr,"^",1) ;就诊ID
		s:DCAAdmDR'="" PAPMIID=$P($G(^PAADM(DCAAdmDR)),"^",1)
		s DCAAppUserDR=$P(InsertStr,"^",2) ;治疗单申请人
		s AppLocDR=$P(InsertStr,"^",3) ;申请人科室
		s DCAAppDate=$P(InsertStr,"^",4) ;申请治疗开始日期
		s Remark=$P(InsertStr,"^",5) ;备注
		s DCAAppPlan=$P(InsertStr,"^",6) ;治疗计划
		s ArcimID=$P(InsertStr,"^",7) ;申请项目
		s ArcimReloc=$P(InsertStr,"^",8) ;接收科室
		s DCANum=+$P(InsertStr,"^",9) ;申请次数
		s FindActiveFlag="N"
		if PAPMIID'=""  d
		.Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
		..Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
		...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
		...Quit:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
		...s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""  d
		....s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
		....Q:ApplyStatus'="A"
		....s Str=..GetCureApply(DCARowId)
		....s ApplayMes=$P(Str,$C(1),2)
		....s ApplyReloc=$P(ApplayMes,6)
		....if AppLocDR=AppLocDR  d
		.....s FindActiveFlag="Y"
		Q FindActiveFlag

	}elseif (Statu="C"){
		s ApplyStatus=$p(CureData,"^",3)
		;已完成的申请单不允许撤销
		if ApplyStatus="F"{
			s ErrMsg="已完成的治疗申请不允许撤销"
			Q "-10001"
		}
		;已撤销的申请单不允许撤销
		if ApplyStatus="C"{
			s ErrMsg="已撤销的治疗申请不允许撤销"
			Q "-10002"
		}
		;已分配的申请单不允许撤销
		if ApplyStatus="D"{
			;s ErrMsg="已分配的治疗申请不允许撤销"
			;Q "-10003"
		}
		s count=0
		s CureOrderId=$p(CureData,"^",2)
		Q:CureOrderId="" ""
		s OEOREChild=0
		for  s OEOREChild=$o(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild)) q:OEOREChild=""  d
		.s ChangeDate=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",19)
		.s ChangeStatus=""
		.s ChangeType=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",16)
		.s:ChangeType'="" ChangeStatus=$p(^OEC("STAT",ChangeType),"^",1)
		.if ChangeStatus="F" s count=count+1
		;存在已执行的执行记录的申请单不允许撤销
		if $g(count)>0{
			s ErrMsg="存在已执行的执行记录的治疗申请不允许撤销"
			Q "-10004"
		}	
		;当进生申请单的撤销或者完成操作的时候进行判断还有多少未到达的申请单预约记录
		s FindArriveNum=0
		s FinAppNum=0
		if DCARowId'=""  d
		.s AppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowId)
		.s FinAppNum=$p(AppInfo,"^",1)
		.s FindArriveNum=$p(AppInfo,"^",2)
		if (FinAppNum>0)!(FindArriveNum>0){
			s ErrMsg="存在已预约的治疗记录的治疗申请不允许撤销"
			Q "-10005"
		}
	}elseif (Statu="F"){
		s ApplyStatus=$p(CureData,"^",3)
		Q:ApplyStatus="F" "-101^该申请已经完成,不能再次完成."
		Q:ApplyStatus="C" "-103^已经撤销的申请单不能进行完成操作."
		s Adm=$P(CureData,"^",1)
		s OrderId=$p(CureData,"^",2)
		s myrtn=##class(DHCDoc.DHCDocCure.Appointment).CheckAdmType(Adm,OrderId)
		if ("^1081^1082^")[("^"_myrtn_"^"){
			s ErrMsg="患者就诊状态异常,不能进行完成操作,请核实!"
			Q "-11001^"_ErrMsg
		}elseif myrtn="108"{
			s ErrMsg="该治疗申请医嘱未缴费,不能进行完成操作!"
			Q "-11002^"_ErrMsg
		}
		
		s count=0,InvalidCount=0
		s CureOrderId=$p(^DHCDocCure(DCARowId),"^",2)
		Q:CureOrderId="" ""
		s OEOREChild=0
		for  s OEOREChild=$o(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild)) q:OEOREChild=""  d
		.s ChangeDate=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",19)
		.s ChangeStatus=""
		.s ChangeType=$p(^OEORD(+CureOrderId,"I",$p(CureOrderId,"||",2),"X",OEOREChild),"^",16)
		.s:ChangeType'="" ChangeStatus=$p(^OEC("STAT",ChangeType),"^",1)
		.if (ChangeStatus="C")||(ChangeStatus="") s count=count+1
		.if (ChangeStatus="R") s InvalidCount=InvalidCount+1 
		q:$g(count)>0 "-11003^存在有效的未完成治疗记录."
		q:$g(InvalidCount)>0 "-11004^存在无效的治疗记录."
		s FindArriveNum=0
		s FinAppNum=0
		if DCARowId'=""  d
		.s AppInfo=##class(DHCDoc.DHCDocCure.Appointment).GetApplyAppInfo(DCARowId)
		.s FinAppNum=$p(AppInfo,"^",1)
		.s FindArriveNum=$p(AppInfo,"^",2)
		if (FinAppNum-FindArriveNum>0) Q "-11005^存在未治疗的预约记录."
	}elseif (Statu="CF"){
		s ApplyStatus=$p(CureData,"^",3)
		Q:ApplyStatus'="F" "-12001^该申请不是完成状态,无需撤消完成."
	}
	q ""
}

/// Creator：      lxz
/// CreatDate：    2014-12-20
/// Description:： 查询预约记录中录入的医嘱记录
/// Table: 		   DHC_DocCureAppOrder
/// Input：        DHCAARowID 预约记录ID
/// 
Query FindOrder(DHCAARowID As %String = "") As %Query(ROWSPEC = "OrderName:%String,statDesc:%String,OrderNum:%String,OrderBilled:%String,OrderRecDep:%String,UserAdd:%String,UserDepart:%String,DateTime:%String,Order:%String,DHCAOrdeID:%String,Adm:%String")
{
}

ClassMethod FindOrderExecute(ByRef qHandle As %Binary, DHCAARowID As %String) As %Status
{
	
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindOrder","")
	Set repid=$I(^CacheTemp)
	Set ind=1
	if +DHCAARowID'=0  d
	.Set CureData=$g(^DHCDocCure(+DHCAARowID))
	.Set Adm=$p(CureData,"^",1)
	.s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(Adm)
	.s SubOrderDi=0
	.f  s SubOrderDi=$O(^DHCDocCure(+DHCAARowID,"OrderApplayDr",DHCAARowID,SubOrderDi)) Q:SubOrderDi=""  d
	..s DHCAOrdeID=+DHCAARowID_"||"_SubOrderDi
	..s DataStr=$G(^DHCDocCure(+DHCAARowID,"Order",SubOrderDi))
	..s Order=$P(DataStr,"^",1)
	..Q:Order=""
	..s OrderID=+Order
	..s SubID=$P(Order,"||",2)
	..s Statu=$P(DataStr,"^",2)
	..s Adduser=$P(DataStr,"^",3)
	..s InsertDate=$P(DataStr,"^",4)
	..s InsertTime=$P(DataStr,"^",5)
	..s Mark=$P(DataStr,"^",6)
	..s ApplayID=$P(DataStr,"^",7)
	..s ArcimID=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",2)
	..s OrderName=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",2) 
	..s statcode="V"
	..s statDesc="核实"
	..s TtemStat=$P($G(^OEORD(OrderID,"I",SubID,1)),"^",13) 
	..i TtemStat'="" d
	...s statcode=$p($g(^OEC("OSTAT",TtemStat)),"^",1)
	...s statDesc=$p($g(^OEC("OSTAT",TtemStat)),"^",2) 
	..s OrderBilled=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",5)
	..;下医嘱人
	..s UserAdd=$p($g(^OEORD(OrderID,"I",SubID,7)),"^",1) 
	..if UserAdd'="" Set UserAdd=$P($G(^SSU("SSUSR",UserAdd)),"^",2)
	..;下医嘱科室
	..s UserDepart=""  
	..s UserDepartId=$p($g(^OEORD(OrderID,"I",SubID,7)),"^",2)
	..If UserDepartId'=""  d
	...Set UserDepart=$P($G(^CTLOC(UserDepartId)),"^",2)
	...if UserDepart["-" s UserDepart=$P(UserDepart,"-",2)
	..;接收科室
	..s OrderRecDepRowid=$P($G(^OEORD(OrderID,"I",SubID,3)),"^",6) ;OEORI_RecDep_DR
	..s OrderRecDep=""
	..if OrderRecDepRowid'="" s OrderRecDep=$P(^CTLOC(OrderRecDepRowid),"^",2)
	..if OrderRecDep["-" s OrderRecDep=$P(OrderRecDep,"-",2)
	..s ItemCatDr=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),1),"^",10) 
	..s OrderType=""
	..if ItemCatDr'="" d
	...s OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	..s OrderPackQty=$P($G(^OEORD(OrderID,"I",SubID,9)),"^",4)
	..s OrderPackUOM=""
	..;s ARCIMBillingUOM=$P(^ARCIM(+ArcimID,$P(ArcimID,"||",2),8),"^",14)
	..s ARCIMBillingUOM=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(ArcimID,AdmType)
	..s:ARCIMBillingUOM'="" OrderPackUOM=$P(^CT("UOM",ARCIMBillingUOM),"^",2)
	..i OrderType'="R" d
	...s DoseqtySum=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",12)
	...s OrderPackQty=DoseqtySum
	..s OrderNum=OrderPackQty_OrderPackUOM
	..s OrderDate=$p($g(^OEORD(OrderID,"I",SubID,3)),"^",7)	;下医嘱日期
	..if OrderDate'="" s OrderDate=$zd(OrderDate,3)
	..s OrderTime=$p($g(^OEORD(OrderID,"I",SubID,1)),"^",17)	;下医嘱时间
	..S:OrderTime'="" OrderTime=$ZT(OrderTime,2)
	..s DateTime=OrderDate_" "_OrderTime
	..d OutputRowOrder
	Set qHandle=$lb(0,repid,0) 
	Quit $$$OK
OutputRowOrder
	
	set Data=$lb(OrderName,statDesc,OrderNum,OrderBilled,OrderRecDep,UserAdd,UserDepart,DateTime,Order,DHCAOrdeID,Adm)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
}

ClassMethod FindOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrderExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrderExecute ]
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

/// desc：取治疗关联科室配置(包含自身关联的其他科室以及关联到自身科室的科室)
/// Creator:nikang
/// CreateTime:20180313
/// Debug:w ##class(DHCDoc.DHCDocCure.Apply).GetLinkLoc(44)
ClassMethod GetLinkLoc(LocID)
{
	q:LocID="" ""
	s ret=""
	s RowID=""
	f  s RowID=$o(^DHCDocCureLinkLoci(0,"MAINLOC",LocID,RowID)) q:RowID=""  d
	.s LinkLocID=$p(^DHCDocCureLinkLoc(RowID),"^",2)
	.if ret="" s ret=LinkLocID
	.else  s ret=ret_"^"_LinkLocID
	s MainLocRowID=""
	f  s MainLocRowID=$o(^DHCDocCureLinkLoci(0,"LINKLOC",LocID,MainLocRowID)) q:MainLocRowID=""  d
	.if ret="" s ret=MainLocRowID
	.else  s ret=ret_"^"_MainLocRowID
	if ret="" s ret=LocID
	else  s ret=ret_"^"_LocID
	q ret
}

Query LookUpItem(Item As %String, GroupID As %String, Category As %String, SubCategory As %String, TYPE As %String, OrderDepRowId As %Library.String, OrderPriorRowId As %Library.String, EpisodeID As %Library.String, BillingGrp As %Library.String, BillingSubGrp As %Library.String, UserRowId As %Library.String, OrdCatGrp As %Library.String, NonFormulary As %Library.String, Form As %Library.String, Strength As %Library.String, Route As %Library.String) As %Query(CONTAINID = 0, ROWSPEC = "医嘱名称:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,医嘱子类:%String,价格:%String,基本药物:%String,计价单位:%String,库存数:%String,打包数:%String,通用名:%String,在途数:%String,收费规定:%String,医保类别:%String,自付比例:%String,接收科室:%String,代码:%String")
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

/// d ##class(%ResultSet).RunQuery("web.DHCDocOrderEntry","LookUpItem","%lhn",100)
ClassMethod LookUpItemExecute(ByRef QHandle As %Binary, Item As %String = "", GroupID As %Library.String = "", Category As %Library.String = "", SubCategory As %Library.String = "", TYPE As %Library.String = "", OrderDepRowId As %Library.String = "", OrderPriorRowId As %Library.String = "", EpisodeID As %Library.String = "", BillingGrp As %Library.String = "", BillingSubGrp As %Library.String = "", UserRowId As %Library.String = "", OrdCatGrp As %Library.String = "", NonFormulary As %Library.String = "", Form As %Library.String = "", Strength As %Library.String = "", Route As %Library.String = "") As %Status
{
	
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
  
   n OEOrderRS
  if Category'="on" 
  {
   set OEOrderRS=##class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
   d OEOrderRS.Execute(Item,GroupID,"","","","","","","","","","","",%session.Get("LOGON.CTLOCID"),%session.Get("LOGON.HOSPID"),"")
   Set columns = OEOrderRS.GetColumnCount()
   If $SYSTEM.Status.IsOK(OEOrderRS)
   {
	   while (OEOrderRS.Next())
      {
	
		continue:OEOrderRS.GetData(4)="ARCOS"
		
		s Data=""	
		for i=1:1:columns {
			s $List(Data,i)=OEOrderRS.GetData(i)
		}
		s ArcimRowid1=OEOrderRS.GetData(2)
		s ItemCatRowid1=$p($g(^ARCIM(+ArcimRowid1,$p(ArcimRowid1,"||",2),1)),"^",10)
		continue:(SubCategory="on")&&(##class(DHCDoc.DHCDocCure.Apply).GetCureItemFlag(ArcimRowid1)'=1)
		s $List(Data,17)=ItemCatRowid1
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
   
      }
   }
   d OEOrderRS.Close()
 
   s OEOrderRS=""
   }else{ 
   n OEOrderRS
   set OEOrderRS=##class(%ResultSet).%New("web.DHCDocOrderEntryCM:LookUpItem")
   d OEOrderRS.Execute(Item,GroupID,"","","","ALL","","","","","","","","","","")
   Set columns = OEOrderRS.GetColumnCount()
   If $SYSTEM.Status.IsOK(OEOrderRS)
   {
	   while (OEOrderRS.Next())
      {
	
		continue:OEOrderRS.GetData(4)="ARCOS"
		
		s Data=""	
		for i=1:1:columns {
			s $List(Data,i)=OEOrderRS.GetData(i)
		}
		s ArcimRowid1=OEOrderRS.GetData(2)
		continue:(SubCategory="on")&&(##class(DHCDoc.DHCDocCure.Apply).GetCureItemFlag(ArcimRowid1)'=1)
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

Query FindAllItem(Alias As %String, CureItemFlag As %String = "", GroupID As %Library.String = "", EpisodeID As %Library.String = "", UserRowId As %Library.String = "", ManualApply As %Library.String = "", SubCategory As %Library.String = "", HospID As %Library.String = "") As %Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String,selected:%Boolean,DDCISRowid:%String")
{
}

ClassMethod FindAllItemExecute(ByRef qHandle As %Binary, Alias As %String, CureItemFlag As %String = "", GroupID As %Library.String = "", EpisodeID As %Library.String = "", UserRowId As %Library.String = "", ManualApply As %Library.String = "", SubCategory As %Library.String = "", HospID As %Library.String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindAllItem","宗(Zung)氏焦虑自评量表","on","","","","","")
	s ^tmpnk("find")=Alias_","_CureItemFlag_","_GroupID_","_EpisodeID_","_UserRowId_","_ManualApply_","_SubCategory
	if (SubCategory="")&&(Alias="") Quit $$$OK
	i ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s Form=""_$c(3)_HospID
	s ind=1
	s qrs=##Class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d qrs.Execute(Alias,GroupID,"",SubCategory,"","","",EpisodeID,"","",UserRowId,"","",Form,"","^1")
	while(qrs.Next()){
		s ArcimDesc=qrs.GetData(1)
		s ArcimID = qrs.GetData(2)
		s ARCIMType=qrs.GetData(4)
		continue:ARCIMType="ARCOS"
		continue:ArcimID=""
		s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(ArcimID,HospID)
		continue:(CureItemFlag="on")&&(##class(DHCDoc.DHCDocCure.Apply).GetCureItemFlag(ArcimID,HospID)'=1)
		s selected=0
		set ArcimDesc=##class(DHCDoc.Common.Translate).GetTransARCIM(ArcimDesc)
		d OutputRowFindAllItem
	}
	d qrs.%Close()
	Quit $$$OK
OutputRowFindAllItem
	Set Data=$lb(ArcimID,ArcimDesc,selected,DDCISRowid)
	set qHandle($I(ind))=Data
	Quit
}

ClassMethod FindAllItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllItemExecute ]
{
 	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

Query CombListFind(CombName As %String, Inpute1 As %String, Inpute2 As %String, Inpute3 As %String, Inpute4 As %String = "", Inpute5 As %String = "", Inpute6 As %String = "", InputeExp As %String = "") As %Query(ROWSPEC = "CombDesc:%String,CombValue:%String,selected:%Boolean,CombCode:%String,CombNote:%String")
{
}

ClassMethod CombListFindExecute(ByRef qHandle As %Binary, CombName As %String, Inpute1 As %String, Inpute2 As %String, Inpute3 As %String, Inpute4 As %String = "", Inpute5 As %String = "", Inpute6 As %String = "", InputeExp As %String = "") As %Status
{
	;s $ZT="ErrorCombListFind"
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","CombListFind","DHCDocOrderRecLoc","6026||1","","3","285","","","")
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","CombListFind","SubCategory","","","0","4235","7")
	s ^tmpnk("CombListFindExecute",CombName)=$lb(CombName,Inpute1,Inpute2,Inpute3,Inpute4,Inpute5,Inpute6,InputeExp)
	k TempList
	s langid=..%LanguageID()
	s HospID=""
    if ($d(%session)){
        s HospID=+$g(%session.Data("LOGON.HOSPID"))
    }
	if (CombName="DHCDocOrderRecLoc"){
		s (RecLocStr,AssScaleID,OrderOpenForAllHosp)=""
		s ARCIMRowid=Inpute1
		s DefaultReclocRowid=Inpute2
		s ProirityRowid=Inpute3
		s EpisodeID=Inpute4
		s OrderDepRowid=Inpute5
		s CureLocFlag=Inpute6
		if InputeExp'=""{
			s AssScaleID=$p(InputeExp,"^",1)
			s OrderOpenForAllHosp=$p(InputeExp,"^",2)		
		}
		s FindRecLocByLogonLoc=0
		if OrderDepRowid'=""{
			s FindRecLocByLogonLoc=1	
		}
		s ParamObj={}
		if (RecLocStr="")&&(ARCIMRowid'=""){
			s ParamObj.EpisodeID=EpisodeID
			s ParamObj.SessionStr=..%SessionStr()
			s ParamObj.OpenForAllHosp=OrderOpenForAllHosp
			s ParamObj.FindRecLocByLogonLoc=FindRecLocByLogonLoc
			s ParamObj.DefaultReclocRowid=DefaultReclocRowid
			s ParamObj.OrderARCIMRowid=ARCIMRowid
			s ParamObj.OrderInstrRowid=""
			s ParamObj.OrderDateStr=""
			s ParamObj.OrderPriorRowid=ProirityRowid
			s ParamObj.OrderPriorRemarksRowId=""
			s ParamJson=ParamObj.%ToJSON()
			s RecLocStrJson=##class(web.DHCDocOrderCommon).GetRecLocInfo(ParamJson)
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(RecLocStrJson,.RecLocStrAry)
			s RecLocStr=$g(RecLocStrAry("CurrentRecLocStr"))
		}
		s LenR=$L(RecLocStr,$c(2))
		s JNO=0
		for J=1:1:LenR{
			s SUStr=$P(RecLocStr,$c(2),J)
			s SRowID=$P(SUStr,$C(1),1)
			Continue:SRowID=""
			if (CureLocFlag'="N"){
				if AssScaleID'=""{
					if (+(##class(DHCDoc.DHCDocCure.AssScaleConfig).CheckAssScaleSetLoc(SRowID,AssScaleID,HospID))'=1){
						Continue
					}
				}elseif (+(##class(DHCDoc.DHCDocCure.Apply).GetCureLocFlag(SRowID,ARCIMRowid,"Y",HospID))'=1){
					Continue
				}
			}
			s SDesc=$P(SUStr,$C(1),2)
			s SDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",SDesc,langid)
			s Default=$P(SUStr,$C(1),3)
			s CTLocContactName=$P(^CTLOC(SRowID),"^",43)
			s CTLocContactName=$$ALPHAUP^SSUTIL4(CTLocContactName)
			if (DefaultReclocRowid'="") {
				if (DefaultReclocRowid=SRowID) s Default=1
				else  s Default=0
			}else{
				if (Default="Y") s Default=1
			    e  s Default=0
			}
			s JNO=JNO+1
			s TempList(JNO)=SDesc_"^"_SRowID_"^"_Default_"^"_CTLocContactName
		}
	}elseif(CombName="AppendItemRecLoc"){
		s ARCIMRowid=Inpute1
		s ReturnMesag=##class(web.DHCARCOrdSets).GetLocRecLoc(ARCIMRowid)
		s LenR=$L(ReturnMesag,$c(2))
		s JNO=0
		for J=1:1:LenR{
			s SUStr=$P(ReturnMesag,$c(2),J)
			s SRowID=$P(SUStr,$C(1),1)
			Continue:SRowID=""
			s SDesc=$P(SUStr,$C(1),2)
			s SDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",SDesc,langid)
			s Default=$P(SUStr,$C(1),3)
			s CTLocContactName=$P(^CTLOC(SRowID),"^",43)
			//科室检索码
			s CTLocContactName=$$ALPHAUP^SSUTIL4(CTLocContactName)
			if (Inpute3=1) {
				if (Inpute2=SRowID) s Default=1
				else  s Default=0
			}else{
				//if (Default="Y") s Default=1
			    //e  s Default=0
			    s Default=0 //默认or不默认？
			}
			s JNO=JNO+1
			s TempList(JNO)=SDesc_"^"_SRowID_"^"_Default_"^"_CTLocContactName
		}
	}elseif(CombName="CureItemPlan"){
		;治疗方案模板
		s DefaultComb="0"
		s DDCISRowid=Inpute1
		s Type=Inpute2
	 	Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.CureItemSet:FindCureItemPlan")
	 	do rset.Execute(DDCISRowid,"",Type)
	 	While (rset.Next()) {
			s CombDesc=rset.GetData(1)
			s CombValue=rset.GetData(3)
			s CombNote=rset.GetData(2)
			s Sub=$O(TempList(""),-1)+1
			s TempList(Sub)=CombDesc_"^"_CombValue_"^"_DefaultComb_"^^"_CombNote
		}
	 	d rset.Close()
	}elseif(CombName="SubCategory"){
		;医嘱子类
		s DefaultComb="0"
	 	Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:FindCatList")
	 	do rset.Execute()
	 	While (rset.Next()) {
		 	s CureFlag=rset.GetData(3)
		 	continue:CureFlag'=1
			s CombDesc=rset.GetData(2)
			s CombValue=rset.GetData(1)
			s Sub=$O(TempList(""),-1)+1
			s TempList(Sub)=CombDesc_"^"_CombValue_"^"_DefaultComb
		}
	 	d rset.Close()
	}elseif (CombName="OrderBillType"){
		s EpisodeID=Inpute1
		s BillTypeID=$p($g(^PAADM(EpisodeID,1)),"^",7)
		s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
		s PrescriptTypeStr=""
		s DefaultType=""
		if (BillTypeID'=""){
			s PrescriptTypeStr=##class(web.DHCDocOrderCommon).GetPrescriptTypeInfo(BillTypeID,PAAdmType)
			// ^ 分割第二个为默认
			//1:自费;2:省医保^1:自费
			s DefaultType=$p(PrescriptTypeStr,"^",2)
			s PrescriptTypeStr=$p(PrescriptTypeStr,"^",1)
			if DefaultType'="" s DefaultType=$p(DefaultType,":",1)
		}
		;s ReturnMesag=##class(web.DHCARCOrdSets).GetLocRecLoc(ARCIMRowid)
		s LenR=$L(PrescriptTypeStr,";")
		s JNO=0
		for J=1:1:LenR{
			s SUStr=$P(PrescriptTypeStr,";",J)
			s SRowID=$P(SUStr,":",1)
			Continue:SRowID=""
			s InsurFlag=##class(web.DHCDocOrderCommon).GetInsurFlag(SRowID)
			s SDesc=$P(SUStr,":",2)
			s Default=0
			if (DefaultType=SRowID) s Default=1
			s JNO=JNO+1
			s TempList(JNO)=SDesc_"^"_SRowID_"^"_Default_"^"_InsurFlag
		}
	}
	
	//统一输出接口
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Sub0=0
 	f  s Sub0=$O(TempList(Sub0)) Q:Sub0=""  d
 	.s CombDesc=$P($G(TempList(Sub0)),"^",1)
 	.s CombValue=$P($G(TempList(Sub0)),"^",2)
 	.s DefaultComb=$P($G(TempList(Sub0)),"^",3)
 	.s CombCode=$P($G(TempList(Sub0)),"^",4)
 	.s CombNote=$P($G(TempList(Sub0)),"^",5)
 	.d OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(CombDesc,CombValue,DefaultComb,CombCode,CombNote)
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

/// Creator：      NIKANG
/// CreatDate：    2017-12-20
/// Description:： 治疗科室查询本科室治疗申请单列表
/// Table: 		  DHC_DocCureApp
/// Input：        EpisodeID:就诊ID
/// 
Query FindAllCureApplyListHUI(PatientID As %String, StartDate As %String, EndDate As %String, outCancel As %String = "", FinishDis As %String = "", PatName As %String = "", TriageFlag As %String = "", LogLocID As %String = "", LogUserID As %String = "", ApplyNo As %String = "", LongOrdPriority As %String = "", CheckAdmType As %String = "", queryArcim As %String = "", queryOrderLoc As %String = "", ExecFlag As %String = "", queryExpStr As %String = "") As %Query(ROWSPEC = "DCARowId:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,OrdQty:%String,OrdBillUOM:%String,OrdReLoc:%String,ApplyStatus:%String,ApplyUser:%String,ApplyDateTime:%String,ApplyAppedTimes:%String,ApplyNoAppTimes:%String,ApplyFinishTimes:%String,ApplyNoFinishTimes:%String,OrdPrice:%String,OrdBilled:%String,ServiceGroup:%String,ServiceGroupID:%String,CallStatus:%String,ApplyExec:%String,ApplyExecFlag:%String,HistoryTriRes:%String,PatOther:%String,OrdUnitPrice:%String,ApplyNo:%String,OrdReLocId:%String,ApplyStatusCode:%String,OrdOtherInfo:%String,OrdFreqCode:%String,OrdStatusCode:%String,OrderId:%String,OrdAddLoc:%String,DCAAdmID:%String,PatientID:%String,CureCfgLimit:%String")
{
}

/// 入参TriageFlag："Y",表示分诊台查询申请单调用Query，outCancel为界面勾选已分配标示，FinishDis为界面勾选全部标示
/// 入参TriageFlag："", 表示预约工作台查询申请单调用Query，outCancel为界面勾选已取消标示，FinishDis为界面勾选完成标示
/// 入参TriageFlag："ALL", 表示治疗患者信息查询,不做权限控制
/// 入参ExecFlag【实际已无效，默认查询所有】："", 查询所有，"Y" 只显示直接执行的申请，"N" 只显示可预约的申请
ClassMethod FindAllCureApplyListHUIExecute(ByRef qHandle As %Binary, PatientID As %String, StartDate As %String, EndDate As %String, outCancel As %String = "", FinishDis As %String = "", PatName As %String = "", TriageFlag As %String = "", LogLocID As %String = "", LogUserID As %String = "", ApplyNo As %String = "", LongOrdPriority As %String = "", CheckAdmType As %String = "", queryArcim As %String = "", queryOrderLoc As %String = "", ExecFlag As %String = "", queryExpStr As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindAllCureApplyListHUI","","2022-10-31","2022-11-21","","","","ALL","13","17473","","","","","","","2^^^^A^doccure.workreport.patientcure.hui.csp")
	s ^TMP("FindAllCureApplyList")=$lb(PatientID,StartDate,EndDate,outCancel,FinishDis,PatName,TriageFlag,LogLocID,LogUserID,ApplyNo,LongOrdPriority,CheckAdmType,queryArcim,queryOrderLoc,ExecFlag,queryExpStr)
	k gHandle
	s DateFormat=##class(websys.Conversions).DateFormat()
	if StartDate'="" s StartDate=$zdh(StartDate,DateFormat)
	if EndDate'="" s EndDate=$zdh(EndDate,DateFormat)
	s:LogLocID="" LogLocID=%session.Get("LOGON.CTLOCID")
	s:LogUserID="" LogUserID=%session.Get("LOGON.USERID")
	s langid=..%LanguageID()
	s (HospID,queryCurrLocFlag,queryOrderDoc,PatMedNo,SortType,cspName,ANFFlag,querySGroupID,AllFlag,ShowByPatFlag)=""
	if queryExpStr'=""{
		s HospID=$p(queryExpStr,"^",1)
		s queryCurrLocFlag=$p(queryExpStr,"^",2) ;近查询本科
		s queryOrderDoc=$p(queryExpStr,"^",3)
		s PatMedNo=$p(queryExpStr,"^",4)
		s SortType=$p(queryExpStr,"^",5)
		s cspName=$p(queryExpStr,"^",6)
		s ANFFlag=$p(queryExpStr,"^",7)
		s querySGroupID=$p(queryExpStr,"^",8)
		s AllFlag=$p(queryExpStr,"^",9)		;查询所有标识(Y/N:看具体过滤要求)
		s ShowByPatFlag=$p(queryExpStr,"^",10)
	}
	if ($g(HospID)="")&&($d(%session)) s HospID=%session.Get("LOGON.HOSPID")
	s GCAExpStr=HospID_"^"_langid_"^"_cspName
	s:cspName="" cspName="doccure.cureapplist.hui.csp"
	s DHCDocCureNeedTriage=##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig("","CureLocNeedTriage",LogLocID,HospID)
	if (TriageFlag="Y")&&(DHCDocCureNeedTriage=0){
		Quit $$$OK	
	}
	s LogLocIDStr=..GetLinkLoc(LogLocID)
	
	s queryCurrLocStr=""
	if (queryCurrLocFlag="Y") {
        s CTLOCType = $p($g(^CTLOC(LogLocID)),"^",13)
        if (CTLOCType="W") {
            s queryCurrLocStr = ##class(EMRservice.DAL.GetPaAdmDetail).CurDeptLinkLocByDept(LogLocID)
        }else{
            s queryCurrLocStr="^"_LogLocID_"^"
        }
    }
	if LongOrdPriority="Y"{
		;按长嘱当日需执行医嘱查询,无需按日期检索,但随着日期及数据量的增大，该索引效率会越来越差
		s LOrdItemID=0 for  s LOrdItemID=$o(^DHCDocCure(0,"LONGOEORI",LOrdItemID)) q:LOrdItemID=""  d
		.s OrderStatusCode=""
		.s OrdStatusDR=$p($g(^OEORD(+LOrdItemID,"I",+$p(LOrdItemID,"||",2),1)),"^",13)
		.s:OrdStatusDR'="" OrderStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
		.Q:(OrderStatusCode'="V")&&(OrderStatusCode'="E")
		.s FindNull="1"
		.s ExecID=0
		.f  s ExecID=$O(^OEORDi(0,"OrdItem",+LOrdItemID,$P(LOrdItemID,"||",2),+$H,ExecID)) Q:ExecID=""  d
		..s FindNull="0"
		.Q:FindNull="1" ;当日没有需要执行的执行记录退出
		.s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"LONGOEORI",LOrdItemID,DCARowId)) q:DCARowId=""  d
		..s QuitFlag=$$CheckQuit()
		..Q:QuitFlag=1
		..d GetOutputRowData
	}
	elseif PatientID'=""{
		;按登记号查询
		Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PatientID,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
		.Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PatientID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
		..Q:'$d(^DHCDocCure(0,"Adm",PAAdm))
		..s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
		..Quit:AdmVisitStatus="C"
		..s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""  d
		...s ApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
		...Quit:((StartDate'="")&&(ApplyDate<StartDate))!((EndDate'="")&&(ApplyDate>EndDate))
		...s QuitFlag=$$CheckQuit()
		...Q:QuitFlag=1
		...d GetOutputRowData
	}
	elseif PatName'=""{
		;按姓名查询
		s PatName=$tr(PatName," ","")
		s PatName=$zcvt(PatName,"U")
		s PersonRowId=""
		for  Set PersonRowId=$o(^PAPERi("PAPER_PatName",PatName,PersonRowId)) q:PersonRowId=""  d
		.Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PersonRowId,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
		..Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PersonRowId,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
		...Q:'$d(^DHCDocCure(0,"Adm",PAAdm))
		...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
		...Quit:AdmVisitStatus="C"
		...s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""  d
		....s ApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
		....Quit:((StartDate'="")&&(ApplyDate<StartDate))!((EndDate'="")&&(ApplyDate>EndDate))
		....s QuitFlag=$$CheckQuit()
		....Q:QuitFlag=1
		....d GetOutputRowData
	}
	elseif ApplyNo'=""{
		;按治疗申请单号查询
		s DCARowId=0 
		for{
			s DCARowId=$o(^DHCDocCure(0,"AppNo",ApplyNo,DCARowId))
			q:DCARowId=""
			s QuitFlag=$$CheckQuit()
			continue:QuitFlag=1
			d GetOutputRowData
		}
	}
	else{
		;按日期查询
		s:StartDate="" StartDate=+$h
		s:EndDate="" EndDate=+$h
		for looploc=1:1:$l(LogLocIDStr,"^"){
			s LogLocID=$p(LogLocIDStr,"^",looploc)
			for QueryDate=StartDate:1:EndDate{
				s DCARowId=""
				for{
					s DCARowId=$o(^DHCDocCure(0,"RecDate",LogLocID,QueryDate,DCARowId))
					Q:DCARowId=""
					s QuitFlag=$$CheckQuit()
					continue:QuitFlag=1
					d GetOutputRowData
				}
			}
		}
	}
	d OutputRowFindAllCureApplyHUI
	Quit $$$OK
CheckQuit()
	s QuitFlag=1
	s OrderId=$p(^DHCDocCure(DCARowId),"^",2)
	Q:OrderId="" QuitFlag
	s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	s AdmType=$P(^PAADM(Adm),"^",2)
	s AdmLocId=$P(^PAADM(Adm),"^",4)
	Q:(queryCurrLocStr'="")&&(queryCurrLocStr'[("^"_AdmLocId_"^")) QuitFlag
	
	s PapmiDr=$p($g(^PAADM(Adm)),"^",1)
	Q:(PatientID'="")&&(PatientID'=PapmiDr) QuitFlag
	
	s PapmiName=$zcvt($P(^PAPER(PapmiDr,"ALL"),"^",1),"U")
	s PapmiName2=$zcvt($P(^PAPER(PapmiDr,"ALL"),"^",2),"U")
	if (PatName'="")&&(PapmiName'=PatName)&&(PapmiName2'=PatName){
		Q QuitFlag
	}
	
	if (PatMedNo'=""){
		s PatientMedicare=##class(web.DHCDocOrderCommon).GetMrNo("",PapmiDr,AdmType,"")
		Q:(PatientMedicare'=PatMedNo) QuitFlag
	}
	
	s OrderAddDeptDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",2)
	Q:(AllFlag'="Y")&&(queryOrderLoc'="")&&(queryOrderLoc'=OrderAddDeptDr) QuitFlag
	s OrderAddDocDr=""
	s OrderAddUserDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",1)
	if OrderAddUserDr'=""{
		s OrderAddDocDr=$p($g(^SSU("SSUSR",OrderAddUserDr)),"^",14)
	}
	Q:(queryOrderDoc'="")&&(OrderAddDocDr'=queryOrderDoc) QuitFlag
	
	s AdmType=$P(^PAADM(Adm),"^",2)
	Q:(((CheckAdmType="I")&&(AdmType'=CheckAdmType))!((CheckAdmType="O")&&(AdmType="I"))) QuitFlag
	
	s ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	Q:(queryArcim'="")&&(queryArcim'=ArcimId) QuitFlag
	
	s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByOrd(OrderId)
	if DDCISRowid=""{
		s QuitFlag=1
		Q QuitFlag
	}
	s ServiceGroupDR=$p(^DHCDocCureItemSet(DDCISRowid),"^",3)
	if ServiceGroupDR=""{
		s QuitFlag=1
		Q QuitFlag
	}
	if (querySGroupID'="")&&(ServiceGroupDR'=querySGroupID){
		s QuitFlag=1
		Q QuitFlag
	}
	
	s CureApplyNo=$p(^DHCDocCure(DCARowId),"^",18)
	Q:(ApplyNo'="")&&(ApplyNo'=CureApplyNo) QuitFlag
	
	s OrdReLocId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
	Q:(AllFlag'="Y")&&(LogLocIDStr'="")&&(("^"_LogLocIDStr_"^")'[("^"_OrdReLocId_"^")) QuitFlag

	if TriageFlag="ALL"{
		;治疗患者查询，则全部可显示，不判断下边的权限条件
		s OrdReLocId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
		s LocHospId=$p(^CTLOC(OrdReLocId),"^",22)
		if (HospID'="")&&(HospID'=LocHospId){
			s QuitFlag=1
		}else{
			s QuitFlag=0
		}
		Q QuitFlag
	}
	
	s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	s ApplyExec=$p(^DHCDocCure(DCARowId),"^",19)
	if TriageFlag'="Y"{
		;非分配界面的查询过滤
		Q:(ExecFlag="Y")&&(ApplyExec'="Y") QuitFlag
		Q:(ExecFlag="N")&&(ApplyExec="Y") QuitFlag
		;治疗预约V2 项目明细查询不判断权限
		if TriageFlag'="APP"{
			if (##class(DHCDoc.DHCDocCure.Config).CheckCureCfgLimit(OrderId,ArcimId,LogUserID,HospID)="0"){
				Q QuitFlag
			}
		}
	}
	
	s QuitFlag=0
	if TriageFlag="Y"{
		;分诊界面查询
		if (outCancel="Y")&&(FinishDis'="Y"){
			;仅勾选已分配
			s ChkApplyStatus="^D^"	
		}elseif (FinishDis="Y"){
			;只要勾选 全部
			s ChkApplyStatus="^A^D^F^"	
		}else{
			;已分配、全部 均未勾选
			s ChkApplyStatus="^A^"
		}
		s:(ChkApplyStatus'[ApplyStatus) QuitFlag=1
	}else{
		;预约界面查询
		s ApplyPermission=##class(DHCDoc.DHCDocCure.Apply).CheckCureApplyPermission(DCARowId,OrdReLocId,LogUserID,LogLocIDStr)
		s:'(ApplyPermission) QuitFlag=1
		if (outCancel="Y")&&(FinishDis'="Y"){
			;仅勾选已撤销
			s ChkApplyStatus="^C^"	
		}elseif (outCancel'="Y")&&(FinishDis="Y"){
			;仅勾选已完成
			s ChkApplyStatus="^F^"	
		}elseif (outCancel="Y")&&(FinishDis="Y"){
			;已撤销、已完成 均勾选
			s ChkApplyStatus="^F^C^"	
		}else{
			;已撤销、已完成 均未勾选
			if (DHCDocCureNeedTriage=1){
				s ChkApplyStatus="^D^"
			}else{
				s ChkApplyStatus="^A^D^"
			}
		}
		s:(ChkApplyStatus'[ApplyStatus) QuitFlag=1
	}
	q QuitFlag
GetOutputRowData
	s rtn=..GetCureApply(DCARowId,"1",GCAExpStr)
	Q:rtn="" 
	s PatientInfo=$p(rtn,$c(1),1)
	s CureAppInfo=$p(rtn,$c(1),2)
	s ApplyAppedTimes=$p(CureAppInfo,"^",10)
	s ApplyNoAppTimes=$p(CureAppInfo,"^",11)
	s ApplyFinishTimes=$p(CureAppInfo,"^",12)
	s ApplyNoFinishTimes=$p(CureAppInfo,"^",13) 
	if ANFFlag="Y"{
		;预约未完成的项目
		Q:+ApplyNoAppTimes'>0
	}
	s DCAAdmID=$p(^DHCDocCure(DCARowId),"^",1)
	if DCAAdmID'="" d
	.s AdmType=$P(^PAADM(DCAAdmID),"^",2)
	.s AdmType=##class(DHCDoc.Common.Translate).GetTransAdmType(DCAAdmID,cspName,langid)
	.s AdmDepId=$p($g(^PAADM(DCAAdmID)),"^",4)
	.s:AdmDepId'="" AdmDep=$p($g(^CTLOC(AdmDepId)),"^",2)
	.s AdmDep=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AdmDep,langid)
	.s PatientId=$P($G(^PAADM(DCAAdmID)),"^",1)
	s ApplyStatusCode=$p(^DHCDocCure(DCARowId),"^",3)
	s PatientNo=$p(PatientInfo,"^",2)
	s PatientName=$p(PatientInfo,"^",3)
	s PatientSex=$p(PatientInfo,"^",4)
	s PatientAge=$p(PatientInfo,"^",5)
	s PatientTel=$p(PatientInfo,"^",25)
	s OrdReLocId=$p(CureAppInfo,"^",6)
	s CureApplyNo=$p(CureAppInfo,"^",31) 
	s ArcimDesc=$p(CureAppInfo,"^")
	s OrderStatus=$p(CureAppInfo,"^",2)
	s OrderQty=$p(CureAppInfo,"^",3)
	s BillingUOM=$p(CureAppInfo,"^",4)
	s OrderReLoc=$p(CureAppInfo,"^",5)
	s OrdReLocId=$p(CureAppInfo,"^",6)
	s ApplyStatus=$p(CureAppInfo,"^",7)
	s ApplyUser=$p(CureAppInfo,"^",8)
	s ApplyDate=$p(CureAppInfo,"^",9)
	s OrdPrice=$p(CureAppInfo,"^",17) 
	s OrdBilled=$p(CureAppInfo,"^",18) 
	s OrdUnitPrice=$p(CureAppInfo,"^",19) 
	s ServiceGroup=$p(CureAppInfo,"^",21) 
	s CallStatus=$p(CureAppInfo,"^",22) 
	s ApplyExec=$p(CureAppInfo,"^",23) 
	s ApplyExecFlag=$p(CureAppInfo,"^",24) 
	s HisToryTriRes=$p(CureAppInfo,"^",25) 
	s OrdAddLoc=$p(CureAppInfo,"^",26) 
	s CureOrdInfo=$p(rtn,$c(1),3)
	s OrdOtherInfo=""
	if $p(CureOrdInfo,"^",1)'=""{
		s OrdOtherInfo=$p(CureOrdInfo,"^",1)_$p(CureOrdInfo,"^",3)
	}
	s OrdOtherInfo=OrdOtherInfo_" "_$p(CureOrdInfo,"^",7)_" "_$p(CureOrdInfo,"^",11)
	s OrdFreqCode=$p(CureOrdInfo,"^",15)
	s OrderId=$p(^DHCDocCure(DCARowId),"^",2)
	s OrdStatusCode=""
	s OrdStatusDR=$p($g(^OEORD(+OrderId,"I",+$P(OrderId,"||",2),1)),"^",13)
	s:OrdStatusDR'="" OrdStatusCode=$p(^OEC("OSTAT",OrdStatusDR),"^",1)
	if PatientTel="" s PatientTel="-"
	s PatOther=PatientSex_" | "_PatientAge_" | "_PatientTel_" | "_AdmType_"("_AdmDep_")"
	s DDCRSServiceGroupDesc=$p(CureAppInfo,"^",35) ;$P($G(^DHCDocCureRBCServiceGroupSet(ServiceGroup)),"^",2)
	s AppChkFlag=##class(DHCDoc.DHCDocCure.Appointment).CheckBeforeAppInsert(DCARowId,"",HospID,"Y","",.ErrMsg)
	if AppChkFlag'=0{
		
	}
	s CureCfgLimit=##class(DHCDoc.DHCDocCure.Config).CheckCureCfgLimit(OrderId,ArcimId,LogUserID,HospID)
	s Data=$lb(DCARowId,PatientNo,PatientName,PatientSex,PatientAge,PatientTel,$g(AdmType),$g(AdmDep),ArcimDesc,OrderQty,BillingUOM,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,OrdPrice,OrdBilled,DDCRSServiceGroupDesc,ServiceGroup,CallStatus,ApplyExec,ApplyExecFlag,HisToryTriRes,PatOther,OrdUnitPrice,CureApplyNo,OrdReLocId,ApplyStatusCode,OrdOtherInfo,OrdFreqCode,OrdStatusCode,OrderId,OrdAddLoc,DCAAdmID,$g(PatientId),CureCfgLimit)
 	
 	s CallStatusFlag=$p(^DHCDocCure(DCARowId),"^",16)
	if CallStatusFlag="Y" s CallStatus="正在呼叫"
	else  if CallStatusFlag="N" s CallStatus="过号"
	if TriageFlag="ALL"{
		s SortCallStatus="Z"
		s:ShowByPatFlag="Y" SortCallStatus=PatientNo
	}else{
 		s SortCallStatus=$case(CallStatus,"正在呼叫":"A","WaitCall":"B","Wait":"C","过号":"Z",:"C")
	}
 	s SortableStr=SortCallStatus ;PatientNo_SortCallStatus
 	s AppDate=$p(^DHCDocCure(DCARowId),"^",5)
 	s AppTime=$p(^DHCDocCure(DCARowId),"^",6)
 	s times=AppDate*24*3600+AppTime
 	s gHandle(SortableStr,times,DCARowId)=Data
 	Quit
OutputRowFindAllCureApplyHUI
 	if SortType=""{s SortType="A"}
	s SortType=$case(SortType,"A":1,"D":-1,:1)
	s SeqNo=""
	for{
		s SeqNo=$O(gHandle(SeqNo))
		Q:SeqNo=""
		s tmpData="",PatPrice=0,PatOthInfo=""
		s times=""
		for{
			s times=$O(gHandle(SeqNo,times),SortType)
			Q:times=""
			s Rowid=""
			for{
				s Rowid=$O(gHandle(SeqNo,times,Rowid))
				Q:Rowid=""
				s data=gHandle(SeqNo,times,Rowid)
				s qHandle($I(ind))=data
				
				s PatOthInfo=$lg(data,28)
				s PatPrice=PatPrice+$lg(data,20)
				s:tmpData="" tmpData=$LISTTOSTRING(data,"^")
			}
		}
		if ShowByPatFlag="Y"{
			s tmpData=$P(tmpData,"^",1,6)
			s $P(tmpData,"^",20)=$fn(PatPrice,"N",2)
			s $P(tmpData,"^",28)=PatOthInfo
			s $P(tmpData,"^",30)=..%Translate(cspName,"总计金额:",langid)
			s qHandle($I(ind))=$LISTFROMSTRING(tmpData,"^")	
		}
	}
	Quit
}

ClassMethod FindAllCureApplyListHUIFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllCureApplyListHUIExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// Creator：      nikang
/// CreatDate：    2019-08-30
/// Description:： 查询单个病人治疗申请单列表
/// Table: 		   DHC_DocCureApp
/// Input：        EpisodeID:就诊ID  PatientID  LongOnLoc 按照传入的登录科室和接收科室作比较 outCancel 是否输出已经撤销的申请
Query FindEMRCureApplyList(EpisodeID As %String, PatientID As %String = "", LongOnLoc As %String = "", outCancel As %String = "", DocApplayNo As %String = "", FinishDis As %String = "", StartDate As %String = "", EndDate As %String = "", queryArcim As %String = "", queryOrderLoc As %String = "") As %Query(ROWSPEC = "DCARowId:%String,PatNo:%String,PatName:%String,PatSex:%String,PatAge:%String,PatTel:%String,AdmType:%String,AdmDep:%String,ArcimDesc:%String,OrdQty:%String,OrdBillUOM:%String,OrdReLoc:%String,ApplyStatus:%String,ApplyUser:%String,ApplyDateTime:%String,ApplyAppedTimes:%String,ApplyNoAppTimes:%String,ApplyFinishTimes:%String,ApplyNoFinishTimes:%String,OrdPrice:%String,OrdBilled:%String,ServiceGroup:%String,ServiceGroupID:%String,CallStatus:%String,ApplyExec:%String,ApplyExecFlag:%String,HistoryTriRes:%String,PatOther:%String,OrdUnitPrice:%String,ApplyNo:%String,OrdReLocId:%String,OrdOtherInfo:%String,ApplyPlan:%String,ApplyAssessment:%String,OrderStatusCode:%String")
{
}

ClassMethod FindEMRCureApplyListExecute(ByRef qHandle As %Binary, EpisodeID As %String, PatientID As %String = "", LongOnLoc As %String = "", outCancel As %String = "", DocApplayNo As %String = "", FinishDis As %String = "", StartDate As %String = "", EndDate As %String = "", queryArcim As %String = "", queryOrderLoc As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindEMRCureApplyList",696)
	s ^tmplog("FindEMRCureApplyList")=$lb(EpisodeID,PatientID,LongOnLoc,outCancel, DocApplayNo, FinishDis , StartDate, EndDate, queryArcim, queryOrderLoc)
	s repid=$I(^CacheTemp)
	s langid=..%LanguageID()
    s cspName="doccure.emr.cureapplist.hui.csp"
	s ind=1
	s DateFormat=##class(websys.Conversions).DateFormat()
	if StartDate'="" s StartDate=$zdh(StartDate,DateFormat)
	if EndDate'="" s EndDate=$zdh(EndDate,DateFormat)
	k OnePerson
	;按治疗申请单号查询
	if DocApplayNo'=""  d
	.s DCARowId=0 
	.;for  s DCARowId=$o(^DHCDocCure(0,"DCANO",DocApplayNo,DCARowId)) q:DCARowId=""  d
	.for  s DCARowId=$o(^DHCDocCure(0,"AppNo",DocApplayNo,DCARowId)) q:DCARowId=""  d
	..s ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	..s OnePerson(DCARowId)=""
	else  if PatientID'=""  d
	.;传入患者ID按照患者查询订单
	.s PAPMIID=PatientID
	.Set PAAdmType="" For  Set PAAdmType=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType)) Quit:PAAdmType=""  Do
	..Set PAAdm=0  For  Set PAAdm=$O(^PAPERdr(PAPMIID,"ADM",PAAdmType,PAAdm)) Quit:PAAdm=""  Do
	...s AdmVisitStatus=$P($g(^PAADM(PAAdm)),"^",20)
	...Q:(AdmVisitStatus="C")||(AdmVisitStatus="D") //退号、已经出院的不再展示
	...s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",PAAdm,DCARowId)) q:DCARowId=""  d
	....Q:$$CheckQuitApply(DCARowId)=1
	....s OnePerson(DCARowId)=""
	else  if EpisodeID'=""  d
	.;传入就诊按照就诊查询患者所有订单
	.s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"Adm",EpisodeID,DCARowId)) q:DCARowId=""  d
	..Q:$$CheckQuitApply(DCARowId)=1
	..s OnePerson(DCARowId)=1
	else  d
	.s:StartDate="" StartDate=+$h
	.s:EndDate="" EndDate=+$h
	.for QueryDate=StartDate:1:EndDate Do
	..s DCARowId=0 for  s DCARowId=$o(^DHCDocCure(0,"ApplyDate",QueryDate,DCARowId)) q:DCARowId=""  d
	...Q:$$CheckQuitApply(DCARowId)=1
	...s OnePerson(DCARowId)=1
	
	s DCARowId=""
	for  s DCARowId=$O(OnePerson(DCARowId),-1) Q:DCARowId=""  d
	.s rtn=..GetCureApply(DCARowId,"1")
	.Q:rtn="" 
	.s Adm=$p(^DHCDocCure(DCARowId),"^",1)
	.if Adm'="" d
	..s AdmType=##class(DHCDoc.Common.Translate).GetTransAdmType(Adm,cspName,langid)
	..s AdmDepId=$p($g(^PAADM(Adm)),"^",4)
	..s:AdmDepId'="" AdmDep=##class(DHCDoc.DHCDocCure.WordReport).GetLocDesc(AdmDepId,langid)
	.s PatientInfo=$p(rtn,$c(1),1)
	.s PatientNo=$p(PatientInfo,"^",2)
	.s PatientName=$p(PatientInfo,"^",3)
	.s PatientSex=$p(PatientInfo,"^",4)
	.s PatientAge=$p(PatientInfo,"^",5)
	.s PatientTel=$p(PatientInfo,"^",25)
	.s CureAppInfo=$p(rtn,$c(1),2)
	.s OrdReLocId=$p(CureAppInfo,"^",6)
	.s CureApplyNo=$p(CureAppInfo,"^",31) 
	.s OrderStatusCode=$p(CureAppInfo,"^",34) 
	.Q:(DocApplayNo'="")&&(DocApplayNo'=CureApplyNo)
	.s ArcimDesc=$p(CureAppInfo,"^")
	.s OrderStatus=$p(CureAppInfo,"^",2)
	.s OrderQty=$p(CureAppInfo,"^",3)
	.s BillingUOM=$p(CureAppInfo,"^",4)
	.s OrderReLoc=$p(CureAppInfo,"^",5)
	.s OrdReLocId=$p(CureAppInfo,"^",6)
	.s ApplyStatus=$p(CureAppInfo,"^",7)
	.s ApplyUser=$p(CureAppInfo,"^",8)
	.s ApplyDate=$p(CureAppInfo,"^",9)
	.s ApplyAppedTimes=$p(CureAppInfo,"^",10)
	.s ApplyNoAppTimes=$p(CureAppInfo,"^",11)
	.s ApplyFinishTimes=$p(CureAppInfo,"^",12)
	.s ApplyNoFinishTimes=$p(CureAppInfo,"^",13) 
	.s OrdPrice=$p(CureAppInfo,"^",17) 
	.s OrdBilled=$p(CureAppInfo,"^",18) 
	.s OrdUnitPrice=$p(CureAppInfo,"^",19) 
	.s ServiceGroup=$p(CureAppInfo,"^",21) 
	.s CallStatus=$p(CureAppInfo,"^",22) 
	.s ApplyExec=$p(CureAppInfo,"^",23) 
	.s ApplyExecFlag=$p(CureAppInfo,"^",24) 
	.s HisToryTriRes=$p(CureAppInfo,"^",25)
	.if PatientTel="" s PatientTel="-"
	.s PatOther=PatientSex_" | "_PatientAge_" | "_PatientTel_" | "_AdmType_"("_AdmDep_")"
	.s DDCRSServiceGroupDesc=$P($G(^DHCDocCureRBCServiceGroupSet(ServiceGroup)),"^",2)
	.s DDCRSServiceGroupDesc=##class(User.DHCDocCureRBCServiceGroupSet).GetTranByDesc("DDCSGSDesc",DDCRSServiceGroupDesc,langid)
	.s ApplyPlan=$p(CureAppInfo,"^",15) 
	.if ApplyPlan'="" s ApplyPlan=1
	.s ApplyAssement=""
	.s DCAssChildSub=0 
	.for  s DCAssChildSub=$o(^DHCDocCure(DCARowId,"ASS",DCAssChildSub)) q:(ApplyAssement'="")!(DCAssChildSub="")  d
	..s DCAssActiveFlag=$p(^DHCDocCure(DCARowId,"ASS",DCAssChildSub),"^",9)
	..Q:DCAssActiveFlag'="Y"
	..s ApplyAssement=DCARowId_"||"_DCAssChildSub
	.s CureOrdInfo=$p(rtn,$c(1),3)
	.s OrdOtherInfo=""
	.if $p(CureOrdInfo,"^",1)'="" d
	..s OrdOtherInfo=$p(CureOrdInfo,"^",1)_$p(CureOrdInfo,"^",3)
	.s OrdOtherInfo=OrdOtherInfo_" "_$p(CureOrdInfo,"^",7)_" "_$p(CureOrdInfo,"^",11)
	.d OutputRowEMRApply
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowEMRApply 
	set Data=$lb(DCARowId,PatientNo,PatientName,PatientSex,PatientAge,PatientTel,$g(AdmType),$g(AdmDep),ArcimDesc,OrderQty,BillingUOM,OrderReLoc,ApplyStatus,ApplyUser,ApplyDate,ApplyAppedTimes,ApplyNoAppTimes,ApplyFinishTimes,ApplyNoFinishTimes,OrdPrice,OrdBilled,DDCRSServiceGroupDesc,ServiceGroup,CallStatus,ApplyExec,ApplyExecFlag,HisToryTriRes,PatOther,OrdUnitPrice,CureApplyNo,OrdReLocId,OrdOtherInfo,ApplyPlan,ApplyAssement,OrderStatusCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	quit
CheckQuitApply(DCARowId)
	Set QuitFlag=1
	Set ApplyDate=$p(^DHCDocCure(DCARowId),"^",5)
	if ((StartDate'="")&&(ApplyDate<StartDate))!((EndDate'="")&&(ApplyDate>EndDate)){
		Q QuitFlag
	}
	Set ApplyStatus=$p(^DHCDocCure(DCARowId),"^",3)
	if (outCancel="Y")&(ApplyStatus'="C"){
		Q QuitFlag
	}
	if (FinishDis="Y")&(ApplyStatus'="F"){
		Q QuitFlag
	}
	if ((outCancel'="Y")&&(FinishDis'="Y")){
		if (ApplyStatus'="A")&&(ApplyStatus'="D"){
			;Q QuitFlag
		}
	}
	Set OrderId=$p(^DHCDocCure(DCARowId),"^",2)
	if OrderId=""{
		Q QuitFlag
	}
	Set ArcimId=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),1)),"^",2)
	if (queryArcim'="")&&(queryArcim'=ArcimId){
		Q QuitFlag
	}
	Set OrderAddDeptDr=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),7)),"^",2)
	if (queryOrderLoc'="")&&(queryOrderLoc'=OrderAddDeptDr){
		Q QuitFlag
	}
 	Quit 0
}

ClassMethod FindEMRCureApplyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEMRCureApplyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindEMRCureApplyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEMRCureApplyListExecute ]
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

ClassMethod GetCureApplyNo(DCARowId As %String)
{
	N (DCARowId)
	Set CureData=$g(^DHCDocCure(DCARowId))
	s ApplyNo=$p(CureData,"^",18)
	Q ApplyNo
}

Query FindCureItemAppendItem(DCARowId As %String, Episodeid As %String, SessionStr As %String = "") As %Query(ROWSPEC = "CureAppRowId:%String,CureAppItemID:%String,CureAppItemDesc:%String,CureAppItemQty:%String,CureAppItemRecLoc:%String,CureAppItemRecLocID:%String,RecLocStr:%String,Price:%String,TotalPrice:%String,CureAppItemType:%String")
{
}

ClassMethod FindCureItemAppendItemExecute(ByRef qHandle As %Binary, DCARowId As %String, Episodeid As %String, SessionStr As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindCureItemAppendItem","236","")
	s ^tmpnk("FindCureItemAppendItem")=$lb(DCARowId,Episodeid)
	s AIrepid=$I(^CacheTemp)
    s ind=1
    if DCARowId=""{
		s qHandle=$lb(0,AIrepid,0)
		Quit $$$OK    
	}
	s langid=$p(SessionStr,"^",6)
	s:langid="" langid=..%LanguageID()
	s CureData=$g(^DHCDocCure(DCARowId))
	s OrderRowId=$p(CureData,"^",2)
	if OrderRowId=""{
		s qHandle=$lb(0,AIrepid,0)
		Quit $$$OK    
	}
	if Episodeid=""{
		s Episodeid=$p(CureData,"^",1)
	}
	s AdmType=$p($g(^PAADM(Episodeid)),"^",2)
	s SubRowId=0
    f {
	   	Set SubRowId=$o(^OEORDi(0,"SERORD",OrderRowId,+OrderRowId,SubRowId))
	   	Q:SubRowId=""
	   	continue:'$d(^OEORD(+OrderRowId,"I",SubRowId,1))
		Set itemstat=$p($g(^OEORD(+OrderRowId,"I",SubRowId,1)),"^",13)
		if itemstat'="" Set statcode=$p($g(^OEC("OSTAT",itemstat)),"^",1)
		continue:($g(statcode)'="V")&&($g(statcode)'="E")
	   	Set ArcimRowId=$p($g(^OEORD(+OrderRowId,"I",SubRowId,1)),"^",2)
	   	Set AppendItem=##class(web.DHCDocOrderCommon).GetFormateOrderName(ArcimRowId)
 		Set AppendItem=##class(ext.util.String).EvalJSON(AppendItem)
 		Set SubOrderRowId=+OrderRowId_"||"_SubRowId
 		Set AppendRecLocID=$P(^OEORD(+OrderRowId,"I",SubRowId,3),"^",6)
 		Set AppendRecLoc=""
 		Set:AppendRecLocID'="" AppendRecLoc=$p(^CTLOC(AppendRecLocID),"^",2)
 		Set AppendRecLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AppendRecLoc,langid)
 		Set ActiveQtyStr=..GetOrderActiveQty(SubOrderRowId) //if AdmType'="I" 
		Set AppendItemQty=$p(ActiveQtyStr,"^",1)
		if AppendItemQty="" s AppendItemQty=##class(DHCDoc.Interface.Inside.Service).GetOrdDoseQty(SubOrderRowId)
		Set BillingUOM=$p(ActiveQtyStr,"^",2)
	 	Set UnitPrice=..GetPrice(Episodeid,ArcimRowId,AppendRecLocID,"",SubOrderRowId)
	 	Set UnitPrice=$p(UnitPrice,"^",1)
	 	Set UnitPrice=$j($g(UnitPrice),11,2)
	 	Set UnitPrice=$tr(UnitPrice," ","")
	 	Set TotalPrice=$j($g(UnitPrice)*AppendItemQty,11,2)
	 	Set TotalPrice=$tr(TotalPrice," ","")
	 	Do OutputRowAppendItem
    }
	Set qHandle=$lb(0,AIrepid,0)
	Quit $$$OK
OutputRowAppendItem
	set Data=$lb(OrderRowId,$g(ArcimRowId),$g(AppendItem),AppendItemQty,AppendRecLoc,AppendRecLocID,"",UnitPrice,TotalPrice,"")
 	Set ^CacheTemp(AIrepid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCureItemAppendItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCureItemAppendItemExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureItemAppendItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureItemAppendItemExecute ]
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

ClassMethod GetCurePlanAndAss(Type As %String, DCARowId As %String)
{
	N (Type,DCARowId)
	s ret=""
	if Type="Plan"{
		s CureData=$g(^DHCDocCure(DCARowId))
		s ret=$p(CureData,"^",11)
	}else{
		s DCAAssChild=$o(^DHCDocCure(DCARowId,"ASS",0))
		if DCAAssChild'=""{
			s RowID=DCARowId_"||"_DCAAssChild
			s AssInfo=##class(DHCDoc.DHCDocCure.Assessment).GetCureAssessment(RowID)
			if AssInfo'=""{
				s ret=$p(AssInfo,"^",3)	
			}
		}
	}
	s ret=##class(ext.util.String).EvalJSON(ret)
	Q ret
}

Query FindCureItemPOA(DCARowId As %String) As %Query(ROWSPEC = "CAPPartDR:%String,CAPPartGrpDR:%String,CAPOrdExecDR:%String,CAPPart:%String")
{
}

ClassMethod FindCureItemPOAExecute(ByRef qHandle As %Binary, DCARowId As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Apply","FindCureItemPOA","753")
    if DCARowId=""{
		Quit $$$OK    
	}
	s langid=..%LanguageID()
	s ID=0
	for{
		s ID=$o(^User.DHCDocCureAppPartI("CureAppDRIndex",DCARowId,ID))
		Q:ID=""
		s CAPPartDR=$Lg(^User.DHCDocCureAppPartD(ID),3)
		s CAPPartGrpDR=$Lg(^User.DHCDocCureAppPartD(ID),4)
		s CAPOrdExecDR=$Lg(^User.DHCDocCureAppPartD(ID),5)
		s CAPPart=$lg(^User.DHCDocCurePartSetD(CAPPartDR),3)
		s CAPPart=##class(User.DHCDocCurePartSet).GetTranByDesc("CPSDesc",CAPPart,langid)
		d OutputRowPOA
	}
	Quit $$$OK
OutputRowPOA
 	s qHandle($I(ind))=$lb(CAPPartDR,CAPPartGrpDR,CAPOrdExecDR,CAPPart)
	Quit
}

ClassMethod FindCureItemPOAFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureItemPOAExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// 通过申请单号获取申请信息
/// w ##class(DHCDoc.DHCDocCure.Apply).GetApplyInfoByAppNo("202210240003")
ClassMethod GetApplyInfoByAppNo(AppNo)
{
	s $zt="GetApplyInfoByAppNo"
	s DCARowId=$o(^DHCDocCure(0,"AppNo",AppNo,0))
	Q:DCARowId="" "{}"
	
	s DCAInfo=$g(^DHCDocCure(DCARowId))
	s AdmID=$p(DCAInfo,"^",1)
	s PatID=$p(^PAADM(AdmID),"^",1)
	s MRAdmID=$p(^PAADM(AdmID),"^",61)
	
	s Obj={}
    s Obj."PatientID"=PatID
	s Obj."EpisodeID"=AdmID
	s Obj."mradm"=MRAdmID
	s Obj."PageShowFromWay"="ApplyEntry"
	Q Obj.%ToJSON()

GetApplyInfoByAppNo
	Q "{}"
}

}
