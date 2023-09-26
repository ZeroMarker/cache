Import SQLUser

/// 对病案主信息的查询
/// By wuqk 2007-03
Class web.DHCWMRMainQry Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 217;

ClassMethod BuildMainData(repid, ind, sTempMain, sPatInfo)
{
	n (repid,ind,sTempMain,sPatInfo)
	;s sTempMain=##class(web.DHCWMRMainCtl).GetMainById(+TempId)
	;s sTempMainRowid=$p(sTempMain,"^",1)
	s MrTypeDr=$p(sTempMain,"^",2)
	s MrTypeDesc=$p(##Class(web.DHCWMRDictionaryCtl).GetDataById(+MrTypeDr),"^",4)
	
	;s sPatInfo=##class(web.DHCWMRMainCtl).GetPatInfo(sTempMainRowid)
	Set Data=$lb("")
 	For iBuild=1:1:$l(sTempMain,"^") Do
 	.Set $li(Data,iBuild)=$p(sTempMain,"^",iBuild)
 	set:$p(sTempMain,"^",6)="Y" $li(Data,6)="死亡"
 	set:$p(sTempMain,"^",6)'="Y" $li(Data,6)=""
 	set:$p(sTempMain,"^",8)="Y" $li(Data,8)="已归架"
 	set:$p(sTempMain,"^",8)'="Y" $li(Data,8)=""
 	Set $li(Data,11)=$p(sPatInfo,"^",27)      ;PaNo
 	Set $li(Data,12)=$p(sPatInfo,"^",26)      ;PatientId
 	Set Name=$p(sPatInfo,"^",2)
 	Set $li(Data,13)=$g(Name)                 ;Name
 	Set $li(Data,14)=$p(sPatInfo,"^",4)       ;Sex
 	Set $li(Data,15)=MrTypeDesc               ;MrTypeDesc
 	Set $li(Data,16)=$p(sPatInfo,"^",5)       ;Birthday
 	Set $li(Data,17)=$p(sPatInfo,"^",14)       ;Company
 	Set $li(Data,18)=$p(sPatInfo,"^",13)       ;Identity
 	Set $li(Data,19)=$p(sPatInfo,"^",17)       ;Address
 	Set Age=""
 	Set BirthDay=$p(sPatInfo,"^",5)
	If BirthDay'="" Do
	.s BirthDay=$tr(BirthDay," ","")
	.s:BirthDay["-" BirthDay=$zdh(BirthDay,3)
	.s:BirthDay["/" BirthDay=$zdh(BirthDay,4)
	.s Age=##Class(web.DHCWMRBaseInfoCtl).CalAge(BirthDay,+$h)
	Set $li(Data,20)=Age
 	;^PAPERdr({PAADM_PAPMI_DR},"ADM",{PAADM_Type},{PAADM_RowID})
 	s paadm=$o(^PAPERdr($p(sPatInfo,"^",26),"ADM","I",""),-1)
 	set $li(Data,21)=paadm
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryByNoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByNoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByNoExecute(ByRef qHandle As %Binary, MrTypeDR As %String, PatientNo As %String, MrNO As %String, IsActive As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	If MrTypeDR="" Quit $$$OK
	//s ^ZF(0)=MrTypeDR_"^"_PatientNo_"^"_MrNO_"^"_IsActive
	;s MrNO=$$ALPHAUP^SSUTIL4($g(MrNO))             //add by zf 2008-04-14

	If PatientNo'="" {
	   s PatientId=$o(^PAPERi("PAPMI_PatNo",PatientNo,""),-1)
	   q:PatientId="" $$$OK
	   ;^DHCWMRMAIN(0,"PAPMI",{Papmi_Dr},{Rowid})
	   q:'$d(^DHCWMRMAIN(0,"PAPMI",PatientId)) $$$OK
	   
	   s TempId=""
	   f  s TempId=$o(^DHCWMRMAIN(0,"PAPMI",PatientId,TempId)) q:TempId=""  d
	   .s sTempMain=##class(web.DHCWMRMainCtl).GetMainById(+TempId)
	   .;s sPatInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(sTempMainRowid)
	   .q:sTempMain=""
	   .s sTempMrType=$p(sTempMain,"^",2)
	   .s sTempMrNo=$p(sTempMain,"^",3)
	   .s sTempIsActive=$p(sTempMain,"^",7)
	   .q:(sTempMrType'=MrTypeDR)
	   .q:(sTempMrNo'=MrNO)&(MrNO'="")
	   .q:(sTempIsActive'=IsActive)&(IsActive'="")
	   .s sTempMainRowid=$p(sTempMain,"^",1)
	   .;s sPatInfo=##class(web.DHCWMRMainCtl).GetPatInfo(sTempMainRowid)
	   .s sPatInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(sTempMainRowid)
	   .s s=..BuildMainData(repid,ind,sTempMain,sPatInfo)
	   .s ind=ind+1
		}
	Else{
		;modify by liuxuefeng 2009-07-01 页面传入的MrNo变为"^"分隔病案号集合
		q:MrNO="" $$$OK
		f i=1:1:$l(MrNO,"^")  d
		.s MrNoEach=$p(MrNO,"^",i)
		.q:$tr(MrNoEach," ","")=""
		.s MrNoEach=$$ALPHAUP^SSUTIL4($g(MrNoEach)) 
		.q:'$d(^DHCWMRMAIN(0,"TypeNO",MrTypeDR,MrNoEach))
		.;^DHCWMRMAIN(0,"TypeNO",{MrType},{MRNO},{Rowid})
	    .s TempId=""
	    .f  s TempId=$o(^DHCWMRMAIN(0,"TypeNO",MrTypeDR,MrNoEach,TempId)) q:TempId=""  d
	    ..s sTempMain=##class(web.DHCWMRMainCtl).GetMainById(+TempId)
	    ..q:sTempMain=""
	    ..s sTempMrType=$p(sTempMain,"^",2)
	    ..s sTempPatId=$p(sTempMain,"^",4)
	    ..s sTempIsActive=$p(sTempMain,"^",7)
	    ..q:(sTempMrType'=MrTypeDR)
	    ..q:(sTempIsActive'=IsActive)&(IsActive'="")
	    ..s sTempMainRowid=$p(sTempMain,"^",1)
	    ..;s sPatInfo=##class(web.DHCWMRMainCtl).GetPatInfo(sTempMainRowid)
	    ..s sPatInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(sTempMainRowid)
	    ..s s=..BuildMainData(repid,ind,sTempMain,sPatInfo)
	    ..s ind=ind+1
		}
	
	Quit $$$OK
}

ClassMethod QueryByNoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByNoExecute ]
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

/// Query: 根据登记号或病案号查询病案信息
Query QueryByNo(MrTypeDR As %String, PatientNo As %String, MrNO As %String, IsActive As %String) As %Query(ROWSPEC = "Rowid:%String,MrType_Dr:%String,MRNO:%String,Papmi_Dr:%String,History_DR:%String,IsDead:%String,IsActive:%String,IsStayIn:%String,BuildDate:%String,ResumeText:%String,PaNo:%String,PatientId:%String,Name:%String,Sex:%String,MrTypeDesc:%String,Birthday:%String,Company:%String,Identity:%String,Address:%String")
{
}

ClassMethod QueryByRowIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByRowIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByRowIdExecute(ByRef qHandle As %Binary, MainId As %String, VolId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:((MainId="")&&(VolId="")) $$$OK
	i VolId'="" d
	.s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	.s:MainId="" MainId=$p(VolumeInfo,"^",2)
	q:MainId="" $$$OK
	
	//VolID或MainID同样处理得MainID
	//s MainRowid=$p(RowID,"||",1)
	
	s MainInfo=$g(^DHCWMRMAIN(MainId))
	s IsMainActive=$p(MainInfo,"^",6)
	q:IsMainActive'="Y" $$$OK
	
	//病案信息
	s sTempMain=##class(web.DHCWMRMainCtl).GetMainById(MainId)
	//病人(病案)基本信息
	s sPatInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainId)
	q:((sTempMain="")&&(sPatInfo="")) $$$OK
	s s=..BuildMainData(repid,ind,sTempMain,sPatInfo)
	s ind=ind+1
	
	Quit $$$OK
}

ClassMethod QueryByRowIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByRowIdExecute ]
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

/// Query: 根据MainId或VolId查询病案信息
Query QueryByRowId(MainId As %String, VolId As %String) As %Query(ROWSPEC = "Rowid:%String,MrType_Dr:%String,MRNO:%String,Papmi_Dr:%String,History_DR:%String,IsDead:%String,IsActive:%String,IsStayIn:%String,BuildDate:%String,ResumeText:%String,PaNo:%String,PatientId:%String,Name:%String,Sex:%String,MrTypeDesc:%String,Birthday:%String,Company:%String,Identity:%String,Address:%String")
{
}

/// ClassMethod: 根据MainId或VolId查询病案信息
ClassMethod QueryMainByRowID(MainId, VolId)
{
	n (MainId,VolId)
	
	s ret=""
	q:((MainId="")&&(VolId="")) ret
	i VolId'="" d
	.s VolumeInfo=##class(web.DHCWMRVolumeCtl).GetVolume(VolId)
	.s:MainId="" MainId=$p(VolumeInfo,"^",2)
	q:MainId="" ret
	
	//VolID或MainID同样处理得MainID
	//s MainRowid=$p(RowID,"||",1)
	
	s MainInfo=$g(^DHCWMRMAIN(MainId))
	s IsMainActive=$p(MainInfo,"^",6)
	q:IsMainActive'="Y" ret
	
	//病案信息
	s sTempMain=##class(web.DHCWMRMainCtl).GetMainById(MainRowid)
	//病人(病案)基本信息
	s sPatInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainRowid)
	s sPatInfo=$tr(sPatInfo,"^","/")
	s ret=sTempMain_"^"_sPatInfo
	q ret
}

ClassMethod Test()
{
	Set PatientNo="00000000"
	If PatientNo'="" {
	   Set PatientId=$o(^PAPERi("PAPMI_PatNo",PatientNo,-1))
	   w !,"PatientId="_PatientId
	   q:PatientId=""
		}
	Else {
		
		}
	w !,"Over"
	q
}

ClassMethod QueryByPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryByPatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryByPatInfoExecute(ByRef qHandle As %Binary, MrTypeDR As %String, NameSpell As %String, Name As %String, Company As %String, Address As %String, Identity As %String, Sex As %String, Birthday As %String, AgeFrom As %String, AgeTo As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	;set ^TestDD("QueryByPatInfoExecute")=MrTypeDR_","_NameSpell_","_Name_","_Company_","_Address_","_Identity_","_Sex_","_Birthday_","_AgeFrom_","_AgeTo
	//Set ^ZF(11)=MrTypeDR_","_NameSpell_","_Name_","_Company_","_Address_","_Identity_","_Sex_","_Birthday_","_AgeFrom_","_AgeTo
	Set:Name'="" Name=$e(Name,1,$l(Name)-1)
	Set:Company'="" Company=$e(Company,1,$l(Company)-1)
	Set:Address'="" Address=$e(Address,1,$l(Address)-1)
	Set:Sex'="" Sex=$e(Sex,1,$l(Sex)-1)
	Set AgeFrom=$g(AgeFrom),AgeTo=$g(AgeTo)
	Quit:MrTypeDR="" $$$OK
	Set JIndex=$j
	Kill ^CacheTemp("DHCWMRHistory",JIndex)
	
	Set:Birthday["/" Birthday=$zdh(Birthday,4)
	Set:Birthday["-" Birthday=$zdh(Birthday,3)
	Set:Birthday'="" Birthday=$zd(+Birthday,3)
	Set:Birthday'="" Birthday=$p(Birthday,"-",1)_"-"_$p(Birthday,"-",2)
	
	/* update by zf 2010-07-05
	;Query History ->MainRowid  ^CacheTemp("DHCWMRHistory",JIndex)
	s JIndex=##class(web.DHCWMRHistoryCtl).QueryByNameSpell(JIndex, NameSpell)
	
	;Query VolInfo ->VolRowid ->MainRowid ^CacheTemp("DHCWMRVOLINFO",JIndex)
	s JIndex=##class(web.DHCWMRVolumeCtl).QueryByNameSpell(JIndex, NameSpell)
	update by zf 2010-07-05 */
	
    Set InputName=$$ALPHAUP^SSUTIL4(Name)
    s InputIdentity=$$ALPHAUP^SSUTIL4(Identity)_"Z"
    ;Quit:(Name="")||(InputName="") $$$OK
    
    If ((Name="")||(InputName="")) {
	    If (InputIdentity'=""){
			;^PAPERi("PAPMI_ICPPBC",$$ALPHAUP({PAPMI_ID})_"Z",{PAPMI_RowId})
			s Rowid=0
			For {
				Set Rowid=$o(^PAPERi("PAPMI_ICPPBC",InputIdentity,Rowid))
				Quit:Rowid=""
				Continue:'$d(^DHCWMRMAIN(0,"PAPMI",Rowid))
				Set MainID=0
				For {
					Set MainID=$o(^DHCWMRMAIN(0,"PAPMI",Rowid,MainID))
					Quit:MainID=""
					Set ^CacheTemp("DHCWMRHistory",JIndex,MainID)=""
				}
			}
			    
		}else{
	      Set MainRowid=0
	      For {
		     Set MainRowid=$o(^DHCWMRMAIN(MainRowid))
		     ;b  ;MainRowid
		     Quit:MainRowid=""
		     Set err=$$CheckOptions()
		     ;Write !,"err="_err_",MainRowid="_MainRowid
		     Set:err ind=ind+1
		  }
		}
	} Else {
		//^DHCWMRHISTORY(0,"PatientName",$$ALPHAUP({PatientName}),{Rowid})
	    Set PatName=$o(^DHCWMRHISTORY(0,"PatientName",InputName),-1)
	    For {
		    Set PatName=$o(^DHCWMRHISTORY(0,"PatientName",PatName))
		    Quit:(PatName="")||(PatName'[InputName)
		    Set Rowid=0
		    For {
			    Set Rowid=$o(^DHCWMRHISTORY(0,"PatientName",PatName,Rowid))
			    Quit:Rowid=""
			    Continue:'$d(^DHCWMRMAIN(0,"HISTORY",Rowid))
			    Set MainID=0
			    For {
				    Set MainID=$o(^DHCWMRMAIN(0,"HISTORY",Rowid,MainID))
				    Quit:MainID=""
				    Set ^CacheTemp("DHCWMRHistory",JIndex,MainID)=""
				}
			}
		}
		
		//^PAPERi("PAPER_PatName",$$ALPHAUP({PAPMI_Name}),{PAPMI_RowId})
		Set PatName=$o(^PAPERi("PAPER_PatName",InputName),-1)
		For {
			Set PatName=$o(^PAPERi("PAPER_PatName",PatName))
			Quit:(PatName="")||(PatName'[InputName)
			Set Rowid=0
			For {
				;b ;PatName
				Set Rowid=$o(^PAPERi("PAPER_PatName",PatName,Rowid))
				Quit:Rowid=""
				Continue:'$d(^DHCWMRMAIN(0,"PAPMI",Rowid))
				Set MainID=0
				For {
					Set MainID=$o(^DHCWMRMAIN(0,"PAPMI",Rowid,MainID))
					Quit:MainID=""
					Set ^CacheTemp("DHCWMRHistory",JIndex,MainID)=""
				}
			}
		}
		
		
	}
	Set MainRowid=""
	For {
		    Set MainRowid=$o(^CacheTemp("DHCWMRHistory",JIndex,MainRowid),-1)
		    Quit:MainRowid=""
		    Set err=$$CheckOptions()
		    ;Write !,"err="_err_",MainRowid="_MainRowid
		    Set:err ind=ind+1
		}
		
    Kill ^CacheTemp("DHCWMRHistory",JIndex)
    
    Set Cnt=ind-1
	Write !,"数量:"_Cnt
	Quit $$$OK
	
CheckOptions()
    ; Name, Company, Address, Identity, Sex, Birthday
    ; AdmDate, DisDate, LocDesc
    s err=0
    s sTempMain=##class(web.DHCWMRMainCtl).GetMainById(+MainRowid)
    q:sTempMain="" err
	s sTempMainRowid=$p(sTempMain,"^",1)
	s sTempMrType=$p(sTempMain,"^",2)
	s sTempPatId=$p(sTempMain,"^",4)
	s sTempIsActive=$p(sTempMain,"^",7)	
	q:(sTempIsActive'="Y") err
	q:(sTempMrType'=MrTypeDR) err
	
	s sPatInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(sTempMainRowid)
	s sTempSex=$p(sPatInfo,"^",4)
	s sTempName=$p(sPatInfo,"^",2)
	s sTempCompany=$p(sPatInfo,"^",14)
	s sTempAddress=$p(sPatInfo,"^",17)
	s sTempIdentity=$p(sPatInfo,"^",13)
	s sTempBirthday=$p(sPatInfo,"^",5)
	s sTempAge=""
	i sTempBirthday'="" d
	.s sTempBirthday=$tr(sTempBirthday," ","")
	.s:sTempBirthday["-" sTempBirthday=$zdh(sTempBirthday,3)
	.s:sTempBirthday["/" sTempBirthday=$zdh(sTempBirthday,4)
	.s sTempAge=##Class(web.DHCWMRBaseInfoCtl).CalAge(sTempBirthday,+$h)
	.s:sTempAge'="" sTempAge=$s($p(sTempAge,"岁",1)="":1,1:$p(sTempAge,"岁",1))
	q:(sTempName'[Name)&(sTempName'[InputName)&(Name'="") err
	q:(sTempCompany'[Company)&(Company'="") err
	q:(sTempAddress'[Address)&(Address'="") err
	q:(sTempIdentity'[Identity)&(Identity'="") err
	q:(sTempSex'[Sex)&(Sex'="") err
	q:(sTempBirthday'[Birthday)&(Birthday'="") err
	q:(sTempAge="")&&((AgeFrom'="")||(AgeTo'="")) err
	q:((sTempAge'="")&&(AgeFrom'="")&&((+sTempAge)<AgeFrom)) err
    q:((sTempAge'="")&&(AgeTo'="")&&((+sTempAge)>AgeTo)) err
	s s=..BuildMainData(repid,ind,sTempMain,sPatInfo)
	s err=1
	q err
}

ClassMethod QueryByPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryByPatInfoExecute ]
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

/// Query: 根据病人基本信息查询病案信息
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRMainQry","QueryByPatInfo",MrTypeDR,NameSpell,Name,Company,Address,Identity,Sex,Birthday)
Query QueryByPatInfo(MrTypeDR As %String, NameSpell As %String, Name As %String, Company As %String, Address As %String, Identity As %String, Sex As %String, Birthday As %String, AgeFrom As %String, AgeTo As %String) As %Query(ROWSPEC = "Rowid:%String,MrType_Dr:%String,MRNO:%String,Papmi_Dr:%String,History_DR:%String,IsDead:%String,IsActive:%String,IsStayIn:%String,BuildDate:%String,ResumeText:%String,PaNo:%String,PatientId:%String,Name:%String,Sex:%String,MrTypeDesc:%String,Birthday:%String,Company:%String,Identity:%String,Address:%String,Age:%String,LastPaadm:%String")
{
}

//********************************************

// 病案状态信息查询   2007-03 ZF

//********************************************

/// ClassMethod：根据MainId查询病案状态信息
ClassMethod MSGetDataByMainId(MainId)
{
	n (MainId)
	s ret=""	
	q:MainId="" ret
	q:'$d(^DHCWMRMAIN(MainId,"S")) ret
	s SubId=0 f  s SubId=$o(^DHCWMRMAIN(MainId,"S",SubId)) q:SubId=""  d
	.q:'$d(^DHCWMRMAIN(MainId,"S",SubId))
	.s Status=##class(web.DHCWMRMainCtl).GetMainStatus(MainId,SubId)
	.s:ret'="" ret=ret_$c(1)_Status
	.s:ret="" ret=Status
	q ret
}

ClassMethod MSBuildData(repid, ind, MainId, SubId)
{
	n (repid, ind, MainId,SubId)
	s Status=##class(web.DHCWMRMainCtl).GetMainStatus(MainId,SubId)
	
	s WorkItem=$p(Status,"^",2)
	s UserFrom=$p(Status,"^",3)
	s UserTo=$p(Status,"^",6)
	
	s $p(Status,"^",2)=$p(WorkItem,"/",1)
	s $p(Status,"^",3)=$p(UserFrom,"/",1)
	s $p(Status,"^",6)=$p(UserTo,"/",1)
	Set Data=$lb("")
 	For iBuild=1:1:$l(Status,"^") Do
 	.Set $li(Data,iBuild)=$p(Status,"^",iBuild)
 	
 	set $li(Data,7)=$p(UserFrom,"/",3)      ;UserFromDesc
 	set $li(Data,8)=$p(UserTo,"/",3)        ;UserToDesc
 	Set $li(Data,9)=$p(WorkItem,"/",2)      ;ItemTypeDr
 	set ItemTypeDesc=""
 	S:$p(WorkItem,"/",2)'="" ItemTypeDesc=$p(^DHCWMRDIC(+$p(WorkItem,"/",2)),"^",3)
 	Set $li(Data,10)=ItemTypeDesc           ;ItemTypeDesc
 	Set $li(Data,11)=$p(WorkItem,"/",3)     ;ItemDesc
 	Set $li(Data,12)=$p(WorkItem,"/",4)     ;ItemActive
 	Set $li(Data,13)=$p(WorkItem,"/",5)     ;ItemResume
 	Set $li(Data,14)=$p(WorkItem,"/",6)     ;SysOperDr
 	set SysOperDesc=""
 	set:$p(WorkItem,"/",6)'="" SysOperDesc=$p(^DHCWMRDIC(+$p(WorkItem,"/",6)),"^",3)
 	Set $li(Data,15)=SysOperDesc            ;SysOperDesc
 	
 	
 	;add by wuqk 2008-2-28 for request
 	s MSRowId=MainId_"||"_SubId
 	s sRequest=##class(web.DHCWMRRequest).GetLongReqByMS(MSRowId)
 	s ReqRowId=$p(sRequest,"^",1)
 	s ReqTypeDesc=$p($p(sRequest,"^",4),"/",4)
 	s reqWorkItemDesc=$p($p(sRequest,"^",5),"/",3)
 	s AimDate=$p(sRequest,"^",6)
 	s AimCtLocDesc=$p($p(sRequest,"^",7),"/",2)
 	s AimUserName=$p($p(sRequest,"^",8),"/",3)
 	s RequestDate=$p(sRequest,"^",10)
 	s RequestTime=$p(sRequest,"^",11)
 	s ResponseDate=$p(sRequest,"^",14)
 	s ResponseTime=$p(sRequest,"^",15)
 	s ResponseUserName=$p($p(sRequest,"^",16),"/",3)
 	s Paadm=$p(sRequest,"^",19)
 	
 	s (RegRowid,RegfeeDocId,RegfeeDoc,RegDate,RegTime,RegTimeRange)=""
 	;User.DHCRegisterationFee
    ;号别,挂号日期,挂号时间,时段
    s tmpPaadm=" "_Paadm
    i $d(^User.DHCRegistrationFeeI("ADM",tmpPaadm)) d
    .s RegRowid=$o(^User.DHCRegistrationFeeI("ADM",tmpPaadm,0))
    .q:RegRowid=""
    .s tmp=$g(^User.DHCRegistrationFeeD(RegRowid))
    .q:tmp=""
    .s RegfeeDocId=$list(tmp,14)
    .s:RegfeeDocId'="" RegfeeDoc=$p($g(^CTPCP(+RegfeeDocId,1)),"^",2)
    .s RegDate=$list(tmp,15)
    .s:RegDate'="" RegDate=$zd(+RegDate,3)
    .s RegTime=$list(tmp,16)
    .s:RegTime'="" RegTime=$zt(+RegTime,1)
    .s RegTimeRangeId=$list(tmp,21)
    .s:RegTimeRangeId'="" RegTimeRange=$p($g(^DHCTimeRange(+RegTimeRangeId)),"^",2)
    
 	Set $li(Data,16)=ReqRowId
 	Set $li(Data,17)=ReqTypeDesc
 	Set $li(Data,18)=reqWorkItemDesc
 	Set $li(Data,19)=AimDate
 	Set $li(Data,20)=AimCtLocDesc
 	Set $li(Data,21)=AimUserName
 	Set $li(Data,22)=ResponseDate
 	Set $li(Data,23)=ResponseTime
 	Set $li(Data,24)=ResponseUserName
 	Set $li(Data,25)=RequestDate     ;申请激活日期
 	Set $li(Data,26)=RequestTime     ;申请激活时间
 	Set $li(Data,27)=RegfeeDoc       ;号别
 	;   end by wuqk 
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod MSQueryByMainIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MSQueryByMainIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod MSQueryByMainIdExecute(ByRef qHandle As %Binary, MainId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	q:MainId="" $$$OK
	q:'$d(^DHCWMRMAIN(MainId,"S")) $$$OK
	//s SubId=0
	//f  s SubId=$o(^DHCWMRMAIN(MainId,"S",SubId)) q:SubId=""  d
	s SubId=""
	f  s SubId=$o(^DHCWMRMAIN(MainId,"S",SubId),-1) q:+SubId=0  d
	.q:'$d(^DHCWMRMAIN(MainId,"S",SubId))
	.d ..MSBuildData(repid,ind,MainId,SubId)
	.s ind=ind+1
	q $$$OK
}

ClassMethod MSQueryByMainIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MSQueryByMainIdExecute ]
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

/// Query：根据MainId查询病案状态信息
/// Query MSQueryByMainId(MainId As %String) As %Query(ROWSPEC = "MainStatusId:%String,WorkItemId:%String,UserFromId:%String,CurrDate:%String,CurrTime:%String,UserToId:%String,UserFromDesc:%String,UserToDesc:%String,ItemTypeId:%String,ItemTypeDesc:%String,WorkItemDesc:%String,WorkItemActive:%String,WorkItemResume:%String,SysOperDr:%String,SysOperDesc:%String")
Query MSQueryByMainId(MainId As %String) As %Query(ROWSPEC = "MainStatusId:%String,WorkItemId:%String,UserFromId:%String,CurrDate:%String,CurrTime:%String,UserToId:%String,UserFromDesc:%String,UserToDesc:%String,ItemTypeId:%String,ItemTypeDesc:%String,WorkItemDesc:%String,WorkItemActive:%String,WorkItemResume:%String,SysOperDr:%String,SysOperDesc:%String,ReqRowId:%String,ReqTypeDesc:%String,reqWorkItemDesc:%String,AimDate:%String,AimCtLocDesc:%String,AimUserName:%String,ResponseDate:%String,ResponseTime:%String,ResponseUserName:%String,RequestDate:%String,RequestTime:%String,RegfeeDoc:%String")
{
}

//********************************************

//病案附加项目明细查询 2007-03 ZF

//********************************************

/// ClassMethod：根据MainStatusId查询病案附加项信息
ClassMethod MSDGetDataByMainStatusId(MainStatusId)
{
	n (MainStatusId)
	s ret=""
	s ParId=$p(MainStatusId,"||",1)
	s SubId=$p(MainStatusId,"||",2)
	q:((ParId="")||(SubId="")) ret
	q:'$d(^DHCWMRMAIN(ParId,"S",SubId,"D")) ret
	s ChildId=0
	f  s ChildId=$o(^DHCWMRMAIN(ParId,"S",SubId,"D",ChildId)) q:ChildId=""  d
	.q:'$d(^DHCWMRMAIN(ParId,"S",SubId,"D",ChildId))
	.s StatusDtl=##class(web.DHCWMRMainCtl).GetMainStatusDtl(ParId,SubId,ChildId)
	.s WDId=$p(StatusDtl,"^",2)
	.s:WDId'="" WorkDetail=##class(web.DHCWMRWorkDetailCtl).GetDataById(WDId)
	.s WorkDetail=$tr(WorkDetail,"^","/")
	.s $p(StatusDtl,"^",2)=WorkDetail
	.s WILId=$p(StatusDtl,"^",5)
	.s:WILId'="" WorkItemList=##class(web.DHCWMRWorkItemCtl).SRGetDataById(WILId)
	.s WorkItemList=$tr(WorkItemList,"^","/")
	.s $p(StatusDtl,"^",5)=WorkItemList
	.s:ret'="" ret=ret_$c(1)_StatusDtl
	.s:ret="" ret=StatusDtl
	q ret
}

ClassMethod MSDBuildData(repid, ind, ParId, SubId, ChildId)
{
	n (repid, ind, ParId,SubId,ChildId)
	s StatusDtl=##class(web.DHCWMRMainCtl).GetMainStatusDtl(ParId,SubId,ChildId)
	
	//工作项目附加明细
	Set Data=$lb("")
 	For iBuild=1:1:$l(StatusDtl,"^") Do
 	.Set $li(Data,iBuild)=$p(StatusDtl,"^",iBuild)
 	
 	//工作项目附加项描述
	s WDId=$p(StatusDtl,"^",2)
	s:WDId'="" WorkDetail=##class(web.DHCWMRWorkDetailCtl).GetDataById(WDId)
 	Set $li(Data,6)=$p(WorkDetail,"^",2)     ;WDCode
 	Set $li(Data,7)=$p(WorkDetail,"^",3)     ;WDDesc
 	Set $li(Data,8)=$p(WorkDetail,"^",4)     ;WDDataType
 	Set $li(Data,9)=$p(WorkDetail,"^",5)     ;WDActive
 	Set $li(Data,10)=$p(WorkDetail,"^",6)    ;WDResume
 	Set $li(Data,11)=$p(WorkDetail,"^",7)    ;WDDicCode
 	
 	;Add by wuqk 2008-04-07 字典类型的附加项目取值
 	if $p(WorkDetail,"^",4)="Dictionary" d
 	.s ValueDr=$p(StatusDtl,"^",3)
 	.s sDic=##class(web.DHCWMRDictionaryCtl).GetDataById(ValueDr)
 	.s $li(Data,3)=$p(sDic,"^",4)
 	
 	//操作项目列表
	s WILId=$p(StatusDtl,"^",5)
	s:WILId'="" WorkItemList=##class(web.DHCWMRWorkItemCtl).SLGetDataById(WILId)
 	set $li(Data,12)=$p(WorkItemList,"^",3)  ;WILListIndex
 	Set $li(Data,13)=$p(WorkItemList,"^",4)  ;WILActive
 	Set $li(Data,14)=$p(WorkItemList,"^",5)  ;WILIsneed
 	set $li(Data,15)=$p(WorkItemList,"^",6)  ;WILResume
 	set $li(Data,16)=$p(WorkItemList,"^",7)  ;WILDefaultValue
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod MSDQueryByMainStatusIdClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MSDQueryByMainStatusIdExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod MSDQueryByMainStatusIdExecute(ByRef qHandle As %Binary, MainStatusId As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	s ParId=$p(MainStatusId,"||",1)
	s SubId=$p(MainStatusId,"||",2)
	q:((ParId="")||(SubId="")) $$$OK
	q:'$d(^DHCWMRMAIN(ParId,"S",SubId,"D")) $$$OK
	s ChildId=0 f  s ChildId=$o(^DHCWMRMAIN(ParId,"S",SubId,"D",ChildId)) q:ChildId=""  d
	.q:'$d(^DHCWMRMAIN(ParId,"S",SubId,"D",ChildId))
	.d ..MSDBuildData(repid, ind, ParId, SubId, ChildId)
	.s ind=ind+1
	q $$$OK
}

ClassMethod MSDQueryByMainStatusIdFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MSDQueryByMainStatusIdExecute ]
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

/// Query：根据MainStatusId查询病案附加项信息
Query MSDQueryByMainStatusId(MainStatusId As %String) As %Query(ROWSPEC = "MainStaDtlId:%String,WorkDtlId:%String,ItemValue:%String,Resume:%String,WorkItemListId:%String,WorkDtlCode:%String,WorkDtlDesc:%String,WorkDtlDataType:%String,WorkDtlActive:%String,WorkDtlResume:%String,WorkDtlDicCode:%String,WILIndex:%String,WILActive:%String,WILIsneed:%String,WILResume:%String,WILDefVal:%String")
{
}

/// 根据papmi查询病案信息
ClassMethod GetMainByPapmi(MrTypeDr, Papmi)
{
	n (MrTypeDr,Papmi)
	q:(Papmi="")!(MrTypeDr="") ""
	;^DHCWMRMAIN(0,"PAPMI",{Papmi_Dr},{Rowid})
	q:'$d(^DHCWMRMAIN(0,"PAPMI",Papmi)) ""
	s TempId="",OKFlag="",sTempMain=""
    f  s TempId=$o(^DHCWMRMAIN(0,"PAPMI",Papmi,TempId),-1) q:(TempId="")!(OKFlag="1")  d
	.s sTempMain=##class(web.DHCWMRMainCtl).GetMainById(+TempId)
	.i ($p(sTempMain,"^",7)="Y")&($p(sTempMain,"^",2)=MrTypeDr) d
	..s OKFlag="1"
	.e  d
	..s sTempMain=""
	q sTempMain
}

ClassMethod QueryStayOutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryStayOutExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QueryStayOutExecute(ByRef qHandle As %Binary, MrTypeDr As %String, IsStayIn As %String, WorkItemList As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	If MrTypeDr="" Quit $$$OK
	If IsStayIn="" Quit $$$OK
	
	/*
	q:'$d(^DHCWMRMAIN(0,"TypeStay",MrTypeDr,IsStayIn)) $$$OK
	s MainRowid=""
	f  s MainRowid=$O(^DHCWMRMAIN(0,"TypeStay",MrTypeDr,IsStayIn,MainRowid)) q:MainRowid=""  d
	.s sTempMain=##class(web.DHCWMRMainCtl).GetMainById(+MainRowid)
	.q:sTempMain=""
	.s sTempIsActive=$p(sTempMain,"^",7)
	.q:(sTempIsActive'="Y")
	.s sPatInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(+MainRowid)
	.s s=..BuildMainData(repid,ind,sTempMain,sPatInfo)
	.s ind=ind+1
	*/
	f index=1:1:$l(MrTypeDr,"^") d
	.s CurrMrType=$p(MrTypeDr,"^",index)
	.q:'$d(^DHCWMRMAIN(0,"TypeStay",CurrMrType,IsStayIn))
	.s MainId=0
	.f  s MainId=$o(^DHCWMRMAIN(0,"TypeStay",CurrMrType,IsStayIn,MainId)) q:MainId=""  d
	..s tmp=$g(^DHCWMRMAIN(MainId))
	..q:tmp=""
	..s tmpActive=$p(tmp,"^",6)
	..q:tmpActive'="Y"
	..;^DHCWMRMAIN({DHC_WMR_Main.Rowid},"S",{ChildSub})
	..s tmpSubId=$o(^DHCWMRMAIN(MainId,"S",""),-1)
	..s tmpStatus=$g(^DHCWMRMAIN(MainId,"S",tmpSubId))
	..s tmpWorkItem=$p(tmpStatus,"^",1)
	..q:(WorkItemList'="")&&(WorkItemList'[tmpWorkItem)
	..s s=$$xBuildData(repid,ind,MainId)
	..s ind=ind+1
	s Cnt=ind-1						;add by liuxuefeng 2009-07-17 页面输出列表总数
	w !,"数量:"_Cnt					;add by liuxuefeng 2009-07-17 页面输出列表总数
	Quit $$$OK
	
xBuildData(repid,ind,MainId)
	n (repid,ind,MainId)
	
	s MainInfo=##class(web.DHCWMRMainCtl).GetMainById(MainId)
	s MrTypeId=$p(MainInfo,"^",2)
	s MrType=##Class(web.DHCWMRDictionaryCtl).GetDataById(+MrTypeId)
	s PatInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainId)
	s Status="",Request=""
	;^DHCWMRMAIN({DHC_WMR_Main.Rowid},"S",{ChildSub})
	s ChildSub=$o(^DHCWMRMAIN(MainId,"S",""),-1)
	i ChildSub'="" d
	.s Status=##Class(web.DHCWMRMainCtl).GetMainStatus(MainId,ChildSub)
	.s StatusRowid=MainId_"||"_ChildSub
	.s Request=##class(web.DHCWMRRequest).GetLongReqByMS(StatusRowid)
	
	Set Data=$lb("")
	
	s Rowid=$p(MainInfo,"^",1)
	s MrTypeDr=$p(MainInfo,"^",2)
	s MRNO=$p(MainInfo,"^",3)
	s PapmiDr=$p(MainInfo,"^",4)
	s HistoryDR=$p(MainInfo,"^",5)
	s IsDead=$s($p(MainInfo,"^",6)="Y":"死亡",1:"")
	s IsActive=$p(MainInfo,"^",7)
	s IsStayIn=$s($p(MainInfo,"^",8)="Y":"已归架",1:"")
	s BuildDate=$p(MainInfo,"^",9)
	s ResumeText=$p(MainInfo,"^",10)
 	Set $li(Data,1)=Rowid
 	Set $li(Data,2)=MrTypeDr
 	Set $li(Data,3)=MRNO
 	Set $li(Data,4)=PapmiDr
 	Set $li(Data,5)=HistoryDR
 	Set $li(Data,6)=IsDead
 	Set $li(Data,7)=IsActive
 	Set $li(Data,8)=IsStayIn
 	Set $li(Data,9)=BuildDate
 	Set $li(Data,10)=ResumeText
 	
 	s MrTypeDesc=$p(MrType,"^",4)
 	s PaNo=$p(PatInfo,"^",27)
 	s PatientId=$p(PatInfo,"^",26)
 	s Name=$p(PatInfo,"^",2)
 	s Sex=$p(PatInfo,"^",4)
 	s Birthday=$p(PatInfo,"^",5)
 	s Company=$p(PatInfo,"^",14)
 	s Identity=$p(PatInfo,"^",13)
 	s Address=$p(PatInfo,"^",17)
 	Set $li(Data,11)=MrTypeDesc
 	Set $li(Data,12)=PaNo
 	Set $li(Data,13)=PatientId
 	Set $li(Data,14)=Name
 	Set $li(Data,15)=Sex
 	Set $li(Data,16)=Birthday
 	Set $li(Data,17)=Company
 	Set $li(Data,18)=Identity
 	Set $li(Data,19)=Address
	
	s StatusId=$p(Status,"^",1)
	s Item=$p(Status,"^",2)
	s ItemId=$p(Item,"/",1)
	s ItemDesc=$p(Item,"/",3)
	s ItemTpId=$p(Item,"/",2)
	s ItemTpDesc=$p($g(^DHCWMRDIC(+ItemTpId)),"^",3)
	s ItemActive=$p(Item,"/",4)
	s ItemResume=$p(Item,"/",5)
	s ItemOperId=$p(Item,"/",6)
	s ItemOperDesc=$p($g(^DHCWMRDIC(+ItemOperId)),"^",3)
	s CheckUser=$p(Item,"/",7)
	s BeRequest=$p(Item,"/",8)
	s UserFrom=$p(Status,"^",3)
	s UserFromId=$p(UserFrom,"/",1)
	s UserFromDesc=$p(UserFrom,"/",3)
	s CurrDate=$p(Status,"^",4)
	s CurrTime=$p(Status,"^",5)
	s UserTo=$p(Status,"^",6)
	s UserToId=$p(UserTo,"/",1)
	s UserToDesc=$p(UserTo,"/",3)
 	set $li(Data,20)=StatusId
 	set $li(Data,21)=ItemId
 	set $li(Data,22)=ItemDesc
 	set $li(Data,23)=ItemTpId
 	set $li(Data,24)=ItemTpDesc
 	Set $li(Data,25)=ItemActive
 	Set $li(Data,26)=ItemResume
 	Set $li(Data,27)=ItemOperId
 	Set $li(Data,28)=ItemOperDesc
 	Set $li(Data,29)=CheckUser
 	Set $li(Data,30)=BeRequest
 	Set $li(Data,31)=UserFromId
 	Set $li(Data,32)=UserFromDesc
 	set $li(Data,33)=CurrDate
 	set $li(Data,34)=CurrTime
 	Set $li(Data,35)=UserToId
 	Set $li(Data,36)=UserToDesc
 	
 	s ReqRowId=$p(Request,"^",1)
 	s ReqTypeDesc=$p($p(Request,"^",4),"/",4)
 	s ReqWorkItemDesc=$p($p(Request,"^",5),"/",3)
 	s AimDate=$p(Request,"^",6)
 	s AimCtLocDesc=$p($p(Request,"^",7),"/",2)
 	s AimUserName=$p($p(Request,"^",8),"/",3)
 	s ResponseDate=$p(Request,"^",14)
 	s ResponseTime=$p(Request,"^",15)
 	s ResponseUserName=$p($p(Request,"^",16),"/",3)
    
 	Set $li(Data,37)=ReqRowId
 	Set $li(Data,38)=ReqTypeDesc
 	Set $li(Data,39)=ReqWorkItemDesc
 	Set $li(Data,40)=AimDate
 	Set $li(Data,41)=AimCtLocDesc
 	Set $li(Data,42)=AimUserName
 	Set $li(Data,43)=ResponseDate
 	Set $li(Data,44)=ResponseTime
 	Set $li(Data,45)=ResponseUserName
 	
 	;User.DHCRegisterationFee
    ;号别,挂号日期,挂号时间,时段
    s (RegRowid,RegfeeDocId,RegfeeDoc,RegDate,RegTime,RegTimeRangeId,RegTimeRange)=""
    s Paadm=$p(Request,"^",19)
    s tmpPaadm=" "_Paadm
    i $d(^User.DHCRegistrationFeeI("ADM",tmpPaadm)) d
    .s RegRowid=$o(^User.DHCRegistrationFeeI("ADM",tmpPaadm,0))
    .q:RegRowid=""
    .s tmp=$g(^User.DHCRegistrationFeeD(RegRowid))
    .q:tmp=""
    .s RegfeeDocId=$list(tmp,14)
    .s:RegfeeDocId'="" RegfeeDoc=$p($g(^CTPCP(+RegfeeDocId,1)),"^",2)
    .s RegDate=$list(tmp,15)
    .s:RegDate'="" RegDate=$zd(+RegDate,3)
    .s RegTime=$list(tmp,16)
    .s:RegTime'="" RegTime=$zt(+RegTime,2)
    .s RegTimeRangeId=$list(tmp,21)
    .s:RegTimeRangeId'="" RegTimeRange=$p($g(^DHCTimeRange(+RegTimeRangeId)),"^",2)
    
    Set $li(Data,46)=RegRowid
 	Set $li(Data,47)=RegfeeDoc
 	Set $li(Data,48)=RegDate
 	Set $li(Data,49)=RegTime
 	Set $li(Data,50)=RegTimeRange
 	
 	Set ^CacheTemp(repid,ind)=Data
	q Data
}

ClassMethod QueryStayOutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryStayOutExecute ]
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

/// 查询不在架的病案列表
/// by zf 2008-04-08 Update
/// d ##Class(%ResultSet).RunQuery("web.DHCWMRMainQry","QueryStayOut",6,"N")
Query QueryStayOut(MrTypeDr As %String, IsStayIn As %String, WorkItemList As %String) As %Query(ROWSPEC = "Rowid:%String,MrType_Dr:%String,MRNO:%String,Papmi_Dr:%String,History_DR:%String,IsDead:%String,IsActive:%String,IsStayIn:%String,BuildDate:%String,ResumeText:%String,MrTypeDesc:%String,PaNo:%String,PatientId:%String,Name:%String,Sex:%String,Birthday:%String,Company:%String,Identity:%String,Address:%String,StatusId:%String,ItemId:%String,ItemDesc:%String,ItemTpId:%String,ItemTpDesc:%String,ItemActive:%String,ItemResume:%String,ItemOperId:%String,ItemOperDesc:%String,CheckUser:%String,BeRequest:%String,UserFromId:%String,UserFromDesc:%String,CurrDate:%String,CurrTime:%String,UserToId:%String,UserToDesc:%String,ReqRowId:%String,ReqTypeDesc:%String,ReqWorkItemDesc:%String,AimDate:%String,AimCtLocDesc:%String,AimUserName:%String,ResponseDate:%String,ResponseTime:%String,ResponseUserName:%String,RegRowid:%String,RegfeeDoc:%String,RegDate:%String,RegTime:%String,RegTimeRange:%String")
{
}

/// add by zf 2008-04-23
/// 根据病人基本信息查询是否建病案
/// w ##Class(web.DHCWMRMainQry).QueryMRByPatInfo(6,"LIJING","李静","","","","","")
ClassMethod QueryMRByPatInfo(MrTypeDR, NameSpell, Name, Company, Address, Identity, Sex, Birthday)
{
	n (MrTypeDR, NameSpell, Name, Company, Address, Identity, Sex, Birthday)
	s ret=""
	q:MrTypeDR="" ret
	q:NameSpell="" ret
	
	s JIndex=$j
	k ^CacheTemp("DHCWMRHistory",JIndex)
	
	;Query History ->MainRowid  ^CacheTemp("DHCWMRHistory",JIndex)
	s JIndex=##class(web.DHCWMRHistoryCtl).QueryByNameSpell(JIndex, NameSpell)
	
	;Query VolInfo ->VolRowid ->MainRowid ^CacheTemp("DHCWMRVOLINFO",JIndex)
	s JIndex=##class(web.DHCWMRVolumeCtl).QueryByNameSpell(JIndex, NameSpell)
	
	;CheckOptions
	
	s MainRowid="",TMP=""
    f  s MainRowid=$o(^CacheTemp("DHCWMRHistory",JIndex,MainRowid),-1) q:MainRowid=""  d
	.s xMain=##class(web.DHCWMRMainCtl).GetMainById(+MainRowid)
    .q:xMain=""
	.s xMainRowid=$p(xMain,"^",1)
	.s xMrType=$p(xMain,"^",2)
	.s xMrNo=$p(xMain,"^",3)
	.s xPatId=$p(xMain,"^",4)
	.s xIsActive=$p(xMain,"^",7)	
	.q:(xIsActive'="Y")
	.q:(xMrType'=MrTypeDR)
	.
	.s xPatInfo=##class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(xMainRowid)
	.s xSex=$p(xPatInfo,"^",4)
	.s xName=$p(xPatInfo,"^",2)
	.s xBirthday=$p(xPatInfo,"^",5)
	.s xCompany=$p(xPatInfo,"^",14)
	.s xAddress=$p(xPatInfo,"^",17)
	.s xIdentity=$p(xPatInfo,"^",13)
	.s xBirthday=$tr(xBirthday," ","")
	.//s xAge=""
	.//i xBirthday'="" d
	.//.s:xBirthday["-" xBirthday=$zdh(xBirthday,3)
	.//.s:xBirthday["/" xBirthday=$zdh(xBirthday,4)
	.//.s xAge=##Class(web.DHCWMRBaseInfoCtl).CalAge(xBirthday,+$h)
	.q:(xName'[Name)&(Name'="")
	.q:(xCompany'[Company)&(Company'="")
	.q:(xAddress'[Address)&(Address'="")
	.q:(xIdentity'[Identity)&(Identity'="")
	.q:(xSex'[Sex)&(Sex'="")
    .q:(xBirthday'=Birthday)&(Birthday'="")
    .//q:(AgeFrom'="")&((xAge="")||((+xAge)<AgeFrom))
    .//q:(AgeTo'="")&((xAge="")||((+xAge)>AgeTo))
    .s TMP=TMP_$c(1)_xMrNo_"^"_xName_"^"_xBirthday_"^"_xSex_"^"_xAddress_"^"_xCompany_"^"_xIdentity
    
    s:TMP'="" ret=$e(TMP,2,$l(TMP))
    k ^CacheTemp("DHCWMRHistory",JIndex)
    q ret
}

}
