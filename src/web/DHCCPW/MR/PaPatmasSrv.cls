/// 名称: web.DHCCPW.MR.PaPatmasSrv
/// 描述: 病人基本信息
/// 编写者：zhufei
/// 编写日期: 2010-05-17
Class web.DHCCPW.MR.PaPatmasSrv Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2010-05-17
/// Description:  根据PatientID取医护人员
/// Table：       User.PAPatMas,User.PAPerson
/// Input：       ID:    User.PAPerson.ID
///               separete: 指定的分隔符
/// Return：      返回String
/// w ##class(web.DHCCPW.MR.PaPatmasSrv).GetPatInfoByID(1)
ClassMethod GetPatInfoByID(argPatientID As %String, argEpisodeID As %String, argSeparete As %String) As %String
{
	New (argPatientID,argEpisodeID,argSeparete)
	Set return=""
	Set:(argPatientID="")&&(argEpisodeID'="") argPatientID=$p($g(^PAADM(argEpisodeID)),"^",1)
	Quit:argPatientID="" return
	Set:$g(argSeparete)="" argSeparete=..#SEPARATE
	Set objPAPatMas=##Class(User.PAPatMas).%OpenId(argPatientID)
	Do:objPAPatMas'="" objPAPatMas.%Close()
	Set objPAPerson=##Class(User.PAPerson).%OpenId(argPatientID)
	Do:objPAPerson'="" objPAPerson.%Close()
	If $IsObject(objPAPatMas)
	{
		Set PatientID=objPAPatMas.%Id()
		//Set PapmiNo=objPAPatMas.PAPMINo
		Set PapmiNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
		Set PatName=objPAPatMas.PAPMIName
		Set PatDeceased=objPAPatMas.PAPMIDeceased  //Add By NiuCaicai 2011-07-27 FixBug:105  临床应用--出入径管理-已死亡病人仍可进行出入径操作
		If $IsObject(objPAPatMas.PAPMISexDR)
		{
			Set PatSex=objPAPatMas.PAPMISexDR.CTSEXDesc
		}
		Set Medicare=objPAPatMas.PAPMIMedicare
	} Else {
		Quit
	}
	If $IsObject(objPAPerson)
	{
		Set BirthDay=objPAPerson.PAPERDob
		//Set:BirthDay'="" Age=(BirthDay\365)
		//Set:BirthDay'="" Age=..GetAgeDesc(BirthDay,"")   // add by wuqk 2011-12-27
		//fix bug 7994 by pylian 20150324 统一调用年龄计算方法
		Set Age=##class(web.DHCCPW.IO.FromHisSrv).GetPapmiAge(PatientID,argEpisodeID,"","")	//返回“*岁*月*天
		;Set:BirthDay'="" BirthDay=$zd(BirthDay,3)
		Set:BirthDay'="" BirthDay=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(BirthDay)
	} Else {
		Quit return
	}
	Set return=$g(PatientID)
	Set return=return_argSeparete_$g(PapmiNo)
	Set return=return_argSeparete_$g(PatName)
	Set return=return_argSeparete_$g(PatSex)
	Set return=return_argSeparete_$g(BirthDay)
	Set return=return_argSeparete_$g(Age)
	Set return=return_argSeparete_$g(PatDeceased)   //Add By NiuCaicai 2011-07-27 FixBug:105  临床应用--出入径管理-已死亡病人仍可进行出入径操作
	Set return=return_argSeparete_$g(Medicare)  //add by zf 20120410 病案号
	Quit return
}

/// 登记号格式化
/// w ##Class(web.DHCCPW.MR.PaPatmasSrv).RegNoCon("123")
ClassMethod RegNoCon(argRegNo As %String) As %String
{
    New (argRegNo)
    Set return=""
    Quit:argRegNo="" return
	Set Len=8
	Set PATCFid=$o(^CF("PATCF",""))
	Set:PATCFid'="" Len=$p($g(^CF("PATCF",PATCFid,3)),"^",5)
	If $l(argRegNo)<Len {
		Set $p(return,"0",Len-$l(argRegNo)-1)=argRegNo
	} ElseIf $l(argRegNo)=Len {
		Set return=argRegNo
	} Else {
		Set return=""
	}
	Quit return
}

/// 获取用户关联医护人员的身份类型(Doctor/Nurse)
/// w ##Class(web.DHCCPW.MR.PaPatmasSrv).getCPTInternalType(1)
ClassMethod getCPTInternalType(argUserID As %String) As %String
{
	New (argUserID)
	Set return=""
	Quit:argUserID="" return
	Set CareProvID=$p($g(^SSU("SSUSR",+argUserID)),"^",14)
	Set CarPrvTpID=$p($g(^CTPCP(+CareProvID,1)),"^",4)
	Set CPTInternalType=$p($g(^CT("CPT",+CarPrvTpID)),"^",4)
	Set return=CPTInternalType
	Quit return
}

ClassMethod GetAgeDesc(DOB As %String, CalDate As %String) As %String
{
	q:DOB="" ""
	i DOB["/" s DOB=$zdh(DOB,4)
	i DOB["-" s DOB=$zdh(DOB,3)
	i CalDate["/" s CalDate=$zdh(CalDate,4)
	i CalDate["-" s CalDate=$zdh(CalDate,3)
	i CalDate="" s CalDate=+$h
	s Age=$$CalAge^at182(DOB,CalDate,"","","")
	s AgeYear=$P(Age,"|",12)
	s AgeMonth=$P(Age,"|",13)
	s AgeDay=$P(Age,"|",14)
	s AgeDesc=..FormatAge(AgeYear,AgeMonth,AgeDay)
	Q AgeDesc
}

ClassMethod FormatAge(AgeYear As %String, AgeMonth As %String, AgeDay As %String) As %String
{
	if AgeYear>0 s AgeDesc=AgeYear_"岁"
	else  d
	.if AgeMonth>0 s AgeDesc=AgeMonth_"月"
	.else  s AgeDesc=AgeDay_"天"
	Q AgeDesc
}

Storage Default
{
<Data name="PaPatmasSrvDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCCPW.MR.PaPatmasSrvD</DataLocation>
<DefaultData>PaPatmasSrvDefaultData</DefaultData>
<IdLocation>^web.DHCCPW.MR.PaPatmasSrvD</IdLocation>
<IndexLocation>^web.DHCCPW.MR.PaPatmasSrvI</IndexLocation>
<StreamLocation>^web.DHCCPW.MR.PaPatmasSrvS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
