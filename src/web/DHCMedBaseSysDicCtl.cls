Import SQLUser

/// Creator:	 陈剑波
/// Description: 系统字典类型处理函数库
/// Create Date: 2010-01-06
/// Updater:     
/// UpdateDate： 
Class web.DHCMedBaseSysDicCtl Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 根据传入rowid取系统字典表记录
ClassMethod GetItem(Id)
{
	n (Id)
	s ret=""
	q:'$d(^DHCMBSDIC(Id)) ret
	s ret=$g(^DHCMBSDIC(Id))
	/*
	s DataTypeDr=+$p(ret,"^",2)
	s:DataTypeDr'=0 DataType=$tr($g(^DHCWMRRDIC(DataTypeDr)),"^","/")
	s:$g(DataType)'="" $p(ret,"^",2)=DataTypeDr_"/"_DataType
	*/
	s ret=Id_"^"_ret
	q ret
}

/// "^SSUser^SS_User^SSUSR_RowId^SSUSR_Initials^SSUSR_Name^系统用户^Yes"
/// 添加或修改系统字典表
/// Debug:w ##class(web.DHCMedBaseSysDicCtl).UpdateSysDic(instr)
ClassMethod UpdateSysDic(Instring)
{
	n (Instring)
    s Rowid=$p(Instring,"^",1)      //Rowid
    s PLIST(2)=$p(Instring,"^",2)       //MBSD_Name
    s PLIST(3)=$p(Instring,"^",3)       //MBSD_TblName
    s PLIST(4)=$p(Instring,"^",4)       //MBSD_IdField
    s PLIST(5)=$p(Instring,"^",5)       //MBSD_CodeField
    s PLIST(6)=$p(Instring,"^",6)       //MBSD_DescField
    s PLIST(7)=$p(Instring,"^",7)       //MBSD_Demo
    s PLIST(8)="Y"
    s:$p(Instring,"^",8)["N" PLIST(8)="N"       //MBSD_Active
    i Rowid="" d
    .q:$d(^DHCMBSDIC(0,"NameTbl",PLIST(2)))
    .&sql(insert into DHC_MedBaseSysDic values :PLIST())
    e  d
    .&sql(update DHC_MedBaseSysDic values :PLIST() where MBSD_Rowid=:Rowid)
    q:SQLCODE SQLCODE
    s ret=$p(%ROWID,$c(1))
    q ret
}

ClassMethod QueryAllClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QueryAllExecute(ByRef qHandle As %Binary) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
    
	//^DHCMBSDIC({MBSD_Rowid}) 
	s Rowid=0
	f  s Rowid=$o(^DHCMBSDIC(Rowid)) q:Rowid=""  d
    .s IsActive=$p($g(^DHCMBSDIC(Rowid)),"^",6)
    .q:IsActive["N"
    .s s=Rowid_"^"_$g(^DHCMBSDIC(Rowid))
    .d BuildData
    
	Quit $$$OK
BuildData
	set Data=$lb("")
 	f iBuild=1:1:$l(s,"^") d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryAllFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllExecute ]
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

/// 获得所有系统字典表记录
/// d ##Class(%ResultSet).RunQuery("web.DHCMedBaseSysDicCtl","QueryAll")
Query QueryAll() As %Query(ROWSPEC = "Rowid:%String,Name:%String,TblName:%String,IdField:%String,CodeField:%String,DescField:%String,Active:%String,Resume:%String")
{
}

/// %SQLQuery %STARTSWITH 参数为空时返回的是所有记录
/// d ##Class(%ResultSet).RunQuery("web.DHCMedBaseSysDicCtl","QuerySysDic","De","")
Query QuerySysDic(TblName As %String, Code As %String, Desc As %String) As %SQLQuery
{
  SELECT %ID,CTLOC_Desc FROM CT_Loc where (CTLOC_Desc %STARTSWITH :Code)
}

/// 根据设置的系统字典取系统表的符合Code和Desc的值 为空的话获得所有
/// w ##class(web.DHCMedBaseSysDicCtl).GetDynamicSql(2,"4","")
ClassMethod GetDynamicSql(Id As %String, Code As %String, Desc As %String)
{
	n (Id ,Code,Desc)
	s ret=""
	q:'$d(^DHCMBSDIC(Id)) ret
	s TblName=$p($g(^DHCMBSDIC(Id)),"^",2)
	s IdField=$p($g(^DHCMBSDIC(Id)),"^",3)
	s CodeField=$p($g(^DHCMBSDIC(Id)),"^",4)
	s DescField=$p($g(^DHCMBSDIC(Id)),"^",5)
	q:(TblName=""!IdField=""!CodeField=""!DescField="") ret
	s SqlStr="SELECT "_IdField_","_CodeField_","_DescField_" FROM "_TblName_" where "_CodeField_" %STARTSWITH ? or "_DescField_" %STARTSWITH ?"
    Set result=##class(%ResultSet).%New("%DynamicQuery:SQL")
    //^DHCMBSDIC({MBSD_Rowid})
	//Set sc=result.Prepare("SELECT ?, ?, ? FROM ? WHERE ? like '%?' and ? like '%?'")
	//Set sc=result.Prepare("SELECT ?, ?, ? FROM ?")
	//Set sc=result.Prepare("SELECT SSUSR_RowId,SSUSR_Initials,SSUSR_Name FROM SS_User")
	Set sc=result.Prepare(SqlStr)
	If $$$ISERR(sc) q ret
	//Set sc=result.Execute(IdField,CodeField,DescField,TblName,Code,Desc)
	//Set sc=result.Execute(IdField,CodeField,DescField,TblName)
	//Set sc=result.Execute()
	Set sc=result.Execute(Code,Desc)
	If $$$ISERR(sc) q ret
	While result.Next(.sc) {
		If $$$ISERR(sc) Quit
		//Write result.Data(CodeField),result.Data(DescField),!
		s:ret'="" ret=ret_$c(1)_result.Data(IdField)_"^"_result.Data(CodeField)_"^"_result.Data(DescField)
		s:ret="" ret=result.Data(IdField)_"^"_result.Data(CodeField)_"^"_result.Data(DescField)
	}
	//s SqlStr="SELECT "_IdField_","_CodeField_","_DescField_" FROM "_TblName_" where "_CodeField_" %STARTSWITH ? and "_DescField_" %STARTSWITH ?"
	//If $$$ISERR(sc) Do DisplayError^%apiOBJ(sc) Quit
	q ret
}

ClassMethod QuerySysDicValuesClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySysDicValuesExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QuerySysDicValuesExecute(ByRef qHandle As %Binary, Id As %String, Code As %String, Desc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s ret=..GetDynamicSql(Id,Code,Desc)
	f j=1:1:$l(ret,$c(1)) d
	.s s=$p(ret,$c(1),j)
	.d BuildData
	Quit $$$OK
}

ClassMethod QuerySysDicValuesFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySysDicValuesExecute ]
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

/// 根据设置的系统字典取系统表的符合Code和Desc的值 为空的话是所有
/// d ##Class(%ResultSet).RunQuery("web.DHCMedBaseSysDicCtl","QuerySysDicValues",2,"4","")
Query QuerySysDicValues(Id As %String, Code As %String, Desc As %String) As %Query(ROWSPEC = "Rowid:%String,CodeVal:%String,DescVal:%String")
{
}

/// 根据系统字典表Rowid和对应表的ID值取对应的Code值和Desc值
/// Debug:w ##class(web.DHCMedBaseSysDicCtl).GetItemValueByRowid(2,484)
ClassMethod GetItemValueByRowid(DicId, ValId)
{
	n (DicId,ValId)
	s ret=""
	q:'$d(^DHCMBSDIC(DicId)) ret
	s TblName=$p($g(^DHCMBSDIC(DicId)),"^",2)
	s IdField=$p($g(^DHCMBSDIC(DicId)),"^",3)
	s CodeField=$p($g(^DHCMBSDIC(DicId)),"^",4)
	s DescField=$p($g(^DHCMBSDIC(DicId)),"^",5)
	q:(TblName=""!IdField=""!CodeField=""!DescField="") ret
	s SqlStr="SELECT "_IdField_","_CodeField_","_DescField_" FROM "_TblName_" where %ID=?"
    s result=##class(%ResultSet).%New("%DynamicQuery:SQL")
	s sc=result.Prepare(SqlStr)
	If $$$ISERR(sc) q ret
	Set sc=result.Execute(ValId)
	If $$$ISERR(sc) q ret
	While result.Next(.sc) {
		i $$$ISERR(sc) q
		//Write result.Data(CodeField),result.Data(DescField),!
		s:ret'="" ret=ret_$c(1)_result.Data(IdField)_"^"_result.Data(CodeField)_"^"_result.Data(DescField)
		s:ret="" ret=result.Data(IdField)_"^"_result.Data(CodeField)_"^"_result.Data(DescField)
	}
	q ret
}

}
