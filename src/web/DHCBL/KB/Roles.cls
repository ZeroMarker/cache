Class web.DHCBL.KB.Roles Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-4-2
/// Description：查询角色对照表内容
/// Table：%BI.Roles
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.Roles","GetList","","","","","")
Query GetList(rowid, desc) As %Query(ROWSPEC = "RoleRowId,Description,ParentRole,Desc,LicMax,MinDrl,MdLog")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s RoleRowId=rowid
		s Description=$listget($g(^BI.RolesD(RoleRowId)),1)  
		s ParentRole=$listget($g(^BI.RolesD(RoleRowId)),2) 
		s:ParentRole'="" Desc=$listget($g(^BI.RolesD(ParentRole)),1)   
		s LicMax=$listget($g(^BI.RolesD(RoleRowId)),3)  
		s MinDrl=$listget($g(^BI.RolesD(RoleRowId)),4)  
		s MdLog=$listget($g(^BI.RolesD(RoleRowId)),5)  
		d OutputRow
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s RoleRowId=0
		for  
		{	
			s RoleRowId=$o(^BI.RolesD(RoleRowId)) q:RoleRowId="" 
			
			s Description=$listget($g(^BI.RolesD(RoleRowId)),1) 
			s DescriptionU=$ZCONVERT(Description,"U") 
			s ParentRole=$listget($g(^BI.RolesD(RoleRowId)),2) 
			s:ParentRole'="" Desc=$listget($g(^BI.RolesD(ParentRole)),1)   
			s LicMax=$listget($g(^BI.RolesD(RoleRowId)),3)  
			s MinDrl=$listget($g(^BI.RolesD(RoleRowId)),4)  
			s MdLog=$listget($g(^BI.RolesD(RoleRowId)),5)
		
			i (DescriptionU[desc)   //条件
			{
				d OutputRow
			}		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(RoleRowId,Description,ParentRole,Desc,LicMax,MinDrl,MdLog)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator:高姗姗
/// CreatDate:2015-4-3
/// Description:查询
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.Roles","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "RoleRowId:%String,Description:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	if (rowid'="")
	{
		s RoleRowId=rowid
		s Description=$listget($g(^BI.RolesD(RoleRowId)),1)  
		d OutputRowCmb
	}
	else
	{
		s:desc'="" desc=$ZCONVERT(desc,"U")
		s RoleRowId=0
		for
		{
			s RoleRowId=$o(^BI.RolesD(RoleRowId)) q:RoleRowId="" 
			
			s Description=$listget($g(^BI.RolesD(RoleRowId)),1) 
			s DescriptionU=$ZCONVERT(Description,"U") 
			i (DescriptionU[desc)
			{
				d OutputRowCmb
			}
			
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RoleRowId,Description)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
