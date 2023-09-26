Class web.DHCPE.PreIADMEx Extends %Persistent
{

ClassMethod GetInfo(PreIADM)
{
	s ReCheckFlag=$P(^DHCPEPreIADM(PreIADM),"^",28)
	s VIPLevel=$P(^DHCPEPreIADM(PreIADM),"^",18)
	s PreGroupID=$P(^DHCPEPreIADM(PreIADM),"^",2)
	q ReCheckFlag_"^"_VIPLevel_"^"_PreGroupID
}

ClassMethod GetPAADMByPADM(PreIADM)
{
	s IADM=$O(^DHCPEIADM(0,"CRMADM",PreIADM,0))
	q:IADM="" ""
	s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	q PAADM
}

ClassMethod UpdateDepartName(PreIADM, DepartName)
{
	s ^DHCPEDataEx("DHCPEPreIADM","Position",PreIADM)=DepartName
	s PIBIID=$P(^DHCPEPreIADM(PreIADM),"^",1)
	s:DepartName'="" $p(^DHCPEPreIBI(PIBIID),"^",11)=DepartName
	q ""
}

ClassMethod UpdateHPNo(PreIADM, OldInfo)
{
	s ReCheckFlag=$P(^DHCPEPreIADM(PreIADM),"^",28)
	s VIPLevel=$P(^DHCPEPreIADM(PreIADM),"^",18)
	s PreGroupID=$P(^DHCPEPreIADM(PreIADM),"^",2)
	s NewInfo=ReCheckFlag_"^"_VIPLevel_"^"_PreGroupID
	s ret=0
	i NewInfo'=OldInfo d
	.s LocID=$P(^DHCPEPreIADM(PreIADM),"^",26)
	.s NewHPNo=..GetNewHPNo(ReCheckFlag,VIPLevel,PreGroupID,LocID)
	.&SQL(Update Sqluser.DHC_PE_PreIADM set PIADM_HPNo=:NewHPNo where PIADM_RowID=:PreIADM)
	.s ret=SQLCODE
	q ret
}

/// w ##class(web.DHCPE.PreIADMEx).GetNewHPNo("Y",1,"",53)
ClassMethod GetNewHPNo(ReCheckFlag, VIPLevel, PreGroupID, LocID)
{
	s ^tempdhcpe("GetNewHPNo")=$lb(ReCheckFlag, VIPLevel, PreGroupID, LocID)
	s HPNo=""
	s VIPDesc=""
	s:VIPLevel="" VIPLevel=##class(web.DHCPE.CT.VIPLevel).GetDefaultVIP(LocID)  ;为空就是默认
	s:VIPLevel="" VIPLevel=$O(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID)) ;为空就是第一个
	
	s PreCode=""
	s HPNoInfo=$G(^DHCPESetting("DHCPE","HPNo",LocID))	
	s PreCode=$P(HPNoInfo,"^",1) //前缀
	s HPNoLength=$P(HPNoInfo,"^",2) ;长度
	s:HPNoLength="" HPNoLength=10 ;没设置就是10位
	s LocVIPLevelID=$o(^CF.PE.LocVIPLevelI("IdxOfLocVIP"," "_LocID,VIPLevel,0))
	s HPNo=HPNo_$lg($g(^CF.PE.LocVIPLevelD(LocVIPLevelID)),8)   //vip等级维护的体检编号
	s HPNo=PreCode_HPNo
	i ReCheckFlag="Y" d ;复查
	.s HPNo=HPNo_"F"
	
	s GroupCode="" ;单位代码
	i PreGroupID'="" d
	.s GroupCode=$P($G(^DHCPEPreGADM(PreGroupID)),"^",24)
	s HPNo=HPNo_GroupCode
	s PreLength=$L(HPNo)
	s Sort=$I(^DHCPEHPNoRecord("DHCPE","HPNoSort",LocID,HPNo))
	s SortLength=$L(Sort)
	i PreLength+SortLength<(HPNoLength+1) d
	.s Sort=$E("000000000",0,HPNoLength-SortLength-PreLength)_Sort
	s HPNo=HPNo_Sort
	q HPNo
}

/*
/// w ##class(web.DHCPE.PreIADMEx).GetNewHPNo("Y",1,"",53)
ClassMethod GetNewHPNo(ReCheckFlag, VIPLevel, PreGroupID, LocID)
{
	s HPNo=""
	s VIPDesc=""
	s:VIPLevel="" VIPLevel=$G(^DHCPEVIPLevel("VIPapprove")) ;为空就是默认
	s:VIPLevel="" VIPLevel=$O(^DHCPEVIPLevel("VIP","")) ;为空就是第一个
	;s:VIPLevel'="" VIPDesc=$P(^DHCPEVIPLevel("VIP",VIPLevel),"^",2)
	;s:VIPDesc[("VIP") PreGroupID=""
	
	s PreCode=""
	s HPNoInfo=$G(^DHCPESetting("DHCPE","HPNo",LocID))
	
	s PreCode=$P(HPNoInfo,"^",1) //前缀
	s HPNoLength=$P(HPNoInfo,"^",2) ;长度
	s:HPNoLength="" HPNoLength=10 ;没设置就是10位
	s HPNo=HPNo_$P(^DHCPEVIPLevel("VIP",VIPLevel),"^",9) ;
	s HPNo=PreCode_HPNo
	i ReCheckFlag="Y" d ;复查
	.s HPNo=HPNo_"F"
	
	s GroupCode="" ;单位代码
	i PreGroupID'="" d
	.s GroupCode=$P($G(^DHCPEPreGADM(PreGroupID)),"^",24)
	s HPNo=HPNo_GroupCode
	s PreLength=$L(HPNo)
	;s HPNo="PT"
	s Sort=$I(^DHCPEHPNoRecord("DHCPE","HPNoSort",LocID,HPNo))
	s SortLength=$L(Sort)
	i PreLength+SortLength<(HPNoLength+1) d
	.s Sort=$E("000000000",0,HPNoLength-SortLength-PreLength)_Sort
	s HPNo=HPNo_Sort
	q HPNo
}
*/
ClassMethod GetNewGroupCode(LocID)
{
	;w ##class(web.DHCPE.PreIADMEx).GetNewGroupCode(53)
	s BaseKey="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	s Base4=$G(^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,4))
	i Base4="" d
	.s ^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,1)="A"
	.s ^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,2)="A"
	.s ^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,3)="A"
	.s ^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,4)="A"
	e  i Base4'="Z" d
	.s SortNum=$L($P(BaseKey,Base4,1))
	.s Base4=$E(BaseKey,SortNum+2,SortNum+2)
	.s ^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,4)=Base4
	e  d
	.s ^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,4)="A"
	.s Base3=$G(^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,3))
	.i Base3'="Z" d
	..s SortNum=$L($P(BaseKey,Base3,1))
	..s Base3=$E(BaseKey,SortNum+2,SortNum+2)
	..s ^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,3)=Base3
	.e  d
	..s ^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,3)="A"
	..s Base2=$G(^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,2))
	..i Base2'="Z" d
	...s SortNum=$L($P(BaseKey,Base2,1))
	...s Base2=$E(BaseKey,SortNum+2,SortNum+2)
	...s ^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,2)=Base2
	..e  d
	...s ^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,2)="A"
	...s Base1=$G(^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,1))
	...i Base1'="Z" d
	....s SortNum=$L($P(BaseKey,Base1,1))
	....s Base1=$E(BaseKey,SortNum+2,SortNum+2)
	....s ^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,1)=Base1
	s ret=$G(^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,1))_$G(^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,2))
	s ret=ret_$G(^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,3))_$G(^DHCPEHPNoRecord("DHCPE","GroupCode",LocID,4))
	q ret
}

ClassMethod getReheckFlag(PIADM) As %String
{
 	s sub=0
	s flag=$P(^DHCPEPreIADM(PIADM),"^",28)
    s OrdSetFlag=0
	f  s sub=$O(^DHCPEPreIADM(PIADM,"ORDENT",sub)) q:sub=""  d
	.s Stat=$P(^DHCPEPreIADM(PIADM,"ORDENT",sub),"^",9)
	.q:Stat'="1"
	.s OrdSetFlag=1
    if (flag="Y")&&(OrdSetFlag=1) q "1"  // 复查不应选套餐
    if (flag="N")&&(OrdSetFlag=0) q "2"  //不是复查应选套餐
 	
    q flag
}

ClassMethod ExistExecItem(PAADM)
{
	q:+..CheckBaseInfo(PAADM)="0" "-1"
	s ExecItem=0
	s OrderID=$O(^OEORD(0,"Adm",PAADM,0))
	q:OrderID="" ExecItem
	s OrderSub=0
	f  s OrderSub=$O(^OEORD(OrderID,"I",OrderSub)) q:(OrderSub="")||(ExecItem=1)  d
	.s Stat=$P(^OEORD(OrderID,"I",OrderSub,1),"^",13)
	.q:Stat="4"
	.s:Stat="6" ExecItem=1
	s HadPrint=0
	s:$D(^DHCPEPatItemPrintFlag("PatItem","PrintFlag",PAADM)) HadPrint=2
	q:ExecItem+HadPrint>0 ExecItem+HadPrint
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	s Date=$P(^DHCPEIADM(IADM),"^",5)
	s GADM=$P(^DHCPEIADM(IADM),"^",2)
	i (Date>+$H)&&(GADM'="") q "5^"_##class(websys.Conversions).DateLogicalToHtml(Date)
	i Date'=+$H q "4^"_##class(websys.Conversions).DateLogicalToHtml(Date)
	q 0
}

// 

ClassMethod OutAsType(ContrlWidth As %String = "")
{
	;d ##class(web.DHCPE.PreIADMEx).OutAsType(125)
	s:(""=ContrlWidth) ContrlWidth="125"
	;w "<select name='AsType' id='AsType' style='width:"_ContrlWidth_"' HEIGHT=0>",!
	w ##class(web.DHCPE.DHCPECommon).GetDefaultStyle("AsType","")
	w "<option value='3'>"_..GetAsTypeDesc(3)_"</option>",!
	w "<option value='1'>"_..GetAsTypeDesc(1)_"</option>",!
	w "<option value='2'>"_..GetAsTypeDesc(2)_"</option>",!
	w "<option value='4'>"_..GetAsTypeDesc(4)_"</option>",!
	//w "<option value='5'>"_..GetAsTypeDesc(5)_"</option>",!
	w "</select>",!
}

ClassMethod GetAsTypeDesc(AsType)
{
	q:AsType="1" "遗留数据"
	q:AsType="2" "领导特批"
	q:AsType="3" "其它"
	q:AsType="4" "转账"
	//q:AsType="5" "团体换人"
	q ""
}

ClassMethod CheckBaseInfo(PAADM)
{
	;1一致  0不一致
	;d ##class(web.DHCPE.PreIADMEx).CheckBaseInfo(125)
	s PatID=$P($g(^PAADM(PAADM)),"^",1)
	s PatName=$P($g(^PAPER(PatID,"ALL")),"^",1)
	s PatSex=$P($g(^PAPER(PatID,"ALL")),"^",7)
	s RegNo=$P($g(^PAPER(PatID,"PAT",1)),"^",1)
	s BaseID=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	s BName=$P($g(^DHCPEPreIBI(BaseID)),"^",2)
	s BSex=$P($g(^DHCPEPreIBI(BaseID)),"^",3)
	i (BName'=PatName)||(PatSex'=BSex) q 0_"^"_BName
	q 1
}

Query SearchDepart() As %Query(ROWSPEC = "DepartName:%String:部门名称")
{
}

ClassMethod SearchDepartExecute(ByRef qHandle As %Binary) As %Status
{

	Set repid=$I(^CacheTemp)

 	s ind=1
 	s DepartName="入职体检"
 	d Build	
	s DepartName="司机体检"
 	d Build	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build
	set Data=$lb(DepartName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchDepartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchDepartExecute ]
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

ClassMethod SearchDepartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchDepartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod CancelArrived(PAADM)
{
	s IADM=$O(^DHCPEIADM(0,"PAADM",PAADM,0))
	s Status=$P(^DHCPEIADM(IADM),"^",8)
	q:Status'="ARRIVED" "NoArrived"
	s ResultID=$O(^DHCPERLT(0,"ADM",PAADM,0))
	q:ResultID'="" "HadResult"
	s PIADM=$P(^DHCPEIADM(IADM),"^",4)
	&SQL(Update SQLUser.DHC_PE_IADM set IADM_Status='REGISTERED' where IADM_RowID=:IADM)
	q:SQLCODE'=0 SQLCODE
	&SQL(Update SQLUser.DHC_PE_PreIADM set PIADM_Status='REGISTERED' where PIADM_RowID=:PIADM)
	q SQLCODE
}

// w ##class(web.DHCPE.PreIADMEx).GetRegisterRecord("19193918")

ClassMethod GetRegisterRecord(RegNo)
{
	i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)	
	q:($L(RegNo)=0) ""
	s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	q:PIBI="" ""
	s PIADM=""
	s PIADMStr="" 
	f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)         //Add by 090702
    .q:LocFlag=1  
	.s PIADMStutas=$P(^DHCPEPreIADM(PIADM),"^", 8)
	.q:("REGISTERED"'=PIADMStutas)
	.s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
	.q:IADM=""
	.s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	.s PrintFlag=$G(^DHCPEPatItemPrintFlag("PatItem","PrintFlag",PAADM))
	.q:PrintFlag'="Y"
	.i PIADMStr="" d
	..s PIADMStr=PIADM
	.e  d
	..s PIADMStr=PIADMStr_"^"_PIADM
	q PIADMStr
}

/// added by sxt 20210408
/// function:根据登记号查找登记的记录
/// w ##class(web.DHCPE.PreIADMEx).GetRegisterRecordNew()
ClassMethod GetRegisterRecordNew(RegNo)
{
	i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)	
	q:($L(RegNo)=0) "-1^登记号不能为空"
	s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	q:PIBI="" "-1^无该人员的基本信息!"
	s PIADM=""
	s PIADMStr="" 
	f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)         //Add by 090702
    .q:LocFlag=1  
	.s PIADMStutas=$P(^DHCPEPreIADM(PIADM),"^", 8)
	.q:("REGISTERED"'=PIADMStutas)
	.s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
	.q:IADM=""
	.s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	.s PrintFlag=$G(^DHCPEPatItemPrintFlag("PatItem","PrintFlag",PAADM))
	.q:PrintFlag'="Y"
	.i PIADMStr="" d
	..s PIADMStr=PIADM
	.e  d
	..s PIADMStr=PIADMStr_"^"_PIADM
	q "0^"_PIADMStr
}

// w ##class(web.DHCPE.PreIADMEx).GetRegisterRecord("19193918")

ClassMethod GetArrivedRecord(RegNo)
{
	i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)	
	q:($L(RegNo)=0) ""
	s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	q:PIBI="" ""
	s PIADM=""
	s PIADMStr="" 
	f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)         //Add by 090702
    .q:LocFlag=1  
	.s PIADMStutas=$P(^DHCPEPreIADM(PIADM),"^", 8)
	.q:("ARRIVED"'=PIADMStutas)
	.s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
	.q:IADM=""
	.s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	.s PrintFlag=$G(^DHCPEPatItemPrintFlag("PatItem","PrintFlag",PAADM))
	.q:PrintFlag'="Y"
	.s AuditUser=""
	.s GSID=##class(web.DHCPE.ResultDiagnosis).GetSSId(PAADM)
	.i GSID'="" d
	..s AuditUser=$P(^DHCPEGS(GSID,1),"^",5)
	.q:(AuditUser'="")
	.i PIADMStr="" d
	..s PIADMStr=PIADM
	.e  d
	..s PIADMStr=PIADMStr_"^"_PIADM
	q PIADMStr
}

// w ##class(web.DHCPE.PreIADMEx).GetLastArrivedRecord("19193918")

ClassMethod GetLastArrivedRecord(RegNo, NoReCheck As %String = "N")
{
	i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)	
	q:($L(RegNo)=0) "-1^请输入正确的登记号"
	s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	q:PIBI="" "-1^无该人员的基本信息!"
	s PIADM=""
	s MaxDate=0
	s MaxTime=0
	s PIADMStr="" 
	f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM)         //Add by 090702
    .q:LocFlag=1  
	.s PIADMStutas=$P(^DHCPEPreIADM(PIADM),"^", 8)
	.q:("ARRIVED"'=PIADMStutas)
	.s ReCheck=$P(^DHCPEPreIADM(PIADM),"^", 28)
	.q:(NoReCheck="Y")&&(ReCheck="Y")
	.s AdmDate=$P(^DHCPEPreIADM(PIADM),"^", 4)
	.s AdmTime=$P(^DHCPEPreIADM(PIADM),"^", 6)
	.i MaxDate<AdmDate d
	..s PIADMStr=PIADM
	..s MaxDate=AdmDate
	..s MaxTime=AdmTime
	.i MaxDate=AdmDate d
	..i MaxTime<AdmTime d
	...s PIADMStr=PIADM
	...s MaxDate=AdmDate
	...s MaxTime=AdmTime
	
	q PIADMStr
}

/// added by xy 20180502 
/// function:根据登记号查找没收表的记录
/// w ##class(web.DHCPE.PreIADMEx).GetNoRecPaperRecord()
ClassMethod GetNoRecPaperRecord(RegNo)
{
    i RegNo'="" s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo) 
	q:('($L(RegNo)>0)) "-1^请输入正确的登记号"
	s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
	q:PIBI="" "_1^无该人员的基本信息!"
	s PIADM="",PIADMStr="" 
	f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM) 
    .q:LocFlag=1 
	.s PIADMStutas=$P(^DHCPEPreIADM(PIADM),"^", 8)
	.q:"ARRIVED"'=PIADMStutas
	.s ReCheck=$P(^DHCPEPreIADM(PIADM),"^", 28)
	.;q:ReCheck="Y"
	.q:$d(^DHCPEDataEx("ConfirmRecPaper",PIADM))
    .S IADM=""
	.s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
	.q:IADM="" 
	.s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	.;q:'$D(^DHCPEPatItemPrintFlag("PatItem","PrintFlag",PAADM))
	.i PIADMStr="" s PIADMStr=PIADM_"$"
	.e  s PIADMStr=PIADMStr_PIADM_"$"
	q "0^"_PIADMStr
}

Query SearchPreIADM(PIADMs As %String = "") As %Query(ROWSPEC = "id:%String, PIADMPIBIDR:%String, PIBIPAPMINo:%String, PIADMPIBIDRName:%String, PIADMPGADMDRName:%String, PIADMPGTeamDRName:%String, PIADMPEDateBegin:%String,PIADMOldHPNo:%String")
{
}

ClassMethod SearchPreIADMExecute(ByRef qHandle As %Binary, PIADMs As %String = "") As %Status
{

	Set repid=$I(^CacheTemp)
	if (""=PIADMs) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ind=1
	s PIADMLength=$L(PIADMs,"$")
	for i=1:1:PIADMLength-1 d
	.s id=$P(PIADMs,"$",i)
	.Do GetPIADMInfo
	
 	Set qHandle=$lb(0,repid,0)
 	Quit $$$OK
GetPIADMInfo
	s CurData=$g(^DHCPEPreIADM(id))
	q:$d(^DHCPEDataEx("ConfirmRecPaper",id))
	s PIADMPIBIDR=$p(CurData,"^",1)
	s PIADMPIBIDRName=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",2)
	s PIADMPGADMDR=$p(CurData,"^",2)
	s PIADMPGADMDRName=""
	i ""'=PIADMPGADMDR  d
	.s PGADMPGBIDR=$p($g(^DHCPEPreGADM(PIADMPGADMDR)),"^",1)
	.i ""'=PGADMPGBIDR d
	..s PIADMPGADMDRName=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",2)
	s PIADMPGTeamDR=$p(CurData,"^",3)
	//PGT_ParRef
	s PGTParRef=$P(PIADMPGTeamDR,"||",1)
	//PGT_ChildSub
	s PGTChildSub=$P(PIADMPGTeamDR,"||",2)
	i ""'=PIADMPGTeamDR  d  //3.1
	.s PIADMPGTeamDRName=$P($g(^DHCPEPreGADM(PGTParRef,"Team",PGTChildSub)),"^",1)
	e  d
	.s PIADMPGTeamDRName=""
	 s IADM=$o(^DHCPEIADM(0,"CRMADM",id,""))
	 S PIADMPEDateBegin=$P($g(^DHCPEIADM(IADM)),"^",5)
	;s PIADMPEDateBegin=$p(CurData,"^",4)
	;i ""'=PIADMPEDateBegin s PIADMPEDateBegin=$ZD(PIADMPEDateBegin,4)
	i ""'=PIADMPEDateBegin s PIADMPEDateBegin=##class(websys.Conversions).DateLogicalToHtml(PIADMPEDateBegin)
	s PIADMVIP = ##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",id)
	
	s TVIPlevel=$P(PIADMVIP,"^",1)
	//q:(VIPLevel'="")&&(VIPLevel'=TVIPlevel)
	s PIADMVIP=$P(PIADMVIP,"^",2)
	s PIBIPAPMINo=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",1)
	s PIADMOldHPNo=$p(CurData,"^",27)

	Do FindBuild
	q
	
FindBuild   
	set Data=$lb($g(id), PIADMPIBIDR, PIBIPAPMINo, PIADMPIBIDRName, PIADMPGADMDRName, PIADMPGTeamDRName, PIADMPEDateBegin,PIADMOldHPNo)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchPreIADMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchPreIADMExecute ]
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

ClassMethod SearchPreIADMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchPreIADMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreIADMEx","FindPIADMInfo","")
Query FindPIADMInfo(RegNo As %String = "", HospID As %String = "", ArrivedFlag As %String = "") As websys.Query(ROWSPEC = "PAADM:%String,PIADM:%String,RegNo:%String,Name:%String,HPNo:%String,AdmDate:%String,StatusDesc:%String,GName:%String,TeamName:%String")
{
}

ClassMethod FindPIADMInfoExecute(ByRef qHandle As %Binary, RegNo As %String = "", HospID As %String = "", ArrivedFlag As %String = "") As %Status
{
  	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1 

    s PIBI=$o(^DHCPEPreIBI(0,"PAPMINo",RegNo,0)) 
	if (""=PIBI) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s PIADM="" 
	f  s PIADM=$o(^DHCPEPreIADM(0,"PIBI",PIBI,PIADM),-1) q:(PIADM="")  d
	.s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PreADM",PIADM) 
    .q:LocFlag=1 
	.s Status=$P(^DHCPEPreIADM(PIADM),"^", 8)
	.q:(Status'="REGISTERED")&&(ArrivedFlag'="Y")
	.q:(Status'="ARRIVED")&&(ArrivedFlag="Y")
	.S IADM=""
	.s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
	.q:IADM="" 
	.s PAADM=$P(^DHCPEIADM(IADM),"^",1)
	.s PrintFlag=$G(^DHCPEPatItemPrintFlag("PatItem","PrintFlag",PAADM))
	.q:PrintFlag'="Y"
	.
	.S AdmDate=$P(^DHCPEIADM(IADM),"^",5)
	.i AdmDate'="" s AdmDate=##class(websys.Conversions).DateLogicalToHtml(AdmDate)
	.S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",RegNo,0))
	.i PAPMIRowId'="" d
	..s TAge=##class(web.DHCPE.DHCPECommon).GetPapmiAge(PAPMIRowId,HospID)
	.s Sex=""
	.s SexDR=$p($g(^DHCPEPreIBI(PIBI)),"^",3)
	.i SexDR'="" s Sex=$P(^CT("SEX",SexDR),"^",2)
	.s Name=$p($g(^DHCPEPreIBI(PIBI)),"^",2)
   .s HPNo=$P(^DHCPEPreIADM(PIADM),"^", 27)
   .s StatusDesc=""
   .s StatusDesc=##Class(web.DHCPE.PreCommon).TransStatus(Status)
   .s GName="",TeamName=""
   .s PreGADM=$P(^DHCPEPreIADM(PIADM),"^", 2)
   .i ""'=PreGADM  d
   ..s PGADMPGBIDR=$p($g(^DHCPEPreGADM(PreGADM)),"^",1)
   ..i ""'=PGADMPGBIDR s GName=$p($g(^DHCPEPreGBI(PGADMPGBIDR)),"^",2)
   .s PreTeam=$P(^DHCPEPreIADM(PIADM),"^", 3)
   .i PreTeam'="" s TeamName=$P($g(^DHCPEPreGADM($p(PreTeam,"||",1),"Team",$p(PreTeam,"||",2))),"^",1)
	
	.s ^CacheTemp(repid,ind)=$lb(PAADM,PIADM,RegNo,Name,HPNo,AdmDate,StatusDesc,GName,TeamName)
	.s ind=ind+1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

Storage Default
{
<Data name="PreIADMExDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.PreIADMExD</DataLocation>
<DefaultData>PreIADMExDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.PreIADMExD</IdLocation>
<IndexLocation>^web.DHCPE.PreIADMExI</IndexLocation>
<StreamLocation>^web.DHCPE.PreIADMExS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
