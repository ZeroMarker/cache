/// 名称: DHCMed.NINFService.Rep.AimICUSurveryAdm
/// 描述: ICU患者日志就诊号字符串Service
/// 编写者：jiangpengpeng
/// 编写日期: 2014-2-28
Class DHCMed.NINFService.Rep.AimICUSurveryAdm Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2014-2-28
/// Description:  查询数据字典
/// Table：       DHCMed.NINF.Rep.AimICUSurveryAdm
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimICUSurveryAdm","QryICUAdmStr","2014-03-14",289)
Query QryICUAdmStr(aDate As %String, aLocID As %String) As %Query(ROWSPEC = "RowID:%String,LocID:%String,LocDesc:%String,AISDate:%String,PatType:%String,PapmiNo:%String,Paadm:%String,PatientName:%String,Sex:%String,Age:%String")
{
}

ClassMethod QryICUAdmStrExecute(ByRef qHandle As %Binary, aDate As %String, aLocID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	Quit:(aDate="")||(aLocID="") $$$OK
 	
 	Set LocID=aLocID
	Set LocDesc=$p($g(^CTLOC(LocID)),"^",2)
	Quit:LocDesc="" $$$OK
	Set:$p(LocDesc,"-",2)'="" LocDesc=$p(LocDesc,"-",2)
 	Set aDate=$zdh(aDate,3)
	Set xRowID=$o(^DHCMed.NINFi("Aim","ICUSAdm","IndexLocDate",aLocID,aDate,0))
	Set objLog=##class(DHCMed.NINF.Rep.AimICUSurveryAdm).GetObjById(xRowID)
	If $IsObject(objLog)
	{
		Set AISItem1=objLog.AISItem1
		Set AISItem2=objLog.AISItem2
		Set AISItem3=objLog.AISItem3
		Set AISItem4=objLog.AISItem4
		Set AISItem5=objLog.AISItem5
		Set AISItem6=objLog.AISItem6
		Set AISItem7=objLog.AISItem7
		Set AISItem8=objLog.AISItem8
		Set AISItem9=objLog.AISItem9
		Set AISItem10=objLog.AISItem10
		Set AISItem11=objLog.AISItem11
		Set AISItem12=objLog.AISItem12
		Set AISItem13=objLog.AISItem13
		Set AISItem14=objLog.AISItem14
		Set AISItem15=objLog.AISItem15
		Set AISItem16=objLog.AISItem16
		Set AISItem17=objLog.AISItem17
		Set AISItem18=objLog.AISItem18
		Set AISItem19=objLog.AISItem19
		Set AISItem20=objLog.AISItem20
	
		For i=1:1:$l(AISItem1,",")	//新住进患者
		{
			set xPaadm=$p(AISItem1,",",i)
			Continue:xPaadm=""
			
			Set (PatType,PatientID,PatientName,Sex,Age,Type)=""
			Set objAdm=##Class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm)
			Set PatientID=objAdm.PatientID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient) 
			Set PatientName=objPatient.PatientName
			Set PapmiNo=objPatient.PapmiNo
			Set Sex=objPatient.Sex
			//Set Age=objPatient.Age
			Set:objPatient.Age>0 Age=objPatient.Age_"岁"
			Set:objPatient.AgeMonth>0 Age=objPatient.AgeMonth_"月"
			Set:objPatient.AgeDay>0 Age=objPatient.AgeDay_"天"
			Do BuildData
			
		}
	
		For i=1:1:$l(AISItem2,",")     //住在患者
		{
			set xPaadm=$p(AISItem2,",",i)
			Continue:xPaadm=""
			
			Set (PatType,PatientID,PatientName,Sex,Age,Type)=""
			Set objAdm=##Class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm) 
			Set PatientID=objAdm.PatientID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient) 
			Set PatientName=objPatient.PatientName
			Set PapmiNo=objPatient.PapmiNo
			Set Sex=objPatient.Sex
			//Set Age=objPatient.Age
			Set:objPatient.Age>0 Age=objPatient.Age_"岁"
			Set:objPatient.AgeMonth>0 Age=objPatient.AgeMonth_"月"
			Set:objPatient.AgeDay>0 Age=objPatient.AgeDay_"天"
			Do BuildData
		}
	}
	Quit $$$OK
	
BuildData
	Set (NewInHosp,InHosp,UC,PICC,VAP)=-1
	Set TypeValue="新住进患者"_"^"_"住在患者"_"^"_"留置导尿管"_"^"_"中心静脉插管"_"^"_"使用呼吸机"
	Set NewInHosp=$Find(AISItem1,xPaadm)
	Set InHosp=$Find(AISItem2,xPaadm)
	Set UC=$Find(AISItem3,xPaadm)
	Set PICC=$Find(AISItem4,xPaadm)
	Set VAP=$Find(AISItem5,xPaadm)
	set TypeList=NewInHosp_"^"_InHosp_"^"_UC_"^"_PICC_"^"_VAP
	For Tpyeind=1:1:5 {
		If ($p(TypeList,"^",Tpyeind)>0) {
			Set PatType=$p(TypeValue,"^",Tpyeind)
			Set Data=$lb(ind,LocID,LocDesc,$zd(aDate,3))
			Set Data=Data_$lb(PatType,PapmiNo,xPaadm,PatientName,Sex,Age)
			Set ^CacheTemp(repid,ind)=Data
			Set ind=ind+1
		}
	}
	Quit
}

ClassMethod QryICUAdmStrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryICUAdmStrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryICUAdmStrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryICUAdmStrExecute ]
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

}
