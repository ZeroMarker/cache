Import Sqluser

Class web.PMP.PMPImprovementList Extends %Persistent
{

//列表-按钮-删除

/// w ##Class(web.PMP.PMPImprovementList)doDelete()
ClassMethod doDelete(RowId As %String) As %String
{
	//s ^FEEL("doSubmit")="delete！"
	
	s $P(^PMPImprovementList(RowId),"^",36)= 0    //置为提交状态
}

//列表-按钮-提交

/// w ##Class(web.PMP.PMPImprovementList)doSubmit()
ClassMethod doSubmit(RowId As %String) As %String
{
	//s ^FEEL("doSubmit")="进来了！"
	//s ^FEEL("AA")=##Class(web.PMP.PMPImprovementList).GetLevelRowId()
	
	s $P(^PMPImprovementList(RowId),"^",28)= 92    //置为提交状态
}

/// w ##Class(web.PMP.PMPImprovementList).insertImprovement(1^@^@^@^@)
ClassMethod insertImprovement(IStr As %String, HEmergency As %String) As %String
{
	s guser=""
 	i guser="" s guser=$G(%session.Data("LOGON.USERID"))
	
	 
	 //s ^FEEL("AA")=##Class(web.PMP.PMPImprovementList).GetLevelRowId()
	
	 s IPMLCode = $P(IStr,"^",1)			//需求Code
	 s IPMLName = $P(IStr,"^",2)			//需求名称
	 s IPMLEmergencyDR = HEmergency ;$P(IStr,"^",3)		//紧急程度
	 s IPMLModuleDR = $P(IStr,"^",4)		//所属模块 
	 s IPMLEngineerDR	 = $P(IStr,"^",5)	//指定工程师
	 
	 s IPMLDevelopUser = $P(IStr,"^",6)	    //开发工程师
	 s IPMLSituation = $P(IStr,"^",7)		//需求现状
	 s IPMLStatusDR = "91" ;$P(IStr,"^",8)		//需求状态  新建需求的时候，默认需求状态为保存"91"
	 s IPMLAuditor1 = $P(IStr,"^",9)		//医院审核人1
	 s IPMLAuditor2 = $P(IStr,"^",10)		//医院审核人2
	 
	 s IPMLAuditor3 = $P(IStr,"^",11)		//医院审核人3
	 s IPMLAuditor = $P(IStr,"^",11)		//项目审核人
	 s IPMLCreateTime = $p($h,",",2)		//创建时间
	 s IPMLCreateDate = +$h				    //创建日期
	 s IPMLCreateUserDR = guser ;$P(IStr,"^",13)	//创建人  默认当先登陆人 ss_user RowId
	 
	 s IPMLAssignEngineerDR = $P(IStr,"^",14) //指派工程师
	 //s IPMLTestDate = +$h ;$P(IStr,"^",15)		//测日期
	 //s IPMLTestTime = $p($h,",",2) ;$P(IStr,"^",0)		//测试时间
	 //s IPMLFinishDate = +$h ;$P(IStr,"^",16)		//完成日期
	 //s IPMLFinishTime = $p($h,",",2) ;$P(IStr,"^",0)		//完成时间
	 
	 s IPMLMenu = $P(IStr,"^",17)			//菜单名称
	 s IPMLCreateLocDR = $P(IStr,"^",18)	//创建科室
	 s IPMLCreateTel = $P(IStr,"^",19)		//创建者电话
	 s IPMLAdjunctFlag = "0" ;$P(IStr,"^",20)	//附件标志
	 s IPMLSolution = $P(IStr,"^",21)		//解决方案
	 
	 s IPMLType = $P(IStr,"^",22)			//需求类型
	 s IPMLPredictTime = "" ;$P(IStr,"^",23)	//预计完成时间
	 s IPMLProjectDR = $P(IStr,"^",24)		//所属项目
	 s IPMLDegreeDR = $P(IStr,"^",25)		//严重程度
	 s IPMLMode = "BS" ;$P(IStr,"^",26)           //模式
	 s IPMLStandby1 = "1"                   //1为有效 0为无效 删除用
	 
	 s IPMLStandby2= ##Class(web.PMP.PMPImprovementList).GetLevelRowId() //$o(^PMPPermission("PER_Level","1",levelRowId)) //
	 
	
	//PMPImprovementList
	&sql(insert into sqluser.PMP_ImprovementList 
   (IPML_Code, IPML_Name, IPML_Emergency_DR, IPML_Module_DR, IPML_Engineer_DR,
 	IPML_DevelopUser, IPML_Situation, IPML_Status_DR, IPML_Auditor1, IPML_Auditor2,
	IPML_Auditor3, IPML_Auditor, IPML_CreateTime, IPML_CreateDate, IPML_CreateUser_DR,
 	IPML_AssignEngineer_DR, IPML_TestDate, IPML_TestTime, IPML_FinishDate, IPML_FinishTime,
 	IPML_Menu, IPML_CreateLoc_DR, IPML_CreateTel, IPML_AdjunctFlag, IPML_Solution,
 	IPML_Type, IPML_PredictTime, IPML_Project_DR, IPML_Degree_DR, IPML_Mode,IPML_Standby1,
 	IPML_Standby2)
	     values(
	:IPMLCode,:IPMLName,:IPMLEmergencyDR,:IPMLModuleDR,:IPMLEngineerDR,
 	:IPMLDevelopUser,:IPMLSituation,:IPMLStatusDR,:IPMLAuditor1,:IPMLAuditor2,
	:IPMLAuditor3,:IPMLAuditor,:IPMLCreateTime,:IPMLCreateDate,:IPMLCreateUserDR,
 	:IPMLAssignEngineerDR,:IPMLTestDate,:IPMLTestTime,:IPMLFinishDate,:IPMLFinishTime,
 	:IPMLMenu,:IPMLCreateLocDR,:IPMLCreateTel,:IPMLAdjunctFlag,:IPMLSolution,
 	:IPMLType,:IPMLPredictTime,:IPMLProjectDR,:IPMLDegreeDR,:IPMLMode,:IPMLStandby1,
 	:IPMLStandby2))
 	
	s rtn=SQLCODE
	q:SQLCODE
	
	 
	
	;set ImpObject=##class(User.PMPImprovementList).%New()
	 //s IStr="1^2^3^4^5^6^7^8^9^11^12^13^14^15^16^17^18^19^21^22^23^24^25^^^^^^^^^^^^^^^^"
	//s ImpObject.IPMLRowid = $P(IStr,"^",1)	     	//Rowid
	;s ImpObject.IPMLCode = $P(IStr,"^",1)			//需求Code
	;s ImpObject.IPMLName = $P(IStr,"^",2)			//需求名称
	;s ImpObject.IPMLEmergencyDR = ##class(User.PMPDictionary3).%OpenId($P(IStr,"^",3)) 		//紧急程度
	;s ImpObject.IPMLModuleDR = ##class(User.PMPModule).%OpenId($P(IStr,"^",4))		//所属模块 
	;s ImpObject.IPMLEngineerDR	 = $P(IStr,"^",5)	//指定工程师
	;s ImpObject.IPMLDevelopUser = $P(IStr,"^",6)	//开发工程师
	;s ImpObject.IPMLSituation = $P(IStr,"^",7)		//需求现状
	;s ImpObject.IPMLStatusDR = $P(IStr,"^",8)		//需求状态
	;s ImpObject.IPMLAuditor1 = $P(IStr,"^",9)		//医院审核人1
	;s ImpObject.IPMLAuditor2 = $P(IStr,"^",10)		//医院审核人2
	//s ImpObject.IPMLAuditor3 = $P(IStr,"^",11)		//医院审核人3
	;s ImpObject.IPMLAuditor = $P(IStr,"^",11)		//项目审核人
	;s ImpObject.IPMLCreateTime = $p($h,",",2)		//创建时间
	;s ImpObject.IPMLCreateDate = +$h		//创建日期
	;s ImpObject.IPMLCreateUserDR = $P(IStr,"^",13)	//创建人
	;s ImpObject.IPMLAssignEngineerDR = $P(IStr,"^",14)		//指派工程师
	;s ImpObject.IPMLTestDate = $P(IStr,"^",15)		//测日期
	;//s ImpObject.IPMLTestTime = $P(IStr,"^",0)		//测试时间
	;s ImpObject.IPMLFinishDate = $P(IStr,"^",16)		//完成日期
	;//s ImpObject.IPMLFinishTime = $P(IStr,"^",0)		//完成时间
	;s ImpObject.IPMLMenu = $P(IStr,"^",17)			//菜单名称
	;s ImpObject.IPMLCreateLocDR = $P(IStr,"^",18)		//创建科室
	;s ImpObject.IPMLCreateTel = $P(IStr,"^",19)		//创建者电话
	;s ImpObject.IPMLAdjunctFlag = $P(IStr,"^",20)		//附件标志
	;s ImpObject.IPMLSolution = $P(IStr,"^",21)		//解决方案
	;s ImpObject.IPMLType = $P(IStr,"^",22)			//需求类型
	;s ImpObject.IPMLPredictTime = $P(IStr,"^",23)		//预计完成时间
	;s ImpObject.IPMLProjectDR = $P(IStr,"^",24)		//所属项目
	;s ImpObject.IPMLDegreeDR = $P(IStr,"^",25)		//严重程度
	;s ImpObject.IPMLMode = $P(IStr,"^",26)       //模式

	;set sc=ImpObject.%Save()
	
	//i $$$ISERR(sc) w $System.Status.DisplayError(),!
    ;i $$$ISERR(sc) q -1
 	;quit ImpObject.%Id()
}

Query GetPMPImprovementList(SDate As %String, EDate As %String, TSex As %String, TAdmReason As %String) As %Query(ROWSPEC = "xh:%String,IPMLOName:%String,IPMLOEmergency:%String,IPMLOModule:%String,IPMLOEngineer:%String,IPMLOStatus:%String,IPMLOCreateTime:%String,IPMLOCreateDate:%String,submit:%String,update:%String,delete:%String,progress:%String,RowId:%String") [ SqlProc ]
{
}

// 需求名称    紧急程度       所属模块     指定工程师     需求状态      创建时间           创建日期

// IPMLOName  IPMLOEmergency  IPMLOModule  IPMLOEngineer  IPMLOStatus   IPMLOCreateTime    IPMLOCreateDate

// IPML_Name:%String,IPML_Emergency:%String,IPML_Module:%String,IPML_Engineer:%String,IPML_Status:%String,IPML_CreateTime:%String,IPML_CreateDate:%String

// D ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","GetPMPImprovementList","","")	

ClassMethod GetPMPImprovementListExecute(ByRef qHandle As %Binary, SDate As %String, EDate As %String, IPMLName As %String, TAdmReason As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	i $g(ind)="" s ind=1
 
 	s guser=""
 	i guser="" s guser=$G(%session.Data("LOGON.USERID"))
 
	s ^FEEL("IStr")=""
 	;s ^FE("tmp")=SDate_"^"_EDate
 	
 	s xh=0
 	i SDate="" s SDate=+$h
	i EDate="" s EDate=+$h
 	
 	i SDate["-" s SDate = $zdh(SDate,3)
	i EDate["-" s EDate = $zdh(EDate,3)
	i SDate["/" s SDate = $zdh(SDate,3)
	i EDate["/" s EDate = $zdh(EDate,3)
	//
	for IPCreateDate=SDate:1:EDate d 
 	.s tmpRowid=""
 	.f  s tmpRowid=$o(^PMPImprovementListi("CreateDate",IPCreateDate,tmpRowid)) q:tmpRowid=""  d
 	..d GetDetails(tmpRowid)
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
GetDetails(tmpRowid)
	s xh=xh+1	
 	s IPMLOName = $p(^PMPImprovementList(tmpRowid),"^",2)
 	s IPMLOEmergency = $P(^PMPImprovementList(tmpRowid),"^",3)
 	s IPMLOModule = $P(^PMPImprovementList(tmpRowid),"^",4)
 	s IPMLOEngineer = $P(^PMPImprovementList(tmpRowid),"^",5)
 	
 	// $p(^PMPDictionary(),"^",2)
 	// $P(^PMPImprovementList(tmpRowid),"^",8)
 	// $p(^PMPDictionary(91),"^",2)
 	
 	s IPMLOStatus = $p(^PMPDictionary($P(^PMPImprovementList(tmpRowid),"^",28)),"^",2)
 	s IPMLOCreateTime = $zt($P(^PMPImprovementList(tmpRowid),"^",14))
 	s IPMLOCreateDate = $zd($P(^PMPImprovementList(tmpRowid),"^",11),3)
 	s submit="提交"
 	s update="更新"
 	s delete="删除"
 	s progress="进度"
 	s RowId = tmpRowid
 	
 	s sdy1=$P(^PMPImprovementList(tmpRowid),"^",36)
 	q:sdy1'=1
 	
 	d OutputRow 
 	q
								 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

OutputRow
    
	set Data=$lb(xh,IPMLOName,IPMLOEmergency,IPMLOModule,IPMLOEngineer,IPMLOStatus,IPMLOCreateTime,IPMLOCreateDate,submit,update,delete,progress,RowId) 
 	//set Data=$lb(sName,sIpno,$zd(papmiDate,3),sCTLocCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPMPImprovementListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPMPImprovementListExecute ]
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

ClassMethod GetPMPImprovementListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPMPImprovementListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

//D ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","GetEmergency")

//紧急程度

Query GetEmergency(READesc As %String) As %SQLQuery(CONTAINID = 1)
{
  select DTY_Desc,DTY_Code,DTY_Rowid from sqluser.PMP_Dictionary where DTY_Flag = "Emergency"
}

//需求状态

Query GetImprovement(READesc As %String) As %SQLQuery(CONTAINID = 1)
{
  select DTY_Desc,DTY_Code,DTY_Rowid from sqluser.PMP_Dictionary where DTY_Flag = "Improvement"
}

//所属项目

Query GetProject(READesc As %String) As %SQLQuery(CONTAINID = 1)
{
  select PJT_Desc,PJT_Code,PJT_Rowid from sqluser.PMP_Project where PJT_Hospital_DR =(select HOSP_RowId from sqluser.CT_hospital)
}

// D ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","GetLevelRowId")

//通过所属项目ID，Level 获取权限RowId

ClassMethod GetLevelRowId(READesc As %String) As %String
{
	s LevelRowId=""
	&sql(select PER_Rowid into :LevelRowId from sqluser.PMP_Permission where PER_Level="1" and PER_Project_DR="1")
	q LevelRowId
}

Query ImprovementList(StDate As %String, EnDate As %String, PMPCode As %String, PMPDesc As %String, PMPModule As %String, PMPProduct As %String, User As %String, Finish As %String) As %Query(ROWSPEC = "TYPCode:%String,TYPName:%String,TYPCreatDate:%String,TYPCheckDate:%String,TYPCreatUser:%String,TYPStatus:%String,TYPEmergency:%String,TYPtype:%String,TYPDegree:%String,TYPAccessory:%String,TYPRowid:%String,TYPSituation:%String,TYPCreateTel:%String,TYPPredictTime:%String,IPMLModule:%String,IPMLStatusDR:%String,IPMLMenu:%String,IPMLDevelopUser:%String,IPMLStandby3:%String")
{
}

//张枕平  2014-10-18

//根据条件查询需求列表

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","ImprovementList","","","","","","","","")

ClassMethod ImprovementListExecute(ByRef qHandle As %Binary, StDate As %String, EnDate As %String, PMPCode As %String, PMPDesc As %String, PMPModule As %String, PMPProduct As %String, User As %String, Finish As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^zzp("11")=StDate_"^"_EnDate_"^"_PMPCode_"^"_PMPDesc_"^"_PMPModule_"^"_PMPProduct_"^"_User_"^"_Finish
	S (TYPCode,TYPName,TYPCreatDate,TYPCheckDate,TYPCreatUser,TYPStatus,TYPEmergency,TYPtype,TYPDegree,TYPAccessory,TYPSituation,TYPCreateTel,TYPPredictTime,IPMLModule,IPMLStatusDR,IPMLMenu,IPMLDevelopUser,IPMLStandby3)=""
	s userId=%session.Data("LOGON.USERID")
	;s userId="1"
	s PJURowid=$o(^PMPProjectUseri("SSUSER",userId,""))
	b ;2
	i StDate="" s StDate=+$h-15
	i StDate'=""  d
	.i EnDate="" s EnDate=+$h
	.f date=StDate:1:EnDate d
	..s IPMLRowid="" f  s IPMLRowid=$o(^PMPImprovementListi("CreateDate",date,IPMLRowid)) q:IPMLRowid=""  d
	...s IPMLAssignEngineerDR=$p(^PMPImprovementList(IPMLRowid),"^",4)
	...q:IPMLAssignEngineerDR'=userId
	...b ;12
	...d query
	e  d
	.s IPMLRowid="" f  s IPMLRowid=$o(^PMPImprovementList(IPMLRowid)) q:IPMLRowid=""  d
	..s IPMLAssignEngineerDR=$p(^PMPImprovementList(IPMLRowid),"^",4)
	..q:IPMLAssignEngineerDR'=PJURowid
	..d query
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow   
	set Data=$lb(TYPCode,TYPName,TYPCreatDate,TYPCheckDate,TYPCreatUser,TYPStatus,TYPEmergency,TYPtype,TYPDegree,TYPAccessory,TYPRowid,TYPSituation,TYPCreateTel,TYPPredictTime,IPMLModule,IPMLStatusDR,IPMLMenu,IPMLDevelopUser,IPMLStandby3)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
query
    b ;11
    s IPMLStatusDR=$p(^PMPImprovementList(IPMLRowid),"^",28)
    s TYPStatus=$P(^PMPDictionary(IPMLStatusDR),"^",2)
    s DTYFlag=$P(^PMPDictionary(IPMLStatusDR),"^",3)
    ;s ^zzp("22")= Finish_"^"_TYPStatus_"^"_DTYFlag
	q:(Finish="")&(TYPStatus="完成")&(DTYFlag="Improvement")
	q:(Finish="on")&(TYPStatus'="完成")&(DTYFlag="Improvement")
	s TYPCode=$p(^PMPImprovementList(IPMLRowid),"^",1)
	q:(PMPCode'="")&(TYPCode'[PMPCode)
	s TYPName=$p(^PMPImprovementList(IPMLRowid),"^",2)
	q:(PMPDesc'="")&(TYPName'[PMPDesc)
	s IPMLModuleDR=$p(^PMPImprovementList(IPMLRowid),"^",23)
	s IPMLModule="",MODEProduct=""
	s desc=""
	i IPMLModuleDR'=""  d
	.s IPMLModule=$p(^PMPModule(IPMLModuleDR),"^",2)
	.s MODEProduct=$p(^PMPModule(IPMLModuleDR),"^",7)
	.s desc=$p(^PMPDictionary(MODEProduct),"^",2)
	q:(PMPModule'="")&(IPMLModule'=PMPModule)
	s ^zzpzzp("11111")=desc
	
	q:(PMPProduct'="")&(PMPProduct'=desc)
	s IPMLCreateUserDR=$p(^PMPImprovementList(IPMLRowid),"^",15)
	s TYPCreatUser=$p(^SSU("SSUSR",IPMLCreateUserDR),"^",2)
	q:(User'="")&(User'=TYPCreatUser)
	s TYPCreatDate=$p(^PMPImprovementList(IPMLRowid),"^",11)
	S TYPCreatDate=$ZD(TYPCreatDate,3)
	s IPMDChildsub=$o(^PMPImprovementDetaili("Flag",IPMLRowid,"133",""))
	s TYPCheckDate=""
	i IPMDChildsub'=""  d
	.s TYPCheckDate=$p(^PMPImprovementDetail(IPMLRowid,IPMDChildsub),"^",11)
	i TYPCheckDate'="" s TYPCheckDate=$zd(TYPCheckDate,3)
	s TYPEmergencyDR=$p(^PMPImprovementList(IPMLRowid),"^",18)
	i TYPEmergencyDR="" s TYPEmergency=""
	i TYPEmergencyDR'=""  s TYPEmergency=$P(^PMPDictionary(TYPEmergencyDR),"^",2)
	s TYPtypeDR=$p(^PMPImprovementList(IPMLRowid),"^",31)
	i TYPtypeDR="" s TYPtype=""
	i TYPtypeDR'="" s TYPtype=$p(^PMPDictionary(TYPtypeDR),"^",2)
	s TYPDegreeDR=$p(^PMPImprovementList(IPMLRowid),"^",16)
	i TYPDegreeDR="" s TYPDegree=""
	i TYPDegreeDR'="" s TYPDegree=$p(^PMPDictionary(TYPDegreeDR),"^",2)
	s TYPAccessory=$p(^PMPImprovementList(IPMLRowid),"^",3)
	i TYPAccessory'="Y" s TYPAccessory=""
	s TYPRowid=IPMLRowid
	s TYPSituation=$p(^PMPImprovementList(IPMLRowid),"^",26)
	s TYPCreateTel=$p(^PMPImprovementList(IPMLRowid),"^",13)
	S TYPPredictTime=$p(^PMPImprovementList(IPMLRowid),"^",24)
	s IPMLMenu=$p(^PMPImprovementList(IPMLRowid),"^",21)
	s IPMLDevelopUser=$p(^PMPImprovementList(IPMLRowid),"^",17)
	s IPMLStandby3=$p(^PMPImprovementList(IPMLRowid),"^",34)
	D OutputRow
}

ClassMethod ImprovementListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ImprovementListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod ImprovementListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ImprovementListExecute ]
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

Query TYPRowidValue(str As %String) As %Query(ROWSPEC = "TYP1username:%String,TYP1MENU:%String,TYP1date:%String,TYP1ID:%String")
{
}

//张枕平  2014-10-18

//根据条件查询需求处理列表

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","TYPRowidValue","48^49^50^51")

ClassMethod TYPRowidValueExecute(ByRef qHandle As %Binary, str As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s ^zzp("111")=str 
	s (TYP1username,TYP1MENU,TYP1date,TYP1ID,IPMDStatusDR1,IPMDFlag1)=""
	i str="" d
	.d OutputRow1
	e  d
	.f lenth=$l(str,"^"):-1:1  d
	..i $l(str,"^")>1  d
	...s strstr=$p(str,"^",lenth)
	..e  s strstr=str
	..S MODTChildsub="" f  s MODTChildsub=$O(^PMPImprovementDetail(strstr,MODTChildsub),-1) Q:MODTChildsub=""  D
	...q:MODTChildsub="E"
	...s IPMDFlag=$p(^PMPImprovementDetail(strstr,MODTChildsub),"^",8)
	...i IPMDFlag'="" s IPMDFlag1=$p(^PMPDictionary(IPMDFlag),"^",2)
	...s IPMDStatusDR=$p(^PMPImprovementDetail(strstr,MODTChildsub),"^",10)
	...i IPMDStatusDR'="" s IPMDStatusDR1=$p(^PMPDictionary(IPMDStatusDR),"^",2)
	...s TYP1MENU=IPMDFlag1_" "_IPMDStatusDR1
	...s IPMDUpdateUserDR=$p(^PMPImprovementDetail(strstr,MODTChildsub),"^",13)
	...i IPMDUpdateUserDR'="" s TYP1username=$p(^SSU("SSUSR",IPMDUpdateUserDR),"^",2)
	...i IPMDUpdateUserDR="" s TYP1username=""
	...S IPMDUpdateDate=$p(^PMPImprovementDetail(strstr,MODTChildsub),"^",11)
	...s IPMDUpdateDate=$zd(IPMDUpdateDate,3)
	...S IPMDUpdateTime=$p(^PMPImprovementDetail(strstr,MODTChildsub),"^",12)
	...s IPMDUpdateTime=$zt(IPMDUpdateTime,1)
	...s TYP1date=IPMDUpdateDate_" "_IPMDUpdateTime
	...s TYP1ID=strstr_"^"_MODTChildsub
	...i $l(str,"^")>1 s TYP1username="第"_""_lenth_""_"次："_TYP1username
	...d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1  
	set Data=$lb(TYP1username,TYP1MENU,TYP1date,TYP1ID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod TYPRowidValueClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TYPRowidValueExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod TYPRowidValueFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TYPRowidValueExecute ]
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

// s bbb=##class(web.PMP.PMPImprovementList).selectPMPIImprovementAdjunct("8","Improvement")

ClassMethod selectPMPIImprovementAdjunct(Improve As %String, Affiliation As %String) As %String
{
	s ret=""
	
	q:(Improve="")||(Affiliation="")
	s rowid="" f  s rowid=$o(^PMPImproveAdjuncti("Improve",Improve,Affiliation,rowid)) q:rowid=""  d
	.s IPAJLocation=$p(^PMPImprovementAdjunct(rowid),"^",3)
	.s IPAJName=$p(^PMPImprovementAdjunct(rowid),"^",4)
	.s Location="\\172.18.10.57\dhccpmp\"
	.f ii=1:1:$l(IPAJLocation,"\")  d
	..;i Location="" s Location=$p(IPAJLocation,"\",1)
	..;I (Location'="")&(ii'="1") s Location=Location_"\\"_$p(IPAJLocation,"\",ii)
	.i ret'="" s ret=ret_"^"_Location_","_IPAJName
	.i ret="" s ret=Location_","_IPAJName
	Q ret
}

//字符串转换（转换路径中的\转义字符）

//s bbb=##class(web.PMP.PMPImprovementList).EscapingChange("C:\Users\Administrator\Desktop\1111")

ClassMethod EscapingChange(input As %String) As %String
{
	s ret=""
	q:input=""
	f ii=1:1:$l(input,"\")  d
	.i ret="" s ret=$p(input,"\",1)
	.i (ret'="")&(ii'="1") s ret=ret_"\\"_$p(input,"\",ii)
	q ret
}

//s bbb=##class(web.PMP.PMPImprovementList).EscapingChangechang("E:\Foxmail地址簿_20140707.csv||E:\崔丹_人民医院HIS系统录入信息汇总20140707.doc")

ClassMethod EscapingChangechang(input As %String) As %String
{
	s ret=""
	q:input=""
	f jj=1:1:($l(input,"||")) d
	.s str=$p(input,"||",jj)
	.s ret1=""
	.f ii=1:1:$l(str,"\")  d
	..i ret1="" s ret1=$p(str,"\",1)
	..i (ret1'="")&(ii'="1") s ret1=ret1_"\\"_$p(str,"\",ii)
	..i ii=$l(str,"\")  d
	...i ret'="" s ret=ret_"||"_ret1
	...i ret="" s ret=ret1
	q ret
}

//s bbb=d ##class(web.PMP.PMPImprovementList).fujianUpdate("6&1447,1451&1&12:00&24/10/2014&80&&办公司&俄方日 s.df集散地法核算地方纷纷 返回是否发发发的好发的发   &1&109")

ClassMethod fujianUpdate(input As %String) As %String
{
	s ret=""
	q:input=""
	s rowid=$p(input,"&",1)  //需求id
	s COMMClentList=$p(input,"&",2)  //客户列表
	s COMMUserList=$p(input,"&",3)  //工程师列表
	s COMMTime=$p(input,"&",4)  //沟通时间
	i COMMTime'="" s COMMTime=$zth(COMMTime,1)
	s COMMDate=$p(input,"&",5)  //沟通日期
	s COMMDate=$zdh(COMMDate,4)
	s COMMUseTime1=$p(input,"&",6)  //沟通时长
	s COMMfujianList=$p(input,"&",7)  //附件列表
	i COMMfujianList="" s fujian="No" 
	i COMMfujianList'="" s fujian="Yes"
	s COMMdel=$p(input,"&",8)  //沟通地点
	s COMMmenu=$p(input,"&",9)  //沟通内容
	s COMMUser=$p(input,"&",10) //更新用户
	s XQzhuangtaiIDvalue=$p(input,"&",11)  //需求状态
	s data=$p($h,",",1),time=$p($h,",",2)
	&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR,IPMD_Remark,IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR,IPMD_CommunicationUser_DR,IPMD_CommunicationUser1_DR,IPMD_Standby1,IPMD_CommunicationDate,IPMD_CommunicationTime,IPMD_Accessory,IPMD_Standby2) values (:rowid,"134",:XQzhuangtaiIDvalue,:COMMmenu,:data,:time,:COMMUser,:COMMUserList,:COMMClentList,:COMMUseTime1,:COMMDate,:COMMTime,:fujian,:COMMdel))
	s aa=rowid_"||"_$o(^PMPImprovementDetaili("Flag",rowid,"134",""),-1)
	i (fujian="Yes") d
	.f ii=1:1:$l(COMMfujianList,"||")  d
	..s fujiandizhi=$p(COMMfujianList,"||",ii)
	..s fujianname=$p(fujiandizhi,"\",$l(COMMfujianList,"\"))
	..&sql(insert into sqluser.PMP_ImprovementAdjunct (IPAJ_Improve,IPAJ_Name,IPAJ_Location,IPAJ_Remark,IPAJ_Affiliation,IPAJ_User_DR,IPAJ_Date,IPAJ_Time) values (:aa,:fujianname,:fujiandizhi,:COMMmenu,"COMM",:COMMUser,:data,:time))
	..s ret="14"
	q ret
}

Query SelectPMPModule(XQmokuai As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

//张枕平  2014-10-18

//提供查询下拉框

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","SelectPMPModule","")

ClassMethod SelectPMPModuleExecute(ByRef qHandle As %Binary, XQmokuai As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s MODERowid="" f  s MODERowid=$o(^PMPModule(MODERowid)) q:MODERowid=""  d
	.s desc=$p(^PMPModule(MODERowid),"^",2)
	.q:desc=""
	.s code=$p(^PMPModule(MODERowid),"^",1)
	.q:(XQmokuai'="")&(desc'[XQmokuai)
	.s rowid=MODERowid
	.d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SelectPMPModuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPMPModuleExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectPMPModuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPMPModuleExecute ]
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

Query PMPModule(PMPModule As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

//张枕平  2014-10-18

//提供查询下拉框

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","PMPModule","")

ClassMethod PMPModuleExecute(ByRef qHandle As %Binary, PMPModule As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s MODERowid="" f  s MODERowid=$o(^PMPModule(MODERowid)) q:MODERowid=""  d
	.q:MODERowid="FLAG"
	.s desc=$p(^PMPModule(MODERowid),"^",2)
	.q:desc=""
	.s code=$p(^PMPModule(MODERowid),"^",1)
	.q:(PMPModule'="")&(desc'[PMPModule)
	.s rowid=MODERowid
	.d OutputRow3
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod PMPModuleClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMPModuleExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod PMPModuleFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMPModuleExecute ]
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

Query UserNameBySQL(User As %String) As %SQLQuery(CONTAINID = 1)
{
	select SSUSR_Name,SSUSR_Initials,SSUSR_RowId from SQLUSER.SS_User where  SSUSR_Name %STARTSWITH %ALPHAUP (:User) or SSUSR_Initials %STARTSWITH %ALPHAUP(:User)
}

Query PMPProduct(PMPProduct As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

//张枕平  2014-10-18

//提供查询下拉框

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","PMPProduct","")

ClassMethod PMPProductExecute(ByRef qHandle As %Binary, PMPProduct As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s DTYROWID="" f  s DTYROWID=$o(^PMPDictionary(DTYROWID)) q:DTYROWID=""  d
	.Q:DTYROWID="FLAG"
	.S code=$p(^PMPDictionary(DTYROWID),"^",1)
	.s desc=$p(^PMPDictionary(DTYROWID),"^",2)
	.s flag=$p(^PMPDictionary(DTYROWID),"^",3)
	.q:flag'="Product"
	.q:(PMPProduct'="")&(desc'[PMPProduct)
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

Query XQzhuangtaiID(XQzhuangtaiID As %String = "", XQzhuangtai As %String = "") As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

//张枕平  2014-10-18

//提供查询下拉框

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","XQzhuangtaiID","")

ClassMethod XQzhuangtaiIDExecute(ByRef qHandle As %Binary, XQzhuangtaiID As %String = "", XQzhuangtai As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i XQzhuangtaiID="" s XQzhuangtaiID="107"
	s DTYROWID="" f  s DTYROWID=$o(^PMPDictionary(DTYROWID)) q:DTYROWID=""  d
	.q:(XQzhuangtaiID'="")&(DTYROWID'="106")&(DTYROWID<XQzhuangtaiID)
	.s flag=$p(^PMPDictionary(DTYROWID),"^",3)
	.q:flag'="Improvement"
	.S code=$p(^PMPDictionary(DTYROWID),"^",1)
	.s desc=$p(^PMPDictionary(DTYROWID),"^",2)
	.q:desc="完成"
	.q:(XQzhuangtai'="")&(desc'[XQzhuangtai)
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

ClassMethod XQzhuangtaiIDClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = XQzhuangtaiIDExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod XQzhuangtaiIDFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = XQzhuangtaiIDExecute ]
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

ClassMethod mokuai(input As %String) As %String
{
	s ret=""
	q:input="" ret
	s rowid=$o(^PMPModulei("Desc",input,""))
	s ret=rowid
	q ret
}

ClassMethod zhuangtai(input As %String) As %String
{
	s ret=""
	s DTYROWID="" f  s DTYROWID=$o(^PMPDictionary(DTYROWID)) q:DTYROWID=""  d
	.s flag=$p(^PMPDictionary(DTYROWID),"^",3)
	.q:flag'="Improvement"
	.s desc=$p(^PMPDictionary(DTYROWID),"^",2)
	.q:desc'=input
	s ret=DTYROWID
	q ret
}

ClassMethod update(input As %String) As %String
{
	s ret="0"
	q:input=""
	s PmpRowidValue=$p(input,"^",1)
	s XQmokuaiValue=$p(input,"^",2)
	s XQzhuangtaiValue=$p(input,"^",3)
	s XQkaifaValue=$p(input,"^",4)
	s PredictTimeValue=$p(input,"^",5)
	s XQchuliguochengValue=$p(input,"^",6)
	s XQzhuangtaiIDValue=$p(input,"^",7)
	s XQmokuaiIDValue=$p(input,"^",8)
	s userId=$p(input,"^",9)
	s xckfId=$p(input,"^",10)
	s data=$p($h,",",1),time=$p($h,",",2)
	i XQchuliguochengValue["请在此处输入处理过程：" s XQchuliguochengValue=$p(XQchuliguochengValue,"请在此处输入处理过程：",2)
	i PredictTimeValue["工作" s PredictTimeValue=$p(PredictTimeValue,"工作日",1)
	i XQzhuangtaiValue="测试"  d
	.&sql(update sqluser.PMP_ImprovementList set IPML_Module_DR=:XQmokuaiIDValue,IPML_DevelopUser=:XQkaifaValue,IPML_Status_DR=:XQzhuangtaiIDValue,IPML_TestDate=:data,IPML_TestTime=:time,IPML_Solution=:XQchuliguochengValue,IPML_PredictTime=:PredictTimeValue,IPML_Standtb7=:xckfId where IPML_Rowid=:PmpRowidValue)
	.&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR,IPMD_Remark,IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR) values (:PmpRowidValue,:XQzhuangtaiIDValue,:XQzhuangtaiIDValue,:XQchuliguochengValue,:data,:time,:userId))
	.s ret="9"
	e  d
	.&sql(update sqluser.PMP_ImprovementList set IPML_Module_DR=:XQmokuaiIDValue,IPML_DevelopUser=:XQkaifaValue,IPML_Status_DR=:XQzhuangtaiIDValue,IPML_Solution=:XQchuliguochengValue,IPML_PredictTime=:PredictTimeValue,IPML_Standtb7=:xckfId where IPML_Rowid=:PmpRowidValue)
	.&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR,IPMD_Remark,IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR) values (:PmpRowidValue,:XQzhuangtaiIDValue,:XQzhuangtaiIDValue,:XQchuliguochengValue,:data,:time,:userId))
	.s ret="9"
	q ret
}

ClassMethod insert(input As %String, type As %String) As %String
{
	s ret="0"
	q:(input="")||(type="")
	s PmpRowidValue=$p(input,"^",1)
	s XQmokuaiValue=$p(input,"^",2)
	s XQzhuangtaiValue=$p(input,"^",3)
	s XQkaifaValue=$p(input,"^",4)
	s PredictTimeValue=$p(input,"^",5)
	s XQchuliguochengValue=$p(input,"^",6)
	s XQzhuangtaiIDValue=$p(input,"^",7)
	s XQmokuaiIDValue=$p(input,"^",8)
	s userId=$p(input,"^",9)
	s data=$p($h,",",1),time=$p($h,",",2)
	i XQchuliguochengValue["请在此处输入处理过程：" s XQchuliguochengValue=$p(XQchuliguochengValue,"请在此处输入处理过程：",2)
	i PredictTimeValue["工作" s PredictTimeValue=$p(PredictTimeValue,"工作日",1)
	i type="XQzhuangtaiValue"  d
	.&sql(insert into sqluser.PMP_ImprovementDetail (PMP_ImprovementList_ParRef,IPMD_Flag,IPMD_Status_DR,IPMD_Remark,IPMD_UpdateDate,IPMD_UpdateTime,IPMD_UpdateUser_DR) values (:PmpRowidValue,"135",:XQzhuangtaiIDValue,:XQchuliguochengValue,:data,:time,:userId))
	.s ret="9"
	q ret
}

Query COMMUuser(COMMUuser As %String) As %Query(ROWSPEC = "desc:%String,rowid:%String")
{
}

//张枕平  2014-10-18

//提供查询下拉框

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","COMMUuser","")

ClassMethod COMMUuserExecute(ByRef qHandle As %Binary, COMMUuser As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i COMMUuser'="" s COMMUuser=$$ALPHAUP^SSUTIL4(COMMUuser)
	s PJURowid="" f  s PJURowid=$o(^PMPProjectUser(PJURowid)) q:PJURowid=""  d
	.s PJUEnDate=$p(^PMPProjectUser(PJURowid),"^",5)
	.q:PJUEnDate'=""
	.s PJUUserDR=$p(^PMPProjectUser(PJURowid),"^",1)
	.q:$g(^SSU("SSUSR",PJUUserDR))=""
	.s desc=$P(^SSU("SSUSR",PJUUserDR),"^",2)
	.s id=$P(^SSU("SSUSR",PJUUserDR),"^",1)
	.s desc1=##Class(web.DHCINSUPort).GetCNCODE(desc,4,"")_desc_id_##Class(web.DHCINSUPort).GetCNCODE(desc,3,"")
	.q:(COMMUuser'="")&(desc1'[COMMUuser)
	.s rowid=PJUUserDR
	.d OutputRow6
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(desc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod COMMUuserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = COMMUuserExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod COMMUuserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = COMMUuserExecute ]
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

Query COMMClenteBySQL(COMMClent1 As %String) As %SQLQuery(CONTAINID = 1)
{
	select SSUSR_Name,SSUSR_Initials,SSUSR_RowId from SQLUSER.SS_User where  SSUSR_Name %STARTSWITH %ALPHAUP (:COMMClent1) or SSUSR_Initials %STARTSWITH %ALPHAUP(:COMMClent1) or SSUSR_GivenName %STARTSWITH %ALPHAUP(:COMMClent1)
}

//s bbb=##class(web.PMP.PMPImprovementList).jichushujv("6^14")

ClassMethod jichushujv(input As %String) As %String
{
	s ret=""
	q:input=""
	s str=$p(input,"^",1)
	s MODTChildsub=$p(input,"^",2)
	s IPMDFlag=$p(^PMPImprovementDetail(str,MODTChildsub),"^",8)
	i IPMDFlag'="" s IPMDFlag1=$p(^PMPDictionary(IPMDFlag),"^",2)
	s IPMDStatusDR=$p(^PMPImprovementDetail(str,MODTChildsub),"^",10)
	i IPMDStatusDR'="" s IPMDStatusDR1=$p(^PMPDictionary(IPMDStatusDR),"^",2)
	s TYP1MENU=IPMDFlag1_" "_IPMDStatusDR1
	s IPMDUpdateUserDR=$p(^PMPImprovementDetail(str,MODTChildsub),"^",13)
	s TYP1username=$p(^SSU("SSUSR",IPMDUpdateUserDR),"^",2)
	S IPMDUpdateDate=$p(^PMPImprovementDetail(str,MODTChildsub),"^",11)
	s IPMDUpdateDate=$zd(IPMDUpdateDate,3)
	S IPMDUpdateTime=$p(^PMPImprovementDetail(str,MODTChildsub),"^",12)
	s IPMDUpdateTime=$zt(IPMDUpdateTime,1)
	S Rearmk=$p(^PMPImprovementDetail(str,MODTChildsub),"^",9)
	s CommunicationUserDR=$p(^PMPImprovementDetail(str,MODTChildsub),"^",6)
	i CommunicationUserDR[","  d
	.s user1=""
	.f ii=1:1:$l(CommunicationUserDR,",")   d
	..i user1="" s user1=$p(^SSU("SSUSR",$p(CommunicationUserDR,",",ii)),"^",2)
	..i user1'="" s user1=user1_","_$p(^SSU("SSUSR",$p(CommunicationUserDR,",",ii)),"^",2)
	e  d
	.i CommunicationUserDR="" s user1=""
	.i CommunicationUserDR'="" s user1=$p(^SSU("SSUSR",CommunicationUserDR),"^",2)
	s CommunicationUserDR1=$p(^PMPImprovementDetail(str,MODTChildsub),"^",7)
	i CommunicationUserDR1[","  d
	.s user2=""
	.f ii=1:1:$l(CommunicationUserDR1,",")   d
	..i user2="" s user2=$p(^SSU("SSUSR",$p(CommunicationUserDR1,",",ii)),"^",2)
	..i user2'="" s user1=user1_","_$p(^SSU("SSUSR",$p(CommunicationUserDR1,",",ii)),"^",2)
	e  d
	.i CommunicationUserDR1="" s user2=""
	.i CommunicationUserDR1'="" s user2=$p(^SSU("SSUSR",CommunicationUserDR1),"^",2)
	s CommunicationDate=$p(^PMPImprovementDetail(str,MODTChildsub),"^",3)
	i CommunicationDate'="" s CommunicationDate=$zd(CommunicationDate,3)
	s CommunicationTime=$p(^PMPImprovementDetail(str,MODTChildsub),"^",5)
	i CommunicationTime'="" s CommunicationTime=$zt(CommunicationTime,1)
	//      标志         状态(审核结果)	      用户         内容      项目人员   用户          沟通日期             沟通时间   
	s ret=IPMDFlag1_"^"_IPMDStatusDR1_"^"_TYP1username_"^"_Rearmk_"^"_user1_"^"_user2_"^"_CommunicationDate_"^"_CommunicationTime
	q ret
}

/*
Query MenuBySQL(CRMenu As %String) As %SQLQuery(CONTAINID = 1)
{
	select Caption,ID from SQLUSER.websys.Menu where  Caption %STARTSWITH %ALPHAUP (:CRMenu)
}
*/
/// 
/// 
///  Desc:查询安全组菜单
/// Other: d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","MenuBySQL","","住院护士","")
Query MenuBySQL(CRMenu As %String = "", GroupName = "", MenuGroupName As %String = "") As websys.Query(ROWSPEC = "Caption,id")
{
}

ClassMethod MenuBySQLExecute(ByRef qHandle As %Binary, CRMenu As %String = "", GroupName = "", MenuGroupName = "") As %Status
{
	s MenuName=CRMenu
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s GroupName=%session.Data("LOGON.GROUPDESC")
    s GroupID = ##class(web.SSGroup).GetIdFromCodeOrDescription(GroupName)
    s myGroupMenuSecurity=""
    i GroupID'=""{
	    s myEprGSRowID=$o(^ooGroupSettingsI("GroupDRIndex", GroupID, 0))
		s myEGSObj=##class(epr.GroupSettings).%OpenId(myEprGSRowID, 0)
		s myGroupMenuSecurity = myEGSObj.MenuSecurity	
		d myEGSObj.%Close()   
    }
    s MenuGroupRowid = ##class(websys.Menu).GetIdFromCodeOrDescription(MenuGroupName)
    s Caption="",Name=""
    s id=""
    do{
		d getmenuid
		q:id=""				
		s ^CacheTemp(repid,ind)=$lb(Caption_"("_Name_")",id)
		s ind=ind+1
	}while(id'="")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
 ;找到下一个满足条件的菜单ID
getmenuid	
	do{
		s id = $o(^websys.MenuD(id))
		q:id=""
		s Name = $lg(^websys.MenuD(id),4)
		s Caption = $lg(^websys.MenuD(id),1)
		s SubMenuOf = $lg(^websys.MenuD(id),12)
	    s MenuMatch=0,GroupMatch=0,MenuGroupMatch=0
	    s:MenuName="" MenuMatch=1
		s:(MenuName'="")&&($zcvt(Name,"U")[$zcvt(MenuName,"U")) MenuMatch=1
		s:(MenuName'="")&&($zcvt(Caption,"U")[$zcvt(MenuName,"U")) MenuMatch=1
		s:MenuGroupRowid="" MenuGroupMatch=1
		s:(MenuGroupRowid'="")&&(SubMenuOf=MenuGroupRowid) MenuGroupMatch=1
		s:GroupID="" GroupMatch=1
		s:(GroupID'="")&&($zbitlen(myGroupMenuSecurity)>=id)&&($zbitget(myGroupMenuSecurity,id)=1) GroupMatch=1 
		q:GroupMatch&&MenuMatch&&MenuGroupMatch
	}while(id'="")
	q
}

//s bbb=##class(web.PMP.PMPImprovementList).ListRowid("领药审核")

ClassMethod Menu(input As %String) As %String
{
	s ret="bucunzai"
	q:input="" ret
	s aa=$o(^PMPImprovementListi("Menu",input,""),-1)
	i aa'="" s ret=aa
	q ret
}

//s bbb=##class(web.PMP.PMPImprovementList).ListRowid("领药审核")

ClassMethod ListRowid(input As %String) As %String
{
	s ret="",rowidid=""
	q:input="" ret
	s Rowid="" f  s Rowid=$o(^PMPImprovementListi("Menu",input,Rowid)) q:Rowid=""  d
	.;s id=$p(^PMPImprovementList(Rowid),"^",38)
	.i ret'="" s ret=ret_"^"_Rowid
	.i ret="" s ret=Rowid,rowidid=Rowid
	;i ret'="" s ret=ret_"^"_rowidid
	;i ret="" s ret=rowidid
	q ret
}

Query DepartmentGroup(XQKSLX As %String) As %SQLQuery(CONTAINID = 1)
{
  select DEP_Desc,DEP_RowId from SQLUser.RBC_DepartmentGroup where DEP_Desc %STARTSWITH %ALPHAUP (:XQKSLX)
}

Query SelectPMPImprovementList(Name As %String, Code As %String, CreatUser As %String, State As %String, Menu As %String, CtLoc As %String, Project As %String, Mode As %String, Module As %String) As %Query(ROWSPEC = "TIPMLRowid:%String,TIPMLCode:%String,TIPMLName:%String,TIPMLEmergencyDR:%String,TIPMLModuleDR:%String,TIPMLEngineerDR:%String,TIPMLDevelopUser:%String,TIPMLSituation:%String,TIPMLStatusDR:%String,TIPMLAuditor1:%String,TIPMLAuditor2:%String,TIPMLAuditor3:%String,TIPMLAuditor4:%String,TIPMLAuditor5:%String,TIPMLAuditor:%String,TIPMLCreateTime:%String,TIPMLCreateDate:%String,TIPMLCreateUserDR:%String,TIPMLCreateLocDR:%String,TIPMLAssignEngineerDR:%String,TIPMLTestDate:%String,TIPMLTestTime:%String,TIPMLFinishDate:%String,TIPMLFinishTime:%String,TIPMLMenu:%String,TIPMLCreateTel:%String,TIPMLAdjunctFlag:%String,TIPMLSolution:%String,TIPMLType:%String,TIPMLPredictTime:%String,TIPMLProjectDR:%String,TIPMLDegreeDR:%String,TIPMLStandby1:%String,TIPMLStandby2:%String,TIPMLStandby3:%String,TIPMLStandby4:%String,TIPMLStandby5:%String,TIPMLMode:%String,TIPMLList:%String,TIPMLRevList:%String,TIPMLRevListIMP:%String,TIPMLUpdateType:%String,TIPMLStandtb1:%String,TIPMLStandtb2:%String,TIPMLStandtb3:%String,TIPMLStandtb4:%String,TIPMLStandtb5:%String,TIPMLStandtb6:%String,TIPMLStandtb7:%String")
{
}

//shenbo  2015-1-13

//查询需求阶段，状态

/**
*@	Name    		需求名称
*@	Code    		需求COde
*@	CreatUser		需求创建人
*@	Status			需求状态
*@	Menu			需求菜单
*@	CtLoc			需求创建科室
*@	Project			所属项目
*@	Mode			需求模式
*@	Module			所属模块
**/

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","SelectPMPImprovementList","领药","2014","demo","","门诊","","","","")

ClassMethod SelectPMPImprovementListExecute(ByRef qHandle As %Binary, Name As %String, Code As %String, CreatUser As %String, Status As %String, Menu As %String, CtLoc As %String, Project As %String, Mode As %String, Module As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s userId=%session.Data("LOGON.USERID")
	s xq="" f  s xq=$o(^PMPProjectUseri("SSUSER",userId,xq)) q:xq=""  d
	.s id=$p(^PMPProjectUser(xq),"^",2)
	.i id="67" s xqtype="1"
	;s ^zzpdsz(1)=Name_"^"_Code_"^"_CreatUser_"^"_Status_"^"_Menu_"^"_CtLoc_"^"_Project_"^"_Mode_"^"_Module
	s Rowid="" 
	for  s Rowid=$o(^PMPImprovementList(Rowid))  q:Rowid=""  d
	    .S (IPMLCode,IPMLName,IPMLEmergencyDR,IPMLModuleDR,IPMLEngineerDR,IPMLDevelopUser,IPMLSituation,IPMLStatusDR,IPMLAuditor1,IPMLAuditor2,IPMLAuditor3,IPMLAuditor4,IPMLAuditor5,IPMLAuditor,IPMLCreateTime,IPMLCreateDate,IPMLCreateUserDR,IPMLCreateLocDR,IPMLAssignEngineerDR,IPMLTestDate,IPMLTestTime,IPMLFinishDate,IPMLFinishTime,IPMLMenu,IPMLCreateTel,IPMLAdjunctFlag,IPMLSolution,IPMLType,IPMLPredictTime,IPMLProjectDR,IPMLDegreeDR,IPMLStandby1,IPMLStandby2,IPMLStandby3,IPMLStandby4,IPMLStandby5,IPMLMode,IPMLList,IPMLRevList,IPMLRevListIMP,IPMLUpdateType,IPMLStandtb1,IPMLStandtb2,IPMLStandtb3,IPMLStandtb4,IPMLStandtb5,IPMLStandtb6,IPMLStandtb7)=""
		.set PMPImprList=##class(User.PMPImprovementList).%OpenId(Rowid)
		.set IPMLRowid=Rowid
		.i ($g(xqtype)'="1")&(userId'="1") q:(userId'=PMPImprList.IPMLStandtb3)||(userId'=PMPImprList.IPMLCreateUserDR)			//4355为李春华工号
		.//根据登陆人员id筛选分配自己的需求，备份字段3存人员id
		.set IPMLCode=PMPImprList.IPMLCode									//需求COde 条件
		.q:(Code'="")&(IPMLCode'[Code)
		.set IPMLName=PMPImprList.IPMLName									//需求名称 条件
		.set ^zzpdsz(2)=IPMLName_"^"_Name
		.q:(Name'="")&(IPMLName'[Name)
		.set IPMLEmergencyDR=PMPImprList.IPMLEmergencyDR.DTYDesc				//
		.set IPMLModuleDR=PMPImprList.IPMLModuleDR.MODEDesc					//所属模块 条件
		.q:(Module'="")&(IPMLModuleDR'[Module)
		.set IPMLEngineerDR=PMPImprList.IPMLEngineerDR.PJUUserDR.SSUSRName				
		.set IPMLDevelopUser=PMPImprList.IPMLDevelopUser
		.set IPMLSituation=PMPImprList.IPMLSituation
		.set IPMLStatusDR=PMPImprList.IPMLStatusDR.DTYDesc					//需求状态 条件
		.q:(Status'="")&(IPMLStatusDR'[Status)
		.set IPMLAuditor1=PMPImprList.IPMLAuditor1.SSUSRName
		.set IPMLAuditor2=PMPImprList.IPMLAuditor2.SSUSRName
		.set IPMLAuditor3=PMPImprList.IPMLAuditor3.SSUSRName
		.set IPMLAuditor4=PMPImprList.IPMLAuditor4.SSUSRName
		.set IPMLAuditor5=PMPImprList.IPMLAuditor5.SSUSRName
		.set IPMLAuditor=PMPImprList.IPMLAuditor.SSUSRName
		.set IPMLCreateTime=$zt(PMPImprList.IPMLCreateTime)
		.set IPMLCreateDate=$zd(PMPImprList.IPMLCreateDate,3)
		.set IPMLCreateUserDR=PMPImprList.IPMLCreateUserDR.SSUSRName			//需求创建人 条件
		.q:(CreatUser'="")&(IPMLCreateUserDR'[CreatUser)
		.set IPMLCreateLocDR=PMPImprList.IPMLCreateLocDR.CTLOCDesc			//需求创建科室 条件
		.q:(CtLoc'="")&(IPMLCreateLocDR'[CtLoc)
		.set IPMLAssignEngineerDR=PMPImprList.IPMLAssignEngineerDR.PJUUserDR.SSUSRName
		.I PMPImprList.IPMLTestDate'="" set IPMLTestDate=$zd(PMPImprList.IPMLTestDate,3)
		.I PMPImprList.IPMLTestTime'="" set IPMLTestTime=$zt(PMPImprList.IPMLTestTime)
		.I PMPImprList.IPMLFinishDate'="" set IPMLFinishDate=$zd(PMPImprList.IPMLFinishDate,3)
		.I PMPImprList.IPMLFinishTime'="" set IPMLFinishTime=$zt(PMPImprList.IPMLFinishTime)
		.set IPMLMenu=PMPImprList.IPMLMenu									//需求菜单 条件
		.q:(Menu'="")&(IPMLMenu'[Menu)
		.set IPMLCreateTel=PMPImprList.IPMLCreateTel
		.set IPMLAdjunctFlag=PMPImprList.IPMLAdjunctFlag
		.set IPMLSolution=PMPImprList.IPMLSolution
		.set IPMLType=PMPImprList.IPMLType.DTYDesc
		.set IPMLPredictTime=PMPImprList.IPMLPredictTime
		.set IPMLProjectDR=PMPImprList.IPMLProjectDR.PJTDesc					//所属项目 条件
		.q:(Project'="")&(IPMLProjectDR'[Project)
		.set IPMLDegreeDR=PMPImprList.IPMLDegreeDR.DTYDesc
		.set IPMLStandby1=PMPImprList.IPMLStandby1
		.set IPMLStandby22=PMPImprList.IPMLStandby2 ;)),"^",2)
		.if IPMLStandby22'=""  set IPMLStandby2=$p(^SSU("SSUSR",IPMLStandby22),"^",2)
		.set IPMLStandby3=PMPImprList.IPMLStandby3
		.set IPMLStandby4=PMPImprList.IPMLStandby4
		.set IPMLStandby5=PMPImprList.IPMLStandby5
		.set IPMLMode=PMPImprList.IPMLMode
		.set IPMLList=PMPImprList.IPMLList.IPMLName
		.set IPMLRevList=PMPImprList.IPMLRevList
		.set IPMLRevListIMP=PMPImprList.IPMLRevListIMP
		.set IPMLUpdateType=PMPImprList.IPMLUpdateType
		.set IPMLStandtb1=PMPImprList.IPMLStandtb1
		.set IPMLStandtb2=PMPImprList.IPMLStandtb2
		.set IPMLStandtb3=PMPImprList.IPMLStandtb3
		.set IPMLStandtb4=PMPImprList.IPMLStandtb4
		.set IPMLStandtb5=PMPImprList.IPMLStandtb5
		.set IPMLStandtb6=PMPImprList.IPMLStandtb6
		.set IPMLStandtb7=PMPImprList.IPMLStandtb7

		
		.d OutputRow2
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(IPMLRowid,IPMLCode,IPMLName,IPMLEmergencyDR,IPMLModuleDR,IPMLEngineerDR,IPMLDevelopUser,IPMLSituation,IPMLStatusDR,IPMLAuditor1,IPMLAuditor2,IPMLAuditor3,IPMLAuditor4,IPMLAuditor5,IPMLAuditor,IPMLCreateTime,IPMLCreateDate,IPMLCreateUserDR,IPMLCreateLocDR,IPMLAssignEngineerDR,$G(IPMLTestDate),$G(IPMLTestTime),$G(IPMLFinishDate),$G(IPMLFinishTime),IPMLMenu,IPMLCreateTel,IPMLAdjunctFlag,IPMLSolution,IPMLType,$G(IPMLPredictTime),IPMLProjectDR,IPMLDegreeDR,IPMLStandby1,IPMLStandby2,IPMLStandby3,IPMLStandby4,IPMLStandby5,IPMLMode,IPMLList,IPMLRevList,IPMLRevListIMP,IPMLUpdateType,IPMLStandtb1,IPMLStandtb2,IPMLStandtb3,IPMLStandtb4,IPMLStandtb5,IPMLStandtb6,IPMLStandtb7)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
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

Query TYPRowidValueQuery(str As %String) As %Query(ROWSPEC = "TYP1username:%String,TYP1MENU:%String,TYP1date:%String,TYP1ID:%String,TIPMDRemark:%String")
{
}

//shenbo  2015-1-14

//根据条件查询需求处理列表

//d ##class(%ResultSet).RunQuery("web.PMP.PMPImprovementList","TYPRowidValueQuery","48^49^50^51")

ClassMethod TYPRowidValueQueryExecute(ByRef qHandle As %Binary, str As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s (TYP1username,TYP1MENU,TYP1date,TYP1ID,IPMDStatusDR1,IPMDFlag1)=""
	i str="" d
	.d OutputRow1
	e  d
	.f lenth=1:1:$l(str,"^")  d
	..i $l(str,"^")>1  d
	...s strstr=$p(str,"^",lenth)
	..e  s strstr=str
	..S MODTChildsub="" f  s MODTChildsub=$O(^PMPImprovementDetail(strstr,MODTChildsub)) Q:MODTChildsub=""  D
	...q:MODTChildsub="E"
	...s IPMDFlag=$p(^PMPImprovementDetail(strstr,MODTChildsub),"^",8)
	...i IPMDFlag'="" s IPMDFlag1=$p(^PMPDictionary(IPMDFlag),"^",2)
	...s IPMDStatusDR=$p(^PMPImprovementDetail(strstr,MODTChildsub),"^",10)
	...i IPMDStatusDR'="" s IPMDStatusDR1=$p(^PMPDictionary(IPMDStatusDR),"^",2)
	...s TYP1MENU=IPMDFlag1_" "_IPMDStatusDR1
	...s IPMDUpdateUserDR=$p(^PMPImprovementDetail(strstr,MODTChildsub),"^",13)
	...i IPMDUpdateUserDR'="" s TYP1username=$p(^SSU("SSUSR",IPMDUpdateUserDR),"^",2)
	...i IPMDUpdateUserDR="" s TYP1username=""
	...S IPMDUpdateDate=$p(^PMPImprovementDetail(strstr,MODTChildsub),"^",11)
	...s IPMDUpdateDate=$zd(IPMDUpdateDate,3)
	...S IPMDUpdateTime=$p(^PMPImprovementDetail(strstr,MODTChildsub),"^",12)
	...s IPMDUpdateTime=$zt(IPMDUpdateTime,1)
	...s IPMDRemark=$p(^PMPImprovementDetail(strstr,MODTChildsub),"^",9)
	...s TYP1date=IPMDUpdateDate_" "_IPMDUpdateTime
	...s TYP1ID=strstr_"^"_MODTChildsub
	...i $l(str,"^")>1 s TYP1username="第"_""_lenth_""_"次："_TYP1username
	...d OutputRow1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1  
	set Data=$lb(TYP1username,TYP1MENU,TYP1date,TYP1ID,IPMDRemark)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod TYPRowidValueQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = TYPRowidValueQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod TYPRowidValueQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = TYPRowidValueQueryExecute ]
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

//shenbo 2015-1-26

Query DepartAuditBySQL(User As %String) As %SQLQuery(CONTAINID = 1)
{
	select SSUSR_Name,SSUSR_RowId,SSUSR_Initials from SQLUSER.SS_User,SQLUSER.PMP_DepartAudit where  SSUSR_Name %STARTSWITH %ALPHAUP (:User) or SSUSR_Initials %STARTSWITH %ALPHAUP(:User) and Audit_UserDr=SSUSR_RowId and Audit_Spare="F"
}

//s bbb=##class(web.PMP.PMPImprovementList).Clearkgt("C:\Documents and Settings\Administrator\桌面\新建文件夹\DTHealth-大科核算.xls")

ClassMethod Clearkg(Input As %String) As %String
{
	s ret=""
	q:Input="" ret
	i Input["C:\Documents and Settings\Administrator\桌面"  d
	.s ret="%ALLUSERSPROFILE%\桌面"_$p(Input,"桌面",2)
	q ret
}

//zzp 20150413  查询是否后补标志

//w ##class(web.PMP.PMPImprovementList).Fincheak("104")

ClassMethod Fincheak(rowid As %String)
{
	s ret=""
	q:rowid="" ret
	s ret=$p(^PMPImprovementList(rowid),"^",32)
	i ret="Y" s ret="true"
    i ret="true" s ret="true"
	q ret
}

Storage Default
{
<Data name="PMPImprovementListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.PMP.PMPImprovementListD</DataLocation>
<DefaultData>PMPImprovementListDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.PMP.PMPImprovementListD</IdLocation>
<IndexLocation>^web.PMP.PMPImprovementListI</IndexLocation>
<StreamLocation>^web.PMP.PMPImprovementListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
