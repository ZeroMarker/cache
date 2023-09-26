/// DingSH
/// 20150505
Class web.DHCINSUZZRep Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock, Not SqlRowIdPrivate ]
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
/// 出参:
/// 医保就诊信息+医保结算信息+HIS基本诊信息+HIS就诊信息+费用分类信息
Query ZZRepQuery(StDate As %String, EndDate As %String, DivFlag As %String, InsuPatType As %String, InsuAdmType As %String, InsuCenterID As %String, InsuType As %String, HisAdmType As %String, RepType As %String, InvNo As %String, InsuId As %String, InName As %String, FileNo As %String, PapmiNo As %String, ShwTypes As %String = "", DivUserDr As %String = "") As %Query(ROWSPEC = "TInd,INADMRowid:%String,INADMAdmDr:%String,INADMInsuId:%String,INADMCardNo:%String,INADMPatType:%String,INADMCardStatus:%String,INADMCompany:%String,INADMStates:%String,INADMCenter:%String,INADMAccount:%String,INADMAdmSeriNo:%String,INADMActiveFlag:%String,INADMAdmDate:%String,INADMAdmTime:%String,INADMAdmType:%String,INADMDeptDesc:%String,INADMInsuUser:%String,INADMIpTimes:%String,INADMInsuType:%String,INADMAdmCancelNo:%String,INADMOutDate:%String,INADMOutTime:%String,INADMOutUser:%String,INADMUserDr:%String,INADMFunDate:%String,INADMFunTime:%String,INADMXString1:%String,INADMXString2:%String,INADMXString3:%String,INADMXString4:%String,INADMXFloat1:%String,INADMXFloat2:%String,INADMXFloat3:%String,INADMXFloat4:%String,INADMXString5:%String,INADMXString6:%String,INADMXString7:%String,INADMXString8:%String,INADMXString9:%String,INADMXString10:%String,INADMXString11:%String,INADMXString12:%String,INADMXString13:%String,INADMXString14:%String,INADMXString15:%String,INADMXString16:%String,INADMXString17:%String,INADMXString18:%String,INADMXString19:%String,INADMXString20:%String,InsuAdmInfoDr:%String,INPAYRowid:%String,INPAYAdmDr:%String,INPAYAdmInfoDr:%String,INPAYDHCpblDr:%String,INPAYDhcInvPrtDr:%String,INPAYFlag:%String,INPAYINSUDivideDr:%String,INPAYbcbxf0:%String,INPAYdjlsh0:%String,INPAYbckbcs:%String,INPAYbqbm00:%String,INPAYbrnl00:%String,INPAYcardno:%String,INPAYcfms0:%String,INPAYcrbcts:%String,INPAYgrzfe0:%String,INPAYiDate:%String,INPAYiTime:%String,INPAYid0000:%String,INPAYjjzfe0:%String,INPAYptbcts:%String,INPAYsUserDr:%String,INPAYsfrq00:%String,INPAYsfrm0:%String,INPAYsfsj00:%String,INPAYsftsbz:%String,INPAYbie00:%String,INPAYming0:%String,INPAYzhzfe0:%String,INPAYzyksmc:%String,INPAYzylsh0:%String,INPAYInsuPay1:%String,INPAYInsuPay2:%String,INPAYInsuPay3:%String,INPAYInsuPay4:%String,INPAYInsuPay5:%String,INPAYZstr01:%String,INPAYZstr02:%String,INPAYZstr03:%String,INPAYZstr04:%String,INPAYZstr05:%String,INPAYZstr06:%String,INPAYZstr07:%String,INPAYZstr08:%String,INPAYZstr09:%String,INPAYZstr10:%String,INPAYInsuPay6:%String,INPAYInsuPay7:%String,INPAYInsuPay8:%String,INPAYInsuPay9:%String,INPAYInsuPay10:%String,INPAYZstr11:%String,INPAYZstr12:%String,INPAYZstr13:%String,INPAYZstr14:%String,INPAYZstr15:%String,INPAYZstr16:%String,INPAYZstr17:%String,INPAYZstr18:%String,INPAYZstr19:%String,INPAYZstr20:%String,INPAYZstr21:%String,INPAYZstr22:%String,INPAYZstr23:%String,INPAYZstr24:%String,INPAYZstr25:%String,INPAYZstr26:%String,INPAYZstr27:%String,INPAYZstr28:%String,INPAYZstr29:%String,INPAYZstr30:%String,PAPMIRowid:%String,PAPMINo:%String,PAPMIMedicare:%String,PAPMIName:%String,PAPMISex:%String,PAPMIAge:%String,PAPMIPatId:%String,PAPMITelephone:%String,PAPMIAddress:%String,PAPMICompany:%String,PAADMRowid:%String,AADMDocDesc:%String,PAADMAdmDate:%String,PAADMAdmTime:%String,PAADMOutDate:%String,PAADMOutTime:%String,PAADMInDepCode:%String,PAADMInDepDesc:%String,PAADMOutDepCode:%String,PAADMOutDepDesc:%String,PAADMInDiagCode:%String,PAADMInDiagDesc:%String,PAADMMainDiagCode:%String,PAADMMainDiagDesc:%String,PAADMOutDiagCode:%String,PAADMOutDiagDesc:%String,PAADMUserDr:%String,PAADMOutStatus:%String,PAADMIPDays:%String,PAADMBedNo:%String,DivInvNo:%String,ZlFee:%String,JCFee:%String,SsFee:%String,GhFee:%String,HlFee:%String,CwFee:%String,ZCFee:%String,HyFee:%String,SxFee:%String,ClFee:%String,ZCaoYFee:%String,ZCheFee:%String,XyFee:%String") [ SqlProc ]
{
}

ClassMethod ZZRepQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ZZRepQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUZZRep","ZZRepQuery","2020-01-10","2020-03-18","I","","","","","O","","","","","","")
ClassMethod ZZRepQueryExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, DivFlag As %String, InsuPatType As %String, InsuAdmType As %String, InsuCenterID As %String, InsuType As %String, HisAdmType As %String, RepType As %String, InvNo As %String, InsuId As %String, InName As %String, FileNo As %String, PapmiNo As %String, ShwTypes As %String = "", DivUserDr As %String = "") As %Status
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
	s ^CacheTMP("ZZRepQuery")=StDate_"^"_EndDate_"^"_DivFlag_"^"_InsuPatType_"^"_InsuAdmType_"^"_InsuCenterID_"^"_HisAdmType_"^"_InsuType_"^"_RepType_"^"_InvNo_"^"_InsuId_"^"_InName_"^"_FileNo_"^"_PapmiNo_"^"_ShwTypes_"^"_DivUserDr
	//s:$l(StDate)=10 StDate=$zdh(StDate,4)
	//s:$l(EndDate)=10 EndDate=$zdh(EndDate,4)
	s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s UserName="",ErrMsg=""
	;对部分入参进行赋值-Start
	if RepType'="" d
	.;医疗人员类型 InsuPatType
	.s tmpInsuPatType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("RepTypeCnPatType"_InsuType,RepType,6)
	.s:tmpInsuPatType'="" InsuPatType=tmpInsuPatType
	.;医疗就诊类型 InsuAdmType
	.s tmpInsuAdmType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("RepTypeCnAdmType"_InsuType,RepType,6)
	.s:tmpInsuAdmType'="" InsuAdmType= tmpInsuAdmType
	;医疗统筹区 InsuCenterID
	.s tmpInsuCenterID=##class(web.INSUDicDataCom).GetDicByCodeAndInd("RepTypeCenterID"_InsuType,RepType,6)
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
	..s PapmiInfo=##class(web.DHCINSUPatInfo).GetPatInfoByPatIDRep(PAPMIDR,ShwPapmiTypes) ;获取Pa_PatMast信息
	..s tmpInsuId=$p(Adminfo,"^",2) ;医保个人编号
	..q:(InsuId'="")&(InsuId'=tmpInsuId)
	..s InvprtDr=$p(Divinfo,"^",4)
	..s BillNo=$p(Divinfo,"^",3)
	..s:TmpHisADMType="O" tmpInvNo=..GetInvNo("",InvprtDr,"")
	..s:TmpHisADMType="I" tmpInvNo=..GetInvNo(BillNo,"","")
	..s DivMod=$p(Divinfo,"^",38) ; 01现金结算模式 02集中打印模式 10本地算法 20自助机
	..s:DivMod="02" tmpInvNo=..GetInvNo("","",INPAYID)
	..s DivInvNo=tmpInvNo
	..q:(InvNo'=tmpInvNo)&(InvNo'="")
	..s tmpPapmino=$p(PapmiInfo,"^",2) ;登记号
	..q:(PapmiNo'="")&(PapmiNo'=tmpPapmino)
	..s tmpInName=$p(PapmiInfo,"^",3) ;姓名
	..q:(InName'="")&(tmpInName'[InName)
	..s PAPMIMedicare=""
	..i HisAdmType="I"  d  s PAPMIMedicare=$p(PapmiInfo,"^",15) ;病案号
	..e  d 
	...s:+$P(ShwTypes,"|",1)=1 PAPMIMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(PAADM,HisAdmType,.ErrMsg)
	...s:+$P(ShwTypes,"|",1)=0 ErrMsg=":"
	..s:PAPMIMedicare="" PAPMIMedicare=$p(ErrMsg,":",2)
	..q:(FileNo'="")&(FileNo'=PAPMIMedicare)
	
	..;st 数据的部分处理
	..;1 st-- 对医保就诊信息格式化
	..s tmpInsuPatTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKC021"_TmpInsuType,TmpInsuPatType,4)
	..s tmpInsuAdmTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA130"_TmpInsuType,TmpInsuAdmType,4)
	..s:tmpInsuPatTypeDesc'="" $p(Adminfo,"^",4)=tmpInsuPatTypeDesc
	..s:tmpInsuAdmTypeDesc'="" $p(Adminfo,"^",14)=tmpInsuAdmTypeDesc
	..s tmpSex=$p(Adminfo,"^",36)
	..s tmpSexDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AAC004"_TmpInsuType,tmpSex,4)
	..s:tmpSexDesc'="" tmpSex=tmpSexDesc
	..s DicDatainfo=##Class(web.INSUDicDataCtl).QueryByCodeNB("TariType",$p(Adminfo,"^",18))
	..s $p(Adminfo,"^",18)=$p(DicDatainfo,"^",4)    ;医保类型
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
	..s tmpStateDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd(DicType,TmpInsuCenterID,4)
	..s:tmpStateDesc'="" $p(Adminfo,"^",7)=tmpStateDesc
	..;2 ed-- 对医保就诊信息格式化
	..;st -- 对医保结算信息格式化处理 
	..s $p(Divinfo,"^",5)=$case($p(Divinfo,"^",5),"D":"预结算","I":"正常","B":"被作废","S":"作废",:"其他")
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

ClassMethod ZZRepQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ZZRepQueryExecute ]
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
/// Others: w ##class(web.DHCINSUZZRep).GetInvNo("","","2834"),两个入参不能同时为空
/// Output:
/// 备注：
ClassMethod GetInvNo(BillNo As %String, InvDr As %String, InsuDivDr As %String) As %String
{
	n (BillNo,InvDr,InsuDivDr)
	s InvNo="未出院结算"
	;b ;00
	q:((+BillNo=0)&(+InvDr=0)&(+InsuDivDr=0))=1 InvNo
	i +BillNo >0 d
	.s InvzyID=""
	.f  s InvzyID=$o(^DHCINVPRTZY("0","AR",BillNo,InvzyID)) q:InvzyID=""  d
	..s InvZYInfo=$g(^DHCINVPRTZY(InvzyID))
	..s Flag=$P(InvZYInfo,"^",8)
	..s:Flag="A" InvNo="发票作废"
	..s:Flag="S" InvNo="发票冲红"
	..q:(Flag'="I")&(Flag'="N")
	..s InvNo=$P(InvZYInfo,"^",1)
	i +InvDr >0 d
	.i $d(^DHCINVPRT(InvDr))=0 d
	..s InvNo="发票号码不存在 "
	.e  d 
	..s InvNo=$p($g(^DHCINVPRT(InvDr)),"^",14)
	
	i +InsuDivDr >0 d
	.s DivMod="",DivFlag=""
	.i $d(^DHCINDIV(InsuDivDr))=0 d
	..s InvNo="发票号码不存在 "
	.e  d 
	..s DivMod=$p(^DHCINDIV(InsuDivDr),"^",38) ; 01现金结算模式 02集中打印模式 10本地算法 20自助机
	..s DivFlag=$p(^DHCINDIV(InsuDivDr),"^",5) 
	.;b ;01
	.i DivMod="02" d
	..s Invprtdr="",AccPayINVDr=""
	..;s Invprtdr=$O(^DHCINVPRT(0,"INSDIV",InsuDivDr,""),-1)
	..s Invprtdr=$P($p(^DHCINDIV(InsuDivDr),"^",4),"!",1)
	..s:+Invprtdr>0 AccPayINVDr=$p($g(^DHCINVPRT(Invprtdr)),"^",4)
	..;s:+AccPayINVDr>0 InvNo=$p($g(^DHCINVPRTAP(AccPayINVDr)),"^",6)
	..i +AccPayINVDr>0 d
	...s InvNo=$p($g(^DHCINVPRTAP(AccPayINVDr)),"^",6)
	...s OldAccPayINVDr=+$p($g(^DHCINVPRTAP(AccPayINVDr)),"^",22)
	...i ((OldAccPayINVDr>0)&&((DivFlag="B")||(DivFlag="S"))) d
	....s InvNo=$p($g(^DHCINVPRTAP(OldAccPayINVDr)),"^",6)
	..;b ;02
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

/// HanZH
/// 20221104
/// 取医保预结算单病人基本信息
/// d ##class(%ResultSet).RunQuery("web.DHCINSUZZRep","FindYBYJSDBaseByPBRowId","5649")
/// Query FindYBYJSDBaseByPBRowIdexts(BillNo As %String) As %Query(ROWSPEC = "InsuType,Name,IDNumber,SEX,Age") [ SqlProc ]
Query FindYBYJSDBaseByPBRowId(INVPrt As %String) As %Query(ROWSPEC = "Name,TmpInsuAdmType,INPAYiDate,INPAYbcbxf0,INPAYjjzfe0,INPAYInsuPay6,INPAYInsuPay8,INPAYInsuPay4,INPAYInsuPayDB,INPAYzhzfe0,INPAYgrzfe0,INPAYZstr23,INPAYInsuPay9") [ SqlProc ]
{
}

ClassMethod FindYBYJSDBaseByPBRowIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindYBJSQDBaseByPBRowIdExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindYBYJSDBaseByPBRowIdExecute(ByRef qHandle As %Binary, INVPrt As %String) As %Status
{
  	Set repid=$I(^CacheTemp)
  	Set ind = 1
  	Set qHandle = $lb(0,repid,0)
  	set ^TMPDWC=$lb(INVPrt)
  	if INVPrt=""  Set qHandle = $lb(0,repid,0) Quit $$$OK
    s (INPAYDr,InsuType,Name,IDNumber,SEX,Age)=""
  	s InsuDivDr="" 
    f  s InsuDivDr=$o(^DHCINDIV("0","DHCInvPrt",INVPrt,InsuDivDr)) q:InsuDivDr=""  d
	.s Divinfo=$g(^DHCINDIV(InsuDivDr))
	.s PAADM=$p(Divinfo,"^",1)
	.q:PAADM=""
	.s InPayFlag=$p(Divinfo,"^",5) ;结算状态
	.q:InPayFlag'="I"     ;此处测试时是Q D状态  ，记得改为q:InPayFlag'=I
	.s InadmDr=$p(Divinfo,"^",2)   //insu_adminfo
	.q:InadmDr=""
	.s INPAYDr=InsuDivDr
	q:INPAYDr="" "-1"
	s Divinfo=$g(^DHCINDIV(INPAYDr))
	s InadmDr=$p(Divinfo,"^",2)   //insu_adminfo.rowidid 
	;1 取基本就诊信息
	s Adminfo=$g(^DHCINADM(InadmDr))
	s INADMAdmDr=$p(Adminfo,"^",1)
	s PAPMIDR=$p(^PAADM(INADMAdmDr),"^",1)
	s PapmiInfo=##class(web.DHCINSUPatInfo).GetPatInfoByPatID(PAPMIDR,2)
	s Name=$p(PapmiInfo,"^",3) ;患者姓名
	s SEX =$p(PapmiInfo,"^",5)    ;性别
	s:SEX="男" SEX="1"
	s:SEX="女" SEX="2"
	s IDNumber=$p(PapmiInfo,"^",9) ;身份证号
	
	s InsuType=$P(Adminfo,"^",18)
	s InsuPatType=$P(Adminfo,"^",36)
	s InsuTypeAYFY=##class(web.INSUDicDataCom).GetDicByCodeAndInd("insutype00A",InsuPatType,4,2)
	s TmpInsuAdmType=$p(Adminfo,"^",14)  ;医疗类别
	s TmpInsuAdmType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("med_type00A",TmpInsuAdmType,4,2)
	s INPAYiDate1=$p(Divinfo,"^",16)  ;结算日期
	s INPAYiDate=$zd(INPAYiDate1,3)
	s INPAYbcbxf0=$p(Divinfo,"^",7)  ;总费用
	s INPAYjjzfe0=$p(Divinfo,"^",19)  ;统筹支付
	
	s INPAYInsuPay6=$p(Divinfo,"^",46)  ;大病保险
	s INPAYInsuPay8=$p(Divinfo,"^",48)  ;基金支付
	
	s INPAYInsuPay4=$p(Divinfo,"^",34)  ;民政医疗救助
	s INPAYInsuPayDB=""  ;本年大病累计
	
	s INPAYzhzfe0=$p(Divinfo,"^",28)  ;账户支付
	s INPAYgrzfe0=$p(Divinfo,"^",15)    ;个人现金支付
	
	s INPAYZstr23=$p(Divinfo,"^",63)  ;结算后账户余额
	s INPAYInsuPay9=$p(Divinfo,"^",49)    ;医院负担
	

  	set Data=$lb(Name,TmpInsuAdmType,INPAYiDate,INPAYbcbxf0,INPAYjjzfe0,INPAYInsuPay6,INPAYInsuPay8,INPAYInsuPay4,INPAYInsuPayDB,INPAYzhzfe0,INPAYgrzfe0,INPAYZstr23,INPAYInsuPay9)
  	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
  	Quit $$$OK
}

ClassMethod FindYBYJSDBaseByPBRowIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindYBJSQDBaseByPBRowIdExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
 //
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" { // if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      { // fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s qHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

/*/// 
/// 
/// 医保就诊信息+医保结算信息+HIS就诊信息
/// 
Query ZZRepQuery1(StDate As %String, EndDate As %String, InsuPatType As %String, InsuAdmType As %String, InsuCenterID As %String, InsuType As %String, HisAdmType As %String, RepType As %String) As %Query(ROWSPEC = "TInd,TInAdm1:%String,TInAdm2:%String,TInAdm3:%String,TInAdm4:%String,TInAdm5:%String,TInAdm6:%String,TInAdm7:%String,TInAdm8:%String,TInAdm9:%String,TInAdm10:%String,TInAdm11:%String,TInAdm12:%String,TInAdm13:%String,TInAdm14:%String,TInAdm15:%String,TInAdm16:%String,TInAdm17:%String,TInAdm18:%String,TInAdm19:%String,TInAdm20:%String,TInAdm21:%String,TInAdm22:%String,TInAdm23:%String,TInAdm24:%String,TInAdm25:%String,TInAdm26:%String,TInAdm27:%String,TInAdm28:%String,TInAdm29:%String,TInAdm30:%String,TInAdm31:%String,TInAdm32:%String,TInAdm33:%String,TInAdm34:%String,TInAdm35:%String,TInAdm36:%String,TInAdm37:%String,TInAdm38:%String,TInAdm39:%String,TInAdm40:%String,TInAdm41:%String,TInAdm42:%String,TInAdm43:%String,TInAdm44:%String,TInAdm45:%String,TInAdm46:%String,TInAdm47:%String,TInAdm48:%String,TInAdm49:%String,TInAdm50:%String,TInDiv1:%String,TInDiv2:%String,TInDiv3:%String,TInDiv4:%String,TInDiv5:%String,TInDiv6:%String,TInDiv7:%String,TInDiv8:%String,TInDiv9:%String,TInDiv10:%String,TInDiv11:%String,TInDiv12:%String,TInDiv13:%String,TInDiv14:%String,TInDiv15:%String,TInDiv16:%String,TInDiv17:%String,TInDiv18:%String,TInDiv19:%String,TInDiv20:%String,TInDiv21:%String,TInDiv22:%String,TInDiv23:%String,TInDiv24:%String,TInDiv25:%String,TInDiv26:%String,TInDiv27:%String,TInDiv28:%String,TInDiv29:%String,TInDiv30:%String,TInDiv31:%String,TInDiv32:%String,TInDiv33:%String,TInDiv34:%String,TInDiv35:%String,TInDiv36:%String,TInDiv37:%String,TInDiv38:%String,TInDiv39:%String,TInDiv40:%String,TInDiv41:%String,TInDiv42:%String,TInDiv43:%String,TInDiv44:%String,TInDiv45:%String,TInDiv46:%String,TInDiv47:%String,TInDiv48:%String,TInDiv49:%String,TInDiv50:%String,TInDiv51:%String,TInDiv52:%String,TInDiv53:%String,TInDiv54:%String,TInDiv55:%String,TInDiv56:%String,TInDiv57:%String,TInDiv58:%String,TInDiv59:%String,TInDiv60:%String,TInDiv61:%String,TInDiv62:%String,TInDiv63:%String,TInDiv64:%String,TInDiv65:%String,TInDiv66:%String,TInDiv67:%String,TInDiv68:%String,TInDiv69:%String,TInDiv70:%String,TIPDays:%String,TAge:%String,TBedNo:%String,TDrugAmt:%String,UserName:%String,IPOutInfo:%String,XYFee:%String,ZCCYFee:%String,HYFee:%String,ZLFee:%String,JCFee:%String,QTFee:%String,GrpType:%String,GrpTypeDesc:%String,TAdmCareNo:%String,tmpPatNo:%String,tmpDepDesc:%String,TmpInsuPatType:%String,PAPMINo:%String") [ SqlProc ]
{
}

ClassMethod ZZRepQuery1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ZZRepQuery1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUZZRep","ZZRepQuery1","2015-10-01","2015-10-31","","","","ZZB","O","OP06")
ClassMethod ZZRepQuery1Execute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, InsuPatType As %String, InsuAdmType As %String, InsuCenterID As %String, InsuType As %String, HisAdmType As %String, RepType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:$g(StDate)="" $$$OK
	q:$g(EndDate)="" $$$OK
	s ^CacheTMP("ZZRepQuery")=StDate_"^"_EndDate_"^"_InsuPatType_"^"_InsuAdmType_"^"_InsuCenterID_"^"_HisAdmType_"^"_InsuType_"^"_RepType
	s:$l(StDate)=10 StDate=$zdh(StDate,3)
	s:$l(EndDate)=10 EndDate=$zdh(EndDate,3)
	s UserName=""
	;对部分入参进行赋值-Start
	;医疗人员类型 InsuPatType
	s tmpInsuPatType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("RepTypeCnPatType"_InsuType,RepType,6)
	s InsuPatType=tmpInsuPatType
	;医疗就诊类型 InsuAdmType
	s tmpInsuAdmType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("RepTypeCnAdmType"_InsuType,RepType,6)
	s InsuAdmType= tmpInsuAdmType
	;医疗统筹区 InsuCenterID
	s tmpInsuCenterID=##class(web.INSUDicDataCom).GetDicByCodeAndInd("RepTypeCenterID"_InsuType,RepType,6)
	s QtFlag="N"
	i ($l(tmpInsuCenterID,"'")>1) d
	.s QtFlag="Y"
	.s InsuCenterID=$p(tmpInsuCenterID,"'",2)
	e  d
	.s InsuCenterID=tmpInsuCenterID
	;b ;0
    ;对部分入参进行赋值-End
	f date=StDate:1:EndDate d
	.s INPAYID=""
	.f  s INPAYID=$o(^DHCINDIV("0","IDate",date,INPAYID)) q:INPAYID=""  d
	..;b ;4
	..s Divinfo=$g(^DHCINDIV(INPAYID))
	..s (TIPDays,TAge,TBedNo)="" ;变量初始化
	..q:$l(Divinfo,"^")<2
	..s PAADM=$p(Divinfo,"^",1)
	..s DHCpblDr=$p(Divinfo,"^",3)
	..s PAPMIDR=$p(^PAADM(PAADM),"^",1)
	..s TmpHisADMType=$p(^PAADM(PAADM),"^",2) ;HIS就诊类型
	..s:TmpHisADMType="E" TmpHisADMType="O"
	..q:(TmpHisADMType'=HisAdmType)&&(HisAdmType'="")
	..s InPayFlag=$p(Divinfo,"^",5) ;结算状态
	..q:InPayFlag'="I" 
	..;b ;0000
	..s InadmDr=$p(Divinfo,"^",2)   //insu_adminfo
	..q:InadmDr=""
	..s Adminfo=$g(^DHCINADM(InadmDr))
	..s TmpInsuType=$p(Adminfo,"^",18) ;医保类型
	..;b ;00000
	..q:TmpInsuType'=InsuType
	..;b ;000000
	..s TmpInsuCenterID=$p(Adminfo,"^",7) ;统筹区号
	..s:InsuCenterID="*" InsuCenterID=""
	..s IsCenterFlag="N"
	..i QtFlag="N" d
	...i (InsuCenterID'="")&(("|"_TmpInsuCenterID_"|")[("|"_InsuCenterID_"|")) d
	....s IsCenterFlag="Y"
	...e  d
	....s IsCenterFlag="N"
	..e  d
	...i (InsuCenterID'="")&(("|"_TmpInsuCenterID_"|")[("|"_InsuCenterID_"|")) d
	....s IsCenterFlag="N"
	....;b ;000
	...e  d
	....s IsCenterFlag="Y"
	..s:(InsuCenterID="")!(InsuCenterID="*") IsCenterFlag="Y" ;20151115 DingSH 修改
	..q:IsCenterFlag'="Y"
	..;(TmpInsuCenterID'=InsuCenterID)
	..s TmpInsuAdmType=$p(Adminfo,"^",14)  ;医疗类别
	..s:InsuAdmType="*" InsuAdmType=""
	..q:(InsuAdmType'="")&(("|"_InsuAdmType_"|")'[("|"_TmpInsuAdmType_"|")) 
	..;q:(InsuAdmType'="")&&(TmpInsuAdmType'=InsuAdmType)
	..s TmpInsuPatType=$p(Adminfo,"^",4)   ;人员类型
	..s:InsuPatType="*" InsuPatType=""
	..q:(InsuPatType'="")&(("|"_InsuPatType_"|")'[("|"_TmpInsuPatType_"|"))
	..;q:(InsuPatType'="")&&(TmpInsuPatType'=InsuPatType)
	..;b ;0
	..;数据的部分处理
	..;获取分组类型 
	..s GrpType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("GrpTypeCnAdmType"_InsuType,TmpInsuAdmType,6)
	..s GrpTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("GrpTypeCnAdmType"_InsuType,TmpInsuAdmType,7)
	..;获取Adm就诊信息PAdmInfo
	..s PAdmInfo=""
	..s PAdmInfo=##class(web.DHCINSUPatInfo).GetAdmInfoByAdmID(PAADM)
	..s TIPDays=$P(PAdmInfo,"^",40)       ;住院天数
	..s:TmpHisADMType="O" TIPDays=0
	..s tmpAdmissionDate=$P(PAdmInfo,"^",6) ;入院日期lhd
	..s tmpAdmissionTime=$P(PAdmInfo,"^",7) ;入院时间lhd
	..s tmpDischgDate=$P(PAdmInfo,"^",10) ;出院日期
	..s tmpDischgTime=$P(PAdmInfo,"^",11) ;出院时间
	..s tmpDischgDiagnosis=$P(PAdmInfo,"^",26) ;出院诊断lhd
	..s tmpPatNo=$P(PAdmInfo,"^",27) // ;住院号lhd
	..s TBedNo=$P(PAdmInfo,"^",19) ;床位号
	..s $p(Adminfo,"^",20)=tmpDischgDate
	..s $p(Adminfo,"^",21)=tmpDischgTime
	..s $p(Adminfo,"^",12)=$zd($p(Adminfo,"^",12),3)
	..s $p(Adminfo,"^",13)=$zt($p(Adminfo,"^",13))
    ..s $p(Adminfo,"^",29)=tmpDischgDiagnosis
    ..b ;3
	..;获取Papmi信息  PApmiInfo
	..s PapmiInfo=""
	..s PapmiInfo=##class(web.DHCINSUPatInfo).GetPatInfoByPatID(PAPMIDR)
	..s PAPMINo=$p(^PAPER(PAPMIDR,"PAT",1),"^",1)  //登记号
	..s TAge=$P(PapmiInfo,"^",4)
	..;医疗类别,人员类别等医保字典数据的处理
	..i InsuType="ZZA" d
	...s tmpInsuPatTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKC021"_InsuType,TmpInsuPatType,4)
	...s tmpInsuAdmTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA130"_InsuType,TmpInsuAdmType,4)
	...s $p(Adminfo,"^",4)=tmpInsuPatTypeDesc
	...s $p(Adminfo,"^",14)=tmpInsuAdmTypeDesc
	..e  i InsuType="ZZB"  d
	...s tmpInsuPatTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("INSUPATTYPE",TmpInsuPatType,4)
	...s tmpInsuAdmTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("INSUMEDType",TmpInsuAdmType,4)
	...s $p(Adminfo,"^",4)=tmpInsuPatTypeDesc
	...s $p(Adminfo,"^",14)=tmpInsuAdmTypeDesc
	..;住院发票号,出院状况
	..s:TmpHisADMType="I" $p(Divinfo,"^",3)=..GetInvNo($p(Divinfo,"^",3),"")
	..s IPOutInfo=$P($P(PAdmInfo,"=",7),"^",2)
	..;个人自付 、按比例自付
	..i InsuType="ZZA" d
	...s Zstr05=+$p(Divinfo,"^",40)+$p(Divinfo,"^",41)+$p(Divinfo,"^",42)	//按比例自负
	...s Zstr08=+$p(Divinfo,"^",43)+$p(Divinfo,"^",51)+$p(Divinfo,"^",53)+$p(Divinfo,"^",54)	//个人自付
	...s $p(Divinfo,"^",40)=Zstr05
	...s $p(Divinfo,"^",43)=Zstr08
	..else  If InsuType="ZZB"  d
	...b ;2
	...s Zstr05=+$p(Divinfo,"^",40)+$p(Divinfo,"^",41)+$p(Divinfo,"^",42)	//按比例自负
	...s Zstr08=+$p(Divinfo,"^",43)+$p(Divinfo,"^",51)+$p(Divinfo,"^",64) ;+$p(^DHCINDIV(Rowid),"^",53)+$p(^DHCINDIV(Rowid),"^",54)	//个人自付
	...s $p(Divinfo,"^",40)=Zstr05
	...s $p(Divinfo,"^",43)=Zstr08
	..;性别，结算时间格本地化,科室
	..s tmpSex=$p(Adminfo,"^",36)
	..i tmpSex="1" d
	...s tmpSex="男" 
	..else  if tmpSex="2" d
	...s tmpSex="女"
	..s $p(Adminfo,"^",36)=tmpSex
	..s tmpiDate=$p(Divinfo,"^",16)
	..s $p(Divinfo,"^",16)=$zd(tmpiDate,3)
	..s tmpDepDesc="" ;科室
	..s tmpDepDesc=$p(Adminfo,"^",15)
	..s tmpDepDesc=$p(tmpDepDesc,"-",2)
	..s $p(Adminfo,"^",15)=tmpDepDesc
	..s tmpDrugAmount=""
	..;i DHCpblDr'=""  d  s tmpDrugAmount=##class(web.DHCINSUPort).GetDrugTotalAmt(PAADM,DHCpblDr)
	..;s TDrugAmt=0
	..;s TDrugAmt=+$P(tmpDrugAmount,"!",1)
	..s TDrugAmt=0
	..s tmedcare=""
	..s tmedcare=##class(web.DHCWMRService).IGetMrNoByEpisodeID(PAADM) ;从病例组获得住院号 DingSH20141105
	..s:InsuType="ZZB" $p(Adminfo,"^",10)=tmedcare
	..s TAdmCareNo=""
	..s TAdmCareNo=tmedcare
	..;对费用分类的统计
	..s:TmpHisADMType="I" CateFeeStr=##class(web.UDHCJFBaseCommon).GetCateFee("",$p(Divinfo,"^",3))
	..s:TmpHisADMType="O" CateFeeStr=##class(web.UDHCJFBaseCommon).GetCateFee($p(Divinfo,"^",4),"")
	..S XYFee=$p($p(CateFeeStr,"^",1),"|",2) ;西药费
	..s ZCCYFee=+$p($p(CateFeeStr,"^",2),"|",2)+$p($p(CateFeeStr,"^",3),"|",2) ;中成草药费
	..s HYFee=$p($p(CateFeeStr,"^",11),"|",2) ;化验费
	..s ZLFee=$p($p(CateFeeStr,"^",6),"|",2) ;治疗费
	..s JCFee=$p($p(CateFeeStr,"^",5),"|",2)+$p($p(CateFeeStr,"^",15),"|",2)+$p($p(CateFeeStr,"^",16),"|",2) ;检查费
	..s QTFee=+$p($p(CateFeeStr,"^",4),"|",2)+$p($p(CateFeeStr,"^",7),"|",2)+$p($p(CateFeeStr,"^",8),"|",2)+$p($p(CateFeeStr,"^",9),"|",2)+$p($p(CateFeeStr,"^",10),"|",2)
	..s QTFee=QTFee+$p($p(CateFeeStr,"^",12),"|",2)+$p($p(CateFeeStr,"^",13),"|",2)+$p($p(CateFeeStr,"^",14),"|",2) ;+$p($p(CateFeeStr,"^",15),"|",2)+$p($p(CateFeeStr,"^",16),"|",2)
	..s QTFee=QTFee+$p($p(CateFeeStr,"^",17),"|",2)+$p($p(CateFeeStr,"^",17),"|",2)+$p($p(CateFeeStr,"^",19),"|",2)+$p($p(CateFeeStr,"^",20),"|",2)+$p($p(CateFeeStr,"^",21),"|",2)
	..;数据的部分处理
	..d Build1
	Quit $$$OK
	;具体字段值标示什么意思参见表结构说明
Build1 	
	set Data=$lb(ind,$p(Adminfo,"^",1),$p(Adminfo,"^",2),$p(Adminfo,"^",3),$p(Adminfo,"^",4),$p(Adminfo,"^",5),$p(Adminfo,"^",6),$p(Adminfo,"^",7),$p(Adminfo,"^",8),$p(Adminfo,"^",9),$p(Adminfo,"^",10),$p(Adminfo,"^",11),
	$p(Adminfo,"^",12),$p(Adminfo,"^",13),$p(Adminfo,"^",14),$p(Adminfo,"^",15),$p(Adminfo,"^",16),$p(Adminfo,"^",17),$p(Adminfo,"^",18),$p(Adminfo,"^",19),$p(Adminfo,"^",20),$p(Adminfo,"^",21),$p(Adminfo,"^",22),$p(Adminfo,"^",23),$p(Adminfo,"^",24),
	$p(Adminfo,"^",25),$p(Adminfo,"^",26),$p(Adminfo,"^",27),$p(Adminfo,"^",28),$p(Adminfo,"^",29),$p(Adminfo,"^",30),$p(Adminfo,"^",31),$p(Adminfo,"^",32),$p(Adminfo,"^",33),$p(Adminfo,"^",34),$p(Adminfo,"^",35),$p(Adminfo,"^",36),
	$p(Adminfo,"^",37),$p(Adminfo,"^",38),$p(Adminfo,"^",39),$p(Adminfo,"^",40),$p(Adminfo,"^",41),$p(Adminfo,"^",42),$p(Adminfo,"^",43),$p(Adminfo,"^",44),$p(Adminfo,"^",45),$p(Adminfo,"^",46),$p(Adminfo,"^",47),$p(Adminfo,"^",48),$p(Adminfo,"^",49),
	$p(Adminfo,"^",50),
	$p(Divinfo,"^",1),$p(Divinfo,"^",2),$p(Divinfo,"^",3),$p(Divinfo,"^",4),$p(Divinfo,"^",5),$p(Divinfo,"^",6),$p(Divinfo,"^",7),$p(Divinfo,"^",8),$p(Divinfo,"^",9),$p(Divinfo,"^",10),
	$p(Divinfo,"^",11),$p(Divinfo,"^",12),$p(Divinfo,"^",13),$p(Divinfo,"^",14),$p(Divinfo,"^",15),$p(Divinfo,"^",16),$p(Divinfo,"^",17),$p(Divinfo,"^",18),$p(Divinfo,"^",19),$p(Divinfo,"^",20),
	$p(Divinfo,"^",21),$p(Divinfo,"^",22),$p(Divinfo,"^",23),$p(Divinfo,"^",24),$p(Divinfo,"^",25),$p(Divinfo,"^",26),$p(Divinfo,"^",27),$p(Divinfo,"^",28),$p(Divinfo,"^",29),$p(Divinfo,"^",30),
	$p(Divinfo,"^",31),$p(Divinfo,"^",32),$p(Divinfo,"^",33),$p(Divinfo,"^",34),$p(Divinfo,"^",35),$p(Divinfo,"^",36),$p(Divinfo,"^",37),$p(Divinfo,"^",38),$p(Divinfo,"^",39),$p(Divinfo,"^",40),
	$p(Divinfo,"^",41),$p(Divinfo,"^",42),$p(Divinfo,"^",43),$p(Divinfo,"^",44),$p(Divinfo,"^",45),$p(Divinfo,"^",46),$p(Divinfo,"^",47),$p(Divinfo,"^",48),$p(Divinfo,"^",49),$p(Divinfo,"^",50),
	$p(Divinfo,"^",51),$p(Divinfo,"^",52),$p(Divinfo,"^",53),$p(Divinfo,"^",54),$p(Divinfo,"^",55),$p(Divinfo,"^",56),$p(Divinfo,"^",57),$p(Divinfo,"^",58),$p(Divinfo,"^",59),$p(Divinfo,"^",60),
	$p(Divinfo,"^",61),$p(Divinfo,"^",62),$p(Divinfo,"^",63),$p(Divinfo,"^",64),$p(Divinfo,"^",65),$p(Divinfo,"^",66),$p(Divinfo,"^",67),$p(Divinfo,"^",68),$p(Divinfo,"^",69),$p(Divinfo,"^",70),TIPDays,TAge,TBedNo,TDrugAmt,UserName,IPOutInfo,XYFee,ZCCYFee,HYFee,ZLFee,JCFee,QTFee,GrpType,GrpTypeDesc,TAdmCareNo,tmpPatNo,tmpDepDesc,TmpInsuPatType,PAPMINo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ZZRepQuery1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ZZRepQuery1Execute ]
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
*/

/*
/// 
/// DingSH 2015-04-17 
/// 入参：账单号
/// 根据账单号获取打印医疗救助费用结算表数据 淮安市医保
/// 
Query HAAIPMZJZPrtJSDQuery(BillNo As %String, ExpStr As %String) As %Query(ROWSPEC = "TInd,TTCQ:%String,TiDate:%String,TDiagDesc:%String,TAdmTypeDesc:%String,TMedCareNo:%String,TInvNo:%String,TJZLB:%String,TName:%String,TPatID:%String,TCompany:%String,TInsuNo:%String,TAdmDate:%String,TAdmDischDate:%String,TIPDays:%String,THosp:%String,TTotal:%String,TYBNFY:%String,TYBWFY:%String,Tjjzfe0:%String,TMZJZFW:%String,TInsuPay5:%String,TMZJZLJ:%String,TGrzfe0:%String") [ SqlProc ]
{
}

ClassMethod HAAIPMZJZPrtJSDQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HAAIPMZJZPrtJSDQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUHARep","HAAIPMZJZPrtJSDQuery","686591","")
ClassMethod HAAIPMZJZPrtJSDQueryExecute(ByRef qHandle As %Binary, BillNo As %String, ExpStr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:$g(BillNo)="" $$$OK
	s ^CacheTMP("HAAIPMZJZPrtJSDQuery")=BillNo_"^"_ExpStr
	;^DHCINDIV("0","DHCPB",{INPAY_DHCpblDr},{INPAY_Rowid})
	
	s INPAYID=""
	f  s INPAYID=$o(^DHCINDIV("0","DHCPB",BillNo,INPAYID)) q:INPAYID=""  d
	.s Divinfo=$g(^DHCINDIV(INPAYID))
	.s InPayFlag=$p(Divinfo,"^",5) ;结算状态
	.q:InPayFlag'="I"
	.s InadmDr=$p(Divinfo,"^",2)   //insu_adminfo
	.q:InadmDr=""
	.s Adminfo=$g(^DHCINADM(InadmDr))
	.;s TmpInsuType=$p(Adminfo,"^",18) ;医保类型
	.;b ;0
	.;数据的部分处理
	.;统筹区  TTCQ
	.s TmpInsuCenterID=$p(Adminfo,"^",8) ;统筹区号
	.;医保字典数据的处理
	.s TTCQ=##class(web.INSUDicDataCom).GetDicByCodeAndInd("CenterHAA",TmpInsuCenterID,7)
	.;结账日期 TiDate
	.s tmpiDate=$p(Divinfo,"^",16)
	.s TiDate=$zd(tmpiDate,3)
	.;疾病诊断 TDiagDesc
	.s TDiagDesc=$p(Adminfo,"^",29) ;
	.;就诊类型 TAdmTypeDesc
	.s TmpInsuAdmType=$p(Adminfo,"^",14)  ;医疗类别
	.s TAdmTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA130HAA",TmpInsuAdmType,4)
	.;就诊号  TMedCareNo
	.s PAADM=$p(Divinfo,"^",1)
	.s TMedCareNo=##class(web.DHCWMRService).IGetMrNoByEpisodeID(PAADM) ;从病例组获得住院号 DingSH20141105  
	.;票据号  TInvNo
	.s TInvNo=..GetInvNoZy(BillNo,"")
	.;救助对象类别 TJZLB
	.s tmpjzlb=$P($p(Divinfo,"^",69),"~",31) ;民政救助对象类别
	.s TJZLB=##class(web.INSUDicDataCom).GetDicByCodeAndInd("JZLBHAA",tmpjzlb,4)
	.;姓名 TName
	.s TName=$p(Adminfo,"^",35)  ;
	.;身份证号 TPatID
	.s TPatID=$p(Adminfo,"^",34)  ;
	.;工作单位 TCompany
	.s TCompany=$p(Adminfo,"^",6)  ;
	.;医保号 TInsuNo
	.s TInsuNo=$p(Adminfo,"^",2)  ;
	.;就诊开始日期 TAdmDate
	.s TAdmDate=$zd($p(Adminfo,"^",12),3)  ;
	.;就诊结束日期 TAdmDischDate
	.s PAdmInfo=""
	.s PAdmInfo=##class(web.DHCINSUPatInfo).GetAdmInfoByAdmID(PAADM)
	.s TAdmDischDate=$P(PAdmInfo,"^",10) ;
	.;住院天数 TIPDays
	.s TIPDays=$P(PAdmInfo,"^",40)       ;
	.;就诊医院 THosp
	.s THosp="淮安市妇幼保健院"
	.;总费用 TTotal
	.s TTotal=+$p(Divinfo,"^",7) 
	.;医保范围内TYBNFY 医保范围内=本次医疗费用 - 本次自费金额
	.s TYBNFY=+$p(Divinfo,"^",7) - +$p(Divinfo,"^",39)
	.;医保范围外TYBWFY 医保范围外=本次自费金额
	.s TYBWFY=++$p(Divinfo,"^",39)
	.;医保报销费用Tjjzfe0
	.s Tjjzfe0=+$p(Divinfo,"^",19) 
	.;民政救助范围TMZJZFW
	.s TMZJZFW=+$P($p(Divinfo,"^",69),"~",34) ;本次进入民政救助金额
	.;本次民政救助金额TInsuPay5
	.s TInsuPay5=+$p(Divinfo,"^",35)
	.;本年度民政救助累计金额TMZJZLJ
	.s TMZJZLJ=+$P($p(Divinfo,"^",69),"~",33) ;民政救助累计
	.;个人实际支付金额TGrzfe0
	.s TGrzfe0=+$p(Divinfo,"^",15)
	
	.;数据的部分处理
	.d Build2
	Quit $$$OK
	;具体字段值标示什么意思参见表结构说明
Build2	
	set Data=$lb(ind,TTCQ,TiDate,TDiagDesc,TAdmTypeDesc,TMedCareNo,TInvNo,TJZLB,TName,TPatID,TCompany,TInsuNo,TAdmDate,TAdmDischDate,TIPDays,THosp,TTotal,TYBNFY,TYBWFY,Tjjzfe0,TMZJZFW,TInsuPay5,TMZJZLJ,TGrzfe0)
	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod HAAIPMZJZPrtJSDQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HAAIPMZJZPrtJSDQueryExecute ]
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



/// 
/// 
/// 
///  新农合报销统计 20150427 DingSH  [院内农合办指标报表]
/// 
Query HABHisRepQuery(StDate As %String, EndDate As %String, InsuPatType As %String, InsuAdmType As %String, InsuCenterID As %String, InsuType As %String, HisAdmType As %String, RepType As %String) As %Query(ROWSPEC = "TInd,TDepCode:%String,TDepDesc:%String,TMediCareNo:%String,TName:%String,TSex:%String,TAge:%String,TTCQ:%String,TAdmType:%String,TAdmTypeDesc:%String,TDiagCode:%String,TDiagDesc:%String,TAdress:%String,TYPAmount:%String,TYPKBAmount:%String,TYLAmount:%String,TYLKBAmount:%String,TTotalAmount:%String,TTotalKEJE:%String,TBCBXJE:%String,TBBXFYTCB:%String,TMLNYPSYL:%String,TSJBCB:%String,TAdmDate:%String,TDischDate:%String,TIDate:%String") [ SqlProc ]
{
}

ClassMethod HABHisRepQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HABHisRepQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("web.DHCINSUHARep","HABHisRepQuery","2015-03-01","2015-03-31","","","","HAB","I","")
ClassMethod HABHisRepQueryExecute(ByRef qHandle As %Binary, StDate As %String, EndDate As %String, InsuPatType As %String, InsuAdmType As %String, InsuCenterID As %String, InsuType As %String, HisAdmType As %String, RepType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:$g(StDate)="" $$$OK
	q:$g(EndDate)="" $$$OK
	s ^CacheTMP("HABHisRepQuery")=StDate_"^"_EndDate_"^"_InsuPatType_"^"_InsuAdmType_"^"_InsuCenterID_"^"_HisAdmType_"^"_InsuType_"^"_RepType
	s:$l(StDate)=10 StDate=$zdh(StDate,3)
	s:$l(EndDate)=10 EndDate=$zdh(EndDate,3)
	;if RepType="OPHAA" d
	;.s tmpInsuAdmType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("InsuAdmTypeRepHAA",InsuAdmType,6)
	;.s InsuAdmType= tmpInsuAdmType
	;b ;in
	f date=StDate:1:EndDate d
	.s INPAYID=""
	.f  s INPAYID=$o(^DHCINDIV("0","IDate",date,INPAYID)) q:INPAYID=""  d
	..s Divinfo=$g(^DHCINDIV(INPAYID))
	..s (TIPDays,TAge,TBedNo)="" ;变量初始化
	..q:$l(Divinfo,"^")<2
	..s PAADM=$p(Divinfo,"^",1)
	..s DHCpblDr=$p(Divinfo,"^",3)
	..s PAPMIDR=$p(^PAADM(PAADM),"^",1)
	..s TmpHisADMType=$p(^PAADM(PAADM),"^",2) ;HIS就诊类型
	..s:TmpHisADMType="E" TmpHisADMType="O"
	..q:TmpHisADMType'=HisAdmType
	..s InPayFlag=$p(Divinfo,"^",5) ;结算状态
	..q:InPayFlag'="I" 
	..s InadmDr=$p(Divinfo,"^",2)   //insu_adminfo
	..q:InadmDr=""
	..s Adminfo=$g(^DHCINADM(InadmDr))
	..s TmpInsuType=$p(Adminfo,"^",18) ;医保类型
	..q:TmpInsuType'=InsuType
	..s TmpInsuCenterID=$p(Adminfo,"^",8) ;统筹区号
	..s:InsuCenterID="ALL" InsuCenterID=""
	..q:(InsuCenterID'="")&&(TmpInsuCenterID'=InsuCenterID)
	..s TmpInsuAdmType=$p(Adminfo,"^",14)  ;医疗类别
	..s:InsuAdmType="ALL" InsuAdmType=""
	..q:(InsuAdmType'="")&(("!"_InsuAdmType_"!")'[("!"_TmpInsuAdmType_"!")) 
	..;q:(InsuAdmType'="")&&(TmpInsuAdmType'=InsuAdmType)
	..s TmpInsuPatType=$p(Adminfo,"^",4)   ;人员类型
	..s:InsuPatType="ALL" InsuPatType=""
	..q:(InsuPatType'="")&(("!"_InsuPatType_"!")'[("!"_TmpInsuPatType_"!"))
	..;q:(InsuPatType'="")&&(TmpInsuPatType'=InsuPatType)
	..;b ;0
	..;数据的部分处理
	..s JSDData=$p(Divinfo,"^",69) ;结算单数据
    ..;TDepCode 科室编码
    ..s PAdmInfo=""
	..s PAdmInfo=##class(web.DHCINSUPatInfo).GetAdmInfoByAdmID(PAADM)
	..s TDepCode=$P(PAdmInfo,"^",4)
    ..;TDepDesc 科室名称 
    ..s TDepDesc=$p($P(PAdmInfo,"^",5),"-",2)
    ..;TMediCareNo 住院号
    ..s TMediCareNo=##class(web.DHCWMRService).IGetMrNoByEpisodeID(PAADM) ;从病例组获得住院号 DingSH20141105
    ..;TName  姓名
    ..s TName=$p(Adminfo,"^",35)
    ..;TSex 性别
    ..s tmpSex=$p(Adminfo,"^",36)
    ..i tmpSex="1" d
	...s tmpSex="男" 
	..else  if tmpSex="2" d
	...s tmpSex="女"
    ..s TSex=tmpSex
    ..;TAge 年龄
    ..s PapmiInfo=""
	..s PapmiInfo=##class(web.DHCINSUPatInfo).GetPatInfoByPatID(PAPMIDR)
	..s TAge=$P(PapmiInfo,"^",4)
    ..;TTCQ 区域
    ..s TTCQ=##class(web.INSUDicDataCom).GetDicByCodeAndInd("INSUCenterHAB",TmpInsuCenterID,7)
    ..;TAdmType  就诊类别编码
    ..s TAdmType=TmpInsuAdmType
    ..;TAdmTypeDesc 就诊类别描述
    ..s tmpInsuAdmTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA130"_InsuType,TmpInsuAdmType,4)
	..s TAdmTypeDesc=$p(JSDData,"~",12) ;tmpInsuAdmTypeDesc
    ..;TDiagCode 诊断编码
	..s TDiagCode=$p(Adminfo,"^",28) ;
    ..;TDiagDesc 诊断描述
    ..s TDiagDesc=$p(JSDData,"~",13) ;$p(Adminfo,"^",29) ;
    ..;TAdress: 家庭住址
    ..s TAdress=$p(JSDData,"~",6) ;$P(PapmiInfo,"^",6) ;
    ..;TYPAmount 药品总额
    ..b ;0
    ..s TYPAmount=+($p(JSDData,"~",19)+$p(JSDData,"~",20))
    ..;TYPKBAmount 药品可报
    ..s TYPKBAmount=+$p(JSDData,"~",19)
    ..;TYLAmount 医疗总额
    ..s TYLAmount=+($p(JSDData,"~",21)+$p(JSDData,"~",22))
    ..;TYLKBAmount 医疗可报
    ..s TYLKBAmount=+$p(JSDData,"~",21)
    ..;TTotalAmount 总额
    ..s TTotalAmount=+$p(Divinfo,"^",7)
    ..;TTotalKEJE 可报金额
     ..s TTotalKEJE=+$p(JSDData,"~",40)
    ..;TBCBXJE 本次报销
    ..;公式
    ..s TBCBXJE=+$p(Divinfo,"^",31)
    ..;TBBXFYTCB 不报销费用剔除比
    ..;公式 不报销费用剔除比=(药品总额-药品可报+医疗总额-医疗可报)/(药品总额+医疗总额)
    ..s TBBXFYTCB=1.0000
    ..s:(TYPAmount'=0)&&(TYLAmount'=0) TBBXFYTCB=$fn((TYPAmount-TYPKBAmount+TYLAmount-TYLKBAmount)/(TYPAmount+TYLAmount),"",4)
    ..;TMLNYPSYL 目录内药品使用率
    ..;公式 目录内药品使用率=药品可报/药品总额
    ..s TMLNYPSYL=1.0000
    ..s:(TYPAmount'=0) TMLNYPSYL=$fn(TYPKBAmount/TYPAmount,"",4)
    ..;TSJBCB 实际补偿比
    ..;公式 实际补偿比=本次报销/总金额
    ..s TSJBCB=0
    ..s TSJBCB=$fn(TBCBXJE/TTotalAmount,"",4)
   ..;TAdmDate 入院日期
   ..s tmpAdmDate=$zd($p(Adminfo,"^",12),3)
   ..s tmpAdmTime=$zt($p(Adminfo,"^",13))
   ..s TAdmDate=tmpAdmDate_" "_tmpAdmTime
    ..;TDischDate 出院日期
    ..s tmpDischgDate=$P(PAdmInfo,"^",10) ;出院日期
	..s tmpDischgTime=$P(PAdmInfo,"^",11) ;出院时间
	..s TDischDate=tmpDischgDate_" "_tmpDischgTime
    ..;TIDate 结算日期
	..s tmpIDate=$zd($p(Divinfo,"^",16),3)
	..s tmpITime=$zt($p(Divinfo,"^",17))
	..s TIDate=tmpIDate_" "_tmpITime
	..;医疗类别,人员类别等医保字典数据的处理
	..;s tmpInsuPatTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKC021"_InsuType,TmpInsuPatType,4)
	..;s tmpInsuAdmTypeDesc=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AKA130"_InsuType,TmpInsuAdmType,4)
	..;s $p(Adminfo,"^",4)=tmpInsuPatTypeDesc
	..;s $p(Adminfo,"^",14)=tmpInsuAdmTypeDesc
	..d Build03
	Quit $$$OK
	
Build03 	
	set Data=$lb(ind,TDepCode,TDepDesc,TMediCareNo,TName,TSex,TAge,TTCQ,TAdmType,TAdmTypeDesc,TDiagCode,TDiagDesc,TAdress,TYPAmount,TYPKBAmount,TYLAmount,TYLKBAmount,TTotalAmount,TTotalKEJE,TBCBXJE,TBBXFYTCB,TMLNYPSYL,TSJBCB,TAdmDate,TDischDate,TIDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod HABHisRepQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HABHisRepQueryExecute ]
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
*/

/*
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUZZRep","ZZRepQueryNHBX","62643","64672","")
Query ZZRepQueryNHBX(BeginDate As %String, EndDate As %String, ReaDr As %String) As %Query(ROWSPEC = "PatNO:%String,PatMedcare:%String,PatName:%String,PatLOC:%String,Patadmdate:%String,PatDisDate:%String,PatDrugmount:%String,PatDrugDIVmountA:%String,PatDrugDIVmountB:%String,PatMedmount:%String,PatMedDIVmountA:%String,PatMedDIVmountB:%String,MZZFYa:%String,ZFFYa:%String,GRZHa:%String,TCZFa:%String,otherfeeA:%String,otherfeeB:%String,HISfee:%String,NHPatType:%String,InINSUFee:%String,OutINSUFee:%String,InDate:%String,AdmDoc:%String,Group:%String") [ SqlProc ]
{
}

ClassMethod ZZRepQueryNHBXClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ZZRepQueryNHBXExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod ZZRepQueryNHBXExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, ReaDr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:$g(BeginDate)="" $$$OK
	q:$g(EndDate)="" $$$OK 
	s:$l(BeginDate)=10 BeginDate=$zdh(BeginDate,3)
	s:$l(EndDate)=10 EndDate=$zdh(EndDate,3)
	f date=BeginDate:1:EndDate d
	.s INPAYID=""
	.f  s INPAYID=$o(^DHCINDIV("0","IDate",date,INPAYID)) q:INPAYID=""  d
	..s Divinfo=$g(^DHCINDIV(INPAYID))
	..s (PatNO,PatMedcare,PatName,PatLOC,Patadmdate,PatDisDate,NHPatType)=""
	..s (PatDrugmount,PatDrugDIVmountA,PatDrugDIVmountB,PatMedmount,PatMedDIVmountA,PatMedDIVmountB,MZZFYa,ZFFYa,GRZHa,TCZFa,otherfeeA,otherfeeB,HISfee)=0
	..q:$l(Divinfo,"^")<2
	..s INPAYFlag=$p(Divinfo,"^",5)  //标记
	..q:INPAYFlag'="I"  //作废的退出
	..s PAADM=$p(Divinfo,"^",1)
	..s INADMInsuType=$p(Divinfo,"^",2)  //医保类型ZZA,ZZB,ZZC
	..Q:INADMInsuType=""
	..S INADMInsuTypeA=$P(^DHCINADM(INADMInsuType),"^",18)
	..Q:INADMInsuTypeA'="ZZC"   //新农合
	..s PAPMIDR=$p(^PAADM(PAADM),"^",1)
	..s EpisodeID=$o(^PAPERdr(PAPMIDR,"ADM","I",""),-1) //add by lhd
	..s admglobalstr=^PAADM(EpisodeID)
	..s admdocdr=$p(admglobalstr,"^",9)
	..;q:((DoctorID'=admdocdr)&&(admdocdr'=""))   //xzl
	..I (admdocdr'="")&&($d(^CTPCP(admdocdr,1))'=0) s AdmDoc=$p(^CTPCP(admdocdr,1),"^",2)
	..s Group=##class(web.DHCINSUZZRep).GetGroupInfo(admdocdr)
 	..q:$p(^PAADM(PAADM),"^",2)'="I" //住院病人
	..s PatNO=$p(^PAPER(PAPMIDR,"PAT",1),"^",1)
	..s PatMedcare=##class(web.DHCWMRService).IGetMrNoByEpisodeID(PAADM) ;$p(^PAPER(PAPMIDR,"PAT",1),"^",22)
	..s PatName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)
	..s PatLOC=$P($p(^CTLOC($p(^PAADM(PAADM),"^",4)),"^",2),"-",2)
	..s Patadmdate=$zd($p(^PAADM(PAADM),"^",6),3)
	..s PatDisDate=$zd($p(^PAADM(PAADM),"^",17),3)
	..s InDate=($p(^PAADM(PAADM),"^",17))-($p(^PAADM(PAADM),"^",6))
	..s admreasonDr=$p(^PAADM(PAADM,1),"^",7)   //病 人  DR
	..s MZZFYa=+$p(Divinfo,"^",7)  //总金额
    ..s ZFFYa=+$p(Divinfo,"^",39)+$p(Divinfo,"^",40)+$p(Divinfo,"^",41)+$p(Divinfo,"^",42)++$p(Divinfo,"^",43)+$p(Divinfo,"^",51)+$p(Divinfo,"^",53)+$p(Divinfo,"^",54) //自费
	..s GRZHa=+$p(Divinfo,"^",28) //个人账户
	..s TCZFa=+$p(Divinfo,"^",31) ////统筹记账
	..s TCZFa=+$p(Divinfo,"^",31) ////统筹记账
	..s PBRowId=$p(Divinfo,"^",3) ////统筹记账
	
	..s PacAdmreasonDr=$p($g(^PAADM(PAADM,1)),"^",7) ;add by dingsh 2013-03-26
	..s NHPatType=$p($g(^PAC("ADMREA",PacAdmreasonDr)),"^",2) ;add by dingsh 2013-03-26
	..q:(PacAdmreasonDr'=ReaDr)&(ReaDr'="")
	..s PBOChildSub=""
	..f  s PBOChildSub=$o(^DHCPB(PBRowId,"O",PBOChildSub)) q:PBOChildSub=""  d
	...s PBDChildSub="0"
	...f  s PBDChildSub=$o(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub)) q:PBDChildSub=""  d
	....s PBDTARIDR=$p(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub),"^",3)
	....s TARISubCate=$p(^DHCTARI(PBDTARIDR),"^",4)
	....s PBDTotalAmount=$p(^DHCPB(PBRowId,"O",PBOChildSub,"D",PBDChildSub),"^",7)
	....s RtnStr=##class(web.DHCINSUPort).GetINSUZFBL(PBDTARIDR,admreasonDr,"")
	....if $p(RtnStr,"^",2)="保内" d
    .....if (TARISubCate=73)!(TARISubCate=74)  d //保内材料费
    ......s PatMedDIVmountA=PatMedDIVmountA+PBDTotalAmount
    ......s PatMedmount=PatMedmount+PBDTotalAmount
    ......s HISfee=HISfee+PBDTotalAmount
    .....else  if ((TARISubCate=1)||(TARISubCate=2)||(TARISubCate=3)||(TARISubCate=4)) d //保内西药费
    ......s PatDrugDIVmountA=PatDrugDIVmountA+PBDTotalAmount
    ......s PatDrugmount=PatDrugmount+PBDTotalAmount
    ......s HISfee=HISfee+PBDTotalAmount
    .....else  s otherfeeA=otherfeeA+PBDTotalAmount,HISfee=HISfee+PBDTotalAmount
    ....else  d
    .....if (TARISubCate=73)!(TARISubCate=74)  d //材料费
    ......s PatMedDIVmountB=PatMedDIVmountB+PBDTotalAmount
    ......s PatMedmount=PatMedmount+PBDTotalAmount
    ......s HISfee=HISfee+PBDTotalAmount
    .....else  if ((TARISubCate=1)||(TARISubCate=2)||(TARISubCate=3)||(TARISubCate=4)) d //西药费
    ......s PatDrugDIVmountB=PatDrugDIVmountB+PBDTotalAmount
    ......s PatDrugmount=PatDrugmount+PBDTotalAmount
    ......s HISfee=HISfee+PBDTotalAmount
    .....else  s otherfeeB=otherfeeB+PBDTotalAmount,HISfee=HISfee+PBDTotalAmount
    ....s InINSUFeeA=(PatDrugDIVmountA+PatMedDIVmountA+otherfeeA)  ;/HISfee
    ....q:HISfee=0
    ....s InINSUFee=(+InINSUFeeA)/(+HISfee)
    ....s InINSUFee=$FNUMBER(InINSUFee,"",3)
    ..d BuildNHBXA
	Quit $$$OK	
BuildNHBXA	
	set Data=$lb(PatNO,PatMedcare,PatName,PatLOC,Patadmdate,PatDisDate,PatDrugmount,PatDrugDIVmountA,PatDrugDIVmountB,PatMedmount,PatMedDIVmountA,PatMedDIVmountB,MZZFYa,ZFFYa,GRZHa,TCZFa,otherfeeA,otherfeeB,HISfee,NHPatType,InINSUFee,"",InDate,AdmDoc,Group)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ZZRepQueryNHBXFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ZZRepQueryNHBXExecute ]
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

//d ##Class(%ResultSet).RunQuery("web.DHCINSUZZRep","ZZARepQuery","2015-06-01","2015-06-03","","","")

Query ZZARepQuery(BeginDate As %String, EndDate As %String, InsuAdmType As %String, HisAdmType As %String, InsuPatType As %String) As %Query(ROWSPEC = "Ind:%String,PatName:%String,AdmNo:%String,OutDiag:%String,AdmType:%String,AdmTypeDesc:%String,PatType:%String,PatTypeDesc:%String,Days:%String,grzfe0:%String,zhzfe0:%String,InsuPay1:%String,InsuPay2:%String,InsuPay3:%String,InsuPay4:%String,InsuPay5:%String,bcbxf0:%String,AdmSeriNo:%String,PatID:%String,zfxmje0:%String,jbylgrzf0:%String,deylgrzf0:%String,TGBZ:%String,cxe0:%String,BriType:%String,TES:%String,TC:%String,AdmDate:%String,InsuPay6:%String,DischgDate:%String,qfbz:%String,SYPatName:%String") [ SqlProc ]
{
}

ClassMethod ZZARepQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ZZARepQueryExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod ZZARepQueryExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, InsuAdmType As %String, HisAdmType As %String, InsuPatType As %String) As %Status
{
	n (qHandle,BeginDate,EndDate, InsuAdmType, HisAdmType, InsuPatType )
	s ^Test("TT")=BeginDate_"^"_EndDate
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:$g(BeginDate)="" $$$OK
	q:$g(EndDate)="" $$$OK
	;Ind,PatName,AdmNo,OutDiag,AdmType,AdmTypeDesc,PatType,PatTypeDesc,Days,grzfe0,zhzfe0,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,bcbxf0
	s ^aaTMPZMC("ZZARepQuery")=BeginDate_"^"_EndDate
	s:$l(BeginDate)=10 BeginDate=$zdh(BeginDate,3)
	s:$l(EndDate)=10 EndDate=$zdh(EndDate,3)

	f date=BeginDate:1:EndDate d
	.s INPAYID=""
	.f  s INPAYID=$o(^DHCINDIV("0","IDate",date,INPAYID)) q:INPAYID=""  d
	..s Divinfo=$g(^DHCINDIV(INPAYID))
	..s (Ind,PatName,AdmNo,OutDiag,AdmType,AdmTypeDesc,PatType,PatTypeDesc,Days,grzfe0,zhzfe0,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,bcbxf0,AdmSeriNo,PatID,zfxmje0,jbylgrzf0,deylgrzf0,TGBZ,cxe0,BriType,TES,TC,AdmDate,InsuPay6,DischgDate,qfbz,SYPatName)=""
	..q:$l(Divinfo,"^")<2
	..s PAADM=$p(Divinfo,"^",1)
	..s PAPMIDR=$p(^PAADM(PAADM),"^",1)
	..if HisAdmType="O" q:($p(^PAADM(PAADM),"^",2)'=HisAdmType)&($p(^PAADM(PAADM),"^",2)'="E")
	..if HisAdmType="I" q:$p(^PAADM(PAADM),"^",2)'=HisAdmType
	..s HAdmType=$p(^PAADM(PAADM),"^",2)
	..s:HAdmType="E" HAdmType="O"
	..s insuadminfo=$p(Divinfo,"^",2)   //insu_adminfo
	..q:insuadminfo=""
	..s insutype=$p(^DHCINADM(insuadminfo),"^",18) ;医保类型
	..Q:insutype'="ZZA"  //省医保
	..s Flag=$p(Divinfo,"^",5)
	..q:Flag'="I"
	..s AdmType=$p(^DHCINADM(insuadminfo),"^",14) ;患者医保就诊类别
	..;q:(InsuAdmType'="")&(InsuAdmType'[AdmType) 
	..q:(InsuAdmType'="")&((","_InsuAdmType_",")'[(","_AdmType_","))
	..s dicstr=##class(web.INSUDicDataCom).QueryDicDataByCode("AKA130ZZA",AdmType)
	..s:$l(dicstr,"^")>4 AmdType=$p(dicstr,"^",3)
	..s AdmTypeDesc=$p(dicstr,"^",4) 
	..s PatType=$p(^DHCINADM(insuadminfo),"^",4) ;患者人员类别
	..q:(InsuPatType'="")&(InsuPatType'[PatType)
	..;i RepType="1" q:(PatType="31")||(PatType="32")||(PatType="33")
	..;i RepType="2" q:(PatType="31")||(PatType="32")||(PatType="33")
	..;i RepType="3" q:(AdmType'="51")&(AdmType'="52")&(AdmType'="521")&(AdmType'="53")&(AdmType'="54")
	..;i RepType="4" q:(PatType'="31")&(PatType'="32")&(PatType'="33")
	..;i RepType="5" q:(PatType'="31")&(PatType'="32")&(PatType'="33")
	..s dicstr=##class(web.INSUDicDataCom).QueryDicDataByCode("AKC021ZZA",PatType)
	..s:$l(dicstr,"^")>4 PatType=$p(dicstr,"^",3)
    ..s PatTypeDesc=$p(dicstr,"^",4) 
	..s bcbxf0=+$p(Divinfo,"^",7) ;总费用
	..s InsuPay1=+$p(Divinfo,"^",31) ;统筹支付额
	..s InsuPay2=+$p(Divinfo,"^",32) ;大额补助
	..s InsuPay3=+$p(Divinfo,"^",33) ;公务员补助
	..s InsuPay4=+$p(Divinfo,"^",34) ;
	..s InsuPay5=+$p(Divinfo,"^",35) ;产前检查费
	..s InsuPay6=+$p(Divinfo,"^",46) ;厅级公补
	..s zhzfe0=+$p(Divinfo,"^",28) ;账户支付额
	..s grzfe0=+$p(Divinfo,"^",15) ;现金支付额
	..s AdmNo=$p(Divinfo,"^",30) ;就诊记录号
	..s zfxmje0=+$p(Divinfo,"^",39) ;自费项目金额 ZStr04
	..s cxe0=+$p(Divinfo,"^",43) ;超限额 ZStr08
	..s jbylgrzf0=+$p(Divinfo,"^",51) ;基本医疗个人自付ZStr11
	..s deylgrzf0=+$p(Divinfo,"^",53) ;大额医疗个人自付ZStr13
	..s AdmSeriNo=$p($g(^DHCINADM(insuadminfo)),"^",10) ;住院业务登记号
	..s PatID=$p($g(^DHCINADM(insuadminfo)),"^",34) ;身份证号
	..s PatName=$p($g(^DHCINADM(insuadminfo)),"^",35) ;姓名
	..s TGBZ=$p($g(^DHCINADM(insuadminfo)),"^",27) ;入院诊断
	..s OutDiagDesc=$p($g(^DHCINADM(insuadminfo)),"^",29) ;出院诊断
	..s OutDiag=##class(web.ZhaozexinINSUDIVIDESUB).getpatdiag(PAADM,"1")  ;取本院出院诊断
	..;s HAdmType=$p(^PAADM(PAADM),"^",2)
	..s:HAdmType="I" BriType=$p($g(^DHCINADM(insuadminfo)),"^",42) ;生育方式
	..s:(HAdmType="I")&(AdmType="54") BriType=$p($g(^DHCINADM(insuadminfo)),"^",41) ;生育方式
	..s:HAdmType="O" BriType=$p($g(^DHCINADM(insuadminfo)),"^",41) ;生育方式
	..s:HAdmType="I" dicstr=##class(web.INSUDicDataCom).QueryDicDataByCode("BTypeIPZZA",BriType)
	..s:(HAdmType="I")&(AdmType="54") dicstr=##class(web.INSUDicDataCom).QueryDicDataByCode("BearingItemIPZZA",BriType)
	..s:HAdmType="O" dicstr=##class(web.INSUDicDataCom).QueryDicDataByCode("BearingItemIPZZA",BriType)
	..s:$l(dicstr,"^")>4 BriType=$p(dicstr,"^",4)
	..s TES=+$p($g(^DHCINADM(insuadminfo)),"^",44) ;胎儿数
	..s TC=+$p($g(^DHCINADM(insuadminfo)),"^",45) ;胎次
	..s:AdmType="521" SYPatName=$p(^PAPER(PAPMIDR,"ALL"),"^",1)
	..s AdmDate=$p(^PAADM(PAADM),"^",6)
	..s DischgDate=$p(^PAADM(PAADM),"^",17)
	..s:DischgDate="" Days=0
	..s:DischgDate'="" Days=+(DischgDate-AdmDate)
	..s:DischgDate="" DischgDate=AdmDate
	..s AdmDate=$zd(AdmDate,3)
	..s:DischgDate'="" DischgDate=$zd(DischgDate,3)
	..s qfbz=+$p(Divinfo,"^",44) ;  ;起伏标准
	..d ZZARep
	Quit $$$OK
ZZARep 
    set Data=$lb(ind,PatName,AdmNo,OutDiag,AdmType,AdmTypeDesc,PatType,PatTypeDesc,Days,grzfe0,zhzfe0,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,bcbxf0,AdmSeriNo,PatID,zfxmje0,jbylgrzf0,deylgrzf0,TGBZ,cxe0,BriType,TES,TC,AdmDate,InsuPay6,DischgDate,qfbz,SYPatName)
 	Set ^CacheTemp(repid,ind)=Data 	
 	Set ind=ind+1
 	q
}

ClassMethod ZZARepQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ZZARepQueryExecute ]
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

/// 根据医保就诊ID分组  2 月结报表  
/// d ##Class(%ResultSet).RunQuery("web.DHCINSUZZRep","ZZAGroupByAdmTypeRepQuery","2015-06-01","2015-06-04","1")
Query ZZAGroupByAdmTypeRepQuery(BeginDate As %String, EndDate As %String, RepType As %String) As %Query(ROWSPEC = "INRC:%String,INRS:%String,Avgbcbxf0:%String,AdmType:%String,AdmTypeDesc:%String,grzfe0:%String,zhzfe0:%String,InsuPay1:%String,InsuPay2:%String,InsuPay3:%String,InsuPay4:%String,InsuPay5:%String,bcbxf0:%String,InsuPay6:%String,Tind:%String") [ SqlProc ]
{
}

ClassMethod ZZAGroupByAdmTypeRepQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ZZAGroupByAdmTypeRepQueryExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod ZZAGroupByAdmTypeRepQueryExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, RepType As %String) As %Status
{
	n (qHandle,BeginDate,EndDate,RepType)
	s ^Test("TT")=BeginDate_"^"_EndDate_"^"_RepType
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	k ^TmpINDataSum
	k ^TmpINRS
    ;控制报表显示格式
	if RepType="3" d ;省生育结算汇总申请单
	.;生育住院
	.s ^TmpINDataSum("SYZY")=0_"^"_0_"^"_0_"^"_"SYZY"_"^"_"生育住院"_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_"1"
	.;计划生育住院
	.s ^TmpINDataSum("54")=0_"^"_0_"^"_0_"^"_"54"_"^"_"计划生育住院"_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_"2"
	.;计划生育门诊
	.s ^TmpINDataSum("51")=0_"^"_0_"^"_0_"^"_"51"_"^"_"计划生育门诊"_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_"3"
	.;生育并发症
	.s ^TmpINDataSum("53")=0_"^"_0_"^"_0_"^"_"53"_"^"_"生育并发症"_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_"4"
	
	if RepType="2" d ;省普通结算汇总申请单
	.;普通门诊
	.s ^TmpINDataSum("11")=0_"^"_0_"^"_0_"^"_"11"_"^"_"普通门诊"_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_"1"
	.;门诊慢性病
	.s ^TmpINDataSum("15")=0_"^"_0_"^"_0_"^"_"15"_"^"_"门诊慢性病"_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_"2"
	.;丙肝
	.s ^TmpINDataSum("152")=0_"^"_0_"^"_0_"^"_"152"_"^"_"丙肝"_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_"3"
	.;普通住院
	.s ^TmpINDataSum("21")=0_"^"_0_"^"_0_"^"_"21"_"^"_"普通住院"_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_"4"
	.;家庭病床
	.s ^TmpINDataSum("31")=0_"^"_0_"^"_0_"^"_"31"_"^"_"家庭病床"_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_0_"^"_"5"
	
	s rcnum=0 ;人次
	s rsnum=0 ;人数
	q:$g(BeginDate)="" $$$OK
	q:$g(EndDate)="" $$$OK
	;INRC,INRS,Avgbcbxf0,AdmType,AdmTypeDesc,grzfe0,zhzfe0,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,bcbxf0
	s ^aaTMPZMC("ZZARepQuery")=BeginDate_"^"_EndDate_"^"_RepType
	s:$l(BeginDate)=10 BeginDate=$zdh(BeginDate,3)
	s:$l(EndDate)=10 EndDate=$zdh(EndDate,3)
	f date=BeginDate:1:EndDate d
	.s INPAYID=""
	.f  s INPAYID=$o(^DHCINDIV("0","IDate",date,INPAYID)) q:INPAYID=""  d
	..s Divinfo=$g(^DHCINDIV(INPAYID))
	..s (INRC,INRS,Avgbcbxf0,AdmType,AdmTypeDesc,grzfe0,zhzfe0,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,bcbxf0,InsuPay6)=""
	..q:$l(Divinfo,"^")<2
	..s PAADM=$p(Divinfo,"^",1)
	..s PAPMIDR=$p(^PAADM(PAADM),"^",1)
	..s PAPMINo=$p(^PAPER(PAPMIDR,"PAT",1),"^",1) ;登记号
	..s HisAdmType=$p(^PAADM(PAADM),"^",2)
	..s insuadminfo=$p(Divinfo,"^",2)   //insu_adminfo
	..q:insuadminfo=""
	..s insutype=$p(^DHCINADM(insuadminfo),"^",18) ;医保类型
	..Q:insutype'="ZZA"  //省医保
	..s PatType=$p($G(^DHCINADM(insuadminfo)),"^",4) ;患者人员类别
	..i RepType=4 q:(PatType'="31")&(PatType'="32")&(PatType'="33")
	..s Flag=$p(Divinfo,"^",5)
	..q:Flag'="I"
	..s AdmType=$p(^DHCINADM(insuadminfo),"^",14) ;患者医保就诊类别
	..i RepType="2" q:((PatType="31")||(PatType="32")||(PatType="33"))&&((AdmType="11")||(AdmType="21"))
	..i RepType="2" q:(AdmType="51")||(AdmType="52")||(AdmType="521")||(AdmType="53")||(AdmType="54") 
	..i RepType="3" q:(AdmType'="51")&(AdmType'="52")&(AdmType'="521")&(AdmType'="53")&(AdmType'="54")
	..i (AdmType="52")||(AdmType="521") s AdmType="SYZY" ;医疗类别 为 52 和 521 要统计在一起
	..i RepType="5" q:((PatType'="51")&(PatType'="52")&(PatType'="53")&(PatType'="54")) ;厅级干部分离统计
    ..i RepType="5" q:HisAdmType'="I"
    ..s dicstr=##class(web.INSUDicDataCom).QueryDicDataByCode("AKA130ZZA",AdmType)
	..s:$l(dicstr,"^")>4 AmdType=$p(dicstr,"^",3)
	..s AdmTypeDesc=$p(dicstr,"^",4)
	..;统计人数
	..i '$d(^TmpINRS(AdmType)) d
	...s ^TmpINRS(AdmType)=+1
	...s ^TmpINRS(AdmType,PAPMINo)=+1
	...s INRS=+1
	..e  d
	...i '$d(^TmpINRS(AdmType,PAPMINo)) d
	....s INRS=^TmpINRS(AdmType)+1
	....s ^TmpINRS(AdmType)=INRS
	....s ^TmpINRS(AdmType,PAPMINo)=+1
	..s INDataSum=$g(^TmpINDataSum(AdmType))
	..s Tind=$p($g(^TmpINDataSum(AdmType)),"^",15)
	..i INDataSum="" d 
	...s INRC=+1
	...;s INRS=+1
	...s bcbxf0=+$p(Divinfo,"^",7) ;总费用
	...s InsuPay1=+$p(Divinfo,"^",31) ;统筹支付额
	...s InsuPay2=+$p(Divinfo,"^",32) ;公务员补助
	...s InsuPay3=+$p(Divinfo,"^",33) ;大额补助
	...s InsuPay4=+$p(Divinfo,"^",34) ;
	...s InsuPay5=+$p(Divinfo,"^",35) ;产前检查费
	...s InsuPay6=+$p(Divinfo,"^",46) ;厅级补助
	...s zhzfe0=+$p(Divinfo,"^",28) ;账户支付额
	...s grzfe0=+$p(Divinfo,"^",15) ;现金支付额
	..e  d
	...s INRC=+$p(INDataSum,"^",1)+1 ;人次
	...;s INRS=+$p(INDataSum,"^",2) ;人数
	...s tmpbcbxf0=+$p(INDataSum,"^",13) ;总费用
	...s tmpInsuPay1=+$p(INDataSum,"^",8) ;统筹支付额
	...s tmpInsuPay2=+$p(INDataSum,"^",9) ;公务员补助
	...s tmpInsuPay3=+$p(INDataSum,"^",10) ;大额补助
	...s tmpInsuPay4=+$p(INDataSum,"^",11) ;
	...s tmpInsuPay5=+$p(INDataSum,"^",12) ;产前检查费
	...s tmpInsuPay6=+$p(INDataSum,"^",14) ;厅级干部补助
	...s tmpzhzfe0=+$p(INDataSum,"^",7) ;账户支付额
	...s tmpgrzfe0=+$p(INDataSum,"^",6) ;现金支付额
	...s bcbxf0=+$p(Divinfo,"^",7)+tmpbcbxf0 ;总费用
	...s InsuPay1=+$p(Divinfo,"^",31)+tmpInsuPay1 ;统筹支付额
	...s InsuPay2=+$p(Divinfo,"^",32)+tmpInsuPay2 ;公务员补助
	...s InsuPay3=+$p(Divinfo,"^",33)+tmpInsuPay3 ;大额补助
	...s InsuPay4=+$p(Divinfo,"^",34)+tmpInsuPay4 ;
	...s InsuPay5=+$p(Divinfo,"^",35)+tmpInsuPay5 ;产前检查费
	...s InsuPay6=+$p(Divinfo,"^",46)+tmpInsuPay6 ;厅级干部补助
	...s zhzfe0=+$p(Divinfo,"^",28)+tmpzhzfe0 ;账户支付额
	...s grzfe0=+$p(Divinfo,"^",15)+tmpgrzfe0 ;现金支付额
	..i INRC'=0 d
	...s Avgbcbxf0=$j(bcbxf0/INRC,3,2)
	..s INRS=$G(^TmpINRS(AdmType))
	..s ^TmpINDataSum(AdmType)=INRC_"^"_INRS_"^"_Avgbcbxf0_"^"_AdmType_"^"_AdmTypeDesc_"^"_grzfe0_"^"_zhzfe0_"^"_InsuPay1_"^"_InsuPay2_"^"_InsuPay3_"^"_InsuPay4_"^"_InsuPay5_"^"_bcbxf0_"^"_InsuPay6_"^"_Tind
	s INAdmType=""
	f  s INAdmType=$o(^TmpINDataSum(INAdmType)) q:INAdmType=""  d
	.s (INRC,Avgbcbxf0,AdmType,AdmTypeDesc,grzfe0,zhzfe0,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,bcbxf0)="" 
	.s DataString=$g(^TmpINDataSum(INAdmType))
	.s INRC=$P(DataString,"^",1)
	.s INRS=$P(DataString,"^",2)
	.s Avgbcbxf0=$P(DataString,"^",3)
	.s AdmType=$P(DataString,"^",4)
	.s AdmTypeDesc=$P(DataString,"^",5)
	.s grzfe0=$P(DataString,"^",6)
	.s zhzfe0=$P(DataString,"^",7)
	.s InsuPay1=$P(DataString,"^",8)
	.s InsuPay2=$P(DataString,"^",9)
	.s InsuPay3=$P(DataString,"^",10)
	.s InsuPay4=$P(DataString,"^",11)
	.s InsuPay5=$P(DataString,"^",12)
	.s bcbxf0=$P(DataString,"^",13)
	.s InsuPay6=$P(DataString,"^",14)
	.i RepType=2 s InsuPay3=InsuPay3-InsuPay6     /////公务员？
	.s Tind=+$P(DataString,"^",15)
	.d ZZARep1
	Quit $$$OK
ZZARep1  	

	set Data=$lb(INRC,INRS,Avgbcbxf0,AdmType,AdmTypeDesc,grzfe0,zhzfe0,InsuPay1,InsuPay2,InsuPay3,InsuPay4,InsuPay5,bcbxf0,InsuPay6,Tind)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod ZZAGroupByAdmTypeRepQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ZZAGroupByAdmTypeRepQueryExecute ]
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

//d ##Class(%ResultSet).RunQuery("web.DHCINSUZZRep","ZZCDBBCRepQuery","2014-06-01","2015-06-03","")

Query ZZCDBBCRepQuery(BeginDate As %String, EndDate As %String, States As %String) As %Query(ROWSPEC = "Ind:%String,PatName:%String,AdmNo:%String,OutDiag:%String,AdmType:%String,AdmTypeDesc:%String,PatType:%String,PatTypeDesc:%String,Days:%String,grzfe0:%String,zhzfe0:%String,InsuPay1:%String,InsuPay2:%String,bcbxf0:%String,AdmSeriNo:%String,PatID:%String,AdmDate:%String,DischgDate:%String,StatesDesc:%String,SexDesc:%String,InsuNo:%String,DepDesc:%String,User:%String,AdmReason:%String") [ SqlProc ]
{
}

ClassMethod ZZCDBBCRepQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ZZCDBBCRepQueryExecute ]
{
	
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod ZZCDBBCRepQueryExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, States As %String) As %Status
{
	n (qHandle,BeginDate,EndDate, States )
	s ^Test("TT")=BeginDate_"^"_EndDate
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	q:$g(BeginDate)="" $$$OK
	q:$g(EndDate)="" $$$OK

	s:$l(BeginDate)=10 BeginDate=$zdh(BeginDate,3)
	s:$l(EndDate)=10 EndDate=$zdh(EndDate,3)

	f date=BeginDate:1:EndDate d
	.s INPAYID=""
	.f  s INPAYID=$o(^DHCINDIV("0","IDate",date,INPAYID)) q:INPAYID=""  d
	..s Divinfo=$g(^DHCINDIV(INPAYID))
	..s (Ind,PatName,AdmNo,OutDiag,AdmType,AdmTypeDesc,PatType,PatTypeDesc,Days,grzfe0,zhzfe0,InsuPay1,InsuPay2,bcbxf0,AdmSeriNo,PatID,AdmDate,DischgDate,StatesDesc,InsuNo,SexDesc,DepDesc,User,AdmReason)=""
	..q:$l(Divinfo,"^")<2
	..s PAADM=$p(Divinfo,"^",1)
	..s insuadminfo=$p(Divinfo,"^",2)   //insu_adminfo
	..q:insuadminfo=""
	..s insutype=$p(^DHCINADM(insuadminfo),"^",18) ;医保类型
	..Q:insutype'="ZZC"  //新农合
	..s Flag=$p(Divinfo,"^",5)
	..q:Flag'="I"
	..s AdmType=$p(^DHCINADM(insuadminfo),"^",14) ;患者医保就诊类别
	..s dicstr=##class(web.INSUDicDataCom).QueryDicDataByCode("AKA130ZZC",AdmType)
	..s:$l(dicstr,"^")>4 AmdType=$p(dicstr,"^",3)
	..s AdmTypeDesc=$p(dicstr,"^",4) 
	..s PatType=$p(^DHCINADM(insuadminfo),"^",4) ;患者人员类别
	..s dicstr=##class(web.INSUDicDataCom).QueryDicDataByCode("AKC021ZZC",PatType)
	..s:$l(dicstr,"^")>4 PatType=$p(dicstr,"^",3)
    ..s PatTypeDesc=$p(dicstr,"^",4) 
    ..s XString9=$p(^DHCINADM(insuadminfo),"^",38)
    ..q:(States'="")&&(XString9'=States)
    ..s dicstr=##class(web.INSUDicDataCom).QueryDicDataByCode("AreaXXH",XString9)
	..s:$l(dicstr,"^")>4 StatesDesc=$p(dicstr,"^",4)  ;试点县
	..s bcbxf0=+$p(Divinfo,"^",7) ;总费用
	..s InsuPay1=+$p(Divinfo,"^",31) ;统筹支付额
	..s InsuPay2=+$p(Divinfo,"^",32) ;大额补助
	..;q:(InsuPay2=0)
	..s zhzfe0=+$p(Divinfo,"^",28) ;账户支付额
	..s grzfe0=+$p(Divinfo,"^",15) ;现金支付额
	..s AdmNo=$p(Divinfo,"^",30) ;就诊记录号
	..s UserDr=$p(Divinfo,"^",23) ;核算人Dr
	..i UserDr'="" d
	...s User=$p($g(^SSU("SSUSR",UserDr)),"^",2)
	..s AdmSeriNo=$p($g(^DHCINADM(insuadminfo)),"^",10) ;住院业务登记号
	..s PatID=$p($g(^DHCINADM(insuadminfo)),"^",34) ;身份证号
	..s PatName=$p($g(^DHCINADM(insuadminfo)),"^",35) ;姓名
	..s OutDiagDesc=$p($g(^DHCINADM(insuadminfo)),"^",29) ;出院诊断
	..s OutDiag=##class(web.ZhaozexinINSUDIVIDESUB).getpatdiag(PAADM,"1")  ;取本院出院诊断
	..s InsuNo=$p($g(^DHCINADM(insuadminfo)),"^",2) ;医疗证号
	..s SexDesc=$p($g(^DHCINADM(insuadminfo)),"^",36) ;性别
	..s DepID=$p(^PAADM(PAADM),"^",4)
	..i (DepID="") d
	...s DepCode=""
	...s DepDesc=""
	..e  d
	...i ('$d(^CTLOC(DepID))) d
	....s DepCode=""
	....s DepDesc=""
	...e  d
	....s DepCode=$p(^CTLOC(DepID),"^",1) ;出院科室编码
	....s DepDesc=$P(^CTLOC(DepID),"^",2) ;出院科室名称
	..s AdmDate=$p(^PAADM(PAADM),"^",6)
	..s DischgDate=$p(^PAADM(PAADM),"^",17)
	..s:DischgDate="" Days=0
	..s:DischgDate'="" Days=+(DischgDate-AdmDate)
	..s:DischgDate="" DischgDate=AdmDate
	..s AdmDate=$zd(AdmDate,3)
	..s:DischgDate'="" DischgDate=$zd(DischgDate,3)
	..s AdmReasonDr=$p(^PAADM(PAADM,1),"^",7)
	..i AdmReasonDr'="" d
	...s AdmReason=$p(^PAC("ADMREA",AdmReasonDr),"^",2)
	..d ZZCDBBCRep
	Quit $$$OK
ZZCDBBCRep 
    set Data=$lb(ind,PatName,AdmNo,OutDiag,AdmType,AdmTypeDesc,PatType,PatTypeDesc,Days,grzfe0,zhzfe0,InsuPay1,InsuPay2,bcbxf0,AdmSeriNo,PatID,AdmDate,DischgDate,StatesDesc,SexDesc,InsuNo,DepDesc,User,AdmReason)
 	Set ^CacheTemp(repid,ind)=Data 	
 	Set ind=ind+1
 	q
}

ClassMethod ZZCDBBCRepQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ZZCDBBCRepQueryExecute ]
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

/// 取医生所在分组信息
/// w ##class(web.DHCINSUZZRep).GetGroupInfo("2620")
ClassMethod GetGroupInfo(DocId As %String) As %String
{
  
 	s mCode="DocTJ"
    s code=$zcvt(mCode,"U")
    s grpId=0 
    s Data=""
	f  s grpId=$o(^DHCWL.CodeCfg.GroupI("Code"," "_code,grpId)) q:grpId=""  d
	.s subgrpId=0 
	.f  s subgrpId=$o(^DHCWL.CodeCfg.SubGroupI("GrpDr",grpId,subgrpId)) q:subgrpId=""  d
	..;s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
	..;s subgrpDesc=value.SGrpDesc_"^"_"subgrpId:"_subgrpId
	..;w !,"subgrpDesc:"_subgrpDesc
	..;s subgrpCode=value.SGrpCode
	..s subgrpItemId=0 
	..;w !,"subgrpDesc:"_subgrpDesc
	..f  s subgrpItemId=$o(^DHCWL.CodeCfg.SubGroupItemI("SGrpIM",subgrpId,subgrpItemId))  q:subgrpItemId=""  d
    ...s subgrpItemIdi=$tr(subgrpItemId," ","")  q:subgrpItemIdi="" 
    ...;s ^TEMPDHCWL($j,"DocGrp",subgrpItemIdi)=subgrpId
    ...s value=##class(DHCWL.CodeCfg.SubGroup).%OpenId(subgrpId)
    ...Q:$g(subgrpItemIdi)'=$g(DocId)
    ...s subgrpDesc=value.SGrpDesc
    ...;s subgrpDesc=$p(value.SGrpCode,"-",1)
    ...s Data=subgrpDesc
    q Data
}*/
}
