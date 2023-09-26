Import SQLUser

Class web.CDSS.Config.MKBConfig Extends %RegisteredObject
{

/// Description：打开数据
/// Table：CF.WDT.CDSS.MKBConfig
/// Input：id
/// Other: w ##class(web.CDSS.Config.MKBConfig).OpenData("")
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
  s eobj.ConfigCategoryDesc=$lg($g(^CF.WDT.CDSS.ConfigCategoryD(eobj.ConfigCategory)),3)	//配置分类描述
  s:eobj.ConfigActive="Y" eobj.ConfigActive="true"
  s:eobj.ConfigEdit="Y" eobj.ConfigEdit="true"
  if ((eobj.ConfigType="C")&&(eobj.ConfigValue="Y")){
    s eobj.ConfigValue="true"
  }
  if ((eobj.ConfigType="D")){
    s:eobj.ConfigValue'="" eobj.ConfigValue=$zd(eobj.ConfigValue,3)
  }
  if ((eobj.ConfigType="CB")){
    s:eobj.ConfigValue'="" eobj.ConfigValue=$p($g(^SSU("SSGRP",eobj.ConfigValue)),"^",1) //获取用户安全组描述
  }

  s str = eobj.JsonS()  
  d eobj.%Close()
  s str = "{""list"":["_str_"]}"
  q str
}

/// Function:保存修改
/// Others:w ##class(web.CDSS.Config.MKBConfig).SaveData()
ClassMethod SaveData(args As %String) As %String
{
  s result=""
  Ts
  s argsLen=$Length(args,";")
  for i=1:1:argsLen   
  {
          
      s MKBConfig=$p(args,";",i)  
      s ConfigCode=$p(MKBConfig,"^",1)
      s:ConfigCode'="" ConfigCode=$ZCONVERT(ConfigCode,"U")
      s ConfigValue=$p(MKBConfig,"^",2)
      s ConfigType=$p(MKBConfig,"^",3)
      if ((ConfigType="D")&&(ConfigValue'=""))
      {
        s ConfigValue=$zdh(ConfigValue,15)  
      }
      if (ConfigValue'="")
      {
 
        s id=$o(^CF.WDT.CDSS.MKBConfigI("ConfigCodeI"," "_ConfigCode,0))
        
        if ($List(^CF.WDT.CDSS.MKBConfigD(id),3)'=ConfigValue)
        {
          
          s obj=##class(CF.WDT.CDSS.MKBConfig).%OpenId(id)
          s bobj=##class(web.CDSSEntity.Config.MKBConfigAdmin).%New()
          s bobj.ID=id
          s bobj.ConfigCode=obj.ConfigCode
          s bobj.ConfigDesc=obj.ConfigDesc
          s bobj.ConfigType=obj.ConfigType
          s bobj.ConfigValue=obj.ConfigValue
          s bobj.ConfigExplain=obj.ConfigExplain
          s bobj.ConfigActive=obj.ConfigActive
          s bobj.ConfigEdit=obj.ConfigEdit 
          s bobj.ConfigCategory=obj.ConfigCategory       
            
          s $List(^CF.WDT.CDSS.MKBConfigD(id),3)=ConfigValue
          
          s eobj=##class(web.CDSSEntity.Config.MKBConfigAdmin).%New()
          s eobj.ID=id
          s eobj.ConfigCode=obj.ConfigCode
          s eobj.ConfigDesc=obj.ConfigDesc
          s eobj.ConfigType=obj.ConfigType
          s eobj.ConfigValue=ConfigValue
          s eobj.ConfigExplain=obj.ConfigExplain
          s eobj.ConfigActive=obj.ConfigActive
          s eobj.ConfigEdit=obj.ConfigEdit
          s eobj.ConfigCategory=obj.ConfigCategory
          
          //修改时，日志
          d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("MKBConfig","CF.WDT.CDSS.MKBConfig","平台配置",eobj.ID,eobj.ConfigDesc,"U",eobj,bobj)

          s result = result_"^"_1
        }
      }
      else
      {
        if (ConfigCode="MKBSSUSRGROUP")||(ConfigCode="MKBUSERPSW")||(ConfigCode="MKBUSERSIGNPSW")
        {
          s result = result_"^"_1
        }
        else
        {
          s result = result_"^"_0
        }       
      } 
  }
  if (result[0)
  {   
    Trollback
    s result = "{success:'false',errorinfo:'配置项的值不能为空！'}"     
  }
  else
  {
    Tc
    s result = "{success:'true',info:'修改成功！'}" 
    //s result = "{""list"":["_result_"]}" 
  }
      
  q result
}

/// Creator:chendailei
/// CreatDate:2012-9-12
/// Description:增加/修改 单位
/// Table:CF.WDT.CDSS.MKBConfig
/// Input:web.Entity.CT.CTUOM 实体类
/// Return:成功返回success:'true'和id;失败返回success:'false'和errorinfo
ClassMethod SaveEntity(eobj As web.CDSSEntity.Config.MKBConfigAdmin) As %String
{
	//n (eobj,%session)
	s result=""
	if $IsObject(eobj)
	{
		s flag= ##class(web.CDSS.Config.MKBConfig).FormValidate(eobj.ID,eobj.ConfigValue)
		if flag=1 q "{success:'false',errorinfo:'该记录已经存在！'}"
		if (eobj.ID="")       
		{
			s obj=##class(CF.WDT.CDSS.MKBConfig).%New()
		}
		else                           
		{
			s obj=##class(CF.WDT.CDSS.MKBConfig).%OpenId(eobj.ID)
			s bobj = ##class(web.CDSSEntity.Config.MKBConfigAdmin).%New()
			s bobj.ID = eobj.ID
			s bobj.ConfigCode = obj.ConfigCode
			s bobj.ConfigDesc = obj.ConfigDesc
			s bobj.ConfigValue = obj.ConfigValue
			//s bobj.CTUOMForeignDesc = obj.CTUOMForeignDesc
		}

		s obj.ConfigCode = eobj.ConfigCode
		s obj.ConfigDesc = eobj.ConfigDesc
		s obj.ConfigValue = eobj.ConfigValue
		//s obj.CTUOMForeignDesc = eobj.CTUOMForeignDesc
		
		Tstart
		s sc=obj.%Save()
		do obj.%Close()
		if $$$ISOK(sc){
			Tcommit
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}"
			d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("MKBConfig","CF.WDT.CDSS.MKBConfig","诊断短语来源",id,eobj.ConfigDesc,"A",eobj)
			d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("MKBConfig","CF.WDT.CDSS.MKBConfig","诊断短语来源",id,eobj.ConfigDesc,"U",eobj,bobj)
		}else{
			Trollback
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("诊断短语来源","web.CDSS.Config.MKBConfig","SaveEntity",eobj)
     		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
		}	
					
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	}	
	q result
}

/// Creator:陈代雷
/// CreatDate:2019-8-28
/// Description:获得诊断数据来源的所有内容
/// Table:User.MKBStructuredBase
/// Input:code : 配置项代码
/// Return:返回所有数据来源内容
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Config.MKBConfig","GetDataResource","CDSScdl2020072401")
Query GetDataResource(code As %String, desc As %String) As %Query(ROWSPEC = "id:%String,MKBSTBDesc:%String")
{
}

ClassMethod GetDataResourceExecute(ByRef qHandle As %Binary, code As %String, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s:desc'="" desc=$zconvert(desc,"U")
 	if (code="SDSDataSource")       //如果是诊断短语数据来源
 	{
	 	s RowId=0
 		s BaseId=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," ICD版本",0))
 		for
 		{
	 		s RowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",BaseId,RowId))
	 		q:RowId=""
	 		s FlagProRowId = $o(^CT.WDT.CDSS.TermPropertyI("DescIndex",RowId," 标识",0))  //获取标识属性id
	 		s FlagDetailRowId = $o(^CT.WDT.CDSS.TermProDetailI("ProIdx",FlagProRowId,0))   //获取标识属性内容id
	 		s Flag = $lg($g(^CT.WDT.CDSS.TermProDetailD(FlagDetailRowId)),3)  //获取标识
	 		continue:Flag'="诊断"
	 		s id="ICD"_RowId
	 		s MKBSTBDesc=$lg($g(^CT.WDT.CDSS.TermD(RowId)),3)
	 		d OutputRow8
 		}
 		s RowId=0
 		for
 		{
	 		s RowId=$o(^User.MKBStructuredBaseD(RowId))
	 		q:RowId=""
	 		s ODFlag = $lg($g(^User.MKBStructuredBaseD(RowId)),9)
	 		continue:ODFlag'="Diagnosis"
	 		s id=RowId
	 		s MKBSTBDesc=$lg($g(^User.MKBStructuredBaseD(RowId)),2)
	 		d OutputRow8
 		}
 	}
 	elseif (code="SDSStateDataSourse")       //如果是诊断状态数据来源
 	{
	 	s BaseId=$o(^CT.WDT.CDSS.TermBaseI("FlagIndex"," "_$ZCONVERT("DiaState","U"),0))   //通过标识获取诊断类型的RowID
	 	//s SortRowId=$o(^CT.WDT.CDSS.TermI("DescIndex",BaseId," 诊断状态",0))   //获取诊断状态的ID
	 	s TermRowId=0    
	 	for 
	 	{
		 	s TermRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",BaseId,TermRowId))     //遍历诊断状态术语
		 	q:TermRowId=""
		 	//s MKBTBCatDr=$lg($g(^CT.WDT.CDSS.TermBaseD(BaseRowId)),9)  //知识库数据类型DR
		 	//w SortRowId_"AAAA"_MKBTBCatDr,!
			 s id=TermRowId
	 		s MKBSTBDesc=$lg($g(^CT.WDT.CDSS.TermD(TermRowId)),3)
	 		d OutputRow8
		 	
	 	}
	 	
 	}
 	elseif (code="SDSTypeDataSourse")       //如果是诊断状态数据来源
 	{
	 	s BaseId=$o(^CT.WDT.CDSS.TermBaseI("FlagIndex"," "_$ZCONVERT("DiaType","U"),0))   //通过标识获取诊断类型的RowID
	 	//w BaseId,!
	 	//s SortRowId=$o(^CT.WDT.CDSS.TermI("DescIndex",BaseId," 诊断状态",0))   //获取诊断状态的ID
	 	s TermRowId=0    
	 	for 
	 	{
		 	s TermRowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",BaseId,TermRowId))     //遍历诊断状态术语
		 	q:TermRowId=""
		 	//s MKBTBCatDr=$lg($g(^CT.WDT.CDSS.TermBaseD(BaseRowId)),9)  //知识库数据类型DR
		 	//w SortRowId_"AAAA"_MKBTBCatDr,!
			 s id=TermRowId
	 		s MKBSTBDesc=$lg($g(^CT.WDT.CDSS.TermD(TermRowId)),3)
	 		d OutputRow8
		 	
	 	}
	 	
 	}
 	/*
 	elseif (code="SDSOperationResource")       //如果是手术短语数据来源
 	{
	 	s OBase = $o(^CT.WDT.CDSS.TermBaseI("DescIndex"," 术语分类",0))  //获取术语分类的baseid
	 	s OTermRowId = $o(^CT.WDT.CDSS.TermI("DescIndex",OBase," 手术",0))  //获得手术的RowID
	 	//遍历base表，选择分类为手术的知识库
	 	s baseid=0
	 	for
	 	{
		 	s baseid = $o(^CT.WDT.CDSS.TermBaseD(baseid))
		 	q:baseid=""
		 	s MKBTBCatDr=$lg($g(^CT.WDT.CDSS.TermBaseD(baseid)),9)  //术语分类
		 	continue:MKBTBCatDr'=OTermRowId
		 	s id = baseid
		 	s MKBSTBDesc = $lg($g(^CT.WDT.CDSS.TermBaseD(baseid)),3)  
		 	d OutputRow8
	 	}
	 	
 	}
 	*/
 	elseif (code="SDSOperationResource")       //如果是手术短语数据来源
 	{
	 	s RowId=0
 		s BaseId=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," ICD版本",0))
 		for
 		{
	 		s RowId=$o(^CT.WDT.CDSS.TermI("BaseIndex",BaseId,RowId))
	 		q:RowId=""
	 		s FlagProRowId = $o(^CT.WDT.CDSS.TermPropertyI("DescIndex",RowId," 标识",0))  //获取标识属性id
	 		s FlagDetailRowId = $o(^CT.WDT.CDSS.TermProDetailI("ProIdx",FlagProRowId,0))   //获取标识属性内容id
	 		s Flag = $lg($g(^CT.WDT.CDSS.TermProDetailD(FlagDetailRowId)),3)  //获取标识
	 		continue:Flag'="手术"
	 		s id="ICD"_RowId
	 		s MKBSTBDesc=$lg($g(^CT.WDT.CDSS.TermD(RowId)),3)
	 		d OutputRow8
 		}
 		s RowId=0
 		for
 		{
	 		s RowId=$o(^User.MKBStructuredBaseD(RowId))
	 		q:RowId=""
	 		s ODFlag = $lg($g(^User.MKBStructuredBaseD(RowId)),9)
	 		continue:ODFlag'="Operation"
	 		s id=RowId
	 		s MKBSTBDesc=$lg(^User.MKBStructuredBaseD(RowId),2)
	 		d OutputRow8
 		}
 	}
 	elseif (code="CDSScdl2020072401")   //医院配置
 	{
	 	s RowId=0
	 	for
	 	{
		 	s RowId=$o(^CT.WDT.CDSS.CustomerHospD(RowId))
		 	q:RowId=""
		 	s id=RowId
		 	s MKBSTBDesc=$lg($g(^CT.WDT.CDSS.CustomerHospD(RowId)),3)
		 	d OutputRow8
	 	}
 	}
 	elseif (code="CDSSzrf2020091702")       //如果是科室配置数据来源
 	{
		
		s ConfigID=$o(^CF.WDT.CDSS.MKBConfigI("ConfigCodeI"," "_$zconvert(code,"U"),0))
		s ConfigValue=$listget($g(^CF.WDT.CDSS.MKBConfigD(ConfigID)),3)
		
		s DeptID=0
		for 
		{
			s DeptID=$o(^CF.WDT.CDSS.DeptDictD(DeptID))
			q:DeptID=""
			s DeptCode= $lg($g(^CF.WDT.CDSS.DeptDictD(DeptID)),2)		
			s DeptName= $lg($g(^CF.WDT.CDSS.DeptDictD(DeptID)),3)		//科室名称
			
			//s str=##class(web.DHCBL.CT.CTLoc).GetIdbyCode(DeptCode)
			//continue:(str="^")
			s id=DeptID
	 		s MKBSTBDesc=DeptName
	 		d OutputRow8
		}
	 	
 	}
 	elseif (code="CDSSzrf2020091704")       //如果是用户配置数据来源
 	{
		s ID=0
		for 
		{
			s ID=$o(^CF.WDT.CDSS.UserDictD(ID))
			q:ID=""
			
			s UserCode= $lg($g(^CF.WDT.CDSS.UserDictD(ID)),2)		//用户编码
			s UserName= $lg($g(^CF.WDT.CDSS.UserDictD(ID)),3)		//用户名称
			//s str=##class(web.DHCBL.CT.SSUser).GetIdbyCode(UserCode)
	 		//continue:(str="^")
			s id=ID
	 		s MKBSTBDesc=UserName
			d OutputRow8
		}
	 	
 	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(id,MKBSTBDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetDataResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataResourceExecute ]
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

ClassMethod GetDataResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:陈代雷
/// CreatDate:2019-8-29
/// Description:根据诊断短语数据来源id获得其对应的短语描述
/// Table:User.MKBStructuredBase
/// Input:id：诊断短语id
/// Return:返回诊断短语描述
/// Other:w ##class(web.CDSS.Config.MKBConfig).getSingleResource("CDSScdl2020072401","1")
ClassMethod getSingleResource(code As %String, id As %String) As %String
{
	s MKBSTBDesc=""
	s Flag=""
	s BaseDR=""
	//s BaseId=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," 术语分类",0))   //获取术语分类的RowID
	//s StateRowId=$o(^CT.WDT.CDSS.TermI("DescIndex",BaseId," 诊断状态",0))   //获取诊断状态的ID
	//s TypeRowId=$o(^CT.WDT.CDSS.TermI("DescIndex",BaseId," 诊断类型",0))   //获取诊断状态的ID
	q:id="" ""
	if ((code="SDSOperationResource")||(code="SDSDataSource"))
	{
		if ($e(id,1,3)="ICD")  //标准版ICD
		{
			s TermId=$tr(id,"ICD","")
			//w TermId
			s MKBSTBDesc=$lg($g(^CT.WDT.CDSS.TermD(TermId)),3)
		}
		else  //数据处理工厂
		{
			if ($d(^User.MKBStructuredBaseD(id)))
			{
			 	s MKBSTBDesc=$lg($g(^User.MKBStructuredBaseD(id)),2)
			}
		}
	}
	elseif ((code="SDSStateDataSourse")||(code="SDSTypeDataSourse"))       //如果是诊断状态数据来源
 	{
	 	s len=$l(id,",")
		for i=1:1:len
		{
			s MKBTId=$p(id,",",i)
			if (MKBSTBDesc="")
			{
				s MKBSTBDesc=$lg($g(^CT.WDT.CDSS.TermD(MKBTId)),3)
			}
			else
			{
				s MKBSTBDesc=MKBSTBDesc_","_$lg($g(^CT.WDT.CDSS.TermD(MKBTId)),3)
			}
			
		}
 	}
 	elseif (code="CDSScdl2020072401")
 	{
	 	s MKBSTBDesc=$lg($g(^CT.WDT.CDSS.CustomerHospD(id)),3)
 	}
	else
	{
		if (id="N")
		{
			s MKBSTBDesc="否"
		}
		elseif (id="Y")
		{
			s MKBSTBDesc="是"
		}
		else
		{
			s MKBSTBDesc=id
		}
	}
	q MKBSTBDesc
}

/// Creator:陈代雷
/// CreatDate:2019-8-29
/// Description:是根据配置code 查询到配置的值
/// Table:User.MKBStructuredBase
/// Input:code：配置code
/// Return:配置值
/// Others:w ##class(web.CDSS.Config.MKBConfig).GetConfigValue("AlertNumber")
ClassMethod GetConfigValue(code As %String) As %String
{
  s ConfigCode=""
  s ConfigValue=""
  s:code'="" ConfigCode=$ZCONVERT(code,"U")
  s id=$o(^CF.WDT.CDSS.MKBConfigI("ConfigCodeI"," "_ConfigCode,0))
  if (id'=""){
    s ConfigValue=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),3)
    s ConfigActive=$listget($g(^CF.WDT.CDSS.MKBConfigD(id)),6)
    s:ConfigActive="N" ConfigValue=""
  }
  else{
    s ConfigValue=""
  }
  q ConfigValue
}

/// Creator：chendailei
/// CreatDate: 2019-10-10
/// Description：查询基础配置的内容
/// Table：CF.WDT.CDSS.MKBConfig
/// Input：rowid,code,desc
/// Editor: ZWW [添加查询配置分类-2022-05]
/// d ##class(%ResultSet).RunQuery("web.CDSS.Config.MKBConfig","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, category As %String) As %Query(ROWSPEC = "ID:%String,ConfigCode:%String,ConfigDesc:%String,ConfigValue:%String,ConfigType:%String,ConfigExplain:%String,ConfigActive:%String,ConfigEdit:%String,ConfigCategory:%String,ConfigCategoryDesc,ConfigVersion")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, category As %String) As %Status
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
		/*if (ConfigActive="N")
		{
			q
		}*/
		s ConfigEdit=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),7)
		s ConfigCategory=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),8)
		s:ConfigCategory'="" ConfigCategoryDesc=$lg($g(^CF.WDT.CDSS.ConfigCategoryD(ConfigCategory)),3)	//配置分类描述
		s:ConfigCategory="" ConfigCategoryDesc=""
		s ConfigVersion=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),9)	//配置项所属版本
		w ConfigDesc,!
		if (ConfigType="D"){
			s:ConfigValue'="" ConfigValue=$zd(ConfigValue,1)
		}
		if (ConfigType="CB"){
			s:ConfigValue'="" ConfigValue=$p($g(^SSU("SSGRP",ConfigValue)),"^",1)
		}
		s CDSSVersion=##class(web.CDSS.CMKB.VersionLib).GetVersion()		//CDSS当前版本[CDSS_V1.2]
		s Version=$p(CDSSVersion,"_",2)		//V1.2
		if ((ConfigVersion[Version)) {
			d OutputRow
		
		}
		
	}
	else
	{
		s:code'="" code=$ZCONVERT(code,"U") //转换成大写
		s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s:category'="" category=$ZCONVERT(category,"U") //转换成大写
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
			/*if (ConfigActive="N")
			{
				continue
			}*/
			s ConfigEdit=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),7)
			s ConfigCategory=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),8)

			s:ConfigCategory'="" ConfigCategoryDesc=$lg($g(^CF.WDT.CDSS.ConfigCategoryD(ConfigCategory)),3)	//配置分类描述
			s:ConfigCategory="" ConfigCategoryDesc=""
			s ConfigVersion=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),9)		//配置项所属版本
			
			if (ConfigType="D"){
				s:ConfigValue'="" ConfigValue=$zd(ConfigValue,1)
			}
			/*if (ConfigType="CB"){
				s:ConfigValue'="" ConfigValue=$p($g(^SSU("SSGRP",ConfigValue)),"^",1)
			}*/
			s CDSSVersion=##class(web.CDSS.CMKB.VersionLib).GetVersion()		//CDSS当前版本[CDSS_V1.2]
			s Version=$p(CDSSVersion,"_",2)		//V1.2
			s IsShowAllConfig=..IsShowAllConfig()
			if (IsShowAllConfig="Y"){
				if ($ZCONVERT(ConfigCode,"U")[code)&($ZCONVERT(ConfigDesc,"U")[desc)&($ZCONVERT(ConfigCategory,"U")[category)
				{
					d OutputRow
				}
			}
			elseif ($ZCONVERT(ConfigCode,"U")[code)&($ZCONVERT(ConfigDesc,"U")[desc)&($ZCONVERT(ConfigCategory,"U")[category)&(ConfigVersion[Version)
			{
				d OutputRow
			}
			
		
		}
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,ConfigCode,ConfigDesc,ConfigValue,ConfigType,ConfigExplain,ConfigActive,ConfigEdit,ConfigCategory,ConfigCategoryDesc,ConfigVersion)
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

/// Creator:ZWW
/// CreatDate:2022-06-06
/// Description:是否展示全部配置数据
/// Table: CF.WDT.CDSS.MKBConfig
/// Input:
/// Return:
/// Others:w ##class(web.CDSS.Config.MKBConfig).IsShowAllConfig()
ClassMethod IsShowAllConfig() As %String
{
	s ID=$o(^CF.WDT.CDSS.MKBConfigI("ConfigDescI"," 是否展示全部配置数据",""))  
	
	q:ID=""
	s ConfigValue=""
	s ConfigValue=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),3)	//是否展示全部配置数据 默认值
	
	q ConfigValue
}

/// Creator:ZWW
/// CreatDate:2022-05-08
/// Description:获取配置医院id和名称
/// Table: CF.WDT.CDSS.MKBConfig
/// Input:
/// Return:ConfigValue(配置医院DR)，名称【31^东华标准版】
/// Others:w ##class(web.CDSS.Config.MKBConfig).GetHospData()
ClassMethod GetHospData() As %String
{
	s ConfigValue="",HospitalName="",ConfigActive=""
	s ID=$o(^CF.WDT.CDSS.MKBConfigI("ConfigDescI"," 配置医院",""))  
	q:ID=""
	s ConfigValue=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),3)	//医院DR
	
	s:ConfigValue'="" HospitalName=$listget($g(^CT.WDT.CDSS.CustomerHospD(ConfigValue)),3)
	s ConfigActive=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),6)
	q ConfigValue_"^"_HospitalName_"^"_ConfigActive
}

/// Creator:陈代雷
/// CreatDate:2020-05-16
/// Description:通过诊断描述，获取诊断编码
/// Table:CT.WDT.CDSS.Term
/// Input:desc：诊断描述
/// Return:诊断编码
/// Others:w ##class(web.CDSS.Config.MKBConfig).GetDiagCodeByDesc("")
ClassMethod GetDiagCodeByDesc(desc As %String) As %String
{
	///先从ICD11智能编码示例找
	s TermBaseID=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," ICD11智能编码示例",0))     //根据知识库名获取其Id
	s ICD11TermBaseID=$o(^CT.WDT.CDSS.TermBaseI("DescIndex"," ICD11编码",0))     //根据知识库名获取其Id
	s ICDInteTermRowId=$o(^CT.WDT.CDSS.TermI("DescIndex",TermBaseID," "_$Zconvert(desc,"U"),0))  //通过描述找到对应术语id
	if (ICDInteTermRowId'="")  //如果匹配成功，返回备注中的代码
	{
		s code=$lg($g(^CT.WDT.CDSS.TermD(ICDInteTermRowId)),7) 
		q code
	}	
	///没找到再去全匹配
	s ICD11TermRowId=$o(^CT.WDT.CDSS.TermI("DescIndex",ICD11TermBaseID," "_$Zconvert(desc,"U"),0))  //通过描述找到对应术语id
	if (ICD11TermRowId'="")  //如果匹配成功，返回匹配成功的代码
	{
		s code=$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId)),2) 
		q code
	}
	///还没找到如果有伴，并，合并 拆开左右再全匹配
	if (desc["合并")
	{
		s diag1=$p(desc,"合并",1)  //拆分诊断1
		s diag2=$p(desc,"合并",2)  //拆分诊断2
		s ICD11TermRowId1=$o(^CT.WDT.CDSS.TermI("DescIndex",ICD11TermBaseID," "_$Zconvert(diag1,"U"),0))  //通过描述找到对应术语id
		s ICD11TermRowId2=$o(^CT.WDT.CDSS.TermI("DescIndex",ICD11TermBaseID," "_$Zconvert(diag2,"U"),0))  //通过描述找到对应术语id
		if (ICD11TermRowId1'="")&(ICD11TermRowId2'="")
		{
			s code=$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId1)),2)_"&"_$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId2)),2) 
			q code 
		}
		elseif (ICD11TermRowId1'="")&(ICD11TermRowId2="")
		{
			s code=$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId1)),2)
			q code 
		}
		elseif (ICD11TermRowId1="")&(ICD11TermRowId2'="")
		{
			s code=$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId2)),2)
			q code 
		}
		
	}
	elseif (desc["伴")
	{
		s diag1=$p(desc,"伴",1)  //拆分诊断1
		s diag2=$p(desc,"伴",2)  //拆分诊断2
		s ICD11TermRowId1=$o(^CT.WDT.CDSS.TermI("DescIndex",ICD11TermBaseID," "_$Zconvert(diag1,"U"),0))  //通过描述找到对应术语id
		s ICD11TermRowId2=$o(^CT.WDT.CDSS.TermI("DescIndex",ICD11TermBaseID," "_$Zconvert(diag2,"U"),0))  //通过描述找到对应术语id
		if (ICD11TermRowId1'="")&(ICD11TermRowId2'="")
		{
			s code=$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId1)),2)_"&"_$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId2)),2) 
			q code 
		}
		elseif (ICD11TermRowId1'="")&(ICD11TermRowId2="")
		{
			s code=$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId1)),2)
			q code 
		}
		elseif (ICD11TermRowId1="")&(ICD11TermRowId2'="")
		{
			s code=$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId2)),2)
			q code 
		}
	}
	elseif ((desc["并"))
	{
		s diag1=$p(desc,"并",1)  //拆分诊断1
		s diag2=$p(desc,"并",2)  //拆分诊断2
		s ICD11TermRowId1=$o(^CT.WDT.CDSS.TermI("DescIndex",ICD11TermBaseID," "_$Zconvert(diag1,"U"),0))  //通过描述找到对应术语id
		s ICD11TermRowId2=$o(^CT.WDT.CDSS.TermI("DescIndex",ICD11TermBaseID," "_$Zconvert(diag2,"U"),0))  //通过描述找到对应术语id
		if (ICD11TermRowId1'="")&(ICD11TermRowId2'="")
		{
			s code=$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId1)),2)_"&"_$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId2)),2) 
			q code 
		}
		elseif (ICD11TermRowId1'="")&(ICD11TermRowId2="")
		{
			s code=$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId1)),2)
			q code 
		}
		elseif (ICD11TermRowId1="")&(ICD11TermRowId2'="")
		{
			s code=$lg($g(^CT.WDT.CDSS.TermD(ICD11TermRowId2)),2)
			q code 
		}
	}
	q ""
}

/// Creator:陈代雷
/// CreatDate:2020-05-17
/// Description:ICD11录入保存用户收藏信息到临时global
/// Table:
/// Input:id：用户id info：收藏信息
/// Return:
/// Others:w ##class(web.CDSS.Config.MKBConfig).SaveCollectionOfICD11("1","test")
ClassMethod SaveCollectionOfICD11(id As %String, info As %String) As %String
{
	if ($d(^TempICD11Collection(id))=10)
	{
		s order=$o(^TempICD11Collection(id,""),-1)+1
	}
	else
	{
		s order=1
	}
	s tmpId=0
	for
	{
		s tmpId=$o(^TempICD11Collection(id,tmpId))
		q:tmpId=""
		if (^TempICD11Collection(id,tmpId)=info)
		{
			return 0
		}
	}
	s ^TempICD11Collection(id,order)=info
	q ""
}

/// Creator:陈代雷
/// CreatDate:2020-05-17
/// Description:ICD11录入通过用户id获取用户收藏信息
/// Table:
/// Input:id：用户id
/// Return:
/// Others:w ##class(web.CDSS.Config.MKBConfig).GetCollectionOfICD11("1")
ClassMethod GetCollectionOfICD11(id As %String) As %String
{
	s result=""
	s order=0
	for
	{
		s order=$o(^TempICD11Collection(id,order))
		q:order=""
		if (result="")
		{
			s result=^TempICD11Collection(id,order)
		}
		else
		{
			s result=result_"&&&"_^TempICD11Collection(id,order)
		}
		
	}
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-09-17
/// Description:某个配置的修改配置项值
/// Table:
/// Input:id：configid
/// Return:
/// Others:w ##class(web.CDSS.Config.MKBConfig).UpdateConfigValue("")
ClassMethod UpdateConfigValue(id As %String, value) As %String
{
	s result=""
	s obj=##class(CF.WDT.CDSS.MKBConfig).%OpenId(id)
	s bobj = ##class(web.CDSSEntity.Config.MKBConfigAdmin).%New()
	s bobj.ID = id
	s bobj.ConfigCode = obj.ConfigCode
	s bobj.ConfigDesc = obj.ConfigDesc
	s bobj.ConfigValue = value
	s bobj.ConfigType=obj.ConfigType
	s bobj.ConfigExplain=obj.ConfigExplain
	s bobj.ConfigActive=obj.ConfigActive
	s bobj.ConfigEdit=obj.ConfigEdit
	
	d obj.%Close()
	s result= ..SaveEntity(bobj)
	q result
}

/// Creator:钟荣枫
/// CreatDate:2020-09-17
/// Description:重复校验
/// Table:
/// Input:id：configid
/// Return:
/// Others:w ##class(web.CDSS.Config.MKBConfig).FormValidate("")
ClassMethod FormValidate(id As %String, value) As %String
{
	s flag=0
	if (id="")
	{
		s ID=0
		for {
			s ID=$o(^CF.WDT.CDSS.MKBConfigD(ID))
			q:ID=""
			s ConfigValue=$listget($g(^CF.WDT.CDSS.MKBConfigD(ID)),3)
			if (value=ConfigValue)
			{
				s flag=1
				q
			}
		}
	}
	q flag
}

/// Creator:钟荣枫
/// CreatDate:2020-09-17
/// Description:在平台配置中是否存在这个科室和用户
/// Table:
/// Input:
/// Return:
/// Others:w ##class(web.CDSS.Config.MKBConfig).IsExist("412","ldy")
ClassMethod IsExist(hislocid As %String, usercode) As %String
{
	s loccode = $p($g(^CTLOC(hislocid)),"^",1)  
	s flag=0
	s locid=$o(^CF.WDT.CDSS.DeptDictI("CodeIndex"," "_$ZCONVERT(loccode,"U"),0))
	s userid=$o(^CF.WDT.CDSS.UserDictI("CodeIndex"," "_$ZCONVERT(usercode,"U"),0)) 
	s locstr=..GetConfigValue("CDSSzrf2020091702")
	s userstr=..GetConfigValue("CDSSzrf2020091704")
	s locflag=0
	s userflag=0
	for m=1:1:$l(locstr,"^")
	{
		
		s loc=$p(locstr,"^",m)
		continue:(loc="")
		if (loc=locid)
		{
			s locflag=1 
			q
		}
	}
	
	for n=1:1:$l(userstr,"^")
	{
		s user=$p(userstr,"^",n)
		continue:(user="")
		if (user=userid)
		{
			s userflag=1 
			q
		}
	}
	if ((locflag=1)&&(userflag=1))
	{
		s flag=1
	}
	q flag
}

/// Creator:钟荣枫
/// CreatDate:2021-4-15
/// Description:在平台配置中是否存在这个科室下的用户是否有权限
/// Table:
/// Input:hisloccode cdss科室代码,usercode 用户代码
/// Return:
/// Others:w ##class(web.CDSS.Config.MKBConfig).IsExistLocAndUser("code","aphadmin")
ClassMethod IsExistLocAndUser(loccode As %String, usercode) As %String
{
	s flag=0
	q:((loccode="")||(usercode="")) 0
	//Index CodeIndex On DeptCode [ Unique ];
	s locid=$o(^CF.WDT.CDSS.DeptDictI("CodeIndex"," "_$zconvert(loccode,"U"),""))
	s userid=$o(^CF.WDT.CDSS.UserDictI("CodeIndex"," "_$ZCONVERT(usercode,"U"),0))
	
	q:((locid="")||(userid="")) 0
	s mainstr=..GetConfigValue("CDSSzrf2020091703")
	if (mainstr="Y")		//用户科室配置开启
	{
		s userid=$o(^CF.WDT.CDSS.UserDictI("CodeIndex"," "_$ZCONVERT(usercode,"U"),0))
		s RowID1=$o(^CF.WDT.CDSS.DeptUserAuthorizeI("DeptUserAuthorizeIndex",locid,-100000000000000,""))
		s RowID2=$o(^CF.WDT.CDSS.DeptUserAuthorizeI("DeptUserAuthorizeIndex",locid,-100000000000000))
		if (RowID1'="")		
		{
				//科室下的用户都有权限
				s flag=1
		}
		else
		{
			s RowID3=$o(^CF.WDT.CDSS.DeptUserAuthorizeI("DeptUserAuthorizeIndex",locid,userid,""))
			s:RowID3'="" flag=1
		}
	}
	q flag
}

/// Creator：钟荣枫 		
/// CreatDate: 2021-4-13
/// Description：查询 CDSS科室 
/// Table:CF.WDT.CDSS.DeptDict
/// Input:id, code, desc,EnableFlag
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Config.MKBConfig","GetLocList","","","")
Query GetLocList(rowid As %String, q As %String, enableflag As %String) As %Query(ROWSPEC = "DeptID,DeptCode,DeptName,EnableFlag")
{
}

ClassMethod GetLocListExecute(ByRef qHandle As %Binary, rowid As %String, q As %String, enableflag As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:q'="" q=$ZCONVERT(q,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s DeptID=rowid
		s DeptCode= $lg($g(^CF.WDT.CDSS.DeptDictD(DeptID)),2)		//科室编码
		s DeptName= $lg($g(^CF.WDT.CDSS.DeptDictD(DeptID)),3)		//科室名称
		
		s UseFlag=$lg($g(^CF.WDT.CDSS.DeptDictD(DeptID)),6)		//使用标记（0使用、1停用）
		s EnableFlag=0
		for m=1:1:$l(locstr,"^")
		{
			s LocID=$p(locstr,"^",m)
			continue:LocID=""
			s:LocID=DeptID EnableFlag=1
		}
		d OutputRow
	}
	else
	{
	
		s DeptID=0
		for 
		{
			s DeptID=$o(^CF.WDT.CDSS.DeptDictD(DeptID))
			q:DeptID=""
			s DeptCode= $lg($g(^CF.WDT.CDSS.DeptDictD(DeptID)),2)		//科室编码
			s DeptName= $lg($g(^CF.WDT.CDSS.DeptDictD(DeptID)),3)		//科室名称

			s UseFlag=$lg($g(^CF.WDT.CDSS.DeptDictD(DeptID)),6)		//使用标记（0使用、1停用）
			s EnableFlag=0
			s userid=$o(^CF.WDT.CDSS.DeptUserAuthorizeI("DeptUserAuthorizeIndex",DeptID,""))
			s:userid'="" EnableFlag=1
			continue:((enableflag'="")&&(enableflag'=EnableFlag))
			s PINYIN=""
			s:q'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DeptName)
			if (($ZCONVERT(DeptName,"U")[q)||(PINYIN[q)||($ZCONVERT(DeptCode,"U")[q))
		  	{
		  		d OutputRow
			}
			
		}
						
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(DeptID,DeptCode,DeptName,EnableFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocListExecute ]
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

/// Creator：钟荣枫 		
/// CreatDate: 2021-4-13
/// Description：查询 CDSS用户
/// Table:CF.WDT.CDSS.DeptDict
/// Input:id, code, desc,EnableFlag
/// Output:
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Config.MKBConfig","GetUserList","","","2","")
Query GetUserList(rowid As %String, q As %String, deptdr As %String, enableflag As %String) As %Query(ROWSPEC = "UserID,UserCode,UserDesc,EnableFlag")
{
}

ClassMethod GetUserListExecute(ByRef qHandle As %Binary, rowid As %String, q As %String, deptdr As %String, enableflag As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s:q'="" q=$ZCONVERT(q,"U") //转换成大写
	q:deptdr="" ""
		//Index UserDeptIndex On (UserCodeDR, FatherCodeDR);
	s UserID=""
	for
	{
		s UserID=$o(^CF.WDT.CDSS.UserJoinDeptI("UserDeptIndex",UserID)) 
		q:UserID="" 
		s ID=""
		for
		{ 
			s ID=$o(^CF.WDT.CDSS.UserJoinDeptI("UserDeptIndex",UserID,deptdr,ID)) 
			q:ID=""
			s UserCode=$LISTGET($G(^CF.WDT.CDSS.UserDictD(UserID)),2) 
			s UserDesc=$LISTGET($G(^CF.WDT.CDSS.UserDictD(UserID)),3)
			s EnableFlag=0
			s RowID1=$o(^CF.WDT.CDSS.DeptUserAuthorizeI("DeptUserAuthorizeIndex",deptdr,-100000000000000,""))
			s RowID2=$o(^CF.WDT.CDSS.DeptUserAuthorizeI("DeptUserAuthorizeIndex",deptdr,-100000000000000))
			if (RowID1'="")		
			{
					//科室下的用户都有权限
				
				s EnableFlag=1
			}
			else
			{
				s RowID3=$o(^CF.WDT.CDSS.DeptUserAuthorizeI("DeptUserAuthorizeIndex",deptdr,UserID,""))
				s:RowID3'="" EnableFlag=1
			}
			
			continue:((enableflag'="")&&(enableflag'=EnableFlag))
			s PINYIN=""
			s:q'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(UserDesc)
			if (($ZCONVERT(UserDesc,"U")[q)||(PINYIN[q)||($ZCONVERT(UserCode,"U")[q))
		  	{
		  		d OutputRow
			}
		
			
		}
		
		
	}
					
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(UserID,UserCode,UserDesc,EnableFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUserListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUserListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetUserListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUserListExecute ]
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

/// Function:是否属于科室关联的疾病
/// Table: CF.WDT.CDSS.DeptJoinDisease：科室关联疾病表
/// Creator: wuzhe
/// CreatDate：2021-07-08
/// Input: DiseaseName：跟项目对照后的疾病名称，LocName：科室名称
/// Output:1：是，0：否
/// Others:w ##class(web.CDSS.Config.MKBConfig).WhetherDeptDis("")
ClassMethod WhetherDeptDis(DiseaseName As %String, LocName As %String) As %String
{
	q:DiseaseName="" ""
	q:LocName="" ""
	s flag=0
	if ($d(^CF.WDT.CDSS.DeptJoinDiseaseI("DeptDiaIndex",LocName,DiseaseName)))
	{
		s flag=1
	}
	q flag
}

}
