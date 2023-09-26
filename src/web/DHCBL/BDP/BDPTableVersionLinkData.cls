/// 版本号关联数据表，包括增删改查等功能
/// User.BDPTableVersionLinkData
/// 基础数据平台-李可凡
/// 2019年12月19日
Class web.DHCBL.BDP.BDPTableVersionLinkData Extends %RegisteredObject
{

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年12月19日
/// Description：遍历版本号关联数据表
/// Table：User.BDPTableVersionLinkData
/// d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTableVersionLinkData","GetList","","","","")
Query GetList(rowid As %String, tabledr As %String, versiondr As %String, dataid As %String) As %Query(ROWSPEC = "RowID,TableName,Version,DataId")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, tabledr As %String, versiondr As %String, dataid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	if (rowid'="")
 	{
	 	s RowID=rowid
	 	s TableName=$lg($g(^User.BDPTableVersionLinkDataD(RowID)),2)	//表名
	 	s Version=$lg($g(^User.BDPTableVersionLinkDataD(RowID)),3)		//版本号
	 	s DataId=$lg($g(^User.BDPTableVersionLinkDataD(RowID)),4)		//关联数据id
	 	s TableName=##class(web.DHCBL.BDP.BDPTableVersion).GetTableWithDesc(TableName)		//调用同时取表名和描述的接口
	 	d OutputRow
	 }
	 else
	 {
		s table=""
		s:tabledr'="" table=$lg($g(^User.BDPTableListD(tabledr)),8)		//入参表名
		s version=""
		s:versiondr'="" version=$lg($g(^User.BDPTableVersionD(versiondr)),3)		//入参版本号
	 	s RowID=0
	 	for
	 	{
		 	s RowID=$O(^User.BDPTableVersionLinkDataD(RowID)) q:RowID=""
		 	s TableName=$lg($g(^User.BDPTableVersionLinkDataD(RowID)),2)	//表名
		 	s Version=$lg($g(^User.BDPTableVersionLinkDataD(RowID)),3)		//版本号
		 	s DataId=$lg($g(^User.BDPTableVersionLinkDataD(RowID)),4)		//关联数据id
		 	s TableName=##class(web.DHCBL.BDP.BDPTableVersion).GetTableWithDesc(TableName)		//调用同时取表名和描述的接口
		 	if ($ZCONVERT(TableName,"U")[$ZCONVERT(table,"U"))&&($ZCONVERT(Version,"U")[$ZCONVERT(version,"U"))&&(DataId[dataid)
		 	{
				d OutputRow
			}
		}
	 }
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(RowID,TableName,Version,DataId)
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年12月19日
/// Description：查询版本号关联数据表
/// Table：User.BDPTableVersionLinkData
/// Input：id
/// Others：w ##class(web.DHCBL.BDP.BDPTableVersionLinkData).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	 s str=""
	 s obj = ##class(User.BDPTableVersionLinkData).%OpenId(id)
	 s eobj = ##class(web.Entity.BDP.BDPTableVersionLinkData).%New()
	 s eobj.RowID = id					//RowID
	 s eobj.TableName=obj.TableName		//表名
	 s eobj.Version=obj.Version			//版本号
	 s eobj.DataId=obj.DataId			//关联数据id
	 s eobj.Version=$o(^User.BDPTableVersionI("UniqueTableNameVersionIndex"," "_$ZCONVERT(eobj.TableName,"U")," "_$ZCONVERT(eobj.Version,"U"),0))		//版本定义表RowID
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

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年12月19日
/// Description：删除版本号关联数据表
/// Table：User.BDPTableVersionLinkData
/// Input：id
/// Others：w ##class(web.DHCBL.BDP.BDPTableVersionLinkData).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result=""
	if (id'="")
	{
		
		s pobj = ##class(User.BDPTableVersionLinkData).%OpenId(id)
		s eobj = ##class(web.Entity.BDP.BDPTableVersionLinkData).%New()
		s eobj.RowID = id
		S eobj.TableName=pobj.TableName
		s eobj.Version= pobj.Version
		s eobj.DataId=pobj.DataId
		TSTART
		s sc=##class(User.BDPTableVersionLinkData).%DeleteId(id)
		if (sc=1)
		{
			TCOMMIT
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_TableVersionLinkData","User.BDPTableVersionLinkData","版本号关联数据",id,eobj.Version,"D",eobj)
		}
		else
		{
			TROLLBACK
			s result="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	else
	{
		s result="{success:'false',info:'数据不存在！'}"
	}
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年12月19日
/// Description：保存版本号关联数据表
/// Table：User.BDPTableVersionLinkData
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPTableVersionLinkData) As %String
{
	if (eobj.Version'="")
	{
		s eobj.TableName=$lg($g(^User.BDPTableVersionD(eobj.Version)),2)		//表名
		s eobj.Version=$lg($g(^User.BDPTableVersionD(eobj.Version)),3)		//版本号
	}
	
	s result=""
	if (eobj.RowID="")
	{
		s obj=##class(User.BDPTableVersionLinkData).%New()
	}
	else
	{
		s obj=##class(User.BDPTableVersionLinkData).%OpenId(eobj.RowID)
		s bobj=##class(web.Entity.BDP.BDPTableVersionLinkData).%New()
	    s bobj.RowID=eobj.RowID
	    s bobj.TableName = obj.TableName
	    s bobj.Version= obj.Version
	    s bobj.DataId = obj.DataId
	}
	if (obj)
	{
		s obj.TableName=eobj.TableName
		s obj.Version=eobj.Version
		s obj.DataId=eobj.DataId
		TSTART
		s sc=obj.%Save()
		if (sc=1)
		{
			TCOMMIT
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.RowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_TableVersionLinkData","User.BDPTableVersionLinkData","版本号关联数据",eobj.RowID,eobj.Version,"U",eobj,bobj)
    		d:eobj.RowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_TableVersionLinkData","User.BDPTableVersionLinkData","版本号关联数据",id,eobj.Version,"A",eobj)
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

/// function：新增关联数据，提供给关联版本按钮
/// Input: 版本定义DR，关联数据RowID
/// debug：w ##class(web.DHCBL.BDP.BDPTableVersionLinkData).SaveData("","")
ClassMethod SaveData(tableversiondr As %String, dataid As %String)
{
	s eobj=##class(web.Entity.BDP.BDPTableVersionLinkData).%New()
	s eobj.Version=tableversiondr
	s eobj.DataId=dataid
	s result=..SaveEntity(eobj)
	q result
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年12月19日
/// Description：版本号关联数据表数据校验，三个字段共同确定数据唯一
/// Table：User.BDPTableVersionLinkData
/// Input：表名table，版本号version，关联数据dataid
/// Output：1：重复		0：不重复
/// Others：w ##class(web.DHCBL.BDP.BDPTableVersionLinkData).FormValidate("","7","1")
ClassMethod FormValidate(id As %String, tableversiondr As %String, dataid As %String) As %String
{
	s flag=0
	if (tableversiondr'="")&&(dataid'="")
	{
		s TableName=$lg($g(^User.BDPTableVersionD(tableversiondr)),2)	//表名
		s Version=$lg($g(^User.BDPTableVersionD(tableversiondr)),3)		//版本号
		s RowID=$o(^User.BDPTableVersionLinkDataI("UniqueTableNameVersionIndex"," "_$ZCONVERT(TableName,"U")," "_$ZCONVERT(Version,"U")," "_dataid,0))
		s:((RowID'="")&&(RowID'=id)) flag=1
	}
	q flag
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年12月19日
/// Description：根据关联数据id和表名返回对应的版本号
/// Table：User.BDPTableVersionLinkData
/// Input：关联数据dataid，表名table
/// Output：版本号version
/// Others：w ##class(web.DHCBL.BDP.BDPTableVersionLinkData).GetDataVersion("DHC_Student","1")
ClassMethod GetDataVersion(table As %String, dataid As %String) As %String
{
	q:((table="")||(dataid="")) "表名和关联数据不能为空"
	s RowID=$o(^User.BDPTableVersionLinkDataI("TableNameIndex",table,dataid,0))
	q:RowID="" "该条数据没有维护版本号"
	s Version=$lg($g(^User.BDPTableVersionLinkDataD(RowID)),3)		//版本号
	q Version
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2020年2月26日
/// Description：根据表名获取启用的版本号,同时查询某条数据是否关联这些版本。提供给云HIS'关联版本'封装按钮的查询方法
/// input: tablename(表名),dataid(数据RowId)
/// output: VersionID(版本定义表的RowID)，Version(版本号)，LinkID(版本关联数据表的RowID)，LinkFlag(该条数据是否关联版本)
/// d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPTableVersionLinkData","GetVersionForCloud","MRC_ICDDx","1")
Query GetVersionForCloud(tablename As %String, dataid As %String) As %Query(ROWSPEC = "VersionID,Version,LinkID,LinkFlag")
{
}

ClassMethod GetVersionForCloudExecute(ByRef qHandle As %Binary, tablename As %String, dataid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
 	
	//循环版本定义表的数据
	s VersionID=0
 	for
 	{
	 	s VersionID=$O(^User.BDPTableVersionD(VersionID)) q:VersionID=""
	 	s TableName=$lg($g(^User.BDPTableVersionD(VersionID)),2)	//表名
	 	s Version=$lg($g(^User.BDPTableVersionD(VersionID)),3)		//版本号
	 	s ActiveFlag=$lg($g(^User.BDPTableVersionD(VersionID)),4)	//激活标识
	 	s LinkID=$o(^User.BDPTableVersionLinkDataI("UniqueTableNameVersionIndex"," "_$ZCONVERT(TableName,"U")," "_$ZCONVERT(Version,"U")," "_dataid,0))
	 	s LinkFlag="N"
	 	s:LinkID'="" LinkFlag="Y"
	 	if ((TableName=tablename)&&(ActiveFlag'="N"))
	 	{
			d OutputForCloud
		}
	}
	
	
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputForCloud
	set Data=$lb(VersionID,Version,LinkID,LinkFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetVersionForCloudFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVersionForCloudExecute ]
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

ClassMethod GetVersionForCloudClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVersionForCloudExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：基础数据平台-李可凡
/// CreatDate: 2019年12月27日
/// Description：批量保存版本号和数据关联
/// Table：User.BDPTableVersionLinkData
/// Input：关联数据dataid，版本号rowid加Flag串(7$Y^9$N^14$N)
/// Output：版本号version
/// Others：w ##class(web.DHCBL.BDP.BDPTableVersionLinkData).UpdateVersion("1","7$Y^9$Y^14$N")
ClassMethod UpdateVersion(dataid As %String, VersionIDs As %String) As %String
{
    q:((dataid="")||(VersionIDs="")) ""
    s result=""
    for i=1:1:$l(VersionIDs,"^")
	{
    	s str=$p(VersionIDs,"^",i)
    	s VersionID=$p(str,"$",1)
    	continue:VersionID=""
    	s LinkFlag=$p(str,"$",2)
    	if LinkFlag="Y"
    	{
	    	s flag=..FormValidate("",VersionID,dataid)
	    	s:flag=0 re=..SaveData(VersionID,dataid)
    	}
    	if LinkFlag="N"
    	{
	    	s TableName=$lg($g(^User.BDPTableVersionD(VersionID)),2)	//表名
			s Version=$lg($g(^User.BDPTableVersionD(VersionID)),3)		//版本号
	    	s id=$o(^User.BDPTableVersionLinkDataI("UniqueTableNameVersionIndex"," "_$ZCONVERT(TableName,"U")," "_$ZCONVERT(Version,"U")," "_dataid,0))
	    	s:id'="" re=..DeleteData(id)
    	}
    	if (re["success:'false'")
    	{
	    	s re=VersionID_re
	    	s result=result_re
	    }
	    else
	    {
		    s result=1
		}
	}
	q result
}

}
