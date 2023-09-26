Import SQLUser

/// 按日期查询
Class web.DHCWMRXVolume Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 69;

ClassMethod BuildData(repid, ind, VolId)
{
	
	//n (repid,ind,VolId)
	s tmp=$g(^DHCWMRVOL(VolId))
	s MainId=$p(tmp,"^",1)
	s AdmId=$p(tmp,"^",2)
	
	s PatBaseInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainId)  //病人基本信息
	s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)               //病案信息
	s VolInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)                 //病案卷信息
	s ADMInfo=##class(web.DHCWMRBasePaadm).GetAdmInfo(AdmId)                //取就诊信息
	
	//病人基本信息
	For iBuild=1:1:27 Do
 	.Set $li(Data,iBuild)=$p(PatBaseInfo,"^",iBuild)
 	
 	//病案信息
 	For iBuild=28:1:37 Do
 	.Set $li(Data,iBuild)=$p(MainInfo,"^",iBuild-27)
 	set MrTypeId=$p(MainInfo,"^",2)
 	set:MrTypeId'="" MrType=$g(^DHCWMRDIC(MrTypeId))
 	set:MrTypeId="" MrType=""
 	set MrTypeDesc=$p(MrType,"^",3)
 	set $li(Data,38)=MrTypeDesc                        //MrTypeDesc
 	
 	//病案卷信息
 	set $li(Data,39)=$p(VolInfo,"^",1)                 //VolId
	set $li(Data,40)=$p(VolInfo,"^",3)                 //VPaadmId
	set $li(Data,41)=$p(VolInfo,"^",4)                 //VHistroyAdmId
	set StatusId=$p(VolInfo,"^",7)
	set $li(Data,42)=StatusId                          //VStatusId
	set:StatusId'="" $li(Data,43)=$p(^DHCWMRWITM(StatusId),"^",2)   //VStatusDesc
	set:StatusId="" $li(Data,43)=""
	set $li(Data,44)=$p(VolInfo,"^",8)                 //VIsActive
	set $li(Data,45)=$p(VolInfo,"^",9)                 //VInFlow
	set $li(Data,46)=$p(VolInfo,"^",10)                //VResumeText
	
	//就诊信息
	For iBuild=47:1:60 Do
	.set $li(Data,iBuild)=$p(ADMInfo,"^",iBuild-46)
	set ADMLoc=$p(ADMInfo,"^",7)
	set $li(Data,53)=$p(ADMLoc,"/",2)
	set ADMDoc=$p(ADMInfo,"^",8)
	set $li(Data,54)=$p(ADMDoc,"/",3)
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

/// update by liuxuefeng 2009-03-04 增加查询参数“MrType”
ClassMethod QueryVolByDate(JIndex, DateType, FromDate, ToDate, MrType, papmiNo)
{
	n (JIndex,DateType,FromDate,ToDate,MrType,papmiNo)
	s ret="",num=0
	
	q:(FromDate="")||(ToDate="") num
	
	s:FromDate["-" FromDate=$zdh(FromDate,3)
	s:ToDate["-" ToDate=$zdh(ToDate,3)
	s:FromDate["/" FromDate=$zdh(FromDate,4)
	s:ToDate["/" ToDate=$zdh(ToDate,4)
	s FromDate=+FromDate
	s ToDate=+ToDate
	s DateType=+DateType
	;^PAADMi("PAADM_AdmDate",{PAADM_AdmDate},{PAADM_RowID})
	;^PAADMi("DischDate",{PAADM_DischgDate},{PAADM_RowID})
	s:DateType=0 tmp="PAADM_AdmDate"      ;按入院日期(就诊日期)查询
	s:DateType=1 tmp="DischDate"          ;按出院日期查询
	k ^CacheTemp("VolList",JIndex) 
	
	if (papmiNo'=""){
		set papmiNo=$zcvt(papmiNo,"U")
		;^PAPERi("PAPMI_PatNo",$$ALPHAUP({PAPMI_No}),{PAPMI_RowId})
		set papmid=""
		set papmid=$o(^PAPERi("PAPMI_PatNo",papmiNo,papmid))
		
		q:(papmid="")!((papmid'="")&'$d(^PAPER(papmid))) num 
		;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
		set AdmID=""
		set AdmID=$o(^PAPERdr(papmid,"ADM","I",AdmID))
		q:(AdmID="")!((AdmID'="")&'$d(^PAADM(AdmID))) num
		set admDate=+$p($g(^PAADM(AdmID)),"^",6)  ;就诊日期
		set dischDate=+$p($g(^PAADM(AdmID)),"^",17) ;出院日期
		
		if (DateType=0){
			q:(admDate>ToDate)!(admDate<FromDate) num
		}elseif(DateType=1){
			q:(dischDate>ToDate)!(dischDate<FromDate) num
		}
		do GetWMRVol(MrType,AdmID)
	}
    else{
	   for Date=FromDate:1:ToDate {
	    Continue:'$d(^PAADMi(tmp,Date))
	    s AdmID=0
	    for  {
		  s AdmID=$o(^PAADMi(tmp,Date,AdmID)) 
		  q:AdmID=""  
	      do GetWMRVol(MrType,AdmID)
	    }
	   }
    }
	q num
GetWMRVol(MrType,AdmID)
     q:'$d(^DHCWMRVOL(0,"VolAdm",AdmID))
	 s VolID=0
	 for {
	   s VolID=$o(^DHCWMRVOL(0,"VolAdm",AdmID,VolID))
	   q:VolID="" 
	   Continue:'$d(^DHCWMRVOL(VolID))
	   Continue:$p($g(^DHCWMRVOL(VolID)),"^",7)'="Y"
	   s MainDr=$p($g(^DHCWMRVOL(VolID)),"^",1) 		;add by liuxuefeng 2009-03-04
	   Continue:'$d(^DHCWMRMAIN(MainDr))						;add by liuxuefeng 2009-03-04
	   s MrTypeDr=$p($g(^DHCWMRMAIN(MainDr)),"^",1) 	;add by liuxuefeng 2009-03-04
	   Continue:(MrType'="")&&(MrType'=MrTypeDr) 				;add by liuxuefeng 2009-03-04
	   s num=num+1
	   s ^CacheTemp("VolList",JIndex,VolID)=""
	 }
}

ClassMethod QueryByDateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByDateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryByDateExecute(ByRef qHandle As %Binary, DateType As %String, FromDate As %String, ToDate As %String, MrType As %String, papmiNo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	set ^CacheTemp("QueryByDateExecute")=DateType_","_FromDate_","_ToDate_","_MrType_","_papmiNo
	s JIndex=$j
	s ret=..QueryVolByDate(JIndex,DateType,FromDate,ToDate,MrType,papmiNo)
	q:+ret<1 $$$OK
	
	s VolID=0
	f  s VolID=$o(^CacheTemp("VolList",JIndex,VolID)) q:VolID=""  d
	.d ..BuildData(repid, ind, VolID)
	.s ind=ind+1
	
    k ^CacheTemp("VolList",JIndex)
    
    s Cnt=ind-1						;add by liuxuefeng 2009-10-21 页面输出列表总数
	w !,"数量:"_Cnt					;add by liuxuefeng 2009-10-21 页面输出列表总数
	
	Quit $$$OK
}

ClassMethod QueryByDateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByDateExecute ]
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

/// 按[入院日期/出院日期]查询[病案/卷]信息
/// DateType: 0--入院日期  1--出院日期
/// FromDate: 开始日期
/// ToDate:   结束日期
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRXVolume","QueryByDate","0","62434","62441","7","0000143731")
Query QueryByDate(DateType As %String, FromDate As %String, ToDate As %String, MrType As %String, papmiNo As %String) As %Query(ROWSPEC = "BaseId:%String,PatientName:%String,NameSpell:%String,Sex:%String,Birthday:%String,Age:%String,Wedlock:%String,Occupation:%String,City:%String,County:%String,Nation:%String,Nationality:%String,IdentityCode:%String,Company:%String,CompanyTel:%String,CompanyZip:%String,HomeAddress:%String,HomeTel:%String,HomeZip:%String,RelationDesc:%String,RelativeName:%String,RelativeTel:%String,RelativeAddress:%String,IsActive:%String,ResumeText:%String,Papmi:%String,PatientNO:%String,MainId:%String,MrTypeDr:%String,MRNO:%String,PapmiDr:%String,HistoryDR:%String,IsDead:%String,IsActive:%String,IsStayIn:%String,BuildDate:%String,ResumeText:%String,MrTypeDesc:%String,VolId:%String,VPaadmId:%String,VHistroyAdmId:%String,VStatusId:%String,VStatusDesc:%String,VIsActive:%String,VInFlow:%String,VResumeText:%String,paadm:%String,AdmType:%String,AdmNo:%String,AdmDate:%String,AdmTime:%String,papmi:%String,LocDesc:%String,DocDesc:%String,WardDesc:%String,RoomDesc:%String,BedDesc:%String,DischgDate:%String,DischgTime:%String,VisitStatus:%String")
{
}

}
