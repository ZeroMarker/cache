Class web.Test Extends %RegisteredObject [ Not ProcedureBlock ]
{

//  ##Class(web.Test).tt(18)

ClassMethod tt(VisitNumberReportPanicDR)
{
	s num=0,PanicResults=""
	Set rsetPres=##class(%ResultSet).%New("DHCLIS.DHCCommon.QueryPanicResult")
	d rsetPres.Execute(VisitNumberReportPanicDR)
	While (rsetPres.Next()) {
		//TestCodeName,VisitNumberReportPanicDR,TestCodeDR,Result,TextRes,ExtraRes,OtherRes,ResNoes,AbFlag,RefRanges,MethodDR,MachineParameterDR,AssayDate,AssayTime,Sequence,Unit
		s TestCodeName=rsetPres.GetData(1)
		s Result=rsetPres.GetData(5)
		s ExtraRes=rsetPres.GetData(6)
		s AbFlag=rsetPres.GetData(9)
		s Ranges=rsetPres.GetData(10)
		s Unit=rsetPres.GetData(16)
		i AbFlag="多耐" s Unit=AbFlag
		i $l(ExtraRes) s Result=Result_" "_ExtraRes
		i $l(Unit) s Result=Result_"("_Unit_")"
		s num=num+1
		i PanicResults="" s PanicResults=num_"、项目名称："_TestCodeName_"    结果："_Result_"    参考范围："_Ranges
		e  s PanicResults=PanicResults_"；"_num_"、项目名称："_TestCodeName_"    结果："_Result_"    参考范围："_Ranges
	 }
	d rsetPres.Close()
	b
}

ClassMethod room()
{
	s RoomId=395
	Set tmpWardId=""
	Set differentSexFlag=0
	For {
		Set tmpWardId = $o(^PAWARD("BED_Room_DR",RoomId,tmpWardId))
		w tmpWardId,!
		Quit:tmpWardId=""
		Quit:(differentSexFlag=1)
		Set tmpBedId=""
	    for {
		 	 Set tmpBedId = $o(^PAWARD("BED_Room_DR",RoomId,tmpWardId,tmpBedId))
		 	 w "   "_tmpBedId,!
		 	 Quit:tmpBedId=""
		 	 Quit:(differentSexFlag=1)
		 	 b ;
		 	 SEt bedAdmId = $O(^PAWARDA(tmpWardId,"BED",tmpBedId,"ADM",""),-1)
		 	 if (bedAdmId>0){
		 	 	Set paadm = $p(^PAWARDA(tmpWardId,"BED",tmpBedId,"ADM",bedAdmId),"^",1)
		 	 	b:paadm=370
		 	 	if (paadm>0){
		 	 		Set tmpSexId = $p(^PAPER(+^PAADM(paadm),"ALL"),"^",7)
		 	 		if (tmpSexId'="")&&(SexId'="")&&(SexId'=tmpSexId) Set differentSexFlag=1
		 	 		Quit:(differentSexFlag=1)
		 	 	}
		 	}
	    }
	}
	q differentSexFlag
}

ClassMethod VB(text)
{
	s displayHandler = "{HIDDEN2_Disable:['D','E'],UnusePermission_Disable:['0']}"		
	&sql(insert into sqluser.websys.ExtMenu (EMCode,EMText,EMParentCode,EMDisplayHandler,EMHandler) 
	values('NURPRNOrderUnuse','作废','NURPRNOrder',:displayHandler,'abortOrderHandler'))
}

ClassMethod TestExpression(eval)
{
	s $zt="ERR"
	k e
	q:eval="" ""
	q @eval
ERR
	W $ze
}

ClassMethod TestQuery()
{
	Set rset=##class(%ResultSet).%New("web.DHCOEOrdItem.FindOrderItems")
	d rset.Execute(70283)
	Set columns = rset.GetColumnCount()
	 While (rset.Next()) {
	     Write "------------------------",!
	         // loop over columns
	        For col = 1:1:columns {
	            Write rset.GetColumnName(col),":"
	            Write rset.GetData(col),!
	        }
	        w "OrderLinkTo:"_rset.Data("OrderLinkTo",1)
	 }
	 d rset.Close()
}

ClassMethod DeployPackage()
{
	d $System.OBJ.GetPackageList(.items,"web",.qstruct)
	s classname=""
	s classname=$O(items(classname))
	while (classname'=""){
		if (classname["web.DHC")||(classname["web.UDHC")||(classname["web.udhc") {
			d $System.OBJ.MakeClassDeployed("classname")
		}
		s classname=$O(items(classname))
	}
}

ClassMethod TestPara(SelectSQL As %String)
{
		S QuerySQL="SELECT ID, ClassName, Event, CacheScript FROM websys.UserDefinedFunctions WHERE ClassName %STARTSWITH :ClassName AND Event %STARTSWITH :Event"
		s QuerySQL=$ZCONVERT(QuerySQL,"U")
		s QuerySQL=$TRANSLATE(QuerySQL,$c(10)," ")
		s QuerySQL=$TRANSLATE(QuerySQL,$c(13)," ")
		s tmpSql=QuerySQL
		s parastr="",paramcn=0
		while (tmpSql[":"){
			set newSql=$p(tmpSql,":")
			set location=$l(newSql)+1
			set index=1
			set para="",flag=1
			s paramcn=paramcn+1
			while flag {
				set nextloc=$e(tmpSql,location+index)
				if (nextloc=" ")||(nextloc=")"){
					set flag=0
				}else{
					set para=para_nextloc
				}
				set:(location+index)>$l(tmpSql) flag=0
				Q:flag=0
				set index=index+1
			}
			
			if parastr="" s parastr=""""_para_""""
			e  s parastr=parastr_","""_para_""""
			w !,para_"/"_index_"/"_location
			set newSql=newSql_" ? "_$e(tmpSql,location+index,$l(tmpSql))
			w !,newSql
			set tmpSql=newSql
		}
		s QuerySQL=tmpSql
}

ClassMethod aa(para1)
{
	//s a=10990
	//q a
	s RowId=""
    s ind=1
	f  s RowId=$o(^DHCINVPRT(0,"Report",para1,RowId)) q:RowId=""  d
	.s invInfo=$g(^DHCINVPRT(RowId))
	.s prtfairtype=$p(invInfo,"^",34)
	;.w !,prtfairtype
    .q:prtfairtype="F"    
    .s prtaccdr=""
    .s prtaccdr=$p(invInfo,"^",4)
    .q:prtaccdr'=""
    ;.w !,prtfairtype_"a"_prtaccdr
    .s amt=$p(invInfo,"^",1)
    .s prtdate=$p(invInfo,"^",5)
    .s:prtdate'="" prtdate=$zd(prtdate,3)
    .s prttime=$p(invInfo,"^",20)
    .s:prttime'="" prttime=$zt(prttime)
    .s flag=$p(invInfo,"^",8)
    .s invno=$p(invInfo,"^",14)  
    .s initinv=$p(invInfo,"^",13)
    .s ind=ind+1
    .s refaccdr=""
    .i initinv'=""  s refaccdr=$p(^DHCINVPRT(initinv),"^",4)
    .q:refaccdr'=""
}

ClassMethod bb()
{
    set b=1
    set arr=$listbuild(1,2,3,4,5)
    f a=1:1:9 d
    
    .set aa=$list(arr,b)
    .s prtime=$p($H,",",2)
    .i prtime'="" s prtime=$zt(prtime)
    .w "***"_prtime_"***"
    .set b=b+1
    .w !,aa
    .q:aa=2
    .s bb=12
    .w !,bb
    .q:bb=12
}

ClassMethod GetFPDetail(JkDr, UserDr)
{
	;w ##class(web.Test).GetFPDetail("1070","659")
	s zfno="",hcno="",normalno=""
	s normalnum=0,normalsum=0,hcnum=0,hcsum=0,zfnum=0,zfsum=0,allsum=0
	s refaccdr=""
    s RowId=""
    s ind=1
    f  s RowId=$o(^DHCINVPRT(0,"Report",JkDr,RowId)) q:RowId=""  d
    .s invInfo=$g(^DHCINVPRT(RowId))
    .s prtfairtype=$p(invInfo,"^",34)
    .q:prtfairtype'="F"
    .s prtaccdr=""
    .s prtaccdr=$p(invInfo,"^",4)
    .q:prtaccdr'=""
    .s prtuser=$p(invInfo,"^",21)
    .q:(UserDr'="")&&(UserDr'=prtuser)
    .s amt=$p(invInfo,"^",1)
    .s prtdate=$p(invInfo,"^",5)
    .s:prtdate'="" prtdate=$zd(prtdate,3)
    .s prttime=$p(invInfo,"^",20)
    .s:prttime'="" prttime=$zt(prttime)
    .s flag=$p(invInfo,"^",8)
    .s invno=$p(invInfo,"^",14)  
    .s initinv=$p(invInfo,"^",13)
    .s ind=ind+1
    .s refaccdr=""
    .i initinv'=""  s refaccdr=$p(^DHCINVPRT(initinv),"^",4)
    .q:refaccdr'="" 
    .i flag="A"  d
    ..s:invno'="" zfnum=+zfnum+1
    ..s:initinv'="" zfsum=+zfsum+(+amt)
    .i flag="S"  d
    ..s hcnum=+hcnum+1  ;s:invno'="" hcnum=+hcnum+1
    ..s hcsum=+hcsum+(+amt)  ;s:initinv'="" hcsum=+hcsum+(+amt)
    .;i (invno'="")&(flag'="S")  d
    .i (invno'="")  d
    ..s normalnum=normalnum+1
    ..s normalsum=+normalsum+(+amt)
    .s allsum=+allsum+(+amt)
    s accrowid=""
    f  s accrowid=$o(^DHCINVPRTAPi(0,"INVRep",JkDr,accrowid)) q:accrowid=""  d
    .s handdr=$p(^DHCINVPRTAP(accrowid),"^",20)
    .s invno=$p(^DHCINVPRTAP(accrowid),"^",6)
    .s ind=ind+1
    .s prtuser=$p(^DHCINVPRTAP(accrowid),"^",5)
    .q:((UserDr'="")&(UserDr'=prtuser))
    .s flag=$p(^DHCINVPRTAP(accrowid),"^",2)
    .s amt=$p(^DHCINVPRTAP(accrowid),"^",1)
    .s initinv=$p(^DHCINVPRTAP(accrowid),"^",10)
    .i flag="A"  d
    ..s:invno'="" zfnum=+zfnum+1
    ..s:initinv'="" zfsum=+zfsum+(+amt)
    .i flag="S"  d
    ..s hcnum=+hcnum+1  ;s:invno'="" hcnum=+hcnum+1
    ..s hcsum=+hcsum+(+amt)  ;s:initinv'="" hcsum=+hcsum+(+amt)
    .;i (invno'="")&(flag'="S")  d
    .i (invno'="")  d
    ..s normalnum=normalnum+1
    ..s normalsum=+normalsum+(+amt)
    .s allsum=+allsum+(+amt)
    s zfno=$g(^TMP("EPInvDailyHand/No",prtuser,"Abort","no"))
    s hcno=$g(^TMP("EPInvDailyHand/No",prtuser,"Strik","no"))
    s normalno=$g(^TMP("EPInvDailyHand/No",prtuser,"Normal","no"))
    k ^TMP("EPInvDailyHand/No",prtuser,"Abort","no")
    k ^TMP("EPInvDailyHand/No",prtuser,"Strik","no")
    k ^TMP("EPInvDailyHand/No",prtuser,"Normal","no")
    q normalsum_"^"_normalnum_"^"_zfsum_"^"_zfnum_"^"_hcsum_"^"_hcnum_"^"_invno
}

/// 沈阳医嘱更新关联主医嘱字段
/// w ##class(web.Test).UpdateOEORI()
ClassMethod UpdateOEORI() As %String
{
	s UDate=+$H+1
	s count=0
	s AdmRowid=0
	for {
		s AdmRowid=$O(^PAADMi("PAADM_Type","I",AdmRowid))
		Q:AdmRowid=""
		s VisitStatus=$P($g(^PAADM(AdmRowid)),"^",20)
		s AdmType=$P($G(^PAADM(AdmRowid)),"^",2)
		s PaadmDate=$P($G(^PAADM(AdmRowid)),"^",6)
		if VisitStatus'="A" continue
		s OrderRowid=$O(^OEORD(0,"Adm",AdmRowid,0))
		if OrderRowid="" continue
		s ItemSub=0
		for {
			
			s ItemSub=$O(^OEORDi(0,"StDt",UDate,OrderRowid,ItemSub))
			;s ItemSub=$O(^OEORD(OrderRowid,"I",ItemSub))
			Q:ItemSub=""
			if '$D(^OEORD(OrderRowid,"I",ItemSub,1)) continue
			s ItemStatus=$p(^OEC("OSTAT",$p(^OEORD(OrderRowid,"I",ItemSub,1),"^",13)),"^",1)
			if ItemStatus'="V" continue
			/*
			s replocdesc=""
			s Itemreploc=$p(^OEORD(OrderRowid,"I",ItemSub,3),"^",6)
			if Itemreploc'="" {
				s replocdesc=$p(^CTLOC(Itemreploc),"^",2)
				i $f(replocdesc,"-")  s replocdesc=$p(replocdesc,"-",2)
			}
			if Itemreploc'="配液中心接收科室的RowId" continue   ;需要写死"配液中心"的RowId
			
			s $p(^OEORD(OrderRowid,"I",ItemSub,"DHC"),"^",16)=1
			*/
			s SttDate=$p(^OEORD(OrderRowid,"I",ItemSub,1),"^",9)
			if SttDate'=UDate continue
			s SeqNo=$p(^OEORD(OrderRowid,"I",ItemSub,3),"^",4)
			if (SeqNo[".") {
				s SubSeqNo=$p(SeqNo,".",1)
				s LinkOrd=..GetLinkOrd(OrderRowid,SubSeqNo,UDate)
				if LinkOrd'="" {
					s $p(^OEORD(OrderRowid,"I",ItemSub,11),"^",39)=$g(LinkOrd)
					s ^OEORDi(0,"OEORI",OrderRowid,$g(LinkOrd),ItemSub)=""
					
					s ^TMPUpdateOEORILog("LOG",+$h,OrderRowid_"||"_ItemSub)=$g(LinkOrd)
					s count=count+1
				}
			}
		}
		
	}
	
	Q count
}

/// w ##class(web.Test).GetLinkOrd(3,7,61190)
ClassMethod GetLinkOrd(Ord, SubSeqNo, UDate) As %String
{
	n (Ord,SubSeqNo,UDate)
	s rtnLinkOrd=""
	s ItemSub=0
	for {
		s ItemSub=$O(^OEORDi(0,"StDt",UDate,Ord,ItemSub))
		Q:ItemSub=""
		if '$D(^OEORD(Ord,"I",ItemSub,1)) continue
		s ItemStatus=$p(^OEC("OSTAT",$p(^OEORD(Ord,"I",ItemSub,1),"^",13)),"^",1)
		if ItemStatus'="V" continue
		
		if '$D(^OEORD(Ord,"I",ItemSub,3)) continue
		s SeqNo=$p(^OEORD(Ord,"I",ItemSub,3),"^",4)
		if SeqNo=SubSeqNo s rtnLinkOrd=Ord_"||"_ItemSub Q
	}
	
	Q rtnLinkOrd
}

ClassMethod DelTr()
{
 k ^websys.TranslationD("PAGE",20,"%CSP.Broker.cls")
 k ^websys.TranslationD("PAGE",1,"%CSP.Broker.cls")
 Set pa="" For  Set pa = $O(^websys.TranslationD("PAGE","20",pa)) Q:pa=""  d
 .if pa["?" k ^websys.TranslationD("PAGE","20",pa)
 .if pa["=" k ^websys.TranslationD("PAGE","20",pa)
 
 Set pa="" For  Set pa = $O(^websys.TranslationD("PAGE","1",pa)) Q:pa=""  d
 .if pa["?" k ^websys.TranslationD("PAGE","1",pa)
 .if pa["=" k ^websys.TranslationD("PAGE","1",pa)
}

}
