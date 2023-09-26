/// *************************************************************************************************************************
/// *******************************************Description:知识库项目扩展函数类**********************************************
/// *******************************************Creator:    QuNianpeng  ******************************************************
/// *******************************************CreateDate: 2017-03-16  ******************************************************
/// *************************************************************************************************************************
Class web.DHCSTPHCMPASSFUN Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:	获取his治疗项目对应的知识库通用名
/// Creator:		QuNianpeng
/// CreateDate:		2018-03-16
/// Input:			医嘱项id
/// return:			his通用名描述,知识库通用名id,商品名id,知识库标本id
/// other:			w ##class(web.DHCSTPHCMPASSFUN).GetLibNameByTreat("11481||1")
ClassMethod GetLibNameByTreat(arci As %String) As %String
{
	n (arci)
	q:arci="" 0
	s libGenDr = ""
	s sub=$p(arci,"||",1),ver=$p(arci,"||",2)
	q:(sub = "")||(ver = "") 0
	
	s hisArciCode = $p(^ARCIM(sub,ver,1),"^",1)						/// 治疗项目使用医嘱项名代码对照
	s hisArciDesc = $p(^ARCIM(sub,ver,1),"^",2)		
	s treatConDr=  $o(^DHCPHGENCON(0,"HisCode",hisArciCode,""))     /// 治疗项目对照id
	q:treatConDr="" 0
	
	s libTreatCode = $p(^DHCPHGENCON(treatConDr),"^",1)				/// 治疗项目代码
	i libTreatCode '= "" s libTreatGenDr=$o(^DHCPHEGENi(0,"Code",$ZCONVERT(libTreatCode,"U"),""))
	q:$g(libTreatGenDr)="" 0

	s pointer = ""
	s libPartDr = $o(^DHCPHEPA(0,"Code",$ZCONVERT("NULL","U"),""))	/// 部位代码固定为NULL
	s pointer = $g(libPartDr)
	q:pointer="" 0	
	
	q hisArciDesc_"^"_libTreatGenDr_"^"_""_"^"_pointer
}

/// Description:	获取his中诊断关联的特殊人群
/// Creator:		QuNianpeng
/// CreateDate:		2018-03-30
/// Input:			诊断表id
/// return:			特殊人群描述
/// Table:          User.CTSpecialCrowd
/// other:			w ##class(web.DHCSTPHCMPASSFUN).GetSpecialDesc(69)
ClassMethod GetSpecialDesc(mradm As %String) As %String
{
	n (mradm)

    s specialistStr=$p($G(^MR(mradm,"DHC")),"^",8)  // 之前是id_$c(1)_描述 2018/3/30 标板现在从基础数据维护-》病人管理-》特殊人群维护id_$c(1)_
    s speciaListDesc=""
    if (specialistStr'=""){
      s lengSpec=$L(specialistStr,"!")
      for sub=1:1:lengSpec {
	      s subStr=$P(specialistStr,"!",sub)
	      s specID=$P(subStr,$C(1),1)
	      continue:specID=""
	      s specDesc=$p(^CT("CTSPECR",specID),"^",2)
	      i speciaListDesc="" s speciaListDesc=specDesc
	      e  s speciaListDesc=speciaListDesc_"/"_specDesc
     }
   }
   q speciaListDesc
}

/// Description:	获取目录的文字描述信息
/// Creator:		QuNianpeng
/// CreateDate:		2019-11-21
/// Input:			医嘱项id,节点,医嘱串
/// return:			
/// Table:          
/// other:			w ##class(web.DHCSTPHCMPASSFUN).GetLabelTips("336||1","","")	83||7
/// 				w ##class(web.DHCSTPHCMPASSFUN).GetLabelTips("","","83||7")
ClassMethod GetLabelTips(arci, pointer, ordItem As %String) As %String
{
	n (arci,pointer,ordItem)

    s insnum=0
    s oeori=$p(ordItem,$c(2),1)
    s ord=$p(oeori,"||",1)
    s ordSub=$p(oeori,"||",2)
    i ord'="" d
    .i arci="" s arci=$p(^OEORD(ord,"I",ordSub,1),"^",2)
    
    s sub=$p(arci,"||",1),ver=$p(arci,"||",2)    
    s instType="Form"   
    s commonType=""
    s orderType=##class(web.DHCSTPHCMPASS).GetOrdType(arci)		// 医嘱类型 
	i orderType="R" s commonLibInfo=##class(web.DHCSTPHCMPASS).GetLibNameByDrug(arci),commonType="R"		// 药品医嘱
	i orderType="L" s commonLibInfo=##class(web.DHCSTPHCMPASS).GetLibNameByLab(arci,pointer),commonType="L"			// 检验医嘱 
	i orderType="N" s commonLibInfo=##class(web.DHCSTPHCMPASSFUN).GetLibNameByTreat(arci),commonType="N"	//治疗项目医嘱
	
	q:((sub="")||(ver="")) ""
	s serverMaterial=$p($g(^ARCIM(sub,ver,7)),"^",6)	
	i serverMaterial="S" s commonLibInfo=##class(web.DHCSTPHCMPASS).GetLibNameByLis(arci,pointer),commonType="S" //检查医嘱
	q:$g(commonLibInfo)="" ""
	s hisGeneDesc=$p(commonLibInfo,"^",1) // 通用名描述
	s libGenDr=$p(commonLibInfo,"^",2) 	  // 知识库通用名id
	s libProDr=$p(commonLibInfo,"^",3)    // 知识库商品名id
	s pointer=$p(commonLibInfo,"^",4)     // 剂型/部位/标本	

	q:(libGenDr="")&(libProDr="")||($g(pointer)="") ""
						
	i libProDr'=""  d					  // 通用名和商品名同时存在的情况下，优先商品名
	.s instType="ProName"
	.s pointer=0	
  	
  	s genDr=$case(libProDr="",1:libGenDr,:libProDr)
  	s retObj=..GetLabelTextByInstType(instType,genDr,pointer)
  	
	q retObj.%ToJSON()
}

ClassMethod GetLabelTextByInstType(instType, genDr, pointer) As %String
{
	n (instType,genDr,pointer)
	
	/// ^DHCPHINSTRUC("0","TGP",{PHINST_Type_Dr},{PHINST_Gen_Dr},{PHINST_PointerType},{PHINST_Pointer_Dr},{PHINST_RowId})
	s labelObj={}
	s labelDr=""
	f  s labelDr=$o(^DHCPHINSTRUC("0","TGP",labelDr))  q:labelDr=""  d
	.q:'$d(^DHCPHPINL(labelDr))
	.s labelCode=$p(^DHCPHPINL(labelDr),"^",1)
	.//s labelCode=$zcvt(labelCode,"U")
	.q:(labelCode'="Indic")&(labelCode'="Contr")&(labelCode'="Usage")&(labelCode'="PreMet")	// 适应症\用法用量\禁忌\给药途径
	.k labelArr
	.s labelArr=[]
	.s instruId="" f  s instruId=$o(^DHCPHINSTRUC("0","TGP",labelDr,genDr,instType,pointer,instruId)) q:instruId=""  d
    ..s libDr=$p(^DHCPHINSTRUC(instruId),"^",6)		// 知识库标识
   	..s text=$p(^DHCPHINSTRUC(instruId),"^",15)	
   	..q:text=""
	..d labelArr.%Push(text)
	.
	.d labelObj.%Set(labelCode,labelArr)
	
	q labelObj
}

/// Description:	清除知识库规则策略数据
/// Creator:		QuNianpeng
/// CreateDate:		2019-10-20
/// other:			w ##class(web.DHCSTPHCMPASSFUN).KillConfigData()
ClassMethod KillConfigData() As %String
{
	
	k ^DHCLIBITMF
	K ^mdata("DHCPHLibItemFeild")

	k ^DHCPHLFUNS
	K ^mdata("DHCPHLibFuntions")

	k ^DHCPHLIBRULE
	k ^mdata("DHCPHLIBRULE")

	k ^DHCPHFUNCAT
	k ^mdata("DHCPHFunCatFeild")

	k ^DHCPHLIBACC
	k ^mdata("DHCPHLibAcc")
	
	q "成功"
}

/// Description:	导入数据后，需要更新节点
/// Creator:		QuNianpeng
/// CreateDate:		2019-10-20
/// other:			w ##class(web.DHCSTPHCMPASSFUN).SetConfigGlobal()
ClassMethod SetConfigGlobal() As %String
{
	s ^mdata("DHCPHLibFuntions")=$o(^DHCPHLFUNS(""),-1)
	s ^mdata("DHCPHFunCatFeild")=$o(^DHCPHFUNCAT(""),-1)
	s ^mdata("DHCPHLibItemFeild")=$o(^DHCLIBITMF(""),-1)
	s ^mdata("DHCPHLibRule")=$o(^DHCPHLIBRULE(""),-1)
	
	q "成功"
}

/// Description:	清除知识库规则配置数据
/// Creator:		QuNianpeng
/// CreateDate:		2019-10-20
/// other:			w ##class(web.DHCSTPHCMPASSFUN).KillRuleConfigData()
ClassMethod KillRuleConfigData() As %String
{
	
	k ^DHCPHLIBRULE
	k ^mdata("DHCPHLIBRULE")
		
	q "成功"
}

/// Description:	获取his手术项目对应的知识库通用名
/// Creator:		QuNianpeng
/// CreateDate:		2019-12-24
/// Input:			手术项目表id ORC_Operation
/// return:			his项目描述,知识库通用名id,商品名id,知识库部位id
/// other:			w ##class(web.DHCSTPHCMPASSFUN).GetLibNameByOper("11481||1")
ClassMethod GetLibNameByOper(arci As %String) As %String
{
	n (arci)
	q:arci="" 0
	s operId=arci
	s libGenDr = ""

	q:'$d(^ORC("OPER",operId)) 0
	
	s hisOperCode = $p($g(^ORC("OPER",operId)),"^",1)				/// 手术项目使用ORC_Operation表代码对照
	s hisOperDesc =$p($g(^ORC("OPER",operId)),"^",2)	
	s hisOperDesc =$tr(hisOperDesc,",",".")
	s operConDr=  $o(^DHCPHOPCON(0,"HisCode",hisOperCode,""),-1)     /// 手术项目对照id
	q:operConDr="" 0
	
	s libOperCode = $p(^DHCPHOPCON(operConDr),"^",1)				/// 手术项目代码
	i libOperCode '= "" s libOperGenDr=$o(^DHCPHEGENi(0,"Code",$ZCONVERT(libOperCode,"U"),""))

	q:$g(libOperGenDr)="" 0

	s pointer = ""
	s libPartDr = $o(^DHCPHEPA(0,"Code",$ZCONVERT("NULL","U"),""))	/// 部位代码固定为NULL
	s pointer = $g(libPartDr)
	q:pointer="" 0	
	
	q hisOperDesc_"^"_libOperGenDr_"^"_""_"^"_pointer
}

/// Description:	审查BMI
/// Creator:		QuNianpeng
/// CreateDate:		2019-12-17
/// Input:			instruId,adm
/// other:			w ##class(web.DHCSTPHCMPASSFUN).Checkdiag()
ClassMethod CheckBMI(instruId, adm, RetMsg)
{
	n (instruId,adm,RetMsg)

	s ret=1
	q:instruId="" ret
	
	s BMIMin=$p($g(^DHCPHINSTRUC(instruId)),"^",16)
	s BMIMax=$p($g(^DHCPHINSTRUC(instruId)),"^",17)
	q:(BMIMin="")&(BMIMax="") ret
	
	;S PatW=##class(web.DHCSTCNTSCOMMON).GetPatWeight(AdmDr) //体重
	;S PatH=##class(web.DHCSTCNTSCOMMON).GetPatHeight(AdmDr) //身高
	s patW=""	// 体重
	s patH=""	// 身高
	i $D(^PAADM(adm)) d
	.S mradm=$P(^PAADM(adm),"^",61)
	.i (mradm'="")&($D(^MR(mradm,"PRO",1))) d
	..S patW=$P(^MR(mradm,"PRO",1),"^",27) 	//kg
	..S patH=$P(^MR(mradm,"PRO",1),"^",20)	//cm
	..s patH=170

	q:(patH="")||(patW="") ret
	
	s patH=$zcvt(patH,"L")
	s:patH["cm"||patH["厘米" patH=(+patH)/100	// BMI身高单位是m
	s patH=(+patH)/100
	s BMI=+patW/(patH*patH)
	
	i (BMIMin'="")&(BMIMax'="") d
	.i (BMIMin>BMI)||(BMIMax<BMI) s ret=0
	e  d
	.i (BMIMin="")&(BMIMax'="") s BMIMin=BMIMax
	.i BMIMin>BMI s ret=0
	
	q ret
}

/// Description:	审查SBP 收缩压(Systolic Blood Pressure)
/// Creator:		QuNianpeng
/// CreateDate:		2019-12-17
/// Input:			instruId,adm
/// User:			User.DHCPhysiologyVal
/// other:			w ##class(web.DHCSTPHCMPASSFUN).CheckSBP()
ClassMethod CheckSBP(instruId, adm, RetMsg)
{
	n (instruId,adm,RetMsg)
	
	s ret=1
	q:instruId="" ret
	
	s phyId=""
	f  s phyId=$o(^DHCPHYVAL("0","Inst",instruId,phyId))  q:phyId=""  d
	.s type=$p($g(^DHCPHYVAL(phyId)),"^",3)
	.q:type'="S"
	.s SBPMax=$p($g(^DHCPHYVAL(phyId)),"^",4)
	.s SBPMin=$p($g(^DHCPHYVAL(phyId)),"^",5)
	q:(SBPMin="")&(SBPMax="") ret	
	s SBP=##Class(Nur.CommonInterface.Temperature).getLastItemValue(adm, "sysPressure") // 6
	q:(SBP="") ret

	i (SBPMin'="")&(SBPMax'="") d
	.i (SBPMin>SBP)||(SBPMax<SBP) s ret=0
	e  d
	.i (SBPMin="")&(SBPMax'="") s SBPMin=SBPMax
	.i SBPMin>SBP s ret=0
	
	q ret
}

/// Description:	审查DBP 舒张压(Diastole Blood Pressure)
/// Creator:		QuNianpeng
/// CreateDate:		2019-12-17
/// Input:			instruId,adm
/// User:			User.DHCPhysiologyVal
/// other:			w ##class(web.DHCSTPHCMPASSFUN).CheckSBP()
ClassMethod CheckDBP(instruId, adm, RetMsg)
{
	n (instruId,adm,RetMsg)
	
	s ret=1
	q:instruId="" ret
	
	s phyId=""
	f  s phyId=$o(^DHCPHYVAL("0","Inst",instruId,phyId))  q:phyId=""  d
	.s type=$p($g(^DHCPHYVAL(phyId)),"^",3)
	.q:type'="D"
	.s DBPMax=$p($g(^DHCPHYVAL(phyId)),"^",4)
	.s DBPMin=$p($g(^DHCPHYVAL(phyId)),"^",5)
	q:(DBPMin="")&(DBPMax="") ret	
	s DBP=##Class(Nur.CommonInterface.Temperature).getLastItemValue(adm, "diaPressure")
	q:(DBP="") ret

	i (DBPMin'="")&(DBPMax'="") d
	.i (DBPMin>DBP)||(DBPMax<DBP) s ret=0
	e  d
	.i (DBPMin="")&(DBPMax'="") s DBPMin=DBPMax
	.i DBPMin>DBP s ret=0
	
	q ret
}

/// Description:	审查检验项目(医嘱)
/// Creator:		QuNianpeng
/// CreateDate:		2019-12-17
/// Input:			instruId,adm
/// User:			DHC_LibLabItm
/// OutPut:		    1 满足,0 不满足
/// other:			w ##class(web.DHCSTPHCMPASSFUN).CheckLibItm(instruId, adm, .RetMsg)
ClassMethod CheckLibItm(instruId, adm, RetMsg)
{
	n (instruId,adm,RetMsg)
	// 判断项目是否对照
	// 判断标本
	// 判断关联
	// 判断本次就诊中的最后一个项目
	// 判断状态
	
	s ret=1
	q:instruId="" ret
	
	s labRowId="",exitFlag=0
	f  s labRowId=$o(^DHCLIBLABI("0","Inst",instruId,labRowId))  q:(labRowId="")||(exitFlag=1)  d	 //DHC_LibLabItm
	.s labItmDr=$p($g(^DHCLIBLABI(labRowId)),"^",2)	// DHCPHExtGeneric
	.q:labItmDr=""
	.s repActiveFlag=$p($g(^DHCLIBLABI(labRowId)),"^",7)	// 要求报告状态
	.s labCode=$p($g(^DHCPHEGEN(labItmDr)),"^",1)
	.q:labCode=""
	.s hisCode="",exitFlag=0 	// 潜在风险, 项目存在一对多,若对照his多个项目,则不知道想要监测的是哪个项目
	.s hisCode=$o(^DHCPHGENCON(0,"Code",labCode,hisCode),-1)
	.i hisCode="" s exitFlag=1
	.q:hisCode="" 
	.
	.// 检验项目,hisCode可能是外部代码或医嘱项代码
	.s sub=$o(^ARCIM(0,"ExtCode",$$ALPHAUP^SSUTIL4(hisCode),""),-1) // 外部代码 ARCItemExternalCodes ^ARCIM(0,"ExtCode",$$ALPHAUP({EXT_Code}),{ARC_ItmMast.ARCIM_Subscript},{ARC_ItmMast.ARCIM_Version},{EXT_Childsub})
	.i sub="" s sub=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(hisCode),""),-1)
	.q:sub=""	
	.s ver=1
	.s arci=sub_"||"_ver
	.// 逆序遍历医嘱,找到Arci项目	
	.s oeord=$o(^OEORD(0,"Adm",adm,""),-1)
	.s stDat="",oeori="",quitFlag=0
	.f  s stDat=$o(^OEORDi(0,"ARCIM",oeord,arci,stDat),-1) q:(stDat="")||(quitFlag=1)  d
	..s oeordsub=""
	..f  s oeordsub=$o(^OEORDi(0,"ARCIM",oeord,arci,stDat,oeordsub),-1) q:(oeordsub="")||(quitFlag=1)  d
	...s oeoriStatus=$p(^OEORD(oeord,"I",oeordsub,1),"^",13)
	...q:+oeoriStatus=0
	...s oeoriStatusCode=$p(^OEC("OSTAT",oeoriStatus),"^",1)
	...q:(oeoriStatusCode'="V")&(oeoriStatusCode'="E")	// V 核实 E 执行
	...s oeori=oeord_"||"_oeordsub
	...s quitFlag=1
	..
	.
	.i oeori="" s ret=0		// his中没有术前检验项目
	.q:oeori="" 
	.// 知识库审查判断
	.i repActiveFlag="Y" d  // 要求报告状态
	..s statusId="",codeFlag=0
	..f  s statusId=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemID"," "_oeori,statusId),-1)  q:(statusId="")||(codeFlag=1)  d // Ens_Status
	...s ensStatusCode=$list(^Busi.ENS.EnsStatusD(statusId),9)	// 报告状态是RP
	...i ensStatusCode'="RP" s ret=0
	...q:ensStatusCode'="RP"
	...s codeFlag=1
	...s ret=1
	
	q ret
}

/// Description:	审查检查项目(医嘱)
/// Creator:		QuNianpeng
/// CreateDate:		2019-12-17
/// Input:			instruId,adm
/// other:			w ##class(web.DHCSTPHCMPASSFUN).CheckSBP()
ClassMethod CheckLisItm(instruId, adm, RetMsg)
{
	n (instruId,adm,RetMsg)
	// 判断项目是否对照
	// 判断部位
	// 判断关联
	// 判断本次就诊中的最后一个项目
	// 判断状态
	s ret=1
	q:instruId="" ret
	
	s labRowId="",exitFlag=0
	f  s labRowId=$o(^DHCLIBLABI("0","Inst",instruId,labRowId))  q:(labRowId="")||(exitFlag=1)  d	 //DHC_LibLabItm
	.s labItmDr=$p($g(^DHCLIBLABI(labRowId)),"^",2)	// DHCPHExtGeneric
	.q:labItmDr=""
	.s repActiveFlag=$p($g(^DHCLIBLABI(labRowId)),"^",7)	// 要求报告状态
	.s labCode=$p($g(^DHCPHEGEN(labItmDr)),"^",1)
	.q:labCode=""
	.s hisCode="",exitFlag=0 	// 潜在风险, 项目存在一对多,若对照his多个项目,则不知道想要监测的是哪个项目
	.s hisCode=$o(^DHCPHGENCON(0,"Code",labCode,hisCode),-1)
	.i hisCode="" s exitFlag=1
	.q:hisCode="" 
	.// 检查项目,hisCode可能医嘱项代码
	.s sub=$o(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(hisCode),""),-1)
	.q:sub=""	
	.s ver=1
	.s arci=sub_"||"_ver
	.
	.// 逆序遍历医嘱,找到Arci项目	
	.s oeord=$o(^OEORD(0,"Adm",adm,""),-1)
	.s stDat="",oeori="",quitFlag=0
	.f  s stDat=$o(^OEORDi(0,"ARCIM",oeord,arci,stDat),-1) q:(stDat="")||(quitFlag=1)  d
	..s oeordsub=""
	..f  s oeordsub=$o(^OEORDi(0,"ARCIM",oeord,arci,stDat,oeordsub),-1) q:(oeordsub="")||(quitFlag=1)  d
	...s oeoriStatus=$p(^OEORD(oeord,"I",oeordsub,1),"^",13)
	...q:+oeoriStatus=0
	...s oeoriStatusCode=$p(^OEC("OSTAT",oeoriStatus),"^",1)
	...q:(oeoriStatusCode'="V")&(oeoriStatusCode'="E")	// V 核实 E 执行
	...s oeori=oeord_"||"_oeordsub
	...s quitFlag=1
	..
	.
	.i oeori="" s ret=0		// his中没有术前检验项目
	.q:oeori="" 
	.// 知识库审查判断
	.i repActiveFlag="Y" d  // 要求报告状态
	..s statusId="",codeFlag=0
	..f  s statusId=$o(^Busi.ENS.EnsStatusI("IndexESOrdItemID"," "_oeori,statusId),-1)  q:(statusId="")||(codeFlag=1)  d // Ens_Status
	...s ensStatusCode=$list(^Busi.ENS.EnsStatusD(statusId),9)	// 报告状态是RP
	...i ensStatusCode'="RP" s ret=0
	...q:ensStatusCode'="RP"
	...s codeFlag=1
	...s ret=1
	
	q ret
}

/// Description:	审查检查项目-测值(医嘱)
/// Creator:		QuNianpeng
/// CreateDate:		2019-12-17
/// Input:			instruId,adm
/// other:			w ##class(web.DHCSTPHCMPASSFUN).CheckLisItmValue(13055,769)
ClassMethod CheckLisItmValue(instruId, adm, RetMsg)
{
	n (instruId, adm,RetMsg)
	
	s ret=-100
	q:instruId="" ret
	s patientID=$p($g(^PAADM(adm)),"^",1)
	s labRowId="",exitFlag=0
	f  s labRowId=$o(^DHCLIBLABI("0","Inst",instruId,labRowId))  q:(labRowId="")||(exitFlag=1)  d	 // DHC_LibLabItm
	.s labItmDr=$p($g(^DHCLIBLABI(labRowId)),"^",2)	// DHCPHExtGeneric
	.q:labItmDr=""
	.s repActiveFlag=$p($g(^DHCLIBLABI(labRowId)),"^",7)	// 要求报告状态
	.s labMinValue=$p($g(^DHCLIBLABI(labRowId)),"^",4)
	.s labMaxValue=$p($g(^DHCLIBLABI(labRowId)),"^",3)
	.s labRetion=$p($g(^DHCLIBLABI(labRowId)),"^",6)
	.s labRetion=$select("<>":"'=","!<":"'<","!>":"'>",1:labRetion)
	.s labCode=$p($g(^DHCPHEGEN(labItmDr)),"^",1)
	.q:labCode=""
	.s hisCode="",hisDesc="",exitFlag=0 	// 潜在风险, 项目存在一对多,若对照his多个项目,则不知道想要监测的是哪个项目
	.s hisCode=$o(^DHCPHGENCON(0,"Code",labCode,hisCode),-1)
	.i hisCode="" s exitFlag=1
	.q:hisCode="" 
	.// hisCode是检查测值代码,数据存在中Ens_RISReportResult Ens_RISItemResult.从这个表中找到最新一次测值的结果值，跟检查项目木有关系
	.s itmValue=..GetLisItmValue(adm,hisCode)
	.q:itmValue=""
	.s runStr="s ret="_itmValue_labRetion_labMinValue x runStr

	q ret
}

/// Description:	门诊获取一个月内有效的医嘱(有效指的是疗程未超过检测当天;比如今天11号，5号就诊开的医嘱疗程7天，那么就要判断)
/// Creator:		QuNianpeng
/// CreateDate:		2020-02-12
/// Input:			adm
/// User:		
/// other:			w ##class(web.DHCSTPHCMPASSFUN).GetOutValidOeori(1093)
/// 
ClassMethod GetOutValidOeori(adm)
{
	n (adm)
	
	s papmi=$p(^PAADM(adm),"^",1)
	q:papmi="" ""
	
	s oeoriStr=""
	s startDate=+$h-30
	s admType=""
	f  s admType=$o(^PAPERdr(papmi,"ADM",admType)) q:admType=""  d
	.q:(admType'="E")&(admType'="O")
	.s tmpadm=""
	.f  s tmpadm=$o(^PAPERdr(papmi,"ADM",admType,tmpadm)) q:tmpadm=""  d
	..s admDate=$p(^PAADM(tmpadm),"^",6)
	..q:admDate<startDate
	..s oeord=$o(^OEORD(0,"Adm",tmpadm,""))
	..q:oeord=""
	..s sub=""
	..f  s sub=$o(^OEORD(oeord,"I",sub))  q:sub=""  d
	...q:sub=0
	...Q:'$d(^OEORD(oeord,"I",sub,1))
	...s oeori=oeord_"||"_sub
	...s statusCode=""
	...s statusDr=$p(^OEORD(oeord,"I",sub,1),"^",13) //医嘱状态 U-作废 D-停止 C-撤销
    ...i statusDr'="" s statusCode=$p(^OEC("OSTAT",statusDr),"^",1)
    ...q:(statusCode="U")||(statusCode="D")||(statusCode="C")
	...//s priority=$p(^OEORD(oeord,"I",sub,1),"^",8)
	...//q:priority=""
	...//s priority=$p(OECPR(priority),"^",1)	
	...q:'$d(^OEORD(oeord,"I",sub,2))
	...s durat=$p(^OEORD(oeord,"I",sub,2),"^",6)
	...q:durat=""
	...s duratDate=$p(^PHCDU(durat),"^",2)
	...s oeoriDate=$p(^OEORD(oeord,"I",sub,3),"^",7)	// 开医嘱日期
	...q:(oeoriDate+duratDate)<+$h	// 开医嘱日期+疗程>=今天， 有效医嘱
	...i oeoriStr="" s oeoriStr=oeori
	...e  s oeoriStr=oeoriStr_$c(2)_oeori
	
	q oeoriStr
}

/// Description:	判断目录的计算方向
/// Creator:		QuNianpeng
/// CreateDate:		2020-04-14
/// Input:			目录描述
/// Ouput:			Y(正向,满足了提醒-同禁忌症),N(满足了不提醒,同适应症）
/// other:			w ##class(web.DHCSTPHCMPASSFUN).CalcPath("dd")
ClassMethod CalcPath(label)
{
	n (label)
	
	q $select(label="术前检验质控":"Y",label="术前检查质控":"Y",label="高危提醒":"Y",1:"N")
}

/// Description:	获取项目的检查测值
/// Creator:		QuNianpeng
/// CreateDate:		2020-04-15
/// Input:			就诊号,检查项目code
/// Ouput:			结果值
/// other:			w ##class(web.DHCSTPHCMPASSFUN).GetLisItmValue(769,"AO")
ClassMethod GetLisItmValue(adm, hisCode)
{
	
	n (adm,hisCode)
	s ret=""
	q:'$d(^Busi.ENS.EnsRISReportResultI("RISRVisitNumberIndex",adm)) ""
	s ensResID="",quitFlag=0,itmValue=""  // ^Busi.ENS.EnsRISReportResultI("RISRVisitNumberIndex",RISRVisitNumber,ID) RISRVisitNumber存的是就诊号
	f  s ensResID=$o(^Busi.ENS.EnsRISReportResultI("RISRVisitNumberIndex",adm,ensResID),-1)  q:(ensResID="")||(quitFlag=1)  d
	.s risReportID=$listget(^Busi.ENS.EnsRISReportResultD(ensResID),2)
	.s itmCode=""
	.f  s itmCode=$o(^Busi.ENS.EnsRISItemResultI("IndexReportItem",risReportID,itmCode)) q:(itmCode="")||(quitFlag=1)  d
	..s itemResID=""
	..q:itmCode'=hisCode
	..f  s itemResID=$o(^Busi.ENS.EnsRISItemResultI("IndexReportItem",risReportID,itmCode,itemResID),-1) q:(itemResID="")||(quitFlag=1)  d
	...s itmValue=$listget(^Busi.ENS.EnsRISItemResultD(itemResID),8)
	...i ret="" s ret=itmValue
	...s quitFlag=1
	
	q ret
}

}
