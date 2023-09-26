Import SQLUser

/// 电子发票查询页面与后台交互
Class BILL.EINV.BL.COM.InvPageInfoCtl Extends %RegisteredObject
{

/// date   ：      2019-09-24    guoyunlong
/// Description:   查询上传成功的电子票据信息
/// Input:			IUDStDate ->开始时间    
/// 				IUDEdDate->结束时间   
/// 				IUDAdmType->票据类型 
/// 				InvNo——>发票ID 
/// 				UserId->操作员
/// 				RegNo->登记号  	
/// Output：       IUDBusNo : 业务流水号 IUDCreatAmt : 开票金额 IUDBillBatchCode : 电子票据代码
/// 			   IUDBillBatchNo : 电子票据号码 IUDPayAdmType : 票据类型 IUDUser : 上传人
/// 			   IUDDate : 上传日期 IUDUplodeFlag : 上传标志,IUDCreatDate 开票日期 
///                IUDCreatTime:  开票时间 ，登记号:PatNo  ,姓名PatName, IUDAdmType As %String = "", InvNo As %String = "", UserId As %String = ""
/// Modify By suhuide at 2022-01-06 考虑使用对象取值前台加载是否过慢?? 修改用$list取值
/// Modify By suhuide at 2023-03-24 修改按照登记号检索(直接利用患者ID做索引)
/// Debug:	d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvPageInfoCtl","QueryBillIUDInfo","2019-09-01","2019-09-27")
Query QueryBillIUDInfo(IUDStDate As %String, IUDEdDate As %String, IUDAdmType As %String = "", InvNo As %String = "", UserId As %String = "", RegNo As %String = "") As %Query(ROWSPEC = "ind,IUDBusNo:%String,IUDCreatAmt:%String,IUDBillBatchCode:%String,IUDBillBatchNo:%String,IUDPayAdmType:%String,USRName:%String,IUDDate:%String,IUDUplodeFlag:%String,IUDHospDr:%String,IUDCreatDate:%String,IUDCreatTime:%String,IUDBillBatchStatus:%String,IUDBillisScarlet:%String,IUDInvDr:%String,PrintType:%String,InvStyle:%String,PrintFlag:%String,RateStatus:%String,PatNo:%String,PatName:%String,IUDDate:%String,IUDTime:%String,IUDVoucherBatchCode:%String,IUDVoucherNo:%String,IUDInitRowID:%String,IUDPrintType,DepDesc,DocDesc,AdmDate,AdmTime,IUDID,TurnFlag") [ SqlProc ]
{
}

ClassMethod QueryBillIUDInfoExecute(ByRef qHandle As %Binary, IUDStDate As %String, IUDEdDate As %String, IUDAdmType As %String = "", InvNo As %String = "", UserId As %String = "", RegNo As %String = "") As %Status
{
	;set ^tempcache("QueryBillIUDInfoExecute")=$lb(IUDStDate,IUDEdDate,IUDAdmType,InvNo,UserId,RegNo)
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
    quit:(IUDStDate="")||(IUDEdDate="") $$$OK	
	//获取上传成功的发票业务信息
    set IUDStDate=##class(websys.Conversions).DateHtmlToLogical(IUDStDate)
    set IUDEdDate=##class(websys.Conversions).DateHtmlToLogical(IUDEdDate)
   
   //1.登记号查询
	if (RegNo'=""){
		set PatientNO=##class(web.UDHCJFBaseCommon).regnocon(RegNo)
		set PatientNO=$zcvt(PatientNO,"U")
		set Papmi=$o(^PAPERi("PAPMI_PatNo",PatientNO,""))
		quit:(Papmi=0)
		set IUDID=""
		while($o(^BILL.EINV.PO.InvUpDetailsI("IdxPaPmiDr",Papmi,IUDID),-1)) {
			set IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxPaPmiDr",Papmi,IUDID),-1)
			do GetInvUpDetails(IUDID)	
		}
	
		quit $$$OK
	
	}else{
		//2.日期查询
		for date=IUDStDate:1:IUDEdDate {
			set IUDID=""
			while($o(^BILL.EINV.PO.InvUpDetailsI("IdxDate",date,IUDID),-1)) {
				set IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxDate",date,IUDID),-1)	
				do GetInvUpDetails(IUDID)
			}
		}	
		
		quit $$$OK
	}  
GetInvUpDetails(IUDID)
	set IUDUplodeFlag=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),8)			//ObjIUDInfo.IUDUplodeFlag  			    ;上传标志（Y:上传成功，N:上传失败）
	quit:IUDUplodeFlag'="Y"                                      ;过滤未开具数据
	set IUDPayAdmType=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),7)			//ObjIUDInfo.IUDPayAdmType  				;票据类型
	quit:(IUDAdmType'="")&&(IUDPayAdmType'=IUDAdmType)           ;过滤不满足的票据类型
	set IUDBusNo=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),6)				//ObjIUDInfo.IUDBusNo    						;业务流水号
	set IUDCreatAmt=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),17)			//ObjIUDInfo.IUDCreatAmt 						;开票金额
	set IUDBillBatchCode=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),12)		//ObjIUDInfo.IUDBillBatchCode 		    ;电子票据代码
	set IUDBillBatchNo=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),13)			//ObjIUDInfo.IUDBillBatchNo				;电子票据号码

	set IUDUser=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),5)					//ObjIUDInfo.IUDUser                				 ;指向SS_User
 	;quit:(UserId'="")&&(UserId'=IUDUser)
	set USRName=$p($g(^SSU("SSUSR",IUDUser)),"^",2)			     ;上传人

	if ($LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),2)'="") {
		set IUDDate=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),2)                             ;上传日期
		set IUDTime=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),3)                             ;上传时间
		set IUDDate=##class(websys.Conversions).DateLogicalToHtml(IUDDate)
		set IUDTime=##class(websys.Conversions).TimeLogicalToHtml(IUDTime, 1)

	}else{
		set IUDDate=""                              ;上传日期
		set IUDTime=""                              ;上传时间
	}
	set IUDHospDr=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),14)							//ObjIUDInfo.IUDHospDr                           ;院区指针
    if ($LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),15)'="") {
		set IUDCreatDate=$zd($LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),15),3)   			//$zd(ObjIUDInfo.IUDCreatDate,3)              ;开票日期  
		set IUDCreatTime=$zt($LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),16),1)			//$zt(ObjIUDInfo.IUDCreatTime)                ;开票时间 
    	set IUDCreatDate=##class(websys.Conversions).DateLogicalToHtml(IUDCreatDate)
		set IUDCreatTime=##class(websys.Conversions).TimeLogicalToHtml(IUDCreatTime, 1)

	}else{
		set IUDCreatDate=""                              
		set IUDCreatTime=""                             
	
	}
	set IUDBillBatchStatus=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),24)			//ObjIUDInfo.IUDBillBatchStatus         ;电子票据状态(状态：1正常，2作废)
	set IUDBillisScarlet=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),27)			//ObjIUDInfo.IUDBillisScarlet             ;是否已开红票  
	set IUDInvDr=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),4)					//ObjIUDInfo.IUDInvDr                             ;发票表指针
	;set IUDInitRowID=ObjIUDInfo.IUDInitRowID					;原交易指针
	set IUDInitRowID=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),46)				//ObjIUDInfo.OrgIUDInvDr					    ;add by xubaobao 2021 10 29 此处应该取原发票表id
	set PrintType=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),30) 					//ObjIUDInfo.IUDPrintType                       ;票据模式 E-电子票据 P-纸质发票
	set:PrintType="E" IUDPrintType="电子票据"
	set:PrintType="P" IUDPrintType="纸质票据"
	quit:"H|I"'[$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),40)					//ObjIUDInfo.EInvFlg
	set InvStyle=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),29)						//ObjIUDInfo.IUDStyle	                		; 票据种类 V-增值税发票 C-普票
	set PrintFlag=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),19)					//ObjIUDInfo.IUDPrintFlag				        ;是否打印纸质票据(0未打印，1已打印)
	set RateStatus=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),20)					//ObjIUDInfo.IUDRateStatus			            ;纸质生成状态(0未生成、1已生成、2失败 )
	set IUDVoucherBatchCode=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),37)			//ObjIUDInfo.IUDVoucherBatchCode       ;预交金凭证代码
	set IUDVoucherNo=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),38)					//ObjIUDInfo.IUDVoucherNo                     ;预交金凭证号码 
	set PatBaseInfo=##class(BILL.EINV.BL.COM.InvPageInfoCtl).GetBaseInfoByPrtIDandAdmType(IUDInvDr,IUDPayAdmType)
	if ($p(PatBaseInfo,"!",1)="0"){
		set PatNo=$p($p(PatBaseInfo,"!",2),"^",1)
		set PatName=$p($p(PatBaseInfo,"!",2),"^",2)
	} 


	set TurnFlag=""
    set EINVInfoStr=##class(BILL.EINV.BL.COM.InvUpDetailsCtl).GetEInvBillNoStr(IUDPayAdmType,IUDInvDr,"P")
    set:((PrintType="E")&&(EINVInfoStr'="")) TurnFlag="已换开"
	set PatInfo=##class(BILL.EINV.BL.COM.Common).GetPatIdAndAdmId(IUDPayAdmType,IUDInvDr)
	set adm=$p(PatInfo,"^",2)
	set (DepDesc,DocDesc,AdmDate,AdmTime)=""
	i (adm'="") {
		set AdmDate=$p(^PAADM(adm),"^",6)
		set AdmTime=$p(^PAADM(adm),"^",7)
    	set AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
		set AdmTime=##class(websys.Conversions).TimeLogicalToHtml(AdmTime, 1)
		set DepID=$p(^PAADM(adm),"^",4) 
		if (DepID'="") {
			set DepDesc=$p($g(^CTLOC(DepID)),"^",2) 			//科室
		}
		set DocID=$p(^PAADM(adm),"^",9)
		if (DocID'="") {
			set DocDesc=$p($g(^CTPCP(DocID,1)),"^",2)
	
		}
	
	}
	do OutputRow
	
OutputRow
	set Data=$lb(ind,IUDBusNo,IUDCreatAmt,IUDBillBatchCode,IUDBillBatchNo,IUDPayAdmType,USRName,IUDDate,
	IUDUplodeFlag,IUDHospDr,IUDCreatDate,IUDCreatTime,IUDBillBatchStatus,IUDBillisScarlet,IUDInvDr,PrintType,InvStyle,
	PrintFlag,RateStatus,PatNo,PatName,IUDDate,IUDTime,IUDVoucherBatchCode,IUDVoucherNo,IUDInitRowID,IUDPrintType,DepDesc,DocDesc,AdmDate,AdmTime,IUDID,TurnFlag)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

ClassMethod QueryBillIUDInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBillIUDInfoExecute ]
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

ClassMethod QueryBillIUDInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBillIUDInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      ZhaoZW
/// CreatDate：    2019-09-20 
/// update   ：    2019-09-24    guoyunlong
/// Description:   查询一段时间内未上传成功的电子票据信息
/// Input：        IUDStDate ->开始时间    IUDEdDate->结束时间   IUDAdmType->票据类型 Hosital:院区,RegNo:登记号
/// Output：       IUDBusNo : 业务流水号 IUDCreatAmt : 开票金额 IUDBillBatchCode : 电子票据代码
/// 			   IUDBillBatchNo : 电子票据号码 IUDPayAdmType : 票据类型 IUDUser : 上传人
/// 			   IUDDate : 上传日期 IUDUplodeFlag : 上传标志,IUDCreatDate 开票日期 
///                IUDCreatTime:  开票时间 
/// Debug:	d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvPageInfoCtl","QueryNotUPLoadInfo","30/11/2019","30/11/2019","OP","all","")
Query QueryNotUPLoadInfo(IUDStDate As %String, IUDEdDate As %String, IUDAdmType As %String = "", Hosital As %String = "", RegNo As %String = "") As %Query(ROWSPEC = "IUDBusNo:%String,IUDCreatAmt:%String,IUDBillBatchCode:%String,IUDBillBatchNo:%String,IUDPayAdmType:%String,USRName:%String,IUDUplodeFlag:%String,IUDHospDr:%String,IUDDate:%String,IUDTime:%String,IUDBillBatchStatus:%String,IUDBillisScarlet:%String,IUDInvDr:%String,PrintType:%String,InvStyle:%String,PrintFlag:%String,RateStatus:%String,PatNo:%String,PatName:%String")
{
}

ClassMethod QueryNotUPLoadInfoExecute(ByRef qHandle As %Binary, IUDStDate As %String, IUDEdDate As %String, IUDAdmType As %String = "", Hosital As %String = "", RegNo As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    s ^chche("QueryNotUPLoadInfo")=IUDStDate_","_IUDEdDate_","_IUDAdmType_","_Hosital_","_RegNo
    q:(IUDStDate="")||(IUDEdDate="") $$$OK
    s IUDStDate=##class(websys.Conversions).DateHtmlToLogical(IUDStDate)
    s IUDEdDate=##class(websys.Conversions).DateHtmlToLogical(IUDEdDate)
    ;s IUDStDate=$zdh(IUDStDate,4)
     ;s IUDEdDate=$zdh(IUDEdDate,4)	
	;b //获取发票业务信息
	set OutStr=##class(BILL.EINV.BL.EInvoiceLogic).GetNotINVInfo(IUDStDate,IUDEdDate)
	set PIDKey=$p(OutStr,"^",1)
	//遍历global数据,根据不同的业务类型调用票据监管业务进行票据补交易
	set PayAdmType=""
	for  set PayAdmType=$o(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType)) quit:(PayAdmType="")  do
	.q:(IUDAdmType'="")&&(IUDAdmType'=PayAdmType)   ;过滤票据类型
	.set HISPrtRowID="0",IUDID=""
	.for  set HISPrtRowID=$o(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType,HISPrtRowID))  quit:(HISPrtRowID="")  do
    ..for  s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey",PayAdmType,HISPrtRowID,"E",IUDID)) q:IUDID=""  d
    ...s ObjIUDInfo=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID)
    ...s IUDUplodeFlag=ObjIUDInfo.IUDUplodeFlag  			   ;上传标志（Y:上传成功，N:上传失败）
    ...q:IUDUplodeFlag'="N"                                     ;过滤已经上传的
    ...s IUDPayAdmType=ObjIUDInfo.IUDPayAdmType  				;票据类型
    ...;q:(IUDPayAdmType'="")&&(IUDPayAdmType'=IUDAdmType)         ;过滤不满足的票据类型
    ...s IUDBusNo=ObjIUDInfo.IUDBusNo    						;业务流水号
    ...s IUDCreatAmt=ObjIUDInfo.IUDCreatAmt 						;开票金额
    ...s IUDBillBatchCode=ObjIUDInfo.IUDBillBatchCode 		    ;电子票据代码
    ...s IUDBillBatchNo=ObjIUDInfo.IUDBillBatchNo				;电子票据号码
    ...s IUDUser=ObjIUDInfo.IUDUser                				 ;指向SS_User
    ...s USRName=$p($g(^SSU("SSUSR",IUDUser)),"^",2)			     ;上传人
    ...s IUDHospDr=ObjIUDInfo.IUDHospDr                           ;院区指针
    ...;q:(Hosital'="")&&(Hosital'=IUDHospDr)
    ...s IUDDate=$zd(ObjIUDInfo.IUDDate,3)              ;开票日期  
    ...s IUDTime=$zt(ObjIUDInfo.IUDTime)                ;开票时间 
    ...s IUDBillBatchStatus=ObjIUDInfo.IUDBillBatchStatus         ;电子票据状态(状态：1正常，2作废)
    ...s IUDBillisScarlet=ObjIUDInfo.IUDBillisScarlet             ;是否已开红票  
    ...s IUDInvDr=ObjIUDInfo.IUDInvDr                             ;发票表指针
    ...s PrintType= ObjIUDInfo.IUDPrintType                       ;票据模式 E-电子票据 P-纸质发票
    ...s InvStyle=ObjIUDInfo.IUDStyle	                		; 票据种类 V-增值税发票 C-普票
    ...s PrintFlag=ObjIUDInfo.IUDPrintFlag				        ;是否打印纸质票据(0未打印，1已打印)
	...s RateStatus=ObjIUDInfo.IUDRateStatus			        ;纸质生成状态(0未生成、1已生成、2失败 )
	...s PatBaseInfo=##class(BILL.EINV.BL.COM.InvPageInfoCtl).GetBaseInfoByPrtIDandAdmType(IUDInvDr,IUDPayAdmType)
	...i $p(PatBaseInfo,"!",1)="0" s PatNo=$p($p(PatBaseInfo,"!",2),"^",1),PatName=$p($p(PatBaseInfo,"!",2),"^",2)
	...i (RegNo'="")&&($l(RegNo)'=10) d
	....f num=$l(RegNo):1:9 d
	.....s RegNo="0"_RegNo
	...i (PatNo'="")&&($l(PatNo)'=10) d
	....f num=$l(PatNo):1:9 d
	.....s PatNo="0"_PatNo
	...q:(PatNo'=RegNo)&&(RegNo'="")
    ...d OutputRow
    
    kill ^TMPERREINV("NotSuccssUpdetails",PIDKey)
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(IUDBusNo,IUDCreatAmt,IUDBillBatchCode,IUDBillBatchNo,IUDPayAdmType,USRName,IUDUplodeFlag,IUDHospDr,IUDDate,IUDTime,IUDBillBatchStatus,IUDBillisScarlet,IUDInvDr,PrintType,InvStyle,PrintFlag,RateStatus,PatNo,PatName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind_1
	q
}

ClassMethod QueryNotUPLoadInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNotUPLoadInfoExecute ]
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

ClassMethod QueryNotUPLoadInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNotUPLoadInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 功能 ：  根据发票ID和票据类型获取基本信息,获取原发票表ID
/// 入参 ：  PrtRowid 发票表ID   AdmType：票据业务类型
/// 出参 ：  成功  0!PatNO登记号^PatName姓名
///          失败  -1
/// 编写者:   guoyunlong
/// 时间  :   2019-09-26
/// Debug :  w ##class(BILL.EINV.BL.COM.InvPageInfoCtl).GetBaseInfoByPrtIDandAdmType("","")
ClassMethod GetBaseInfoByPrtIDandAdmType(PrtRowid As %String, AdmType As %String)
{
	s rtn="-1"
	q:(PrtRowid="")||(AdmType="") rtn
	s PatNO="",PatName="",PRTPAPMIDR="",InitRowid=""
	i (AdmType="OP")||(AdmType="REG") d
	.;门诊发票表
	.s InvPrtInfo=$g(^DHCINVPRT(PrtRowid))
	.s PRTPAPMIDR=$p($g(^DHCINVPRT(PrtRowid)),"^",15)    ;基本信息表ID
	.s InvStr=##class(BILL.EINV.BL.COM.Common).GetOPINVInfo(PrtRowid)     ;门诊发票ID
	.s InitRowid=$p(InvStr,"&",2)
	i AdmType="IP" d
	.;住院发票表
	.s InvPrtInfo=$g(^DHCINVPRTZY(PrtRowid))
	.s PRTAdm=$p($g(^DHCINVPRTZY(PrtRowid)),"^",4)  ;paadm表ID
	.s PRTPAPMIDR=$p($g(^PAADM(PRTAdm)),"^",1)    ;;基本信息表ID
	.s InvStr=##class(BILL.EINV.BL.COM.Common).GetIPINVInfo(PrtRowid)
	.s InitRowid=$p(InvStr,"&",2)
	i AdmType="DEP" d
	.;住院预交金
	.s InvPrtInfo=$g(^DHCSFPRINTDETAIL(PrtRowid))
	.;s sprtadmdr=$p($g(^DHCSFPRINTDETAIL(PrtRowid)),"^",4)  ;paadm表ID
	.s PRTAdm=$p($g(^DHCSFPRINTDETAIL(PrtRowid)),"^",4)  ;paadm表ID		;add by xubaobao 2020 05 11
	.s PRTPAPMIDR=$p($g(^PAADM(PRTAdm)),"^",1)            ;;基本信息表ID
	.s InvStr=##class(BILL.EINV.BL.COM.Common).GetDEPDepInfo(PrtRowid)
	.s InitRowid=$p(InvStr,"&",2)
	i AdmType="API" d
	.;集中打印发票表
	.s InvPrtInfo=$g(^DHCINVPRTAP(PrtRowid))
	.s PRTPAPMIDR=$p($g(^DHCINVPRTAP(PrtRowid)),"^",11)     ;基本信息表ID
	.s InvStr=##class(BILL.EINV.BL.COM.Common).GetAPIINVInfo(PrtRowid)
	.s InitRowid=$p(InvStr,"&",2)
	i AdmType="PE" d
	.;体检发发票表
	.s InvPrtInfo=$g(^DHCPEINVPRT(PrtRowid))
	.s admDr=$p($g(^DHCPEINVPRT(PrtRowid)),"^",2) 
	.s PRTPAPMIDR=$p($g(^PAADM(admDr)),"^",1)
	.;s PRTPAPMIDR=$p($g(^DHCPEINVPRT(PrtRowid)),"^",5)  ;;基本信息表ID
	.s InvStr=##class(BILL.EINV.BL.COM.Common).GetPEINVInfo(PrtRowid)
	.s InitRowid=$p(InvStr,"&",2)
	i AdmType="CF" d
	.;卡发票表
	.s InvPrtInfo=$g(^DHCCARDINVPRT(PrtRowid))
	.s PRTPAPMIDR=$p($g(^DHCCARDINVPRT(PrtRowid)),"^",1) 
	.s InvStr=##class(BILL.EINV.BL.COM.Common).GetCFINVInfo(PrtRowid)
	.s InitRowid=$p(InvStr,"&",2)
	;基本信息表ID不为空时，取基本信息
	i PRTPAPMIDR'="" d
	.s PapmiInfo=##class(BILL.EINV.BL.COM.Common).GetPatinfo(PRTPAPMIDR)
	.s PatNO=$p(PapmiInfo,"^",1)                  ;登记号   
	.s PatName=$p(PapmiInfo,"^",2)                ;姓名
	.s rtn="0"_"!"_PatNO_"^"_PatName_"^"_InitRowid
	q rtn
}

/// 功能：电子发票补上传
/// 入参：dataStr(AdmType就诊类型^PrtRowid发票ID)
/// 出参：0-成功  其他-失败
/// 编写：guoyunlong
/// 时间：2019-10-09
/// Debug :  w ##class(BILL.EINV.BL.COM.InvPageInfoCtl).DealData("")
ClassMethod DealData(dataStr As %String)
{
   
    s Rtn="-1"
	q:$l(dataStr,"^")<2 Rtn
	s AdmType=$p(dataStr,"^",1)      ;就诊类型
	s PrtRowid=$p(dataStr,"^",2)     ;发票ID
	s InitRowid=$p(dataStr,"^",3)    ;原发票ID
	s PathCode=$p(dataStr,"^",4)     ;;PathCode
	s ExpStr=$p(dataStr,"^",5)       ;扩展串
	;s OutStr=##class(BILL.EINV.BL.COM.InvPageInfoCtl).GetBaseInfoByPrtIDandAdmType(PrtRowid,AdmType)
	;q:$p(OutStr,"!",1)'="0" Rtn
	;s InitRowid=$p($p(OutStr,"!",2),"^",3)   ;原发票ID
	s RtnStr=##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill(AdmType,PrtRowid,InitRowid,PathCode,ExpStr)
	;成功标志0^错误信息
	i $p(RtnStr,"^",1)="0" d
    . s Rtn="0"
    q Rtn
}

/// 功能说明：通过页面调用票据开具的业务方法
/// 入参说明：dataStr --> 票据开具所需的参数
///           Index   --> 页面上数据所在的行
/// 返 回 值：开具是否成功的json数据
/// 修改履历：董科锋 2019 12 19  新做成
/// w ##class(BILL.EINV.BL.COM.InvPageInfoCtl).InvocieBill("REG^232647^^","2")
ClassMethod InvocieBill(dataStr As %String, Index As %String)
{
	s status="-1"
	s Data=""
	s ErrMsg=""
	
	;q:$l(dataStr,"^")<2 Rtn
	s AdmType=$p(dataStr,"|",1)      ;业务类型
	s PrtRowid=$p(dataStr,"|",2)     ;发票ID
	s InitRowid=$p(dataStr,"|",3)    ;原发票ID
	s PathCode=$p(dataStr,"|",4)     ;;PathCode
	s ExpStr=$p(dataStr,"|",5)       ;扩展串

	s RtnStr=##class(BILL.EINV.BL.EInvoiceLogic).InvocieBill(AdmType,PrtRowid,InitRowid,PathCode,ExpStr)   ;返回值格式：成功标志0^错误信息
	b ;dd
	s status=$p(RtnStr, "^", 1)
	;s ErrMsg=$p(RtnStr, "^", 2)   ////如果错误信息里面包含^导致截取错误信息不全
	s ErrMsg=$e(RtnStr, 3, $l(RtnStr))   ;add 2023-02-13    
	i status="0" d
	.s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR", AdmType, PrtRowid, ""), -1)
	.q:IUDID=""
	.s RtnFlg=..GetInvViewInfoByTradDr(IUDID, .Data)
	.q:RtnFlg'="0"
	
	i (status="0")&&($isobject(Data)=0){
		s status="-1"
		s ErrMsg="开票成功,但是刷新页面数据失败!"
	}
    
    
	s RtnObj=##class(%ArrayOfDataTypes).%New()
	d RtnObj.SetAt(status, "status")
	d RtnObj.SetAt(ErrMsg, "info")
	d RtnObj.SetAt(Data, "TradeData")
	d RtnObj.SetAt(Index, "DataIndex")   ;数据在页面上的索引序号
	
	q ##class(ext.util.JsonObject).ObjToJson(RtnObj)
}

/// 功能说明：获取最的有效的业务流水信息
/// 修改履历：董科锋 2020-03-16 新做成
ClassMethod GetActiveUpdetailID(Date As %Integer, IUDPayAdmType As %String, IUDInvDr As %String) As %String
{
	s RtnIUDID=""
	s EInvFlg=""
	
	s IUDID=""
	f  s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IdxtDateAndInvDr",Date,IUDPayAdmType,IUDInvDr, RtnIUDID), -1) q:((IUDID="")||(EInvFlg'=""))  d
	.s objUpdetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID)
	.s RtnIUDID=IUDID
	.s EInvFlg=objUpdetail.EInvFlg
	
	q RtnIUDID
}

/// 功能说明： 未开具电子票据的结算记录列表信息查询
/// 入参说明： IUDStDate  -->开始时间
///            IUDEdDate  -->结束时间
///            IUDAdmType -->业务类型
///            Extstr     -->扩展参数(院区^登记号^开票标志)
/// Modify By suhuide at 2021-12-27  增加登记号查询条件
/// 输出说明:  登记号:患者姓名:发票金额:业务类型:收退标志:his发票Dr:his原发票Dr:收费日期:收费员:就诊科室:就诊院区:就诊日期
/// Debug:	d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvPageInfoCtl","QueryNotEinvDivInfo","2019-01-01","2019-12-01","","")
Query QueryNotEinvDivInfo(IUDStDate As %String, IUDEdDate As %String, IUDAdmType As %String = "", Extstr As %String = "") As %Query(ROWSPEC = "PatRegNo:%String,PatName:%String,InvprtAmount:%String,LocgicType:%String,SFTFFlg:%String,Invprtrowid:%String,InitRowid:%String,SFDate:%String,SFTime:%String,SFUserDr:%String,SFUserName:%String,AdmLocName:%String,AdmHospitalDr:%String,AdmHospitalNM:%String,EInvFlg:%String,EInvCode:%String,EInvSeriNo:%String,BusinessDr:%String")
{
}

ClassMethod QueryNotEinvDivInfoExecute(ByRef qHandle As %Binary, IUDStDate As %String, IUDEdDate As %String, IUDAdmType As %String = "", Extstr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    set ind=1
    set ^Tempchche("QueryNotEinvDivInfo")=$lb(IUDStDate,IUDEdDate,IUDAdmType,Extstr)
    
    quit:(IUDStDate="")||(IUDEdDate="") $$$OK
    set IUDStDate=##class(websys.Conversions).DateHtmlToLogical(IUDStDate)
    set IUDEdDate=##class(websys.Conversions).DateHtmlToLogical(IUDEdDate)
    
    // 查询条件参数获取
    set:IUDAdmType="ALL" IUDAdmType=""     ;业务类型
    set HospitalDrPam=$p(Extstr, "^", 1)   ;院区编码
    set:HospitalDrPam="ALL" HospitalDrPam=""
    set PatRegNoPam=$p(Extstr, "^", 2)     ;登记号
    set:PatRegNoPam'="" PatRegNoPam=..PatRegNoFormat(PatRegNoPam, 10)  //格式化为10位的长度
    set KPFlg=$p(Extstr, "^", 3)           ;开票标志 1 已开 0 未开 空代表全部
    set:KPFlg="ALL" KPFlg=""
	
	//获取各个业务下未开电子票据的his结算记录信息
	set OutStr=##class(BILL.EINV.BL.EInvoiceLogic).GetNotINVInfo(IUDStDate,IUDEdDate,PatRegNoPam)
	set PIDKey=$p(OutStr,"^",1)
	
	set AllInvInfoMap=""
	kill AllInvInfoMap
	
	//遍历global数据,根据不同的业务类型调用票据监管业务进行票据补交易
	if (KPFlg="")||(KPFlg="0") {   //未开票据信息查询
		set PayAdmType=""
		for  set PayAdmType=$o(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType)) quit:(PayAdmType="")  do
		.quit:(IUDAdmType'="")&&(IUDAdmType'=PayAdmType)   ;过滤票据类型
		.set InvprtrowidTmp=""
		.for  set InvprtrowidTmp=$o(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType, InvprtrowidTmp)) quit:(InvprtrowidTmp="")  do
		..set outInfo=$g(^TMPERREINV("NotSuccssUpdetails",PIDKey,PayAdmType, InvprtrowidTmp))
		..set ExpStrTmp=$p(outInfo, "&", 1)  ;1操作员ID^2安全组ID^3院区ID^4科室ID^5发票金额^6收费日期^7收费时间
		..set InitRowid=$p(outInfo, "&", 2)  ;原发票Dr
		..//获取基本信息和就诊信息
		..set ObjPatBaseInfo =##class(BILL.EINV.DTO.COM.PatBaseInfo).%New()   ;基本信息对象
		..set ObjPatAdmInfo =##class(BILL.EINV.DTO.COM.PatAdmInfo).%New()     ;就诊信息对象
		..set PatRtn=##class(BILL.EINV.BL.COM.Common).GetPatInfoByInv(PayAdmType, InvprtrowidTmp, .ObjPatBaseInfo, .ObjPatAdmInfo)  ;根据发票票信息获取患者基本信息及就诊信息
		..quit:PatRtn'="0"
		
		..set PatRegNo = ObjPatBaseInfo.PAPMINO                    ;登记号
		..set:PatRegNo'="" PatRegNo=..PatRegNoFormat(PatRegNo, 10)  //格式化为10位的长度
		..quit:(PatRegNoPam'="")&&(PatRegNo'=PatRegNoPam)
		
		..set PatName = ObjPatBaseInfo.PatName                     ;患者姓名
		..set InvprtAmount = +$p(ExpStrTmp, "^", 5)                ;发票金额
		..set LocgicType = PayAdmType                              ;业务类型
		..set SFTFFlg = "收费"                                     ;收退标志
		..set:InitRowid'="" SFTFFlg = "退费"
		..set Invprtrowid = InvprtrowidTmp                         ;his发票Dr
		..set InitRowid = InitRowid                                ;his原发票Dr
		..set SFDate = $p(ExpStrTmp, "^", 6)                       ;收费日期
		..set SFTime = $p(ExpStrTmp, "^", 7)                       ;收费时间
		..set SFUserDr = $p(ExpStrTmp, "^", 1)                     ;收费员Dr
		..set SFUserName = ""                                      ;收费员名称
		..if SFUserDr'="" do
		...set SFUserName=$p($g(^SSU("SSUSR",SFUserDr)), "^", 2)
		
		..set AdmLocName = ""                                      ;就诊科室
		..set AdmLocDr=$p(ExpStrTmp, "^", 4)                       ;就诊科室Dr
		..if AdmLocDr'="" do
		...set AdmLocName=$p($g(^CTLOC(AdmLocDr)), "^", 2)
		..set AdmHospitalDr = $p(ExpStrTmp, "^", 3)                ;就诊院区Dr
		..quit:(HospitalDrPam'="")&&(HospitalDrPam'=AdmHospitalDr)          //根据就诊院区过滤
		..if AdmHospitalDr'="" do
		...set AdmHospitalNM = $p($g(^CT("HOSP",AdmHospitalDr)), "^", 2)  ;就诊院区名称
		
		..set EInvFlg="0"               ;开票标志
		..set EInvCode=""               ;票据代码
		..set EInvSeriNo=""             ;票据号码
		..set BusinessDr=""             ;业务表id
		
		..set InvInfoKey=LocgicType_"||"_Invprtrowid
		..quit:$d(AllInvInfoMap(InvInfoKey))'=0        ;已经存在的数据不再输出
		..set AllInvInfoMap(InvInfoKey)=""
		..do OutputRow
		
		kill ^TMPERREINV("NotSuccssUpdetails",PIDKey)
	}
	
	//已开票据查询  注意在上边集合中存在的数据 后续查询结果中不能再输出防止重复
	if (KPFlg="")||(KPFlg="1") {
		//需要计算业务表中 开票标志
		//开票时间按照发票结算时间统计Index IdxPrtDate On IUDPrtDate As Exact;
		for Date=IUDStDate:1:IUDEdDate  do
		.set IUDPayAdmType="",IUDPrintType="",IUDInvDr=""
		.for  set IUDPayAdmType=$o(^BILL.EINV.PO.InvUpDetailsI("IdxtDateAndInvDr",Date,IUDPayAdmType)) quit:IUDPayAdmType=""  do
		..quit:(IUDAdmType'="")&&(IUDAdmType'=IUDPayAdmType)            ;过滤票据类型
		..for  set IUDInvDr=$o(^BILL.EINV.PO.InvUpDetailsI("IdxtDateAndInvDr",Date,IUDPayAdmType,IUDInvDr)) quit:IUDInvDr=""  do
		...set IUDID=..GetActiveUpdetailID(Date,IUDPayAdmType,IUDInvDr)
		...set InvInfoKeyTmp=IUDPayAdmType_"||"_IUDInvDr 
		...quit:$d(AllInvInfoMap(InvInfoKeyTmp))'=0         ;已经存在的数据不再输出
		...set ObjIUDInfo=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID)
		...set EInvShowView = ##class(BILL.EINV.DTO.COM.EInvShowView).%New()
		...set DataRtn=..GetInvViewInfoByTradDr(IUDID, .EInvShowView, ObjIUDInfo)
		...quit:DataRtn'="0"
		...quit:((KPFlg="1")&&(EInvShowView.EInvFlg'="1"))  ;已上传标志判断
		...set PatRegNo= EInvShowView.PatRegNo
		...set PatName= EInvShowView.PatName
		...set InvprtAmount= EInvShowView.InvprtAmount
		...set LocgicType= EInvShowView.LocgicType
		...set SFTFFlg= EInvShowView.SFTFFlg
		...set Invprtrowid= EInvShowView.Invprtrowid
		...set InitRowid= EInvShowView.InitRowid
		...set SFDate= EInvShowView.SFDate
		...set SFTime= EInvShowView.SFTime
		...set SFUserDr= EInvShowView.SFUserDr
		...set SFUserName= EInvShowView.SFUserName
		...set AdmLocName= EInvShowView.AdmLocName
		...set AdmHospitalDr= EInvShowView.AdmHospitalDr
		...set AdmHospitalNM= EInvShowView.AdmHospitalNM
		...set EInvFlg= EInvShowView.EInvFlg
		...set EInvCode= EInvShowView.EInvCode
		...set EInvSeriNo= EInvShowView.EInvSeriNo
		...set BusinessDr= EInvShowView.BusinessDr
		
		...set:PatRegNo'="" PatRegNo=..PatRegNoFormat(PatRegNo, 10)       ;格式化为10位的长度
		...quit:(PatRegNoPam'="")&&(PatRegNo'=PatRegNoPam)                 ;根据登记号过滤
		...quit:(HospitalDrPam'="")&&(HospitalDrPam'=AdmHospitalDr)        ;根据就诊院区过滤
		...do OutputRow
		
	} 
	
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(PatRegNo,PatName,InvprtAmount,LocgicType,SFTFFlg,Invprtrowid,InitRowid,SFDate,SFTime,SFUserDr,SFUserName,AdmLocName,AdmHospitalDr,AdmHospitalNM,EInvFlg,EInvCode,EInvSeriNo,BusinessDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryNotEinvDivInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryNotUPLoadInfoExecute ]
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

ClassMethod QueryNotEinvDivInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryNotUPLoadInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 功能说明：根据交易表Dr获取页面显示逻辑对象数据
/// 入参说明：IUDID         --> 交易表Dr
///           EInvShowView  --> 页面展示对象
///           ObjIUDInfo    --> 交易对象数据
/// 返 回 值：0 成功 其他值代表失败
/// 修改履历：董科锋 2019 12 19 新做成
ClassMethod GetInvViewInfoByTradDr(IUDID As %String, ByRef EInvShowView As BILL.EINV.DTO.COM.EInvShowView, ObjIUDInfo As BILL.EINV.PO.InvUpDetails = "") As %String
{
	s RtnFlg="-1"
	q:IUDID="" RtnFlg
	
	if ($isobject(EInvShowView)=0){
		s ObjIUDInfo=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID)
	}
	q:$isobject(ObjIUDInfo)=0 RtnFlg
	
	if ($isobject(EInvShowView)=0){
		s EInvShowView=##class(BILL.EINV.DTO.COM.EInvShowView).%New()
	}
	
	s IUDPayAdmType=ObjIUDInfo.IUDPayAdmType                   ;票据类型
	s Invprtrowid=ObjIUDInfo.IUDInvDr                          ;发票表指针
	;s PrintType= ObjIUDInfo.IUDPrintType                       ;票据模式 E-电子票据 P-纸质发票
	;q:(IUDAdmType'="")&&(IUDAdmType'=IUDPayAdmType)          ;过滤票据类型				
                                     ;过滤已经上传的
	;登记号查询条件
	//获取基本信息和就诊信息
	s ObjPatBaseInfo =##class(BILL.EINV.DTO.COM.PatBaseInfo).%New()   ;基本信息对象
	s ObjPatAdmInfo =##class(BILL.EINV.DTO.COM.PatAdmInfo).%New()     ;就诊信息对象
	s PatRtn=##class(BILL.EINV.BL.COM.Common).GetPatInfoByInv(IUDPayAdmType, Invprtrowid, .ObjPatBaseInfo, .ObjPatAdmInfo)  ;根据发票票信息获取患者基本信息及就诊信息
	q:PatRtn'="0" RtnFlg
	s PatRegNo = ObjPatBaseInfo.PAPMINO                    ;登记号
	s:PatRegNo'="" PatRegNo=..PatRegNoFormat(PatRegNo, 10)  //格式化为10位的长度
	
	s InvprtAmount=ObjIUDInfo.IUDCreatAmt 					 ;开票金额
	s EInvCode=ObjIUDInfo.IUDBillBatchCode 		             ;票据代码
	s EInvSeriNo=ObjIUDInfo.IUDBillBatchNo				     ;票据号码
	s SFUserDr=ObjIUDInfo.IUDUser                			 ;指向SS_User
	s SFUserName=$p($g(^SSU("SSUSR",SFUserDr)),"^",2)	     ;上传人
	s AdmHospitalDr=ObjIUDInfo.IUDHospDr                         ;院区指针
	;q:(HospitalDrPam'="")&&(HospitalDrPam'=AdmHospitalDr)        ;根据就诊院区过滤
	s AdmHospitalNM=""
	i AdmHospitalDr'="" d
	.s AdmHospitalNM = $p($g(^CT("HOSP",AdmHospitalDr)), "^", 2)  ;就诊院区名称
	s IUDDate=$zd(ObjIUDInfo.IUDDate,3)                      ;开票日期  
	s IUDTime=$zt(ObjIUDInfo.IUDTime)                        ;开票时间 
	s PatName=ObjPatBaseInfo.PatName                         ;姓名  
	s LocgicType= IUDPayAdmType	
	s AdmLocName=""
	s EInvFlg="0"                                          ;就诊科室名称
	s EInvFlgTmp=ObjIUDInfo.EInvFlg  ;票据标志 I 正常开具 B 被冲红 S 冲红 H 已换开 A 作废
	;s:EInvFlgTmp="I" EInvFlg="1"               ;开票标志
	s BusinessDr=IUDID             ;业务表id
	s InitRowid=ObjIUDInfo.OrgIUDInvDr
	i InitRowid="" d
	.s InStr=##class(BILL.EINV.BL.COM.InvPageInfoCtl).GetBaseInfoByPrtIDandAdmType(Invprtrowid,IUDPayAdmType)
	.s InitRowid=$p(InStr,"^",3)
	i InitRowid'="" d
	.s:EInvFlgTmp="S" EInvFlg="1"
	e  d
	.s:((EInvFlgTmp="I")||(EInvFlgTmp="B")||(EInvFlgTmp="H")) EInvFlg="1"
	
	s SFTFFlg = "收费"                                     ;收退标志
	s:InitRowid'="" SFTFFlg = "退费"
	s SFDate=IUDDate                        ;开票日期
	s SFTime=IUDTime                        ;开票时间
	
	s EInvShowView.PatRegNo= PatRegNo
	s EInvShowView.PatName= PatName
	s EInvShowView.InvprtAmount= InvprtAmount
	s EInvShowView.LocgicType= LocgicType
	s EInvShowView.SFTFFlg= SFTFFlg
	s EInvShowView.Invprtrowid= Invprtrowid
	s EInvShowView.InitRowid= InitRowid
	s EInvShowView.SFDate= SFDate
	s EInvShowView.SFTime= SFTime
	s EInvShowView.SFUserDr= SFUserDr
	s EInvShowView.SFUserName= SFUserName
	s EInvShowView.AdmLocName= AdmLocName
	s EInvShowView.AdmHospitalDr= AdmHospitalDr
	s EInvShowView.AdmHospitalNM= AdmHospitalNM
	s EInvShowView.EInvFlg= EInvFlg
	s EInvShowView.EInvCode= EInvCode
	s EInvShowView.EInvSeriNo= EInvSeriNo
	s EInvShowView.BusinessDr= BusinessDr
	
	s RtnFlg="0"
	q RtnFlg
}

/// 功能说明：患者登记号格式化为固定的长度
/// w ##class(BILL.EINV.BL.COM.InvPageInfoCtl).PatRegNoFormat("1000")
/// w ##class(BILL.EINV.BL.COM.InvPageInfoCtl).PatRegNoFormat("12345678901")
ClassMethod PatRegNoFormat(RegNoIn As %String, MaxLen As %Integer = 10) As %String
{
	s RtnRegNo=""
	
	s PreString=""
	f index=1:1:MaxLen d
	.s PreString=PreString_"0"
	
	if $l(RegNoIn)>MaxLen {
		s RtnRegNo=RegNoIn
	}else{
		s RegNoTmp=PreString_RegNoIn
		s LenTmp=$l(RegNoTmp)
		s RtnRegNo=$e(RegNoTmp, (LenTmp-MaxLen)+1, LenTmp)
	}
	
	q RtnRegNo
}

/// Debug:  d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvPageInfoCtl","QueryGetHospital","")
Query QueryGetHospital(HospDr As %String = "") As %Query(ROWSPEC = "HospitalDr:%String,HospitalNo:%String,HospitalNM:%String")
{
}

ClassMethod QueryGetHospitalExecute(ByRef qHandle As %Binary, HospDr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    s ind=1
    ///以上不用动
    
    s HospitalDr="ALL"
    s HospitalNo="ALL"
    s HospitalNM="全部"
    d OutputRow
    
    s ID=0
    f  s ID=$o(^CT("HOSP",ID)) q:ID=""  d
    .q:(HospDr'="")&&(HospDr'=ID)
    .s HospitalInfo=$g(^CT("HOSP",ID)) ;获取数据串
    .s HospitalDr=ID
    .s HospitalNo=$p(HospitalInfo, "^", 1)   //医院编码
    .s HospitalNM=$p(HospitalInfo, "^", 2)   //医院名称
    
    .d OutputRow
    //以下不用动
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(HospitalDr, HospitalNo, HospitalNM)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryGetHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryDicDataInfoExecute ]
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

ClassMethod QueryGetHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryDicDataInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 通过发票ID和就诊类型获取最新一条数据
/// 入参：AdmType ->就诊类型
///       PrtRowID  ->发票ID
/// 出参：Json串  
/// w ##class(BILL.EINV.BL.COM.InvPageInfoCtl).GetUpDetailsInfoById("","")
ClassMethod GetUpDetailsInfoById(AdmType As %String, PrtRowID As %String) As %String
{
    s rtn="-1"
	q:(AdmType="")||(PrtRowID="") rtn
	q:'$d(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR",AdmType,PrtRowID)) rtn
	s Id=$o(^BILL.EINV.PO.InvUpDetailsI("IdxInvDR",AdmType,PrtRowID,""),-1)
	q:Id="" rtn
	s ObjIUDInfo=##class(BILL.EINV.PO.InvUpDetails).%OpenId(Id)
	s PrintType= ObjIUDInfo.IUDPrintType                       ;票据模式 E-电子票据 P-纸质发票
	s EInvCode=ObjIUDInfo.IUDBillBatchCode 		     ;票据代码
    s EInvSeriNo=ObjIUDInfo.IUDBillBatchNo				 ;票据号码
    s EInvFlg="1"               ;开票标志
    s SFDate=$zd(ObjIUDInfo.IUDDate,3)                        ;开票日期
	s SFTime=$zt(ObjIUDInfo.IUDTime)                          ;开票时间
	s rtnInfo="{""result"":""00000"",""Data"":{""EInvCode"":"""_EInvCode_""",""EInvSeriNo"":"""_EInvSeriNo_""",""PrintType"":"""_PrintType_""",""EInvFlg"":"""_EInvFlg_""",""SFDate"":"""_SFDate_""",""SFTime"":"""_SFTime_"""}}"
	q rtnInfo
}

/// 功能说明：根据登记号,开始日期和结束日期查询票据信息
ClassMethod GetInvByRegNo(PapmiNo As %String, StDate As %String, EndDate As %String) As %String
{
	set StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	set EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	;set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime)
	;set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime)

	set PIDKey=$i(^TMPPatAllEINV("PatInvInfos"))
	kill ^TMPPatAllEINV("PatInvInfos",PIDKey)
	set Invindex=0
	
	q:$d(^PAPERi("PAPMI_PatNo",PapmiNo))=0 Invindex_"^"_PIDKey
	s PatmasID=""
	s PatmasID=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PatmasID))
	q:PatmasID="" Invindex_"^"_PIDKey
	
	//门诊住院票据获取
	s AdmType=""
	f  s AdmType=$o(^PAPERdr(PatmasID,"ADM",AdmType),-1) q:AdmType=""  d
	.s AdmDr=""
	.f  s AdmDr=$o(^PAPERdr(PatmasID,"ADM",AdmType, AdmDr),-1) q:AdmDr=""  d
	..i AdmType="I" d  //住院
	...s IpInvNums=..GetIPInvByAdmDr(AdmDr, StDate, EndDate, PIDKey, .Invindex)   ;住院发票获取
	
	..i ((AdmType="O")||(AdmType="E")) d  //门诊、急诊
	...s OpInvNums=..GetOPInvByAdmDr(AdmDr, StDate, EndDate, PIDKey, .Invindex)   ;门诊发票获取
	
	
	
	q Invindex_"^"_PIDKey
}

/// 根据就诊号查询住院票据
ClassMethod GetIPInvByAdmDr(Admdr As %String, StDate As %String, EndDate As %String, DataPIDKey As %String, ByRef IndexNo As %Integer) As %String
{
	s RtnNum=0
	
	s InvDr=""
	f  s InvDr=$o(^DHCINVPRTZY("ADM", Admdr, InvDr), -1) q:InvDr=""  d
	.s prtDate=$p(^DHCINVPRTZY(InvDr),"^",2)
	.s prtTime=$p(^DHCINVPRTZY(InvDr),"^",3)
	.q:(prtDate<StDate)||(prtDate>EndDate)
	.s IndexNo=IndexNo+1
	.s ^TMPPatAllEINV("PatInvInfos",PIDKey, IndexNo)=InvDr_"^"_"IP"
	.s RtnNum=RtnNum+1
	
	q RtnNum
}

/// 根据就诊号查询门诊票据
ClassMethod GetOPInvByAdmDr(Admdr As %String, StDate As %String, EndDate As %String, DataPIDKey As %String, ByRef IndexNo As %Integer) As %String
{
	s RtnNum=0
	
	s ConDr=""
	f  s ConDr=$o(^DHCBCI(0, "ADM", Admdr, ConDr), -1) q:ConDr=""  d
	.s InvDr=$p($g(^DHCBCI(ConDr)),"^",1)
	.s prtDate=$p(^DHCINVPRT(InvDr),"^",5)
	.s prtTime=$p(^DHCINVPRT(InvDr),"^",20)
	.q:(prtDate<StDate)||(prtDate>EndDate)
	.s IndexNo=IndexNo+1
	.s ^TMPPatAllEINV("PatInvInfos",PIDKey, IndexNo)=InvDr_"^"_"OP"
	.s RtnNum=RtnNum+1
	
	q RtnNum
}

/// 功能说明：根据登记号获取就诊Dr
/// 入参说明：PapmiNo --> 登记号
/// 返 回 值：就诊号
ClassMethod GetAdmDrByRegNo(PapmiNo As %String) As %String
{
	s AdmDr=""
	
	q:$d(^PAPERi("PAPMI_PatNo",PapmiNo))=0 ""
	s PatmasID=""
	s PatmasID=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PatmasID))
	q:PatmasID="" AdmDr
	s AdmDr=$o(^PAPERdr(PatmasID,"ADM","I",""),-1)
	
	q AdmDr
}

/// 功能说明根据病人ID获取发票信息
/// xubaobao 2020 07 24
/// 入参：Papmi		病人ID
/// 	  PrtInvType  业务类型(IP:住院发票,OP:门诊发票,API:集中打印发票,PE:体检发票,DEP:住院押金)
/// 	  StaDate	开始日期
/// 	  EndDate	结束日期
/// 
/// 出参：进程号^数量
/// w ##class(BILL.EINV.BL.COM.InvPageInfoCtl).GetInvInfoByPapmi
ClassMethod GetInvInfoByPapmi(Papmi, PrtInvType, StaDate, EndDate) As %String
{
	s InvPID=$i(^TMP("BILLEINVUPLOAD"))
	k ^TMP("BILLEINVUPLOAD",InvPID)
	s num=0
	
	// 获取门诊、挂号票据信息
	i (PrtInvType="OP")||(PrtInvType="REG")||(PrtInvType="") d
	.s PrtRowid="",PayAdmType=""
	.i $d(^DHCINVPRT(0,"PAPMI")) d
	..f  s PrtRowid=$o(^DHCINVPRT(0,"PAPMI",Papmi,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCINVPRT(PrtRowid))
	...q:PrtInvInfo=""
	...s ACCINV=$p(PrtInvInfo,"^",4)
	...q:ACCINV'=""     ;add by xubaobao 2020 12 18过滤集中打印发票的数据 
	...s PrtDate=$p(PrtInvInfo,"^",5)		;结算日期
	...;q:((PrtDate<StaDate)||(PrtDate>EndDate))&&((StaDate'="")&&(EndDate'=""))	//根据登记号查询时无需过滤日期
	...s Flag=$p(PrtInvInfo,"^",8)			;结算状态
	...s fairType=$p(PrtInvInfo,"^",34)
	...s PayAdmType=$case(fairType,"R":"REG","F":"OP",:"")
	...;s PayAdmType=$case(fairType,"R":"REG","F":"OP","H":"PE",:"")
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	.e  d
	..f date=StaDate:1:EndDate  d
	...s PrtRowid="",PayAdmType=""
	...f  s PrtRowid=$o(^DHCINVPRT(0,"DatePAPMI",date,Papmi,PrtRowid)) q:PrtRowid=""  d
	....s PrtInvInfo=$g(^DHCINVPRT(PrtRowid))
	....q:PrtInvInfo=""
	....s Flag=$p(PrtInvInfo,"^",8)			;结算状态
	....q:(Flag="TP")						;过滤预结算记录
	....s fairType=$p(PrtInvInfo,"^",34)
	....s PayAdmType=$case(fairType,"R":"REG","F":"OP",:"")
	....s num=num+1
	....s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
	// 获取住院票据信息
	k AdmArray
	i (PrtInvType="IP")||(PrtInvType="") d
	.s adm=""
	.f  s adm=$o(^PAPERdr(Papmi,"ADM","I",adm)) q:adm=""  d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCINVPRTZY(0,"ADM",adm,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCINVPRTZY(PrtRowid))
	...q:PrtInvInfo=""
	...s PrtDate=$p(PrtInvInfo,"^",2)		;结算日期
	...;q:((PrtDate<StaDate)||(PrtDate>EndDate))&&((StaDate'="")&&(EndDate'=""))	//根据登记号查询时无需过滤日期
	...s Flag=$p(PrtInvInfo,"^",8)			;结算状态
	...s PayAdmType="IP"					;业务类型
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
	..//+add by suhuide at 2023-02-20 通过母亲就诊取婴儿就诊记录 
	..s AdmArray(adm)=""
	..s BabyAdmRowIDStr=##class(web.DHCIPBillCashier).GetBabyAdm(adm)
	..f idx=1:1:$l(BabyAdmRowIDStr,"^") d
	...s BabyAdmRowID=$p(BabyAdmRowIDStr,"^",idx)
	...q:(+BabyAdmRowID=0)
	...q:$d(AdmArray(BabyAdmRowID))
	...s PrtRowid="",PayAdmType=""
	...f  s PrtRowid=$o(^DHCINVPRTZY(0,"ADM",BabyAdmRowID,PrtRowid)) q:PrtRowid=""  d
	....s PrtInvInfo=$g(^DHCINVPRTZY(PrtRowid))
	....q:PrtInvInfo=""
	....s PrtDate=$p(PrtInvInfo,"^",2)		;结算日期
	....;q:((PrtDate<StaDate)||(PrtDate>EndDate))&&((StaDate'="")&&(EndDate'=""))	//根据登记号查询时无需过滤日期
	....s Flag=$p(PrtInvInfo,"^",8)			;结算状态
	....s PayAdmType="IP"					;业务类型
	....s num=num+1
	....s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	...s AdmArray(BabyAdmRowID)=""
	k AdmArray
	//+end;2023-02-20
	
	// 获取住院预交金票据信息
	i (PrtInvType="DEP")||(PrtInvType="") d
	.s adm=""
	.f  s adm=$o(^PAPERdr(Papmi,"ADM","I",adm)) q:adm=""  d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCSFPRINTDETAIL(0,"adm",adm,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCSFPRINTDETAIL(PrtRowid))
	...q:PrtInvInfo=""
	...s Flag="N"			;结算状态
	...s PrtDate=$p(PrtInvInfo,"^",2)		;结算日期
	...;q:((PrtDate<StaDate)||(PrtDate>EndDate))&&((StaDate'="")&&(EndDate'=""))		//根据登记号查询时无需过滤日期	
	...s PayAdmType="DEP"				;业务类型
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
			
	// 获取体检票据信息
	i (PrtInvType="PE")||(PrtInvType="") d
	.s adm=""
	.f  s adm=$o(^PAPERdr(Papmi,"ADM","H",adm)) q:adm=""  d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCPEINVPRT(0,"ADM",adm,PrtRowid)) q:(PrtRowid="")   d
	...s PrtInvInfo=$g(^DHCPEINVPRT(PrtRowid))
	...q:PrtInvInfo=""
	...s Flag=$p(PrtInvInfo,"^",8)		;结算状态
	...s PrtDate=$p(PrtInvInfo,"^",11)		;结算日期
	...;q:((PrtDate<StaDate)||(PrtDate>EndDate))&&((StaDate'="")&&(EndDate'=""))		//根据登记号查询时无需过滤日期	
	...s PayAdmType="PE"				;业务类型
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
	// 获取门诊集中打印票据信息
	i (PrtInvType="API")||(PrtInvType="") d
	.s PrtRowid="",PayAdmType=""
	.f  s PrtRowid=$o(^DHCINVPRTAPi(0,"PAPMI",Papmi,PrtRowid)) q:PrtRowid=""  d
	..s PrtInvInfo=$g(^DHCINVPRTAP(PrtRowid))
	..q:PrtInvInfo=""
	..s PrtDate=$p(PrtInvInfo,"^",3)		;结算日期
	..;q:((PrtDate<StaDate)||(PrtDate>EndDate))&&((StaDate'="")&&(EndDate'=""))			//根据登记号查询时无需过滤日期
	..s Flag=$p(PrtInvInfo,"^",2)			;结算状态
	..s PayAdmType="API"		;业务类型
	..s num=num+1
	..s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
	// add by xubaobao 2021 04 15
	// 获取注册建卡票据信息 
	i (PrtInvType="CF")||(PrtInvType="") d
	.s PrtRowid="",PayAdmType=""
	.f  s PrtRowid=$o(^DHCCARDINVPRTi(0,"PAPMI",Papmi,PrtRowid)) q:PrtRowid=""  d
	..s PrtInvInfo=$g(^DHCCARDINVPRT(PrtRowid))
	..q:PrtInvInfo=""
	..s PrtDate=$p(PrtInvInfo,"^",4)		;结算日期
	..;q:((PrtDate<StaDate)||(PrtDate>EndDate))&&((StaDate'="")&&(EndDate'=""))			//根据登记号查询时无需过滤日期
	..s Flag=$p(PrtInvInfo,"^",2)			;结算状态
	..s PayAdmType="CF"		;业务类型
	..s num=num+1
	..s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
			
	s RtnStr=InvPID_"^"_num
	
	q RtnStr
}

/// 功能说明根据日期获取发票信息
/// xubaobao 2020 07 24
/// 入参：PrtInvType  业务类型(IP:住院发票,OP:门诊发票,API:集中打印发票,PE:体检发票,DEP:住院押金)
/// 	  StaDate	开始日期
/// 	  EndDate	结束日期
/// 
/// 出参：进程号^数量
/// w ##class(BILL.EINV.BL.COM.InvPageInfoCtl).GetInvInfoByDate
ClassMethod GetInvInfoByDate(PrtInvType, StaDate, EndDate) As %String
{
	s:EndDate="" EndDate=+$h
	s:StaDate="" StaDate=+$h-30			//如果日期为空,默认获取30天内的数据
	
	s InvPID=$i(^TMP("BILLEINVUPLOAD"))
	k ^TMP("BILLEINVUPLOAD",InvPID)
	s num=0
	s Papmi=""  
	
	f date=StaDate:1:EndDate d
	.// 获取门诊、挂号票据信息
	.i (PrtInvType="OP")||(PrtInvType="REG")||(PrtInvType="") d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCINVPRT(0,"Date",date,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCINVPRT(PrtRowid))
	...q:PrtInvInfo=""
	...s ACCINV=$p(PrtInvInfo,"^",4)
	...q:ACCINV'=""     ;add by xubaobao 2020 12 18过滤集中打印发票的数据 
	...s Flag=$p(PrtInvInfo,"^",8)			;结算状态
	...s fairType=$p(PrtInvInfo,"^",34)
	...s PayAdmType=$case(fairType,"R":"REG","F":"OP",:"")
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
		
	.// 获取住院票据信息
	.i (PrtInvType="IP")||(PrtInvType="") d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCINVPRTZY(0,"DATE",date,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCINVPRTZY(PrtRowid))
	...q:PrtInvInfo=""
	...s Flag=$p(PrtInvInfo,"^",8)			;结算状态
	...s PayAdmType="IP"					;业务类型
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
	.// 获取住院预交金票据信息
	.i (PrtInvType="DEP")||(PrtInvType="") d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCSFPRINTDETAIL(PrtRowid))
	...q:PrtInvInfo=""
	...s Flag="N"						;结算状态
	...s PayAdmType="DEP"				;业务类型
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
			
	.// 获取体检票据信息
	.i (PrtInvType="PE")||(PrtInvType="") d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCPEINVPRT(0,"DATE",date,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCPEINVPRT(PrtRowid))
	...q:PrtInvInfo=""
	...s Flag=$p(PrtInvInfo,"^",8)		;结算状态
	...s PayAdmType="PE"				;业务类型
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
	.// 获取门诊集中打印票据信息
	.i (PrtInvType="API")||(PrtInvType="") d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCINVPRTAPi(0,"Date",date,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCINVPRTAP(PrtRowid))
	...q:PrtInvInfo=""
	...s Flag=$p(PrtInvInfo,"^",2)		;结算状态
	...s PayAdmType="API"				;业务类型
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
	.;add by xubaobao 2021 04 15
	.// 获取注册建卡票据信息
	.i (PrtInvType="CF")||(PrtInvType="") d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCCARDINVPRTi(0,"Date",date,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCCARDINVPRT(PrtRowid))
	...q:PrtInvInfo=""
	...s Flag=$p(PrtInvInfo,"^",2)		;结算状态
	...s PayAdmType="CF"				;业务类型
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
			
	s RtnStr=InvPID_"^"_num
	
	q RtnStr
}

/// 功能说明根据操作员获取发票信息
/// xubaobao 2020 07 24
/// 入参：UserID	  收费人员ID
/// 	  PrtInvType  业务类型(IP:住院发票,OP:门诊发票,API:集中打印发票,PE:体检发票,DEP:住院押金)
/// 	  StaDate	开始日期
/// 	  EndDate	结束日期
/// 
/// 出参：进程号^数量
/// w ##class(BILL.EINV.BL.COM.InvPageInfoCtl).GetInvInfoByUsrId
ClassMethod GetInvInfoByUsrId(UserID, PrtInvType, StaDate, EndDate) As %String
{
	
	s InvPID=$i(^TMP("BILLEINVUPLOAD"))
	k ^TMP("BILLEINVUPLOAD",InvPID)
	s num=0
	s Papmi=""
	
	// 获取门诊、挂号票据信息
	i (PrtInvType="OP")||(PrtInvType="REG")||(PrtInvType="") d
	.f date=StaDate:1:EndDate  d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCINVPRT(0,"UserDate",UserID,date,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCINVPRT(PrtRowid))
	...q:PrtInvInfo=""
	...s ACCINV=$p(PrtInvInfo,"^",4)
	...q:ACCINV'=""     ;add by xubaobao 2020 12 18过滤集中打印发票的数据 
	...s Flag=$p(PrtInvInfo,"^",8)			;结算状态
	...s fairType=$p(PrtInvInfo,"^",34)
	...s PayAdmType=$case(fairType,"R":"REG","F":"OP",:"")
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
	// 获取住院票据信息
	i (PrtInvType="IP")||(PrtInvType="") d
	.f date=StaDate:1:EndDate  d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCINVPRTZY(0,"DATEUSER",date,UserID,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCINVPRTZY(PrtRowid))
	...q:PrtInvInfo=""
	...s Flag=$p(PrtInvInfo,"^",8)			;结算状态
	...s PayAdmType="IP"					;业务类型
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
	
	// 获取住院预交金票据信息
	i (PrtInvType="DEP")||(PrtInvType="") d
	.s PrtRowid="",PayAdmType=""
	.f  s PrtRowid=$o(^DHCSFPRINTDETAIL(0,"AddUser",UserID,PrtRowid)) q:PrtRowid=""  d
	..s PrtInvInfo=$g(^DHCSFPRINTDETAIL(PrtRowid))
	..q:PrtInvInfo=""
	..s Flag="N"			;结算状态
	..s PrtDate=$p(PrtInvInfo,"^",2)		;结算日期
	..q:((PrtDate<StaDate)||(PrtDate>EndDate))&&((StaDate'="")&&(EndDate'=""))	
	..s PayAdmType="DEP"				;业务类型
	..s num=num+1
	..s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
			
	// 获取体检票据信息
	i (PrtInvType="PE")||(PrtInvType="") d
	.f date=StaDate:1:EndDate  d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCPEINVPRT(0,"USER",UserID,date,PrtRowid)) q:(PrtRowid="")   d
	...s PrtInvInfo=$g(^DHCPEINVPRT(PrtRowid))
	...q:PrtInvInfo=""
	...s Flag=$p(PrtInvInfo,"^",8)		;结算状态
	...s PayAdmType="PE"				;业务类型
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
	// 获取门诊集中打印票据信息
	i (PrtInvType="API")||(PrtInvType="") d
	.f date=StaDate:1:EndDate  d
	..s PrtRowid="",PayAdmType=""
	..f  s PrtRowid=$o(^DHCINVPRTAPi(0,"UserDate",UserID,date,PrtRowid)) q:PrtRowid=""  d
	...s PrtInvInfo=$g(^DHCINVPRTAP(PrtRowid))
	...q:PrtInvInfo=""
	...s Flag=$p(PrtInvInfo,"^",2)			;结算状态
	...s PayAdmType="API"		;业务类型
	...s num=num+1
	...s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
	
	// 获取门诊集中打印票据信息
	i (PrtInvType="CF")||(PrtInvType="") d
	.s PrtRowid="",PayAdmType=""
	.f  s PrtRowid=$o(^DHCCARDINVPRTi(0,"User",UserID,PrtRowid)) q:PrtRowid=""  d
	..s PrtInvInfo=$g(^DHCCARDINVPRT(PrtRowid))
	..q:PrtInvInfo=""
	..s Flag=$p(PrtInvInfo,"^",2)			;结算状态
	..s PayAdmType="CF"		;业务类型
	..s num=num+1
	..s ^TMP("BILLEINVUPLOAD",InvPID,num)=Papmi_"^"_PrtRowid_"^"_PayAdmType_"^"_Flag
			
	s RtnStr=InvPID_"^"_num
	
	q RtnStr
}

/// 功能说明：根据业务类型和发票ID获取发票信息
/// 入参说明: PayAdmType      --> 票据业务类型
///                               IP:住院发票,OP:门诊发票,API:集中打印发票,OT:门诊跳号发票,IT:住院跳号发票,PE:体检发票,DEP:住院押金
///           HISPrtRowID     --> HIS发生业务发票ID
/// 返 回 值: 0 成功 发票信息串
/// 修改履历：徐保保 2020 07 23 新做成
/// w ##class(BILL.EINV.BL.COM.InvPageInfoCtl).GetInvInfoByIDAndType()
ClassMethod GetInvInfoByIDAndType(PayAdmType As %String, HISPrtRowID As %String) As %String
{

	q:(PayAdmType="")||(HISPrtRowID="") ""
	
	s InvStr=""
	if (PayAdmType="OP")||(PayAdmType="REG"){		
		s InvStr=##class(BILL.EINV.BL.COM.Common).GetOPINVInfo(HISPrtRowID,"Y")
	}elseif(PayAdmType="IP"){		//获取住院发票信息对象
		s InvStr=##class(BILL.EINV.BL.COM.Common).GetIPINVInfo(HISPrtRowID,"Y")
	}elseif(PayAdmType="API"){		//获取集中打印发票对象
		s InvStr=##class(BILL.EINV.BL.COM.Common).GetAPIINVInfo(HISPrtRowID,"Y")
	}elseif(PayAdmType="DEP"){		//获取住院预交金发票对象
		s InvStr=##class(BILL.EINV.BL.COM.Common).GetDEPDepInfo(HISPrtRowID,"Y")
	}elseif(PayAdmType="PE"){       //获取体检发票对象
		s InvStr=##class(BILL.EINV.BL.COM.Common).GetPEINVInfo(HISPrtRowID,"Y")
	}elseif(PayAdmType="CF"){       //获取卡发票对象
		s InvStr=##class(BILL.EINV.BL.COM.Common).GetCFINVInfo(HISPrtRowID,"Y")
	}
	
	q InvStr
}

/// 功能说明： 未开具电子票据的结算记录列表信息查询
/// 入参说明： IUDStDate  -->开始时间
///            IUDEdDate  -->结束时间
///            IUDAdmType -->业务类型
///            Extstr     -->扩展参数(院区^登记号^开票标志^姓名^收费员)
/// 输出说明:  登记号:患者姓名:发票金额:业务类型:收退标志:his发票Dr:his原发票Dr:收费日期:收费员:就诊科室:就诊院区:就诊日期
/// Debug:	d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.InvPageInfoCtl","QueryInvUploadInfo","2019-01-01","2019-12-01","ALL","ALL^^ALL^")
Query QueryInvUploadInfo(IUDStDate As %String, IUDEdDate As %String, IUDAdmType As %String = "", Extstr As %String = "") As %Query(ROWSPEC = "PatRegNo:%String,PatName:%String,InvprtAmount:%String,LocgicType:%String,SFTFFlg:%String,Invprtrowid:%String,InitRowid:%String,SFDate:%String,SFTime:%String,SFUserDr:%String,SFUserName:%String,AdmLocName:%String,AdmHospitalDr:%String,AdmHospitalNM:%String,EInvFlg:%String,EInvCode:%String,EInvSeriNo:%String,BusinessDr:%String,EInvRandom:%String,PacAdmReasonDesc:%String,PictureUrl:%String,PDFUrl:%String")
{
}

ClassMethod QueryInvUploadInfoExecute(ByRef qHandle As %Binary, IUDStDate As %String, IUDEdDate As %String, IUDAdmType As %String = "", Extstr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
    s ind=1
    s ^Tempchche("QueryInvUploadInfo")=$lb(IUDStDate,IUDEdDate,IUDAdmType,Extstr)
    
    q:(IUDStDate="")||(IUDEdDate="") $$$OK
    s IUDStDate=##class(websys.Conversions).DateHtmlToLogical(IUDStDate)
    s IUDEdDate=##class(websys.Conversions).DateHtmlToLogical(IUDEdDate)
    
    // 查询条件参数获取
    s:IUDAdmType="ALL" IUDAdmType=""     ;业务类型
    s HospitalDrPam=$p(Extstr, "^", 1)   ;院区编码
    s:HospitalDrPam="ALL" HospitalDrPam=""
    s PatRegNoPam=$p(Extstr, "^", 2)     ;登记号
    s:PatRegNoPam'="" PatRegNoPam=..PatRegNoFormat(PatRegNoPam, 10)  //格式化为10位的长度
    s KPFlg=$p(Extstr, "^", 3)           ;开票标志 1 已开 0 未开 空代表全部
    s PatNamePam=$p(Extstr, "^", 4)		 ;姓名
    s SFUserDrPam=$p(Extstr, "^", 5)	 ;收费员
    s:SFUserDrPam="" SFUserDrPam="ALL"		//默认查询全部
    s InvType=""
    s (PatRegNo,PatName,InvprtAmount,LocgicType,SFTFFlg,Invprtrowid,InitRowid,SFDate,SFTime,SFUserDr,SFUserName,AdmLocName,AdmHospitalDr,AdmHospitalNM,EInvFlg,EInvCode,EInvSeriNo,BusinessDr,PacAdmReasonDesc,PictureUrl)=""
    
    if (PatNamePam'="")||(PatRegNoPam'=""){	
    	i (PatRegNoPam'="") {							//按照登记号查询发票信息
	    	s Papmi=$o(^PAPERi("PAPMI_PatNo",PatRegNoPam,""))
	    	d PrtInvInfoRow
    	}elseif(PatNamePam'="")&&(PatRegNoPam=""){		//按照姓名查询发票信息
	    	s Papmi=""		
    		f  s Papmi=$o(^PAPERi("PAPER_PatName",PatNamePam,Papmi)) q:Papmi=""  d
    		.d PrtInvInfoRow
    	}	  
    }elseif(SFUserDrPam'="ALL")&&(PatNamePam="")&&(PatRegNoPam=""){	//根据收费员查询
    	s InvType="1"			//为1时按照收费员查询
    	d PrtInvInfoRow
    }else{						//根据日期查询电子发票信息
    	s InvType="2"			//为2时按照日期查询
    	d PrtInvInfoRow
    }
    s qHandle=$lb(0,repid,0)
    q $$$OK

PrtInvInfoRow
	i InvType="1" d
	.s RtnStr=..GetInvInfoByUsrId(SFUserDrPam,IUDAdmType, IUDStDate, IUDEdDate)
	e  i InvType="2" d
	.s RtnStr=..GetInvInfoByDate(IUDAdmType, IUDStDate, IUDEdDate)
	e   d
	.s RtnStr=..GetInvInfoByPapmi(Papmi,IUDAdmType, IUDStDate, IUDEdDate)	
    s pid=$p(RtnStr,"^",1)
	s num=$p(RtnStr,"^",2)
	q:num<1 $$$OK
	//获取发票信息
	f index=1:1:num d
	.s InvStr=$g(^TMP("BILLEINVUPLOAD",pid,index))
  	.s Flag=$p(InvStr,"^",4)   		 ;结算类型
	.s PrtRowid=$p(InvStr,"^",2)
	.s PayAdmType=$p(InvStr,"^",3)
	.s ObjPatBaseInfo =##class(BILL.EINV.DTO.COM.PatBaseInfo).%New()   ;基本信息对象
	.s ObjPatAdmInfo =##class(BILL.EINV.DTO.COM.PatAdmInfo).%New()     ;就诊信息对象
	.s PatRtn=##class(BILL.EINV.BL.COM.Common).GetPatInfoByInv(PayAdmType, PrtRowid, .ObjPatBaseInfo, .ObjPatAdmInfo)  ;根据发票票信息获取患者基本信息及就诊信息 
    .q:PatRtn'="0"
    .s PrtInvInfo=..GetInvInfoByIDAndType(PayAdmType,PrtRowid)
    .q:PrtInvInfo=""
	.s PatRegNo=ObjPatBaseInfo.PAPMINO                    ;登记号
	.s:PatRegNo'="" PatRegNo=..PatRegNoFormat(PatRegNo, 10)  //格式化为10位的长度
	.q:(PatRegNoPam'="")&&(PatRegNo'=PatRegNoPam)
 	.s PatName=ObjPatBaseInfo.PatName                     ;患者姓名
 	.q:(PatNamePam'="")&&(PatName'=PatNamePam)
 	.s InvprtAmount=$p(PrtInvInfo,"^",5)               	  ;发票金额
	.s LocgicType=PayAdmType                              ;业务类型
	.s InitRowid=$p(PrtInvInfo,"&",2)					  ;原发票ID
	.s PacAdmReason=$p(PrtInvInfo,"&",4)	              ;费别ID
	.s:PacAdmReason'="" PacAdmReasonDesc=$p($g(^PAC("ADMREA",PacAdmReason)),"^",2) 
	.s SFTFFlg = "收费"                                   ;收退标志
	.;add by xubaobao 2020 08 03 start	增加判断(如果金额<0且原发票ID不为空时为退费记录)
	.s:(InitRowid'="")&&(+InvprtAmount<0) SFTFFlg = "退费"
	.s:SFTFFlg="收费" InitRowid=""	 	;如果是收费记录，原发票ID默认取空(开具补上传使用)
	.;add by xubaobao 2020 08 03 end
	.s Invprtrowid = PrtRowid                        	  ;his发票Dr
	.s InitRowid = InitRowid                              ;his原发票Dr
	.s SFDate=$p(PrtInvInfo,"^",6)                        ;收费日期
	.s SFTime=$p(PrtInvInfo,"^",7)                        ;收费时间
	.s SFTime=$p(SFTime,"&",1)                        	  ;收费时间
	.s SFUserDr=$p(PrtInvInfo,"^",1)                      ;收费员Dr
	.s SFUserName=""                                      ;收费员名称
	.i SFUserDr'="" d
	..s SFUserName=$p($g(^SSU("SSUSR",SFUserDr)), "^", 2)
	.s AdmLocName =ObjPatAdmInfo.DepDesc                  ;就诊科室
	.s AdmHospitalDr=$p(PrtInvInfo,"^",3)             	  ;院区Dr
	.q:(HospitalDrPam'="")&&(HospitalDrPam'=AdmHospitalDr)          //根据结算院区过滤
	.i AdmHospitalDr'="" d
	..s AdmHospitalNM = $p($g(^CT("HOSP",AdmHospitalDr)), "^", 2)  ;就诊院区名称
	.//根据发票ID,业务类型获取电子发票信息
	.s EInvFlg="0"               ;开票标志
	.s EInvCode=""               ;票据代码
	.s EInvSeriNo=""             ;票据号码
	.s BusinessDr=""             ;业务表id
	.s EInvRandom=""             ;票据校验码
	.s PictureUrl=""             ;票据URL
	.s PDFUrl=""                 ;PDFURL
	.s IUDID=$o(^BILL.EINV.PO.InvUpDetailsI("IDataKey",PayAdmType,PrtRowid,"E",""),-1)
	.i IUDID'="" d
	..//Modify By suhuide at 2022-01-06  考虑使用对象取值前台加载是否过慢?? 修改用$list取值
	..//s objUpDetail=##class(BILL.EINV.PO.InvUpDetails).%OpenId(IUDID)
	..s EInvCode=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),12)
	..//s EInvCode=objUpDetail.IUDBillBatchCode
	..s EInvSeriNo=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),13) 
	..//s EInvSeriNo=objUpDetail.IUDBillBatchNo
	..s BusinessDr=IUDID
	..//s EInvRandom=objUpDetail.IUDCheckCode
	..s EInvRandom=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),21) 
	..//s EInvFlg=$case(objUpDetail.IUDUplodeFlag,"Y":"1",:"0")
	..s EInvFlg=$case($LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),8),"Y":"1",:"0")
	..s PictureUrl=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),33)      ;add 2023-01-29   增加电子票据预览地址
	..s PDFUrl=$LIST(^BILL.EINV.PO.InvUpDetailsD(IUDID),42)      ;目前PDFurl,XStr2
	.q:(KPFlg'="ALL")&&(EInvFlg'=KPFlg)
	.d OutputRow
	
	k ^TMP("BILLEINVUPLOAD",pid)
	Set qHandle=$lb(0,repid,0)
    Quit $$$OK
		
OutputRow
	//需要输出的列
	set Data=$lb(PatRegNo,PatName,InvprtAmount,LocgicType,SFTFFlg,Invprtrowid,InitRowid,SFDate,SFTime,SFUserDr,SFUserName,AdmLocName,AdmHospitalDr,AdmHospitalNM,EInvFlg,EInvCode,EInvSeriNo,BusinessDr,EInvRandom,PacAdmReasonDesc,PictureUrl,PDFUrl)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	q
}

ClassMethod QueryInvUploadInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInvUploadInfoExecute ]
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

ClassMethod QueryInvUploadInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInvUploadInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 徐保保 2020 08 07 新做成
/// 根据就诊号查询体检票据
ClassMethod GetPEInvByAdmDr(Admdr As %String, StDate As %String, EndDate As %String, DataPIDKey As %String, ByRef IndexNo As %Integer) As %String
{
	s RtnNum=0
	
	s InvDr=""
	f  s InvDr=$o(^DHCPEINVPRT(0, "ADM", Admdr, InvDr)) q:InvDr=""  d
	.s prtDate=$p(^DHCPEINVPRT(InvDr),"^",11)
	.s prtTime=$p(^DHCPEINVPRT(InvDr),"^",12)
	.q:(prtDate<StDate)||(prtDate>EndDate)
	.s IndexNo=IndexNo+1
	.s ^TMPPatAllEINVPE("PatInvInfosPE",DataPIDKey, IndexNo)=InvDr_"^"_"PE"
	.s RtnNum=RtnNum+1
	
	q RtnNum
}

}
