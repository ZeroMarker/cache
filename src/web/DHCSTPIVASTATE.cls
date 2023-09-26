Import SQLUser

/// 配液状态（流程定制）维护 Table(PIVA_State)
Class web.DHCSTPIVASTATE Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod GetStateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStateExecute ]
{
	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		S AtEnd=1
 		S Row=""
 	}
 	Else {				
 		S Row=^CacheTemp(repid,ind)
 	}
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

ClassMethod GetStateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStateExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

/// w ##class(%ResultSet).RunQuery("web.DHCSTPIVASTATE","GetState")
ClassMethod GetStateExecute(ByRef qHandle As %Binary) As %Status
{
	n psdr
	k ^TMP("DHCST","DHCSTPIVASTATE",$j)
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	s group=$s($d(%session):$g(%session.Data("LOGON.GROUPID")),1:"")
	S ind=1
	S number=0
	F  S number=$o(^PIVAS(0,"NUMBER",number)) Q:number=""  D
	.s psdr=""
	.f  S psdr=$o(^PIVAS(0,"NUMBER",number,psdr)) q:psdr=""  d 
	..Q:'$D(^PIVAS(psdr))
 	..S psnumber=$P(^PIVAS(psdr),"^",1)
 	..S psname=$P(^PIVAS(psdr),"^",2)
 	..S psflag=$P(^PIVAS(psdr),"^",3)
 	..S pssysflag=$P(^PIVAS(psdr),"^",4)
 	..S psretflag=$P(^PIVAS(psdr),"^",5)
 	..S psdispflag=$P(^PIVAS(psdr),"^",6)
 	..S pssingleflag=$P(^PIVAS(psdr),"^",8)
 	..S pslocdr=$P(^PIVAS(psdr),"^",7)
 	..q:(group'="")&&('$d(^SSU("SSGRP",group,"ST",0,"Loc",pslocdr))) ; yunhaibao20170122,按登录安全组过滤
 	..s locdesc=""
 	..i pslocdr'="" d
 	...S locdesc=$P(^CTLOC(pslocdr),"^",2)
 	..S type=$P(^PIVAS(psdr),"^",9)
 	..i type="I" s type="住院"
 	..i type="O" s type="门诊"
 	..s tmpnum=1000-psnumber
 	..S index=type_"^"_pslocdr_"^"_tmpnum
 	..S ^TMP("DHCST","DHCSTPIVASTATE",$j,index)=psdr_"^"_psnumber_"^"_psname_"^"_psflag_"^"_pssysflag_"^"_psretflag_"^"_psdispflag_"^"_pssingleflag_"^"_locdesc_"^"_type
 	
 	s index=""
 	f  s index=$o(^TMP("DHCST","DHCSTPIVASTATE",$j,index),-1) q:index=""  d
 	.s str=^TMP("DHCST","DHCSTPIVASTATE",$j,index)
 	.s psdr=$p(str,"^",1)
 	.s psnumber=$p(str,"^",2)
 	.s psname=$p(str,"^",3)
 	.s psflag=$p(str,"^",4)
 	.s pssysflag=$p(str,"^",5)
 	.s psretflag=$p(str,"^",6)
 	.s psdispflag=$p(str,"^",7)
 	.s pssingleflag=$p(str,"^",8)
 	.s locdesc=$p(str,"^",9)
 	.s type=$p(str,"^",10)
	.D OutputRow
	k ^TMP("DHCST","DHCSTPIVASTATE",$j)
 	Q $$$OK
OutputRow
	S Data=$lb(psdr,psnumber,psname,psflag,pssysflag,psretflag,psdispflag,pssingleflag,locdesc,type)
 	S ^CacheTemp(repid,ind)=Data	
 	S ind=ind+1
 	Q
}

Query GetState() As %Query(ROWSPEC = "TPSDr:%String,TPSNumber:%String,TPSName:%String,TPSFlag:%String,TPSSysFlag:%String,TPSRetFlag:%String,TPSDispFlag:%String,TPSSinFlag:%String,TPSLocDesc:%String,TPSType:%String")
{
}

/// 更新使用标志
ClassMethod UpdPsFlag(psdr As %String, psflag As %String, psretflag As %String, psdispflag, pssinflag) As %String
{
	N (psdr,psflag,psretflag,psdispflag,pssinflag)
	Q:psdr="" -99999
	Q:'$d(^PIVAS(psdr)) -99998
	&sql(Update PIVA_State set PS_Flag=:psflag,PS_RetFlag=:psretflag,PS_Dispflag=:psdispflag,PS_Singleflag=:pssinflag where PS_Rowid=:psdr) 
	Q SQLCODE
}

/// 插入新的流程
/// w ##class(web.DHCSTPIVASTATE).InsPs()
ClassMethod InsPs(psnumber As %String, psname As %String, psflag As %String, pssysflag As %String, psretflag As %String, psdispflag, pslocdr) As %String
{
	N (psnumber,psname,psflag,pssysflag,psretflag,psdispflag,pslocdr)
	Q:psnumber="" -99998
	Q:psname="" -99997
	Q:psflag="" -99996
	//S psdr=$o(^PIVAS(0,"NUMBER",psnumber,""))
	//Q:psdr'="" psdr
	&sql(Insert Into PIVA_State(PS_Number,PS_Name,PS_Flag,PS_SysFlag,PS_RetFlag,PS_DispFlag,PS_Loc_Dr) values(:psnumber,:psname,:psflag,:pssysflag,:psretflag,:psdispflag,:pslocdr)) 
	Q:SQLCODE<0 SQLCODE
	Q:SQLCODE=100 -99999
	Q $P(%ROWID,$C(1))
}

/// 检查流程号是否已经存在,return：0-不存在; 1-psnumber存在；2-psname存在
ClassMethod ExistPs(psnumber As %String, psname As %String, pslocdr) As %String
{
	N (psnumber,psname)
	Q:psnumber="" -99998
	s chkflag=0
	s psdr=""
	f  S psdr=$o(^PIVAS(0,"NUMBER",psnumber,psdr)) q:psdr=""  d
	.s tmplocdr=$p(^PIVAS(psdr),"^",7)
	.i pslocdr=pslocdr d
	..s chkflag=1
	//Q:psdr'="" 1
	//S psdr=$o(^PIVAS(0,"NAME",psname,""))
	//Q:psdr'="" 2
	Q chkflag
}

ClassMethod GetStateNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStateNumExecute ]
{
	S AtEnd=$LIST(qHandle,1)
 	S repid=$LIST(qHandle,2)
 	S ind=$LIST(qHandle,3)
 	S ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		S AtEnd=1
 		S Row=""
 	}
 	Else {				
 		S Row=^CacheTemp(repid,ind)
 	}
 	S qHandle=$lb(AtEnd,repid,ind)
	Q $$$OK
}

ClassMethod GetStateNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStateNumExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod GetStateNumExecute(ByRef qHandle As %Binary) As %Status
{
	n psdr
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	S psdr=""
	F  S psdr=$o(^PIVASN(psdr)) Q:(psdr="")||(psdr=0)  D
 	.S psnumber=$P(^PIVASN(psdr),"^",1)
 	.S psname=$P(^PIVASN(psdr),"^",2)
 	.S psflag=$P(^PIVASN(psdr),"^",3)
 	.Q:psflag'="Y"
	.D OutputNumRow
 	Q $$$OK
OutputNumRow
	S Data=$lb(psname,psdr,psnumber,psflag)
 	S ^CacheTemp(repid,ind)=Data	
 	S ind=ind+1
 	Q
}

Query GetStateNum() As %Query(ROWSPEC = "TPSName:%String,TPSDr:%String,TPSNumber:%String,TPSFlag:%String")
{
}

/// 插入新的流程
/// PS_SysFlag:目前仅打签为Y,不允许删此流程2017-01-17,yunhaibao
ClassMethod InsPsFlag(psdr, pslocdr, type) As %String
{
	N (psdr, pslocdr,type)
    s psnumber=$p(^PIVASN(psdr),"^",1)
    s psname=$p(^PIVASN(psdr),"^",2)
    s psflag="Y",retflag="N",pssysflag=""
	i psname="打签" s pssysflag="Y"
	e  i psname["不通过" s retflag="Y"
    s chkflag=0
    s psdr=""
    f  s psdr=$o(^PIVAS(0,"NUMBER",psnumber,psdr)) q:psdr=""  d
    .s tmppsnumber=$p(^PIVAS(psdr),"^",1)
    .s tmppslocdr=$p(^PIVAS(psdr),"^",7)
    .s tmptype=$p(^PIVAS(psdr),"^",9)  //类型
    .q:tmppslocdr'=pslocdr
    .q:tmppsnumber'=psnumber
    .q:tmptype'=type
    .s chkflag=1  //已存在
    .
    Q:chkflag=1 -99
	&sql(Insert Into PIVA_State(PS_Number,PS_Name,PS_Flag,PS_Loc_Dr,PS_RetFlag,PS_TypeFlag,PS_SysFlag) values(:psnumber,:psname,:psflag,:pslocdr,:retflag,:type,:pssysflag)) 
	Q:SQLCODE'=0 SQLCODE
	Q $P(%ROWID,$C(1))
}

/// Descript： 	删除流程
/// Creater：	zhouyg
/// CreateDate：	2015-01-07
/// Input：		PIVA_State的ID
/// Return：		0-成功，其他-错误
/// w ##class(web.DHCSTPIVASTATE).DelPs(17)
ClassMethod DelPs(psdr) As %String
{
	N (psdr)
	q:psdr="" -1
	q:$d(^PIVA(0,"PS",psdr)) -100	//已使用
	&sql(delete from PIVA_State where PS_RowID=:psdr) 
	q SQLCODE
}

}
