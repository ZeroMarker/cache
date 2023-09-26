Import SQLUser

Include webimport

IncludeGenerator webimport

/// Desc：拟日间手术
/// creat：DYL
/// creat：20180705
/// 
Class web.DHCANOPArrangeDayOper Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod insertAnRecord(str1 As %String, op As %String, ass As %String, strcheck As %String, anmetId As %String = "", ifBLApp As %String = "N", appType As %String = "") As %String
{
	k PLIST
	//web.UDHCANOPArrange.insertAnRecord
	//str1=applocId+"^"+appdocId+"^"+opaStartDate+"^"+opaStartTime+"^"+appUser+"^"+admId+"^"+oproomid+"^"+opmem+"^"+BldTypId+"^"+ArrTime;
	//str1=str1+"^"+opaOPLevelDr^opaPatHeight^opaPatWeight^opaPreDiscussDate^opaEstiOperDuration^opaOpDocNote^opaSeqNote^opaSeq^opaAppDate^opaAppTime
	//str1=str1+"^"+opaMedInfect+"^"+transferMeansCode
	//申请科室ID^申请医师^手术日期^手术时间^登陆用户^病人就诊ID^手术间ID^手术要求^血型^安排时间^麻醉规模^身高^体重^术前讨论日期^预计手术时长^手术医师备注^手术编号^台次^申请日期(空)^申请时间(空)^院内感染
	//s ^tmpYpzRJ("insertAnRecord","str1")=str1
	//=987^4460^11/09/2009^17:40^680^8598^^手术要求手术要求^1^^3^^^^02:00^游邢泳爱耘^10101010^1
	//s op=ANAOP_Type_DR+"^"+preDiagid+"^"+ANAOP_Surgeon_DR+"^"+diagmem+"^"+operLoction^bodsId^operPositionId
	//	手术名称ID^术前诊断ID^手术医师ID^诊断备注^手术室名称^手术部位ID^手术体位ID
	s ^tmpYpzRJ("insertAnRecord","op")=op
	//anaopTypeDR^anaopPreopDiagDR^anaopSurgeonDR^anaopNotes^anaopCtlocDesc^bodsId^operPositionId
	//=4^4^3594^霍乱霍乱^ZYSS-住院手术室^1^2
	s ^tmpYpzRJ("insertAnRecord","ass")=ass
	//ass=firstAssId+"^"+secondAssId+"^"+thirdAssId+"^"+otherAssId
	//=3804^3884^3712^5396^4092
	s ^tmpYpzRJ("insertAnRecord","strcheck")=strcheck
	//var strcheck=chbsag+"^"+chcvab+"^"+chivab+"^"+chmd+"^"+seljz+"^"+qt+"^"+RHBloodType+"^"+isolated+"^"+isPrepareBlood+"^"+isUseSelfBlood+"^"+isExCirculation+"^"+NeedAnaesthetist+"^"+"^"+NeedNavigation
	//	HbsAg^HCV_Ab^Hiv_Ab^梅毒^急诊^其他^RH血型^是否隔离^是否备血^是否自体血回收^是否体外循环^是否麻醉会诊^是否微创^是否导航
	//^^^^^^opaRHBloodType^opaIsolated^opaPrepareBlood^opaUseSelfBlood^opaExCirculation^opaNeedAnaesthetist
	//=未查^阴性^阳性^化验中^1^其他^阴性^Y^Y^Y^Y^Y
	s ^tmpYpzRJ("insertAnRecord","anmetId")=anmetId
	//=8
	//anmetId 麻醉方法(1|2)
	
	s adm=+$P(str1,"^",6)
	q:adm<1 "-1^就诊号不对!"
	TSTART  //test
	;s adm=$P(str1,"^",6)
	s PLIST(0)=adm 
	i $P(str1,"^",3)'=""
	{
		s PLIST(48)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3))		//ANA_TheatreInDate	手术开始日期
		s PLIST(49)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4),"")		//ANA_TheatreInTime	手术开始时间
	}
    &sql(INSERT INTO sqluser.OR_Anaesthesia Values :PLIST())
    s anaId=%ROWID
    i SQLCODE'=0  TRollBack  q "-2^插入麻醉表错误!"
	k PLIST
	s PLIST(2)=adm
	s PLIST(13)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",19)) //appDate
	s PLIST(14)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",20)) //appTime
	i $P(str1,"^",3)'=""
	{
		s PLIST(7)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3))
		i PLIST(7)<$h  TRollBack  q "-3^手术日期不能早于系统日期!"
		i (PLIST(7)=+$h)&($P(strcheck,"^",5)'=1) TRollBack  q "-12^非急诊手术日期不能是当前系统日期!"
		//s PLIST(9)=$ZTH($P(str1,"^",4))  //StarT
		s PLIST(9)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4),"")
		//s ^TT(3)=$ZTH($P(str1,"^",4))
	}
	s PLIST(5)=$P(str1,"^",7)  								//OPA_OpRoom_dr	如维护手术间默认使用科室,申请时自动填入手术间
	s PLIST(12)=$P(str1,"^",2) 								//OPA_AppCtcp_Dr 申请医生
	s PLIST(3)=$p($g(^PAADM(adm)),"^",4)					//patloc //ypz 070530
	s PLIST(55)=$P(str1,"^",1)	//申请科室
	i "EO"[$p($g(^PAADM(adm)),"^",2) s PLIST(55)=$p($g(^PAADM(adm)),"^",4)
	s PLIST(33)=$p($g(^PAADM(adm)),"^",70)
	s PLIST(4)=anaId
	s PLIST(20)="S"		//拟日间手术
	//如果是实习医生申请的手术为空状态
	s appctcpId=$P(str1,"^",2)
	i appctcpId'="" d
		.s ctcptId=$p($g(^CTPCP(appctcpId,1)),"^",4)
		.i ctcptId'="" d
			..s ctcptType=$p($g(^CT("CPT",ctcptId)),"^",1)
			..i ctcptType="PRACTICE" s PLIST(20)=""

	s BldTyDescOrdId=$P(str1,"^",9)                               	//WKZ 071226 S 血型更新
 	i BldTyDescOrdId'="" d
		.i BldTyDescOrdId=+BldTyDescOrdId s BldTyId=BldTyDescOrdId
		.e  d
			..s BldTyDescOrdId=$$ALPHAUP^SSUTIL4(BldTyDescOrdId)
			..s BldTyId=$o(^PAC("BLDT",0,"Desc",BldTyDescOrdId,""))
	e  s BldTyId=""
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
	;其他检验信息+这块maxlen增大了
	s PLIST(166)=$P(strcheck,"^",6)							//OPA_PATestOther 	检验其它阴阳性
	
	s PLIST(19)=$P(str1,"^",8) 								//OPA_Memo			备注-手术要求			
	//s PLIST(21)=+$P(str1,"^",11)      //WKZ 071224 S		//OPA_OPLevel_Dr	麻醉规模
	s PLIST(25)=+$P(str1,"^",12)							//OPA_PatHeight		身高
	s PLIST(26)=$P(str1,"^",13)      //WKZ 071224 E			//OPA_PatWeight		体重
	s PLIST(149)=anmetId 
	s PLIST(26)=+PLIST(26)
	;20161214+dyl
	//s PLIST(38)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",15),"")
	s PLIST(38)=$P(str1,"^",15)
	s PLIST(39)=##class(web.DHCANOPCom).ConvertToDateH(($P(str1,"^",14)),"") //+ wxl 090316

	s PLIST(22)="N"
	s PLIST(43)=$P(str1,"^",16)   							//OPA_OpDocNote 实习医生,手术医师备注
	s PLIST(42)=$P(str1,"^",17)   							//OPA_SeqNote	手术编号,医生手术申请编号
	s PLIST(6)=$P(str1,"^",18) 								//OPA_Seq		台次
	s PLIST(54)=$P(str1,"^",21)							    //OPA_MedInfect 院感
	s PLIST(40)=$P(str1,"^",22)                             //OPA_TransferMeans 接病人方式
	s PLIST(47)=$P(strcheck,"^",17)		//勿动20160114+OPA_UnPlanedOperation+重返手术
	&sql(INSERT INTO SQLUSER.DHC_AN_OPArrange Values :PLIST())
	s Ret1=%ROWID
	;20160908+dyl:统一用"|"分割
	s anmetId=$tr(anmetId,",","|")
	s $P(^DHCANOPArrange(Ret1,"PA"),"^",89)=anmetId
	i SQLCODE'=0 TRollBack  q "-5^插入手术排班表错误!"_"/"_Ret1_"/"_SQLCODE
	
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
	s $P(^OR(adm,"ANA",anachl),"^",5)=anmetId 	
	k PLIST
	s PLIST(6)=""
	s PLIST(7)=""
	s daigPreStr=$P(op,"^",2)
	s diagIdS=$p(daigPreStr,"/",1)
	i diagIdS'=""  d
		.s PLIST(6)=$tr(diagIdS,",","|")

	q:($p($P(op,"^",1),"|",1)="")&($p($P(op,"^",1),"|",3)="") "手术名称或手术备注为空!"
	i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
		.s PLIST(9)="" //20101029 zhangtao
	e  s PLIST(9)=$p($P(op,"^",1),"|",1)
	s PLIST(8)=$lb($p($p(op,"^",1),"|",3))	//ANAOP_Notes
	//s PLIST(11)=$P(op,"^",3)	//主刀医生
	s PLIST(11)=$p($P(op,"^",1),"|",7)	//20180118
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
	s PLIST(25)="Y"		;日间手术标志
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
	s ^OR(adm,"ANA",anaSub,"TXT",0)=3 
	//诊断备注
 	s preDiagN=""                                          
	s preDiagN=$p(daigPreStr,"/",2)
	s ^OR(adm,"ANA",anaSub,"TXT",1)=preDiagN 
	
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
	s ancoplId=""
	i ancoplCode'="" d
		.i ancoplCode=+ancoplCode s ancoplId=ancoplCode q
		.s ancoplCode=$$ALPHAUP^SSUTIL4(ancoplCode)
		.//s ancoplId=$o(^DHCANC("OPLevel",0,"Code",ancoplCode,""))
		.s ancoplId=$o(^ORC("CATEG",0,"Code",ancoplCode,"")) 		//update by lyn 20160811
	s $p(^OR(adm,"ANA",anchl,"OP",chl,"DHC"),"^",1)=ancoplId	//+wxl 091215 
		//术者科室20180118
	s doclocId=$p($p(op,"^",1),"|",6)
	s $p(^OR(adm,"ANA",anchl,"OP",chl,"DHC"),"^",7)=doclocId
	s ass=""
	s ass1=$p($p(op,"^",1),"|",8)
	s ass2=$p($p(op,"^",1),"|",9)
	s ass3=$p($p(op,"^",1),"|",10)
	s asso=$p($p(op,"^",1),"|",11)
	s asso=$tr(asso,",","^")
	s ass=ass1_"^"_ass2_"^"_ass3_"^"_asso
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
	s opaId=Ret1
	s otherOperStatus=0
	s subOperStr=$p(op,"^",8)
	s otherOperStatus=..insertchlop(opaId,subOperStr,appType)
	
	;20170627+dyl
	s SendMessage=$g(^DHCCLSet("AnOp","SendMessage"))
	i SendMessage="Y" d
		.//申请的时候向平台发送一次信息
		.s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",Ret1)
		.s ^tmpDYL("ANOPApp",Ret1)=OAret
		.//申请的时候向电子病历发送一次消息
		.s retEMR=""
		.;s retEMR=##class(EMRservice.BIEMRService).SetOperation(adm,Ret1)
		.//申请的时候向消息平台发送一次信息
		.s applocdr=$P(str1,"^",1)
		.Set rtnMes =##class(websys.DHCMessageInterface).Send("申请手术", "1053", $p(str1,"^",5), adm , "" , "" , "opaId为"_Ret1 ,ctlocId)
   //liangq 20101105
   	TCOMMIT
 q Ret1
}

ClassMethod updatewardRecord(opaId As %String, str1 As %String, op As %String, ass As %String, strcheck As %String, anmetId As %String = "", appType As %String = "") As %String
{
   //病区填写
	;k (str1,anmthid,andocid,op,ass,scr,cir)
	s userId=%session.Data("LOGON.USERID")
	s ctcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
	s ctcptType=$p(^CT("CPT",ctcptId),"^",4)
	s locId=$p($g(^DHCANOPArrange(opaId)),"^",54) 
	s docLocId=%session.Data("LOGON.CTLOCID")
	s linkLocStr=##class(web.DHCANOPOutInDeptLink).GetOutInLinkID(docLocId)
	q:(("^"_docLocId_"^"_linkLocStr_"^")'[("^"_locId_"^"))&(ctcptType="DOCTOR") "医生不能修改非本科室手术" 
	;20160908+dyl
	s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	;q:(opaStatus'="A")&(appType="Ward") "手术状态已更新,请刷新界面"
	k PLIST
	//s strcheck="阴性^阴性^阴性^阴性^0^阴性"
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
	i SQLCODE  q "未找到手术申请记录!"
		
	TSTART
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    s opdate=$P($g(^DHCANOPArrange(opaId)),"^",14)
    if $P(str1,"^",3)'="" 
    {
		s PLIST(7)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3)) // starD
		i (PLIST(7)<$h)  TRollBack  q "手术日期不能早于系统日期!"	//20160908+dyl
		s PLIST(9)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4),"") //手术申请时间不填写
    }
	s PLIST(5)=$P(str1,"^",7)  								//OPA_OpRoom_dr	如维护手术间默认使用科室,申请时自动填入手术间
	//s PLIST(12)=$P(str1,"^",2) 								//OPA_AppCtcp_Dr 申请医生
	//s PLIST(3)=$P(str1,"^",1)  							//ypz 070530 病人科室不变,便于统计
	s PLIST(19)=$P(str1,"^",8) 								//OPA_Memo		备注-手术要求
	s groupId=%session.Data("LOGON.GROUPID")				//科主任审核
	
	
    s adm=$P(str1,"^",6)                                    //WKZ 071226 S 	血型更新
	s BldTyId=$P(str1,"^",9)
	s PLIST(28)=$P(strcheck,"^",7)							//OPA_RHBloodType	RH血型							
	s PLIST(29)=$P(strcheck,"^",8)							//OPA_Isolated		是否隔离
	s PLIST(34)=$P(strcheck,"^",9)							//OPA_PrepareBlood	是否备血
	s PLIST(35)=$P(strcheck,"^",10)							//OPA_UseSelfBlood	是否自体血回输
	s PLIST(37)=$P(strcheck,"^",11)							//OPA_ExCirculation	是否体外循环
	s PLIST(45)=$P(strcheck,"^",12)  						//OPA_NeedAnaesthetist是否麻醉会诊
	s PLIST(24)=$P(strcheck,"^",13) 						//OPA_MiniInvasive	是否微创手术
	s PLIST(56)=$p(strcheck,"^",14)                         //OPA_Navigation 是否导航 zhangtao 2010.8.6
	s PLIST(285)=$p(strcheck,"^",15)
	s PLIST(27)=BldTyId										//OPA_BloodType_Dr	血型
	s PLIST(193)=$P(strcheck,"^",1)							//OPA_PATestHBsAg 	免疫乙肝表面抗原
	s PLIST(198)=$P(strcheck,"^",2)							//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	s PLIST(199)=$P(strcheck,"^",3)							//OPA_PATestHivAb 	免疫艾滋病毒抗体
	s PLIST(200)=$P(strcheck,"^",4)							//OPA_PATestTPAb 	免疫梅毒
	s PLIST(166)=$P(strcheck,"^",6)							//OPA_PATestOther 	检验其它阴阳性
	s PLIST(21)=$P(str1,"^",11)								//OPA_OPLevel_Dr	麻醉规模
	s PLIST(25)=$P(str1,"^",12)								//OPA_PatHeight		身高
	s PLIST(26)=$P(str1,"^",13)								//OPA_PatWeight		体重
	;20161214+dyl
	;s PLIST(38)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",15),"") //OPA_EstiOperDuration
	s PLIST(38)=$P(str1,"^",15)
	s PLIST(39)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",14),"") //OPA_PreDiscussDate
	s PLIST(43)=$P(str1,"^",16)   							//OPA_OpDocNote 实习医生,手术医师备注
	s PLIST(42)=$P(str1,"^",17)   							//OPA_SeqNote	手术编号,医生手术申请编号
	s PLIST(6)=$P(str1,"^",18) 								//OPA_Seq		台次
	s PLIST(54)=$P(str1,"^",21)							    //OPA_MedInfect 院感
	s PLIST(40)=$P(str1,"^",22)                             //OPA_TransferMeans 接病人方式
	;20160908+dyl：统一用|
	s anmetId=$tr(anmetId,",","|")
	i PLIST(20)="S" s PLIST(149)=anmetId                    //OPA_PAAnaestType 拟施麻醉方式
	s PLIST(47)=$P(strcheck,"^",17)		//勿动20160114					
	;可以去掉
	;增加&(PLIST(13)=+$h)  update by lyn 标准版bug修正 2010928
	i (PLIST(7)=+$h)&($P(strcheck,"^",5)'="E")&(PLIST(20)="S") TRollBack  q "非急诊手术日期不能是当前系统日期!"
	//s ^DHCANARRAGE("ch",opaId)=strcheck					//检验值已存入DHC_AN_OPArrange
	i PLIST(22)="G" s PLIST(22)="M"
	&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	i SQLCODE TRollBack  q "修改手术申请错误!"
	s anmetId=$tr(anmetId,",","|")
	s $P(^DHCANOPArrange(opaId,"PA"),"^",89)=anmetId
	//-----
	///091204 ck
	s anaNotesList=$lb("")
	s anaNotesList=$lb($p(op,"^",4))
	s SourceType=$P(strcheck,"^",5)							//ANA_SourceType 急诊(E)/择期(B)	
	i SourceType=1  s anaSourceType="E"
	e  s anaSourceType="B"
	s opstdate=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3))		//ANA_TheatreInDate	手术开始日期
	s opstTime=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4),"")	//ANA_TheatreInTime	手术开始时间
	&sql(update SQLUSER.OR_Anaesthesia set ANA_Notes=:anaNotesList,ANA_SourceType=:anaSourceType,ANA_TheatreInDate=:opstdate,ANA_TheatreInTime=:opstTime where ANA_RowId=:anaId)
	i SQLCODE'=0 TRollBack  q "修改诊断备注或急诊手术错误!" 
	;i anmetId'="" &sql(update SQLUSER.OR_Anaesthesia set ANA_Method=:anmetId where ANA_RowId=:anaId)
	;i SQLCODE'=0 TRollBack  q "修改麻醉方式错误!" //ypz 070405 外科医生填写麻醉方式 
	//保存多个麻醉方法
	s adm=$p(anaId,"||",1)
	s anachl=$p(anaId,"||",2)
	s $P(^OR(adm,"ANA",anachl),"^",5)=anmetId 
	
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
	s daigPreStr=$P(op,"^",2)
	s diagIdS=$p(daigPreStr,"/",1)
	i diagIdS'=""  d
		.s PLIST(6)=$tr(diagIdS,",","|")

	q:($p($P(op,"^",1),"|",1)="")&($p($P(op,"^",1),"|",3)="") "手术名称或手术备注为空!"
	i $p($p(op,"^",1),"|",1)'="" d
	;s PLIST(9)=$p($p(op,"^",1),"|",1)
	i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
	.s PLIST(9)="" //20101029 zhangtao
	e  s PLIST(9)=$p($P(op,"^",1),"|",1)
	s PLIST(8)=$lb($p($p(op,"^",1),"|",3))	//手术分类
	s bldtpCode=$p($p(op,"^",1),"|",4)		//手术刀口类型 ANAOP_Blade_DR->ORC_BladeType
	s bldtpId=""
	i bldtpCode'="" d
		.i bldtpCode=+bldtpCode s bldtpId=bldtpCode q
		.s bldtpCode=$$ALPHAUP^SSUTIL4(bldtpCode)
		.q:bldtpCode=""
		.s bldtpId=$o(^ORC("BLDTP",0,"Code",bldtpCode,""))
	s PLIST(12)=bldtpId
	
	s PLIST(11)=$p($P(op,"^",1),"|",7)	//20180118:主刀医师
	s ctlocDesc=$$ALPHAUP^SSUTIL4($P(op,"^",5)),ctlocId="" //ypz 070316
	i ctlocDesc'="" s ctlocId=$o(^CTLOC(0,"Desc",ctlocDesc,"")) //ypz 070316
	i $P(op,"^",5)=+$P(op,"^",5) s ctlocId=$P(op,"^",5)  //ypz 091118
	s PLIST(13)=ctlocId  //ypz 070316：转出科室	
	//s PLIST(42)=$P(op,"^",6)  //ypz 070418 bodySite//100129现直接保存于Global中
	//s PLIST(0)=anaId
 	//&sql(insert into sqluser.OR_Anaest_Operation Values :PLIST())
 	s PLIST(27)=""					//现ANAOP_AreaInTime与ANAOP_BodySite_DR同一节点
 	s PLIST(42)=""					//ANAOP_AreaInTime暂不使用,ANAOP_BodySite_DR含|不直接保存
 	&sql(update sqluser.OR_Anaest_Operation Values :PLIST() where anaop_rowid=:anaopId)
 	//w "oper update="_SQLCODE,!
    i SQLCODE'=0 TRollBack  q "修改手术信息错误!"
	;s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",0)=1
	;s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",1)=$P(op,"^",4)
	//保存多个手术部位于Global中
	i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
		.s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",0)=2
		.;s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",1)=$lb($p($p(op,"^",1),"|",3))
		.s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",2)=$p($p(op,"^",1),"|",1)
	//诊断备注
	s ^OR(adm,"ANA",anaSub,"TXT",0)=3                
    s preDiagN=""                                          
	s preDiagN=$p(daigPreStr,"/",2)
	s ^OR(adm,"ANA",anaSub,"TXT",1)=preDiagN  
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

	s ancoplCode=$p($p(op,"^",1),"|",2)								//+wxl 091215 保存手术级别->ORC_OperationCategay 
	s ancoplId=""
	i ancoplCode'="" d
	.i ancoplCode=+ancoplCode s ancoplId=ancoplCode q
	.s ancoplCode=$$ALPHAUP^SSUTIL4(ancoplCode)
	.///s ancoplId=$o(^DHCANC("OPLevel",0,"Code",ancoplCode,""))
	.s ancoplId=$o(^ORC("CATEG",0,"Code",ancoplCode,"")) 			//update by lyn 20160811
	s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",1)=ancoplId	//+wxl 091215 
		//术者科室20180118
	s doclocId=$p($p(op,"^",1),"|",6)
	s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",7)=doclocId
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
	;20170627+dyl
	s SendMessage=$g(^DHCCLSet("AnOp","SendMessage"))
	i SendMessage="Y" d
		.//修改手术申请向平台发送消息
		.s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
	//20180119
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s anaopSub=0
    s otherOperStatus=0
    s subOperStr=$p(op,"^",8)
    ;s ^tmpDyl("Subo",4)=subOperStr_"/"_appType
	s otherOperStatus=..insertchlop(opaId,subOperStr,appType)
    i otherOperStatus'=0 q "插从手术有问题"
    
    s ass=""
	s ass1=$p($p(op,"^",1),"|",8)
	s ass2=$p($p(op,"^",1),"|",9)
	s ass3=$p($p(op,"^",1),"|",10)
	s asso=$p($p(op,"^",1),"|",11)
	s asso=$tr(asso,",","^")
	s ass=ass1_"^"_ass2_"^"_ass3_"^"_asso
	s assnum=0
    f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
        .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
        .q:ass=""
        .s num=$L(ass,"^")
        .//s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",0)=num
        .for i=1:1:num d
            ..i $p(ass,"^",i)'=""  d
            ...s assnum=assnum+1
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",i)=$P(ass,"^",i)
            ..e  d
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",i)=""
        .s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",0)=assnum
 	TCommit

 q 0
 //OR_An_Oper_Anaest_Assistant
}

ClassMethod ConfirmRecord(opaId As %String, str1 As %String, op As %String, ass As %String, strcheck As %String, anmetId As %String = "", appType As %String = "") As %String
{
	
   //病区填写
	;k (str1,anmthid,andocid,op,ass,scr,cir)
	s userId=%session.Data("LOGON.USERID")
	s ctcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	s ctcptId=$P($g(^CTPCP(ctcpId,1)),"^",4)
	s ctcptType=$p(^CT("CPT",ctcptId),"^",4)
	s locId=$p($g(^DHCANOPArrange(opaId)),"^",54) 
	s docLocId=%session.Data("LOGON.CTLOCID")
	s linkLocStr=##class(web.DHCANOPOutInDeptLink).GetOutInLinkID(docLocId)
	q:(("^"_docLocId_"^"_linkLocStr_"^")'[("^"_locId_"^"))&(ctcptType="DOCTOR") "医生不能修改非本科室手术" 

	;q:(docLocId'=locId)&(ctcptType="DOCTOR") "医生不能修改非本科室手术" 
	;20160908+dyl
	s opaStatus=$P(^DHCANOPArrange(opaId),"^",27)
	;q:(opaStatus'="A")&(appType="Ward") "手术状态已更新,请刷新界面"
	k PLIST
	//s strcheck="阴性^阴性^阴性^阴性^0^阴性"
	&sql(select * into :PLIST() from SQLUSER.DHC_AN_OPArrange where opa_rowid=:opaId)
	i SQLCODE  q "未找到手术申请记录!"
		
	TSTART
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    s opdate=$P($g(^DHCANOPArrange(opaId)),"^",14)
		s PLIST(7)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3)) // starD
		i (PLIST(7)<$h)  TRollBack  q "手术日期不能早于系统日期!"	//20160908+dyl
		s PLIST(9)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4),"") //手术申请时间不填写
	s PLIST(5)=$P(str1,"^",7)  								//OPA_OpRoom_dr	如维护手术间默认使用科室,申请时自动填入手术间
	//s PLIST(12)=$P(str1,"^",2) 								//OPA_AppCtcp_Dr 申请医生
	//s PLIST(3)=$P(str1,"^",1)  							//ypz 070530 病人科室不变,便于统计
	s PLIST(19)=$P(str1,"^",8) 								//OPA_Memo		备注-手术要求
	s groupId=%session.Data("LOGON.GROUPID")				//科主任审核
	i (PLIST(20)="S")&(appType="ward") s PLIST(20)="A"
	
    s adm=$P(str1,"^",6)                                    //WKZ 071226 S 	血型更新
	s BldTyId=$P(str1,"^",9)
	s PLIST(28)=$P(strcheck,"^",7)							//OPA_RHBloodType	RH血型							
	s PLIST(29)=$P(strcheck,"^",8)							//OPA_Isolated		是否隔离
	s PLIST(34)=$P(strcheck,"^",9)							//OPA_PrepareBlood	是否备血
	s PLIST(35)=$P(strcheck,"^",10)							//OPA_UseSelfBlood	是否自体血回输
	s PLIST(37)=$P(strcheck,"^",11)							//OPA_ExCirculation	是否体外循环
	s PLIST(45)=$P(strcheck,"^",12)  						//OPA_NeedAnaesthetist是否麻醉会诊
	s PLIST(24)=$P(strcheck,"^",13) 						//OPA_MiniInvasive	是否微创手术
	s PLIST(56)=$p(strcheck,"^",14)                         //OPA_Navigation 是否导航 zhangtao 2010.8.6
	s PLIST(285)=$p(strcheck,"^",15)
	s PLIST(27)=BldTyId										//OPA_BloodType_Dr	血型
	s PLIST(193)=$P(strcheck,"^",1)							//OPA_PATestHBsAg 	免疫乙肝表面抗原
	s PLIST(198)=$P(strcheck,"^",2)							//OPA_PATestHCVAb 	免疫丙型肝炎抗体
	s PLIST(199)=$P(strcheck,"^",3)							//OPA_PATestHivAb 	免疫艾滋病毒抗体
	s PLIST(200)=$P(strcheck,"^",4)							//OPA_PATestTPAb 	免疫梅毒
	s PLIST(166)=$P(strcheck,"^",6)							//OPA_PATestOther 	检验其它阴阳性
	s PLIST(21)=$P(str1,"^",11)								//OPA_OPLevel_Dr	麻醉规模
	s PLIST(25)=$P(str1,"^",12)								//OPA_PatHeight		身高
	s PLIST(26)=$P(str1,"^",13)								//OPA_PatWeight		体重
	;20161214+dyl
	;s PLIST(38)=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",15),"") //OPA_EstiOperDuration
	s PLIST(38)=$P(str1,"^",15)
	s PLIST(39)=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",14),"") //OPA_PreDiscussDate
	s PLIST(43)=$P(str1,"^",16)   							//OPA_OpDocNote 实习医生,手术医师备注
	s PLIST(42)=$P(str1,"^",17)   							//OPA_SeqNote	手术编号,医生手术申请编号
	s PLIST(6)=$P(str1,"^",18) 								//OPA_Seq		台次
	s PLIST(54)=$P(str1,"^",21)							    //OPA_MedInfect 院感
	s PLIST(40)=$P(str1,"^",22)                             //OPA_TransferMeans 接病人方式
	;20160908+dyl：统一用|
	s anmetId=$tr(anmetId,",","|")
	i PLIST(20)="S" s PLIST(149)=anmetId                    //OPA_PAAnaestType 拟施麻醉方式
	s PLIST(47)=$P(strcheck,"^",17)		//勿动20160114					
	s PLIST(20)="A"
	;可以去掉
	;增加&(PLIST(13)=+$h)  update by lyn 标准版bug修正 2010928
	//i (PLIST(7)=+$h)&($P(strcheck,"^",5)'=1)&(PLIST(20)="A")&(PLIST(13)=+$h) TRollBack  q "非急诊手术日期不能是当前系统日期!"
	//s ^DHCANARRAGE("ch",opaId)=strcheck					//检验值已存入DHC_AN_OPArrange
	i PLIST(22)="G" s PLIST(22)="M"
	&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	i SQLCODE TRollBack  q "修改手术申请错误!"
	s anmetId=$tr(anmetId,",","|")
	s $P(^DHCANOPArrange(opaId,"PA"),"^",89)=anmetId
	//-----
	///091204 ck
	s anaNotesList=$lb("")
	s anaNotesList=$lb($p(op,"^",4))
	s SourceType=$P(strcheck,"^",5)							//ANA_SourceType 急诊(E)/择期(B)	
	i SourceType=1  s anaSourceType="E"
	e  s anaSourceType="B"
	s opstdate=##class(web.DHCANOPCom).ConvertToDateH($P(str1,"^",3))		//ANA_TheatreInDate	手术开始日期
	s opstTime=##class(web.DHCANOPCom).ConvertToTimeH($P(str1,"^",4),"")	//ANA_TheatreInTime	手术开始时间
	&sql(update SQLUSER.OR_Anaesthesia set ANA_Notes=:anaNotesList,ANA_SourceType=:anaSourceType,ANA_TheatreInDate=:opstdate,ANA_TheatreInTime=:opstTime where ANA_RowId=:anaId)
	i SQLCODE'=0 TRollBack  q "修改诊断备注或急诊手术错误!" 
	;i anmetId'="" &sql(update SQLUSER.OR_Anaesthesia set ANA_Method=:anmetId where ANA_RowId=:anaId)
	;i SQLCODE'=0 TRollBack  q "修改麻醉方式错误!" //ypz 070405 外科医生填写麻醉方式 
	//保存多个麻醉方法
	s adm=$p(anaId,"||",1)
	s anachl=$p(anaId,"||",2)
	s $P(^OR(adm,"ANA",anachl),"^",5)=anmetId 
	
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
	s daigPreStr=$P(op,"^",2)
	s diagIdS=$p(daigPreStr,"/",1)
	i diagIdS'=""  d
		.s PLIST(6)=$tr(diagIdS,",","|")


	q:($p($P(op,"^",1),"|",1)="")&($p($P(op,"^",1),"|",3)="") "手术名称或手术备注为空!"
	i $p($p(op,"^",1),"|",1)'="" d
	;s PLIST(9)=$p($p(op,"^",1),"|",1)
	i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
	.s PLIST(9)="" //20101029 zhangtao
	e  s PLIST(9)=$p($P(op,"^",1),"|",1)
	s PLIST(8)=$lb($p($p(op,"^",1),"|",3))	//手术分类
	s bldtpCode=$p($p(op,"^",1),"|",4)		//手术刀口类型 ANAOP_Blade_DR->ORC_BladeType
	s bldtpId=""
	i bldtpCode'="" d
		.i bldtpCode=+bldtpCode s bldtpId=bldtpCode q
		.s bldtpCode=$$ALPHAUP^SSUTIL4(bldtpCode)
		.q:bldtpCode=""
		.s bldtpId=$o(^ORC("BLDTP",0,"Code",bldtpCode,""))
	s PLIST(12)=bldtpId
	
	s PLIST(11)=$p($P(op,"^",1),"|",7)	//20180118:主刀医师
	s ctlocDesc=$$ALPHAUP^SSUTIL4($P(op,"^",5)),ctlocId="" //ypz 070316
	i ctlocDesc'="" s ctlocId=$o(^CTLOC(0,"Desc",ctlocDesc,"")) //ypz 070316
	i $P(op,"^",5)=+$P(op,"^",5) s ctlocId=$P(op,"^",5)  //ypz 091118
	s PLIST(13)=ctlocId  //ypz 070316：转出科室	
	//s PLIST(42)=$P(op,"^",6)  //ypz 070418 bodySite//100129现直接保存于Global中
	//s PLIST(0)=anaId
 	//&sql(insert into sqluser.OR_Anaest_Operation Values :PLIST())
 	s PLIST(27)=""					//现ANAOP_AreaInTime与ANAOP_BodySite_DR同一节点
 	s PLIST(42)=""					//ANAOP_AreaInTime暂不使用,ANAOP_BodySite_DR含|不直接保存
 	&sql(update sqluser.OR_Anaest_Operation Values :PLIST() where anaop_rowid=:anaopId)
 	//w "oper update="_SQLCODE,!
    i SQLCODE'=0 TRollBack  q "修改手术信息错误!"
	;s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",0)=1
	;s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",1)=$P(op,"^",4)
	//保存多个手术部位于Global中
	i $p($p(op,"^",1),"|",1)'=(+$p($p(op,"^",1),"|",1)) d
		.s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",0)=2
		.;s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",1)=$lb($p($p(op,"^",1),"|",3))
		.s ^OR(adm,"ANA",anaSub,"OP",anaopSub,"REM",2)=$p($p(op,"^",1),"|",1)
	s ^OR(adm,"ANA",anaSub,"TXT",0)=3                  //zhangtao add
    s preDiagN=""                                          
	s preDiagN=$p(daigPreStr,"/",2)
	s ^OR(adm,"ANA",anaSub,"TXT",2)=preDiagN  

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

	s ancoplCode=$p($p(op,"^",1),"|",2)								//+wxl 091215 保存手术级别->ORC_OperationCategay 
	s ancoplId=""
	i ancoplCode'="" d
	.i ancoplCode=+ancoplCode s ancoplId=ancoplCode q
	.s ancoplCode=$$ALPHAUP^SSUTIL4(ancoplCode)
	.///s ancoplId=$o(^DHCANC("OPLevel",0,"Code",ancoplCode,""))
	.s ancoplId=$o(^ORC("CATEG",0,"Code",ancoplCode,"")) 			//update by lyn 20160811
	s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",1)=ancoplId	//+wxl 091215 
		//术者科室20180118
	s doclocId=$p($p(op,"^",1),"|",6)
	s $p(^OR(adm,"ANA",anaSub,"OP",anaopSub,"DHC"),"^",7)=doclocId
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
	;20170627+dyl
	s SendMessage=$g(^DHCCLSet("AnOp","SendMessage"))
	i SendMessage="Y" d
		.//修改手术申请向平台发送消息
		.s OAret=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
	//20180119
    s EpisodeID=+anaId
    s anaSub=$p(anaId,"||",2)
    s anaopSub=0
    s ass=""
	s ass1=$p($p(op,"^",1),"|",8)
	s ass2=$p($p(op,"^",1),"|",9)
	s ass3=$p($p(op,"^",1),"|",10)
	s asso=$p($p(op,"^",1),"|",11)
	s asso=$tr(asso,",","^")
	s ass=ass1_"^"_ass2_"^"_ass3_"^"_asso
	s assnum=0
    f  s anaopSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub)) q:anaopSub=""  d
        .q:$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub),"^",12)'="M" 
        .q:ass=""
        .s num=$L(ass,"^")
        .//s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",0)=num
        .for i=1:1:num d
            ..i $p(ass,"^",i)'=""  d
            ...s assnum=assnum+1
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",i)=$P(ass,"^",i)
            ..e  d
            ...s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",i)=""
        .s ^OR(EpisodeID,"ANA",anaSub,"OP",anaopSub,"ASS",0)=assnum
 	
 	
 	s arcimId=$g(^DHCCLSet("AnOp","AppArcimId"))   
    s retInsord = ..SaveAnopAppOrdItem(arcimId,opaId,userId,"ward",0,0)
   	i retInsord'=0 TRollBack  q retInsord
 	s subOperStr=$p(op,"^",8)
	s otherOperStatus=..insertchlop(opaId,subOperStr,appType)
   	;s ^tmpDyl("InsertOrder",1)=retInsord
 	s retInsord = ..SaveAnopAppOrdItem(arcimId,opaId,userId,"ward",0,1)
   	i retInsord'=0 TRollBack  q retInsord

 	TCommit

 q 0
 //OR_An_Oper_Anaest_Assistant
}

ClassMethod SaveAnopAppOrdItem(arcimId, opaId, userId = "", appType = "", ifBLApp = "", isUpdate = 0)
{
	q:appType'="ward" 0
	q:opaId="" 0
	q:'$d(^DHCANOPArrange(opaId)) 0
	q:+arcimId=0 0

    s arcimVer=$p(arcimId,"||",2)
	q:arcimVer=""
	q:$d(^ARCIM(+arcimId,arcimVer))<1 0
	
	s oeoriDepProcNotes=""
	
	s anopGlb = ^DHCANOPArrange(opaId)
	s EpisodeID=$p(anopGlb,"^",1)
	s anaId = $p(anopGlb,"^",2)
	s anaSub = $p(anaId,"||",2)
	s anaOpId=$o(^OR(EpisodeID,"ANA",anaSub,"OP",0))

	//如果是更新
	i isUpdate {
	//该手术对应医嘱
	s oeordId=""
	s oeordId=$o(^OEORDi(0,"Ana",anaId,oeordId))
	q:oeordId="" 0

	//取手术名称以","分隔
	s operId=""
	s val("operDesc")=""
	s anaOpSub=0
	f  s anaOpSub=$o(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpSub)) q:anaOpSub=""  d
	.s operId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpSub),"^",6)
	.s tmpDesc=""
	.i operId="" d  //手写的手术名称
	..s tmpDesc = $g(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpSub,"REM",2))
	.e  d
	..s tmpDesc = $p($g(^ORC("OPER",operId)),"^",2)
	..i $p(tmpDesc,"-",2)'="" s tmpDesc=$p(tmpDesc,"-",2)
	.i val("operDesc")="" s val("operDesc")=tmpDesc
	.e  s val("operDesc")=val("operDesc")_","_tmpDesc

	s anmthdr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)
	i anmthdr="" s anmthdr=$P(^DHCANOPArrange(opaId,"PA"),"^",89) 
	//麻醉方法
	s anmetDesc=##class(web.DHCANOPCom).GetAnMethodDescById(anmthdr,",")
		i $l(anmetDesc,"-")>1 s val("anmetDesc")=$p(anmetDesc,"-",2)
	e  s val("anmetDesc")=anmetDesc
	
	s opaStartDate=$p(anopGlb,"^",14)
	s opaStartTime=$p(anopGlb,"^",15)
	i opaStartDate'="" s opaStartDate=##class(web.DHCClinicCom).ConvertToDate(opaStartDate)
    s val("opaStartDate")=opaStartDate

    s val("opaStartTime")=""
    i opaStartTime'="" d
    .s val("opaStartTime")=$zt(opaStartTime)
    
    //手术部位
    s bodsDesc=""
	s bodySiteId= $p($g(^OR(EpisodeID,"ANA",anaSub,"OP",anaOpId)),"^",24)
	i bodySiteId'="" d
	.s bodsIdNum=$l(bodySiteId,"|")
	.f i=1:1:bodsIdNum d
	..s curBodsId=$p(bodySiteId,"|",i)
	..q:curBodsId=""
	..i bodsDesc="" s bodsDesc=$p($g(^OEC("BODS",+curBodsId)),"^",2)
	..e  s bodsDesc=bodsDesc_","_$p($g(^OEC("BODS",+curBodsId)),"^",2)
	s val("bodsDesc")=bodsDesc
	
	//拼出字符串:拟于^opaStartDate^ ^opaStartTime^,在^bodsDesc^anmetDesc^下行^operDesc
   	i val("operDesc")'="" d
       .s oeoriDepProcNotes=""
       .s noteStr=$g(^DHCCLSet("AnOp","Note"))
       .i noteStr'="" d
       	    ..s num=$l(noteStr,"^")
       	    ..f i=1:1:num d
       			...s curVal=$p(noteStr,"^",i)
       			...q:curVal=""
       	        ...i $d(val(curVal))>0 s curVal=val(curVal)
        		...s oeoriDepProcNotes=oeoriDepProcNotes_curVal

	//更新医嘱DEP字段
	s oeoriSub=""
	f  s oeoriSub = $o(^OEORDi(0,"Ana",anaId,oeordId, oeoriSub)) q:oeoriSub=""  d
		.q:$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)'=arcimId
		.s ordStatCode=##Class(web.DHCClinicCom).GetOrdStatCode(oeordId_"||"_oeoriSub)
		.q:((ordStatCode'="E") && (ordStatCode'="V"))
		.s ^OEORD(oeordId,"I",oeoriSub,"DEP",1)=oeoriDepProcNotes
	q 0 
	}
	
	s retInsord=""
    s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
    i oeordId="" d
   	    .s curDate=+$h,curTime=$p($h,",",2)
   	    .&sql(insert into sqluser.OE_Order(OEORD_Adm_DR,OEORD_Date,OEORD_Time) values(:EpisodeID,:curDate,:curTime))
   	    .i 'SQLCODE s oeordId=$g(%ROWID)
   	q:oeordId="" "-10^插入医嘱主表错!"
   	
    s userDeptId=$p(^PAADM(EpisodeID),"^",4)
 	//P5-P8//s retInsord=##Class(web.DHCCLCom).InsertOrdItem(userId, oeordId, arcimId,3,1, userDeptId, anaId, anaId_"||"_anaOpId, "",oeoriDepProcNotes)
    ////20160301+dyl+多加了一个$c(3)
    s miltiOeoriStr=arcimId_$c(3)_$zd(+$h,3)_$c(3)_$zt($p($h,",",2))_$c(3)_userDeptId_$c(3)_$c(3)_1_$c(3)_$c(3)_$c(3)_1_$c(3)_$c(3)_$c(3)_$c(3)_opaId_$c(3)_oeoriDepProcNotes
    s retInsord=##Class(web.DHCANOrder).InsertOrderItem(EpisodeID, miltiOeoriStr, userId, userDeptId)
    i $l(retInsord,"*")>2 s retInsord=0
    i $p(retInsord,"^")=-1 s retInsord=0
    i retInsord'=0 q "-11^插入手术医嘱错误!"_retInsord
    
    //+wxl090901 是否插入病理申请
    s BLAppId=$g(^DHCCLSet("AnOp","BLAppId"))
    s retInsord=0
    i ifBLApp="Y",BLAppId'="" d
        .//P5-P8//s retInsord=##Class(web.DHCCLCom).InsertOrdItem(userId, oeordId, BLAppId,3,1, userDeptId, "", "", "","")
        .s miltiOeoriStr=arcimId_$c(3)_$zd(+$h,3)_$c(3)_$zt($p($h,",",2))_$c(3)_userDeptId_$c(3)_$c(3)_1_$c(3)_$c(3)_$c(3)_1_$c(3)_$c(3)_$c(3)_opaId_$c(3)_""
        .s retInsord=##Class(web.DHCANOrder).InsertOrderItem(EpisodeID, miltiOeoriStr, userId, userDeptId)
        .i $l(retInsord,"*")>2 s retInsord=0
        .i $p(retInsord,"^")=-1 s retInsord=0
    i retInsord'=0  q "-12^插入病理申请医嘱错误!"
    
    q 0
}

ClassMethod insertchlop(opaId, opstr, appType = "") As %String
{
	s opstr=$tr(opstr,"#","^")
	s err=0
	s ifAll="Y"
	s attAnaopStr=""
	s anaId=$p(^DHCANOPArrange(opaId),"^",2)
	s adm=$P(anaId,"||",1)
	s chl=$P(anaId,"||",2)
	s num=$L(opstr,"^")
	s anaopSubStr="|"
	f i=1:1:num d
		.q:($p($p(opstr,"^",i),"|",1)="")&($p($p(opstr,"^",i),"|",3)="") //手术ID且手术名为空退出
		.s anaopSubStr=anaopSubStr_$p($p(opstr,"^",i),"|",5)
	    .i anaopSubStr'="|" s anaopSubStr=anaopSubStr_"|"
	s i=0
	s subchl=0 f  s subchl=$O(^OR(adm,"ANA",chl,"OP",subchl)) q:subchl=""  d
		.q:(anaopSubStr)[("|"_subchl_"|")
		.s oprowid=adm_"||"_chl_"||"_subchl
		.s i=i+1
		.if i'=1 d
			..&sql(delete from SQLUSER.OR_Anaest_Operation where anaop_rowid=:oprowid)
			..i SQLCODE'=0  s err="操作失败!"
	q:err'=0 err 
	f i=1:1:num
	{   
	    q:($p($p(opstr,"^",i),"|",1)="")&($p($P(opstr,"^",i),"|",3)="")
	    s anaopOperType="S"
	    s attAnaopSub=$p($p(opstr,"^",i),"|",5)
	    s attOperId=$p($P(opstr,"^",i),"|",1)
	    s attOperDesc=$p($P(opstr,"^",i),"|",3)  //手术备注
	    s bldtpCode=$p($p(opstr,"^",i),"|",4)		//+wxl 091215 手术刀口类型 ANAOP_Blade_DR->ORC_BladeType
		
		s bldtpId=""
		i bldtpCode'="" d
			.i bldtpCode=+bldtpCode s bldtpId=bldtpCode q
			.s bldtpCode=$$ALPHAUP^SSUTIL4(bldtpCode)
			.s bldtpId=$o(^ORC("BLDTP",0,"Code",bldtpCode,""))
		s ancoplCode=$p($p(opstr,"^",i),"|",2)		//+wxl 091215 保存手术级别->ORC_OperationCategay 
	   	s ancoplId=""
		i ancoplCode'="" d
			.i ancoplCode=+ancoplCode s ancoplId=ancoplCode q
			.s ancoplCode=$$ALPHAUP^SSUTIL4(ancoplCode)
			.//s ancoplId=$o(^DHCANC("OPLevel",0,"Code",ancoplCode,""))
			.s ancoplId=$o(^ORC("CATEG",0,"Code",ancoplCode,""))
		//20180118
		s opdocLocId=$p($p(opstr,"^",i),"|",6)
		s opdocId=$p($p(opstr,"^",i),"|",7)
		s assId1=$p($p(opstr,"^",i),"|",8)
		s assId2=$p($p(opstr,"^",i),"|",9)
		s assId3=$p($p(opstr,"^",i),"|",10)
		s assoId=$p($p(opstr,"^",i),"|",11)
		s asso=$tr(assoId,",","@")

		
		s ass=assId1_"@"_assId2_"@"_assId3_"@"_asso
		i attAnaopStr="" d
	    	.s attAnaopStr=attAnaopSub_$c(4)_anaopOperType_$c(4)_attOperId_$c(4)_attOperDesc_$c(4)_bldtpId
	    	.s attAnaopStr=attAnaopStr_$c(4)_ancoplId_$c(4)_opdocLocId_$c(4)_opdocId_$c(4)_ass_$c(4)_$c(3)
	    e  d
	    	.s attAnaopStr=attAnaopStr_attAnaopSub_$c(4)_anaopOperType_$c(4)_attOperId_$c(4)_attOperDesc_$c(4)_bldtpId
	    	.s attAnaopStr=attAnaopStr_$c(4)_ancoplId_$c(4)_opdocLocId_$c(4)_opdocId_$c(4)_ass_$c(4)_$c(3)
	}
	
	//Id：类型：手术Id：手术名称：切口：级别
	s err=##Class(web.DHCANOPCom).UpdateAttOperation(anaId,attAnaopStr,ifAll)
	s err=##class(web.DHCANOPCom).AdjustPlanOperation("",anaId)

	q err
}

ClassMethod GetCtlocDescById(ctlocId)
{
	q:ctlocId="" ""
	s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
	q ctlocId_"!"_ctlocDesc
}

/// w ##class(web.DHCANOPArrangeDayOper).GetPatBaseInfo(130,"164","","In")
ClassMethod GetPatBaseInfo(EpisodeID, opaId, userId, type) As %String
{
	s ward="",operLocId="",operLocDesc="",appDocId="",appDocDesc="",bedCode=""
	s opDescStr="",anMethodStr="",preDiagStr="",otherinfo="",postinfo="",outinfo=""
	s admReasonDr=$p($g(^PAADM(EpisodeID,1)),"^",7)
	i admReasonDr'="" s admReason=$P(^PAC("ADMREA",admReasonDr),"^",2) //费别
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	i curWardId'="" s ward=$P($G(^PAWARD(curWardId)),"^",2)
	i $l(ward,"-")>1 s ward=$p(ward,"-",2)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
		s SecretLevel="",secretCode=""	;病人密级级别
	s SecretLevel=##class(web.DHCClinicCom).GetPatLevelByPapmiId(EpisodeID)
	;secretCode:密级,patLevel:级别
	i SecretLevel'="" s secretCode=$p($g(SecretLevel),"^",4),patLevel=$p($g(SecretLevel),"^",2)

	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	
	s locId=$P($g(^PAADM(EpisodeID)),"^",4)
	s locDes=$P(^CTLOC(locId),"^",2)
	i type="In" d
		.s IPDefOpLocId=$g(^DHCCLSet("AnOp","IPDefOpLoc"))
		.i IPDefOpLocId'="" d
			..s operLocId=IPDefOpLocId
			..s operLocDesc=$p(^CTLOC(operLocId),"^",2)
	s operLoc=operLocId_"!"_operLocDesc
	i userId'="" d
		.s appDocId=$p($g(^SSU("SSUSR",userId)),"^",14)
		.q:appDocId=""
		.s appDocDesc=##class(web.DHCANOPCom).GetNameById(appDocId)
	s appDoc=appDocId_"!"_appDocDesc
	s appLoc=locId_"!"_locDes
	i opaId="" d SetRetData1 q retStr
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$P(anaId,"||",2)
	s EpisodeID=$P(anaId,"||",1)
	s opSub=0 f  s opSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub)) q:(opSub="")  d
		.s preDigDrStr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",4)     ;ANAOP_PreopDiag_DR 术前诊断S //zhangtao add
		.s num=$l(preDigDrStr,"|")
		.f di=1:1:num d
			..s dr=$p(preDigDrStr,"|",di)
			..q:dr=""
			..s desc=$P(^MRC("ID",dr),"^",2)
			..s item=desc
			..i preDiagStr="" s preDiagStr=item
			..e  s preDiagStr=preDiagStr_","_item
	.s opDes=""
	.s opDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",6)         ;ANAOP_Type_DR     ；手术名称
	.i opDr'="" d
		..i $D(^ORC("OPER",opDr)) d
			...s opDes=$P(^ORC("OPER",opDr),"^",2)
		..i opDescStr'=""  s opDescStr=opDescStr_","_opDes
		..e  s opDescStr=opDes
	
	s anMethDr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)       ;ANA_Method	麻醉方法
	i anMethDr'="" d
		.s anMethNum=$l(anMethDr,"|")
		.f i=1:1:anMethNum d
		..s anMethId=$p(anMethDr,"|",i)
		..q:anMethId=""
		..s anMethDesc=$p($g(^ORC("ANMET",anMethId)),"^",2)
		..i $P(anMethDesc,"-",2)'="" s anMethDesc=$P(anMethDesc,"-",2)
		..i anMethodStr="" s anMethodStr=anMethId_"!"_anMethDesc
		..e  s anMethodStr=anMethodStr_","_anMethId_"!"_anMethDesc	
	s otherinfo=..GetPreDayOperInfo(opaId)
   	s postinfo=..GetPostDayOperInfo(opaId)
   	s outinfo=..GetOutDayOperInfo(opaId)
	d SetRetData1 q retStr
SetRetData1
	//病人基本信息
	s patientBaseInfo=EpisodeID_"^"_patName_"^"_regNo_"^"_sex_"^"_age_"^"_locDes_"^"_ward_"^"_bedCode_"^"_admReason_"^"_SecretLevel_"^"_secretCode
    s operInfo=anMethodStr_"^"_opDescStr_"^"_preDiagStr
    //
    s retStr=patientBaseInfo_"@"_operInfo_"@"_otherinfo_"@"_postinfo_"@"_outinfo
}

ClassMethod SaveDayOperANMInfo(anmth, opaId, userId)
{
	s anaId=$P($g(^DHCANOPArrange(opaId)),"^",2)
	s chl=$p(anaId,"||",2)
	s adm=$p(anaId,"||",1)

	s anmetId=$tr(anmth,",","|")
	i anmetId'="" s $P(^OR(adm,"ANA",chl),"^",5)=anmetId 
	q 0
}

ClassMethod SaveDayOperInfo(preStr, opaId, userId)
{
	s ret=0
	s anaId=$P($g(^DHCANOPArrange(opaId)),"^",2)
	s chl=$p(anaId,"||",2)
	s adm=$p(anaId,"||",1)
	;扩展数据保存
	s prelen=$l(preStr,"^")
	f pl=1:1:prelen d
		.s prestr=$p(preStr,"^",pl)
		.q:prestr=""
		.s preNote=$p(prestr,":",1)
		.s preValue=$p(prestr,":",2)
		.s paraStr=""
		.s paraStr=preNote_$c(3)_preValue
		.s ret=##Class(web.DHCANOPArrangeExtend).SaveArrangeExtend(opaId,paraStr,userId)
		.i +ret<0 q:"-111^插入扩展数据错误"_paraStr
	q ret
}

/// w ##class(web.DHCANOPArrangeDayOper)GetPreDayOperInfo("164")
ClassMethod GetPreDayOperInfo(opaId)
{
	s retstr=""
	s str="BDS_ASAIVOrV:"_"BDS_ChildInDanger:"_"BDS_LossMoreBlood:"_"BDS_Disease:"_"BDS_RespiaratDif:"
	_"BDS_BreathDif:"_"BDS_LongRFatAndSleep:"_"BDS_DrugAddiction:"_"BDS_BipolarDisorder:"_"BDS_NoCompanion:"
	_"BDS_IsCanDayOper:"_"BDS_OtherNote:"_"Pre_Height:"_"Pre_Weight:"_"Pre_Pulse:"
	_"Pre_Respiration:"_"Pre_BP:"_"ASAClass:"

	s prelength=$l(str,":")
	f prel=1:1:prelength d
		.s note=$p(str,":",prel)
		.q:note=""
		.s value=""
		.s ret=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,note)
		.i ret'="" s value=$p(ret,$c(3),1)
		.e  s value=" "
		.i retstr="" s retstr=value
		.e  s retstr=retstr_"^"_value
	q retstr
}

// w ##class(web.DHCANOPArrangeDayOper).GetPostDayOperInfo("164")

ClassMethod GetPostDayOperInfo(opaId)
{
	s retstr=""
	s str="PDS_MoveScore:"_"PDS_RespScore:"_"PDS_CircleScore:"_"PDS_CondciousScore:"
	_"PDS_SPO2Score:"_"PDS_AldreteScore:"_"PDS_OtherNote:"_"ASAClass:"

	s prelength=$l(str,":")
	f prel=1:1:prelength d
		.s note=$p(str,":",prel)
		.q:note=""
		.s value=""
		.s ret=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,note)
		.i ret'="" s value=$p(ret,$c(3),1)
		.e  s value=" "
		.i retstr="" s retstr=value
		.e  s retstr=retstr_"^"_value
	q retstr
}

ClassMethod GetOutDayOperInfo(opaId)
{
	s retstr=""
	s str="ODS_VitalSignScore:"_"ODS_MoveScore:"_"ODS_VomitScore:"_"ODS_PainScore:"
	_"ODS_BleedingScore:"_"ODS_OutScore:"_"ODS_OtherNote:"_"ASAClass:"

	s prelength=$l(str,":")
	f prel=1:1:prelength d
		.s note=$p(str,":",prel)
		.q:note=""
		.s value=""
		.s ret=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,note)
		.i ret'="" s value=$p(ret,$c(3),1)
		.e  s value=" "
		.i retstr="" s retstr=value
		.e  s retstr=retstr_"^"_value
	q retstr
}

ClassMethod GetAnSingle(opaId As %String, EpisodeID As %String = "", userId As %String = "", type As %String = "") As %String
{
	//n (itmjs,itmjsex,opaId,EpisodeID,userId)
	i EpisodeID="",opaId'="" s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
	q:EpisodeID="" ""
	s anaesRowId=""
	
	//s transferMeans="",transferMeansCode="",docAnMethod="",IsPapEstimDS="N"
	
	s admReason="",bedCode="",ward="",regNo="",patName="",age="",sex="",infection="",locId="",locDes="",secretCode="",patLevel="",opDocGroup="",IsPapEstimDS=""
	s opDate="",operLocId="",operLocDesc="",appDocId="",appDocDesc="",appLocId="",appLocDesc="",transferMeans="",opMem="",bloodType="",arrDateTime="",isAddInstrument="",instrumentDr="",instrument="",surgeonDr="",surgeonDesc="",surgeon="",opCategory="",postDiag="",assistants="",opDocNote="",opSeqNote="",bodsList="",operPosition=""
	s anDoc="",anSupDoc="",anNurse="",anAssStr="",shiftAnAssStr="",anMethodStr="",anaLevel="",anDocNote="",anDocMethodStr=""
	s opRoom="",opaSeq="",scNurStr="",sScNurStr="",cirNurStr="",sCirNurStr="",scnShiftTime="",cirShiftTime="",scNurNote="",cirNurNote="" 
	s opStDate="",opStTime="",opArrDate="",opArrTime="",opEndDate="",opEndTime="",preDiscussDate="",estiOperDuration="",anaTheatreInDate="",anaTheatreInTime="",anaTheatreOutDate="",anaTheatreOutTime=""
	s selfReport="",operResource="",telId="",queueNo="",patNotice="",operStock="",operStockNote="",comeTime="",surgeonLoc="",patDiseaseHis="" //lyn add 门诊扩展项 主诉，资源，病人电话，号源，病人须知
	s dateformatnum=##class(websys.Conversions).DateFormat()	//20170302+dyl
	//s timeformatnum=##class(websys.Conversion).TimeFormat()
	s timeformatnum=2
	s admReasonDr=$p($g(^PAADM(EpisodeID,1)),"^",7)
	i admReasonDr'="" s admReason=$P(^PAC("ADMREA",admReasonDr),"^",2) //费别
	s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
	s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
	i bedSub'="" s bedCode=$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
	i curWardId'="" s ward=$P($G(^PAWARD(curWardId)),"^",2)
	i $l(ward,"-")>1 s ward=$p(ward,"-",2)
	s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
	s SecretLevel=""	;病人密级级别
	s SecretLevel=##class(web.DHCClinicCom).GetPatLevelByPapmiId(EpisodeID)
	;secretCode:密级,patLevel:级别
	i SecretLevel'="" s secretCode=$p($g(SecretLevel),"^",4),patLevel=$p($g(SecretLevel),"^",2)
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	;s age=##class(web.UDHCANOPArrange).CalAge(birth,+$h)
	s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s telId=$p($g(^PAPER(papmiId,"PER",1)),"^",11)   //手机
	s infection=##class(web.UDHCANOPArrange).GetQueryInfPyObjDrugByPaadmStr(EpisodeID)
	s locId=$P($g(^PAADM(EpisodeID)),"^",4)
	s locDes=$P(^CTLOC(locId),"^",2)
	i $l(locDes,"-")>1 s locDes=$p(locDes,"-",2)
	;s papEstimDCDate=$p($g(^PAADM(EpisodeID)),"^",59)
	;PAADM_DischgDate
	s IsPatDisCharFlag=""
	;s papDisCharDate=$p($g(^PAADM(EpisodeID)),"^",17)
	;s papVStatus=$p($g(^PAADM(EpisodeID)),"^",20)
	;i ((papDisCharDate'="")) d
    ;.s IsPatDisCharFlag="Y"
	;病人出院时间
	s patDisDate=""
	s patDisCharDate=##class(web.DHCDischargeHistory).GetDischargeDateTime(EpisodeID)
	i patDisCharDate'="" s patDisDate=$p(patDisCharDate,"^",1)
	;病人出院状态
	s patOutStatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
	i (patDisDate'="")&(patOutStatus'="B") s IsPatDisCharFlag="Y"
    //获取手术日期
    ;s opStDate=##class(web.DHCANOPCom).GetOperDate()
    
    s opStDate=""
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
	i userId'="" d
		.s appDocId=$p($g(^SSU("SSUSR",userId)),"^",14)
		.q:appDocId=""
		.s appDocDesc=##class(web.DHCANOPCom).GetNameById(appDocId)
	s appDoc=appDocId_"!"_appDocDesc
	s curloglocId=%session.Data("LOGON.CTLOCID")
	s curloglocDes=$P($g(^CTLOC(+curloglocId)),"^",2)
	s appLoc=curloglocId_"!"_curloglocDes
	////术前诊断
	s mainDiag=..GetAllMDiagnos(EpisodeID)
	s diagNotes=..GetAllDiagNote(EpisodeID)
	s retSlaveDiag=##class(web.DHCANOPPREDIAG).GetAllMDiagnos(EpisodeID)	
	;s slaveDiag=$p(retSlaveDiag,"$",1)
	;s slaveDiag=$tr(slaveDiag,"|",",")	
	;s diagNotes=$p(retSlaveDiag,"$",2)
	s slaveDiag=""
	s preDiag=mainDiag   //获取诊断记录
	i diagNotes="" s preDiagAndNotes=preDiag_"#"_slaveDiag
	e  s preDiagAndNotes=preDiag_"#"_diagNotes
	s preDiagAndNotes=$tr(preDiagAndNotes,"^","")
	i appDocId'="" d  //门诊手术排班-病人须知  add by lyn
    	.s appSetInfo=$g(^DHCANOP("APPSET","DOC",appDocId))
    	.s patNotice=$p(appSetInfo,"^",1)
	i opaId="" d SetRetData q retStr
	
	
	s appDocId=$P(^DHCANOPArrange(opaId),"^",6)
	i appDocId'="" s appDocDesc=##class(web.DHCANOPCom).GetNameById(appDocId)
	s appDoc=appDocId_"!"_appDocDesc
	s appLocId=$p($g(^DHCANOPArrange(opaId)),"^",54)
	i appLocId'="" s appLocDesc=$P($g(^CTLOC(appLocId)),"^",2)
	i $l(appLocDesc,"-")>1 s appLocDesc=$p(appLocDesc,"-",2)
	s appLoc=appLocId_"!"_appLocDesc
	s opStDate=$P(^DHCANOPArrange(opaId),"^",14)
	s opDocGroup=""	
	/*
	单条对单独医生以后不再保存手术医师组：20180122+dyl
	s retStrC=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperMedUnitId")
	i retStrC'="" s opDocGroup=$p(retStrC,$c(3),1)
	*/
	;s age=##class(web.UDHCANOPArrange).CalAge(birth,opStDate)
	s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
	i opStDate'="" s opStDate=$zd(opStDate,dateformatnum)
	s opStTime=$P(^DHCANOPArrange(opaId),"^",15)
	s opArrDate=$P(^DHCANOPArrange(opaId),"^",7)
	s opArrTime=$P(^DHCANOPArrange(opaId),"^",8)
	s opEndDate=$P(^DHCANOPArrange(opaId),"^",16)
	s opEndTime=$P(^DHCANOPArrange(opaId),"^",17)
	i opStTime'="" s opStTime=$ZT(opStTime,2)
	i opArrDate'="" s opArrDate=$ZD(opArrDate,dateformatnum)	//20170302+dyl
	i opArrTime'="" s opArrTime=$ZT(opArrTime,timeformatnum)
	s arrDateTime=opArrDate_" "_opArrTime
	i opEndDate'=""  s opEndDate=$ZD(opEndDate,dateformatnum)	
	i opEndTime'=""  s opEndTime=$ZT(opEndTime,timeformatnum)
	s preDiscussDate=$P(^DHCANOPArrange(opaId),"^",38)
	i preDiscussDate'="" s preDiscussDate=$zd(preDiscussDate,dateformatnum)
	s estiOperDuration=$P(^DHCANOPArrange(opaId),"^",37)
	;20161214+dyl
	;i estiOperDuration'="" s estiOperDuration=$ZT(estiOperDuration,2)
	s transferMeansCode=$p(^DHCANOPArrange(opaId),"^",39)  
	i transferMeansCode="W" s transferMeans="自行" 
	i transferMeansCode="C" s transferMeans="轮椅"
	i transferMeansCode="S" s transferMeans="平车"
	s opMem=$P(^DHCANOPArrange(opaId),"^",19)
	s bldTypId=$P(^DHCANOPArrange(opaId),"^",11)
	i bldTypId'="" s bldTypDesc=$P($G(^PAC("BLDT",bldTypId)),"^",2)
	e  s bldTypDesc="未知"
	s bloodType=bldTypId_"!"_bldTypDesc
	s instrumentDr=$P($G(^DHCANOPArrange(opaId)),"^",30) 
	i instrumentDr'="" s instrument=$P($G(^DHCANC("Instrument",instrumentDr)),"^",2)  	//DHC_ANC_Instrument	器械
	e  s instrument=""
	s isAddInstrument=$P($G(^DHCANOPArrange(opaId)),"^",31) 			//OPA_AddInstrument		是否补充器械
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
	.i surgeonDr'="" s surgeonDesc=##class(web.DHCANOPCom).GetNameById(surgeonDr)
	.s surgeon=surgeonDr_"!"_surgeonDesc
	.;e  s surgeon=$TR($p($p(^DHCANOPArrange(opaId),"^",42),"|",2)," ","")  //自填写手术医生
	.s opDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",6)         ;ANAOP_Type_DR     ；手术名称
	.s opDes=""
	.i opDr'="" d
	..i $D(^ORC("OPER",opDr)) d
	...s opDes=$P(^ORC("OPER",opDr),"^",2)
	...s opCategoryId=$p(^ORC("OPER",opDr),"^",7)  					 // 手术分类
    ...i opCategoryId'=""  s opCategory=$p($g(^ORC("CATEG",opCategoryId)),"^",2)
    ...s opStatName=$P(^ORC("OPER",opDr),"^",35) 						 //手术统计名称
    .s operation=opDr_"!"_opDes
	.s operLocId=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",10) 
	.s operLocDesc="" 
	.i operLocId'="" s operLocDesc=$p(^CTLOC(operLocId),"^",2)
	.s operLoc=operLocId_"!"_operLocDesc
	.s bodsIdList=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub),"^",24) 	 //手术部位
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
	..i assistants="" s assistants=assistantDr_"!"_##class(web.DHCANOPCom).GetNameById(assistantDr)
	..e  s assistants=assistants_"#"_assistantDr_"!"_##class(web.DHCANOPCom).GetNameById(assistantDr)
    .s operPositionId=$P($G(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"POS",1)),"^")
	.i operPositionId'=""  d
	..s operPositionDesc=$P($G(^ORC("OPPOS",operPositionId)),"^",2)
	.e  s operPositionDesc=""
	.s operPosition=operPositionId_"!"_operPositionDesc
	s opSeqNote=$P($G(^DHCANOPArrange(opaId)),"^",41) //手术编号
	s opDocNote=$P($G(^DHCANOPArrange(opaId)),"^",42)
	s opMem=$P(^DHCANOPArrange(opaId),"^",19) //手术要求
	//麻醉////////////////////////////////
	
	s anDocDr=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",6)        		//ANA_Anaesthetist_Dr	麻醉医师
	i anDocDr'="" d			 	;麻醉医师
	.s anDocDesc=##class(web.DHCANOPCom).GetNameById(anDocDr) 
	e  s anDocDesc=""
	s anDoc=anDocDr_"!"_anDocDesc
	s anSupDr=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",7)        		//ANA_Supervisor_Dr ///ck091203
	i anSupDr'="" d 	 	;麻醉辅导医师
	.s anSupDesc=##class(web.DHCANOPCom).GetNameById(anSupDr)
	e  s anSupDesc=""
	s anSupDoc=anSupDr_"!"_anSupDesc
	s anNurseDr=$P(^OR(EpisodeID,"ANA",anaSub),"^",8)			//ANA_ORAnaNurse_DR		麻醉护士
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
	s anMethDr=$P(^OR(EpisodeID,"ANA",anaSub),"^",5)       ;ANA_Method	麻醉方法
	i anMethDr'="" d
		.s anMethNum=$l(anMethDr,"|")
		.f i=1:1:anMethNum d
		..s anMethId=$p(anMethDr,"|",i)
		..q:anMethId=""
		..s anMethDesc=$p($g(^ORC("ANMET",anMethId)),"^",2)
		..i $P(anMethDesc,"-",2)'="" s anMethDesc=$P(anMethDesc,"-",2)
		..i anMethodStr="" s anMethodStr=anMethId_"!"_anMethDesc
		..e  s anMethodStr=anMethodStr_","_anMethId_"!"_anMethDesc	
	s anDocMethodStr=""
	s anDocMethDr=$P(^DHCANOPArrange(opaId,"PA"),"^",89)
	i anDocMethDr'="" d
		.s anDocMethNum=$l(anDocMethDr,"|")
		.f i=1:1:anDocMethNum d
			..s anDocMethId=$p(anDocMethDr,"|",i)
			..q:anDocMethId=""
			..s anDocMethDesc=$p($g(^ORC("ANMET",anDocMethId)),"^",2)
			..i $P(anDocMethDesc,"-",2)'="" s anDocMethDesc=$P(anDocMethDesc,"-",2)
			..i anDocMethodStr="" s anDocMethodStr=anDocMethId_"!"_anDocMethDesc
			..e  s anDocMethodStr=anDocMethodStr_","_anDocMethId_"!"_anDocMethDesc	
	
	
	s anaLevelDr=""
	s anaLevelDr=$P(^DHCANOPArrange(opaId),"^",28)
	i anaLevelDr'="" s anaLevelDesc=$P($g(^DHCANC("OPLevel",anaLevelDr)),"^",2)
	e  s anaLevelDesc=""
	s anaLevel=anaLevelDr_"!"_anaLevelDesc
	s anDocNote=$P($G(^DHCANOPArrange(opaId)),"^",43)
	s anaTheatreInDate=$p(^OR(EpisodeID,"ANA",anaSub),"^",39)
	i anaTheatreInDate'="" s anaTheatreInDate=$zd(anaTheatreInDate,dateformatnum)	//20170302+dyl
	e  s anaTheatreInDate=opStDate
	s anaTheatreInTime=$p(^OR(EpisodeID,"ANA",anaSub),"^",40)
	i anaTheatreInTime'="" s anaTheatreInTime=$zt(anaTheatreInTime,timeformatnum)
	e  s anaTheatreInTime=opStTime
	s anaTheatreOutDate=$p(^OR(EpisodeID,"ANA",anaSub),"^",41)
	i anaTheatreOutDate'="" s anaTheatreOutDate=$zd(anaTheatreOutDate,dateformatnum)
	s anaTheatreOutTime=$p(^OR(EpisodeID,"ANA",anaSub),"^",42)
	i anaTheatreOutTime'="" s anaTheatreOutTime=$zt(anaTheatreOutTime,timeformatnum)
	///手术室
	s opRoomDr=$P($g(^DHCANOPArrange(opaId)),"^",20)
	s opRoomDesc=""
	i opRoomDr'="" s opRoomDesc=$P($G(^DHCANC("OPRoom",opRoomDr)),"^",2)
	s opRoom=opRoomDr_"!"_opRoomDesc
	s opaSeq=$P(^DHCANOPArrange(opaId),"^",26) 							//OPA_seq	台次               
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
	   .i scNurStr="" s scNurStr=scnDr_"!"_##class(web.DHCANOPCom).GetNameById(scnDr)
	   .e  s scNurStr=scNurStr_","_scnDr_"!"_##class(web.DHCANOPCom).GetNameById(scnDr)
	s id=20 f  s id=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",id)) q:(id="")  d
	   .s scnDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"SCN",id),"^",1)
	   .q:scnDr=""
	   .i sScNurStr="" s sScNurStr=scnDr_"!"_##class(web.DHCANOPCom).GetNameById(scnDr)
	   .e  s sScNurStr=sScNurStr_","_scnDr_"!"_##class(web.DHCANOPCom).GetNameById(scnDr)
	
	s cirNurStr="",sCirNurStr=""  ;巡床
	s id=0 f  s id=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",id)) q:(id="")!(id>20)   d
	.s cirDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",id),"^",1)
	.q:cirDr=""
	.i cirNurStr=""  s cirNurStr=cirDr_"!"_##class(web.DHCANOPCom).GetNameById(cirDr)
	.e  s cirNurStr=cirNurStr_","_cirDr_"!"_##class(web.DHCANOPCom).GetNameById(cirDr)
	s id=20 f  s id=$O(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",id)) q:(id="")   d
	   .s cirDr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",opSub,"CIRN",id),"^",1)
	   .q:cirDr=""
	   .i sCirNurStr=""  s sCirNurStr=cirDr_"!"_##class(web.DHCANOPCom).GetNameById(cirDr)
	   .e  s sCirNurStr=sCirNurStr_","_cirDr_"!"_##class(web.DHCANOPCom).GetNameById(cirDr)
	s scNurNote=$p($G(^DHCANOPArrange(opaId)),"^",51)			//OPA_ScrubNurseNote 	器械护士,手术录入
	s cirNurNote=$p($G(^DHCANOPArrange(opaId)),"^",52)			//OPA_CirculNurseNote	巡回护士,手工录入
	
	/************************start门诊手术排班信息*************************/
    ;获取主诉
	s selfReport=""  ; OPA.SelfReport (扩展字段) 主诉
	s retSe=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.SelfReport")
	i retSe'="" s selfReport=$p(retSe,$c(3),1)
	
	;获取门诊手术排班资源(暂时未使用)
	s operResource="",resourceDesc="",asTimeRangeDr="",operResourceId=""  ; OPA.OperResource (扩展字段门诊手术预约资源)
	s retOR=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperResource")
	i retOR'="" s operResourceId=$p(retOR,$c(3),1)
	i operResourceId'="" d
	.s reRowid=$p(operResourceId,"||",1)
	.s reSubId=$p(operResourceId,"||",2)
	.i reRowid'="" d
		..s resourceDesc=$p(^RB("RES",reRowid),"^",17) //资源描述
		..s asTimeRangeDr=$P($g(^RBAS(reRowid,reSubId,"DHC")),"^",17) //排班时段
		..s asTimeRangeDesc=$p($g(^DHCTimeRange(asTimeRangeDr)),"^",2) //排班时段描述
		..s resourceDesc=resourceDesc_"  "_asTimeRangeDesc
		..S operResource=operResourceId_"!"_resourceDesc
	
	;获取号源信息 OPA.QueueNo (扩展字段门诊手术预约号) (暂时未使用)
	s queueNo=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.QueueNo")
	s queueNo=$p(queueNo,$c(3),1)
	;病人须知 ;OPA.PatNotice(扩展字段病人须知) 
	//s patNotice=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.PatNotice")
	s patNotice=$g(^DHCANOPArrange("PatNotice",opaId))
	
	;手术耗材 OPA.OperStock(扩展字段病人须知) 
	s retOS=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperStock")
	s operStockStr=$p(retOS,$c(3),1)
	i operStockStr'="" d
	.f i=1:1:$l(operStockStr,",") D
		..s operStId=$p(operStockStr,",",i)
		..q:'$d(^DHCANOPLOCStock(appLocId,operStId))
		..s ancDesc=$p($g(^DHCANOPLOCStock(appLocId,operStId)),"^",2)
		..i operStock="" s operStock=operStId_"!"_ancDesc
		..e  s operStock=operStock_","_operStId_"!"_ancDesc
	
	;患者电话 OPA.PatTel(扩展字段患者电话) 
	s telId=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.PatTel")
	s telId=$p(telId,$c(3),1)
	b
	;备用耗材备注 ;OPA.OperStockNote(扩展字段耗材备注) 
	s operStockNote=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.OperStockNote")
	s operStockNote=$p(operStockNote,$c(3),1)
	b
	;来院时间 ;OPA.PatComeHosTime(扩展字段来院时间) 
	s comeDTime=##class(web.DHCANOPArrangeExtend).SetArrangeExtendValue(opaId,"OPA.PatComeHosTime")
	s comeDTime=$p(comeDTime,$c(3),1)
	s comeDTime=$p(comeDTime,",",2)
	i comeDTime'="" s comeTime=##class(web.DHCClinicCom).ConvertToTime(comeDTime)
	i comeTime'="" s comeTime=$e(comeTime,1,5)
	/************************end门诊手术排班信息*************************/
	d SetRetData
	q retStr
SetRetData
	//病人基本信息
	s patientBaseInfo=EpisodeID_"^"_patName_"^"_regNo_"^"_sex_"^"_age_"^"_locDes_"^"_ward_"^"_bedCode_"^"_admReason_"^"_secretCode_"^"_patLevel_"^"_IsPatDisCharFlag_"^"_telId
    //病区信息
    s patWardInfo=operLoc_"^"_appLoc_"^"_appDoc_"^"_preDiagAndNotes_"^"_postDiag_"^"_surgeon_"^"_assistants_"^"_opDocNote_"^"_opMem_"^"_bodsList_"^"_operPosition_"^"_bloodType_"^"_opSeqNote_"^"_opDocGroup
    s patWardInfo=patWardInfo_"^"_selfReport_"^"_operResource_"^"_queueNo_"^"_patNotice_"^"_operStock_"^"_operStockNote_"^"_comeTime_"^"_surgeonLoc_"^"_patDiseaseHis ;update by lyn 
    //麻醉信息
    s anaesInfo=anDoc_"^"_anSupDoc_"^"_anNurse_"^"_anAssStr_"^"_shiftAnAssStr_"^"_anMethodStr_"^"_anaLevel_"^"_anDocNote_"^"_anDocMethodStr
    //手术室信息
    s opTheatreInfo=opRoom_"^"_opaSeq_"^"_scNurStr_"^"_sScNurStr_"^"_cirNurStr_"^"_sCirNurStr_"^"_scNurNote_"^"_cirNurNote 
    //手术时间
    s opDateTime=opStDate_"^"_opStTime_"^"_opArrDate_"^"_opArrTime_"^"_opEndDate_"^"_opEndTime_"^"_preDiscussDate_"^"_estiOperDuration_"^"_anaTheatreInDate_"^"_anaTheatreInTime_"^"_anaTheatreOutDate_"^"_anaTheatreOutTime_"^"_scnShiftTime_"^"_cirShiftTime
    //
    s retStr=patientBaseInfo_"@"_patWardInfo_"@"_anaesInfo_"@"_opTheatreInfo_"@"_opDateTime
}

/// w ##class(web.DHCANOPArrangeDayOper).GetAllMDiagnos(1992)
ClassMethod GetAllMDiagnos(Adm) As %String
{
  q:Adm="" ""
  s diagdes=""
    s diagdes=""
  ;业务，考虑到如果加前缀可能把诊断当成自定义，暂时不加，以后再改造
  s mradm=$P(^PAADM(Adm),"^",61)
   s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradm)
	s digStrLength=$l(diagInfoStr,"^")
	f dnum=1:1:digStrLength d
		.s curDiagStr=$p(diagInfoStr,"^",dnum)
		.s curDigDesc=$p(curDiagStr,"&&",1)
		.s curDigId=$p(curDiagStr,"&&",2)
		.s curDigNote=$p(curDiagStr,"&&",3)
		.s curPreFix=$p(curDiagStr,"&&",4)
		.s curDigType=$p(curDiagStr,"&&",5)
		.s curDigMainFlag=$p(curDiagStr,"&&",6)
		.;q:curDigMainFlag'="Y"
		.s newDiagStr=curDigId_"!"_curDigDesc
		.i diagdes'="" s diagdes=diagdes_","_newDiagStr
		.e  s diagdes=newDiagStr

  /*
  s mradm=$P(^PAADM(Adm),"^",61)
  s mcl=0  f  s mcl=$O(^MR(mradm,"DIA",mcl) ) q:(mcl="")  d
  	  .s typcl=0  f  s typcl=$O(^MR(mradm,"DIA",mcl,"TYP",typcl)) q:(typcl="")  d
		  ..s diagtypId=$P(^MR(mradm,"DIA",mcl,"TYP",typcl),"^",1)
		  ..q:diagtypId=""
		  ..s diagtyp=$P($g(^MRC("DTYP",diagtypId)),"^",1)
		  ..q:diagtyp="DIS"
	  .s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
	  .;q:$P(^MR(mradm,"DIA",mcl,1),"^",20)'="Y"
	  .i +icddr>0  d
		  ..i diagdes'="" s diagdes=diagdes_","_icddr_"!"_$P(^MRC("ID",icddr),"^",2)
		  ..e  s diagdes=icddr_"!"_$P(^MRC("ID",icddr),"^",2)
		  */
		  
  q diagdes
}

/// w ##class(web.DHCANOPArrangeDayOper).GetAllDiagNote(283)
ClassMethod GetAllDiagNote(Adm) As %String
{
  q:Adm="" ""
  s diagnote=""
    s mradm=$P(^PAADM(Adm),"^",61)
  s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradm)
	s digStrLength=$l(diagInfoStr,"^")
	f dnum=1:1:digStrLength d
		.s curDiagStr=$p(diagInfoStr,"^",dnum)
		.s curDigDesc=$p(curDiagStr,"&&",1)
		.s curDigId=$p(curDiagStr,"&&",2)
		.s curDigNote=$p(curDiagStr,"&&",3)
		.s curPreFix=$p(curDiagStr,"&&",4)
		.s curDigType=$p(curDiagStr,"&&",5)
		.s curDigMainFlag=$p(curDiagStr,"&&",6)
		.;q:curDigMainFlag'="Y"
		.s newDiagStr=curDigId_"!"_curDigDesc
		.i diagnote'="" s diagnote=diagnote_","_curDigNote
		.e  s diagnote=curDigNote


  /*
  s mradm=$P(^PAADM(Adm),"^",61)
  s mcl=0  f  s mcl=$O(^MR(mradm,"DIA",mcl) ) q:(mcl="")  d
  	  .s typcl=0  f  s typcl=$O(^MR(mradm,"DIA",mcl,"TYP",typcl)) q:(typcl="")  d
		  ..s diagtypId=$P(^MR(mradm,"DIA",mcl,"TYP",typcl),"^",1)
		  ..q:diagtypId=""
		  ..s diagtyp=$P($g(^MRC("DTYP",diagtypId)),"^",1)
		  ..q:diagtyp="DIS"
	  .s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
	  .s mainNote=$g(^MR(mradm,"DIA",mcl,"DES",1))
	  .;q:$P(^MR(mradm,"DIA",mcl,1),"^",20)'="Y"
	  .i +icddr>0  d
		  ..i diagnote'="" s diagnote=diagnote_","_mainNote
		  ..e  s diagnote=mainNote
		  */
  q diagnote
}

}
