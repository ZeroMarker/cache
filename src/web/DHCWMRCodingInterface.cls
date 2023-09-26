/// 病案编目数据导出接口
/// by wuqk 2008-06
Class web.DHCWMRCodingInterface Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 37;

/***********************************************
/导出病案编目数据：getFrontPageICDList
/入参：
/  1-Paadm               就诊号
/  2-GetType             类型
/        D:              主要诊断
/                        次要诊断
/                        医院感染诊断
/                        病理诊断
/                        损伤、中毒的外部因素
/                        中医主病
/                        中医门急诊诊断
/                        中医主症
/        O/1:            手术
/        O/2:            操作
/        E/1:            病案类型
/  3-Index               第几条记录
/出参：ret
/
/注:
/输出方式：
/一次传出某一条(诊断、手术、操作)信息
/字段之间用$c(2)分割     例：ICD10 $c(2) 诊断描述 $c(2) 出院情况
/如果没有这条记录,传回空
/
/基础字典维护(描述,代码)
/1-诊断类型维护
/主要诊断                 1
/次要诊断                 2
/感染诊断                 3
/病理诊断                 4
/损伤中毒诊断             5
/西医门急诊诊断           6
/中医门急诊诊断           11
/中医主病                 9
/中医主症                 10
/
/2-手术操作类型维护
/手术                     1
/操作                     2
/w ##Class(web.DHCWMRCodingInterface).getFrontPageICD(77022,"O/1",1)
/诊断返回值：    ICD10 $c(2) 诊断描述 $c(2) 出院情况
/手术操作返回值：ICD10$c(2)手术名称$c(2)手术操作日期$c(2)术者$c(2)一助$c(2)二助$c(2)麻醉方式$c(2)愈合情况$c(2)麻醉师
***********************************************/
ClassMethod getFrontPageICDList(Paadm, GetType)
{
	n (Paadm,GetType)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).getFrontPageICDList(Paadm, GetType)
		quit return
	}
	
	k ^CacheTemp("DHCWMRDISInterface",$j)
	s ret=""
	q:Paadm="" ret
	q:GetType="" ret
	s ICDType=$p(GetType,"/",1)
	s OperType=$p(GetType,"/",2)
	q:(ICDType'="D")&(ICDType'="O") ret
	q:(ICDType="O")&((OperType'="1")&(OperType'="2")) ret
	
	;取卷
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	q:'$d(^DHCWMRVOL(0,"VolAdm",Paadm)) ret
	s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",Paadm,""),-1)
	q:VolRowid="" ret
	
	;取首页
	;^DHCWMRFP(0,"VolumeDr",{VolumeDr},{RowId})
	q:'$d(^DHCWMRFP(0,"VolumeDr",VolRowid)) ret
	s FPRowid=$o(^DHCWMRFP(0,"VolumeDr",VolRowid,""),-1)
	q:FPRowid="" ret
	
	;取ICD列表
	;^DHCWMRFPICD(0,"FP",{FrontPageDr}
	q:'$d(^DHCWMRFPICD(0,"FP",FPRowid)) ret
	
	s FPICDRowid=0,index=1
	f  s FPICDRowid=$o(^DHCWMRFPICD(0,"FP",FPRowid,FPICDRowid)) q:FPICDRowid=""  d
	.s sICD=$g(^DHCWMRFPICD(FPICDRowid))
	.s ICDTypeDr=$p(sICD,"^",10)     ;ICD类型 诊断/手术操作
	.s OperTypeDr=$p(sICD,"^",14)     ;手术/操作类型
	.s sOperDic="",sICDTypeDic=""
	.s:ICDTypeDr'="" sICDTypeDic=##class(web.DHCWMRDictionaryCtl).GetDataById(ICDTypeDr)
	.s:OperTypeDr'="" sOperDic=##class(web.DHCWMRDictionaryCtl).GetDataById(OperTypeDr)
	.s sICDTypeCode=$p(sICDTypeDic,"^",3)
	.s sOperTypeCode=$p(sOperDic,"^",3)
	.q:sICDTypeCode'=ICDType
	.q:(ICDType="O")&(sOperTypeCode'=OperType)
	.s sOutput=""
	.s:ICDType="D" sOutput=$$BuildDisString(FPICDRowid,OperType)
	.s:ICDType="O" sOutput=$$BuildOperString(FPICDRowid,OperType)
	.i (ICDType="D")&(+sOperTypeCode>2) d  ;诊断 且 诊断类型不是主要诊断和其它诊断
	..s ^CacheTemp("DHCWMRDISInterface",$j,+sOperTypeCode)=sOutput
	.e  d
	..s $p(ret,$c(1),index)=sOutput
	.s index=index+1
	if ICDType="D" do
	.set $p(ret,$c(1),10)=$g(^CacheTemp("DHCWMRDISInterface",$j,3))  ;院内感染诊断
	.set $p(ret,$c(1),11)=$g(^CacheTemp("DHCWMRDISInterface",$j,4))  ;病理诊断
	.set $p(ret,$c(1),12)=$g(^CacheTemp("DHCWMRDISInterface",$j,5))  ;损伤中毒诊断
	q ret
BuildDisString(FPICDRowid,OperType)
    ;ICD10 $c(2) 诊断描述 $c(2) 出院情况$c(2)诊断类型代码/诊断类型描述
    n (FPICDRowid,OperType)
    s sOut=""
    s sICD=$g(^DHCWMRFPICD(FPICDRowid))
    s ICDDr=$p(sICD,"^",2)
    s ResultDr=$p(sICD,"^",3)
    //****************************************
    s scrType=-1
    s:OperType=10 scrType=4  //中医主症取自MRC_DiagnosSignSymptom表
    //****************************************
    s sICDDictionary=##class(web.DHCWMRMedBaseICD).GetMyICDByRowId(ICDDr,scrType)
    q:sICDDictionary="" sOut
    s HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode()
    i ((OperType=4)||(OperType=5))&&(HospCode="ChangChun_JDSY") d   //吉大三院 病理诊断和损伤中毒诊断取附加码,附加码为空取主码
    .s:$p(sICDDictionary,"^",3)'="" $p(sICDDictionary,"^",3)=$p(sICDDictionary,"^",4)
    s sResultDic=##class(web.DHCWMRDictionaryCtl).GetDataById(ResultDr)
    s ICD10=$p(sICDDictionary,"^",2)
    s ICDDesc=$p(sICDDictionary,"^",4)
    s ResultCode=$p(sResultDic,"^",3)
    s DiagType=$p(sICD,"^",14)
    s sDiagTypeDic=##class(web.DHCWMRDictionaryCtl).GetDataById(DiagType)
    s sDiagTypeStr=$p(sDiagTypeDic,"^",3)_"/"_$p(sDiagTypeDic,"^",4)
    s sOut=ICD10_$c(2)_ICDDesc_$c(2)_ResultCode_$c(2)_sDiagTypeStr
    q sOut
BuildOperString(FPICDRowid,OperType)
    ;ICD10$c(2)手术名称$c(2)手术操作日期$c(2)术者$c(2)一助$c(2)二助$c(2)麻醉方式$c(2)愈合情况$c(2)麻醉师$c(2)手术等级
    n (FPICDRowid,OperType)
    s sOut=""
    s sICD=$g(^DHCWMRFPICD(FPICDRowid))
    s ICDDr=$p(sICD,"^",2)
    s OperDate=$zd(+$p(sICD,"^",13),3)
    s OperatorDr=$p(sICD,"^",4)
    s Ass1Dr=$p(sICD,"^",5)
    s Ass2Dr=$p(sICD,"^",6)
    s NarcTypeDr=$p(sICD,"^",7)
    s CloseUpDr=$p(sICD,"^",9)
    s NarcDocDr=$p(sICD,"^",8)
    s OperationRankID=$p(sICD,"^",15)
    s OperType=$p(sICD,"^",14)
    s sOperTypeDic=##class(web.DHCWMRDictionaryCtl).GetDataById(OperType)
    s sOperTypeStr=$p(sOperTypeDic,"^",3)_"/"_$p(sOperTypeDic,"^",4)
    s sICDDictionary=##class(web.DHCWMRMedBaseICD).GetMyOperByRowId(ICDDr)
    q:sICDDictionary="" sOut
    s OperationRankDic=##class(web.DHCWMRDictionaryCtl).GetDataById(OperationRankID)
    
    s Operator=##class(web.DHCWMRMedBaseCtl).GetUsrStr(OperatorDr)
    s Ass1=##class(web.DHCWMRMedBaseCtl).GetUsrStr(Ass1Dr)
    s Ass2=##class(web.DHCWMRMedBaseCtl).GetUsrStr(Ass2Dr)
    s NarcDoc=##class(web.DHCWMRMedBaseCtl).GetUsrStr(NarcDocDr)
    
    s NarcType=##class(web.DHCWMRDictionaryCtl).GetDataById(NarcTypeDr)
    s CloseUp=##class(web.DHCWMRDictionaryCtl).GetDataById(CloseUpDr)
    
    s ICD10=$p(sICDDictionary,"^",2)
    s ICDDesc=$p(sICDDictionary,"^",4)
    s OperatorCode=$p(Operator,"/",3)    ;2取代码 3取Name
    s Ass1Code=$p(Ass1,"/",3)
    //s Ass2Code=$p(Ass1,"/",3)
    s Ass2Code=$p(Ass2,"/",3)            //modify by wuqk 2009-09-23 地坛发现病案接口导出二助被一助覆盖
    s NarcTypeCode=$p(NarcType,"^",4)    ;麻醉方式 3代码 4描述
    s CloseUpCode=$p(CloseUp,"^",4)      ;切口愈合 3代码 4描述
    s NarcDocCode=$p(NarcDoc,"/",3)
    s OprationRank=$P(OperationRankDic,"^",4)
    s:OperType="2" CloseUpCode=""
    s sOut=ICD10_$c(2)_ICDDesc_$c(2)_OperDate_$c(2)_OperatorCode_$c(2)_Ass1Code_$c(2)_Ass2Code_$c(2)_NarcTypeCode_$c(2)_CloseUpCode_$c(2)_NarcDocCode_$c(2)_OprationRank_$c(2)_sOperTypeStr
    q sOut
BuildExtraString(FPICDRowid,Index) 	;Add by liuxuefeng 2009-11-23
    ;附加项目名称$c(2)ItemId$c(2)ItemValue
    ;武汉第一医院：ItemId=1，病案类型
    
    n (FPICDRowid,Index)
    s sOut=""
    ;^DHCWMRFPE(0,"FP",{FrontPageDr},{RowId})
   	s ExtraID=""
   	;b ;121
    f  s ExtraID=$o(^DHCWMRFPE(0,"FP",FPICDRowid,ExtraID)) q:ExtraID=""  d
    .s sExtra=$g(^DHCWMRFPE(ExtraID))
    .;w !,"sExtra="_sExtra
    .s ItemId=$p(sExtra,"^",2) 							;附加项目ID
    .;w !,"ItemId="_ItemId
    .s ItemValue=$p(sExtra,"^",3) 						;附加项目值
    .;s Pos=$p(sExtra,"^",3) 							;位置
    .q:Index'=ItemId
    .s sFPItemDic=$g(^DHCWMRFPIDIC(ItemId)) 			;附加项目字典字母串
    .s ExtraItemDesc=$p(sFPItemDic,"^",1)		 		;附加项目名称
    .s DictionaryName=$p(sFPItemDic,"^",4)				;附加项目绑定字典名称,指向DHC_WMR_Dictionary表中DictionaryName
    .;w !,"DictionaryName="_DictionaryName
    .;新增索引:^DHCWMRDIC(0,"DicNameDescCode",{DictionaryName},{Description},{Code},{Rowid})
    .s DicCode=""
    .;w !,"DictionaryName="_DictionaryName_";	ItemValue="_ItemValue
    .s:ItemValue'="" DicCode=$o(^DHCWMRDIC(0,"DicNameDescCode",DictionaryName,ItemValue,DicCode))
    .s sOut=ExtraItemDesc_$c(2)_ItemId_$c(2)_ItemValue_$c(2)_DicCode
    .;s sOut=ExtraItemDesc_"^"_ItemId_"^"_ItemValue_"^"_DicCode
	
	;w !,"sOut="_sOut,!
    q sOut
}

/**********************************************
/导出病案编目数据：getFrontPageICDList
/入参：
/  1-Paadm               就诊号
/  2-GetType             类型
/        D:              主要诊断
/                        次要诊断
/                        医院感染诊断
/                        病理诊断
/                        损伤、中毒的外部因素
/                        中医主病
/                        中医门急诊诊断
/                        中医主症
/        O/1:            手术
/        O/2:            操作
/        E/1:            病案类型
/  3-Index               第几条记录
/出参：ret
/
/注:
/输出方式：
/一次传出某一条(诊断、手术、操作)信息
/字段之间用$c(2)分割     例：ICD10 $c(2) 诊断描述 $c(2) 出院情况
/如果没有这条记录,传回空
/
/基础字典维护(描述,代码)
/基础字典维护(描述,代码)
/1-诊断类型维护
/主要诊断                 1
/次要诊断                 2
/感染诊断                 3
/病理诊断                 4
/损伤中毒诊断             5
/西医门急诊诊断           6
/中医门急诊诊断           11
/中医主病                 9
/中医主症                 10
/
/2-手术操作类型维护
/手术                     1
/操作                     2
/w ##Class(web.DHCWMRCodingInterface).getFrontPageICD(2150708,"E/1",1)
/诊断返回值：    ICD10 $c(2) 诊断描述 $c(2) 出院情况
/手术操作返回值：ICD10$c(2)手术名称$c(2)手术操作日期$c(2)术者$c(2)一助$c(2)二助$c(2)麻醉方式$c(2)愈合情况$c(2)麻醉师$c(2)手术
***********************************************/
ClassMethod getFrontPageICD(Paadm, GetType, Index)
{
	n (Paadm,GetType,Index)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).getFrontPageICD(Paadm, GetType, Index)
		quit return
	}
	
	s ret=""
	q:Paadm="" ret
	q:GetType="" ret
	s ICDType=$p(GetType,"/",1)
	s OperType=$p(GetType,"/",2)
	s Index=+$g(Index)
	s:Index<1 Index=1
	q:(ICDType'="D")&&(ICDType'="O")&&(ICDType'="E") ret
	q:(ICDType="D")&&((OperType'="1")&&(OperType'="2")&&(OperType'="3")&&(OperType'="4")&&(OperType'="5")&&(OperType'="6")&&(OperType'="9")&&(OperType'="10")&&(OperType'="11")) ret
	q:(ICDType="O")&&((OperType'="1")&&(OperType'="2")) ret
	q:(ICDType="E")&&(OperType'="1") ret
	
	;取卷
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	q:'$d(^DHCWMRVOL(0,"VolAdm",Paadm)) ret
	s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",Paadm,""),-1)
	q:VolRowid="" ret
	
	;取首页
	;^DHCWMRFP(0,"VolumeDr",{VolumeDr},{RowId})
	q:'$d(^DHCWMRFP(0,"VolumeDr",VolRowid)) ret
	s FPRowid=$o(^DHCWMRFP(0,"VolumeDr",VolRowid,""),-1)
	q:FPRowid="" ret
	
	;取ICD列表
	;^DHCWMRFPICD(0,"FP",{FrontPageDr}
	q:'$d(^DHCWMRFPICD(0,"FP",FPRowid)) ret
	;b ;12
	s sOut=""
	if (ICDType="D")||(ICDType="O"){
	s FPICDRowid=0,index=1
	f  s FPICDRowid=$o(^DHCWMRFPICD(0,"FP",FPRowid,FPICDRowid)) q:(FPICDRowid="")||(index>Index)  d
	.s sICD=$g(^DHCWMRFPICD(FPICDRowid))
	.s sICDTypeDr=$p(sICD,"^",10)       ;ICD类型
	.s:sICDTypeDr'="" sICDTypeDic=##class(web.DHCWMRDictionaryCtl).GetDataById(sICDTypeDr)
	.s sICDType=$p(sICDTypeDic,"^",3)
	.q:sICDType'=ICDType
	.s OperTypeDr=$p(sICD,"^",14)     ;诊断/手术/操作类型
	.s sOperDic=""
	.s:OperTypeDr'="" sOperDic=##class(web.DHCWMRDictionaryCtl).GetDataById(OperTypeDr)
	.s sOperTypeCode=$p(sOperDic,"^",3)
	.q:sOperTypeCode'=OperType
	.i index=Index d
	..s:ICDType="D" sOut=$$BuildDisString(FPICDRowid,OperType)
	..s:ICDType="O" sOut=$$BuildOperString(FPICDRowid,OperType)
	.s index=index+1
	}elseif (ICDType="E"){
		s sOut=$$BuildExtraString(FPRowid,OperType) 
	}
	q sOut
}

/********************************
/取住院次数
/入参：
/	Paadm   就诊号
/	Papmi	Pa_PatMas表Rowid
/出参：
/	ret     病人住院次数
/********************************/
ClassMethod getIPCount(Paadm, Papmi)
{
	n (Paadm,Papmi)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).getIPCount(Paadm, Papmi)
		quit return
	}
	
	s ret=0
	
	;取Papmi
	s Papmi=+Papmi
	s:+Paadm'=0 Papmi=+$p($g(^PAADM(+Paadm)),"^",1)
	q:Papmi=0 ret
	
	s MrType=7
    ;取病案类型设置
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" ret
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" ret
	;取病案号
	;paperson.paper_governcardno
	s:MrNoField="A" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoA(Papmi)
	;PA_PatMas.PAPMI_Medicare
	s:MrNoField="B" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoB(Papmi)
	;User.DHCPerson.PAPERFCMedicareCode1
	s:MrNoField="C" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoC(Papmi)
	;User.DHCPerson.PAPERFCMedicareCode2
	s:MrNoField="D" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoD(Papmi)
	q:MrNo="" ret
	
	;^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
	s MainId=0,IPCount=0
	f  s MainId=$o(^DHCWMRMAIN(0,"TypeNO",+MrType,MrNo,MainId)) q:(MainId="")||(IPCount>0)  d
	.s tmpMain=$g(^DHCWMRMAIN(MainId))
	.q:tmpMain=""
	.s tmpActive=$p(tmpMain,"^",6)
	.q:tmpActive'="Y"
	.q:'$d(^DHCWMRVOL(0,"Main",+MainId))
    .s VolId=0,Count=0      ;取第几次住院最大数
    .f  s VolId=$o(^DHCWMRVOL(0,"Main",MainId,VolId)) q:VolId=""  d
    ..s Active=$p($g(^DHCWMRVOL(+VolId)),"^",7)
    ..q:Active'="Y"
    ..s Count=+$p($g(^DHCWMRVOL(+VolId)),"^",9)
    ..s:IPCount<Count IPCount=Count
    
    s ret=IPCount
	q ret
}

/*****************************
/取就诊对应第几次住院
/入参：
/ Paadm   就诊号
/出参：
/	ret     就诊对应第几次住院
/*****************************/
ClassMethod getPaadmIP(Paadm)
{
	n (Paadm)
	
	//病案3.0版本升级，兼容原有接口
	set MRSVersion=##Class(DHCWMR.IO.OutService).GetMRSVersion()
	if MRSVersion=3 {
		set return=##class(DHCWMR.IO.ToHistorySrv).getPaadmIP(Paadm)
		quit return
	}
	
	s ret=0
	
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
	q:'$d(^DHCWMRVOL(0,"VolAdm",+Paadm)) ret
	s VolId=0,IPNum=0
	f  s VolId=$o(^DHCWMRVOL(0,"VolAdm",+Paadm,VolId)) q:(VolId="")||(IPNum>0)  d
	.s tmpVol=$g(^DHCWMRVOL(VolId))
	.q:$p(tmpVol,"^",7)'="Y"
	.s IPNum=+$p(tmpVol,"^",9)
	
	s ret=IPNum
	q ret
}

}
