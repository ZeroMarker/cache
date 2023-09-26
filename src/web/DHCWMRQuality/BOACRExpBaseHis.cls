Import SQLUser

/// 维护ACR用到的公用方法
/// By ZF 2009-06-14
Class web.DHCWMRQuality.BOACRExpBaseHis Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 35;

/// 是否院感患者
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).IsInHospInf(EpisodeID)
ClassMethod IsInHospInf(EpisodeID)
{
	n (EpisodeID)
	s ret="No"
	;^DHCMedIR(0,"PAADM",{MIR_Paadm_DR},{MIR_Rowid})
	s Rowid=0
	f  s Rowid=$o(^DHCMedIR(0,"PAADM",EpisodeID,Rowid)) q:Rowid=""  d
	.s tmp=$g(^DHCMedIR(Rowid))  //16字段--院内感然/社区感染
	.s:($p(tmp,"^",11)'["0") ret="Yes"
	q ret
}

/// 是否危重患者
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).IsApogeeInPat(EpisodeID)
ClassMethod IsApogeeInPat(EpisodeID)
{
	n (EpisodeID)
	s ret="No"
	s HospCode=..GetHospCode()
	i HospCode="ChengDu_HX" d      //华西取是否危重患者
	.s tmp=##Class(web.DHCWMRQuality.BOACRExpBaseEpr).GetElementDataByName(EpisodeID,"住院病案首页","病人类型","")
	.s:(tmp["急诊")||(tmp["病危")||(tmp["病重")||(tmp["疑难") ret="Yes"
	e  d
	.s ret="No"
	q ret
}

/// 取患者红细胞输血量
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetRBCTransfuse(EpisodeID)
ClassMethod GetRBCTransfuse(EpisodeID)
{
	n (EpisodeID)
	s HospCode=..GetHospCode()
	//华西/浙江衢州
	i (HospCode="ChengDu_HX")||(HospCode="BeiJing_DT") d
	.s ret=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordItemAmount(EpisodeID,"01001")
	e  d
	.s ret=0
	q ret
}

/// 取患者血小板输血量
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetPlateletTransfuse(EpisodeID)
ClassMethod GetPlateletTransfuse(EpisodeID)
{
	n (EpisodeID)
	s HospCode=..GetHospCode()
	//华西/浙江衢州
	i (HospCode="ChengDu_HX")||(HospCode="BeiJing_DT") d
	.s ret=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordItemAmount(EpisodeID,"01002")
	e  d
	.s ret=0
	q ret
}

/// 取患者血浆输血量
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetPlasmaTransfuse(EpisodeID)
ClassMethod GetPlasmaTransfuse(EpisodeID)
{
	n (EpisodeID)
	s HospCode=..GetHospCode()
	//华西/浙江衢州
	i (HospCode="ChengDu_HX")||(HospCode="BeiJing_DT") d
	.s ret=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordItemAmount(EpisodeID,"01003")
	e  d
	.s ret=0
	q ret
}

/// 取患者全血输血量
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetWholeBloodTransfuse(EpisodeID)
ClassMethod GetWholeBloodTransfuse(EpisodeID)
{
	n (EpisodeID)
	s HospCode=..GetHospCode()
	//华西/浙江衢州
	i (HospCode="ChengDu_HX")||(HospCode="BeiJing_DT") d
	.s ret=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordItemAmount(EpisodeID,"01004")
	e  d
	.s ret=0
	q ret
}

/// 取患者其它输血量
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOtherTransfuse(EpisodeID)
ClassMethod GetOtherTransfuse(EpisodeID)
{
	n (EpisodeID)
	s HospCode=..GetHospCode()
	//华西/浙江衢州
	i (HospCode="ChengDu_HX")||(HospCode="BeiJing_DT") d
	.s ret=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordItemAmount(EpisodeID,"01004")
	e  d
	.s ret=0
	q ret
}

/// 取患者抢救次数
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetSaveTimes(EpisodeID)
ClassMethod GetSaveTimes(EpisodeID)
{
	n (EpisodeID)
	s HospCode=..GetHospCode()
	//华西/浙江衢州
	i (HospCode="ChengDu_HX")||(HospCode="BeiJing_DT") d
	.s ret=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordItemCount(EpisodeID,"01006")
	e  d
	.s ret=0
	q ret
}

/// 取患者抢救医嘱DateTimeList
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetSaveDateTime(EpisodeID)
ClassMethod GetSaveDateTime(EpisodeID)
{
	n (EpisodeID)
	s HospCode=..GetHospCode()
	//华西/浙江衢州
	i (HospCode="ChengDu_HX")||(HospCode="BeiJing_DT") d
	.s ret=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordDateTime(EpisodeID,"01006")
	e  d
	.s ret=""
	q ret
}

/// 取患者输血医嘱次数
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetTransfuseTimes(EpisodeID)
ClassMethod GetTransfuseTimes(EpisodeID)
{
	n (EpisodeID)
	s HospCode=..GetHospCode()
	//华西/浙江衢州
	i (HospCode="ChengDu_HX")||(HospCode="BeiJing_DT") d
	.s ret=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordItemCount(EpisodeID,"01011")
	e  d
	.s ret=0
	q ret
}

/// 取患者穿刺医嘱次数
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetPunctureTimes(EpisodeID)
ClassMethod GetPunctureTimes(EpisodeID)
{
	n (EpisodeID)
	s HospCode=..GetHospCode()
	//华西/浙江衢州
	i (HospCode="ChengDu_HX")||(HospCode="BeiJing_DT") d
	.s ret=##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordItemCount(EpisodeID,"01010")
	e  d
	.s ret=0
	q ret
}

/// 取患者血型
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetBloodGroup(EpisodeID)
ClassMethod GetBloodGroup(EpisodeID)
{
	n (EpisodeID)
	s HospCode=..GetHospCode()
	i HospCode="ChengDu_HX" d      //华西取检验血型
	.s ret=##class(web.DHCBL.LIS.ReceiveReport).GetLisReportInfo(EpisodeID,"3573")
	e  d
	.s ret=""
	q ret
}

/// 判断就诊号是否最后一次就诊
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).IsLastAdm(EpisodeID,AdmType)
ClassMethod IsLastAdm(EpisodeID, AdmType)
{
	n (EpisodeID,AdmType)
	s ret=0
	q:EpisodeID="" ret
	s Papmi=$p($g(^PAADM(EpisodeID)),"^",1)
	;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
	i AdmType="" d
	.s LastAdm=+$o(^PAPERdr(Papmi,"ADM","I",""),-1)
	.s LastAdm2=+$o(^PAPERdr(Papmi,"ADM","O",""),-1)
	.s LastAdm3=+$o(^PAPERdr(Papmi,"ADM","E",""),-1)
	.s:LastAdm<LastAdm2 LastAdm=LastAdm2
	.s:LastAdm<LastAdm3 LastAdm=LastAdm3
	e  d
	.s LastAdm=+$o(^PAPERdr(Papmi,"ADM",AdmType,""),-1)
	s:EpisodeID=LastAdm ret=1
	s:EpisodeID'=LastAdm ret=-1
	q ret
}

/// 清除字符串非法字符  如：清除字符串“A /B无”中的“ ”、“/”、“无”等
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).ClearUselessChar(Val, CharSTR)
ClassMethod ClearUselessChar(Val As %String, CharSTR As %String) As %String
{
	n (Val,CharSTR)
	s ret=Val
	q:(Val="")||(CharSTR="") ret
	f i=1:1:$l(CharSTR) d
	.s tmpChar=$e(CharSTR,i,i)
	.s Val=$tr(Val,tmpChar,"")
	s ret=Val
	q ret
}

/// 计算时间差(精确到小时) 日期时间格式 "2009-05-24 10:10:10"
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDateTimeGap(DateTime1,DateTime2)
ClassMethod GetDateTimeGap(DateTime1 As %String, DateTime2 As %String) As %String
{
	n (DateTime1,DateTime2)
	s ret=0
	s DateTime1=..ChangeDateTime(DateTime1)
	s DateTime2=..ChangeDateTime(DateTime2)
	s Date1=$p(DateTime1," ",1),Time1=$p(DateTime1," ",2)
	s Date2=$p(DateTime2," ",1),Time2=$p(DateTime2," ",2)
	q:(Date1="")||(Date2="")||(Time1="")||(Time2="") ret
	s Date1=$zdh(Date1,3),Time1=$zth(Time1,2)
	s Date2=$zdh(Date2,3),Time2=$zth(Time2,2)
	s cDay=0,cSecond=0
	s cDay=Date1-Date2
	s cSecond=(Time1-Time2)\3600
	s ret=cDay*24+cSecond
	q ret
}

/// 统一转换成"2009-05-01 10:10:10"
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).ChangeDateTime(DateTime)
ClassMethod ChangeDateTime(DateTime As %String) As %String
{
	n (DateTime)
	s ret=""
	q:DateTime="" ret
	s Date=$p(DateTime," ",1),Time=$p(DateTime," ",2)
	q:Date="" ret
	s:Date["年" Date=$tr(Date,"年","-"),Date=$tr(Date,"月","-"),Date=$tr(Date,"日","")
	s:Date["/" Date=$zd($zdh(Date,4),3)
	s:Time="" Time=$zt(0,2)
	s:Date'["-" Date=$zd(+Date,3)
	s:Time'[":" Time=$zt(+Time,2)
	s Date=$zd($zdh(Date,3),3)
	s Time=$zt($zth(Time,3),2)
	s ret=Date_" "_Time
	q ret
}

/// ****************************************************************
/// 功能说明      : 查询特定医嘱输血量
/// 入参          : 
/// EpisodeID     : 就诊号
/// TypeCode      : 类型代码
/// 程序调试      : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordItemAmount(EpisodeID,TypeCode)
/// ****************************************************************
ClassMethod GetOeordItemAmount(EpisodeID As %String, TypeCode As %String) As %String
{
	n (EpisodeID,TypeCode)
	s Amount=0
	
	s ds=##class(%Library.ResultSet).%New("web.DHCWMRQuality.BOACRExpBaseHis:QryOeordItem")
	d ds.Execute(EpisodeID, TypeCode)
	while(ds.Next())
	{
		s OeordItemID=ds.Data("OeordItemID")
		s OeordID=+$p(OeordItemID,"||",1)
		s ChildSub=+$p(OeordItemID,"||",2)
		s Amount=Amount+(+$p($g(^OEORD(OeordID,"I",ChildSub,1)),"^",12))     //输血量
	}
	d ds.Close()
	
	q Amount
}

/// ****************************************************************
/// 功能说明      : 查询医嘱数量
/// 入参          : 
/// EpisodeID     : 就诊号
/// TypeCode      : 类型代码
/// 程序调试      : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordItemCount(EpisodeID,TypeCode)
/// ****************************************************************
ClassMethod GetOeordItemCount(EpisodeID As %String, TypeCode As %String)
{
	n (EpisodeID,TypeCode)
	s Count=0
	
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRQuality.BOACRExpBaseHis:QryOeordItem")
	d ds.Execute(EpisodeID, TypeCode)
	while(ds.Next())
	{
		s Count=Count+1
	}
	d ds.Close()
	
	q Count
}

/// ****************************************************************
/// 功能说明      : 查询特定医嘱日期时间LIST
/// 入参          : 
/// EpisodeID     : 就诊号
/// TypeCode      : 类型代码
/// 程序调试      : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetOeordDateTime(EpisodeID,TypeCode)
/// ****************************************************************
ClassMethod GetOeordDateTime(EpisodeID As %String, TypeCode As %String)
{
	n (EpisodeID,TypeCode)
	s cData=""
	
	s ds = ##class(%Library.ResultSet).%New("web.DHCWMRQuality.BOACRExpBaseHis:QryOeordItem")
	d ds.Execute(EpisodeID, TypeCode)
	while(ds.Next())
	{
		s OeordItemID=ds.Data("OeordItemID")
		s DateTime=ds.Data("VDate")_" "_ds.Data("VTime")
		s:(ds.Data("EDate")'="")&&(ds.Data("ETime")'="") DateTime=ds.Data("EDate")_" "_ds.Data("ETime")
		s cData=cData_$lb(DateTime)
	}
	d ds.Close()
	q cData
}

/// ****************************************************************
/// 功能说明      : 取患者死亡时间
/// 入参          : 
/// EpisodeID     : 就诊号
/// 程序调试      : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDeathDateTime(EpisodeID)
/// ****************************************************************
ClassMethod GetDeathDateTime(EpisodeID)
{
	n (EpisodeID)
	s ret=""
	q:EpisodeID="" ret
	
	s HospCode=..GetHospCode()
	i HospCode="ChengDu_HX" d      //华西医院 取体温单死亡时间
	.s Ind=0
	.f  s Ind=$o(^DHCADMQTREC("adm",EpisodeID,Ind)) q:(Ind="")||(ret'="")  d
	..s ADate=$p($g(^DHCADMQTREC("QTREC",Ind)),"^",2)
	..s:ADate'="" ADate=$zd(ADate,3)
	..s ATime=$p($g(^DHCADMQTREC("QTREC",Ind)),"^",3)
	..s:ATime'="" ATime=$zt(ATime,2)
	..s TypDr=$p($g(^DHCADMQTREC("QTREC",Ind)),"^",4)
	..s:TypDr'="" Typ=$p($g(^DHCQTRECTYP("typ",TypDr)),"^",2)
	..q:Typ'="死亡"
	..q:(ADate="")||(ATime="")
	..s ret=ADate_" "_ATime
	e  d      //其它医院 取病人基本信息死亡时间
	.s Papmi=$p($g(^PAADM(+EpisodeID)),"^",1)
	.s DeathFlg=$p($g(^PAPER(+Papmi,"ALL")),"^",12)
	.s ADate=$p($g(^PAPER(+Papmi,"ALL")),"^",13)
	.s ATime=$p($g(^PAPER(+Papmi,"ALL")),"^",8)
	.q:(DeathFlg'="Y")||(ADate="")||(ATime="")
	.s ADate=$zd(ADate,3)
	.s ATime=$zt(ATime,2)
	.s ret=ADate_" "_ATime
	
	q ret
}

/// ****************************************************************
/// 功能说明      : 取患者入院时间
/// 入参          : 
/// EpisodeID     : 就诊号
/// 程序调试      : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetRegDateTime(EpisodeID)
/// ****************************************************************
ClassMethod GetRegDateTime(EpisodeID)
{
	n (EpisodeID)
	s ret=""
	q:EpisodeID="" ret
	
	i (..GetHospCode())="ChengDu_HX" d      //华西医院 取安床时间
	.;^PAADM({PA_Adm.PAADM_RowID},"TRANS",{TRANS_Childsub})
	.s ChildSub=0,DateFlg=0
	.f  s ChildSub=$o(^PAADM(EpisodeID,"TRANS",ChildSub)) q:(ChildSub="")||(DateFlg=1)  d
	..s Info=$g(^PAADM(EpisodeID,"TRANS",ChildSub))
	..q:$p(Info,"^",8)=""
	..s ADate=$p(Info,"^",1)
	..s ATime=$p(Info,"^",2)
	..q:(ADate="")||(ATime="")
	..s DateFlg=1
	.s:DateFlg=0 ADate=$p($g(^PAADM(+EpisodeID)),"^",6)
	.s:DateFlg=0 ATime=$p($g(^PAADM(+EpisodeID)),"^",7)
	.q:(ADate="")||(ATime="")
	.s ADate=$zd(ADate,3)
	.s ATime=$zt(ATime,2)
	.s ret=ADate_" "_ATime
	e  d     //其它医院取住院登记时间
	.s ADate=$p($g(^PAADM(+EpisodeID)),"^",6)
	.s ATime=$p($g(^PAADM(+EpisodeID)),"^",7)
	.q:(ADate="")||(ATime="")
	.s ADate=$zd(ADate,3)
	.s ATime=$zt(ATime,2)
	.s ret=ADate_" "_ATime
	
	q ret
}

/// ****************************************************************
/// 功能说明      : 取患者出院时间(医疗结算时间)
/// 入参          : 
/// EpisodeID     : 就诊号
/// 程序调试      : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischDateTime1(EpisodeID)
/// ****************************************************************
ClassMethod GetDischDateTime1(EpisodeID)
{
	n (EpisodeID)
	s ret=""
	q:EpisodeID="" ret
	s ADate=$p($g(^PAADM(+EpisodeID)),"^",17)
	s ATime=$p($g(^PAADM(+EpisodeID)),"^",18)
	q:(ADate="")||(ATime="") ret
	s ADate=$zd(ADate,3)
	s ATime=$zt(ATime,2)
	s ret=ADate_" "_ATime
	q ret
}

/// ****************************************************************
/// 功能说明      : 取患者出院时间(最终结算时间)
/// 入参          : 
/// EpisodeID     : 就诊号
/// 程序调试      : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischDateTime2(EpisodeID)
/// ****************************************************************
ClassMethod GetDischDateTime2(EpisodeID)
{
	n (EpisodeID)
	s ret=""
	q:EpisodeID="" ret
	s ADate=$p($g(^PAADM(+EpisodeID)),"^",59)
	s ATime=$p($g(^PAADM(+EpisodeID)),"^",60)
	q:(ADate="")||(ATime="") ret
	s ADate=$zd(ADate,3)
	s ATime=$zt(ATime,2)
	s ret=ADate_" "_ATime
	q ret
}

/// ****************************************************************
/// 功能说明      : 取患者出院时间
/// 入参          : 
/// EpisodeID     : 就诊号
/// 程序调试      : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischDateTime(EpisodeID)
/// ****************************************************************
ClassMethod GetDischDateTime(EpisodeID)
{
	n (EpisodeID)
	s ret=""
	q:EpisodeID="" ret
	s HospCode=..GetHospCode()
	i HospCode="ShenYang_YDYFY" d
	.s ret=..GetDischDateTime2(EpisodeID)    //最终结算时间
	e  d
	.s ret=..GetDischDateTime1(EpisodeID)    //医疗结算时间
	q ret
}

/// *****************************************************
/// 说明       : 取病人已入院时间(单位:小时)
///            : 计算的是入院时间到当前时间(未出院)的差值 或 入院时间到出院时间(已出院)的差值
/// 参数       :
/// EpisodeID  : 就诊号
/// 调试       : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetRegHour(EpisodeID)
/// *****************************************************
ClassMethod GetRegHour(EpisodeID)
{
	n (EpisodeID)
	s ret=0
	s RegDateTime=..GetRegDateTime(EpisodeID)
	q:RegDateTime="" ret
	s RegDate=$p(RegDateTime," ",1),RegTime=$p(RegDateTime," ",2)
	q:(RegDate="")||(RegTime="") ret
	s RegDate=$zdh(RegDate,3),RegTime=$zth(RegTime,2)
	s DischDateTime=..GetDischDateTime(EpisodeID)
	s DisDate=$p(DischDateTime," ",1),DisTime=$p(DischDateTime," ",2)
	i (DisDate="")||(DisTime="") d
	.s CurrDate=+$h,CurrTime=$p($h,",",2)
	e  d
	.s CurrDate=$zdh(DisDate,3),CurrTime=$zth(DisTime,2)
	s cDay=0,cSecond=0
	s cDay=CurrDate-RegDate
	s cSecond=(CurrTime-RegTime)\3600
	s ret=cDay*24+cSecond
	q ret
}

/// *****************************************************
/// 说明       : 取病人入院和出院时间
/// 参数       :
/// EpisodeID  : 就诊号
/// 调试       : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetInPatDateTime(EpisodeID)
/// *****************************************************
ClassMethod GetInPatDateTime(EpisodeID)
{
	n (EpisodeID)
	s ret=""
	s RegDateTime=..GetRegDateTime(EpisodeID)
	q:RegDateTime="" ret
	s DischDateTime=..GetDischDateTime(EpisodeID)
	s ret=$lb(RegDateTime,DischDateTime)
	q ret
}

/// *****************************************************
/// 说明       : 取病人已出院时间(单位:小时)
///            : 计算的是出院时间到当前时间的差值
/// 参数       :
/// EpisodeID  : 就诊号
/// 调试       : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetDischHour(EpisodeID)
/// *****************************************************
ClassMethod GetDischHour(EpisodeID)
{
	n (EpisodeID)
	s ret=0
	s DischDateTime=..GetDischDateTime(EpisodeID)
	q:DischDateTime="" ret
	s DisDate=$p(DischDateTime," ",1),DisTime=$p(DischDateTime," ",2)
	q:(DisDate="")||(DisTime="") ret
	s DisDate=$zdh(DisDate,3),DisTime=$zth(DisTime,2)
	s CurrDate=+$h,CurrTime=$p($h,",",2)
	s cDay=0,cSecond=0
	s cDay=CurrDate-DisDate
	s cSecond=(CurrTime-DisTime)\3600
	s ret=cDay*24+cSecond
	q ret
}

/// *****************************************************
/// 说明       : 取患者转科次数
/// 参数       :
/// EpisodeID  : 就诊号
/// 调试       : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetTransLocCount(EpisodeID)
/// *****************************************************
ClassMethod GetTransLocCount(EpisodeID)
{
	n (EpisodeID)
	s ret=0
	q:EpisodeID="" ret
	//^PAADM({PA_Adm.PAADM_RowID},"TRANS",{TRANS_Childsub})
	q:'$d(^PAADM(EpisodeID)) ret
	s ChildSub="",CurrLoc="",Count=0
	f  s ChildSub=$o(^PAADM(EpisodeID,"TRANS",ChildSub)) q:ChildSub=""  d
	.s tmpLoc=$p($g(^PAADM(EpisodeID,"TRANS",ChildSub)),"^",6)
	.q:tmpLoc=""
	.s:CurrLoc'=tmpLoc Count=Count+1
	.s CurrLoc=tmpLoc
	s ret=Count-1
	s:ret<0 ret=0
	q ret
}

/// *****************************************************
/// 说明       : 婚姻状态 返回代码描述
/// 参数       :
/// EpisodeID  : 就诊号
/// 返回值     ：ret=已婚|未婚|单身|丧偶|离弃...
/// 调试       : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetMaritalStatus(EpisodeID)
/// *****************************************************
ClassMethod GetMaritalStatus(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s ret=""
	q:EpisodeID="" ret
	s Papmi=$p($g(^PAADM(EpisodeID)),"^",1)
	q:Papmi="" ret
	q:'$d(^PAPER(Papmi,"PER",2)) ret
	s Marital=$p($g(^PAPER(Papmi,"PER",2)),"^",3)
	s:Marital'="" Marital=$p($g(^CT("MAR",Marital)),"^",2)
	s ret=Marital
	q ret
}

/// *****************************************************
/// 说明       : 是否已婚
/// 参数       :
/// EpisodeID  : 就诊号
/// 返回值     ："0"未婚  "1"已婚  "2"不确定
/// 调试       : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).IsMaritalStatus(EpisodeID)
/// *****************************************************
ClassMethod IsMaritalStatus(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s ret=2
	s tmp=..GetMaritalStatus(EpisodeID)
	s:(tmp["未婚")||(tmp["单身") ret=0
	s:(tmp["已婚")||(tmp["丧偶")||(tmp["离异")||(tmp["离弃") ret=1
	q ret
}

/// *****************************************************
/// 说明       : 性别 返回代码描述
/// 参数       :
/// EpisodeID  : 就诊号
/// 返回值     ：ret=男|女|不确定...
/// 调试       : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetSex(EpisodeID)
/// *****************************************************
ClassMethod GetSex(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s ret=""
	q:EpisodeID="" ret
	s Papmi=$p($g(^PAADM(EpisodeID)),"^",1)
	q:Papmi="" ret
	q:'$d(^PAPER(Papmi,"ALL")) ret
	s Sex=$p($g(^PAPER(Papmi,"ALL")),"^",7)
	s:Sex'="" Sex=$p($g(^CT("SEX",Sex)),"^",2)
	s ret=Sex
	q ret
}

/// *****************************************************
/// 说明       : 出生日期
/// 参数       :
/// EpisodeID  : 就诊号
/// 返回值     ：ret="2009-1-01"
/// 调试       : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetBirthday(EpisodeID)
/// *****************************************************
ClassMethod GetBirthday(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s ret=""
	q:EpisodeID="" ret
	s Papmi=$p($g(^PAADM(EpisodeID)),"^",1)
	q:Papmi="" ret
	q:'$d(^PAPER(Papmi,"ALL")) ret
	s Birthday=+$p($g(^PAPER(Papmi,"ALL")),"^",6)
	q:Birthday=0 ret
	s ret=$zd(Birthday,3)
	q ret
}

/// *****************************************************
/// 说明       : 年龄(单位:岁)
/// 参数       :
/// EpisodeID  : 就诊号
/// 返回值     ："-1"年龄为空
/// 调试       : w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetAge(EpisodeID)
/// *****************************************************
ClassMethod GetAge(EpisodeID As %String) As %String
{
	n (EpisodeID)
	s ret="-1"
	s Birthday=..GetBirthday(EpisodeID)
	q:Birthday="" ret
	s ret=((+$h)-$zdh(Birthday,3))\360
	q ret
}

/// 取当前医院代码
/// w ##Class(web.DHCWMRQuality.BOACRExpBaseHis).GetHospCode()
ClassMethod GetHospCode()
{
	n
	s ret=$p($g(^DHCMedHosptial(0)),"/",4)
	q ret
}

ClassMethod QryOeordItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOeordItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOeordItemExecute(ByRef qHandle As %Binary, EpisodeID As %String, TypeCode As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:(EpisodeID="")||(TypeCode="") $$$OK
	s HospCode=..GetHospCode()
	s OrderID=$o(^OEORD(0,"Adm",+EpisodeID,""))
	q:(HospCode="")||(OrderID="") $$$OK
	q:'$d(^DHCWMRACRArg(HospCode,TypeCode)) $$$OK
	
	//取此种类型医嘱有效状态
	s Ind=0,StatusStr=""
	f  s Ind=$o(^DHCWMRACRArg(HospCode,TypeCode,"01",Ind)) q:Ind=""  d
	.s Status=$p($g(^DHCWMRACRArg(HospCode,TypeCode,"01",Ind)),"^",1)
	.s StatusStr=StatusStr_"|"_Status_"|"
	
	//取医嘱项对应的医嘱
	s Ind=0
	f  s Ind=$o(^DHCWMRACRArg(HospCode,TypeCode,"02",Ind)) q:Ind=""  d
	.s ARCItmMast=$p($g(^DHCWMRACRArg(HospCode,TypeCode,"02",Ind)),"^",1)
	.d getOeordItem
	
	Quit $$$OK
	
getOeordItem
	//^OEORDi(0,"ARCIM",{OE_Order.OEORD_RowId},{OEORI_ItmMast_DR},{OEORI_SttDat},{OEORI_Childsub})
	q:ARCItmMast=""
	q:'$d(^OEORDi(0,"ARCIM",OrderID,ARCItmMast))
	s SttDat=""
	f  s SttDat=$o(^OEORDi(0,"ARCIM",OrderID,ARCItmMast,SttDat)) q:SttDat=""  d
	.s ChildSub=0
	.f  s ChildSub=$o(^OEORDi(0,"ARCIM",OrderID,ARCItmMast,SttDat,ChildSub)) q:ChildSub=""  d
	..s OeordItemID=OrderID_"||"_ChildSub
	..s CurrStatus=$p($g(^OEORD(OrderID,"I",ChildSub,1)),"^",13)
	..q:StatusStr'[("|"_CurrStatus_"|")
	..s IDate=$p($g(^OEORD(OrderID,"I",ChildSub,1)),"^",9)      //开医嘱时间  OEORI_SttDat
	..s ITime=$p($g(^OEORD(OrderID,"I",ChildSub,1)),"^",10)
	..s VDate=$p($g(^OEORD(OrderID,"I",ChildSub,3)),"^",7)      //核实时间   OEORI_Date
	..s VTime=$p($g(^OEORD(OrderID,"I",ChildSub,3)),"^",15)
	..s:VTime="" VTime=ITime
	..s EDate=$p($g(^OEORD(OrderID,"I",ChildSub,6)),"^",2)      //执行时间   OEORI_DateExecuted
	..s ETime=$p($g(^OEORD(OrderID,"I",ChildSub,6)),"^",3)	
	..s DDate=$p($g(^OEORD(OrderID,"I",ChildSub,3)),"^",34)     //停止时间   OEORI_XDate
	..s DTime=$p($g(^OEORD(OrderID,"I",ChildSub,2)),"^",15)
	..s ItemMastID=ARCItmMast
	..s ItemMastDesc=$p($g(^ARCIM(+$p(ARCItmMast,"||",1),+$p(ARCItmMast,"||",2))),"^",2)
	..s Data=$lb(OeordItemID,IDate,ITime,VDate,VTime,EDate,ETime,DDate,DTime,ItemMastID,ItemMastDesc)
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	q
}

ClassMethod QryOeordItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOeordItemExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// ****************************************************************
/// 功能说明      : 查询特定医嘱项医嘱信息
/// 入参          : 
/// EpisodeID     : 就诊号
/// TypeCode      : 类型代码
/// 程序调试      : d ##Class(%ResultSet).RunQuery("web.DHCWMRQuality.BOACRExpBaseHis","QryOeordItem",EpisodeID,TypeCode)
/// ****************************************************************
Query QryOeordItem(EpisodeID As %String, TypeCode As %String) As %Query(ROWSPEC = "OeordItemID:%String,IDate:%String,ITime:%String,VDate:%String,VTime:%String,EDate:%String,ETime:%String,DDate:%String,DTime:%String,ItemMastID:%String,ItemMastDesc:%String")
{
}

}
