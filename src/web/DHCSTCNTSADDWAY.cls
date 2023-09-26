Import sqluser

/// 维护点评方式
Class web.DHCSTCNTSADDWAY Extends %Persistent
{

/// 增加点评方式
/// w ##class(web.DHCSTCNTSADDWAY).AddWay("testcode","测试方式","Y","N")
ClassMethod AddWay(WayCode, WayDesc, WayActive, OtherStr = "") As %String
{
	//s ^tmyq("AddWay")=WayCode_","_WayDesc_","_WayActive_","_OtherStr
	s resaveflag=$p(OtherStr,"^",1)
	s chkexist=0
	s wayid="0"
	f  s wayid=$o(^DHCPCWAY(wayid)) q:wayid=""  d
	.s tmpcode=$p(^DHCPCWAY(wayid),"^",1)
	.i tmpcode=WayCode d
	..s chkexist=1
	.s tmpdesc=$p(^DHCPCWAY(wayid),"^",2)
	.i tmpdesc=WayDesc d
	..s chkexist=1
	q:chkexist=1 -99	
	k PLIST
	s PLIST(2)=WayCode
	s PLIST(3)=WayDesc
	s PLIST(4)=WayActive
	s PLIST(6)=resaveflag
	
	&sql(INSERT INTO DHC_PHCNTSWAY VALUES :PLIST())
 	i SQLCODE'=0 q -1
 	q 0
}

/// 修改点评方式
ClassMethod UpdWay(WayCode, WayDesc, WayActive, WayID, OtherStr = "") As %String
{
	s resaveflag=$p(OtherStr,"^",1)
	s exitflag=0
	s pwayid="0"
	f  s pwayid=$o(^DHCPCWAY(pwayid)) q:(pwayid="")||(exitflag=1)  d
	.q:pwayid=WayID
	.s pwaycode=$p(^DHCPCWAY(pwayid),"^",1)
	.s:pwaycode=WayCode exitflag=1
	.q:exitflag'=0
	.s pwaydesc=$p(^DHCPCWAY(pwayid),"^",2)
	.s:pwaydesc=WayDesc exitflag=1
	q:exitflag=1 -101
	
	&sql(update  DHC_PHCNTSWAY set PWAY_Code=:WayCode,PWAY_Desc=:WayDesc,PWAY_Active=:WayActive,PWAY_ReSaveFlag=:resaveflag where PWAY_RowID=:WayID)
 	i SQLCODE'=0 q -1
 	q 0
}

/// 获取注射剂集合
ClassMethod QueryWayDs() As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s wayid="0"
	f  s wayid=$o(^DHCPCWAY(wayid)) q:wayid=""  d
	.s waycode=$p(^DHCPCWAY(wayid),"^",1)
	.q:waycode=""
	.s waydesc=$p(^DHCPCWAY(wayid),"^",2)
	.q:waydesc=""
	.s wayactive=$p(^DHCPCWAY(wayid),"^",3)
	.s resaveflag=$p(^DHCPCWAY(wayid),"^",5)
	.i $f(waydesc,$c(13))  s waydesc=$p(waydesc,$c(13))
	.s h=h+1
    .s data=waycode_"^"_waydesc_"^"_wayactive_"^"_wayid_"^"_resaveflag
    .s ^TMP("dhcpha","DHCSTCNTSADDWAY","QueryWayDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSADDWAY","QueryWayDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSADDWAY","QueryWayDs",pid,h)
    .s waycode=$p(data,"^",1)
    .s waydesc=$p(data,"^",2)
    .s wayactive=$p(data,"^",3)
    .s wayrowid=$p(data,"^",4)
    .s resaveflag=$p(data,"^",5)
    .
    .s waycode=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("waycode",waycode)
    .s waydesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("waydesc",waydesc)
    .s wayactive=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("wayactive",wayactive)
    .s resaveflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("resaveflag",resaveflag)
	.s wayrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("wayrowid",wayrowid)
	.
	.s tmpstr=waycode_waydesc_wayactive_resaveflag_wayrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSADDWAY","QueryWayDs",pid)
	q ""
}

/// 获取点评方式集合(激活)
ClassMethod QueryActiveWayDs(Type) As %String
{
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s wayid="0"
	f  s wayid=$o(^DHCPCWAY(wayid)) q:wayid=""  d
	.s waycode=$p(^DHCPCWAY(wayid),"^",1)
	.q:(Type="2")&(waycode'="IP")
	.q:(Type="1")&(waycode="IP") 
	.s waydesc=$p(^DHCPCWAY(wayid),"^",2)
	.q:waydesc=""
	.s wayactive=$p(^DHCPCWAY(wayid),"^",3)
	.q:wayactive'="Y"
	.i $f(waydesc,$c(13))  s waydesc=$p(waydesc,$c(13))
	.s h=h+1
    .s data=waydesc_"^"_wayid
    .s ^TMP("dhcpha","DHCSTCNTSADDWAY","QueryActiveWayDs",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSADDWAY","QueryActiveWayDs",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSADDWAY","QueryActiveWayDs",pid,h)
    .s waydesc=$p(data,"^",1)
    .s wayrowid=$p(data,"^",2)
    .
    .s waydesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("waydesc",waydesc)
	.s wayrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("wayrowid",wayrowid)
	.
	.s tmpstr=waydesc_wayrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSADDWAY","QueryActiveWayDs",pid)
	q ""
}

/// 获取点评方式串(激活)
ClassMethod GetAllPageUrls() As %String
{
	s result=""
	s wayid=""
	f  s wayid=$o(^DHCPCWAY(wayid)) q:wayid=""  d
    .s waycode=$p(^DHCPCWAY(wayid),"^",1)
    .q:waycode=""
	.s waydesc=$p(^DHCPCWAY(wayid),"^",2)
	.q:waydesc=""
	.s wayactive=$p(^DHCPCWAY(wayid),"^",3)
	.q:wayactive'="Y"
	.i $f(waydesc,$c(13))  s waydesc=$p(waydesc,$c(13))
    .s data=waydesc_"^"_waycode
    .i result="" d
    ..s result=data
    .e  d
    ..s result=result_"#"_data
	q result
}

/// 根据代码查询ID
/// Modified by MYQ 20160810 根据代码索引查询id
ClassMethod GetWayDrByCode(code) As %String
{
	s ret=""
	q:code="" ret
	s ret=$o(^DHCPCWAY(0,"Code",code,""),-1) 
	i ret="" d
	.s wayid="0"
	.f  s wayid=$o(^DHCPCWAY(wayid)) q:wayid=""  d
    ..s waycode=$p(^DHCPCWAY(wayid),"^",1)
    ..q:waycode=""
    ..q:waycode'=code
    ..s ret=wayid
    
    q ret
}

/// 处方点评方式安全组配置
ClassMethod AddItmWay(wayid, grpdr, input) As %String
{
	s updateflag="Yes"
	s updateflag=$p(input,"^",1)
	;add by myq 20150824 不能重复添加
	s chl="",existflag=""
	f  s chl=$o(^DHCPCWAY(wayid,"I",chl)) q:((chl="")||(existflag=1))  d
	.s wayusergrp=$p(^DHCPCWAY(wayid,"I",chl),"^",1)
	.s:wayusergrp=grpdr existflag=1
	q:existflag=1 -2
	s sub=+$o(^DHCPCWAY(wayid,"I",""),-1)+1
	q:'$d(^SSU("SSGRP",grpdr)) -100		//不存在此安全组
	//
	&sql(INSERT INTO DHC_PHCNTSWAYITM (PWAYI_Parref,PWAYI_ChildSub,PWAYI_UserGroup_Dr,PWAYI_UpdateFlag )
	VALUES (:wayid,:sub,:grpdr,:updateflag))
	
 	i SQLCODE'=0 q -1
 	q 0
}

/// 修改处方点评方式安全组配置
/// w ##class(web.DHCSTCNTSADDWAY).UpdItmWay("3||3","自助收费","","N")
ClassMethod UpdItmWay(wayitmid, secgrp, grpdr, input) As %String
{
	s updateflag=$p(input,"^",1)
	s wayid=$p(wayitmid,"||",1)
	s sub=$p(wayitmid,"||",2)
	s chl="",existflag=""
	f  s chl=$o(^DHCPCWAY(wayid,"I",chl)) q:((chl="")||(existflag=1))  d
	.s wayusergrp=$p(^DHCPCWAY(wayid,"I",chl),"^",1)
	.s:wayusergrp=grpdr existflag=1
	q:existflag=1 -2
	s secgrpdr=""
	s secgrpdr=$o(^SSU("SSGRP",0,"Desc",$$ALPHAUP($g(secgrp)),secgrpdr)) q:secgrpdr=""
	i grpdr="" s grpdr=secgrpdr
	&sql(update DHC_PHCNTSWAYITM set PWAYI_Parref=:wayid,PWAYI_ChildSub=:sub, PWAYI_UserGroup_Dr=:grpdr,PWAYI_UpdateFlag=:updateflag where PWAYI_RowID=:wayitmid)
 	i SQLCODE'=0 q -1
 	q 0
}

// w ##class(web.DHCSTCNTSADDWAY).GetAllItmWay(3)

ClassMethod GetAllItmWay(wayid) As %String
{
	s ^tmyq("GetAllItmWay")=wayid
	s wayid=+wayid
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s sub=""
	f  s sub=$o(^DHCPCWAY(wayid,"I",sub)) q:sub=""  d
	.s grpdesc=""
	.s grpdr=$p(^DHCPCWAY(wayid,"I",sub),"^",1)
	.q:'$d(^SSU("SSGRP",grpdr))
	.i +grpdr'="0" d
	..s grpdesc=$p(^SSU("SSGRP",grpdr),"^",1)
	.s updateflag=$p(^DHCPCWAY(wayid,"I",sub),"^",2)
	.s h=h+1
	.s wayitmid=wayid_"||"_sub
    .s data=grpdesc_"^"_updateflag_"^"_wayitmid
    .s ^TMP("dhcpha","DHCSTCNTSCOMMON","GetAllItmWay",pid,h)=data

    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
 
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSCOMMON","GetAllItmWay",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSCOMMON","GetAllItmWay",pid,h)
    .s secgrp=$p(data,"^",1)
    .s updateflag=$p(data,"^",2)
    .s wayitmid=$p(data,"^",3)
    .
    .s secgrp=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("secgrp",secgrp)
	.s updateflag=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("updateflag",updateflag)
	.s wayitmid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("wayitmid",wayitmid)
	.
	.s tmpstr=secgrp_updateflag_wayitmid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSCOMMON","GetAllItmWay",pid)
	q ""
}

/// 处方点评方式安全组配置
ClassMethod DelItmWay(wayitmid) As %String
{
    &sql(delete from DHC_PHCNTSWAYITM where PWAYI_RowId=:wayitmid)
	
 	i SQLCODE'=0 q -1
 	q 0
}

Storage Default
{
<Data name="DHCSTCNTSADDWAYDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCSTCNTSADDWAYD</DataLocation>
<DefaultData>DHCSTCNTSADDWAYDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCSTCNTSADDWAYD</IdLocation>
<IndexLocation>^web.DHCSTCNTSADDWAYI</IndexLocation>
<StreamLocation>^web.DHCSTCNTSADDWAYS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
