/// Creator: zy 2011-07-19 ZY0074
/// Description:导出列设置数据维护
Class web.DHCEQCColumns Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by csj 20190524 添加隐藏标志查询
Query Columns(TableDR As %Library.String = "", Name As %Library.String = "", Caption As %Library.String = "", Location As %Library.String = "", Sort As %Library.String = "", FormatDR As %Library.String = "", HiddenFlag As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TTable:%String,TTableDR:%String,TName:%String,THiddenFlag:%String,TCaption:%String,TLocation:%String,TRemark:%String,TFormat:%String,TFormatDR:%String,TSort:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod ColumnsExecute(ByRef qHandle As %Binary, TableDR As %Library.String = "", Name As %Library.String = "", Caption As %Library.String = "", Location As %Library.String = "", Sort As %Library.String = "", FormatDR As %Library.String = "", HiddenFlag As %Library.String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	Set TRow=0
	s TableID=0
	for  s TableID=$o(^DHCEQCCode("DHCEQCColumns",0,"Sort",TableID))  quit:TableID=""  d
	.quit:(TableDR'="")&&(TableID'=TableDR)
	.s SortID=0
	.for  s SortID=$o(^DHCEQCCode("DHCEQCColumns",0,"Sort",TableID,SortID))  quit:SortID=""  d
	..s rowid=0
	..for  s rowid=$o(^DHCEQCCode("DHCEQCColumns",0,"Sort",TableID,SortID,rowid))  quit:rowid=""  d
	...d ResetVariablesColumns
	...s TRowID=rowid
	...s TTableDR=TableID
	...s TTable=$p($g(^DHCEQCCode("DHCEQCTableData",TableID)),"^",2) 	//Table
	...s TName=$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",2) 		//Name
	...quit:(Name'="")&&(TName'[Name)
	...s THiddenFlag=$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",3) 	//HiddenFlag
	...q:(HiddenFlag'="")&&(HiddenFlag'=THiddenFlag)	//modified by csj 20190524 添加隐藏标志查询
	...//s THiddenFlag=##class(web.DHCEQCommon).TransValueToPage(THiddenFlag,"bool")
	...s TCaption=$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",4) 		//Caption
	...quit:(Caption'="")&&(TCaption'[Caption)
	...s TLocation=$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",5) 	//Location
	...quit:(Location'="")&&(TLocation'=Location)
	...s TRemark=$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",6) 		//Remark
	...s TFormatDR=$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",7) 		//Format
	...quit:(FormatDR'="")&&(TFormatDR'=FormatDR)
	...s TFormat=##class(web.DHCEQCColumns).FormatDiaplay(TFormatDR)
	...s TSort=$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",8) 		//Sort
	...quit:(Sort'="")&&(TSort'=Sort)
	...s THold1=$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",9) 		//Hold1
	...s THold2=$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",10) 		//Hold2
	...s THold3=$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",11) 		//Hold3
	...s THold4=$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",12) 		//Hold4
	...s THold5=$p($g(^DHCEQCCode("DHCEQCColumns",rowid)),"^",13) 		//Hold5
	...d OutputRowColumns
	
	Quit $$$OK
OutputRowColumns
	Set TRow=TRow+1
    s Data=$lb(TRowID,TTable,TTableDR,TName,THiddenFlag,TCaption,TLocation,TRemark,TFormat,TFormatDR,TSort,THold1,THold2,THold3,THold4,THold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesColumns
	s (TRowID,TTable,TTableDR,TName,THiddenFlag,TCaption,TLocation,TRemark,TFormat,TFormatDR,TSort,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod ColumnsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ColumnsExecute ]
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

ClassMethod ColumnsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ColumnsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query Format() As %Query(ROWSPEC = "Desc:%String:描述,ID:%String")
{
}

ClassMethod FormatExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ID=1
	s Desc=##class(web.DHCEQCColumns).FormatDiaplay(ID)
	i Desc'="" d OutputRowFormat
	s ID=11
	s Desc=##class(web.DHCEQCColumns).FormatDiaplay(ID)
	i Desc'="" d OutputRowFormat
	s ID=12
	s Desc=##class(web.DHCEQCColumns).FormatDiaplay(ID)
	i Desc'="" d OutputRowFormat
	s ID=2
	s Desc=##class(web.DHCEQCColumns).FormatDiaplay(ID)
	i Desc'="" d OutputRowFormat
	s ID=3
	s Desc=##class(web.DHCEQCColumns).FormatDiaplay(ID)
	i Desc'="" d OutputRowFormat
	s ID=4
	s Desc=##class(web.DHCEQCColumns).FormatDiaplay(ID)
	i Desc'="" d OutputRowFormat
	Quit $$$OK
OutputRowFormat
    s Data=$lb(Desc,ID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod FormatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FormatExecute ]
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

ClassMethod FormatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FormatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// "1:YYYY-MM-DD"
/// "11:YYYY年MM月DD日"
/// "12:dd/mm/yyyy"
/// "2:0.00"
/// "3:短名称根据-截取"
/// "4:字符串"
ClassMethod FormatDiaplay(ID)
{
	s Desc="" 
	if ID=1	 s Desc="日期(YYYY-MM-DD)"
	if ID=11 s Desc="日期(YYYY年MM月DD日)"
	if ID=12 s Desc="日期(dd/mm/yyyy)"
	if ID=2  s Desc="数字(0.00)"	
	if ID=3	 s Desc="短名称(根据-截取)"
	if ID=4  s Desc="字符串"
	q Desc
}

/// 91^1^DesignWorkLoadNum^true^额定工作量^30^^^30.0^^^^^
ClassMethod SaveData(val, type)
{
	new (val,type)
	Set $ZT="ERROR"
	s tmpid=""
	s rowid=$p(val,"^",1)
	s PLIST(2) = $p(val,"^",2)	;TableDR
	s PLIST(3) = $p(val,"^",3) ;Name
	s PLIST(4) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"bool")	;HiddenFlag
	s PLIST(5) = $p(val,"^",5) ;Caption
	s PLIST(6) = $p(val,"^",6) ;Location
	s PLIST(7) = $p(val,"^",7) ;Remark
	s PLIST(8) = $p(val,"^",8) ;Format
	s PLIST(9) = $p(val,"^",9) ;Sort
	s PLIST(10) = $p(val,"^",10) ;Hold1
	s PLIST(11) = $p(val,"^",11) ;Hold2
	s PLIST(12) = $p(val,"^",12) ;Hold3
	s PLIST(13) = $p(val,"^",13) ;Hold4
	s PLIST(14) = $p(val,"^",14) ;Hold5
	//
	TSTART
	i (+type=1)  //新增按钮操作
	{
		&SQL(select C_RowID into :tmpid from SQLUSER.DHC_EQCColumns where C_TableDR=:PLIST(2) and C_Name=:PLIST(3))
		if (tmpid="")
		{
			if (rowid="")
			{
				&SQL(Insert Into SQLUSER.DHC_EQCColumns Values :PLIST())
			}
			else
			{
			 	&SQL(Update SQLUSER.DHC_EQCColumns Values :PLIST() where C_RowID = :rowid)
			}
		}
		else
		{
			if (rowid=tmpid)
			{
		 		&SQL(Update SQLUSER.DHC_EQCColumns Values :PLIST() where C_RowID = :rowid)
			}
			else
			{
				s SQLCODE=-1001   //数据重复
			}
		}
	 }
	 i (+type=0)  //删除按钮操作
	 {
		 &SQL(select CS_RowID into :tmpid from SQLUSER.DHC_EQCColSet where CS_ColumnDR=:rowid)
		 if (tmpid="")
		 {
			 &SQL(Delete from SQLUser.DHC_EQCColumns where C_RowID = :rowid)
		 }
		 else
		 {
			 s SQLCODE=-1002   //字段有地方用到
		 }		 
	 }
	 i SQLCODE
	 {
	 	TROLLBACK
	 	q SQLCODE
	 }
	TCOMMIT
	q SQLCODE
ERROR 
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERROR>"_ErrorMsg     //返回错误消息 ;
}

}
