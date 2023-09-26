Import SQLUser

/// Creator:    bianshuai
/// CreateDate: 2014-11-27
/// Descript:   药学查房
Class web.DHCSTPHCMWARDROUND Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Descript:药学查房
/// w ##class(web.DHCSTPHCMWARDROUND).SaveWardRound("","1602||2||2||A||1.骨折,2.骨折||New||hello||2^1||1.1||1.2^aa^aa^cc^dd^ee^ff^16149701||14,16149701||15")
/// w ##class(web.DHCSTPHCMWARDROUND).SaveWardRound("","861||14||10||||1.高血压病,2.脑动脉供血不足,3.脑动脉供血不足,4.视网膜动脉供血不足,5.视网膜动脉供血不足||New||新入院患者测试||578||60KG^^现病史测试^既往病史测试^既往用药史测试^个人史及家族史测试^伴发疾病与用药情况测试^过敏史测试^812||13")
ClassMethod SaveWardRound(wardRoundID As %String, wrDataList As %String) As %String
{
	n (wardRoundID,wrDataList)
	s wrMainDataList=$p(wrDataList,"^",1)    //查房主信息
	s wrGuidanceList=$p(wrDataList,"^",2)    //查房指导意见
	s wrHisPreComList=$p(wrDataList,"^",3)   //现病史
	s wrPasDisHisList=$p(wrDataList,"^",4)   //既往病史
	s wrPasMedHisList=$p(wrDataList,"^",5)   //既往用药史
	s wrPerFamHisList=$p(wrDataList,"^",6)   //个人史及家族史
	s wrConDisTreList=$p(wrDataList,"^",7)   //伴发疾病与用药
	s wrAllergicHisList=$p(wrDataList,"^",8) //过敏史
	s wrDrgItmList=$p(wrDataList,"^",9)      //药品
	s ret=0
	i wardRoundID="" d
	.S ret=..Insert(wrMainDataList,wrGuidanceList,wrHisPreComList,wrPasDisHisList,wrPasMedHisList,wrPerFamHisList,wrConDisTreList,wrAllergicHisList,wrDrgItmList)
	e  d
	.S ret=..Update(wardRoundID,wrMainDataList,wrGuidanceList,wrHisPreComList,wrPasDisHisList,wrPasMedHisList,wrPerFamHisList,wrConDisTreList,wrAllergicHisList,wrDrgItmList)
	q ret
}

/// Descript:药学查房
ClassMethod Insert(wrDataList, wrGuidanceList, wrHisPreComList, wrPasDisHisList, wrPasMedHisList, wrPerFamHisList, wrConDisTreList, wrAllergicHisList, wrDrgItmList) As %String
{
	N (wrDataList,wrGuidanceList,wrHisPreComList,wrPasDisHisList,wrPasMedHisList,wrPerFamHisList,wrConDisTreList,wrAllergicHisList,wrDrgItmList)
	s Err=0
	TS
	//查房主表
	s wardRoundID=..InsWardRound(wrDataList)
	i wardRoundID<0 tro
	q:wardRoundID<0 wardRoundID
	
	//指导意见
	i wrGuidanceList'="" d
	.s Err=..InsDHCPHWRGuidance(wardRoundID, wrGuidanceList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//现病史
	i wrHisPreComList'="" d
	.s Err=..InsDHCPHWRHisPreCom(wardRoundID, wrHisPreComList)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	//既往病史
	i wrPasDisHisList'="" d
	.s Err=..InsDHCPHWRPasDisHis(wardRoundID, wrPasDisHisList)
	i Err'=0 tro
	q:Err'=0 "-13"

	//既往用药史
	i wrPerFamHisList'="" d
	.s Err=..InsDHCPHWRPasMedHis(wardRoundID, wrPasMedHisList)
	i Err'=0 tro
	q:Err'=0 "-14"

	//个人史及家族史
	i wrPerFamHisList'="" d
	.s Err=..InsDHCPHWRPerAndFamHis(wardRoundID, wrPerFamHisList)
	i Err'=0 tro
	q:Err'=0 "-14"
	
	//伴发疾病与用药情况
	i wrConDisTreList'="" d
	.s Err=..InsDHCPHWRConDisAndTre(wardRoundID, wrConDisTreList)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	//过敏史
	i wrAllergicHisList'="" d
	.s Err=..InsDHCPHWRAllergicHis(wardRoundID, wrAllergicHisList)
	i Err'=0 tro
	q:Err'=0 "-16"
	
	//查房关注药品
	i wrDrgItmList'="" d
	.s Err=..InsDHCPHWRDrgItm(wardRoundID, wrDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-17"

	TC
	Q 0
}

/// Descript:药学查房
ClassMethod Update(wardRoundID, wrDataList, wrGuidanceList, wrHisPreComList, wrPasDisHisList, wrPasMedHisList, wrPerFamHisList, wrConDisTreList, wrAllergicHisList, wrDrgItmList) As %String
{
	N (wardRoundID,wrDataList,wrGuidanceList,wrHisPreComList,wrPasDisHisList,wrPasMedHisList,wrPerFamHisList,wrConDisTreList,wrAllergicHisList,wrDrgItmList)
	s Err=0

	TS
	//查房主表 
	s Err=..UpdWardRound(wardRoundID, wrDataList)
	i Err'=0 tro
	q:Err'=0 "-10"

	//删除相关子表
	s Err=..DelWardRoundRelaTable(wardRoundID)
	i Err'=0 tro
	q:Err'=0 Err
	
	//指导意见
	i wrGuidanceList'="" d
	.s Err=..InsDHCPHWRGuidance(wardRoundID, wrGuidanceList)
	i Err'=0 tro
	q:Err'=0 "-11"
	
	//现病史
	i wrHisPreComList'="" d
	.s Err=..InsDHCPHWRHisPreCom(wardRoundID, wrHisPreComList)
	i Err'=0 tro
	q:Err'=0 "-12"
	
	//既往病史
	i wrPasDisHisList'="" d
	.s Err=..InsDHCPHWRPasDisHis(wardRoundID, wrPasDisHisList)
	i Err'=0 tro
	q:Err'=0 "-13"

	//既往用药史
	i wrPerFamHisList'="" d
	.s Err=..InsDHCPHWRPasMedHis(wardRoundID, wrPasMedHisList)
	i Err'=0 tro
	q:Err'=0 "-14"

	//个人史及家族史
	i wrPerFamHisList'="" d
	.s Err=..InsDHCPHWRPerAndFamHis(wardRoundID, wrPerFamHisList)
	i Err'=0 tro
	q:Err'=0 "-14"
	
	//伴发疾病与用药情况
	i wrConDisTreList'="" d
	.s Err=..InsDHCPHWRConDisAndTre(wardRoundID, wrConDisTreList)
	i Err'=0 tro
	q:Err'=0 "-15"
	
	//过敏史
	i wrAllergicHisList'="" d
	.s Err=..InsDHCPHWRAllergicHis(wardRoundID, wrAllergicHisList)
	i Err'=0 tro
	q:Err'=0 "-16"
	
	//查房关注药品
	i wrDrgItmList'="" d
	.s Err=..InsDHCPHWRDrgItm(wardRoundID, wrDrgItmList)
	i Err'=0 tro
	q:Err'=0 "-17"

	TC
	Q 0
}

/// Descript:插入查房信息
ClassMethod InsWardRound(wrDataList As %String) As %String
{
	N (wrDataList)
	S WRAdmDr=$p(wrDataList,"||",1)     //病人Adm
	S WRWardDr=$p(wrDataList,"||",2)    //病区ID
	S WRDeptDr=$p(wrDataList,"||",3)    //科室ID
	S WRBloodType=$p(wrDataList,"||",4) //血型
	S WRICDesc=$p(wrDataList,"||",5)    //诊断
	S WRCurStatus=$p(wrDataList,"||",6) //当前状态
	i WRCurStatus="New" s WRCurStatus="N"
	else  if WRCurStatus="In" s WRCurStatus="I"
	else  s WRCurStatus="O"
	S WRGuidance=$p(wrDataList,"||",7)  //指导意见
	S WRUserDr=$p(wrDataList,"||",8)    //记录人
	S WRWeight=$p(wrDataList,"||",9)    //体重
	S WRDrugInstruction=$p(wrDataList,"||",10) //药品注意事项
	S WRDate=+$H                        //记录日期
	S WRTime=$p($H,",",2)               //记录日期
	&SQL(Insert Into DHC_PHWardRound(PHWR_Adm_Dr,PHWR_Ward_Dr,PHWR_Dept_Dr,PHWR_BloodType,PHWR_ICDesc,PHWR_CurStatus,PHWR_Guidance,PHWR_User_Dr,PHWR_Date,PHWR_Time,PHWR_Weight,PHWR_Instruction) 
		Values(:WRAdmDr,:WRWardDr,:WRDeptDr,:WRBloodType,:WRICDesc,:WRCurStatus,:WRGuidance,:WRUserDr,:WRDate,:WRTime,:WRWeight,:WRDrugInstruction))
	I SQLCODE'=0  Q SQLCODE
	Q +%ROWID
}

/// Descript:更新查房信息
ClassMethod UpdWardRound(wardRoundID As %String, wrDataList As %String) As %String
{
	N (wardRoundID,wrDataList)
	S WRAdmDr=$p(wrDataList,"||",1)     //病人Adm
	S WRWardDr=$p(wrDataList,"||",2)    //病区ID
	S WRDeptDr=$p(wrDataList,"||",3)    //科室ID
	S WRBloodType=$p(wrDataList,"||",4) //血型
	S WRICDesc=$p(wrDataList,"||",5)    //诊断
	S WRCurStatus=$p(wrDataList,"||",6) //当前状态
	i WRCurStatus="New" s WRCurStatus="N"
	else  if WRCurStatus="In" s WRCurStatus="I"
	else  s WRCurStatus="O"
	S WRGuidance=$p(wrDataList,"||",7)  //指导意见
	S WRUserDr=$p(wrDataList,"||",8)    //记录人
	S WRDate=+$H                       //记录日期
	S WRTime=$p($H,",",2)              //记录日期
	S WRDrugInstruction=$p(wrDataList,"||",10) //药品注意事项
	S WRWeight=$p(wrDataList,"||",9)    //体重
	
	&SQL(Update DHC_PHWardRound Set PHWR_Adm_Dr=:WRAdmDr,PHWR_Ward_Dr=:WRWardDr,PHWR_Dept_Dr=:WRDeptDr,PHWR_BloodType=:WRBloodType,
		PHWR_ICDesc=:WRICDesc,PHWR_CurStatus=:WRCurStatus,PHWR_Guidance=:WRGuidance,PHWR_User_Dr=:WRUserDr,PHWR_Date=:WRDate,
		PHWR_Time=:WRTime,PHWR_Instruction=:WRDrugInstruction,PHWR_Weight=:WRWeight Where PHWR_RowID=:wardRoundID)
	Q SQLCODE
}

/// Descript:保存临床查房指导意见表
ClassMethod InsDHCPHWRGuidance(wardRoundID As %String, wrGuidanceList As %String) As %String
{
	N (wardRoundID,wrGuidanceList)
	;S wrGuidanceList1=$p(wrGuidanceList,"!",1)
	S Len=$L(wrGuidanceList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S wrGuidance=$p($p(wrGuidanceList,"!",1),"||",i)
	.;S ItemCode=$p(wrGuidance,"^",1)     //代码
	.;S ItemDesc=$p(wrGuidance,"^",2)     //指导意见
	.s ItemCode=wrGuidance
	.q:ItemCode=""
	.s ItemDesc=""
	.s:ItemCode="-100" ItemDesc=$p(wrGuidanceList,"!",2)
	.S childSub=$o(^DHCPHWR(wardRoundID,"G",""),-1)+1
	.&SQL(Insert into DHC_PHWRGuidance(PHWRG_PHWR_Parref,PHWRG_ChildSub,PHWRG_Code,PHWRG_Desc)
		Values(:wardRoundID,:childSub,:ItemCode,:ItemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除临床查房指导意见表
ClassMethod DelDHCPHWRGuidance(wardRoundID As %String) As %String
{
	N (wardRoundID)
	&SQL(delete from DHC_PHWRGuidance where PHWRG_PHWR_Parref=:wardRoundID)
	Q SQLCODE
}

/// Descript:保存现病史
ClassMethod InsDHCPHWRHisPreCom(wardRoundID As %String, wrHisPreComList As %String) As %String
{
	N (wardRoundID,wrHisPreComList)
	S Len=$L(wrHisPreComList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S wrHisPreCom=$p(wrHisPreComList,"||",i)
	.S ItemDesc=$p(wrHisPreCom,"^",1)     //描述
	.S childSub=$o(^DHCPHWR(wardRoundID,"HPC",""),-1)+1
	.&SQL(Insert into DHC_PHWRHisPreCom(PHHPC_PHWR_Parref,PHHPC_ChildSub,PHHPC_Desc)
		Values(:wardRoundID,:childSub,:ItemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除现病史
ClassMethod DelDHCPHWRHisPreCom(wardRoundID As %String) As %String
{
	N (wardRoundID)
	&SQL(delete from DHC_PHWRHisPreCom where PHHPC_PHWR_Parref=:wardRoundID)
	Q SQLCODE
}

/// Descript:保存既往病史
ClassMethod InsDHCPHWRPasDisHis(wardRoundID As %String, wrPasDisHisList As %String) As %String
{
	N (wardRoundID,wrPasDisHisList)
	S Len=$L(wrPasDisHisList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S wrPasDisHis=$p(wrPasDisHisList,"||",i)
	.S ItemDesc=$p(wrPasDisHis,"^",1)     //描述
	.S childSub=$o(^DHCPHWR(wardRoundID,"PDH",""),-1)+1
	.&SQL(Insert into DHC_PHWRPasDisHis(PHPDH_PHWR_Parref,PHPDH_ChildSub,PHPDH_Desc)
		Values(:wardRoundID,:childSub,:ItemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除既往病史
ClassMethod DelDHCPHWRPasDisHis(wardRoundID As %String) As %String
{
	N (wardRoundID)
	&SQL(delete from DHC_PHWRPasDisHis where PHPDH_PHWR_Parref=:wardRoundID)
	Q SQLCODE
}

/// Descript:保存既往用药史
ClassMethod InsDHCPHWRPasMedHis(wardRoundID As %String, wrPasMedHisList As %String) As %String
{
	N (wardRoundID,wrPasMedHisList)
	S Len=$L(wrPasMedHisList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S wrPasMedHis=$p(wrPasMedHisList,"||",i)
	.S ItemDesc=$p(wrPasMedHis,"^",1)     //描述
	.S childSub=$o(^DHCPHWR(wardRoundID,"PMH",""),-1)+1
	.&SQL(Insert into DHC_PHWRPasMedHis(PHPMH_PHWR_Parref,PHPMH_ChildSub,PHPMH_Desc)
		Values(:wardRoundID,:childSub,:ItemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除既往用药史
ClassMethod DelDHCPHWRPasMedHis(wardRoundID As %String) As %String
{
	N (wardRoundID)
	&SQL(delete from DHC_PHWRPasMedHis where PHPMH_PHWR_Parref=:wardRoundID)
	Q SQLCODE
}

/// Descript:保存个人史及家族史
ClassMethod InsDHCPHWRPerAndFamHis(wardRoundID As %String, wrPerFamHisList As %String) As %String
{
	N (wardRoundID,wrPerFamHisList)
	S Len=$L(wrPerFamHisList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S wrPerFamHis=$p(wrPerFamHisList,"||",i)
	.S ItemDesc=$p(wrPerFamHis,"^",1)     //描述
	.S childSub=$o(^DHCPHWR(wardRoundID,"PFH",""),-1)+1
	.&SQL(Insert into DHC_PHWRPerAndFamHis(PHPFH_PHWR_Parref,PHPFH_ChildSub,PHPFH_Desc)
		Values(:wardRoundID,:childSub,:ItemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除个人史及家族史
ClassMethod DelDHCPHWRPerAndFamHis(wardRoundID As %String) As %String
{
	N (wardRoundID)
	&SQL(delete from DHC_PHWRPerAndFamHis where PHPFH_PHWR_Parref=:wardRoundID)
	Q SQLCODE
}

/// Descript:保存伴发疾病与用药情况
ClassMethod InsDHCPHWRConDisAndTre(wardRoundID As %String, wrConDisTreList As %String) As %String
{
	N (wardRoundID,wrConDisTreList)
	S Len=$L(wrConDisTreList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S wrConDisTre=$p(wrConDisTreList,"||",i)
	.S ItemDesc=$p(wrConDisTre,"^",1)     //描述
	.S childSub=$o(^DHCPHWR(wardRoundID,"CDT",""),-1)+1
	.&SQL(Insert into DHC_PHWRConDisAndTre(PHCDT_PHWR_Parref,PHCDT_ChildSub,PHCDT_Desc)
		Values(:wardRoundID,:childSub,:ItemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除伴发疾病与用药情况
ClassMethod DelDHCPHWRConDisAndTre(wardRoundID As %String) As %String
{
	N (wardRoundID)
	&SQL(delete from DHC_PHWRConDisAndTre where PHCDT_PHWR_Parref=:wardRoundID)
	Q SQLCODE
}

/// Descript:保存过敏史
ClassMethod InsDHCPHWRAllergicHis(wardRoundID As %String, wrAllergicHisList As %String) As %String
{
	N (wardRoundID,wrAllergicHisList)
	S Len=$L(wrAllergicHisList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S wrAllerHis=$p(wrAllergicHisList,"||",i)
	.S ItemDesc=$p(wrAllerHis,"^",1)     //描述
	.S childSub=$o(^DHCPHWR(wardRoundID,"AH",""),-1)+1
	.&SQL(Insert into DHC_PHWRAllergicHis(PHAH_PHWR_Parref,PHAH_ChildSub,PHAH_Desc)
		Values(:wardRoundID,:childSub,:ItemDesc))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除过敏史
ClassMethod DelDHCPHWRAllergicHis(wardRoundID As %String) As %String
{
	N (wardRoundID)
	&SQL(delete from DHC_PHWRAllergicHis where PHAH_PHWR_Parref=:wardRoundID)
	Q SQLCODE
}

/// Descript:保存药学查房关注药品
ClassMethod InsDHCPHWRDrgItm(wardRoundID As %String, wrDrgItmList As %String) As %String
{
	N (wardRoundID,wrDrgItmList)
	S Len=$L(wrDrgItmList,",")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S wrDrgItm=$p(wrDrgItmList,",",i)
	.S oeoriDr=$p(wrDrgItm,"^",1)     //医嘱ID
	.S childSub=$o(^DHCPHWR(wardRoundID,"DI",""),-1)+1
	.&SQL(Insert into DHC_PHWRDrgItm(PHDI_PHWR_Parref,PHDI_ChildSub,PHDI_OEORI_DR)
		Values(:wardRoundID,:childSub,:oeoriDr))
	.i SQLCODE'=0 S quitflag="1"
	.
	Q quitflag
}

/// Descript:删除药学查房关注药品
ClassMethod DelDHCPHWRDrgItm(wardRoundID As %String) As %String
{
	N (wardRoundID)
	&SQL(delete from DHC_PHWRDrgItm where PHDI_PHWR_Parref=:wardRoundID)
	Q SQLCODE
}

/// Descript: 删除查房相关信息表
/// w ##class(web.DHCSTPHCMWARDROUND).DelWardRoundRelaTable("11")
ClassMethod DelWardRoundRelaTable(wardRoundID As %String) As %String
{
	n (wardRoundID)
	s SQLCODE=0
	//临床查房指导意见表
	i $d(^DHCPHWR(wardRoundID,"G",1)) d
	.&SQL(delete from DHC_PHWRGuidance where PHWRG_PHWR_Parref=:wardRoundID)
	q:SQLCODE'=0 SQLCODE
	
	//现病史
	i $d(^DHCPHWR(wardRoundID,"HPC",1)) d
	.&SQL(delete from DHC_PHWRHisPreCom where PHHPC_PHWR_Parref=:wardRoundID)
	q:SQLCODE'=0 SQLCODE
	
	//既往病史
	i $d(^DHCPHWR(wardRoundID,"PDH",1)) d
	.&SQL(delete from DHC_PHWRPasDisHis where PHPDH_PHWR_Parref=:wardRoundID)
	q:SQLCODE'=0 SQLCODE
	
	//既往用药史
	i $d(^DHCPHWR(wardRoundID,"PMH",1)) d
	.&SQL(delete from DHC_PHWRPasMedHis where PHPMH_PHWR_Parref=:wardRoundID)
	q:SQLCODE'=0 SQLCODE
	
	//个人史及家族史
	i $d(^DHCPHWR(wardRoundID,"PFH",1)) d
	.&SQL(delete from DHC_PHWRPerAndFamHis where PHPFH_PHWR_Parref=:wardRoundID)
	q:SQLCODE'=0 SQLCODE
	
	//伴发疾病与用药情况
	i $d(^DHCPHWR(wardRoundID,"CDT",1)) d
	.&SQL(delete from DHC_PHWRConDisAndTre where PHCDT_PHWR_Parref=:wardRoundID)
	q:SQLCODE'=0 SQLCODE
	
	//过敏史
	i $d(^DHCPHWR(wardRoundID,"AH",1)) d
	.&SQL(delete from DHC_PHWRAllergicHis where PHAH_PHWR_Parref=:wardRoundID)
	q:SQLCODE'=0 SQLCODE
	
	//药学查房关注药品
	i $d(^DHCPHWR(wardRoundID,"DI",1)) d
	.&SQL(delete from DHC_PHWRDrgItm where PHDI_PHWR_Parref=:wardRoundID)
	q:SQLCODE'=0 SQLCODE
	
	q 0
}

/// Descript:获取查房数据
/// w ##class(web.DHCSTPHCMWARDROUND).getWardRound("16243032","New")
ClassMethod getWardRound(AdmDr As %String, curStatus As %String) As %String
{
	N (AdmDr,curStatus,%session)
	s retjson=##class(PHA.COM.Object).%New()
	i curStatus="New"  s curStatus="N"
	e  i curStatus="Out"  s curStatus="O"
	S wardRoundID=$o(^DHCPHWR(0,"CurStatus",curStatus,AdmDr,""),-1)	
	s retjson.RowId=wardRoundID
	i wardRoundID=""  d
    .Set obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(AdmDr,"HDSD00.13.01")
	.s retjson.ChiefCom =##class(PHA.CPW.Com.OutInterfance).GetTransDesc(obj.GetAt("HDSD00.13.114"))   		///主诉
	.s retjson.CurrentMed =##class(PHA.CPW.Com.OutInterfance).GetTransDesc(obj.GetAt("HDSD00.13.095"))		///现病史
	.s retjson.PastHistory =##class(PHA.CPW.Com.OutInterfance).GetTransDesc(obj.GetAt("HDSD00.13.042"))		///既往史 (疾病史)
	.s retjson.Personal =##class(PHA.CPW.Com.OutInterfance).GetTransDesc(obj.GetAt("HDSD00.13.036"))   		///个人史
	.s retjson.MarryHistory = ##class(PHA.CPW.Com.OutInterfance).GetTransDesc(obj.GetAt("HDSD00.13.041"))  	///婚育史
	.s retjson.Menstruation = ##class(PHA.CPW.Com.OutInterfance).GetTransDesc(obj.GetAt("HDSD00.13.106"))   	///月经史
	.s retjson.Family =##class(PHA.CPW.Com.OutInterfance).GetTransDesc(obj.GetAt("HDSD00.13.043"))  			///家族史	
	.s retjson.Examination = ##class(PHA.CPW.Com.OutInterfance).GetTransDesc(obj.GetAt("HDSD00.13.301"))		///obj.GetAt("HDSD00.13.088")   ///体格检查
	.s retjson.Assist = ##class(PHA.CPW.Com.OutInterfance).GetTransDesc(obj.GetAt("HDSD00.13.035"))   		///辅助检查
	.s retjson.Consultations = ##class(PHA.CPW.Com.OutInterfance).GetTransDesc(obj.GetAt("HDSD00.13.112"))    ///四诊概要
	.s retjson.Specialist = ##class(PHA.CPW.Com.OutInterfance).GetTransDesc(obj.GetAt("HDSD00.13.118"))  		///专科检查
	.;s retjson.Allergy =obj.GetAt("HDSD00.13.037")   		///过敏史
	.s retjson.patPMDrgHisDesc =##class(PHA.CPW.Com.OutInterfance).GetTransDesc(obj.GetAt("HDSD00.13.065")_obj.GetAt("HDSD00.13.066"))  ///既往用药史->手术史 输血史 
	.s PatientID=$p(^PAADM(AdmDr),"^",1)
    .s retjson.patAllergicHis=##class(web.DHCSTPHCMCOMMON).GetPatAllergies(PatientID)  //2020.2.5 调用医生站接口取过敏史
	e  d
	.S AdmDr=$p(^DHCPHWR(wardRoundID),"^",1)     //病人Adm
    .S AdmWard=""
	.S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	.I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
    .S retjson.AdmBed=##class(web.DHCSTPHCMCOMMON).getBed(AdmDr)
    .S Papmi=$p(^PAADM(AdmDr),"^",1)
    .S retjson.PatName=$p(^PAPER(Papmi,"ALL"),"^",1)      //姓名
	.S retjson.PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)      //登记号
	.S retjson.mobPhone=$p(^PAPER(Papmi,"PER",4),"^",21)  //电话
    .S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )       //姓别
	.S retjson.PatSex=$p(^CT("SEX",SexID),"^",2)
	.S retjson.PatAge=##class(PHA.FACE.IN.Com).GetAge(Papmi,AdmDr)  //年龄
	

	.S retjson.WRWard=""
	.S WRWardDr=$p(^DHCPHWR(wardRoundID),"^",2)    //病区ID
	.S:WRWardDr'="" retjson.WRWard=##class(PHA.FACE.IN.Com).GetTransDesc("User.PACWard","WARDDesc","",$p(^PAWARD(WRWardDr),"^",2))
	.S retjson.WRDept=""
	.S WRDeptDr=$p(^DHCPHWR(wardRoundID),"^",3)    //科室ID
	.S:WRDeptDr'="" retjson.WRDept=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",$p(^CTLOC(WRDeptDr),"^",2))
	.S retjson.WRBloodType=$p(^DHCPHWR(wardRoundID),"^",4) //血型
	.S retjson.WRICDesc=##class(PHA.CPW.Com.OutInterfance).GetTransDesc($p(^DHCPHWR(wardRoundID),"^",5))    //诊断
	.S retjson.WRCurStatus=$p(^DHCPHWR(wardRoundID),"^",6) //当前状态
	.S retjson.WRGuidance=##class(PHA.CPW.Com.OutInterfance).GetTransDesc($p(^DHCPHWR(wardRoundID),"^",7))  //指导意见
    .S retjson.PatH=##class(PHA.COM.Order).PatHeight(AdmDr)       //身高
	.s PatW = $p(^DHCPHWR(wardRoundID),"^",11) 
	.i PatW="" 	S retjson.PatW=##class(PHA.COM.Order).PatWeight(AdmDr)       //体重	
	.S WRUser=""
	.S WRUserDr=$p(^DHCPHWR(wardRoundID),"^",8)    //记录人
	.S:WRUserDr'="" retjson.WRUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",$p(^SSU("SSUSR",WRUserDr),"^",2))
	.S WRDate=$p(^DHCPHWR(wardRoundID),"^",9)      //记录日期
	.S:WRDate'="" retjson.WRDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(WRDate) ;$zd(WRDate,3)
	.S WRTime=$p(^DHCPHWR(wardRoundID),"^",10)     //记录日期
	.S:WRTime'="" retjson.WRTime=$zt(WRTime,2)
	.S retjson.WRDrugInstruction=##class(PHA.CPW.Com.OutInterfance).GetTransDesc($p(^DHCPHWR(wardRoundID),"^",12)) //用药注意事项
	
	
	
    .S GuidanceList=..getWRGuidance(wardRoundID)      //临床查房指导意见表
	.s retjson.wrGuidanceList=GuidanceList
	.S wrGuidanceOther=""
	.i GuidanceList[-100 s retjson.wrGuidanceOther=..getWRGuidanceDesc(wardRoundID)
	.S retjson.wrHisPreComList=..getWRHisPreCom(wardRoundID)    //现病史
	.S retjson.wrPasDisHisList=..getWRPasDisHis(wardRoundID)    //既往病史
	.S retjson.wrPasMedHisList=..getWRPasMedHis(wardRoundID)    //既往用药史
	.S retjson.wrPerFamHisList=..getWRPerFamHis(wardRoundID)    //个人史及家族史
	.S retjson.wrConDisTreList=..getWRConDisTre(wardRoundID)    //伴发疾病与用药情况
	.S retjson.wrAllergHisList=..getWRAlleicHis(wardRoundID)    //过敏史
	q retjson.ToJSON()
	
	//S ret=wrMasDataList_"!"_wrGuidanceList_"!"_wrHisPreComList_"!"_wrPasDisHisList
	//S ret=ret_"!"_wrPasMedHisList_"!"_wrPerFamHisList_"!"_wrConDisTreList_"!"_wrAllergHisList_"!"_wardRoundID_"!"_wrGuidanceOther
	
	//Q ret
}

/// Descript:获取查房数据
/// 住院期间患者列表
/// w ##class(web.DHCSTPHCMWARDROUND).getPatWardRecord("15","1","1602","In","2014-10-10","2016-12-12")
ClassMethod getPatWardRecord(rows, page, AdmDr, curStatus, startDate, endDate) As %String
{
	n (rows,page,AdmDr,curStatus,startDate,endDate,%session)
	s pid=##class(web.DHCSTPHCMCOMMON).GetPID()
	i curStatus="In"  s curStatus="I"
	s stdate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(startDate) ;$zdh(startDate,3)
	s enddate=##class(web.DHCSTPHCMCOMMON).DateHtmlToLogical(endDate) ;$zdh(endDate,3)
	
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	
	s h=0
	s fdate=0
	f fdate=stdate:1:enddate  d
	.s wardRoundID=""
	.f  s wardRoundID=$o(^DHCPHWR(0,"DataAdm",fdate,AdmDr,wardRoundID)) q:(wardRoundID="")||(wardRoundID=0)  d
	..S AdmDr=$p(^DHCPHWR(wardRoundID),"^",1)     //病人Adm
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
	..S PatAge=##class(PHA.FACE.IN.Com).GetAge(Papmi,AdmDr)  //年龄
	..S PatW=##class(PHA.COM.Order).PatWeight(AdmDr)     //体重
	..S PatH=##class(PHA.COM.Order).PatHeight(AdmDr)     //身高
	..S WRWardDr=$p(^DHCPHWR(wardRoundID),"^",2)    //病区ID
	..S:WRWardDr'="" WRWard=$p(^PAWARD(WRWardDr),"^",2)
	..S WRDept=""
	..S WRDeptDr=$p(^DHCPHWR(wardRoundID),"^",3)    //科室ID
	..S:WRDeptDr'="" WRDept=$p(^CTLOC(WRDeptDr),"^",2)
	..S WRBloodType=$p(^DHCPHWR(wardRoundID),"^",4) //血型
	..S WRICDesc=$p(^DHCPHWR(wardRoundID),"^",5)    //诊断
	..S WRCurStatus=$p(^DHCPHWR(wardRoundID),"^",6) //当前状态
	..q:WRCurStatus'=curStatus  ;过滤掉不是“In”住院期间患者的记录信息
	..S WRGuidance=$p(^DHCPHWR(wardRoundID),"^",7)  //指导意见
	..S WRUser=""
	..S WRUserDr=$p(^DHCPHWR(wardRoundID),"^",8)    //记录人
	..S:WRUserDr'="" WRUser=$p(^SSU("SSUSR",WRUserDr),"^",2)
	..S WRDate=$p(^DHCPHWR(wardRoundID),"^",9)      //记录日期
	..S:WRDate'="" WRDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(WRDate)  ;$zd(WRDate,3)
	..S WRTime=$p(^DHCPHWR(wardRoundID),"^",10)     //记录日期
	..S:WRTime'="" WRTime=$zt(WRTime,2)
	..S WRDrugInstruction=$p(^DHCPHWR(wardRoundID),"^",12) //药品注意事项
	..s PatName=##class(PHA.FACE.IN.Com).GetTransDesc("User.PAPatMas","PAPMIName","",PatName)
    ..s PatSex=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTSex","CTSEXDesc","",PatSex)
    ..s WRWard=##class(PHA.FACE.IN.Com).GetTransDesc("User.PACWard","WARDDesc","",WRWard)
    ..s WRDept=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTLoc","CTLOCDesc","",WRDept)
    ..s WRICDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHWardRound","PHWRICDesc","",WRICDesc)   
	..s WRGuidance=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHWardRound","PHWRGuidance","",WRGuidance)
	..s WRUser=##class(PHA.FACE.IN.Com).GetTransDesc("User.SSUser","SSUSRName","",WRUser)
	
	..s h=h+1
	..S data=AdmDr_"^"_PatNo_"^"_PatName_"^"_AdmBed_"^"_PatSex_"^"_PatAge_"^"_PatW_"^"_PatH_"^"_mobPhone
	..S data=data_"^"_WRWard_"^"_WRDept_"^"_WRBloodType_"^"_WRICDesc_"^"_WRCurStatus_"^"_WRGuidance_"^"_WRUser_"^"_WRDate_"^"_WRTime_"^"_wardRoundID_"^"_WRDrugInstruction
	..s ^TMP("DHCST","DHCSTPHCMWARDROUND","getPatWardRecord",pid,h)=data
	
	    
	q:h=0 ##class(web.DHCSTJQUERYCOMMON).GetNoJson()
	s maxrow=h
    i endpage>maxrow s endpage=maxrow
	
	s count=0
	s h=""
	f  s h=$o(^TMP("DHCST","DHCSTPHCMWARDROUND","getPatWardRecord",pid,h)) q:h=""  d
	.s data=^TMP("DHCST","DHCSTPHCMWARDROUND","getPatWardRecord",pid,h)
	.s AdmDr=$p(data,"^",1)
	.s PatNo=$p(data,"^",2)
	.s PatName=$p(data,"^",3)
	.s AdmBed=$p(data,"^",4)
	.s PatSex=$p(data,"^",5)
	.s PatAge=$p(data,"^",6)
	.s PatW=$p(data,"^",7)
	.s PatH=$p(data,"^",8)
	.s mobPhone=$p(data,"^",9)
	.s WRWard=$p(data,"^",10)
	.s WRDept=$p(data,"^",11)
	.s WRBloodType=$p(data,"^",12)
	.s WRICDesc=$p(data,"^",13)
	.s WRCurStatus=$p(data,"^",14)
	.s WRGuidance=$p(data,"^",15)
	.s WRUser=$p(data,"^",16)
	.s WRDate=$p(data,"^",17)
	.s WRTime=$p(data,"^",18)
	.s wardRoundID=$p(data,"^",19)
	.s WRDrugInstruction=$p(data,"^",20)
	.s count=count+1
    .q:count<stpage
    .q:count>endpage
	.s AdmDr=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("AdmDr",AdmDr)
	.s PatNo=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatNo",PatNo) 
	.s PatName=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatName",PatName)
	.s AdmBed=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("AdmBed",AdmBed)
	.s PatSex=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatSex",PatSex)
	.s PatAge=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatAge",PatAge)
	.s PatW=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatW",PatW)
	.s PatH=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("PatH",PatH)
	.s mobPhone=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("mobPhone",mobPhone)
	.s WRWard=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WRWard",WRWard)
	.s WRDept=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WRDept",WRDept)
	.s WRBloodType=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WRBloodType",WRBloodType)
	.s WRICDesc=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WRICDesc",WRICDesc)
	.s WRCurStatus=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WRCurStatus",WRCurStatus)
	.s WRGuidance=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WRGuidance",WRGuidance)
	.s WRUser=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WRUser",WRUser)
	.s WRDate=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WRDate",WRDate)
	.s WRTime=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WRTime",WRTime)
	.s WRDrugInstruction=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstCell("WRDrugInstruction",WRDrugInstruction)
	.s wardRoundID=##class(web.DHCSTJQUERYCOMMON).GetJsonLastCell("wardRoundID",wardRoundID)
	.
	.s tmpstr=AdmDr_PatNo_PatName_AdmBed_PatSex_PatAge_PatW_PatH_mobPhone_WRWard_WRDept_WRBloodType_WRICDesc_WRCurStatus_WRGuidance_WRUser_WRDate_WRTime_WRDrugInstruction_wardRoundID
	.s startString=##class(web.DHCSTJQUERYCOMMON).GetJsonStartString(maxrow)
	.s firstrow=##class(web.DHCSTJQUERYCOMMON).GetJsonFirstRow(tmpstr)
	.s lastrow=##class(web.DHCSTJQUERYCOMMON).GetJsonLastRow(tmpstr)
	.i count=stpage w startString
    .i count<endpage w firstrow
    .i count=endpage w lastrow
	.
	k ^TMP("DHCST","DHCSTPHCMWARDROUND","getPatWardRecord",pid)
	q ""
}

/// Descript:临床查房指导意见表
/// w ##class(web.DHCSTPHCMWARDROUND).getWRGuidance("67")
ClassMethod getWRGuidance(wardRoundID As %String) As %String
{
	N (wardRoundID,curStatus,%session)
	
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"G",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"G",CH))
	.s id=$p(mdata,"^",1)
	.Q:id<0
	.s desc=$p(mdata,"^",2)
	.s desc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHWRGuidance","PHWRGDesc","",desc)
	.i ret="" S ret=id
	.E  S ret=ret_"^"_id
	Q ret
}

/// Descript:现病史
ClassMethod getWRHisPreCom(wardRoundID As %String) As %String
{
	N (wardRoundID,curStatus,%session)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"HPC",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"HPC",CH))
	.s mdata=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHWRHisPreCom","PHHPCDesc","",mdata)
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:既往病史
ClassMethod getWRPasDisHis(wardRoundID As %String) As %String
{
	N (wardRoundID,%session)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"PDH",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"PDH",CH))
	.s mdata=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHWRPasDisHis","PHPDHDesc","",mdata)
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:既往用药史
ClassMethod getWRPasMedHis(wardRoundID As %String) As %String
{
	N (wardRoundID,%session)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"PMH",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"PMH",CH))
	.s mdata=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHWRPasMedHis","PHPMHDesc","",mdata)
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:个人史及家族史
ClassMethod getWRPerFamHis(wardRoundID As %String) As %String
{
	N (wardRoundID,%session)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"PFH",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"PFH",CH))
	.s mdata=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHWRPerAndFamHis","PHPFHDesc","",mdata)
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:伴发疾病与用药情况
ClassMethod getWRConDisTre(wardRoundID As %String) As %String
{
	N (wardRoundID,%session)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"CDT",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"CDT",CH))
	.s mdata=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHWRConDisAndTre","PHCDTDesc","",mdata)
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:过敏史
ClassMethod getWRAlleicHis(wardRoundID As %String) As %String
{
	N (wardRoundID,%session)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"AH",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"AH",CH))
	.s mdata=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHWRAllergicHis","PHAHDesc","",mdata)
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:关注药品
/// w ##class(web.DHCSTPHCMWARDROUND).getWRDrgItm("86")
ClassMethod getWRDrgItm(wardRoundID As %String, StPage = "1", EndPage = "999") As %String
{
	N (wardRoundID,StPage,EndPage,%session)

	S pid=..NewPid()
	d ..killTmpGlobal(pid)
	s Num=0
	S CH="",ret=""  
	F  S CH=$o(^DHCPHWR(wardRoundID,"DI",CH)) Q:CH=""  D
	.S orditm=$p(^DHCPHWR(wardRoundID,"DI",CH),"^",1)		/// 医嘱ID
	.S ord=+orditm
	.S chl=$p(orditm,"||",2)
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)     		/// 医嘱 ARC_ItmMast ARCIM_RowId
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
    .S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
    .Q:(ordertype'="R")
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""  										 	/// 医嘱名称
	.;S inciDesc=$p(^INCI(inci,1),"^",2) 					/// 药品名称
	.S inciDesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2) //lbb 2019/1/4 取医嘱项名称，因为医嘱项和库存项存在一对多关系
    .s moeoriflag=##class(web.DHCSTPHCMCOMMON).GetMainOeoriNew(orditm)
	.i moeoriflag'="" d
	..s inciDesc="______"_inciDesc
	.;S dosage=$p($g(^OEORD(ord,"I",chl,2)),"^",1) 	/// 剂量
	.s dosage=##class(PHA.FACE.IN.Com).GetOrdDoseQty(orditm)  //lbb  2019/7/3 同频次不同剂量,剂量串
	.S dosuomID=+$p($g(^OEORD(ord,"I",chl,2)),"^",3)
	.S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)    		/// 剂量单位
	.;S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4)  		/// OEORI_PHFreq_DR
    .;S freq=$p($g(^PHCFR(freqdr)),"^",3)           			/// 频率
	.s freqInfo=##class(PHA.COM.Order).OeoriFreq(orditm)   //取频次调用统一接口
	.s freqdr=$p(freqInfo,"^",1)  
    .s freq=$p(freqInfo,"^",2) 
    .S instrudr=+$p($g(^OEORD(ord,"I",chl,2)),"^",7)
    .S instru=$p($g(^PHCIN(instrudr)),"^",2)        		/// 用法
	.s duration=""
    .s durId=$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.s:durId'="" duration=$p($g(^PHCDU(durId)),"^",1)  /// 用药疗程
	.S phcdf=$p($g(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1)),"^",12) q:phcdf=""
    .s genenicdr=$p($g(^PHCD(+phcdf,4)),"^",1)
    .s genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) 		/// 通用名
    .s formdr=$p($g(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1)),"^",1)
    .s form=$p($g(^PHCF(formdr)),"^",2) 						/// 剂型
    .s execStat=##class(web.DHCSTPHCMCOMMON).CheckIfExec(ord,chl)	/// 是否执行 qunianpeng 2018/3/12
	.s execStat=$case(execStat,"Y":"已执行","N":"未执行",:"") 
	.s sendStat=##class(web.DHCSTPHCMCOMMON).CheckIfSend(ord,chl) 	/// 是否发药 qunianpeng 2018/3/12
	.s sendStat=$case(sendStat,"Y":"已发药","N":"未发药",:"") 
    .s manf=""
    .s manfdr=$p($g(^PHCD(+phcdf,2)),"^",4)         				/// 厂家
    .s:manfdr'="" manf=$p($g(^PHMNF(manfdr)),"^",2)
	.S doctor=##class(web.DHCSTCOMMONSRV).getOrdDoctor(orditm) 		/// 医生
	.S StartDate=+$p($g(^OEORD(ord,"I",chl,1)),"^",9)   				/// 开始日期
	.S:StartDate'="" StartDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(StartDate)  ;$zd(StartDate,3)
	.S Num=Num+1
	.s inciDesc=##class(PHA.FACE.IN.Com).GetTransDesc("User.ARCItmMast","ARCIMDesc","",inciDesc)
	.s freq=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCFreq","PHCFRDesc1","",freq)
	.s instru=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCInstruc","PHCINDesc1","",instru)
	.s duration=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCDuration","PHCDUCode","",duration)
	.s doctor=##class(PHA.FACE.IN.Com).GetTransDesc("User.CTCareProv","CTPCPDesc","",doctor)
	.s genenic=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCGeneric","PHCGEName","",genenic)
	.s form=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHCForm","PHCFDesc","",form)
	.s manf=##class(PHA.FACE.IN.Com).GetTransDesc("User.PHManufacturer","PHMNFName","",manf)
	.s execStat=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(execStat)
	.s sendStat=##class(PHA.CPW.Com.OutInterfance).GetTransDesc(sendStat)
	.S ^TMP("DHCST","web.DHCSTPHCMWARDROUND","getWRDrgItm",pid,Num)=orditm_"^"_StartDate_"^"_inciDesc_"^"_dosage_doseuom_"^"_freq_"^"_instru_"^"_duration_"^"_doctor_"^"_genenic_"^"_form_"^"_manf_"^"_execStat_"^"_sendStat

	i 4>Num d
	.S Len=4-Num
	.f i=1:1:Len d
	..S Num=Num+1
	..S ^TMP("DHCST","web.DHCSTPHCMWARDROUND","getWRDrgItm",pid,Num)=""

	Q:Num=0 ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0) //输出空的json串
	
	//S Title="orditm^StartDate^incidesc^Dosage^freq^Instance^duration^Doctor^genenic^form^manf"
	S Title="orditm^StartDate^incidesc^dosage^freq^instru^duration^Doctor^genenic^form^manf^execStat^sendStat" //替换剂量和疗程字段 qunianpeng 2018/3/12
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	w ##class(web.DHCSTPHCMCOMMON).getJsonStartSign(Num) //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMWARDROUND","getWRDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMWARDROUND","getWRDrgItm",pid,index)
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

/// Descript:药师指导列表
/// w ##class(web.DHCSTPHCMWARDROUND).getGuidList("20")
ClassMethod getGuidList(wardRoundID As %String) As %String
{
	
	S wrGuidanceList=..getWRGuidance(wardRoundID)
	q wrGuidanceList
}

/// Descript:首次病程记录
/// w ##class(web.DHCSTPHCMWARDROUND).getPatFirProNote("16617332")
ClassMethod getPatFirProNote(AdmDr As %String) As %String
{
	n (AdmDr)
	///现病史
	s patHPCDesc=##class(web.DHCSTPHCMCOMMON).getPatHPC(AdmDr)
	///既往病史
	s patPMHisDesc=##class(web.DHCSTPHCMCOMMON).getPatPMHis(AdmDr)
	///既往用药史
	s patPMDrgHisDesc=##class(web.DHCSTPHCMCOMMON).getPatPMDrgHis(AdmDr)
	///个人史及家族史
	s patPerHisDesc=##class(web.DHCSTPHCMCOMMON).getPatPerHis(AdmDr)
	///过敏史
	s patAllHisDesc=##class(web.DHCSTPHCMCOMMON).getPatAllHis(AdmDr)
	///入院诊断
	s patInHosDiagDesc=##class(web.DHCSTPHCMCOMMON).getPatInHosDiag(AdmDr)

	s jsonDataList="PreDisHis^"_patHPCDesc_$c(2)_"PasDisHis^"_patPMHisDesc_$c(2)_"PasMedHis^"_patPMDrgHisDesc_$c(2)_"PerAndFamHis^"_patPerHisDesc
	s jsonDataList=jsonDataList_$c(2)_"AllergicHis^"_patAllHisDesc_$c(2)_"InHosdiag^"_patInHosDiagDesc
	s jsonDataList=$tr(jsonDataList,":","")
	q jsonDataList
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMWARDROUND","getWRDrgItm",pid)
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	Q $I(^DHCST("PHCMWARDROUND"))
}

/// Descript:临床查房指导意见其它
/// w ##class(web.DHCSTPHCMWARDROUND).getWRGuidanceDesc("66")
ClassMethod getWRGuidanceDesc(wardRoundID As %String) As %String
{
	N (wardRoundID,curStatus,%session)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"G",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"G",CH))
	.s id=$p(mdata,"^",1)
	.q:id'=-100
	.s desc=$p(mdata,"^",2)
	.s desc=##class(PHA.FACE.IN.Com).GetTransDesc("User.DHCPHWRGuidance","PHWRGDesc","",desc)
	.i ret="" S ret=desc
	.E  S ret=ret_"^"_desc
	Q ret
}

/// Descript:获取查房数据
/// Creater:lbb
/// CreateDate:2018-11-5
/// Table:DHC_PHWardRound
/// Input:药学查房记录ID
/// Output:病人基本信息，药品信息，指导内容
/// w ##class(web.DHCSTPHCMWARDROUND).ExportgetWardRound(8)
ClassMethod ExportgetWardRound(wardRoundID As %String) As %String
{
	N (wardRoundID)
	S AdmDr=$p(^DHCPHWR(wardRoundID),"^",1)     //病人Adm
	S PatientID=$p(^PAADM(AdmDr),"^",1)
	S workunit=$p($g(^PAPER(PatientID,"PER",4)),"^",18) /// 工作单
	S nationdr=$p(^PAPER(PatientID,"PER",2),"^",1)  /// 民族   
	S nation=""
	I nationdr'="" S nation=$p(^CT("NAT",nationdr),"^",2)
	S mobPhone=$p(^PAPER(PatientID,"PER",1),"^",11) 	    /// 电话 
	S AdmWard=""
	S AdmWardDr=$p(^PAADM(AdmDr),"^",70)
	I AdmWardDr'="" s AdmWard=$p(^PAWARD(AdmWardDr),"^",2) //病区
	S bedid=$p(^PAADM(AdmDr),"^",73)             //床号
	I bedid="" S AdmBed=""
	E  S AdmBed=$p(^PAWARD($p(bedid,"||",1),"BED",$p(bedid,"||",2)),"^",1)
	S Papmi=$p(^PAADM(AdmDr),"^",1)
	S PatName=$p(^PAPER(Papmi,"ALL"),"^",1)      //姓名
	S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",1)      //登记号
	S SexID=$p(^PAPER(Papmi,"ALL"),"^",7 )       //姓别
	S PatSex=$p(^CT("SEX",SexID),"^",2)
	S PatAge=##class(PHA.FACE.IN.Com).GetAge(Papmi,AdmDr)  //年龄
	S PatW=##class(PHA.COM.Order).PatWeight(AdmDr)       //体重
	S PatH=##class(PHA.COM.Order).PatHeight(AdmDr)       //身高	
	S WRWard=""
	S WRWardDr=$p(^DHCPHWR(wardRoundID),"^",2)    //病区ID
	S:WRWardDr'="" WRWard=$p(^PAWARD(WRWardDr),"^",2)
	S WRDept=""
	S WRDeptDr=$p(^DHCPHWR(wardRoundID),"^",3)    //科室ID
	S:WRDeptDr'="" WRDept=$p(^CTLOC(WRDeptDr),"^",2)
	S WRBloodType=$p(^DHCPHWR(wardRoundID),"^",4) //血型
	S WRICDesc=$p(^DHCPHWR(wardRoundID),"^",5)    //诊断
	S WRCurStatus=$p(^DHCPHWR(wardRoundID),"^",6) //当前状态
	S WRGuidance=$p(^DHCPHWR(wardRoundID),"^",7)  //指导意见
	S WRUser=""
	S WRUserDr=$p(^DHCPHWR(wardRoundID),"^",8)    //记录人
	S:WRUserDr'="" WRUser=$p(^SSU("SSUSR",WRUserDr),"^",2)
	S WRDate=$p(^DHCPHWR(wardRoundID),"^",9)      //记录日期
	S:WRDate'="" WRDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(WRDate) ;$zd(WRDate,3)
	S WRTime=$p(^DHCPHWR(wardRoundID),"^",10)     //记录日期
	S:WRTime'="" WRTime=$zt(WRTime,2)
	S WRDrugInstruction=$p(^DHCPHWR(wardRoundID),"^",12) //用药注意事项
	
	S wrMasDataList=PatNo_"^"_PatName_"^"_AdmBed_"^"_PatSex_"^"_PatAge_"^"_PatW_"^"_PatH_"^"_mobPhone_"^"_nation_"^"_workunit
	S wrMasDataList=wrMasDataList_"^"_WRWard_"^"_WRDept_"^"_WRBloodType_"^"_WRICDesc_"^"_WRCurStatus_"^"_WRGuidance_"^"_WRUser_"^"_WRDate_"^"_WRTime_"^"_WRDrugInstruction
	
	S wrGuidanceList=..getWRGuidance(wardRoundID)      //临床查房指导意见表
	S wrGuidanceOther=""
	i wrGuidanceList[-100 s wrGuidanceOther=..getWRGuidanceDesc(wardRoundID)
	S wrHisPreComList=..getWRHisPreCom(wardRoundID)    //现病史
	S wrPasDisHisList=..getWRPasDisHis(wardRoundID)    //既往病史
	S wrPasMedHisList=..getWRPasMedHis(wardRoundID)    //既往用药史
	S wrPerFamHisList=..getWRPerFamHis(wardRoundID)    //个人史及家族史
	S wrConDisTreList=..getWRConDisTre(wardRoundID)    //伴发疾病与用药情况
	S wrAllergHisList=..getWRAlleicHis(wardRoundID)    //过敏史
	S CH="",ret="" ,dDateList="" 
	F  S CH=$o(^DHCPHWR(wardRoundID,"DI",CH)) Q:CH=""  D
	.S orditm=$p(^DHCPHWR(wardRoundID,"DI",CH),"^",1) /// 医嘱ID
	.S ord=+orditm
	.S chl=$p(orditm,"||",2)
	.S ArcItmId=$p(^OEORD(ord,"I",chl,1),"^",2)      /// 医嘱 ARC_ItmMast ARCIM_RowId
	.S ItemCatDR=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
	.S ordertype=$P(^ARC("IC",ItemCatDR),"^",7)
	.Q:(ordertype'="R")
	.S inci=$o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.Q:inci=""  			                /// 医嘱名称
	.S inciDesc=$p(^INCI(inci,1),"^",2) 		/// 药品名称
	.S dosage=$p(^OEORD(ord,"I",chl,2),"^",1) 	/// 剂量
	.S dosuomID=+$p(^OEORD(ord,"I",chl,2),"^",3)
	.S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)    /// 剂量单位
	.;S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4)  /// OEORI_PHFreq_DR
	.;S freq=$p($g(^PHCFR(freqdr)),"^",3)           	/// 频率
	.s freqInfo=##class(PHA.COM.Order).OeoriFreq(orditm)   //取频次调用统一接口
	.s freqdr=$p(freqInfo,"^",1)  
    .s freq=$p(freqInfo,"^",2) 
	.S instrudr=+$p(^OEORD(ord,"I",chl,2),"^",7)
	.S instru=$p($g(^PHCIN(instrudr)),"^",2)            /// 用法
	.s duration=""
    .s durId=$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.s:durId'="" duration=$p($g(^PHCDU(durId)),"^",1)  /// 用药疗程
	.S phcdf=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12) q:phcdf=""
	.S genenicdr=$p($g(^PHCD(+phcdf,4)),"^",1)
	.S genenic=$p($g(^PHCGE("GE",genenicdr)),"^",2) 	/// 通用名
	.S formdr=$p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1),"^",1)
	.S form=$p(^PHCF(formdr),"^",2) 			/// 剂型
	.I dDateList="" S dDateList=inciDesc_"^"_dosage_doseuom_"^"_freq_"^"_instru_"^"_duration_"^"_genenic_"^"_form
	.E  S dDateList=dDateList_"||"_inciDesc_"^"_dosage_doseuom_"^"_freq_"^"_instru_"^"_duration_"^"_genenic_"^"_form
	S ret=wrMasDataList_"!"_wrGuidanceList_"!"_wrHisPreComList_"!"_wrPasDisHisList
	S ret=ret_"!"_wrPasMedHisList_"!"_wrPerFamHisList_"!"_wrConDisTreList_"!"_wrAllergHisList_"!"_wardRoundID_"!"_wrGuidanceOther
	s retdesc="",CH=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"G",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"G",CH))
	.s id=$p(mdata,"^",1)
	.s desc=$p($g(^DHCPHGS(id)),"^",2) //指导内容
	.i retdesc="" S retdesc=desc
	.E  S retdesc=retdesc_";"_desc
	Q ret_"&&"_dDateList_"&&"_retdesc
}

/// Creator: Huxiaotian 2019-12-15
/// Desc: 药学查房获取打印数据
/// Table: DHC_PHWardRound
/// Input: 药学查房记录ID
/// Output: 病人基本信息，药品信息，指导内容
/// w ##class(web.DHCSTPHCMWARDROUND).GetWardRoundPrint(3)
ClassMethod GetWardRoundPrint(wardRoundID As %String) As %String
{
	n (wardRoundID)
	//患者信息
	s adm = $p(^DHCPHWR(wardRoundID),"^",1)     			//病人adm
	s PatientID = $p(^PAADM(adm),"^",1)
	s workunit = $p($g(^PAPER(PatientID,"PER",4)),"^",18) 	//工作单
	s nationdr = $p(^PAPER(PatientID,"PER",2),"^",1)  		//民族   
	s nation=""
	s:nationdr'="" nation = $p(^CT("NAT",nationdr),"^",2)
	s mobPhone = $p(^PAPER(PatientID,"PER",1),"^",11) 	    //电话 
	s admWard = ""
	s admWardDr=$p(^PAADM(adm),"^",70)
	s:admWardDr'="" admWard=$p(^PAWARD(admWardDr),"^",2) 	//病区
	s patBed = ""
	s bedID = $p(^PAADM(adm),"^",73)             			//床号
	s:bedID="" patBed = $p(^PAWARD($p(bedID,"||",1),"BED",$p(bedID,"||",2)),"^",1)
	s papmi = $p(^PAADM(adm),"^",1)
	s patName = $p(^PAPER(papmi,"ALL"),"^",1)      			//姓名
	s patNo = $p(^PAPER(papmi,"PAT",1),"^",1)      			//登记号
	s sexID = $p(^PAPER(papmi,"ALL"),"^",7 )
	s patSex = $p(^CT("SEX",sexID),"^",2)					//姓别
	s patAge = ##class(PHA.FACE.IN.Com).GetAge(papmi,adm)  		//年龄
	s patW = ##class(PHA.COM.Order).PatWeight(adm)	//体重
	s patH = ##class(PHA.COM.Order).PatHeight(adm)	//身高	
	//查房记录
	s WRWard=""
	s WRWardDr = $p(^DHCPHWR(wardRoundID),"^",2)    		//病区ID
	s:WRWardDr'="" WRWard = $p(^PAWARD(WRWardDr),"^",2)
	s WRDept=""
	s WRDeptDr = $p(^DHCPHWR(wardRoundID),"^",3)    		//科室ID
	s:WRDeptDr'="" WRDept = $p(^CTLOC(WRDeptDr),"^",2)
	s WRBloodType = $p(^DHCPHWR(wardRoundID),"^",4) 		//血型
	s WRICDesc = $p(^DHCPHWR(wardRoundID),"^",5)    		//诊断
	s WRCurStatus = $p(^DHCPHWR(wardRoundID),"^",6) 		//当前状态
	s WRGuidance = $p(^DHCPHWR(wardRoundID),"^",7)  		//初始治疗方案 OR 查房记录 -- ???
	s WRUser=""
	s WRUserDr = $p(^DHCPHWR(wardRoundID),"^",8)    		//记录人
	s:WRUserDr'="" WRUser = $p(^SSU("SSUSR",WRUserDr),"^",2)
	s WRDate = $p(^DHCPHWR(wardRoundID),"^",9)      		//记录日期
	s:WRDate'="" WRDate = ##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(WRDate)
	s WRTime = $p(^DHCPHWR(wardRoundID),"^",10)    	 		//记录时间
	s:WRTime'="" WRTime = $zt(WRTime,2)
	s WRDrugInstruction = $p(^DHCPHWR(wardRoundID),"^",12) 	//用药注意事项
	s wrGuidanceList = ..getWRGuidance(wardRoundID)      	//临床查房指导意见表
	s wrGuidanceOther=""
	i wrGuidanceList[-100 s wrGuidanceOther=..getWRGuidanceDesc(wardRoundID)
	s wrHisPreComList = ..getWRHisPreCom(wardRoundID)    	//现病史
	s wrPasDisHisList = ..getWRPasDisHis(wardRoundID)    	//既往病史
	s wrPasMedHisList = ..getWRPasMedHis(wardRoundID)    	//既往用药史
	s wrPerFamHisList = ..getWRPerFamHis(wardRoundID)    	//个人史及家族史
	s wrConDisTreList = ..getWRConDisTre(wardRoundID)    	//伴发疾病与用药情况
	s wrAllergHisList = ..getWRAlleicHis(wardRoundID)    	//过敏史
	s wrGuideContent = ..getGuideContent(wardRoundID)		//指导意见 OR 指导内容 -- ???
	//超长字符串处理
	s WRICDesc = ##class(PHA.COM.Print).SplitStr(WRICDesc,64,4)
	s WRGuidance = ##class(PHA.COM.Print).SplitStr(WRGuidance,80,4)
	s WRDrugInstruction = ##class(PHA.COM.Print).SplitStr(WRDrugInstruction,64,4)
	s wrGuidanceList = ##class(PHA.COM.Print).SplitStr(wrGuidanceList,64,4)
	s wrHisPreComList = ##class(PHA.COM.Print).SplitStr(wrHisPreComList,64,4)
	s wrPasDisHisList = ##class(PHA.COM.Print).SplitStr(wrPasDisHisList,64,4)
	s wrPasMedHisList = ##class(PHA.COM.Print).SplitStr(wrPasMedHisList,64,4)
	s wrPerFamHisList = ##class(PHA.COM.Print).SplitStr(wrPerFamHisList,64,4)
	s wrConDisTreList = ##class(PHA.COM.Print).SplitStr(wrConDisTreList,64,4)
	s wrAllergHisList = ##class(PHA.COM.Print).SplitStr(wrAllergHisList,64,4)
	s wrGuideContent = ##class(PHA.COM.Print).SplitStr(wrGuideContent,80,4)
	//josn
	s retJson = {}
	s Para = {}
	s Para.patName = patName
	s Para.patAge = patAge
	s Para.patSex = patSex
	s Para.patNo = patNo
	s Para.nation = nation
	s Para.patHeight = patH
	s Para.patWeight = patW
	s Para.bloodType = WRBloodType
	s Para.patTel = mobPhone
	s Para.workPlace = workunit
	s Para.admWard = admWard
	s Para.patBed = patBed
	s Para.WRWard = WRWard
	s Para.WRDept = WRDept
	s Para.WRUser = WRUser
	s Para.WRDate = WRDate
	s Para.WRTime = WRTime
	s Para.ICDesc1 = $p(WRICDesc,"^",1)						//诊断
	s Para.ICDesc2 = $p(WRICDesc,"^",2)
	s Para.ICDesc3 = $p(WRICDesc,"^",3)
	s Para.ICDesc4 = $p(WRICDesc,"^",4)
	s Para.guideContent1 = $p(wrGuideContent,"^",1)			//指导意见 OR 指导内容 -- ???
	s Para.guideContent2 = $p(wrGuideContent,"^",2)
	s Para.guideContent3 = $p(wrGuideContent,"^",3)
	s Para.guideContent4 = $p(wrGuideContent,"^",4)
	s Para.Guidance1 = $p(WRGuidance,"^",1)					//初始治疗方案 OR 查房记录 -- ???
	s Para.Guidance2 = $p(WRGuidance,"^",2)
	s Para.Guidance3 = $p(WRGuidance,"^",3)
	s Para.Guidance4 = $p(WRGuidance,"^",4)
	s Para.drugInstruction1 = $p(WRDrugInstruction,"^",1)	//用药注意事项
	s Para.drugInstruction2 = $p(WRDrugInstruction,"^",2)
	s Para.drugInstruction3 = $p(WRDrugInstruction,"^",3)
	s Para.drugInstruction4 = $p(WRDrugInstruction,"^",4)
	s Para.guidanceList1 = $p(wrGuidanceList,"^",1)			//临床查房指导意见表
	s Para.guidanceList1 = $p(wrGuidanceList,"^",2)
	s Para.guidanceList1 = $p(wrGuidanceList,"^",3)
	s Para.guidanceList1 = $p(wrGuidanceList,"^",4)
	s Para.hisPreComList1 = $p(wrHisPreComList,"^",1)		//现病史
	s Para.hisPreComList2 = $p(wrHisPreComList,"^",2)
	s Para.hisPreComList3 = $p(wrHisPreComList,"^",3)
	s Para.hisPreComList4 = $p(wrHisPreComList,"^",4)
	s Para.pasDisHisList1 = $p(wrPasDisHisList,"^",1)		//既往病史
	s Para.pasDisHisList2 = $p(wrPasDisHisList,"^",2)
	s Para.pasDisHisList3 = $p(wrPasDisHisList,"^",3)
	s Para.pasDisHisList4 = $p(wrPasDisHisList,"^",4)
	s Para.pasMedHisList1 = $p(wrPasMedHisList,"^",1) 		//既往用药史
	s Para.pasMedHisList2 = $p(wrPasMedHisList,"^",2)
	s Para.pasMedHisList3 = $p(wrPasMedHisList,"^",3)
	s Para.pasMedHisList4 = $p(wrPasMedHisList,"^",4)
	s Para.perFamHisList1 = $p(wrPerFamHisList,"^",1)		//个人史及家族史
	s Para.perFamHisList2 = $p(wrPerFamHisList,"^",2)
	s Para.perFamHisList3 = $p(wrPerFamHisList,"^",3)
	s Para.perFamHisList4 = $p(wrPerFamHisList,"^",4)
	s Para.conDisTreList1 = $p(wrConDisTreList,"^",1)		//伴发疾病与用药情况
	s Para.conDisTreList2 = $p(wrConDisTreList,"^",2)
	s Para.conDisTreList3 = $p(wrConDisTreList,"^",3)
	s Para.conDisTreList4 = $p(wrConDisTreList,"^",4)
	s Para.allergHisList1 = $p(wrAllergHisList,"^",1)		//过敏史
	s Para.allergHisList2 = $p(wrAllergHisList,"^",2)
	s Para.allergHisList3 = $p(wrAllergHisList,"^",3)
	s Para.allergHisList4 = $p(wrAllergHisList,"^",4)
	//药品信息
	s List = []
	s chlid = ""
	f  s chlid = $o(^DHCPHWR(wardRoundID,"DI",chlid)) q:chlid=""  d
	.s orditm = $p(^DHCPHWR(wardRoundID,"DI",chlid),"^",1)
	.s ord = +orditm
	.s chl = $p(orditm,"||",2)
	.s ArcItmId = $p(^OEORD(ord,"I",chl,1),"^",2)
	.s ItemCatDR = $p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",10)
	.S ordertype = $P(^ARC("IC",ItemCatDR),"^",7)
    .q:ordertype'="R"
	.s inci = $o(^INCI(0,"ARCIM_DR",$p(ArcItmId,"||",1),"")) 
	.q:inci=""
	.;s inciDesc = $p(^INCI(inci,1),"^",2)				//药品名称
	.s moeoriflag=##class(web.DHCSTPHCMCOMMON).GetMainOeoriNew(orditm)
    .S inciDesc=$p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",2) //lbb 2019/1/4 取医嘱项名称，因为医嘱项和库存项存在一对多关系 
    .i moeoriflag'="" d
    ..s inciDesc="______"_inciDesc
	.s dosage = $p(^OEORD(ord,"I",chl,2),"^",1)			//剂量
	.s dosuomID = +$p(^OEORD(ord,"I",chl,2),"^",3)
	.s doseuom = $p($g(^CT("UOM",dosuomID)),"^",2)		//剂量单位
	.;s freqdr = +$p($g(^OEORD(ord,"I",chl,2)),"^",4)
	.;s freq = $p($g(^PHCFR(freqdr)),"^",3)				//频率
	.s freqInfo=##class(PHA.COM.Order).OeoriFreq(orditm)   //取频次调用统一接口
	.s freqdr=$p(freqInfo,"^",1)  
    .s freq=$p(freqInfo,"^",2) 
	.s instrudr = +$p(^OEORD(ord,"I",chl,2),"^",7)
	.s instru = $p($g(^PHCIN(instrudr)),"^",2)			//用法
	.s duration=""
    .s durId=$p($g(^OEORD(ord,"I",chl,2)),"^",6)
	.s:durId'="" duration=$p($g(^PHCDU(durId)),"^",1)  /// 用药疗程
	.s phcdf = $p(^ARCIM($p(ArcItmId,"||",1),$p(ArcItmId,"||",2),1),"^",12)
	.q:phcdf=""
	.s genenicdr = $p($g(^PHCD(+phcdf,4)),"^",1)
	.s genenic = $p($g(^PHCGE("GE",genenicdr)),"^",2) 	//通用名
	.s formdr = $p(^PHCD(+phcdf,"DF",$p(phcdf,"||",2),1),"^",1)
	.s form = $p(^PHCF(formdr),"^",2) 					//剂型
	.//json
	.s onwRow = {}
	.s onwRow.inciDesc = inciDesc
	.s onwRow.dosageUom = dosage_doseuom
	.s onwRow.instru = instru
	.s onwRow.freq = freq
	.s onwRow.duration = duration
	.d List.%Push(onwRow)
	s retJson.Para = Para
	s retJson.List = List
	q retJson.%ToJSON()
}

/// Creator: Huxt 2019-12-15
/// Desc: 获取指导内容
/// w ##class(web.DHCSTPHCMWARDROUND).getGuideContent(3)
ClassMethod getGuideContent(wardRoundID)
{
	s retdesc = ""
	s chl = ""
	f  s chl = $o(^DHCPHWR(wardRoundID,"G",chl)) Q:chl=""  D
	.s mdata = $g(^DHCPHWR(wardRoundID,"G",chl))
	.s id = $p(mdata,"^",1)
	.s desc = $p($g(^DHCPHGS(id)),"^",2) //指导内容
	.q:desc=""
	.i retdesc="" d
	..s retdesc = desc
	.e  d
	..s retdesc = retdesc_";"_desc
	q retdesc
}

/// Creator: psc 2019-12-15
/// Desc: 获取药学查房表id串
/// w ##class(web.DHCSTPHCMWARDROUND).GetPhaWardStr(3)
ClassMethod GetPhaWardStr(admId)
{
	n (admId)
	q:admId="" ""
	s retStr=""
	s curStatus=""
	f  s curStatus=$o(^DHCPHWR(0,"CurStatus",curStatus)) q:curStatus=""  d
	.s phwrId=""
	.f  s phwrId=$o(^DHCPHWR(0,"CurStatus",curStatus,admId,phwrId)) q:phwrId=""  d
	..i retStr="" s retStr=curStatus_"^"_phwrId
	..e  s retStr=retStr_"#"_curStatus_"^"_phwrId
	q retStr
}

}
