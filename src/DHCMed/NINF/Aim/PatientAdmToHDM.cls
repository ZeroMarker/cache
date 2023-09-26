Class DHCMed.NINF.Aim.PatientAdmToHDM Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊号
Property EpisodeID As %Integer [ Required ];

/// 科室
Property DepartmentID As %Integer [ Required ];

Index IndexEpisodeID On EpisodeID [ Unique ];

Index IndexPaadmLoc On (DepartmentID, EpisodeID) [ Unique ];

/// w ##class(DHCMed.NINF.Aim.PatientAdmToHDM).InsertPatAdmListToHDM()
/// 横断面调查 初始化 数据
ClassMethod InsertPatAdmListToHDM() As %String
{
	k ^DHCMed.NINF.Aim.PatientAdmToHDMI
	k ^DHCMed.NINF.Aim.PatientAdmToHDMD
	
	s ret=0
	
	s INFHDMResDate=##class(DHCMed.SSService.ConfigSrv).GetValueByKeyHospN("INFHDMResDate","")
	q:INFHDMResDate="" ret
	s:INFHDMResDate["/" INFHDMResDate=$zdh(INFHDMResDate,4)
    s:INFHDMResDate["-" INFHDMResDate=$zdh(INFHDMResDate,3)
    
	s LocID=""
	f  s LocID=$o(^CTLOC(LocID)) q:LocID=""  d
	.s LocType=$p($g(^CTLOC(LocID)),"^",13)
	.q:LocType'="E"
	.s Date=""
    .f  s Date=$o(^PAADMi("AdmTypeCurrLoc","I",LocID,Date)) q:(Date="")  d
    ..q:Date=INFHDMResDate	//当天入院的病人不在调查范围之内
    ..s Time=""
    ..f  s Time=$o(^PAADMi("AdmTypeCurrLoc","I",LocID,Date,Time)) q:(Time="")  d
    ...s paadm=""
    ...f  s paadm=$o(^PAADMi("AdmTypeCurrLoc","I",LocID,Date,Time,paadm)) q:(paadm="")  d
	....q:$d(^DHCMed.NINF.Aim.PatientAdmToHDMI("IndexEpisodeID",paadm))
	....s obj=##class(DHCMed.NINF.Aim.PatientAdmToHDM).%New()
	....s obj.EpisodeID=paadm
	....s AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	....q:'$IsObject(AdmObj)
	....s DepartmentID=AdmObj.DepartmentID
	....q:DepartmentID=""
	....s obj.DepartmentID=DepartmentID
	....s rt=obj.%Save()
	....do obj.%Close()
	
	Set DischDateIndex=##Class(DHCMed.SSIO.FromAdmSrv).GetDischDateIndex()  //update by pylian 2016-01-21取出院时间索引	
	i $d(^PAADMi(DischDateIndex,INFHDMResDate)) d
	.s paadm=""
	.f  s paadm=$o(^PAADMi(DischDateIndex,INFHDMResDate,paadm)) q:paadm=""  d
	..q:$d(^DHCMed.NINF.Aim.PatientAdmToHDMI("IndexEpisodeID",paadm))
	..s obj=##class(DHCMed.NINF.Aim.PatientAdmToHDM).%New()
	..s obj.EpisodeID=paadm
	..s AdmObj=##class(DHCMed.Base.PatientAdm).GetObjById(paadm)
	..q:'$IsObject(AdmObj)
	..s DepartmentID=AdmObj.DepartmentID
	..q:DepartmentID=""
	..s obj.DepartmentID=DepartmentID
	..s rt=obj.%Save()
	..do obj.%Close()
	
	s ret=^DHCMed.NINF.Aim.PatientAdmToHDMD
	q ret
}

/// 获取Http服务器信息
/// Trakcare的服务器，不是Medtrak的
ClassMethod GetServerInfo()
{
	n
    Set CurrentNS=$ZNSPACE
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    //Set Server=Config.WebServer
    Set Server=$p(Config.LayoutManager,":",2)
    Set Path=Config.PathToReports
    Set LayOutManager=Config.LayoutManager
    Set WebServerAppURL = "http://"_Config.WebServer_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
   // Set WebServerAppURL = "http://127.0.0.1"_Config.PathToApp //Modified By LiYang 2008-10-08 获取CSP服务器的IP地址以及程序路径
    d Config.%Close()
    s s=CurrentNS_$c(1)_MEDDATA_$c(1)_LABDATA_$c(1)_Server_$c(1)_Path_$c(1)_LayOutManager_$C(1)_WebServerAppURL
	q s
}

Storage Default
{
<Data name="PatientAdmToHDMDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ICUInfoDr</Value>
</Value>
<Value name="3">
<Value>EpisodeID</Value>
</Value>
<Value name="4">
<Value>DepartmentID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.PatientAdmToHDMD</DataLocation>
<DefaultData>PatientAdmToHDMDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.PatientAdmToHDMD</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.PatientAdmToHDMI</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.PatientAdmToHDMS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
