Import SQLUser

/// 医保就诊信息类
Class web.DHCINSUAdmInfoCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 133;

/// 保存
ClassMethod Save(InString As %String) As %String
{
	
	;n (InString)
	//s InString="^^604409227^6013046479^1^^社保局南山分局个人缴费窗口　　　　　　^^^706.94^H11122120073440632^A^^^1^SFC^^0^SZOP^^^^^5^20111221^000^1^^^^302760^2000000^0^0^%GASFALGLJMUKDWKZUZIN?;07437808955320345476?^^^^^^^^"
	s InString=$tr(InString,$c(0),"")
	q:InString="" -100
	s Save=$$Save^DHCINSUAdmInfo(InString)
	q Save
	/*
	s obj=##class(User.INSUAdmInfo).%New()
	s obj.AdmDr=$p(InString,"^",2)       ///指向PAADM的指针
	s obj.InsuId=$p(InString,"^",3)       ///医疗保险号
	s obj.CardNo=$p(InString,"^",4)       ///医保卡号
	s obj.PatType=$p(InString,"^",5)       ///人员类别
	s obj.CardStatus=$p(InString,"^",6)       ///IC卡状态
	s obj.Company=$p(InString,"^",7)       ///单位
	s obj.States=$p(InString,"^",8)       ///地区
	s obj.Center=$p(InString,"^",9)       ///所属分中心
	s obj.Account=+$p(InString,"^",10)       ///个人帐户余额
	s obj.AdmSeriNo=$p(InString,"^",11)       ///医保就诊流水号
	s obj.ActiveFlag=$p(InString,"^",12)       ///有效标志
	s obj.AdmDate=$p(InString,"^",13)       ///入院日期
	s obj.AdmTime=$p(InString,"^",14)       ///入院时间
	s obj.AdmType=$p(InString,"^",15)       ///入院类别
	s obj.DeptDesc=$p(InString,"^",16)       ///就诊科室名称
	s obj.InsuUser=$p(InString,"^",17)       ///入院登记人
	s obj.IpTimes=+$p(InString,"^",18)       ///住院次数
	s obj.InsuType=$p(InString,"^",19)       ///医保类别
	s obj.AdmCancelNo=$p(InString,"^",20)       ///冲销流水号
	s obj.OutDate=$p(InString,"^",21)       ///出院日期
	s obj.OutTime=$p(InString,"^",22)       ///出院时间
	s obj.OutUser=$p(InString,"^",23)       ///出院操作员	
	s obj.UserDr=$p(InString,"^",24)       ///操作员指针
	s obj.FunDate=$p($h,",",1)  ///$p(InString,"^",25)       ///操作日期
	s obj.FunTime=$p($h,",",2)  ///$p(InString,"^",26)       ///操作时间
	s obj.XString1=$p(InString,"^",27)       ///预留串
	s obj.XString2=$p(InString,"^",28)       ///预留串
	s obj.XString3=$p(InString,"^",29)       ///预留串
	s obj.XString4=$p(InString,"^",30)       ///预留串
	s obj.XFloat1=+$p(InString,"^",31)       ///预留串
	s obj.XFloat2=+$p(InString,"^",32)       ///预留串
	s obj.XFloat3=+$p(InString,"^",33)       ///预留串
	s obj.XFloat4=+$p(InString,"^",34)       ///预留串	
	d obj.%Save()
    s id=$p(obj.%Id(),$c(1))
    d obj.%Close()
    s sSave=id
    q sSave
    */
}

/// 按照ADMDR查询医保就诊信息
ClassMethod GetInfoByAdm(AdmRowid As %String) As %String
{
	
	;n (AdmRowid)
	q:AdmRowid="" -1
	q:$d(^DHCINADM("0","ADM",AdmRowid))=0 -100
	s InfoId="",flag=""
	s InfoId=$o(^DHCINADM("0","ADM",AdmRowid,InfoId),-1)
	s OutStr=..GetInfoById(InfoId)
	s GetInfoByAdm="1!"_OutStr
	q GetInfoByAdm
	/*
  Index of ADM                ^DHCINADM("0","ADM",{INADM_AdmDr},{INADM_Rowid} x
x Index of CardNo             ^DHCINADM("0","CardNo",{INADM_CardNo},{INADM_Ro x
x Index of Date               ^DHCINADM("0","ADMDate",{INADM_AdmDate},{INADM_ x
x Index of InsuId             ^DHCINADM("0","InsuId",{INADM_InsuId},{INADM_Ro
	s IndexOfAdm=" "_AdmRowid
	q:$d(^DHCINSUAdmInfoI("IndexOfAdm",IndexOfAdm))=0 -100
	s InfoId="",flag=""
	s InfoId=$o(^DHCINSUAdmInfoI("IndexOfAdm",IndexOfAdm,InfoId),-1)
	s OutStr=..GetInfoById(InfoId)
	s GetInfoByAdm="1!"_OutStr
	q GetInfoByAdm
	*/
}

/// 按照ADMDR,状态,查询医保就诊信息
/// INSU_Divide.INPAY_Flag="strike"=>INSU_AdmInfo.ActiveFlag="S"
/// INSU_Divide.INPAY_Flag="insu"=>INSU_AdmInfo.ActiveFlag="O"
/// w ##class(web.DHCINSUAdmInfoCtl).GetInfoByAdmFlag("39","O")
ClassMethod GetInfoByAdmFlag(AdmRowid As %String, status As %String) As %String
{
	;n (AdmRowid)
	q:AdmRowid="" -1
	q:$d(^DHCINADM("0","ADM",AdmRowid))=0 -100
	s InfoId="0",flag=""
	f  s InfoId=$o(^DHCINADM("0","ADM",AdmRowid,InfoId)) q:InfoId=""  d
	.s mCurrRow=$g(^DHCINADM(InfoId))
	.s ActiveFlag=$p(mCurrRow,"^",11)
	.q:(status="bestrike")&&(ActiveFlag'="S")
	.q:(status="strike")&&(ActiveFlag'="S")
	.q:(status="insu")&&(ActiveFlag'="O")
	.;q:(status="insu")&&(ActiveFlag'="A")
	.s OutStr=..GetInfoById(InfoId)
	.w "OutStr:",OutStr,! 
	.s GetInfoByAdm="1!"_OutStr
	q GetInfoByAdm
	/*
  Index of ADM                ^DHCINADM("0","ADM",{INADM_AdmDr},{INADM_Rowid} x
x Index of CardNo             ^DHCINADM("0","CardNo",{INADM_CardNo},{INADM_Ro x
x Index of Date               ^DHCINADM("0","ADMDate",{INADM_AdmDate},{INADM_ x
x Index of InsuId             ^DHCINADM("0","InsuId",{INADM_InsuId},{INADM_Ro
	s IndexOfAdm=" "_AdmRowid
	q:$d(^DHCINSUAdmInfoI("IndexOfAdm",IndexOfAdm))=0 -100
	s InfoId="",flag=""
	s InfoId=$o(^DHCINSUAdmInfoI("IndexOfAdm",IndexOfAdm,InfoId),-1)
	s OutStr=..GetInfoById(InfoId)
	s GetInfoByAdm="1!"_OutStr
	q GetInfoByAdm
	*/
}

/// 根据医保号查询就诊信息列表
ClassMethod GetInfoByInsuId(InsuId As %String) As %String
{
	;IndexOfInsuId
	n (InsuId)
	q:InsuId="" -1
	q:$d(^DHCINADM("0","InsuId",InsuId))=0 -100
	s InfoId="",flag="",count=0,OutStr=""
	f  s InfoId=$o(^DHCINADM("0","InsuId",InsuId,InfoId)) q:InfoId=""  d
	.s InfoStr=..GetInfoById(InfoId)
	.s OutStr=OutStr_"!"_InfoStr
	.s count=count+1	
	s GetInfoByInsuId=count_OutStr
	q GetInfoByInsuId
	/*
	s IndexOfInsuId=" "_InsuId
	q:$d(^DHCINSUAdmInfoI("IndexOfInsuId",IndexOfInsuId))=0 -100
	s InfoId="",flag="",count=0,OutStr=""
	f  s InfoId=$o(^DHCINSUAdmInfoI("IndexOfInsuId",IndexOfInsuId,InfoId)) q:InfoId=""  d
	.s InfoStr=..GetInfoById(InfoId)
	.s OutStr=OutStr_"!"_InfoStr
	.s count=count+1	
	s GetInfoByInsuId=count_OutStr
	q GetInfoByInsuId
	*/
}

/// 根据医保卡号查询就诊信息列表
ClassMethod GetInfoByCardNo(CardNo As %String) As %String
{
	;IndexOfIndexOfInsuId
	n (CardNo)
	q:CardNo="" -1
	q:$d(^DHCINADM("0","CardNo",CardNo))=0 -100
	s InfoId="",flag="",count=0,OutStr=""
	f  s InfoId=$o(^DHCINADM("0","CardNo",CardNo,InfoId)) q:InfoId=""  d
	.s InfoStr=..GetInfoById(InfoId)
	.s OutStr=OutStr_"!"_InfoStr
	.s count=count+1	
	s GetInfoByCardNo=count_OutStr
	q GetInfoByCardNo
	/*
	s IndexOfCardNo=" "_CardNo
	q:$d(^DHCINSUAdmInfoI("IndexOfCardNo",IndexOfCardNo))=0 -100
	s InfoId="",flag="",count=0,OutStr=""
	f  s InfoId=$o(^DHCINSUAdmInfoI("IndexOfCardNo",IndexOfCardNo,InfoId)) q:InfoId=""  d
	.s InfoStr=..GetInfoById(InfoId)
	.s OutStr=OutStr_"!"_InfoStr
	.s count=count+1	
	s GetInfoByCardNo=count_OutStr
	q GetInfoByCardNo
	*/
}

/// 按照ID取医保就诊信息
ClassMethod GetInfoById(InfoId As %String) As %String
{
	;n (InfoId)
	s GetInfoById=$$GetInfoById^DHCINSUAdmInfo(InfoId)
	q GetInfoById
	/*
	q:$d(^DHCINSUAdmInfoD(InfoId))=0 -100
	s obj=##class(User.INSUAdmInfo).%OpenId(InfoId)	
    s AdmDr=obj.AdmDr        ///指向PAADM的指针
    s InsuId=obj.InsuId        ///医疗保险号
    s CardNo=obj.CardNo        ///医保卡号
    s PatType=obj.PatType        ///人员类别
    s CardStatus=obj.CardStatus        ///IC卡状态
    s Company=obj.Company        ///单位
    s States=obj.States        ///地区
    s Center=obj.Center        ///所属分中心
    s Account=+obj.Account        ///个人帐户余额
    s AdmSeriNo=obj.AdmSeriNo        ///医保就诊流水号
    s ActiveFlag=obj.ActiveFlag        ///有效标志
    s AdmDate=obj.AdmDate        ///入院日期
    s AdmTime=obj.AdmTime        ///入院时间
    s AdmType=obj.AdmType        ///入院类别
    s DeptDesc=obj.DeptDesc        ///就诊科室名称
    s InsuUser=obj.InsuUser        ///入院登记人
    s IpTimes=+obj.IpTimes        ///住院次数
    s InsuType=obj.InsuType        ///医保类别
    s AdmCancelNo=obj.AdmCancelNo        ///冲销流水号
    s OutDate=obj.OutDate        ///出院日期
    s OutTime=obj.OutTime        ///出院时间
    s OutUser=obj.OutUser        ///出院操作员
    s UserDr=obj.UserDr        ///操作员指针
    s FunDate=$zd(obj.FunDate,3)        ///操作日期
    s FunTime=$zt(obj.FunTime,1)        ///操作时间
    s XString1=obj.XString1        ///预留串
    s XString2=obj.XString2        ///预留串
    s XString3=obj.XString3        ///预留串
    s XString4=obj.XString4        ///预留串
    s XFloat1=+obj.XFloat1        ///预留串
    s XFloat2=+obj.XFloat2        ///预留串
    s XFloat3=+obj.XFloat3        ///预留串
    s XFloat4=+obj.XFloat4        ///预留串	   
    s:UserDr'="" UserStr=##class(web.INSUBase).GetUserStr(UserDr)
    s:UserDr="" UserStr=""
    s UserName=$p(UserStr,"^",2)
    s GetInfoById=InfoId_"^"_AdmDr_"^"_InsuId_"^"_CardNo_"^"_PatType_"^"_CardStatus_"^"_Company_"^"_States_"^"_Center_"^"_Account_"^"_AdmSeriNo_"^"_ActiveFlag_"^"_AdmDate_"^"_AdmTime_"^"_AdmType_"^"_DeptDesc_"^"_InsuUser_"^"_IpTimes_"^"_InsuType_"^"_AdmCancelNo_"^"_OutDate_"^"_OutTime_"^"_OutUser_"^"_UserDr_"^"_FunDate_"^"_FunTime_"^"_XString1_"^"_XString2_"^"_XString3_"^"_XString4_"^"_XFloat1_"^"_XFloat2_"^"_XFloat3_"^"_XFloat4_"^"_UserName
    q GetInfoById
    */
}

// 结算后更新insu_adminfo.activeFlag=out

/*ClassMethod UpdateOut(instring As %String) As %String
{
	s UpdateOut=$$UpdateOut^DHCINSUAdmInfo(instring)
	q UpdateOut
}*/
ClassMethod UpdateAdminfoFlag(INAdmDr As %String, Flag As %String) As %String
{
	q:(+INAdmDr<1) "-1"
	&sql(Update INSU_AdmInfo set Inadm_activeflag=:Flag where INADM_RowID=:INAdmDr)
	q SQLCODE
}

ClassMethod Delete(INAdmDr As %String) As %String
{
	q:(+INAdmDr<1) "-1"
	&sql(delete from  INSU_AdmInfo  where INADM_RowID=:INAdmDr)
	q SQLCODE
}

/// Creator：      刘书凤
/// CreatDate：    2010 06 18
/// Description:   退号时调用的函数，退号时往Insu_Adminfo表插一条新记录
/// Table：        
/// Input：        
/// Output：       
/// Return：       成功返回 0
/// Others：
/// w ##class(web.DHCINSUAdmInfoCtl).StrikeInsuAdmInfo("")  
ClassMethod StrikeInsuAdmInfo(Instring As %String) As %String
{
	s StrikeInsuAdmInfo=$$StrikeInsuAdm^DHCINSUAdmInfo(Instring)
	q StrikeInsuAdmInfo
}

/// 按照insu_divide rowid查询医保就诊信息
/// w ##class(web.DHCINSUAdmInfoCtl).GetInfoByDivDr("887")  
ClassMethod GetInfoByDivDr(DivDr As %String) As %String
{
	
	n (DivDr)
	q:DivDr="" -1
	s GetDivById=$$GetDivideInfo^DHCINSUDivide(DivDr)
	s INPAYAdmInfoDr=$p(GetDivById,"^",3)
	s OutStr=##class(web.DHCINSUAdmInfoCtl).GetInfoById(INPAYAdmInfoDr)
	s GetInfoByDivDr="1!"_OutStr
	q GetInfoByDivDr
}

/// w ##class(web.DHCINSUAdmInfoCtl).GetInfoByAdmYLLB("36","11")  
ClassMethod GetInfoByAdmYLLB(AdmRowid As %String, YLLB As %String) As %String
{
	;n (AdmRowid)
	q:AdmRowid="" -1
	q:$d(^DHCINADM("0","ADM",AdmRowid))=0 -100
	s OutStr=""
	s InfoId="",flag=""
	f  s InfoId=$o(^DHCINADM("0","ADM",AdmRowid,InfoId)) q:(InfoId="")||(flag="N")  d
	.s OutStr=..GetInfoById(InfoId)
	.q:$p(OutStr,"^",15)'=YLLB
	.s flag="N"
	q:flag="" -100
	s GetInfoByAdm="1!"_OutStr
	q GetInfoByAdm
	/*
  Index of ADM                ^DHCINADM("0","ADM",{INADM_AdmDr},{INADM_Rowid} x
x Index of CardNo             ^DHCINADM("0","CardNo",{INADM_CardNo},{INADM_Ro x
x Index of Date               ^DHCINADM("0","ADMDate",{INADM_AdmDate},{INADM_ x
x Index of InsuId             ^DHCINADM("0","InsuId",{INADM_InsuId},{INADM_Ro
	s IndexOfAdm=" "_AdmRowid
	q:$d(^DHCINSUAdmInfoI("IndexOfAdm",IndexOfAdm))=0 -100
	s InfoId="",flag=""
	s InfoId=$o(^DHCINSUAdmInfoI("IndexOfAdm",IndexOfAdm,InfoId),-1)
	s OutStr=..GetInfoById(InfoId)
	s GetInfoByAdm="1!"_OutStr
	q GetInfoByAdm
	*/
}

/// w ##class(web.DHCINSUAdmInfoCtl).GetInsuAdmInfoByStr("36","11")  
ClassMethod GetInsuAdmInfoByStr(AdmRowid As %String, InStr As %String) As %String
{
	;n (AdmRowid)
	q:AdmRowid="" -1
	q:$d(^DHCINADM("0","ADM",AdmRowid))=0 -100
	s OutStr=""
	s InfoId="",flag=""
	f  s InfoId=$o(^DHCINADM("0","ADM",AdmRowid,InfoId),-1) q:(InfoId="")||(flag="N")  d
	.s OutStr=..GetInfoById(InfoId)
	.q:$p(OutStr,"^",15)'=InStr
	.s flag="N"
	q:flag="" -100
	s GetInfoByAdm="1!"_OutStr
	q GetInfoByAdm
}

///  获取异常的就诊信息
///  InAdmDr^AdmDr^AdmSeriNo^AdmDate^AdmTime^AdmLoc^AdmActFlag^InDivId^DivFlag^DivDjlsh0
/// w ##class(web.DHCINSUAdmInfoCtl).GetInAdmInfoExByInsuId("44020000001101823504")
ClassMethod GetInAdmInfoExByInsuId(InsuId As %String, HisAdmType As %String = "", ActFlag As %String = "", HospDr As %String = "")
{
	q:$d(^DHCINADM("0","InsuId",InsuId))=0 -100
	s InfoId="",Flag=""

	f  s InfoId=$o(^DHCINADM("0","InsuId",InsuId,InfoId)) q:InfoId=""  d
	.s (InAdmDr,AdmDr,AdmSeriNo,AdmDate,AdmTime,AdmLoc,AdmActFlag,InDivId,DivFlag,DivDjlsh0)=""
    .s mCurrRow=$g(^DHCINADM(InfoId))
	.s tActFlag=$P(mCurrRow,"^",11)
	.q:(ActFlag'="")&&(tActFlag'=ActFlag)
	.s AdmDr=$P(mCurrRow,"^",1)
	.q:AdmDr=""
	.s tHisAdmType=$P(^PAADM(AdmDr),"^",2)
	.q:(HisAdmType'="")&&(tHisAdmType'=HisAdmType)
	.s InAdmDr=InfoId
	.s AdmSeriNo=$P(mCurrRow,"^",10)
	.s AdmDate=$zd($P(mCurrRow,"^",12),3)
	.s AdmTime=$zt($P(mCurrRow,"^",13))
	.s AdmLoc=$P(mCurrRow,"^",15)
	.s AdmActFlag=$P(mCurrRow,"^",11)
	.s AdmActFlagA="挂号正常",AdmActFlagO="挂号完成"
	.s:tHisAdmType="I" AdmActFlagA="在院",AdmActFlagO="出院"
    .s AdmActFlag=$case(AdmActFlag,"A":AdmActFlagA,"O":AdmActFlagO,"B":"被作废","S":"作废",:"其他")
	.s InDivId=""
	.s InDivId=$O(^DHCINDIV(0,"ADMINFO",InfoId,""),-1)
	.i +InDivId>0 d
	..s mInDiv=$G(^DHCINDIV(InDivId))
	..s DivFlag=$P(mInDiv,"^",5)
	..s DivFlag=$case(DivFlag,"D":"预结算","I":"正常结算","B":"被作废","S":"作废",:"其他")
	..s DivDjlsh0=$P(mInDiv,"^",8)
	q InAdmDr_"^"_AdmDr_"^"_AdmSeriNo_"^"_AdmDate_"^"_AdmTime_"^"_AdmLoc_"^"_AdmActFlag_"^"_InDivId_"^"_DivFlag_"^"_DivDjlsh0
}

/// Creator：      HanZH
/// CreatDate：    2022-08-02
/// Description:   根据就诊事件ID取医保就诊数据
/// Table：        
/// Input：        AdmSeriNo:INSU_AdmInfo.INADM_AdmSeriNo
/// Output：       
/// Return：       成功返回 "1！就诊信息数据" 或 失败 "-1/-100"
/// Others：
/// w ##class(web.DHCINSUAdmInfoCtl).GetRegInfoByAdmSeriNo("103001285012")
ClassMethod GetRegInfoByAdmSeriNo(AdmSeriNo As %String) As %String
{
	n (AdmSeriNo)
	q:AdmSeriNo="" -1
	q:$d(^DHCINADM("0","AdmSeriNo",AdmSeriNo))=0 -100
	s InfoId="",flag=""
	s InfoId=$o(^DHCINADM("0","AdmSeriNo",AdmSeriNo,InfoId),-1)
	s OutStr=..GetInfoById(InfoId)
	s GetInfoByAdm="1!"_OutStr
	q GetInfoByAdm
}

/// Creator：      DingSH
/// CreatDate：    2022-09-06
/// Description:   根据就诊获取医保登记状态
/// Table：        
/// Input：        AdmDr:Pa_Adm,ExpStr:费别^医疗类别
/// Output：       
/// Return：       成功返回 "1！就诊信息数据" 或 失败 "-1/-100"
/// Others：HIS办理入院登记修改费别时校验医保是否登记
/// w ##class(web.DHCINSUAdmInfoCtl).CheckRegActFlag("21")
ClassMethod CheckRegActFlag(AdmDr As %String, ExpStr As %String) As %String
{
	n (AdmDr,ExpStr)
	s OutStr=""
	q:AdmDr="" "-1!就诊ID不能为空"
	q:$d(^DHCINADM("0","ADM",AdmDr))=0 "N!"
	s admReasonDr=$P($g(ExpStr),"^",1)
	s medType=$P($g(ExpStr),"^",2)
	s hospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	//一次就诊按照多个费别结算情况，例如市职工、市生育，医疗类别不同
	i (admReasonDr>0)&&(medType="") d
	..s medType=##class(web.INSUDicDataCom).GetDicByCodeAndInd("AdmReasonDrToYLLB",admReasonDr,6)
	s InfoId="",flag="N",ActFlag=""
	f  s InfoId=$o(^DHCINADM("0","ADM",AdmDr,InfoId),-1) q:(InfoId="")||(flag="Y")  d
	.s tmpmedType=$p(^DHCINADM(InfoId),"^",14)
	.q:(medType'="")&&(tmpmedType'=medType)
	.s ActFlag=$p(^DHCINADM(InfoId),"^",11)
	.s flag="Y"
    q:flag="N" "N!"
    s OutStr=$case(ActFlag,"A":"Y!A^登记在院"
                          ,"O":"Y!O^登记出院"
                          ,"B":"N!B^登记取消"
                          ,"S":"M!S^登记取消"
                          ,:"N!")
	q OutStr
}

/// Creator：      HanZH copy zyx
/// CreatDate：    2022-10-13
/// Description:   根据就诊事件ld或者人员编号取医保就诊表信息
/// Table：        
/// Input：        MdtrtId:就诊id，PsnNo:人员编码
/// Output：       
/// Return：       成功返回 "1！就诊信息数据" 或 失败 "-1/-100"
/// Others：
/// w ##class(web.DHCINSUAdmInfoCtl)GetInsuAdmByMdtrtIdOrPsnno("210120210","42134119921831313")
ClassMethod GetInsuAdmByMdtrtIdOrPsnno(MdtrtId As %String, PsnNo As %String) As %String
{
	n (MdtrtId,PsnNo)
	q:(MdtrtId="")&&(PsnNo="") -1
	q:($d(^DHCINADM("0","AdmSeriNo",MdtrtId)))&&($d(^DHCINADM("0","InsuId",PsnNo)))=0 -100
	
	s Id=$O(^DHCINADM("0","AdmSeriNo",MdtrtId,""),-1)
	i +Id=0 d
	.s Id=$O(^DHCINADM("0","InsuId",PsnNo,""),-1)
	
	s GetInsuAdmByMdtrtId=..GetInfoById(Id)	
	s GetInsuAdmByMdtrtId="1!"_GetInsuAdmByMdtrtId
	q GetInsuAdmByMdtrtId
}

/// 根据就诊Dr判断患者是否慢病
/// 丁少华 20230331
/// AdmDr：Pa_Adm.Rowid 
/// ExpStr:
/// Return: 成功：Y^医疗类别 或 N^ ；失败 小于0^错误信息
/// 判断规则说明：
/// 	      1:根据医保就诊登记表 AdmType(医疗类别),XString9(病种编码|病种名称)
///  使用场景 门诊收费界面 人员信息展示患者是否慢病
///  特别说明如果 按照3 判断 可能会影响性能
/// w ##class(web.DHCINSUAdmInfoCtl).CheckIsChronic("4153")
ClassMethod CheckIsChronic(AdmDr As %String, ExpStr As %String = "") As %String
{
	set $zt="CheckIsChronicEx"
	set IsChronic = "N",MedType=""
	quit:$g(AdmDr)="" "-1^就诊号不能为空"
	set HospDr = ##class(UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
	set InRId=""
	for {
		set InRId =$O(^DHCINADM("0","ADM",AdmDr,InRId))
		quit:InRId=""
		quit:IsChronic="Y"         
		set InAdmInfo=$g(^DHCINADM(InRId))
		set ActFlag = $P(InAdmInfo,"^",11)
		set InsuType = $P(InAdmInfo,"^",18)
		Continue:(ActFlag'="A")&&(ActFlag'="O")
		set TmpMedType=$P(InAdmInfo,"^",14)   ;医疗类型 INADM_AdmType 
		;med_type00A的使用标识需要配置 M INSU_DicData.DicUseFlag
		set MBFalg = ##class(INSU.COM.BaseData).GetDicByCodeAndInd("med_type"_InsuType,11,HospDr) 
		Continue:MBFalg'="M"
		//set MBInfo = $P(InAdmInfo,"^",38)  ;慢病手术信息拼串 INADM_XString9
		//set DiseCode=$P(MBInfo,"|",1)      ;病种编码
		//set DiseName=$P(MBInfo,"|",2)      ;病种编码
		set MedType = TmpMedType
		set IsChronic="Y"
		}
	quit IsChronic_"^"_MedType
CheckIsChronicEx
 set $zt=""
 b ; CheckIsChronicEx
 quit "-99^调用ChekIsChronic程序异常："_$ze
}

// 根据就诊Dr未结算医嘱病种字段判断患者是否有慢病

/// 丁少华 20230331
/// AdmDr：Pa_Adm.Rowid 
/// ExpStr:
/// Return: 成功：Y^医疗类别 或 N^ ；失败 小于0^错误信息
/// 判断规则说明：
/// 	      1:根据医保就诊登记表 AdmType(医疗类别),XString9(病种编码|病种名称)
///  使用场景 门诊收费界面 人员信息展示患者是否慢病
///  特别说明如果 按照3 判断 可能会影响性能
/// w ##class(web.DHCINSUAdmInfoCtl).CheckIsChronicByOrd("9598")
ClassMethod CheckIsChronicByOrd(AdmDr As %String, ExpStr As %String = "") As %String
{
	set $zt="CheckIsChronicByOrdEx"
	set IsChronic = "N",MedType=""
	quit:$g(AdmDr)="" "-1^就诊号不能为空"
	set HisAdmType=$P(^PAADM(AdmDr),"^",2)
	quit:(HisAdmType'="O")&&((HisAdmType'="E")) "-1^非门诊就诊信息"
	set HospDr = ##class(UDHCHospitalGroup).GetHospitalByAdm(AdmDr)
    set OEORDRowId=$O(^OEORD(0,"Adm",AdmDr,""),-1)
    quit:+OEORDRowId="" "-1^就诊无对应医嘱信息"
	set OEORIChildsub=0
	for {
        set OEORIChildsub=$O(^OEORD(OEORDRowId,"I",OEORIChildsub)) 
        quit:OEORIChildsub=""
		set ItemStatDR=$p(^OEORD(OEORDRowId,"I",OEORIChildsub,1),"^",13) 
		Continue:ItemStatDR=""                 
        set OSTATCode=$P(^OEC("OSTAT",ItemStatDR),"^",1)
        Continue:($zcvt(OSTATCode,"U")="U")||($zcvt(OSTATCode,"U")="D")||($zcvt(OSTATCode,"U")="C")
		set ChronicDiagCode=$p($g(^OEORD(+OEORDRowId,"I",OEORIChildsub,"DHC")),"^",66)		//OE_OrdItemExt.OEORI_ChronicDiagCode
		Continue:ChronicDiagCode="" 
		quit:IsChronic="Y"    
		//set ChronicInfo=##class(insuqc.service.ServicePort).GetChronicNameByCode(OrdDRGOrder, InsTypeDR, HospCode)
		//set DiseCode=$p(ChronicInfo,"^",1)      //病种编码
		//set DiseName=$p(ChronicInfo,"^",2)      //病种描述
		set IsChronic="Y"
		}
	quit IsChronic_"^"_MedType
CheckIsChronicByOrdEx
 set $zt=""
 b ; CheckIsChronicByOrdEx
 quit "-99^调用CheckIsChronicByOrd程序异常："_$ze
}

}
