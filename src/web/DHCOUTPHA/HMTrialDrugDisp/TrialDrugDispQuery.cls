/// Description:门诊草药房审方发药查询相关
/// Creator:    hulihua
/// CreateDate: 2018-08-14
/// Table:      DHC_PHARWIN-计费药房中间表
Class web.DHCOUTPHA.HMTrialDrugDisp.TrialDrugDispQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", ProcedureBlock ]
{

/// descirpiton:获取门诊草药房审方列表
/// creator: 	pushuangcai
/// createdate:	2018/08/03
/// w ##class(web.DHCOUTPHA.HMTrialDrugDisp.TrialDrugDispQuery).jsQueryPrecsCheckDispList("1","50","16/12/2018^18/12/2018^310^0000000779^^13")
ClassMethod jsQueryPrecsCheckDispList(page, rows, params)
{
 	//s ^hlh($h)=$lb(page, rows, params)
 	Quit:params="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
 	Set EnPage=page*rows  //结束行
	Set StPage=((page-1)*rows)+1 //开始行
 	Set StDate=$P(params,"^",1)
 	Set Endate=$P(params,"^",2)
 	Set Phalocdr=$P(params,"^",3)
 	Set PatNoInput=$P(params,"^",4)
 	Set OnlyDisp=$P(params,"^",5) 		;仅已发已审标志
 	Set Phl=$P(params,"^",6)
 	Quit:Phl="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
 	Set StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	Set EnDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(Endate)
 	Set Pid=##class(web.DHCOUTPHA.Common.CommonUtil).NewPid($this)
 	Set H=0
 	Do ##class(web.DHCOUTPHA.Common.CommonUtil).ClearTmp($this,"jsQueryPrecsCheckDispList",Pid)
 	Set $ZT="ErrorjsQueryDispList"
 	Kill CheckPrescNoArr
 	For Date=StDate:1:EnDate {
	 	If (PatNoInput=""){
		 	//先收费后发药 	
			Set phdrow=""
			For  Set phdrow=$o(^DHCPHARWi(Date,Phl,phdrow)) Quit:phdrow=""  Do
			.Do DispBeforePay
			//先发药后收费
			Set Ord=0
			For  Set Ord=$o(^OEORDi(0,"LocStDtArr",Phalocdr,0,Date,Ord)) Quit:Ord=""  Do
			.Set Chl=0
			.For  Set Chl=$o(^OEORDi(0,"LocStDtArr",Phalocdr,0,Date,Ord,Chl)) Quit:Chl=""  Do
			..Quit:'$d(^OEORD(Ord,"I",Chl,1))
			..Do DispAfterPay
		}Else{
			Set phdpapmidr=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNoInput),""),-1)
			Quit:phdpapmidr=""
			//先收费后发药 
			Set phdrow=0
			For  Set phdrow=$o(^DHCPHARi("PAPMI",phdpapmidr,Date,Phl,phdrow)) Quit:phdrow=""  Do
			.Do DispBeforePay
			//先发药后收费
			Set AdmType=""
			For  Set AdmType=$o(^PAPERdr(phdpapmidr,"ADM",AdmType)) Quit:AdmType=""  Do 
			.Quit:AdmType="I" 						;过滤住院
			.Set Adm=""
			.For  Set Adm=$o(^PAPERdr(phdpapmidr,"ADM",AdmType,Adm),-1) Quit:Adm=""  Do 
			..Set AdmDate=$p(^PAADM(Adm),"^",6) 	;就诊日期
			..Quit:AdmDate>EnDate
			..Quit:AdmDate<StDate
			..Set Ord=$o(^OEORD(0,"Adm",Adm,"")) 
			..Set Chl=0
			..For  Set Chl=$o(^OEORDi(0,"LocStDtArr",Phalocdr,0,Date,Ord,Chl)) Quit:Chl=""  Do
			...Quit:'$d(^OEORD(Ord,"I",Chl,1))
			...Do DispAfterPay
			...
			..
			.
		} 
    }
    // 输出Json数据
	Set countrecords=H
    Quit:countrecords="0" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson()
    If EnPage>countrecords Set EnPage=countrecords
    Set Count=0
	Set ColNameStr1="TPatLoc^TPrescNo^TAdm^TOeori^TPayDispFlag"
	Set ColNameStr2="TPrescType^TBillType^TEmergFlag^TDspStatus^TPmiNo"
	Set ColNameStr3="TPatName^TMR^TPatSex^TPatAge^TCookType"
	Set ColNameStr4="TPrt^THandMadeFlag^TCookCost^TDuration^TPapmi"
	Set ColNameStr5="TPrescConfigId^Tphd^TDocNote^TRefResult^TMBDiagnos"
	Set ColNameStr6="TFyFlag"
	Set ColNameStr=ColNameStr1_"^"_ColNameStr2_"^"_ColNameStr3_"^"_ColNameStr4_"^"_ColNameStr5_"^"_ColNameStr6
 	Set H=""
	For  {
		Set H=$O(^TMP("DHCOUTPHA",$this,"jsQueryPrecsCheckDispList",Pid,H)) Quit:H="" 
		Set OutPutData=^TMP("DHCOUTPHA",$this,"jsQueryPrecsCheckDispList",Pid,H)	
		Set Count=Count+1
		Quit:Count<StPage
    	Quit:Count>EnPage
    	If Count=StPage {
	    	Write ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartStringJqGrid(countrecords,rows)
			Write ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(ColNameStr,OutPutData)
	    }Else{
			Write ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(ColNameStr,OutPutData)
		}
		If Count=EnPage Write ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign()
	}
	Do ##class(web.DHCOUTPHA.Common.CommonUtil).ClearTmp($this,"jsQueryPrecsCheckDispList",Pid)
	Kill CheckPrescNoArr
	Quit ""
DispBeforePay
	Set nouse=$p(^DHCPHARW(phdrow),"^",7)
	Quit:nouse="1"
	Set retflag=$p(^DHCPHARW(phdrow),"^",13)
	Quit:retflag'="1"
	Set prescNo=$p(^DHCPHARW(phdrow),"^",16)
	Quit:prescNo=""
	Quit:$d(CheckPrescNoArr("PrescNo",prescNo))
	Set Ord=$o(^OEORD(0,"PrescNo",prescNo,""))
	Quit:Ord=""
	Set Chl=$o(^OEORD(0,"PrescNo",prescNo,Ord,"")) 	
	Set Oeori=Ord_"||"_Chl
	Set PayDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(Oeori)
	Quit:PayDispFlag="Y"
	if PayDispFlag="Y" d
	.Set PayDispFlag="是"
	else  do
	.Set PayDispFlag="否"
	Set HandMade=$p(^DHCPHARW(phdrow),"^",14)
	Set Prt=+$p(^DHCPHARW(phdrow),"^",1)
	Set Reclocdr=$P(^OEORD(Ord,"I",Chl,3),"^",6)
	Quit:Reclocdr'=Phalocdr
	Quit:'$D(^DHCOEDISQTY(0,"OEORI",Oeori))
	Set DspId=$O(^DHCOEDISQTY(0,"OEORI",Oeori,"")) 
	Quit:DspId=""
	Do GetOutPutData
	Quit ""			
DispAfterPay
	Set prescNo=$p(^OEORD(Ord,"I",Chl,1),"^",14)
	Quit:prescNo=""
	Set Oeori=Ord_"||"_Chl
	Set PayDispFlag=##class(PHA.OP.COM.Method).GetDispBeforePay(Oeori)
	Quit:PayDispFlag'="Y"
	if PayDispFlag="Y" d
	.Set PayDispFlag="是"
	else  do
	.Set PayDispFlag="否"
	Quit:$d(CheckPrescNoArr("PrescNo",prescNo))
	Set BillFlag=$p(^OEORD(Ord,"I",Chl,3),"^",5)
	Set OeoriStatCode=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(Oeori),"^",1)
	Quit:(OnlyDisp'="Y")&&(BillFlag'="P")&&((OeoriStatCode'="V")&&(OeoriStatCode'="E"))
	Set DspId=$o(^DHCOEDISQTY(0,"OEORI",Oeori,""))
	Quit:DspId=""
	Quit:(OnlyDisp'="Y")&&($p(^DHCOEDISQTY(DspId),"^",7)="C")					
	Set HandMade=0
	Set Prt=""
	Do GetOutPutData
	Quit ""	
GetOutPutData
	Set NeedAuditFlag=##class(web.DHCOutPhCommon).GetNeedOrdAuditFlag(Phl)			;是否处方审核
	Set AuditFlag=##class(web.DHCOutPhCommon).GetOrdAuditResultByPresc(prescNo)
	Quit:(NeedAuditFlag="1")&&(AuditFlag'="Y") 										;处理需要发药前审核
	Set Adm=$p(^OEORD(Ord),"^",1)
	Set Papmi=$p(^PAADM(Adm),"^",1)
	Set Quer=$o(^PAQUE1(0,"PrescNo",prescNo,""))
	Quit:'$d(^PAQUE1(Quer,"DHC"))
	Set phd=##class(web.DHCOutPhDisp).GetPhdByPresc(prescNo,"",Phl)
	Quit:(OnlyDisp="Y")&&(phd="")
	Quit:(OnlyDisp'="Y")&&(phd'="")
	Set DspStatus=##class(web.DHCOutPhCommon).GetPhdStatus(phd,prescNo)
	Set DocNote="",PhRefResult=""
	Set RefResult=##class(web.DHCOutPhCommon).GetOrdRefResultByPresc(prescNo)
	If RefResult="N" Do
	.Set PhRefResult=##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetRefReasonByPresc(prescNo,"OR")
	If RefResult="S" Do
	.Set DocNote=##class(web.DHCOutPhCommon).GetOrdAppealReasonByPresc(prescNo) //申诉理由
	.Set PhRefResult=##class(web.DHCINPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetRefReasonByPresc(prescNo,"OR")
	Set patInfo=##class(web.DHCPHACOM.ComPubClass.OrderAndPatInfo).GetPatInfo(Adm)
	Set PatNo=$P(patInfo,"^",1)
	Quit:(PatNoInput'="")&&(PatNoInput'=PatNo)
	Set PatName=$P(patInfo,"^",3)
	Set Diagnodesc=$P(patInfo,"^",9)
	Set Sex=$P(patInfo,"^",4)
	Set Age=$P(patInfo,"^",5)
	Set prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	Set JYType=$p(prescStr,"^",7)
	Set PrescForm=$p(prescStr,"^",8)
	Set Duration=$p(prescStr,"^",14)
	Set EmergFlag=$p(prescStr,"^",18)
	if EmergFlag="Y" d
	.Set EmergFlag="是"
	else  do
	.Set EmergFlag="否"
	Set PrescConfigId=$p(prescStr,"^",22)
	Set preOrdStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPreOrdInfo(prescNo)
	Set DeplocDesc=$p(preOrdStr,"^",1)
	If DeplocDesc["-" Set DeplocDesc=$p(DeplocDesc,"-",2)
	Set BillType=##class(web.DHCOutPhCommon).GetPrescType(prescNo)
	Set CookCost=##class(web.DHCOutPhCommon).GetDecoctFee(prescNo,"1")
	Set:CookCost="" CookCost=##class(web.DHCOutPhCommon).GetDecoctFee(prescNo,"2")
	Set MBDiagnos=##class(web.DHCINPHA.MTCommon.PublicCallMethod).GetPrescMBDiagnos(prescNo)	//psc 2018-09-27
	Set chkerr=##class(web.DHCOutPhDisp).CheckBeforUpdate(prescNo,Phl)
	Set FinFlag=$s(chkerr=1:"OK",1:"")
	Set CheckPrescNoArr("PrescNo",prescNo)=""
	Set Data1=DeplocDesc_"^"_prescNo_"^"_Adm_"^"_Oeori_"^"_PayDispFlag
	Set Data2=$G(PrescForm)_"^"_BillType_"^"_EmergFlag_"^"_DspStatus_"^"_PatNo
	Set Data3=PatName_"^"_Diagnodesc_"^"_Sex_"^"_Age_"^"_JYType
	Set Data4=Prt_"^"_HandMade_"^"_CookCost_"^"_Duration_"^"_Papmi
	Set Data5=PrescConfigId_"^"_phd_"^"_DocNote_"^"_PhRefResult_"^"_MBDiagnos
	Set Data6=FinFlag
	Set H=H+1
	Set ^TMP("DHCOUTPHA",$this,"jsQueryPrecsCheckDispList",Pid,H)=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6
	Quit ""
ErrorjsQueryDispList
	Do ##class(web.DHCOUTPHA.Common.CommonUtil).ClearTmp($this,"jsQueryPrecsCheckDispList",Pid)
	Set Error=$$Error^DHCSTERROR()
	Quit Error
}

/// descirpiton:获取门诊草药房审方列表
/// creator: 	pushuangcai
/// createdate:	2018/08/015
/// w ##class(web.DHCOUTPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetPrescDetailList("O190111000076")
ClassMethod GetPrescDetailList(prescno As %String)
{
	q:prescno="" ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetNoJson() 
	s ColNameStr="TOeori^TInciDesc^TBoilType^TDose"
	s jsonStr=""	 
	s mainTitle="TCoookType^TPrescConfigId^TPrescConfig^TOrderQty^TOrderQtyDesc"
	s mainTitle=mainTitle_"^"_"TFreqDr^TFreqDesc^TInsdr^TInstruc^TEfficacy^TPrescTypedr"
	s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescno)
	s CoookType=$P(prescStr,"^",7)
	s PrescConfig=$P(prescStr,"^",10)
	s OrderQtyDesc=$P(prescStr,"^",11)
	s FreqDesc=$P(prescStr,"^",9)
	s Instruc=$P(prescStr,"^",1)
	s Quefac=$p(prescStr,"^",2) 
	s Efficacy=$p(prescStr,"^",12)
	s OrderQtyRowid=$p(prescStr,"^",19)
	s insdr=$p(prescStr,"^",20)
	s FreqDr=$p(prescStr,"^",21)
	s PrescConfigRowID=$p(prescStr,"^",22)
	s PrescTypedr=$p(prescStr,"^",23)
	s mainStr=CoookType_"^"_PrescConfigRowID_"^"_PrescConfig_"^"_OrderQtyRowid_"^"_OrderQtyDesc
	s mainStr=mainStr_"^"_FreqDr_"^"_FreqDesc_"^"_insdr_"^"_Instruc_"^"_Efficacy
	s mainStr=mainStr_"^"_PrescTypedr
	s jsonStr=##class(web.DHCINPHA.MTCommon.JQueryCommon).getUserDefJsonData(mainTitle,mainStr)
	s ord=""
	f  s ord=$o(^OEORD(0,"PrescNo",prescno,ord))  q:ord=""  d
	.s itm="",Count=0
	.f  s itm=$o(^OEORD(0,"PrescNo",prescno,ord,itm))  q:itm=""  d
	..s oeori=ord_"||"_itm
	..s OEPrescNo=$p(^OEORD(ord,"I",itm,1),"^",14)
	..q:prescno'=OEPrescNo
	..s dsp=$o(^DHCOEDISQTY(0,"OEORI",oeori,""),-1)
	..q:dsp="" 
	..s Count=Count+1
	..s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)
    ..s inci=$o(^INCI(0,"ARCIM_DR",$p(arcimid,"||",1),"")) 
    ..s arcimdesc=$p($g(^ARCIM(+arcimid,1,1)),"^",2)
    ..s ordremark=$p($g(^OEORD(ord,"I",itm,2)),"^",8)
    ..s unitDR=$p($g(^OEORD(ord,"I",itm,2)),"^",3)
    ..s unitDesc=$p($g(^CT("UOM",unitDR)),"^",2)
    ..s DoseQty=$p($g(^OEORD(ord,"I",itm,1)),"^",12) 				 //数量
	..s DoseQtyCM=DoseQty/Quefac
	..s:(DoseQtyCM<1)&&(DoseQtyCM>0) DoseQtyCM="0"_DoseQtyCM
    ..s Dose=DoseQtyCM_unitDesc
    ..s OutputData=oeori_"^"_arcimdesc_"^"_ordremark_"^"_Dose
    ..i Count=1 d
    ...s jsonStr=jsonStr_",""TDetail"":"_##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonStartRow()
    ...s jsonStr=jsonStr_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(ColNameStr,OutputData)
	..e  d
	...s jsonStr=jsonStr_","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(ColNameStr,OutputData)
	q:Count=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(0)
	s jsonStr=jsonStr_##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonEndRow()_"}" 
	q jsonStr
}

/// Description:检查是否允许插入煎药费
/// Creator:	hulihua
/// CreateDate:	2018-12-27
/// Table:      OE_OrdItem
/// Input:		处方号
/// Output:	    
/// Return：	0-允许，非0-不允许    
/// Others:     
/// Debug:		w ##class(web.DHCOUTPHA.HMTrialDrugDisp.TrialDrugDispQuery).CheckIfInsertCookFee("173","O181227000005","4638","310")
ClassMethod CheckIfInsertCookFee(PrescNo As %String, Phl As %String) As %String
{
	q:PrescNo="" "-1^未选中处方！"
	s Ord=$o(^OEORD(0,"PrescNo",PrescNo,""),-1)
	q:Ord="" "-2^所开处方主表ID为空！"
	s Itm=$o(^OEORD(0,"PrescNo",PrescNo,Ord,""),-1) 
	q:Itm="" "-3^所开处方没有子表ID！"
	s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(PrescNo)
	s CookType=$p(prescStr,"^",7)
	q:CookType["代煎" "-4^该处方为代煎处方，无需再次申请！"
	s preFeeArcimStr=##class(web.DHCOutPhCommon).GetPreFeeArcimStr(PrescNo)
	q:preFeeArcimStr="" "-5^该处方对应的处方剂型没有配置煎药费!"
	s CookCost=##class(web.DHCOutPhCommon).GetDecoctFee(PrescNo)
	q:CookCost'="" "-6^该处方煎药费已存在，无需重复申请！"
	s phd=##class(web.DHCOutPhDisp).GetPhdByPresc(PrescNo,"",Phl)
	s phdretid=$s(phd'="":$o(^DHCPHRETi(Phl,phd,""),-1),1:"")
	q:phdretid'="" "-7^该处方已存在退药信息，无需申请！!"
	q 0
}

/// Description:代煎转自煎插入煎药费
/// Creator:	hulihua
/// CreateDate:	2018-09-06
/// Table:      OE_OrdItem
/// Input:		就诊ID、处方号、插入人ID、药房ID
/// Output:	    
/// Return：	0-成功，非0-失败    
/// Others:     只考虑自煎处方的煎药费，全部取自于医生站的配置
/// Debug:		w ##class(web.DHCOUTPHA.HMTrialDrugDisp.TrialDrugDispQuery).SaveCookFee("173","O181227000005","4638","310")
ClassMethod SaveCookFee(Params As %String)
{
	//s ^hlh($h)=$lb(AdmDr,PrescNo,UserId,LocId)
	s AdmDr=$p(Params,"^",1)
	s prescNo=$p(Params,"^",2)
	q:(AdmDr="")||(prescNo="") "-1^未选中处方！"
	s UserId=$p(Params,"^",4)
	s LocId=$p(Params,"^",5)
	q:(UserId="")||(LocId="") "-2^请重新刷新界面后再试！"
	s Ord=$o(^OEORD(0,"PrescNo",prescNo,""),-1)
	q:Ord="" "-3^所开处方主表ID为空！"
	s Itm=$o(^OEORD(0,"PrescNo",prescNo,Ord,""),-1) 
	q:Itm="" "-4^所开处方没有子表ID！"
	i $$LK()<0  q "-5加锁失败！" 
	s prescStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	s Factor=$p(prescStr,"^",2)
	s PrescForm=$p(prescStr,"^",8)
	s Moeori=##class(web.DHCOutPhCommon).GetMainOeori(Ord_"||"_Itm)
	s OrdBillTypeDr=$p(^OEORD(Ord,"I",Itm,11),"^",18)
	s preFeeArcimStr=##class(web.DHCOutPhCommon).GetPreFeeArcimStr(prescNo)
	q:preFeeArcimStr="" "-6^该处方对应的处方剂型没有配置煎药费!"
	s preFeeArim=$p(preFeeArcimStr,",",1)
	s preFeeQty=Factor
	s DocLocId=$$GetRecloc^DHCDocOrderCommonNew(AdmDr,preFeeArim)
	s:DocLocId="" DocLocId=LocId
	s materAddFeeStr=$p(Params,"^",3)
	s materAddFeeArcim=$p(materAddFeeStr,",",1)
	s materAddFeeQty=$p(materAddFeeStr,",",3)
	s aricimStr=preFeeArim_"^"_preFeeQty_"&&"_materAddFeeArcim_"^"_materAddFeeQty
	s aricimLen=$l(aricimStr,"&&")
	s retCode=0
	f j=1:1:aricimLen q:retCode'=0  d
	.s cookFeeStr=$p(aricimStr,"&&",j)
	.s arcimDr=$p(cookFeeStr,"^",1)
	.q:arcimDr=""
	.s arcimQty=+$p(cookFeeStr,"^",2)
	.q:arcimQty=0
	.s OrdItemStr=arcimDr_"^"_arcimQty_"^"_DocLocId_"^^^"_OrdBillTypeDr_"^^^^^"
	.s DoctorID=##class(web.SSUser).GetDefaultCareProvider(UserId)
	.s CookStr=##class(web.DHCOPCashier).CashierInsertOrdItem(AdmDr,OrdItemStr,UserId,LocId,DoctorID,"")
	.s Ret=$p(CookStr,"^$")
	.s:(Ret=0)||(Ret=100) retCode=-1
	.q:retCode'=0
	.s CookOeori=$p(CookStr,"*",2)
	.s Ret=##class(web.DHCOUTPHA.HMTrialDrugDisp.SqlDbTrialDrugDisp).UpdateCookOeori(CookOeori,Moeori)
	.s:Ret'=0 retCode=-2
	i retCode'=0 d UK
	q:retCode=-1 "-7^插入煎药费失败!"
	q:retCode=-2 Ret
	d UK
	q 0
LK()
	l +^DHCOUTPHACOOKFEE(prescNo):5  e  q -1
	q 0
UK
	l -^DHCOUTPHACOOKFEE(prescNo)  
	q
}

/// Description:根据处方号获取草药处方附加材料费的医嘱项ID串
/// Creator:	hulihua
/// CreateDate:	2018-12-27
/// Table:      PA_Que1
/// Input:		prescno-处方号
/// Output:	    
/// Return：	医嘱项ID^医嘱项名称  
/// Others:     
/// Debug:		w ##class(web.DHCOUTPHA.HMTrialDrugDisp.TrialDrugDispQuery).GetPreAppendStr("O181227000005")
ClassMethod GetPreAppendStr(PrescNo As %String) As %String
{
	Q:PrescNo="" ""
	S queId=$o(^PAQUE1(0,"PrescNo",PrescNo,""),-1)
	Q:queId="" ""
	Q:'$d(^PAQUE1(queId,"DHC")) ""
	S prescTypeCode=$P(^PAQUE1(queId,"DHC"),"^",26)
	Q:prescTypeCode="" ""
	//附加费医嘱项ID
	S presAppendItem=$G(^DHCDocConfig(prescTypeCode,"CNMedAppendItem"))
	Q:presAppendItem="" ""
	s presAppendDesc=$p($g(^ARCIM(+presAppendItem,$p(presAppendItem,"||",2),1)),"^",2)
	S presAppendStr=presAppendItem_","_presAppendDesc
	Q presAppendStr
}

}
