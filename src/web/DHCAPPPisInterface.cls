Import SQLUser

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    新产品研发组病理申请对外接口公共类
Class web.DHCAPPPisInterface Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:    bianshuai
/// CreateDate: 2017-11-03
/// Descript:   取病理申请对应表单内容
/// InPut:      PisID-申请单ID
/// OutPut:     空
/// w ##Class(web.DHCAPPPisInterface).GetPisReqContent("12")
ClassMethod GetPisReqContent(PisID As %String) As %String
{
	n (PisID)
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)		/// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s PatWard=""
	s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	/// 病区ID
	s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	s CreatDate=$p(^DHCAPPPM(PisID),"^",6)		/// 申请日期
	s:CreatDate'="" CreatDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(CreatDate) 
	s CreatTime=$p(^DHCAPPPM(PisID),"^",7)		/// 申请时间
	s:CreatTime'="" CreatTime=..%ZT(CreatTime,2)
	s UserID=$p(^DHCAPPPM(PisID),"^",5)	        /// 申请人
	s UserName=$p(^SSU("SSUSR",UserID),"^",2)
	s ReqLoc=""
	s ReqLocID=$p(^DHCAPPPM(PisID),"^",8)	    /// 申请科室
	s:ReqLocID'="" ReqLoc=$p(^CTLOC(ReqLocID),"^",2)
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s BedId=$p(^PAADM(EpisodeID),"^",73) 				/// 床号ID
    S PatBed=""
    s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)          /// 出生日期
	i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ErrMsg=""
	s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,AdmType,.ErrMsg) ;病历号
	s PisReqNo=$p(^DHCAPPPM(PisID),"^",4)		 		/// 申请单号

	s ListData=PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr_"^"_ReqLoc_"^"_BillType_"^"_MedicareNo_"^"_UserID_"^"_UserName_"^"_CreatDate_"^"_CreatTime_"^"_EpisodeID_"^"_PisReqNo
	Q ListData
}

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    取病理申请相关医嘱串
/// w ##Class(web.DHCAPPPisInterface).GetPisItem("")
ClassMethod GetPisItem(PisID As %String, mOeori As %String) As %String
{
	n (PisID, mOeori)
	s ListData=""
	s CH=""
	f  s CH=$o(^DHCAPPPM(PisID,"A",CH)) Q:CH=""  D
	.s itmID=PisID_"||"_CH
	.s arcimid=$p(^DHCAPPPM(PisID,"A",CH),"^",1)  /// 医嘱项ID ->医嘱项CODE
	.s oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",2)    /// 医嘱ID
	.Q:mOeori'=oeori
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
	.i ListData'="" s ListData=ListData_"@"_arcimid_"#"_oeori_"#"_arcitmdesc
	.E  s ListData=arcimid_"#"_oeori_"#"_arcitmdesc
	Q ListData
}

/// Creator:    bianshuai
/// CreateDate: 2017-11-02
/// Descript:   提取病理申请内容串给Pis系统
/// InPut:      ID-病理申请ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCAPPPisInterface).ToPisSystem("6||56")
ClassMethod ToPisSystem(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" ""
	s ID=$o(^DHCAPPPM(0,"OrdItem",Oeori,"")) /// 申请单ID
	Q:ID="" ""
	Q:$p(^DHCAPPPM(ID),"^",9)="D" "-101"     /// 申请单已取消
	s PisReqNoXml=..GetPisReqNoXml(ID,Oeori) /// 申请单内容XML串
	Q PisReqNoXml
}

/// Descript:   提取细胞学申请单内容
/// w ##Class(web.DHCAPPPisInterface).GetPisReqNoXml("13")
ClassMethod GetPisReqNoXml(PisID As %String, Oeori As %String) As %String
{
	n (PisID, Oeori)
	/// 病人信息
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)		/// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",1)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s PatWard=""
	s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	/// 病区ID
	s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	s CreatDate=$p(^DHCAPPPM(PisID),"^",6)		/// 申请日期
	s:CreatDate'="" CreatDate=$zd(CreatDate,3)
	//s:CreatDate'="" CreatDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(CreatDate) 
	s CreatTime=$p(^DHCAPPPM(PisID),"^",7)		/// 申请时间
	s:CreatTime'="" CreatTime=..%ZT(CreatTime,2)
	s UserID=$p(^DHCAPPPM(PisID),"^",5)	        /// 申请人
	s UserName=$p(^SSU("SSUSR",UserID),"^",2)
	s ReqLoc=""
	s ReqLocID=$p(^DHCAPPPM(PisID),"^",8)	    /// 申请科室
	s:ReqLocID'="" ReqLoc=$p(^CTLOC(ReqLocID),"^",2)
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s BedId=$p(^PAADM(EpisodeID),"^",73) 				/// 床号ID
    S PatBed=""
    s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)          /// 出生日期
	s:PatBod'="" PatBod=$zd(PatBod,3)
	//i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ErrMsg=""
	s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,AdmType,.ErrMsg) ;病历号
	s PisReqNo=$p(^DHCAPPPM(PisID),"^",4)		 		/// 申请单号
	;s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	s PatDiagDesc=""
	/// 申请单内容
	s FrostFlag=$p(^DHCAPPPM(PisID),"^",2)   /// 冰冻标志
	s EmgFlag=$p(^DHCAPPPM(PisID),"^",3)     /// 加急标志
	s PisNo=$p(^DHCAPPPM(PisID),"^",13)      /// 病理号
	s MedRecord=$p(^DHCAPPPM(PisID),"^",14)  /// 临床病历
	s MedDiag=$p(^DHCAPPPM(PisID),"^",15)    /// 临床诊断
	s HepatitisB=$p(^DHCAPPPM(PisID),"^",16) /// 乙肝病史
	s OperRes=$p(^DHCAPPPM(PisID),"^",17)    /// 手术所见
	s InfDisHis=$p(^DHCAPPPM(PisID),"^",18)  /// 传染病史
	s FoundDate=$p(^DHCAPPPM(PisID),"^",19)  /// 首次发现人乳头瘤病毒时间
	s:FoundDate'="" FoundDate=$zd(FoundDate,3)
	s PisType=$p(^DHCAPPPM(PisID),"^",20)    /// 申请单类型
	s PisStatus=$p(^DHCAPPPM(PisID),"^",9)   /// 申请单状态
	s PisArcList=##Class(web.DHCAppPisMaster).GetPisArc(PisID)     /// 病理申请医嘱项目内容
	s PisArcList=$REPLACE(PisArcList,"^","#")
	//s ItemDesc=$p(PisArcList,"^"),LocID=$p(PisArcList,"^",2),LocDesc=$p(PisArcList,"^",3)

	s PisAutoPsy=##Class(web.DHCAppPisMaster).GetPisAutoPsy(PisID) /// 病理申请尸检信息内容
	s MorToDeaPro=$p(PisAutoPsy,"^"),DisAndTrePro=$p(PisAutoPsy,"^",2),PhyAndLabTest=$p(PisAutoPsy,"^",3),FinTakRes=$p(PisAutoPsy,"^",4)

	s PisConsult=##Class(web.DHCAppPisMaster).GetPisConsult(PisID) /// 病理申请会诊信息内容
	s InsDoc=$p(PisConsult,"^"),InsHosp=$p(PisConsult,"^",2),SpecExaRes=$p(PisConsult,"^",3),ConsNote=$p(PisConsult,"^",4),ConsStaff=$p(PisConsult,"^",5)

	s PisGynWon=##Class(web.DHCAppPisMaster).GetPisGynWon(PisID)   /// 病理申请妇科信息内容
	s PisGynWon=$REPLACE(PisGynWon,"^",",")
	s LastMensDate=$p(PisGynWon,","),MensDate=$p(PisGynWon,",",2)
	s:LastMensDate'="" $p(PisGynWon,",")=..TrsToFormat(LastMensDate)  /// 格式化上次月经日期
	s:MensDate'="" $p(PisGynWon,",",2)=..TrsToFormat(MensDate)		  /// 格式化末次月经日期
	//s LastMensDate=$p(PisGynWon,"^"),MensDate=$p(PisGynWon,"^",2),PreTimes=$p(PisGynWon,"^",3),LyTimes=$p(PisGynWon,"^",4),PauFlag=$p(PisGynWon,"^",5)

	s PisCutBas=##Class(web.DHCAppPisMaster).GetPisCutBas(PisID)   /// 病理申请取材信息内容
	s SepDate=$p(PisCutBas,"^"),SepTime=$p(PisCutBas,"^",2),FixDate=$p(PisCutBas,"^",3),FixTime=$p(PisCutBas,"^",4),BLocDesc=$p(PisCutBas,"^",5)	
	s DocName=$p(PisCutBas,"^",6),Position=$p(PisCutBas,"^",7),Type=$p(PisCutBas,"^",8)
	s:SepDate'="" SepDate=..TrsToFormat(SepDate)  /// 格式化取材日期
	s:FixDate'="" FixDate=..TrsToFormat(FixDate)  /// 格式化固定日期
	
	s PisTumour=##Class(web.DHCAppPisMaster).GetPisTumour(PisID)   /// 病理申请肿瘤信息内容
	s PisTumour=$REPLACE(PisTumour,"^",",")
	s TFoundDate=$p(PisTumour,",")
	s:TFoundDate'="" $p(PisTumour,",")=..TrsToFormat(TFoundDate)
	//s TFoundDate=$p(PisTumour,"^"),TumPart=$p(PisTumour,"^",2),TumSize=$p(PisTumour,"^",3),TransFlag=$p(PisTumour,"^",4),TransPos=$p(PisTumour,"^",5)	
	//s RadCureFlag=$p(PisTumour,"^",6),CheCureFlag=$p(PisTumour,"^",7),Remark=$p(PisTumour,"^",8)

	s PisReqSpec=##Class(web.DHCAPPPisInterface).GetPisReqSpec(PisID)     /// 病理标本
	s PisTreMet=##Class(web.DHCAPPPisInterface).GetPisTreMet(PisID)       /// 治疗方式
	s PisTesItmMet=##Class(web.DHCAPPPisInterface).GetPisTesItmMet(PisID) /// 检测方法
	s PisTesDiag=##Class(web.DHCAPPPisInterface).GetPisTesDiag(PisID)     /// 临床诊断
	s PisPatRec=##Class(web.DHCAPPPisInterface).GetPisPatRec(PisID)       /// 病人病历
	s PisPatInfDis=##Class(web.DHCAPPPisInterface).GetPisPatInfDis(PisID) /// 传染病史
	i PisTesDiag="" s PisTesDiag=MedDiag
	i PisTesDiag="" s PisTesDiag=PatDiagDesc
	
	s mListData=PatNo_"^"_PatName_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_PatTelH_"^"_PatBod_"^"_PatAddr
	s mListData=mListData_"^"_ReqLoc_"^"_BillType_"^"_MedicareNo_"^"_PisReqNo_"^^^"_UserName_"^"_CreatDate_"^"_CreatTime
	s mListData=mListData_"^"_EpisodeID_"^"_PisReqNo_"^"_OperRes_"^"_PisTumour_"^"_PisGynWon_"^"_MedRecord_"^"_EmgFlag_"^"_FrostFlag
	s mListData=mListData_"^"_SepDate_" "_SepTime_"^"_FixDate_" "_FixTime_"^"_BLocDesc_"^"_DocName_"^"_SepDate_"^"_PisPatInfDis_"^"_PisPatRec
	s mListData=mListData_"^"_FoundDate_"^"_PisTesItmMet_"^"_PisTesDiag_"^"_PisTreMet_"^"_SpecExaRes_"^"_ConsNote_"^"_ConsStaff_"^"_Position_"^"_Type
	s mListData=mListData_"^"_MorToDeaPro_"^"_DisAndTrePro_"^"_PhyAndLabTest_"^"_FinTakRes_"^"_PisReqSpec_"^"_PisArcList
	s mListData=mListData_"^"_InsHosp_"^"_InsDoc_"^"_PisType_"^"_PisStatus
	Q mListData
}

/// Descript: 取HPV申请治疗方式数据
/// w ##Class(web.DHCAPPPisInterface).GetPisTreMet("")
ClassMethod GetPisTreMet(PisID As %String) As %String
{
	n (PisID)
	s ID="", mData=""
	F  s ID=$o(^DHCAPPPTM(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TreMetID=$p(^DHCAPPPTM(ID),"^",2)
	.Q:TreMetID=""
	.s TreMetDesc=$p(^DHCAPPPDI(TreMetID),"^",2) //^DHCAPPID$p(^DHCAPPTM(TreMetID),"^",2)
	.;i TreMetDesc="其他" s TreMetDesc=$p(^DHCAPPPTM(ID),"^",3)
	.i mData="" s mData=TreMetDesc
	.E  s mData=mData_","_TreMetDesc
	Q mData
}

/// Descript: 取HPV申请检测方法数据
/// w ##Class(web.DHCAPPPisInterface).GetPisTesItmMet("")
ClassMethod GetPisTesItmMet(PisID As %String) As %String
{
	n (PisID)
	s ID="", mData=""
	F  s ID=$o(^DHCAPPPTIM(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TreMetID=$p(^DHCAPPPTIM(ID),"^",2)
	.Q:TreMetID=""
	.s TreMetDesc=$p(^DHCAPPPDI(TreMetID),"^",2) //$p(^DHCAPPTIM(TreMetID),"^",2)
	.i TreMetDesc="其他" s TreMetDesc=$p(^DHCAPPPTIM(ID),"^",3)
	.i mData="" s mData=TreMetDesc
	.E  s mData=mData_","_TreMetDesc
	Q mData
}

/// Descript: 取HPV申请临床诊断数据
/// w ##Class(web.DHCAPPPisInterface).GetPisTesDiag("")
ClassMethod GetPisTesDiag(PisID As %String) As %String
{
	n (PisID)
	s ID="", mData=""
	F  s ID=$o(^DHCAPPPTD(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s TesDiagID=$p(^DHCAPPPTD(ID),"^",2)
	.Q:TesDiagID=""
	.s TesDiagDesc=$p(^DHCAPPPDI(TesDiagID),"^",2) //$p(^DHCAPPTD(TesDiagID),"^",2)
	.i TesDiagDesc="其他" s TesDiagDesc=$p(^DHCAPPPTD(ID),"^",3)
	.i mData="" s mData=TesDiagDesc
	.E  s mData=mData_","_TesDiagDesc
	Q mData
}

/// Descript: 取HPV申请病人病历数据
/// w ##Class(web.DHCAPPPisInterface).GetPisPatRec("")
ClassMethod GetPisPatRec(PisID As %String) As %String
{
	n (PisID)
	s ID="", mData=""
	F  s ID=$o(^DHCAPPPPR(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s PatRecID=+$p(^DHCAPPPPR(ID),"^",2)
	.Q:PatRecID=0
	.s PatRecDesc=$p(^DHCAPPPDI(PatRecID),"^",2) //$p(^DHCAPPPR(PatRecID),"^",2)
	.i PatRecDesc="其他" s PatRecDesc=$p(^DHCAPPPPR(ID),"^",3)
	.i mData="" s mData=PatRecDesc
	.E  s mData=mData_","_PatRecDesc
	Q mData
}

/// Descript: 取传染病史数据
/// w ##Class(web.DHCAPPPisInterface).GetPisPatInfDis("")
ClassMethod GetPisPatInfDis(PisID As %String) As %String
{
	n (PisID)
	s ID="", mData=""
	F  s ID=$o(^DHCAPPPID(0,"PisMas",PisID,ID)) Q:ID=""  D
	.s PatInfDisID=$p(^DHCAPPPID(ID),"^",2)
	.Q:PatInfDisID=""
	.s PatInfDisDesc=$p(^DHCAPPPDI(PatInfDisID),"^",2) //^DHCAPPID
	.//i PatInfDisDesc="其他" s PatInfDisDesc=$p(^DHCAPPPID(ID),"^",3)
	.i mData="" s mData=PatInfDisDesc
	.E  s mData=mData_","_PatInfDisDesc
	Q mData
}

/// Descript:    取病理申请标本内容
/// w ##Class(web.DHCAPPPisInterface).GetPisReqSpec("13")
ClassMethod GetPisReqSpec(PisID As %String) As %String
{
	n (PisID)
	s CH="",mListData=""
	/*F  s CH=$o(^DHCAPPPM(PisID,"S",CH)) Q:CH=""  D
	.s No=$p(^DHCAPPPM(PisID,"S",CH),"^",1)      /// 标本序号
	.s ID=$p(^DHCAPPPM(PisID,"S",CH),"^",2)      /// 标本标识
	.s Name=$p(^DHCAPPPM(PisID,"S",CH),"^",3)    /// 标本名称
	.s Explain=$p(^DHCAPPPM(PisID,"S",CH),"^",4) /// 标本说明
	.s Part=$p(^DHCAPPPM(PisID,"S",CH),"^",5)    /// 标本部位
	.s Qty=$p(^DHCAPPPM(PisID,"S",CH),"^",6)     /// 标本数量
	.s Remark=$p(^DHCAPPPM(PisID,"S",CH),"^",7)  /// 标本备注
	.s SliType=$p(^DHCAPPPM(PisID,"S",CH),"^",8) /// 玻片/蜡片
	.s PisNo=$p(^DHCAPPPM(PisID,"S",CH),"^",9)   /// 原病理号
	.s TypeID=$p(^DHCAPPPM(PisID,"S",CH),"^",10) /// 标本类型
	.s TypeDesc=""
	.i TypeID'="" s TypeDesc=$p($g(^DHCAPPCB(TypeID)),"^",2)    /// 描述
	.i TypeDesc'="" s Remark=TypeDesc
	.s mTmpData=No_"#"_Name_"#"_"#"_Qty_"#"_SliType_"#"_PisNo_"#"_Remark
	.i mListData="" s mListData=mTmpData
	.E  s mListData=mListData_"@"_mTmpData
	.*/
	s JsonStr=$G(^DHCAPPPM(PisID,"JsonInfo"))
	k ArrJsonStr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonStr,.ArrJsonStr)
	s ID=""
	for{
		s ID=$O(ArrJsonStr(ID))
		q:ID=""
		s ToPisID=$g(ArrJsonStr(ID,"ID"))
			if (ToPisID="OtherInfo"){
			k ArrOtherInfo
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr($g(ArrJsonStr(ID,"Val")),.ArrOtherInfo)
			s OtherID=""
			for {
				s OtherID=$O(ArrOtherInfo(OtherID))
				q:OtherID=""
				if (OtherID="PisReqSpec"){
					s mListData=$g(ArrOtherInfo(OtherID))
					}
				}
			}
		}
	Q mListData
}

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    取消病理申请单，发送状态给Pis系统
/// w ##Class(web.DHCAPPPisInterface).CancelPisNo("")
ClassMethod CancelPisNo(ID As %String) As %String
{
	n (ID)
	Q:'$d(^DHCAPPPM(ID)) ""
	s PisReqNo=$p(^DHCAPPPM(ID),"^",11)		 		/// 申请单号
	d ##class(Src.DPIS3OutInterface).GetPISAppBill("",ExaReqNoXml)
	Q 0
}

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    更新Pis系统结果状态
/// w ##Class(web.DHCAPPPisInterface).InsPisResFlag("")
ClassMethod InsPisResFlag(PisID As %String, HisCodeID As %String, PisNo As %String) As %String
{
	n (PisID, HisCodeID, PisNo)
	i PisNo="" s PisNo=$p(^DHCAPPPM(PisID),"^",13)
	&SQL(update DHC_AppPisMaster set AP_Status_Dr=:HisCodeID, AP_PisNo=:PisNo where AP_RowID=:PisID)
	Q SQLCODE
}

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    取病理申请相关医嘱串
/// w ##Class(web.DHCAPPPisInterface).GetPisItemByNo("")
ClassMethod GetPisItemByNo(PisNo As %String) As %String
{
	n (PisNo)
	s PisID=$o(^DHCAPPPM(0,"PisNo",PisNo,""))
	Q:PisID="" ""
	s CH="",ListData=""
	f  s CH=$o(^DHCAPPPM(PisID,"A",CH)) Q:CH=""  D
	.s itmID=PathID_"||"_CH
	.s oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",2)    /// 医嘱ID
	.i ListData'="" s ListData=ListData_"^"_oeori
	.E  s ListData=oeori
	Q ListData
}

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    执行科室登记时调用
/// w ##Class(web.DHCAPPPisInterface).DoPisRegister("CR^164||371^pis^^病理科^64658^62020^撤销登记")
ClassMethod DoPisRegister(PisParam As %String) As %String
{
	n (PisParam)
	Q ..UpdPisReqNo(PisParam)
}

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    执行科室更新申请单状态时调用
/// w ##Class(web.DHCAPPPisInterface).UpdPisReqNo("3^115||83^pis^病理科^2018-02-03^10:06:18^^C1700021")
ClassMethod UpdPisReqNo(PisParam As %String) As %String
{
	n (PisParam)

	s PisCode=$p(PisParam,"^")
	/// 取His状态码
	s HisCodeID=$o(^DHCAPPSC(0,"Code",$$ALPHAUP^SSUTIL4(PisCode),""))
	Q:HisCodeID="" "-1"
	s HisCode=$p(^DHCAPPTST(HisCodeID),"^",1)

	/// SC-登记、HA-诊断中、RP-报告、RA-拒收、CA-取消检查、CR-取消登记、MA-报告更改、申请补充
	/// 登记修改医嘱为执行、诊断中/报告/报告更改不修改医嘱状态、拒收/取消检查/取消登记修改医嘱为核实
	///s OeStatus=$s(HisCode="3":"E",HisCode="29":"",HisCode="95":"",HisCode="2":"V",HisCode="1":"V",HisCode="1":"V",HisCode="30":"",1:"N")
	s OeStatus=$s(HisCode="REG":"E",HisCode="DI":"",HisCode="MA":"",HisCode="RF":"V",HisCode="CP":"V",HisCode="CR":"V",HisCode="RP":"",1:"N")
	Q:OeStatus="N" "-2"

	/// 取申请单ID
	s Oeori=$p(PisParam,"^",2)
	s PisID=..GetPisArcByOeori(Oeori)
	Q:PisID="" "-3"
	TS
	/// 保存操作日志
	s Err=..InsPisLog(PisID, HisCodeID, PisParam)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	s PisNo=""
	i HisCode="REG" s PisNo=$p(PisParam,"^",8)
	s Err=..InsPisResFlag(PisID, HisCodeID, PisNo)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	/// 更新医嘱状态
	i OeStatus'="" s Err=..UpdOeoriStat(OeStatus, Oeori)
	i Err'=0 tro
	q:Err'=0 "-13"
	TC
	Q Err
}

/// Descript:    执行科室在写完报告后，调用接口回传报告结果
/// w ##Class(web.DHCAPPPisInterface).ReturnReport("")
ClassMethod UpdOeoriStat(OeStatus As %String, Oeori As %String) As %String
{
	n (OeStatus, Oeori)
	s Err=##Class(web.DHCAPPInterface).SetOeoriStat(Oeori,OeStatus)
	Q Err
}

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    执行科室在写完报告后，调用接口回传报告结果
/// w ##Class(web.DHCAPPPisInterface).ReturnReport("")
ClassMethod ReturnReport(PisParam As %String) As %String
{
	n (PisParam)

	s Oeori=$p(PisParam,"^",1)  /// 医嘱ID
	TS
	/// 取申请单ID
	s PisID=..GetPisArcByOeori(Oeori)
	Q:PisID="" ""

	/// 保存报告结果
	s Err=..InsPisResult(PisID, PisParam)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	TC
	Q Err
}

/// Descript:    取申请单ID
/// w ##Class(web.DHCAPPPisInterface).GetPisArcByOeori("")
ClassMethod GetPisArcByOeori(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" ""
	s PisID=$o(^DHCAPPPM(0,"OrdItem",Oeori,""))
	Q PisID
#;	Q:PisID="" ""
#;	s CH=$o(^DHCAPPPM(0,"OrdItem",Oeori,PisID,""))
#;	Q:CH="" ""
#;	Q PisID_"||"_CH
}

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    插入病理申请日志
/// w ##Class(web.DHCAPPPisInterface).InsPisResult("")
ClassMethod InsPisResult(PisID, mListData As %String) As %String
{
	n (PisID, mListData)
	s Oeori=$p(mListData,"^",1)   		 /// 医嘱ID
	s PisStuNo=$p(mListData,"^",2)       /// 病理号
	s RUserCode=$p(mListData,"^",3)      /// 报告医生代码
	s RUser=$p(mListData,"^",4)          /// 报告医生
	s AUserCode=$p(mListData,"^",5)      /// 审核医生代码
	s AUser=$p(mListData,"^",6)          /// 审核医生
	s RDate=$p(mListData,"^",7)          /// 报告日期
	s ADate=$p(mListData,"^",8)          /// 审核日期
	s RTime=$p(mListData,"^",9)          /// 报告时间
	s ATime=$p(mListData,"^",10)         /// 审核时间
	s Notes=$p(mListData,"^",11)         /// 备注
	s ImgPath=$p(mListData,"^",12)       /// 图像的路径
	s SeeRes=$p(mListData,"^",13)        /// 肉眼所见
	s ExaRes=$p(mListData,"^",14)        /// 检查所见
	s ResDiag=$p(mListData,"^",15)       /// 诊断结果
	s ResFlag=$p(mListData,"^",16)       /// 检查结果
	s ResAbnormal=$p(mListData,"^",17)   /// 结果异常
	s PisDr=$p(mListData,"^",18)         /// PIS报告ID
	s Type="P"							 /// 类型
	s BaseDocCode="" //$p(mListData,"^",2)    /// 取材医生代码
	s BaseDoc="" //$p(mListData,"^",2)        /// 取材医生
	&SQL(insert into DHC_AppRepResult(AR_Pointer,AR_Type,AR_Oeori_Dr,AR_PisStuNo,AR_BaseDocCode,AR_BaseDoc,AR_RUserCode,AR_RUser,AR_RDate,AR_RTime,AR_AUserCode,AR_AUser,AR_ADate,AR_ATime,AR_Notes,AR_ImgPath,AR_SeeRes,AR_ExaRes,AR_ResDiag,AR_ResFlag,AR_ResAbnormal,AR_Pis_Dr)
		values(:PisID,:Type,:Oeori,:PisStuNo,:BaseDocCode,:BaseDoc,:RUserCode,:RUser,:RDate,:RTime,:AUserCode,:AUser,:ADate,:ATime,:Notes,:ImgPath,:SeeRes,:ExaRes,:ResDiag,:ResFlag,:ResAbnormal,:PisDr))
	Q SQLCODE
}

/// Creator: 	 bianshuai
/// CreateDate:  2017-11-14
/// Descript:    插入检查申请日志
/// w ##Class(web.DHCAPPPisInterface).InsPisLog("")
ClassMethod InsPisLog(PisID As %String, HisCodeID As %String, mListData As %String) As %String
{
	n (PisID, HisCodeID, mListData)
	s Oeori=$p(mListData,"^",2)   		 /// 医嘱ID
	s UserCode=$p(mListData,"^",3)       /// 操作员工号
	s UserName=$p(mListData,"^",4)       /// 操作员
	s Reason=$p(mListData,"^",7)         /// 原因
	s PisStuNo=$p(mListData,"^",8)       /// 病理号
	s EQTxt=$p(mListData,"^",9)          /// 设备
	s Type="P"							 /// 类型
	s CreateDate=$p(mListData,"^",5)     /// 日期
	i CreateDate'="" s CreateDate=$zdh(CreateDate,3)
	s CreateTime=$p(mListData,"^",6)     /// 时间
	i CreateTime'="" s CreateTime=..%ZTH(CreateTime,1)
	//s CreateDate=..%SysDate()   				 /// 记录日期
	//s CreateTime=..%SysTime()   	     /// 记录时间
	&SQL(insert into DHC_AppRepLog(AR_Pointer,AR_Type,AR_Oeori_Dr,AR_OpeUserCode,AR_OpeUser,AR_Status_Dr,AR_Date,AR_Time,AR_Reason,AR_PisStuNo,AR_EQTxt)
		values(:PisID,:Type,:Oeori,:UserCode,:UserName,:HisCodeID,:CreateDate,:CreateTime,:Reason,:PisStuNo,:EQTxt))
	Q SQLCODE
}

/// Descript:  取病人现病史及主诉信息
/// w ##Class(web.DHCAPPPisInterface).JsonGetPatSymHis("")
ClassMethod JsonGetPatSymHis(EpisodeID As %String) As %String
{
	n (EpisodeID)
	
	s PatSym="",PatHis=""
	s PatType=$p(^PAADM(EpisodeID),"^",2)  /// 病人类型
	i PatType="I" D
	./// 住院
	.//主诉
	.s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.13.01")
	.i obj'="" s PatSym = obj.GetAt("HDSD00.13.114")
	.//现病史
	.s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.13.01")
	.i obj'="" s PatHis = obj.GetAt("HDSD00.13.095")  
	E  D
	./// 门急诊
	.//现病史
	.s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.03.01")
	.i obj'="" s PatHis = obj.GetAt("HDSD00.03.038") 
	.//主诉
	.s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossary(EpisodeID,"HDSD00.03.01")
	.i obj'="" s PatSym = obj.GetAt("HDSD00.03.057") 
	
	s ListData=PatSym_"^"_PatHis
	s ListTitle="PatSym^PatHis"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Descript:  取病人传染病史内容 调用Lis接口
/// w ##Class(web.DHCAPPPisInterface).JsonGetPatInfDis("")
ClassMethod JsonGetPatInfDis(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s PatInfDis = ""
	Q PatInfDis
}

/// Descript:  取病人手术内容 调用手麻接口
/// w ##Class(web.DHCAPPPisInterface).JsonGetPatOperRes("")
ClassMethod JsonGetPatOperRes(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s PatOperRes = ""
	Q PatOperRes
}

/// Descript:  取冰冻申请单列表 PIS系统调用
/// Input:     StartDate - 开始日期，EndDate - 结束日期，LocID - 申请科室Code，recLocCode - 接收科室Code
/// w ##Class(web.DHCAPPPisInterface).JsGetPisFrostREQ("2018-01-01","2018-02-31","","")
ClassMethod JsGetPisFrostREQ(StartDate As %String, EndDate As %String, LocID As %String, recLocID As %String) As %Stream.GlobalCharacter
{
	n (StartDate, EndDate, LocID, recLocID)
	
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
    
    i StartDate="" s StartDate=..%SysDate()-1
    i EndDate="" s EndDate=..%SysDate()
	
    s OutBinStream=##Class(%Stream.GlobalCharacter).%New()
	d OutBinStream.Write("[")
    s Num=0
	F dd=StartDate:1:EndDate D
	.s PisID=""
	.F  s PisID=$o(^DHCAPPPM(0,"CreateDate",dd,PisID)) Q:PisID=""  D
	..Q:(LocID'="")&($p(^DHCAPPPM(PisID),"^",8)'=LocID)
	..s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)       /// 就诊ID
	..Q:'$d(^PAADM(EpisodeID))
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1)  /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)  /// 登记号
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)  /// 年龄
	..s FrostFlag=$p(^DHCAPPPM(PisID),"^",2)     /// 冰冻标志
	..Q:FrostFlag'="Y"
	..s PisRDate=$p(^DHCAPPPM(PisID),"^",6)		/// 申请日期
	..s:PisRDate'="" PisRDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(PisRDate) 
	..s PisRTime=$p(^DHCAPPPM(PisID),"^",7)		/// 申请时间
	..s:PisRTime'="" PisRTime=..%ZT(PisRTime,2)
	..s UserID=$p(^DHCAPPPM(PisID),"^",5)	    /// 申请人
	..s PisRUser=$p(^SSU("SSUSR",UserID),"^",2)
	..s ReqLoc=""
	..s ReqLocID=$p(^DHCAPPPM(PisID),"^",8)	    /// 申请科室
	..s:ReqLocID'="" ReqLoc=$p(^CTLOC(ReqLocID),"^",2)
	..s PisMasSpec=..GetPisMasSpec(PisID)       /// 病理标本
	..s Num=Num+1
    ..s ListData=PatName_"^"_PatNo_"^"_PatSex_"^"_PatAge_"^"_PisRDate_"^"_PisRTime_"^"_PisRUser_"^"_ReqLoc_"^"_PisMasSpec
	..s ListTitle="PatName^PatNo^PatSex^PatAge^PisRDate^PisRTime^PisRUser^ReqLoc^PisMasSpec"
	..i Num=1 d
	...d OutBinStream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	..E  d
	...d OutBinStream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	..
	d OutBinStream.Write("]")
	Q OutBinStream
}

/// Descript:    取病理申请标本内容
/// w ##Class(web.DHCAPPPisInterface).GetPisMasSpec("13")
ClassMethod GetPisMasSpec(PisID As %String) As %String
{
	n (PisID)
	s CH="",mListData=""
	F  s CH=$o(^DHCAPPPM(PisID,"S",CH)) Q:CH=""  D
	.s No=$p(^DHCAPPPM(PisID,"S",CH),"^",1)      /// 标本序号
	.s ID=$p(^DHCAPPPM(PisID,"S",CH),"^",2)      /// 标本标识
	.s Name=$p(^DHCAPPPM(PisID,"S",CH),"^",3)    /// 标本名称
	.s Explain=$p(^DHCAPPPM(PisID,"S",CH),"^",4) /// 标本说明
	.s Part=$p(^DHCAPPPM(PisID,"S",CH),"^",5)    /// 标本部位
	.s Qty=$p(^DHCAPPPM(PisID,"S",CH),"^",6)     /// 标本数量
	.s Remark=$p(^DHCAPPPM(PisID,"S",CH),"^",7)  /// 标本备注
	.s SliType=$p(^DHCAPPPM(PisID,"S",CH),"^",8) /// 玻片/蜡片
	.s PisNo=$p(^DHCAPPPM(PisID,"S",CH),"^",9)   /// 原病理号
	.s mTmpData=No_":"_Name_":"_Qty_":"_SliType_":"_Remark
	.i mListData="" s mListData=mTmpData
	.E  s mListData=mListData_","_mTmpData
	.
	Q mListData
}

/// Descript:  取病人本次就诊的病理相关费用
/// w ##Class(web.DHCAPPPisInterface).GetPisNoCost("6394||8","345")
ClassMethod GetPisNoCost(Oeori As %String, LocID As %String) As %Stream.GlobalCharacter
{
	n (Oeori, LocID)
	s ord=+Oeori
	s OutBinStream=##Class(%Stream.GlobalCharacter).%New()
	d OutBinStream.Write("[")
	s itm=0,Num=0
	F  s itm=$o(^OEORD(ord,"I",itm)) Q:itm=""  D
	.Q:$p(^OEORD(ord,"I",itm,3),"^",6)'=LocID
	.s ItmStatID=$p(^OEORD(ord,"I",itm,1),"^",13)
	.Q:ItmStatID=""
	.s itmStCode=$p(^OEC("OSTAT",ItmStatID),"^",1) /// 医嘱状态代码
	.Q:(itmStCode="D")||(itmStCode="U")  
	.s itmStDesc=$p(^OEC("OSTAT",ItmStatID),"^",2) /// 医嘱状态描述
	.s arcimid=$p(^OEORD(ord,"I",itm,1),"^",2)     /// 医嘱项ID
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	.s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
	.s OrdDate=$p(^OEORD(ord,"I",itm,3),"^",7)   /// 医嘱日期
	.s OrdTime=$p(^OEORD(ord,"I",itm,3),"^",15)  /// 医嘱时间
	.s:OrdTime'="" OrdTime=..%ZT(OrdTime,1)
	.s itmCostStr=##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcimid,OrdDate,"","","","")
	.s itmCost=+$p(itmCostStr,"^",1)
	.s:OrdDate'="" OrdDate=$zd(OrdDate,3)
	.s Num=Num+1
    .s ListData=ord_"||"_itm_"^"_arcitmdesc_"^"_itmCost_"^"_itmStDesc_"^"_OrdDate_"^"_OrdTime
	.s ListTitle="itmID^itmDesc^itmCost^itmStDesc^OrdDate^OrdTime"
	.i Num=1 d
	..d OutBinStream.Write(##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.E  d
	..d OutBinStream.Write(","_##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData))
	.
	d OutBinStream.Write("]")
	Q OutBinStream
}

/// Creator:    sufan
/// CreateDate: 2018-02-07
/// Descript:   根据医嘱ID取病理申请单单ID(给护理组)
/// InPut:      医嘱ID
/// OutPut:     病理申请单ID
/// w ##Class(web.DHCAPPPisInterface).GetRepRowIdByOeordID("1295||251")
ClassMethod GetRepRowIdByOeordID(OeordID As %String) As %String
{
	n (OeordID)
	q:OeordID="" "-1+医嘱ID为空"
	q:'$d(^DHCAPPPM(0,"OrdItem",OeordID)) ""
	s RepRowID=$o(^DHCAPPPM(0,"OrdItem",OeordID,""))		//病理申请单ID
	q $g(RepRowID)
}

/// Creator:    sufan
/// CreateDate: 2018-02-07
/// Descript:   根据申请单ID取标本名称(给护理组)
/// InPut:      申请单ID
/// OutPut:     标本名称串
/// w ##Class(web.DHCAPPPisInterface).GetSpeNameByRepID("357")
ClassMethod GetSpeNameByRepID(RepRowID As %String) As %String
{
	n (RepRowID)
	s SpeInfo=""
	q:RepRowID="" "-2+申请单ID为空"
	s PisCH=""
	s PisCH=$o(^DHCAPPPM(RepRowID,"A",PisCH))	
	s OeorID=$p(^DHCAPPPM(RepRowID,"A",PisCH),"^",3)      //医嘱ID
	q:OeorID="" ""
	s CH=""
	/*for  s CH=$o(^DHCAPPPM(RepRowID,"S",CH)) q:CH=""  d    //取此表DHC_AppPisSpec信息
	.s SpeNo=$p(^DHCAPPPM(RepRowID,"S",CH),"^",1)		   //序号
	.s SpeName=$p(^DHCAPPPM(RepRowID,"S",CH),"^",3)		   //标本名称
	.s Remark=$p(^DHCAPPPM(RepRowID,"S",CH),"^",7)         //标本备注
	.s Qty=$p(^DHCAPPPM(RepRowID,"S",CH),"^",6)            //标本备注
	.i SpeInfo="" s SpeInfo=SpeNo_"!"_SpeName_"!"_Remark_"!"_Qty_"!"_$p(OeorID,"||",1)_"-"_$p(OeorID,"||",2)_"-"_SpeNo			   //标本名称拼串
	.e  s SpeInfo=SpeInfo_";"_SpeNo_"!"_SpeName_"!"_Remark_"!"_Qty_"!"_$p(OeorID,"||",1)_"-"_$p(OeorID,"||",2)_"-"_SpeNo
	
	*/
	s JsonStr=$G(^DHCAPPPM(RepRowID,"JsonInfo"))
	q:JsonStr="" ""
	k ArrJsonStr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(JsonStr,.ArrJsonStr)
	s ID=""
	for{
		s ID=$O(ArrJsonStr(ID))
		q:ID=""
		s ToPisID=$g(ArrJsonStr(ID,"ID"))
			if (ToPisID="OtherInfo"){
			k ArrOtherInfo
			d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr($g(ArrJsonStr(ID,"Val")),.ArrOtherInfo)
			s OtherID=""
			for {
				s OtherID=$O(ArrOtherInfo(OtherID))
				q:OtherID=""
				if (OtherID="PisReqSpec"){
					s PisReqSpec=$g(ArrOtherInfo(OtherID))
					Set PisReqSpec =  ##Class(DHCDoc.Util.FromJSON).Replace(PisReqSpec, "\"_$c(1), $c(1))
					Set PisReqSpec =  ##Class(DHCDoc.Util.FromJSON).Replace(PisReqSpec, "\"_$c(2), $c(2))
					F i=1:1:$L(PisReqSpec,$C(2)) {
						s OnePisSpec=$P(PisReqSpec,$C(2),i)
						s SpeNo=$P(OnePisSpec,$C(1),1)	   //序号
						s SpeName=$P(OnePisSpec,$C(1),2)		   //标本名称
						s Remark=$P(OnePisSpec,$C(1),6)       //标本备注
						s Qty=$P(OnePisSpec,$C(1),4)           //标本备注
						i SpeInfo="" s SpeInfo=SpeNo_"!"_SpeName_"!"_Remark_"!"_Qty_"!"_$p(OeorID,"||",1)_"-"_$p(OeorID,"||",2)_"-"_SpeNo			   //标本名称拼串
						e  s SpeInfo=SpeInfo_";"_SpeNo_"!"_SpeName_"!"_Remark_"!"_Qty_"!"_$p(OeorID,"||",1)_"-"_$p(OeorID,"||",2)_"-"_SpeNo
						}
					}
				}
			}
		}
	q SpeInfo
}

/// Creator:    bianshuai
/// CreateDate: 2018-03-07
/// Descript:   自动生成病理申请单接口【体检】
/// InPut:      mListData - 医嘱项ID^接收科室ID^就诊ID^申请医生ID^申请科室ID^加急标志^冰冻标志^人乳头病毒发现日期^临床病历^临床诊断^^^申请类型^医嘱ID
///                         &标本序号^标本标识^标本名字^标本部位^标本数量^拨片/蜡片^原病历号^备注
/// OutPut:     申请单号-成功，负数-失败,
/// w ##Class(web.DHCAPPPisInterface).InsPisMas("11542||1^370^380^4647^370^^^^^^^^^361||1")
ClassMethod InsPisMas(mListData As %String) As %String
{
	n (mListData)
	s EpisodeID=$P(mListData,"^",3)
	s DocID=$P(mListData,"^",4)
	s LocID=$P(mListData,"^",5)
	s Type=""
	s itmmastid=$P(mListData,"^",1)
	if (itmmastid'=""){
		s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,""))
		Q:TraID="" ""
		Q:'$d(^DHCAPPTRA(TraID)) ""
		s Type=$p(^DHCAPPTRA(TraID),"^",7)
		}
	s OEOrdStr=$P(mListData,"^",1)_"^"_$P(mListData,"^",2)_"^"_$P($P(mListData,"&",1),"^",14)
	s PisID=""
	s BillTypeID=""
	s JsonStr=""
	
	s AMArr=[]
	s obj={}
	s obj.ID="TesItemDesc"
	s obj.Val=$p($G(^ARCIM(+itmmastid,$P(itmmastid,"||",2),1)),"^",2)
	s obj.Class="text"
	s obj.Desc=$p($G(^ARCIM(+itmmastid,$P(itmmastid,"||",2),1)),"^",2)
	d AMArr.%Push(obj)
	s obj={}
	s obj.ID="recLoc"
	s obj.Val=$P(mListData,"^",2)
	s obj.Class="combobox"
	s obj.Desc=$P($g(^CTLOC($P(mListData,"^",2))),"^",2)
	d AMArr.%Push(obj)
	s obj={}
	s obj.ID="DocDr"
	s obj.Val=$P(mListData,"^",4)
	s obj.Class="combobox"
	s obj.Desc=$p($g(^SSU("SSUSR",$P(mListData,"^",4))),"^",2) 
	d AMArr.%Push(obj) 
	s obj={}
	s obj.ID="ApplyDocUser"
	s obj.Val=$P(mListData,"^",4)
	s obj.Class="combobox"
	s obj.Desc=$p($g(^SSU("SSUSR",$P(mListData,"^",4))),"^",2) 
	d AMArr.%Push(obj) 
	s obj={}
	s obj.ID="LocID"
	s obj.Val=$P(mListData,"^",5)
	s obj.Class="combobox"
	s obj.Desc=$P($g(^CTLOC($P(mListData,"^",5))),"^",2)
	d AMArr.%Push(obj) 
	s obj={}
	s obj.ID="ApplyLoc"
	s obj.Val=$P(mListData,"^",5)
	s obj.Class="combobox"
	s obj.Desc=$P($g(^CTLOC($P(mListData,"^",5))),"^",2)
	d AMArr.%Push(obj) 
	s obj={}
	s EmgFlag="false"
	if ($P(mListData,"^",6)="Y") s EmgFlag="true"
	s obj.ID="EmgFlag"
	s obj.Val=EmgFlag
	s obj.Class="checkbox"
	s obj={}
	s FrostFlag="false"
	if ($P(mListData,"^",7)="Y") s FrostFlag="true"
	s obj.ID="FrostFlag"
	s obj.Val=FrostFlag
	s obj.Class="checkbox"
	d AMArr.%Push(obj)
	s obj={}
	s obj.ID="SepDate"
	s obj.Val=$P(mListData,"^",8)
	s obj.Class="datebox"
	s obj.Desc=$P(mListData,"^",8)
	d AMArr.%Push(obj)
	s obj={} 
	s obj.ID="MedRecord"
	s obj.Val=$P(mListData,"^",9)
	s obj.Class="text"
	s subobj={}
	s Spcestr=$P(mListData,"&",2)
	s subobj.PisReqSpec=$P(Spcestr,"^",1)_$C(1)_$P(Spcestr,"^",3)_$C(1)_$P(Spcestr,"^",4)_$C(1)_$P(Spcestr,"^",5)_$C(1)_$P(Spcestr,"^",6)_$C(1)_$P(Spcestr,"^",7)
	s Value=subobj.%ToJSON()
	s obj={}
	s obj.ID="OtherInfo"
	s obj.Val=Value
	d AMArr.%Push(obj)
	s JsonStr=AMArr.%ToJSON()
	s rtn=##class(web.DHCDocAPPBL).InsertNewBLInformation(EpisodeID, DocID, LocID, Type, OEOrdStr, JsonStr, PisID, BillTypeID)
	s PisID=$P(rtn,"^",2)
	s rtn=##class(web.DHCDocAPPBL).InsSendFlag(PisID,DocID,"")
	/*s arcimid=$p(mListData,"^",1)
	s PisType=..GetPisType(arcimid) 	/// 取病理类型
	Q:PisType="" "-2"
	s $p(mListData,"^",13)=PisType*/
	;s PisID=..Insert(mListData)
	s PisNo=$p(^DHCAPPPM(PisID),"^",4)   /// 申请单号
	if (PisNo'=""){
		d ##Class(web.DHCAPPPisInterface).UpdPisReqStatus("AP",PisID,$P(mListData,"^",4))
		}
	
	Q PisNo
}

/// Descritp:  插入病理申请内容
/// Input:     mListData-申请单内容
/// Ouput:     申请单ID
/// w ##Class(web.DHCAppPisMaster).Insert("")
ClassMethod Insert(mListData As %String) As %String
{
	N (mListData)
	s Err=0
	TS

	/// 病理内容
	s PisID=##Class(web.DHCAppPisMaster).InsPisMaster(mListData)
	i PisID<0 tro
	Q:PisID<0 PisID

	/// 病理医嘱
	s Err=##Class(web.DHCAppPisMaster).InsPisArc(PisID,mListData)
	i Err'=0 tro
	Q:Err'=0 "-11"

	/// 病理标本
	s ListData=$p(mListData,"&",2)
	s Err=##Class(web.DHCAppPisMaster).InsPisSpec(PisID,ListData)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 病理发送状态
	s Err=##Class(web.DHCAppPisMaster).UpdPisSendFlag(PisID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	TC
	Q PisID
}

/// Creator:    bianshuai
/// CreateDate: 2018-03-07
/// Descript:   提取病理检查结果内容【体检】
/// InPut:      Oeori - 医嘱ID
/// OutPut:     空-失败,
///             结果内容串:病理号^报告医生代码^报告医生^审核医生代码^审核医生^报告日期^审核日期
///             ^报告时间^审核时间^备注^肉眼所见^检查所见^诊断结果^检查结果^结果异常^PIS报告ID
/// w ##Class(web.DHCAPPPisInterface).GetPisItmRes("487||1")
ClassMethod GetPisItmRes(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" ""
	s ID=$o(^DHCAPPRR(0,"OrdItem",Oeori,"")) /// 申请单ID
	b ;ID
	Q:ID="" ""
	s PisStuNo=$p(^DHCAPPRR(ID),"^",4)       /// 病理号
	s RUsCode=$p(^DHCAPPRR(ID),"^",7)        /// 报告医生代码
	s RUsName=$p(^DHCAPPRR(ID),"^",8)        /// 报告医生
	s AUsCode=$p(^DHCAPPRR(ID),"^",11)       /// 审核医生代码
	s AUsName=$p(^DHCAPPRR(ID),"^",12)       /// 审核医生
	s RDate=$p(^DHCAPPRR(ID),"^",9)          /// 报告日期
	s ADate=$p(^DHCAPPRR(ID),"^",13)         /// 审核日期
	s RTime=$p(^DHCAPPRR(ID),"^",10)         /// 报告时间
	s ATime=$p(^DHCAPPRR(ID),"^",14)         /// 审核时间
	s Notes=$p(^DHCAPPRR(ID),"^",15)         /// 备注
	s SeeRes=$p(^DHCAPPRR(ID),"^",17)        /// 肉眼所见
	s ExaRes=$p(^DHCAPPRR(ID),"^",18)        /// 检查所见
	s ResDiag=$p(^DHCAPPRR(ID),"^",19)       /// 诊断结果
	s ResFlag=$p(^DHCAPPRR(ID),"^",20)       /// 检查结果
	s ResAbnormal=$p(^DHCAPPRR(ID),"^",21)   /// 结果异常
	s PisDr=$p(^DHCAPPRR(ID),"^",22)         /// PIS报告ID
	
	s PisData=PisStuNo_"^"_RUsCode_"^"_RUsName_"^"_AUsCode_"^"_AUsName_"^"_RDate_"^"_ADate_"^"_RTime_"^"_ATime
	s PisData=PisData_"^"_Notes_"^"_SeeRes_"^"_ExaRes_"^"_ResDiag_"^"_ResFlag_"^"_ResAbnormal_"^"_PisDr
	Q PisData
}

/// Creator:    bianshuai
/// CreateDate: 2018-03-07
/// Descript:   获取病理申请url【体检】
/// InPut:      mListData - 
/// OutPut:     0-成功，其他-失败,
/// w ##Class(web.DHCAPPPisInterface).GetPisLinkUrl("597","11542||1","559||4")
ClassMethod GetPisLinkUrl(EpisodeID As %String, itmmasID As %String, Oeori As %String) As %String
{
	n (EpisodeID, itmmasID, Oeori)
	s $zt="LinkErrMsg"
	s PatientID=$p(^PAADM(EpisodeID),"^",1)          /// 病人ID
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)      /// 登记号
	s Link=..GetLinkUrl(itmmasID)
	Q:Link="-1" "" 
#;	s PisType=..GetPisType(itmmasID) 	             /// 取病理类型
#;	Q:PisType="" "-1"
#;	s Link=$s(PisType="HPV":"dhcapp.pismaster.csp",PisType="CYT":"dhcapp.piscytexn.csp",PisType="MOL":"dhcapp.pismolecular.csp",PisType="CON":"dhcapp.pisoutcourt.csp",PisType="TCT":"dhcapp.piswontct.csp",PisType="APY":"dhcapp.pisautopsy.csp",PisType="LIV":"dhcapp.pislivcells.csp",1:"")
	s Link=Link_"&EpisodeID="_EpisodeID_"&Oeori="_Oeori_"&ARCIM="_itmmasID
	Q Link
LinkErrMsg
    Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2018-03-12
/// Descript:   取病理申请类型【体检】
/// InPut:      mListData - 
/// OutPut:     类型代码,  空-失败
/// w ##Class(web.DHCAPPPisInterface).GetPisType("164||459")
ClassMethod GetPisType(arcimid As %String) As %String
{
	n (arcimid)
	Q:arcimid="" ""
	s TraID=$o(^DHCAPARCCA(0,"Arc",arcimid,""))
	Q:TraID="" ""
	s PisType=$p(^DHCAPARCCA(TraID),"^",1)
	Q PisType
	
#;	s TraID=$o(^DHCAPPTRA(0,"Arc",arcimid,""))
#;	Q:TraID="" ""
#;	Q:'$d(^DHCAPPTRA(TraID)) ""
#;	s nodeType=$p(^DHCAPPTRA(TraID),"^",1)
#;	Q nodeType
	
#;	s itmmastid=$p(arcimid,"||",1)
#;	s itmmastver=$p(arcimid,"||",2)
#;	s itmArcCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)   /// 医嘱子类
#;	s itmCatID=$o(^DHCAPARCCA(0,"O",itmArcCatID,""))
#;	Q:itmCatID="" ""
#;	s PisType=$p(^DHCAPARCCA(itmCatID),"^",1)   	/// 检查分类代码
#;	Q PisType
}

/// Creator:    bianshuai
/// CreateDate: 2018-03-12
/// Descript:   取医嘱项ID
/// InPut:      Oeori - 医嘱
/// OutPut:     医嘱项ID,  空-失败
/// w ##Class(web.DHCAPPPisInterface).GetArcimID("164||459")
ClassMethod GetArcimID(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" ""
	Q:'$d(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),1)) ""
	s arcimid=$p(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),1),"^",2) /// 医嘱项ID
	Q arcimid
}

/// Descript:  格式化日期
ClassMethod TrsToFormat(d As %String) As %String
{
	n (d)
	s $ZT="Err"
	Q:d="" ""
	Q:d["-" d
	if d["/" {
		s flag=##class(web.DHCAPPCommonUtil).DateFormat()
		if flag = 4{
			Set d = $p(d,"/",3)_"-"_$p(d,"/",2)_"-"_$p(d,"/",1)
		}else{
			Set d = $p(d,"/",3)_"-"_$p(d,"/",1)_"-"_$p(d,"/",2)
		}
	}
	Q d
Err
	Q ""
}

/// Descript:	取病理申请数据【体检】
/// W ##Class(web.DHCAPPPisInterface).GetPisNoByOeori("115||86")
ClassMethod GetPisNoByOeori(Oeori As %String) As %String
{
	n (Oeori)
	
	Q:Oeori="" ""
	Q:'$d(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),1)) ""
	s arcimid=$p(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),1),"^",2) /// 医嘱项ID
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s arcimDesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)       /// 医嘱项名称
	s rLocDesc=""
	s rLocID=$p(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),3),"^",6)  /// 接收科室
	i rLocID'="" s rLocDesc=$p(^CTLOC(rLocID),"^",2)
	s PisID=##Class(web.DHCAPPPisInterface).GetPisArcByOeori(Oeori) /// 取申请单ID
	s ListData=arcimid_"^"_arcimDesc_"^"_rLocID_"^"_rLocDesc_"^"_PisID
	s ListTitle="arcimid^arcimDesc^rLocID^rLocDesc^PisID"
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2018-03-07
/// Descript:	对医生站检查数据内容进行分类
/// W ##Class(web.DHCAPPPisInterface).GetExaItemListDoc("70^1^110!N^323^2018-03-19^3844||1^1@N^323^2018-03-19^3847||1^2@N^345^2018-03-19^11542||1^3@N^323^2018-03-19^3891||1^4",.sss)
ClassMethod GetExaItemListDoc(mListDataDoc As %String, itemTmpArr As %String) As %String
{
	n (mListDataDoc, itemTmpArr)
	s PatList=$p(mListDataDoc,"!",1)
	s arcItemList=$p(mListDataDoc,"!",2)
	s Len=$L(arcItemList,"@")
	F i=1:1:Len D
	.s itmmaststr=$p(arcItemList,"@",i)
	.s arcimid=$p(itmmaststr,"^",4)
	.s itmmastid=$p(arcimid,"||",1)
	.s itmmastver=$p(arcimid,"||",2)
	./// 检查分类类型 P - 病理，E - 检查
	.s Type=##Class(web.DHCAPPExaReportQuery).GetTraType(arcimid)
	.i Type="P" D
	..s LinkUrl=..GetLinkUrl(arcimid)
	..i $g(itemTmpArr("P",LinkUrl))="" D
	...s itemTmpArr("P",LinkUrl)=PatList_"!"_itmmaststr
	...s itemTmpArr("P",LinkUrl,1)=..GetPisReqDesc(arcimid)
	..E  s itemTmpArr("P",LinkUrl)=itemTmpArr("P",LinkUrl)_"@"_itmmaststr
	.E  D
	..i $g(itemTmpArr("E"))="" s itemTmpArr("E")=PatList_"!"_itmmaststr
	..E  s itemTmpArr("E")=itemTmpArr("E")_"@"_itmmaststr
	.
    Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2018-03-07
/// Descript:   获取检查申请url
/// InPut:      mListData - 
/// OutPut:     0-成功，其他-失败,
/// w ##Class(web.DHCAPPPisInterface).GetLinkUrl("11542||1")
ClassMethod GetLinkUrl(arcimid As %String) As %String
{
	n (arcimid)
	s PisType=..GetPisType(arcimid) 	             /// 取病理类型
	Q:PisType="" "-1"
	//s Link=$s(PisType="HPV":"dhcapp.pismaster.csp",PisType="CYT":"dhcapp.piscytexn.csp",PisType="MOL":"dhcapp.pismolecular.csp",PisType="CON":"dhcapp.pisoutcourt.csp",PisType="TCT":"dhcapp.piswontct.csp",PisType="APY":"dhcapp.pisautopsy.csp",PisType="LIV":"dhcapp.pislivcells.csp",1:"")
	s LinkUrl = "docapp.blmapshow.hui.csp?&MapCode="_PisType_"&ARCIM="_arcimid
	Q LinkUrl
}

/// Creator:    bianshuai
/// CreateDate: 2018-03-19
/// Descript:   取病理申请描述
/// InPut:      mListData - 
/// OutPut:     0-成功，其他-失败,
/// w ##Class(web.DHCAPPPisInterface).GetPisReqDesc("11541||1")
ClassMethod GetPisReqDesc(itmmastid As %String) As %String
{
	n (itmmastid)
	s TraID=$o(^DHCAPPTRA(0,"Arc",itmmastid,""))
	Q:TraID="" ""
	Q:'$d(^DHCAPPTRA(TraID)) ""
	s nodeDesc=$p(^DHCAPPTRA(TraID),"^",2)
	Q nodeDesc
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-22
/// Descript:     检查申请列表
/// InPut:        EpisodeID - 就诊ID,  HospID - 医院ID
/// W ##Class(web.DHCAPPPisInterface).GetExaReqHis("162","",.TmpPatExaArr)
ClassMethod GetExaReqHis(EpisodeID As %String, LgUserCode As %String, TmpPatExaArr As %String, isXDFlag As %String = "") As %String
{
	n (EpisodeID, LgUserCode, TmpPatExaArr, isXDFlag)
	s UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(LgUserCode),""))
	s ID=""
	F  s ID=$o(^DHCAPREP(0,"ADM",EpisodeID,ID)) Q:ID=""  D
	.s LocID=$p(^DHCAPREP(ID),"^",5)  		/// 执行科室
	.//Q:(HospID'="")&($p($g(^CTLOC(+LocID)),"^",22)'=HospID)
	.s No=$p(^DHCAPREP(ID),"^",1)  		    /// 单号
	.s reqData=$p(^DHCAPREP(ID),"^",2)      /// 申请日期
	.s:reqData'="" reqData=##class(web.DHCAPPCommonUtil).DateLogicalToHtml(reqData)
	.s reqTime=$p(^DHCAPREP(ID),"^",3)      /// 申请时间
	.s:reqTime'="" reqTime=..%ZT(reqTime,2)
	.Q:$p(^DHCAPREP(ID),"^",17)'="Y"	    /// 是否发送
	.s TypeDesc=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(ID,1)
	.i TypeDesc="" s TypeDesc="未知"
	./// 检查当前对应部位是否停止
	.s repStatCode=##Class(web.DHCAPPExaReportQuery).GetExaReqNoStat(ID)
	.Q:repStatCode=0
	.s busTime=reqData_" "_reqTime 		   /// 业务节点时间
	.s CH=""
	.F  s CH=$o(^DHCAPREP(ID,"AR",CH)) Q:CH=""  D
	..Q:$p(^DHCAPREP(ID,"AR",CH),"^",7)'=""
	..s arcimid=$p(^DHCAPREP(ID,"AR",CH),"^",1)        /// 医嘱项ID
	..Q:(isXDFlag=1)&(##Class(DHCDoc.DHCDocConfig.OrderClassify).DefinedClassify("EkgOrd",arcimid)="Y")
	..s Oeori=$p(^DHCAPREP(ID,"AR",CH),"^",3)          /// 医嘱ID
	..Q:Oeori=""
	..s itmmastid=$p(arcimid,"||",1)
	..s itmmastver=$p(arcimid,"||",2)
	..s itmArcDesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)      ///医嘱项名称
	..s OrdBigCat = ##class(web.DHCEMInComUseMethod).GetOECCatByOEORDItmDr(Oeori)
	..q:OrdBigCat["检验"
 	..s ItemLabel=##Class(web.DHCAPPInterface).GetExaReqItemDesc(Oeori)
 	..s ItemStat=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)
	..Q:(ItemStat="D")||(ItemStat="C")   /// 临嘱 住院为撤销、门诊为停止
	..s rLocDesc=""
	..s rLocID=$p($g(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),3)),"^",6)  /// 接收科室
	..i rLocID'="" s rLocDesc=$p(^CTLOC(rLocID),"^",2)
	..i '$d(^DHCAPREP(ID,"AR",CH,"PA")) d
	...s PartID=""
	...s PartDesc=""
	...d GetExaReqHisList
 	..s Sub="",StudyNo=""
	..F  s Sub=$o(^DHCAPREP(ID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	...s PartID=+$p(^DHCAPREP(ID,"AR",CH,"PA",Sub),"^",1) ///部位ID
	...Q:$p(^DHCAPREP(ID,"AR",CH,"PA",Sub),"^",2)="D"
	...Q:PartID=0
	...s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2)
	...d GetExaReqHisList
	.
	Q ""
GetExaReqHisList
	s SNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(Oeori,PartID)
	/// 该医生报告查看情况
	;s PacsData=##Class(RISService.TrakRISService).GetRPTCMStatus(Oeori,SNo,LgUserCode)
	;s isReaded=$p(PacsData,"^",1)
	;Q:isReaded="Y"   /// 已阅读
	s StudyNo=$case(SNo,0:"",-1:"",:SNo)
	s ExamStatus=##Class(web.DHCAPPInterface).GetExaReqItmStatus(Oeori,StudyNo)
	s Params = Oeori_"^"_StudyNo_"^"_UserID
	s IsReadedFlag=##class(web.DHCAPPInterface).IsReadByParams(Params)
	q:IsReadedFlag="Y"
	q:(ExamStatus="OCA")	//HIS系统撤销、作废、停止医嘱
	i "^AP^BK^CSC^CBK^^"[("^"_ExamStatus_"^") s ReqStatus="申请"
	e  i "^RP^"[("^"_ExamStatus_"^") s ReqStatus="报告"
	e  s ReqStatus="登记"
	;w ExamStatus,!
	s ListData=ReqStatus_"^"_Oeori_"^"_itmArcDesc_"^"_$p(ItemLabel,itmArcDesc,2)_"^"_busTime_"^"_TypeDesc_"^"_ID_"||"_CH_"^"_reqData_"^"_reqTime_"^"_No_"^"_StudyNo_"^"_rLocDesc
	s TmpPatExaArr(Oeori)=ListData

	q
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-22
/// Descript:     病理申请列表
/// InPut:        EpisodeID - 就诊ID,  HospID - 医院ID
/// W ##Class(web.DHCAPPPisInterface).GetPisReqHis("15","",.TmpPatExaArr)
ClassMethod GetPisReqHis(EpisodeID As %String, LgUserCode As %String, TmpPatExaArr As %String) As %String
{
	n (EpisodeID, LgUserCode, TmpPatExaArr)
	s UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(LgUserCode),""))
    s PisID=""
    F  {
	    s PisID=$o(^DHCAPPPM(0,"Adm",EpisodeID,PisID))
	    Q:PisID=""
	    s LocID=$p(^DHCAPPPM(PisID),"^",8)  	   /// 申请科室
		//Q:(HospID'="")&($p($g(^CTLOC(+LocID)),"^",22)'=HospID)
		s No=$p(^DHCAPPPM(PisID),"^",4)           /// 申请单号
		s PisDate=$p(^DHCAPPPM(PisID),"^",6)	   /// 申请日期
		s PisTime=$p(^DHCAPPPM(PisID),"^",7)	   /// 申请时间
		s:PisTime'="" PisTime=..%ZT(PisTime,2)
		s PisStatus=$p(^DHCAPPPM(PisID),"^",9)	   /// 申请状态
		continue:PisStatus'="Y"
		s PisNo=$p(^DHCAPPPM(PisID),"^",13)       /// 病理号
		//s PisStatus="申请"
		//s ID=+$p(^DHCAPPPM(PisID),"^",21)         /// 结果状态ID
		//s ResStats=$p($g(^DHCAPPTST(+ID)),"^",1)  /// 状态代码
		//i ResStats="REG" s PisStatus="登记"
		//i ResStats="RP" s PisStatus="报告"
		s PisType=$p(^DHCAPPPM(PisID),"^",20)     /// 申请类型
		s PisTypeDesc=$s(PisType="CYT":"细胞",PisType="HPV":"HPV",PisType="TCT":"妇科TCT",PisType="LIV":"活体",PisType="APY":"尸检",PisType="CON":"外院",PisType="MOL":"分子",1:"未知")
	  	s CH=$O(^DHCAPPPM(PisID,"A",0))
	  	s Oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)  /// 医嘱ID
	  	//w Oeori,!
	  	s arcimid=$p(^DHCAPPPM(PisID,"A",CH),"^",1)            /// 医嘱项ID
	  	continue:arcimid=""
	  	
	  	s Params = Oeori_"^"_PisNo_"^"_UserID
		s IsReadedFlag=##class(web.DHCAPPInterface).IsReadByParams(Params)
		continue:IsReadedFlag="Y"
	  	
	  	s apStatus=##Class(web.DHCAPPInterface).GetExaReqItmStatus(Oeori,PisNo)
	  	continue:(apStatus="OCA")	//HIS系统撤销、作废、停止医嘱
	  	i "^AP^BK^CSC^CBK^"[("^"_apStatus_"^") s Report="申请"
		e  i "^RP^"[("^"_apStatus_"^") s Report="报告"
		e  s Report="登记"
	  	//w Oeori_","_apStatus_","_Report,!
		s itmmastid=$p(arcimid,"||",1)
		s itmmastver=$p(arcimid,"||",2)
		s ItemLabel=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
		continue:'$d(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),3))
		s rLocDesc=""
		s rLocID=$p(^OEORD(+Oeori,"I",+$p(Oeori,"||",2),3),"^",6)  /// 接收科室
		i rLocID'="" s rLocDesc=$p(^CTLOC(rLocID),"^",2)
		s PisSpec=##Class(web.DHCAPPPisInterface).GetPisMasSpec(PisID)     /// 标本
		s PisSpec=$REPLACE(PisSpec,":"," ")
		s:PisDate'="" PisDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(PisDate)
		s busTime=..GetPisBusTime(PisID) 	       /// 业务节点时间
		i +busTime=0 s busTime=PisDate_" "_PisTime
		s ListData=Report_"^"_Oeori_"^"_ItemLabel_"^"_PisSpec_"^"_busTime_"^"_PisTypeDesc_"^"_PisID_"^"_PisDate_"^"_PisTime_"^"_No_"^"_PisNo_"^"_rLocDesc
		s TmpPatExaArr(Oeori)=ListData
	}
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-22
/// Descript:     取病人检查项目列表【医生站住院信息总览调用】
/// InPut:        EpisodeID - 就诊ID,  HospID - 医院ID
/// OutPut:       申请单状态:医嘱ID:医嘱描述:标本/部位:业务时间(申请时间\登记时间\报告时间):申请类型:报告ID:申请日期:申请时间:申请单号:检查号: 
/// D ##Class(%ResultSet).RunQuery("web.DHCAPPPisInterface","QryPatExaList","15","")
Query QryPatExaList(EpisodeID As %String, LgUserCode As %String = "") As websys.Query(ROWSPEC = "ItmStatus:%String,Oeori:%String,ItmDesc:%String,ItmPart:%String,BusTime:%String,ItmType:%String,ItmReqID:%String,ItmReqDate:%String,ItmReqTime:%String,ItmNo:%String,ItmStudyNo:%String")
{
}

ClassMethod QryPatExaListExecute(ByRef qHandle As %Binary, EpisodeID As %String, LgUserCode As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    k TmpPatExaArr
    
    /// 检查申请列表
	d ..GetExaReqHis(EpisodeID, LgUserCode, .TmpPatExaArr, 1)
	
	/// 病理申请列表
	d ..GetPisReqHis(EpisodeID, LgUserCode, .TmpPatExaArr)
	
    s index=""
	F  s index=$o(TmpPatExaArr(index))  Q:index=""  D
	.s ListData=$g(TmpPatExaArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpPatExaArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-22
/// Descript:     检验申请列表【Portal组调用】
/// InPut:        LgDocCode - 医生工号
/// W ##Class(web.DHCAPPPisInterface).GetDocExaListContent("2018-03-26","2018-03-26","ys01",.TmpPatExaArr)
ClassMethod GetDocExaListContent(StartDate As %String, EndDate As %String, LgDocCode As %String, TmpPatExaArr As %String)
{
	n (StartDate, EndDate, LgDocCode, TmpPatExaArr)
	
	s LgDocCode=$$ALPHAUP^SSUTIL4(LgDocCode)
	s userID=$o(^SSU("SSUSR",0,"SSUSR_Initials",LgDocCode,""))
	Q:userID="" ""
	s CareProID=$p(^SSU("SSUSR",userID),"^",14)   /// 医生 CT_CareProv
	i StartDate'="" s StartDate=$zdh(StartDate,3) /// 开始日期
	i EndDate'="" s EndDate=$zdh(EndDate,3)       /// 结束日期
	F dd=StartDate:1:EndDate D
	.s ord=""
	.F  s ord=$o(^OEORDi(0,"DocStDate",CareProID,dd,ord)) Q:ord=""  D
	..s itm=""
	..F  s itm=$o(^OEORDi(0,"DocStDate",CareProID,dd,ord,itm)) Q:itm=""  D
	...s Oeori=ord_"||"_itm
	...s OeFlag=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)    /// 医嘱状态
	...Q:(OeFlag="D")||(OeFlag="C")||(OeFlag="U")
	.../// 病理
	...s ID=$o(^DHCAPPPM(0,"OrdItem",Oeori,""))
	...i ID'="" D ..GetPisItemContent(Oeori, userID, .TmpPatExaArr)
	.../// 检查
	...s ID=$o(^DHCAPREP(0,"OrdItem",Oeori,""))
	...i ID'="" D ..GetExaItemContent(Oeori, userID, .TmpPatExaArr)
	.../// 检验
	...D ..GetLabItemContent(Oeori, userID, .TmpPatExaArr)
	..
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-22
/// Descript:     病理报告信息
/// InPut:        Oeori - 医嘱ID, userID-医生ID
/// W ##Class(web.DHCAPPPisInterface).GetPisItemContent("136||11","5083")
ClassMethod GetPisItemContent(Oeori As %String, userID As %String, TmpPatExaArr As %String) As %String
{
	n (Oeori, userID, TmpPatExaArr)
	s PisID=$o(^DHCAPPPM(0,"OrdItem",Oeori,""))
	Q:PisID="" ""
	Q:$p(^DHCAPPPM(PisID),"^",9)'="Y" ""	   /// 申请状态
	s StatsObj=##Class(web.DHCAPPInterface).GetExaReqItmStatusObj(Oeori,"")  //统一改为取平台方法
	q:StatsObj=""
	s ResStats = StatsObj.Status
	q:ResStats'="RP"   //RP是报告
	
	//s PisNo=$p(^DHCAPPPM(PisID),"^",13)        /// 病理号
	;s PisNo=##class(web.DHCAPPSeePatPacs).GetTmInfoByOrderRowId(Oeori)
	s PisNo = ##class(web.DHCAPPSeePatPacs).GetStudyNoByORORIAndPart(Oeori,"")
	//s:PisNo'="" PisNo=$p(PisNo,"^",2)
	s arcimid=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1),"^",2)
	Q:arcimid="" ""
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s ItemLabel=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
	s EpisodeID=$p(^OEORD(+Oeori),"^",1)        /// 就诊ID
	s LinkUrl=##class(web.DHCAPPInterface).GetPacsPortUrlByOrd(Oeori,"",1) ;..GetRepLinkUrl(EpisodeID,Oeori,PisNo)
	s AuthDate="", AuthTime="", AuthUser="", LgID=""
	s AuthInfo = StatsObj.UpDateTime
	s AuthDate = $p(AuthInfo," ",1)
	s AuthTime = $p(AuthInfo," ",2)
	s AuthUser = StatsObj.UserName
	s ReadFlag=##class(web.DHCAPPInterface).IsReadByParams(Oeori_"^^"_userID)
	S ReportDR=""
    s ListData=Oeori_"^"_ItemLabel_"^"_PisNo_"^"_AuthDate_"^"_AuthTime_"^"_AuthUser_"^"_LinkUrl_"^"_ReadFlag_"^"_"病理"_"^"_ReportDR
	s TmpPatExaArr(Oeori)=ListData
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-22
/// Descript:     检查报告信息
/// InPut:        Oeori - 医嘱ID, userID-医生ID
/// W ##Class(web.DHCAPPPisInterface).GetExaItemContent("122||115","4634")
ClassMethod GetExaItemContent(Oeori As %String, userID As %String, TmpPatExaArr As %String) As %String
{
	n (Oeori, userID, TmpPatExaArr)
	s ID=$o(^DHCAPREP(0,"OrdItem",Oeori,""))
	Q:ID="" ""
	s CH=$o(^DHCAPREP(0,"OrdItem",Oeori,ID,""))   /// 检查申请医嘱项Child
	Q:CH="" ""
	Q:$p(^DHCAPREP(ID),"^",17)'="Y" ""	          /// 是否发送
	s EpisodeID=$p(^OEORD(+Oeori),"^",1)          /// 就诊ID
	s TypeDesc=##Class(web.DHCAPPExaReportQuery).GetExaReqItmCat(ID,1)
	i TypeDesc="" s TypeDesc="未知"
	Q:$p(^DHCAPREP(ID,"AR",CH),"^",7)'="" ""
	s Oeori=$p(^DHCAPREP(ID,"AR",CH),"^",3)          /// 医嘱ID
	s arcimid=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1),"^",2)
	Q:arcimid="" ""
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s ItemLabel=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  ///医嘱项名称
 	s ItemStat=##Class(web.DHCAPPExaReportQuery).GetOeoriStat(Oeori)
	Q:(ItemStat="D")||(ItemStat="C") ""   /// 临嘱 住院为撤销、门诊为停止
	i $o(^DHCAPREP(ID,"AR",CH,"PA","")) D
 	.s Sub="",StudyNo="",ReadFlag=""
	.F  s Sub=$o(^DHCAPREP(ID,"AR",CH,"PA",Sub)) Q:Sub=""  D
	..s PartID=+$p(^DHCAPREP(ID,"AR",CH,"PA",Sub),"^",1) ///部位ID
	..Q:$p(^DHCAPREP(ID,"AR",CH,"PA",Sub),"^",2)="D"
	..s PartDesc=$p($g(^DHCAPPART(PartID)),"^",2)
	..s SNo=""
	..s RegRowid = ##Class(web.DHCRisResApptSchudleSystem).getRegRowid(Oeori_"^"_PartID)
	..s:RegRowid'="" SNo=$p(^DHCPACRegInfo(RegRowid),"^",2)         //检查号
	..q:SNo=""
	..s StudyNo = SNo
	..s StatsObj=##Class(web.DHCAPPInterface).GetExaReqItmStatusObj(Oeori,SNo)  //统一改为取平台方法
	..q:StatsObj=""
	..s ResStats = StatsObj.Status
	..q:ResStats'="RP"   //RP是报告
    ..s ReadFlag=##class(web.DHCAPPInterface).IsReadByParams(Oeori_"^"_SNo_"^"_userID) ;##class(web.DHCAPPSeePatPacs).IsReadByParams(Oeori_"^"_SNo_"^"_userID)  /// 是否阅读
    ..s AuthDate="",AuthTime="",AuthUser=""
    ..s AuthInfo = StatsObj.UpDateTime
	..s AuthDate = $p(AuthInfo," ",1)
	..s AuthTime = $p(AuthInfo," ",2)
	..s AuthUser = StatsObj.UserName
	..s LinkUrl=##class(web.DHCAPPInterface).GetPacsPortUrlByOrd(Oeori,PartID,1)    ;..GetRepLinkUrl(EpisodeID,Oeori,SNo)
	..S ReportDR=""
    ..s ListData=Oeori_"^"_ItemLabel_"^"_StudyNo_"^"_AuthDate_"^"_AuthTime_"^"_AuthUser_"^"_LinkUrl_"^"_ReadFlag_"^"_"检查"_"^"_ReportDR
	..s TmpPatExaArr(SNo_"^"_Oeori)=ListData
	..s TmpPatExaArr(SNo_"^"_Oeori,PartID)=PartDesc
	E  D
	.s SNo=""
	.s RegRowid=##Class(web.DHCRisResApptSchudleSystem).getRegRowid(Oeori)
	.s:RegRowid'="" SNo=$p(^DHCPACRegInfo(RegRowid),"^",2)         //检查号
	.s:SNo="" SNo = ##class(web.DHCEkg.GetEkgReportState).GetEkgStudyId(Oeori)   //心电的检查号获取
	.q:SNo=""
	.s StudyNo = SNo
	.s StatsObj=##Class(web.DHCAPPInterface).GetExaReqItmStatusObj(Oeori,SNo)  //统一改为取平台方法
	.q:StatsObj=""
	.s ResStats = StatsObj.Status
	.q:ResStats'="RP"   //RP是报告
	.s AuthDate="",AuthTime="",AuthUser=""
	.s AuthInfo = StatsObj.UpDateTime
	.s AuthDate = $p(AuthInfo," ",1)
	.s AuthTime = $p(AuthInfo," ",2)
	.s AuthUser = StatsObj.UserName
    .s ReadFlag=##class(web.DHCAPPSeePatPacs).IsReadByParams(Oeori_"^"_SNo_"^"_userID)  /// 是否阅读
    .s LinkUrl=##class(web.DHCAPPInterface).GetPacsPortUrlByOrd(Oeori,"",1) ;..GetRepLinkUrl(EpisodeID,Oeori,SNo)
    .S ReportDR=""
    .s ListData=Oeori_"^"_ItemLabel_"^"_SNo_"^"_AuthDate_"^"_AuthTime_"^"_AuthUser_"^"_LinkUrl_"^"_ReadFlag_"^"_"检查"_"^"_ReportDR
	.s TmpPatExaArr(SNo_"^"_Oeori)=ListData

	///相同检查号项目合并显示
	s SNo=""
	F  s SNo=$o(TmpPatExaArr(SNo)) Q:SNo=""  D
	.s Oeori="", LabItemLabel="",LabOeori=""
	.F  s Oeori=$o(TmpPatExaArr(SNo,Oeori)) Q:Oeori=""  D
	..s ItemLabel=$g(TmpPatExaArr(SNo,Oeori))
	..s LabItemLabel=$s(LabItemLabel'="":LabItemLabel_","_ItemLabel,1:ItemLabel)
	..k TmpPatExaArr(SNo,Oeori)
	.i LabItemLabel'="" D
	..s $p(TmpPatExaArr(SNo),"^",2)=$p(TmpPatExaArr(SNo),"^",2)_"["_LabItemLabel_"]"
	.
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-22
/// Descript:     检验报告信息
/// InPut:        Oeori - 医嘱ID, userID-医生ID
/// W ##Class(web.DHCAPPPisInterface).GetLabItemContent("92||3","4634")
ClassMethod GetLabItemContent(Oeori As %String, userID As %String, TmpPatExaArr As %String) As %String
{
	n (Oeori, userID, TmpPatExaArr)
	k TmpPisPatExaArr
	s EpisodeID=$p(^OEORD(+Oeori),"^",1)        /// 就诊ID
	s arcimid=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),1),"^",2)
	Q:arcimid="" ""
	Q:'##Class(web.DHCLabOrder).isLabTS(arcimid) ""
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s ItemLabel=$p(^ARCIM(itmmastid,itmmastver,1),"^",2)  /// 医嘱项名称
	s LabEpisode=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",20)         /// 检验号
	Q:LabEpisode="" ""
	s LabContent=..GetLabContent(Oeori, userID)  /// 检验报告信息
	s AuthDate=$p(LabContent,"^",3),AuthTime=$p(LabContent,"^",4),AuthUser=$p(LabContent,"^",5),VisitNumberReportDR=$p(LabContent,"^",7)
	s ReadFlag = ##class(web.DHCAPPInterface).IsReadByParams(Oeori_"^^"_userID)
	//s LinkUrl="jquery.easyui.dhclabreport.csp?VisitNumberReportDR='"_VisitNumberReportDR
	s LinkUrl="VisitNumberReportDR="_VisitNumberReportDR ;..GetRepLinkUrl(EpisodeID,Oeori,LabEpisode)
	s ListData=Oeori_"^"_ItemLabel_"^"_LabEpisode_"^"_AuthDate_"^"_AuthTime_"^"_AuthUser_"^"_LinkUrl_"^"_ReadFlag_"^"_"检验"_"^"_VisitNumberReportDR
	s TmpPisPatExaArr(LabEpisode)=ListData
	s TmpPisPatExaArr(LabEpisode,Oeori)=ItemLabel
	
	///相同检查号项目合并显示
	s LabNo=""
	F  s LabNo=$o(TmpPisPatExaArr(LabNo)) Q:LabNo=""  D
	.s Oeori="", LabItemLabel="",LabOeori=""
	.F  s Oeori=$o(TmpPisPatExaArr(LabNo,Oeori)) Q:Oeori=""  D
	..s ItemLabel=$g(TmpPisPatExaArr(LabNo,Oeori))
	..s LabItemLabel=$s(LabItemLabel'="":LabItemLabel_"+"_ItemLabel,1:ItemLabel)
	..s LabOeori=$s(LabOeori'="":LabOeori_","_Oeori,1:Oeori)
	.s $p(TmpPisPatExaArr(LabNo),"^",1)=LabOeori
	.s $p(TmpPisPatExaArr(LabNo),"^",2)=LabItemLabel
	.s TmpPatExaArr(LabNo)=$g(TmpPisPatExaArr(LabNo))
	Q ""
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-22
/// Descript:     检验报告信息
/// InPut:        PisID - 病理申请单ID
/// W ##Class(web.DHCAPPPisInterface).GetLabContent("92||3","4634")
ClassMethod GetLabContent(Oeori As %String, userID As %String) As %String
{
	n (Oeori, userID)
	s EpisodeID=$p(^OEORD(+Oeori),"^",1)  /// 就诊ID
	s AdmLocID=$p(^PAADM(EpisodeID),"^",4)
	s HospID="",HospitalCode=""
	i AdmLocID'="" s HospID=$p(^CTLOC(AdmLocID),"^",22)
	i HospID="" s HospitalCode=$p(^CT("HOSP",HospID),"^",1)
	//标本类型
	s SpecDr=$o(^OEORD(+Oeori,"I",$p(Oeori,"||",2),"SPEC",""),-1)
	s (SpecCode,SpecName)=""
	i $l(SpecDr) s SpecCode=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),"SPEC",SpecDr),"^",1)
	i $l(SpecCode) s SpecName=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(SpecCode,HospitalCode),$c(2),2)
	//报告ID
	s LabTestSetRow=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",35)
	s LabTestSetRow=$tr(LabTestSetRow,$c(0))
	s VisitnumberReportDR="",AuthDate="",AuthTime=""
	i $l(LabTestSetRow) s VisitnumberReportDR=$lg($g(^dbo.RPVisitNumberTestSetD(LabTestSetRow)),11)
	Q:VisitnumberReportDR="" ""
	s SplitStatus=$lg($g(^dbo.RPVisitNumberReportD(VisitnumberReportDR)),44)
	Q:SplitStatus="2" ""
	///审核日期
	s AuthUser=""
	s AuthDate=$lg($g(^dbo.RPVisitNumberReportD(VisitnumberReportDR)),19)
	s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(VisitnumberReportDR)),20)
	/// 审核人
	s AuthUserID=$lg($g(^dbo.RPVisitNumberReportD(VisitnumberReportDR)),21)
	i AuthUserID'="" D
	.s AuthUser=$lg($g(^dbo.SYSUserD(AuthUserID)),3)
	i $l(AuthTime) s AuthTime=..%ZT(AuthTime)
	i $l(AuthDate) s AuthDate=$e(AuthDate,1,4)_"-"_$e(AuthDate,5,6)_"-"_$e(AuthDate,7,8)
	//阅读标记
	s ResultStatus=$lg($g(^dbo.RPVisitNumberReportD(VisitnumberReportDR)),22)
	s ReadFlag="N"
	i ResultStatus=3 s ReadFlag=##Class(DHCLIS.DHCReportControl).ReportViewLog(VisitnumberReportDR,userID,HospID)
	i ReadFlag=1 s ReadFlag="Y"
	Q SpecCode_"^"_SpecName_"^"_AuthDate_"^"_AuthTime_"^"_AuthUser_"^"_ReadFlag_"^"_VisitnumberReportDR
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-22
/// Descript:     取病人检查项目列表【Portal组调用】
/// InPut:        EpisodeID - 就诊ID,  HospID - 医院ID
/// OutPut:       申请单状态:医嘱ID:医嘱描述:标本/部位:业务时间(申请时间\登记时间\报告时间):申请类型:报告ID:申请日期:申请时间:申请单号:检查号: 
/// D ##Class(%ResultSet).RunQuery("web.DHCAPPPisInterface","QryPatExaReqPortal","2018-12-26","2018-12-26","2526","")
Query QryPatExaReqPortal(StartDate As %String, EndDate As %String, LgDocCode As %String, IsReadFalg As %String) As websys.Query(ROWSPEC = "PatientID:%String,EpisodeID:%String,PatNo:%String,PatName:%String,PatAge:%String,PatSex:%String,PatLoc:%String,PatWard:%String,PatBed:%String,MedNo:%String,Oeori:%String,ItemLabel:%String,StudyNo:%String,AuthDate:%String,AuthTime:%String,AuthUser:%String,LinkUrl:%String,ReadFlag:%String,StudyType:%String,ReportID:%String")
{
}

ClassMethod QryPatExaReqPortalExecute(ByRef qHandle As %Binary, StartDate As %String, EndDate As %String, LgDocCode As %String, IsReadFalg As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    k TmpPatExaArr
	
	/// 医生检查列表
	D ..GetDocExaListContent(StartDate, EndDate, LgDocCode, .TmpPatExaArr)

    s index=""
	F  s index=$o(TmpPatExaArr(index))  Q:index=""  D
	.s ListData=$g(TmpPatExaArr(index))
	.Q:ListData=""
	.s Oeori=$p(ListData,"^",1)    /// 医嘱ID
	.s AuthUser=$p(ListData,"^",6) /// 报告人
	.Q:AuthUser=""
	.s ReadFlag=$p(ListData,"^",8) /// 是否阅读
	.Q:(IsReadFalg="Y")&(IsReadFalg'=ReadFlag)
	.Q:(IsReadFalg="N")&(ReadFlag="Y")
	.s EpisodeID=$p(^OEORD(+Oeori),"^",1)        /// 就诊ID
	.s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	.s PatLoc=""
	.s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		 	   /// 就诊科室
	.s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	.s PatWard=""
	.s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	           /// 病区ID
	.s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2)  /// 病区描述
	.s BedId=$p(^PAADM(EpisodeID),"^",73) 				   /// 床号ID
    .s PatBed=""
    .s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1) /// 床号描述
    .s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	.s ErrMsg=""
	.s MedNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,AdmType,.ErrMsg) ;病历号
	.s ListData=PatientID_"^"_EpisodeID_"^"_PatNo_"^"_PatName_"^"_PatAge_"^"_PatSex_"^"_PatLoc_"^"_PatWard_"^"_PatBed_"^"_MedNo_"^"_ListData
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpPatExaArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-22
/// Descript:     病理申请业务时间点
/// InPut:        PisID - 病理申请单ID
/// W ##Class(web.DHCAPPPisInterface).GetPisBusTime("344")
ClassMethod GetPisBusTime(PisID As %String) As %String
{
	n (PisID)
	s ID=+$p(^DHCAPPPM(PisID),"^",21)         /// 结果状态ID
	Q:ID="" ""
	s LgID="", BusDate="", BusTime=""
	F  s LgID=$o(^DHCAPPRL(0,"TypePointer","P",PisID,LgID)) Q:(LgID="")||(BusDate'="")  D
	.Q:$p(^DHCAPPRL(LgID),"^",6)'=ID
	.s BusDate=$p(^DHCAPPRL(LgID),"^",7)
	.s BusTime=$p(^DHCAPPRL(LgID),"^",8)
	.
	s:BusDate'="" BusDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(BusDate)
	s:BusTime'="" BusTime=..%ZT(BusTime,2)
	Q BusDate_" "_BusTime
}

/// Creator:      bianshuai
/// CreateDate:   2018-03-22
/// Descript:     检查分类描述
/// InPut:        PisID - 病理申请单ID
/// W ##Class(web.DHCAPPPisInterface).GetAppExaCat("344")
ClassMethod GetAppExaCat(arcimid As %String) As %String
{
	n (arcimid)
	Q:arcimid="" ""
	s itmmastid=$p(arcimid,"||",1)
	s itmmastver=$p(arcimid,"||",2)
	s itemCatID=$p(^ARCIM(itmmastid,itmmastver,1),"^",10)   ///医嘱子类
	Q:itemCatID="" ""
	s itmArcCatID=$o(^DHCAPARCCA(0,"O",itemCatID,""))
	Q:itmArcCatID="" ""
	s itmArcCatDesc=$p(^DHCAPARCCA(itmArcCatID),"^",2)  	/// 检查分类描述
	Q itmArcCatDesc
}

/// Creator:      yangyongtao
/// CreateDate:   2018-05-04
/// Descript:   取PAC组检查报告链接
/// w ##Class(web.DHCAPPPisInterface).GetRepLinkUrl("315","293||153","L")
ClassMethod GetRepLinkUrl(EpisodeID As %String, Oeori As %String, SNo As %String) As %String
{
	n (EpisodeID, Oeori, SNo)
	s $zt="LinkErrMsg2"
	s recLoc=""
	i Oeori'="" s recLoc=$p(^OEORD(+Oeori,"I",$p(Oeori,"||",2),3),"^",6) /// 接收科室
	s PatientID=$p(^PAADM(EpisodeID),"^",1)          /// 病人ID
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1)      /// 登记号
	s LinkUrl=##Class(web.DHCEMSeePatPacs).GetPacsOpenPortInfo(recLoc)
	S PatNoFlag=$p(LinkUrl,"^",2) /// 登记号标识
	S ParamNo=$p(LinkUrl,"^",3)   /// 登记号
	S StuFlag=$p(LinkUrl,"^",4)   /// 检查号标识
	S ParamSN=$p(LinkUrl,"^",5)   /// 检查号
	S OeFlag=$p(LinkUrl,"^",6)    /// 医嘱号标识  
	S ParamOe=$p(LinkUrl,"^",7)   /// 医嘱号	
	s LinkUrl=$p(LinkUrl,"^",1)
	Q:LinkUrl="" ""
	s LinkUrl=$s(LinkUrl["?":LinkUrl,1:LinkUrl_"?")
	i PatNoFlag="Y" D
	.//s LinkUrl=LinkUrl_"&"_ParamNo_"="_PatNo
	i StuFlag="Y" D
	.//s LinkUrl=LinkUrl_"&"_ParamSN_"="_SNo
	i OeFlag="Y" D
	.//s LinkUrl=LinkUrl_"&"_ParamOe_"="_Oeori
	i (LinkUrl["RISWeb3")||(LinkUrl["EKG") D
	.s LinkUrl=LinkUrl_"&"_"LID="_recLoc_"&SID="_SNo_"&OID="_Oeori_"&USERID="
	i $o(^DHCAPPPM(0,"OrdItem",Oeori,"")) D
	.s LinkUrl=LinkUrl_"&dept="_recLoc_"&patID="_PatNo_"&OrderID="_Oeori_"&Rpt=1"

	Q LinkUrl

LinkErrMsg2
    Q ""
}

/// Creator :  QQA
/// Descript:  修改检查检验病理的申请状态调用集成平台方法:用于申请单界面发送时调用
/// Input:     StatusCode：状态代码  Arreqid：申请单ID
/// w ##Class(web.DHCAPPPisInterface).UpdExaReqStatus("AP","341")
ClassMethod UpdPisReqStatus(StatusCode As %String, PisID As %String, UserID As %String) As %String
{
	n (StatusCode,PisID,UserID)
	s:UserID="" UserID = $p(^DHCAPPPM(PisID),"^",5)
	s UserCode=$p($g(^SSU("SSUSR",+UserID)),"^",1)
	s UserName=$p($g(^SSU("SSUSR",+UserID)),"^",2)
	s DataList=[]
	
	s PisNo=$p(^DHCAPPPM(PisID),"^",13) 
	s CH=""
	F  s CH=$o(^DHCAPPPM(PisID,"A",CH)) Q:(CH="")  D
	.s Oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)   /// 检查申请医嘱ID
	.s Position=""                          
	.
	.s DymObj={}
	.s DymObj.OEOrdItemID =Oeori
	.s DymObj.Position =Position
	.s DymObj.ExamID =PisNo
	.s DymObj.Status =StatusCode
	.s DymObj.UserID =UserCode
	.s DymObj.UserName =UserName
	.s DymObj.UpDateTime =$zd(+$h,3)_" "_..%ZT(..%SysTime(),2)
	.s DymObj.SourceSystem ="HIS"
	.d DataList.%Push(DymObj)
	s Steam = ##class(%Stream.GlobalCharacter).%New()
	d Steam.Write(DataList.%ToJSON())
	s Ret = ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",Steam)
	Q 0
}

/// Creator :  qqa 
/// Descript:  修改检查检验病理的申请状态调用集成平台方法
/// Input:     StatusCode：状态代码  ArReqItmId：申请单子表ID  InPartID：部位ID  LgParam：UserID
/// w ##Class(web.DHCAPPPisInterface).UpdExaReqItmStatus("OCA","295||1","",4634^266^104)
ClassMethod UpdExaReqItmStatus(StatusCode, PisItmID, UserID) As %String
{
	n (StatusCode, PisItmID,InPartID,UserID)
	s UserCode=$p($g(^SSU("SSUSR",+UserID)),"^",1)
	s UserName=$p($g(^SSU("SSUSR",+UserID)),"^",2)
	s DataList=[]
	s PisID = +PisItmID
	s CH = $p(PisItmID,"||",2)
	s Oeori=$p(^DHCAPPPM(PisID,"A",CH),"^",3)   /// 检查申请医嘱ID
	s PisNo=$p(^DHCAPPPM(PisID),"^",13)   
	s Position=""                          
	s DymObj={}
	s DymObj.OEOrdItemID =Oeori
	s DymObj.Position =Position
	s DymObj.ExamID =PisNo
	s DymObj.Status =StatusCode
	s DymObj.UserID =UserCode
	s DymObj.UserName =UserName
	s DymObj.UpDateTime =$zd(+$h,3)_" "_..%ZT(..%SysTime(),2)
	s DymObj.SourceSystem ="HIS"
	d DataList.%Push(DymObj)
	s Steam = ##class(%Stream.GlobalCharacter).%New()
	d Steam.Write(DataList.%ToJSON())
	s Ret = ##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",Steam)
	q 0
}

/// Creator :  qqa 
/// Descript:  修改检查检验病理的申请状态调用集成平台方法
/// Input:     StatusCode：状态代码  ArReqItmId：申请单子表ID  InPartID：部位ID  LgParam：UserID
/// w ##Class(web.DHCAPPPisInterface).UpdExaReqItmStatus("OCA","295||1","",4634)
ClassMethod UpdExaReqItmStatusOrd(StatusCode, OrdItmID, UserID) As %String
{
	n (StatusCode, OrdItmID,InPartID,UserID)
	s PisID=$o(^DHCAPPPM(0,"OrdItem",OrdItmID,""))    /// 检查申请ID
	Q:PisID="" ""
	s CH=$o(^DHCAPPPM(0,"OrdItem",OrdItmID,PisID,"")) /// 检查申请医嘱项Child
	Q:CH="" ""
	s PisItmID = PisID_"||"_CH
	s Ret = ##Class(web.DHCAPPPisInterface).UpdExaReqItmStatus(StatusCode,PisItmID,UserID)
	q Ret
}

/// Descript: 取固定液数据
/// w ##Class(web.DHCAPPPisInterface).GetPisPatInfDis("")
ClassMethod GetPisPatActive(PisID As %String) As %String
{
	n (PisID)
	s mData=""
	s CH=$o(^DHCAPPPM(PisID,"S",""))
	Q:CH="" ""
	s FixActiveID=$p(^DHCAPPPM(PisID,"S",CH),"^",11)      /// 固定液
	q:FixActiveID="" ""
	s FixActiveDesc=$p(^DHCAPPFIX(FixActiveID),"^",2)	
    	s mData=FixActiveDesc
	Q mData
}

/// Descript: 获取病理申请信息
/// Input：	 医嘱ID
/// Output:   html
/// w ##class(web.DHCAPPPisInterface).GetPisRepHtmlContent("481||14")
ClassMethod GetPisRepHtmlContent(Oeorid As %String) As %String
{
	n (Oeorid)
	q:Oeorid="" ""
	s PisID=$O(^DHCAPPPM(0,"OrdItem",Oeorid,""))
	s ItemmasterId=$p(^OEORD($p(Oeorid,"||",1),"I",$p(Oeorid,"||",2),1),"^",2)
	s ItemmasterDesc=$p(^ARCIM($p(ItemmasterId,"||",1),$p(ItemmasterId,"||",2),1),"^",2)
	/// 病人信息
	s EpisodeID=$p(^DHCAPPPM(PisID),"^",1)		/// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",PatientID,EpisodeID)
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s PatWard=""
	s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	/// 病区ID
	s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	s CreatDate=$p(^DHCAPPPM(PisID),"^",6)		/// 申请日期
	s:CreatDate'="" CreatDate=##Class(web.DHCAPPCommonUtil).DateLogicalToHtml(CreatDate) 
	s CreatTime=$p(^DHCAPPPM(PisID),"^",7)		/// 申请时间
	s:CreatTime'="" CreatTime=..%ZT(CreatTime,2)
	s UserID=$p(^DHCAPPPM(PisID),"^",5)	        /// 申请人
	s UserName=$p(^SSU("SSUSR",UserID),"^",2)
	s ReqLoc=""
	s ReqLocID=$p(^DHCAPPPM(PisID),"^",8)	    /// 申请科室
	s:ReqLocID'="" ReqLoc=$p(^CTLOC(ReqLocID),"^",2)
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)     /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s BedId=$p(^PAADM(EpisodeID),"^",73) 				/// 床号ID
    S PatBed=""
    s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)          /// 出生日期
	i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	s AdmType=##class(web.DHCDocOrderEntry).GetPAAdmType(EpisodeID)
	s ErrMsg=""
	s MedicareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,AdmType,.ErrMsg)  ///病案号
	s PisReqNo=$p(^DHCAPPPM(PisID),"^",4)		 		/// 申请单号
	s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	
	/// 申请单内容
	s FrostFlag=$p(^DHCAPPPM(PisID),"^",2)   /// 冰冻标志
	s EmgFlag=$p(^DHCAPPPM(PisID),"^",3)     /// 加急标志
	s PisNo=$p(^DHCAPPPM(PisID),"^",13)      /// 病理号
	s MedRecord=$p(^DHCAPPPM(PisID),"^",14)  /// 临床病历
	s SupInstru=$p(MedRecord,"[next]",1)     /// 补充说米
	s PatPreHis=$p(MedRecord,"[next]",2)     /// 现病史
	s MedDiag=$p(^DHCAPPPM(PisID),"^",15)    /// 临床诊断
	s HepatitisB=$p(^DHCAPPPM(PisID),"^",16) /// 乙肝病史
	s OperRes=$p(^DHCAPPPM(PisID),"^",17)    /// 手术所见
	s InfDisHis=$p(^DHCAPPPM(PisID),"^",18)  /// 传染病史
	s FoundDate=$p(^DHCAPPPM(PisID),"^",19)  /// 首次发现人乳头瘤病毒时间
	s:FoundDate'="" FoundDate=$zd(FoundDate,3)
	s PisType=$p(^DHCAPPPM(PisID),"^",20)    /// 申请单类型
	s APMedication=$p(^DHCAPPPM(PisID),"^",28)  ///药物治疗及剂量
	s APPreResult=$p(^DHCAPPPM(PisID),"^",22)  ///既往检查日期及结果
	s FamilyHistory=$p(^DHCAPPPM(PisID),"^",26)  ///家族史
	s Nutriture=$p(^DHCAPPPM(PisID),"^",27)  ///营养状况 
	s LastHPVDate=$p(APPreResult,"[next]",1)
	s LastHPVFlag=$p(APPreResult,"[next]",2)
	i LastHPVFlag'="" s LastHPVFlag=$s(LastHPVFlag="minus":"阳性","plus":"阴性")
	s LastResult=$p(APPreResult,"[next]",3)
	s PisArcList=##Class(web.DHCAppPisMaster).GetPisArc(PisID)     /// 病理申请医嘱项目内容
	s ItemDesc=$p(PisArcList,"^"),LocID=$p(PisArcList,"^",2),LocDesc=$p(PisArcList,"^",3),arcimid=$p(PisArcList,"^",4),Oeori=$p(PisArcList,"^",5)

	s PisAutoPsy=##Class(web.DHCAppPisMaster).GetPisAutoPsy(PisID) /// 病理申请尸检信息内容
	s MorToDeaPro=$p(PisAutoPsy,"^"),DisAndTrePro=$p(PisAutoPsy,"^",2),PhyAndLabTest=$p(PisAutoPsy,"^",3),FinTakRes=$p(PisAutoPsy,"^",4)

	s PisConsult=##Class(web.DHCAppPisMaster).GetPisConsult(PisID) /// 病理申请会诊信息内容
	s InsDoc=$p(PisConsult,"^"),InsHosp=$p(PisConsult,"^",2),SpecExaRes=$p(PisConsult,"^",3),ConsNote=$p(PisConsult,"^",4),ConsStaff=$p(PisConsult,"^",5)

	s PisGynWon=##Class(web.DHCAppPisMaster).GetPisGynWon(PisID)   /// 病理申请妇科信息内容
	s LastMensDate=$p(PisGynWon,"^"),MensDate=$p(PisGynWon,"^",2),PreTimes=$p(PisGynWon,"^",3),LyTimes=$p(PisGynWon,"^",4),PauFlag=$p(PisGynWon,"^",5)
	s PauFlag=$s(PauFlag="Y":"是",1:""),PreAge=$p(PisGynWon,"^",6),LyAge=$p(PisGynWon,"^",7),CsHistory=$p(PisGynWon,"^",8)
	s SexHistory=$p(PisGynWon,"^",9),SexHistory=$s(SexHistory="Y":"是",1:""),GyHistory=$p(PisGynWon,"^",10)
    s GyTreatHistory=$p(PisGynWon,"^",11),GyTreatHistory=$s(GyTreatHistory="Y":"是",1:""), RepResultRes=$p(PisGynWon,"^",12)
    s PreFlag=$p(PisGynWon,"^",13),PreFlag=$s(PreFlag="Y":"是",1:"")
    s MenUnknown=$p(PisGynWon,"^",14),MenUnknown=$s(MenUnknown="Y":"是",1:""),AbnBleed=$p(PisGynWon,"^",15),AbnBleed=$s(AbnBleed="Y":"是",1:"")
	
	s PisCutBas=##Class(web.DHCAppPisMaster).GetPisCutBas(PisID)   /// 病理申请取材信息内容
	s SepDate=$p(PisCutBas,"^"),SepTime=$p(PisCutBas,"^",2),FixDate=$p(PisCutBas,"^",3),FixTime=$p(PisCutBas,"^",4),BLocDesc=$p(PisCutBas,"^",5)	
	s DocName=$p(PisCutBas,"^",6),Position=$p(PisCutBas,"^",7),Type=$p(PisCutBas,"^",8)
	
	s PisTumour=##Class(web.DHCAppPisMaster).GetPisTumour(PisID)   /// 病理申请肿瘤信息内容
	
	s TFoundDate=$p(PisTumour,"^"),TumPart=$p(PisTumour,"^",2),TumSize=$p(PisTumour,"^",3),TransFlag=$p(PisTumour,"^",4),TransPos=$p(PisTumour,"^",5)	
	s RadCureFlag=$p(PisTumour,"^",6),CheCureFlag=$p(PisTumour,"^",7),Remark=$p(PisTumour,"^",8),Radiation=$p(PisTumour,"^",9)

	s PisReqSpec=##Class(web.DHCAPPPrintCom).GetPisReqSpec(PisID)         /// 病理标本
	s PisTreMet=##Class(web.DHCAPPPisInterface).GetPisTreMet(PisID)       /// 治疗方式
	s PisTesItmMet=##Class(web.DHCAPPPisInterface).GetPisTesItmMet(PisID) /// 检测方法
	s PisTesDiag=##Class(web.DHCAPPPisInterface).GetPisTesDiag(PisID)     /// 临床诊断
	s PisPatRec=##Class(web.DHCAPPPisInterface).GetPisPatRec(PisID)       /// 病人病历
	s PisPatInfDis=##Class(web.DHCAPPPisInterface).GetPisPatInfDis(PisID) /// 传染病史
	s PisCutBasType=##Class(web.DHCAPPPrintCom).GetPisCutBasType(PisID)   /// 分子病理取材类型 qunianpeng 2018/2/7
	s PisTesItmMol=##Class(web.DHCAPPPrintCom).GetPisTesItmMol(PisID)	  /// 分子病理检测项目 qunianpeng 2018/2/7
	s FixActive=##Class(web.DHCAPPPisInterface).GetPisPatActive(PisID)  ///病历申请标本固定液(活检病历用)
	i PisTesDiag="" s PisTesDiag=MedDiag
	i PisTesDiag="" s PisTesDiag=PatDiagDesc
	s Constyle="",Cytstyle="",Livstyle="",Tctstyle=""
	s RepTypeCode=$p(^DHCAPPPM(PisID),"^",20)							  ///申请单类型
	i RepTypeCode="LIV" s Livstyle="display:none"
	i RepTypeCode="CYT" s Cytstyle="display:none"
	i RepTypeCode="CON" s Constyle="display:none"
	i RepTypeCode="TCT" s Tctstyle="display:none"
	s ExaReqTitle=$s(RepTypeCode="LIV":"组织活检",RepTypeCode="CYT":"细胞学原理",RepTypeCode="CON":"院外会诊",RepTypeCode="TCT":"TCT、HPV检测申请",1:"")
	s ListData="<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Transitional//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'>"
	s ListData=ListData_"<html xmlns='http://www.w3.org/1999/xhtml'>"
	s ListData=ListData_"<head>"
	s ListData=ListData_"<meta http-equiv='Content-Type' content='text/html; charset=utf-8' />"
	s ListData=ListData_"<title>病理申请</title>"
	s ListData=ListData_"</head>"
	s ListData=ListData_"<body>"
	s ListData=ListData_"<div style='margin:0 auto; width:900px; height:640px; font-family: "_"宋体"_";font-size: 14px;'>"
	s ListData=ListData_"<div style='width:100%; text-align:center; '>"
	s ListData=ListData_"<h2 style='padding: 0; margin: 0; line-height: 30px; '>"_ExaReqTitle_"</h2>"
	s ListData=ListData_"</div>"
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>病人基本信息</span>"
	s ListData=ListData_"<div style='margin:5px 5px'>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>姓名:<span style='padding-left:10px;'>"_PatName_"</span></span>"
	s ListData=ListData_"<span style='margin:0 20px;display:inline-block;'>性别:<span style='padding-left:10px;'>"_PatSex_"</span></span>"
	s ListData=ListData_"<span style='margin:0 20px;display:inline-block;'>年龄:<span style='padding-left:10px;'>"_PatAge_"</span></span>"
	s ListData=ListData_"<span style='margin:0 20px;display:inline-block;'>登记号:<span style='padding-left:10px;'>"_PatNo_"</span></span>"
	s ListData=ListData_"<span style='margin:0 20px;display:inline-block;'>费别:<span style='padding-left:10px;'>"_BillType_"</span></span>"
	s ListData=ListData_"<span style='margin:0 20px;display:inline-block;'>床号:<span style='padding-left:10px;'>"_PatBed_"</span></span>"
	s ListData=ListData_"</div>" //病人基本信息
	s ListData=ListData_"</div>"  //div边框	
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>申请信息</span>"
	s ListData=ListData_"<div style='margin:5px 5px'>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>医嘱名称:<span style='padding-left:10px;'>"_ItemmasterDesc_"</span></span>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>申请科室:<span style='padding-left:10px;'>"_ReqLoc_"</span></span>"
	s ListData=ListData_"<span style='margin:0 20px;display:inline-block;'>申请医生:<span style='padding-left:10px;'>"_UserName_"</span></span>"
	s ListData=ListData_"<span style='margin:0 20px;display:inline-block;'>申请日期:<span style='padding-left:10px;'>"_CreatDate_"</span></span>"
	s ListData=ListData_"</div>"  //申请信息
	s ListData=ListData_"</div>"  //div边框	
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;"_Constyle_"'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>妇科信息</span>"
	s ListData=ListData_"<div style='margin:5px;'>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>现病史:<span style='padding-left:10px;'>"_PatPreHis_"</span></span><br>"
	s ListData=ListData_"<div style='"_Cytstyle_"'>"
	s ListData=ListData_"<span style='margin:20px 10px;'>手术史:<span style='padding-left:10px;'>"_OperRes_"</span></span><br>"
	s ListData=ListData_"<span style='margin:10 0px;display:inline-block;'>月经史</span><br>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>末次月经:<span style='padding-left:10px;'>"_MensDate_"</span></span>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>不详:<span style='padding-left:10px;'>"_MenUnknown_"</span></span>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>子宫异常出血:<span style='padding-left:10px;'>"_AbnBleed_"</span></span>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>绝经:<span style='padding-left:10px;'>"_PauFlag_"</span></span>"	
	s ListData=ListData_"</div>"
	s ListData=ListData_"</div>"  //妇科信息
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;"_Constyle_Cytstyle_Livstyle_"'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>非妇科综合信息</span>"
	s ListData=ListData_"<div style='margin:5px 20px'>"_PisPatRec_"</div>"
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;"_Constyle_Cytstyle_Livstyle_"'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>补充说明</span>"
	s ListData=ListData_"<div style='margin:5px 20px'>"_SupInstru_"</div>"
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;"_Constyle_Cytstyle_"'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>取材信息</span>"
	s ListData=ListData_"<div style='margin:5px 5px'>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>取材日期:<span style='padding-left:10px;'>"_SepDate_"</span></span>"
	s ListData=ListData_"<span style='margin:10px 10px;'>取材科室:<span style='padding-left:10px;'>"_BLocDesc_"</span></span>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>取材医生:<span style='padding-left:10px;'>"_DocName_"</span>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>送检医生签字:<span style='padding-left:10px;'>"_DocName_"</span>"
	s ListData=ListData_"</div>"  //取材信息
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>标本信息</span>"
	s ListData=ListData_"<div style='margin:5px 5px'>"_PisReqSpec_"</div>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;"_Constyle_Cytstyle_Tctstyle_"'>固定液</span>"
	s ListData=ListData_"<div style='margin:5px 5px'>"_FixActive_"</div>"
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;"_Constyle_Cytstyle_Tctstyle_"'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>药物治疗及剂量</span>"
	s ListData=ListData_"<div style='margin:5px 5px'>"_APMedication_"</div>"
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;"_Constyle_Cytstyle_Tctstyle_"'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>传染病史</span>"
	s ListData=ListData_"<div style='margin:5px 5px'>"_PisPatInfDis_"</div>"
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;"_Constyle_Cytstyle_Tctstyle_"'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>肿瘤信息</span>"
	s ListData=ListData_"<div style='margin:5px 5px'>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>发现日期:<span style='padding-left:10px;'>"_TFoundDate_"</span></span>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>肿瘤原发部位:<span style='padding-left:10px;'>"_TumPart_"</span></span>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>肿瘤大小:<span style='padding-left:10px;'>"_TumSize_"</span></span>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>有无转移:<span style='padding-left:10px;'>"_TransFlag_"</span></span>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>转移部位:<span style='padding-left:10px;'>"_TransPos_"</span></span><br>"
	s ListData=ListData_"<span style='margin:10px 10px;display:inline-block;'>曾否放疗:<span style='padding-left:10px;'>"_RadCureFlag_"</span></span>"
	s ListData=ListData_"<span style='margin:10px 10px;display:inline-block;'>曾否化疗:<span style='padding-left:10px;'>"_CheCureFlag_"</span></span>"
	s ListData=ListData_"<span style='margin:10px 10px;display:inline-block;'>备注:<span style='padding-left:10px;'>"_Remark_"</span></span>"
	s ListData=ListData_"<span style='margin:10px 10px;display:inline-block;'>放射治疗及剂量:<span style='padding-left:10px;'>"_Radiation_"</span></span>"
	s ListData=ListData_"</div>"  //肿瘤信息
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"<div style='width:100%;height:30px; border:1px solid #000;"_Cytstyle_Livstyle_Tctstyle_"'>"
	s ListData=ListData_"<span style='margin:0 10px;display:inline-block;'>送检医生:<span style='padding-left:20px;'>"_InsDoc_"</span></span>"
	s ListData=ListData_"<span style='margin:0 10px;margin-top:5px;display:inline-block;'>送检医院:<span style='padding-left:10px;'>"_InsHosp_"</span></span>"
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;"_Cytstyle_Livstyle_Tctstyle_"'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>病理原诊断</span>"
	s ListData=ListData_"<div style='margin:5px 5px'>"_SpecExaRes_"</div>"
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;"_Cytstyle_Livstyle_Tctstyle_"'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>会诊要求</span>"
	s ListData=ListData_"<div style='margin:5px 5px'>"_ConsNote_"</div>"
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;"_Cytstyle_Livstyle_Tctstyle_"'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>会诊专家</span>"
	s ListData=ListData_"<div style='margin:5px 5px'>"_ConsStaff_"</div>"
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"<div style='width:100%; border:1px solid #000;'>"
	s ListData=ListData_"<span style='margin:5px 0px; display:inline-block;'>临床诊断</span>"
	s ListData=ListData_"<div style='margin:5px 5px'>"_PisTesDiag_"</div>"
	s ListData=ListData_"</div>"  //div边框
	s ListData=ListData_"</div>"  //总界面
	s ListData=ListData_"</body>"

	s ListData=ListData_"</html>"
	q ListData
}

/// Creator:    qujian
/// CreateDate: 2020-07-02
/// Descript:   APYN是否有有效的尸检申请单
/// InPut:      EpisodeID 就诊ID
/// OutPut:     类型代码,  0-没有，1有
/// w ##Class(web.DHCAPPPisInterface).CheckActiveAPYN("1")
ClassMethod CheckActiveAPYN(EpisodeID As %String) As %String
{
	q:EpisodeID="" 0
	s PisID=""
	s rtn=0
	for {
		s PisID=$O(^DHCAPPPM(0,"Adm",EpisodeID,PisID))
		q:PisID=""
		s APType=$P(^DHCAPPPM(PisID),"^",20)
		continue:APType'="APYN"
		s APStatus=$P(^DHCAPPPM(PisID),"^",9)
		continue:APStatus'="Y"
		s rtn=1
		}
	q rtn
}

}
