Import sqluser

Class web.DHCST.DrugInfoAudit Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// description:获取需要审核的药品信息记录
/// others:		原始版本自邯钢医院,zhaozhiduan做
/// lastupdate:	20151215,yunhaibao
/// w ##class(web.DHCST.DrugInfoAudit).GetPhcChangedInfoNew("0","999","2016-01-17","2017-01-17","","","G^590^N^")
ClassMethod GetPhcChangedInfoNew(Start As %Integer, Limit As %Integer, StDate As %String, EndDate As %String, Grp As %String, inci As %String, Other As %String, Sort = "", Dir = "") As %String
{
	s Pid=..NewPid()
	s $zt="ErrorGetPhcChangedInfoNew"
	q:StDate="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	q:EndDate="" ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s maxlev=$o(^DHCSTAL(0,"Level","Basic","G",""),-1)  //未维护审核级别
	q:+maxlev=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate)
	s EndDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EndDate)
	s stkgrptype=$p(Other,"^",1)
	s userid=$p(Other,"^",2)
	s auditflag=$p(Other,"^",3)
	s likeincidesc=$p(Other,"^",4)
	s Type="Basic"
	s level=..GetAuditLevel(Type,stkgrptype,userid)  
	q:level<1 ##class(web.DHCSTEXTCOMMON).GetNoJson()  //维护的级别最低为1
	if ((level>1)||(auditflag="Y"))
	{
		s StrSql ="select WORKAUDIT_Point as rowid from DHC_WORKAUDIT where WORKAUDIT_Type='Basic' and WORKAUDIT_Rowid>0" 
		i auditflag'="Y" d 
		.s StrSql=StrSql_" and WORKAUDIT_Level="_(level-1)_" and WORKAUDIT_Flag='Y' and WORKAUDIT_Date  between "_StDate_" and "_EndDate 
		e   d
		.s StrSql=StrSql_" and WORKAUDIT_Level="_level_" and WORKAUDIT_Date  between "_StDate_" and "_EndDate
	}
	else {      
	    s StrSql = "select DL_Rowid rowid from DHC_Log where dl_date between "_StDate_" and "_EndDate_" and DL_rowid>0"
	}
	s result = ##class(%Library.ResultSet).%New()
    d result.Prepare(StrSql)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    If err  q ##class(web.DHCSTEXTCOMMON).GetNoJson()
    s CountRecord = 0
    s resultString = ""
	s Title1="tmpinci^phcd^ChangeType^Code^Desc^Poison^Instr^Form^Offcode^Freq^Ctuom^Generic"
	s Title2="ManfDesc^SubCat^MinorSubCat^Date^Time^Name^BillCtuom^EFfDate^EFfDateTo^ItemCat"
	s Title3="Own^Priority^BillSubCat^OeMsg^Buom^Puruom"
	s Title4="StkCatDesc^Spec^Rowid^AuditFlag^NoUseFlag^AuditUser^AuditDate^AuditTime"
	s Title=Title1_"^"_Title2_"^"_Title3_"^"_Title4
    While(result.Next())
    {
	     s rowid=result.Data("rowid")
	     i (level>1)||(auditflag="Y") s rowid=$p(rowid,"||",2)  //dhclog的id
	     s perref=rowid
	     s lastsub=$o(^DHCLOG(perref,"PHCD",""),-1)
	     continue:lastsub=""
	     s lastphcd=$p(^DHCLOG(perref,"PHCD",lastsub),"^",1)
	     s lastphcddesc=$p($g(^PHCD(+lastphcd,1)),"^",2)
	     continue:(likeincidesc'="")&&(lastphcddesc'[likeincidesc)
	     s sub="" 
	     f  s sub=$o(^DHCLOG(perref,"PHCD",sub)) q:sub=""  d
	     .s phcd =$p(^DHCLOG(perref,"PHCD",sub),"^",1)
	     .s phcsub=$o(^PHCD(phcd,"DF",""),-1)
	     .s phc=phcd_"||"_phcsub     
	     .s arcrowid=$o(^ARCIM(0,"PHCDF",phc,""))
	     .q:arcrowid=""
	     .s tmpinci=$o(^INCI(0,"ARCIM_DR",+arcrowid,""))
	     .s str=tmpinci_"||"_perref
         .q:tmpinci=""
         .q:(tmpinci'=inci)&(inci'="")
     	 .s nouseflag=$p($g(^INCI(tmpinci,2)),"^",9)
     	 .s lastaudit=$o(^DHCWORKAUDIT(0,"TypePointer","Basic",str,""),-1)
     	 .s lastupdate=""
     	 .s lastuptime=""
     	 .s lastupdateuser=""
     	 .s auditlevel=""
     	 .i lastaudit'="" d
     	 ..s lastupdate=$p(^DHCWORKAUDIT(lastaudit),"^",1)
     	 ..i lastupdate'="" s lastupdate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(lastupdate)
     	 ..s lastuptime=$p(^DHCWORKAUDIT(lastaudit),"^",2)
     	 ..i lastuptime'="" s lastuptime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(lastuptime,"ST")
     	 ..s lastupdateuser=$p(^DHCWORKAUDIT(lastaudit),"^",5)
     	 ..i lastupdateuser'="" s lastupdateuser=$p($g(^SSU("SSUSR",lastupdateuser)),"^",2)
     	 ..s auditlevel=$p(^DHCWORKAUDIT(lastaudit),"^",6)  //最后的一次审核的级别
     	 ..s audit=$p(^DHCWORKAUDIT(lastaudit),"^",7)  //最后一次的审核状态
     	 ..i (audit="Y") s levflag="审核通过"
     	 ..i (audit="N") s levflag="审核不通过"
     	 .i auditflag'="Y" s levflag="未审核"
     	 .//i auditflag="N" q:nouseflag'="Y"  //不可用标志
     	 .q:(lastaudit="")&(auditflag'="N")
     	 .q:(auditlevel'<level)&(auditflag="N")
         .s stkgrpinfo=##class(web.DHCST.Common.DrugInfoCommon).GetIncStkCatGrp(tmpinci)
 		 .s grptype=$p(stkgrpinfo,"^",3)
 		 .q:(grptype'=..sssCode())
 		 .s grpid=$p(stkgrpinfo,"^",5)
		 .q:(Grp'="")&&(grpid'=Grp)
       	 .s Type = $p(^DHCLOG(perref,"PHCD",sub),"^",2)
         .s ChangeType =""
         .s:Type=0 ChangeType = "修改前"
         .s:Type=1 ChangeType = "修改后"
         .s:Type=2 ChangeType = "新增加"
         .s Code = $p(^DHCLOG(perref,"PHCD",sub),"^",3)
         .s Desc = $p(^DHCLOG(perref,"PHCD",sub),"^",4)
         .s Poison=$p(^DHCLOG(perref,"PHCD",sub),"^",11)
         .s:Poison'="" Poison=$p($g(^PHCPO(Poison)),"^",2)
         .s Instr=$p(^DHCLOG(perref,"PHCD",sub),"^",14)
         .s:Instr'="" Instr=$p($g(^PHCIN(Instr)),"^",2)
         .s Form=$p(^DHCLOG(perref,"PHCD",sub),"^",13)
         .S:Form'="" Form=$P($g(^PHCF(Form)),"^",2)
         .s Offcode=$p(^DHCLOG(perref,"PHCD",sub),"^",8)  //存为指针,yunhaibao20160129
         .i (Offcode'="")&&($d(^DHCITMIC(Offcode))) s Offcode=$p($g(^DHCITMIC(Offcode)),"^",2)
         .s Freq=$p(^DHCLOG(perref,"PHCD",sub),"^",12)
         .s:Freq'="" Freq=$p($g(^PHCFR(Freq)),"^",3)
         .s CtuomDr=$p(^DHCLOG(perref,"PHCD",sub),"^",10)
         .s Ctuom=$p($g(^CT("UOM",CtuomDr)),"^",2)
         .s Generic=$p(^DHCLOG(perref,"PHCD",sub),"^",7)
         .s:Generic'="" Generic=$p($g(^PHCGE("GE",Generic)),"^",2)
         .s ManfDesc=$p(^DHCLOG(perref,"PHCD",sub),"^",9)
         .s:ManfDesc'="" ManfDesc=$P($g(^PHMNF(ManfDesc)),"^",2)
         .s SubCat=$p(^DHCLOG(perref,"PHCD",sub),"^",5)
         .i (SubCat'="")&&($p(SubCat,"||",2)'="") s SubCat=$p($g(^PHCC($p(SubCat,"||",1),"SC",$p(SubCat,"||",2))),"^",2)
         .s MinorSubCat =$p(^DHCLOG(perref,"PHCD",sub),"^",6)
         .i (MinorSubCat'="")&&($p(MinorSubCat,"||",3)'="") s MinorSubCat=$p($g(^PHCC($p(MinorSubCat,"||",1),"SC",$p(MinorSubCat,"||",2),"MIN",$p(MinorSubCat,"||",3))),"^",2)
         .s PlphDate=$p(^DHCLOG(perref),"^",1)
         .s PlphTime=$p(^DHCLOG(perref),"^",2)  //dhclog修改日志的日期与时间,lastupdate为dhcworkaudit日志的最后插入时间
         .//q:(lastupdate=PlphDate)&(+lastuptime>PlphTime)&(lastupdate'="")&(auditflag'="Y") //yunhaibao20151216,这两句什么意思不知道
         .//q:((lastupdate<StDate)||(lastupdate>EndDate))&(lastupdate'="")&(auditflag'="Y")
         .i PlphDate'="" s PlphDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(PlphDate)
         .i PlphTime'="" s PlphTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(PlphTime,"ST")
         .s PlphName=$p(^DHCLOG(perref),"^",3)
         .s:PlphName'="" PlphName=$p($g(^SSU("SSUSR",PlphName)),"^",2)
         .i $d(^DHCLOG(perref,"ARCIM",sub)) d
         ..s BillCtuomdr=$p(^DHCLOG(perref,"ARCIM",sub),"^",9)
         ..s BillCtuom=""
         ..s:BillCtuomdr'="" BillCtuom=$p(^CT("UOM",BillCtuomdr),"^",2)
         ..s EFfDate=$p(^DHCLOG(perref,"ARCIM",sub),"^",5)
         ..i EFfDate'="" s EFfDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(EFfDate)
         ..s EFfDateTo=$p(^DHCLOG(perref,"ARCIM",sub),"^",6)
         ..i EFfDateTo'="" s EFfDateTo=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(EFfDateTo)
         ..s ItemCatdr=$p(^DHCLOG(perref,"ARCIM",sub),"^",7)
         ..s ItemCat=$p(^ARC("IC",+ItemCatdr),"^",2)
         ..s Own=$p(^DHCLOG(perref,"ARCIM",sub),"^",11)
         ..s Priority=$p(^DHCLOG(perref,"ARCIM",sub),"^",10)
         ..s:Priority'="" Priority=$p($g(^OECPR(Priority)),"^",2)
         ..s BillSubCatId=$p(^DHCLOG(perref,"ARCIM",sub),"^",8)
         ..s BillSubCat=""
         ..s:BillSubCatId'="" BillSubCat=$p(^ARCBG(+BillSubCatId,"SG",$p(BillSubCatId,"||",2)),"^",2)
         ..s OeMsg=$p(^DHCLOG(perref,"ARCIM",sub),"^",12)
         .e  d
         ..s arcitm=$o(^ARCIM(arcrowid,""))
         ..
         ..s BillCtuomdr=$p(^ARCIM(arcrowid,arcitm,8),"^",14)
         ..s BillCtuom=$p(^CT("UOM",BillCtuomdr),"^",2)
         ..s EFfDate=+$p(^ARCIM(arcrowid,arcitm,1),"^",13)
         ..i EFfDate'="" s EFfDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(EFfDate)
         ..s EFfDateTo=+$p(^ARCIM(arcrowid,arcitm,7),"^",1)
         ..i EFfDateTo'="" s EFfDateTo=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(EFfDateTo)
         ..s ItemCatdr=$p(^ARCIM(arcrowid,arcitm,1),"^",10)
         ..s ItemCat=$p(^ARC("IC",+ItemCatdr),"^",2)
         ..s Own=$p(^ARCIM(arcrowid,arcitm,7),"^",13)
         ..s Priority=$p(^ARCIM(arcrowid,arcitm,8),"^",22)
         ..s:Priority'="" Priority=$p($g(^OECPR(Priority)),"^",2)
         ..s BillSubCatId=$p(^ARCIM(arcrowid,arcitm,1),"^",9)
         ..s BillSubCat=""
         ..s:BillSubCatId'="" BillSubCatId=$p(^ARCBG(+BillSubCatId,"SG",$p(BillSubCatId,"||",2)),"^",2)
         ..s OeMsg=$p($g(^ARCIM(arcrowid,arcitm,"OEM")),"^",1)
		 ..
		 .i $d(^DHCLOG(perref,"INCI",sub)) d
		 ..s Buomdr=$p(^DHCLOG(perref,"INCI",sub),"^",5)
         ..s Buom=$p($g(^CT("UOM",Buomdr)),"^",2)
		 ..s Puruomdr=$p(^DHCLOG(perref,"INCI",sub),"^",6)
         ..s Puruom=$p($g(^CT("UOM",Puruomdr)),"^",2)
		 ..s StkCatdr=$p(^DHCLOG(perref,"INCI",sub),"^",7)
		 ..s StkCatDesc=$p(^INC("SC",StkCatdr),"^",2)
		 ..s spec=$p(^DHCLOG(perref,"INCI",sub),"^",9)
		 ..s nouseflag=$p(^DHCLOG(perref,"INCI",sub),"^",10)
		 .e  d
		 ..s Buomdr=$p(^INCI(tmpinci,1),"^",10)
         ..s Buom=$p($g(^CT("UOM",Buomdr)),"^",2)
		 ..s Puruomdr=$p(^INCI(tmpinci,3),"^",6)
         ..s Puruom=$p($g(^CT("UOM",Puruomdr)),"^",2)
		 ..s StkCatdr=$p(^INCI(tmpinci,2),"^",2)
		 ..s StkCatDesc=$p(^INC("SC",StkCatdr),"^",2) 
		 ..s info=$o(^DHCITMINFO(0,"INCI",tmpinci,""),-1)
	 	 ..i info="" s spec=""
	 	 ..e  s spec=$p(^DHCITMINFO(info),"^",27)
	 	 ..s nouseflag=""     
         .s Data1=tmpinci_"^"_phcd_"^"_ChangeType_"^"_Code_"^"_Desc_"^"_Poison_"^"_Instr
         .s Data2=Form_"^"_Offcode_"^"_Freq_"^"_Ctuom_"^"_Generic 
         .s Data3=ManfDesc_"^"_SubCat_"^"_MinorSubCat_"^"_PlphDate_"^"_PlphTime
         .s Data4=PlphName_"^"_BillCtuom_"^"_EFfDate_"^"_EFfDateTo_"^"_ItemCat
         .s Data5=Own_"^"_Priority_"^"_BillSubCat_"^"_OeMsg_"^"_Buom 
         .s Data6=Puruom_"^"_StkCatDesc_"^"_spec_"^"_perref_"^"_levflag
         .s Data7=nouseflag_"^"_lastupdateuser_"^"_lastupdate_"^"_lastuptime
         .s Data=Data1_"^"_Data2_"^"_Data3_"^"_Data4_"^"_Data5_"^"_Data6_"^"_Data7
         .s CountRecord=CountRecord+1
         .s index=1
         .s ^TMP("DHCST","DrugInfoAudit","GetPhcChangedInfoNew",Pid,index,CountRecord)=Data 
     } 
    q:CountRecord=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s Dir=$$ALPHAUP^SSUTIL4(Dir)
    s:(Dir="")&(Dir'="ASC")&(Dir'="DESC") Dir="DESC"
    i Dir="DESC" s orderflag="-1"
    e  s orderflag="1"
    s End = Start+Limit
    s Start=Start+1
    i End>CountRecord s End=CountRecord
    s count=0
    s outputi=""
    f  s outputi=$o(^TMP("DHCST","DrugInfoAudit","GetPhcChangedInfoNew",Pid,outputi),orderflag) q:outputi=""  d
    .s outputj=""
    .f  s outputj=$o(^TMP("DHCST","DrugInfoAudit","GetPhcChangedInfoNew",Pid,outputi,outputj),orderflag) q:outputj=""  d
	..s count=count+1
	..q:count<Start
	..q:count>End
	..s outputdata=^TMP("DHCST","DrugInfoAudit","GetPhcChangedInfoNew",Pid,outputi,outputj)
	..i count=Start d
	...w ##class(web.DHCSTEXTCOMMON).GetJsonStartString(CountRecord)
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	...w retstring
	..e  d
	...s retstring=##class(web.DHCST.Common.UtilCommon).GetJsonStr(outputdata,Title)
	...w ","_retstring
 	w "]}"
    k ^TMP("DHCST","DrugInfoAudit","GetPhcChangedInfoNew",Pid)
    q ""
ErrorGetPhcChangedInfoNew
	k ^TMP("DHCST","DrugInfoAudit","GetPhcChangedInfoNew",Pid)
	s Error=$$Error^DHCSTERROR()
    Set Method=	"##class(web.DHCST.DrugInfoAudit).GetPhcChangedInfoNew"
	Set ErrorMsg=Method_"("""_Start_""","""_Limit_""","""_StDate_""","""_EndDate_""","""_Grp_""","""_inci_""","""_Other_""","""_Sort_""","""_Dir_""")"_"</br>"_Error
	w "{Error:'"_ErrorMsg_"'}"
	q ""
}

/// Creator		zhaozhiduan
/// CreatDate	2015-04-09
/// Description	
/// Input		
/// Output
/// w ##class(web.DHCST.DrugInfoAudit).DrugAudit("900^5031@900^5031",590,"N")
ClassMethod DrugAudit(InciStr, User, Flag)
{
	//判断是否维护业务审核权限
	q:User="" -1000
	q:'$d(^DHCSTAL(0,"Level","Basic","G")) -1001
	q:'$d(^DHCSTAL(0,"User","Basic","G",User)) -1002
	s auditlevelid=$o(^DHCSTAL(0,"User","Basic","G",User,""),-1)
	s auditactive=$p(^DHCSTAL(auditlevelid),"^",5)
	q:auditactive'="Y" -1005
	s SQLCODE=0
	s len=$l(InciStr,"@")
	s ret=0
	tstart
 	s $ZT="Error^DHCSTERROR"
	f i=1:1:len  q:ret'=0  d
	.s str=$p(InciStr,"@",i)
	.s inci=$p(str,"^",1)
	.s dhcl=$p(str,"^",2)
	.s nouseflag=$p($g(^INCI(inci,2)),"^",9)
	.s tmpnouse="N"
	.i $d(^DHCLOG(dhcl,"INCI")) d
	..s sub=$o(^DHCLOG(dhcl,"INCI",""),-1)
	..s tmpnouse=$p(^DHCLOG(dhcl,"INCI",sub),"^",10)
	.s arc=$p($g(^INCI(inci,1)),"^",3)
	.s dateto=$p(^ARCIM(+arc,$p(arc,"||",2),7),"^",1)
	.s date=+$h
	.s time=$p($h,",",2)
	.s type="Basic"
	.s point=inci_"||"_dhcl
	.s userdr=User
	.s level=..GetAuditLevel("Basic","G",User) 
	.s auditlev=0
	.s auditid=$o(^DHCWORKAUDIT(0,"TypePointer","Basic",str,""),-1) //审核记录中最新的审核级别状态
	.i auditid'="" s auditlev=+$p($g(^DHCWORKAUDIT(auditid)),"^",6)      
	.q:auditlev'<level									//判断该修改记录是否已经插入过
	.s maxlev=$o(^DHCSTAL(0,"Level","Basic","G",""),-1)
	.q:level<1  //当此次为最后一条审核记录时,且为最大级别,更新可用状态
	.i ((maxlev=level)&(Flag="Y"))||(Flag="N") d
	..&SQL(UPDATE DHC_Log_INCI SET DLIN_AuditFlag='Y' WHERE DLIN_DL_Parref=:dhcl)
	..i SQLCODE'=0 tro  s ret=-1003
	.q:ret<0
	.s:(maxlev=level)&(Flag="Y")&&('$d(^DHCLOG(0,"INCIAUDIT",inci,"N"))) $p(^INCI(inci,2),"^",9)=tmpnouse  //最大权限时置可用状态
	.s incidesc=$p(^INCI(inci,1),"^",2)
	./*判断是否需要插入记录,以免重复插入,审核级别+point+type确定唯一记录,yunhaibao20151216*/
	.s tmpauditid="",distinct=""
	.f  s tmpauditid=$o(^DHCWORKAUDIT(0,"TypePointer","Basic",point,tmpauditid)) q:tmpauditid=""  d
	..s tmplevel=$p($g(^DHCWORKAUDIT(tmpauditid)),"^",6)
	..i tmplevel=level s distinct="1"
	.q:distinct'=""
	.&sql(INSERT INTO DHC_WORKAUDIT(WORKAUDIT_Date,WORKAUDIT_Time,WORKAUDIT_Type,WORKAUDIT_Point, 
    WORKAUDIT_User,WORKAUDIT_Level,WORKAUDIT_Flag)
    VALUES(:date, :time, :type, :point,:userdr,:level,:Flag)) 
    .;i SQLCODE'=0 d
    .;.s ret=$$ErrorRecord^DHCSTERROR("InsertDHC_WORKAUDIT",incidesc,SQLCODE_":"_%msg)
    .i SQLCODE'=0 s ret=-11 
    .i ret'=0 trollback
    .q:ret'=0 
    .i Flag'="Y" d
    ..s ret=..RecoveryInfoByDHCLog(str)  //不通过恢复对应数据
    .i ret'=0 trollback
    .q:ret'=0
    q:ret'=0 ret 
    tcommit
	q ret
}

ClassMethod InsLogMain(user As %String)
{
	 k PLIST
	 s PLIST(2)=+$h
	 s PLIST(3)=+$p($h,",",2)
	 s PLIST(4)=user
	 &sql(insert into dhc_log values PLIST())
	 q:SQLCODE ""
	 q +%ROWID
}

ClassMethod SelPhcd(user, mrowid, CurrRowid, type, reason)
{
	; type : 0   - Before Update
	; type : 1   - After Update
	; type : 2   - New Add
	n (user,mrowid,CurrRowid,type,reason)
	k PLIST
	&sql(select * into :PLIST() from phc_drgmast where PHCD_RowId=:CurrRowid)
	i SQLCODE=100 d
	.&sql(select * into :PLIST() from phc_drgmast where PHCD_RowId=+:CurrRowid)
	q:SQLCODE -1
	s rowid=+PLIST(1)
	s code=PLIST(15)
	s desc=PLIST(2)
	s manf=PLIST(13)
	s subcat=PLIST(5)
	s mincat=PLIST(18)
	s generic=PLIST(22)
	s offcode=PLIST(23)
	s poison=PLIST(8)
	s ch=$o(^PHCD(rowid,"DF",0))
	i ch="" d
	. s instruc=""
	. s form=""
	. s uom=""
	. s freq=""
	e  d
	. s instruc=$p(^PHCD(rowid,"DF",ch,1),"^",5)
	. s form=$p(^PHCD(rowid,"DF",ch,1),"^",1)
	. s uom=$p(^PHCD(rowid,"DF",ch,2),"^",4)
	. s freq=$p(^PHCD(rowid,"DF",ch,1),"^",4)
	k PLIST
	f i=0:1:16 s PLIST(i)=""
	i mrowid="" d
	. s mrowid=..InsLogMain(user)
	q:mrowid="" -2
	s PLIST(0)=+mrowid  ; parref rowid
	s ch=0
	s ch=$o(^DHCLOG(mrowid,"PHCD",""),-1)
	s ch=ch+1
	s PLIST(2)=ch
	s PLIST(3)=code
	s PLIST(4)=desc
	s PLIST(5)=poison
	s PLIST(6)=manf
	s PLIST(7)=subcat
	s PLIST(8)=mincat
	s PLIST(9)=generic
	s PLIST(10)=offcode
	s PLIST(11)=uom
	s PLIST(12)=rowid  ; rowid of phc_DrgMast
	s PLIST(13)=type
	s PLIST(14)=freq
	s PLIST(15)=form
	s PLIST(16)=instruc
	// s PLIST(17)=reason
	&sql(insert into dhc_log_phcd values PLIST())
	i SQLCODE'=0  d
	.trollback
	.s rett=$$ErrorRecord^DHCSTERROR("Insert:DHC_Log_Phcd",desc,SQLCODE_":"_%msg)
	q:SQLCODE -3
	q %ROWID
}

ClassMethod SelArcim(user, mrowid, CurrRowid, type, reason)
{
	 ; type : 0   - Before Update
	 ; type : 1   - After Update
	 ; type : 2   - New Add
	 n (user,mrowid,CurrRowid,type,reason)
	 k PLIST
	 &sql(select * into :PLIST() from arc_itmmast where arcim_rowid=:CurrRowid)
	 q:SQLCODE -1
	 s arcim=PLIST(1)
	 s BillingUom=PLIST(105)
	 s BillSubCat=PLIST(47)
	 s Code=PLIST(2)       
	 s Desc=PLIST(3)       
	 s Effdate=+PLIST(58)    
	 s EffDateto=+PLIST(73)  
	 i EffDateto="0" s EffDateto=""
	 s ItemCat=PLIST(9)    
	 s OrderOnItsOwn=PLIST(83)
	 s OrdPriority=PLIST(113)  
	 s oemsg=PLIST(81)  
	 i mrowid="" d
	  . s mrowid=..InsLogMain(user)
	  . s mrowid=+mrowid
	 q:mrowid="" -2
	 s ch=0
	 s ch=$o(^DHCLOG(mrowid,"ARCIM",""),-1)
	 s ch=ch+1
	 ;       
	 k PLIST  f i=0:1:15 s PLIST(i)=""
	 s PLIST(0)=mrowid
	 s PLIST(2)=ch
	 s PLIST(3)=type
	 s PLIST(4)=arcim
	 s PLIST(5)=Code
	 s PLIST(6)=Desc
	 s PLIST(7)=Effdate
	 s PLIST(8)=EffDateto
	 s PLIST(9)=ItemCat
	 s PLIST(10)=BillSubCat
	 s PLIST(11)=BillingUom
	 s PLIST(12)=OrdPriority
	 s PLIST(13)=$p(OrderOnItsOwn,$c(1))
	 s PLIST(15)=reason
	 s memo=..OEMessage(arcim)
	 s PLIST(14)=memo
	 &sql(insert into dhc_log_arcim values PLIST() )
	 i SQLCODE'=0  d
	 .trollback
	 .s rett=$$ErrorRecord^DHCSTERROR("Insert:dhc_log_arcim",Desc,SQLCODE_":"_%msg)
	 q:SQLCODE SQLCODE
	 q %ROWID
}

ClassMethod SelInci(user, mrowid, CurrRowid, type, reason)
{
	 ; type : 0   - Before Update
	 ; type : 1   - After Update
	 ; type : 2   - New Add
	 n (user,mrowid,CurrRowid,type,reason)
	 k PLIST
	 &sql(Select * into :PLIST() from inc_itm where inci_rowid=:CurrRowid)
	 q:SQLCODE -1
	 s Code=PLIST(44)
	 s CTUOM=PLIST(13)
	 s CTUOMPurch=PLIST(60)
	 s Desc=PLIST(45)
	 s INCIDR=PLIST(1)
	 s StkCat=PLIST(14)
	 s nouseflag=PLIST(38)
	 s info=$o(^DHCITMINFO(0,"INCI",CurrRowid,""),-1)
	 i info="" s spec=""
	 e  s spec=$p(^DHCITMINFO(info),"^",27)
	 i mrowid="" d
	  . s mrowid=..InsLogMain(user)
	  . s mrowid=+mrowid
	 q:mrowid="" -2
 
	 k PLIST  f i=0:1:11 s PLIST(i)=""
	 ;
	 s ch=0
	 s ch=$o(^DHCLOG(mrowid,"INCI",""),-1)
	 s ch=ch+1
	 ;
	 s PLIST(0)=mrowid
	 s PLIST(6)=ch
	 s PLIST(2)=Code
	 s PLIST(3)=Desc
	 s PLIST(4)=CTUOM
	 s PLIST(8)=CTUOMPurch
	 s PLIST(9)=INCIDR
	 s PLIST(10)=StkCat
	 s PLIST(7)=type
	 s PLIST(12)=spec
	 s PLIST(13)=nouseflag
	 s PLIST(14)="N"
	 &sql(insert into dhc_log_inci values PLIST())
	 i SQLCODE'=0  d
	 .trollback
	 .s rett=$$ErrorRecord^DHCSTERROR("Insert:dhc_log_inci",Desc,SQLCODE_":"_%msg)
	 q:SQLCODE -3
	 q %ROWID
}

/// w ##class(web.DHCST.DrugInfoAudit).OEMessage("858||1")
ClassMethod OEMessage(arcim)
{
	 n (arcim)
	 s id1=$P(arcim,"||",1)
	 s id2=$P(arcim,"||",2)
	 q:id1="" "" 
	 q:id2="" "" 
	 s memo=""
	 i $d(^ARCIM(id1,id2,"OEM"))'=0 d 
	 .s memonum=^ARCIM(id1,id2,"OEM",0)
	 .f k=1:1:memonum  d
	 ..i memo="" s memo=^ARCIM(id1,id2,"OEM",k)
	 ..e  s memo=memo_"@"_^ARCIM(id1,id2,"OEM",k)
	 q $g(memo)
}

/// w ##class(web.DHCST.DrugInfoAudit).GetAuditLevel("590","G",590)
ClassMethod GetAuditLevel(type, stkgrptype, userid)
{
	s audlev=0
	s stalid=$o(^DHCSTAL(0,"User",type,stkgrptype,userid,""))
	i +stalid'="0" d
	.s audlev=$p(^DHCSTAL(stalid),"^",3)
	.i $p(^DHCSTAL(stalid),"^",5)'="Y" s audlev=0  //yunhaibao,20161010,未启用,审核级别视为0
	q +audlev
}

/// Creator		zhaozhiduan
/// CreatDate	2015-04-09
/// Description	根据三大项日志还原药品基本信息
/// Input		库存项id^日志id
/// Output
/// Exec			w ##class(web.DHCST.DrugInfoAudit).RecoveryInfoByDHCLog("858^5159")
ClassMethod RecoveryInfoByDHCLog(InfoStr)
{
	s inci=$p(InfoStr,"^",1)
	s dhcl=$p(InfoStr,"^",2)
	s ret=0
	i $d(^DHCLOG(dhcl,"INCI")) d
	.q:$p(^DHCLOG(dhcl,"INCI",1),"^",2)'=0
	.k PLIST
	.&sql(Select * into :PLIST() from dhc_log_inci where DLIN_DL_Parref=:dhcl and DLIN_Type="0")
	.i SQLCODE'=0 s ret=-1
	.q:SQLCODE'=0
	.s Code=PLIST(2)
	.s Desc=PLIST(3)
	.s CTUOM=PLIST(4)
	.s CTUOMPurch=PLIST(8)
	.s INCIDR=PLIST(9)
	.s StkCat=PLIST(10)
	.s spec=PLIST(12)
	.s nouseflag=PLIST(13)
	.s info=$o(^DHCITMINFO(0,"INCI",inci,""),-1)
	.i info'="" d
	..s $p(^DHCITMINFO(info),"^",27)=spec
	..i nouseflag="N" s $p(^DHCITMINFO(info),"^",47)=""  //不可用原因
	.&SQL(UPDATE INC_Itm SET INCI_Code=:Code,Inci_Desc=:Desc,INCI_CTUOM_DR=:CTUOM,INCI_CTUOM_Purch_DR=:CTUOMPurch,
		 INCI_INCSC_DR=:StkCat,INCI_NotUseFlag=:nouseflag
		 WHERE INCI_RowId=:INCIDR ) //修改为update形式,否则索引会有问题
 	q:ret'=0 ret 	 
 	i $d(^DHCLOG(dhcl,"ARCIM")) d
 	.q:$p(^DHCLOG(dhcl,"ARCIM",1),"^",1)'=0
 	.k PLIST
	.&sql(select * into :PLIST() from dhc_log_arcim where DLAR_DL_Parref=:dhcl and DLAR_Type="0")
	.i SQLCODE'=0 s ret=-2
	.q:SQLCODE'=0
	.s arcitm=PLIST(4)
	.s BillingUom=PLIST(11)
	.s BillSubCat=PLIST(10)
	.s Code=PLIST(5)       
	.s Desc=PLIST(6)       
	.s Effdate=+PLIST(7)    
	.s EffDateto=+PLIST(8)  
	.i EffDateto="0" s EffDateto=""
	.s ItemCat=PLIST(9)    
	.s OrderOnItsOwn=PLIST(13)
	.s OrdPriority=PLIST(12)  
	.s oemsg=PLIST(14)  
	.s arc=+arcitm
	.s itm=$p(arcitm,"||",2)
    .s frdate=$p(^ARCIM(arc,itm,1),"^",13)
    .s Effdate=Effdate_","_$p(frdate,",",2)
    .s todate=$p(^ARCIM(arc,itm,7),"^",1)
    .&SQL(UPDATE ARC_ItmMast SET ARCIM_Code=:Code,ARCIM_Desc=:Desc,ARCIM_EffDateTime=:Effdate,ARCIM_EffDateTo=:EffDateto,ARCIM_ItemCat_DR=:ItemCat,
    	  ARCIM_OrderOnItsOwn=:OrderOnItsOwn,ARCIM_DefPriority_DR=:OrdPriority,ARCIM_BillSub_DR=:BillSubCat WHERE ARCIM_RowId=:arcitm)
    .i oemsg'="" d
    ..s len=$l(oemsg,"@")
    ..f i=1:1:len  d
    ...s ^ARCIM(arc,itm,"OEM",i)=$p(oemsg,"@",i)
    .i SQLCODE=0 d
    ..i $d(^DHCOLT(0,"ARTTA",arcitm)) d 	
    ...s TarItm=$o(^DHCOLT(0,"ARTTA",arcitm,""))
 	...&SQL(UPDATE DHC_TarItem SET TARI_Code=:Code, TARI_Desc=:Desc WHERE TARI_RowId=:TarItm)
    q:ret'=0 ret	
 	i $d(^DHCLOG(dhcl,"PHCD")) d
 	.q:$p(^DHCLOG(dhcl,"PHCD",1),"^",2)'=0
 	.k PLIST
	.&sql(select * into :PLIST() from dhc_log_phcd where DLPH_DL_Parref=:dhcl and DLPH_Type="0")
	.i SQLCODE'=0 s ret=-3
	.q:SQLCODE'=0
	.s rowid=+PLIST(12)
	.s code=PLIST(3)
	.s desc=PLIST(4)
	.s manf=PLIST(6)
	.s subcat=PLIST(7)
	.s mincat=PLIST(8)
	.s generic=PLIST(9)
	.s offcode=PLIST(10)
	.s poison=PLIST(5)
	.s instruc=PLIST(16)
	.s form=PLIST(15)
	.s uom=PLIST(11)
	.s freq=PLIST(14)
	.&SQL(UPDATE PHC_DrgMast SET PHCD_Code=:code,PHCD_Name=:desc, PHCD_PHCSC_DR=:subcat,PHCD_PHCPO_DR=:poison,
		  PHCD_MinSubCat_DR=:mincat, PHCD_PHMNF_DR=:manf,PHCD_Generic_DR=:generic,PHCD_OfficialCode=:offcode 
		  WHERE PHCD_RowId=:rowid)
	.s ch=$o(^PHCD(rowid,"DF",0))
	.i ch'="" d
	..s phcdfrowid=rowid_"||"_ch
	..&SQL(UPDATE PHC_DrgForm SET PHCDF_PHCF_DR=:form,PHCDF_PHCFR_DR=:freq,PHCDF_PHCIN_DR=:instruc,PHCDF_CTUOM_DR=:uom
		   WHERE PHCDF_RowId=:phcdfrowid)
	q ret
}

/// creator:yunhaibao
/// createdate:20151215
/// description:保存日志到DHCLog表
/// input:药学id,医嘱id,库存id,登录信息,AU标志(2新增,0更新前,1更新后)
/// w ##class(web.DHCST.DrugInfoAudit).SaveToDHCLog("","","","","","","","")
ClassMethod SaveToDHCLog(DHCLog, PhcdfRowidStr, ArcRowidStr, IncRowidStr, StrParam, PhcListData, ArcListData, IncListData)
{
	N (DHCLog,PhcdfRowidStr,ArcRowidStr,IncRowidStr,StrParam,PhcListData,ArcListData,IncListData)
	q:DHCLog="" ""
	s Ret=0
	s user=$p(StrParam,"^",3)
 	s mlog=DHCLog
 	s BPhcdfId=$p(PhcdfRowidStr,"^",1)  //B改前,A改后
 	s APhcdfId=$p(PhcdfRowidStr,"^",2)
 	s BArcId=$p(ArcRowidStr,"^",1)  //B改前,A改后
 	s AArcId=$p(ArcRowidStr,"^",2)
 	s BIncId=$p(IncRowidStr,"^",1)  //B改前,A改后
 	s AIncId=$p(IncRowidStr,"^",2)
 	s PhcActionFlag="",ArcActionFlag="",IncActionFlag=""
 	i BPhcdfId="" s PhcActionFlag="2"
 	i BArcId="" s ArcActionFlag="2"
 	i BPhcdfId="" s IncActionFlag="2"
 	q:(PhcActionFlag=2)&&(APhcdfId="") 0
 	q:(ArcActionFlag=2)&&(AArcId="") 0
 	q:(IncActionFlag=2)&&(AIncId="") 0
 	i BPhcdfId'="" d
 	.s PhcActionFlag=0
 	.i APhcdfId'="" s PhcActionFlag=1
 	i BArcId'="" d
 	.s ArcActionFlag=0
 	.i AArcId'="" s ArcActionFlag=1
 	i BIncId'="" d
 	.s IncActionFlag=0
 	.i AIncId'="" s IncActionFlag=1
 	i APhcdfId="" s APhcdfId=BPhcdfId
 	i AArcId="" s AArcId=BArcId
 	i AIncId="" s AIncId=BIncId  //不论修改前后,id是不变的
 	i APhcdfId'="" d   ///插入log表记录修改信息,修改前
 	.s Ret=##class(web.DHCST.DrugInfoAudit).SelPhcd(user,mlog,APhcdfId,PhcActionFlag,"")
 	i +Ret<0 trollback
 	q:+Ret<0 -1002 
 	i AArcId'="" d 
 	.s Ret=##class(web.DHCST.DrugInfoAudit).SelArcim(user,mlog,AArcId,ArcActionFlag,"")
 	i +Ret<0 trollback
 	q:+Ret<0 -1003 
 	i AIncId'="" d 
 	.s Ret=##class(web.DHCST.DrugInfoAudit).SelInci(user,mlog,AIncId,IncActionFlag,"")
 	i +Ret<0 trollback
 	q:+Ret<0 -1004
 	q 0
}

ClassMethod NewPid()
{
	q $i(^DHCSTPID("DrugInfoAudit"))
}

}
