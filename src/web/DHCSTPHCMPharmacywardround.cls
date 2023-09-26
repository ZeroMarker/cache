Import SQLUser

/// Creator:    wangxuejian
/// CreateDate: 2017-03-15
/// Descript:   药学查房
Class web.DHCSTPHCMPharmacywardround Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*/// Descript:   获取指导范围的动态条目
/// w ##class(web.DHCSTPHCMPharmacywardround).getGuiScopePatCode("WAR","N","")
ClassMethod getGuiScopePatCode(ModType, SubModType, PatCode)As %GlobalCharacterStream
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
	.S ^TMP("DHCST","web.DHCSTPHCMPharmacywardround","getGuiScopePatCode",pid,Num)=code_"^"_desc	
	S Title="code^desc"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	d OutBinStream.Write("[")  //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPharmacywardround","getGuiScopePatCode",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMPharmacywardround","getGuiScopePatCode",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	d OutBinStream.Write("]")   //输出json结尾符
	D ..killTmpGlobal(pid)
	D OutBinStream.OutputToDevice()
	Q OutBinStream
}*/
/// Descript:保存药学查房信息
/// w ##class(web.DHCSTPHCMPharmacywardround).SavePhaWdRdInfor("195","337||19||36||||||New||头疼，||578||||/photo/Pha_New_195^^^^刚才v乖乖v^^发病了kkk^^319||73")
/// w ##class(web.DHCSTPHCMPharmacywardround).SavePhaWdRdInfor("","14||19||15||||||Leave||hello||2^1||")
/// w ##class(web.DHCSTPHCMPharmacywardround).SavePhaWdRdInfor("142","319||14||10||||||New||新入院患者测试||578||^^现病史测试^既往病史测试^既往用药史测试^个人史及家族史测试^伴发疾病与用药情况测试^过敏史测试^1||2")
ClassMethod SavePhaWdRdInfor(wardRoundID As %String, wrDataList As %String) As %String
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
	i wrPasMedHisList'="" d
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
	Q wardRoundID
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
	i wrPasMedHisList'="" d
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
	Q wardRoundID
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
	S Len=$l(WRWeight)					//取体重字符串中的数字 qunianpeng 2016-09-14
	S WRWeight=$e(WRWeight,1,Len-2)
	S WRSignPath=$p(wrDataList,"||",10)    //签名路径
	S WRDate=+$H                        //记录日期
	S WRTime=$p($H,",",2)               //记录日期
	&SQL(Insert Into DHC_PHWardRound(PHWR_Adm_Dr,PHWR_Ward_Dr,PHWR_Dept_Dr,PHWR_BloodType,PHWR_ICDesc,PHWR_CurStatus,PHWR_Guidance,PHWR_User_Dr,PHWR_Date,PHWR_Time,PHWR_Weight,PHWR_PharSignPath) 
		Values(:WRAdmDr,:WRWardDr,:WRDeptDr,:WRBloodType,:WRICDesc,:WRCurStatus,:WRGuidance,:WRUserDr,:WRDate,:WRTime,:WRWeight,:WRSignPath))
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
	S WRSignPath=$p(wrDataList,"||",10)    //签名路径
	S WRDate=+$H                       //记录日期
	S WRTime=$p($H,",",2)              //记录日期
	
	&SQL(Update DHC_PHWardRound Set PHWR_Adm_Dr=:WRAdmDr,PHWR_Ward_Dr=:WRWardDr,PHWR_Dept_Dr=:WRDeptDr,PHWR_BloodType=:WRBloodType,
		PHWR_ICDesc=:WRICDesc,PHWR_CurStatus=:WRCurStatus,PHWR_Guidance=:WRGuidance,PHWR_User_Dr=:WRUserDr,PHWR_Date=:WRDate,PHWR_Time=:WRTime,PHWR_PharSignPath=:WRSignPath Where PHWR_RowID=:wardRoundID)
	Q SQLCODE
}

/// Descript:保存临床查房指导意见表
ClassMethod InsDHCPHWRGuidance(wardRoundID As %String, wrGuidanceList As %String) As %String
{
	N (wardRoundID,wrGuidanceList)
	S Len=$L(wrGuidanceList,"||")
	S quitflag=0
	F i=1:1:Len q:quitflag'="0"  d
	.S wrGuidance=$p(wrGuidanceList,"||",i)
	.;S ItemCode=$p(wrGuidance,"^",1)     //代码
	.;S ItemDesc=$p(wrGuidance,"^",2)     //指导意见
	.s ItemCode=wrGuidance
	.s ItemDesc=""
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

/// w ##class(web.DHCSTPHCMPharmacywardround).InsDHCPHWRPasMedHis("195","刚才v乖乖v")
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
/// w ##class(web.DHCSTPHCMPharmacywardround).DelWardRoundRelaTable("11")
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

/// date: 2017-05-09
/// Descript:获取药学查房信息(出院患者和新入院患者)
/// w ##class(web.DHCSTPHCMPharmacywardround).GetPhaWardRound("337","New")
ClassMethod GetPhaWardRound(AdmDr As %String, curStatus As %String) As %GlobalCharacterStream
{
	N (AdmDr,curStatus)
	i curStatus="New"  s curStatus="N"
	e  i curStatus="Out"  s curStatus="O"
	S wardRoundID=$o(^DHCPHWR(0,"CurStatus",curStatus,AdmDr,""),-1)
	Q:wardRoundID="" ""  ;没有记录，返回-999
    s Num=0    
    s OutBinStream=##Class(%GlobalCharacterStream).%New()  
	;S AdmDr=$p($o(^DHCPHWR(wardRoundID)),"^",1) //病人Adm
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
	S WRWard=""
	S WRWardDr=$p(^DHCPHWR(wardRoundID),"^",2)    //病区ID
	S:WRWardDr'="" WRWard=$p(^PAWARD(WRWardDr),"^",2)
	S WRDept=""
	S WRDeptDr=$p(^DHCPHWR(wardRoundID),"^",3)    //科室ID
	S:WRDeptDr'="" WRDept=$p(^CTLOC(WRDeptDr),"^",2)
	S WRBloodType=$p(^DHCPHWR(wardRoundID),"^",4) //血型
	S WRICDesc=$p(^DHCPHWR(wardRoundID),"^",5)    //入院诊断
	;S WRICDesc=..GetMRDiagnosByEpisodeID(AdmDr) //入院诊断
	S WRCurStatus=$p(^DHCPHWR(wardRoundID),"^",6) //当前状态
	S WRGuidance=$p(^DHCPHWR(wardRoundID),"^",7)  //治疗方案
	S WRUser=""
	S WRUserDr=$p(^DHCPHWR(wardRoundID),"^",8)    //记录人
	S:WRUserDr'="" WRUser=$p(^SSU("SSUSR",WRUserDr),"^",2)
	S WRDate=$p(^DHCPHWR(wardRoundID),"^",9)      //记录日期
	S:WRDate'="" WRDate=$zd(WRDate,3) 
	S WRTime=$p(^DHCPHWR(wardRoundID),"^",10)     //记录日期
	S:WRTime'="" WRTime=$zt(WRTime,2)
	S WRSignPath=$p(^DHCPHWR(wardRoundID),"^",12)     //签名路径
	S wrMasDataList=PatNo_"#"_PatName_"#"_AdmBed_"#"_PatSex_"#"_PatAge_"#"_PatW_"#"_PatH_"#"_mobPhone
	S wrMasDataList=wrMasDataList_"#"_WRWard_"#"_WRDept_"#"_WRBloodType_"#"_WRCurStatus_"#"_WRGuidance_"#"_WRUser_"#"_WRDate_"#"_WRTime
	;s wrHisList=..GetPatInfoFromEmr(AdmDr)  //现病史、既往病史、个人史及家族史、过敏史
	S wrHisPreComList=..getWRHisPreCom(wardRoundID)    //现病史
	S wrPasDisHisList=..getWRPasDisHis(wardRoundID)    //既往病史
	S wrPerFamHisList=..getWRPerFamHis(wardRoundID)    //个人史及家族史	
	S wrAllergHisList=..getWRAlleicHis(wardRoundID)    //过敏史
	S wrPasMedHisList=..getWRPasMedHis(wardRoundID)    //既往用药史
	S wrConDisTreList=..getWRConDisTre(wardRoundID)    //伴发疾病与用药情况	
	S ret=wrMasDataList_"#"_wrPasMedHisList_"#"_wrConDisTreList_"#"_wardRoundID_"#"_WRSignPath_"#"_wrHisPreComList_"#"_wrPasDisHisList_"#"_wrPerFamHisList_"#"_wrAllergHisList_"#"_WRICDesc
	s ListData=ret
	s ListTitle="PatNo#PatName#AdmBed#PatSex#PatAge#PatW#PatH#mobPhone#WRWard#WRDept#WRBloodType#WRCurStatus#WRtreatment#WRUser#WRDate#WRTime#wrPasMedHisList#wrConDisTreList#wardRoundID#WRSignPath#wrHisPreComList#wrPasDisHisList#wrPerFamHisList#wrAllergHisList#WRICDesc"
	d OutBinStream.Write("[")  //输出json前缀串
	d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(ListTitle,ListData,"#"))
	d OutBinStream.Write("]")   //输出json结尾符
	D OutBinStream.OutputToDevice()
	q OutBinStream
}

/// Creator:wangxuejian
/// CreatDate:2017-05-10
/// Description:从电子病历中取病人的生命体征和各种数据
/// return: 现病史 既往病史  个人史及家族史 过敏史 入院诊断
/// other:w ##class(web.DHCSTPHCMPharmacywardround).GetPatInfoFromEmr("651")
ClassMethod GetPatInfoFromEmr(EpisodeID As %String) As %String
{
	Set obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(EpisodeID,"HDSD00.13")
	s PreDisHis=obj.GetAt("HDSD00.13.095")	//入院记录	现病史
	s PasDisHis=obj.GetAt("HDSD00.13.300")	//入院记录 既往病史
	s perHis=obj.GetAt("HDSD00.13.036")	//入院记录 个人史
	s FamHis=obj.GetAt("HDSD00.13.043")	//入院记录  家族史
	s AllergicHis=obj.GetAt("HDSD00.13.037")	//入院记录 过敏史 
	S WRICDesc=..GetMRDiagnosByEpisodeID(EpisodeID) //入院诊断		
	s LifeSignData=PreDisHis_"#"_PasDisHis_"#"_perHis_"。"_FamHis_"#"_AllergicHis_"#"_WRICDesc
	q LifeSignData
	;q "现病史^既往病史^个人史。家族史^过敏史"
}

/// Descript:临床查房指导范围
/// w ##class(web.DHCSTPHCMPharmacywardround).getWRGuidance(178)
ClassMethod getWRGuidance(wardRoundID As %String) As %GlobalCharacterStream
{
	N (wardRoundID,curStatus)
	s CH="",ret=""
	s Num=0
	s StPage = 1, EndPage = 999
    S pid=..NewPid()
    d ..killTmpGlobal(pid)
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
	f  s CH=$o(^DHCPHWR(wardRoundID,"G",CH)) Q:CH=""  D
	.s data=$g(^DHCPHWR(wardRoundID,"G",CH))
	.s Num=Num+1
	.s ^TMP("DHCST","web.DHCSTPHCMPharmacywardround","getWRGuidance",pid,Num)=data
	S Title="gcode"
	s maxrow=Num
	i EndPage>maxrow S EndPage=maxrow
	s quitflag=0
	d OutBinStream.Write("[")  //输出json前缀串
	S Num=0
	s index=""
	f  S index=$o(^TMP("DHCST","web.DHCSTPHCMPharmacywardround","getWRGuidance",pid,index)) Q:(index="")||(quitflag=1)  D
	.s mdata=^TMP("DHCST","web.DHCSTPHCMPharmacywardround","getWRGuidance",pid,index)
	.s Num=Num+1
	.q:Num<StPage
	.s:Num=EndPage quitflag=1
	.i Num=StPage d
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"^"))
	d OutBinStream.Write("]")   //输出json结尾符
	D ..killTmpGlobal(pid) //k掉临时global
   // D OutBinStream.OutputToDevice()
    Q OutBinStream
}

/// Descript:现病史
ClassMethod getWRHisPreCom(wardRoundID As %String) As %String
{
	N (wardRoundID,curStatus)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"HPC",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"HPC",CH))
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:既往病史
ClassMethod getWRPasDisHis(wardRoundID As %String) As %String
{
	N (wardRoundID)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"PDH",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"PDH",CH))
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:个人史及家族史
ClassMethod getWRPerFamHis(wardRoundID As %String) As %String
{
	N (wardRoundID)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"PFH",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"PFH",CH))
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:过敏史
ClassMethod getWRAlleicHis(wardRoundID As %String) As %String
{
	N (wardRoundID)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"AH",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"AH",CH))
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:既往用药史
/// w ##class(web.DHCSTPHCMPharmacywardround).getWRPasMedHis(145)
ClassMethod getWRPasMedHis(wardRoundID As %String) As %String
{
	N (wardRoundID)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"PMH",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"PMH",CH))
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Descript:伴发疾病与用药情况
ClassMethod getWRConDisTre(wardRoundID As %String) As %String
{
	N (wardRoundID)
	S CH="",ret=""
	F  S CH=$o(^DHCPHWR(wardRoundID,"CDT",CH)) Q:CH=""  D
	.S mdata=$g(^DHCPHWR(wardRoundID,"CDT",CH))
	.i ret="" S ret=mdata
	.E  S ret=ret_"||"_mdata
	Q ret
}

/// Creator:   wangxuejian
/// CreateDate: 2017-05-16
/// Descript:获取关注药品信息
/// Table: DHC_PHWRDrgItm
/// Input: 保存药学查房的id
/// w ##class(web.DHCSTPHCMPharmacywardround).getWRDrgItm("178")
ClassMethod getWRDrgItm(wardRoundID As %String, StPage = "1", EndPage = "999") As %GlobalCharacterStream
{
	N (wardRoundID,StPage,EndPage)
	S pid=..NewPid()
    d ..killTmpGlobal(pid)
    s OutBinStream=##Class(%GlobalCharacterStream).%New()
	s Num=0
	S CH="",ret=""  
	F  S CH=$o(^DHCPHWR(wardRoundID,"DI",CH)) Q:CH=""  D
	.S orditm=$p(^DHCPHWR(wardRoundID,"DI",CH),"^",1)  //医嘱ID
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
	.S doseuom=$p($g(^CT("UOM",dosuomID)),"^",2)    //剂量单位
	.S freqdr=+$p($g(^OEORD(ord,"I",chl,2)),"^",4)  //OEORI_PHFreq_DR
    .S freq=$p($g(^PHCFR(freqdr)),"^",3)            //频率
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
	.S:StartDate'="" StartDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(StartDate)  ;$zd(StartDate,3)
	.S Num=Num+1
	.S ^TMP("DHCST","web.DHCSTPHCMPharmacywardround","getWRDrgItm",pid,Num)=orditm_"#"_StartDate_"#"_inciDesc_"#"_dosage_doseuom_"#"_freq_"#"_instru_"#"_duration_"#"_doctor_"#"_genenic_"#"_form_"#"_manf	
	S Title="orditm#StartDate#incidesc#Dosage#freq#Instance#duration#Doctor#genenic#form#manf"
	S maxrow=Num
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	d OutBinStream.Write("[")  //输出json前缀串
	S Num=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPharmacywardround","getWRDrgItm",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMPharmacywardround","getWRDrgItm",pid,index)
	.S Num=Num+1
	.Q:Num<StPage
	.S:Num=EndPage quitflag=1
	.I Num=StPage d
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"#"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"#"))
	d OutBinStream.Write("]")   //输出json结尾符
	d ..killTmpGlobal(pid)	
    //D OutBinStream.OutputToDevice()
	q OutBinStream
}

/// Descript:住院期间患者历史记录
/// w ##class(web.DHCSTPHCMPharmacywardround).GetPhaWardRecord("15","1","644","2017-3-10","2017-05-12")
ClassMethod GetPhaWardRecord(rows, page, AdmDr, startDate, endDate) As %GlobalCharacterStream
{
	n (rows,page,AdmDr,startDate,endDate)
	s StPage = page, EndPage = rows
	;s pid=##class(web.DHCSTPHCMADDINST).GetPID()
	S pid=..NewPid()
	d ..killTmpGlobal(pid)	
	s OutBinStream=##Class(%GlobalCharacterStream).%New()
	s curStatus="I" 
	s stdate=$zdh(startDate,3)
	s enddate=$zdh(endDate,3)
	s endpage=page*rows  //结束行
	s stpage=((page-1)*rows)+1 //开始行
	s h=0
	s fdate=0
	f fdate=stdate:1:enddate  d
	.s wardRoundID=""
	.f  s wardRoundID=$o(^DHCPHWR(0,"DataAdm",fdate,AdmDr,wardRoundID)) q:(wardRoundID="")||(wardRoundID=0)  d
	..S WRCurStatus=$p(^DHCPHWR(wardRoundID),"^",6) //当前状态
	..q:WRCurStatus'=curStatus  ;过滤掉不是“In”住院期间患者的记录信息
	..S WRUser=""
	..S WRUserDr=$p(^DHCPHWR(wardRoundID),"^",8)    //记录人
	..S:WRUserDr'="" WRUser=$p(^SSU("SSUSR",WRUserDr),"^",2)
	..S WRDate=$p(^DHCPHWR(wardRoundID),"^",9)      //记录日期
	..S:WRDate'="" WRDate=$zd(WRDate,3) ;WRDate=##class(web.DHCSTPHCMCOMMON).DateLogicalToHtml(WRDate) 
	..s h=h+1
	..S data=wardRoundID_"#"_WRDate_"#"_WRUser
	..s ^TMP("DHCST","web.DHCSTPHCMPharmacywardround","GetPhaWardRecord",pid,h)=data
	S Title="rowid#recordDate#user"
	S maxrow=h
	I EndPage>maxrow S EndPage=maxrow
	S quitflag=0
	d OutBinStream.Write("[")  //输出json前缀串
	S Count=0
	S index=""
	F  S index=$o(^TMP("DHCST","web.DHCSTPHCMPharmacywardround","GetPhaWardRecord",pid,index)) Q:(index="")||(quitflag=1)  D
	.S mdata=^TMP("DHCST","web.DHCSTPHCMPharmacywardround","GetPhaWardRecord",pid,index)
	.S Count=Count+1
	.Q:Count<StPage
	.S:Count=EndPage quitflag=1
	.I Count=StPage d
	..d OutBinStream.Write(##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"#"))
	.e  d
	..d OutBinStream.Write(","_##Class(web.DHCSTPHCMJsonCommon).getJsonData(Title,mdata,"#"))
	d OutBinStream.Write("]")   //输出json结尾符
	d ..killTmpGlobal(pid)	
	D OutBinStream.OutputToDevice()
	q OutBinStream
}

/// Descript:根据住院期间病人rowid加载病人的治疗方案和签名路径
/// w ##class(web.DHCSTPHCMPharmacywardround).GetInPhaWardRound("209")
ClassMethod GetInPhaWardRound(Rowid) As %String
{
	n (Rowid)
	s rowid=Rowid
	q:rowid=""
	s Num=0
	S treatment=""
	S treatment=$p(^DHCPHWR(rowid),"^",7)             //治疗方案
	S WRSignPath=$p(^DHCPHWR(rowid),"^",12)     //签名路径
	q treatment_"#"_WRSignPath
}

/// Creator：   wangxuejian
/// CreatDate：  2017-05-9
/// Description：获取入院诊断
/// Table：      PA_ADM,MR_Diagnos,MRC_ICDDx
/// Input：      EpisodeID
/// Return：     MRDIAICDCodeDR(指向MRC_ICDDx),MRDiagnos
/// Debug:	  w ##class(web.DHCSTPHCMPharmacywardround).GetMRDiagnosByEpisodeID("2")
ClassMethod GetMRDiagnosByEpisodeID(EpisodeID As %String) As %String
{
	n (EpisodeID)
	q:+EpisodeID=0 ""
	s MRDiagnos="",Num=0
	s INDiaType=$O(^MRC("DTYP",0,"Code","C008",0)) ;入院诊断
	s mradmId=$p(^PAADM(+EpisodeID),"^",61)
	s mrdiaSub=0
	f  s mrdiaSub=$o(^MR(mradmId,"DIA",mrdiaSub)) Q:(mrdiaSub="")  D
	.s TYPMRCDiagTyp=$p(^MR(mradmId,"DIA",mrdiaSub,"TYP",1),"^",1)
	.q:TYPMRCDiagTyp'=INDiaType
	.s MRDIAICDCodeDR=+$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
	.//Q:MRDIAICDCodeDR=""
	.s MRDiagDesc=$p($g(^MRC("ID",MRDIAICDCodeDR)),"^",2)    /// 诊断描述
	.s MRDiagNotes=$g(^MR(mradmId,"DIA",mrdiaSub,"DES",1))   /// 诊断注释
	.i MRDiagNotes'="" s MRDiagNotes=""_MRDiagNotes_""
	.s Num=Num+1
	.i MRDiagnos="" D
	..s MRDiagnos=Num_"、"_MRDiagDesc_MRDiagNotes
	.e  d
	..s MRDiagnos=MRDiagnos_"；"_Num_"、"_MRDiagDesc_MRDiagNotes
	;Q "入院诊断"
	q MRDiagnos
}

/// Descript:计数器
ClassMethod NewPid() As %String
{
	q $i(^DHCST("PHCMPharmacywardround"))
}

/// Descript:k掉临时global
ClassMethod killTmpGlobal(pid) As %String
{
	k ^TMP("DHCST","web.DHCSTPHCMPharmacywardround","getWRDrgItm",pid)
	;k ^TMP("DHCST","web.DHCPHMEDEDUCATION","getMedEduDrgItm",pid)
	k ^TMP("DHCST","web.DHCSTPHCMPharmacywardround","getGuiScopePatCode",pid)
	k ^TMP("DHCST","web.DHCSTPHCMPharmacywardround","getWRGuidance",pid)
	k ^TMP("DHCST","web.DHCSTPHCMPharmacywardround","GetPhaWardRecord",pid)
}

}
