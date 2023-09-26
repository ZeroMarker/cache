Import sqluser

/// Creator:myq
/// Creatdate:2013-11-22
/// 维护点评药师权限
Class web.DHCSTCNTSALLOTUSER Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 获取药师集
ClassMethod GetPHAllot() As %String
{
	
	s pid=##class(web.DHCSTCNTSCOMMON).GetPHCNTSPID()
	s h=0
	s pclu=0
	f  s pclu=$o(^DHCPCALU(pclu)) q:pclu=""  d
	.s docdescdr=$p(^DHCPCALU(pclu),"^",1)
	.s docdesc=""
	.i docdescdr'=""  d
	..q:'$d(^SSU("SSUSR",docdescdr))
	..s docdesc=$p(^SSU("SSUSR",docdescdr),"^",2)
	.q:docdesc=""
	.i $f(docdesc,$c(13))  s docdesc=$p(advdesc,$c(13),1)
	.s h=h+1
    .s data=docdesc_"^"_pclu_"^"_docdescdr
    .s ^TMP("dhcpha","DHCSTCNTSALLOTUSER","GetPHAllot",pid,h)=data
    q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSALLOTUSER","GetPHAllot",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSALLOTUSER","GetPHAllot",pid,h)
    .s docdesc=$p(data,"^",1)
    .s docrowid=$p(data,"^",2)
    .s docdescdr=$p(data,"^",3)
    .
    .s docdesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("docdesc",docdesc)
    .s docdescdr=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("docdescdr",docdescdr)
	.s docrowid=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("docrowid",docrowid)
	.
	.s tmpstr=docdesc_docdescdr_docrowid
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	k ^TMP("dhcpha","DHCSTCNTSALLOTUSER","GetPHAllot",pid)
	q ""
}

/// 增加点评药师集
/// w ##class(web.DHCSTCNTSALLOTUSER).AddDoctor("83") 
ClassMethod AddPhama(doccode) As %String
{
	k PLIST
	
	q:'$d(^SSU("SSUSR",doccode)) -10
	s username=$p(^SSU("SSUSR",doccode),"^",2)
	q:username="" -10
	
	
	s flag=0
	
	s pclu=0
	f  s pclu=$o(^DHCPCALU(pclu)) q:(pclu="")||(flag=1)  d
	.s docdescdr=$p(^DHCPCALU(pclu),"^",1)
	.s:(docdescdr'="")&&(doccode=docdescdr) flag=1
	
	i (flag=1) q 100
	s PLIST(2)=doccode
	&sql(INSERT INTO DHC_PHCNTSALLOTUSER VALUES :PLIST())
 	i SQLCODE'=0 q -1
 	q 0
}

/// 删除点评药师集
ClassMethod DelPhama(docrowid) As %String
{
	
	&sql(delete from DHC_PHCNTSALLOTUSER where PCALU_RowID=:docrowid )
 	i SQLCODE'=0 q -1
 	q 0
}

/// Modified : MYQ 20160524 添加住院点评单的分配任务
/// 把点评单分配给药师
/// "陈雪华^^11^41^1406"
/// w ##class(web.DHCSTCNTSALLOTUSER).AllotUser("林昆山^^4","41","1406")
ClassMethod AllotUser(Data, Prenum, Rowid) As %String
{
	//s ^tmyq("AllotUser")=Data_","_Prenum_","_Rowid
	s n="" 
	s err=0
	s pcnts=Rowid
	s len=$l(Data,"*")
	f i=1:1:len d
	.s data=$p(Data,"*",i)
	.s pclu=$p(data,"^",2)
	.s allotednum=..GetAllotPrescNum(pcnts,pclu)
	.s userid=$p(^DHCPCALU(pclu),"^",1)
	.s allotcount=$p(data,"^",3)
	.i allotcount>0 d ;分配处方数为正数
	..s flag=0
	..s h=0
	..s chl=n
	..f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:(chl="")||(flag=1)  d
	...s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6)
	...q:curret'="" ;过滤掉已点评的
	...s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	...s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)   //add by myq 20150827
	...s pcaluserdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",7)
	...q:pcaluserdr'=""
	...s pcntstype=$p(^DHCPHCNTS(pcnts),"^",5) ;取点评单类型
	...i pcntstype="P" d   //add by myq 20150827
	....s ret=..AllotAdmUser(adm,userid,pcnts)  ;分配住院点评单	;还需要判断点评单id，因为可能重复抽取
	...e  d
	....s ret=..AllotPrescUser(prescno,userid,pcnts)  ;分配门诊点评单 ;还需要判断点评单id，因为可能重复抽取
	...s:ret'=0 err=-1
	...q:ret'=0
	...s ^DHCPHCNTS(0,"AllotUser",userid,pcnts,chl)="" ;生成 AllotUser 索引
	...s h=h+1
	...s n=chl
	...s:h=allotcount flag=1
	.e  d ;分配处方数为负数,即删除部分分配的任务
	..s flag=0
	..s h=0
	..s chl=""
	..f  s chl=$o(^DHCPHCNTS(0,"AllotUser",userid,pcnts,chl)) q:(chl="")||(flag=1)  d
	...s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	...s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)  //add by myq 20150827
	...s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6)
	...q:curret'="" ;过滤掉已点评的
	...s pcaluserdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",7)
	...q:pcaluserdr=""  ;该处方尚未分配
	...s pcntstype=$p(^DHCPHCNTS(pcnts),"^",5) ;取点评单类型
	...i pcntstype="P" d   //add by myq 20150827
	....s ret=..AllotAdmUser(adm,"",pcnts)  ;分配住院点评单
	...e  d
	....s ret=..AllotPrescUser(prescno,"",pcnts)  ;取消分配点评单
	...s:ret'=0 err=-1
	...q:ret'=0
	...s h=h+1
	...s:h=-allotcount flag=1
	
	q ""
}

/// 把点评单分配给药师
/// w ##class(web.DHCSTCNTSALLOTUSER).AllotPrescUser("O13052000045","608")
ClassMethod AllotPrescUser(Prescno, Useriddr, Pcnts) As %String
{
	s pcnts=Pcnts
	s prescno=Prescno
	s userid=Useriddr
	&sql(update  DHC_PHCOMMENTSITM set PCNTSI_AllotUser_Dr=:userid where PCNTSI_ParRef_Dr=:pcnts and PCNTSI_PrescNo=:prescno)
 	i SQLCODE'=0 q -1
 	q 0
}

/// 把住院点评单中的出院患者分配给药师
/// Modified : MYQ 20160704 添加判断主表id
/// w ##class(web.DHCSTCNTSALLOTUSER).AllotPrescUser("O13052000045","608")
ClassMethod AllotAdmUser(Adm, Useriddr, Pcnts) As %String
{
	
	s adm=Adm
	s pcnts=Pcnts
	s userid=Useriddr
	&sql(update  DHC_PHCOMMENTSITM set PCNTSI_AllotUser_Dr=:userid where PCNTSI_ParRef_Dr=:pcnts and PCNTSI_Adm_Dr=:adm)
 	i SQLCODE'=0 q -1
 	q 0
}

/// 分配点评任务时查询点评单
ClassMethod QueryComno(findflag, stdate, enddate, parstr = "") As %String
{
	//s ^tmyq("QueryComno")=findflag_"^"_stdate_"^"_enddate_"^"_parstr
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s:stdate'="" stdate=##class(websys.Conversions).DateHtmlToLogical(stdate)
	s:enddate'="" enddate=##class(websys.Conversions).DateHtmlToLogical(enddate)
	s pcntstype="F^P"
	i findflag="1" s pcntstype="F"
	i findflag="2" s pcntstype="P"
    s waydr=$p(parstr,"^",1)
    s h=0
	f date=stdate:1:enddate d
	.s typecnt=$l(pcntstype,"^")
	.f i=1:1:typecnt d
	..s type=$p(pcntstype,"^",i)
	..s pcnts=""
	..f  s pcnts=$o(^DHCPHCNTS(0,"Date",date,type,pcnts)) q:pcnts=""  d
	...s prenum=0
	...s pnum=0
	...s chl=""
	...f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	....s pnum=pnum+1
	....s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6)
	....q:curret'=""  ;过滤掉已点评的处方
	....s pcaluuserdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",7)
	....i pcaluuserdr="" d
	.....s prenum=prenum+1 //统计未分配的处方数量
	....e  d
	.....s prenum=prenum 
	...s pcntsno=$p(^DHCPHCNTS(pcnts),"^",1)
	...s pcntsdate=$p(^DHCPHCNTS(pcnts),"^",2)
	...i pcntsdate'="" s pcntsdate=##class(websys.Conversions).DateLogicalToHtml(pcntsdate)
	...s pcntstime=$p(^DHCPHCNTS(pcnts),"^",3)
	...i pcntstime'="" s pcntstime=##class(websys.Conversions).TimeLogicalToHtml(pcntstime)
	...s pcntstext=$p(^DHCPHCNTS(pcnts),"^",4)
	...s pcntsuserdr=$p(^DHCPHCNTS(pcnts),"^",6)
	...s pcntsuser=$p(^SSU("SSUSR",pcntsuserdr),"^",2)
	...i type="F" s typedesc="门诊"
	...i type="P" s typedesc="住院"
	...s tmpwaydr=$p(^DHCPHCNTS(pcnts),"^",7)
    ...q:(tmpwaydr'=waydr)&(waydr'="")
	...i tmpwaydr'="" d
	....q:'$d(^DHCPCWAY(tmpwaydr))
	....s waydesc=$p(^DHCPCWAY(tmpwaydr),"^",2)
	...s h=h+1
	...s data=pcntsno_"^"_pcntsdate_"^"_pcntstime_"^"_pcntstext_"^"_pcntsuser_"^"_typedesc_"^"_pcnts_"^"_waydesc_"^"_prenum_"^"_pnum
	...s ^TMP("dhcpha","DHCSTCNTSALLOTUSER","QueryComno",pid,h)=data
	..
	.
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSALLOTUSER","QueryComno",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSALLOTUSER","QueryComno",pid,h)
    .s pcntsno=$p(data,"^",1)
    .s pcntsdate=$p(data,"^",2)
    .s pcntstime=$p(data,"^",3)
    .s pcntstext=$p(data,"^",4)
    .s pcntsuser=$p(data,"^",5)
    .s typedesc=$p(data,"^",6)
    .s pcnts=$p(data,"^",7)
    .s waydesc=$p(data,"^",8)
    .s prenum=$p(data,"^",9)
    .s pnum=$p(data,"^",10)
    .
    .s pcntsno=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comno",pcntsno)
    .s pcntsdate=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comdate",pcntsdate)
    .s pcntstime=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comtime",pcntstime)
    .s pcntsuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comcreator",pcntsuser)
    .s typedesc=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comtype",typedesc)
    .s pnum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("pnum",pnum)
	.s pcntstext=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comtext",pcntstext)
	.s pcnts=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comrowid",pcnts)
	.s prenum=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("prenum",prenum)
	.s waydesc=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("comway",waydesc)
	.
	.s tmpstr=pcntsno_pcntsdate_pcntstime_pcntsuser_typedesc_pnum_pcntstext_pcnts_prenum_waydesc
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow

    k ^TMP("dhcpha","DHCSTCNTSALLOTUSER","QueryComno",pid)
    
	q ""
}

/// 查询点评的分配明细
/// d ##class(web.DHCSTCNTSALLOTUSER).QueryDetail("510")
ClassMethod QueryDetail(ComRowid) As %String
{
    //s ^tmyq("mm")= ComRowid
	s pid=##class(web.DHCSTCNTSMAIN).GetPHCNTSPID()
	s pcnts=ComRowid
	s chl=""
	f  s chl=$o(^DHCPHCNTS(pcnts,"I",chl)) q:chl=""  d
	.s pcaluserdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",7)
	.q:pcaluserdr=""
	.s pcaluserdr=+pcaluserdr
	.s comuser=$p(^SSU("SSUSR",pcaluserdr),"^",2)
	.s prescno=$p(^DHCPHCNTS(pcnts,"I",chl),"^",1)
	.s adm=$p(^DHCPHCNTS(pcnts,"I",chl),"^",3)
	.s pcntstype=$p(^DHCPHCNTS(pcnts),"^",5) ;取点评单类型
	.i pcntstype="P" d   //add by myq 20150827
	..s prescno=adm
	.s ^TMP("dhcpha","DHCSTCNTSALLOTUSER","QueryDetail","pid",pid,comuser,prescno)=prescno_"^"_comuser
	.
	s h=0
	s comuser=""
	f  s comuser=$o(^TMP("dhcpha","DHCSTCNTSALLOTUSER","QueryDetail","pid",pid,comuser)) q:comuser=""  d
	.s prescno=""
	.s comnum=0
	.s h=h+1
	.f  s prescno=$o(^TMP("dhcpha","DHCSTCNTSALLOTUSER","QueryDetail","pid",pid,comuser,prescno)) q:prescno=""  d
	..s comnum=comnum+1
	.s ^TMP("dhcpha","DHCSTCNTSALLOTUSER","QueryDetail",pid,h)=comuser_"^"_comnum
	.
	q:h=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s maxrow=h
    s count=0
    s h=""
    f  s h=$o(^TMP("dhcpha","DHCSTCNTSALLOTUSER","QueryDetail",pid,h)) q:h=""  d
    .s data=^TMP("dhcpha","DHCSTCNTSALLOTUSER","QueryDetail",pid,h)
    .s comuser=$p(data,"^",1)
    .s comnum=$p(data,"^",2)
    .
    .s comuser=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("comuser",comuser)
	.s comnum=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("comnum",comnum)
	.
	.s tmpstr=comuser_comnum
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.s count=count+1
	.i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow

    k ^TMP("dhcpha","DHCSTCNTSALLOTUSER","QueryDetail",pid)
    k ^TMP("dhcpha","DHCSTCNTSALLOTUSER","QueryDetail","pid",pid)
    
	q ""
}

/// 根据点评单主表ID和医师ID取已分配的处方数(不包含已点评过的)
/// w ##class(web.DHCSTCNTSALLOTUSER).GetAllotPrescNum("508","")  
ClassMethod GetAllotPrescNum(ComRowid, pha) As %String
{
	s counter=0
	q:(ComRowid="")||(pha="") counter
	s pcnts=ComRowid
	s userid=$p(^DHCPCALU(pha),"^",1)
	s chl=""
	f  s chl=$o(^DHCPHCNTS(0,"AllotUser",userid,pcnts,chl)) q:chl=""  d
	.s curret=$p(^DHCPHCNTS(pcnts,"I",chl),"^",6)
	.q:curret'=""   ;过滤掉已经点评过的处方
	.s pcaluserdr=$p(^DHCPHCNTS(pcnts,"I",chl),"^",7)
	.q:(pcaluserdr'=userid)  ;该处方尚未分配
	.s counter=counter+1
	q counter
}

}
