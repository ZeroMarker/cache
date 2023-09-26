Class web.DHCDocDiagnosNew Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod InvNewComCLSID() As %String
{
  w "<LINK REL='stylesheet' TYPE='text/css' HREF='../scripts/epr.chartbook.side.css'>"
  w "<LINK REL='stylesheet' TYPE='text/css' HREF='../dhtmx/dhtmlxTabbar/codebase/dhtmlxtabbar.css'>"
  w "<LINK REL='stylesheet' TYPE='text/css' HREF='../dhtmx/dhtmlxTabbar/samples/common/style.css'>"
  w "<link REL='stylesheet' TYPE='text/css' HREF='../dhtmx/dhtmlxWindows/codebase/dhtmlxwindows.css'>"
  w "<SCRIPT SRC='../dhtmx/dhtmlxTabbar/codebase/dhtmlxcommon.js'></SCRIPT>"
  w "<SCRIPT SRC='../dhtmx/dhtmlxTabbar/codebase/dhtmlxtabbar.js'></SCRIPT>"
  w "<SCRIPT SRC='../dhtmx/dhtmlxWindows/codebase/dhtmlxwindows.js'></SCRIPT>"
  ;w "<div id='a_tabbar' style='width:1024; height:800'></DIV>"
}

ClassMethod AddPrivate(PrivateDesc As %String, USERID As %String, CTLOCID As %String, INDEXNum As %String) As %String
{
	if PrivateDesc="" Q "PrivateDesc Null"
	&sql(Insert into SQLUSER.DHC_MRDiagnosMaster Set DHCDIADESC=:PrivateDesc,DHCDIAUSER=:USERID,DHCDIALOC=:CTLOCID,DHCDIAINDEX=:INDEXNum)
    quit SQLCODE
}

ClassMethod GetPrivateList(USERID As %String) As %String
{
	If USERID="" Q "User Null"
	Set Str="",IndexNum=0
	Set DHCDIAINDEX="" f  s DHCDIAINDEX=$O(^DHCDIAMAS("USER",USERID,DHCDIAINDEX)) q:DHCDIAINDEX=""  d
	.Set DHCDIAMASRowid="" f  s DHCDIAMASRowid=$O(^DHCDIAMAS("USER",USERID,DHCDIAINDEX,DHCDIAMASRowid)) q:DHCDIAMASRowid=""  d
	..Set DHCDIADESC=$P(^DHCDIAMAS(DHCDIAMASRowid),"^",2)
	..If DHCDIADESC'="" Set IndexNum=IndexNum+1
	..If Str'="" Set Str=Str_$c(1)_DHCDIAMASRowid_"^"_DHCDIADESC
	..if Str="" Set Str=DHCDIAMASRowid_"^"_DHCDIADESC
	if (Str="") {
		s LOCID=%session.Get("LOGON.CTLOCID")
		if LOCID="" Q ""
		Set DHCDIAINDEX="" f  {
			s DHCDIAINDEX=$O(^DHCDIAMAS("CTLOC",LOCID,DHCDIAINDEX)) 
			q:DHCDIAINDEX=""  d
			Set DHCDIAMASRowid="" f  {
				s DHCDIAMASRowid=$O(^DHCDIAMAS("CTLOC",LOCID,DHCDIAINDEX,DHCDIAMASRowid)) 
				q:DHCDIAMASRowid=""  d
				Set DHCDIADESC=$P(^DHCDIAMAS(DHCDIAMASRowid),"^",2)
				If DHCDIADESC'="" Set IndexNum=IndexNum+1
				If Str'="" Set Str=Str_$c(1)_DHCDIAMASRowid_"^"_DHCDIADESC
				if Str="" Set Str=DHCDIAMASRowid_"^"_DHCDIADESC
			}
		}
	}
	Q Str_$c(2)_IndexNum
}

ClassMethod PrivateorderSave(PrivateorderStr As %String, USERID As %String) As %String
{
	f i=1:1:$l(PrivateorderStr,"^") d
	.Set MASTERRowid=$P(PrivateorderStr,"^",i) 
	.&sql(update SQLUSER.DHC_MRDiagnosMaster set DHCDIAINDEX=:i where DHCDIAUSER=:USERID and MASTERRowid=:MASTERRowid)
	Q SQLCODE
}

ClassMethod PrivateDel(USERID As %String, PrivateorderRowid As %String) As %String
{
	&sql(delete from SQLUSER.DHC_MRDiagnosMaster where DHCDIAUSER=:USERID and MASTERRowid=:PrivateorderRowid)
	&sql(delete from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_MASTERDR=:PrivateorderRowid)
	Q SQLCODE
}

ClassMethod PrivateChangeName(USERID As %String, PrivateorderRowid As %String, PrivateorderNewName As %String) As %String
{
	&sql(select count(MASTERRowid) into:count from SQLUSER.DHC_MRDiagnosMaster where DHCDIADESC=:PrivateorderNewName and DHCDIAUSER=:USERID and MASTERRowid<>:PrivateorderRowid)
	if (count>0){
	    Q "记录重复!"
	}
	&sql(Update SQLUSER.DHC_MRDiagnosMaster set DHCDIADESC=:PrivateorderNewName where DHCDIAUSER=:USERID and MASTERRowid=:PrivateorderRowid)
	Q SQLCODE
}

ClassMethod LookUpWithAliasBroker(desc As %String, CNDiagnoseFlag As %String = "1") As %String
{
   
    s len=$l(desc)
    s control=$e(desc,len)
    s ^xiangzong333=desc_"^"_control
    i (control="#")
    {s ^xiangzongtemp1111=desc 
    Set obj=##class(%ResultSet).%New("web.DHCMRDiagnos:LookUpWithAlias")
	d obj.Execute(desc,"","","",CNDiagnoseFlag)
	Set Str=""
	Set RetCount=0
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("desc")
	.S Desc=$P(Desc,"|",1)
	.s HIDDEN=obj.Data("HIDDEN")
	.s Code=obj.Data("code")
	.S RetCount=RetCount+1
	.Q:RetCount>50
    .if Str'="" Set Str=Str_"^"_HIDDEN_$c(1)_Desc
    .if Str="" Set Str=HIDDEN_$c(1)_Desc
    .s ^xiangzongtemp111=Str
    }
    
    else{
	Set obj=##class(%ResultSet).%New("web.DHCMRDiagnos:LookUpWithAlias")
	d obj.Execute(desc,"","","",CNDiagnoseFlag)
	Set Str=""
	Set RetCount=0
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("desc")
	.S Desc=$P(Desc,"|",1)
	.s HIDDEN=obj.Data("HIDDEN")
	.s Code=obj.Data("code")
	.S RetCount=RetCount+1
	.Q:RetCount>50
    .if Str'="" Set Str=Str_"^"_HIDDEN_$c(1)_Desc
    .if Str="" Set Str=HIDDEN_$c(1)_Desc
    .s ^xiangzongtemp111=Str
    }
    Q Str
}

ClassMethod PrivateSave(USERID As %String, selValue As %String, DiagnosStr As %String, ListNum As %String) As %String
{
   &sql(delete from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_ListNum=:ListNum and DHCMRDiaICD_MASTERDR=:selValue)
   Q:DiagnosStr="" "^"
   s rtn=""
   s err=0
   for i=1:1:$L(DiagnosStr,"^") {
		Set OneDiagnosInfo=$P(DiagnosStr,"^",i)
		Set MainICDInfo=$P(OneDiagnosInfo,"!",1)
		s MainIcdDesc=""
		s MainIcdRowid=+MainICDInfo
		i MainICDInfo["$" {
			s MainIcdDesc=$p(MainICDInfo,"$",2)
			s MainIcdRowid=""
		}
		Set SyndromeICDInfo=$P(OneDiagnosInfo,"!",2,$L(OneDiagnosInfo,"!"))
		s SyndromeICDInfo=$TR(SyndromeICDInfo,"!",$C(2))
		s count=0
		i MainIcdRowid'="" {
			if (SyndromeICDInfo'="") &sql(select count(DHCMRDiaICD_Rowid) into:count from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_MASTERDR=:selValue and DHCMRDiaICD_ICDDR=:MainIcdRowid and DHCMRDiaICD_SyndromeICDInfo=:SyndromeICDInfo)
		    else  &sql(select count(DHCMRDiaICD_Rowid) into:count from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_MASTERDR=:selValue and DHCMRDiaICD_ICDDR=:MainIcdRowid)
		}
		i count'=0 {
			i rtn="" s rtn=$p(^MRC("ID",MainIcdRowid),"^",2)
			e  s rtn=rtn_","_$p(^MRC("ID",MainIcdRowid),"^",2)
		}
		continue:count>0
		
		&sql(insert into SQLUSER.DHC_MRDiagnosICD set DHCMRDiaICD_MASTERDR=:selValue,DHCMRDiaICD_ICDDR=:MainIcdRowid,DHCMRDiaICD_ListNum=:ListNum,DHCMRDiaICD_ListIndex=:i,DHCMRDiaICD_Desc=:MainIcdDesc,DHCMRDiaICD_SyndromeICDInfo=:SyndromeICDInfo)
		s err=err+SQLCODE
   }
   Q err_"^"_rtn
   /*s rtn=""
   for i=1:1:$L(DiagnosStr,"^") d
   .Set IcdRowid=$P(DiagnosStr,"^",i)
   .s IcdDesc=""
   .i IcdRowid["$" d
   ..s IcdDesc=$p(IcdRowid,"$",2)
   ..s IcdRowid=""
   .s count=0
   .&sql(select count(DHCMRDiaICD_Rowid) into:count from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_MASTERDR=:selValue and DHCMRDiaICD_ICDDR=:IcdRowid)
   .i count'=0 d
   ..i rtn="" s rtn=$p(^MRC("ID",IcdRowid),"^",2)
   ..e  s rtn=rtn_","_$p(^MRC("ID",IcdRowid),"^",2)
   .q:count>0
   .&sql(insert into SQLUSER.DHC_MRDiagnosICD set DHCMRDiaICD_MASTERDR=:selValue,DHCMRDiaICD_ICDDR=:IcdRowid,DHCMRDiaICD_ListNum=:ListNum,DHCMRDiaICD_ListIndex=:i,DHCMRDiaICD_Desc=:IcdDesc)
   Q SQLCODE_"^"_rtn*/
}

ClassMethod GetICD(MASTERDR As %String, ListNum As %String) As %String
{
    Set langid=..%LanguageID()
    Set RetStr=""
    Set DHCMRDiaICDListIndex="" 
    f{
	    s DHCMRDiaICDListIndex=$O(^DHCDIAICD("MASTER",MASTERDR,ListNum,DHCMRDiaICDListIndex))
	    Q:DHCMRDiaICDListIndex=""
    	Set DHCMRDiaICDRowid=""
    	f {
	    	s DHCMRDiaICDRowid=$O(^DHCDIAICD("MASTER",MASTERDR,ListNum,DHCMRDiaICDListIndex,DHCMRDiaICDRowid))
	    	Q:DHCMRDiaICDRowid=""
	    	Set DHCMRDiaICDICDDR=$P($g(^DHCDIAICD(DHCMRDiaICDRowid)),"^",3)
			if (DHCMRDiaICDICDDR'="") {
				Set DHCMRDiaICDICDDesc=$P($G(^MRC("ID",DHCMRDiaICDICDDR)),"^",2)
				s ActiveFrom=$P(^MRC("ID",DHCMRDiaICDICDDR),"^",6)
				s ActiveTo=$P(^MRC("ID",DHCMRDiaICDICDDR),"^",7)
				continue:(ActiveFrom'="")&&(ActiveFrom>+$H)
				continue:(ActiveTo'="")&&(ActiveTo<+$H)
				s Active=$P(^MRC("ID",DHCMRDiaICDICDDR),"^",27)
				continue:Active'="Y"
				s DHCMRDiaICDICDDesc=##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",DHCMRDiaICDICDDesc,langid)
			}else{
				s DHCMRDiaICDICDDesc= $P($g(^DHCDIAICD(DHCMRDiaICDRowid)),"^",6)
				}
			s DHCMRDiaICDICDNotes=$P($g(^DHCDIAICD(DHCMRDiaICDRowid)),"^",8) //ICD诊断备注
			s SDSTermDR=$P($g(^DHCDIAICD(DHCMRDiaICDRowid)),"^",9) //结构化诊断中心词ID
			s SDSDisplayIDStr=$P($g(^DHCDIAICD(DHCMRDiaICDRowid)),"^",10) //属性ID串
			if (SDSTermDR'="") {
				s DHCMRDiaICDICDDesc=##class(web.DHCBL.MKB.SDSDiagnosFuseInterface).GetDisplayName(SDSTermDR,SDSDisplayIDStr)
			}
			s DHCMRDiaICDICDType=$P($g(^DHCDIAICD(DHCMRDiaICDRowid)),"^",11)
			if DHCMRDiaICDICDType=""{
				s BillFlag1=$P($G(^MRC("ID",+DHCMRDiaICDICDDR)),"^",13)
				s BillFlag3=$P($g(^MRC("ID",+DHCMRDiaICDICDDR)),"^",15)
				s DHCMRDiaICDICDType=$SELECT((BillFlag1="Y")&&(BillFlag3="Y"):2,(BillFlag1'="Y")&&(BillFlag3="Y"):1,1:0)
			}
			s SyndromeInfo=$P($g(^DHCDIAICD(DHCMRDiaICDRowid)),"^",7)
			s SyndromeDescInfo=""
			s Syndrome1="",Syndrome2=""
			
			for i=1:1:$L(SyndromeInfo,$C(2)) {
				s oneSyndromeInfo=$P(SyndromeInfo,$C(2),i)
				continue:oneSyndromeInfo=""
				s myICDRowID=""
				if $D(^MRC("ID",oneSyndromeInfo)) {
					s BillFlag1=$P($G(^MRC("ID",+oneSyndromeInfo)),"^",13)
					s BillFlag3=$P($g(^MRC("ID",+oneSyndromeInfo)),"^",15)
					if (BillFlag1'="Y")||(BillFlag3'="Y"){
						s myICDRowID=""
						s Desc=oneSyndromeInfo
					}else{
						s myICDRowID=oneSyndromeInfo
						s Desc=$P($G(^MRC("ID",myICDRowID)),"^",2)
						s Desc=##class(User.MRCICDDx).GetTranByDesc("MRCIDDesc",Desc,langid)
					}
					s ActiveFrom=$P(^MRC("ID",+oneSyndromeInfo),"^",6)
					s ActiveTo=$P(^MRC("ID",+oneSyndromeInfo),"^",7)
					continue:(ActiveFrom'="")&&(ActiveFrom>+$H)
					continue:(ActiveTo'="")&&(ActiveTo<+$H)
					s Active=$P(^MRC("ID",+oneSyndromeInfo),"^",27)
					continue:Active'="Y"
					
				}else{
					s Desc=oneSyndromeInfo
				}
				if (SyndromeDescInfo=""){
					s SyndromeDescInfo=Desc
				}else{
					s SyndromeDescInfo=SyndromeDescInfo_"!"_Desc
				}
				
				if (Syndrome1="")&&(Syndrome2=""){
					if (myICDRowID'=""){
						s Syndrome1=myICDRowID
					}else{
						s Syndrome2=Desc
					}
				}else{
					if (myICDRowID'=""){
						s Syndrome1=Syndrome1_"!"_myICDRowID
						s Syndrome2=Syndrome2_"!"
					}else{
						s Syndrome1=Syndrome1_"!"
						s Syndrome2=Syndrome2_"!"_Desc
					}
				}
			}
			s SyndromeDrInfo=Syndrome1_"#"_Syndrome2
			if (SyndromeDrInfo'=""){
				s SyndromeDrInfo="*"_SyndromeDrInfo
			}
			if (SyndromeDescInfo'=""){
				s SyndromeDescInfo="*"_SyndromeDescInfo
			}
			b //45
			s str=DHCMRDiaICDICDDR_SyndromeDrInfo_"^"_DHCMRDiaICDICDDesc_SyndromeDescInfo_"^"_DHCMRDiaICDRowid_"^"_DHCMRDiaICDICDNotes_"^"_SDSTermDR_"^"_SDSDisplayIDStr_"^"_DHCMRDiaICDICDType
			if (DHCMRDiaICDICDDesc'=""){
				if RetStr'="" {
					Set RetStr=RetStr_$c(1)_str
				}else{
					Set RetStr=str
				}
			}else{
			}
    	}
    }
	Q RetStr
}

ClassMethod GetOneICD(MASTERDR As %String) As %String
{
  //{MR_Adm.MRADM_RowId} "DIA" {MRDIA_Childsub} MRDIA_ICDCode_DR 1 
	s MRDIAICDCodeDR=""
    q:$P(MASTERDR,"||",2)="" MRDIAICDCodeDR
    s MRDIAICDCodeDR=$P($G(^MR($P(MASTERDR,"||",1),"DIA",$P(MASTERDR,"||",2))),"^",1)
    q MRDIAICDCodeDR
}

ClassMethod GetHistoryMRDiagnoseList(PatientID As %String, ICDType As %String, CurDep As %String = "") As %String
{
	Set RetStr=""
	Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:GetHistoryMRDiagnose")
	d obj.Execute(PatientID,"All",CurDep)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("Desc")
	.s Rowid=obj.Data("Rowid")
	.s MRDesc=obj.Data("MRDesc")
	.s DoctDesc=obj.Data("DoctDesc")
	.s MRDate=obj.Data("MRDate")
	.s MRtime=obj.Data("MRtime")
	.s MRDIADr=obj.Data("MRDIADr")
	.s MainMRDIADr=obj.Data("MainMRDIADr")
	.i MainMRDIADr'="" d
	..s Desc="&nbsp&nbsp"_Desc
	.;w Desc_"^"_Rowid_"^"_MRDesc_"^"_DoctDesc_"^"_MRDate_"^"_MRtime_"^"_MRDIADr,!
	.s OneMrDiaInfo=Desc_"^"_Rowid_"^"_MRDesc_"^"_DoctDesc_"^"_MRDate_"^"_MRtime_"^"_MRDIADr_"^"_MainMRDIADr
	.If RetStr'="" Set RetStr=RetStr_$c(1)_OneMrDiaInfo
	.if RetStr="" Set RetStr=OneMrDiaInfo
	d obj.Close()
	q RetStr
}

ClassMethod GetHistoryMRDiagnoseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHistoryMRDiagnoseExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetHistoryMRDiagnoseExecute(ByRef qHandle As %Binary, PatientID As %String, ICDType As %String = "", CurDep As %String = "") As %Status
{
	s ^gry("GetHistoryMRDiagnose")=PatientID_","_ICDType_","_CurDep
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosNew","GetHistoryMRDiagnose",334,"",167)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s desc="",rowid="",mrdesc=""
	if (PatientID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	k ^CacheTemp($J,"HistoryMRDiagnose")
	k ^TMPMRDiagPDesc($j)
	k ^TMPSortHisMRDiag($J)
	s InGroupStr=""
	s Paadmtype=0  f  s Paadmtype=$o(^PAPERdr(PatientID,"ADM",Paadmtype)) q:Paadmtype=""  d
    .s PaadmRowid=0 f  s PaadmRowid=$o(^PAPERdr(PatientID,"ADM",Paadmtype,PaadmRowid)) q:PaadmRowid=""  d
	..s MradmRowid=$P(^PAADM(PaadmRowid),"^",61)
	..s MrICDSub=0  f  s MrICDSub=$o(^MR(MradmRowid,"DIA",MrICDSub)) q:MrICDSub=""  d
	...Q:$g(^MR(MradmRowid,"DIA",MrICDSub))=""
	...s DiagPRowId=$o(^MRi("DIAGP",MradmRowid_"||"_MrICDSub,"")) //诊断属性表ID
	...s AdmDepId=$P($g(^PAADM(PaadmRowid)),"^",4) 
	...s ICDRowid=$p(^MR(MradmRowid,"DIA",MrICDSub),"^",1)
	...s MainMRDIADr=$P($g(^MR(MradmRowid,"DIA",MrICDSub)),"^",15)
	...s doctorRowid=$p(^MR(MradmRowid,"DIA",MrICDSub),"^",4)
	...s DoctDesc=""
	...i doctorRowid'="" S DoctDesc=$P($G(^CTPCP(doctorRowid,1)),"^",2)
	...s MRDate=$p($g(^MR(MradmRowid,"DIA",MrICDSub)),"^",7)
	...if MRDate'="" set MRDate=..%ZD(MRDate) //$zd(MRDate,3)
	...s MRtime=$p($g(^MR(MradmRowid,"DIA",MrICDSub)),"^",8)
	...if MRtime'="" Set MRtime=..%ZT(MRtime,3)
	...;if ICDRowid="" q
	...s desc="",BillFlag3="",mrdesc=""
	...if ICDRowid'="" s desc=$p($g(^MRC("ID",ICDRowid)),"^",2)
	...s ICDCommSub=0
	...s ICDCommSub=$o(^MR(MradmRowid,"DIA",MrICDSub,"DES",ICDCommSub))
	...if ICDCommSub'="" s mrdesc=$p(^MR(MradmRowid,"DIA",MrICDSub,"DES",ICDCommSub),"^",1)
	...if ICDRowid'="" s BillFlag3=$p($g(^MRC("ID",ICDRowid)),"^",15)
	...s rowid=ICDRowid
	...s DKBBCDiaDr=##class(web.DHCMRDiagnos).GetDKBDiagRowId(DiagPRowId)
	...i DKBBCDiaDr'="" s rowid=DKBBCDiaDr
	...Q:(ICDType="1")&&(BillFlag3'="Y")&&(ICDType'="All")
	...Q:(ICDType'="1")&&(BillFlag3="Y")&&(ICDType'="All")
	...;W AdmDepId_","_DoctDesc_","_MRDate,!
	...i (CurDep'="")&(CurDep=AdmDepId) s AdmDepId="0"
	...e  s AdmDepId="1"
	...s MRDIAMRDIADR=$p($g(^MR(MradmRowid,"DIA",MrICDSub)),"^",15)
	...s DiagnosLeavel=$P($G(^MR(MradmRowid,"DIA",MrICDSub,"EPR")),"^",1) //取诊断级别
	...i DiagPRowId'="" s desc=##class(web.DHCMRDiagnosNew).GetDiagFormateDesc(DiagPRowId),DigPDesc=desc
	...s banlkSpace="" f i=1:1:(+DiagnosLeavel-1) s banlkSpace=banlkSpace_"&nbsp&nbsp&nbsp&nbsp" ;根椐级别加空格
    ...s desc=banlkSpace_desc
    ...s desc=##class(web.DHCDocUtil).EvalJSON(desc)
    ...s GroupICDRowIDStr=##Class(web.DHCMRDiagnos).GetGroupICDRowIDStr(MradmRowid_"||"_MrICDSub)
    ...s GroupMRDiaStr=##Class(web.DHCMRDiagnos).GetGroupMRDia(MradmRowid_"||"_MrICDSub)
    ...s MainDiagnosRowid=$P(^MR(MradmRowid,"DIA",MrICDSub),"^",15)
    ...//w MradmRowid_"||"_MrICDSub_","_GroupMRDiaStr_","_GroupICDRowIDStr_","_InGroupStr,!
    ...;判断的重复的诊断
	...i GroupICDRowIDStr'="" d
	....i ('$D(^CacheTemp($J,"HistoryMRDiagnose",GroupICDRowIDStr)))||(InGroupStr[(MradmRowid_"||"_MrICDSub)) d
	.....s ^CacheTemp($J,"HistoryMRDiagnose",GroupICDRowIDStr)=""
	.....s:InGroupStr'[GroupMRDiaStr InGroupStr=InGroupStr_"^"_GroupMRDiaStr
	.....s ^TMPSortHisMRDiag($J,AdmDepId,+..%ZDH(MRDate),MradmRowid_"||"_MrICDSub)=$lb(rowid,desc,mrdesc,DoctDesc,MRDate,MRtime,MradmRowid_"||"_MrICDSub,MainMRDIADr,DiagPRowId)
	.....;d OutputRow4
	...e  i DiagPRowId'="",DigPDesc'="" d
	....i '$d(^TMPMRDiagPDesc($j,DigPDesc)) d 
	.....s ^TMPMRDiagPDesc($j,DigPDesc)=1
	.....s ^TMPSortHisMRDiag($J,AdmDepId,+..%ZDH(MRDate),MradmRowid_"||"_MrICDSub)=$lb(rowid,desc,mrdesc,DoctDesc,MRDate,MRtime,MradmRowid_"||"_MrICDSub,MainMRDIADr,DiagPRowId)
	...e  d
	....s ^TMPSortHisMRDiag($J,AdmDepId,+..%ZDH(MRDate),MradmRowid_"||"_MrICDSub)=$lb(rowid,desc,mrdesc,DoctDesc,MRDate,MRtime,MradmRowid_"||"_MrICDSub,MainMRDIADr,DiagPRowId)
	....;d OutputRow4
	b //45
	s loc=""
	f  s loc=$O(^TMPSortHisMRDiag($J,loc)) q:loc=""  d
	.s Date=""
	.f  s Date=$O(^TMPSortHisMRDiag($J,loc,Date),-1) q:Date=""  d
	..s Id=""
	..f  s Id=$O(^TMPSortHisMRDiag($J,loc,Date,Id)) q:Id=""  d
	...s Data=$g(^TMPSortHisMRDiag($J,loc,Date,Id))
	...s ^CacheTemp(repid,ind)=Data
	...s ind=ind+1
	
	k ^CacheTemp($J,"HistoryMRDiagnose")
	k ^TMPSortHisMRDiag($J)
	k ^TMPMRDiagPDesc($j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow4
	set Data=$lb(rowid,desc,mrdesc,DoctDesc,MRDate,MRtime,MRDIADr,MainMRDIADr,DiagPRowId)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod GetHistoryMRDiagnoseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHistoryMRDiagnoseExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query GetHistoryMRDiagnose(PatientID As %String, ICDType As %String = "", CurDep As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "Rowid:%String,Desc:%String,MRDesc:%String,DoctDesc:%String,MRDate:%String,MRtime:%String,MRDIADr:%String,MainMRDIADr:%String,DiagPRowId:%String")
{
}

ClassMethod HisMRDiagRepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = HisMRDiagRepExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// 2075 9||6

ClassMethod HisMRDiagRepExecute(ByRef qHandle As %Binary, PatientID As %String, ICDCodeRowId As %String, MRDIADr As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	k ^CacheTemp($J,"HistoryMRDiagnose")
	k ^TMPSortHisMRDiagRep($J)
	
	s GroupICDRowIDStr=""
	if (MRDIADr'=""){
		s GroupICDRowIDStr=##Class(web.DHCMRDiagnos).GetGroupICDRowIDStr(MRDIADr)
		s RepeatMRDesc=""
		s DiagPRowId=$o(^MRi("DIAGP",MRDIADr,""))
	    s DKBBCDiaDr=##class(web.DHCMRDiagnos).GetDKBDiagRowId(DiagPRowId)
	    i DKBBCDiaDr'="" s RepeatMRDesc=##class(web.DHCMRDiagnosNew).GetDiagFormateDesc(DiagPRowId)
	}
	
	s desc="",rowid="",mrdesc=""
	s Paadmtype=0  f  s Paadmtype=$o(^PAPERdr(PatientID,"ADM",Paadmtype)) q:Paadmtype=""  d
    .s PaadmRowid=0 f  s PaadmRowid=$o(^PAPERdr(PatientID,"ADM",Paadmtype,PaadmRowid)) q:PaadmRowid=""  d 
	..s MradmRowid=$P(^PAADM(PaadmRowid),"^",61)
	..s AdmDep=$P(^PAADM(PaadmRowid),"^",4)
	..i AdmDep'="" s AdmDep=$p($g(^CTLOC(AdmDep)),"^",2)
	..i $l(AdmDep,"-")=2 s AdmDep=$p(AdmDep,"-",2)
	..s MrICDSub=0  f  s MrICDSub=$o(^MR(MradmRowid,"DIA",MrICDSub)) q:MrICDSub=""  d
	...s ICDRowid=$p(^MR(MradmRowid,"DIA",MrICDSub),"^",1)
	...;s doctorRowid=$p(^MR(MradmRowid,"DIA",MrICDSub),"^",12)
	...s doctorRowid=$p(^MR(MradmRowid,"DIA",MrICDSub),"^",4)
	...s DoctDesc=""
	...i doctorRowid'="" S DoctDesc=$P($G(^CTPCP(doctorRowid,1)),"^",2)
	...s MRDate=$p($g(^MR(MradmRowid,"DIA",MrICDSub)),"^",7)
	...if MRDate'="" set MRDate=..%ZD(MRDate) //$zd(MRDate,3)
	...s MRtime=$p($g(^MR(MradmRowid,"DIA",MrICDSub)),"^",8)
	...if MRtime'="" Set MRtime=..%ZT(MRtime,3)
	...s desc="",BillFlag3="",mrdesc=""
	...if ICDRowid'="" s desc=$p($g(^MRC("ID",ICDRowid)),"^",2)
	...s ICDCommSub=0
	...s ICDCommSub=$o(^MR(MradmRowid,"DIA",MrICDSub,"DES",ICDCommSub))
	...if ICDCommSub'="" s mrdesc=$p(^MR(MradmRowid,"DIA",MrICDSub,"DES",ICDCommSub),"^",1)
	...if ICDRowid'="" s BillFlag3=$p($g(^MRC("ID",ICDRowid)),"^",15)
	...s rowid=ICDRowid
	...s SubGroupICDRowIDStr=##Class(web.DHCMRDiagnos).GetGroupICDRowIDStr(MradmRowid_"||"_MrICDSub)
	...;Q:(ICDType="1")&&(BillFlag3'="Y")
	...;Q:(ICDType'="1")&&(BillFlag3="Y")
	...s DiagPRowId=$o(^MRi("DIAGP",MradmRowid_"||"_MrICDSub,""))
	...s DKBBCDiaDr=##class(web.DHCMRDiagnos).GetDKBDiagRowId(DiagPRowId)
	...i DKBBCDiaDr'="" s desc=##class(web.DHCMRDiagnosNew).GetDiagFormateDesc(DiagPRowId)
	...Q:(rowid="")&&(DKBBCDiaDr="")
	...Q:(GroupICDRowIDStr="")&&(ICDCodeRowId'="")&&(ICDCodeRowId'=rowid)&&(rowid'="")
	...Q:(GroupICDRowIDStr="")&&(ICDCodeRowId'="")&&(ICDCodeRowId'=DKBBCDiaDr)&&(DiagPRowId'="")
	...Q:(desc'=RepeatMRDesc)&&(DiagPRowId'="")
	...Q:(GroupICDRowIDStr'="")&&(SubGroupICDRowIDStr'=GroupICDRowIDStr)
	...s ^TMPSortHisMRDiagRep($J,+..%ZDH(MRDate),MrICDSub)=$lb(rowid,desc,mrdesc,DoctDesc,MRDate,MRtime,AdmDep)
	...;d OutputRow4
	
	s Date=""
	f  s Date=$O(^TMPSortHisMRDiagRep($J,Date),-1) q:Date=""  d
	.s Id=""
	.f  s Id=$O(^TMPSortHisMRDiagRep($J,Date,Id)) q:Id=""  d
	..s Data=$g(^TMPSortHisMRDiagRep($J,Date,Id))
	..s ^CacheTemp(repid,ind)=Data
	..s ind=ind+1
	
	k ^CacheTemp($J,"HistoryMRDiagnose")
	k ^TMPSortHisMRDiagRep($J)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(rowid,desc,mrdesc,DoctDesc,MRDate,MRtime,AdmDep)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod HisMRDiagRepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = HisMRDiagRepExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {			// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	}
	Else {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query HisMRDiagRep(PatientID As %String, ICDCodeRowId As %String, MRDIADr As %String = "") As %Library.Query(CONTAINID = 0, ROWSPEC = "Rowid:%String,Desc:%String,MRDesc:%String,DoctDesc:%String,MRDate:%String,MRtime:%String,AdmDep:%String")
{
}

/// wanghc 2012-1-14
ClassMethod GetMRDiagnoseListJson(MRADMID As %Library.String = "", ICDType As %String = "")
{
	
	Set RetStr="",NO=1
	k ^TempDiagnos($J)
	k TempArr("FindDiagnosJson",$J)
	s ^UU=MRADMID_"^"_ICDType
	Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MRADMID)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s DiagPRowId=$o(^MRi("DIAGP",Rowid,""))
	.i DiagPRowId'="" s Desc=##class(web.DHCMRDiagnosNew).GetDiagFormateDesc(DiagPRowId)
	.s MRDiagnosTypeDesc=""
	.s MRDiagnosTypeDr=""
	.S MRdiagnosNoteDr=""
	.S MRdiagnosNoteDesc=""
	.s MRdiagnosNoteSubRowid=""
	.S SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
	.if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
	.I MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
	.S MRdiagnosNoteSubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",0))
	.I MRdiagnosNoteSubRowid'="" Set MRdiagnosNoteDesc=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",MRdiagnosNoteSubRowid))
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRCIDCode=obj.Data("MRDIAICDCodeDRCode")
	.S MRDiagnosDate=obj.Data("MRDIADate")
	.s MRdiagnosTime=obj.Data("MRDIATime")
	.I MRDiagnosDate'="" Set MRDiagnosDate=..%ZD(MRDiagnosDate) //$zd(MRDiagnosDate,3)
	.I MRdiagnosTime'="" Set MRdiagnosTime=..%ZT(MRdiagnosTime,3)
	.;q:CodeRowid=""
	.s BillFlag3="" 
	.;Q:'$D(^MRC("ID",CodeRowid))
	.s BillFlag3=""
	.i CodeRowid'="" s BillFlag3=$P(^MRC("ID",CodeRowid),"^",15)
	.Q:(ICDType="1")&&(BillFlag3'="Y")&&(ICDType'="ALL")
	.Q:(ICDType'="1")&&(BillFlag3="Y")&&(ICDType'="ALL")
	.s MRDesc=obj.Data("MRDIADesc")
	.if (MRDesc'="")&&($$$ISOK($LV(MRDesc))) s MRDesc=$ListToString(MRDesc,"、")
	.s DiagStat=""
	.s DiagStatDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",9)
	.s DiagnosLeavel=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",1) //取诊断级别
	.s DiagnosNumber=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",2) //取顺序号
	.if DiagStatDr'="" s DiagStat=$p($g(^MRC("DSTAT",DiagStatDr)),"^",2)
    .s banlkSpace="" f i=1:1:+DiagnosLeavel s banlkSpace=banlkSpace_"&nbsp&nbsp&nbsp&nbsp;"	;根椐级别加空格
    .//s jsonitem="{Desc:'"_banlkSpace_Desc_MRDesc_"',Rowid:'"_Rowid_"',CodeRowid:'"_CodeRowid_"',MRDesc:'"_MRDesc_"',MRCIDCode:'"_MRCIDCode_"',MRDiagnosTypeDesc:'"_MRDiagnosTypeDesc_"',MRdiagnosNoteDesc:'"_MRdiagnosNoteDesc_"',MRDiagnosDate:'"_MRDiagnosDate_"',MRdiagnosTime:'"_MRdiagnosTime_"',DiagStat:'"_DiagStat_"',DiagnosLeavel:'"_DiagnosLeavel_"'}"
    .s:DiagnosNumber="" DiagnosNumber=$g(^MR(+Rowid,"DIA",0))+1
	.i MRDesc'="" s Desc=Desc_"("_MRDesc_")"
	.s TempArr("FindDiagnosJson",$j,DiagnosNumber,+Rowid,$p(Rowid,"||",2))="{Desc:'"_banlkSpace_Desc_"',Rowid:'"_Rowid_"',CodeRowid:'"_CodeRowid_"',MRDesc:'"_MRDesc_"',MRCIDCode:'"_MRCIDCode_"',MRDiagnosTypeDesc:'"_MRDiagnosTypeDesc_"',MRdiagnosNoteDesc:'"_MRdiagnosNoteDesc_"',MRDiagnosDate:'"_MRDiagnosDate_"',MRdiagnosTime:'"_MRdiagnosTime_"',DiagStat:'"_DiagStat_"',DiagnosLeavel:'"_DiagnosLeavel_"'}"
	d obj.Close()
	s obj=""
	
	//按顺序输出设置
	s TempDia=""
	s DiagnosNumber=0  f  {
		s DiagnosNumber=$O(TempArr("FindDiagnosJson",$j,DiagnosNumber)) 
		Q:DiagnosNumber=""  d
		s Temprowid=0 f {
			s Temprowid=$O(TempArr("FindDiagnosJson",$j,DiagnosNumber,MRADMID,Temprowid))
			q:Temprowid=""
			i RetStr="" s RetStr=TempArr("FindDiagnosJson",$j,DiagnosNumber,MRADMID,Temprowid)
			e  s RetStr=RetStr_","_TempArr("FindDiagnosJson",$j,DiagnosNumber,MRADMID,Temprowid)
		}
	}
	k TempArr("FindDiagnosJson",$j)

	q "{rows:["_RetStr_"],results:1}"
}

/// w ##class(web.DHCDocDiagnosNew).GetMRDiagnoseList("3")
ClassMethod GetMRDiagnoseList(MRADMID As %Library.String = "", ICDType As %String = "", DiagnosTypeCode As %String = "") As %String
{
	s RetStr=""
	s rs=##class(%ResultSet).%New("web.DHCDocDiagnosEntryV8:DiagnosList")
	d rs.Execute(MRADMID,ICDType,DiagnosTypeCode)
	while rs.Next(){
		s Desc=rs.GetDataByName("DiagnosICDDesc")
		s SDSDesc=rs.GetDataByName("SDSDesc")
		s:SDSDesc'="" Desc=SDSDesc
		s Rowid=rs.GetDataByName("MRDIARowId")
		s CodeRowid=rs.GetDataByName("MRCIDRowId")
		s MRDesc=rs.GetDataByName("DiagnosNotes")
		s MRCIDCode=rs.GetDataByName("MRCIDCode")
		s MRDiagnosTypeDesc=rs.GetDataByName("DiagnosType")
		s MRdiagnosNoteDesc=rs.GetDataByName("DiagnosNotes")
		s MRDiagnosDate=rs.GetDataByName("DiagnosDate")
		s MRdiagnosTime=rs.GetDataByName("DiagnosTime")
		s DiagStat=rs.GetDataByName("DiagnosStatus")
		s DiagnosLeavel=rs.GetDataByName("DiagnosLeavel")
		s DiagnosNumber=rs.GetDataByName("id")
		s DIAOnsetDate=rs.GetDataByName("DiagnosOnsetDate")
		s DiagnosCat=rs.GetDataByName("DiagnosCat")
		s MainMRDiagnoeRowId=rs.GetDataByName("MRDIAMRDIADR")
		s oneStr=Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime
		s oneStr=oneStr_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate_"^"_DiagnosCat_"^"_MainMRDiagnoeRowId
		i RetStr="" s RetStr=oneStr
		e  s RetStr=RetStr_$c(1)_oneStr
	}
	Q RetStr
}

ClassMethod GetDiagnosType(AdmType As %String = "") As %String
{
	Set RetStr=""
	Set MRDiagnosRowid="0" f  s MRDiagnosRowid=$O(^MRC("DTYP",MRDiagnosRowid)) Q:MRDiagnosRowid=""  d
	.Set DTYPCode=$P($g(^MRC("DTYP",MRDiagnosRowid)),"^",1)
	.Set DTYPDesc=$P($g(^MRC("DTYP",MRDiagnosRowid)),"^",2)
	.Q:(AdmType'="")&&(AdmType'="I")&&((DTYPCode="DIS")||(DTYPCode="C008")) ;入院诊断,出院诊断只用于住院患者.
	.Q:(AdmType'="")&&(AdmType="I")&&(DTYPCode="OP") ;门诊诊断只用于住院患者.
	.If RetStr'="" Set RetStr=RetStr_"^"_MRDiagnosRowid_$c(1)_DTYPDesc
	.If RetStr="" Set RetStr=MRDiagnosRowid_$c(1)_DTYPDesc
	Q RetStr
}

// MRCID_Code

Query Find(mradm As %Library.String) As %Library.SQLQuery(CONTAINID = 1, ROWSPEC = "ID,mradm,MRDIAICDCodeDR,MRDIAICDCodeDRDesc,MRDIAICDCodeDRCode,MRDIADate:%Date,MRDIATime:%Time,MRDIADesc,MRDIAUpdateUserDRSSUSRName")
{
	
SELECT MRDIA_RowID, MRDIA_MRADM_ParRef, MRDIA_ICDCode_DR, MRDIA_ICDCode_DR->MRCID_Desc, MRDIA_ICDCode_DR->MRCID_ICD9CM_Code, %INTERNAL(MRDIA_Date), %INTERNAL(MRDIA_Time), $ListToString(MRDIA_Desc,"、"), MRDIA_UpdateUser_DR->SSUSR_Name
FROM SQLUser.MR_Diagnos
WHERE MRDIA_MRADM_ParRef = :mradm
}

ClassMethod GetExecuteCTLOC() As %String
{
	Set CTLOCRowid=""
	Set RetStr=""
	F  s CTLOCRowid=$O(^CTLOC(CTLOCRowid)) q:CTLOCRowid=""  d
	.Set CTLOCType=$P($G(^CTLOC(CTLOCRowid)),"^",13)
	.Q:(CTLOCType'="E")&&(CTLOCType'="EM")
	.Set CTLOCDesc=$P($G(^CTLOC(CTLOCRowid)),"^",2)
	.Q:CTLOCDesc["停用"
	.Set CTLocContactName=$P(^CTLOC(CTLOCRowid),"^",43)
	.Set CTLocContactName=$$ALPHAUP^SSUTIL4(CTLocContactName)
	.//Set CTLOCDescQuickCode=$P(CTLOCDesc,"-",1)
	.//Set CTLOCCode=$P(CTLOCDesc,"-",2)
	.If CTLOCDesc'="" d
	..//If RetStr'="" Set RetStr=RetStr_"^"_CTLOCRowid_$c(1)_CTLOCCode_"-"_CTLOCDescQuickCode
	..//If RetStr="" Set RetStr=CTLOCRowid_$c(1)_CTLOCCode_"-"_CTLOCDescQuickCode
	..If RetStr'="" Set RetStr=RetStr_"^"_CTLOCRowid_$C(1)_CTLOCDesc_"-"_CTLocContactName
	..If RetStr="" Set RetStr=CTLOCRowid_$C(1)_CTLOCDesc_"-"_CTLocContactName
	Q RetStr
}

ClassMethod GetCTLocTemplet(CTlocRowid As %String) As %String
{
	If CTlocRowid="" Q "User Null"
	Set Str="",IndexNum=0
	Set DHCDIAINDEX="" f  s DHCDIAINDEX=$O(^DHCDIAMAS("CTLOC",CTlocRowid,DHCDIAINDEX)) q:DHCDIAINDEX=""  d
	.Set DHCDIAMASRowid="" f  s DHCDIAMASRowid=$O(^DHCDIAMAS("CTLOC",CTlocRowid,DHCDIAINDEX,DHCDIAMASRowid)) q:DHCDIAMASRowid=""  d
	..Set DHCDIADESC=$P(^DHCDIAMAS(DHCDIAMASRowid),"^",2)
	..Set UserRowid=$P($g(^DHCDIAMAS(DHCDIAMASRowid)),"^",4)
	..Set UserDesc="" If UserRowid'="" Set UserDesc=$P($G(^SSU("SSUSR",UserRowid)),"^",2)
	..If DHCDIADESC'="" Set IndexNum=IndexNum+1
	..If Str'="" Set Str=Str_$c(1)_DHCDIAMASRowid_"^"_DHCDIADESC_"  "_UserDesc
	..if Str="" Set Str=DHCDIAMASRowid_"^"_DHCDIADESC_"  "_UserDesc
	Q Str_$c(2)_IndexNum
}

ClassMethod CTLocAddToPrivate(CTLocTempletRowid As %String, USERID As %String, LogonHospId As %String = "") As %String
{
  if CTLocTempletRowid="" Q "CTLocTempletRowid null"
  Set DHCDIADESC=$P(^DHCDIAMAS(CTLocTempletRowid),"^",2)
  If DHCDIADESC="" Q "CTLocTempletDesc null"
  s LogonHospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(LogonHospId)
  &sql(select count(MASTERRowid) into:count from SQLUSER.DHC_MRDiagnosMaster where DHCDIADESC=:DHCDIADESC and DHCDIAUSER=:USERID and DHCDIAHospDr=:LogonHospId)
  if (count>0){
	  Q "记录重复!"
  }
  s MaxIndex=+$o(^DHCDIAMAS("USER",USERID,LogonHospId,""),-1)+1
  TStart
  s object=##class(User.DHCMRDiagnosMaster).%New()
  S object.DHCDIADESC=DHCDIADESC
  s object.DHCDIAINDEX=MaxIndex
  d object.DHCDIAUSERSetObjectId(USERID)
  d object.DHCDIAHospDrSetObjectId(LogonHospId)
  Set sc = object.%Save()
	If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		TRollback
		Q ""
  }
  d object.%Close()
  Set DHCMRDiaICDNewRowid=object.%Id()
  Set MasterRowid=CTLocTempletRowid
  Set DHCMRDiaICDListNumrowid="" f  s DHCMRDiaICDListNumrowid=$O(^DHCDIAICD("MASTER",MasterRowid,DHCMRDiaICDListNumrowid)) q:DHCMRDiaICDListNumrowid=""  d
  .Set DHCMRDiaICDListIndexRowid="" f  s DHCMRDiaICDListIndexRowid=$O(^DHCDIAICD("MASTER",MasterRowid,DHCMRDiaICDListNumrowid,DHCMRDiaICDListIndexRowid)) Q:DHCMRDiaICDListIndexRowid=""  d
  ..Set DHCMRDiaICDRowid=""  s DHCMRDiaICDRowid=$O(^DHCDIAICD("MASTER",MasterRowid,DHCMRDiaICDListNumrowid,DHCMRDiaICDListIndexRowid,""))  
  ..Set MASTERDR=$P($G(^DHCDIAICD(DHCMRDiaICDRowid)),"^",2)
  ..Set DHCMRDiaICDICDDR=$P($G(^DHCDIAICD(DHCMRDiaICDRowid)),"^",3)
  ..Set DHCMRDiaICDListNum=$P($G(^DHCDIAICD(DHCMRDiaICDRowid)),"^",4)
  ..Set DHCMRDiaICDListIndex=$P($G(^DHCDIAICD(DHCMRDiaICDRowid)),"^",5)
  ..Set DHCMRDiaICDDesc=$P($G(^DHCDIAICD(DHCMRDiaICDRowid)),"^",6)
  ..Set DHCMRDiaICDSyndromeICDInfo=$P($G(^DHCDIAICD(DHCMRDiaICDRowid)),"^",7)
  ..Set DHCMRDiaICDNotes=$P($G(^DHCDIAICD(DHCMRDiaICDRowid)),"^",8)
  ..;w DHCMRDiaICDNewRowid_"^"_DHCMRDiaICDICDDR_"^"_DHCMRDiaICDListNum_"^"_DHCMRDiaICDListIndex,!
  ..if ((DHCMRDiaICDICDDR'="")||(DHCMRDiaICDDesc'=""))&(DHCMRDiaICDListNum'="")&(DHCMRDiaICDListIndex'="") Do Insert
  TC
  Q DHCMRDiaICDNewRowid
 
Insert
  ;w DHCMRDiaICDNewRowid_"^"_DHCMRDiaICDICDDR_"^"_DHCMRDiaICDListNum_"^"_DHCMRDiaICDListIndex,!
  s object=##class(User.DHCMRDiagnosICD).%New()
  s object.DHCMRDiaICDListNum=DHCMRDiaICDListNum
  s object.DHCMRDiaICDListIndex=DHCMRDiaICDListIndex
  d object.DHCMRDiaICDMASTERDRSetObjectId(DHCMRDiaICDNewRowid)
  if (DHCMRDiaICDICDDR'="") d object.DHCMRDiaICDICDDRSetObjectId(DHCMRDiaICDICDDR)
  s object.DHCMRDiaICDDesc=DHCMRDiaICDDesc
  s object.DHCMRDiaICDSyndromeICDInfo=DHCMRDiaICDSyndromeICDInfo
  s object.DHCMRDiaICDNotes=DHCMRDiaICDNotes
  s sc=object.%Save()  
  If $$$ISERR(sc) {
		Do $System.Status.DisplayError()
		TRollback
		Q "DHCMRDiaICDMASTERDR Error"}
 d object.%Close()
 Quit
}

ClassMethod AddToCTLocTemplet(MasterRowid As %String, CTLocRwoid As %String) As %String
{
	if MasterRowid="" Q "MasterRowid null"
	if CTLocRwoid="" Q "CTLocRwoid null"
	&sql(update SQLUSER.DHC_MRDiagnosMaster Set DHCDIALOC=:CTLocRwoid where MASTERRowid=:MasterRowid)
	Q SQLCODE
}

// LPD

ClassMethod DelFromCTLocTemplet(MasterRowid As %String, CTLocRwoid As %String) As %String
{
	if MasterRowid="" Q "MasterRowid null"
	&sql(update SQLUSER.DHC_MRDiagnosMaster Set DHCDIALOC=NULL where MASTERRowid=:MasterRowid and DHCDIALOC=:CTLocRwoid)
	Q SQLCODE
}

// 本次就诊诊断是否重复标识返回

/// w ##Class(web.DHCDocDiagnosNew).FlagMarchDiagnose(50,1,5)
ClassMethod FlagMarchDiagnose(MRADMID As %Library.String = "", ChoseDiagnosisId As %String = "", MRDiagnosTypeDr As %String = "") As %String
{
	s ^tempscl("FlagMarchDiagnose")=MRADMID_","_ChoseDiagnosisId_","_MRDiagnosTypeDr
   //当为2时为非标准化icd ，为1时为标准化icd重复，为0时为没有重复的非标准化icd
    //s UseDKBFlag=..%GetConfig("UseDDiagnosKB")
	if ChoseDiagnosisId="" s RetStr=2 q RetStr
	Set RetStr=0
	Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MRADMID)
	For  Quit:'obj.Next()  Do
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRDiagRowId=obj.Data("ID")
	.s DiagPRowId=$o(^MRi("DIAGP",MRADMID_"||"_$p(MRDiagRowId,"||",2),""))
	.b //45
	.q:(CodeRowid="")&&(DiagPRowId="")
	.q:(ChoseDiagnosisId'=CodeRowid)&&(DiagPRowId="")
	.s DKBBCDiaDr=##class(web.DHCMRDiagnos).GetDKBDiagRowId(DiagPRowId)
	.q:(DKBBCDiaDr'=ChoseDiagnosisId)&&(DiagPRowId'="")
	.;-------------------------------
	.s ID=obj.Data("ID")
	.s SubRowid=$G(^MR($P(ID,"||",1),"DIA",$P(ID,"||",2),"TYP",0))
	.s DiagTypeDr=""
	.s DiagTypeDesc=""
	.if SubRowid'="" s DiagTypeDr=$G(^MR($P(ID,"||",1),"DIA",$P(ID,"||",2),"TYP",SubRowid))
	.i DiagTypeDr'="" s DiagTypeDesc=$P($G(^MRC("DTYP",DiagTypeDr)),"^",2)
	.q:(MRDiagnosTypeDr'="")&&(MRDiagnosTypeDr'=DiagTypeDr)
	.;-------------------------
	.s RetStr=1
	.break
	d obj.Close()
	q RetStr
}

/// Modify:WangQingyong 改为表存储 并记录日志
ClassMethod UpdateMRDiagnos(MRDiagnoeRowId As %String, info As %String) As %String
{
	;s ^Wqy("UpdateMRDiagnos",$I(^Wqy("UpdateMRDiagnos")))=$LB(MRDiagnoeRowId,info)
	s MRADMRowId=+MRDiagnoeRowId
	s MRDIAChildsub=$P(MRDiagnoeRowId,"||",2)
	s Level=$P(info,"^",1)
	s Sequence=$P(info,"^",2)
	s MainMRDiagnoeRowId=$P($g(^MR(MRADMRowId,"DIA",MRDIAChildsub)),"^",15)
	s SQLCODE=0
	set OldDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.MRDiagnos"_$c(2)_MRDiagnoeRowId)
	TS
	;s $P(^MR(MRADMRowId,"DIA",MRDIAChildsub,"EPR"),"^",1)=Level
	&SQL(UPDATE SQLUser.MR_Diagnos SET MRDIA_Level=:Level WHERE MRDIA_RowId=:MRDiagnoeRowId)
	;子诊断跟着主诊断走
	if 'SQLCODE&&(MainMRDiagnoeRowId=""){ 
		;s $P(^MR(MRADMRowId,"DIA",MRDIAChildsub,"EPR"),"^",2)=Sequence
		&SQL(UPDATE SQLUser.MR_Diagnos SET MRDIA_Sequence=:Sequence WHERE MRDIA_RowId=:MRDiagnoeRowId)
		if 'SQLCODE{
			if (MainMRDiagnoeRowId="") s MainMRDiagnoeRowId=MRDiagnoeRowId
			s sub=0 for {
				s sub=$O(^MR(MRADMRowId,"DIA",0,"Link",MainMRDiagnoeRowId,sub)) Q:sub=""
				s DiagID=MRADMRowId_"||"_sub
				&SQL(UPDATE SQLUser.MR_Diagnos SET MRDIA_Sequence=:Sequence WHERE MRDIA_RowId=:DiagID)
				Q:SQLCODE
			}
		}
	}
	if 'SQLCODE{
		;医生站业务数据修改日志
		s NewDataJson=##class(web.DHCDocDataChangeLog).GetLogJsonData("User.MRDiagnos"_$c(2)_MRDiagnoeRowId)
		s SQLCODE=##class(web.DHCDocDataChangeLog).SaveLog("MR_Diagnos","User.MRDiagnos","诊断信息","User.MRDiagnos_"_MRDiagnoeRowId,MRDiagnoeRowId,"U",NewDataJson,OldDataJson)
	}
	if SQLCODE TRO
	else  TC
	Q SQLCODE
}

/// /---中医诊断证
/// 获取患者对应诊断所对应的证
/// d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosNew","FindSynd","传染科","78||2",63)
Query FindSynd(SynDesc As %String, MRDiagnoeRowId As %String, CTLoc As %String) As %Query(ROWSPEC = "Num:%String,DSYMDesc:%String,DSYMDr:%String,LinkFlag:%String")
{
}

ClassMethod FindSyndExecute(ByRef qHandle As %Binary, SynDesc As %String, MRDiagnoeRowId As %String, CTLoc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Num=1
 	s MradmRowid=+MRDiagnoeRowId
 	s MrICDSub=+$P(MRDiagnoeRowId,"||",2)
 	s SynDesc=$tr(SynDesc," ")
 	s SynDesc=$ZCVT(SynDesc,"U")
 	s LenDesc=$L(SynDesc)
 	s RtnHaveSyn="" ;已经选择关联的证
 	s ICDRowid=""
 	i MrICDSub'=0  d
 	.s ICDRowid=$p(^MR(MradmRowid,"DIA",MrICDSub),"^",1)
 	.s RtnHaveSyn=..GetDiaSynd(MRDiagnoeRowId)
 	.s Rtn=$$GetDiahaveSys(RtnHaveSyn)
 	if ICDRowid'=""  d
 	.s RowID=0
 	.f  s RowID=$O(^DHCDocSyndLink(0,"MRCICDDX",ICDRowid,RowID)) Q:RowID=""  d
 	..s SyndRowid=$p(^DHCDocSyndLink(RowID),"^",1)
 	..s DescOut=""
 	..i SyndRowid'=""  d
 	...s DescOut=$p($g(^MRC("DSYM",SyndRowid)),"^",2)
 	...s Active=$p($g(^MRC("DSYM",SyndRowid)),"^",7)
 	...Q:Active'="Y"
 	...s StDate=$p($g(^MRC("DSYM",SyndRowid)),"^",5)
 	...Q:(StDate>+$H)&&(StDate'="")
 	...s EnDate=$p($g(^MRC("DSYM",SyndRowid)),"^",6)
 	...Q:(EnDate<+$H)&&(EnDate'="")
 	...s UserLoc=$p($g(^MRC("DSYM",SyndRowid)),"^",3)
 	...Q:(CTLoc'=UserLoc)&&(UserLoc'="")&&(CTLoc'="")
 	...s FlagFind="Y"
 	...i SynDesc'=""  d
 	....s FlagFind="N"
 	....s DescOut2=$E($ZCVT(DescOut,"U"),1,LenDesc)
 	....s:(DescOut2=SynDesc)&&(SynDesc'="") FlagFind="Y"
 	....s SubDr=0
 	....f  s SubDr=$O(^MRC("DSYM",SyndRowid,"ALIAS",SubDr)) Q:(SubDr="")||(FlagFind="Y")  d
 	.....s SubDesc=$G(^MRC("DSYM",SyndRowid,"ALIAS",SubDr))
 	.....Q:SubDesc=""
 	.....s SubDesc1=$E($ZCVT(SubDesc,"U"),1,LenDesc)
 	.....i SubDesc1=SynDesc  d
 	......s FlagFind="Y"
 	...Q:FlagFind'="Y"
 	...s DSYMDesc=DescOut
 	...s DSYMDr=SyndRowid
 	...//Q:("^"_RtnHaveSyn_"^")[("^"_DSYMDr_"^")  ;关联过的在前边输出
 	...s LinkFlag=0
 	...i ("^"_RtnHaveSyn_"^")[("^"_DSYMDr_"^") s LinkFlag=1
	...Do OutputRow
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Num,DSYMDesc,DSYMDr,LinkFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	s Num=Num+1
 	Set ind=ind+1
	quit
GetDiahaveSys(RtnHaveSyn)
	;先输出已经存在关联
	s RtnLen=$L(RtnHaveSyn,"^")
	for j=1:1:RtnLen
	{	s DSYMDr=$P(RtnHaveSyn,"^",j)
		Continue:DSYMDr=""
		s DSYMDesc=$p($g(^MRC("DSYM",DSYMDr)),"^",2)
		s LinkFlag=1
		//Do OutputRow
	}
	q 1
}

ClassMethod FindSyndFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindSyndExecute ]
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

ClassMethod FindSyndClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindSyndExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 确认诊断是否属于中医诊断
/// input  MRDiagnoeRowId 诊断ID
/// Out  "Y" 中医诊断  "N" 非中医诊断
ClassMethod GetZYMRDiagnosFlag(MRDiagnoeRowId As %String) As %String
{
	s FlagZY="N"
	s MRADMRowId=+MRDiagnoeRowId
	s MRDIAChildsub=+$P(MRDiagnoeRowId,"||",2)
	Q:MRDIAChildsub=0 FlagZY
	s ICDRowid=""
	s:MRDIAChildsub'=0 ICDRowid=$p($g(^MR(MRADMRowId,"DIA",MRDIAChildsub)),"^",1)
	Q:ICDRowid="" FlagZY
	s BillFlag3=$p($g(^MRC("ID",ICDRowid)),"^",15)
	S:BillFlag3="Y" FlagZY="Y"
	q FlagZY
}

/// 插入诊断对应的证
/// input Adm 就诊ID MRDiagnoeRowId诊断ID SyndStr证ID串用^分割
/// OutPut 0成功 Other 失败
ClassMethod InsertDiaSynd(Adm As %String, MRDiagnoeRowId As %String, SyndStr As %String, UserDr As %String, NewSynStr As %String) As %String
{
	s NowDate=..%SysDate()
	s NowTime=..%SysTime()
	s Rtn=0
	Q:(Adm="")||(MRDiagnoeRowId="")||(UserDr="") -1
	s SyndSignStr=""
	s SyndRowid=""
	f  s SyndRowid=$o(^DHCDocSYND("0","ADM",Adm,SyndRowid)) q:SyndRowid=""  d
	.s SyndMRDiagDR=$p(^DHCDocSYND(SyndRowid),"^",1)
	.q:SyndMRDiagDR'=MRDiagnoeRowId
	.s SyndSign=$p(^DHCDocSYND(SyndRowid),"^",6)
	.i SyndSignStr="" s SyndSignStr=SyndSign
	.e  s SyndSignStr=SyndSignStr_"^"_SyndSign
	&SQL(delete from SQLUser.DHC_DocSyndDiff where Synd_MRDiag_DR=:MRDiagnoeRowId)
	if (SyndStr=""){
		q:SyndSignStr="" 0
		for i=1:1:$l(SyndSignStr,"^"){
			s OneSyndSign=$p(SyndSignStr,"^",i)
			if ("^"_OneSyndSign_"^")[("^"_SyndStr_"^"){
			  	&SQL(insert into SQLUser.DHC_DocSyndDiff (Synd_Adm_DR,Synd_MRDiag_DR,Synd_Sign,Synd_User_DR,Synd_Date,Synd_Time)
		         values (:Adm,:MRDiagnoeRowId,:OneSyndSign,:UserDr,:NowDate,:NowTime))
		         s Rtn=SQLCODE
		       i (Rtn'=0) q
			}else{
				if ("^"_NewSynStr_"^")'[("^"_OneSyndSign_"^"){
					     &SQL(insert into SQLUser.DHC_DocSyndDiff (Synd_Adm_DR,Synd_MRDiag_DR,Synd_Sign,Synd_User_DR,Synd_Date,Synd_Time)
		                values (:Adm,:MRDiagnoeRowId,:OneSyndSign,:UserDr,:NowDate,:NowTime))
		                s Rtn=SQLCODE
		             i (Rtn'=0) q
				}
			}
			//if (("^"_OneSyndSign_"^")'[("^"_SyndStr_"^"))&&(("^"_OneSyndSign_"^")[("^"_NewSynStr_"^")){
			//}
		}
	}else{
		if (SyndSignStr=""){
			s LenSyn=$l(SyndStr,"^")
		    for i=1:1:LenSyn 
	        {
		      s SynDr=$P(SyndStr,"^",i)
		      Continue:SynDr=""
		       &SQL(insert into SQLUser.DHC_DocSyndDiff (Synd_Adm_DR,Synd_MRDiag_DR,Synd_Sign,Synd_User_DR,Synd_Date,Synd_Time)
		         values (:Adm,:MRDiagnoeRowId,:SynDr,:UserDr,:NowDate,:NowTime))
		       s Rtn=SQLCODE
		       i (Rtn'=0) q
		    }
		   
		 }else{
			 for i=1:1:$l(SyndSignStr,"^"){
				 s OneSyndSign=$p(SyndSignStr,"^",i)
			     if ("^"_SyndStr_"^")[("^"_OneSyndSign_"^"){
			  	   &SQL(insert into SQLUser.DHC_DocSyndDiff (Synd_Adm_DR,Synd_MRDiag_DR,Synd_Sign,Synd_User_DR,Synd_Date,Synd_Time)
		            values (:Adm,:MRDiagnoeRowId,:OneSyndSign,:UserDr,:NowDate,:NowTime))
		            s Rtn=SQLCODE
		            i (Rtn'=0) q
			     }else{
				     if ("^"_NewSynStr_"^")'[("^"_OneSyndSign_"^"){
					     &SQL(insert into SQLUser.DHC_DocSyndDiff (Synd_Adm_DR,Synd_MRDiag_DR,Synd_Sign,Synd_User_DR,Synd_Date,Synd_Time)
		                values (:Adm,:MRDiagnoeRowId,:OneSyndSign,:UserDr,:NowDate,:NowTime))
		                s Rtn=SQLCODE
		                i (Rtn'=0) q
					 }
				 }
			 }
			 s LenSyn=$l(SyndStr,"^")
		     for j=1:1:LenSyn 
	         {
		        s SynDr=$P(SyndStr,"^",j)
		        b //
		        Continue:SynDr=""
		        Continue:("^"_SyndSignStr_"^")[("^"_SynDr_"^")
		        &SQL(insert into SQLUser.DHC_DocSyndDiff (Synd_Adm_DR,Synd_MRDiag_DR,Synd_Sign,Synd_User_DR,Synd_Date,Synd_Time)
		        values (:Adm,:MRDiagnoeRowId,:SynDr,:UserDr,:NowDate,:NowTime))
		        s Rtn=SQLCODE
		        i (Rtn'=0) q
		     }
	   }
	 }
	
	/*;保存症状串先清除信息
	&SQL(delete from SQLUser.DHC_DocSyndDiff where Synd_MRDiag_DR=:MRDiagnoeRowId)
	s Rtn=0
	for i=1:1:LenSyn 
	{
		s SynDr=$P(SyndStr,"^",i)
		Continue:SynDr=""
		&SQL(insert into SQLUser.DHC_DocSyndDiff (Synd_Adm_DR,Synd_MRDiag_DR,Synd_Sign,Synd_User_DR,Synd_Date,Synd_Time)
		values (:Adm,:MRDiagnoeRowId,:SynDr,:UserDr,:NowDate,:NowTime)
		)
		s Rtn=SQLCODE
		i (Rtn'=0) q
		
	}*/
	q Rtn
}

/// 获取一个诊断上添加的ID串用^分割
/// Input 诊断ID
/// OutPut 诊断对应证ID
ClassMethod GetDiaSynd(MRDiagnoeRowId As %String) As %String
{
	Q:MRDiagnoeRowId="" ""
	s Return=""
	s Row=0
	f  s Row=$O(^DHCDocSYND(0,"Diagnos",MRDiagnoeRowId,Row)) Q:Row=""  d
	.s SynDr=$P($G(^DHCDocSYND(Row)),"^",6)
	.Q:SynDr=""
	.if $D(^MRC("DSYM",SynDr))  d
	..i Return="" s Return=SynDr
	..else  s Return=Return_"^"_SynDr
	Q Return
}

/// 获取一个诊断上添加的描述
/// Input 诊断ID
/// OutPut 诊断对应证ID
ClassMethod GetDiaSyndDesc(MRDiagnoeRowId As %String) As %String
{
	Q:MRDiagnoeRowId="" ""
	s Return=""
	s Row=0
	f  s Row=$O(^DHCDocSYND(0,"Diagnos",MRDiagnoeRowId,Row)) Q:Row=""  d
	.s SynDr=$P($G(^DHCDocSYND(Row)),"^",6)
	.Q:SynDr=""
	.if $D(^MRC("DSYM",SynDr))  d
	..s Desc=$p($g(^MRC("DSYM",SynDr)),"^",2)
	..i Return="" s Return=Desc
	..else  s Return=Return_","_Desc
	Q Return
}

// 新版诊断录入所用方法

/// /w ##Class(web.DHCDocDiagnosNew).CopyFromHistMRDiag(5,1259,5,3,"126||1",171)
ClassMethod CopyFromHistMRDiag(LogDepRowid As %String, LogUserRowid As %String, DiagnosType As %String, DiagnosStatus As %String, MRDIADr As %String, mradm As %String) As %String
{
	s ^tan("CopyFromHistMRDiag")=LogDepRowid_","_LogUserRowid_","_DiagnosType_","_DiagnosStatus_","_MRDIADr_","_mradm
	s MradmRowid=$p(MRDIADr,"||",1)
	s MrICDSub=$p(MRDIADr,"||",2)
	q:(MradmRowid="")||(MrICDSub="") "-1^诊断记录查询失败"
	s MainMRDIADr=$P($g(^MR(MradmRowid,"DIA",MrICDSub)),"^",15)
	q:(MainMRDIADr'="") "-2^请选择主诊断复制"
	
	s ICDCodeRowid=$p(^MR(MradmRowid,"DIA",MrICDSub),"^",1)
	s MRDIADesc=""
	s MainNCDCode=$p($G(^MR(MradmRowid,"DIA",MrICDSub,"DHC")),"^",10)
	s Questionnaire=$P($G(^MR(MradmRowid,"DIA",MrICDSub)),"^",22)
	//if (ICDCodeRowid=""){
		s MRDIADescDr=$g(^MR(MradmRowid,"DIA",MrICDSub,"DES",0))
		if (+MRDIADescDr'=0){
			s MRDIADesc=$g(^MR(MradmRowid,"DIA",MrICDSub,"DES",MRDIADescDr))
			s MRDIADesc=MRDIADesc_"#"_Questionnaire
		}
	//}
	
	s SyndromeCICDRowid=""
	s SyndromeDesc=""
	s SyndromeNCDCode=""
	s sub=0
	for {
		s sub=$O(^MR(MradmRowid,"DIA",sub))
		q:sub=""
		//w MainMRDiagnoeRowId_","_$P($g(^MR(MRADMRowId,"DIA",sub)),"^",15),!
		continue:(MRDIADr'=$P($g(^MR(MradmRowid,"DIA",sub)),"^",15))
		s SyndromeCICDRowid=$p(^MR(MradmRowid,"DIA",sub),"^",1)
		s Questionnaire=$P($G(^MR(MradmRowid,"DIA",sub)),"^",22)
		//if (ICDCodeRowid=""){
			s SyndromeDescDr=$g(^MR(MradmRowid,"DIA",sub,"DES",0))
			if (+SyndromeDescDr'=0){
				s SyndromeDesc=$g(^MR(MradmRowid,"DIA",sub,"DES",SyndromeDescDr))
				s SyndromeDesc=SyndromeDesc_"#"_Questionnaire
			}
		//}
		s SyndromeNCDCode=$p($G(^MR(MradmRowid,"DIA",sub,"DHC")),"^",10)
		
	}
	b
	 ///										LogDepRowid, MRAdmRo, ICDCodeRowid ,UserRowid ,MRDIADesc , MRDiagTypeDesc , MRDIADiagStatDesc, MRDIASignSymDesc, MRDIADurationNum, MRDIADurationUnit, DHCMRDIASignSymDesc, DiagnosStatus, DiagnosLeavel, DocUserId, SyndromeCICDRowid, SyndromeDesc
	s ret=##class(web.DHCMRDiagnos).InsertMRDiagnos(LogDepRowid,mradm,ICDCodeRowid,LogUserRowid,MRDIADesc,DiagnosType,"","","","","",DiagnosStatus,1,"","",SyndromeCICDRowid,SyndromeDesc)
	if (+ret=mradm){
		s MainAdmRowid=$P(ret,"^",1)
		s SyndromeRowid=$P(ret,"^",2)
		if (+MainAdmRowid>0){
			if (MainNCDCode'=""){
				d ##Class(web.DHCMRDiagnosNew).UpdateNCDCode(MainAdmRowid,MainNCDCode)
			}
		}
		if (+SyndromeRowid>0){
			if (SyndromeNCDCode'=""){
				d ##Class(web.DHCMRDiagnosNew).UpdateNCDCode(SyndromeRowid,SyndromeNCDCode)
			}
		}
	}
	q ret
}

/// /w ##Class(web.DHCDocDiagnosNew).CopyFromMRDia("19666#55||1#",185,4712,55)
ClassMethod CopyFromMRDia(MRDiaStr As %String, LogDepRowid As %String, LogUserRowid As %String, mradm As %String, MRDiagnosTypeDr As %String = "", DiagnosStatus As %String = "") As %String
{
	s ^tan("CopyFromMRDia")=MRDiaStr_","_LogDepRowid_","_LogUserRowid_","_mradm_","_MRDiagnosTypeDr_","_DiagnosStatus
	s InsertMRDiaStr=""
	s Length=$L(MRDiaStr,"^")
	for i=1:1:Length {
		s OneDiaStr=$P(MRDiaStr,"^",i)
		s MRDiaDr=$P(OneDiaStr,"#",2)
		continue:MRDiaDr=""
		s MRDIADesc=""
		continue:$G(^MR(+MRDiaDr,"DIA",$P(MRDiaDr,"||",2)))=""
		s ICDCodeDR=$P(^MR(+MRDiaDr,"DIA",$P(MRDiaDr,"||",2)),"^",1)
		if (ICDCodeDR=""){
			s MRDIADescDr=$G(^MR(+MRDiaDr,"DIA",$P(MRDiaDr,"||",2),"DES",0))
			if (MRDIADescDr'=""){
				s MRDIADesc=$G(^MR(+MRDiaDr,"DIA",$P(MRDiaDr,"||",2),"DES",MRDIADescDr))
				s Questionnaire=$P($G(^MR(+MRDiaDr,"DIA",$P(MRDiaDr,"||",2))),"^",22)
				s MRDIADesc=MRDIADesc_"#"_Questionnaire
			}
		}
		continue:(MRDIADesc="")&&(ICDCodeDR="")
		if (MRDiagnosTypeDr=""){
			s InPutMRDiagnosTypeDr=""
			s SubRowid=$G(^MR(+MRDiaDr,"DIA",$P(MRDiaDr,"||",2),"TYP",0))
			if SubRowid'="" s InPutMRDiagnosTypeDr=$G(^MR(+MRDiaDr,"DIA",$P(MRDiaDr,"||",2),"TYP",SubRowid))
			if (InPutMRDiagnosTypeDr'=""){
				s InPutMRDiagnosTypeDr=$P(^MRC("DTYP",InPutMRDiagnosTypeDr),"^",2)
			}
		}else{
			s InPutMRDiagnosTypeDr=MRDiagnosTypeDr
		}
		if (DiagnosStatus=""){
			s InPutDiagnosStatus=$P(^MR(+MRDiaDr,"DIA",$P(MRDiaDr,"||",2)),"^",9)
		}else{
			s InPutDiagnosStatus=DiagnosStatus
		}
		s MainMRDIADr=$P($g(^MR(+MRDiaDr,"DIA",$P(MRDiaDr,"||",2))),"^",15)
		continue:MainMRDIADr'=""
		///遍历其子诊断
		s SubICDRowidStr=""
		s SyndromeDesc=""
		s Sub=0
		for {
			s Sub=$O(^MR(+MRDiaDr,"DIA",0,"Link",MRDiaDr,Sub))
			q:Sub=""
			s SubICDCodeDR=$P(^MR(+MRDiaDr,"DIA",Sub),"^",1)
			if (SubICDCodeDR'=""){
				if (SubICDRowidStr=""){
					s SubICDRowidStr=SubICDCodeDR
				}else{
					s SubICDRowidStr=SubICDRowidStr_"^"_SubICDCodeDR
				}
			}else{
				
				s SubDescDr=$G(^MR(+MRDiaDr,"DIA",Sub,"DES",0))
				if (SubDescDr'=""){
					s SubDesc=$G(^MR(+MRDiaDr,"DIA",Sub,"DES",SubDescDr))
					s SubQuestionnaire=$P($G(^MR(+MRDiaDr,"DIA",Sub)),"^",22)
					s SyndromeDesc=SubDesc_"#"_SubQuestionnaire
				}
			}
		}
		
		s ret=##class(web.DHCMRDiagnos).InsertMRDiagnos(LogDepRowid,mradm,ICDCodeDR,LogUserRowid,MRDIADesc,InPutMRDiagnosTypeDr,"","","","","",InPutDiagnosStatus,1,"","",SubICDRowidStr,SyndromeDesc)
		if (ret'=0){
			if (InsertMRDiaStr=""){
				s InsertMRDiaStr=ret
			}else{
				s InsertMRDiaStr=InsertMRDiaStr_"^"_ret
			}
		}
	}
	s OutPutStr=""
	s Length=$L(InsertMRDiaStr,"^")
	for i=1:1:Length {
		s InsertMRDiaRowID=	$P(InsertMRDiaStr,"^",i)
		continue:InsertMRDiaRowID=""
		s ICDCodeDR=$P(^MR(+InsertMRDiaRowID,"DIA",$P(InsertMRDiaRowID,"||",2)),"^",1)
		if (OutPutStr=""){
			s OutPutStr=InsertMRDiaRowID_"#"_ICDCodeDR
		}else{
			s OutPutStr=OutPutStr_"^"_InsertMRDiaRowID_"#"_ICDCodeDR
		}
	}
	
	q OutPutStr
}

/// /w ##Class(web.DHCDocDiagnosNew).GetKeyFromJC()
ClassMethod GetKeyFromJC() As %String
{
	s $ZT="GetKeyFromJCErr"
	s SOAP=##Class(web.JCMRDiaInsert.SOAP.ICD10HelpHandlerSoap).%New()
	s ret=SOAP.GetKey()
	q ret
GetKeyFromJCErr
	q $ze
}

/// /w ##Class(web.DHCDocDiagnosNew).GetValueByKeyFromJC("20151209203935000705eadcb2de54c1e9c43cc2476b67f76",3009)
ClassMethod GetValueByKeyFromJC(Key As %String, UserID As %String, LogDepRowid As %String, mradm As %String, MRDiagnosTypeDesc As %String) As %String
{
	s $ZT="GetValueByKeyFromJCErr"
	s ^tan("GetValueByKeyFromJC")=Key_","_UserID
	s SOAP=##Class(web.JCMRDiaInsert.SOAP.ICD10HelpHandlerSoap).%New()
	s ret=SOAP.GetValueByKey(Key,UserID)
	
	s OutPutObj=##Class(web.JCMRDiaInsert.GetValueByKeyRp).%New()
	d OutPutObj.XMLNodeDeserialize(.OutPutObj,"ICD",ret)
	
	///诊断类型：1-确诊诊断；2-待查诊断
	s ICDTYPE=OutPutObj.ICDTYPE
	///ICD10编码
	s ICD10=OutPutObj.ICD10
	
	///医生临床诊断描述
	s ICD10LCMS=OutPutObj.ICD10LCMS
	
	///中医疾病诊断编码
	s ICDCNB=OutPutObj.ICDCNB
	///中医证候编码
	s ICDCNZ=OutPutObj.ICDCNZ
	///肿瘤形态学编码	---仅录入出院诊断时插入病理诊断类型
	s ZLXTXBM=OutPutObj.ZLXTXBM
	//w ICDTYPE_","_ICD10_","_ICD10LCMS_","_ICDCNB_","_ICDCNZ_","_ZLXTXBM,!
	///^MRC("DSTAT")
	s DiagStatDr=3
	if (ICDTYPE=1){
		s DiagStatDr=1
	}
	
	s ICD10Dr=..GetICDXRowID(ICD10)
	s ICDCNBDr=..GetICDXRowID(ICDCNB)
	s ICDCNZDr=..GetICDXRowID(ICDCNZ)
	s ZLXTXBMDr=..GetICDXRowID(ZLXTXBM)
	
	//w ICD10Dr_","_ICDCNBDr_","_ICDCNZDr_","_ZLXTXBMDr,!

	if (ICD10Dr'=""){
		s ICDStr=ICD10Dr
	}
	if (ICDCNBDr'=""){
		if (ICDStr=""){
			s ICDStr=ICDCNBDr
		}else{
			s ICDStr=ICDStr_"^"_ICDCNBDr
		}
		if (ICDCNZDr'=""){
			if (ICDStr=""){
				s ICDStr=ICDCNZDr
			}else{
				s ICDStr=ICDStr_"^"_ICDCNZDr
			}
		}
	}
	///病理诊断
	s BLZD=""
	if ((ZLXTXBMDr'="")&&(MRDiagnosTypeDesc="出院诊断")){
		s BLZD=ICDCNBDr
	}
	if (ICDStr=""){
		q "-1^未查找到有效的诊断"
	}
	s ICDCodeDR=$P(ICDStr,"^",1)
	s SubICDRowidStr=$P(ICDStr,"^",2,$l(ICDStr,"^"))
	
	s ret=##class(web.DHCMRDiagnos).InsertMRDiagnos(LogDepRowid,mradm,ICDCodeDR,UserID,ICD10LCMS,MRDiagnosTypeDesc,"","","","","",DiagStatDr,1,"","",SubICDRowidStr)
	
	///病理诊断时单独的类型
	if ((+ret>0)&&(BLZD'="")){
		s MainRowI=$P(ret,"^",1)
		s BLret=##class(web.DHCMRDiagnos).InsertMRDiagnos(LogDepRowid,mradm,BLZD,UserID,"","病理诊断","","","","","",DiagStatDr,1,"","")
		if (+BLret>0){
			Set object = ##class(User.MRDiagnos).%OpenId(BLret)
			d object.MRDIAMRDIADRSetObjectId($P(ret,"^",$L(ret,"^")))
			Set sc = object.%Save()
			Do object.%Close()
		}
	}
	
	
	s OutPutStr="0^"
	s Length=$L(ret,"^")
	for i=1:1:Length {
		s InsertMRDiaRowID=	$P(ret,"^",i)
		continue:InsertMRDiaRowID=""
		s ICDCodeDR=$P(^MR(+InsertMRDiaRowID,"DIA",$P(InsertMRDiaRowID,"||",2)),"^",1)
		if (OutPutStr=""){
			s OutPutStr=InsertMRDiaRowID_"#"_ICDCodeDR
		}else{
			s OutPutStr=OutPutStr_"^"_InsertMRDiaRowID_"#"_ICDCodeDR
		}
	}
	
	
	q OutPutStr
GetValueByKeyFromJCErr
	q $ze
}

ClassMethod GetICDXRowID(InsDesc As %String) As %String
{
	q:InsDesc="" ""
	s OutPut=""
	s RowId=0
	for {
		s RowId=$o(^MRC("ID",0,"InsDesc",$$ALPHAUP^SSUTIL4(InsDesc),RowId))
		q:RowId=""
		s ActiveFrom=$P(^MRC("ID",RowId),"^",6)
		s ActiveTo=$P(^MRC("ID",RowId),"^",7)
		continue:(ActiveFrom'="")&&(ActiveFrom>+$H)
		continue:(ActiveTo'="")&&(ActiveTo<+$H)
		s Active=$P(^MRC("ID",RowId),"^",27)
		continue:Active'="Y"
		s OutPut=RowId
	}
	q OutPut
}

/*
////w ##Class(web.DHCDocDiagnosNew).ReSetICDDx()
ClassMethod ReSetICDDx() As %String
{
	s ID=0
	for {
		s ID=$O(^MRC("ID",ID))
		q:ID=""
		&SQL(UPDATE SQLUser.MRC_ICDDx SET  MRCID_InsDesc=MRCID_ICD9CM_Code where MRCID_RowId=:ID)
		
	}
	q 0
}
*/

// w ##class(web.DHCDocDiagnosNew).GetPreMRAdmMethod(7)

ClassMethod GetPreMRAdmMethod(EpisodeID As %String) As %String
{
	s PAADMPAPMIDR=$p($G(^PAADM(EpisodeID)),"^",1)
	Q:PAADMPAPMIDR="" ""
	s AdmLoc=$p($G(^PAADM(EpisodeID)),"^",4)
	s PAADMRowID="",PreEpisodeID=""
	f  s PAADMRowID=$o(^PAPERdr(PAADMPAPMIDR,"ADM","O",PAADMRowID),-1) q:(PAADMRowID="")||(PreEpisodeID'="")  d
	.Q:(PAADMRowID>=EpisodeID)
	.s PAADMDepCodeDR=$p($G(^PAADM(PAADMRowID)),"^",4)
	.q:(PAADMDepCodeDR'=AdmLoc)
	.s PreEpisodeID=PAADMRowID
	s PreMRAdm=""
	if (PreEpisodeID'="") s PreMRAdm=$p($G(^PAADM(PreEpisodeID)),"^",61)
	Q PreMRAdm
}

ClassMethod GetAdmIsExistDiag(PreMRAdm As %String) As %String
{
	Q:PreMRAdm="" ""
	//s PAADMMainMRADMDR=$p($G(^PAADM(PreEpisodeID)),"^",61)
	//Q:PAADMMainMRADMDR="" ""
	s MRDIAChildsub=$o(^MR(PreMRAdm,"DIA",""),-1)
	Q MRDIAChildsub
}

// LogDepRowid, MRADMID, MRCICDRowid, LogUserRowid, MRDIADesc, 

// DiagnosType,"","","","","",DiagnosStatus,DiagnosLevel,"",SyndromeCICDRowid,SyndromeDesc

// w ##class(web.DHCDocDiagnosNew).InsertPreMRDiagnos("211||1,211||2,211||3",212,52,2543)

ClassMethod InsertPreMRDiagnos(IDStr As %String, MRADMID As %String, LogDepRowid As %String, LogUserRowid As %String) As %String
{
	s ^tempscl("InsertPreMRDiagnos")=IDStr_","_MRADMID_","_LogDepRowid_","_LogUserRowid
	s rtn=""
	For i=1:1:$l(IDStr,",") d
	.s OneID=$p(IDStr,",",i)
	.s MRCICDRowid=$p($g(^MR(+OneID,"DIA",$p(OneID,"||",2))),"^",1)
	.s MRDIADesc=$G(^MR($P(OneID,"||",1),"DIA",$P(OneID,"||",2),"DES",1))
	.s DiagnosType=""
	.s TYPMRCDiagTyp=$p($g(^MR(+OneID,"DIA",$p(OneID,"||",2),"TYP",1)),"^",1)
	.i TYPMRCDiagTyp'="" s DiagnosType=$p($g(^MRC("DTYP",TYPMRCDiagTyp)),"^",2)
	.s DiagnosLevel=1
	.s DiagnosStatus=$p($g(^MR(+OneID,"DIA",$p(OneID,"||",2))),"^",9)
	.s DiagnosCat=""
	.s SyndromeCICDRowid="",SyndromeDesc=""
	.i MRCICDRowid'="" d
	..s BillFlag1=$P($G(^MRC("ID",+MRCICDRowid)),"^",13)
	..s BillFlag3=$P($g(^MRC("ID",+MRCICDRowid)),"^",15)
	..i BillFlag3'="Y" d
	...s DiagnosCat="西医"
	..else  if (BillFlag3="Y")&&(BillFlag1'="Y") d
	...s DiagnosCat="中医"
	..else  d
	...s DiagnosCat="证候"
	...//s SyndromeCICDRowid=MRCICDRowid
	...//s SyndromeDesc=""
	.e  d
	..s Questionnaire=$P($G(^MR($P(OneID,"||",1),"DIA",$P(OneID,"||",2))),"^",22)
	..i Questionnaire=1 d
	...s DiagnosCat="西医"
	..else  if (Questionnaire=2) d
	...s DiagnosCat="中医"
	..else  if (Questionnaire=3) d
	...s DiagnosCat="证候"
	...s SyndromeCICDRowid=""
	...s SyndromeDesc=MRDIADesc
	.if (DiagnosCat="中医") d
	..if (MRDIADesc'="") s MRDIADesc=MRDIADesc_"#2"
	..//if (SyndromeDesc'="") s SyndromeDesc=SyndromeDesc_"#3"
	.else  d
	..if (MRDIADesc'="") s MRDIADesc=MRDIADesc_"#1"
	.Q:DiagnosCat="证候"
	.s MRDIAChildsub=0
	.f  s MRDIAChildsub=$o(^MR(+OneID,"DIA",0,"Link",OneID,MRDIAChildsub)) q:MRDIAChildsub=""  d
	..s SyndromeCICDRowid=$p($g(^MR(+OneID,"DIA",MRDIAChildsub)),"^",1)
	..s SyndromeDesc=$G(^MR($P(OneID,"||",1),"DIA",MRDIAChildsub,"DES",1))
	..s SyndromeDesc=SyndromeDesc_"#3"
	.s rowid=##class(web.DHCMRDiagnos).InsertMRDiagnos(LogDepRowid,MRADMID,MRCICDRowid,LogUserRowid,MRDIADesc,DiagnosType,"","","","","",DiagnosStatus,DiagnosLevel,"","",SyndromeCICDRowid,SyndromeDesc)
	.//i (DiagnosCat="证候")&&(rowid'="") d
	..//s ret=##Class(web.DHCDocDiagnosNew).UpdateMRDiagnos(rowid,"1"+i)
	..//Set object = ##class(User.MRDiagnos).%OpenId(rowid)
	..//d object.MRDIAMRDIADRSetObjectId($P(rtn,"^",$L(rtn,"^")))
	..//Set sc = object.%Save()
	..//Do object.%Close()
	.i rowid'="" d
	.i rtn="" s rtn=rowid
	.e  s rtn=rtn_"^"_rowid
	q rtn
}

ClassMethod ChangeDiaDate(MRDiagnosRowid As %String, DateString As %String) As %String
{
	s Date=$P(DateString," ",1)
	s Time=$P(DateString," ",2)
	s Date=$ZDH(Date,3)
	s Time=..%ZTH(Time)
	Set object = ##class(User.MRDiagnos).%OpenId(MRDiagnosRowid)
	s object.MRDIADate=Date
	s object.MRDIATime=Time
	s sc = object.%Save()
	Do object.%Close()
	q sc
}

Query TemplateList(MASTERDR As %String) As %Query(ROWSPEC = "RowNum:%String,ICDDesc1:%String,ICDDr1:%String,ICDDesc2:%String,ICDDr2:%String,ICDDesc3:%String,ICDDr3:%String,ICDDesc4:%String,ICDDr4:%String,ICDDesc5:%String,ICDDr5:%String")
{
}

ClassMethod TemplateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TemplateListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod TemplateListExecute(ByRef qHandle As %Binary, MASTERDR As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosNew","TemplateList",220)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s ^tan("TemplateList")=MASTERDR
	if MASTERDR="" {  
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	///重排序
	k TemplateRowDataList
	Set ListNum=""
    for {
		s ListNum=$O(^DHCDIAICD("MASTER",MASTERDR,ListNum))
		q:ListNum=""
		s RowID=0
		s DHCMRDiaICDListIndex=0
		for {
			s DHCMRDiaICDListIndex=$O(^DHCDIAICD("MASTER",MASTERDR,ListNum,DHCMRDiaICDListIndex))
			q:DHCMRDiaICDListIndex=""
			s DHCMRDiaICDRowid=0
			for {
				s DHCMRDiaICDRowid=$O(^DHCDIAICD("MASTER",MASTERDR,ListNum,DHCMRDiaICDListIndex,DHCMRDiaICDRowid))
				Q:DHCMRDiaICDRowid=""
				s RowID=RowID+1
				//s TemplateRowDataList(RowID,ListNum)=DHCMRDiaICDRowid
				s $P(TemplateRowDataList(RowID),"^",+ListNum)=DHCMRDiaICDRowid
			}
		}
    }
    s RowNum=0
	s RowID=0
	for {
		s RowID=$O(TemplateRowDataList(RowID))
		q:RowID=""
		s TemplateStr=$G(TemplateRowDataList(RowID))
		s RowNum=RowNum+1
		s Data=$lb(RowNum)
		d ResetValue
		for i=1:1:5 {

			s TemplateRowID=$P(TemplateStr,"^",i)
			if (TemplateRowID=""){
				s Desc=""
				s ID=""
			}else{
				Set DHCMRDiaICDICDDR=$P($g(^DHCDIAICD(TemplateRowID)),"^",3)
				i DHCMRDiaICDICDDR'="" Set DHCMRDiaICDICDDesc=$P($G(^MRC("ID",DHCMRDiaICDICDDR)),"^",2)
				e  s DHCMRDiaICDICDDesc=$P($g(^DHCDIAICD(TemplateRowID)),"^",6)
				s SyndromeDr="" //$P($g(^DHCDIAICD(TemplateRowID)),"^",6)
				s SyndromeDesc=""
				i SyndromeDr'="" {
					s SyndromeDesc=$P($G(^MRC("ID",SyndromeDr)),"^",2)
				}
				if (SyndromeDesc'="") s Desc=DHCMRDiaICDICDDesc_"*"_SyndromeDesc
				e  s Desc=DHCMRDiaICDICDDesc
				if (SyndromeDr'="") s ID=DHCMRDiaICDICDDR_"*"_SyndromeDr
				e  s ID=DHCMRDiaICDICDDR
				//s Desc=DHCMRDiaICDICDDesc_"*"_SyndromeDesc
				//s ID=DHCMRDiaICDICDDR_"*"_SyndromeDr
			}
			s $List(Data,i*2)=Desc
			s $List(Data,(i*2)+1)=ID
		}
		d OutputRow7
	}

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	//set Data=$lb(RowNum,ICDDesc1,ICDDr1,ICDDesc2,ICDDr2,ICDDesc3,ICDDr3,ICDDesc4,ICDDr4,ICDDesc5,ICDDr5)  //
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetValue
	s (ICDDesc1,ICDDr1,ICDDesc2,ICDDr2,ICDDesc3,ICDDr3,ICDDesc4,ICDDr4,ICDDesc5,ICDDr5)=""
	q
}

ClassMethod TemplateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TemplateListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

/// //w ##Class(web.DHCDocDiagnosNew).GetLocTemplateList(52)
ClassMethod GetLocTemplateList(LOCID As %String) As %String
{
	s Str=""
	s IndexNum=0
	if LOCID="" Q ""
	Set DHCDIAINDEX="" f  {
		s DHCDIAINDEX=$O(^DHCDIAMAS("CTLOC",LOCID,DHCDIAINDEX)) 
		q:DHCDIAINDEX=""
		Set DHCDIAMASRowid="" f  {
			s DHCDIAMASRowid=$O(^DHCDIAMAS("CTLOC",LOCID,DHCDIAINDEX,DHCDIAMASRowid)) 
			q:DHCDIAMASRowid=""
			s UserID=$P(^DHCDIAMAS(DHCDIAMASRowid),"^",4)
			//w ^DHCDIAMAS(DHCDIAMASRowid),!
			Set DHCDIADESC=$P(^DHCDIAMAS(DHCDIAMASRowid),"^",2)
			If DHCDIADESC'="" Set IndexNum=IndexNum+1
			If Str'="" Set Str=Str_$c(1)_DHCDIAMASRowid_"^"_DHCDIADESC
			if Str="" Set Str=DHCDIAMASRowid_"^"_DHCDIADESC
		}
	}
	Q Str_$c(2)_IndexNum
}

/// //w ##Class(web.DHCDocDiagnosNew).GetPrivateList(2543)
ClassMethod GetUserTemplateList(USERID As %String) As %String
{
	If USERID="" Q "User Null"
	Set Str="",IndexNum=0
	Set DHCDIAINDEX="" f  s DHCDIAINDEX=$O(^DHCDIAMAS("USER",USERID,DHCDIAINDEX)) q:DHCDIAINDEX=""  d
	.Set DHCDIAMASRowid="" f  s DHCDIAMASRowid=$O(^DHCDIAMAS("USER",USERID,DHCDIAINDEX,DHCDIAMASRowid)) q:DHCDIAMASRowid=""  d
	..Set DHCDIADESC=$P(^DHCDIAMAS(DHCDIAMASRowid),"^",2)
	..If DHCDIADESC'="" Set IndexNum=IndexNum+1
	..If Str'="" Set Str=Str_$c(1)_DHCDIAMASRowid_"^"_DHCDIADESC
	..if Str="" Set Str=DHCDIAMASRowid_"^"_DHCDIADESC
	
	Q Str_$c(2)_IndexNum
}

Query DiagnosList(MRADMID As %Library.String = "", ICDType As %String = "", DiagnosTypeCode As %String = "", Format As %String = "") As %Query(ROWSPEC = "DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosDate,DiagnosOnsetDate:%String,DiagStat:%String,DiagnosLeavel:%String,MainDiagFlag:%String,DiagnosPrefix:%String,DiagnosNumber:%String,MRDIAAddLocDr:%String,MRDIADocCode:%String,MRDIADocDesc:%String,MRdiagnosTime:%String,DiagnosCat:%String")
{
}

ClassMethod DiagnosListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagnosListExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod DiagnosListExecute(ByRef qHandle As %Binary, MRADMID As %Library.String = "", ICDType As %String = "", DiagnosTypeCode As %String = "", Format As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosNew","DiagnosList","166","","")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if MRADMID="" {  
	    d ResetVariables1
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	Set RetStr="",NO=1
	k TempArr("FindDiagnos",$J)
	
	s defaultDiagnosTypeID=""
	if DiagnosTypeCode'="" {
		s defaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code",DiagnosTypeCode,0))
	}
	Set obj=##class(%ResultSet).%New("web.DHCDocDiagnosNew:Find")
	d obj.Execute(MRADMID)
	For  Quit:'obj.Next()  Do
	.s Desc=obj.Data("MRDIAICDCodeDRDesc")
	.s Rowid=obj.Data("ID")
	.s MRDiagnosTypeDesc=""
	.s MRDiagnosTypeDr=""
	.S MRdiagnosNoteDr=""
	.S MRdiagnosNoteDesc=""
	.s MRdiagnosNoteSubRowid=""
	.S SubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",0))
	.if SubRowid'="" s MRDiagnosTypeDr=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"TYP",SubRowid))
	.Q:(defaultDiagnosTypeID'="")&&(MRDiagnosTypeDr'=defaultDiagnosTypeID)
	.I MRDiagnosTypeDr'="" Set MRDiagnosTypeDesc=$P($G(^MRC("DTYP",MRDiagnosTypeDr)),"^",2)
	.S MRdiagnosNoteSubRowid=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",0))
	.I MRdiagnosNoteSubRowid'="" Set MRdiagnosNoteDesc=$G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"DES",MRdiagnosNoteSubRowid))
	.s CodeRowid=obj.Data("MRDIAICDCodeDR")
	.s MRCIDCode=obj.Data("MRDIAICDCodeDRCode")
	.S MRDiagnosDate=obj.Data("MRDIADate")
	.s MRdiagnosTime=obj.Data("MRDIATime")
	.I ((MRDiagnosDate'="")&&(MRDiagnosDate'["-")) Set MRDiagnosDate=$zd(MRDiagnosDate,3)
	.I MRdiagnosTime'="" Set MRdiagnosTime=..%ZT(MRdiagnosTime)
	.s BillFlag3="" 
	.s BillFlag3=""
	.i CodeRowid'="" s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)
	.Q:(ICDType="1")&&(BillFlag3'="Y")
	.//Q:(ICDType'="1")&&(BillFlag3="Y")
	.s MRDesc=obj.Data("MRDIADesc")
	.if (MRDesc'="")&&($$$ISOK($LV(MRDesc))) s MRDesc=$ListToString(MRDesc,"、")
	.if MRDesc'="" s MRDesc=MRdiagnosNoteDesc
	.s DiagStat=""
	.s DiagStatDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",9)
	.s DiagnosLeavel=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",1) //取诊断级别
	.s DiagnosNumber=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),"EPR")),"^",2) //取顺序号
	.s DIAOnsetDate=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",35) //取发病日期
	.s:DIAOnsetDate'="" DIAOnsetDate=$zd(DIAOnsetDate,3) //取发病日期
	.s MainDiagFlag=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",20)
	.i MainDiagFlag'="Y" s MainDiagFlag="N"
	.if DiagStatDr'="" s DiagStat=$p($g(^MRC("DSTAT",DiagStatDr)),"^",2)
	.if DiagnosNumber="" s DiagnosNumber=$g(^MR($P(Rowid,"||",1),"DIA",0))+1
	.s banlkSpace="" f i=1:1:(+DiagnosLeavel-1) s banlkSpace=banlkSpace_"&nbsp" ;根椐级别加空格
    .s Desc=banlkSpace_Desc
	.i (Format=1) s Desc=$tr(Desc,"&nbsp","")
	.s DiagnosPrefix=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",26) ;诊断前缀
	.s MRDIAAddLocDr=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2),1)),"^",25) ;诊断科室
	.s MRDIADocCode="",MRDIADocDesc=""
	.s MRDIADocCodeDR=$p($g(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",4)
	.if MRDIADocCodeDR'="" d
	..s MRDIADocCode=$p($g(^CTPCP(MRDIADocCodeDR,1)),"^",1) ;诊断医生编码
	..s MRDIADocDesc=$p($g(^CTPCP(MRDIADocCodeDR,1)),"^",2) ;诊断医生名称
	.s DiagnosCat=""
	.i CodeRowid'="" d
	..s BillFlag1=$P($G(^MRC("ID",+CodeRowid)),"^",13)
	..s BillFlag3=$P($g(^MRC("ID",+CodeRowid)),"^",15)
	..
	..i BillFlag3'="Y" d
	...s DiagnosCat="西医"
	..else  if (BillFlag3="Y")&&(BillFlag1'="Y") d
	...s DiagnosCat="中医"
	..else  d
	...s DiagnosCat="证候"
	.e  d
	..s Questionnaire=$P($G(^MR($P(Rowid,"||",1),"DIA",$P(Rowid,"||",2))),"^",22)
	..i Questionnaire=1 d
	...s DiagnosCat="西医"
	..else  if (Questionnaire=2) d
	...s DiagnosCat="中医"
	..else  if (Questionnaire=3) d
	...s DiagnosCat="证候"
	.s TempArr("FindDiagnos",$j,DiagnosNumber,+Rowid,$p(Rowid,"||",2))=Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate_"^"_MainDiagFlag_"^"_DiagnosPrefix_"^"_MRDIAAddLocDr_"^"_MRDIADocCode_"^"_MRDIADocDesc_"^"_DiagnosCat
	d obj.Close()
	s DiagnosSeqNo=0
	//按顺序输出设置
	s TempDia=""
	s DiagnosNumber=0  f  {
		s DiagnosNumber=$O(TempArr("FindDiagnos",$j,DiagnosNumber)) 
		Q:DiagnosNumber=""  d
		s Temprowid=0 f {
			s Temprowid=$O(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid))
			q:Temprowid=""
			s DiagnosDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",1)
			s DiagnosValue=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",2)
			s DiagnosCodeRowid=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",3)
			s DiagnosMRDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",4)
			s DiagnosICDCode=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",5)
			s DiagnosType=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",6)
			s DiagnosNote=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",7)
			s DiagnosDate=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",8)
			s MRdiagnosTime=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",9)
			s DiagnosOnsetDate=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",13)
			s DiagnosLeavel=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",11)
			s DiagStat=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",10)
			s MainDiagFlag=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",14)
			s DiagnosPrefix=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",15)
			s MRDIAAddLocDr=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",16)
			s MRDIADocCode=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",17)
			s MRDIADocDesc=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",18)
			s DiagnosCat=$p(TempArr("FindDiagnos",$j,DiagnosNumber,MRADMID,Temprowid),"^",19)
			s DiagnosSeqNo=DiagnosSeqNo+1
			Do OutputRow1
		}
	}
	k TempArr("FindDiagnos",$j)
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
 //Desc_"^"_Rowid_"^"_CodeRowid_"^"_MRDesc_"^"_MRCIDCode_"^"_MRDiagnosTypeDesc_"^"_MRdiagnosNoteDesc_"^"_MRDiagnosDate_"^"_MRdiagnosTime_"^"_DiagStat_"^"_DiagnosLeavel_"^"_DiagnosNumber_"^"_DIAOnsetDate_"^"_MainDiagFlag
 //ICD描述 诊断表ID ICD诊断ID 诊断注释 ICDCode 诊断类型 诊断注释 日期 状态 发病日期 主诊断标识(Y/N)
OutputRow1
	set Data=$lb(DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosDate,DiagnosOnsetDate,DiagStat,DiagnosLeavel,MainDiagFlag,DiagnosPrefix,DiagnosSeqNo,MRDIAAddLocDr,MRDIADocCode,MRDIADocDesc,MRdiagnosTime,DiagnosCat)  //
	 Set ^CacheTemp(repid,ind)=Data
	 Set ind=ind+1
	quit
ResetVariables1
	set (DiagnosDesc,DiagnosValue,DiagnosCodeRowid,DiagnosMRDesc,DiagnosICDCode,DiagnosType,DiagnosNote,DiagnosDate,DiagnosOnsetDate,DiagStat,DiagnosLeavel,MainDiagFlag,DiagnosPrefix,DiagnosNumber,MRDIAAddLocDr,MRDIADocCode,MRDIADocDesc,MRdiagnosTime)=""
	quit
}

ClassMethod DiagnosListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagnosListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

// 查询诊断模板列表

Query DiagTemplateList(USERID As %String) As %Query(ROWSPEC = "DHCDIAMASRowid,DHCDIADESC")
{
}

ClassMethod DiagTemplateListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagTemplateListExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DiagTemplateListExecute(ByRef qHandle As %Binary, USERID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosNew","DiagTemplateList")
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if USERID="" {  
	    d ResetVariables2
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s PrivateListStr=..GetPrivateList(USERID)
	s PrivateListStr=$p(PrivateListStr,$c(2),1)
	For i=1:1:$l(PrivateListStr,$c(1)) d
	.s OnePrivateListStr=$p(PrivateListStr,$c(1),i)
	.s DHCDIAMASRowid=$p(OnePrivateListStr,"^",1)
	.s DHCDIADESC=$p(OnePrivateListStr,"^",2)
	.Do OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(DHCDIAMASRowid,DHCDIADESC)  
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables2
	set (DHCDIAMASRowid,DHCDIADESC)=""
	quit
}

ClassMethod DiagTemplateListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagTemplateListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

// 查询诊断模板明细列表

Query DiagTemplateDetailList(MASTERDR As %String) As %Query(ROWSPEC = "DHCMRDiaICDICDDR,DHCMRDiaICDICDDesc,DHCMRDiaICDRowid,DHCMRDiaICDICDNotes,SDSTermDR,SDSDisplayIDStr,DHCMRDiaICDICDType")
{
}

ClassMethod DiagTemplateDetailListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DiagTemplateDetailListExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod DiagTemplateDetailListExecute(ByRef qHandle As %Binary, MASTERDR As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosNew","DiagTemplateDetailList",211)
	s ^tan("DiagTemplateDetailList")=MASTERDR
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if MASTERDR="" {  
	    d ResetVariables3
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	For i=1:1:5 d
	.s ICDStr=..GetICD(MASTERDR,i)
	.q:ICDStr=""
	.For j=1:1:$l(ICDStr,$c(1)) d
	..s OneICDStr=$p(ICDStr,$c(1),j)
	..s DHCMRDiaICDICDDR=$p(OneICDStr,"^",1)
	..s DHCMRDiaICDICDDesc=$p(OneICDStr,"^",2)
	..s DHCMRDiaICDRowid=$p(OneICDStr,"^",3)
	..s DHCMRDiaICDICDNotes=$p(OneICDStr,"^",4)
	..s SDSTermDR=$p(OneICDStr,"^",5)
	..s SDSDisplayIDStr=$p(OneICDStr,"^",6)
	..s DHCMRDiaICDICDType=$p(OneICDStr,"^",7)
	..Do OutputRow3
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(DHCMRDiaICDICDDR,DHCMRDiaICDICDDesc,DHCMRDiaICDRowid,DHCMRDiaICDICDNotes,SDSTermDR,SDSDisplayIDStr,DHCMRDiaICDICDType)  
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables3
	set (DHCMRDiaICDICDDR,DHCMRDiaICDICDDesc)=""
	quit
}

ClassMethod DiagTemplateDetailListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DiagTemplateDetailListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

/// 查询诊断类型
Query GetDiagnosTypeList(AdmType As %String = "") As %Query(ROWSPEC = "DTYPRowid:%String,DTYPDesc:%String,selected:%Boolean")
{
}

ClassMethod GetDiagnosTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiagnosTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDiagnosTypeListExecute(ByRef qHandle As %Binary, AdmType As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocDiagnosNew","GetDiagnosTypeList",)
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s IPDedfaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code","M",0))
	s OPDedfaultDiagnosTypeID=$O(^MRC("DTYP",0,"Code","OP",0))
    s DiagnosTypeStr=..GetDiagnosType(AdmType)
    For i=1:1:$l(DiagnosTypeStr,"^") d
    .s OneDiagnosTypeStr=$p(DiagnosTypeStr,"^",i)
    .s DTYPRowid=$p(OneDiagnosTypeStr,$c(1),1)
    .s DTYPDesc=$p(OneDiagnosTypeStr,$c(1),2)
    .s selected=0
    .if (AdmType="I")&&(DTYPRowid=IPDedfaultDiagnosTypeID) s selected=1
    .e  i (DTYPRowid=OPDedfaultDiagnosTypeID) s selected=1
	.Do OutputRow4
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(DTYPRowid,DTYPDesc,selected)  
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
ResetVariables4
	set (DTYPRowid,DTYPDesc,selected)=""
	quit
}

ClassMethod GetDiagnosTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiagnosTypeListExecute ]
{
 Set AtEnd=$LIST(qHandle,1)
 Set repid=$LIST(qHandle,2)
 Set ind=$LIST(qHandle,3)
	//
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

/// Creator：    宋春莉
/// CreatDate：  2015-09-10
/// Description：根据PA_ADM表RowID获取住院患者的门急诊诊断(可能有多个)
/// Table：      PA_ADM,MR_Diagnos,MRC_ICDDx
/// Input：      EpisodeID
/// Return：     MRDIAICDCodeDR(指向MRC_ICDDx),MRDiagnos
/// Debug:		 w ##class(web.DHCDocDiagnosNew).GetMRDiagnosByEpisodeID(EpisodeID)
ClassMethod GetMRDiagnosByEpisodeID(EpisodeID)
{
	q:+EpisodeID=0 ""
	s RowId=0,MRDiagnos=""
	f  s RowId=$o(^DHCDocIPBK(0,"EpisodeIDTo",EpisodeID,RowId)) q:RowId=""  d
	.s ICDDr=$p(^DHCDocIPBK(RowId),"^",24)
	.q:ICDDr=""
	.s MRCIDDesc=$p($g(^MRC("ID",ICDDr)),"^",2)
	.i MRDiagnos="" d
	..s MRDiagnos=MRCIDDesc
	.e  d
	..s MRDiagnos=MRDiagnos_","_MRCIDDesc
	q MRDiagnos
	/*s MRDiagnos=""
	s INDiaType=$O(^MRC("DTYP",0,"Code","C008",0)) ;入院诊断
	s mradmId=$P(^PAADM(+EpisodeID),"^",61)
	s mrdiaSub=0
	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
	.s MRDIAICDCodeDR=$p($G(^MR(mradmId,"DIA",mrdiaSub)),"^",1)
	.q:MRDIAICDCodeDR=""
	.s TYPMRCDiagTyp=$p($g(^MR(mradmId,"DIA",mrdiaSub,"TYP",1)),"^",1)
	.q:TYPMRCDiagTyp'=INDiaType
	.i MRDiagnos="" d
	..s MRDiagnos=$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	.e  d
	..s MRDiagnos=MRDiagnos_","_$p($G(^MRC("ID",MRDIAICDCodeDR)),"^",2)
	q MRDiagnos*/
}

// 保存诊断个人模板

// @param: USERID 用户ID

// @param: selValue 个人模板ID(表DHC_MRDiagnosMaster的Rowid)

// @param: DiagnosStr需要保存的诊断串

// @param: DHCMRDiaICDRowid(个人模板明细表DHC_MRDiagnosICD)

// @param:catType (诊断分类)

// w ##class(web.DHCDocDiagnosNew).PrivateSaveNew(10209,825,22579,1,"")

// w ##class(web.DHCDocDiagnosNew).PrivateSaveNew(10209,910,"22579"_$c(1)_"1",1,"")

ClassMethod PrivateSaveNew(USERID As %String, selValue As %String, DiagnosStr As %String, ListNum As %String, DHCMRDiaICDRowid As %String = "", catType As %String = "", SDSTermDR As %String = "", SDSDisplayIDStr As %String = "") As %String
{
	s ^tan("PrivateSaveNew")=USERID_","_selValue_","_DiagnosStr_","_ListNum_","_DHCMRDiaICDRowid
	&sql(select count(DHCMRDiaICD_ListIndex) into :MaxListIndex from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_ListNum=:ListNum and DHCMRDiaICD_MASTERDR=:selValue and DHCMRDiaICD_ListNum='1')
	Q:DiagnosStr="" "^"
	s rtn="",rowid=""
	s err=0
	for i=1:1:$L(DiagnosStr,"^") {
		Set OneDiagnosInfo=$P(DiagnosStr,"^",i)
		Set MainICDInfo=$P(OneDiagnosInfo,"!",1)
		s MainIcdDesc=""
		s MainIcdRowid=+MainICDInfo
		if (MainICDInfo[$C(1)) {
			s MainIcdRowid=$p(MainICDInfo,$C(1),1)
			s MainIicdescCat=$p(MainICDInfo,$C(1),2)
			if (MainIicdescCat'="") s catType=MainIicdescCat
			if ($l(MainICDInfo,$C(1))>2) {
				s SDSTermDR=$p(MainICDInfo,$C(1),3)
				s SDSDisplayIDStr=$p(MainICDInfo,$C(1),4)
			}
		}
		i MainICDInfo["$" {
			s MainICDInfo1=$p(MainICDInfo,"$",2)
			s MainIicdescCat=$p(MainICDInfo1,$C(1),2)
			if (MainIicdescCat'="") s catType=MainIicdescCat
			s MainIcdDesc=$p(MainICDInfo1,$C(1),1)
			s MainIcdRowid=""
		}
		Set SyndromeICDInfo=$P(OneDiagnosInfo,"!",2,$L(OneDiagnosInfo,"!"))
		s SyndromeICDInfo=$TR(SyndromeICDInfo,"!",$C(2))
		//只验证西医诊断是否重复
		s count=0,count1=0
		b //
		if (+catType=0) {
			 if (MainIcdRowid'="") {
				 s MainICDDesc=$p(^MRC("ID",MainIcdRowid),"^",2)
				 if (SDSTermDR) {
					 &sql(select count(DHCMRDiaICD_Rowid) into:count from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_MASTERDR=:selValue and (DHCMRDiaICD_ICDDR=:MainIcdRowid or DHCMRDiaICD_Desc=:MainICDDesc) and DHCMRDiaICD_SDSTermDR=:SDSTermDR and DHCMRDiaICD_SDSDisplayIDStr=:SDSDisplayIDStr)
				 }else{
				 	&sql(select count(DHCMRDiaICD_Rowid) into:count from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_MASTERDR=:selValue and (DHCMRDiaICD_ICDDR=:MainIcdRowid or DHCMRDiaICD_Desc=:MainICDDesc))
				 }
			 }else{
				 &sql(select count(*) into:count1 from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_MASTERDR=:selValue and (DHCMRDiaICD_Desc=:MainIcdDesc or DHCMRDiaICD_ICDDR->MRCID_Desc=:MainIcdDesc)) 
			 }
		}
		/*i MainIcdRowid'="" {
			if (SyndromeICDInfo'="") &sql(select count(DHCMRDiaICD_Rowid) into:count from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_MASTERDR=:selValue and DHCMRDiaICD_ICDDR=:MainIcdRowid and DHCMRDiaICD_SyndromeICDInfo=:SyndromeICDInfo)
		    else  &sql(select count(DHCMRDiaICD_Rowid) into:count from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_MASTERDR=:selValue and DHCMRDiaICD_ICDDR=:MainIcdRowid and DHCMRDiaICD_SyndromeICDInfo is null)
		}elseif(SyndromeICDInfo=""){
			&sql(select count(DHCMRDiaICD_Desc) into:count1 from SQLUSER.DHC_MRDiagnosICD where DHCMRDiaICD_MASTERDR=:selValue and DHCMRDiaICD_Desc=:MainIcdDesc)
		}*/
		i count'=0 {
			i rtn="" s rtn=$p(^MRC("ID",MainIcdRowid),"^",2)
			e  s rtn=rtn_","_$p(^MRC("ID",MainIcdRowid),"^",2)
		}
		i count1'=0{
			i rtn="" s rtn=MainIcdDesc
			e  s rtn=rtn_","_MainIcdDesc
		}
		continue:(count>0)||(count1>0)
		if (DHCMRDiaICDRowid=""){
			s MaxListIndex=MaxListIndex+1
			&sql(insert into SQLUSER.DHC_MRDiagnosICD set DHCMRDiaICD_MASTERDR=:selValue,DHCMRDiaICD_ICDDR=:MainIcdRowid,DHCMRDiaICD_ListNum=:ListNum,DHCMRDiaICD_ListIndex=:MaxListIndex,DHCMRDiaICD_Desc=:MainIcdDesc,DHCMRDiaICD_SyndromeICDInfo=:SyndromeICDInfo,DHCMRDiaICD_SDSTermDR=:SDSTermDR,DHCMRDiaICD_SDSDisplayIDStr=:SDSDisplayIDStr,DHCMRDiaICD_Type=:catType)
		}else{
			&sql(update SQLUSER.DHC_MRDiagnosICD set DHCMRDiaICD_ICDDR=:MainIcdRowid,DHCMRDiaICD_Desc=:MainIcdDesc,DHCMRDiaICD_SyndromeICDInfo=:SyndromeICDInfo,DHCMRDiaICD_Type=:catType where DHCMRDiaICD_Rowid=:DHCMRDiaICDRowid)
		}
		s rowid=$p(%ROWID,$c(1))
		s err=err+SQLCODE
	}
   Q err_"^"_rtn_"^"_rowid
}

/// //w ##Class(web.DHCDocDiagnosNew).RefreshMRData(1339)
ClassMethod RefreshMRData(EpisodeID As %String) As %String
{
	s EpisodeType=$p(^PAADM(EpisodeID),"^",2)
	s mradm=$p(^PAADM(EpisodeID),"^",61)
	s PatientID=$p(^PAADM(EpisodeID),"^",1)
	s FirstAdm=0,ReAdmis=0,OutReAdm=0,TransAdm=0,ILIFlag=0,AdmWay=""
	s FirstOrReadmis=$p(^PAADM(EpisodeID),"^",72)
    s AdmReadm=$p(^PAADM(EpisodeID),"^",56)
    s TransFlag=$p($g(^PAADM(EpisodeID,"DHC")),"^",5)
    s ILIFlag=$p($g(^PAADM(EpisodeID,"DHC")),"^",13)
    ;默认初诊
    s FirstAdm=1
    s AdmWayID=$p($g(^PAADM(EpisodeID,2)),"^",47)
    I AdmWayID'="" S AdmWay=$P(^PAC("RTR",AdmWayID),"^",1)
    if (FirstOrReadmis="R")&&(AdmWay="CYFZ") s OutReAdm=1,FirstAdm=0
    if (FirstOrReadmis="F") s FirstAdm=1
    if (AdmReadm="R")&&(AdmWay="MZFZ") s ReAdmis=1,FirstAdm=0
    if (TransFlag="Y")&&(AdmWay="ZZ") s TransAdm=1,FirstAdm=0
    ;流感样
    if ILIFlag="Y" s ILIFlag=1
    //血压
    s BPSystolic=$p($g(^MR(mradm,"PRO",1)),"^",4)
    s BPDiastolic=$p($g(^MR(mradm,"PRO",1)),"^",5)
    s DiagnosStatus=$o(^MRC("DSTAT",0,"Desc","确诊",""))
    //上次门诊就诊ID
    s PreMRAdm=##class(web.DHCDocDiagnosNew).GetPreMRAdmMethod(EpisodeID)
    //住院患者的入院诊断
    s INDiag=##class(web.DHCDocDiagnosNew).GetMRDiagnosByEpisodeID(EpisodeID)

    s Data=EpisodeType_$C(1)_mradm_$C(1)_PatientID_$C(1)_FirstAdm_$C(1)_ReAdmis
    s Data=Data_$C(1)_OutReAdm_$C(1)_TransAdm_$C(1)_ILIFlag_$C(1)_BPSystolic_$C(1)_BPDiastolic
    s Data=Data_$C(1)_INDiag_$C(1)_PreMRAdm
    q Data
}

/// w ##class(web.DHCDocDiagnosNew).GetMRDiagnosToEMR(EpisodeID)
ClassMethod GetMRDiagnosToEMR(EpisodeID As %String)
{
	s mradm=$p(^PAADM(EpisodeID),"^",61)
	if mradm="" q ""
	s num=0
	s ret=""
	s sub=0
	for  s sub=$o(^MR(mradm,"DIA",sub)) Quit:sub=""  do
	.s desc=""
	.s desid=$g(^MR(mradm,"DIA",sub,"DES",0))
	.if desid'="" Set desc=^MR(mradm,"DIA",sub,"DES",desid)
	.s ICDId=$p(^MR(mradm,"DIA",sub),"^",1)
	.if ICDId'="" do
	..s desc=$p(^MRC("ID",ICDId),"^",2)
	.//处理诊断知识库录入的诊断
	.s DiagPRowId=$o(^MRi("DIAGP",mradm_"||"_sub,""))
	.i DiagPRowId'="" s desc=##class(web.DHCMRDiagnosNew).GetDiagFormateDesc(DiagPRowId)
	.Quit:desc=""
	.s num=num+1
	.if ret="" s ret=num_". "_desc
	.else  s ret=ret_"@"_num_". "_desc
	Quit ret
}

/// desc:得到安全组是否有诊断模板维护某一个保存菜单权限
/// input: "按科室保存设置"菜单:System.DiagFav.Save.SaveAsLoc
/// 		   "按安全组保存设置"菜单:System.DiagFav.Save.SaveAsGroup
/// 		   "按站点保存设置"菜单:System.DiagFav.Save.SaveAsSite
/// 		   "按用户保存设置"菜单:System.DiagFav.Save.SaveAsUser
/// output:0 没有权限,1 有
/// w ##class(web.DHCDocDiagnosNew).IsHaveMenuAuthDiagFav(29,"System.OEOrder.OrgFav.Save.SetSaveForUser")
ClassMethod IsHaveMenuAuthDiagFav(GroupId As %String, MenuName As %String) As %String
{
	Q:(GroupId="")||(MenuName="") 0
	s ret=0
	s masterMenuId=$o(^websys.MenuI("UniqueNameIndex"," SYSTEM.DIAGFAV.SAVE",0))
	Q:masterMenuId="" 0
	s MenuName=$zcvt(MenuName,"U")
	s menuId=$O(^websys.MenuI("UniqueNameIndex"," "_MenuName,0))
	Q:menuId="" 0
	
	Set rs=##Class(%ResultSet).%New("websys.Menu:SelectSubMenu")
	If rs.QueryIsValid() {
		Set Status=rs.Execute(masterMenuId,GroupId,1)
		If 'Status Quit
		While (rs.Next()) {
		    s HaveAuthMenuId=rs.GetData(1)
		    i HaveAuthMenuId=menuId s ret=1
		}
		d rs.Close()
	}
	
	Q ret
}

/// 保存诊断模板明细的ICD诊断备注
ClassMethod SaveTemplICDDiagNotes(TemplICDNotesJson As %String) As %String
{
	k TemplICDNotesArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(TemplICDNotesJson,.TemplICDNotesArr)
	s Counter=""
	for {
		s Counter=$O(TemplICDNotesArr(Counter)) Q:(Counter="")
		s DHCMRDiaICDRowid=TemplICDNotesArr(Counter,"DHCMRDiaICDRowid")
		s DHCMRDiaICDICDNotes=TemplICDNotesArr(Counter,"DHCMRDiaICDICDNotes")
		&sql(update SQLUSER.DHC_MRDiagnosICD set DHCMRDiaICD_Notes=:DHCMRDiaICDICDNotes where DHCMRDiaICD_Rowid=:DHCMRDiaICDRowid)
	}
	Q SQLCODE
}

}
