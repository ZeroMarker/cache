Import sqluser

/// Description:煎药室操作表结构相关
/// Creator:    hulihua
/// CreateDate: 2017-11-29
/// Table:      DHC_PhaMedBroth-揭药主表、DHC_PhaMedBrothItm-揭药子表
Class web.DHCINPHA.HMRecordWorkLoad.SqlDbRecordWorkLoad Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:第三方移动端完成煎药之后回传给HIS煎药信息
/// Creator:	hulihua
/// CreateDate:	2017-11-08
/// Table:      DHCST_MBCCollDrug-煎药主表、DHCST_MBCCollDrugItem-煎药子表
/// Input:		type-业务类型（I-住院、O-门诊）、dispid-发药主表ID、TisaneListData-煎药信息串
/// Output:
/// Return： 	0-成功、非0-失败  
/// Others:
/// w ##class(web.DHCINPHA.HMRecordWorkLoad.SqlDbRecordWorkLoad).InsertMBCData()
ClassMethod InsertMBCData(type, dispid, TisaneListData)
{
	n (type, dispid, TisaneListData)
	//s ^hlh($h)=$lb(type, dispid, TisaneListData)
	i type="I"  d
	.s PhLocId=$p(^DHCPHAC(dispid),"^",1)
	.s WardId=$p(^DHCPHAC(dispid),"^",4)  		//患者病区
  	.s deplocdr=$p(^PAWARD(WardId),"^",5)  		//病区对应的CT_Loc记录
	.s dispch=$o(^DHCPHAC(dispid,"I",""),-1)
	.s AdmDr=$p(^DHCPHAC(dispid,"I",dispch),"^",3)
	.s prescNo=$p(^DHCPHAC(dispid,"I",dispch),"^",5)
	.s oeori=$p(^DHCPHAC(dispid,"I",dispch),"^",7)
	e  d
	.s PhlDr=$p(^DHCPHDISP(dispid,1),"^",1)
	.s PhLocId=$p(^DHCPHLOC(PhlDr),"^",1)
	.s Papmi=$p(^DHCPHDISP(dispid),"^",7)
	.s AdmId=$p(^DHCPHDISP(dispid,1),"^",18)    
	.s deplocdr=$p(^PAADM(AdmId),"^",4) 		//患者就诊科室
	.s prescNo=$p(^DHCPHDISP(dispid,2),"^",1)
	.s dispch=$o(^DHCPHDI(dispid,"PHDI",""),-1)
	.s oeori=$p(^DHCPHDI(dispid,"PHDI",dispch),"^",5)
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7)  //医嘱日期
    s ordtime=+$p(^OEORD(ord,"I",itm,1),"^",17) //医嘱时间
	s prescNoStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	s facotor=$p(prescNoStr,"^",2)
    s Err=0
    tstart
    s $ZT="Error^DHCSTERROR"
    s MBCRowid=$o(^DHCMBC(0,"PRESCNO",prescNo,""),-1)
    i MBCRowid="" d
    .;插入煎药主表
	.&sql(insert into DHCST_MBCCollDrug(MBC_PrescNo,MBC_Adm_Dr,MBC_Facotor,MBC_Pointer,
	MBC_OrdDate,MBC_OrdTime,MBC_Type,MBC_LocDr) values(:prescNo,:AdmDr,:facotor,:dispid,
	:orddate,:ordtime,:type,:deplocdr))
	.i SQLCODE'=0  d
 	..s ret=$$SqlErrorRecord^DHCSTERROR("Insert:DHCST_MBCCollDrug",prescNo,SQLCODE_":"_%msg)
 	..s Err="-7^插入煎药主表失败！" 
 	.e  d
 	..s MBCRowid=$p(%ROWID,$c(1))
 	.q:Err'=0
 	i Err'=0 trollback
 	q:Err'=0 Err
	;插入煎药子表
	s len=$l(TisaneListData,"&&")
	f i=1:1:len  q:Err'=0  d
	.s TisaneInfo=$p(TisaneListData,"&&",i)
	.q:TisaneInfo=""
	.s TisaneStatue=$p(TisaneInfo,"^",1)
	.q:TisaneStatue=""
	.s statedr=$o(^DHCMBCS(0,"TYPENAME",type,TisaneStatue,""),-1)
	.i statedr="" d
	..s Err="-8^HIS系统中"_TisaneStatue_"状态未维护！" 
	.q:Err'=0
	.s TisaneUserCode=$p(TisaneInfo,"^",4)
	.s TisaneUser=$s(TisaneUserCode'="":$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(TisaneUserCode),""),-1),1:"")
	.i (TisaneUserCode'="")&&(TisaneUser="")  d
	..s Err="-9^HIS系统中"_TisaneStatue_"人工号不存在！" 
	.q:Err'=0
	.s TisaneDate=$p(TisaneInfo,"^",2)
	.s TisaneTime=$p(TisaneInfo,"^",3)
	.s DataSource="1"
	.s MBCRowidCh=$o(^DHCMBC(0,"ITMSTATE",statedr,MBCRowid,""),-1)
	.i MBCRowidCh=""  d
	..s ChildSub=$o(^DHCMBC(MBCRowid,"I",""),-1)+1
  	..&sql(Insert into DHCST_MBCCollDrugItem(MBCI_Parref,MBCI_ChildSub,MBCI_DateUser_Dr,
  	MBCI_Date,MBCI_Time,MBCI_State_Dr,MBCI_DataSource) values(:MBCRowid,:ChildSub,:TisaneUser,:TisaneDate,
  	:TisaneTime,:statedr,:DataSource))
	..i SQLCODE'=0  d
 	...s ret=$$SqlErrorRecord^DHCSTERROR("Insert:DHCST_MBCCollDrugItem",prescNo_"#"_TisaneStatue,SQLCODE_":"_%msg)
 	...s Err="-10^插入煎药子表失败！"
 	..q:Err'=0
 	.e  d
 	..s MBCIRowId=MBCRowid_"||"_MBCRowidCh
 	..&sql(Update DHCST_MBCCollDrugItem set MBCI_DateUser_Dr=:TisaneUser,MBCI_Date=:TisaneDate,
 	MBCI_Time=:TisaneTime,MBCI_State_Dr=:statedr,MBCI_DataSource=:DataSource where MBCI_Rowid=:MBCIRowId)
	..i SQLCODE'=0  d
 	...s ret=$$SqlErrorRecord^DHCSTERROR("Update:DHCST_MBCCollDrugItem",prescNo_"#"_TisaneStatue,SQLCODE_":"_%msg)
 	...s Err="-10^更新煎药子表失败！"
 	..q:Err'=0
 	.q:Err'=0
 	.;草药处方需要插入处方追踪信息！
 	.s PreStatDesc="煎药室"_TisaneStatue
 	.s PreStatId=$o(^DHCPHAPSTATEi("STATEDESC",$$ALPHAUP^SSUTIL4(PreStatDesc),""),-1)
 	.s PreStatCode=$s(PreStatId'="":$p(^DHCPHAPSTATE(PreStatId),"^",1),1:"")
 	.i PreStatCode'=""  d
	..s SqlStr="^^"_prescNo_"^"_PreStatCode_"^"_PhLocId_"^"_TisaneUser_"^"_TisaneDate_"^"_TisaneTime
	..d ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr,"1")
	.
 	i Err'=0 trollback
 	q:Err'=0 Err
 	tcommit
 	q Err
}

/// Description:界面扫描记录煎药室工作量
/// Creator:	hulihua
/// CreateDate:	2017-11-29
/// Table:      DHCST_MBCCollDrug-煎药主表、DHCST_MBCCollDrugItem-煎药子表
/// Input:		业务类型（I-住院、O-门诊）、发药主表ID、煎药状态、记录工号
/// Output:
/// Return： 	0-成功、非0-失败  
/// Others:
/// w ##class(web.DHCINPHA.HMRecordWorkLoad.SqlDbRecordWorkLoad).SaveMBCData()
ClassMethod SaveMBCData(SqlStr)
{
	n (SqlStr)
	s type=$p(SqlStr,"^",1)
	s dispid=$p(SqlStr,"^",2)
	s TisaneStatue=$p(SqlStr,"^",3)
	s statedr=$o(^DHCMBCS(0,"TYPENAME",type,TisaneStatue,""),-1)
	q:statedr="" "-5^系统中"_TisaneStatue_"状态未维护！" 
	i type="I"  d
	.s PhLocId=$p(^DHCPHAC(dispid),"^",1)
	.s WardId=$p(^DHCPHAC(dispid),"^",4)  		//患者病区
  	.s deplocdr=$p(^PAWARD(WardId),"^",5)  		//病区对应的CT_Loc记录
	.s dispch=$o(^DHCPHAC(dispid,"I",""),-1)
	.s AdmDr=$p(^DHCPHAC(dispid,"I",dispch),"^",3)
	.s prescNo=$p(^DHCPHAC(dispid,"I",dispch),"^",5)
	.s oeori=$p(^DHCPHAC(dispid,"I",dispch),"^",7)
	e  d
	.s PhlDr=$p(^DHCPHDISP(dispid,1),"^",1)
	.s PhLocId=$p(^DHCPHLOC(PhlDr),"^",1)
	.s Papmi=$p(^DHCPHDISP(dispid),"^",7)
	.s AdmId=$p(^DHCPHDISP(dispid,1),"^",18)    
	.s deplocdr=$p(^PAADM(AdmId),"^",4) 		//患者就诊科室
	.s prescNo=$p(^DHCPHDISP(dispid,2),"^",1)
	.s dispch=$o(^DHCPHDI(dispid,"PHDI",""),-1)
	.s oeori=$p(^DHCPHDI(dispid,"PHDI",dispch),"^",5)
	s ord=+oeori
	s itm=$p(oeori,"||",2)
	s orddate=+$p(^OEORD(ord,"I",itm,3),"^",7) //医嘱日期
    s ordtime=+$p(^OEORD(ord,"I",itm,3),"^",15) //医嘱时间
	s prescNoStr=##class(web.DHCPHACOM.ComPubClass.HMPrescMethod).GetPaQueInfo(prescNo)
	s facotor=$p(prescNoStr,"^",2)
    s Err=0,CheckFlag=""
    tstart
    s $ZT="Error^DHCSTERROR"
    s MbcId=$o(^DHCMBC(0,"PRESCNO",prescNo,""),-1)
    i MbcId="" d
    .;插入煎药主表
	.&sql(insert into DHCST_MBCCollDrug(MBC_PrescNo,MBC_Adm_Dr,MBC_Facotor,MBC_Pointer,
	MBC_State_Dr,MBC_OrdDate,MBC_OrdTime,MBC_Type,MBC_LocDr) values(:prescNo,:AdmDr,
	:facotor,:dispid,:statedr,:orddate,:ordtime,:type,:deplocdr))
	.i SQLCODE'=0  d
 	..s ret=$$SqlErrorRecord^DHCSTERROR("Insert:DHCST_MBCCollDrug",prescNo,SQLCODE_":"_%msg)
 	..s Err="-6^插入煎药主表失败！"
 	.e  d
 	..s MbcId=$p(%ROWID,$c(1)) 
 	..s CheckFlag=1
 	e  d
 	.;更新煎药主表的状态
	.&sql(update DHCST_MBCCollDrug set MBC_State_Dr=:statedr where MBC_RowId=:MbcId)
	.i SQLCODE'=0  d
 	..s ret=$$SqlErrorRecord^DHCSTERROR("update:DHCST_MBCCollDrug",MbcId_","_TisaneStatue,SQLCODE_":"_%msg)
 	..s Err="-7^更新煎药主表失败！" 
 	i Err'=0 trollback
 	q:(Err'=0)||(MbcId="") Err
	;插入煎药子表
	i CheckFlag'=1  d
	.s MbciCh=$o(^DHCMBC(0,"ITMSTATE",statedr,MbcId,""),-1)
	.i MbciCh'="" d
	..s Err="-8^此处方在"_TisaneStatue_"状态下已记录！" 
	i Err'=0 trollback
	q:Err'=0 Err
	s TisaneUser=$p(SqlStr,"^",4)
	s:(TisaneUser="")||('$d(^SSU("SSUSR",TisaneUser))) Err="-9^"_TisaneStatue_"人为空或者不存在！" 
	i Err'=0 trollback
	q:Err'=0 Err
	s TisaneDate=+$h
	s TisaneTime=$p($h,",",2)
	s ChildSub=$o(^DHCMBC(MbcId,"I",""),-1)+1
  	&sql(insert into DHCST_MBCCollDrugItem(MBCI_Parref,MBCI_ChildSub,MBCI_DateUser_Dr,
  	MBCI_Date,MBCI_Time,MBCI_State_Dr) values(:MbcId,:ChildSub,:TisaneUser,:TisaneDate,
  	:TisaneTime,:statedr))
	i SQLCODE'=0  d
 	.s ret=$$SqlErrorRecord^DHCSTERROR("Insert:DHCST_MBCCollDrugItem",prescNo_"#"_TisaneStatue,SQLCODE_":"_%msg)
 	.s Err="-10^插入煎药子表失败！"
 	i Err'=0 trollback
 	q:Err'=0 Err
 	tcommit
 	;草药处方需要插入处方追踪信息！
 	s PreStatDesc="煎药室"_TisaneStatue
 	s PreStatId=$o(^DHCPHAPSTATEi("STATEDESC",$$ALPHAUP^SSUTIL4(PreStatDesc),""),-1)
 	s PreStatCode=$s(PreStatId'="":$p(^DHCPHAPSTATE(PreStatId),"^",1),1:"")
 	i PreStatCode'=""  d
	.s SqlStr="^^"_prescNo_"^"_PreStatCode_"^"_PhLocId_"^"_TisaneUser_"^"_TisaneDate_"^"_TisaneTime
	.d ##class(web.DHCINPHA.HMPresTrack.SqlDbPresTrack).HandlePresTrackDB(SqlStr,"1")
 	q Err
}

/// Description:记录发药调剂信息
/// Creator:	hulihua
/// CreateDate:	2017-12-06
/// Table:      DHC_PHACollected、DHC_PHDISPEN
/// Input:		业务类型（I-住院、O-门诊）、发药主表ID、煎药状态、记录工号
/// Output:
/// Return： 	0-成功、非0-失败  
/// Others:
/// w ##class(web.DHCINPHA.HMRecordWorkLoad.SqlDbRecordWorkLoad).SaveAdjustorData()
ClassMethod SaveAdjustorData(SqlStr)
{
	n (SqlStr)
	s type=$p(SqlStr,"^",1)
	s DispId=$p(SqlStr,"^",2)
	s TisaneStatue=$p(SqlStr,"^",3)
	s Operator=$p(SqlStr,"^",4)
	q:(Operator="")||('$d(^SSU("SSUSR",Operator))) "-5^"_TisaneStatue_"人为空或不存在！"
	s TisaneDate=+$h,TisaneTime=$p($h,",",2)
	s DataSource="1"
	s Err=0
	i type="I"  d
	.&sql(update DHC_PHACollected set DHC_PHAOperator=:Operator,DHC_PHAOperateDate=:TisaneDate,
	DHC_PHAOperateTime=:TisaneTime,DHC_PHADataSource=:DataSource where DHC_PHACollect_RowID=:DispId)
	.i SQLCODE'=0  d
 	..s ret=$$SqlErrorRecord^DHCSTERROR("SaveAdjustorData:DHC_PHACollected",DispId,SQLCODE_":"_%msg)
 	..s Err="-6^更新住院发药主表失败！"
	e  d
	.s pydr=$o(^DHCPHPERi("USR",Operator,""),-1)
	.s:pydr="" Err="-7^该工号在门诊药房未维护！"
	.q:Err'=0
	.&sql(update DHC_PHDISPEN set PHD_PHP_PYDR=:pydr,PHD_PYEDDATE=:TisaneDate,PHD_PYEDTIME=:TisaneTime where PHD_ROWID=:DispId)
	.i SQLCODE'=0  d
 	..s ret=$$SqlErrorRecord^DHCSTERROR("SaveAdjustorData:DHC_PHDISPEN",DispId,SQLCODE_":"_%msg)
 	..s Err="-6^更新门诊发药主表失败！"
 	q:Err'=0 Err
 	q Err
}

}
