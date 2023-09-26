Class web.DHCANOPCareRecord Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 取病人的基本信息
/// Table：PA_Adm,PA_PatMas,PA_Person,CT_Loc,PAC_BloodType,DHC_AN_OPArrange,DHC_ANC_OperRoom,OR_Anaesthesia,OR_Anaest_Operation
/// Input：opaId:手术申请ID
/// Return：返回病人科室,姓名,性别,年龄,住院号,血型,手术间,手术日期,手术名称,入室时间,出室时间
/// 			CTLOCD_"^"_patName_"^"_patSex_"^"_patAge_"^"_patMedCareNo_"^"_patBloodType_"^"_patOpRoom_"^"_patOpDate_"^"_patOpName_"^"_StTime_"^"_EnTime
ClassMethod GetPatInfo(opaId)
{
	q:opaId="" ""
	s EpisodeID=$P(^DHCANOPArrange(opaId),"^",1)
    s PatientID=+^PAADM(EpisodeID)
	s CTLOCDr=$P(^PAADM(EpisodeID),"^",4)
    i CTLOCDr'="" d
    .s CTLOCD=$P(^CTLOC(CTLOCDr),"^",2)											//科室
    .i $L(CTLOCD,"-")>1  s CTLOCD=$P(CTLOCD,"-",2)
    e  s CTLOCD=""
    s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)								//姓名
    s patSex=$p($g(^CT("SEX",$p($g(^PAPER(PatientID,"ALL")),"^",7))),"^",2)
    s birth=$p($g(^PAPER(PatientID,"ALL")),"^",6)								
    s patAge=##class(web.DHCLCNUREXCUTE).CalAge(birth,+$h)						//年龄
    i $P(patAge,"Y",1)'="" s patAge=$P(patAge,"Y",1)_"岁"
    //s patMedCareNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",22)
	s paadmtype=$p($g(^PAADM(EpisodeID)),"^",2)
	s patMedCareNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,paadmtype,.ErrMsg)
	s patBloodTypeDr=$P(^DHCANOPArrange(opaId),"^",11)                       	//OPA_BloodType_dr	血型
	i patBloodTypeDr'="" s patBloodType=$P($G(^PAC("BLDT",patBloodTypeDr)),"^",2)
	e  s patBloodType=""
	s patOpRoomDr=$P(^DHCANOPArrange(opaId),"^",20)                       		//OPA_OpRoom_dr	手术间
	i patOpRoomDr'="" s patOpRoom=$P($G(^DHCANC("OPRoom",patOpRoomDr)),"^",2)
	e  s patOpRoom=""
	s patOpDate=$P(^DHCANOPArrange(opaId),"^",3)                       			//OPA_AppDate	手术申请日期
	i patOpDate'="" s patOpDate=$zd(patOpDate,3)
	s patOpName=""
	s anaId=$P(^DHCANOPArrange(opaId),"^",2)
	s anaSub=$p(anaId,"||",2)
	s subchl=0 f  s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl)) q:(subchl="")  d
	.s opdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",6)         			//ANAOP_Type_DR 手术名称
	.i opdr'="" d
	..s opdes=$P($g(^ORC("OPER",opdr)),"^",2)
	..i patOpName="" s patOpName=opdes
	..e  s patOpName=patOpName_","_opdes
	.s predigdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",4)   			//ANAOP_PreopDiag_DR 术前诊断
	.i predigdr'=""  d
	..s prediag=$P($g(^MRC("ID",predigdr)),"^",2)
	..s diag=$G(prediag)
	.e  d
	..i $g(^OR(EpisodeID,"ANA",anaSub,"TXT",1))'="" d 
	...s diamen=^OR(EpisodeID,"ANA",anaSub,"TXT",1)  							//ANA_Notes 麻醉表存放诊断备注
	...s diag=$G(diamen)
	.s docdr=$P(^OR(EpisodeID,"ANA",anaSub,"OP",subchl),"^",8)      			//ANAOP_Surgeon_DR   手术医师
	.i docdr'="" s opdoc=$TR($P(^CTPCP(docdr,1),"^",2)," ","")
	.e  s opdoc=""
	.s InstrNur="",cirNur=""
	.s OPSCNSub=0 f  s OPSCNSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"SCN",OPSCNSub)) q:(OPSCNSub="")  d
	..q:OPSCNSub>20	//小于20为洗手护士,大于20是交洗手护士
	..s InstrNurDr=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"SCN",OPSCNSub)),"^",1)  //OR_An_Oper_Scrub_Nurse 洗手护士或器材护士
	..i InstrNurDr'="" d
	...i InstrNur="" s InstrNur=$P(^CTPCP(InstrNurDr,1),"^",2)
	...e  s InstrNur=InstrNur_" "_$P(^CTPCP(InstrNurDr,1),"^",2) 
	.s CIRNSub=0 f  s CIRNSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"CIRN",CIRNSub)) q:(CIRNSub="")  d
	..q:CIRNSub>20	//小于20为巡回护士,大于20是交巡回护士
	..s cirNurDr=$P($g(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"CIRN",CIRNSub)),"^",1)  //OR_An_Oper_Circul_Nurse 巡回护士
	..i cirNurDr'="" d
	...i cirNurDr="" s cirNur=$P(^CTPCP(cirNurDr,1),"^",2)
	...e  s cirNur=cirNur_" "_$P(^CTPCP(cirNurDr,1),"^",2) 
	s StTime=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",40) 						//ANA_TheatreInTime  	入室时间
	i StTime'="" s StTime=$zt(StTime,2)
	s EnTime=$P($g(^OR(EpisodeID,"ANA",anaSub)),"^",42) 						//ANA_TheatreOutTime	出室时间
    i EnTime'="" s EnTime=$zt(EnTime,2)

    q CTLOCD_"^"_patName_"^"_patSex_"^"_patAge_"^"_patMedCareNo_"^"_patBloodType_"^"_patOpRoom_"^"_patOpDate_"^"_patOpName_"^"_StTime_"^"_EnTime_"^"_InstrNur_"^"_cirNur_"^"_diag_"^"_opdoc
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 保存护理记录内容
/// Table：DHC_AN_OPArrange,DHC_AN_Shift,OR_Anaesthesia,OR_Anaest_Operation,ORC_OperPosition
/// Input：opaId:手术申请ID,
/// 	SQCareRecord:术前记录,
/// 		入室时间^神志^术前静脉输液^深静脉穿刺^管道^术前皮肤情况^药物过敏^术前用药^禁饮^禁食^随身物品^体表标识^手术灭菌用物指示标记
/// 		TheatreInTime+"^"+Consciousness+"^"+SQIntravenInfusion+"^"+DeepIntravenPunc+"^"+Catheter+"^"+SQSkin+"^"+PreAllergy+"^"+PreAnaDrug+"^"+ForbidDrink+"^"+ForbidFood+"^"+VadeMecum+"^"+BodySurfIdentity+"^"+CareAsepticPackCheck
/// 	SZCareRecord:术中记录
/// 		体位^电刀类型^负极板位置^止血带^体位支撑物^体内植入物^标本^送冰冻切片^送病理标本^术中静脉输液^导尿^静脉输血^引流
/// 		OperPosition+"^"+CareElectrotome+"^"+CareNegativePlate+"^"+CareHemostaticBelt+"^"+CarePositionSupport+"^"+CareImplant+"^"+CareSpecimen+"^"+CareFreezingSlice+"^"+CarePathologSection+"^"+SZIntravenInfusion+"^"+CareUrineCatheter+"^"+BloodTranfused+"^"+CareDrainageCatheter
/// 	SHCareRecord:术后记录
/// 		出室时间^离室类型^术后静脉输液^术后皮肤情况^引流管^备注^交班人^接班人
/// 		TheatreOutTime+"^"+ANSType+"^"+SHIntravenInfusion+"^"+SHSkin+"^"+CareDrainCath+"^"+ANSNote+"^"+ShiftCtcpId+"^"+ReliefCtcpId
/// Return：成功返回0,否则返回错误信息
ClassMethod SaveCareRecord(opaId, SQCareRecord, SZCareRecord, SHCareRecord)
{
	q:opaId="" "没有手术申请记录!"
	
	s TheatreInTime=$p(SQCareRecord,"^",1)			//入室时间
	i TheatreInTime'="" s TheatreInTime=$zth(TheatreInTime,2)
	s Consciousness=$p(SQCareRecord,"^",2)			//神志
	s SQIntravenInfusion=$p(SQCareRecord,"^",3)		//术前静脉输液
	s DeepIntravenPunc=$p(SQCareRecord,"^",4)		//深静脉穿刺
	s Catheter=$p(SQCareRecord,"^",5)				//管道
	s SQSkin=$p(SQCareRecord,"^",6)					//术前皮肤情况
	s PreAllergy=$p(SQCareRecord,"^",7)				//药物过敏
	s PreAnaDrug=$p(SQCareRecord,"^",8)				//术前用药
	s ForbidDrink=$p(SQCareRecord,"^",9)			//禁饮
	s ForbidFood=$p(SQCareRecord,"^",10)			//禁食
	s VadeMecum=$p(SQCareRecord,"^",11)				//随身物品
	s BodySurfIdentity=$p(SQCareRecord,"^",12)		//体表标识
	s CareAsepticPackCheck=$p(SQCareRecord,"^",13)	//手术灭菌用物指示标记
	
	s OperPosition=$p(SZCareRecord,"^",1)			//体位
	s CareElectrotome=$p(SZCareRecord,"^",2)		//电刀类型
	s CareNegativePlate=$p(SZCareRecord,"^",3)		//负极板位置
	s CareHemostaticBelt=$p(SZCareRecord,"^",4)		//止血带
	s CarePositionSupport=$p(SZCareRecord,"^",5)	//体位支撑物
	s CareImplant=$p(SZCareRecord,"^",6)			//体内植入物
	s CareSpecimen=$p(SZCareRecord,"^",7)			//标本
	s CareFreezingSlice=$p(SZCareRecord,"^",8)		//送冰冻切片
	s CarePathologSection=$p(SZCareRecord,"^",9)	//送病理标本
	s SZIntravenInfusion=$p(SZCareRecord,"^",10)	//术中静脉输液
	s CareUrineCatheter=$p(SZCareRecord,"^",11)		//导尿
	s BloodTranfused=$p(SZCareRecord,"^",12)		//术中静脉输血
	s CareDrainageCatheter=$p(SZCareRecord,"^",13)	//术中引流

	s TheatreOutTime=$p(SHCareRecord,"^",1)			//出室时间
	i TheatreOutTime'="" s TheatreOutTime=$zth(TheatreOutTime,2)
	s ANSType=$p(SHCareRecord,"^",2)				//离室类型
	s SHIntravenInfusion=$p(SHCareRecord,"^",3)		//术后静脉输液
	s SHSkin=$p(SHCareRecord,"^",4)					//术后皮肤情况
	//s CareDrainCath=$p(SHCareRecord,"^",5)			//引流管--与术中引流使用之一
	s CareDrainCath=CareDrainageCatheter
	s ANSNote=$p(SHCareRecord,"^",6)				//备注
	s ShiftCtcpId=$p(SHCareRecord,"^",7)			//交班人
	s ReliefCtcpId=$p(SHCareRecord,"^",8)			//接班人

	k PLIST
	TSTART
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    s PLIST(124)=Consciousness						//OPA_PAConsciousness	神志
    s PLIST(108)=PreAllergy							//OPA_PAPreAllergy 		过敏史
    s PLIST(261)=PreAnaDrug							//OPA_PreAnaDrug		术前用药
    s PLIST(262)=ForbidDrink						//OPA_ForbidDrink 		过敏史
    s PLIST(263)=ForbidFood							//OPA_ForbidFood		禁食
    s PLIST(267)=CareAsepticPackCheck				//OPA_CareAsepticPackCheck手术灭菌用物指示标记
    s PLIST(269)=CareHemostaticBelt					//OPA_CareHemostaticBelt止血带
    s PLIST(272)=CarePositionSupport				//OPA_CarePositionSupport体位支撑物
    s PLIST(274)=CareElectrotome					//OPA_CareElectrotome	电刀类型
    s PLIST(276)=CareNegativePlate					//OPA_CareNegativePlate	负极板位置
    s PLIST(280)=CareUrineCatheter					//OPA_CareUrineCatheter 导尿
    s PLIST(282)=CareDrainCath						//OPA_CareDrainageCatheter引流管
    s PLIST(284)=CareFreezingSlice					//OPA_CareFreezingSlice	送冰冻切片
    s PLIST(285)=CarePathologSection				//OPA_CarePathologSection送病理标本
    s PLIST(287)=CareSpecimen						//OPA_CareSpecimen		标本
    s PLIST(288)=CareImplant						//OPA_CareImplant		体内植入物 
	&sql(update SQLUSER.DHC_AN_OPArrange Values :PLIST() where opa_rowid=:opaId)
	i SQLCODE TRollBack  q "修改手术排班表错误!"

	s err=0
	k PLIST
	s PLIST(3)=ANSType								//ANS_Type				离室类型
	s IntravenInfusion=SQIntravenInfusion_"$"_SHIntravenInfusion_"$"_SZIntravenInfusion
	s PLIST(18)=ShiftCtcpId							//ANS_ShiftCtcp_Dr		交班人
    s PLIST(19)=ReliefCtcpId						//ANS_ReliefCtcp_Dr		接班人
	s PLIST(24)=IntravenInfusion					//ANS_IntravenInfusion	静脉输液
    s PLIST(26)=DeepIntravenPunc					//ANS_DeepIntravenPunc 	深静脉穿刺
    s PLIST(27)=BodySurfIdentity					//ANS_BodySurfIdentity	体表标识
    s PLIST(28)=VadeMecum							//ANS_VadeMecum			随身物品
    s PLIST(30)=Catheter							//ANS_Catheter			管道
    s Skin=SQSkin_"$"_SHSkin
    s PLIST(34)=ANSNote								//ANS_Note				备注
    s PLIST(38)=Skin								//ANS_Skin				皮肤情况
	s PLIST(39)=BloodTranfused						//ANS_BloodTranfused	静脉输血
	s ANSSub=$o(^DHCANOPArrange(opaId,"Shift",0))
	i ANSSub'="" d
	.s ANSRowId=opaId_"||"_ANSSub
	.&sql(update SQLUSER.DHC_AN_Shift Values :PLIST() where ANS_RowId=:ANSRowId)
	.i SQLCODE s err="修改手术麻醉交班表错误!" q
	e  d
	.s PLIST(0)=opaId
	.&sql(insert into SQLUSER.DHC_AN_Shift Values :PLIST())
	.i SQLCODE s err="插入手术麻醉交班表错误!" q
	i err'=0 TRollBack  q err
	
	&sql(update SQLUSER.OR_Anaesthesia set ANA_TheatreInTime=:TheatreInTime,ANA_TheatreOutTime=:TheatreOutTime where ANA_RowId=:anaId)
	i SQLCODE'=0 TRollBack  q "写入入室时间或出室时间错误!"
	k PLIST
	s EpisodeID=+anaId
	s anaSub=$p(anaId,"||",2)
	s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",0)) 
	s anopId=EpisodeID_"||"_anaSub_"||"_subchl
	s OPPOSSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"POS",0))
	s OperPosition=$$ALPHAUP^SSUTIL4(OperPosition)
	i OperPosition'="" s operPositionId=$O(^ORC("OPPOS",0,"Code",OperPosition,""))
	e  s operPositionId=""
	i operPositionId'="" d
	.s PLIST(3)=operPositionId
	.i OPPOSSub'="" d
	..s OPPOSRowId=anopId_"||"_OPPOSSub
	..&sql(update sqluser.OR_An_Oper_Position Values :PLIST() where OPPOS_RowId=:OPPOSRowId)
	..i SQLCODE s err="更新手术体位表错误!" q
	.e  d
	..s PLIST(0)=anopId
	..&sql(INSERT INTO sqluser.OR_An_Oper_Position Values :PLIST())
	..i SQLCODE s err="插入手术体位表错误!" q
	i err'=0 TRollBack  q err
	TCOMMIT
	q 0
}

/// Creator: wangxinlei
/// CreatDate: 2009-12-22
/// Description: 取护理记录内容
/// Table：DHC_AN_OPArrange,DHC_AN_Shift,OR_Anaesthesia,OR_Anaest_Operation,ORC_OperPosition
/// Input：opaId:手术申请ID,
/// Return:
/// 	SQCareRecord:术前记录,
/// 		入室时间^神志^术前静脉输液^深静脉穿刺^管道^术前皮肤情况^药物过敏^术前用药^禁饮^禁食^随身物品^体表标识
/// 		TheatreInTime_"^"_Consciousness_"^"_SQIntravenInfusion_"^"_DeepIntravenPunc_"^"_Catheter_"^"_SQSkin_"^"_PreAllergy_"^"_PreAnaDrug_"^"_ForbidDrink_"^"_ForbidFood_"^"_VadeMecum_"^"_BodySurfIdentity_"^"_CareAsepticPackCheck
/// 	SZCareRecord:术中记录
/// 		体位^电刀类型^负极板位置^止血带^体位支撑物^体内植入物^标本^送冰冻切片^送病理标本^术中静脉输液^导尿^术中静脉输血^是否引流
/// 		OperPosition_"^"_CareElectrotome_"^"_CareNegativePlate_"^"_CareHemostaticBelt_"^"_CarePositionSupport_"^"_CareImplant_"^"_CareSpecimen_"^"_CareFreezingSlice_"^"_CarePathologSection_"^"_SZIntravenInfusion_"^"_CareUrineCatheter_"^"_BloodTranfused_"^"_CareDrainageCatheter
/// 	SHCareRecord:术后记录
/// 		出室时间^离室类型^术后静脉输液^术后皮肤情况^引流管^备注^交班人ID,交班人^接班人ID,接班人
/// 		TheatreOutTime_"^"_ANSType_"^"_SHIntravenInfusion_"^"_SHSkin_"^"_CareDrainCath_"^"_ANSNote_"^"_ShiftCtcpId_","_ShiftCtcp_"^"_ReliefCtcpId_","_ReliefCtcp
ClassMethod GetCareRecord(opaId)
{
	q:opaId="" ""
    s anaId=$P(^DHCANOPArrange(opaId),"^",2)
    s Consciousness=$P($g(^DHCANOPArrange(opaId,"PA")),"^",64)			//OPA_PAConsciousness	神志
    s PreAllergy=$P($g(^DHCANOPArrange(opaId,"PA")),"^",48)				//OPA_PAPreAllergy 		过敏史
    s PreAnaDrug=$P(^DHCANOPArrange(opaId),"^",72)						//OPA_PreAnaDrug		术前用药
    s ForbidDrink=$P(^DHCANOPArrange(opaId),"^",73)						//OPA_ForbidDrink 		过敏史
    s ForbidFood=$P(^DHCANOPArrange(opaId),"^",74)						//OPA_ForbidFood		禁食
    s CareAsepticPackCheck=$P($g(^DHCANOPArrange(opaId,"Care")),"^",3)	//OPA_CareAsepticPackCheck手术灭菌用物指示标记
    s CareHemostaticBelt=$P($g(^DHCANOPArrange(opaId,"Care")),"^",5)	//OPA_CareHemostaticBelt止血带
    s CarePositionSupport=$P($g(^DHCANOPArrange(opaId,"Care")),"^",8)	//OPA_CarePositionSupport体位支撑物
    s CareElectrotome=$P($g(^DHCANOPArrange(opaId,"Care")),"^",10)		//OPA_CareElectrotome	电刀类型
    s CareNegativePlate=$P($g(^DHCANOPArrange(opaId,"Care")),"^",12)	//OPA_CareNegativePlate	负极板位置
    s CareUrineCatheter=$P($g(^DHCANOPArrange(opaId,"Care")),"^",16)	//OPA_CareUrineCatheter	导尿
    s CareDrainCath=$P($g(^DHCANOPArrange(opaId,"Care")),"^",18)		//OPA_CareDrainageCatheter引流管
    s CareDrainageCatheter=CareDrainCath
    s CareFreezingSlice=$P($g(^DHCANOPArrange(opaId,"Care")),"^",20)	//OPA_CareFreezingSlice	送冰冻切片
    s CarePathologSection=$P($g(^DHCANOPArrange(opaId,"Care")),"^",21)	//OPA_CarePathologSection送病理标本
    s CareSpecimen=$P($g(^DHCANOPArrange(opaId,"Care")),"^",23)			//OPA_CareSpecimen		标本
    s CareImplant=$P($g(^DHCANOPArrange(opaId,"Care")),"^",24)			//OPA_CareImplant		体内植入物 


	s ANSType="",SQIntravenInfusion="",SHIntravenInfusion="",DeepIntravenPunc="",BodySurfIdentity="",VadeMecum="",Catheter="",SQSkin="",SHSkin="",ANSNote="",ShiftCtcpId="",ShiftCtcp="",ReliefCtcpId="",ReliefCtcp="",SZIntravenInfusion="",BloodTranfused=""
	s ANSSub=$o(^DHCANOPArrange(opaId,"Shift",0))
	i ANSSub'="" d
	.s ANSType=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",1)				//ANS_Type				离室类型
	.s IntravenInfusion=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",22)	//ANS_IntravenInfusion	静脉输液
    .s SQIntravenInfusion=$P(IntravenInfusion,"$",1)
    .s SHIntravenInfusion=$P(IntravenInfusion,"$",2)
    .s SZIntravenInfusion=$P(IntravenInfusion,"$",3)
    .s DeepIntravenPunc=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",24)	//ANS_DeepIntravenPunc 	深静脉穿刺
    .s BodySurfIdentity=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",25)	//ANS_BodySurfIdentity	体表标识
    .s VadeMecum=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",26)			//ANS_VadeMecum			随身物品
    .s Catheter=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",28)			//ANS_Catheter			管道
    .s ANSNote=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",32)				//ANS_Note				备注
    .s Skin=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",36)				//ANS_Skin				皮肤情况
	.s SQSkin=$P(Skin,"$",1)
	.s SHSkin=$P(Skin,"$",2)
    .s BloodTranfused=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",37)		//ANS_BloodTranfused	静脉输血
	.s ShiftCtcpId=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",16)			//ANS_ShiftCtcp_Dr		交班人
	.i ShiftCtcpId'="" s ShiftCtcp=$P(^CTPCP(ShiftCtcpId,1),"^",2)
	.s ReliefCtcpId=$P(^DHCANOPArrange(opaId,"Shift",ANSSub),"^",17)		//ANS_ReliefCtcp_Dr		接班人
	.i ReliefCtcpId'="" s ReliefCtcp=$P(^CTPCP(ReliefCtcpId,1),"^",2)

	s EpisodeID=+anaId
	s anaSub=$p(anaId,"||",2)
	s TheatreInTime=$P(^OR(EpisodeID,"ANA",anaSub),"^",40) 			//ANA_TheatreInTime  	入室时间
	i TheatreInTime'="" s TheatreInTime=$zt(TheatreInTime,2)
	s TheatreOutTime=$P(^OR(EpisodeID,"ANA",anaSub),"^",42) 		//ANA_TheatreOutTime	出室时间
	i TheatreOutTime'="" s TheatreOutTime=$zt(TheatreOutTime,2)
	s OperPosition=""
	s subchl=$O(^OR(EpisodeID,"ANA",anaSub,"OP",0)) 
	s OPPOSSub=$O(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"POS",0))	//OR_Anaest_Operation	体位
	i OPPOSSub'="" d
	.s operPositionId=$p(^OR(EpisodeID,"ANA",anaSub,"OP",subchl,"POS",OPPOSSub),"^",1)
	.i operPositionId'="" s OperPosition=$P(^ORC("OPPOS",operPositionId),"^",2)
	s SQCareRecord=TheatreInTime_"^"_Consciousness_"^"_SQIntravenInfusion_"^"_DeepIntravenPunc_"^"_Catheter_"^"_SQSkin_"^"_PreAllergy_"^"_PreAnaDrug_"^"_ForbidDrink_"^"_ForbidFood_"^"_VadeMecum_"^"_BodySurfIdentity_"^"_CareAsepticPackCheck
	s SZCareRecord=OperPosition_"^"_CareElectrotome_"^"_CareNegativePlate_"^"_CareHemostaticBelt_"^"_CarePositionSupport_"^"_CareImplant_"^"_CareSpecimen_"^"_CareFreezingSlice_"^"_CarePathologSection_"^"_SZIntravenInfusion_"^"_CareUrineCatheter_"^"_BloodTranfused_"^"_CareDrainageCatheter
	s SHCareRecord=TheatreOutTime_"^"_ANSType_"^"_SHIntravenInfusion_"^"_SHSkin_"^"_CareDrainCath_"^"_ANSNote_"^"_ShiftCtcpId_","_ShiftCtcp_"^"_ReliefCtcpId_","_ReliefCtcp
	q SQCareRecord_"@"_SZCareRecord_"@"_SHCareRecord
}

}
