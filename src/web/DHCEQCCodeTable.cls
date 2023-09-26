Import SQLUser

Class web.DHCEQCCodeTable Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 85;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

/// ---------search CodeTable Star
Parameter SQLCODE = "CT_RowID";

/// / Modified  By QW20210512 BUG:QW0108 恢复
Query GetCodeTable(TabName As %String = "", PreFix As %String = "", Code As %String = "", Desc As %String = "", Remark As %String = "", titleName) As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TRow:%String")
{
}

ClassMethod GetCodeTableExecute(ByRef qHandle As %Binary, TabName As %String = "", PreFix As %String = "", Code As %String = "", Desc As %String = "", Remark As %String = "", titleName) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetConfigItem
	Quit $$$OK
BuildDataGetConfigItem
	q:TabName=""
	s TabName=##Class(web.DHCEQCommon).Replace(TabName,"_","")
	f  s rowid=$o(^DHCEQCCode(TabName,rowid))  quit:rowid=""  d
	.d ResetVariablesGetConfigItem
	.s TRowID = rowid	//rowid
	.s TCode=$p($g(^DHCEQCCode(TabName,rowid)),"^",1) //代码
	.q:TCode'[Code
	.s TDesc=$p($g(^DHCEQCCode(TabName,rowid)),"^",2) //描述
	.q:TDesc'[Desc
	.s TRemark=$p($g(^DHCEQCCode(TabName,rowid)),"^",3) //备注
	.s TInvalidFlag=$p($g(^DHCEQCCode(TabName,rowid)),"^",4) //无效标志
	.q:(TInvalidFlag'="N")
	.s TRow=index
	.d OutputRowGetConfigItem
	Quit 
OutputRowGetConfigItem
    s Data=$lb(TRowID,TCode,TDesc,TRemark,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetConfigItem
	s (TRowID,TCode,TDesc,TRemark,TRow)="" 
	quit
	/*
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s sqlString=""
	if TabName'="" 
	{	
		s tj=""
		s sqlRowID=PreFix _ "_RowID"
		s sqlCode=PreFix _ "_Code"
		s sqlDesc=PreFix _ "_Desc"
		s sqlRemark=PreFix _ "_Remark"
		s sqlInvalidFlag=PreFix _ "_InvalidFlag"
		if Code'=""
		{
			s tj = sqlCode _ " like '%" _ Code _ "%'"
		} 
		if Desc'=""
		{
			if tj=""
			{
				s tj = sqlDesc _ " like '%" _ Desc _ "%'"			
			}
			else
			{
				s tj = tj _ " and " _ sqlDesc _ " like '%" _ Desc _ "%'"	
			}
		}
		if Remark'=""
		{
			if tj=""
			{
				s tj = sqlRemark _ " like '%" _ Remark _ "%'"
			}
			else
			{
				s tj = tj _ " and " _ sqlRemark _ " like '%" _ Remark _ "%'"
			}
		}		
		if tj=""
		{		
			s sqlString="select " _ sqlRowID _ " AS TRowID," _ sqlCode _ " as TCode," _ sqlDesc _ " as TDesc," _ sqlRemark _ " as TRemark from SqlUser." _ TabName _ " where " _ sqlInvalidFlag _ "='N'"
		}
		else
		{
			s sqlString="select " _ sqlRowID _ " AS TRowID," _ sqlCode _ " as TCode," _ sqlDesc _ " as TDesc," _ sqlRemark _ " as TRemark from SqlUser." _ TabName _ " where " _ sqlInvalidFlag _ "='N' and " _ tj
		}		
		//s Data=$lb(sqlRowID,sqlString,sqlDesc,sqlRemark,sqlInvalidFlag,sqlString)
		//Set ^CacheTemp(repid,index)=Data
		Set rs = ##class(%ResultSet).%New()
		Do rs.Prepare(sqlString)
    	d rs.Execute()    	
	}	
	*/
}

ClassMethod GetCodeTableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCodeTableExecute ]
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

Parameter SQLDESCRIPTION = "CT_TableDesc";

ClassMethod GetCodeTableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCodeTableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Parameter SQLROWID = "CT_RowID";

/// ---------search TableDir Star
Query GetTableDir() As %Query(ROWSPEC = "TRowID:%String,TCodeName:%String,TCodeDesc:%String,TShortDesc:%String,TType:%String,TReadOnly:%String,TRow:%String")
{
}

ClassMethod GetTableDirExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set CurGroup=%session.Get("LOGON.GROUPID")
	s index=1
	s rowid=0
	d BuildDataGetTableDir
	Quit $$$OK
BuildDataGetTableDir
	&sql(DECLARE tableDir CURSOR FOR
	   select CT_RowID,CT_TableName,CT_TableDesc,CT_Prefix,CT_Type,CT_ReadOnly from SQLUser.DHC_EQCCodeTable where CT_Hidden='0' and CT_RowID in (select GCT_CodeTableDR from sqluser.DHC_EQCGroupCTable where GCT_GroupDR=:CurGroup))
	&sql(OPEN tableDir )
	f  &sql(fetch tableDir into :rowid,:TableName,:TableDesc,:Prefix,:Type,:ReadOnly) q:SQLCODE  d
	.d ResetVariablesGetTableDir
	.s RowID=$p(rowid,$c(1))
	.s oTableName = TableName
	.s oTableDesc = TableDesc
	.s oPrefix= Prefix
	.s oType=Type
	.s oReadOnly=ReadOnly
	.s TRow=index
	.d OutputRowGetTableDir
	&sql(close tableDir )
	quit
OutputRowGetTableDir
	s Data=$lb(RowID,oTableName,oTableDesc,oPrefix,oType,oReadOnly,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetTableDir
	s (oTableName,oTableDesc,oPrefix,oType,oReadOnly,TRow)=""
	quit
}

ClassMethod GetTableDirFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTableDirExecute ]
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

ClassMethod GetTableDirClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTableDirExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by zy 2017-03-24  修改标准代码维护界面的逻辑
/// -------Sql method
/// tabNameStr,preFixStr,rowidStr,codeStr,descStr,remarkStr
/// w ##Class(web.DHCEQCCodeTable).ExecSql("update SqlUser.DHC_EQCPurposeType set PT_Code='09',PT_Desc='住宅楼',PT_Remark=' ttt' where PT_RowID=9")
ClassMethod ExecSql(optType As %Library.String = "", tabNameStr As %Library.String = "", preFixStr As %Library.String = "", rowidStr As %Library.String = "", codeStr As %Library.String = "", descStr As %Library.String = "", remarkStr As %Library.String = "")
{
	i +optType=0
	{
		s sqlStr="insert into SqlUser."_tabNameStr_" ("_preFixStr_"_Code,"_preFixStr_"_Desc,"_preFixStr_"_Remark,"_preFixStr_"_InvalidFlag) values ('"_codeStr_"','"_descStr_"','"_remarkStr_"','N')"
	}
	elseif +optType=1
	{
		s sqlStr="update SqlUser."_tabNameStr_" set "_preFixStr_"_Code='"_codeStr_"',"_preFixStr_"_Desc='"_descStr_"',"_preFixStr_"_Remark='"_remarkStr_"' where "_preFixStr_"_RowID="_rowidStr
	}	
	elseif +optType=2
	{
		s sqlStr="update SqlUser."_tabNameStr_" set "_preFixStr_"_InvalidFlag='Y' where "_preFixStr_"_RowID="_rowidStr
	}	
	Set rs = ##class(%ResultSet).%New()
	Do rs.Prepare(sqlStr)
	d rs.Execute()  
	q SQLCODE
}

/// Add By DJ 2010-06-11
/// 检测录入或修改数据是否已存在
ClassMethod CheckData(TableName, RowID, Code, Desc)
{
	s ID=0
	s Find=0
	f  s ID=$o(^DHCEQCCode(TableName,ID)) q:(ID="")||(Find'=0)  d
	.s Invalidflag=$p($g(^DHCEQCCode(TableName,ID)),"^",4)
	.q:Invalidflag="Y"
	.s TCode=$p($g(^DHCEQCCode(TableName,ID)),"^",1)
	.i (TCode=Code)&&(RowID'=ID) s Find=1
	.s TDesc=$p($g(^DHCEQCCode(TableName,ID)),"^",2)
	.i (TDesc=Desc)&&(RowID'=ID) s Find=1
	q Find
}

}
