/// 名称:通过表名查询Global	
/// 描述:
/// 编写者:基础数据平台组 - 陈莹 
/// 编写日期: 2014-8-11
Class web.DHCBL.BDP.FindTableStructure Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2014-8-14
/// Description:判断类是否存在
/// Input:包名,类名
/// Return:存在1,不存在0
/// Other:w ##class(web.DHCBL.BDP.FindTableStructure).ClassExistOrNot("User.CTLoc")	
ClassMethod ClassExistOrNot(classAllName As %String)
{
	n (classAllName)
	q:(classAllName="") 0
	s myrtn=0
	set ClassObj = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
	i ($IsObject(ClassObj)){
		s myrtn = 1
	}	
	q myrtn
}

/// Creator:陈莹
/// CreatDate:2014-8-18
/// Description:判断表内某字段是否存在
/// Input:包名,类名,字段名
/// Return: 存在1,不存在0
/// w ##class(web.DHCBL.BDP.FindTableStructure).PropertyExistOrNot("User.BDPMenu","LinkUrl")
ClassMethod PropertyExistOrNot(classAllName As %String, Property As %String)
{
	n (classAllName,Property)
	q:(classAllName="")||(Property="") 0
	s myrtn=0
	set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId(classAllName_"||"_Property,0)
	i ($IsObject(PropObj)){
		s myrtn = 1
	}
	q myrtn
}

/// Creator:陈莹
/// CreatDate:2014-8-11
/// Description:%CacheSQLStorage，得到主索引或索引的subString
/// Input:subScripts
/// Return:subString:   (0,"BillDate",{PBDO_BillDate},{PBDO_RowId})
/// Other:w ##class(web.DHCBL.BDP.FindTableStructure).getIndexSubStr("")  
/// QUERY SelectMaster %CacheSQLStorage 查询表的结构(Index及data)里用到
ClassMethod getIndexSubStr(subScripts)
{
	n (subScripts)
	s subString=""
	s subCnt=subScripts.Count(),subString="("
	for k=1:1:subCnt {
		set subScript=subScripts.GetAt(k)	
		set expr=subScript.Expression
		set subString=subString_""_expr_","
	}
	set $e(subString,$l(subString))=""   //去掉最后的逗号
	s subString=subString_")"
	q subString
}

/// Creator:陈莹
/// CreatDate:2014-8-11
/// Description:查询表的结构(Index及data)
/// Input:包名,类名
/// Return:type:索引类型,indexName:索引名,indexMasterData:索引结构
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.FindTableStructure","SelectMaster","User","BDPExecutables")  //BDPExecutables父表  BDPExtExecItem
Query SelectMaster(packageName As %String, className As %String) As %Query(ROWSPEC = "type:%String,indexName:%String,indexMasterData:%String")
{
}

ClassMethod SelectMasterExecute(ByRef qHandle As %Binary, packageName As %String, className As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
    Set ind=1	
    
    if packageName="" s packageName ="User"  //默认User
    
	set classAllName=packageName_"."_className
	set ClassObj = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
	if $IsObject(ClassObj)
	{
		set dsd=ClassObj.Storages
		set dsdCount=dsd.Count()
		s storage = dsd.GetAt(1)
		s storageType = storage.Type
		if storageType = "%Library.CacheStorage"
		{
			s storageIndexLocation=storage.IndexLocation
			s storageDataLocation=storage.DataLocation
			s storageDatas = storage.Data	   ///%Library.CacheStorage
			s storageDatasCount = storageDatas.Count()
			for y=1:1:storageDatasCount //2，子表BDPExtExecItem
			{
				s storageData=storageDatas.GetAt(y)
				s storageDataValue=storageData.Values
				s storageDataValueCount=storageDataValue.Count()
				s type="Data"	
				s indexName=storageData.Name
				s storageStructure=storageData.Structure
				if storageStructure="node"   //子表Data:BDPExtExecItemClassName:{%%PARENT}("ChildExtExecItem")(ID,0)=%%CLASSNAME
				{
					s indexMasterData=storage.DataLocation_"(ID,0)="_storageData.Attribute
				}
				else   //listnode
				{
					s indexSub=""
					for x=1:1:storageDataValueCount
					{
						if indexSub'="" s indexSub=indexSub_","_storageDataValue.GetAt(x).Value
						else  s indexSub=storageDataValue.GetAt(x).Value
					}
					s indexMasterData=storage.DataLocation_"(ID)=$LB("_indexSub_")"
				}
				d OutputRowMaster
			}
			;%Library.CacheStorage
			s indexDefinitions = ClassObj.Indices
			s indicesCount = indexDefinitions.Count()
			for i=1:1:indicesCount
			{
				s indexDefinition = indexDefinitions.GetAt(i)
				s type="Index"
				s indexName=indexDefinition.Name
				s indexMasterData = storageIndexLocation_"("""_indexName_""","_indexDefinition.Properties_",ID)"
				d OutputRowMaster
			}
		
		}
		elseif (storageType["CacheSQLStorage")   //%CacheSQLStorage /%Library.CacheSQLStorage
		{
			s sqlMapsID = storage.SQLMaps
			s sqlMapsCount=sqlMapsID.Count()
			for i=1:1:sqlMapsCount
			{
				set sqlMapID=sqlMapsID.GetAt(i)
				set type=sqlMapID.Type
				set indexName=sqlMapID.Name
				set indexSub=..getIndexSubStr(sqlMapID.Subscripts)
				set indexMasterData=sqlMapID.Global_indexSub
				d OutputRowMaster
			}
		}
		
		
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowMaster
	set Data=$lb($g(type),$g(indexName),$g(indexMasterData))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SelectMasterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectMasterExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectMasterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectMasterExecute ]
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

/// Creator: 陈莹
/// CreatDate: 2014-8-18
/// Description: 查询一个表的子表名称,用^分隔
/// Input: 包名,类名
/// Return: childNameStr,子表名称,用^分隔
/// w ##class(web.Util.DHCJFClassGlobal).SelectChild("User","BDPExecutables")--->BDPExtExecItem
/// Creator:陈莹
/// CreatDate:2014-8-18
/// Description:查询一个子表的父表名称
/// Input:包名,类名
/// Return:parentClass,父表名称
/// w ##class(web.Util.DHCJFClassGlobal).SelectParent("User","BDPExtExecItem") -->BDPExecutables
/// Creator:陈莹
/// CreatDate:2014-8-11  
/// Description:查询主map名
/// Input:包名,类名
/// Return: 主map名
/// Other:w ##class(web.DHCBL.BDP.FindTableStructure).getMasterIndexName("User","CTLoc")
/// w ##class(web.DHCBL.BDP.FindTableStructure).getMasterIndexName("User","BDPExtExecItem")
/// QUERY SelectProperty  查询表的字段时用到
ClassMethod getMasterIndexName(packageName As %String, className As %String) As %String
{
	n (className,packageName)
	s masterIndexName=""
	
	set classAllName=packageName_"."_className
	set ClassObj = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
	set dsd=ClassObj.Storages
	set dsdCount=dsd.Count()
	for j=1:1:dsdCount {
		s storage = dsd.GetAt(j)
		s storageType = storage.Type
		if storageType="%Library.CacheStorage"
		{
			s storageDatas = storage.Data	
			s storageDatasCount = storageDatas.Count()
			for y=1:1:storageDatasCount 
			{	
				s storageData=storageDatas.GetAt(y)
				//s storageDataValue=storageData.Values
				//s storageDataValueCount=storageDataValue.Count()
				//s type="data"		
				s storageStructure=storageData.Structure
				if storageStructure="listnode" 
				{
					s indexName=storageData.Name
					s masterIndexName=indexName	
				}
			}
		}
		elseif (storageType["CacheSQLStorage")   //%CacheSQLStorage /%Library.CacheSQLStorage
		{	
			s sqlMapsID=dsd.GetAt(j).SQLMaps
			s sqlMapsCount=sqlMapsID.Count()
			for i=1:1:sqlMapsCount {
				set sqlMapID=sqlMapsID.GetAt(i)
				set type=sqlMapID.Type
				if type="data" 
				{
					set indexName=sqlMapID.Name
					s masterIndexName=indexName
					//set indexSub=..getIndexSubStr(sqlMapID.Subscripts)
					//set indexMasterData=sqlMapID.Global_indexSub	
				}
			}
		}	
	}
	q masterIndexName
}

/// Creator:陈莹
/// CreatDate:2014-8-11  update @20170808
/// Description:%CacheSQLStorage,查询主map里的字段名称,所在位置,分隔符,类型等信息
/// Input:包名,类名
/// Return: propertyName,propertyNode,propertyDeli,propertyPiece,propertyType,propertyField,propertyColumn
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.FindTableStructure","SelectProperty","User","CTLoc")
Query SelectProperty(packageName As %String, className As %String) As %Query(ROWSPEC = "propertyName:%String,propertyNode:%String,propertyDeli:%String,propertyPiece:%String,propertyType:%String,propertyField:%String,propertyColumn:%String")
{
}

ClassMethod SelectPropertyExecute(ByRef qHandle As %Binary, packageName As %String, className As %String) As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    
    if packageName="" s packageName ="User"  //默认User
    
	i (packageName'="")&&(className'="") 
	{
		s classAllName=packageName_"."_className
		set ClassObj = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
		Set rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
		do rsltSt.Execute(classAllName)
		While(rsltSt.Next()) {
			s (propertyName,propertyNode,propertyDeli,propertyPiece,propertyType,propertyField,propertyColumn)=""
			set propertyName=rsltSt.Data("Name")  //"CTLOCActiveFlag"
			set propertyId=classAllName_"||"_propertyName 
			set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId,0)
			if (PropObj.Cardinality'="children")
			{
				set propertyType=PropObj.Type 
				set propertyField=PropObj.SqlFieldName
				set propertyColumn=PropObj.SqlColumnNumber
				s masterIndexName=..getMasterIndexName(packageName,className)
				set SQLMapDataObj=##class(%Dictionary.StorageSQLMapDataDefinition).%OpenId(classAllName_"||"_ClassObj.StorageStrategy_"||"_masterIndexName_"||"_PropObj.SqlFieldName,0)
				if (SQLMapDataObj'="") {   
					set propertyNode=SQLMapDataObj.Node
					set propertyDeli=SQLMapDataObj.Delimiter
					set propertyPiece=SQLMapDataObj.Piece
					d OutputRowProperty
				}
				else  ////%Library.CacheStorage
				{
					s masterIndexName=$p(..getMasterNameAndData(packageName_"."_className) ,"&",1)
					s indexMasterData= $p(..getMasterNameAndData(packageName_"."_className) ,"&",2)
					S MasterData=$p(indexMasterData,"=",1)
					S MasterDataInfo=$p(indexMasterData,"=",2)
					s propertyPiece=$l($p(MasterDataInfo,propertyName,1),",")	
					d OutputRowProperty			
				}
				
			}
		}
	}
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowProperty
	set Data=$lb(propertyName,propertyNode,propertyDeli,propertyPiece,propertyType,propertyField,propertyColumn)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
}

ClassMethod SelectPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPropertyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SelectPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPropertyExecute ]
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

/// Creator:陈莹
/// CreatDate:2014-8-13 update 20170808
/// Description:基础数据授权里引用 rowid,子表不行,$o({%%PARENT}("ChildExtExecItem")(11))
/// Input:包名,类名
/// Return: s rowid=$o(^APC("APCVC",XROWID))
/// w ##class(web.DHCBL.BDP.FindTableStructure).GetGlobalRowId("User.BDPExtExecItem")
/// w ##class(web.DHCBL.BDP.FindTableStructure).GetGlobalRowId("User.CTReligion")
/// w ##class(web.DHCBL.BDP.FindTableStructure).GetGlobalRowId("User.MBDPProductLine")
ClassMethod GetGlobalRowId(classAllName As %String)
{
	n (classAllName)
	s str=""
	set masterIndexName=""
	set ClassObj = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
	set dsd=ClassObj.Storages
	set dsdCount=dsd.Count()
	s storage = dsd.GetAt(1)
	s storageType =storage.Type
	
	if storageType="%Library.CacheStorage"
	{
		s storageDataLocation=storage.DataLocation
		s storageDatas = storage.Data	  //
		s storageDatasCount = storageDatas.Count()
		for y=1:1:storageDatasCount 
		{	
			s storageData=storageDatas.GetAt(y)
			if (storageData.Structure="listnode")
			{
				
				s str="s rowid=$o("_storage.DataLocation_"(XROWID)"_")"
				q
				//s storageDataValue=storageData.Values
				//s storageDataValueCount=storageDataValue.Count()
			}
		}
		
	}
	elseif (storageType["CacheSQLStorage")   //%CacheSQLStorage /%Library.CacheSQLStorage
	{
		s sqlMapsID=storage.SQLMaps
		s sqlMapsCount=sqlMapsID.Count()
		for i=1:1:sqlMapsCount 
		{
			set sqlMapID=sqlMapsID.GetAt(i)
			set type=sqlMapID.Type  // set indexName=sqlMapID.Name
			if type="data" 
			{
				set indexSub=..getIndexSubStr(sqlMapID.Subscripts)  ///("RLG",{CTRLG_RowId})
				set indexMasterData=sqlMapID.Global_indexSub   //^CT("RLG",{CTRLG_RowId})
				s str="s rowid=$o("_$p(indexMasterData,"{",1)_"XROWID"_$p(indexMasterData,"}",2)_")"
				q
				
			}
		}
	}
	q str
}

/// Creator:陈莹
/// CreatDate:2014-8-13
/// Description:根据类名称获取类里的字段
/// Input:包名.类名
/// Return: 字段1^字段2^字段3
/// w ##class(web.DHCBL.BDP.FindTableStructure).GetTableProperty("User.BDPMenu")
/// w ##class(web.DHCBL.BDP.FindTableStructure).GetTableProperty("User.CTLoc")
ClassMethod GetTableProperty(classAllName As %String)
{
	n (classAllName)
	s str=""
	i (classAllName'="")
	{
		Set rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")  //1@%Library.ResultSet
		do rsltSt.Execute(classAllName)
		While(rsltSt.Next()) {
			set propertyName=rsltSt.Data("Name")
			if str="" s str=propertyName
			if str'="" s str=str_"^"_propertyName
		}	
	}
	q str
}

/// Creator:陈莹
/// CreatDate:2014-8-13
/// Description:根据包名和类名,获取主MAP名和主Map数据
/// Input:包名.类名
/// Return: masterIndexName_"&"_indexMasterData
/// w ##class(web.DHCBL.BDP.FindTableStructure).getMasterNameAndData("User.BDPMenu")
/// w ##class(web.DHCBL.BDP.FindTableStructure).getMasterNameAndData("User.CTLoc")
ClassMethod getMasterNameAndData(classAllName As %String)
{
	n (classAllName)
	s masterIndexName="",indexMasterData=""
	set ClassObj = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
	set dsd=ClassObj.Storages
	set dsdCount=dsd.Count()

	s storage = dsd.GetAt(1)
	s storageType = storage.Type
	if storageType="%Library.CacheStorage"
	{
		s storageDataLocation=storage.DataLocation
		s storageDatas = storage.Data	  //
		s storageDatasCount = storageDatas.Count()
		for y=1:1:storageDatasCount 
		{	
			s storageData=storageDatas.GetAt(y)
			s storageDataValue=storageData.Values
			s storageDataValueCount=storageDataValue.Count()
			s masterIndexName=storageData.Name
			
			s storageStructure=storageData.Structure  //node/listnode
			s storageDataAttribute=storageData.Attribute  //"%%CLASSNAME"
			if storageStructure="listnode"
			{
				s indexSub=""
				for x=1:1:storageDataValueCount
				{
					if indexSub'="" s indexSub=indexSub_","_storageDataValue.GetAt(x).Value
					else  s indexSub=storageDataValue.GetAt(x).Value
				}
				s indexMasterData=storage.DataLocation_"(ID)=$LB("_indexSub_")"
				q
			}
		}
		
	}
	elseif (storageType["CacheSQLStorage")   //%CacheSQLStorage /%Library.CacheSQLStorage
	{
		s sqlMapsID=dsd.GetAt(1).SQLMaps	
		s sqlMapsCount=sqlMapsID.Count()
		for i=1:1:sqlMapsCount {
			set sqlMapID=sqlMapsID.GetAt(i)
			set type=sqlMapID.Type
			set indexName=sqlMapID.Name
			i type="data" 
			{
				s masterIndexName=indexName
				set indexSub=..getIndexSubStr(sqlMapID.Subscripts)
				set indexMasterData=sqlMapID.Global_indexSub
				q
			}
		}
	}
	q masterIndexName_"&"_indexMasterData
}

/// Creator:陈莹
/// CreatDate:2014-8-13  update@20170808
/// Description:基础数据授权里引用 desc
/// Input:包名,类名,基础数据授权里要显示的字段名
/// Return: s desc=$p($g(^CT("COU",XROWID)),"^",2)
/// w ##class(web.DHCBL.BDP.FindTableStructure).GetProperty("User.BDPExecutables","PropertyName")
/// w ##class(web.DHCBL.BDP.FindTableStructure).GetProperty("User.CTReligion","CTRLGDesc")
/// w ##class(web.DHCBL.BDP.FindTableStructure).GetProperty("User.MBDPProductLine","MBDPPROLDesc")
/// web.DHCBL.BDP.BDPPreferences,web.DHCBL.BDP.Authorize
ClassMethod GetProperty(classAllName As %String, Property As %String) As %String
{
	n (classAllName,Property)
	s str=""
	Q:(classAllName="") "类名称不可为空!"
	Q:(Property="") "字段名称不可为空!"
	
	s str=""
	set ClassObj = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
	set dsd=ClassObj.Storages
	set dsdCount=dsd.Count()
	s storage = dsd.GetAt(1)
	s storageType =storage.Type
	
	if storageType["CacheStorage"
	{
		s storageDataLocation=storage.DataLocation
		s storageDatas = storage.Data
		s storageDatasCount = storageDatas.Count()
		for y=1:1:storageDatasCount 
		{	
			s storageData=storageDatas.GetAt(y)
			s storageStructure=storageData.Structure  //node/listnode
			s storageDataAttribute=storageData.Attribute  //"%%CLASSNAME"
			s storageDataValue=storageData.Values
			s masterIndexName=storageData.Name
			s storageDataValueCount=storageDataValue.Count()
				
			
			if (storageData.Structure="listnode")
			{
				//s str="s rowid=$o("_storage.DataLocation_"(XROWID)"_")"
				
				//s storageDataValue=storageData.Values
				//s storageDataValueCount=storageDataValue.Count()
				
				s indexSub=""
				s propertyPiece=1
				for x=1:1:storageDataValueCount
				{
					if indexSub'="" s indexSub=indexSub_","_storageDataValue.GetAt(x).Value
					else  s indexSub=storageDataValue.GetAt(x).Value
					if storageDataValue.GetAt(x).Value=Property s propertyPiece=x
				}
				
				s indexMasterData=storage.DataLocation_"(XROWID)=$LB("_indexSub_")"
				
				//^User.BDPMenuD(XROWID)=$LB(%%CLASSNAME,Code,Caption,LinkFuntionDR,LinkUrl,Image,Method,Sequence,ShortcutKey,ShowInNewWindow,ParentMenuDr,UpdateDate,UpdateTime,UpdateUser,ValueExpression,ActiveFlag)
				s MasterData=storage.DataLocation_"(XROWID)"

				s str="s desc=$LISTGET($g("_MasterData_"),"_propertyPiece_")"
	
				q
				
			}
		}
		
	}
	elseif (storageType["CacheSQLStorage")   //%CacheSQLStorage /%Library.CacheSQLStorage
	{
		s sqlMapsID=storage.SQLMaps
		s sqlMapsCount=sqlMapsID.Count()
		for i=1:1:sqlMapsCount 
		{
			set sqlMapID=sqlMapsID.GetAt(i)
			set type=sqlMapID.Type  // set indexName=sqlMapID.Name
			if type="data" 
			{
				s masterIndexName=sqlMapID.Name
				set indexSub=..getIndexSubStr(sqlMapID.Subscripts)  ///("RLG",{CTRLG_RowId})
				set indexMasterData=sqlMapID.Global_indexSub   //^CT("RLG",{CTRLG_RowId})
				//s str="s rowid=$o("_$p(indexMasterData,"{",1)_"XROWID"_$p(indexMasterData,"}",2)_")"
				s ClassObj=##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
				set propertyId=classAllName_"||"_Property 
				set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId,0)
				i ($IsObject(PropObj))
				{
					set propertyType=PropObj.Type   //%String
					//BDPMenuDefaultData&^User.BDPMenuD(ID)=$LB(%%CLASSNAME,Code,Caption,LinkFuntionDR,LinkUrl,Image,Method,Sequence,ShortcutKey,ShowInNewWindow,ParentMenuDr,UpdateDate,UpdateTime,UpdateUser,ValueExpression,ActiveFlag,CompName,ProductLineDr)
					//DataMasterCTLOC&^CTLOC({CTLOC_RowID})	
					
					//	"User.CTLoc||SQLStorage||DataMasterCTLOC||CTLOC_DifferentSexPatients"
					set SQLMapDataObj=##class(%Dictionary.StorageSQLMapDataDefinition).%OpenId(classAllName_"||"_ClassObj.StorageStrategy_"||"_masterIndexName_"||"_PropObj.SqlFieldName,0) //3、4@%Dictionary.StorageSQLMapDataDefinition
					i ($IsObject(SQLMapDataObj))
					{
						set propertyNode=SQLMapDataObj.Node
						set propertyDeli=SQLMapDataObj.Delimiter
						set propertyPiece=SQLMapDataObj.Piece
						if (propertyNode)
						{
							//indexMasterData="^CT("RLG",{CTRLG_RowId})"
							s str="s desc=$p($g("_$p(indexMasterData,"{",1)_"XROWID"_","_propertyNode_")),""^"""_","_propertyPiece_")"	
						}
						else
						{
							s str="s desc=$p($g("_$p(indexMasterData,"{",1)_"XROWID"_")),""^"""_","_propertyPiece_")"
						}
						q
					}
					
				}
			}
		}
	}

	q str
}

/// Creator:陈莹
/// CreatDate:2015-12-18
/// Description:基础数据授权里引用 desc
/// Input:包名.类名,基础数据授权里要显示的字段名
/// Return: 字段所在节点位置
/// w ##class(web.DHCBL.BDP.FindTableStructure).GetPropertyPiece("User.BDPExecutables","PropertyName")
/// w ##class(web.DHCBL.BDP.FindTableStructure).GetPropertyPiece("User.CTReligion","CTRLGDesc")
/// w ##class(web.DHCBL.BDP.FindTableStructure).GetPropertyPiece("User.MBDPProductLine","MBDPPROLDesc")
/// web.DHCBL.BDP.BDPPreferences,web.DHCBL.BDP.Authorize
ClassMethod GetPropertyPiece(classAllName As %String, Property As %String) As %String
{
	n (classAllName,Property)
	Q:(classAllName="") ""
	Q:(Property="") ""
	s propertyPiece=""
	set ClassObj = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
	i ($IsObject(ClassObj))
	{
		set dsd=ClassObj.Storages
		set dsdCount=dsd.Count()
		s storage = dsd.GetAt(1)
		s storageType =storage.Type
		if storageType="%Library.CacheStorage"
		{
			s storageDataLocation=storage.DataLocation
			s storageDatas = storage.Data
			s storageDatasCount = storageDatas.Count()
			for y=1:1:storageDatasCount 
			{	
				s storageData=storageDatas.GetAt(y)
				s storageStructure=storageData.Structure  //node/listnode
				s storageDataAttribute=storageData.Attribute  //"%%CLASSNAME"
				s storageDataValue=storageData.Values
				s masterIndexName=storageData.Name
				s storageDataValueCount=storageDataValue.Count()
				if (storageData.Structure="listnode")
				{
					//s str="s rowid=$o("_storage.DataLocation_"(XROWID)"_")"
				
					//s storageDataValue=storageData.Values
					//s storageDataValueCount=storageDataValue.Count()
				
					s indexSub=""
					s propertyPiece=1
					for x=1:1:storageDataValueCount
					{
						if indexSub'="" s indexSub=indexSub_","_storageDataValue.GetAt(x).Value
						else  s indexSub=storageDataValue.GetAt(x).Value
						
						if storageDataValue.GetAt(x).Value=Property s propertyPiece=x
					}
					///s indexMasterData=storage.DataLocation_"(XROWID)=$LB("_indexSub_")"
				
					//^User.BDPMenuD(XROWID)=$LB(%%CLASSNAME,Code,Caption,LinkFuntionDR,LinkUrl,Image,Method,Sequence,ShortcutKey,ShowInNewWindow,ParentMenuDr,UpdateDate,UpdateTime,UpdateUser,ValueExpression,ActiveFlag)
					///s MasterData=storage.DataLocation_"(XROWID)"

					///s str="s desc=$LISTGET($g("_MasterData_"),"_propertyPiece_")"
	
					q
				
				}
			}
		
		}
		elseif (storageType["CacheSQLStorage")   //%CacheSQLStorage /%Library.CacheSQLStorage
		{
			s sqlMapsID=storage.SQLMaps
			s sqlMapsCount=sqlMapsID.Count()
			for i=1:1:sqlMapsCount 
			{
				set sqlMapID=sqlMapsID.GetAt(i)
				set type=sqlMapID.Type  // set indexName=sqlMapID.Name
				if type="data" 
				{
					s masterIndexName=sqlMapID.Name
					set indexSub=..getIndexSubStr(sqlMapID.Subscripts)  ///("RLG",{CTRLG_RowId})
					set indexMasterData=sqlMapID.Global_indexSub   //^CT("RLG",{CTRLG_RowId})
					//s str="s rowid=$o("_$p(indexMasterData,"{",1)_"XROWID"_$p(indexMasterData,"}",2)_")"
					s ClassObj=##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
					set propertyId=classAllName_"||"_Property 
					set PropObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId,0)
					i ($IsObject(PropObj))
					{
						set propertyType=PropObj.Type   //%String
						//BDPMenuDefaultData&^User.BDPMenuD(ID)=$LB(%%CLASSNAME,Code,Caption,LinkFuntionDR,LinkUrl,Image,Method,Sequence,ShortcutKey,ShowInNewWindow,ParentMenuDr,UpdateDate,UpdateTime,UpdateUser,ValueExpression,ActiveFlag,CompName,ProductLineDr)
						//DataMasterCTLOC&^CTLOC({CTLOC_RowID})	
						//	"User.CTLoc||SQLStorage||DataMasterCTLOC||CTLOC_Desc"
						set SQLMapDataObj=##class(%Dictionary.StorageSQLMapDataDefinition).%OpenId(classAllName_"||"_ClassObj.StorageStrategy_"||"_masterIndexName_"||"_PropObj.SqlFieldName,0) //3、4@%Dictionary.StorageSQLMapDataDefinition
						i ($IsObject(SQLMapDataObj))
						{
							set propertyNode=SQLMapDataObj.Node
							set propertyDeli=SQLMapDataObj.Delimiter
							set propertyPiece=SQLMapDataObj.Piece
							if (propertyNode)
							{
								s str="s desc=$p($g("_$p(indexMasterData,"{",1)_"XROWID"_","_propertyNode_")),""^"""_","_propertyPiece_")"	
							}
							else
							{
								s str="s desc=$p($g("_$p(indexMasterData,"{",1)_"XROWID"_")),""^"""_","_propertyPiece_")"
							}
							q
						}
					
					}
				}
			}
		}
	}
	
	q propertyPiece
}

}
