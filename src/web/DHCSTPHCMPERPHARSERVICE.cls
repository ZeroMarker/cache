/// Descript:个人药学服务查询类
Class web.DHCSTPHCMPERPHARSERVICE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:个人药学服务树
/// W ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonPerPharServiceTree("5")
ClassMethod jsonPerPharServiceTree(EpisodeID As %String) As %String
{
	N (EpisodeID)

	S pid=..NewPid()
	d ..killTmpGlobal(pid)

	s Num = 1
	/// 药学查房
	s Num = ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonWardRound(pid,Num,EpisodeID)
	
	/// 用药建议
	s Num = ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonMedAdvice(pid,Num,EpisodeID)
	
	/// 医学查房
	s Num = ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonCliPathography(pid,Num,EpisodeID)
	
	/// 用药教育
	s Num = ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonMedEducation(pid,Num,EpisodeID)
	
	/// 药学监护
	s Num = ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonPhaCare(pid,Num,EpisodeID)

	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S count=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,index)) Q:index=""  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,index)
	.S count=count+1
	.I count=1 d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData("bstype^id^text^_parentId",mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstype^id^text^_parentId",mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符

	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:药学查房
/// W ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonWardRound("16243032",1,5)
ClassMethod jsonWardRound(pid As %String, num As %String, EpisodeID As %String) As %String
{
	n (pid, num, EpisodeID,%session)
	s Phward=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("药学查房")
	s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="WR^wr^"_Phward_"^"
	/// 入院记录
	s wardRoundID=$o(^DHCPHWR("0","CurStatus","N",EpisodeID,""))
	i wardRoundID'="" d
	.s PhwardNew=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("入院记录")
	.s mdata="WR"_"^"_"WR-"_wardRoundID_"^"_PhwardNew_"^"_"wr"
	.s num=num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)=mdata
    s PhwardIn=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("日常查房记录")
	s num=num+1
	s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="WR^I^"_PhwardIn_"^wr"
	
	/// 日常查房记录
	//s num=0
	s wardRoundID=""
	f  s wardRoundID=$o(^DHCPHWR("0","CurStatus","I",EpisodeID,wardRoundID)) q:wardRoundID=""  d
	.s userID=$p(^DHCPHWR(wardRoundID),"^",8)    //记录人
	.q:userID=""
	.q:'$d(^SSU("SSUSR",+userID))
	.s userName=$p(^SSU("SSUSR",userID),"^",2)   //姓名
	.s wrDate=$p(^DHCPHWR(wardRoundID),"^",9)    //日期
	.s:wrDate'="" wrDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(wrDate) //$zd(wrDate,3) 
	.s wrTime=$p(^DHCPHWR(wardRoundID),"^",10)   //时间
	.s:wrTime'="" wrTime=$zt(wrTime,2)
	.s userName=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",userName)
	.s mdata="WR"_"^"_"WR-"_wardRoundID_"^"_wrDate_" "_wrTime_" "_userName_"^"_"I"
	.s num=num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)=mdata
	.
	
	/// 出院记录
	s wardRoundID=$o(^DHCPHWR("0","CurStatus","O",EpisodeID,""))
	i wardRoundID'="" d
	.s PhwardOut=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("出院记录")
	.s mdata="WR"_"^"_"WR-"_wardRoundID_"^"_PhwardOut_"^"_"wr"
	.s num=num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)=mdata
	b //11
	q num
}

/// Descript:用药建议
/// W ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonMedAdvice("2","1","16243032")
ClassMethod jsonMedAdvice(pid As %String, num As %String, EpisodeID As %String)
{
	n (pid, num, EpisodeID,%session)
	s num=num+1
	s Advice=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("用药建议")
	s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="MA^ma^"_Advice_"^"

	s flag=0
	s medAdvID=""
	f  s medAdvID=$o(^DHCPHAD(0,"AdmDr",EpisodeID,medAdvID)) q:medAdvID=""  d
	.q:'$d(^DHCPHAD(medAdvID))
	.s medAdvUser=$p(^DHCPHAD(medAdvID),"^",2)     //建议人
	.s:medAdvUser'="" medAdvUser=$p(^SSU("SSUSR",medAdvUser),"^",2)
	.s:medAdvUser["/" medAdvUser=$p(medAdvUser,"/",2)
	.s medAdvDate=$p(^DHCPHAD(medAdvID),"^",4)     //记录日期
	.s:medAdvDate'="" medAdvDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(medAdvDate) ;$zd(medAdvDate,3)
	.s medAdvTime=$p(^DHCPHAD(medAdvID),"^",5)     //记录时间
	.s:medAdvTime'="" medAdvTime=$zt(medAdvTime,2)
	.s medAdvCurStatus=$p(^DHCPHAD(medAdvID),"^",6) //当前状态
	.q:medAdvCurStatus=0
	.s medAdvCurStatus=$S(medAdvCurStatus="10":"提议",medAdvCurStatus="20":"申诉",medAdvCurStatus="30":"已接受",medAdvCurStatus="40":"同意用药",1:"")
	.s medAdvUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",medAdvUser)
	.s medAdvCurStatus=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(medAdvCurStatus)
	.s mdata="MA"_"^"_"MA-"_medAdvID_"^"_medAdvDate_" "_medAdvTime_" "_medAdvUser_" "_medAdvCurStatus_"^"_"ma"
	.s num=num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)=mdata
	.s flag=1
	.
	i flag=0 d
	.s num=num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="MA^EMP^^"_Advice
	q num
}

/// Descript:医学查房
/// W ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonCliPathography("2","1","16243032")
ClassMethod jsonCliPathography(pid As %String, num As %String, EpisodeID As %String) As %String
{
	n (pid, num, EpisodeID,%session)
	s num=num+1
	s Phcli=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("医学查房")
	s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="CP^cp^"_Phcli_"^"
	
	s cliPhaID=$o(^DHCPHCP(0,"Adm",EpisodeID,""))
	i cliPhaID'="" d
	.s num=num+1
	.s PhcliNew=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("首次查房")
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="CP"_"^"_"CP-"_cliPhaID_"^"_PhcliNew_"^cp"
    
	s num=num+1
	s PhcliIn=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("日常查房")
	s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="CP^cpI^"_PhcliIn_"^cp"

	//s num=0
	//s cliPhaID=0
	f  s cliPhaID=$o(^DHCPHCP(0,"Adm",EpisodeID,cliPhaID)) q:cliPhaID=""  d
	.s cliPhaUser=$p(^DHCPHCP(cliPhaID),"^",18)    //记录人
	.s:cliPhaUser'="" cliPhaUser=$p(^SSU("SSUSR",cliPhaUser),"^",2)
	.s recordDate=$p(^DHCPHCP(cliPhaID),"^",19)    //记录日期
	.s:recordDate'="" recordDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(recordDate) //$zd(recordDate,3) ;
	.s recordTime=$p(^DHCPHCP(cliPhaID),"^",20)    //记录时间
	.s:recordTime'="" recordTime=$zt(recordTime,2)
	.s cliPhaUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",cliPhaUser)
	.s mdata="CP"_"^"_"CP-"_cliPhaID_"^"_recordDate_" "_recordTime_" "_cliPhaUser_"^"_"cpI"
	.s num=num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)=mdata
	.
	q num
}

/// Descript:药学监护
ClassMethod jsonPhaCare(pid As %String, num As %String, EpisodeID As %String) As %String
{
	n (pid, num, EpisodeID,%session)
	s num=num+1
	s Phmon=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("药学监护")
	s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="MON^mon^"_Phmon_"^"
	k monLevelArr
	s monID=""
	f  s monID=$o(^DHCPHPC(0,"ADM",EpisodeID,monID)) q:monID=""  d
	.s monLevID=$p(^DHCPHPC(monID),"^",1)
	.s monLevel="mon"_$p(^DHCPHML(monLevID),"^",1)
	.s monDesc=$p(^DHCPHML(monLevID),"^",2)
	.s monLevelDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMonLevel","PHMLDesc","",monDesc)_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("监护")
	.i '$d(monLevelArr("MON^"_monLevel_"^"_monLevelDesc_"^mon")) d
	..s num=num+1
	..s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="MON^"_monLevel_"^"_monLevelDesc_"^mon"
	..s monLevelArr("MON^"_monLevel_"^"_monLevelDesc_"^mon")=""
	.s monUser=""
	.s monUserID=$p(^DHCPHPC(monID),"^",5)  //监护人
	.s:monUserID'="" monUser=$p(^SSU("SSUSR",monUserID),"^",2)
	.s:monUser["/" monUser=$p(monUser,"/",2)
	.s monDate=$p(^DHCPHPC(monID),"^",6)  //监护日期
	.s:monDate'="" monDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(monDate)  //$zd(monDate,1)
	.s monTime=$p(^DHCPHPC(monID),"^",7)  //监护时间
	.s:monTime'="" monTime=$zt(monTime,2)
	.s monUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",monUser)
	.s ListData="MON"_"^"_"MON-"_monID_"^"_monDate_" "_monTime_" "_monUser_"^"_monLevel
	.s num=num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)=ListData
	.
	k monLevelArr
	q num
}

/// Descript:用药教育
/// W ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonMedEducation("2","1","16243032")
ClassMethod jsonMedEducation(pid As %String, num As %String, EpisodeID As %String) As %String
{
	n (pid, num, EpisodeID,%session)
	s num=num+1
	s Mededu=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("用药教育")
	s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="ED^ed^"_Mededu_"^"
	
	/// 新入院记录
	s medEduID=$o(^DHCPHME(0,"CurStatus","N",EpisodeID,""),-1)
	i medEduID'="" d
	.s num=num+1
	.s MededuNew=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("新入院记录")
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="ED^"_"ED-"_medEduID_"^"_MededuNew_"^ed"
	
	s num=num+1
	s MededuIn=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("住院期间")
	s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="ED^IN^"_MededuIn_"^ed"
	
	/// 出院记录
	s medEduID=$o(^DHCPHME(0,"CurStatus","O",EpisodeID,""),-1)
	i medEduID'="" d
	.s num=num+1
	.s MededuOut=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("出院教育")
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)="ED^"_"ED-"_medEduID_"^"_MededuOut_"^ed"
	
	s medEduID=""
	f  s medEduID=$o(^DHCPHME(0,"CurStatus","I",EpisodeID,medEduID)) q:medEduID=""  d
	.q:medEduID=""
	.s medUser=""
	.s medUserID=$p(^DHCPHME(medEduID),"^",3)    //记录人
	.s:medUserID'="" medUser=$p(^SSU("SSUSR",medUserID),"^",2)
	.s medDate=$p(^DHCPHME(medEduID),"^",4)      //记录日期
	.s:medDate'="" medDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(medDate) //$zd(medDate,3)
	.s medTime=$p(^DHCPHME(medEduID),"^",5)      //记录时间
	.s:medTime'="" medTime=$zt(medTime,2)
	.s medUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",medUser)
	.s ListData="ED"_"^"_"ED-"_medEduID_"^"_medDate_" "_medTime_" "_medUser_"^"_"IN"
	.s num=num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,num)=ListData
	.

	q num
}

/// Descript:加载个人药学服务明细
/// w ##class(web.DHCSTPHCMPERPHARSERVICE).jsonLoadPerPharSerDet("MON","44")
ClassMethod jsonLoadPerPharSerDet(bsType As %String, bsPoint As %String) As %String
{
	n (bsType, bsPoint ,%session)
	i bsType = "WR" d
	.d ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonWardRoundDet(bsPoint)
	
	i bsType = "MA" d
	.d ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonMedAdviceDet(bsPoint)
	
	i bsType = "CP" d
	.d ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonCliPathographyDet(bsPoint)
	
	i bsType = "MON" d
	.d ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonPhaCareDet(bsPoint)
	
	i bsType = "ED" d
	.d ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonMedEducationDet(bsPoint)
	q ""
}

/// Descript:药学查房
/// w ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonWardRoundDet(7)
ClassMethod jsonWardRoundDet(wardRoundID As %String) As %String
{
	n (wardRoundID,%session)
	i '$d(^DHCPHWR(wardRoundID))  w "[]"
	q:'$d(^DHCPHWR(wardRoundID)) "" 
	w "["
	s EpisodeID=$p(^DHCPHWR(wardRoundID),"^",1)  //就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  // 姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  // 登记号
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)	 // 性别Id   sufan  2016/12/28  增加取病人性别、籍贯、民族、体重、身高、电话、工作单位、诊断的 基本信息
    s SexDesc=$p(^CT("SEX",SexId),"^",2)		 // 性别描述
    s patAge=##class(PHA.FACE.IN.Com).GetAge(PatientID,EpisodeID)  //年龄
    s patCityDr=$p(^PAPER(PatientID,"ALL"),"^",18)  //籍贯
    s nationdr=$p(^PAPER(PatientID,"PER",2),"^",1)  //民族  
	s nation=""
	i nationdr'="" s nation=$p(^CT("NAT",nationdr),"^",2)
    s patWeight=##class(PHA.COM.Order).PatWeight(EpisodeID)  //体重
	s patHeight=##class(PHA.COM.Order).PatHeight(EpisodeID)   //身高
	s patTel=$p(^PAPER(PatientID,"PER",1),"^",11) 	       /// 电话 
	s workunit=$p($g(^PAPER(PatientID,"PER",4)),"^",18)    /// 工作单位
	s patBloodType=$p(^DHCPHWR(wardRoundID),"^",4)         /// 病人血型
    s CurrStatus=$p(^DHCPHWR(wardRoundID),"^",6)           /// 病人状态
	s wruser=""  
	s userID=$p(^DHCPHWR(wardRoundID),"^",8)    //记录人
	s:userID'="" wruser=$p(^SSU("SSUSR",userID),"^",2)
	s userName=$p(^SSU("SSUSR",userID),"^",2)   //姓名
	s wrDate=$p(^DHCPHWR(wardRoundID),"^",9)    //日期
	s:wrDate'="" wrDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(wrDate) ;$zd(wrDate,3)
	s wrTime=$p(^DHCPHWR(wardRoundID),"^",10)     //时间
	s:wrTime'="" wrTime=$zt(wrTime,2)
	s wrGuidance=$p(^DHCPHWR(wardRoundID),"^",7)  //指导意见
	s WRICDesc=$p(^DHCPHWR(wardRoundID),"^",5)    //诊断
	s wruser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",wruser)
	s patName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",patName)
	s SexDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",SexDesc)
    s nation=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTNation","CTNATDesc","",nation)   
	s workunit=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPERSecondPhone","",workunit)
	s WrListData=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("药学查房")_"^"_wrDate_"^"_wrTime_"^"_wruser_"^"_patNo_"^"_patName   //sufan 修改ListData为WrListData
	w ##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bsdate^bstime^bsuser^patno^patname",WrListData)
	
	/*
	s ListData=""
	i CurrStatus="N" D
	.s ListData="患者姓名："_patName_"、性别："_SexDesc_"、年龄："_patAge_"、籍贯："_patCityDr_"、血型："_patBloodType_"、民族："_nation_"、身高："_patHeight_"、联系电话："_patTel_"、体重："_patWeight_"、工作单位："_workunit_"、诊断："_WRICDesc
	.s ListData=ListData_"诊断"_WRICDesc
	
	s wrHisPreComList=##Class(web.DHCSTPHCMWARDROUND).getWRHisPreCom(wardRoundID)    //现病史
	i wrHisPreComList'="" d
	.s ListData=ListData_"；"_"现病史："_wrHisPreComList
	
	s wrPasDisHisList=##Class(web.DHCSTPHCMWARDROUND).getWRPasDisHis(wardRoundID)    //既往病史
	i wrPasDisHisList'="" d
	.i ListData="" s ListData="既往病史："_$REPLACE(wrPasDisHisList,"||",",")
	.e  s ListData=ListData_"；"_"既往病史："_$REPLACE(wrPasDisHisList,"||",",")
	
	s wrPasMedHisList=##Class(web.DHCSTPHCMWARDROUND).getWRPasMedHis(wardRoundID)    //既往用药史
	i wrPasMedHisList'="" d
	.i ListData="" s ListData="既往用药史："_$REPLACE(wrPasMedHisList,"||",",")
	.e  s ListData=ListData_"；"_"既往用药史："_$REPLACE(wrPasMedHisList,"||",",")
	
	s wrPerFamHisList=##Class(web.DHCSTPHCMWARDROUND).getWRPerFamHis(wardRoundID)    //个人史及家族史
	i wrPerFamHisList'="" d
	.i ListData="" s ListData="个人史及家族史："_$REPLACE(wrPerFamHisList,"||",",")
	.e  s ListData=ListData_"；"_"个人史及家族史："_$REPLACE(wrPerFamHisList,"||",",")
	
	s wrConDisTreList=##Class(web.DHCSTPHCMWARDROUND).getWRConDisTre(wardRoundID)    //伴发疾病与用药情况
	i wrConDisTreList'="" d
	.i ListData="" s ListData="伴发疾病与用药情况："_$REPLACE(wrConDisTreList,"||",",")
	.e  s ListData=ListData_"；"_"伴发疾病与用药情况："_$REPLACE(wrConDisTreList,"||",",")
	
	s wrAllergHisList=##Class(web.DHCSTPHCMWARDROUND).getWRAlleicHis(wardRoundID)    //过敏史
	i wrAllergHisList'="" d
	.i ListData="" s ListData="过敏史："_$REPLACE(wrAllergHisList,"||",",")
	.e  s ListData=ListData_"；"_"过敏史："_$REPLACE(wrAllergHisList,"||",",")
	
	i ListData'="" s ListData=ListData_"；"
	s ListData=ListData_"指导意见："_##Class(web.DHCSTPHCMPERPHARSERVICE).getWRGuidance(wardRoundID)
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","基本信息"_"^"_ListData)
	*/ //qunianpeng 2017/11/22 因界面排版修改
	s spStyle="<span style=margin-right:15px>"
	s ListData=""
	s WRICDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHWardRound","PHWRICDesc","",WRICDesc)
	i CurrStatus="N" D
	.s ListData="<p>"_spStyle_"&nbsp;&nbsp;"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("患者姓名")_":【"_patName_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("性别")_"：【"_SexDesc_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("年龄")_"：【"_patAge_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("籍贯")_"：【"_patCityDr_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("血型")_"：【"_patBloodType_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("民族")_"：【"_nation_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("身高")_"：【"_patHeight_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("联系电话")_"：【"_patTel_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("体重")_"：【"_patWeight_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("工作单位")_"：【"_workunit_"】</span></p>"
	.s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("入院诊断")_"】&nbsp;&nbsp;"_WRICDesc_"</p>"
	
	s wrHisPreComList=##Class(web.DHCSTPHCMWARDROUND).getWRHisPreCom(wardRoundID)    //现病史
	i wrHisPreComList'="" d
	.s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("现病史")_"】&nbsp;&nbsp;"_wrHisPreComList_"</p>"

	s wrPasDisHisList=##Class(web.DHCSTPHCMWARDROUND).getWRPasDisHis(wardRoundID)    //既往病史
	i wrPasDisHisList'="" d
	.i ListData="" s ListData="<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("既往病史")_"】&nbsp;&nbsp;"_$REPLACE(wrPasDisHisList,"||",",")_"</p>"
	.e  s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("既往病史")_"】&nbsp;&nbsp;"_$REPLACE(wrPasDisHisList,"||",",")_"</p>"

	s wrPasMedHisList=##Class(web.DHCSTPHCMWARDROUND).getWRPasMedHis(wardRoundID)    //既往用药史
	i wrPasMedHisList'="" d
	.i ListData="" s ListData="<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("既往用药史")_"】&nbsp;&nbsp;"_$REPLACE(wrPasMedHisList,"||",",")_"</p>"
	.e  s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("既往用药史")_"】&nbsp;&nbsp;"_$REPLACE(wrPasMedHisList,"||",",")_"</p>"
	
	s wrPerFamHisList=##Class(web.DHCSTPHCMWARDROUND).getWRPerFamHis(wardRoundID)    //个人史及家族史
	i wrPerFamHisList'="" d
	.i ListData="" s ListData="<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("个人史及家族史")_"】&nbsp;&nbsp;"_$REPLACE(wrPerFamHisList,"||",",")_"</p>"
	.e  s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("个人史及家族史")_"】&nbsp;&nbsp;"_$REPLACE(wrPerFamHisList,"||",",")_"</p>"
	
	s wrConDisTreList=##Class(web.DHCSTPHCMWARDROUND).getWRConDisTre(wardRoundID)    //伴发疾病与用药情况
	i wrConDisTreList'="" d
	.i ListData="" s ListData="<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("伴发疾病与用药情况")_"】&nbsp;&nbsp;"_$REPLACE(wrConDisTreList,"||",",")_"</p>"
	.e  s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("伴发疾病与用药情况")_"】&nbsp;&nbsp;"_$REPLACE(wrConDisTreList,"||",",")_"</p>"

	s wrAllergHisList=##Class(web.DHCSTPHCMWARDROUND).getWRAlleicHis(wardRoundID)    //过敏史
	i wrAllergHisList'="" d
	.i ListData="" s ListData="<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("过敏史")_"】&nbsp;&nbsp;"_$REPLACE(wrAllergHisList,"||",",")_"</p>"
	.e  s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("过敏史")_"】&nbsp;&nbsp;"_$REPLACE(wrAllergHisList,"||",",")_"</p>"
	
	s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("指导意见")_"】"_##Class(web.DHCSTPHCMPERPHARSERVICE).getWRGuidance(wardRoundID)_"</p>"
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("基本信息")_"^"_ListData)	
	
	
	s wrDrgItm=##Class(web.DHCSTPHCMPERPHARSERVICE).getWardRoundDrgItm(wardRoundID)
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("重点关注药物")_"^"_wrDrgItm)
	
	i CurrStatus="N" D
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("初始治疗方案")_"^"_wrGuidance)
	E  D
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("治疗方案")_"^"_wrGuidance)
	w "]"
	q ""
}

// W ##Class(web.DHCSTPHCMPERPHARSERVICE).getWRGuidance("111")

/// Descript:临床查房指导意见
ClassMethod getWRGuidance(wardRoundID As %String) As %String
{
	N (wardRoundID)
	S CH="",ListData=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"G",CH)) Q:CH=""  D
	.S wrgCode=$p(^DHCPHWR(wardRoundID,"G",CH),"^",1)
	.//S wrgDesc=$p(^DHCPHWR(wardRoundID,"G",CH),"^",2)
	.Q:wrgCode=""
	.i $d(^DHCPHGS(wrgCode))  d
	..s type=$p(^DHCPHGS(wrgCode),"^",4)     //病人类型
	..;q:type="N"  
	..S wrgDesc=$p(^DHCPHGS(wrgCode),"^",2)  //内容描述
	..i ListData="" s ListData="&nbsp;&nbsp;"_wrgDesc
	..e  s ListData=ListData_"<br>"_"&nbsp;&nbsp;"_wrgDesc	//qunianpeng 2017/11/22 因界面排版修改
	.
	q ListData
}

/// Descript:初始治疗计划及治疗药物
/// w ##Class(web.DHCSTPHCMPERPHARSERVICE).getWrCureplane(79) 
ClassMethod getWrCureplane(wardRoundID As %String) As %String
{
	N (wardRoundID,curStatus)
	S CH="",ListData=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"G",CH)) Q:CH=""  D
	.S wrgCode=$p(^DHCPHWR(wardRoundID,"G",CH),"^",1)
	.S wrgDesc=$p(^DHCPHWR(wardRoundID,"G",CH),"^",2)
	.Q:wrgCode=""
	.i wrgCode="1" S wrgDesc="初始治疗计划及治疗药物:"_wrgDesc
	.i wrgCode="1.1" S wrgDesc="1、关心患者心理和经济状况，提出适宜指导"_wrgDesc
	.i wrgCode="1.2" S wrgDesc="2、注重了解患者用药方面隐患的忧虑，提出适宜指导"_wrgDesc
	.i wrgCode="1.3" S wrgDesc="3、评估患者的饮食、药物对现治疗药物的影响，提出适宜指导"_wrgDesc
	.i wrgCode="1.4" S wrgDesc="4、初始治疗药物方案"_wrgDesc
	.i wrgCode="1.5" S wrgDesc="5、初始药物治疗提出适宜用药指导，如服药疗程、时间、方法、可能出现的不良反应以及预防措施、其它注意事项"_wrgDesc
	.i wrgCode="1.6" S wrgDesc="6、药物重整"_wrgDesc
	.i wrgCode="1.7" S wrgDesc="7、其它"_wrgDesc
	.i ListData="" s ListData=wrgDesc
	.e  s ListData=ListData_"<br>"_wrgDesc
	.
	q ListData
}

/// Descript:关注药品
/// w ##class((web.DHCSTPHCMPERPHARSERVICE).getWardRoundDrgItm("12")
ClassMethod getWardRoundDrgItm(wardRoundID As %String) As %String
{
	n (wardRoundID)
	s Num=0
	s CH="",ListData=""  
	f  s CH=$o(^DHCPHWR(wardRoundID,"DI",CH)) q:CH=""  d
	.s orditm=$p(^DHCPHWR(wardRoundID,"DI",CH),"^",1)  //医嘱ID
	.s ord=+orditm
	.s chl=$p(orditm,"||",2)
	.s ArcItmId=$p($g(^OEORD(ord,"I",chl,1)),"^",2)     //医嘱 ARC_ItmMast ARCIM_RowId
	.s inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.q:inci=""  //医嘱名称
	.;s inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.S inciDesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2) //lbb 2019/1/7 取医嘱项名称，因为医嘱项和库存项存在一对多关系 
	.;s dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) //剂量
	.;s dosage=$fn(dosage,".",0)
	.s dosage=##class(PHA.FACE.IN.Com).GetOrdDoseQty(orditm)  //剂量
	.s dosuomID=+$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	.s doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)    //剂量单位
	.;s freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4)  //OEORI_PHFreq_DR
    .;s freq=$p($g(^PHCFR(freqdr)),"^",3)            //频率
    .s freqInfo=##class(PHA.COM.Order).OeoriFreq(orditm)   //取频次调用统一接口
	.s freqdr=$p(freqInfo,"^",1)  
    .s freq=$p(freqInfo,"^",2)
    .s instrudr=+$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    .s instru=$p($g(^PHCIN(instrudr)),"^",2)        //用法
    .;s durId=+$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.;s duration=$p($g(^PHCDU(durId)),"^",1)         //用药疗程
	.s duration=""
    .s durId=$p(^OEORD(ord,"I",chl,2),"^",6)
	.s:durId'="" duration=$p($g(^PHCDU(durId)),"^",1)         ///用药疗程
	.s phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
    .s genenicdr=$p($g(^PHCD(+phcdf,4)),"^",1)
    .s genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) //通用名
    .s formdr=$p($g(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1)),"^",1)
    .s form=$p($g(^PHCF(formdr)),"^",2) //剂型
    .s manf=""
    .s manfdr=$p($g(^PHCD(+phcdf,2)),"^",4) //厂家
    .s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.//i ListData="" s ListData="("_CH_")"_inciDesc_"  "_genenic_"  "_manf
	.//e  s ListData=ListData_"、"_"("_CH_")"_inciDesc_"  "_genenic_"  "_manf
	.i ListData="" s ListData="<p>"_"("_CH_")"_inciDesc_"  "_dosage_doseuom_"  "_instru_" "_freq_" "_duration_"</p>" //qunianpeng 2017/11/22 因为界面排版修改
	.e  s ListData=ListData_"<p>"_"("_CH_")"_inciDesc_"  "_dosage_doseuom_"  "_instru_"  "_freq_"  "_duration_"</p>"
	.
	q ListData
}

/// Descript:用药建议明细
/// w ##class(web.DHCSTPHCMPERPHARSERVICE).jsonMedAdviceDet(59)
ClassMethod jsonMedAdviceDet(medAdvID As %String) As %String
{
	n (medAdvID,%session)

	i '$d(^DHCPHAD(medAdvID))  w "[]"
	q:'$d(^DHCPHAD(medAdvID)) ""
	w "["
	;s EpisodeID=$p(^DHCPHAD(medAdvID),"^",2)     //就诊ID
	s EpisodeID=$p(^DHCPHAD(medAdvID),"^",1)     //就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	s medAdvUser=$p(^DHCPHAD(medAdvID),"^",2)    //建议人
	s:medAdvUser'="" medAdvUser=$p(^SSU("SSUSR",medAdvUser),"^",2)
	s medAdvDate=$p(^DHCPHAD(medAdvID),"^",4)     //记录日期
	s:medAdvDate'="" medAdvDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(medAdvDate) ;$zd(medAdvDate,3)
	s medAdvTime=$p(^DHCPHAD(medAdvID),"^",5)     //记录时间
	s:medAdvTime'="" medAdvTime=$zt(medAdvTime,2)
	
	s medAdvUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",medAdvUser)
	s patName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",patName)	
	S medAdvMasDataList=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("用药建议")_"^"_medAdvDate_"^"_medAdvTime_"^"_medAdvUser_"^"_patNo_"^"_patName
	w ##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bsdate^bstime^bsuser^patno^patname",medAdvMasDataList)
	
	s medAdvDrgItmList=##Class(web.DHCSTPHCMADVICE).getPHMedAdvDrgItm(medAdvID)   //医嘱信息
	//w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","医嘱信息"_"^"_$REPLACE(medAdvDrgItmList,"||","、"))
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("医嘱信息")_"^"_$REPLACE(medAdvDrgItmList,"||","<br>")) //qunianpeng 2017/11/22 因界面排版修改
		
	s medAdvContentList=##Class(web.DHCSTPHCMADVICE).getPHMedAdvDetail(medAdvID)  //建议信息
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("建议内容")_"^"_$REPLACE(medAdvContentList,"||","<br>"))

	w "]"
	Q ""
}

/// Descript:药学监护
ClassMethod jsonPhaCareDet(phaCareID As %String) As %String
{
	n (phaCareID,%session)
	i '$d(^DHCPHPC(phaCareID))  w "[]"    //liyarong 2016-10-19
	q:'$d(^DHCPHPC(phaCareID)) "" 
	w "["
	s monLevID=$p(^DHCPHPC(phaCareID),"^",1)
	s monLevel=$p(^DHCPHML(monLevID),"^",2)
	s EpisodeID=$p(^DHCPHPC(phaCareID),"^",2)        //就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	s monUser=""
	s monUserID=$p(^DHCPHPC(phaCareID),"^",5)  //监护人
	s:monUserID'="" monUser=$p(^SSU("SSUSR",monUserID),"^",2)
	s monDate=$p(^DHCPHPC(phaCareID),"^",6)  //监护日期
	s:monDate'="" monDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(monDate)  ;$zd(monDate,3)
	s monTime=$p(^DHCPHPC(phaCareID),"^",7)  //监护时间
	s:monTime'="" monTime=$zt(monTime,2)
	s monContent=$p(^DHCPHPC(phaCareID),"^",8)   //监护内容
	s ImpMonItems=$p(^DHCPHPC(phaCareID),"^",9)   //重要检验检测项目
	s monLevel=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMonLevel","PHMLDesc","",monLevel)
	s monLevel=monLevel_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("监护")
	s monUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",monUser)
	s patName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",patName)
	s monContent=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHPharCare","PHPCContent","",monContent)
	s ImpMonItems=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHPharCare","PHPCImpMonItems","",ImpMonItems)
	s ListData=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("药学监护")_"^"_monDate_"^"_monTime_"^"_monUser_"^"_patNo_"^"_patName
	w ##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bsdate^bstime^bsuser^patno^patname",ListData)

	s phaCareMonScopeList=##Class(web.DHCSTPHCMPERPHARSERVICE).getphaCareMonScope(phaCareID)
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("纳入标准")_"^"_phaCareMonScopeList)
		
	s phaCareMonItemList=##Class(web.DHCSTPHCMPERPHARSERVICE).getphaCareMonItem(phaCareID)
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("生命体征")_"^"_phaCareMonItemList)
	
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("检验检查")_"^"_ImpMonItems)

	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("病情转归情况")_"^"_monContent)
	w "]"
	Q ""
}

/// Descript:监护范围
ClassMethod getphaCareMonScope(phaCareID As %String) As %String
{
	n (phaCareID,%session)
	s CH="",ListData=""
	f  s CH=$o(^DHCPHPC(phaCareID,"MS",CH)) q:CH=""  d
	.s monScopeID=$p(^DHCPHPC(phaCareID,"MS",CH),"^",1)
	.q:monScopeID=0								    /// qunianpeng 2018/3/22
 	.s monScopeCode=$p(^DHCPHMS(monScopeID),"^",1)	/// 代码
    .s monScopeDesc=$p(^DHCPHMS(monScopeID),"^",2) 	/// 描述
    .s monScopeDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMonScope","PHMSDesc","",monScopeDesc)
	.i ListData="" s ListData=monScopeDesc
	.e  s ListData=ListData_"、"_monScopeDesc
	q ListData
}

/// Descript:监护项目
ClassMethod getphaCareMonItem(phaCareID As %String) As %String
{
	n (phaCareID,curStatus,%session)
	s CH="",ListData=""
	f  s CH=$o(^DHCPHPC(phaCareID,"MI",CH)) Q:CH=""  D
	.s monItmID=$p(^DHCPHPC(phaCareID,"MI",CH),"^",1)
	.s monItmVal=$p(^DHCPHPC(phaCareID,"MI",CH),"^",2)
	.q:(monItmID=0)||(monItmVal="")				/// qunianpeng 2018/3/22 
	.s monItmCode=$p(^DHCPHMI(monItmID),"^",1) 	/// 代码
    .s monItmDesc=$p(^DHCPHMI(monItmID),"^",2) 	/// 描述
    .s monItmDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMonItem","PHMIDesc","",monItmDesc)
    .s monItmVal=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMonItem","PHMIDesc","",monItmVal)
	.i ListData="" s ListData=$REPLACE(monItmDesc,"[]",monItmVal)
	.e  s ListData=ListData_"、"_$REPLACE(monItmDesc,"[]",monItmVal)
	q ListData
}

/// Descript:用药教育
ClassMethod jsonMedEducationDet(medEduID As %String) As %String
{
	n (medEduID,%session)
	i '$d(^DHCPHME(medEduID))  w "[]"    //liyarong 2016-10-19
	q:'$d(^DHCPHME(medEduID)) "" 
	w "["
	s EpisodeID=$p(^DHCPHME(medEduID),"^",1)     //就诊ID
	S curStatus=$p(^DHCPHME(medEduID),"^",2)
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	
	s AdmWard=""
	s AdmWardDr=$p(^PAADM(EpisodeID),"^",70)
	i AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
	s bedid=$p(^PAADM(EpisodeID),"^",73)             //床号
	i bedid="" s AdmBed=""
    e  s AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	s MEBadHabits=$p(^DHCPHME(medEduID),"^",6)    //不良嗜好
	s MEConDisAndTre=$p(^DHCPHME(medEduID),"^",7) //伴发疾病与用药情况
	s MEGrantFlag=$p(^DHCPHME(medEduID),"^",8)    //发放临床药师联系卡
	i MEGrantFlag="Y"  s MEGrantFlag="是"
	i MEGrantFlag="N"  s MEGrantFlag="否"
	s MEGuidObject=$p(^DHCPHME(medEduID),"^",9)   //指导对象
	s otherObject=$p(^DHCPHME(medEduID),"^",24)
	s MEGuidContent=$p(^DHCPHME(medEduID),"^",10) //指导意见/内容
	s MEIcd=$p(^DHCPHME(medEduID),"^",11)  	      //诊断描述
	;i MEIcd="" s MEIcd=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")
	s mobPhone=$p(^DHCPHME(medEduID),"^",12)      //联系方式
	s Address=$p(^DHCPHME(medEduID),"^",13)       //家庭地址
	
	s medUser=""
	s medUserID=$p(^DHCPHME(medEduID),"^",3)    //记录人
	s:medUserID'="" medUser=$p(^SSU("SSUSR",medUserID),"^",2)
	s medDate=$p(^DHCPHME(medEduID),"^",4)      //记录日期
	s:medDate'="" medDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(medDate) ;$zd(medDate,3)
	s medTime=$p(^DHCPHME(medEduID),"^",5)      //记录时间
	s:medTime'="" medTime=$zt(medTime,2)
	
    s medUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",medUser)
    s patName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",patName)
    s AdmWard=##class(PHA.FACE.IN.Com).GetTransDesc("User.PACWard","WARDDesc","",AdmWard)
    s medUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",medUser)
    s MEBadHabits=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEBadHabits","",MEBadHabits)
    s MEConDisAndTre=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEConDisAndTre","",MEConDisAndTre)
    s MEGuidContent=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEGuidContent","",MEGuidContent)
    s MEIcd=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEIcd","",MEIcd)   
	s Address=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEAddress","",Address)
	s otherObject=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHMedEducation","PHMEOtherObject","",otherObject)

	s medEduList=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("用药教育")_"^"_medDate_"^"_medTime_"^"_medUser_"^"_patNo_"^"_patName
	w ##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bsdate^bstime^bsuser^patno^patname",medEduList)
	/*
	s ListData="病区："_AdmWard_"、姓名："_patName_"、床号："_AdmBed_"、登记号："_patNo_"、联系方式："_mobPhone_"、家庭地址："_Address_"、"  //nisijia  2016-10-18   sufan  2016/12/27  去掉_"、诊断:"_MEIcd  
	i (curStatus="N")&(MEIcd'="") s ListData=ListData_"入院诊断："_MEIcd_";"  //sufan  2016/12/27  将MEConDisAndTre换为MEIcd
	i (curStatus="I")&(MEIcd'="") s ListData=ListData_"诊断："_MEIcd_";"
	i (curStatus="O")&(MEIcd'="") s ListData=ListData_"出院诊断："_MEIcd_";"
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","基本信息"_"^"_ListData)
	
	s ListData=""
	i MEBadHabits'="" s ListData=ListData_"不良嗜好(烟、酒、药物依赖)："_MEBadHabits_";"
	i MEConDisAndTre'="" s ListData=ListData_"<br>伴发疾病与用药情况："_MEConDisAndTre_";"
	i MEGrantFlag'="" s ListData=ListData_"<br>发放临床药师联系卡："_MEGrantFlag_";"
	i MEGuidObject'="" s ListData=ListData_"指导对象："_$S(MEGuidObject="10":"患者本人",MEGuidObject="11":"患者家属",1:"其他")_";"
	i (curStatus'="O")&(MEGuidContent'="") s ListData=ListData_"<br>注意事项："_MEGuidContent_";"
	
	/// 指导内容
	s medEduGuiContent=##class(web.DHCSTPHCMPERPHARSERVICE).getMedEduGuiContent(medEduID,curStatus)
	i medEduGuiContent'="" s ListData=ListData_"指导内容:"_medEduGuiContent_";"    ///sufan  2016/12/27  将 MEGrantFlag 换为 medEduGuiContent
	
	i curStatus="N" d
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","入院记录"_"^"_ListData)
	
	s medEduDrgList=##Class(web.DHCSTPHCMPERPHARSERVICE).getMedEduDrgItm(medEduID)  //关注药品
	i medEduDrgList'="" d
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","关注药品"_"^"_medEduDrgList)

	i curStatus="I" d
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","指导内容"_"^"_ListData)
	
	i curStatus="O" d
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","治疗方案"_"^"_MEGuidContent)
	*/
	 //qunianpeng 2017/11/22 因界面排版修改
	s spStyle="<span style=margin-right:15px>"
		s ListData="<p>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("病区")_":【"_AdmWard_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("姓名")_"：【"_patName_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("床号")_"：【"_AdmBed_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("登记号")_"：【"_patNo_"】</span>"  //nisijia  2016-10-18   sufan  2016/12/27  去掉_"、诊断:"_MEIcd  
	i (curStatus="N")&(MEIcd'="") s ListData=ListData_"<span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("联系方式")_"：【"_mobPhone_"】</span><span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("家庭地址")_"：【"_Address_"】</span></p>"  
	i (curStatus="N")&(MEIcd'="") s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("入院诊断")_"】&nbsp;&nbsp;"_MEIcd_";</p>"  //sufan  2016/12/27  将MEConDisAndTre换为MEIcd
	i (curStatus="I")&(MEIcd'="") s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("诊断")_"】&nbsp;&nbsp;"_MEIcd_";</p>"
	i (curStatus="O")&(MEIcd'="") s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("出院诊断")_"】&nbsp;&nbsp;"_MEIcd_";</p>"
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("基本信息")_"^"_ListData)
	
	s ListData=""
	i MEBadHabits'="" s ListData=ListData_"【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("不良嗜好(烟、酒、药物依赖)")_"】&nbsp;&nbsp;"_MEBadHabits_";<br>"
	i MEConDisAndTre'="" s ListData=ListData_"【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("伴发疾病与用药情况")_"】&nbsp;&nbsp;"_MEConDisAndTre_";<br>"
	i MEGrantFlag'="" s ListData=ListData_"【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("发放临床药师联系卡")_"】&nbsp;&nbsp;"_MEGrantFlag_";<br>"
	i MEGuidObject'="" s ListData=ListData_"【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("指导对象")_"】&nbsp;&nbsp;"_$S(MEGuidObject="10":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("患者本人"),MEGuidObject="11":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("患者家属"),1:##class(PHA.CPW.Com.OutInterfance).GetTransDesc("其他")_"&nbsp;")_otherObject_";<br>"
	i (curStatus'="O")&(MEGuidContent'="") s ListData=ListData_"【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("注意事项")_"】&nbsp;&nbsp;"_MEGuidContent_";<br>"
	
	/// 指导内容
	s medEduGuiContent=##class(web.DHCSTPHCMPERPHARSERVICE).getMedEduGuiContent(medEduID,curStatus)
	i medEduGuiContent'="" s ListData=ListData_"【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("指导内容")_"】&nbsp;&nbsp;"_medEduGuiContent_";<br>"    ///sufan  2016/12/27  将 MEGrantFlag 换为 medEduGuiContent
	
	i curStatus="N" d
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("入院记录")_"^"_ListData)
	
	s medEduDrgList=##Class(web.DHCSTPHCMPERPHARSERVICE).getMedEduDrgItm(medEduID)  //关注药品
	i medEduDrgList'="" d
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("关注药品")_"^"_medEduDrgList)

	i curStatus="I" d
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("指导内容")_"^"_ListData)
	
	i curStatus="O" d
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("治疗方案")_"^"_MEGuidContent)
	w "]"
}

/// Descript:关注药品
/// w ##class(web.DHCSTPHCMPERPHARSERVICE).getMedEduDrgItm("8")
ClassMethod getMedEduDrgItm(medEduID As %String) As %String
{
	N (medEduID,%session)
	S Num=0
	S CH="",ListData=""
	F  S CH=$o(^DHCPHME(medEduID,"DI",CH)) Q:CH=""  D
	.S orditm=$p(^DHCPHME(medEduID,"DI",CH),"^",1)  //医嘱ID
	.S guiCon=$p(^DHCPHME(medEduID,"DI",CH),"^",2)  //指导意见
	.S ord=+orditm
	.S chl=$p(orditm,"||",2)
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)     //医嘱 ARC_ItmMast ARCIM_RowId
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .Q:(ordertype'="R")
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""  //医嘱名称
	.;S inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.S inciDesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2) //lbb 2019/1/7 取医嘱项名称，因为医嘱项和库存项存在一对多关系 
	.;S dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) //剂量
	.s dosage=##class(PHA.FACE.IN.Com).GetOrdDoseQty(orditm)  //剂量
	.S dosuomID=+$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	.S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)   //剂量单位
	.s freqInfo=##class(PHA.COM.Order).OeoriFreq(orditm)   //取频次调用统一接口
	.s freqdr=$p(freqInfo,"^",1)  
    .s freq=$p(freqInfo,"^",2)
    .s instrudr=+$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    .s instru=$p($g(^PHCIN(instrudr)),"^",2)        //用法
    .;s durId=+$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.;s duration=$p($g(^PHCDU(durId)),"^",1)         //用药疗程
	.s duration=""
    .s durId=$p(^OEORD(ord,"I",chl,2),"^",6)
	.s:durId'="" duration=$p($g(^PHCDU(durId)),"^",1)         ///用药疗程
	.S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
    .s genenicdr=$p($g(^PHCD(+phcdf,4)),"^",1)
    .s genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) //通用名
    .s formdr=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1),"^",1)
    .s form=$p($g(^PHCF(formdr)),"^",2) //剂型
    .s manf=""
    .s manfdr=$p($g(^PHCD(+phcdf,2)),"^",4) //厂家
    .s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.S doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm) //医生
	.//i ListData="" s ListData="("_CH_")、"_inciDesc_" "_genenic_" "_manf
	.//e  s ListData=ListData_"；"_"("_CH_")、"_inciDesc_" "_genenic_" "_manf
	.s inciDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.ARCItmMast","ARCIMDesc","",inciDesc)
	.s freq=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCFreq","PHCFRDesc1","",freq)
	.s instru=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCInstruc","PHCINDesc1","",instru)
	.s duration=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCDuration","PHCDUCode","",duration)
	.i ListData="" s ListData="("_CH_")、"_inciDesc_" "_dosage_doseuom_"  "_instru_"  "_freq_"  "_duration_"<br>"  //qunianpeng 2017/11/22 因界面排版修改
	.e  s ListData=ListData_"("_CH_")、"_inciDesc_" "_dosage_doseuom_"  "_instru_"  "_freq_"  "_duration_"<br>"
	q ListData
}

/// Descript:指导意见
/// w ##class(web.DHCSTPHCMPERPHARSERVICE).getMedEduGuiContent("2")
ClassMethod getMedEduGuiContent(medEduID As %String, medEduCurStatus As %String) As %String
{
	N (medEduID,medEduCurStatus)
	S CH="",ListData=""
	F  S CH=$o(^DHCPHME(medEduID,"GC",CH)) Q:CH=""  D
	.S medEduGCCode=+$p(^DHCPHME(medEduID,"GC",CH),"^",1)  //内容代码
	.//S medEduGCDesc=$p(^DHCPHME(medEduID,"GC",CH),"^",2)  //内容描述
	.Q:medEduGCCode=0
	.S medEduGCDesc=$p(^DHCPHGS(medEduGCCode),"^",2)  //内容描述
	.i ListData="" s ListData=medEduGCDesc
	.e  s ListData=ListData_"、"_medEduGCDesc
	q ListData
}

/// Descript:医学查房
/// z
ClassMethod jsonCliPathographyDet(cliPhaID As %String) As %String
{
	n (cliPhaID,%session)
	i '$d(^DHCPHCP(cliPhaID))  w "[]"    //liyarong 2016-10-19
	q:'$d(^DHCPHCP(cliPhaID)) "" 
	w "["
	s EpisodeID=$p(^DHCPHCP(cliPhaID),"^",1)     //就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	
	s Temperature=$p(^DHCPHCP(cliPhaID),"^",2)    //体温
	s Pulse=$p(^DHCPHCP(cliPhaID),"^",3)          //脉搏
	s Breath=$p(^DHCPHCP(cliPhaID),"^",4)         //呼吸
	s Heartrate=$p(^DHCPHCP(cliPhaID),"^",5)    //心率
	s Bloodpre=$p(^DHCPHCP(cliPhaID),"^",6)     //血压
	s Urineamt=$p(^DHCPHCP(cliPhaID),"^",7)     //尿量
	s DouLunBrePho=$p(^DHCPHCP(cliPhaID),"^",8) //双肺呼吸音
	s Rale=$p(^DHCPHCP(cliPhaID),"^",9)         //啰音
	s Arrhythmia=$p(^DHCPHCP(cliPhaID),"^",10)  //心律
	s PathMurmur=$p(^DHCPHCP(cliPhaID),"^",11)  //各瓣膜听诊区、病理性杂音
	s Belly=$p(^DHCPHCP(cliPhaID),"^",12)       //腹部
	s LivLieCos=$p(^DHCPHCP(cliPhaID),"^",13)   //肝脾肋下
	s PerPain=$p(^DHCPHCP(cliPhaID),"^",14)     //双肾区叩击痛
	s Oedema=$p(^DHCPHCP(cliPhaID),"^",15)      //双下肢水肿
	s ChaOfDisDesc=$p(^DHCPHCP(cliPhaID),"^",16) //主要病情变化
	s Guidance=$p(^DHCPHCP(cliPhaID),"^",17)    //指导内容
	s Icd=$p(^DHCPHCP(cliPhaID),"^",21)         //具体诊断描述
	s PhcpcDesc=..GetPatPhcp(cliPhaID) 			//获取病人主诉  sufan 2017/01/03 增加获取主诉的方法"GetPatPhcp"
	s cliPhaUser=$p(^DHCPHCP(cliPhaID),"^",18)    //记录人
	s:cliPhaUser'="" cliPhaUser=$p(^SSU("SSUSR",cliPhaUser),"^",2)
	s recordDate=$p(^DHCPHCP(cliPhaID),"^",19)    //记录日期
	s:recordDate'="" recordDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(recordDate) ;$zd(recordDate,3)
	s recordTime=$p(^DHCPHCP(cliPhaID),"^",20)    //记录时间
	s:recordTime'="" recordTime=$zt(recordTime,2)

	s cliPhaUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",cliPhaUser)
	s patName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",patName)
	s ChaOfDisDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHCliPathography","PHCPChaOfDisDesc","",ChaOfDisDesc)
	s Guidance=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHCliPathography","PHCPGuidance","",Guidance)
	s Icd=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHCliPathography","PHCPIcd","",Icd)
	s ListData=##class(PHA.CPW.Com.OutInterfance).GetTransDesc("医学查房")_"^"_recordDate_"^"_recordTime_"^"_cliPhaUser_"^"_patNo_"^"_patName
	w ##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bsdate^bstime^bsuser^patno^patname",ListData)

	i Guidance'="" s Guidance="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"_Guidance
	/*
	s ListData="体温:"_Temperature_" ℃、脉搏:"_Pulse_"次/分、呼吸:"_Breath_"次/分、心率:"_Heartrate_"次/分、血压:"_Bloodpre_"mmHg、尿量:"_Urineamt_"ML"
	;s ListData=ListData_",主诉:"_PhcpcDesc   //sufan 2017/01/03 主诉    wangxuejian 2017/03/21
	i DouLunBrePho'="" s ListData=ListData_",主诉:"_PhcpcDesc_",双肺呼吸音:"_$S(DouLunBrePho="10":"清",DouLunBrePho="11":"粗",1:"")
	i Rale'="" s ListData=ListData_"、啰音:"_$S(Rale="10":"闻及",Rale="11":"未闻及",Rale="12":"干",Rale="13":"湿",1:"")
	i Arrhythmia'="" s ListData=ListData_"、心律:"_$S(Arrhythmia="10":"齐",Arrhythmia="11":"不齐",1:"")
	i PathMurmur'="" s ListData=ListData_"、各瓣膜听诊区、病理性杂音:"_$S(PathMurmur="10":"闻及",PathMurmur="11":"未闻及",1:"")
	i Belly'="" s ListData=ListData_"、腹部:"_$S(Belly="10":"平软",Belly="11":"膨隆",1:"")
	i LivLieCos'="" s ListData=ListData_"、肝脾肋下:"_$S(LivLieCos="10":"触及",LivLieCos="11":"未触及",1:"")
	i PerPain'="" s ListData=ListData_"、双肾区叩击痛:"_$S(PerPain="10":"有",LivLieCos="11":"无",1:"")
	i Oedema'="" s ListData=ListData_"、双下肢水肿:"_$S(Oedema="10":"无",LivLieCos="11":"轻",LivLieCos="12":"中",LivLieCos="13":"重度水肿",1:"")
	i Icd'="" s ListData=ListData_"；<br>初始诊断:"_Icd
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","重要生命体征变化情况 "_"^"_ListData)

	i ChaOfDisDesc'="" d
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","主要病情变化情况"_"^"_ChaOfDisDesc)
	
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","治疗方案"_"^"_Guidance)
	*/
	//qunianpeng 2017/11/22 因界面排版修改
	s spStyle="<span style=margin-right:15px>"
	s ListData="<p>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("体温")_":【"_Temperature_"℃】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("脉搏")_":【"_Pulse_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("次/分")_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("呼吸")_":【"_Breath_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("次/分")_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("心率")_":【"_Heartrate_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("次/分")_"】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("血压")_":【"_Bloodpre_"mmHg】</span>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("尿量")_":【"_Urineamt_"ML】</span></p>"
	;s ListData=ListData_",主诉:"_PhcpcDesc   //sufan 2017/01/03 主诉    wangxuejian 2017/03/21
	i DouLunBrePho'="" s ListData=ListData_"<p>"_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("双肺呼吸音")_":【"_$S(DouLunBrePho="10":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("清"),DouLunBrePho="11":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("粗"),1:"")_"】</span>"
	i Rale'="" s ListData=ListData_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("啰音")_":【"_$S(Rale="10":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("闻及"),Rale="11":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("未闻及"),Rale="12":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("干"),Rale="13":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("湿"),1:"")_"】</span>"
	i Arrhythmia'="" s ListData=ListData_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("心律")_":【"_$S(Arrhythmia="10":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("齐"),Arrhythmia="11":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("不齐"),1:"")_"】</span>"
	i PathMurmur'="" s ListData=ListData_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("各瓣膜听诊区、病理性杂音")_":【"_$S(PathMurmur="10":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("闻及"),PathMurmur="11":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("未闻及"),1:"")_"】</span>"
	i Belly'="" s ListData=ListData_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("腹部")_":【"_$S(Belly="10":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("平软"),Belly="11":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("膨隆"),1:"")_"】</span>"
	i LivLieCos'="" s ListData=ListData_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("肝脾肋下")_":【"_$S(LivLieCos="10":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("触及"),LivLieCos="11":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("未触及"),1:"")_"】</span>"
	i PerPain'="" s ListData=ListData_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("双肾区叩击痛")_":【"_$S(PerPain="10":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("有"),LivLieCos="11":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("无"),1:"")_"】</span>"
	i Oedema'="" s ListData=ListData_spStyle_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("双下肢水肿")_":【"_$S(Oedema="10":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("无"),Oedema="11":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("轻"),Oedema="12":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("中"),Oedema="13":##class(PHA.CPW.Com.OutInterfance).GetTransDesc("重度水肿"),1:"")_"】</span></p>"

	i PhcpcDesc'="" s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("主诉")_"】&nbsp;&nbsp;"_PhcpcDesc_"</p>"
	i Icd'="" s ListData=ListData_"<p>【"_##class(PHA.CPW.Com.OutInterfance).GetTransDesc("初始诊断")_"】&nbsp;&nbsp;"_Icd_"</p>"
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("重要生命体征变化情况")_"^"_ListData)

	i ChaOfDisDesc'="" d
	.w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("主要病情变化情况")_"^"_ChaOfDisDesc)
	
	w ","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent",##class(PHA.CPW.Com.OutInterfance).GetTransDesc("治疗方案")_"^"_Guidance)
	
	w "]"
	q ""
}

/// Descript:获取主诉
ClassMethod GetPatPhcp(PhcpcRowId) As %String
{
	n (PhcpcRowId,%session)
	s PhcpcDesc=""
	s ChildSub=""
	f  s ChildSub=$o(^DHCPHCP(PhcpcRowId,"PPC",ChildSub)) q:ChildSub=""  d
	.s PhcpcDesc=$p(^DHCPHCP(PhcpcRowId,"PPC",ChildSub),"^",1)
	.s PhcpcDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHCliPatPreCom","PHCPCDesc","",PhcpcDesc)
	q PhcpcDesc
}

/// =======================================临床药学移动端=======================================
/// Descript:个人药学服务树
/// W ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonPerPharSerPad("24923402")
ClassMethod jsonPerPharSerPad(EpisodeID As %String) As %GlobalCharacterStream
{
	N (EpisodeID)

	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()

	s Num = 1
	/// 药学查房
	s Num = ..jsonWardRoundPad(pid,Num,EpisodeID)
	
	/// 用药建议
	s Num = ..jsonMedAdvicePad(pid,Num,EpisodeID)
	
	/// 医学查房
	s Num = ..jsonClinialPathPad(pid,Num,EpisodeID)
	
	/// 用药教育
	s Num = ..jsonMedEduPad(pid,Num,EpisodeID)
	
	/// 药学监护
	s Num = ..jsonPhaCarePad(pid,Num,EpisodeID)
	
	/// 转换数据为Json格式
	s ListTitle="itemtype^itemid^itemdesc"
	d OutBinStream.Write("[")  //输出json前缀串
	S index="", count=0
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,index)) Q:index=""  D
	.S index1=""
	.F  S index1=$o(^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,index,index1)) Q:index1=""  D
	..S ListData=^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,index,index1)
	..s count = count+1
	..I count=1 d
	...d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData))
	..e  d
	...d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData))
	..
	
	d OutBinStream.Write("]")   //输出json结尾符
	d ..killTmpGlobal(pid)
	Q OutBinStream
}

/// Descript:药学查房
/// W ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonWardRoundPad("16243032")
ClassMethod jsonWardRoundPad(pid As %String, num As %String, EpisodeID As %String) As %String
{
	n (pid, num, EpisodeID)
	
	s WrType=""
	f  s WrType=$o(^DHCPHWR("0","CurStatus",WrType)) Q:WrType=""  D
	.s wardRoundID=""
	.f  s wardRoundID=$o(^DHCPHWR("0","CurStatus",WrType,EpisodeID,wardRoundID)) q:wardRoundID=""  d
	..s userID=$p(^DHCPHWR(wardRoundID),"^",8)    //记录人
	..q:userID=""
	..q:'$d(^SSU("SSUSR",+userID))
	..s userName=$p(^SSU("SSUSR",userID),"^",2)   //姓名
	..s userName=$Replace(userName,"/","")
	..s wrDate=$p(^DHCPHWR(wardRoundID),"^",9)    //日期
	..s:wrDate'="" wrDate=$zd(wrDate,3)
	..s wrTime=$p(^DHCPHWR(wardRoundID),"^",10)   //时间
	..s:wrTime'="" wrTime=$zt(wrTime,2)
	..s mdata="WR"_"^"_wardRoundID_"^"_wrDate_" "_wrTime_" "_userName_" "_"【药学查房】"
	..s num=num+1
	..s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,wrDate_"^"_wrTime,num)=mdata
	.
	
	q num
}

/// Descript:用药建议
/// W ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonMedAdvicePad("2","1","16243032")
ClassMethod jsonMedAdvicePad(pid As %String, num As %String, EpisodeID As %String)
{
	n (pid, num, EpisodeID)

	s medAdvID=""
	f  s medAdvID=$o(^DHCPHAD(0,"AdmDr",EpisodeID,medAdvID)) q:medAdvID=""  d
	.q:'$d(^DHCPHAD(medAdvID))
	.s medAdvUser=$p(^DHCPHAD(medAdvID),"^",2)     //建议人
	.s:medAdvUser'="" medAdvUser=$p(^SSU("SSUSR",medAdvUser),"^",2)
	.s:medAdvUser["/" medAdvUser=$p(medAdvUser,"/",2)
	.s medAdvDate=$p(^DHCPHAD(medAdvID),"^",4)     //记录日期
	.s:medAdvDate'="" medAdvDate=$zd(medAdvDate,3)
	.s medAdvTime=$p(^DHCPHAD(medAdvID),"^",5)     //记录时间
	.s:medAdvTime'="" medAdvTime=$zt(medAdvTime,2)
	.s medAdvCurStatus=$p(^DHCPHAD(medAdvID),"^",6) //当前状态
	.s medAdvCurStatus=$S(medAdvCurStatus="10":"提议",medAdvCurStatus="20":"申诉",medAdvCurStatus="30":"已接受",medAdvCurStatus="40":"同意用药",1:"")
	.s mdata="MA"_"^"_medAdvID_"^"_medAdvDate_" "_medAdvTime_" "_medAdvUser_" "_"【用药建议】"
	.s num=num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,medAdvDate_"^"_medAdvTime,num)=mdata
	.
	q num
}

/// Descript:医学查房
/// W ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonCliPathographyPad("2","1","16243032")
ClassMethod jsonClinialPathPad(pid As %String, num As %String, EpisodeID As %String) As %String
{
	n (pid, num, EpisodeID)

	s cliPhaID=0
	f  s cliPhaID=$o(^DHCPHCP(0,"Adm",EpisodeID,cliPhaID)) q:cliPhaID=""  d
	.s cliPhaUser=$p(^DHCPHCP(cliPhaID),"^",18)    //记录人
	.s:cliPhaUser'="" cliPhaUser=$p($g(^SSU("SSUSR",cliPhaUser)),"^",2)
	.s:cliPhaUser["/" cliPhaUser=$p(cliPhaUser,"/",2)
	.s recordDate=$p(^DHCPHCP(cliPhaID),"^",19)    //记录日期
	.s:recordDate'="" recordDate=$zd(recordDate,3)
	.s recordTime=$p(^DHCPHCP(cliPhaID),"^",20)    //记录时间
	.s:recordTime'="" recordTime=$zt(recordTime,2)
	.s mdata="CP"_"^"_cliPhaID_"^"_recordDate_" "_recordTime_" "_cliPhaUser_" "_"【医学查房】"
	.s num=num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,recordDate_"^"_recordTime,num)=mdata
	.
	
	q num
}

/// Descript:用药教育
/// W ##Class(web.DHCSTPHCMPERPHARSERVICE).jsonMedEduPad("2","1","16243032")
ClassMethod jsonMedEduPad(pid As %String, num As %String, EpisodeID As %String) As %String
{
	n (pid, num, EpisodeID)
	
	s Type=""
	f  s Type=$o(^DHCPHME(0,"CurStatus",Type)) q:Type=""  d
	.s medEduID=""
	.f  s medEduID=$o(^DHCPHME(0,"CurStatus",Type,EpisodeID,medEduID)) q:medEduID=""  d
	..q:medEduID=""
	..s medUser=""
	..s medUserID=$p(^DHCPHME(medEduID),"^",3)    //记录人
	..s:medUserID'="" medUser=$p(^SSU("SSUSR",medUserID),"^",2)
	..s medUser=$Replace(medUser,"/","")
	..s medDate=$p(^DHCPHME(medEduID),"^",4)      //记录日期
	..s:medDate'="" medDate=$zd(medDate,3)
	..s medTime=$p(^DHCPHME(medEduID),"^",5)      //记录时间
	..s:medTime'="" medTime=$zt(medTime,2)
	..s ListData="ED"_"^"_medEduID_"^"_medDate_" "_medTime_" "_medUser_" "_"【用药教育】"
	..s num=num+1
	..s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,medDate_"^"_medTime,num)=ListData
	.

	q num
}

/// Descript:药学监护
ClassMethod jsonPhaCarePad(pid As %String, num As %String, EpisodeID As %String) As %String
{
	n (pid, num, EpisodeID)

	s monID=""
	f  s monID=$o(^DHCPHPC(0,"ADM",EpisodeID,monID)) q:monID=""  d
	.s monLevID=$p(^DHCPHPC(monID),"^",1)
	.s monLevel=$p(^DHCPHML(monLevID),"^",2)
	.i monLevel["一级" s monLevel="一级监护"
	.i monLevel["二级" s monLevel="二级监护"
	.i monLevel["三级" s monLevel="三级监护"
	.s monUser=""
	.s monUserID=$p(^DHCPHPC(monID),"^",5)  //监护人
	.s:monUserID'="" monUser=$p(^SSU("SSUSR",monUserID),"^",2)
	.s:monUser["/" monUser=$p(monUser,"/",2)
	.s monDate=$p(^DHCPHPC(monID),"^",6)  //监护日期
	.s:monDate'="" monDate=$zd(monDate,3)
	.s monTime=$p(^DHCPHPC(monID),"^",7)  //监护时间
	.s:monTime'="" monTime=$zt(monTime,2)
	.s ListData="MON"_"^"_monID_"^"_monDate_" "_monTime_" "_monUser_" "_"【药学监护】"
	.s num=num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid,monDate_"^"_monTime,num)=ListData
	.
	
	q num
}

/// Descript:加载个人药学服务明细
ClassMethod jsonPerPharSerDetPad(bsType As %String, bsPoint As %String) As %String
{
	n (bsType, bsPoint)
	
	s ListData=""
	i bsType = "WR" d
	.s ListData=..jsonWardRoundDetPad(bsPoint)
	
	i bsType = "MA" d
	.s ListData=..jsonMedAdviceDetPad(bsPoint)
	
	i bsType = "CP" d
	.s ListData=..jsonClinialPathDetPad(bsPoint)
	
	i bsType = "MON" d
	.s ListData=..jsonPhaCareDetPad(bsPoint)
	
	i bsType = "ED" d
	.s ListData=..jsonMedEduDetPad(bsPoint)
	q ListData
}

/// Descript:药学查房
ClassMethod jsonWardRoundDetPad(wardRoundID As %String) As %String
{
	n (wardRoundID)
	s mListData= "["
	s EpisodeID=$p(^DHCPHWR(wardRoundID),"^",1)  //就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	s wruser=""
	s userID=$p(^DHCPHWR(wardRoundID),"^",8)    //记录人
	s:userID'="" wruser=$p(^SSU("SSUSR",userID),"^",2)
	s userName=$p(^SSU("SSUSR",userID),"^",2)   //姓名
	s wrDate=$p(^DHCPHWR(wardRoundID),"^",9)    //日期
	s:wrDate'="" wrDate=$zd(wrDate,3)
	s wrTime=$p(^DHCPHWR(wardRoundID),"^",10)   //时间
	s:wrTime'="" wrTime=$zt(wrTime,2)
	s wrGuidance=$p(^DHCPHWR(wardRoundID),"^",7)  //指导意见
	s ListData="药学查房"_"^"_wrDate_"^"_wrTime_"^"_wruser_"^"_patNo_"^"_patName
	s mListData = mListData_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bsdate^bstime^bsuser^patno^patname",ListData)
	
	s ListData=""
	s wrHisPreComList=##Class(web.DHCSTPHCMWARDROUND).getWRHisPreCom(wardRoundID)    //现病史
	i wrHisPreComList'="" d
	.s ListData="现病史："_wrHisPreComList_"&nbsp;&nbsp;"

	s wrPasDisHisList=##Class(web.DHCSTPHCMWARDROUND).getWRPasDisHis(wardRoundID)    //既往病史
	i wrPasDisHisList'="" d
	.i ListData="" s ListData="既往病史："_$REPLACE(wrPasDisHisList,"||",",")_"&nbsp;&nbsp;"
	.e  s ListData=ListData_"；"_"既往病史："_$REPLACE(wrPasDisHisList,"||",",")_"&nbsp;&nbsp;"

	s wrPasMedHisList=##Class(web.DHCSTPHCMWARDROUND).getWRPasMedHis(wardRoundID)    //既往用药史
	i wrPasMedHisList'="" d
	.i ListData="" s ListData="既往用药史："_$REPLACE(wrPasMedHisList,"||",",")_"&nbsp;&nbsp;"
	.e  s ListData=ListData_"；"_"既往用药史："_$REPLACE(wrPasMedHisList,"||",",")_"&nbsp;&nbsp;"
	
	s wrPerFamHisList=##Class(web.DHCSTPHCMWARDROUND).getWRPerFamHis(wardRoundID)    //个人史及家族史
	i wrPerFamHisList'="" d
	.i ListData="" s ListData="个人史及家族史："_$REPLACE(wrPerFamHisList,"||",",")_"&nbsp;&nbsp;"
	.e  s ListData=ListData_"；"_"个人史及家族史："_$REPLACE(wrPerFamHisList,"||",",")_"&nbsp;&nbsp;"
	
	s wrConDisTreList=##Class(web.DHCSTPHCMWARDROUND).getWRConDisTre(wardRoundID)    //伴发疾病与用药情况
	i wrConDisTreList'="" d
	.i ListData="" s ListData="伴发疾病与用药情况："_$REPLACE(wrConDisTreList,"||",",")_"&nbsp;&nbsp;"
	.e  s ListData=ListData_"；"_"伴发疾病与用药情况："_$REPLACE(wrConDisTreList,"||",",")_"&nbsp;&nbsp;"

	s wrAllergHisList=##Class(web.DHCSTPHCMWARDROUND).getWRAlleicHis(wardRoundID)    //过敏史
	i wrAllergHisList'="" d
	.i ListData="" s ListData="过敏史："_$REPLACE(wrAllergHisList,"||",",")_"&nbsp;&nbsp;"
	.e  s ListData=ListData_"；"_"过敏史："_$REPLACE(wrAllergHisList,"||",",")_"&nbsp;&nbsp;"
	
	s WRGuidance=##Class(web.DHCSTPHCMPERPHARSERVICE).getWRGuidance(wardRoundID)
	i WRGuidance'="" d
	.i ListData="" s ListData="查房指导意见："_$REPLACE(WRGuidance,"||",",")_"&nbsp;&nbsp;"
	.e  s ListData=ListData_"；"_"查房指导意见："_$REPLACE(WRGuidance,"||",",")_"&nbsp;&nbsp;"

	s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","基本信息"_"^"_ListData)

	s wrDrgItm=##Class(web.DHCSTPHCMPERPHARSERVICE).getWardRoundDrgItm(wardRoundID)
	s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","重点关注药物"_"^"_wrDrgItm)
	
	s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","初始治疗方案"_"^"_wrGuidance)
	s mListData = mListData_"]"
	q mListData
}

/// Descript:用药建议明细
/// w ##class(web.DHCSTPHCMPERPHARSERVICE).jsonMedAdviceDetPad(33)
ClassMethod jsonMedAdviceDetPad(medAdvID As %String) As %String
{
	n (medAdvID)

	q:'$d(^DHCPHAD(medAdvID)) "[]"
	s ListData = "["
	s EpisodeID=$p(^DHCPHAD(medAdvID),"^",2)     //就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	s medAdvUser=$p(^DHCPHAD(medAdvID),"^",2)    //建议人
	s:medAdvUser'="" medAdvUser=$p(^SSU("SSUSR",medAdvUser),"^",2)
	s medAdvDate=$p(^DHCPHAD(medAdvID),"^",4)     //记录日期
	s:medAdvDate'="" medAdvDate=$zd(medAdvDate,3)
	s medAdvTime=$p(^DHCPHAD(medAdvID),"^",5)     //记录时间
	s:medAdvTime'="" medAdvTime=$zt(medAdvTime,2)
		
	S medAdvMasDataList="用药建议"_"^"_medAdvDate_"^"_medAdvTime_"^"_medAdvUser_"^"_patNo_"^"_patName
	s ListData = ListData_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bsdate^bstime^bsuser^patno^patname",medAdvMasDataList)
	
	s medAdvDrgItmList=##Class(web.DHCSTPHCMADVICE).getPHMedAdvDrgItm(medAdvID)   //医嘱信息

	s ListData = ListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","医嘱信息"_"^"_$REPLACE(medAdvDrgItmList,"||","、"))

	s medAdvContentList=##Class(web.DHCSTPHCMADVICE).getPHMedAdvDetail(medAdvID)  //建议信息
	s ListData = ListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","建议内容"_"^"_$REPLACE(medAdvContentList,"||","<br>"))

	s ListData = ListData_"]"
	Q ListData
}

/// Descript:医学查房
ClassMethod jsonClinialPathDetPad(cliPhaID As %String) As %String
{
	n (cliPhaID)
	s mListData = "["
	s EpisodeID=$p(^DHCPHCP(cliPhaID),"^",1)     //就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	
	s Temperature=$p(^DHCPHCP(cliPhaID),"^",2)    //体温
	s Pulse=$p(^DHCPHCP(cliPhaID),"^",3)          //脉搏
	s Breath=$p(^DHCPHCP(cliPhaID),"^",4)         //呼吸
	s Heartrate=$p(^DHCPHCP(cliPhaID),"^",5)    //心率
	s Bloodpre=$p(^DHCPHCP(cliPhaID),"^",6)     //血压
	s Urineamt=$p(^DHCPHCP(cliPhaID),"^",7)     //尿量
	s DouLunBrePho=$p(^DHCPHCP(cliPhaID),"^",8) //双肺呼吸音
	s Rale=$p(^DHCPHCP(cliPhaID),"^",9)         //啰音
	s Arrhythmia=$p(^DHCPHCP(cliPhaID),"^",10)  //心律
	s PathMurmur=$p(^DHCPHCP(cliPhaID),"^",11)  //各瓣膜听诊区、病理性杂音
	s Belly=$p(^DHCPHCP(cliPhaID),"^",12)       //腹部
	s LivLieCos=$p(^DHCPHCP(cliPhaID),"^",13)   //肝脾肋下
	s PerPain=$p(^DHCPHCP(cliPhaID),"^",14)     //双肾区叩击痛
	s Oedema=$p(^DHCPHCP(cliPhaID),"^",15)      //双下肢水肿
	s ChaOfDisDesc=$p(^DHCPHCP(cliPhaID),"^",16) //主要病情变化
	s Guidance=$p(^DHCPHCP(cliPhaID),"^",17)    //指导内容
	s Icd=$p(^DHCPHCP(cliPhaID),"^",21)         //具体诊断描述
	
	s cliPhaUser=$p($g(^DHCPHCP(cliPhaID)),"^",18)    //记录人
	s:cliPhaUser'="" cliPhaUser=$p($g(^SSU("SSUSR",cliPhaUser)),"^",2)
	s recordDate=$p(^DHCPHCP(cliPhaID),"^",19)    //记录日期
	s:recordDate'="" recordDate=$zd(recordDate,3)
	s recordTime=$p(^DHCPHCP(cliPhaID),"^",20)    //记录时间
	s:recordTime'="" recordTime=$zt(recordTime,2)
	
	s ListData="医学查房"_"^"_recordDate_"^"_recordTime_"^"_cliPhaUser_"^"_patNo_"^"_patName
	s mListData = mListData_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bsdate^bstime^bsuser^patno^patname",ListData)
	
	s ListData="体温:"_Temperature_" ℃、脉搏:"_Pulse_"次/分、呼吸:"_Breath_"次/分、心率:"_Heartrate_"次/分、血压:"_Bloodpre_"mmHg、尿量:"_Urineamt_"ML"
	
	i DouLunBrePho'="" s ListData=ListData_"、双肺呼吸音:"_$S(DouLunBrePho="10":"清",DouLunBrePho="11":"粗",1:"")
	i Rale'="" s ListData=ListData_"、啰音:"_$S(Rale="10":"闻及",Rale="11":"未闻及",Rale="12":"干",Rale="13":"湿",1:"")
	i Arrhythmia'="" s ListData=ListData_"、心律:"_$S(Arrhythmia="10":"齐",Arrhythmia="11":"不齐",1:"")
	i PathMurmur'="" s ListData=ListData_"、各瓣膜听诊区、病理性杂音:"_$S(PathMurmur="10":"闻及",PathMurmur="11":"未闻及",1:"")
	i Belly'="" s ListData=ListData_"、腹部:"_$S(Belly="10":"平软",Belly="11":"膨隆",1:"")
	i LivLieCos'="" s ListData=ListData_"、肝脾肋下:"_$S(LivLieCos="10":"触及",LivLieCos="11":"未触及",1:"")
	i PerPain'="" s ListData=ListData_"、双肾区叩击痛:"_$S(PerPain="10":"有",LivLieCos="11":"无",1:"")
	i Oedema'="" s ListData=ListData_"、双下肢水肿:"_$S(Oedema="10":"无",LivLieCos="11":"轻",LivLieCos="12":"中",LivLieCos="13":"重度水肿",1:"")
	i Icd'="" s ListData=ListData_"；<br>初始诊断:"_Icd
	s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","重要生命体征变化情况 "_"^"_ListData)

	i ChaOfDisDesc'="" d
	.s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","主要病情变化情况"_"^"_ChaOfDisDesc)
	
	s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","治疗方案"_"^"_Guidance)
	
	s mListData = mListData_"]"
	q mListData
}

/// Descript:药学监护
ClassMethod jsonPhaCareDetPad(phaCareID As %String) As %String
{
	n (phaCareID)
	s mListData = "["
	s monLevID=$p(^DHCPHPC(phaCareID),"^",1)
	s monLevel=$p(^DHCPHML(monLevID),"^",2)
	i monLevel["一级" s monLevel="一级监护"
	i monLevel["二级" s monLevel="二级监护"
	i monLevel["三级" s monLevel="三级监护"
	s EpisodeID=$p(^DHCPHPC(phaCareID),"^",2)        //就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	s monUser=""
	s monUserID=$p(^DHCPHPC(phaCareID),"^",5)  //监护人
	s:monUserID'="" monUser=$p(^SSU("SSUSR",monUserID),"^",2)
	s monDate=$p(^DHCPHPC(phaCareID),"^",6)  //监护日期
	s:monDate'="" monDate=$zd(monDate,3)
	s monTime=$p(^DHCPHPC(phaCareID),"^",7)  //监护时间
	s:monTime'="" monTime=$zt(monTime,2)
	s monContent=$p(^DHCPHPC(phaCareID),"^",8)   //监护内容
	s ImpMonItems=$p(^DHCPHPC(phaCareID),"^",9)   //重要检验检测项目
	
	s ListData="药学监护"_"^"_monDate_"^"_monTime_"^"_monUser_"^"_patNo_"^"_patName
	s mListData = mListData_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bsdate^bstime^bsuser^patno^patname",ListData)

	s phaCareMonScopeList=##Class(web.DHCSTPHCMPERPHARSERVICE).getphaCareMonScope(phaCareID)
	s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","纳入标准"_"^"_phaCareMonScopeList)
		
	s phaCareMonItemList=##Class(web.DHCSTPHCMPERPHARSERVICE).getphaCareMonItem(phaCareID)
	s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","生命体征"_"^"_phaCareMonItemList)
	
	s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","检验检查"_"^"_ImpMonItems)

	s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","病情转归情况"_"^"_monContent)
	s mListData = mListData_"]"
	Q mListData
}

/// Descript:用药教育
ClassMethod jsonMedEduDetPad(medEduID As %String) As %String
{
	n (medEduID)
	s mListData = "["
	s EpisodeID=$p(^DHCPHME(medEduID),"^",1)     //就诊ID
	S curStatus=$p(^DHCPHME(medEduID),"^",2)
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s patName=$p(^PAPER(PatientID,"ALL"),"^",1)  //姓名
	s patNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  //登记号
	s PatSex=""
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)	 // 性别Id 
    i SexId'="" s PatSex=$p(^CT("SEX",SexId),"^",2)		// 性别
    s patAge=##class(PHA.FACE.IN.Com).GetAge(PatientID,EpisodeID)  // 年龄
	s AdmWard=""
	s AdmWardDr=$p(^PAADM(EpisodeID),"^",70)
	i AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
	s bedid=$p(^PAADM(EpisodeID),"^",73)                   //床号
	i bedid="" s AdmBed=""
    e  s AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	s MEBadHabits=$p(^DHCPHME(medEduID),"^",6)    //不良嗜好
	s MEConDisAndTre=$p(^DHCPHME(medEduID),"^",7) //伴发疾病与用药情况
	s MEGrantFlag=$p(^DHCPHME(medEduID),"^",8)    //发放临床药师联系卡
	s MEGrantFlag=$s(MEGrantFlag="Y":"是",MEGrantFlag="N":"否",1:"")
	s MEGuidObject=$p(^DHCPHME(medEduID),"^",9)   //指导对象
	s MEGuidContent=$p(^DHCPHME(medEduID),"^",10) //指导意见/内容
	s MEIcd=$p(^DHCPHME(medEduID),"^",11)  	      //诊断描述
	s mobPhone=$p(^DHCPHME(medEduID),"^",12)      //联系方式
	s Address=$p(^DHCPHME(medEduID),"^",13)       //家庭地址

	s medUser=""
	s medUserID=$p(^DHCPHME(medEduID),"^",3)    //记录人
	s:medUserID'="" medUser=$p(^SSU("SSUSR",medUserID),"^",2)
	s medDate=$p(^DHCPHME(medEduID),"^",4)      //记录日期
	s:medDate'="" medDate=$zd(medDate,3)
	s medTime=$p(^DHCPHME(medEduID),"^",5)      //记录时间
	s:medTime'="" medTime=$zt(medTime,2)
	
	s medEduList="用药教育"_"^"_medDate_"^"_medTime_"^"_medUser_"^"_patNo_"^"_patName
	s mListData = mListData_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bsdate^bstime^bsuser^patno^patname",medEduList)
	
	s ListData="科室："_AdmWard_"、床号："_AdmBed_"、性别："_PatSex_"、年龄："_patAge_"、联系方式："_mobPhone_"、家庭地址："_Address
	s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","基本信息"_"^"_ListData)
	
	s ListData=""
	i MEBadHabits'="" s ListData=ListData_"不良嗜好(烟、酒、药物依赖)："_MEBadHabits_"；&nbsp;&nbsp;"
	i MEConDisAndTre'="" s ListData=ListData_"伴发疾病与用药情况："_MEConDisAndTre_"；&nbsp;&nbsp;"
	i MEGrantFlag'="" s ListData=ListData_"发放临床药师联系卡："_MEGrantFlag_"；&nbsp;&nbsp;"
	i MEGuidObject'="" s ListData=ListData_"指导对象："_$S(MEGuidObject="10":"患者本人",MEGuidObject="11":"患者家属",1:"其他")_"；&nbsp;&nbsp;"

	i (curStatus="N")&(MEIcd'="") s ListData=ListData_"入院诊断："_MEIcd_"；&nbsp;&nbsp;"
	i (curStatus="I")&(MEIcd'="") s ListData=ListData_"诊断："_MEIcd_"；&nbsp;&nbsp;"
	i (curStatus="O")&(MEIcd'="") s ListData=ListData_"出院诊断："_MEIcd_"；&nbsp;&nbsp;"
	
	/// 指导内容
	s medEduGuiContent=##class(web.DHCSTPHCMPERPHARSERVICE).getMedEduGuiContent(medEduID,curStatus)
	i medEduGuiContent'="" s ListData=ListData_"指导内容："_medEduGuiContent_"；&nbsp;&nbsp;"
	
	i curStatus="N" d
	.s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","入院情况"_"^"_ListData)
	
	s medEduDrgList=##Class(web.DHCSTPHCMPERPHARSERVICE).getMedEduDrgItm(medEduID)  //关注药品
	i medEduDrgList'="" d
	.s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","关注药品"_"^"_medEduDrgList)

	i curStatus'="N" d
	.s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","指导信息"_"^"_ListData)

	i (curStatus'="O")&(MEGuidContent'="") d
	.s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","注意事项"_"^"_MEGuidContent)
	
	i curStatus="O" d
	.s mListData = mListData_","_##class(web.DHCSTPHCMCOMMON).getJsonData("bstitle^bscontent","注意事项"_"^"_MEGuidContent)

	s mListData = mListData_"]"
	
	Q mListData
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMPERPHARSERVICE","jsonWardRound",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMPERPHARSERVICE"))
}

}
