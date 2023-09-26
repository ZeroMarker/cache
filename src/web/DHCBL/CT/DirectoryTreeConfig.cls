Class web.DHCBL.CT.DirectoryTreeConfig Extends %RegisteredObject
{

/// Creator:高姗姗
/// CreatDate:2017-1-20
/// Description:查询目录树配置
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DirectoryTreeConfig","GetDataForCmb1","User.SSUser","")
Query GetDataForCmb1(table As %String, desc As %String) As %Query(ROWSPEC = "RowId:%String,Desc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, table As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
	s ind=1
	s ^TMP("DirectoryTree","User.SSUser","SSUSRDefaultDeptDR")="登录科室->用户"
	s ^TMP("DirectoryTree","User.SSUser","RESCTLOCDR")="科室->用户"
	s ^TMP("DirectoryTree","User.SSUser","SSUSRGroup")="安全组->用户"
	s ^TMP("DirectoryTree","User.SSUser","CTPCPCarPrvTpDR")="医护人员类型->用户"
	s ^TMP("DirectoryTree","User.SSUser","CTPCPSpecDR")="医生专长->用户"
	s ^TMP("DirectoryTree","User.SSUser","SSUSRHospitalDR")="医院->用户"
	s ^TMP("DirectoryTree","User.SSUser","HospitalSSUSRDefaultDeptDR")="医院->登录科室->用户"
	s ^TMP("DirectoryTree","User.SSUser","HospitalRESCTLOCDR")="医院->科室->用户"
	s ^TMP("DirectoryTree","User.SSUser","HospitalSSUSRGroup")="医院->安全组->用户"
	s ^TMP("DirectoryTree","User.CTLoc","CTLOCType")="科室类型->科室"
	s ^TMP("DirectoryTree","User.CTLoc","CTLOCDepDR")="部门组->科室"
	s ^TMP("DirectoryTree","User.CTLoc","CTLOCHospitalDR")="医院->科室"
	s:desc'="" desc=$ZCONVERT(desc,"U")
	s RowId=0
	for
	{
		s RowId=$o(^TMP("DirectoryTree",table,RowId)) q:RowId=""
		s Desc=^TMP("DirectoryTree",table,RowId)

		i (Desc[desc)
		{
			d OutputRowCmb
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RowId,Desc)
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

/// Others:w ##class(web.DHCBL.CT.DirectoryTreeConfig).OpenData("User.SSUser")
ClassMethod OpenData(table As %String) As %String
{
	s rule=""
	if (table="User.CTLoc")&&($d(^TMP("DirectoryTreeConfig","User.CTLoc"))=0){
		s rule="CTLOCHospitalDR"
	}elseif(table="User.SSUser")&&($d(^TMP("DirectoryTreeConfig","User.SSUser"))=0){
		s rule="HospitalSSUSRDefaultDeptDR"
	}else{
		s rule=^TMP("DirectoryTreeConfig",table)
	}
	q rule
}

/// Others:w ##class(web.DHCBL.CT.DirectoryTreeConfig).SaveData("User.CTLoc","SSUSRDefaultDeptDR")
ClassMethod SaveData(table As %String, rule As %String) As %String
{
	s result=""
	s ^TMP("DirectoryTreeConfig",table)=rule
	s result=1
	q result
}

}
