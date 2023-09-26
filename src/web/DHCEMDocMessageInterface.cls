Class web.DHCEMDocMessageInterface Extends %Persistent
{

/// w ##class(web.DHCEMDocMessageInterface).platformMessageNumber("jzys01","1130")
ClassMethod platformMessageNumber(userCode = "", messageCode = "")
{
	s code=200,data="",msg=""
	s userId=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),"")) 
	s:+userId=0 code=500,msg=userCode_"未找到对应用户!"
	i +userId'=0 {
		;##class(%ResultSet).RunQuery("websys.DHCMessageDetailsMgr","FindCountAndBizIds",18849,"1000","N")
		s result=##class(%Library.ResultSet).%New("websys.DHCMessageDetailsMgr:FindCountAndBizIds")
	 	s sc=result.Execute(userId,messageCode,"N")
	 	i $$$ISERR(sc) q ""
		while(result.Next())
		{ 
			s data = result.Data("count")
		}
	}
	b ;c1
	/*s:(messageCode="1000")&&(data=0) data=3 // 危急值
	s:(messageCode="1046")&&(data=0) data=2 // 抗菌药物审核
	s:(messageCode="1003")&&(data=0) data=6 // 处方审核
	s:(messageCode="1044")&&(data=0) data=1 // 处方审核申诉
	s:(messageCode="1002")&&(data=0) data=4 // 处方点评
	s:(messageCode="1056")&&(data=0) data=2 // 处方点评申诉
	s:(messageCode="1008")&&(data=0) data=5 // 病历质控
	s:(messageCode="1132")&&(data=0) data=2 // 拒绝发药
	s:(messageCode="1048")&&(data=0) data=1 // 拒绝发药申诉
	s:(messageCode="1014")&&(data=0) data=6 // 会诊
	s:(messageCode="1220")&&(data=0) data=2 // 会诊驳回
	s:(messageCode="1019")&&(data=0) data=2 // 皮试结果	
	s:(messageCode="1130")&&(data=0) data=6 // 不良事件驳回
	s:(messageCode="1069")&&(data=0) data=3 // 病历权限申请（拒绝）
	s:(messageCode="1204")&&(data=0) data=5 // 用药建议申诉
	*/
	q ##class(web.DHCEMDocMessageInterface).hosMessageResponse(code,data,msg)
}

/// 返回hos消息组件需要的格式
ClassMethod hosMessageResponse(code = "200", data = "0", msg = "", success = "true")
{
	s obj = {} 
	s obj.code = code
	s obj.data = data
	s obj.msg = msg
	s obj.success = success
    q obj.%ToJSON()
}

/// Descript: 急诊医生二屏统计-第一行 当日各级分级人数(设计无未分级项，故采用遍历分诊表方式)
/// w ##class(web.DHCEMDocMessageInterface).getLevNum()
ClassMethod getLevNum(HOSPID = "")
{
	s stDate=+$h
  	s edDate=+$h
  	s LevOne=0,LevTwo=0,LevThr=0,LevFou=0,LevFiv=0,LevAll=0
  	;s LevOne=10,LevTwo=22,LevThr=32,LevFou=44,LevFiv=60
	f Date=stDate:1:edDate  d 
	.s PCLDr = 0
	.f  s PCLDr = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
	..s PatientID=$p(^DHCEMPCL(PCLDr),"^",1)      /// 病人ID
	..q:'$d(^PAPER(PatientID))            ///QQA 2017-08-22 过滤错误数据
	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:(HOSPID'="")&(CurHospID'=HOSPID) //ed
    ..s PCLNurseLevel=$p(^DHCEMPCL(PCLDr),"^",7) //护士分级
    ..q:+PCLNurseLevel=0
	..s:PCLNurseLevel=1 LevOne=LevOne+1
	..s:PCLNurseLevel=2 LevTwo=LevTwo+1
	..s:PCLNurseLevel=3 LevThr=LevThr+1
	..s:PCLNurseLevel=4 LevFou=LevFou+1
	..s:PCLNurseLevel=5 LevFiv=LevFiv+1
    s LevAll=LevOne+LevTwo+LevThr+LevFou+LevFiv
	s ListData=LevOne_"^"_LevTwo_"^"_LevThr_"^"_LevFou_"^"_LevFiv_"^"_LevAll
	s ListTitle="LevOne^LevTwo^LevThr^LevFou^LevFiv^LevAll"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Creator：      hxy
/// CreatDate：    2022-11-14
/// Description:： 急诊医生/留观医生二屏统计
/// Table：        
/// Input：        
/// Output：       
/// Return：       
/// Others：w ##class(web.DHCEMDocMessageInterface).getStatisNum()
ClassMethod getStatisNum(HOSPID = "")
{
	s stDate=+$h
  	s edDate=+$h
	s AdmNum=..PatAdmNum(stDate,edDate,HOSPID)
	s DocNum=..DocNum(HOSPID)	
	s Ratio="0" //医患比
	s:AdmNum'=0 Ratio=$j(DocNum/AdmNum,2,2)

	s NurNum=..NurNum()	
	s NurRatio="0" //护患比
	s:AdmNum'=0 NurRatio=$j(NurNum/AdmNum,2,2)

	s SurDeathRatio=0 //手术患者死亡率
	s SurDeathRatio=..SurDeathRatio(stDate,edDate,HOSPID)
	
	s ROSCRatio="0" //ROSC成功率
	s ROSCRatio=..ROSCRatio(stDate,edDate,HOSPID)
	
	s SalDeaRatio=0 //抢救死亡率
	s SalDeaRatio=..SalDeaRatio(stDate,edDate,HOSPID)
	
	s ReturnRatio=0 //72小时重返率
	s ReturnRatio=..ReturnRatio(stDate,edDate,HOSPID)
	
	s ChkRatio=0 //急诊分诊率
	s ChkRatio=..ChkRatio(stDate,edDate,HOSPID)
	
#;	s:AdmNum=0 Ratio=0.50 //效果展示，后期删除！
#;	s:AdmNum=0 NurRatio=0.60 //效果展示，后期删除！
#;	s:+ROSCRatio=0 ROSCRatio=0.74
#;	s:SalDeaRatio=0 SalDeaRatio=0.33
#;	s:ReturnRatio=0 ReturnRatio=0.10
#;	s:ChkRatio=0 ChkRatio=0.97
	
	s ListData=Ratio_"^"_SurDeathRatio_"^"_ROSCRatio_"^"_SalDeaRatio_"^"_ReturnRatio_"^"_ChkRatio_"^"_NurRatio
	s ListTitle="Ratio^SurDeathRatio^ROSCRatio^SalDeaRatio^ReturnRatio^ChkRatio^NurRatio"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Others：w ##class(web.DHCEMDocMessageInterface).ChkRatio(66427,66427,)
ClassMethod ChkRatio(stDate, edDate, HOSPID = "")
{
	s ChkRatio=0
	s ChkNum=0,AllNum=0
	f Date=stDate:1:edDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)
   	..s PCLRowID=$o(^DHCEMPCA(0,"AdmChkLev",EpisodeID,""))
   	..s AllNum=AllNum+1
   	..s:+PCLRowID'=0 ChkNum=ChkNum+1
	
	s:+AllNum'=0 ChkRatio=$j(ChkNum/AllNum,1,2)
	q ChkRatio
}

/// Others：w ##class(web.DHCEMDocMessageInterface).ReturnRatio(66427,66427,)
ClassMethod ReturnRatio(stDate, edDate, HOSPID = "")
{
	s ret=0
	k ^TMP("DHCEM","web.DHCEMDocMessageInterface","ReturnRatio") //2017-07-18 yuliping
	s ReturnNum=0,AllNum=0
 	f Date=stDate:1:edDate  d 
 	.s PCLDr="" 
 	.f  s PCLDr  = $o(^DHCEMPCL(0,"CreateDate",Date,PCLDr)) q:PCLDr=""  d
 	..s PAPMIDr = $p(^DHCEMPCL(PCLDr),"^",1)
 	..q:+PAPMIDr=0
 	..q:'$d(^PAPER(PAPMIDr))  ;2017-08-22 qqa 58上错误数据过滤
 	..s PatLocID=$p(^DHCEMPCL(PCLDr),"^",10) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:(HOSPID'="")&(CurHospID'=HOSPID) //ed
 	..i $d(^TMP("DHCEM","web.DHCEMDocMessageInterface","ReturnRatio",PAPMIDr)) d       ///这里很明显临时globle保存病人ID以及对应的分诊ID
 	...s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ReturnRatio",PAPMIDr) = ^TMP("DHCEM","web.DHCEMDocMessageInterface","ReturnRatio",PAPMIDr)_":"_PCLDr
 	..e  d
 	...s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ReturnRatio",PAPMIDr) = PCLDr
		
	s PAPMIDr=""
	f  s PAPMIDr = $o(^TMP("DHCEM","web.DHCEMDocMessageInterface","ReturnRatio",PAPMIDr)) q:PAPMIDr=""  d
	.s pclRowIdStr = ^TMP("DHCEM","web.DHCEMDocMessageInterface","ReturnRatio",PAPMIDr)
	.i (##class(web.DHCEMPatCheckLevStat).PatIsReturn(pclRowIdStr)) d
	..s ReturnNum=ReturnNum+1
	.s AllNum=AllNum+1
	s:AllNum'=0 ret= $j(ReturnNum/AllNum,2,2)
	k ^TMP("DHCEM","web.DHCEMDocMessageInterface","ReturnRatio")
	q ret
}

/// Others：w ##class(web.DHCEMDocMessageInterface).SalDeaRatio(66427,66427,)
ClassMethod SalDeaRatio(stDate, edDate, HOSPID = "")
{
	s SalDeaRatio=0
	s AllNum=0,DeathNum=0
	f Date=stDate:1:edDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d 
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)
  	..s IsSalvage=##class(web.DHCEMPatCheckLevStatis).IsSalvagePat(EpisodeID)
   	..q:IsSalvage'="Y"
   	..s AllNum=AllNum+1
   	..s PatientID=+^PAADM(EpisodeID)
   	..s IsDeath = $p(^PAPER(PatientID,"ALL"),"^",12)
   	..s:IsDeath="Y" DeathNum=DeathNum+1
	
	s:AllNum'=0 SalDeaRatio=$j(DeathNum/AllNum,1,2)
	q SalDeaRatio
}

/// Others：w ##class(web.DHCEMDocMessageInterface).ROSCRatio(66427,66427,)
ClassMethod ROSCRatio(stDate, edDate, HOSPID = "")
{
	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","CARDRESUSC",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
 	s CardResuscNum=0,DeathNum=0,ROSCRatio="0"
	f Date=stDate:1:edDate  d 
	.s EpisodeID=""  s HasOrdIDs=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d  
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)
   	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid("",SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s OrdItmID=$p(HasOrdIDs,"^",1) //ed
   	..s OpenOrdDate="",OpenOrdTime=""
   	..i OrdItmID'="" d
   	...s Ord=+OrdItmID
   	...s Itm=$p(OrdItmID,"||",2)
   	...s OpenOrdDate=$p($g(^OEORD(Ord,"I",Itm,1)),"^",9) 
   	...s OpenOrdTime=$p($g(^OEORD(Ord,"I",Itm,1)),"^",10) 
   	..s CardResuscNum=CardResuscNum+1
   	..s PatientID=+^PAADM(EpisodeID)
   	..s IsDeath = $p(^PAPER(PatientID,"ALL"),"^",12)
   	..s DeceasedDate=$p(^PAPER(PatientID,"ALL"),"^",13)
	..s DeceasedTime=$p(^PAPER(PatientID,"ALL"),"^",8)
	..i IsDeath="Y" d
	...s LimitDateTime=(DeceasedDate-OpenOrdDate)+((DeceasedTime-OpenOrdTime)/60/60/24)
	...s:LimitDateTime<1 DeathNum=DeathNum+1
	
	s:+CardResuscNum'=0 ROSCRatio=$j(CardResuscNum-DeathNum/CardResuscNum,1,2)
	q ROSCRatio
}

/// Others：w ##class(web.DHCEMDocMessageInterface).SurDeathRatio(66427,66427,)
ClassMethod SurDeathRatio(stDate, edDate, HOSPID = "")
{
	s SetData =##Class(web.DHCAppComPar).GetAppPropValue("DHCEMSTAT","SURGPAT",+$g(HOSPID),"","","")
 	s SetData = ##class(web.DHCEMPatCheckLevStatis).FormatSettingData(SetData)
 	s SetDataDiag = $p(SetData,"^",1)
 	s SetDataOrd = $p(SetData,"^",2)
 	
 	s AllNum=0,DeathNum=0,DeathRatio=0
	f Date=stDate:1:edDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d
    ..s AdmHospID = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(EpisodeID)
    ..q:(HOSPID'="")&&(AdmHospID'=HOSPID)   
	..s PatDiag=##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(EpisodeID,",")	;诊断
	..q:##class(web.DHCEMPatCheckLevStatis).SetDiagValid(PatDiag,SetDataDiag)'="Y"	;验证诊断
   	..s HasOrdIDs=""
   	..i SetDataOrd'="" d
   	...s HasOrdIDs=##class(web.DHCEMPatCheckLevStatis).SetOrdValid(EpisodeID,SetDataOrd)
   	..q:(SetDataOrd'="")&&(HasOrdIDs="")	;验证医嘱
   	..s AllNum=AllNum+1
   	..s PatientID=+^PAADM(EpisodeID)
   	..s IsDeath = $p(^PAPER(PatientID,"ALL"),"^",12)
   	..s:IsDeath="Y" DeathNum=DeathNum+1
   	s:AllNum'=0 DeathRatio=$j(DeathNum/AllNum,2,2)
   	
   	q DeathRatio
}

/// Description:：医生数
/// w ##class(web.DHCEMDocMessageInterface).DocNum(2)
ClassMethod DocNum(HOSPID)
{
	s DocNum=0
  	s GroupID=$O(^SSU("SSGRP",0,"Desc","急诊医师",""))
  	s UserNomal=""
	f  s UserNomal=$O(^SSU("SSUSR",0,"Group",GroupID,UserNomal)) q:UserNomal=""  d
	.q:(HOSPID'="")&&($p(^SSU("SSUSR",UserNomal),"^",98)'=HOSPID)
	.S UserNomalActive=$p(^SSU("SSUSR",UserNomal),"^",19)
	.Q:(UserNomalActive'="")&&(UserNomalActive="N") 
	.S UserNomalDateFrom=$p(^SSU("SSUSR",UserNomal),"^",96) ;生效日期
	.S UserNomalDateTo=$p(^SSU("SSUSR",UserNomal),"^",97) ;截止日期
	.Q:(UserNomalDateFrom'="")&&(UserNomalDateFrom>+$h) 
	.Q:(UserNomalDateTo'="")&&(UserNomalDateTo<+$h) 
	.s DocNum=DocNum+1
	s UserId=""
	f  s UserId = $O(^SSU("SSUSR",UserId)) q:UserId=""  d
	.q:(HOSPID'="")&&($p(^SSU("SSUSR",UserId),"^",98)'=HOSPID)
	.q:$p(^SSU("SSUSR",UserId),"^",5)=GroupID
	.S UserActive=$p(^SSU("SSUSR",UserId),"^",19)
	.Q:(UserActive'="")&&(UserActive="N") 
	.S UserDateFrom=$p(^SSU("SSUSR",UserId),"^",96) ;生效日期
	.S UserDateTo=$p(^SSU("SSUSR",UserId),"^",97) ;截止日期
	.Q:(UserDateFrom'="")&&(UserDateFrom>+$h) 
	.Q:(UserDateTo'="")&&(UserDateTo<+$h) 
	.s ChildSub=0,Flag=""
	.f  s ChildSub = $O(^SSU("SSUSR",UserId,"OTHLL",ChildSub)) q:(ChildSub="")!(Flag'="")  d
	..s othllInfo=$g(^SSU("SSUSR",UserId,"OTHLL",ChildSub))
	..s GroupDr=$p(othllInfo,"^",2)
	..s:GroupDr=GroupID Flag=1
	.s:Flag=1 DocNum=DocNum+1
	q DocNum
}

/// Description:：患者数
/// w ##class(web.DHCEMDocMessageInterface).PatAdmNum(66427,66427,2)
ClassMethod PatAdmNum(stDate, edDate, HOSPID)
{
	s ret=0
	f AdmDate=stDate:1:edDate  d 
  	.s AdmRowID=""
  	.f  s AdmRowID=$o(^PAADMi("AdmDateCurr",AdmDate,AdmRowID))  q:AdmRowID=""  d
  	..s AdmType=$p(^PAADM(AdmRowID),"^",2)
  	..q:AdmType'="E"
  	..s PatLocID=$p(^PAADM(AdmRowID),"^",4) //hxy 2020-06-11 st
    ..s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	..q:(HOSPID'="")&&(CurHospID'=HOSPID) //ed
  	..s ret=ret+1
	q ret
}

/// Description:：护士数
/// w ##class(web.DHCEMDocMessageInterface).NurNum()
ClassMethod NurNum()
{
	s NurNum=0
  	s GroupID=$O(^SSU("SSGRP",0,"Desc","急诊留观抢救护士",""))
  	s UserNomal=""
	f  s UserNomal=$O(^SSU("SSUSR",0,"Group",GroupID,UserNomal)) q:UserNomal=""  d
	.s NurNum=NurNum+1
	s UserId=""
	f  s UserId = $O(^SSU("SSUSR",UserId)) q:UserId=""  d
	.q:$p(^SSU("SSUSR",UserId),"^",5)=GroupID
	.s ChildSub=0,Flag=""
	.f  s ChildSub = $O(^SSU("SSUSR",UserId,"OTHLL",ChildSub)) q:(ChildSub="")!(Flag'="")  d
	..s othllInfo=$g(^SSU("SSUSR",UserId,"OTHLL",ChildSub))
	..s GroupDr=$p(othllInfo,"^",2)
	..s:GroupDr=GroupID Flag=1
	.s:Flag=1 NurNum=NurNum+1
	q NurNum
}

/// w ##class(web.DHCEMDocMessageInterface).getStatis()
ClassMethod getStatis(Params)
{
	s Del=""""
	w "{"
	s ordCat=..ordCat()
	w Del_"XStr"_Del_":"
	w $p(ordCat,"^",1)
	;w "[188,200,234,140, 232, 101, 264, 90, 340, 250]"
	w ","
	w Del_"ZStr"_Del_":"
	w $p(ordCat,"^",2)
	;w "[199,320,188,120, 282, 111, 234, 220, 340, 310]"
	w ","
	w Del_"YStr"_Del_":"
	w $p(ordCat,"^",3)
	;w "[288,123,342,320, 132, 201, 334, 190, 130, 220]"
	w ","
	w Del_"CStr"_Del_":"
	w $p(ordCat,"^",4)
	;w "[234,125,421,220, 402, 231, 134, 190, 230, 120]"
	w ","
	w Del_"OStr"_Del_":"
	w $p(ordCat,"^",5)
	;w "[184,321,354,220, 302, 181, 234, 210, 290, 150]"
	w ","
	w Del_"XAxisStr"_Del_":"
	w $p(ordCat,"^",6)
	w ","
	w Del_"MioDrug"_Del_":"
	d ..MioDrug()
	w ","
	w Del_"MioBall"_Del_":"
	d ..MioBall()
	w ","
	w Del_"medTime"_Del_":"
	d ..medTime()
	w ","
	w Del_"PatSource"_Del_":"
	s Stdate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(+$h)
	d ##class(web.DHCEMAnalysessCheckLev).PatGetSource(Stdate, Stdate,2)
	;w "[{"_Del_"value"_Del_":1 ,"_Del_"name"_Del_": "_Del_"120"_Del_"},{"_Del_"value"_Del_":0 ,"_Del_"name"_Del_": "_Del_"救助站"_Del_"},{"_Del_"value"_Del_":2 ,"_Del_"name"_Del_": "_Del_"外院"_Del_"},{"_Del_"value"_Del_":43 ,"_Del_"name"_Del_": "_Del_"自行来院"_Del_"},{"_Del_"value"_Del_":8 ,"_Del_"name"_Del_": "_Del_"未知"_Del_"}]"
	w ","
	w Del_"PatTypeNum"_Del_":"
	d ..PatTypeNum()
	w ","
	s ObsStr=..ObsData()
	w Del_"Obs"_Del_":"_$p(ObsStr,"^",1)
	w ","
	w Del_"ObsData"_Del_":"_$p(ObsStr,"^",2)
	w ","
	w Del_"WorkLoad"_Del_":"
	d ..WorkLoad(Params)
	
	w "}"
	q ""
}

/// d ##class(web.DHCEMDocMessageInterface).ordCat()
ClassMethod ordCat()
{
	s endDate=+$h
	s startDate=endDate-300
	s stY=$p($zd(startDate,3),"-",1)
	s stM=$p($zd(startDate,3),"-",2)
	s edY=$p($zd(endDate,3),"-",1)
	s edM=$p($zd(endDate,3),"-",2)
	K ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat")
	s Del=""""
	s XAxisStr=""
	i stY=edY d
	.for i=stM:1:edM  d
	..s Mon=i
	..s:$l(Mon)=1 Mon="0"_Mon
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","西药",stY_"-"_Mon)=0
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","中药",stY_"-"_Mon)=0
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","检验",stY_"-"_Mon)=0
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","检查",stY_"-"_Mon)=0
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","其他",stY_"-"_Mon)=0
	..s:(XAxisStr'="") XAxisStr=XAxisStr_","_Del_stY_"-"_Mon_Del
	..s:(XAxisStr="") XAxisStr=Del_stY_"-"_Mon_Del
	
	i stY'=edY d
	.for i=stM:1:12  d
	..s Mon=i
	..s:$l(Mon)=1 Mon="0"_Mon
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","西药",stY_"-"_Mon)=0
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","中药",stY_"-"_Mon)=0
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","检验",stY_"-"_Mon)=0
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","检查",stY_"-"_Mon)=0
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","其他",stY_"-"_Mon)=0
	..s:(XAxisStr'="") XAxisStr=XAxisStr_","_Del_stY_"-"_Mon_Del
	..s:(XAxisStr="") XAxisStr=Del_stY_"-"_Mon_Del
	.for j=1:1:edM  d
	..s Mon=j
	..s:$l(Mon)=1 Mon="0"_Mon
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","西药",edY_"-"_Mon)=0
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","中药",edY_"-"_Mon)=0
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","检验",edY_"-"_Mon)=0
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","检查",edY_"-"_Mon)=0
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","其他",edY_"-"_Mon)=0
	..s:(XAxisStr'="") XAxisStr=XAxisStr_","_Del_edY_"-"_Mon_Del
	..s:(XAxisStr="") XAxisStr=Del_edY_"-"_Mon_Del

	
	f Date=startDate:1:endDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d  
    ..s year=$p($zd(Date,3),"-",1,2)
	..s ord=0
	..f  s ord=$o(^OEORD(0,"Adm",EpisodeID,ord)) q:ord=""  d
	...s itm=""
	...f  s itm=$o(^OEORD(ord,"I",itm)) q:itm=""  d
	....q:+itm=0
	....q:$p($g(^OEORD(ord,"I",itm,1)),"^",2)=""
	....s orcatDesc=##class(web.DHCEMOrdInfoVO).getOrcatDesc(ord,itm)
	....i orcatDesc="西药" d
	.....s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","西药",year)=^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","西药",year)+1
	....e  i orcatDesc="中药" d
	.....s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","中药",year)=^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","中药",year)+1
	....e  i orcatDesc="检验" d
	.....s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","检验",year)=^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","检验",year)+1
	....e  i orcatDesc="检查" d
	.....s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","检查",year)=^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","检查",year)+1
	....e  d
	.....s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","其他",year)=^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat","其他",year)+1
	....
	
    s XStr="",ZStr="",YStr="",CStr="",OStr=""
	s Count=0
	s index =""
	f  s index = $o(^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat",index)) q:index=""  d
	.s YearM=""
	.f  s YearM = $o(^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat",index,YearM)) q:YearM=""  d
	..s Data = $g(^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat",index,YearM))
	..i index="西药" d
	...s:XStr'="" XStr=XStr_","_Data
	...s:XStr="" XStr=Data
	..e  i index="中药" d
	...s:ZStr'="" ZStr=ZStr_","_Data
	...s:ZStr="" ZStr=Data
	..e  i index="检验" d
	...s:YStr'="" YStr=YStr_","_Data
	...s:YStr="" YStr=Data
	..e  i index="检查" d
	...s:CStr'="" CStr=CStr_","_Data
	...s:CStr="" CStr=Data
	..e  d
	...s:OStr'="" OStr=OStr_","_Data
	...s:OStr="" OStr=Data
	K ^TMP("DHCEM","web.DHCEMDocMessageInterface","ordCat")
	Q "["_XStr_"]^["_ZStr_"]^["_YStr_"]^["_CStr_"]^["_OStr_"]^["_XAxisStr_"]"
}

/// d ##class(web.DHCEMDocMessageInterface).MioDrug()
ClassMethod MioDrug()
{
	s ret="",Del=""""
	/// d ##class(%ResultSet).RunQuery("web.DHCEMLevelNum","EmPatMioInfData","2023-05-06","2023-05-06","2","MIOINFPATDRUG")
	Set result=##class(%Library.ResultSet).%New("web.DHCEMPatCheckLevStatis:EmPatMioInfData")
 	Set sc=result.Execute($zd((+$h),3),$zd((+$h),3),2)
 	;If $$$ISERR(sc) Quit ""
 	s count=0
 	While(result.Next())
	{ 	
		continue:count>1
		s ret=result.%GetData(16)
		s count=count+1
	}
	s:ret="" ret="0"
 	w Del_ret_Del
}

/// d ##class(web.DHCEMDocMessageInterface).MioBall()
ClassMethod MioBall()
{
 	s ret="",Del=""""
	//d ##class(%ResultSet).RunQuery("web.DHCEMLevelNum","EmPatMioInfData","2022-04-01","2022-06-29","2")
	Set result=##class(%Library.ResultSet).%New("web.DHCEMLevelNum:EmPatMioInfData")
 	Set sc=result.Execute($zd((+$h),3),$zd((+$h),3),2)
 	;If $$$ISERR(sc) Quit ""
 	s count=0
 	While(result.Next())
	{ 	
		continue:count>1
		s ret=result.%GetData(16)
		s count=count+1
	}
	s:ret="" ret="0"
 	w Del_ret_Del
}

/// d ##class(web.DHCEMDocMessageInterface).PatTypeNum()
ClassMethod medTime()
{
 	s ret="",Del=""""
	//d ##class(%ResultSet).RunQuery("web.DHCEMAvgObservationTime","medTimeQuery","2021-07-18","2022-07-18","2","2")
	Set result=##class(%Library.ResultSet).%New("web.DHCEMAvgObservationTime:medTimeQuery")
 	Set sc=result.Execute($zd((+$h-3),3),$zd((+$h),3),2,2)
 	;If $$$ISERR(sc) Quit ""
 	
 	While(result.Next())
	{ 
		s ret=result.%GetData(1)
	}
	s:ret="" ret="0小时0分"
 	w Del_ret_Del
}

/// d ##class(web.DHCEMDocMessageInterface).PatTypeNum()
ClassMethod PatTypeNum()
{
	//d ##class(%ResultSet).RunQuery("web.DHCEMPatTypeNum","admNumQuery","2022-05-10","2022-08-10",2)
	Set result=##class(%Library.ResultSet).%New("web.DHCEMPatTypeNum:admNumQuery")
 	;Set sc=result.Execute("2022-05-10","2022-08-10",2)
 	Set sc=result.Execute($zd((+$h),3),$zd((+$h),3),2)
 	;If $$$ISERR(sc) Quit "[]"
	
	w "["
    Set count = 0
	While(result.Next())
	{ 
		Set count = count+1
		If count=1 Write ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value",result.%GetData(1)_"^"_result.%GetData(2))
		Else  Write ","_##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value",result.%GetData(1)_"^"_result.%GetData(2))
	 }
	 
	/*i count=0 d
	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","小孩^11")
 	.w ","
 	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","孕妇^2")
 	.w ","
 	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","老人^17")
 	.w ","
 	.W ##class(web.DHCAPPJsonCommon).getJsonDataEcharts("name^value","残疾人^1")
 	*/
 	w "]"
}

/// w ##class(web.DHCEMDocMessageInterface).ObsData()
ClassMethod ObsData()
{
	s endDate=+$h
	s startDate=endDate-300
	s stY=$p($zd(startDate,3),"-",1)
	s stM=$p($zd(startDate,3),"-",2)
	s edY=$p($zd(endDate,3),"-",1)
	s edM=$p($zd(endDate,3),"-",2)
	K ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData")
	
	i stY=edY d
	.for i=stM:1:edM  d
	..s Mon=i
	..s:$l(Mon)=1 Mon="0"_Mon
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData",stY_"-"_Mon)=0
	
	i stY'=edY d
	.for i=stM:1:12  d
	..s Mon=i
	..s:$l(Mon)=1 Mon="0"_Mon
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData",stY_"-"_Mon)=0
	.for j=1:1:edM  d
	..s Mon=j
	..s:$l(Mon)=1 Mon="0"_Mon
	..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData",edY_"-"_Mon)=0
	
	f Date=startDate:1:endDate  d 
	.s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("NNType","E",Date,EpisodeID)) q:EpisodeID=""  d  
    ..q:##class(web.DHCEMPatChange).GetStayStatus(EpisodeID)=-1
    ..s year=$p($zd(Date,3),"-",1,2)
    ..s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData",year)=^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData",year)+1
    .
    
#;    s:^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-03")=0 ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-03")=330
#;    s:^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-04")=0 ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-04")=217
#;    s:^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-05")=0 ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-05")=199
#;    s:^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-06")=0 ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-06")=219
#;    s:^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-07")=0 ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-07")=321
#;    s:^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-08")=0 ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-08")=201
#;    s:^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-09")=0 ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-09")=161
#;    s:^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-10")=0 ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-10")=220
#;    s:^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-11")=0 ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-11")=287
#;    s:^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-12")=0 ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-12")=391
    /*s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-03")=220
    s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-04")=217
    s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-05")=199
    s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-06")=219
    s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-07")=200
    s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-08")=201
    s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-09")=161
    s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-10")=210
    s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-11")=207
    s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2022-12")=191
    s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2023-01")=200
    s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2023-02")=198
    s ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData","2023-03")=199
*/

	s Obs="",ObsData="",Del=""""
	s Count=0
	s index =""
	f  s index = $o(^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData",index)) q:index=""  d
	.s Data = $g(^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData",index)) 
	.s:Obs'="" Obs=Obs_","_Del_index_Del
	.s:Obs="" Obs=Del_index_Del
	.s:ObsData'="" ObsData=ObsData_","_Data
	.s:ObsData="" ObsData=Data
	K ^TMP("DHCEM","web.DHCEMDocMessageInterface","ObsData")
	Q "["_Obs_"]^"_"["_ObsData_"]"
}

/// w ##class(web.DHCEMDocMessageInterface).WorkLoad("^50^^^STAY")
ClassMethod WorkLoad(Params)
{
	s LocID =$p(Params,"^",2)
	s StaType =$p(Params,"^",5)
 	s WARDId =""
 	s:LocID'="" WARDId=$o(^PAWARD(0,"WARD_LocationDR",LocID,""),-1) // 科室id 50 改完 LocID

	s today=+$h
	s todayweek=$zd(today,10)
	s startDate=today-(todayweek-1)
	s endDate=today+(7-todayweek)

 	s week1=0,week2=0,week3=0,week4=0,week5=0,week6=0,week7=0
 	f stDate=startDate:1:endDate  d 
  	.s stTime=""
 	.f  s stTime=$o(^PAADMi("TransDateTime",stDate,stTime))   Q:stTime=""  D
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("TransDateTime",stDate,stTime,EpisodeID))   Q:EpisodeID=""  D    //按照就诊改变状态插入记录
 	...q:$p(^PAADM(EpisodeID),"^",2)'="E"
 	...q:($p(^PAADM(EpisodeID),"^",20)'="A")&($p(^PAADM(EpisodeID),"^",20)'="D")
	...s AdmLoc=$P($g(^PAADM(EpisodeID)),"^",4)
 	...s PatWarDr=$p(^PAADM(EpisodeID),"^",70)            //用来判断病人是否留观
	...Q:(StaType'="")&&((WARDId'=PatWarDr)||(WARDId=""))
 	...Q:(StaType="")&&(AdmLoc'=LocID)
 	...s weekdr=$zd(stDate,10)
 	...s:(weekdr=1) week1=week1+1
 	...s:(weekdr=2) week2=week2+1
 	...s:(weekdr=3) week3=week3+1
 	...s:(weekdr=4) week4=week4+1
 	...s:(weekdr=5) week5=week5+1
 	...s:(weekdr=6) week6=week6+1
 	...s:(weekdr=7) week7=week7+1

	/*s:(week1=0)&&(todayweek>=1) week1=120
	s:(week2=0)&&(todayweek>=2) week2=200
	s:(week3=0)&&(todayweek>=3) week3=150
	s:(week4=0)&&(todayweek>=4) week4=180
	s:(week5=0)&&(todayweek>=5) week5=168
	s:(week6=0)&&(todayweek>=6) week6=110
	s:(week7=0)&&(todayweek>=7) week7=130*/
 	w "["
 	w week1_","_week2_","_week3_","_week4_","_week5_","_week6_","_week7 	
 	w "]"
	Q ""
}

/// 急诊医生工作站 主屏统计
/// 今日接诊情况
/// w ##class(web.DHCEMDocMessageInterface).WorkLoadToDay("18849^39^104^2")
ClassMethod WorkLoadToDay(LgParam)
{
	
	s UserID=$p(LgParam,"^",1)
	s LocID=$p(LgParam,"^",2)
	s HospID=$p(LgParam,"^",4)
	s DocID=""
	s:UserID'="" DocID=$p($g(^SSU("SSUSR",UserID)),"^",14) 	 /// 医生ID 
	s startDate=+$h
	s endDate=+$h
	s EmPatLevWait=0,EmPatLevUnWait=0,AllPat=0
 	f stDate=startDate:1:endDate  d 
  	.s stTime=""
 	.f  s stTime=$o(^PAADMi("AdmTypeCurrLoc","E",LocID,stDate,stTime))   Q:stTime=""  D
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("AdmTypeCurrLoc","E",LocID,stDate,stTime,EpisodeID))   Q:EpisodeID=""  D    //按照就诊改变状态插入记录
 	...q:($p(^PAADM(EpisodeID),"^",20)'="A")&($p(^PAADM(EpisodeID),"^",20)'="D")
  	...s PatLocID=$p(^PAADM(EpisodeID),"^",4) 
    ...s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	...q:(HospID'="")&&(CurHospID'=HospID)
 	...s QueDocId=""
	...s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))   			///QueRowId
	...s QueObj=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	...s:QueObj'="" QueDocId=QueObj.QueDocDrGetObjectId()
 	...q:(DocID'="")&&(QueDocId'="")&&(DocID'=QueDocId)
 	...s WARDId =""
 	...s WARDId=$o(^PAWARD(0,"WARD_LocationDR",50,""),-1) // 科室id 50
 	...s PatWarDr=$p(^PAADM(EpisodeID),"^",70)            //用来判断病人是否留观
 	...q:(PatWarDr'="")
 	...s IsWaitPat=0
 	...s WalkStatus=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(EpisodeID)       /// 当前状态
	...i WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	...i WalkStatus="" s WalkStatus="等候"
	...s IsWaitPat = ((WalkStatus="等候")||(WalkStatus["复诊"))
	...s:IsWaitPat=0 EmPatLevUnWait=EmPatLevUnWait+1  ;已诊
	...s:IsWaitPat=1 EmPatLevWait=EmPatLevWait+1  ; 未诊
	...s AllPat=AllPat+1
 	w "["
 	w EmPatLevUnWait_","_EmPatLevWait_","_AllPat	
 	w "]"
	Q ""
}

/// 本周接诊人数
/// w ##class(web.DHCEMDocMessageInterface).WorkLoadWeek("18849^39^104^2")
ClassMethod WorkLoadWeek(LgParam)
{
	
	s UserID=$p(LgParam,"^",1)
	s LocID=$p(LgParam,"^",2)
	s HospID=$p(LgParam,"^",4)
	s DocID=""
	s:UserID'="" DocID=$p($g(^SSU("SSUSR",UserID)),"^",14) 	 /// 医生ID 
	s today=+$h
	s todayweek=$zd(today,10)
	s startDate=today-(todayweek-1)
	s endDate=today+(7-todayweek)
 	s Mon=0,Tue=0,Wed=0,Thur=0,Fri=0,Sat=0,Sun=0
	s EmPatLevWait=0,EmPatLevUnWait=0,AllPat=0
 	f stDate=startDate:1:endDate  d 
  	.s stTime=""
 	.f  s stTime=$o(^PAADMi("AdmTypeCurrLoc","E",LocID,stDate,stTime))   Q:stTime=""  D
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("AdmTypeCurrLoc","E",LocID,stDate,stTime,EpisodeID))   Q:EpisodeID=""  D    //按照就诊改变状态插入记录
 	...q:($p(^PAADM(EpisodeID),"^",20)'="A")&($p(^PAADM(EpisodeID),"^",20)'="D")
  	...s PatLocID=$p(^PAADM(EpisodeID),"^",4) 
    ...s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	...q:(HospID'="")&&(CurHospID'=HospID)
 	...s QueDocId=""
	...s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))   			///QueRowId
	...s QueObj=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	...s:QueObj'="" QueDocId=QueObj.QueDocDrGetObjectId()
 	...q:(DocID'="")&&(QueDocId'="")&&(DocID'=QueDocId)
 	...s WARDId =""
 	...s WARDId=$o(^PAWARD(0,"WARD_LocationDR",50,""),-1) // 科室id 50
 	...s PatWarDr=$p(^PAADM(EpisodeID),"^",70)            //用来判断病人是否留观
 	...q:(PatWarDr'="")
 	...s IsWaitPat=0 ; 0 已诊 1 未诊-等候就诊
 	...s WalkStatus=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(EpisodeID)       /// 当前状态
	...i WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	...i WalkStatus="" s WalkStatus="等候"
	...s IsWaitPat = ((WalkStatus="等候")||(WalkStatus["复诊"))
	...q:IsWaitPat=1 ; 未诊退出
	...s weekdr=$zd(stDate,10)
 	...s:(weekdr=1) Mon=Mon+1
 	...s:(weekdr=2) Tue=Tue+1
 	...s:(weekdr=3) Wed=Wed+1
 	...s:(weekdr=4) Thur=Thur+1
 	...s:(weekdr=5) Fri=Fri+1
 	...s:(weekdr=6) Sat=Sat+1
 	...s:(weekdr=7) Sun=Sun+1

	w "["
 	w Mon_","_Tue_","_Wed_","_Thur_","_Fri_","_Sat_","_Sun 	
 	w "]"
	Q ""
}

/// 本月接诊人数
/// w ##class(web.DHCEMDocMessageInterface).WorkLoadMoon("18849^39^104^2")
ClassMethod WorkLoadMoon(LgParam)
{
	
	s UserID=$p(LgParam,"^",1)
	s LocID=$p(LgParam,"^",2)
	s HospID=$p(LgParam,"^",4)
	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
	k ^TMP("DHCEM","web.DHCEMDocMessageInterface","WorkLoadMoon",pid)
	s DocID=""
	s:UserID'="" DocID=$p($g(^SSU("SSUSR",UserID)),"^",14) 	 /// 医生ID 
	s today=+$h
	s toyear=$p($zd(today,3),"-",1)
	s tomoon=$p($zd(today,3),"-",2)
	s startDate=toyear_"-"_tomoon_"-"_"01"
	s endDate=$SYSTEM.SQL.LASTDAY(startDate)
	s startDate=$zdh(startDate,3)
	
	s h=0
 	f stDate=startDate:1:endDate  d 
	.s ^TMP("DHCEM","web.DHCEMDocMessageInterface","WorkLoadMoon",pid,stDate)=0
  	.s stTime=""
 	.f  s stTime=$o(^PAADMi("AdmTypeCurrLoc","E",LocID,stDate,stTime))   Q:stTime=""  D
 	..s EpisodeID=""
 	..f  s EpisodeID=$o(^PAADMi("AdmTypeCurrLoc","E",LocID,stDate,stTime,EpisodeID))   Q:EpisodeID=""  D    //按照就诊改变状态插入记录
 	...q:($p(^PAADM(EpisodeID),"^",20)'="A")&($p(^PAADM(EpisodeID),"^",20)'="D")
  	...s PatLocID=$p(^PAADM(EpisodeID),"^",4) 
    ...s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	...q:(HospID'="")&&(CurHospID'=HospID)
 	...s QueDocId=""
	...s QueRowId=$O(^User.DHCQueueI("QuePaadmDrIndex",EpisodeID,""))   			///QueRowId
	...s QueObj=##Class(User.DHCQueue).%OpenId(QueRowId,0)
	...s:QueObj'="" QueDocId=QueObj.QueDocDrGetObjectId()
 	...q:(DocID'="")&&(QueDocId'="")&&(DocID'=QueDocId)
 	...s WARDId =""
 	...s WARDId=$o(^PAWARD(0,"WARD_LocationDR",50,""),-1) // 科室id 50
 	...s PatWarDr=$p(^PAADM(EpisodeID),"^",70)            //用来判断病人是否留观
 	...q:(PatWarDr'="")
 	...s IsWaitPat=0 ; 0 已诊 1 未诊-等候就诊
 	...s WalkStatus=##Class(web.DHCEMDocMainOutPat).GetPatCurStat(EpisodeID)       /// 当前状态
	...i WalkStatus'="" Set WalkStatus=$P(WalkStatus,"^",2)
	...i WalkStatus="" s WalkStatus="等候"
	...s IsWaitPat = ((WalkStatus="等候")||(WalkStatus["复诊"))
	...q:IsWaitPat=1
	...s h=h+1
	...i $d(^TMP("DHCEM","web.DHCEMDocMessageInterface","WorkLoadMoon",pid,stDate))  d
	....S ^TMP("DHCEM","web.DHCEMDocMessageInterface","WorkLoadMoon",pid,stDate)=$p(^TMP("DHCEM","web.DHCEMDocMessageInterface","WorkLoadMoon",pid,stDate),"^",1)+1
	...E  d
	....S ^TMP("DHCEM","web.DHCEMDocMessageInterface","WorkLoadMoon",pid,stDate)=1
	
	i h=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(h) //输出json结尾符
	q:h=0 ""
	
	
	s name="",value="",Del=""""
	s Count=0
	s index =""
	f  s index = $o(^TMP("DHCEM","web.DHCEMDocMessageInterface","WorkLoadMoon",pid,index)) q:index=""  d
	.s num = $g(^TMP("DHCEM","web.DHCEMDocMessageInterface","WorkLoadMoon",pid,index)) 
	.s date=$p($zd(index,3),"-",3)
	.s:name'="" name=name_","_Del_date_Del
	.s:name="" name=Del_date_Del
	.s:value'="" value=value_","_num
	.s:value="" value=num
	K ^TMP("DHCEM","web.DHCEMDocMessageInterface","WorkLoadMoon",pid)	
	w "{"
	w Del_"name"_Del_":"_"["_name_"]"
	w ","
	w Del_"value"_Del_":"_"["_value_"]"
	w "}"
	Q ""
}

/// 当日就诊患者分级比例
/// w ##class(web.DHCEMDocMessageInterface).PatLevelNum("18849^39^104^2")
ClassMethod PatLevelNum(LgParam)
{
	s HospID=$p(LgParam,"^",4)

	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
	k ^TMP("DHCEM","web.DHCEMDocMessageInterface","PatLevelNum",pid)
	s ^TMP("DHCEM","web.DHCEMDocMessageInterface","PatLevelNum",pid,"Ⅰ")="Ⅰ级"_"^"_"0"
	s ^TMP("DHCEM","web.DHCEMDocMessageInterface","PatLevelNum",pid,"Ⅱ")="Ⅱ级"_"^"_"0"
	s ^TMP("DHCEM","web.DHCEMDocMessageInterface","PatLevelNum",pid,"Ⅲ")="Ⅲ级"_"^"_"0"
	s ^TMP("DHCEM","web.DHCEMDocMessageInterface","PatLevelNum",pid,"Ⅳa")="Ⅳa级"_"^"_"0"
	s ^TMP("DHCEM","web.DHCEMDocMessageInterface","PatLevelNum",pid,"Ⅳb")="Ⅳb级"_"^"_"0"

	//d ##class(%ResultSet).RunQuery("web.DHCEMLevelNum","admNumQuery","","",2)
	Set result=##class(%Library.ResultSet).%New("web.DHCEMLevelNum:admNumQuery")
 	;Set sc=result.Execute("2022-05-10","2022-08-10",2)
 	Set sc=result.Execute($zd((+$h),3),$zd((+$h),3),HospID,1) /// 1 查询已就诊分诊数据数据
 	;If $$$ISERR(sc) Quit "[]"
	
	w "["
	While(result.Next())
	{ 
		s name=result.%GetData(1)
		s value=result.%GetData(2)
		I $d(^TMP("DHCEM","web.DHCEMDocMessageInterface","PatLevelNum",pid,name))  d
		.s $p(^TMP("DHCEM","web.DHCEMDocMessageInterface","PatLevelNum",pid,name),"^",2)=value
	}
	///转换数据为Json格式
	S Title="name^value"
	s index="",count=0
	f  s index=$o(^TMP("DHCEM","web.DHCEMDocMessageInterface","PatLevelNum",pid,index)) q:index=""  d
	.s name=$p($g(^TMP("DHCEM","web.DHCEMDocMessageInterface","PatLevelNum",pid,index)),"^",1)
	.s num=$p($g(^TMP("DHCEM","web.DHCEMDocMessageInterface","PatLevelNum",pid,index)),"^",2)
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(Title,name_"^"_num)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(Title,name_"^"_num)
	k ^TMP("DHCEM","web.DHCEMDocMessageInterface","PatLevelNum",pid)
	w "]"
	q ""
}

/// 当日就诊患者去向比例
/// d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryVisitStatus","2017-08-01","2017-08-02")
/// w ##class(web.DHCEMDocMessageInterface).PatVisitStatusNum("18849^39^104^2")
ClassMethod PatVisitStatusNum(LgParam)
{
	
	s UserID=$p(LgParam,"^",1)
	s LocID=$p(LgParam,"^",2)
	s GroupID=$p(LgParam,"^",3)
	s HospID=$p(LgParam,"^",4)
	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
	k ^TMP("DHCEM","web.DHCEMDocMessageInterface","PatVisitStatusNum",pid)
	s ID=""
	f  s ID=$o(^DHCPACVisitStatus(ID)) q:ID=""  d
	.s Code=$p(^DHCPACVisitStatus(ID),"^",1)
	.s Desc=$p(^DHCPACVisitStatus(ID),"^",2)
	.s PACRowID=""
	.s IsHasQx=0
	.f  s PACRowID=$o(^DHCEMPSA(0,"IndexStatus",ID,PACRowID)) q:(PACRowID="")||(IsHasQx=1)  d
	..s Type=$p(^DHCEMPSA(PACRowID),"^",2)
	..s Point=$p(^DHCEMPSA(PACRowID),"^",3)
	..s HospDr=$p(^DHCEMPSA(PACRowID),"^",4) //hxy 2020-06-02 st
	..s RealHospDr=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmPatStatusAcc",HospID)
	..q:HospDr'=RealHospDr //ed
	..q:(Type="G")&&(GroupID'=Point)
	..q:(Type="U")&&(UserID'=Point)
	..s IsHasQx=1
	.q:IsHasQx'=1
	.s Desc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCPACVisitStatus","PVSDesc","",Desc) //hxy 2023-01-31
	.s ^TMP("DHCEM","web.DHCEMDocMessageInterface","PatVisitStatusNum",pid,Desc)=Desc_"^"_"0"

	//d ##class(%ResultSet).RunQuery("web.DHCEMPatCheckLevStat","QueryVisitStatus","2022-05-10","2022-08-10",2)
	Set result=##class(%Library.ResultSet).%New("web.DHCEMPatCheckLevStat:QueryVisitStatus")
 	;Set sc=result.Execute("2022-05-10","2022-08-10",2)
 	Set sc=result.Execute($zd((+$h),3),$zd((+$h),3),HospID)
 	;If $$$ISERR(sc) Quit "[]"
	
	w "["
	While(result.Next())
	{ 
		s name=result.%GetData(1)
		s value=result.%GetData(2)
		I $d(^TMP("DHCEM","web.DHCEMDocMessageInterface","PatVisitStatusNum",pid,name))  d
		.s $p(^TMP("DHCEM","web.DHCEMDocMessageInterface","PatVisitStatusNum",pid,name),"^",2)=value
	}
	b ;c1
	///转换数据为Json格式
	S Title="name^value"
	s index="",count=0
	f  s index=$o(^TMP("DHCEM","web.DHCEMDocMessageInterface","PatVisitStatusNum",pid,index)) q:index=""  d
	.s name=$p($g(^TMP("DHCEM","web.DHCEMDocMessageInterface","PatVisitStatusNum",pid,index)),"^",1)
	.s num=$p($g(^TMP("DHCEM","web.DHCEMDocMessageInterface","PatVisitStatusNum",pid,index)),"^",2)
	.s count = count+1
	.I count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(Title,name_"^"_num)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(Title,name_"^"_num)
	k ^TMP("DHCEM","web.DHCEMDocMessageInterface","PatVisitStatusNum",pid)
	w "]"
	q ""
}

/// 医生今日最后一批交接班
/// w ##class(web.DHCEMDocMessageInterface).getLastShift("^^^2")
ClassMethod getLastShift(LgParam)
{
	s LgUserID=$p(LgParam,"^",1)
	s LgHospID=$p(LgParam,"^",4)
	w "["
	s BsDr="",Ward="",count=0
	s BsID=""
	F  s BsID=$o(^DHCEMBSS(0,"CreateDate",+$h,BsID),-1) Q:(BsID="")!(BsDr'="")  D
	.q:$p(^DHCEMBSS(BsID),"^",4)'="Doc"
	.q:$p(^DHCEMBSS(BsID),"^",10)'="Y"
	.s WardID=$p(^DHCEMBSS(BsID),"^",2)    /// 交班病区
	.s CurLocID=$p($g(^PAWARD(+WardID)),"^",5)
	.s CurHospID=$p($g(^CTLOC(+CurLocID)),"^",22)
	.q:(LgHospID'="")&&(CurHospID'=LgHospID)
	.s Ward=$p($g(^PAWARD(WardID)),"^",2)
	.s UserID=$p(^DHCEMBSS(BsID),"^",5)    /// 交班人员
	.s AccUserID=$p(^DHCEMBSS(BsID),"^",9) /// 接班人
	.q:(LgUserID'="")&&(UserID'=LgUserID)&&(AccUserID'=LgUserID)
	.s BsDr=BsID
	q:BsDr="" "]"
	s Title="Bed^PatName^PatDesc"
	
	/// 交班本病人
    s CH=0
	F  s CH=$O(^DHCEMBSS(BsDr,"I",CH)) Q:CH=""  D
	.s EpisodeID=$P(^DHCEMBSS(BsDr,"I",CH),"^",1)  /// 就诊ID
	.s PatientID=$P(^PAADM(EpisodeID),"^",1)       /// 病人ID
	.s mradm=$P(^PAADM(EpisodeID),"^",61) 
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)   /// 姓名
	.s BedId=$P($g(^PAADM(EpisodeID)),"^",73)
	.i BedId'="" s PatBed=Ward_"["_$P($g(^PAWARD(+BedId,"BED",$P(BedId,"||",2))),"^",1)_"]"  /// 床号
	.e  s PatBed=""
	.s BsPatDiag=$P(^DHCEMBSS(BsDr,"I",CH),"^",3)   /// 诊断
	.s BsContents=$P(^DHCEMBSS(BsDr,"I",CH),"^",5)  /// 交班内容
	.s count = count+1
	.i count=1 d
	..w ##class(web.DHCEMJsonCommon).getJsonData(Title,PatBed_"^"_PatName_"^"_BsContents)
	.e  d
	..w ","_##class(web.DHCEMJsonCommon).getJsonData(Title,PatBed_"^"_PatName_"^"_BsContents)
	w "]"
	q ""
}

Storage Default
{
<Data name="DHCEMDocMessageInterfaceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMDocMessageInterfaceD</DataLocation>
<DefaultData>DHCEMDocMessageInterfaceDefaultData</DefaultData>
<IdLocation>^web.DHCEMDocMessageInterfaceD</IdLocation>
<IndexLocation>^web.DHCEMDocMessageInterfaceI</IndexLocation>
<StreamLocation>^web.DHCEMDocMessageInterfaceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
