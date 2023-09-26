Import sqluser

/// Creator: 	hulihua
/// CreateDate: 2016-09-28
/// Descript: 	公共控件类
Class web.DHCINPHA.MTCommon.CommonUtil Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:获取煎药室状态
/// Creator:	hulihua
/// CreateDate:	2017-11-29
/// Table:      CT_LOC、ss_groupstocklocations
/// Input:
/// Output:		煎药状态（煎药状态下拉框显示）
/// Return：
/// Others:    		 
/// w ##class(web.DHCINPHA.MTCommon.CommonUtil).GetDecConComb("select2")
ClassMethod GetDecConComb(style = "") As %String
{
	N (style)
	s Title="RowId^Desc"
	i style["select2" s Title="id^text"
	s h=0
	S PID=..NewPid("web.DHCINPHA.MTCommon.CommonUtil")
	d ..ClearTmp("web.DHCINPHA.MTCommon.CommonUtil","GetDecConComb",PID,"Data")
	s ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.CommonUtil","GetDecConComb",PID,"Data",h)="0^调剂"
	s MbcsId=0
	f  s MbcsId=$o(^DHCMBCS(MbcsId)) q:MbcsId=""  d
	.q:$p(^DHCMBCS(MbcsId),"^",3)="N"
	.q:$p(^DHCMBCS(MbcsId),"^",4)'="I"
	.s MbDesc=$p(^DHCMBCS(MbcsId),"^",2)
	.s h=h+1
	.s data=MbcsId_"^"_MbDesc
	.s ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.CommonUtil","GetDecConComb",PID,"Data",h)=data
	
	s count=0
	w "["
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTCommon.CommonUtil","GetDecConComb",PID,"Data",h)) q:h=""  d
	.s data=^TMP("DHCINPHA","web.DHCINPHA.MTCommon.CommonUtil","GetDecConComb",PID,"Data",h)
	.s MbcsId = $p(data,"^",1)
	.s MbDesc = $p(data,"^",2)
	.s tmpstr=MbcsId_"^"_MbDesc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,tmpstr)
	.e  d
	..W ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,tmpstr)
	
	w "]"
	d ..ClearTmp("web.DHCINPHA.MTCommon.CommonUtil","GetDecConComb",PID,"Data")
	q ""
}

/// Description:按照改安全组关联的科室
/// Creator:	hulihua
/// CreateDate:	2016-09-28
/// Table:      CT_LOC、ss_groupstocklocations
/// Input:
/// Output:		安全组关联科室信息（下拉框显示）
/// Return：
/// Others:    		 
/// w ##class(web.DHCINPHA.MTCommon.CommonUtil).GetPhaLocByGrp("38")
ClassMethod GetPhaLocByGrp(grpdr) As %String
{
	N (grpdr)
	s h=0
	S PID=..NewPid("web.DHCINPHA.MTCommon.CommonUtil")
	d ..ClearTmp("web.DHCINPHA.MTCommon.CommonUtil","GetPhaLocByGrp",PID,"Data")
	s sub="0"
	f  s sub=$o(^SSU("SSGRP",grpdr,"ST",sub)) q:sub=""  d
	.s ctlocdr=$p(^SSU("SSGRP",grpdr,"ST",sub),"^",1)
	.q:ctlocdr=""
	.q:'$d(^CTLOC(ctlocdr))
	.s ctlocdesc=$p(^CTLOC(ctlocdr),"^",2)
	.s ctloctype=$p(^CTLOC(ctlocdr),"^",13)
	.q:ctloctype'="D"
	.s h=h+1
	.s data=ctlocdesc_"^"_ctlocdr
	.
	.s ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.CommonUtil","GetPhaLocByGrp",PID,"Data",h)=data
	
	s count=0
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonStartRow()
	s h=""
	f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTCommon.CommonUtil","GetPhaLocByGrp",PID,"Data",h)) q:h=""  d
	.s data=^TMP("DHCINPHA","web.DHCINPHA.MTCommon.CommonUtil","GetPhaLocByGrp",PID,"Data",h)
	.s LocDr = $p(data,"^",2)
	.s LocDesc = $p(data,"^",1)
	.s tmp=LocDr_"^"_LocDesc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData("value^text",tmp)
	.e  d
	..W ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData("value^text",tmp)
	
	w ##class(web.DHCINPHA.MTCommon.JQueryCommon).GetJsonEndRow()
	d ..ClearTmp("web.DHCINPHA.MTCommon.CommonUtil","GetPhaLocByGrp",PID,"Data")
	q ""
}

/// Description:按照类型获取该类型的科室
/// Creator:	hulihua
/// CreateDate:	2016-09-29
/// Table:      CT_LOC
/// Input:
/// Output:		所有病区描述（下拉框显示）
/// Return：
/// Others:    		 
/// w ##class(web.DHCINPHA.MTCommon.CommonUtil).GetWardLoc("W","hx")
ClassMethod GetWardLoc(LocType, combotext = "") As %String
{
	N (LocType,combotext)
	s combotext=$zcvt(combotext,"U")
	S result = ##class(%Library.ResultSet).%New()
	S sqlStr = "SELECT CTLOC_ROWID AS RowId, CTLOC_DESC AS Description ,CTLOC_ContactName AS Name FROM CT_Loc WHERE CTLOC_TYPE ="_"'"_LocType_"'"_" ORDER BY CTLOC_ROWID"
    D result.Prepare(sqlStr)
	D result.Execute()
	S count = 0
	W "["
	While(result.Next())
	{	
		S Rowid = result.Data("RowId")
		s ActTo=$p(^CTLOC(Rowid),"^",25)
    	Continue:(ActTo'="")&&(ActTo<+$H)
		S WardDesc = result.Data("Description")
		S WardName = result.Data("Name")
		continue:(combotext'="")&&($zcvt(WardName,"U")'[combotext)&&(WardDesc'[combotext)
		S tmp=Rowid_"^"_WardDesc
		S count = count+1
		I count=1 D
		.W ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData("value^text",tmp)
		E  D
		.W ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData("value^text",tmp)
	}
	w "]"
	q ""
}

/// Description:查询送药科室信息
/// Creator:	hulihua
/// CreateDate:	2016-09-12
/// Table:      DHC_PHSendLoc
/// Input:
/// Output:
/// Return：    
/// w ##class(web.DHCINPHA.MTCommon.CommonUtil).GetLocByLocTypeList("W","心内一科护理单元")
ClassMethod GetLocByLocTypeList(LocType, params) As %Integer
{
	 n (LocType, params)
	 //s ^hlh($h)=$lb(LocType, params)
     s page=1
     s rows=100
	 s End = page*rows
	 s Start=(page-1)*rows+1
	 s InputLocDesc=$p(params,"^",1)
	 s PhLoc=$p(params,"^",2)
	 s pid=..NewPid("web.DHCINPHA.MTCommon.CommonUtil")
	 d ..ClearTmp("web.DHCINPHA.MTCommon.CommonUtil","GetWardLocList",pid)
	 s n=0
	 s locdr="" 
	 f  s locdr=$o(^CTLOC(0,"LocType",LocType,locdr)) q:locdr=""  d
	 .q:(PhLoc'="")&&($d(^DHCPHSLi("PHLOC",PhLoc,locdr)))
	 .s locdesc=$p(^CTLOC(locdr),"^",2)
	 .q:(InputLocDesc'="")&&(locdesc'[InputLocDesc) 
	 .s n=n+1
	 .s data=$g(locdr)_"^"_$g(locdesc)
	 .s ^TMP("DHCINPHA","web.DHCINPHA.MTCommon.CommonUtil","GetWardLocList",pid,n)=data
     q:n=0 ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEmptySign(n) //输出空的json串
     w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonStartSign(n) //输出json前缀串

     s maxrow=n
     s count=0
     s h=""
     f  s h=$o(^TMP("DHCINPHA","web.DHCINPHA.MTCommon.CommonUtil","GetWardLocList",pid,h)) q:h=""  d
     .s mdata=^TMP("DHCINPHA","web.DHCINPHA.MTCommon.CommonUtil","GetWardLocList",pid,h)
     .s count = count+1
	 .s Title="rowid^LocDesc"
	 .q:(count<Start)||(count>End)
	 .I count=Start d
	 ..w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	 .e  d
	 ..w ","_##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonData(Title,mdata)
	
	 w ##class(web.DHCINPHA.MTCommon.JQueryCommon).getJsonEndSign() //输出json结尾符
	 d ..ClearTmp("web.DHCINPHA.MTCommon.CommonUtil","GetWardLocList",pid)
     q ""
}

/// Descript:js 获取登录信息
/// w ##Class(web.DHCINPHA.MTCommon.CommonUtil).getHopDesc()
/// hulihua
ClassMethod getHopDesc() As %String
{
	n (%session)
	q:'$d(%session) ""
	q:+%session.Get("LOGON.HOSPID")=0 ""
	q:+%session.Get("LOGON.CTLOCID")=0 ""
	w "<SCRIPT Language='JavaScript'> var gHospDesc='"_$p(^CT("HOSP",%session.Get("LOGON.HOSPID")),"^",2)_
	"';var gLocDesc='"_$p(^CTLOC(%session.Get("LOGON.CTLOCID")),"^",2)_"';</SCRIPT>"
}

/// 获取系统日期格式配置
/// @return 
///    1 MM/DD/YYYY
///    3 YYYY-MM-DD
///    4 DD/MM/YYYY
ClassMethod DateFormat()
{
	n
	s dateformat=$lg(^websys.ConfigurationD(1),10)
	s datesper=$lg(^websys.ConfigurationD(1),4)
	i (dateformat="DMY")&&(datesper="/") Quit 4
	i (dateformat="YMD")&&(datesper="-") Quit 3
	i (dateformat="MDY")&&(datesper="/") Quit 1
	Quit 4
}

/// w ##Class(web.DHCINPHA.MTCommon.CommonUtil).UserNameToRowID()
ClassMethod UserNameToRowID(TmpUserName) As %Library.String
{
 s PP=""
 &sql( SELECT SSUSR_RowId INTO :PP FROM SS_USER WHERE SSUSR_Name=:TmpUserName)
 q $g(PP)
}

ClassMethod PrintComm() As %String
{
    s setstr=##class(Nur.DHCMGNurseSet).getSet()
 	s webIP=$P(setstr,"^",2)
 	s dllstr=webIP_"/dhcmg/DHCCNursePrintComm.dll#DHCCNursePrintComm.WebInterface"
 	w "<OBJECT id=""DHCCNursePrintComm""  width=""0"" height=""0"" classid="""_dllstr_""" IEWASTEXT></OBJECT>",!
 	w "<SCRIPT Language='JavaScript'>session['WebIP']="_""""_webIP_""";</SCRIPT>"
    q 0
}

/// Description:新建临时global的计数器
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCINPHA.MTCommon.CommonUtil).NewPid()
ClassMethod NewPid(ClassName As %String) As %String
{
	N (ClassName)
  	Q $I(^DHCINPHAPID("DHCINPHA",ClassName))
}

/// Description:Kill临时global的公共方法
/// Creator:	hulihua
/// CreateDate:	2016-06-05
/// Table:      
/// Input:      
/// Output:		
/// Return：
/// w ##class(web.DHCINPHA.MTCommon.CommonUtil).ClearTmp()
ClassMethod ClearTmp(ClassName As %String, MethodName As %String, pid As %String, PAR As %String = "") As %String
{
	N (ClassName, MethodName, pid, PAR)
	I PAR'="" D
	.K ^TMP("DHCINPHA",ClassName,MethodName,pid,PAR)
	E  D
	.K ^TMP("DHCINPHA",ClassName,MethodName,pid)
	Q ""
}

}
