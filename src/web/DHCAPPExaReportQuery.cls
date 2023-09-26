Import SQLUser

/// Creator: 	bianshuai
/// CreateDate: 2016-04-25
/// Descript: 	检查申请报告
Class web.DHCAPPExaReportQuery Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:获取病人基本就诊信息
/// W ##Class(web.DHCAPPExaReportQuery).GetPatEssInfo("","2")
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String, PPFlag As %String = "") As %String
{
	n (PatientID, EpisodeID, PPFlag)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)  /// 出生日期
	i PatBDay'="" s PatBDay=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(PatBDay) //hxy 2017-03-03 $zd(PatBDay,3)
	s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	s PatDiagDesc=##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis($g(EpisodeID)) //##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") /// 诊断
	i $L(PatDiagDesc)>14 s PatDiagDesc=$E(PatDiagDesc,1,16)_"..."
	s PatType=$p(^PAADM(EpisodeID),"^",2) 	           /// 就诊类型
	s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,"")
 	s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	s PatLevel=$p(EncryptLevelInfo,"^",2)
 	s mradm=$p(^PAADM(EpisodeID),"^",61)          	  /// 就诊类型
 	s PatBed=$p(^PAADM(EpisodeID),"^",73) 		      /// 床号
	i PatBed'="" s PatBed=$p(^PAWARD($p(PatBed,"||",1),"BED",$p(PatBed,"||",2)),"^",1)
	i PatBed="" s PatBed=##Class(web.DHCEMNurAddOrder).GetPatSeatNo(EpisodeID) /// 座位号
	s BillTypeID=$P(^PAADM(EpisodeID,1),"^",7)          /// 费别指针
	s PatBill=$p($g(^PAC("ADMREA",+BillTypeID)),"^",2)
	s BillType=##class(DHCDoc.OPDoc.AjaxInterface).GetAdmReason(EpisodeID)
	//s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     ///  费别
	//s:BillType'="" PatBill=$p(^CT("SS",BillType),"^",2)
	
    s PrescriptTypeStr=##class(web.DHCDocOrderCommon).GetPrescriptTypeInfo(BillTypeID,PatType) /// 费别
    s PresTypes=$p(PrescriptTypeStr,"^",2)   /// 默认费别
	s BillTypeID=$p(PresTypes,":",1), BillType=$p(PresTypes,":",2)
	i PPFlag="Y" D     /// 药理实验患者费别
	.i PatType="I" D
	..s BillTypeID=##Class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("IPPilotPatAdmReason")
	.E  D
	..s BillTypeID=##Class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("PilotPatAdmReason")
	.s BillType=$p($g(^PAC("ADMREA",+BillTypeID)),"^",2)
	s BookStr=""
	s status=$p(^PAADM(EpisodeID),"^",20)
	if (status="P") s BookStr="预住院"
	s BookID=$O(^DHCDocIPBK(0,"EpisodeIDTo",EpisodeID,0))
	if (BookID'=""){
		s IsDayFlag=$p(^DHCDocIPBK(BookID),"^",33) ;是否日间
		if (IsDayFlag="Y"){
			if (BookStr=""){s BookStr="日间"}else{s BookStr=BookStr_" 日间"}
			}
	}
	if (BookStr'="") s BookStr="("_BookStr_")"
	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_BookStr_"^"_$g(PatSex)_"^"_PatAge_"^"_PatBDay_"^"_PatDiagDesc_"^"_PatType_"^"_EncryptLevel_"^"_PatLevel_"^"_mradm_"^"_PatBed_"^"_PatBill_"^"_BillTypeID_"^"_BillType
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiagDesc^PatType^PatSLv^PatLv^mradm^PatBed^PatBill^BillTypeID^BillType"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	Q Stream.Read()
}

/// Descritp:	检查分类
/// w ##Class(web.DHCAPPExaReportQuery).jsonExaCat()
ClassMethod jsonExaCat(HospID As %String) As %String
{
	n (HospID,%session)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AC_RowID ,AC_CatDesc FROM DHC_AppArcCat"
	i HospID'="" s sqlStr = sqlStr_" Where  AC_Hosp_Dr="_HospID
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	Set langid=..%LanguageID()
	While(result.Next())
	{	
		s RowId = result.Data("AC_RowID")
		s Desc = result.Data("AC_CatDesc")
		Set Desc= ##class(User.DHCAppArcCat).GetTranByDesc("ACCatDesc",Desc,langid)
		Continue:Desc=""
		s tmp=RowId_"^"_Desc
		s count = count+1
		I count=1 d
		.d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
		e  d
		.d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	}
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp: 根据检查分类取对应子类下的接收科室 
/// W ##Class(web.DHCAPPExaReportQuery).jsonExaCatRecLocByItemCat("24","20")
ClassMethod jsonExaCatRecLocByItemCat(EpisodeID As %String, arItemCatID As %String) As %String
{
	n (EpisodeID, arItemCatID)

	s itemCatID=$p(^DHCAPARCCA(arItemCatID),"^",3)   ///医嘱子类ID
	s admLocID=$p(^PAADM(EpisodeID),"^",4) 			 ///就诊科室
	s LocListData=##Class(web.DHCDocOrderCommon).GetLocRecLocByItemCat(admLocID,itemCatID)
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s Len = $L(LocListData,$C(2))
	f i=1:1:Len d
	.s LocList = $p(LocListData,$C(2),i)
	.s LocID = $p(LocList,$C(1),1)
	.s LocDesc = $p(LocList,$C(1),2)
	.s tmp=LocID_"^"_LocDesc
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	根据就诊ID，医嘱项ID获取接收科室
/// w ##Class(web.DHCAPPExaReportQuery).jsonExaCatRecLoc("32","5615||1")
ClassMethod jsonExaCatRecLoc(EpisodeID As %String, arItmmastID As %String) As %String
{
	n (EpisodeID, arItmmastID)

	s LocListData=##Class(web.DHCDocOrderCommon).GetRecloc(EpisodeID, arItmmastID)
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s Len = $L(LocListData,$C(2))
	f i=1:1:Len d
	.s LocList = $p(LocListData,$C(2),i)
	.s LocID = $p(LocList,$C(1),1)
	.s LocDesc = $p(LocList,$C(1),2)
	.s Default = $p(LocList,$C(1),3)
	.s tmp=LocID_"^"_LocDesc_"^"_Default
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^deftyle",tmp))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^deftyle",tmp))
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	根据医嘱项，部位获取对应体位
/// W ##Class(web.DHCAPPExaReportQuery).jsonExaPosition("11207||1","65")
ClassMethod jsonExaPosition(itmmastid As %String, HospID As %String, PartID As %String) As %String
{
	n (itmmastid, HospID, PartID, %session)
	Set langid=..%LanguageID()
	s count = 0
	s isExFlag=..isExistPos(itmmastid, PartID)  /// 是否存在医嘱项和部位对应体位项目 
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s ALPID=""
	f  s ALPID=$o(^DHCAPARCPO(0,"Arc",itmmastid,ALPID)) Q:ALPID=""  D
	.s PosiID=$p(^DHCAPARCPO(ALPID),"^",2)
	.Q:(isExFlag=1)&($p(^DHCAPARCPO(ALPID),"^",3)'=PartID)
	.Q:(isExFlag'=1)&($p(^DHCAPARCPO(ALPID),"^",3)'="")
	.Q:'$d(^DHCAPPOS(PosiID))
	.Q:$p(^DHCAPPOS(PosiID),"^",3)'="Y"
	.Q:(HospID'="")&($p(^DHCAPPOS(PosiID),"^",4)'=HospID)
	.s PosiCode=$p(^DHCAPPOS(PosiID),"^",1)  ///体位代码
	.s PosiDesc=$p(^DHCAPPOS(PosiID),"^",2)  ///体位描述
	.s PosiDesc=##class(User.DHCAppPosition).GetTranByDesc("APDesc",PosiDesc,langid)
	.s tmp=PosiID_"^"_PosiDesc
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	.
	d Stream.Write("]")
	q Stream.Read()
}

/// Description:： 是否存在医嘱项和部位对应体位项目 
ClassMethod isExistPos(itmmastid As %String, PartID As %String) As %String
{
	n (itmmastid, PartID)
	s ID="", QuitFlag=0
	F  s ID=$o(^DHCAPARCPO(0,"Arc",itmmastid,ID)) Q:(ID="")||(QuitFlag'=0)  D
	.Q:(PartID'="")&($p(^DHCAPARCPO(ID),"^",3)'=PartID)
	.s QuitFlag=1
	.
	Q QuitFlag
}

/// Descritp:	后处理方法
/// W ##Class(web.DHCAPPExaReportQuery).jsonExaDisp("7||1","")
ClassMethod jsonExaDisp(itmmastid As %String, HospID As %String) As %String
{
	n (itmmastid, HospID ,%session)
	Set langid=..%LanguageID()
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s ALDID=""
	f  s ALDID=$o(^DHCAPARCDI(0,"Arc",itmmastid,ALDID)) Q:ALDID=""  D
	.s DispMID=$p(^DHCAPARCDI(ALDID),"^",2)
	.Q:'$d(^DHCAPDIM(DispMID))
	.Q:$p(^DHCAPDIM(DispMID),"^",3)'="Y"
	.Q:(HospID'="")&($p(^DHCAPDIM(DispMID),"^",4)'=HospID)
	.s DispMCode=$p(^DHCAPDIM(DispMID),"^",1)  ///后处理方法代码
	.s DispMDesc=$p(^DHCAPDIM(DispMID),"^",2)  ///后处理方法描述
	.Set DispMDesc= ##class(User.DHCAppDispMedthod).GetTranByDesc("ADDesc",DispMDesc,langid)
	.s tmp=DispMID_"^"_DispMDesc
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	.
	d Stream.Write("]")
	q Stream.Read()
}

/// Descript:	检查部位
/// W ##Class(web.DHCAPPExaReportQuery).jsonCheckPart("1","1")
ClassMethod jsonCheckPart(arItemCatID As %String, HospID As %String) As %String
{
	n (arItemCatID, HospID)

	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s CH=""
	f  s CH=$o(^DHCAPARCCA(arItemCatID,"A",CH)) Q:CH=""  D
	.Q:'$d(^DHCAPARCCA(arItemCatID,"A",CH))
	.s PartID=$p(^DHCAPARCCA(arItemCatID,"A",CH),"^",1)
	.s PartCode=$p(^DHCAPPART(PartID),"^",1)  ///检查部位代码
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2)  ///检查部位描述
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(arItemCatID_"||"_CH,PartDesc))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(arItemCatID_"||"_CH,PartDesc))
	.d Stream.Write(..GetCheckPartChildren(arItemCatID_"||"_CH))
	.d Stream.Write("}")
	d Stream.Write("]")
	q Stream.Read()
}

///  Descript: 症状分级树孩子节点处理
ClassMethod GetCheckPartChildren(ParentID As %String) As %String
{
	n (ParentID)
	s LPCH=$p(ParentID,"||",2)
	///  是否存在孩子节点
	Q:'$o(^DHCAPARCCA(+ParentID,"A",LPCH,"S","")) ""
	///  存在孩子节点
	s count=0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	///  有孩子节点的初始化时收缩
	d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign())
	d Stream.Write(",""children"":[")
	s CH=""
	f  s CH=$o(^DHCAPARCCA(+ParentID,"A",LPCH,"S",CH)) Q:CH=""  D
	.Q:'$d(^DHCAPARCCA(+ParentID,"A",LPCH,"S",CH))
	.s PartID=$p(^DHCAPARCCA(+ParentID,"A",LPCH,"S",CH),"^",1)
	.s PartCode=$p(^DHCAPPART(PartID),"^",1)  ///检查部位代码
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2)  ///检查部位描述
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(+ParentID_"||"_PartID,PartDesc))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(+ParentID_"||"_PartID,PartDesc))
	.
	.d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript:	根据检查分类获取对应子类下的医嘱项
/// W ##Class(web.DHCAPPExaReportQuery).QueryCheckMethodList("1","1")
ClassMethod QueryCheckMethodList(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params)

	s End = page*rows
	s Start=(page-1)*rows+1

    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    s itemCatID=$p(params,"^",1)
    s HospID=$p(params,"^",2)
    s Stream=##class(%Stream.GlobalCharacter).%New()
	s itemCatID=$p(^DHCAPARCCA(itemCatID),"^",3)
	s h=0,count=0
	if itemCatID'="" d
	.s itmmastid=""
	.f  s itmmastid=$o(^ARCIM(0,"ARCIC_DR",itemCatID,itmmastid)) q:itmmastid=""  d
	..s itmmastver=""
	..f  s itmmastver=$o(^ARCIM(0,"ARCIC_DR",itemCatID,itmmastid,itmmastver)) q:itmmastver=""  d
	...s arcimid=itmmastid_"||"_itmmastver
	...s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码
	...s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
	...s arcitmprice=##class(web.DHCOPItemMast).GetOrderPrice("","",arcimid,+$h,"","","","")
	...s arcitmprice=+$p(arcitmprice,"^") 					//医嘱项价格
	...i $p(arcitmprice,".")="" s arcitmprice=0_arcitmprice  //小于0的价格前补0
	...s h=h+1
	...s ListData=arcimid_"^"_arcitmcode_"^"_arcitmdesc_"^"_arcitmprice
	...s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryCheckMethodList",pid,h)=ListData
	
	;i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	;q:h=0 
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="ItemID^ItemCode^ItemDesc^ItemPrice"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryCheckMethodList",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryCheckMethodList",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript:	检查分类
/// W ##Class(web.DHCAPPExaReportQuery).jsonCheckCatOld()
ClassMethod jsonCheckCatOld(HospID As %String, PyType As %String = "") As %String
{
	n (HospID,PyType)	
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s count=0 k TmpArr
	s ID=0
  	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",0,ID)) q:ID=""  d
  	.s Code=$p(^DHCAPPTRA(ID),"^",1)
  	.s Text=$p(^DHCAPPTRA(ID),"^",2)
  	.Q:$p(^DHCAPPTRA(ID),"^",5)'=HospID
  	.Q:(PyType'="")&&(PyType'[$p(^DHCAPPTRA(ID),"^",10))		//增加过滤类型 qunianpeng 2018/2/1
  	.s OrdNum=+$p(^DHCAPPTRA(ID),"^",6)
  	.i OrdNum=0 s OrdNum=Code
  	.s TmpArr(OrdNum,ID)=ID_"^"_Text_"^"_Code
  	.
  	s index=""
  	F  s index=$o(TmpArr(index)) Q:index=""  D
  	.s IDindex=""
  	.F  s IDindex=$o(TmpArr(index,IDindex)) Q:IDindex=""  D
  	..s ID=+$g(TmpArr(index,IDindex))
  	..s Code=$p(^DHCAPPTRA(ID),"^",1)
  	..s Text=$p(^DHCAPPTRA(ID),"^",2)
  	..s count = count+1
	..i count=1 d
	...d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
	..e  d
	...d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
    ..///  是否存在孩子节点
	..s trID=$o(^DHCAPPTRA(0,"LastRowid",ID,""))
	..i trID'="" D
	...d Stream.Write(",""children"":")
	...d Stream.Write(..jsonCheckCatByNodeID(ID,HospID,PyType))
	..e  d
	...
	...d Stream.Write(..GetCheckTreeLeafNote(ID))  ///是否有叶子节点
	..d Stream.Write("}")
	
	/// 如果分类树为空,显示默认根节点
	i count=0 d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign("ROOT","部位树根节点")_"}")
	
	d Stream.Write("]")
  	q Stream.Read()
	
	/*
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT AC_RowID ,AC_CatDesc FROM DHC_AppArcCat"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	While(result.Next())
	{	
		s arItemCatID = result.Data("AC_RowID")
		s arItemCat = result.Data("AC_CatDesc")
		Continue:arItemCat=""
		s count = count+1
		i count=1 d
		.d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(arItemCatID,arItemCat))
		e  d
		.d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(arItemCatID,arItemCat))
		d Stream.Write(..GetCheckPart(arItemCatID))
		d Stream.Write("}")
	}
	d Stream.Write("]")
	q Stream.Read()
	*/
}

/// Descript:	检查部位
/// W ##Class(web.DHCAPPExaReportQuery).GetCheckPart("1","1")
ClassMethod GetCheckPart(arItemCatID As %String) As %String
{
	n (arItemCatID)
	///  是否存在孩子节点
	Q:'$o(^DHCAPARCCA(arItemCatID,"A","")) ""
	///  存在孩子节点
	s count=0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	///  有孩子节点的初始化时收缩
	d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign())
	d Stream.Write(",""children"":[")
	s CH=""
	f  s CH=$o(^DHCAPARCCA(arItemCatID,"A",CH)) Q:CH=""  D
	.Q:'$d(^DHCAPARCCA(arItemCatID,"A",CH))
	.s PartID=$p(^DHCAPARCCA(arItemCatID,"A",CH),"^",1)
	.s PartCode=$p(^DHCAPPART(PartID),"^",1)  ///检查部位代码
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2)  ///检查部位描述
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(arItemCatID_"||"_PartID,PartDesc))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(arItemCatID_"||"_PartID,PartDesc))
	.d Stream.Write(..GetCheckPartChildren(arItemCatID_"||"_CH))
	.d Stream.Write("}")
	d Stream.Write("]")
  	q Stream.Read()
}

/// Descript:  申请列表
/// W ##Class(web.DHCAPPExaReportQuery).QueryExaReqHisList("30","1","527^^D^2")
ClassMethod QueryExaReqHisList(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params,%session)
	s ^tempqujian("QueryExaReqHisList")=rows_","_page_","_params
	s End = page*rows
	s Start=(page-1)*rows+1

    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global

	/// 检查申请列表
	d ..GetExaReqHis(pid, params)
	/// 病理申请列表
	d ..GetPisReqHis(pid, params)
	s Stream=##class(%Stream.GlobalCharacter).%New()
	///转换数据为Json格式
	S ListTitle="arRepID^arReqNo^arReqData^repEmgFlag^arExaReqCode^repStatCode^arcListData^TraType^ReqType^CreateDocDesc"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()) //输出json前缀串
	s index="",count=0
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqHisList",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqHisList",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count)) //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	Q Stream.Read()
}

ClassMethod QueryExaReqHisListCount(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params,%session)
	s ^tempqujian("QueryExaReqHisList")=rows_","_page_","_params
	s End = page*rows
	s Start=(page-1)*rows+1

    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global

	/// 检查申请列表
	d ..GetExaReqHis(pid, params)
	/// 病理申请列表
	d ..GetPisReqHis(pid, params)
	
	s index="",count=0
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqHisList",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqHisList",pid,index))
	.s count = count+1
	Q count
}

/// Descript:  检查申请列表
/// W ##Class(web.DHCAPPExaReportQuery).GetExaReqHis("43633","2682^^^9")
ClassMethod GetExaReqHis(pid As %String, params As %String) As %String
{
	n (pid, params,%session)
	Set langid=..%LanguageID()
	s ^tempqujian("GetExaReqHis")=pid _","_params
	s EpisodeID=$p(params,"^",1)   /// 就诊ID
    s itemCatID=$p(params,"^",2)   /// 检查分类ID
    s repStatID=$p(params,"^",3)   /// 报告状态Code
    s HospID=$p(params,"^",4)      /// 医院
    s itmCatCode=""
    i itemCatID'="" s itmCatCode=$p(^DHCAPARCCA(itemCatID),"^",1)  	/// 检查分类代码
	s arRepID=""
	S DateFormat=##class(web.DHCAPPCommonUtil).DateFormat()  //hxy 
	f  s arRepID=$o(^DHCAPREP(0,"ADM",EpisodeID,arRepID)) Q:arRepID=""  D
	.s arExaReqCode=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(arRepID,"",HospID)
	.Q:(itmCatCode'="")&(itmCatCode'=arExaReqCode)
	.s arExLocID=$p(^DHCAPREP(arRepID),"^",5)  		/// 执行科室
	.s ARCreateDocDr=$p(^DHCAPREP(arRepID),"^",4) //申请人
	.s SUSRHospitalDR=$p($g(^SSU("SSUSR",ARCreateDocDr)),"^",98)
	.;Q:SUSRHospitalDR'=HospID
	.;//执行科室有可能是跨院,去掉按照执行科室院区过滤条件
	.;Q:$p($g(^CTLOC(+arExLocID)),"^",22)'=HospID
	.s arReqNo=$p(^DHCAPREP(arRepID),"^",1)  		/// 单号
	.s arReqData=$p(^DHCAPREP(arRepID),"^",2)		/// 申请日期
	.s:arReqData'="" arReqData=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(arReqData) //hxy 2017-03-22 $zd(arReqData,3)
	.s arReqTime=$p(^DHCAPREP(arRepID),"^",3)		/// 申请时间
	.s:arReqTime'="" arReqTime=..%ZT(arReqTime,2)
	.i DateFormat=3 s arReqData=$E(arReqData,6,10)_" "_arReqTime  //hxy
	.i DateFormat=4 s arReqData=$E(arReqData,1,5)_" "_arReqTime  //hxy
	.//s arReqData=$E(arReqData,6,10)_" "_arReqTime   //hxy 2017-03-22 
	.s repEmgFlag=$p(^DHCAPREP(arRepID),"^",16)     /// 加急标志
	.s repEmgFlag=$s(repEmgFlag="Y":"是",1:"否")
	.Q:(($p(^DHCAPREP(arRepID),"^",17)'="Y")&&($p(^DHCAPREP(arRepID),"^",17)'="I"))	        /// 是否发送
	.s arExaReqDesc=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(arRepID,1,HospID)
	.i arExaReqDesc="" s arExaReqDesc="未知"
	.E  s arExaReqDesc=arExaReqDesc
	.s ^tempqujian("arExaReqDesc")=arExaReqDesc
	.;s arExaReqDesc=##class(websys.Translation).Get("dhcapp.mainframe.csp",arExaReqDesc)
	./// 检查当前对应部位是否停止
	.s arSendFlag=$p(^DHCAPREP(arRepID),"^",17) 
	.s repStat=##Class(web.DHCAPPExaReportQuery).GetExaReqNoStat(arRepID)
	.s QuitFlag=0
	.if repStatID="D" d
	..if repStat=0 s QuitFlag=1
	.if repStatID="I" d
	..if (repStat'=0)&&(arSendFlag="I") s QuitFlag=1
	.if ((repStatID="V")||(repStatID="")) d
	..if (repStat'=0)&&(arSendFlag="Y") s QuitFlag=1
	.q:(QuitFlag=0)
	.;Q:(repStatCode'=0)&(repStatID="D")
	.;Q:(repStatCode=0)&(repStatID'="D")
	.;Q:((repStatID="I")&&(arSendFlag'="I"))
	.;Q:((repStatID'="I")&&(arSendFlag="I"))
	.s repStatCode=$s(repStat=0:"停止",1:"")
	.if (repStat'=0)&&(arSendFlag="I") s repStatCode="待审核"
	.s repStatCode=##class(websys.Translation).Get("dhcapp.mainframe.csp",repStatCode)
	.s index=$p(^DHCAPREP(arRepID),"^",2)		/// 申请日期
	.s arcListData="",TraType=""
	.s CH=""
	.f  s CH=$o(^DHCAPREP(arRepID,"AR",CH)) Q:CH=""  D
	..s itmmastid=$p(^DHCAPREP(arRepID,"AR",CH),"^",1)      /// 医嘱项ID
	..s oeori=$p(^DHCAPREP(arRepID,"AR",CH),"^",3)          /// 医嘱ID
	..i TraType="" s TraType=..GetTraType(itmmastid)
 	..s ItemLabel=##Class(web.DHCAPPInterface).GetExaReqItemDesc(oeori)
 	..if ItemLabel="" s ItemLabel=$p(^ARCIM(+itmmastid,$P(itmmastid,"||",2),1),"^",2)
 	..s ItemLabel=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ItemLabel,langid)
 	..i TraType="E" D
	...s RetFlag=##Class(web.DHCAPPInterface).GetOeoriRetFlag(arRepID,CH)  /// 报告是否已出
	..E  D
	...s RetFlag=""
	...i oeori'="" s RetFlag=##Class(web.DHCAPPInterface).GetOeLabRepFlag(oeori)
	...i RetFlag="Y" s RetFlag="IM"
	..s IsFlag=##Class(web.DHCAPPInterface).IsOpenBookWin(oeori)			 /// 检查项目是否预约
	..i arcListData="" s arcListData=oeori_"&&"_ItemLabel_"&&"_RetFlag_"&&"_IsFlag
	..E  s arcListData=arcListData_"#"_oeori_"&&"_ItemLabel_"&&"_RetFlag_"&&"_IsFlag
	.s CreateDocDesc=""
	.s CreateDocDr=$p(^DHCAPREP(arRepID),"^",4)
	.if CreateDocDr'="" s CreateDocDesc=$p(^SSU("SSUSR",CreateDocDr),"^",2)
	. s CreateDocDesc =##class(User.SSUser).GetTranByDesc("SSUSRName",CreateDocDesc,langid)
	.s ListData=arRepID_"^"_arReqNo_"^"_arReqData_"^"_repEmgFlag_"^"_arExaReqDesc_"^"_repStatCode_"^"_arcListData_"^"_TraType_"^^"_CreateDocDesc
	.s index=arExaReqCode_"^"_index_"^"_arReqNo
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqHisList",pid,index)=ListData
	.
	Q ""
}

/// Descript:  病理申请列表
/// W ##Class(web.DHCAPPExaReportQuery).GetExaReqHis("30","1","527^^D^2")
ClassMethod GetPisReqHis(pid As %String, params As %String) As %String
{
	n (pid, params,%session)
	Set langid=..%LanguageID()
	s EpisodeID=$p(params,"^",1)   /// 就诊ID
	s itemCatID=$p(params,"^",2)   /// 检查分类ID
    s repStatID=$p(params,"^",3)   /// 报告状态Code
    s HospID=$p(params,"^",4)      /// 医院
 	s itmCatCode=""				   /// sufan 2018-03-01 按分类过滤病理
    i itemCatID'="" s itmCatCode=$p(^DHCAPARCCA(itemCatID),"^",1)  	/// 检查分类代码
	S DateFormat=##class(web.DHCAPPCommonUtil).DateFormat()  	//hxy 
    s PisID=""
    F  s PisID=$o(^DHCAPPPM(0,"Adm",EpisodeID,PisID)) Q:PisID=""  D
    .s PisCatCode=##Class(web.DHCAPPExaReportQuery).GetPisReqItmCat(PisID)		///sufan 2018-03-01
    .Q:(itmCatCode'="")&(itmCatCode'=PisCatCode)
    .s LocID=$p(^DHCAPPPM(PisID),"^",8)  	   /// 申请科室
	.Q:$p($g(^CTLOC(+LocID)),"^",22)'=HospID
	.s No=$p(^DHCAPPPM(PisID),"^",4)           /// 申请单号
	.s CreatDate=$p(^DHCAPPPM(PisID),"^",6)	   /// 申请日期
	.s:CreatDate'="" CreatDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(CreatDate) 
	.s CreatTime=$p(^DHCAPPPM(PisID),"^",7)	   /// 申请时间
	.s PisNo=$p(^DHCAPPPM(PisID),"^",13)						//病理号
	.s:CreatTime'="" CreatTime=..%ZT(CreatTime,2)
	.i DateFormat=3 s CreatDate=$E(CreatDate,6,10)_" "_CreatTime  	/// hxy
	.i DateFormat=4 s CreatDate=$E(CreatDate,1,5)_" "_CreatTime  	/// hxy
	.s apStatus=$p(^DHCAPPPM(PisID),"^",9)	   /// 申请状态
	.Q:(apStatus="D")&(repStatID'="D")
	.Q:(apStatus'="D")&(repStatID="D")
	.Q:((repStatID="I")&&(apStatus'="I"))
	.Q:((repStatID'="I")&&(apStatus="I"))
	.;s apStatus=$s(apStatus="D":"停止",apStatus="N":"申请",apStatus="Y":"发送",1:"")
	.
	.s ID=+$p(^DHCAPPPM(PisID),"^",21)       /// 结果状态ID
	.s PisStats=""
	.i apStatus="发送" s PisStats=$p($g(^DHCAPPTST(+ID)),"^",2)    /// 状态描述
	.i PisStats'="" s apStatus=PisStats
	.s apStatus=$E(apStatus,1,2)
	.s RetFlag=""
	.s PisType=$p(^DHCAPPPM(PisID),"^",20)  	   /// 申请类型
	.s PisReqDesc=$s(PisType["CYT":"细胞",PisType["HPV":"HPV",PisType["TCT":"TCT",PisType="LIVN":"活体",PisType="FLIV":"冰冻",PisType["APY":"尸检",PisType["CON":"外院",PisType["MOL":"分子",1:"未知")
	.s PisReqDesc=##class(websys.Translation).Get("dhcapp.mainframe.csp",PisReqDesc)
	.s index=$p(^DHCAPPPM(PisID),"^",6)	           /// 申请日期
	.s arcListData=""
  	.s CH=""
  	.f  s CH=$o(^DHCAPPPM(PisID,"A",CH))  Q:CH=""  D
  	..s oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)
  	..s ordStatus=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(oeori)
  	..s:ordStatus'="I" apStatus = ##Class(web.DHCAPPInterface).GetExaReqItmStatus(oeori,PisNo)
  	..i apStatus="RP" s RetFlag="IM"
  	..s arcimid=$p(^DHCAPPPM(PisID,"A",CH),"^",1)   /// 医嘱项ID
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s ItemLabel=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
	..s ItemLabel=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ItemLabel,langid)
  	..i arcListData="" s arcListData=oeori_"&&"_ItemLabel_"&&"_RetFlag_"&&"_""
	..E  s arcListData=arcListData_"#"_oeori_"&&"_ItemLabel_"&&"_RetFlag_"&&"_""
	.s apStatus = ..GetResultStatus(apStatus)
	.s PisApStatus=$p(^DHCAPPPM(PisID),"^",9)
	.if (PisApStatus="I") s apStatus ="待审核"
	.if (PisApStatus="D") s apStatus ="取消申请"
	.s apStatus=##class(websys.Translation).Get("dhcapp.mainframe.csp",apStatus)
	.s PisReqDesc=##class(websys.Translation).Get("dhcapp.mainframe.csp",PisReqDesc)
	.s CreateDocDesc=""
	.s CreateDocDr=$p(^DHCAPPPM(PisID),"^",5)
	.if CreateDocDr'="" s CreateDocDesc=$p(^SSU("SSUSR",CreateDocDr),"^",2)
	.s CreateDocDesc =##class(User.SSUser).GetTranByDesc("SSUSRName",CreateDocDesc,langid)
	.s ListData=PisID_"^"_No_"^"_CreatDate_"^"_""_"^"_PisReqDesc_"^"_apStatus_"^"_arcListData_"^"_"P"_"^"_PisType_"^"_CreateDocDesc
	.s index=PisType_"^"_index_"^"_PisID
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqHisList",pid,index)=ListData
	Q ""
}

/// Descript:  已开项目列表
/// W ##Class(web.DHCAPPExaReportQuery).QueryExaReqDetList("1118")
ClassMethod QueryExaReqDetList(params As %String) As %String
{
	n (params,%session)
	s ^tempqujian("QueryExaReqDetList")=params	
	Set langid=..%LanguageID()
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    s arReqID=$p(params,"^",1)  /// 检查申请ID
	Q:arReqID="" ""
    s itemLoc=""
    s itemLocID=$p(^DHCAPREP(arReqID),"^",5)              /// 接收科室ID
    i itemLocID'="" s itemLoc=$p(^CTLOC(itemLocID),"^",2)
    s itemLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",itemLoc,langid)
    i itemLoc["-" s itemLoc=$p(itemLoc,"-",2)
    
    s itemExaPurp=$p(^DHCAPREP(arReqID),"^",20)           /// 检查目的
    s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)	          /// 就诊ID
	s PatType=$p(^PAADM(EpisodeID),"^",2)                 /// 就诊类型
	s AdmHospitalId=##class(DHCDoc.Common.Hospital).GetAdmHospitalId(EpisodeID)
	s AdmHospitalCode=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalCode(AdmHospitalId)
    s Num=0,count=0,OpCellFlag=0
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:CH=""  D
	.s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)        /// 医嘱项目ID
	.Q:arcimid=""
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) /// 医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) /// 医嘱项名称
	.s arcitmdesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcitmdesc,langid)
	.s SpeCode=$p(^DHCAPREP(arReqID,"AR",CH),"^",7)        /// 标本代码   //sufan 2018-02-01
	.s SpecDesc=..GetSpecDesc(SpeCode,AdmHospitalId)
	.s SpecSiteRowid=$p(^DHCAPREP(arReqID,"AR",CH),"^",14) //标本采集部位
	.s SpecSite=""
	.s:SpecSiteRowid'="" SpecSite=##Class(DHCLIS.DHCCommon).GetAnatomicalSite(SpecSiteRowid,AdmHospitalCode) 
	.s ItemQty=$p(^DHCAPREP(arReqID,"AR",CH),"^",15) 		//数量
	.s oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)          /// 医嘱ID
	.i oeori'="" s ItemQty=$p(^OEORD($p(oeori,"||",1),"I",$p(oeori,"||",2),1),"^",12)
	.i oeori'="" s SpecDesc=##class(web.DHCOEOrdItem).GetLabSpec(oeori)
	.s emgFlag=""
	.i oeori'="" s emgFlag=$p(^OEORD($p(oeori,"||",1),"I",$p(oeori,"||",2),"11"),"^",55)	// qunianpeng 加急标志 2018/3/20
	.if emgFlag="" s emgFlag=$p(^DHCAPREP(arReqID),"^",16)
	.if emgFlag="" s emgFlag=$p(^DHCAPREP(arReqID,"AR",CH),"^",10)
	.i emgFlag'="" s emgFlag=$case(emgFlag,"Y":1,"N":0,:0)
	.s Billed=""
	.i oeori'="" s Billed=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),3),"^",5) /// 医嘱计费状态
	./// 是否显示撤销链接
	.i PatType="I" s OpCellFlag=1
	.E  D
	..i Billed="P" s OpCellFlag=1
	.
	.s DispID=##Class(web.DHCAPPExaReportQuery).GetRepDispID(arReqID_"||"_CH) ///后处理ID
	.s DispDesc=##Class(web.DHCAPPExaReportQuery).GetRepDisp(arReqID_"||"_CH) ///后处理
	.s BillType="",BillTypeID=""
	.i oeori'="" s BillTypeID=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),11)),"^",18)
	.if BillTypeID="" s BillTypeID=$P(^PAADM(EpisodeID,1),"^",7) 
	.i BillTypeID'=""  s BillType=$p($g(^PAC("ADMREA",BillTypeID)),"^",2)     /// 费别
	.s BillType=##class(User.PACAdmReason).GetTranByDesc("READesc",BillType,langid)
	.s PartIDList="",PartDescList=""
	.i $o(^DHCAPREP(arReqID,"AR",CH,"PA",""))  D 
	..s Sub=""
	..f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	...s PartID=+$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1) /// 部位ID
	...Q:PartID=0
	...s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				   /// 部位
	...s PartDesc=##class(User.DHCAppPart).GetTranByDesc("APDesc",PartDesc,langid)
	...s ExeStat=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",2) /// 执行状态
	...Q:(oeori="")&&(ExeStat'="V")
	...s ItemStat=$s(ExeStat="V":"核实",ExeStat="E":"执行",ExeStat="D":"停止",1:"")
	...s ItemStat=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc",ItemStat,langid)
	...s ItemXUser=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",5) /// 撤销人
	...s:ItemXUser'="" ItemXUser=$p(^SSU("SSUSR",ItemXUser),"^",2)
	...s ItemXDate=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",3) /// 撤销日期
	...s ItemXTime=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",4) /// 撤销时间
	...i ItemXDate'="" s ItemXDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(ItemXDate)
	...i ItemXTime'="" S ItemXTime=..%ZT(ItemXTime,1)
	...s ItemRemark=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",8) /// 备注
	...s AppendOrderStr=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",9)
	...s AppendOrderStr=##Class(web.DHCAPPExaReport).GetAppendOrderStr(AppendOrderStr)
	...s AppendOrder=$P(AppendOrderStr,"^",1),AppendOrderIDStr=$P(AppendOrderStr,"^",2)
	...s arPartID=arReqID_"||"_CH_"||"_Sub
	...s PosiID=##Class(web.DHCAPPExaReportQuery).GetRepPosiID(arPartID) /// 体位ID
	...s PosiDesc=##Class(web.DHCAPPExaReportQuery).GetRepPosi(arPartID) /// 体位
	...
	.../// 组织检查项目显示名称
	...s ItemLabel=arcitmdesc
	...i DispDesc'="" s ItemLabel=ItemLabel_" + "_DispDesc
	...i PosiDesc'="" D
	....s PartDesc=PartDesc_"("_PosiDesc_")"
	...s ItemLabel=ItemLabel_" ["_PartDesc_"]"
	...i oeori="" s ItemStat="待审核",ItemPrice=##Class(web.DHCAPPInterface).GetExaReqCost(arcimid,PartID_"$$"_PosiID,EpisodeID,DispID,pid)
	...e  d
	....i $o(^DHCAPREP(arReqID,"AR",CH,"PA",""),-1)=1 s ItemPrice=##Class(web.DHCAPPExaReportQuery).GetExaReqPartCost(oeori,""),ItemPrice=$p(ItemPrice,"^",1) //获取折扣后的价格
	....e  s ItemPrice=##Class(web.DHCAPPExaReportQuery).GetExaReqPartCost(oeori,PartID),ItemPrice=$p(ItemPrice,"^",1) //获取折扣后的价格
	...s OrderStageID=$p(^DHCAPREP(arReqID,"AR",CH),"^",12)        /// 医嘱阶段SQ:术前;SZ:术中;SH:术后;CZ:产中
	...s OrderStage=$s(OrderStageID="SQ":"术前",OrderStageID="SZ":"术中",OrderStageID="SH":"术后",OrderStageID="CZ":"产中",OrderStageID="":"",1:"")
	...s OrderStage=##class(websys.Translation).Get("dhcapp.mainframe.csp",OrderStage)
	...s ItemStat=##class(websys.Translation).Get("dhcapp.mainframe.csp",ItemStat)
	...s ListData=arReqID_"^"_arReqID_"||"_CH_"||"_Sub_"^"_arcimid_"^"_ItemLabel_"^"_PosiID_"^"_PartID_"^"_DispID_"^"_itemExaPurp_"^"_itemLocID_"^"_itemLoc_"^"_ItemStat_"^"_Billed_"^"_OpCellFlag_"^"_ItemXUser_"^"_ItemXDate_"^"_ItemXTime_"^"_ItemRemark_"^"_SpeCode_"^"_SpecDesc_"^"_emgFlag_"^"_BillType_"^"_ItemPrice_"^"_oeori_"^"_OrderStageID_"^"_OrderStage_"^"_AppendOrder_"^"_AppendOrderIDStr_"^"_SpecSiteRowid_"^"_SpecSite_"^"_ItemQty
	...
	...s Num=Num+1
	...s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqDetList",pid,Num)=ListData
	.E  D
	..s ItemStat="待审核",ItemXUser="",ItemXDate="",ItemXTime=""
	..i oeori'="" d
	... s ItemStat=..GetOeoriStat(oeori)
	... s ItemStat=$s(ItemStat="V":"核实",ItemStat="E":"执行",ItemStat="D":"停止",ItemStat="C":"停止",ItemStat="U":"停止",1:"")
	... s ord=$p(oeori,"||",1),itm=$p(oeori,"||",2)
	... s ItemXUser=$p(^OEORD(ord,"I",itm,3),"^",29) /// 撤销人
	... s:ItemXUser'="" ItemXUser=$p(^CTPCP(ItemXUser,1),"^",2)
	... s ItemXDate=$p(^OEORD(ord,"I",itm,3),"^",34) /// 撤销日期
	... s ItemXTime=$p($g(^OEORD(ord,"I",itm,2)),"^",15) /// 撤销时间
	... i ItemXDate'="" s ItemXDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(ItemXDate)
	... i ItemXTime'="" S ItemXTime=..%ZT(ItemXTime,1)
	... s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)
	... i (ItemStat="核实")||(ItemStat="执行")||(ItemStat="待审核") s ItemPrice=##Class(web.DHCAPPInterface).GetExaReqCost(arcimid,"",EpisodeID,"",pid)
	... e  s ItemPrice=""
	..e  d
	...s ItemPrice=""
	...s OeorStatus=$p(^DHCAPREP(arReqID,"AR",CH),"^",9) 
	...if (OeorStatus="D") s ItemStat="停止"
	..s ItemRemark=$p(^DHCAPREP(arReqID,"AR",CH),"^",4) /// 备注
	..s ItemLabel=arcitmdesc
	..s OrderStageID=$p(^DHCAPREP(arReqID,"AR",CH),"^",12)        /// 医嘱阶段SQ:术前;SZ:术中;SH:术后;CZ:产中
	..s OrderStage=$s(OrderStageID="SQ":"术前",OrderStageID="SZ":"术中",OrderStageID="SH":"术后",OrderStageID="CZ":"产中",OrderStageID="":"",1:"")
	..s OrderStage=##class(websys.Translation).Get("dhcapp.mainframe.csp",OrderStage)
	..s ItemStat=##class(websys.Translation).Get("dhcapp.mainframe.csp",ItemStat)
	..s ListData=arReqID_"^"_arReqID_"||"_CH_"^"_arcimid_"^"_ItemLabel_"^^^"_DispID_"^"_itemExaPurp_"^"_itemLocID_"^"_itemLoc_"^"_ItemStat_"^"_Billed_"^"_0_"^"_ItemXUser_"^"_ItemXDate_"^"_ItemXTime_"^"_ItemRemark_"^"_SpeCode_"^"_SpecDesc_"^"_emgFlag_"^"_BillType_"^"_ItemPrice_"^"_oeori_"^"_OrderStageID_"^"_OrderStage_"^^^"_SpecSiteRowid_"^"_SpecSite_"^"_ItemQty
	..s Num=Num+1
	..s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqDetList",pid,Num)=ListData
	
	;i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	;q:Num=0 ""
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i Num=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num)) //输出json结尾符
		q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="ItemID^ItemArcID^ItemExaID^ItemLabel^ItemExaPosiID^ItemExaPartID^ItemExaDispID^ItemExaPurp^ItemLocID^ItemLoc^ItemStat^ItemBilled^OpCellFlag^ItemXUser^ItemXDate^ItemXTime^ItemRemark^ItemSpecCode^ItemSpec^ItemEmgFlag^ItemBillType^ItemPrice^oeori^OrderStageID^OrderStage^AppendOrder^AppendOrderIDStr^ItemSpecSiteRowid^ItemSpecSite^ItemQty"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(Num)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqDetList",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqDetList",pid,index))
	.s count=count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript:  其它项目
/// w ##Class(web.DHCAPPExaReportQuery).jsonExaReqOtherOpt("11494||1","1")
ClassMethod jsonExaReqOtherOpt(itmmastid As %String, HospID As %String) As %String
{
	n (itmmastid, HospID)
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s ListTitle="OptiID^OptiDesc^OptiType^OptiRequ"
	s count = 0
	d Stream.Write("[")
	s OptiID=""
	f  s OptiID=$o(^DHCAPARCO(0,"ARC",itmmastid,OptiID)) Q:OptiID=""  D
	.Q:'$d(^DHCAPOTHO(OptiID))
	.Q:(HospID'="")&($p(^DHCAPOTHO(OptiID),"^",5)'=HospID)
	.s OptiCode=$p(^DHCAPOTHO(OptiID),"^",1)  ///代码
	.s OptiDesc=$p(^DHCAPOTHO(OptiID),"^",2)  ///描述
	.s OptiType=$p(^DHCAPOTHO(OptiID),"^",3)  ///类型
	.s OptiRequ=$p(^DHCAPOTHO(OptiID),"^",4)  ///是否必填
	.s ListData=OptiID_"^"_OptiDesc_"^"_OptiType_"^"_OptiRequ
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write("]")
	q Stream.Read()
}

/// w ##Class(web.DHCAPPExaReportQuery).GetExaReqOtherOpt("","2729||1","2")
ClassMethod GetExaReqOtherOpt(pid As %String, itmmastid As %String, HospID As %String) As %String
{
	n (pid, itmmastid, HospID,%session)
	Set langid=..%LanguageID()
	i pid = "" d
	.s pid=..NewPid()
    .d ..killTmpGlobal(pid) //k掉临时global
    
	s itemid=""
	f  s itemid=$o(^DHCAPARCO(0,"ARC",itmmastid,itemid)) Q:itemid=""  D
	.Q:'$d(^DHCAPOTHO(itemid))
	.Q:(HospID'="")&($p(^DHCAPOTHO(itemid),"^",5)'=HospID)
	.s ID=$o(^DHCAPARCO(0,"ARC",itmmastid,itemid,""),-1)
	.s AOMoChoiceDr=$P(^DHCAPARCO(ID),"^",3)
	.s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)  ///描述
	.s itemdesc=##class(User.DHCAppOtherOpt).GetTranByDesc("AODesc",itemdesc,langid)
	.s itemtype=$p(^DHCAPOTHO(itemid),"^",3)  ///类型
	.s itemrequ=$p(^DHCAPOTHO(itemid),"^",4)  ///是否必填
	.s itemval=..getExaOtherOpt(pid, itemid, itemtype)
	.s Subvalue=""
	.if ((itemval="")&&(AOMoChoiceDr'="")) d
	..if itemtype="Check" d
	...s itemval=AOMoChoiceDr
	..if itemtype="Combox" d
	...s itemval=itemid_"||"_AOMoChoiceDr
	..if itemtype="Order" d
	...s Subvalue=AOMoChoiceDr
	.d ..InsExaOtherOpt(pid, itmmastid, itemid, itemdesc, itemtype, itemval,Subvalue)
	.
	s itmCatID=..GetItmCatID(itmmastid,HospID)
	Q:itmCatID="" pid
	s CH=""
	f  s CH=$o(^DHCAPCATO(itmCatID,"O",CH)) Q:CH=""  D
	.s itemid=$p(^DHCAPCATO(itmCatID,"O",CH),"^",1)
	.Q:'$d(^DHCAPOTHO(itemid))
	.Q:(HospID'="")&($p(^DHCAPOTHO(itemid),"^",5)'=HospID)
	.s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)  ///描述
	.s itemdesc=##class(User.DHCAppOtherOpt).GetTranByDesc("AODesc",itemdesc,langid)
	.s itemtype=$p(^DHCAPOTHO(itemid),"^",3)  ///类型
	.s itemrequ=$p(^DHCAPOTHO(itemid),"^",4)  ///是否必填
	.s itemval=..getExaOtherOpt(pid, itemid, itemtype)
	.d ..InsExaOtherOpt(pid, itmmastid, itemid, itemdesc, itemtype, itemval)
	.
	
	q pid
}

/// Descript: 临时存储其他项目
ClassMethod InsExaOtherOpt(pid As %String, itmmastid As %String, id As %String, desc As %String, type As %String, val As %String, OrderVar As %String = "") As %String
{
	n (pid, itmmastid, id, desc, type, val,OrderVar,%session)
	b ;zzdf
	Set langid=..%LanguageID()
	;q:$d(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,type_"^"_id,itmmastid)) ""
	if (type="Order"){
		if (val["||") {
			s arcim=$P(^DHCAPOTHO(+val,"I",$P(val,"||",2)),"^",3)
			s desc=$p(^ARCIM(+arcim,$P(arcim,"||",2),1),"^",2) 
			s desc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",desc,langid)
			s ^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,type_"^"_val,itmmastid)=val_"^"_desc_"^"_type_"^Y"
			q ""
		}else{
			s ^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,type_"^"_id,itmmastid)=id_"^"_desc_"^"_type_"^"_val
			}
		s idsub=""
		for {
			s idsub=$O(^DHCAPOTHO(id,"I",idsub))
			q:idsub=""
			s arcim=$P(^DHCAPOTHO(id,"I",idsub),"^",3)
			continue:arcim=""
			s desc=$p(^ARCIM(+arcim,$P(arcim,"||",2),1),"^",2) 
			s desc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",desc,langid)
			s datefrom=$p($g(^ARCIM(+arcim,1,1)),"^",13)
			s dateto=$p($g(^ARCIM(+arcim,1,7)),"^",1)
			i datefrom>$h continue
			i dateto,dateto<$h continue
			s OrderVal=""
			b ;093345
			if ($g(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,type_"^"_id_"||"_idsub,itmmastid))=""){
				if (OrderVar=idsub){
				s ^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,type_"^"_id_"||"_idsub,itmmastid)=id_"||"_idsub_"^"_desc_"^"_type_"^Y"	
					}else{
				s ^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,type_"^"_id_"||"_idsub,itmmastid)=id_"||"_idsub_"^"_desc_"^"_type_"^"
				}
			}
			}
		}else{
	
	s ^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,type_"^"_id,itmmastid)=id_"^"_desc_"^"_type_"^"_val
	}
	q ""
}

/// Descript: 输出临时存储的其他项目
/// w ##Class(web.DHCAPPExaReportQuery).jsonExaReqTmpOtherOpt("")
ClassMethod jsonExaReqTmpOtherOpt(pid As %String) As %String
{
	n (pid)
	
	s ListTitle="itemid^itemdesc^itemtype^itemval"
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s tmp=""
	f  s tmp=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,tmp)) Q:tmp=""  D
	.s itmid=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,tmp,""))
	.Q:itmid=""
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,tmp,itmid))
	.Q:ListData=""
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.
	d Stream.Write("]")
	q Stream.Read()
}

/// Descript:  保存临时数据
ClassMethod setExaOtherOpt(pid As %String, id As %String, type As %String, val As %String) As %String
{
	n (pid, id, type, val)
	if (id["_") s id=$replace(id,"_","||")
	s itmid=""
	f  s itmid=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,type_"^"_id,itmid)) Q:itmid=""  D
	.s $p(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,type_"^"_id,itmid),"^",4)=val
	.
	q 0
}

/// Descript:  获取临时数据
ClassMethod getExaOtherOpt(pid As %String, id As %String, type As %String) As %String
{
	n (pid, id, type)
	s itmid=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,type_"^"_id,"")) 
	Q:itmid="" ""
	s val=$p(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,type_"^"_id,itmid),"^",4)
	q val
}

/// Descript:  其它项目子项目
/// w ##Class(web.DHCAPPExaReportQuery).jsonOtherOptSubItm("1")
ClassMethod jsonOtherOptSubItm(itemid As %String) As %String
{
	n (itemid)
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s count = 0
	d Stream.Write("[")
	s CH=""
	f  s CH=$o(^DHCAPOTHO(itemid,"I",CH)) Q:CH=""  D
	.s itemdesc=$p(^DHCAPOTHO(itemid,"I",CH),"^",2)  ///描述
	.s ListData=itemid_"||"_CH_"^"_itemdesc
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData))
	d Stream.Write("]")
	q Stream.Read()
}

/// Descript:  检查申请报告其他项目
/// w ##class(web.DHCAPPExaReportQuery).GetExaReqOthOpt(639,23,23)
ClassMethod GetExaReqOthOpt(pid As %String, arReqID As %String, itmmastid As %String) As %String
{
	n (pid, arReqID, itmmastid, %session)
	
	i pid = "" d
	.s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    Set langid=..%LanguageID()
    s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"OT",CH)) Q:CH=""  D
	.s itemid=$p(^DHCAPREP(arReqID,"OT",CH),"^",1)   /// 其他项目ID
	.s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)         /// 描述
	.s itemdesc=##class(User.DHCAppOtherOpt).GetTranByDesc("AODesc",itemdesc,langid)
	.s itemtype=$p(^DHCAPOTHO(itemid),"^",3)         /// 类型
	.s itemval=$p(^DHCAPREP(arReqID,"OT",CH),"^",2)  /// 其他项目值
	.d ..InsExaOtherOpt(pid, itmmastid, itemid, itemdesc, itemtype, itemval)
	
    s HospID=%session.Get("LOGON.HOSPID")
    s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:CH=""  D
	.s ArcimRowId=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)
	.s itemid=""
	.f  s itemid=$o(^DHCAPARCO(0,"ARC",ArcimRowId,itemid)) Q:itemid=""  D
	..Q:'$d(^DHCAPOTHO(itemid))
	..Q:(HospID'="")&($p(^DHCAPOTHO(itemid),"^",5)'=HospID)
	..s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)  ///描述
	..s itemdesc=##class(User.DHCAppOtherOpt).GetTranByDesc("AODesc",itemdesc,langid)
	..s itemtype=$p(^DHCAPOTHO(itemid),"^",3)  ///类型
	..s itemrequ=$p(^DHCAPOTHO(itemid),"^",4)  ///是否必填
	..s itemval=..getExaOtherOpt(pid, itemid, itemtype)
	..d ..InsExaOtherOpt(pid, itmmastid, itemid, itemdesc, itemtype, itemval)
	.	
	.s itmCatID=..GetItmCatID(ArcimRowId)
	.Q:itmCatID=""
	.s CH1=""
	.f  s CH1=$o(^DHCAPCATO(itmCatID,"O",CH1)) Q:CH1=""  D
	..s itemid=$p(^DHCAPCATO(itmCatID,"O",CH1),"^",1)
	..Q:'$d(^DHCAPOTHO(itemid))
	..Q:(HospID'="")&($p(^DHCAPOTHO(itemid),"^",5)'=HospID)
	..s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)  ///描述
	..s itemdesc=##class(User.DHCAppOtherOpt).GetTranByDesc("AODesc",itemdesc,langid)
	..s itemtype=$p(^DHCAPOTHO(itemid),"^",3)  ///类型
	..s itemrequ=$p(^DHCAPOTHO(itemid),"^",4)  ///是否必填
	..s itemval=..getExaOtherOpt(pid, itemid, itemtype)
	..d ..InsExaOtherOpt(pid, itmmastid, itemid, itemdesc, itemtype, itemval)
	
	
	
	
	q pid
}

/// Descript:  删除检查申请报告其他项目临时数据
ClassMethod DelExaReqOthOpt(pid As %String, itmmastid As %String) As %String
{
	n (pid, itmmastid)

	s tmp=""
	f  s tmp=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,tmp)) Q:tmp=""  D
	.s itmid=""
	.f  s itmid=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,tmp,itmid)) Q:itmid=""  D
	..Q:itmid'=itmmastid
	..k ^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid,tmp,itmid)
	.
	Q 0
}

/// Descript:  根据根节点ID获取节点下的检查分类树子节点信息
/// w ##class(web.DHCAPPExaReportQuery).jsonCheckCatByNodeID()
ClassMethod jsonCheckCatByNodeID(id As %String, HospID As %String, PyType As %String = "") As %String
{
	n (id, HospID, PyType)
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s count=0 k TmpArr
	s ID=0
  	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",id,ID)) q:ID=""  d
  	.s Code=$p(^DHCAPPTRA(ID),"^",1)
  	.s Text=$p(^DHCAPPTRA(ID),"^",2)
  	.Q:$p(^DHCAPPTRA(ID),"^",5)'=HospID
  	.Q:(PyType'="")&&(PyType'[$p(^DHCAPPTRA(ID),"^",10))		//增加过滤类型 qunianpeng 2018/2/1
  	.s OrdNum=+$p(^DHCAPPTRA(ID),"^",6)
  	.i OrdNum=0 s OrdNum=Code
  	.s TmpArr(OrdNum,ID)=ID_"^"_Text_"^"_Code
  	.
  	s index=""
  	F  s index=$o(TmpArr(index)) Q:index=""  D
  	.s IDindex=""
  	.F  s IDindex=$o(TmpArr(index,IDindex)) Q:IDindex=""  D
  	..s ID=+$g(TmpArr(index,IDindex))
  	..s Code=$p(^DHCAPPTRA(ID),"^",1)
  	..s Text=$p(^DHCAPPTRA(ID),"^",2)
  	..s count = count+1
	..i count=1 d
	...d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
	..e  d
	...d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
    ..///  是否存在孩子节点
	..s trID=$o(^DHCAPPTRA(0,"LastRowid",ID,""))
	..i trID'="" D
	...d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign())
	..
	..i trID="" d Stream.Write(..GetCheckTreeLeafNote(ID))  ///是否有叶子节点
	..d Stream.Write("}")
	
	/// 如果分类树为空,显示默认根节点
	i count=0 d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign("ROOT","部位树根节点")_"}")
	
	d Stream.Write("]")
  	q Stream.Read()
}

/// Descript:  检查分类树
/// w ##class(web.DHCAPPExaReportQuery).jsonCheckCat()
ClassMethod jsonCheckCat(HospID As %String, LocID As %String) As %String
{
	n (HospID,LocID,%session)	
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	Set langid=..%LanguageID()
	s count=0
	s ID=0
  	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",0,ID)) q:ID=""  d
  	.s Code=$p(^DHCAPPTRA(ID),"^",1)
  	.s Text=$p(^DHCAPPTRA(ID),"^",2)
  	.Q:$p(^DHCAPPTRA(ID),"^",5)'=HospID
  	.q:##class(web.DHCAPPTreeAdd).CheckTreeConfigloc("TreeAdd", ID, HospID, LocID)=0
  	.s OrdNum=+$p(^DHCAPPTRA(ID),"^",6) //显示顺序
  	.i OrdNum=0 s OrdNum="Z"_Code
  	.s TmpArr(OrdNum)=ID_"^"_Text_"^"_Code
  	
  	s index=""
  	F  s index=$o(TmpArr(index)) Q:index=""  D
  	.s ID=+$g(TmpArr(index))
  	.s Code=$p(^DHCAPPTRA(ID),"^",1)
  	.s Text=$p(^DHCAPPTRA(ID),"^",2)
  	.Set Text= ##class(User.DHCAppTreeAdd).GetTranByDesc("TRADesc",Text,langid)
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
	.d Stream.Write(..GetCheckTreeChilden(ID,HospID))
	.d Stream.Write("}")
	d Stream.Write("]")
  	q Stream.Read()
}

///  Descript:	检查分类树孩子节点处理
ClassMethod GetCheckTreeChilden(patlev, HospID) As %String
{
	n (patlev,HospID,%session)
    ///  是否存在孩子节点
    s Stream=##class(%Stream.GlobalCharacter).%New()	
	s ID=$o(^DHCAPPTRA(0,"LastRowid",patlev,""))
	Set langid=..%LanguageID()
	//i ID="" D ..GetCheckTreeLeafNote(patlev)   ///是否有叶子节点
	if ID=""{
		Q Stream.Read()
	}
	s count=0	
	s lev=patlev+1
	///  有孩子节点的初始化时收缩
	//w ","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign()
	d Stream.Write(",""children"":[")
	s ID=""
	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",patlev,ID))  q:ID=""  d
	.s Code=$p(^DHCAPPTRA(ID),"^",1)
	.s Text=$p(^DHCAPPTRA(ID),"^",2)
	.s TRAHospDr=$p(^DHCAPPTRA(ID),"^",5)
  	.Q:TRAHospDr'=HospID
	.s OrdNum=+$p(^DHCAPPTRA(ID),"^",6)
  	.i OrdNum=0 s OrdNum=Code
  	.s TmpArr(OrdNum)=ID_"^"_Text_"^"_Code
  	
  	s index=""
  	F  s index=$o(TmpArr(index)) Q:index=""  D
  	.s ID=+$g(TmpArr(index))
  	.s Code=$p(^DHCAPPTRA(ID),"^",1)
  	.s Text=$p(^DHCAPPTRA(ID),"^",2)
  	.Set Text= ##class(User.DHCAppTreeAdd).GetTranByDesc("TRADesc",Text,langid)
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
	.d Stream.Write(..GetCheckTreeChilden(ID,HospID))
	.d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript:  获取叶子节点
ClassMethod GetCheckTreeLeafNote(TraID) As %String
{
	n (TraID)
	k TreeLeafNote
	K PartSortArr
	///  是否存在孩子节点
	//s CH=$o(^DHCAPPTRA(TraID,"I",""))
	//Q:CH="" ""
	s Stream=##class(%Stream.GlobalCharacter).%New()
	if ('..isExistChildNote(TraID)){
		Q Stream.Read()
	}
	s count=0
	///  有孩子节点的初始化时收缩
	d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign())
	d Stream.Write(",""children"":[")
	s CH=""
	f{
		s CH=$o(^DHCAPPTRA(TraID,"I",CH))
		q:CH=""
		s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
		continue:PartID=""
		continue:'$D(^DHCAPPART(PartID))
		continue:$p(^DHCAPPART(PartID),"^",5)="N"        /// 停用
		s PartDesc=$p(^DHCAPPART(PartID),"^",2)   /// 部位

		continue:$D(TreeLeafNote(PartID))
		s (OrdNum1,OrdNum2,OrdNum3)=0
		s OrdNum3=+$p(^DHCAPPART(PartID),"^",8)
		//
		s APParPDr=$p(^DHCAPPART(PartID),"^",3)
		i +APParPDr'=0 {
			s OrdNum2=+$p(^DHCAPPART(APParPDr),"^",8)
			s APParPDr=$p(^DHCAPPART(APParPDr),"^",3)
			s:+APParPDr'=0 OrdNum1=+$p(^DHCAPPART(APParPDr),"^",8)
		}
		s TreeLeafNote(PartID)=PartDesc
		//s TraItmID=TraID_"||"_CH_"^"_PartID
		//按照部位维护的内容进行排序
		s PartSortArr(OrdNum1,OrdNum2,OrdNum3,PartID)=PartID_"^"_PartDesc_"^"_TraID
	}
	
	s OrdNum1=""
	f {
		s OrdNum1=$O(PartSortArr(OrdNum1))
		q:(OrdNum1="")
		s OrdNum2=""
		f{
		s OrdNum2=$O(PartSortArr(OrdNum1,OrdNum2))
		q:(OrdNum2="")
		s OrdNum3=""
		f{
		s OrdNum3=$O(PartSortArr(OrdNum1,OrdNum2,OrdNum3))
		q:(OrdNum3="")
	      s PartID=""
	      f{
	         s PartID=$O(PartSortArr(OrdNum1,OrdNum2,OrdNum3,PartID))
	         q:(PartID="")
	         s Str=PartSortArr(OrdNum1,OrdNum2,OrdNum3,PartID)
	         s PartID=$P(Str,"^",1)
	         s PartDesc=$P(Str,"^",2)
	         s TraID=$P(Str,"^",3)
	         s TraItmID=TraID_"^"_PartID
	         
	         s count = count+1
	         i count=1 {
	            d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(TraItmID,PartDesc))
	         }else{
	            d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(TraItmID,PartDesc))
	         }
	         d Stream.Write("}")
	      }
		}
		}
	}
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript: 是否有孩子节点
ClassMethod isExistChildNote(TraID As %String) As %String
{
	n (TraID)
	s QuitFlag=0
	s CH=""
	f  s CH=$o(^DHCAPPTRA(TraID,"I",CH)) Q:(CH="")||(QuitFlag=1)  D
	.s PartID=+$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	.Q:PartID=0
	.s QuitFlag=1
	Q QuitFlag
}

/// Descript: 医嘱项列表
/// w ##Class(web.DHCAPPExaReportQuery).QueryCheckItemList("30","1","11^185")
ClassMethod QueryCheckItemList(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params)
	s ^tempqujian("QueryCheckItemList")=rows_","_page_","_params
	s End = page*rows
	s Start=(page-1)*rows+1

    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    s TraID=+$p(params,"^",1)  /// 主表ID
    s PartID=$p(params,"^",2)  /// 部位ID
    i PartID="" s ExaItmCode=$p(params,"^",3)  /// 拼音码
    E  s ExaItmCode=$p(params,"^",4)  /// 拼音码
	if ExaItmCode="" s ExaItmCode=$p(params,"^",3)  
	s h=0,count=0
	s CH=""
	//f  s CH=$o(^DHCAPPTRA(0,"Part",PartID,TraID,CH)) q:CH=""  d
	f  s CH=$o(^DHCAPPTRA(TraID,"I",CH)) q:CH=""  d
	.s itempartid=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)    //部位
	.Q:(PartID'="")&(itempartid'=PartID)
	.s itempartdesc=$p($g(^DHCAPPART(+itempartid)),"^",2)   //部位描述
	.s arcimid=$p(^DHCAPPTRA(TraID,"I",CH),"^",2)
	.Q:$d(itmmastid(arcimid))
	.s itmmastid(arcimid)=""
	.Q:'..isConItemCode(arcimid,ExaItmCode)
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcEndDate=$p(^ARCIM(itmmastid,itmmastver,7),"^",1)  //sufan 2018-11-21 判断医嘱是否可用
	.Q:(arcEndDate'="")&&(arcEndDate<+$H)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  //医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  //医嘱项名称
	.s itemprice=##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcimid,+$h,"","","","")
	.s itemprice=+$p(itemprice,"^") 					    //医嘱项价格
	.i $p(itemprice,".")="" s itemprice=0_itemprice         //小于0的价格前补0
	.s itemOrdNum=+$p(^DHCAPPTRA(TraID,"I",CH),"^",5)
	.if itemOrdNum="0" s itemOrdNum=CH
	.s h=h+1
	.s ItemToothFlagCode=$p(^DHCAPPTRA(TraID,"I",CH),"^",6)
	.s ItemToothFlag=$s(ItemToothFlagCode="Y":"是",ItemToothFlagCode="N":"否",ItemToothFlagCode="":"否")
	.s ListData=TraID_"^"_TraID_"||"_CH_"^"_arcimid_"^"_arcitmcode_"^"_arcitmdesc_"^"_itemprice_"^"_itempartid_"^"_itempartdesc_"^"_itemOrdNum_"^"_ItemToothFlagCode_"^"_ItemToothFlag
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryCheckItemList",pid,itemOrdNum)=ListData
	
	;i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	;q:h=0 ""
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="TraID^TraItmID^ItemID^ItemCode^ItemDesc^ItemPrice^ItemPartID^ItemPart^ItemOrdNum^ItemToothFlagCode^ItemToothFlag"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryCheckItemList",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryCheckItemList",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript: 检查医嘱项目是否含有对应拼音别名码
ClassMethod isConItemCode(itmmastid As %String, ItmCode As %String) As %String
{
	n (itmmastid, ItmCode)
	Q:ItmCode="" 1
	s ItmCode=$$ALPHAUP^SSUTIL4(ItmCode)
	s ArcimDesc=$P(^ARCIM(+itmmastid,$p(itmmastid,"||",2),1),"^",2)
	if ($$ALPHAUP^SSUTIL4(ArcimDesc)[ItmCode){
		q 1
	}
	s quitflag=0
	s ID=""
	f  s ID=$o(^ARC("ALIAS",0,"ARCIM",itmmastid,ID)) Q:(ID="")||(quitflag=1)  D 
	.s text=$p(^ARC("ALIAS",ID),"^",6)
	.Q:text'[ItmCode
	.s quitflag=1
    q quitflag
}

/// Descript: 获取检查申请现病史和体征
ClassMethod jsonExaReqHisSign(arReqID As %String, EpisodeID As %String) As %String
{
	n (arReqID, EpisodeID)
	
	/// 根据申请取病人现病史.申请ID为空时,默认取病人上次检查申请的现病史内容
	s arExaReqHis=""
	i arReqID'="" d    
	.s arExaReqHisID=$o(^DHCAPPREH(0,"REQ",arReqID,""))
	E  d
	.s arExaReqHisID=$o(^DHCAPPREH(0,"ADM",EpisodeID,""),-1)
	i arExaReqHisID '= "" d
	.s arExaReqHis=$g(^DHCAPPREH(arExaReqHisID,"History"))         /// 现病史
	
	/// 根据申请取病人体征.申请ID为空时,默认取病人上次检查申请的体征内容
	s arExaReqSig=""
	i arReqID'="" d    
	.s arExaReqSigID=$o(^DHCAPPATSI(0,"REQ",arReqID,""))
	E  d
	.s arExaReqSigID=$o(^DHCAPPATSI(0,"ADM",EpisodeID,""),-1)
	i arExaReqSigID '= "" d
	.s arExaReqSig=$g(^DHCAPPATSI(arExaReqSigID,"Sings"))         /// 体征
	
	/// 根据申请取病人体征.申请ID为空时,默认取病人上次检查申请的体征内容
	s arExaReqSym=""
	i arReqID'="" d    
	.s arExaReqSymID=$o(^DHCAPPATSY(0,"REQ",arReqID,""))
	E  d
	.s arExaReqSymID=$o(^DHCAPPATSY(0,"ADM",EpisodeID,""),-1)
	i arExaReqSymID '= "" d
	.s arExaReqSym=$G(^DHCAPPATSY(arExaReqSymID,"Symptom"))        /// 主诉
	
	s PatType=$p(^PAADM(EpisodeID),"^",2)  /// 病人类型
	
	if (PatType="I"){
		//优先从入院记录中取值
		s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.13.01")
		//主诉
		i arExaReqSym="" s arExaReqSym = obj.GetAt("HDSD00.13.114")
		//现病史
		i arExaReqHis="" s arExaReqHis = obj.GetAt("HDSD00.13.095")
		//体格检查
		i arExaReqSig="" s arExaReqSig = obj.GetAt("HDSD00.13.094")
		if (arExaReqSym="")&&(arExaReqHis="")&&(arExaReqSig=""){
			//其次从【24h内入出院记录】中取值；
			s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.13.02")
			s arExaReqSym = obj.GetAt("HDSD00.13.114")
			s arExaReqHis = obj.GetAt("HDSD00.13.095")
			s arExaReqSig = obj.GetAt("HDSD00.13.094")
		}
		if (arExaReqSym="")&&(arExaReqHis="")&&(arExaReqSig=""){
			//其次从【24h内入院死亡记录】中取值；
			s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.13.03")
			s arExaReqSym = obj.GetAt("HDSD00.13.114")
			s arExaReqHis = obj.GetAt("HDSD00.13.095")
			s arExaReqSig = obj.GetAt("HDSD00.13.094")
		}
		s status=$p(^PAADM(EpisodeID),"^",20)
		if (status="P") {
			if (arExaReqSym="")&&(arExaReqHis="")&&(arExaReqSig=""){
				s BookID=$O(^DHCDocIPBK(0,"EpisodeIDTo",EpisodeID,0))
				if (BookID'=""){
				s EpisodeIDFrom=$p(^DHCDocIPBK(BookID),"^",2)
				//优先从【门(急)诊病历】中取值；
				s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeIDFrom,"HDSD00.03.01")
				//主诉
				i arExaReqSym="" s arExaReqSym = obj.GetAt("HDSD00.03.057")
				//现病史
				i arExaReqHis="" s arExaReqHis = obj.GetAt("HDSD00.03.038")
				//体格检查
				i arExaReqSig="" s arExaReqSig = obj.GetAt("HDSD00.03.037")
				}
			}
			}
	}else{
		//优先从【门(急)诊病历】中取值；
		s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.03.01")
		//主诉
		i arExaReqSym="" s arExaReqSym = obj.GetAt("HDSD00.03.057")
		//现病史
		i arExaReqHis="" s arExaReqHis = obj.GetAt("HDSD00.03.038")
		//体格检查
		i arExaReqSig="" s arExaReqSig = obj.GetAt("HDSD00.03.037")
		if (arExaReqSym="")&&(arExaReqHis="")&&(arExaReqSig=""){
			//其次从【急诊留观病历】中取值；
			s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.03.02")
			
			s arExaReqSym = obj.GetAt("HDSD00.03.057")
			s arExaReqHis = obj.GetAt("HDSD00.03.038")
			s arExaReqSig = obj.GetAt("HDSD00.03.037")
		}
	}
	s ListData=arExaReqHis_$C(4)_arExaReqSig_$C(4)_arExaReqSym
	
	s ListTitle="arExaReqHis"_$C(4)_"arExaReqSig"_$C(4)_"arExaReqSym"
	s Json=##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData,$C(4))
	q Json
}

/// Descript: 预约详情
/// W ##Class(web.DHCAPPExaReportQuery).QueryExaReqAppList("30","1","252")
ClassMethod QueryExaReqAppList(rows As %String, page As %String, arReqID As %String) As %String
{
	n (rows, page, arReqID)

	s End = page*rows
	s Start=(page-1)*rows+1

    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s h=0,count=0
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:CH=""  D
	.s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)          /// 医嘱项ID
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)   /// 医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)   /// 医嘱项名称
	.s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)     	     /// 医嘱ID
	.Q:##Class(web.DHCAPPInterface).IsOpenBookWin(Oeori)'="Y"
	.i $o(^DHCAPREP(arReqID,"AR",CH,"PA","")) D
	..s Sub=""
	..f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	...s PartID=$p(^DHCAPREP(arReqID,"AR",CH,"PA",Sub),"^",1)  ///部位ID
	...Q:PartID=""
	...s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				  ///部位代码
	...s h=h+1
	...s ListData=##Class(web.DHCAPPInterface).GetItemAppStatus(Oeori,PartID)
	...s ListData=ListData_"^"_PartDesc_"^"_arcitmdesc
	...s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqAppList",pid,h)=ListData
	.E  D
	..s h=h+1
	..s ListData=##Class(web.DHCAPPInterface).GetItemAppStatus(Oeori,"")
	..s ListData=ListData_"^"_""_"^"_arcitmdesc
	..s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqAppList",pid,h)=ListData
	
	;i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	;q:h=0 ""
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="ItemStatus^ItemDate^ItemTime^ItemMach^PartDesc^ItemLabel"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqAppList",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqAppList",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript: 根据医嘱项获取部位树
/// w ##Class(web.DHCAPPExaReportQuery).jsonGetPartTreeByArc("2727||1","","19","2")
ClassMethod jsonGetPartTreeByArc(itmmastid As %String, PyCode As %String, TraID As %String, HospID As %String) As %String
{
	n (itmmastid, PyCode, TraID, HospID, %session)
	s itmmastid=$REPLACE(itmmastid,"_","||")
	s PyCode=$$ALPHAUP^SSUTIL4(PyCode)
	s count = 0
#;	w "["
#;	w ##class(web.DHCAPPJsonCommon).getJsonTreeStartSign("ROOT","可选部位")
#;	i +TraID = 0 D
#;	.d ..GetPartTreeChildenByArcNoTarID(itmmastid,PyCode,HospID)
#;	.d ..GetPartTreeChildByArcNoTarIDNew(itmmastid,PyCode,HospID)
#;	E  D
#;	.d ..GetPartTreeChildenByArc(itmmastid,TraID,PyCode)
#;	.d ..GetPartTreeChildByArcNew(itmmastid,TraID,PyCode)
#;	d ..GetPartTreeAddCat(itmmastid,PyCode)
#;	w "}"
#;	w "]"
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i +TraID = 0 D
	.d Stream.Write(..GetPartTreeChildByArcNoTarIDNew(itmmastid,PyCode,HospID))
	E  D
	.d Stream.Write(..GetPartTreeChildByArcNew(itmmastid,TraID,PyCode))
  	q Stream.Read()
}

/// Descript: 根据医嘱项获取子部位对应上级分类
ClassMethod GetPartTreeAddCat(itmmastid As %String, PyCode As %String) As %String
{
	n (itmmastid,PyCode)
	s Stream=##class(%Stream.GlobalCharacter).%New()
    ///  是否存在孩子节点
    s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,""))
	if TraID=""{
		Q Stream.Read()	
	}
	s count=0
	d Stream.Write(",""children"":[")
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID)) q:TraID=""  d
	.s Text=$p(^DHCAPPTRA(TraID),"^",2)
	.Q:'..CheckTreeLeafNodeByArcPyCode(TraID,PyCode,itmmastid)
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(TraID,Text))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(TraID,Text))
	.d Stream.Write(..GetPartTreeChildenByArc(itmmastid,TraID,PyCode))
	.d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript:  检查叶子节点是否包含别名
ClassMethod CheckTreeLeafNodeByArcPyCode(TraID, PyCode, itmmastid) As %String
{
	n (TraID,PyCode,itmmastid)
	s isExistFlag=0
	s CH=""
	f  s CH=$o(^DHCAPPTRA(TraID,"I",CH)) q:(CH="")||(isExistFlag=1)  d
	.s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	.Q:+PartID=0
	.Q:'$D(^DHCAPPART(PartID))
	.Q:$p(^DHCAPPTRA(TraID,"I",CH),"^",2)'=itmmastid
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2)   /// 部位
	.s PartAlias=$p(^DHCAPPART(PartID),"^",9)  /// 别名
	.Q:(PartDesc'[PyCode)&(PartAlias'[PyCode)
	.s isExistFlag=1
	.
	Q isExistFlag
}

/// Descript: 根据医嘱项获取部位树
ClassMethod GetPartTreeChildenByArc(itmmastid As %String, TraID As %String, PyCode As %String) As %String
{
	n (itmmastid,TraID,PyCode)
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s count=0
	d Stream.Write(",""children"":[")
	s CH=""
	f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) q:CH=""  d
	.s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	.Q:+PartID=0
	.Q:'$D(^DHCAPPART(PartID))
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2)    /// 部位
	.Q:$p(^DHCAPPART(PartID),"^",5)="N"         /// 停用
	.s PartAlias=$p(^DHCAPPART(PartID),"^",9)   /// 别名
	.Q:(PartDesc'[PyCode)&(PartAlias'[PyCode)
	.Q:$D(TreeLeafNote(PartID))
	.s TreeLeafNote(PartID)=PartDesc
	.
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(PartID,PartDesc))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(PartID,PartDesc))
	.d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript: 根据医嘱项获取部位树
ClassMethod GetPartTreeChildenByArcNoTarID(itmmastid As %String, PyCode As %String, HospID As %String) As %String
{
	n (itmmastid,PyCode,HospID)
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s count=0
	d Stream.Write(",""children"":[")
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID)) q:TraID=""  d
	.Q:$p(^DHCAPPTRA(TraID),"^",5)'=HospID
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) q:CH=""  d
	..s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	..Q:+PartID=0
	..Q:'$D(^DHCAPPART(PartID))
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2)    /// 部位
	..Q:$p(^DHCAPPART(PartID),"^",5)="N"         /// 停用
	..s PartAlias=$p(^DHCAPPART(PartID),"^",9)   /// 别名
	..Q:(PartDesc'[PyCode)&(PartAlias'[PyCode)
	..Q:$D(TreeLeafNote(PartID))
	..s TreeLeafNote(PartID)=PartDesc
	..
	..s count = count+1
	..i count=1 d
	...d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(PartID,PartDesc))
	..e  d
	...d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(PartID,PartDesc))
	..d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript: 病人历次就诊记录
/// w ##Class(web.DHCAPPExaReportQuery).jsonPatAdmHisList("30","1","1507")
ClassMethod jsonPatAdmHisList(rows As %String, page As %String, EpisodeID As %String, HospId As %String) As %String
{
	n (rows, page, EpisodeID,HospId,%session)
	Set langid=..%LanguageID()
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s End = page*rows
	s Start=(page-1)*rows+1
	
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	s PatientID=$p(^PAADM(EpisodeID),"^",1)      /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s h=0,count=0
	s PatType=""
	f  s PatType=$o(^PAPERdr(PatientID,"ADM",PatType)) Q:PatType=""  D
	.s EpisodeID=""
	.f  s EpisodeID=$o(^PAPERdr(PatientID,"ADM",PatType,EpisodeID)) Q:EpisodeID=""  D
	..s AdmDate=$p(^PAADM(EpisodeID),"^",6)  //就诊日期
	..s AdmTime=$p(^PAADM(EpisodeID),"^",7)  //就诊时间
	..i AdmDate'="" S AdmDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(AdmDate) //hxy $zd(AdmDate,3)
	..i AdmTime'="" S AdmTime=..%ZT(AdmTime,1)
	..s AdmLoc=""
	..s AdmLocID=$p(^PAADM(EpisodeID),"^",4)     /// 科室
	..s:AdmLocID'="" AdmLoc=$p(^CTLOC(AdmLocID),"^",2)
	..s AdmLoc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",AdmLoc,langid)
	..s DeptHospDt=$p(^CTLOC(AdmLocID),"^",22)
	..Q:(DeptHospDt'=HospId)
	..s AdmDoc=""
	..s AdmDocID=$p(^PAADM(EpisodeID),"^",9)     /// 医生
	..s:AdmDocID'="" AdmDoc=$p($g(^CTPCP(AdmDocID,1)),"^",2)
	..Set AdmDoc= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",AdmDoc,langid)
	..s PatDiag=##class(DHCDoc.Diagnos.Common).GetAdmDiagDesc(EpisodeID) ;##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",") /// 诊断
	..s h=h+1
	..s itmLabel=AdmDate_" "_AdmLoc_" "_AdmDoc_" "_PatDiag
	..s ListData=EpisodeID_"^"_itmLabel_"^"_AdmDate_"^"_AdmTime_"^"_PatNo_"^"_PatName_"^"_AdmLoc_"^"_AdmDoc_"^"_PatDiag
	..s ^TMP("DHCST","web.DHCAPPExaReportQuery","jsonPatAdmHisList",pid,h)=ListData
	.
	
	;i h=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(h) //输出json结尾符
	;q:h=0 ""
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="EpisodeID^itmLabel^AdmDate^AdmTime^PatNo^PatName^AdmLoc^AdmDoc^PatDiag"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","jsonPatAdmHisList",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","jsonPatAdmHisList",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript: 获取检查申请项目总费用
/// Input:     mListData=申请ID^就诊ID#医嘱项目ID^体位ID^部位ID^后处理ID&&医嘱项目ID^体位ID^部位ID^后处理ID
/// w ##Class(web.DHCAPPExaReportQuery).GetExaReqItmCost("^112^86161#2561||1^^185^")
ClassMethod GetExaReqItmCost(ListData As %String) As %String
{
	n (ListData)

	s ExaReqCost=0    /// 总金额
	s mListData=$p(ListData,"#",1)    /// 主信息
	s aListData=$p(ListData,"#",2)    /// 项目信息
	s arReqID=$p(mListData,"^",1)     /// 检查申请ID
	s EpisodeID=$p(mListData,"^",2)   /// 就诊ID
	s IPid=$p(mListData,"^",3)        /// 进程号
	/// k 掉临时数据
	i IPid'="" k ^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",IPid)
	
	i arReqID'="" D
	.s CH=""
	.f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:CH=""  D
	..s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)   /// 医嘱ID
	..Q:Oeori=""
	..;tanjishan
	..s StatusCode=##class(appcom.OEOrdItem).GetStatusCode(Oeori)
	..q:("VE"'[StatusCode)
	..s itmCostStr=##Class(web.DHCAPPInterface).GetExaReqPartCost(Oeori,"",IPid)
	..s itmCost=$p(itmCostStr,"^",1)
	..s ExaReqCost=ExaReqCost+itmCost
	.
	
	Q:ExaReqCost'=0 ExaReqCost
	
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
	f i=1:1:$L(aListData,"&&")  d
	.s arcListData=$p(aListData,"&&",i)
	.s arItmmastID=$p(arcListData,"^",1)   /// 医嘱项ID
	.s arPosiID=$p(arcListData,"^",2)      /// 体位
	.s arPartID=$p(arcListData,"^",3)      /// 部位
	.s arDispList=$p(arcListData,"^",4)    /// 后处理
	.s uniqueID=$p(arcListData,"^",6)      /// 唯一标识
	.s index=arItmmastID_"^"_arDispList_"^"_uniqueID
	.i arPartID["$$" s index2=$TR(arPartID,"@","^")
	.E  s index2=arPartID_"$$"_arPosiID
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","GetExaReqItmCost",pid,index)=""
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","GetExaReqItmCost",pid,index,index2)=""
	s ListData=""
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","GetExaReqItmCost",pid,index)) Q:index=""  D
	.s itmmmastid=$p(index,"^",1)    /// 医嘱项ID
	.s itemExaDispID=$p(index,"^",2) /// 后处理ID
	.s itemExaPartID=""
	.s index2=""
	.f  s index2=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","GetExaReqItmCost",pid,index,index2)) Q:index2=""  D
	..i itemExaPartID="" s itemExaPartID=index2
	..E  s itemExaPartID=itemExaPartID_"^"_index2
	.s itmCost=##Class(web.DHCAPPInterface).GetExaReqCost(itmmmastid,itemExaPartID,EpisodeID,itemExaDispID,IPid)
	.s ExaReqCost=ExaReqCost+itmCost
	
	d ..killTmpGlobal(pid) //k掉临时global
	Q ExaReqCost
}

/// Descript:  收费项目价格
/// w ##Class(web.DHCAPPExaReportQuery).GetTarItmCost("2","1633")
ClassMethod GetTarItmCost(TarID As %String, EpisodeID As %String) As %String
{
	n (TarID, EpisodeID)
	s PatType=$P($g(^PAADM(EpisodeID,1)),"^",6)
	s InsType=$P($g(^PAADM(EpisodeID,1)),"^",7)
	s itmPriceExpStr=""_"^"_""_"^"_""_"^"_EpisodeID_"^"_""_"^"_""
	s itmprice=##CLASS(UDHCJFPRICE).GetItmPrice(+TarID,+$H,InsType,PatType,"","","")
	s itmprice=+$p(itmprice,"^") 					//医嘱项价格
	i $p(itmprice,".")="" s itmprice=0_itmprice  //小于0的价格前补0
	Q itmprice
}

/// Descript: 申请单项目医嘱分类对应检查分类代码
/// w ##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat("12763")
ClassMethod GetExaReqItmCat(arReqID As %String, aFlag As %String = "", HospID As %String = "") As %String
{
	n (arReqID, aFlag, HospID,%session)
	Set langid=..%LanguageID()
	s CH=$o(^DHCAPREP(arReqID,"AR",""))
	Q:CH="" ""
	s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)         ///医嘱项目ID
	Q:arcimid="" ""
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s itemCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)   ///医嘱子类
	s itmArcCatID=$O(^DHCAPARCCA(0,"Arc",arcimid,""))
	i itmArcCatID="" {
		for{
			s itmArcCatID=$o(^DHCAPARCCA(0,"O",itemCatID,itmArcCatID))
			q:itmArcCatID=""
			q:$p(^DHCAPARCCA(itmArcCatID),"^",4)=HospID
		}
	}
	b ;;09323
	Q:itmArcCatID="" ""
	;Q:(HospID'="")&($p(^DHCAPARCCA(itmArcCatID),"^",4)'=HospID) ""
	//s itmArcCatID=$o(^DHCAPARCCA(0,"Cat",itemCatID,""))
	Q:itmArcCatID="" ""
	s itmArcCatCode=$p(^DHCAPARCCA(itmArcCatID),"^",1)  	/// 检查分类代码
	s itmArcCatDesc=$p(^DHCAPARCCA(itmArcCatID),"^",2)  	/// 检查分类描述
	Set itmArcCatDesc= ##class(User.DHCAppArcCat).GetTranByDesc("ACCatDesc",itmArcCatDesc,langid)
	Q:aFlag=1 itmArcCatDesc
	Q itmArcCatCode
}

/// Descript: 取检查项目对应的检查分类
/// w ##Class(web.DHCAPPExaReportQuery).GetItmCatID("")
ClassMethod GetItmCatID(arcimid As %String, HospID As %String = "") As %String
{
	n (arcimid,HospID)
	if (HospID="")&&($d(%session)) {
		s HospID=%session.Get("LOGON.HOSPID")
	}
	Q:arcimid="" ""
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s itmArcCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)   ///医嘱子类
	s itmCatID=0,findItmCatID=""
	for {
		s itmCatID=$o(^DHCAPARCCA(0,"O",itmArcCatID,itmCatID)) Q:(itmCatID="")||(findItmCatID'="")
		s HospDr=$p(^DHCAPARCCA(itmCatID),"^",4)
		continue:(HospDr'=HospID)&&(HospID'="")
		s findItmCatID=itmCatID
	}
	if (findItmCatID="") {
		s itmCatID=0
		for {
			s itmCatID=$o(^DHCAPARCCA(0,"Arc",arcimid,itmCatID)) Q:(itmCatID="")||(findItmCatID'="")
			s HospDr=$p(^DHCAPARCCA(itmCatID),"^",4)
			continue:(HospDr'=HospID)&&(HospID'="")
			s findItmCatID=itmCatID
		}
	}
	Q findItmCatID
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	//Q $I(^DHCAPP("APPExaReportQuery"))
	Q ##Class(web.DHCAPPExaRepCom).NewPid()
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	N (pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","GetCheckMethodList",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryCheckItemList",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","InsExaOtherOpt",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqAppList",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqDetList",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","jsonPatAdmHisList",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","GetExaReqItmCost",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryExaReqHisList",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","jsonPart",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPartItmList",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryCheckPartList",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySymPublicFormat",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySymPersonalFormat",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPrehisPublicFormat",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPrehisPersonalFormat",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySignPublicFormat",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySignPersonalFormat",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPurPublicFormat",pid)
	k ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPurPersonalFormat",pid)
	q ""
}

/// Descript: 根据医嘱项获取后处理方法
/// w ##Class(web.DHCAPPExaReportQuery).jsonGetDispTreeByArc("2738||1")
ClassMethod jsonGetDispTreeByArc(itmmastid As %String) As %String
{
	n (itmmastid)
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign("ROOT",""))
	d Stream.Write(..GetPartDispChildenByArc(itmmastid))
	d Stream.Write("}")
	d Stream.Write("]")
  	q Stream.Read()
}

/// Descript: 根据医嘱项获取后处理方法
ClassMethod GetPartDispChildenByArc(itmmastid As %String) As %String
{
	n (itmmastid)
    ///  是否存在孩子节点
    s ALDID=$o(^DHCAPARCDI(0,"Arc",itmmastid,""))
	Q:ALDID="" ""
	s count=0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	///  有孩子节点的初始化时收缩
	/// w ","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign()
	d Stream.Write(",""children"":[")
	s ALDID=0
	f  s ALDID=$o(^DHCAPARCDI(0,"Arc",itmmastid,ALDID)) Q:ALDID=""  D
	.s DispMID=$p(^DHCAPARCDI(ALDID),"^",2)
	.Q:'$d(^DHCAPDIM(DispMID))
	.;Q:$p(^DHCAPDIM(DispMID),"^",3)'="Y"
	.s DispMCode=$p(^DHCAPDIM(DispMID),"^",1)  ///后处理方法代码
	.s DispMDesc=$p(^DHCAPDIM(DispMID),"^",2)  ///后处理方法描述
	.Q:$D(TreeLeafNote(DispMID))
	.s TreeLeafNote(DispMID)=DispMDesc
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(DispMID,DispMDesc))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(DispMID,DispMDesc))
	.d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript: 医嘱执行状态
ClassMethod GetOeoriStat(oeori As %String) As %String
{
	n (oeori,%session)
	Q:oeori="" ""
	q:+oeori=0 ""
	s ItemStatID=$p($g(^OEORD(+oeori,"I",$p(oeori,"||",2),1)),"^",13)
	Q:ItemStatID="" ""
	s ExeStatCode=$p(^OEC("OSTAT",ItemStatID),"^",1)
	Q ExeStatCode
}

/// Descript:  通过医嘱ID获取检查申请内容(PAC预览使用)
/// Input:     oeori-医嘱ID
/// w ##Class(web.DHCAPPExaReportQuery).GetExaReqHtmlContent("","APP20160811064")
ClassMethod GetExaReqHtmlContent(arReqID As %String, arExaReqNo As %String) As %String
{
	n (arReqID, arExaReqNo)
	
	i arReqID="" s arReqID=$o(^DHCAPREP(0,"ARNo",arExaReqNo,""))
	Q:arReqID="" ""
	s HtmlContent=##Class(web.DHCAPPInterface).GetExaReqHtmlContentCT(arReqID)
	Q HtmlContent
}

/// Descript:  收费项目明细
/// w ##Class(web.DHCAPPExaReportQuery).QueryExaReqTarList("30","1","2755||1^^213524")
ClassMethod QueryExaReqTarList(rows As %String, page As %String, param As %String) As %String
{
	n (rows, page, param, %session)

	s End = page*rows
	s Start=(page-1)*rows+1
	Set langid=..%LanguageID()
	s itmmastid=$p(param,"^",1)  /// 医嘱项目ID
	s mPartID=$p(param,"^",2)    /// 部位ID
	s pid=$p(param,"^",3)        /// 进程号
	s itmmastidsub=$p(param,"^",4)  /// 医嘱项目ID
	if ((itmmastidsub'="")&&(mPartID="")) s itmmastid=itmmastidsub
	s index=itmmastid_"^"_+mPartID
	/// 不存在项目返回空值
	//s index1=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid,index,""))
	//i index1="" w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出json结尾符
	//q:index1="" ""

	/// 后处理项目费用
	s index1=""
	f  s index1=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid,itmmastid_"^"_0,index1)) Q:index1=""  D
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid,itmmastid_"^"_0,index1))
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid,index,index1)=ListData
	s Stream=##class(%Stream.GlobalCharacter).%New()
	S del=""""
	s count=0
	s ListTitle="TarID^TarCost^TarDiscCost^TarQty^TarPrice^TarCode^TarDesc"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartNoTotal()) //输出json前缀串
	s TarCost=0,TarDiscCost=0
	F i=1:1:$L(mPartID,"@") D
	.s index=itmmastid_"^"_+$p(mPartID,"@",i) 
	.s index1=""
	.F  s index1=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid,index,index1)) Q:index1=""  D
	..s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid,index,index1))
	..Q:ListData=""
	..s TarID=$p(ListData,"^",1)  /// 收费项目ID
	..s TarCost=TarCost+$p(ListData,"^",2)          /// 收费项目合计
	..s TarDiscCost=TarDiscCost+$p(ListData,"^",3)  /// 收费项目折后合计
	..s TarCode=$p(^DHCTARI(TarID),"^",1) /// 收费项代码
	..s TarDesc=$p(^DHCTARI(TarID),"^",2) /// 收费项描述
	..s TarDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc",TarDesc,langid)
	..s ListData=ListData_"^"_TarCode_"^"_TarDesc
	..s count = count+1
	..q:(count<Start)||(count>End)
	..I count=Start d
	...d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	..e  d
	...d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	..
	if count>0{
		d Stream.Write(",")	
	}
	/// 增加合计
	s ListData="^"_TarCost_"^"_TarDiscCost_"^^^"_##class(websys.Translation).Get("dhcapp.reportreq.csp","合计：")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndConTotal(count+1)) //输出json结尾符
	Q Stream.Read()
}

ClassMethod SumExaReqTarList(param As %String) As %String
{
	n (param)
	s ^tempqujian("SumExaReqTarList")=param
	
	s itmmastid=$p(param,"^",1)  /// 医嘱项目ID
	s mPartID=$p(param,"^",2)    /// 部位ID
	s pid=$p(param,"^",3)        /// 进程号
	
	s index=itmmastid_"^"_+mPartID
	/// 不存在项目返回空值
	//s index1=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid,index,""))
	//i index1="" w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出json结尾符
	//q:index1="" ""

	/// 后处理项目费用
	s index1=""
	f  s index1=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid,itmmastid_"^"_mPartID,index1)) Q:index1=""  D
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid,itmmastid_"^"_mPartID,index1))
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid,index,index1)=ListData
	S del=""""
	s count=0
	s TarCost=0,TarDiscCost=0
	F i=1:1:$L(mPartID,"@") D
	.s index=itmmastid_"^"_+$p(mPartID,"@",i) 
	.s index1=""
	.F  s index1=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid,index,index1)) Q:index1=""  D
	..s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","GetCostDetail",pid,index,index1))
	..Q:ListData=""
	..s TarID=$p(ListData,"^",1)  /// 收费项目ID
	..s TarCost=TarCost+$p(ListData,"^",2)          /// 收费项目合计
	..s TarDiscCost=TarDiscCost+$p(ListData,"^",3)  /// 收费项目折后合计
	..s TarCode=$p(^DHCTARI(TarID),"^",1) /// 收费项代码
	..s TarDesc=$p(^DHCTARI(TarID),"^",2) /// 收费项描述
	q TarDiscCost
}

/// Descript:  检查分类树
/// w ##class(web.DHCAPPExaReportQuery).jsonCheckCatByPyCode("泌尿系")
ClassMethod jsonCheckCatByPyCode(PyCode As %String, HospID As %String, PyType As %String = "", LocID As %String = "") As %String
{
	n (PyCode, HospID,PyType,LocID,%session)
	s PyCode=$$ALPHAUP^SSUTIL4(PyCode)
	s count = 0
	Set langid=..%LanguageID()
	s Stream=##class(%Stream.GlobalCharacter).%New() 
	d Stream.Write("[")
	s count=0 k TmpArr
	s ID=0
  	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",0,ID)) q:ID=""  d
  	.s Text=$p(^DHCAPPTRA(ID),"^",2)
  	.s Code=$p(^DHCAPPTRA(ID),"^",1)
  	.Q:$p(^DHCAPPTRA(ID),"^",5)'=HospID
  	.q:##class(web.DHCAPPTreeAdd).CheckTreeConfigloc("TreeAdd", ID, HospID, LocID)=0
  	.Q:(PyType'="")&&(PyType'[$p(^DHCAPPTRA(ID),"^",10))
  	.Q:'..isExistPyCodeOnChilden(ID,PyCode)
  	.s OrdNum=+$p(^DHCAPPTRA(ID),"^",6)
  	.i OrdNum=0 s OrdNum=Code
  	.s TmpArr(OrdNum)=ID_"^"_Text_"^"_Code
  	.
  	
  	s index=""
  	F  s index=$o(TmpArr(index)) Q:index=""  D
  	.s ID=+$g(TmpArr(index))
  	.s Code=$p(^DHCAPPTRA(ID),"^",1)
  	.s Text=$p(^DHCAPPTRA(ID),"^",2)
  	.Set Text= ##class(User.DHCAppTreeAdd).GetTranByDesc("TRADesc",Text,langid)
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text))
	.d Stream.Write(..GetCheckTreeChildenByPyCode(ID,PyCode))
	.d Stream.Write("}")
	d Stream.Write("]")
  	q Stream.Read()
}

///  Descript:	检查分类树孩子节点处理
ClassMethod GetCheckTreeChildenByPyCode(patlev, PyCode) As %String
{
	n (patlev,PyCode,%session)
	Set langid=..%LanguageID()
	s Stream=##class(%Stream.GlobalCharacter).%New() 
    ///  是否存在孩子节点
	s ID=$o(^DHCAPPTRA(0,"LastRowid",patlev,""))
	i ID=""{
		d Stream.Write(..GetCheckTreeLeafNodeByPyCode(patlev, PyCode))   ///是否有叶子节点
		Q Stream.Read()
	}
	
	s count=0	
	s lev=patlev+1
	d Stream.Write(",""children"":[")
	s ID=""
	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",patlev,ID))  q:ID=""  d
	.s Text=$p(^DHCAPPTRA(ID),"^",2)
	.Q:'..isExistPyCodeOnChilden(ID,PyCode)
	.Set Text= ##class(User.DHCAppTreeAdd).GetTranByDesc("TRADesc",Text,langid)
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text))
	.d Stream.Write(..GetCheckTreeChildenByPyCode(ID,PyCode))
	.d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript:  获取叶子节点
ClassMethod GetCheckTreeLeafNodeByPyCode(TraID, PyCode) As %String
{
	n (TraID,PyCode)
	k TreeLeafNote
	///  是否存在孩子节点
	//s CH=$o(^DHCAPPTRA(TraID,"I",""))
	//Q:CH="" ""
	Q:'..isExistChildNote(TraID) ""
	s Stream=##class(%Stream.GlobalCharacter).%New() 
	s count=0
	d Stream.Write(",""children"":[")
	s CH=""
	f  s CH=$o(^DHCAPPTRA(TraID,"I",CH)) q:CH=""  d
	.s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	.Q:PartID=""
	.Q:'$D(^DHCAPPART(PartID))
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2)    /// 部位
	.s PartAlias=$p(^DHCAPPART(PartID),"^",9)   /// 别名
	.Q:(PartDesc'[PyCode)&(PartAlias'[PyCode)
	.Q:$D(TreeLeafNote(PartID))
	.s TreeLeafNote(PartID)=PartDesc
	.//s TraItmID=TraID_"||"_CH_"^"_PartID
	.s TraItmID=TraID_"^"_PartID
	.
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(TraItmID,PartDesc))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(TraItmID,PartDesc))
	.d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript: 本级节点是否需要显示
ClassMethod isExistPyCodeOnChilden(LastLevID As %String, PyCode As %String) As %String
{
	n (LastLevID, PyCode)

	s isExistFlag=0
	/// 不存在下级节点
	s ID=$o(^DHCAPPTRA(0,"LastRowid",LastLevID,""))
	i ID="" D
	.i ..isExistChildNote(LastLevID) D
	..s isExistFlag=..CheckTreeLeafNodeByPyCode(LastLevID,PyCode)   /// 检查叶子节点是否包含别名
	.E  D
	..i ($p(^DHCAPPTRA(LastLevID),"^",2)[PyCode)||($p(^DHCAPPTRA(LastLevID),"^",7)[PyCode) D
	...s isExistFlag=1

	Q:ID="" isExistFlag

	s ID=""
	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",LastLevID,ID))  q:(ID="")||(isExistFlag=1)  d
	.s Text=$p(^DHCAPPTRA(ID),"^",2)
	.s isExistFlag=..isExistPyCodeOnChilden(ID,PyCode)
	.
	Q isExistFlag
}

/// Descript:  检查叶子节点是否包含别名
ClassMethod CheckTreeLeafNodeByPyCode(TraID, PyCode) As %String
{
	n (TraID,PyCode)
	s isExistFlag=0
	s CH=""
	f  s CH=$o(^DHCAPPTRA(TraID,"I",CH)) q:(CH="")||(isExistFlag=1)  d
	.s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	.Q:PartID=""
	.Q:'$D(^DHCAPPART(PartID))
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2)   /// 部位
	.s PartAlias=$p(^DHCAPPART(PartID),"^",9)  /// 别名
	.Q:(PartDesc'[PyCode)&(PartAlias'[PyCode)
	.s isExistFlag=1
	.
	Q isExistFlag
}

/// Descript:  获取部位对应顶级节点拼音码
/// w ##class(web.DHCAPPExaReportQuery).GetPartTreeTopLevNodePyCode("6884")
ClassMethod GetPartTreeTopLevNodePyCode(TraID As %String) As %String
{
	n (TraID)
	s TraDesc=$p(^DHCAPPTRA(TraID),"^",7)    /// 分级别名
	s LastLevID=$p(^DHCAPPTRA(TraID),"^",4)  /// 上级节点
	Q:LastLevID=0 TraDesc
	Q ..GetPartTreeTopLevNodePyCode(LastLevID)
}

/// Descript:  过滤字符串中的英文字母
/// w ##Class(web.DHCAPPExaReportQuery).FilerEngLetChar("")
ClassMethod FilerEngLetChar(InString As %String) As %String
{
	n (InString)
	s TmpString=""
	s InString=$ZCVT(InString,"U")
	s len=$L(InString)
	f i=1:1:len  D
	.s vChar=$E(InString,i)
	.s vChar=$ASCII(vChar)
	.Q:(vChar'<65)&(vChar'>90)
	.i TmpString="" s TmpString=$E(InString,i)
	.E  s TmpString=TmpString_$E(InString,i)
	Q TmpString
}

/// Descript:  检查部位列表
/// w ##Class(web.DHCAPPExaReportQuery).jsonPart("10","1","")
ClassMethod jsonPart(rows As %String, page As %String, PartName As %String, q = "", itmmastid As %String = "", ShowAllPart = 0) As %String
{
	n (rows, page, PartName, q, itmmastid, ShowAllPart)
	i q'="" s PartName=q
	s End = page*rows
	s Start=(page-1)*rows+1
	if (itmmastid="")&&(ShowAllPart=0) {
		s Stream=##class(%Stream.GlobalCharacter).%New()
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(0)) //输出json结尾符
		Q Stream.Read()
	}
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s PartName=$$ALPHAUP^SSUTIL4(PartName)
    s h=0,count=0
    if (itmmastid="") {
	    s PartID=""
	    f  s PartID=$o(^DHCAPPART(PartID)) Q:PartID=""  D
	    .Q:+PartID=0
	    .s PartDesc=$p(^DHCAPPART(PartID),"^",2)
	    .Q:$p(^DHCAPPART(PartID),"^",5)="N"         /// 停用
	    .Q:(PartDesc'[PartName)&($p(^DHCAPPART(PartID),"^",9)'[PartName)
	    .s LastPartID=$p(^DHCAPPART(PartID),"^",3)
	    .Q:+LastPartID=0
		.s LastPartDesc=$p($g(^DHCAPPART(LastPartID)),"^",2)
		.s h=h+1
		.s ListData=PartID_"^"_PartDesc_"^"_LastPartID_"^"_LastPartDesc
		.s ^TMP("DHCST","web.DHCAPPExaReportQuery","jsonPart",pid,h)=ListData
	}else{
		k PartListArr
		s TraID=""
		for {
			s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID)) q:TraID="" 
			s CH=""
			for{
				 s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) q:CH="" 
				 s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
				 continue:+PartID=0
				 continue:$d(PartListArr(PartID))
				 s PartDesc=$p(^DHCAPPART(PartID),"^",2)
				 continue:$p(^DHCAPPART(PartID),"^",5)="N"         /// 停用
				 continue:(PartDesc'[PartName)&($p(^DHCAPPART(PartID),"^",9)'[PartName)
				 s LastPartID=$p(^DHCAPPART(PartID),"^",3)
				 continue:+LastPartID=0
				 s LastPartDesc=$p($g(^DHCAPPART(LastPartID)),"^",2)
				 s h=h+1
				 s ListData=PartID_"^"_PartDesc_"^"_LastPartID_"^"_LastPartDesc
				 s ^TMP("DHCST","web.DHCAPPExaReportQuery","jsonPart",pid,h)=ListData
				 s PartListArr(PartID)=1
			}
		}
		k PartListArr
	}
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="PartID^PartDesc^LastPartID^LastPartDesc"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","jsonPart",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","jsonPart",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript:  获取申请单总金额
/// w ##Class(web.DHCAPPExaReportQuery).GetExaReqNoCost("")
ClassMethod GetExaReqNoCost(arReqID As %String, ContainChild As %String = "N") As %String
{
	n (arReqID, ContainChild)
	Q:arReqID="" ""
	s AdmId=$p(^DHCAPREP(arReqID),"^",6)
	s ExaReqCost=0
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:CH=""  D
	.s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)    ///医嘱项目ID
	.s Oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)      /// 医嘱ID
	.s TItemStatCode=""
	.q:Oeori=""
	.s itemStatDr = $p($g(^OEORD(+Oeori,"I",$P(Oeori,"||",2),1)),"^",13)
	.s:+itemStatDr>0 TItemStatCode = $p(^OEC("OSTAT",itemStatDr),"^",1)
	.q:((TItemStatCode="D")||(TItemStatCode="U")||(TItemStatCode="C"))
	.s itmCostStr=##Class(web.DHCAPPInterface).GetExaReqPartCost(Oeori,"","")
	.s itmCost=+$p(itmCostStr,"^",1)
	.i itmCost = 0 d
	..s ExpStrin="^^^"_AdmId_"^^^^"
	..s itmCost=##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcimid,+$h,"","","","","",ExpStrin)
	.s ExaReqCost=ExaReqCost+itmCost
	.;包含附带的子医嘱金额
	.q:ContainChild'="Y"
	.s LinkSub=0 s LinkSub=$o(^OEORDi(0,"OEORI",+Oeori,Oeori,LinkSub)) q:LinkSub=""  d
	..s ItemStat=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(+Oeori_"||"_LinkSub)
	..Q:(ItemStat="D")||(ItemStat="C")||(ItemStat="U")||(ItemStat="I")  
	..s LinkPriceStr=##class(web.DHCDocOrderCommon).GetOEORIPrice(+Oeori_"||"_LinkSub)
	..s LinkOrdPackQtyInfo=##class(web.DHCDocQryOEOrder).GetOrdPackQtyInfo(+Oeori_"||"_LinkSub)
	..s LinkOrderPackQty=$fn($p(LinkOrdPackQtyInfo,"^",1),"",0)
	..s LinkArcPrice=$p(LinkPriceStr,"^",1)*LinkOrderPackQty
	..s ExaReqCost=ExaReqCost+LinkArcPrice
	Q ExaReqCost_"元"
}

/// Descript:  获取申请单状态
/// w ##Class(web.DHCAPPExaReportQuery).GetExaReqNoStat("")
ClassMethod GetExaReqNoStat(arReqID As %String) As %String
{
	n (arReqID)
	Q:arReqID="" ""
	s Err=0
	s CH=""
	f  s CH=$o(^DHCAPREP(arReqID,"AR",CH)) Q:(CH="")||(Err=1)  D
	.s oeori=$p(^DHCAPREP(arReqID,"AR",CH),"^",3)          /// 医嘱ID
	.s PartNum=##Class(web.DHCAPPExaReport).GetExaReqPartNum(arReqID,CH)	 /// 检查申请部位数
	.i PartNum'=0 D
	../// 检查当前对应部位是否停止
	..s Err=##Class(web.DHCAPPExaReport).GetExaReqItmStat(arReqID_"||"_CH,"")
	.E  D
	../// 没有对应部位时,查看医嘱状态
	..if oeori'="" d 
	...s itemStat=..GetOeoriStat(oeori)
	...i (itemStat'="D")&(itemStat'="C")&(itemStat'="U") s Err=1
	..e  d
	...s OeorStatus=$p(^DHCAPREP(arReqID,"AR",CH),"^",9) 
	...if (OeorStatus'="D") s Err=1
	.Q:Err=0
	.
	Q Err
}

/// Descript: 根据医嘱ID获取收费项目信息
/// w ##Class(web.DHCAPPExaReportQuery).QueryPartItmList("4536||12")
ClassMethod QueryPartItmList(oeori As %String) As %String
{
	n (oeori,%session)
	Set langid=..%LanguageID()
    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    
    s reqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))    /// 检查申请ID
	Q:reqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,reqID,""))
	Q:CH="" ""
	Q:'$d(^DHCAPREP(reqID,"AR",CH)) ""
	s arcimid=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",2) /// 医嘱项ID
	Q:arcimid="" ""
	s EpisodeID=$p(^OEORD(+oeori),"^",1)	      /// 就诊ID
	s AdmDepId=$p(^PAADM(EpisodeID),"^",4)
	s HospId=$p(^CTLOC(AdmDepId),"^",22)
	s TarFlag=##Class(web.DHCAPPExaRepCom).GetItemTarFlag(arcimid,HospId) /// 多部位只收取一个部位价钱
	s Num=0
	s PartExecFlag="核实"
	/// 部位
	s Sub=""
	f  s Sub=$o(^DHCAPREP(reqID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	.s PartID=+$p(^DHCAPREP(reqID,"AR",CH,"PA",Sub),"^",1)   /// 部位ID
	.Q:PartID=0
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2) 				 /// 部位
	.s PartDesc=##class(User.DHCAppPart).GetTranByDesc("APDesc",PartDesc,langid)
	.s ExeStat=$p(^DHCAPREP(reqID,"AR",CH,"PA",Sub),"^",2)   /// 执行状态
	.s arPartID=reqID_"||"_CH_"||"_Sub
	.s PosiDesc=##Class(web.DHCAPPExaReportQuery).GetRepPosi(arPartID) /// 体位
	.s ItemPrice=+..GetExaReqPartCostForRefundApply(oeori,PartID)
	.i PosiDesc'="" s PartDesc=PartDesc_"【 "_PosiDesc_" 】"
	.Q:ExeStat="D"
	.i ExeStat="E" s PartExecFlag="执行"
	.s ItemStat=$s(ExeStat="V":"核实",ExeStat="E":"执行",ExeStat="D":"停止",1:"")
	.s ItemStat=..%Translate("dhcapp.repparttarwin.csp",ItemStat)
	.s ListData=reqID_"||"_CH_"||"_Sub_"^"_PartID_"^"_PartDesc_"^"_ItemStat_"^"_ItemPrice_"^"_TarFlag
	.s Num=Num+1
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPartItmList",pid,Num)=ListData
	/// 后处理
	s Sub=""
	f  s Sub=$o(^DHCAPREP(reqID,"AR",CH,"DI",Sub)) Q:Sub=""  D
	.s DispID=$p(^DHCAPREP(reqID,"AR",CH,"DI",Sub),"^",1)     ///后处理ID
	.Q:DispID=""
	.s DispDesc=$p(^DHCAPDIM(DispID),"^",2) 				  ///后处理描述
	.Set DispDesc= ##class(User.DHCAppDispMedthod).GetTranByDesc("ADDesc",DispDesc,langid)
	.s ItemPrice=..GetExaReqPartCostForRefundApply(oeori,DispID)
	.s ListData=""_"^"_""_"^"_DispDesc_"^"_PartExecFlag_"^"_ItemPrice
	.s Num=Num+1
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPartItmList",pid,Num)=ListData
	/// 检查项目加收费用
	s TarDiscCost=0
	s TarID=""
	f  s TarID=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarID)) Q:TarID=""  D
	.s TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    /// 计费标志
	.Q:(TarBilled="I")||(TarBilled="R")
	.s TarType=$p(^DHCAPREPTA(TarID),"^",3)      /// 类型
	.Q:TarType'="D"
	.Q:$p(^DHCAPREPTA(TarID),"^",1)'=""          /// 指针
	.s TarItmID=$p(^DHCAPREPTA(TarID),"^",5)     /// 收费项ID
	.s TarPrice=##Class(web.DHCAPPInterface).GetTarPrice(TarItmID,EpisodeID) /// 取收费项价格
	.s TarQty=$p(^DHCAPREPTA(TarID),"^",8)       /// 数量
	.s TarDiscCost=TarDiscCost+(TarPrice*TarQty)
	i TarDiscCost'=0 D
	.s ListData=""_"^"_""_"^"_"检查项目加收费用"_"^"_PartExecFlag_"^"_TarDiscCost
	.s Num=Num+1
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPartItmList",pid,Num)=ListData
	
	;i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	;q:Num=0 ""
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i Num=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	s count=0
	S ListTitle="ItemID^PartID^PartDesc^ItemStat^ItemPrice^TarFlag"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(Num)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPartItmList",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPartItmList",pid,index))
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript:  获取检查申请医嘱总费用-供退费申请-部位用
/// Input:     oeori-医嘱ID,PartID-部位ID
/// OutPut:    折后费用^费用
/// w ##Class(web.DHCAPPExaReportQuery).GetExaReqPartCost("354||122","374")
ClassMethod GetExaReqPartCostForRefundApply(oeori As %String, PartID As %String) As %String
{
	n (oeori,PartID)
	s TarDiscCost=0,TarCost=0
	s EpisodeID=$p(^OEORD(+oeori),"^",1)	/// 就诊ID
	s TarID=""
	f  s TarID=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarID)) Q:TarID=""  D
	.s TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    /// 计费标志
	.Q:(TarBilled="I")||(TarBilled="R")
	.s TarType=$p(^DHCAPREPTA(TarID),"^",3)      /// 类型
	.s TarPartID=$p(^DHCAPREPTA(TarID),"^",1)    /// 部位ID
	.Q:(PartID'="")&(TarPartID'=PartID)          /// 筛选部位
	.s TarItmID=$p(^DHCAPREPTA(TarID),"^",5)     /// 收费项ID
	.s TarPrice=##Class(web.DHCAPPInterface).GetTarPrice(TarItmID,EpisodeID) /// 取收费项价格
	.s TarDisc=$p(^DHCAPREPTA(TarID),"^",4)      /// 打折系数
	.s TarQty=$p(^DHCAPREPTA(TarID),"^",8)       /// 数量
	.s TarDiscCost=TarDiscCost+(TarPrice*TarDisc*TarQty)
	.s TarCost=TarCost+(TarPrice*TarQty)
	Q TarDiscCost_"^"_TarCost
}

/// Descript: 医嘱对应部位数
/// w ##Class(web.DHCAPPExaReportQuery).GetExaReqPartNumByOrd("23693||14")
ClassMethod GetExaReqPartNumByOrd(oeori As %String) As %String
{
	n (oeori)
    
    s arReqID=$o(^DHCAPREP(0,"OrdItem",oeori,""))    /// 检查申请ID
	Q:arReqID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",oeori,arReqID,""))
	Q:CH="" ""
	Q:'$d(^DHCAPREP(arReqID,"AR",CH)) ""
	s PartNum=##Class(web.DHCAPPExaReport).GetExaReqPartNum(arReqID,CH)	 /// 检查申请部位数
	Q PartNum
}

/// Descript: 根据医嘱项获取部位树
ClassMethod GetPartTreeChildByArcNoTarIDNew(itmmastid As %String, PyCode As %String, HospID As %String) As %String
{
	n (itmmastid,PyCode,HospID,%session)
	//检查部位按照使用频率排序
	s UserRowId=%session.Get("LOGON.USERID")
	s GroupRowId=%session.Get("LOGON.GROUPID")
	s ExaPartSortByUseCount=##class(web.DHCDocConfig).GetUserPageSetting("CheckApp","obj",UserRowId,GroupRowId).ExaPartSortByUseCount
	Set langid=..%LanguageID()
	k TMPTreeLeafNode
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID)) q:TraID=""  d
	.Q:$p(^DHCAPPTRA(TraID),"^",5)'=HospID
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) q:CH=""  d
	..s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	..Q:+PartID=0
	..Q:'$D(^DHCAPPART(PartID))
	..s PartDesc=$p(^DHCAPPART(PartID),"^",2)    /// 部位
	..s PartDesc=##class(User.DHCAppPart).GetTranByDesc("APDesc",PartDesc,langid)
	..Q:$p(^DHCAPPART(PartID),"^",5)="N"         /// 停用
	..s PartAlias=$p(^DHCAPPART(PartID),"^",9)   /// 别名
	..Q:(PartDesc'[PyCode)&(PartAlias'[PyCode)
	..Q:$D(TreeLeafNote(PartID))
	..s TreeLeafNote(PartID)=PartDesc
	..s LPartID=$p(^DHCAPPART(PartID),"^",3)      /// 部位ID
	..s LPartDesc=$p(^DHCAPPART(LPartID),"^",2)   /// 部位
	..s OrdNum=+$p(^DHCAPPART(PartID),"^",8)      /// 顺序
	..if ExaPartSortByUseCount="Y" d
	...s OrdNum=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount("User.DHCAppPart",PartID,UserRowId,"U")
	..s TMPTreeLeafNode(LPartID_"^"_LPartDesc,OrdNum,PartID_"^"_PartDesc)=""
	.
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s index="", count=0
	F  s index=$o(TMPTreeLeafNode(index)) Q:index=""  D
	.s LPartID=$p(index,"^",1)
	.s LPartDesc=$p(index,"^",2)
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(LPartID,LPartDesc))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(LPartID,LPartDesc))
	.
	.d Stream.Write(..GetTmpPartTreeChildNode(index, .TMPTreeLeafNode,ExaPartSortByUseCount))
	.d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript: 根据医嘱项获取部位树
/// w ##Class(web.DHCAPPExaReportQuery).GetPartTreeChildByArcNew("3861||1","2","")
ClassMethod GetPartTreeChildByArcNew(itmmastid As %String, TraID As %String, PyCode As %String) As %String
{
	n (itmmastid,TraID,PyCode,%session)
	//检查部位按照使用频率排序
	s UserRowId=%session.Get("LOGON.USERID")
	s GroupRowId=%session.Get("LOGON.GROUPID")
	Set langid=..%LanguageID()
	s ExaPartSortByUseCount=##class(web.DHCDocConfig).GetUserPageSetting("CheckApp","obj",UserRowId,GroupRowId).ExaPartSortByUseCount
	k TMPTreeLeafNode
	s CH=""
	f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) q:CH=""  d
	.s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	.Q:+PartID=0
	.Q:'$D(^DHCAPPART(PartID))
	.s PartDesc=$p(^DHCAPPART(PartID),"^",2)    /// 部位
	.s PartDesc=##class(User.DHCAppPart).GetTranByDesc("APDesc",PartDesc,langid)
	.Q:$p(^DHCAPPART(PartID),"^",5)="N"         /// 停用
	.s PartAlias=$p(^DHCAPPART(PartID),"^",9)   /// 别名
	.Q:(PartDesc'[PyCode)&(PartAlias'[PyCode)
	.Q:$D(TreeLeafNote(PartID))
	.s TreeLeafNote(PartID)=PartDesc
	.s LPartID=$p(^DHCAPPART(PartID),"^",3)     /// 部位ID
	.s LPartDesc=$p(^DHCAPPART(LPartID),"^",2)  /// 部位
	.s OrdNum=+$p(^DHCAPPART(PartID),"^",8)     /// 顺序
	.;根节点 顺序号 ;2021.3.16 增加根节点排序
	.s LOrdNum=+$p(^DHCAPPART(LPartID),"^",8) 
	.s LOrdNum=$e("0000",1,4-$l(LOrdNum))_LOrdNum
	.i ExaPartSortByUseCount="Y" d
	..s OrdNum=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount("User.DHCAppPart",PartID,UserRowId,"U")
	.s TMPTreeLeafNode(LOrdNum_"^"_LPartID_"^"_LPartDesc,OrdNum,PartID_"^"_PartDesc)=""
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s index="", count=0
	F  s index=$o(TMPTreeLeafNode(index)) Q:index=""  D
	.s LPartID=$p(index,"^",2)
	.s LPartDesc=$p(index,"^",3)
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(LPartID,LPartDesc))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(LPartID,LPartDesc))
	.
	.d Stream.Write(..GetTmpPartTreeChildNode(index, .TMPTreeLeafNode, ExaPartSortByUseCount))
	.d Stream.Write("}")
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript: 根据临时的数据变量获取指定树的json格式
ClassMethod GetTmpPartTreeChildNode(index As %String, TMPTree As %String, ExaPartSortByUseCount As %String = "0") As %String
{
	n (index,TMPTree,ExaPartSortByUseCount)
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s count=0
	d Stream.Write(",""children"":[")
	if (ExaPartSortByUseCount="Y") {
		s index2=""
		F  s index2=$o(TMPTree(index,index2),-1) Q:index2=""  D
		.s index3=""
		.F  s index3=$o(TMPTree(index,index2,index3)) Q:index3=""  D
		..s PartID=$p(index3,"^",1)
		..s PartDesc=$p(index3,"^",2)
		..s count = count+1
		..i count=1 d
		...d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(PartID,PartDesc))
		..e  d
		...d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(PartID,PartDesc))
		..d Stream.Write("}")
	}else{
		s index2=""
		F  s index2=$o(TMPTree(index,index2)) Q:index2=""  D
		.s index3=""
		.F  s index3=$o(TMPTree(index,index2,index3)) Q:index3=""  D
		..s PartID=$p(index3,"^",1)
		..s PartDesc=$p(index3,"^",2)
		..s count = count+1
		..i count=1 d
		...d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(PartID,PartDesc))
		..e  d
		...d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(PartID,PartDesc))
		..d Stream.Write("}")
	}
	d Stream.Write("]")
	Q Stream.Read()
}

/// =================================以下最新版检查申请===================================
/// Descript:  检查分类树
/// w ##class(web.DHCAPPExaReportQuery).jsonCheckCatByNodeIDNew(0,2,"")
ClassMethod jsonCheckCatByNodeIDNew(id As %String, HospID As %String, PyType As %String = "", LocID As %String = "") As %String
{
	n (id, HospID, PyType,LocID,%session)
	s ^tempqujian("jsonCheckCatByNodeIDNew")=id_","_HospID_","_ PyType
	Set langid=..%LanguageID()
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s count=0 k TmpArr
	s ID=0
  	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",id,ID)) q:ID=""  d
  	.s Code=$p(^DHCAPPTRA(ID),"^",1)
  	.s Text=$p(^DHCAPPTRA(ID),"^",2)
  	.Q:$p(^DHCAPPTRA(ID),"^",5)'=HospID
  	.q:##class(web.DHCAPPTreeAdd).CheckTreeConfigloc("TreeAdd", ID, HospID, LocID)=0
  	.Q:(PyType'="")&&(PyType'[$p(^DHCAPPTRA(ID),"^",10))		//增加过滤类型 qunianpeng 2018/2/1
  	.s OrdNum=+$p(^DHCAPPTRA(ID),"^",6)
  	.i OrdNum=0 s OrdNum=Code
  	.s TmpArr(OrdNum,ID)=ID_"^"_Text_"^"_Code
  	.
  	s index=""
  	F  s index=$o(TmpArr(index)) Q:index=""  D
  	.s IDindex=""
  	.F  s IDindex=$o(TmpArr(index,IDindex)) Q:IDindex=""  D
  	..s ID=+$g(TmpArr(index,IDindex))
  	..s Code=$p(^DHCAPPTRA(ID),"^",1)
  	..s Text=$p(^DHCAPPTRA(ID),"^",2)
  	..Set Text= ##class(User.DHCAppTreeAdd).GetTranByDesc("TRADesc",Text,langid)
  	..s count = count+1
	..i count=1 d
	...d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
	..e  d
	...d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
    ..///  是否存在孩子节点
	..s trID=$o(^DHCAPPTRA(0,"LastRowid",ID,""))
	..i trID'="" D
	...d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeClosedSign())
	..//i trID="" D ..GetCheckTreeLeafNote(ID)   ///是否有叶子节点
	..d Stream.Write("}")
	
	/// 如果分类树为空,显示默认根节点
	i count=0 d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign("ROOT","部位树根节点")_"}")
	
	d Stream.Write("]")
  	q Stream.Read()
}

/// Descritp:	检查方法
/// W ##Class(web.DHCAPPExaReportQuery).jsonItemList("")
ClassMethod jsonItemList(item As %String, HospID As %String, LocID As %String = "") As %String
{
	n (item,HospID,LocID,%session)
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign("0","结果列表"))
	d Stream.Write(",""items"":")
	d Stream.Write(..GetItemList(item,HospID,LocID))
	d Stream.Write("}")
	d Stream.Write("]")
	//q Stream.Read()
	Q Stream.ReadSQL()
}

/// Descritp:	检验方法 
/// W ##Class(web.DHCAPPExaReportQuery).jsonLabItemList("xx")
ClassMethod jsonLabItemList(item As %String, HospID As %String) As %String
{
	n (item,HospID,%session)
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign("1","结果列表"))
	d Stream.Write(",""items"":")
	d Stream.Write(..GetLabItemList(item,HospID))
	d Stream.Write("}")
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	检查项目明细
/// W ##Class(web.DHCAPPExaReportQuery).GetItemList("乳头")
ClassMethod GetItemList(item As %String, HospID As %String, LocID As %String = "") As %String
{
	n (item,HospID,LocID,%session)
	Set langid=..%LanguageID()
	s count = 0
	s ItemStream=##class(%Stream.GlobalCharacter).%New()
	d ItemStream.Write("[")
	s TraID=0
	f  s TraID=$o(^DHCAPPTRA(TraID)) q:TraID=""  d
	.q:'$d(^DHCAPPTRA(TraID))
	.Q:$p(^DHCAPPTRA(TraID),"^",10)'="E"
	.Q:$p(^DHCAPPTRA(TraID),"^",5)'=HospID
	.q:##class(web.DHCAPPTreeAdd).CheckTreeConfigloc("TreeAdd", TraID, HospID, LocID)=0
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(TraID,"I",CH)) q:CH=""  d
	..s arcimid=$p(^DHCAPPTRA(TraID,"I",CH),"^",2)
	..q:##class(web.DHCAPPTreeAdd).CheckTreeConfigloc("TreeLink", TraID_"||"_CH, HospID, LocID)=0
	..s ArcimClassification=##class(web.DHCDocOrderCommon).GetArcimClassification(arcimid)
	..Q:(ArcimClassification'="L")&&(ArcimClassification'="E")
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s arcEndDate=$p(^ARCIM(itmmastid,itmmastver,7),"^",1)   //sufan 2018-11-21 判断医嘱是否可用
	..Q:(arcEndDate'="")&&(arcEndDate<+$H)
	..s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  //医嘱项代码
	..s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  //医嘱项名称
	..s arcitmdesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcitmdesc,langid)
	..Q:$p($g(^ARCIM(+itmmastid,itmmastver,7)),"^",13)'["Y"
	..Q:(arcitmdesc'[item)&('..isExistAlias(arcimid,$zcvt(item,"U")))
	..s arcitmsentive=$p(^ARCIM(itmmastid,itmmastver,9),"^",18)	//医嘱项加急标志(Y可选加急 N不可选)  qunianpeng 2018/3/20
	..s arcitmsentive=$case($zcvt(arcitmsentive,"U"),"Y":"Y","N":"N",:"N")
	..;是否默认加急
	..s ARCIMDefSensitive= $p($g(^ARCIM(+itmmastid,itmmastver,9)),"^",41) 
	..s ARCIMDefSensitive=$case(ARCIMDefSensitive,"Y":"Y",:"N")
	..s arcimid=$REPLACE(arcimid,"||","_")
	..Q:$d(TmpFilter(arcimid))
	..s TmpFilter(arcimid)=""
	..s ListData=arcimid_"^"_arcitmdesc_"^"_arcitmsentive_"^"_ARCIMDefSensitive
	..s count = count+1
	..I count=1 d
	...d ItemStream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^title^defSensitive",ListData))
	..e  d
	...d ItemStream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^title^defSensitive",ListData))
	d ItemStream.Write("]")
	/*if (ItemStream.SizeGet()>32656) {
		Q ItemStream.ReadSQL()
	}else{
		Q ItemStream.Read()
	}*/
	Q ItemStream.ReadSQL()
}

/// Descritp:	检验项目明细 
/// W ##Class(web.DHCAPPExaReportQuery).GetItemList("乳头")
ClassMethod GetLabItemList(item As %String, HospID As %String) As %String
{
	n (item,HospID,%session)
	Set langid=..%LanguageID()
	s count = 0
	s ItemStream=##class(%Stream.GlobalCharacter).%New()
	d ItemStream.Write("[")
	s TraID=0
	f  s TraID=$o(^DHCAPPTRA(TraID)) q:TraID=""  d
	.Q:$p(^DHCAPPTRA(TraID),"^",10)'="L"
	.Q:$p(^DHCAPPTRA(TraID),"^",5)'=HospID
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(TraID,"I",CH)) q:CH=""  d
	..s arcimid=$p(^DHCAPPTRA(TraID,"I",CH),"^",2)
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s arcEndDate=$p($g(^ARCIM(itmmastid,itmmastver,7)),"^",1)   //sufan 2018-11-21 判断医嘱是否可用
	..Q:(arcEndDate'="")&&(arcEndDate<+$H)
	..s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  //医嘱项代码
	..s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  //医嘱项名称
	..Q:$p($g(^ARCIM(+itmmastid,itmmastver,7)),"^",13)'["Y"
	..s arcitmdesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcitmdesc,langid)
	..Q:(arcitmdesc'[item)&('..isExistAlias(arcimid,$zcvt(item,"U")))
	..s arcitmsentive=$p(^ARCIM(itmmastid,itmmastver,9),"^",18)	//医嘱项加急标志(Y可选加急 N不可选)  qunianpeng 2018/3/20
	..s arcitmsentive=$case($zcvt(arcitmsentive,"U"),"Y":"Y","N":"N",:"N")
	..s arcimid=$REPLACE(arcimid,"||","_")
	..Q:$d(TmpFilter(arcimid))
	..s TmpFilter(arcimid)=""
	..s ListData=arcimid_"^"_arcitmdesc_"^"_arcitmsentive
	..s count = count+1
	..I count=1 d
	...d ItemStream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^title",ListData))
	..e  d
	...d ItemStream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^title",ListData))
	..
	d ItemStream.Write("]")
	q ItemStream.Read()
}

/// Descritp:	检查项目别名
/// W ##Class(web.DHCAPPExaReportQuery).isExistAlias("1||1","BAD")
ClassMethod isExistAlias(arcimid As %String, item As %String) As %String
{
	n (arcimid, item)
	s ID="",quitflag=0
	F  s ID=$o(^ARC("ALIAS",0,"ARCIM",arcimid,ID)) Q:(ID="")||(quitflag=1)  D
    .Q:$p(^ARC("ALIAS",ID),"^",6)'[item
    .s quitflag=1
    Q quitflag
}

/// Descritp:	检查方法
/// W ##Class(web.DHCAPPExaReportQuery).jsonExaItemList("10")
ClassMethod jsonExaItemList(params As %String, LocID As %String = "", HospID As %String = "") As %String
{
	n (params,LocID,HospID,%session)
	s TraID=$P(params,"^",1)  /// 主表ID
	s PartID=$p(params,"^",2)  /// 部位ID
	Set langid=..%LanguageID()
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s ID=$o(^DHCAPPTRA(0,"LastRowid",TraID,""))
	I ID=""  D
	.s Text=$p(^DHCAPPTRA(TraID),"^",2)
	.Set Text= ##class(User.DHCAppTreeAdd).GetTranByDesc("TRADesc",Text,langid)
	.q:##class(web.DHCAPPTreeAdd).CheckTreeConfigloc("TreeAdd", TraID, HospID, LocID)=0
	.d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(TraID,Text))
	.d Stream.Write(",""items"":")
	.d Stream.Write(..GetExaItemList(TraID,PartID,HospID, LocID))
	.d Stream.Write("}")
	E  D
	.s ID=0
  	.f  s ID=$o(^DHCAPPTRA(0,"LastRowid",TraID,ID)) q:ID=""  d
  	..q:##class(web.DHCAPPTreeAdd).CheckTreeConfigloc("TreeAdd", TraID, HospID, LocID)=0
  	..s Text=$p(^DHCAPPTRA(ID),"^",2)
  	..Set Text= ##class(User.DHCAppTreeAdd).GetTranByDesc("TRADesc",Text,langid)
  	..s count = count+1
	..i count=1 d
	...d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text))
	..e  d
	...d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStartSign(ID,Text))
	..d Stream.Write(",""items"":")
	..d Stream.Write(..GetExaItemList(ID,PartID,HospID, LocID))
	..d Stream.Write("}")
	d Stream.Write("]")
	q Stream.ReadSQL()
}

/// Descript: 检查项目明细
ClassMethod GetExaItemList(TraID As %String, PartID As %String = "", HospID As %String = "", LocID As %String = "") As %String
{
	n (TraID,PartID,HospID,LocID,%session)
	//检验/检查项目按照使用频率排序
	s UserRowId=%session.Get("LOGON.USERID")
	s GroupRowId=%session.Get("LOGON.GROUPID")
	Set langid=..%LanguageID()
    s ExaSortByUseCount=##class(web.DHCDocConfig).GetUserPageSetting("CheckApp","obj",UserRowId,GroupRowId).ExaSortByUseCount
	s count = 0
	k TMPListArr
	s CH=""
	f  s CH=$o(^DHCAPPTRA(TraID,"I",CH)) q:CH=""  d
	.s itempartid=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)    //部位
	.s itempartdesc=$p($g(^DHCAPPART(+itempartid)),"^",2)   //部位描述
	.s arcimid=$p(^DHCAPPTRA(TraID,"I",CH),"^",2)
	.s ArcimClassification=##class(web.DHCDocOrderCommon).GetArcimClassification(arcimid)
	.Q:(ArcimClassification'="L")&&(ArcimClassification'="E")
	.q:(PartID'="")&&(itempartid'=PartID)
	.q:##class(web.DHCAPPTreeAdd).CheckTreeConfigloc("TreeLink", TraID_"||"_CH, HospID, LocID)=0
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcEndDate=$p(^ARCIM(itmmastid,itmmastver,7),"^",1)  //sufan 2018-11-21 判断医嘱是否可用
	.Q:(arcEndDate'="")&&(arcEndDate<+$H)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  //医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  //医嘱项名称
	.Q:$p($g(^ARCIM(+itmmastid,itmmastver,7)),"^",13)'["Y"
	.s arcitmdesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcitmdesc,langid)
	.s arcitmsentive=$p(^ARCIM(itmmastid,itmmastver,9),"^",18)	//医嘱项加急标志(Y可选加急 N不可选)  qunianpeng 2018/3/20
	.s arcitmsentive=$case($zcvt(arcitmsentive,"U"),"Y":"Y","N":"N",:"N")
	.;是否默认加急
	.s ARCIMDefSensitive= $p($g(^ARCIM(+itmmastid,itmmastver,9)),"^",41) 
	.s ARCIMDefSensitive=$case(ARCIMDefSensitive,"Y":"Y",:"N")
	.s arcimid=$REPLACE(arcimid,"||","_")
	.Q:$d(TmpFilter(arcimid))
	.s TmpFilter(arcimid)=""
	.s itemOrdNum=$p(^DHCAPPTRA(TraID,"I",CH),"^",5)    /// 顺序号
	.if itemOrdNum=""  s itemOrdNum=CH+10000
	.s ListData=arcimid_"^"_arcitmdesc_"^"_arcitmsentive_"^"_ARCIMDefSensitive
	.s count = count+1
	.if ExaSortByUseCount="Y" d
	..s RecordCount=##class(DHCDoc.Log.DHCDocCTUseCount).GetCount("User.ARCItmMast",$REPLACE(arcimid,"_","||"),UserRowId,"U")
	..s TMPListArr(RecordCount,count)=ListData
	.e  d
	..s TMPListArr(itemOrdNum,count)=ListData
	.
	
	s ItemStream=##class(%Stream.GlobalCharacter).%New()
	d ItemStream.Write("[")
	if (ExaSortByUseCount="Y") {
		s index="",itemcount=0
		F  s index=$o(TMPListArr(index),-1) Q:index=""  D
		.s count="" 
		.F  s count=$o(TMPListArr(index,count)) Q:count=""  D
		..s ListData=$g(TMPListArr(index,count))
		..s itemcount = itemcount+1
		..I itemcount=1 d
		...d ItemStream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^title^defSensitive",ListData))
		..e  d
		...d ItemStream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^title^defSensitive",ListData))
	}else{
		s index="",itemcount=0
		F  s index=$o(TMPListArr(index)) Q:index=""  D
		.s count="" 
		.F  s count=$o(TMPListArr(index,count)) Q:count=""  D
		..s ListData=$g(TMPListArr(index,count))
		..s itemcount = itemcount+1
		..I itemcount=1 d
		...d ItemStream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^title^defSensitive",ListData))
		..e  d
		...d ItemStream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^title^defSensitive",ListData))
		.
	}
	d ItemStream.Write("]")
	q ItemStream.Read()
}

/// Descript: 检查项目是否关联部位
/// W ##Class(web.DHCAPPExaReportQuery).isExistLinkPart("1809||1","7044")
ClassMethod isExistLinkPart(itmmastid As %String, TraID As %String, HospID As %String) As %String
{
	n (itmmastid, TraID, HospID)
	s itmmastid=$REPLACE(itmmastid,"_","||")
	Q:'$D(^DHCAPPTRA(0,"Arc",itmmastid,TraID)) ..isExistLinkPartNoTraID(itmmastid, HospID)  /// 不存在分类
	s quitflag=0
	s CH=""
	f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) q:(CH="")||(quitflag=1)  d
	.s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	.Q:+PartID=0
	.s quitflag=1
	Q quitflag
}

/// Descript: 检查项目是否关联部位
/// W ##Class(web.DHCAPPExaReportQuery).isExistLinkPartNoTraID("11207||1")
ClassMethod isExistLinkPartNoTraID(itmmastid As %String, HospID As %String) As %String
{
	n (itmmastid, HospID)
	s quitflag=0
	s TraID=""
	f  s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID)) q:(TraID="")||(quitflag=1)  d
	.Q:$p(^DHCAPPTRA(TraID),"^",5)'=HospID
	.s CH=""
	.f  s CH=$o(^DHCAPPTRA(0,"Arc",itmmastid,TraID,CH)) q:(CH="")||(quitflag=1)  d
	..s PartID=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)
	..Q:+PartID=0
	..s quitflag=1
	Q quitflag
}

/// Descritp:	接收科室
/// w ##Class(web.DHCAPPExaReportQuery).jsonExaCatRecLocNew("27689","11207||1")
ClassMethod jsonExaCatRecLocNew(EpisodeID As %String, ItmmastID As %String, OrderDepRowId As %String = "", OpenForAllHosp As %String = "") As %String
{
	n (EpisodeID, ItmmastID, OrderDepRowId, OpenForAllHosp,%session)
	s SessionStr=..%SessionStr()
	s $P(SessionStr,"^",3)=OrderDepRowId
	k ParamJson,ParamArr
	s ParamArr("EpisodeID")=EpisodeID
    s ParamArr("SessionStr")=SessionStr
    s ParamArr("OpenForAllHosp")=OpenForAllHosp
    s ParamArr("FindRecLocByLogonLoc")=$CASE(OrderDepRowId,"":0,:1)
    s ParamArr("OrderARCIMRowid")=ItmmastID
    s ParamArr("OrderPriorRowid")=$O(^OECPR(0,"Code","NORM",0))
	s ParamJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.ParamArr)
	s RecLocJson=##Class(web.DHCDocOrderCommon).GetRecLocInfo(ParamJson)
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(RecLocJson,.RecLocArr)
	s LocListData=RecLocArr("CurrentRecLocStr")


	;Set langid=..%LanguageID()
	//s LocListData=##Class(web.DHCDocOrderCommon).GetRecloc(EpisodeID, ItmmastID)
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s Len = $L(LocListData,$C(2))
	f i=1:1:Len d
	.s LocList = $p(LocListData,$C(2),i)
	.s LocID = $p(LocList,$C(1),1)
	.s LocDesc = $p(LocList,$C(1),2)
	.;s LocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",LocDesc,langid)
	.s Default = $p(LocList,$C(1),3)
	.s tmp=LocID_"^"_LocDesc
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	默认接收科室
/// w ##Class(web.DHCAPPExaReportQuery).jsonItmDefaultRecLoc("27689","11207||1")
ClassMethod jsonItmDefaultRecLoc(EpisodeID As %String, ItmmastID As %String, OrderDepRowId As %String = "", OpenForAllHosp As %String = "") As %String
{
	n (EpisodeID, ItmmastID,OrderDepRowId,OpenForAllHosp,%session)
	s ^tempscl("jsonItmDefaultRecLoc")=EpisodeID_","_ItmmastID_","_OrderDepRowId_","_OpenForAllHosp
	;s LocListData=##Class(web.DHCDocOrderCommon).GetRecloc(EpisodeID, ItmmastID)
	
	s SessionStr=..%SessionStr()
	s $P(SessionStr,"^",3)=OrderDepRowId
	k ParamJson,ParamArr
	s ParamArr("EpisodeID")=EpisodeID
    s ParamArr("SessionStr")=SessionStr
    s ParamArr("OpenForAllHosp")=OpenForAllHosp
    s ParamArr("FindRecLocByLogonLoc")=$CASE(OrderDepRowId,"":0,:1)
    s ParamArr("OrderARCIMRowid")=ItmmastID
    s ParamArr("OrderPriorRowid")=$O(^OECPR(0,"Code","NORM",0))
	s ParamJson=##Class(DHCDoc.Util.FromJSON).GetArrJson(.ParamArr)
	s RecLocJson=##Class(web.DHCDocOrderCommon).GetRecLocInfo(ParamJson)
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(RecLocJson,.RecLocArr)
	s LocListData=RecLocArr("CurrentRecLocStr")


	;Set langid=..%LanguageID()
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s Len = $L(LocListData,$C(2))
	f i=1:1:Len d
	.s LocList = $p(LocListData,$C(2),i)
	.s LocID = $p(LocList,$C(1),1)
	.s LocDesc = $p(LocList,$C(1),2)
	.;s LocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",LocDesc,langid)
	.s Default = $p(LocList,$C(1),3)
	.Q:Default'="Y"
	.s tmp=LocID_"^"_LocDesc
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	默认接收科室
/// w ##Class(web.DHCAPPExaReportQuery).jsonItmRecLoc("27689")
ClassMethod jsonItmRecLoc(LocID As %String) As %String
{
	n (LocID,%session)
	Set langid=..%LanguageID()
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s LocDesc=$P($g(^CTLOC(LocID)),"^",2)
	s LocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",LocDesc,langid)
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",LocID_"^"_LocDesc))
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	获取项目对应注意事项
/// w ##Class(web.DHCAPPExaReportQuery).jsonItemTemp("11207||1")
ClassMethod jsonItemTemp(itmmastid As %String, HospID As %String) As %String
{
	n (itmmastid, HospID)
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	;优先取【RIS预约平台配置】-【注意事项与医嘱项目设置】,若未配置或配置的模板注意事项为空,取检查树-检查注意事项
	s TempText="",ItemTemp=""
	s memoRowid=$o(^DHCRBAppi("Memo-ItMast",itmmastid,0))
	if (memoRowid'="") {
		s memoTmplRowid=$p(^DHCRBApp("Memo",memoRowid),"^",4)
		if (memoTmplRowid'="") {
			s ItemTemp=$p($g(^DHCRBCApp("Memo-Template",memoTmplRowid)),"^",2)
			s TempText=$p($g(^DHCRBCApp("Memo-Template",memoTmplRowid)),"^",3)
			s TempText=$replace(TempText,$c(10),"<br>")
		}
	}
	if (TempText'="") {
		s ListData=ItemTemp_"^"_TempText
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("ItemTemp^TempText",ListData))
	}else {
		s ArcNoID=""
		F  s ArcNoID=$o(^DHCAPARCNO(0,"ARC",itmmastid,ArcNoID)) Q:ArcNoID=""  D
		.s ItemTempID=$p(^DHCAPARCNO(ArcNoID),"^",2)  /// 注意事项ID
		.s ItemTemp=$p(^DHCAPITMTE(ItemTempID),"^",2) /// 注意事项
		.Q:$p(^DHCAPITMTE(ItemTempID),"^",3)'="Y"     /// 不可用退出
		.Q:$p(^DHCAPITMTE(ItemTempID),"^",4)'=HospID  /// 登录医院判断
		.s CH=""
		.F  s CH=$o(^DHCAPITMTE(ItemTempID,"D",CH)) Q:CH=""  D
		..s TempText=$p(^DHCAPITMTE(ItemTempID,"D",CH),"^",1)
		..s ListData=ItemTemp_"^"_TempText
		..s count = count+1
		..i count=1 d
		...d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("ItemTemp^TempText",ListData))
		..e  d
		...d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("ItemTemp^TempText",ListData))
	}
	d Stream.Write("]")
	q Stream.Read()
}

/// Descript: 医嘱项列表
/// w ##Class(web.DHCAPPExaReportQuery).QueryCheckPartList("30","1","6884","11210||1")
ClassMethod QueryCheckPartList(rows As %String, page As %String, TraID As %String, ItemID As %String) As %String
{
	n (rows, page, TraID, ItemID)

	s End = page*rows
	s Start=(page-1)*rows+1

    s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
	if (ItemID'="")&&(TraID'="") {
		s CH=""
		f  s CH=$o(^DHCAPPTRA(0,"Arc",ItemID,TraID,CH)) Q:CH=""  D
		.s itempartid=$p(^DHCAPPTRA(TraID,"I",CH),"^",1)        //部位
		.Q:itempartid=""
		.s itempartdesc=$p($g(^DHCAPPART(+itempartid)),"^",2)   //部位描述
		.s arcimid=$p(^DHCAPPTRA(TraID,"I",CH),"^",2)
		.s h=h+1
		.s ListData=TraID_"^"_TraID_"||"_CH_"^"_arcimid_"^"_itempartid_"^"_itempartdesc
		.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryCheckPartList",pid,h)=ListData
	}
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="TraID^TraItmID^ItemID^ItemPartID^ItemPart"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryCheckPartList",pid,index),-1) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryCheckPartList",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript: 获取医嘱子类ID
/// w ##Class(web.DHCAPPExaReportQuery).GetArcCat(arcimid)
ClassMethod GetArcCat(arcimid As %String) As %String
{
	n (arcimid)
	Q:arcimid="" ""
	s itmmastid=+$p(arcimid,"||",1)
	s itmmastver=+$p(arcimid,"||",2)
	Q:'$d(^ARCIM(itmmastid,itmmastver,1)) ""
	s itemCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)   ///医嘱子类
	Q:itemCatID="" ""
	s itmArcCatID=$o(^DHCAPARCCA(0,"Arc",arcimid,""))
	if (itmArcCatID=""){
		s itmArcCatID=$o(^DHCAPARCCA(0,"O",itemCatID,""))
		
	}
	Q itmArcCatID
}

/// Descript:  检查分类树
/// w ##class(web.DHCAPPExaReportQuery).jsonCheckCatByPyCodeNew("",2,"E")
ClassMethod jsonCheckCatByPyCodeNew(PyCode As %String, HospID As %String, PyType As %String = "", LocID As %String) As %String
{
	n (PyCode, HospID, PyType,LocID,%session)
	s PyCode=$$ALPHAUP^SSUTIL4(PyCode)
	s count = 0
	Set langid=..%LanguageID()
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s count=0 k TmpArr
	s ID=0
  	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",0,ID)) q:ID=""  d
  	.s Code=$p(^DHCAPPTRA(ID),"^",1)
  	.s Text=$p(^DHCAPPTRA(ID),"^",2)
  	.s TRAHospDr=$p(^DHCAPPTRA(ID),"^",5)
  	.Q:TRAHospDr'=HospID
  	.Q:$p(^DHCAPPTRA(ID),"^",5)'=HospID
  	.q:##class(web.DHCAPPTreeAdd).CheckTreeConfigloc("TreeAdd", ID, HospID, LocID)=0
  	.Q:(PyType'="")&&(PyType'[$p(^DHCAPPTRA(ID),"^",10))		//增加过滤类型 qunianpeng 2018/2/1
  	.Q:'..isExistPyCodeOnChildenNew(ID,PyCode)
  	.s OrdNum=+$p(^DHCAPPTRA(ID),"^",6)
  	.s TmpArr(OrdNum)=ID_"^"_Text_"^"_Code
  	s index=""
  	F  s index=$o(TmpArr(index)) Q:index=""  D
  	.s ID=+$g(TmpArr(index))
  	.s Code=$p(^DHCAPPTRA(ID),"^",1)
  	.s Text=$p(^DHCAPPTRA(ID),"^",2)
  	.Set Text= ##class(User.DHCAppTreeAdd).GetTranByDesc("TRADesc",Text,langid)
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
	.d Stream.Write(..GetCheckTreeChildenByPyCodeNew(ID,PyCode,HospID))
	.d Stream.Write("}")
	d Stream.Write("]")
  	q Stream.Read()
}

/// Descript: 本级节点是否需要显示
ClassMethod isExistPyCodeOnChildenNew(LastLevID As %String, PyCode As %String) As %String
{
	n (LastLevID, PyCode)

	s isExistFlag=0
	/// 不存在下级节点
	s ID=$o(^DHCAPPTRA(0,"LastRowid",LastLevID,""))
	i ID="" D
	.i ($p(^DHCAPPTRA(LastLevID),"^",2)[PyCode)||($p(^DHCAPPTRA(LastLevID),"^",7)[PyCode) D
	..s isExistFlag=1

	Q:ID="" isExistFlag

	s ID=""
	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",LastLevID,ID))  q:(ID="")||(isExistFlag=1)  d
	.s Text=$p(^DHCAPPTRA(ID),"^",2)
	.s isExistFlag=..isExistPyCodeOnChildenNew(ID,PyCode)
	.
	Q isExistFlag
}

///  Descript:	检查分类树孩子节点处理
/// w ##class(web.DHCAPPExaReportQuery).GetCheckTreeChildenByPyCodeNew(114,"",2)
ClassMethod GetCheckTreeChildenByPyCodeNew(patlev, PyCode, HospID = "") As %String
{
	n (patlev,PyCode,HospID,%session)
	Set langid=..%LanguageID()
	s HospID=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    ///  是否存在孩子节点
	s ID=$o(^DHCAPPTRA(0,"LastRowid",patlev,""))
	Q:ID="" ""
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s count=0 k TmpArr	
	s lev=patlev+1
	D Stream.Write(",""children"":[")
	s ID=""
	f  s ID=$o(^DHCAPPTRA(0,"LastRowid",patlev,ID))  q:ID=""  d
	.s Code=$p(^DHCAPPTRA(ID),"^",1)
	.s Text=$p(^DHCAPPTRA(ID),"^",2)
	.s TRAHospDr=$p(^DHCAPPTRA(ID),"^",5)
  	.Q:TRAHospDr'=HospID
	.Q:'..isExistPyCodeOnChildenNew(ID,PyCode)
	.s OrdNum=+$p(^DHCAPPTRA(ID),"^",6)
  	.i OrdNum=0 s OrdNum=Code
  	.s TmpArr(OrdNum)=ID_"^"_Text_"^"_Code
  	s index=""
  	F  s index=$o(TmpArr(index)) Q:index=""  D
  	.s ID=+$g(TmpArr(index))
  	.s Code=$p(^DHCAPPTRA(ID),"^",1)
  	.s Text=$p(^DHCAPPTRA(ID),"^",2)
  	.Set Text= ##class(User.DHCAppTreeAdd).GetTranByDesc("TRADesc",Text,langid)
	.s count = count+1
	.i count=1 d
	..D Stream.Write(##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
	.e  d
	..D Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonTreeStart(ID,Text,Code))
	.D Stream.Write(..GetCheckTreeChildenByPyCodeNew(ID,PyCode,HospID))
	.D Stream.Write("}")
	D Stream.Write("]")
	Q Stream.Read()
}

/// Creator:    bianshuai
/// CreateDate：2017-01-19
/// Descript:   调用知识库检查项目
/// TipsContent 内容分割 目录@目录内容/n目录内容!目录@目录内容
/// W ##Class(web.DHCAPPExaReportQuery).InvokItemLibrary("195","10554||1^","12175^113^29")
ClassMethod InvokItemLibrary(EpisodeID As %String, mListData As %String, userInfo As %String) As %String
{
	n (EpisodeID, mListData, userInfo)
	s ^tempqujian("InvokItemLibrary")=EpisodeID_"$$$$"_mListData_"$$$$"_userInfo
	s TmpListData=""
	F i=1:1:$L(mListData,$c(2)) D
	.s ListData=$p(mListData,$c(2),i)
	.s itmmmastid=$p(ListData,"^",1)
	.s itemPartID=+$p(ListData,"^",2)
	.s itemPart=""
	.i itemPartID'=0 s itemPart=$p(^DHCAPPART(itemPartID),"^",1)   /// 部位代码
	.s TmpListData=$s(TmpListData'="":TmpListData_$c(2)_itmmmastid_"^^^^^^^^^^"_itemPart,1:itmmmastid_"^^^^^^^^^^"_itemPart)
	.
	s OrdIDStr=##class(web.DHCDocService).GetAdmOrdStr(EpisodeID)
	s mListData=EpisodeID_"!"_TmpListData_"!"_OrdIDStr
	s TipsMessage = ##Class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"C",mListData,userInfo)
    Q TipsMessage
}

/// Descript: 提取检查项目说明书
/// W ##Class(web.DHCAPPExaReportQuery).GetItemInstr("3844||1","232")
ClassMethod GetItemInstr(itmmastid As %String, itemPartID As %String, OrderLabSpecRowid As %String = "") As %String
{
	n (itmmastid, itemPartID, OrderLabSpecRowid)
	s ListTitle="itemTile^itemContent"
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s itemPart=""
	i itemPartID'="" s itemPart=$p(^DHCAPPART(+itemPartID),"^",1)   /// 部位代码
	s mParam="!"_itmmastid_"^^^^^^^^^"_OrderLabSpecRowid_"^"_itemPart
	/// 调用知识库函数,提取内容
	s mListData = ##Class(web.DHCSTPHCMPASS).CheckLibPha(.RetStr,"Q",mParam,"")
	s mListData=$p(mListData,"^",3)
	s num=0
	F i=1:1:$L(mListData,"!")  D
	.s mData=$p(mListData,"!",i)
	.Q:mData=""
	.s num=num+1
	.s itemTile=$p(mData,"@/$",1)   /// 分隔符????
	.s itemContent=$p(mData,"@/$",2)
	.s mItemContent=""
	.F m=1:1:$L(itemContent,"/n")  D
	..s mItemData=$p(itemContent,"/n",m)
	..Q:mItemData=""
	..s mItemContent=mItemContent_"<p>"_m_"、"_mItemData_"</p>"
	.s ListData=itemTile_"^"_mItemContent
	.i num=1 D
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.E  D
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descritp:	检查方法
/// W ##Class(web.DHCAPPExaReportQuery).jsonExaItemListDoc("7044")
ClassMethod jsonExaItemListDoc(arcItemList As %String, LinkFlag As %String, HospID As %String) As %String
{
	n (arcItemList, LinkFlag, HospID, %session)
	s count = 0
	Set langid=..%LanguageID()
	s Stream=##class(%Stream.GlobalCharacter).%New()
	s del=""""
	d Stream.Write("[{"_del_"id"_del_":"_del_"0"_del_","_del_"text"_del_":"_del_"项目列表"_del_","_del_"items"_del_":")
	d Stream.Write("[")
	s Len=$L(arcItemList,"@")
	f i=1:1:Len D
	.s itmmaststr=$p(arcItemList,"@",i)
	.s arcimid=$p(itmmaststr,"^",4)   /// 医嘱项ID
	.s PartFlag=$p(itmmaststr,"^",6)  /// 部位串
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcEndDate=$p(^ARCIM(itmmastid,itmmastver,7),"^",1)		//sufan 2018-11-21 增加医嘱不可用判断
	.Q:(arcEndDate'="")&&(arcEndDate<+$H)
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  //医嘱项名称
	.s arcitmdesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcitmdesc,langid)
	.s isLinkFlag=##Class(web.DHCAPPExaReportQuery).isExistLinkPartNoTraID(arcimid,HospID) /// 关联部位标示
	.Q:(LinkFlag'=isLinkFlag)&(LinkFlag=0)&(PartFlag="")
	.Q:(LinkFlag=isLinkFlag)&(LinkFlag=1)&(PartFlag'="")
	.Q:(LinkFlag'=isLinkFlag)&(LinkFlag=1)
	.s PartLabel=""
	.i (LinkFlag=0)&(PartFlag'="") D
	..s PartLabel=" + "_..GetPartLabel($p(itmmaststr,"^",6,7)) ///部位描述
	.s itmmaststr=$REPLACE(itmmaststr,"A","@")
	.s itmmaststr=$REPLACE(itmmaststr,"B","$$")
	.s itmmaststr=$REPLACE(itmmaststr,"^","*")
	.s itmmaststr=$REPLACE(itmmaststr,"||","_")
	.s ListData=itmmaststr_"^"_arcitmdesc_PartLabel
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",ListData))
	.
	d Stream.Write("]")
	d Stream.Write("}]")
	Q Stream.Read()
}

/// Creator:    bianshuai
/// CreateDate: 2018-05-25
/// Descript:   取对应的部位串ID和描述内容
/// InPut:      部位B体位,体位A部位B体位^后处理(备注：部位串之间使用A分隔；部位和体位之间使用B分隔)
/// OutPut:     检查项目部位描述内容
/// w ##Class(web.DHCAPPExaReportQuery).GetPartLabel("10B1A12B1,2^1")
ClassMethod GetPartLabel(mListData As %String, langid As %String = "") As %String
{
	n (mListData,langid,%session)
	Q:mListData="" ""
	s mListData=$Replace(mListData,"*","^")
	s PartList=$p(mListData,"^",1)  /// 部位串
	s DispStr=$p(mListData,"^",2)     /// 后处理
	Set:langid="" langid=..%LanguageID()
	s DispDesc=""
	s DispDim=$SELECT(DispStr["@":"@",1:",")
	for i=1:1:$L(DispStr,DispDim){
		s DispID=$P(DispStr,DispDim,i)
		continue:DispID=""
		s DispMDesc=$p($g(^DHCAPDIM(+DispID)),"^",2)
		Set DispMDesc= ##class(User.DHCAppDispMedthod).GetTranByDesc("ADDesc",DispMDesc,langid)
		i DispDesc="" s DispDesc=DispMDesc
		e  s DispDesc=DispDesc_"+"_DispMDesc
	}
	s Ret=""
	for i=1:1:$L(PartList,"A"){
		s OnePartInfo=$P(PartList,"A",i)
		continue:OnePartInfo=""
		s PartID=$p(OnePartInfo,"B",1)
		s PartDesc=$p($G(^DHCAPPART(+PartID)),"^",2) 
		s PartDesc=##class(User.DHCAppPart).GetTranByDesc("APDesc",PartDesc,langid)
		s PosiIDs=$p(OnePartInfo,"B",2)
		s PosiDesc=""
		for j=1:1:$L(PosiIDs,","){
			s PosiID=$P(PosiIDs,",",j)
			continue:PosiID=""
			continue:'$D(^DHCAPPOS(PosiID))
			s MPosiDesc=$p(^DHCAPPOS(PosiID),"^",2)
			s MPosiDesc=##class(User.DHCAppPosition).GetTranByDesc("APDesc",MPosiDesc,langid)
			i PosiDesc="" s PosiDesc=MPosiDesc
			e  s PosiDesc=PosiDesc_","_MPosiDesc
		}
		s:PosiDesc'="" PartDesc=PartDesc_"("_PosiDesc_")"
		i Ret="" s Ret=PartDesc
		e  s Ret=Ret_"、"_PartDesc
	}
	s:Ret'="" Ret="["_Ret_"]"
	s:DispDesc'="" Ret=DispDesc_Ret
	Q Ret
}

/// Creator:    bianshuai
/// CreateDate: 2018-05-25
/// Descritp:   通过体位ID获取体位描述内容
/// w ##Class(web.DHCAPPExaReportQuery).GetPosiDesc("1")
ClassMethod GetPosiDesc(mPosiID As %String) As %String
{
	n (mPosiID)
	s mPosiDesc=""
	F n=1:1:$L(mPosiID,",") D
	.s PosiID=$p(mPosiID,",",n)
	.q:PosiID=""
	.s PosiDesc=$p(^DHCAPPOS(PosiID),"^",2)   /// 体位
	.i mPosiDesc="" s mPosiDesc=PosiDesc
	.E  s mPosiDesc=mPosiDesc_"、"_PosiDesc
	.
	Q mPosiDesc
}

/// Descritp:	检查部位对应体位
/// W ##Class(web.DHCAPPExaReportQuery).GetRepPosiID("4||1||1")
ClassMethod GetRepPosiID(arPartID As %String) As %String
{
	n (arPartID)
	s tempPosiID=""
	s arPosiID=""
	f  s arPosiID=$o(^DHCAPREPO(0,"RepPart",arPartID,arPosiID)) Q:arPosiID=""  D
	.s PosiID=$p(^DHCAPREPO(arPosiID),"^",2)
	.Q:PosiID=""
	.i tempPosiID = "" s tempPosiID=PosiID
	.e  s tempPosiID=tempPosiID_","_PosiID
	Q tempPosiID
}

/// Descritp:	检查部位对应体位
/// W ##Class(web.DHCAPPExaReportQuery).GetRepPosi("4||1||1")
ClassMethod GetRepPosi(arPartID As %String) As %String
{
	n (arPartID,%session)
	Set langid=..%LanguageID()
	s tempPosi=""
	s arPosiID=""
	f  s arPosiID=$o(^DHCAPREPO(0,"RepPart",arPartID,arPosiID)) Q:arPosiID=""  D
	.s PosiID=$p(^DHCAPREPO(arPosiID),"^",2)
	.Q:PosiID=""
	.s PosiDesc=$p($G(^DHCAPPOS(PosiID)),"^",2)	   /// 体位
	.q:PosiDesc=""
	.s PosiDesc=##class(User.DHCAppPosition).GetTranByDesc("APDesc",PosiDesc,langid)
	.i tempPosi = "" s tempPosi=PosiDesc
	.e  s tempPosi=tempPosi_","_PosiDesc
	Q tempPosi
}

/// Descritp:	检查部位对应体位
/// W ##Class(web.DHCAPPExaReportQuery).GetRepDispID("4||1||1")
ClassMethod GetRepDispID(arReqArcID As %String) As %String
{
	n (arReqArcID)
	s arReqID=+arReqArcID
	s CH=$p(arReqArcID,"||",2)
	s tempDispID=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"DI",Sub)) Q:Sub=""  D
	.s DispID=$p(^DHCAPREP(arReqID,"AR",CH,"DI",Sub),"^",1) ///后处理ID
	.Q:DispID=""
	.i tempDispID = "" s tempDispID=DispID
	.e  s tempDispID=tempDispID_","_DispID
	Q tempDispID
}

/// Descritp:	检查部位对应体位
/// W ##Class(web.DHCAPPExaReportQuery).GetRepDisp("4||1||1")
ClassMethod GetRepDisp(arReqArcID As %String) As %String
{
	n (arReqArcID,%session)
	s arReqID=+arReqArcID
	Set langid=..%LanguageID()
	s CH=$p(arReqArcID,"||",2)
	s tempDisp=""
	s Sub=""
	f  s Sub=$o(^DHCAPREP(arReqID,"AR",CH,"DI",Sub)) Q:Sub=""  D
	.s DispID=$p(^DHCAPREP(arReqID,"AR",CH,"DI",Sub),"^",1) ///后处理ID
	.Q:DispID=""
	.s DispDesc=$p($g(^DHCAPDIM(DispID)),"^",2) 			    ///后处理描述
	.Set DispDesc= ##class(User.DHCAppDispMedthod).GetTranByDesc("ADDesc",DispDesc,langid)
	.i tempDisp = "" s tempDisp=DispDesc
	.e  s tempDisp=tempDisp_","_DispDesc
	Q tempDisp
}

/// Descript:  获取检查申请医嘱总费用
/// Input:     oeori-医嘱ID,PartID-部位ID
/// OutPut:    折后费用^费用
/// w ##Class(web.DHCAPPExaReportQuery).GetExaReqPartCost("354||122","374")
ClassMethod GetExaReqPartCost(oeori As %String, PartID As %String) As %String
{
	n (oeori,PartID)
	s TarDiscCost=0,TarCost=0
	s EpisodeID=$p(^OEORD(+oeori),"^",1)	/// 就诊ID
	s TarID=""
	f  s TarID=$o(^DHCAPREPTA(0,"OrdItem",oeori,TarID)) Q:TarID=""  D
	.s TarBilled=$p(^DHCAPREPTA(TarID),"^",9)    /// 计费标志
	.Q:(TarBilled="I")||(TarBilled="R")
	.s TarType=$p(^DHCAPREPTA(TarID),"^",3)      /// 类型
	.s TarPartID=$p(^DHCAPREPTA(TarID),"^",1)    /// 部位ID
	.//Q:(PartID'="")&(TarPartID'=PartID)&(TarPartID'="")          /// 筛选部位
	.Q:(PartID'="")&(TarPartID'=PartID)&(TarType'="D")
	.s TarItmID=$p(^DHCAPREPTA(TarID),"^",5)     /// 收费项ID
	.s TarPrice=##Class(web.DHCAPPInterface).GetTarPrice(TarItmID,EpisodeID) /// 取收费项价格
	.s TarDisc=$p(^DHCAPREPTA(TarID),"^",4)      /// 打折系数
	.s TarQty=$p(^DHCAPREPTA(TarID),"^",8)       /// 数量
	.if ((TarPartID="")&(PartID'="")) d
	..s SubTarID="" f  s SubTarID=$o(^DHCAPREPTA(0,"OrdItem",oeori,SubTarID)) Q:SubTarID=""  D
	...s SubTarBilled=$p(^DHCAPREPTA(SubTarID),"^",9)    /// 计费标志
	...Q:(SubTarBilled="I")||(SubTarBilled="R")
	...s SubTarPartID=$p(^DHCAPREPTA(SubTarID),"^",1)    /// 部位ID
	...Q:(PartID'="")&(SubTarPartID'=PartID)         /// 筛选部位
	...;s TarDisc=$p(^DHCAPREPTA(SubTarID),"^",4)      /// 打折系数
	...;s TarQty=$p(^DHCAPREPTA(SubTarID),"^",8)       /// 数量
	.s TarDiscCost=TarDiscCost+(TarPrice*TarDisc*TarQty)
	.s TarCost=TarCost+(TarPrice*TarQty)
	.
	Q TarDiscCost_"^"_TarCost
}

/// Descript:  取系统自动打印状态
/// w ##Class(web.DHCAPPExaReportQuery).GetAutoPrintFlag("87","2^191^4634^169")
ClassMethod GetAutoPrintFlag(EpisodeID As %String, LgParam As %String, Type As %String = "Exa") As %String
{
	n (EpisodeID, LgParam,%session,Type)
	s ^tmplog("GetAutoPrintFlag")=$lb(EpisodeID, LgParam,Type)
	Q:EpisodeID="" ""
	s PatType=$p(^PAADM(EpisodeID),"^",2)  /// 就诊类型
	Q:PatType="" ""
	s HospID=$p(LgParam,"^",1) 
	Q ##Class(DHCDoc.DHCApp.BasicConfig).GetAppPrtSetConfig(PatType,Type,LgParam)
	
	if (Type="Exa"){
		s PrintExa=##Class(DHCDoc.DHCApp.BasicConfig).GetConfigNode("PrintExa",HospID)
		if (PrintExa[PatType) {q 1}else{q 0}
		}
	if (Type="Lab"){
		s PrintLab=##Class(DHCDoc.DHCApp.BasicConfig).GetConfigNode("PrintLab",HospID)
		if (PrintLab[PatType) {q 1}else{q 0}
		}
	/*s resVal=..GetEmSysConfig("AUTOPRINT", LgParam)
	Q:resVal=2 1
	Q:(resVal=1)&((PatType="O")||(PatType="E")) 1
	Q:(resVal=3)&(PatType="I") 1*/
	Q 0
}

/// Descript:  取系统参数配置
/// w ##class(web.DHCAPPExaReportQuery).GetEmSysConfig("INSERTDOC")
ClassMethod GetEmSysConfig(TypeCode As %String, LgParam As %String) As %String
{
	n (TypeCode, LgParam)
	s LgHospID=$p(LgParam,"^",1)    /// 医院ID
	s LgLocID=$p(LgParam,"^",2)     /// 科室
	s LgUserID=$p(LgParam,"^",3)    /// 用户
	s LgGroupID=$p(LgParam,"^",4)   /// 安全组
	s ResType=##Class(web.DHCAppComPar).GetAppPropValue("DHCAPP",TypeCode,LgHospID,LgLocID,LgUserID,LgGroupID)
	Q ResType
}

/// Descritp:	取检查分类树的类型
/// W ##Class(web.DHCAPPExaReportQuery).GetNodeType("4||1||1")
ClassMethod GetNodeType(ID As %String) As %String
{
	n (ID)
	s ID=$P(ID,"^",1)
	Q:(ID="") ""
	Q:'$d(^DHCAPPTRA(ID)) ""
	s nodeType=$p(^DHCAPPTRA(ID),"^",10)
	Q nodeType
}

/// Descript: 根据医嘱项获取检查分类类型
/// w ##Class(web.DHCAPPExaReportQuery).GetTraType("11108||1")
ClassMethod GetTraType(itmmastid As %String) As %String
{
	n (itmmastid)
	s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,""))
	if (TraID'=""){
		Q ..GetNodeType(TraID)
	}else{
		s ArcimClassification=##class(web.DHCDocOrderCommon).GetArcimClassification(itmmastid)
		if (ArcimClassification="L") q "L"
		if (ArcimClassification="E"){
			s itemCatID=$p(^ARCIM(+itmmastid,$P(itmmastid,"||",2),1),"^",10)   ///医嘱子类
			s itmArcCatID=$o(^DHCAPARCCA(0,"Arc",itmmastid,""))
			if (itmArcCatID=""){
				s itmArcCatID=$o(^DHCAPARCCA(0,"O",itemCatID,""))
				
			}
			Q:itmArcCatID="" "E"
			s ArcCatType=$P(^DHCAPARCCA(itmArcCatID),"^",1)
			s nodeType="E"
			s ID=0
			for {
				s ID=$O(^DHCAPPTRA(ID))
				q:ID=""
				s APPTRAType=$P(^DHCAPPTRA(ID),"^",7)
				if (APPTRAType=ArcCatType) s nodeType=$P(^DHCAPPTRA(ID),"^",10)
				}
			q nodeType
			}
			
		}
	q ""
}

/// Descript: 根据检查分类树节点代码获取明细项目
/// w ##Class(web.DHCAPPExaReportQuery).JsonGetTraItmByCode("LIV")
ClassMethod JsonGetTraItmByCode(Code As %String) As %String
{
	n (Code,%session)
	s LgHospID=%session.Get("LOGON.HOSPID")
	//s TraID=$o(^DHCAPPTRA(0,"Code",Code,""))
	//Q:TraID="" ""
	/// 检查分类
	s itemCatID=$o(^DHCAPARCCA(0,"Code",Code,""))
	Q:itemCatID="" ""
	S itemCatIDsUB=$O(^DHCAPARCCA(itemCatID,"ArcItm",""))
	Q:itemCatIDsUB=""
    s itmmastid=$p($g(^DHCAPARCCA(itemCatID,"ArcItm",itemCatIDsUB)),"^",1)
    Q:itmmastid="" ""
    /// 分类树
    s TraID="",tmpTraID=""
	f  s tmpTraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,tmpTraID)) q:(TraID'="")||(tmpTraID="")  d
	.q:$p(^DHCAPPTRA(tmpTraID),"^",5)'=LgHospID
	.s TraID=tmpTraID
	Q:TraID="" ""
	s Json=##Class(web.DHCAPPExaReportQuery).jsonExaItemList(TraID)
	Q Json
}

/// w ##Class(web.DHCAPPExaReportQuery).JsonGetTraItmByCodeNew("活体组织病理申请单",10)
ClassMethod JsonGetTraItmByCodeNew(Code As %String, LgHospID, LocID) As %String
{
	;n (Code,%session)
	;s LgHospID=%session.Get("LOGON.HOSPID")
	//s TraID=$o(^DHCAPPTRA(0,"Code",Code,""))
	//Q:TraID="" ""
	/// 检查分类
	s ^tempqujina("JsonGetTraItmByCodeNew")=Code_","_LgHospID
	s TraID="0"
	s Json=""
	for {
		s TraID=$O(^DHCAPPTRA(0,"Code",Code,TraID))
		Q:TraID=""
		s TreeHospID=$P(^DHCAPPTRA(TraID),"^",5)
		continue:##class(web.DHCAPPTreeAdd).CheckTreeConfigloc("TreeAdd", TraID, LgHospID, LocID)=0
		continue:TreeHospID'=LgHospID
		s Json=##Class(web.DHCAPPExaReportQuery).jsonExaItemList(TraID,LocID,LgHospID)
	}
	Q Json
}

/// Descript: 取病理分类类型代码
/// w ##Class(web.DHCAPPExaReportQuery).GetPisTypeCode("44")
ClassMethod GetPisTypeCode(itemCatID As %String) As %String
{
	n (itemCatID)
	s TraCode=$P(^DHCAPPTRA(itemCatID),"^",7)
	/*s CH=$o(^DHCAPPTRA(itemCatID,"I",0))
	Q:CH="" ""
	s arcimid=$p(^DHCAPPTRA(itemCatID,"I",CH),"^",2)
	Q:arcimid="" ""
	s TraID=$o(^DHCAPARCCA(0,"Arc",arcimid,""))
	Q:TraID="" ""
	s TraCode=$p(^DHCAPARCCA(TraID),"^",1)*/
	Q TraCode
}

///             =================================以上最新版检查申请===================================
/// 根据session获取参数配置的值
/// w ##class(web.DHCAPPExaReportQuery).GetConfigBySession("INSERTDOC")
ClassMethod GetConfigBySession(Type As %String, HospId As %String = "") As %String
{
	n (Type,HospId,%session)
	if (HospId="") {
		s LgHospID=%session.Get("LOGON.HOSPID")
	}else{
		s LgHospID=HospId
	}
	s LgCtLocID=%session.Get("LOGON.CTLOCID")
	s LgUserID=%session.Get("LOGON.USERID")
	s LgGroupID=%session.Get("LOGON.GROUPID")
	s ResType=##Class(web.DHCAppComPar).GetAppPropValue("DHCAPP",Type,LgHospID,LgCtLocID,LgUserID,LgGroupID)
	Q ResType
}

/// Descript:查询主诉科室模板
/// w ##class(web.DHCAPPExaReportQuery).QuerySymPublicFormat("10","1","306")
ClassMethod QuerySymPublicFormat(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s Saveas=$p(params,"^",1)			/// 截取保存对象Id
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
    s LocDesc=$p(^CTLOC(Saveas),"^",2)			/// 保存对象描述
    s amRowId=0
    f  s amRowId=$o(^DHCAPPATSYT(0,"SaveAs",LocDesc,Saveas,amRowId)) q:amRowId=""  d
    .s EpisodeID=$p(^DHCAPPATSYT(amRowId),"^",1)		/// 患者就诊Id
    .s PatStmTom=$p(^DHCAPPATSYT(amRowId),"^",2)		/// 主诉描述
    .s amSave=$p(^DHCAPPATSYT(amRowId),"^",3)			/// 保存对象
    .s amPointer=$p(^DHCAPPATSYT(amRowId),"^",4)		/// 对象Id
    .s opUserDr=$p(^DHCAPPATSYT(amRowId),"^",5)			/// 操作人Id
    .;s opUsername=$p(^SSU("SSUSR",opUserDr),"^",2)
	.s h=h+1
	.s ListData=amRowId_"^"_EpisodeID_"^"_PatStmTom_"^"_amSave_"^"_amPointer_"^"_opUserDr
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySymPublicFormat",pid,h)=ListData
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="amRowId^EpisodeID^PatStmTom^amSave^amPointer^opUserDr"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySymPublicFormat",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySymPublicFormat",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript:查询主诉个人模板
/// w ##class(web.DHCAPPExaReportQuery).QueryPersonalFormat("10","1","2874")
ClassMethod QuerySymPersonalFormat(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s Saveas=$p(params,"^",1)		/// 截取保存对象Id
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
    s SaveDesc=$p(^SSU("SSUSR",Saveas),"^",2)		/// 保存对象描述
    s amRowId=0
    f  s amRowId=$o(^DHCAPPATSYT(0,"SaveAs",SaveDesc,Saveas,amRowId)) q:amRowId=""  d
    .s EpisodeID=$p(^DHCAPPATSYT(amRowId),"^",1)		/// 患者就诊Id
    .s PatStmTom=$p(^DHCAPPATSYT(amRowId),"^",2)		/// 主诉描述
    .s amSave=$p(^DHCAPPATSYT(amRowId),"^",3)			/// 保存对象
    .s amPointer=$p(^DHCAPPATSYT(amRowId),"^",4)		/// 对象Id
    .s opUserDr=$p(^DHCAPPATSYT(amRowId),"^",5)			/// 操作人Id
    .;s opUsername=$p(^SSU("SSUSR",opUserDr),"^",2)
	.s h=h+1
	.s ListData=amRowId_"^"_EpisodeID_"^"_PatStmTom_"^"_amSave_"^"_amPointer_"^"_opUserDr
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySymPersonalFormat",pid,h)=ListData
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="amRowId^EpisodeID^PatStmTom^amSave^amPointer^opUserDr"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySymPersonalFormat",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySymPersonalFormat",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript:查询现病史科室模板
/// w ##class(web.DHCAPPExaReportQuery).QueryPreHisList("10","1")
ClassMethod QueryPrehisPublicFormat(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s Saveas=$p(params,"^",1)		/// 截取保存对象Id
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
    s LocDesc=$p(^CTLOC(Saveas),"^",2)		/// 保存对象描述
    s apRowId=0
    f  s apRowId=$o(^DHCAPPREHT(0,"SaveAs",LocDesc,Saveas,apRowId)) q:apRowId=""  d
    .s EpisodeID=$p(^DHCAPPREHT(apRowId),"^",1)		/// 患者就诊Id
    .s PatPreHis=$p(^DHCAPPREHT(apRowId),"^",2)		/// 现病史描述
    .s apSave=$p(^DHCAPPREHT(apRowId),"^",3)		/// 保存对象
    .s apPointer=$p(^DHCAPPREHT(apRowId),"^",4)		/// 对象Id
    .s opUserDr=$p(^DHCAPPREHT(apRowId),"^",5)		/// 操作人Id
	.s h=h+1
	.s ListData=apRowId_"^"_EpisodeID_"^"_PatPreHis_"^"_apSave_"^"_apPointer_"^"_opUserDr
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPrehisPublicFormat",pid,h)=ListData
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="apRowId^EpisodeID^PatPreHis^apSave^apPointer^opUserDr"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPrehisPublicFormat",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPrehisPublicFormat",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript:查询现病史个人模板
/// w ##class(web.DHCAPPExaReportQuery).QueryPreHisList("10","1")
ClassMethod QueryPrehisPersonalFormat(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s Saveas=$p(params,"^",1)		/// 截取保存对象Id
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
    s SaveDesc=$p(^SSU("SSUSR",Saveas),"^",2)     /// 保存对象描述
    s apRowId=0
    f  s apRowId=$o(^DHCAPPREHT(0,"SaveAs",SaveDesc,Saveas,apRowId)) q:apRowId=""  d
    .s EpisodeID=$p(^DHCAPPREHT(apRowId),"^",1)		/// 患者就诊Id
    .s PatPreHis=$p(^DHCAPPREHT(apRowId),"^",2)		/// 现病史描述
    .s apSave=$p(^DHCAPPREHT(apRowId),"^",3)		/// 保存对象
    .s apPointer=$p(^DHCAPPREHT(apRowId),"^",4)		/// 对象Id
    .s opUserDr=$p(^DHCAPPREHT(apRowId),"^",5)		/// 操作人Id
	.s h=h+1
	.s ListData=apRowId_"^"_EpisodeID_"^"_PatPreHis_"^"_apSave_"^"_apPointer_"^"_opUserDr
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPrehisPersonalFormat",pid,h)=ListData
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="apRowId^EpisodeID^PatPreHis^apSave^apPointer^opUserDr"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPrehisPersonalFormat",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPrehisPersonalFormat",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript:查询体征科室模板
/// w ##class(web.DHCAPPExaReportQuery).QuerySignPublicFormat("10","1","306")
ClassMethod QuerySignPublicFormat(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s Saveas=$p(params,"^",1)      /// 截取保存对象Id
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
    s LocDesc=$p(^CTLOC(Saveas),"^",2)    /// 保存对象描述
    s aptRowId=""
    f  s aptRowId=$o(^DHCAPATST(0,"SaveAs",LocDesc,Saveas,aptRowId)) q:aptRowId=""  d
    .s EpisodeID=$p(^DHCAPATST(aptRowId),"^",1)		/// 患者就诊Id
    .s PatSign=$p(^DHCAPATST(aptRowId),"^",2)		/// 体征描述
    .s aptSave=$p(^DHCAPATST(aptRowId),"^",3)		/// 保存对象
    .s aptPointer=$p(^DHCAPATST(aptRowId),"^",4)	/// 对象Id
    .s optUserDr=$p(^DHCAPATST(aptRowId),"^",5)		/// 操作人Id
	.s h=h+1
	.s ListData=aptRowId_"^"_EpisodeID_"^"_PatSign_"^"_aptSave_"^"_aptPointer_"^"_optUserDr
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySignPublicFormat",pid,h)=ListData
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="aptRowId^EpisodeID^PatSign^aptSave^aptPointer^optUserDr"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySignPublicFormat",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySignPublicFormat",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript:查询体征个人模板
/// w ##class(web.DHCAPPExaReportQuery).QuerySignPersonalFormat("10","1")
ClassMethod QuerySignPersonalFormat(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s Saveas=$p(params,"^",1)    /// 截取保存对象Id
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
    s SaveDesc=$p(^SSU("SSUSR",Saveas),"^",2)  /// 保存对象描述
    s aptRowId=""
    f  s aptRowId=$o(^DHCAPATST(0,"SaveAs",SaveDesc,Saveas,aptRowId)) q:aptRowId=""  d
    .s EpisodeID=$p(^DHCAPATST(aptRowId),"^",1)     /// 患者就诊Id
    .s PatSign=$p(^DHCAPATST(aptRowId),"^",2)		/// 体征描述
    .s aptSave=$p(^DHCAPATST(aptRowId),"^",3)		/// 保存对象
    .s aptPointer=$p(^DHCAPATST(aptRowId),"^",4)	/// 对象Id
    .s optUserDr=$p(^DHCAPATST(aptRowId),"^",5)		/// 操作人Id
	.s h=h+1
	.s ListData=aptRowId_"^"_EpisodeID_"^"_PatSign_"^"_aptSave_"^"_aptPointer_"^"_optUserDr
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySignPersonalFormat",pid,h)=ListData
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="aptRowId^EpisodeID^PatSign^aptSave^aptPointer^optUserDr"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySignPersonalFormat",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QuerySignPersonalFormat",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript:查询检查目的科室模板
/// w ##class(web.DHCAPPExaReportQuery).QueryPurPublicFormat("10","1","6")
ClassMethod QueryPurPublicFormat(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s Saveas=$p(params,"^",1)      /// 截取保存对象Id
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
    s LocDesc=$p(^CTLOC(Saveas),"^",2)    /// 保存对象描述
    s aptRowId=""
    f  s aptRowId=$o(^DHCAPPPUR(0,"SaveAs",LocDesc,Saveas,aptRowId)) q:aptRowId=""  d
    .s EpisodeID=$p(^DHCAPPPUR(aptRowId),"^",1)		/// 患者就诊Id
    .s PatPur=$p(^DHCAPPPUR(aptRowId),"^",2)		/// 体征描述
    .s aptSave=$p(^DHCAPPPUR(aptRowId),"^",3)		/// 保存对象
    .s aptPointer=$p(^DHCAPPPUR(aptRowId),"^",4)	/// 对象Id
    .s optUserDr=$p(^DHCAPPPUR(aptRowId),"^",5)		/// 操作人Id
	.s h=h+1
	.s ListData=aptRowId_"^"_EpisodeID_"^"_PatPur_"^"_aptSave_"^"_aptPointer_"^"_optUserDr
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPurPublicFormat",pid,h)=ListData
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="aptRowId^EpisodeID^PatPur^aptSave^aptPointer^optUserDr"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPurPublicFormat",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPurPublicFormat",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript:查询体征个人模板
/// w ##class(web.DHCAPPExaReportQuery).QuerySignPersonalFormat("10","1","359")
ClassMethod QueryPurPersonalFormat(rows As %String, page As %String, params As %String) As %String
{
	n (rows, page, params)
	s End = page*rows
	s Start=(page-1)*rows+1
	s Saveas=$p(params,"^",1)    /// 截取保存对象Id
	s pid=..NewPid()
    d ..killTmpGlobal(pid) //k掉临时global
    s h=0,count=0
    s SaveDesc=$p(^SSU("SSUSR",Saveas),"^",2)  /// 保存对象描述
    s aptRowId=""
    f  s aptRowId=$o(^DHCAPPPUR(0,"SaveAs",SaveDesc,Saveas,aptRowId)) q:aptRowId=""  d
    .s EpisodeID=$p(^DHCAPPPUR(aptRowId),"^",1)     /// 患者就诊Id
    .s PatPur=$p(^DHCAPPPUR(aptRowId),"^",2)		/// 体征描述
    .s aptSave=$p(^DHCAPPPUR(aptRowId),"^",3)		/// 保存对象
    .s aptPointer=$p(^DHCAPPPUR(aptRowId),"^",4)	/// 对象Id
    .s optUserDr=$p(^DHCAPPPUR(aptRowId),"^",5)		/// 操作人Id
	.s h=h+1
	.s ListData=aptRowId_"^"_EpisodeID_"^"_PatPur_"^"_aptSave_"^"_aptPointer_"^"_optUserDr
	.s ^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPurPersonalFormat",pid,h)=ListData
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEmptySign(h)) //输出json结尾符
		Q Stream.Read()
	}
	
	///转换数据为Json格式
	S ListTitle="aptRowId^EpisodeID^PatPur^aptSave^aptPointer^optUserDr"
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonStartSign(h)) //输出json前缀串
	s index=""
	f  s index=$o(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPurPersonalFormat",pid,index)) q:index=""  d
	.s ListData=$g(^TMP("DHCST","web.DHCAPPExaReportQuery","QueryPurPersonalFormat",pid,index))
	.s count = count+1
	.q:(count<Start)||(count>End)
	.I count=Start d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonEndSign()) //输出json结尾符
	d ..killTmpGlobal(pid) //k掉临时global
	q Stream.Read()
}

/// Descript : 根据医嘱项ID取检查分类及其他大的分类
/// w ##class(web.DHCAPPExaReportQuery).GetExacatByItmId("3&11221||1","User^2874")
ClassMethod GetExacatByItmId(ExaIdList As %String, SaveObj As %String) As %String
{
	n (ExaIdList,SaveObj)
	s SaveAs=$p(SaveObj,"^",1)					/// 保存对象
	s Pointer=$p(SaveObj,"^",2)					/// 对象Id
	s ItmId=$p(ExaIdList,"^",1)					/// 医嘱项Id
	s TraId=$p(ExaIdList,"&",1)					/// 分类Id
	s TraCode=$p(^DHCAPPTRA(TraId),"^",1)		/// 分类代码
	s TraDesc=$p(^DHCAPPTRA(TraId),"^",2)		/// 分类描述
	s LastRowid=$p(^DHCAPPTRA(TraId),"^",4)		/// 上一级的Id
	s Alias=$p(^DHCAPPTRA(TraId),"^",7)			/// 分类别名
	s HospId=$p(^DHCAPPTRA(TraId),"^",5)		/// 医院Id
	s Listdata=TraCode_"^"_TraDesc_"^"_LastRowid_"^"_Alias_"^"_HospId_"^"_SaveAs_"^"_Pointer
	
	s Listdata=..GetExaDataList(Listdata,LastRowid,SaveObj)
	q Listdata
}

/// 递归获取主表信息
ClassMethod GetExaDataList(Listdata As %String, LastRowid As %String, SaveObj) As %String
{
	n (Listdata,LastRowid,SaveObj)
	s SaveAs=$p(SaveObj,"^",1)    				/// 保存对象
	s Pointer=$p(SaveObj,"^",2)	  				/// 对象Id
	s TraCode=$p(^DHCAPPTRA(LastRowid),"^",1)	/// 分类代码
	s TraDesc=$p(^DHCAPPTRA(LastRowid),"^",2)	/// 分类描述
	s LastId=$p(^DHCAPPTRA(LastRowid),"^",4)	/// 上一级的Id
	s HospId=$p(^DHCAPPTRA(LastRowid),"^",5)	/// 医院Id
	s Alias=$p(^DHCAPPTRA(LastRowid),"^",7)		/// 分类别名
	s sListdata=TraCode_"^"_TraDesc_"^"_LastId_"^"_Alias_"^"_HospId_"^"_SaveAs_"^"_Pointer_"^"_SaveAs_"^"_Pointer
	s Listdata=sListdata_"$$"_Listdata
	if LastId'=0  d
	.s Listdata=..GetExaDataList(Listdata,LastId,SaveObj)   /// 递归获取主表信息
	q Listdata
}

/// Creator: 	sufan
/// CreateDate: 2018-02-02
/// Descript: 	取检验标本
/// Input:
/// Return:
/// Others:w ##class(web.DHCAPPExaReportQuery).GetSpeJsonData(1)
ClassMethod GetSpeJsonData(HospID As %String) As %String
{
	n (HospID)
	s SpecID="",count=0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	for  s SpecID=$o(^dbo.BTSpecimenD(SpecID)) q:SpecID=""  d
	.s SpeCode=$List(^dbo.BTSpecimenD(SpecID),2)		//标本代码
	.s SpeName=$List(^dbo.BTSpecimenD(SpecID),3)		//标本名称
	.s SpeHosp=$List(^dbo.BTSpecimenD(SpecID),6)		//医院标识
	.q:(HospID'="")&&(HospID'=SpeHosp)					//医院过滤
	.s count = count+1
	.i count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^Code",SpecID_"^"_SpeName_"^"_SpeCode))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^Code",SpecID_"^"_SpeName_"^"_SpeCode))
	d Stream.Write("]")
	q Stream.Read()
}

/// Descript: 提取医嘱项检验标本
/// w ##Class(web.DHCAPPExaReportQuery).jsonArcItemSpec("5114||1")
ClassMethod jsonArcItemSpec(itmmastid As %String, isDefFlag As %String = "") As %String
{
	n (itmmastid, isDefFlag,%session)
	s mListData=##Class(web.DHCDocOrderCommon).GetLabSpec(itmmastid)
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s Len = $L(mListData,$C(2))
	f i=1:1:Len d
	.s ListData = $p(mListData,$C(2),i)
	.s ID = $p(ListData,$C(3),1)     	/// 标本代码
	.s Desc = $p(ListData,$C(3),2)      /// 标本描述
	.s Default = $p(ListData,$C(3),5)
	.Q:(Default'="Y")&(isDefFlag="Y")
	.s tmp=ID_"^"_Desc
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	d Stream.Write("]")
	q Stream.Read()
}

/// Descript: 获取标本采集部位
/// w ##Class(web.DHCAPPExaReportQuery).jsonArcItemSpecSite("5114||1")
ClassMethod jsonArcItemSpecSite(itmmastid As %String, ItemSpecCode As %String) As %String
{
	n (itmmastid, ItemSpecCode, %session)
	s excode=##class(web.DHCDocOrderCommon).GetExCode(itmmastid)
    s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentSYSHospitalCode("")
    s OrderLabSpecCollectionSiteStr=##Class(DHCLIS.DHCCommon).GetTestSetSpecimenSite(excode,ItemSpecCode,HospitalCode)
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s Len = $L(OrderLabSpecCollectionSiteStr,$C(3))
	f i=1:1:Len d
	.s ListData = $p(OrderLabSpecCollectionSiteStr,$C(3),i)
	.s ID = $p(ListData,$C(2),1)     	/// 采集部位代码
	.s Desc = $p(ListData,$C(2),2)      /// 采集部位描述
	.s tmp=ID_"^"_Desc
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	d Stream.Write("]")
	q Stream.Read()
}

/// Descript: 提取医嘱项检验标本
/// w ##Class(web.DHCAPPExaReportQuery).jsonGetArcItmSpec("5114||1")
ClassMethod jsonGetArcItmSpec(itmmastid As %String, isDefFlag As %String = "") As %String
{
	n (itmmastid, isDefFlag,%session)
	s mListData=##Class(web.DHCDocOrderCommon).GetLabSpec(itmmastid)
	s count = 0, HavFlag=0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s Len = $L(mListData,$C(2))
	f i=1:1:Len d
	.s ListData = $p(mListData,$C(2),i)
	.Q:ListData=""
	.s ID = $p(ListData,$C(3),1)     	/// 标本代码
	.s Desc = $p(ListData,$C(3),2)      /// 标本描述
	.s Default = $p(ListData,$C(3),5)
	.s HavFlag=1
	.Q:(Default'="Y")&(isDefFlag="Y")
	.s tmp=ID_"^"_Desc
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	.e  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	.
	i (HavFlag=0)&(isDefFlag="Y") D
	.d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text","-1^"))
	d Stream.Write("]")
	q Stream.Read()
}

ClassMethod CheckArcItmSpec(itmmastid, HospitalId)
{
	n (itmmastid, HospitalId)
	s LabExcode=""
	s LabExcode=##Class(web.DHCDocOrderCommon).GetExCode(itmmastid)
	;判断检验是否可用
	s LabItemActive=##Class(web.DHCDocOrderCommon).CheckLabItemActive(LabExcode,HospitalId)
	q LabItemActive
}

/// Descript: 提取医嘱项检验标本
/// w ##Class(web.DHCAPPExaReportQuery).GetSpecDesc("9683||1")
ClassMethod GetSpecDesc(SpecCode As %String, HospitalId As %String) As %String
{
	n (SpecCode,HospitalId,%session)
	Q:SpecCode="" ""
	s HospitalCode=##class(web.DHCDocOrderCommon).GetCurrentSYSHospitalCode(HospitalId)
	i $d(^DHCLISBSVersion(1)) d
	. s SpecDesc=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,$g(HospitalCode)),$c(2),2) 
	e  d
	. s SpecDesc=$p($G(^TTAB("SPEC",SpecCode)),"\",1)
	Q SpecDesc
}

/// Creator:    sufan
/// CreateDate: 2018-03-01
/// Descript:   取病理申请对应的检查分类
/// w ##Class(web.DHCAPPExaReportQuery).GetPisReqItmCat("12763")
ClassMethod GetPisReqItmCat(PisReqID As %String, Flag As %String = "", HospID As %String = "") As %String
{
	n (PisReqID, Flag, HospID)
	s CH=$o(^DHCAPPPM(PisReqID,"A",""))
	Q:CH="" ""
	s arcimid=$p(^DHCAPPPM(PisReqID,"A",CH),"^",1)         ///医嘱项目ID
	Q:arcimid="" ""
	s itmArcCatID="" 
	s itmArcCatID = $o(^DHCAPARCCA(0,"Arc",arcimid,""),-1)
	i itmArcCatID="" d
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s itemCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)   ///医嘱子类
	.s itmArcCatID=$o(^DHCAPARCCA(0,"O",itemCatID,""))
	Q:itmArcCatID="" ""
	Q:(HospID'="")&($p(^DHCAPARCCA(itmArcCatID),"^",4)'=HospID) ""
	Q:itmArcCatID="" ""
	s itmArcCatCode=$p(^DHCAPARCCA(itmArcCatID),"^",1)  	/// 检查分类代码
	s itmArcCatDesc=$p(^DHCAPARCCA(itmArcCatID),"^",2)  	/// 检查分类描述
	Q:Flag=1 itmArcCatDesc
	Q itmArcCatCode
}

/// Descript: 取医嘱项加急标志
/// w ##Class(web.DHCAPPExaReportQuery).GetItmEmFlag("1||1")
ClassMethod GetItmEmFlag(arcimid As %String) As %String
{
	n (arcimid)
	Q:arcimid="" ""
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s EmFlag=$p(^ARCIM(itmmastid,itmmastver,9),"^",18)  /// 加急
	Q EmFlag
}

/// Creator:    bianshuai
/// CreateDate: 2018-03-17
/// Descript:   取医嘱ID串
/// InPut:      申请ID串, 
/// w ##Class(web.DHCAPPExaReportQuery).GetExaReqOeori("223","P")
ClassMethod GetExaReqOeori(mReqID As %String, Type As %String) As %String
{
	n (mReqID, Type)
	s $zt="InvErrMsg"
	s mListData=""
	F i=1:1:$L(mReqID,"^") D
	.i Type="P" D
	..s ret=..GetPisItem($p(mReqID,"^",i),"*")
	.E  D
	..s ret=..GetExaItem($p(mReqID,"^",i),"*")
	.i mListData'="" s mListData=mListData_"^"_ret
	.E  s mListData=ret
	Q mListData
InvErrMsg
    Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2018-03-17
/// Descript:   取医嘱ID串
/// InPut:      申请ID串, 
/// w ##Class(web.DHCAPPExaReportQuery).GetRevOeori("223","P")
ClassMethod GetRevOeori(mReqID As %String, Type As %String) As %String
{
	n (mReqID, Type)
	s $zt="InvRevErrMsg"
	s mListData=""
	F i=1:1:$L(mReqID,"^") D
	.i Type="P" D
	..s ret=..GetPisItem($p(mReqID,"^",i))
	.E  D
	..s ret=..GetRevItem($p(mReqID,"^",i))
	.i mListData'="" s mListData=mListData_"^"_ret
	.E  s mListData=ret
	Q mListData
InvRevErrMsg
    Q ""
}

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    取病理申请相关医嘱串
/// w ##Class(web.DHCAPPExaReportQuery).GetExaItem("")
ClassMethod GetExaItem(ID As %String, DimStr As %String = "") As %String
{
	n (ID,DimStr)
	s mListData="", CH=""
	F  s CH=$o(^DHCAPREP(ID,"AR",CH)) Q:CH=""  D
	.s Oeori=$p(^DHCAPREP(ID,"AR",CH),"^",3)      /// 医嘱ID
	.s Oeori=DimStr_Oeori
	.i mListData'="" s mListData=mListData_"^"_Oeori
	.E  s mListData=Oeori
	Q mListData
}

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    取病理申请相关医嘱串
/// w ##Class(web.DHCAPPExaReportQuery).GetPisItem("")
ClassMethod GetPisItem(PisID As %String, DimStr As %String = "") As %String
{
	n (PisID,DimStr)
	Q:PisID="" ""
	s CH="",mListData=""
	F  s CH=$o(^DHCAPPPM(PisID,"A",CH)) Q:CH=""  D
	.s Oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)    /// 医嘱ID
	.s Oeori=DimStr_Oeori
	.i mListData'="" s mListData=mListData_"^"_Oeori
	.E  s mListData=Oeori
	Q mListData
}

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    取病理申请撤销医嘱ID
/// w ##Class(web.DHCAPPExaReportQuery).GetRevItem("")
ClassMethod GetRevItem(arID As %String) As %String
{
	n (arID)
	s ID=$p(arID,"||",1),CH=$p(arID,"||",2)
	Q:'$D(^DHCAPREP(ID,"AR",CH)) ""
	s Oeori=$p(^DHCAPREP(ID,"AR",CH),"^",3)      /// 医嘱ID
	s OeFlag=..GetOeoriStat(Oeori)
	Q:("^C^D^U")'[("^"_OeFlag_"^") ""
	Q Oeori
}

ClassMethod GetBillInfo(EpisodeID, PPFlag, InHosp)
{
	n (EpisodeID,PPFlag,InHosp)
	s BillTypeID=""		/// 费别指针
	s PatType=""        /// 就诊类型
	s BillType=""
	s PatType = $p(^PAADM(EpisodeID),"^",2)
	i PPFlag="N" d
	.s BillTypeID=$P(^PAADM(EpisodeID,1),"^",7)  
	;临床药理调整20211201QP 
	i PPFlag="Y" {
		s AdmType = $p(^PAADM(EpisodeID),"^",2)
		i AdmType="I" {
			;s BillTypeID=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("IPPilotPatAdmReason")
			s BillTypeID=##Class(web.PilotProject.DHCDocPPGroupSeting).GetCFGValue(InHosp,"IPPilotPatAdmReason")
		} else {
			;s BillTypeID=##class(web.PilotProject.DHCDocPPGroupSeting).GetConfigNode("PilotPatAdmReason")
			s BillTypeID=##Class(web.PilotProject.DHCDocPPGroupSeting).GetCFGValue(InHosp,"PilotPatAdmReason")
		}
	}
	s:BillTypeID'="" BillType = $p($g(^PAC("ADMREA",BillTypeID)),"^",2)
	q BillTypeID_"^"_BillType_"^"_PatType
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-12-17
/// Descript:    申请单是否允许编辑
/// InPut:       ID - 申请单ID
/// OutPut:      1 - 允许， 0 - 不允许
/// w ##Class(web.DHCAPPExaReportQuery).JsGetReqEditFlag("1740","","10652^111^134")
ClassMethod JsGetReqEditFlag(ID As %String, Type As %String, LgParams As %String) As %String
{
	n (ID, Type, LgParams)
	s ^BIANSHUAI(123)=$lb(ID, Type, LgParams)
	s ret=""
	i Type="P" {
		s ret=..GetPisItem(ID)  /// 病理医嘱串
	}else{
		s ret=..GetExaItem(ID)  /// 检查医嘱串
	}
	Q:ret="" 1
	s Err=..GetReqEditFlag(ret, LgParams) //$p(ret,"^")
	Q Err
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-12-17
/// Descript:    申请单是否允许编辑
/// InPut:       ID - 申请单ID
/// OutPut:      1 - 允许， 0 - 不允许
/// w ##Class(web.DHCAPPExaReportQuery).GetReqEditFlag("15||346^15||347^15||348^15||349^15||350^15||351","","10209^95^134")
ClassMethod GetReqEditFlag(Oeori As %String, LgParams As %String) As %String
{
	n (Oeori, LgParams)
	s EditFlag=0
	for i=1:1:$l(Oeori,"^") {
		Q:EditFlag=1
		s oneOeori=$p(Oeori,"^",i)
		s EpisodeID=$p(^OEORD(+oneOeori),"^",1)	/// 就诊ID
		s PatType=$p(^PAADM(EpisodeID),"^",2)  	/// 病人类型
		s Billed=""
		i oneOeori'="" s Billed=$p(^OEORD(+oneOeori,"I",$p(oneOeori,"||",2),3),"^",5) /// 医嘱
		i (PatType'="I")&(Billed="P") s EditFlag=0 continue /// 门急诊已收费的项目不允许进行撤销操作
		/// 停医嘱权限判断
		s LgUserID=$p(LgParams,"^",1) s LgCtLocID=$p(LgParams,"^",2) s LgGroupID=$p(LgParams,"^",3)
		i (PatType="I") {
			if (##Class(web.DHCDocMain).CheckCancelOrder(oneOeori,LgUserID,LgCtLocID,LgGroupID)'=1) {
				s OEORIItemStateCode=##class(appcom.OEOrdItem).GetStatusCode(oneOeori)
				if (OEORIItemStateCode="E")  Q
				s EditFlag=0 continue
			}
		}
		s EditFlag=1
	}
	Q EditFlag
}

/// Creator: 	 bianshuai
/// CreateDate:  2018-12-17
/// Descript:    停医嘱权限判断
/// InPut:       OrderItemRowId - 医嘱ID, UserRowId - 用户ID, LocID - 科室ID, GroupID - 安全组ID, Msg - 提示消息
/// OutPut:      1 - 有权限， 0 - 无权限
/// w ##Class(web.DHCAPPExaReportQuery).GetStopPermission("316","")
ClassMethod GetStopPermission(Oeori As %String, LgParams As %String)
{
	n (Oeori, LgParams)
	s EpisodeID=$p(^OEORD(+Oeori),"^",1)	    /// 就诊ID
	s OrdDeptId=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),7),"^",2)	  /// 开单科室
	s LgUserID=$p(LgParams,"^",1)
	s CareProvDR = $p(^SSU("SSUSR",LgUserID),"^",14)
	/// 医护人员类型一致 且 [当前用户]是医嘱[开单科室]的[医护人员] /*开单科室下的医护人员,才可撤销*/
	Q:((CareProvDR>0)&&('$d(^RB("RES",0,"CTPCP",CareProvDR,OrdDeptId)))) 0
	s PAAdmFlag = ##class(web.DHCDocMainOrderInterface).HiddenMenuFlag(EpisodeID)
	/// 医生,费用调整时可撤销  2:"医疗结算",3:"护士结算",4:"财务结算后",5:"不是V7病人"
	Q:(PAAdmFlag>0)&(PAAdmFlag'=2.5) 0
	Q 1
}

ClassMethod GetResultStatus(statusCode As %String) As %String
{
	q:(statusCode="") ""
	s StatusDesc=""
	&sql(SELECT ESC_Desc INTO :StatusDesc FROM Ens_Statuscode WHERE ESC_Code=:statusCode)
	q StatusDesc
}

/// Creator:sufan
/// CreateDate:2019-01-12
/// Descript:取检查目的
/// Input:申请单ID
ClassMethod GetExaPurpose(arRepID As %String) As %String
{
	n (arRepID)
	Q:arRepID="" ""
	s Purpose=""
	&sql(SELECT AR_Purpose INTO :Purpose FROM DHC_AppReport WHERE AR_RowID=:arRepID)
	Q Purpose
}

/// Creator: 	 bianshuai
/// CreateDate:  2019-02-27
/// Descript:    诊断信息
/// Output:      Y-从主表提取会诊意见, N-从子表提取
/// w ##Class(web.DHCAPPExaReportQuery).JsonGetMRDiagnos("19")
ClassMethod JsonGetMRDiagnos(EpisodeID As %String, Type As %String) As %String
{
	n (EpisodeID, Type,%session)
	Set langid=..%LanguageID()
	s count=0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s MRAdmRowid=$p(^PAADM(EpisodeID),"^",61)
	i MRAdmRowid'="" D
	.s obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	.d obj.Execute(MRAdmRowid)
	.F  Quit:'obj.Next()  Do
	..s itmDesc=obj.Data("MRDIAICDCodeDRDesc")
	..s itmID=obj.Data("ID")
	..s CodeRowid=obj.Data("MRDIAICDCodeDR")
	..s MRDesc=obj.Data("MRDIADesc")
	..s MRDesc =##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",MRDesc,langid)
	..s ZYZDFlag=$p($g(^MRC("ID",+CodeRowid)),"^",15) /// 中医诊断标志
	..Q:(Type="GC")&&(ZYZDFlag'="Y") ;取中医诊断,过滤非中医诊断
	..Q:(Type="GX")&&(ZYZDFlag="Y")  ;取西医诊断,过滤中医诊断
	..s MRDIAMRDIADR=$p($g(^MR(+itmID,"DIA",$p(itmID,"||",2))),"^",15)
	..s itmDesc=##class(DHCDoc.Diagnos.Common).GetDiagDesc(itmID,"Y")
	..s itmID=$REPLACE(itmID,"||","-")
	..s tmp=itmID_"^"_itmDesc_"^"_$REPLACE(MRDIAMRDIADR,"||","-")
	..s count = count+1
	..I count=1 d
	...d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text^linkvalue",tmp))
	..E  d
	...d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text^linkvalue",tmp))
	..
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript:	检查申请诊断
/// w ##class(web.DHCAPPExaReportQuery).JsonGetExaRepDiags("365")
ClassMethod JsonGetExaRepDiags(mReqID As %String) As %String
{
	n (mReqID)
	s mPatDiags=$p(^DHCAPREP(mReqID),"^",25)		/// 病人诊断
	s count=0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	s ID=""
	F i=1:1:$L(mPatDiags,"@")  D
	.s MrData=$p(mPatDiags,"@",i)    /// 诊断
	.s MrID=$p(MrData,$C(2),1)       /// 诊断ID
	.s MrID=$p(MrID,$C(4),1)  //2019-07-29 原诊断ID和描述分割符由$C(2)改为$C(4),
	.Q:MrID=""
	.s MrID=$REPLACE(MrID,"||","-")
	.Q:'$d(^MR(+MrID,"DIA",$p(MrID,"-",2)))
	.s MrDesc=$p(MrData,$C(2),2)
	.if MrDesc="" s MrDesc=$p(MrData,$C(4),2)
	.s tmp=MrID_"^"_MrDesc
	.s count = count+1
	.I count=1 d
	..d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	.E  d
	..d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
	d Stream.Write("]")
#;	s count=0
#;	w "["
#;	s ID=""
#;	F  s ID=$o(^DHCAPPATDI(0,"REQ",mReqID,ID)) Q:ID=""  D
#;	.s itmID=$p(^DHCAPPATDI(ID),"^",2)    /// 诊断ID
#;	.Q:itmID=""
#;	.s itmDesc=$p(^DHCAPPATDI(ID),"^",3)  /// 诊断
#;	.s itmID=$REPLACE(itmID,"||","-")
#;	.s tmp=itmID_"^"_itmDesc
#;	.s count = count+1
#;	.I count=1 d
#;	..w ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
#;	.E  d
#;	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
#;	w "]"
	Q Stream.Read()
}

/// w ##class(web.DHCAPPExaReportQuery).GetJsonBillType(35)
ClassMethod GetJsonBillType(EpisodeID)
{
	n (EpisodeID,%session)
	s BillTypeID=$p($g(^PAADM(EpisodeID,1)),"^",7)
	s PAAdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s PrescriptTypeStr=##class(web.DHCDocOrderCommon).GetPrescriptTypeInfo(BillTypeID,PAAdmType)
	s PrescriptTypeStr=$P(PrescriptTypeStr,"^",1)
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	for i=1:1:$L(PrescriptTypeStr,";"){
		s OnePrescriptType=$P(PrescriptTypeStr,";",i)
		s BillTypeRowID=$P(OnePrescriptType,":",1)
		s BillType=$P(OnePrescriptType,":",2)
		s tmp=BillTypeRowID_"^"_BillType	
		s count = count+1
		I count=1 d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
		e  d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))	
	}
	d Stream.Write("]")
	q Stream.Read()
}

/// Descritp:	获取手工绑定医嘱列表
/// w ##Class(web.DHCAPPExaReportQuery).jsonExaCatAppendOrder("27689","11207||1")
ClassMethod jsonExaCatAppendOrder(EpisodeID As %String, ItmmastID As %String, PartID As %String, LogonCtLoc As %String) As %String
{
	n (EpisodeID, ItmmastID,PartID,LogonCtLoc,%session)
	Set langid=..%LanguageID()
	s PAPMIRowid=$P(^PAADM(EpisodeID),"^",1)
	s PatDOB=$P($G(^PAPER(PAPMIRowid,"ALL")),"^",6)
	s Age=$$CalAge^at182(PatDOB,+$H,"","","")
	s Age=$p(Age,"|",12)
	s CurrData=+$P($ZD(+$H,3),"-",3)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ExpStr=EpisodeID_"^"_LogonCtLoc_"^0"
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	if (PartID=""){
		d Stream.Write("]")
		Q Stream.Read()
	}
	k AppendOrderList
	s LinkRowid=""
	for {
		s LinkRowid=$O(^DHCAPARCLARCi("ArcPart",ItmmastID,PartID,LinkRowid))
		q:LinkRowid=""
		s Arcim=$P(^DHCAPARCLARC(LinkRowid),"^",1)
		s ItemCatDR=$p(^ARCIM(+Arcim,$p(Arcim,"||",2),1),"^",10)  /// 医嘱子类ID
		s OrderType=$P(^ARC("IC",ItemCatDR),"^",7)  
		s Qty=$P(^DHCAPARCLARC(LinkRowid),"^",10)
		s AgeLimits=$p(^DHCAPARCLARC(LinkRowid),"^",12) 	///add by tanjishan 2020-06
		s DateLimits=$p(^DHCAPARCLARC(LinkRowid),"^",13)
		s ByHandle=$p(^DHCAPARCLARC(LinkRowid),"^",14)
		if (ByHandle'="Y"){
			continue
		}
		if (AgeLimits'=""){
			if (Age<$P(AgeLimits,"-",1))||(Age>$P(AgeLimits,"-",2)){
				continue
			}
		}
		if (DateLimits'=""){
			if (CurrData<$P(DateLimits,"-",1))||(CurrData>$P(DateLimits,"-",2)){
				continue
			}
		}

		//s BillUOM=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),8)),"^",14) ; ARCIM_BillingUOM_DR
		s BillUOM=##Class(web.DHCDocOrderCommon).GetBillUOMRowID(Arcim,AdmType)
		s BillUOMDesc=$P(^CT("UOM",BillUOM),"^",1)
		s BillUOMDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc",BillUOMDesc,langid)
		s ArcimDesc=$P(^ARCIM(+Arcim,$P(Arcim,"||",2),1),"^",2)
		s ArcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimDesc,langid)
		Set RecDepRowid=$$GetRecloc^DHCDocOrderCommonNew(EpisodeID,Arcim)
		s Check =##Class(web.DHCDocOrderCommon).CheckStockEnough(Arcim, Qty, RecDepRowid,AdmType,ExpStr)
		/*if (+Check<=0){
			continue
		}*/
		s datefrom=$p($g(^ARCIM(+Arcim,$P(Arcim,"||",2),1)),"^",13)
	 	s dateto=$p($g(^ARCIM(+Arcim,$P(Arcim,"||",2),7)),"^",1)
	 	i datefrom>$h continue
	 	i dateto,dateto<$h continue
		i $p($g(^ARCIM(+Arcim,$P(Arcim,"||",2),7)),"^",13)'["Y" continue
		s IncItmHighValueFlag=##Class(web.DHCDocOrderCommon).GetIncItmHighValueFlag(Arcim)
		continue:IncItmHighValueFlag="Y"
		s ArcimDesc=ArcimDesc_Qty_BillUOMDesc
		s ActiveFlag="Y"
		s FormArcimDesc="",NoFormArcimDesc=""
		if (+Check<=0){
			s FormArcimDesc="<font style='color:red;'>无库存</font>"_ArcimDesc
			s NoFormArcimDesc="[无库存]"_ArcimDesc
			s ActiveFlag="N"
		}
		s ArcimInfo=Arcim_"@"_Qty_"@"_ActiveFlag_"@"_$case($g(NoFormArcimDesc),"":ArcimDesc,:$g(NoFormArcimDesc))
		
		s tmp=ArcimInfo_"^"_$case($g(FormArcimDesc),"":ArcimDesc,:$g(FormArcimDesc))
		s count = count+1
		s AppendOrderList($CASE(ActiveFlag,"Y":1,:2),count)=tmp
	}
	//有剩余库存的附加医嘱优先排在前面
	s count=0
	s Loop1=""
	for {
		s Loop1=$O(AppendOrderList(Loop1))
		q:(Loop1="")
		s Loop2=""
		for {
			s Loop2=$O(AppendOrderList(Loop1,Loop2))
			q:(Loop2="")
			s tmp=AppendOrderList(Loop1,Loop2)
			s count = count+1
			I count=1 d
			.d Stream.Write(##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
			e  d
			.d Stream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp))
		}
		
	}
	d Stream.Write("]")
	Q Stream.Read()
}

ClassMethod GetToothInfo(ItemID)
{
	s arReqID=+ItemID
	s CH=$P(ItemID,"||",2)
	s ToothInfo=$g(^DHCAPREP(arReqID,"AR",CH,"ToothInfo"))  
	q ToothInfo
}

ClassMethod GetToothFlag(TraID, Arcim)
{
	s TraID=+TraID
	if (TraID=0){
		s ItemToothFlagCode=""
		s TraID=0
		f  s TraID=$o(^DHCAPPTRA(0,"Arc",Arcim,TraID)) q:((TraID="")||(ItemToothFlagCode'=""))  d
		.s CH=$o(^DHCAPPTRA(0,"Arc",Arcim,TraID,""),-1)
		.q:CH=""
		.s ItemToothFlagCode=$p(^DHCAPPTRA(TraID,"I",CH),"^",6)
	}else{
		s CH=$o(^DHCAPPTRA(0,"Arc",Arcim,TraID,""),-1)
		s ItemToothFlagCode=""
		q:CH=""
		s ItemToothFlagCode=$p(^DHCAPPTRA(TraID,"I",CH),"^",6)
	}
	q ItemToothFlagCode
}

/// w ##class(web.DHCAPPExaReportQuery).GetToothInfoDesc("3576||1")
ClassMethod GetToothInfoDesc(ItemID)
{
	s arReqID=+ItemID
	s CH=$P(ItemID,"||",2)
	s ToothInfo=$g(^DHCAPREP(arReqID,"AR",CH,"ToothInfo")) 
	if ((ToothInfo="")||(ToothInfo="undefined")) q "" 
	s ToothInfoObj={}.%FromJSON(ToothInfo)
	b ;09334
	s Text=""
	s Obj={}.%FromJSON(ToothInfoObj.CurTreat)
	s Text=""
	for j=1:1:Obj.UpLeftAreaTeeth.%Size(){
		s obj=Obj.UpLeftAreaTeeth.%Get(j-1)
		if (Text=""){
			s Text=obj.ToothValue_"."_obj.ToothSurfaceValue
			}else{
			s Text=Text_","_obj.ToothValue_"."_obj.ToothSurfaceValue
			}	
	}
	for j=1:1:Obj.UpRightAreaTeeth.%Size(){
		s obj=Obj.UpRightAreaTeeth.%Get(j-1)
		if (Text=""){
			s Text=obj.ToothValue_"."_obj.ToothSurfaceValue
			}else{
			s Text=Text_","_obj.ToothValue_"."_obj.ToothSurfaceValue
			}	
	}
	for j=1:1:Obj.DownLeftAreaTeeth.%Size(){
		s obj=Obj.DownLeftAreaTeeth.%Get(j-1)
		if (Text=""){
			s Text=obj.ToothValue_"."_obj.ToothSurfaceValue
			}else{
			s Text=Text_","_obj.ToothValue_"."_obj.ToothSurfaceValue
			}	
	}
	for j=1:1:Obj.DownRightAreaTeeth.%Size(){
		s obj=Obj.DownRightAreaTeeth.%Get(j-1)
		if (Text=""){
			s Text=obj.ToothValue_"."_obj.ToothSurfaceValue
			}else{
			s Text=Text_","_obj.ToothValue_"."_obj.ToothSurfaceValue
			}	
	}
	if (Text'="") s Text="牙位-("_Text_")"
	q Text
}

/// 判断是否可以录入小数
ClassMethod AllowEntryDecimalItemCat(ARCIMRowid, Adm, HospID)
{
	s rtn=0
	s ItemCatRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",10)
	s AllowEntryDecimalItemCat=##Class(web.DHCDocOrderCommon).GetAllowEntryDecimalItemCat(Adm,HospID)
	if ("^"_AllowEntryDecimalItemCat_"^")'[("^"_ItemCatRowid_"^"){
		s NotLimitQty=##class(web.DHCOEOrdItem).GetItemNotLimitQtyFlag(ARCIMRowid)
		s ItemServiceFlag=##Class(web.DHCDocOrderCommon).GetItemServiceFlag(ARCIMRowid)
 			if (ItemServiceFlag=1)&&(NotLimitQty'="Y"){
	 			s rtn=1
	 			}
		}
	q rtn
}

}
