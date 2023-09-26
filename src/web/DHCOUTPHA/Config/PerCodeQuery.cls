Import SQLUser

/// creator:dinghongying
/// createdate:20160614
/// descirpiton:门诊药房药房人员代码维护
Class web.DHCOUTPHA.Config.PerCodeQuery Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", ProcedureBlock ]
{

/// 药房人员代码列表
/// d ##class(web.DHCOUTPHA.Config.PerCodeQuery).jsGetPharmacyStaffList("2","30","100^^^0^0^0^0")
ClassMethod jsGetPharmacyStaffList(page, rows, params, HospId = "")
{
	s stpage=((page-1)*rows)+1 //开始行
	s endpage=page*rows  //结束行
	s pid=##class(web.DHCOUTPHA.Common.CommonUtil).NewPid($this)
	d ##class(web.DHCOUTPHA.Common.CommonUtil).ClearTmp($this,"jsGetPharmacyStaffList",pid)
    s $zt="ErrorjsGetPharmacyStaffList"
    s result=##class(%Library.ResultSet).%New("web.DHCOUTPHA.Config.PerCodeQuery:FindPhPer")
	s sc=result.Execute(params,HospId)
	i $$$ISERR(sc) q ##class(web.DHCPHACOM.ComPubClass.JQueryCommon).getJsonEmptySign(0) 
	s colNum=result.GetColumnCount()
	s colNameStr=""
	f i=1:1:colNum d
	.i colNameStr="" s colNameStr=result.GetColumnName(i)
	.e  s colNameStr=colNameStr_"^"_result.GetColumnName(i)
	s countrecords=0
	While(result.Next())
	{ 
		s ret=""
		f i=1:1:colNum d
		.s retvalue=result.%GetData(i)
		.i ret="" s ret=retvalue
		.e   s ret=ret_"^"_retvalue
		s countrecords=countrecords+1  //可做索引用
		s ^TMP("DHCOUTPHA",$this,"jsGetPharmacyStaffList",pid,countrecords)=ret
	}
	q:countrecords="0" ##class(web.DHCPHACOM.ComPubClass.JQueryCommon).getJsonEmptySign(0)
	i endpage>countrecords s endpage=countrecords
	s count=0
	s outputi=""
	f  s outputi=$o(^TMP("DHCOUTPHA",$this,"jsGetPharmacyStaffList",pid,outputi)) q:outputi=""  d
	.s outputdata=^TMP("DHCOUTPHA",$this,"jsGetPharmacyStaffList",pid,outputi)
	.s count=count+1
	.q:count<stpage
    .q:count>endpage
	.I count=stpage d
	..w ##class(web.DHCPHACOM.ComPubClass.JQueryCommon).GetJsonStartString(countrecords)
	..W ##class(web.DHCPHACOM.ComPubClass.JQueryCommon).getJsonData(colNameStr,outputdata)
	.e  d
	..W ","_##class(web.DHCPHACOM.ComPubClass.JQueryCommon).getJsonData(colNameStr,outputdata)
	.i count=endpage w ##class(web.DHCPHACOM.ComPubClass.JQueryCommon).getJsonEndSign()
	d ##class(web.DHCOUTPHA.Common.CommonUtil).ClearTmp($this,"jsGetPharmacyStaffList",pid)
	q ""
ErrorjsGetPharmacyStaffList
	d ##class(web.DHCOUTPHA.Common.CommonUtil).ClearTmp($this,"jsGetPharmacyStaffList",pid)
	s Error=$$Error^DHCSTERROR()
	q Error
}

Query FindPhPer(params As %Library.String = "", HospId = "") As websys.Query(ROWSPEC = "TLocDesc:%String,TPhlid:%String,TUserName:%String,TUserCode:%String,TPyFlag:%String,TFyFlag:%String,TUseFlag:%String,TPhpid:%String,TCheckFlag:%String,TUserId:%String,TCtLocId:%String") [ SqlProc ]
{
}

ClassMethod FindPhPerExecute(ByRef QHandle As %Binary, params As %Library.String = "", HospId = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s logctlocdr=$g(%session.Data("LOGON.USERID"))
	s logctlocdrstr=##class(web.DHCOUTPHA.Common.Method).GetLocFrUser(logctlocdr)
    s logctloccnt=$l(logctlocdrstr,"^")   
	set myrowid=0
 	for  s myrowid=$o(^DHCPHPER(myrowid)) q:(myrowid="")!(myrowid="0")  d
 	   .s phl="",okflag="",nouse="",windesc="",tr=0,chkloglocflag=0
 	   .s ctlocdesc="",ctloc="",manflag="",loc="",checkflag=""
 	   .s phl=+$p(^DHCPHPER(myrowid),"^",3)
 	   .s ctloc=+$p(^DHCPHLOC(phl),"^",1)
 	   .q:(HospId'="")&&($p($g(^CTLOC(ctloc)),"^",22)'=HospId)
 	   .f locdrnum=1:1:logctloccnt d
 	   ..s tmpstr=$p(logctlocdrstr,"^",locdrnum)
 	   ..s logctlocdr=$p(tmpstr,$c(1),1)
 	   ..q:logctlocdr'=ctloc
 	   ..s chkloglocflag=1
 	   .q:chkloglocflag=0
  	   .s py=$p(^DHCPHPER(myrowid),"^",6)
 	   .s fy=$p(^DHCPHPER(myrowid),"^",1)
 	   .;s manflag=$p(^DHCPHPER(myrowid),"^",9)
 	   .s userid="",usercode="",username=""
 	   .s userid=+$p(^DHCPHPER(myrowid),"^",5)
 	   .q:'$d(^SSU("SSUSR",userid))
 	   .s usercode=$p(^SSU("SSUSR",userid),"^",1)
 	   .s username=$p(^SSU("SSUSR",userid),"^",2)
 	   .s useflag=$p(^DHCPHPER(myrowid),"^",9)
 	   .s checkflag=$p(^DHCPHPER(myrowid),"^",8)
 	   
 	   .s ctlocdesc=$p($g(^CTLOC(ctloc)),"^",2)
 	   .s paramsLocId=$p(params,"^",1)
 	   .s paramsUserId=$p(params,"^",2)
 	   .s paramsUserCode=$p(params,"^",3)
 	   .s paramsPyFlag=$p(params,"^",4)
 	   .s paramsFyFlag=$p(params,"^",5)
 	   .s paramsUseFlag=$p(params,"^",6)
 	   .s paramsCheckFlag=$p(params,"^",7)
 	   .q:(paramsLocId'="")&(paramsLocId'=ctloc)
 	   .q:(paramsUserId'="")&(paramsUserId'=userid)
 	   .q:(paramsUserCode'="")&(usercode'[paramsUserCode)
 	   .q:(paramsPyFlag="1")&(py'="1")
 	   .q:(paramsFyFlag="1")&(fy'="1")
 	   .q:(paramsUseFlag="1")&(useflag'="1")
 	   .q:(paramsCheckFlag="1")&(checkflag'="1")
 	   .i useflag="1" s useflag="是"
 	   .e  s useflag="否"
 	   .i py="1" s py="是" 
 	   .e  s py="否"
 	   .i fy="1" s fy="是"
 	   .e  s fy="否"
 	   .e  s manflag="否"
 	   .i checkflag="1" s checkflag="是"
 	   .e  s checkflag="否"
 	   .Do perOutputRow
 	
 	Set QHandle=$lb(0,repid,0)
 	
	Quit $$$OK
perOutputRow
	set Data=$lb(ctlocdesc,phl,username,usercode,py,fy,useflag,myrowid,checkflag,userid,ctloc)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
perResetVariables
	///set (repid)=0
	set (ctlocdesc,phl,username,usercode,py,fy,useflag,myrowid,checkflag,userid,ctloc)=""
	quit
}

}
