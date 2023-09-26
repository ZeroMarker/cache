Import SQLUser

/// Lid
/// 2010-08-23
/// DHCBILL类库业务类
Class web.DHCBILLLLibraryLogic Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCBILLLLibraryLogic).GetCompQueryInfo("INSUTarItemsCom","","1")
ClassMethod GetCompQueryInfo(compName, group, guser)
{
	n (compName, group, guser)
	s compid=##Class(websys.Component).GetIdFromCodeOrDescription(compName)	
	s comObj=##Class(websys.Component).%OpenId(compid)
	s className=comObj.ClassName
	s queryName=comObj.QueryName
	s query=className_":"_queryName
	s resultObj=##class(%ResultSet).%New(query)
    s queryParamCount=resultObj.GetParamCount()
    s paramStr=""
    f i=1:1:queryParamCount d
    .s paramName=resultObj.GetParamName(i)
    .i paramStr="" s paramStr=paramName
    .e  s paramStr=paramStr_"^"_paramName
    
    ;取组件上查询元素 ;^websys.ComponentItemsD
    s sub="",flag=0,itmName=""
    f  s sub=$o(^websys.ComponentItemsD(compid,sub)) q:(sub="")!(flag=1)  d
    .s str=$g(^websys.ComponentItemsD(compid,sub))
    .s displayType=$LG(str,8)
    .q:displayType'="B"
    .s hideFlag=$LG(str,7)
    .q:hideFlag'=0 
    .s linkComp=$LG(str,12) ;
    .q:linkComp'=compName
    .s itmName=$LG(str,19)
    .s flag=1
    
    ;取组件列编辑器中定义的信息，优先级:用户——>安全组——>站点
	s ConfigurationID = $o(^websys.ConfigurationD(0))
	s Config=##Class(websys.Configuration).%OpenId(ConfigurationID)
	s SiteCode=Config.SiteCode  
	s rowList=""
	;按用户^websys.PreferencesD
	s rowList=##Class(websys.Preferences).GetData("User.SSUser",guser,"ROWS",compName)
	i rowList="" d
	.;按安全组
	.s rowList=##Class(websys.Preferences).GetData("User.SSGroup",group,"ROWS",compName)
    i rowList="" d
    .;按站点
    .s rowList=##Class(websys.Preferences).GetData("SITE",SiteCode,"ROWS",compName)
    s rows=0  
    i rowList'="" d
    .s rows=$ListGet(rowList,1)
    i +rows=0 s rows=25  ;默认是25，根据系统设定
    
    d Config.%Close()
	d resultObj.%Close()
	Do comObj.%Close()
	
	s rtn=compid_$c(2)_className_"^"_queryName_"^"_paramStr_$c(2)_rows_$c(2)_itmName
	q rtn
}

/// Lid
/// 2010-08-22
/// 设置组件上表格的滚动条配置信息
/// data:组件名^自定义滚动条样式^自定义列头样式^Table宽度^Table高度^滚动条位置
/// w ##class(web.DHCBILLLLibraryLogic).SetScrollData("INSUDicDataCom","1","1","SITE","INSUDicDataCom^^^^200^")
ClassMethod SetScrollData(compName, group, guser, scope, data)
{
	n (compName, group, guser, scope, data)
	s compName=$tr(compName,".")
	s compName=$ZCVT(compName,"U")
	i scope="GUSER" d  //用户
	.s ^DHCBILLScrollData(compName,scope,guser)=data
	i scope="GROUP" d  //安全组
	.s ^DHCBILLScrollData(compName,scope,group)=data
	i scope="SITE" d   //站点
	.s ConfigurationID = $o(^websys.ConfigurationD(0))
	.s Config=##Class(websys.Configuration).%OpenId(ConfigurationID)
	.s SiteCode=Config.SiteCode  
	.s ^DHCBILLScrollData(compName,scope,SiteCode)=data
	q 0
}

/// Lid
/// 2010-08-22
/// 获取组件上表格的滚动条配置信息
/// ;^DHCBILLScrollData(组件名,保存权限,guser/group/sitecode)=tableName^tableClassName^tblHeadClassName^divWidth^divHeight^ScrollPosition^colLockFlag
ClassMethod GetScrollInfo(compName, group, guser)
{
	n (compName, group, guser)
	s compName=$tr(compName,".")
	s compName=$ZCVT(compName,"U")
	s ConfigurationID = $o(^websys.ConfigurationD(0))
	s Config=##Class(websys.Configuration).%OpenId(ConfigurationID)
	s SiteCode=Config.SiteCode  
	s rtn=""
	i $d(^DHCBILLScrollData(compName,"GUSER",guser)) d
	.s rtn=$g(^DHCBILLScrollData(compName,"GUSER",guser))
	q:rtn'="" rtn
	i $d(^DHCBILLScrollData(compName,"GROUP",group)) d
	.s rtn=$g(^DHCBILLScrollData(compName,"GROUP",group))
	q:rtn'="" rtn
	i $d(^DHCBILLScrollData(compName,"SITE",SiteCode)) d
	.s rtn=$g(^DHCBILLScrollData(compName,"SITE",SiteCode))
	q:rtn'="" rtn
	i rtn="" s rtn="^^^^^^^^^^^^^^^"
	q rtn
}

///  Lid
///  2010-08-27
///  入参:名称,人员Rowid
///  出参:名称^安全组Rowid
///  查询安全组信息(支持根据"名称"查询,且如果人员信息已存在，则只查询改人员所在的安全组信息)
///  ;d ##class(%ResultSet).RunQuery("web.DHCBILLLLibraryLogic","GetSecurityGroup","","")
Query GetSecurityGroup(desc As %String, user As %String) As %Query(ROWSPEC = "Id:%String,Group:%String")
{
}

ClassMethod GetSecurityGroupExecute(ByRef qHandle As %Binary, desc As %String, user As %String) As %Status
{
	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
    ;i desc="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    ;i papmirowid="" Set qHandle=$lb(0,repid,0) Quit $$$OK
    s desc=..UnEscape(desc)
    i user="" d
    .s RowId=""
    .f  s RowId=$o(^SSU("SSGRP",RowId)) q:RowId=""  d
 	..s GrpDesc=$P(^SSU("SSGRP",RowId),"^",1)
 	..q:($ZCVT(GrpDesc,"U")'[$ZCVT(desc,"U"))&(desc'="")
 	..do OutputRow
    e  d
    .s Index=""
    .f  s Index=$o(^SSU("SSUSR",Index)) q:Index=""  d 
    ..s UserName=$p(^SSU("SSUSR",Index),"^",2)
    ..q:(UserName'[user)&(Index'[user)
    ..s RowId=$p(^SSU("SSUSR",Index),"^",5)
    ..q:RowId=""
    ..s GrpDesc=$P(^SSU("SSGRP",RowId),"^",1)
    
    ..Do OutputRow
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(RowId,GrpDesc)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetSecurityGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSecurityGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSecurityGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSecurityGroupExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

///   Lid
///   2010-08-27
///   入参:名称,人员Code,安全组Rowid
///   出参:名称^人员Rowid
///   查询人员信息(支持根据"Code"或"名称"查询,且如果安全组已有值时,只查询改安全组内的信息)
///   ;d ##class(%ResultSet).RunQuery("web.DHCBILLLLibraryLogic","GetUserInfo","","")
Query GetUserInfo(username As %String, grprowid As %String = "") As %Query(ROWSPEC = "TUser:%String,TCode,TRowid")
{
}

ClassMethod GetUserInfoExecute(ByRef qHandle As %Binary, username As %String, grprowid As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ret=0
	
	if ($g(username)=""){
		d OutputRowOPUN
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s username=..UnEscape(username)
	;按照UserCode,模糊查询
	If $g(username)'="" {
		s rowid=$o(^SSU("SSUSR",0,"SSUSR_Initials",$ZCVT(username,"U"),""))
		i (rowid'=""){
			s guserCode=$p(^SSU("SSUSR",rowid),"^",1)
			s guserName=$p(^SSU("SSUSR",rowid),"^",2)
			d OutputRowOPUN
		}
	}
	;按照UserName 模糊查询
	s myName=""
	f  s myName=$o(^SSU("SSUSR",0,"SSUSR_Name",myName)) q:(myName="")  d
	.q:(($zcvt(myName,"U")'[$zcvt(username,"U"))&&(username'=""))
	.s rowid=0
	.f  s rowid=$o(^SSU("SSUSR",0,"SSUSR_Name",myName, rowid))  q:(rowid="")  d
	..s guserCode=$p(^SSU("SSUSR",rowid),"^",1)
	..s guserName=$p(^SSU("SSUSR",rowid),"^",2)
	..d OutputRowOPUN
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
ValidateOPUN
	s (rowid,guserName,guserCode)=""
	q
OutputRowOPUN
	set Data=$lb(guserName,guserCode,rowid)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetUserInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUserInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

///    Lid
///    2010-08-27
///    验证指定权限下的添加滚动条样式是否存在
ClassMethod JudgeScrollExitYN(compName, group, guser, scope)
{
	n (compName, group, guser, scope)
	s compName=$tr(compName,".")
	s compName=$ZCVT(compName,"U")
	s rtn=-1
	i scope="GUSER" d  //用户
	.i $d(^DHCBILLScrollData(compName,scope,guser)) s rtn=0
	i scope="GROUP" d  //安全组
	.i $d(^DHCBILLScrollData(compName,scope,group)) s rtn=0
	i scope="SITE" d   //站点
	.s ConfigurationID = $o(^websys.ConfigurationD(0))
	.s Config=##Class(websys.Configuration).%OpenId(ConfigurationID)
	.s SiteCode=Config.SiteCode  
	.i $d(^DHCBILLScrollData(compName,scope,SiteCode)) s rtn=0
	
	q rtn
}

///     Lid
///     2010-08-27
///     删除滚动条样式
ClassMethod DeleteScroll(delStr)
{
	n (delStr)
	s rtn=-1
	f i=1:1:$l(delStr,"!") d
	.s compName=$p($p(delStr,"!",i),"^",1)
	.s scope=$p($p(delStr,"!",i),"^",2)
	.s sub=$p($p(delStr,"!",i),"^",3)
	.s compName=$tr(compName,".")
	.s compName=$ZCVT(compName,"U")
	.i scope="GUSER" d  //用户
	..k ^DHCBILLScrollData(compName,scope,sub)
	..s rtn=0
	.i scope="GROUP" d  //安全组
	..k ^DHCBILLScrollData(compName,scope,sub)
	..s rtn=0
	.i scope="SITE" d   //站点
	..k ^DHCBILLScrollData(compName,scope,sub)
	..s rtn=0
	q rtn
}

///      Lid
///      2010-08-27
///      查询信息(可以根据"组件"名查询)
///      返回值:序号^组件名^用户名^安全组名^站点名^权限^DIV高度^DIV宽度^滚动条位置(左/右)^是否锁定列
Query SearchScrollInfo(txtComponentName As %String) As %Query(ROWSPEC = "RecordSum,TInd,TScopeDesc,TComponentName,TGuserName,TGroupDesc,TSiteName,TWidth,THeight,TLocation,TSub,TColLockFlag")
{
}

ClassMethod SearchScrollInfoExecute(ByRef qHandle As %Binary, txtComponentName As %String) As %Status
{
	;w ##class(%ResultSet).RunQuery("web.DHCBILLLLibraryLogic","SearchScrollInfo","")
	//;^DHCBILLScrollData(组件名,保存权限,guser/group/sitecode)=tableName^tableClassName^tblHeadClassName^divWidth^divHeight^ScrollPosition^colLockFlag
	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s compName=txtComponentName
	s compName=$tr(compName,".")
	s compName=$ZCVT(compName,"U")
	s component=""
	
	f  s component=$o(^DHCBILLScrollData(component)) q:component=""  d
	.q:(compName'="")&&(component'=compName)
	.s scope=""
	.f  s scope=$o(^DHCBILLScrollData(component,scope)) q:scope=""  d
	..s sub=""
	..f  s sub=$o(^DHCBILLScrollData(component,scope,sub)) q:sub=""  d
	...s data=$g(^DHCBILLScrollData(component,scope,sub))
	...s componentName=$p(data,"^",1)
	...s width=$p(data,"^",4)
	...s height=$p(data,"^",5)
	...s location=$p(data,"^",6)
	...s colLockFlag=$p(data,"^",7)
	...s (siteName,groupDesc,guserName)=""
	...i scope="SITE" d
	....;s scopeDesc="站点"
	....s siteName=sub
	...e  i scope="GROUP" d
	....;s scopeDesc="安全组"
	....s groupDesc=$p(^SSU("SSGRP",sub),"^",1)
	...e  i scope="GUSER" d
	....;s scopeDesc="用户"
	....s guserName=$p(^SSU("SSUSR",sub),"^",2)
	...Do OutputRow2
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow2
    set Data=$lb(0,ind,scope,componentName,guserName,groupDesc,siteName,width,height,location,sub,colLockFlag)
    Set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod SearchScrollInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchScrollInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SearchScrollInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchScrollInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		s RecordSum=$o(^CacheTemp(repid,""),-1)
 		s $LIST(^CacheTemp(repid,ind),1)=RecordSum
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:zhaoym
/// CreatDate:2008-10-14
/// Description: 解密JS加密字符串
/// Input:  需解密字符串
/// Return: 解密后的字符串
/// Others: 为了解决P8版本汉字模糊查询翻页后无法正常显示的问题
///         在在组件使用该类方法得到值及Query中执行查询前进行该转换  
///        InStr：入参          
ClassMethod UnEscape(InStr As %String) As %String
{
	n (InStr)
	s num=1,retStr="",tmpNum=1	
	f num=1:1:$l(InStr,"%") d
	.s char=$p(InStr,"%",num) 
	.i num=1 d
	..s retStr=$e(char,1,$l(char))
	.e  d
	..i $e(char,1,1)'="u" d
	...s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
	..e  d
	...s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))
	q retStr
}

}
