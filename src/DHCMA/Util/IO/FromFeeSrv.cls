/// 名称: DHCMA.Util.IO.FromFeeSrv
/// 描述: 计费提供接口服务
/// 编写者：zhufei
/// 编写日期: 2018-07-11
Class DHCMA.Util.IO.FromFeeSrv Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:		yankai
/// CreatDate:		2022-12-07
/// Description:	【以此为准】获取住院患者实时费用接口封装,根据Adm/账单号查询病案分类(大类/子类)
/// Input:			EpisodeID: 就诊号
/// 				Bill: 账单号
/// 	    		ItemType: Null(空):两个分类都要 N:新病案分类(38) O:旧病案分类(24) 
/// 				ExpStr: 扩展字符串
/// Return:			总金额_"^"_自付金额_$c(3)_新分类费用信息_$c(3)_旧分类费用信息
/// 					新分类费用信息=分类1_$c(2)_分类2_$c(2)_分类3…
/// 								分类=分类Code^分类名称^分类金额@子分类Code1^子分类名称1^子分类金额1!子分类Code2^子分类名称2^子分类金额2!子分类Code3^子分类名称3^子分类金额3…
/// 					旧分类费用信息=分类1_$c(2)_分类2_$c(2)_分类3…
/// 								分类=分类Code^分类名称^分类金额@子分类Code1^子分类名称1^子分类金额1!子分类Code2^子分类名称2^子分类金额2!子分类Code3^子分类名称3^子分类金额3…
/// w ##class(DHCMA.Util.IO.FromFeeSrv).IGetTarMRCateFee("3453","","","") 
ClassMethod IGetTarMRCateFee(aEpisodeID As %String, aBillNo As %String = "", aItemType As %String = "", aExpStr As %String = "") As %String
{
	New (aEpisodeID,aBillNo,aItemType,aExpStr)
	Set return = ""
	Quit:(+aEpisodeID="")&&(aBillNo="") return
	
	Set $ZT="IGetTarMRCateFeeError"
	Set return = ##class(web.DHCBillInterface).IGetTarMRCateFee(+aEpisodeID,aBillNo,aItemType,aExpStr)
	Quit return
	
IGetTarMRCateFeeError
	Quit ""
}

/// Modifier:			yankai 2022-12-15 床位费等开单科室为空医嘱造成程序报错已处理
/// Creator:			张法宾提供 add 2022.11.8 @安徽省立给医政组提供接口
/// Description:		按开单科室统计患者分类费用 
/// Inputs:				患者就诊号，科室ID,开始日期时间，结束日期时间。
/// Output:				该患者在这个科室的“药品费用^检验费用^检查费用^材料费用^其他费用”
/// w ##class(DHCMA.Util.IO.FromFeeSrv).getPatBillData("","","","")
ClassMethod getPatBillData(adm, locDr, sDate, eDate)
{
	s (ypAmt,jyAmt,jcAmt,clAmt,qtAmt)=""
	q:locDr="" ypAmt_"^"_jyAmt_"^"_jcAmt_"^"_clAmt_"^"_qtAmt
	k outData
	s pbRowid=""
	f  s pbRowid=$o(^DHCPB(0,"ADM",adm,pbRowid)) q:pbRowid=""  d
	.s pbo=0
	.f  s pbo=$o(^DHCPB(pbRowid,"O",pbo)) q:pbo=""  d
	..s Arcim=$p(^DHCPB(pbRowid,"O",pbo),"^",3)
	..s OEIMDR=$p(^DHCPB(pbRowid,"O",pbo),"^",4)
	..s pboAmt=$p(^DHCPB(pbRowid,"O",pbo),"^",8)
	..if $d(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),7)) do
	...s UserLoc=$p(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),7),"^",2)
	..else  do
	...s UserLoc=""
	..s OEOrdDate=$p($g(^OEORD(+OEIMDR,"I",$p(OEIMDR,"||",2),3)),"^",7)
	..q:(sDate'="")&&(OEOrdDate<sDate)
	..q:(eDate'="")&&(OEOrdDate>eDate)
	..q:(locDr'="")&&(UserLoc'=locDr)
	..s ARCCATRowid=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)
	..s orderType=$p(^ARC("IC",ARCCATRowid),"^",7)	//R,D,I,C,N,T,L,X,P,B,S,H,E,A,F,DTF,BM,PROS,M
	..s pbd=0
	..f  s pbd=$o(^DHCPB(pbRowid,"O",pbo,"D",pbd)) q:pbd=""  d
	...s pbdInfo=$g(^DHCPB(pbRowid,"O",pbo,"D",pbd))
	...q:(pbdInfo="")
	...s myTarRowID=$p(pbdInfo,"^",3)
	..if (orderType="R") do
	...//药品
	...s outData(locDr,"R")=$g(outData(locDr,"R"))+pboAmt
	..else  if (orderType="L") do
	...//检验
	...s outData(locDr,"L")=$g(outData(locDr,"L"))+pboAmt
	..else  if (orderType="M") do
	...//材料
	...s outData(locDr,"M")=$g(outData(locDr,"M"))+pboAmt
	..else  do
	...set isExam=##class(web.DHCBillHardCoded).IsExamSubCat(Arcim)
	...if (+isExam=1) do
	....//检查
	....s outData(locDr,"JC")=$g(outData(locDr,"JC"))+pboAmt
	...else  do
	....//其他
	....s outData(locDr,"Other")=$g(outData(locDr,"Other"))+pboAmt
	
	i locDr'="" {
		s ypAmt=$g(outData(locDr,"R"))
		s jyAmt=$g(outData(locDr,"L"))
		s jcAmt=$g(outData(locDr,"JC"))
		s clAmt=$g(outData(locDr,"M"))
		s qtAmt=$g(outData(locDr,"Other"))
	}
	
	q ypAmt_"^"_jyAmt_"^"_jcAmt_"^"_clAmt_"^"_qtAmt
}

/// 取病案首页费用分类接口
/// w ##class(DHCMA.Util.IO.FromFeeSrv).IGetTarCateFeeByAdm(8228531)
ClassMethod IGetTarCateFeeByAdm(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set IOGetFeeVer=##class(DHCMA.Util.BT.Config).GetValueByCode("HISIOGetFeeVer")
	If IOGetFeeVer=1 {
		Set return=..GetPatCostToMR(aEpisodeID)
	} Else {
		//默认用此接口
		Set return=..IGetTarCateFee("W",aEpisodeID,"","O","")
	}
	Quit return
}

/// w ##class(DHCMA.Util.IO.FromFeeSrv).GetPatCostToMR(8228531)
ClassMethod GetPatCostToMR(aEpisodeID As %String) As %String
{
	New (aEpisodeID)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set return=""
	Quit:aEpisodeID="" return
	
	//^DHCTarC("MCNew" 首页费用分类
	Set IOGetEmrVer=##class(DHCMA.Util.BT.Config).GetValueByCode("HISIOGetEmrVer")
	If IOGetEmrVer="V2" {
		Set CostStr=##class(EPRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSubNew(aEpisodeID)
	} Else {
		Set CostStr=##class(EMRservice.HISInterface.PatientInfoAssist).InPatCostTrakCareSubNew(aEpisodeID)
	}
	Quit:CostStr="" return
	
	For xind=1:1:$l(CostStr,"!") {
		Set FeeStr=$p(CostStr,"!",xind)
		Set Cost=$p(FeeStr,"^",3)
		Set Desc=$p(FeeStr,"^",2)
		Set Code=$p(FeeStr,"^",1)
		Set Code=$tr(Code," ","")
		Set Code=$tr(Code,$c(0),"")
		Set Code=$tr(Code,$c(1),"")
		Set Code=$tr(Code,$c(2),"")
		Set Code=$tr(Code,$c(9),"")
		Set Code="DHCCOST"_Code
		Set return=return_"<"_Code_">"_Cost_"</"_Code_">"
	}
	Quit return
}

/// aFPType:C中医首页，W西医首页
/// w ##class(DHCMA.Util.IO.FromFeeSrv).IGetTarCateFee("","","","O","")
ClassMethod IGetTarCateFee(aFPType As %String, aEpisodeID As %String, aBill As %String, aItemType As %String, aExpStr As %String) As %String
{
	New (aFPType,aEpisodeID,aBill,aItemType,aExpStr)
	Set aEpisodeID=$p(aEpisodeID,"!!",1)
	Set return=""
	Quit:aEpisodeID="" return
	
	Set CostStr=..IGetTarMRCateFee(aEpisodeID,aBill,aItemType,aExpStr)
		
	Set NewFeeStr=..TurnByCate(aFPType,CostStr,aItemType)
	Set:NewFeeStr'="" return=NewFeeStr
	
	Quit return
}

ClassMethod TurnByCate(aFPType As %String, aCostStr As %String, aItemType As %String) As %String
{
	New (aFPType,aCostStr,aItemType)
	Set return=""
	Quit:(aCostStr="")||(aFPType="")||(aItemType="") return
	
	Set tmpCostStr=$p(aCostStr,"@",2)
	For ind=1:1:$l(tmpCostStr,$C(2)) {
		Set tmpCate=$p(tmpCostStr,$C(2),ind)
		Continue:tmpCate=""
		Set SubCates=$p(tmpCate,"@",2)
		For jnd=1:1:$l(SubCates,"!") {
			Set tmpSubCate=$p(SubCates,"!",jnd)
			Continue:tmpSubCate=""
			Set SubCateCode=$p(tmpSubCate,"^",1)
			Set SubCateDesc=$p(tmpSubCate,"^",2)
			Set Value=$p(tmpSubCate,"^",3)
			Set MRQCode=..GetCodeByDesc(aFPType,aItemType,SubCateDesc)
			Continue:MRQCode=""
			Set return=return_"<"_MRQCode_">"_Value_"</"_MRQCode_">"
		}
	}
	Quit return
}

/// w ##Class(DHCMA.Util.IO.FromFeeSrv).GetCodeByDesc("W","N","诊疗费")
ClassMethod GetCodeByDesc(aFPType As %String, aItemType As %String, aCateDesc As %String) As %String
{
	New (aCateDesc,aFPType,aItemType)
	Set return=""
	Quit:(aFPType="")||(aCateDesc="")||(aItemType="") return
	
	//新西医费用
	Set NewFeeList=$lb("诊疗费","P61001001")
	Set NewFeeList=NewFeeList_$lb("挂号费","P61001002")
	Set NewFeeList=NewFeeList_$lb("床位费","P61001003")
	Set NewFeeList=NewFeeList_$lb("一般治疗费","P61002001")
	Set NewFeeList=NewFeeList_$lb("护理治疗费","P61002002")
	Set NewFeeList=NewFeeList_$lb("监护及辅助呼吸费","P61002003")
	Set NewFeeList=NewFeeList_$lb("输氧费","P61002004")
	Set NewFeeList=NewFeeList_$lb("护理费","P61003001")
	Set NewFeeList=NewFeeList_$lb("其它费用","P61004001")
	Set NewFeeList=NewFeeList_$lb("病理费","P61005001")
	Set NewFeeList=NewFeeList_$lb("化验费","P61006001")
	Set NewFeeList=NewFeeList_$lb("核素检查","P61007001")
	Set NewFeeList=NewFeeList_$lb("超声费","P61007002")
	Set NewFeeList=NewFeeList_$lb("放射费","P61007003")
	Set NewFeeList=NewFeeList_$lb("一般检查费","P61008001")
	Set NewFeeList=NewFeeList_$lb("临床物理治疗费","P61009001")
	Set NewFeeList=NewFeeList_$lb("核素治疗费","P61009002")
	Set NewFeeList=NewFeeList_$lb("特殊治疗费","P61009003")
	Set NewFeeList=NewFeeList_$lb("精神治疗费","P61009004")
	Set NewFeeList=NewFeeList_$lb("麻醉费","P61010001")
	Set NewFeeList=NewFeeList_$lb("手术费","P61010002")
	Set NewFeeList=NewFeeList_$lb("介入治疗费","P61010003")
	Set NewFeeList=NewFeeList_$lb("接生费","P61010004")
	Set NewFeeList=NewFeeList_$lb("康复治疗费","P61011001")
	Set NewFeeList=NewFeeList_$lb("中医治疗费","P61012001")
	Set NewFeeList=NewFeeList_$lb("抗菌药物费","P61013001")
	Set NewFeeList=NewFeeList_$lb("西药费","P61013002")
	Set NewFeeList=NewFeeList_$lb("中成药费","P61014001")
	Set NewFeeList=NewFeeList_$lb("中草药费","P61015001")
	Set NewFeeList=NewFeeList_$lb("输血费","P61016001")
	Set NewFeeList=NewFeeList_$lb("白蛋白类制品费","P61017001")
	Set NewFeeList=NewFeeList_$lb("球蛋白类制品费","P61018001")
	Set NewFeeList=NewFeeList_$lb("凝血因子类制品费","P61019001")
	Set NewFeeList=NewFeeList_$lb("细胞因子类制品费","P61020001")
	Set NewFeeList=NewFeeList_$lb("检查用一次性医用材料费","P61021001")
	Set NewFeeList=NewFeeList_$lb("治疗用一次性医用材料费","P61022001")
	Set NewFeeList=NewFeeList_$lb("介入用一次性医用材料费","P61023001")
	Set NewFeeList=NewFeeList_$lb("手术用一次性医用材料费","P61023002")
	
	//旧西医费用
	Set OldFeeList=$lb("总费用","P60000000")
	Set OldFeeList=OldFeeList_$lb("手术用一次性医用材料费","P60250000")
	Set OldFeeList=OldFeeList_$lb("治疗用一次性医用材料费","P60240000")
	Set OldFeeList=OldFeeList_$lb("检查用一次性医用材料费","P60230000")
	Set OldFeeList=OldFeeList_$lb("其他费用","P60040000")
	Set OldFeeList=OldFeeList_$lb("影像学诊断费","P60070000")
	Set OldFeeList=OldFeeList_$lb("手术费","P60100200")
	Set OldFeeList=OldFeeList_$lb("一般医疗服务费","P60010000")
	Set OldFeeList=OldFeeList_$lb("一般治疗操作费","P60020000")
	Set OldFeeList=OldFeeList_$lb("护理费","P60030000")
	Set OldFeeList=OldFeeList_$lb("临床诊断项目费","P60080000")
	Set OldFeeList=OldFeeList_$lb("临床物理治疗费","P60090100")
	Set OldFeeList=OldFeeList_$lb("实验室诊断费","P60060000")
	Set OldFeeList=OldFeeList_$lb("病理诊断费","P60050000")
	Set OldFeeList=OldFeeList_$lb("非手术治疗项目费","P60090000")
	Set OldFeeList=OldFeeList_$lb("介入治疗费","P60270000")
	Set OldFeeList=OldFeeList_$lb("麻醉费","P60100100")
	Set OldFeeList=OldFeeList_$lb("康复费","P60110000")
	Set OldFeeList=OldFeeList_$lb("中医治疗费","P60130000")
	Set OldFeeList=OldFeeList_$lb("血费","P60180000")
	Set OldFeeList=OldFeeList_$lb("其他费","P60260000")
	Set OldFeeList=OldFeeList_$lb("西药费","P60150000")
	Set OldFeeList=OldFeeList_$lb("抗菌药物费用","P60150100")
	Set OldFeeList=OldFeeList_$lb("中成药费","P60160000")
	Set OldFeeList=OldFeeList_$lb("中草药费","P60170000")
	Set OldFeeList=OldFeeList_$lb("白蛋白类制品费","P60190000")
	Set OldFeeList=OldFeeList_$lb("球蛋白类制品费","P60200000")
	Set OldFeeList=OldFeeList_$lb("凝血因子类制品费","P60210000")
	Set OldFeeList=OldFeeList_$lb("细胞因子类制品费","P60220000")
	
	//新中医费用
	Set NewFeeListC=$lb("诊疗费","P61001001")
	Set NewFeeListC=NewFeeListC_$lb("挂号费","P61001002")
	Set NewFeeListC=NewFeeListC_$lb("床位费","P61001003")
	Set NewFeeListC=NewFeeListC_$lb("中医辩证论治费","P61001004")
	Set NewFeeListC=NewFeeListC_$lb("中医辩证论治会诊费","P61001005")
	Set NewFeeListC=NewFeeListC_$lb("一般治疗费","P61002001")
	Set NewFeeListC=NewFeeListC_$lb("护理治疗费","P61002002")
	Set NewFeeListC=NewFeeListC_$lb("监护及辅助呼吸费","P61002003")
	Set NewFeeListC=NewFeeListC_$lb("输氧费","P61002004")
	Set NewFeeListC=NewFeeListC_$lb("护理费","P61003001")
	Set NewFeeListC=NewFeeListC_$lb("其它费用","P61004001")
	Set NewFeeListC=NewFeeListC_$lb("病理费","P61005001")
	Set NewFeeListC=NewFeeListC_$lb("化验费","P61006001")
	Set NewFeeListC=NewFeeListC_$lb("核素检查","P61007001")
	Set NewFeeListC=NewFeeListC_$lb("超声费","P61007002")
	Set NewFeeListC=NewFeeListC_$lb("放射费","P61007003")
	Set NewFeeListC=NewFeeListC_$lb("一般检查费","P61008001")
	Set NewFeeListC=NewFeeListC_$lb("临床物理治疗费","P61009001")
	Set NewFeeListC=NewFeeListC_$lb("核素治疗费","P61009002")
	Set NewFeeListC=NewFeeListC_$lb("特殊治疗费","P61009003")
	Set NewFeeListC=NewFeeListC_$lb("精神治疗费","P61009004")
	Set NewFeeListC=NewFeeListC_$lb("麻醉费","P61010001")
	Set NewFeeListC=NewFeeListC_$lb("手术费","P61010002")
	Set NewFeeListC=NewFeeListC_$lb("介入治疗费","P61010003")
	Set NewFeeListC=NewFeeListC_$lb("接生费","P61010004")
	Set NewFeeListC=NewFeeListC_$lb("康复治疗费","P61011001")
	Set NewFeeListC=NewFeeListC_$lb("中医诊断","P61012001")
	Set NewFeeListC=NewFeeListC_$lb("中医外治","P61013001")
	Set NewFeeListC=NewFeeListC_$lb("中医骨伤","P61013002")
	Set NewFeeListC=NewFeeListC_$lb("针刺与灸法","P61013003")
	Set NewFeeListC=NewFeeListC_$lb("中医推拿治疗","P61013004")
	Set NewFeeListC=NewFeeListC_$lb("中医肛肠治疗","P61013005")
	Set NewFeeListC=NewFeeListC_$lb("中医特色治疗","P61013006")
	Set NewFeeListC=NewFeeListC_$lb("中医特殊调配加工","P61014001")
	Set NewFeeListC=NewFeeListC_$lb("辩证施膳","P61014002")
	Set NewFeeListC=NewFeeListC_$lb("中医煎药费","P61014003")
	Set NewFeeListC=NewFeeListC_$lb("抗菌药物费","P61015001")
	Set NewFeeListC=NewFeeListC_$lb("西药费","P61015002")
	Set NewFeeListC=NewFeeListC_$lb("医疗机构中药制剂费","P61016001")
	Set NewFeeListC=NewFeeListC_$lb("中成药费","P61016002")
	Set NewFeeListC=NewFeeListC_$lb("中草药费","P61017001")
	Set NewFeeListC=NewFeeListC_$lb("输血费","P61018001")
	Set NewFeeListC=NewFeeListC_$lb("白蛋白类制品费","P61019001")
	Set NewFeeListC=NewFeeListC_$lb("球蛋白类制品费","P61020001")
	Set NewFeeListC=NewFeeListC_$lb("凝血因子类制品费","P61021001")
	Set NewFeeListC=NewFeeListC_$lb("细胞因子类制品费","P61022001")
	Set NewFeeListC=NewFeeListC_$lb("检查用一次性医用材料费","P61023001")
	Set NewFeeListC=NewFeeListC_$lb("治疗用一次性医用材料费","P61024001")
	Set NewFeeListC=NewFeeListC_$lb("介入用一次性医用材料费","P61025001")
	Set NewFeeListC=NewFeeListC_$lb("手术用一次性医用材料费","P61025002")
	Set NewFeeListC=NewFeeListC_$lb("其他费","P61026001")

	//旧中医费用
	Set OldFeeListC=$lb("一般医疗服务费","P60010000")
	Set OldFeeListC=OldFeeListC_$lb("中医辨证论治费","P60010400")
	Set OldFeeListC=OldFeeListC_$lb("中医辨证论治会诊费","P60010500")
	Set OldFeeListC=OldFeeListC_$lb("一般治疗操作费","P60020000")
	Set OldFeeListC=OldFeeListC_$lb("护理费","P60030000")
	Set OldFeeListC=OldFeeListC_$lb("其他费用","P60040000")
	Set OldFeeListC=OldFeeListC_$lb("病理诊断费","P60050000")
	Set OldFeeListC=OldFeeListC_$lb("实验室诊断费","P60060000")
	Set OldFeeListC=OldFeeListC_$lb("影像学诊断费","P60070000")
	Set OldFeeListC=OldFeeListC_$lb("临床诊断项目费","P60080000")
	Set OldFeeListC=OldFeeListC_$lb("非手术治疗项目费","P60090000")
	Set OldFeeListC=OldFeeListC_$lb("临床物理治疗费","P60090100")
	Set OldFeeListC=OldFeeListC_$lb("手术治疗费","P60100000")
	Set OldFeeListC=OldFeeListC_$lb("麻醉费","P60100100")
	Set OldFeeListC=OldFeeListC_$lb("手术费","P60100200")
	Set OldFeeListC=OldFeeListC_$lb("康复费","P60110000")
	Set OldFeeListC=OldFeeListC_$lb("中医诊断","P60120000")
	Set OldFeeListC=OldFeeListC_$lb("中医治疗","P60130000")
	Set OldFeeListC=OldFeeListC_$lb("中医外治","P60130100")
	Set OldFeeListC=OldFeeListC_$lb("中医骨伤","P60130200")
	Set OldFeeListC=OldFeeListC_$lb("针刺与灸法","P60130300")
	Set OldFeeListC=OldFeeListC_$lb("中医推拿治疗","P60130400")
	Set OldFeeListC=OldFeeListC_$lb("中医肛肠治疗","P60130500")
	Set OldFeeListC=OldFeeListC_$lb("中医特殊治疗","P60130600")
	Set OldFeeListC=OldFeeListC_$lb("中医其他","P60140000")
	Set OldFeeListC=OldFeeListC_$lb("中药特殊调配加工","P60140100")
	Set OldFeeListC=OldFeeListC_$lb("辨证施膳","P60140200")
	Set OldFeeListC=OldFeeListC_$lb("西药费","P60150000")
	Set OldFeeListC=OldFeeListC_$lb("抗菌药物费用","P60150100")
	Set OldFeeListC=OldFeeListC_$lb("中成药费","P60160000")
	Set OldFeeListC=OldFeeListC_$lb("医疗机构中药制剂费","P60160100")
	Set OldFeeListC=OldFeeListC_$lb("中草药费","P60170000")
	Set OldFeeListC=OldFeeListC_$lb("血费","P60180000")
	Set OldFeeListC=OldFeeListC_$lb("白蛋白类制品费","P60190000")
	Set OldFeeListC=OldFeeListC_$lb("球蛋白类制品费","P60200000")
	Set OldFeeListC=OldFeeListC_$lb("凝血因子类制品费","P60210000")
	Set OldFeeListC=OldFeeListC_$lb("细胞因子类制品费","P60220000")
	Set OldFeeListC=OldFeeListC_$lb("检查用一次性医用材料费","P60230000")
	Set OldFeeListC=OldFeeListC_$lb("治疗用一次性医用材料费","P60240000")
	Set OldFeeListC=OldFeeListC_$lb("手术用一次性医用材料费","P60250000")
	Set OldFeeListC=OldFeeListC_$lb("其他费","P60260000")
	
	Set ListName=""
	If (aFPType="W") {	//西医首页费用
		If (aItemType="N") {
			Set ListName=NewFeeList
		} Else {
			Set ListName=OldFeeList
		}
	} Else {	//中医医首页费用
		If (aItemType="N") {
			Set ListName=NewFeeListC
		} Else {
			Set ListName=OldFeeListC
		}
	}
	Quit:ListName="" return
	
	Set ind=$ListFind(ListName,aCateDesc)
	Quit:ind<1 return
	
	Set Code=$Lg(ListName,ind+1)
	
	Quit Code
}

}
