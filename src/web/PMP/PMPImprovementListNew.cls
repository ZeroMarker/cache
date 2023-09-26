/// 用户需求处理相关类
Class web.PMP.PMPImprovementListNew Extends %Persistent
{

Query SelectPMPImprovementList(TJCreateDateStart As %String, TJCreateDateEnd As %String, TJCode As %String, TJName As %String, TJMenu As %String, TJFinish As %String) As %Query(ROWSPEC = "XQxiangxi:%String,XQCode:%String,XQName:%String,XQStatus:%String,XQEmergency:%String,XQDegree:%String,XQMenu:%String,XQAssignEngineer:%String,XQAdjunctFlag:%String,XQRowid:%String,XQSituation:%String,XQStandby3:%String,XQGoutongjieguo:%String,XQCreateTel:%String,XQStandby2:%String,XQType:%String,XQIPMLEngineerDESC:%String")
{
}

//张枕平  2014-10-27

//根据条件查询需求列表

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementListNew","SelectPMPImprovementList","63515","63516","","","","")

ClassMethod SelectPMPImprovementListExecute(ByRef qHandle As %Binary, TJCreateDateStart As %String, TJCreateDateEnd As %String, TJCode As %String, TJName As %String, TJMenu As %String, TJFinish As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	//s ^zzpp("11")=TJFinish
	S (XQxiangxi,XQCode,XQName,XQStatus,XQEmergency,XQDegree,XQMenu,XQAssignEngineer,XQAdjunctFlag,XQRowid,XQSituation,XQStandby3,XQGoutongjieguo,XQCreateTel,XQStandby2,XQType,XQIPMLEngineerDESC)=""
	s userId=%session.Data("LOGON.USERID")
	;S userId="2353"
	i TJCreateDateStart=""  s TJCreateDateStart=+$h-15
	i TJCreateDateEnd=""  s TJCreateDateEnd=+$h
	f date=TJCreateDateStart:1:TJCreateDateEnd d
	.s IPMLRowid="" f  s IPMLRowid=$o(^PMPImprovementListi("CreateDate",date,IPMLRowid)) q:IPMLRowid=""  d
	..s IPMLCreateUserDR=$p(^PMPImprovementList(IPMLRowid),"^",15)
	..q:IPMLCreateUserDR'=userId
	..d query

	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1      
	set Data=$lb(XQxiangxi,XQCode,XQName,XQStatus,XQEmergency,XQDegree,XQMenu,XQAssignEngineer,XQAdjunctFlag,XQRowid,XQSituation,XQStandby3,XQGoutongjieguo,XQCreateTel,XQStandby2,XQType,XQIPMLEngineerDESC)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
query
	s IPMLStatusDR=$p(^PMPImprovementList(IPMLRowid),"^",28)
	q:IPMLStatusDR=""
    s XQStatus=$P(^PMPDictionary(IPMLStatusDR),"^",2)
    s DTYFlag=$P(^PMPDictionary(IPMLStatusDR),"^",3)
	q:(TJFinish="")&(XQStatus="完成")&(DTYFlag="Improvement")
	q:(TJFinish="on")&(XQStatus'="完成")&(DTYFlag="Improvement")
	q:$p(^PMPImprovementList(IPMLRowid),"^",36)="Y"
	s XQCode=$p(^PMPImprovementList(IPMLRowid),"^",1)
	q:(TJCode'="")&(XQCode'[TJCode)
	s XQName=$p(^PMPImprovementList(IPMLRowid),"^",2)
	q:(TJName'="")&(XQName'[TJName)
	s IPMLModuleDR=$p(^PMPImprovementList(IPMLRowid),"^",23)
	i IPMLModuleDR'=""  d
	.s IPMLModule=$p(^PMPModule(IPMLModuleDR),"^",2)
	.s MODEProduct=$p(^PMPModule(IPMLModuleDR),"^",7)
	e  s IPMLModule="",MODEProduct=""
	s IPMLCreateUserDR=$p(^PMPImprovementList(IPMLRowid),"^",15)
	s TYPCreatUser=$p(^SSU("SSUSR",IPMLCreateUserDR),"^",2)
	s TYPCreatDate=$p(^PMPImprovementList(IPMLRowid),"^",11)
	S TYPCreatDate=$ZD(TYPCreatDate,3)
	;s IPMDChildsub=$o(^PMPImprovementDetaili("Flag",IPMLRowid,"133",""))
	;s TYPCheckDate=$p(^PMPImprovementDetail(IPMLRowid,IPMDChildsub),"^",11)
	s TYPEmergencyDR=$p(^PMPImprovementList(IPMLRowid),"^",18)
	i TYPEmergencyDR="" s TYPEmergency=""
	i TYPEmergencyDR'=""  d
	.s XQEmergency=$P(^PMPDictionary(TYPEmergencyDR),"^",2)
	s TYPtypeDR=$p(^PMPImprovementList(IPMLRowid),"^",31)
	i TYPtypeDR="" s TYPtype=""
	i TYPtypeDR'="" s TYPtype=$p(^PMPDictionary(TYPtypeDR),"^",2)
	s TYPDegreeDR=$p(^PMPImprovementList(IPMLRowid),"^",16)
	i TYPDegreeDR="" s XQDegree=""
	i TYPDegreeDR'="" s XQDegree=$p(^PMPDictionary(TYPDegreeDR),"^",2)
	s XQAdjunctFlag=$p(^PMPImprovementList(IPMLRowid),"^",3)
	;i XQAdjunctFlag'="Y" s XQAdjunctFlag=""
	i XQAdjunctFlag'="Y" s XQAdjunctFlag="有附件"
	s TYPRowid=IPMLRowid
	s XQSituation=$p(^PMPImprovementList(IPMLRowid),"^",26)
	s XQCreateTel=$p(^PMPImprovementList(IPMLRowid),"^",13)
	S TYPPredictTime=$p(^PMPImprovementList(IPMLRowid),"^",24)
	s XQMenu=$p(^PMPImprovementList(IPMLRowid),"^",21)
	s IPMLDevelopUser=$p(^PMPImprovementList(IPMLRowid),"^",17)
	s IPMLAssignEngineerDR=$p(^PMPImprovementList(IPMLRowid),"^",4)
	I IPMLAssignEngineerDR="" S XQAssignEngineer=""
	I IPMLAssignEngineerDR'="" S XQAssignEngineer=$p(^SSU("SSUSR",IPMLAssignEngineerDR),"^",2)
	S XQRowid=IPMLRowid
	S XQStandby3=$p(^PMPImprovementList(IPMLRowid),"^",34)
	s XQGoutongjieguo=$p(^PMPImprovementList(IPMLRowid),"^",33)
	S XQIPMLEngineer="",XQIPMLEngineerDESC=""
	s IPMLEngineerDR=$p(^PMPImprovementList(IPMLRowid),"^",37)
	B ;1
	I IPMLEngineerDR'="" S XQIPMLEngineerDESC=$P(^SSU("SSUSR",IPMLEngineerDR),"^",2)
	B ;2
	s XQStandby2dr=$p(^PMPImprovementList(IPMLRowid),"^",35)
	I XQStandby2dr'="" D
	.s XQStandby2=$p(^SSU("SSUSR",XQStandby2dr),"^",2)
	E  S XQStandby2=""
	s XQTypedr=$p(^PMPImprovementList(IPMLRowid),"^",31)
	I XQTypedr'="" D
	.S XQType=$P(^PMPDictionary(XQTypedr),"^",2)
	E  S XQType=""
	D OutputRow1
}

ClassMethod SelectPMPImprovementListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPMPImprovementListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectPMPImprovementListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPMPImprovementListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query PMPProduct(PMPProduct As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

//张枕平  2014-10-18

//提供查询下拉框

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementListNew","PMPProduct","")

ClassMethod PMPProductExecute(ByRef qHandle As %Binary, PMPProduct As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s DTYROWID="" f  s DTYROWID=$o(^PMPDictionary(DTYROWID)) q:DTYROWID=""  d
	.Q:(DTYROWID="FLAG")||(DTYROWID="flagdesc")
	.S code=$p(^PMPDictionary(DTYROWID),"^",1)
	.s desc=$p(^PMPDictionary(DTYROWID),"^",2)
	.s flag=$p(^PMPDictionary(DTYROWID),"^",3)
	.q:flag'="Type"
	.q:(PMPProduct'="")&(desc'[PMPProduct)
	.s rowid=DTYROWID
	.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PMPProductClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMPProductExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PMPProductFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMPProductExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod selectPMPIImprovementAdjunctList(Improve As %String, Affiliation As %String) As %String
{
	s ret=""
	
	q:(Improve="")||(Affiliation="")
	s rowid="" f  s rowid=$o(^PMPImproveAdjuncti("Improve",Improve,Affiliation,rowid)) q:rowid=""  d
	.s IPAJLocation=$p(^PMPImprovementAdjunct(rowid),"^",3)
	.s IPAJName=$p(^PMPImprovementAdjunct(rowid),"^",4)
	.i ret'="" s ret=ret_"||"_IPAJLocation
	.i ret="" s ret=IPAJLocation
	Q ret
}

ClassMethod UpdateImprovementList(menu As %String, rowid As %String) As %String
{
	;s ^zzpp("11")=menu_","_rowid
	s ret="FailurePrompt"
	//"门诊收款处收款失败，实际金额与账单金额不符。"^""^"已有菜单"^"特急"^"Demo Group"^"目前全院无法收费而额"^""^""^"C:\Windows\rescache\rc0007\Segment0.cmf"^"18230326251"^"111111"^"201410250001"^"11324 搞定个个个 大锅饭 "^"Demo Group"
	// 需求名称         菜单名称          需求类型          紧急程度                指定工程师          需求现状              严重程度          后补标志                附件列表                   联系电话          沟通结果               需求编码         要求达到效果       沟通人员（ssuser）
	//CRName.value+"^"+CRMenu.value+"^"+CRType.value+"^"+CREmergency.value+"^"+CREngineer.value+"^"+CRSituation.value+"^"+CRDegree.value+"^"+CRRepairType.value+"^"+CRAdjunctFlagList.value+"^"+CRtel.value+"^"+CRgoutongjieguo.value+"^"+CRCode.value+"^"+CQStandby3.value+"^"+CRgoutong.value;
	s CRName=$p(menu,"^",1)
	s CRMenu=$p(menu,"^",2)
	s CRTypename=$p(menu,"^",3)
	s CREmergencyname=$p(menu,"^",4)
	s CREmergency=..DictionaryDesc(CREmergencyname)
	s CREngineer=$p(menu,"^",5)
	s CRSituation=$p(menu,"^",6)
	s CRDegree=$p(menu,"^",7)
	s CRRepairType=$p(menu,"^",8)
	s COMMfujianList=$p(menu,"^",9)
	s CRtel=$p(menu,"^",10)
	s CRgoutongjieguo=$p(menu,"^",11)
	s CRCode=$p(menu,"^",12)
	s CQStandby3=$p(menu,"^",13)
	s mark=CRSituation_"||||"_CQStandby3
	s CRgoutong=$p(menu,"^",14)
	I COMMfujianList'="" S TYPE="Y"
	I COMMfujianList=""  S TYPE="N"
	S data=$p($h,",",1), time=$p($h,",",2)
	s userId=%session.Data("LOGON.USERID")
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	&sql(update sqluser.PMP_ImprovementList SET IPML_CreateTel=:CRtel,IPML_Standby2=:CRgoutong,IPML_Standby4=:CRgoutongjieguo,IPML_AdjunctFlag=:TYPE,IPML_Standby3=:CQStandby3,IPML_Situation=:CRSituation,IPML_Status_DR="92" WHERE IPML_Rowid=:rowid)
	s Status=$p(^PMPImprovementList(rowid),"^",28)
	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate, IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Remark,IPMD_Locid) values (:rowid,"131","92",:data,:time,:userId,:mark,:locid))
	s ret="SuccendPrompt"
	I TYPE="Y" D
	.f ii=1:1:$l(COMMfujianList,"||")  d
	..s fujiandizhi=$p(COMMfujianList,"||",ii)
	..s ^zzppp("11")=COMMfujianList
	..s fujianname=$p(fujiandizhi,"\",$l(COMMfujianList,"\"))
	..s IAJrowid="" f  s IAJrowid=$o(^PMPImproveAdjuncti("Improve",rowid,"Improvement",IAJrowid)) q:IAJrowid=""  d 
	...s Name=$p(^PMPImprovementAdjunct(IAJrowid),"^",4)
	...q:fujianname'=Name
	...s qq="1"
	..i $g(qq)'="1"  d
	...&sql(insert into sqluser.PMP_ImprovementAdjunct (IPAJ_Improve,IPAJ_Name,IPAJ_Location,IPAJ_Affiliation,IPAJ_User_DR,IPAJ_Date,IPAJ_Time) values (:rowid,:fujianname,:fujiandizhi,"Improvement",:userId,:data,:time))
	...s ret="SuccendPrompt"
	q ret
}

ClassMethod DictionaryDesc(Input As %String) As %String
{
	s ret=""
	q:Input="" 
	s ret=$o(^PMPDictionary(0,"DTY_Desc",Input,""))
	q ret
}

ClassMethod UserName(Input As %String) As %String
{
	s ret=""
	q:Input=""
	s ret=^SSU("SSUSR",0,"SSUSR_Name",Input,"")
}

ClassMethod Delete(Input As %String) As %String
{
	s ret="delete0"
	q:Input=""
	&sql(update sqluser.PMP_ImprovementList SET IPML_Standby1="Y" WHERE IPML_Rowid=:Input)
	S ret="delete"
	q ret
}

//s bbb=##class(web.PMP.PMPImprovementListNew).CRCode()

/**
ClassMethod CRCode() As %String
{
	s XQCode=""
	S Rowid=$o(^PMPImprovementList(""),-1)
	s XQCode=$p(^PMPImprovementList(Rowid),"^",1)
	b ;12
	s data=$zd(+$h,3)
	s data=$p(data,"-",1)_$p(data,"-",2)_$p(data,"-",3)
	i XQCode[data s XQCode=XQCode+1
	i XQCode'[data s XQCode=data_"0001"
	q XQCode
}*/

//s bbb=##class(web.PMP.PMPImprovementListNew).CRCode()

/// 需求编号加载    update 20150309
ClassMethod CRCodeold() As %String
{
	s XQCode=""
	s dataC=$zd(+$h,3)
	s data=$p(dataC,"-",1)_$p(dataC,"-",2)_$p(dataC,"-",3)
	S Rowid=$o(^PMPImprovementList(""),-1)
	i Rowid'="" {
		s XQCode=$p(^PMPImprovementList(Rowid),"^",1)
	    i XQCode[data s XQCode=XQCode+1
	    i XQCode'[data s XQCode=data_"0001"
		}
	ELSE {
		s XQCode=data_"0001"
		}
	q XQCode
}

//s bbb=##class(web.PMP.PMPImprovementListNew).CRCode()

/// 需求编号加载    update 20150325 by zzp
ClassMethod CRCode() As %String
{
	s XQCode=""
	i ('$d(^CacheTemp("XQCode",+$H)))  d
	.k ^CacheTemp("XQCode")
	.f no=1:1:9999  d
	..s dataC=$zd(+$h,3)
	..s length=$l(no)
	..s lengthce=4-length
	..s data=$p(dataC,"-",1)_$p(dataC,"-",2)_$p(dataC,"-",3)
	..i lengthce=0 s id=data_no
	..i lengthce=1 s id=data_"0"_no
	..i lengthce=2 s id=data_"00"_no
	..i lengthce=3 s id=data_"000"_no
	..i lengthce=4 s id=data_"0000"_no
	..s ^CacheTemp("XQCode",+$H,id)=id
	.s XQCode=$o(^CacheTemp("XQCode",+$H,""))
	.k ^CacheTemp("XQCode",+$H,XQCode)
	e  d
	.s XQCode=$o(^CacheTemp("XQCode",+$H,""))
	.k ^CacheTemp("XQCode",+$H,XQCode)
	q XQCode
}

/// 返回需求编号
ClassMethod quxiaoCRCode(code As %String)
{
	s ret=""
	q:code="" ret
	s ^CacheTemp("XQCode",+$H,code)=code
	s ret="1"
	q ret
}

/// 紧急程度下拉框
Query SelectCREmergency(CREmergency As %String) As %Query(ROWSPEC = "name:%String,rowid:%String")
{
}

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementListNew","SelectCREmergency","")

ClassMethod SelectCREmergencyExecute(ByRef qHandle As %Binary, CREmergency As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s DTYROWID="" f  s DTYROWID=$o(^PMPDictionary(DTYROWID)) q:DTYROWID=""  d
	.Q:(DTYROWID="FLAG")||(DTYROWID="flagdesc")
	.S code=$p(^PMPDictionary(DTYROWID),"^",1)
	.s desc=$p(^PMPDictionary(DTYROWID),"^",2)
	.s flag=$p(^PMPDictionary(DTYROWID),"^",3)
	.q:$p(^PMPDictionary(DTYROWID),"^",5)="N"   //不可用标记
	.q:flag'="Emergency"
	.q:(CREmergency'="")&(desc'[CREmergency)
	.s rowid=DTYROWID
	.d OutputRow4
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow4
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SelectCREmergencyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectCREmergencyExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectCREmergencyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectCREmergencyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query SelectCRDegree(CRDegree As %String) As %Query(ROWSPEC = "name:%String,rowid:%String")
{
}

ClassMethod SelectCRDegreeExecute(ByRef qHandle As %Binary, CRDegree As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s DTYROWID="" f  s DTYROWID=$o(^PMPDictionary(DTYROWID)) q:DTYROWID=""  d
	.Q:(DTYROWID="FLAG")||(DTYROWID="flagdesc")
	.S code=$p(^PMPDictionary(DTYROWID),"^",1)
	.s desc=$p(^PMPDictionary(DTYROWID),"^",2)
	.s flag=$p(^PMPDictionary(DTYROWID),"^",3)
	.q:$p(^PMPDictionary(DTYROWID),"^",5)="N"
	.q:flag'="Degree"
	.q:(CRDegree'="")&(desc'[CRDegree)
	.s rowid=DTYROWID
	.d OutputRow5
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SelectCRDegreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectCRDegreeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectCRDegreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectCRDegreeExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {				
		Set AtEnd=1
		Set Row=""
	}
	Else      {				
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

//新建需求插入数据

/// edit by dongzt 增加事务处理，嵌套提交申请
ClassMethod InsertPMPImprovementList(input As %String) As %String
{
	//"读卡失败^201410300001^18230326251^113^1^已经和Demo Group工程师确认该问题！^目前建卡室有一台电脑不能读卡，界面报错！^84^127^^E:\东华软件\表结构\1.基础表ASD.txt^1^目前建卡室有一台电脑不能读卡，界面报错！^能够读卡即可^1^119"
	//CRNamev+"^"+CRCodev+"^"+CRtelv+"^"+CRTypeIDv+"^"+CRgoutongIDv+"^"+CRgoutongjieguov+"^"+CRSituationv+"^"+CREmergencyv+"^"+CRDegreev+"^"+
	//CRRepairTypev+"^"+CRAdjunctFlagListv+"^"+CREngineerIDv+"^"+CRSituationv+"^"+CQStandby3v+"^"+userId+"^"+locid;
	//"门诊退费不打负票^201411080001^18230326251^113^^^前门诊退费患者在打印退费发票的时候不打印负票^84^123^^^^前门诊退费患者在打印退费发票的时候不打印负票^^1^119"
	s ret="Insertfill"
	k ^pmpzzp($j)
	q:input=""
	S ^ZZP("CESHI")=input
	s input1=$p(input,"@@") //add by dongzt
	s IPMLName=$P(input1,"^",1)
	s IPMLCode=$P(input1,"^",2)
	s IPMLCreateTel=$P(input1,"^",3)
    s IPMLType=$P(input1,"^",4)
	s IPMLStandby2=$P(input1,"^",5)
	s IPMLStandby4=$P(input1,"^",6)
	s IPMLSituation=$P(input1,"^",7)
	s IPMLEmergencyDR=$P(input1,"^",8)
	s IPMLDegreeDR=$P(input1,"^",9)
	s IPMLStandby5=$P(input1,"^",10)
	s IPMLAdjunctFlag1=$P(input1,"^",11)
	S IPMLStatusDR="91"
	i IPMLAdjunctFlag1'="" s IPMLAdjunctFlag="Y" 
	i IPMLAdjunctFlag1=""  s IPMLAdjunctFlag="N" 
	s IPMLEngineerDR=$P(input1,"^",12)
	S IPMLStandby3=$P(input1,"^",14)
	S IPMLCreateDate=+$H
	s IPMLCreateLocDR=$P(input1,"^",16)
	S IPMLCreateTime=$P($H,",",2)
	s IPMLCreateUserDR=$P(input1,"^",15)
	s IPMLStandby1="N"
	s IPMLMenu=$p(input1,"^",17)
	s IPMLList=$p(input1,"^",19)
	S XYSHRIDvalue=$p(input1,"^",18)
	s IPMLStandby41=""
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	i IPMLStandby4'="" s IPMLStandby41="沟通结果："_IPMLStandby4
	TSTART
	
	i IPMLList=""  d
	.&sql(insert into sqluser.PMP_ImprovementList (IPML_Name,IPML_Code,IPML_CreateTel,IPML_Type,IPML_Standby2,IPML_Standby4,IPML_Situation,IPML_Emergency_DR,IPML_Standby5,IPML_AdjunctFlag,IPML_Status_DR,IPML_Standby3,IPML_CreateDate,IPML_CreateLoc_DR,IPML_CreateTime,IPML_CreateUser_DR,IPML_Standby1,IPML_Engineer_DR,IPML_Menu,IPML_RevList,IPML_UpdateType,IPML_Degree_DR) values (:IPMLName,:IPMLCode,:IPMLCreateTel,:IPMLType,:IPMLStandby2,:IPMLStandby4,:IPMLSituation,:IPMLEmergencyDR,:IPMLStandby5,:IPMLAdjunctFlag,:IPMLStatusDR,:IPMLStandby3,:IPMLCreateDate,:IPMLCreateLocDR,:IPMLCreateTime,:IPMLCreateUserDR,:IPMLStandby1,:IPMLEngineerDR,:IPMLMenu,:XYSHRIDvalue,"N",:IPMLDegreeDR))
    i IPMLList'=""  d
    .&sql(insert into sqluser.PMP_ImprovementList (IPML_Name,IPML_Code,IPML_CreateTel,IPML_Type,IPML_Standby2,IPML_Standby4,IPML_Situation,IPML_Emergency_DR,IPML_Standby5,IPML_AdjunctFlag,IPML_Status_DR,IPML_Standby3,IPML_CreateDate,IPML_CreateLoc_DR,IPML_CreateTime,IPML_CreateUser_DR,IPML_Standby1,IPML_Engineer_DR,IPML_Menu,IPML_List,IPML_Degree_DR,IPML_RevList,IPML_UpdateType) values (:IPMLName,:IPMLCode,:IPMLCreateTel,:IPMLType,:IPMLStandby2,:IPMLStandby4,:IPMLSituation,:IPMLEmergencyDR,:IPMLStandby5,:IPMLAdjunctFlag,:IPMLStatusDR,:IPMLStandby3,:IPMLCreateDate,:IPMLCreateLocDR,:IPMLCreateTime,:IPMLCreateUserDR,:IPMLStandby1,:IPMLEngineerDR,:IPMLMenu,:IPMLList,:IPMLDegreeDR,:XYSHRIDvalue,"N"))
    if (SQLCODE)
    {
	    TROLLBACK
	}
    s rowid=$o(^PMPImprovementList(""),-1)
	s mark=IPMLStandby41_"||"_"需求现状："_$P(input1,"^",13)_"||"_"要求效果："_IPMLStandby3
	i IPMLAdjunctFlag="Y" S IPMLAdjunctFlag="Yes"
	i IPMLAdjunctFlag="N" S IPMLAdjunctFlag="No"
	s ^zzp(rowid)=IPMLName_"^"_IPMLCode_"^"_IPMLCreateTel_"^"_IPMLType_"^"_IPMLStandby2_"^"_IPMLStandby4_"^"_IPMLSituation_"^"_IPMLEmergencyDR_"^"_IPMLStandby5_"^"_IPMLAdjunctFlag_"^"_IPMLStandby3_"^"_IPMLCreateDate_"^"_IPMLCreateLocDR_"^"_IPMLCreateTime_"^"_IPMLCreateUserDR_"^"_IPMLStandby1
	
	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Remark,IPMD_Accessory,IPMD_Locid) values (:rowid,'131','91',:IPMLCreateDate,:IPMLCreateTime,:IPMLCreateUserDR,:mark,:IPMLAdjunctFlag,:locid))
	if (SQLCODE) TROLLBACK
	i (XYSHRIDvalue'="")  d
	.f no=1:1:$l(XYSHRIDvalue,",")  d
	..i $l(XYSHRIDvalue,",")="1"  d
	...s user=$g(XYSHRIDvalue)
	..e  d
	...s user=$p(XYSHRIDvalue,",",no)
	..i '$d(^pmpzzp($j,user))  d
	...s ^pmpzzp($j,user)=""
	...&sql(insert into sqluser.PMP_ImprovmentRevList (PMP_ImprovementRevList_ParRef,IPRL_User,IPRL_Date,IPRL_Time,IPRL_Loc,IPRL_UpdateUser,IPRL_Falg) values (:rowid,:user,:IPMLCreateDate,:IPMLCreateTime,:IPMLCreateLocDR,:IPMLCreateUserDR,"HP"))
	if (SQLCODE) TROLLBACK
	s fujian=$P(input1,"^",11)
	i fujian'=""  d
    f ii=1:1:$l(fujian,"||")  d
	.s IPAJImprove=rowid
	.s IPAJLocation=$p(fujian,"||",ii)
	.s IPAJName=$p($p(fujian,"||",ii),"\",$l($p(fujian,"||",ii),"\"))
	.s IPAJAffiliation="Improvement"
	.s IPAJDate=+$h
	.s IPAJTime=$p($h,",",2)
	.s IPAJUserDR=$P(input1,"^",14)
	.&sql(insert into sqluser.PMP_ImprovementAdjunct (IPAJ_Improve,IPAJ_Name,IPAJ_Location,IPAJ_Affiliation,IPAJ_User_DR,IPAJ_Date,IPAJ_Time) values (:IPAJImprove,:IPAJName,:IPAJLocation,"Improvement",:IPAJUserDR,:IPAJDate,:IPAJTime))
	.s ret="0"
	if (SQLCODE) TROLLBACK  s ret="Insertfill"
	;s ret="Insertsuss"
	
	s flag=$p(input,"@@",2)
	if (flag="Submit")
	{
		d ..SubmitApplication(IPMLCode)
	}
	TCOMMIT
	
	q $g(ret)
}

//s bbb=##class(web.PMP.PMPImprovementListNew).InsertPMPImprovementList("门诊退费不打负票^201411080001^18230326251^113^^^前门诊退费患者在打印退费发票的时候不打印负票^84^123^^^^前门诊退费患者在打印退费发票的时候不打印负票^^1^119")

ClassMethod InsertPMPImprovementListold(input As %String) As %String
{
	//"读卡失败^201410300001^18230326251^113^1^已经和Demo Group工程师确认该问题！^目前建卡室有一台电脑不能读卡，界面报错！^84^127^^E:\东华软件\表结构\1.基础表ASD.txt^1^目前建卡室有一台电脑不能读卡，界面报错！^能够读卡即可^1^119"
	//CRNamev+"^"+CRCodev+"^"+CRtelv+"^"+CRTypeIDv+"^"+CRgoutongIDv+"^"+CRgoutongjieguov+"^"+CRSituationv+"^"+CREmergencyv+"^"+CRDegreev+"^"+
	//CRRepairTypev+"^"+CRAdjunctFlagListv+"^"+CREngineerIDv+"^"+CRSituationv+"^"+CQStandby3v+"^"+userId+"^"+locid;
	//"门诊退费不打负票^201411080001^18230326251^113^^^前门诊退费患者在打印退费发票的时候不打印负票^84^123^^^^前门诊退费患者在打印退费发票的时候不打印负票^^1^119"
	s ret="Insertfill"
	k ^pmpzzp($j)
	q:input=""
	S ^ZZP("CESHI")=input
	s IPMLName=$P(input,"^",1)
	s IPMLCode=$P(input,"^",2)
	s IPMLCreateTel=$P(input,"^",3)
    s IPMLType=$P(input,"^",4)
	s IPMLStandby2=$P(input,"^",5)
	s IPMLStandby4=$P(input,"^",6)
	s IPMLSituation=$P(input,"^",7)
	s IPMLEmergencyDR=$P(input,"^",8)
	s IPMLDegreeDR=$P(input,"^",9)
	s IPMLStandby5=$P(input,"^",10)
	s IPMLAdjunctFlag1=$P(input,"^",11)
	S IPMLStatusDR="91"
	i IPMLAdjunctFlag1'="" s IPMLAdjunctFlag="Y" 
	i IPMLAdjunctFlag1=""  s IPMLAdjunctFlag="N" 
	s IPMLEngineerDR=$P(input,"^",12)
	S IPMLStandby3=$P(input,"^",14)
	S IPMLCreateDate=+$H
	s IPMLCreateLocDR=$P(input,"^",16)
	S IPMLCreateTime=$P($H,",",2)
	s IPMLCreateUserDR=$P(input,"^",15)
	s IPMLStandby1="N"
	s IPMLMenu=$p(input,"^",17)
	s IPMLList=$p(input,"^",19)
	S XYSHRIDvalue=$p(input,"^",18)
	s IPMLStandby41=""
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	i IPMLStandby4'="" s IPMLStandby41="沟通结果："_IPMLStandby4
	i IPMLList=""  d
	.&sql(insert into sqluser.PMP_ImprovementList (IPML_Name,IPML_Code,IPML_CreateTel,IPML_Type,IPML_Standby2,IPML_Standby4,IPML_Situation,IPML_Emergency_DR,IPML_Standby5,IPML_AdjunctFlag,IPML_Status_DR,IPML_Standby3,IPML_CreateDate,IPML_CreateLoc_DR,IPML_CreateTime,IPML_CreateUser_DR,IPML_Standby1,IPML_Engineer_DR,IPML_Menu,IPML_RevList,IPML_UpdateType,IPML_Degree_DR) values (:IPMLName,:IPMLCode,:IPMLCreateTel,:IPMLType,:IPMLStandby2,:IPMLStandby4,:IPMLSituation,:IPMLEmergencyDR,:IPMLStandby5,:IPMLAdjunctFlag,:IPMLStatusDR,:IPMLStandby3,:IPMLCreateDate,:IPMLCreateLocDR,:IPMLCreateTime,:IPMLCreateUserDR,:IPMLStandby1,:IPMLEngineerDR,:IPMLMenu,:XYSHRIDvalue,"N",:IPMLDegreeDR))
    i IPMLList'=""  d
    .&sql(insert into sqluser.PMP_ImprovementList (IPML_Name,IPML_Code,IPML_CreateTel,IPML_Type,IPML_Standby2,IPML_Standby4,IPML_Situation,IPML_Emergency_DR,IPML_Standby5,IPML_AdjunctFlag,IPML_Status_DR,IPML_Standby3,IPML_CreateDate,IPML_CreateLoc_DR,IPML_CreateTime,IPML_CreateUser_DR,IPML_Standby1,IPML_Engineer_DR,IPML_Menu,IPML_List,IPML_Degree_DR,IPML_RevList,IPML_UpdateType) values (:IPMLName,:IPMLCode,:IPMLCreateTel,:IPMLType,:IPMLStandby2,:IPMLStandby4,:IPMLSituation,:IPMLEmergencyDR,:IPMLStandby5,:IPMLAdjunctFlag,:IPMLStatusDR,:IPMLStandby3,:IPMLCreateDate,:IPMLCreateLocDR,:IPMLCreateTime,:IPMLCreateUserDR,:IPMLStandby1,:IPMLEngineerDR,:IPMLMenu,:IPMLList,:IPMLDegreeDR,:XYSHRIDvalue,"N"))
    s rowid=$o(^PMPImprovementList(""),-1)
	s mark=IPMLStandby41_"||"_"需求现状："_$P(input,"^",13)_"||"_"要求效果："_IPMLStandby3
	i IPMLAdjunctFlag="Y" S IPMLAdjunctFlag="Yes"
	i IPMLAdjunctFlag="N" S IPMLAdjunctFlag="No"
	s ^zzp(rowid)=IPMLName_"^"_IPMLCode_"^"_IPMLCreateTel_"^"_IPMLType_"^"_IPMLStandby2_"^"_IPMLStandby4_"^"_IPMLSituation_"^"_IPMLEmergencyDR_"^"_IPMLStandby5_"^"_IPMLAdjunctFlag_"^"_IPMLStandby3_"^"_IPMLCreateDate_"^"_IPMLCreateLocDR_"^"_IPMLCreateTime_"^"_IPMLCreateUserDR_"^"_IPMLStandby1
	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Remark,IPMD_Accessory,IPMD_Locid) values (:rowid,'131','91',:IPMLCreateDate,:IPMLCreateTime,:IPMLCreateUserDR,:mark,:IPMLAdjunctFlag,:locid))
	i (XYSHRIDvalue'="")  d
	.f no=1:1:$l(XYSHRIDvalue,",")  d
	..i $l(XYSHRIDvalue,",")="1"  d
	...s user=$g(XYSHRIDvalue)
	..e  d
	...s user=$p(XYSHRIDvalue,",",no)
	..i '$d(^pmpzzp($j,user))  d
	...s ^pmpzzp($j,user)=""
	...&sql(insert into sqluser.PMP_ImprovmentRevList (PMP_ImprovementRevList_ParRef,IPRL_User,IPRL_Date,IPRL_Time,IPRL_Loc,IPRL_UpdateUser,IPRL_Falg) values (:rowid,:user,:IPMLCreateDate,:IPMLCreateTime,:IPMLCreateLocDR,:IPMLCreateUserDR,"HP"))
	s fujian=$P(input,"^",11)
	i fujian'=""  d
    f ii=1:1:$l(fujian,"||")  d
	.s IPAJImprove=rowid
	.s IPAJLocation=$p(fujian,"||",ii)
	.s IPAJName=$p($p(fujian,"||",ii),"\",$l($p(fujian,"||",ii),"\"))
	.s IPAJAffiliation="Improvement"
	.s IPAJDate=+$h
	.s IPAJTime=$p($h,",",2)
	.s IPAJUserDR=$P(input,"^",14)
	.&sql(insert into sqluser.PMP_ImprovementAdjunct (IPAJ_Improve,IPAJ_Name,IPAJ_Location,IPAJ_Affiliation,IPAJ_User_DR,IPAJ_Date,IPAJ_Time) values (:IPAJImprove,:IPAJName,:IPAJLocation,"Improvement",:IPAJUserDR,:IPAJDate,:IPAJTime))
	s ret="Insertsuss"
	q ret
}

ClassMethod SaveShenHe(Rowid As %String, UserId As %String) As %String
{
	s ^zzp("save")=Rowid_","_UserId
	s ret="",type="132"
	q:(Rowid="")||(UserId="")
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s usertype=0
	s ROWIDD="" F  S ROWIDD=$O(^PMPPermission(ROWIDD)) Q:ROWIDD=""  D
	.s PERLevel=$p(^PMPPermission(ROWIDD),"^",3)
	.s PERSpare2=$p(^PMPPermission(ROWIDD),"^",5)
	.s PERSpare3=$p(^PMPPermission(ROWIDD),"^",6)
	.q:PERSpare2'="Y"
	.s ROWID="" F  S ROWID=$O(^PMPPermisBusinessi("PERBusUserDr",ROWIDD,UserId,ROWID)) Q:ROWID=""  D
	..s PERBusIsEffect=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",3)
	..q:PERBusIsEffect'="Y"
	..s usertype=PERSpare3
	..s XQStatus=$P(^PMPDictionary(PERSpare3),"^",2)
	..i XQStatus["审核通过" s type="133"
	i usertype=0  d
	.s Status=$p(^PMPImprovementList(Rowid),"^",28)
	.i $d(^PMPImprovementRevListi("User",Rowid,UserId))  d
	..&sql(update sqluser.PMP_ImprovmentRevList set IPRL_Type="Y" where PMP_ImprovementRevList_ParRef=:Rowid and IPRL_User=:UserId)
	..&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,:type,:Status,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	e   d
	.&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:usertype,IPML_Auditor1=:UserId where IPML_Rowid=:Rowid) 
	.&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,:type,:usertype,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
    s ret="wangcheng"
	q ret
}

/**
**查询当前需求的下一审核权限
**
**/
ClassMethod SaveShenHeNextByDemo(Rowid As %String) As %String
{
	
	s ret=""
	s NextYzsh=""	//院长审核标识
	s NextPerRowid=""
	s type="132"
	s usertype=0
	s UserId=1	//demo
    s userId=%session.Data("LOGON.USERID")
	s ROWIDD="" F  S ROWIDD=$O(^PMPPermission(ROWIDD)) Q:ROWIDD=""  D
	.s PERLevel=$p(^PMPPermission(ROWIDD),"^",3)
	.s PERSpare2=$p(^PMPPermission(ROWIDD),"^",5)
	.q:PERSpare2'="Y"
	.s ROWID="" F  S ROWID=$O(^PMPPermisBusinessi("PERBusUserDr",ROWIDD,userId,ROWID)) Q:ROWID=""  D
	..s PERBusIsEffect=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",3)
	..q:PERBusIsEffect'="Y"
	..;s StutsPer=$P(^PMPPermission(ROWIDD),"^",8)
	..s NextRowid=ROWIDD+1     //判断下一条权限是否为空或者不存在，知道不为空为止
	..f NextRowid=$o(^PMPPermission(NextRowid)) q:NextRowid=""  d
	...s PERSpare22=$p(^PMPPermission(NextRowid),"^",5)
	...q:PERSpare22'="Y"    //无效退出
	...s NextYzsh=$P(^PMPPermission(NextRowid),"^",8)
	...s PERSpare3=$p(^PMPPermission(NextRowid),"^",6)
	...s XQStatus=$P(^PMPDictionary(PERSpare3),"^",2)
	...i XQStatus["审核通过" s type="133"
	...s NextPerRowid=NextRowid
	...s usertype=PERSpare3
	...break
	
	if NextYzsh="E"		//如果下一审核权限是院长查询，demo自动同意改进
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	
	i usertype=0  d
	.s Status=$p(^PMPImprovementList(Rowid),"^",28)
	.i $d(^PMPImprovementRevListi("User",Rowid,UserId))  d
	..&sql(update sqluser.PMP_ImprovmentRevList set IPRL_Type="Y" where PMP_ImprovementRevList_ParRef=:Rowid and IPRL_User=:UserId)
	..&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,:type,:Status,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	e   d
	.;s ^zzpzzp("6666")=PERSpare3_"^"_usertype
	.&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:usertype,IPML_Auditor1=:UserId where IPML_Rowid=:Rowid) 
	.&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,:type,:usertype,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
    s ret="wangcheng"
	q ret
}

ClassMethod SaveShenHeold(Rowid As %String, UserId As %String) As %String
{
	s ret=""
	q:(Rowid="")||(UserId="")
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	;s ^zzp("1111")=IPMLCreateDate_"^"_IPMLCreateTime_"^"_Rowid_"^"_UserId
	s Status=$p(^PMPImprovementList(Rowid),"^",28)
	i $d(^PMPImprovementRevListi("User",Rowid,UserId))  d
	.&sql(update sqluser.PMP_ImprovmentRevList set IPRL_Type="Y" where PMP_ImprovementRevList_ParRef=:Rowid and IPRL_User=:UserId)
	.s type="0"
	.s IPRLrowid="" f  s IPRLrowid=$o(^PMPImprovementRevList(Rowid,IPRLrowid)) Q:IPRLrowid=""  D
	..s IPRLtype=$p(^PMPImprovementRevList(Rowid,IPRLrowid),"^",9)
	..i IPRLtype=""  s type="1"
	.i type="1" d
	..&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR="94",IPML_Auditor1=:UserId where IPML_Rowid=:Rowid) 
	..&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,'132','94',:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	.e  d
	..&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,'132',:Status,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	..&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR="94",IPML_Auditor1=:UserId where IPML_Rowid=:Rowid) 
	e  d
	.&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR="94",IPML_Auditor1=:UserId where IPML_Rowid=:Rowid) 
	.&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,'132','94',:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	s ret="wancheng"
	q ret
}

ClassMethod SaveShenHe1(Rowid As %String, UserId As %String) As %String
{
	s ret=""
	q:(Rowid="")||(UserId="")
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	;s ^zzp("1111")=IPMLCreateDate_"^"_IPMLCreateTime_"^"_Rowid_"^"_UserId
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR="99",IPML_Auditor=:UserId where IPML_Rowid=:Rowid) 
	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,'133','99',:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	s ret="wancheng1"
	q ret
}

ClassMethod SaveShenHe2(Rowid As %String, UserId As %String) As %String
{
	s ret=""
	q:(Rowid="")||(UserId="")
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	;s ^zzp("1111")=IPMLCreateDate_"^"_IPMLCreateTime_"^"_Rowid_"^"_UserId
	s Status=$p(^PMPImprovementList(Rowid),"^",28)
	i $d(^PMPImprovementRevListi("User",Rowid,UserId))  d
	.&sql(update sqluser.PMP_ImprovmentRevList set IPRL_Type="Y" where PMP_ImprovementRevList_ParRef=:Rowid and IPRL_User=:UserId)
	.s type="0"
	.s IPRLrowid="" f  s IPRLrowid=$o(^PMPImprovementRevList(Rowid,IPRLrowid)) Q:IPRLrowid=""  D
	..s IPRLtype=$p(^PMPImprovementRevList(Rowid,IPRLrowid),"^",9)
	..i IPRLtype=""  s type="1"
	.i type="1" d
	..&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:Status,IPML_Auditor1=:UserId where IPML_Rowid=:Rowid) 
	..&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,'132','94',:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	.e  d
	..&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,'132',:Status,:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	..&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:Status,IPML_Auditor1=:UserId where IPML_Rowid=:Rowid) 
	s ret="wancheng2"
	q ret
}

ClassMethod TiJiaoShenQingold(Input As %String) As %String
{
	s ret=""
	q:(Input="")
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)
	s Rowid=$o(^PMPImprovementListi("Code",Input,""))
	s UserId=%session.Data("LOGON.USERID")
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR="92",IPML_Auditor1=:UserId where IPML_Rowid=:Rowid) 
	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,'135','92',:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))
	s ret="tijiao"
	q ret
}

//edit by dongzt 增加事务处理

ClassMethod SubmitApplication(Input As %String) As %String
{
	s ret=""
	q:(Input="")
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)  //add by dongzt 
	s Rowid=$o(^PMPImprovementListi("Code",Input,""))
	s UserId=%session.Data("LOGON.USERID")
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	TSTART
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR="92",IPML_Auditor1=:UserId where IPML_Rowid=:Rowid) 
	if (SQLCODE) 
	{
		TROLLBACK
	}
	else
	{
		&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,'135','92',:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))	
		if (SQLCODE)
		{
			TROLLBACK
		}
		else
		{
			TCOMMIT
		}

	}
		
	
	q $g(SQLCODE)
}

ClassMethod TiJiaoShenQing(Input As %String) As %String
{
	s ret=""
	q:(Input="")
	s IPMLCreateDate=+$h,IPMLCreateTime=$p($h,",",2)  //add by dongzt 
	s Rowid=$o(^PMPImprovementListi("Code",Input,""))
	s UserId=%session.Data("LOGON.USERID")
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	TSTART
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR="92",IPML_Auditor1=:UserId where IPML_Rowid=:Rowid) 
	if (SQLCODE) 
	{
		TROLLBACK
	}
	else
	{
		&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,'135','92',:IPMLCreateDate,:IPMLCreateTime,:UserId,:locid))	
		if (SQLCODE)
		{
			TROLLBACK
		}
		else
		{
			TCOMMIT
		}

	}
		
	
	q $g(SQLCODE)
}

ClassMethod CeShiTongGuo(Rowid As %String, UserId As %String) As %String
{
	s ret=""
	q:Rowid="" ret
	q:UserId="" ret
	s Date=+$h,Time=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR="108",IPML_FinishDate=:Date,IPML_FinishTime=:Time where IPML_Rowid=:Rowid) 
	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid) values (:Rowid,'135','108',:Date,:Time,:UserId,:locid))
	s ret="ceshiwancheng"
	q ret
}

ClassMethod Confrm(Rowid As %String) As %String
{
	s ret="XGSHIBAI" 
	q:Rowid="" ret
	s Date=+$h,Time=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s UserId=%session.Data("LOGON.USERID")
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR='92' where IPML_Rowid=:Rowid) 
	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid,IPMD_Remark) values (:Rowid,'149','92',:Date,:Time,:UserId,:locid,'按照新需求修改！'))
	&sql(update sqluser.PMP_ImprovmentRevList set IPRL_Type='' where PMP_ImprovementRevList_ParRef=:Rowid)
	s ret="XGQUEREN"
	q ret
}

ClassMethod NoConfrm(Rowid As %String) As %String
{
	s ret="XGSHIBAI" 
	q:Rowid="" ret
	s Date=+$h,Time=$p($h,",",2)
	s locid=%session.Data("LOGON.CTLOCID")  ;IPMD_Locid
	s UserId=%session.Data("LOGON.USERID")
	s chid=$o(^PMPImprovementDetaili("Flag",Rowid,"150",""),-1)
	s status=$p(^PMPImprovementDetail(Rowid,chid),"^",18)
	&sql(update sqluser.PMP_ImprovementList SET IPML_Status_DR=:status where IPML_Rowid=:Rowid)
	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR, IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_Locid,IPMD_Remark) values (:Rowid,'149',:status,:Date,:Time,:UserId,:locid,'按照原需求修改！'))
	s ret="XGQUERENN"
	Q ret
}

//s bbb=##class(web.PMP.PMPImprovementListNew).shenheliebiao("7")

ClassMethod shenheliebiao(Rowid As %String) As %String
{
	s ret="",username=""
	q:Rowid="" ret
	s Subrowid=$o(^PMPImprovementRevList(Rowid,""))
	b ;1
	i Subrowid'=""  d
	.s SubChidRowid="" f  s SubChidRowid=$o(^PMPImprovementRevList(Rowid,SubChidRowid)) q:SubChidRowid=""  d
	
	..s IPRLUser=$p(^PMPImprovementRevList(Rowid,SubChidRowid),"^",2)
	..i IPRLUser'="" s username=$p(^SSU("SSUSR",IPRLUser),"^",2)
	..i ret'="" s ret=ret_","_username
	..i ret="" s ret=username
	q ret
}

//s bbb=##class(web.PMP.PMPImprovementListNew).Careat("7")

ClassMethod Careat(Rowid As %String) As %String
{
	s ret=""
	q:Rowid="" ret
	s ret=$p(^PMPImprovementList(Rowid),"^",15)
	I ret'="" S ret=$P(^SSU("SSUSR",ret),"^",2)
	Q ret
}

ClassMethod ShenHeTiShi(input As %String) As %String
{
	s ret=""
	q:input="" ret
	s ROWIDD="" F  S ROWIDD=$O(^PMPPermission(ROWIDD)) Q:ROWIDD=""  D
	.s PERLevel=$p(^PMPPermission(ROWIDD),"^",3)
	.s PERSpare2=$p(^PMPPermission(ROWIDD),"^",5)
	.q:PERSpare2'="Y"
	.s ROWID="" F  S ROWID=$O(^PMPPermisBusinessi("PERBusUserDr",ROWIDD,input,ROWID)) Q:ROWID=""  D
	..s PERBusIsEffect=$P(^PMPPermisBusiness(ROWIDD,"E",ROWID),"^",3)
	..q:PERBusIsEffect'="Y"
	..s PERSpare4=$p(^PMPPermission(ROWIDD),"^",7)
	..i PERSpare4'="" s ret="是否需要"_$p(^PMPPermission(PERSpare4),"^",2)_"？"_","_ROWIDD
	q ret
}

Storage Default
{
<Data name="PMPImprovementListNewDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.PMP.PMPImprovementListNewD</DataLocation>
<DefaultData>PMPImprovementListNewDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.PMP.PMPImprovementListNewD</IdLocation>
<IndexLocation>^web.PMP.PMPImprovementListNewI</IndexLocation>
<StreamLocation>^web.PMP.PMPImprovementListNewS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
