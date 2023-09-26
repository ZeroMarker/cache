Import SQLUser

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
Class web.DHCEMPatientSeat Extends %Persistent [ Not ProcedureBlock ]
{

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// Description:通过科室ID查询病床总数
/// Table：^DHCEMPSE
/// Input：LocName:科室ID
/// Return：病床信息以及病人信息
/// W ##class(web.DHCEMPatientSeat).SelAllBedNew("100")
/// 39^4*4#1-1^1^成人$1-2^2^成人$1-3^3^成人$
/// 返回:
/// W ##class(web.DHCEMPatientSeat).SelAllBedNew("2^39^175^18850")
ClassMethod SelAllBedNew(LgParams, PatRegNo = "", FilterType = "", FilterValue = "")
{
	s LocId=$p(LgParams,"^",2)
	///读取的过程 
	S StrRs="",AllSeat=0,UserSeat=0,InSeatID=""
	s InPatientID = ##class(web.DHCEMPatientSeat).GetPatientID(PatRegNo)
	s:InPatientID'="" InSeatID=##class(web.DHCEMPatientSeat).GetPatSeatID(InPatientID)
	q:+LocId=0 ""
	s SeatSize="",widAndHei=""
	S PatSeatId=0
	F  S PatSeatId=$o(^DHCEMPSE(0,"Loc",LocId,PatSeatId))  Q:PatSeatId=""  D
	.S LocNameDr=$p(^DHCEMPSE(PatSeatId),"^",1)  //主表rowID
	.;Q:LocNameDr'=LocId 
	.S SeatSize=$p(^DHCEMPSE(PatSeatId),"^",3)                //4*4
	.S widAndHei=$p($g(^DHCEMPSE(PatSeatId)),"^",5)_"*"_$p($g(^DHCEMPSE(PatSeatId)),"^",6)
	.S seatItmSub=0 
	.F  S seatItmSub=$o(^DHCEMPSE(PatSeatId,"SE",seatItmSub))  Q:seatItmSub=""  D
	..Q:^DHCEMPSE(PatSeatId,"SE",seatItmSub)=""
	..s patSeatiDr = PatSeatId_"||"_seatItmSub
	..q:(InSeatID'="")&&(InSeatID'=patSeatiDr)
	..S BedData=""
	..S BedData="" ; ##class(web.DHCEmSeatLinkBed).GetBedPatStrBySeat(patSeatiDr)   //BedData
	..S SeatDesc = $p(^DHCEMPSE(PatSeatId,"SE",seatItmSub),"^",1) //1-1
	..S SeatName = $p(^DHCEMPSE(PatSeatId,"SE",seatItmSub),"^",2) //2号床铺
	..S SeatType = $p(^DHCEMPSE(PatSeatId,"SE",seatItmSub),"^",3) //成人、儿童   这里可以设置一个globle标志
	..q:+SeatType=0 												
	..s SeatColor = $p($g(^DHCEMPSC(SeatType)),"^",5)
	..s patSeatiDr = PatSeatId_"||"_seatItmSub
	..s AllSeat=AllSeat+1   //总床数
	..s PatRecDr= $p(^DHCEMPSE(PatSeatId,"SE",seatItmSub),"^",4)
	..s PatData=""
	..i +PatRecDr'="0" d
	...s PatData=##class(web.DHCEMPatientSeat).GetPatBySeatIdNew(patSeatiDr,+LgParams)    //获取在床位上的病人的基本信息
	..s PatNo=$p(PatData,"^",5)
	..s PatName=$p(PatData,"^",2)
	..s PatentID=$p(PatData,"^",4)
	..s PatSex=$p(PatData,"^",8)
	..s PatSexDesc=$p($g(^CT("SEX",+PatSex)),"^",2)
	..s PatSexDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSexDesc) //hxy 2022-12-19
	..
	..q:(FilterType="PatSeat")&&(FilterValue'="")&&((SeatName)'[FilterValue) ;座位
	..q:(FilterType="PatNo")&&(FilterValue'="")&&(PatNo'[FilterValue)
	..q:(FilterType="PatName")&&(FilterValue'="")&&(PatName'[FilterValue)
	..q:(FilterType="PatSex")&&(FilterValue'="")&&(FilterValue'=PatSexDesc)
	..S StrRs=StrRs_"^"_SeatDesc_"^"_SeatName_"^"_SeatColor_"^"_patSeatiDr_"^"_SeatName
	..s:(BedData="")&&(+PatRecDr="0") StrRs=StrRs_"^N$$"
	..i BedData'="" D
	...s:+BedData'="0" StrRs=StrRs_"^YY^"_BedData_"$$"
	...s:+BedData'="0" UserSeat=UserSeat+1
	..i PatName'="" d
	...s SEATORDTIPFORM=##class(web.DHCEMNurExe).GetConfigBySession("SEATORDTIPFORM",LgParams)
	...s:SEATORDTIPFORM="" SEATORDTIPFORM="SYDO"
	...s IsHasSyOrd = ##class(web.DHCEMPatientSeat).IsHasSyOrd(PatentID,LgParams,SEATORDTIPFORM)
	...s StrRs=StrRs_"^Y^"_PatData_"!!"_IsHasSyOrd_"$$"
	...s UserSeat=UserSeat+1
	..i PatName="" d
	...s StrRs=StrRs_"^N$$"
	
	S jsonRs = ##class(web.DHCEMJsonCommon).getJsonData("size@allSeat@useSeat@widAndHei@text",SeatSize_"@"_AllSeat_"@"_UserSeat_"@"_widAndHei_"@"_StrRs,"@")
	Q jsonRs
}

/// Descript:当日是否有位置行输液单
/// Input:ExecForms(不能为空,单据code)
/// W ##class(web.DHCEMPatientSeat).IsHasSyOrd("203")
ClassMethod IsHasSyOrd(PatMasID, LgParams, ExecForms)
{
	
	s Ret=""
	s OrdType = ##class(web.DHCEMNurExe).GetConfigBySession("SEEORDTYPE",LgParams) 
    s:OrdType="" OrdType="OE"
    s ExecFormLen=$l(ExecForms,",")
	s CurDate=+$H
	
	s PatsAdm=##class(web.DHCEMNurExe).getAllAdmStrByRegNo(PatMasID,OrdType,CurDate,CurDate)
	s Num=$l(PatsAdm,"^")
	f i=1:1:Num q:Ret=1  d
	.s AdmId=$p(PatsAdm,"^",i)
	.q:+AdmId=0 
	.s AdmHosp = ##class(web.DHCEMCommonUtil).GetHospitalByAdm(AdmId)
	.q:AdmHosp'=+LgParams
	.s Ord=0
	.f  s Ord=$o(^OEORD(0,"Adm",AdmId,Ord)) q:(Ord="")||(Ret=1)  d
	..s Itm=0
	..f  s Itm=$o(^OEORD(Ord,"I",Itm)) q:(Itm="")||(Ret=1)  d
	...s IsHasOrd=""
	...s Sub=0
	...f  s Sub=$o(^OEORD(Ord,"I",Itm,"X",Sub))  q:(Sub="")||(IsHasOrd=1)  d
	....s OrdSttDate=$p($g(^OEORD(Ord,"I",Itm,"X",Sub)),"^",1)
	....q:OrdSttDate'=+$H
	....f k=1:1:ExecFormLen q:IsHasOrd=1  d
	.....s ExecFormCode=$p(ExecForms,",",k)
	.....s IsThisFormOrd=##class(web.DHCEMPat).IsInThisForm(LgParams,ExecFormCode,Ord,Itm,Sub,"false","true")
	.....s:+IsThisFormOrd IsHasOrd=1
	...q:IsHasOrd'=1
	...s Ret=1
	q Ret
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// Description: 换座位combobox数据获取
/// Table：^DHCEMPSE
/// Input：通过科室ID：Loc
/// Return：json数据
/// w ##class(web.DHCEMPatientSeat).SeatDatasByJson2("67")
ClassMethod SeatDatasByJson2(Loc)
{
	s pid=##Class(web.DHCEMPatCheckLevCom).NewPid()
    D ..killTmpGlobal(pid) //k掉临时global
   	s EPSeatId="0"
	F  S EPSeatId = $o(^DHCEMPSE(EPSeatId))  Q:EPSeatId=""  D
	.S EPSeatLocDr = $p(^DHCEMPSE(EPSeatId),"^",1)
	.Q:EPSeatLocDr'=Loc   
	.S EPSeatISub="0"
	.F  S EPSeatISub =$o(^DHCEMPSE(EPSeatId,"SE",EPSeatISub))  Q:EPSeatISub=""  D
	..s SeatId = EPSeatId_"||"_EPSeatISub
	..S SECode = $p(^DHCEMPSE(EPSeatId,"SE",EPSeatISub),"^",1)   //这是1-1，4-1那个数据
	..S SEDesc = $p(^DHCEMPSE(EPSeatId,"SE",EPSeatISub),"^",2)   //这是1号床铺，2号床铺
	..I +$p(^DHCEMPSE(EPSeatId,"SE",EPSeatISub),"^",4)="0"  D
	...s ^TMP("DHCEM","web.DHCEMPatientSeat","SeatDatasByJson2",pid," "_$$ALPHAUP^SSUTIL4(SEDesc))=SeatId   //为了排序,别忘了用完K掉
  
   	S h=0,count=0      //读取数据
	S SEDesc=""
	F  S SEDesc = $o(^TMP("DHCEM","web.DHCEMPatientSeat","SeatDatasByJson2",pid," "_$$ALPHAUP^SSUTIL4(SEDesc)))  Q:SEDesc=""  D
	.S SeatId=^TMP("DHCEM","web.DHCEMPatientSeat","SeatDatasByJson2",pid," "_$$ALPHAUP^SSUTIL4(SEDesc))
	.Q:+$p(SeatId,"||",1)="0"
	.Q:+$p(SeatId,"||",2)="0"
	.S h=h+1,TempStr = SeatId_"^"_SEDesc   //满足条件必须是没人和新子表有这个字段,数据格式40^2号床铺	
	.S ^TMP("DHCEM","web.DHCEMJsonCommon","TestSelect",pid,h)=TempStr		
	Q:h=0 "[]" //输出json结尾符，如果这个h为0的时候补输出回去，结果回事datagrid显示有误
	
	S Title="id^text"
	W "[" //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCEM","web.DHCEMJsonCommon","TestSelect",pid,index)) Q:index=""  D
	.S mdate=$g(^TMP("DHCEM","web.DHCEMJsonCommon","TestSelect",pid,index))
	.S count = count+1
	.I count=1 D   //有开始值和结束值
	..W ##class(web.DHCEMJsonCommon).getJsonData(Title,mdate)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(Title,mdate) //逗号在这加着呢
	W "]" //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
	Q ""
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// Description:通过科室ID与座位ID取病人基本信息
/// Table：
/// Input：LocID:科室ID,SeatID:座位ID
/// Return：病人就诊ID^病人姓名^卡号^座位号
/// w ##class(web.DHCEMPatientSeat).GetPatBySeatIdNew("1||7","2")
ClassMethod GetPatBySeatIdNew(SeatID As %String, LgHospID = "") As %String
{
	n (SeatID,LgHospID,%session)
	s:$d(%session) LgHospID = %session.Data("LOGON.HOSPID")
	s Data=""
	s RecDr = $p(^DHCEMPSE($p(SeatID,"||",1),"SE",$p(SeatID,"||",2)),"^",4)
	
	s PatRecData = $g(^User.DHCNurSyPatRecD(RecDr))
	s PatAdm=$listget(PatRecData,3)
	
	;错误数据自动清除，就诊错误或者座位信息错误
	i ('$d(^PAADM(+PatAdm))||'$d(^User.DHCNurSyPatRecD(RecDr))) d
	.d ##class(web.DHCEMPatientSeat).ClearSeat(SeatID)
	
	q:('$d(^PAADM(+PatAdm))||'$d(^User.DHCNurSyPatRecD(RecDr))) ""
	
	s SeatId = $lg(PatRecData,5)
	s PatDr = $p(^PAADM(PatAdm),"^",1)
	s NowPaAdm = ##class(web.DHCEMPatientSeat).GetAdmByPatNew(PatDr,LgHospID)      //获取最新的挂号数据
	s AdmAbnormal = ""
	s:+NowPaAdm=0 NowPaAdm=PatAdm,AdmAbnormal="Y"
	s rs=0
	s PatName=$P($g(^PAPER(PatDr,"ALL")),"^",1)					           //病人姓名
	s PatSex = $P($g(^PAPER(PatDr,"ALL")),"^",7)   //病人性别
	s PatSexDesc=$p($g(^CT("SEX",+PatSex)),"^",2)
    s RegNo=$p($g(^PAPER(PatDr,"PAT",1)),"^",2)					           //登记号
    s CardDr=$o(^DHCCARDi("CF",0,"PAPMIDR",PatDr,""),-1)
    s:CardDr="" Cardno=""
    s:CardDr'="" Cardno=$p(^DHCCARD("CF",CardDr),"^",2)
	s PatAge=""
	s PatAge = ##class(web.DHCBillInterface).GetPapmiAge(PatDr,"",LgHospID)
	;##Class(web.DHCEMPatientAge).GetPatAge(PatDr,NowPaAdm)      //病人年龄
	s MRDiagnos=""
	s MRDiagnos = ##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(NowPaAdm,"","","","Y")   //病人诊断
	s PatInDep=""
	s DeplocDr=$p(^PAADM(NowPaAdm),"^",4)
	s PaAdmDate = $p(^PAADM(NowPaAdm),"^",6)
	s PaAdmTime = $p(^PAADM(NowPaAdm),"^",7)
	s BillType=""
	s PAADMAdmReasonDR=$p(^PAADM(NowPaAdm,1),"^",7)
	s:PAADMAdmReasonDR'="" BillType=$p(^PAC("ADMREA",PAADMAdmReasonDR),"^",2)
	s PatInDep=$p(^CTLOC(DeplocDr),"^",2)
	s PatInDep=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",PatInDep) //hxy 2022-12-19
	i PatInDep["-" s PatInDep=$p(PatInDep,"-",2) 						 	//就诊科室
	s PaAdmDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(PaAdmDate)
	s PaAdmTime=$zt(PaAdmTime,2)
	s PaAdmTime=PaAdmDate_" "_PaAdmTime
	s PatEncryptLevel="",EncryptLevel="",PatLevel=""
	s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",NowPaAdm)  
	s EncryptLevel=$p(PatEncryptLevel,"^",1)  							    //病人密级 
    s PatLevel=$p(PatEncryptLevel,"^",2) 									//病人级别
    s CareProvID=##Class(web.DHCEMPatientSeat).GetPrvDoc(NowPaAdm)
    s MainDoc=$p($g(^CTPCP(+CareProvID,1)),"^",2)       /// 主管医生
    s SeatInfo = ##class(web.DHCEMPatientSeat).GetPatSeatInfo(PatDr)
	s UpdDate=$p(SeatInfo,"!!",3)
	s UpdTime=$p(SeatInfo,"!!",4)
	
	s InSeatDateLimit = ##class(web.DHCEMPatientSeat).GetDateLimit(UpdDate,UpdTime)
	s AllergyInfo=##class(web.DHCEMAllergyEnter).GetPatALGDesc(PatDr)
	
	s PatSexDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSexDesc) //hxy 2022-12-19
	s BillType=##class(web.DHCEMCommonUtil).GetTransDesc("User.PACAdmReason","READesc","",BillType)
	s MainDoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",MainDoc) //ed
	s Ret = NowPaAdm_"^"_PatName_"^"_Cardno_"^"_PatDr_"^"_RegNo_"^"_EncryptLevel_"^"_PatLevel_"^"_PatSex_"^"_PatAge_"^"_BillType_"^"_MRDiagnos_"^"_PatInDep_"^"_PaAdmTime_"^"_MainDoc_"^"_InSeatDateLimit
	s Ret = Ret_"^"_AllergyInfo_"^"_AdmAbnormal_"^"_PatSexDesc
	q Ret
}

/// w ##class(web.DHCEMPatientSeat).GetDateLimit("2019-11-11","17:30")
ClassMethod GetDateLimit(StDate, StTime)
{
	n (StDate,StTime)
	q:StDate="" ""
	s MDate = ##class(web.DHCEMCommonUtil).DateHtmlToLogical(StDate)
	s MTime= $zth(StTime)
	s MLimit=(+$h-MDate)*24*60*60+($p($h,",",2)-MTime)
	s MLimitDay=MLimit\(24*60*60)
	q:+MLimitDay>0 MLimitDay_"天"
	s MLimitHour=MLimit\(60*60)
	q:+MLimitHour>0 MLimitHour_"时"
	s MLimitMin=MLimit\(60)
	q:+MLimitMin>0 MLimitMin_"分"
	q "0分"
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
ClassMethod ClearSeat(SeatID As %String)
{
	s b = ##class(User.DHCEmPatSeatItm).%OpenId(SeatID)
	s b.SEPatDescDr =""
	d b.%Save()
	d b.%Close()
	q 0
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// 通过卡号或登记号取病人就诊ID
/// w ##class(web.DHCEMPatientSeat).GetPatInfo("0000001010","")
ClassMethod GetPatInfo(CardNo As %String = "", RegNo As %String = "", CardTypeID = "") As %String
{
	
	//w ##class(web.DHCNurSyComm).GetCurrAdm("000000000123")
	if (CardNo'=""){
		s ind="",cardrow=""
		f  s cardrow=$o(^DHCCARDi("CF",0,"CardNo",CardNo,cardrow),-1) q:(cardrow="")||(ind'="")  d
		.s ThisCardTypeID=$p(^DHCCARD("CF",cardrow),"^",16)
		.q:(CardTypeID'="")&&(CardTypeID'=ThisCardTypeID)
		.s ind=cardrow
		q:+ind="0" "-10"
		q:'$d(^DHCCARD("CF",ind)) "-10"         				//没有卡信息
		q:$p($g(^DHCCARD("CF",ind)),"^",10)'="N" "-11" 		    //卡没有启用
		s PatDr=$p($g(^DHCCARD("CF",ind)),"^",4)                //通过卡号取出病人ID
		q:PatDr="" "-12"                                        //卡未关联病人
		s RegNo=$p($g(^PAPER(PatDr,"PAT",1)),"^",2)            	//登记号 
		q "0"_"^"_CardNo_"^"_RegNo_"^"_PatDr
	}
	else {
		if (RegNo'=""){
			s patConfig=##class(web.DHCCLCom).GetPatConfig()  //系统配置，登记号长度
			s RegNoLong=$p(patConfig,"^")  
			q:$l(RegNo)>RegNoLong "-13"                        //登记号长度错误
			s nvar=""
			s ln=$L(RegNo)
			s le=RegNoLong+1-ln  							  //11-$L(RegNo)
			s $P(nvar,"0",le)=RegNo
			s nvar=$$ALPHAUP^SSUTIL4(nvar)
			s RegNo=nvar
			s PatDr=""
			s PatDr=$O(^PAPERi("PAPMI_PatNo",nvar,PatDr),-1)
			q:+PatDr="0" "-14"								  //未找到病人信息
			s PatName=$P($G(^PAPER(PatDr,"ALL")),"^",1)
			s CardDr=$O(^DHCCARDi("CF",0,"PAPMIDR",PatDr,""),-1)
			s:+CardDr="0" CardNo=""
			s:+CardDr'="0" CardNo=$P($G(^DHCCARD("CF",CardDr)),"^",2)
			q "0"_"^"_CardNo_"^"_RegNo_"^"_PatDr 
		}	
	}
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// 通过卡号或登记号取病人就诊ID
/// w ##class(web.DHCEMPatientSeat).GetCurrAdm("0000900056","0000000483","2")
ClassMethod GetCurrAdm(CardNo As %String = "", RegNo As %String = "", LgHospID = "") As %String
{
	n (CardNo,RegNo,LgHospID,%session)
	q:(CardNo="")&&(RegNo="") ""
	s Ret=""
	s PatientID=""
	i RegNo'="" d
	.s PatConfig=##class(web.DHCCLCom).GetPatConfig()  //系统配置，登记号长度
	.s RegNoLong=$p(PatConfig,"^")  
	.q:$l(RegNo)>PatConfig 
	.s Nvar=""
	.s Ln=$L(RegNo)
	.s Le=RegNoLong+1-Ln  							  //11-$L(RegNo)
	.s $P(Nvar,"0",Le)=RegNo
	.s RegNo=$$ALPHAUP^SSUTIL4(Nvar)
	.s PatientID=$O(^PAPERi("PAPMI_PatNo",RegNo,""),-1)
	i (CardNo'="")&&(PatientID="") d
	.s Ind=$O(^DHCCARDi("CF",0,"CardNo",CardNo,""),-1)
	.q:+Ind="0"
	.q:'$d(^DHCCARD("CF",Ind))
	.q:$p($g(^DHCCARD("CF",Ind)),"^",10)'="N" //卡没有启用
	.s PatientID=$p($g(^DHCCARD("CF",Ind)),"^",4)  //通过卡号取出病人ID
	q:+PatientID=0 ""		///没有改患者信息
	s RegNo = $p(^PAPER(PatientID,"PAT",1),"^",1)  
	
	s EpisodeID=##class(web.DHCEMPatientSeat).GetAdmByPatNew(PatientID,LgHospID) //当前就诊ID
	q:EpisodeID="" ""    ///未查询到患者就诊信息
	s CurrHosp=""
	s PatName=$p($g(^PAPER(PatientID,"ALL")),"^",1)				//病人姓名
	s PAADMDepCodeDR = $p($g(^PAADM(EpisodeID)),"^",4)
	S CurrHosp = $p($g(^CTLOC(PAADMDepCodeDR)),"^",22)
    s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)   //ssss
	s EncryptLevel=$p(PatEncryptLevel,"^",1)  /// 病人密级 
   	s PatLevel=$p(PatEncryptLevel,"^",2) 	    /// 病人级别
   	s PatSex=""
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)                   /// 姓别
	s:SexId'="" PatSex=$p(^CT("SEX",SexId),"^",2)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID)  ///年龄
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 			    /// 就诊科室
	s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) /// 就诊日期
	s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) /// 就诊时间
	s PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s PaAdmDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(PaAdmDate)
	s PaAdmTime=$zt(PaAdmTime,2)
	s PaAdmTime=PaAdmDate_" "_PaAdmTime
	s CardNoID=##Class(web.DHCEMPatCheckLevQuery).GetPatCardNoID(PatientID)  		         /// 病人卡号ID
	s CardNo=$p($g(^DHCCARD("CF",+CardNoID)),"^",2) 		 /// 卡号
	s CardTypeID=$p($g(^DHCCARD("CF",+CardNoID)),"^",16) 	 /// 卡类型
	s SeatInfo = ##class(web.DHCEMPatientSeat).GetPatSeatNo(PatientID)
	s SeatNo=$p(SeatInfo,"!!",2)
	s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
	s PatLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",PatLoc) 
	s Ret=EpisodeID_"^"_CardNo_"^"_RegNo_"^"_PatName_"^"_EncryptLevel       ;1-5
	s Ret =Ret_"^"_PatLevel_"^"_PatientID_"^"_PatSex_"^"_PatAge_"^"_PatLoc  ;6-10
	s Ret =Ret_"^"_PaAdmTime_"^"_CardTypeID_"^"_SeatNo
	q Ret
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// 根据病人的DId取出病人的就诊ID PAADM
/// 优先找急诊病人，当急诊病人没有的时候找门诊
/// w ##class(web.DHCEMPatientSeat).GetAdmByPatId("1")
/// w ##class(web.DHCEMPatientSeat).GetAdmByPatId("313")
ClassMethod GetAdmByPatId(PatId As %String)
{
	q:PatId="" ""
	s adm="",admType=""
	s admType= $O(^PAPERdr(PatId,"ADM",admType),-1)     //这个节点是就诊类型
	q:admType'="E" ""   //E是急诊
	s adm=$O(^PAPERdr(PatId,"ADM",admType,adm),-1)
	q:+adm="" ""										//所有就诊全部取出，最后一次的就诊ID
	s admDate=$P(^PAADM(adm),"^",6)
	q:admDate>+$h ""
	s AdmStatus = $p($g(^PAADM(adm)),"^",20)
	q:AdmStatus'="A" ""
	q adm
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// 根据病人的DId取出病人的就诊ID PAADM
/// 优先找急诊病人
/// w ##class(web.DHCEMPatientSeat).GetAdmByPatId("1")
/// w ##class(web.DHCEMPatientSeat).GetAdmByPatId("313")
ClassMethod getCurrentEpisodeId(PatId As %String)
{
	q:PatId="" ""
	s Adm=""
	s Adm= $O(^PAPERdr(PatId,"ADM","E",Adm),-1)     	//这个节点是就诊类型
	q:+Adm="0" ""										//所有就诊全部取出，最后一次的就诊ID
	s AdmDate=$P(^PAADM(Adm),"^",6)
	q:AdmDate>+$h ""
	s AdmStatus = $p($g(^PAADM(Adm)),"^",20)
	q:AdmStatus'="A" ""
	q Adm
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// w ##class(web.DHCEMPatientSeat).GetAdmByPatNew(18)
ClassMethod GetAdmByPatNew(patientId, LgHospID = "")
{
	
	s oAdm="",eAdm="",oAdmDate="",eAdmDate=""
	s adm="" f  s adm=$O(^PAPERdr(patientId,"ADM","O",adm),-1) q:(adm="")!(oAdm'="")  d
	.s admDate=$P(^PAADM(adm),"^",6)
	.q:admDate>+$h
	.q:$p(^PAADM(adm),"^",20)'="A"
	.s admHosp=##class(web.DHCEMCommonUtil).GetHospitalByAdm(adm)
	.q:(LgHospID'="")&&(LgHospID'=admHosp)
	.s oAdmDate=admDate
	.s oAdm=adm
	
	s adm=""
	f  s adm=$O(^PAPERdr(patientId,"ADM","E",adm),-1) q:(adm="")!(eAdm'="")  d
	.s admDate=$P(^PAADM(adm),"^",6)
	.q:admDate>+$h
	.q:$p(^PAADM(adm),"^",20)'="A"
	.s admHosp=##class(web.DHCEMCommonUtil).GetHospitalByAdm(adm)
	.q:(LgHospID'="")&&(LgHospID'=admHosp)
	.s eAdmDate=admDate
	.s eAdm=adm
	
	q:(oAdmDate>=eAdmDate) oAdm  
	q eAdm
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// 根据病人的DId取出病人的就诊ID PAADM
/// 优先找急诊病人，当急诊病人没有的时候找门诊
/// w ##class(web.DHCEMPatientSeat).GetAdmByPatId("1")
/// w ##class(web.DHCEMPatientSeat).GetAdmByPatId("313")
ClassMethod GetAdmByPatIdNew(PatId As %String)
{
	s Adm=""
	s Adm=$O(^PAPERdr(PatId,"ADM","E",Adm),-1)
	q:+Adm="" ""										//所有就诊全部取出，最后一次的就诊ID
	s AdmDate=$P(^PAADM(Adm),"^",6)
	q:AdmDate>+$h ""
	s AdmStatus = $p($g(^PAADM(Adm)),"^",20)
	q:AdmStatus'="A" ""
	q Adm
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// Description:  这个方法用来:当同一个病人安排两次的时候，将上一个座位标志清空
/// Table：User.DHCNurSyPatRec
/// Input："^"+loc+"^"+CardNo+"^"+curAdm+"^"+id+"^"+session['LOGON.USERID']+"^Y";
/// Return：
/// w ##class(web.DHCEMPatientSeat).save("^103^3^288^1||1^13828^Y^")
ClassMethod save(parr As %String) As %String
{
	n (parr)
	
	s id=$P(parr,"^",1)
	s Loc=$P(parr,"^",2)     //科室ID
	s PatId=$P(parr,"^",3)   //病人ID
	s Adm=$P(parr,"^",4)     //就诊Id
	s SeatId=$P(parr,"^",5)  //床位ID,子表RowId
	s User=$P(parr,"^",6)    //用户ID
	s SFlag=$P(parr,"^",7)   //标志Y表示病人正在这坐着，N表示病人离开了
	s PrvDoc=$P(parr,"^",8)  //主管医生
	s WaitListID=$P(parr,"^",9)
	s FromSeatId=$P(parr,"^",10)
	
	s IsHasPat = ##class(web.DHCEMPatientSeat).GetPatByID(SeatId)
	q:+IsHasPat'=0 "-1"
	
	ts
	b ;err
	//置空其他
	s rs = ##class(web.DHCEMPatientSeat).ClearPatSeatNew(PatId,Loc,User,FromSeatId)   //清空DHCNurSyPatRec,User.DHCEmPatSeatItm
	i rs'=0 tro
	q:rs'=0 rs
	b ;err1
	//插入新的安排床位的记录
	s rs = ##Class(web.DHCEMPatientSeat).AddPatSeat(Loc,PatId,Adm,SeatId,SFlag,User,PrvDoc)
	i rs'=0 tro
	q:rs'=0 rs
	b ;err2
	/// 给病人安排座位时，等候队列移除
	s rs = ##Class(web.DHCEMPatientSeat).RemoveWaitPat(Adm, Loc ,WaitListID)
	i rs'=0 tro
	q:rs'=0 rs
	b ;err3
	tc
	
	q rs
ERROR
	tro
	q "ERROR"
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
ClassMethod AddPatSeat(Loc, PatId, Adm, SeatId, SFlag, User, PrvDoc)
{
	n (Loc, PatId, Adm , SeatId , SFlag , User ,PrvDoc)
	s CurDate=+$h
	s CurTime=$p($h,",",2)
	s Ret=0
	&sql(INSERT INTO DHCNurSyPatRec 
		(SyLoc,SyPatId,SyPatEpisode,SySeatDr,SyPatStatus,
		SyUpdateDate,SyUpdateTime,SyUpdateUser,SyDocDr)
		VALUES(:Loc,:PatId,:Adm,:SeatId,:SFlag,:CurDate,:CurTime,:User,:PrvDoc))
	s Ret=SQLCODE
	q:Ret'=0 Ret
	s PatDescID = %ROWID
  	&sql(UPDATE DHC_EmPatSeatItm SET SE_PatDesc_Dr=:PatDescID WHERE SE_RowID=:SeatId)
    s Ret=SQLCODE
	q Ret
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// 清空座位标志(两张表)
/// w ##class(web.DHCEMPatientSeat).ClearPatSeat(3774,213,11843)
ClassMethod ClearPatSeat(adm, loc, user) As %String
{
	n (adm, loc , user)
	s PatientID=$p(^PAADM(adm),"^",1)
	q ##class(web.DHCEMPatientSeat).ClearPatSeatNew(PatientID,loc,user)
}

/// Creator：      qiaoqingao
/// CreatDate：    2019-07-05
/// 清空座位标志(两张表)
/// w ##class(web.DHCEMPatientSeat).ClearPatSeatNew(2251,213,11843)
ClassMethod ClearPatSeatNew(PatientID, Loc, User, FromSeatId = "") As %String
{
	n (PatientID, Loc , User,FromSeatId)
	
	
	s Rs=0
	s CurDate=+$H
	s CurTime=$p($H,",",2)
	
	i FromSeatId'="" d
	.&sql(UPDATE DHC_EmPatSeatItm SET SE_PatDesc_Dr=NULL WHERE SE_RowID=:FromSeatId)
	.s Rs=SQLCODE
	.q:Rs'=0
	.s RecRowId = $p(^DHCEMPSE(+FromSeatId,"SE",+$p(FromSeatId,"||",2)),"^",4)
	.q:+RecRowId=0
	.&sql(UPDATE DHCNurSyPatRec SET SyLeavDate=:CurDate,SyLeavTime=:CurTime,
			SyPatStatus="N",SyUpdateUser=:User WHERE ID=:RecRowId)
	.s Rs=SQLCODE
	q:Rs'=0 Rs
	
    s PatRecID="" 
    f  s PatRecID=$O(^User.DHCNurSyPatRecI("sypatid"," "_Loc," "_PatientID," Y",PatRecID)) q:PatRecID=""  d
	.s Stat=$listget(^User.DHCNurSyPatRecD(PatRecID),9)
	.s SeatID=$listget(^User.DHCNurSyPatRecD(PatRecID),5)
	.s SEId= ##class(web.DHCEMPatientSeat).GetSeatItmID(PatRecID)
	.i SEId'="" d
	..&sql(UPDATE DHC_EmPatSeatItm SET SE_PatDesc_Dr=NULL WHERE SE_RowID=:SEId)
	..s Rs=SQLCODE
	.q:Rs'=0
	.q:Stat'="Y"
	.&sql(UPDATE DHCNurSyPatRec SET SyLeavDate=:CurDate,SyLeavTime=:CurTime,
			SyPatStatus="N",SyUpdateUser=:User WHERE ID=:PatRecID)
	.s Rs=SQLCODE
	.
	
	
	q Rs
}

/// Descipt:通过PatRecID找与之匹配的SeatItm的ID
ClassMethod GetSeatItmID(PatRecID)
{
	n (PatRecID)
	s ID = $o(^DHCEMPSE(0,"NurPatRec",PatRecID,""))
	q:ID="" ""
	s Sub = $o(^DHCEMPSE(0,"NurPatRec",PatRecID,ID,""))
	q ID_"||"_Sub
}

// w ##class(web.DHCEMPatientSeat).GetPatByID("97||2")

ClassMethod GetPatByID(SeatID As %String)
{
	s SeatData=^DHCEMPSE($p(SeatID,"||",1),"SE",$p(SeatID,"||",2))
	q $p(SeatData,"^",4)
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// 通过就诊ID查找输液室病人床号
/// w ##class(web.DHCEMPatientSeat).GetBedDescByEpisodeID("435")
/// 通过就诊ID查找输液室病人床号
ClassMethod GetBedDescByEpisodeID(loc, adm)
{
	S PatSeat=""
	Q:adm="" PatSeat
	s PatRecId=$o(^User.DHCNurSyPatRecI("patseat"," "_loc," "_adm,""),-1)
	s PatFlag=""
	s:PatRecId'="" PatFlag = $lg(^User.DHCNurSyPatRecD(PatRecId),9) 
	I PatFlag="Y" D
	.S SeatId = $lg(^User.DHCNurSyPatRecD(PatRecId),5)
	.s PatSeat=$p(^DHCEMPSE($p(SeatId,"||",1),"SE",$p(SeatId,"||",2)),"^",2) //_"号"
	I PatSeat="" D
	.s bedInfo = ##class(web.DHCEMPatientSeat).GetPatSeatNo("",adm)  ///输液室座位
    .s patSeatNo=$p(bedInfo,"!!",2)
    .s:patSeatNo'="" PatSeat=patSeatNo //_"号"
	I PatSeat="" D
	.s beddr=$p(^PAADM(adm),"^",73)
  	.s:beddr'="" PatSeat=$p(^PAWARD(+beddr,"BED",$p(beddr,"||",2)),"^",1) //_"号"
	Q PatSeat
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// 通过就诊ID查找输液室病人床号
/// w ##class(web.DHCEMPatientSeat).GetBedDescByEpisodeIDNew("50000284")
/// 通过就诊ID查找输液室病人床号
ClassMethod GetBedDescByEpisodeIDNew(adm)
{
	n (adm)
	S PatSeat=""
	Q:adm="" PatSeat
	s admStr = ##class(web.MyInterfaceMethod).GetAdmStrByPatID($p(^PAADM(adm),"^",1),"","","")
	s len = $l(admStr,"^")
	f i=1:1:len d
	.s adm = $p(admStr,"^",i)	
	.s loc=""
	.f  s loc = $o(^User.DHCNurSyPatRecI("patseat",loc)) q:(loc="")!(PatSeat'="")  d
	..q:$d(^User.DHCNurSyPatRecI("patseat",loc," "_adm))=0
	..s PatRecId=$o(^User.DHCNurSyPatRecI("patseat",loc," "_adm,""),-1)
	..s PatFlag=""
	..s:PatRecId'="" PatFlag = $lg(^User.DHCNurSyPatRecD(PatRecId),9) 
	..q:PatFlag'="Y" 
	..S SeatId = $lg(^User.DHCNurSyPatRecD(PatRecId),5)
	..s PatSeat=$p(^DHCEMPSE($p(SeatId,"||",1),"SE",$p(SeatId,"||",2)),"^",2)_"号"
	Q PatSeat
}

/// Creator：      qiaoqingao
/// CreatDate：    2016-07-20
/// 修改输液室床位状态
ClassMethod UpdateOldTabFlag(SeatId)
{
	Q:SeatId="" ""
	S a = $g(^User.DHCNurSySeatD(SeatId))
	q:a="" 0
	Q:$lg(a,7)="N" 0 
	I ($lg(a,7)="Y"){
		S ^User.DHCNurSySeatD(SeatId)=$lb($lg(a,1),$lg(a,2),$lg(a,3),$lg(a,4),$lg(a,5),$lg(a,6),"N")
	}
	Q 0
}

// W ##CLASS(web.DHCEMPatientSeat).getRegNoByCarNo()

ClassMethod getRegNoByCarNo(cardNo)
{
	Q:cardNo=""
	S cardRefId=""
	F  S cardRefId=$O(^DHCCARDi("CF",0,"CardNo",cardNo,cardRefId),-1)  Q:cardRefId=""  D
	.S regNo = $p(^DHCCARD("CF",cardRefId),"^",6)
	Q:regNo=""
	Q regNo
}

// W ##CLASS(web.DHCEMPatientSeat).getGlasgow()

ClassMethod getGlasgow()
{
	S gcsId="0"
	F  S gcsId=$o(^DHCEMGCS(gcsId)) Q:gcsId=""  d
	.Q:$p(^DHCEMGCS(gcsId),"^",3)'="Y"
	.w $p(^DHCEMGCS(gcsId),"^",2)
}

/// Description:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCEM","web.DHCEMPatientSeat","SeatDatasByJson2",pid)
}

ClassMethod GetPatMes(carNo, regNo)
{
	Q:carNo=""||regNo=""
	i (regNo'=""){
		
	}
}

/// w ##class(web.DHCEMPatientSeat).GetEmAISData(LgHospID)
ClassMethod GetEmAISData(LgHospID As %String)
{
	 s AISRowId ="0",AISdataStr=""
  f  s AISRowId= $o(^DHCEMAIS(AISRowId)) Q:AISRowId=""  d
  .Q:$p(^DHCEMAIS(AISRowId),"^",3)'="Y"
  .Q:$p(^DHCEMAIS(AISRowId),"^",4)'=LgHospID
  .s AISdataStr=AISdataStr_$p(^DHCEMAIS(AISRowId),"^",2)_"#"
  .s AISRowSubId="0"
  .f  s AISRowSubId=$o(^DHCEMAIS(AISRowId,AISRowSubId))  q:AISRowSubId=""  d
	..s AISSubId=AISRowId_"||"_AISRowSubId
	..Q:$p(^DHCEMAIS(AISRowId,AISRowSubId),"^",6)'="Y"
	..s AISName=$p(^DHCEMAIS(AISRowId,AISRowSubId),"^",3)
	..s AISSc=$p(^DHCEMAIS(AISRowId,AISRowSubId),"^",5)
	..s AISdataStr=AISdataStr_AISSubId_"^"_AISName_"^"_AISSc_"$"
	.s AISdataStr=$e(AISdataStr,1,$l(AISdataStr)-1)
	.s AISdataStr=AISdataStr_"!"
	s AISdataStr=$e(AISdataStr,1,$l(AISdataStr)-1)
	Q AISdataStr
}

/// 格拉斯哥昏迷
/// w ##class(web.DHCEMPatientSeat).selAllData(2)
ClassMethod selAllData(LgHospID As %String)
{
	
	S gcsId="0",dataStr=""
	F  S gcsId=$o(^DHCEMGCS(gcsId)) Q:gcsId=""  d
	.Q:$p(^DHCEMGCS(gcsId),"^",3)'="Y"
	.Q:$p(^DHCEMGCS(gcsId),"^",4)'=LgHospID
	.s dataStr=dataStr_$p(^DHCEMGCS(gcsId),"^",2)_"#"
	.s gcsiSub="0"
	.f  s gcsiSub=$o(^DHCEMGCS(gcsId,"I",gcsiSub))  q:gcsiSub=""  d
	..s gcsiId=gcsId_"||"_gcsiSub
	..Q:$p(^DHCEMGCS(gcsId,"I",gcsiSub),"^",6)'="Y"
	..s GlasgowName=$p(^DHCEMGCS(gcsId,"I",gcsiSub),"^",4)
	..s GlasgowSc=$p(^DHCEMGCS(gcsId,"I",gcsiSub),"^",5)
	..s dataStr=dataStr_gcsiId_"^"_GlasgowName_"^"_GlasgowSc_"$"
	.s dataStr=$e(dataStr,1,$l(dataStr)-1)
	.s dataStr=dataStr_"!"
	s dataStr=$e(dataStr,1,$l(dataStr)-1)
	Q dataStr
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-19
/// Descritp:   插入等候区
/// InPut：     EpisodeID - 就诊ID，LgLocID - 当前科室ID，LgUserID - 当前用户ID
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMPatientSeat).InsPatWaitArea("")
ClassMethod InsPatWaitArea(EpisodeID As %String, LgLocID As %String, LgUserID As %String) As %String
{
	n (EpisodeID, LgLocID, LgUserID)
	s Err=0
	TS
	/// 置空其他
	s Err = ..ClearPatSeat(EpisodeID,LgLocID,LgUserID)
	i Err'=0 tro
	Q:Err'=0 Err
	
	/// 插入等候区
	s Err = ..InsWaitArea(EpisodeID, LgLocID)
	i Err'=0 tro
	Q:Err'=0 Err
	
	TC
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-19
/// Descritp:   插入等候区
/// InPut：     EpisodeID - 就诊ID，LgLocID - 当前科室ID
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMPatientSeat).InsWaitArea("")
ClassMethod InsWaitArea(EpisodeID As %String, LgLocID As %String) As %String
{
	n (EpisodeID, LgLocID)
	Q:..GetPatWaitID(EpisodeID, LgLocID) "-1"
	s State="W"
	s CreateDate=+$H   		     /// 日期
	s CreateTime=$p($H,",",2)    /// 时间
	&SQL(Insert Into DHC_EmPatWaitArea(EM_Adm_Dr,EM_Loc_Dr,EM_Date,EM_Time,EM_State)
		values(:EpisodeID,:LgLocID,:CreateDate,:CreateTime,:State))
	Q SQLCODE
}

ClassMethod RemoveWaitArea(ID) As %String
{
	n (ID)
	&SQL(DELETE DHC_EmPatWaitArea WHERE EC_RowID=:ID)
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-19
/// Descritp:   取病人等候队列ID
/// InPut：     EpisodeID - 就诊ID，LgLocID - 当前科室ID
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMPatientSeat).GetPatWaitID("7","612")
ClassMethod GetPatWaitID(EpisodeID As %String, LgLocID As %String) As %String
{
	n (EpisodeID, LgLocID)
	q:+EpisodeID=0 ""
	q:'$d(^PAADM(EpisodeID)) ""
	
	s InPatientID=$p(^PAADM(EpisodeID),"^",1)
	s ID="", TmpID=""
	F  s ID=$o(^DHCEMPWA(0,"Loc",LgLocID,"W",ID)) Q:(ID="")||(TmpID'="")  D
	.s Adm=$p(^DHCEMPWA(ID),"^",1)
	.q:'$d(^PAADM(Adm))
	.s PatientID=$p(^PAADM(Adm),"^",1)
	.Q:InPatientID'=PatientID     ///病人ID
	.s TmpID=ID
	.
	Q TmpID
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-19
/// Descritp:   修改病人等候区状态
/// InPut：     ID - 等候区ID
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMPatientSeat).UpdWaitAreaFlag("")
ClassMethod UpdWaitAreaFlag(ID As %String) As %String
{
	n (ID)
	s State="A"
	&SQL(update DHC_EmPatWaitArea set EM_State=:State where EC_RowID=:ID)
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-19
/// Descritp:   给病人安排座位时，等候队列移除
/// InPut：     EpisodeID - 就诊ID，LgLocID - 当前科室ID
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMPatientSeat).RemoveWaitPat("")
ClassMethod RemoveWaitPat(EpisodeID As %String, LgLocID As %String, WaitListID = "") As %String
{
	n (EpisodeID, LgLocID ,WaitListID)
	/// 取病人等候队列ID
	s:WaitListID="" ID=..GetPatWaitID(EpisodeID, LgLocID)
	s:WaitListID'="" ID=WaitListID
	Q:ID="" "0"
	/// 修改病人等候区状态
	s Err=..UpdWaitAreaFlag(ID)
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-19
/// Descritp:   修改病人等候区状态
/// InPut：     ID - 等候区ID
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMPatientSeat).JsLocPatWaitArea(999,1,"2^71^175^13806","")
ClassMethod JsLocPatWaitArea(rows As %String = 999, page As %String = 1, LgParams As %String, TmpPatNo As %String, FilterType = "", FilterValue = "") As %String
{
	n (rows, page, LgParams, TmpPatNo,FilterType,FilterValue,%session)
	
	s End = page*rows
	s Start=(page-1)*rows+1
	s LgLocID=$p(LgParams,"^",2)
    	s Count=0
	s ID=""
	F  s ID=$o(^DHCEMPWA(0,"Loc",LgLocID,"W",ID)) Q:ID=""  D
	.Q:$p(^DHCEMPWA(ID),"^",6)'="W"           /// 申请状态
	.s EpisodeID=$p(^DHCEMPWA(ID),"^",1)      /// 就诊ID
	./// 病人信息
	.s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)    /// 病人ID
	.q:+PatientID=0
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	.Q:(TmpPatNo'="")&(TmpPatNo'=PatNo)&(PatName'[TmpPatNo)
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	.s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	.s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	.q:(FilterType="PatNo")&&(FilterValue'="")&&(PatNo'[FilterValue)
	.q:(FilterType="PatName")&&(FilterValue'="")&&(PatName'[FilterValue)
	.q:(FilterType="PatSex")&&(FilterValue'="")&&(FilterValue'=PatSex)
	.q:(FilterType="PatSeat")&&(FilterValue'="")
	.s SEATORDTIPFORM=##class(web.DHCEMNurExe).GetConfigBySession("SEATORDTIPFORM",LgParams)
	.s:SEATORDTIPFORM="" SEATORDTIPFORM="SYDO"
	.s IsHasSyOrd = ##class(web.DHCEMPatientSeat).IsHasSyOrd(PatientID,LgParams,SEATORDTIPFORM)
	.s Count=Count+1
	.s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex) //hxy 2022-12-19
	.s BillType=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSocialStatus","SSDesc","",BillType) //hxy 2022-12-19
	.s ListData=ID_"^"_PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_BillType_"^"_IsHasSyOrd
	.s TMPListData(Count)=ListData
	.
	
	i Count=0 w ##class(web.DHCEMJsonCommon).getJsonEmptySign(0) //输出json结尾符
	Q:Count=0 ""
	
	///转换数据为Json格式
	s ListTitle="ID^PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^BillType^IsHasSyOrd"

	W ##class(web.DHCEMJsonCommon).getJsonStartSign(Count) //输出json前缀串
	s Index=""
	F  s Index=$o(TMPListData(Index)) Q:Index=""  D
	.s ListData=$g(TMPListData(Index))
	.Q:ListData=""
	.Q:(Index<Start)||(Index>End)
	.i Index=Start D
	..W ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-19
/// Descritp:   根据就诊ID获取病人信息
/// InPut：     EpisodeID - 就诊ID
/// OutPut：    病人信息
/// w ##class(web.DHCEMPatientSeat).GetPatEssInfo("49")
ClassMethod GetPatEssInfo(EpisodeID As %String) As %String
{
	n (EpisodeID,%session)
	q:+EpisodeID=0 "{}"
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)     /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)       /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) ///年龄
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 			    /// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
    s CardDr=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
    s:CardDr="" Cardno=""
    s:CardDr'="" Cardno=$p(^DHCCARD("CF",CardDr),"^",2) /// 卡号
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) /// 年龄
	s MRDiagnos=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)     /// 病人诊断
	s PaAdmDate = $p(^PAADM(EpisodeID),"^",6) /// 就诊日期
	s PaAdmTime = $p(^PAADM(EpisodeID),"^",7) /// 就诊时间
	s PaAdmDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(PaAdmDate)
	s PaAdmTime=$zt(PaAdmTime,2)
	s PaAdmTime=PaAdmDate_" "_PaAdmTime
	
	//s PatCardDr=$o(^DHCCARDi("CF",0,"PAPMIDR",PatientID,""),-1)
	//s:+PatCardDr'="0" PatCardNo=$P($G(^DHCCARD("CF",PatCardDr)),"^",2)
	s CardNoID=##Class(web.DHCEMPatCheckLevQuery).GetPatCardNoID(PatientID)  		         /// 病人卡号ID
	s PatCardNo="",CardTypeID="",PatCardType=""
	i CardNoID'="" D
	.s PatCardNo=$p($g(^DHCCARD("CF",CardNoID)),"^",2) 		 /// 卡号
	.s CardTypeID=$p($g(^DHCCARD("CF",CardNoID)),"^",16) 	 /// 卡类型
	.s:CardTypeID'="" PatCardType=$p($g(^DHCCARDTYPEDef(CardTypeID)),"^",2)
	s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,"")
 	s EncryptLevel=$p(EncryptLevelInfo,"^",1)  /// 病人密级 
 	s PatLevel=$p(EncryptLevelInfo,"^",2)	   /// 病人级别
 	s PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex) //hxy 2022-12-19 st
 	s PatLoc=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",PatLoc) //ed 
	s ListData=PatientID_"^"_EpisodeID_"^"_$g(PatCardNo)_"^"_PatNo_"^"_PatName_"^"_PatAge_"^"_PatSex_"^"_EncryptLevel_"^"_PatLevel_"^"_PaAdmTime_"^"_PatLoc_"^"_CardTypeID_"^"_PatCardType
	s ListTitle="PatientID^EpisodeID^PatCardNo^PatNo^PatName^PatAge^PatSex^PatSLv^PatLv^PaAdmTime^PatLoc^CardTypeID^CardTypeNew"
	w ##class(web.DHCEMJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// Creator：      yangyongyao
/// CreatDate：    2019-04-26
/// Description: 主管医生combobox数据获取
/// Table：DHCNurSyPatRec
/// Input：就诊ID
/// Return：主管医生ID
/// w ##class(web.DHCEMPatientSeat).GetPrvDoc("1300")
ClassMethod GetPrvDoc(EpisodeID = "")
{
     q:EpisodeID="" ""
     s PatientID=+^PAADM(EpisodeID)
     q ##class(web.DHCEMPatientSeat).GetPrvDocNew(PatientID)
     s PrvDoc=""
     S RecDr=""
     F  S RecDr=$o(^User.DHCNurSyPatRecI("epiPatSeat"," "_EpisodeID,RecDr)) Q:RecDr=""  D
	 .s PatRecData = $g(^User.DHCNurSyPatRecD(RecDr))
	 .s SyPatEpisode=$LISTGET(PatRecData,3)
	 .s RecStatus=$LISTGET(PatRecData,9)
	 .q:RecStatus'="Y" 
	 .q:(EpisodeID'="")&&(SyPatEpisode'=EpisodeID)
	 .s PrvDoc=$LISTGET(PatRecData,12)
	 q PrvDoc
}

ClassMethod GetPrvDocNew(PatientID)
{
	s PrvDoc=""
	s RecDr=0
	f  s RecDr=$o(^User.DHCNurSyPatRecI("patient"," "_PatientID," Y",RecDr)) q:RecDr=""  d
	.s PatRecData = $g(^User.DHCNurSyPatRecD(RecDr))
	.s PrvDoc=$LISTGET(PatRecData,12)
	q PrvDoc
}

/// Creator：      yangyongyao
/// CreatDate：    2019-04-26
/// Description:   主管医生combobox数据获取
/// Table：        DHCNurSyPatRec
/// Input：        座位号 SeatItm
/// Return：      主管医生ID
/// w ##class(web.DHCEMPatientSeat).GetPrvDoc("55||8")
ClassMethod GetPrvDocbak(SeatItm = "")
{
	N (SeatItm)
	q:(SeatItm="") ""
	s RecDr= $p(^DHCEMPSE(+SeatItm,"SE",$p(SeatItm,"||",2)),"^",4)
	q:RecDr="" ""
	s PatRecData = $g(^User.DHCNurSyPatRecD(RecDr))
	s RecStatus=$LISTGET(PatRecData,9)
	q:RecStatus'="Y" ""
	s PrvDoc=$LISTGET(PatRecData,12) 
	q PrvDoc
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-19
/// Descritp:   修改病人等候区状态
/// InPut：     ID - 等候区ID
/// OutPut：    0-成功; 其他-不成功
/// W ##Class(web.DHCEMPatientSeat).UpdPrvDoc("39","1616","1260")
ClassMethod UpdPrvDoc(Loc, EpisodeID, ChargDoc) As %String
{
	n (Loc,EpisodeID,ChargDoc)
	q:EpisodeID="" ""
	s PatientID = $p(^PAADM(EpisodeID),"^",1)
    s PatRecID="" 
    f  s PatRecID=$O(^User.DHCNurSyPatRecI("sypatid"," "_Loc," "_PatientID," Y",PatRecID)) q:PatRecID=""  d
	.&SQL(UPDATE DHCNurSyPatRec set SyDocDr=:ChargDoc where ID=:PatRecID)
	Q SQLCODE
}

/// Creator:    yangyongtao
/// CreateDate: 2019-04-25
/// Descritp:   通过座位ID获取病人信息
/// InPut：     SeatItm 座位ID
/// OutPut：    病人信息 
/// Table:      DHC_EmPatSeatItm,DHCNurSyPatRec
/// w ##class(web.DHCEMPatientSeat).GetSeatInfo("55||1")
ClassMethod GetSeatInfo(SeatItm As %String = "")
{
	N (SeatItm)
	q:(SeatItm="")||(SeatItm'["||") ""
	S RecDr=""
	s RecDr=$p(^DHCEMPSE(+SeatItm,"SE",$p(SeatItm,"||",2)),"^",4)
	q:RecDr="" ""
	s PatRecData = $g(^User.DHCNurSyPatRecD(RecDr))
	q:PatRecData="" ""
	s PatAdm=$LISTGET(PatRecData,3)
	s PatientID=$LISTGET(PatRecData,4)
	s RecDate=$LISTGET(PatRecData,6)
	S:RecDate'="" RecDate=$zd(RecDate,3)
	s RecTime=$LISTGET(PatRecData,7)
	S:RecTime'="" RecTime=$zt(RecTime,1)
	s RecStatus=$LISTGET(PatRecData,9)
	s RecDoc=""
	;s RecDoc=$LISTGET(PatRecData,12) 
	;S:RecDoc'="" RecDoc=$p(^SSU("SSUSR",RecDoc),"^",2) ;主管医生
	q:RecStatus'="Y" ""
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)     /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)     /// 登记号
	q PatName_"^"_PatNo_"^"_RecDate_"^"_RecTime_"^"_RecDoc
}

/// Descript:通过病人ID或者就诊ID获取床位描述
/// w ##class(web.DHCEMPatientSeat).GetPatSeatNo(275)
ClassMethod GetPatSeatNo(PatientID = "", AdmID = "")
{
	n (PatientID,AdmID)
	s SeatNo="",SeatID=""
	s:AdmID'="" PatientID=$p($g(^PAADM(AdmID)),"^",1)
	q:+PatientID=0 ""
	s Loc=""
	f  s Loc=$o(^User.DHCNurSyPatRecI("sypatid",Loc)) q:(Loc="")||(SeatNo'="")  d
	.s PatRecID="" 
    .f  s PatRecID=$O(^User.DHCNurSyPatRecI("sypatid",Loc," "_PatientID," Y",PatRecID)) q:(PatRecID="")||(SeatNo'="")  d
	..s PatSeatID=$o(^DHCEMPSE(0,"NurPatRec",PatRecID,""))
	..q:+PatSeatID=0
	..s PatSeatSub=$o(^DHCEMPSE(0,"NurPatRec",PatRecID,PatSeatID,""))
	..q:+PatSeatSub=0
	..s SeatID=PatSeatID_"||"_PatSeatSub
	..s SeatNo=$p($g(^DHCEMPSE(PatSeatID,"SE",PatSeatSub)),"^",2)
	q SeatID_"!!"_SeatNo
}

/// w ##class(web.DHCEMPatientSeat).GetPatSeatID()
ClassMethod GetPatSeatID(PatientID = "", AdmID = "")
{
	n (PatientID,AdmID)
	s SeatInfo = ##class(web.DHCEMPatientSeat).GetPatSeatNo(PatientID)
	s SeatID=$p(SeatInfo,"!!",1)
	q SeatID
}

/// Descript:通过病人ID或者就诊ID获取床位信息
/// w ##class(web.DHCEMPatientSeat).GetPatSeatInfo("",1524)
ClassMethod GetPatSeatInfo(PatientID = "", AdmID = "")
{
	n (PatientID,AdmID)
	s SeatNo="",SeatID="",UpdDate="",UpdTime="",LocDesc=""
	s:AdmID'="" PatientID=$p($g(^PAADM(AdmID)),"^",1)
	q:+PatientID=0 ""
	s Loc=""
	f  s Loc=$o(^User.DHCNurSyPatRecI("sypatid",Loc)) q:(Loc="")||(SeatNo'="")  d
	.s PatRecID="" 
    .f  s PatRecID=$O(^User.DHCNurSyPatRecI("sypatid",Loc," "_PatientID," Y",PatRecID)) q:(PatRecID="")||(SeatNo'="")  d
	..s PatSeatID=$o(^DHCEMPSE(0,"NurPatRec",PatRecID,""))
	..q:+PatSeatID=0
	..s PatSeatSub=$o(^DHCEMPSE(0,"NurPatRec",PatRecID,PatSeatID,""))
	..q:+PatSeatSub=0
	..s UpdDate=$lg(^User.DHCNurSyPatRecD(PatRecID),6)
	..s UpdTime=$lg(^User.DHCNurSyPatRecD(PatRecID),7)
	..s LocID=$lg(^User.DHCNurSyPatRecD(PatRecID),2)
	..s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	..s:UpdDate'="" UpdDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(UpdDate)
	..s:UpdTime'="" UpdTime=$zt(UpdTime,2)
	..s SeatID=PatSeatID_"||"_PatSeatSub
	..s SeatNo=$p($g(^DHCEMPSE(PatSeatID,"SE",PatSeatSub)),"^",2)
	q SeatID_"!!"_SeatNo_"!!"_UpdDate_"!!"_UpdTime_"!!"_LocDesc
}

/// w ##class(web.DHCEMPatientSeat).GetPrintSeatCard(20)
ClassMethod GetPrintSeatCard(PatientID = "", AdmID = "", HospID = "")
{
	n (PatientID,AdmID,HospID)
	s:AdmID'="" PatientID=$p($g(^PAADM(AdmID)),"^",1)
	s Hosp=""
	s:HospID'="" Hosp=$p(^CT("HOSP",HospID),"^",2)
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	s PatSex=""
	i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)  /// 出生日期
	i PatBDay'="" s PatBDay=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(PatBDay) //hxy 2017-03-03 $zd(PatBDay,3)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(AdmID) /// 年龄
	s SeatInfo = ##class(web.DHCEMPatientSeat).GetPatSeatInfo(PatientID)
	s SeatID=$p(SeatInfo,"!!",1)
	s SeatNo=$p(SeatInfo,"!!",2)
	s UpdDate=$p(SeatInfo,"!!",3)
	s UpdTime=$p(SeatInfo,"!!",4)
	s Loc=$p(SeatInfo,"!!",5)
	s Title="PatName^PatNo^PatSex^PatBDay^PatAge^SeatID^SeatNo^UpdDate^UpdTime^Loc^Hosp"
	s Data=PatName_"^"_PatNo_"^"_PatSex_"^"_PatBDay_"^"_PatAge_"^"_SeatID_"^"_SeatNo_"^"_UpdDate_"^"_UpdTime
	s Data=Data_"^"_Loc_"^"_Hosp
	w ##class(web.DHCEMJsonCommon).getJsonData(Title,Data)
	q ""
}

/// w ##class(web.DHCEMPatientSeat).GetPatientID("0000001024")
ClassMethod GetPatientID(RegNo)
{
	n (RegNo)
	q:RegNo="" ""
	s PatConfig=##class(web.DHCCLCom).GetPatConfig()  //系统配置，登记号长度
	s RegNoLong=$p(PatConfig,"^")  
	q:$l(RegNo)>RegNoLong ""                        //登记号长度错误
	s Nvar=""
	s Ln=$L(RegNo)
	s Le=RegNoLong+1-Ln  							  //11-$L(RegNo)
	s $P(Nvar,"0",Le)=RegNo
	s Nvar=$$ALPHAUP^SSUTIL4(Nvar)
	s RegNo=Nvar
	s PatientID=$O(^PAPERi("PAPMI_PatNo",Nvar,""),-1)	
	q PatientID
}

/// Creator：      hxy
/// CreatDate：    2022-06-07
/// Description:： 分页显示输液记录
/// Table：        DHC_EmPatHistory
/// Input：	      page：当前页数，rows：每页条数，Params   
/// d ##class(web.DHCEMPatientSeat).ListTrans(1,20,"2022-05-01^2022-06-08^^^49^39^1^1^2")
/// d ##class(web.DHCEMPatientSeat).ListTrans(1,20,"2022-05-01^2022-06-08^^^49^^1^1^2")
ClassMethod ListTrans(page = 1, rows = 10, Params)
{
	n (page,rows,Params,%session)
    s start=(page-1)*rows+1
    s end=page*rows
    
    s StartDate=$p(Params,"^",1)
    s EndDate=$p(Params,"^",2)
    s StartTime=$p(Params,"^",3)
    s EndTime=$p(Params,"^",4)
    s CTLOCID=$p(Params,"^",5)
    s OrdDep=$p(Params,"^",6)
    s OPCheck=$p(Params,"^",7)
    s EMCheck=$p(Params,"^",8)
    s LgHospID=$p(Params,"^",9)
    i (OPCheck="")&&(EMCheck="") W ##Class(web.DHCAPPJsonCommon).getJsonEmptySign(0) //输出json结尾符
	Q:(OPCheck="")&&(EMCheck="") ""

    i StartDate'="" s StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
 	i StartDate="" s StartDate=+$h
 	i EndDate'="" s EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i EndDate=""  s EndDate=+$h
	s:StartTime'="" StartTime=$zth(StartTime,2)
	s:EndTime'="" EndTime=$zth(EndTime,2)
	i StartTime="" s StartTime="0"
	i EndTime=""  s EndTime="86340"
	
	s LgHospID = ##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmExecFormSet",LgHospID)
	s ExecFormID=..getNurExecFormName("SYDO",LgHospID)
	
    s count=0
    s jsonObj=##class(web.DHCAPPJsonObject).%New()
    w "{""rows"":["
	s seqNo=0
    f ordSttDate=StartDate:1:EndDate  d
    .s oeordId=0 f  s oeordId=$o(^OEORDi(0,"StDt",ordSttDate,oeordId)) q:oeordId=""  d
    ..Q:'$d(^OEORD(oeordId))
    ..s EpisodeID=$p(^OEORD(oeordId),"^",1)
    ..s admType=$p($g(^PAADM(EpisodeID)),"^",2)
    ..q:(admType'="E")&(admType'="O")							//非门急诊病人退出
    ..s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
    ..s patRegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    ..s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    ..s cardDr=$O(^DHCCARDi("CF",0,"PAPMIDR",papmiId,""))
    ..s patSeatNo=##class(web.DHCNurSyComm).getPatSeat(EpisodeID)
	..q:cardDr=""
	..s patCardNo=$p($g(^DHCCARD("CF",cardDr)),"^",2)
	..s flag=0,execDateTime="",execNur="",patSeatNo="",tOrdDep="",execDate="",execTime=""
    ..
    ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"StDt",ordSttDate,oeordId,oeoriSub)) q:(oeoriSub="")!(flag=1)  d
    ...s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)
    ...q:ordStatCode'="V"		
    ...s curOrdDepDesc=""									//非核实状态医嘱退出
    ...s curOrdDepId=$P($G(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)	//开医嘱科室
    ...;w:curOrdDepId="" oeordId_"I"_oeoriSub,!
    ...q:curOrdDepId="" //
    ...i curOrdDepId'="" s curOrdDepDesc=$P(^CTLOC(curOrdDepId),"^",2)
    ...q:(OrdDep'="")&(OrdDep'=curOrdDepId)
    ...s tOrdDep=curOrdDepDesc
    ...s ArcimDR=$P($G(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	...s ARCIMRowid=$P(ArcimDR,"||",1)
	...s ARCIMSub=$P(ArcimDR,"||",2)  
	...s ItemCatDR=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",10) //oeori_itmmast_dr->arcim_itemcat_dr->arcic_ordcat_dr->orcat_code
	...s OrdTyp=$P(^ARC("IC",ItemCatDR),"^",7)
	...q:OrdTyp'="R"											//非药物退出
	...s SubCatFlag=$g(^DHCCLSet("Exec","OrderSubCat"))			//设置大类或子类过滤
	...s oecatIdStr=""
	...s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,"ExecCat","")) 
	...s:FSIRowID'="" oecatIdStr=$p(^DHCEMEFSI(FSIRowID),"^",3)
	...s oecatIdStr="^"_$tr(oecatIdStr,"#","^")_"^"
	...;s oecatIdStr="^"_$g(^DHCCLNurseExec("VarDef",0,"SYDO","OrCat"))_"^"	//执行设置输液单医嘱分类
	...s orcatId=$p($g(^ARC("IC",ItemCatDR)),"^",8)				//医嘱大类 
    ...q:(SubCatFlag'="Y")&(oecatIdStr'[("^"_orcatId_"^"))&(orcatId'="") 
    ...q:(SubCatFlag="Y")&(oecatIdStr'[("^"_ItemCatDR_"^"))&(ItemCatDR'="")
    ...;s phcinIdStr="^"_$g(^DHCCLNurseExec("VarDef",0,"SYDO","PhcIn"))_"^" //执行设置输液单用药途径
    ...s phcinIdStr=""
	...s FSIRowID = $o(^DHCEMEFSI(0,"ExecForm",+ExecFormID,"ExecPhi","")) 
	...s:FSIRowID'="" phcinIdStr=$p(^DHCEMEFSI(FSIRowID),"^",3)
	...s phcinIdStr="^"_$tr(phcinIdStr,"#","^")_"^"
	...s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) 	//OEORI_Instr_DR
	...q:(phcinIdStr'[("^"_phcinId_"^"))&(phcinId'="")			//用药途径 
    ...q:($d(^OEORD(oeordId,"I",oeoriSub,"X"))<10)				//无执行医嘱
   	...s oeoreSub=0
    ...f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")!(flag=1)  d
    ....s execDate=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",19)		 //执行日期	
    ....s execTime=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",20)		 //执行时间	
    ....q:(execTime<StartTime)||(execTime>EndTime)
    ....q:(execDate="")!(execTime="")
    ....s exeDate=##Class(web.DHCCLCom).FormatDate(execDate)
    ....s exeTime=##Class(web.DHCCLCom).FormatTime(execTime)
    ....s execDateTime=exeDate_" "_exeTime
	....s execNurId=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)	 //执行人
	....i execNurId'="" s execNur=$P($g(^CTPCP(execNurId,1)),"^",2)
	....e  s execNur=""
	....q:execNur=""
	....s patSeatNo=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",22) //座位号
	....;i admType="E" d
    ....;.s loc=$P($G(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
    ....;.s:loc'="" patSeatNo = ##class(web.DHCEMPatientSeat).GetBedDescByEpisodeID(loc,EpisodeID)
	....s:patSeatNo="" patSeatNo = ##class(web.DHCEMPatientSeat).GetBedDescByEpisodeID("",EpisodeID)
	....s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	....s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
	....s execLocId=""
	....s:dhcoreId'="" execLocId=$p($g(^DHCOrdExec(dhcoreId)),"^",4)		 //执行科室
	....q:(CTLOCID'="")&(CTLOCID'=execLocId)
	....s flag=1
	..q:(execDateTime=" ")!(execNur="")
	..q:(OPCheck="1")&(EMCheck'="1")&(admType'="O")
	..q:(OPCheck'="1")&(EMCheck="1")&(admType'="E")	
#;	..i admType="E"	s admType="急诊"
#;	..i admType="O"	s admType="门诊"
	..q:tOrdDep=""
	..s execNur=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",execNur) //hxy 2022-12-12 st
	..s tOrdDep=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTLoc","CTLOCDesc","",tOrdDep) //ed
	..s seqNo=seqNo+1
	..s tmp=admType_"^"_patCardNo_"^"_exeDate_"^"_exeTime_"^"_patName_"^"_execNur_"^"_patSeatNo_"^"_seqNo_"^"_tOrdDep
	..s count=count+1
	..q:count<start
	..q:count>end
    ..w $case(count,start:"",:",") 
	..w ##class(web.DHCAPPJsonCommon).getJsonData("admType^patCardNo^exeDate^exeTime^patName^execNur^patSeatNo^seqNo^tOrdDep",tmp)
	w "],""total"":"_count_"}"
	q ""
}

/// Descript:		获取执行单ID
/// w ##class(web.DHCEMPatientSeat).getNurExecFormName("SYDO","2")
ClassMethod getNurExecFormName(Code As %String, HospID As %String) As %String
{
	N (Code,HospID)
	Q:Code="" ""
	s FormID=""
	s FSRowID=""
	f  s FSRowID=$o(^DHCEMEFS("0","Code",Code,FSRowID)) q:(FSRowID="")  d
	.q:(FormID'="")
	.s FSHospID = $p(^DHCEMEFS(FSRowID),"^",3)
	.q:(HospID'="")&&(FSHospID'="")&&(FSHospID'=HospID)
	.s FormID= FSRowID
	Q FormID
}

Storage Default
{
<Data name="DHCEMPatientSeatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEMPatientSeatD</DataLocation>
<DefaultData>DHCEMPatientSeatDefaultData</DefaultData>
<IdLocation>^web.DHCEMPatientSeatD</IdLocation>
<IndexLocation>^web.DHCEMPatientSeatI</IndexLocation>
<StreamLocation>^web.DHCEMPatientSeatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
