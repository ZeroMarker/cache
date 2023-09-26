Import SQLUser

Class web.DHCWMRTest Extends (%Library.RegisteredObject, websys.Abstract) [ Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 71;

ClassMethod TestQueryExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	;.d BuildData
    ;"Rowid,Code,Value,DataType,Resume"
    s sRowid="1^2^3^4^5^6^7^8^9"
    s sCode="Code1^Code2^Code3^Code4^Code5^Code6^Code7^Code8^Code9"
    s sValue="Value1^Value2^Value3^Value4^Value5^Value6^Value7^Value8^Value9"
    s sDataType="Type1^Type2^Type3^Type4^Type5^Type6^Type7^Type8^Type9"
    s sResume="Re1^Re2^Re3^Re4^Re5^Re6^Re7^Re8^Re9"
	f i=1:1:$l(sRowid,"^") d
	.s Data=$lb("")
	.s $li(Data,1)=$p(sRowid,"^",i)
	.s $li(Data,2)=$p(sCode,"^",i)
	.s $li(Data,3)=$p(sValue,"^",i)
	.s $li(Data,4)=$p(sDataType,"^",i)
	.s $li(Data,5)=$p(sResume,"^",i)
	.s ^CacheTemp(repid,ind)=Data
	.s ind=ind+1
	Quit $$$OK
BuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod TestQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TestQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod TestQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TestQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query TestQuery() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Value:%String,DataType:%String,Resume:%String")
{
}

ClassMethod SetDicData(Code) As %String
{
	;n (itmName,DataType,DicType,Val)
	/*
	Set itmName="comb"
	Set DataType="4"
	Set DicType="Marriage"
	Set Val="1"
	*/

	Set itmName="EpdApp_"_rs.GetDataByName("iRow")
	Set DataType=rs.GetDataByName("DataType")
	Set DicType=rs.GetDataByName("DicType")
	Set Val=rs.GetDataByName("ItemValue")
	Set Requre=rs.GetDataByName("Requre")
    ;s Active=""
    s Active=$s(Active="1":"",1:"disabled")
    i DataType="4" d
    .Write "<select id='"_itmName_"' name='"_itmName_"' size=1 "_Active_" style='WIDTH: 180px; HEIGHT: 24px'>"
	.i Requre'="1" Write "<option  value=''></option>"
	.s temp=##class(web.DHCWMRMedDictoryCtl).GetByType(DicType,"Y")
	.f Index=1:1:($l(temp,$c(1))-1) d
	..s s=$p(temp,$c(1),Index)
	..s code=$p(s,"^",2)
	..s desc=$p(s,"^",3)
	..If code=Val Write "<option value="_code_" selected>"_desc_"</option>"
	..Else  Write "<option value="_code_">"_desc_"</option>"
	.Write "</select>"
    e  i DataType="5" d
    .Write "<input id='"_itmName_"' name='"_itmName_"' "_Active
	.Write " style='WIDTH: 104px; HEIGHT: 24px' value='"_val_"'>"
	.;Write "<IMG id='i"_itmName_"' name='i"_itmName_"'  src='../images/websys/lookupdate.gif'>"
    e  d
    .Write "<input id='"_itmName_"' name='"_itmName_"' "_Active
	.Write " style='WIDTH: 104px; HEIGHT: 24px' value='"_val_"'>"
 	q ""
}

ClassMethod QueryCtLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryCtLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryCtLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCtLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod QueryCtLocExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s flag=$$getctloc^DHCWMRMedBase()
	s count=P1
	f i=1:1:count d
	.s s=PLIST(i)
	.d BuildDatas
	Quit $$$OK
BuildDatas
	set Data=$lb("")
 	f iBuild=1:1:$l(s,$c(2)) d
 	.s $li(Data,iBuild)=$p(s,$c(2),iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

Query QueryCtLoc() As %Query(ROWSPEC = "Rowid:%String,Description:%String")
{
}

/// 为当前在院病人接诊
ClassMethod ReceiptCurrPaadm()
{
   s i=0,j=0,x=0,h=0
   w "ReceiptCurrPaadm...",!
   s file="/tmp/DHCWMR.log"
   s MrType=7,ctloc=148,UserId=2040
   o file:"WNS"
   u file
   s Ward=""
   f  s Ward=$o(^PAADMi("CurrWard",Ward)) q:Ward=""  d
   .s Room="" f  s Room=$o(^PAADMi("CurrWard",+Ward,Room)) q:Room=""  d
   ..s paadm="" f  s paadm=$o(^PAADMi("CurrWard",+Ward,Room,paadm)) q:paadm=""  d
   ...s j=j+1
   ...s flag=0
   ...s papmi=+$p(^PAADM(+paadm),"^",1)
   ...s papmino=$p(^PAPER(papmi,"PAT",1),"^",1)
   ...s AdmDate=$zd($p($g(^PAADM(+paadm)),"^",6),3)
   ...s MrNo=$p(^PAPER(papmi,"PER",4),"^",4)
   ...s RetStr="^"_papmino_"^"_AdmDate_"^"_paadm_"^"_MrNo
   ...i $d(^DHCWMRVOL(0,"VolAdm",paadm)) d
   ....s VolRowid=$o(^DHCWMRVOL(0,"VolAdm",paadm,""),-1)
   ....s IsActive=$p($g(^DHCWMRVOL(+VolRowid)),"^",7)
   ....s:IsActive="Y" flag=1
   ....s:flag=1 h=h+1
   ....w:flag=1 !,"Over^"_VolRowid_RetStr
   ...q:flag=1            ;
   ...s MainRowid=""
   ...i MrNo="" d
   ....w !,"Null^"_RetStr
   ...q:MrNo=""
   ...
   ...i $d(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo)) d
   ....s TmpRowid=$o(^DHCWMRMAIN(0,"TypeNO",MrType,MrNo,""),-1)
   ....s IsActive=$p($g(^DHCWMRMAIN(+TmpRowid)),"^",6)
   ....s:IsActive="Y" MainRowid=TmpRowid
   ...;(MrType, papmi, paadm, MainRowid, ctloc, NameSpell, patcond, OldNo, UserId)
   ...s flag=##class(web.DHCWMRReceipt).Receipt(MrType,papmi,paadm,MainRowid,ctloc,"",1,MrNo,UserId)
   ...i +flag>0 d
   ....s i=i+1
   ....w !,"OK^"_flag_RetStr
   ...e  d
   ....s x=x+1
   ....w !,"err^"_flag_RetStr
   c file
   w !,"OK!   All="_j_"  OK="_i_" ERR="_x_" OV="_h
   q "---OK---"
}

/// test
ClassMethod JavaTest() As %String
{
	q "Over!"
}

ClassMethod GetMetDataByTemplateID(TemplateID) As %String
{
	;Set Ret=##class(Test.test).GetMetDataByTemplateID(TemplateID)
	Set Ret=""
	Quit Ret
}

ClassMethod GetTemplateList() As %String
{
	;Set Ret=##class(Test.test).GetTemplateList()
	Set Ret=""
	Quit Ret
}

ClassMethod TmpCate() As %String
{
	;Set Ret=##class(Test.test).TestTemplateCategory()
	Set Ret=""
	Set Ret="^^^"_$c(1)
	Quit Ret
}

/// ret="{'total':'"_count_"','record':["_record_"]}"
/// record="{'id':"_"'"_id_"','desc':'"_ctlocdesc_"'},"
/// fields:
/// id
/// code
/// desc
/// resume
ClassMethod GetAjaxList(DicName, Alias) As %String
{
	n (DicName,Alias)
	set ret=""
	quit:DicName="" ret
	set SysFlag=$$ALPHAUP^SSUTIL4(DicName)
	
	if SysFlag="CTLOC"
	{
		set ret=..GetCTLocByDesc(Alias)
	}
	elseif SysFlag="WARD"
	{
	}
	elseif SysFlag="SSUSER"
	{
		set ret=..GetSSUserByName(Alias)
	}
	elseif SysFlag="DOCTOR"
	{
		set ret=..GetDocByName(Alias)
	}
	else
	{
		;DHC_WMR_Dictionary
		set ret=..GetWMRDicList(DicName)
	}
	quit ret
}

ClassMethod GetCTLocByDesc(Desc As %String)
{
	n (Desc)
	s Desc=$$ALPHAUP^SSUTIL4(Desc)
	s count=0
	s record=""
	s alias=Desc
	i $d(^CTLOC(0,"Desc",alias)) d
	.s id=0
	.f  s id=$o(^CTLOC(0,"Desc",alias,id)) q:id=""  d
	..s count=count+1
	..s tmprecord=$$BuildCtloc(id)
	..s record=record_tmprecord_","
	f  s alias=$o(^CTLOC(0,"Desc",alias)) q:(alias="")!(alias'[Desc)  d
	.s id=0
	.f  s id=$o(^CTLOC(0,"Desc",alias,id)) q:id=""  d
	..s count=count+1
	..s tmprecord=$$BuildCtloc(id)
	..s record=record_tmprecord_","
	s:record'="" record=$e(record,1,$l(record)-1)
	s ret="{'total':'"_count_"','record':["_record_"]}"
	q ret
BuildCtloc(ctloc)
    n (ctloc)
    s s=$g(^CTLOC(ctloc))
    s id=ctloc
    s code=$p(s,"^",1)
    s desc=$p(s,"^",2)
    s:desc["-" desc=$p(desc,"-",$l(desc,"-"))
    s resume=""
    s ret="{id:"_"'"_id_"',code:'"_code_"',desc:'"_desc_"',resume='"_resume_"'}"
    q ret
}

ClassMethod GetSSUserByName(Name As %String)
{
	n (Name)
	s count=0
	s record=""
	i $d(^SSU("SSUSR",0,"SSUSR_Name",Name)) d
	.s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Name",Name,Rowid))
	.s tmprecord=$$BuildUser(Rowid)
	.q:tmprecord=""
	.s count=count+1
	.s record=record_tmprecord_","
    
    s tmpName=Name
    f  s tmpName=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName)) q:(tmpName="")!(tmpName'[Name)  d
    .s Rowid=""
    .f  s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName,Rowid)) q:Rowid=""  d
	..s tmprecord=$$BuildUser(Rowid)
	..q:tmprecord=""
	..s count=count+1
	..s record=record_tmprecord_","
    
    s:record'="" record=$e(record,1,$l(record)-1)
	s ret="{'total':'"_count_"','record':["_record_"]}"
	q ret
    
    
BuildUser(Rowid)
    n (Rowid)
    s ret=""
    s s=$g(^SSU("SSUSR",+Rowid)) 
    s id=+Rowid
    s code=$p(s,"^",1)
    s desc=$p(s,"^",2)
    s active=$p(s,"^",19)
    q:active'="Y" ret
    s:desc["-" desc=$p(desc,"-",$l(desc,"-"))
    s ctloc=$p(s,"^",5)
    s resume=$p($g(^CTLOC(+ctloc)),"^",2)
    s:resume["-" demo=$p(resume,"-",$l(resume,"-"))
    s ret="{id:"_"'"_id_"',code:'"_code_"',desc:'"_desc_"',resume='"_resume_"'}"
    q ret
    
CheckDoctor(Rowid)
    n (Rowid)
    s flag=0
    q:Rowid="" flag
    q:'$d(^SSU("SSUSR",+Rowid)) flag
    s usrCareProvDR=$p($g(^SSU("SSUSR",+Rowid)),"^",14)
    q:usrCareProvDR="" flag
    q:'$d(^CTPCP(usrCareProvDR)) flag
    s activeFlag=$p($g(^CTPCP(usrCareProvDR,1)),"^",9)
    q:activeFlag'="Y" flag
    
    s CarPrvTpDr=$p($g(^CTPCP(usrCareProvDR,1)),"^",4)
    q:CarPrvTpDr="" flag
    
    q:'$d(^CT("CPT",CarPrvTpDr)) flag
    s InternalType=$p($g(^CT("CPT",CarPrvTpDr)),"^",4)
    
    q:InternalType'="DOCTOR" flag
    
    s flag=1
    q flag
}

ClassMethod GetDocByName(Name As %String)
{
	n (Name)
	s count=0
	s record=""
	i $d(^SSU("SSUSR",0,"SSUSR_Name",Name)) d
	.s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Name",Name,Rowid))
	.q:$$CheckDoctor(Rowid)=0
	.s tmprecord=$$BuildUser(Rowid)
	.q:tmprecord=""
	.s count=count+1
	.s record=record_tmprecord_","
    
    s tmpName=Name
    f  s tmpName=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName)) q:(tmpName="")!(tmpName'[Name)  d
    .s Rowid=""
    .f  s Rowid=$o(^SSU("SSUSR",0,"SSUSR_Name",tmpName,Rowid)) q:Rowid=""  d
	..s flag=$$CheckDoctor(Rowid)
	..
	..q:flag=0
	..
	..s tmprecord=$$BuildUser(Rowid)
	..q:tmprecord=""
	..;w !,"flag="_flag_"  "_tmprecord
	..s count=count+1
	..s record=record_tmprecord_","
    
    s:record'="" record=$e(record,1,$l(record)-1)
	s ret="{'total':'"_count_"','record':["_record_"]}"
	q ret
}

ClassMethod GetWMRDicList(DicName As %String)
{
	n (DicName)
	s count=0
	s record=""
	s ret="{'total':'"_count_"','record':["_record_"]}"
	
	q:'$d(^DHCWMRDIC(0,"DicName",DicName,"Y")) ret
    
    s WMRRowid=""
    f  s WMRRowid=$o(^DHCWMRDIC(0,"DicName",DicName,"Y",WMRRowid))  q:WMRRowid=""  d
    .s tmprecord=$$BuildWMRDic(WMRRowid)
    .q:tmprecord=""
	.s count=count+1
	.s record=record_tmprecord_","
    	
    s:record'="" record=$e(record,1,$l(record)-1)
	s ret="{'total':'"_count_"','record':["_record_"]}"
	q ret
BuildWMRDic(Rowid)
    n (Rowid)
    s s=$g(^DHCWMRDIC(Rowid))
    s id=+Rowid
    s code=$p(s,"^",2)
    s desc=$p(s,"^",3)
    ;s:desc["-" desc=$p(desc,"-",$l(desc,"-"))
    s resume=""
    s ret="{id:"_"'"_id_"',code:'"_code_"',desc:'"_desc_"',resume='"_resume_"'}"
    q ret
}

}
