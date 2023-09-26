Import SQLUser

/// Creator:    bianshuai
/// CreateDate: 2014-11-27
/// Descript:   药学监护
Class web.DHCSTPHCMPHARCARE Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:药学监护
ClassMethod SavePharCare(phaCareID As %String, phaCareDataList As %String) As %String
{
	n (phaCareID,phaCareDataList)
	s phaCareMasDataList=$p(phaCareDataList,"!!",1)   //药学监护主信息
	s phaCareMonScopeList=$p(phaCareDataList,"!!",2)  //监护范围
	s phaCareMonItemList=$p(phaCareDataList,"!!",3)   //监护项目
	s phaCareDrgItmList=$p(phaCareDataList,"!!",4)    //医嘱信息
	s ret=0
	i phaCareID="" d
	.S ret=..Insert(phaCareMasDataList,phaCareMonScopeList,phaCareMonItemList,phaCareDrgItmList)
	e  d
	.S ret=..Update(phaCareID,phaCareMasDataList,phaCareMonScopeList,phaCareMonItemList,phaCareDrgItmList)
	q ret
}

/// Descript:药学监护
ClassMethod Insert(phaCareMasDataList, phaCareMonScopeList, phaCareMonItemList, phaCareDrgItmList) As %String
{
	N (phaCareMasDataList,phaCareMonScopeList,phaCareMonItemList,phaCareDrgItmList)
	s Err=0

	TS
	//药学监护
	s phaCareID=..InsphaCare(phaCareMasDataList)
	i phaCareID<0 tro
	q:phaCareID<0 phaCareID

	//监护范围
	i phaCareMonScopeList'="" d
	.s Err=..InsphaCareMonScope(phaCareID, phaCareMonScopeList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//监护项目
	i phaCareMonItemList'="" d
	.s Err=..InsphaCareMonItem(phaCareID, phaCareMonItemList)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	//医嘱信息
	i phaCareDrgItmList'="" d
	.s Err=..InsphaCareDrgItm(phaCareID, phaCareDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-12"

	TC
	Q 0
}

/// Descript:药学监护
ClassMethod Update(phaCareID, phaCareMasDataList, phaCareMonScopeList, phaCareMonItemList, phaCareDrgItmList) As %String
{
	N (phaCareID,phaCareMasDataList,phaCareMonScopeList,phaCareMonItemList,phaCareDrgItmList)
	s Err=0

	TS
	//药学监护
	s Err=..UpdphaCare(phaCareID,phaCareMasDataList)
	i Err<0 tro
	q:Err<0 "-10"

	//删除相关子表
	s Err=..DelphaCareRelaTable(phaCareID)
	i Err'=0 tro
	q:Err'=0 Err

	//监护范围
	i phaCareMonScopeList'="" d
	.s Err=..InsphaCareMonScope(phaCareID, phaCareMonScopeList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//监护项目
	i phaCareMonItemList'="" d
	.s Err=..InsphaCareMonItem(phaCareID, phaCareMonItemList)
	i Err'=0 tro
	q:Err'=0 "-12"
	B  ///BBB
	//医嘱信息
	i phaCareDrgItmList'="" d
	.s Err=..InsphaCareDrgItm(phaCareID, phaCareDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-12"

	TC
	Q 0
}

/// Descript:插入查房信息
ClassMethod InsphaCare(phaCareMasDataList As %String) As %String
{
	N (phaCareMasDataList)
	S PHPCMLDR=$p(phaCareMasDataList,"^",1)     //监护级别
	S PHPCAdmDr=$p(phaCareMasDataList,"^",2)    //病人AdmDr
	S PHPCWardDr=$p(phaCareMasDataList,"^",3)   //病区ID
	S PHPCDeptDr=$p(phaCareMasDataList,"^",4)   //科室ID
	S PHPCUserDr=$p(phaCareMasDataList,"^",5)   //记录人
	S PHPCContent=$p(phaCareMasDataList,"^",6)  //监护内容
	S ImpMonItems=$p(phaCareMasDataList,"^",7)  //重要检验检测项目
	S PHPCDate=+$H                              //记录日期
	S PHPCTime=$p($H,",",2)                     //记录时间
	
	&SQL(Insert Into DHC_PHPharCare(PHPC_ML_DR,PHPC_Adm_Dr,PHPC_Ward_Dr,PHPC_Dept_Dr,PHPC_User_Dr,PHPC_Date,PHPC_Time,PHPC_Content,PHPC_ImpMonItems) 
		Values(:PHPCMLDR,:PHPCAdmDr,:PHPCWardDr,:PHPCDeptDr,:PHPCUserDr,:PHPCDate,:PHPCTime,:PHPCContent,:ImpMonItems))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:更新查房信息
ClassMethod UpdphaCare(phaCareID As %String, phaCareMasDataList As %String) As %String
{
	N (phaCareID,phaCareMasDataList)
	S ImpMonContent=$p(phaCareMasDataList,"^",6)  //监护内容
	S ImpMonItems=$p(phaCareMasDataList,"^",7)  //重要检验检测项目
	
	&SQL(Update DHC_PHPharCare Set PHPC_Content=:ImpMonContent, PHPC_ImpMonItems=:ImpMonItems Where PHPC_RowID=:phaCareID) 

	Q SQLCODE
}

/// Descript:监护范围
ClassMethod InsphaCareMonScope(phaCareID As %String, phaCareMonScopeList As %String) As %String
{
	N (phaCareID,phaCareMonScopeList)
	S Len=$L(phaCareMonScopeList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S phaCareMonScope=$p(phaCareMonScopeList,"||",i)
	.S ItemCode=$p(phaCareMonScope,"^",1)    //代码
	.
	.S childSub=$o(^DHCPHPC(phaCareID,"MS",""),-1)+1
	.&SQL(Insert into DHC_PHPCMonScope(PHMS_PHPC_Parref,PHMS_ChildSub,PHMS_MonScope_Dr)
		Values(:phaCareID,:childSub,:ItemCode))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除监护范围
ClassMethod DelphaCareMonScope(phaCareID As %String) As %String
{
	N (phaCareID)
	&SQL(delete from DHC_PHPCMonScope where PHMS_PHPC_Parref=:phaCareID)
	Q SQLCODE
}

/// Descript:监护项目
ClassMethod InsphaCareMonItem(phaCareID As %String, phaCareMonItemList As %String) As %String
{
	N (phaCareID,phaCareMonItemList)
	S Len=$L(phaCareMonItemList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S phaCareMonItem=$p(phaCareMonItemList,"||",i)
	.S ItemCode=$p(phaCareMonItem,"^",1)    //代码
	.S ItemDesc=$p(phaCareMonItem,"^",2)    //值
	.S childSub=$o(^DHCPHPC(phaCareID,"MI",""),-1)+1
	.&SQL(Insert into DHC_PHPCMonItem(PHMI_PHPC_Parref,PHMI_ChildSub,PHMI_MonItm_Dr,PHMI_Desc)
		Values(:phaCareID,:childSub,:ItemCode,:ItemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除监护项目
ClassMethod DelphaCareMonItem(phaCareID As %String) As %String
{
	N (phaCareID)
	&SQL(delete from DHC_PHPCMonItem where PHMI_PHPC_Parref=:phaCareID)
	Q SQLCODE
}

/// Descript:保存关注药品
ClassMethod InsphaCareDrgItm(phaCareID As %String, phaCareDrgItmList As %String) As %String
{
	N (phaCareID,phaCareDrgItmList)
	S Len=$L(phaCareDrgItmList,",")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S phaCareDrgItm=$p(phaCareDrgItmList,",",i)
	.S oeoriDr=$p(phaCareDrgItm,"^",1)        //医嘱ID
	.S childSub=$o(^DHCPHPC(phaCareID,"DI",""),-1)+1
	.&SQL(Insert into DHC_PHPCDrgItm(PHDI_PHPC_Parref,PHDI_ChildSub,PHDI_OEORI_DR)
		Values(:phaCareID,:childSub,:oeoriDr))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除关注药品
ClassMethod DelphaCareDrgItm(phaCareID As %String) As %String
{
	N (phaCareID)
	&SQL(delete from DHC_PHPCDrgItm where PHDI_PHPC_Parref=:phaCareID)
	Q SQLCODE
}

/// Descript: 删除用药教育相关信息表
ClassMethod DelphaCareRelaTable(phaCareID As %String) As %String
{
	n (phaCareID)
	
	//监护范围
	i $d(^DHCPHPC(phaCareID,"MS",1)) d
	.&SQL(delete from DHC_PHPCMonScope where PHMS_PHPC_Parref=:phaCareID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	//监护项目
	i $d(^DHCPHPC(phaCareID,"MI",1)) d
	.&SQL(delete from DHC_PHPCMonItem where PHMI_PHPC_Parref=:phaCareID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	//关注药品
	i $d(^DHCPHPC(phaCareID,"DI",1)) d
	.&SQL(delete from DHC_PHPCDrgItm where PHDI_PHPC_Parref=:phaCareID)
	q:+$g(SQLCODE)'=0 SQLCODE
	
	q 0
}

/// Descript:获取监护信息
ClassMethod getphaCare(AdmDr As %String) As %String
{
	N (AdmDr)
	S phaCareID=$o(^DHCPHPC(0,"AdmDr",AdmDr,""),-1)
	Q:phaCareID=""

	S AdmDr=$p(^DHCPHPC(phaCareID),"^",2)     //病人Adm
    S AdmWard=""
	S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
	S bedid=$p(^PAADM(AdmDr),"^",73)             //床号
	I bedid="" S AdmBed=""
    E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
    S Papmi=$p(^PAADM(AdmDr),"^",1)
    S PatName=$p(^PAPER(Papmi,"ALL"),"^",1)      //姓名
	S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)      //登记号
	S mobPhone=$p(^PAPER(papmi,"PER",4),"^",21)  //电话
    S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )       //姓别
	S PatSex=$p(^CT("SEX",SexID),"^",2)
	S PatAge=##class(web.DHCSTKUTIL).GetAge(Papmi)  //年龄
	S PatW=##class(PHA.COM.Order).PatWeight(AdmDr)       //体重
	S PatH=##class(PHA.COM.Order).PatHeight(AdmDr)       //身高
	
	S PCWardDr=$p(^DHCPHPC(phaCareID),"^",3)    //病区ID
	S:PCWardDr'="" PCWard=$p(^CTLOC(PCWardDr),"^",2)
	S PCDept=""
	S PCDeptDr=$p(^DHCPHPC(phaCareID),"^",4)    //科室ID
	S:PCDeptDr'="" PCDept=$p(^CTLOC(PCDeptDr),"^",2)
	
	S PCUser=""
	S PCUserDr=$p(^DHCPHPC(phaCareID),"^",5)    //记录人
	S:PCUserDr'="" PCUser=$p(^SSU("SSUSR",PCUserDr),"^",2)
	S PCDate=$p(^DHCPHPC(phaCareID),"^",6)      //记录日期
	S:PCDate'="" PCDate=$zd(PCDate,3)
	S PCTime=$p(^DHCPHPC(phaCareID),"^",7)      //记录时间
	S:PCTime'="" PCTime=$zt(PCTime,2)
	S PCContent=$p(^DHCPHPC(phaCareID),"^",8)   //指导内容
	
	S phaCareMasDataList=PatNo_"^"_PatName_"^"_AdmBed_"^"_PatSex_"^"_PatAge_"^"_PatW_"^"_PatH_"^"_mobPhone
	S phaCareMasDataList=phaCareMasDataList_"^"_PCWard_"^"_PCDept_"^"_PCUser_"^"_PCDate_"^"_PCTime_"^"_PCContent
	
	S phaCareMonScopeList=..getphaCareMonScope(phaCareID)    //监护范围
	S phaCareMonItemList=..getphaCareMonScope(phaCareID)    //监护项目
	
	S ret=phaCareMasDataList_"!"_phaCareMonScopeList_"!"_phaCareMonItemList
	
	Q ret
}

/// Descript:监护范围
ClassMethod getphaCareMonScope(phaCareID As %String) As %String
{
	N (phaCareID)
	S CH="",ret=""
	F  S CH=$o(^DHCPHPC(phaCareID,"MS",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHPC(phaCareID,"MS",CH))
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:监护项目
ClassMethod getphaCareMonItem(phaCareID As %String) As %String
{
	N (phaCareID,curStatus)
	S CH="",ret=""
	F  S CH=$o(^DHCPHPC(phaCareID,"MI",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHPC(phaCareID,"MI",CH))
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:关注药品
ClassMethod getphaCareDrgItm(phaCareID As %String) As %String
{
	N (phaCareID,curStatus)
	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	
	S Num=0
	S CH=""
	F  S CH=$o(^DHCPHPC(phaCareID,"DI",CH)) Q:CH=""  D
	.S orditm=$p(^DHCPHPC(phaCareID,"DI",CH),"^",1)  //医嘱ID
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
	.S doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm) //医生
	.S StartDate=+$p(^OEORD(ord,"I",chl,1),"^",9)   //开始日期
	.S:StartDate'="" StartDate=$zd(StartDate,3)
	.S Num=Num+1
	.S index=StartDate_"||"_orditm
	.S ^TMP("DHCST","web.DHCSTPHCMPHARCARE","getphaCareDrgItm",pid,index)=orditm_"^"_StartDate_"^"_inciDesc_"^"_dosage_doseuom_"^"_freq_"^"_instru_"^"_duration_"^"_doctor

	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	S Title="orditm^StartDate^MedName^Dosage^freq^Instance^duration^Doctor"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPHARCARE","getphaCareDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMPHARCARE","getphaCareDrgItm",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..w ##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	.e  d
	..w ","_##class(web.DHCSTPHCMCOMMON).getJsonData(Title,mdata)
	
	w ##class(web.DHCSTPHCMCOMMON).getJsonEndSign() //输出json结尾符
	d ..killTmpGlobal(pid)
	q ""
}

/// Descript:药学监护
ClassMethod saveMedMonInfo(phaCareID As %String, phaCareDataList As %String) As %String
{
	n (phaCareID,phaCareDataList)
	s phaCareMasDataList=$p(phaCareDataList,"!!",1)   //药学监护主信息
	s phaCareMonScopeList=$p(phaCareDataList,"!!",2)  //监护范围
	s phaCareMonItemList=$p(phaCareDataList,"!!",3)   //监护项目
	s phaCareDrgItmList=$p(phaCareDataList,"!!",4)    //医嘱信息
	s ret=0
	i phaCareID="" d
	.S ret=..Insert(phaCareMasDataList,phaCareMonScopeList,phaCareMonItemList,phaCareDrgItmList)
	e  d
	.S ret=..Update(phaCareID,phaCareMasDataList,phaCareMonScopeList,phaCareMonItemList,phaCareDrgItmList)
	s ret=##class(web.DHCSTPHCMCOMMON).getJsonData("ErrCode",ret)
	q "["_ret_"]"
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMPHARCARE","getphaCareDrgItm",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMphaCareCATION"))
}

}
