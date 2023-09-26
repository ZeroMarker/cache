Import SQLUser

Class web.DHCMedEpidemicCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 123;

ClassMethod GetMEPD(MEPDRowid)
{
	n (MEPDRowid)
	q:MEPDRowid="" ""
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s sMEPD=$$GetMEPD^DHCMedEpidemic(MEPDRowid)
	zn CurrentNS
	s papmi=+$p(sMEPD,"^",2)
	s sPatInfo=##class(web.DHCMedBaseCtl).GetPatInfo(papmi)
	///区域
	s:$p(sMEPD,"^",3)'="" $p(sMEPD,"^",3)=$p(sMEPD,"^",3)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicReportRegion",$p(sMEPD,"^",3))
	///职业
	s:$p(sMEPD,"^",4)'="" $p(sMEPD,"^",4)=$p(sMEPD,"^",4)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("Career",$p(sMEPD,"^",4))
	///ICD
	///s:$p(sMEPD,"^",6)'="" $p(sMEPD,"^",6)=$p(sMEPD,"^",2)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicReportRegion",$p(sMEPD,"^",6))
	///密切接触情况
	s:$p(sMEPD,"^",7)'="" $p(sMEPD,"^",7)=$p(sMEPD,"^",7)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicContact",$p(sMEPD,"^",7))
	///诊断程度
	s:$p(sMEPD,"^",10)'="" $p(sMEPD,"^",10)=$p(sMEPD,"^",10)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicDiagnoseDegree",$p(sMEPD,"^",10))
	///发病性质
	s:$p(sMEPD,"^",12)'="" $p(sMEPD,"^",12)=$p(sMEPD,"^",12)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicSickQuality",$p(sMEPD,"^",12))
	///报告位置
	s:$p(sMEPD,"^",15)'="" $p(sMEPD,"^",15)=$p(sMEPD,"^",15)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("RepPlace",$p(sMEPD,"^",15))
	///报告运行状态
	s:$p(sMEPD,"^",16)'="" $p(sMEPD,"^",16)=$p(sMEPD,"^",16)_"/"_##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicReportStatus",$p(sMEPD,"^",16))
	
	s sICD=##class(web.DHCMedDictoryCtl).GetInfection(+$p(sMEPD,"^",6))
	
	s s=sMEPD_$c(1)_sPatInfo_$c(1)_sICD
    q s
}

/// Modi by cjb 2009-03-24 for 为上报传染病时自动插入一条医嘱名称为“传染病上报“
ClassMethod UpdateEPD(Instring)
{
	n (Instring)
	/*
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$UpdateEPD^DHCMedEpidemic(Instring)
	zn CurrentNS
	*/
		Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    s ret=""
    Tstart
	zn MEDDATA
	s ret=$$UpdateEPD^DHCMedEpidemic(Instring)
	//取医嘱项设置
	//^DHCMedHosptial(0)第6位设置传染病医嘱项Rowid
	s ArcimConfig=$P($$GetDefaultHosp^DHCMedBase01(),"/",6)
	s ArcimId=$P(ArcimConfig,"^",2)
	s HospCode=$P($$GetDefaultHosp^DHCMedBase01(),"/",4)
	zn CurrentNS
    //向医嘱表插入一条传染病医嘱
    s MEPDRowid=$p(Instring,"^",1)      //传染RowId
	i ((HospCode="NingXia_FY")&&(ArcimId'="")&&(MEPDRowid="")) d
	.s ArcimRet=..UpdateOPCashier(Instring,ArcimId)
	.i ArcimRet'=0 TRollback
	Tcommit
	
	q ret
}

/// Add by cjb 2009-03-24 for 为上报传染病时自动插入一条医嘱名称为“传染病上报“
ClassMethod UpdateOPCashier(Instring As %String, ArcimId As %String) As %String
{
	n (Instring,ArcimId)
	s AdmRowId=$p(Instring,"^",30)              //就诊号
	q:'$d(^PAADM(AdmRowId)) 1
	
	//##Class(web.DHCOPCashier).Insert(AdmRowId,ordstr,user,AdmDep,"","") 
	s AdmReason=$P(^PAADM(AdmRowId,1),"^",7)    //就诊费别
	s AdmDep=$P(^PAADM(AdmRowId),"^",4)         //就诊科室
	s AdmDate=$P(^PAADM(AdmRowId),"^",6)        //就诊日期
	s AdmTime=$p(^PAADM(AdmRowId),"^",7)        //就诊时间
	
	s Ordstr=ArcimId_"^"_"1"_"^"_AdmDep_"^"_0_"^"_""_"^"_AdmReason_"^"_AdmDate_"^"_AdmTime
	s UsrDr=$p(Instring,"^",17)                 //报告人
	
	s ret=##Class(web.DHCOPCashier).Insert(AdmRowId,Ordstr,UsrDr,AdmDep,"","")
	;w "ret="_AdmRowId_",Ordstr="_Ordstr_",UsrDr="_UsrDr_",AdmDep="_AdmDep,!
	q ret
}

/// Modi by cjb 2009-05-25 for 判断上报传染病时同一种疾病半年是否已经上报
ClassMethod CheckEPDICD(Instring As %String) As %String
{
	n (Instring)
	s ret=1                         //ret=1 同疾病报告半年内不存在 ret=0反之
	s EPDRowid=$p(Instring,"^",1)      //EPDRowid
    s Papmi=$p(Instring,"^",2)      //Pa_PatMas.Rowid
    s ICDRowid=$p(Instring,"^",6)   //疾病rowid
    q:(Papmi="")!(ICDRowid="") ret
    s RepDate=$p(Instring,"^",18)      ;MEPD_RepDate
    s:RepDate'="" RepDate=$zdh(RepDate,3) //报告日期
    s:RepDate="" RepDate=+$h
    s Rowid=""
    f  s Rowid=$o(^DHCMEPD("0","PAPMIICD",Papmi,ICDRowid,Rowid)) q:(Rowid="")!(ret<1)  d
    .q:($p(^DHCMEPD(Rowid),"^",15)="00")||($p(^DHCMEPD(Rowid),"^",15)="10")
    .q:Rowid=EPDRowid
    .s tmpRepDate=+$p(^DHCMEPD(Rowid),"^",17)
    .s:(RepDate-tmpRepDate<133) ret=0
	q ret
}

ClassMethod UpdateCheckEPD(MEPDRowid, Status, CheckUsr, CheckDate, CheckTime, Demo)
{
	n (MEPDRowid,Status,CheckUsr,CheckDate,CheckTime,Demo)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$UpdateCheckEPD^DHCMedEpidemic(MEPDRowid,Status,CheckUsr,CheckDate,CheckTime,Demo)
	zn CurrentNS
	q ret
}

ClassMethod UpdateEpidemicSub(Instring)
{
	n (Instring)
	s iCount=$l(Instring,$c(1))-1
	q:iCount<1 -1
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	d BeginTran^DHCMedBase
	s flag=0
	f Index=1:1:iCount q:flag'=0  d
	.s subString=$p(Instring,$c(1),Index)
	.s ParRef=+subString
	.s ret=$$UpdateEpidemicSub^DHCMedEpidemic(subString)
	.s:+ret'=ParRef flag=ret
	.s:$l(ret,"||")'=2 flag=ret
	i flag'=0 d RollBack^DHCMedBase
	i flag=0 d Commit^DHCMedBase
	zn CurrentNS
	q flag
}

ClassMethod GetAppendixCode(EpdRowid)
{
	n (EpdRowid)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    s ItemString=""
    zn MEDDATA
    s EpdString=$$GetMEPD^DHCMedEpidemic(EpdRowid)
    s ICDDR=$p(EpdString,"^",6)
    s ICDString=$$GetData^DHCMedInfection(ICDDR)
    s AppendixCode=+$p(ICDString,"^",6)
	zn CurrentNS
	q AppendixCode
}

ClassMethod CheckAppSub(EpdRowid)
{
	n (EpdRowid)
	s Flag=""
	s:$d(^DHCMEPD(EpdRowid,"I")) Flag="1"
	q Flag
}

ClassMethod QueryAppendixClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAppendixExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryAppendixExecute(ByRef qHandle As %Binary, MepdRowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s EpdRowid=MepdRowid
	Quit:EpdRowid="" $$$OK
	//s:EpdRowid="" EpdRowid="17"
    /*
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    zn MEDDATA
    zn CurrentNS
    */
	s:$d(^DHCMEPD(EpdRowid,"I")) ind=..GetEpidemicSub(repid,ind,EpdRowid)
	s:'$d(^DHCMEPD(EpdRowid,"I")) ind=..GetAppendixItem(repid,ind,EpdRowid)
	
	;s ind=..GetAppendixItem(repid,ind,EpdRowid)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildData      
	;set Data=$lb(id,code,desc,Fpfl,Lb)	
	set Data=$lb("")
	;s:$p(s,"^",4)'="" $p(s,"^",4)=##class(web.DHCMedDictoryCtl).GetByTypeCode("EpidemicPatientType",$p(s,"^",4))
	
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild) 	
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryAppendixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAppendixExecute ]
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

Query QueryAppendix(MepdRowid As %String) As %Query(ROWSPEC = "ChildSub:%String,ItemValue:%String,ItemDesc:%String,DataType:%String,DicType:%String,DateTypeDesc:%String,Requre:%String,DicRowid:%String,iRow:%String")
{
}

ClassMethod GetEpidemicSub(repid, ind, EpdRowid)
{
	n (repid,ind,EpdRowid)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    s ItemString=""
    zn MEDDATA
	s num=$$GetEpidemicSub^DHCMedEpidemic(EpdRowid)
	f Index=0:1:num d
	.s tmpSting=PLIST(Index)
	.;s=ParRef_"||"_+sub_$c(2)_MDicDr_$c(2)_Val_$c(2)_$$GetDataById^DHCMedDictory(MDicDr)
	.;MDIC_Rowid^MDIC_Code^MDIC_Desc^MDIC_Type^MDIC_Active^MDIC_DateFrom^MDIC_DateTo^MDIC_StrA^MDIC_StrB^MDIC_StrC^MDIC_StrD^
	.s sub=$p($p(tmpSting,$c(2),1),"||",2)
	.s val=$p(tmpSting,$c(2),3)
	.s DicString=$p(tmpSting,$c(2),4)
	.s DicRwoid=$p(DicString,"^",1)
	.s ItemDesc=$p(DicString,"^",3)
	.s DataTypeCode=$p(DicString,"^",8)
	.s DicType=$p(DicString,"^",9)
	.s Requre=$p(DicString,"^",11)
	.s DataTypeString=$$QueryByTypeCode^DHCMedDictory("EpidemicAppendixDataType",DataTypeCode)
	.s DataTypeDesc=$p(DataTypeString,"^",3)
	.s s=sub_"^"_val_"^"_ItemDesc_"^"_DataTypeCode_"^"_DicType_"^"_DataTypeDesc_"^"_Requre_"^"_DicRwoid
	.s ItemString=ItemString_s_$c(1)
	zn CurrentNS
	f iRow=1:1:($l(ItemString,$c(1))-1) d
	.s s=$p(ItemString,$c(1),iRow)
	.s err=..BuildAppendixData(repid,ind,s)
	.s ind=ind+1
    q ind
}

ClassMethod GetAppendixItem(repid, ind, EpdRowid)
{
	n (repid,ind,EpdRowid)
	s AppendixCode=..GetAppendixCode(EpdRowid)
	q:AppendixCode=0 0
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
    s ItemString=""
    zn MEDDATA
    s num=$$GetAppendixCard^DHCMedAppendixCard("")
    s CardRowid=""
    f Index=0:1:num d
    .s CardInfo=PLIST(Index)
    .s:AppendixCode=$p(CardInfo,"^",2) CardRowid=+$p(CardInfo,"^",1)
    i CardRowid>0 d
    .s ItemNum=$$GetAppendixItm^DHCMedAppendixCard(CardRowid)
    .f subIndex=0:1:ItemNum d
    ..s subString=PLIST(subIndex)
    ..;MACRowid_"||"_sub_$c(2)_DicDR_$c(2)_ActiveFlag_$c(2)_$$GetDataById^DHCMedDictory(DicDR)
    ..s sub=""
	..s val=""
	..s DicString=$p(subString,$c(2),4)
	..s DicRwoid=$p(DicString,"^",1)
	..s ItemDesc=$p(DicString,"^",3)
	..s DataTypeCode=$p(DicString,"^",8)
	..s DicType=$p(DicString,"^",9)
	..s Requre=$p(DicString,"^",11)
	..s DataTypeString=$$QueryByTypeCode^DHCMedDictory("EpidemicAppendixDataType",DataTypeCode)
	..s DataTypeDesc=$p(DataTypeString,"^",3)
	..s s=sub_"^"_val_"^"_ItemDesc_"^"_DataTypeCode_"^"_DicType_"^"_DataTypeDesc_"^"_Requre_"^"_DicRwoid
	..s ItemString=ItemString_s_$c(1)

	zn CurrentNS
	f iRow=1:1:($l(ItemString,$c(1))-1) d
	.s s=$p(ItemString,$c(1),iRow)
	.s err=..BuildAppendixData(repid,ind,s)
	.s ind=ind+1
    q ind
}

ClassMethod BuildAppendixData(repid, ind, s)
{
	n (repid,ind,s)
    set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	s $li(Data,$l(s,"^")+1)=ind 	
 	Set ^CacheTemp(repid,ind)=Data
 	q 0
}

ClassMethod SetDicData(Active) As %String
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
    .Write "<select id='"_itmName_"' name='"_itmName_"' size=1 "_Active_" style='WIDTH: 200px; HEIGHT: 24px'>"
	.i Requre'="1" Write "<option  value=''></option>"
	.s temp=##class(web.DHCMedDictoryCtl).GetByType(DicType,"Y")
	.f Index=1:1:($l(temp,$c(1))-1) d
	..s s=$p(temp,$c(1),Index)
	..s code=$p(s,"^",2)
	..s desc=$p(s,"^",3)
	..If code=Val Write "<option value="_code_" selected>"_desc_"</option>"
	..Else  Write "<option value="_code_">"_desc_"</option>"
	.Write "</select>"
    e  d
    .i DataType="5" d
    ..s tmpCHECKED=$s(Val["Y":"CHECKED",1:"")
    ..Write "<input id='"_itmName_"' name='"_itmName_"' "_tmpCHECKED_" type='checkbox' "_Active_">"
    ..//Write "<input id='"_itmName_"' name='"_itmName_"' "_Active
	..//Write " style='WIDTH: 200px; HEIGHT: 24px' value='"_val_"'>"
	..;Write "<IMG id='i"_itmName_"' name='i"_itmName_"'  src='../images/websys/lookupdate.gif'>"
    .e  i DataType="3" d
    ..Write "<input id='"_itmName_"' name='"_itmName_"' "_Active_" style='WIDTH: 200px; HEIGHT: 24px' value='"_Val_"' onClick='popup(this)'>"
    .e  d
    ..Write "<input id='"_itmName_"' name='"_itmName_"' "_Active_" style='WIDTH: 200px; HEIGHT: 24px' value='"_Val_"'>"
 	q ""
}

/*******************************************
/CheckPaadm：历次就诊传染病WEB环境监控
/            监控传染病发病情况和传染病上报情况
/            监控方向（诊断、辅检、传染病报告、死亡报告）
/入参：      Paadm
/返回：      字符串描述（例：霍乱  Y;伤寒  N;）
/            为空则非传染病
********************************************/
ClassMethod CheckPaadm(Paadm As %String) As %String
{
	n (Paadm)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$XPaadm^DHCMedEpidemicCtl(MEDDATA,LABDATA,Paadm)
	zn CurrentNS
	quit ret
}

/*******************************************
/CheckCurrPaadm：  当次就诊传染病WEB环境监控
/                  监控传染病发病情况和传染病上报情况
/                  监控方向（诊断、传染病报告）
/入参：            Paadm
/返回：            字符串描述
/                  为空则非传染病
********************************************/
ClassMethod CheckCurrPaadm(Paadm As %String) As %String
{
	n (Paadm)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$YPaadm^DHCMedEpidemicCtl(MEDDATA,LABDATA,Paadm)
	zn CurrentNS
	quit ret
}

/*******************************************
/CheckPaadmAA：历次就诊传染病WEB环境监控
/            监控传染病发病情况和传染病上报情况
/            监控方向（诊断、辅检、传染病报告、确诊诊断）
/入参：      Paadm
/返回：      字符串描述（例：霍乱  Y;伤寒  N;）
/            为空则非传染病
/w ##Class(web.DHCMedEpidemicCtl).CheckPaadmAA(2065)
********************************************/
ClassMethod CheckPaadmAA(Paadm As %String) As %String
{
	n (Paadm)
	Set Config=##Class(websys.Configuration).%OpenId(1)
    Set MEDDATA=Config.DataNamespace
    Set LABDATA=Config.LabDataNamespace
    Set CurrentNS=$ZNSPACE
    d Config.%Close()
	zn MEDDATA
	s ret=$$ZPaadm^DHCMedEpidemicCtl(MEDDATA,LABDATA,CurrentNS,Paadm)
	zn CurrentNS
	quit ret
}

/*******************************************
/CheckCurrPaadmAA：判断当次就诊有没有上报传染病报告
/入参：      Paadm
/返回：      Y/N
/w ##Class(web.DHCMedEpidemicCtl).CheckCurrPaadmAA(2065)
********************************************/
ClassMethod CheckCurrPaadmAA(Paadm As %String) As %String
{
	n (Paadm)
	s ret="No"
	q:Paadm="" ret
	;^DHCMEPD(0,"PAADM",{MEPD_TEXT1},{MEPD_Rowid})
	s Rowid=0
	f  s Rowid=$o(^DHCMEPD(0,"PAADM",Paadm,Rowid)) q:Rowid=""  d
	.q:'$d(^DHCMEPD(Rowid))
	.s ret="Yes"
	q ret
}

}
