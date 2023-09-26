Import SQLUser

Class web.DHCWMRMRMerger Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 18;

/// 通过病案号或登记号取病案信息
/// w ##Class(web.DHCWMRMRMerger).GetMRInfo(6,"","0000000086","")
ClassMethod GetMRInfo(MrType, MrNo, PatNo, CardNo)
{
	n (MrType,MrNo,PatNo,CardNo)
	s ret="",PatInfo=""
	
	q:MrType="" ret
	q:(MrNo="")&&(PatNo="")&&(CardNo="") ret
	
	s MrNo=$$ALPHAUP^SSUTIL4($g(MrNo))
	
	;^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
	i MrNo'="" d
	.s MrNo=$$ALPHAUP^SSUTIL4(MrNo)
	.s MainId=0,Active=""
	.f  s MainId=$o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,MainId)) q:(MainId="")||(Active="Y")  d
	..s tmp=##Class(web.DHCWMRMainCtl).GetMainById(MainId)
	..q:tmp=""
	..s tmpMrType=$p(tmp,"^",2)
	..q:tmpMrType'=MrType
	..s tmpActive=$p(tmp,"^",7)
	..q:tmpActive'="Y"
	..s PatInfo=##Class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainId)
	..s ret=PatInfo_$c(1)_tmp
	..s Active="Y"
	q:ret'="" ret
	
	s Papmi=""
	i PatNo'="" d
	.s Papmi=$o(^PAPERi("PAPMI_PatNo",PatNo,""),-1)
    .q:Papmi=""
    .s Papmi=+Papmi
    
    i (Papmi="")&&(CardNo'="") d
	.;^DHCCARDi("CF",0,"CardNo",{CF_CardNo},{CF_RowID})
	.s CardRefRowid=0,Flag=0
	.f  s CardRefRowid=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardRefRowid)) q:(CardRefRowid="")||(Flag=1)  d
	..s tmp=$g(^DHCCARD("CF",+CardRefRowid))
	..q:tmp=""
	..s Papmi=$p(tmp,"^",4)
	..q:Papmi=""
	..s Papmi=+Papmi
	;^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
	i Papmi'="" d
	.;^DHCWMRMAIN(0,"PAPMI",{Papmi_Dr},{Rowid})
	.i $d(^DHCWMRMAIN(0,"PAPMI",Papmi)) d
	..s MainId=0,Active=""
	..f  s MainId=$o(^DHCWMRMAIN(0,"PAPMI",Papmi,MainId)) q:(MainId="")||(Active="Y")  d
	...s tmp=##Class(web.DHCWMRMainCtl).GetMainById(MainId)
	...q:tmp=""
	...s tmpMrType=$p(tmp,"^",2)
	...q:tmpMrType'=MrType
	...s tmpActive=$p(tmp,"^",7)
	...q:tmpActive'="Y"
	...s PatInfo=##Class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainId)
	...s ret=PatInfo_$c(1)_tmp
	...s Active="Y"
	.i ret="" d
	..s PatInfo=##Class(web.DHCWMRBaseInfoCtl).FormatBaseInfo(+Papmi,"")
	..s ret=PatInfo_$c(1)_""
	s ret=$tr(ret,$c(0),"")  //add by zf 208-05-06
	q:ret'="" ret
	
	q ret
}

/// 通过病案Rowid取卷信息
ClassMethod GetMRVolume(MainId)
{
	n (MainId)
	s ret=""
	
	;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
	q:'$d(^DHCWMRVOL(0,"Main",MainId)) ret
	s VolId=0,TMP=""
	f  s VolId=$o(^DHCWMRVOL(0,"Main",MainId,VolId)) q:VolId=""  d
	.s tmp=##Class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	.q:tmp=""
	.s tmpActive=$p(tmp,"^",8)
	.q:tmpActive'="Y"
	.s TMP=TMP_$c(1)_tmp
	s ret=$e(TMP,2,$l(TMP))
	q ret
}

/// 合病案:同类型的病案才可合并
/// 旧病案主信息作废
/// 旧的病案号释放
/// 旧病案对应的Papatmas/Paperson表中的病案号字段清除
/// 卷挂到新病案下
/// 向DHC_WMR_VolLog表插入一条记录
/// 参数：
/// FromMainId  旧病案主信息Rowid
/// ToMainId    新病案主信息Rowid
/// UserId      操作人员Rowid
/// w ##Class(web.DHCWMRMRMerger).MRMerger(19243,19245,1)
ClassMethod MRMerger(FromMainId, ToMainId, UserId, NameSpell)
{
	n (FromMainId, ToMainId, UserId, NameSpell)
	s ret=-1
	
	q:FromMainId=ToMainId 1
	s tmpFMain=##class(web.DHCWMRMainCtl).GetMainById(FromMainId)
	q:tmpFMain="" ret
	s tmpFMrType=$p(tmpFMain,"^",2)
	q:tmpFMrType="" ret
	s tmpFMrNo=$p(tmpFMain,"^",3)
	s tmpFPapmi=+$p(tmpFMain,"^",4)
	s tmpFActive=$p(tmpFMain,"^",7)
	q:tmpFActive'="Y" ret
	
	s tmpTMain=##class(web.DHCWMRMainCtl).GetMainById(ToMainId)
	q:tmpTMain="" ret
	s tmpTMrType=$p(tmpTMain,"^",2)
	q:tmpTMrType="" ret
	s tmpTMrType=$p(tmpTMain,"^",2)
	s tmpTMrNo=$p(tmpTMain,"^",3)
	s tmpTPapmi=+$p(tmpTMain,"^",4)
	s tmpTActive=$p(tmpTMain,"^",7)
	q:tmpTActive'="Y" ret
	
	q:tmpFMrType'=tmpTMrType ret
	s tmpMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(tmpFMrType)
	q:tmpMrType="" ret
	s MrNoField=$p($p(tmpMrType,"^",5),"/",2)
	q:MrNoField="" ret
	
	TStart
	
	s ret=-2,flag=0
	;作废旧病案
    s $p(tmpFMain,"^",7)="N"
    s flag=##class(web.DHCWMRMainCtl).UpdateMain(tmpFMain)
    i flag<0 TRollBack
    q:flag<0 ret
    
    s ret=-3,flag=0
	;清除病人基本信息表中的病案号
	i tmpFPapmi>0 d
	.s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA("",tmpFPapmi)
	.s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB("",tmpFPapmi)
	.;User.DHCPerson.PAPERSGMedicareCode1
	.s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC("",tmpFPapmi)
	.;User.DHCPerson.PAPERSGMedicareCode2
	.s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD("",tmpFPapmi)
	.i flag<0 TRollBack
	q:flag<0 ret
	
	s ret=-4,flag=0
	;释放作废病案的旧号码
	//i tmpFMrNo'=tmpTMrNo d
	//.s flag=##class(web.DHCWMRNoCtl).SetMrNoByTypeNo(tmpFMrType,tmpFMrNo)
	//.i flag<0 TRollBack
	//q:flag<0 ret
	
	s ret=-5,flag=0
	;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
	s tmpVolId=0
	f  s tmpVolId=$o(^DHCWMRVOL(0,"Main",FromMainId,tmpVolId)) q:(tmpVolId="")||(flag<0)  d
	.s tmpVol=##class(web.DHCWMRVolumeCtl).GetVolume(+tmpVolId)
	.q:tmpVol=""
	.
	.s ret=-5.1
	.;作废卷原信息  DHC_WMR_VolInfo
	.;^DHCWMRVOLINFO(0,"VOL",{Volume_Dr},{Rowid})
	.s xVolInfoId=$o(^DHCWMRVOLINFO(0,"VOL",tmpVolId,0))
	.s xVolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfo(xVolInfoId)
	.s $p(xVolInfo,"^",24)="N"
	.s flag=##class(web.DHCWMRVolumeCtl).UpdateVolInfo(xVolInfo)
	.i flag<0 TRollBack
	.q:flag<0
	.
	.s ret=-5.2
	.;生成卷新信息  DHC_WMR_VolInfo
	.s yVolId=$o(^DHCWMRVOL(0,"Main",ToMainId,""),-1)
	.s yVolInfoId=$o(^DHCWMRVOLINFO(0,"VOL",yVolId,0))
	.s yVolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfo(yVolInfoId)
	.s $p(yVolInfo,"^",3)=NameSpell
	.s $p(yVolInfo,"^",26)=tmpVolId
	.s flag=##class(web.DHCWMRVolumeCtl).UpdateVolInfo(yVolInfo)
	.i flag<0 TRollBack
	.q:flag<0
	.
	.s ret=-5.3
	.;旧病案下的卷挂到新病案下
	.s $p(tmpVol,"^",2)=ToMainId
	.s $p(tmpVol,"^",7)=+$p(tmpVol,"^",7)
	.s flag=##class(web.DHCWMRVolumeCtl).UpdateVol(tmpVol)
	.i flag<0 TRollBack
	.
	.s ret=-5.4
	.;旧病案下的卷写一条日志,记录原来是哪份病案下的卷.
	.s tmpVolLog=tmpVolId_"^"_""_"^"_ToMainId_"^"_UserId_"^"_""_"^"_""
	.s flag=##class(web.DHCWMRVolumeCtl).UpdateVolLog(tmpVolLog)
	.i flag<0 TRollBack
	q:flag<0 ret
	
	TCommit
	s ret=1
	q ret
}

/// 转病案:
/// 建错的病案取消从新建病案
/// 一人多个卡,把旧卡的病案转到新卡下
/// 相应的修改接诊和取消接诊的程序
/// 病案实行强制转换
/// 
/// 旧病案的Papmi指针指向新病人
/// 旧病案对应的Papatmas/Paperson表中的病案号字段清除
/// 新病案对应的Papatmas/Paperson表中的病案号字段设置
/// 参数：
/// FromMainId     病案主表
/// ToPapmi        新卡基本信息Papmi
/// w ##Class(web.DHCWMRMRMerger).MRChange(19245,1)
ClassMethod MRChange(FromMainId, ToPapmi, NameSpell, UserId)
{
	n (FromMainId, ToPapmi, NameSpell,UserId)
	s ret=-1
	
	s tmpFMain=##class(web.DHCWMRMainCtl).GetMainById(FromMainId)
	q:tmpFMain="" ret
	s tmpFMrType=$p(tmpFMain,"^",2)
	q:tmpFMrType="" ret
	s tmpFMrNo=$p(tmpFMain,"^",3)
	s tmpFPapmi=+$p(tmpFMain,"^",4)
	s tmpFActive=$p(tmpFMain,"^",7)
	q:tmpFActive'="Y" ret
	
	s tmpMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(tmpFMrType)
	q:tmpMrType="" ret
	s MrNoField=$p($p(tmpMrType,"^",5),"/",2)
	q:MrNoField="" ret
	
	q:tmpFPapmi=ToPapmi 1
	
	q:'$d(^PAPER(ToPapmi)) ret
	
	TStart
	
	s ret=-2,flag=0
	;^DHCWMRVOL(0,"Main",{Main_Dr},{Rowid})
	s tmpVolId=0
	f  s tmpVolId=$o(^DHCWMRVOL(0,"Main",FromMainId,tmpVolId)) q:(tmpVolId="")||(flag<0)  d
	.s tmpVol=##class(web.DHCWMRVolumeCtl).GetVolume(+tmpVolId)
	.q:tmpVol=""
	.
	.s ret=-2.1
	.;作废卷原信息  DHC_WMR_VolInfo
	.;^DHCWMRVOLINFO(0,"VOL",{Volume_Dr},{Rowid})
	.s xVolInfoId=$o(^DHCWMRVOLINFO(0,"VOL",tmpVolId,0))
	.s xVolInfo=##class(web.DHCWMRVolumeCtl).GetVolInfo(xVolInfoId)
	.s $p(xVolInfo,"^",24)="N"
	.s flag=##class(web.DHCWMRVolumeCtl).UpdateVolInfo(xVolInfo)
	.i flag<0 TRollBack
	.q:flag<0
	.
	.s ret=-2.2
	.;生成卷新信息  DHC_WMR_VolInfo
	.s yVolInfo=##class(web.DHCWMRBaseInfoCtl).FormatBaseInfo(ToPapmi,"")
	.s $p(yVolInfo,"^",3)=NameSpell
	.s $p(yVolInfo,"^",26)=tmpVolId
	.s flag=##class(web.DHCWMRVolumeCtl).UpdateVolInfo(yVolInfo)
	.i flag<0 TRollBack
	q:flag<0 ret
	
	s ret=-3,flag=0
	;修改病案Papmi指针
    s $p(tmpFMain,"^",4)=ToPapmi
    //s:tmpFPapmi'="" $p(tmpFMain,"^",10)=$p(tmpFMain,"^",10)_" "_tmpFPapmi
    s flag=##class(web.DHCWMRMainCtl).UpdateMain(tmpFMain)
    i flag<0 TRollBack
    q:flag<0 ret
    
    s ret=-4,flag=0
	;清除旧病人基本信息表中的病案号
	i tmpFPapmi>0 d
	.s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA("",tmpFPapmi)
	.s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB("",tmpFPapmi)
	.;User.DHCPerson.PAPERSGMedicareCode1
	.s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC("",tmpFPapmi)
	.;User.DHCPerson.PAPERSGMedicareCode2
	.s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD("",tmpFPapmi)
	.i flag<0 d
	..TRollBack
	q:flag<0 ret
	
    s ret=-5,flag=0
	;设置新病人基本信息表中的病案号
	i ToPapmi>0 d
	.s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(tmpFMrNo,ToPapmi)
	.s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(tmpFMrNo,ToPapmi)
	.;User.DHCPerson.PAPERSGMedicareCode1
	.s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(tmpFMrNo,ToPapmi)
	.;User.DHCPerson.PAPERSGMedicareCode2
	.s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(tmpFMrNo,ToPapmi)
	.i flag<0 d
	..TRollBack
	q:flag<0 ret
	
	s ret=-6,flag=0
	;添加修改记录
	s tmpMainLog=FromMainId_"^^^"_tmpFPapmi_"^"_UserId_"^^"
	s flag=##Class(web.DHCWMRMainCtl).UpdateMainLog(tmpMainLog)
	.i flag<0 TRollBack
	q:flag<0 ret
	
	TCommit
	s ret=1
	q ret
}

/// Papmi
/// 
ClassMethod MRChangeToPatient(MrType, FMrNo, TPapmi, TNameSpell)
{
	n (MrType,FMrNo,TPapmi,TNameSpell)
	s ret=0
	q:(MrType="")||(FMrNo="")||(TPapmi="") ret
	
	s FMrNo=$$ALPHAUP^SSUTIL4($g(FMrNo))
	
	;^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
	q:'$d(^DHCWMRMAIN(0,"TypeNO",MrType,FMrNo)) ret
	s MainId=0
	f  s MainId=$o(^DHCWMRMAIN(0,"TypeNO",MrType,FMrNo,MainId)) q:MainId=""  d
	.s tmp=$g(^DHCWMRMAIN(MainId))
	.q:tmp=""
	.s tmpActive=$p(tmp,"^",6)
	.q:tmpActive'="Y"
	.s ret=..MRChange(MainId,TPapmi,TNameSpell)
	
	q ret
}

/// 修改病案号:
/// 修改病案中的病案号
/// 占用新号
/// 释放旧号
/// 病案对应的Papatmas/Paperson表中的病案号字段修改
/// 添加修改记录
/// 参数：
/// MrType   病案类型
/// OldNo    旧号
/// NewNo    新号
/// UserId   操作员
/// Ctloc    接诊室
/// w ##Class(web.DHCWMRMRMerger).MRNoUpdate(6,"TM000001","TM000001S",10,1007)
ClassMethod MRNoUpdate(MrType, OldNo, NewNo, UserId, Ctloc)
{
	n (MrType,OldNo,NewNo,UserId,Ctloc)
	s ret=0
	
	q:MrType="" ret
	q:(OldNo="")||(NewNo="") ret
	
	s OldNo=$$ALPHAUP^SSUTIL4($g(OldNo))
	s NewNo=$$ALPHAUP^SSUTIL4($g(NewNo))
	
	q:OldNo=NewNo ret
	
	;^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
	q:'$d(^DHCWMRMAIN(0,"TypeNO",MrType,OldNo)) ret
	s MainId=0,Flg=0
	f  s MainId=$o(^DHCWMRMAIN(0,"TypeNO",MrType,OldNo,MainId)) q:(MainId="")||(Flg=1)  d
	.s tmp=$g(^DHCWMRMAIN(MainId))
	.q:tmp=""
	.s tmpActive=$p(tmp,"^",6)
	.q:tmpActive'="Y"
	.s CurrMainId=MainId
	.s Flg=1
	
	;取病案关联的Papmi
	q:CurrMainId="" ret
	s tmpMain=##class(web.DHCWMRMainCtl).GetMainById(CurrMainId)
	q:tmpMain="" ret
	s tmpPapmi=$p(tmpMain,"^",4)
	
	;取病案类型设置
	s strMrType=##class(web.DHCWMRNoCtl).GetMrNoFormat(MrType)
	q:strMrType="" ret
	s MrNoField=$p($p(strMrType,"^",5),"/",2)
	q:MrNoField="" ret
	
	TStart
	
	s ret=-1,flag=0,MrNo=""
	;占用新号
	i $d(^DHCWMRNO(0,"TypeNo",MrType,NewNo)) d
	.s MrNoRowid=$o(^DHCWMRNO(0,"TypeNo",MrType,NewNo,""),-1)
	.s sWMRNo=##class(web.DHCWMRNoCtl).GetDataById(MrNoRowid)
	.i $p(sWMRNo,"^",4)="N" d
	..s xxMrNo=$p(sWMRNo,"^",3)
	..s xxMrNo=$$ALPHAUP^SSUTIL4($g(xxMrNo))
	..s flg=..IsCheckMrNo(MrNoField,xxMrNo)
	..s:flg>0 ret=-1.1                            ;已经用完 不可再用
	..s MrNo=xxMrNo
	.e  d
	..s $p(sWMRNo,"^",4)="N"
	..s $p(sWMRNo,"^",5)=Ctloc	                  ;所属接诊科室
	..s $p(sWMRNo,"^",6)=UserId	                  ;操作员
	..s $p(sWMRNo,"^",7)=$zd(+$h,3)	              ;发放日起
	..s $p(sWMRNo,"^",8)=$zt($p($h,",",2))	      ;发放时间
	..s flag=##class(web.DHCWMRNoCtl).Update(sWMRNo)
	..i flag<0 TRollBack
	..s MrNo=NewNo
	e  d
	.s ret=-1.2                       ;分配一个未入库的历史号码
	.s sWMRNo=""
	.s $p(sWMRNo,"^",2)=MrType	      ;病案类型
	.s $p(sWMRNo,"^",3)=NewNo	      ;病案号
	.s $p(sWMRNo,"^",4)="N"	          ;是否有效
	.s $p(sWMRNo,"^",5)=Ctloc	      ;所属接诊科室
	.s $p(sWMRNo,"^",6)=UserId	                  ;发放操作员
	.s $p(sWMRNo,"^",7)=$zd(+$h,3)	              ;发放日起
	.s $p(sWMRNo,"^",8)=$zt($p($h,",",2))	      ;发放时间
	.s flag=##class(web.DHCWMRNoCtl).Update(sWMRNo)
	.i flag<0 TRollBack
	.s MrNo=NewNo
	i MrNo="" TRollBack
	q:flag<0 ret
	
	s MrNo=$$ALPHAUP^SSUTIL4($g(MrNo))
	
	s ret=-2,flag=0
	;释放旧号
	//s flag=##class(web.DHCWMRNoCtl).SetMrNoByTypeNo(MrType,OldNo)
	//i flag<0 TRollBack
	//q:flag<0 ret
	
	s ret=-3,flag=0
	;修改病案中的新病案号
	i MrNo'="" d
    .s $p(tmpMain,"^",3)=MrNo
    .s flag=##class(web.DHCWMRMainCtl).UpdateMain(tmpMain)
    .i flag<0 TRollBack
    q:flag<0 ret
	
	s ret=-4,flag=0
	;病案对应的Papatmas/Paperson表中的病案号字段修改
	i +tmpPapmi>0 d
	.s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(MrNo,tmpPapmi)
	.s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(MrNo,tmpPapmi)
	.;User.DHCPerson.PAPERSGMedicareCode1
	.s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(MrNo,tmpPapmi)
	.;User.DHCPerson.PAPERSGMedicareCode2
	.s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(MrNo,tmpPapmi)
	.i flag<0 TRollBack
	q:flag<0 ret
	
	;添加修改记录
	s tmpMainLog=CurrMainId_"^^"_OldNo_"^^"_UserId_"^^"
	s flag=##Class(web.DHCWMRMainCtl).UpdateMainLog(tmpMainLog)
	.i flag<0 TRollBack
	q:flag<0 ret
	
	TCommit
	s ret=1
	q ret
}

//     A/B/C/D

ClassMethod IsCheckMrNo(cCode, cMrNo)
{
	n (cCode,cMrNo)
	s ret=0
	;^PAPERi("Govern",$$ALPHAUP({PAPMI_GovernCardNo})_"Z",{PAPMI_RowId})
	s:((cCode="A")&&$d(^PAPERi("Govern",cMrNo_"Z"))) ret=1
	;^PAPERi("Medicare1",$$ALPHAUP({PAPMI_Medicare}),{PAPMI_RowId})
	s:((cCode="B")&&$d(^PAPERi("Medicare1",cMrNo))) ret=1
	q ret
}

}
