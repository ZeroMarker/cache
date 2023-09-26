/// Creator		: zhaoyu
/// CreateDate	: 2014-07-02
/// Description	: 临床路径合并症、并发症
Class web.DHCCPW.MR.ClinPathWaysSyndrome Extends web.DHCCPW.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCCPW.MR.ClinPathWaysSyndrome).GetObjBySyndID("1||1")
ClassMethod GetObjBySyndID(SyndromeID As %String) As User.DHCMRClinicalPathWaySyndrome
{
	New (SyndromeID)
	Set ret=""
	Set objSyndrome=##class(User.DHCMRClinicalPathWaySyndrome).%OpenId(SyndromeID)
	If $IsObject(objSyndrome) {
		Set ret=objSyndrome
		Do objSyndrome.%Close()
	}
	Quit ret
}

/// w ##class(web.DHCCPW.MR.ClinPathWaysSyndrome).UpdateSyndrome("1||^hbz1^hbz2^1918^^")
ClassMethod UpdateSyndrome(InputStr As %String) As %String
{
	New (InputStr)
	Set ret=-1
	Set ID=$p(InputStr,"^",1)
	Set Parref=$p(ID,"||",1)
	Set ChildSub=$p(ID,"||",2)
	If (ChildSub="") {
		Set obj=##class(User.DHCMRClinicalPathWaySyndrome).%New()
	} Else {
		Set obj=##class(User.DHCMRClinicalPathWaySyndrome).%OpenId(ID)
		Quit:'$IsObject(obj) ret
	}
	Set objParref=##class(web.DHCCPW.MR.ClinicalPathWays).GetObjById(Parref)
	Quit:'$IsObject(objParref) ret
	Set Compl1=$p(InputStr,"^",2)
	//Set Compl1=$tr(Compl1,"\","")
	Set Compl2=$p(InputStr,"^",3)
	//Set Compl2=$tr(Compl2,"\","")
	Set SyndUser=$p(InputStr,"^",4)
	Set SyndUser=##class(web.DHCCPW.MR.CTCareProvSrv).GetCareProvByUserID(+SyndUser,"^")
	Quit:(+SyndUser=0) ret
	Set SyndDate=$p(InputStr,"^",5)
	Set:SyndDate["/" SyndDate=$zdh(SyndDate,4)
	Set:SyndDate["-" SyndDate=$zdh(SyndDate,3)
	Set SyndDate=$s(SyndDate'="":+SyndDate,1:+$h)
	Set SyndTime=$p(InputStr,"^",6)
	Set:SyndTime[":" SyndTime=$zth(SyndTime)
	Set SyndTime=$s(SyndTime'="":+SyndTime,1:+$p($h,",",2))
	Set obj.CPWSParRef=objParref
	Set obj.CPWSCompl1=Compl1
	Set obj.CPWSCompl2=Compl2
	Set obj.CPWSSyndUser=+SyndUser
	Set obj.CPWSSyndDate=SyndDate
	Set obj.CPWSSyndTime=SyndTime
	Set sc=obj.%Save()
	If $System.Status.IsError(sc) {
		Do $system.OBJ.DisplayError(sc)
		Set ret=-2
	} Else {
		Set ret=obj.%Id()
	}
	Do obj.%Close()
	Quit ret
}

/// 根据出入径记录ID获取合并症、并发症信息
/// w ##class(web.DHCCPW.MR.ClinPathWaysSyndrome).GetSyndInfoByCPWID("1")
ClassMethod GetSyndInfoByCPWID(CPWID As %String) As %String
{
	New (CPWID)	// ^DHCMR("CPW",1,"SYND",1)	=	$lb("","hbz1","hbz2",475,63370,47118)
	Set ret="^^^^^"
	Quit:(CPWID="") ret
	Quit:'$d(^DHCMR("CPW",CPWID,"SYND")) ret
	Set SubID=$o(^DHCMR("CPW",CPWID,"SYND",""),-1)
	Quit:(SubID="") ret
	Set SyndromeID=CPWID_"||"_SubID
	Set objSyndrome=..GetObjBySyndID(SyndromeID)
	Quit:'$IsObject(objSyndrome) ret
	Set Compl1=objSyndrome.CPWSCompl1
	Set Compl2=objSyndrome.CPWSCompl2
	Set SyndUser=objSyndrome.CPWSSyndUser
	Set SyndUser=$p($g(^CTPCP(+SyndUser,1)),"^",2)
	Set SyndDate=objSyndrome.CPWSSyndDate
	Set SyndDate=$zd(SyndDate,3)
	Set SyndTime=objSyndrome.CPWSSyndTime
	Set SyndTime=$zt(SyndTime)
	Set ret=SyndromeID_"^"_Compl1_"^"_Compl2_"^"_SyndUser_"^"_SyndDate_"^"_SyndTime
	Quit ret
}

/// 根据出入径记录ID查询所有操作记录
/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MR.ClinPathWaysSyndrome","QrySyndInfoByCPWID","1")
Query QrySyndInfoByCPWID(CPWID As %String) As %Query(ROWSPEC = "SyndromeID:%String,Compl1:%String,Compl2:%String,SyndUser:%String,SyndDate:%String,SyndTime:%String") [ SqlProc ]
{
}

ClassMethod QrySyndInfoByCPWIDExecute(ByRef qHandle As %Binary, CPWID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$LB(0,repid,0)
	
	Quit:(+CPWID=0) $$$OK
	Set SubID=""
	For {
		Set SubID=$o(^DHCMR("CPW",CPWID,"SYND",SubID))
		Quit:(SubID="")
		Set SyndromeID=CPWID_"||"_SubID
		Set objSyndrome=..GetObjBySyndID(SyndromeID)
		Continue:'$IsObject(objSyndrome)
		Set Compl1=objSyndrome.CPWSCompl1
		Set Compl2=objSyndrome.CPWSCompl2
		Set SyndUser=objSyndrome.CPWSSyndUser
		Set SyndUser=$p($g(^CTPCP(+SyndUser,1)),"^",2)
		Set SyndDate=objSyndrome.CPWSSyndDate
		Set SyndDate=$zd(SyndDate,3)
		Set SyndTime=objSyndrome.CPWSSyndTime
		Set SyndTime=$zt(SyndTime)
		Set Data=$lb(SyndromeID,Compl1,Compl2,SyndUser,SyndDate,SyndTime)
		Set ^CacheTemp(repid,ind)=Data
 		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QrySyndInfoByCPWIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySyndInfoByCPWIDExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If (ind="") {
		Set AtEnd=1
		Set Row=""
	} Else {
		Set Row=^CacheTemp(repid,ind)
	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QrySyndInfoByCPWIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySyndInfoByCPWIDExecute ]
{
	Set repid=$LIST($g(qHandle),2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCCPW.MR.Interface).CheckSyndBeforeDischarge()
ClassMethod CheckSyndBeforeDischarge(EpisodeID As %String, UserID As %String) As %String
{
	New (EpisodeID,UserID)
	Set ret=0
	Quit:(+EpisodeID=0)!(+UserID=0) ret
	//临床路径记录是否有效校验
	Set MrAdmObj=##class(DHCMed.Base.MRAdm).GeObjtByPaadm(EpisodeID)
	Quit:'$IsObject(MrAdmObj) ret
	Set MrAdmDR=MrAdmObj.Rowid
	//该患者不是入径患者，直接退出
	Quit:'$d(^DHCMRi("CPW",0,"IndexMRAdm"," "_MrAdmDR)) ret
	Set CPWID=$o(^DHCMRi("CPW",0,"IndexMRAdm"," "_MrAdmDR,""),-1)
	Set CPWString=##class(web.DHCCPW.MR.ClinicalPathWays).GetStringById(CPWID,"^")
	Quit:CPWString="" ret
	Set Status=$p($g(CPWString),"^",9)
	Quit:Status'="I" ret //I:入径，O:出径,C:完成
	//
	Set SyndStr=##class(web.DHCCPW.MRC.BaseConfig).GetValueByCode("CheckSyndBeforeDischarge")
	Set SyndStr=$s((SyndStr="Y")!(SyndStr="N"):SyndStr,1:"")
	Set UserType=##Class(web.DHCCPW.MR.PaPatmasSrv).getCPTInternalType(UserID)
	Quit:(SyndStr="")!(UserType'="DOCTOR") ret
	Set SyndFlg=##class(web.DHCCPW.MR.ClinPathWaysSyndrome).GetSyndInfoByCPWID(CPWID)
	If ($p(SyndFlg,"^",1)="") {
		Set ret=SyndStr_"^"_"未填写临床路径合并症、并发症!!"
	}
	Quit ret
}

}
