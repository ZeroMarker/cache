Import SQLUser

/// 住院登记
Class web.DHCINSUIPReg Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 38;

/// 根据病人登记号得到病人信息列表
/// DingSH 20200526 入参增加院区
ClassMethod GetPatInfoByPatNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", PatNo As %Library.String = "", HospDr As %Library.String = "")
{
	q:PatNo=""	
	q:HospDr=""
	
	s ret=##class(web.DHCINSUPatInfo).GetPatInfoByPatNO(PatNo,HospDr)
	q ret
}

/// 根据病人登记号得到病人就诊记录
/// DingSH 20200526 入参增加院区
/// w ##class(web.DHCINSUIPReg).GetPaAdmListByPatNo("","",)
ClassMethod GetPaAdmListByPatNo(itmjs As %Library.String = "", itmjsex As %Library.String = "", PapmiNo As %Library.String = "", HospDr As %Library.String = "")
{
	q:PapmiNo=""
	s outstr=""
    s PatmasID="0"
    s PaadmRowID="0"
    q:$d(^PAPERi("PAPMI_PatNo",PapmiNo))=0 outstr
    s PatmasID=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PatmasID))
    f  s PaadmRowID=$o(^PAPERdr(PatmasID,"ADM","I",PaadmRowID)) q:PaadmRowID=""  d
    .s DepNameId=$P(^PAADM(PaadmRowID),"^",4)
    .s tHospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PaadmRowID) //+DingSH 20200526
    .q:tHospDr'=HospDr
    .s outstr=$p($g(^PAADM(PaadmRowID)),"^",81)_"!"_PaadmRowID_"!"_$p(^PAPER(PatmasID,"ALL"),"^",1)_"!"_$p(^CTLOC(DepNameId),"^",2)_"!"_##class(websys.Conversions).DateLogicalToHtml($p(^PAADM(PaadmRowID),"^",6))_"^"_outstr
    s outstr=""_"^"_outstr
    q outstr
}

/// 根据病人登记号得到病人就诊记录
/// DingSH 20200526 入参增加院区
ClassMethod GetPaAdmListByPatNoIPReg(itmjs As %Library.String = "", itmjsex As %Library.String = "", PapmiNo As %Library.String = "", HospDr As %Library.String = "")
{
	q:PapmiNo=""
	s outstr="",jsonstr=""
    s PatmasID="0"
    s PaadmRowID="0"
    q:$d(^PAPERi("PAPMI_PatNo",PapmiNo))=0 outstr
    #dim lstDataAry As %ListOfDataTypes 
	i $zcvt(itmjs,"U") ="HUITOJSON" d       //DingSH 20210910
	.s lstDataAry =  ##class(%ListOfDataTypes).%New()
    s PatmasID=$o(^PAPERi("PAPMI_PatNo",PapmiNo,PatmasID))
    f  s PaadmRowID=$o(^PAPERdr(PatmasID,"ADM","I",PaadmRowID)) q:PaadmRowID=""  d
    .s BillFlag=$P(^PAADM(PaadmRowID),"^",45)
    .;q:BillFlag="Y"  d
    .s Rtn=##class(web.DHCINSUPatInfo).GetAdmInfoByAdmID(PaadmRowID)
    .q:$p(Rtn,"!",1)'=1
    .s tHospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PaadmRowID) //+DingSH 20200526
    .q:tHospDr'=HospDr
    .s AdmInfo=$p(Rtn,"!",2)
    .s AdmNo=$p(AdmInfo,"^",2)    ;就诊号
    .s AdmType=$p(AdmInfo,"^",3)
    .s DepDesc=$p(AdmInfo,"^",5)   ;入院科室名称
    .s AdmDate=$p(AdmInfo,"^",6)   ;入院日期
    .s AdmTime=$p(AdmInfo,"^",7)
    .s tmpAdmDate=$zdh(AdmDate,3)
	.s AdmDate=##class(websys.Conversions).DateLogicalToHtml(tmpAdmDate)
	.s tmpAdmTime=$zth(AdmTime)
	.s AdmTime=##class(websys.Conversions).TimeLogicalToHtml(tmpAdmTime)
	.s $p(AdmInfo,"^",6)=AdmDate
	.s $p(AdmInfo,"^",7)=AdmTime
	.s VisitStatus=$p(AdmInfo,"^",12)
	.s VisitStatus=$case(VisitStatus,"C":"退院","A":"在院","D":"出院")
	.s AdmReasonDr=$p(AdmInfo,"^",28)
	.s AdmReasonDesc=$p(AdmInfo,"^",29)
	.s AdmReasonInfo=$p(AdmInfo,"=",6)
	.s ReaNationalCode=$p(AdmReasonInfo,"^",6)
	.s InDiagCode=$p(AdmInfo,"^",22)
	.s InDiagDesc=$p(AdmInfo,"^",23)
    .i outstr="" d
    ..s outstr=AdmInfo
    .e           d
    ..s outstr=AdmInfo_"!"_outstr
    .//i itmjs="HUIToJson" d
    .i $zcvt(itmjs,"U") ="HUITOJSON" d //DingSH 20210910
	..s dataAry=  ##class(%ArrayOfDataTypes).%New()
	..d dataAry.SetAt($p(AdmInfo,"^",1),"AdmDr")
	..d dataAry.SetAt(AdmNo,"AdmNo")
	..d dataAry.SetAt(AdmType,"AdmType")
	..d dataAry.SetAt(DepDesc,"DepDesc")
	..d dataAry.SetAt(AdmDate,"AdmDate")
	..d dataAry.SetAt(AdmTime,"AdmTime")
	..d dataAry.SetAt("","AdmStr")
	..d dataAry.SetAt(VisitStatus,"VisitStatus")
	..d dataAry.SetAt(AdmReasonDr,"AdmReasonDr")
	..d dataAry.SetAt(AdmReasonDesc,"AdmReasonDesc")
	..d dataAry.SetAt(ReaNationalCode,"ReaNationalCode")
	..d dataAry.SetAt(InDiagCode,"InDiagCode")
	..d dataAry.SetAt(InDiagDesc,"InDiagDesc")
	..d lstDataAry.Insert(dataAry)
    ..//s tmpjson="{""AdmDr"":"""_$p(AdmInfo,"^",1)_""",""AdmNo"":"""_AdmNo_""",""AdmType"":"""_AdmType_""",""DepDesc"":"""_DepDesc_""",""AdmDate"":"""_AdmDate_""",""AdmTime"":"""_AdmTime_""",""AdmStr"":"""_""_""",""VisitStatus"":"""_VisitStatus_""",""AdmReasonDr"":"""_AdmReasonDr_""",""AdmReasonDesc"":"""_AdmReasonDesc_""",""ReaNationalCode"":"""_ReaNationalCode_""","":InDiagCode"":"""_InDiagCode_""","":InDiagDesc"":"""_InDiagDesc_""""_"}"
    ..//i jsonstr="" d
    ..//.s jsonstr=jsonstr_tmpjson
    ..//e  d
    ..//.s jsonstr=jsonstr_","_tmpjson
    s:outstr'="" outstr=""_"!"_outstr
    i $zcvt(itmjs,"U") ="HUITOJSON" d //DingSH 20210910
    .;s outstr="{""rows"""_ ":["_jsonstr_"],""total"":"_1_"}"
    .//s outstr="["_jsonstr_"]"
    .s outstr=##class(web.INSUCacheJSON).Encode(lstDataAry)
    q outstr
}

/// 根据Adm得到病人就诊信息
ClassMethod GetPaAdmInfoCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", Adm As %Library.String = "") As %String
{
	q:Adm=""	
	s ret=##class(web.DHCINSUPatInfo).GetAdmInfoByAdmID(Adm)
	q ret
}

/// 得到医保信息
/// w ##class(web.DHCINSUIPReg).GetInfoByAdm("", "", 369)
ClassMethod GetInfoByAdm(itmjs As %Library.String = "", itmjsex As %Library.String = "", Paadm As %Library.String = "")
{
	q:Paadm=""
	s ret=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(Paadm)
	i +ret>0 d
	.s $P(ret,"^",13)=##class(websys.Conversions).DateHtmlToLogical($P(ret,"^",13))  
	.s $P(ret,"^",13)=##class(websys.Conversions).DateLogicalToHtml($P(ret,"^",13)) //日期格式 20200305 DingSH
	.s HospDr = ##class(web.UDHCHospitalGroup).GetHospitalByAdm(Paadm)
	.s InsuType=$P(ret,"^",19)
	.s $P(ret,"^",5)=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKC021"_InsuType,$P(ret,"^",5),4,HospDr)
	.;st -不同医保类型登记界面处理(注意，每个项目要修改)
	.i InsuType = "ZZB" d
	..s $P(ret,"^",37)=""  ;创智接口-待遇类别，东软接口-没用到
	.;ed -不同医保类型登记界面处理(注意，每个项目要修改)
	.;st 统筹区划描述 +20230331 HanZH
	.i $P(ret,"^",9)'="" D
	.s admdvsDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("admdvs"_InsuType,$P(ret,"^",9),4,HospDr)
	.s ret=ret_"^"_admdvsDesc
	.;ed
	q ret
}

/// 检测病人费用
ClassMethod CheckBillCom(itmjs As %Library.String = "", itmjsex As %Library.String = "", admRowid As %Library.String = "", user As %Library.String = "")
{
	q:admRowid=""
	s err=##class(web.UDHCJFBILL).BILL(admRowid,user)	
	q:$d(^DHCPB(0,"ADM",admRowid))=0 0
	s id=$o(^DHCPB(0,"ADM",admRowid,""))	
	s s=$g(^DHCPB(id))	
	q:+$p(s,"^",8)>0 -1
	q 0
}

/// 20080828 入院类别
ClassMethod GetAdmTypeByAdm(Paadm As %Library.String = "")
{
	q:Paadm=""
	s ret=##class(web.DHCINSUAdmInfoCtl).GetInfoByAdm(Paadm)
	s data=$p(ret,"!",2)
    S type=$p(data,"^",15)
	if type="TB"{ s type="特病登记"}
	else  {s type=""} 
	q type
}

ClassMethod GetInsuDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInsuDiagnosisExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// DingSH 20200526 入参 AdmReasonDesc 修改成 InsuType
/// DingSH 20200526 入参 增加 HospDr
ClassMethod GetInsuDiagnosisExecute(ByRef qHandle As %Binary, InsuInDiagDesc As %String, InsuType As %String, HospDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	set ^TMP("GetInsuDiagnosis")=$lb(InsuInDiagDesc, InsuType)
	s ind=1
	Set qHandle=$lb(0,repid,0) 
	q:InsuType="" $$$OK
	s actDate=+$h ;DingSH 20160414
	//根据院区取医保分组默认院区的ID  +WangXQ 20220721
	s:(HospDr="")&&($g(%session)'="") HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_Diagnosis",HospDr)  
	//set:AdmReasonDesc="CCXKS" AdmReasonDesc="CCCNew"
	s InsuInDiagDesc=$$ALPHAUP^SSUTIL4(InsuInDiagDesc)
	;s InsuInDiagDesc=##class(web.DHCINSUPort).GetCNCODE(InsuInDiagDesc,4,"")
	s rowid="0"
	f  s rowid=$o(^DHCINDiagnos(rowid)) q:rowid=""  d
	.s tmpInsuType=$p(^DHCINDiagnos(rowid),"^",1)
	.s Code=$p(^DHCINDiagnos(rowid),"^",2)
	.s Desc=$p(^DHCINDiagnos(rowid),"^",3)
	.s pym=$p(^DHCINDiagnos(rowid),"^",4)
	.s tHospDr=$p(^DHCINDiagnos(rowid),"^",25) //+ DingSH 20200526
	.q:tHospDr'=GroupHospDr
	.s tactDate=+$p(^DHCINDiagnos(rowid),"^",13) ;没开始生效的过滤掉 DingSH 20160414
	.q:tactDate>actDate
	.q:(pym'[InsuInDiagDesc)&&(Desc'[InsuInDiagDesc) ;tangzf 2019-3-25 add 汉字检索
	.q:tmpInsuType'=InsuType
	.d Build
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build    
	set Data=$lb(rowid,Code,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetInsuDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInsuDiagnosisExecute ]
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

/// D ##class(%ResultSet).RunQuery("web.DHCINSUIPReg","GetInsuDiagnosis","pf","XZA")
Query GetInsuDiagnosis(InsuInDiagDesc As %String, InsuType As %String, HospDr As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod GetInsuAdmInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInsuAdmInfoExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod GetInsuAdmInfoExecute(ByRef qHandle As %Binary, AdmDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s TRowid="Rowid"
	s TAdmDr="就诊号"
	s TInsuId="医保号"
	s TCardNo="医保卡号"
	s TPatType="人员类型"
	s TCardStatus="IC卡状态"
	s TCompany="单位"
	s TStates="地区"
	s TCenter="分中心"
	s TAccount="账户余额"
	s TAdmSeriNo="医保流水号"
	s TActiveFlag="登记有效标志"
	s TAdmDate="His就诊日期"
	s TAdmTime="His就诊时间"
	s TAdmType="医疗类别"
	s TDeptDesc="科室"
	s TInsuUser="入院登记人"
	s TIpTimes="住院次数"
	s TInsuType="医保类型"
	s TAdmCancelNo="冲销流水号"
	s TOutDate="出院日期"
	s TOutTime="出院时间"
	s TOutUser="出院操作员"
	s TUserDr="操作员指针"
	s TFunDate="操作日期"
	s TFunTime="操作时间"
	s TXString1="医保入院诊断编码"
	s TXString2="医保入院诊断名称"
	s TXString3="医保出院诊断编码"
	s TXString4="医保出院诊断名称"
	s TXFloat1="预留1"
	s TXFloat2="预留2"
	s TXFloat3="预留3"
	s TXFloat4="预留4"
	s TXString5="身份证号"
	s TXString6="预留6"
	s TXString7="待遇类别"
	s TXString8="险种类型"
	s TXString9="预留9"
	s TXString10="预留10"
	s TXString11="预留11"
	s TXString12="预留12"
	s TXString13="预留13"
	s TXString14="预留14"
	s TXString15="预留15"
	s TXString16="预留16"
	s TXString17="预留17"
	s TXString18="预留18"
	s TXString19="预留19"
	s TXString20="预留20"
	s TInsuAdmInfoDr="被冲销记录rowid"
	s HospDr=""
	;d Build1
	i AdmDr="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s InAdmRowid="0"
	f  s InAdmRowid=$o(^DHCINADM(0,"ADM",AdmDr,InAdmRowid)) q:InAdmRowid=""  d
	.s InsuAdmInfo=$g(^DHCINADM(InAdmRowid))
	.s TRowid=InAdmRowid
	.s TAdmDr=AdmDr
	.s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr) //+DingSH 20200526
	.s TInsuId=$p(InsuAdmInfo,"^",2)
	.s TCardNo=$p(InsuAdmInfo,"^",3)
	.s TPatType=$p(InsuAdmInfo,"^",4)
	.s TCardStatus=$p(InsuAdmInfo,"^",5)
	.s TCompany=$p(InsuAdmInfo,"^",6)
	.s TStates=$p(InsuAdmInfo,"^",7)
	.s TCenter=$p(InsuAdmInfo,"^",8)
	.s TAccount=$p(InsuAdmInfo,"^",9)
	.s TAdmSeriNo=$p(InsuAdmInfo,"^",10)
	.s TActiveFlag=$p(InsuAdmInfo,"^",11)
	.s TActiveFlag=$case(TActiveFlag,"A":"在院","O":"出院","B":"被作废","S":"作废",:"其他") ;DingSH20170221
	.s TAdmDate=$p(InsuAdmInfo,"^",12)
	.;s:TAdmDate'="" TAdmDate=$zd(TAdmDate,3)
	.s:TAdmDate'="" TAdmDate=##class(websys.Conversions).DateLogicalToHtml(TAdmDate)
	.s TAdmTime=$p(InsuAdmInfo,"^",13)
	.;s:TAdmTime'="" TAdmTime=$zt(TAdmTime)
	.s:TAdmTime'="" TAdmTime=##class(websys.Conversions).TimeLogicalToHtml(TAdmTime)
	.s TAdmType=$p(InsuAdmInfo,"^",14)
	.s TDeptDesc=$p(InsuAdmInfo,"^",15)
	.s TInsuUser=$p(InsuAdmInfo,"^",16)
	.s UserStr=""
    .s:TInsuUser'="" UserStr=$$GetUserStr^DHCINSUBase(TInsuUser) ;DingSH 20160722
    .s:UserStr'="" TInsuUser=$P(UserStr,"^",2)
	.s TIpTimes=$p(InsuAdmInfo,"^",17)
	.s TInsuType=$p(InsuAdmInfo,"^",18)
	.s TPatType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKC021"_TInsuType,TPatType,4,HospDr) ;DingSH 20160722
	.s TAdmType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA130"_TInsuType,TAdmType,4,HospDr) ;;DingSH 20160722
	.s TAdmCancelNo=$p(InsuAdmInfo,"^",19)
	.s TOutDate=$p(InsuAdmInfo,"^",20)
	.s:TOutDate="" TOutDate=$p(##class(web.DHCDischargeHistory).GetDischargeDateTime(AdmDr),"^",1)
	.;s:TOutDate'="" TOutDate=$zd(TOutDate,3)
	.s:TOutDate'="" TOutDate=##class(websys.Conversions).DateLogicalToHtml(TOutDate)
	.s TOutTime=$p(InsuAdmInfo,"^",21)
	.s:TOutTime="" TOutTime=$p(##class(web.DHCDischargeHistory).GetDischargeDateTime(AdmDr),"^",2)
	.;s:TOutTime'="" TOutTime=$zt(TOutTime)
	.s:TOutTime'="" TOutTime=##class(websys.Conversions).TimeLogicalToHtml(TOutTime)
	.s TOutUser=$p(InsuAdmInfo,"^",22)
	.s TUserDr=$p(InsuAdmInfo,"^",23)
	.s UserStr=""
    .s:TUserDr'="" UserStr=$$GetUserStr^DHCINSUBase(TUserDr) ;DingSH 20160722
    .s:UserStr'="" TUserDr=$P(UserStr,"^",2)
    .s:(TOutUser="")&&(TActiveFlag="出院") TOutUser=TUserDr
	.s TFunDate=$p(InsuAdmInfo,"^",24)
	.;s:TFunDate'="" TFunDate=$zd(TFunDate,3)
	.s:TFunDate'="" TFunDate=##class(websys.Conversions).DateLogicalToHtml(TFunDate)
	.s TFunTime=$p(InsuAdmInfo,"^",25)
	.;s:TFunTime'="" TFunTime=$zt(TFunTime)
	.s:TFunTime'="" TFunTime=##class(websys.Conversions).TimeLogicalToHtml(TFunTime)
	
	.s TXString1=$p(InsuAdmInfo,"^",26)
	.s TXString2=$p(InsuAdmInfo,"^",27)
	.s TXString3=$p(InsuAdmInfo,"^",28)
	.s TXString4=$p(InsuAdmInfo,"^",29)
	.;s:TXString3="" TXString3=TXString1
	.;s:TXString4="" TXString4=TXString2
	.s TXFloat1=$p(InsuAdmInfo,"^",30)
	.s TXFloat2=$p(InsuAdmInfo,"^",31)
	.s TXFloat3=$p(InsuAdmInfo,"^",32)
	.s TXFloat4=$p(InsuAdmInfo,"^",33)
	.s TXString5=$p(InsuAdmInfo,"^",34)
	.s TXString6=$p(InsuAdmInfo,"^",35)
	.s TXString7=$p(InsuAdmInfo,"^",36)
	.s TXString8=$p(InsuAdmInfo,"^",37)
	.s TXString9=$p(InsuAdmInfo,"^",38)
	.s TXString10=$p(InsuAdmInfo,"^",39)
	.s TXString11=$p(InsuAdmInfo,"^",40)
	.s TXString12=$p(InsuAdmInfo,"^",41)
	.s TXString13=$p(InsuAdmInfo,"^",42)
	.s TXString14=$p(InsuAdmInfo,"^",43)
	.s TXString15=$p(InsuAdmInfo,"^",44)
	.s TXString16=$p(InsuAdmInfo,"^",45)
	.s TXString17=$p(InsuAdmInfo,"^",46)
	.s TXString18=$p(InsuAdmInfo,"^",47)
	.s TXString19=$p(InsuAdmInfo,"^",48)
	.s TXString20=$p(InsuAdmInfo,"^",49)
	.s TInsuAdmInfoDr=$p(InsuAdmInfo,"^",50)
	.// st-不同医保界面展示字段取值位置不同处理 注意每个项目需要修改
	.i TInsuType="ZZB" d
	..s TSex=$p(InsuAdmInfo,"^",36)
	..s TXString7=""
	.// st-不同医保界面展示字段取值位置不同处理
	.d Build1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build1    
	s:TIpTimes=0 TIpTimes=""
	s:TStates'="" TStates=##class(web.INSUDicDataCom).GetDicByCodeAndInd("YAB003"_TInsuType,TStates,4,HospDr)
	s TInsuType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",TInsuType,4,HospDr)
	set Data=$lb(TRowid,TAdmDr,TInsuId,TCardNo,TPatType,TCardStatus,TCompany,TStates,TCenter,TAccount,TAdmSeriNo,TActiveFlag,TAdmDate,TAdmTime,TAdmType,TDeptDesc,TInsuUser,TIpTimes,TInsuType,TAdmCancelNo,TOutDate,TOutTime,TOutUser,TUserDr,TFunDate,TFunTime,TXString1,TXString2,TXString3,TXString4,TXFloat1,TXFloat2,TXFloat3,TXFloat4,TXString5,TXString6,TXString7,TXString8,TXString9,TXString10,TXString11,TXString12,TXString13,TXString14,TXString15,TXString16,TXString17,TXString18,TXString19,TXString20,TInsuAdmInfoDr,TSex)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetInsuAdmInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInsuAdmInfoExecute ]
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

/// D ##class(%ResultSet).RunQuery("web.DHCINSUIPReg","GetInsuAdmInfo","")
Query GetInsuAdmInfo(AdmDr As %String) As %Query(ROWSPEC = "TRowid:%String,TAdmDr:%String,TInsuId:%String,TCardNo:%String,TPatType:%String,TCardStatus:%String,TCompany:%String,TStates:%String,TCenter:%String,TAccount:%String,TAdmSeriNo:%String,TActiveFlag:%String,TAdmDate:%String,TAdmTime:%String,TAdmType:%String,TDeptDesc:%String,TInsuUser:%String,TIpTimes:%String,TInsuType:%String,TAdmCancelNo:%String,TOutDate:%String,TOutTime:%String,TOutUser:%String,TUserDr:%String,TFunDate:%String,TFunTime:%String,TXString1:%String,TXString2:%String,TXString3:%String,TXString4:%String,TXFloat1:%String,TXFloat2:%String,TXFloat3:%String,TXFloat4:%String,TXString5:%String,TXString6:%String,TXString7:%String,TXString8:%String,TXString9:%String,TXString10:%String,TXString11:%String,TXString12:%String,TXString13:%String,TXString14:%String,TXString15:%String,TXString16:%String,TXString17:%String,TXString18:%String,TXString19:%String,TXString20:%String,TInsuAdmInfoDr:%String,TSex:%String")
{
}

/// 功能描述:根据 Pa_Adm.Rowid 及读卡返回的 病人类型和医疗类别 更新费别
/// DingSH 20160713
/// Input:PAADMDr:Pa_Adm.Rowid,ReaId(新费别，可为空，为空时必须在AKC021+医保类型 字典维护，人员类别到费别对照)
/// ExpStr:操作员Dr^PapmiDr^InsuId(医保号,即医保手册号) 
/// OutPut    : 成功与否标识!返回信息
/// w ##class(web.DHCINSUIPReg).UpdatePatAdmReason("45","","1^173^0011")
ClassMethod UpdatePatAdmReason(PAADMDr, ReaId, ExpStr) As %String
{
    n (PAADMDr,ReaId, ExpStr)
	q:$g(PAADMDr)="" "-1!入参PAAMDr为空"
	s admReaDrOld=$p(^PAADM(PAADMDr,1),"^",7)  ;原“病人类型”
	s UserDr=$P($g(ExpStr),"^",1)
	q:UserDr="" "-2!入参操作员Dr为空"
	s HospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADMDr) //+DingSH 20200526
	;增加更新医保号到医保基本信息表功能 20190110 DingSH
	s PapmiDr=$P($g(ExpStr),"^",2)
	s InsuId=$P($g(ExpStr),"^",3)
	//q:(ReaId'="") ##class(web.UDHCJFIPReg).IUpdateAdmReason(PAADMDr, admReaDrOld, ReaId,UserDr, "") 
	q:(ReaId'="") ##class(web.DHCIPBillReg).UpdateAdmReason(PAADMDr, admReaDrOld, ReaId,UserDr,"") //+DingSH 20201223
    ; w ##class(web.UDHCJFIPReg).IUpdateAdmReason(adm, admReasonDr, updateUser, expStr) ;-1:就诊Rowid为空 ; -2:病人类型指针为空  -3:更新人为空; 0:更新成功 ;其它:更新不成功
	q:$d(^DHCINADM("0","ADM",PAADMDr))=0 "-1!没有就诊Dr对应的医保登记信息"
	s AdmInfoDr="",InsuAdmCenter="",InsuAdmInsuType=""
	s AdmInfoDr=$o(^DHCINADM("0","ADM",PAADMDr,AdmInfoDr),-1)
	s AdmInfo=$g(^DHCINADM(AdmInfoDr))	
	s ActFlag=$p(AdmInfo,"^",11)	
	s InsuType=$p(AdmInfo,"^",18) 
	s PatType=$p(AdmInfo,"^",4) 
	s InAdmType=$p(AdmInfo,"^",4) 
	i (ActFlag="A")!(ActFlag="O") d
	.;s NewReadId=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKC021"_InsuType,PatType,6,HospDr)
	.s xString7=$p(AdmInfo,"^",36)
	.s NewReadId=##class(web.INSUDicDataCom).GetDicByCodeAndInd("insutype"_InsuType,xString7,6,HospDr)	;upt 根据险种类型取对应费别 20221014 HanZH
	.//s:(InsuType="00A")&&(NewReadId="") NewReadId=73   //不推荐这种写法
    .s:NewReadId="" NewReadId=admReaDrOld
	e  d
	.s NewReadId="1"
	//s Flag=##class(web.UDHCJFIPReg).IUpdateAdmReason(PAADMDr, admReaDrOld, NewReadId,UserDr, "")
	
	s Flag=##class(web.DHCIPBillReg).UpdateAdmReason(PAADMDr, admReaDrOld, NewReadId,UserDr,"") //+DingSH 20201223
	
	q:Flag["费别未发生变化" 0  //DingSH 20210721
	
	;更新医保手册号 DingSH 20190110
	i ((PapmiDr'="")&&(InsuId'=""))  d
	.&sql(update PA_PatMas set PAPMI_HealthFundNo=:InsuId  where PAPMI_RowId1=:PapmiDr )
	
	
	q Flag
}

/// 功能描述:根据 医保类型(insutype),获取字典配置中 入院日期是否允许修改
/// Kongjian 20180516
/// OutPut    : 成功与否标识!返回信息
/// w ##class(web.DHCINSUIPReg).CheckAdmDateIsModify("ZZB")
ClassMethod CheckAdmDateIsModify(InsuType As %String) As %String
{
    n (InsuType)
	q:$g(InsuType)="" "-1!入参Insutype为空"
	s Flag=+##class(web.DHCINSUPort).GetDicByCodeAndInd("HISPROPerty"_InsuType,"AdmDateIsEdit",4)
	q Flag
}

/// 根据病案号获取病人登记号
/// DingSH 20200527 入参增加院区
/// w ##class(web.DHCINSUIPReg).GetPatNoByMrNo("100302","I",2)
ClassMethod GetPatNoByMrNo(MrNo As %Library.String, MedType As %String, HospDr As %Library.String = "")
{
	n (MrNo,MedType,HospDr)
	s errMsg="",PatNo=""
    s papmiDr=##Class(web.DHCINSUPortUse).IGetPatientIDByMrNo(MrNo,MedType,HospDr,.errMsg)
	s:papmiDr PatNo=$P(^PAPER(papmiDr,"PAT",1),"^",1)
	q PatNo
}

/// 取病种信息
/// 20221021 HanZH
/// D ##class(%ResultSet).RunQuery("web.DHCINSUIPReg","GetInsuDise","剖宫","00A","52","2")
Query GetInsuDise(InsuInDiagDesc As %String, InsuType As %String, MedType As %String, HospDr As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

/// DingSH 20200526 入参 AdmReasonDesc 修改成 InsuType
/// DingSH 20200526 入参 增加 HospDr
ClassMethod GetInsuDiseExecute(ByRef qHandle As %Binary, InsuInDiagDesc As %String, InsuType As %String, MedType As %String, HospDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	set ^TMP("GetInsuDise")=$lb(InsuInDiagDesc, InsuType, MedType, HospDr)
	s ind=1
	Set qHandle=$lb(0,repid,0) 
	q:InsuType="" $$$OK
	s actDate=+$h ;DingSH 20160414
	//根据院区取医保分组默认院区的ID  +WangXQ 20220721
	s:(HospDr="")&&($g(%session)'="") HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_Diagnosis",HospDr)  
	//set:AdmReasonDesc="CCXKS" AdmReasonDesc="CCCNew"
	s InsuInDiagDesc=$$ALPHAUP^SSUTIL4(InsuInDiagDesc)
	;s InsuInDiagDesc=##class(web.DHCINSUPort).GetCNCODE(InsuInDiagDesc,4,"")
	s rowid="0"
	f  s rowid=$o(^DHCINDiagnos(rowid)) q:rowid=""  d
	.s tmpInsuType=$p(^DHCINDiagnos(rowid),"^",1)
	.s Code=$p(^DHCINDiagnos(rowid),"^",2)
	.s Desc=$p(^DHCINDiagnos(rowid),"^",3)
	.s pym=$p(^DHCINDiagnos(rowid),"^",4)
	.q:(pym'[InsuInDiagDesc)&&(Desc'[InsuInDiagDesc) ;tangzf 2019-3-25 add 汉字检索
	.s Cate=$p(^DHCINDiagnos(rowid),"^",7)	//取病种类型 INDIS_Cate(M:慢特病病种; B:按病种结算病种; R:日间手术病种)
	.q:Cate=""
	.s SubCate=$p(^DHCINDiagnos(rowid),"^",8)	//取病种对应的就诊类型和医疗类别INDIS_SubCate IP|52
	.s:SubCate'="" tAdmType=$p(SubCate,"|",1),tMedType=$p(SubCate,"|",2)
	.q:tMedType'=MedType
	.s AdmType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_type"_InsuType,MedType,9,HospDr)
	.q:tAdmType'=AdmType
	.s tHospDr=$p(^DHCINDiagnos(rowid),"^",25) //+ DingSH 20200526
	.q:tHospDr'=GroupHospDr
	.s tactDate=+$p(^DHCINDiagnos(rowid),"^",13) ;没开始生效的过滤掉 DingSH 20160414
	.q:tactDate>actDate
	.q:tmpInsuType'=InsuType
	.d Build2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build2   
	set Data=$lb(rowid,Code,Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetInsuDiseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInsuDiseExecute ]
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

ClassMethod GetInsuDiseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInsuDiseExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// 根据医院Id,医保类型,手术标准目录ID(模糊查询)、章(模糊查询),HIS下载批次号,版本号查询目录信息
/// 入参说明:
/// 		QryType:检索类型(0:全部,1:按条件查找)
///          StDate:开始日期
///          EndDate:结束日期
///          HospId:医院Id(CT_Hospital,不能为空)
///          HiType:医保类型(00A)
///          Code:目录编码(关键字)
///          Desc:药品商品名名称(关键字)
///          HisBatch:检索类型(0:按HIS创建日期查找,1:按HIS下载批次号查找,2:手术标准目录ID(模糊查询)查找,章(模糊查询)查找)
///          Ver:版本号
Query QueryOPRNOPRTLISTNEW(QryType, StDate, EndDate, HospId, HiType, Code, Desc, HisBatch, Ver) As websys.Query(CONTAINID = 1, ROWSPEC = "Ind,Rowid:%String,HospId:%String,HiType:%String,OprnStdListId:%String,Cpr:%String,CprCodeScp:%String,Cprname:%String,CGyCode:%String,CgyName:%String,SorCode:%String,SorName:%String,DtlsCode:%String,DtlsName:%String,OprnOprtCode:%String,OprnOprtName:%String,UsedStd:%String,RtlOprnOprtCode:%String,RtlOprnOprtName:%String,ClncOprnOprtCode:%String,ClncOprnName:%String,Memo:%String,ValiFlag:%String,Rid:%String,CrteTime:%String,UpdtTime:%String,Ver:%String,VerName:%String,HisBatch:%String,HisCrterId:%String,HisCrteDate:%String,HisCrteTIme:%String,HisUpdtId:%String,HisUpdtDate:%String,HisupdtTime:%String,HiTypeDesc:%String,HisCrterName:%String,HisUpdtName:%String")
{
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUIPReg","QueryOPRNOPRTLISTNEW","2021-08-01","2021-08-30","2","00A","","","","")
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUIPReg","QueryOPRNOPRTLISTNEW","","","2","00A","","","J003_20210115200000_C","")
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUIPReg","QueryOPRNOPRTLISTNEW","","","2","00A","253a0ee3-1737-11ea-99e3-fa163e0a8baf","","","")
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUIPReg","QueryOPRNOPRTLISTNEW","","","2","00A","00.01","","","")
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUIPReg","QueryOPRNOPRTLISTNEW","","","","2","00A","","治疗","","")
ClassMethod QueryOPRNOPRTLISTNEWExecute(ByRef qHandle As %Binary, QryType, StDate, EndDate, HospId, HiType, Code, Desc, HisBatch, Ver) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:$g(HospId)="" $$$OK
	q:$g(HiType)="" $$$OK
	s:$l(StDate)=10 StDate=$zdh(StDate,3)
	s:$l(EndDate)=10 EndDate=$zdh(EndDate,3)
	s Flag=0
	s ^Temp("OPRNOPRTLISTIPREG")=$lb(QryType,StDate, EndDate, HospId, HiType, Code, Desc, HisBatch, Ver)
	
	//根据代码模糊查询
	i (+Flag=0)&&(Code'="") d
	.s OprnOprtCode=""
	.f  s OprnOprtCode=$O(^CT.INSU.MI.OPRNOPRTLISTI("IdxOprnOprtCode",HospId,OprnOprtCode)) q:OprnOprtCode=""  d
	..q:OprnOprtCode'[Code
	..s RowId=""
	..f  s RowId=$O(^CT.INSU.MI.OPRNOPRTLISTI("IdxOprnOprtCode",HospId,OprnOprtCode,RowId)) q:RowId=""  d
	...d BdLInfoNew
	...s Flag=1
	//根据描述模糊查询
	i (+Flag=0)&&(Desc'="") d
	.s OprnOprtName=""
	.f  s OprnOprtName=$O(^CT.INSU.MI.OPRNOPRTLISTI("IdxOprnOprtName",HospId,OprnOprtName)) q:OprnOprtName=""  d
	..q:OprnOprtName'[Desc
	..s RowId=""
	..f  s RowId=$O(^CT.INSU.MI.OPRNOPRTLISTI("IdxOprnOprtName",HospId,OprnOprtName,RowId)) q:RowId=""  d
	...d BdLInfoNew
	...s Flag=1
	//根据HIS创建日期查找
	i (+Flag=0)&&(StDate'="")&&(EndDate'="") d
	.f date=StDate:1:EndDate d
	..s RowId=""
	..f  s RowId=$o(^CT.INSU.MI.OPRNOPRTLISTI("IdxHISCRTEDATE",HospId,date,RowId)) q:RowId=""  d
    ...d BdLInfoNew
    ...s Flag=1
	//根据下载批次号查询
	i (+Flag=0)&&(HisBatch'="") d
	.s RowId=""
	.f  s RowId=$O(^CT.INSU.MI.OPRNOPRTLISTI("IdxHISBATCH",HospId,HisBatch,RowId)) q:RowId=""  d
	..d BdLInfoNew
	..s Flag=1
	//根据版本号查询
	Quit $$$OK
BdLInfoNew
	s TMPInfo=$g(^CT.INSU.MI.OPRNOPRTLISTD(RowId))
	s tHiType=$lg(TMPInfo,3)
	
	q:tHiType'=HiType
	s tHisBatch=$lg(TMPInfo,28)
	
	q:(HisBatch'="")&&(tHisBatch'=HisBatch)
	
	s tVer=$lg(TMPInfo,26)
	q:(Ver'="")&&(tVer'=Ver)
	//DingSH 20210924 增加过滤条件
    s tCode=$lg(TMPInfo,14)
	q:(Code'="")&&(tCode'[Code)
	s tDesc=$lg(TMPInfo,15)
	q:(Desc'="")&&(tDesc'[Desc)
	s tHospId=$lg(TMPInfo,2)
	//st格式化数据
	 s (HiscrteDate,HiscrteTime,HisupdtDate,HisupdtTime)=""
	 i $lg(TMPInfo,30)'="" d
	 .s HiscrteDate=$zd($lg(TMPInfo,30),3)   //HIS创建日期 
	 i $lg(TMPInfo,31)'="" d
	 .s HiscrteTime=$zt($lg(TMPInfo,31))     //HIS创建时间
	 i $lg(TMPInfo,33)'="" d
	 .s HisupdtDate=$zd($lg(TMPInfo,33),3)   //HIS更新日期
	 i $lg(TMPInfo,34)'="" d
	 .s HisupdtTime=$zt($lg(TMPInfo,34))     //HIS创建时间
	 s HiTypeDesc=""
	 s HiTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",HiType,4,tHospId) //DingSH 20211205 
	 s HisCrterName="",UserInfo=""
	 s HisCrterId=$lg(TMPInfo,29)
	 s HisUpdtId=$lg(TMPInfo,32)
	 s:+HisCrterId>0 UserInfo=##class(web.INSUBase).GetUserStr(HisCrterId)          ////DingSH 20211205 
	 s:+UserInfo>=0 HisCrterName=$P($g(UserInfo),"^",2)
	 s:+HisUpdtId>0 UserInfo=##class(web.INSUBase).GetUserStr(HisUpdtId)            ////DingSH 20211205 
	 s:+UserInfo>=0 HisUpdtName=$P($g(UserInfo),"^",2)
	 
	 
	 
	//ed格式化数据
	;b ;w 
	d BuildQryNew
	
	q
BuildQryNew 	
	set Data=$lb(ind,RowId,$lg(TMPInfo,2),$lg(TMPInfo,3),$lg(TMPInfo,4),$lg(TMPInfo,5),$lg(TMPInfo,6),$lg(TMPInfo,7),$lg(TMPInfo,8),$lg(TMPInfo,9),$lg(TMPInfo,10)
	,$lg(TMPInfo,11),$lg(TMPInfo,12),$lg(TMPInfo,13),$lg(TMPInfo,14),$lg(TMPInfo,15),$lg(TMPInfo,16),$lg(TMPInfo,17),$lg(TMPInfo,18),$lg(TMPInfo,19),$lg(TMPInfo,20)
	,$lg(TMPInfo,21),$lg(TMPInfo,22),$lg(TMPInfo,23),$lg(TMPInfo,24),$lg(TMPInfo,25),$lg(TMPInfo,26),$lg(TMPInfo,27),$lg(TMPInfo,28),$lg(TMPInfo,29)
	,HiscrteDate,HiscrteTime,$lg(TMPInfo,32),HisupdtDate,HisupdtTime,HiTypeDesc,HisCrterName,HisUpdtName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 取医保区划
/// 20230410 HanZH
/// D ##class(%ResultSet).RunQuery("web.DHCINSUIPReg","GetAdmdvs","110","00A","2")
Query GetAdmdvs(Admdvs As %String, InsuType As %String, HospDr As %String) As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String")
{
}

ClassMethod GetAdmdvsExecute(ByRef qHandle As %Binary, Admdvs As %String, InsuType As %String, HospDr As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	set ^TMP("GetAdmdvs")=$lb(Admdvs, InsuType, HospDr)
	s ind=1
	Set qHandle=$lb(0,repid,0) 
	q:InsuType="" $$$OK
	s actDate=+$h ;DingSH 20160414
	//根据院区取医保分组默认院区的ID  +WangXQ 20220721
	s:(HospDr="")&&($g(%session)'="") HospDr=$g(%session.Data("DHCBILLINSUCloud.Hospital"))
	s GroupHospDr=##class(web.DHCBILLINSUCloudCommon).GetINSUGroupDefaultHospId("INSU_DicData",HospDr)  
	s DicType="admdvs"_InsuType
	s DicRowid=""
  	f  s DicRowid=$o(^DHCINDID("0","IType",DicType,DicRowid)) q:(DicRowid="")  d
	.s DicStr=^DHCINDID(DicRowid)
	.s tDicCode=$p(DicStr,"^",2)	//代码
	.s tDicDesc=$p(DicStr,"^",3)	//描述
	.s tHospDr=$p(DicStr,"^",15)
	.q:tHospDr'=GroupHospDr
	.q:(tDicCode'[Admdvs)&&(tDicDesc'[Admdvs)	//检索
	.d BuildAdmdvs

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

BuildAdmdvs 
	set Data=$lb(rowid,tDicCode,tDicDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod GetAdmdvsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAdmdvsExecute ]
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

ClassMethod GetAdmdvsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAdmdvsExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

}
