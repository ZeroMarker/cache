Import SQLUser

Include webimport

IncludeGenerator webimport

/// Desc：门诊手术排班
/// creat：LYN
/// creat：20160405
/// 
Class web.DHCANOPArrangeClinics Extends %RegisteredObject
{

ClassMethod insertAnRecord(itmjs As %Library.String = "", itmjsex As %Library.String = "", str1 As %String, op As %String, ass As %String, strcheck As %String, anmetId As %String = "", ifBLApp As %String = "N", appType As %String = "", strClinic As %String = "") As %String
{
	k PLIST
	//web.UDHCANOPArrange.insertAnRecord
	//str1=applocId+"^"+appdocId+"^"+opaStartDate+"^"+opaStartTime+"^"+appUser+"^"+admId+"^"+oproomid+"^"+opmem+"^"+BldTypId+"^"+ArrTime;
	//str1=str1+"^"+opaOPLevelDr^opaPatHeight^opaPatWeight^opaPreDiscussDate^opaEstiOperDuration^opaOpDocNote^opaSeqNote^opaSeq^opaAppDate^opaAppTime
	//str1=str1+"^"+opaMedInfect+"^"+transferMeansCode
	//申请科室ID^申请医师^手术日期^手术时间^登陆用户^病人就诊ID^手术间ID^手术要求^血型^安排时间^麻醉规模^身高^体重^术前讨论日期^预计手术时长^手术医师备注^手术编号^台次^申请日期(空)^申请时间(空)^院内感染
	//s ^tmpYpz("insertAnRecord","str1")=str1
	//=987^4460^11/09/2009^17:40^680^8598^^手术要求手术要求^1^^3^^^^02:00^游邢泳爱耘^10101010^1
	//s op=ANAOP_Type_DR+"^"+preDiagid+"^"+ANAOP_Surgeon_DR+"^"+diagmem+"^"+operLoction^bodsId^operPositionId
	//	手术名称ID^术前诊断ID^手术医师ID^诊断备注^手术室名称^手术部位ID^手术体位ID
	s ^tmpYpz("insertAnRecord","op")=op
	//anaopTypeDR^anaopPreopDiagDR^anaopSurgeonDR^anaopNotes^anaopCtlocDesc^bodsId^operPositionId
	//=4^4^3594^霍乱霍乱^ZYSS-住院手术室^1^2
	s ^tmpYpz("insertAnRecord","ass")=ass
	//ass=firstAssId+"^"+secondAssId+"^"+thirdAssId+"^"+otherAssId
	//=3804^3884^3712^5396^4092
	s ^tmpYpz("insertAnRecord","strcheck")=strcheck
	//var strcheck=chbsag+"^"+chcvab+"^"+chivab+"^"+chmd+"^"+seljz+"^"+qt+"^"+RHBloodType+"^"+isolated+"^"+isPrepareBlood+"^"+isUseSelfBlood+"^"+isExCirculation+"^"+NeedAnaesthetist+"^"+"^"+NeedNavigation
	//	HbsAg^HCV_Ab^Hiv_Ab^梅毒^急诊^其他^RH血型^是否隔离^是否备血^是否自体血回收^是否体外循环^是否麻醉会诊^是否微创^是否导航
	//^^^^^^opaRHBloodType^opaIsolated^opaPrepareBlood^opaUseSelfBlood^opaExCirculation^opaNeedAnaesthetist
	//=未查^阴性^阳性^化验中^1^其他^阴性^Y^Y^Y^Y^Y
	s ^tmpYpz("insertAnRecord","anmetId")=anmetId
	//同仁门诊使用字段信息
	s ^tmpYpz("insertAnRecord","strClinic")=strClinic
	//=8
	//anmetId 麻醉方法(1|2)
	
	s adm=+$P(str1,"^",6)
	q:adm<1 "-1^就诊号不对!"
	TSTART  //test
	s PLIST(0)=adm 
	//门诊预约手术号源
	s opResource=$P(strClinic,"^",2) 	;手术预约资源
	s opQueueNo=$P(strClinic,"^",3) 	;手术预约号
	s totalH=0 ,opstartTime="" ;手术总时长;手术开始时间
	s comHospDT="",opStartDT="",opStartTime=""
	s comeHosDT=$P(strClinic,"^",4) ;患者来院时间
	s comeHosDate=##class(web.DHCClinicCom).ConvertToDateH($p(comeHosDT," ",1))
	s comeHosTime=##class(web.DHCClinicCom).ConvertToTimeH($p(comeHosDT," ",2))
	i +opQueueNo=0 d
		.s retLoadStr=##class(web.DHCANOPArrangeClinics).JudgeResourceEffect(opResource)
		.s opQueueNo=$p(retLoadStr,"|",4)
		.;获取手术号源的开始时间
		.;s ^tmpYpz("OPDT","para")=opResource_"/"_$P(str1,"^",3)_"/"_totalH_"/"_opQueueNo
		.s retDTStr=##class(web.DHCANOPArrangeClinics).GetOPStartTimeByResource(opResource,$P(str1,"^",3),opQueueNo,1)
		.s ^tmpYpz("OPDT")=retDTStr
		.i +retDTStr>0 d
		..//s comeHosTime=$P(retDTStr,"||",1)
		..s opStartDT=$P(retDTStr,"||",2)
		..s opStartTime=$p(opStartDT," ",2)
	e  s opStartTime=$P(str1,"^",4) ;设置手术开始时间
	
	//q:(+opQueueNo=0) "-3^该资源已经没有了预约号源，请选择其他资源" (暂时未使用)
	//q:opStartTime="" "-1^手术时间设置错误"  (暂时未使用)
	s opStartTime=$P(str1,"^",4) ;设置手术开始时间  上面时间段设置后，此句话当删除
	
	s PLIST(48)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3))		//ANA_TheatreInDate	手术开始日期
	s PLIST(49)=##class(web.DHCANOPCom).ConvertToTimeH(opStartTime,"")		//ANA_TheatreInTime	手术开始时间
    &sql(INSERT INTO sqluser.OR_Anaesthesia Values :PLIST())
    s anaId=%ROWID
    i SQLCODE'=0  TRollBack  q "-2^插入麻醉表错误!"
	k PLIST
	s PLIST(2)=adm
	s PLIST(13)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",19)) //appDate
	s PLIST(14)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",20)) //appTime
	
	s PLIST(7)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3))
	i PLIST(7)<$h  TRollBack  q "-3^手术日期不能早于系统日期!"
	s PLIST(9)=##class(web.DHCANOPCom).ConvertToTimeH(opStartTime,"")
	
	s PLIST(5)=$P(str1,"^",7)  								//OPA_OpRoom_dr	如维护手术间默认使用科室,申请时自动填入手术间
	s PLIST(12)=$P(str1,"^",2) 								//OPA_AppCtcp_Dr 申请医生
	s PLIST(3)=$p($g(^PAADM(adm)),"^",4)					//patloc //ypz 070530
	s PLIST(55)=$P(str1,"^",1)
	i "EO"[$p($g(^PAADM(adm)),"^",2) s PLIST(55)=$p($g(^PAADM(adm)),"^",4)
	s PLIST(33)=$p($g(^PAADM(adm)),"^",70)
	s PLIST(4)=anaId
	//s PLIST(20)="A"
	s PLIST(20)=""		//科主任审核
	s groupId=%session.Data("LOGON.GROUPID")
	i $G(^DHCCLSet("AnOp","DirAudit"))'="" d
	.i $G(^DHCCLSet("AnOp","DirAudit"))[groupId d
	..s PLIST(20)="A"
	e  s PLIST(20)="A"
	//如果是实习医生申请的手术为空状态
	s appctcpId=$P(str1,"^",2)
	i appctcpId'="" d
		.s ctcptId=$p($g(^CTPCP(appctcpId,1)),"^",4)
		.i ctcptId'="" d
			..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",1)
			..i ctcptType="PRACTICE" s PLIST(20)=""

	//i $P(strcheck,"^",5)=1 s PLIST(20)="A"
	s BldTyDescOrdId=$P(str1,"^",9)                               	//WKZ 071226 S 血型更新
 	i BldTyDescOrdId'="" d
	.i BldTyDescOrdId=+BldTyDescOrdId s BldTyId=BldTyDescOrdId
	.e  d
	..s BldTyDescOrdId=$$ALPHAUP^SSUTIL4(BldTyDescOrdId)
	..s BldTyId=$o(^PAC("BLDT",0,"Desc",BldTyDescOrdId,""))
	e  s BldTyId=""
	s ifBlood=##class(web.UDHCANOPArrange).GetPatBlood(adm)
	s PLIST(27)=BldTyId										//OPA_BloodType_Dr	血型
	s PLIST(28)=$P(strcheck,"^",7)							//OPA_RHBloodType	RH血型
	s PLIST(29)=$P(strcheck,"^",8)						  	//OPA_Isolated		是否隔离
	i "YN"'[PLIST(29) s PLIST(29)=""
	s PLIST(34)=$P(strcheck,"^",9)							//OPA_PrepareBlood	是否备血
	i "YN"'[PLIST(34) s PLIST(34)=""
	s PLIST(35)=$P(strcheck,"^",10)							//OPA_UseSelfBlood	是否自体血回输
	i "YN"'[PLIST(35) s PLIST(35)=""
	s PLIST(37)=$P(strcheck,"^",11)							//OPA_ExCirculation	是否体外循环
	i "YN"'[PLIST(37) s PLIST(37)=""
	s PLIST(45)=$P(strcheck,"^",12) 						//OPA_NeedAnaesthetist是否麻醉会诊
	i "YN"'[PLIST(45) s PLIST(45)=""
	s PLIST(24)=$P(strcheck,"^",13) 						//OPA_MiniInvasive	是否微创手术
	i "YN"'[PLIST(24) s PLIST(24)=""
	s PLIST(56)=$p(strcheck,"^",14)                         //OPA_Navigation 是否导航
	i "YN"'[PLIST(56) s PLIST(56)=""
	s PLIST(285)=$p(strcheck,"^",15)                         //OPA_CarePathologSection 是否病理标本
    i "YN"'[PLIST(285) s PLIST(285)=""
	s PLIST(193)=$P(strcheck,"^",1)							//OPA_PATestHBsAg 	免疫乙肝表面抗原
	s PLIST(198)=$P(strcheck,"^",2)							//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	s PLIST(199)=$P(strcheck,"^",3)							//OPA_PATestHivAb 	免疫艾滋病毒抗体
	s PLIST(200)=$P(strcheck,"^",4)							//OPA_PATestTPAb 	免疫梅毒
	s PLIST(166)=$P(strcheck,"^",6)							//OPA_PATestOther 	检验其它阴阳性
	s PLIST(19)=$P(str1,"^",8) 								//OPA_Memo			备注-手术要求			
	//s PLIST(21)=+$P(str1,"^",11)      //WKZ 071224 S		//OPA_OPLevel_Dr	麻醉规模
	s PLIST(25)=+$P(str1,"^",12)							//OPA_PatHeight		身高
	s PLIST(26)=$P(str1,"^",13)      //WKZ 071224 E			//OPA_PatWeight		体重
	s PLIST(149)=anmetId 
	s PLIST(26)=+PLIST(26)
	s PLIST(38)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",15),"")
	s PLIST(39)=##class(web.DHCANOPCom).ConvertToDateH(($P(str1,"^",14)),"") //+ wxl 090316

	s PLIST(22)="N"
	s PLIST(43)=$P(str1,"^",16)   							//OPA_OpDocNote 实习医生,手术医师备注
	s PLIST(42)=$P(str1,"^",17)   							//OPA_SeqNote	手术编号,医生手术申请编号
	s PLIST(6)=$P(str1,"^",18) 								//OPA_Seq		台次
	s PLIST(54)=$P(str1,"^",21)							    //OPA_MedInfect 院感
	s PLIST(40)=$P(str1,"^",22)                             //OPA_TransferMeans 接病人方式
	s PLIST(47)=$P(strcheck,"^",17)		//勿动20160114
	&sql(INSERT INTO SQLUSER.DHC_AN_OPArrange Values :PLIST())
	s Ret1=%ROWID
	s $P(^DHCANOPArrange(Ret1,"PA"),"^",89)=anmetId
	i SQLCODE'=0 TRollBack  q "-5^插入手术排班表错误!"_"/"_Ret1_"/"_SQLCODE
	
	//手术医师组+dyl+20150319+标准版+旧版没有保存，走扩展字段
	s docGroupId=$P(strcheck,"^",16)	//OPA.OperMedUnitId 手术医师组
	s paraStr="" ,retSur=""
	s paraStr="OPA.OperMedUnitId"_$c(3)_docGroupId
	s retSur=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(Ret1,paraStr,$p(str1,"^",5))
	i +retSur<0 TRollBack  q:"-111^插入手术医师组错误"
	//-----
	
	///ck 091204
	s anaNotesList=$lb("")
	i ($p($P(op,"^",2),"|",1)="")!($p($p($p(op,"^",2),"|",1),"/",2)="")  d
	.s anaNotes=$p(op,"^",4)
	.s anaNotesList=$lb(anaNotes)
	
	s SourceType=$P(strcheck,"^",5)							//ANA_SourceType 急诊(E)/择期(B)	
	i SourceType=1  s anaSourceType="E"
	e  s anaSourceType="B" 
	&sql(update SQLUSER.OR_Anaesthesia set ANA_Notes=:anaNotesList,ANA_SourceType=:anaSourceType where ANA_RowId=:anaId)
	i SQLCODE'=0 TRollBack  q "-6^写入诊断备注或急诊手术错误!"
	//s ^DHCANARRAGE("ch",Ret1)=strcheck					//检验值已存入DHC_AN_OPArrange
	;i anmetId'="" &sql(update SQLUSER.OR_Anaesthesia set ANA_Method=:anmetId where ANA_RowId=:anaId)
	;i SQLCODE'=0 TRollBack  q "-7^写入麻醉方式错误!" //ypz 070405 外科医生填写麻醉方式
	//保存多个麻醉方法
	s adm=$p(anaId,"||",1)
	s anachl=$p(anaId,"||",2)
	i anmetId'="" s $P(^OR(adm,"ANA",anachl),"^",5)=anmetId 	
	k PLIST
	s PLIST(7)=""
	s diagIdS=$p($P(op,"^",2),"|",1)
	s diagIdS=$tr(diagIdS,",","$") //主要为了兼容以前的程序，以前是以"$"分隔的，现在前台以","分隔，故替换
	s preDiagIdS=$p(diagIdS,"/",1)
	s postDiagId=$p(diagIdS,"/",2)
    i $l(diagIdS,"/")=1  d
	.i diagIdS'=""  d    //术前诊断Id
	..i diagIdS=+diagIdS s PLIST(6)=diagIdS
	..e  s PLIST(6)=""
	.s PLIST(7)=""
	i $l(diagIdS,"/")=2  d
	.i preDiagIdS'=""  d
	..i preDiagIdS=+preDiagIdS s PLIST(6)=preDiagIdS
	..e  s PLIST(6)=""
	.e  s PLIST(6)=""
	i postDiagId'=""  d      //术后诊断ID
	.i postDiagId=+postDiagId s PLIST(7)=postDiagId
	.e  s PLIST(7)=""
	q:($p($P(op,"^",1),"|",1)="")&($p($P(op,"^",1),"|",3)="") "手术名称或手术备注为空!"
	i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
		.s PLIST(9)="" //20101029 zhangtao
	e  s PLIST(9)=$p($P(op,"^",1),"|",1)
	s PLIST(8)=$lb($p($p(op,"^",1),"|",3))	//ANAOP_Notes
	;s PLIST(6)=$p(op,"^",2)
	;s PLIST(9)=$P(op,"^",1)
	//s PLIST(8)=$P(op,"^",4)
	s PLIST(11)=$P(op,"^",3)
	s bldtpCode=$p($p(op,"^",1),"|",4)							//+wxl 091215 手术刀口类型 ANAOP_Blade_DR->ORC_BladeType
	s bldtpId=""
	i bldtpCode'="" d
	.i bldtpCode=+bldtpCode s bldtpId=bldtpCode q
	.s bldtpCode=$$ALPHAUP^SSUTIL4(bldtpCode)
	.q:bldtpCode=""
	.s bldtpId=$o(^ORC("BLDTP",0,"Code",bldtpCode,""))
	s PLIST(12)=bldtpId											//+wxl 091215
	s ctlocDesc=$$ALPHAUP^SSUTIL4($P(op,"^",5)),ctlocId="" //ypz 070316
	i ctlocDesc'="" s ctlocId=$o(^CTLOC(0,"Desc",ctlocDesc,"")) //ypz 070316
	i ctlocId="",ctlocDesc=+ctlocDesc s ctlocId=ctlocDesc
	i ctlocId="",ctlocDesc'=+ctlocDesc TRollBack  q "-11^请选择手术室"
	s PLIST(13)=ctlocId  //ypz 070316
	s PLIST(14)="M" //ypz 070530
	s bodsId=$P(op,"^",6) //ypz 070418
	s PLIST(23)=$p(^PAADM(adm),"^",4) //ypz 090917 病人科室
	//s PLIST(42)=bodsId //ypz 070418 OEC_BodySite RowId //100129 现直接保存于Global中
	//s bodsDesc=$p($g(^OEC("BODS",+bodsId)),"^",2) //ypz 070418
	s PLIST(0)=anaId
	&sql(INSERT INTO sqluser.OR_Anaest_Operation Values :PLIST())
	s Ret3=%ROWID
	i SQLCODE'=0 TRollBack  q "-8^插入手术表错误!"
    //保存多个手术部位于GLobal中
    s adm=$P(Ret3,"||",1)	
	s anaSub=$P(Ret3,"||",2)
	s anaopSub=$P(Ret3,"||",3)
	s ^OR(adm,"ANA",anaSub,"TXT",0)=3                  //zhangtao add
    s preDiagS="",preDiagN=""   
                                           
	i $l(diagIdS,"/")=1  d
	.i diagIdS'=""  d    //术前诊断Id
	..s dNum=$l(diagIdS,"$")
	..f i=1:1:dNum d
	...s diagId=$p(diagIdS,"$",i)
	...q:diagId=""
	...i diagId=+diagId s $p(preDiagS,"|",i)=diagId
	...e  d
	....s $p(preDiagS,"|",i)=""
	....s $p(preDiagN,"|",i)=diagId
	
	i $l(diagIdS,"/")=2  d
	.i preDiagIdS'=""  d
	..s dNum=$l(preDiagIdS,"$")
	..f i=1:1:dNum d
	...s preDiagId=$p(preDiagIdS,"$",i)
	...i preDiagId=+preDiagId s $p(preDiagS,"|",i)=preDiagId
	...e  d 
	....s $p(preDiagS,"|",i)=""    
	....s $p(preDiagN,"|",i)=preDiagId
	.i postDiagId'=""  d      //术后诊断ID
	..i postDiagId'=+postDiagId s ^OR(adm,"ANA",anaSub,"TXT",3)=postDiagId
	s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub),"^",4)=preDiagS  
	s ^OR(adm,"ANA",anaSub,"TXT",2)=preDiagN   //zhangtao add
	i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
	.s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",0)=2
	.;s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",1)=$lb($p($p(op,"^",1),"|",3))
	.s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",2)=$p($p(op,"^",1),"|",1)
	
	s bodsDesc=""
	i bodsId'="" d
	.s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub),"^",24)=bodsId
	.s bodsIdNum=$l(bodsId,"|")
	.f i=1:1:bodsIdNum d
	..s curBodsId=$p(bodsId,"|",i)
	..q:curBodsId=""
	..i bodsDesc="" s bodsDesc=$p($g(^OEC("BODS",+curBodsId)),"^",2)
	..e  s bodsDesc=bodsDesc_","_$p($g(^OEC("BODS",+curBodsId)),"^",2)
	s operPositionId=$P(op,"^",7)
	i operPositionId'="" d
	.s PLIST(0)=Ret3
	.s PLIST(3)=operPositionId
	.&sql(INSERT INTO sqluser.OR_An_Oper_Position Values :PLIST())
	i SQLCODE'=0 TRollBack  q "-9^插入体位表错误!"
	s chl=$P(Ret3,"||",3)
	s anchl=$P(Ret3,"||",2)
	s ancoplCode=$p($p(op,"^",1),"|",2)							//+wxl 091215 保存手术级别->ORC_OperationCategay 
	;s ^tmpLYN(Ret1)=$p($p(op,"^",1),"|",2)	
	s ancoplId=""
	i ancoplCode'="" d
	.i ancoplCode=+ancoplCode s ancoplId=ancoplCode q
	.s ancoplCode=$$ALPHAUP^SSUTIL4(ancoplCode)
	.//s ancoplId=$o(^DHCANC("OPLevel",0,"Code",ancoplCode,""))  
	.s ancoplId=$o(^ORC("CATEG",0,"Code",ancoplCode,""))  //update by lyn 20160811
	
	s $p(^OR(adm,"ANA",anchl,"OP",chl,"DHC"),"^",1)=ancoplId	//+wxl 091215  保存手术级别->ORC_OperationCategay 
	s num=$L(ass,"^")
	f i=1:1:num
	{
		i SQLCODE q
		k PLIST
		i $P(ass,"^",i)'=""  d
		.s PLIST(0)=Ret3
		.s PLIST(3)=$P(ass,"^",i)
		.&sql(insert into sqluser.OR_An_Oper_Assistant values :PLIST())
	}
	i SQLCODE TRollBack  q "-10^插入手术助手表错误!"
	
	
	
	//************门诊插入主诉和资源******************
	//add by lyn
	s selfReport=$P(strClinic,"^",1)
	//K ^LYNTMP
	//s ^LYNTMP(Ret1)=selfReport
	s paraStr="OPA.SelfReport"_$c(3)_selfReport
	s retSelf=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(Ret1,paraStr,$p(str1,"^",5))
	i +retSelf<0 TRollBack  q "-15^插入主诉错误！"
	/*  (暂时不使用，根据项目要求，是否决定启用)
	//s ^LYNTMP(Ret1)=selfReport_"/  "_opResource
	s paraStr="OPA.OperResource"_$c(3)_opResource
	s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(Ret1,paraStr,$p(str1,"^",5))
	i +retOR<0 TRollBack  q "-16^插入门诊资源！"

	//s ^LYNTMP(Ret1)=selfReport_"/  "_opResource_"/"_opQueueNo
	s paraStr="OPA.QueueNo"_$c(3)_opQueueNo
	s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(Ret1,paraStr,$p(str1,"^",5))
	i +retOR<0 TRollBack  q "-17^插入门诊号源！"
		
	///更改手术号源使用状态
	//s ^LYNTMP("RS",opResource)=opResource_"/"_$P(strClinic,"^",3)_"/"_1
	s retLN=##class(web.DHCANOPArrangeClinics).UpdateOpSequenceNoStat(opResource,opQueueNo,1)
	i retLN=2 TRollBack  q "-18^手术号源刚被使用，请重新选择资源、号源!"
	i retLN<1 TRollBack  q "-18^更新号源时参数出现错误！"
	//s ^LYNTMP("RS",$P(strcheck,"^",17))=retLN
	
	
	*/
	s comeHosDateTime=comeHosDate_","_comeHosTime
	s paraStr="OPA.PatComeHosTime"_$c(3)_comeHosDateTime
	s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(Ret1,paraStr,$p(str1,"^",5))
	i +retOR<0 TRollBack  q "-20^插入患者来院错误！"
	
	s patNotice=$P(strClinic,"^",5) ;病人须知
	s ^DHCANOPArrange("PatNotice",Ret1)=$P(strClinic,"^",5) ;病人须知
	
	s operStock=$P(strClinic,"^",6) ;手术耗材
	s paraStr="OPA.OperStock"_$c(3)_operStock
	s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(Ret1,paraStr,$p(str1,"^",5))
	i +retOR<0 TRollBack  q "-21^插入手术耗材错误！"
	
	s operStockNote=$P(strClinic,"^",7) ;手术耗材说明
	s paraStr="OPA.OperStockNote"_$c(3)_operStockNote
	s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(Ret1,paraStr,$p(str1,"^",5))
	i +retOR<0 TRollBack  q "-21^插入手术耗材说明错误！"
	s ^tmpLYN("ANOPApp",Ret1)=operStock_","_operStockNote
	
	s telNum=$P(strClinic,"^",9) //病人电话
	s paraStr="OPA.PatTel"_$c(3)_telNum
	s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(Ret1,paraStr,$p(str1,"^",5))
	i +retOR<0 TRollBack  q "-22^插入患者电话错误！"
	
    s ^DHCANOPArrange("OUTOP",Ret1)="O"  //标记门诊手术
	//************************************************
	
	//申请的时候向平台发送一次信息
	s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",Ret1)
	s ^tmpDYL("ANOPApp",Ret1)=OAret
	//
   //liangq 20101105
   	s ctpcpId=$p($g(^SSU("SSUSR",$P(str1,"^",2))),"^",14)
     s arcimId=$g(^DHCCLSet("AnOp","AppArcimId"))
    s retInsord =##class(web.UDHCANOPArrange).SaveAnopAppOrdItem(arcimId,Ret1,$P(str1,"^",5),appType,ifBLApp,0)
   	i retInsord'=0 TRollBack  q retInsord
	s subOperStr=$p(op,"^",8)
	s otherOperStatus=##class(web.UDHCANOPArrange).insertchlop("","",anaId,subOperStr,appType)
	//s retval=itmjs_"('"_$ZCVT(anaId,"O","JS")_"');"
    //i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(anaId,"O","JS")_"');"
    //&javascript<#(retval)#>
	
   	TCOMMIT
   	
   	
   	
 q Ret1
 //OR_An_Oper_Anaest_Assistant
}

/// d ##class(%ResultSet).RunQuery("web.DHCANOPArrangeClinics","FindOPerByCat","1")
/// Creator: 		lyn
/// Description:	通过手术分类查找手术
/// Output:			分类Code 分类描述
/// Table：			DHC_ANC_OperationCat，分类表Id 关联手术$p($g(^ORC("OPER",operId,"DHC")),"^",16)位置中
Query FindOPerByCat(opCatId As %String) As %Query(ROWSPEC = "operId,operCode,operDesc")
{
}

ClassMethod FindOPerByCatExecute(ByRef qHandle As %Binary, opCatId As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	i opCatId="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s operId=0
	f  s operId=$o(^ORC("OPER",operId)) q:operId=""  d
		.s operCat=$p($g(^ORC("OPER",operId,"DHC")),"^",16)
		.q:(operCat'=opCatId)
		.s operDesc=$p(^ORC("OPER",operId),"^",2)
		.s operCode=$p(^ORC("OPER",operId),"^",1)
		.d OutputG
	
	
	s qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputG
	s data=$lb(operId,operCode,operDesc)
	s ^CacheTemp(repid,ind)=data
	s ind=ind+1
	quit
}

ClassMethod FindOPerByCatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOPerByCatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindOPerByCatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOPerByCatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Descripation：通过查找手术分类
/// Table：DHC_ANC_OperationCat
/// d ##class(%ResultSet).RunQuery("web.DHCANOPArrangeClinics","FindOperCat") 
Query FindOperCat() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,ANCOC_Code:%String,ANCOC_Desc:%String")
{
    select ID ,ANCOC_Code,ANCOC_Desc from SQLUser.DHC_ANC_OperationCat
}

// w ##class(web.DHCANOPArrange).GetAnSingle("25","","")

ClassMethod GetAnSingle(opaId As %String, EpisodeID As %String = "", userId As %String = "", type As %String = "") As %String
{
    //n (itmjs,itmjsex,opaId,EpisodeID,userId)
    i EpisodeID="",opaId'="" s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
    q:EpisodeID="" ""
    s anaesRowId=""
    s dateformatnum=##class(websys.Conversions).DateFormat()
    //s transferMeans="",transferMeansCode="",docAnMethod="",IsPapEstimDS="N"
    
    s admReason="",bedCode="",ward="",regNo="",patName="",age="",sex="",infection="",locId="",locDes=""
    s opDate="",operLocId="",operLocDesc="",appDocId="",appDocDesc="",appLocId="",appLocDesc="",transferMeans="",opMem="",bloodType="",arrDateTime="",isAddInstrument="",instrumentDr="",instrument="",surgeonDr="",surgeonDesc="",surgeon="",opCategory="",postDiag="",assistants="",opDocNote="",opSeqNote="",bodsList="",operPosition=""
    s anDoc="",anSupDoc="",anNurse="",anAssStr="",shiftAnAssStr="",anMethodStr="",anaLevel="",anDocNote=""
    s opRoom="",opaSeq="",scNurStr="",sScNurStr="",cirNurStr="",sCirNurStr="",scnShiftTime="",cirShiftTime="",scNurNote="",cirNurNote="" 
    s opStDate="",opStTime="",opArrDate="",opArrTime="",opEndDate="",opEndTime="",preDiscussDate="",estiOperDuration="",anaTheatreInDate="",anaTheatreInTime="",anaTheatreOutDate="",anaTheatreOutTime=""
    s methedId="",methedesc="",selfReport="",operResource=""
    s operpermissions=""    //whl20140520  手术权限
    s opermemo="" //whl20140520   术式备注
    s positionmemo=""   //whl20140520    手术部位备注
    s oneday="" //whl20140520    一日病房
    s qiekou="" //whl20140520    手术切口
    s qiekouId=""   //whl20140520    手术切口
    s OpAssNote="" //whl20140520    助手备注
    s OpAssNoteRet=""
    s operpermdengji=""
    s bldtpdr=""
    s dengjidr=""
    s operdr="",methedDescStr="",preDiagAndNotes=""
    s admReasonDr=$p($g(^PAADM(EpisodeID,1)),"^",7)
    i admReasonDr'="" s admReason=$P(^PAC("ADMREA",admReasonDr),"^",2) //费别
    s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
    s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
    i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    i curWardId'="" s ward=$P($G(^PAWARD(curWardId)),"^",2)
    ;i $l(ward,"-")>1 s ward=$p(ward,"-",2)
    s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    
    //update by LYN 
    s telId="" ;病人电话
    s telId=$p($g(^PAPER(papmiId,"PER",4)),"^",21)   //手机
    i telId="" s telId=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //家庭电话
    i telId="" s telId=$p($g(^PAPER(papmiId,"PER",1)),"^",9)
	
    s infection=##class(web.UDHCANOPArrange).GetQueryInfPyObjDrugByPaadmStr(EpisodeID)
    s locId=$P($g(^PAADM(EpisodeID)),"^",4)
    s locDes=$P(^CTLOC(locId),"^",2)
    ;i $l(locDes,"-")>1 s locDes=$p(locDes,"-",2)
    s papEstimDCDate=$p($g(^PAADM(EpisodeID)),"^",59)
    s papVStatus=$p($g(^PAADM(EpisodeID)),"^",20)
    i ((papEstimDCDate'="")&(papVStatus="A")) d
    .s IsPapEstimDS="Y"
    s opStDate=##class(web.DHCANOPCom).GetOperDate()
    s opStDate=$ZD(opStDate,dateformatnum)
    s opDate=opStDate
    s locListCodeStr=##class(web.DHCClinicCom).AdjustLocListCode("OP^OUTOP^EMOP",EpisodeID)
    s ctLocIdList=##class(web.DHCClinicCom).GetLocIdByLocListCode(locListCodeStr)
    i ctLocIdList'="" d
    .s operLocId=$p(ctLocIdList,"^",1)
    .q:operLocId=""
    .q:'$d(^CTLOC(operLocId))
    .s operLocDesc=$p(^CTLOC(operLocId),"^",2)
    		;20170628+dyl+默认的住院或门诊手术室按照手术申请配置走
	i type="In" d
		.s IPDefOpLocId=$g(^DHCCLSet("AnOp","IPDefOpLoc"))
		.i IPDefOpLocId'="" d
			..s operLocId=IPDefOpLocId
			..s operLocDesc=$p(^CTLOC(operLocId),"^",2)
	i type="Out" d
		.s OPDefOpLocId=$g(^DHCCLSet("AnOp","OPDefOpLoc"))
		.i OPDefOpLocId'="" d
			..s operLocId=OPDefOpLocId
			..s operLocDesc=$p(^CTLOC(operLocId),"^",2)

    i locId'="" d
	    .s curOPRoomId=$o(^DHCANC("OPRoom",0,"DefDep",locId,""))
	    .q:curOPRoomId=""
	    .s operLocId=$p(^DHCANC("OPRoom",curOPRoomId),"^",3)
	    .q:operLocId=""
	    .q:'$d(^CTLOC(operLocId))
	    .s operLocDesc=$p(^CTLOC(operLocId),"^",2)
    s operLoc=operLocId_"!"_operLocDesc
    
    ;s defalultoperLocDesc=##class(web.DHCANOPCom).GetLocDefaultOpRoomByLocId(locId)
    ;i defalultoperLocDesc'="" s operLoc=$p(defalultoperLocDesc,"^",1)_"!"_$p(defalultoperLocDesc,"^",2)
    i userId'="" d
    .s appDocId=$p($g(^SSU("SSUSR",userId)),"^",14)
    .q:appDocId=""
    .s appDocDesc=##class(web.DHCANOPCom).GetNameById(appDocId)
    s appDoc=appDocId_"!"_appDocDesc
    s appLoc=locId_"!"_locDes
    ////术前诊断
    s mainDiag=##class(web.DHCANOPPREDIAG).GetAllMDiagnosByAdm(EpisodeID)
    s mainDiag=$tr(mainDiag,"^","!")
    s retSlaveDiag=##class(web.DHCANOPPREDIAG).GetAllMDiagnos(EpisodeID)    
    s slaveDiag=$p(retSlaveDiag,"$",1)
    s slaveDiag=$tr(slaveDiag,"|",",")  
    s diagNotes=$p(retSlaveDiag,"$",2)
    s preDiag=mainDiag   //medify mfc 20140117获取诊断记录
    i diagNotes="" s preDiagAndNotes=preDiag_"#"_slaveDiag
    e  s preDiagAndNotes=preDiag_"#"_slaveDiag_","_diagNotes
    s preDiagAndNotes=$tr(preDiagAndNotes,"^","")
    i opaId="" d SetRetData q retStr
    b ;"2"
    s appDocId=$P(^DHCANOPArrange(opaId),"^",6)
    i appDocId'="" s appDocDesc=##class(web.DHCANOPCom).GetNameById(appDocId)
    s appDoc=appDocId_"!"_appDocDesc
    s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
    i appLocId'="" s appLocDesc=$P($g(^CTLOC(appLocId)),"^",2)
    s appLoc=appLocId_"!"_appLocDesc
    s opStDate=$P(^DHCANOPArrange(opaId),"^",14)
    s age=##class(web.UDHCANOPArrange).CalAge(birth,opStDate)
    i opStDate'="" s opStDate=$zd(opStDate,dateformatnum)
    s opStTime=$P(^DHCANOPArrange(opaId),"^",15)
    s opArrDate=$P(^DHCANOPArrange(opaId),"^",7)
    s opArrTime=$P(^DHCANOPArrange(opaId),"^",8)
    s opEndDate=$P(^DHCANOPArrange(opaId),"^",16)
    s opEndTime=$P(^DHCANOPArrange(opaId),"^",17)
    i opStTime'="" s opStTime=$ZT(opStTime,2)
    i opArrDate'="" s opArrDate=$ZD(opArrDate,dateformatnum)
    i opArrTime'="" s opArrTime=$ZT(opArrTime,2)
    s arrDateTime=opArrDate_" "_opArrTime
    i opEndDate'=""  s opEndDate=$ZD(opEndDate,dateformatnum)
    i opEndTime'=""  s opEndTime=$ZT(opEndTime,2)
    s preDiscussDate=$P(^DHCANOPArrange(opaId),"^",38)
    i preDiscussDate'="" s preDiscussDate=$zd(preDiscussDate,dateformatnum)
    s estiOperDuration=$P(^DHCANOPArrange(opaId),"^",37)
    i estiOperDuration'="" s estiOperDuration=$ZT(estiOperDuration,2)
    s transferMeansCode=$p(^DHCANOPArrange(opaId),"^",39)  
    i transferMeansCode="W" s transferMeans="自行" 
    i transferMeansCode="C" s transferMeans="轮椅"
    i transferMeansCode="S" s transferMeans="平车"
    s opMem=$P(^DHCANOPArrange(opaId),"^",19)
    s bldTypId=$P(^DHCANOPArrange(opaId),"^",11)
    i bldTypId'="" s bldTypDesc=$P($G(^PAC("BLDT",bldTypId)),"^",2)
    e  s bldTypDesc="不详"
    s bloodType=bldTypId_"!"_bldTypDesc
    s instrumentDr=$P($G(^DHCANOPArrange(opaId)),"^",30) 
    i instrumentDr'="" s instrument=$P($G(^DHCANC("Instrument",instrumentDr)),"^",2)    //DHC_ANC_Instrument    器械
    e  s instrument=""
    s isAddInstrument=$P($G(^DHCANOPArrange(opaId)),"^",31)             //OPA_AddInstrument     是否补充器械
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    s anaSub=$P(anaId,"||",2)
    s assDocNum=5
    i $p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)>0 s assDocNum=$p($g(^DHCCLSet("AnOp","Ctcp")),"^",1)
    s i=0
    s opSub=0 f  s opSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub)) q:(opSub="")!(i=1)  d
    .s i=i+1
    .;s anaopSub=opSub
    .;s oprdate=$P(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",13)  ;ANAOP_OpStartDate  手术日期
    .s surgeonDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",8)        ;ANAOP_Surgeon_DR  ；手术医师
    .i surgeonDr'="" s surgeonDesc=$p($g(^CTPCP(surgeonDr,3)),"^",28)_##class(web.DHCANOPCom).GetNameById(surgeonDr)
    .s surgeon=surgeonDr_"!"_surgeonDesc
    .;e  s surgeon=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //自填写手术医生   
     .s methedIds=$p($g(^DHCANOPArrange(opaId,"PA")),"^",89) //医生填写的麻醉方法
     
     .i methedIds'="" d
    ..s methedIdnum=$l(methedIds,",")
    ..f i=1:1:methedIdnum d
    ...s methedId=$p(methedIds,",",i)
    ...q:methedId=""
    ...s methedDesc=$p($g(^ORC("ANMET",methedId)),"^",2)
    ...i $P(methedDesc,"-",2)'="" s methedDesc=$P(methedDesc,"-",2)
    ...i methedDescStr="" s methedDescStr=methedId_"!"_methedDesc
    ...e  s methedDescStr=methedDescStr_","_methedId_"!"_methedDesc
     .s operdr=$p(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"DHC"),"^",4)   //whl20140520  手术权限
     .s operpermissions=$P($g(^ORC("OPER",+operdr)),"^",2)
     .s dengjidr= $P($g(^ORC("OPER",+operdr)),"^",7)
     .i dengjidr'="" s operpermdengji=$p($g(^ORC("CATEG",dengjidr)),"^",2)
     
     .s opermemo=$p(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"DHC"),"^",5) //whl20140520   术式备注
     .s positionmemo=$p(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"DHC"),"^",6) //whl20140520    手术部位备注
     .s oneday=$p(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"DHC"),"^",7)   //whl20140520    一日病房
     .s bldtpdr=$p($g(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"DHC")),"^",8)  //whl20140520    手术切口
     .i bldtpdr'="" s qiekou=$p($g(^ORC("BLDTP",bldtpdr)),"^",2),qiekouId=bldtpdr
    
    .s opDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",6)         ;ANAOP_Type_DR     ；手术名称
    .s opDes=""
    .i opDr'="" d
    ..i $D(^ORC("OPER",opDr)) d
    ...s opDes=$P(^ORC("OPER",opDr),"^",2)
    ...s opCategoryId=$p(^ORC("OPER",opDr),"^",7)                    // 手术分类
    ...i opCategoryId'=""  s opCategory=$p($g(^ORC("CATEG",opCategoryId)),"^",2)
    ...s opStatName=$P(^ORC("OPER",opDr),"^",35)                         //手术统计名称
    .s operation=opDr_"!"_opDes
    .s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",10) 
    .s operLocDesc="" 
    .i operLocId'="" s operLocDesc=$p(^CTLOC(operLocId),"^",2)
    .s operLoc=operLocId_"!"_operLocDesc
    .s bodsIdList=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",24)      //手术部位
    .s bodsList=""
    .i bodsIdList'="" d
    ..s bodsIdNum=$l(bodsIdList,"|")
    ..f j=1:1:bodsIdNum d
    ...s bodsId=$p(bodsIdList,"|",j)
    ...q:bodsId=""
    ...s bodsDesc=$p($g(^OEC("BODS",+bodsId)),"^",2)
    ...i bodsList="" s bodsList=bodsId_"!"_bodsDesc
    ...e  s bodsList=bodsList_","_bodsId_"!"_bodsDesc      
    .s preDiagStr=""
    .s preDigDrStr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",4)     ;ANAOP_PreopDiag_DR 术前诊断S //zhangtao add
    .s num=$l(preDigDrStr,"|")
    .f di=1:1:num d
    ..s dr=$p(preDigDrStr,"|",di)
    ..q:dr=""
    ..s desc=$P(^MRC("ID",dr),"^",2)
    ..s item=dr_"!"_desc
    ..i preDiagStr="" s preDiagStr=item
    ..e  s preDiagStr=preDiagStr_","_item
    .s diaMem=$g(^OR(EpisodeID,"ANA",anaSub,"TXT",1))
    .s preDiagAndNotes=preDiagStr_"#"_diaMem
    .s preDiagAndNotes=$tr(preDiagAndNotes,"^","")
    .s postDigDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",5)   ;ANAOP_PostDiag_DR 术后诊断
    .i postDigDr'="" d
    ..s postDiag=postDigDr_"!"_$P(^MRC("ID",postDigDr),"^",2)    
    .s p=0  ;助手 
    .s asId=0 f  s asId=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ASS",asId)) q:(asId="")!(p'<assDocNum)  d
    ..s assistantDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ASS",asId),"^",1)
    ..q:assistantDr=""
    ..s p=p+1
    ..s OpAssNote=$P($g(^CTPCP(assistantDr,1)),"^",2)
    ..i OpAssNote'="" d 
    ...i assistants="" s assistants=assistantDr_"!"_##class(web.DHCANOPCom).GetNameById(assistantDr)
    ...e  s assistants=assistants_"#"_assistantDr_"!"_##class(web.DHCANOPCom).GetNameById(assistantDr)
    ..e  s OpAssNoteRet=assistantDr 
    ..i OpAssNote="" s OpAssNoteRet=assistantDr 
    .s operPositionId=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"POS",1)),"^")
    .i operPositionId'=""  d
    ..s operPositionDesc=$P($G(^ORC("OPPOS",operPositionId)),"^",2)
    .e  s operPositionDesc=""
    .s operPosition=operPositionId_"!"_operPositionDesc
    s opSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41) //手术编号
    s opDocNote=$P($G(^DHCANOPArrange(opaId)),"^",42)
    s opMem=$P(^DHCANOPArrange(opaId),"^",19) //手术要求
    //麻醉////////////////////////////////
    
    s anDocDr=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",6)             //ANA_Anaesthetist_Dr   麻醉医师
    i anDocDr'="" d             ;麻醉医师
    .s anDocDesc=##class(web.DHCANOPCom).GetNameById(anDocDr) 
    e  s anDocDesc=""
    s anDoc=anDocDr_"!"_anDocDesc
    s anSupDr=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",7)             //ANA_Supervisor_Dr ///ck091203
    i anSupDr'="" d         ;麻醉辅导医师
    .s anSupDesc=##class(web.DHCANOPCom).GetNameById(anSupDr)
    e  s anSupDesc=""
    s anSupDoc=anSupDr_"!"_anSupDesc
    s anNurseDr=$P(^OR(EpisodeID,"ANA",anaSub),"^",8)           //ANA_ORAnaNurse_DR     麻醉护士
    i anNurseDr'="" d
    .s anNurseDesc=##class(web.DHCANOPCom).GetNameById(anNurseDr)
    e  s anNurseDesc="" 
    s anNurse=anNurseDr_"!"_anNurseDesc 
    s opSub=0,anAssDesc="",shiftAnAssDesc=""
    f  s opSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",opSub)) q:opSub=""  d
    .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",12)'="M" 
    .s anAssStr=""
    .s anassSub=0
    .f  s anassSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS",anassSub))  q:(anassSub="")||(anassSub>20)  d
    ..s anAssDr=$g(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS",anassSub))
    ..i anAssDr'="" s anAssDesc=##class(web.DHCANOPCom).GetNameById(anAssDr)
    ..i anAssStr="" s anAssStr=anAssDr_"!"_anAssDesc
    ..e  s anAssStr=anAssStr_","_anAssDr_"!"_anAssDesc
    .s shiftAnAssStr=""
    .s anassSub=20
    .f  s anassSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS",anassSub)) q:(anassSub="")  d
    ..s shiftAnAssDr=$g(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"ANASS",anassSub))
    ..i shiftAnAssDr'="" s shiftAnAssDesc=##class(web.DHCANOPCom).GetNameById(shiftAnAssDr)
    ..i shiftAnAssStr="" s shiftAnAssStr=shiftAnAssDr_"!"_shiftAnAssDesc
    ..e  s shiftAnAssStr=shiftAnAssStr_","_shiftAnAssDr_"!"_shiftAnAssDesc
    s anMethodStr=""
    s anMethDr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)       ;ANA_Method  麻醉方法
    i anMethDr'="" d
    .s anMethNum=$l(anMethDr,"|")
    .f i=1:1:anMethNum d
    ..s anMethId=$p(anMethDr,"|",i)
    ..q:anMethId=""
    ..s anMethDesc=$p($g(^ORC("ANMET",anMethId)),"^",2)
    ..i $P(anMethDesc,"-",2)'="" s anMethDesc=$P(anMethDesc,"-",2)
    ..i anMethodStr="" s anMethodStr=anMethId_"!"_anMethDesc
    ..e  s anMethodStr=anMethodStr_","_anMethId_"!"_anMethDesc  
    s anaLevelDr=""
    s anaLevelDr=$P(^DHCANOPArrange(opaId),"^",28)
    i anaLevelDr'="" s anaLevelDesc=$P(^DHCANC("OPLevel",anaLevelDr),"^",2)
    e  s anaLevelDesc=""
    s anaLevel=anaLevelDr_"!"_anaLevelDesc
    s anDocNote=$P($G(^DHCANOPArrange(opaId)),"^",43)
    s anaTheatreInDate=$p(^OR(EpisodeID,"ANA",anaSub),"^",39)
    i anaTheatreInDate'="" s anaTheatreInDate=$zd(anaTheatreInDate,dateformatnum)
    e  s anaTheatreInDate=opStDate
    s anaTheatreInTime=$p(^OR(EpisodeID,"ANA",anaSub),"^",40)
    i anaTheatreInTime'="" s anaTheatreInTime=$zt(anaTheatreInTime,2)
    e  s anaTheatreInTime=opStTime
    s anaTheatreOutDate=$p(^OR(EpisodeID,"ANA",anaSub),"^",41)
    i anaTheatreOutDate'="" s anaTheatreOutDate=$zd(anaTheatreOutDate,dateformatnum)
    s anaTheatreOutTime=$p(^OR(EpisodeID,"ANA",anaSub),"^",42)
    i anaTheatreOutTime'="" s anaTheatreOutTime=$zt(anaTheatreOutTime,2)
    ///手术室
    s opRoomDr=$P($g(^DHCANOPArrange(opaId)),"^",20)
    s opRoomDesc=""
    i opRoomDr'="" s opRoomDesc=$P($G(^DHCANC("OPRoom",opRoomDr)),"^",2)
    s opRoom=opRoomDr_"!"_opRoomDesc
    s opaSeq=$P(^DHCANOPArrange(opaId),"^",26)                          //OPA_seq   台次               
    s sub=0 f  s sub=$o(^DHCANOPArrange(opaId,"Shift",sub)) q:sub=""  d
    .i $p(^DHCANOPArrange(opaId,"Shift",sub),"^",39)="SN" d 
    ..s scnShiftTime=$zt($p(^DHCANOPArrange(opaId,"Shift",sub),"^",19),2)
    .i $p(^DHCANOPArrange(opaId,"Shift",sub),"^",39)="CN" d
    ..s cirShiftTime=$zt($p(^DHCANOPArrange(opaId,"Shift",sub),"^",19),2) 
    
    s opSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))
    s scNurStr="",sScNurStr=""    ;洗手(器械)
    s id=0 f  s id=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",id)) q:(id="")!(id>20)  d
       .s scnDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",id),"^",1)
       .q:scnDr=""
       .i scNurStr="" s scNurStr=scnDr_"!"_$p($g(^CTPCP(scnDr,3)),"^",28)_##class(web.DHCANOPCom).GetNameById(scnDr)
       .e  s scNurStr=scNurStr_","_scnDr_"!"_$p($g(^CTPCP(scnDr,3)),"^",28)_##class(web.DHCANOPCom).GetNameById(scnDr)
    s id=20 f  s id=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",id)) q:(id="")  d
       .s scnDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",id),"^",1)
       .q:scnDr=""
       .i sScNurStr="" s sScNurStr=scnDr_"!"_$p($g(^CTPCP(scnDr,3)),"^",28)_##class(web.DHCANOPCom).GetNameById(scnDr)
       .e  s sScNurStr=sScNurStr_","_scnDr_"!"_$p($g(^CTPCP(scnDr,3)),"^",28)_##class(web.DHCANOPCom).GetNameById(scnDr)
    
    s cirNurStr="",sCirNurStr=""  ;巡床
    s id=0 f  s id=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",id)) q:(id="")!(id>20)   d
    .s cirDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",id),"^",1)
    .q:cirDr=""
    .i cirNurStr=""  s cirNurStr=cirDr_"!"_$p($g(^CTPCP(cirDr,3)),"^",28)_##class(web.DHCANOPCom).GetNameById(cirDr)
    .e  s cirNurStr=cirNurStr_","_cirDr_"!"_$p($g(^CTPCP(cirDr,3)),"^",28)_##class(web.DHCANOPCom).GetNameById(cirDr)
    s id=20 f  s id=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",id)) q:(id="")   d
       .s cirDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",id),"^",1)
       .q:cirDr=""
       .i sCirNurStr=""  s sCirNurStr=cirDr_"!"_$p($g(^CTPCP(cirDr,3)),"^",28)_##class(web.DHCANOPCom).GetNameById(cirDr)
       .e  s sCirNurStr=sCirNurStr_","_cirDr_"!"_$p($g(^CTPCP(cirDr,3)),"^",28)_##class(web.DHCANOPCom).GetNameById(cirDr)
    s scNurNote=$p($G(^DHCANOPArrange(opaId)),"^",51)           //OPA_ScrubNurseNote    器械护士,手术录入
    s cirNurNote=$p($G(^DHCANOPArrange(opaId)),"^",52)          //OPA_CirculNurseNote   巡回护士,手工录入
  
    d SetRetData
    q retStr
SetRetData
    //病人基本信息
    s patientBaseInfo=EpisodeID_"^"_patName_"^"_regNo_"^"_sex_"^"_age_"^"_locDes_"^"_ward_"^"_bedCode_"^"_admReason_"^"_telId
    //病区信息
    s patWardInfo=operLoc_"^"_appLoc_"^"_appDoc_"^"_preDiagAndNotes_"^"_postDiag_"^"_surgeon_"^"_assistants_"^"_opDocNote_"^"_opMem_"^"_bodsList_"^"_operPosition_"^"_bloodType_"^"_opSeqNote_"^"_operpermissions_"^"_operdr_"^"_opermemo_"^"_positionmemo_"^"_oneday_"^"_qiekou_"^"_qiekouId_"^"_OpAssNoteRet_"^"_operpermdengji_"^"_methedDescStr    ;.i methedId'="" s methedesc
    
    //麻醉信息
    s anaesInfo=anDoc_"^"_anSupDoc_"^"_anNurse_"^"_anAssStr_"^"_shiftAnAssStr_"^"_anMethodStr_"^"_anaLevel_"^"_anDocNote
    //手术室信息
    s opTheatreInfo=opRoom_"^"_opaSeq_"^"_scNurStr_"^"_sScNurStr_"^"_cirNurStr_"^"_sCirNurStr_"^"_scNurNote_"^"_cirNurNote 
    //手术时间
    s opDateTime=opStDate_"^"_opStTime_"^"_opArrDate_"^"_opArrTime_"^"_opEndDate_"^"_opEndTime_"^"_preDiscussDate_"^"_estiOperDuration_"^"_anaTheatreInDate_"^"_anaTheatreInTime_"^"_anaTheatreOutDate_"^"_anaTheatreOutTime_"^"_scnShiftTime_"^"_cirShiftTime
    //

    b ;"SetRetData"
    s retStr=patientBaseInfo_"@"_patWardInfo_"@"_anaesInfo_"@"_opTheatreInfo_"@"_opDateTime
}

/// d ##class(%ResultSet).RunQuery("web.UDHCANOPArrangeClinics","FindOpResourceInfo","1")
/// Creator: 		lyn
/// Description:	通过手术室查找门诊手术室所有可用的资源信息
/// Input:			LocId:s手术室Id
/// Output:			分类Code 分类描述
/// Table：			RB_Resource（资源表）RB_ApptSchedule（资源子表），
/// 				DHC_RBApptSchedule（资源字表扩展表）AS_QueueNo（资源是否有效表）
/// d ##class(%ResultSet).RunQuery("web.DHCANOPArrangeClinics","FindOpResource","553","")
Query FindOpResource(LocId As %String = "", startDate As %String = "") As %Query(ROWSPEC = "rowId,resourceDesc,asSessStartTime,calDuration")
{
}

ClassMethod FindOpResourceExecute(ByRef qHandle As %Binary, LocId As %String = "", startDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s rowId="",resourceDesc="",asSessStartTime=""
	i LocId="" s qHandle=$lb(0,repid,0) Quit $$$OK
	s ^LYNTMP(LocId)=LocId_","_startDate
	i startDate'="" s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	e  s startDate=+$h
	f  s rowId=$o(^RB("RES",0,"CTLOC",LocId,rowId)) q:rowId=""  d  //遍历资源表数据
		.q:'$d(^RB("RES",rowId))
		.s rsScheduleRequired=$p(^RB("RES",rowId),"^",6)
		.s resourceDesc=$p(^RB("RES",rowId),"^",17) //资源描述
		.q:rsScheduleRequired'="Y"
		.s subRowId=0
		.i rowId=14906 b
		.f  s subRowId=$O(^RBAS(rowId,subRowId)) Q:subRowId=""  d //遍历字表数据
			..q:'$d(^RBAS(rowId,subRowId))
			..q:'$d(^RBAS(rowId,subRowId,"DHC"))
			..s ASDate=$p(^RBAS(rowId,subRowId),"^",1) //排班日期
			..q:startDate'=ASDate
			..s resourceId=rowId_"||"_subRowId
			..s resourceDesc=$p(^RB("RES",rowId),"^",17) //资源描述
			..s asLoad=$p(^RBAS(rowId,subRowId),"^",8)
			..s asQueueNo=$P($g(^RBAS(rowId,subRowId,"DHC")),"^",4)
			..s asSessStartTime=$p(^RBAS(rowId,subRowId),"^",4) //开始时间
			..s asSessEndTime=$p(^RBAS(rowId,subRowId),"^",5) //结束时间
			..i rowId=14906 b
			..s asTimeRangeDr=$P($g(^RBAS(rowId,subRowId,"DHC")),"^",17) //排班时段
			..s asTimeRangeDesc=$p($g(^DHCTimeRange(asTimeRangeDr)),"^",2)
			..s calDuration=##class(web.DHCClinicCom).CalculateDuration(ASDate,asSessStartTime,ASDate,asSessEndTime,"M") //计算两个时间的时间差,返回时间为两个
			..s resourceDesc=resourceDesc_"  "_asTimeRangeDesc
			..i +asSessStartTime'=0 s asSessStartTime=##class(web.DHCClinicCom).ConvertToTime(asSessStartTime)
			..s rbasRowid=rowId_"||"_subRowId
			..;b ;01
	 		..Do Output2	
     Set qHandle=$lb(0,repid,0)
	 Quit $$$OK

Output2
 set Data=$lb(rbasRowid,resourceDesc,asSessStartTime,calDuration)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod FindOpResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOpResourceExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindOpResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOpResourceExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// d ##class(web.DHCANOPArrangeClinics).setvalue()
ClassMethod setvalue()
{
	k PLIST
	s PLIST(5)=48600 
	s PLIST(6)=61200
	&sql(INSERT INTO sqluser.RB_ApptSchedule Values :PLIST())
	W SQLCODE
}

/// creator:		LYN
/// CreatDate:		20160411
/// Descripation:	判断当前选择的手术资源获取当前资源使用的情况
/// Input:			资源ID
/// Return: 		asLoad_"|"_unUseLoad_"|"_useLoad
/// 					资源总数|未使用资源|已使用资源数|第一个未用号源
/// Table:			RB_ApptSchedule  DHC_RBApptSchedule  
/// w ##class(web.DHCANOPArrangeClinics).JudgeResourceEffect("467||1")
ClassMethod JudgeResourceEffect(ASRowId As %String) As %String
{
	q:ASRowId="" 0
	s asResRowId=$p(ASRowId,"||",1)
	s asChildSub=$p(ASRowId,"||",2)
	q:'$d(^RBAS(asResRowId,asChildSub)) 0
	q:'$d(^RBAS(asResRowId,asChildSub,"DHC")) 0
	s ret=0
	s asLoad=$p(^RBAS(asResRowId,asChildSub),"^",8)  //预约资源总数
	//s useLoad=0  //已经使用了多少资源
	//s unUseLoad=0 //未使用资源总数
	s asQueueNo=$P($g(^RBAS(asResRowId,asChildSub,"DHC")),"^",4)
	s firstUnUseNo=""
	s ^NUMCount("Unuse")=0
	f i=1:1:(+asLoad) d
		.s useFlag=$p($p(asQueueNo,",",i),":",2)
		.i +useFlag=0 d 
			..s ^NUMCount("Unuse")=$g(^NUMCount("Unuse"))+1
			..i firstUnUseNo="" s firstUnUseNo=i
	s unUseLoad=$g(^NUMCount("Unuse"))
	s useLoad=asLoad-unUseLoad
	q asLoad_"|"_unUseLoad_"|"_useLoad_"|"_firstUnUseNo
}

/// 设置手术的分类
/// d ##class(web.DHCANOPArrangeClinics).SetOperCat()
ClassMethod SetOperCat()
{
	for i=1:1:5 d
	.S $p(^ORC("OPER",i,"DHC"),"^",16)=1
	for i=6:1:8 d
	.S $p(^ORC("OPER",i,"DHC"),"^",16)=2
}

/// d ##class(%ResultSet).RunQuery("web.UDHCANOPArrangeClinics","FindOpResourceInfo","1")
/// Creator: 		lyn
/// Description:	通过手术资源id获得当前未使用的资源数
/// Input:			资源ID
/// Output:			分类Code 分类描述
/// Table：			RB_Resource（资源表）RB_ApptSchedule（资源子表），
/// 				DHC_RBApptSchedule（资源字表扩展表）AS_QueueNo（资源是否有效表）
/// d ##class(%ResultSet).RunQuery("web.DHCANOPArrangeClinics","FindNumResource","43")
Query FindNumResource(RBASId As %String = "") As %Query(ROWSPEC = "Id,Desc")
{
}

ClassMethod FindNumResourceExecute(ByRef qHandle As %Binary, RBASId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s rowId="",resourceDesc="",asSessStartTime=""
	if RBASId="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s asResRowId=$p(RBASId,"||",1)
	s asChildSub=$p(RBASId,"||",2)
	s asQueueNo=$P($g(^RBAS(asResRowId,asChildSub,"DHC")),"^",4)
	s asLoad=$p(^RBAS(asResRowId,asChildSub),"^",8)  //预约资源总数
	f i=1:1:(+asLoad) d
		.s useFlag=$p($p(asQueueNo,",",i),":",2)
		.q:useFlag=1
		.s Id=i
		.s Desc=i
		.d Output2
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK

Output2
 set Data=$lb(Id,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
	quit
}

ClassMethod FindNumResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindNumResourceExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod FindNumResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindNumResourceExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {				// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {				// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 // Save QHandle
 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:		lyn
/// CreatDate:		2016/04/12
/// Descripation:	根据每台手术的平均时长，获取每个资源对应的手术时间
/// Input:			FristStartT（手术资源第一个开始时间）, PerTime (以分钟为单位), LoadNo（号源）
/// Output:			返回结算后的结束时间，保留到分钟
/// d ##class(web.DHCANOPArrangeClinics).GetClinicOperStartTime()
ClassMethod GetClinicOperStartTime(FristStartT As %String, PerTime As %String, LoadNo As %String) As %String
{
	q:(FristStartT="")!(PerTime="")!(LoadNo="") ""
}

/// Creator:		lyn
/// CreatDate:		2016/04/10
/// Descripation:	更新手术资源的号源使用状态
/// Input:			RBASId（资源ID）, LoadNo（号源）, Status (状态)
/// Output:			返回结算后的结束时间，保留到分钟
/// w ##class(web.DHCANOPArrangeClinics).UpdateOpSequenceNoStat("1||1","1",1)
ClassMethod UpdateOpSequenceNoStat(RBASId As %String, QueueNo As %String, Status As %String) As %String
{
	q:(RBASId="")!(QueueNo="") -1
	q:(+Status'=0)&&(+Status'=1) -1
	s asResRowId=$p(RBASId,"||",1)
	s asChildSub=$p(RBASId,"||",2)
	lock ^RBAS(asResRowId,asChildSub):10
	s asQueueNo=$P($g(^RBAS(asResRowId,asChildSub,"DHC")),"^",4)
	s asLoad=$p($g(^RBAS(asResRowId,asChildSub)),"^",8)  //预约资源总数
	s updateFlag=0
	f i=1:1:(+asLoad) d
		.q:updateFlag=1
		.s queueNo=$p($p(asQueueNo,",",i),":",1)
		.q:QueueNo'=queueNo
		.s queueNoSta=$p(asQueueNo,",",i)
		.i (Status=1)&&($p(queueNoSta,":",2)=Status) s updateFlag=2
		.q:updateFlag=2
		.s $p(queueNoSta,":",2)=+Status
		.s $p(asQueueNo,",",i)=queueNoSta
		.s updateFlag=1
	s $P(^RBAS(asResRowId,asChildSub,"DHC"),"^",4)=asQueueNo
	lock -^RBAS(asResRowId,asChildSub):5
	//w asQueueNo,!
	s ^LYNTMP("RBAS")=asQueueNo
	q updateFlag
}

/// Creator: 		LYN
/// CreatDate:		20160415
/// Descripation: 	根据门诊预约的号源和总时长计算出手术的开始时间以及通知病人的来院时间
/// Input:			RSLoad(预约号源总数),StartDate(手术预约日期),StartTime(手术预约时间)
/// 					(RSQueueNo)预约号
/// 					tranFlag(返回的时间格式是否需要转换0:不转换时间格式,1:转换时间格式)
/// Output:			病人来院时间和手术预约时间
/// w ##class(web.DHCANOPArrangeClinics).GetOPStartTimeByResource("9066||957","2016-04-26",1,1)
ClassMethod GetOPStartTimeByResource(RBASId As %String, StartDate As %String = "", RSQueueNo As %String = "", tranFlag As %String = 0, startTime As %String = "") As %String
{
	q:(RBASId="") "-1^手术资源有误"
	q:(RSQueueNo="") "-1^计算时长时出现参数错误"
	s asResRowId=$p(RBASId,"||",1)
	s asChildSub=$p(RBASId,"||",2)

	i StartDate'="" s StartDate=##class(web.DHCClinicCom).ConvertToDateH(StartDate)
	e  s StartDate=+$h
	s asResRowId=+asResRowId
	s asChildSub=+asChildSub
	s RSLoad=$p($g(^RBAS(+asResRowId,+asChildSub)),"^",8) ;预约资源总数
	s ASDate=$p(^RBAS(+asResRowId,+asChildSub),"^",1) 			;排班日期
	q:(StartDate'=ASDate) "-1^当前日期没有排班"
	
	i startTime="" s asSessStartTime=$p(^RBAS(asResRowId,asChildSub),"^",4) ;开始时间
	e  s asSessStartTime=startTime
	;b
	s asSessEndTime=$p(^RBAS(asResRowId,asChildSub),"^",5) ;结束时间
	q:(asSessEndTime<=asSessStartTime) "-1^排班日期出现问题"
	s calDuration=##class(web.DHCClinicCom).CalculateDuration(ASDate,asSessStartTime,ASDate,asSessEndTime) //计算两个时间的时间差,返回时间为两个
	;s asSessStartTime=$p(^RBAS(asResRowId,asChildSub),"^",4) ;开始时间
	b
	s StartTime=##class(web.DHCClinicCom).ConvertToTimeH(asSessStartTime)
	s comeHosTime="",orderOpTime="",orderDate="",comeDate=""
	s perTime=calDuration/RSLoad 		;个预约号平均使用时间
	s perTime=perTime/3600
	s orderOpTime=##class(web.DHCClinicCom).getPreDateTime(StartDate,StartTime,"+",perTime*(RSQueueNo-1))
	s orderTime=$p(orderOpTime," ",2)
	s orderDate=$p(orderOpTime," ",1)
	;b
	s comeHosTime=##class(web.DHCClinicCom).getPreDateTime(orderDate,orderTime,"-",.5)
	i +tranFlag=0 q comeHosTime_"||"_orderOpTime
	s orderDate=##class(web.DHCClinicCom).ConvertToDate(orderDate)
	i +orderTime=0 s orderTime="0:00"
	i +orderTime'=0  s orderTime=##class(web.DHCClinicCom).ConvertToTime(orderTime)
	s orderTime=..TimeRound(orderTime,15)
	
	s comeDate=##class(web.DHCClinicCom).ConvertToDate($p(comeHosTime," ",1))
	i +$p(comeHosTime," ",2)'=0 s comeTime=##class(web.DHCClinicCom).ConvertToTime($p(comeHosTime," ",2))
	s comeTime=..TimeRound(comeTime,15)
	;b
	//comeDate comeTime 已停用
	q comeDate_" "_comeTime_"||"_orderDate_" "_orderTime
}

/// Creator:		lyn
/// CreatDate:		2016/04/18
/// Descripation:	设置门诊申请科室信息或者申请医生的配置信息
/// 					手术总时长(hours)
/// 	Global			^DHCANOPArrangeClinic("AppLoc",locId)  
/// 	Global			^DHCANOPArrangeClinic("AppDoc",userId)  //医生的信息问题
/// Input:			LocId(科室Id),userId(申请医生Id)
/// Output:			返回结算后的结束时间，保留到分钟
ClassMethod SetClinicsOpAppInfo(LocId As %String)
{
	s ^DHCANOPArrangeClinic("AppLoc",63)=3.5
	s ^DHCANOPArrangeClinic("AppDoc",600)=3.5
}

/// Creator:		lyn
/// CreatDate:		2016/04/18
/// Descripation:	设置门诊申请科室信息或者申请医生的配置信息
/// 					手术总时长(hours)
/// 	Global			^DHCANOPArrangeClinic("AppLoc",locId)  
/// 	Global			^DHCANOPArrangeClinic("AppDoc",userId)  //医生的信息问题
/// Input:			LocId(科室Id),userId(申请医生Id)
/// Output:			返回结算后的结束时间，保留到分钟
ClassMethod GetClinicsOpAppInfo(LocId As %String, DocUserId As %String)
{
	s retStr=""
	q:(LocId="")&&(DocUserId="") retStr
	
	i LocId'="" s retStr=$g(^DHCANOPArrangeClinic("AppLoc",LocId))
	i DocUserId'="" s retStr=$g(^DHCANOPArrangeClinic("AppDoc",DocUserId))
	q retStr
}

/// creator:LYN
/// CreatDate:20160418
/// 根据手术室获取手术间信息
/// D ##class(%ResultSet).RunQuery("web.DHCANOPArrangeClinics","FindAncOperRoomNew","N","480","","","","437")
/// input: oprDesc-手术间模糊查询输入项; opaId-手术申请记录ID 
/// 			opLoc-手术室 ; locListCodeStr-手术室的科室列表 ; oprBedType-床位类型 ;appLocDescOrId-申请科室ID
Query FindAncOperRoomNew(oprDesc As %String, opLoc As %String, locListCodeStr As %String = "", opaId As %String = "", oprBedType As %String = "", appLocDescOrId As %String = "") As %Query(ROWSPEC = "oprId:%String,oprDesc:%String,oprCode:%String")
{
}

ClassMethod FindAncOperRoomNewExecute(ByRef qHandle As %Binary, needOprDesc As %String = "", opLoc As %String = "", locListCodeStr As %String = "OP^OUTOP^EMOP", opaId As %String = "", oprBedType As %String = "T", appLocDescOrId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	k oprIdList
	i opaId'="" d
		.s opaStartDate=$p($g(^DHCANOPArrange(opaId)),"^",14)
		.q:opaStartDate=""
		.s opaId=""
	    .f  s opaId=$O(^DHCANOPArrange(0,"SDate",+opaStartDate,opaId)) q:opaId=""  d 
		    ..q:'$d(^DHCANOPArrange(opaId))
		    ..s oprId=$p($g(^DHCANOPArrange(+opaId)),"^",20)
		    ..i oprId'="" s oprIdList(oprId)=$g(oprIdList(oprId))+1
 	s appLocId="",opTheaterId=""
 	
 	i appLocDescOrId'="" d  ;根据申请科室获得手术室ID
 		.i appLocDescOrId=+appLocDescOrId s appLocId=appLocDescOrId
 		.e  d
			..s appLocDesc=$$ALPHAUP^SSUTIL4(appLocDescOrId)
			..s appLocId=$o(^CTLOC(0,"Desc",appLocDesc,""))
	i appLocId '="" d
		.s defalultoperLocDesc=##class(web.DHCANOPCom).GetLocDefaultOpRoomByLocId(appLocId) //获取当前申请科室默认的手术室
		.s opTheaterId=$p($g(defalultoperLocDesc),"^",1)	
	i opLoc'="" s opTheaterId=opLoc
	i opTheaterId'="" d
		.s oprId=0 
		.f  s oprId=$o(^DHCANC("OPRoom",0,"CtLoc",opTheaterId,oprId)) q:oprId=""  d
			..d getRoomInfo
	e  d
		.s oprId=0 
		.f  s oprId=$o(^DHCANC("OPRoom",oprId)) q:oprId=""  d
			..d getRoomInfo

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
getRoomInfo
	q:(oprBedType'="")&(oprBedType'[$p(^DHCANC("OPRoom",oprId),"^",9)) 
	q:$p(^DHCANC("OPRoom",oprId),"^",7)="N"  ;停用的手术间不再搜索出来
	s oprDesc=$P(^DHCANC("OPRoom",oprId),"^",2)
	;q:(needOprDesc'="")&($p(oprDesc,needOprDesc)'="")
	q:(needOprDesc'="")&(oprDesc'[needOprDesc)
	i $d(oprIdList(oprId)) s oprDesc=oprDesc_"("_oprIdList(oprId)_"台)"
	s oprCode=$P(^DHCANC("OPRoom",oprId),"^",1)
	Do OutputRow10
	q
OutputRow10
	set Data=$lb(oprId,oprDesc,oprCode)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod FindAncOperRoomNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAncOperRoomNewExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else {				// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindAncOperRoomNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAncOperRoomNewExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 根据Code获取血型
/// w ##class(web.DHCANOPArrangeClinics).GetBloodType("X")
ClassMethod GetBloodType(Code As %String) As %String
{
	q:Code="" ""
	q:'$d(^PAC("BLDT",0,"Code","X")) ""
	s btId=$o(^PAC("BLDT",0,"Code",Code,""))
	s desc=$p(^PAC("BLDT",btId),"^",2) 
	Q btId_"!"_desc
}

/// Creator: 		Lyn
/// CreatDate: 		20160422
/// Input:			Time时间,RoundM-四舍五入的长度（以分钟为单位，默认值15分钟）
/// Output:			returnDate前、后几小时日期,returnTime前、后几小时时间
/// Desc：			根据输入的日期时间,将时间四舍五入（以15分钟为阶段）
/// w ##class(web.DHCANOPArrangeClinics).TimeRound("0","15")
ClassMethod TimeRound(Time As %String, TimeR As %String = "15") As %String
{
	q:Time="" 
	s timeHH=+$p(Time,":",1)
	s timeMM=+$p(Time,":",2)
	s retTime=Time
	
	i +timeMM<15 s $p(Time,":",2)="00"
	;b ;00
	i (+timeMM'<15)&&(+timeMM<30) s $p(retTime,":",2)="15"
	;b ;01
	i (+timeMM'<30)&&(+timeMM<45) s $p(retTime,":",2)="30"
	;b ;02
	i (+timeMM'<45)&&(+timeMM<60) s $p(retTime,":",2)="45"
	s retTime=$e(retTime,1,5)
	q retTime
}

ClassMethod updatewardRecord(itmjs As %Library.String = "", itmjsex As %Library.String = "", opaId As %String, str1 As %String, op As %String, ass As %String, strcheck As %String, anmetId As %String = "", operpermissions As %String = "", opermemo As %String = "", positionmemo As %String = "", oneday As %String = "", qiekou As %String = "", appType As %String = "", strClinic As %String = "") As %String
{
    
   //病区填写
    ;k (str1,anmthid,andocid,op,ass,scr,cir)
    s userId=%session.Data("LOGON.USERID")
    s ctcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
    s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
    s ctcptType=$p(^CT("CPT",ctcptId),"^",4)
    s locId=$p($g(^DHCANOPArrange(opaId)),"^",54) 
    s docLocId=%session.Data("LOGON.CTLOCID")
    q:(docLocId'=locId)&(ctcptType="DOCTOR") "医生不能修改非本科室手术"  
    k PLIST
    //s strcheck="阴性^阴性^阴性^阴性^0^阴性"
    &sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
    i SQLCODE  q "未找到手术申请记录!"
    s OPDate=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3))
    s AppDate=PLIST(13)
    i OPDate<AppDate q "手术日期不能小于申请日期!"
    
    s appCtcpId=$P(^DHCANOPArrange(opaId),"^",6) //申请医生ID
    q:$P(str1,"^",2)'=appCtcpId "非本人不能修改手术"
    
    TSTART
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    s opdate=$P(^DHCANOPArrange(opaId),"^",14)
    
    //门诊预约手术号源 （暂未使用）
	s opResource=$P(strClinic,"^",2) 	;手术预约资源
	s opQueueNo=$P(strClinic,"^",3) 	;手术预约号
	s totalH=0 ,opstartTime="" ;手术总时长;手术开始时间
	s comHospDT="",opStartDT="",opStartTime=""
	s comeHosDT=$P(strClinic,"^",4) ;患者来院时间
	s comeHosDate=##class(web.DHCClinicCom).ConvertToDateH($p(comeHosDT," ",1))
	s comeHosTime=##class(web.DHCClinicCom).ConvertToTimeH($p(comeHosDT," ",2))
	/*
	i +opQueueNo=0 d
		.s retLoadStr=##class(web.DHCANOPArrangeClinics).JudgeResourceEffect(opResource)
		.s opQueueNo=$p(retLoadStr,"|",4)
		.s retDTStr=##class(web.DHCANOPArrangeClinics).GetOPStartTimeByResource(opResource,$P(str1,"^",3),opQueueNo,1)
		.s ^tmpYpz("OPDT")=retDTStr
		.i +retDTStr>0 d
		..//s comeHosTime=$P(retDTStr,"||",1)
		..s opStartDT=$P(retDTStr,"||",2)
		..s opStartTime=$p(opStartDT," ",2)
	e  s opStartTime=$P(str1,"^",4) ;设置手术开始时间
	*/
	s opStartTime=$P(str1,"^",4) ;设置手术开始时间  上面时间段设置后，此句话当删除
	s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
    s PLIST(7)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3)) // starD
    i (PLIST(7)<$h)&(opaStatus="A")  TRollBack  q "手术日期不能早于系统日期!"	//20160908+dyl
    s PLIST(9)=##class(web.DHCANOPCom).ConvertToTimeH(opStartTime,"") //手术申请时间不填写
    //s PLIST(5)=$P(str1,"^",7)                               //OPA_OpRoom_dr 如维护手术间默认使用科室,申请时自动填入手术间
    s PLIST(12)=$P(str1,"^",2)                              //OPA_AppCtcp_Dr 申请医生
    //s PLIST(3)=$P(str1,"^",1)                             //ypz 070530 病人科室不变,便于统计
    s PLIST(19)=$P(str1,"^",8)                              //OPA_Memo      备注-手术要求
    s groupId=%session.Data("LOGON.GROUPID")                //科主任审核
    
    i PLIST(20)="" d
    .i $G(^DHCCLSet("AnOp","DirAudit"))'="" d
    ..i $G(^DHCCLSet("AnOp","DirAudit"))[groupId d
    ...s PLIST(20)="A"
    s adm=$P(str1,"^",6)                                    //WKZ 071226 S  血型更新
    s BldTyId=$P(str1,"^",9)
    s PLIST(28)=$P(strcheck,"^",7)                          //OPA_RHBloodType   RH血型                            
    s PLIST(29)=$P(strcheck,"^",8)                          //OPA_Isolated      是否隔离
    s PLIST(34)=$P(strcheck,"^",9)                          //OPA_PrepareBlood  是否备血
    s PLIST(35)=$P(strcheck,"^",10)                         //OPA_UseSelfBlood  是否自体血回输
    s PLIST(37)=$P(strcheck,"^",11)                         //OPA_ExCirculation 是否体外循环
    s PLIST(45)=$P(strcheck,"^",12)                         //OPA_NeedAnaesthetist是否麻醉会诊
    s PLIST(24)=$P(strcheck,"^",13)                         //OPA_MiniInvasive  是否微创手术
    s PLIST(56)=$p(strcheck,"^",14)                         //OPA_Navigation 是否导航 zhangtao 2010.8.6
    s PLIST(285)=$p(strcheck,"^",15)
    s PLIST(27)=BldTyId                                     //OPA_BloodType_Dr  血型
    s PLIST(193)=$P(strcheck,"^",1)                         //OPA_PATestHBsAg   免疫乙肝表面抗原
    s PLIST(198)=$P(strcheck,"^",2)                         //OPA_PATestHCVAb   免疫丙型肝炎抗体
    s PLIST(199)=$P(strcheck,"^",3)                         //OPA_PATestHivAb   免疫艾滋病毒抗体
    s PLIST(200)=$P(strcheck,"^",4)                         //OPA_PATestTPAb    免疫梅毒
    s PLIST(166)=$P(strcheck,"^",6)                         //OPA_PATestOther   检验其它阴阳性
    //s PLIST(21)=$P(str1,"^",11)                             //OPA_OPLevel_Dr    麻醉规模
    s PLIST(25)=$P(str1,"^",12)                             //OPA_PatHeight     身高
    s PLIST(26)=$P(str1,"^",13)                             //OPA_PatWeight     体重
    s PLIST(38)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",15),"") //OPA_EstiOperDuration
    s PLIST(39)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",14),"") //OPA_PreDiscussDate
    s PLIST(43)=$P(str1,"^",16)                             //OPA_OpDocNote 实习医生,手术医师备注
    s PLIST(42)=$P(str1,"^",17)                             //OPA_SeqNote   手术编号,医生手术申请编号
    //s PLIST(6)=$P(str1,"^",18)                              //OPA_Seq       台次
    s PLIST(54)=$P(str1,"^",21)                             //OPA_MedInfect 院感
    s PLIST(40)=$P(str1,"^",22)                             //OPA_TransferMeans 接病人方式
    i PLIST(20)="A" s PLIST(149)=anmetId      s ^TEMPWHL("anmetId")=anmetId              //OPA_PAAnaestType 拟施麻醉方式
     
    &sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
    i SQLCODE TRollBack  q "修改手术申请错误!"
    
    ///091204 ck
    s anaNotesList=$lb("")
    s anaNotesList=$lb($p(op,"^",4))
    s SourceType=$P(strcheck,"^",5)                         //ANA_SourceType 急诊(E)/择期(B)    
    i SourceType=1  s anaSourceType="E"
    e  s anaSourceType="B"
    s opstdate=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3))       //ANA_TheatreInDate 手术开始日期
    s opstTime=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4),"")    //ANA_TheatreInTime 手术开始时间
    &sql(update SQLUSER.OR_Anaesthesia set ANA_Notes=:anaNotesList,ANA_SourceType=:anaSourceType,ANA_TheatreInDate=:opstdate,ANA_TheatreInTime=:opstTime where ANA_RowId=:anaId)
    i SQLCODE'=0 TRollBack  q "修改诊断备注或急诊手术错误!" 
    ;i anmetId'="" &sql(update SQLUSER.OR_Anaesthesia set ANA_Method=:anmetId where ANA_RowId=:anaId)
    ;i SQLCODE'=0 TRollBack  q "修改麻醉方式错误!" //ypz 070405 外科医生填写麻醉方式 
    //保存多个麻醉方法
    s adm=$p(anaId,"||",1)
    s anachl=$p(anaId,"||",2)
    i anmetId'="" s $P(^OR(adm,"ANA",anachl),"^",5)=anmetId 
    
    s adm=$P(anaId,"||",1)
    s anaSub=$P(anaId,"||",2)
    s anaopSub=0  s anaopSub=$O(^OR(adm,"ANA",anaSub,"OP",anaopSub)) 
    i anaopSub="" TRollBack  q "未找到病人的手术定义!"
    s anaopId=anaId_"||"_anaopSub
    k PLIST //op=opid+"^"+diagid+"^"+opdocid+"^"+diagmem+"^"+operLoction
    &sql(select * into :PLIST() from SQLUSER.OR_Anaest_Operation where anaop_rowid=:anaopId)
    i SQLCODE TRollBack  q "手术记录查找错误!"
    s PLIST(6)=""
    s PLIST(7)=""
    s diagIdS=$p($P(op,"^",2),"|",1)
    s diagIdS=$tr(diagIdS,",","$") //主要为了兼容以前的程序，以前是以"$"分隔的，现在前台以","分隔，故替换
    s preDiagIdS=$p(diagIdS,"/",1)
    s postDiagId=$p(diagIdS,"/",2)
    i $l(diagIdS,"/")=1  d
    .i diagIdS'=""  d    //术前诊断Id
    ..i diagIdS=+diagIdS s PLIST(6)=$p($P(op,"^",2),"|",1)
    ..e  s PLIST(6)=""
    .s PLIST(7)=""
    i $l(diagIdS,"/")=2  d
    .i preDiagIdS'=""  d
    ..i preDiagIdS=+preDiagIdS s PLIST(6)=preDiagIdS
    ..e  s PLIST(6)=""
    .e  s PLIST(6)=""

    i postDiagId'=""  d      //术后诊断ID
    .i postDiagId=+postDiagId s PLIST(7)=postDiagId
    .e  s PLIST(7)=""
    q:($p($P(op,"^",1),"|",1)="")&($p($P(op,"^",1),"|",3)="") "手术名称或手术备注为空!"
    i $p($p(op,"^",1),"|",1)'="" d
    ;s PLIST(9)=$p($p(op,"^",1),"|",1)
    i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
    .s PLIST(9)="" //20101029 zhangtao
    e  s PLIST(9)=$p($P(op,"^",1),"|",1)
    s PLIST(8)=$lb($p($p(op,"^",1),"|",3))
    s bldtpCode=$p($p(op,"^",1),"|",4)                  //+wxl 091215 手术刀口类型 ANAOP_Blade_DR->ORC_BladeType
    s bldtpId=""
    i bldtpCode'="" d
    .i bldtpCode=+bldtpCode s bldtpId=bldtpCode q
    .s bldtpCode=$$ALPHAUP^SSUTIL4(bldtpCode)
    .q:bldtpCode=""
    .s bldtpId=$o(^ORC("BLDTP",0,"Code",bldtpCode,""))
    s PLIST(12)=bldtpId
    ;s PLIST(6)=$P(op,"^",2)
    ;s PLIST(9)=$P(op,"^",1)
    s PLIST(11)=$P(op,"^",3)
    s ctlocDesc=$$ALPHAUP^SSUTIL4($P(op,"^",5)),ctlocId="" //ypz 070316
    i ctlocDesc'="" s ctlocId=$o(^CTLOC(0,"Desc",ctlocDesc,"")) //ypz 070316
    i $P(op,"^",5)=+$P(op,"^",5) s ctlocId=$P(op,"^",5)  //ypz 091118
    s PLIST(13)=ctlocId  //ypz 070316   
    s PLIST(27)=""                  //现ANAOP_AreaInTime与ANAOP_BodySite_DR同一节点
    s PLIST(42)=""                  //ANAOP_AreaInTime暂不使用,ANAOP_BodySite_DR含|不直接保存
    &sql(update sqluser.OR_Anaest_Operation Values :PLIST() where anaop_rowid=:anaopId)
    //w "oper update="_SQLCODE,!
    i SQLCODE'=0 TRollBack  q "修改手术信息错误!"
    //保存多个手术部位于Global中
    i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
        .s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",0)=2
        .;s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",1)=$lb($p($p(op,"^",1),"|",3))
        .s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",2)=$p($p(op,"^",1),"|",1)
    s ^OR(adm,"ANA",anaSub,"TXT",0)=3                  //zhangtao add
    s preDiagS="",preDiagN=""                                          
    i $l(diagIdS,"/")=1  d
    .i diagIdS'=""  d    //术前诊断Id
    ..s dNum=$l(diagIdS,"$")
    ..f i=1:1:dNum d
    ...s diagId=$p(diagIdS,"$",i)
    ...q:diagId=""
    ...i diagId=+diagId s $p(preDiagS,"|",i)=diagId
    ...e  d
    ....s $p(preDiagS,"|",i)=""
    ....s $p(preDiagN,"|",i)=diagId
    i $l(diagIdS,"/")=2  d
    .i preDiagIdS'=""  d
    ..s dNum=$l(preDiagIdS,"$")
    ..f i=1:1:dNum d
    ...s preDiagId=$p(preDiagIdS,"$",i)
    ...i preDiagId=+preDiagId s $p(preDiagS,"|",i)=preDiagId
    ...e  d 
    ....s $p(preDiagS,"|",i)=""    
    ....s $p(preDiagN,"|",i)=preDiagId
    .i postDiagId'=""  d      //术后诊断ID
    ..i postDiagId'=+postDiagId s ^OR(adm,"ANA",anaSub,"TXT",3)=postDiagId
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub),"^",4)=preDiagS  
    s ^OR(adm,"ANA",anaSub,"TXT",2)=preDiagN   //zhangtao add
    s bodySiteId=$P(op,"^",6)
    s bodsDesc="" //liangq 20101105
    i bodySiteId'="" d
    .s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub),"^",24)=bodySiteId
    .s bodsIdNum=$l(bodySiteId,"|")
    .f i=1:1:bodsIdNum d
    ..s curBodsId=$p(bodySiteId,"|",i)
    ..q:curBodsId=""
    ..i bodsDesc="" s bodsDesc=$p($g(^OEC("BODS",+curBodsId)),"^",2)
    ..e  s bodsDesc=bodsDesc_","_$p($g(^OEC("BODS",+curBodsId)),"^",2)

    s ancoplCode=$p($p(op,"^",1),"|",2)                             //+wxl 091215 保存手术级别->ORC_OperationCategay 
    s ancoplId=""
    i ancoplCode'="" d
    .i ancoplCode=+ancoplCode s ancoplId=ancoplCode q
    .s ancoplCode=$$ALPHAUP^SSUTIL4(ancoplCode)
    .///s ancoplId=$o(^DHCANC("OPLevel",0,"Code",ancoplCode,""))
    .s ancoplId=$o(^ORC("CATEG",0,"Code",ancoplCode,""))  			//update by lyn 20160811
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",1)=ancoplId  //+wxl 091215 
    
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",4)=operpermissions   //whl20140520  手术权限
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",5)=opermemo  //whl20140520   术式备注
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",6)=positionmemo  //whl20140520    手术部位备注
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",7)=oneday    //whl20140520    一日病房
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",8)=qiekou    //whl20140520    手术切口
    s doc=$p($g(op),"^",3)   //add by  csq 
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",11)=doc  //csq 2015-07-30  手术医生 
    s ssjb=$p($g(op),"^",8)   
    i ssjb="" s ssjb=0
    i ssjb["一" s ssjb=1
    i ssjb["二" s ssjb=2
    i ssjb["三" s ssjb=3
    i ssjb["四" s ssjb=4
    i ssjb["五" s ssjb=5
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",9)=ssjb  //csq 2015-07-30   手术级别
    s jzbj=$p($g(op),"^",9)   //add by  csq 
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",10)=jzbj //csq 2015-07-30   急诊标记 
    s ssyz=$p($g(op),"^",10)   //add by  csq 
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",12)=ssyz //csq 2015-07-30   手术一助 
    s ssez=$p($g(op),"^",11)
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",13)=ssez //csq 2015-07-30   手术二助
    s sssz=$p($g(op),"^",12) 
    s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",14)=sssz //csq 2015-07-30   手术三助 
    
    ;s ^TEMPWHL("whl20140520")=operpermissions_"^"_opermemo_"^"_positionmemo_"^"_oneday_"^"_qiekou
    
    i $d(^OR(adm,"ANA",anaSub,"OP",1,"ASS"))>0 k ^OR(adm,"ANA",anaSub,"OP",1,"ASS")  //&sql(delete from sqluser.OR_An_Oper_Assistant where opas_parref=:anaopId)
    //w "oper asst="_SQLCODE,!

    s operPositionId=$P(op,"^",7)
    i operPositionId'="" d
    .s PLIST(0)=anaopId
    .s PLIST(3)=operPositionId
    .i $D(^OR($P(anaopId,"||"),"ANA",$P(anaopId,"||",2),"OP",$P(anaopId,"||",3),"POS"))'=0 d
    ..s opRowId=anaopId_"||"_1
    ..&sql(update sqluser.OR_An_Oper_Position set OPPOS_Position_DR=:operPositionId where OPPOS_RowId=:opRowId)
    .e  &sql(INSERT INTO sqluser.OR_An_Oper_Position Values :PLIST())
    i SQLCODE'=0 TRollBack  q "插入体位表错误!"
    
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s anaopSub=0
    f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
        .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
        .q:ass=""
        .s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",0)=100
        .s num=$L(ass,"^")
        .//s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",0)=num
        .for i=1:1:num d
            ..i $p(ass,"^",i)'=""  d
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",i)=$P(ass,"^",i)
            ..e  d
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",i)=""
   
    s arcimId=$g(^DHCCLSet("AnOp","AppArcimId")) 
    
	//************门诊插入主诉和资源******************
	//add by lyn
	s selfReport=$P(strClinic,"^",1)
	K ^LYNTMP
	s ^LYNTMP(opaId)=selfReport
	s paraStr="OPA.SelfReport"_$c(3)_selfReport
	s retSelf=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(opaId,paraStr,$p(str1,"^",5))
	i +retSelf<0 TRollBack  q "-15^插入主诉错误！"
	
	/* (暂时不使用)
	s ^LYNTMP(opaId)=selfReport_"/  "_opResource
	s paraStr="OPA.OperResource"_$c(3)_opResource
	s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(opaId,paraStr,$p(str1,"^",5))
	i +retOR<0 TRollBack  q "-16^插入门诊资源！"

	s ^LYNTMP(opaId)=selfReport_"/  "_opResource_"/"_opQueueNo
	s paraStr="OPA.QueueNo"_$c(3)_opQueueNo
	s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(opaId,paraStr,$p(str1,"^",5))
	i +retOR<0 TRollBack  q "-17^插入门诊号源！"
		
	///更改手术号源使用状态
	
	s beforQueueNo=$P(strClinic,"^",8),retBQN=""  //前预约的号源
	s retLN=""
	i (beforQueueNo'="")&&(beforQueueNo'=opQueueNo) d ;将原来的号源置为0
		.s retBQN=##class(web.DHCANOPArrangeClinics).UpdateOpSequenceNoStat(opResource,beforQueueNo,0)
		.s retLN=##class(web.DHCANOPArrangeClinics).UpdateOpSequenceNoStat(opResource,opQueueNo,1)
	i (retBQN'="")&&(retBQN'=1) TRollBack  q "-18^释放旧的号源信息失败！"
	i retLN=2 TRollBack  q "-18^手术号源刚被使用，请重新选择资源、号源!"
	i (retLN'="")&&(retLN<1) TRollBack  q "-18^更新号源时参数出现错误！"
	*/
	s patNotice=$P(strClinic,"^",5) ;病人须知
	;s paraStr="OPA.PatNotice"_$c(3)_patNotice
	;s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(opaId,paraStr,$p(str1,"^",5))
	;i +retOR<0 TRollBack  q "-19^更新病人须知错误！"
	s ^DHCANOPArrange("PatNotice",opaId)=patNotice
	
	s comeHosDateTime=comeHosDate_","_comeHosTime
	s paraStr="OPA.PatComeHosTime"_$c(3)_comeHosDateTime
	s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(opaId,paraStr,$p(str1,"^",5))
	i +retOR<0 TRollBack  q "-20^更新患者来院时间有误！"
	
	s operStock=$P(strClinic,"^",6) ;手术耗材
	s paraStr="OPA.OperStock"_$c(3)_operStock
	s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(opaId,paraStr,$p(str1,"^",5))
	i +retOR<0 TRollBack  q "-21^插入手术耗材错误！"
	
	s operStockNote=$P(strClinic,"^",7) ;手术耗材备注
	s paraStr="OPA.OperStockNote"_$c(3)_operStockNote
	s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(opaId,paraStr,$p(str1,"^",5))
	i +retOR<0 TRollBack  q "-21^插入手术耗材备注错误！"
	
	s telNum=$P(strClinic,"^",9) //病人电话
	s paraStr="OPA.PatTel"_$c(3)_telNum
	s retOR=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(opaId,paraStr,$p(str1,"^",5))
	i +retOR<0 TRollBack  q "-22^插入患者电话错误！"
	//************************************************
   s subOperStr=$p(op,"^",8)
	s otherOperStatus=##class(web.UDHCANOPArrange).insertchlop("","",anaId,subOperStr,appType)
    //s retval=itmjs_"('"_$ZCVT(anaId,"O","JS")_"');"
    //i itmjsex'="" s retval=retval_itmjsex_"('"_$ZCVT(anaId,"O","JS")_"');"
    //&javascript<#(retval)#>
    TCommit
  
 q 0
}

/// w ##class(web.DHCANOPArrangeClinics).GetUserInfo(258)
ClassMethod GetUserInfo(userId) As %String
{
	s userInfo=""
	q:userId="" userInfo
    s ctcptId=$p($g(^SSU("SSUSR",userId)),"^",14)
    q:ctcptId="" ""
    s userDesc=##class(web.DHCANOPCom).GetNameById(ctcptId)
    
    s ctcpAlias=$p($g(^CTPCP(ctcptId,3)),"^",28)
    s userInfo=ctcptId_"!"_userDesc
    q userInfo
}

/// w ##class(web.DHCANOPArrangeClinics).GetANAMethod("局部麻醉")
ClassMethod GetANAMethod(desc) As %String
{
	q:desc="" ""
	s rowid=0,retstr=""
	f  s rowid=$o(^ORC("ANMET",rowid)) q:(rowid="")!(retstr'="")  d
    .s Dateto=$p(^ORC("ANMET",rowid),"^",6)
    .q:(Dateto'="")&(Dateto<=+$h)
    .s Des=$p(^ORC("ANMET",rowid),"^",2)
    .s Code=$p(^ORC("ANMET",rowid),"^",1)
    .q:(Des'=desc)&&(Des'="")
    .s retstr=rowid_"!"_Des
    q retstr
}

/// 获取门诊打印的预约单信息
/// W ##class(web.DHCANOPArrangeClinics).GetMZSSMZYYD(174)
ClassMethod GetMZSSMZYYD(opaId As %String) As %String
{
	s retStr=""
	q:opaId="" ""
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
    s paadmtype=$p(^PAADM(EpisodeID),"^",2)
    s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s phoneId=$p($g(^PAPER(papmiId,"ALL")),"^",4)
    i phoneId="" s phoneId=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //手机
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2) 
    s workAdd="" ;工作地址
    s workAdd=$p(^PAPER(papmiId,"PER",4),"^",18)
    s homAddress=$g(^PAPER(papmiId,"PER","ADD",1))	
    s personId=$p($g(^PAPER(papmiId,"ALL")),"^",9) //身份证号
    s personIdInfo=""
    //S medCareNo= ##Class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID , .ErrMsg)
    s medCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
    i personId'="" d
   		.s personIdInfo=$e(personId,1,3)_"***********"_$e(personId,15,19)
    ;s age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)
    s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
    //s mainDiag=##class(web.DHCANOPPREDIAG).GetAllMDiagnosByAdm(EpisodeID) //获取主诊断
   // s mainDiag=$p(mainDiag,"^",2)
  	 s mainDiag=""
    s mainDiag=..MDiagnos(EpisodeID,"OP")
    
    s appDocDesc=""
    s appDocId=$P(^DHCANOPArrange(opaId),"^",6)
    i appDocId'="" s appDocDesc=##class(web.DHCANOPCom).GetNameById(appDocId) 
    ;w "appDocId: "_appDocDesc,!
    
    s opStDate=$P(^DHCANOPArrange(opaId),"^",14)
    i opStDate'="" s opStDate=##class(web.DHCClinicCom).ConvertToDate(opStDate)
    s opsttime=$P(^DHCANOPArrange(opaId),"^",15)
    i opsttime'=""  s opsttime=$ZT(opsttime,2)
    s opSTDT=opStDate_" "_opsttime
    ;w "opSTDT "_opSTDT,!
    
    s appLocId= $p($g(^DHCANOPArrange(opaId)),"^",54)
    s appLocDesc=""
    i appLocId'="" s appLocDesc=$P($g(^CTLOC(appLocId)),"^",2)
    i $l(appLocDesc,"-")>1 s appLocDesc=$p(appLocDesc,"-",2)
    
    s opAppdate=$P(^DHCANOPArrange(opaId),"^",3)
    s opAppdate=##class(web.DHCClinicCom).ConvertToDate(opAppdate)
    s opApptime=$P(^DHCANOPArrange(opaId),"^",5)
    i opApptime'=""  s opApptime=$ZT(opApptime,2)
    s appDT=opAppdate_" "_opApptime
    ;w "opAppdate "_appDT,!
    
    s i=0
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s surgeonDesc="",bodsList="",operLocDesc=""
    s opSub=0 f  s opSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub)) q:(opSub="")!(i=1)  d
    .s i=i+1
    .s surgeonDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",8)        ;ANAOP_Surgeon_DR  ；手术医师
    .i surgeonDr'="" s surgeonDesc=##class(web.DHCANOPCom).GetNameById(surgeonDr)
 	.;手术科室
    .s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",10) 
    .s operLocDesc="" 
    .i operLocId'="" s operLocDesc=$p(^CTLOC(operLocId),"^",2)
    .;i operLocDesc'="" s operLocDesc=$p(operLocDesc,"-",2)
    .i $l(operLocDesc,"-")>1 s operLocDesc=$p(operLocDesc,"-",2)
    .s bodsIdList=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",24)      //手术部位
    .;手术部位
    .s bodsList=""
    .i bodsIdList'="" d
    ..s bodsIdNum=$l(bodsIdList,"|")
    ..f j=1:1:bodsIdNum d
    ...s bodsId=$p(bodsIdList,"|",j)
    ...q:bodsId=""
    ...s bodsDesc=$p($g(^OEC("BODS",+bodsId)),"^",2)
    ...i bodsList="" s bodsList=bodsDesc
    ...e  s bodsList=bodsList_","_bodsDesc  
    
    s opdes="" ;手术名称
    s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d 
      	.s opdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",6)     
      	.i opdr'=""  d  
      	..i $P($g(^ORC("OPER",+opdr)),"^",2)'="" d     
        	...i opdes'="" s opdes=opdes_";"     
        	...s opdes=opdes_$P($g(^ORC("OPER",+opdr)),"^",2)     
      	.e  d
        	..i $g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2))'="" d
        	...i opdes'="" s opdes=opdes_";"
        	...s opdes=opdes_$G(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"REM",2)) 
        	 
    ;病人须知 ;OPA.PatNotice(扩展字段病人须知) 
	//s patNotice=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.PatNotice")
	//s patNotice=$p(patNotice,$c(3),1)  
	s patNotice=$g(^DHCANOPArrange("PatNotice",opaId))
	
	;来院时间 ;OPA.PatComeHosTime(扩展字段病人须知) 
	s comeTime=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.PatComeHosTime")
	s comeTime=$p(comeTime,$c(3),1)
	s comeDate=""
	i comeTime'="" d
		.s comeDate=$p(comeTime," ",1)
		.s comeDateH=##class(web.DHCClinicCom).ConvertToDateH(comeDate)
		.s comeDate=##class(web.DHCClinicCom).ConvertToDate(comeDateH)
	s comeHdt=opStDate_" "_$zt($p(comeTime,",",2),2)
	
	;获取号源信息 OPA.QueueNo (扩展字段门诊手术预约号) 
	s queueNo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.QueueNo")
	s queueNo=$p(queueNo,$c(3),1)
	
	s opMem=$P(^DHCANOPArrange(opaId),"^",19) //病例摘要~手术要求
	s retStr=patName_"^"_sex_"^"_age_"^"_medCareNo_"^"_personIdInfo
	s retStr=retStr_"^"_phoneId_"^"_workAdd_"^"_homAddress_"^"_mainDiag_"^"_opdes
	s retStr=retStr_"^"_surgeonDesc_"^"_appDocDesc_"^"_operLocDesc_"^"_appLocDesc_"^"_bodsList
	s retStr=retStr_"^"_appDT_"^"_opSTDT_"^"_comeHdt_"^"_patNotice_"^"_queueNo
	s retStr=retStr_"^"_opMem
	q retStr
}

/// 获取诊断
ClassMethod MDiagnos(Adm, typ) As %String
{
  s i=0
  s retstr=""
  i typ="M" s typ="C008"
  s count=0
  s mradmId=$P(^PAADM(Adm),"^",61)
	;无id可修改
	i mradmId'="" d
		.s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradmId)
		.s digStrLength=$l(diagInfoStr,"^")
		.f dnum=1:1:digStrLength d
			..s curDiagStr=$p(diagInfoStr,"^",dnum)
			..s curDigDesc=$p(curDiagStr,"&&",1)
			..s curDigId=$p(curDiagStr,"&&",2)
			..s curDigNote=$p(curDiagStr,"&&",3)
			..s curPreFix=$p(curDiagStr,"&&",4)
			..s curDigType=$p(curDiagStr,"&&",5)
			..s curDigMainFlag=$p(curDiagStr,"&&",6)
			..q:curDigType'="门诊诊断"
			..s newDiagStr=curPreFix_curDigDesc_curDigNote
			..i retstr'="" s retstr=retstr_";"_newDiagStr
			..e  s retstr=newDiagStr

  /*
  s retIcdId=""
  s mcl=0  f  s mcl=$O(^MR(mradm,"DIA",mcl) ) q:(mcl="")!(i=1)  d
	  .s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
	  .q:icddr=""
	  .;q:$P(^MR(mradm,"DIA",mcl,1),"^",20)'="Y"	;不是主诊断的pass+20161009
	  .s typcl=0  f  s typcl=$O(^MR(mradm,"DIA",mcl,"TYP",typcl)) q:(typcl="")!(i=1)   d
		  ..s diagtypId=$P(^MR(mradm,"DIA",mcl,"TYP",typcl),"^",1)
		  ..q:diagtypId=""
		  ..s diagtyp=$P($g(^MRC("DTYP",diagtypId)),"^",1)
		  ..q:diagtyp'=typ
		  ..s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
		  ..q:icddr=""
		  ..s diagdes=$P(^MRC("ID",icddr),"^",2)
		  ..i retstr'="" s retstr=retstr_";"_diagdes
		  ..e  s retstr=diagdes
		  */
  q retstr
}

/// w ##class(web.DHCANOPArrangeClinics).IfHaveDiag()
ClassMethod IfHaveDiag(Adm, groupId)
{
	s retstr=""
	s mradm=$P(^PAADM(Adm),"^",61)
	s admType=$p(^PAADM(Adm),"^",2)
	;无id可修改
	i mradm'="" d
		.s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradm)
		.s digStrLength=$l(diagInfoStr,"^")
		.f dnum=1:1:digStrLength d
			..s curDiagStr=$p(diagInfoStr,"^",dnum)
			..s curDigDesc=$p(curDiagStr,"&&",1)
			..s curDigId=$p(curDiagStr,"&&",2)
			..s curDigNote=$p(curDiagStr,"&&",3)
			..s curPreFix=$p(curDiagStr,"&&",4)
			..s curDigType=$p(curDiagStr,"&&",5)
			..s curDigMainFlag=$p(curDiagStr,"&&",6)
			..q:curDigType'="出院诊断"
			..s newDiagStr=curPreFix_curDigDesc_curDigNote
			..i retstr'="" s retstr=retstr_","_newDiagStr
			..e  s retstr=newDiagStr

	/*
  s retIcdId=""
  s mcl=0  f  s mcl=$O(^MR(mradm,"DIA",mcl) ) q:(mcl="")  d
	  .s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
	  .q:icddr=""
	  .s typcl=0  f  s typcl=$O(^MR(mradm,"DIA",mcl,"TYP",typcl)) q:(typcl="")  d
		  ..s diagtypId=$P(^MR(mradm,"DIA",mcl,"TYP",typcl),"^",1)
		  ..q:diagtypId=""
		  ..s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
		  ..q:icddr=""
		  ..s diagdes=$P(^MRC("ID",icddr),"^",2)
		  ..i retstr'="" s retstr=retstr_";"_diagdes
		  ..e  s retstr=diagdes
		  */
		  
 	s OrderLimit=##Class(web.DHCDocConfig).GetConfigNode1("OrderLimit",groupId)
	i OrderLimit=1 s retstr=1
  q retstr
}

ClassMethod CheckAdmValid(Adm, groupId)
{
	s retStr="",LimitType="",timeNum=0
	s today=+$h
	s time=$p($h,",",2)
	s PAADMDate=$p(^PAADM(Adm),"^",6)     /// 就诊日期
	s PAADMTime=$p(^PAADM(Adm),"^",7)
	s admType=$p(^PAADM(Adm),"^",2)
	s OPAdmDayLimit=##Class(web.DHCDocConfig).GetConfigNode("OPAdmDayLimit")
	
	s LimitType1=##Class(web.DHCDocConfig).GetConfigNode("OPLimitType")
	
	i LimitType1="Hour" s LimitType="小时",timeNum=$zth(OPAdmDayLimit,2)
	i LimitType1="Day" s LimitType="天"
	i OPAdmDayLimit="" s OPAdmDayLimit=1
	s IfPilotAdm=##Class(web.PilotProject.DHCDocPilotProCommon).CheckPilotAdm(Adm)
	i LimitType1="Day" d
	.i (today-PAADMDate>(OPAdmDayLimit-1))&&(IfPilotAdm'=1)  s retStr="此就诊记录的挂号在"_OPAdmDayLimit_LimitType_"以前,不允许再开申请."
	i LimitType1="Hour" d
	.i (time-PAADMTime>timeNum)&&(IfPilotAdm'=1)  s retStr="此就诊记录的挂号在"_OPAdmDayLimit_LimitType_"以前,不允许再开申请."
	i admType="E" d
	.s EPAdmDayLimit=##Class(web.DHCDocConfig).GetConfigNode("EPAdmDayLimit")
	.s LimitTypeE=##Class(web.DHCDocConfig).GetConfigNode("EPLimitType")
	.i LimitTypeE="Hour" d
		..s LimitTypeE="小时",timeNume=$zth(EPAdmDayLimit,2)
		..i (time-PAADMTime>timeNume)&&(IfPilotAdm'=1)  s retStr="此就诊记录的挂号在"_EPAdmDayLimit_LimitTypeE_"以前,不允许再开申请."
	.i LimitTypeE="Day" d
		..s LimitType="天"
		..i (today-PAADMDate>(EPAdmDayLimit-1))&&(IfPilotAdm'=1)  s retStr="此就诊记录的挂号在"_EPAdmDayLimit_LimitType_"以前,不允许再开申请."
		 s NoAdmValidDaysLimit=##Class(web.DHCDocConfig).GetConfigNode1("NoAdmValidDaysLimit",groupId)
	i NoAdmValidDaysLimit=1 s retStr=""

	q retStr
}

/// Descripation:	根据科室ID获取当前科室是门诊申请科室（门诊手术室）、住院申请科室（住院手术室）、
/// 					急诊申请科室（急诊手术室）
/// Input：			LocId-科室Id，Type-判断类型
/// OutPut:			返回判断的类型
/// w ##class(web.DHCANOPArrangeClinics).JudgeLocType(748,"OUTOPDEPT")
ClassMethod JudgeLocType(LocId As %String, Type As %String) As %String
{
	s ret=1
	q:(LocId="")!(Type="") ret
	s LocIdList=##class(web.DHCClinicCom).GetLocIdByLocListCode(Type)
	i ("^"_LocIdList_"^")[("^"_LocId_"^") s ret=0
	q ret
}

ClassMethod GetUserIdByCtcpId(ctcpId As %String) As %String
{
    s workNo=$p(^CTPCP(ctcpId,1),"^",1)  ;工号
    s userId=$o(^SSU("SSUSR",0,"SSUSR_Initials",workNo,""))
    q userId
}

}
