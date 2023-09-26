Import sqluser

Class web.DHCEMPatChange Extends (%RegisteredObject, %XML.Adaptor, ) [ Not ProcedureBlock ]
{

/// Description: 入院病区下拉列表
/// Input:  	 code：代码 
/// Return： 	 入院病区
/// w ##class(web.DHCEMPatChange).LookUpWardTojson("","","")	
ClassMethod LookUpWardTojson(code As %String, locType As %String = "W", search As %String) As %String
{
	n (code,locType,search)
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s count=1
	W "["
	
 	s sub=0 f  s sub=$o(^PAWARD(sub)) q:(+sub=0)  d
    .q:$p(^PAWARD(sub),"^",6)'="Y"
    .s desc=$p($g(^PAWARD(sub)),"^",2)
    .q:((desc'[code)&(code'=""))
    .q:(search'="")&&(desc'[search)
    .s locId=$p(^PAWARD(sub),"^",5)
    .q:locId=""
    .//q:$p($g(^CTLOC(locId)),"^",13)'="EM"
    .q:(locType'="")&(("^"_locType_"^")'[("^"_$p($g(^CTLOC(locId)),"^",13)_"^"))
    .s dateFrom=$P(^PAWARD(sub),"^",7)
 	.s dateTo=$P(^PAWARD(sub),"^",9)
 	.s h=+$h
 	.q:(((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'="")))
	
	.W $case(count,1:"",:",") 
	.w jsonObj.Put("id",sub).Put("text",desc).Json()
	.S count=count+1
	W "]"
	q ""
}

/// Descript: 标本列表
/// w ##class(web.DHCEMPatChange).LookUpCtlocTojson("NFM","W","2")
ClassMethod LookUpCtlocTojson(q As %String, admType As %String = "I", hospId As %String)
{
	
	n (q,admType,hospId,%session)

	Set result=##class(%Library.ResultSet).%New("web.DHCCLCom:LookUpWard")
	Set sc=result.Execute("",admType,hospId)  ///第一个参数是过滤，护理有问题，这里先自己写
	If $$$ISERR(sc) Quit ""
	s q = $$ALPHAUP^SSUTIL4(q)
	Set colNum=result.GetColumnCount() //列数
	Set count = 0
	Set del=""""
	Set tmp=""
	W "["
	While(result.Next())
	{ 
		Set ret="",wardAllDesc=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_"text"_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_"id"_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		s wardAllDesc = ..GetWardCodeByWardDr($P(result.%GetData(i),$C(13,10)))_"-"_$P(result.%GetData(1),$C(13,10))
		Continue:(q'="")&(wardAllDesc'[q)    ///自己先写过滤
		Set count = count+1
		If count=1 Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }
	 w "]"
	 Do result.Close()
	 Quit ""
}

/// Description: 入院科室下拉列表
/// Input:  	 code：代码 
/// Return： 	 入院科室
/// w ##class(web.DHCEMPatChange).LookUpCtlocTojson("I","","")
ClassMethod LookUpCtlocTojsonOld(admType As %String = "I", desc As %String, search As %String) As %Status
{
	n (admType,desc,search)
	s admType="I"
	i search'="" s search=$zcvt(search,"U")
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s count=1
	W "["
	
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s admlocId=0
	f  s admlocId=$o(^PAC("ADMLOC",admlocId)) q:admlocId=""  d
	.i admType'[$p(^PAC("ADMLOC",admlocId),"^") q  //jst
	.s ctlocId=$p(^PAC("ADMLOC",admlocId),"^",2)
	.q:'$D(^CTLOC(ctlocId))
	.s ctlocDesc=$$ALPHAUP^SSUTIL4($p(^CTLOC(ctlocId),"^",2))
	.s ctlocCode = $$ALPHAUP^SSUTIL4($p(^CTLOC(ctlocId),"^",43))
	.q:(search'="")&&((ctlocCode_ctlocDesc)'[search)
	.i (desc'="")&($p(ctlocDesc,desc,1)'="") q	
	
	.W $case(count,1:"",:",") 
	.w jsonObj.Put("id",ctlocId).Put("text",ctlocDesc).Json()
	.S count=count+1
	W "]"
	q ""
}

/// Description:获取就诊类型
/// w ##class(web.DHCEMPatChange).GetAdmType("8")
ClassMethod GetAdmType(admId = "") As %String
{
	i admId="" q ""
	q $p(^PAADM(admId),"^",2)
}

/// Description: 2017-09-06 liangqiang增加需关注判断
/// Input:就诊号
/// Return：是否有需关注医嘱：""(没有)，其他(有:描述)
/// w ##class(web.DHCEMPatChange).GetAbnormalOrder("3006","2^39^104^18849")
ClassMethod GetAbnormalOrder(EpisodeID As %String, LgParams = "") As %String
{
	
	s payMode=##class(web.DHCEMCommonUtil).IGetStayPayModeByAdmID(EpisodeID) 
	q:+payMode=0 "[]"     //现金模式不做需关注判断 qqa
	
	s lgUserId = $p(LgParams,"^",4)
	s provId = $p(^SSU("SSUSR",lgUserId),"^",14)
	s internalType=""
	i +provId'=0 {
		s prvTpId = $p(^CTPCP(provId,1),"^",4)
		s internalType = $p($g(^CT("CPT",+prvTpId)),"^",4)
	}
	//护士或者医生
	s internalType=$case(internalType,"DOCTOR":"DOCTOR","NURSE":"NURSE",:"NURSE")
	
	s abnormalOrders = ##class(%ListOfDataTypes).%New()
	//不仅医生使用,护士也会使用
	s transNeedCare=##class(Nur.HISUI.NeedCareOrder).getAbnormalOrder(EpisodeID,internalType,"D")  //1^会控制,0^只提示
	
	if (transNeedCare=""){
		s ret=##class(Nur.JSON).EncodeByWrite(abnormalOrders)
		q ret
	}
	if (transNeedCare.Count() >=1){
		s ifCanOper=0,ifOtherCanOper=0
		s abnormalMsgs = ##class(%ListOfDataTypes).%New() 
		s otherAbnormalMsgs = ##class(%ListOfDataTypes).%New() 
		for i=1:1:transNeedCare.Count() {
			s dataObj=transNeedCare.GetAt(i)
			s ifCare=dataObj.GetAt("ifCare")
			s abnormalMsg=dataObj.GetAt("abnormalMsg")
			continue:abnormalMsg=""
			s isOtherAbnormal=dataObj.GetAt("isOtherAbnormal")
			s msgObj = ##class(%ArrayOfDataTypes).%New()
			d msgObj.SetAt($case(ifCare,"Y":1,:0),"ifCanOper")
			d msgObj.SetAt(abnormalMsg,"abnormalMsg")
			if (isOtherAbnormal="Y"){
				if (ifCare = "Y") s ifOtherCanOper=1
				d otherAbnormalMsgs.Insert(msgObj)
			}else{
				if (ifCare = "Y") s ifCanOper=1
				d abnormalMsgs.Insert(msgObj)
			}
		}
		s abnormalOrder = ##class(%ArrayOfDataTypes).%New()
		s str=##class(websys.Translation).Get("Nur.NIS.Service.Base.Transfer","该患者有")
		s str2=##class(websys.Translation).Get("Nur.NIS.Service.Base.Transfer","医嘱需要处理")
		d abnormalOrder.SetAt(str,"prefixMsg")
		d abnormalOrder.SetAt(str2,"suffixMsg")
		d abnormalOrder.SetAt(ifCanOper,"ifCanOper")
		d abnormalOrder.SetAt(ifOtherCanOper,"ifOtherCanOper")
		d abnormalOrder.SetAt(abnormalMsgs,"abnormalMsgs")
		d abnormalOrder.SetAt(otherAbnormalMsgs,"otherAbnormalMsgs")
		d abnormalOrders.Insert(abnormalOrder)
	}
	s ret=##class(Nur.JSON).EncodeByWrite(abnormalOrders)
	q ret
	
	
	s:+abnormal=0 abnormal=""
	s:+abnormal'=0 abnormp=$p(abnormal,"1^",2)
	s:abnormal'="" abnormal = $tr(abnormal,"^",",")
    q abnormal
}

/// w ##class(web.DHCEMPatChange).SetPatChargeStatusNew(就诊ID,离院日期,离院时间,用户ID,"")
/// w ##class(web.DHCEMPatChange).SetPatChargeStatusNew(565,'23/11/2017','09:30:41',69,"")
ClassMethod SetPatChargeStatusNew(EpisodeID, StatusDate, StatusTime, userID, WardDesc, Notes = "")
{
	n (EpisodeID,StatusDate,StatusTime,userID,WardDesc,Notes)
	
	s AdmType= ##class(web.DHCEMPatChange).GetAdmType(EpisodeID)
	q:AdmType'="E" "就诊类型不是急诊！"
	
	s ADMVisitStatusDr= $o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	s PACVisitStatusDr=$p($g(^DHCADMVisitStatus(+ADMVisitStatusDr)),"^",2)
	s CuStatusDesc = $p($g(^DHCPACVisitStatus(+PACVisitStatusDr)),"^",2)
	
	s rtn=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)   //这里没有判断抢救
	
    q:(rtn'=1)&(rtn'=2)&(CuStatusDesc'["抢救") "病人非留观或曾经留观或抢救！"
   	s rtn = ##class(web.DHCEMPatChange).GetIfHaveNoPayOrder(EpisodeID)
   	q:rtn'=0 "有急诊留观账单未结算"
	s rtn =  ##class(web.DHCEMPatChange).VerifyDisDate(EpisodeID,StatusDate)   
	q:rtn'=0 "离院时间不能小于入留观时间"
	s rtn =  ##class(web.DHCEMPatChange).VerifyDisDate2(StatusDate,StatusTime)   
	q:rtn'=0 "离院时间不能大于当前时间"
		
   	ts
   	
   	s rs = ##class(web.DHCEMPatChange).InsertVis(EpisodeID,"Discharge",StatusDate, StatusTime, userID, WardDesc,Notes)
   	i rs'=0 tro 1
   	q:rs'=0 "记录离院时间错误！"
   	
   	s rs = ##class(web.DHCEMPatChange).PAAdmFinalDischarge(EpisodeID, userID)
   	i rs'=0 tro 1
   	q:rs'=0 "修改结算状态以及离院状态错误！"
   	
   	s rs = ##class(web.DHCEMPatChange).SetDisHospInfo(EpisodeID, StatusDate,StatusTime)
   	i rs'=0 tro 1
   	q:rs'=0 "修改PaAdmExt中离院时间和日期错误！"
   	
   	tc
   	
   	q 0
}

/// Descript:离院修改PaAdm中扩展表中离院日期和时间
/// 
ClassMethod SetDisHospInfo(EpisodeID, AvsDate, AvsTime)
{
	n (EpisodeID,AvsDate,AvsTime)
	q:+EpisodeID=0 -1
	s:AvsDate="" AvsDate=+$h
	s:AvsTime="" AvsTime=$p($h,",",2)
	s AvsDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(AvsDate)
   	s AvsTime=$ZTH(AvsTime)
   	&sql(UPDATE PA_AdmExt SET PAADM_DischargeDate=:AvsDate,PAADM_DischargeTime=:AvsTime WHERE PAADM_RowId=:EpisodeID)
   	q SQLCODE
}

/// 离院时间与留观开始时间判断
/// w ##class(web.DHCEMPatChange).VerifyDisDate("1973","2018-01-01")
ClassMethod VerifyDisDate(EpisodeID, StatusDate)
{
	n (EpisodeID,StatusDate)
	q:EpisodeID="" ""
	s ObsStDate="",ObsStTime=""
	s AdmTransSub=0 
	f  s AdmTransSub = $o(^PAADM(EpisodeID,"TRANS",AdmTransSub)) q:(AdmTransSub="")!(ObsStDate'="")  d
	.q:$p(^PAADM(EpisodeID,"TRANS",AdmTransSub),"^",8)=""
	.s ObsStDate=$p(^PAADM(EpisodeID,"TRANS",AdmTransSub),"^",1)
	.s ObsStTime = $p(^PAADM(EpisodeID,"TRANS",AdmTransSub),"^",2)
	q:ObsStDate="" 0       //没有取到留观时间默认通过
	s StatusDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StatusDate)
	q:StatusDate<ObsStDate 1
	q 0
}

ClassMethod VerifyDisDate2(StatusDate, StatusTime)
{
	n (StatusDate,StatusTime)
	s StatusDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StatusDate)	
	s:StatusTime'="" StatusTime=$zth(StatusTime,2)
	q:StatusDate>+$H -1
	q:(StatusDate=+$H)&&(StatusTime>$p($h,",",2)) -1
	q 0
}

/// 状态修改时间与就诊时间判断
/// w ##class(web.DHCEMPatChange).VerifyUpdDate("1973","01/01/2018")
ClassMethod VerifyUpdDate(EpisodeID, StatusDate)
{
	n (EpisodeID,StatusDate)
	q:EpisodeID="" "-1"
	s AdmDate = $p(^PAADM(EpisodeID),"^",6)
	s UpdStatDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StatusDate)
	b ;err
	q:AdmDate>UpdStatDate "-1"
	q 0
}

ClassMethod GetAbnormalConsultAlert(EpisodeID As %String) As %String
{
    q:EpisodeID="" ""
    q:$p(^PAADM(EpisodeID),"^",20)'="A" "当前不是在院病人!"
    ;s ret=##class(web.DHCEMPatChange).GetPatCurStat(EpisodeID)
    s patStatus = ##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)   ///qqa 2017-08-22 改为调用护理统一接口
    q:(patStatus'=1)&(patStatus'=2) "非留观病人!"
    ;q:(patStatus'=1)&(ret'["抢救死亡")&(ret'["来时死亡")&(ret'["抢救") "病人为非留观病人或抢救死亡或来时死亡！"
    s ret=..GetUndoConsult(EpisodeID)
    q:(ret="") 0
    s ret=$L(ret,"^")
    q:(ret=0) ret
    q:(ret'=0) "有"_ret_"条会诊未执行!"
}

ClassMethod GetUndoConsult(Adm As %String) As %String
{
    q:(Adm="") ""
    s ret=""
    s consultid=""
    f {
        s consultid=$O(^User.DHCConsultationI("Adm"," "_Adm,consultid))
        q:consultid=""
        s consultObj=##class(User.DHCConsultation).%OpenId(consultid,0)
        s status=consultObj.Status
        i (status'="E")&&(status'="C")&&(status'="R")
        {
            i ret="" s ret=consultid
            e  s ret=ret_"^"_consultid
        }
    }
    q ret
}

/// Description:病人当前状态,最后一次的
/// input: 就诊ID
/// output: 状态信息
/// w ##class(web.DHCEMPatChange).GetPatCurStat("51")
ClassMethod GetPatCurStat(EpisodeID = "") As %String
{
	i EpisodeID="" q ""
	s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	q:avsId="" ""
	s pvsId=$P(^DHCADMVisitStatus(avsId),"^",2)
   	q $P(^DHCPACVisitStatus(pvsId),"^",1,2)
}

/// 判断有无结算的急诊留观账单
/// w ##class(web.DHCEMPatChange).GetIfHaveNoPayOrder("243")
ClassMethod GetIfHaveNoPayOrder(Adm)
{
	n (Adm)
	q 0  //不考虑未结算的情况   liangqiang  2016-09-08
	s papmiId=+^PAADM(Adm)
	s EpisodeID=""
	s ret=0
	f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","E",EpisodeID),-1) q:((EpisodeID="")!(ret=1))  d  
    .s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    .q:EpisodeID=Adm
    .;q:(pavisit'="A")
    .s rtn=##class(web.DHCADMVisitStat).GetStayStatus(EpisodeID)
    .
    .q:(rtn'=1)&(rtn'=2)
    .s JFRet=##class(web.UDHCJFBaseCommon).JudgeBillNum(EpisodeID)
    .s:JFRet>0 ret=1
    q ret
}

ClassMethod GetStayStatus(Adm) As %String
{
	//w ##class(web.DHCEMPatChange).GetStayStatus(467136)
	
	n (Adm)
	q ##class(web.DHCADMVisitStat).GetStayStatus(Adm)
	
	s ii=0
    s rtn=-1
    q:(Adm="") rtn
   
    s Admtype=$p($g(^PAADM(Adm)),"^",2)
    q:(Admtype'="E" ) rtn
    s AdmRea=$p($g(^PAADM(Adm,1)),"^",7)
    q:$g(AdmRea)="" rtn		//PAC_AdmReason收费类型
    b //1
    s InsurFlag=+$p($g(^PAC("ADMREA",+AdmRea)),"^",9)
	s BedCodeDr=$p($g(^PAADM(Adm)),"^",73)
	q:(BedCodeDr="")!(BedCodeDr=0) rtn	//	无床位
	
    s PatAllStatusCode=""
    s PatCurStatusDr=""
	f  s PatCurStatusDr=$o(^DHCADMVisitStatus(0,"PAADM",Adm,PatCurStatusDr)) q:(PatCurStatusDr="")  d
	.s PatCurStatusCTid=$p($g(^DHCADMVisitStatus(PatCurStatusDr)),"^",2)
	.q:PatCurStatusCTid=""
	.s PatCurStatusCode=$p($g(^DHCPACVisitStatus(PatCurStatusCTid)),"^",1)
	.s PatCurStatusCode=$zcvt(PatCurStatusCode,"U")
	.s ii=ii+1
	.i PatAllStatusCode="" d
	..s PatAllStatusCode=PatCurStatusCode
	.e  d
	..s PatAllStatusCode=PatAllStatusCode_"^"_PatCurStatusCode
	b //4
	q:((PatAllStatusCode'["STAY")) rtn  //状态变更中不包含留观或抢救
	
	i (($p(PatAllStatusCode,"^",ii)="STAY")) s rtn=1   //留观状态,当前为留观或抢救
	e  s rtn=2 //曾经留观	
	q rtn
}

/// Description:更改病人状态保存
/// Input:  EpisodeID:就诊id;visStatCode:病人状态代码;avsDateStr:当前日期;
/// w ##class(web.DHCEMPatChange).InsertVis("17","Discharge","03/01/2019","9:18","4636","")
ClassMethod InsertVis(EpisodeID, visStatCode, avsDateStr, avsTimeStr, userId, wardDesc, notes = "", isTakStayFlag = "") As %String
{
   	n (EpisodeID,visStatCode,avsDateStr,avsTimeStr,userId,wardDesc,notes, isTakStayFlag)
   	
   	s curStat=$P(..GetPatCurStat(EpisodeID),"^")
	q:visStatCode=curStat "所置状态与病人当前状态相同！" ;
   	i ((visStatCode="Stay")!(visStatCode="Salvage")!(visStatCode="SalDeath")!(visStatCode="Death")) d
    .s ifHaveNoPay=##class(web.DHCBillInterface).GetnotPayOrderByRegno("",EpisodeID)
    e  s ifHaveNoPay=0
    i (curStat="Stay")!(curStat="Salvage")!(curStat="SalDeath")!(curStat="Death") s ifHaveNoPay=0
    s IsObs = ##Class(web.DHCEMVisitStat).IsObsIng(EpisodeID)
	i ($g(ifHaveNoPay)>1)&(isTakStayFlag=0)&(IsObs'=1) q "本次就诊有未结算的医嘱，如果留观需停医嘱或者交费" /// 注释 留观时，未结算医嘱设置留观标志，此处不再做此判断 bianshuai 2020-10-29 
	
   	s avsDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(avsDateStr)
   	s avsTime=$ZTH(avsTimeStr)
   	s wardId=""
   	i wardDesc'="" s wardId=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(wardDesc),""))
    ;q ..InsertVisitStat(EpisodeID, visStatCode, avsDate, avsTime, userId, wardId)
    s ret="" //wxl 081201 Start
    s visStatId=$o(^DHCPACVisitStatus(0,"Code",$$ALPHAUP^SSUTIL4(visStatCode),""))	//状态id
   	s PreVisitStatId=""
   	s PreVisitStatId=$p($G(^DHCPACVisitStatus(visStatId)),"^",9)
    i PreVisitStatId="" s ret=0
    e  d
    .s avsrowId=""	//DHCADMVisitStatus表的id
    .f  s avsrowId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsrowId),-1) q:avsrowId=""  d
    ..s avsVisStatCode=$p($G(^DHCADMVisitStatus(avsrowId)),"^",2)	
    ..i avsVisStatCode=PreVisitStatId s ret=0
    ;i ($$ALPHAUP^SSUTIL4(visStatCode)="INHOSPITAL")||($$ALPHAUP^SSUTIL4(visStatCode)="DISPLACE"){s ret =##class(web.DHCPAAdmDischarge).PAAdmFinalDischarge(EpisodeID,userId) }
    i ret=0 q ..InsertVisitStat(EpisodeID, visStatCode, avsDate, avsTime, userId, wardId,notes)
    e  d
    .s PreVisitStatDesc=""
    .i PreVisitStatId'="" s PreVisitStatDesc=$p($G(^DHCPACVisitStatus(PreVisitStatId)),"^",2)  
   	q "先置病人状态为"_PreVisitStatDesc //wxl 081201 End
}

ClassMethod InsertVisitStat(EpisodeID, visStatCode, avsDate, avsTime, userId = "", wardId = "", notes = "") As %String
{
   	n (EpisodeID,visStatCode,avsDate,avsTime,userId,wardId,notes)
   	s visStatId=$o(^DHCPACVisitStatus(0,"Code",$$ALPHAUP^SSUTIL4(visStatCode),""))
	s admLocId=$P(^PAADM(EpisodeID),"^",4)
	s date=+$H
	s time=$P($H,",",2)
	&sql(INSERT INTO DHC_ADMVisitStatus (AVS_Paadm_Dr,AVS_VisitStatus,AVS_Date,AVS_Time,
    	AVS_User_Dr,AVS_Location,AVS_CreateDate,AVS_CreateTime,AVS_CreateUser,AVS_Ward_Dr,AVS_Note) 
    	values 
    	(:EpisodeID,:visStatId,:avsDate,:avsTime,:userId,:admLocId,:date,:time,:userId,:wardId,:notes))
    q SQLCODE
}

/// Description: 置病人死亡日期、时间
/// w ##class(web.DHCEMPatchange).SetDeceasedStatus("51","2016-08-16","21:35")
ClassMethod SetDeceasedStatus(EpisodeID = "", avsDateStr, avsTimeStr, userId) As %String
{
	q:EpisodeID="" "无病人就诊信息!"
	;s ret =##class(web.DHCPAAdmDischarge).PAAdmFinalDischarge(EpisodeID,userId)  //调用病人离院的方法
	s papmiId=$p(^PAADM(EpisodeID),"^",1)
	
	s DeceasedFlag=""
	s DeceasedDate=""
   	s DeceasedTime=""
	s DeceasedFlag=$p(^PAPER(papmiId,"ALL"),"^",12)
	s DeceasedDate=$p(^PAPER(papmiId,"ALL"),"^",13)
	s DeceasedTime=$p(^PAPER(papmiId,"ALL"),"^",8)
	;q:(DeceasedFlag'="")!(DeceasedDate'="")!(DeceasedTime'="") 0  //置了死亡时间可以修改
	
	s DeceasedFlag="Y"
	s DeceasedDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(avsDateStr)
   	s DeceasedTime=$ZTH(avsTimeStr)
	&sql(update PA_Person set PAPER_Deceased=:DeceasedFlag,PAPER_Deceased_Date=:DeceasedDate,PAPER_DeceasedTime=:DeceasedTime where PAPER_RowId=:papmiId)	
	i SQLCODE q "记录病人死亡状态日期时间出错!"
	q 0
}

/// 离院状态修改
/// w #class(web.DHCEMPatchange).PAAdmFinalDischarge("51","69")
ClassMethod PAAdmFinalDischarge(EpisodeID As %String, userId As %String) As %String
{
	q:EpisodeID="" "没有选择就诊病人"
	s ret=##class(web.DHCPAAdmDischarge).PAAdmFinalDischarge(EpisodeID,userId)
	q ret
}

/// Description: 撤销结算原因下拉列表
/// Input:  	 code：代码 
/// Return： 	 撤销结算原因
/// w ##class(web.DHCEMPatchange).PayoutreasonTojson("","")	
ClassMethod PayoutreasonTojson(code As %String, search As %String) As %String
{
	n (code,search,%session)
	s jsonObj=##class(web.DHCAPPJsonObject).%New()
	s count=1
	W "["
	
 	s RFDRowId=0 f  s RFDRowId=$o(^PAC("RFD",RFDRowId)) q:RFDRowId=""  d
    .s reasondesc=$p($g(^PAC("RFD",RFDRowId)),"^",2)
    .s reasondesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACReasonForReverseFinDisch","RFDDesc","",reasondesc) //hxy 2022-12-19
    .q:((reasondesc'[code)&(code'=""))
    .q:(search'="")&&(reasondesc'[search)
   
	.W $case(count,1:"",:",") 
	.w jsonObj.Put("id",RFDRowId).Put("text",reasondesc).Json()
	.S count=count+1
	W "]"
	q ""
}

/// 撤销结算判断
/// w ##class(web.DHCEMPatChange).GetFinalStat("")
/// w ##class(web.DHCEMPatchange).GetFinalStat("844")
ClassMethod GetFinalStat(EpisodeID) As %String
{
    //取得病人财务结算状态,财务最终结算,财务审核。
    s retStr=0
    q:EpisodeID="" "没有病人就诊号!"
    s PayMode=##class(web.DHCEMCommonUtil).IGetStayPayModeByAdmID(EpisodeID) 
	s BilledFlag = $p(^PAADM(EpisodeID),"^",45)
	s:((BilledFlag="Y")&&(PayMode=1)) retStr="请先去财务撤销财务结算！"
	q:retStr'=0 retStr
    s auditUser=$P($G(^PAADM(EpisodeID,2)),"^",92)
    i auditUser'="" s retStr="财务已审核,不能撤消最终结算!"
    q:retStr'=0 retStr
    s billFlag=$P($G(^PAADM(EpisodeID)),"^",45)
    s inadmId=$o(^DHCINADM("0","ADM",EpisodeID,""),-1)
    i inadmId'="" d 
        .s inadmActiveFlag=$p($g(^DHCINADM(inadmId)),"^",11)        ;INSU_AdmInfo表中的INADM_ActiveFlag字段
        .//i inadmActiveFlag="out" s retStr="医保已经导出,不能撤销最终结算!"
    q retStr
}

/// 撤消最终结算
ClassMethod ReversepayDischarge(compref As %Library.String, id As %Library.String, EpisodeID As %String, userId As %String, reverseDesc As %String)
{
	S reverseReasonId = ##class(web.PACReasonForReverseFinDisch).GetIdFromCodeOrDescription(reverseDesc)
	d ##class(web.DHCADTDischarge).PAAdmReverseFinalDischarge(EpisodeID, userId, reverseReasonId)
	;i retStr'="" q retStr
	;q ""
	q $$$OK
}

/// 删除病人的出院状态
/// Table:DHC_ADMVisitStatus
/// w ##class(web.DHCEMPatchange).deldischarge("243")
ClassMethod deldischarge(Adm) As %String
{
	s VisitStatus=$p($g(^PAADM(Adm)),"^",20)
	i VisitStatus="D" d
	.s id=$o(^DHCADMVisitStatus(0,"PAADM",Adm,""),-1) 
	.s PatCurStatusCTid=$p($g(^DHCADMVisitStatus(id)),"^",2)
	.i PatCurStatusCTid'="" d
	..s PatCurStatusCode=$p($g(^DHCPACVisitStatus(PatCurStatusCTid)),"^",1)
	..s PatCurStatusCode=$zcvt(PatCurStatusCode,"U")
	..i ((PatCurStatusCode["DISCHARGE")!(PatCurStatusCode="Death")) d
	...&sql(delete from DHC_ADMVisitStatus  where AVS_RowId=:id)
	q 0
}

/// 删除病人出院状态并执行撤销结算事务
/// userId: 用户id; reverseDesc: 撤销结算原因; Adm: 就诊id
/// other: 
/// w ##class(web.DHCEMPatChange).DelDisorReversePay("","","4636","病情变化","273")
ClassMethod DelDisorReversePay(compref As %Library.String, id As %Library.String, userId As %String, reverseDesc As %String, Adm As %String) As %String
{
	Q:Adm="" ""
	s PayMode=##class(web.DHCEMCommonUtil).IGetStayPayModeByAdmID(Adm) 
	s BilledFlag = $p(^PAADM(Adm),"^",45)
	ts
	s retStr=0
	s VisitStatus=$p($g(^PAADM(Adm)),"^",20)
	i VisitStatus="D" d
	.s id=$o(^DHCADMVisitStatus(0,"PAADM",Adm,""),-1) 
	.s PatCurStatusCTid=$p($g(^DHCADMVisitStatus(id)),"^",2)
	.i PatCurStatusCTid'="" d
	..s PatCurStatusCode=$p($g(^DHCPACVisitStatus(PatCurStatusCTid)),"^",1)
	..s PatCurStatusCode=$zcvt(PatCurStatusCode,"U")
	..i ((PatCurStatusCode["DISCHARGE")!(PatCurStatusCode="Death")) d
	...&sql(delete from DHC_ADMVisitStatus  where AVS_RowId=:id)
	...s:SQLCODE'=0 retStr=SQLCODE
	tro:retStr'=0
	q:retStr'=0 retStr
	s reverseDesc=##Class(web.DHCEMCommonUtil).GetBeforeTransDesc("User.PACReasonForReverseFinDisch","RFDDesc","EN",reverseDesc)
	S reverseReasonId = ##class(web.PACReasonForReverseFinDisch).GetIdFromCodeOrDescription(reverseDesc)
	s retStr=##class(web.DHCEMPatChange).PAAdmReverseFinalDischarge(Adm, userId, reverseReasonId)
	tro:retStr'=0
	q:retStr'=0 retStr
	
	s:((BilledFlag="Y")&&(PayMode=1)) retStr="请先去财务撤销财务结算！"
	tro:retStr'=0
	q:retStr'=0 retStr
	
	s BillFlag="N"
	i PayMode'=1 d
	.&sql(UPDATE PA_Adm SET PAADM_BillFlag=:BillFlag WHERE PAADM_RowID=:Adm)
	.s retStr = SQLCODE
	tro:retStr'=0
	q:retStr'=0 "修改结算标志出错！"
	
	&sql(UPDATE PA_AdmExt SET PAADM_DischargeDate=NULL,PAADM_DischargeTime=NULL WHERE PAADM_RowId=:Adm)
   	tro:SQLCODE'=0
   	q:SQLCODE'=0 "修改PaAdmExt中离院时间和日期错误！"
	tc
	q 0
}

/// Creator:  	bianshuai
/// CreateDate: 2016-11-28
/// Descript: 	设置病人留观信息
ClassMethod SetStayStatus(EpisodeID As %String, userId As %String, ctlocId As %String, wardId As %String, bedId As %String) As %String
{
	n (EpisodeID, userId, ctlocId, wardId, bedId)
	i wardId="" d
	.s ctlocType=$p($g(^CTLOC(ctlocId)),"^",13)
	.i (ctlocType="EM") d
	..s wardId=0
	..s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,wardId))
	.e  d
	..i (ctlocType="E") d  
	..s linksub=0
	..s linksub=$o(^CTLOC(ctlocId,"LINK",linksub))
	..i $g(linksub)'="" d
	...s linkCtlocId=$p($g(^CTLOC(ctlocId,"LINK",linksub)),"^",1)
	...i $g(linkCtlocId)'="" d
	....s linkCtlocType=$p($g(^CTLOC(linkCtlocId)),"^",13)
	....i $g(linkCtlocType)="EM" d 
	.....s wardId=0
	.....s wardId=$o(^PAWARD(0,"WARD_LocationDR",linkCtlocId,wardId))
	q:(wardId="") "无病区信息!"

	s curWardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
	i curWardId'="" q "病人已经在病区床位上"
	s curWardId=$o(^PAWARDA(0,"WADM",EpisodeID,""))
	i curWardId'="" q "病人已经在病区等待区"
	s roomId="",bedSub=""
	s statDesc=""
	i bedId'="" d ##class(web.PACBedStatusChange).IsUnavailBedStatus(bedId,.statDesc)
	i statDesc'="" q "该床位已经被占用"
	i bedId'="" s bedSub=$p(bedId,"||",2)
	i bedSub'="" s roomId=$p(^PAWARD(+bedId,"BED",bedSub),"^",3)
	&sql(update PA_ADM set PAADM_CurrentWard_Dr=:wardId,PAADM_CurrentRoom_DR=:roomId where PAADM_RowId=:EpisodeID)
	i SQLCODE q "更新病区信息出错!"
	s curDate=+$h,curTime=$p($h,",",2)
	s reqstId=$o(^PAC("REQST",0,"Code","T",""))
	s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
	&sql(insert into PA_AdmTransaction (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
		TRANS_Ward_DR,TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
		TRANS_TransType_DR,TRANS_Room_DR,TRANS_Bed_DR)  
		Values (:EpisodeID,:curDate,:curTime,:wardId,:reqstId,:curDate,:curTime,:userId,:transtypId,:roomId,:bedId))
	i SQLCODE q "插入转病区信息出错!"
	s transId=$g(%ROWID)
	q:transId="" ""
	s bookedStatus="O"
	if bedSub'="" 
	{
		&sql(insert into PAC_BedAdm (ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
			Values (:bedId,:EpisodeID,:bookedStatus,:transId))
		i SQLCODE q "插入床位信息出错!"
		&sql(update PA_Adm (PAADM_CurrentBed_DR) Values (:bedId) Where PAADM_RowId=:EpisodeID)
	}
	else
	{
		&sql(insert into PAC_WardAdm (WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus,WADM_Trans_DR)
			Values (:wardId,:EpisodeID,:bookedStatus,:transId))
		i SQLCODE q "插入病区信息出错!"
	}
	s locId=$p(^PAWARD(wardId),"^",5)
	q:locId="" ""
	s cptSub=$o(^CTLOC(locId,"CPT",0))
	q:cptSub="" 0
	s caretypId=$p($g(^CTLOC(locId,"CPT",cptSub)),"^")
	q:caretypId="" 0
	s caretypCode=$p(^PAC("CARETYP",caretypId),"^")
	q:caretypCode="" 0
	s ctacuId=$o(^CT("ACU",0,"Code",caretypCode,""))
	q:ctacuId="" 0
	&sql(update PA_Adm (PAADM_Priority_DR) Values (:ctacuId) Where PAADM_RowId=:EpisodeID)
    i SQLCODE q "修改病人等级出错!"
	q 0
}

/// Descript: 设置病人留观状态
ClassMethod setPatSatyStatus(EpisodeID, StatusDate, StatusTime, userID, WardDesc, LocID, EmWardID, EmBedID) As %String
{
	n (EpisodeID, StatusDate, StatusTime, userID, WardDesc, LocID, EmWardID, EmBedID)
	s Err=0
	s Err=##Class(web.DHCADMVisitStat).GetIfStaying(EpisodeID)
	Q:Err'=0 "-1"
	TS
	/// 更新状态
	s Err = ##Class(web.DHCEMPatChange).InsertVis(EpisodeID,"Stay",StatusDate,StatusTime,userID,WardDesc)
	i Err'=0 Tro
	Q:Err'=0 "-2"
	/// 更新留观相关信息
	s Err = ##Class(web.DHCEMPatChange).SetStayStatus(EpisodeID, userID, LocID, EmWardID, EmBedID)
	i Err'=0 Tro
	Q:Err'=0 "-3"
	TC
	Q 0
}

/// Descript:   病区床位列表
/// Creator:    bianshuai
/// CreateDate: 2016-11-30
/// W ##Class(web.DHCEMPatChange).JSonQryEmWardBed("0","1","")
ClassMethod JSonQryEmWardBed(offset As %String, limit As %String, WardID As %String, EpisodeID As %String) As %String
{
	n (offset,limit,WardID,EpisodeID)

	s Start=offset+1
	s End=offset+limit
	s ^BIANSHUAI(123)=WardID_"||"_EpisodeID
 	Set result=##class(%Library.ResultSet).%New("web.DHCEMPatChange:QueryEmWardBed")
 	Set sc=result.Execute(WardID,EpisodeID)
 	If $$$ISERR(sc) Quit ""

    Set colNum=result.GetColumnCount() //列数
    Set count = 0
    Set del=""""
 	Set tmp=""
 	Write ##class(web.DHCSTPHCMCOMMON).getJsonStartSignNoTotal() //输出json前缀串
	While(result.Next())
	{ 
		Set ret=""
		For i=1:1:colNum Do
		.If ret="" Set ret=del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.Else   Set ret=ret_","_del_result.GetColumnName(i)_del_":"_del_$P(result.%GetData(i),$C(13,10))_del
		.
		Set count = count+1
		Continue:(count<Start)||(count>End)
		If count=Start Write "{"_ret_"}"
		Else  Write ",{"_ret_"}"
	 }
	 w "]"
	 w ","_del_"total"_del_":"_count
	 w "}"
	 //Write ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	 Do result.Close()
	 Quit ""
}

/// Descript:   病区床位列表
/// Creator:    bianshuai
/// CreateDate: 2016-11-30
/// D ##Class(%ResultSet).RunQuery("web.DHCEMPatChange","QueryEmWardBed","","")
Query QueryEmWardBed(WardID As %Library.String, EpisodeID As %Library.String) As %Query(ROWSPEC = "BedDesc:%String,WardDesc:%String,RoomDesc:%String,BedType:%String,statDesc:%String,WardBedID:%String,WardID:%String,BedTypeID:%String,RoomID:%String,RoomTypeID:%String,RoomType:%String,WardBedAvrID:%String,RestrictReason:%String,RestrictDateFrom:%String,RestrictTimeFrom:%String,RestrictDateTo:%String,RestrictTimeTo:%String")
{
}

ClassMethod QueryEmWardBedExecute(ByRef qHandle As %Binary, WardID As %Library.String, EpisodeID As %Library.String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	
	i (WardID = ""){
		set WardID=$O(^PAWARD(0))
		while (WardID'="")
		{
			d findbyward(WardID)
			set WardID=$O(^PAWARD(WardID))
		}
	}
	else
	{
		d findbyward(WardID)
	}
	s QHandle=$lb(0,repid,0)
	Quit $$$OK
	
findbyward(WardID)
	Q:+WardID=0 ""
	s WardDesc = $p(^PAWARD(WardID),"^",2)
	s PAAdmType=$P($g(^PAADM(EpisodeID)),"^",2)
	s wardLinkLoc=$p($G(^PAWARD(WardID)),"^",5)
	q:wardLinkLoc="" ""
	s locType=$p(^CTLOC(wardLinkLoc),"^",13)
	q:(locType'="EM")&&(PAAdmType="E") ""
	s bedsub=0 f  {
		s bedsub=$o(^PAWARD(WardID,"BED",bedsub)) 
		q:bedsub=""
		s BedDesc=$p(^PAWARD(WardID,"BED",bedsub),"^",1)
		s RoomDesc=""
		s RoomID=$p(^PAWARD(WardID,"BED",bedsub),"^",3)
		s:RoomID'="" RoomDesc=$p($g(^PAROOM(RoomID)),"^",2)
		s BedTypeID=$p(^PAWARD(WardID,"BED",bedsub),"^",2)
		s:BedTypeID'="" BedType=$p($g(^PAC("BEDTP",BedTypeID)),"^",2)
		s RcFlag=$p(^PAWARD(WardID,"BED",bedsub),"^",4)
		continue:(RcFlag="N") ;未激活的床
		s RoomTypeID=""
		s:RoomID'="" RoomTypeID=$p($G(^PAROOM(RoomID)),"^",3)	
		s:RoomTypeID'="" RoomType=$p($G(^PAC("ROOMT",RoomTypeID)),"^",2)
	
		s BedID=WardID_"||"_bedsub
		&sql(select BED_Available into :available from SQLUser.PAC_Bed WHERE BED_RowId = :BedID)
		s:EpisodeID'="" statDesc=$s(available="N":"占用",1:"空")
		s statDesc=""
		s unavail=##class(web.PACBedStatusChange).IsUnavailBedStatus(BedID,.statDesc)
		
		;如果床位上已经安排病人,就不需要显示
		s adm=$o(^PAWARDA(+WardID,"BED",+$p(BedID,"||",2),"ADM",0))
		continue:(adm'="")
		;PAC_BedAvailRestriction
		s avrbedsub=0 f {
			s avrbedsub=$o(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub)) 
			q:avrbedsub=""
			s RestrictReasonDR=$p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",3)
			s RestrictReason=$p(^PAC("RNAV",RestrictReasonDR),"^",2)
			s RestrictDateFrom=$zd($p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",1),3)
			s RestrictTimeFrom=$zd($p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",4),3)
			s RestrictDateTo=$zd($p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",2),3)
			s RestrictTimeTo=$zd($p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",5),3)
		}
		;PAC_BedStatusChange, availRestriction表中没存记录, 从状态表中取数据,wanghc
		if (statDesc'=""){
			s statubedsub=$o(^PAWARDA(WardID,"BED",bedsub,"STAT",""),-1) 
			if statubedsub>0{
				Set tmpstatdata = $g(^PAWARDA(WardID,"BED",bedsub,"STAT",statubedsub))
				s RestrictReasonDR=$p(tmpstatdata,"^",7)
				s RestrictReason=$p(^PAC("RNAV",RestrictReasonDR),"^",2)
				s RestrictDateFrom=$p(tmpstatdata,"^",1)
				IF (RestrictDateFrom'="") SET RestrictDateFrom=$zd(RestrictDateFrom,3)
				s RestrictTimeFrom=$p(tmpstatdata,"^",2)
				IF (RestrictTimeFrom'="") SET RestrictTimeFrom=$zT(RestrictTimeFrom)
				s RestrictDateTo=$p(tmpstatdata,"^",5)
				IF (RestrictDateTo'="") SET RestrictDateTo=$zD(RestrictDateTo,3)
				s RestrictTimeTo=$p(tmpstatdata,"^",6)
				IF (RestrictTimeTo'="") SET RestrictTimeTo=$zT(RestrictTimeTo)
			}
			
		}
		d outputrow
	}
	Q
outputrow
	s ^CacheTemp(repid,ind)=$lb(BedDesc,WardDesc,RoomDesc,BedType,statDesc,WardID_"||"_bedsub,WardID,BedTypeID,RoomID,RoomTypeID,RoomType,WardID_"||"_bedsub_"||"_avrbedsub,RestrictReason,RestrictDateFrom,RestrictTimeFrom,RestrictDateTo,RestrictTimeTo)
	s ind=ind+1
	q
}

ClassMethod QueryEmWardBedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEmWardBedExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QueryEmWardBedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEmWardBedExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {                // if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else {         
	    Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetWardCodeByWardDr(WardDr As %String)
{
	n (WardDr,%session)
	s LocDr = $p(^PAWARD(WardDr),"^",5)
	q ##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCContactName","",$p(^CTLOC(LocDr),"^",43)) //hxy 2022-12-20
}

/// 撤消最终结算
ClassMethod PAAdmReverseFinalDischarge(EpisodeID, userId, reverseReasonId) As %String
{
	q:EpisodeID="" "没有选择就诊病人!"
	q:$p(^PAADM(EpisodeID),"^",20)'="D" "只能对出院病人操作!"
	q:reverseReasonId="" "没有撤消最终结算原因!"
	s retStr=..GetFinalStat(EpisodeID)
	i retStr'=0 q retStr
	//s ^ypzTmp(EpisodeID)=userId_"/"_disConDesc_"/"_deceasedDate_"/"_deceasedTime
	s ctcpId=$p($g(^SSU("SSUSR",+userId)),"^",14)
	q:ctcpId="" "请用医护人员的身份操作!"
    s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
	q:ctcptId="" "未定义医护人员类型!"
    s ctcptInternalType=$P($g(^CT("CPT",ctcptId)),"^",4)
    q:(ctcptInternalType'="DOCTOR")&(ctcptInternalType'="NURSE") "医护人员类型错!"
    
    s curDate=+$h,curTime=$p($h,",",2)
    s dischDate="",dischTime=""

	s visitStatusCode="A"
	Set $ZT="ERROR"
	TSTART
	&sql(update PA_ADM set PAADM_VisitStatus=:visitStatusCode,
			PAADM_DischgDate=:dischDate,PAADM_DischgTime=:dischTime,
			PAADM_UpdateDate=:curDate,PAADM_UpdateTime=:curTime,PAADM_UpdateUser_DR=:userId 
			where PAADM_RowId=:EpisodeID)
	i SQLCODE TROLLBACK  q "修改病人结算状态错误!"
	s wardId=$p(^PAADM(EpisodeID),"^",70)
	s bedId=$p(^PAADM(EpisodeID),"^",73)
	s bedSub=$p(bedId,"||",2)
	s reverseBed="N"  //默认转到等待区
	i bedSub'="" d
	    .q:$p(^PAWARD(wardId,"BED",bedSub),"^",4)="N" 
	    .s reverseBed="Y"
	    .s bedAdmSub=0
	    .f  s bedAdmSub=$o(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub)) q:bedAdmSub=""  d
	        ..i $p(^PAWARDA(+bedId,"BED",bedSub,"ADM",bedAdmSub),"^",2)="O" s reverseBed="N"
	        ..//w bedAdmSub,"/",reverseBed
	s transBed="N"
	i reverseBed="Y" d
		.s bookedStatus="O"
		.s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
		.s preTransSub="",transSub=0
		.f  s preTransSub=$o(^PAADM(EpisodeID,"TRANS",preTransSub),-1) q:(preTransSub="")!(transSub>0)  d
	    	..i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)=transtypId s transSub=preTransSub
	        ..//w preTransSub,"/",transSub,!
		.q:transSub=0
		.s transId=EpisodeID_"||"_transSub
		.&sql(insert into PAC_BedAdm (ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
			Values (:bedId,:EpisodeID,:bookedStatus,:transId))
		.i SQLCODE s retStr="插入床位信息出错!" q
		.s transBed="Y"
	i retStr'=0 TROLLBACK  q retStr
	i (reverseBed'="Y")||(transBed'="Y") d
	.s retStr=##class(web.DHCADTTransaction).MoveAdm(EpisodeID, userId, wardId, "","N")
	s RecallHos=##class(web.DHCEMCommonUtil).GetTrans("dhcem.visitstat.csp","离院召回")
	i retStr'=0 TROLLBACK  q retStr
	s mradmId=$P(^PAADM(EpisodeID),"^",61)
	i $P(^PAADM(EpisodeID),"^",2)="E" d
    .s curdate = $ZD(+$h,4)
    .s curtime = $zt($p($h,",",2))
    .s warddesc = $p(^PAWARD(wardId),"^",2)
    .s upStatusCode = ##class(web.DHCEMPatChange).GetDisUpStatusCode(EpisodeID)
    .b ;3
    .s rtn = ##class(web.DHCADMVisitStat).InsertVis(EpisodeID,upStatusCode,curdate,curtime,userId,warddesc,1,RecallHos)
	&sql(update MR_Adm set MRADM_ReasonForRevFinDisch_DR=:reverseReasonId where MRADM_RowId=:mradmId)
	i SQLCODE'=0 TROLLBACK  q "修改撤消最终结算原因错!"
	TCOMMIT
	d ##class(web.DHCEMPatChange).ISendCancelDisInfo(EpisodeID) 
	q retStr
ERROR	; 
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
 	TROLLBACK		       //回滚事务
 	Quit "错误提示:"_ErrorMsg
}

ClassMethod ISendCancelDisInfo(Adm As %String)
{
	s res=0
	q:Adm="" res
	s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDADMCANCELOUTINFO",Adm)
    s rtnmes1=$p(rtn,"^")
    s rtnmes2=$p(rtn,"^",2)
    i rtnmes1'=0 s res=rtnmes2
    q res
}

/// 通过就诊获取离院状态的上个状态为留观或者抢救
ClassMethod GetDisUpStatusCode(EpisodeID)
{
	n (EpisodeID)
	i EpisodeID="" q "Stay"
	s Status=""
	s AvsId=""
	f  s AvsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,AvsId),-1) q:(AvsId="")||(Status'="")  d
	.s PvsId=$P(^DHCADMVisitStatus(AvsId),"^",2)
   	.s DymStatusCode = $P(^DHCPACVisitStatus(PvsId),"^",1)
   	.q:(DymStatusCode'["Stay")&&(DymStatusCode'["Salvage")
   	.s Status = DymStatusCode
   	s:Status="" Status="Stay"
   	q Status
}

}
