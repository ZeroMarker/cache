/// 名称: DHCMed.Base.OrdItem
/// 描述: 医嘱表(OE_OrdItem)的业务封装，定义常用属性和方法
/// 编写者：刘学峰
/// 编写日期: 2010-04-12
Class DHCMed.Base.OrdItem Extends (%Persistent, DHCMed.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

//OEORI_OEORD_Parref		OE_Order

//OEORI_ItmMast_DR	医嘱项指针	ARC_ItmMast

//OEORI_SttDat	开始日期	

//OEORI_SttTim	开始时间	

//OEORI_Doctor_DR	开医嘱医生	CT_CareProv

//OEORI_Priority_DR	医嘱类型	OEC_Priority

//OEORI_ItemStat_DR	医嘱状态	OEC_OrderStatus

//		U：未审核，删除医嘱用

//		I:未激活,实习医生开医嘱用

//OEORI_DoseQty	剂量	

//OEORI_Unit_DR	剂量单位	CT_UOM

//OEORI_PHFreq_DR	频率	PHC_Freq

//OEORI_Durat_DR	疗程	PHC_Duration

//OEORI_Instr_DR	用法	PHC_Instruc

//OEORI_SeqNo	关联号	

//OEORI_RecDep_DR	接受科室	CT_LOC

//OEORI_Date	开医嘱日期	

//OEORI_Time	开医嘱时间	

//OEORI_LabEpisodeNo	检验条码	

//OEORI_Price	自定义价格	

//OEORI_XCTCP_DR	停止医生	CT_CareProv

//OEORI_XDate	停止日期	

//OEORI_XTime	停止时间	

//OEORI_OEORI_DR	关联医嘱	OE_Orditem

//OEORI_Billed	结算状态	

//OEORI_PhQtyOrd	基本单位数量	

/// OE_OrdItem表RowId
Property OEORIRowId As %String;

/// OEORI_ItmMast_DR	医嘱项指针	ARC_ItmMast
Property OEORIItmMastDR As %String;

/// OEORI_SttDat	开始日期
Property OEORISttDat As %String;

/// OEORI_SttTim	开始时间
Property OEORISttTim As %String;

/// OEORI_Doctor_DR	开医嘱医生	CT_CareProv
Property OEORIDoctorDR As %String;

/// OEORI_Priority_DR	医嘱类型	OEC_Priority
Property OEORIPriorityDR As %String;

/// OEORI_ItemStat_DR	医嘱状态	OEC_ItemStatus U：未审核，删除医嘱用;I:未激活,实习医生开医嘱用
Property OEORIItemStatDR As %String;

/// OEORI_DoseQty	剂量
Property OEORIDoseQty As %String;

/// OEORI_Unit_DR	剂量单位	CT_Unit
Property OEORIUnitDR As %String;

/// OEORI_PHFreq_DR	频率	PHC_Freq
Property OEORIPHFreqDR As %String;

/// OEORI_Durat_DR	疗程	PHC_Duration
Property OEORIDuratDR As %String;

/// OEORI_Instr_DR	用法	PHC_Instruction
Property OEORIInstrDR As %String;

/// OEORI_SeqNo	关联号
Property OEORISeqNo As %String;

/// OEORI_RecDep_DR	接受科室	CT_LOC
Property OEORIRecDepDR As %String;

/// OEORI_Date	开医嘱日期	
Property OEORIDate As %String;

/// OEORI_Time	开医嘱时间
Property OEORITime As %String;

/// OEORI_LabEpisodeNo	检验条码
Property OEORILabEpisodeNo As %String;

/// OEORI_Price	自定义价格
Property OEORIPrice As %String;

/// OEORI_XCTCP_DR	停止医生	CT_CareProv
Property OEORIXCTCPDR As %String;

/// OEORI_XDate	停止日期
Property OEORIXDate As %String;

/// OEORI_XTime	停止时间
Property OEORIXTime As %String;

/// OEORI_OEORI_DR	关联医嘱	OE_Orditem
Property OEORIOEORIDR As %String;

/// OEORI_Billed	结算状态
Property OEORIBilled As %String;

/// OEORI_PhQtyOrd	基本单位数量
Property OEORIPhQtyOrd As %String;

//以下为关联表字段

//1、OEORI_ItmMast_DR指向表ARC_ItmMast

/// ARCIM_Code
Property ARCIMCode As %String;

/// ARCIM_Desc
Property ARCIMDesc As %String;

//2、OEORI_Doctor_DR	开医嘱医生 指向	CT_CareProv

Property DocCode As %String;

Property DocDesc As %String;

//3、OEORI_Priority_DR	医嘱类型 指向 OEC_Priority

/// OECPR_Code
Property OECPRCode As %String;

/// OECPR_Desc
Property OECPRDesc As %String;

//4、OEORI_ItemStat_DR	医嘱状态 指向 OEC_OrderStatus

/// OSTAT_Code
Property OSTATCode As %String;

/// OSTAT_Desc
Property OSTATDesc As %String;

//5、OEORI_Unit_DR	剂量单位 指向 CT_UOM

/// CTUOM_Code
Property CTUOMCode As %String;

/// CTUOM_Desc
Property CTUOMDesc As %String;

//6、OEORI_PHFreq_DR	频率	PHC_Freq

/// PHCFR_Code
Property PHCFRCode As %String;

/// PHCFR_Desc1
Property PHCFRDesc1 As %String;

/// PHCFR_Desc2
Property PHCFRDesc2 As %String;

//7、OEORI_Durat_DR	疗程	PHC_Duration

/// PHCDU_Code
Property PHCDUCode As %String;

/// PHCDU_Factor
Property PHCDUFactor As %String;

/// PHCDU_Desc1
Property PHCDUDesc1 As %String;

//8、OEORI_Instr_DR	用法 指向 PHC_Instruc

/// PHCIN_Code
Property PHCINCode As %String;

/// PHCIN_Desc1
Property PHCINDesc1 As %String;

/// PHCIN_Desc2
Property PHCINDesc2 As %String;

//9、OEORI_RecDep_DR	接受科室 指向 CT_LOC

//##class(DHCMed.Base.Ctloc).GetObjById

/// 科室代码 CTLOC_Code
Property CTLOCCode As %String;

/// 科室描述 CTLOC_Desc
Property CTLOCDesc As %String;

//10、OEORI_XCTCP_DR	停止医生	CT_CareProv

Property XDocCode As %String;

Property XDocDesc As %String;

/// Creator：     刘学峰
/// CreatDate：   2010-04-06
/// Description:  将对象格式化为字符串
/// Table：       OE_OrdItem及其关联表
/// Input：       sep:指定的分隔符
/// Return：      返回各属性值，按照sep分隔
Method ToString(sep As %String) As %String
{
	if $g(sep)=""{
		set sep=..#SEPARATE
		} 
	s ret=..OEORIRowId						//1
	s ret=ret_sep_..OEORIItmMastDR			//2
	s ret=ret_sep_..OEORISttDat				//3
	s ret=ret_sep_..OEORISttTim				//4
	s ret=ret_sep_..OEORIDoctorDR			//5
	s ret=ret_sep_..OEORIPriorityDR			//6
	s ret=ret_sep_..OEORIItemStatDR			//7
	s ret=ret_sep_..OEORIDoseQty			//8
	s ret=ret_sep_..OEORIUnitDR				//9
	s ret=ret_sep_..OEORIPHFreqDR			//10
	s ret=ret_sep_..OEORIDuratDR			//11
	s ret=ret_sep_..OEORIInstrDR			//12
	s ret=ret_sep_..OEORISeqNo				//13
	s ret=ret_sep_..OEORIRecDepDR			//14
	s ret=ret_sep_..OEORIDate				//15
	s ret=ret_sep_..OEORITime				//16
	s ret=ret_sep_..OEORILabEpisodeNo		//17
	s ret=ret_sep_..OEORIPrice				//18
	s ret=ret_sep_..OEORIXCTCPDR			//19
	s ret=ret_sep_..OEORIXDate				//20
	s ret=ret_sep_..OEORIXTime				//21
	s ret=ret_sep_..OEORIOEORIDR			//22
	s ret=ret_sep_..OEORIBilled				//23
	s ret=ret_sep_..OEORIPhQtyOrd			//24
	//以下为从关联表中取值字段
	//1
	s ret=ret_sep_..ARCIMCode				//25
	s ret=ret_sep_..ARCIMDesc				//26
	//2
	s ret=ret_sep_..DocCode					//27
	s ret=ret_sep_..DocDesc					//28
	//3
	s ret=ret_sep_..OECPRCode				//29
	s ret=ret_sep_..OECPRDesc				//30
	//4
	s ret=ret_sep_..OSTATCode				//31
	s ret=ret_sep_..OSTATDesc				//32
	//5
	s ret=ret_sep_..CTUOMCode				//33
	s ret=ret_sep_..CTUOMDesc				//34
	//6
	s ret=ret_sep_..PHCFRCode				//35
	s ret=ret_sep_..PHCFRDesc1				//36
	s ret=ret_sep_..PHCFRDesc2				//37
	//7
	s ret=ret_sep_..PHCDUCode				//38
	s ret=ret_sep_..PHCDUFactor				//39
	s ret=ret_sep_..PHCDUDesc1				//40
	//8
	s ret=ret_sep_..PHCINCode				//41
	s ret=ret_sep_..PHCINDesc1				//42
	s ret=ret_sep_..PHCINDesc2				//43
	//9
	s ret=ret_sep_..CTLOCCode				//44
	s ret=ret_sep_..CTLOCDesc				//45
	//10
	s ret=ret_sep_..XDocCode				//46
	s ret=ret_sep_..XDocDesc				//47
	quit ret
}

/// Creator：     刘学峰
/// CreatDate：   2010-04-06
/// Description:  根据OE_Order.OEORD_RowId取医嘱信息
/// Table：       OE_OrdItem等
/// Input：       OEORIRowId
/// Return：      返回obj
/// Others：      
/// w ##class(DHCMed.Base.OrdItem).GetObjById(1) 
ClassMethod GetObjById(OEORIRowId As %String) As DHCMed.Base.OrdItem
{
	n (OEORIRowId)
	s return=""
	q:+OEORIRowId=0 return
	q:'$d(^OEORD(+OEORIRowId)) return
	s OEORIChildsub=+$p(OEORIRowId,"||",2)
	q:'$d(^OEORD(+OEORIRowId,"I",OEORIChildsub)) return
	
	s obj=##Class(DHCMed.Base.OrdItem).%New()
	s obj.OEORIRowId=OEORIRowId
	s obj.OEORIItmMastDR = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",2) // 医嘱项指针 ARC_ItmMast
	s obj.OEORISttDat = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",9) // 开始日期 
	s obj.OEORISttTim = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",10) // 开始时间 
	s obj.OEORIDoctorDR = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",11) // 开医嘱医生 CT_CareProv
	s obj.OEORIPriorityDR = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",8) // 医嘱类型 OEC_Priority
	s obj.OEORIItemStatDR = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",13) // 医嘱状态 OEC_ItemStatus  U：未审核，删除医嘱用;I:未激活,实习医生开医嘱用
	s obj.OEORIDoseQty = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,2)),"^",1) // 剂量 
	s obj.OEORIUnitDR = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,2)),"^",3) // 剂量单位 CT_Unit
	s obj.OEORIPHFreqDR = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,2)),"^",4) // 频率 PHC_Freq
	s obj.OEORIDuratDR = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,2)),"^",6) // 疗程 PHC_Duration
	s obj.OEORIInstrDR = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,2)),"^",7) // 用法 PHC_Instruction
	s obj.OEORISeqNo = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,3)),"^",4) // 关联号 
	s obj.OEORIRecDepDR = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,3)),"^",6) // 接受科室 CT_LOC
	s obj.OEORIDate = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,3)),"^",7) // 开医嘱日期 
	s obj.OEORITime = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,3)),"^",15) // 开医嘱时间 
	// 20) modi by cjb 35 
	s obj.OEORILabEpisodeNo = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,3)),"^",35) // 检验条码 
	s obj.OEORIPrice = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,3)),"^",25) // 自定义价格 
	s obj.OEORIXCTCPDR = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,3)),"^",29) // 停止医生 CT_CareProv
	s obj.OEORIXDate = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,3)),"^",34) // 停止日期 
	s obj.OEORIXTime = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,2)),"^",15) // 停止时间 
	s obj.OEORIOEORIDR = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,11)),"^",39) // 关联医嘱 OE_Orditem
	s obj.OEORIBilled = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,3)),"^",5) // 结算状态 
	s obj.OEORIPhQtyOrd = $p($g(^OEORD(+OEORIRowId,"I",OEORIChildsub,1)),"^",12) // 基本单位数量 

	//下面查询关联表数据
	//1、OEORIItmMastDR指向表ARC_ItmMast
	s objItmMast=##class(DHCMed.Base.Arcim).GetObjById(+obj.OEORIItmMastDR)
	if $IsObject(objItmMast){
		s obj.ARCIMCode=objItmMast.ARCIMCode
		s obj.ARCIMDesc=objItmMast.ARCIMDesc
	}
	//2、OEORIDoctorDR	开医嘱医生 指向	CT_CareProv
	s:+obj.OEORIDoctorDR'=0 obj.DocCode=$p($g(^CTPCP(+obj.OEORIDoctorDR,1)),"^",1)
	s:+obj.OEORIDoctorDR'=0 obj.DocDesc=$p($g(^CTPCP(+obj.OEORIDoctorDR,1)),"^",2)
	
	//3、OEORI_Priority_DR	医嘱类型 指向 OEC_Priority
	s:+obj.OEORIPriorityDR'=0 obj.OECPRCode=$p($g(^OECPR(+obj.OEORIPriorityDR)),"^",1)
	s:+obj.OEORIPriorityDR'=0 obj.OECPRDesc=$p($g(^OECPR(+obj.OEORIPriorityDR)),"^",2)
	
	//4、OEORI_ItemStat_DR	医嘱状态 指向 OEC_OrderStatus
	s:+obj.OEORIItemStatDR'=0 obj.OSTATCode=$p($g(^OEC("OSTAT",+obj.OEORIItemStatDR)),"^",1)
	s:+obj.OEORIItemStatDR'=0 obj.OSTATDesc=$p($g(^OEC("OSTAT",+obj.OEORIItemStatDR)),"^",2)

	//5、OEORI_Unit_DR	剂量单位 指向 CT_UOM
	s:+obj.OEORIUnitDR'=0 obj.CTUOMCode=$p($g(^CT("UOM",+obj.OEORIUnitDR)),"^",1)
	s:+obj.OEORIUnitDR'=0 obj.CTUOMDesc=$p($g(^CT("UOM",+obj.OEORIUnitDR)),"^",2)
	
	//6、OEORI_PHFreq_DR	频率	PHC_Freq
	s:+obj.OEORIPHFreqDR'=0 obj.PHCFRCode=$p($g(^PHCFR(+obj.OEORIPHFreqDR)),"^",1)
	s:+obj.OEORIPHFreqDR'=0 obj.PHCFRDesc1=$p($g(^PHCFR(+obj.OEORIPHFreqDR)),"^",3)
	s:+obj.OEORIPHFreqDR'=0 obj.PHCFRDesc2=$p($g(^PHCFR(+obj.OEORIPHFreqDR)),"^",4)
	
	//7、OEORI_Durat_DR	疗程	PHC_Duration
	s:+obj.OEORIDuratDR'=0 obj.PHCDUCode=$p($g(^PHCDU(+obj.OEORIDuratDR)),"^",1)
	s:+obj.OEORIDuratDR'=0 obj.PHCDUFactor=$p($g(^PHCDU(+obj.OEORIDuratDR)),"^",2)
	s:+obj.OEORIDuratDR'=0 obj.PHCDUDesc1=$p($g(^PHCDU(+obj.OEORIDuratDR)),"^",3)
	
	//8、OEORI_Instr_DR	用法 指向 PHC_Instruc
	s:+obj.OEORIInstrDR'=0 obj.PHCINCode=$p($g(^PHCIN(+obj.OEORIInstrDR)),"^",1)
	s:+obj.OEORIInstrDR'=0 obj.PHCINDesc1=$p($g(^PHCIN(+obj.OEORIInstrDR)),"^",2)
	s:+obj.OEORIInstrDR'=0 obj.PHCINDesc2=$p($g(^PHCIN(+obj.OEORIInstrDR)),"^",3)
	
	//9、OEORI_RecDep_DR	接受科室 指向 CT_LOC
	s objRecDep=##class(DHCMed.Base.Ctloc).GetObjById(+obj.OEORIRecDepDR)
	if $IsObject(objRecDep){
		s obj.CTLOCCode=objRecDep.Code
		s obj.CTLOCDesc=objRecDep.Descs
	}
	//10、OEORI_XCTCP_DR	停止医生 指向 CT_CareProv
	s:+obj.OEORIXCTCPDR'=0 obj.XDocCode=$p($g(^CTPCP(+obj.OEORIXCTCPDR,1)),"^",1)
	s:+obj.OEORIXCTCPDR'=0 obj.XDocDesc=$p($g(^CTPCP(+obj.OEORIXCTCPDR,1)),"^",2)
	
	s return=obj
	q return
}

/// Creator：     刘学峰
/// CreatDate：   2010-04-06
/// Description:  根据OEORI_RowId取医嘱项目信息
/// Table：       OE_OrdItem等
/// Input：       OEORI_RowId 格式"11||1"
///               separete: 指定的分隔符
/// Return：      返回obj.ToString()
/// w ##class(DHCMed.Base.OrdItem).GetStringById(1)
ClassMethod GetStringById(OEORIRowId As %String, separete As %String) As %String
{
	n (OEORIRowId,separete)
	s return=""
	q:+OEORIRowId=0 return
	q:'$d(^OEORD(+OEORIRowId)) return
	s OEORIChildsub=+$p(OEORIRowId,"||",2)
	q:OEORIChildsub=0 return
	q:'$d(^OEORD(+OEORIRowId,"I",OEORIChildsub)) return
	s obj=..GetObjById(OEORIRowId)
	s return=obj.ToString($g(separete))
	q return
}

}
