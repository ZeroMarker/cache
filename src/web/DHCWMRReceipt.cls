Import SQLUser

/// 接诊 病案号分配
/// by wuqk 2007-04
/// Modify by 2007-05-22  for Structure Rebuild
Class web.DHCWMRReceipt Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 145;

/// *****************************************************************
/// 事务           :  Receipt
/// 功能描述       ： 接诊 
///                   生成病案信息 
///                   生成卷信息 
///                   更新病案号码发放 
///                   更新入院时情况
/// by wuqk 2007-04
/// 入参           ：
///   MrType       ： 病案类型
///   papmi        ： Pa_PatMas.Rowid
///   paadm        ： 本次就诊 Pa_adm.Rowid
///   MainRowid    :  DHC_WMR_Main.Rowid 使用旧号码  如为空，则分配新号码
///   ctloc        ： 接诊室 Ct_Loc.Rowid
///   NameSpell    :  病人姓名的拼音
///   patcond      :  入院时情况  MRC_PatientCondition.Rowid
///   OldNo        :  分配一个未入库的历史号码
///   UserId       ： 接诊操作员Rowid   
/// 返回值         ： ret=VolRowid 成功    ret<0 失败
/// debug:w ##Class(web.DHCWMRReceipt).Receipt(7,143768,77377,"",230,"CESHI",1,500072,641)
/// *****************************************************************
ClassMethod Receipt(MrType, papmi, paadm, MainRowid, ctloc, NameSpell, patcond, OldNo, UserId)
{
	n (MrType,papmi,paadm,MainRowid,ctloc,NameSpell,patcond,OldNo,UserId)
	;s ^CacheTemp("Receipt")=MrType_","_papmi_","_paadm_","_MainRowid_","_ctloc_","_NameSpell_","_patcond_","_OldNo_","_UserId
	s ret=-1,IsHavNo="Y"
	;Set:OldNo="" IsHavNo="N"
	q:(MrType="")||(papmi="")||(paadm="") ret
	q:(MainRowid="")&&(ctloc="") ret
	
	;取流的第一个操作项目
	s ret=-1.1
	s ItemDr=$$GetWorkFlow(MrType)
	q:ItemDr="" ret
	
	;取病案类型设置
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" ret
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" ret
	
	;^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
	/***** from ;i $d(^DHCWMRMAIN(0,"TypeNO",MrType,OldNo)) d
	..i $d(^DHCWMRMAIN(0,"TypeNO",MrType,OldNo)) d
	...s ret=-2.2             ;检查历史号码是否有效
	...s tmpMrMainRowid=$o(^DHCWMRMAIN(0,"TypeNO",MrType,OldNo,""),-1)
	...s tmpsMain=##class(web.DHCWMRMainCtl).GetMainById(tmpMrMainRowid)
	...s:$p(tmpsMain,"^",7)="Y" NoFlag=-1      ;如果操作员给的历史号码已经存在，不能再分配
	...s:NoFlag=0 MrNo=OldNo
	..*/
	
	Tstart
	s MrNo="",NoFlag=0
	i MainRowid="" d         ;分配新号码
	.i OldNo="" d
	..s ret=-2.1                ;更新病案号码发放
	..//s sMrNo=##class(web.DHCWMRNoCtl).GetMrNoByLoc(MrType,ctloc)  
	..Set:'$o(^DHCWMRNO(0,"TypeActive",MrType,"Y","")) IsHavNo="N"
	..s sMrNo=##class(web.DHCWMRNoCtl).GetMrNoByMrType(MrType)
	..i sMrNo="" TRollBack
	..s:sMrNo="" NoFlag=-1111
	..s WMRNoRowid=$o(^DHCWMRNO(0,"TypeNo",MrType,sMrNo,""))
	..s MrNo=sMrNo     ;$p(sMrNo,"^",3)
	..s sWMRNo=""
	..s $p(sWMRNo,"^",1)=WMRNoRowid	  ;Rowid
	..s $p(sWMRNo,"^",2)=MrType	      ;病案类型
	..s $p(sWMRNo,"^",3)=sMrNo	      ;病案号
	..s $p(sWMRNo,"^",4)="N"	      ;是否有效
	..s $p(sWMRNo,"^",5)=ctloc	      ;所属接诊科室
	..s $p(sWMRNo,"^",6)=UserId	      ;发放操作员
	..s $p(sWMRNo,"^",7)=$zd(+$h,3)	      ;发放日起
	..s $p(sWMRNo,"^",8)=$zt($p($h,",",2))	      ;发放时间
	..s NoFlag=##class(web.DHCWMRNoCtl).Update(sWMRNo)
	..i NoFlag<0 TRollBack
	..s MrNo=sMrNo
	.e  d 
	..;i $d(^DHCWMRMAIN(0,"TypeNO",MrType,OldNo)) d
	..s OldNo=$$ALPHAUP^SSUTIL4($g(OldNo))
	..i $d(^DHCWMRNO(0,"TypeNo",MrType,OldNo)) d
	...s WMRNoRowid=$o(^DHCWMRNO(0,"TypeNo",MrType,OldNo,""),-1)
	...s sWMRNo=##class(web.DHCWMRNoCtl).GetDataById(WMRNoRowid)
	...i $p(sWMRNo,"^",4)="N" d
	....s NoFlag=-2222     ;已经用完 不可再用
	...e  d
	....s $p(sWMRNo,"^",4)="N"
	....s $p(sWMRNo,"^",5)=ctloc	      ;所属接诊科室
	....s $p(sWMRNo,"^",6)=UserId	      ;发放操作员
	....s $p(sWMRNo,"^",7)=$zd(+$h,3)	      ;发放日起
	....s $p(sWMRNo,"^",8)=$zt($p($h,",",2))	      ;发放时间
	....s NoFlag=##class(web.DHCWMRNoCtl).Update(sWMRNo)
	....i NoFlag<0 TRollBack
	....s MrNo=OldNo
	..e  d
	...s ret=-2.3             ;分配一个未入库的历史号码
	...s sWMRNo=""
	...s $p(sWMRNo,"^",2)=MrType	      ;病案类型
	...s $p(sWMRNo,"^",3)=OldNo	      ;病案号
	...s $p(sWMRNo,"^",4)="N"	      ;是否有效
	...s $p(sWMRNo,"^",5)=ctloc	      ;所属接诊科室
	...s $p(sWMRNo,"^",6)=UserId	      ;发放操作员
	...s $p(sWMRNo,"^",7)=$zd(+$h,3)	      ;发放日起
	...s $p(sWMRNo,"^",8)=$zt($p($h,",",2))	      ;发放时间
	...s NoFlag=##class(web.DHCWMRNoCtl).Update(sWMRNo)
	...i NoFlag<0 TRollBack
	...s MrNo=OldNo
	q:NoFlag<0 ret
	s OldNo=$$ALPHAUP^SSUTIL4($g(MrNo))
	s ret=-3
	;生成病案信息
	i MainRowid="" d
	.s sMain=""
	.s $p(sMain,"^",2)=MrType
	.s $p(sMain,"^",3)=MrNo
	.s $p(sMain,"^",4)=papmi
	.s $p(sMain,"^",7)="Y"
	.s $p(sMain,"^",8)="Y"
	e  d
	.s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
	.s MrNo=$p(sMain,"^",3)
	i sMain="" TRollBack
	q:sMain="" ret
	s ret=-3.1
	s $p(sMain,"^",4)=papmi
	s MainRowid=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
	i +MainRowid<0 TRollBack
	q:+MainRowid<0 ret
	
	s ret=-3
	;生成卷信息
	s sVolume=""
	s $p(sVolume,"^",2)=+MainRowid
	s $p(sVolume,"^",3)=+paadm
	s $p(sVolume,"^",7)=ItemDr          ;病案操作项目/状态
	s $p(sVolume,"^",8)="Y"
	s $p(sVolume,"^",9)="Y"
	;Add by wuqk 2008-07-05  病案卷表ResumeText字段存储住院次数
	s $p(sVolume,"^",10)=..GetIPCount("",MainRowid)
	s volNo=paadm
	s LeadingFactor=##Class(web.DHCWMRGroup.DHCWMRGroupReceipt).GetLeadingFactor(MrType)
	if (LeadingFactor="V"){
		s volNo=OldNo	
	}
	s $p(sVolume,"^",11)=volNo
	
	s VolRowid=##class(web.DHCWMRVolumeCtl).UpdateVol(sVolume)
	i +VolRowid<0 TRollBack
	q:+VolRowid<0 ret
	
	s ret=-3.1
	;生成卷病案号更改列表
	s sVolLog=""
	s $p(sVolLog,"^",1)=VolRowid
	s $p(sVolLog,"^",3)=+MainRowid
	s $p(sVolLog,"^",4)=UserId          ;User
	s VolLogRowid=##class(web.DHCWMRVolumeCtl).UpdateVolLog(sVolLog)
	i +VolLogRowid<0 TRollBack
	q:+VolLogRowid<0 ret
	
	s ret=-4
	;生成卷就诊列表信息   DHC_WMR_VolAdm
	s sVolAdm=""
    s $p(sVolAdm,"^",1)=VolRowid
    s $p(sVolAdm,"^",3)=paadm
	s VolAdmRowid=##class(web.DHCWMRVolumeCtl).UpdateVolAdm(sVolAdm)
	i +VolAdmRowid<0 TRollBack
	q:+VolAdmRowid<0 ret
	
	s ret=-5
	;生成卷状态信息   DHC_WMR_VolStatus
	s sVolStatus=""
	s $p(sVolStatus,"^",1)=VolRowid
	s $p(sVolStatus,"^",3)=ItemDr
	s $p(sVolStatus,"^",4)=UserId
	s $p(sVolStatus,"^",7)=UserId
	s VolStatusRowid=##class(web.DHCWMRVolumeCtl).UpdateVolStatus(sVolStatus)
	i +VolStatusRowid<0 TRollBack
	q:+VolStatusRowid<0 ret
	
	s ret=-6
	;生成卷信息   DHC_WMR_VolInfo
	s sVolInfo=##class(web.DHCWMRBaseInfoCtl).FormatBaseInfo(papmi,"")
	s $p(sVolInfo,"^",3)=NameSpell
	s $p(sVolInfo,"^",26)=VolRowid
	s VolInfoRowid=##class(web.DHCWMRVolumeCtl).UpdateVolInfo(sVolInfo)
	i +VolInfoRowid<0 TRollBack
	q:+VolInfoRowid<0 ret
	
	s ret=-7
	s flag=0
	;更新入院时情况(病人入院状态--平稳/病重/病危)
	s:patcond'="" flag=##class(web.DHCWMRBasePaadm).UpdateAdmPatCond(paadm,patcond)
	i flag'=0 TRollBack
	q:flag'=0 ret
	
	/*
	s ret=-8
	;更新病案号
	s flag=0	
	;paperson.paper_governcardno
	s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(MrNo,papmi)
	;PA_PatMas.PAPMI_Medicare
	s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(MrNo,papmi)
	;User.DHCPerson.PAPERFCMedicareCode1
	s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(MrNo,papmi)
	;User.DHCPerson.PAPERFCMedicareCode2
	s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(MrNo,papmi)
	i flag'=0 TRollBack
	q:flag'=0 ret
	*/
	TCommit
	
	//更新当前最大号
	Set:IsHavNo="N" MaxNo=##class(web.DHCWMRNoCtl).UpdateMrNoByMrType(MrType)
	;添加接诊日志
	;RecStr=OprType^MrType^MrNo^VolId^Papmi^Paadm^RecLoc^RecUser^ResumeText
	s OprType=1,xVolId=+VolRowid
	s RecStr=OprType_"^"_MrType_"^"_MrNo_"^"_xVolId_"^"_papmi_"^"_paadm_"^"_ctloc_"^"_UserId_"^"_""
	s xret=##Class(web.DHCWMRReceiptLogCtl).SaveReceiptLog(RecStr)
	
	s ret=VolRowid
	q ret
	
GetWorkFlow(MrType)
    n (MrType)
    s sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(MrType,"Y",$zd(+$h,3))
    s ItemDr=""
    q:sFlow="" ItemDr
    s sTmp=$p(sFlow,$c(1),1)
    s ItemDr=$p(sTmp,"^",3)
    q ItemDr
    
    /*
    ;取住院次数
GetIPCount(IPCount,MainRowid)
    n (IPCount,MainRowid)
    if +IPCount>0 d      ;如果录入住院次数，取录入的数据
    .s IPCount=+IPCount
    e  d
    .;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})   ;未录入，且无历史，默认为首次
    .if '$d(^DHCWMRVOL(0,"Main",MainRowid)) s IPCount=1
    .e  d
    ..s VolRowid="",IPCount=0      ;未录入，取最后一次的住院次数，加1
    ..f  s VolRowid=$o(^DHCWMRVOL(0,"Main",MainRowid,VolRowid),-1)  q:(+VolRowid=0)!(IPCount>0)  d
    ...s Active=$p($g(^DHCWMRVOL(+VolRowid)),"^",7)
    ...q:Active'="Y"
    ...s Count=+$p($g(^DHCWMRVOL(+VolRowid)),"^",9)
    ...s IPCount=Count+1
    
    q IPCount
    */
}

/// *****************************************************************
/// 事务           :  UnReceipt
/// 功能描述       ： 接诊退号
///                   检查paadm是否已取消
///                   修改卷状态  IsActive=N
///                   如该病案无其它卷 修改病案状态 IsActive=N
///                                    更新病案号码发放 
/// by wuqk 2007-04
/// 入参           ：
///   VolRowid     ： 卷Rowid  DHC_WMR_MainVolume.Rowid
///   RecLocId        :  取消接诊操作人科室
///   RecUserId       :  取消接诊操作人
/// 返回值         ： ret=0 成功    ret<0 失败
/// *****************************************************************
ClassMethod UnReceipt(VolRowid, RecLocId, RecUserId)
{
	n (VolRowid, RecLocId, RecUserId)
	s ret=-1
	
	s sVol=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
	q:sVol="" ret
	s MainRowid=+$p(sVol,"^",2)
	q:MainRowid'>0 ret
	s xVolId=+VolRowid
	
	s sMrMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
	s MrType=$p(sMrMain,"^",2)
	s xPapmi=$p(sMrMain,"^",4)
	
	;取病案类型设置
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" ret
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" ret
	;add by liuxuefeng 2009-06-30 获取是否取消病案号设置
	s MrNoCancelFlag=$p(strMrType,"^",6)
  s recycle=$p(strMrType,"^",13)
	s RecyCode=$p(^DHCWMRDIC(recycle),"^",2)
		
	Tstart
	s ret=-2
	;取消卷
	s $p(sVol,"^",7)=+$p(sVol,"^",7)
	s $p(sVol,"^",8)="N"
	s flag=##class(web.DHCWMRVolumeCtl).UpdateVol(sVol)
	i +flag<0 TRollBack
	q:+flag<0 ret
	
    s sMain=##class(web.DHCWMRMainCtl).GetMainById(+MainRowid)
    s MrType=$p(sMain,"^",2),MrNo=$p(sMain,"^",3),papmi=+$p(sMain,"^",4)
    s TmpVol="0",ActiveFlag=""             ;检查是否存在有效的卷
    
    s PapmiFlag=""
    ;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
    f  s TmpVol=$o(^DHCWMRVOL(0,"Main",MainRowid,TmpVol)) q:TmpVol=""  d
    .s IsActive=$p($g(^DHCWMRVOL(TmpVol)),"^",7)
    .i IsActive="Y" d
    ..s ActiveFlag="1"
    ..s tmpPaadm=$p($g(^DHCWMRVOL(TmpVol)),"^",2)
    ..i tmpPaadm'="" d
    ...s tmpPapmi=$p($g(^PAADM(+tmpPaadm)),"^",1)
    ...s:papmi=tmpPapmi PapmiFlag="1"
    
    ;Modify by liuxuefeng 2009-06-30 如果MrNoCancelFlag为“Y”，则取消病案号
    if (MrNoCancelFlag="Y")
    {
		s ret=-3
		;取消病案
	    s:ActiveFlag="" $p(sMain,"^",7)="N"      ;无有效卷 取消main
	    ;s:PapmiFlag="" $p(sMain,"^",4)=""        ;无相同papmi
	    s MainRowid=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
	    i +MainRowid<0 d
		.TRollBack
	    q:+MainRowid<0 ret
	    if (RecyCode="Y"){
	    s MainFlag=0
	    i ActiveFlag="" d
		.s ret=-4
		.;取消号码分配
		.s NoFlag=##class(web.DHCWMRNoCtl).SetMrNoByTypeNo(MrType,MrNo)
		.i +NoFlag<0 d
		..TRollBack
		..s MainFlag=-1
		q:MainFlag<0 ret 
		}
		;add by liuxuefeng 2009-06-30 取消病案号时，将病案基本信息中对应病案号置空
		s ret=-8
		;更新病案号
		s flag=0	
		s MrNoEmpty=""
		;paperson.paper_governcardno
		s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(MrNoEmpty,papmi)
		;PA_PatMas.PAPMI_Medicare
		s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(MrNoEmpty,papmi)
		;User.DHCPerson.PAPERFCMedicareCode1
		s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(MrNoEmpty,papmi)
		;User.DHCPerson.PAPERFCMedicareCode2
		s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(MrNoEmpty,papmi)
		i flag'=0 TRollBack
		q:flag'=0 ret
    }
	//add by liuxuefeng 2009-02-11
	s ret=-7
	;更新入院时情况(病人入院状态--平稳/病重/病危),将入院情况设为空
	s patcond=""
	s EpisodeID=$p($g(^DHCWMRVOL(VolRowid)),"^",2)
	s CondFlag=##class(web.DHCWMRBasePaadm).UpdateAdmPatCond(EpisodeID,patcond)
	i CondFlag'=0 TRollBack
	q:CondFlag'=0 ret
	
	/* delete by liuxuefeng 2009-07-03 上面取消接诊程序已将病案基本信息中对应病案号置空
	s MainFlag=0
	i ActiveFlag="" d
	.s ret=-5
	.;更新住院病案号paperson.paper_governcardno
	.s flag=0
	.i papmi>0 d
	..s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA("",papmi)
	..s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB("",papmi)
	..;User.DHCPerson.PAPERFCMedicareCode1
	..s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(,papmi)
	..;User.DHCPerson.PAPERFCMedicareCode2
	..s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(,papmi)
	..;s flag=##class(web.DHCWMRMedBaseCtl).UpdateIPMrNo("",papmi)
	.i flag<0 d
	..TRollBack
	..s MainFlag=-1
	q:MainFlag<0 ret
	*/
	TCommit
	
	;添加取消接诊日志
	;RecStr=OprType^MrType^MrNo^VolId^Papmi^Paadm^RecLoc^RecUser^ResumeText
	s OprType=2,MrType="",MrNo="",Papmi="",Paadm=""
	s RecStr=OprType_"^"_MrType_"^"_MrNo_"^"_xVolId_"^"_xPapmi_"^"_Paadm_"^"_RecLocId_"^"_RecUserId_"^"_""
	s xret=##Class(web.DHCWMRReceiptLogCtl).SaveReceiptLog(RecStr)
	
	s ret=0
	q ret
}

/// 取住院次数
/// w ##Class(web.DHCWMRReceipt).GetIPCount(IPCount,MainRowid)
ClassMethod GetIPCount(IPCount, MainRowid)
{
    n (IPCount,MainRowid)
    if +IPCount>0 d      ;如果录入第几次住院，取录入的数据
    .s IPCount=+IPCount
    e  d
    .;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})   ;未录入，且无历史，默认为首次住院
    .if '$d(^DHCWMRVOL(0,"Main",+MainRowid)) s IPCount=1
    .e  d
    ..s VolRowid=0,IPCount=0      ;未录入，取所有卷中第一次住院中最大数，加1
    ..f  s VolRowid=$o(^DHCWMRVOL(0,"Main",MainRowid,VolRowid))  q:VolRowid=""  d
    ...s Active=$p($g(^DHCWMRVOL(+VolRowid)),"^",7)
    ...q:Active'="Y"
    ...s Count=+$p($g(^DHCWMRVOL(+VolRowid)),"^",9)
    ...s:IPCount<Count IPCount=Count
    ..s IPCount=IPCount+1
    
    q IPCount
}

/// *****************************************************************
/// 事务           :  ReceiptByReg
/// 功能描述       ： 住院登记时自动生成病案信息
///                   生成病案信息 
///                   生成卷信息 
///                   更新病案号码发放 
///                   更新入院时情况
/// by wuqk 2008-14
/// 入参           ：
///   MrType       ： 病案类型
///   paadm        ： 本次就诊 Pa_adm.Rowid
///   NameSpell    :  病人姓名的拼音
///   RegMrNo      :  住院登记时分配的病案号码
///   UserId       ： 操作员Rowid   
/// 返回值         ： ret=VolRowid 成功    ret<0 失败
/// *****************************************************************
ClassMethod ReceiptByReg(MrType, paadm, NameSpell, RegMrNo, UserId)
{
	;n (MrType,papmi,paadm,MainRowid,ctloc,NameSpell,patcond,OldNo,UserId)
	n (MrType,paadm,NameSpell,RegMrNo,UserId)
	s ret=-1
	q:$p($g(^PAADM(+paadm)),"^",75)'="" 1    //婴儿不建病案
	q:(MrType="")||(paadm="") ret
	q:'$d(^PAADM(paadm)) ret
	
	q:RegMrNo="" ret
	
	//已经建病案,不再重复建病案
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
    s TMPVolId=0,TMPFlg=0
    f  s TMPVolId=$o(^DHCWMRVOL(0,"VolAdm",paadm,TMPVolId)) q:((TMPVolId="")||((+TMPFlg)>0))  d
    .s TMPVol=$g(^DHCWMRVOL(TMPVolId))
    .q:$p(TMPVol,"^",7)'="Y"
    .s TMPFlg=TMPVolId
    q:(+TMPFlg)>0 +TMPFlg
	
	s papmi=+$p($g(^PAADM(paadm)),"^",1)
	s patcond=""
	s MainRowid=""
	s ctloc=+$p($g(^SSU("SSUSR",UserId)),"^",4)
	s OldNo=$$ALPHAUP^SSUTIL4(RegMrNo)
	
	;取流的第一个操作项目
	s ret=-1.1
	s ItemDr=$$GetWorkFlow(MrType)
	q:ItemDr="" ret
	
	;取病案类型设置
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" ret
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" ret
	
	s MrNo="",NoFlag=0
	
	;1、根据papmi查询病案信息
	s ret=-2.1
	s pMain="",pMrNo=OldNo
	i $d(^DHCWMRMAIN(0,"PAPMI",papmi)) d
	.s mainRowid=0
	.f  s mainRowid=$o(^DHCWMRMAIN(0,"PAPMI",papmi,mainRowid)) q:mainRowid=""  d
	..s Type=$p($g(^DHCWMRMAIN(mainRowid)),"^",1)
	..q:Type'=MrType          ;病案类型不一致
	..s Active=$p($g(^DHCWMRMAIN(mainRowid)),"^",6)
	..q:Active'="Y"
	..s pMain=mainRowid
	..s pMrNo=$p($g(^DHCWMRMAIN(pMain)),"^",2)
	..;s OldNo=pMrNo
	q:pMrNo'=OldNo ret
	
	;2、根据MrNo查询病案信息   ^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
	s ret=-2.2
	s mMain="",mPapmi=papmi
	i $d(^DHCWMRMAIN(0,"TypeNO",MrType,OldNo)) d
	.s mainRowid=0
	.f  s mainRowid=$o(^DHCWMRMAIN(0,"TypeNO",MrType,OldNo,mainRowid)) q:mainRowid=""  d
	..s Active=$p($g(^DHCWMRMAIN(mainRowid)),"^",6)
	..q:Active'="Y"
	..s mMain=mainRowid
	..s mPapmi=+$p($g(^DHCWMRMAIN(mMain)),"^",3)
	q:mPapmi'=papmi ret
	
	;校准
	s ret=-2.3
	q:(pMain'=mMain) ret
	s MainRowid=mMain
	
	
	Tstart
	
	;记录号码发放
	s ret=-2.4
	i $d(^DHCWMRNO(0,"TypeNo",MrType,OldNo)) d
	.s WMRNoRowid=$o(^DHCWMRNO(0,"TypeNo",MrType,OldNo,""),-1)
	.s sWMRNo=##class(web.DHCWMRNoCtl).GetDataById(+WMRNoRowid)
	.i $p(sWMRNo,"^",4)="N" d
	..s:MainRowid="" NoFlag=-2222     ;已经用完 不可再用
	.e  d
	..s $p(sWMRNo,"^",4)="N"
	..s $p(sWMRNo,"^",5)=ctloc	      ;所属接诊科室
	..s $p(sWMRNo,"^",6)=UserId	      ;发放操作员
	..s $p(sWMRNo,"^",7)=$zd(+$h,3)	      ;发放日起
	..s $p(sWMRNo,"^",8)=$zt($p($h,",",2))	      ;发放时间
	..s NoFlag=##class(web.DHCWMRNoCtl).Update(sWMRNo)
	..i NoFlag<0 TRollBack
	..s MrNo=OldNo
	e  d
	.s ret=-2.5             ;分配一个未入库的历史号码
	.s sWMRNo=""
	.s $p(sWMRNo,"^",2)=MrType	      ;病案类型
	.s $p(sWMRNo,"^",3)=OldNo	      ;病案号
	.s $p(sWMRNo,"^",4)="N"	      ;是否有效
	.s $p(sWMRNo,"^",5)=ctloc	      ;所属接诊科室
	.s $p(sWMRNo,"^",6)=UserId	      ;发放操作员
	.s $p(sWMRNo,"^",7)=$zd(+$h,3)	      ;发放日起
	.s $p(sWMRNo,"^",8)=$zt($p($h,",",2))	      ;发放时间
	.s NoFlag=##class(web.DHCWMRNoCtl).Update(sWMRNo)
	.i NoFlag<0 TRollBack
	.s MrNo=OldNo
	q:NoFlag<0 ret
	
	s ret=-3
	;生成病案信息
	i MainRowid="" d
	.s sMain=""
	.s $p(sMain,"^",2)=MrType
	.s $p(sMain,"^",3)=MrNo
	.s $p(sMain,"^",4)=papmi
	.s $p(sMain,"^",7)="Y"
	.s $p(sMain,"^",8)="Y"
	e  d
	.s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
	.s MrNo=$p(sMain,"^",3)
	i sMain="" TRollBack
	q:sMain="" ret
	s ret=-3.1
	s $p(sMain,"^",4)=papmi
	s MainRowid=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
	i +MainRowid<0 TRollBack
	q:+MainRowid<0 ret
	
	s ret=-3
	;生成卷信息
	s sVolume=""
	s $p(sVolume,"^",2)=+MainRowid
	s $p(sVolume,"^",3)=+paadm
	s $p(sVolume,"^",7)=ItemDr          ;病案操作项目/状态
	s $p(sVolume,"^",8)="Y"
	s $p(sVolume,"^",9)="Y"
	;Add by wuqk 2008-07-05  病案卷表ResumeText字段存储住院次数
	s $p(sVolume,"^",10)=..GetIPCount("",MainRowid)
	s VolRowid=##class(web.DHCWMRVolumeCtl).UpdateVol(sVolume)
	i +VolRowid<0 TRollBack
	q:+VolRowid<0 ret
	
	s ret=-3.1
	;生成卷病案号更改列表
	s sVolLog=""
	s $p(sVolLog,"^",1)=VolRowid
	s $p(sVolLog,"^",3)=+MainRowid
	s $p(sVolLog,"^",4)=UserId          ;User
	s VolLogRowid=##class(web.DHCWMRVolumeCtl).UpdateVolLog(sVolLog)
	i +VolLogRowid<0 TRollBack
	q:+VolLogRowid<0 ret
	
	s ret=-4
	;生成卷就诊列表信息   DHC_WMR_VolAdm
	s sVolAdm=""
    s $p(sVolAdm,"^",1)=VolRowid
    s $p(sVolAdm,"^",3)=paadm
	s VolAdmRowid=##class(web.DHCWMRVolumeCtl).UpdateVolAdm(sVolAdm)
	i +VolAdmRowid<0 TRollBack
	q:+VolAdmRowid<0 ret
	
	s ret=-5
	;生成卷状态信息   DHC_WMR_VolStatus
	s sVolStatus=""
	s $p(sVolStatus,"^",1)=VolRowid
	s $p(sVolStatus,"^",3)=ItemDr
	s $p(sVolStatus,"^",4)=UserId
	s $p(sVolStatus,"^",7)=UserId
	s VolStatusRowid=##class(web.DHCWMRVolumeCtl).UpdateVolStatus(sVolStatus)
	i +VolStatusRowid<0 TRollBack
	q:+VolStatusRowid<0 ret
	
	s ret=-6
	;生成卷信息   DHC_WMR_VolInfo
	s sVolInfo=##class(web.DHCWMRBaseInfoCtl).FormatBaseInfo(papmi,"")
	s $p(sVolInfo,"^",3)=NameSpell
	s $p(sVolInfo,"^",26)=VolRowid
	s VolInfoRowid=##class(web.DHCWMRVolumeCtl).UpdateVolInfo(sVolInfo)
	i +VolInfoRowid<0 TRollBack
	q:+VolInfoRowid<0 ret
	
	s ret=-7
	s flag=0
	;更新入院时情况(病人入院状态--平稳/病重/病危)
	s:patcond'="" flag=##class(web.DHCWMRBasePaadm).UpdateAdmPatCond(paadm,patcond)
	i flag'=0 TRollBack
	q:flag'=0 ret
	
	s ret=-8
	;更新病案号
	s flag=0	
	;paperson.paper_governcardno
	s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(MrNo,papmi)
	;PA_PatMas.PAPMI_Medicare
	s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(MrNo,papmi)
	;User.DHCPerson.PAPERFCMedicareCode1
	s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(MrNo,papmi)
	;User.DHCPerson.PAPERFCMedicareCode2
	s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(MrNo,papmi)
	i flag'=0 TRollBack
	q:flag'=0 ret
	
	TCommit
	
	;添加接诊日志
	;RecStr=OprType^MrType^MrNo^VolId^Papmi^Paadm^RecLoc^RecUser^ResumeText
	s OprType=1,xVolId=+VolRowid
	s RecStr=OprType_"^"_MrType_"^"_MrNo_"^"_xVolId_"^"_papmi_"^"_paadm_"^"_ctloc_"^"_UserId_"^"_""
	s xret=##Class(web.DHCWMRReceiptLogCtl).SaveReceiptLog(RecStr)
	
	s ret=VolRowid
	q ret
}

/// *****************************************************************
/// 事务           :  UnReceiptByReg
/// 功能描述       ： 住院登记退院
///                   检查paadm是否已取消
///                   修改卷状态  IsActive=N
///                   --根据中国医科大一附属医院需求,不取消病案号(病人基本信息表中病案号保留)
///                   --根据华西一院需求,不取消病案号(病人基本信息表中病案号保留)
/// by wuqk 2008-11
/// 入参           ：
///   Paadm        :  EpisodeId
///   RecUserId    :  取消接诊操作人
/// 返回值         ： ret=0 成功    ret<0 失败
/// *****************************************************************
ClassMethod UnReceiptByReg(Paadm, RecUserId)
{
	n (Paadm, RecUserId)
	s ret=-1
	q:Paadm="" ret
	q:$p($g(^PAADM(+Paadm)),"^",75)'="" 0    //婴儿不建病案
	q:'$d(^DHCWMRVOL(0,"VolAdm",Paadm)) ret
	
	s ret=0
	//已经取消病案,不再重复取消病案
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
    s TMPVolId=0,TMPFlg=0
    f  s TMPVolId=$o(^DHCWMRVOL(0,"VolAdm",Paadm,TMPVolId)) q:((TMPVolId="")||((+TMPFlg)>0))  d
    .s TMPVol=$g(^DHCWMRVOL(TMPVolId))
    .q:$p(TMPVol,"^",7)'="Y"
    .s TMPFlg=TMPVolId
    q:(+TMPFlg)=0 ret
	
	s ret=-1
	;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr}
	s RecLocId=+$p($g(^SSU("SSUSR",RecUserId)),"^",4)
	s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",Paadm,""),-1)
	
	s sVol=##class(web.DHCWMRVolumeCtl).GetVolume(+VolRowid)
	q:sVol="" ret
	s MainRowid=+$p(sVol,"^",2)
	q:MainRowid'>0 ret
	s xVolId=+VolRowid
	
	s sMrMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
	s MrType=$p(sMrMain,"^",2)
	s xPapmi=$p(sMrMain,"^",4)
	
	;取病案类型设置
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" ret
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" ret
	;add by liuxuefeng 2009-06-30 获取是否取消病案号设置
	s MrNoCancelFlag=$p(strMrType,"^",6)
	
	Tstart
	s ret=-2
	;取消卷
	s $p(sVol,"^",7)=+$p(sVol,"^",7)
	s $p(sVol,"^",8)="N"
	s flag=##class(web.DHCWMRVolumeCtl).UpdateVol(sVol)
	i +flag<0 TRollBack
	q:+flag<0 ret
	
    s sMain=##class(web.DHCWMRMainCtl).GetMainById(+MainRowid)
    s MrType=$p(sMain,"^",2),MrNo=$p(sMain,"^",3),papmi=+$p(sMain,"^",4)
    s TmpVol="0",ActiveFlag=""             ;检查是否存在有效的卷
    
    s PapmiFlag=""
    ;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
    f  s TmpVol=$o(^DHCWMRVOL(0,"Main",MainRowid,TmpVol)) q:TmpVol=""  d
    .s IsActive=$p($g(^DHCWMRVOL(TmpVol)),"^",7)
    .i IsActive="Y" d
    ..s ActiveFlag="1"
    ..s tmpPaadm=$p($g(^DHCWMRVOL(TmpVol)),"^",2)
    ..i tmpPaadm'="" d
    ...s tmpPapmi=$p($g(^PAADM(+tmpPaadm)),"^",1)
    ...s:papmi=tmpPapmi PapmiFlag="1"

    ;Modify by liuxuefeng 2009-06-30 如果MrNoCancelFlag为“Y”，则取消病案号
    if (MrNoCancelFlag="Y")
    {
		s ret=-3
		;取消病案
	    s:ActiveFlag="" $p(sMain,"^",7)="N"      ;无有效卷 取消main
	    ;s:PapmiFlag="" $p(sMain,"^",4)=""        ;无相同papmi
	    s MainRowid=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
	    i +MainRowid<0 d
		.TRollBack
	    q:+MainRowid<0 ret
	    
	    s MainFlag=0
	    i ActiveFlag="" d
		.s ret=-4
		.;取消号码分配
		.s NoFlag=##class(web.DHCWMRNoCtl).SetMrNoByTypeNo(MrType,MrNo)
		.i +NoFlag<0 d
		..TRollBack
		..s MainFlag=-1
		q:MainFlag<0 ret
		
		;add by liuxuefeng 2009-06-30 取消病案号时，将病案基本信息中对应病案号置空
		s ret=-8
		;更新病案号
		s flag=0	
		s MrNoEmpty=""
		;paperson.paper_governcardno
		s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(MrNoEmpty,papmi)
		;PA_PatMas.PAPMI_Medicare
		s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(MrNoEmpty,papmi)
		;User.DHCPerson.PAPERFCMedicareCode1
		s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(MrNoEmpty,papmi)
		;User.DHCPerson.PAPERFCMedicareCode2
		s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(MrNoEmpty,papmi)
		i flag'=0 TRollBack
		q:flag'=0 ret
    }
	TCommit
	
	;添加取消接诊日志
	;RecStr=OprType^MrType^MrNo^VolId^Papmi^Paadm^RecLoc^RecUser^ResumeText
	s OprType=2,MrType="",MrNo="",Papmi="",Paadm=""
	s RecStr=OprType_"^"_MrType_"^"_MrNo_"^"_xVolId_"^"_xPapmi_"^"_Paadm_"^"_RecLocId_"^"_RecUserId_"^"_""
	s xret=##Class(web.DHCWMRReceiptLogCtl).SaveReceiptLog(RecStr)
	
	s ret=0
	q ret
}

/// 取住院登记时自动建病案用到的病人姓名和病案号
/// w ##Class(web.DHCWMRReceipt).GetMrNoByPaadm(MrType,Paadm)
ClassMethod GetMrNoByPaadm(MrType, Paadm)
{
    n (MrType,Paadm)
    s ret="",PatName="",MrNo=""
    
    q:(Paadm="")||(MrType="") ret
    s tmpPaadm=$g(^PAADM(Paadm))
    q:tmpPaadm="" ret
    s Papmi=$p(tmpPaadm,"^",1)
    s PatName=$p($g(^PAPER(+Papmi,"ALL")),"^",1)
    q:PatName="" ret
    
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" ret
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" ret
	;paperson.paper_governcardno
	s:MrNoField="A" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoA(Papmi)
	;PA_PatMas.PAPMI_Medicare
	s:MrNoField="B" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoB(Papmi)
	;User.DHCPerson.PAPERFCMedicareCode1
	s:MrNoField="C" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoC(Papmi)
	;User.DHCPerson.PAPERFCMedicareCode2
	s:MrNoField="D" MrNo=##class(web.DHCWMRMedBaseCtl).GetMrNoD(Papmi)
	s:MrNo="" MrNo=$p(tmpPaadm,"^",81)
	q:MrNo="" ret
	
    s ret=Paadm_"^"_MrNo_"^"_PatName
    q ret
}

/// w ##Class(web.DHCWMRReceipt).ImportReceiptData(From,To)
ClassMethod ImportReceiptData(From, To)
{
	n (From,To)
	s Count=0
	
	s Paadm=From-1
	f  s Paadm=$o(^DHCWMRPinYin(Paadm)) q:(Paadm="")||(Paadm>To)  d
	.;^DHCWMRVOL(0,"VolAdm",{Paadm_Dr},{DHC_WMR_MainVolume.Rowid},{ChildSub})
    .s TMPVolId=0,TMPFlg=0
    .f  s TMPVolId=$o(^DHCWMRVOL(0,"VolAdm",Paadm,TMPVolId)) q:((TMPVolId="")||((+TMPFlg)>0))  d
    ..s TMPVol=$g(^DHCWMRVOL(TMPVolId))
    ..q:$p(TMPVol,"^",7)'="Y"
    ..s TMPFlg=TMPVolId
    .q:(+TMPFlg)>0
    .s tmp=$g(^DHCWMRPinYin(Paadm))
    .s MrType=$p(tmp,"^",1)
    .s Paadm=$p(tmp,"^",2)
    .s NameSpell=$p(tmp,"^",3)
    .s MrNo=$p(tmp,"^",4)
    .s UserId=$p(tmp,"^",5)
    .q:(MrType="")||(Paadm="")||(NameSpell="")||(MrNo="")||(UserId="")
    .s flg=##Class(web.DHCWMRReceipt).ReceiptByReg(7,Paadm,NameSpell,MrNo,UserId)
    .w:flg<0 flg,!
    .s:flg<0 ^DHCWMRReceiptErr(7, Paadm, NameSpell, MrNo, UserId)=flg
    .k:flg>0 ^DHCWMRPinYin(Paadm)
    .s Count=Count+1
    .i Count=((Count\100)*100) w "已经处理"_Count_"条数据...",!
    
	q "Import Over!"
}

}
