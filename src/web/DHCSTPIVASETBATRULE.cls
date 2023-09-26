Import SQLUser

/// 设定批次规则
Class web.DHCSTPIVASETBATRULE Extends (%RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Description:获取当前病人就诊列表
/// Input:登记号
/// Output:就诊列表
/// Creator:LiangQiang
/// CreatDate:2015-12-16
ClassMethod GetAllFreqList(rows, page) As %Integer
{
     i $g(page)="" s page=1
     i $g(rows)="" s rows=900
     
	 s End = page*rows
	 s Start=(page-1)*rows+1
	
	 S pid=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
	 s n=0
	 s phcfr="" 
	 f  s phcfr=$o(^PHCFR(phcfr)) q:phcfr=""  d
	 .s freqdesc=$p(^PHCFR(phcfr),"^",1) 
	 .s rowid=phcfr
	 .s n=n+1
	 .s data=$g(phcfr)_"^"_$g(freqdesc)
	 .s ^TMP("DHCST","DHCSTPIVASETBATRULE","GetAllFreqList",pid,n)=data
     w ##class(web.DHCSTJQUERYCOMMON).getJsonStartSign(n) //输出json前缀串
     q:n=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(n) //输出空的json串
     s maxrow=n
     s count=0
     s h=""
     f  s h=$o(^TMP("DHCST","DHCSTPIVASETBATRULE","GetAllFreqList",pid,h)) q:h=""  d
     .s mdata=^TMP("DHCST","DHCSTPIVASETBATRULE","GetAllFreqList",pid,h)
     .s count = count+1
	 .s Title="id^desc"
	 .q:(count<Start)||(count>End)
	 .I count=Start d
	 ..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	 .e  d
	 ..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	
	 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign() //输出json结尾符
	 k ^TMP("DHCST","DHCSTPIVASETBATRULE","GetAllFreqList",pid)
     q ""
}

/// Description:增加
/// Input:
/// Output:
/// Creator:LiangQiang
/// CreatDate:2015-12-16
ClassMethod AddFreqList(Input) As %Integer
{
	  n (Input)
	  s ret=0
	  s freqDr=$p(Input,"^",1)
	  s phalocDr=$p(Input,"^",2)
	  s freqr=0
	  f  s freqr=$o(^PIVAFREQR(freqr)) q:(freqr="")||(freqr=0)  d
	  .s tmpfreqdr=$p(^PIVAFREQR(freqr),"^",1)
	  .s ctlocdr=$p(^PIVAFREQR(freqr),"^",3)
	  .i (tmpfreqdr=freqDr)&(phalocDr=ctlocdr) d
	  ..s ret=1
	  q:ret=1 -99
	  
	  s ordnum=+$o(^PIVAFREQR(0,"OrdNum",phalocDr,""),-1)+1
	  k PLIST
	  s PLIST(2)=freqDr
	  s PLIST(3)=ordnum
	  s PLIST(4)=phalocDr
	  &sql(insert into PIVA_FreqRule values PLIST())   ;总表插入
	  i SQLCODE'=0 s ret=-1 
	  q +$g(%ROWID)
}

/// Description:删除
/// Input:rowid
/// Output:
/// Creator:LiangQiang
/// CreatDate:2015-12-16
ClassMethod DelFreqList(Input) As %Integer
{
	n (Input)
	s rowid=$p(Input,"^",1)
	&sql(delete from PIVA_FreqRule where PIVA_RowID=:rowid )
	q SQLCODE
}

/// Description:获取频次规则列表
/// Input:行号
/// Output:频次规则列表
/// Creator:LiangQiang
/// CreatDate:2015-12-16
ClassMethod GetFreqRuleList(rows, page, params) As %Integer
{
	 n (rows, page,params)
     i $g(page)="" s page=1
     i $g(rows)="" s rows=900
     
	 s End = page*rows
	 s Start=(page-1)*rows+1
	 s phalocdr=$p(params,"^",1)
	 S pid=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
	 s n=0
	 s ordnum="" 
	 f  s ordnum=$o(^PIVAFREQR(0,"OrdNum",phalocdr,ordnum)) q:ordnum=""  d
	 .s freqdr=""
	 .f  s freqdr=$o(^PIVAFREQR(0,"OrdNum",phalocdr,ordnum,freqdr)) q:freqdr=""  d
	 ..s rowid=$o(^PIVAFREQR(0,"OrdNum",phalocdr,ordnum,freqdr,""))
	 ..s freqdesc=$p(^PHCFR(freqdr),"^",1) 
	 ..s n=n+1
	 ..s data=$g(rowid)_"^"_$g(freqdesc)
	 ..s ^TMP("DHCST","DHCSTPIVASETBATRULE","GetFreqRuleList",pid,n)=data
     q:n=0 ##class(web.DHCSTJQUERYCOMMON).getJsonEmptySign(n) //输出空的json串
     w ##class(web.DHCSTJQUERYCOMMON).getJsonStartSign(n) //输出json前缀串

     s maxrow=n
     s count=0
     s h=""
     f  s h=$o(^TMP("DHCST","DHCSTPIVASETBATRULE","GetFreqRuleList",pid,h)) q:h=""  d
     .s mdata=^TMP("DHCST","DHCSTPIVASETBATRULE","GetFreqRuleList",pid,h)
     .s count = count+1
	 .s Title="rowid^FreqDesc"
	 .q:(count<Start)||(count>End)
	 .I count=Start d
	 ..w ##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	 .e  d
	 ..w ","_##class(web.DHCSTJQUERYCOMMON).getJsonData(Title,mdata)
	
	 w ##class(web.DHCSTJQUERYCOMMON).getJsonEndSign() //输出json结尾符
	 k ^TMP("DHCST","DHCSTPIVASETBATRULE","GetFreqRuleList",pid)
     q ""
}

/// Description:上移或下移
/// Input:上移和下移id
/// Output:0成功
/// Creator:LiangQiang
/// CreatDate:2015-12-16
ClassMethod SaveUp(input) As %Integer
{
    n (input)
	s currowid=$p(input,"^",1)
	s lastrowid=$p(input,"^",2)
    s curordernum=$p(^PIVAFREQR(+lastrowid),"^",2)
	s lastordernum=$p(^PIVAFREQR(+currowid),"^",2)

	tstart
	&sql(update PIVA_FreqRule  set PIVA_OrderNum=:curordernum where PIVA_RowID=:currowid)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 -1
	&sql(update PIVA_FreqRule  set PIVA_OrderNum=:lastordernum where PIVA_RowID=:lastrowid)
	i SQLCODE'=0 tro
	q:SQLCODE'=0 -2
	tcommit
	
	q 0
}

/// Descritp:科室信息
ClassMethod GetPhaLocByGrp(grpdr) As %String
{
	N (grpdr)
	s h=0
	S PID=##class(web.DHCSTPIVAPRINTLABEL).NewPid()
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
	.s ^TMP("DHCST","DHCSTPIVABATUPDATE","GetPhaLocByGrp",PID,"Data",h)=data
	
	s count=0
	w "["
	s h=""
	f  s h=$o(^TMP("DHCST","DHCSTPIVABATUPDATE","GetPhaLocByGrp",PID,"Data",h)) q:h=""  d
	.s data=^TMP("DHCST","DHCSTPIVABATUPDATE","GetPhaLocByGrp",PID,"Data",h)
	.s LocDr = $p(data,"^",2)
	.s LocDesc = $p(data,"^",1)
	.s tmp=LocDr_"^"_LocDesc
	.s count = count+1
	.I count=1 d
	..W ##class(web.DHCSTJQUERYCOMMON).getJsonData("rowId^Desc",tmp)
	.e  d
	..W ","_##class(web.DHCSTJQUERYCOMMON).getJsonData("rowId^Desc",tmp)
	
	w "]"
	k ^TMP("DHCST","DHCSTPIVABATUPDATE","GetPhaLocByGrp",PID,"Data")
	q ""
}

/// Description:保存其它规则
/// Input:
/// Output:是否成功
/// Creator:LiangQiang
/// CreatDate:2015-12-28
ClassMethod SaveOthRule(Input) As %Integer
{
	n (Input)
	k PLIST
	s phalocdr=$p(Input,"^",1)
    s bigflag=$p(Input,"^",2)
    s conflag=$p(Input,"^",3)
    
    s pothdr=$o(^PIVAOTHR(0,"Loc",phalocdr,""),-1)
    i pothdr'="" s ret=..UpdOthRule(Input)
    q:pothdr'="" $g(ret)
    s PLIST(2)=bigflag
    s PLIST(3)=conflag
    s PLIST(4)=phalocdr
    &sql(insert into PIVA_OtherRule values PLIST())   ;总表插入
    i SQLCODE'=0 s ret=-1 
    q +$g(%ROWID)
}

/// Description:更新其它规则
/// Input:信息
/// Output:
/// Creator:LiangQiang
/// CreatDate:2015-12-28
ClassMethod UpdOthRule(Input) As %Integer
{
	n (Input)
	s phalocdr=$p(Input,"^",1)
    s bigflag=$p(Input,"^",2)
    s conflag=$p(Input,"^",3)
    s rowid=$o(^PIVAOTHR(0,"Loc",phalocdr,""),-1)
    &sql(update PIVA_OtherRule set PIVA_CubageFlag=:bigflag,PIVA_ContinueFlag=:conflag where PIVA_RowID=:rowid )
	q SQLCODE
}

/// Description:返回其它规则
/// Input:
/// Output:信息
/// Creator:LiangQiang
/// CreatDate:2015-12-28
ClassMethod GetOthRuleInfo(Input) As %Integer
{
	n (Input)
	s phalocdr=$p(Input,"^",1)
	s ListTitle="bigflag^conflag"
	s pothdr=$o(^PIVAOTHR(0,"Loc",phalocdr,""),-1)
	q:pothdr="" ""
	s bigflag=$p(^PIVAOTHR(pothdr),"^",1)
	s conflag=$p(^PIVAOTHR(pothdr),"^",2)
	s ListData=bigflag_"^"_conflag
	w ##class(web.DHCSTJQUERYCOMMON).getJsonData(ListTitle,ListData,"^")
	q ""
}

}
