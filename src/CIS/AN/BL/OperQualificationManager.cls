Class CIS.AN.BL.OperQualificationManager Extends %RegisteredObject
{

/// Creator: 唐潇
/// CreatDate: 2020-02-26
/// Description: 查询医护人员
/// Table：
/// Input：
/// Return：ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperQualificationManager","FindSurgeonDatas","6","","","")
Query FindSurgeonDatas(deptID As %String = "", workNo As %String = "", surgeonDesc As %String = "", operID As %String = "") As %Query(ROWSPEC = "RowId,Dept,DeptDesc,CareProvider,CareProviderDesc,WorkNo") [ SqlProc ]
{
}

ClassMethod FindSurgeonDatasExecute(ByRef qHandle As %Binary, deptID As %String, workNo As %String, surgeonDesc As %String = "", operID As %String = "") As %Status
{
	Set ^tempzmy(1)=deptID_"^"_operID
	Set repid=$INCREMENT(^CacheTemp)
	If $GET(ind)="" Set ind=1
	Set deptID=$GET(deptID)
	Set workNo=$GET(workNo)
	Set surgeonDesc=$GET(surgeonDesc)
	Set operID=$GET(operID)
	If (workNo'="")
	{
		Set UserID=0
		Set UserID=$ORDER(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(workNo),UserID))
		;b ;001
		If UserID'="" Do
		.Set CareProvider=$PIECE(^SSU("SSUSR",UserID),"^",14)
		.;b ;002
		.Quit:CareProvider=""
		.Set CareProviderDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",CareProvider)
		.Set dept=0
		.For  Set dept=$ORDER(^RB("RES",0,"CTPCP",CareProvider,dept)) Quit:dept=""  Do
		..Set resourceID=0
		..For  Set resourceID=$ORDER(^RB("RES",0,"CTPCP",CareProvider,dept,resourceID)) Quit:resourceID=""  Do
		...Set deptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",dept)
		...Set ActiveDate=$PIECE(^RB("RES",resourceID),"^",22)
		...Set ExpireDate=$PIECE(^RB("RES",resourceID),"^",23)
		...Set Active=$PIECE(^RB("RES",resourceID),"^",18)
		...Quit:(ActiveDate'="")&&(ActiveDate>+$HOROLOG)
		...Quit:(ExpireDate'="")&&(ExpireDate<(+$HOROLOG+1))
		...Set ^CacheTemp(repid,ind)=$LISTBUILD(resourceID,dept,deptDesc,CareProvider,CareProviderDesc,workNo)
		...Set qHandle=$LISTBUILD(0,repid,0)
		...Set ind=ind+1
		Set qHandle=$LISTBUILD(0,repid,0)
		Quit $$$OK
	}
	If (surgeonDesc'="")
	{
		Set resourceID=0
		For  Set resourceID=$ORDER(^RB("RES",resourceID)) Quit:resourceID=""  Do
		.Set dept=$PIECE(^RB("RES",resourceID),"^",1)
		.Set deptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",dept)
		.Set CareProvider=$PIECE(^RB("RES",resourceID),"^",2)
		.Set CareProviderDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",CareProvider)
		.Set UserID=$ORDER(^SSU("SSUSR",0,"CTPCP",CareProvider,0))
		.Set WorkNo=$PIECE(^SSU("SSUSR",UserID),"^",1)
		.Set ^CacheTemp(repid,ind)=$LISTBUILD(resourceID,dept,deptDesc,CareProvider,CareProviderDesc,WorkNo)
		.Set qHandle=$LISTBUILD(0,repid,0)
		.Set ind=ind+1
		Set qHandle=$LISTBUILD(0,repid,0)
		Quit $$$OK	
	}
	If ((operID'="")&&##class(User.ORCOperation).%ExistsId(operID))
	{
		Set surgeonOperationID=0
		For  Set surgeonOperationID=$ORDER(^CF.AN.SurgeonOperationI("IOperation"," "_operID,surgeonOperationID)) Quit:surgeonOperationID=""  Do
		.Set CareProvider=$LISTGET(^CF.AN.SurgeonOperationD(surgeonOperationID),1)
		.Set ExpireDate=$LISTGET(^CF.AN.SurgeonOperationD(surgeonOperationID),4)
		.Quit:((ExpireDate'="")&&(ExpireDate<(+$HOROLOG+1)))
		.Set UserID=$ORDER(^SSU("SSUSR",0,"CTPCP",CareProvider,0))
		.Set WorkNo=$PIECE(^SSU("SSUSR",UserID),"^",1)
		.Set CareProviderDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",CareProvider)
		.Set dept=0
		.For  Set dept=$ORDER(^RB("RES",0,"CTPCP",CareProvider,dept)) Quit:dept=""  Do
		..Set resourceID=0
		..For  Set resourceID=$ORDER(^RB("RES",0,"CTPCP",CareProvider,dept,resourceID)) Quit:resourceID=""  Do
		...Set deptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",dept)
		...Set ActiveDate=$PIECE(^RB("RES",resourceID),"^",22)
		...Set ExpireDate=$PIECE(^RB("RES",resourceID),"^",23)
		...Set Active=$PIECE(^RB("RES",resourceID),"^",18)
		...Quit:(ActiveDate'="")&&(ActiveDate>+$HOROLOG)
		...Quit:(ExpireDate'="")&&(ExpireDate<(+$HOROLOG+1))
		...Set ^CacheTemp(repid,ind)=$LISTBUILD(resourceID,dept,deptDesc,CareProvider,CareProviderDesc,WorkNo)
		...Set qHandle=$LISTBUILD(0,repid,0)
		...Set ind=ind+1
		Set qHandle=$LISTBUILD(0,repid,0)
		Quit $$$OK	
	}
	If ((deptID="")||('##class(User.CTLoc).%ExistsId(deptID)))
	{
		Set qHandle=$LISTBUILD(0,repid,0)
		Quit $$$OK	
	}
	Set resourceID=0
	For  Set resourceID=$ORDER(^RB("RES",0,"CTLOC",deptID,resourceID)) Quit:resourceID=""  Do
	.Set dept=$PIECE(^RB("RES",resourceID),"^",1)
	.Set deptDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTLoc","CTLOCDesc",dept)
	.Set CareProvider=$PIECE(^RB("RES",resourceID),"^",2)
	.Set CareProviderDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",CareProvider)
	.Set UserID=$ORDER(^SSU("SSUSR",0,"CTPCP",CareProvider,0))
	.Quit:UserID=""
	.Set WorkNo=$PIECE($GET(^SSU("SSUSR",UserID)),"^",1)
	.Set ^CacheTemp(repid,ind)=$LISTBUILD(resourceID,dept,deptDesc,CareProvider,CareProviderDesc,WorkNo)
	.Set qHandle=$LISTBUILD(0,repid,0)
	.Set ind=ind+1
	
	Set qHandle=$LISTBUILD(0,repid,0)
	Quit $$$OK
}

ClassMethod FindSurgeonDatasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$ORDER(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	Set qHandle=$LISTBUILD(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindSurgeonDatasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(CIS.AN.BL.OperQualificationManager).SaveSurgeonOperation("YS01","2340",95)
ClassMethod SaveSurgeonOperation(Surgeon, Operation, SurgeonDept As %String = "") As %String
{
	
	Quit:Surgeon="" "E^Surgeon is null"
	Quit:Operation="" "E^Operation is null"
	Set $ZTRAP="Error" 
	Set rowId="",ifhave=0
	For  Set rowId=$ORDER(^CF.AN.SurgeonOperationI("ISurgeonOperation"," "_Surgeon," "_Operation,rowId))  Quit:rowId=""  Do
	.Set deptId=$LISTGET(^CF.AN.SurgeonOperationD(rowId),5)
	.If deptId=SurgeonDept Set ifhave=1
	Quit:ifhave=1 "S^"
	Set obj=##class(CF.AN.SurgeonOperation).%New()
	Set obj.Surgeon=Surgeon
	Set obj.Operation=Operation
	Set:SurgeonDept'="" obj.SurgeonDept=SurgeonDept
	Set obj.ActiveDate=+$HOROLOG
	Set sc=obj.%Save()
	Quit:($SYSTEM.Status.IsError(sc)) "E^"_$SYSTEM.Status.GetErrorText(sc)
	Quit "S^"_obj.%Id()
Error
	Quit "E^"_$ZERROR
}

/// Surgeon_$c(1)_Operation_$c(1)_SurgeonDept_$c(2)
ClassMethod SaveSurgeonOperations(saveStr As %String) As %String
{
	Set ^tmpXX("ss")=saveStr
	Set strLen=$LENGTH(saveStr,$CHAR(2))
	Set error=""
	Tstart
	For i=1:1:strLen Quit:error'=""  Do
	.Set paraStr=$PIECE(saveStr,$CHAR(2),i)
	.Quit:paraStr=""
	.Set curSurgeon=$PIECE(paraStr,$CHAR(1),1)
	.Set curOperation=$PIECE(paraStr,$CHAR(1),2)
	.Set curSurgeonDept=$PIECE(paraStr,$CHAR(1),3)
	.Set ret=..SaveSurgeonOperation(curSurgeon,curOperation,curSurgeonDept)
	.Set:$PIECE(ret,"^")="E" error=ret
	If error'="" Trollback  Quit error
	Tcommit
	Quit "S^保存成功"
}

/// w ##class(CIS.AN.BL.OperQualificationManager).SaveDeptOperation("117","2340")
ClassMethod SaveDeptOperation(Dept, Operation) As %String
{
	Quit:Dept="" "E^Dept is null"
	Quit:Operation="" "E^Operation is null"
	Set $ZTRAP="SaveDeptOperationError" 
	Set rowId=""
	If $DATA(^CF.AN.DeptOperationI("IDeptOperation"," "_Dept," "_Operation)) Do
	.Set rowId=$ORDER(^CF.AN.DeptOperationI("IDeptOperation"," "_Dept," "_Operation,0))
	Quit:rowId'="" "S^"
	Set obj=##class(CF.AN.DeptOperation).%New()
	Set obj.DeptID=Dept
	Set obj.Operation=Operation
	Set obj.ActiveDate=+$HOROLOG
	Set sc=obj.%Save()
	Quit:($SYSTEM.Status.IsError(sc)) "E^"_$SYSTEM.Status.GetErrorText(sc)
	Quit "S^"_obj.%Id()
SaveDeptOperationError
	Quit "E^"_$ZERROR
}

/// Dept_$c(1)_Operation_$c(2)
ClassMethod SaveDeptOperations(saveStr As %String) As %String
{
	Set strLen=$LENGTH(saveStr,$CHAR(2))
	Set error=""
	Tstart
	For i=1:1:strLen Quit:error'=""  Do
	.Set paraStr=$PIECE(saveStr,$CHAR(2),i)
	.Quit:paraStr=""
	.Set curDept=$PIECE(paraStr,$CHAR(1),1)
	.Set curOperation=$PIECE(paraStr,$CHAR(1),2)
	.Set ret=..SaveDeptOperation(curDept,curOperation)
	.Set:$PIECE(ret,"^")="E" error=ret
	If error'="" Trollback  Quit error
	Tcommit
	Quit "S^保存成功"
}

ClassMethod ClearSurgeonOperation(Surgeon As %String) As %String
{
	Set rowId=0
	Tstart
	Set $ZTRAP="Error"
	For  Set rowId=$ORDER(^CF.AN.SurgeonOperationI("ISurgeon"," "_Surgeon,rowId)) Quit:rowId=""  Do
	.Do ##class(CF.AN.SurgeonOperation).%DeleteId(rowId)
	Tcommit
	Quit "S^操作成功"
Error
	Trollback
	Quit "E^"_$ZERROR
}

ClassMethod DeleteSurgeonOperation(idStr As %String) As %String
{
	Set len=$LENGTH(idStr,$CHAR(1))
	Tstart
	Set $ZTRAP="Error"
	For i=1:1:len Do
	.Set rowId=$PIECE(idStr,$CHAR(1),i)
	.Quit:rowId=""
	.Do ##class(CF.AN.SurgeonOperation).%DeleteId(rowId)
	Tcommit
	Quit "S^操作成功"
Error
	Trollback
	Quit "E^"_$ZERROR
}

ClassMethod DeleteDeptOperation(idStr As %String) As %String
{
	Set len=$LENGTH(idStr,$CHAR(1))
	Tstart
	Set $ZTRAP="Error"
	For i=1:1:len Do
	.Set rowId=$PIECE(idStr,$CHAR(1),i)
	.Quit:rowId=""
	.Do ##class(CF.AN.DeptOperation).%DeleteId(rowId)
	Tcommit
	Quit "S^操作成功"
Error
	Trollback
	Quit "E^"_$ZERROR
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperQualificationManager","FindSurgeonOperations","","","周")
Query FindSurgeonOperations(careprovID As %String = "", deptID As %String = "", operDesc As %String = "", operClass As %String = "") As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   Surgeon,
	   CIS_AN_COM.String_GetDescByID("User.CTCareProv","CTPCPDesc",Surgeon) As SurgeonDesc,
	   Operation,
	   CIS_AN_COM.String_GetDescBySQL('SQLUser.ORC_Operation','OPER_DefaultCategory_DR',Operation) As OperClass,
	   CIS_AN_COM.String_GetDescBySQL('SQLUser.ORC_Operation','OPER_DefaultCategory_DR->CATEG_Desc',Operation) As OperClassDesc,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperation','OPERDesc',Operation) As OperationDesc,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperation','OPERICD10',Operation) As ICD10Desc,
	   %ODBCOUT(ActiveDate) As ActiveDate,
	   %ODBCOUT(ExpireDate) As ExpireDate,
	   SurgeonDept,
	   CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",SurgeonDept) As SurgeonDeptDesc
	   from CF_AN.SurgeonOperation
	   where ((SurgeonDept=:deptID) or (:deptID is null))
	   and ((Surgeon=:careprovID) or (:careprovID is null))
	   and ((CIS_AN_COM.String_GetDescByID('User.ORCOperation','OPERDesc',Operation) like "%"_:operDesc_"%") or(:operDesc is null))
	   and ((CIS_AN_COM.String_GetDescBySQL('SQLUser.ORC_Operation','OPER_DefaultCategory_DR',Operation)=:operClass) or (:operClass is null))
	   and (ActiveDate<=+$h and (ExpireDate>+$h or ExpireDate is null))
}

Query FindDeptOperations(deptID As %String, operClass As %String = "") As %Query(ROWSPEC = "RowId,OperClassDesc,OperationDesc,Operation")
{
}

/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperQualificationManager","FindDeptOperations","104","")
ClassMethod FindDeptOperationsExecute(ByRef qHandle As %Binary, deptID As %String, operClass As %String = "") As %Status
{
	Set repid=$INCREMENT(^CacheTemp)
	If $GET(ind)="" Set ind=1
	Set ^tempzmy(1)=operClass
	Set DeptOperation=0
	For  Set DeptOperation=$ORDER(^CF.AN.DeptOperationI("IDeptID"," "_deptID,DeptOperation)) Quit:DeptOperation=""  Do
	    .Set RowId="",OperClassDesc="",OperationDesc="",Operation=""
        .Set Operation=$LIST(^CF.AN.DeptOperationD(DeptOperation),2)
        .Set RowId=DeptOperation
	    .Set OperClassId=$PIECE(^ORC("OPER",Operation),"^",7)
	    .If OperClassId'="" Set OperClassDesc=$PIECE($GET(^ORC("CATEG",OperClassId)),"^",2)
	    .Quit:((operClass'="")&&(operClass'=OperClassId))
	    .Set OperationDesc=$PIECE(^ORC("OPER",Operation),"^",2)
	    .Set result=$LISTBUILD(RowId,OperClassDesc,OperationDesc,Operation)
		.Do OutputRow
	
	

	Set qHandle=$LISTBUILD(0,repid,0)
	Quit $$$OK
OutputRow
	Set ^CacheTemp(repid,ind)=result
	Set ind=ind+1
	Quit
}

ClassMethod FindDeptOperationsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOperationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	//
	Set ind=$ORDER(^CacheTemp(repid,ind))
	If ind="" {				// if there are no more rows, finish fetching
	Set AtEnd=1
	Set Row=""
	}
	Else      {				// fetch row
	Set Row=^CacheTemp(repid,ind)
	}
	// Save QHandle
	Set qHandle=$LISTBUILD(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindDeptOperationsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOperationExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(CIS.AN.BL.OperQualificationManager).ImportDeptOperation("呼吸（内科）","1772","头和颈部血管治疗性超声")
ClassMethod ImportDeptOperation(SurgeonDept As %String = "", Surgeon As %String = "", Operation As %String = "", OperLecal As %String = "")
{
	Quit:SurgeonDept="" "科别不能为空"
	Set SurgeonDeptId=$ORDER(^CTLOC(0,"Desc",SurgeonDept,""))
	Quit:SurgeonDeptId="" "科别不存在"
	Quit:Surgeon="" "工号不能为空"
	Set SurgeonId=$ORDER(^CTPCP(0,"Code",Surgeon,""))
	Quit:SurgeonId="" "医护人员不存在"
	Quit:Operation="" "手术不能为空"
	Set OperationId=$ORDER(^ORC("OPER",0,"Desc",Operation,""))
	Quit:OperationId="" "手术名称不存在"
	Set ret=..SaveSurgeonOperation(SurgeonId,OperationId,SurgeonDeptId)
	Quit ret
}

ClassMethod SaveClassOperation(SurgeonId, OperClassId, SurgeonDeptId)
{
	Set operId=0,ret="",Saveret=""
	For  Set operId=$ORDER(^ORC("OPER",operId)) Quit:operId=""  Do
	.Quit:operId=""
	.Set objoper=##class(User.ORCOperation).%OpenId(operId)
	.Set OperClass=$PIECE(^ORC("OPER",operId),"^",7)
	.Quit:(OperClassId'="")&&(OperClassId'=OperClass)
	.Set datato=objoper.OPERActiveDateTo
	.Quit:(datato'="")&&(datato<+$HOROLOG)
	.Set Saveret=..SaveSurgeonOperation(SurgeonId,operId,SurgeonDeptId)
	.If Saveret'["S^" Do
	..If ret=""  Set ret=Saveret
	..Else  Set ret=ret_"!"_Saveret
	Quit ret
}

/// w ##class(CIS.AN.BL.OperQualificationManager).ImportHisData(^TMPOPAPP("Para"))
ClassMethod ImportHisData(data As %String) As %String
{
	Set ^TMPOPAPP("Para")=data
	Set $ZTRAP="Error"
	Set objCount=$LENGTH(data,",")
	Set ClassName=$PIECE(data,",",1)
	Quit:ClassName="" "E^ClassName is null"
	If (##class(%ClassDefinition).%ExistsId(ClassName))
    {
	    Set instance=$CLASSMETHOD(ClassName,"%New")
	    For objIndex=2:2:objCount
	    {
		    Set DataValue=$PIECE(data,",",objIndex)
		    Set DataField=$PIECE(data,",",objIndex+1)
		    Set $PROPERTY(instance,DataField)=DataValue
		}
	    Set sc=$METHOD(instance,"%Save")
	    If ($SYSTEM.Status.IsOK(sc))
	    {
		    Set result="S^"_$METHOD(instance,"%Id")
		}
		Else
		{
			Set result="E^"_$SYSTEM.Status.GetErrorText(sc)
        }
    }
    Else
    {
	    Set result="E^类"_ClassName_"不存在"    
    }  
    Quit result
Error
    Set $ZTRAP=""
    Quit "E^"_$ZERROR
}

/// w ##class(CIS.AN.BL.OperQualificationManager).ExportHISData("CT_AN.OperAction")
ClassMethod ExportHISData(className As %String) As %String
{
	Set myquery="SELECT * FROM drms_User_Oracle."_className
	Set tStatement = ##class(%SQL.Statement).%New()
	Set qStatus = tStatement.%Prepare(myquery)
	If qStatus'=1 {Write "%Prepare failed",$SYSTEM.Status.DisplayError(qStatus) Quit $$$OK}
	Set rset = tStatement.%Execute()
	While rset.%Next() {
		Set PropertyName=""
		For i=1:1:tStatement.%Metadata.columns.Count() {
			Set array("Property",tStatement.%Metadata.columns.GetAt(i).colName)=""
		}
		For
		{
			Set PropertyName=$ORDER(array("Property",PropertyName))
			Quit:PropertyName=""
			Set TMPHisDataList(0,PropertyName)=PropertyName
			Set TMPHisDataList(rset.rowid,PropertyName)=rset.%Get(PropertyName)
		}
   		//w "Row count:",rset.%ROWCOUNT,!
   		//w "Row GetData1:",rset.%GetData(1),!
   		//w "Row ResultColumnCount:",rset.%ResultColumnCount,!
   	}
   	Break ;
	Set json=##class(CIS.AN.COM.String).ToJson(.TMPHisDataList)
	Quit json
}

}
