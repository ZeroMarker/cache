/// 名称:版本字典表(诊断/手术)
/// 描述:包含增删改查功能
/// 编写者：鲁俊文 陈莹
/// 编写日期: 2022-10-24
Class web.DHCBL.CT.BDVersionDict Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:鲁俊文
/// CreatDate:2022-10-24
/// Description：查询版本字典表
/// Table：CT_BDP_CT.BDVersionDict
/// Input：rowid,code,desc,type(类型)
/// Return: ID:RowId Type:类型 VersionCode:版本代码 VersionName:版本名称 DateFrom:开始日期 DateTo:结束日期 IsSyncToMr:同步到病案系统 IsChineseMedicineFlag:中医数据标识 IsInsuFlag:中医数据标识
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDVersionDict","GetList","","","","")	
Query GetList(rowid As %String, code As %String, desc As %String, type As %String) As %Query(ROWSPEC = "ID:%String,Type:%String,VersionCode:%String,VersionName:%String,DateFrom:%String,DateTo:%String,IsSyncToMr:%String,IsChineseMedicineFlag:%String,IsInsuFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (rowid'="") //根据rowid返回该条记录
	{
    	s ID=rowid                                     ///RowID
	    s Type=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),2)  ///类型
	    s VersionCode=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),3)  ///版本代码
	    s VersionName=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),4)   ///版本名称
	    s DateFrom=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),5)     ///开始日期  
	    s DateTo=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),6) ///结束日期
	    s:DateFrom'="" DateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateFrom) ///开始日期 
    	s:DateTo'="" DateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateTo) ///结束日期
		s IsSyncToMr=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),7) ///同步到病案系统
		s IsChineseMedicineFlag=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),8) //中医数据标识
		s IsInsuFlag=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),9) //医保数据标识
	    d OutputRow
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	    s:type'="" type=$ZCONVERT(type,"U") //转换成大写
	    s ID=0
    	for 
    	{
	        s ID=$o(^CT.BDP.CT.BDVersionDictD(ID)) q:ID=""  ///RowID
	        s Type=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),2)  ///类型
	    	s VersionCode=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),3)  ///版本代码
	    	s VersionName=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),4)   ///版本名称
	    	s DateFrom=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),5)     ///开始日期  
	    	s DateTo=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),6) ///结束日期
	    	s:DateFrom'="" DateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateFrom) ///开始日期 
    		s:DateTo'="" DateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateTo) ///结束日期
			s IsSyncToMr=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),7) ///同步到病案系统
			s IsChineseMedicineFlag=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),8) ///中医数据标识
			s IsInsuFlag=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),9) //医保数据标识
	    	s PINYIN=""
	        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(VersionName)
	        if ($ZCONVERT(VersionCode,"U")[code)&&(($ZCONVERT(VersionName,"U")[desc)||(PINYIN[desc))&&(($ZCONVERT(Type,"U")[type))
        	{
	        	d OutputRow
        	} 
    	}
	}


	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ID,Type,VersionCode,VersionName,DateFrom,DateTo,IsSyncToMr,IsChineseMedicineFlag,IsInsuFlag)
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

/// Creator:鲁俊文
/// CreatDate:2022-09-09
/// Description:为combobox查询取数据 版本字典
/// Table：CT_BDP_CT.BDVersionDict
/// Input：rowid,code,desc,type
/// Return: ID:RowId Type:类型 VersionCode:代码  VersionName：名称 IsInsuFlag:医保数据标识
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDVersionDict","GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, type As %String) As %Query(ROWSPEC = "ID:%String,Type:%String,VersionCode:%String,VersionName:%String,IsInsuFlag:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
	if (rowid'="") //根据rowid返回该条记录
	{
    	s ID=rowid                                     ///RowID
	    s Type=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),2)  ///类型
	    s VersionCode=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),3)  ///版本代码
	    s VersionName=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),4)   ///版本名称
	    s IsInsuFlag=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),9) //医保数据标识
	    d OutputRowCmb
	}
	else
	{
	    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	    s:type'="" type=$ZCONVERT(type,"U") //转换成大写
	    s ID=0
    	for 
    	{
	        s ID=$o(^CT.BDP.CT.BDVersionDictD(ID)) q:ID=""  ///RowID
	        s Type=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),2)  ///类型
	    	s VersionCode=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),3)  ///版本代码
	    	s VersionName=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),4)   ///版本名称
	    	s IsInsuFlag=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),9) //医保数据标识
	    	s DateFrom=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),5)     ///开始日期  
	    	s DateTo=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),6) ///结束日期
	    	continue:(DateFrom'="")&&(DateFrom>+$h)
	    	continue:(DateTo'="")&&(DateTo<+$h)
			s PINYIN=""
	        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(VersionName)
	        if ($ZCONVERT(VersionCode,"U")[code)&&(($ZCONVERT(VersionName,"U")[desc)||(PINYIN[desc))&&($ZCONVERT(Type,"U")[type)
        	{
	        	d OutputRowCmb
        	} 
    	}
	}


	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCmb
	set Data=$lb(ID,Type,VersionCode,VersionName,IsInsuFlag)
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

/// Creator:陈莹
/// CreatDate:2022-12-22
/// Description:为combobox查询取版本类型数据
/// Table：CT_BDP_CT.BDVersionDict
/// Input：type
/// Return: Type:类型
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDVersionDict","GetTypeDataForCmb1","")
Query GetTypeDataForCmb1(type As %String) As %Query(ROWSPEC = "Type:%String")
{
}

ClassMethod GetTypeDataForCmb1Execute(ByRef qHandle As %Binary, type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1  
 	s Type=0
	for 
	{
        s Type=$o(^CT.BDP.CT.BDVersionDictI("TypeIndex",Type)) q:Type=""  ///RowID
        if ($ZCONVERT(Type,"U")[$ZCONVERT(type,"U"))
    	{
        	d OutputRowType
    	} 
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowType
	set Data=$lb(Type)
	set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod GetTypeDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTypeDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetTypeDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTypeDataForCmb1Execute ]
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

/// Creator:    鲁俊文
/// CreatDate:  2022-10-25
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串
/// Other: w ##class(web.DHCBL.CT.BDVersionDict).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.BDVersionDict).%New()
    s obj = ##class(CT.BDP.CT.BDVersionDict).%OpenId(id)
    s eobj.ID=id ///RowId
    s eobj.Type=obj.Type ///类型
    s eobj.VersionCode= obj.VersionCode ///版本代码
    s eobj.VersionName=obj.VersionName ///版本名称
    s:obj.DateFrom'="" eobj.DateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.DateFrom) ///开始日期 
    s:obj.DateTo'="" eobj.DateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.DateTo) ///结束日期
    s eobj.IsSyncToMr = obj.IsSyncToMr ///同步到病案系统
    s eobj.IsChineseMedicineFlag=obj.IsChineseMedicineFlag ///中医数据标识
    s eobj.IsInsuFlag=obj.IsInsuFlag ///医保数据标识
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-24
/// Description：重复校验
/// Table：CT_BDP_CT.BDVersionDict
/// Input：id code name
/// Others：w ##class(web.DHCBL.CT.BDVersionDict).FormValidate(1,"001","")
ClassMethod FormValidate(id As %String, code As %String, name As %String) As %String
{
	s flag=0
	if code'=""
	{
		s ID=$o(^CT.BDP.CT.BDVersionDictI("CodeIndex"," "_$ZCONVERT(code,"U"),0)) 
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	if name'=""
	{
		s ID=$o(^CT.BDP.CT.BDVersionDictI("NameIndex"," "_$ZCONVERT(name,"U"),0)) 
		if (ID'="")&&(id'=ID)
		{
			s flag=1
		}
	}
	q flag
}

/// Creator：鲁俊文
/// CreatDate: 2022年10月14日
/// function：测试对象数据存储
/// debug：d ##class(web.DHCBL.CT.BDVersionDict).SaveTest()
ClassMethod SaveTest()
{
	s eobj=##class(web.Entity.CT.BDVersionDict).%New()
	s eobj.Type="保存测试"
	s eobj.VersionCode="004"
	s eobj.VersionName="保存测试004"
	s eobj.DateFrom="2022-10-25"
	s eobj.DateTo=""
	s eobj.IsSyncToMr="Y"
	s eobj.IsChineseMedicineFlag="N"
	s eobj.IsInsuFlag="N"
	w ..SaveEntity(eobj)
}

/// Creator：鲁俊文
/// CreatDate: 2022-10-25
/// Description：保存版本字典信息
/// Table：CT_BDP_CT.BDVersionDict
/// Others：w ##class(web.DHCBL.CT.BDVersionDict).SaveEntity(eobj)
ClassMethod SaveEntity(eobj As web.Entity.CT.BDVersionDict) As %String
{
	s result=""
	if $IsObject(eobj)
	{
		s:eobj.DateFrom'="" eobj.DateFrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DateFrom)	//时间转换
	    s:eobj.DateTo'="" eobj.DateTo= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.DateTo)		//时间转换 
	    s:eobj.DateFrom="" eobj.DateFrom=+$h //取当前日期
	    s:eobj.IsSyncToMr="" eobj.IsSyncToMr="N"
	    s:eobj.IsChineseMedicineFlag="" eobj.IsChineseMedicineFlag="N"
	    s:eobj.IsInsuFlag="" eobj.IsInsuFlag="N"
		s flag=..FormValidate(eobj.ID,eobj.VersionCode,eobj.VersionName)  //调用重复验证
		if (flag=1)
		{
			q "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		if (eobj.ID="")
		{
			s obj=##class(CT.BDP.CT.BDVersionDict).%New()
		}
		else
		{
			s obj=##class(CT.BDP.CT.BDVersionDict).%OpenId(eobj.ID)
			
			s bobj=##class(web.Entity.CT.BDVersionDict).%New()
		    s bobj.ID=eobj.ID    ////RowId
		    s bobj.Type=obj.Type		///类型
			s bobj.VersionCode=obj.VersionCode		///版本代码
			s bobj.VersionName=obj.VersionName ///版本名称
			s bobj.DateFrom=obj.DateFrom ///开始日期
			s bobj.DateTo=obj.DateTo ///结束日期
			s bobj.IsSyncToMr=obj.IsSyncToMr //同步到病案系统
			s bobj.IsChineseMedicineFlag = obj.IsChineseMedicineFlag //中医数据标识	
			s bobj.IsInsuFlag = obj.IsInsuFlag //医保数据标识	
		}
		s obj.Type=eobj.Type //类型
		s obj.VersionName=eobj.VersionName		//版本名称
		s obj.VersionCode=eobj.VersionCode		//版本代码
		s obj.DateFrom= eobj.DateFrom     //开始日期
	    s obj.DateTo= eobj.DateTo 		 //结束日期
	    s obj.IsSyncToMr=eobj.IsSyncToMr //同步到病案系统
	    s obj.IsChineseMedicineFlag=eobj.IsChineseMedicineFlag ///中医数据标识
	    s obj.IsInsuFlag = eobj.IsInsuFlag //医保数据标识	
		TS
		s sc=obj.%Save()
		if (sc=1)
		{
			TC
			s id=obj.%Id()
			s result="{success:'true',id:'"_id_"'}"
			d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.BDVersionDict","CT.BDP.CT.BDVersionDict","版本字典",eobj.ID,eobj.Type_"-"_eobj.VersionName,"U",eobj,bobj) 
			d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.BDVersionDict","CT.BDP.CT.BDVersionDict","版本字典",id,eobj.Type_"-"_eobj.VersionName,"A",eobj) 
		}
		else
		{
			TRO
			s result="{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("版本字典","web.DHCBL.CT.BDVersionDict","SaveEntity",eobj) 
	        s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
}

/// Creator:陈莹
/// CreatDate:2022-12-22
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    if $d(^CT.BDP.CT.BDVersionDictInsuI("IndexDictInsu",id)){
        s myInfo=myInfo_"<版本字典表与医保对照的关联表>"
    }   
    if myInfo=""
    {
	    if $d(^CT.BDP.CT.BDVersionDictInsuI("IndexInsuDict",id))
	    {
	        s myInfo=myInfo_"<版本字典表与医保对照的关联表>"
	    }
    }
    i myInfo="" s return="0^未被引用可删除！"
    else  s return="1^在"_myInfo_"表里被引用,不能删除！"
    
    q return
}

/// Creator:鲁俊文
/// CreatDate:2022-10-24
/// Description：根据id删除数据
/// Table：CT_BDP_CT.BDVersionDict
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.BDVersionDict).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
	s result="" 
	s re=##class(web.DHCBL.CT.BDVersionDict).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag<0)
    {
	    s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
		//new Entity对象，用于保存日志
		s pobj = ##class(CT.BDP.CT.BDVersionDict).%OpenId(id)
		s eobj = ##class(web.Entity.CT.BDVersionDict).%New()
		s eobj.ID = id ///RowId
		s eobj.Type=pobj.Type ///类型
		s eobj.VersionCode=pobj.VersionCode ///版本代码
		s eobj.VersionName=pobj.VersionName ///版本名称
		s eobj.DateFrom=pobj.DateFrom ///开始日期
		s eobj.DateTo=pobj.DateTo ///结束日期
		s eobj.IsSyncToMr=pobj.IsSyncToMr ///同步到病案系统
		s eobj.IsChineseMedicineFlag=pobj.IsChineseMedicineFlag ///中医数据标识
		s eobj.IsInsuFlag=pobj.IsInsuFlag ///医保数据标识
		d pobj.%Close()
		k pobj
		Tstart
		s sc=##class(CT.BDP.CT.BDVersionDict).%DeleteId(id)
		if $$$ISOK(sc)
		{
		    Tcommit
		    s result = "{success:'true',info:'删除成功！'}"  
		    //保存日志
		    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.BDVersionDict","CT.BDP.CT.BDVersionDict","版本字典",id,eobj.Type_"-"_eobj.VersionName,"D",eobj)
		    d eobj.%Close()
		}
		else 
		{
		    Trollback
		    s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("版本字典","web.DHCBL.CT.BDVersionDict","DeleteData",eobj)
		    s ^ERRORLOGINFO(+logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
		} 
		q result
    }
}

/// Creator:    chenying
/// CreatDate:  2022-12-23
/// Description：获取版本id对应的类型
/// Input：     id 
/// Return:type
/// Other: w ##class(web.DHCBL.CT.BDVersionDict).GetTypeByRowId("1")
ClassMethod GetTypeByRowId(id As %String) As %String
{
	q:id="" ""
    s Type=$lg($g(^CT.BDP.CT.BDVersionDictD(id)),2)  ///类型
    q Type
}

/// Creator:    chenying
/// CreatDate:  2023-01-04
/// Description：根据版本id获取是否同步病案的接口
/// Input：     id 
/// Return:Y/N
/// Other: w ##class(web.DHCBL.CT.BDVersionDict).GetDictIsSyncToMr("1")
ClassMethod GetDictIsSyncToMr(id As %String) As %String
{
	q:id="" "N"
    s IsSyncToMr=$lg($g(^CT.BDP.CT.BDVersionDictD(id)),7) ///同步到病案系统
    s:IsSyncToMr="" IsSyncToMr="N"
    q IsSyncToMr
}

/// Creator:    chenying
/// CreatDate:  2023-01-18
/// Description：根据版本id获取所有信息
/// Input：     ID
/// Return: 类型^版本代码^版本名称^开始日期^结束日期^同步到病案系统^中医数据标识^医保数据标识
/// Other: w ##class(web.DHCBL.CT.BDVersionDict).GetDictInfoByRowId("1")
ClassMethod GetDictInfoByRowId(ID As %String) As %String
{
	q:ID="" "N"
    s Type=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),2)  ///类型
    s VersionCode=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),3)  ///版本代码
    s VersionName=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),4)   ///版本名称
    s DateFrom=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),5)     ///开始日期
    s DateTo=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),6) ///结束日期
    s:DateFrom'="" DateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateFrom) ///开始日期
	s:DateTo'="" DateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(DateTo) ///结束日期
	s IsSyncToMr=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),7) ///同步到病案系统
	s IsChineseMedicineFlag=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),8) //中医数据标识
	s IsInsuFlag=$lg($g(^CT.BDP.CT.BDVersionDictD(ID)),9) //医保数据标识
	s DictInfo=Type_"^"_VersionCode_"^"_VersionName_"^"_DateFrom_"^"_DateTo_"^"_IsSyncToMr_"^"_IsChineseMedicineFlag_"^"_IsInsuFlag
	q DictInfo
}

/// Creator:    chenying
/// CreatDate:  2022-12-23
/// Description：获取版本代码对应的版本rowid
/// Input：     code 
/// Return:rowid
/// Other: w ##class(web.DHCBL.CT.BDVersionDict).GetRowIdByCode("SSLCB1.0")
ClassMethod GetRowIdByCode(code As %String) As %String
{
	q:code="" ""
	s VersionID=$o(^CT.BDP.CT.BDVersionDictI("CodeIndex"," "_$ZCONVERT(code,"U"),0))
    q VersionID
}

/// Creator:    chenying
/// CreatDate:  2022-12-23
/// Description：获取版本代码对应的版本信息
/// Input：     code 
/// Return: 版本rowid^类型^版本代码^版本名称^开始日期^结束日期^同步到病案系统^中医数据标识^医保数据标识
/// Other: w ##class(web.DHCBL.CT.BDVersionDict).GetDictInfoByCode("SSLCB1.0")
ClassMethod GetDictInfoByCode(code As %String) As %String
{
	q:code="" ""
	s VersionID=$o(^CT.BDP.CT.BDVersionDictI("CodeIndex"," "_$ZCONVERT(code,"U"),0))
	q:VersionID="" ""
	s DictInfo=##class(web.DHCBL.CT.BDVersionDict).GetDictInfoByRowId(VersionID)
	s DictInfo=VersionID_"^"_DictInfo
    q DictInfo
}

}
