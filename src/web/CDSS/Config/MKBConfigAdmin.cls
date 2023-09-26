Class web.CDSS.Config.MKBConfigAdmin Extends %RegisteredObject
{

/// Creator：
/// CreatDate: 2014-9-1
/// Description：修改时打开的数据
/// Table：CF.WDT.CDSS.MKBConfig
/// Input：id
/// Other: w ##class(web.CDSS.Config.MKBConfigAdmin).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.CDSSEntity.Config.MKBConfigAdmin).%New()
	s eobj.ID = id
	s eobj.ConfigCode=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),1)
	s eobj.ConfigDesc=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),2)
	s eobj.ConfigValue=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),3)
	s eobj.ConfigType=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),4)
	s eobj.ConfigExplain=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),5)
	s eobj.ConfigActive=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),6)
	s eobj.ConfigEdit=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),7)
	s eobj.ConfigCategory=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),8)
	s:eobj.ConfigCategory'="" eobj.ConfigCategoryDesc=$lg($g(^CF.WDT.CDSS.ConfigCategoryD(eobj.ConfigCategory)),3)	//配置分类描述
	s eobj.ConfigVersion=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),9)
	//s:eobj.ConfigActive="Y" eobj.ConfigActive="true"
	//s:eobj.ConfigEdit="Y" eobj.ConfigEdit="true"
	if ((eobj.ConfigType="C")&&(eobj.ConfigValue="Y")){
		s eobj.ConfigValue="true"
	}
	s str = eobj.JsonS()	
	d eobj.%Close()
	//s str = "{list:["_str_"]}"
	q str
}

/// Creator：chendailei
/// CreatDate: 2019-8-25
/// Description：查询基础配置的内容
/// Table：CF.WDT.CDSS.MKBConfig
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.CDSS.Config.MKBConfigAdmin","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,ConfigCode:%String,ConfigDesc:%String,ConfigValue:%String,ConfigType:%String,ConfigExplain:%String,ConfigActive:%String,ConfigEdit:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s ConfigCode=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),1)
		s ConfigDesc=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),2)
		s ConfigValue=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),3)
		s ConfigType=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),4)
		s ConfigExplain=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),5)
		s ConfigActive=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),6)
		s ConfigEdit=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),7)
		s ConfigCategory=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),8)
		w ConfigDesc,!
		if (ConfigType="D"){
			s:ConfigValue'="" ConfigValue=$zd(ConfigValue,1)
		}
		if (ConfigType="CB"){
			s:ConfigValue'="" ConfigValue=$p($g(^SSU("SSGRP",ConfigValue)),"^",1)
		}
		d OutputRow
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s ID=0
		for {
			s ID=$o(^CF.WDT.CDSS.MKBConfigD(ID))
			q:ID=""
			s ConfigCode=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),1)
			s ConfigDesc=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),2)
			s ConfigValue=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),3)
			s ConfigType=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),4)
			s ConfigExplain=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),5)
			s ConfigActive=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),6)
			s ConfigEdit=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),7)
			s ConfigCategory=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),8)
			if (ConfigType="D"){
				s:ConfigValue'="" ConfigValue=$zd(ConfigValue,1)
			}
			/*if (ConfigType="CB"){
				s:ConfigValue'="" ConfigValue=$p($g(^SSU("SSGRP",ConfigValue)),"^",1)
			}*/
			if ($ZCONVERT(ConfigCode,"U")[code)&($ZCONVERT(ConfigDesc,"U")[desc)
			{
				d OutputRow
			}
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,ConfigCode,ConfigDesc,ConfigValue,ConfigType,ConfigExplain,ConfigActive,ConfigEdit)
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

/// Function:数据重复校验
/// Creator:Zhaowenwei
/// CreateDate:2022-05-26    
/// w ##class(web.CDSS.Config.MKBConfigAdmin).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CF.WDT.CDSS.MKBConfigI("ConfigCodeI",code))
	s:desc'="" flagd=$d(^CF.WDT.CDSS.MKBConfigI("ConfigDescI",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CF.WDT.CDSS.MKBConfigI("ConfigCodeI",code,0))
		s:desc'="" idd=$o(^CF.WDT.CDSS.MKBConfigI("ConfigDescI",desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Creator：
/// CreatDate: 2019-8-25
/// Description：保存基础配置的内容
/// Table：CF.WDT.CDSS.MKBConfig
/// Input：web.CDSSEntity.Config.MKBConfigAdmin
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.Config.MKBConfigAdmin).SaveData()
ClassMethod SaveData(eobj As web.CDSSEntity.Config.MKBConfigAdmin) As %String
{
	s $zt="ERROE"
	s result="",flag=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.ID,eobj.ConfigCode,eobj.ConfigDesc)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
			if (eobj.ID="")  //如果RowId未赋值则增加
			{
				s obj=##class(CF.WDT.CDSS.MKBConfig).%New()
			}
			else                     //如果RowId已赋值则修改
			{
				s obj=##class(CF.WDT.CDSS.MKBConfig).%OpenId(eobj.ID)
				s bobj=##class(web.CDSSEntity.Config.MKBConfigAdmin).%New()
				s bobj.ID=eobj.ID
				s bobj.ConfigCode=obj.ConfigCode
				s bobj.ConfigDesc=obj.ConfigDesc
				s bobj.ConfigType=obj.ConfigType
				s bobj.ConfigValue=obj.ConfigValue
				s bobj.ConfigExplain=obj.ConfigExplain
				s bobj.ConfigActive=obj.ConfigActive
				s bobj.ConfigEdit=obj.ConfigEdit
				//s bobj.ConfigCategory=obj.ConfigCategory
				s:obj.ConfigCategory'="" bobj.ConfigCategory = obj.ConfigCategory.%Id() 	//配置分类
				s bobj.ConfigVersion=obj.ConfigVersion		//配置项所属版本
			}
			Ts
			s obj.ConfigCode = eobj.ConfigCode         //修改代码
			s obj.ConfigDesc = eobj.ConfigDesc         //修改描述
			if ((eobj.ConfigType="D")&&(eobj.ConfigValue'="")){
				s eobj.ConfigValue=$zdh(eobj.ConfigValue,15)  
			}  
			/*if ((eobj.ConfigType="C")&&(eobj.ConfigValue="")){
				s eobj.ConfigValue="N"
			}*/
			s obj.ConfigValue = eobj.ConfigValue   //修改值
			s obj.ConfigExplain = eobj.ConfigExplain  
			s obj.ConfigType = eobj.ConfigType
			//s:eobj.ConfigActive="true" eobj.ConfigActive="Y"
			s:eobj.ConfigActive="" eobj.ConfigActive="N" 
			s obj.ConfigActive = eobj.ConfigActive 
			
			//s:eobj.ConfigEdit="true" eobj.ConfigEdit="Y"
			s:eobj.ConfigEdit="" eobj.ConfigEdit="N"    
			s obj.ConfigEdit = eobj.ConfigEdit
			//s obj.ConfigCategory=eobj.ConfigCategory
			d obj.ConfigCategorySetObjectId(eobj.ConfigCategory)				//配置分类
			s obj.ConfigVersion=eobj.ConfigVersion		//配置项所属版本
	
			s sc=obj.%Save()
			d obj.%Close()
			If $$$ISOK(sc)
			{
				Tc
				s id = obj.%Id()
				s result = "{success:'true',id:'"_id_"'}"  //返回RowId
				//新增时，日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("MKBConfig","CF.WDT.CDSS.MKBConfig","基础配置组内应用",id,eobj.ConfigDesc,"A",eobj)
				//修改时，日志
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("MKBConfig","CF.WDT.CDSS.MKBConfig","基础配置组内应用",eobj.ID,eobj.ConfigDesc,"U",eobj,bobj)
			}
			else
			{
				Trollback
				s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
				s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("基础配置组内应用","web.CDSS.Config.MKBConfigAdmin","SaveData",eobj)
     			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		}				
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}
	q result
ERROE
    s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("基础配置组内应用","web.CDSS.Config.MKBConfigAdmin","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
	q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：
/// CreatDate: 2014-9-2
/// Description：根据ID删除基础配置的内容
/// Table：CF.WDT.CDSS.MKBConfig2
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
	s result = ""
	//new Entity对象，用于保存日志
	s eobj = ##class(web.CDSSEntity.Config.MKBConfigAdmin).%New()
	s eobj.ID = id
	s eobj.ConfigCode=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),1)
	s eobj.ConfigDesc=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),2)
	s eobj.ConfigValue=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),3)
	s eobj.ConfigType=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),4)
	s eobj.ConfigExplain=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),5)
	s eobj.ConfigActive=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),6)
	s eobj.ConfigEdit=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),7)
	s eobj.ConfigCategory=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),8)
	s eobj.ConfigVersion=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),9)
	
	Tstart
	s sc=##class(CF.WDT.CDSS.MKBConfig).%DeleteId(id)
	if $$$ISOK(sc)
	{
		Tcommit
		s result = "{success:'true',info:'删除成功！'}"	
		//保存日志
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("MKBCONFIG","CF.WDT.CDSS.MKBConfig","基础配置组内应用",id,eobj.ConfigDesc,"D",eobj)
		d eobj.%Close()
	}
	else 
	{
		Trollback
		s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("基础配置组内应用","web.CDSS.Config.MKBConfigAdmin","DeleteData",eobj)
		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	}
	q result
}

}
