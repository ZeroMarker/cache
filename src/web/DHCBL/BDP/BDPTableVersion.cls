/// 版本定义表的增删改查
/// User.BDPTableVersion
Class web.DHCBL.BDP.BDPTableVersion Extends %RegisteredObject
{

/// Creator：基础数据平台-杨帆
/// CreatDate: 2019年12月19日
/// Description：遍历版本定义表
/// Table：User.BDPTableVersion
/// d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTableVersion","GetList","","81")
Query GetList(rowid As %String, tabledr As %String) As %Query(ROWSPEC = "RowID,TableName,Version,ActiveFlag,Remarks")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, tabledr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	if (rowid'="")
 	{
	 	s RowID=rowid
	 	s TableName=$lg($g(^User.BDPTableVersionD(RowID)),2)	//表名
	 	s Version=$lg($g(^User.BDPTableVersionD(RowID)),3)		//版本号
	 	s ActiveFlag=$lg($g(^User.BDPTableVersionD(RowID)),4)	//激活标识
	 	s Remarks=$lg($g(^User.BDPTableVersionD(RowID)),5)		//备注
	 	s TableName=..GetTableWithDesc(TableName)		//调用同时取表名和描述的接口
	 	d OutputRow
	 }
	 else
	 {
		s table=""
		s:tabledr'="" table=$lg($g(^User.BDPTableListD(tabledr)),8)		//入参表名
	 	s RowID=0
	 	for
	 	{
		 	s RowID=$O(^User.BDPTableVersionD(RowID)) q:RowID=""
		 	s TableName=$lg($g(^User.BDPTableVersionD(RowID)),2)	//表名
		 	s Version=$lg($g(^User.BDPTableVersionD(RowID)),3)		//版本号
		 	s ActiveFlag=$lg($g(^User.BDPTableVersionD(RowID)),4)	//激活标识
		 	s Remarks=$lg($g(^User.BDPTableVersionD(RowID)),5)		//备注
		 	s TableName=..GetTableWithDesc(TableName)		//调用同时取表名和描述的接口
		 	if ($ZCONVERT(TableName,"U")=$ZCONVERT(table,"U"))||(table="")
		 	{
				d OutputRow
			}

		}
	 }
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowID,TableName,Version,ActiveFlag,Remarks)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：基础数据平台-杨帆
/// CreatDate: 2019年12月19日
/// Description：查询版本定义表
/// Table：User.BDPTableVersion
/// Input：id
/// Others：w ##class(web.DHCBL.BDP.BDPTableVersion).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	 s str=""
	 s obj = ##class(User.BDPTableVersion).%OpenId(id)
	 s eobj = ##class(web.Entity.BDP.BDPTableVersion).%New()
	 s eobj.RowID = id						//RowID
	 s eobj.TableName=obj.TableName			//表名
	 s eobj.Version=obj.Version				//版本号
	 s eobj.ActiveFlag=obj.ActiveFlag		//是否激活
	 s eobj.Remarks=obj.Remarks		//备注
	 s:eobj.ActiveFlag="Y" eobj.ActiveFlag="true"
	 
	//根据表名取表结构登记RowId
	s RowID=0
 	for	
 	{
	 	s RowID=$O(^User.BDPTableListD(RowID)) q:RowID=""
	 	s ClassName=$lg($g(^User.BDPTableListD(RowID)),8)		//表名
	 	s:eobj.TableName=ClassName eobj.TableName=RowID
	}
	 
	 d obj.%Close()
	 s str = eobj.JsonS()
	 s str = "{list:["_str_"]}"
	 q str
}

/// Creator：基础数据平台-杨帆
/// CreatDate: 2019年12月19日
/// Description：删除版本定义表
/// Table：User.BDPTableVersion
/// Input：id
/// Others：w ##class(web.DHCBL.BDP.BDPTableVersion).DeleteData("3")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		s flag=..GetRefFlag(id)
		if (flag=1)
		{
			s result="{success:'false',info:'该版本存在关联数据！'}"
		}
		else
		{
			s pobj = ##class(User.BDPTableVersion).%OpenId(id)
			s eobj = ##class(web.Entity.BDP.BDPTableVersion).%New()
			s eobj.RowID = id
			S eobj.TableName=pobj.TableName
			s eobj.Version= pobj.Version
			s eobj.ActiveFlag=pobj.ActiveFlag
			s eobj.Remarks=pobj.Remarks
			TSTART
			s sc=##class(User.BDPTableVersion).%DeleteId(id)
			if (sc)
			{
				TCOMMIT
				s result="{success:'true',info:'删除成功！'}"
				d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_TableVersion","User.BDPTableVersion","版本定义",id,eobj.TableName,"D",eobj)
			}
			else
			{
				TROLLBACK
				s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			}
		}
	}
	else
	{
		s result="{success:'false',info:'数据不存在！'}"
	}
	q result
}

/// Creator：基础数据平台-杨帆
/// CreatDate: 2019年12月19日
/// Description：保存版本定义表
/// Table：User.BDPTableVersion
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPTableVersion) As %String
{
	s result=""
	s:eobj.ActiveFlag="" eobj.ActiveFlag="N"
	s:eobj.TableName'="" eobj.TableName=$lg($g(^User.BDPTableListD(eobj.TableName)),8)		//取表名
	if (eobj.RowID="")
	{
		s obj=##class(User.BDPTableVersion).%New()
	}
	else
	{
		s obj=##class(User.BDPTableVersion).%OpenId(eobj.RowID)
		s bobj=##class(web.Entity.BDP.BDPTableVersion).%New()
	    s bobj.RowID=eobj.RowID
	    s bobj.TableName = obj.TableName
	    s bobj.Version= obj.Version
	    s bobj.ActiveFlag = obj.ActiveFlag
	    s bobj.Remarks = obj.Remarks
	}
	if (obj)
	{
		s obj.TableName=eobj.TableName
		s obj.Version=eobj.Version
		s obj.ActiveFlag=eobj.ActiveFlag
		s obj.Remarks=eobj.Remarks
		TSTART
		s sc=obj.%Save()
		if (sc)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_TableVersion","User.BDPTableVersion","版本定义",eobj.RowID,eobj.TableName,"U",eobj,bobj)
    		d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_TableVersion","User.BDPTableVersion","版本定义",id,eobj.TableName,"A",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
		k obj
		k eobj
	}
	q result
}

/// Creator：基础数据平台-杨帆
/// CreatDate: 2019年12月19日
/// Description：版本定义表数据校验
/// Table：User.BDPTableVersion
/// Input：表名table，版本号version
/// Output：1：重复		0：不重复
/// Others：w ##class(web.DHCBL.BDP.BDPTableVersion).FormValidate("","DHC_Student","v1.0.0")
ClassMethod FormValidate(id As %String, table As %String, version As %String) As %String
{
	s flag=0
	if ((table'="")&&(version'=""))
	s RowID=$o(^User.BDPTableVersionI("UniqueTableNameVersionIndex"," "_$ZCONVERT(table,"U")," "_$ZCONVERT(version,"U"),0))
	s:((RowID'="")&&(RowID'=id)) flag=1
	q flag
}

/// Creator：基础数据平台-李可凡 		
/// CreatDate: 2020年2月10日
/// Description：查询版本定义表里的所有版本
/// Table：User.BDPTableVersion
/// Other：d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTableVersion","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, tableversion As %String) As %Query(ROWSPEC = "RowID,TableVersion")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, tableversion As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="")
	{
		s RowID=rowid
		s TableName=$lg($g(^User.BDPTableVersionD(RowID)),2)	//表名
		s Version=$lg($g(^User.BDPTableVersionD(RowID)),3)		//版本号
		s TableVersion=TableName_"-"_Version
		d OutputRowCmb
	}
	else
	{
		s:tableversion'="" tableversion=$ZCONVERT(tableversion,"U")
		s RowID=0
		for
	 	{
		 	s RowID=$O(^User.BDPTableVersionD(RowID)) q:RowID=""
		 	s TableName=$lg($g(^User.BDPTableVersionD(RowID)),2)	//表名
		 	s Version=$lg($g(^User.BDPTableVersionD(RowID)),3)		//版本号
		 	s TableVersion=TableName_"-"_Version
		 	if ($ZCONVERT(TableVersion,"U")[tableversion)
		 	{
				d OutputRowCmb
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
    set Data=$lb(RowID,TableVersion)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年2月12日
/// Description：根据表名获取启用的版本号
/// Table：User.BDPTableVersion
/// d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTableVersion","GetVersionByTable","103")
Query GetVersionByTable(tabledr As %String) As %Query(ROWSPEC = "RowID,TableName,Version")
{
}

ClassMethod GetVersionByTableExecute(ByRef qHandle As %Binary, tabledr As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	s table=""
	s:tabledr'="" table=$lg($g(^User.BDPTableListD(tabledr)),8)		//入参表名
 	s RowID=0
 	for
 	{
	 	s RowID=$O(^User.BDPTableVersionD(RowID)) q:RowID=""
	 	s TableName=$lg($g(^User.BDPTableVersionD(RowID)),2)	//表名
	 	s Version=$lg($g(^User.BDPTableVersionD(RowID)),3)		//版本号
	 	s ActiveFlag=$lg($g(^User.BDPTableVersionD(RowID)),4)	//激活标识
	 	if (($ZCONVERT(TableName,"U")=$ZCONVERT(table,"U"))||(table=""))&&(ActiveFlag'="N")
	 	{
			d OutputRow2
		}
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(RowID,TableName,Version)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetVersionByTableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVersionByTableExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetVersionByTableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVersionByTableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年2月25日
/// Description：根据表结构登记获取‘是否区分版本’为Y的表名
/// Table：User.BDPTableList
/// Input: 表名table，例如"CT_CareProv"
/// Output: RowID(表结构登记的RowID),Table(表名)
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTableVersion","GetTable","")
Query GetTable(table As %String) As %Query(ROWSPEC = "RowID,Table")
{
}

ClassMethod GetTableExecute(ByRef qHandle As %Binary, table As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
 	s table=$ZCONVERT(table,"U")
 	s RowID=0
 	for
 	{
	 	s RowID=$O(^User.BDPTableListD(RowID)) q:RowID=""
	 	s ClassName=$lg($g(^User.BDPTableListD(RowID)),8)		//表名
	 	s TableDesc=$lg($g(^User.BDPTableListD(RowID)),3)		//中文名
	 	s VersionFlag=$lg($g(^User.BDPTableListD(RowID)),11)	//是否区分版本
	 	s Table=ClassName_"("_TableDesc_")"
	 	if (VersionFlag="Y")&&(Table[table)
	 	{
			d OutputRow3
		}
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow3
	set Data=$lb(RowID,Table)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTableExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Description: 根据表名返回表名加中文描述,取自表结构登记的数据
/// Creator: 基础数据平台-李可凡
/// CreatDate: 2020年2月27日
/// Table: User.BDPTableList
/// Input: 表名，例如"CT_CareProv"
/// Output: 表名(中文描述)，例如"CT_CareProv(医护人员)"
/// Others: w ##class(web.DHCBL.BDP.BDPTableVersion).GetTableWithDesc("CT_SocialStatus")
ClassMethod GetTableWithDesc(tablename As %String) As %String
{
	q:tablename="" ""
	s Table=""
	s RowID=0
 	for
 	{
	 	s RowID=$O(^User.BDPTableListD(RowID)) q:RowID=""
	 	s ClassName=$lg($g(^User.BDPTableListD(RowID)),8)		//表名
	 	s TableDesc=$lg($g(^User.BDPTableListD(RowID)),3)		//中文名
	 	if (ClassName=tablename)
	 	{
		 	s Table=ClassName_"("_TableDesc_")"
		 	q
		}
	}
	q Table
}

/// Description: 删除时判断是否被‘版本号关联数据表’引用
/// Creator: 基础数据平台-李可凡
/// CreatDate: 2020年3月24日
/// Input: id
/// Output: 0 未被引用可以删除		1 被引用，不能删除
/// Others: w ##class(web.DHCBL.BDP.BDPTableVersion).GetRefFlag("4")
ClassMethod GetRefFlag(id As %String) As %String
{
	s flag=0
	s tablename=$lg($g(^User.BDPTableVersionD(id)),2)
	s version=$lg($g(^User.BDPTableVersionD(id)),3)
	s RowID=0
 	for
 	{
	 	
		s RowID=$O(^User.BDPTableVersionLinkDataD(RowID)) q:RowID=""
		s TableName=$lg($g(^User.BDPTableVersionLinkDataD(RowID)),2)	//表名
		s Version=$lg($g(^User.BDPTableVersionLinkDataD(RowID)),3)		//版本号
		if ((TableName=tablename)&&(Version=version))
		{
			s flag=1
		}
	}
	q flag
}

}
