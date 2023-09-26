Import SQLUser

/// Creator:    yangyongtao
/// CreateDate: 2017-04-06
/// Descript:   用药教育
Class web.DHCSTPHCMEDUCATION Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:用药教育
/// w ##class(web.DHCSTPHCMEDUCATION).SaveMedEducation("43","644^New^^注意事xrdxr^578^感冒^123456^陕西西安!!")
ClassMethod SaveMedEducation(medEduID As %String, medEduDataList As %String) As %String
{
	n (medEduID,medEduDataList)
	s medEduMasDataList=$p(medEduDataList,"!",1) //用药教育主信息
	s medEduGuiConList=$p(medEduDataList,"!",2)  //指导内容
	s medEduDrgItmList=$p(medEduDataList,"!",3)  //药品关注
	s ret=0
	i medEduID="" d
	.S ret=..Insert(medEduMasDataList,medEduGuiConList,medEduDrgItmList)
	e  d
	.S ret=..Update(medEduID,medEduMasDataList,medEduGuiConList,medEduDrgItmList)
	q ret
}

/// Descript:用药教育
ClassMethod Insert(medEduMasDataList, medEduGuiConList, medEduDrgItmList) As %String
{
	N (medEduMasDataList,medEduGuiConList,medEduDrgItmList)
	s Err=0

	TS
	//用药教育主表
	s medEduID=..InsMedEducation(medEduMasDataList)
	i medEduID<0 tro
	q:medEduID<0 medEduID

	//用药指导内容
	i medEduGuiConList'="" d
	.s Err=..InsMedEduGuiContent(medEduID, medEduGuiConList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//相关药品
	i medEduDrgItmList'="" d
	.s Err=..InsMedEduDrgItm(medEduID, medEduDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-12"

	TC
    Q "0#"_medEduID
}

/// Descript:每日病情记录表
ClassMethod Update(medEduID, medEduMasDataList, medEduGuiConList, medEduDrgItmList) As %String
{
	N (medEduID,medEduMasDataList,medEduGuiConList,medEduDrgItmList)
	s Err=0

	TS
	//查房主表
	s Err=..UpdMedEducation(medEduID,medEduMasDataList)
	i Err<0 tro
	q:Err<0 "-10"

	//删除相关子表
	s Err=..DelMedEduRelaTable(medEduID)
	i Err'=0 tro
	q:Err'=0 Err
	
	//用药指导内容
	i medEduGuiConList'="" d
	.s Err=..InsMedEduGuiContent(medEduID, medEduGuiConList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//相关药品
	i medEduDrgItmList'="" d
	.s Err=..InsMedEduDrgItm(medEduID, medEduDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-12"

	TC
	Q "0#"_medEduID
}

/// Descript:插入查房信息
ClassMethod InsMedEducation(medEduMasDataList As %String) As %String
{
  

   //medEduDataList=AdmDr+"^"+MECurStatus+"^"+PatObj+"^"+MEGuidContent+"^"+UserID+"^"+grantFlag+"^"+MEBadHabits+"^"+DiagDesc+"^"+MEConDisAndTre+"^"+modPhone+"^"+address;
	N (medEduMasDataList)
	S MEAdmDr=$p(medEduMasDataList,"^",1)        //病人Adm
	S MECurStatus=$p(medEduMasDataList,"^",2)    //当前状态
	i MECurStatus="New" s MECurStatus="N"
	else  if MECurStatus="In" s MECurStatus="I"
	else  s MECurStatus="O"
	S MEGuidObject=$p(medEduMasDataList,"^",3)   //指导对象
	S MEGuidContent=$p(medEduMasDataList,"^",4)  //指导意见/内容
	S MEUserDr=$p(medEduMasDataList,"^",5)       //记录人
	S MEGrantFlag=$p(medEduMasDataList,"^",6) //发放临床药师联系卡
	S MEBadHabits=$p(medEduMasDataList,"^",7)    //不良嗜好
	S MEIcd=$p(medEduMasDataList,"^",8)          //诊断
	S MEConDisAndTre=$p(medEduMasDataList,"^",9) //伴发疾病与用药情况
	
	S modPhone=$p(medEduMasDataList,"^",10)      //电话
	S address=$p(medEduMasDataList,"^",11)       //家庭住址
	S patSign=$p(medEduMasDataList,"^",12)       //患者签名路径
	S phaSign=$p(medEduMasDataList,"^",13)       //药师签名路径
	
	S MEDate=+$H                                 //记录日期
	S METime=$p($H,",",2)                        //记录时间
	
	&SQL(Insert Into DHC_PHMedEducation(PHME_Adm_Dr,PHME_CurStatus,PHME_User_Dr,PHME_Date,PHME_Time,PHME_BadHabits,PHME_ConDisAndTre,PHME_GrantFlag,PHME_GuidObject,PHME_GuidContent,PHME_Icd,PHME_MobPhone,PHME_Address,PHME_PatSignPath,PHME_PharSignPath) 
		Values(:MEAdmDr,:MECurStatus,:MEUserDr,:MEDate,:METime,:MEBadHabits,:MEConDisAndTre,:MEGrantFlag,:MEGuidObject,:MEGuidContent,:MEIcd,:modPhone,:address,:patSign,:phaSign))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:更新查房信息
ClassMethod UpdMedEducation(medEduID As %String, medEduMasDataList As %String) As %String
{
	N (medEduID,medEduMasDataList)
	S MEAdmDr=$p(medEduMasDataList,"^",1)        //病人Adm
	S MECurStatus=$p(medEduMasDataList,"^",2)    //当前状态
	S MECurStatus=$p(medEduMasDataList,"^",2)    //当前状态
	i MECurStatus="New" s MECurStatus="N"
	else  if MECurStatus="In" s MECurStatus="I"
	else  s MECurStatus="O"
	S MEGuidObject=$p(medEduMasDataList,"^",3)   //指导对象
	S MEGuidContent=$p(medEduMasDataList,"^",4)  //指导意见/内容
	S MEUserDr=$p(medEduMasDataList,"^",5)       //记录人
	S MEGrantFlag=$p(medEduMasDataList,"^",6) //发放临床药师联系卡
	S MEBadHabits=$p(medEduMasDataList,"^",7)    //不良嗜好
	S MEIcd=$p(medEduMasDataList,"^",8)          //诊断
	S MEConDisAndTre=$p(medEduMasDataList,"^",9) //伴发疾病与用药情况
	
	S modPhone=$p(medEduMasDataList,"^",10)      //电话
	S address=$p(medEduMasDataList,"^",11)       //家庭住址
	
	S patSign=$p(medEduMasDataList,"^",12)       //患者签名路径
	S phaSign=$p(medEduMasDataList,"^",13)       //药师签名路径
	
	S MEDate=+$H                                 //记录日期
	S METime=$p($H,",",2)                        //记录时间
	
	&SQL(Update DHC_PHMedEducation Set PHME_Adm_Dr=:MEAdmDr,PHME_CurStatus=:MECurStatus,PHME_User_Dr=:MEUserDr,
		PHME_Date=:MEDate,PHME_Time=:METime,PHME_BadHabits=:MEBadHabits,PHME_ConDisAndTre=:MEConDisAndTre,PHME_GrantFlag=:MEGrantFlag,
		PHME_GuidObject=:MEGuidObject,PHME_GuidContent=:MEGuidContent,PHME_Icd=:MEIcd,PHME_MobPhone=:modPhone,PHME_Address=:address,PHME_PatSignPath=:patSign,PHME_PharSignPath=:phaSign Where PHME_RowID=:medEduID) 

	Q SQLCODE
}

/// Descript:获取电子病例数据
/// w ##class(web.DHCSTPHCMEDUCATION).GetPatInfoByEmr("1")
ClassMethod GetPatInfoByEmr(EpisodeID As %String) As %String
{
	S Data=..GetPatInfoFromEmr(EpisodeID)
	S PasDisHis=$p(Data,"^",7) //伴发疾病与用药情况
	S perHis=$p(Data,"^",9) //不良嗜好
	Q PasDisHis_"#"_perHis
}

/// Creator:qunianpeng
/// CreatDate:2017-01-18
/// Description:从电子病历中取病人的生命体征和各种数据
/// return: 尿量 体温 脉搏 呼吸 血压 现病史 既往病史 过敏史 个人史 家族史  出院诊断
/// other:w ##class(web.DHCSTPHCMCOMMON).GetPatInfoFromEmr("644")
ClassMethod GetPatInfoFromEmr(EpisodeID As %String) As %String
{
	s firstLifeInfo=##class(web.DHCTHREEE).GetFirstData(EpisodeID)	//护理病历中取生命体征（尿量）
	s Urineamt=$p(firstLifeInfo,"^",6)	//尿量
	Set obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(EpisodeID,"HDSD00.13")
	s Temperature=obj.GetAt("HDSD00.13.303")	//体温
	s Pulse=obj.GetAt("HDSD00.13.080")  	//脉搏
	s Breath=obj.GetAt("HDSD00.13.077") 	//呼吸
	s DiastolicPre=obj.GetAt("HDSD00.13.085") 	//舒张压
	s ShrinkPre=obj.GetAt("HDSD00.13.086") 	//收缩压
	s Bloodpre=ShrinkPre_"/"_DiastolicPre	//血压
	s PreDisHis=obj.GetAt("HDSD00.13.095")	//入院记录	现病史
	s PasDisHis=obj.GetAt("HDSD00.13.300")	//入院记录 既往病史  "伴发疾病与用药情况" 
	s AllergicHis=obj.GetAt("HDSD00.13.037")	//入院记录 过敏史
	s perHis=obj.GetAt("HDSD00.13.036")	//入院记录 个人史    "不良嗜好"
	s FamHis=obj.GetAt("HDSD00.13.043")	//入院记录  家族史
	
	s OutChinMedInf=obj.GetAt("HDSD00.12028") 	//出院中医诊断
	s OutChinMedMainInf=obj.GetAt("HDSD00.12030") 	//出院中医诊断主诊名称
	s OutWestMedInf=obj.GetAt("HDSD00.12025")		//出院西医诊断
	s OutWestMedOtherInf= obj.GetAt("HDSD00.12022")	   //出院西医其他诊断
	s OutPatAdmInf=OutChinMedInf_" "_OutChinMedMainInf_" "_OutWestMedInf_" "_OutWestMedOtherInf

	s LifeSignData=Urineamt_"^"_Temperature_"^"_Pulse_"^"_Breath_"^"_Bloodpre_"^"_PreDisHis_"^"_PasDisHis_"^"_AllergicHis_"^"_perHis_"^"_FamHis_"^"_OutPatAdmInf
	q LifeSignData
}

/// Descript:保存用药指导内容
ClassMethod InsMedEduGuiContent(medEduID As %String, medEduGuiConList As %String) As %String
{
	N (medEduID,medEduGuiConList)
	S Len=$L(medEduGuiConList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S medEduGuiCon=$p(medEduGuiConList,"||",i)
	.;S ItemCode=$p(medEduGuiCon,"^",1)    //代码
	.;S ItemDesc=$p(medEduGuiCon,"^",2)    //指导意见
	.S ItemCode=medEduGuiCon
	.S childSub=$o(^DHCPHME(medEduID,"GC",""),-1)+1
	.&SQL(Insert into DHC_PHMEGuiContent(PHMEGC_PHME_Parref,PHMEGC_ChildSub,PHMEGC_Code,PHMEGC_GuidDesc)
		Values(:medEduID,:childSub,:ItemCode,:ItemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除用药指导内容
ClassMethod DelMedEduGuiContent(medEduID As %String) As %String
{
	N (medEduID)
	&SQL(delete from DHC_PHMEGuiContent where PHMEGC_PHME_Parref=:medEduID)
	Q SQLCODE
}

/// Descript:保存关注药品
ClassMethod InsMedEduDrgItm(medEduID As %String, medEduDrgItmList As %String) As %String
{
	N (medEduID,medEduDrgItmList)
	S Len=$L(medEduDrgItmList,",")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S medEduDrgItm=$p(medEduDrgItmList,",",i)
	.S oeoriDr=$p(medEduDrgItm,"^",1)        //医嘱ID
	.;S guiContent=$p(medEduDrgItm,"^",2)     //指导内容
	.s guiContent=""
	.S childSub=$o(^DHCPHME(medEduID,"DI",""),-1)+1
	.&SQL(Insert into DHC_PHMEDrgItm(PHMEDI_PHME_Parref,PHMEDI_ChildSub,PHMEDI_OEORI_DR,PHMEDI_Desc)
		Values(:medEduID,:childSub,:oeoriDr,:guiContent))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除关注药品
ClassMethod DelMedEduDrgItm(medEduID As %String) As %String
{
	N (medEduID)
	&SQL(delete from DHC_PHMEDrgItm where PHMEDI_PHME_Parref=:medEduID)
	Q SQLCODE
}

/// Descript: 删除用药教育相关信息表
ClassMethod DelMedEduRelaTable(medEduID As %String) As %String
{
	n (medEduID)
	
	//用药指导内容
	i $d(^DHCPHME(medEduID,"GC",1)) d
	.&SQL(delete from DHC_PHMEGuiContent where PHMEGC_PHME_Parref=:medEduID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	//关注药品
	i $d(^DHCPHME(medEduID,"DI",1)) d
	.&SQL(delete from DHC_PHMEDrgItm where PHMEDI_PHME_Parref=:medEduID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	q 0
}

/// Descript:获取用药教育数据
/// w ##class(web.DHCSTPHCMEDUCATION).getMedEducation("644","Out")
ClassMethod getMedEducation(AdmDr As %String, curStatus As %String) As %GlobalCharacterStream
{
	N (AdmDr,curStatus)
	S n=0 
	S pid=..NewPid()
	K ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEducation",pid)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	i curStatus="New"  s curStatus="N"
	e  i curStatus="Out"  s curStatus="O"
	S medEduID=$o(^DHCPHME(0,"CurStatus",curStatus,AdmDr,""),-1)
	Q:medEduID="" ""  ;没有记录，返回-999
	S AdmDr=$p(^DHCPHME(medEduID),"^",1)     //病人Adm
    S AdmWard=""
	S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
	S bedid=$p(^PAADM(AdmDr),"^",73)             //床号
	I bedid="" S AdmBed=""
    E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
    S Papmi=$p(^PAADM(AdmDr),"^",1)
    S PatName=$p(^PAPER(Papmi,"ALL"),"^",1)      //姓名
	S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)      //登记号
	S mobPhone=$p(^PAPER(Papmi,"PER",4),"^",21)  //电话
    S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )       //姓别
	S PatSex=$p(^CT("SEX",SexID),"^",2)
	S PatAge=##class(web.DHCSTKUTIL).GetAge(Papmi)  //年龄
	S PatW=##class(web.DHCSTCNTSCOMMON).GetPatWeight(AdmDr)       //体重
	S PatH=##class(web.DHCSTCNTSCOMMON).GetPatHeight(AdmDr)       //身高
	
	S EDCurStatus=$p(^DHCPHME(medEduID),"^",2) //当前状态
	S EDUser=""
	S EDUserDr=$p(^DHCPHME(medEduID),"^",3)    //记录人
	S:EDUserDr'="" EDUser=$p(^SSU("SSUSR",EDUserDr),"^",2)
	S EDDate=$p(^DHCPHME(medEduID),"^",4)      //记录日期
	S:EDDate'="" EDDate=$zd(EDDate,3)
	S EDTime=$p(^DHCPHME(medEduID),"^",5)      //记录时间
	S:EDTime'="" EDTime=$zt(EDTime,2)
	S MEBadHabits=$p(^DHCPHME(medEduID),"^",6)    //不良嗜好
	S MEConDisAndTre=$p(^DHCPHME(medEduID),"^",7) //伴发疾病与用药情况
	S MEGrantFlag=$p(^DHCPHME(medEduID),"^",8)    //发放临床药师联系卡
	S MEGuidObject=$p(^DHCPHME(medEduID),"^",9)   //指导对象
	S MEGuidContent=$p(^DHCPHME(medEduID),"^",10)  //指导意见/内容
	S MEIcd=$p(^DHCPHME(medEduID),"^",11)  	  //诊断描述
	S mobPhone=$p(^DHCPHME(medEduID),"^",12)  //联系方式
	S Address=$p(^DHCPHME(medEduID),"^",13)     //家庭地址
	
	S PhaPath=$p(^DHCPHME(medEduID),"^",14)     //药师
	S PatPath=$p(^DHCPHME(medEduID),"^",15)     //患者
	
	//S medEduMasDataList=PatNo_"^"_PatName_"^"_AdmBed_"^"_PatSex_"^"_PatAge_"^"_PatW_"^"_PatH_"^"_mobPhone
	//S medEduMasDataList=medEduMasDataList_"^"_EDCurStatus_"^"_EDUser_"^"_EDDate_"^"_EDTime_"^"_MEBadHabits_"^"_MEConDisAndTre_"^"_MEGrantFlag_"^"_MEGuidObject_"^"_MEGuidContent_"^"_MEIcd_"^"_medEduID_"^"_Address
	
	 S medEduGuiConList=..getMedEduGuiContent(medEduID)    //用药指导内容
	
	 S n=n+1
     S data=MEGuidObject_"^"_MEGuidContent_"^"_medEduGuiConList_"^"_medEduID_"^"_MEBadHabits_"^"_MEConDisAndTre_"^"_MEGrantFlag_"^"_MEIcd_"^"_EDDate_"^"_EDUser_"^"_PhaPath_"^"_PatPath
	 S ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEducation",pid,n)=data
	 
     //Q:n=0 ##class(web.DHCSTJsonCommon).getJsonEmptySign(n) //输出空的json串
    
     S maxrow=n
     S count=0
     //W ##class(web.DHCSTJsonCommon).getJsonStartSign(n) //输出json前缀串
     d OutBinStream.Write("[")  //输出json前缀串
     S h=""
     F  S h=$o(^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEducation",pid,h)) Q:h=""  D
     .S mdata=^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEducation",pid,h)
     .S count = count+1
	 .S Title="GuidObj^GuidCon^EduGuiConList^medEduID^badHabits^conDisTre^grantFlag^MEIcd^EDDate^EDUser^PhaPath^PatPath"
	 .I count=1 D
	 ..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	 .e  d
	 ..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	 d OutBinStream.Write("]")   //输出json结尾符
	 K ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEducation",pid)
     //D OutBinStream.OutputToDevice()
     Q OutBinStream
}

/// Descript:	计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("MedEducation"))
}

/// Descript:指导意见
/// w ##class(web.DHCSTPHCMEDUCATION).getMedEduGuiContent("34")
ClassMethod getMedEduGuiContent(medEduID As %String) As %String
{
	N (medEduID)
	S CH="",ret=""
	F  S CH=$o(^DHCPHME(medEduID,"GC",CH)) Q:CH=""  D
	.S ItemCode=$p(^DHCPHME(medEduID,"GC",CH),"^",1)
	.I ret="" S ret=ItemCode
	.E  S ret=ret_"#"_ItemCode
	Q ret
}

/// Descript:临床查房指导意见表
/// w ##class(web.DHCSTPHCMEDUCATION).getMeduGuid("43")
ClassMethod getMeduGuid(medEduID As %String) As %GlobalCharacterStream
{
	N (medEduID)
	s Num=0
	s StPage = 1, EndPage = 999
    S pid=..NewPid()
    K ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMeduGuid",pid)
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
    s CH=""
	F  S CH=$o(^DHCPHME(medEduID,"GC",CH)) Q:CH=""  D
	.s Code=$p(^DHCPHME(medEduID,"GC",CH),"^",1)
	.s Num=Num+1
	.s ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMeduGuid",pid,Num)=Code
	//q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	S Title="gcode"
	s maxrow=Num
	i EndPage>maxrow S EndPage=maxrow
	s quitflag=0
	d OutBinStream.Write("[")  //输出json前缀串
	//w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	s index=""
	f  S index=$o(^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMeduGuid",pid,index)) Q:(index="")||(quitflag=1)  D
	.s mdata=^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMeduGuid",pid,index)
	.s Num=Num+1
	.q:Num<StPage
	.s:Num=EndPage quitflag=1
	.i Num=StPage d
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	d OutBinStream.Write("]")   //输出json结尾符
	K ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMeduGuid",pid)
    //D OutBinStream.OutputToDevice()
	Q OutBinStream
}

/// Descript:关注药品
/// w ##class(web.DHCSTPHCMEDUCATION).getMedEduDrgItm("52")
ClassMethod getMedEduDrgItm(medEduID As %String, StPage = "1", EndPage = "999") As %GlobalCharacterStream
{
	N (medEduID,StPage,EndPage)
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	 s OutBinStream=##Class(%GlobalCharacterStream).%New()
	S curStatus=$p(^DHCPHME(medEduID),"^",2)
	S Num=0
	S CH=""
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
	.S inciDesc=$p(^INCI(inci,1),"^",2) //药品名称
	.S dosage=$j($p(^OEORD(ord,"I",chl,2),"^",1)," ",3) //剂量
	.S dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	.S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)   //剂量单位
	.S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) //OEORI_PHFreq_DR
    .S freq=$p($g(^PHCFR(freqdr)),"^",3)           //频率
    .S instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    .S instru=$p($g(^PHCIN(instrudr)),"^",2)        //用法
    .s durId=+$p(^OEORD(ord,"I",chl,2),"^",6)
	.S duration=$p($g(^PHCDU(durId)),"^",1)         //用药疗程
	.S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
    .s genenicdr=$p($g(^PHCD(+phcdf,4)),"^",1)
    .s genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) //通用名
    .s formdr=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1),"^",1)
    .s form=$p(^PHCF(formdr),"^",2) //剂型
    .s manf=""
    .s manfdr=$p($g(^PHCD(+phcdf,2)),"^",4) //厂家
    .s:manfdr'="" manf=$p($p($g(^PHMNF(manfdr)),"^",2),"-",2)
	.S doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm) //医生
	.S StartDate=+$p(^OEORD(ord,"I",chl,1),"^",9)   //开始日期
	.S:StartDate'="" StartDate=$zd(StartDate,3)
	.S dgID=$S(curStatus="I":"drugdg",curStatus="O":"outdrugdg",1:"")
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEduDrgItm",pid,Num)=orditm_"^"_StartDate_"^"_inciDesc_"^"_dosage_doseuom_"^"_freq_"^"_instru_"^"_duration_"^"_doctor_"^"_genenic_"^"_form_"^"_manf_"^"_dgID

	//i 4>Num d
	//.S Len=4-Num
	//.f i=1:1:Len d
	//..S Num=Num+1
	//..S ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEduDrgItm",pid,Num)=""
	
	//Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="orditm^StartDate^incidesc^Dosage^freq^Instance^duration^Doctor^genenic^form^manf^dgID"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	d OutBinStream.Write("[")  //输出json前缀串
	//w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEduDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEduDrgItm",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
    ..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	d OutBinStream.Write("]")   //输出json结尾符
    //D OutBinStream.OutputToDevice()
	Q OutBinStream
}

/// Descript:获取用药教育数据
/// 住院期间患者列表   历史记录  100^1^1074^In^2017-08-15^2017-08-15
/// w ##class(web.DHCSTPHCMEDUCATION).getMedEduRecord("100","1","1196","In","2017-08-15","2017-08-15")
ClassMethod getMedEduRecord(offet, limit, AdmDr, curStatus, startDate, endDate) As %GlobalCharacterStream
{
	n (offet,limit,AdmDr,curStatus,startDate,endDate)
	s rows=offet
	s page=limit
	S End = page*rows
	S Start=(page-1)*rows+1
	S pid=..NewPid()
	D ..killTmpGlobal(pid)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	i curStatus="In"  s curStatus="I"
	s stdate=$zdh(startDate,3)
	s enddate=$zdh(endDate,3)
	s h=0
	s fdate=0
	f fdate=stdate:1:enddate  d
	.s medEduID=""
	.f  s medEduID=$o(^DHCPHME(0,"DateAdm",fdate,AdmDr,medEduID)) q:(medEduID="")||(medEduID=0)  d
	..S AdmDr=$p(^DHCPHME(medEduID),"^",1)     //病人Adm
    ..S AdmWard=""
	..S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	..I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
	..S bedid=$p(^PAADM(AdmDr),"^",73)             //床号
	..I bedid="" S AdmBed=""
    ..E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
    ..S Papmi=$p(^PAADM(AdmDr),"^",1)
    ..S PatName=$p(^PAPER(Papmi,"ALL"),"^",1)      //姓名
	..S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)      //登记号
	..S mobPhone=$p(^PAPER(Papmi,"PER",4),"^",21)  //电话
    ..S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )       //姓别
	..S PatSex=$p(^CT("SEX",SexID),"^",2)
	..S PatAge=##class(web.DHCSTKUTIL).GetAge(Papmi)  //年龄
	..S PatW=##class(web.DHCSTCNTSCOMMON).GetPatWeight(AdmDr)       //体重
	..S PatH=##class(web.DHCSTCNTSCOMMON).GetPatHeight(AdmDr)       //身高
	..S EDCurStatus=$p(^DHCPHME(medEduID),"^",2) //当前状态
	..Q:EDCurStatus'=curStatus  //Quit出 不是住院期间患者的信息列表
	..S EDUser=""
	..S EDUserDr=$p(^DHCPHME(medEduID),"^",3)    //记录人
	..S:EDUserDr'="" EDUser=$p(^SSU("SSUSR",EDUserDr),"^",2)
	..S EDDate=$p(^DHCPHME(medEduID),"^",4)      //记录日期
	..S:EDDate'="" EDDate=$zd(EDDate,3)
	..S EDTime=$p(^DHCPHME(medEduID),"^",5)      //记录时间
	..S:EDTime'="" EDTime=$zt(EDTime,2)
	..S MEBadHabits=$p(^DHCPHME(medEduID),"^",6)    //不良嗜好
	..S MEConDisAndTre=$p(^DHCPHME(medEduID),"^",7) //伴发疾病与用药情况
	..S MEGrantFlag=$p(^DHCPHME(medEduID),"^",8)    //发放临床药师联系卡
	..S MEGuidObject=$p(^DHCPHME(medEduID),"^",9)   //指导对象
	..S MEGuidContent=$p(^DHCPHME(medEduID),"^",10)  //指导意见/内容
	..S MEIcd=$p(^DHCPHME(medEduID),"^",11)  //诊断描述
	..s h=h+1
	..S data=medEduID_"^"_EDDate_" "_EDTime_"^"_EDUser
	..//S data=AdmDr_"^"_PatNo_"^"_PatName_"^"_AdmBed_"^"_PatSex_"^"_PatAge_"^"_PatW_"^"_PatH_"^"_mobPhone
	..//S data=data_"^"_EDCurStatus_"^"_EDUser_"^"_EDDate_" "_EDTime_"^"_MEGrantFlag_"^"_MEGuidObject_"^"_MEGuidContent_"^"_MEIcd_"^"_medEduID
	..s ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEduRecord",pid,h)=data
    //Q:h=0 ##class(web.DHCSTJsonCommon).getJsonEmptySign(h) //输出空的json串
	S count=0
	d OutBinStream.Write("[")  //输出json前缀串
	//W ##class(web.DHCSTJsonCommon).getJsonStartSign(h) //输出json前缀串
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEduRecord",pid,index)) Q:index=""  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEduRecord",pid,index)
	.S count = count+1
	.//S Title="AdmDr^PatNo^PatName^AdmBed^PatSex^PatAge^PatW^PatH^mobPhone^EDCurStatus^EDUser^EDDateTime^MEGrantFlag^MEGuidObject^MEGuidContent^MEIcd^medEduID"
	.S Title="rowid^recordDate^user"
	.Q:(count<Start)||(count>End)
	.I count=Start D
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	d OutBinStream.Write("]")   //输出json结尾符
	D ..killTmpGlobal(pid)
    //D OutBinStream.OutputToDevice()
	Q OutBinStream
}

/// Descript:获取用药教育数据(住院信息)
/// w ##class(web.DHCSTPHCMEDUCATION).getMedEducationByEduID("36","In")
ClassMethod getMedEducationByEduID(medEduID As %String, curStatus As %String) As %GlobalCharacterStream
{
	N (medEduID,curStatus)
	S n=0 
	S pid=..NewPid()
	D ..killTmpGlobal(pid)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	i curStatus="In"  s curStatus="I"
	//S medEduID=$o(^DHCPHME(0,"CurStatus",curStatus,AdmDr,""),-1)
	Q:medEduID="" ""  ;没有记录，返回-999

	S AdmDr=$p(^DHCPHME(medEduID),"^",1)     //病人Adm
    S AdmWard=""
	S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
	S bedid=$p(^PAADM(AdmDr),"^",73)             //床号
	I bedid="" S AdmBed=""
    E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
    S Papmi=$p(^PAADM(AdmDr),"^",1)
    S PatName=$p(^PAPER(Papmi,"ALL"),"^",1)      //姓名
	S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)      //登记号
	S mobPhone=$p(^PAPER(Papmi,"PER",4),"^",21)  //电话
    S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )       //姓别
	S PatSex=$p(^CT("SEX",SexID),"^",2)
	S PatAge=##class(web.DHCSTKUTIL).GetAge(Papmi)  //年龄
	S PatW=##class(web.DHCSTCNTSCOMMON).GetPatWeight(AdmDr)       //体重
	S PatH=##class(web.DHCSTCNTSCOMMON).GetPatHeight(AdmDr)       //身高
	
	S EDCurStatus=$p(^DHCPHME(medEduID),"^",2) //当前状态
	S EDUser=""
	S EDUserDr=$p(^DHCPHME(medEduID),"^",3)    //记录人
	S:EDUserDr'="" EDUser=$p(^SSU("SSUSR",EDUserDr),"^",2)
	S EDDate=$p(^DHCPHME(medEduID),"^",4)      //记录日期
	S:EDDate'="" EDDate=$zd(EDDate,3)
	S EDTime=$p(^DHCPHME(medEduID),"^",5)      //记录时间
	S:EDTime'="" EDTime=$zt(EDTime,2)
	S MEBadHabits=$p(^DHCPHME(medEduID),"^",6)    //不良嗜好
	S MEConDisAndTre=$p(^DHCPHME(medEduID),"^",7) //伴发疾病与用药情况
	S MEGrantFlag=$p(^DHCPHME(medEduID),"^",8)    //发放临床药师联系卡
	S MEGuidObject=$p(^DHCPHME(medEduID),"^",9)   //指导对象
	S MEGuidContent=$p(^DHCPHME(medEduID),"^",10)  //指导意见/内容
	S MEIcd=$p(^DHCPHME(medEduID),"^",11)  	  //诊断描述
	S mobPhone=$p(^DHCPHME(medEduID),"^",12)  //联系方式
	S Address=$p(^DHCPHME(medEduID),"^",13)     //家庭地址
	S PhaPath=$p(^DHCPHME(medEduID),"^",14)     //药师
	S PatPath=$p(^DHCPHME(medEduID),"^",15)     //患者
	
	S medEduGuiConList="" //..getMedEduGuiContent(medEduID)    //用药指导内容
	S n=n+1
	S data=medEduID_"^"_MEGuidObject_"^"_MEGuidContent_"^"_medEduGuiConList_"^"_PhaPath_"^"_PatPath
	S ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEducationByEduID",pid,n)=data
	//Q:n=0 ##class(web.DHCSTJsonCommon).getJsonEmptySign(n) //输出空的json串
	S maxrow=n
	S count=0
	d OutBinStream.Write("[")  //输出json前缀串
	// W ##class(web.DHCSTJsonCommon).getJsonStartSign(n) //输出json前缀串
	S h=""
	F  S h=$o(^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEducationByEduID",pid,h)) Q:h=""  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEducationByEduID",pid,h)
	.S count = count+1
	.S Title="medEduID^GuidObj^GuidCon^EduGuiConList^PhaPath^PatPath"
	.I count=1 D
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	d OutBinStream.Write("]")   //输出json结尾符
	D ..killTmpGlobal(pid)
	//D OutBinStream.OutputToDevice()
	Q OutBinStream
}

/// Descript:   获取指导范围
/// w ##class(web.DHCSTPHCMEDUCATION).getGuiScopePatCode("EDU","I","")
ClassMethod getGuiScopePatCode(ModType As %String, SubModType As %String, PatCode As %String) As %GlobalCharacterStream
{
	s PhgsId="",str="",Num=0 , StPage = 1, EndPage = 999
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	q:((ModType="")||(SubModType="")) str
	f  s PhgsId=$o(^DHCPHGS(0,"ModType",ModType,SubModType,PhgsId))  q:PhgsId=""  d
	.q:PhgsId=0
	.s code="",desc=""
	.s code=$p($g(^DHCPHGS(PhgsId)),"^",1)
	.q:((PatCode="")&&(code[".")) 					//PatCode为空，只查询父节点
	.s firCode=""
	.i code["." s firCode=$p(code,".",1)
	.q:((firCode'=PatCode)&&(PatCode'=""))          //PatCode不为空，只查询子节点
	.s desc=$p($g(^DHCPHGS(PhgsId)),"^",2)
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getGuiScopePatCode",pid,Num)=PhgsId_"^"_desc
	//Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="code^desc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	d OutBinStream.Write("[")  //输出json前缀串
	//w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMEDUCATION","getGuiScopePatCode",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMEDUCATION","getGuiScopePatCode",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
    ..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	d OutBinStream.Write("]")   //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
    //D OutBinStream.OutputToDevice()
    Q OutBinStream
}

/// 病人用药列表信息
/// w ##class(web.DHCSTPHCMEDUCATION).GetPatOEInfo("15","1","644")
ClassMethod GetPatOEInfo(rows As %String, page As %String, AdmDr As %String)
{
	N (rows,page,AdmDr,priCode)
	Q:AdmDr="" "-1"
	S EndPage=page*rows  //结束行
	S StPage=((page-1)*rows)+1 //开始行
	S ord=$o(^OEORD(0,"Adm",AdmDr,""))
	S pid=##class(web.DHCSTPHCMADDINST).GetPID()
	d ..killTmpGlobal(pid)
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	S Num=0
    S chl=0 
    F  S chl=$o(^OEORD(ord,"I",chl)) q:(chl="")||(chl=0)  d
	.S orditm=ord_"||"_chl
	.Q:'$D(^OEORD(ord,"I",chl,1))
	.S priDr=+$p(^OEORD(ord,"I",chl,1),"^",8) 
    .Q:priDr=0 
    .S priorty=$p(^OECPR(priDr),"^",1) //医嘱优先级代码                 
    .S priorty=$p(^OECPR(priDr),"^",2) //医嘱优先级
    .S priorty=$E(priorty,1,2)
    .S StatDr=$p(^OEORD(ord,"I",chl,1),"^",13)
    .S OeFlag=$p(^OEC("OSTAT",StatDr),"^",1) 
	.S FillerNo=$p(^OEORD(ord,"I",chl,9),"^",12) //滚医嘱来源信息 OEORI_FillerNo
    .Q:(FillerNo'="")&(FillerNo'=orditm_"!!"_orditm)&(OeFlag'="D")  //长嘱非首日和截止日期的记录过滤
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)  //医嘱 ARC_ItmMast ARCIM_RowId
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .Q:(ordertype'="R")
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""  //医嘱名称
	.S incidesc=$p(^INCI(inci,1),"^",2)       //药品名称
	.S dosage=$p(^OEORD(ord,"I",chl,2),"^",1) //剂量
	.S dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	.S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)   //剂量单位
	.S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4) //OEORI_PHFreq_DR
    .S freq=$p($g(^PHCFR(freqdr)),"^",3)           //频率
    .S instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
    .S instru=$p($g(^PHCIN(instrudr)),"^",2) //用法
    .s durId=+$p(^OEORD(ord,"I",chl,2),"^",6)
	.S duration=$p($g(^PHCDU(durId)),"^",3) //用药疗程
    .S arcim=$p($g(^INCI(inci,1)),"^",3)
    .q:arcim=""
    .S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
    .s genenicdr=+$p($g(^PHCD(+phcdf,4)),"^",1)
    .s genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) //通用名
    .s formdr=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1),"^",1)
    .s form=$p(^PHCF(formdr),"^",2) //剂型
    .s manf=""
    .s manfdr=$p($g(^PHCD(+phcdf,2)),"^",4) //厂家
    .s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
    .i manf["-" s manf=$p($g(^PHMNF(manfdr)),"-",2)
    .S manf=$E(manf,1,4)
    .s apprdocu=""
    .s itminfo=$o(^DHCITMINFO(0,"INCI",inci,""))
    .i itminfo'="" s apprdocu=$p(^DHCITMINFO(itminfo),"^",10) //批准文号
    .S spec="["_$p(^INCI(inci,3),"^",9)_"]" //规格
    .S EndDate=$p(^OEORD(ord,"I",chl,3),"^",34)     //停止日期
	.S:EndDate'="" EndDate=$zd(EndDate,3)
	.i FillerNo'="" d
	..S orditm=$p(FillerNo,"!!",1)
	.S StartDate=$p(^OEORD(ord,"I",$p(orditm,"||",2),1),"^",9)  //开始日期
	.S:StartDate'="" StartDate=$zd(StartDate,3)
	.S moeori=##class(web.DHCSTCNTSCOMMON).GetMainOeori(orditm) //主医嘱
    .S index=StartDate_"||"_moeori_"||"_orditm
    .i $d(^TMP("DHCST","web.DHCSTPHCMEDUCATION","GetPatOrdItmInfo",pid,index)) d
	..S $p(^TMP("DHCST","web.DHCSTPHCMEDUCATION","GetPatOrdItmInfo",pid,index),"^",21)=EndDate
	..S $p(^TMP("DHCST","web.DHCSTPHCMEDUCATION","GetPatOrdItmInfo",pid,index),"^",22)=OeFlag
	.E  D
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMEDUCATION","GetPatOrdItmInfo",pid,index)=orditm_"^"_phcdf_"^"_incidesc_"^"_dosage_doseuom_"^"_dosuomID_"^"_freqdr_"^"_freq_"^"_instrudr_"^"_instru_"^"_durId_"^"_duration_"^"_genenicdr_"^"_genenic_"^"_formdr_"^"_form_"^"_manfdr_"^"_manf_"^"_apprdocu_"^"_spec_"^"_StartDate_"^"_EndDate_"^"_OeFlag_"^"_priorty

	//Q:Num=0 ##class(web.DHCSTPHCMEDUCATION).getJsonEmptySign(0) //输出空的json串
	
	S Title="orditm^phcdf^incidesc^dosage^dosuomID^freqdr^freq^instrudr^instru^durId^duration^genenicdr^genenic^formdr^form^manfdr^manf^apprdocu^spec^startDate^endDate^OeFlag^priorty"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	d OutBinStream.Write("[")  //输出json前缀串
	//w ##class(web.DHCSTPHCMEDUCATION).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMEDUCATION","GetPatOrdItmInfo",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMEDUCATION","GetPatOrdItmInfo",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	d OutBinStream.Write("]")   //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
    //D OutBinStream.OutputToDevice()
    Q OutBinStream
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	K ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEduDrgItm",pid)
	K ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEduRecord",pid)
	K ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMedEducationByEduID",pid)
	K ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getMeduGuid",pid)
	
	K ^TMP("DHCST","web.DHCSTPHCMEDUCATION","getGuiScopePatCode",pid)
	K ^TMP("DHCST","web.DHCSTPHCMEDUCATION","GetPatOrdItmInfo",pid)
}

}
