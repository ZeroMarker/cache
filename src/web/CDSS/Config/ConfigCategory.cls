/// 名称:平台配置分类
/// 描述:平台配置分类
/// 编写者:基础数据平台组 - Xuwenhu
/// 编写日期:2022-04-26
Class web.CDSS.Config.ConfigCategory Extends %RegisteredObject
{

/// Creator：Xuwenhu
/// CreatDate: 2022-04-29
/// Description：树形配置下拉框
/// Table：CF.WDT.CDSS.ConfigCategory
/// Input：父节点 
/// Return：tree格式数据串
/// w ##class(web.CDSS.Config.ConfigCategory).GetJsonDataForCmb("")
ClassMethod GetJsonDataForCmb(id As %String = "") As %String
{
	s parentdr=id
	if (parentdr="") s parentdr=-100000000000000

	//输出JSON串
	w "["
	s count=0
	s myRowID=0
	for 
	{
		s myRowID=$o(^CF.WDT.CDSS.ConfigCategoryI("CategoryParIdx",parentdr,myRowID)) 
		q:myRowID=""
		s CategoryDesc = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(myRowID)),3)					//类别描述
		s CategoryActive = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(myRowID)),5)					//是否激活
		continue:(CategoryActive=0)
		s count=count+1
		
		if count>1 w ","
		w "{""id"":"""_myRowID_""",""text"":"""_CategoryDesc_""""
		w ",""state"":""open"""
		if $d(^CF.WDT.CDSS.ConfigCategoryI("CategoryParIdx",myRowID))
		{
				w ",""state"":""open"""
				w ",""children"":"
				w ..GetJsonDataForCmb(myRowID)	
		}
		else
		{
				w ",""state"":""open"""
		}
		w "}"
	}
	w "]"
	q ""
}

/// Creator:Xuwenhu
/// CreatDate:2022-04-26
/// Description:树形配置分类
/// Input:上级节点
/// Return:成功返回树形配置分类
/// Other:w ##class(web.CDSS.Config.ConfigCategory).GetTreeJson("")
ClassMethod GetTreeJson(id As %String) As %String
{
	s parentdr=id
	if (parentdr="") s parentdr=-100000000000000
	s myJsonStr=""
	
	//输出树形JSON串
	s childStr=""
	w "["
	s count=0
	s RowId=""
	for
	{ 	
		s RowId=$o(^CF.WDT.CDSS.ConfigCategoryI("CategoryParIdx",parentdr,RowId)) 
		q:RowId=""
		
		s CategoryCode = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(RowId)),2)					//类别代码
		s CategoryDesc = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(RowId)),3)					//类别描述
		s CategoryParentDR = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(RowId)),4)				//父级
		s FatherName=""
		s:CategoryParentDR'="" FatherName=$LISTGET($G(^CF.WDT.CDSS.ConfigCategoryD(CategoryParentDR)),3)
		s CategoryActive = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(RowId)),5)				//是否激活
		s UpdateUser = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(RowId)),6)					//操作人员
		s UpdateDate= $lg($g(^CF.WDT.CDSS.ConfigCategoryD(RowId)),7)						//编辑时间
		s Remarks = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(RowId)),8)						//备注
		
		s count=count+1
		if count>1 w ","
		w "{""id"":"""_RowId_""""
		w ",""RowId"":"""_RowId_""",""CategoryCode"":"""_CategoryCode_""",""CategoryDesc"":"""_CategoryDesc_""",""CategoryParentDR"":"""_CategoryParentDR_""",""FatherName"":"""_FatherName_""",""CategoryActive"":"""_CategoryActive
		_""",""UpdateDate"":"""_UpdateDate_""",""UpdateUser"":"""_UpdateUser_""",""Remarks"":"""_Remarks_""""
		
		if $d(^CF.WDT.CDSS.ConfigCategoryI("CategoryParIdx",RowId))
		{
			w ",""state"":""open"""
			w ",""children"":"
			w ..GetTreeJson(RowId)	
		}
		else
		{
			w ",""state"":""open"""
		}
		w "}"
	}
	w "]"
	q ""
}

/// Creator：Xuwenhu
/// CreatDate: 202-04-26
/// Description：数据重复验证 重复返回1
/// Table：CF.WDT.CDSS.MKBConfigDetail
/// Input：id, base.desc
/// Other: w ##class(web.CDSS.Config.ConfigCategory).FormValidate()
ClassMethod FormValidate(id, code) As %String
{
	//q:id="" 1
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s flag="",flagd=""
	s:code'="" flagd=$d(^CF.WDT.CDSS.ConfigCategoryI("CodeIndex"," "_code))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagd>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idd=""
		s:code'="" idd=$o(^CF.WDT.CDSS.ConfigCategoryI("CodeIndex"," "_code,0))
		if ((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Other: w ##class(web.CDSS.Config.ConfigCategory).Test()
ClassMethod Test()
{
	s eobj=##class(web.CDSSEntity.Config.ConfigCategory).%New()
	s eobj.RowId=11
	s eobj.CategoryCode=123
	s eobj.CategoryDesc="测试22"
	s eobj.CategoryParentDR=""
	
	s re=..SaveData(eobj)
	b ;5
	q re
}

/// Creator:Xuwenhu
/// CreatDate:2022-04-26
/// Description:保存平台配置分类表
/// Table：CF.WDT.CDSS.ConfigCategory
/// Input: eobj 平台配置分类表实体对象
/// Return: 成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// others:w ##class(web.CDSS.Config.ConfigCategory).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Config.ConfigCategory) As %String
{
	s $zt="ERROR"
	s result=""
	if $IsObject(eobj)
	{
		s flag=..FormValidate(eobj.RowId,eobj.CategoryCode)  //重复校验
		q:flag=1 "{success:'false',errorinfo:'该记录已经存在'}"
		
		if (eobj.RowId="")  //如果RowId未赋值则增加
		{
			s obj=##class(CF.WDT.CDSS.ConfigCategory).%New()
		}
		else  //如果RowId已赋值则修改
		{
			s obj=##class(CF.WDT.CDSS.ConfigCategory).%OpenId(eobj.RowId)
			s bobj=##class(web.CDSSEntity.Config.ConfigCategory).%New() 
			s bobj.RowId=eobj.RowId
			
			s bobj.CategoryCode = obj.CategoryCode  					//类别代码				
			s bobj.CategoryDesc = obj.CategoryDesc 						//类别描述
			
			s:obj.CategoryParentDR'="" bobj.CategoryParentDR = obj.CategoryParentDR.%Id() 		//父级
			
			s bobj.CategoryActive = obj.CategoryActive					//是否激活
			s bobj.UpdateUser = obj.UpdateUser							//操作人员
			//s bobj.UpdateDate = obj.UpdateDate							//编辑时间
			s bobj.UpdateDate = $ZDATETIME($HOROLOG,3)	
			s bobj.Remarks = obj.Remarks								//备注
		}
		
		s obj.CategoryCode = eobj.CategoryCode
		s obj.CategoryDesc = eobj.CategoryDesc
		//d:eobj.CategoryParentDR'="" obj.CategoryParentDR(eobj.CategoryParentDR)
		d:eobj.CategoryParentDR'="" obj.CategoryParentDRSetObjectId(eobj.CategoryParentDR)
		//d:eobj.CategoryParentDR="" obj.FatherCodeDRSetObjectId("")
		d:eobj.CategoryParentDR="" obj.CategoryParentDRSetObjectId("")
		s obj.CategoryActive = eobj.CategoryActive
		s obj.UpdateUser = eobj.UpdateUser
		s obj.UpdateDate = eobj.UpdateDate
		s obj.Remarks = eobj.Remarks
		
		Ts
		s sc=obj.%Save()
		
		d obj.%Close()
		If $$$ISOK(sc)
		{
			Tc
			s id = obj.%Id()
			s result = "{success:'true',id:'"_id_"'}" //返回RowId
			//保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("ConfigCategory","CF.WDT.CDSS.ConfigCategory","平台配置分类",id,eobj.CategoryDesc,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("ConfigCategory","CF.WDT.CDSS.ConfigCategory","平台配置分类",eobj.RowId,eobj.CategoryDesc,"U",eobj,bobj)			
		}
		else
		{
			Trollback
			s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
			s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("平台配置分类","web.CDSS.Config.ConfigCategory","SaveData",eobj)
       		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}	
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在'}"
	}
	q result
	
ERROR
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("平台配置分类","web.CDSS.Config.ConfigCategory","SaveData",eobj)
	s ^ERRORLOGINFO(logid)=$ze
	q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:Xuwenhu
/// CreatDate:2022-04—26
/// Description：根据ID删除平台配置分类表的内容
/// Table：CF.WDT.CDSS.ConfigCategory
/// Input：id-平台配置分类表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.Config.ConfigCategory).DeleteData("10")
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    s flag=$d(^CF.WDT.CDSS.ConfigCategoryI("CategoryParIdx",id)) //判断是否有子节点
    s quoteflag = $d(^CF.WDT.CDSS.MKBConfigI("ConfigCategoryIndex",id))	//判断是否被配置项引用
	if (flag>0)
	{
		s result = "{success:'false',info:'该数据下已有子节点,禁止删除！'}" 
		q result
	}
	elseif (quoteflag>0)
	{
		s result = "{success:'false',info:'该数据已被配置项引用,禁止删除！'}" 
		q result
	}
	else
	{  
	    s obj=##class(CF.WDT.CDSS.ConfigCategory).%OpenId(id)  
	    s bobj = ##class(web.CDSSEntity.Config.ConfigCategory).%New()
	    s bobj.RowId=id
		s bobj.CategoryCode = obj.CategoryCode  					//类别代码				
		s bobj.CategoryDesc = obj.CategoryDesc 						//类别描述
		s:obj.CategoryParentDR'="" bobj.CategoryParentDR = obj.CategoryParentDR.%Id() 		//父级
		s bobj.CategoryActive = obj.CategoryActive					//是否激活
		s bobj.UpdateUser = obj.UpdateUser							//操作人员
		s bobj.UpdateDate = obj.UpdateDate							//编辑时间
		s bobj.Remarks = obj.Remarks								//备注
		d obj.%Close()
	    k obj
	    Tstart
	    s sc=##class(CF.WDT.CDSS.ConfigCategory).%DeleteId(id)
	    if $$$ISOK(sc)
	    {
	        Tcommit
	        s result = "{success:'true',info:'删除成功！'}"  
	        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("ConfigCategory","CF.WDT.CDSS.ConfigCategory","平台配置分类",id,bobj.RowId,"D",bobj)
	        d bobj.%Close()   
	    }
	    else 
	    {
	        Trollback
	        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("平台配置分类","web.CDSS.Config.ConfigCategory","DeleteData",bobj)
	        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	     }
	     q result
	}
}

/// Creator：Xuwenhu
/// CreatDate: 2022-04-26
/// Description：数据打开方法
/// Table：CF.WDT.CDSS.ConfigCategory
/// Input：RowId
/// Return: Json
/// Other: w ##class(web.CDSS.Config.ConfigCategory).OpenDataT("9")
ClassMethod OpenDataT(id As %String) As %String
{
	s str=""	
	s obj=##class(CF.WDT.CDSS.ConfigCategory).%OpenId(id)  
    s bobj = ##class(web.CDSSEntity.Config.ConfigCategory).%New()
    s bobj.RowId=id
	s bobj.CategoryCode = obj.CategoryCode  					//类别代码				
	s bobj.CategoryDesc = obj.CategoryDesc 						//类别描述
	s bobj.CategoryParentDR = obj.CategoryParentDR.%Id() 		//父级
	s:bobj.CategoryParentDR'="" bobj.CategoryParentDesc=$lg($g(^CF.WDT.CDSS.ConfigCategoryD(bobj.CategoryParentDR)),3)	
	s bobj.CategoryActive = obj.CategoryActive					//是否激活
	s bobj.UpdateUser = obj.UpdateUser							//操作人员
	s bobj.UpdateDate = obj.UpdateDate							//编辑时间
	s bobj.Remarks = obj.Remarks								//备注
	d obj.%Close()		
	k obj
	s str = bobj.JsonS()	
	q str
}

/// Creator:ZWW
/// CreatDate:2022-06-06
/// Description：修改时打开的数据
/// Table：CF.WDT.CDSS.ConfigCategory
/// Input：id
/// Return:Json格式的字符串{}
/// Other: w ##class(web.CDSS.Config.ConfigCategory).OpenData("9")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.CDSSEntity.Config.ConfigCategory).%New()
    s eobj.RowId=id
    s eobj.CategoryCode = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(id)),2)					//类别代码
	s eobj.CategoryDesc = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(id)),3)					//类别描述
	s eobj.CategoryParentDR = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(id)),4)				//父级
	s eobj.CategoryParentDesc=""
	s:eobj.CategoryParentDR'="" eobj.CategoryParentDesc=$LISTGET($G(^CF.WDT.CDSS.ConfigCategoryD(eobj.CategoryParentDR)),3)
	s eobj.CategoryActive = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(id)),5)					//是否激活
	s eobj.UpdateUser = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(id)),6)						//操作人员
	s eobj.UpdateDate= $lg($g(^CF.WDT.CDSS.ConfigCategoryD(id)),7)						//编辑时间
	s eobj.Remarks = $lg($g(^CF.WDT.CDSS.ConfigCategoryD(id)),8)							//备注
    s str= eobj.JsonS()
    d eobj.%Close()
    
    q str
}

}
