/// 名称: DHCMed.NINFService.Rep.AimNICUSurveryAdm
/// 描述: ICU患者日志就诊号字符串Service
/// 编写者：jiangpengpeng
/// 编写日期: 2014-03-01
Class DHCMed.NINFService.Rep.AimNICUSurveryAdm Extends (%RegisteredObject, DHCMed.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     jiangpengpeng
/// CreatDate：   2014-2-28
/// Description:  查询数据字典
/// Table：       DHCMed.NINF.Rep.AimNICUSurveryAdm
/// Input：       
/// D ##class(%ResultSet).RunQuery("DHCMed.NINFService.Rep.AimNICUSurveryAdm","QryNICUAdmStr","2013-07-01",25)
Query QryNICUAdmStr(aDate As %String, aLocID As %String) As %Query(ROWSPEC = "RowID:%String,LocID:%String,LocDesc:%String,AISDate:%String,IsNew:%String,PatientID:%String,Paadm:%String,PatientName:%String,Sex:%String,Age:%String")
{
}

ClassMethod QryNICUAdmStrExecute(ByRef qHandle As %Binary, aDate As %String, aLocID As %String) As %Status
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
	Set xRowID=$o(^DHCMed.NINFi("Aim","NICUSAdm","IndexLocDate",aLocID,aDate,0))
	Set objLog=##class(DHCMed.NINF.Rep.AimNICUSurveryAdm).GetObjById(xRowID)
	If $IsObject(objLog)
	{
		Set ANISItem1=objLog.ANISItem1
		Set ANISItem2=objLog.ANISItem2
		Set ANISItem3=objLog.ANISItem3
		Set ANISItem4=objLog.ANISItem4
		Set ANISItem5=objLog.ANISItem5
		Set ANISItem6=objLog.ANISItem6
		Set ANISItem7=objLog.ANISItem7
		Set ANISItem8=objLog.ANISItem8
		Set ANISItem9=objLog.ANISItem9
		Set ANISItem10=objLog.ANISItem10
		Set ANISItem11=objLog.ANISItem11
		Set ANISItem12=objLog.ANISItem12
		Set ANISItem13=objLog.ANISItem13
		Set ANISItem14=objLog.ANISItem14
		Set ANISItem15=objLog.ANISItem15
		Set ANISItem16=objLog.ANISItem16
		Set ANISItem1A=objLog.ANISItem1A
		Set ANISItem2A=objLog.ANISItem2A
		Set ANISItem3A=objLog.ANISItem3A
		Set ANISItem4A=objLog.ANISItem4A
		Set ANISItem5A=objLog.ANISItem5A
		Set ANISItem6A=objLog.ANISItem6A
		Set ANISItem7A=objLog.ANISItem7A
		Set ANISItem8A=objLog.ANISItem8A
		Set ANISItem9A=objLog.ANISItem9A
		Set ANISItem10A=objLog.ANISItem10A
		Set ANISItem11A=objLog.ANISItem11A
		Set ANISItem12A=objLog.ANISItem12A
		Set ANISItem13A=objLog.ANISItem13A
		Set ANISItem14A=objLog.ANISItem14A
		Set ANISItem15A=objLog.ANISItem15A
		Set ANISItem16A=objLog.ANISItem16A
		
		For i=1:1:$l(ANISItem1,",")	//新住进患者
		{
			set xPaadm=$p(ANISItem1,",",i)
			Continue:xPaadm=""
			
			Set (IsNew,PatientID,PatientName,Sex,Age,Type)=""
			Set objAdm=##Class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm) 
			Set PatientID=objAdm.PatientID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient) 
			Set PatientName=objPatient.PatientName
			Set Sex=objPatient.Sex
			//Set Age=objPatient.Age
			Set:objPatient.Age>0 Age=objPatient.Age_"岁"
			Set:objPatient.AgeMonth>0 Age=objPatient.AgeMonth_"月"
			Set:objPatient.AgeDay>0 Age=objPatient.AgeDay_"天"
			Set BornWeight="(BW<=1000g)"
			Set IsNew="新住进患者"_BornWeight
			Do BuildData()
			
		}
	
		For i=1:1:$l(ANISItem2,",")     //住在患者
		{
			set xPaadm=$p(ANISItem2,",",i)
			Continue:xPaadm=""
		
			Set (IsNew,PatientID,PatientName,Sex,Age,Type)=""
			Set objAdm=##Class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm) 
			Set PatientID=objAdm.PatientID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient) 
			Set PatientName=objPatient.PatientName
			Set Sex=objPatient.Sex
			//Set Age=objPatient.Age
			Set:objPatient.Age>0 Age=objPatient.Age_"岁"
			Set:objPatient.AgeMonth>0 Age=objPatient.AgeMonth_"月"
			Set:objPatient.AgeDay>0 Age=objPatient.AgeDay_"天"
			Set BornWeight="(BW<=1000g)"
			Set IsNew="住在患者"_BornWeight
			Do BuildData()
		}
		
		For i=1:1:$l(ANISItem5,",")	//新住进患者
		{
			set xPaadm=$p(ANISItem5,",",i)
			Continue:xPaadm=""
			
			Set (IsNew,PatientID,PatientName,Sex,Age,Type)=""
			Set objAdm=##Class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm) 
			Set PatientID=objAdm.PatientID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient) 
			Set PatientName=objPatient.PatientName
			Set Sex=objPatient.Sex
			//Set Age=objPatient.Age
			Set:objPatient.Age>0 Age=objPatient.Age_"岁"
			Set:objPatient.AgeMonth>0 Age=objPatient.AgeMonth_"月"
			Set:objPatient.AgeDay>0 Age=objPatient.AgeDay_"天"
			Set BornWeight="(BW1001g~1500g)"
			Set IsNew="新住进患者"_BornWeight
			Do BuildData()
			
		}
	
		For i=1:1:$l(ANISItem6,",")     //住在患者
		{
			set xPaadm=$p(ANISItem6,",",i)
			Continue:xPaadm=""
		
			Set (IsNew,PatientID,PatientName,Sex,Age,Type)=""
			Set objAdm=##Class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm) 
			Set PatientID=objAdm.PatientID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient) 
			Set PatientName=objPatient.PatientName
			Set Sex=objPatient.Sex
			//Set Age=objPatient.Age
			Set:objPatient.Age>0 Age=objPatient.Age_"岁"
			Set:objPatient.AgeMonth>0 Age=objPatient.AgeMonth_"月"
			Set:objPatient.AgeDay>0 Age=objPatient.AgeDay_"天"
			Set BornWeight="(BW1001g~1500g)"
			Set IsNew="住在患者"_BornWeight
			Do BuildData()
		}
		
		For i=1:1:$l(ANISItem9,",")	//新住进患者
		{
			set xPaadm=$p(ANISItem9,",",i)
			Continue:xPaadm=""
			
			Set (IsNew,PatientID,PatientName,Sex,Age,Type)=""
			Set objAdm=##Class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm) 
			Set PatientID=objAdm.PatientID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient) 
			Set PatientName=objPatient.PatientName
			Set Sex=objPatient.Sex
			//Set Age=objPatient.Age
			Set:objPatient.Age>0 Age=objPatient.Age_"岁"
			Set:objPatient.AgeMonth>0 Age=objPatient.AgeMonth_"月"
			Set:objPatient.AgeDay>0 Age=objPatient.AgeDay_"天"
			Set BornWeight="(BW1501g~2500g)"
			Set IsNew="新住进患者"_BornWeight
			Do BuildData()
			
		}
	
		For i=1:1:$l(ANISItem10,",")     //住在患者
		{
			set xPaadm=$p(ANISItem10,",",i)
			Continue:xPaadm=""
		
			Set (IsNew,PatientID,PatientName,Sex,Age,Type)=""
			Set objAdm=##Class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm) 
			Set PatientID=objAdm.PatientID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient) 
			Set PatientName=objPatient.PatientName
			Set Sex=objPatient.Sex
			//Set Age=objPatient.Age
			Set:objPatient.Age>0 Age=objPatient.Age_"岁"
			Set:objPatient.AgeMonth>0 Age=objPatient.AgeMonth_"月"
			Set:objPatient.AgeDay>0 Age=objPatient.AgeDay_"天"
			Set BornWeight="(BW1501g~2500g)"
			Set IsNew="住在患者"_BornWeight
			Do BuildData()
		}
		
		For i=1:1:$l(ANISItem13,",")	//新住进患者
		{
			set xPaadm=$p(ANISItem13,",",i)
			Continue:xPaadm=""
			
			Set (IsNew,PatientID,PatientName,Sex,Age,Type)=""
			Set objAdm=##Class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm) 
			Set PatientID=objAdm.PatientID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient) 
			Set PatientName=objPatient.PatientName
			Set Sex=objPatient.Sex
			//Set Age=objPatient.Age
			Set:objPatient.Age>0 Age=objPatient.Age_"岁"
			Set:objPatient.AgeMonth>0 Age=objPatient.AgeMonth_"月"
			Set:objPatient.AgeDay>0 Age=objPatient.AgeDay_"天"
			Set BornWeight="(BW>2500g)"
			Set IsNew="新住进患者"_BornWeight
			Do BuildData()
			
		}
	
		For i=1:1:$l(ANISItem14,",")     //住在患者
		{
			set xPaadm=$p(ANISItem14,",",i)
			Continue:xPaadm=""
		
			Set (IsNew,PatientID,PatientName,Sex,Age,Type)=""
			Set objAdm=##Class(DHCMed.Base.PatientAdm).GetObjById(xPaadm)
			Continue:'$IsObject(objAdm) 
			Set PatientID=objAdm.PatientID
			Set objPatient=##class(DHCMed.Base.Patient).GetObjById(PatientID)
			Continue:'$IsObject(objPatient) 
			Set PatientName=objPatient.PatientName
			Set Sex=objPatient.Sex
			//Set Age=objPatient.Age
			Set:objPatient.Age>0 Age=objPatient.Age_"岁"
			Set:objPatient.AgeMonth>0 Age=objPatient.AgeMonth_"月"
			Set:objPatient.AgeDay>0 Age=objPatient.AgeDay_"天"
			Set BornWeight="(BW>2500g)"
			Set IsNew="住在患者"_BornWeight
			Do BuildData()
		}
	}
	Quit $$$OK
	
BuildData()
	Set (x,y,z)=-1
	Set x=$Find(ANISItem3,xPaadm)
	Set y=$Find(ANISItem4,xPaadm)
	Set:x>0 IsNew="使用呼吸机"_BornWeight
	Set:y>0 IsNew="脐\中心静脉插管"_BornWeight
	Set Data=$lb(ind,LocID,LocDesc,$zd(aDate,3))
	Set Data=Data_$lb(IsNew,PatientID,xPaadm,PatientName,Sex,Age)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod QryNICUAdmStrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNICUAdmStrExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNICUAdmStrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNICUAdmStrExecute ]
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
