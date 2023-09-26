Import SQLUser

/// 从HIS导入数据
Class web.DHCWMRReceiptFromHIS Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 112;

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
///   paadm        ： 历史就诊 DHC_WMR_HistoryAdm.Rowid
///   MainRowid    :  DHC_WMR_Main.Rowid 使用旧号码  如为空，则分配新号码
///   ctloc        ： 接诊室 Ct_Loc.Rowid
///   NameSpell    :  病人姓名的拼音
///   patcond      :  入院时情况  MRC_PatientCondition.Rowid
///   OldNo        :  分配一个未入库的历史号码
///   UserId       ： 接诊操作员Rowid   
///   BuildDate    :  建病案日期
///   IPCount      :  住院次数－－本次住院是第几次住院
/// 返回值         ： ret=VolRowid 成功    ret<0 失败
/// *****************************************************************
/// w ##Class().Receipt(6,1004,1,"",1007,"","",C000007,1)
ClassMethod Receipt(MrType, papmi, paadm, MainRowid, ctloc, NameSpell, patcond, OldNo, UserId, BuildDate, IPCount)
{
	n (MrType,papmi,paadm,MainRowid,ctloc,NameSpell,patcond,OldNo,UserId,BuildDate,IPCount)
	s ret=-1
	q:(MrType="")||(papmi="")||(paadm="") ret
	q:(MainRowid="")&&(ctloc="") ret
	
	s xpapmi=papmi
	
	;取流的第一个操作项目
	s ret=-1.1
	s ItemDr=$$GetWorkFlow(MrType)
	q:ItemDr="" ret
	
	;取病案类型设置
	s ret=-1.2
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
	s MrNo=$$ALPHAUP^SSUTIL4($g(MrNo))    //add by zf 2008-04-14
	i MainRowid="" d         ;分配新号码
	.i OldNo="" d
	..s ret=-2.1                ;更新病案号码发放
	..s sMrNo=##class(web.DHCWMRNoCtl).GetMrNoByLoc(MrType,ctloc)
	..i sMrNo="" TRollBack
	..s:sMrNo="" NoFlag=-1111
	..s MrNo=sMrNo     ;$p(sMrNo,"^",3)
	.e  d 
	..;i $d(^DHCWMRMAIN(0,"TypeNO",MrType,OldNo)) d
	..s ret=-2.2
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
	...i NoFlag<0 TRollBack
	...s MrNo=OldNo
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
	
	s ret=-3
	;生成病案信息
	i MainRowid="" d
	.s sMain=""
	.s $p(sMain,"^",2)=MrType
	.s $p(sMain,"^",3)=MrNo
	.s $p(sMain,"^",4)=xpapmi
	.s $p(sMain,"^",7)="Y"
	.s $p(sMain,"^",8)="Y"
	.s $p(sMain,"^",9)=BuildDate      //Add by wuqk 取建病案日期
	e  d
	.s sMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
	.s MrNo=$p(sMain,"^",3)
	i sMain="" TRollBack
	q:sMain="" ret
	s ret=-3.1
	s $p(sMain,"^",4)=xpapmi
	s MainRowid=##class(web.DHCWMRMainCtl).UpdateMain(sMain)
	i +MainRowid<0 TRollBack
	q:+MainRowid<0 ret
	
	s ret=-4
	;生成卷信息
	s sVolume=""
	s $p(sVolume,"^",2)=+MainRowid
	;s $p(sVolume,"^",3)=+paadm
	s $p(sVolume,"^",4)=+paadm          ;HistroyAdm_Dr
	s $p(sVolume,"^",7)=ItemDr          ;病案操作项目/状态
	s $p(sVolume,"^",8)="Y"
	s $p(sVolume,"^",9)="Y"
	;Add by wuqk 2008-07-05  病案卷表ResumeText字段存储住院次数
	s $p(sVolume,"^",10)=##Class(web.DHCWMRReceipt).GetIPCount("",MainRowid)
	s VolRowid=##class(web.DHCWMRVolumeCtl).UpdateVol(sVolume)
	i +VolRowid<0 TRollBack
	q:+VolRowid<0 ret
	
	s ret=-4.1
	;生成卷病案号更改列表
	s sVolLog=""
	s $p(sVolLog,"^",1)=VolRowid
	s $p(sVolLog,"^",3)=+MainRowid
	s $p(sVolLog,"^",4)=UserId          ;User
	s VolLogRowid=##class(web.DHCWMRVolumeCtl).UpdateVolLog(sVolLog)
	i +VolLogRowid<0 TRollBack
	q:+VolLogRowid<0 ret
	
	/*
	s ret=-4
	;生成卷就诊列表信息   DHC_WMR_VolAdm
	s sVolAdm=""
    s $p(sVolAdm,"^",1)=VolRowid
    s $p(sVolAdm,"^",3)=paadm
	s VolAdmRowid=##class(web.DHCWMRVolumeCtl).UpdateVolAdm(sVolAdm)
	i +VolAdmRowid<0 TRollBack
	q:+VolAdmRowid<0 ret
	*/
	
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
	s sVolInfo=..FormatBaseInfo(xpapmi,"")
	s $p(sVolInfo,"^",3)=NameSpell
	s $p(sVolInfo,"^",26)=VolRowid
	s VolInfoRowid=##class(web.DHCWMRVolumeCtl).UpdateVolInfo(sVolInfo)
	i +VolInfoRowid<0 TRollBack
	q:+VolInfoRowid<0 ret
	
	/*
	s ret=-7
	s flag=0
	;更新入院时情况(病人入院状态--平稳/病重/病危)
	s:patcond'="" flag=##class(web.DHCWMRBasePaadm).UpdateAdmPatCond(paadm,patcond)
	i flag'=0 TRollBack
	q:flag'=0 ret
	*/
	
	s ret=-8
	;更新病案号
	s flag=0	
	;paperson.paper_governcardno
	s:MrNoField="A" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoA(MrNo,papmi)
	;PA_PatMas.PAPMI_Medicare
	s:MrNoField="B" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoB(MrNo,papmi)
	;User.DHCPerson.PAPERSGMedicareCode1
	s:MrNoField="C" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoC(MrNo,papmi)
	;User.DHCPerson.PAPERSGMedicareCode2
	s:MrNoField="D" flag=##class(web.DHCWMRMedBaseCtl).UpdateMrNoD(MrNo,papmi)
	i flag'=0 TRollBack
	q:flag'=0 ret
	
	TCommit
	s ret=VolRowid
	q ret
GetWorkFlow(MrType)
    n (MrType)
    s sFlow=##class(web.DHCWMRWorkFlowCtl).GetWFLByTypeActiveDate(MrType,"Y",$zd(+$h,3))
    s ItemDr=""
    q:sFlow="" ItemDr
    s len=$l(sFlow,$c(1))
    ;最后一个状态
    s sTmp=$p(sFlow,$c(1),len)
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

ClassMethod LoadHISMrNo(PatientId, NameSpell)
{
	n (PatientId,NameSpell)
	
	s xPatientId=PatientId
	s MrType=""
	f  s MrType=$o(^DHCWMRDIC(0,"DicName","MrType","Y",MrType)) q:MrType=""  d
	.q:MrType'=6
	.s MrNo=##class(web.DHCWMRMedBaseCtl).GetHISMrNo(PatientId,MrType)
	.s MrNo=$tr(MrNo,$c(0),"")
	.q:MrNo=""
	.i (PatientId<5000)&&(MrNo'="") d
	..s MrNo="TM"
	..s ^DHCWMRTEMP("TEST")=+$G(^DHCWMRTEMP("TEST"))+1
	..s tmpMrNo=+$G(^DHCWMRTEMP("TEST"))
	..s $p(MrNo,"0",7-$l(tmpMrNo))=tmpMrNo
	.e  d
	..s MrNo=$$ALPHAUP^SSUTIL4($g(MrNo))    //add by zf 2008-04-14
	..s:MrNo'["M" ^DHCWMRTEMP("MrNoErr",xPatientId,MrType,MrNo)=""
	..s:MrNo'["M" MrNo=""
	.q:MrNo=""
	.
	.s flag=0
	.i $d(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo)) d
	..s MrMainRowid=$o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,""))
	..s mrPapmi=$p($g(^DHCWMRMAIN(+MrMainRowid)),"^",3)
	..s:(mrPapmi'="")&&(mrPapmi'=PatientId) flag=1
	.i flag d
	..s index=0
	..i '$d(^DHCWMRTEMP("MainErr",MrType,MrNo))  d
	...s ^DHCWMRTEMP("MainErr",MrType,MrNo,index)=..BuildMrError(mrPapmi)
	..s index=$o(^DHCWMRTEMP("MainErr",MrType,MrNo,""),-1)
	..s index=index+1
	..s ^DHCWMRTEMP("MainErr",MrType,MrNo,index)=..BuildMrError(xPatientId)
	.q:flag
	.;Receipt(MrType, papmi, paadm, MainRowid, ctloc, NameSpell, patcond, OldNo, UserId)
	.s ret=..Receipt(MrType,PatientId,1,"",1007,NameSpell,"",MrNo,1)
	.s:ret<0 ^DHCWMRTEMP("ReceiptErr",PatientId,MrType,MrNo)=ret
	.s ^DHCWMRTEMP("ReceiptCount")=+$g(^DHCWMRTEMP("ReceiptCount"))+1
	q 0
}

ClassMethod BuildMrError(yPatientId)
{
	n (yPatientId)
	s papmino=$p(^PAPER(yPatientId,"PAT",1),"^",1)
	s name=$p($g(^PAPER(yPatientId,"ALL")),"^",1)
	s birth=$p($g(^PAPER(yPatientId,"ALL")),"^",6)
	i birth'="" s birthdate=$zd(birth,3)
	s error=yPatientId_"  "_papmino_"  "_name_"  "_birthdate
	q error
}

/// w ##Class(web.DHCWMRReceiptFromHIS).LoadMrData("")
ClassMethod LoadMrData(PatientId)
{
	n (PatientId)
	
	i PatientId="" d
	.s count=0
	.;s PatientId=+$g(^DHCWMRTEMP("FromPapmi")),ToPapmi=+$g(^DHCWMRTEMP("ToPapmi"))
	.s PatientId=0,ToPapmi=110134
    .f  s PatientId=$o(^PAPER(PatientId))  q:(PatientId="")||(PatientId>ToPapmi)  d
    ..;s PatName=$p($g(^DHCWMRTEMP("NameSpell",PatientId)),"^",1)
    ..;s NameSpell=$p($g(^DHCWMRTEMP("NameSpell",PatientId)),"^",2)
    ..;s xPatName=$p($g(^PAPER(PatientId,"ALL")),"^",1)
    ..;s:xPatName'=PatName ^DHCWMRTEMP("NameChange",PatientId)=xPatName_"^"_PatName_"^"_NameSpell
    ..;s:NameSpell="" ^DHCWMRTEMP("NameSpellNull",PatientId)=xPatName_"^"_PatName_"^"_NameSpell
    ..;q:xPatName'=PatName
    ..;q:NameSpell=""
    ..;s ret=..LoadHISMrNo(PatientId,NameSpell)
    ..s ret=..LoadDTHISMrNo(PatientId)
    ..s count=count+1
    ..w:(count#1000)=0 !!,PatientId_"  "_count_"....."
    q "Over Load Mr Date."
}

///     清妇产测试病人的东院病案号(门诊/住院)
///     select count(*) from pa_patmas where PAPMI_No<"00001001" and PAPMI_No>"0000000"
///     Update pa_patmas(PAPMI_Medicare) values("") where PAPMI_No<"00001001" and PAPMI_No>"0000000"
///     select count(*) from paperson where PAPER_PAPMI_DR->PAPMI_No<"00001001" and PAPER_PAPMI_DR->PAPMI_No>"0000000"
///     Update paperson(paper_governcardno) values("") where PAPER_PAPMI_DR->PAPMI_No<"00001001" and PAPER_PAPMI_DR->PAPMI_No>"0000000"
/// w ##Class(web.DHCWMRReceiptFromHIS).GetPatInfoTMP(xPapmi)
ClassMethod GetPatInfoTMP(xPapmi)
{
	n (xPapmi)
	s ret=""
	q:xPapmi="" ret
	q:'$d(^PAPER(xPapmi)) ret
	
	s ProvinceDesc="",CityBirthDesc="",DeptDesc="",SocialDESC="",PatCategoryDesc=""
	s PAPMIRowId=+xPapmi
	s regno=$p(^PAPER(PAPMIRowId,"PAT",1),"^",1)
	s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","I",-1))
	i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","O",-1))
	i paadmID="" s paadmID=$o(^PAPERdr(PAPMIRowId,"ADM","E",-1))
	i paadmID'="" d
	.s admDate=$p(^PAADM(paadmID),"^",6)
	.i admDate'="" s admDate=$zd(admDate,3)
	.s DepCodeDR=$p(^PAADM(paadmID),"^",4)
	.s DeptDesc=$p($g(^CTLOC(+DepCodeDR)),"^",2)
	.s DepCodeDR=+DepCodeDR
	.i $g(DeptDesc)["-" s DeptDesc=$p(DeptDesc,"-",2)
	.s curdepdr=$P($g(^CTLOC(DepCodeDR)),"^",19)
	.s curdepdrdesc=$p(^RBC("DEP",+curdepdr),"^",2)
	s name=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",1)
	s sex=$p($g(^CT("SEX",$p($g(^PAPER(PAPMIRowId,"ALL")),"^",7))),"^",2)
	s today=$p($h,",",1)
	s birth=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",6)
	i birth'="" s birthdate=$zd(birth,3)
	s age=##Class(web.DHCWMRMedBaseCtl).CalAge(birth,today)
	s SocialStatusDR=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",10)
	s SocialStatusDR=+SocialStatusDR
	i SocialStatusDR=0  d
	.s SocialDESC="3自费医疗"
	e  d
	.s SocialDESC=$p($g(^CT("SS",SocialStatusDR)),"^",2)
	.i (SocialDESC'["医疗保险")&(SocialDESC'["公费医疗") d
	..s SocialDESC="3自费医疗"
	s ProvinceDR=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",11)
	s ProvinceDR=+ProvinceDR        
	i ProvinceDR'=0 s ProvinceDesc=$p(^CT("PROV",ProvinceDR),"^",2)
	i ProvinceDesc["-" s ProvinceDesc=$p(ProvinceDesc,"-",2)
	s GovernCardNo= $p($g(^PAPER(PAPMIRowId,"PER",4)),"^",4) 
	s SecondAddress=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",18) 
	s CityBirthDR=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",18)
	s CityBirthDR=+CityBirthDR
	i CityBirthDR'=0 s CityBirthDesc=$p(^CT("CIT",CityBirthDR),"^",2)
	i $g(CityBirthDesc)["-" s CityBirthDesc=$p(CityBirthDesc,"-",2)
	;i (argdepartID'="")&(argdepartID'=curdepdr) s P6=2
	;q:(P6=2) $g(curdepdrdesc)
	s papmiId=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",9)
	s papersonGX=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",4)
	s papersonGXAdress=$p($g(^PAPER(PAPMIRowId,"ALL")),"^",5)
	s papersonGXman=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",1)
	s papersonGXTel=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",8)
	s Marital=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",3)
	i Marital'="" s MaritalDesc=$p(^CT("MAR",+Marital),"^",2) 
	s nationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",1)
	i nationdr'="" s nationDesc=$p(^CT("NAT",+nationdr),"^",2) 
	i $g(nationDesc)'="" d
	.i nationDesc["-" s nationDesc=$p(nationDesc,"-",2)
	s telphone=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",11)
	s educationdr=$p($g(^PAPER(PAPMIRowId,"PER",2)),"^",5)
	i educationdr'="" s educationDesc=$p(^CT("EDU",+Marital),"^",2) 
	i $d(^PAPER(PAPMIRowId,"PER","ADD",1))'=0 d 
	.s workAdress= $g(^PAPER(PAPMIRowId,"PER","ADD",1))   ;同MEM
	;PAC_PatientCategory
	s PatCategoryDR=$p($g(^PAPER(PAPMIRowId,"PAT",1)),"^",8) 
	s PatCategoryDR=+PatCategoryDR
	i PatCategoryDR'=0 s PatCategoryDesc=$p(^PAC("PCAT",PatCategoryDR),"^",2 )
	s countrydr=$p($g(^PAPER(PAPMIRowId,"PER",1)),"^",8)
	i countrydr'="" s countryDesc=$p(^CT("COU",+countrydr),"^",2) 
	i $g(ProvinceDesc)=$g(CityBirthDesc) s CityBirthDesc=""
	s gvCardNo=$p($g(^PAPER(PAPMIRowId,"PER",4)),"^",4) 
	s countryDesc=$g(countryDesc)
	s gvCardNo=$g(gvCardNo)
	s s=$g(name)_$c(2)_$g(sex)_$c(2)_$g(birthdate)_$c(2)_$g(age)_$c(2)_$g(papmiId)_$c(2)_$g(ProvinceDesc)_$g(CityBirthDesc)_$c(2)_$g(MaritalDesc)_$c(2)_$g(nationDesc)_$c(2)_$g(telphone)_$c(2)_$g(educationDesc)_$c(2)_$g(workAdress)_$c(2)_$g(papersonGX)_$c(2)_$g(papersonGXAdress)_$c(2)_$g(papersonGXman)_$c(2)_$g(papersonGXTel)_$c(2)_$g(PatCategoryDesc)_$c(2)_$g(DeptDesc)_$c(2)_$g(SecondAddress)_$c(2)_countryDesc_$c(2)_gvCardNo_$c(2)_$g(SocialDESC)_$c(2)_PAPMIRowId_$c(2)_regno
	;s s=$g(name)_$c(2)_$g(sex)_$c(2)_$g(birthdate)_$c(2)_$g(age)_$c(2)_$g(papmiId)_$c(2)_$g(ProvinceDesc)_$g(CityBirthDesc)_$c(2)_$g(MaritalDesc)_$c(2)_$g(nationDesc)_$c(2)_$g(telphone)_$c(2)_$g(educationDesc)_$c(2)_$g(workAdress)_$c(2)_$g(papersonGX)_$c(2)_$g(papersonGXAdress)_$c(2)_$g(papersonGXman)_$c(2)_$g(papersonGXTel)_$c(2)_$g(PatCategoryDesc)_$c(2)_$g(DeptDesc)_$c(2)_$g(SecondAddress)_$c(2)_""_$c(2)_""_$c(2)_$g(SocialDESC)_$c(2)_PAPMIRowId_$c(2)_regno
	q s
}

ClassMethod FormatBaseInfo(Papmi, MainRowid)
{
    n (Papmi,MainRowid)
    ;s sPapmi=$$GetPatInfo^DHCWMRMedBase(+Papmi)
    s sPapmi=..GetPatInfoTMP(+Papmi)
    s PatName=$p(sPapmi,$c(2),1)
    s NameSpell=""
    ;s:PatName="" NameSpell=..GetNameSpell(PatName)
    ;s:NameSpell="" NameSpell=PatName
    ;s NameSpell=$$ALPHAUP^SSUTIL4(NameSpell)
    s sBaseInfo=""
    s $p(sBaseInfo,"^",1)=""                     ;Rowid/DHC_WMR_HistoryRowID    
    s $p(sBaseInfo,"^",2)=$p(sPapmi,$c(2),1)     ;PatientName/病人姓名          
    s $p(sBaseInfo,"^",3)=NameSpell              ;NameSpell/姓名拼音码          
    s $p(sBaseInfo,"^",4)=$p(sPapmi,$c(2),2)     ;Sex/性别                      
    s $p(sBaseInfo,"^",5)=$p(sPapmi,$c(2),3)     ;Birthday/生日                 
    s $p(sBaseInfo,"^",6)=$p(sPapmi,$c(2),4)     ;Age/年龄                      
    s $p(sBaseInfo,"^",7)=$p(sPapmi,$c(2),7)     ;Wedlock/婚姻                  
    s $p(sBaseInfo,"^",8)=$p(sPapmi,$c(2),16)    ;Occupation/职业               
    s $p(sBaseInfo,"^",9)=$p(sPapmi,$c(2),6)     ;City/出生市                   
    s $p(sBaseInfo,"^",10)=""                     ;County/出生县                 
    s $p(sBaseInfo,"^",11)=$p(sPapmi,$c(2),8)     ;Nation/民族                   
    s $p(sBaseInfo,"^",12)=$p(sPapmi,$c(2),19)    ;Nationality/国籍              
    s $p(sBaseInfo,"^",13)=$p(sPapmi,$c(2),5)     ;IdentityCode/身份证号         
    s $p(sBaseInfo,"^",14)=$p(sPapmi,$c(2),11)    ;Company/工作单位              
    s $p(sBaseInfo,"^",15)=$p($g(^PAPER(Papmi,"PER",4)),"^",18)  ;CompanyTel/工作单位电话       PAPER_SecondPhone
    s $p(sBaseInfo,"^",16)="" ;$p(sPapmi,$c(2),)  ;CompanyZip/工作单位邮编       
    s $p(sBaseInfo,"^",17)=$p(sPapmi,$c(2),18)    ;HomeAddress/家庭住址          
    s $p(sBaseInfo,"^",18)=$p(sPapmi,$c(2),9)     ;HomeTel/家庭电话              
    s $p(sBaseInfo,"^",19)=##Class(web.DHCWMRBaseInfoCtl).GetHomeZip(Papmi)  ;HomeZip/家庭邮编              
    s $p(sBaseInfo,"^",20)=$p(sPapmi,$c(2),12)    ;RelationDesc/与联系人关系     
    s $p(sBaseInfo,"^",21)=$p(sPapmi,$c(2),14)    ;RelativeName/联系人           
    s $p(sBaseInfo,"^",22)=$p(sPapmi,$c(2),15)    ;RelativeTel/联系人电话        
    s $p(sBaseInfo,"^",23)=$p(sPapmi,$c(2),13)    ;RelativeAddress/联系人地址    
    s $p(sBaseInfo,"^",24)="Y"                    ;IsActive/是否有效             
    s $p(sBaseInfo,"^",25)=""                     ;ResumeText/备注   
    s $p(sBaseInfo,"^",26)=$p(sPapmi,$c(2),22)    ;Papmi
    s $p(sBaseInfo,"^",27)=$p(sPapmi,$c(2),23)    ;PatitneNO
    q sBaseInfo
}

/// 取病人姓名的全拼音
ClassMethod GetPatBaseData(PatientId)
{
	n (PatientId)
	s ret=""
	s PatientId=$g(^DHCWMRTEMP("CurrPapmi"))
	q:PatientId="" ret
	s Papmi=$o(^PAPER(PatientId))
	q:Papmi="" ret
	s tmp=+$g(^DHCWMRTEMP("ToPapmi"))
	q:Papmi>tmp ret
	s PatName=$p($g(^PAPER(+Papmi,"ALL")),"^",1)
	s ret=Papmi_"^"_PatName
	q ret
}

/// 取病人姓名的全拼音
ClassMethod LoadPatMrData(PatientId, NameSpell)
{
	n (PatientId,NameSpell)
	s:NameSpell="" ^DHCWMRTEMP("NameSpellNull",PatientId)=""
	;s ret=..LoadHISMrNo(PatientId,NameSpell)
	s ret=0
	s PatName=$p($g(^PAPER(+PatientId,"ALL")),"^",1)
	s ^DHCWMRTEMP("NameSpell",PatientId)=PatName_"^"_NameSpell
	s ^DHCWMRTEMP("CurrPapmi")=PatientId
	s ^DHCWMRTEMP("CurrCount")=+$g(^DHCWMRTEMP("CurrCount"))+1
	s count=+$g(^DHCWMRTEMP("CurrCount"))
	s:(count-((count\1000)*1000))=0 ret="已经处理"_count_"条Papatmas数据....."
	q ret
}

ClassMethod LoadDTHISMrNo(PatientId)
{
    n (PatientId)
	
	s MrType=""
	f  s MrType=$o(^DHCWMRDIC(0,"DicName","MrType","Y",MrType)) q:MrType=""  d
	.q:MrType>7
	.;q:MrType'=6
	.s MrNo=##class(web.DHCWMRMedBaseCtl).GetHISMrNo(PatientId,MrType)
	.;s MrNo=$tr(MrNo,$c(0),"")
	.q:MrNo=""
	.s MrNo=$$ALPHAUP^SSUTIL4(MrNo)
	.s flag=0
	.i $d(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo)) d
	..s MrMainRowid=$o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,""))
	..s mrPapmi=$p($g(^DHCWMRMAIN(+MrMainRowid)),"^",3)
	..s:(mrPapmi'="")&&(mrPapmi'=PatientId) flag=1
	.;b
	.i flag d
	..s index=0
	..i '$d(^TempWMRMainERROR(MrType,MrNo))  d
	...s ^TempWMRMainERROR(MrType,MrNo,index)=..BuildMrError(mrPapmi)
	..s index=$o(^TempWMRMainERROR(MrType,MrNo,""),-1)
	..s index=index+1
	..s ^TempWMRMainERROR(MrType,MrNo,index)=..BuildMrError(PatientId)
	.q:flag
	.;Receipt(MrType, papmi, paadm, MainRowid, ctloc, NameSpell, patcond, OldNo, UserId)
	.;w MrNo_" "
	./*read data for DiTan Hospital 2008-04-29*/
	.q:'$d(^DHCWMRTempData(MrType,MrNo))
	.s NameSpell=$g(^DHCWMRTempData(MrType,MrNo,"NameSpell"))
	.;如果没有就诊信息，取历史第一卷作为就诊信息，分配病案号
	.if '$d(^DHCWMRTempData(MrType,MrNo,0)) d
	..s HisAdmRowId=$o(^DHCWMRHISADM(0))
	..s ret=..Receipt(MrType,PatientId,HisAdmRowId,"",1,NameSpell,"",MrNo,1,"","")
	..s VolRowid=+ret
    ..i VolRowid'>0 d 
    ...s ^TempWMRMainERROR(MrType,MrNo,0)="VolRowid=‘"_VolRowid_"’ "_MrType_"  "_MrNo_" PatientId="_PatientId_" HisAdmRowId="_HisAdmRowId
    ..q:VolRowid'>0
    ..s tmpMainRowid=$p($g(^DHCWMRVOL(VolRowid)),"^",1)
    ..s ^DHCWMRTempData(MrType,MrNo,"MainId")=tmpMainRowid
	.s index=""
	.f  s index=$o(^DHCWMRTempData(MrType,MrNo,0,index)) q:index=""  d
	..s AdmData=$g(^DHCWMRTempData(MrType,MrNo,0,index))
	..s BuildDate=$p(AdmData,"^",3)
	..s:BuildDate'["-" BuildDate=""
	..s:$p(BuildDate,"-",3)>31 $p(BuildDate,"-",3)=30
	..s $p(AdmData,"^",3)=BuildDate
	..s DisDate=$p(AdmData,"^",7)
	..s:DisDate'["-" DisDate=""
	..s:$p(DisDate,"-",3)>31 $p(DisDate,"-",3)=30
	..s $p(AdmData,"^",7)=DisDate
	..s MainRowid=$g(^DHCWMRTempData(MrType,MrNo,"MainId"))
	..if MainRowid'="" d
	...s:'$d(^DHCWMRMAIN(MainRowid)) MainRowid=""
	..TStart
	..s HisAdmRowId=##class(web.DHCWMRHistoryCtl).UpdateAdm(AdmData)
	..if HisAdmRowId'>0 TRollBack
	..if HisAdmRowId>0 TCommit
	..i HisAdmRowId'>0 d 
	...s ^TempWMRMainERROR(MrType,MrNo,index)="HisAdmRowId=‘"_HisAdmRowId_"’ "_MrType_"  "_MrNo_" PatientId="_PatientId
	..s IPCount=+$p(AdmData,"^",13)     ;Add by wuqk 2008-07-05  住院次数
	..s ret=..Receipt(MrType,PatientId,HisAdmRowId,MainRowid,1,NameSpell,"",MrNo,1,BuildDate,IPCount)
	..s VolRowid=+ret
    ..i VolRowid'>0 d 
    ...s ^TempWMRMainERROR(MrType,MrNo,index)="VolRowid=‘"_VolRowid_"’ "_MrType_"  "_MrNo_" PatientId="_PatientId_" HisAdmRowId="_HisAdmRowId
    ..q:VolRowid'>0
    ..s tmpMainRowid=$p($g(^DHCWMRVOL(VolRowid)),"^",1)
    ..s ^DHCWMRTempData(MrType,MrNo,"MainId")=tmpMainRowid
	q 0
}

/// d ##class(web.DHCWMRReceiptFromHIS).LoadDTHISMrNoNew()
ClassMethod LoadDTHISMrNoNew()
{
 k ^DHCWMRRecErr($ZN)
 s MrType="",count=0,AdmCount=0
 f  s MrType=$o(^DHCWMRTempData(MrType)) q:MrType=""  d
 .s MrNo=""
 .f  s MrNo=$o(^DHCWMRTempData(MrType,MrNo)) q:MrNo=""  d
 ..s NameSpell=$g(^DHCWMRTempData(MrType,MrNo,"NameSpell"))
 ..s PatientId=$g(^DHCWMRTempData(MrType,MrNo,"PatId"))
 ..;s MainRowid=$g(^DHCWMRTempData(MrType,MrNo,"MainId"))
 ..i PatientId="" d BuildErr("PatientId＝‘’ "_MrType_"  "_MrNo) q
 ..s count=count+1
 ..w !,count_"...."
 ..s index=0
 ..f  s index=$o(^DHCWMRTempData(MrType,MrNo,0,index)) q:index=""  d
 ...s AdmData=$g(^DHCWMRTempData(MrType,MrNo,0,index))
 ...s BuildDate=$p(AdmData,"^",3)
 ...s:BuildDate'["-" BuildDate=""
 ...s:$p(BuildDate,"-",3)>31 $p(BuildDate,"-",3)=30
 ...s $p(AdmData,"^",3)=BuildDate
 ...s DisDate=$p(AdmData,"^",7)
 ...s:DisDate'["-" DisDate=""
 ...s:$p(DisDate,"-",3)>31 $p(DisDate,"-",3)=30
 ...s $p(AdmData,"^",7)=DisDate
 ...s HisAdmRowId=+##class(web.DHCWMRHistoryCtl).UpdateAdm(AdmData)
 ...i HisAdmRowId'>0 d BuildErr("HisAdmRowId=‘"_HisAdmRowId_"’ "_MrType_"  "_MrNo_" "_index) q
 ...q:HisAdmRowId<0
 ...s MainRowid=$g(^DHCWMRTempData(MrType,MrNo,"MainId"))
 ...s ret=..Receipt(MrType,PatientId,HisAdmRowId,MainRowid,1,NameSpell,"",MrNo,1,BuildDate)
 ...s AdmCount=AdmCount+1
 ...s VolRowid=+ret
 ...i VolRowid'>0 d BuildErr("VolRowid=‘"_VolRowid_"’ "_MrType_"  "_MrNo_" "_index) q
 ...s MainRowid=$p($g(^DHCWMRVOL(VolRowid)),"^",1)
 ...s ^DHCWMRTempData(MrType,MrNo,"MainId")=MainRowid
 q
BuildErr(s)
 n (s)
 s num=$g(^DHCWMRRecErr($ZN))+1
 s ^DHCWMRRecErr($ZN)=num
 s ^DHCWMRRecErr($ZN,num)=s
 w !,s
 q
}

/// 再次倒入错误信息
/// d ##class(web.DHCWMRReceiptFromHIS).LoadErr()
ClassMethod LoadErr()
{
   ;^TempWMRMainERROR(MrType,MrNo,index)
   s MrType=""
   f  s MrType=$o(^TempWMRMainERROR(MrType)) q:MrType=""  d
   .s MrNo=""
   .f  s MrNo=$o(^TempWMRMainERROR(MrType,MrNo)) q:MrNo=""  d
   ..s index=0
   ..f  s index=$o(^TempWMRMainERROR(MrType,MrNo,index)) q:index=""  d
   ...s NameSpell=$g(^DHCWMRTempData(MrType,MrNo,"NameSpell"))
   ...s PatientId=$g(^DHCWMRTempData(MrType,MrNo,"PatId"))
   ...s AdmData=$g(^DHCWMRTempData(MrType,MrNo,0,index))
   ...s BuildDate=$p(AdmData,"^",3)
   ...s:BuildDate'["-" BuildDate=""
   ...s:$p(BuildDate,"-",3)>31 $p(BuildDate,"-",3)=30
   ...s $p(AdmData,"^",3)=BuildDate
   ...s DisDate=$p(AdmData,"^",7)
   ...s:DisDate'["-" DisDate=""
   ...s:$p(DisDate,"-",3)>31 $p(DisDate,"-",3)=30
   ...s $p(AdmData,"^",7)=DisDate
   ...;Tstart
   ...s HisAdmRowId=##class(web.DHCWMRHistoryCtl).UpdateAdm(AdmData)
   ...;if HisAdmRowId'>0 TRollBack
   ...;if HisAdmRowId>0 TCommit
   ...q:HisAdmRowId'>0
   ...s ret=..Receipt(MrType,PatientId,HisAdmRowId,"",1,NameSpell,"",MrNo,1,BuildDate)
   ...q:+ret'>0
   ...k ^TempWMRMainERROR(MrType,MrNo,index)
   q
}

/// 清除错误信息
/// d ##class(web.DHCWMRReceiptFromHIS).KillErr()
ClassMethod KillErr()
{
	
   s MrType=""
   f  s MrType=$o(^TempWMRMainERROR(MrType)) q:MrType=""  d
   .s MrNo=""
   .f  s MrNo=$o(^TempWMRMainERROR(MrType,MrNo)) q:MrNo=""  d
   ..s tmp=$g(^TempWMRMainERROR(MrType,MrNo))
   ..Kill:$p(tmp,"  ",1)<1178894 ^TempWMRMainERROR(MrType,MrNo)
   q
}

/// 再次导入地坛病案历史信息
/// ^DHCWMRMRADM(Papmi,AdmType,"ADM",Ind)=AdmData
/// ^DHCWMRMRADM(Papmi,AdmType,"MRNO")=MRNO
ClassMethod LoadDTHISMRNEXT(TMP)
{
	n (TMP)
	s Papmi=0,MrType="",MrNo="",MainId=""
	f  s Papmi=$o(^DHCWMRMRADM(Papmi)) q:Papmi=""  d
	.s AdmType=""
	.f  s AdmType=$o(^DHCWMRMRADM(Papmi,AdmType)) q:AdmType=""  d
	..s:AdmType="I" MrType=7
	..s:AdmType="O" MrType=6
	..s MrNo=$g(^DHCWMRMRADM(Papmi,AdmType,"MRNO"))
	..q:(MrNo="")||(MrType="")
	..;^DHCWMRMAIN(0,"TypeNO",{MrType_Dr},{MRNO},{Rowid})
	..q:'$d(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo))
	..s tmpId=""
	..f  s tmpId=$o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,tmpId)) q:(tmpId="")||(MainId'="")  d
	...q:'$d(^DHCWMRMAIN(tmpId))
	...q:$p($g(^DHCWMRMAIN(tmpId)),"^",6)'="Y"
	...s MainId=tmpId
	..s Ind=0
	..f  s Ind=$o(^DHCWMRMRADM(Papmi,AdmType,Ind)) q:Ind=""  d
	...s AdmData=$g(^DHCWMRMRADM(Papmi,AdmType,Ind))
	...s BuildDate=$p(AdmData,"^",3)
	...s:BuildDate'["-" BuildDate=""
	...s:$p(BuildDate,"-",3)>31 $p(BuildDate,"-",3)=30
	...s $p(AdmData,"^",3)=BuildDate
	...s DisDate=$p(AdmData,"^",7)
	...s:DisDate'["-" DisDate=""
	...s:$p(DisDate,"-",3)>31 $p(DisDate,"-",3)=30
	...s $p(AdmData,"^",7)=DisDate
	...s HisAdmRowId=+##class(web.DHCWMRHistoryCtl).UpdateAdm(AdmData)
	...i HisAdmRowId'>0 d BuildErr("HisAdmRowId=‘"_HisAdmRowId_"’ "_MrType_"  "_MrNo_" "_Papmi) q
	...q:HisAdmRowId<0
	...s ret=..Receipt(MrType,PatientId,HisAdmRowId,MainId,1,NameSpell,"",MrNo,1,BuildDate)
	...s AdmCount=AdmCount+1
	...s VolRowid=+ret
	...i VolRowid'>0 d BuildErr("VolRowid=‘"_VolRowid_"’ "_MrType_"  "_MrNo_" "_Papmi) q
	
	q "Import Data Success!!!"
}

}
