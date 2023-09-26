Class DHCEPRFS.BL.BLMetaLifeCycle Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 查询Meta表数据
ClassMethod QueryMetaTable(ATableName As %String) As %XML.DataSet
{
	s tableName = $zcvt(ATableName,"U")
	s rowID = ""
	s rowID = $o(^DHCEPRFS.META.ConfigMetaLCI("IdxTableName"," "_tableName,rowID))
	s obj = ##class(DHCEPRFS.META.ConfigMetaLC).%OpenId(rowID)
	s className = obj.ClassName
	s queryName = obj.QueryFunction
	d obj.%Close()
	s ds = ##class(%XML.DataSet).%New(className_":"_queryName)
	q ds
}

/// Desc: 添加日志信息
/// Debug: w ##class(DHCEPRFS.BL.BLMetaLifeCycle).AddLCLogDetail("DHCEPRFS.META.MRAction","3","TestAction","HIS","286","UPDATE","SCAN","PRINT")
ClassMethod AddLCLogDetail(ATableName As %String, AFieldRowID As %String, AFieldName As %String, AActUserType As %String, AActUserCode As %String, AActType As %String, AOldValue As %String, ANewValue As %String)
{
	s:(AFieldName = $c(0)) AFieldName = ""
	s:(AOldValue = $c(0)) AOldValue = ""
	s:(ANewValue = $c(0)) ANewValue = ""
	
	s objLog = ##class(DHCEPRFS.INST.MetaLCManageLog).%New()
	s objLog.TableName = ATableName
	s tableName = $zcvt(ATableName,"U")
	s tableRowID = ""
	s tableRowID = $o(^DHCEPRFS.META.ConfigMetaLCI("IdxTableName"," "_tableName,tableRowID))
	q:(tableRowID = "") ""
	s objLog.TableRowID = tableRowID
	s objLog.FieldRowID = AFieldRowID
	s objLog.FieldName = AFieldName
	s objLog.ActDate = $p($h,",",1)
	s objLog.ActTime = $p($h,",",2)
	s objLog.ActUserType = AActUserType
	s objLog.ActUserCode = AActUserCode
	s objLog.ActType = AActType
	s objLog.OldValue = AOldValue
	s objLog.NewValue = ANewValue
	
	s sc = objLog.%Save()
	d objLog.%Close()
	if ($$$ISERR(sc))
	{
		q ""
	}
	else
	{
		q objLog.%Id()
	}
}

/// Desc: 增加记录并创建日志
/// Debug: w ##class(DHCEPRFS.BL.BLMetaLifeCycle).AddRecord("DHCEPRFS.META.OptionTest","HIS","742","OptionName=Test3,OptionDesc=测试3,OptionType=CLIENT,OptionValue=3")
ClassMethod AddRecord(ATableName As %String, AActUserType As %String, AActUserCode As %String, AProperties As %String) As %String
{
	s flag = "true"
	TSTART
	s $zt = "OnAddRecordErrorHandler"
	
	s cmdCreateCls = "obj=##class("_ATableName_").%New()"
	s @cmdCreateCls
	
	f i=1:1:$l(AProperties,"$$$")
	{
		s keyValue = $p(AProperties,"$$$",i)
		s property = $p(keyValue,"=",1)
		s value = $e(keyValue,$find(keyValue,"="),*)
		continue:(property = "ID")
		
		s type = ##class(DHCEPRFS.BL.BLMetaLifeCycle).GetPropertyType(ATableName,property)
		s formatValue = value
		//对日期、时间类型的字段进行格式转换
		if (value '= "")&&(type = "%Library.Date")
		{
			s formatValue = $zdh(value,3)
		}
		elseif (value '= "")&&(type = "%Library.Time")
		{
			s formatValue = $zth(value)
		}
		
		s cmdLetValue = "obj."_property_"="""_formatValue_""""
		s @cmdLetValue
	}
	
	s cmdSave = "obj.%Save()"
	d @cmdSave
	s cmdID = "recordID=obj.%Id()"
	s @cmdID
	s recordID = @"recordID"
	
	if (recordID '= "")
	{
		s logID = ..AddLCLogDetail(ATableName,recordID,"",AActUserType,AActUserCode,"ADD","",AProperties)
		if (logID = "")
		{
			s flag = "false"
		}
	}
	else
	{
		s flag = "false"
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q recordID
	}
	else
	{
		TROLLBACK
		q "0"
	}
OnAddRecordErrorHandler
	TROLLBACK
	q "-1"
}

/// Desc: 更新记录并创建日志
/// Debug: w ##class(DHCEPRFS.BL.BLMetaLifeCycle).UpdateRecord("DHCEPRFS.META.OptionTest","23","HIS","742","OptionName=Test3,OptionDesc=测试3,OptionType=CLIENT,OptionValue=3")
ClassMethod UpdateRecord(ATableName As %String, AFieldRowID As %String, AActUserType As %String, AActUserCode As %String, AProperties As %String) As %String
{
	s flag = "true"
	TSTART
	s $zt = "OnUpdateRecordErrorHandler"
	
	s cmdOpenCls = "obj=##class("_ATableName_").%OpenId("""_AFieldRowID_""")"
	s @cmdOpenCls
	
	f i=1:1:$l(AProperties,"$$$")
	{
		s keyValue = $p(AProperties,"$$$",i)
		s property = $p(keyValue,"=" ,1)
		s newValue = $e(keyValue,$find(keyValue,"="),*)	//有些数值中有=号，需要取后半截
		s cmdGetValue = "oldValue=obj."_property
		s @cmdGetValue
		s oldValue = @"oldValue"
		
		s type = ##class(DHCEPRFS.BL.BLMetaLifeCycle).GetPropertyType(ATableName,property)
		s formatNewValue = newValue
		s formatOldValue = oldValue
		//对日期、时间类型的字段进行格式转换
		if (type = "%Library.Date")
		{
			if (newValue '= "")
			{
				s newValue = $zdh(newValue,3)
			}
			if (formatOldValue '= "")
			{
				s formatOldValue = $zd(formatOldValue,3)
			}
		}
		elseif (type = "%Library.Time")
		{
			if (newValue '= "")
			{
				s newValue = $zth(newValue)
			}
			if (formatOldValue '= "")
			{
				s formatOldValue = $zt(formatOldValue)
			}
		}
		
		s cmdLetValue = "obj."_property_"="""_newValue_""""
		s @cmdLetValue
		if (newValue '= oldValue)
		{
			s logID = ..AddLCLogDetail(ATableName,AFieldRowID,property,AActUserType,AActUserCode,"UPDATE",formatOldValue,formatNewValue)
			if (logID = "")
			{
				s flag = "false"
			}
		}
	}
	s cmdSave = "ret=obj.%Save()"
	s @cmdSave
	s ret = @"ret"
	s cmdClose = "obj.%Close()"
	d @cmdClose
	if ($$$ISERR(ret))
	{
		s flag = "false"
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q "1"
	}
	else
	{
		TROLLBACK
		q "0"
	}
OnUpdateRecordErrorHandler
	TROLLBACK
	q "-1"
}

/// Desc: 删除记录并创建日志
/// Debug: w ##class(DHCEPRFS.BL.BLMetaLifeCycle).DelRecord("DHCEPRFS.META.OptionTest","28","HIS","742")
ClassMethod DelRecord(ATableName As %String, AFieldRowID As %String, AActUserType As %String, AActUserCode As %String) As %String
{
	s flag = "true"
	TSTART
	s $zt = "OnDelRecordErrorHandler"
	
	s rowFields = ..GetRowFields(ATableName,AFieldRowID)
	s logID = ..AddLCLogDetail(ATableName,AFieldRowID,"",AActUserType,AActUserCode,"DELETE",rowFields,"")
	if (logID '= "")
	{
		s cmdDel = "##class("_ATableName_").%DeleteId("_AFieldRowID_")"
		d @cmdDel
	}
	else
	{
		s flag = "false"
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q "1"
	}
	else
	{
		TROLLBACK
		q "0"
	}
OnDelRecordErrorHandler
	TROLLBACK
	q "-1"
}

/// Desc: 返回表的指定行各属性字段组成的字符串
/// Debug: w ##class(DHCEPRFS.BL.BLMetaLifeCycle).GetRowFields("DHCEPRFS.META.OptionTest","23")
ClassMethod GetRowFields(ATableName As %String, ARowID As %String) As %String
{
	s properties = ..GetClassProperties(ATableName)
	s cmdOpenCls = "obj=##class("_ATableName_").%OpenId("""_ARowID_""")"
	s @cmdOpenCls
	
	s ret = ""
	f i=1:1:$l(properties,",")
	{
		s property = $p(properties,",",i)
		
		s cmdGetValue="value=obj."_property
		s @cmdGetValue
		s value = @"value"
		//对日期、时间类型的字段进行格式转换
		s type = ##class(DHCEPRFS.BL.BLMetaLifeCycle).GetPropertyType(ATableName,property)
		if ((type = "%Library.Date") && (value '= ""))
		{
			s value = $zd(value,3)
		}
		elseif ((type = "%Library.Time") && (value '= ""))
		{
			s value = $zt(value)
		}
		
		if (ret '= "")
		{
			s ret = ret_"$$$"_property_"="_value
		}
		else
		{
			s ret = property_"="_value
		}
	}
	s cmdClose="obj.%Close()"
	d @cmdClose
	q ret
}

/// Desc: 表日志查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLifeCycle","GetMetaLCManageLog","DHCEPRFS.META.MRAction")
Query GetMetaLCManageLog(TableName As %String) As %Query(ROWSPEC = "FieldRowID:%String,FieldName:%String,ActDate:%String,ActTime:%String,ActUserName:%String,ActType:%String,OldValue:%String,NewValue:%String")
{
}

ClassMethod GetMetaLCManageLogExecute(ByRef qHandle As %Binary, TableName As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s tableName = $zcvt(TableName,"U")
	s tableRowID = ""
	s tableRowID = $o(^DHCEPRFS.META.ConfigMetaLCI("IdxTableName"," "_tableName,tableRowID))
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.INST.MetaLCManageLogI("IndexMain"," "_tableRowID,rowID))
		q:(rowID = "")
		s objLog = ##class(DHCEPRFS.INST.MetaLCManageLog).%OpenId(rowID)
		s fieldRowID = objLog.FieldRowID
		s fieldName = objLog.FieldName
		s actDate = $zd(objLog.ActDate,3)
		s actTime = $zt(objLog.ActTime)
		s userType = objLog.ActUserType
		s userCode = objLog.ActUserCode
		s userRowID = ""
		s userRowID = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserCode"," "_userType," "_$zcvt(userCode,"U"),userRowID))
		s objQueryUser = ##class(DHCEPRFS.META.QueryUser).%OpenId(userRowID)
		s actUserName = objQueryUser.UserName
		d objQueryUser.%Close()
		s actType = objLog.ActType
		s oldValue = objLog.OldValue
		s newValue = objLog.NewValue
		
		d objLog.%Close()
		s ^CacheTemp(repid,ind) = $lb(fieldRowID,fieldName,actDate,actTime,actUserName,actType,oldValue,newValue)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetMetaLCManageLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMetaLCManageLogExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMetaLCManageLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMetaLCManageLogExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 表指定属性日志查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLifeCycle","GetPropertyLog","DHCEPRFS.META.MRAction","3")
Query GetPropertyLog(TableName As %String, FieldRowID As %String) As %Query(ROWSPEC = "FieldRowID:%String,FieldName:%String,ActDate:%String,ActTime:%String,ActUserName:%String,ActType:%String,OldValue:%String,NewValue:%String")
{
}

ClassMethod GetPropertyLogExecute(ByRef qHandle As %Binary, TableName As %String, FieldRowID As %String) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s tableName = $zcvt(TableName,"U")
	s tableRowID = ""
	s tableRowID = $o(^DHCEPRFS.META.ConfigMetaLCI("IdxTableName"," "_tableName,tableRowID))
	s date = ""
	f {
		s date = $o(^DHCEPRFS.INST.MetaLCManageLogI("IndexFieldRowID"," "_tableRowID," "_FieldRowID,date))
		q:(date = "")
		s time = ""
		f {
			s time = $o(^DHCEPRFS.INST.MetaLCManageLogI("IndexFieldRowID"," "_tableRowID," "_FieldRowID,date,time))
			q:(time = "")
			s rowID = ""
			f {
				s rowID = $o(^DHCEPRFS.INST.MetaLCManageLogI("IndexFieldRowID"," "_tableRowID," "_FieldRowID,date,time,rowID))
				q:(rowID = "")
				s objLog = ##class(DHCEPRFS.INST.MetaLCManageLog).%OpenId(rowID)
				s fieldRowID = objLog.FieldRowID
				s fieldName = objLog.FieldName
				s actDate = $zd(objLog.ActDate,3)
				s actTime = $zt(objLog.ActTime)
				s userType = objLog.ActUserType
				s userCode = objLog.ActUserCode
				s userRowID = ""
				s userRowID = $o(^DHCEPRFS.META.QueryUserI("IdxTypeUserCode"," "_userType," "_$zcvt(userCode,"U"),userRowID))
				s objQueryUser = ##class(DHCEPRFS.META.QueryUser).%OpenId(userRowID)
				s actUserName = objQueryUser.UserName
				d objQueryUser.%Close()
				s actType = objLog.ActType
				s oldValue = objLog.OldValue
				s newValue = objLog.NewValue
				
				d objLog.%Close()
				s ^CacheTemp(repid,ind) = $lb(fieldRowID,fieldName,actDate,actTime,actUserName,actType,oldValue,newValue)
				s ind = ind + 1
			}
		}
	}
	
	q $$$OK
}

ClassMethod GetPropertyLogFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPropertyLogExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPropertyLogClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPropertyLogExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 配置表查询
/// Debug: d ##class(%ResultSet).RunQuery("DHCEPRFS.BL.BLMetaLifeCycle","GetMetaLCConfig")
Query GetMetaLCConfig() As %Query(ROWSPEC = "表名:%String,配置名:%String,类名:%String,Query名:%String,是否启用:%String,字段:%String")
{
}

ClassMethod GetMetaLCConfigExecute(ByRef qHandle As %Binary) As %Status
{
	s repid = $I(^CacheTemp)
	s qHandle = $lb(0,repid,0)
	s ind = 1
	
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.ConfigMetaLCD(rowID))
		q:(rowID = "")
		s objConfig = ##class(DHCEPRFS.META.ConfigMetaLC).%OpenId(rowID)
		s tableName = objConfig.TableName
		s configName = objConfig.ConfigName
		s className = objConfig.ClassName
		s queryFunction = objConfig.QueryFunction
		s isActive = objConfig.IsActive
		s fields = objConfig.Fields
		d objConfig.%Close()
		s ^CacheTemp(repid,ind) = $lb(tableName,configName,className,queryFunction,isActive,fields)
		s ind = ind + 1
	}
	
	q $$$OK
}

ClassMethod GetMetaLCConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMetaLCConfigExecute ]
{
	Set AtEnd = $LIST(qHandle,1)
	Set repid = $LIST(qHandle,2)
	Set ind = $LIST(qHandle,3)
	Set ind = $o(^CacheTemp(repid,ind))
	If ind = "" {				// if there are no more rows, finish fetching
		Set AtEnd = 1
		Set Row = ""
		kill ^CacheTemp(repid)
	}
	Else      {				// fetch row
		Set Row = ^CacheTemp(repid,ind)
	}
	// Save QHandle
	s qHandle = $lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetMetaLCConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMetaLCConfigExecute ]
{
	Set repid = $LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Desc: 配置表更新，包括增加和修改
/// Debug: w ##class(DHCEPRFS.BL.BLMetaLifeCycle).UpdateConfigTable("DHCEPRFS.META.TableTest","测试表","DHCEPRFS.BL.BLTest","QueryTest","Y")
ClassMethod UpdateConfigTable(ATableName As %String, AConfigName As %String, AClassName As %String, AQueryFunction As %String, AIsActive As %String, AFields As %String) As %String
{
	s tableName = $zcvt(ATableName,"U")
	s tableRowID = ""
	s tableRowID = $o(^DHCEPRFS.META.ConfigMetaLCI("IdxTableName"," "_tableName,tableRowID))
	if (tableRowID '= "")
	{
		s objConfig = ##class(DHCEPRFS.META.ConfigMetaLC).%OpenId(tableRowID)
		s objConfig.ConfigName = AConfigName
		s objConfig.ClassName = AClassName
		s objConfig.QueryFunction = AQueryFunction
		s objConfig.IsActive = AIsActive
		s objConfig.Fields = AFields
	}
	else
	{
		s objConfig = ##class(DHCEPRFS.META.ConfigMetaLC).%New()
		s objConfig.TableName = ATableName
		s objConfig.ConfigName = AConfigName
		s objConfig.ClassName = AClassName
		s objConfig.QueryFunction = AQueryFunction
		s objConfig.IsActive = AIsActive
		s objConfig.Fields = AFields
	}
	s sc = objConfig.%Save()
	d objConfig.%Close()
	if ($$$ISERR(sc))
	{
		q ""
	}
	else
	{
		q objConfig.%Id()
	}
}

/// Desc: 配置表更新的事务处理
ClassMethod UpdateMetaLCConfig(ATableName As %String, AConfigName As %String, AClassName As %String, AQueryFunction As %String, AIsActive As %String, AFields As %String) As %String
{
	s flag = "true"
	
	TSTART
	s $zt = "OnUpdateConfigErrorHandler"
	
	s configID = ..UpdateConfigTable(ATableName, AConfigName, AClassName, AQueryFunction, AIsActive, AFields)
	if (configID = "")
	{
		s flag = "false"
	}
	
	if (flag = "true")
	{
		TCOMMIT
		q "1"
	}
	else
	{
		TROLLBACK
		q "0"
	}
OnUpdateConfigErrorHandler
	TROLLBACK
	q ""
}

/// Desc: 根据类名得到类的Query名,类名对大小写敏感
/// Input: ClassName：类名
/// Return: Query名连接成的String,以","分隔
/// Debug: w ##class(DHCEPRFS.BL.BLMetaLifeCycle).GetClassQueries("DHCEPRFS.BL.BLMetaLCQuery")
ClassMethod GetClassQueries(ClassName As %String) As %String
{
	s result = ""
	s obj = ##Class(%Dictionary.CompiledClass).%OpenId(ClassName)
	if (obj = "")
	{
		q ""
	}
	s cnt = obj.Queries.Count()
	f i=1:1:cnt 
	{
		s pdef = obj.Queries.GetAt(i)
		s QueryName = pdef.Name
		s item = ""
		s item = ..FilterIlleaglChar(pdef.Name)
		if (result '= "")
		{
			s result = result_","_item
		}
		else
		{
			s result = item
		}  
	}
	d obj.%Close()
	q result
}

/// Desc: 根据类名得到类的属性,类名对大小写敏感
/// Input: ClassName：类名
/// Return: 属性名连接成的String,以","分隔
/// Debug: w ##class(DHCEPRFS.BL.BLMetaLifeCycle).GetClassProperties("DHCEPRFS.META.SysOption")
ClassMethod GetClassProperties(ClassName As %String) As %String
{
	s result = ""
	s obj = ##Class(%Dictionary.CompiledClass).%OpenId(ClassName)
	if (obj = "")
	{
		q ""
	}
	s cnt = obj.Properties.Count()
	f i=1:1:cnt
	{
		s pdef = obj.Properties.GetAt(i)
		s PropertyName = pdef.Name
		s item = ""
		if (PropertyName '= "%Concurrency") && (PropertyName '= "%IsInSave") && (pdef.Private '= 1)
		{
			s item = ..FilterIlleaglChar(pdef.Name)
			if (result '= "")
			{
				s result = result_","_item
			}
			else
			{
				s result = item
			}
		}
	}
	
	d obj.%Close()
	q result
}

/// Desc: 返回类中某个属性的类型
/// Input: AClassName: 类名,APropertyName: 属性名
/// Debug: w ##class(DHCEPRFS.BL.BLMetaLifeCycle).GetPropertyType("DHCEPRFS.META.OptionTest","CreateDate")
ClassMethod GetPropertyType(AClassName As %String, APropertyName As %String) As %String
{
	s result = ""
	s obj = ##Class(%Dictionary.CompiledClass).%OpenId(AClassName)
	if (obj = "")
	{
		q ""
	}
	s cnt = obj.Properties.Count()
	f i=1:1:cnt
	{
		s pdef = obj.Properties.GetAt(i)
		if (pdef.Name = APropertyName) && (pdef.Private '= 1)
		{
			s result = pdef.Type
		}
	}
	
	d obj.%Close()
	q result
}

ClassMethod FilterIlleaglChar(txt As %String) As %String
{
	s txt = $tr(txt,$c(10),"")
	s txt = $tr(txt,$c(13),"")
	s txt = $tr(txt,"""","\""")
	q txt
}

/// Desc: 对当前时间点所有配置生命周期管理的表创建备份
/// Debug:w ##class(DHCEPRFS.BL.BLMetaLifeCycle).CreateMetaBackups()
ClassMethod CreateMetaBackups() As %String
{
	s dateNow = $p($h,",",1)
	s timeNow = $p($h,",",2)
	s rowID = ""
	f {
		s rowID = $o(^DHCEPRFS.META.ConfigMetaLCD(rowID))
		q:(rowID = "")
		s objConfig = ##class(DHCEPRFS.META.ConfigMetaLC).%OpenId(rowID)
		s tableName = objConfig.TableName
		d objConfig.%Close()
		d ..CreateBackupsDtl(dateNow,timeNow,tableName)
	}
	q $zd(dateNow,3)_","_$zt(timeNow)_","_dateNow_","_timeNow
}

/// Desc: 使用Global单独存储表的每一行每一列的数据
/// Debug: d ##class(DHCEPRFS.BL.BLMetaLifeCycle).CreateBackupsDtl("64341","51569","DHCEPRFS.META.MRStatus")
ClassMethod CreateBackupsDtl(ACreateDate As %String, ACreateTime As %String, ATableName As %String)
{
	s rowID = ""
	s cmdInit = "rowID="""""
	s @cmdInit
	f {
		s cmdOrder = "rowID=$o(^"_ATableName_"D(rowID))"
		s @cmdOrder
		s rowID = @"rowID"
		q:(rowID = "")
		s cmdCls = "objDtl=##class("_ATableName_").%OpenId(rowID)"
		s @cmdCls
		
		s properties = ..GetClassProperties(ATableName)
		f i=1:1:$l(properties,",")
		{
			s property = $p(properties,",",i)
			s cmdLetValue = "^DHCEPRFS.MetaBackups("""_ACreateDate_""","""_ACreateTime_""","""_ATableName_""",rowID,"""_property_""")=objDtl."_property
			s @cmdLetValue
		}
		
		s cmdClose = "objDtl.%Close()"
		d @cmdClose
	}
}

}
