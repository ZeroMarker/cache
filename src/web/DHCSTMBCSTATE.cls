Import SQLUser

/// 煎药室状态（流程定制）维护 Table(DHCST_MBCState)
Class web.DHCSTMBCSTATE Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
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

ClassMethod GetStateExecute(ByRef qHandle As %Binary) As %Status
{
	n psdr
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	S number=0
	s mbctype=0
	F  S mbctype=$o(^DHCMBCS(0,"TYPENUMBER",mbctype)) Q:mbctype=""  D 
	.F  S number=$o(^DHCMBCS(0,"TYPENUMBER",mbctype,number)) Q:number=""  D 
	..S msdr=$o(^DHCMBCS(0,"TYPENUMBER",mbctype,number,""))
	..Q:msdr=""
	..Q:'$D(^DHCMBCS(msdr))
 	..S msnumber=$P(^DHCMBCS(msdr),"^",1)
 	..S msname=$P(^DHCMBCS(msdr),"^",2)
 	..S msflag=$P(^DHCMBCS(msdr),"^",3)
 	..S mstype=$P(^DHCMBCS(msdr),"^",4)
 	..//s ^lq(msdr)=mssingleflag
	..D OutputRow
 	Q $$$OK
OutputRow
	S Data=$lb(msdr,msnumber,msname,msflag,mstype)
 	S ^CacheTemp(repid,ind)=Data	
 	S ind=ind+1
 	Q
}

Query GetState() As %Query(ROWSPEC = "TMSDr:%String,TMSNumber:%String,TMSName:%String,TMSFlag:%String,TMSType:%String")
{
}

/// 插入新的流程
ClassMethod InsMs(msnumber As %String, msname As %String, msflag As %String, mstype As %String) As %String
{
	N (msnumber,msname,msflag,mstype)
	Q:msnumber="" -99998
	Q:msname="" -99997
	Q:msflag="" -99996
	S msdr=$o(^DHCMBCS(0,"TYPENUMBER",mstype,msnumber,""))
	Q:msdr'="" -99995
	&sql(Insert Into DHCST_MBCState(MBCS_Number,MBCS_Name,MBCS_Flag,MBCS_Type) values(:msnumber,:msname,:msflag,:mstype)) 
	Q:SQLCODE<0 SQLCODE
	Q:SQLCODE=100 -99999
	Q $P(%ROWID,$C(1))
}

/// 检查流程号是否已经存在,return：0-不存在; 1-msnumber存在；2-msname存在
ClassMethod ExistMs(msnumber As %String, msname As %String, mstype As %String) As %String
{
	N (msnumber,msname,mstype)
	Q:msnumber="" -99998
	S msdr=$o(^DHCMBCS(0,"TYPENUMBER",mstype,msnumber,""))
	Q:msdr'="" 1
	S msdr=$o(^DHCMBCS(0,"TYPENAME",mstype,msname,""))
	Q:msdr'="" 2
	Q 0
}

ClassMethod getinouttype()
{
	;1--住院，2--门诊
	s ret=""
	s ret="1"_$c(1)_"住院"_"^"_"2"_$c(1)_"门诊"
	
  q ret
}

/// 更新使用标志
ClassMethod UpdMsFlag(msdr As %String, msflag As %String) As %String
{
	N (msdr,msflag)
	Q:msdr="" -99999
	Q:'$d(^DHCMBCS(msdr)) -99998
	//s ^lq(psdr)=pssinflag
	&sql(Update DHCST_MBCState set MBCS_Flag=:msflag where MBCS_Rowid=:msdr) 
	Q SQLCODE
}

ClassMethod GetNotPrintItmsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNotPrintItmsExecute ]
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

ClassMethod GetNotPrintItmsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNotPrintItmsExecute ]
{
	S repid=$LIST(qHandle,2)
 	K ^CacheTemp(repid)
 	Q $$$OK
}

ClassMethod GetNotPrintItmsExecute(ByRef qHandle As %Binary) As %Status
{
	n psdr
	S repid=$I(^CacheTemp)
	S qHandle=$lb(0,repid,0)
	S ind=1
	s mbcdr=0,facttotal=0
	s userid=$g(%session.Data("LOGON.USERID"))
	s number=10
	F  S mbcdr=$o(^DHCMBC(0,"STATE",number,mbcdr)) Q:mbcdr=""  D 
	.s mbcsubdr=0
	.F  S mbcsubdr=$o(^DHCMBC(mbcdr,"I",mbcsubdr)) Q:mbcsubdr=""  D 
	..S musedr=$p(^DHCMBC(mbcdr,"I",mbcsubdr),"^",1)
	..Q:(userid'="")&&(userid'=musedr)
 	..S mbcprescno=$P(^DHCMBC(mbcdr),"^",1)
 	..S mbcadm=$P(^DHCMBC(mbcdr),"^",2)
 	..S mbcfactor=$P(^DHCMBC(mbcdr),"^",3)
 	..S mbctype=$P(^DHCMBC(mbcdr),"^",8)
 	..i mbctype="I" s mbctype="住院"
 	..i mbctype="O" s mbctype="门诊"
 	..s painfo=$$PaInfo(mbcadm)
	..q:painfo=""
	..s pano=$p(painfo,"^",1)   //登记号 
	..s pabed= $p(painfo,"^",7)  //床号 
	..s paname= $p(painfo,"^",2)  //姓名  
	..s dept =$p(painfo,"^",8)  //科室   
	..s ward =$p(painfo,"^",6) //病区
	..s wardid=$p(painfo,"^",9) //病区ID
	..S weight=$p(painfo,"^",10) //体重
	..s facttotal=mbcfactor+facttotal
	..D OutputRow1
 	d OutputRowTotal
 	Q $$$OK
OutputRow1
	S Data=$lb(mbcdr,pano,mbcprescno,paname,ward,pabed,mbctype,mbcfactor)
 	S ^CacheTemp(repid,ind)=Data	
 	S ind=ind+1
 	Q
OutputRowTotal
    S Data=$lb("","合计:","","","","","",facttotal)
 	S ^CacheTemp(repid,ind)=Data	
 	S ind=ind+1
 	Q
PaInfo(adm) 
 //取病人的相关信息
 n (adm)
 q:adm="" ""
 s papmidr=$p($g(^PAADM(adm)),"^",1) q:papmidr="" ""
 s pano=$p($g(^PAPER(papmidr,"PAT",1)),"^",1) ;登记号
 s name=$p($g(^PAPER(papmidr,"ALL")),"^",1)
 s sexdr=$p($g(^PAPER(papmidr,"ALL")),"^",7)
 s sex=""
 i sexdr'="" s sex=$p(^CT("SEX",sexdr),"^",1)
 s dob=$p($g(^PAPER(papmidr,"ALL")),"^",6)
 s age=+$h-dob   ;days of age
 s ward=$p($g(^PAADM(adm)),"^",70)
 s bed=$p($g(^PAADM(adm)),"^",73)
 s wardcode="",warddesc="",bedno=""
 i ward'="" s wardcode=$p(^PAWARD(ward),"^",1), warddesc=$p(^PAWARD(ward),"^",2)
 i bed'="" s bedno=$p($g(^PAWARD(+bed,"BED",$P(bed,"||",2))),"^",1)  
 ;
 s deptdr=$P(^PAADM(adm),"^",4)
 i deptdr'="" s dept=$p(^CTLOC(deptdr),"^",2)
 S weight=##class(web.DHCSTPIVA).GetPatWeight(adm)
 s result=pano_"^"_name_"^"_sex_"^"_age_"^"_wardcode_"^"_warddesc_"^"_bedno_"^"_dept_"^"_ward_"^"_weight
 q result
}

Query GetNotPrintItms() As %Query(ROWSPEC = "TMBCDr:%String,TMBCPaNo:%String,TMBCPresNo:%String,TMBCPaName:%String,TMBCWard:%String,TMBCPaBed:%String,TMBCType:%String,TMBCFactor:%String")
{
}

/// Description:煎药室收药执行
/// Creator:   WYX
/// CreatDate:2013-05-23  
/// Input:条码,用户ID
/// Output:number
ClassMethod SaveCheckOK(mbarcode As %String, museid As %String)
{
  n (mbarcode,museid)
}

/// Description:煎药室收药执行前检查
/// Creator:   WYX
/// CreatDate:2013-05-23  
/// Input:条码,用户ID
/// Output:number
ClassMethod CheckBeforSave(mbarcode As %String, museid As %String)
{
  n (mbarcode,museid)
  s number=10
  s msrowid=$o(^DHCMBCS) //根据病人信息找到住院还是门诊判断收药流出那个是否使用中。。。。
}

}
