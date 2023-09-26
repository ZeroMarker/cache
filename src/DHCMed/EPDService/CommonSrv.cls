/// 名称：DHCMed.EPDService.CommonSrv
/// 描述：传染病管理公用方法类
/// 创建者：朱飞
/// 创建日期：2011-08-11
Class DHCMed.EPDService.CommonSrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     zhufei
/// CreatDate：   2011-08-11
/// Description:  获取基础字典列表
/// Table：       DHCMed.SS.Dictionary
/// Input：       TypeCode:    根字典代码
/// Return：      %String
/// w ##class(DHCMed.EPDService.CommonSrv).GetDicList("EPIDEMICREPORTSTATUS")
ClassMethod GetDicList(aTypeCode As %String, aIsActive As %String) As %String
{
	New (aTypeCode,aIsActive)
	Set return=""
	Quit:aTypeCode="" return
	
	Set $ZT="GetDicListErr"
	
	Set aTypeCode=$ZCVT(aTypeCode,"U")
	Set DicID=0
	For {
		Set DicID=$o(^DHCMed.SS.DictionaryI("IdxofType"," "_aTypeCode,DicID))
		Quit:DicID=""
		Set objDic=##class(DHCMed.SS.Dictionary).GetObjById(DicID)
		Continue:'$IsObject(objDic)
		Continue:(aIsActive'="")&&(objDic.Active'=aIsActive)
		Set Code=objDic.Code
		Set Desc=objDic.Description
		Set return=return_$c(1)_Code_$c(2)_Desc
	}
	Set:return'="" return=$e(return,2,$l(return))
	
	Quit return
	
GetDicListErr
	Quit ""
}

/// Creator：     maxiangping
/// CreatDate：   2016-10-28
/// Description:  获取病人的有效证件号
/// Table：       Pa_Patmas
/// Input：       TypeCode:
/// Return：      %String
/// w ##class(DHCMed.EPDService.CommonSrv).GetActiveCardNo(106)
ClassMethod GetActiveCardNo(PatientID As %String) As %String
{
	New (PatientID,PapmiID)
	Set return=""
	Quit:PatientID="" return
	
	Set (PatIDTypeSSCode,PatIDType)=""
	Set PersonalID=$p($g(^PAPER(PatientID,"ALL")),"^",9)
	Set PersonalIDTypeID = $p($g(^PAPER(PatientID,"PAT",3)),"^",7)
	Set PersonalIDType = $p($g(^PAC("CARD",+PersonalIDTypeID)),"^",2)
	Set PAPMIDVAnumber=$p($g(^PAPER(PatientID,"PAT",3)),"^",6)
	
	Set:PersonalIDType["居民身份证" PatIDType="居民身份证号"
	Set:PersonalIDType["居民户口薄" PatIDType=""
	Set:PersonalIDType["护照" PatIDType="护照"
	Set:PersonalIDType["军官证" PatIDType="军官证"
	Set:PersonalIDType["驾驶证" PatIDType=""
	Set:PersonalIDType["港澳居民来往内地通行证" PatIDType=""
	Set:PersonalIDType["台湾居民来往内地通行证" PatIDType=""
	Set:PatIDType'="" PersonalID=PAPMIDVAnumber
	if PatIDType="" {
		Set PersonalID=""
		Set PatIDType="居民身份证号"
		}
	Set DicRowID = 0
	For {
		Set DicRowID = $o(^DHCMed.SS.DictionaryI("IdxofType"," "_$ZCVT("EpidemicCardType","U"),DicRowID))
		Quit:DicRowID=""
		Quit:return'=""
		
		Set objDic = ##class(DHCMed.SS.Dictionary).GetObjById(DicRowID)
		Continue:'$IsObject(objDic)
		Continue:objDic.Active'=1 
		if (objDic.Description=PatIDType) {
			Set PatIDTypeSSID=objDic.%Id()
			set return=objDic.Code_"^"_PersonalID_"^"_objDic.Description
		}
	}
		
	Quit return
}

/// Creator：     zhufei
/// CreatDate：   2011-08-12
/// Description:  更新病人的身份证号
/// Table：       Pa_Patmas
/// Input：       TypeCode:    根字典代码
/// Return：      %String
/// w ##class(DHCMed.EPDService.CommonSrv).UpdatePapmiID(106,"420502198601029987")
ClassMethod UpdatePapmiID(PatientID As %String, PapmiID As %String) As %String
{
	New (PatientID,PapmiID)
	Set return=0
	Quit:PatientID="" return
	
	Set PapmiID=$ZCVT(PapmiID,"U")
	Set:$l(PapmiID)>18 PapmiID=$e(PapmiID,1,18)
	Set PatInfo=$g(^PAPER(PatientID,"ALL"))
	Set $p(PatInfo,"^",9)=PapmiID
	Set ^PAPER(PatientID,"ALL")=PatInfo
	//update by zhouruimeng 2016-03-28 传染病身份证回写时两个字段都更新
	Set PatInfo=$g(^PAPER(PatientID,"PAT",3))
	Set $p(PatInfo,"^",6)=PapmiID
	Set ^PAPER(PatientID,"PAT",3)=PatInfo
	Set return=1
	Quit return
	
	/* update by zf 20110812 字段长度定义为17
	Set obj=##Class(User.PAPatMas).%OpenId(PatientID)
	Quit:'$IsObject(obj) return
	Set obj.PAPMIID=PapmiID
	Set sc=obj.%Save()
	If $system.Status.IsError(sc) {   //检查Save是否成功
		//Do $system.OBJ.DisplayError(sc) 
		Set return=-1
	}Else{
		Set return=obj.%Id()
	}
	Do obj.%Close()
	*/
}

/// Creator：     PanLei
/// CreatDate：   2012-10-10
/// Description:  更新病人的出生日期
/// Table：       Pa_Patmas
/// Input：       PatientID: 病人ID
///               PapmiDOB: 出生日期
/// Return：      成功返回1,失败返回0
/// w ##class(DHCMed.EPDService.CommonSrv).UpdatePapmiDOB(145048,"152126196711082411")
ClassMethod UpdatePapmiDOB(PatientID As %String, PapmiDOB As %String) As %String
{
	New (PatientID,PapmiDOB)
	Set return=0
	Quit:PatientID="" return
	
	//Set tmpPapmiDOB=+$ZDH(PapmiDOB,3)
	Set tmpPapmiDOB=##Class(DHCMed.SSService.CommonCls).DateHtmlToLogical(PapmiDOB)
	Set PatInfo=$g(^PAPER(PatientID,"ALL"))
	Set PatDOB=+$p(PatInfo,"^",6)
	
	// 如果身份证的出生日期和建卡填写的出生日期不相同，则依据身份证更新
	If (tmpPapmiDOB'=PatDOB) {
		Set $p(PatInfo,"^",6)=tmpPapmiDOB
		Set ^PAPER(PatientID,"ALL")=PatInfo
		Set return=1
	}
	
	Quit return
}

/*
/// Creator：     PanLei
/// CreatDate：   2012-10-10
/// Description:  根据病人出生日期,更新年龄,精确到岁/月/天
/// Table：       PA_Person
/// Input：       PatientID: 病人ID
///               PapmiDOB: 出生日期
/// Return：      成功返回1,失败返回0
/// w ##class(DHCMed.EPDService.CommonSrv).UpdatePapmiAge(145048,"152126196711082411")
ClassMethod UpdatePapmiAge(PatientID As %String, PapmiDOB As %String) As %String
{
	New (PatientID,PapmiDOB)
	Set return=0
	Quit:PatientID="" return
	
	Quit return
}
*/
/// 获取模板文件存放目录
/// w ##class(DHCMed.EPDService.CommonSrv).GetTemplatePath()
ClassMethod GetTemplatePath() As %String
{
	New
	Set objConfig=##class(websys.Configuration).%OpenId(1)
	Do objConfig.%Close()
	Set strPath=objConfig.PathToReports
	Set objConfig=""
	Kill objConfig
	Quit strPath
}

/// 取系统日期和时间
/// w ##Class(DHCMed.EPDService.CommonSrv).GetSysDateTime()
ClassMethod GetSysDateTime()
{
	New
	Set Date=+$h
	Set Time=$p($h,",",2)
	Set return=$zd(Date,3)_" "_$zt(Time,1)
	Quit return
}

/// w ##Class(DHCMed.EPDService.CommonSrv).Translate()
ClassMethod Translate(string As %String, identifier As %String, associator As %String) As %String
{
	New (string,identifier,associator)
	Set return=""
	Quit:(string="")||(identifier="")||(associator="") return
	
	For Ind=1:1:$l(string,identifier)
	{
		Set tmp=$p(string,identifier,Ind)
		If return="" {
			Set return=tmp
		}Else{
			Set return=return_associator_tmp
		}
	}
	
	Quit return
}

/// 通过登记号查询就诊记录
/// d ##class(%ResultSet).RunQuery("DHCMed.EPDService.CommonSrv","QryAdmByRegNo","1")
Query QryAdmByRegNo(aRegNo As %String) As %Query(ROWSPEC = "Paadm:%String,PatientID:%String,RegNo:%String,PatName:%String,Sex:%String,Age:%String,PersonalID:%String,AdmDate:%String,AdmTime:%String,AdmLoc:%String,AdmType:%String,AdmStatus:%String,DischDate:%String,DischTime:%String")
{
}

ClassMethod QryAdmByRegNoExecute(ByRef qHandle As %Binary, aRegNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Quit:aRegNo="" $$$OK
	
	Set RegNo=""
	Set PATCFId=$o(^CF("PATCF",""))
	Set RegNoLen=$p($g(^CF("PATCF",+PATCFId,3)),"^",5)
	Set:RegNoLen="" RegNoLen=10
	Set $p(RegNo,"0",RegNoLen-$l(+aRegNo)+1)=(+aRegNo)
	Set PatientID=$o(^PAPERi("PAPMI_PatNo",RegNo,""))
	Quit:PatientID="" $$$OK
	
	Set (RegNo,PatName,Sex,Age,PersonalID)=""
	Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
	If $IsObject(objPatient){
		Set RegNo=objPatient.PapmiNo              //登记号
		Set PatName=objPatient.PatientName        //姓名
		Set Sex=objPatient.Sex                    //性别
		Set Age=""                                //年龄
		If (objPatient.Age>0) {
			Set Age=Age_objPatient.Age_"岁"
		} ElseIf (objPatient.AgeMonth>0) {
			Set Age=Age_objPatient.AgeMonth_"月"
		} ElseIf (objPatient.AgeDay>0) {
			Set Age=Age_objPatient.AgeDay_"天"
		}
		Set PersonalID=objPatient.PersonalID      //身份证号
	}
	If objPatient'="" Do objPatient.%Close()
	
	Set xAdmType=""
	For {
		Set xAdmType=$o(^PAPERdr(+PatientID,"ADM",xAdmType))
		Quit:xAdmType=""
		
		Set xPaadm=0
		For {
			Set xPaadm=$o(^PAPERdr(+PatientID,"ADM",xAdmType,xPaadm))
			Quit:xPaadm=""
			
			Set (AdmDate,AdmTime,AdmLoc,AdmType,AdmStatus,DischDate,DischTime)=""
			//upadte by pylian 2016-02-18 修改入院时间取值方式
    		Set AdmDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetAdmDateTime(xPaadm)
			Set AdmDate=$p(AdmDateTime,"^",1)
			Set AdmTime=$p(AdmDateTime,"^",2)
			//Set AdmDate=$p($g(^PAADM(xPaadm)),"^",6)
			//Set:AdmDate'="" AdmDate=$zd(AdmDate,3)
			Set:AdmDate'="" AdmDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(AdmDate)
			//Set AdmTime=$p($g(^PAADM(xPaadm)),"^",7)
			Set:AdmTime'="" AdmTime=$zt(AdmTime,1)
			Set AdmLocID=$p($g(^PAADM(xPaadm)),"^",4)
			Set AdmLoc=$p($g(^CTLOC(+AdmLocID)),"^",2)
			Set:$p(AdmLoc,"-",2)'="" AdmLoc=$p(AdmLoc,"-",2)
			Set AdmType=$s(xAdmType="O":"门诊",xAdmType="E":"急诊",xAdmType="I":"住院",1:"")
			Set AdmStatusID=$p($g(^PAADM(xPaadm)),"^",20)
			Set AdmStatus=$s(AdmStatusID="A":"Admit",AdmStatusID="C":"Cancel",AdmStatusID="D":"Discharged",AdmStatusID="P":"Pre-Admission",1:"")
			
			//Set DischDate=$p($g(^PAADM(xPaadm)),"^",17)
			//Update by pylian 2016-01-21 修改出院时间取值方式
			Set DischDateTime=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateTime(xPaadm)
			Set DischDate=$p(DischDateTime,"^",1)
			Set DischTime=$p(DischDateTime,"^",2)
			//Set:DischDate'="" DischDate=$zd(DischDate,3)
			Set:DischDate'="" DischDate=##Class(DHCMed.SSService.CommonCls).DateLogicalToHtml(DischDate)
			//Set DischTime=$p($g(^PAADM(xPaadm)),"^",18)
			Set:DischTime'="" DischTime=$zt(DischTime,1)
			
			Set Data=$lb(xPaadm,PatientID,RegNo,PatName,Sex,Age,PersonalID,AdmDate,AdmTime,AdmLoc,AdmType,AdmStatus,DischDate,DischTime)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryAdmByRegNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdmByRegNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAdmByRegNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdmByRegNoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	// if there are no more rows, finish fetching
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	// fetch row
 	Else {
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
