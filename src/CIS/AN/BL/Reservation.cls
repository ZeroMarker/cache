Class CIS.AN.BL.Reservation Extends %RegisteredObject
{

/// Creator：      	雍阳
/// CreatDate：    	2018-10-30
/// Description： 	查询药品项
/// Table：        	CF.AN.UserPreferedDrug
/// Input:			
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.ConfigQueries","FindUserPreferedDrug")
Query FindReservation(deptId As %String, operDate As %String, operRoom As %String = "", resnProv As %String = "", queryCancel As %String = "N") As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT RowId,
	   %ODBCOUT(OperDate) As OperDate,
	   OperRoom,
	   OperRoom->Description As OperRoomDesc,
	   Article,
	   Article->Description As ArticleDesc,
	   Qty,
	   Uom,
	   CIS_AN_COM.String_GetDescByID('User.CTUOM','CTUOMDesc',Uom) As UomDesc,
	   ResnProv,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',ResnProv) As ResnProvDesc,
	   %ODBCOUT(ResnDate)_' '_%ODBCOUT(ResnTime) As ResnDT,
	   PrepareProv,
	   CIS_AN_COM.String_GetDescByID('User.SSUser','SSUSRName',PrepareProv) As PrepareProvDesc,
	   %ODBCOUT(PrepareDate)_' '_%ODBCOUT(PrepareTime) As PrepareDT,
	   PrepareQty,
	   Status,
	   %EXTERNAL(Status) As StatusDesc,
	   UpdateUser,
	   %ODBCOUT(UpdateDate)_' '_%ODBCOUT(UpdateTime) As UpdateDT,
	   Dept,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',Dept) As DeptDesc
	   from CIS_AN.Reservation
	   where (Dept=:deptId)
	   and (OperDate=%ODBCIN(:operDate))
	   and (OperRoom=:operRoom or :operRoom is null)
	   and (ResnProv=:resnProv or :resnProv is null)
	   and ((:queryCancel="N" and Status in ('R','P')) or :queryCancel="Y")
}

ClassMethod SaveReservation(dataPara As %String) As %String
{
	set $zt="Error"
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)
	tstart
	set dataIndex=0,saveResult=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		k reservation
		m reservation=array(dataIndex)
		set rowId=$get(reservation("RowId"))
		if (##class(CIS.AN.Reservation).%ExistsId(rowId)=0)
		{
			set reservation("ResnDate")=+$h
			set reservation("ResnTime")=$p($h,",",2)
			set reservation("Status")="R"	
		}
		else
		{
			set status=$get(reservation("Status"))
			if (status="P")
			{
				set resnObj=##class(CIS.AN.Reservation).%OpenId(rowId)
				if (resnObj.PrepareDate="")
				{
					set reservation("PrepareDate")=+$h
					set reservation("PrepareTime")=$p($h,",",2)	
				}
					
			}	
		}
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.reservation)
		quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
Error
	set $zt=""
	quit "E^"_$ze
}

ClassMethod PrepareArticle(dataPara As %String) As %String
{
	set $zt="Error"
	set sc=##class(CIS.AN.COM.String).ToArray(dataPara,.array)
	tstart
	set dataIndex=0,saveResult=""
	for
	{
		set dataIndex=$order(array(dataIndex))
		quit:(dataIndex="")
		m reservation=array(dataIndex)
		set reservation("PrepareDate")=+$h
		set reservation("PrepareTime")=$p($h,",",2)
		set saveResult=##class(CIS.AN.COM.DataService).SaveData(.reservation)
		quit:($piece(saveResult,"^",1)'="S")
	}
	if ($piece(saveResult,"^",1)'="S")
	{
		trollback
		quit saveResult	
	}
	
	tcommit
	quit "S^"
Error
	set $zt=""
	quit "E^"_$ze
}

}
