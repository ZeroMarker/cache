/// 病案编目数据导出接口
/// by wuqk 2008-06
Class web.DHCWMRCodingToInterface Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 17;

/**********************************************
/导出病案编目数据：getFrontPageICD
/入参：
/  1-Paadm               就诊号
/  2-GetType             类型
/        D/1:            主要诊断
/        D/2:            次要诊断
/        D/3:            医院感染诊断
/        D/4:            病理诊断
/        D/5:            损伤、中毒的外部因素
/        O/1:            手术
/        O/2:            操作
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
/
/2-手术操作类型维护
/手术                     1
/操作                     2
/w ##Class(web.DHCWMRCodingToInterface).getFrontPageICD(Paadm,GetType,Index)
/诊断返回值：    ICD10 $c(2) 诊断描述 $c(2) 出院情况
/手术操作返回值：ICD10_$c(2)_手术名称)_$c(2)_手术操作日期_$c(2)_切口编号_$c(2)_切口_$c(2)_愈合编目_$c(2)_愈合_$c(2)_手术医生编号_$c(2)_手术医师_$c(2)_麻醉方式编号_$c(2)_麻醉方式_$c(2)_是否附加手术_$c(2)_1助编号_$c(2)_1助姓名_$c(2)_2助编号_$c(2)_2助姓名_$c(2)_麻醉医生编号_$c(2)_麻醉医生
***********************************************/
ClassMethod getFrontPageICD(Paadm, GetType, Index)
{
	n (Paadm,GetType,Index)
	s ret=""
	q:Paadm="" ret
	q:GetType="" ret
	s ICDType=$p(GetType,"/",1)
	s OperType=$p(GetType,"/",2)
	s Index=+$g(Index)
	s:Index<1 Index=1
	q:(ICDType'="D")&&(ICDType'="O") ret
	q:(ICDType="D")&&((OperType'="1")&&(OperType'="2")&&(OperType'="3")&&(OperType'="4")&&(OperType'="5")&&(OperType'="6")&&(OperType'="7")) ret
	q:(ICDType="O")&&((OperType'="1")&&(OperType'="2")) ret
	
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
	
	s FPICDRowid=0,index=1,sOut=""
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
	q sOut
	
BuildDisString(FPICDRowid,OperType)
    ;ICD10 $c(2) 诊断描述 $c(2) 出院情况
    n (FPICDRowid,OperType)
    s sOut=""
    s sICD=$g(^DHCWMRFPICD(FPICDRowid))
    s ICDDr=$p(sICD,"^",2)
    s ResultDr=$p(sICD,"^",3)
    s sICDDictionary=##class(web.DHCWMRMedBaseICD).GetMyICDByRowId(ICDDr)
    q:sICDDictionary="" sOut
    s HospCode=##class(web.DHCWMRMedBase01).GetDefaultHospCode()
    i ((OperType=4)||(OperType=5))&&(HospCode="ChangChun_JDSY") d   //吉大三院 病理诊断和损伤中毒诊断取附加码,附加码为空取主码
    .s:$p(sICDDictionary,"^",3)'="" $p(sICDDictionary,"^",2)=$p(sICDDictionary,"^",3)
    s sResultDic=##class(web.DHCWMRDictionaryCtl).GetDataById(ResultDr)
    s ICD10=$p(sICDDictionary,"^",2)
    s ICDDesc=$p(sICDDictionary,"^",4)
    s ResultCode=$p(sResultDic,"^",3)
    s ResultDesc=""
    s DicID=$o(^DHCWMRDIC(0,"DicNameCode","DiseaseResult",ResultCode,""))
    i DicID'=""  d
    .s ResultDesc=$p($g(^DHCWMRDIC(DicID)),"^",3)
    s sOut=ICD10_$c(2)_ICDDesc_$c(2)_ResultCode_$c(2)_ResultDesc
    q sOut
BuildOperString(FPICDRowid,OperType)
    ;ICD10$c(2)手术名称$c(2)手术操作日期$c(2)切口编号$c(2)切口$c(2)术者$c(2)一助$c(2)二助$c(2)麻醉方式$c(2)愈合情况$c(2)麻醉师
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
    s sICDDictionary=##class(web.DHCWMRMedBaseICD).GetMyOperByRowId(ICDDr)
    q:sICDDictionary="" sOut
    
    s Operator=##class(web.DHCWMRMedBaseCtl).GetUsrStr(OperatorDr)
    s Ass1=##class(web.DHCWMRMedBaseCtl).GetUsrStr(Ass1Dr)
    s Ass2=##class(web.DHCWMRMedBaseCtl).GetUsrStr(Ass2Dr)
    s NarcDoc=##class(web.DHCWMRMedBaseCtl).GetUsrStr(NarcDocDr)
    
    s NarcType=##class(web.DHCWMRDictionaryCtl).GetDataById(NarcTypeDr)
    s CloseUp=##class(web.DHCWMRDictionaryCtl).GetDataById(CloseUpDr)
    
    s ICD10=$p(sICDDictionary,"^",2)
    s ICDDesc=$p(sICDDictionary,"^",4)
    s OperatorCode=$p(Operator,"/",2)    ;2取代码 3取Name
    s OperatorName=$p(Operator,"/",3)    ;2取代码 3取Name
    s Ass1Name=$p(Ass1,"/",3)
    s Ass1Code=$p(Ass1,"/",2)
    //s Ass2Code=$p(Ass1,"/",3)
    s Ass2Name=$p(Ass2,"/",3)            //modify by wuqk 2009-09-23 地坛发现病案接口导出二助被一助覆盖
    s Ass2Code=$p(Ass2,"/",2)
    s NarcTypeCode=$p(NarcType,"^",3)    ;麻醉方式 3代码 4描述
    s NarcTypeDesc=$p(NarcType,"^",4)    ;麻醉方式 3代码 4描述
    s CloseUpCode=$p(CloseUp,"^",3)      ;切口愈合 3代码 4描述
    s CloseUpDesc=$p(CloseUp,"^",4)      ;切口愈合 3代码 4描述
    s NarcDocCode=$p(NarcDoc,"/",2)
    s NarcDocDesc=$p(NarcDoc,"/",3)
    s:OperType="2" CloseUpCode=""
    s sOut=ICD10_$c(2)_ICDDesc_$c(2)_OperDate_$c(2)_$c(2)_$c(2)_CloseUpCode_$c(2)_CloseUpDesc_$c(2)_OperatorCode_$c(2)_OperatorName_$c(2)_NarcTypeCode_$c(2)_NarcTypeDesc_$c(2)_$c(2)_Ass1Code_$c(2)_Ass1Name_$c(2)_Ass2Code_$c(2)_Ass2Name_$c(2)_NarcDocCode_$c(2)_NarcDocDesc
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

}
