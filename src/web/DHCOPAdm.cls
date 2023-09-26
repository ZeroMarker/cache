Include webimport

IncludeGenerator webimport

Class web.DHCOPAdm Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 删除PAADM的垃圾数据
ClassMethod DelADMByRowID(PAADMRowID As %String) As %String
{
	n (PAADMRowID)
	;w ##class(web.DHCOPAdm).DelADMByRowID(600228)
	;需要判断的OE_Order 表是否有数据
	;没有数据就要删除PAADM
	
	q:(PAADMRowID="") 0
	
	s myOEORDR=$o(^OEORD(0,"Adm",PAADMRowID,0))
	;b	;;
	
	;有医嘱的先退出
	q:(myOEORDR'="") 0
	
	;Del
	&sql(Delete from SQLUser.PA_Adm where PAADM_RowID=:PAADMRowID)
	
	;b	;;tro
	
	q 0
}

ClassMethod GetEncrypt(Method As %String)
{
	s encmeth=##Class(websys.Page).Encrypt($lb(Method))
	Quit encmeth
}

ClassMethod GetHoliFlag() As %String
{
	
	//lgl+ 节假日费开关
	
	s flag=0,flag2=0
 s today=$h
 s flag=$g(^DHCHFONOFF("j"))    //临时节假日
 if (($zd(today,10)=0)!($zd(today,10)=6)) d   //周末;不管加收标志开否,只要周末都加收
 .s flag=1
	s flag2=$g(^DHCHFONOFF("j2"))
	if (flag2=1) d    //强制关闭默认
	.s flag=0
	q flag
}

ClassMethod GetOldDoc(itmjs As %Library.String = "", itmjsex As %Library.String = "", RegNo As %Library.String = "", nday As %Library.String = "")
{
	s desc=0
	 	//Set repid=$I(^CacheTemp)
 s n=nday
 i n="" d  s n=0
 s cdate=..%SysDate()
 s edate=..%SysDate()-n
 ;s ^lgltest(7890)=RegNo_"^"_n
 s InvoiceId=""
 s Admdepcode="",admdep="",Admdoccode="",admdoc="",admdate=""
 s Arcdr="",Arcp="",ph=""
	If $g(ind)="" Set ind=1
	Set Adm=0
	If $g(RegNo)'="" do
	.Set PAPMI=$o(^PAPERi("PAPMI_PatNo",$ZCVT(RegNo,"U"),""))
	.If $g(PAPMI)="" Quit
	.f  Set Adm=$o(^PAPERdr(PAPMI,"ADM","O",Adm)) quit:Adm=""  d
	..s VisitStatus=$p($g(^PAADM(Adm)),"^",20)
	..i VisitStatus'="A" d  q 
	..s admdate=$p($g(^PAADM(Adm)),"^",6)
	..f k=edate:1:cdate d
	...i admdate'=k d  q 
	...s kdate=$zd(admdate,1)
 ...s Admdepcode=$p($g(^PAADM(Adm)),"^",4)
 ...s admdep=$p($g(^CTLOC(Admdepcode)),"^",2)
 ...s Admdoccode=$p($g(^PAADM(Adm)),"^",9) 
 ...i Admdoccode="" s admdoc="aa" 
 ...e  s admdoc=$p($g(^CTPCP(Admdoccode,1)),"^",2)
 ...s AdmTime=..%ZT($p($g(^PAADM(Adm)),"^",7),3)

 ...s Cuserid=$p($g(^PAADM(Adm)),"^",43)
 ...i Cuserid="" s Username="bb" 
 ...s Admi=Adm
 ...e  s Username=$p($g(^SSU("SSUSR",Cuserid)),"^",2)
 ...S I=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
 ...if I'="" d
 ....s Arcdr=$List(^User.DHCRegistrationFeeD(I),3)
 ....s Arcp=$List(^User.DHCRegistrationFeeD(I),4)
 ....s ph=$List(^User.DHCRegistrationFeeD(I),8)
 ....s InvoiceId=$List(^User.DHCRegistrationFeeD(I),11)

 ...if (desc=0) d
 ....s desc=Admdepcode_"^"_admdep_"^"_Admdoccode_"^"_admdoc_"^"_AdmTime_"^"_Username_"^"_Adm_"^"_Arcp_"^"_Arcdr_"^"_RegNo_"^"_ph_"^"_InvoiceId_"^"_kdate
 ...e  d
 ....s desc=desc_"!"_Admdepcode_"^"_admdep_"^"_Admdoccode_"^"_admdoc_"^"_AdmTime_"^"_Username_"^"_Adm_"^"_Arcp_"^"_Arcdr_"^"_RegNo_"^"_ph_"^"_InvoiceId_"^"_kdate
 ....//s ^lgltest(7654)=desc
	s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 &javascript<#(retval)#>
	
	q desc
}

ClassMethod GetPatDetailBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 ;n id,code,desc
 ;
 Set (id,code,desc)=""
 ;
 Set PatDr=$o(^PAPERi("PAPMI_PatNo",$ZCVT(val,"U"),""))
 If PatDr="" {
	Set SQLCODE=1
	Set desc=val
	Quit 0
 }  Else {
	Set Name=$p(^PAPER(PatDr,"ALL"),"^",1)
 set RIDCardNo=$p($g(^PAPER(PatDr,"ALL")),"^",9)
	Set Age=+$p(^PAPER(PatDr,"ALL"),"^",6)
	Set Age=$p(((+$H-Age)/365)+0.5,".")
	Set Sex=$p(^CT("SEX",$p(^PAPER(PatDr,"ALL"),"^",7)),"^",2)
	Set OPMRN=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatDr,"O",$g(%session.Data("LOGON.HOSPID")))
	Set IPMRN=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(PatDr,"I",$g(%session.Data("LOGON.HOSPID")))
	set RAddress=$p(^PAPER(PatDr,"PER",4),"^",18) 
	Set PatCat=""
	Set PatCatDr=$p(^PAPER(PatDr,"PER",1),"^",10)
	If PatCatDr'="" Set PatCat=$p(^CT("SS",PatCatDr),"^",1)_"."_$p(^CT("SS",PatCatDr),"^",2)
	Set desc=Name_"^"_Age_"^"_Sex_"^"_OPMRN_"^"_IPMRN_"^"_PatCat_"^"_PatDr_"^"_RIDCardNo_"^"_RAddress
	Set SQLCODE=0
 }
 ;
 i SQLCODE s desc=val q 0
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod OPDeptListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPDeptListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod OPDeptListExecute(ByRef qHandle As %Binary, UserId As %String) As %Status
{
 //
 Set repid=$I(^CacheTemp)
 //
	If $g(ind)="" Set ind=1
	Set RowId=0
	
	s UserId=$ZCVT(UserId,"U")

	//If $g(UserId)
	s UserId=$o(^SSU("SSUSR",0,"SSUSR_Initials",UserId,0))
	//s ^DHCApp=UserId

	//}
	//测试用245用户
	//s UserId=" 2"
	s UserId=" "_UserId

	s UserRowId=0
	s RowIdOld=""
	If $g(UserId)="" do
	.f  Set RowId=$o(^CTLOC(RowId)) quit:RowId=""  d
 ..s CTCode=$p($g(^CTLOC(RowId)),"^",1)
 ..s CTCode=$ZCVT(CTCode,"L")
 ..s CTDesc=$p($g(^CTLOC(RowId)),"^",2)
 ..s CTRowId=RowId
 ..s CTType=$p($g(^CTLOC(RowId)),"^",13)
 ..Do OutputRow1
 Else  do
	.f  Set UserRowId=$o(^User.DHCUserGroupI("UserNamedr",UserId,UserRowId)) quit:UserRowId=""  d
 ..s RowId=$list(^User.DHCUserGroupD(UserRowId),4)
 ..if (RowIdOld '= RowId) do
 ...s CTCode=$p($g(^CTLOC(RowId)),"^",1)
 ...;ctcode come from  ^User.DHCRegKind
 ...s RegKindDocDr=$o(^User.DHCRegKindI("RegDeptDocIndex"," "_RowId,0))
 ...s RegKindRowid=$o(^User.DHCRegKindI("RegDeptDocIndex"," "_RowId,RegKindDocDr,0)) 
 ...s CTCode=$LIST(^User.DHCRegKindD(RegKindRowid),5)
 ...s CTCode=$ZCVT(CTCode,"U")
 ...s CTDesc=$p($g(^CTLOC(RowId)),"^",2)
 ...s CTRowId=RowId
 ...s CTType=$p($g(^CTLOC(RowId)),"^",13)
 ...s RowIdOld=RowId
 ...Do OutputRow1	

 Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow1
	set Data=$lb(CTCode,CTDesc)
	//set ^DHCApp(ind)=CTCode_"^"_CTDesc
 Set ^CacheTemp(repid,CTDesc)=Data
 Set ind=ind+1
	quit
ResetVariables1
	///set (repid)=0
	set (CTRowId,CTCode,CTDesc,CTType)=""
	quit
}

ClassMethod OPDeptListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDeptListExecute ]
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

Query OPDeptList(UserId As %String) As %Query(ROWSPEC = "CTCode:%String,CTDesc:%String")
{
}

Query UFinddoc(depid) As %SQLQuery(CONTAINID = 1, ROWSPEC = "name:%String,id:%Integer")
{
SELECT RES_CTPCP_DR->CTPCP_Desc,RES_CTPCP_DR  FROM RB_RESOURCE
 WHERE (RES_CTLOC_DR = :depid and res_schedulerequired='Y')
}

/// CreatDate?    2010.01.30
/// Description:? 取医保表指针
/// Table?     
/// Input?        RegFeeRowId
/// Return?       INADMRowid
/// Others? 
ClassMethod GetINADMRowid(RegFeeRowId As %String)
{
	n (RegFeeRowId)
	q:RegFeeRowId="" ""
	s INADMRowid=""
	q:$d(^User.DHCRegistrationFeeD(RegFeeRowId))=0 ""
	s INADMRowid=$lg(^User.DHCRegistrationFeeD(RegFeeRowId),24)	
	q INADMRowid
}

/// CreatDate?    2017.08.30
/// Description:? 根据就诊RowId得到医保结算所需要的参数，使用场景：挂号医保补登记
/// Table?     
/// Input         AdmID PA_Adm表ID
/// output?       myrtn	医保结算所需参数       
/// Others? 
ClassMethod GetInsuBillParaByAdmID(AdmID As %String) As %String
{
	;w ##class(web.DHCOPAdm).GetInsuBillParaByAdmID(514)
	n (AdmID)
	Q:AdmID="" "传入参数不能为空"
	s LocDr=$P(^PAADM(AdmID),"^",4)
	s DocDr=$P(^PAADM(AdmID),"^",9)
	s PatId=$P(^PAADM(AdmID),"^",1)
	s ASRowId=""
	s AdmReason=$P(^PAADM(AdmID,1),"^",7)
	s UserId=$P(^PAADM(AdmID),"^",43)
	s FeeStr="1||1||||||||"
	s RegType=""
	s InsuJoinType=""
	s FreeRegFeeFlag=""
	s InsuReadCardInfo=""
	s RetInsuGSInfo=""
	///判断是否排班,区分DocDr是不是正确的挂号医生，而不是更新后的医生
	s RowId=""
	s RowId=$O(^RB("RES",0,"CTPCP",DocDr,LocDr,RowId))
	s FeeRowId=$O(^regfee("0",AdmID,""),-1)   ;老版本  Fx,YY
	if FeeRowId="" s FeeRowId=$O(^User.DHCRegistrationFeeI("ADM",AdmID,""),-1)  ;新版本 dt,gbl,fc
	if FeeRowId="" s FeeRowId=$O(^User.DHCRegistrationFeeI("ADM",AdmID,""),-1)      ;版本 zyy,zl
	Q:(FeeRowId="")&&(RowId="") "没有找到资源"
	s FeeObj=##class(User.DHCRegistrationFee).%OpenId(FeeRowId)
	if $IsObject(FeeObj) {
		s RegfeeDocDr=FeeObj.RegfeeDocDr.%Id()
		s RegfeeDepDr=FeeObj.RegfeeDepDr.%Id()
		s RegfeeRBASDr=FeeObj.RegfeeRBASDr.%Id()
		if RegfeeDocDr'="" s DocDr=RegfeeDocDr
		if RegfeeDepDr'="" s LocDr=RegfeeDepDr
		s ASRowId=RegfeeRBASDr
	}
	;s ^tmpgry(1)=LocDr_","_DocDr_","_PatId_","_UserId_","_ASRowId_","_AdmReason_","_FeeStr_","_RegType_","_InsuJoinType_","_INSUCardNo
	s myrtn=##class(web.DHCOPAdm).GetInsuBillPara(LocDr,DocDr,PatId,"",UserId,ASRowId,AdmReason,FeeStr,RegType,InsuJoinType,FreeRegFeeFlag,InsuReadCardInfo,RetInsuGSInfo)
	
	Q myrtn
}

/// CreatDate:   2010.01.30
/// Description: 获取医保实时结算所需要的挂号信息
/// Table:      
/// Input:       LocDr(科室), DocDr(医生), PatId, UPatientName(病人姓名??), UserId(用户), ASRowId(资源), AdmReason(费别), FeeStr(费用串)      
/// Input:       RegType(挂号类别),InsuJoinType(参保类别),FreeRegFeeFlag(免挂号费标志),InsuReadCardInfo(读医保卡返回信息),RetInsuGSInfo(医保返回工伤信息)           
/// Return:        
/// Others:		 w ##class(web.DHCOPAdm).GetInsuBillPara(p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13)
ClassMethod GetInsuBillPara(LocDr As %String, DocDr As %String, PatId As %String, UPatientName As %String, UserId As %String, ASRowId As %String = "", AdmReason As %String = "", FeeStr As %String = "", RegType As %String = "", InsuJoinType As %String = "", FreeRegFeeFlag As %String = "", InsuReadCardInfo As %String = "", RetInsuGSInfo As %String = "", ExpStr As %String = "") As %String
{
	s ^tmplog("InsuBill")=$lb(LocDr,DocDr,PatId,UPatientName,UserId,ASRowId,AdmReason,FeeStr,RegType,InsuJoinType,FreeRegFeeFlag,InsuReadCardInfo,RetInsuGSInfo,ExpStr)
	n (LocDr,DocDr,PatId,UPatientName,UserId,ASRowId,AdmReason,FeeStr,RegType,InsuJoinType,FreeRegFeeFlag,InsuReadCardInfo,RetInsuGSInfo,ExpStr)
	s AccRowId=$p(ExpStr,"^",1)
	s PayModeCode=$p(ExpStr,"^",2)
	s GroupId=$p(ExpStr,"^",3)
	;挂号来源(窗口01、集中打印02、微信31、支付宝32、自助20、本地算法10)
	s GHLY=$p(ExpStr,"^",4)
	s RegConDisId=$p(ExpStr,"^",5)
	s HospitalCode=""
	s myrtn=""
	;得到基本信息
	s ResRowId=+ASRowId,Childsub=$p(ASRowId,"||",2)
	s PatName="",LocCode="",DocCode="",DocDesc=""
	if PatId'="" s PatName=$P(^PAPER(PatId,"ALL"),"^",1)
	if (UPatientName'="")&&(PatName'=UPatientName)  s PatName=UPatientName
	;lock +^RBASLOCK(ResRowId,Childsub):10 ;Modify20220822 没必要加锁
	s AdmDate=..%SysDate(),AdmTime=..%SysTime()
	if ASRowId'="" {
		s LocDr=$p(^RB("RES",+ASRowId),"^",1)
		s DocDr=$p(^RB("RES",+ASRowId),"^",2)
		if LocDr'=""{
			s LocCode=$P(^CTLOC(LocDr),"^",1)
			s LocDesc=$P(^CTLOC(LocDr),"^",2)
			s LocDesc=$P(LocDesc,"-",1)
		}
		if DocDr'="" {
			s DocCode=$P($g(^CTPCP(DocDr,1)),"^",1)
			s DocDesc=$P($g(^CTPCP(DocDr,1)),"^",2)
		}
		s AdmDate=$p($g(^RBAS(+ASRowId,+$p(ASRowId,"||",2))),"^",1)
	}else{
		if LocDr'=""{
			s LocCode=$P(^CTLOC(LocDr),"^",1)
			s LocDesc=$P(^CTLOC(LocDr),"^",2)
			s LocDesc=$P(LocDesc,"-",1)
		}
		if DocDr'="" {
			s DocCode=$P($g(^CTPCP(DocDr,1)),"^",1)
			s DocDesc=$P($g(^CTPCP(DocDr,1)),"^",2)
		}
	}
	
	i AdmDate'="" s AdmDate=$zd(AdmDate,3)
	i AdmTime'="" s AdmTime=..%ZT(AdmTime,1)
	s AdmDateTime=AdmDate_" "_AdmTime
	;判断是否急诊
	s AdmType="O" 
 	s IsEmergency=##class(web.DHCOPAdmReg).IsEmergency(LocDr)
	if IsEmergency="1" s AdmType="E"
 	
	s TarItemInfo=$$GetTarItemStr()
	s TarItemStr=$p(TarItemInfo,$c(2),1)
	s TotalAmount=$p(TarItemInfo,$c(2),2)
	
	s YLLB=""
	i AdmType="O" {
		s YLLB=11
	}elseif AdmType="E" {
		s YLLB=10
	}
	s InsuNo="",CardType="0",YLLB=""
	s DiagCode="",DiagDesc=""
	;数据库连接串,默认为空即可
	s CacheConStr=""
	;lock -^RBASLOCK(ResRowId,Childsub) ;Modify20220822 没必要加锁
	if (AccRowId'=""){
		s AccmLeftBalance=##class(web.DHCOPAdmReg).GetAccmLeftBalance(AccRowId)
	}else{
		s AccmLeftBalance=0
	}
	s PayModeDr=""
	s:PayModeCode'="" PayModeDr=$o(^CT("CTPM",0,"Code",PayModeCode,0))
	s PatNo=$P(^PAPER(PatId,"PAT",1),"^",1)
	;Type^Name^TotalAmount^HisDepCode^UserId^Doctor^InsuNo^CardType^YLLB^DiagCode^DiagDesc^GHLY^CacheConStr!TarItemDr^Code^Desc^Amount!TarItemDr2^Code2^Desc2^Amount2!……
	;Quit AdmType_"^"_PatName_"^"_TotalAmount_"^"_LocCode_"^"_UserId_"^"_DocCode_"^"_InsuNo_"^"_CardType_"^"_YLLB_"^"_DiagCode_"^"_DiagDesc_"^"_GHLY_"^"_CacheConStr_"^"_GroupId_"^"_AccRowId_"^"_AccmLeftBalance_"^"_PayModeDr_"^"_AdmDateTime_"^"_LocDesc_"^"_DocDesc_"^^^^"_"^"_PatNo_"^"_PatId_"!"_TarItemStr
	
	s InsuRegParaInfo=AdmType_"^"_PatName_"^"_TotalAmount_"^"_LocCode_"^"_UserId     				                  ;1-5 就诊类型^患者姓名^项目总金额^科室代码^用户Id
	s InsuRegParaInfo=InsuRegParaInfo_"^"_DocCode_"^"_InsuNo_"^"_CardType_"^"_YLLB_"^"_DiagCode         				  ;6-10 医生代码^医保个人编号^卡类型^医疗类别^病种代码
	s InsuRegParaInfo=InsuRegParaInfo_"^"_DiagDesc_"^"_GHLY_"^"_CacheConStr_"^"_GroupId_"^"_AccRowId    			  ;11-15 病种名称^挂号来源^数据库连接串^安全组Id^预交金账户id
	s InsuRegParaInfo=InsuRegParaInfo_"^"_AccmLeftBalance_"^"_PayModeDr_"^"_AdmDateTime_"^"_LocDesc_"^"_DocDesc      		  ;16-20 预交金金额^个人支付部分支付方式id^挂号时间^就诊科室^就诊医生名称
	s InsuRegParaInfo=InsuRegParaInfo_"^^^^"_"^"_PatNo                                                         				                  ;21-25 就诊凭证类型^就诊凭证号码^人员证件类型^证件号码^登记号^病人id
	s InsuRegParaInfo=InsuRegParaInfo_"^"_PatId                                                               						  ;26 病人id
	;27-40预留信息
	///------------医保移动支付所需参数（由第三厂家在移动端自行填写补充，HIS仅预留出位置）start-------------
	s $p(InsuRegParaInfo,"^",41)=""   ;结算费别id
	s $p(InsuRegParaInfo,"^",42)=""   ;医院Id
	s $p(InsuRegParaInfo,"^",43)=""     ;订单号
	s $p(InsuRegParaInfo,"^",44)=""   ;支付授权码
	s $p(InsuRegParaInfo,"^",45)=""   ;电子凭证授权
	s $p(InsuRegParaInfo,"^",46)=""   ;经纬度
	s $p(InsuRegParaInfo,"^",47)=""   ;参保地区
	s $p(InsuRegParaInfo,"^",48)=""   ;险种类型
	s $p(InsuRegParaInfo,"^",49)=""   ;经办人类别
	s $p(InsuRegParaInfo,"^",50)=""   ;部门性质
	s $p(InsuRegParaInfo,"^",51)=""   ;IP地址
	s $p(InsuRegParaInfo,"^",52)=""   ;mac地址
	s DiagListStr=""
	s InsuRegParaInfo=InsuRegParaInfo_"=="_DiagListStr_"=="  
	///------------医保移动支付所需参数end-------------																																	
	Quit InsuRegParaInfo_"!"_TarItemStr

GetTarItemStr()
	s Fee=$P(FeeStr,"||",1)
	s checkfee=$P(FeeStr,"||",2)
	s holi=$P(FeeStr,"||",3)
	s appfee=$P(FeeStr,"||",4)
	s Other=$P(FeeStr,"||",5)
	s recheckfee=$P(FeeStr,"||",6)
 	if (AdmReason="") {
		s PatCatDr=$p(^PAPER(PatId,"PER",1),"^",10)
		s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	}
	s HospId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp("","",ASRowId,""),"^",1)
 	s SerIdStr=##class(web.DHCOPAdmReg).GetScheduleService(ASRowId,AdmReason,HospId)
 	s SerIdStr=##class(web.DHCOPAdmReg).GetCustomScheduleService(PatId,ASRowId,SerIdStr)
 	//病历本费
 	s BLBFee=##class(web.DHCOPAdmReg).GetMRFee()
 	i (Other=1)&&(BLBFee'="") {
 		s MRFeeArcimId=##class(web.DHCOPAdmReg).GetMRFeeArcimId()
 		if (MRFeeArcimId'=""){
 			s SerIdStr=SerIdStr_"^"_MRFeeArcimId
 		}
 	}
 	if SerIdStr="" Set SerIdStr=$p(##class(web.DHCOPRegConfig).GetSpecConfigNode("FreeOrder",HospId),"@",1)
 	if (RegConDisId=""){
		 s RegConDisIdPara=PatId_"^"_ASRowId_"^"_AdmReason_"^"_""
		 s RegConDisId=##class(web.DHCOPAdmReg).GetRegConDisId(RegConDisIdPara)
	}
	s HospId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp("","",ASRowId,""),"^",1)
	s ASDate=$P($G(^RBAS(+ASRowId,$P(ASRowId,"||",2))),"^",1) 
 	s TarItemStr="",OtherStr=""
	s RegTARIRowId="",RegTarCode="",RegTarDesc="",RegPrice=0
	s CheTARIRowId="",CheTarCode="",CheTarDesc="",ChePrice=0
	//未增加就诊类型导致获取折扣系数与实际不否
	s PriceExpStr=RegConDisId_"^^^^^^^^"_PatId_"^"_AdmType
	s TotalAmount=0
 	f i=1:1:$l(SerIdStr,"^") {
		s ArcimDr=$P(SerIdStr,"^",i)
		i (ArcimDr="") {continue}
		//需与挂号保持同步,没有考虑医院的特殊写死处理
		s RegSerBillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimDr,HospId)
		//诊察费放在下面处理通过 此处屏蔽
		;i (RegSerBillSubType="Check")&&((checkfee=0)!(checkfee="")) {continue}
		i (RegSerBillSubType="ReCheck")&&((recheckfee=0)!(recheckfee="")) {continue}
		i (RegSerBillSubType="App")&&((appfee=0)!(appfee="")) {continue}
		i (RegSerBillSubType="Holi")&&((holi=0)!(holi="")) {continue}
		i (RegSerBillSubType="Other")&&((Other=0)!(Other="")) {continue}
		
		;就诊类型。使用场景：有折扣的情况使用,由计费组提供接口获取
		;原协和提供的接口为:s EpisodeSubType=##class(web.DHCOPBillLocParEst).IGetEpisodeSubType(LocDr,AdmReason)
		s EpisodeSubType=""
		s ArcimDr=..CheckRegInsuComp(PatId,ArcimDr,InsuReadCardInfo)
		s BillPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReason,ArcimDr,ASDate,"","","","",HospId,PriceExpStr),"^",4)
		if (RegSerBillSubType="Reg") { 
			s RegItem=..GetTarIdByArcimId(EpisodeSubType,AdmReason,ArcimDr,ASDate,"","","","")
			s RegTARIRowId=$p(RegItem,"^",1)
			if RegTARIRowId'="" 
			 {
				 s RegTarCode=$p(^DHCTARI(RegTARIRowId),"^",1)
				 s RegTarDesc=$p(^DHCTARI(RegTARIRowId),"^",2)
				 s RegPrice=BillPrice //$p(RegItem,"^",2)
				 if (TarItemStr="") s TarItemStr=RegTARIRowId_"^"_RegTarCode_"^"_RegTarDesc_"^"_RegPrice
				 else  s TarItemStr=TarItemStr_"!"_RegTARIRowId_"^"_RegTarCode_"^"_RegTarDesc_"^"_RegPrice	
			 }
		}elseif (RegSerBillSubType="Check") {
	 		 s CheckItem=..GetTarIdByArcimId(EpisodeSubType,AdmReason,ArcimDr,ASDate,"","","","")
			 s CheTARIRowId=$p(CheckItem,"^",1)
			 if CheTARIRowId'="" 
			 {
			 	s CheTarCode=$p(^DHCTARI(CheTARIRowId),"^",1)
			 	s CheTarDesc=$p(^DHCTARI(CheTARIRowId),"^",2)
			 	s ChePrice=BillPrice //$p(CheckItem,"^",2)
			 	if (TarItemStr="") s TarItemStr=CheTARIRowId_"^"_CheTarCode_"^"_CheTarDesc_"^"_ChePrice
				else  s TarItemStr=TarItemStr_"!"_CheTARIRowId_"^"_CheTarCode_"^"_CheTarDesc_"^"_ChePrice	
			 }
		 }else{
			s OtherItem=..GetTarIdByArcimId(EpisodeSubType,AdmReason,ArcimDr,ASDate,"","","","")
			s OtherTARIRowId=$p(OtherItem,"^",1)
			 if OtherTARIRowId'="" 
			 {
				 s OtherTarCode=$p(^DHCTARI(OtherTARIRowId),"^",1)
				 s OtherTarDesc=$p(^DHCTARI(OtherTARIRowId),"^",2)
			 }else{
				 s OtherTarCode="",OtherTarDesc=""
			 }
			 s OtherPrice=BillPrice //$p(OtherItem,"^",2)
			 if OtherStr="" s OtherStr=OtherTARIRowId_"^"_OtherTarCode_"^"_OtherTarDesc_"^"_OtherPrice
			 else  s OtherStr=OtherStr_"!"_OtherTARIRowId_"^"_OtherTarCode_"^"_OtherTarDesc_"^"_OtherPrice
 		}
		s TotalAmount=TotalAmount+(+$g(BillPrice))
 	}
 	i OtherStr'="" s TarItemStr=TarItemStr_"!"_OtherStr
 	//s TotalAmount=RegPrice+ChePrice+(+$g(OtherPrice))
 	Q TarItemStr_$C(2)_TotalAmount
}

/// CreatDate?    2017.08.30
/// Description:? 获取：医生站配置—>医保上传代码对照的对照数据
/// Table?     
/// Input         PatId PA_Person表ID,OldArcimDr 当前传入需比较的医嘱项目ID,[InsuReadCardInfo] 读一医保卡返回信息
/// output?       NewArcimDr	对照的医嘱项目ID,如果没有对照数据则会将传入的项目ID返回       
/// Others? 
/// debug	w ##class(web.DHCOPAdm).CheckRegInsuComp(1,"4||1","||||||ttt||")
ClassMethod CheckRegInsuComp(PatId As %String, OldArcimDr As %String, InsuReadCardInfo As %String) As %String
{
	n (PatId,OldArcimDr,InsuReadCardInfo)
	Q:OldArcimDr="" OldArcimDr
	s ExistRICRowid=$O(^User.DHCOPRegInsuCompI("RICNowOrdItemIndex",OldArcimDr,""))
	Q:ExistRICRowid="" OldArcimDr
	s NewArcimDr=OldArcimDr
	s InsuPatType=$p(InsuReadCardInfo,"|",7)
	s AdmReason=""
	i PatId'="" {
		s PatCatDr=$p(^PAPER(PatId,"PER",1),"^",10)
		s AdmReason=##class(web.DHCOPAdmReg).GetDefaultBillType(PatCatDr)
	}
	if AdmReason'="" {
		s RICRowid=0
		for {
			s RICRowid=$O(^User.DHCOPRegInsuCompI("RICNowOrdItemIndex",OldArcimDr,RICRowid))
			Q:RICRowid=""
			s RICAdmReason=$List(^User.DHCOPRegInsuCompD(RICRowid),8)
			s RICStartDate=$List(^User.DHCOPRegInsuCompD(RICRowid),7)
			s RICEndDate=$List(^User.DHCOPRegInsuCompD(RICRowid),6)
			if (RICStartDate'="")&(RICStartDate>+$h) continue
			if (RICEndDate'="")&(RICEndDate<+$h) continue
			if AdmReason=RICAdmReason s NewArcimDr=$List(^User.DHCOPRegInsuCompD(RICRowid),5)
		}
	}
	if InsuPatType'="" {
		s RICRowid=0
		for {
			s RICRowid=$O(^User.DHCOPRegInsuCompI("RICNowOrdItemIndex",OldArcimDr,RICRowid))
			Q:RICRowid=""
			s RICInsuPatTypeCode=$List(^User.DHCOPRegInsuCompD(RICRowid),2)
			s RICStartDate=$List(^User.DHCOPRegInsuCompD(RICRowid),7)
			s RICEndDate=$List(^User.DHCOPRegInsuCompD(RICRowid),6)
			if (RICStartDate'="")&(RICStartDate>+$h) continue
			if (RICEndDate'="")&(RICEndDate<+$h) continue
			if InsuPatType=RICInsuPatTypeCode s NewArcimDr=$List(^User.DHCOPRegInsuCompD(RICRowid),5)
		}
	}
	
	q NewArcimDr
}

ClassMethod GetTarIdByArcimId(pattype, instype, arcim, sttdate, prior, instr, linkto, oeprice) As %String
{
	//w ##Class(web.DHCOPAdm).GetTarIdByArcimId("","","ArcimId",+$H,"","","","")
	s Price=0,DiscPrice=0,InsPrice=0,PatPrice=0,RTarcRowId=""
	s Conf=$o(^DHCTarC("CF","")) q:Conf="" RTarcRowId_"^"_Price
	;
	s ReturnString=""
	s ExecuDate=""
	f  s ExecuDate=$o(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate)) q:ExecuDate=""  d
	.q:ExecuDate>sttdate
	.s OLT=""
	.f  s OLT=$o(^DHCOLT(0,"ARCIM",arcim,"Z",ExecuDate,OLT)) q:OLT=""  d
	..s EndDate=$p(^DHCOLT(OLT),"^",5)
	..q:((EndDate<sttdate)&&(EndDate'=""))
	..s qty0=$p(^DHCOLT(OLT),"^",3)
	..s Itm=$p(^DHCOLT(OLT),"^",2)
	..s RTarcRowId=Itm
	..s err=##Class(web.UDHCJFPRICE).GetItmPrice(Itm,sttdate,instype,pattype,oeprice)
	..s Price=$p(err,"^",1)*qty0+Price
	..;s DiscPrice=$p(err,"^",2)*qty0+DiscPrice
	..;s InsPrice=$p(err,"^",3)*qty0+InsPrice
	..;s PatPrice=$p(err,"^",4)*qty0+PatPrice
	
	i ($p($g(^DHCTarC("CF",Conf)),"^",6)="Y")&(linkto="")&(instr'="") d
	.s ExecuDate=""
	.f  s ExecuDate=$o(^DHCOLT(0,"ARCIM",arcim,instr_"Z",ExecuDate)) q:ExecuDate=""  d
	..q:ExecuDate>sttdate
	..s OLT=""
	..f  s OLT=$o(^DHCOLT(0,"ARCIM",arcim,instr_"Z",ExecuDate,OLT)) q:OLT=""  d
	...s EndDate=$p(^DHCOLT(OLT),"^",5)
	...q:((EndDate<sttdate)&&(EndDate'=""))
	...s qty0=$p(^DHCOLT(OLT),"^",3)
	...s Itm=$p(^DHCOLT(OLT),"^",2)
	...s RTarcRowId=Itm
	...s err=##Class(web.UDHCJFPRICE).GetItmPrice(Itm,sttdate,instype,pattype,oeprice)
	...s Price=$p(err,"^",1)*qty0+Price
	...;s DiscPrice=$p(err,"^",2)*qty0+DiscPrice
	...;s InsPrice=$p(err,"^",3)*qty0+InsPrice
	...;s PatPrice=$p(err,"^",4)*qty0+PatPrice
	
	s ReturnString=RTarcRowId_"^"_Price
	Q ReturnString
}

/// CreatDate?    2009.09.11
/// Description:? 取免挂号的医嘱
/// Table?        
/// Input?       AgeFlag(老年证年龄标记)，FreeRegFeeFlag(界面免挂号费标记) 
/// Return?      免挂号的医嘱ID
/// Others?   
ClassMethod GetFreeRegFeeArcimId(Age As %String, FreeRegFeeFlag As %String, OldManCardId As %String) As %String
{
   if (Age'="")
   { s FreeRegFeeAge=80          ;从设置里读取
      if (Age>FreeRegFeeAge)     ;根据年龄判断是否免挂号费
      {
		s ARCIMSubscript=$O(^ARCIM(0,"Code","110100001MF",""))
		s ARCIMVersion=$O(^ARCIM(0,"Code","110100001MF",ARCIMSubscript,""))
		Q ARCIMSubscript_"||"_ARCIMVersion	
      }
  }elseif ((FreeRegFeeFlag="Y")!(OldManCardId'="")){	
  	;根据界面标志或老年证判断是否免挂号费	
  	s ARCIMSubscript=$O(^ARCIM(0,"Code","110100001MF",""))
	s ARCIMVersion=$O(^ARCIM(0,"Code","110100001MF",ARCIMSubscript,""))
	Q ARCIMSubscript_"||"_ARCIMVersion	
  }else{
	Q ""
  }
}

ClassMethod GetMRFee() As %String
{
	s ArcimId=..GetMRFeeArcimId()
	Q:ArcimId="" 0
	s BillPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("","",ArcimId,+$H,"","","",""),"^",4)
	Q BillPrice
}

ClassMethod GetMRFeeArcimId() As %String
{
	s HospitalCode=..GetHospitalCode()
	if HospitalCode="YKDYY" {
		s ARCIMSubscript=$O(^ARCIM(0,"Code","CZJBLSC",""))
		s ARCIMVersion=$O(^ARCIM(0,"Code","CZJBLSC",ARCIMSubscript,""))
		Q ARCIMSubscript_"||"_ARCIMVersion
	}elseif(HospitalCode="SZZYY") {
		s ARCIMSubscript=$O(^ARCIM(0,"Code","11010000102",""))
		s ARCIMVersion=$O(^ARCIM(0,"Code","11010000102",ARCIMSubscript,""))
		Q ARCIMSubscript_"||"_ARCIMVersion
		
	}else{
		Q ""
	}
}

ClassMethod GetHospitalCode()
{
	s HospitalRowId=$O(^CT("HOSP",0))
	Q:HospitalRowId="" ""
	s HospitalNationalCode=$P(^CT("HOSP",HospitalRowId),"^",1)
	Q HospitalNationalCode
}

/// 医保计费
ClassMethod OPInsuBill(InvoiceRowid As %String, InsuStr As %String)
{
	s ^RP("OPInsuBill")=InvoiceRowid_"^"_InsuStr
	;医保支付明细
	Q:InsuStr="" "0"
	s Strlen=$l(InsuStr,$c(2))
	s FirstStr=$P(InsuStr,$c(2),1)
	s FirstPMId=$P(FirstStr,"^",1)
	s FirstPMPay=$P(FirstStr,"^",2)
	TS
	s CTPMRowId=InvoiceRowid_"||1"
	s selrtn=..IPMSELECT(CTPMRowId)
	s ret=$p(selrtn,"^",1)
	i +ret'="0"{
		TRollback
		Q "201002"
	}
	s Date=$p(selrtn,"^",2)
	s Time=$p(selrtn,"^",3)
	s PayAmt=$fn($p(selrtn,"^",4),"",2)
	s AccPLDR=$p(selrtn,"^",5)
	s uprtn=..IPMUPDATEAll(CTPMRowId,FirstPMId,FirstPMPay)
	i +uprtn'="0"{
		TRollback
		Q "201002"
	}
	s flag=0
	for i=2:1:Strlen {
		s TempStr=$P(InsuStr,$c(2),i)
		s thisPayModeid=$p(TempStr,"^",1)
		s thisPay=$p(TempStr,"^",2)
		s inret=..IPMINSERT(InvoiceRowid,thisPayModeid,thisPay,Date,Time)
		i (+inret) {
			s flag=flag+1
		}
		Q:flag'="0"
	}
	i (flag=1){
		TrollBack
		Q "201002"
	}
	TC
	Q 0
}

ClassMethod OPInsuCoBill(InvoiceRowid As %String, InsuCoStr As %String)
{
	s RegfeeInsuCoDR="",RegfeeInsuCoProDR="",RegfeeInsuCoPatPay=""
	i ((InsuCoStr'="")&&(InsuCoStr[$C(2))){
		s RegfeeInsuCoDR=$p(InsuCoStr,$C(2),1)
		s RegfeeInsuCoProDR=$p(InsuCoStr,$C(2),2)
		s RegfeeInsuCoPatPay=$p(InsuCoStr,$C(2),3)	
		s RegfeeInsuCoPatPay=$p(RegfeeInsuCoPatPay,"^",1)
	}
	;这个条件有问题?支付比例和支付的钱不为空更新发票子表 ,为零呢?
	i ((RegfeeInsuCoProDR'="")&&(RegfeeInsuCoPatPay'="")){
		s RegfeeInsuCoPatPay=$fn(RegfeeInsuCoPatPay,"",2) 
		s RegfeeInsuCoPatPayRound=##class(web.DHCBillConsIF).OPCRound(RegfeeInsuCoPatPay,"")
		s RegfeeInsuCoPatPayRound=+(RegfeeInsuCoPatPayRound-RegfeeInsuCoPatPay)
		TS
		&sql(UPDATE sqluser.DHC_INVPRT set PRT_OPCRoundErr=:RegfeeInsuCoPatPayRound  WHERE PRT_Rowid= :InvoiceRowid)
		i SQLCODE{
			TRollback
			Q "201002"
		}
		s CTPMRowId=InvoiceRowid_"||1"
		s selrtn=..IPMSELECT(CTPMRowId)
		s ret=$p(selrtn,"^",1)
		i +ret'="0"{
			TRollback
			Q "201002"
		}
		
		s Date=$p(selrtn,"^",2)
		s Time=$p(selrtn,"^",3)
		s PayAmt=$fn($p(selrtn,"^",4),"",2)
		s AccPLDR=$p(selrtn,"^",5)
		s uprtn=..IPMUPDATE(CTPMRowId,RegfeeInsuCoPatPay)
		i +uprtn'="0"{
			TRollback
			Q "201002"
		}
		s InsuCoPay=PayAmt-RegfeeInsuCoPatPay
		;为零还更新?
		s PayModeid=$o(^CT("CTPM",0,"Code","SYBX",0))
		s inret=..IPMINSERT(InvoiceRowid,PayModeid,InsuCoPay,Date,Time)
		i (+inret'="0"){
			TRollback
			Q "201002"
		}
		TC		
	}
	Q 0
}

ClassMethod IPMSELECT(CTPMRowId)
{
	s IPMDate="",IPMTime="",IPMAmt="",IPMAccPLDR=""
	&sql(SELECT IPM_Date,IPM_Time,IPM_Amt,IPM_AccPL_DR INTO :IPMDate,:IPMTime,:IPMAmt,:IPMAccPLDR FROM sqluser.DHC_INVPayMode WHERE IPM_RowID= :CTPMRowId) 
	q SQLCODE_"^"_IPMDate_"^"_IPMTime_"^"_IPMAmt_"^"_IPMAccPLDR
}

ClassMethod IPMUPDATE(CTPMRowId, Pay)
{
	
	q:((CTPMRowId="")!(RegfeeInsuCoPatPay="")) "1"
	&sql(update sqluser.DHC_INVPayMode set IPM_Amt=:Pay WHERE IPM_RowID= :CTPMRowId) 
	q SQLCODE
}

ClassMethod IPMINSERT(InvoiceRowid, PayModeid, Pay, Date, Time)
{
	
	q:((InvoiceRowid="")!(PayModeid="")) "1"
	&sql(insert into sqluser.DHC_INVPayMode (IPM_PRT_ParRef,IPM_PayMode_DR,IPM_Amt,IPM_Date,IPM_Time) values(:InvoiceRowid,:PayModeid,:Pay,:Date,:Time)) 
	q SQLCODE
}

/// 医保使用
ClassMethod IPMUPDATEAll(CTPMRowId, Id, Pay)
{
	
	q:((CTPMRowId="")!(Id="")!(Pay="")) "1"
	&sql(update sqluser.DHC_INVPayMode set IPM_Amt=:Pay,IPM_PayMode_DR=:Id WHERE IPM_RowID= :CTPMRowId) 
	q SQLCODE
}

/// 还原挂号用
ClassMethod QueueUpdate(Para As %String)
{
	n (Para)
	//Update DHC_Queue 更新分诊排队记录表
	s EpisodeID=$P(Para,"^",1)
	s RoomDr=$P(Para,"^",2)
	s QueueNo=$P(Para,"^",3)
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s Name=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	s PatientNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	
	s AdmDate=$P(^PAADM(EpisodeID),"^",6)
	s AdmDep=$P(^PAADM(EpisodeID),"^",4)
	s AdmDoc=$P(^PAADM(EpisodeID),"^",9)
	
	s QueueID=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""),-1)
	if QueueID="" Q "UpdateQueueError"
	//"等候"状态rowid
	&sql(select ID into :PersDr from  SQLUser.DHCPerState where PersName="等候")
	&sql(select ID into :FirstDr from SQLUser.DHCFirstCode where firstcname="正常")
	set ExabDr=""
	set MarkRowid=0
	set SQLCODE=0
	s RoomDr=""
	if RoomDr="" {
		&sql(SELECT ID,depmbordr into :MarkRowid,:ExabDr FROM sqluser.DHCDepMark where depmdepdr=:AdmDep and depmmarkdr=:AdmDoc)
		 if (ExabDr'="") {
			&sql(select ExabTem into :Checkin from SQLUser.DHCExaBorough where ID=:ExabDr)
			
			if Checkin'="Y"{
			   s Checkin=$list(^User.DHCDepMarkD(MarkRowid),10)
			}
			if (Checkin="Y"){
			&sql(select ID into :PersDr from  SQLUser.DHCPerState where PersName="报到")
			}else{
			&sql(select ID into :PersDr from  SQLUser.DHCPerState where PersName="等候")
			}
			&SQL(Update SQLUser.DHCQueue
			(QueDate,QuePersonId,QueName,QueExabDr,QueDepDr,QueMarkDr,QueNo,QuePaadmDr,QueStateDr,QueFirstDr)
			values(:AdmDate,:PatientNo,:Name,:ExabDr,:AdmDep,:AdmDoc,:QueueNo,:EpisodeID,:PersDr,:FirstDr) where ID=:QueueID)
		 }else{
			s SQLCODE=0
		 }
	}else{
		;通过诊室与诊区的关系去得到诊区RowId
		//&SQL(Select ExarBorDr Into :ExabDr From DHCExaRoom Where %Id=:RoomDr )
		&SQL(Update SQLUser.DHCQueue
		(QueDate,QuePersonId,QueName,QueExabDr,QueDepDr,QueMarkDr,QueNo,QuePaadmDr,QueStateDr,QueFirstDr)
		values(:AdmDate,:PatientNo,:Name,:ExabDr,:AdmDep,:AdmDoc,:QueueNo,:EpisodeID,:PersDr,:FirstDr) where ID=:QueueID)
	}
	Q SQLCODE
}

/// CreatDate?    2017.08.30
/// Description:? 撤销HIS退号，使用场景：退号流程中退号在前，然后医保退号，如果医保退号不成功则调用此方法撤销HIS退号
/// Table?     
/// Input         adm PA_Adm表ID
/// output?       0	成功,其他 失败       
/// Others? 
ClassMethod RevivificationReg(adm As %String, GroupDR As %String, LogState As %String = "") As %String
{
	Q:adm="" "admIsNull"
	
	s RegFeeRowId=$O(^User.DHCRegistrationFeeI("ADM",adm,""))
	if RegFeeRowId="" {
		d ..SaveRevivificationLog(adm,LogState,"没有得到DHCRegistionFee的ID")
		Q "NotRegFeeRowId"
	}
	
	&SQL(Select RegfeeAdmDr,RegfeeNo,RegfeeDoFlag,RegfeeRBASDr,Regfeetemp1,RegfeeDate,RegfeeRoomDr
	   into :adm,:QueueNo,:doflag,:RBASRowId,:InvoiceId,:RegfeeDate,:RoomDr
	   from SQLUser.DHCRegistrationFee 
	  Where %Id=:RegFeeRowId)
	  
	if adm'="" {
		s AdmStatus=$P($g(^PAADM(adm)),"^",20)
		if AdmStatus="A" {
			d ..SaveRevivificationLog(adm,LogState,"就诊状态错误")
			Q "PAADMStarusError"
		}
	}
    
	s RestoreInvoiceId="",oldInvoiceId="",RegInvoiceId="" 
	&SQL(select PRT_RowId into :oldInvoiceId From SQLUser.DHC_INVPRT where PRT_initInv_Dr=:InvoiceId)
	if (oldInvoiceId'="") {s RestoreInvoiceId=oldInvoiceId}
	else {
		s RestoreInvoiceId=InvoiceId
		&SQL(select PRT_initInv_Dr into :RegInvoiceId From SQLUser.DHC_INVPRT where PRT_RowId=:InvoiceId)
	}
	
    if RestoreInvoiceId="" {
	    d ..SaveRevivificationLog(adm,LogState,"发票ID没有找到")
	    Q "RestoreInvoiceIdNotExist"
    }
    
    TS
	if RegInvoiceId'="" {
		&SQL(Update SQLUser.DHCRegistrationFee Set Regfeetemp1=:RegInvoiceId Where %Id=:RegFeeRowId)
		if SQLCODE {
			TRO
			d ..SaveRevivificationLog(adm,LogState,"更新DHCRegistrationFee的发票ID错误")
			Q "UpdateInvoiceIdError"
		}
	}

	s Para=adm_"^"_RoomDr_"^"_QueueNo
	s myrtn=..QueueUpdate(Para)
	if myrtn'=0 {
		TRO
		d ..SaveRevivificationLog(adm,LogState,"更新队列表失败")
		Q myrtn
	}
	
	b ;判断是否为预约
	s APPTRowIdStr=##class(web.DHCRBAppointment).GetAppByAdm(adm)
	if (APPTRowIdStr'=""){
		;取消预约(包括了回退号的处理)
		s UserRowId=%session.Get("LOGON.USERID")
		s APPTRowId=$P(APPTRowIdStr,"^",1)
		s err=##class(web.DHCRBAppointment).AppRestore(APPTRowId,UserRowId)
		if err {
			TRo
			d ..SaveRevivificationLog(adm,LogState,"预约号回退失败")
			Q "-210"
		}
	}else{
		Set StatusCode=1
		d ##class(web.DHCRBAppointment).RestoreSeqNo(RBASRowId,QueueNo, StatusCode)
	}
	
	s vis="A",read="",admdate="",admtime=""
    &sql(update SQLUser.PA_Adm set PAADM_VisitStatus=:vis,
    PAADM_ReadOnly=null,PAADM_UpDateDate=null,PAADM_UpDateTime=null,
    PAADM_SocialWorkerName=null 
    where PAADM_RowID=:adm)
	
	///如果有重收的新发票,则需要还原账单及发票信息(调用计费组提供的统一接口)
	if (SQLCODE=0)&&(RestoreInvoiceId'="") {
		s ExpStr=GroupDR_"^"
		s SQLCODE=##class(web.DHCBillConsIF).DelINVPRTForYB(RestoreInvoiceId,ExpStr)
	}

	if SQLCODE=0 {
		TC
		d ..SaveRevivificationLog(adm,LogState,"成功")
		Quit 0
	}else{
		TRO
		d ..SaveRevivificationLog(adm,LogState,"失败")
		Quit 1
	}
}

/// 撤销退号日志记录
ClassMethod SaveRevivificationLog(adm As %String = "", LogState As %String = "", ExpStr As %String = "")
{
	n (adm,LogState,ExpStr)
	s VisitStatus=$p(^PAADM(adm),"^",20)
	s ReadOnly=$p(^PAADM(adm,1),"^",20)
	s UpDateDate=$p(^PAADM(adm,1),"^",42)
	s UpDateTime=$p(^PAADM(adm,1),"^",43)
	s SocialWorkerName=$p(^PAADM(adm,2),"^",69)
	s ^DHCRevivificationRegLog("ERROR",adm)=ExpStr_"^"_VisitStatus_$c(1)_ReadOnly_$c(1)_UpDateDate_$c(1)_UpDateTime_$c(1)_SocialWorkerName_"^"_LogState
}

/// CreatDate?    2017.08.30
/// Description:? 调用计费接口，使用场景：医保挂号更新发票支付方式表
/// Table?     
/// Input         InsuJoinStr 医保结算返回信息
/// output?       0	成功,其他 失败       
/// Others? 
ClassMethod UpdateINVPRTYBInfo(InsuJoinStr, INVRowID)
{
	Q:InsuJoinStr="" "-100"
	s InsuPayStr=$p(InsuJoinStr,"!",1)
	;医保返回信息中的支付方式串,其中包括:现金支付,帐户支付,统筹支付;
	;个人支付固定放在第一部分,已经和医保组约定
	s InsuPayModeDetailStr=$p(InsuJoinStr,"!",2)
	
	s InsuRet=$p(InsuPayStr,"^",1)
	s InsuAdmRowid=$p(InsuPayStr,"^",2)
	s InsuDivRowid=$p(InsuPayStr,"^",3)
	;个人自付方式及金额
	s PatPayModeDR=$p(InsuPayStr,"^",4)
	s PatShareSum=0
	s NotPatSharePayModeStr=""
	for i=1:1:$l(InsuPayModeDetailStr,$c(2)) {
		s OneInsuPayModeStr=$p(InsuPayModeDetailStr,$c(2),i)
		s OneInsuPayModeId=$p(OneInsuPayModeStr,"^",1)
		s OneInsuPayModeAmount=$p(OneInsuPayModeStr,"^",2)
		;计费接口中传入的支付方式串不包含个人自付部分
		i PatPayModeDR=OneInsuPayModeId { //PatPayModeDR'="",
			s PatShareSum=PatShareSum+OneInsuPayModeAmount
			continue
		}
		
		i NotPatSharePayModeStr="" s NotPatSharePayModeStr=OneInsuPayModeStr
		e  s NotPatSharePayModeStr=NotPatSharePayModeStr_$c(2)_OneInsuPayModeStr
		
	}
	s YBInfo=InsuRet_"^"_InsuDivRowid_"^"_PatShareSum_"^"_INVRowID_"^"_PatPayModeDR_$c(2)_NotPatSharePayModeStr
	s ExpStr=""
	s err=##class(web.DHCBillConsIF).UpdateINVPRTYBInfo(YBInfo,ExpStr)
	
	Q err
}

}
