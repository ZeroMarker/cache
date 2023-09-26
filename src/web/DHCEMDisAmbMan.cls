Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2018-10-29
/// Descript: 	急诊科救护车派车管理
Class web.DHCEMDisAmbMan Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descritp:  插入急诊派车信息
/// Input:     mListData-登记内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMDisAmbMan).Insert("14","")
ClassMethod Insert(MaID As %String, mListData As %String) As %String
{
	n (MaID, mListData)
	i MaID="" D
	.s MaID=..InsDisMan(mListData)
	E  D
	.s MaID=..UpdDisMan(MaID, mListData)
	Q MaID
}

/// Descritp:  插入派车信息
/// Input:     mListData-派车内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMDisAmbMan).InsDisMan("")
ClassMethod InsDisMan(mListData As %String) As %String
{
	N (mListData)
	s SCDoc=$p(mListData,"^",7)
	s SCNur=$p(mListData,"^",8)
	s SCDri=$p(mListData,"^",9)
	s SCDocType="医生"
	s SCNurType="护士"
	s SCDriType="司机"
	s SCDriDesc=SCDri
	s Err=0
	TS

	/// 插入派车主表
	s MaID=..InsDisManMas(mListData)
	i MaID<0 tro
	Q:MaID<0 MaID
	i SCDoc'="" d
	.s MaNewID1=..InsEmAccPer(MaID,SCDoc,"",SCDocType)
	i SCNur'="" d
	.s MaNewID1=..InsEmAccPer(MaID,SCNur,"",SCNurType)
	i SCDoc'="" d
	.s MaNewID1=..InsEmAccPer(MaID,"",SCDriDesc,SCDriType)
	TC
	Q MaID
}

/// Descritp:  修改派车信息
/// Input:     mListData-派车内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCEMDisAmbMan).UpdDisMan("")
ClassMethod UpdDisMan(MaID As %String, mListData As %String) As %String
{
	N (MaID, mListData)
	s SCDoc=$p(mListData,"^",7)
	s SCNur=$p(mListData,"^",8)
	s SCDri=$p(mListData,"^",9)
	s MaIDx=MaID
	s Err=0
	TS

	/// 修改派车主表
	s MaID=..UpdDisManMas(MaID,mListData)
	i MaID<0 tro
	Q:MaID<0 MaID
	i SCDoc'="" d
	.s MaNewID1=..UpdEmAccPer(MaID,SCDoc,"","医生")
	i SCNur'="" d
	.s MaNewID1=..UpdEmAccPer(MaID,SCNur,"","护士")
	i SCDoc'="" d
	.s MaNewID1=..UpdEmAccPer(MaID,"",SCDri,"司机")
	TC
	Q MaID
}

/// Descritp:  插入登记主表
ClassMethod InsDisManMas(mListData As %String) As %String
{
	n (mListData)
	s EpisodeID=$p(mListData,"^",1)   ///EpisodeID
	s RUserID=$p(mListData,"^",2)     ///申请医生
	s RLocID=$p(mListData,"^",3)      ///申请科室
	s OutFlag=$p(mListData,"^",4)     ///院内院外
	s Notes=$p(mListData,"^",5)       ///备注
	s VisID=$p(mListData,"^",6)
	s RDate=+$H   		              ///申请日期
	s RTime=$p($H,",",2)              ///申请时间
	&SQL(Insert Into DHC_EmDisAmbMan(ED_Adm_Dr,ED_RLoc_Dr,ED_RDate,ED_RTime,ED_RUser_Dr,ED_OutFlag,ED_Note,ED_PHV_Dr)
		values(:EpisodeID,:RLocID,:RDate,:RTime,:RUserID,:OutFlag,:Notes,:VisID))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descritp:  修改登记主表
ClassMethod UpdDisManMas(MaID As %String, mListData As %String) As %String
{
	n (MaID, mListData)
	s OutFlag=$p(mListData,"^",4)     ///院内院外
	s Notes=$p(mListData,"^",5)       ///备注
	&SQL(Update DHC_EmDisAmbMan Set ED_OutFlag=:OutFlag,ED_Note=:Notes Where ED_RowID=:MaID)
	Q MaID
}

/// 插入随车人员表
ClassMethod InsEmAccPer(MaID As %String, User As %String, Desc As %String, Type As %String) As %String
{
	n (MaID,User,Desc,Type)
	i User'="" d
	.&SQL(Insert Into DHC_EmAccPerson(EM_ParRef_Dr,EM_User_Dr,EM_Type)values(:MaID,:User,:Type))
	e  d
	.&SQL(Insert Into DHC_EmAccPerson(EM_ParRef_Dr,EM_User,EM_Type)values(:MaID,:Desc,:Type))
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// 修改随车人员表
ClassMethod UpdEmAccPer(MaID As %String, User As %String, Desc As %String, Type As %String) As %String
{
	n (MaID,User,Desc,Type)
	i User'="" d
	.&SQL(Update DHC_EmAccPerson SET EM_User_Dr=:User Where EM_ParRef_Dr=:MaID AND EM_Type=:Type)
	e  d
	.&SQL(Update DHC_EmAccPerson SET EM_User=:Desc Where EM_ParRef_Dr=:MaID AND EM_Type=:Type)
	i SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript: 删除急诊救护车派车管理数据
/// w ##Class(web.DHCEMWaitToHosPat).delDisAmbMan("24")
ClassMethod DelDisAmbMan(ID As %String) As %String
{
	n (ID)
	&SQL(delete from DHC_EmDisAmbMan where ED_RowID=:ID)
	Q SQLCODE
}

/// Descript:  取急诊救护车派车管理数据
/// W ##Class(web.DHCEMDisAmbMan).GetDisAmbManInfo("22")
ClassMethod GetDisAmbManInfo(MaID As %String) As %String
{
	n (MaID)
	Q:'$D(^DHCEMDAM(MaID)) ""
	s EpisodeID=$p(^DHCEMDAM(MaID),"^",1)   /// 就诊ID	
	//s ListData=##Class(web.DHCEMWaitToHosPat).GetPatEssInfo("",EpisodeID)
	s MtType=$p(^DHCEMDAM(MaID),"^",6)      /// 类型
	s MtNotes=$p(^DHCEMDAM(MaID),"^",7)     /// 备注
	s SCDoc="",SCNur="",SCDri="" //医生 护士 司机
	s SSDocUser="",UserDocID="",SSNurUser="",UserNurID=""
	s SCDocdr=$o(^DHCEMACCPi(0,"ParType",MaID,"医生",""))
	i SCDocdr'="" d
	.s SSDocUser=$p($g(^DHCEMACCP(SCDocdr)),"^",3)
	.s SCDoc=SSDocUser
	s SCNurdr=$o(^DHCEMACCPi(0,"ParType",MaID,"护士",""))
	i SCNurdr'="" d
	.s SCNur=$p($g(^DHCEMACCP(SCNurdr)),"^",3)
	
	s SCDridr=$o(^DHCEMACCPi(0,"ParType",MaID,"司机",""))
	i SCDridr'="" d
	.s SCDri=$p($g(^DHCEMACCP(SCDridr)),"^",2)
	s ListData=EpisodeID_"^"_MaID_"^"_MtType_"^"_MtNotes_"^"_SCDoc_"^"_SCNur_"^"_SCDri
	s ListTitle="EposodeID^MaID^MtType^MtNotes^SCDoc^ScNur^SCDri"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript: 取急诊救护车派车管理数据
/// w ##Class(web.DHCEMDisAmbMan).JsGetDisManMasList("10","1","2019-05-01^2019-06-01")
ClassMethod JsGetDisManMasList(rows As %String, page As %String, Params As %String) As %String
{
	n (rows,page,Params)

	s End = page*rows
	s Start=(page-1)*rows+1
	
	s StartDate=$p(Params,"^",1) /// 开始日期
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-1
    s EndDate=$p(Params,"^",2)   /// 结束日期
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s argLocID=$p(Params,"^",3)  /// 登记科室
	s aPatName=$p(Params,"^",4)  /// 病人姓名
	s mMtType=$p(Params,"^",5)   /// 类型
	s aPatNo=$p(Params,"^",6)    /// 登记号
	
    s Num=0
	F dd=StartDate:1:EndDate D
	.s MaID=""
	.F  s MaID=$o(^DHCEMDAM(0,"CreateDate",dd,MaID)) Q:MaID=""  D
	..s EpisodeID=$p(^DHCEMDAM(MaID),"^",1)        /// 就诊ID
	..q:EpisodeID=""
	../// 病人信息
	..s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..Q:(aPatName'="")&(PatName'[aPatName)
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..Q:(aPatNo'="")&(aPatNo'=PatNo)
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID)
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	..Q:(argLocID'="")&(argLocID'=PatLocID)
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s PatWard=""
	..s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	           /// 病区ID
	..s:PatWardID'="" PatWard=$p($g(^PAWARD(PatWardID)),"^",2) /// 病区描述
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
    ..s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
    ..s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	 /// 电话 
	..s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	 /// 家庭住址
	..s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	..i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	..s MedicareNo=##Class(web.DHCEMCommonUtil).GetMrNo(EpisodeID) /// 病案号
	..s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)       /// 诊断
	..s RLocID=$p(^DHCEMDAM(MaID),"^",2)     /// 申请科室
	..Q:(argLocID'="")&(argLocID'=RLocID)
	..s RLocDesc=""
	..s:RLocID'="" RLocDesc=$p(^CTLOC(RLocID),"^",2)
	..s RDate=$p(^DHCEMDAM(MaID),"^",3)    /// 登记日期
	..s:RDate'="" RDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(RDate)
	..s RTime=$p(^DHCEMDAM(MaID),"^",4)    /// 登记时间
	..s:RTime'="" RTime=$zt(RTime,1)
	..s UserID=$p(^DHCEMDAM(MaID),"^",5)   /// 登记人
	..s RUser=$p($g(^SSU("SSUSR",UserID)),"^",2)
	..s MtType=$p(^DHCEMDAM(MaID),"^",6)   /// 类型
	..Q:(mMtType'="")&(mMtType'=MtType)
	..s MtType=$s(MtType="Y":"院外",MtType="N":"院内",1:"")
	..s MtNotes=$p(^DHCEMDAM(MaID),"^",7)  /// 备注
	..s Num=Num+1
	..s ListData=MaID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	..s ListData=ListData_"^"_RLocDesc_"^"_BillType_"^"_MedicareNo_"^"_PatDiag_"^"_RDate_"^"_RTime_"^"_RUser_"^"_MtType_"^"_MtNotes
	..s TMPListData(Num)=ListData
	..
	
	i Num=0 w ##class(web.DHCAPPJsonCommon).getJsonEmptySign(Num) //输出json结尾符
	Q:Num=0 ""
	
	///转换数据为Json格式
	s ListTitle="MaID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatLoc^PatWard^PatBed^PatTelH^PatBod^PatAddr^RLocDesc^BillType^MedicareNo^PatDiag^RDate^RTime^RUser^MtType^MtNotes"

	W ##class(web.DHCAPPJsonCommon).getJsonStartSign(Num) //输出json前缀串
	s index="",count=0
	F  s index=$o(TMPListData(index),-1) Q:index=""  D
	.s ListData=$g(TMPListData(index))
	.Q:ListData=""
	.s count = count+1
	.Q:(count<Start)||(count>End)
	.i count=Start D
	..W ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	.E  D
	..W ","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	W "]}"
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-10-29
/// Descript:     急诊救护车派车单报表
/// InPut:        StartDate - 开始日期, EndDate - 结束日期, mMtType - 类型
/// OutPut:       序号_"^"_病人登记号_"^"_病人姓名_"^"_派车日期_"^"_类型_"^"_备注
/// D ##Class(%ResultSet).RunQuery("web.DHCEMDisAmbMan","QryDisAmbManStat","2018-01-01","2018-12-31","")
Query QryDisAmbManStat(StartDate As %String, EndDate As %String, mMtType As %String) As %Query(ROWSPEC = "Num:%String,PatNo:%String,PatName:%String,MtDate:%String,MtType:%String,MtNotes:%String") [ SqlProc ]
{
}

ClassMethod QryDisAmbManStatExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, mMtType As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	Q:StartDate="" $$$OK
	Q:EndDate="" $$$OK
    k TmpCstArr
    
    /// 检查申请列表
	D ..GetDisAmbManStat(StartDate, EndDate, mMtType, .TmpCstArr)
	
    s index=""
	F  s index=$o(TmpCstArr(index))  Q:index=""  D
	.s ListData=$g(TmpCstArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(index_"^"_ListData,"^")	
	.s ind=ind+1
	.

	k TmpCstArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QryDisAmbManStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDisAmbManStatExecute ]
{
	 Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

ClassMethod QryDisAmbManStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDisAmbManStatExecute ]
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

/// Creator:      bianshuai
/// CreateDate:   2018-10-29
/// Descript:     急诊救护车派车单报表
/// InPut:        StartDate -开始日期, EndDate - 结束日期, mMtType - 类型
/// OutPut:       病人登记号_"^"_病人姓名_"^"_派车日期_"^"_类型_"^"_备注
/// D ##Class(web.DHCEMDisAmbMan).GetDisAmbManStat("2018-01-01","2018-12-31",.TmpCstArr)
ClassMethod GetDisAmbManStat(StartDate As %String, EndDate As %String, mMtType As %String, TmpCstArr As %String) As %String
{
	n (StartDate, EndDate, mMtType, TmpCstArr)
	s StartDate=$zdh(StartDate,3),EndDate=$zdh(EndDate,3)
    s Num=0
	F dd=StartDate:1:EndDate D
	.s MaID=""
	.F  s MaID=$o(^DHCEMDAM(0,"CreateDate",dd,MaID)) Q:MaID=""  D
	..s EpisodeID=$p(^DHCEMDAM(MaID),"^",1)        	/// 就诊ID
	../// 病人信息
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)    	/// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) 	/// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) 	/// 登记号
	..s MtType=$p(^DHCEMDAM(MaID),"^",6)   			/// 类型
	..Q:(mMtType'="")&(mMtType'=MtType)
	..s MtType=$s(MtType="Y":"院外",MtType="N":"院内",1:"")
	..s MtNotes=$p(^DHCEMDAM(MaID),"^",7)  			/// 备注
	..s Num=Num+1
	..s TmpCstArr(Num)=PatNo_"^"_PatName_"^"_$zd(dd,3)_"^"_MtType_"^"_MtNotes
	.
	Q ""
}

/// Creator:      yangyongtao
/// CreateDate:   2019-05-25
/// Descript:     当前病人是否存在申请记录
/// InPut:        EpisodeID -就诊ID
/// OutPut:       0:否 ,1：是
/// w ##Class(web.DHCEMDisAmbMan).isExistDisAmbMan("70000024")
ClassMethod isExistDisAmbMan(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:+EpisodeID=0 0
	s MaID="", isFlag=0,RTime="" 
	F  s MaID=$o(^DHCEMDAM(0,"ADM",EpisodeID,MaID)) Q:(MaID="")||(isFlag=1)  D
	.s RDate=$p(^DHCEMDAM(MaID),"^",3)    /// 登记日期
	.i RDate=+$h  s isFlag=1
 	Q isFlag
}

/// Descript:  获取病人基本就诊信息
/// W ##Class(web.DHCEMDisAmbMan).GetPatBaseInfo("0000000293")
ClassMethod GetPatBaseInfo(PatientNo As %String, LgHospID = "") As %String
{
	n (PatientNo,LgHospID,%session)
	s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,""))
	i PatientID="" w ##Class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg","-1^登记号有误")
	Q:PatientID="" ""
	s EpisodeID="",TEpisodeID=""
	F  s EpisodeID=$O(^PAPERdr(PatientID,"ADM","E",EpisodeID),-1) Q:(EpisodeID="")||(TEpisodeID)  D
	.;Q:$p(^PAADM(EpisodeID),"^",70)=""	   /// 病区ID
	.s TEpisodeID=EpisodeID
	i TEpisodeID="" w ##Class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg","-2^病人非急诊病人")   //yyt 2019-06-01
	Q:TEpisodeID="" ""
	s PatLocID=$p($g(^PAADM(+TEpisodeID)),"^",4) // 就诊科室
	s CurHospID=$p($g(^CTLOC(+PatLocID)),"^",22)
	q:(LgHospID'="")&&(CurHospID'=LgHospID) ##Class(web.DHCAPPJsonCommon).getJsonData("ErrCode^ErrMsg","-3^病人当前就诊非本院区！")
	
	s ListData=..GetPatEssInfo(PatientID,TEpisodeID)
	s ListTitle="PatientID^EpisodeID^PatNo^PatName^PatSex^PatAge^PatBDay^PatDiags^PatType^PatSLv^PatLv^mradm^PatBed^BillType^LvDate^LvTime^AdmDays^PatDoc"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript:  获取病人基本就诊信息
/// W ##Class(web.DHCEMDisAmbMan).GetPatEssInfo("","2")
ClassMethod GetPatEssInfo(PatientID As %String, EpisodeID As %String) As %String
{
	n (PatientID, EpisodeID,%session)
	i PatientID="" s PatientID=$p(^PAADM(EpisodeID),"^",1)
	
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatBDay=$p(^PAPER(PatientID,"ALL"),"^",6)  /// 出生日期
	i PatBDay'="" s PatBDay=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(PatBDay)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) //hxy 2022-10-14
	s PatDiag=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID) /// 诊断
	i $L(PatDiag)>80 s PatDiag=$E(PatDiag,1,80)_"..."
	s PatType=$p(^PAADM(EpisodeID),"^",2) 	           /// 就诊类型
	s EncryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatientID,"")
 	s EncryptLevel=$p(EncryptLevelInfo,"^",1)
 	s PatLevel=$p(EncryptLevelInfo,"^",2)
 	s mradm=$p(^PAADM(EpisodeID),"^",61)          	   /// 就诊类型
	s PatBed=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(EpisodeID) /// 床号
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)    /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s PatDoc=""
	s AdmDocID=$p(^PAADM(EpisodeID),"^",9)             /// 医生
	s:AdmDocID'="" PatDoc=$p($g(^CTPCP(AdmDocID,1)),"^",2)
	s EmPLvDate="",EmPLvTime="",AdmDays=""
	s EmPCLvID=$o(^DHCEMPCA(0,"AdmChkLev",+EpisodeID,""),-1) /// 分诊ID
	i EmPCLvID'="" D
	.s LvDate=$p(^DHCEMPCL(EmPCLvID),"^",4)   /// 分诊日期
	.s AdmDays=+$H-LvDate_"天"                /// 来诊天数
	.i LvDate'="" s LvDate=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(LvDate)
	.s LvTime=$p(^DHCEMPCL(EmPCLvID),"^",5)   /// 分诊时间
	.s:LvTime'="" LvTime=$zt(LvTime,2)
	.s:PatSex'="" PatSex=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex) //hxy 2022-12-07
	.
	s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_$g(PatSex)_"^"_PatAge_"^"_PatBDay_"^"_PatDiag_"^"_PatType_"^"_EncryptLevel_"^"_PatLevel_"^"_mradm_"^"_PatBed_"^"_BillType
	s ListData=ListData_"^"_$g(LvDate)_"^"_$g(LvTime)_"^"_$g(AdmDays)_"^"_PatDoc
	q ListData
}

/// Creator:      yangyongtao
/// CreateDate:   2019-06-04
/// Descript:     急诊救护车派车单打印
/// InPut:        MaID
/// w ##Class(web.DHCEMDisAmbMan).PrintDisAmbMan("17")
ClassMethod PrintDisAmbMan(MaID As %String)
{
	n (MaID)
	s EpisodeID=$p(^DHCEMDAM(MaID),"^",1)        /// 就诊ID
	q:EpisodeID=""
	/// 病人信息
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,EpisodeID) ///年龄
	s MtNotes=$p(^DHCEMDAM(MaID),"^",7)  /// 备注
	s ListData=PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_MtNotes
	s ListTitle="PatNo^PatName^PatSex^PatAge^MtNotes"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descritp:	获取医生或者护士
/// w ##Class(web.DHCEMDisAmbMan).JsonCareProv("Nurse","NUR")
ClassMethod JsonCareProv(q = "", ProvType As %String, LgHospID = "") As %String
{
	n (q,ProvType,LgHospID,%session)
	
	s count=0
	s ProvType=$zcvt(ProvType,"U")
	s ProvType=$s(ProvType["NUR":"NURSE",1:"DOCTOR")
	w "["
	s ProvTypeID=""
	F  s ProvTypeID=$o(^CT("CPT",ProvTypeID)) Q:ProvTypeID=""  D
	.;s ShowFlag=##class(web.DHCEMCommonUtil).GetHospShowDataFlag("CT_CareProv",ProvTypeID,LgHospID) //hxy 2020-06-01 注释
	.;q:ShowFlag'="Y" //hxy 2020-06-01 注释
	.Q:$p(^CT("CPT",ProvTypeID),"^",3)'="Y"
	.Q:$p(^CT("CPT",ProvTypeID),"^",4)'=ProvType //"DOCTOR"
	.s CareProvID=""
	.F  s CareProvID=$o(^CTPCP(0,"CareProvType",ProvTypeID,CareProvID)) Q:CareProvID=""  D 
	..s UserID=$o(^SSU("SSUSR",0,"CTPCP",CareProvID,""))
	..Q:UserID=""
	..s ShowFlag=##class(web.DHCEMCommonUtil).GetHospShowDataFlag("SS_User",UserID,LgHospID) //hxy 2020-06-01 st
	..q:ShowFlag'="Y" //ed
	..s CTPCPCTId = $p(^CTPCP(CareProvID,1),"^",4)
	..Q:$p(^CTPCP(CareProvID,1),"^",9)'="Y"
	..s UserName=$p(^CTPCP(CareProvID,1),"^",2)
	..s UserName=##class(web.DHCEMCommonUtil).GetTransDesc("User.CTCareProv","CTPCPDesc","",UserName) //hxy 2022-12-07
	..Q:UserName'[q
	..s tmp=CareProvID_"^"_UserName
	..s count = count+1
	..I count=1 d
	...W ##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	..e  d
	...W ","_##class(web.DHCAPPJsonCommon).getJsonData("value^text",tmp)
	w "]"
	q ""
}

}
