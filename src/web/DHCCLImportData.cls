/// 创 建 者：lijie
/// 描    述：web.DHCCLImportData里面的方法是与东华HIS相关的，主要功能是将数据插入HIS，
/// 	          核心方法是保存病人基本信息、就诊信息、转科信息和医嘱信息，
/// 			  还包括码表导入的方法。
/// 创建日期：2015年11月15日
Class web.DHCCLImportData Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// w ##class(web.DHCCLImportData).SavePatInfo("","刘柏三","1","1970-12-12","中国","汉族","422341199208080214","18290980981","AB")
/// 说明：保存病人基本信息以及就诊信息,主要判断PatientId是否为空，为空则增加，否则修改
ClassMethod SavePatInfo(PatientId As %String, Name As %String, Sex As %String, DateOfBirth As %String, Citizenship As %String, Nation As %String, IDNO As %String, PhoneNumberHome As %String, PhoneNumbeBusiness As %String, BldTyp As %String, UserDR As %String, MedicareNo As %String) As %String
{
	//病人信息								
	q:'$d(^CT("SEX",Sex)) "-1^性别不对"
	
	s rPatInfo=##class(web.DHCEntity.PCA.PATMAS).%New()																	
	s rPatInfo.PAPMIRowID                     =PatientId				//PatientId 病人标识号，唯一
	s rPatInfo.Name                           =Name						//姓名
	s rPatInfo.Sex                            =Sex						//性别 1-男，2-女，0-未知
	s rPatInfo.Birth                          =DateOfBirth				//出生日期
	s rPatInfo.CountryDescLookUpRowID 		  =Citizenship				//国籍 1-中国
	s rPatInfo.NationDescLookUpRowID          =Nation					//民族 1-汉族
	s rPatInfo.CredType                       =1	    				//证件类型 1-身份证
    s rPatInfo.CredNo                         =IDNO						//身份证号
	s rPatInfo.TelHome                        =PhoneNumberHome			//家庭电话号码																	//ChargeType 费别
	s rPatInfo.TelOffice                      =PhoneNumbeBusiness   	//单位电话号码
																		//MotherPatientNo 母亲病人标识，针对新生儿
																		//NextOfKin 联系人姓名
																		
	s rPatInfo.InMedicare                     =MedicareNo				//住院号
	s rPatInfo.OpMedicare                     =""						//门诊号																	
    s rPatInfo.Address                        =""      					//地址
    s rPatInfo.Allergy                        =""   					//过敏史
    s rPatInfo.MobPhone                       =""  						//手机号
    s rPatInfo.PatType                        =""     					//病人类型
    s rPatInfo.ProvinceInfoLookUpRowID        =""  						//省

    s rPatInfo.UpdateDate                     =+$h
    s rPatInfo.UpdateTime                     =$p($h,",",2)						
    s rPatInfo.UserDR                         =""   					//操作用户
    s rPatInfo.Vocation                       =""						//职业
    s rPatInfo.ZipLookUpRowID                 =""						//邮编
    s rPatInfo.PatYBCode                      =""						//医疗保险卡号
    s rPatInfo.BloodType					  =BldTyp					//BloodTypeCode 血型代码:1-A型，2-B型，3-O型，4-AB型，5-不详，6-未查
    s rPatInfo.UserDR						  =UserDR					//操作用户
    //病人建卡
    s myrtn=##class(web.DHCBL.CARD.UCardPaPatMasInfo).SavePatInfo(rPatInfo)
	s ret=$p(myrtn,"^",1)
	q:ret<0 ret
	
	s PatientID=$p(myrtn,"^",2)
	q PatientID
}

//w ##class(web.DHCCLImportData).InsertAdmInfo(271,"2015-11-05 14:46",40,69,23,"23||2")

/// 插入就诊信息
ClassMethod InsertAdmInfo(PatientID As %String, AdmDate As %String, deptId As %String, receiveDocId As %String, userId As %String, wardId As %String, bedId As %String, MrcidDesc As %String = "") As %String
{
	//就诊信息
	q:PatientID="" "-1^PatientID不能为空"
	q:'$d(^CTLOC(deptId)) "-1^就诊科室不存在"
	q:'$d(^CTPCP(receiveDocId,1)) "-1^就诊医生不存在"
	q:'$d(^PAWARD(wardId)) "-1^病区不存在"
	
    //s PatientID							     			            // 1-PatientID
    s AdmType								 ="I" 						// 2-就诊类型
    s Dt									 =$Extract(AdmDate,0,19)    //   AdmDate,就诊日期时间（入院日期时间）yyyy-mm-dd hh:mm
    s AdmDate								 =$ZDH($p(Dt," ",1),3)		// 3-就诊日期
    s AdmTime								 =$ZTH($p(Dt," ",2),2)		// 4-就诊时间
    s AdmDep								 =deptId       				// 5-就诊科室
    s AdmDoc								 =receiveDocId	     		// 6-就诊医生(ctcpId)
    s AdmReason								 =""               			// 7-费用类别
    s CreateUser							 =""        				// 8-操作员代码
    s AdmWard								 =wardId					// 9-就诊病区
    s AdmRoom								 =""        				//10-病房
    s AdmBed								 =bedId		   				//11-床位
    s Epissubtype							 =""                		//12-普通病人，绿色通道病人，国际医疗病部
    s AdmCate								 ="" 						//13-绿色通道  非绿色通道
    s AdmRefDocListDR						 =""     					//14-未知
    s AdmDiagnosCatRowId					 =""                		//15-特病类别
    s AdmUnkown								 =""					
    s AdmInPatNo							 =""            			//17-住院次数
    s AdmSrcDr								 =""                		//18-病人来源
    s FirstOrReadmis						 =""                		//19-是否首次就诊
    s InsuCoRowid							 =""    					//20-保险公司
    s Para=PatientID_"^"_AdmType_"^"_AdmDate_"^"_AdmTime_"^"_AdmDep_"^"_AdmDoc_"^"_AdmReason_"^"_CreateUser_"^"_AdmWard_"^"_AdmRoom_"^"_AdmBed_"^"_Epissubtype_"^"_AdmCate_"^"_AdmRefDocListDR_"^"_AdmDiagnosCatRowId_"^"_AdmUnkown_"^"_AdmInPatNo_"^"_AdmSrcDr_"^"_FirstOrReadmis_"^"_InsuCoRowid
    //病人挂号
    s EpisodeID=##class(web.DHCPAADM).ADMInsert(Para)
    q:EpisodeID="" "-1^插入病人失败"
    
    //同时插入医嘱
    s curDate=+$h
	s curTime=$p($h,",",2)
    &sql(insert into SQLUser.OE_Order (OEORD_Adm_DR,OEORD_Date,OEORD_Time)
			Values (:EpisodeID,:curDate,:curTime))
	q:SQLCODE "-2^插入医嘱失败"
	
	//保存诊断
	set ret=##class(web.DHCCLImportData).SaveMrcidDesc(EpisodeID,MrcidDesc)
	
	q EpisodeID
}

/// 更新就诊记录
ClassMethod SaveAdmInfo(EpisodeID As %String, PAPMIDr As %String, AdmDate As %String, deptId As %String, receiveDocId As %String, userId As %String, wardId As %String, bedId As %String, MrcidDesc As %String = "") As %String
{
	quit:EpisodeID="" "-1^就诊号为空"
	quit:PAPMIDr="" "-2^病人ID为空"
	quit:deptId="" "-3^科室Id为空"
	quit:receiveDocId="" "-4^就诊医生为空"
	quit:userId="" "-5^用户Id为空"
	quit:wardId="" "-6^病区Id为空"
	
	&sql(update SQLUser.PA_Adm set PAADM_PAPMI_DR=:PAPMIDr,PAADM_DepCode_DR=:deptId,PAADM_AdmDocCodeDR=:receiveDocId,PAADM_CurrentWard_DR=:wardId where PAADM_RowID=:EpisodeID)
	quit SQLCODE
}

/// w ##class(web.DHCCLImportData).TransAdm(534,69,13)	
/// 说明：转科记录 转病区，转床位，转科室
/// isWaitArea="1" 表示转到等待区，否则如果传入的床位为空，床位也会保持原来的不变
ClassMethod TransAdm(EpisodeID As %String, userId As %String, wardId As %String, bedId As %String, locId As %String, isWaitArea As %String = "") As %String
{
	q:(EpisodeID="")!(userId="")!(wardId="") "输入不能为空"
	q:'$d(^PAADM(EpisodeID)) "病人信息不存在"
	q:'$d(^SSU("SSUSR",userId)) "用户不存在"
	q:'$d(^PAWARD(wardId)) "病区不存在"
	q:'$d(^CTLOC(locId)) "科室不存在"
	
	s roomId=""
	s bedSub=""
	
	if (isWaitArea="1")
	{
		set bedId=""
	}
	else  
	{
		if bedId="" &sql(select PAADM_CurrentBed_DR into :bedId from SQLUser.PA_Adm where PAADM_RowId=:EpisodeID )
	}
	
	if (bedId'="")&(wardId=+bedId) set bedSub=$p(bedId,"||",2)
	else  set bedId=""

	if (bedId'="") set roomId=$p($g(^PAWARD(+bedId,"BED",$p(bedId,"||",2))),"^",3)
	
	//当前日期时间
	s curDate=+$h,curTime=$p($h,",",2)
	s curTime=$E($zt(curTime,1),1,5)
	s curTime=$zth(curTime,2)
	
	//是否编辑前一次转科记录
	s editPreTrans="Y"
	
	s reqstId=$o(^PAC("REQST",0,"Code","T",""))
	//转科类型为M(Move)
	s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
	
	//找到最近一次转科状态为T(Transfer)的记录
	s preTransSub="",transSub=0
	f  s preTransSub=$o(^PAADM(EpisodeID,"TRANS",preTransSub),-1) q:(preTransSub="")!(transSub>0)  d
	.i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)=transtypId s transSub=preTransSub
	
	set quitFlag=0
	if transSub>0 do
	.set preLocId=$p($g(^PAADM(EpisodeID,"TRANS",transSub)),"^",6)
	.set preWardId=$p($g(^PAADM(EpisodeID,"TRANS",transSub)),"^",9)
	.set preBedId=$p($g(^PAADM(EpisodeID,"TRANS",transSub)),"^",8)
	.if (preLocId=locId)&(preWardId=wardId)&(preBedId=bedId)&(isWaitArea="") set quitFlag=1
	//如果科室、病区和床位没有改变就不转科
	quit:quitFlag=1 0
	
	
	//将最近一次就诊记录状态改为D(Done),结束日期时间改为当前日期时间
	i transSub>0,editPreTrans="Y" d
	.s preTransId=EpisodeID_"||"_transSub
	.s preReqstId=$o(^PAC("REQST",0,"Code","D",""))
	.&sql(update SQLUser.PA_AdmTransaction set TRANS_Status_DR=:preReqstId,TRANS_EndDate=:curDate,TRANS_EndTime=:curTime where TRANS_RowId=:preTransId)
	
	//插入一条转科记录,状态为T(Transfer)
	&sql(insert into SQLUser.PA_AdmTransaction (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
		TRANS_Ward_DR,TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
		TRANS_TransType_DR,TRANS_Room_DR,TRANS_Bed_DR,TRANS_CTLOC_DR)  
		Values (:EpisodeID,:curDate,:curTime,:wardId,:reqstId,:curDate,:curTime,:userId,:transtypId,:roomId,:bedId,:locId))
	i SQLCODE q "插入转病区信息出错!"
	s transId=$g(%ROWID)
	q:transId="" "transId为空！！"
	
	//更新床位信息
	s bookedStatus="O"
	i $o(^PAWARDA(0,"ADM",EpisodeID,""))'="" d
	    .s curWardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
	    .s curBedSub=$o(^PAWARDA(0,"ADM",EpisodeID,+curWardId,""))
	    .s bedtpId=$p(^PAWARD(+curWardId,"BED",+curBedSub),"^",2)
	    .//删除原来床位病人信息
	    .&sql(delete from SQLUser.PAC_BedAdm where ADM_PAADM_DR=:EpisodeID)
	    .q:SQLCODE
	    
	//删除原来的病区病人信息
	i $o(^PAWARDA(0,"WADM",EpisodeID,""))'="" &sql(delete from SQLUser.PAC_WardAdm where WADM_PAADM_DR=:EpisodeID)
	if bedSub'="" 
	{
		&sql(insert into SQLUser.PAC_BedAdm (ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
			Values (:bedId,:EpisodeID,:bookedStatus,:transId))
		i SQLCODE q "插入床位信息出错!"
	}
	else
	{
		&sql(insert into SQLUser.PAC_WardAdm (WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus,WADM_Trans_DR)
			Values (:wardId,:EpisodeID,:bookedStatus,:transId))
		i SQLCODE q "插入等待区信息出错!"
	}
	//修改就诊表，病人当前病区，房间，床位
	&sql(update SQLUser.PA_Adm (PAADM_CurrentBed_DR,PAADM_CurrentWard_Dr,PAADM_CurrentRoom_DR,PAADM_DepCode_DR) Values (:bedId,:wardId,:roomId,:locId) Where PAADM_RowId=:EpisodeID)
	i SQLCODE q "更新就诊病区、房间及床位信息出错!"
	
	set ret="0^"_transId
	quit ret
}

/// w ##class(web.DHCCLImportData).DischargeFromHospital(54,310,1,2) //54是就诊号
/// 病人出院
ClassMethod DischargeFromHospital(EpisodeID As %String, userId As %String, wardId As %String, deptId As %String) As %String
{
	q:(EpisodeID="")!(userId="")!(wardId="") "输入不能为空"
	q:'$d(^PAADM(EpisodeID)) "病人信息不存在"
	q:'$d(^SSU("SSUSR",userId)) "用户不存在"
	q:'$d(^PAWARD(wardId)) "病区不存在"
	
	//先把病人转到等待区
	set ret=##class(web.DHCCLImportData).TransAdm(EpisodeID,userId,wardId,"",deptId,1)
	q:$p(ret,"^",1)'=0 ret
	
	set visitStatus="D"
	&sql(update SQLUser.PA_Adm set PAADM_VisitStatus=:visitStatus Where PAADM_RowId=:EpisodeID)
	q SQLCODE
}

/// w ##class(web.DHCCLImportData).AdmissionToHospital(54,310,1,"")
/// 病人入院
ClassMethod AdmissionToHospital(EpisodeID As %String, userId As %String, wardId As %String, bedId As %String, deptId As %String) As %String
{
	q:(EpisodeID="")!(userId="")!(wardId="") "输入不能为空"
	q:'$d(^PAADM(EpisodeID)) "病人信息不存在"
	q:'$d(^SSU("SSUSR",userId)) "用户不存在"
	q:'$d(^PAWARD(wardId)) "病区不存在"
	
	set visitStatus="A"
	&sql(update SQLUser.PA_Adm set PAADM_VisitStatus=:visitStatus Where PAADM_RowId=:EpisodeID)
	
	set ret=##class(web.DHCCLImportData).TransAdm(EpisodeID,userId,wardId,bedId,deptId)
	q ret
}

/// 插入医嘱
/// EpisodeID:病人就诊号
/// userId:开医嘱人员Id   arcimId:医嘱码   oecprId:医嘱优先级(3-临时医嘱，5-长期医嘱)
/// oecStatusId:医嘱状态(1-核实，4-停止，6-执行)
/// phcFreqId:医嘱频次(4-Qd,5-Bid,9-St)
/// phcInId:医嘱用法(2-口服，3-外用，4-注射，8-静脉滴注)
/// uomId:医嘱单位(5-个，7-瓶，20-ml) phDuratId:疗程(63-1天)  doseQty:剂量，
/// userDeptId:开医嘱科室  notes:备注   recDepID:接受科室   qty:首日次数   relateOrdItemDr:关联医嘱
/// w ##class(web.DHCCLImportData).InsertOrdItem(534,600,"806||1",5,1,4,8,20,100,63,19,"又下了一条医嘱",98)
ClassMethod InsertOrdItem(EpisodeID As %String, userId As %String, arcimId As %String, oecprId As %String, oecStatusId As %String, phcFreqId As %String, phcInId As %String, uomId As %String, doseQty As %String, phDuratId As %String, userDeptId As %String, notes As %String, recDepID As %String, dayExecTimes As %String = "", relateOrdItemDr As %String = "", stDate As %String = "", stTime As %String = "")
{
	q:(EpisodeID="")!(userId="")!(arcimId="")!(oecprId="")!(doseQty="") "-1^输入不能为空"
	
	q:'$d(^SSU("SSUSR",userId)) "-1^用户不存在"
	s ctcpId=$p(^SSU("SSUSR",+userId),"^",14)  //医护人员id
	q:ctcpId="" "-1^医护人员id不能为空"
	
	q:'$d(^ARCIM(+arcimId,+$p(arcimId,"||",2),1)) "-2^医嘱码不对"
	
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" "-1^医嘱Id不能为空"
	
	q:'$d(^OECPR(oecprId)) "-4^医嘱优先级不对"
	q:'$d(^OEC("OSTAT",oecStatusId)) "-3^医嘱状态不对"
	q:'$d(^PHCFR(phcFreqId)) "-5^医嘱频率不对"
	q:'$d(^PHCIN(phcInId)) "-6^医嘱用法不对"
	q:'$d(^CT("UOM",uomId)) "-7^单位不对"
	q:'$d(^PHCDU(phDuratId)) "-8^疗程不对"
	q:'$d(^CTLOC(userDeptId)) "-9^开医嘱科室不存在"
	q:'$d(^CTLOC(recDepID)) "-9^接受科室不存在"
	
	//获取当天医嘱序号
	s lastSeqNo=$o(^OEORDi(0,"StDtSeqNo",oeordId,+$h,""),-1)
    s lastSeqNo1=$p(lastSeqNo,".",1)
    s lastSeqNo2=$p(lastSeqNo,".",2)
	s seqNo=+lastSeqNo1+1
	
	//设置关联医嘱
	s isRelate=0
	if relateOrdItemDr'=""
	{
		set obj=##class(User.OEOrdItem).%OpenId(relateOrdItemDr)
		if $IsObject(obj) s isRelate=1
		if isRelate d
		.s lastSeqNo2=+lastSeqNo2+1
		.s seqNo=lastSeqNo1_"."_lastSeqNo2
	}
	
	
	if stDate="" set curDate=+$h
	else  set curDate=stDate
	if stTime="" set curTime=$p($h,",",2)
	else  set curTime=stTime
	
	k PLIST
	s PLIST(4)=arcimId								//OEORI_ItmMast_DR
	s PLIST(6)=userDeptId  							//OEORI_OrdDept_DR
	s PLIST(10)=oecStatusId   						//OEC_OrderStatus：1-核实，4-停止，6-执行
	s PLIST(14)=ctcpId  							//OEORI_Doctor_DR:
	s PLIST(17)=curDate 							//OEORI_SttDat
	s PLIST(18)=curTime  							//OEORI_SttTim
	s PLIST(23)=oecprId   							//OEORI_Priority_DR:3-临时，5-长期
	s PLIST(25)=phcFreqId   						//OEORIPHFreqDR: 4-Qd,5-Bid,9-St
	s PLIST(27)=phcInId   							//OEORI_Instr_DR: 2-口服，3-外用，4-注射
	s PLIST(28)=uomId   							//OEORI_Unit_DR: 5-个，7-瓶
	s PLIST(85)=doseQty 							//OEORI_DoseQty 剂量
	s PLIST(35)=phDuratId 							//OEORIDuratDR:疗程 63-1天
	s PLIST(45)="" 									//OEORI_BillDesc
	s PLIST(55)="Y"  								//OEORI_CoverMainIns  Y
	s PLIST(56)="N"  								//OEORI_PortEquipReq  N
	s PLIST(57)="N"  								//OEORI_AdministerSkinTest N
	s PLIST(63)="P"  								//OEORI_WhoGoWhere P
	s PLIST(75)=recDepID  							//OEORI_RecDep_DR
	s PLIST(76)="TB" 								//OEORI_Billed
	s PLIST(77)=seqNo					  			//OEORI_SeqNo，当天医嘱的序号
	s PLIST(81)=curDate    							//OEORI_Date
	s PLIST(90)=curTime    							//OEORI_TimeOrd
	s PLIST(111)="A" 								//OEORI_ResultFlag A
	s PLIST(192)=curDate 							//OEORI_UpdateDate
	s PLIST(193)=curTime	 						//OEORI_UpdateTime
	s PLIST(120)=userId 							//OEORI_UserAdd
	s PLIST(121)=userDeptId  						//OEORI_UserDepartment_DR
	s PLIST(141)=userId 							//OEORI_UserUpdate
	s PLIST(161)=$p($g(^PAADM(EpisodeID)),"^",4) 	//OEORI_AdmLoc_DR：病人科室
	s PLIST(53)=notes 								//OEORI_DepProcNotes
	s PLIST(50)=dayExecTimes 								//OEORI_Qty  首日次数
	i isRelate s PLIST(230)=relateOrdItemDr 		//OEORI_OEORI_DR  关联医嘱
	s PLIST(206)=1 									//OEORI_BBExtCode  1
	s PLIST(248)="N" 								//OEORI_NotifyClinician N
	
	//插入医嘱
	s ret=##class(appcom.OEOrdItem).Insert(oeordId,"Y",.PLIST)
	
	q ret
}

/// w ##class(web.DHCCLImportData).UpdateOrdItem("133||62","133||64")
/// 更新医嘱，主要更新关联医嘱
ClassMethod UpdateOrdItem(oeoriId As %String, relateOrdItemDr As %String) As %String
{
	set obj=##class(User.OEOrdItem).%OpenId(oeoriId)
	if '$IsObject(obj) Quit "-1^医嘱不存在"
	
	set seqNo=""
	if relateOrdItemDr'="" do
	. //获取当天医嘱序号
	.set lastSeqNo=$o(^OEORDi(0,"StDtSeqNo",+oeoriId,+$h,""),-1)
    .set lastSeqNo1=$p(lastSeqNo,".",1)
    .if lastSeqNo1'=+lastSeqNo1 set lastSeqNo1=+lastSeqNo1+1
    .set lastSeqNo2=$p(lastSeqNo,".",2)
    .set lastSeqNo2=+lastSeqNo2+1
    .set seqNo=lastSeqNo1_"."_lastSeqNo2
	
	&SQL(Update SQLUser.OE_OrdItem Set OEORI_OEORI_DR=:relateOrdItemDr,OEORI_SeqNo=:seqNo Where OEORI_RowId=:oeoriId )
	quit SQLCODE
}

/// w ##class(web.DHCCLImportData).GetRelateOrdItemId("52||4")
/// 获取医嘱的关联医嘱id,如果没有关联医嘱就返回空
ClassMethod GetRelateOrdItemId(oeoriId As %String) As %String
{
	set obj=##class(User.OEOrdItem).%OpenId(oeoriId)
	if '$IsObject(obj) Quit ""
	
	set relateId=""
	&sql(select OEORI_OEORI_DR into :relateId from SQLUser.OE_OrdItem where OEORI_RowId=:oeoriId)
	quit relateId
}

/// w ##class(web.DHCCLImportData).GetEqUomQty("1||1")
/// 获取医嘱缺省等效量
/// 返回：eqUomIdStr_"^"_eqDefDoseStr
/// 		等效剂量单位    医嘱缺省量
ClassMethod GetEqUomQty(arcimId As %String) As %String
{
	s eqUomIdStr="",eqDefDoseStr=1,baseUomId="",eqQtyStr=1,volume=1
	q:arcimId="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume
	s baseUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
	s eqUomIdStr=baseUomId
	s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
	q:phcdfId="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume
	s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
	q:phcdfSub="" eqUomIdStr_"^"_eqDefDoseStr_"^"_baseUomId_"^"_eqQtyStr_"^"_volume
	s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
	
	s volume=""
	s volUomId=$o(^CT("UOM",0,"Code","ML",""))
	s eqUomIdStr=baseUomId,eqQtyStr=1,eqDefDoseStr=1
	s eqId=0,haveData=0
	f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
		.s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
		.s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
		.s eqDefDose=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",3)
		.i eqQty=0 s eqQty=1
		.i $p(eqQty,".",1)="" s eqQty=0_eqQty
		.i $p(eqDefDose,".",1)="" s eqDefDose=0_eqDefDose
		.q:(eqUomId="")!(eqQty=0)
		.i +eqDefDose=0 s eqDefDose=eqQty
		.i 'haveData s eqUomIdStr="",eqQtyStr="",eqDefDoseStr=""
		.
		.i eqUomIdStr'="" s eqUomIdStr=eqUomIdStr_"|",eqQtyStr=eqQtyStr_"|",eqDefDoseStr=eqDefDoseStr_"|"
		.s eqUomIdStr=eqUomIdStr_eqUomId,eqQtyStr=eqQtyStr_eqQty,eqDefDoseStr=eqDefDoseStr_eqDefDose
		.i volUomId=eqUomId d
		    ..s volume=eqQty
		    ..i +volume=0 s volume=1
		.s haveData=1
	q eqUomIdStr_"^"_eqDefDoseStr
}

/// w ##class(web.DHCCLImportData).StopOrdItem("483||2",600)
/// 停医嘱
ClassMethod StopOrdItem(OrdItmRowId As %String, userId As %String, ExpectEndDate As %String = "", ExpectEndTime As %String = "")
{
	if ExpectEndDate="" s ExpectEndDate=+$h
	if ExpectEndTime="" s ExpectEndTime=$p($h,",",2)
	
	s CurrDate=$p($h,",",1)
	s CurrTime=$p($h,",",2)
	
	set obj=##class(User.OEOrdItem).%OpenId(OrdItmRowId)
	if '$IsObject(obj) Quit "-100"			   //医嘱不存在
	
	set StatusRowId=$O(^OEC("OSTAT",0,"Code","D",0))
	s err=##class(appcom.OEOrdItem).UpdateStatus(OrdItmRowId,userId,StatusRowId)
	&SQL(Update SQLUser.OE_OrdItem set OEORI_Xdate=:CurrDate,OEORI_Xtime=:CurrTime,OEORI_XCTCP_DR=:userId where OEORI_rowid=:OrdItmRowId)

	quit err
}

/// 执行医嘱
ClassMethod ExecOrdItem(OrdItmRowId As %String, userId As %String, execDate As %String = "")
{
	set obj=##class(User.OEOrdItem).%OpenId(OrdItmRowId)
	if '$IsObject(obj) Quit "-100^医嘱不存在"
	
	if execDate="" set execDate=+$h		
	
	quit:'$d(^SSU("SSUSR",userId)) "-1^用户不存在"
	set ctcpId=$p(^SSU("SSUSR",+userId),"^",14)  //医护人员id
	quit:ctcpId="" "-1^医护人员id不能为空"	   
	
	s err=0
		
	s StatusRowId=$O(^OEC("OSTAT",0,"Code","E",0))
	s Sub=0  
	f  s Sub=$O(^OEORD(+OrdItmRowId,"I",$P(OrdItmRowId,"||",2),"X",Sub)) Q:Sub=""  do
	.s rowid=OrdItmRowId_"||"_Sub
	.&SQL(Update SQLUser.OE_OrdExec Set OEORE_Order_Status_DR=:StatusRowId, OEORE_CTPCP_DR=:ctcpId Where OEORE_RowId=:rowid)
	.if SQLCODE s err=SQLCODE

	Quit err
}

/// w ##class(web.DHCCLImportData).IsDisconOrder("39||21")
/// 是否已经停了的医嘱
ClassMethod IsDisconOrder(OrdItmRowId As %String) As %String
{
	set obj=##class(User.OEOrdItem).%OpenId(OrdItmRowId)
	if '$IsObject(obj) Quit 0 
	
	set oecStatusId=$p(^OEORD(+OrdItmRowId,"I",$P(OrdItmRowId,"||",2),1),"^",13)
	if oecStatusId=$O(^OEC("OSTAT",0,"Code","D",0)) quit 1
	quit 0
}

/// w ##class(web.DHCCLImportData).GenOeordExec("39||21")
/// 产生医嘱执行记录
ClassMethod GenOeordExec(OrdItmRowId As %String, GenDate As %String = "") As %String
{
	if GenDate="" set GenDate=+$h
	
	set obj=##class(User.OEOrdItem).%OpenId(OrdItmRowId)
	if '$IsObject(obj) Quit "-1^医嘱不存在"
	
	d GenExe^DHCOEOrdExec(OrdItmRowId,GenDate)
	
	q 0
}

/// d ##class(web.DHCCLImportData).Log("Error","")
/// 日志
ClassMethod Log(type, value, date = "", time = "")
{
	i type="" s type="undefined"
	s date="" s date=$zd(+$h,3)
	s time="" s time=$zt($p($h,",",2))
	
	i $g(^tmpdebugNew(type,date,time))'="" d
	.s index=""
	.s index=+$O(^tmpdebugNew(type,date,time,index),-1)+1
	.s ^tmpdebugNew(type,date,time,index)=value
 	e  d
 	.s ^tmpdebugNew(type,date,time)=value
}

/// 记日志
///  LogType: 日志类型，可以为  Loc,CareProv,Arcim,Trans,Oeori,Lab,InOut
///  LogDesc: 日志的基本描述
///  LogSeq:  日志序号
///  LogContent: 日志的详细描述
///  LogStatus:  日志状态 ExternalError:程序错误
///              		  Error:数据错误
/// 					  Warning:警告
/// 					  Success:成功
/// 	do ##class(web.DHCCLImportData).LogNew("Loc","Test","1","测试下看行不行","Success")				
ClassMethod LogNew(LogType As %String, LogDesc As %String, LogSeq As %String, LogContent As %String, LogStatus As %String)
{
	set ret=##class(web.DHCCLMappingData).InsertLog(LogType,LogDesc,LogSeq,LogContent,LogStatus)
}

/// RowStr=LocCode_"^"_LocDesc_"^"_LocType_"^"_HospitalCode_"^"_LinkLoc_"^"_LocTel_"^"_LocContactName
/// w ##class(web.DHCCLImportData).ImportCtloc("",RowStr)
/// 导入科室
ClassMethod ImportCtloc(ChangeType As %String = "", RowStr As %String = "") As %String
{
	/*
	if ChangeType="Clear" do
	.K ^CTLOC,^PAWARD,^PAC("ADMLOC"),^PAC("PACWD")
	
	quit:ChangeType="Clear" "数据已清:科室和病区"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set LocCode=$p(RowStr,del,2), LocDesc=$p(RowStr,del,3), LocType=$p(RowStr,del,4)
	set HospitalCode=$p(RowStr,del,5), LinkLoc=$p(RowStr,del,6), LocTel=$p(RowStr,del,7)
	set LocContactName=$p(RowStr,del,8)
	
	quit:LocContactName="" "科室拼音码为空"
	set LocContactName=$$ALPHAUP^SSUTIL4(LocContactName)
	set LocDesc=$$ALPHAUP^SSUTIL4(LocDesc)
	set LocDesc=LocContactName_"-"_LocDesc
	
	quit:LocCode="" "科室代码为空"
	quit:$d(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode))) "科室代码已经存在:LocCode="_LocCode
	
	if $d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc))) set LocDesc=LocDesc_LocCode
	quit:LocDesc="" "科室名称为空"
	quit:$d(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LocDesc))) "科室名称已经存在:LocDesc="_LocDesc
	
	set wardFlag=""
	set LocType=$$ALPHAUP^SSUTIL4(LocType)
	set LocType=$select(LocType["WARD":"W",LocType["EXECUTE":"E",LocType["MEDICAL":"MR",LocType["OPERATION":"OP",LocType["CASHIER":"C",LocType["OTHER":"O",LocType["DISPENSING":"D",LocType["CLINIC":"CL",LocType["ROOM":"OR",1:"")
	if LocType="W" set wardFlag="Y"
	if LocType="" set LocType="O"
	
	set hospId=""
	if HospitalCode'="" set hospId=$o(^CT("HOSP",0,"Code",HospitalCode,0))
	
	TSTART
	k PLIST
	s PLIST(2)=$$ALPHAUP^SSUTIL4(LocCode)    				//CTLOC_Code
	s PLIST(3)=LocDesc 					//CTLOC_Desc
	s PLiST(7)=wardFlag					//CTLOC_WardFlag
	s PLIST(21)="Y"						//CTLOC_OwnQueFlag
	s PLIST(22)="Y"						//CTLOC_RecQueFlag
	s PLIST(27)=LocType					//CTLOC_Type
	s PLIST(42)="N"						//CTLOC_Laundry
	s PLIST(45)="Y"						//CTLOC_Index
	//s PLIST(46)=hospId				//CTLOC_Hospital_DR
	s PLIST(47)="Y"						//CTLOC_ExecuteConfirmation
	s PLIST(48)=+$h						//CTLOC_DateActiveFrom
	s PLIST(54)="Y"						//CTLOC_MedicalRecordActive
	s PLIST(68)=LocTel					//CTLOC_TelephoneExt
	s PLIST(70)=LocContactName			//CTLOC_ContactName
	
	&sql(INSERT INTO SQLUser.CT_Loc VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "插入科室表失败！！"
	set locId=$g(%ROWID)
	
	set isFail=0
	if wardFlag="Y" do
	.if $d(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(LocCode))) quit 
	.if $d(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(LocDesc))) quit
	.kill PLIST 
	.set PLIST(2)=$$ALPHAUP^SSUTIL4(LocCode)                  //WARD_Code
	.set PLIST(3)=LocDesc					                  //WARD_Desc
	.set PLIST(5)="N"                                         //WARD_SingleRoom
	.set PLIST(6)=locId                                       //WARD_LocationDR
	.set PLIST(7)="Y"                                         //WARD_Active
	.&sql(INSERT INTO SQLUser.PAC_Ward VALUES PLIST())
	.if SQLCODE'=0 set isFail=1
	
	if isFail=1 TRollBack
	quit:isFail=1 "插入病区表失败！！"
	
	TCOMMIT
    quit 0
    */
    q 0
}

/// w ##class(web.DHCCLImportData).SetLinkLoc(RowStr)
/// 设置关联科室，入参数据RowStr和导入科室的入参RowStr相同
/// 考虑到科室的相互关联，应该是先导入所有的科室，然后再设置关联科室
ClassMethod SetLinkLoc(RowStr As %String) As %String
{
	set RowStr=$tr(RowStr," ","")
	set LocCode=$p(RowStr,del,1)
	set LinkLocList=$p(RowStr,del,5)
	
	quit:LocCode="" "科室代码为空"
	quit:LinkLocList="" "关联科室为空"
	
	set locId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(LocCode),0))
	quit:locId="" "科室不存在"
	
	for i=1:1:$l(LinkLocList,"/") do
	.set LinkLoc=$p(LinkLocList,"/",i)
	.quit:LinkLoc=""
	.set linkLocId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(LinkLoc),0))
	.quit:linkLocId=""
	.quit:'$d(^CTLOC(linkLocId))
	.&SQL(INSERT INTO SQLUser.CT_LocLinkLocation(LINK_ParRef,LINK_CTLOC_DR) VALUES(:locId,:linkLocId))
	
	quit 0
}

/// RowStr=CtcpLocCode_"^"_CtcpLocDesc_"^"_CtcpCode_"^"_CtcpDesc_"^"_CtcpType_"^"_CtcpGroup_"^"_CtcpMark
/// w ##class(web.DHCCLImportData).ImportCtcp("",RowStr)
/// 导入医护人员
ClassMethod ImportCtcp(ChangeType As %String = "", RowStr As %String = "") As %String
{
	/*
	if ChangeType="Clear" do
	.Kill ^SSU("SSUSR"),^SST("LOG"),^CTPCP,^RB("RES"),^RBC("SER"),^User.DHCUserGroupD,^User.DHCUserGroupI,^User.DHCUserGroupS
	
	quit:ChangeType="Clear" "数据已清:医护人员和资源"
	
	set del="^"
	set RowStr=$tr(RowStr," ","")
	set CtcpLocCode=$p(RowStr,del,2), CtcpLocDesc=$p(RowStr,del,3), CtcpCode=$p(RowStr,del,4), CtcpDesc=$p(RowStr,del,5)
	set CtcpType=$p(RowStr,del,6), CtcpGroup=$p(RowStr,del,7), CtcpMark=$p(RowStr,del,8)
	
	quit:CtcpLocCode="" "科室代码不能为空"	
	set locId=$o(^CTLOC(0,"Code",$$ALPHAUP^SSUTIL4(CtcpLocCode),0))
	quit:locId="" "科室Id为空"
	
	quit:CtcpCode="" "医护人员代码为空"
	quit:CtcpDesc="" "医护人员姓名为空"
	
	quit:$d(^CTPCP(0,"Code",$$ALPHAUP^SSUTIL4(CtcpCode))) "医护人员已存在,CtcpCode="_CtcpCode
	
	if CtcpType="" set CtcpType="其他"
	quit:CtcpType="" "医护人员类型为空"
	set CtcpTypeDr=$o(^CT("CPT",0,"Desc",$$ALPHAUP^SSUTIL4(CtcpType),""))
	quit:CtcpTypeDr="" "医护人员类型错误:CtcpTypeDr="_CtcpType
	
	set groupDesc=""
	if CtcpGroup="" do
	.//漯河用
	.if CtcpCode["Y" set groupDesc="ICU医师"
	.if CtcpCode["H" set groupDesc="ICU护士"
	else  do
	.set groupDesc=CtcpGroup
	quit:groupDesc="" "安全组为空"
	set CtcpGroupDr=##class(web.DHCCLImportData).GetSSGroupDrByDesc(groupDesc)
	quit:CtcpGroupDr="" "安全组不对，groupDesc="_groupDesc
	
	TSTART
	kill PLIST
	set PLIST(2)=$$ALPHAUP^SSUTIL4(CtcpCode)						//CTPCP_Code
	set PLIST(3)=$$ALPHAUP^SSUTIL4(CtcpDesc)						//CTPCP_Desc
	set PLIST(4)=$$ALPHAUP^SSUTIL4(CtcpCode)						//CTPCP_Id
	set PLIST(7)=CtcpTypeDr                  						//CTPCP_CarPrvTp_DR
	set PLIST(25)="Y"                  						        //CTPCP_ActiveFlag
	set PLIST(28)=1                  						        //CTPCP_VersionNumber
	set PLIST(38)=+$h                 						        //CTPCP_DateActiveFrom
	set PLIST(73)=$$ALPHAUP^SSUTIL4(CtcpMark)                		//CTPCP_OtherName
	set PLIST(76)="N"                								//CTPCP_HICApproved
	&sql(INSERT INTO SQLUser.CT_CareProv VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "-1^插入医护人员表失败！！SQLCODE="_SQLCODE
	set CtcpId=$g(%ROWID)
	
	kill PLIST
	set PLIST(2)=$$ALPHAUP^SSUTIL4(CtcpCode)						//SSUSR_Initials
	set PLIST(3)=$$ALPHAUP^SSUTIL4(CtcpDesc)						//SSUSR_Name
	set PLIST(4)="U&dDF1,""7k7k"						            //SSUSR_Password
	set PLIST(7)=locId						            			//SSUSR_DefaultDept_DR
	set PLIST(13)=CtcpGroupDr						            	//SSUSR_Group
	set PLIST(14)="Y"						            			//SSUSR_ChangeLocation
	set PLIST(17)=20						            			//SSUSR_CTLAN_DR
	set PLIST(18)=CtcpId						            		//SSUSR_CareProv_DR
	set PLIST(19)="U&dDF1,""7k7k"						            //SSUSR_Pin
	set PLIST(103)=+$h						            			//SSUSR_DateFrom
	&sql(INSERT INTO SQLUser.SS_User VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "-2^插入用户表失败！！SQLCODE="_SQLCODE
	
	kill PLIST
	set PLIST(3)=locId												//RES_CTLOC_DR
	set PLIST(4)=CtcpId												//RES_CTPCP_DR
	set PLIST(7)=$$ALPHAUP^SSUTIL4(CtcpCode)						//RES_Code
	set PLIST(8)=$$ALPHAUP^SSUTIL4(CtcpDesc)						//RES_Desc
	set PLIST(21)="Y"												//RES_MRRequest
	&sql(INSERT INTO SQLUser.RB_Resource VALUES PLIST())
	if SQLCODE'=0  TRollBack
	quit:SQLCODE "-3^插入资源表失败！！SQLCODE="_SQLCODE
	
	TCOMMIT
	*/
    quit 0
}

/// w ##class(web.DHCCLImportData).GetSSGroupDrByDesc("ICU医师")
/// 根据安全组描述获取安全组Id
ClassMethod GetSSGroupDrByDesc(GroupDesc As %String) As %String
{
	quit:GroupDesc="" ""
	set GroupDr=""
	set RowId=0
	for  set RowId=$o(^SSU("SSGRP",RowId)) quit:RowId=""  do
	.set desc=$p($g(^SSU("SSGRP",RowId)),"^",1)
	.if GroupDesc=desc set GroupDr=RowId
	
	quit GroupDr
}

/// RowStr=ArcimCode_"^"_ArcimDesc_"^"_ArcimGenericDesc_"^"_ArcimAlia_"^"_ArcimUom_"^"_
/// 		   ArcimEqualQty_"^"_ArcimEqualUom_"^"_ArcimDefaultQty_"^"_ArcimControlCat_"^"_
/// 		   ArcimSubCat_"^"_ArcimPHCSubCat_"^"_ArcimPHCForm_"^"_ArcimPHCSpec
/// w ##class(web.DHCCLImportData).ImportArcim("",RowStr)
/// 导入医嘱项
ClassMethod ImportArcim(ChangeType As %String = "", RowStr As %String = "") As %String
{
	/*
	if ChangeType="Clear"  do
	.kill ^ARCIM,^ARC("ALIAS"),^ARC("KEYW")
	.kill ^DHCTARI,^DHCTARIi,^mdata("DHCTARITEM"),^DHCTARAL,^mdata("DHCTARITEMALIAS")
	.kill ^DHCOLT,^mdata("DHCORDERLINKTAR"),^DHCTARF,^mdata("DHCTARFACTOR")
	.kill ^PHCGE("GE")
	.kill ^PHCD

	quit:ChangeType="Clear" "数据已清:医嘱项"
	
	set ArcimDesc=$p(RowStr,"^",3)
	
	set RowStr=$tr(RowStr," ","")
	set ArcimCode=$p(RowStr,"^",2), ArcimGenericDesc=$p(RowStr,"^",4)
	set ArcimAlia=$p(RowStr,"^",5), ArcimUom=$p(RowStr,"^",6), ArcimEqualQty=$p(RowStr,"^",7)
	set ArcimEqualUom=$p(RowStr,"^",8), ArcimDefaultQty=$p(RowStr,"^",9), ArcimControlCat=$p(RowStr,"^",10)
	set ArcimSubCat=$p(RowStr,"^",11), ArcimPHCSubCat=$p(RowStr,"^",12), ArcimPHCForm=$p(RowStr,"^",13)
	set ArcimPHCSpec=$p(RowStr,"^",14)
	
	if ArcimCode="" quit "医嘱项代码为空:"
    if ArcimDesc="" quit "医嘱项名称为空:"
    if (ArcimCode'="")&($d(^ARCIM(0,"Code",$$ALPHAUP^SSUTIL4(ArcimCode)))) quit "医嘱项代码已存在"
    set num=1
    set desc=ArcimDesc
    while (ArcimDesc'="")&($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(ArcimDesc))))
    {
	    set ArcimDesc=desc_num
	    set num=num+1
	}
    if (ArcimDesc'="")&($d(^ARCIM(0,"Desc",$$ALPHAUP^SSUTIL4(ArcimDesc)))) quit "医嘱项名称已存在"
    
    set ArcimSubCatDefVal="其它" //医嘱项子分类,如果为空，则取一个默认值，这里是漯河中心医院用的
    if ArcimSubCat="" set ArcimSubCat=ArcimSubCatDefVal  
    set ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcimSubCat),"")) 
    if ArcSubCatDr="" set ArcSubCatDr=$o(^ARC("IC",0,"Desc",$$ALPHAUP^SSUTIL4(ArcimSubCatDefVal),""))  
    quit:ArcSubCatDr="" "医嘱项子分类不存在"
    
    //帐单子组指针
    set BillSubGrpDefVal="西药费"
    set BillGrpDr=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(BillSubGrpDefVal),""))
    set BillSubGrpDr=$o(^ARCBG("SG_Desc",$$ALPHAUP^SSUTIL4(BillSubGrpDefVal),BillGrpDr,""))
    set BillSubGrpDr=BillGrpDr_"||"_BillSubGrpDr
    quit:BillSubGrpDr="" "帐单子组不存在"
    
    quit:ArcimUom="" "药品单位为空"
    set TarUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(ArcimUom),""))
    quit:TarUomDr="" "药品单位不正确"
    
    quit:ArcimEqualUom="" "药品等效单位为空"
    set EqualUomDr=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(ArcimEqualUom),""))
    quit:EqualUomDr="" "药品等效单位不正确"
    
    quit:ArcimEqualQty="" "药品等效剂量不正确"
    
    set PHCFormDefVal="片剂"
    if ArcimPHCForm="" set ArcimPHCForm=PHCFormDefVal
    set PHCFormDr=$o(^PHCF(0,"Desc",$$ALPHAUP^SSUTIL4(ArcimPHCForm),""))
    if PHCFormDr="" set PHCFormDr=$o(^PHCF(0,"Desc",$$ALPHAUP^SSUTIL4(PHCFormDefVal),""))
    quit:PHCFormDr="" "剂型不正确"
    
    TSTART 
    //set code=$$ALPHAUP^SSUTIL4(ArcimDesc)_$$ALPHAUP^SSUTIL4(ArcimCode)
    set PHCGEName=$$ALPHAUP^SSUTIL4(ArcimDesc)
    set PHCGECode=$$ALPHAUP^SSUTIL4(ArcimCode)
    set PHCGEDateFrom=+$h-1
    &SQL(INSERT INTO SQLUser.PHC_Generic(PHCGE_Name,PHCGE_Code,PHCGE_DateFrom) VALUES (:PHCGEName,:PHCGECode,:PHCGEDateFrom))
    i SQLCODE'=0  TRollBack  
    q:SQLCODE "-1^插入药品简称表错误,"_SQLCODE
    set GenericDR=$g(%ROWID)
    
    kill PLIST
    set PLIST(2)=$$ALPHAUP^SSUTIL4(ArcimDesc)   			//PHCD_Name
    set PLIST(5)="95||1"   					  				//PHCD_PHCSC_DR 默认为 待完善
    set PLIST(15)=$$ALPHAUP^SSUTIL4(ArcimCode)   			//PHCD_Code
    set PLIST(18)="95||1||1"   								//PHCD_MinSubCat_DR
    set PLIST(19)=+$h   								    //PHCD_UpdateDate
    set PLIST(20)=$p($h,",",2)   						    //PHCD_UpdateTime
    set PLIST(22)=GenericDR   						    	//PHCD_Generic_DR
    set PLIST(23)=$$ALPHAUP^SSUTIL4(ArcimPHCSpec)   		//PHCD_OfficialCode
    &SQL(INSERT INTO SQLUser.PHC_DrgMast VALUES PLIST())
    i SQLCODE'=0  TRollBack  
    q:SQLCODE "-2^插入剂型表父表错误,"_SQLCODE
    set DrgMastDr=$g(%ROWID)
    
    set ParRef=DrgMastDr   			    //PHCDF_PHCD_ParRef
    set PHCFDR=PHCFormDr   			    //PHCDF_PHCF_DR
    set PHCINDR=2   					//PHCDF_PHCIN_DR  用法默认为口服
    set PHCDUDR=63   					//PHCDF_PHCDU_DR  频次默认为1天
    set CTUOMDR=TarUomDr   			    //PHCDF_CTUOM_DR
    set BaseQty=1   		            //PHCDF_BaseQty
    set UpdateDate=+$h   			    //PHCDF_UpdateDate
    set UpdateTime=$p($h,",",2)   		//PHCDF_UpdateTime
    &SQL(INSERT INTO SQLUser.PHC_DrgForm(PHCDF_PHCD_ParRef,PHCDF_PHCF_DR,PHCDF_PHCIN_DR,PHCDF_PHCDU_DR,PHCDF_CTUOM_DR,PHCDF_BaseQty,PHCDF_UpdateDate,PHCDF_UpdateTime) VALUES (:ParRef,:PHCFDR,:PHCINDR,:PHCDUDR,:CTUOMDR,:BaseQty,:UpdateDate,:UpdateTime))
    i SQLCODE'=0  TRollBack  
    q:SQLCODE "-3^插入剂型表错误,"_SQLCODE
    set PHCDFDR=$g(%ROWID)
    
    //插入等效单位(PHC_DrgForm子表)
    set ParRef=PHCDFDR							 //EQ_ParRef
    set EQCTUOMDR=EqualUomDr                     //EQ_CTUOM_DR
    set EQQty=ArcimEqualQty                      //EQ_Qty
    set EQDefaultDose=ArcimEqualQty              //EQ_DefaultDose
    &SQL(INSERT INTO SQLUser.PHC_FormDoseEquiv(EQ_ParRef,EQ_CTUOM_DR,EQ_Qty,EQ_DefaultDose) VALUES (:PHCDFDR,:EqualUomDr,:ArcimEqualQty,:ArcimEqualQty))
    i SQLCODE'=0  TRollBack  
    q:SQLCODE "-4^插入等效单位表错误"
    
    kill PLIST
    set PLIST(2)=ArcimCode   			//ARCIM_Code
    set PLIST(3)=ArcimDesc	 			//ARCIM_Desc
    set PLIST(4)=1		          		//ARCIM_Abbrev
    set PLIST(8)=1                      //ARCIM_ChgUnitFact
    set PLIST(9)=ArcSubCatDr            //ARCIM_ItemCat_DR
    set PLIST(23)="I"                   //ARCIM_ChgDispFlg
    set PLIST(24)="O"                   //ARCIM_ChgPostFlg
    set PLIST(43)="N"                   //ARCIM_ProfileFlg
    set PLIST(44)="N"                   //ARCIM_SubMasFlg
    set PLIST(47)=BillSubGrpDr          //ARCIM_BillSub_DR
    set PLIST(51)=PHCDFDR               //ARCIM_PHCDF_DR
    set PLIST(54)="1"                   //ARCIM_Version
    set PLIST(76)="S"					//ARCIM_ServMaterial
    set PLIST(83)="Y"                   //ARCIM_OrderOnItsOwn
    set PLIST(89)=+$h                   //ARCIM_UpdateDate
    set PLIST(90)=$p($h,",",2)          //ARCIM_UpdateTime
    set PLIST(105)=TarUomDr             //ARCIM_BillingUOM_DR
    set PLIST(112)=$$ALPHAUP^SSUTIL4(ArcimGenericDesc)          //ARCIM_GenericDesc
    set PLIST(114)=ArcimGenericDesc     //ARCIM_ShortDesc 
    
    &SQL(INSERT INTO SQLUser.ARC_ItmMast VALUES PLIST())
    i SQLCODE'=0  TRollBack  
    q:SQLCODE "-5^插入医嘱项表错误"
    
    TCOMMIT
    */
    quit 0
}

ClassMethod RetErrorValue(RetStr As %String = "", ErrorStr As %String = "") As %String
{
	if RetStr="" d
	.s:ErrorStr'="" RetStr=ErrorStr
	else  d
	.s:ErrorStr'="" RetStr=RetStr_"@"_"   "_ErrorStr
	q RetStr
}

/// w ##class(web.DHCCLImportData).SavePatMapped("13","0235528")
/// 病人Id映射
ClassMethod SavePatMapped(PAPMIDr As %String, PatientNo As %String) As %String
{
	set patID=""
	&sql(select CLMPAPMI_MappedPatientNo into :patID from SQLUser.DHC_CL_MappedPatMaster where CLMPAPMI_PAPMI_Dr=:PAPMIDr)
	
	if (patID="")
	{
		&sql(insert into SQLUser.DHC_CL_MappedPatMaster(CLMPAPMI_PAPMI_Dr,CLMPAPMI_MappedPatientNo) values(:PAPMIDr,:PatientNo) )
	}
	else
	{
		&sql(update SQLUser.DHC_CL_MappedPatMaster set CLMPAPMI_MappedPatientNo=:PatientNo where CLMPAPMI_PAPMI_Dr=:PAPMIDr )
	}
	
	Quit SQLCODE
}

/// w ##class(web.DHCCLImportData).GetPatientIDByPAPMIDr("13")
ClassMethod GetPatientIDByPAPMIDr(PAPMIDr As %String) As %String
{
	set patID=""
	&sql(select CLMPAPMI_MappedPatientNo into :patID from SQLUser.DHC_CL_MappedPatMaster where CLMPAPMI_PAPMI_Dr=:PAPMIDr)
	q patID
}

/// w ##class(web.DHCCLImportData).GetPAPMIDrByPatientID("0235529")
ClassMethod GetPAPMIDrByPatientID(PatientNo As %String) As %String
{
	set papmiDr=""
	&sql(select CLMPAPMI_PAPMI_Dr into :papmiDr from SQLUser.DHC_CL_MappedPatMaster where CLMPAPMI_MappedPatientNo=:PatientNo)
	q papmiDr
}

/// w ##class(web.DHCCLImportData).SavePaAdmMapped("149","0292001")
/// 就诊号映射
ClassMethod SavePaAdmMapped(PaadmDr As %String, MappedAdmNo As %String) As %String
{
	set admNo=""
	&sql(select CLMPAADM_MappedAdmNo into :admNo from SQLUser.DHC_CL_MappedPaAdm where CLMPAADM_Adm_Dr=:PaadmDr )
	
	if (admNo="")
	{
		&sql(insert into SQLUser.DHC_CL_MappedPaAdm(CLMPAADM_Adm_Dr,CLMPAADM_MappedAdmNo) values(:PaadmDr,:MappedAdmNo) )
	}
	else
	{
		&sql(update SQLUser.DHC_CL_MappedPaAdm set CLMPAADM_MappedAdmNo=:MappedAdmNo where CLMPAADM_Adm_Dr=:PaadmDr )
	}
	quit SQLCODE
}

/// w ##class(web.DHCCLImportData).GetMappedAdmNoByAdmDr("149")
ClassMethod GetMappedAdmNoByAdmDr(PaadmDr As %String) As %String
{
	set MappedAdmNo=""
	&sql(select CLMPAADM_MappedAdmNo into :MappedAdmNo from SQLUser.DHC_CL_MappedPaAdm where CLMPAADM_Adm_Dr=:PaadmDr)
	q MappedAdmNo
}

/// w ##class(web.DHCCLImportData).GetAdmDrByMappedAdmNo("0292001")
ClassMethod GetAdmDrByMappedAdmNo(MappedAdmNo As %String) As %String
{
	set AdmDr=""
	&sql(select CLMPAADM_Adm_Dr into :AdmDr from SQLUser.DHC_CL_MappedPaAdm where CLMPAADM_MappedAdmNo=:MappedAdmNo)
	q AdmDr
}

/// 医嘱Id映射和医嘱执行Id映射
/// 医嘱与医嘱执行的区别在于“||”有几个，医嘱是一个，医嘱执行是两个
/// w ##class(web.DHCCLImportData).SaveOEOrdExecMapped("21","14695291")
ClassMethod SaveOEOrdExecMapped(OEOrdExecDr As %String, MappedOeoreNo As %String) As %String
{
	set execNo=""
	&sql(select CLMOEORE_MappedOeoreNo into :execNo from SQLUser.DHC_CL_MappedOEOrdExec where CLMOEORE_OEOrdExec_Dr=:OEOrdExecDr)
	
	if (execNo="")
	{
		&sql(insert into SQLUser.DHC_CL_MappedOEOrdExec(CLMOEORE_OEOrdExec_Dr,CLMOEORE_MappedOeoreNo) values(:OEOrdExecDr,:MappedOeoreNo))
	}
	else
	{
		&sql(update SQLUser.DHC_CL_MappedOEOrdExec set CLMOEORE_MappedOeoreNo=:MappedOeoreNo where CLMOEORE_OEOrdExec_Dr=:OEOrdExecDr )
	}
	quit SQLCODE
}

/// w ##class(web.DHCCLImportData).GetMappedOeoreNoByOEOrdExecDr("21")
ClassMethod GetMappedOeoreNoByOEOrdExecDr(OEOrdExecDr As %String) As %String
{
	set MappedOeoreNo=""
	&sql(select CLMOEORE_MappedOeoreNo into :MappedOeoreNo from SQLUser.DHC_CL_MappedOEOrdExec where CLMOEORE_OEOrdExec_Dr=:OEOrdExecDr)
	quit MappedOeoreNo
}

/// w ##class(web.DHCCLImportData).GetOEOrdExecDrByMappedOeoreNo("14695291")
ClassMethod GetOEOrdExecDrByMappedOeoreNo(MappedOeoreNo As %String)
{
	set OEOrdExecDr=""
	&sql(select CLMOEORE_OEOrdExec_Dr into :OEOrdExecDr from SQLUser.DHC_CL_MappedOEOrdExec where CLMOEORE_MappedOeoreNo=:MappedOeoreNo)
	quit OEOrdExecDr
}

/// w ##class(web.DHCCLImportData).GetUserIdByCtcpId("378")
/// 通过医护人员Id获取对应的UserId
ClassMethod GetUserIdByCtcpId(ctcpId As %String) As %String
{
	set result=""
	
	set userId=""
	for  set userId=$o(^SSU("SSUSR",userId)) q:userId=""  d
	.set id=$p(^SSU("SSUSR",userId),"^",14)
	.if id=ctcpId set result=userId
	
	q result
}

/// w ##class(web.DHCCLImportData).GetBedIdByWardIdAndBedCode(1,"+1床")
/// 通过病区Id和床位号来获取床位Id
ClassMethod GetBedIdByWardIdAndBedCode(wardId As %String, bedCode As %String) As %String
{
	set result=""
	
	q:bedCode="" ""
	q:wardId="" ""
	q:'$d(^PAWARD(wardId)) ""
	set bedId=""
	for  set bedId=$o(^PAWARD(wardId,"BED",bedId)) quit:bedId=""  d
	.set code=$p(^PAWARD(wardId,"BED",bedId),"^",1)
	.if code=bedCode set result=bedId
	
	q:result="" ""
	
	q wardId_"||"_result
}

/// w ##class(web.DHCCLImportData).GetArcimIdByCode("042317")
/// 通过医嘱码Code取医嘱码Id
ClassMethod GetArcimIdByCode(arcimCode As %String) As %String
{
	q:arcimCode="" ""
	
	set arcimId=""
	
	set sub="",ver=""
	for  set sub=$o(^ARCIM(0,"Code",arcimCode,sub)) quit:sub=""  d
	.for  set ver=$o(^ARCIM(0,"Code",arcimCode,sub,ver)) quit:ver=""  d
	..if (sub'="")&(ver'="") set arcimId=sub_"||"_ver
	
	q arcimId
}

/// w ##class(web.DHCCLImportData).ClearData("Clear")
/// 清除业务数据
ClassMethod ClearData(ChangeType As %String) As %String
{
	/*
	//清除病人信息
	if ChangeType="Clear" d
	.//清除病人信息
	.kill ^DHCCARDi,^DHCCARD,^PAPERi,^PAPER,^DHCACD,^DHCACDi,^User.DHCAccManagerS,^mdata("DHCACCMANAGER")
	.//清除就诊信息
	.kill ^PAADM,^PAADMi
	.
	.&sql(delete from SQLUser.PAC_WardAdm)
	.&sql(delete from SQLUser.PAC_BedAdm)
	
	if ChangeType="Clear" d
	.;清医嘱,在Kill整个^OEORD,^OEORI清除不了的情况下执行
	.kill ^OEORDi,^OEORDi(0)
	.set ord=0
	.for  s ord=$O(^OEORD(ord)) Q:ord=""  d
	..kill ^OEORD(ord)
	.kill ^OEORD(0)
	
	
	if ChangeType="Clear" d
	.&sql(delete from SQLUser.DHC_CL_MappedPaAdm)
	.&sql(delete from SQLUser.DHC_CL_MappedPatMaster)
	.&sql(delete from SQLUser.DHC_CL_MappedOEOrdExec)
	
	if ChangeType="Clear" d
	.kill ^tmpdebug
	.kill ^tmpInsertOeordItem
	.kill ^tmpTransAdm
	.kill ^tmp("RelateOrd")
	.kill ^tmp("transId")
	*/
	q 0
}

/// w ##class(web.DHCCLImportData).SaveMrcidDesc("131","脑挫裂伤")
/// 保存诊断
ClassMethod SaveMrcidDesc(EpisodeID As %String, MrcidDesc As %String) As %String
{
	quit:EpisodeID="" "-1"
	quit:MrcidDesc="" "-2"
	quit:$g(^tmpMrcidDesc(EpisodeID))=MrcidDesc "-3"
	
	set ^tmpMrcidDesc(EpisodeID)=MrcidDesc
	quit 0
}

/// w ##class(web.DHCCLImportData).GetMrcidDesc("131")
/// 获取诊断
ClassMethod GetMrcidDesc(EpisodeID As %String) As %String
{
	quit:EpisodeID="" ""
	quit $g(^tmpMrcidDesc(EpisodeID))
}

/// w ##class(web.DHCCLImportData).GetSplitChar()
/// 获取分割字符
ClassMethod GetSplitChar() As %String
{
	quit "^"
}

/// w ##class(web.DHCCLImportData).SaveLabSpecimen("Blood","全血")
/// 保存检验标本类型，如：全血，尿等
ClassMethod SaveLabSpecimen(STCode As %String, STDesc As %String) As %String
{
	quit:(STCode="")!(STDesc="") ""
	
	set RowId=##class(web.DHCCLImportData).GetSpecimenRowIdByCode(STCode)
	
	if RowId=""
	{
		&sql(insert into SQLUser.DHC_CLC_LabSpecimen(CLCLST_Code,CLCLST_Desc) values(:STCode,:STDesc))
	}
	else
	{
		&sql(update SQLUser.DHC_CLC_LabSpecimen set CLCLST_Desc=:STDesc where CLCLST_Code=:STCode)
	}
	
	quit SQLCODE
}

/// w ##class(web.DHCCLImportData).GetSpecimenRowIdByCode("Blood")
/// 通过标本类型代码查询检验标本类型RowId
ClassMethod GetSpecimenRowIdByCode(STCode As %String) As %String
{
	set RowId=""
	&sql(select CLCLST_RowId into :RowId from SQLUser.DHC_CLC_LabSpecimen where CLCLST_Code=:STCode)
	quit RowId
}

/// w ##class(web.DHCCLImportData).SaveLabTestCode("WBC","白细胞","WBC","WBC")
/// 保存检验项目
ClassMethod SaveLabTestCode(TCCode As %String, TCDesc As %String, TCAbbrev As %String, TCStandardCode As %String) As %String
{
	quit:(TCCode="")!(TCDesc="")!(TCStandardCode="") ""
	
	set RowId=##class(web.DHCCLImportData).GetLabTestRowIdByCode(TCCode)
	if RowId=""
	{
		&sql(insert into SQLUser.DHC_CLC_LabTestCode(CLCLTC_Code,CLCLTC_Desc,CLCLTC_Abbrev,CLCLTC_StandardCode) values (:TCCode,:TCDesc,:TCAbbrev,:TCStandardCode))
	}
	else
	{
		&sql(update SQLUser.DHC_CLC_LabTestCode set CLCLTC_Desc=:TCDesc,CLCLTC_Abbrev=:TCAbbrev,CLCLTC_StandardCode=:TCStandardCode where CLCLTC_Code=:TCCode)
	}
	quit SQLCODE
}

/// w ##class(web.DHCCLImportData).GetLabTestRowIdByCode("WBC")
/// 根据检验项目代码获取检验项目RowId
ClassMethod GetLabTestRowIdByCode(TCCode As %String) As %String
{
	set RowId=""
	&sql(select CLCLTC_RowId into :RowId from SQLUser.DHC_CLC_LabTestCode where CLCLTC_Code=:TCCode)
	quit RowId
}

ClassMethod SaveLabInfo(RowId, LabResultNo, PaadmDr, OeoriNo, LabNo, SpecimenDr, TestCodeDr, TestCodeDesc, CollectDate, CollectTime, ReceivedDate, ReceivedTime, ResultDate, ResultTime, TestResult, TestResultUnitCode, TestResultRange, TestConclusion, MicroorganismType, LabLocCode) As %String
{
	quit:LabResultNo="" "-1^LabResultNo为空"
	quit:PaadmDr="" "-2^PaadmDr为空"
	quit:OeoriNo="" "-3^OeoriNo为空"
	quit:LabNo="" "-4^LabNo为空"
	quit:SpecimenDr="" "-5^SpecimenDr为空"
	quit:TestCodeDr="" "-6^TestCodeDr为空"
	quit:TestCodeDesc="" "-7^TestCodeDesc为空"
	quit:ReceivedDate="" "-8^ReceivedDate为空"
	quit:ReceivedTime="" "-9^ReceivedTime为空"
	quit:TestResult="" "-10^TestResult为空"
	//quit:TestResultUnitCode="" "-11^TestResultUnitCode为空"
	quit:LabLocCode="" "-12^LabLocCode为空"
	
	
	quit:'$d(^PAADM(PaadmDr)) "-13^病人就诊号不存在,PaadmDr="_PaadmDr
	quit:'##class(User.DHCCLCLabSpecimen).%ExistsId(SpecimenDr) "-14^标本类型不存在,SpecimenDr="_SpecimenDr
	quit:'##class(User.DHCCLCLabTestCode).%ExistsId(TestCodeDr) "-15^检验项目不存在,TestCodeDr="_TestCodeDr
	
	set CLLabResultObj=""
	if (+RowId>0)
	{
		set CLLabResultObj=##class(User.DHCCLLabResult).%OpenId(RowId)
	}
	else
	{
		set CLLabResultObj=##class(User.DHCCLLabResult).%New()
	}
	set CLLabResultObj.CLLRLabResultNo=LabResultNo
	set CLLabResultObj.CLLRPaadmDr=PaadmDr
	set CLLabResultObj.CLLROeoriNo=OeoriNo
	set CLLabResultObj.CLLRLabNo=LabNo
	set CLLabResultObj.CLLRSpecimenDr=##class(User.DHCCLCLabSpecimen).%OpenId(SpecimenDr)
	set CLLabResultObj.CLLRTestCodeDr=##class(User.DHCCLCLabTestCode).%OpenId(TestCodeDr)
	set CLLabResultObj.CLLRTestCodeDesc=TestCodeDesc
	set CLLabResultObj.CLLRCollectDate=CollectDate
	set CLLabResultObj.CLLRCollectTime=CollectTime
	set CLLabResultObj.CLLRReceivedDate=ReceivedDate
	set CLLabResultObj.CLLRReceivedTime=ReceivedTime
	set CLLabResultObj.CLLRResultDate=ResultDate
	set CLLabResultObj.CLLRResultTime=ResultTime
	set CLLabResultObj.CLLRTestResult=TestResult
	set CLLabResultObj.CLLRTestResultUnitCode=TestResultUnitCode
	set CLLabResultObj.CLLRTestResultRange=TestResultRange
	set CLLabResultObj.CLLRTestConclusion=TestConclusion
	set CLLabResultObj.CLLRMicroorganismType=MicroorganismType
	set CLLabResultObj.CLLRLabLocCode=LabLocCode
	
	set status=CLLabResultObj.%Save()
	
	set result=""
	if ($System.Status.IsOK(status))
	{
		set result=CLLabResultObj.%Id()	
	}
	else
	{
		set result=$System.Status.GetErrorText(status)	
	}
	
	quit result
}

/// w ##class(web.DHCCLImportData).GetLabRowIdByLabNo("20160530MY_I10006003BNP")
ClassMethod GetLabRowIdByLabNo(LabNo As %String) As %String
{
	quit:LabNo="" ""
	quit $o(^DHCCLLabResult(0,"LabResultNo",LabNo,""))
}

/// 根据就诊号、登记号或科室的化验项目标准码standardCode，取检验结果,ifSingle=1取最新值
/// 返回值：多个结果以~分割,每个以"\"分割：检验值，单位，检验正常值范围，标本接受日期，标本接受时间，检验代码
/// w ##class(web.DHCCLImportData).GetTestResult("8805","","","WBC","","","","")
///    endDate有11天滞后
ClassMethod GetTestResult(needEpisodeID, regNoList, ctlocId, standardCode, startDate, startTime, endDate, endTime, ifSingle = 0, needNote = "", dataField = "") As %String
{
	quit:needEpisodeID="" ""
	quit:'$d(^PAADM(needEpisodeID)) ""
	
	quit:standardCode="" ""
	
	set startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	set startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	set endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	set endTime=##class(web.DHCClinicCom).ConvertToTimeH(endTime)
	
	set testCodeRowidStr=""
	set rowId=""
	for  set rowId=$o(^DHCCLC("LabTestCode",rowId)) quit:rowId=""  do
	.set CLCLTCStandardCode=$list(^DHCCLC("LabTestCode",rowId),4)
	.if CLCLTCStandardCode=standardCode do
	..if testCodeRowidStr="" set testCodeRowidStr=rowId
	..else  set testCodeRowidStr=testCodeRowidStr_"^"_rowId
	
	set retStr=""
	for i=1:1:$l(testCodeRowidStr,"^") do
	.set testCodeRowId=$p(testCodeRowidStr,"^",i)
	.quit:testCodeRowId=""
	.set ifFind=0
	.set count=0
	.set date=endDate+11 //允许十天滞后
	.for  set date=$o(^DHCCLLabResult(0,"TestCodeDate",needEpisodeID,testCodeRowId,date),-1) quit:(date="")!(date<startDate)!(ifFind)  do
	..set labResultRowId=""
	..for  set labResultRowId=$o(^DHCCLLabResult(0,"TestCodeDate",needEpisodeID,testCodeRowId,date,labResultRowId)) quit:(labResultRowId="")  do
	...set receiveDate=$list(^DHCCLLabResult(labResultRowId),10)
	...set receiveTime=$list(^DHCCLLabResult(labResultRowId),11)
	...quit:(receiveDate=startDate)&(receiveTime<startTime)
	...quit:(receiveDate>endDate)!((receiveDate=endDate)&(receiveTime>endTime))
	...set result=$list(^DHCCLLabResult(labResultRowId),14)
	...set unit=$list(^DHCCLLabResult(labResultRowId),15)
	...set range=$list(^DHCCLLabResult(labResultRowId),16)
	...set testCode=$list(^DHCCLC("LabTestCode",testCodeRowId),1)
	...set conclusion=$list(^DHCCLLabResult(labResultRowId),17)
	...set microorganismType=$list(^DHCCLLabResult(labResultRowId),18)
	...set labLocCode=$list(^DHCCLLabResult(labResultRowId),19)
	...set ret=result_"\"_unit_"\"_range_"\"_receiveDate_"\"_receiveTime_"\"_testCode
	...set count=count+1
	...if retStr="" set retStr=ret
	...else  set retStr=retStr_"~"_ret
	...if ((dataField="")||(dataField="First"))&(ifSingle)&(count>0) set ifFind=1
	
	quit retStr
}

}
