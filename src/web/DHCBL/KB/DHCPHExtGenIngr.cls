Class web.DHCBL.KB.DHCPHExtGenIngr Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2014-11-10
/// Description：查询药品通用名成分明细表内容
/// Table：User.DHCPHExtGenIngr
/// Input：rowid, ingr, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGenIngr","GetList","","","","","")
Query GetNewList(rowid, gen) As %Query(ROWSPEC = "PHEGIRowId,PHEGIPHEGDr,PHEGDesc,PHEGILevel,PHEGIIngrDr,PHEGISysFlag,PHEGIIngrDrF,PHEGILevelF,PHEGISysFlagF")
{
}

ClassMethod GetNewListExecute(ByRef qHandle As %Binary, rowid, gen) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtGeneric).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	s AuFlag=0
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEGIRowId=rowid
		s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)  //通用名Dr
		s:PHEGIPHEGDr'="" PHEGDesc=$p($g(^DHCPHEGEN(PHEGIPHEGDr)),"^",2) //通用名名称 
		s PHEGILevel=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",3)  //主要成分标识
		s PHEGIIngrDrF=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)  //成分DR
		s:PHEGIIngrDrF'="" PHEGIIngrDr=$LISTGET($G(^User.DHCPHExtIngrD(PHEGIIngrDrF)),3)  //成分名称
		s:PHEGIIngrDrF="" PHEGIIngrDr=""  //成分名称
		s PHEGISysFlag=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",4)  //是否系统标识
		s:PHEGISysFlag'="N" PHEGISysFlag="Y"
		s PHEGILevelF=""
		s PHEGISysFlagF=""		
		
		d OutputNewRow
	}
	else
	{	
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s PHEGIRowId=0
		for  
		{	
			s PHEGIRowId=$o(^DHCPHEGENIN(PHEGIRowId)) q:PHEGIRowId="" 
			
			s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)  //通用名Dr
			s PHEGIPHEGDrU=$ZCONVERT(PHEGIPHEGDr,"U")
			s strRowId = "{ID:"_PHEGIPHEGDrU_"}"
			i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			{
				s:PHEGIPHEGDr'="" PHEGDesc=$p($g(^DHCPHEGEN(PHEGIPHEGDr)),"^",2) //通用名名称 
				s PHEGILevel=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",3)  //主要成分标识
				s PHEGIIngrDrF=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)  //成分DR
				s:PHEGIIngrDrF'="" PHEGIIngrDr=$LISTGET($G(^User.DHCPHExtIngrD(PHEGIIngrDrF)),3)  //成分名称
				s:PHEGIIngrDrF="" PHEGIIngrDr=""  //成分名称
				s PHEGISysFlag=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",4)  //是否系统标识
				s:PHEGISysFlag'="N" PHEGISysFlag="Y"
				s PHEGILevelF=""
				s PHEGISysFlagF=""
		
				i ((PHEGIPHEGDrU=gen)||(gen=""))   //条件
				{
					d OutputNewRow
				}		
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputNewRow
    set Data=$lb(PHEGIRowId,PHEGIPHEGDr,PHEGDesc,PHEGILevel,PHEGIIngrDr,PHEGISysFlag,PHEGIIngrDrF,PHEGILevelF,PHEGISysFlagF)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetNewListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNewListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetNewListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNewListExecute ]
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

/// Creator：高姗姗
/// CreatDate: 2014-11-10
/// Description：查询药品通用名成分明细表内容
/// Table：User.DHCPHExtGenIngr
/// Input：rowid, ingr, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtGenIngr","GetList","","","","","")
Query GetList(rowid, gen) As %Query(ROWSPEC = "PHEGIRowId,PHEGIPHEGDr,PHEGDesc,PHEGILevel,PHEGIIngrDr,PHEINGDesc,PHEGISysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, gen) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//获取授权Json
	//s AuStr=##class(web.DHCBL.Authorize.SSUser).DHCGetDataByDefaultSession()
	;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
	;假设未授权情况下默认全部显示数据
	//s AuFlag=0
	//if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s PHEGIRowId=rowid
		s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)  //通用名Dr
		s:PHEGIPHEGDr'="" PHEGDesc=$p($g(^DHCPHEGEN(PHEGIPHEGDr)),"^",2) //通用名名称 
		s PHEGILevel=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",3)  //主要成分标识
		s PHEGIIngrDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)  //成分DR
		s:PHEGIIngrDr'="" PHEINGDesc=$LISTGET($G(^User.DHCPHExtIngrD(PHEGIIngrDr)),3)  //成分名称
		s:PHEGIIngrDr="" PHEINGDesc=""  //成分名称
		s PHEGISysFlag=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",4)  //是否系统标识
		s:PHEGISysFlag'="N" PHEGISysFlag="Y"
		
		d OutputRow
	}
	else
	{	
		s:gen'="" gen=$ZCONVERT(gen,"U")
		s PHEGIRowId=0
		for  
		{	
			s PHEGIRowId=$o(^DHCPHEGENIN(PHEGIRowId)) q:PHEGIRowId="" 
			s strRowId = "{ID:"_PHEGIRowId_"}"
			//i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
			//{
				s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)  //通用名Dr
				s PHEGIPHEGDrU=$ZCONVERT(PHEGIPHEGDr,"U")
				s:PHEGIPHEGDr'="" PHEGDesc=$p($g(^DHCPHEGEN(PHEGIPHEGDr)),"^",2) //通用名名称 
				s PHEGILevel=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",3)  //主要成分标识
				s PHEGIIngrDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)  //成分DR
				s:PHEGIIngrDr'="" PHEINGDesc=$LISTGET($G(^User.DHCPHExtIngrD(PHEGIIngrDr)),3)  //成分名称
				s:PHEGIIngrDr="" PHEINGDesc=""  //成分名称
				s PHEGISysFlag=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",4)  //是否系统标识
				s:PHEGISysFlag'="N" PHEGISysFlag="Y"
				
				i ((PHEGIPHEGDrU=gen)||(gen=""))   //条件
				{
					d OutputRow
				}		
			//}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(PHEGIRowId,PHEGIPHEGDr,PHEGDesc,PHEGILevel,PHEGIIngrDr,PHEINGDesc,PHEGISysFlag)
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2015-2-8 
/// w ##class(web.DHCBL.KB.DHCPHExtGenIngr).FormValidate("","6","2")
ClassMethod FormValidate(id As %String, gen As %String, text As %String) As %String
{
	s flag=""
	s flagd=""
	s flagd=$d(^DHCPHEGENINi(0,"GenIngr",gen,text))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0)
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""	
		s idd=$o(^DHCPHEGENINi(0,"GenIngr",gen,text,0))
		if ((idd'=id)&(flagd>0))
		{
			s flag=1  //返回重复标志
		}
		else
		{
			s flag=0 //返回不重复标志
		}
	}
	q flag
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCPHExtGenIngr
/// Input：web.Entity.KB.DHCPHExtGenIngr 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHExtGenIngr) As %String
{
	
 s result = ""

	if $IsObject(eobj)
	{
		
		s flag=..FormValidate(eobj.PHEGIRowId,eobj.PHEGIPHEGDr,eobj.PHEGIIngrDr)  //调用重复验证
 		if (flag=1)
  		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  		}
  		else{
			if (eobj.PHEGIRowId="")  //如果RowId未赋值则增加
			{
				s obj=##class(User.DHCPHExtGenIngr).%New()
			}
			else  //如果RowId已赋值则修改
			{
				s obj=##class(User.DHCPHExtGenIngr).%OpenId(eobj.PHEGIRowId)
				s bobj = ##class(web.Entity.KB.DHCPHExtGenIngr).%New()
				s bobj.PHEGIRowId = eobj.PHEGIRowId
				s:obj.PHEGIPHEGDr'="" bobj.PHEGIPHEGDr = obj.PHEGIPHEGDr.%Id()
				s bobj.PHEGILevel=  obj.PHEGILevel
				s:obj.PHEGIIngrDr'="" bobj.PHEGIIngrDr = obj.PHEGIIngrDr.%Id()
				s bobj.PHEGISysFlag = obj.PHEGISysFlag
			}
	
			d:eobj.PHEGIPHEGDr'="" obj.PHEGIPHEGDrSetObjectId(eobj.PHEGIPHEGDr)
			d:eobj.PHEGIPHEGDr="" obj.PHEGIPHEGDrSetObjectId("")
			s obj.PHEGILevel = eobj.PHEGILevel
			d:eobj.PHEGIIngrDr'="" obj.PHEGIIngrDrSetObjectId(eobj.PHEGIIngrDr)
			d:eobj.PHEGIIngrDr="" obj.PHEGIIngrDrSetObjectId("")	
			i eobj.PHEGISysFlag="Y"
			{
				s obj.PHEGISysFlag = "Y"
			}
			else
			{
				s obj.PHEGISysFlag = "N"
			}
			Ts
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc){
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}" //返回RowId
				d:eobj.PHEGIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtGenIngr","User.DHCPHExtGenIngr","药品通用名成分明细",id,eobj.PHEGILevel,"A",eobj)
				d:eobj.PHEGIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtGenIngr","User.DHCPHExtGenIngr","药品通用名成分明细",eobj.PHEGIRowId,eobj.PHEGILevel,"U",eobj,bobj)
			}else{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
				s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品通用名成分明细","web.DHCBL.KB.DHCPHExtGenIngr","SaveData",eobj)
				s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}	
		}
	}	

	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：获取修改时的记录
/// Table：User.DHCPHExtGenIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHExtGenIngr).OpenData()
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHExtGenIngr).%New()
	s pobj = ##class(User.DHCPHExtGenIngr).%OpenId(id)
	s eobj.PHEGIRowId = id
	s:pobj.PHEGIPHEGDr'="" eobj.PHEGIPHEGDr = pobj.PHEGIPHEGDr.%Id()
	s eobj.PHEGILevel = pobj.PHEGILevel
	s:pobj.PHEGIIngrDr'="" eobj.PHEGIIngrDr = pobj.PHEGIIngrDr.%Id()
	s:pobj.PHEGISysFlag="Y" eobj.PHEGISysFlag="true"	

	s str = eobj.JsonS()	
	s str = "{data:["_str_"]}"
	q str
}

/// Creator：丁亚男
/// CreatDate: 2018-07-26
/// Description：获取修改时的记录
/// Table：User.DHCPHExtGenIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHExtGenIngr).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.KB.DHCPHExtGenIngr).%New()
	s pobj = ##class(User.DHCPHExtGenIngr).%OpenId(id)
	s eobj.PHEGIRowId = id
	s:pobj.PHEGIPHEGDr'="" eobj.PHEGIPHEGDr = pobj.PHEGIPHEGDr.%Id()
	s eobj.PHEGILevel = pobj.PHEGILevel
	s:pobj.PHEGIIngrDr'="" eobj.PHEGIIngrDr = pobj.PHEGIIngrDr.%Id()
	
	s eobj.PHEGISysFlag=pobj.PHEGISysFlag	
	s:pobj.PHEGISysFlag'="N" eobj.PHEGISysFlag="Y"
	
	s str = eobj.JsonS()	
	;s str = "{data:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCPHExtGenIngr
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHExtGenIngr).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s return="",myInfo=""

		Tstart
		s eobj = ##class(web.Entity.KB.DHCPHExtGenIngr).%New()
		s pobj = ##class(User.DHCPHExtGenIngr).%OpenId(id)
		s eobj.PHEGIRowId = id
		s:pobj.PHEGIPHEGDr'="" eobj.PHEGIPHEGDr = pobj.PHEGIPHEGDr.%Id()
		s eobj.PHEGILevel = pobj.PHEGILevel
		s:pobj.PHEGIIngrDr'="" eobj.PHEGIIngrDr = pobj.PHEGIIngrDr.%Id()	
		s eobj.PHEGISysFlag = pobj.PHEGISysFlag
	
		s sc=##class(User.DHCPHExtGenIngr).%DeleteId(id)
		if $$$ISOK(sc){
			Tcommit
			s result="{success:'true',info:'删除成功！'}"
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtGenIngr","User.DHCPHExtGenIngr","药品通用名成分明细",id,eobj.PHEGILevel,"D",eobj)
		}
		else{
			Trollback
			s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品通用名成分明细","web.DHCBL.KB.DHCPHExtGenIngr","DeleteData",eobj)
			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	q result
}

/// Creator:高姗姗
/// CreatDate:2016-8-25
/// Description:获取批量设定药品列表
/// w ##class(web.DHCBL.KB.DHCPHExtGenIngr).GetTreeJson("menuTreeRoot","10","3",0,20,"","")
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK) As %String
{
	if (ParentID="menuTreeRoot") s ParentID=-100000000000000

	s myJsonStr=""
	
	s rowid=0
	s count=0
	s end=start+limit
	s desc=""
	//获取已选JSON
	s AuStr=..GetBatchJson(ObjectType,ObjectReference)
	s rowid=0
	for  
	{	
		s rowid=$o(^DHCPHEGEN(rowid)) q:rowid="" 

		s code=$p($g(^DHCPHEGEN(rowid)),"^",1)  //代码
		s desc=$p($g(^DHCPHEGEN(rowid)),"^",2)  //描述
		s LibDr=$p($g(^DHCPHEGEN(rowid)),"^",7)  //知识库标识DR

		//过滤已选、未选
		s AuStr2="{ID:"_rowid_"}"
		if (FilterCK="checked") {
			if (AuStr[AuStr2) 
			else  continue
		}
		elseif (FilterCK="unchecked") {
			if (AuStr[AuStr2) continue
			else  
		}
		
		if ($ZCONVERT(desc,"U")[$ZCONVERT(query,"U"))&(LibDr=ObjectType){
			s count=count+1
			if ((count>start) & (count<=end)) || (end=0) {
				s AuStr2="{ID:"_rowid_"}"
				if (AuStr[AuStr2) s myEnable=1
				else  s myEnable=0
				
				s:(myJsonStr'="") myJsonStr=myJsonStr_","
				s myJsonStr=myJsonStr_"{"
				s myJsonStr=myJsonStr_"""id"":"""_""_rowid_""",""text"":"""_desc_""","
				
				if (+myEnable) {
					s myJsonStr=myJsonStr_"""checked"":true,"
				}else {
					s myJsonStr=myJsonStr_"""checked"":false,"
				}
				s myJsonStr=myJsonStr_"""leaf"":true"
				s myJsonStr=myJsonStr_"}"
			}
		}
	}
	s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"
	q myJsonStr
}

/// Creator:高姗姗
/// CreatDate:2016-8-25
/// Description:获取批量设定药品已选列表
/// Other:w ##class(web.DHCBL.KB.DHCPHExtGenIngr).GetBatchJson("","5")
ClassMethod GetBatchJson(ObjectType As %String, ObjectReference As %String) As %String
{
	s str=""
	s PHEGIRowId=0
	for  
	{	
		s PHEGIRowId=$o(^DHCPHEGENIN(PHEGIRowId)) q:PHEGIRowId="" 
		s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)  //通用名Dr
		s PHEGIIngrDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)  //成分DR
		if (PHEGIIngrDr=ObjectReference){
			if (str=""){
				s str="{ID:"_PHEGIPHEGDr_"}"
			}
			else{
				s str=str_",{ID:"_PHEGIPHEGDr_"}"
			}
		}
	}
	s str="{IDS:["_str_"]}"
	q str
}

/// Creator:高姗姗
/// CreatDate:2016-8-25
/// Description:批量设定药品保存方法
/// Other:w ##class(web.DHCBL.KB.DHCPHExtGenIngr).SaveBatchData("10","2","{IDS:[{ID:82},{ID:23},{ID:24}]}")
ClassMethod SaveBatchData(ObjectType As %String, ObjectReference As %String, Data As %String) As %String
{
	s flag=""
	;"{IDS:[{ID:1},{ID:2},{ID:3}]}"
	;{ID:1},{ID:2},{ID:3}
	s Data = $e(Data,7,*-2)
	s ^TMP("data")=Data
	if (Data=""){
		s PHEGIRowId=0
		for  
		{	
			s PHEGIRowId=$o(^DHCPHEGENIN(PHEGIRowId)) q:PHEGIRowId="" 
			s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)  //通用名Dr
			s PHEGIIngrDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)  //成分DR
			if (PHEGIIngrDr=ObjectReference){
				s id = $o(^DHCPHEGENINi(0,"GEN",PHEGIPHEGDr,0))
				s return = ..DeleteData(id)	
				if (return["true"){
					s flag=0	
				}
			}
		}
	}
	else{
		s PHEGIRowId=0
		for  
		{	
			s PHEGIRowId=$o(^DHCPHEGENIN(PHEGIRowId)) q:PHEGIRowId="" 
			s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)  //通用名Dr
			s PHEGIIngrDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)  //成分DR
			if (PHEGIIngrDr=ObjectReference){
				s PHEGIPHEG="{ID:"_PHEGIPHEGDr_"}"
				if (Data[PHEGIPHEG){
				}
				else{
					s id = $o(^DHCPHEGENINi(0,"GEN",PHEGIPHEGDr,0))
					s return = ..DeleteData(id)	
					if (return["true"){
						s flag=0	
					}
				}
			}
		}
	
		s len=$Length(Data,",")
		for i=1:1:len
		{
			s GenData=$p(Data,",",i)
			s eobj = ##class(web.Entity.KB.DHCPHExtGenIngr).%New()
			s eobj.PHEGIPHEGDr = $e(GenData,5,*-1)
			s eobj.PHEGIIngrDr = ObjectReference	
			s eobj.PHEGISysFlag = "Y"
			s return= ..SaveData(eobj)
			if (return["true"){
				s flag=0	
			}
		}
	}
	if (flag=0){
		s result = "{msg:"_flag_"}" //保存成功
	}else{
		s result = "{msg:"_flag_"}"
	}
	q result
}

/// Creator:丁亚男
/// CreatDate:2018-8-15
/// Description:获取批量设定药品列表
/// w ##class(web.DHCBL.KB.DHCPHExtGenIngr).NewGetTreeJson("","10","6")
ClassMethod NewGetTreeJson(ParentID As %String, DrugId As %String, CatID As %String) As %String
{
	if (ParentID="") s ParentID=-100000000000000

	s myJsonStr=""
	
	s rowid=0
	s count=0
	w "["
	s desc=""
	//获取已选JSON
	s AuStr=..GetBatchJson(DrugId,CatID)
	s rowid=0
	for  
	{	
		s rowid=$o(^DHCPHEGEN(rowid)) q:rowid="" 
		s code=$p($g(^DHCPHEGEN(rowid)),"^",1)  //代码
		s desc=$p($g(^DHCPHEGEN(rowid)),"^",2)  //描述
		s desc = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(desc)
		s LibDr=$p($g(^DHCPHEGEN(rowid)),"^",7)  //知识库标识DR
		
		s PHNDesc=""
		s Id=0
		for  
		{	
			s Id=$o(^DHCPHPNA(0,"Gen",rowid,Id)) q:Id="" //药品商品名字典
			s PHNDesc=$p($g(^DHCPHPNA(Id)),"^",2) 
		}
		
		
		if (LibDr=DrugId){
			s count=count+1	
			s AuStr2="{ID:"_rowid_"}"
			if (AuStr[AuStr2) s myEnable=1
			else  s myEnable=0
			
			if count>1 w ","
			w "{"
			if (PHNDesc=""){
				 w """id"":"""_""_rowid_""",""text"":"""_desc_""","
			}else{
				s PHNDesc = ##class(web.DHCBL.BDP.FunLib).EvalJSONB(PHNDesc)
				w """id"":"""_""_rowid_""",""text"":"""_desc_"("_PHNDesc_")"","
			}
			
			if (+myEnable) {
				w """checked"":true,"
			}else {
				w """checked"":false,"
			}
			//列表型 没有子节点
			w """state"":""open"""
			w "}"
		}
	}
	w "]"
	q ""
}

/// Creator:丁亚男
/// CreatDate:2018-8-15
/// Description:批量设定药品保存方法
/// Other:w ##class(web.DHCBL.KB.DHCPHExtGenIngr).NewSaveBatchData("10","69","5","0")
ClassMethod NewSaveBatchData(DrugId As %String, CatID As %String, Data As %String, checked) As %String
{
	s result="",flag=""
	if (Data="") { q:"请选择药品名！" }
	if ((checked="true")||(checked="1"))
	{
		/*s PHEGIRowId=0
		for  
		{	
			s PHEGIRowId=$o(^DHCPHEGENIN(PHEGIRowId)) q:PHEGIRowId="" 
			s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)  //通用名Dr
			s PHEGIIngrDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)  //成分DR
			
			if (PHEGIIngrDr=CatID)
			{
				if (Data=PHEGIPHEGDr)
				{
				}
				else
				{
					s eobj = ##class(web.Entity.KB.DHCPHExtGenIngr).%New()
					s eobj.PHEGIPHEGDr = Data
					s eobj.PHEGIIngrDr = CatID	
					s eobj.PHEGISysFlag = "Y"
					s return= ..SaveData(eobj)
					if (return["true"){
						s flag=0	
					}
				}
			}
		}	
		
		if (flag=0)
		{
			s result = "{msg:"_flag_"}" //保存成功
		}
		else
		{
			s result = "{msg:"_flag_"}"
		}*/
		s eobj = ##class(web.Entity.KB.DHCPHExtGenIngr).%New()
		s eobj.PHEGIPHEGDr = Data
		s eobj.PHEGIIngrDr = CatID	
		s eobj.PHEGISysFlag = "Y"
		s return= ..SaveData(eobj)
		if (return["true"){
			s flag=0	
		}
		if (flag=0)
		{
			s result = "{msg:"_flag_"}" //保存成功
		}
		else
		{
			s result = "{msg:"_flag_"}"
		}
		
	}
	else
	{
		s PHEGIRowId=0 
		for  
		{	
			s PHEGIRowId=$o(^DHCPHEGENIN(PHEGIRowId)) q:PHEGIRowId="" 
			s PHEGIPHEGDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",1)  //通用名Dr
			s PHEGIIngrDr=$p($g(^DHCPHEGENIN(PHEGIRowId)),"^",2)  //成分DR
			if (PHEGIIngrDr=CatID)
			{
				if (Data=PHEGIPHEGDr)
				{
					s id = $o(^DHCPHEGENINi(0,"GEN",PHEGIPHEGDr,0))
					s return = ..DeleteData(id)	
					if (return["true")
					{
						s flag=0	
					}
				}
			}	
	
		if (flag=0)
		{
			s result = "{msg:"_flag_"}" //保存成功
		}
		else
		{
			s result = "{msg:"_flag_"}"
		}			
	  }
	}
	q result
}

}
