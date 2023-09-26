Class web.DHCAPPPrintCom Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      huaxiaoying
/// CreatDate：    2016-04-21
/// Description:   获取打印各项所需数据
/// Table：        
/// Input：	      RepID：检查报告申请表 DHC_AppReport ROWID             
/// Return：       json串串
/// Other:         w ##class(web.DHCAPPPrintCom).getData(6289327)
ClassMethod getData(RepID)
{
    set PACat=$p(^DHCAPREP(RepID),"^",7)
	//set PACatDesc=$p(^DHCAPARCCA(PACat),"^",1)		//医嘱子类描述
	s ItmCatCode=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(RepID) /// 检查分类项目代码 bianshuai 2016-07-29
	s ItmCatDesc=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(RepID,1) /// 检查分类项目描述 bianshuai 2016-07-29
	i ItmCatDesc'="" s ItmCatDesc=$E(ItmCatDesc,1,2)
	set PAAdm=$p(^DHCAPREP(RepID),"^",6)
	;set ARData=$p(^DHCAPREP(RepID),"^",2)
	set ARTime=$p(^DHCAPREP(RepID),"^",3)
	set ARTime=..%ZT(ARTime)
	set ARDocID=$p(^DHCAPREP(RepID),"^",4)
	set ARDocName=$p(^SSU("SSUSR",ARDocID),"^",2) //申请医生
	s ARDocName=##Class(web.DHCAPPExaReportQuery).FilerEngLetChar(ARDocName)
	set ARExecLoc=$p(^DHCAPREP(RepID),"^",5)
	s ARExecLocCode=$p(^CTLOC(ARExecLoc),"^",2) ///接收科室
	s arExecLocAdrr=$p(^CTLOC(ARExecLoc),"^",16) ///接收科室地址
	s PatDiagDesc1="",PatDiagDesc2=""
	s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(PAAdm,",") //诊断
	i $L(PatDiagDesc)>48 D
	.s PatDiagDesc1=$E(PatDiagDesc,1,48)
	.s PatDiagDesc2=$E(PatDiagDesc,48,$L(PatDiagDesc))
	E  s PatDiagDesc1=PatDiagDesc
    s deplocdr=$p(^PAADM(PAAdm),"^",4)
    s deplocdesc=$p(^CTLOC(deplocdr),"^",2)
    i deplocdesc["-" s deplocdesc=$p(deplocdesc,"-",2) ///就诊科室
    
    s ArcIndex=0
    s ArcList=""
    s ArcList1=""
    s ArcList2=""
    set chID=""
    for  set chID=$o(^DHCAPREP(RepID,"AR",chID)) quit:chID=""  d //父到子的唯一方法
	.s ARArc=$p(^DHCAPREP(RepID,"AR",chID),"^",1) 	///检查医嘱项ID
	.q:ARArc=""
	.s ARArcDesc=$p(^ARCIM($p(ARArc,"||",1),$p(ARArc,"||",2),1),"^",2)  
	.s ARPos=$p(^DHCAPREP(RepID,"AR",chID),"^",2)
	.i ARPos="" d
	..s ARPosDesc=""
	.i ARPos'="" d
	..s ARPosDesc=$p(^DHCAPPOS(ARPos),"^",2) ///体位描述
	.s chIDchRowid=RepID_"||"_chID   //ARParRefDr
	.s:ArcIndex=0 ArcList=ARArcDesc_"："
	.s:ArcIndex=1 ArcList1=ARArcDesc_"："
	.s:ArcIndex=2 ArcList2=ARArcDesc_"："
	.s ToothDesc=##class(web.DHCAPPExaReportQuery).GetToothInfoDesc(chIDchRowid)
	.if ToothDesc'="" s ARArcDesc=ARArcDesc_"-"_ToothDesc
	.s chIDchPart=""
	.for  set chIDchPart=$o(^DHCAPREP(RepID,"AR",chID,"PA",chIDchPart)) quit:chIDchPart=""  d 
	..s ARPart=$p(^DHCAPREP(RepID,"AR",chID,"PA",chIDchPart),"^",1)
	..s ARPartDesc=$p(^DHCAPPART(ARPart),"^",2) ///子部位描述
	..s:ArcIndex=0 ArcList=ArcList_ARPartDesc_" "
	..s:ArcIndex=1 ArcList1=ArcList1_ARPartDesc_" "
	..s:ArcIndex=2 ArcList2=ArcList2_ARPartDesc_" "
	
	.s:ArcIndex=0 ArcList=ArcList_" "_ARPosDesc_" "
	.s:ArcIndex=1 ArcList1=ArcList1_" "_ARPosDesc_" "
	.s:ArcIndex=2 ArcList2=ArcList2_" "_ARPosDesc_" "
	
	.s chIDch=""
	.for  set chIDch=$o(^DHCAPREP(RepID,"AR",chID,"DI",chIDch)) quit:chIDch=""  d 
	..s ARDisp=$p(^DHCAPREP(RepID,"AR",chID,"DI",chIDch),"^",1)
	..i ARDisp="" d
	...s ARDispDesc=""
	..i ARDisp'="" d
	...s ARDispDesc=$p(^DHCAPDIM(ARDisp),"^",2) ///后处理描述
	..s:ArcIndex=0 ArcList=ArcList_ARDispDesc_" "
	..s:ArcIndex=1 ArcList1=ArcList1_ARDispDesc_" "
	..s:ArcIndex=2 ArcList2=ArcList2_ARDispDesc_" "
	.s ArcIndex=ArcIndex+1
	s isGao="N"
	s isXin="N"
	s isTang="N"
	s isShen="N"
	s isGan="N"
	s isDian="N"
	s IsOther=""
	;CS增加
	s IsShou="N"
	s IsZhong="N"
	s HBsAg="阴性"
	s HCV="阴性"
	s HIV="阴性"
	s IsMei="阴性"
	;HC增加
	s IsOther1="N"
	s IsOther2="N"
	s IsOther3="N"
	;WJ增加
	s IsXiaoG="N"
	s IsXiaoC="N"
	s IsXiaoCX="N"
	s PLT="N"
	s PTA="N"
	s HBsAgY="N"
	s HCVY="N"
	s HIVY="N"
	s IsMeiY="N"
	s IsShiD="N"
	s IsXiR="N"
	;XD增加
	s IsYDH="N"
	
	set chIDOth=""
	for  set chIDOth=$o(^DHCAPREP(RepID,"OT",chIDOth)) quit:chIDOth=""  d 
	.s Opt=$p(^DHCAPREP(RepID,"OT",chIDOth),"^",1)
	.s OptDesc=$p(^DHCAPOTHO(Opt),"^",2)
	.s OptType=$p(^DHCAPOTHO(Opt),"^",3) //类型add
	.s OptItem=$p(^DHCAPREP(RepID,"OT",chIDOth),"^",2)
	.i OptType="Input" d
	..s OptItemDesc=OptItem
	.i OptType="Check" d
	..s OptItemDesc=OptItem
	.i OptType="Combox" d
	..;s OptItemDesc =$p(^DHCAPOTHO($p(OptItem,"||",1),"I",$p(OptItem,"||",2)),"^",2)
	..s OptItemDesc =$p(^DHCAPOTHO(+OptItem,"I",$p(OptItem,"||",2)),"^",2)
	.s:OptDesc["高血压" isGao=OptItemDesc
	.s:OptDesc["心脏病" isXin=OptItemDesc
	.s:OptDesc["糖尿病" isTang=OptItemDesc
	.s:OptDesc["肾脏" isShen=OptItemDesc
	.s:OptDesc["肝脏" isGan=OptItemDesc
	.s:OptDesc["碘过敏" isDian=OptItemDesc
	.s:OptDesc["其他" IsOther=OptItemDesc
	;CS增加
	.s:OptDesc["手术史" IsShou=OptItemDesc
	.s:OptDesc["肿瘤" IsZhong=OptItemDesc
	.s:OptDesc["HBsAg" HBsAg=OptItemDesc
	.s:OptDesc["抗HCV" HCV=OptItemDesc
	.s:OptDesc["抗HIV" HIV=OptItemDesc
	.s:OptDesc["梅毒" IsMei=OptItemDesc
	;HC增加
	.s:OptDesc["体内含铁血管金属夹" IsOther1=OptItemDesc
	.s:OptDesc["体内金属标记及固定钢板" IsOther2=OptItemDesc
	.s:OptDesc["心脏起搏器" IsOther3=OptItemDesc
	;WJ增加
	.s:OptDesc["消化道梗阻" IsXiaoG=OptItemDesc
	.s:OptDesc["消化道穿孔" IsXiaoC=OptItemDesc
	.s:OptDesc["消化道出血" IsXiaoCX=OptItemDesc
	.s:OptDesc["PLT" PLT=OptItemDesc
	.s:OptDesc["PTA" PTA=OptItemDesc
	.s:OptDesc["HBsAg阳性" HBsAgY=OptItemDesc
	
	.s:OptDesc["抗HCV阳性" HCVY=OptItemDesc
	.s:OptDesc["抗HIV阳性" HIVY=OptItemDesc
	.s:OptDesc["梅毒阳性" IsMeiY=OptItemDesc
	.s:OptDesc["食道胃底静脉曲张内镜治疗" IsShiD=OptItemDesc
	.s:OptDesc["息肉切除息肉切除" IsXiR=OptItemDesc
	;XD增加
	.s:OptDesc["服用洋地黄(或其他药品)" IsYDH=OptItemDesc
	
	s BedNo="",Name="",Sex="",Age="",MedicareNo="",AdmReason=""
	if PAAdm="" q BedNo_"^"_Name_"^"_Sex_"^"_Age_"^"_MedicareNo_"^"_AdmReason
	Set Bed=$P($g(^PAADM(PAAdm)),"^",73)
	if Bed'="" s BedNo=$P($g(^PAWARD(+Bed,"BED",$P(Bed,"||",2))),"^",1)
	Set PAAdmNo=$P($g(^PAADM(PAAdm)),"^",81)
	set PatientID=$P($g(^PAADM(PAAdm)),"^",1)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(PAAdm)
	s ErrMsg=""
	s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(PAAdm,AdmType,.ErrMsg) ;病历号
	Set Name=$P(^PAPER(PatientID,"ALL"),"^",1)
	Set Sex=$P(^PAPER(PatientID,"ALL"),"^",7)
	if Sex'="" Set Sex=$P($g(^CT("SEX",Sex)),"^",2)
	set Age=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,PAAdm)
	Set regNo=$P(^PAPER(PatientID,"PAT",1),"^",1) //登记号

	set ApsID=+$O(^DHCAPPATSI(0,"ADM",PAAdm,""))
	set sign=$p($g(^DHCAPPATSI(ApsID)),"^",2)  //体征内容
	set AphID=+$O(^DHCAPPREH(0,"ADM",PAAdm,""))
	set his=$p($g(^DHCAPPREH(AphID)),"^",2)  //现病史内容
	s PatType=$p(^PAADM(PAAdm),"^",2)        /// 就诊类型
	i PatType="I" D
	.s arExaReqSym=""  /// 主诉
	E  D
	.s arExaReqSym=##Class(EMRservice.BL.BLScatterData).GetDataByGlossary(PAAdm,"HDSD00.03.057","0")  /// 主诉
    ;w regNo_","_Name_","_Age_","_MedicareNo_","_deplocdesc_","_Sex_","_""_","_sign_","_""_","_""_","_PatDiagDesc_","_""_","_ArcList_","_ArcList1_","_ArcList2_","_isGao_","_isXin_","_isTang_","_isShen_","_isGan_","_isDian_","_""_","_ARExecLocCode_","_ARTime_","_ARDocName_","
    s PatSymInfo=arExaReqSym_""_his_""_sign
    s PatSymInfo1="",PatSymInfo2="",PatSymInfo3=""
	i $L(PatSymInfo)>42 D
	.s PatSymInfo1=$E(PatSymInfo,1,42)
	.s PatSymInfo2=$E(PatSymInfo,42,$L(PatSymInfo))
	E  s PatSymInfo1=PatSymInfo
	
	i $L(PatSymInfo2)>42 D
	.s PatSymInfo3=$E(PatSymInfo2,42,$L(PatSymInfo2))
	.s PatSymInfo2=$E(PatSymInfo2,1,42)
	
	i $L(PatSymInfo3)>42 s PatSymInfo3=$E(PatSymInfo3,1,42)_"..."
	;牙位
	
	Set str=""
	set str="{"
	set str=str_"""PACatDesc"""_":"""_ItmCatCode_""","
	set str=str_"""ItmCatDesc"""_":"""_ItmCatDesc_""","
	set str=str_"""RegNo"""_":"""_regNo_""","
	set str=str_"""Name"""_":"""_Name_""","
	set str=str_"""Age"""_":"""_Age_""","
	set str=str_"""MedicareNo"""_":"""_MedicareNo_""","
	set str=str_"""InLoc"""_":"""_deplocdesc_""","
	set str=str_"""Sex"""_":"""_Sex_""","
	set str=str_"""InsuranceNo"""_":"""_""_""","
	set str=str_"""PatientNowValue1"""_":"""_PatSymInfo1_""","
	set str=str_"""PatientNowValue2"""_":"""_PatSymInfo2_""","
	set str=str_"""PatientNowValue3"""_":"""_PatSymInfo3_""","
	set str=str_"""MainDiagoseValue1"""_":"""_PatDiagDesc1_""","
	set str=str_"""MainDiagoseValue2"""_":"""_PatDiagDesc2_""","
	set str=str_"""PurposeValue1"""_":"""_ArcList_""","
	set str=str_"""PurposeValue2"""_":"""_ArcList1_""","
	set str=str_"""PurposeValue3"""_":"""_ArcList2_""","
	set str=str_"""IsGao"""_":"""_isGao_""","
	set str=str_"""IsXin"""_":"""_isXin_""","
	set str=str_"""IsTang"""_":"""_isTang_""","
	set str=str_"""IsShen"""_":"""_isShen_""","
	set str=str_"""IsGan"""_":"""_isGan_""","
	set str=str_"""IsDian"""_":"""_isDian_""","
	set str=str_"""IsOther"""_":"""_IsOther_""","
	;CS增加
	set str=str_"""IsShou"""_":"""_IsShou_""","
	set str=str_"""IsZhong"""_":"""_IsZhong_""","
	set str=str_"""HBsAg"""_":"""_HBsAg_""","
	set str=str_"""HCV"""_":"""_HCV_""","
	set str=str_"""HIV"""_":"""_HIV_""","
	set str=str_"""IsMei"""_":"""_IsMei_""","
	;HC增加
	set str=str_"""IsOther1"""_":"""_IsOther1_""","
	set str=str_"""IsOther2"""_":"""_IsOther2_""","
	set str=str_"""IsOther3"""_":"""_IsOther3_""","
	;WJ增加
	set str=str_"""IsXiaoG"""_":"""_IsXiaoG_""","
	set str=str_"""IsXiaoC"""_":"""_IsXiaoC_""","
	set str=str_"""IsXiaoCX"""_":"""_IsXiaoCX_""","
	set str=str_"""PLT"""_":"""_PLT_""","
	set str=str_"""PTA"""_":"""_PTA_""","
	set str=str_"""HBsAgY"""_":"""_HBsAgY_""","
	set str=str_"""HCVY"""_":"""_HCVY_""","
	set str=str_"""HIVY"""_":"""_HIVY_""","
	set str=str_"""IsMeiY"""_":"""_IsMeiY_""","
	set str=str_"""IsShiD"""_":"""_IsShiD_""","
	set str=str_"""IsXiaoCX"""_":"""_IsXiaoCX_""","
	;XD增加
	set str=str_"""IsYDH"""_":"""_IsYDH_""","
	set str=str_"""IsJL"""_":"""_""_""","
	
	set str=str_"""RecLoc"""_":"""_ARExecLocCode_""","
	set str=str_"""LocAddr"""_":"""_arExecLocAdrr_""","
	set str=str_"""HopeDate"""_":"""_ARTime_""","
	set str=str_"""AppDoc"""_":"""_ARDocName_""""
	
					  
	set str=str_"}"
	q str
}

// w ##class(web.DHCAPPPrintCom).getarItemIdList(EpisodeID)

ClassMethod getarItemIdList(EpisodeID)
{
  s ARRowID="",arItemIdList=""
  f  s ARRowID=$o(^DHCAPREP(0,"ADM",EpisodeID,ARRowID)) q:ARRowID=""  d
  .i arItemIdList=""  s arItemIdList=ARRowID
  .e  s arItemIdList=arItemIdList_"||"_ARRowID
  q arItemIdList
}

/// Creator：   bianshuai
/// CreatDate： 2016-08-15
/// Descript:   获取检查申请单打印数据
/// Table：     DHC_AppReport  
/// Input：	    ExaReqID：申请单ID、ExaReqNo：申请单号   
/// Return：    申请单json串
/// w ##Class(web.DHCAPPPrintCom).GetExaReqPrintData("3620","")
ClassMethod GetExaReqPrintData(ExaReqID As %String, ExaReqNo As %String) As %String
{
	n (ExaReqID, ExaReqNo)
	i ExaReqID="" s ExaReqID=$o(^DHCAPREP(0,"ARNo",ExaReqNo,""))
	Q:ExaReqID="" "{}"
	
	k TmpPatDiagArr, TmpArcItemArr, TmpOthOptArr, TmpPatBaseArr
	s arSendFlag=$p(^DHCAPREP(ExaReqID),"^",17) 
	Q:arSendFlag="I" "{}"
	s arReqNo=$p(^DHCAPREP(ExaReqID),"^",1)           /// 单号
	s arReqData=$p(^DHCAPREP(ExaReqID),"^",2)         /// 报告日期
	s:arReqData'="" arReqData=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(arReqData) //hxy $zd(arReqData,3)
	s arReqTime=$p(^DHCAPREP(ExaReqID),"^",3)         /// 报告时间
	s:arReqTime'="" arReqTime=..%ZT(arReqTime,1)
	s arReqTime=arReqData_" "_arReqTime
	s arUserCode=""
	s arUserID=$p(^DHCAPREP(ExaReqID),"^",4)          /// 申请人
	s:arUserID'="" arUserCode=$p(^SSU("SSUSR",arUserID),"^",2)
	//s arUserCode=##Class(web.DHCAPPExaReportQuery).FilerEngLetChar(arUserCode)
	s arRepExLoc=""
	s arExLocID=$p(^DHCAPREP(ExaReqID),"^",5)         /// 执行科室
	s arRepExLoc=$p(^CTLOC(arExLocID),"^",2)          /// 执行科室
	s arRepExLocFlor=$p(^CTLOC(arExLocID),"^",16)     /// 接收科室地址
	if arRepExLocFlor'="" s arRepExLocFlor=$P($g(^CT("CTLB",+arRepExLocFlor,"Floor",$P(arRepExLocFlor,"||",2))),"^",1)
	s arRepExLocAdrr=$g(^CTLOC(arExLocID,"ADDR",1))   /// 接收科室楼层
	s arRepExLocAdrr=arRepExLocAdrr_arRepExLocFlor
	s EpisodeID=$p(^DHCAPREP(ExaReqID),"^",6)	      /// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)           /// 病人ID
	s arPurpose=$g(^DHCAPREP(ExaReqID,"Purpose"))        /// 检查目的
	s arEmgFlag=$p(^DHCAPREP(ExaReqID),"^",16)        /// 加急标志
	s arEmgFlag=$s(arEmgFlag="Y":"【加急】",1:"")
	s PrintFlag=""
	s NurPrtUser=$p(^DHCAPREP(ExaReqID),"^",22)        /// 打印人
	s NurPrtDate=$p(^DHCAPREP(ExaReqID),"^",23)        /// 打印日期
	s NurPrtTime=$p(^DHCAPREP(ExaReqID),"^",24)        /// 打印时间
	i (NurPrtUser'="")&&(NurPrtDate'="")&&(NurPrtTime'="") s PrintFlag="[补]"
	s PreInFlag=..GetPatPreInFlag(EpisodeID)           /// 获取病人预住院和日间标志
	s arHisDesc=""
	s arHisID=$o(^DHCAPPREH(0,"REQ",ExaReqID,""))      /// 现病史
	i arHisID'="" s arHisDesc=$g(^DHCAPPREH(arHisID,"History"))
	s arSigDesc=""
	s arSigID=$o(^DHCAPPATSI(0,"REQ",ExaReqID,""))     /// 体征信息
	i arSigID'="" s arSigDesc=$g(^DHCAPPATSI(arSigID,"Sings"))
	s arExaReqSym=""
	s arExaReqSymID=$o(^DHCAPPATSY(0,"REQ",ExaReqID,""))
	i arExaReqSymID'="" s arExaReqSym=$G(^DHCAPPATSY(arExaReqSymID,"Symptom")) /// 主诉
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)            /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)            /// 登记号
	s InsuCardNo=$p($g(^PAPER(PatientID,"PAT",3)),"^",12)  /// 医保卡号
	s CardNo=##Class(web.DHCAPPPrintCom).GetCardNoByRegNo(PatientID) /// 卡号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)          /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 			   /// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s HospID=+$p($g(^CTLOC(+PatLocID)),"^",22)         /// 医院ID
	s HospDesc=$p($g(^CT("HOSP",HospID)),"^",2)
	s InsuID=$o(^DHCINADM("0","ADM",EpisodeID,""))
	s InsuNo=$p($g(^DHCINADM(+InsuID)),"^",1)          /// 医疗保险号 
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ErrMsg=""
	s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,AdmType,.ErrMsg) ;病历号
	s ExaRepDiags=""
	s mPatDiags=$p(^DHCAPREP(ExaReqID),"^",25)		/// 病人诊断
	s count=0
	For k=1:1:$L(mPatDiags,"@")  {
		s MrData=$p(mPatDiags,"@",k)    /// 诊断
		s MrID=$p(MrData,$C(2),1)       /// 诊断ID
		s MrID=$p(MrID,$C(4),1)  //2019-07-29 原诊断ID和描述分割符由$C(2)改为$C(4),
		continue:MrID=""
		if (ExaRepDiags="") s ExaRepDiags=MrID
		else  s ExaRepDiags=ExaRepDiags_"^"_MrID
	}	
	s PatDiag=..GetMRDiagnosDesc(EpisodeID,";","",ExaRepDiags)       /// ##class(web.DHCSTKUTIL) 诊断
	D ##Class(web.DHCAPPExaRepCom).splitString(PatDiag, "86", "10", .TmpPatDiagArr)  /// 拆分字符串
	D ..TrsTmpArrNew("PatDiagArr", .TmpPatDiagArr)
	s ProPatFlag=""
	s arItemDesc="", NoteList=""
	s CH=""
	F  s CH=$o(^DHCAPREP(ExaReqID,"AR",CH)) Q:CH=""  D
	.s arcimid=$p(^DHCAPREP(ExaReqID,"AR",CH),"^",1)        ///医嘱项目ID
	.s itmmastid=$p(arcimid,"||",1), itmmastver=$p(arcimid,"||",2)
	.s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1)  ///医嘱项代码
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
	.s PosiDesc="",PosiCode=""
	.s PosiID=$p(^DHCAPREP(ExaReqID,"AR",CH),"^",2)     	///体位ID
	.s:PosiID'="" PosiDesc=$p(^DHCAPPOS(PosiID),"^",2)	    ///体位
	.s Oeori=$p(^DHCAPREP(ExaReqID,"AR",CH),"^",3)     	    ///医嘱ID
	.Q:Oeori=""
	.s PPRowID=$p($G(^OEORD(+Oeori,"I",$p(Oeori,"||",2),"DHC")),"^",10)
	.i PPRowID'="" s ProPatFlag="【科研】"
	.s NoteList=##class(web.DHCAPPArcNote).GetAppArcNote(arcimid,HospID)  /// 注意事项
	.s ItemStat=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)
	.Q:(ItemStat="D")||(ItemStat="C")||(ItemStat="U")||(ItemStat="I")       /// 临嘱 住院为撤销、门诊为停止
	.s ItemLabel=##Class(web.DHCAPPInterface).GetExaReqItemDesc(Oeori) /// 项目描述
	.if arEmgFlag="" d
	..s emgFlag=$p(^OEORD($p(Oeori,"||",1),"I",$p(Oeori,"||",2),"11"),"^",55)	// 加急标志
	..s emgFlag=$case(emgFlag,"Y":"【加急】","N":"",:"")
	..i emgFlag'="" s ItemLabel=emgFlag_ItemLabel
	.i arItemDesc="" s arItemDesc=ItemLabel
	.E  s arItemDesc=arItemDesc_"；"_ItemLabel
	.s ToothDesc=##class(web.DHCAPPExaReportQuery).GetToothInfoDesc(ExaReqID_"||"_CH)
	.if ToothDesc'="" s arItemDesc=arItemDesc_" "_ToothDesc
	.s LinkItemDesc=""
	.s LinkSub=0 s LinkSub=$o(^OEORDi(0,"OEORI",+Oeori,Oeori,LinkSub)) q:LinkSub=""  d
	..s ItemStat=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(+Oeori_"||"_LinkSub)
	..Q:(ItemStat="D")||(ItemStat="C")||(ItemStat="U")||(ItemStat="I")  
	..s LinkItemDr=$p($G(^OEORD(+Oeori,"I",LinkSub,1)),"^",2)
	..i LinkItemDesc="" s LinkItemDesc=$p(^ARCIM(+LinkItemDr,$p(LinkItemDr,"||",2),1),"^",2)
	..e  s LinkItemDesc=LinkItemDesc_"；"_$p(^ARCIM(+LinkItemDr,$p(LinkItemDr,"||",2),1),"^",2)
	.i LinkItemDesc'="" s arItemDesc=arItemDesc_" 【"_LinkItemDesc_"】"

	D ##Class(web.DHCAPPExaRepCom).splitString(arItemDesc, "86", "10", .TmpArcItemArr)  /// 拆分字符串
	D ..TrsTmpArrNew("ArcItemArr", .TmpArcItemArr)
	s arExaReqCode=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(ExaReqID)   /// 分类代码
	s arExaReqDesc=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(ExaReqID,1) /// 分类描述
	s arExaReqDesc=arExaReqDesc_"申请单"
	s OthOptList=""
	s CH=""
	F  s CH=$o(^DHCAPREP(ExaReqID,"OT",CH)) Q:CH=""  D
	.s itemid=$p(^DHCAPREP(ExaReqID,"OT",CH),"^",1)  /// 其他项目ID
	.s itemdesc=$p(^DHCAPOTHO(itemid),"^",2)         /// 描述
	.s itemtype=$p(^DHCAPOTHO(itemid),"^",3)         /// 类型
	.s itemval=$p(^DHCAPREP(ExaReqID,"OT",CH),"^",2) /// 其他项目值
	.i itemtype="Combox" s itemval=$p(^DHCAPOTHO(+itemval,"I",$p(itemval,"||",2)),"^",2)
	.i itemtype="Order"  q
	.Q:OthOptList[(itemdesc_":"_itemval)
	.i OthOptList="" s OthOptList=itemdesc_":"_itemval
	.E  s OthOptList=OthOptList_"  "_itemdesc_":"_itemval
	.
	D ##Class(web.DHCAPPExaRepCom).splitString(OthOptList, "86", "10", .TmpOthOptArr)  /// 拆分字符串
	D ..TrsTmpArrNew("OthOptArr", .TmpOthOptArr)
	s PatType=$p(^PAADM(EpisodeID),"^",2)            /// 就诊类型
	s Type=$s(PatType="I":"住院",PatType="E":"急诊",PatType="O":"门诊",1:"")    ///  sufan 2017-03-14
	i arExaReqSym'="" s arExaReqSym="主诉："_arExaReqSym_"；" 
	i arHisDesc'="" s arHisDesc="现病史："_arHisDesc_"；"
    i arSigDesc'="" s arSigDesc="体征："_arSigDesc_"；"
    s PatSymInfo=arExaReqSym_""_arHisDesc_""_arSigDesc
    s PatSymInfo=$replace(PatSymInfo,$c(10),"")
    D ##Class(web.DHCAPPExaRepCom).splitString(PatSymInfo, "86", "4", .TmpPatSymArr)  /// 拆分字符串
	D ..TrsTmpArrNew("PatSymArr", .TmpPatSymArr)
	s BillType=##class(DHCDoc.OPDoc.AjaxInterface).GetAdmReason(EpisodeID)
	//$p(^PAPER(PatientID,"PER",1),"^",10)  /// 费别
	//s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	
    s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	s ExaReqNoCost=##Class(web.DHCAPPExaReportQuery).GetExaReqNoCost(ExaReqID,"Y")       /// 申请单总金额
	s PatCardMoney=##Class(web.DHCDocOrderCommon).GetCurrentDeposit(EpisodeID)       /// 获取卡余额
	s PrintTemp=..GetPrintTemp(ExaReqID)            /// 打印模板
	i PrintTemp="" s PrintTemp="DHCAPP_NT"
	//s ExaReqTitle=HospDesc_$s(PatType="I":"住院",PatType="E":"急诊",1:"门诊")_"检查申请单"_PrintFlag
	
	s HospDesc=HospDesc_$s(PatType="I":"住院",PatType="E":"急诊",1:"门诊")
	s ExaReqTitle="检查申请单"_PrintFlag
	
	s GreenFlag=##class(web.DHCEMInterfaceCom).CheckGreenRec(EpisodeID)   /// sufan 2018-10-22 
	s GreenFlag=$s(GreenFlag="1":"绿色通道",1:"")
	D ##Class(web.DHCAPPExaRepCom).splitString(NoteList, "86", "10", .TmpNoteListArr)  /// 拆分字符串
	D ..TrsTmpArrNew("NoteListArr", .TmpNoteListArr)
	s Location=arRepExLocAdrr_"  "_arRepExLoc_"   刷卡检查"
	s mListData=HospDesc_$C(4)_"*"_PatNo_"*"_$C(4)_MedicareNo_$C(4)_PatNo_$C(4)_PatName
	s mListData=mListData_$C(4)_PatAge_$C(4)_PatLoc_$C(4)_PatSex_$C(4)_arHisDesc_$C(4)_arSigDesc
	//11-20
	s mListData=mListData_$C(4)_PatDiag_$C(4)_arRepExLocAdrr_$C(4)_CardNo_$C(4)_BillType_$C(4)_PatBed
	s mListData=mListData_$C(4)_Type_$C(4)_NoteList_$C(4)_arItemDesc_$C(4)_arRepExLoc_$C(4)_arReqTime
	//21-30
	s mListData=mListData_$C(4)_arUserCode_$C(4)_arReqNo_$C(4)_OthOptList_$C(4)_arExaReqCode_$C(4)_arExaReqDesc
	s mListData=mListData_$C(4)_""_$C(4)_PatCardMoney_$C(4)_ExaReqNoCost_$C(4)_ExaReqTitle_$C(4)_arEmgFlag
	//31-40
	s mListData=mListData_$C(4)_PrintTemp_$C(4)_InsuNo_$C(4)_InsuCardNo_$C(4)_PrintFlag_$C(4)_PreInFlag
	s mListData=mListData_$C(4)_GreenFlag_$C(4)_Location_$C(4)_ ProPatFlag_$C(4)_TmpPatSymArr("PatSymArrVal")_$C(4)_TmpPatDiagArr("PatDiagArrVal")_$C(4)_TmpOthOptArr("OthOptArrVal")
	//41-50
	s mListData=mListData_$C(4)_TmpArcItemArr("ArcItemArrVal")_$C(4)_TmpNoteListArr("NoteListArrVal")
	////////
	s ListTitle="hopName"_$C(4)_"Barcode"_$C(4)_"MedicareNo"_$C(4)_"PatNo"_$C(4)_"PatName"
	s ListTitle=ListTitle_$C(4)_"PatAge"_$C(4)_"PatLoc"_$C(4)_"PatSex"_$C(4)_"arHisDesc"_$C(4)_"arSigDesc"
	//11-20
	s ListTitle=ListTitle_$C(4)_"PatDiag"_$C(4)_"arRepExLocAdrr"_$C(4)_"CardNo"_$C(4)_"BillType"_$C(4)_"PatBed"
	s ListTitle=ListTitle_$C(4)_"Type"_$C(4)_"NoteList"_$C(4)_"arItemDesc"_$C(4)_"arRepExLoc"_$C(4)_"arReqTime"
	//21-30
	s ListTitle=ListTitle_$C(4)_"arUserCode"_$C(4)_"arReqNo"_$C(4)_"OthOptList"_$C(4)_"arExaReqCode"_$C(4)_"arExaReqDesc"
	s ListTitle=ListTitle_$C(4)_"InsuranceNo"_$C(4)_"PatCardMoney"_$C(4)_"ExaReqNoCost"_$C(4)_"ExaReqTitle"_$C(4)_"EmgFlag"
	//31-40
	s ListTitle=ListTitle_$C(4)_"PrintTemp"_$C(4)_"InsuNo"_$C(4)_"InsuCardNo"_$C(4)_"PrintFlag"_$C(4)_"PreInFlag"
	s ListTitle=ListTitle_$C(4)_"GreenFlag"_$C(4)_"Location" _$C(4)_"ProPatFlag"_$C(4)_TmpPatSymArr("PatSymArrKey")_$C(4)_TmpPatDiagArr("PatDiagArrKey")_$C(4)_TmpOthOptArr("OthOptArrKey")
	//41-50
	s ListTitle=ListTitle_$C(4)_TmpArcItemArr("ArcItemArrKey")_$C(4)_TmpNoteListArr("NoteListArrKey")
	
	Q ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,mListData,$C(4))
}

/// Descript: 输出数组Key和Value串
/// w ##Class(web.DHCAPPPrintCom).TrsTmpArr("", "")
ClassMethod TrsTmpArr(ColField As %String, TmpArr As %String) As %String
{
	n (ColField, TmpArr)
	s index="", Num=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.Q:(index["Key")||(index["Val")
	.s Num=Num+1
	.s TmpArr(ColField_"Key")=$s($g(TmpArr(ColField_"Key"))="":ColField_Num,1:$g(TmpArr(ColField_"Key"))_"^"_ColField_Num)
	.s TmpArr(ColField_"Val")=$s($g(TmpArr(ColField_"Val"))="":TmpArr(index),1:$g(TmpArr(ColField_"Val"))_"^"_TmpArr(index))
 	Q ""
}

ClassMethod TrsTmpArrNew(ColField As %String, TmpArr As %String) As %String
{
	n (ColField, TmpArr)
	s index="", Num=0
	F  s index=$o(TmpArr(index)) Q:index=""  D
	.Q:(index["Key")||(index["Val")
	.s Num=Num+1
	.s TmpArr(ColField_"Key")=$s($g(TmpArr(ColField_"Key"))="":ColField_Num,1:$g(TmpArr(ColField_"Key"))_$C(4)_ColField_Num)
	.s TmpArr(ColField_"Val")=$s($g(TmpArr(ColField_"Val"))="":TmpArr(index),1:$g(TmpArr(ColField_"Val"))_$C(4)_TmpArr(index))
 	Q ""
}

/// Descript: 获取病人卡号
/// w ##Class(web.DHCAPPPrintCom).GetCardNoByRegNo("6335788")
ClassMethod GetCardNoByRegNo(Papmi As %String) As %String
{
	n (Papmi)
	Q:Papmi="" ""
	s CardNo=""
 	s CFRowID="0"
	f  s CFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",Papmi,CFRowID))  Q:CFRowID=""  D
 	.s ActiveFlag=$p(^DHCCARD("CF",CFRowID),"^",10)
 	.Q:ActiveFlag'="N"
 	.s CardNo=$p(^DHCCARD("CF",CFRowID),"^",2)
 	.
 	Q CardNo
}

/// Descript: 获取病人卡余额
/// w ##Class(web.DHCAPPPrintCom).GetPatCardMoney(6289327)
ClassMethod GetPatCardMoney(patpmi As %String) As %String
{
	n (patpmi)
	s Balance=0
	s accrowid="0"
	f  s accrowid=$o(^DHCACDi("AccM",0,"PAPMI",patpmi,accrowid))  q:accrowid=""  d
	.s AccStatus=$p(^DHCACD("AccM",accrowid),"^",13)
	.q:(AccStatus'="N")&((AccStatus'="S"))
	.s Balance=+$p(^DHCACD("AccM",accrowid),"^",8)
	q Balance_" 元"
}

/// Descript: 申请单项目医嘱分类对应检查分类代码
/// w ##Class(web.DHCAPPPrintCom).GetPrintTemp("")
ClassMethod GetPrintTemp(arReqID As %String) As %String
{
	n (arReqID,%session)
	s CH=$o(^DHCAPREP(arReqID,"AR",""))
	Q:CH="" ""
	s EpisodeID=$p(^DHCAPREP(arReqID),"^",6)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	s arcimid=$p(^DHCAPREP(arReqID,"AR",CH),"^",1)         ///医嘱项目ID
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s itemCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)   ///医嘱子类
	s HospID=""
	s PAADMDepCodeDR=$p($g(^PAADM(EpisodeID)),"^",4)
	i PAADMDepCodeDR'=""  s HospID=$p($g(^CTLOC(PAADMDepCodeDR)),"^",22)
	//tanjishan 2021-03-19
	// 根据医嘱子类或医嘱项获取检查分类ID
	s itmArcCatID=0,itmArcCatIDNew=""
	// 先取医嘱项关联的检查分类
	f  s itmArcCatID=$o(^DHCAPARCCA(0,"Arc",arcimid,itmArcCatID))  q:(itmArcCatID="")  d
	.s HospDr=$p(^DHCAPARCCA(itmArcCatID),"^",4)
	.i (HospID'="")&(HospID=HospDr)  d
	..s itmArcCatIDNew=itmArcCatID
	// 医嘱项检查分类取不到时再去医嘱子分类对应的检查分类
	s itmArcCatID=0
	i itmArcCatIDNew=""  d
	.f  s itmArcCatID=$o(^DHCAPARCCA(0,"O",itemCatID,itmArcCatID))  q:(itmArcCatID="")  d
	..s HospDr=$p(^DHCAPARCCA(itmArcCatID),"^",4)
	..i (HospID'="")&(HospID=HospDr)  d
	...s itmArcCatIDNew=itmArcCatID
	Q:itmArcCatIDNew="" ""
	s PrintTemp=""
	s TempID=0
	for {
		s TempID=$o(^DHCAPPPRT(0,"Arc",itmArcCatIDNew,TempID)) Q:TempID=""
		s APTType=$p(^DHCAPPPRT(TempID),"^",3)
		continue:(APTType'="")&&(APTType'=AdmType)
		s APTSex=$p(^DHCAPPPRT(TempID),"^",4)
		continue:(APTSex'="")&&(APTSex'=sexId)
		s PrintTemp=$p(^DHCAPPPRT(TempID),"^",2) /// 打印模板
		Q:PrintTemp'=""
	}	
	Q PrintTemp
}

/// Descript: 病理申请单打印模板
/// w ##Class(web.DHCAPPPrintCom).GetPisPrintTemp("CYT")
ClassMethod GetPisPrintTemp(PisType As %String) As %String
{
	n (PisType)
	s itmArcCatID=$o(^DHCAPARCCA(0,"Code",PisType,""))
	Q:itmArcCatID="" ""
	s TempID=$o(^DHCAPPPRT(0,"Arc",itmArcCatID,""))
	Q:TempID="" ""
	s PrintTemp=$p(^DHCAPPPRT(TempID),"^",2) /// 打印模板
	Q PrintTemp
}

/// 通过 ArcCatID 得到 是否有打印模板 
/// 有返回模板数据，没有返回空 
ClassMethod GetAllPrinttemp(itmArcCatID As %String = "", ItemExaID As %String = "", HospId As %String = "")
{
	s HospId=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (itmArcCatID'=""){
		s TempID=$o(^DHCAPPPRT(0,"Arc",itmArcCatID,""))
	}
	if (ItemExaID'=""){
		s itmmastid=$p(ItemExaID,"||",1)
		s itmmastver=$p(ItemExaID,"||",2)
		s itemCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)   ///医嘱子类
		s itmArcCatID=""
		for {
			s itmArcCatID=$o(^DHCAPARCCA(0,"O",itemCatID,itmArcCatID))
			Q:itmArcCatID="" 
			s HospDr=$p(^DHCAPARCCA(itmArcCatID),"^",4)
			q:(HospDr=HospId)
		}
		s TempID=$o(^DHCAPPPRT(0,"Arc",itmArcCatID,""))
	}
	Q:TempID="" ""
	s PrintTemp=$p(^DHCAPPPRT(TempID),"^",2) /// 打印模板
	Q PrintTemp
}

/// Creator:    bianshuai
/// CreateDate: 2018-01-11
/// Descript:   Print病理申请打印函数
/// InPut:      PisID-病理申请关联表ID
/// OutPut:     病理申请打印内容
/// w ##Class(web.DHCAPPPrintCom).GetPisPrintCon("303")
ClassMethod GetPisPrintCon(PisID As %String) As %String
{
	n (PisID)	
	/// 病人信息
	k TmpMedRecArr,TmpMedDiagArr,TmpPisTesDiagArr,TmpSpecExaResArr,TmpConsNoteArr,TmpMorToDeaArr,TmpDisAndTreArr,TmpPhyAndLabArr,TmpPisReqSpecArr
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)		/// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s PatWard=""
	s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	/// 病区ID
	s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	s CreatDate=$p(^DHCAPPPM(PisID),"^",6)		/// 申请日期
	s:CreatDate'="" CreatDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(CreatDate) 
	s CreatTime=$p(^DHCAPPPM(PisID),"^",7)		/// 申请时间
	s:CreatTime'="" CreatTime=..%ZT(CreatTime,2)
	s UserID=$p(^DHCAPPPM(PisID),"^",5)	        /// 申请人
	s UserName=$p(^SSU("SSUSR",UserID),"^",2)
	s ReqLoc=""
	s ReqLocID=$p(^DHCAPPPM(PisID),"^",8)	    /// 申请科室
	s:ReqLocID'="" ReqLoc=$p(^CTLOC(ReqLocID),"^",2)
	//s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	//s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s BillType=##class(DHCDoc.OPDoc.AjaxInterface).GetAdmReason(EpisodeID)
	s BedId=$p(^PAADM(EpisodeID),"^",73) 				/// 床号ID
    S PatBed=""
    s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)          /// 出生日期
	i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ErrMsg=""
	s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,AdmType,.ErrMsg) ;病历号
	s PisReqNo=$p(^DHCAPPPM(PisID),"^",4)		 		/// 申请单号
	s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	s PrevHis=$p(^DHCAPPPM(PisID),"^",24) //既往手术史
	if (PrevHis="") s PrevHis="无"
	/// 申请单内容
	s NorFlag=""
	s FrostFlag=$p(^DHCAPPPM(PisID),"^",2)   /// 冰冻标志
	i FrostFlag="Y" s FrostFlag="√"
	e  s FrostFlag=""
	s EmgFlag=$p(^DHCAPPPM(PisID),"^",3)     /// 加急标志
	i EmgFlag="Y" s EmgFlag="√",NorFlag=""
	e  s EmgFlag=""
	
	i (FrostFlag="")&&(EmgFlag="") s NorFlag="√"
	s PisNo=$p(^DHCAPPPM(PisID),"^",13)      /// 病理号
	s MedRecord=$p(^DHCAPPPM(PisID),"^",14)  /// 临床病历 临床所见
	D ##Class(web.DHCAPPExaRepCom).splitString(MedRecord, "86", "10", .TmpMedRecArr)  /// 拆分字符串
	D ..TrsTmpArr("MedRecord", .TmpMedRecArr)
	s MedDiag=$p(^DHCAPPPM(PisID),"^",15)    /// 临床诊断
	s HepatitisB=$p(^DHCAPPPM(PisID),"^",16) /// 乙肝病史
	s OperRes=$p(^DHCAPPPM(PisID),"^",17)    /// 手术所见
	D ##Class(web.DHCAPPExaRepCom).splitString(OperRes, "86", "10", .TmpOperResArr)  /// 拆分字符串
	D ..TrsTmpArr("OperRes", .TmpOperResArr)
	s InfDisHis=$p(^DHCAPPPM(PisID),"^",18)  /// 传染病史
	s FoundDate=$p(^DHCAPPPM(PisID),"^",19)  /// 首次发现人乳头瘤病毒时间
	s:FoundDate'="" FoundDate=$zd(FoundDate,3)
	s PisType=$p(^DHCAPPPM(PisID),"^",20)    /// 申请单类型
	s PisArcList=##Class(web.DHCAppPisMaster).GetPisArc(PisID)     /// 病理申请医嘱项目内容
	s ItemDesc=$p(PisArcList,"^"),LocID=$p(PisArcList,"^",2),LocDesc=$p(PisArcList,"^",3),arcimid=$p(PisArcList,"^",4),Oeori=$p(PisArcList,"^",5)

	s PisAutoPsy=##Class(web.DHCAppPisMaster).GetPisAutoPsy(PisID) /// 病理申请尸检信息内容
	s MorToDeaPro=$p(PisAutoPsy,"^"),DisAndTrePro=$p(PisAutoPsy,"^",2),PhyAndLabTest=$p(PisAutoPsy,"^",3),FinTakRes=$p(PisAutoPsy,"^",4)
	s TakBack="",TakHosp=""
	if (FinTakRes="TakBack"){
		s TakBack="√"
	}
	if (FinTakRes="TakHosp"){
		s TakHosp="√"
	}
	s PisConsult=##Class(web.DHCAppPisMaster).GetPisConsult(PisID) /// 病理申请会诊信息内容
	s InsDoc=$p(PisConsult,"^"),InsHosp=$p(PisConsult,"^",2),SpecExaRes=$p(PisConsult,"^",3),ConsNote=$p(PisConsult,"^",4),ConsStaff=$p(PisConsult,"^",5)

	s PisGynWon=##Class(web.DHCAppPisMaster).GetPisGynWon(PisID)   /// 病理申请妇科信息内容
	s LastMensDate=$p(PisGynWon,"^"),MensDate=$p(PisGynWon,"^",2),PreTimes=$p(PisGynWon,"^",3),LyTimes=$p(PisGynWon,"^",4),PauFlag=$p(PisGynWon,"^",5)
	s PauFlag=$s(PauFlag="Y":"是",1:"否")
	
	s PisCutBas=##Class(web.DHCAppPisMaster).GetPisCutBas(PisID)   /// 病理申请取材信息内容
	s SepDate=$p(PisCutBas,"^"),SepTime=$p(PisCutBas,"^",2),FixDate=$p(PisCutBas,"^",3),FixTime=$p(PisCutBas,"^",4),BLocDesc=$p(PisCutBas,"^",5)	
	s DocName=$p(PisCutBas,"^",6),Position=$p(PisCutBas,"^",7),Type=$p(PisCutBas,"^",8)
	
	s PisTumour=##Class(web.DHCAppPisMaster).GetPisTumour(PisID)   /// 病理申请肿瘤信息内容
	s TFoundDate=$p(PisTumour,"^"),TumPart=$p(PisTumour,"^",2),TumSize=$p(PisTumour,"^",3),TransFlag=$CASE($p(PisTumour,"^",4),"Y":"是",:"否"),TransPos=$p(PisTumour,"^",5)	
	s RadCureFlag=$CASE($p(PisTumour,"^",6),"Y":"是",:"否"),CheCureFlag=$CASE($p(PisTumour,"^",7),"Y":"是",:"否"),Remark=$p(PisTumour,"^",8)

	s PisReqSpec=##Class(web.DHCAPPPrintCom).GetPisReqSpec(PisID)         /// 病理标本
	D ##Class(web.DHCAPPExaRepCom).splitString(PisReqSpec, "86", "10", .TmpPisReqSpecArr)  /// 拆分字符串
	D ..TrsTmpArr("PisReqSpec", .TmpPisReqSpecArr)
	s PisTreMet=##Class(web.DHCAPPPisInterface).GetPisTreMet(PisID)       /// 治疗方式
	s PisTesItmMet=##Class(web.DHCAPPPisInterface).GetPisTesItmMet(PisID) /// 检测方法
	s PisTesDiag=##Class(web.DHCAPPPisInterface).GetPisTesDiag(PisID)     /// 临床诊断
	s PisPatRec=##Class(web.DHCAPPPisInterface).GetPisPatRec(PisID)       /// 病人病历
	s PisPatInfDis=##Class(web.DHCAPPPisInterface).GetPisPatInfDis(PisID) /// 传染病史
	s PisCutBasType=##Class(web.DHCAPPPrintCom).GetPisCutBasType(PisID)   /// 分子病理取材类型 qunianpeng 2018/2/7
	s PisTesItmMol=##Class(web.DHCAPPPrintCom).GetPisTesItmMol(PisID)	  /// 分子病理检测项目 qunianpeng 2018/2/7
	i PisTesDiag="" s PisTesDiag=MedDiag
	i PisTesDiag="" s PisTesDiag=PatDiagDesc
	
	/// 临床诊断
	D ##Class(web.DHCAPPExaRepCom).splitString(PisTesDiag, "86", "10", .TmpPisTesDiagArr)  /// 拆分字符串
	D ..TrsTmpArr("PisTesDiag", .TmpPisTesDiagArr)
	/// 病理原诊断
	D ##Class(web.DHCAPPExaRepCom).splitString(SpecExaRes, "86", "10", .TmpSpecExaResArr)  /// 拆分字符串
	D ..TrsTmpArr("SpecExaRes", .TmpSpecExaResArr)
	/// 会诊要求
	D ##Class(web.DHCAPPExaRepCom).splitString(ConsNote, "86", "10", .TmpConsNoteArr)      /// 拆分字符串
	D ..TrsTmpArr("ConsNote", .TmpConsNoteArr)
	/// 自发病至死亡病程时日
	D ##Class(web.DHCAPPExaRepCom).splitString(MorToDeaPro, "86", "10", .TmpMorToDeaArr)   /// 拆分字符串
	D ..TrsTmpArr("MorToDeaPro", .TmpMorToDeaArr)
	/// 病史及治疗经过
	D ##Class(web.DHCAPPExaRepCom).splitString(DisAndTrePro, "86", "10", .TmpDisAndTreArr)  /// 拆分字符串
	D ..TrsTmpArr("DisAndTrePro", .TmpDisAndTreArr)
	/// 临床体格检查及化验检查
	D ##Class(web.DHCAPPExaRepCom).splitString(PhyAndLabTest, "86", "10", .TmpPhyAndLabArr) /// 拆分字符串
	D ..TrsTmpArr("PhyAndLabTest", .TmpPhyAndLabArr)
	// 分子病理申请单,取材部位
	i PisType="MOL" s Position=PisReqSpec
	s Oeori=$REPLACE(Oeori,"||","-")
	
	s GreenFlag=##class(web.DHCEMInterfaceCom).CheckGreenRec(EpisodeID)   //sufan 2018-10-22  
	s GreenFlag=$s(GreenFlag="1":"绿色通道",1:"")
	s PrintTemp=..GetPisPrintTemp(PisType)            /// 打印模板
	i (PatSex'="女")&(PisType="LIV") s PrintTemp=PrintTemp_"_M"
	
	s ListData="*"_PatNo_"*^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	s ListData=ListData_"^"_ReqLoc_"^"_BillType_"^"_MedicareNo_"^"_PisReqNo_"^"_UserName_"^"_CreatDate_"^"_CreatTime
	s ListData=ListData_"^"_EpisodeID_"^"_PisReqNo_"^"_OperRes_"^"_TFoundDate_"^"_TumPart_"^"_TumSize_"^"_TransFlag_"^"_TransPos_"^"_RadCureFlag
	s ListData=ListData_"^"_CheCureFlag_"^"_Remark_"^"_LastMensDate_"^"_MensDate_"^"_PreTimes_"^"_LyTimes_"^"_PauFlag_"^"_MedRecord_"^"_EmgFlag
	s ListData=ListData_"^"_FrostFlag_"^"_SepDate_" "_SepTime_"^"_FixDate_" "_FixTime_"^"_BLocDesc_"^"_DocName_"^"_PisPatInfDis
	s ListData=ListData_"^"_MedRecord_"^"_FoundDate_"^"_PisTesItmMet_"^"_PisTesDiag_"^"_PisTreMet_"^"_SpecExaRes_"^"_ConsNote_"^"_ConsStaff_"^"_Position
	s ListData=ListData_"^"_Type_"^"_MorToDeaPro_"^"_DisAndTrePro_"^"_PhyAndLabTest_"^"_FinTakRes_"^"_PisReqSpec_"^"_arcimid_"^"_Oeori_"^"_ItemDesc_"^"_InsHosp_"^"_InsDoc_"^"_PisType_"^"_PisPatRec_"^"_PisCutBasType_"^"_PisTesItmMol
	s ListData=ListData_"^"_GreenFlag_"^"_PrintTemp_"^"_TmpMedRecArr("MedRecordVal")_"^"_TmpPisTesDiagArr("PisTesDiagVal")_"^"_TmpOperResArr("OperResVal")
	s ListData=ListData_"^"_TmpSpecExaResArr("SpecExaResVal")_"^"_TmpConsNoteArr("ConsNoteVal")_"^"_TmpMorToDeaArr("MorToDeaProVal")_"^"_TmpDisAndTreArr("DisAndTreProVal")_"^"_TmpPhyAndLabArr("PhyAndLabTestVal")
	s ListData=ListData_"^"_NorFlag_"^"_TakBack_"^"_TakHosp_"^"_PrevHis_"^"_TmpPisReqSpecArr("PisReqSpecVal")
	
	s ListTitle="BarCode^PatNo^PatName^PatSex^PatAge^PatLoc^PatWard^PatBed^PatTelH^PatBod^PatAddr^ReqLoc^BillType^MedicareNo^PisReqNo^UserName^CreatDate^CreatTime"
	s ListTitle=ListTitle_"^EpisodeID^PisReqNo^OperRes^TFoundDate^TumPart^TumSize^TransFlag^TransPos^RadCureFlag^CheCureFlag^Remark^LastMensDate^MensDate^PreTimes"
	s ListTitle=ListTitle_"^LyTimes^PauFlag^MedRecord^EmgFlag^FrostFlag^SepDate^FixDate^BLocDesc^DocName^PisPatInfDis^MedRecord^FoundDate^PisTesItmMet^PisTesDiag"
	s ListTitle=ListTitle_"^PisTreMet^SpecExaRes^ConsNote^ConsStaff^Position^Type^MorToDeaPro^DisAndTrePro^PhyAndLabTest^FinTakRes^PisReqSpec^arcimid^Oeori^ItemDesc"
	s ListTitle=ListTitle_"^InsHosp^InsDoc^PisType^PisPatRec^PisCutBasType^PisTesItmMol^GreenFlag^PrintTemp^"_TmpMedRecArr("MedRecordKey")_"^"_TmpPisTesDiagArr("PisTesDiagKey")_"^"_TmpOperResArr("OperResKey")
	s ListTitle=ListTitle_"^"_TmpSpecExaResArr("SpecExaResKey")_"^"_TmpConsNoteArr("ConsNoteKey")_"^"_TmpMorToDeaArr("MorToDeaProKey")_"^"_TmpDisAndTreArr("DisAndTreProKey")_"^"_TmpPhyAndLabArr("PhyAndLabTestKey")
	s ListTitle=ListTitle_"^NorFlag^TakBack^TakHosp^PrevHis"_"^"_TmpPisReqSpecArr("PisReqSpecKey")
	
	Q ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	//Q ""
}

/// Descript:    取病理申请标本内容
/// w ##Class(web.DHCAPPPrintCom).GetPisReqSpec("13")
ClassMethod GetPisReqSpec(PisID As %String) As %String
{
	n (PisID)
	s CH="",mListData=""
	F  s CH=$o(^DHCAPPPM(PisID,"S",CH)) Q:CH=""  D
	.s No=$p(^DHCAPPPM(PisID,"S",CH),"^",1)      /// 标本序号
	.s ID=$p(^DHCAPPPM(PisID,"S",CH),"^",2)      /// 标本标识
	.s Name=$p(^DHCAPPPM(PisID,"S",CH),"^",3)    /// 标本名称
	.s Explain=$p(^DHCAPPPM(PisID,"S",CH),"^",4) /// 标本说明
	.s Part=$p(^DHCAPPPM(PisID,"S",CH),"^",5)    /// 标本部位
	.s Qty=$p(^DHCAPPPM(PisID,"S",CH),"^",6)     /// 标本数量
	.s Remark=$p(^DHCAPPPM(PisID,"S",CH),"^",7)  /// 标本备注
	.s SliType=$p(^DHCAPPPM(PisID,"S",CH),"^",8) /// 玻片/蜡片
	.s PisNo=$p(^DHCAPPPM(PisID,"S",CH),"^",9)   /// 原病理号
	.s mTmpData=Name_" "_Qty_" "_SliType_" "_PisNo_" "_Remark
	.i mListData="" s mListData=mTmpData
	.E  s mListData=mListData_";"_mTmpData
	.
	Q mListData
}

/// Descript:    取病理申请标本内容
/// w ##Class(web.DHCAPPPrintCom).GetPisPrintByOeori("294||16")
ClassMethod GetPisPrintByOeori(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" ""
	/// 取病理申请单ID
	s PisID=$o(^DHCAPPPM(0,"OrdItem",Oeori,""))
	Q:PisID="" ""
	/// 病理申请打印内容
	q ##Class(web.DHCAPPPrintCom).GetPisPrintCon(PisID)
}

/// Creator:    sufan
/// CreateDate: 2018-02-06
/// Descript:   病理,检验条码打印数据
/// InPut:      病理申请表/检验ID
/// OutPut:     执行记录ID,标本号
/// w ##Class(web.DHCAPPPrintCom).GetPathReqData("357")
ClassMethod GetPathReqData(ExaReqID, Flag) As %String
{
	n (ExaReqID,Flag)
	s OeordExeStr="",LabNoStr=""
	s CH=""
	if Flag="1" d		//取病理信息
	.s CH=$o(^DHCAPPPM(ExaReqID,"A",CH)) 
	.s OeordID=$p(^DHCAPPPM(ExaReqID,"A",CH),"^",3)		//医嘱ID
	.q:OeordID=""
	.s Ord=$p(OeordID,"||",1)
	.s Itm=$p(OeordID,"||",2)
	.s Sub=$o(^OEORD(Ord,"I",Itm,"X",0))
	.s OeordExeId=Ord_"||"_Itm_"||"_Sub    			 	//执行记录ID
	.i OeordExeStr="" s OeordExeStr=OeordExeId
	.e  s OeordExeStr=OeordExeStr_"$"_OeordExeId
	.s LabNo=ExaReqID										//病理申请单ID
    .s specDesc=##class(web.DHCAPPPisInterface).GetSpeNameByRepID(LabNo)     ///获取标本名称
    .i LabNoStr="" s LabNoStr=LabNo
    .e  s LabNoStr=LabNoStr_"$"_LabNo
    .s DisposeStatCode="Immediate"
    .s BarType="BLDO"
    if Flag="2" d		//取检验信息
    .for  s CH=$o(^DHCAPREP(ExaReqID,"AR",CH))  	q:CH=""  d
    ..s OeordID=$p(^DHCAPREP(ExaReqID,"AR",CH),"^",3)		//医嘱ID
	..s Ord=$p(OeordID,"||",1)
	..s Itm=$p(OeordID,"||",2)
	..s Sub=$o(^OEORD(Ord,"I",Itm,"X",0))
	..s OeordExeId=Ord_"||"_Itm_"||"_Sub    			//执行记录ID
	..i OeordExeStr="" s OeordExeStr=OeordExeId
	..e  s OeordExeStr=OeordExeStr_"$"_OeordExeId
	..s LabNo=$p($g(^OEORD(Ord,"I",Itm,3)),"^",20)		//标本号(检验)
    ..i LabNoStr="" s LabNoStr=LabNo
    ..e  s LabNoStr=LabNoStr_"$"_LabNo
    ..s DisposeStatCode="Immediate"
    ..s BarType="JYDO"
    s Setstr=##class(Nur.DHCMGNurseSet).getSet()       //获取IP地址
    s WebIP=$P(Setstr,"^",2)
    s ListTitle="OeordExeStr^LabNoStr^DisposeStatCode^BarType^WebIP"
	s ListData=OeordExeStr_"^"_LabNoStr_"^"_DisposeStatCode_"^"_BarType_"^"_WebIP
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Creator:    qunianpeng
/// CreateDate: 2018-02-07
/// Descript:   获取分子病理检验项目
/// InPut:      病理申请表ID
/// OutPut:     检测项目字符串
/// w ##Class(web.DHCAPPPrintCom).GetPisTesItmMol("394")
ClassMethod GetPisTesItmMol(PisID As %String) As %String
{
	n (PisID)
	q:PisID="" ""
	
	s (ATIStr,APRowID)=""
	f  s APRowID=$o(^DHCAPPPTI(0,"PisMas",PisID,APRowID))  q:APRowID=""  d
	.s TesItmID=$p(^DHCAPPPTI(APRowID),"^",2)
	.q:TesItmID=""
	.s ATIDesc=$p($g(^DHCAPPTI(TesItmID)),"^",2)  	//User.DHCAppTestItem
	.i ATIStr="" s ATIStr=ATIDesc
	.e  s ATIStr=ATIStr_", "_ATIDesc
	
	q ATIStr
}

/// Creator:    qunianpeng
/// CreateDate: 2018-02-07
/// Descript:   获取分子病理取材类型
/// InPut:      病理申请表ID
/// OutPut:     检测项目字符串
/// w ##Class(web.DHCAPPPrintCom).GetPisCutBasType("394")
ClassMethod GetPisCutBasType(PisID As %String) As %String
{
	n (PisID)
	q:PisID="" ""
	s (AcStr,Sub)=""
	f  s Sub=$o(^DHCAPPPM(PisID,"S",Sub))  q:Sub=""  d
	.s APType=$p(^DHCAPPPM(PisID,"S",Sub),"^",10)
	.q:APType=""
	.s AcDesc=$p(^DHCAPPCB(APType),"^",2)  //User.DHCAppCutBas
	.i AcStr="" s AcStr=AcDesc
	.e  s AcStr=AcStr_","_AcDes
	
	q AcStr
}

/// Creator:    bianshuai
/// CreateDate: 2017-11-02
/// Descript:   提取病理申请单标签打印内容
/// InPut:      Oeori-医嘱ID
/// OutPut:     病理申请单标签打印内容Json，其他-失败
/// w ##Class(web.DHCAPPPrintCom).GetPisPriBarContent("6||56")
ClassMethod GetPisPriBarContent(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" ""
	s ID=$o(^DHCAPPPM(0,"OrdItem",Oeori,"")) /// 申请单ID
	Q:ID="" ""
	D ##Class(web.DHCAPPPrintCom).GetPathReqData(ID,"1")
	Q ""
}

/// Creator:    	bianshuai
/// CreateDate: 	2018-03-26
/// Descript:   	根据医嘱ID取申请单打印类型和申请ID
/// InPut:      	Oeori-医嘱ID
/// OutPut:     	病理申请单标签打印内容Json，其他-失败
/// w ##Class(web.DHCAPPPrintCom).GetJsonReqPrtObj("5430||430^39||10^16||12^5430||429")
ClassMethod GetJsonReqPrtObj(mListData As %String) As %String
{
	n (mListData)
	Q:mListData="" ""
	k TempOrdArr
	F i=1:1:$L(mListData,"^") D
	.s Oeori=$p(mListData,"^",i)
	.s ID=$o(^DHCAPPPM(0,"OrdItem",Oeori,""))  /// 病理申请单ID
	.i ID'="" D
	..s TempOrdArr(ID)="P^"_ID
	.Q:ID'=""
	.s ID=$o(^DHCAPREP(0,"OrdItem",Oeori,""))  /// 检查申请ID
	.i ID'="" D
	..s ArcimID =$p($g(^OEORD(+Oeori,"I",$P(Oeori,"||",2),1)),"^",2)
	..s OECCat= ##Class(web.DHCAPPExaReportQuery).GetTraType(ArcimID)
	..s TempOrdArr(ID)=OECCat_"^"_ID
	
	w "["
	s index="",count=0
	F  s index=$o(TempOrdArr(index)) Q:index=""  D
	.s Type=$p(TempOrdArr(index),"^",1)  /// 申请类型
	.s ID=$p(TempOrdArr(index),"^",2)    /// 申请ID
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCAPPJsonCommon).getJsonData("Type^ID",Type_"^"_ID)
	.e  d
	..w ","_##class(web.DHCAPPJsonCommon).getJsonData("Type^ID",Type_"^"_ID)
	w "]"
	Q ""
}

ClassMethod GetOECCatByOEORDItmDr(OEORIDr)
{
	n (OEORIDr,%session)
	s Ord = +OEORIDr
	s Itm = $p(OEORIDr,"||",2)
	s ArcimID =$p($g(^OEORD(Ord,"I",Itm,1)),"^",2)
	q:ArcimID="" ""
	s ARCICatDr = $p(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1),"^",10)
	s OECCatDr = $p(^ARC("IC",ARCICatDr),"^",8)
	s OECCatDesc = $p(^OEC("ORCAT",OECCatDr),"^",2)
	q OECCatDesc
}

/// Descript: 获取病人预住院和日间标志
ClassMethod GetPatPreInFlag(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s PreInFlag=""
	s VisitStatus=$p(^PAADM(EpisodeID),"^",20)  /// 病人当前状态
	s TreatedOldCode=""
	s TreatedOld=$P($G(^PAADM(EpisodeID,"DHC")),"^",49)
	s:TreatedOld'="" TreatedOldCode=$P($G(^DHCDocIPBDIC(TreatedOld)),"^",1)
	i (VisitStatus="P")&(TreatedOldCode="DaySurg") s PreInFlag="日间"
	i (VisitStatus="P")&(TreatedOldCode'="DaySurg") s PreInFlag="预"
	i VisitStatus'="P" s PreInFlag=""
	Q PreInFlag
}

/// 打印检验告知单
/// w ##class(web.DHCAPPPrintCom).GetExaLabPrintData(810)
ClassMethod GetExaLabPrintData(ExaReqID As %String) As %String
{
	s EpisodeID=$p(^DHCAPREP(ExaReqID),"^",6)	      /// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)           /// 病人ID
	s selectedOEItemID=""
	s SubRowid=""
	for {
		s SubRowid=$O(^DHCAPREP(ExaReqID,"AR",SubRowid))
		q:SubRowid=""
		if (selectedOEItemID=""){ s selectedOEItemID=$P(^DHCAPREP(ExaReqID,"AR",SubRowid),"^",3)}
		else{s selectedOEItemID=selectedOEItemID_"^"_$P(^DHCAPREP(ExaReqID,"AR",SubRowid),"^",3)}
	}
	d ##class(DHCDoc.OPDoc.TreatPrint).GetJYDPrintData(EpisodeID,selectedOEItemID,"","JYDO","Print")
	s rtn=""
	q rtn
}

/// 打印检验告知单
/// tanjishan 2019-12-27屏蔽该方法，统一使用总览打印的获取打印数据的方法
/// w ##class(web.DHCAPPPrintCom).GetExaLabPrintData(810)
ClassMethod GetExaLabPrintDataOld(ExaReqID As %String) As %String
{
	s EpisodeID=$p(^DHCAPREP(ExaReqID),"^",6)	      /// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)           /// 病人ID
	s selectedOEItemID=""
	s SubRowid=""
	for {
		s SubRowid=$O(^DHCAPREP(ExaReqID,"AR",SubRowid))
		q:SubRowid=""
		if (selectedOEItemID=""){ s selectedOEItemID=$P(^DHCAPREP(ExaReqID,"AR",SubRowid),"^",3)}
		else{s selectedOEItemID=selectedOEItemID_"^"_$P(^DHCAPREP(ExaReqID,"AR",SubRowid),"^",3)}
		}
	s PatInfoStr=##class(DHCDoc.OPDoc.TreatPrint).GetPatBaseInfo(EpisodeID)
	s PANo=$p(PatInfoStr,"^",1)
	s PatientMedicareNo=$p(PatInfoStr,"^",2)
	s AdmDep=$p(PatInfoStr,"^",3)
	s AdmDate=$p(PatInfoStr,"^",4)
	s MRNo=$p(PatInfoStr,"^",5)
	s Name=$p(PatInfoStr,"^",6)
	s Sex=$p(PatInfoStr,"^",7)
	s Age=$p(PatInfoStr,"^",8)
	s Company=$p(PatInfoStr,"^",9)
	s Childweight=$p(PatInfoStr,"^",10)
    s Diagnose1=$p(PatInfoStr,"^",11)
    s Diagnose2=$p(PatInfoStr,"^",12)
    s Diagnose3=$p(PatInfoStr,"^",13)
    s Diagnose4=$p(PatInfoStr,"^",14)
    s Diagnose5=$p(PatInfoStr,"^",15)
    s Diagnose6=$p(PatInfoStr,"^",16)
    s SessHospDesc=$p(PatInfoStr,"^",17)
    s AdmReason=$p(PatInfoStr,"^",18)	
	s Diagnose1=$p(PatInfoStr,"^",11)
    s Diagnose2=$p(PatInfoStr,"^",12)
    s Diagnose3=$p(PatInfoStr,"^",13)
    s Diagnose4=$p(PatInfoStr,"^",14)
    s Diagnose5=$p(PatInfoStr,"^",15)
    s Diagnose6=$p(PatInfoStr,"^",16)
    s MRDiagnos=Diagnose1_" "_Diagnose2_" "_Diagnose3_" "_Diagnose4_" "_Diagnose5_" "_Diagnose6
	s PrintTime=$zd(+$h,3)_" "_..%ZT(..%SysTime(),1)
	s SessHospDesc=SessHospDesc_"检验告知单"
	//检验单需要考虑分页问题
	s PageOnLine=17 //一页显示行数
	s tIndx="QuerySYZSForPrint_"_$j
	k ^CacheTemp(tIndx)
	s Group=0,Count=0
	set rs=##class(%ResultSet).%New()
	set rs.ClassName="web.UDHCOrderItemLabPrint"
	set rs.QueryName="GetOrderItems"
	set sc=rs.Execute(EpisodeID,"")
	while rs.Next(.sc) {
		if $$$ISERR(sc) q
		s OrdRowid=rs.Data("Rowid")
		continue:(selectedOEItemID'="")&&(("^"_selectedOEItemID_"^")'[("^"_OrdRowid_"^"))
		s OrderName=rs.Data("OrderName")_"("_$fn(rs.Data("Price"),"",2)_"元)"
		s spec=rs.Data("Spec")
		s LabEpisodeNo=rs.Data("LabEpisodeNo")
		s ProcessingNotes=rs.Data("ProcessingNotes")
		if (ProcessingNotes=""){
			s ProcessingNotes=rs.Data("DepProcNotes")
		}
		s Count=Count+1
		s ^CacheTemp(tIndx,Count)=OrderName_"^"_spec_"^"_LabEpisodeNo_"^"_ProcessingNotes
	}
	s arUserID=$p(^DHCAPREP(ExaReqID),"^",4)          /// 申请人
	s:arUserID'="" arUserCode=$p(^SSU("SSUSR",arUserID),"^",2)
	s Len=$o(^CacheTemp(tIndx,""),-1)
	s PageSum=Len/PageOnLine
	if (PageSum[".") s PageSum=$p(PageSum,".",1)+1
	s rtn=""
	for PageNum=1:1:PageSum{
		s MinLen=PageOnLine*(PageNum-1)+1
		s MaxLen=PageOnLine*PageNum
		if (Len<MaxLen) s MaxLen=Len
		s PrintTemp=..GetPrintTemp(ExaReqID)  
		s ListTitle="PrintTemp^HosName^PANo^AdmDep^PrintDate^Name^Sex^Age^MRDiagnos^AdmDoc"
		s mListData=PrintTemp_"^"_SessHospDesc_"^"_PANo_"^"_AdmDep_"^"_PrintTime_"^"_Name_"^"_Sex_"^"_Age_"^"_MRDiagnos_"^"_arUserCode
		s index=MinLen-1
		s ListOBJ=""
		f  s index=$o(^CacheTemp(tIndx,index)) q:(index="")||(index>MaxLen)  d
		.s OrderName=$p(^CacheTemp(tIndx,index),"^",1)
		.s spec=$p(^CacheTemp(tIndx,index),"^",2)
		.s LabEpisodeNo=$p(^CacheTemp(tIndx,index),"^",3)
		.s ProcessingNotes=$p(^CacheTemp(tIndx,index),"^",4)
		.s OneList="^"_OrderName_"^"_spec_"^"_LabEpisodeNo_"^"_ProcessingNotes
		.if ListOBJ="" s ListOBJ=OneList
		.e  s ListOBJ=ListOBJ_$C(2)_OneList
		s PrintPage="第 "_PageNum_" 页  共 "_PageSum_" 页"
		s ListTitle=ListTitle_"^PageNum"
		s mListData=mListData_"^"_PrintPage
		s XmlDate=##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,mListData)
		if (rtn=""){s rtn=XmlDate_"!!!"_ListOBJ}
		else {s rtn=rtn_"!^^!"_XmlDate_"!!!"_ListOBJ}
	}
	q rtn
}

ClassMethod GetMRDiagnosDesc(MRAdmRowid As %String, DelimStr As %String, Type As %String = "", ExaRepDiags As %String = "") As %String
{
	n (MRAdmRowid,DelimStr,Type,ExaRepDiags)
	q:MRAdmRowid="" ""
	s MRAdmRowid=$p(^PAADM(MRAdmRowid),"^",61)
	q:MRAdmRowid="" ""
	s retval=""
	s i=0
	Set obj=##class(%ResultSet).%New("web.MRDiagnos:Find")
	d obj.Execute(MRAdmRowid)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.Q:(ExaRepDiags'="")&&(("^"_ExaRepDiags_"^")'[("^"_Rowid_"^"))
	.s DiagnosCat=##class(DHCDoc.Diagnos.Common).GetDiagnosCat(Rowid)
	.s Desc=##class(DHCDoc.Diagnos.Common).GetDiagDesc(Rowid,"Y")
	.i DiagnosCat="" s DiagnosCat="西医"
	.q:(Type="GC")&&(DiagnosCat="西医")  				;中医诊断
	.q:(Type="GX")&&(DiagnosCat'="西医")  				;西医诊断
	.q:(Type="ZX")&&(DiagnosCat'="证型")  				;证型  
	.//证型与诊断不要区分(需求810128)
	.i DiagnosCat'="证型"  d
	..s i=i+1
	..s Desc=i_"."_Desc
	.i retval="" d
	..s retval=Desc
	.e  d
	..s retval=$s(DiagnosCat="证型":retval_" "_Desc,1:retval_DelimStr_Desc)
	.
	d obj.Close()
	Q retval
	//q $ZCVT($g(retval),"O","JS")
}

}
