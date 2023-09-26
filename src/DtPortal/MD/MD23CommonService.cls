/// 名称:DtPortal.MD.MD23HospitalMonitor
/// 描述:住院监控调用的一些方法
/// 编写者：白明哲
/// 编写日期: 2015-11-23
Class DtPortal.MD.MD23CommonService Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator： bmz
/// CreatDate： 2015-11-26
/// Description: 根病区ID取该病区床位数、已占床位数
/// Input：	wardId
/// Return：bedNum、bedPatNum
/// Debug：w ##class(DtPortal.MD.MD23CommonService).getBedNumByWardId(10)
ClassMethod getBedNumByWardId(wardId As %String) As %String
{
	
	n (wardId)
	q:+wardId=0 "0^0" 
	s bedNum=0
	s bedPatNum=0
	
	
	s bedIdStr=##class(DtPortal.Common.PublicService).getBedIDStrByWardID(wardId,2)
	s bedLength=$l(bedIdStr,"^")
	f bedIndex=1:1:bedLength d
	.s bedId=$p(bedIdStr,"^",bedIndex)
	.q:bedId=""
	.s bedChild=$p(bedId,"||",2)
	.Set bedNum=bedNum+1
	.s bedAvailable=$$CO18^at153(wardId_"||"_bedChild)  //取床位是否可用
	.s baoChuang=..ifBaoChuang(wardId_"||"_bedChild)
	.s isValid=##class(DtPortal.Common.PublicService).isValidBed(wardId_"||"_bedChild)
	.q:isValid'="1"
	.i (bedAvailable'="Y")||(baoChuang'=0) s bedPatNum=bedPatNum+1   //已占的床位数   by cfyc 床为状态包括其他占用情况
	q bedNum_"^"_bedPatNum
}

/// Creator： bmz
/// CreatDate： 2015-11-26
/// Description: 按病区取当前在院的病人数量
/// Input：	wardId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).getPatNumByWardId(10)
ClassMethod getPatNumByWardId(wardId As %String) As %String
{
	n (wardId)
	q:+wardId="0" ""
	
	//取公共方法，false表示不按配置过滤床位
	s admStr=##Class(DtPortal.Common.PaadmService).GetIPPaadmList("ward","",wardId,"true")
	q:admStr="" ""
	q $l(admStr,"^")
}

/// Creator： bmz
/// CreatDate： 2015-11-26
/// Description: 按病区取昨日在院的病人数量
/// Input：	wardId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).getYesPatNumByWardId(10)
ClassMethod getYesPatNumByWardId(wardId As %String) As %String
{
	
	n (wardId)
	
	q:+wardId="0" ""
	//昨日在院人数--综合查询的表
	s yesInpatientNum=0
	s mripId=0
	s mripId=$o(^MRIPdaily("MRIPWARD",wardId,"MRIPDATE",+$h-1,mripId))
	i +mripId'="0" s yesInpatientNum=$p(^MRIPdaily(mripId),"^",18)  //现有人数
	q yesInpatientNum
}

/// Creator： bmz
/// CreatDate： 2015-11-26
/// Description: 按病区取今日出院的病人数量
/// Input：	wardId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).getDisPatNumByWardId(10)
ClassMethod getDisPatNumByWardId(wardId As %String) As %String
{
	
	n (wardId)
	
	q:+wardId="0" ""
	
	//今日出院人数
	s dischargeNum=0
	s PAAdm=""
	f  s PAAdm=$o(^PAADMi("DischDate",+$h,PAAdm)) q:PAAdm=""  d
	.s PatWardId=$p(^PAADM(PAAdm),"^",70)
	.q:(PatWardId="")||(wardId'=PatWardId)
	.s dischargeNum=dischargeNum+1
	q dischargeNum
}

/// Creator： bmz
/// CreatDate： 2015-11-26
/// Description: 按病区、时间查询死亡人数和就诊ID---bmz20170315
/// Input：	wardId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).getDeadNumByWardId(10,63880,63883)
ClassMethod getDeadNumByWardId(wardId As %String = "", sDate As %String = "", eDate As %String = "") As %String
{
	
	n (wardId,sDate,eDate)
	
	q:+wardId="0" ""
	q:(sDate="")||(eDate="") ""
	s deadNum=0
	s episodeIdStr=""
	
	//需要一个病人id对应一个就诊id---把就诊id存进病人数组里

	f Date=sDate:1:eDate  d
	.s papmi=""
	.f  s papmi=$o(^PAPERi("DecDate",Date,papmi)) q:papmi=""  d
	..s atype="",episodeId=0 f  s atype=$o(^PAPERdr(papmi,"ADM",atype)) q:atype=""  d
	...s admid="" f  s admid=$o(^PAPERdr(papmi,"ADM",atype,admid)) q:admid=""  d
	....s AdmType=$p(^PAADM(admid),"^",2)
	....q:AdmType="O"
	....i admid>episodeId s episodeId=admid
	..q:episodeId=0
	..;s patinfo=##Class(DtPortal.Common.PaadmService).GetPatInfo(episodeId)
	..;q:..ifPatDead(episodeId)=0
	..s patWardId=$p(^PAADM(episodeId),"^",70)
	..i (patWardId'="")&&(patWardId=wardId) d
	...s deadNum=deadNum+1
	...i episodeIdStr="" s episodeIdStr=episodeId
	...e  s episodeIdStr=episodeIdStr_"^"_episodeId
	
	//当前在院的死亡患者--过滤病人信息表的状态继续判断
	s patRoomId=""
    f  s patRoomId=$o(^PAADMi("CurrWard",wardId,patRoomId)) q:patRoomId=""  d
    .s episodeId=0
    .f  s episodeId=$o(^PAADMi("CurrWard",wardId,patRoomId,episodeId)) q:episodeId=""  d
    ..;过滤重复数据
    ..q:$LF($LISTFROMSTRING(episodeIdStr,"^"),episodeId)
    ..s deadPatFlag=##class(DtPortal.MD.MD23CommonService).ifPatDead(episodeId)
	..i deadPatFlag=1 d
	...s deadNum=deadNum+1       
	...i episodeIdStr="" s episodeIdStr=episodeId
	...e  s episodeIdStr=episodeIdStr_"^"_episodeId     
	
	
	q deadNum_"#"_episodeIdStr
}

/// Creator： bmz
/// CreatDate： 2015-12-03
/// Description: 判断患者是否是术后
/// Input：	episodeId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).ifOpeAfterByAdm("")
ClassMethod ifOpeAfterByAdm(episodeId As %String = "") As %String
{
	
	n (episodeId)
	s opeAfterFlag=0
	//"A"是申请，"D"是拒绝，"R"是安排，"I"是术中，"P"是恢复室，"L"是离室(术毕)，"F"是完成。""是全部。可以用"ARF"这样的组合查询多个状态。
	s opastatus="PLF"   //"P"是恢复室，"L"是离室(术毕)，"F"是完成，，这三个判断术后
	s opId=""
	f  s opId=$o(^DHCANOPArrange(0,"Adm",episodeId,opId)) q:(opId="")||(opeAfterFlag=1)  d
	.s stat=$P(^DHCANOPArrange(opId),"^",27)
	.q:(opastatus'="")&((opastatus'[stat)!(stat=""))
	.s opeAfterFlag=1
	q opeAfterFlag
}

/// Creator： bmz
/// CreatDate： 2015-12-03
/// Description: 判断患者是否二次及以上手术
/// Input：	episodeId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).ifReOpeByAdm(10,63880,63883)
ClassMethod ifReOpeByAdm(episodeId As %String = "") As %String
{
	
	n (episodeId)
	s ifReOpe=0
	s num=0
	//"A"是申请，"D"是拒绝，"R"是安排，"I"是术中，"P"是恢复室，"L"是离室(术毕)，"F"是完成。""是全部。可以用"ARF"这样的组合查询多个状态。
	s opastatus="PLF"   //"P"是恢复室，"L"是离室(术毕)，"F"是完成，，这三个判断术后
	s opId=""
	f  s opId=$o(^DHCANOPArrange(0,"Adm",episodeId,opId)) q:(opId="")||(ifReOpe=1)  d
	.s stat=$P(^DHCANOPArrange(opId),"^",27)
	.q:(opastatus'="")&((opastatus'[stat)!(stat=""))
	.s num=num+1
	.i num>1 s ifReOpe=1   //取两次及以上的手术
	q ifReOpe
}

/// Creator： bmz
/// CreatDate： 2015-12-03
/// Description: 判断床位是否包床
/// Input：	bedId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).ifBaoChuang("5||1")
ClassMethod ifBaoChuang(bedId As %String = "") As %String
{
	
	n (bedId)
	s baoFlag=0
	s baoFlag=0  //包床标记
	s StatSub=0  //循环包床记录
	f  s StatSub=$o(^PAWARDA($p(bedId,"||",1),"BED",$p(bedId,"||",2),"STAT",StatSub)) q:StatSub=""  d
	.s startDate=$p($g(^PAWARDA($p(bedId,"||",1),"BED",$p(bedId,"||",2),"STAT",StatSub)),"^",1)
	.s startTime=$p($g(^PAWARDA($p(bedId,"||",1),"BED",$p(bedId,"||",2),"STAT",StatSub)),"^",2)
	.s endDate=$p($g(^PAWARDA($p(bedId,"||",1),"BED",$p(bedId,"||",2),"STAT",StatSub)),"^",5)
	.s endTime=$p($g(^PAWARDA($p(bedId,"||",1),"BED",$p(bedId,"||",2),"STAT",StatSub)),"^",6)
	.i (endDate'="")&&(endTime="") s endTime=86400
	.s startTotal=startDate*100000+startTime
	.s endTotal=endDate*100000+endTime
	.s nowTotal=+$h*100000+$p($h,",",2)
	.s StatusId=$p($g(^PAWARDA($p(bedId,"||",1),"BED",$p(bedId,"||",2),"STAT",StatSub)),"^",7)
	.i StatusId'="" s StatusDesc=$p($g(^PAC("RNAV",StatusId)),"^",2) 
	.e  s StatusDesc="" 
	.i (endDate'="")&&(nowTotal>=startTotal)&&(nowTotal<=endTotal)&&(StatusDesc["包床") s baoFlag=1
	.i (endDate="")&&(startTotal<=nowTotal)&&(StatusDesc["包床") s baoFlag=1
	.i (endDate'="")&&(nowTotal>=startTotal)&&(nowTotal<=endTotal)&&(StatusDesc'="")&&(StatusDesc'["包床") s baoFlag=2_"^"_StatusDesc
	.i (endDate="")&&(startTotal<=nowTotal)&&(StatusDesc'="")&&(StatusDesc'["包床") s baoFlag=2_"^"_StatusDesc
	q baoFlag
}

/// Creator： 程鹏
/// CreatDate： 2018-10-10
/// Description: 获取是否有某类医嘱
/// Input：	episodeId
/// Input：	ArcCode  用^分隔
/// Return：1^0^1^1  按照入参ArcCode顺序依次返回，如果有该医嘱，返回1，没有返回0
/// Debug：w ##class(DtPortal.MD.MD23CommonService).getArcNums("4","CRITICALCARE^RESCUE^SERIOUSLYCRITICALLY")
ClassMethod getArcNums(episodeId As %String, ArcCode As %String) As %String
{
	
	n (episodeId,ArcCode)
	k ^||TMPPortalgetArcNums
	set ord=$o(^OEORD(0,"Adm",episodeId,""))
 	quit:ord="" 0
 	set arcimIDs=##class(DtPortal.Configure.arcim).getArcImID(ArcCode,1)
 	set ordSttTime="" 
 	for
 	{
	 	set ordSttTime=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime)) 
	 	quit:ordSttTime=""
	 	
	 	set OrdSub=0
	 	for
	 	{
		 	set OrdSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub)) 
		 	quit:OrdSub=""
		 	
		 	set OreSub=0
		 	for
		 	{
			 	set OreSub=$o(^OEORDi(0,"Date",ord,+$h,ordSttTime,OrdSub,OreSub)) 
			 	quit:OreSub=""
			 	
			 	set ordStatusId=$p($g(^OEORD(ord,"I",OrdSub,"X",OreSub,"BILL")),"^",1)  
 				set ordStat=$p($g(^OEC("OSTAT",ordStatusId)),"^",1)
 				continue:(ordStat'="V")&(ordStat'="E") 
 				set ArcRowId=$p(^OEORD(ord,"I",OrdSub,1),"^",2)
 				set ArcRowIdsS="^"_ArcRowId_"^"
 				
 				for index=1:1:$l(arcimIDs,"*")
 				{
	 				set arcimIDs2=$p(arcimIDs,"*",index)
	 				set arcimIDs2="^"_arcimIDs2_"^"
	 				continue:("^"_arcimIDs2_"^")'[ArcRowIdsS
	 				set ^||TMPPortalgetArcNums("arcimNum",index)=1
	 			}
			}
		}
	}  
	
	set retStr=""
 	set index=0
 	for index=1:1:$l(arcimIDs,"*")
 	{
	 	set num=+$g(^||TMPPortalgetArcNums("arcimNum",index))
	 	set:retStr'="" retStr=retStr_"^"_num
	 	set:retStr="" retStr=num
	}
 
	k ^||TMPPortalgetArcNums
	q retStr
}

/// Creator： bmz
/// CreatDate： 2015-12-03
/// Description: 判断患者是否特级护理
/// Input：	episodeId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).ifSpecialNur("211")
ClassMethod ifSpecialNur(episodeId As %String = "") As %String
{
	
	n (episodeId)
	s ifSpecialNur=0
	s arcimCodes=""  //判断特级护理用
	s arcimCodes=##class(DtPortal.Configure.arcim).getArcImID("CRITICALCARE",2)
	q:arcimCodes="" 0
	s ifSpecialNur=##class(DtPortal.Common.PaadmService).IfOrddailyExist(episodeId,arcimCodes)
	
	q ifSpecialNur
}

/// Creator： bmz
/// CreatDate： 2015-12-03
/// Description: 判断患者是否病危病重
/// Input：	episodeId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).ifCritical("211","all")
ClassMethod ifCritical(episodeId As %String = "", codes As %String = "") As %String
{
	
	n (episodeId,codes)
	/*
	s ifCritical=0
	
	s arcimCodes=""
	//取病危和病重医嘱Code
	s SeriouslyCode=""
	s SeriouslyCode=##class(DtPortal.Configure.arcim).getArcImID("SERIOUSLY",2)
	s CriticallyCode=""
	s CriticallyCode=##class(DtPortal.Configure.arcim).getArcImID("CRITICALLY",2)
	;i (SeriouslyCode'="")||(CriticallyCode'="") s arcimCodes=SeriouslyCode_"^"_CriticallyCode
	;e  s arcimCodes=""
	if ((SeriouslyCode'="")&&(codes="s")){
		s arcimCodes=SeriouslyCode
	}elseif((CriticallyCode'="")&&(codes="c")){
		s arcimCodes=CriticallyCode
	}elseif(((SeriouslyCode'="")||(CriticallyCode'=""))&&(codes="all")){
		s arcimCodes=SeriouslyCode_"^"_CriticallyCode
	}else{
		s arcimCodes=""
	}  
	
	q:arcimCodes="" 0
	s ifCritical=##class(DtPortal.Common.PaadmService).IfOrddailyExist(episodeId,arcimCodes)
	q ifCritical
	*/
	set arcimIDs=##class(DtPortal.Configure.arcim).getArcImID("CRITICALLY^SERIOUSLY",1)
	
	set ArcNums=##class(DtPortal.Common.PaadmService).getArcNums(episodeId,arcimIDs)
	if (codes="c"){
		if ($p(ArcNums,"^",1)=1){
			q 1
		}
	}elseif(codes="s"){
		if ($p(ArcNums,"^",2)=1){
			q 1
		}
	}elseif(codes="all"){
		if (($p(ArcNums,"^",1)+$p(ArcNums,"^",2))>0){
			q 1
		}
	}
	
	q 0
}

/// Creator： bmz
/// CreatDate： 2015-12-03
/// Description: 判断患者是否抢救患者--根据床位图的判断
/// Input：	episodeId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).ifRescuePat("211")
ClassMethod ifRescuePat(episodeId As %String = "") As %String
{
	
	n (episodeId)
	s ifRescuePat=0
	s arcimCodes=""
	s arcimCodes=##class(DtPortal.Configure.arcim).getArcImID("RESCUE",2)
	q:arcimCodes="" 0
	s ifRescuePat=##class(DtPortal.Common.PaadmService).IfOrddailyExist(episodeId,arcimCodes)
	q ifRescuePat
}

/// Creator： bmz
/// CreatDate： 2015-12-04
/// Description: 判断患者是否死亡、死亡上报
/// Input：	episodeId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).ifPatDead("211")
ClassMethod ifPatDead(episodeId As %String = "") As %String
{
	
	n (episodeId)
	s ifPatDead=0
	
	//判断病人信息表标记
	set patientID=$P($g(^PAADM(episodeId)),"^",1)
	s deadPat=$p(^PAPER(patientID,"ALL"),"^",12)  //死亡标记
	i deadPat="Y" s ifPatDead=1
	
	i ifPatDead=1 q ifPatDead //返回标记
	
	
	//判断死亡上报
	s deadReportStr=##class(DtPortal.Common.PaadmService).IsDTHReport(episodeId)
	s deadReportID=$p(deadReportStr,"^",1)
	i +deadReportID>0 s ifPatDead="1"
	
	i ifPatDead=1 q ifPatDead   //返回标记
	
	q ifPatDead
}

/// Creator： bmz
/// CreatDate： 2015-12-04
/// Description: 判断是否是本院患者
/// Input：	episodeId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).ifTHosPat("211")
ClassMethod ifTHosPat(episodeId As %String = "") As %String
{
	
	n (episodeId)
	s ifTHosPat=0
	s AdmReasonDr=$P($g(^PAADM(episodeId)),"^",73)  //取费用类别--就诊类别？用于判断本院
    s AdmReason=""
	Set AdmReasonDr=$P($g(^PAADM(episodeId,1)),"^",7)
	If AdmReasonDr'="" Set AdmReason=$P($g(^PAC("ADMREA",AdmReasonDr)),"^",2)
	;i AdmReason="本院" s ifTHosPat=1
	i AdmReason["本院" s ifTHosPat=1   // by cfyc 1026 
	q ifTHosPat
}

/// Creator： bmz
/// CreatDate： 2015-12-04
/// Description: 判断是否今日出院
/// Input：	episodeId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).ifTOutHosNum("211")
ClassMethod ifTOutHosNum(episodeId As %String = "") As %String
{
	
	n (episodeId)
	s ifTOutHosNum=0
	s patVisit=$p($g(^PAADM(episodeId)),"^",20)
	s dischgDate=$p($g(^PAADM(episodeId)),"^",17)
    i (patVisit="D")&&(dischgDate=+$h) s ifTOutHosNum=1
	q ifTOutHosNum
}

/// Creator:			zhougang(zg)
/// CreatDate:		2014.12.18
/// Description:   	根据就诊查询欠费患者信息
/// Table：       	被访问的表:DHC_JFQFTotal
/// Input:			输入参数说明:病人就诊的EpisodeId
/// Return：         函数返回值的说明：
/// 					正常返回 		1^总费用^费用类别^个人自付^押金^欠费总额信息
/// 					欠费病人返回 	2^总费用^费用类别^个人自付^押金^欠费总额信息
/// 					错误返回 		"0^^^^^"
ClassMethod UDHCJFGetQFPatDetailByEpisodeId(EpisodeId As %String, ExpStr As %String = "") As %String
{
	//w ##Class(web.UDHCJFARREARSMANAGE).UDHCJFGetQFPatDetailByEpisodeId(267)
	;n (EpisodeId)
	s QFflag=0					;欠费病人标志：0错误信息，1：未欠费 2：欠费 
	s ReturnValue=QFflag_"^^^^"
	q:$g(EpisodeId)="" ReturnValue
	
	s admtype=$p(^PAADM(EpisodeId),"^",2)
	s JFType=""
	i admtype="I" s JFType="住院收费"
	e  s JFType="门诊收费"
	
	q:(admtype'="I") QFflag_"^^^^"		;控制只查询住院
	;收费已结算的情况。根据支付方式QF来处理，暂不考虑。
	
	/*
	;未结算的情况。符合：NH13.07欠费患者 服务定义 的要求。
	;总费用,病人自付费用
	s PatBillFeeinf=..UDHCJFGetBillFeeInfo(EpisodeId, "", +$h)
	s PatTotal=$p(PatBillFeeinf,"^",1)
	s PatShare=$p(PatBillFeeinf,"^",2)
		
	;s arrrowid=..GetAdmArrears(EpisodeId)			;DHC_JFArrearsMoney表rowid
	s arrrowid=##class(web.UDHCJFARREARSMANAGE).GetAdmArrears(EpisodeId)
	;有配置取费用比例：这里的比例还不太理解。比例参考上面的程序。
	s FeeRate=1
    i ($g(arrrowid)'="")&&($d(^DHCJFARREARS(arrrowid)))&&($d(^DHCJFARREARS(0,"AM",arrrowid))) d	
	  .s type=""
	  .f  s type=$o(^DHCJFARREARS(0,"AM",arrrowid,type)) q:type=""  d
	  ..s al=""
	  ..f  s al=$o(^DHCJFARREARS(0,"AM",arrrowid,type,al)) q:al=""  d
	  ...s sub=$o(^DHCJFARREARS(0,"AM",arrrowid,type,al,""))
	  ...s str=^DHCJFARREARS(arrrowid,"M",sub)
	  ...s FeeRate=$p(str,"^",17)
  
 	i $g(FeeRate)="" s FeeRate=1
 	;医保的信息
 	s ybinfo="0^0^0^0"	;总金额,医保基金支付,个人自付;这里需要调用医保接口
 	s YBJJZF=$p(ybinfo,"^",2)		;医保基金支付.默认0
	
	;未结算押金
	s PatDeposit=##class(web.UDHCJFBaseCommon).deposit(EpisodeId)
	
    ;住院在院病人的欠费算法。
    s warrantamt=##class(web.UDHCJFARREARSMANAGE).GetWarrAmt(EpisodeId) ;病人有效担保金额
    s Balance=PatDeposit+warrantamt+YBJJZF-(billamount*FeeRate)
    ;i ($g(PatDeposit)+$g(warrantamt)-$g(PatShare))'=$g(PatQfTotal)  d
    i Balance'<0 d
    .s QFflag=1	 		;未欠费标志
    .s Balance=0.00
    e  d
    .s QFflag=2	 		;欠费标志
    .s Balance=Balance*(-1)
    
    i (admtype="I")  d
    .s PatQfTotal=Balance
    */
    
	s billAmount=##class(web.UDHCJFARREARSMANAGE).GetAdmBillAmount(EpisodeId)
	;未结算押金
	s PatDeposit=##class(web.UDHCJFARREARSMANAGE).GetDeposit(EpisodeId)
    ;病人有效担保金额
    s warrantamt=##class(web.UDHCJFARREARSMANAGE).GetWarrAmt(EpisodeId) 
 	s ybinfo="0^0^0^0"	            ;总金额,医保基金支付,个人自付;这里需要调用医保接口
 	s YBJJZF=$p(ybinfo,"^",2)		;医保基金支付.默认0
	s Balance=PatDeposit+warrantamt+YBJJZF-billAmount
	
	i (Balance'<0) d
    .s QFflag=1	 		;未欠费标志
    .s PatQfTotal=0
    e  d
    .s QFflag=2	 		;欠费标志
    .s PatQfTotal=$zabs(Balance)
    	
    q QFflag_"^"_$j(billAmount,3,2)_"^"_$g(JFType)_"^"_$j(billAmount,3,2)_"^"_$j(PatDeposit,"",2)_"^"_$j(PatQfTotal,3,2)
}

/// Creator:			zhougang(zg)
/// CreatDate:		2014.12.18
/// Description:   
/// Input:			输入参数说明:病人就诊的EpisodeId,账单开始,结束时间
/// Output：         输出参数的说明:	总费用,自付费用
ClassMethod UDHCJFGetBillFeeInfo(adm, frmdat, todat)
{
	//w ##Class(web.UDHCJFARREARSMANAGE).UDHCJFGetBillFeeInfo(267,"",+$h)
  	s totalamt=0,PatShare=0
  	s admbill=0 f  s admbill=$o(^DHCPB(0,"ADM",adm,admbill)) q:admbill=""  d
  	.q:admbill=""
  	.q:$p(^DHCPB(admbill),"^",16)="P" 			;过滤已结算账单	
  	.s Amtinfo=$$getBillinfo(admbill,frmdat, todat)
  	.s totalamt=totalamt+$p(Amtinfo,"^",1)
  	.s PatShare=PatShare+$p(Amtinfo,"^",4)
  	
  	q totalamt_"^"_PatShare
  	
getBillinfo(billno,frmdat, todat)
	
	i todat="" s todat=+$h
	i frmdat="" s frmdat=0
	s billno=+$g(billno),frmdat=$g(frmdat),todat=$g(todat)
	s pat=0,totsum=0,discsum=0,patsum=0,payorsum=0 
	s paidflag= $p(^DHCPB(billno),"^",16)   
	f  s pat=$o(^DHCPB(billno,"O",pat)) q:pat=""  d
	.s detailid=0
	.f  s detailid=$o(^DHCPB(billno,"O",pat,"D",detailid)) q:detailid=""  s s=^(detailid) d
	..s totfee=0,discfee=0,patientfee=0,payorfee=0 ,paidfee=""
	..s paidflag=$p(s,"^",14)
	..s totfee=$p(s,"^",7),dat=$p(s,"^",11)
	..s discfee=$p(s,"^",8)
	..s patientfee=$p(s,"^",10)
	..s payorfee=$p(s,"^",9)
	..i dat'>todat,dat'<frmdat  d
	...s totsum=totsum+totfee
	...s discsum=discsum+discfee
	...s patsum=patsum+patientfee
	...s payorsum=payorsum+payorfee 
	...i paidflag="P" s paidfee=paidfee+totfee
	q totsum_"^"_discsum_"^"_payorsum_"^"_patsum
}

// 取死亡患者信息

// w ##class(DtPortal.MD.MD23CommonService).getPatDeadReason(306)

ClassMethod getPatDeadReason(episodeId)
{
	
	n (episodeId)
	q:+episodeId=0 ""
	s ret=""
	s PatId=$P($g(^PAADM(episodeId)),"^",1)
	q:PatId="" ""
	;直接死因
    i $d(^DHCMed.DTHi("REP","IndexPatientID"," "_PatId)) d
    .s reportId=$o(^DHCMed.DTHi("REP","IndexPatientID"," "_PatId,""),-1)
    e  s reportId=""
    s AReason=""
    i reportId'="" s AReason=..GetAReason(reportId)
    
    ;出院诊断
   
    ;s obj=##Class(DtPortal.Doctor.EMRInfoService).GetEMRHDSD0011DiagInfo(episodeId)
    ;i obj.data'="" d
	.;s Disdiag=obj.data.GetAt("HDSD00.11.024")
	;e  s Disdiag=""
	;s Disdiag=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(PAAdm)        //调用统一接口取出院诊断 by ZhaoRX 2016.2.22
	s Disdiag=##class(DtPortal.Common.PaadmService).GetDisDiagnosis(episodeId)        //by cfyc1026  修改bug
	;死亡日期
	s DeceasedDate=$p(^PAPER(PatId,"ALL"),"^",13)
	s DeceasedTime=$p(^PAPER(PatId,"ALL"),"^",8)
    i DeceasedDate'="" s DeceasedDate=$zd(DeceasedDate,3)
    i DeceasedTime'="" s DeceasedTime=$zt(DeceasedTime,2)
    s DeceasedDateTime=DeceasedDate_"&nbsp;"_DeceasedTime
    
    ;死亡小结
    s deadSummary=""
    set deadSummary=##class(DtPortal.Common.PaadmService).getDeadPatSummary(episodeId)
    		
    
    s ret=AReason_"^"_Disdiag_"^"_DeceasedDateTime_"^"_deadSummary
    q ret
}

// 取死亡患者直接死因

ClassMethod GetAReason(RpId) As %String
{
	n (RpId)
 	q:$g(RpId)="" ""
 	q:$g(^DHCMed.DTH("REP",RpId))="" ""
 	s AReason=$List(^DHCMed.DTH("REP",RpId),7)
 	q $g(AReason)
}

/// Creator： bmz
/// CreatDate： 2015-12-11
/// Description: 取该病人的护理级别
/// Input：	episodeId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).getPatNurseLevel(episodeId)
ClassMethod getPatNurseLevel(episodeId) As %String
{
	n (episodeId)
	q:episodeId="" ""
 	s nurseLevelCode="NURSELEVEL" //定义护理级别的串
 	q:nurseLevelCode="" ""
 	i nurseLevelCode'="" 
 	s NurseLevelCode=##class(DtPortal.Configure.arcim).getArcImID(nurseLevelCode,2)
 	s nurseLevel=##class(DtPortal.Common.PaadmService).IfNurseLevelExist(episodeId,NurseLevelCode)
 	q nurseLevel
}

/// Creator： bmz
/// CreatDate： 2017-3-23
/// Description: 判断是否欠费患者
/// Input：	episodeId
/// Return： Y-欠费 N-不欠费
/// Debug：w ##class(DtPortal.MD.MD23CommonService).ifQFPat(episodeId)
ClassMethod ifQFPat(episodeId) As %String
{
	n (episodeId)
	q:episodeId="" ""
	s flag="N"
 	//欠费走Portal公共方法
 	s str=##class(DtPortal.Common.PaadmService).IsArrears(episodeId)
 	//1-表示欠费
 	i ($p(str,"^",1)="1") s flag="Y"
 	q flag
}

/// Creator： 赵丽
/// CreatDate： 2017-10-12
/// Description: 判断患者是否是的护理级别
/// Input：	episodeId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).ifNur("64","1")
ClassMethod ifNur(episodeId As %String = "", type As %String = "") As %String
{
	
	n (episodeId,type)
	s ifNur=0
	s arcimCodes=""  
	if type="1" s arcimCodes=##class(DtPortal.Configure.arcim).getArcImID("FIRSTCLSCARE",2)
		else  if type="2" s arcimCodes=##class(DtPortal.Configure.arcim).getArcImID("SECONDCLSCARE",2)
			else  if type="3" s arcimCodes=##class(DtPortal.Configure.arcim).getArcImID("THIRDCLSCARE",2)
					
	q:arcimCodes="" 0
	s ifNur=##class(DtPortal.Common.PaadmService).IfOrddailyExist(episodeId,arcimCodes)
	
	q ifNur
}

/// Creator： 赵丽
/// CreatDate： 2017-10-12
/// Description: 判断患者是否是急诊转过来的住院患者
/// Input：	episodeId
/// Return：
/// Debug：w ##class(DtPortal.MD.MD23CommonService).ifEmergency("211")
ClassMethod ifEmergency(episodeId As %String = "") As %String
{
	
	n (episodeId)
	s ifEmergency=0
	s RowID=0 f  s RowID=$o(^DHCDocIPBK(0,"EpisodeIDTo",episodeId,RowID)) q:RowID=""  d
   		.s OutAdmId=$p(^DHCDocIPBK(RowID),"^",2)
    	.s PAADMType=$P(^PAADM(OutAdmId),"^",2)
    	.;w PAADMType,!
    	.q:PAADMType'="E"
		.s ifEmergency=1
	q ifEmergency
}

}
