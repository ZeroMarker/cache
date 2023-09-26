Class web.DHCBL.KB.KPICondConfig Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2015-2-26
/// Description：查询知识库度量数据来源
/// Table：%IHBI.KBaseConfig
/// Input：rowid, tableName
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.KPICondConfig","GetTypeList","ARC_BillSub","")
Query GetTypeList(tableName, desc) As %Query(ROWSPEC = "TypeRowID,TypeName")
{
}

ClassMethod GetTypeListExecute(ByRef qHandle As %Binary, tableName, desc) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:desc'="" desc=$ZCONVERT(desc,"U")
	
	if (tableName="DHC_TarCate"){ //User.DHCTarCate
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^DHCTarC("CC",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^DHCTarC("CC",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}	
	elseif (tableName="PHC_Poison"){ //User.PHCPoison
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^PHCPO(TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^PHCPO(TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}	
		}
	}	
	elseif (tableName="PHC_Instruc"){ //User.PHCInstruc
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^PHCIN(TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^PHCIN(TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}
		}
	} 
	elseif (tableName="OEC_OrderCategory"){ //User.OECOrderCategory
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^OEC("ORCAT",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^OEC("ORCAT",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}			
		}
	}
	elseif (tableName="PAC_AdmReason"){ //User.OECOrderCategory
		s TypeRowID=0
		for  
		{	
			s TypeRowID=$o(^PAC("ADMREA",TypeRowID)) q:TypeRowID="" 
			s TypeName=$p($g(^PAC("ADMREA",TypeRowID)),"^",2)  
			s TypeNameU=$ZCONVERT(TypeName,"U")
			i (TypeNameU[desc){  
				d OutputRow		
			}			
		}
	}
	else{              //自定义
		if (tableName'=""){
			s TypeRowID=""
			s TypeName=""
			d OutputRow
		}
	}
	/*
	elseif (tableName="DHC_ItmAddionInfo"){ //User.DHCItmAddionInfo自定义
		s TypeRowID=""
		s TypeName=""
		d OutputRow
	}
	*/
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(TypeRowID,TypeName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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
/// CreatDate: 2015-3-9
/// Description：查询KPI指标条件明细
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.KBaseConfig","GetList","3")
Query GetList(code As %String) As %Query(ROWSPEC = "KPIRowId,TableCode,TypeRowID,TypeName,Flag,GroupTypeName,ADMType,StartDate,EndDate,Condition,SavedFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, code As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
		s:code'="" code=$ZCONVERT(code,"U")
		s KPIRowId=0
		for  
		{	
			s KPIRowId=$o(^IHBI.KPICondConfigD(KPIRowId)) q:KPIRowId="" 
			
			s KPICode=$listget($g(^IHBI.KPICondConfigD(KPIRowId)),1)  //代码
			s KPICodeU=$ZCONVERT(KPICode,"U")
			s TableCode=$listget($g(^IHBI.KPICondConfigD(KPIRowId)),5)  //表编码
			s TypeRowID=$listget($g(^IHBI.KPICondConfigD(KPIRowId)),6)  //表对应数据RowID
			s TypeName=$listget($g(^IHBI.KPICondConfigD(KPIRowId)),7)  //表对应数据名称
			s Flag=$listget($g(^IHBI.KPICondConfigD(KPIRowId)),8)  //有效标志
			s GroupTypeName=$listget($g(^IHBI.KPICondConfigD(KPIRowId)),9)  //表对应数据组名称
			s ADMType=$listget($g(^IHBI.KPICondConfigD(KPIRowId)),10)  //就诊类型
			s StartDate=$listget($g(^IHBI.KPICondConfigD(KPIRowId)),11)  //开始日期
			s:StartDate'="" StartDate=$zd(StartDate,1)
			s EndDate=$listget($g(^IHBI.KPICondConfigD(KPIRowId)),12)  //截止日期
			s:EndDate'="" EndDate=$zd(EndDate,1)
			s Condition=$listget($g(^IHBI.KPICondConfigD(KPIRowId)),13)  //附加Condition
			s SavedFlag=$listget($g(^IHBI.KPICondConfigD(KPIRowId)),14)  //指标是否导入标志
		
			i (code'="")&&(KPICodeU[code)   //条件
			{
				d OutputRow
			}		
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(KPIRowId,TableCode,TypeRowID,TypeName,Flag,GroupTypeName,ADMType,StartDate,EndDate,Condition,SavedFlag)
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
/// CreatDate: 2015-2-27
/// Description：添加KPI指标条件明细
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.KPICondConfig).SaveData("'010006^1^全院药品总收入^DHC_TarCate^8^床位费1")
ClassMethod SaveData(config As %String) As %String
{
	s result = ""
	s KPICode=$p(config,"^",1) //KPICode
	s KPIDR=$p(config,"^",2) //KPIDR
    s KPIName=$p(config,"^",3) //KPIName
    s TableName=$p(config,"^",4) //TableName
    s TypeRowID=$p(config,"^",5) //TypeRowID
    s TypeName=$p(config,"^",6) //TypeName
    
	s KPICodeU=$ZCONVERT(KPICode,"U")
    s TableNameU=$ZCONVERT(TableName,"U")

    s id = $o(^IHBI.KPICondConfigI("UqKPICodeIdx"," "_KPICodeU," "_TableNameU," "_TypeRowID,0))
	if (id'="") Quit "{success:'false',info:'该记录已存在'}" 
	Ts
	
	s obj=##class(%IHBI.KPICondConfig).%New()
	s obj.KPICode=KPICode
	d obj.KPIDRSetObjectId(KPIDR)
	s obj.KPIName=KPIName
	s obj.TableName=TableName
	s obj.TypeRowID=TypeRowID
	s obj.TypeName=TypeName
	s obj.Flag="Y"
	s obj.GroupTypeName=" "
	s obj.ADMType="A"
	s obj.SavedFlag="Y"

	s logJson="{KPICode:"_$c(34)_KPICode_$c(34)_",KPIDR:"_$c(34)_KPIDR_$c(34)_",KPIName:"_$c(34)_KPIName_$c(34)_",TableName:"_$c(34)_TableName_$c(34)_",TypeRowID:"_$c(34)_TypeRowID_$c(34)_",TypeName:"_$c(34)_TypeName_$c(34)_"}"
	
	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc){	
		Tc		
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("%IHBI.KPICondConfig","%IHBI.KPICondConfig","KPI指标条件维护明细",id,TypeName,"A",logJson)
	}else{
		Trollback
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
	}
	q result
}

/// Creator:高姗姗
/// CreatDate: 2015-3-9
/// Description：KPI指标条件明细修改
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// d ##class(web.DHCBL.KB.KPICondConfig).Save("8^9^LAB")
ClassMethod Save(id As %String, TypeRowID As %String, TypeName As %String, TableCode As %String, GroupTypeName As %String, ADMType As %String, Flag As %String, StartDate As %String, EndDate As %String, Condition As %String, SavedFlag As %String) As %String
{
	s result = ""
	Ts
	s obj=##class(%IHBI.KPICondConfig).%OpenId(id)
	s obj.TypeRowID=TypeRowID
	s obj.TypeName=TypeName
	s obj.TableCode=TableCode
	s obj.GroupTypeName=GroupTypeName
	s obj.ADMType = ADMType
	s obj.Flag=Flag
	if (StartDate'=""){
		s obj.StartDate = $zdh(StartDate,15)
	}else{
		s obj.StartDate = ""	
	}
	if (EndDate'=""){
		s obj.EndDate = $zdh(EndDate,15)	
	}else{
		s obj.EndDate = ""	
	}
	s obj.Condition=Condition
	s obj.SavedFlag=SavedFlag
	if (Condition'=""){
		try{
			X "s str="_Condition
		}catch myvar{
			s result = myvar.Name
			;myvar.Name 会显示报错信息		
		}
	}
	if (result="<SYNTAX>")
	{
		s result="{success:'false',info:'condition语法错误，请验证后重新输入'}" 
	}	
	else
	{	
		s sc=obj.%Save()
		d obj.%Close()
	
		If $$$ISOK(sc){	
			Tc		
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
		}else{
			Trollback
			s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
		}
	}
	q result
}

/// Creator:高姗姗
/// CreatDate:2015-3-5
/// Description:根据id删除
/// Table:%IHBI.KPICondConfig
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.KPICondConfig).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""
		Tstart
		s eobj = ##class(web.Entity.KB.KPICondConfig).%New()
		s pobj = ##class(%IHBI.KPICondConfig).%OpenId(id)
		s eobj.KPIRowId = id
		s eobj.KPICode = pobj.KPICode
		s eobj.KPIDR = pobj.KPIDR.%Id()
		s eobj.KPIName = pobj.KPIName
		s eobj.TableName = pobj.TableName
		s eobj.TableCode = pobj.TableCode
		s eobj.TypeRowID = pobj.TypeRowID
		s eobj.TypeName = pobj.TypeName
		s eobj.Flag = pobj.Flag
		s eobj.GroupTypeName = pobj.GroupTypeName
		s eobj.ADMType = pobj.ADMType
		s eobj.StartDate = pobj.StartDate
		s eobj.EndDate = pobj.EndDate
		s eobj.Condition = pobj.Condition
		s eobj.SavedFlag = pobj.SavedFlag
	
		s sc=##class(%IHBI.KPICondConfig).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("%IHBI.KPICondConfig","%IHBI.KPICondConfig","KPI指标条件定义表",id,eobj.KPIName,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
		}
	q result
}

}
