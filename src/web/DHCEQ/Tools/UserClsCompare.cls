/// 操作说明如下:
/// (1)获取项目旧库User类下所有DHCEQ开头且存在global数据的【实体类】,【存储和索引】,【存储详细】。
///   d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","SelectClass","User","DHCEQ","X","3")
/// (2)检测项目旧库User类下所有DHCEQ开头实体类扩展节点内容,并以TXT文件输出
///   d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","CheckUserClsEx","User","DHCEQ","N","D:\DHCEQCheckGloablEx.txt")
/// (3)导出第一步生成的临时global【^TempDHCEQUserClsInfo】和拷贝第二步扩展节点检测结果TXT文件
/// (4)升级库导入第三步导出的global
/// (5)获取升级库User类下所有DHCEQ开头且旧库存在global数据的【实体类】,【存储和索引】,【存储详细】。
///   d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","SelectClass","User","DHCEQ","S","3")
/// (6)比对项目旧库与升级库实体类存在差异,并以TXT文件输出比对结果.
///   d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","MAndICompare","D:\DHCEQMAndICompare.txt")
/// (7)拷贝第六步TXT文件中内容到EXCEL中保存方便筛选。
///   类型为字段则表示该表存在字段位置不一致或增加字段情况
///   类型为索引则表示旧库和升级库索引存在增加，修改，删除差异。
Class web.DHCEQ.Tools.UserClsCompare Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add By DJ 2017-11-16
/// 描述:获取所有表名
/// 改自:web.Util.DHCJFClassGlobal.cls下的SelectClass
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","SelectClass","User","DHCEQ","S","3")
/// 入参：packageName 表示实体类包名
/// 		 preClassName  表示Web类前缀 
/// 		 StandFlag 标准版本标志 X表示项目库 S表示标准版 
///      PrintAllFlag 输出结果标志 1:【实体类】, 2:【实体类】【存储和索引】  3:【实体类】【存储和索引】【存储详细】
Query SelectClass(packageName As %String = "", preClassName As %String = "", StandFlag As %String = "", PrintAllFlag As %String = "") As %Query(ROWSPEC = "className:%String:类名") [ SqlProc ]
{
}

/// 开始用$order有大小写的问题,处理不是很好。全循环效率差不多
ClassMethod SelectClassExecute(ByRef qHandle As %Binary, packageName As %String = "", preClassName As %String = "", StandFlag As %String = "", PrintAllFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1	
    k PLIST
    i StandFlag=$C(0) s StandFlag=""
    i PrintAllFlag=$C(0) s PrintAllFlag=""
    
	//默认获取标准版所有DHCEQ开头的实体类
	i packageName="" s packageName="User"
	i preClassName="" s preClassName="DHCEQ"
	i StandFlag="" s StandFlag="S"
	i PrintAllFlag="" s PrintAllFlag="3"	//1:【实体类】, 2:【实体类】【存储和索引】  3:【实体类】【存储和索引】【存储详细】
	K ^TempDHCEQUserClsInfo(StandFlag)
	
	I preClassName=""  Set qHandle=$lb(0,repid,0) Quit $$$OK
	;获取所有表名
	s sog=$System.OBJ.GetPackageList(.PLIST,packageName,"")
	Do:('sog) $system.Status.DisplayError(sog)
	
	s len = $l(preClassName)
	s name=""
	f  s name=$o(PLIST(name)) q:name=""  d
	.s outClassName=$p(name,packageName_".",2)
	.s preName=$e(outClassName,1,len)
	.q:($ZCVT(preName,"U")'=$ZCVT(preClassName,"U"))
	.i PrintAllFlag>=1  d
	..s ^TempDHCEQUserClsInfo(StandFlag,"Table",outClassName)=""
	..;d $SYSTEM.OBJ.Export("User."_outClassName_".cls","D:\\DHCEQ\\"_outClassName_".xml")
	.i PrintAllFlag>=2  d
	..d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","SelectMaster",packageName,outClassName,StandFlag,PrintAllFlag,"")
	.do OutputRowClass	
	k PLIST
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowClass
	set Data=$lb(outClassName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
}

ClassMethod SelectClassFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectClassExecute ]
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

ClassMethod SelectClassClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectClassExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/******************************************************************************************************/
/// Add By DJ 2017-11-16
/// 描述:获取表存储及索引
/// 改自:web.Util.DHCJFClassGlobal.cls下的SelectMaster
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","SelectMaster","User","DHCEQInStock","S","","")
/// 入参：packageName 表示实体类包名
/// 		 className  表示Web类名称
/// 		 StandFlag 标准版本标志 X表示项目库 S表示标准版 
///      PrintAllFlag 输出结果标志 2:【存储和索引】  3:【存储和索引】【存储详细】
/// 		 vType 表示存储或索引 "data"存储 "Index"索引
Query SelectMaster(packageName As %String = "", className As %String = "", StandFlag As %String = "", PrintAllFlag As %String = "", vType As %String = "") As %Query(ROWSPEC = "className:%String:表名,type:%String:索引类型,indexName:%String:索引名,indexMasterData:%String:索引结构") [ SqlProc ]
{
}

ClassMethod SelectMasterExecute(ByRef qHandle As %Binary, packageName As %String = "", className As %String = "", StandFlag As %String = "", PrintAllFlag As %String = "", vType As %String = "") As %Status
{
	
	Set repid=$I(^CacheTemp)
    If $g(indm)="" Set indm=1
    i StandFlag=$C(0) s StandFlag=""
    i PrintAllFlag=$C(0) s PrintAllFlag=""
    i vType=$C(0) s vType=""
    
    i (StandFlag'="")&&(className'="") d
    .k ^TempDHCEQUserClsInfo(StandFlag,"Table",className)
	set classAllName=packageName_"."_className
	set dcd = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
	if (dcd="")  Set qHandle=$lb(0,repid,0) Quit $$$OK
	set dsd=dcd.Storages
	set dsdCount=dsd.Count()
	s storageType="%CacheSQLStorage"
	for j=1:1:dsdCount 	d
	.s storage = dsd.GetAt(j)
	.s storageType = storage.Type	; %Dictionary.CacheClassname
	.;2011-11-18 把默认结构也查询出来
	.i storageType = "%Library.CacheStorage" d
	..s storageIndexMasterData=storage.IndexLocation
	..s storageDatas = storage.Data		;%Dictionary.StorageDataDefinition
	..s storageDatasCount = storageDatas.Count()
	..f y=1:1:storageDatasCount d
	...s storageData=storageDatas.GetAt(y)
	...s storageDataValue=storageData.Values	;%Dictionary.StorageDataValueDefinition
	...s storageDataValueCount=storageDataValue.Count()
	...s type = "data"	
	...s indexName=storageData.Name
	...s storageStructure=storageData.Structure
	...i storageStructure="node"  s indexMasterData=storage.DataLocation_"(ID,0)="_storageData.Attribute
	...e  d
	....s indexSub=""
	....for x=1:1:storageDataValueCount d
	.....i indexSub'="" s indexSub=indexSub_","_storageDataValue.GetAt(x).Value
	.....e  s indexSub=storageDataValue.GetAt(x).Value
	....s indexMasterData=storage.DataLocation_"(ID)=$LB("_indexSub_")"
	...q:(vType'="")&&($ZCONVERT(vType,"U")'=$ZCONVERT(type,"U"))
	...d OutputRowMaster
	.e  d 
	..s sqlMapsID = storage.SQLMaps
	..s sqlMapsCount=sqlMapsID.Count()
	..for i=1:1:sqlMapsCount d
	...set sqlMapID=sqlMapsID.GetAt(i)
	...set type=sqlMapID.Type
	...set indexName=sqlMapID.Name
	...set indexSub=..getIndexSubStr(sqlMapID.Subscripts)
	...set indexMasterData=sqlMapID.Global_indexSub
	...q:(vType'="")&&($ZCONVERT(vType,"U")'=$ZCONVERT(type,"U"))
	...d OutputRowMaster
	i storageType '= "%Library.CacheStorage" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s indexDefinitions = dcd.Indices
	s indicesCount = indexDefinitions.Count()
	f i=1:1:indicesCount d
	.s indexDefinition = indexDefinitions.GetAt(i)
	.s type="Index"
	.s indexName=indexDefinition.Name
	.s indexMasterData = storageIndexMasterData_"("""_indexName_""","_indexDefinition.Properties_",ID)"
	.q:(vType'="")&&($ZCONVERT(vType,"U")'=$ZCONVERT(type,"U"))
	.d OutputRowMaster
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowMaster
	set Data=$lb($g(className),$g(type),$g(indexName),$g(indexMasterData))
	i StandFlag'=""  d
	.;检测是否存在数据
	.s DataFlag=0
	.i $L(indexMasterData,"=")<=1  d
	..i $L(indexMasterData,",")>1  d
	...s DataExe="DataFlag=$D("_$p(indexMasterData,",",1)_"))"
	..e  d
	...s DataExe="DataFlag=$D("_$p(indexMasterData,"(",1)_")"
	..s @DataExe
	..i +DataFlag>0 s DataFlag=1
	.i StandFlag="S"  d
	..s DataFlag=0
	..i $D(^TempDHCEQUserClsInfo("X","Table",className)) s DataFlag=1
	.i DataFlag'=1  d
	..k ^TempDHCEQUserClsInfo(StandFlag,"Table",className)
	.e  d
	..s ^TempDHCEQUserClsInfo(StandFlag,"Table",className,type,indexName)=DataFlag_"@"_indexMasterData
	..i (PrintAllFlag>="3")&&(type="data")  d
	...d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","SelectProperty",packageName,className,indexName,StandFlag,PrintAllFlag)
 	Set ^CacheTemp(repid,indm)=Data
 	Set indm=indm+1
}

ClassMethod SelectMasterFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectMasterExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
 	Set indm=$LIST(qHandle,3)
 	Set indm=$o(^CacheTemp(repid,indm))
 	If indm="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
	 	Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,indm)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,indm)
	Quit $$$OK
}

ClassMethod SelectMasterClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectMasterExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 描述:    得到主索引或索引的subString
/// 返回:    subString:   (0,"BillDate",{PBDO_BillDate},{PBDO_RowId})
/// 入参:    subScripts
/// [Previously private]
ClassMethod getIndexSubStr(subScripts)
{
	s subCnt=subScripts.Count(),subString="("
	for k=1:1:subCnt {
				set subScript=subScripts.GetAt(k)	
				set expr=subScript.Expression
				set subString=subString_""_expr_","
	}
	set $e(subString,$l(subString))=""   //去掉最后的逗号
	q subString_")"
}

/***********************************************************************************************/
/// Add By DJ 2017-11-16
/// 描述:获取DataMaster结构
/// 改自:web.Util.DHCJFClassGlobal.cls下的SelectProperty
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","SelectProperty","User","DHCEQInStock","DataMaster")
/// 入参：packageName 表示实体类包名
/// 		 className  表示Web类名称
/// 		 masterIndexName 表示存储或索引名称
/// 		 StandFlag 标准版本标志 X表示项目库 S表示标准版 
///      PrintAllFlag 输出结果标志 3:【存储详细】
Query SelectProperty(packageName As %String = "User", className As %String, masterIndexName As %String, StandFlag As %String = "", PrintAllFlag As %String = "") As %Query(ROWSPEC = "TclassName:%String,propertyName:%String,propertyNode:%String,propertyDeli:%String,propertyPiece:%String,propertyType:%String,propertyField:%String,propertyColumn:%String,propertyMaxLen:%String") [ SqlProc ]
{
}

ClassMethod SelectPropertyExecute(ByRef qHandle As %Binary, packageName As %String = "User", className As %String, masterIndexName As %String, StandFlag As %String = "", PrintAllFlag As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
    If $g(indp)="" Set indp=1	
    
    i StandFlag=$C(0) s StandFlag=""
    i PrintAllFlag=$C(0) s PrintAllFlag=""
    
	i (packageName="")||(className="") Set qHandle=$lb(0,repid,0) Quit $$$OK
	i StandFlag'=""  d
	.k ^TempDHCEQUserClsInfo(StandFlag,"DataMaster",className)
	s classAllName=packageName_"."_className
	Set rsltSt = ##class(%ResultSet).%New("%Dictionary.PropertyDefinition:Summary")
	do rsltSt.Execute(classAllName)
	While(rsltSt.Next()) {
		s (TclassName,propertyName,propertyNode,propertyDeli,propertyPiece,propertyType,propertyField,propertyColumn)=""
		s TclassName="DHC_EQ"_$e(className,6,$L(className))
		set propertyName=rsltSt.Data("Name")
		set propertyId=classAllName_"||"_propertyName
		set propObj=##class(%Dictionary.PropertyDefinition).%OpenId(propertyId,0)
		set propertyType=propObj.Type
		set propertyMaxLen=propObj.Parameters.GetAt("MAXLEN")
		if ($l(propertyType,".")=1)&&($l(propertyType,"%")=1) s propertyType="User."_propertyType
		set propertyField=propObj.SqlFieldName
		set propertyColumn=propObj.SqlColumnNumber
		if (masterIndexName="") {
			s masterIndexName=..getMasterIndexName(packageName,className)
		}
		s ssmddID=classAllName_"||SQLStorage||"_masterIndexName_"||"_propertyField
		set ssmdd=##class(%Dictionary.StorageSQLMapDataDefinition).%OpenId(ssmddID,0)
		if (ssmdd'="") {
			set propertyNode=ssmdd.Node
			set propertyDeli=ssmdd.Delimiter
			set propertyPiece=ssmdd.Piece
		}
		d OutputRowProperty
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowProperty
	set Data=$lb(TclassName,propertyName,propertyNode,propertyDeli,propertyPiece,propertyType,propertyField,propertyColumn,propertyMaxLen)
	i StandFlag'=""  d
	.i propertyPiece="" s propertyPiece=propertyName
	.i propertyNode="" s propertyNode="-"
	.s ^TempDHCEQUserClsInfo(StandFlag,"Table",className,"DataMaster",propertyNode,propertyPiece)=propertyField_"^"_propertyType_"^"_propertyColumn_"^"_propertyMaxLen
 	Set ^CacheTemp(repid,indp)=Data
 	Set indp=indp+1
}

ClassMethod SelectPropertyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SelectPropertyExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
 	Set indp=$LIST(qHandle,3)
 	Set indp=$o(^CacheTemp(repid,indp))
 	If indp="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
	 	Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,indp)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,indp)
	Quit $$$OK
}

ClassMethod SelectPropertyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SelectPropertyExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod getMasterIndexName(packageName As %String, className As %String)
{
	set classAllName=packageName_"."_className
	set masterIndexName=""
	set dcd = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
	set dsd=dcd.Storages
	set dsdCount=dsd.Count()
	for j=1:1:dsdCount {
		s sqlMapsID=dsd.GetAt(j).SQLMaps
		s sqlMapsCount=sqlMapsID.Count()
		for i=1:1:sqlMapsCount {
			set sqlMapID=sqlMapsID.GetAt(i)
			set type=sqlMapID.Type
			set indexName=sqlMapID.Name
			i type="data" s masterIndexName=indexName
		}	
	}
	q masterIndexName
}

/// Add By DJ 2017-11-24
/// 描述:获取实体类DataMaster名称
/// w ##Class(web.DHCEQ.Tools.UserClsCompare).GetUserDataMasterName("User","DHCEQInStock","DATA")
ClassMethod GetUserDataMasterName(packageName As %String = "", preClassName As %String = "", vType As %String = "")
{
	i ((packageName="")||(preClassName="")||(vType="")) q ""
	s result=""
	s classAllName=packageName_"."_preClassName
	s dcd = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
	i dcd="" q ""
	s dsd=dcd.Storages
	s dsdCount=dsd.Count()
	s storageType="%CacheSQLStorage"
	for j=1:1:dsdCount 	d
	.s storage = dsd.GetAt(j)
	.s storageType = storage.Type	; %Dictionary.CacheClassname
	.i storageType = "%Library.CacheStorage" d
	..s storageIndexMasterData=storage.IndexLocation
	..s storageDatas = storage.Data		;%Dictionary.StorageDataDefinition
	..s storageDatasCount = storageDatas.Count()
	..f y=1:1:storageDatasCount d
	...s storageData=storageDatas.GetAt(y)
	...s storageDataValue=storageData.Values	;%Dictionary.StorageDataValueDefinition
	...s storageDataValueCount=storageDataValue.Count()
	...s type = "data"	
	...s indexName=storageData.Name
	...s storageStructure=storageData.Structure
	...i storageStructure="node"  s indexMasterData=storage.DataLocation_"(ID,0)="_storageData.Attribute
	...e  d
	....s indexSub=""
	....for x=1:1:storageDataValueCount d
	.....i indexSub'="" s indexSub=indexSub_","_storageDataValue.GetAt(x).Value
	.....e  s indexSub=storageDataValue.GetAt(x).Value
	....s indexMasterData=storage.DataLocation_"(ID)=$LB("_indexSub_")"
	...q:(vType'="")&&($ZCONVERT(vType,"U")'=$ZCONVERT(type,"U"))
	...i result'="" s result=result_"&"
	...s result=indexName_"@"_indexMasterData
	.e  d 
	..s sqlMapsID = storage.SQLMaps
	..s sqlMapsCount=sqlMapsID.Count()
	..for i=1:1:sqlMapsCount d
	...set sqlMapID=sqlMapsID.GetAt(i)
	...set type=sqlMapID.Type
	...set indexName=sqlMapID.Name
	...set indexSub=..getIndexSubStr(sqlMapID.Subscripts)
	...set indexMasterData=sqlMapID.Global_indexSub
	...q:(vType'="")&&($ZCONVERT(vType,"U")'=$ZCONVERT(type,"U"))
	...i result'="" s result=result_"&"
	...s result=indexName_"@"_indexMasterData
	
	i storageType '= "%Library.CacheStorage" q result
	s indexDefinitions = dcd.Indices
	s indicesCount = indexDefinitions.Count()
	f i=1:1:indicesCount d
	.s indexDefinition = indexDefinitions.GetAt(i)
	.s type="Index"
	.s indexName=indexDefinition.Name
	.s indexMasterData = storageIndexMasterData_"("""_indexName_""","_indexDefinition.Properties_",ID)"
	.q:(vType'="")&&($ZCONVERT(vType,"U")'=$ZCONVERT(type,"U"))
	.i result'="" s result=result_"&"
	.s result=indexName_"@"_indexMasterData
	
	q result
}

/************************************************************************************************************/
/// Add By DJ 2017-11-16
/// 描述:检查所有表扩展节点记录内容
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","CheckUserClsEx","User","DHCEQ","D:\DHCEQCheckGloablEx.txt")
/// 入参：packageName 表示实体类包名
/// 		 preClassName  表示Web类前缀
/// 		 OutFile 检测结果输出文件路径
Query CheckUserClsEx(packageName As %String = "", preClassName As %String = "", OutFile As %String = "") As %Query(ROWSPEC = "TGlobal:%String,TCodeName:%String,TExInfo:%String") [ SqlProc ]
{
}

ClassMethod CheckUserClsExExecute(ByRef qHandle As %Binary, packageName As %String = "", preClassName As %String = "", OutFile As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i OutFile=""
	{
		w "请输入检测结果存储文件名及路径!"
		Quit $$$OK
	}
	//默认获取标准版所有DHCEQ开头的实体类
	i packageName="" s packageName="User"
	i preClassName="" s preClassName="DHCEQ"
	k ^Temp("DHCEQCheckUserClsEx")
	;获取所有表名
	s sog=$System.OBJ.GetPackageList(.PLIST,packageName,"")
	Do:('sog) $system.Status.DisplayError(sog)
	
	s len = $l(preClassName)
	s name=""
	s name=$o(PLIST(name))
	while(name'="")
	{
		s outClassName=$p(name,packageName_".",2)
		s preName=$e(outClassName,1,len)
		s ContainFlag=0
		i outClassName="DHCEQMonthDepre" s ContainFlag=1
		i outClassName="DHCEQCostAllotDetail" s ContainFlag=1
		i outClassName="DHCEQLifeInfo" s ContainFlag=1
		i outClassName="DHCEQUseRecord" s ContainFlag=1
		i outClassName="DHCEQUseRecordStat" s ContainFlag=1
		i outClassName="DHCEQUsedResource" s ContainFlag=1
		i outClassName="DHCEQUseConsumableItem" s ContainFlag=1
		i outClassName="DHCEQInventory" s ContainFlag=1
		i outClassName="DHCEQInventoryList" s ContainFlag=1
		i ($ZCVT(preName,"U")=$ZCVT(preClassName,"U")&&(ContainFlag=0))
		{
			s DataMasterGlobal=##Class(web.DHCEQ.Tools.UserClsCompare).GetUserDataMasterName("User",outClassName,"data")
			s DataMasterGlobal=$p(DataMasterGlobal,"@",2)
			i '((DataMasterGlobal="")||($E(DataMasterGlobal,1,6)'="^DHCEQ"))
			{
				s GlobalName=$p(DataMasterGlobal,"(",1)
				s vTCodeNode=""
				i $L(DataMasterGlobal,",")>1 s vTCodeNode=$p($p(DataMasterGlobal,",",1),"(",2)
				;开始循环单个Global
				s NoteReturn=##Class(web.DHCEQ.Tools.UserClsCompare).GetGlobalNextNote(GlobalName,vTCodeNode,0)
				s NextNoteStr=NoteReturn_","_$C(34)_$C(34)
				While (NoteReturn'="")&&(NoteReturn'=($C(34)_$C(34)))
				{
					s NextNoteReturn=##Class(web.DHCEQ.Tools.UserClsCompare).GetGlobalNextNote(GlobalName,vTCodeNode,NextNoteStr)
					i (NextNoteReturn'="")&&(NextNoteReturn'=($C(34)_$C(34)))
					{
						i $E(NextNoteStr,$L(NextNoteStr)-2,$L(NextNoteStr))=(","_$C(34)_$C(34))
						{
							s NextNoteStr=$E(NextNoteStr,1,$L(NextNoteStr)-2)_NextNoteReturn_","_$C(34)_$C(34)
						}
						else
						{
							s NextNoteStr=$p(NextNoteStr,",",1,$L(NextNoteStr,",")-1)_","_NextNoteReturn_","_$C(34)_$C(34)
						}
					}
					else
					{
						i $E(NextNoteStr,$L(NextNoteStr)-2,$L(NextNoteStr))=(","_$C(34)_$C(34))
						{
							s NextNoteStr=$E(NextNoteStr,1,$L(NextNoteStr)-3)
							i $L(NextNoteStr,",")>1
							{
								s TGlobal=GlobalName
								s TCodeName=vTCodeNode
								;s TExInfo=$p(NextNoteStr,",",1)_"@"_$p(NextNoteStr,",",2,$L(NextNoteStr,","))
								s TExInfo=$p(NextNoteStr,",",2,$L(NextNoteStr,","))
								i TCodeName="" s TCodeName="-"
								i '$D(^Temp("DHCEQCheckUserClsEx",TGlobal,TCodeName,TExInfo))
								{
									s ^Temp("DHCEQCheckUserClsEx",TGlobal,TCodeName,TExInfo)=""
									d OutputRowCheckUserClsEx
								}
							}
						}
						else
						{
							s NextNoteStr=$p(NextNoteStr,",",1,$L(NextNoteStr,",")-1)
						}
					}
					i $L(NextNoteStr,",")<=1
					{
						s NoteReturn=##Class(web.DHCEQ.Tools.UserClsCompare).GetGlobalNextNote(GlobalName,vTCodeNode,NextNoteStr)
						s NextNoteStr=NoteReturn_","_$C(34)_$C(34)
					}
				}
				;单个Global循环结束
			}
		}
		s name=$o(PLIST(name))
	}
	;写TXT文件
	s filename=OutFile
 	s file=##class(%File).%New(filename)
	d file.Open("WSN")
	d file.WriteLine("Global名"_$C(9)_"节点")
	s GlobalName=""
	f  s GlobalName=$o(^Temp("DHCEQCheckUserClsEx",GlobalName)) q:GlobalName=""  d
	.s TCodeName=""
	.f  s TCodeName=$o(^Temp("DHCEQCheckUserClsEx",GlobalName,TCodeName))  q:TCodeName=""  d
	..s TExInfo=""
	..f  s TExInfo=$o(^Temp("DHCEQCheckUserClsEx",GlobalName,TCodeName,TExInfo))  q:TExInfo=""  d
	...q:(GlobalName="^DHCEQCCode")&&(TCodeName["DHCEQCCounter")&&(TExInfo["EX")&&(TExInfo["Group")
	...i TCodeName="-"  d
	....d file.WriteLine(GlobalName_$C(9)_"(RowID,"_TExInfo_")")
	...e  d
	....d file.WriteLine(GlobalName_$C(9)_"("_TCodeName_",RowID,"_TExInfo_")")
	d file.Close()
	k ^Temp("DHCEQCheckUserClsEx")
	
	Quit $$$OK
OutputRowCheckUserClsEx
	s Data=$lb(TGlobal,TCodeName,TExInfo)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod CheckUserClsExFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckUserClsExExecute ]
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

ClassMethod CheckUserClsExClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckUserClsExExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By DJ 2017-11-29
/// 描述:获取某一Global中当前节点的下一节点
ClassMethod GetGlobalNextNote(vGlobalName As %String = "", vTCodeNote As %String = "", vNote As %String = "")
{
	i vTCodeNote=""  d
	.s ExeStr="ReturnStr=$o("_vGlobalName_"("_vNote_"))"
	e  d
	.s ExeStr="ReturnStr=$o("_vGlobalName_"("_vTCodeNote_","_vNote_"))"
	s @ExeStr
	q $C(34)_ReturnStr_$C(34)
}

/// Add By DJ 2017-12-01
/// 索引及存储比较
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","MAndICompare","D:\DHCEQMAndICompare.txt")
/// 入参:OutFile 比对结果文件输出路径
Query MAndICompare(OutFile As %String = "") As %Query(ROWSPEC = "TUserCls:%String,TSTableFlag:%String,TYesNoDataFlag:%String,TType:%String,TCompareFlag:%String,TKeyName:%String,TStandInfo:%String,TItemInfo:%String") [ SqlProc ]
{
}

ClassMethod MAndICompareExecute(ByRef qHandle As %Binary, OutFile As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i OutFile=""
	{
		w "请输入比较结果存储文件名及路径"
		Quit $$$OK
	}
	s filename=OutFile
 	s file=##class(%File).%New(filename)
	d file.Open("WSN")
	d file.WriteLine("表名"_$C(9)_"标版存在"_$C(9)_"有数据"_$C(9)_"类型"_$C(9)_"差异"_$C(9)_"关键字"_$C(9)_"标准版值(字段名^字段类型^存储位置^字段长度)"_$C(9)_"旧版值(字段名^字段类型^存储位置^字段长度)")
	s OldTable=""
	f  s OldTable=$o(^TempDHCEQUserClsInfo("X","Table",OldTable))  q:OldTable=""  d
	.d ResetVariablesMAndICompare
	.s TUserCls=OldTable
	.s TSTableFlag="Y"
	.i '$D(^TempDHCEQUserClsInfo("S","Table",OldTable)) s TSTableFlag="N"
	.;检测项目库是否存在数据
	.s OldDataMName=$o(^TempDHCEQUserClsInfo("X","Table",OldTable,"data",""))
	.i OldDataMName'=""  d
	..s TYesNoDataFlag=$p($g(^TempDHCEQUserClsInfo("X","Table",OldTable,"data",OldDataMName)),"@",1)
	..i TYesNoDataFlag=0  d
	...s TYesNoDataFlag="N"
	..e  d
	...s TYesNoDataFlag="Y"
	.;检测索引是否一致
	.s TType="索引"
	.s IndexType=""
	.f  s IndexType=$o(^TempDHCEQUserClsInfo("X","Table",OldTable,IndexType))  q:IndexType=""  d
	..q:IndexType="DataMaster"
	..s OldIndexName=""
	..f  s OldIndexName=$o(^TempDHCEQUserClsInfo("X","Table",OldTable,IndexType,OldIndexName))  q:OldIndexName=""  d
	...s OldIndexInfo=$p($g(^TempDHCEQUserClsInfo("X","Table",OldTable,IndexType,OldIndexName)),"@",2)
	...;旧表索引存在,新表索引不存在(需要升级后在新系统建立的索引)
	...i '$D(^TempDHCEQUserClsInfo("S","Table",OldTable,IndexType,OldIndexName))  d
	....s TKeyName=OldIndexName
	....s TStandInfo="无"
	....s TItemInfo=OldIndexInfo
	....s TCompareFlag="删除索引"
	....d file.WriteLine(TUserCls_$C(9)_TSTableFlag_$C(9)_TYesNoDataFlag_$C(9)_TType_$C(9)_TCompareFlag_$C(9)_TKeyName_$C(9)_TStandInfo_$C(9)_TItemInfo)
	....d OutputRowMAndICompare
	...e  d
	....;旧索引变更(需要根据实际情况处理)
	....s NewIndexInfo=$p($g(^TempDHCEQUserClsInfo("S","Table",OldTable,IndexType,OldIndexName)),"@",2)
	....i OldIndexInfo'=NewIndexInfo  d
	.....s TKeyName=OldIndexName
	.....s TStandInfo=NewIndexInfo
	.....s TItemInfo=OldIndexInfo
	.....s TCompareFlag="修改索引"
	.....d file.WriteLine(TUserCls_$C(9)_TSTableFlag_$C(9)_TYesNoDataFlag_$C(9)_TType_$C(9)_TCompareFlag_$C(9)_TKeyName_$C(9)_TStandInfo_$C(9)_TItemInfo)
	.....d OutputRowMAndICompare
	..;新索引存在,旧索引不存在(升级需要重建生成索引数据)
	..s NewIndexName=""
	..f  s NewIndexName=$o(^TempDHCEQUserClsInfo("S","Table",OldTable,IndexType,NewIndexName))  q:NewIndexName=""  d
	...i '$D(^TempDHCEQUserClsInfo("X","Table",OldTable,IndexType,NewIndexName))  d
	....s TKeyName=NewIndexName
	....s TStandInfo=$p($g(^TempDHCEQUserClsInfo("S","Table",OldTable,IndexType,NewIndexName)),"@",2)
	....s TItemInfo="无"
	....s TCompareFlag="增加索引"
	....d file.WriteLine(TUserCls_$C(9)_TSTableFlag_$C(9)_TYesNoDataFlag_$C(9)_TType_$C(9)_TCompareFlag_$C(9)_TKeyName_$C(9)_TStandInfo_$C(9)_TItemInfo)
	....d OutputRowMAndICompare
	.;检测存储结构是否一致
	.s TType="字段"
	.s TableCheckResult=0
	.s DataMasterNode=""
	.f  s DataMasterNode=$o(^TempDHCEQUserClsInfo("S","Table",OldTable,"DataMaster",DataMasterNode))  q:(DataMasterNode="")||(TableCheckResult'=0)  d
	..s OldTableCCount=+$o(^TempDHCEQUserClsInfo("X","Table",OldTable,"DataMaster",DataMasterNode,""),-1)
	..s NewTableCCount=+$o(^TempDHCEQUserClsInfo("S","Table",OldTable,"DataMaster",DataMasterNode,""),-1)
	..s MaxCount=OldTableCCount
	..i NewTableCCount>OldTableCCount s MaxCount=NewTableCCount
	..s CurIndex=0
	..f CurIndex=1:1:MaxCount  d
	...q:TableCheckResult'=0
	...s OldCurInfo=$g(^TempDHCEQUserClsInfo("X","Table",OldTable,"DataMaster",DataMasterNode,CurIndex))
	...s NewCurInfo=$g(^TempDHCEQUserClsInfo("S","Table",OldTable,"DataMaster",DataMasterNode,CurIndex))
	...i OldCurInfo'=NewCurInfo s TableCheckResult=1
	.i TableCheckResult'=0  d
	..s DataMasterNode=""
	..f  s DataMasterNode=$o(^TempDHCEQUserClsInfo("S","Table",OldTable,"DataMaster",DataMasterNode))  q:DataMasterNode=""  d
	...s OldTableCCount=+$o(^TempDHCEQUserClsInfo("X","Table",OldTable,"DataMaster",DataMasterNode,""),-1)
	...s NewTableCCount=+$o(^TempDHCEQUserClsInfo("S","Table",OldTable,"DataMaster",DataMasterNode,""),-1)
	...s MaxCount=OldTableCCount
	...i NewTableCCount>OldTableCCount s MaxCount=NewTableCCount
	...s CurIndex=0
	...f CurIndex=1:1:MaxCount  d
	....s TItemInfo=$g(^TempDHCEQUserClsInfo("X","Table",OldTable,"DataMaster",DataMasterNode,CurIndex))
	....s TStandInfo=$g(^TempDHCEQUserClsInfo("S","Table",OldTable,"DataMaster",DataMasterNode,CurIndex))
	....s TCompareFlag=""
	....i TItemInfo'=TStandInfo s TCompareFlag="Y"
	....i DataMasterNode="-"  d
	.....s TKeyName=CurIndex
	....e  d
	.....s TKeyName=DataMasterNode_CurIndex
	....d file.WriteLine(TUserCls_$C(9)_TSTableFlag_$C(9)_TYesNoDataFlag_$C(9)_TType_$C(9)_TCompareFlag_$C(9)_TKeyName_$C(9)_TStandInfo_$C(9)_TItemInfo)
	....d OutputRowMAndICompare
	
	d file.Close()
	Quit $$$OK

OutputRowMAndICompare
	s Data=$lb(TUserCls,TSTableFlag,TYesNoDataFlag,TType,TCompareFlag,TKeyName,TStandInfo,TItemInfo)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesMAndICompare
	s (TUserCls,TSTableFlag,TYesNoDataFlag,TType,TCompareFlag,TKeyName,TStandInfo,TItemInfo)=""
	quit
}

ClassMethod MAndICompareFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MAndICompareExecute ]
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

ClassMethod MAndICompareClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MAndICompareExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By DJ 2018-04-24
/// 描述:基础数据升级标准库存在数据项目库不存在数据以标准库为准
/// d ##Class(web.DHCEQ.Tools.UserClsCompare).UpdateBaseCode()
ClassMethod UpdateBaseCode()
{
	s BaseTable=""
	f  s BaseTable=$o(^DHCEQCCodeStand(BaseTable))  q:BaseTable=""  d
	.q:BaseTable="DHCEQCAction"
	.q:BaseTable="DHCEQCApproveFlowAllow"
	.q:BaseTable="DHCEQCRoleReqFields"
	.q:BaseTable="DHCEQCApproveAction"
	.q:BaseTable="DHCEQCApprFlowStepAction"
	.q:BaseTable="DHCEQCLocGroup"
	.q:BaseTable="DHCEQCLocGroupType"
	.q:BaseTable="DHCEQCLocType"
	.q:BaseTable="DHCEQCTableData"
	.q:BaseTable="DHCEQCColumns"
	.q:BaseTable="DHCEQCColSet"
	.q:$D(^TempDHCEQUserClsInfo("X","Table",BaseTable))
	.k ^DHCEQCCode(BaseTable)
	.M ^DHCEQCCode(BaseTable)=^DHCEQCCodeStand(BaseTable)
	
	k ^DHCEQCCodeTable
	M ^DHCEQCCodeTable=^DHCEQCCodeTableStand
}

/// add by ZY0233 20200522
/// modify by wl 2020-06-19
/// desc:  把表的数据转成json
/// Input：tableName,表名
/// 		id,记录id
/// Return： json串
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","DataTransOut","basedata","d:\\业务表.txt","d:\\基础数据导出.txt")
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Tools.UserClsCompare","DataTransOut","tableNameByFile","d:\\业务表.txt","d:\\业务数据导出.txt")
/// call web_DHCEQ_Tools.UserClsCompare_DataTransOut('tableNameByFile','d:\\业务表.txt','d:\\业务数据导出.txt')
Query DataTransOut(tableName As %String = "", readFile As %String = "", dataout As %String = "") As %Query(ROWSPEC = "tableName:%String,id:%String,data:%String") [ SqlProc ]
{
}

ClassMethod DataTransOutExecute(ByRef qHandle As %Binary, tableName As %String = "", readFile As %String = "", dataout As %String = "") As %Status
{
	i (dataout="")  							   q "请输入输出文件的文件路径及文件名"
	i (tableName="tableNameByFile")&&(readFile="") q "请输入读文件的路径"
 	s file=##class(%File).%New(dataout)
	d file.Open("WSN")
	d file.WriteLine("JSON 拼串开始")
 	n repid, index,rowid
 	s (StorgeList,mapGlobal,subscriLen,sqlIdExpression,startValue,sqlIdExpression,tableobj)=""
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	/*基础数据处理部分*/
	if tableName="basedata"
	{
		s tableName=0
		f   s tableName=$o(^DHCEQCCode(tableName))  q:tableName=""  d
		.i tableName="DHCEQCInHospitalType"  s tableobj=##class(%Dictionary.ClassDefinition).%OpenId("User."_"DHCEQInHospitalType")
		.e  s tableobj= ##class(%Dictionary.ClassDefinition).%OpenId("User."_tableName)
		.i tableobj="" d file.WriteLine("问题1User."_tableName_"该表不存在"_" ,存在global:DHCEQCCode(""_tableName_"")")
		.q:tableobj=""
		.s StorgeList= ..GetStorgelist(tableobj)
		.q:StorgeList="" 
		.s mapGlobal 		= StorgeList.%Get("mapGlobal")
		.s subscriLen 		= StorgeList.%Get("subscriLen")
		.s sqlIdExpression  = StorgeList.%Get("sqlIdExpression")
		.s startValue		= StorgeList.%Get("startValue")
		.i startValue="" 	d file.WriteLine("问题2该表User."_tableName_"中StartValue没有设置请在数据导入完成补充")
		.i (mapGlobal'["DHCEQCCode")&&(subscriLen'=2) d file.WriteLine("Global:"_mapGlobal_" subscriLen:"_subscriLen)
		.i sqlIdExpression'["DHCEQCCode" d file.WriteLine("问题3SQLIdExpression格式不标准"_sqlIdExpression_"  User."_tableName)
		.i tableName="DHCEQCCodeTable"   d
			..s id=0
			..for  x "s id="_"$o(^"_tableName_"("_id_"))"  q:(id="")  d 
				...x "s obj=##Class(User."_tableName_").%OpenId("_id_")"
				...s obj=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(obj)
				...s data=obj.%ToJSON()
				...d OutputRowTableData
		.s id=0
		.f  s id=$o(^DHCEQCCode(tableName,id))  q:(id="")||(tableobj="")||((mapGlobal'["DHCEQCCode")&&(subscriLen'=2))||(tableName="DHCEQCCodeTable")  d
			..i tableName="DHCEQCInHospitalType" x "s obj=##Class(User.DHCEQInHospitalType).%OpenId("_id_")"
			..e  x "s obj=##Class(User."_tableName_").%OpenId("_id_")"
			..s obj=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(obj)
			..s data=obj.%ToJSON()
			..d file.WriteLine("User."_tableName_" id:"_id_" data:"_data)
			..d OutputRowTableData
		
	}
	/*通用数据处理*/
	else
	{//tableName转list集合
		i tableName="tableNameByFile" s tableName=..GetTabNameByFile(readFile)
		s tableLen=$l(tableName,"^")
		s tableList=$LISTFROMSTRING(tableName,"^")
		f i=1:1:tableLen  d
		.s tableName=$LIST(tableList,i)
		.s tableobj=##class(%Dictionary.ClassDefinition).%OpenId("User."_tableName) 
		.i tableobj=""  d file.WriteLine("问题5该表User."_tableName_"在本库中不存在") q
		.s StorgeList= ..GetStorgelist(tableobj)
		.i StorgeList="" q
		.s startValue=StorgeList.%Get("startValue")
		.i startValue="" d file.WriteLine("问题6该表User."_tableName_"中StartValue没有设置请在数据导入完成补充")
		.s dataMaster=StorgeList.%Get("dataMaster")
		.s count=0
		.s id=0
		.for  x "s id="_"$o("_dataMaster_")"  q:(id="")  d 
			..x "s tableobj=##Class(User."_tableName_").%OpenId("_id_")"
			..s tableobj=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(tableobj)
			..s data=tableobj.%ToJSON()
			..d file.WriteLine("User."_tableName_" id:"_id_" data:"_data)
			..s count=count+1
			..d OutputRowTableData
		.i count=0  d file.WriteLine("问题7该表User."_tableName_"中输出的数据为0")	
	}
	d file.WriteLine("JSON 拼串结束")
	d file.Close()
	Quit $$$OK
	
OutputRowTableData
	s Data=$lb(tableName,id,data)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod DataTransOutFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DataTransOutExecute ]
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

ClassMethod DataTransOutClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DataTransOutExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by ZY0233 20200522
/// modify by wl 2020-06-19
/// desc:  把json格式的数据通过对象的方式存到表中
/// Input：tableName,表名
/// 		id,记录id
/// 		data,{field:value,field:value,...}
/// Return：新记录的ID
/// d ##Class(web.DHCEQ.Tools.UserClsCompare).DataTransIn("DHCEQCAccessoryCat",16,"{""ACCode"":""12233"",""ACDesc"":""sdd"",""ACHold1"":"""",""ACHold2"":"""",""ACHold3"":"""",""ACInvalidFlag"":""1"",""ACParCatDR"":"""",""ACRemark"":""""})
ClassMethod DataTransIn(tableName As %String = "", rowid As %Integer = "", data As %String(MAXLEN=32767)) As %String [ SqlProc ]
{
	n ColumnsInfo,ColumnsLength,Iterator,CurColumn,ColumnType,DisPlayList,val,sqlIdExpression
	n codeFlag,prerowid,SQLCODE
	s (SQLCODE)=0
	i rowid'=""
	{
		s prerowid=rowid-1
		i tableName="DHCEQCInHospitalType" s tableName="DHCEQInHospitalType"
	    s ColumnsInfo = ##class(%Dictionary.ClassDefinition).%OpenId("User."_tableName)
	    i ColumnsInfo="" q "该表"_tableName_"不存在,无法插入"
		s StorgeList= ..GetStorgelist(ColumnsInfo)
		s sqlIdExpression=StorgeList.sqlIdExpression
		s sqlIdExpression=$e(sqlIdExpression,4,$l(sqlIdExpression)-1)
		x "s "_sqlIdExpression_"="_prerowid	
	} 
	i (data'="")
	{
		k PLIST
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    XECUTE "s obj=##Class(User."_tableName_").%New()"   		
	    s ColumnsLength=ColumnsInfo.Properties.Count()
	    
	    //s Iterator = JsonData.%GetIterator()		//CZF0131 2021-01-20
	    //while Iterator.%GetNext(.key,.val) {
		s key=""
		For
		{
			s val=JsonData.GetNext(.key)
			q:key=""
		    f CurColumn=1:1:ColumnsLength  d
			.i ColumnsInfo.Properties.GetAt(CurColumn).Name=key d
			..s SqlColumnNumber=ColumnsInfo.Properties.GetAt(CurColumn).SqlColumnNumber
			..s ColumnType=ColumnsInfo.Properties.GetAt(CurColumn).Type
			..s DisPlayList=ColumnsInfo.Properties.GetAt(CurColumn).Parameters.GetAt("DISPLAYLIST")
			..if (ColumnType="%Library.Date")||(ColumnType="%Date") d
			...s val=##Class(web.DHCEQCommon).TransValueFromPage(val,"date")
			..else  if (ColumnType="%Library.Time")||(ColumnType="%Time") d
			...s val=##Class(web.DHCEQCommon).TransValueFromPage(val,"time")
			..if (DisPlayList=",Yes,No") d
			...s val=##Class(web.DHCEQCommon).TransValueFromPage(val,"bool")
			..//SetObjectId
			..if ($e(ColumnType,1,5)="User.")||((ColumnType'["%")&&(ColumnType'["User.") ) d
			...s cmd="d obj."_key_"SetObjectId(val)"
			..e  d
			...s cmd="s obj."_key_"=val"
			..XECUTE cmd
		}

	
		s sc=obj.%Save()
		s rowid= obj.%Id() 
		q rowid
		
	}
	q 0
}

/// add by wl 2020-06-19
/// 根据文件获取业务表名
/// 入参：filName:文件地址
/// 返回值：null
/// Debug: w ##class(web.DHCEQ.Tools.UserClsCompare).GetTabNameByFile("C:\Users\WL\Desktop\表名.txt")
ClassMethod GetTabNameByFile(fileName As %String) As %String
{
	if fileName="" q "无相关文件导入"
	s tableName=""
	If '##class(%File).Exists(fileName) q "路径无效"
	s errs=""
	Set stream=##class(%FileCharacterStream).%New()
	Set stream.Filename=fileName
	While 'stream.AtEnd {
		Set lineStr=stream.ReadLine()
		if lineStr="" continue
		s lineStr=##class(web.DHCEQ.Plat.LIBCommon).Replace(lineStr,"_","")
		i lineStr'["DHCEQ" continue
		s tableName=tableName_"^"_lineStr
}
	q $e(tableName,2,$l(tableName))
}

/// add by wl 2020-06-19 
/// 描述：获取SQLMap的相关信息
/// 入参：tableobj:类%Dictionary.ClassDefinition的实例
/// 返回值：jsonData对象====>
/// storgecout:		 "storage的数量", 
/// sqlIdExpression："种子值表达式" ,
/// subscriLen:		 "sqlmap为dataMaster的节点数" 
/// mapGlobal:		 "map对应的global" 
/// dataMaster:		 "datamaster的表达式" 
/// startValue:		 "数据区的初始值"}
/// 调试:w ##class(web.DHCEQ.Tools.UserClsCompare).GetStorgelist(##class(%Dictionary.ClassDefinition).%OpenId("User.DHCEQCBuildingStruct"))
ClassMethod GetStorgelist(tableobj As %String = "")
{
		
		q:tableobj=""
		s (storage,storgecout,sqlIdExpression,sqlMap,subscriLen,mapGlobal,dataMaster,startValue,SubscriExpress)=""
		s jsonData=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
		s storage=tableobj.Storages
		s storgecout=tableobj.Storages.Count()
		f j=1:1:storgecout d 
		.s storage=tableobj.Storages.GetAt(j)
		.s sqlIdExpression=storage.SqlIdExpression
		.s sqlMap=storage.SQLMaps.GetAt(1) 
		.i $zcvt(sqlMap.Name,"U")["INDEX"    d
		..f h=2:1:storage.SQLMaps.Count()  d
		...s sqlMap=storage.SQLMaps.GetAt(h)
		...i sqlMap'["INDEX" d
		....s h=storage.SQLMaps.Count()+1
		.s subscriLen=sqlMap.Subscripts.Count()
		.s mapGlobal=sqlMap.Global
		.s dataMaster=mapGlobal_"("
		.f k=1:1:subscriLen   d
		..s subScript=sqlMap.Subscripts.GetAt(k)
		..s subscriExpress=subScript.Expression
		..i k'=subscriLen s dataMaster=dataMaster_subscriExpress_","
		..e   d  
		...s startValue=subScript.StartValue
		...s SubscriExpress="id"
		...s dataMaster=dataMaster_SubscriExpress_")"
		d jsonData.%Set("storgecout",storgecout)
		d jsonData.%Set("sqlIdExpression",sqlIdExpression)
		d jsonData.%Set("subscriLen",subscriLen)
		d jsonData.%Set("mapGlobal",mapGlobal)
		d jsonData.%Set("dataMaster",dataMaster)
		d jsonData.%Set("startValue",startValue)
		q jsonData
}

/// add by wl 2020-06-19 
/// 描述：删除无用的global
/// 入参：null
/// 返回值：null
/// d ##class(web.DHCEQ.Tools.UserClsCompare).KillGlobalAndNew()
ClassMethod KillGlobalAndNew()
{
	
	i $d(^DHCEQCCode("DHCEQCGROUPACCESSORYTYPE",0))'=0 d
	.s ^DHCEQCCode("DHCEQCGroupAccessoryType",0)=^DHCEQCCode("DHCEQCGROUPACCESSORYTYPE",0)
	.k ^DHCEQCCode("DHCEQCGROUPACCESSORYTYPE",0)
	
	i $d(^DHCEQCCode("DHCEQBrand",0))'=0 d
	.s ^DHCEQCCode("DHCEQCBrand",0)=^DHCEQCCode("DHCEQBrand",0)
	.k ^DHCEQCCode("DHCEQBrand",0)
	
	i $d(^DHCEQCCode("DHCEQCPAYMODE",0))'=0 d
	.s ^DHCEQCCode("DHCEQCPayMode",0)=^DHCEQCCode("DHCEQCPAYMODE",0)
	.k ^DHCEQCCode("DHCEQCPAYMODE",0)

	i $d(^DHCEQCCode("DHCEQMessagesResult",0))'=0 d
	.s ^DHCEQCCode("DHCEQCMessagesResult",0)=^DHCEQCCode("DHCEQMessagesResult",0)
	.k ^DHCEQCCode("DHCEQMessagesResult",0)
	
	i $d(^mdata("DHCEQCALIAS"))'=0 d
	.s ^DHCEQCCode("DHCEQCAlias",0)=^mdata("DHCEQCALIAS")
	.k ^mdata("DHCEQCALIAS")
	
	
	i $d(^mdata("DHCEQCAPPROVEFLOWSTEPACTION"))'=0 d
	.s ^DHCEQCCode("DHCEQCApprFlowStepAction",0)=^mdata("DHCEQCAPPROVEFLOWSTEPACTION")
	.k ^mdata("DHCEQCAPPROVEFLOWSTEPACTION")
	
	
	i $d(^mdata("DHCEQEQUIPSTATUS"))'=0 d
	.s ^DHCEQCCode("DHCEQEquipStatus",0)=^mdata("DHCEQEQUIPSTATUS")
	.k ^mdata("DHCEQEQUIPSTATUS")
	
	
	i $d(^mdata("DHCEQMCMAINTGROUP"))'=0 d
	.s ^DHCEQCCode("DHCEQMCMaintGroup",0)=^mdata("DHCEQMCMAINTGROUP")
	.k ^mdata("DHCEQMCMAINTGROUP")
	
	i $d(^mdata("DHCEQMCMAINTGROUPLIST"))'=0 d
	.s ^DHCEQCCode("DHCEQMCMaintGroupList",0)=^mdata("DHCEQMCMAINTGROUPLIST")
	.k ^mdata("DHCEQMCMAINTGROUPLIST")
	
	i $d(^mdata("DHCEQMCMAINTRESULTS"))'=0 d
	.s ^DHCEQCCode("DHCEQMCMaintResults",0)=^mdata("DHCEQMCMAINTRESULTS")
	.k ^mdata("DHCEQMCMAINTRESULTS")
	
	i $d(^DHCEQCCode("DHCEQPMReport",0))'=0 d
	.s ^DHCEQPMReport("0")=^DHCEQCCode("DHCEQPMReport",0)
	.k ^DHCEQCCode("DHCEQPMReport",0)
	
	i $d(^DHCEQCCode("DHCEQPMReportList",0))'=0 d
	.s ^DHCEQPMReportList("0")=^DHCEQCCode("DHCEQPMReportList",0)
	.k ^DHCEQCCode("DHCEQPMReportList",0)
	
	i $d(^DHCEQCCode("DHCEQCGROUPACCESSORYTYPE",0))=0 w "^DHCEQCCode(""DHCEQCGROUPACCESSORYTYPE"",0)已清",!
	i $d(^DHCEQCCode("DHCEQBrand",0))=0 			  w "^DHCEQCCode(""DHCEQBrand"",0)已清",!
	i $d(^DHCEQCCode("DHCEQCPAYMODE",0))=0 			  w "^DHCEQCCode(""DHCEQCPAYMODE"",0)已清",!
	i $d(^DHCEQCCode("DHCEQMessagesResult",0))=0      w "^DHCEQCCode(""DHCEQMessagesResult"",0)已清",!
	i $d(^mdata("DHCEQCALIAS"))=0      				  w "^mdata(""DHCEQCALIAS"")已清",!
	i $d(^mdata("DHCEQCAPPROVEFLOWSTEPACTION"))=0     w "^mdata(""DHCEQCAPPROVEFLOWSTEPACTION"")已清",!
	i $d(^mdata("DHCEQEQUIPSTATUS"))=0      		  w "^mdata(""DHCEQEQUIPSTATUS"")已清",!
	i $d(^mdata("DHCEQMCMAINTGROUP"))=0      		  w "^mdata(""DHCEQMCMAINTGROUP"")已清",!
	i $d(^mdata("DHCEQMCMAINTGROUPLIST"))=0      	  w "^mdata(""DHCEQMCMAINTGROUPLIST"")已清",!
	i $d(^mdata("DHCEQMCMAINTRESULTS"))=0      		  w "^mdata(""DHCEQMCMAINTRESULTS"")已清",!
	i $d(^DHCEQCCode("DHCEQCRiskAssessment"))'=0 	  k ^DHCEQCCode("DHCEQCRiskAssessment")
	i $d(^DHCEQCCode("DHCEQCRiskAssessment"))=0   	  w "^DHCEQCCode(""DHCEQCRiskAssessment"")数据已清",!
	i $d(^DHCEQCCode("DHCEQCRiskEquipType"))'=0 	  k ^DHCEQCCode("DHCEQCRiskEquipType")
	i $d(^DHCEQCCode("DHCEQCRiskEquipType"))=0   	  w "^DHCEQCCode(""DHCEQCRiskEquipType"")数据已清",!
	i $d(^DHCEQCCode("DHCEQCRiskEquipTypeList"))'=0   k ^DHCEQCCode("DHCEQCRiskEquipTypeList")
	i $d(^DHCEQCCode("DHCEQCRiskEquipTypeList"))=0    w "^DHCEQCCode(""DHCEQCRiskEquipTypeList"")数据已清",!
	i $d(^DHCEQCCode("DHCEQPMReport",0))=0   		  w "^DHCEQCCode(""DHCEQPMReport"",0)已清",!
	i $d(^DHCEQCCode("DHCEQPMReportList",0))=0   	  w "^DHCEQCCode(""DHCEQPMReportList"",0)已清",!

	i $d(^DHCEQCCode("DHCEQCGroupAccessoryType",0))'=0    w "^DHCEQCCode(""DHCEQCGroupAccessoryType"",0)替换完成",!
	i $d(^DHCEQCCode("DHCEQCBrand",0))'=0 				  w "^DHCEQCCode(""DHCEQCBrand"",0)替换完成",!
	i $d(^DHCEQCCode("DHCEQCPayMode",0))'=0 			  w "^DHCEQCCode(""DHCEQCPayMode"",0)替换完成",!
	i $d(^DHCEQCCode("DHCEQCMessagesResult",0))'=0 	  	  w "^DHCEQCCode(""DHCEQCMessagesResult"",0)替换完成",!
	i $d(^DHCEQCCode("DHCEQCAlias",0))'=0  	  		  	  w "^DHCEQCCode(""DHCEQCAlias"",0)替换完成",!
	i $d(^DHCEQCCode("DHCEQCApprFlowStepAction",0))'=0    w "^DHCEQCCode(""DHCEQCApprFlowStepAction"",0)替换完成",!
	i $d(^DHCEQCCode("DHCEQEquipStatus",0))'=0 	  	  	  w "^DHCEQCCode(""DHCEQEquipStatus"",0)替换完成",!
	i $d(^DHCEQCCode("DHCEQMCMaintGroup",0))'=0 	  	  w "^DHCEQCCode(""DHCEQMCMaintGroup"",0)替换完成",!
	i $d(^DHCEQCCode("DHCEQMCMaintGroupList",0))'=0   	  w "^DHCEQCCode(""DHCEQMCMaintGroupList"",0)替换完成",!
	i $d(^DHCEQCCode("DHCEQMCMaintResults",0))'=0  	  	  w "^DHCEQCCode(""DHCEQMCMaintResults"",0)替换完成",!
	i $d(^DHCEQPMReport("0"))'=0 	  	  			  	  w "^DHCEQPMReport(""0"")替换完成",!
	i $d(^DHCEQPMReportList("0"))'=0   	   	  		      w "^DHCEQPMReportList(""0"")替换完成",!
}

}
