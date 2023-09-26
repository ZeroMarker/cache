Import SQLUser

/// Descritpt:	取药学项相关信息(转自medsrc下的同名Mac)
/// Creater：	Zhouyg
/// CreateDate:	20130301 
Class web.DHCSTCOMMPHC Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:	根据库存项ID取DrgForm的ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-库存项RowID
/// Output:		Return
/// Return：	PHC_DrgForm的ID
ClassMethod GetPhcdf(InciDr) As %String
{
 N (InciDr)
 S ArcimDr=##Class(web.DHCSTCOMMARC).GetArcim(InciDr)
 Q:ArcimDr="" ""
 S Phcdf=..GetPhcdfByArcim(ArcimDr)
 Q Phcdf
}

/// Descript:	根据医嘱项ID取DrgForm的ID
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		ArcimDr-Arc_ItmMast的RowID
/// Output:		Return
/// Return：	PHC_DrgForm的ID
ClassMethod GetPhcdfByArcim(ArcimDr) As %String
{
 N (ArcimDr)
 Q:ArcimDr="" ""
 S Arcsub=$P(ArcimDr,"||",1)
 S Arcver=$P(ArcimDr,"||",2)
 Q:Arcsub="" ""
 Q:Arcver="" ""
 Q:'$D(^ARCIM(Arcsub,Arcver)) ""
 S Phcdf=$P(^ARCIM(Arcsub,Arcver,1),"^",12)
 Q Phcdf
}

/// Descript:	根据PHC_DrgForm的ID取剂型代码和描述
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		PhcdfDr-PHC_DrgForm的ID
/// Output:		Return
/// Return：	剂型代码^描述
ClassMethod GetFormByPhcdf(PhcdfDr) As %String
{
 N (PhcdfDr)
 Q:PhcdfDr="" ""
 S Phcd=$P(PhcdfDr,"||",1)
 S DfSub=$P(PhcdfDr,"||",2)
 Q:Phcd="" ""
 Q:DfSub="" ""
 Q:'$D(^PHCD(Phcd,"DF",DfSub)) ""
 S PhcfDr=$P(^PHCD(Phcd,"DF",DfSub,1),"^",1)
 Q:PhcfDr="" ""
 Q:'$D(^PHCF(PhcfDr)) ""
 S PhcfCode=$P(^PHCF(PhcfDr),"^",1)
 S PhcfDesc=$P(^PHCF(PhcfDr),"^",2)
 Q PhcfCode_"^"_PhcfDesc
}

/// Descript:	根据库存项ID取剂型代码和描述
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-库存项ID
/// Output:		Return
/// Return：	剂型代码^描述
ClassMethod GetForm(InciDr) As %String
{
 N (InciDr)
 Q:InciDr="" ""
 S Phcdf=..GetPhcdf(InciDr)
 Q:Phcdf="" ""
 S FormStr=..GetFormByPhcdf(Phcdf)
 Q FormStr
}

/// Descript:	根据PHC_DrgMast的ID取商品名
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		PhcdDr-PHC_DrgMast的ID
/// Output:		Return
/// Return：	商品名
ClassMethod GetGoodNameByPhcd(PhcdDr) As %String
{
 N (PhcdDr)
 Q:PhcdDr="" ""
 Q:'$D(^PHCD(PhcdDr)) ""
 S GoodName=$P(^PHCD(PhcdDr,2),"^",7)
 Q GoodName
}

/// Descript:	根据库存项的ID取商品名
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-INC_Itm的ID
/// Output:		Return
/// Return：	商品名
ClassMethod GetGoodName(InciDr) As %String
{
 N (InciDr)
 Q:InciDr="" ""
 S Phcdf=..GetPhcdf(InciDr)
 Q:Phcdf="" ""
 S Phcd=$P(Phcdf,"||",1)
 Q:Phcd="" ""
 S GoodName=..GetGoodNameByPhcd(Phcd)
 Q GoodName
}

/// Descript:	根据PHC_DrgMast的ID取通用名
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		PhcdDr-PHC_DrgMast的ID
/// Output:		Return
/// Return：	通用名
ClassMethod GetGeneByPhcd(PhcdDr) As %String
{
 N (PhcdDr)
 Q:PhcdDr="" ""
 Q:'$D(^PHCD(PhcdDr)) ""
 S GeneDr=$P(^PHCD(PhcdDr,4),"^",1)
 Q:GeneDr="" ""
 Q:'$D(^PHCGE("GE",GeneDr)) ""
 S GeneCode=$P(^PHCGE("GE",GeneDr),"^",1)
 S GeneName=$P(^PHCGE("GE",GeneDr),"^",2)
 Q GeneCode_"^"_GeneName
}

/// Descript:	根据库存项的ID取通用名
/// Creater:	Zhouyg
/// CreateDate:	20100302
/// Input:		InciDr-INC_Itm的ID
/// Output:		Return
/// Return：	通用名代码^通用名描述
ClassMethod GetGene(InciDr) As %String
{
 N (InciDr)
 Q:InciDr="" ""
 S Phcdf=..GetPhcdf(InciDr)
 Q:Phcdf="" ""
 S Phcd=$P(Phcdf,"||",1)
 Q:Phcd="" ""
 S GeneStr=..GetGeneByPhcd(Phcd)
 Q GeneStr
}

/// Descript:	根据PHC_DrgMast的ID取厂商
/// Creater:	Zhouyg
/// CreateDate:	20100309
/// Input:		PhcdDr-PHC_DrgMast的ID
/// Output:		Return
/// Return：	厂商ID^厂商代码^厂商名称
ClassMethod GetManfByPhcd(PhcdDr) As %String
{
 N (PhcdDr)
 Q:PhcdDr="" ""
 Q:'$D(^PHCD(PhcdDr)) ""
 S ManfDr=$P(^PHCD(PhcdDr,2),"^",4)
 Q:ManfDr="" ""
 Q:'$D(^PHMNF(ManfDr)) ""
 S ManfCode=$P(^PHMNF(ManfDr),"^",1)
 S ManfName=$P(^PHMNF(ManfDr),"^",2)
 Q ManfDr_"^"_ManfCode_"^"_ManfName
}

/// Descript:	根据库存项的ID取厂商
/// Creater:	Zhouyg
/// CreateDate:	20100309
/// Input:		InciDr-INC_Itm的ID
/// Output:		Return
/// Return：	厂商ID^厂商代码^厂商名称
ClassMethod GetManf(InciDr) As %String
{
 N (InciDr)
 Q:InciDr="" ""
 S Phcdf=..GetPhcdf(InciDr)
 Q:Phcdf="" ""
 S Phcd=$P(Phcdf,"||",1)
 Q:Phcd="" ""
 S ManfStr=..GetManfByPhcd(Phcd)
 Q ManfStr
}

/// Descript:	根据厂商ID取厂商名称
/// Creater:	Zhouyg
/// CreateDate:	20110630
/// Input:		ManfID-厂商ID
/// Return:		厂商名称
ClassMethod GetManfNameByID(ManfID) As %String
{
 n (ManfID)
 q:ManfID="" ""
 s ManfName=$P($g(^PHMNF(ManfID)),"^",2)
 q ManfName
}

/// Descript:	根据PHC_DrgForm的ID取是否抗菌药
/// Creater:	Zhouyg
/// CreateDate:	20120829
/// Input:		PhcdfDr-PHC_DrgForm的ID
/// Output:		Return
/// Return：	Y或N
ClassMethod GetAntiFlagByPhcdf(PhcdfDr) As %String
{
 N (PhcdfDr)
 Q:PhcdfDr="" ""
 S Phcd=$P(PhcdfDr,"||",1)
 S DfSub=$P(PhcdfDr,"||",2)
 Q:Phcd="" ""
 Q:DfSub="" ""
 Q:'$D(^PHCD(Phcd,"DF",DfSub)) ""
 S AntiFlag=$P($g(^PHCD(Phcd,"DF",DfSub,"DHC")),"^",8)
 Q AntiFlag
}

/// Descript:	根据PHC_DrgForm的ID取是药学相关信息
/// Creater:	Zhouyg
/// CreateDate:	20130301
/// Input:		PhcdfDr-PHC_DrgForm的ID
/// Return(yunhaibao20130310)
/// RetStr= ;1药学项代码^2药学项描述^3药学大类描述^4药学子类描述^5药学最小分类描述
///  		;6管制分类^7MIMS number(??)^8生产厂商^9作废标记^10商品名
///  		;11处方通用名^12英文国际非专利药名名^13国际专利药名^14更新用户代码^15更新用户名称
/// 		;16更新日期^17更新时间^18剂型描述^19频率代码^20频率描述
/// 		;21频率系数^22用法^23疗程^24基本单位^25基本数量
/// 		;26住院一天量(1或0)^27制剂通用名^28原料通用名^29门诊一天用量标记^30门诊皮试用原液
/// 		;31住院皮试用液标记^32年龄限制^33DDD值^34医保剂量上传为0^35草药默认备注
/// 		;36抗菌药标记(Y或N)^37高危药标记(Y或N)^38(WHONET)
/// 	Others:		w ##class(web.DHCSTCOMMPHC).GetPhcInfo("2152||1")
ClassMethod GetPhcInfo(PhcdfDr) As %String
{
 N (PhcdfDr)
 Q:PhcdfDr="" ""
 S Phcd=$P(PhcdfDr,"||",1)
 S DfSub=$P(PhcdfDr,"||",2)
 Q:Phcd="" ""
 Q:DfSub="" ""
 Q:'$D(^PHCD(Phcd,"DF",DfSub)) ""
 s phcCode=$p(^PHCD(Phcd,1),"^",1)
 s phcDesc=$p(^PHCD(Phcd,1),"^",2)
 s phcscID=$p(^PHCD(Phcd,1),"^",3)
 s phcpoID=$p(^PHCD(Phcd,1),"^",4)
 s MinSCID=$p(^PHCD(Phcd,1),"^",6)
 s phLogo=$p(^PHCD(Phcd,2),"^",3)
 s phmnfID=$p(^PHCD(Phcd,2),"^",4)
 s NoUseFlag=$p(^PHCD(Phcd,2),"^",6)
 s labelName1=$p(^PHCD(Phcd,2),"^",7)	//商品名
 s labelName2=$p(^PHCD(Phcd,2),"^",8)
 s phupDate=$p(^PHCD(Phcd,3),"^",1)
 s phupTime=$p(^PHCD(Phcd,3),"^",2)
 s phupUserID=$p(^PHCD(Phcd,3),"^",3)
 s phGeneID=$p(^PHCD(Phcd,4),"^",1)
 s OffiCode=$p(^PHCD(Phcd,4),"^",2)	//
 s (CatDesc,subCatDesc,poisName,MinSCDesc,mnfDesc,upUserCode,upUserName,GeneName)=""
 i phcscID'="" d
 .s catID=$p(phcscID,"||",1)
 .s scatSub=$p(phcscID,"||",2)
 .s CatDesc=$p($g(^PHCC(catID)),"^",2)
 .s cscDesc=$p($g(^PHCC(catID,"SC",scatSub)),"^",2)
 i phcpoID'="" d
 .s poisName=$p(^PHCPO(phcpoID),"^",2)
 i MinSCID'="" d
 .s catID=$p(MinSCID,"||",1)
 .s scatSub=$p(MinSCID,"||",2)
 .s mcatSub=$p(MinSCID,"||",3)
 .s MinSCDesc=$p($g(^PHCC(catID,"SC",scatSub,"MIN",mcatSub)),"^",2)
 i phmnfID'="" d
 .s mnfDesc=$p($g(^PHMNF(phmnfID)),"^",2)
 i phupUserID'="" d
 .s upUserCode=$p(^SSU("SSUSR",phupUserID),"^",1)
 .s upUserName=$p(^SSU("SSUSR",phupUserID),"^",2)
 i phGeneID'="" d
 .s GeneName=$p(^PHCGE("GE",phGeneID),"^",2)
 s engname1=$p(labelName2,"||",1)
 s engname2=$p(labelName2,"||",2)
 i phupDate'="" d
 .s phupDate=$zd(phupDate,3)
 i phupTime'="" d
 .s phupTime=$zt(phupTime,1)
 //
 s formID=$p(^PHCD(Phcd,"DF",DfSub,1),"^",1)
 s freqID=$p(^PHCD(Phcd,"DF",DfSub,1),"^",4)
 s InstID=$p(^PHCD(Phcd,"DF",DfSub,1),"^",5)
 s DuraID=$p(^PHCD(Phcd,"DF",DfSub,1),"^",8)
 s uomID=$p(^PHCD(Phcd,"DF",DfSub,2),"^",4)
 s baseQty=$p(^PHCD(Phcd,"DF",DfSub,2),"^",5)
 s DeductPartially=$p(^PHCD(Phcd,"DF",DfSub,2),"^",6)
 s pfupDate=$p(^PHCD(Phcd,"DF",DfSub,3),"^",1)
 s pfupTime=$p(^PHCD(Phcd,"DF",DfSub,3),"^",2)
 s pfupUserID=$p(^PHCD(Phcd,"DF",DfSub,3),"^",3)
 s pfOffiCode=$p(^PHCD(Phcd,"DF",DfSub,3),"^",4)
 s (formDesc,FreqCode,FreqDesc,FreqFact,InstDesc,DuraDesc,uomDesc)=""
 i formID'="" d
 .s formDesc=$p(^PHCF(formID),"^",2)
 i freqID'="" d
 .s FreqCode=$p(^PHCFR(freqID),"^",1)
 .s FreqDesc=$p(^PHCFR(freqID),"^",3)
 .s FreqFact=$p(^PHCFR(freqID),"^",2)
 i InstID'="" d
 .s InstDesc=$p(^PHCIN(InstID),"^",2)
 i DuraID'="" d
 .s DuraDesc=$p(^PHCDU(DuraID),"^",2)
 i uomID'="" d
 .s uomDesc=$P($g(^CT("UOM",uomID)),"^",2)
 s Fregen1=$p(pfOffiCode,"||",1)	//制剂通用名
 s Fregen2=$p(pfOffiCode,"||",2)	//原料通用名
 //
 s CalcuDose=$p($g(^PHCD(Phcd,"DF",DfSub,"DHC")),"^",1)
 s OPSkinTestYY=$p($g(^PHCD(Phcd,"DF",DfSub,"DHC")),"^",2)
 s IPSkinTestYY=$p($g(^PHCD(Phcd,"DF",DfSub,"DHC")),"^",3)
 s AgeLimit=$p($g(^PHCD(Phcd,"DF",DfSub,"DHC")),"^",4)
 s DDD=$p($g(^PHCD(Phcd,"DF",DfSub,"DHC")),"^",5)
 s InsuDoseZero=$p($g(^PHCD(Phcd,"DF",DfSub,"DHC")),"^",6)
 s CHPhSpecInstr=$p($g(^PHCD(Phcd,"DF",DfSub,"DHC")),"^",7)
 s AntibioticFlag=$p($g(^PHCD(Phcd,"DF",DfSub,"DHC")),"^",8)
 s CriticalFlag=$p($g(^PHCD(Phcd,"DF",DfSub,"DHC")),"^",9)
 s WHONET=$p($g(^PHCD(Phcd,"DF",DfSub,"DHC")),"^",10)
 s PhcStr1=phcCode_"^"_phcDesc_"^"_CatDesc_"^"_subCatDesc_"^"_MinSCDesc
 //1药学项代码^2药学项描述^3药学大类描述^4药学子类描述^5药学最小分类描述
 s PhcStr2=poisName_"^"_phLogo_"^"_mnfDesc_"^"_NoUseFlag_"^"_labelName1
 //6管制分类^7商标^8生产厂商描述^9药学作废标记^10商品名
 s PhcStr3=GeneName_"^"_engname1_"^"_engname2_"^"_upUserCode_"^"_upUserName
 //11处方通用名^12英文国际非专利药名名^13国际专利药名^14更新用户代码^15更新用户名称
 s PhcStr4=phupDate_"^"_phupTime_"^"_formDesc_"^"_FreqCode_"^"_FreqDesc
 //16更新日期^17更新时间^18剂型描述^19频率代码^20频率描述
 s PhcStr5=FreqFact_"^"_InstDesc_"^"_DuraDesc_"^"_uomDesc_"^"_baseQty
 //21频率系数^22用法^23疗程^24基本单位^25基本数量
 s PhcStr6=DeductPartially_"^"_Fregen1_"^"_Fregen2_"^"_CalcuDose_"^"_OPSkinTestYY
 //26住院一天量(1或0)^27制剂通用名^28原料通用名^29门诊一天用量标记^30门诊皮试用原液
 s PhcStr7=IPSkinTestYY_"^"_AgeLimit_"^"_DDD_"^"_InsuDoseZero_"^"_CHPhSpecInstr
 //31住院皮试用液标记^32年龄限制^33DDD值^34医保剂量上传为0^35草药默认备注
 s PhcStr8=AntibioticFlag_"^"_CriticalFlag_"^"_WHONET
 //36抗菌药标记(Y或N)^37高危药标记(Y或N)^38(WHONET)
 s PhcStr=PhcStr1_"^"_PhcStr2_"^"_PhcStr3_"^"_PhcStr4_"^"_PhcStr5_"^"_PhcStr6_"^"_PhcStr7_"^"_PhcStr8
 Q PhcStr
}

}
