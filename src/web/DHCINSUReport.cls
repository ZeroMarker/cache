/// 医保组统计数据统一接口
Class web.DHCINSUReport Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock, Not SqlRowIdPrivate ]
{

/// Creator DingSH
/// Date  2015-12-21
/// 入参:
/// StDate:         结算开始开始,即 InsuDivide.inpay_iDate
/// EndDate:        结算结束日期,即 InsuDivide.inpay_iDate
/// DivFlag:        结算状态串(,分割), 即 InsuDivide.inpay_Flag,   例如 B,S,I
/// InsuPatType		医保人员类型串(|分割),即 InsuAdminfo.inadm_PatType  ,    11|12
/// InsuAdmType		医保就诊类型串(|分割),即 InsuAdminfo.inadm_AdmType
/// InsuCenterID	医保统筹区(|分割),对应 InsuAdminfo.inadm_center或Inadm_states因项目而异
/// InsuType		医保类型,例如 ZZB：郑州市医保 ZZA:郑州省医保
/// HisAdmType		HIS就诊类型,例如 I:住院 O:门诊 E:急诊 
/// RepType		    报表类型,暂时无用,例如 OP01:上街区门诊职工生育明细表
/// InvNo		    发票号,即 DHCInvPrt.Inv
/// InsuId		    医保个人编号,即InsuAdminfo.inadm_insuId	
/// InName		    姓名,患者姓名
/// FileNo		    病案号
/// PapmiNo		    登记号,即Pa_PatMast.PAPMI_No
/// ShwTypes 		显示信息类型(是否忽略影响查询速度慢的字段),格式说明(0|0|0|0|0|0|0|0|0|0)：是否取病案号(0,1)|是否取年龄(0,1)|是否取就诊时间(0,1)|是否取出院时间(0,1)|是否取诊断集合信息(0,1)|是否取医保就诊信息(0,1)|是否取医保结算信息(0,1)|是否取HIS基本信息(0,1)|是否取费用分类信息(0,1)|是否取医保费用分类信息(0,1)
/// DivUserDr       结算操作员:Insu_divide.Inpay_sUserDr
/// HospDr          当前登录院区指针
/// 出参:
/// 医保就诊信息+医保结算信息+HIS基本诊信息+HIS就诊信息+费用分类信息
Query INSURepQuery(StDate As %String, EndDate As %String, DivFlag As %String, InsuPatType As %String, InsuAdmType As %String, InsuCenterID As %String, InsuType As %String, HisAdmType As %String, RepType As %String, InvNo As %String, InsuId As %String, InName As %String, FileNo As %String, PapmiNo As %String, ShwTypes As %String = "", DivUserDr As %String = "", HospDr As %String = "") As %Query(ROWSPEC = "TInd,INADMRowid:%String,INADMAdmDr:%String,INADMInsuId:%String,INADMCardNo:%String,INADMPatType:%String,INADMCardStatus:%String,INADMCompany:%String,INADMStates:%String,INADMCenter:%String,INADMAccount:%String,INADMAdmSeriNo:%String,INADMActiveFlag:%String,INADMAdmDate:%String,INADMAdmTime:%String,INADMAdmType:%String,INADMDeptDesc:%String,INADMInsuUser:%String,INADMIpTimes:%String,INADMInsuType:%String,INADMAdmCancelNo:%String,INADMOutDate:%String,INADMOutTime:%String,INADMOutUser:%String,INADMUserDr:%String,INADMFunDate:%String,INADMFunTime:%String,INADMXString1:%String,INADMXString2:%String,INADMXString3:%String,INADMXString4:%String,INADMXFloat1:%String,INADMXFloat2:%String,INADMXFloat3:%String,INADMXFloat4:%String,INADMXString5:%String,INADMXString6:%String,INADMXString7:%String,INADMXString8:%String,INADMXString9:%String,INADMXString10:%String,INADMXString11:%String,INADMXString12:%String,INADMXString13:%String,INADMXString14:%String,INADMXString15:%String,INADMXString16:%String,INADMXString17:%String,INADMXString18:%String,INADMXString19:%String,INADMXString20:%String,InsuAdmInfoDr:%String,INPAYRowid:%String,INPAYAdmDr:%String,INPAYAdmInfoDr:%String,INPAYDHCpblDr:%String,INPAYDhcInvPrtDr:%String,INPAYFlag:%String,INPAYINSUDivideDr:%String,INPAYbcbxf0:%String,INPAYdjlsh0:%String,INPAYbckbcs:%String,INPAYbqbm00:%String,INPAYbrnl00:%String,INPAYcardno:%String,INPAYcfms0:%String,INPAYcrbcts:%String,INPAYgrzfe0:%String,INPAYiDate:%String,INPAYiTime:%String,INPAYid0000:%String,INPAYjjzfe0:%String,INPAYptbcts:%String,INPAYsUserDr:%String,INPAYsfrq00:%String,INPAYsfrm0:%String,INPAYsfsj00:%String,INPAYsftsbz:%String,INPAYbie00:%String,INPAYming0:%String,INPAYzhzfe0:%String,INPAYzyksmc:%String,INPAYzylsh0:%String,INPAYInsuPay1:%String,INPAYInsuPay2:%String,INPAYInsuPay3:%String,INPAYInsuPay4:%String,INPAYInsuPay5:%String,INPAYZstr01:%String,INPAYZstr02:%String,INPAYZstr03:%String,INPAYZstr04:%String,INPAYZstr05:%String,INPAYZstr06:%String,INPAYZstr07:%String,INPAYZstr08:%String,INPAYZstr09:%String,INPAYZstr10:%String,INPAYInsuPay6:%String,INPAYInsuPay7:%String,INPAYInsuPay8:%String,INPAYInsuPay9:%String,INPAYInsuPay10:%String,INPAYZstr11:%String,INPAYZstr12:%String,INPAYZstr13:%String,INPAYZstr14:%String,INPAYZstr15:%String,INPAYZstr16:%String,INPAYZstr17:%String,INPAYZstr18:%String,INPAYZstr19:%String,INPAYZstr20:%String,INPAYZstr21:%String,INPAYZstr22:%String,INPAYZstr23:%String,INPAYZstr24:%String,INPAYZstr25:%String,INPAYZstr26:%String,INPAYZstr27:%String,INPAYZstr28:%String,INPAYZstr29:%String,INPAYZstr30:%String,PAPMIRowid:%String,PAPMINo:%String,PAPMIMedicare:%String,PAPMIName:%String,PAPMISex:%String,PAPMIAge:%String,PAPMIPatId:%String,PAPMITelephone:%String,PAPMIAddress:%String,PAPMICompany:%String,PAADMRowid:%String,AADMDocDesc:%String,PAADMAdmDate:%String,PAADMAdmTime:%String,PAADMOutDate:%String,PAADMOutTime:%String,PAADMInDepCode:%String,PAADMInDepDesc:%String,PAADMOutDepCode:%String,PAADMOutDepDesc:%String,PAADMInDiagCode:%String,PAADMInDiagDesc:%String,PAADMMainDiagCode:%String,PAADMMainDiagDesc:%String,PAADMOutDiagCode:%String,PAADMOutDiagDesc:%String,PAADMUserDr:%String,PAADMOutStatus:%String,PAADMIPDays:%String,PAADMBedNo:%String,DivInvNo:%String,ZlFee:%String,JCFee:%String,SsFee:%String,GhFee:%String,HlFee:%String,CwFee:%String,ZCFee:%String,HyFee:%String,SxFee:%String,ClFee:%String,ZCaoYFee:%String,ZCheFee:%String,XyFee:%String") [ SqlProc ]
{
}

ClassMethod INSURepQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = INSURepQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUReport","INSURepQuery","2020-10-23","2020-10-23","I","","","","","O","","","","","","")
ClassMethod INSURepQueryExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, DivFlag As %String, InsuPatType As %String, InsuAdmType As %String, InsuCenterID As %String, InsuType As %String, HisAdmType As %String, RepType As %String, InvNo As %String, InsuId As %String, InName As %String, FileNo As %String, PapmiNo As %String, ShwTypes As %String = "", DivUserDr As %String = "", HospDr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:$g(StDate)="" $$$OK
	q:$g(EndDate)="" $$$OK
	i PapmiNo'="" d
	.s PapmiNo="0000000000"_PapmiNo
    .s PapmiNo=$EXTRACT(PapmiNo,*-9,*)
    s:InsuPatType="null" InsuPatType=""
	s:InsuAdmType="null" InsuAdmType=""
	s:HisAdmType="null" HisAdmType=""
	s:InsuType="null" InsuType=""
	s:InsuCenterID="null" InsuCenterID=""
	s ^CacheTMP("ZZRepQuery")=StDate_"^"_EndDate_"^"_DivFlag_"^"_InsuPatType_"^"_InsuAdmType_"^"_InsuCenterID_"^"_HisAdmType_"^"_InsuType_"^"_RepType_"^"_InvNo_"^"_InsuId_"^"_InName_"^"_FileNo_"^"_PapmiNo_"^"_ShwTypes_"^"_DivUserDr_"^"_HospDr
	//s:$l(StDate)=10 StDate=$zdh(StDate,4)
	//s:$l(EndDate)=10 EndDate=$zdh(EndDate,4)
	s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s UserName="",ErrMsg=""
	b ;00
	;对部分入参进行赋值-Start
	if RepType'="" d
	.;医疗人员类型 InsuPatType
	.s tmpInsuPatType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("RepTypeCnPatType"_InsuType,RepType,6,HospDr)
	.s:tmpInsuPatType'="" InsuPatType=tmpInsuPatType
	.;医疗就诊类型 InsuAdmType
	.s tmpInsuAdmType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("RepTypeCnAdmType"_InsuType,RepType,6,HospDr)
	.s:tmpInsuAdmType'="" InsuAdmType= tmpInsuAdmType
	;医疗统筹区 InsuCenterID
	.s tmpInsuCenterID=##class(web.INSUDicDataCom).GetDicByCodeAndInd("RepTypeCenterID"_InsuType,RepType,6,HospDr)
	.s InsuCenterID=tmpInsuCenterID
	
    ;对部分入参进行赋值-End
	f date=StDate:1:EndDate d
	.s INPAYID=""
	.f  s INPAYID=$o(^DHCINDIV("0","IDate",date,INPAYID)) q:INPAYID=""  d
	..s Divinfo=$g(^DHCINDIV(INPAYID))
	..s (TIPDays,TAge,TBedNo)="" ;变量初始化
	..q:$l(Divinfo,"^")<2
	..s PAADM=$p(Divinfo,"^",1)
	..q:PAADM=""
	..s DHCpblDr=$p(Divinfo,"^",3)
	..s PAPMIDR=$p(^PAADM(PAADM),"^",1)
	..s TmpHisADMType=$p(^PAADM(PAADM),"^",2) ;HIS就诊类型
	..s:TmpHisADMType="E" TmpHisADMType="O"
	..s:TmpHisADMType="H" TmpHisADMType="O"
	..q:(TmpHisADMType'=HisAdmType)&&(HisAdmType'="")
	..s InPayFlag=$p(Divinfo,"^",5) ;结算状态
	..s tDivUserDr=$P(Divinfo,"^",21)
	..;q:(InPayFlag'=DivFlag)&(DivFlag'="") 
	..q:(DivFlag'="")&((","_DivFlag_",")'[(","_InPayFlag_","))
	..q:(DivUserDr'="")&((","_DivUserDr_",")'[(","_tDivUserDr_","))
	..s InadmDr=$p(Divinfo,"^",2)   //insu_adminfo
	..q:InadmDr=""
	..s Adminfo=$g(^DHCINADM(InadmDr))
	..s TmpInsuType=$p(Adminfo,"^",18) ;医保类型
	..q:(TmpInsuType'=InsuType)&(InsuType'="")
	..s TmpInsuCenterID=$p(Adminfo,"^",7) ;统筹区号
	..q:(InsuCenterID'="")&(("|"_InsuCenterID_"|")'[("|"_TmpInsuCenterID_"|"))
	..;(TmpInsuCenterID'=InsuCenterID)
	..s TmpInsuAdmType=$p(Adminfo,"^",14)  ;医疗类别
	..s:InsuAdmType="*" InsuAdmType=""
	..q:(InsuAdmType'="")&(("|"_InsuAdmType_"|")'[("|"_TmpInsuAdmType_"|")) 
	..;q:(InsuAdmType'="")&&(TmpInsuAdmType'=InsuAdmType)
	..s TmpInsuPatType=$p(Adminfo,"^",4)   ;人员类型
	..s:InsuPatType="*" InsuPatType=""
	..q:(InsuPatType'="")&(("|"_InsuPatType_"|")'[("|"_TmpInsuPatType_"|"))
	..s PAdmInfo="" 
	..s ShwPAdmTypes=$P(ShwTypes,"|",3,5)
	..s ShwPAdmTypes="1|1|1"
	..s PAdmInfo=##class(web.DHCINSUPatInfo).GetAdmInfoByAdmIDRep(PAADM,ShwPAdmTypes) ;获取Adm就诊信息PAdmInfo
	..s PapmiInfo=""
	..s ShwPapmiTypes=$P(ShwTypes,"|",1,2)
	..s ShwPapmiTypes="1|1"
	..s tHospDr=##class(web.UDHCHospitalGroup).GetHospitalByAdm(PAADM)
	..q:(tHospDr'=HospDr)&(HospDr'="")
	..s PapmiInfo=##class(web.DHCINSUPatInfo).GetPatInfoByPatIDRep(PAPMIDR,ShwPapmiTypes,tHospDr) ;获取Pa_PatMast信息
	..s tmpInsuId=$p(Adminfo,"^",2) ;医保个人编号
	..q:(InsuId'="")&(InsuId'=tmpInsuId)
	..s InvprtDr=$p(Divinfo,"^",4)
	..s BillNo=$p(Divinfo,"^",3)
	..s:TmpHisADMType="O" tmpInvNo=..GetInvNo("",InvprtDr,"")
	..s:TmpHisADMType="I" tmpInvNo=..GetInvNo(BillNo,"","")
	..s:tmpInvNo="" tmpInvNo=..GetInvNo("","",INPAYID)
	..s DivInvNo=tmpInvNo
	..q:(InvNo'=tmpInvNo)&(InvNo'="")
	..s tmpPapmino=$p(PapmiInfo,"^",2) ;登记号
	..q:(PapmiNo'="")&(PapmiNo'=tmpPapmino)
	..s tmpInName=$p(PapmiInfo,"^",3) ;姓名
	..q:(InName'="")&(tmpInName'[InName)
	..s PAPMIMedicare=""
	..i HisAdmType="I"  d  s PAPMIMedicare=$p(PapmiInfo,"^",15) ;病案号
	..e  d 
	...s:+$P(ShwTypes,"|",1)=1 PAPMIMedicare=##Class(web.DHCINSUPortUse).IGetMrNoByEpisodeID(PAADM,HisAdmType,.ErrMsg)
	...s:+$P(ShwTypes,"|",1)=0 ErrMsg=":"
	..s:PAPMIMedicare="" PAPMIMedicare=$p(ErrMsg,":",2)
	..q:(FileNo'="")&(FileNo'=PAPMIMedicare)
	
	..;st 数据的部分处理
	..;1 st-- 对医保就诊信息格式化
	..s tmpInsuPatTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKC021"_TmpInsuType,TmpInsuPatType,4,tHospDr)
	..s tmpInsuAdmTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA130"_TmpInsuType,TmpInsuAdmType,4,tHospDr)
	..s:(TmpInsuType="00A")&&(tmpInsuPatTypeDesc="") tmpInsuPatTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("psn_type"_TmpInsuType,TmpInsuPatType,4,tHospDr)  
	..s:(TmpInsuType="00A")&&(tmpInsuAdmTypeDesc="") tmpInsuAdmTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_type"_TmpInsuType,TmpInsuAdmType,4,tHospDr)
	..s:tmpInsuPatTypeDesc'="" $p(Adminfo,"^",4)=tmpInsuPatTypeDesc
	..s:tmpInsuAdmTypeDesc'="" $p(Adminfo,"^",14)=tmpInsuAdmTypeDesc
	..s tmpSex=$p(Adminfo,"^",36)
	..s tmpSexDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AAC004"_TmpInsuType,tmpSex,4,tHospDr)
	..s:tmpSexDesc'="" tmpSex=tmpSexDesc
	..s InsuTypeDesc=##Class(web.INSUDicDataCom).GetDicByCodeAndInd("DLLType",$p(Adminfo,"^",18),4,tHospDr)
	..s:InsuTypeDesc'="" $p(Adminfo,"^",18)=InsuTypeDesc   ;医保类型
	..s $p(Adminfo,"^",36)=tmpSex
	..s tmpDepDesc="" ;科室
	..s tmpDepDesc=$p(Adminfo,"^",15)
	..s tmpDepDesc=$p(tmpDepDesc,"-",2)
	..s $p(Adminfo,"^",15)=tmpDepDesc
	..;s DicType="InsuCenter"_TmpInsuType
	..;s:TmpInsuType="ZZA" DicType="InsuCenterZZA" ;测试用
	..;s:TmpInsuType="ZZB" DicType="InsuCenterZZB"
	..;s:TmpInsuType="ZZC" DicType="StatesZZC"
	..;s:TmpInsuType="ZZF" DicType="InsuCenterZZF"
	..s DicType="YAB003"_TmpInsuType
	..s tmpStateDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd(DicType,TmpInsuCenterID,4,tHospDr)
	..s:(TmpInsuType="00A")&&(tmpStateDesc="") tmpStateDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("admdvs"_TmpInsuType,TmpInsuCenterID,4,tHospDr)
	..s:tmpStateDesc'="" $p(Adminfo,"^",7)=tmpStateDesc
	..;2 ed-- 对医保就诊信息格式化
	..;st -- 对医保结算信息格式化处理 
	..s $p(Divinfo,"^",5)=$case($p(Divinfo,"^",5),"D":"预结算","I":"正常","B":"被冲销","S":"冲销",:"其他")
	..i $p(Divinfo,"^",5)="作废"  d
	...s $p(Divinfo,"^",7)=-$p(Divinfo,"^",7),$p(Divinfo,"^",31)=-$p(Divinfo,"^",31),$p(Divinfo,"^",32)=-$p(Divinfo,"^",32),$p(Divinfo,"^",35)=-$p(Divinfo,"^",35)
	...s $p(Divinfo,"^",15)=-$p(Divinfo,"^",15),$p(Divinfo,"^",33)=-$p(Divinfo,"^",33),$p(Divinfo,"^",34)=-$p(Divinfo,"^",34),$p(Divinfo,"^",46)=-$p(Divinfo,"^",46)
	...s $p(Divinfo,"^",28)=-$p(Divinfo,"^",28),$p(Divinfo,"^",47)=-$p(Divinfo,"^",47),$p(Divinfo,"^",48)=-$p(Divinfo,"^",48),$p(Divinfo,"^",49)=-$p(Divinfo,"^",49)
	...s $p(Divinfo,"^",15)=-$p(Divinfo,"^",15),$p(Divinfo,"^",19)=-$p(Divinfo,"^",19) //+ DingSH 20191030
	..s $p(Divinfo,"^",16)=$zd($p(Divinfo,"^",16),3)
	..s $p(Divinfo,"^",17)=$zt($p(Divinfo,"^",17))
	..s $p(Divinfo,"^",36)=$case($p(Divinfo,"^",36),"R":"挂号","F":"收费",:"其他")
	..s $p(Divinfo,"^",37)=$case($p(Divinfo,"^",37),"M":"中途结算","F":"最终结算",:"其他")
	..s $p(Divinfo,"^",38)=$case($p(Divinfo,"^",38),"01":"现金结算","02":"集中打印模式","10":"本地算法","20":"自助机结算",:"其他")
	..;2 ed -- 对医保结算信息格式化处理 
	
	
	..;3 st -- 对HIS人员基本信息格式化处理 
	..s PAPMIRowid=$p($P(PapmiInfo,"^",1),"!",2) ;
	..s PAPMINo=$p(PapmiInfo,"^",2) ;
	..s PAPMIName=$p(PapmiInfo,"^",3) ;
	..s PAPMISex=$p(PapmiInfo,"^",5) ;
	..s PAPMIAge=$p(PapmiInfo,"^",4) ;
	..s PAPMIPatId=$p(PapmiInfo,"^",9) ;
	..s PAPMITelephone=$p(PapmiInfo,"^",7) ;
	..s PAPMIAddress=$p(PapmiInfo,"^",6) ;
	..s PAPMICompany=$p(PapmiInfo,"^",8) ;工作单位
				
	..;3 ed -- 对HIS人员基本信息格式化处理 
	
	..;4 st -- 对HIS就诊信息格式化处理 
	..s PAADMRowid=$p($P(PAdmInfo,"^",1),"!",2) ;
	..s PAADMDocDesc=$P(PAdmInfo,"^",9) ;就诊医生
	..s PAADMAdmDate=$P(PAdmInfo,"^",6) ;就诊日期
	..s PAADMAdmTime=$P(PAdmInfo,"^",7) ;就诊时间
	..s PAADMOutDate=$P(PAdmInfo,"^",10) ;出院日期
	..s PAADMOutTime=$P(PAdmInfo,"^",11) ;出院时间
	.. ;转科的需要处理
	..s TRANS="",TRANSinfo="",PAADMInDepDr=""
	..f  s TRANS=$o(^PAADM(PAADM,"TRANS",TRANS),-1) q:TRANS=""  d
    ...s TRANSinfo=^PAADM(PAADM,"TRANS",TRANS)
    ...q:$P(TRANSinfo,"^",6)=""
    ...s PAADMInDepDr=$P(TRANSinfo,"^",6) 
    ..i PAADMInDepDr'="" d
	...s Depcode=$p(^CTLOC(PAADMInDepDr),"^",1) //科室编号
	...s DepDesc=$p(^CTLOC(PAADMInDepDr),"^",2) //科室
	...s PAADMInDepCode=Depcode ;住院科室编码
	...s PAADMInDepDesc=DepDesc  ;住院科室名称
	..e  d
	...s PAADMInDepCode=$P(PAdmInfo,"^",4) ;住院科室编码
	...i $l($P(PAdmInfo,"^",5),"-")>1  d
	....s PAADMInDepDesc=$P($P(PAdmInfo,"^",5),"-",2) ;住院科室名称
	...e  d
	....s PAADMInDepDesc=$P($P(PAdmInfo,"^",5),"-",1) ;住院科室名称
	..s PAADMOutDepCode=$P(PAdmInfo,"^",4) ;出院科室编码
	
	..i $l($P(PAdmInfo,"^",5),"-")>1  d
	...s PAADMOutDepDesc=$P($P(PAdmInfo,"^",5),"-",2) ;
	..e  d
	...s PAADMOutDepDesc=$P($P(PAdmInfo,"^",5),"-",1) ;
	
	..s PAADMInDiagCode=$P(PAdmInfo,"^",22) ;入院诊断编码
	..s PAADMInDiagDesc=$P(PAdmInfo,"^",23) ;入院诊断名称
	..s PAADMMainDiagCode=$P(PAdmInfo,"^",22) ;主诊断编码 ？
	..s PAADMMainDiagDesc=$P(PAdmInfo,"^",23) ;主诊断名称 ？
	..s PAADMOutDiagCode=$P(PAdmInfo,"^",25) ;出院诊断编码
	..s PAADMOutDiagDesc=$P(PAdmInfo,"^",26) ;出院诊断名称
	..s PAADMUserDr=$P(PAdmInfo,"^",34) ;门诊挂号/住院登记操作员
	..s PAADMOutStatus=$P(PAdmInfo,"^",41) ;出院状态(治愈、好转、死亡等)
	..s PAADMIPDays=$P(PAdmInfo,"^",40) ;住院天数
	..s PAADMBedNo=$P(PAdmInfo,"^",19) ;床位号
    ..;5 st -取费用分类信息 
    ..s ShwFeeType=$P(ShwTypes,"|",9)
    ..s (ZlFee,JCFee,SsFee,GhFee,HlFee,CwFee,ZCFee,HyFee,SxFee,ClFee,ZCaoYFee,ZCheFee,XyFee)=0
    ..i +ShwFeeType=1   d
    ...;务必注意每个项目要修改如下代码
	...;治疗费|0^检查费|560^手术费|0^挂号费|0^护理费|0^床位费|0^诊查费|0^化验费|0^输血费|0^材料费|0^中草药费|0^中成药费|0^西药费|0
	...s AdmCateFeeInfo=""
	...s:TmpHisADMType="O" AdmCateFeeInfo=..GetCateFee(InvprtDr,"","FeeTypeCon"_InsuType)
	...s:TmpHisADMType="I" AdmCateFeeInfo=..GetCateFee("",BillNo,"FeeTypeCon"_InsuType)
	...s (ZlFee,JCFee,SsFee,GhFee,HlFee,CwFee,ZCFee,HyFee,SxFee,ClFee,ZCaoYFee,ZCheFee,XyFee)=0
	...s ZlFee=$P($P(AdmCateFeeInfo,"^",1),"|",2) ;治疗费
	...s JCFee=$P($P(AdmCateFeeInfo,"^",2),"|",2) ;检查费
	...s SsFee=$P($P(AdmCateFeeInfo,"^",3),"|",2) ;手术费
	...s GhFee=$P($P(AdmCateFeeInfo,"^",4),"|",2) ;挂号费
	...s HlFee=$P($P(AdmCateFeeInfo,"^",5),"|",2) ;护理费
	...s CwFee=$P($P(AdmCateFeeInfo,"^",6),"|",2) ;床位费
	...s ZCFee=$P($P(AdmCateFeeInfo,"^",7),"|",2) ;诊查费
	...s HyFee=$P($P(AdmCateFeeInfo,"^",8),"|",2) ;化验费
	...s SxFee=$P($P(AdmCateFeeInfo,"^",9),"|",2) ;输血费
	...s ClFee=$P($P(AdmCateFeeInfo,"^",10),"|",2) ;材料费
	...s ZCaoYFee=$P($P(AdmCateFeeInfo,"^",11),"|",2) ;中草药费
	...s ZCheFee=$P($P(AdmCateFeeInfo,"^",12),"|",2) ;中成药费
	...s XyFee=$P($P(AdmCateFeeInfo,"^",13),"|",2) ;西药费
    ..;ZlFee,JCFee,SsFee,GhFee,HlFee,CwFee,ZCFee,HyFee,SxFee,ClFee,ZCaoYFee,ZCheFee,XyFee
	..;5 ed -取费用分类信息
	
	
	..;4 ed -- 对HIS就诊信息格式化处理 
	..;ed 数据的部分处理
	..d Build
	Quit $$$OK
	;具体字段值标示什么意思参见表结构说明
Build 	
	set Data=$lb(ind,InadmDr,$p(Adminfo,"^",1),$p(Adminfo,"^",2),$p(Adminfo,"^",3),$p(Adminfo,"^",4),$p(Adminfo,"^",5),$p(Adminfo,"^",6),$p(Adminfo,"^",7),$p(Adminfo,"^",8),$p(Adminfo,"^",9),$p(Adminfo,"^",10),$p(Adminfo,"^",11),
	$p(Adminfo,"^",12),$p(Adminfo,"^",13),$p(Adminfo,"^",14),$p(Adminfo,"^",15),$p(Adminfo,"^",16),$p(Adminfo,"^",17),$p(Adminfo,"^",18),$p(Adminfo,"^",19),$p(Adminfo,"^",20),$p(Adminfo,"^",21),$p(Adminfo,"^",22),$p(Adminfo,"^",23),$p(Adminfo,"^",24),
	$p(Adminfo,"^",25),$p(Adminfo,"^",26),$p(Adminfo,"^",27),$p(Adminfo,"^",28),$p(Adminfo,"^",29),$p(Adminfo,"^",30),$p(Adminfo,"^",31),$p(Adminfo,"^",32),$p(Adminfo,"^",33),$p(Adminfo,"^",34),$p(Adminfo,"^",35),$p(Adminfo,"^",36),
	$p(Adminfo,"^",37),$p(Adminfo,"^",38),$p(Adminfo,"^",39),$p(Adminfo,"^",40),$p(Adminfo,"^",41),$p(Adminfo,"^",42),$p(Adminfo,"^",43),$p(Adminfo,"^",44),$p(Adminfo,"^",45),$p(Adminfo,"^",46),$p(Adminfo,"^",47),$p(Adminfo,"^",48),$p(Adminfo,"^",49),
	$p(Adminfo,"^",50),
	INPAYID,$p(Divinfo,"^",1),$p(Divinfo,"^",2),$p(Divinfo,"^",3),$p(Divinfo,"^",4),$p(Divinfo,"^",5),$p(Divinfo,"^",6),$p(Divinfo,"^",7),$p(Divinfo,"^",8),$p(Divinfo,"^",9),$p(Divinfo,"^",10),
	$p(Divinfo,"^",11),$p(Divinfo,"^",12),$p(Divinfo,"^",13),$p(Divinfo,"^",14),$p(Divinfo,"^",15),$p(Divinfo,"^",16),$p(Divinfo,"^",17),$p(Divinfo,"^",18),$p(Divinfo,"^",19),$p(Divinfo,"^",20),
	$p(Divinfo,"^",21),$p(Divinfo,"^",22),$p(Divinfo,"^",23),$p(Divinfo,"^",24),$p(Divinfo,"^",25),$p(Divinfo,"^",26),$p(Divinfo,"^",27),$p(Divinfo,"^",28),$p(Divinfo,"^",29),$p(Divinfo,"^",30),
	$p(Divinfo,"^",31),$p(Divinfo,"^",32),$p(Divinfo,"^",33),$p(Divinfo,"^",34),$p(Divinfo,"^",35),$p(Divinfo,"^",36),$p(Divinfo,"^",37),$p(Divinfo,"^",38),$p(Divinfo,"^",39),$p(Divinfo,"^",40),
	$p(Divinfo,"^",41),$p(Divinfo,"^",42),$p(Divinfo,"^",43),$p(Divinfo,"^",44),$p(Divinfo,"^",45),$p(Divinfo,"^",46),$p(Divinfo,"^",47),$p(Divinfo,"^",48),$p(Divinfo,"^",49),$p(Divinfo,"^",50),
	$p(Divinfo,"^",51),$p(Divinfo,"^",52),$p(Divinfo,"^",53),$p(Divinfo,"^",54),$p(Divinfo,"^",55),$p(Divinfo,"^",56),$p(Divinfo,"^",57),$p(Divinfo,"^",58),$p(Divinfo,"^",59),$p(Divinfo,"^",60),
	$p(Divinfo,"^",61),$p(Divinfo,"^",62),$p(Divinfo,"^",63),$p(Divinfo,"^",64),$p(Divinfo,"^",65),$p(Divinfo,"^",66),$p(Divinfo,"^",67),$p(Divinfo,"^",68),$p(Divinfo,"^",69),$p(Divinfo,"^",70),
	PAPMIRowid, PAPMINo, PAPMIMedicare,PAPMIName,PAPMISex, PAPMIAge, PAPMIPatId,PAPMITelephone,PAPMIAddress,PAPMICompany,
	PAADMRowid,PAADMDocDesc,PAADMAdmDate, PAADMAdmTime,PAADMOutDate, PAADMOutTime, PAADMInDepCode,PAADMInDepDesc,PAADMOutDepCode, PAADMOutDepDesc,
    PAADMInDiagCode, PAADMInDiagDesc, PAADMMainDiagCode, PAADMMainDiagDesc,PAADMOutDiagCode, PAADMOutDiagDesc, PAADMUserDr,PAADMOutStatus,PAADMIPDays,PAADMBedNo,DivInvNo,ZlFee,JCFee,SsFee,GhFee,HlFee,CwFee,ZCFee,HyFee,SxFee,ClFee,ZCaoYFee,ZCheFee,XyFee)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod INSURepQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = INSURepQueryExecute ]
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

/// GetInvNo
/// Creator: DingSH  
/// Description:通过账单号或门诊发票ID,获得发票号
/// Input：BillNo 账单号,InvDr dhc_invprt.rowid
/// CreatDate:2015-12-21
/// Others: w ##class(web.DHCINSUReport).GetInvNo("","","747"),两个入参不能同时为空
/// Output:
/// 备注：
ClassMethod GetInvNo(BillNo As %String, InvDr As %String, InsuDivDr As %String) As %String
{
	n (BillNo,InvDr,InsuDivDr)
	s InvNo="未出院结算"
	;b ;00
	q:((+BillNo=0)&(+InvDr=0)&(+InsuDivDr=0))=1 InvNo
	
	i +InvDr >0 d
	.i $d(^DHCINVPRT(InvDr))=0 d
	..s InvNo="" ;"发票不存在 "
	.e  d 
	..s InvNo=$p($g(^DHCINVPRT(InvDr)),"^",14)
	..//s StayFlag=$p($g(^DHCINVPRT(InvDr)),"^",44) //是否留观结算 +DingSH 20200902
	..i (InvNo="") d 
	...s InvNo=..GetAccInvNoByPrtDr(InvDr)
	
	i +InsuDivDr >0 d
	.s DivMod="",DivFlag="",tAdmDr="",tAdmType="",tPrtDr=""
	.i $d(^DHCINDIV(InsuDivDr))=0 d
	..s InvNo=""   ;"发票不存在"
	.e  d 
	..s DivMod=$p(^DHCINDIV(InsuDivDr),"^",38) ; 01现金结算模式 02集中打印模式 10本地算法 20自助机
	..s DivFlag=$p(^DHCINDIV(InsuDivDr),"^",5)
	..s tAdmDr=$p(^DHCINDIV(InsuDivDr),"^",1)
	..s:tAdmDr'="" tAdmType=$P(^PAADM(tAdmDr),"^",2)
	..s tPrtDr=$P($p(^DHCINDIV(InsuDivDr),"^",4),"!",1)
	..s:tPrtDr'="" InvNo=$p($g(^DHCINVPRT(tPrtDr)),"^",14)
	.i DivMod="02" d
	..s InvNo=..GetAccInvNoByPrtDr(tPrtDr,DivFlag)
	.i tAdmType="H" d //+DingSH 20200915
	..s InvNo=$P($g(^DHCPEINVPRT(tPrtDr)),"^",1)
	.i tAdmType="I" d 
	..s BillNo =$p(^DHCINDIV(InsuDivDr),"^",3)
	i +BillNo >0 d
	.s InvzyID=""
	.f  s InvzyID=$o(^DHCINVPRTZY("0","AR",BillNo,InvzyID)) q:InvzyID=""  d
	..s InvZYInfo=$g(^DHCINVPRTZY(InvzyID))
	..s Flag=$P(InvZYInfo,"^",8)
	..s:Flag="A" InvNo="发票作废"
	..s:Flag="S" InvNo="发票冲红"
	..q:(Flag'="I")&(Flag'="N")
	..s InvNo=$P(InvZYInfo,"^",1)
	
	
	q InvNo
}

/// GetAccInvNo
/// Creator: DingSH  
/// Description:通过门诊发票ID集中打印发票号
/// Input：PrtDr:dhc_invprt.rowid,DivFlag:医保结算状态
/// CreatDate:2020-09-02
/// Others: w ##class(web.DHCINSUReport).GetAccInvNoByPrtDr("6087"),两个入参不能同时为空
/// Output:
/// 备注：
ClassMethod GetAccInvNoByPrtDr(PrtDr As %String, DivFlag As %String = "") As %String
{
	n (PrtDr,DivFlag)
	s InvNo=""
	s AccPayINVDr=""
	q:$g(PrtDr)="" InvNo
    s AccPayINVDr=$p($g(^DHCINVPRT(PrtDr)),"^",4)
	i +AccPayINVDr>0 d
	.s InvNo=$p($g(^DHCINVPRTAP(AccPayINVDr)),"^",6)
	.s OldAccPayINVDr=+$p($g(^DHCINVPRTAP(AccPayINVDr)),"^",22)
	.i ((OldAccPayINVDr>0)&&((DivFlag="B")||(DivFlag="S"))) d
	..s InvNo=$p($g(^DHCINVPRTAP(OldAccPayINVDr)),"^",6)
	
	q InvNo
}

/// DingSH
/// 20170418
/// 获取分类信息门诊传发票表InvDr,住院传账单号bill
/// w ##class(web.DHCINSUZZRep).GetCateFee("","249093","")
ClassMethod GetCateFee(InvDr, bill, FeeTypeCon)
{
	n (InvDr,bill,FeeTypeCon)
	;s FeeTypeCon="" ;根据项目需要启用 启用时请务必保证医保字典配置费用大类到医保分类的对照
	s job=$j,str="",Type=""
	k ^TMP("BILL","CateFee",job)
	k ^TMP("BILL","InsuCateFee",job)
	if (InvDr'=""){
		;s Type="TOC"
		s Type="CC"
		s Condr=""
		f  s Condr=$o(^DHCBCI(0,"INV",InvDr,Condr))  q:Condr=""  d
		.s Bill=$p($g(^DHCBCI(Condr)),"^",2)
		.s BillOrd=""
		.f  s BillOrd=$o(^DHCPB(Bill,"O",BillOrd))  q:BillOrd=""   d
		..s BillDetsub=""
		..f  s BillDetsub=$o(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub))   q:BillDetsub=""   d
		...s tarid=$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",3)
		...q:tarid=""
		...;s OPSubCat=$p($g(^DHCTARI(tarid)),"^",15)      ;门诊子类
		...;s OPSubCatCode=$p($G(^DHCTarC("OC",OPSubCat)),"^",1)  ;门诊大类
		...;s OPCat=$p($G(^DHCTarC("OC",OPSubCat)),"^",3)  ;门诊大类	
		...s TariSubCat=$p($g(^DHCTARI(tarid)),"^",4)
		...s TariCat=$P(^DHCTarC("SC",TariSubCat),"^",3)
		...s ^TMP("BILL","CateFee",job,TariCat)=$g(^TMP("BILL","CateFee",job,TariCat))+$p($g(^DHCPB(Bill,"O",BillOrd,"D",BillDetsub)),"^",7)
		
	}elseif(bill'=""){
		;s Type="TIC"
		s Type="CC"
		s BillOrd="0"
		f  s BillOrd=$o(^DHCPB(bill,"O",BillOrd))  q:BillOrd=""   d
		.s BillDetsub="0"
		.f  s BillDetsub=$o(^DHCPB(bill,"O",BillOrd,"D",BillDetsub))   q:BillDetsub=""   d
		..s tarid=$p($g(^DHCPB(bill,"O",BillOrd,"D",BillDetsub)),"^",3)
		..q:tarid=""
		..;s IPSubCat=$p($g(^DHCTARI(tarid)),"^",14)
		..;s IPSubCatCode=$p($G(^DHCTarC("IC",IPSubCat)),"^",1) 
		..;s IPCat=$p($G(^DHCTarC("IC",IPSubCat)),"^",3)
		..s TariSubCat=$p($g(^DHCTARI(tarid)),"^",4)
		..s TariCat=$P(^DHCTarC("SC",TariSubCat),"^",3)
		..s ^TMP("BILL","CateFee",job,TariCat)=$g(^TMP("BILL","CateFee",job,TariCat))+$p($g(^DHCPB(bill,"O",BillOrd,"D",BillDetsub)),"^",7)
	
	
	}else{
	}
	if (Type'=""){
		s catDr="0"
		f  s catDr=$o(^DHCTarC(Type,catDr)) q:catDr=""  d
		.s cateDesc=$p(^DHCTarC(Type,catDr),"^",2)     
		.s cateCode=$p(^DHCTarC(Type,catDr),"^",1)
		.s amt=+$g(^TMP("BILL","CateFee",job,catDr))
		.i FeeTypeCon'="" d
		..i +$d(^TEMP("InsuRep",FeeTypeCon,catDr))=0 d
		...s InsucateCode=##class(web.INSUDicDataCom).GetDicByCodeAndInd(FeeTypeCon,cateCode,6)
		...s InsucateDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd(FeeTypeCon,cateCode,7)
		...s:InsucateCode'="" ^TEMP("InsuRep",FeeTypeCon,catDr)=InsucateCode_"^"_InsucateDesc
		..e  d
		...s InsucateCode=$P(^TEMP("InsuRep",FeeTypeCon,catDr),"^",1)
		...s InsucateDesc=$P(^TEMP("InsuRep",FeeTypeCon,catDr),"^",2)
		..i InsucateCode'="" d
		...i $d(^TMP("BILL","InsuCateFee",job,InsucateCode))=0  d
		....s ^TMP("BILL","InsuCateFee",job,InsucateCode)=amt_"^"_InsucateCode_"^"_InsucateDesc
		...e  d
		....s $P(^TMP("BILL","InsuCateFee",job,InsucateCode),"^",1)=+(^TMP("BILL","InsuCateFee",job,InsucateCode))+amt
		.i str="" s str=cateDesc_"|"_amt
		.e  s str=str_"^"_cateDesc_"|"_amt
		i FeeTypeCon'="" d
		.s str="",InsucateCode=""
		.f  s InsucateCode=$O(^TMP("BILL","InsuCateFee",job,InsucateCode)) q:InsucateCode=""  d
		..s InsuCode=$P(^TMP("BILL","InsuCateFee",job,InsucateCode),"^",2)
		..s InsuDesc=$P(^TMP("BILL","InsuCateFee",job,InsucateCode),"^",3)
		..s amt=+$P(^TMP("BILL","InsuCateFee",job,InsucateCode),"^",1)
		..i str="" s str=InsuDesc_"|"_amt
		..e  s str=str_"^"_InsuDesc_"|"_amt
	}else{
		s str=-1
	}

	q str
}

}
