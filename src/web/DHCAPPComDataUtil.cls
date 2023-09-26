/// Creator: 	bianshuai
/// CreateDate: 2016-04-15
/// Descript: 	检查报告公共数据类
Class web.DHCAPPComDataUtil Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:获取病人基本就诊信息
/// W ##Class(web.DHCAPPComDataUtil).GetPatEssInfo("","2")
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    //姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)   //出生日期
	i PatBDay'="" s PatBDay=$zd(PatBDay,3)
	s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  //年龄
	s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") //诊断
	s PatDiagDesc=$E(PatDiagDesc,1,10)  //苏帆 2016年7月5日

	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_$g(PatSex)_"^"_PatAge_"^"_PatBDay_"^"_PatDiagDesc
	
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiagDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:	检查项目
/// W ##Class(web.DHCAPPComDataUtil).GetCheckItem("")
ClassMethod GetCheckItem(HospID As %String) As %String
{
	n (HospID)
	s ListTitle="arcimid^arcitmcode^arcitmdesc"
	s count = 0
	w "["
	/*
	s Num=0
	s itemCatID=""
	f  s itemCatID=$o(^ARC("IC",0,"OrderType","S",itemCatID)) q:itemCatID=""  d
	.s itmmastid=""
	.f  s itmmastid=$o(^ARCIM(0,"ARCIC_DR",itemCatID,itmmastid)) q:itmmastid=""  d
	..s itmmastver=""
	..f  s itmmastver=$o(^ARCIM(0,"ARCIC_DR",itemCatID,itmmastid,itmmastver)) q:itmmastver=""  d
	...s arcimid=itmmastid_"||"_itmmastver
	...s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码
	...s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
	...s ListData=arcimid_"^"_arcitmcode_"^"_arcitmdesc
	...s Num=Num+1
	...I Num=1 d
	....w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	...e  d
	....W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	..
	*/
	s ListData=1_"^"_"L0000001"_"^"_"CT"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	s ListData=2_"^"_"L0000002"_"^"_"超声"
	W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	s ListData=3_"^"_"L0000003"_"^"_"内镜"
	W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	s ListData=4_"^"_"L0000004"_"^"_"核磁共振"
	W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w "]"
	q ""
}

/// Descript:	检查部位
/// W ##Class(web.DHCAPPComDataUtil).GetCheckPartGetCheckPartOLD("","")
ClassMethod GetCheckPartOLD(LastRowid As %String, HospID As %String) As %String
{
	n (LastRowid, HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AP_RowId ,AP_Desc FROM DHC_AppPart"
	s sqlStr = sqlStr_" Where AP_Hosp_Dr='"_HospID_"'"_" And AP_LastRowid='"_LastRowid_"'"
	s sqlStr = sqlStr_" And AP_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="PartID^PartDesc"
	s count = 0
	w "["
	While(result.Next())
	{	
		s PartID = result.Data("AP_RowId")
		s PartDesc = result.Data("AP_Desc")
		s ListData=PartID_"^"_PartDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Descript:	检查体位
/// W ##Class(web.DHCAPPComDataUtil).GetCheckPositionOLD("")
ClassMethod GetCheckPositionOLD(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AP_RowID ,AP_Desc FROM DHC_AppPosition"
	s sqlStr = sqlStr_" Where AP_Hosp_Dr='"_HospID_"'"_" And AP_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="PosiID^PosiDesc"
	s count = 0
	w "["
	While(result.Next())
	{	
		s PosiID = result.Data("AP_RowID")
		s PosiDesc = result.Data("AP_Desc")
		s ListData=PosiID_"^"_PosiDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Descript:	后处理字典维护模块
/// W ##Class(web.DHCAPPComDataUtil).GetDispMedthodOLD("")
ClassMethod GetDispMedthodOLD(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AD_RowID ,AD_Desc FROM DHC_AppDispMedthod"
	s sqlStr = sqlStr_" Where AD_Hosp_Dr='"_HospID_"'"_" And AD_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="DispMID^DispMDesc"
	s count = 0
	w "["
	While(result.Next())
	{	
		s DispMID = result.Data("AD_RowID")
		s DispMDesc = result.Data("AD_Desc")
		s ListData=DispMID_"^"_DispMDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Descript:	检查方法
/// W ##Class(web.DHCAPPComDataUtil).GetArcCat("")
ClassMethod GetArcCat(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AC_RowID ,AC_CatDesc FROM DHC_AppArcCat"
	//s sqlStr = sqlStr_" Where AD_Hosp_Dr='"_HospID_"'"_" And AD_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="ArcCatID^ArcCatDesc"
	s count = 0
	w "["
	While(result.Next())
	{	

		s ArcCatID = result.Data("AC_RowID")
		continue:ArcCatID=0
		s ArcCatDesc = result.Data("AC_CatDesc")
		s ListData=ArcCatID_"^"_ArcCatDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Descript:	检查体位
/// W ##Class(web.DHCAPPComDataUtil).GetCheckPosition("")
ClassMethod GetCheckPosition(itmmastid As %String, HospID As %String) As %String
{
	n (itmmastid, HospID)
	
	s ListTitle="PosiID^PosiDesc"
	s count = 0
	
	w "["
	s PosiID=""
	f  s PosiID=$o(^DHCAPARCPO(0,"ArcPos",itmmastid,PosiID)) Q:PosiID=""  D
	.;s PosiID=$p(^DHCAPARCPO(ALPID),"^",2)
	.Q:'$d(^DHCAPPOS(PosiID))
	.Q:$p(^DHCAPPOS(PosiID),"^",3)'="Y"
	.Q:(HospID'="")&($p(^DHCAPPOS(PosiID),"^",4)'=HospID)
	.s PosiCode=$p(^DHCAPPOS(PosiID),"^",1)  ///体位代码
	.s PosiDesc=$p(^DHCAPPOS(PosiID),"^",2)  ///体位描述
	.s ListData=PosiID_"^"_PosiDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

/// Descript:	后处理方法
/// W ##Class(web.DHCAPPComDataUtil).GetDispMedthod("")
ClassMethod GetDispMedthod(itmmastid As %String, HospID As %String) As %String
{
	n (itmmastid, HospID)
	
	s ListTitle="DispMID^DispMDesc"
	s count = 0
	
	w "["
	s ALDID=""
	f  s ALDID=$o(^DHCAPARCDI(0,"Arc",itmmastid,ALDID)) Q:ALDID=""  D
	.s DispMID=$p(^DHCAPARCDI(ALDID),"^",2)
	.Q:'$d(^DHCAPDIM(DispMID))
	.Q:$p(^DHCAPDIM(DispMID),"^",3)'="Y"
	.Q:(HospID'="")&($p(^DHCAPDIM(DispMID),"^",4)'=HospID)
	.s DispMCode=$p(^DHCAPDIM(DispMID),"^",1)  ///后处理方法代码
	.s DispMDesc=$p(^DHCAPDIM(DispMID),"^",2)  ///后处理方法描述
	.s ListData=DispMID_"^"_DispMDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

/// Descript:	检查方法
/// W ##Class(web.DHCAPPComDataUtil).GetCheckMethod("1","1")
ClassMethod GetCheckMethod(itemCatID As %String, HospID As %String) As %String
{
	n (itemCatID, HospID)
	
	s ListTitle="arcimid^arcitmcode^arcitmdesc"
	s count = 0
	s itemCatID=$p(^DHCAPARCCA(itemCatID),"^",3)
	w "["
	s itmmastid=""
	f  s itmmastid=$o(^ARCIM(0,"ARCIC_DR",itemCatID,itmmastid)) q:itmmastid=""  d
	.s itmmastver=""
	.f  s itmmastver=$o(^ARCIM(0,"ARCIC_DR",itemCatID,itmmastid,itmmastver)) q:itmmastver=""  d
	..s arcimid=itmmastid_"||"_itmmastver
	..s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码
	..s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
	..s ListData=arcimid_"^"_arcitmcode_"^"_arcitmdesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

/// Descript:	检查部位
/// W ##Class(web.DHCAPPComDataUtil).GetCheckPart("1","1")
ClassMethod GetCheckPart(itemCatID As %String, HospID As %String) As %String
{
	n (itemCatID, HospID)
	
	s ListTitle="PartID^PartDesc"
	s count = 0
	
	w "["
	s CH=""
	f  s CH=$o(^DHCAPARCCA(itemCatID,"P",CH)) Q:CH=""  D
	.Q:'$d(^DHCAPARCCA(itemCatID,"P",CH))
	.s PartID=$p(^DHCAPARCCA(itemCatID,"P",CH),"^",1)
	.s PartCode=$p(^DHCAPPART(PartID),"^",1)  ///检查部位代码
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2)  ///检查部位描述
	.s ListData=itemCatID_"||"_CH_"^"_PartDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

/// Descript:	检查部位
/// W ##Class(web.DHCAPPComDataUtil).GetCheckSubPart("1||1","1")
/// W ##Class(web.DHCAPPComDataUtil).GetCheckSubPart("1||1","2")
ClassMethod GetCheckSubPart(arcCatLPID As %String, HospID As %String) As %String
{
	n (arcCatLPID, HospID)
	s LPCH=$p(arcCatLPID,"||",2)
	s ListTitle="PartID^PartDesc"
	s count = 0
	w "["
	s CH=""
	f  s CH=$o(^DHCAPARCCA(+arcCatLPID,"P",LPCH,"S",CH)) Q:CH=""  D
	.Q:'$d(^DHCAPARCCA(+arcCatLPID,"P",LPCH,"S",CH))
	.s PartID=$p(^DHCAPARCCA(+arcCatLPID,"P",LPCH,"S",CH),"^",1)
	.s PartCode=$p(^DHCAPPART(PartID),"^",1)  ///检查部位代码
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2)  ///检查部位描述
	.s PartFlag=$p(^DHCAPPART(PartID),"^",5)  ///检出部位状态
	.q:($g(PartFlag)="N")					  ///检查部位状态为停用时，不加载
	.s ListData=PartID_"^"_PartDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

/// Descript:	检查模板
/// W ##Class(web.DHCAPPComDataUtil).GetCheckPartNew("1","1")
ClassMethod GetItemTempNew(itmmastid As %String, HospID As %String) As %String
{
	n (itmmastid, HospID)
	
	s itemCatID=$p(^ARCIM(+itmmastid,$p(itmmastid,"||",2),1),"^",10)
	s ListTitle="PartID^PartDesc"
	s count = 0
	
	
	///^DHCAPARCCA(ArcCatID,"A",LPCH,"S",CH)
	w "["
	s ArcCatID=""
	f  s ArcCatID=$o(^DHCAPARCCA(0,"IndexOrdCatDr",itemCatID,ArcCatID)) Q:ArcCatID=""  D
	.Q:'$d(^DHCAPARCCA(ArcCatID))
	.f  s CH=$o(^DHCAPARCCA(ArcCatID,"A",CH)) Q:CH=""  D
	..s PartID=$p(^DHCAPARCCA(ArcCatID,"A",CH),"^",1)
	..s PartCode=$p(^DHCAPPART(PartID),"^",1)  ///检查部位代码
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2)  ///检查部位描述
	..s ListData=PartID_"^"_PartDesc
	..s count = count+1
	..I count=1 d
	...w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	..e  d
	...W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

/// Descript:  医嘱接收科室
/// W ##Class(web.DHCAPPComDataUtil).GetCatRecLoc("24","213")
ClassMethod GetCatRecLoc(EpisodeID As %String, arItemCatID As %String) As %String
{
	n (EpisodeID, arItemCatID)
	s itemCatID=$p(^DHCAPARCCA(arItemCatID),"^",3)   ///医嘱子类ID
	s admLocID=$p(^PAADM(EpisodeID),"^",4) 			 ///就诊科室
	s LocListData=##Class(web.DHCDocOrderCommon).GetLocRecLocByItemCat(admLocID,itemCatID)
	s ListTitle="LocID^LocDesc"
	s count = 0
	w "["
	s Len = $L(LocListData,$C(2))
	f i=1:1:Len d
	.s LocList = $p(LocListData,$C(2),i)
	.s LocID = $p(LocList,$C(1),1)
	.s LocDesc = $p(LocList,$C(1),2)
	.s ListData=LocID_"^"_LocDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""

	/*
	s ListData=1_"^"_"2CWKMZSF-2C外科门诊收费"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	s ListData=2_"^"_"2DGKMZSF-2D骨科门诊收费"
	W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	s ListData=3_"^"_"1CTJZXSF-1C体检中心收费"
	W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	s ListData=4_"^"_"ZYSFC-住院收费处"
	W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
		
	w "]"
	q ""
	*/
}

/// Descript:	  其它项目
/// W ##Class(web.DHCAPPComDataUtil).GetArcOtherOpt("1","1")
ClassMethod GetArcOtherOpt(itmmastid As %String, HospID As %String) As %String
{
	n (itmmastid, HospID)
	
	s ListTitle="OptiID^OptiDesc^OptiType^OptiRequ^ChildSubDesc"
	s count = 0
	w "["
	s OptiID=""
	f  s OptiID=$o(^DHCAPARCO(0,"ARC",itmmastid,OptiID)) Q:OptiID=""  D
	.Q:'$d(^DHCAPOTHO(OptiID))
	.Q:(HospID'="")&($p(^DHCAPOTHO(OptiID),"^",5)'=HospID)
	.s OptiCode=$p(^DHCAPOTHO(OptiID),"^",1)  ///代码
	.s OptiDesc=$p(^DHCAPOTHO(OptiID),"^",2)  ///描述
	.s OptiType=$p(^DHCAPOTHO(OptiID),"^",3)  ///类型
	.s OptiRequ=$p(^DHCAPOTHO(OptiID),"^",4)  ///是否必填
	.s ChildSubDesc=##Class(web.DHCAPPComDataUtil).GetOtherOptItm(OptiID)
	.s ListData=OptiID_"^"_OptiDesc_"^"_OptiType_"^"_OptiRequ_"^"_ChildSubDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

/// Descript:	  其它项目
/// W ##Class(web.DHCAPPComDataUtil).GetOtherOpt("1","1")
ClassMethod GetOtherOpt(itemCatID As %String, HospID As %String) As %String
{
	n (itemCatID, HospID)
	
	s ListTitle="OptiID^OptiDesc^OptiType^OptiRequ^ChildSubDesc"
	s count = 0
	w "["
	s OptiID=""
	f  s OptiID=$o(^DHCAPCATO(itemCatID,"O",OptiID)) Q:OptiID=""  D
	.Q:'$d(^DHCAPOTHO(OptiID))
	.Q:(HospID'="")&($p(^DHCAPOTHO(OptiID),"^",5)'=HospID)
	.s OptiCode=$p(^DHCAPOTHO(OptiID),"^",1)  ///代码
	.s OptiDesc=$p(^DHCAPOTHO(OptiID),"^",2)  ///描述
	.s OptiType=$p(^DHCAPOTHO(OptiID),"^",3)  ///类型
	.s OptiRequ=$p(^DHCAPOTHO(OptiID),"^",4)  ///是否必填
	.s ChildSubDesc=##Class(web.DHCAPPComDataUtil).GetOtherOptItm(OptiID)
	.s ListData=OptiID_"^"_OptiDesc_"^"_OptiType_"^"_OptiRequ_"^"_ChildSubDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

/// Descript:	  其它项目子项目
/// W ##Class(web.DHCAPPComDataUtil).GetOtherOptItm("1")
ClassMethod GetOtherOptItm(OptiID As %String) As %String
{
	n (OptiID)
	
	s ListTitle="OptItmID^OptItmDesc"
	s count = 0
	s jsonstr = "["
	s CH=""
	f  s CH=$o(^DHCAPOTHO(OptiID,"I",CH)) Q:CH=""  D
	.Q:'$d(^DHCAPOTHO(CH))
	.s OptItmCode=$p(^DHCAPOTHO(OptiID,"I",CH),"^",1)  ///代码
	.s OptItmDesc=$p(^DHCAPOTHO(OptiID,"I",CH),"^",2)  ///描述
	.s ListData=OptiID_"||"_CH_"^"_OptItmDesc
	.s count = count+1
	.I count=1 d
	..s jsonstr = jsonstr_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..s jsonstr = jsonstr_","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	s jsonstr = jsonstr_"]"
	q:jsonstr="[]" ""
	q jsonstr
}

/// Descript:申请历史列表
/// w ##Class(web.DHCAPPComDataUtil).jsonAppReqHis("10","1","2016-04-01^2016-05-30")
ClassMethod jsonAppReqHis(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)

	s End=page*rows  //结束行
	s Start=((page-1)*rows)+1     //开始行
	
	s startDate=$p(params,"^",1)
	s:startDate["-" startDate=$zdh(startDate,3)
	s endDate=$p(params,"^",2)
	s:endDate["-" endDate=$zdh(endDate,3)

	s pid=..NewPid()
	d ..killTmpGlobal(pid)
	
	s Num=0,count=0
	f dd=startDate:1:endDate  d
	.s arRepID=""
	.f  s arRepID=$o(^DHCAPREP(0,"CreateDate",dd,arRepID)) q:arRepID=""  d
	..s arReqNo=$p(^DHCAPREP(arRepID),"^",1)  ///单号
	..s arReqData=$p(^DHCAPREP(arRepID),"^",2)
	..s:arReqData'="" arReqData=$zd(arReqData,3)
	..s arReqTime=$p(^DHCAPREP(arRepID),"^",3)
	..s:arReqTime'="" arReqTime=$zt(arReqTime,3)
	..s arReqUser=""
	..s arReqUserID=$p(^DHCAPREP(arRepID),"^",4)
	..s:arReqUserID'="" arReqUser=$p(^SSU("SSUSR",arReqUserID),"^",2)
	..s repExLocID=$p(^DHCAPREP(arRepID),"^",5)
	..s arRepExLoc=$p(^CTLOC(repExLocID),"^",2) //执行科室
	..s EpisodeID=$p(^DHCAPREP(arRepID),"^",6)
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s arPatName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	..s arPatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	..s repEmgFlag=$p(^DHCAPREP(arRepID),"^",16)     //加急标志
	..s repEmgFlag=$s(repEmgFlag="Y":"是",1:"否")
	..s ListData=arRepID_"^"_arReqNo_"^"_arReqData_"^"_arReqTime_"^"_arReqUser_"^"_arRepExLoc
	..s ListData=ListData_"^"_EpisodeID_"^"_repEmgFlag_"^"_arPatName_"^"_arPatNo
	..s Num=Num+1
	..s ^TMP("DHCST","web.DHCAPPComDataUtil","jsonAppReqHis",pid,Num)=ListData
	.
	
	i Num="0" w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出空的json串
	q:Num="0" ""

	///转换数据为Json格式
	S ListTitle="arRepID^arReqNo^arReqData^arReqTime^arReqUser^arRepExLoc^EpisodeID^repEmgFlag^arPatName^arPatNo"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPComDataUtil","jsonAppReqHis",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPComDataUtil","jsonAppReqHis",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCAPPComDataUtil","jsonAppReqHis",pid)
	k ^TMP("DHCST","web.DHCAPPComDataUtil","jsonAppArcTemp",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("APPComDataUtil"))
}

/// Descript:获取检查申请单明细
/// W ##Class(web.DHCAPPComDataUtil).GetPatReqDetail("103")
ClassMethod GetPatReqDetail(arReqID As %String) As %String
{
	n (arReqID)
	
	s arReqUserID=$p(^DHCAPREP(arReqID),"^",4)  //申请人
	s repExLocID=$p(^DHCAPREP(arReqID),"^",5)   //执行科室
	s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)	//就诊ID
	s arItemCatID=$p(^DHCAPREP(arReqID),"^",7)	//医嘱子类
	//s arItmArcCatID=$o(^DHCAPARCCA(0,"Cat",arItemCatID,""))
	s arItemCat=$p(^DHCAPARCCA(arItemCatID),"^",2)
	s arPurpose=$p(^DHCAPREP(arReqID),"^",20)   //检查目的
	s arHisDesc=""
	s arHisID=$o(^DHCAPPREH(0,"ADM",EpisodeID,""))  //现病史
	i arHisID'="" s arHisDesc=$p(^DHCAPPREH(arHisID),"^",2)
	s arSigDesc=""
	s arSigID=$o(^DHCAPPATSI(0,"ADM",EpisodeID,"")) //体征信息
	i arSigID'="" s arSigDesc=$p(^DHCAPPATSI(arSigID),"^",2)
	
	s arReqOtherOpt=##Class(web.DHCAPPComDataUtil).GetPatRepOTH(arReqID) //其他项目
	
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    //姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)   //出生日期
	i PatBDay'="" s PatBDay=$zd(PatBDay,3)
	s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  //年龄
	s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") //诊断
	s PatDiagDesc=$E(PatDiagDesc,1,4)

	s ListData=arReqID_"^"_repExLocID_"^"_arItemCatID_"^"_arItemCat_"^"_PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge
	s ListData=ListData_"^"_PatBDay_"^"_PatDiagDesc_"^"_arPurpose_"^"_arHisDesc_"^"_arSigDesc_"^"_arReqOtherOpt
	
	s ListTitle="arRepID^repExLocID^arItemCatID^arItemCat^PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiagDesc^arPurpose^arDisHis^arPhySigns^arReqOtherOpt"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:获取报告医嘱项目对应信息
/// W ##Class(web.DHCAPPComDataUtil).GetPatRepArc("87")
ClassMethod GetPatRepArc(arReqID As %String) As %String
{
	n (arReqID)
	
	s ListData=""
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:CH=""  D
	.s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)  ///医嘱项目ID
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
	.s arcimid="AC_"_arcimid
	.
	.s PosiDesc=""
	.s PosiID=$p(^DHCAPREP(arReqID,"AR",CH),"^",2)     	  ///体位ID
	.s:PosiID'="" PosiDesc=$p(^DHCAPPOS(PosiID),"^",2)			   	  ///体位
	.s PosiID="PO_"_PosiID
	.
	.s PartList=""
	.s Sub=""
	.f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	..s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1) ///部位ID
	..Q:PartID=""
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				 ///部位
	..s PartID="PS_"_PartID
	..i PartList'="" s PartList=PartList_"$$"_PartID_"^"_PartDesc
	..E  s PartList=PartID_"^"_PartDesc
	.
	.s DispMList=""
	.s Sub=""
	.f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"DI",Sub)) Q:Sub=""  D
	..s DispMID=$p(^DHCAPREP(arReqID,"AR",CH,"DI",Sub),"^",1) ///后处理ID
	..Q:DispMID=""
	..s DispMDesc=$p(^DHCAPDIM(DispMID),"^",2) 				  ///后处理描述
	..s DispMID="DM_"_DispMID
	..i DispMList'="" s DispMList=DispMList_"$$"_DispMID_"^"_DispMDesc
	..E  s DispMList=DispMID_"^"_DispMDesc
	.
	.i ListData'="" s ListData=ListData_"!!"_PartList_"$$"_arcimid_"^"_arcitmdesc_"$$"_PosiID_"^"_PosiDesc_"$$"_DispMList
	.E  s ListData=PartList_"$$"_arcimid_"^"_arcitmdesc_"$$"_PosiID_"^"_PosiDesc_"$$"_DispMList
	
	q ListData
}

/// Descript:获取报告医嘱项目对应信息
/// W ##Class(web.DHCAPPComDataUtil).GetPatRepOTH("87")
ClassMethod GetPatRepOTH(arReqID As %String) As %String
{
	n (arReqID)
	
	s ListData=""
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"OT",CH)) Q:CH=""  D
	.s OptiID=$p(^DHCAPREP(arReqID,"OT",CH),"^",1) 	 ///项目ID
	.s OptDesc=$p(^DHCAPREP(arReqID,"OT",CH),"^",2)  ///项目值
	.s OptiType=$p(^DHCAPOTHO(OptiID),"^",3)  		 ///类型
	.s Prefix=$s(OptiType="Combox":"s",OptiType="Input":"i",OptiType="Check":"c",1:"")
	.s OptiID=Prefix_"_"_OptiID
	.
	.i ListData'="" s ListData=ListData_"$"_OptiID_"#"_OptDesc_"#"_OptiType
	.E  s ListData=OptiID_"#"_OptDesc_"#"_OptiType
	.
	q ListData
}

/// Descript:	检查方法
/// W ##Class(web.DHCAPPComDataUtil).GetAppArcCat("")
ClassMethod GetAppArcCat(HospID As %String) As %String
{
	n (HospID)
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AC_RowID ,AC_CatDesc FROM DHC_AppArcCat"
	//s sqlStr = sqlStr_" Where AD_Hosp_Dr='"_HospID_"'"_" And AD_ActiveFlag='Y'"
    d result.Prepare(sqlStr)
	d result.Execute()
	s ListTitle="value^text"
	s count = 0
	w "["
	While(result.Next())
	{	

		s ArcCatID = result.Data("AC_RowID")
		continue:ArcCatID=0
		s ArcCatDesc = result.Data("AC_CatDesc")
		s ListData=ArcCatID_"^"_ArcCatDesc
		s count = count+1
		I count=1 d
		.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
		e  d
		.W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	}
	w "]"
	q ""
}

/// Descript:	检查申请医嘱项模板
/// w ##Class(web.DHCAPPComDataUtil).jsonAppArcTemp("10","1","")
ClassMethod jsonAppArcTemp(rows As %String, page As %String, params As %String) As %String
{
	n (rows,page,params)

	s End=page*rows  //结束行
	s Start=((page-1)*rows)+1     //开始行
	
	s arcitemcat=$p(params,"^",1)
	
	s pid=..NewPid()
	d ..killTmpGlobal(pid)
	
	s Num=0,count=0
	s arcTempID="0"
	f  s arcTempID=$o(^DHCAPATE(arcTempID)) q:arcTempID=""  d
	.s arcSaveFor=$p(^DHCAPATE(arcTempID),"^",1)    /// 保存模式
	.s arcPoint=$p(^DHCAPATE(arcTempID),"^",2)      /// 指针
	.s arcCatItemID=$p(^DHCAPATE(arcTempID),"^",3)  /// 检查分类
	.Q:(arcitemcat'="")&(arcitemcat'=arcCatItemID)
	.s arcCatItem=$p(^DHCAPARCCA(arcCatItemID),"^",2) ///检查分类
	.s arcArcimId=$p(^DHCAPATE(arcTempID),"^",4)      /// 医嘱项ID
	.s itmmastid=$p(arcArcimId,"||",1)
	.s itmmastver=$p(arcArcimId,"||",2)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) ///医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) ///医嘱项名称
	.s arcPosiID=$p(^DHCAPATE(arcTempID),"^",5)     	   /// 体位ID
	.s arcPosiDesc=""
	.i arcPosiID'="" s arcPosiDesc=$p(^DHCAPPOS(arcPosiID),"^",2) ///体位
	.i arcPosiDesc'="" s arcPosiDesc="，"_arcPosiDesc
	.
	.s PartList=""
	.s Sub=""
	.f  s Sub=$o(^DHCAPATE(arcTempID,"P",Sub)) Q:Sub=""  D
	..s PartID=$p(^DHCAPATE(arcTempID,"P",Sub),"^",1) ///部位ID
	..Q:PartID=""
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2) 		  ///部位
	..s PartList=$s(PartList="":PartDesc,1:PartList_" + "_PartDesc)
	.
	.s DispMList=""
	.s Sub=""
	.f  s Sub=$o(^DHCAPATE(arcTempID,"D",Sub)) Q:Sub=""  D
	..s DispMID=$p(^DHCAPATE(arcTempID,"D",Sub),"^",1) ///后处理ID
	..Q:DispMID=""
	..s DispMDesc=$p(^DHCAPDIM(DispMID),"^",2) 		   ///后处理描述
	..s DispMList=$s(DispMList="":DispMDesc,1:DispMList_"、"_DispMDesc)
	..
	.i DispMList'="" s DispMList="，"_DispMList
	.s ListData=arcTempID_"^"_arcCatItem_"^"_PartList_"【"_arcitmdesc_arcPosiDesc_DispMList_"】"
	.s Num=Num+1
	.s ^TMP("DHCST","web.DHCAPPComDataUtil","jsonAppArcTemp",pid,Num)=ListData
	.
	
	i Num="0" w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出空的json串
	q:Num="0" ""

	///转换数据为Json格式
	S ListTitle="arcTempID^arcTempCat^arcTempDesc"
	w ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPComDataUtil","jsonAppArcTemp",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPComDataUtil","jsonAppArcTemp",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	
	w ##class(web.DHCAPPJsonCommon).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q ""
}

/// Descript:获取检查申请单明细
/// W ##Class(web.DHCAPPComDataUtil).GetArcTemp("103")
ClassMethod GetArcTemp(arcTempID As %String) As %String
{
	n (arcTempID)

	s arItemCatID=$p(^DHCAPATE(arcTempID),"^",3)    /// 检查分类ID
	s arItemCat=$p(^DHCAPARCCA(arItemCatID),"^",2) ///检查分类

	s ListData=arItemCatID_"^"_arItemCat
	
	s ListTitle="arItemCatID^arItemCat"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Descript:获取报告医嘱项目对应信息
/// W ##Class(web.DHCAPPComDataUtil).GetArcTempDetail("87")
ClassMethod GetArcTempDetail(arcTempID As %String) As %String
{
	n (arcTempID)
	
	s ListData=""
	
	s arcimid=$p(^DHCAPATE(arcTempID),"^",4)      /// 医嘱项ID
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) ///医嘱项代码
	s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) ///医嘱项名称
	s arcimid="AC_"_arcimid
	
	s PosiDesc=""
	s PosiID=$p(^DHCAPATE(arcTempID),"^",5)     	      /// 体位ID
	s:PosiID'="" PosiDesc=$p(^DHCAPPOS(PosiID),"^",2)	  ///体位
	s PosiID="PO_"_PosiID
	
	s PartList=""
	s Sub=""
	f  s Sub=$o(^DHCAPATE(arcTempID,"P",Sub)) Q:Sub=""  D
	.s PartID=$p(^DHCAPATE(arcTempID,"P",Sub),"^",1) ///部位ID
	.Q:PartID=""
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				 ///部位
	.s PartID="PS_"_PartID
	.i PartList'="" s PartList=PartList_"$$"_PartID_"^"_PartDesc
	.E  s PartList=PartID_"^"_PartDesc
	
	s DispMList=""
	s Sub=""
	f  s Sub=$o(^DHCAPATE(arcTempID,"D",Sub)) Q:Sub=""  D
	.s DispMID=$p(^DHCAPATE(arcTempID,"D",Sub),"^",1) ///后处理ID
	.Q:DispMID=""
	.s DispMDesc=$p(^DHCAPDIM(DispMID),"^",2) 				  ///后处理描述
	.s DispMID="DM_"_DispMID
	.i DispMList'="" s DispMList=DispMList_"$$"_DispMID_"^"_DispMDesc
	.E  s DispMList=DispMID_"^"_DispMDesc
	
	i ListData'="" s ListData=ListData_"!!"_PartList_"$$"_arcimid_"^"_arcitmdesc_"$$"_PosiID_"^"_PosiDesc_"$$"_DispMList
	E  s ListData=PartList_"$$"_arcimid_"^"_arcitmdesc_"$$"_PosiID_"^"_PosiDesc_"$$"_DispMList
	
	q ListData
}

/// Descript:获取医嘱项对应注意事项
/// W ##Class(web.DHCAPPComDataUtil).GetArcNoteTemp("9471||1")
ClassMethod GetArcNoteTemp(itmmastid) As %String
{
	n (itmmastid)
	s ListTitle="itemTemp^itemTempDesc"
	s count=0
	w "["
	s ID=""
	f  s ID=$o(^DHCAPARCNO(0,"ARC",itmmastid,ID)) q:ID=""  d
	.s itemTempId=$p(^DHCAPARCNO(ID),"^",2)      		 //注意事项ID
	.s itemTemp=$p(^DHCAPITMTE(itemTempId),"^",2)    //描述
	.s itemTempDesc=$G(^DHCAPITMTE(itemTempId,"D",1))
	.s aitActCode=$p(^DHCAPITMTE(itemTempId),"^",3) //可用标志 sufan 2016年7月11日
	.q:aitActCode="N"  //sufan 2016年7月11日 
	.s ListData=itemTemp_"^"_itemTempDesc
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.e  d
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

/// Descript: 获取报告医嘱项目信息(供其他组调用)
/// W ##Class(web.DHCAPPComDataUtil).GetCheckReqItmDetail("申请ID")
ClassMethod GetCheckReqItmDetail(arReqID As %String) As %String
{
	n (arReqID)
	s ListData=""
	
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:CH=""  D
	.s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)        ///医嘱项目ID
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) ///医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) ///医嘱项名称
	.
	.s PosiDesc=""
	.s PosiID=$p(^DHCAPREP(arReqID,"AR",CH),"^",2)     	   ///体位ID
	.s:PosiID'="" PosiDesc=$p(^DHCAPPOS(PosiID),"^",2)	   ///体位
	.
	.s PartList=""
	.s Sub=""
	.f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	..s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1) ///部位ID
	..Q:PartID=""
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				 ///部位
	..i PartList'="" s PartList=PartList_"!"_PartID_":"_PartDesc
	..E  s PartList=PartID_":"_PartDesc
	.
	.s DispMList=""
	.s Sub=""
	.f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"DI",Sub)) Q:Sub=""  D
	..s DispMID=$p(^DHCAPREP(arReqID,"AR",CH,"DI",Sub),"^",1) ///后处理ID
	..Q:DispMID=""
	..s DispMDesc=$p(^DHCAPDIM(DispMID),"^",2) 				  ///后处理描述
	..i DispMList'="" s DispMList=DispMList_"!"_DispMID_":"_DispMDesc
	..E  s DispMList=DispMID_":"_DispMDesc
	.
	.i ListData'="" s ListData=ListData_$C(2)_arcimid_":"_arcitmdesc_"^"_PosiID_":"_PosiDesc_"^"_PartList_"^"_DispMList
	.E  s ListData=arcimid_":"_arcitmdesc_"^"_PosiID_":"_PosiDesc_"^"_PartList_"^"_DispMList
	
	q ListData
}

}
