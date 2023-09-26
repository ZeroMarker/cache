Import sqluser

/// Creator: 	bianshuai
/// CreateDate: 2018-04-10
/// Descript: 	会诊申请接口类
Class web.DHCEMConsInterface Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator:    bianshuai
/// CreateDate: 2018-04-10
/// Descript:   抗生素会诊申请接口
/// InPut:      mListData - "就诊ID^申请医生ID^申请科室^简要病历^会诊目的^^^DOCA^会诊日期^会诊时间^加急(Y/N)^是否外院(Y/N)"
/// 							^外院名称^外院医师^会诊备注^联系人^联系电话^是否共享^N^$C(2)会诊科室ID^会诊医生ID^医生职称ID"
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMConsInterface).Insert("1830^10209^203^^本病人建议使用【注射用青霉素钠[400万U]】，使用目的为：治疗-内科-经验，指征：急性细菌性上呼吸道感染^DOC01^^DOCA^2019-08-27^09:48^Y^N^^^^^^^N"_$c(2)_"2^501^4")
ClassMethod Insert(mListData As %String) As %String
{
	n (mListData,%session)
	
	s $ZT="ErrorMsg"
	s Err=0
	s LocID=$p(mListData,"^",3)     /// 申请科室ID
	s HospID=$p($g(^CTLOC(+LocID)),"^",22)
	s HospID=##Class(web.DHCEMCommonUtil).GetDefHospIdByTableName("DHC_EmConsDicType",HospID) //多院区改造
	s itemID=$o(^DHCEMCDI(0,"Code",$$ALPHAUP^SSUTIL4($p(mListData,"^",6)),HospID,""))
	s $p(mListData,"^",6)=itemID
	i $p(mListData,"^",11)="Y" s CsPropID=$o(^DHCEMCDI(0,"Code","02",HospID,"")) /// 会诊性质
	E  s CsPropID=$o(^DHCEMCDI(0,"Code","01",HospID,""))
	s mLocData=$p(mListData,$C(2),2), mListData=$p(mListData,$C(2),1)
	s $p(mListData,"^",20)=CsPropID
	s mListData=mListData_$C(2)_mLocData
	s LgParam=HospID_"^^^"_$p(mListData,"^",2)
	/// 插入会诊申请
	s CstID=##Class(web.DHCEMConsult).InsConsult(mListData)
	Q:CstID'>0 "-1"
	/// 发送会诊
	s CstID=##Class(web.DHCEMConsult).SendCstNo(CstID, LgParam)
	Q:CstID'>0 "-2"
	/// 发送会诊消息 短信接口
	//s Err=..SendCstMsgToDoc(CstID)
	Q Err_"^"_CstID
ErrorMsg
	Q "-99"
}

/// Creator:qqa
/// Descripts:提供个医生站用于撤销抗生素会诊
/// w ##Class(web.DHCEMConsInterface).RevCompAntiCstMas("138","4634")
ClassMethod RevCompAntiCstMas(CstID, UserID)
{
	n (CstID, UserID)
	s Ret=0
	s CsType = $P(^DHCEMCON(CstID),"^",19)
	q:CsType'="DOCA" -99
	s Ret = ##Class(web.DHCEMConsult).RevCompCstMas(CstID,"",UserID)
	q Ret
}

/// Creator:    qqa
/// CreateDate: 2018-08-03
/// Descript:   病人离院调用判断是否有未处理会诊
/// InPut:      EpisodeID - 就诊ID
/// OutPut:     未处理科室串:科室1;科室2...(多科会诊的科室内部用","分割) 0：表示没有
/// w ##Class(web.DHCEMConsInterface).GetPatNoOkConsult("51560939")
ClassMethod GetPatNoOkConsult(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s Ret=0
	s CstID=""
	F  s CstID=$o(^DHCEMCON(0,"ADM",EpisodeID,CstID)) Q:CstID=""  D
	.s CstStatId = $p(^DHCEMCON(CstID),"^",18)			 /// 申请状态ID
	.s CstStatCode=""
	.s:CstStatId'="" CstStatCode=$p(^DHCEMCONS(CstStatId),"^",2)               /// 申请状态
	.q:(CstStatCode="完成")||(CstStatCode="作废申请")||(CstStatCode="")||(CstStatCode="撤销完成")
	.s LocDesc = ##Class(web.DHCEMConsultQuery).GetConsultLocs(CstID)
	.s:Ret'="" Ret=Ret_";"_LocDesc
	.s:Ret="" Ret=LocDesc
	q Ret
}

/// Creator:    qqa
/// CreateDate: 2018-06-28
/// Descript:   抗生素会诊申请接口
/// InPut:      mListData - "就诊ID^申请医生ID^申请科室^简要病历^会诊目的^^^^会诊日期^会诊时间^加急(Y/N)^是否外院(Y/N)"
/// 							^外院名称^外院医师^会诊备注^联系人^联系电话^是否共享^会诊地点^单科多科(Y/N)^当前问题
/// 								^是否有纠纷^会诊类型(DOCA)&会诊科室ID^会诊医生ID"
/// 				Params    - "医院ID^科室ID^人员ID^安全组ID"
/// OutPut:     <0:失败，CstID:成功
/// w ##Class(web.DHCEMConsInterface).InsertAntiCst("50494346^6^696^简要病历^会诊目的^^^^2018-06-28^23:00^N^N^^^^^^Y^^N^^^DOCA&2^340^1","2^696^6^30")
ClassMethod InsertAntiCst(mListData As %String, Params As %String) As %String
{
	n (mListData,Params,%session)

	s Err=0
	s UserID = $p(Params,"^",3)
	s StatusID=##Class(web.DHCEMConsult).GetConsStatus(20)
	s IfCreateOrderByApp = ^DHCNurConsultSet("ifCreateOrderByApp")   //申请的时候是否插入医嘱
	s CsNDate=$p(mListData,"^",9)          ///会诊日期
	s CsNTime=$p(mListData,"^",10)         ///会诊时间
	s:CsNDate'="" CsNDate = $zdh(CsNDate,3)
	s:CsNDate="" CsNDate = +$h             ///会诊日期为空取当前时间   
	s CsNDate = ##class(web.DHCAPPCommonUtil).DateLogicalToHtml(CsNDate)  
	s:CsNTime="" CsNTime = $zt($p($h,",",2),2) ///会诊时间为空取当前时间
	TS
	
	/// 会诊申请
	s CstID=##Class(web.DHCEMConsult).InsConMaster(mListData)
	i CstID<0 tro
	Q:CstID<0 CstID

	/// 会诊子表
	s Site=$l(mListData,"&") //hxy 2021-03-16 第一个参数mListData含分隔符&
	s ListData=$p(mListData,"&",Site)
	;s ListData=$p(mListData,"&",2) //ed
	s Err=##Class(web.DHCEMConsult).InsConItm(CstID, ListData)
	i Err'=0 tro
	Q:Err'=0 "-11"
	
	/// 更新发送
	s Err = ##Class(web.DHCEMConsult).UpdConsStatus(CstID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-12"
	
	/// 插入医嘱
	i IfCreateOrderByApp ="Y" d
	.s Err = ##Class(web.DHCEMConsult).InsCstOeori(CstID)
	i Err'=0 tro
	Q:Err'=0 "-13"
	
	/// 插入操作日志
	s Err = ##Class(web.DHCEMConsult).InsConsLog(CstID,UserID,StatusID)
	i Err'=0 tro
	Q:Err'=0 "-14"
	
	/// 小信箱
	s Err = ##Class(web.DHCEMConsult).InsWebsysMessage(CstID,Params,"")
	i Err<0 tro
	Q:Err<0 "-15"
	TC
	Q CstID
}

/// Creator:    qqa
/// CreateDate: 2018-06-28
/// Descript:   抗生素接口通过会诊ID查询会诊科室会诊医生
/// InPut:     	CstID:会诊申请ID
/// OutPut:     会诊科室^会诊医生^会诊意见(成功)，空（未获取到数据）
/// w ##Class(web.DHCEMConsInterface).GetAntiConsultInfo("65")
ClassMethod GetAntiConsultInfo(CstID As %String) As %String
{
	n (CstID)
	q:+CstID=0 "" 
	Q:'$D(^DHCEMCON(CstID)) ""
	Q:$P(^DHCEMCON(CstID),"^",19)'="DOCA" ""  //只负者抗生素的会诊
	s Ret=""
	s CsUserID="",CsLocID=""
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 会诊医生
	.s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.s CsLocDesc=""
	.s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       /// 会诊科室
	.s:CsLocID'="" CsLocDesc=$p(^CTLOC(CsLocID),"^",2)
	s Opinion=$p(^DHCEMCON(CstID),"^",17)       /// 会诊意见
	//s CstConsDate = ##Class(web.DHCEMConsultQuery).GetCstCurStatDate(CstID)   //日期^时间
	s CstConsDate=##Class(web.DHCEMConsultQuery).GetCstNodeTime(CstID_"||1","50")  /// 完成时间
	
	s Ret = CsLocID_"^"_CsUserID_"^"_Opinion_"^"_CstConsDate
	Q Ret
}

/// Creator:    qqa
/// CreateDate: 2018-06-28
/// Descript:   抗生素查询是否同意使用抗生药物
/// InPut:     	CstID:会诊申请ID
/// OutPut:     Y:同意使用  N:不同意  "":未处理
/// w ##Class(web.DHCEMConsInterface).GetConsentAnti("63")
ClassMethod GetConsentAnti(CstID As %String) As %String
{
	n (CstID)
	q:+CstID=0 "" 
	Q:'$D(^DHCEMCON(CstID)) ""
	s StatusID = $p(^DHCEMCON(+CstID),"^",18)
	Q:StatusID="" ""
	s StatusCode = $p($g(^DHCEMCONS(StatusID)),"^",1)
	Q:(StatusCode<50)||(StatusCode=51) ""   //状态不是完成的
	Q $p($g(^DHCEMCON(CstID)),"^",35)
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-10
/// Descript:   发送抗生素会诊申请给会诊医生
/// InPut:      CstID - 会诊申请ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMConsInterface).SendCstMsgToDoc("")
ClassMethod SendCstMsgToDoc(CstID As %String) As %String
{
	n (CstID)
	s $zt="LinkErrMsg"
	s mListData=..GetCstNote(CstID)
	F i=1:1:$L(mListData,"||") D
	.D ##class(web.DHCENS.STBLL.SendMSG).sendMsg($p(mListData,"||",i))
	.
	Q 0
LinkErrMsg
    Q "-1"
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-10
/// Descript:   取抗会诊申请消息内容
/// InPut:      CstID - 会诊申请ID
/// OutPut:     消息内容，空
/// w ##Class(web.DHCEMConsInterface).GetCstNote("")
ClassMethod GetCstNote(CstID As %String) As %String
{
	n (CstID)
	s mListData=""
	s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)     /// 是否加急
	s CstCstType=$s(CstEmFlag="Y":"加急",1:"普通")
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s LocDesc=""
	.s LocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)         /// 会诊科室ID
	.s:LocID'="" LocDesc=$p(^CTLOC(LocID),"^",2)
	.s TelPhone=$p(^CTLOC(LocID),"^",40)               /// 科室电话
	.s CareProv=""
	.s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)
	.i CareProvID'="" D
	..s CareProv=$p($g(^CTPCP(+CareProvID,1)),"^",2)    /// 会诊医生
	..s TelPhone=$p($g(^CTPCP(+CareProvID,2)),"^",1)    /// 会诊医生电话
	.s PrvTp=""
	.s PrvTpID=$p(^DHCEMCON(CstID,"I",CH),"^",11)       /// 职称
	.i PrvTpID'="" s PrvTp=$p(^CT("CPT",PrvTpID),"^",2)
	.s TmpMessage=TelPhone_"^"_"有"_LocDesc_PrvTp_CstCstType_"会诊，请及时会诊。"
	.i mListData="" s mListData=TmpMessage
	.E  s mListData=mListData_"||"_TmpMessage
	Q mListData
}

/// Creator:      bianshuai
/// CreateDate:   2018-04-25
/// Descript:     取病人会诊列表【电子病历资源界面调用】
/// InPut:        EpisodeID - 就诊ID
/// OutPut:       病人ID^姓名^登记号^性别^科室^病区^费别^床号^出生日期^联系方式^地址^病案号^诊断^就诊ID^申请科室ID^申请科室^申请日期^申请时间^申请人ID^申请人^简要病历^会诊目的^要求会诊日期^要求会诊时间^要求会诊地点^是否加急^是否外院^外院名称^外院医生^备注^联系人^联系电话^会诊类型^会诊科室^会诊医生^会诊意见
/// D ##Class(%ResultSet).RunQuery("web.DHCEMConsInterface","QryPatConsList","94")
Query QryPatConsList(EpisodeID As %String) As websys.Query(ROWSPEC = "IPatientID:%String,PatName:%String,PatNo:%String,PatSex:%String,PatLoc:%String,PatWard:%String,BillType:%String,PatBed:%String,PatBod:%String,PatTelH:%String,PatAddr:%String,MedicareNo:%String,PatDiagDesc:%String,EpisodeID:%String,CstRLocID:%String,CstRLoc:%String,CstRDate:%String,CstRTime:%String,CstUserID:%String,CstRUser:%String,CstTrePro:%String,CstPurpose:%String,CstNDate:%String,CstNTime:%String,CstNPlace:%String,CstEmFlag:%String,CstOutFlag:%String,CstUnit:%String,CstDocName:%String,CstRemark:%String,CstUser:%String,CstPhone:%String,CstCstType:%String,CsLocDesc:%String,CsUser:%String,Opinion:%String")
{
}

ClassMethod QryPatConsListExecute(ByRef qHandle As %Binary, EpisodeID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    k TmpPatConsArr
    
    /// 检查申请列表
	D ..GetPatConsult(EpisodeID, .TmpPatConsArr)
	
    s index=""
	F  s index=$o(TmpPatConsArr(index))  Q:index=""  D
	.s ListData=$g(TmpPatConsArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpPatExaArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-25
/// Descript:   取病人会诊列表
/// InPut:      EpisodeID - 就诊ID
/// OutPut:     会诊内容内容，空
/// w ##Class(web.DHCEMConsInterface).GetPatConsult("")
ClassMethod GetPatConsult(EpisodeID As %String, TmpPatConsArr As %String = "") As %String
{
	n (EpisodeID, TmpPatConsArr)
	s Num=0
	s CstID=""
	F  s CstID=$o(^DHCEMCON(0,"ADM",EpisodeID,CstID)) Q:CstID=""  D
	.s EpisodeID=$p(^DHCEMCON(CstID),"^",1)   /// 就诊ID
	.s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) ///年龄
	.s PatLoc=""
	.s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	.s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	.s PatWard=""
	.s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	          /// 病区ID
	.s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	.s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	.s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	.s BedId=$p(^PAADM(EpisodeID),"^",73) 				/// 床号ID
    .s PatBed=""
    .s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    .s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	/// 电话 
	.s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	.s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	.i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	.s MedicareNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID)  ///病案号
	.s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)   /// 诊断
	.
	.s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	.s CstRLoc=""
	.s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	.s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	.s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	.s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	.s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	.s CstRUser=""
	.s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	.s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	.s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	.s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	.s CstNDate=$p(^DHCEMCON(CstID),"^",10)    /// 会诊日期
	.s CstNDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)	
	.s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	.s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	.s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	.s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	.s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	.s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	.s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	.s CstRemark=$p(^DHCEMCON(CstID),"^",27)  /// 备注
	.s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	.s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	.s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	.s CstCstType=$s(CstEmFlag="Y":"加急",1:"普通")
	.s CstUserID=$p(^DHCEMCON(CstID),"^",14)  /// 审核人
	.s CH=""
	.F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	..s ItmSta=$p(^DHCEMCON(CstID,"I",CH),"^",6)         /// 子表状态
	..s ItmStaCode=$p($g(^DHCEMCONS(+ItmSta)),"^",1)     /// 子表状态Code
	..q:(ItmStaCode="")!(ItmStaCode=22)
	..s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 会诊医生
	..s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	..s CsUser=""
	..s:CsUserID'="" CsUser=$p(^SSU("SSUSR",CsUserID),"^",2)
	..s CsLocDesc=""
	..s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       /// 会诊科室
	..s:CsLocID'="" CsLocDesc=$p(^CTLOC(CsLocID),"^",2)
	..s Opinion=$p(^DHCEMCON(CstID,"I",CH),"^",4)       /// 会诊意见
	..//Q:Opinion=""
	..s Num=Num+1
	..s ListData=PatientID_"^"_PatName_"^"_PatNo_"^"_PatSex_"^"_PatLoc_"^"_PatWard_"^"_BillType_"^"_PatBed_"^"_PatBod_"^"_PatTelH_"^"_PatAddr_"^"_MedicareNo_"^"_PatDiagDesc
    ..s ListData=ListData_"^"_EpisodeID_"^"_CstRLocID_"^"_CstRLoc_"^"_CstRDate_"^"_CstRTime_"^"_CstUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose_"^"_CstNDate_"^"_CstNTime
    ..s ListData=ListData_"^"_CstNPlace_"^"_CstEmFlag_"^"_CstOutFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser_"^"_CstPhone_"^"_CstCstType_"^"_CsLocDesc_"^"_CsUser_"^"_Opinion
	..s TmpPatConsArr(Num)=ListData
	.
    Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2018-06-21
/// Descript:   自动生成MDT会诊申请接口
/// InPut:      mListData - "就诊ID^申请医生ID^申请科室^简要病历^会诊目的^^^^会诊日期^会诊时间^加急(Y/N)^是否外院(Y/N)"
/// 							^外院名称^外院医师^会诊备注^联系人^联系电话^是否共享&会诊科室ID^会诊医生ID"
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMConsInterface).InsMDTConsult("")
ClassMethod InsMDTConsult(mListData As %String) As %String
{
	n (mListData)
	/// 插入会诊申请
	s CstID=##Class(web.DHCEMConsult).InsConsult(mListData)
	Q:CstID'>0 "-1"
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2018-06-21
/// Descript:   插入MDT会诊病人列表
/// InPut:      EpisodeID - "申请单ID"
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMConsInterface).InsMDTPat("")
ClassMethod InsMDTPat(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s CsDate=+$H   		              /// 操作日期
	s CsTime=$p($H,",",2)             /// 操作时间
	&SQL(Insert Into DHC_EmConsultPat(EC_Adm_Dr, EC_Date, EC_Time) values(:EpisodeID, :CsDate, :CsTime))
	Q SQLCODE
}

/// Creator:    bianshuai
/// CreateDate: 2018-06-21
/// Descript:   是否是MDT诊断
/// InPut:      MrID - 诊断ID
/// OutPut:     1-是，0-不是
/// w ##Class(web.DHCEMConsInterface).IsMDTDiag("")
ClassMethod IsMDTDiag(MrID As %String) As %String
{
	n (MrID)
	Q:$o(^DHCEMCD(0,"MR",MrID,"")) 1
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2018-04-25
/// Descript:   取病人会诊列表
/// InPut:      EpisodeID - 就诊ID
/// OutPut:     会诊列表
/// 			列表格式：会诊ID^病人ID^姓名^登记号^性别^科室^病区^费别^床号^出生日期^联系方式^地址^病案号^诊断^就诊ID^申请科室ID^申请科室^申请日期^申请时间^申请人ID^申请人^简要病历^会诊目的^要求会诊日期^要求会诊时间^要求会诊地点^是否加急^是否外院^外院名称^外院医生^备注^联系人^联系电话^会诊性质^会诊科室ID^会诊科室^会诊医生^会诊意见^会诊分类^抗生素同意标识^会诊状态^会诊状态Code^多科标识^会诊类型^年龄
/// w ##Class(web.DHCEMConsInterface).GetPatConsult("")
ClassMethod GetDocConsult(userCode As %String, LocID As %String, StartDate As %String, EndDate As %String, conStatus As %String, QryType As %String, TmpPatConsArr As %String = "") As %String
{
	n (userCode, LocID, StartDate, EndDate, conStatus, QryType, TmpPatConsArr)
	s UserID=""
	i userCode'="" s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	//Q:UserID="" ""
	s MulWriFlag="" /// 多科会诊填写标识
	s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	i StartDate="" s StartDate=$H-1
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
	i EndDate="" s EndDate=$H
	s Num=0
	F dd=StartDate:1:EndDate D
	.s CstID=""
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..s EpisodeID=$p(^DHCEMCON(CstID),"^",1)   /// 就诊ID
	..Q:'$D(^PAADM(EpisodeID))
	..s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	..s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	..s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	..s PatSex=""
	..s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	..i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	..s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) ///年龄
	..s PatLoc=""
	..s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	..s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	..s PatWard=""
	..s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	           /// 病区ID
	..s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	..s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	..s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	..s BedId=$p(^PAADM(EpisodeID),"^",73) 				/// 床号ID
    ..s PatBed=""
    ..s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    ..s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	/// 电话 
	..s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	/// 家庭住址
	..s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)        /// 出生日期
	..i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	..s MedicareNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID)  ///病案号
	..s PatDiagDesc=##class(web.DHCEMCommonUtil).GetMRDiagnosDesc(EpisodeID)   /// 诊断
	..
	..s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	..Q:(QryType="R")&(CstRLocID'=LocID)&(LocID'="")
	..s CstRLoc=""
	..s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	..s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	..s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	..s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	..s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	..s CstRUser=""
	..s CstRUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	..Q:(QryType="R")&(CstRUserID'=UserID)&(UserID'="")
	..s:CstRUserID'="" CstRUser=$p(^SSU("SSUSR",CstRUserID),"^",2)
	..s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	..s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	..s CstNDate=$p(^DHCEMCON(CstID),"^",10)    /// 会诊日期
	..s CstNDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)	
	..s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	..s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	..s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	..s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	..s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	..s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	..s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	..s CstRemark=$p(^DHCEMCON(CstID),"^",27)  /// 备注
	..s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	..s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	..s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	..s CsPropID = $p(^DHCEMCON(CstID),"^",45)   /// 会诊性质
	..;s CstEmType=$s(CstEmFlag="Y":"急会诊",1:"平会诊")
	..s CstEmType=$p($g(^DHCEMCDI(+CsPropID)),"^",2) /// 会诊性质
	..s CstUserID=$p(^DHCEMCON(CstID),"^",14)  /// 审核人
	..s CsCategory=$p(^DHCEMCON(CstID),"^",19) /// 单据类型 DOCA-为抗生素会诊
	..s AgreeFlag=$p(^DHCEMCON(CstID),"^",35)  /// 是否同意用药
	..s MoreFlag=$p(^DHCEMCON(CstID),"^",31)   /// 是否多科
	..s CsAUserID=$p(^DHCEMCON(CstID),"^",14)  /// 审核人
	..s StateFlag=$p(^DHCEMCON(CstID),"^",18)  /// 申请状态
	..s CstTypeDr=$p(^DHCEMCON(CstID),"^",8)   /// 会诊类型ID
	..s CstType=$p(^DHCEMCDI(CstTypeDr),"^",2) /// 会诊类型
	..s TreMeasures=$p(^DHCEMCON(CstID),"^",17)  /// 最终治疗措施
	..s isCsAuditFlag=##Class(web.DHCEMConsultCom).isCsAudit(CstTypeDr)
	..Q:(QryType="C")&(StateFlag="")
	..s CstHospID=$p(^CTLOC(CstRLocID),"^",22)
	..s isWFCompFlag=##Class(web.DHCEMConsultWorkFlow).isWFCompFlag(CstID,CstHospID) /// 当前会诊工作流是否已经审核完
	..Q:(QryType="C")&(isWFCompFlag'="Y")
	..i MulWriFlag="" s MulWriFlag=##Class(web.DHCEMConsultCom).GetEmSysConfig("MULWRIFLAG",CstHospID)
	..i (QryType="C")&(MoreFlag'="Y") s MulWriFlag=""
	..s CH=""
	..F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	...s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 会诊医生
	...s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	...;Q:(QryType="C")&(UserID'="")&(CsUserID'=UserID)
	...Q:(QryType="C")&(CsUserID'="")&(CsUserID'=UserID)
	...s CsUser=""
	...s:CsUserID'="" CsUser=$p(^SSU("SSUSR",CsUserID),"^",2)
	...s CsLocDesc=""
	...s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       /// 会诊科室
	...Q:(QryType="C")&(LocID'="")&(CsLocID'=LocID)
	...Q:(QryType="C")&(LocID="")&('..GetUserLocRelFlag(UserID,CsLocID)) /// 判断当前用户与科室是否有关联
	...s:CsLocID'="" CsLocDesc=$p(^CTLOC(CsLocID),"^",2)
	...s Opinion=$p(^DHCEMCON(CstID,"I",CH),"^",4)       /// 会诊意见
	...i Opinion="" s Opinion=TreMeasures
	...s CsStatDesc=##Class(web.DHCEMConsultQuery).GetCstCurStat(CstID_"||"_CH)  /// 取会诊记录的当前状态值
	...s CsStatCode=..GetCstCurStat(CstID_"||"_CH)  /// 取会诊记录的当前状态值
	...Q:(conStatus'="")&('$LF($LISTFROMSTRING(conStatus,"^"),CsStatCode))
	...s CsDate=$p(^DHCEMCON(CstID,"I",CH),"^",7)			/// 会诊日期
	...s CsDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CsDate)
	...s CsTime=$p(^DHCEMCON(CstID,"I",CH),"^",8)			/// 会诊时间
	...s:CsTime'="" CsTime=$zt(CsTime,1)
	...i CstUserID="" s CstNDate=CsDate,CstNTime=CsTime
	...//Q:Opinion=""
	...s Num=Num+1
	...s ListData=CstID_"||"_CH_"^"_PatientID_"^"_PatName_"^"_PatNo_"^"_PatSex_"^"_PatLoc_"^"_PatWard_"^"_BillType_"^"_PatBed_"^"_PatBod_"^"_PatTelH_"^"_PatAddr_"^"_MedicareNo_"^"_PatDiagDesc
    ...s ListData=ListData_"^"_EpisodeID_"^"_CstRLocID_"^"_CstRLoc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose_"^"_CstNDate_"^"_CstNTime
    ...s ListData=ListData_"^"_CstNPlace_"^"_CstEmFlag_"^"_CstOutFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser_"^"_CstPhone_"^"_CstEmType_"^"_CsLocID_"^"_CsLocDesc_"^"_CsUser_"^"_Opinion_"^"_CsCategory_"^"_AgreeFlag_"^"_CsStatDesc_"^"_CsStatCode_"^"_MulWriFlag_"^"_CstType_"^"_PatAge
	...s TmpPatConsArr(Num)=ListData
	.
    Q ""
}

/// Descript:  取会诊记录的当前状态值
/// w ##Class(web.DHCEMConsultQuery).GetCstCurStat("12")
ClassMethod GetCstCurStat(CstID As %String) As %String
{
	n (CstID)
	s LgID="",ID=""
	F  s LgID=$o(^DHCEMCONL(0,"Cst",CstID,LgID),-1) Q:(LgID="")||(ID'="")  D
	.s ID=$p(^DHCEMCONL(LgID),"^",3)        /// 状态
	.
	i ID="" D
	.s ID=$p(^DHCEMCON(+CstID),"^",18)
	Q $p($g(^DHCEMCONS(+ID)),"^",1)
}

/// Descript: 取会诊申请数据
/// w ##Class(web.DHCEMConsInterface).GetCstContent("80||1")
ClassMethod GetCstContent(ItmID) As %String
{
	n (ItmID)
	s CstID=+ItmID
	Q:'$D(^DHCEMCON(CstID)) ""
	s EpisodeID=$p(^DHCEMCON(CstID),"^",1)   /// 就诊ID 
	s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	s CstRLoc=""
	s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	s:CstRDate'="" CstRDate=$zd(CstRDate,3)
	s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	s CstRUser=""
	s CstRUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	s:CstRUserID'="" CstRUser=$p(^SSU("SSUSR",CstRUserID),"^",2)
	s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	s:CstNDate'="" CstNDate=$zd(CstNDate,3)
	s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	s CstRemark=$p(^DHCEMCON(CstID),"^",27)  /// 备注
	s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	s ShareFlag=$p(^DHCEMCON(CstID),"^",30)  /// 是否共享
	s TreMeasures=$p(^DHCEMCON(CstID),"^",17)  /// 最终治疗措施
	s CsCategory=$p(^DHCEMCON(CstID),"^",19)   /// 会诊类型 DOCA-为抗生素会诊
	s AgreeFlag=$p(^DHCEMCON(CstID),"^",35)    /// 是否同意用药
	s CsEmFlag=$p(^DHCEMCON(CstID),"^",23)     /// 是否加急
	s CsEmFlag=$s(CsEmFlag="Y":"加急",1:"普通")
	s CsLocID=$p($g(^DHCEMCON(CstID,"I",+$p(ItmID,"||",2))),"^",1)     /// 会诊科室  增加了$G
	s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)
	s Opinion=$p($g(^DHCEMCON(CstID,"I",+$p(ItmID,"||",2))),"^",4)     /// 会诊意见
		
    s ListData=EpisodeID_"^"_CstRLocID_"^"_CstRLoc_"^"_CstRDate_"^"_CstRTime_"^"_CstRUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose_"^"_CstNDate_"^"_CstNTime
    s ListData=ListData_"^"_CstNPlace_"^"_CstEmFlag_"^"_CstOutFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser_"^"_CstPhone_"^"_ShareFlag_"^"_Opinion_"^"_TreMeasures_"^"_CsEmFlag_"^"_CsLocDesc_"^"_CsCategory_"^"_AgreeFlag
	Q ListData
}

/// Descript: 取会诊数据
/// w ##Class(web.DHCEMConsInterface).GetConsultInfo("24")
ClassMethod GetConsultInfo(CstID) As %String
{
	n (CstID)
	Q:'$D(^DHCEMCON(CstID)) ""
	s CH="",ListData=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 会诊医生
	.s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)        /// 会诊科室
	.s CsDate=$p(^DHCEMCON(CstID,"I",CH),"^",7)			/// 会诊日期
	.s CsTime=$p(^DHCEMCON(CstID,"I",CH),"^",8)			/// 会诊时间
	.i ListData="" s ListData=CH_"^"_CareProvID_"^"_CsLocID_"^"_CsDate_"^"_CsTime
	.E  s ListData=ListData_"@"_CH_"^"_CareProvID_"^"_CsLocID_"^"_CsDate_"^"_CsTime
	Q ListData
}

/// Creator:    bianshuai
/// CreateDate: 2018-08-24
/// Descript:   获取会诊记录列表【互联网会诊接口】【医生站-住院会诊列表接口2023-04-19】
/// InPut:      userCode - 用户工号, LocID - 科室ID, StartDate - 开始日期, EndDate - 结束日期，QryType - 查询类型(R：请会诊；C:会诊)
/// OutPut:     会诊列表
/// 			列表格式：会诊ID^病人ID^姓名^登记号^性别^科室^病区^费别^床号^出生日期^联系方式^地址^病案号^诊断^就诊ID^申请科室ID^申请科室^申请日期^申请时间^申请人ID^申请人^简要病历^会诊目的^要求会诊日期^要求会诊时间^要求会诊地点^是否加急^是否外院^外院名称^外院医生^备注^联系人^联系电话^会诊性质^会诊科室ID^会诊科室^会诊医生^会诊意见^会诊分类^抗生素同意标识^会诊状态^会诊状态Code^多科标识^会诊类型^年龄
/// D ##Class(%ResultSet).RunQuery("web.DHCEMConsInterface","QryDocCstList","ys01","","2019-08-20","2019-08-20","","R")
/// d ##Class(%ResultSet).RunQuery("web.DHCEMConsInterface","QryDocCstList","4829","189","","","","C")
Query QryDocCstList(userCode As %String, LocID As %String, StartDate As %String, EndDate As %String, conStatus As %String, QryType As %String = "C") As websys.Query(ROWSPEC = "CsItmID:%String,IPatientID:%String,PatName:%String,PatNo:%String,PatSex:%String,PatLoc:%String,PatWard:%String,BillType:%String,PatBed:%String,PatBod:%String,PatTelH:%String,PatAddr:%String,MedicareNo:%String,PatDiagDesc:%String,EpisodeID:%String,CstRLocID:%String,CstRLoc:%String,CstRDate:%String,CstRTime:%String,CstUserID:%String,CstRUser:%String,CstTrePro:%String,CstPurpose:%String,CstNDate:%String,CstNTime:%String,CstNPlace:%String,CstEmFlag:%String,CstOutFlag:%String,CstUnit:%String,CstDocName:%String,CstRemark:%String,CstUser:%String,CstPhone:%String,CstEmType:%String,CsLocID:%String,CsLocDesc:%String,CsUser:%String,Opinion:%String,CsCategory:%String,AgreeFlag:%String,CsStatDesc:%String,CsStatCode:%String,MulWriFlag:%String,CstType:%String,PatAge:%String")
{
}

ClassMethod QryDocCstListExecute(ByRef qHandle As %Binary, userCode As %String, LocID As %String, StartDate As %String, EndDate As %String, conStatus As %String, QryType As %String = "C") As %Status
{
	new (qHandle,userCode,LocID,StartDate,EndDate,conStatus,QryType)
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    k TmpPatConsArr
    //Q:(userCode="")&(LocID="") $$$OK
    
    /// 会诊记录列表
	D ..GetDocConsult(userCode, LocID, StartDate, EndDate, conStatus, QryType, .TmpPatConsArr)
	
    s index=""
	F  s index=$o(TmpPatConsArr(index))  Q:index=""  D
	.s ListData=$g(TmpPatConsArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpPatExaArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:    bianshuai
/// CreateDate: 2018-08-24
/// Descript:   获取会诊记录的详细内容【互联网会诊接口】
/// InPut:      userCode - 用户工号, LocID - 科室ID, ItmID - 会诊ID
/// OutPut:     会诊申请明细
/// w ##Class(web.DHCEMConsInterface).GetCstDetail("YS01","","277||1")
ClassMethod GetCstDetail(userCode As %String, LocID As %String, ItmID As %String) As %String
{
	n (userCode, LocID, ItmID)
	s ListData=..GetCstContent(ItmID)
	Q ListData
}

/// Creator:    bianshuai
/// CreateDate: 2018-08-24
/// Descript:   会诊更新会诊意见【互联网会诊接口】
/// InPut:      userCode - 用户工号, LocID - 科室ID, ItmID - 会诊ID, Opinion - 会诊意见, AgreeFlag - 同意用药
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMConsInterface).UpdCstOpinion("YS01","","88||1","HAHA")
ClassMethod UpdCstOpinion(userCode As %String, LocID As %String, ItmID As %String, Opinion As %String, AgreeFlag As %String) As %String
{
	n (userCode, LocID, ItmID, Opinion, AgreeFlag)
	s userID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	Q:userID="" ""
	i LocID="" s LocID=$p(^DHCEMCON(+ItmID),"^",2)   /// 申请科室
	s HospID=$p($g(^CTLOC(+LocID)),"^",22)
	s recLocID=+$p(^DHCEMCON(+ItmID,"I",$P(ItmID,"||",2)),"^",1)   /// 接收科室ID
	s LgParam=HospID_"^"_recLocID_"^^"_userID
	s Err=##Class(web.DHCEMConsult).CompCstMas(+ItmID, ItmID, LgParam, Opinion, AgreeFlag)
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2018-08-24
/// Descript:   执行会诊记录计费【互联网会诊接口】
/// InPut:      userCode - 用户工号, LocID - 科室ID, ItmID - 会诊ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMConsInterface).AcceptCstNo("YS01","","88||1")
ClassMethod AcceptCstNo(userCode As %String, LocID As %String, ItmID As %String) As %String
{
	n (userCode, LocID, ItmID)
	s userID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	Q:userID="" ""
	s LgParam="^^^"_userID
	s Err=##Class(web.DHCEMConsult).AcceptCstMas(+ItmID, ItmID, LgParam)
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2018-09-07
/// Descript:   是否允许同步撤销会诊申请
/// InPut:      UserID - 用户ID, Oeori - 医嘱ID
/// OutPut:     0：可以同步撤销申请单; -1^Mgs：不可以同步撤销申请单,以及不能同步撤销文字描述; 100：不属于申请单医嘱
/// w ##Class(web.DHCEMConsInterface).GetCanCstFlag("","")
ClassMethod GetCanCstFlag(UserID As %String, Oeori As %String) As %String
{
	n (UserID, Oeori)
	Q:UserID="" ""
	s CstID=$o(^DHCEMCON(0,"OrdItem",Oeori,""))
	Q:CstID="" "100"
	/// 申请状态
	Q:##Class(web.DHCEMConsult).IsPermitCancel(CstID) "-1^申请单当前状态，不允许进行取消操作！"
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2018-09-07
/// Descript:   撤销会诊申请
/// InPut:      userID - 用户ID, Oeori - 医嘱ID
/// OutPut:     0：可以同步撤销申请单; -1^Mgs：原因; 100：不属于申请单医嘱
/// w ##Class(web.DHCEMConsInterface).CanCstNo("4634","879||170")
ClassMethod CanCstNo(UserID As %String, Oeori As %String) As %String
{
	n (UserID, Oeori)
	/// 停止抗生素会诊医嘱时，不同步撤销会诊申请 bianshuai 2021-01-04
	Q:##Class(DHCAnt.Serve.ComOut).GetConidByOeori(Oeori) 0
	Q:UserID="" ""
	s CstID=$o(^DHCEMCON(0,"OrdItem",Oeori,""))
	Q:CstID="" "100"
	s IsModFlag=##Class(web.DHCEMConsult).GetIsModFlag(CstID,5)
	Q:IsModFlag=1 0  /// 会诊申请是否已经取消
	/// 申请状态
	s Err=..CancelCstNo(CstID,UserID)
	Q:Err="-1" "-1^申请单当前状态，不允许进行取消操作！"
	Q Err
	
#;	Q:UserID="" ""
#;	s CstIDs=$o(^DHCEMCON(0,"OrdItem",Oeori,""))
#;	s:CstIDs="" CstIDs = ##class(DHCAnt.Serve.ComOut).GetConidByOeori(Oeori)   ///抗生素会诊
#;	Q:CstIDs="" "100"
#;
#;	s Len=$l(CstIDs,",")	///医生站接口返回值存在多个的情况，用逗号分隔
#;	s Err=0
#;	ts
#;	f ii=1:1:Len q:Err'=0  d
#;	.s CstID=$p(CstIDs,",",ii)
#;	.s IsModFlag=##Class(web.DHCEMConsult).GetIsModFlag(CstID,5)
#;	.Q:IsModFlag=1  /// 会诊申请是否已经取消
#;	.s Err=..CancelCstNo(CstID,UserID) /// 申请状态
#;	.s:Err="-1" Err="-1^申请单当前状态，不允许进行取消操作！"
#;	i Err'=0 tro 1
#;	q:Err'=0 Err
#;	tc
#;	
#;	Q Err
}

/// Descritp:  取消申请单
/// w ##Class(web.DHCEMConsInterface).CancelCstNo(121,4634)
ClassMethod CancelCstNo(CstID As %String, UserID As %String) As %String
{
	n (CstID, UserID)

	s Err=0
	s StatusID=##Class(web.DHCEMConsult).GetConsStatus(5)
	/// 申请状态
	Q:##Class(web.DHCEMConsult).IsPermitCancel(CstID) "-1"
	
	TS
	/// 更新发送
	s Err = ##Class(web.DHCEMConsult).InsCsItemStatus(CstID,"",StatusID)
	i Err'=0 tro 1
	Q:Err'=0 "-11"
	
	/// 插入操作日志
	s Err = ##Class(web.DHCEMConsult).InsConsultLog(CstID,"",UserID,StatusID)
	i Err'=0 tro 1
	Q:Err'=0 "-12"

	/// 修改会诊主表状态
	s Err = ##Class(web.DHCEMConsult).InsCsMasStatus(CstID,StatusID)
	i Err'=0 tro 1
	Q:Err'=0 "-13"

	/// 执行信封消息
	D ##Class(web.DHCEMConsult).InvExecMes(CstID,"",UserID)
	//i Err<0 tro
	//Q:Err<0 "-14"

	TC
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2018-10-19
/// Descript:   提取需处理会诊记录数接口
/// InPut:      userID - 用户ID,  userID - 科室ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMConsInterface).GetCsHanNum("")
ClassMethod GetCsHanNum(userID As %String, LocID As %String) As %String
{
	n (userID, LocID)
    s StartDate=+$H-30
    s EndDate=+$H
    s LgCPrvID=$p($g(^SSU("SSUSR",userID)),"^",14)
    s Num=0, CsHanNum=0
	F dd=StartDate:1:EndDate D
	.s CstID=""
	.F  s CstID=$o(^DHCEMCON(0,"ReqDateIndex",dd,CstID)) Q:CstID=""  D
	..s CH=""
	..F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	...s CPrvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)   /// CT_CareProv ID
	...i CPrvID="" s CPrvID=$p(^DHCEMCON(CstID,"I",CH),"^",3)
	...s CsCUser=$p($g(^CTPCP(+CPrvID,1)),"^",2)    /// 会诊医生
	...Q:(CPrvID'="")&(CPrvID'=LgCPrvID)
	...s CsCLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1) /// CT_Loc ID
	...Q:CsCLocID'=LocID
	...s CsStatCode=##Class(web.DHCEMConsultQuery).GetCstCurStat(CstID_"||"_CH)  /// 取会诊记录的当前状态值
	...Q:CsStatCode="取消"
	.../// 计算会诊列表待处理申请数
	...i (CsStatCode="发送")||(CsStatCode="审核") s CsHanNum=CsHanNum+1
	..
	Q CsHanNum
}

/// Creator:     bianshuai
/// CreateDate:  2018-11-03
/// Descript:    本次就诊是否有未处理会诊
/// InPut:       EpisodeID - 就诊ID
/// OutPut:      0-没有，1-有
/// w ##Class(web.DHCEMConsInterface).GetWaitHeadleCsFlag("")
ClassMethod GetWaitHeadleCsFlag(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s CstID="", Tips=0, WComNum=0, WAccNum=0
	F  s CstID=$o(^DHCEMCON(0,"ADM",EpisodeID,CstID)) Q:CstID=""  D
	.s ID=$p(^DHCEMCON(CstID),"^",18)   /// 会诊状态
	.s stCode=$p($g(^DHCEMCONS(+ID)),"^",1)
	.Q:stCode>50 /// 完成
	.Q:(stCode=5)||(stCode=25)||(stCode=22) /// 取消||拒绝||驳回
	.i stCode=30 s WComNum=WComNum+1
	.i stCode=20 s WAccNum=WAccNum+1
	.
	Q:(WComNum=0)&(WAccNum=0) 0
	s TipMsg=""
	i WAccNum'=0 s TipMsg="待接收会诊"_WAccNum_"条"
	i WComNum'=0 s TipMsg=$s(TipMsg'="":TipMsg_",待完成会诊"_WComNum_"条",1:"待完成会诊"_WComNum_"条")
	s TipMsg="该患者有"_TipMsg_"，请先处理！"
	Q TipMsg
}

/// Creator:     qqa
/// CreateDate:  2018-12-24
/// Descript:    通过会诊申请医嘱查找会诊是否未完成
/// InPut:       医嘱ID,会诊类型(NUR/DOC)
/// OutPut:      1-没有完成，0-完成, ""-不存在会诊
/// w ##Class(web.DHCEMConsInterface).IsCanConsBySendOrd("18||3")
ClassMethod IsCanConsBySendOrd(OrderID, CstTypeDesc = "") As %String
{
	n (OrderID,CstTypeDesc)
	s OrdItm = OrderID
	q:OrdItm="" ""
	s ConsItmID = $o(^DHCEMCON(0,"OrdItem",OrdItm,""),-1)
	q:+ConsItmID=0 ""
	s ConStDr=$p(^DHCEMCON(+ConsItmID),"^",18)
	s stCode=$p($g(^DHCEMCONS(+ConStDr)),"^",1)
	Q:(stCode=5)||(stCode=25)||(stCode=22) 0      /// 取消||拒绝||驳回
	s CstTypeID=$p(^DHCEMCON(+ConsItmID),"^",8)   /// 会诊类型
	s CstType = $p($g(^DHCEMCDI(CstTypeID)),"^",1)
	q:(CstTypeDesc'="")&&(CstType'[CstTypeDesc) ""
	s ConsItmSub = $o(^DHCEMCON(0,"OrdItem",OrdItm,ConsItmID,""),-1)
	q:+ConsItmSub=0 ""
	q:$d(^DHCEMCON(ConsItmID,"I",ConsItmSub))=0 ""
	s ItmStatusDr = $p(^DHCEMCON(ConsItmID,"I",ConsItmSub),"^",6)
	s StCode=$p($g(^DHCEMCONS(+ItmStatusDr)),"^",1)
	q:(StCode<50)&&(StCode'=5) 1
	q:StCode=51 1   //51为取消完成
	s CmpDate=$p($g(^DHCEMCON(+ConsItmID,"I",+ConsItmSub)),"^",16)
	q:CmpDate="" 1  //完成时间无
	q 0
}

/// Creator:     qqa
/// CreateDate:  2018-12-24
/// Descript:    通过会诊申请医嘱查找会诊是否未完成
/// InPut:       医嘱ID
/// OutPut:      0-没有完成，1-完成, ""-不存在会诊
/// w ##Class(web.DHCEMConsInterface).IsCanConDocsBySendOrd("18||3")
ClassMethod IsCanConDocsBySendOrd(OrderID As %String) As %String
{
	n (OrderID)
	q ##Class(web.DHCEMConsInterface).IsCanConsBySendOrd(OrderID,"DOC")
}

/// Creator:     qqa
/// CreateDate:  2018-12-24
/// Descript:    通过会诊申请医嘱查找会诊是否未完成
/// InPut:       医嘱ID
/// OutPut:      1-没有完成，0-完成, ""-不存在会诊
/// w ##Class(web.DHCEMConsInterface).IsCanConNursBySendOrd("18||3")
ClassMethod IsCanConNursBySendOrd(OrderID As %String) As %String
{
	n (OrderID)
	q ##Class(web.DHCEMConsInterface).IsCanConsBySendOrd(OrderID,"NUR")
}

/// Creator:    bianshuai
/// CreateDate: 2018-11-19
/// Descript:   该病人是否有未打印会诊申请
/// InPut:      EpisodeID - 就诊ID
/// OutPut:     QuitFlag：1-存在未打印会诊单，0-不存在
/// w ##Class(web.DHCEMConsInterface).GetCstPrintFlag("6") 
ClassMethod GetCstPrintFlag(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s CstID="", QuitFlag=0
	F  s CstID=$o(^DHCEMCON(0,"ADM",EpisodeID,CstID)) Q:CstID=""  D
	.s PrintFlag=$p(^DHCEMCON(CstID),"^",37)   /// 打印标志
	.Q:PrintFlag="Y"
	.s QuitFlag=1
	.
	Q QuitFlag
}

/// Creator:    bianshuai
/// CreateDate: 2018-11-19
/// Descript:   判断当前用户与科室是否有关联
/// InPut:      UserID - 用户ID，LocID - 科室ID
/// OutPut:     QuitFlag：1-有，0-无
/// w ##Class(web.DHCEMConsInterface).GetUserLocRelFlag("1301","617") 
ClassMethod GetUserLocRelFlag(UserID As %String, LocID As %String) As %String
{
	n (UserID, LocID)
	s QuitFlag=0
	Q:UserID="" 1
	Q:$p(^SSU("SSUSR",UserID),"^",4)=LocID 1
	s OtherFlag=##Class(web.DHCEMConsultCom).GetUserOtherLoc(UserID, LocID)
	Q:OtherFlag=1 1
	Q QuitFlag
}

/// Creator:    bianshuai
/// CreateDate: 2018-12-10
/// Descript:   判断病人是否有未完成会诊
/// InPut:      EpisodeID - 就诊ID
/// OutPut:     0 - 没有, 1- 有
/// w ##Class(web.DHCEMConsInterface).GetPatWaitCsFlag("")
ClassMethod GetPatWaitCsFlag(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s CstID="", QuitFlag=0
	F  s CstID=$o(^DHCEMCON(0,"ADM",EpisodeID,CstID)) Q:CstID=""  D
	.s ID=$p(^DHCEMCON(CstID),"^",18)        /// 会诊状态
	.s stCode=$p($g(^DHCEMCONS(+ID)),"^",1)
	.Q:(stCode=5)||(stCode=25)||(stCode=22)  /// 取消||拒绝||驳回
	.Q:(stCode>=50)&(stCode'=51)             /// 完成&取消完成
	.s QuitFlag=1
	.
	Q QuitFlag
}

/// Creator:    bianshuai
/// CreateDate: 2019-01-21
/// Descript:   关闭病历授权
/// InPut:      EpisodeID - 就诊ID,
/// OutPut:     1-关闭授权成功; -1-关闭授权失败
/// w ##Class(web.DHCEMConsInterface).CloseEmrAuth("")
ClassMethod CloseEmrAuth(EpisodeID As %String, CstID As %String) As %String
{
	n (EpisodeID, CstID)
	///  AEpisodeID: 就诊ID
	///  AStatus:    IC-会诊授权;IP-检查授权;IL-检验授权
	///  AObjID:     具体模块的业务ID(会诊申请ID)
	s Err=##Class(EMRservice.InterfaceService.Appoint).closeAppoint(EpisodeID,"IC",CstID)
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2019-01-21
/// Descript:   病历授权
/// InPut:      EpisodeID - 就诊ID,
/// OutPut:     0 此就诊没有病历; 1-授权成功; -1-授权失败
/// w ##Class(web.DHCEMConsInterface).OpenEmrAuth("")
ClassMethod OpenEmrAuth(EpisodeID As %String, CstID As %String, LgUserID As %String, DeptID As %String, UserID As %String, LimTime As %String) As %String
{
	n (EpisodeID, CstID, LgUserID, DeptID, UserID, LimTime)
 	///	AEpisodeID:           就诊ID (不能为空)
    /// AAppointCateCharpter: 1、病历ID串(病历ID^病历ID) 2、ALL(全部病历)
    /// ARequestUserID:       获得权限的医护人员UserID (不能为空)
    /// ARequestDeptID:       获得权限的科室ID (不能为空)
    /// AActions:             view (授予的病历操作权限，不能为空)
    /// AAppointUserID:       进行授权的医护人员UserID (不能为空)
    /// AAppointType:         0-对ARequestUserID进行授权; 1-对ARequestDeptID进行授权
    /// AAppointSpan:         数字-授权时长，单位为小时 (例：时长6小时，参数为6)
    /// AStatus:              IC-会诊授权;IP-检查授权;IL-检验授权 (不能为空)
    /// AObjID:               具体模块的业务ID(会诊申请ID，不能为空)
    s AppointType=0
    i UserID="" s AppointType=1, UserID="-1"
	s Err=##Class(EMRservice.InterfaceService.Appoint).addAppoint(EpisodeID,"ALL",UserID,DeptID,"view",LgUserID,AppointType,LimTime,"IC",CstID)
	Q Err
}

/// Creator:    bianshuai
/// CreateDate: 2019-03-26
/// Descript:   验证病人是否允许会诊授权
/// InPut:      EpisodeID - 就诊ID,
/// OutPut:     0
/// w ##Class(web.DHCEMConsInterface).isPopEmrAut("")
ClassMethod isPopEmrAut(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s TakMsg=""
	s Err=##Class(EMRservice.InterfaceService.Appoint).getInstanceIDsByAdmID(EpisodeID)
	i Err="" s TakMsg="当前病人此次就诊没有病历！"
	Q TakMsg
}

/// Creator:    bianshuai
/// CreateDate: 2019-01-21
/// Descript:   医嘱是否和会诊申请医嘱
/// InPut:      Oeori - 医嘱ID,
/// OutPut:     1-有; 0-没有
/// w ##Class(web.DHCEMConsInterface).isCstOeori("")
ClassMethod isCstOeori(Oeori As %String) As %String
{
	n (Oeori)
	Q:Oeori="" 0
	/// 请会诊医嘱
	s CstID=$o(^DHCEMCON(0,"OrdItem",Oeori,""))
	Q:CstID'="" 1
	/// 会诊医嘱
	s CstID=$o(^DHCEMCON(0,"COeori",Oeori,""))
	Q:CstID'="" 1
	Q 0
}

/// Creator:    bianshuai
/// CreateDate: 2019-02-12
/// Descript:   取当前医嘱对应的会诊记录关联的其他医嘱ID串
/// InPut:      Oeori - 医嘱ID,
/// OutPut:     mListData - 关联医嘱ID串
/// w ##Class(web.DHCEMConsInterface).GetCstRelOeori("9||1")
ClassMethod GetCstRelOeori(mOeori As %String) As %String
{
	n (mOeori)
	Q:mOeori="" ""
	/// 请会诊医嘱
	s CstID=$o(^DHCEMCON(0,"OrdItem",mOeori,""))
	Q:CstID="" ""
	s CH="", mListData=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s Oeori=$p(^DHCEMCON(CstID,"I",CH),"^",9)  /// 医嘱ID
	.Q:Oeori=mOeori
	.s mListData=$s(mListData="":Oeori,1:mListData_"^"_Oeori)
	.
	Q mListData
}

/// Creator:    hxy
/// CreateDate: 2021-04-08
/// Descript:   闭环接口-发送节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConSendData("386||4")
ClassMethod GetConSendData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"20") //发送code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-08
/// Descript:   闭环接口-取消节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConCanData("52||250")
ClassMethod GetConCanData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"5") //取消code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-08
/// Descript:   闭环接口-审核节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConAuditData("252||84")
ClassMethod GetConAuditData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"21") //审核code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-08
/// Descript:   闭环接口-驳回节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConRejData("98||140")
ClassMethod GetConRejData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"22") //驳回code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-08
/// Descript:   闭环接口-拒绝节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConRefData("252||77")
ClassMethod GetConRefData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"25") //拒绝code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descript:   闭环接口-接收节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConAccData("252||76")
ClassMethod GetConAccData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"30") //接收code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descript:   闭环接口-取消接收节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConRevAccData("252||76")
ClassMethod GetConRevAccData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"35") //取消接收code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descript:   闭环接口-到达节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConArrData("515||76")
ClassMethod GetConArrData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"40") //到达code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descript:   闭环接口-完成节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConComData("101||106")
ClassMethod GetConComData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"50") //完成code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descript:   闭环接口-取消完成节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConRevComData("880||4")
ClassMethod GetConRevComData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"51") //取消完成code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descript:   闭环接口-会诊评价节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConCevaData("880||4")
ClassMethod GetConCevaData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"55") //会诊评价code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descript:   闭环接口-取消会诊评价节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConRevCevaData("880||4")
ClassMethod GetConRevCevaData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"56") //取消会诊评价code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descript:   闭环接口-确认节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConSureData("880||4")
ClassMethod GetConSureData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"60") //确认code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descript:   闭环接口-取消确认节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConRevSureData("880||4")
ClassMethod GetConRevSureData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"61") //取消确认code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descript:   闭环接口-评价节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConReavData("880||4")
ClassMethod GetConReavData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"70") //评价code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descript:   闭环接口-取消评价节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConRevReavData("252||84")
ClassMethod GetConRevReavData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"79") //取消评价code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-08
/// Descript:   闭环接口-科主任审核节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConDirAuditData("252||81")
ClassMethod GetConDirAuditData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"71") //科主任审核code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-08
/// Descript:   闭环接口-医务部审核节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConMedAuditData("52||252")
ClassMethod GetConMedAuditData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"72") //医务部审核code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-08
/// Descript:   闭环接口-护士长审核节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConHeadNurAuditData("98||57")
ClassMethod GetConHeadNurAuditData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"73") //护士长审核code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-08
/// Descript:   闭环接口-护理部审核节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConNurDepAuditData("98||57")
ClassMethod GetConNurDepAuditData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"74") //护理部审核code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-08
/// Descript:   闭环接口-取消审核节点
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConCanAuditData("252||84")
ClassMethod GetConCanAuditData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCode(ItmID,"80") //取消审核code
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-07-12
/// Descript:   闭环接口-科主任取消审核节点【未使用】
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConCanHeadAuditData("742||311")
ClassMethod GetConCanHeadAuditData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCodeSpe(ItmID,"80","71") //取消审核code //科主任审核71
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-07-12
/// Descript:   闭环接口-医务部取消审核节点【未使用】
/// InPut:      医嘱id
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
///             多科发送、取消、***审核、取消审核、驳回分支ID用主表的，其他用子表的
/// w ##Class(web.DHCEMConsInterface).GetConCanMedAuditData("742||311")
ClassMethod GetConCanMedAuditData(OrdItemId As %String) As %String
{
	n (OrdItemId)
	s ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s ret=..GetLogDataByStCodeSpe(ItmID,"80","72") //取消审核code //医务部审核72
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-07-12
/// Descript:   由会诊子表ID、状态code取值日志数据【未使用】
/// InPut:      ItmID - 子表ID,StCode - 状态code
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
/// w ##Class(web.DHCEMConsInterface).GetLogDataByStCode("65||1","20")
ClassMethod GetLogDataByStCodeSpe(ItmID As %String, StCode As %String, AuditCode As %String) As %String
{
	n (ItmID, StCode,AuditCode)
	q:(ItmID="")||(StCode="") ""
	s CstID=+ItmID
	q:$p(^DHCEMCON(CstID),"^",18)="" ""             /// 会诊状态
	s MoreFlag=$p($g(^DHCEMCON(CstID)),"^",31) /// 多科标志
	s ret=""
	s LgID=""
	f  s LgID=$o(^DHCEMCONL(0,"Cst",ItmID,LgID),-1) q:(LgID="")||(ret'="")  d
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态ID
	.q:$p($g(^DHCEMCONS(+StatusID)),"^",1)'=StCode
	.s LastAuditCode=..GetLastAuditCode(ItmID,LgID) //
	.q:(AuditCode=71)&&(LastAuditCode'=AuditCode)&&(LastAuditCode'=80) //默认医生-多科：发送-科主任审核-医务部审核
	.q:(AuditCode=72)&&(LastAuditCode'=AuditCode) //
	.s StatusDesc=$p($g(^DHCEMCONS(+StatusID)),"^",2)
	.s User=$p(^DHCEMCONL(LgID),"^",2)      /// 操作人
	.s:User'="" User=$p($g(^SSU("SSUSR",+User)),"^",2)
	.s LgDate=$p(^DHCEMCONL(LgID),"^",4)    /// 日期
	.s LgDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	.s LgTime=$p(^DHCEMCONL(LgID),"^",5)    /// 时间	
	.s:LgTime'="" LgTime=$zt(LgTime,1)
	.s Pointer=ItmID
	.s:(MoreFlag="Y")&&((StatusDesc["审核")||(StCode=5)||(StCode=20)) Pointer=CstID //取消发送审核
	.s ret=LgDate_"^"_LgTime_"^"_User_"^"_""_"^"_Pointer_"^"_""
	.
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-07-12 【未使用】
/// Descript:   闭环接口-取上一个审核(取消审核)状态
/// InPut:      ItmID:子表ID,LgID:取消审核日志ID
/// OutPut:     上一个审核(取消审核)状态code
/// w ##Class(web.DHCEMConsInterface).GetLastAuditCode("781||1","2632")
ClassMethod GetLastAuditCode(ItmID As %String, LgID As %String) As %String
{
	n (ItmID,LgID)
	s ret=""
	s LgDr=""
	f  s LgDr=$o(^DHCEMCONL(0,"Cst",ItmID,LgDr),-1) q:(LgDr="")||(ret'="")  d
	.q:LgDr>=LgID
	.s StatusID=$p(^DHCEMCONL(LgDr),"^",3)  /// 状态ID
	.s StatusDesc=$p($g(^DHCEMCONS(+StatusID)),"^",2)
	.q:StatusDesc'["审核"
	.s ret=$p($g(^DHCEMCONS(+StatusID)),"^",1)
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-08
/// Descript:   由会诊子表ID、状态code取值日志数据
/// InPut:      ItmID - 子表ID,StCode - 状态code
/// OutPut:     执行日期^执行时间^执行人姓名^部位(空)^分支ID^节点说明(空)
/// w ##Class(web.DHCEMConsInterface).GetLogDataByStCode("65||1","20")
ClassMethod GetLogDataByStCode(ItmID As %String, StCode As %String) As %String
{
	n (ItmID, StCode)
	q:(ItmID="")||(StCode="") ""
	s CstID=+ItmID
	q:$p(^DHCEMCON(CstID),"^",18)="" ""             /// 会诊状态
	s MoreFlag=$p($g(^DHCEMCON(CstID)),"^",31) /// 多科标志
	s ret=""
	s LgID=""
	f  s LgID=$o(^DHCEMCONL(0,"Cst",ItmID,LgID),-1) q:(LgID="")||(ret'="")  d
	.s StatusID=$p(^DHCEMCONL(LgID),"^",3)  /// 状态ID
	.q:$p($g(^DHCEMCONS(+StatusID)),"^",1)'=StCode
	.s StatusDesc=$p($g(^DHCEMCONS(+StatusID)),"^",2)
	.s User=$p(^DHCEMCONL(LgID),"^",2)      /// 操作人
	.s:User'="" User=$p($g(^SSU("SSUSR",+User)),"^",2)
	.s LgDate=$p(^DHCEMCONL(LgID),"^",4)    /// 日期
	.s LgDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(LgDate)
	.s LgTime=$p(^DHCEMCONL(LgID),"^",5)    /// 时间	
	.s:LgTime'="" LgTime=$zt(LgTime,1)
	.s Pointer=ItmID
	.s:(MoreFlag="Y")&&((StatusDesc["审核")||(StCode=5)||(StCode=20)) Pointer=CstID //取消发送审核
	.s ret=LgDate_"^"_LgTime_"^"_User_"^"_""_"^"_Pointer_"^"_""
	.
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-08
/// Descript:   由医嘱ID取会诊子表ID
/// InPut:      OrdItemId - 医嘱ID,
/// OutPut:     会诊子表ID
/// w ##Class(web.DHCEMConsInterface).GetItmByOrdItem("386||4")
ClassMethod GetItmByOrdItem(OrdItem As %String) As %String
{
	n (OrdItem)
	q:+OrdItem=0 ""
	s ret="",CstID="",CH=""
	/// 请会诊医嘱
	s CstID=$o(^DHCEMCON(0,"OrdItem",OrdItem,""))
	s:CstID'="" CH=$o(^DHCEMCON(0,"OrdItem",OrdItem,CstID,""))
	/// 会诊医嘱
	i CstID="" d
	.s CstID=$o(^DHCEMCON(0,"COeori",OrdItem,""))
	.s:CstID'="" CH=$o(^DHCEMCON(0,"COeori",OrdItem,CstID,""))
	s:(CstID'="")&&(CH'="") ret=CstID_"||"_CH
	Q ret
}

/// Creator:    hxy
/// CreateDate: 2021-04-09
/// Descript:   基础平台会诊闭环追踪图会诊基本信息数据取值接口提供
/// InPut:      医嘱id
/// OutPut:     申请科室^申请时间^申请医生^申请人职称^会诊类型^会诊性质^会诊科室1（职称1 来会诊医生1）、会诊科室2（职称2 来会诊医生2）^会诊地点
/// w ##Class(web.DHCEMConsInterface).GetConBaseData("742||265")
/// w ##Class(web.DHCEMConsInterface).GetConBaseData("742||267")
/// w ##Class(web.DHCEMConsInterface).GetConBaseData("742||268")
ClassMethod GetConBaseData(OrdItemId As %String, ItmID = "") As %String
{
	n (OrdItemId,ItmID)
	s:ItmID="" ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s CstID=+ItmID
	s ret=""
	s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   
	s CstRLoc=$p($g(^CTLOC(+CstRLocID)),"^",2)        /// 申请科室
	s CstRDate=$p(^DHCEMCON(CstID),"^",3)
	s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	s CstRTime=$p(^DHCEMCON(CstID),"^",4)    
	s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	s CstRDateTime=CstRDate_" "_CstRTime              /// 申请时间
	s CstUserID=$p(^DHCEMCON(CstID),"^",5)   
	s CstRUser=$p($g(^SSU("SSUSR",+CstUserID)),"^",2) /// 申请医生
	s PrvTp=##Class(web.DHCEMConsultCom).GetPrvTpByUserID(CstUserID) /// 职称
	s CstTypeID=$p(^DHCEMCON(CstID),"^",8)
	s CstType=$p($g(^DHCEMCDI(+CstTypeID)),"^",2)     /// 会诊类型
	s CsPropID=$p(^DHCEMCON(CstID),"^",45)     
	s CsProp=$p($g(^DHCEMCDI(+CsPropID)),"^",2)       /// 会诊性质
	s CstNPlace=$p(^DHCEMCON(CstID),"^",12)           /// 会诊地点
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24)          /// 是否院外
	s CstUnit=$p(^DHCEMCON(CstID),"^",25)             /// 外院名称
	s CstUnitLoc=$p(^DHCEMCON(CstID),"^",26)          /// 外院科室
	s CH="",CsLocDescStr="" 
	f  s CH=$o(^DHCEMCON(CstID,"I",CH)) q:CH=""  d
	.s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       
	.s CsLocDesc=$p($g(^CTLOC(+CsLocID)),"^",2)        /// 会诊科室
	.s:CstOutFlag="Y" CsLocDesc=CstUnitLoc             /// 外院会诊科室
	.s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",3)    /// 实际会诊医生
	.s:CareProvID="" CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2) /// 要求会诊医生
	.s CsUser=$p($g(^CTPCP(+CareProvID,1)),"^",2)      /// 会诊医生
	.s CPrvTpID=$p(^DHCEMCON(CstID,"I",CH),"^",11)     
	.s CPrvTp=$p($g(^CT("CPT",+CPrvTpID)),"^",2)       /// 职称
	.s:CsUser'="" CsLocDesc=CsLocDesc_"("_CPrvTp_" "_CsUser_")"
	.s:CsLocDescStr'="" CsLocDescStr=CsLocDescStr_"、"_CsLocDesc
	.s:CsLocDescStr="" CsLocDescStr=CsLocDesc
	s ret=CstRLoc_"^"_CstRDateTime_"^"_CstRUser_"^"_PrvTp_"^"_CstType_"^"_CsProp_"^"_CsLocDescStr_"^"_CstNPlace
	q ret
}

/// Creator:    hxy
/// CreateDate: 2021-07-01
/// Descript:   【会诊闭环】提供基础平台会诊闭环判断多科会诊是否由请会诊医生填写结果接口
/// InPut:      医嘱id
/// OutPut:     1:是多科由请会诊医生填写结果
/// w ##Class(web.DHCEMConsInterface).GetMulWriFlag("742||278")
/// w ##Class(web.DHCEMConsInterface).GetMulWriFlag("742||282")
ClassMethod GetMulWriFlag(OrdItemId As %String, ItmID = "") As %String
{
	n (OrdItemId,ItmID)
	s:ItmID="" ItmID=..GetItmByOrdItem(OrdItemId)
	q:+ItmID=0 ""
	s CstID=+ItmID
	s MoreFlag=$p(^DHCEMCON(CstID),"^",31) /// 多科标志
	q:MoreFlag'="Y" ""
    s ret=""
    s TreMea=$p(^DHCEMCON(CstID),"^",17)   /// 最终治疗措施==多科申请人完成时的会诊意见
    q:TreMea'="" 1
    s CH="",Opinions=""
    f  s CH=$o(^DHCEMCON(CstID,"I",CH)) q:(CH="")||(Opinions'="")  d
	.s Opinion=$p(^DHCEMCON(CstID,"I",CH),"^",4)   /// 会诊意见
	.s:Opinion'="" Opinions=Opinion
	q:Opinions'="" 0
    s HospID=##Class(web.DHCEMConsultCom).GetPatHospID(CstID)
    s MulWriFlag=##Class(web.DHCEMConsultCom).GetEmSysConfig("MULWRIFLAG",HospID)
    s:MulWriFlag=1 ret=1
    q ret
}

/// Creator:    hxy
/// CreateDate: 2021-06-09
/// Descript:   提供会诊数据【给电子病历接口】
/// InPut:      CstID - 会诊主表ID
/// OutPut:     会诊信息(其中 会诊完成时间^会诊意见 列 为多科申请人完成时使用，其他情况为空)  
/// 			列表格式：患者姓名^会诊类型^会诊申请时间^申请医师^申请科室^会诊地址^病情摘要^会诊理由及要求^会诊完成时间^会诊意见^会诊科室1&会诊医师1&会诊医师职称1&会诊完成时间&会诊意见1$c(2)会诊科室2&会诊医师2&会诊医师职称2&会诊完成时间2&会诊意见2
/// D ##Class(%ResultSet).RunQuery("web.DHCEMConsInterface","QryGetDataForEmr","698") 单科
/// D ##Class(%ResultSet).RunQuery("web.DHCEMConsInterface","QryGetDataForEmr","699") 多科
/// D ##Class(%ResultSet).RunQuery("web.DHCEMConsInterface","QryGetDataForEmr","700") 多科-申请人完成
/// D ##Class(%ResultSet).RunQuery("web.DHCEMConsInterface","QryGetDataForEmr","175") 抗菌药
/// D ##Class(%ResultSet).RunQuery("web.DHCEMConsInterface","QryGetDataForEmr","701") 院际
Query QryGetDataForEmr(CstID As %String) As websys.Query(ROWSPEC = "PatName:%String,CstType:%String,CstRDateTime:%String,CstRUser:%String,CstRLoc:%String,CstNPlace:%String,CstTrePro:%String,CstPurpose:%String,CstCDateTime:%String,TreMeasures:%String,ConStr:%String")
{
}

ClassMethod QryGetDataForEmrExecute(ByRef qHandle As %Binary, CstID As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	
	s EpisodeID=$p(^DHCEMCON(CstID),"^",1)            /// 就诊ID
	s PatientID=$p($g(^PAADM(+EpisodeID)),"^",1)      /// 病人ID
	s PatName=$p($g(^PAPER(+PatientID,"ALL")),"^",1)  /// 患者姓名
	s CstTypeDr=$p(^DHCEMCON(CstID),"^",8)            /// 会诊类型ID
	s CstType=$p($g(^DHCEMCDI(+CstTypeDr)),"^",2)     /// 会诊类型
	s CstRDate=$p(^DHCEMCON(CstID),"^",3)             /// 申请日期
	s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	s CstRTime=$p(^DHCEMCON(CstID),"^",4)             /// 申请时间
	s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	s CstRDateTime=CstRDate_" "_CstRTime              /// 会诊申请时间
	s CstUserID=$p(^DHCEMCON(CstID),"^",5)           
	s CstRUser=$p($g(^SSU("SSUSR",+CstUserID)),"^",2) /// 申请医师
	s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   
	s CstRLoc=$p($g(^CTLOC(+CstRLocID)),"^",2)        /// 申请科室
    s CstNPlace=$p(^DHCEMCON(CstID),"^",12)           /// 会诊地点
    s CstTrePro=$p(^DHCEMCON(CstID),"^",6)            /// 病情摘要
	s CstPurpose=$p(^DHCEMCON(CstID),"^",7)           /// 会诊理由及要求
	s CstCDate=$p(^DHCEMCON(CstID),"^",20)            /// 完成日期
	s CstCDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstCDate)	
	s CstCTime=$p(^DHCEMCON(CstID),"^",21)            /// 完成时间
	s:CstCTime'="" CstCTime=$zt(CstCTime,1)
	s CstCDateTime=$s(CstCTime'="":CstCDate_" "_CstCTime,1:"") /// 会诊完成时间
	s TreMeasures=$p(^DHCEMCON(CstID),"^",17)         /// 会诊意见-多科申请人完成
	s CstEcType=$p(^DHCEMCON(CstID),"^",19)
	s Anti=$p(^DHCEMCON(CstID),"^",35)
	s Anti=$s(Anti="Y":"同意;",Anti="N":"不同意;",1:"")
	s:CstEcType="DOCA" TreMeasures=""
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24)          /// 是否院外
	s CstUnit=$p(^DHCEMCON(CstID),"^",25)             /// 外院名称
	s CstLocName=$p(^DHCEMCON(CstID),"^",26)          /// 外院科室
	
	;会诊科室1&会诊医师1&会诊医师职称1&会诊完成时间&会诊意见1$c(2)会诊科室2&会诊医师2&会诊医师职称2&会诊完成时间2&会诊意见2
	s ConStr=""
	s CH=""
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s ConLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)
	.s ConLoc=$p($g(^CTLOC(+ConLocID)),"^",2)        /// 会诊科室
	.s:CstOutFlag="Y" ConLoc=CstLocName              /// 会诊科室-外院
	.s ConDocID=$p(^DHCEMCON(CstID,"I",CH),"^",3)
	.s:ConDocID="" ConDocID=$p(^DHCEMCON(CstID,"I",CH),"^",2)
	.s ConDoc=$p($g(^CTPCP(+ConDocID,1)),"^",2)      /// 会诊医师
	.s PrvTpID=$p($g(^CTPCP(+ConDocID,1)),"^",4)     /// 职称ID
	.s PrvTp=$p($g(^CT("CPT",+PrvTpID)),"^",2)       /// 会诊医师职称
	.s Opinion=$p($g(^DHCEMCON(CstID,"I",CH)),"^",4) /// 会诊意见
	.s:CstEcType="DOCA" Opinion=Anti_Opinion         /// 会诊意见-抗菌药
	.s CsCDate=$p(^DHCEMCON(CstID,"I",CH),"^",16)	 /// 完成日期
	.s CsCDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CsCDate)
	.s CsCTime=$p(^DHCEMCON(CstID,"I",CH),"^",17)	 /// 完成时间
	.s:CsCTime'="" CsCTime=$zt(CsCTime,1)
	.s CsCDateTime=$s(CsCTime'="":CsCDate_" "_CsCTime,1:"") /// 会诊完成时间
	.s:ConStr'="" ConStr=ConStr_$c(2)_ConLoc_"&"_ConDoc_"&"_PrvTp_"&"_CsCDateTime_"&"_Opinion
	.s:ConStr="" ConStr=ConLoc_"&"_ConDoc_"&"_PrvTp_"&"_CsCDateTime_"&"_Opinion
	s ListData=PatName_"^"_CstType_"^"_CstRDateTime_"^"_CstRUser_"^"_CstRLoc_"^"_CstNPlace_"^"_CstTrePro_"^"_CstPurpose_"^"_CstCDateTime_"^"_TreMeasures_"^"_ConStr

    s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")
    
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:     hxy
/// CreateDate:  2021-06-30
/// Descript:    病例保存返回InstanceID 【电子病历接口】
/// Input   : 	 会诊主表ID，病历实例ID
/// Return  :    0:成功，其他:失败
/// W ##Class(web.DHCEMConsInterface).UpdMedHisInstanceId("788","1")
ClassMethod UpdMedHisInstanceId(CstID, InstanceID)
{
	n (CstID,InstanceID)
	q:CstID="" -1
	;q:InstanceID="" -2 //hxy 2022-04-08注释：会诊病程删除需调用该接口同步为空
	&SQL(UPDATE DHC_EmConsult SET EC_Instance_Dr =:InstanceID WHERE EC_RowID = :CstID)
	Q SQLCODE
}

/// Creator:    	bianshuai
/// CreateDate: 	2021-08-24
/// Descript:   	通过就诊号获取会诊数据明细【护理组 智慧医院接口】
/// InPut:      	EpisodeID - 医嘱ID, UserType - 类型, StartDate - 开始日期, EndDate - 结束日期
/// OutPut:     	mListData - 关联医嘱ID串
/// D ##Class(%ResultSet).RunQuery("web.DHCEMConsInterface","QryPatCsList","16","DOC","2021-08-24","2021-08-24")
Query QryPatCsList(EpisodeID As %String, UserType As %String, StartDate As %String, EndDate As %String) As websys.Query(ROWSPEC = "IPatientID:%String,PatName:%String,PatNo:%String,PatSex:%String,PatLoc:%String,PatWard:%String,BillType:%String,PatBed:%String,PatBod:%String,PatTelH:%String,PatAddr:%String,MedicareNo:%String,PatDiagDesc:%String,EpisodeID:%String,CstRLocID:%String,CstRLoc:%String,CstRDate:%String,CstRTime:%String,CstUserID:%String,CstRUser:%String,CstTrePro:%String,CstPurpose:%String,CstNDate:%String,CstNTime:%String,CstType:%String,itmID:%String,CstNPlace:%String,CstEmFlag:%String,CstOutFlag:%String,CstUnit:%String,CstDocName:%String,CstRemark:%String,CstUser:%String,CstPhone:%String,CstCstType:%String,CsLocDesc:%String,CsUser:%String,Opinion:%String")
{
}

ClassMethod QryPatCsListExecute(ByRef qHandle As %Binary, EpisodeID As %String, UserType As %String, StartDate As %String, EndDate As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
    k TmpArr
    
    s:StartDate'="" StartDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(StartDate)
	s:EndDate'="" EndDate=##class(web.DHCEMCommonUtil).DateHtmlToLogical(EndDate)
    /// 取病人会诊列表
	D ..GetPatCsList(EpisodeID, UserType, StartDate, EndDate, .TmpArr)
	
    s index=""
	F  s index=$o(TmpArr(index))  Q:index=""  D
	.s ListData=$g(TmpArr(index))
	.Q:ListData=""
	.s ^CacheTemp(repid,ind)=$LISTFROMSTRING(ListData,"^")	
	.s ind=ind+1
	.

	k TmpPatExaArr
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
}

/// Creator:    	bianshuai
/// CreateDate: 	2021-08-24
/// Descript:   	取病人会诊列表【护理组 智慧医院接口】
/// InPut:      	EpisodeID - 就诊ID
/// OutPut:     	会诊内容内容，空
/// w ##Class(web.DHCEMConsInterface).GetPatCsList("")
ClassMethod GetPatCsList(EpisodeID As %String, UserType As %String, StartDate As %String, EndDate As %String, TmpArr As %String = "") As %String
{
	n (EpisodeID, UserType, StartDate, EndDate, TmpArr)
	s Num=0
	s CstID=""
	F  s CstID=$o(^DHCEMCON(0,"ADM",EpisodeID,CstID)) Q:CstID=""  D
	.Q:$p(^DHCEMCON(CstID),"^",19)'=UserType
	.s EpisodeID=$p(^DHCEMCON(CstID),"^",1)      /// 就诊ID
	.s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	.s PatSex=""
	.s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	.i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	.s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) ///年龄
	.s PatLoc=""
	.s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	.s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	.s PatWard=""
	.s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	          /// 病区ID
	.s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	.s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	.s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	.s BedId=$p(^PAADM(EpisodeID),"^",73) 				/// 床号ID
    .s PatBed=""
    .s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    .s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	/// 电话 
	.s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	.s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)         /// 出生日期
	.i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	.s MedicareNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID)  ///病案号
	.s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	.
	.s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	.s CstRLoc=""
	.s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	.s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	.Q:(CstRDate<StartDate)||(CstRDate>EndDate)
	.s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	.s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	.s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	.s CstRUser=""
	.s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	.s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	.s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	.s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	.s CstTypeID=$p(^DHCEMCON(CstID),"^",8)   /// 会诊类型
	.s CstType=$p(^DHCEMCDI(CstTypeID),"^",2) /// 会诊类型
	.s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	.s CstNDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)	
	.s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	.s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	.s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	.s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	.s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	.s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	.s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	.s CstRemark=$p(^DHCEMCON(CstID),"^",27)  /// 备注
	.s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	.s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	.s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	.s CstCstType=$s(CstEmFlag="Y":"加急",1:"普通")
	.s CstUserID=$p(^DHCEMCON(CstID),"^",14)  /// 审核人
	.s CH=""
	.F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	..s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 会诊医生
	..s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	..s CsUser=""
	..s:CsUserID'="" CsUser=$p(^SSU("SSUSR",CsUserID),"^",2)
	..s CsLocDesc=""
	..s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       /// 会诊科室
	..s:CsLocID'="" CsLocDesc=$p(^CTLOC(CsLocID),"^",2)
	..s Opinion=$p(^DHCEMCON(CstID,"I",CH),"^",4)       /// 会诊意见
	..s itmID=CstID_"||"_CH
	..s Num=Num+1
	..s ListData=PatientID_"^"_PatName_"^"_PatNo_"^"_PatSex_"^"_PatLoc_"^"_PatWard_"^"_BillType_"^"_PatBed_"^"_PatBod_"^"_PatTelH_"^"_PatAddr_"^"_MedicareNo_"^"_PatDiagDesc
    ..s ListData=ListData_"^"_EpisodeID_"^"_CstRLocID_"^"_CstRLoc_"^"_CstRDate_"^"_CstRTime_"^"_CstUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose_"^"_CstNDate_"^"_CstNTime_"^"_CstType_"^"_itmID
    ..s ListData=ListData_"^"_CstNPlace_"^"_CstEmFlag_"^"_CstOutFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser_"^"_CstPhone_"^"_CstCstType_"^"_CsLocDesc_"^"_CsUser_"^"_Opinion
	..s TmpArr(Num)=ListData
	.
    Q ""
}

/// Creator:    bianshuai
/// CreateDate: 2021-08-24
/// Descript:   确认到达【护理组 智慧医院接口】
/// InPut:      userCode - 用户工号, itmID - 会诊ID
/// OutPut:     0-成功，其他-失败
/// w ##Class(web.DHCEMConsInterface).AriCstNo("YS01","","88||1")
ClassMethod AriCstNo(userCode As %String, itmID As %String) As %String
{
	n (userCode, itmID)
	s userID=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(userCode),""))
	Q:userID="" "-1^用户为空"
	s Err=##Class(web.DHCEMConsult).AriCstNo(itmID, userID)
	Q Err
}

/// Creator:    	bianshuai
/// CreateDate: 	2021-08-24
/// Descript:   	会诊详情【护理组 智慧医院接口】
/// InPut:      	itmID - 会诊ID
/// OutPut:     	会诊内容内容，空
/// w ##Class(web.DHCEMConsInterface).GetPatCsDetail("74", .TmpArr)
ClassMethod GetPatCsDetail(itmID As %String, TmpArr) As %String
{
	n (itmID, TmpArr)
	k TmpArr
	s CstID=+itmID
	s EpisodeID=$p(^DHCEMCON(CstID),"^",1)      /// 就诊ID
	s PatientID=$p(^PAADM(EpisodeID),"^",1)     /// 病人ID
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s PatSex=""
	s sexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	i sexId'="" s PatSex=$p(^CT("SEX",sexId),"^",2)
	s PatAge=##class(web.DHCEMCommonUtil).GetPapmiAgeByAdmID(EpisodeID) ///年龄
	s PatLoc=""
	s PatLocID=$p(^PAADM(EpisodeID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s PatWard=""
	s PatWardID=$p(^PAADM(EpisodeID),"^",70) 	         /// 病区ID
	s:PatWardID'="" PatWard=$p(^PAWARD(PatWardID),"^",2) /// 病区描述
	s BillType=$p(^PAPER(PatientID,"PER",1),"^",10)      /// 费别
	s:BillType'="" BillType=$p(^CT("SS",BillType),"^",2)
	s BedId=$p(^PAADM(EpisodeID),"^",73) 				 /// 床号ID
  	s PatBed=""
    s:BedId'="" PatBed=$p(^PAWARD($p(BedId,"||",1),"BED",$p(BedId,"||",2)),"^",1)   /// 床号描述
    s PatTelH=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	s PatAddr=$g(^PAPER(PatientID,"PER","ADD",1)) 	    /// 家庭住址
	s PatBod=$p(^PAPER(PatientID,"ALL"),"^",6)          /// 出生日期
	i PatBod'="" s PatBod=##class(web.DHCEMCommonUtil).DateLogicalToHtml(PatBod)
	s MedicareNo=##Class(web.DHCEMConsultCom).GetMrNo(EpisodeID)  ///病案号
	s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(EpisodeID,",")   /// 诊断
	s CstRLocID=$p(^DHCEMCON(CstID),"^",2)   /// 申请科室
	s CstRLoc=""
	s:CstRLocID'="" CstRLoc=$p(^CTLOC(CstRLocID),"^",2)
	s CstRDate=$p(^DHCEMCON(CstID),"^",3)    /// 申请日期
	s CstRDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstRDate)	
	s CstRTime=$p(^DHCEMCON(CstID),"^",4)    /// 申请时间
	s:CstRTime'="" CstRTime=$zt(CstRTime,1)
	s CstRUser=""
	s CstUserID=$p(^DHCEMCON(CstID),"^",5)   /// 申请医生
	s:CstUserID'="" CstRUser=$p(^SSU("SSUSR",CstUserID),"^",2)
	s CstTrePro=$p(^DHCEMCON(CstID),"^",6)   /// 病情及诊疗经过
	s CstPurpose=$p(^DHCEMCON(CstID),"^",7)  /// 会诊的理由和目的
	s CstTypeID=$p(^DHCEMCON(CstID),"^",8)   /// 会诊类型
	s CstType=$p(^DHCEMCDI(CstTypeID),"^",2) /// 会诊类型
	s CstNDate=$p(^DHCEMCON(CstID),"^",10)   /// 会诊日期
	s CstNDate=##class(web.DHCEMCommonUtil).DateLogicalToHtml(CstNDate)	
	s CstNTime=$p(^DHCEMCON(CstID),"^",11)   /// 会诊时间
	s:CstNTime'="" CstNTime=$zt(CstNTime,1)
	s CstNPlace=$p(^DHCEMCON(CstID),"^",12)  /// 会诊地点
	s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	s CstOutFlag=$p(^DHCEMCON(CstID),"^",24) /// 是否院外
	s CstUnit=$p(^DHCEMCON(CstID),"^",25)    /// 外院名称
	s CstDocName=$p(^DHCEMCON(CstID),"^",26) /// 外院医师
	s CstRemark=$p(^DHCEMCON(CstID),"^",27)  /// 备注
	s CstUser=$p(^DHCEMCON(CstID),"^",28)    /// 联系人
	s CstPhone=$p(^DHCEMCON(CstID),"^",29)   /// 联系电话
	s CstEmFlag=$p(^DHCEMCON(CstID),"^",23)  /// 是否加急
	s CstCstType=$s(CstEmFlag="Y":"加急",1:"普通")
	s CstUserID=$p(^DHCEMCON(CstID),"^",14)  /// 审核人
	s CH="", Num=0
	F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	.s CareProvID=$p(^DHCEMCON(CstID,"I",CH),"^",2)     /// 会诊医生
	.s CsUserID=$o(^SSU("SSUSR",0,"CTPCP",+CareProvID,""))
	.s CsUser=""
	.s:CsUserID'="" CsUser=$p(^SSU("SSUSR",CsUserID),"^",2)
	.s CsLocDesc=""
	.s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)       /// 会诊科室
	.s:CsLocID'="" CsLocDesc=$p(^CTLOC(CsLocID),"^",2)
	.s Opinion=$p(^DHCEMCON(CstID,"I",CH),"^",4)       /// 会诊意见
	.s Num=Num+1
	.s ListData=PatientID_"^"_PatName_"^"_PatNo_"^"_PatSex_"^"_PatLoc_"^"_PatWard_"^"_BillType_"^"_PatBed_"^"_PatBod_"^"_PatTelH_"^"_PatAddr_"^"_MedicareNo_"^"_PatDiagDesc
    .s ListData=ListData_"^"_EpisodeID_"^"_CstRLocID_"^"_CstRLoc_"^"_CstRDate_"^"_CstRTime_"^"_CstUserID_"^"_CstRUser_"^"_CstTrePro_"^"_CstPurpose_"^"_CstNDate_"^"_CstNTime
    .s ListData=ListData_"^"_CstNPlace_"^"_CstEmFlag_"^"_CstOutFlag_"^"_CstUnit_"^"_CstDocName_"^"_CstRemark_"^"_CstUser_"^"_CstPhone_"^"_CstCstType_"^"_CsLocDesc_"^"_CsUser_"^"_Opinion_"^"_CstType
	.s TmpArr(Num)=ListData
	.
    Q ""
}

/// Creator:    	hxy
/// CreateDate: 	2022-08-10
/// Descript:   	由会诊子表ID判断是否有录医嘱权限【医生站】
/// InPut:      	ConItmID - 会诊ID
/// OutPut:     	1:有 ;其他：无
/// w ##Class(web.DHCEMConsInterface).GetTakOrdAut("17||1")
ClassMethod GetTakOrdAut(ConItmID As %String) As %String
{
	n (ConItmID)
	q:+ConItmID=0 "0"
	s Ret=##Class(web.DHCEMConsult).HasTakOrdAut(ConItmID,2)
	q Ret
}

/// 判断下会诊是否已经完成
/// ID:会诊是否已经完成
/// Return: 1(全部完成)/2(部分完成)/0(未完成)
/// w ##Class(web.DHCEMConsInterface).ConsIsComped("25")
ClassMethod ConsIsComped(ID As %String) As %String
{
	n (ID)
	
	s HasOk=0,HasNoOk=0
	s CH=""
	f {
		s CH=$o(^DHCEMCON(ID,"I",CH))
		q:CH=""
		s ItmSta=$p(^DHCEMCON(ID,"I",CH),"^",6)
		s ItmStaCode=$p($g(^DHCEMCONS(+ItmSta)),"^",1) /// 子表状态Code
		s IsComped=0
		s:(ItmStaCode>=50)&&(ItmStaCode<=70)&&(ItmStaCode'=51) IsComped=1
		s HasOk=IsComped,HasNoOk='IsComped
	}

	s:HasOk&&HasNoOk Ret=2
	s:HasOk&&'HasNoOk Ret=1
	s:'HasOk&&HasNoOk Ret=0
	s:'HasOk&&'HasNoOk Ret=0
	q Ret
}

/// 提供给电子病历
/// Return: 1(有需要归档的会诊)/0(没有需要归档的会诊)
/// w ##Class(web.DHCEMConsInterface).GetCsComFlag("141")
ClassMethod GetCsComFlag(EpisodeID)
{
	n (EpisodeID)
	s Ret=0
	s ID=""
	f {
		s ID=$o(^DHCEMCON(0,"ADM",EpisodeID,ID))
		q:ID=""
		s IsComped = ##Class(web.DHCEMConsInterface).ConsIsComped(ID)
		s:IsComped=1 Ret=1
		q:Ret
	}
	q Ret
}

/// Creator:    	hxy
/// CreateDate: 	2022-12-22
/// Descript:   	【电子病历权限管理方案】为电子病历组提供是否到本科室的有效会诊的函数，入参就诊ID、登录科室，出参：1存在有效会诊，2无会诊 3会诊已完成
/// InPut:      	就诊ID、登录科室
/// OutPut:     	1:存在有效会诊，2:无会诊 3:会诊已完成
/// w ##Class(web.DHCEMConsInterface).GetValidConFlag("5839","189")
ClassMethod GetValidConFlag(EpisodeID, LgLocID)
{
	n (EpisodeID,LgLocID)
	q:(EpisodeID="")!(LgLocID="") ""
	q:'$D(^PAADM(EpisodeID)) ""
	s Ret=3,Count=0
	s CstID=""
	F  s CstID=$o(^DHCEMCON(0,"ADM",EpisodeID,CstID)) Q:(CstID="")!(Ret'=3)  D
	.s CstStatId = $p(^DHCEMCON(CstID),"^",18)			 /// 申请状态ID
	.q:CstStatId=""                                      /// 未发送
	.s CstStatCode=$p($g(^DHCEMCONS(+CstStatId)),"^",2)  /// 申请状态Code
	.q:(CstStatCode=5)!(CstStatCode=22)!(CstStatCode=25) /// 取消！驳回！拒绝
	.s CH=""
	.F  s CH=$o(^DHCEMCON(CstID,"I",CH)) Q:CH=""  D
	..s CsLocID=$p(^DHCEMCON(CstID,"I",CH),"^",1)        /// 会诊科室
	..q:LgLocID'=CsLocID
	..s CHStatId=$p(^DHCEMCON(CstID,"I",CH),"^",6)
	..s CHStatCode=$p($g(^DHCEMCONS(+CHStatId)),"^",2)   /// 申请状态Code
	..q:CHStatCode=25                                    /// 拒绝
	..s CompTime=##Class(web.DHCEMConsultQuery).GetCstNodeTime(CstID_"||"_CH,"50") 
	..s:CompTime="" Ret=1 //存在有效会诊
	..s Count=Count+1
	.
	s:Count=0 Ret=2 //无会诊
	q Ret
}

/// Creator:    	hxy
/// CreateDate: 	2022-02-10
/// Descript:   	【电子病历】电子病历需要实现以下功能:常规会诊意见记录应当由会诊医师在会诊申请发出后48小时内完成if (($$会诊申请后时间$$>48)&&($$TitleName$$="会诊记录")) {s new=0}
/// InPut:      	就诊ID、登录科室ID
/// OutPut:     	最后一次会诊申请距当天时间多少小时
/// w ##Class(web.DHCEMConsInterface).GetHoursSinceLast("87","191")
ClassMethod GetHoursSinceLast(EpisodeID, LgLocID)
{
	n (EpisodeID,LgLocID)
	q:(EpisodeID="")!(LgLocID="") ""
	q:'$D(^PAADM(EpisodeID)) ""
	s Ret="",LastCstID=""
	s CstID=""
	F  s CstID=$o(^DHCEMCON(0,"ADM",EpisodeID,CstID),-1) Q:(CstID="")!(LastCstID'="")  D
	.s CstStatId = $p(^DHCEMCON(CstID),"^",18)			 /// 申请状态ID
	.q:CstStatId=""                                      /// 未发送
	.s CstStatCode=$p($g(^DHCEMCONS(+CstStatId)),"^",2)  /// 申请状态Code
	.q:(CstStatCode=5)!(CstStatCode=22)!(CstStatCode=25) /// 取消！驳回！拒绝
	.s LastCstID=CstID
	if (LastCstID'="")
	{
		s RDate=$p($g(^DHCEMCON(LastCstID)),"^",3)    /// 申请日期
		s RTime=$p($g(^DHCEMCON(LastCstID)),"^",4)    /// 申请时间
		s Ret=$SYSTEM.SQL.DATEDIFF("ss",RDate_","_RTime,$h)/3600
	}
	q Ret
}

}
