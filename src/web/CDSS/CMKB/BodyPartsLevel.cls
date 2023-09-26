/// 描述:部位分层表 
/// 描述:包含增删改查
/// 编写者:赵文伟
/// 编写日期:2021-11-16
Class web.CDSS.CMKB.BodyPartsLevel Extends %RegisteredObject
{

/// Creator:赵文伟
/// CreatDate:2021-11-17
/// Description：查询页面数据
/// Table：CT.WDT.CDSS.BodyPartsLevel
/// Input：父节点
/// Return：treegrid格式数据串
/// Other:w ##class(web.CDSS.CMKB.BodyPartsLevel).GetJsonList("","1")
ClassMethod GetJsonList(id As %String = "", type As %String = 1) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	s myJsonStr=""	
	//输出菜单JSON串
	s myJsonStr=myJsonStr_"["
	s count=0
	s ID=""
	for
	{
		s ID=$o(^CT.WDT.CDSS.BodyPartsLevelI("LevelIndex",type,parentcatdr,ID)) q:ID=""
		
		s count=count+1
		s BodyPartDR= $lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),2)			//部位指针
		s BodyPartName = ""
		s:BodyPartDR'="" BodyPartName =$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyPartDR)),3) //部位名称
		s BodyPartAlias=""
		s:BodyPartDR'="" BodyPartAlias =$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyPartDR)),8) //部位别名
		
		s BodyLastLevel = $lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),3)				//父节点DR  
		s BodyLastLevelDR =""
		s:BodyLastLevel'="" BodyLastLevelDR =$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(BodyLastLevel)),2)	//父节点部位指针
		s BodyLastLevelName =""
		s:BodyLastLevelDR'="" BodyLastLevelName =$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyLastLevelDR)),3)	//父节点名称
		
		s LevelType=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),4)				//层级类型
		s newtype=LevelType
		s:LevelType'="" LevelType=$case(LevelType,0:"系统",1:"解剖",:"")
		//s UseFlag=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),5)				//状态【0编辑中，1已删除，2已审核】
		//状态改为取部位字典状态
		s UseFlag=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyPartDR)),4)
		s:UseFlag'="" UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"编辑中")
		s UpdateUser=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),6)			//编辑人员
		s UpdateDate=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),7)			//编辑时间
		s Remarks=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),8)				//备注
		
		if count>1 s myJsonStr=myJsonStr_","
		s myJsonStr=myJsonStr_"{""id"":"""_ID_""""
		s myJsonStr=myJsonStr_",""ID"":"""_ID_""",""BodyPartDR"":"""_BodyPartDR_""",""BodyPartName"":"""_BodyPartName_""",""BodyPartAlias"":"""_BodyPartAlias_""",""BodyLastLevel"":"""_BodyLastLevel_""",""BodyLastLevelName"":"""_BodyLastLevelName_""",""LevelType"":"""_LevelType_""",""UseFlag"":"""_UseFlag_""",""UpdateUser"":"""_UpdateUser_""",""UpdateDate"":"""_UpdateDate_""",""Remarks"":"""_Remarks_""""
		s myChildFlag=$d(^CT.WDT.CDSS.BodyPartsLevelI("ParentIndex",ID))
        if (myChildFlag) //有子菜单不是叶子节点
        {
	        //一次性加载   
			s myJsonStr=myJsonStr_",""state"":""open"""   //closed节点不展开,open节点展开
			s myJsonStr=myJsonStr_",""children"":"
			s myJsonStr=myJsonStr_..GetJsonListA(ID,newtype)
        }
	    else  //叶子节点
	    {
		   s myJsonStr=myJsonStr_",""state"":""open"""
	    }
		s myJsonStr=myJsonStr_"}"
	}
		

	s myJsonStr=myJsonStr_"]"
	s myJsonStr=myJsonStr_""
	k ^TempDataHandle("BODY",$JOB,"Handle")
	q myJsonStr
}

/// Creator:赵文伟
/// CreatDate:2021-11-17
/// Description：查询首节点下的节点【倒序取数据】
/// Table：CT.WDT.CDSS.BodyPartsLevel
/// Input：父节点
/// Return：treegrid格式数据串
/// Other:w ##class(web.CDSS.CMKB.BodyPartsLevel).GetJsonListA("","1")
ClassMethod GetJsonListA(id As %String = "", type As %String = 1) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s myJsonStr=""	
	//输出菜单JSON串
	s myJsonStr=myJsonStr_"["
	s count=0
	s ID=""
	for
	{
		s ID=$o(^CT.WDT.CDSS.BodyPartsLevelI("LevelIndex",type,parentcatdr,ID),-1) q:ID=""
		s count=count+1
		s BodyPartDR= $lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),2)			//部位指针
		s BodyPartName = ""
		s:BodyPartDR'="" BodyPartName =$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyPartDR)),3) //部位名称
		s BodyPartAlias=""
		s:BodyPartDR'="" BodyPartAlias =$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyPartDR)),8) //部位别名
		
		s BodyLastLevel = $lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),3)				//父节点DR  
		s BodyLastLevelDR =""
		s:BodyLastLevel'="" BodyLastLevelDR =$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(BodyLastLevel)),2)	//父节点部位指针
		s BodyLastLevelName =""
		s:BodyLastLevelDR'="" BodyLastLevelName =$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyLastLevelDR)),3)	//父节点名称
		
		s LevelType=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),4)				//层级类型
		s newtype=LevelType
		s:LevelType'="" LevelType=$case(LevelType,0:"系统",1:"解剖",:"")
		//s UseFlag=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),5)				//状态【0编辑中，1已删除，2已审核】
		//状态改为取部位字典状态
		s UseFlag=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyPartDR)),4)
		s:UseFlag'="" UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"编辑中")
		s UpdateUser=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),6)			//编辑人员
		s UpdateDate=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),7)			//编辑时间
		s Remarks=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),8)				//备注
		
		if count>1 s myJsonStr=myJsonStr_","
		s myJsonStr=myJsonStr_"{""id"":"""_ID_""""
		s myJsonStr=myJsonStr_",""ID"":"""_ID_""",""BodyPartDR"":"""_BodyPartDR_""",""BodyPartName"":"""_BodyPartName_""",""BodyPartAlias"":"""_BodyPartAlias_""",""BodyLastLevel"":"""_BodyLastLevel_""",""BodyLastLevelName"":"""_BodyLastLevelName_""",""LevelType"":"""_LevelType_""",""UseFlag"":"""_UseFlag_""",""UpdateUser"":"""_UpdateUser_""",""UpdateDate"":"""_UpdateDate_""",""Remarks"":"""_Remarks_""""
		s myChildFlag=$d(^CT.WDT.CDSS.BodyPartsLevelI("ParentIndex",ID))
        if (myChildFlag) //有子菜单不是叶子节点
        {
	        //一次性加载   
			s myJsonStr=myJsonStr_",""state"":""open"""   //closed节点不展开,open节点展开
			s myJsonStr=myJsonStr_",""children"":"
			s myJsonStr=myJsonStr_..GetJsonListA(ID,newtype)
        }
	    else  //叶子节点
	    {
		   s myJsonStr=myJsonStr_",""state"":""open"""
	    }
		s myJsonStr=myJsonStr_"}"
	}
		
	s myJsonStr=myJsonStr_"]"
	s myJsonStr=myJsonStr_""
	q myJsonStr
}

/// Creator:赵文伟
/// CreatDate:2021-11-17
/// Description：修改时打开的数据
/// Table：CT.WDT.CDSS.BodyPartsLevel
/// Input：id-部位分层的rowid
/// Return:Json格式的字符串{}
/// Other: w ##class(web.CDSS.CMKB.BodyPartsLevel).OpenDataJSON("233")
ClassMethod OpenDataJSON(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.CDSSEntity.CMKB.BodyPartsLevel).%New()
    s eobj.ID=id
    s eobj.BodyPartDR=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(id)),2)			//部位指针
    s:eobj.BodyPartDR'="" eobj.BodyPartName=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(eobj.BodyPartDR)),3) //部位名称
    s eobj.BodyLastLevel=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(id)),3)				//上级分类/父节点DR
	s:eobj.BodyLastLevel'="" eobj.BodyLastLevelDR =$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(eobj.BodyLastLevel)),2)	//父节点部位指针
	s:eobj.BodyLastLevelDR'="" eobj.BodyLastLevelName=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(eobj.BodyLastLevelDR)),3)
    s eobj.LevelType=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(id)),4)		//层级类型
  	
	s eobj.UseFlag=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(id)),5)				//状态（0编辑中，1已删除，2已审核）
	s eobj.UpdateUser=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(id)),6)			//编辑人员	
	s eobj.UpdateDate=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(id)),7)		//编辑时间
	s eobj.Remarks=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(id)),8)				//备注
    s str= eobj.JsonS()
    d eobj.%Close()
    //s str = "{list:["_str_"]}"
    q str
}

/// Creator:赵文伟
/// CreatDate:2021-11-18
/// Description:测试方法
/// Other: w ##class(web.CDSS.CMKB.BodyPartsLevel).Test()
ClassMethod Test()
{
	s eobj = ##class(web.CDSSEntity.CMKB.BodyPartsLevel).%New()
	s eobj.BodyPartDR="8006"	
	s eobj.BodyLastLevel="2042"
	s eobj.LevelType=1
	s eobj.UseFlag=0
	s eobj.UpdateUser=""
	s eobj.UpdateDate=""
	s eobj.Remarks=""

	w ..SaveData(eobj)
	q ""
}

/// Creator:赵文伟
/// CreatDate:2023-5-10
/// Description：数据重复验证方法，由js调用
/// Table:	CT.WDT.CDSS.BodyPartsLevel
/// Input：Id；code；name
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.BodyPartsLevel).FormValidate("","8006","1","2042")
ClassMethod FormValidate(id As %String, bodyPartDR As %String, leveltype As %String, parentDR As %String) As %String
{
    s flag="",flagc=""
    if (parentDR="") s parentDR=-100000000000000
    b ;1
    s:((bodyPartDR'="")&&(leveltype'="")) flagc=$d(^CT.WDT.CDSS.BodyPartsLevelI("BodyLastLevelIndex",bodyPartDR,leveltype,parentDR))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
		
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:((bodyPartDR'="")&&(leveltype'="")) idc=$o(^CT.WDT.CDSS.BodyPartsLevelI("BodyLastLevelIndex",bodyPartDR,leveltype,parentDR,0))
		if ((idc'="")&(idc'=id)&(flagc>0)) s flag=1  //返回重复标志
  		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:赵文伟
/// CreatDate:2021-11-18
/// Description：保存部位分层表的内容
/// Table：CT.WDT.CDSS.BodyPartsLevel
/// Input：web.CDSSEntity.CMKB.BodyPartsLevel实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.BodyPartsLevel).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.BodyPartsLevel) As %String
{
    //s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
    	s flag=..FormValidate(eobj.ID,eobj.BodyPartDR,eobj.LevelType,eobj.BodyLastLevel)		//调用别名重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
            
        }else{
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.BodyPartsLevel).%New()
            }
            else         	//如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.BodyPartsLevel).%OpenId(eobj.ID)
                s bobj = ##class(web.CDSSEntity.CMKB.BodyPartsLevel).%New()
                s bobj.ID=eobj.ID
				s:obj.BodyPartDR'="" bobj.BodyPartDR=obj.BodyPartDR.%Id()     		//部位指针
				s:obj.BodyLastLevel'="" bobj.BodyLastLevel=obj.BodyLastLevel.%Id()	//上级分类/父节点
				//s bobj.BodyPartDR =obj.BodyPartDR
				//s bobj.BodyLastLevel =obj.BodyLastLevel
				s bobj.LevelType =obj.LevelType 									//层级类型
				s bobj.UseFlag=obj.UseFlag							//状态（0编辑中，1已删除，2已审核）
				s bobj.UpdateUser=obj.UpdateUser					//编辑用户
				s bobj.UpdateDate=obj.UpdateDate					//编辑时间
				s bobj.Remarks=obj.Remarks							//备注
               
            }
            //d:eobj.BodyPartDR'="" obj.BodyPartDRSetObjectId(eobj.BodyPartDR)  
			//d:eobj.BodyPartDR="" obj.BodyPartDRSetObjectId("") 	
			//d:eobj.BodyLastLevel'="" obj.BodyLastLevelSetObjectId(eobj.BodyLastLevel)  
			//d:eobj.BodyLastLevel="" obj.BodyLastLevelSetObjectId("") 
            d obj.BodyPartDRSetObjectId(eobj.BodyPartDR)
            d obj.BodyLastLevelSetObjectId(eobj.BodyLastLevel)
            s obj.LevelType=eobj.LevelType
            s:eobj.UseFlag="" eobj.UseFlag=0						//状态（0编辑中，1已删除，2已审核）
            s obj.UseFlag=eobj.UseFlag
            s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))						//编辑用户
            s obj.UpdateUser=eobj.UpdateUser
            s eobj.UpdateDate=$ZDATETIME($HOROLOG,3)						//编辑时间
            s obj.UpdateDate=eobj.UpdateDate
            s obj.Remarks=eobj.Remarks								//备注
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
#;                s pobj=##class(web.CDSSEntity.CMKB.BodyPartsDict).%New()
#;                s pobj.ID=eobj.BodyPartDR
#;                s pobj.PartsDesc=eobj.BodyPartName
#;                s pobj.Alias=eobj.Alias
#;                s result=##class(web.CDSS.CMKB.BodyPartsDict).SaveEntity(pobj)
				s pobj=##class(CT.WDT.CDSS.BodyPartsDict).%OpenId(eobj.BodyPartDR)
				s OldAlilas=pobj.Alias
				s pobj.Alias=eobj.Alias
				s sc=pobj.%Save()
				//如果别名有了变动，则保存别名到别名通用表  
            	if ((eobj.BodyPartDR'="")&&(eobj.Alias'=OldAlilas))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.BodyPartsDict",eobj.BodyPartDR,eobj.Alias)
            	}

                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BodyPartsLevel","CT.WDT.CDSS.BodyPartsLevel","部位分层字典",id,eobj.BodyPartDR,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BodyPartsLevel","CT.WDT.CDSS.BodyPartsLevel","部位分层字典",eobj.ID,eobj.BodyPartDR,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("部位分层字典","web.CDSS.CMKB.BodyPartsLevel","SaveData",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("部位分层字典","web.CDSS.CMKB.BodyPartsLevel","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate:2021-11-18
/// Description：根据ID删除部位分层表的内容
/// Table：CT.WDT.CDSS.BodyPartsLevel
/// Input：id-部位分层表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.CMKB.BodyPartsLevel).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
	s result = "",flag=""
	s flag=$d(^CT.WDT.CDSS.BodyPartsLevelI("ParentIndex",id)) //判断该菜单是否被引用
	if (flag>0)
	{
		s result = "{success:'false',info:'该数据下已有子节点,禁止删除！'}"   
	}
	else
	{
		s obj=##class(CT.WDT.CDSS.BodyPartsLevel).%OpenId(id)    
        s bobj = ##class(web.CDSSEntity.CMKB.BodyPartsLevel).%New()
        s bobj.ID=id
        
        
		s:obj.BodyPartDR'="" bobj.BodyPartDR=obj.BodyPartDR.%Id()     		//部位指针
		s:obj.BodyLastLevel'="" bobj.BodyLastLevel=obj.BodyLastLevel.%Id()	//上级分类/父节点
		s bobj.LevelType =obj.LevelType 									//层级类型
		s bobj.UseFlag=obj.UseFlag							//状态（0编辑中，1已删除，2已审核）
		s bobj.UpdateUser=obj.UpdateUser					//编辑用户
		s bobj.UpdateDate=obj.UpdateDate					//编辑时间
		s bobj.Remarks=obj.Remarks							//备注								//备注
		d obj.%Close()
        k obj
		
		Tstart
		s sc=##class(CT.WDT.CDSS.BodyPartsLevel).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tcommit
			s result = "{success:'true',info:'删除成功！'}" 
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BodyPartsLevel","CT.WDT.CDSS.BodyPartsLevel","部位分层字典",id,bobj.BodyPartDR,"D",bobj)
            d bobj.%Close()
		}
		else 
		{
			Trollback
			s result ="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorText(sc)_"'}"
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("部位分层字典","web.CDSS.CMKB.BodyPartsLevel","DeleteData",bobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator：赵文伟   
/// CreatDate: 2022-01-25
/// Description：同步删除接口【在部位字典中调用】
/// Table：CT.WDT.CDSS.BodyPartsLevel
/// Input：BodyPartDR
/// Return：result
/// w ##class(web.CDSS.CMKB.BodyPartsLevel).SynchDelete(6098)
ClassMethod SynchDelete(PartDR As %String) As %String
{
	s ID=""
	s ID=$o(^CT.WDT.CDSS.BodyPartsLevelI("BodyPartDRIndex",PartDR,ID))
	s result = "",flag=""
	if (ID'="")
	{
		s result = "",flag=""
		s flag=$d(^CT.WDT.CDSS.BodyPartsLevelI("ParentIndex",ID)) //判断该菜单是否被引用
	
		if (flag>0)
		{
			s result = "{success:'false',info:'该数据在部位分层表中引用且有子节点,禁止删除！'}"   
		}
		else
		{
			s obj=##class(CT.WDT.CDSS.BodyPartsLevel).%OpenId(ID)    
        	s bobj = ##class(web.CDSSEntity.CMKB.BodyPartsLevel).%New()
        	s bobj.ID=ID
        	s:obj.BodyPartDR'="" bobj.BodyPartDR=obj.BodyPartDR.%Id()     		//部位指针
			s:obj.BodyLastLevel'="" bobj.BodyLastLevel=obj.BodyLastLevel.%Id()	//上级分类/父节点
			s bobj.LevelType =obj.LevelType 									//层级类型
			s bobj.UseFlag=obj.UseFlag							//状态（0编辑中，1已删除，2已审核）
			s bobj.UpdateUser=obj.UpdateUser					//编辑用户
			s bobj.UpdateDate=obj.UpdateDate					//编辑时间
			s bobj.Remarks=obj.Remarks							//备注								//备注
			d obj.%Close()
        	k obj
		
			Tstart
			s sc=##class(CT.WDT.CDSS.BodyPartsLevel).%DeleteId(ID)
			if $$$ISOK(sc)
			{
				Tcommit
				s result = "{success:'true',info:'删除成功！'}" 
				d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BodyPartsLevel","CT.WDT.CDSS.BodyPartsLevel","部位分层字典",ID,bobj.BodyPartDR,"D",bobj)
            	d bobj.%Close()
			}
			else 
			{
				Trollback
				s result ="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorText(sc)_"'}"
				s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("部位分层字典","web.CDSS.CMKB.BodyPartsLevel","DeleteData",bobj)
            	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			}
		}
	}
	q result
}

/// Creator：赵文伟   
/// CreatDate: 2021-11-18
/// Description：查询数据  下拉框
/// Table：CT.WDT.CDSS.BodyPartsLevel
/// Input：父节点 层级类型【0：系统；1：解剖】
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.CMKB.BodyPartsLevel).GetJsonDataForCmb("","1")
ClassMethod GetJsonDataForCmb(parentcatdr As %String, type As %String) As %String
{
	s IDStr=""
	if (parentcatdr="") s parentcatdr=-100000000000000
	s myJsonStr=""

	//输出菜单JSON串
	s myRowID=0
	s childStr=""
	w "["
	s count=0
	for {
		s myRowID=$o(^CT.WDT.CDSS.BodyPartsLevelI("LevelIndex",type,parentcatdr,myRowID)) q:myRowID=""
		
		s count=count+1
		s BodyPartDR=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(myRowID)),2)			//部位指针
		s BodyPartName = ""
    	s:BodyPartDR'="" BodyPartName=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyPartDR)),3) //部位名称
		s LevelType=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(myRowID)),4)		//层级类型
		s newtype=LevelType
		s:LevelType'="" LevelType=$case(LevelType,0:"系统",1:"解剖",:"")
		if count>1 w ","
		
		w "{""id"":"""_myRowID_""",""text"":"""_BodyPartName_""",""type"":"""_LevelType_""""
		
		s childStr=..GetChildOrderedIDStr(myRowID)
		if childStr'=""
		{
			w ",""state"":""open"""
			w ",""children"":"
			w ..GetJsonDataForCmb(myRowID,newtype)	
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

/// Creator：赵文伟
/// CreatDate:2021-11-18
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：CT.WDT.CDSS.BodyPartsLevel
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.CDSS.CMKB.BodyPartsLevel).GetChildOrderedIDStr("")
ClassMethod GetChildOrderedIDStr(LastLevel As %String) As %String
{
	s IDStr=""
	if (LastLevel="") s LastLevel=-100000000000000
	s myJsonStr=""
	
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	for {
		s myRowID=$o(^CT.WDT.CDSS.BodyPartsLevelI("ParentIndex",LastLevel,myRowID)) q:myRowID=""
		s childStr=..GetChildOrderedIDStr(myRowID)
		s:childStr'="" childStr=myRowID_"^"_childStr
		s:childStr="" childStr=myRowID
		s:IDStr="" IDStr=childStr
		s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// Creator：赵文伟
/// CreatDate: 2021-11-19
/// Description:状态修改
/// Input:id useflag(0编辑中,1已删除,2已审核)
/// Table：CT.WDT.CDSS.BodyPartsLevel
/// Other: w ##class(web.CDSS.CMKB.BodyPartsLevel).UpdateUseFlag(2041,"弃用")
ClassMethod UpdateUseFlag(RowId, Operation) As %String
{
	s result=""
	if (Operation="弃用")
	{
		s flag=$d(^CT.WDT.CDSS.BodyPartsLevelI("ParentIndex",RowId)) //判断该数据是否被引用
		
		if (flag>0)
		{
			q "{success:'false',info:'该数据下已有子节点,禁止弃用！'}"  
		}	
	}
	s eobj = ##class(web.CDSSEntity.CMKB.BodyPartsLevel).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.BodyPartsLevel).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.BodyPartsLevel).%New()
	s bobj.UseFlag=obj.UseFlag
	s bobj.UpdateDate=obj.UpdateDate
	s bobj.UpdateUser=obj.UpdateUser
	
	s obj.UseFlag=eobj.UseFlag
 	s obj.UpdateDate=eobj.UpdateDate
 	s obj.UpdateUser=eobj.UpdateUser
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//同步修改部位字典数据状态
		s BodyPartDR= $lg($g(^CT.WDT.CDSS.BodyPartsLevelD(RowId)),2)
		d ##class(web.CDSS.CMKB.BodyPartsDict).UpdateUseFlag(BodyPartDR,Operation)
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.BodyPartsLevel","CT.WDT.CDSS.BodyPartsLevel","部位分层字典",RowId,obj.BodyPartDR_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:赵文伟
/// CreatDate:2021-11-23
/// Description：导出数据
/// Other:w ##class(web.CDSS.CMKB.BodyPartsLevel).ExportBodyPartsLevelData()
ClassMethod ExportBodyPartsLevelData(desc As %String, type As %String = 1) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"部位分层字典数据.txt"		
	s file=""			 	;key转放到web目录下
	if (Path["\"){
		s DirName = Path_"scripts\bdp\CDSS\DataExport\"
		s file = Path_"scripts\bdp\CDSS\DataExport\"_fileName
	}else{
		s DirName = Path_"scripts/bdp/CDSS/DataExport/"
		s file = Path_"scripts/bdp/CDSS/DataExport/"_fileName
	}
	if '##class(%File).DirectoryExists(DirName){	//文件保存路径不存在，新建文件夹
		d ##class(%File).CreateDirectoryChain(DirName)
	}
	o file:"NWS"
	u file
	w "ID	部位名称	父节点	层级类型	状态	操作人员	操作时间	备注"
	s:desc'="" desc=$ZCONVERT(desc,"U") 
	//s parentdr=-100000000000000
	s ID=0
	for{
		s ID=$o(^CT.WDT.CDSS.BodyPartsLevelD(ID))
		q:ID=""
		s BodyPartDR= $lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),2)			//部位指针
		s BodyPartName = ""
		s:BodyPartDR'="" BodyPartName =$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyPartDR)),3) //部位名称
		continue:(desc'="")&&($ZCONVERT(BodyPartName,"U")'[desc)
		s BodyLastLevel = $lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),3)				//父节点DR  
		s BodyLastLevelDR =""
		s:BodyLastLevel'="" BodyLastLevelDR =$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(BodyLastLevel)),2)	//父节点部位指针
		s BodyLastLevelName =""
		s:BodyLastLevelDR'="" BodyLastLevelName =$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyLastLevelDR)),3)	//父节点名称
		
		s LevelType=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),4)				//层级类型
		continue:(type'="")&&(type'=LevelType)
		s:LevelType'="" LevelType=$case(LevelType,0:"系统",1:"解剖",:"")
		s UseFlag=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),5)				//状态【0编辑中，1已删除，2已审核】
		s:UseFlag'="" UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"编辑中")
		s UpdateUser=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),6)			//编辑人员
		s UpdateDate=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),7)			//编辑时间
		s Remarks=$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(ID)),8)				//备注
		s Remarks=$replace(Remarks,"""","''")
		
		w !,ID_"	"_BodyPartName_"	"_BodyLastLevelName_"	"_LevelType_"	"_UseFlag_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks
	}
	
	c file
	q fileName
}

/// Creator: 赵文伟 
/// CreatDate: 2021-11-19
/// Description: 批量通过
/// Table: CT.WDT.CDSS.BodyPartsLevel
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.BodyPartsLevel).ChangeStatusPass("131,132")
ClassMethod ChangeStatusPass(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)

			s flag=..UpdateUseFlag(id,"通过")

			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
		q result
}

/// Creator: 赵文伟 
/// CreatDate: 2021-11-19
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.BodyPartsLevel
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.BodyPartsLevel).ChangeStatusBack("131,132")
ClassMethod ChangeStatusBack(RowIdStr As %String)
{
	s result=""
	s errorflag=0
	s num=$l(RowIdStr,",")
	q:RowIdStr="" "false"
	TS
	if (num>=1)
	{
		for m=1:1:num
		{
			s id=$p(RowIdStr,",",m)
			s flag=..UpdateUseFlag(id,"驳回")

			if (flag'["true"){
				s errorflag = errorflag+1
			}
		}
	}
	if (errorflag'=0)
	{
		tro
		s result="false"	
	}
	else
	{
		tc
		s result="true"	
	}
		q result
}

/// Creator: 赵文伟
/// CreatDate: 2021-11-23
/// Description：导入数据[部位分层表-解剖]
/// Table: CT.WDT.CDSS.BodyPartsLevel
/// Input：path(路径)
/// Return：
/// Other: w ##class(web.CDSS.CMKB.BodyPartsLevel).ImportData("D:\字典数据\部位分层字典-解剖.csv")
ClassMethod ImportData(path)
{
	s readcount=0   	//读取总数
	s savecount=0		//导入成功总数
	s nosavecount=0 	//导入失败总数
	s incount=0			//已存在总数
	s num=0
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	s Level2=""
	s Level3=""
	s Level4=""
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s readcount=readcount+1
		s BodyPartName1=$p(str,",",1)
		s BodyPartName2=$p(str,",",2)
		s BodyPartName3=$p(str,",",3)
		s BodyPartName4=$p(str,",",4)
		
		if (BodyPartName1'="")
		{
			s Level2=BodyPartName1
		}
		if (BodyPartName2'="")
		{
			s Level3=BodyPartName2
		}
		if (BodyPartName3'="")
		{
			s Level4=BodyPartName3
		}
		s readcount=readcount+1
		
		if (BodyPartName1'="")
		{
			s TBodyPartName=BodyPartName1
			s Parent=""
			d SaveData
			
		}
		if (BodyPartName2'="")
		{
			s TBodyPartName=BodyPartName2
			s Parent=Level2
			d SaveData
		}
		if (BodyPartName3'="")
		{
			s TBodyPartName=BodyPartName3
			s Parent=Level3
			d SaveData
		}
		if (BodyPartName4'="")
		{
			s TBodyPartName=BodyPartName4
			s Parent=Level4
			d SaveData
		}
			
	}
	q "{success:'true',readcount:'"_readcount_"',savecount:'"_savecount_"',nosavecount:'"_nosavecount_"',incount:'"_incount_"'}"
SaveData
	s RowID=$o(^CT.WDT.CDSS.BodyPartsLevelI("BodyPartDRIndex"," "_TBodyPartName,0))
	
	s BodyPartName=$zstrip(TBodyPartName,"<>W")			//去除两端空白
	s BodyPartDR=""
	s:BodyPartName'="" BodyPartDR=$o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_BodyPartName,""),-1)

	s BodyLastLevelDR=""
	s BodyLastLevelName=Parent		//父节点描述
	s BodyLastLevelName=$zstrip(BodyLastLevelName,"<>W")			//去除两端空白
	s:BodyLastLevelName'="" BodyLastLevelDR=$o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_BodyLastLevelName,""),-1) //父节点部位指针
	s BodyLastLevel=""
	s:BodyLastLevelDR'="" BodyLastLevel=$o(^CT.WDT.CDSS.BodyPartsLevelI("BodyPartDRIndex",BodyLastLevelDR,""),-1)
	
	if RowID=""
	{
		TS											//代码
		s obj = ##class(CT.WDT.CDSS.BodyPartsLevel).%New()
		
    	d obj.BodyPartDRSetObjectId(BodyPartDR)
    	d obj.BodyLastLevelSetObjectId(BodyLastLevel)
    	s obj.LevelType="1"
    	s obj.UseFlag="0"												//状态
    	s obj.UpdateUser="dhcc"											//编辑用户
		s obj.UpdateDate=$ZDT($H,3)										//编辑时间
		s obj.Remarks=""
		s sc=obj.%Save()
		d obj.%Close()
		if ($$$ISOK(sc))
		{
			TC
			s savecount=savecount+1
		}
		else
		{
			TRO
			s nosavecount=nosavecount+1	
		}		
	}
	else
	{
		
		s BodyLastLevel = $lg($g(^CT.WDT.CDSS.BodyPartsLevelD(RowID)),3)				//父节点DR  
		s BodyLastLevelDR =""
		s:BodyLastLevel'="" BodyLastLevelDR =$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(BodyLastLevel)),2)	//父节点部位指针
		if BodyLastLevelName '=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyLastLevelDR)),3)	//父节点名称
		
		{
			TS											//代码
			s obj = ##class(CT.WDT.CDSS.BodyPartsLevel).%OpenId(RowID)
			//d obj.BodyPartDRSetObjectId(BodyPartDR)
    		d obj.BodyLastLevelSetObjectId(BodyLastLevel)
        	s obj.LevelType="1"
        	s obj.UseFlag="0"												//状态
        	s obj.UpdateUser="dhcc"											//编辑用户
			s obj.UpdateDate=$ZDT($H,3)										//编辑时间
			s obj.Remarks=""
			s sc=obj.%Save()
			d obj.%Close()
			if ($$$ISOK(sc))
			{
				TC
				s savecount=savecount+1
			}
			else
			{
				TRO
				s nosavecount=nosavecount+1	
			}		
		}
		else
		{
			s incount=incount+1	
		}
	}
}

/// Creator: 赵文伟
/// CreatDate: 2021-11-30
/// Description：导入数据[部位分层表-系统]
/// Table: CT.WDT.CDSS.BodyPartsLevel
/// Input：path(路径)
/// Return：
/// Other: w ##class(web.CDSS.CMKB.BodyPartsLevel).ImportSysData("D:\字典数据\部位分层字典-系统.csv")
ClassMethod ImportSysData(path)
{
	s readcount=0   	//读取总数
	s savecount=0		//导入成功总数
	s nosavecount=0 	//导入失败总数
	s incount=0			//已存在总数
	s num=0
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	s Level2=""
	s Level3=""
	s Level4=""
	s Level5=""
	s Level6=""
	s Level7=""
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s readcount=readcount+1
		s BodyPartName1=$p(str,",",1)
		s BodyPartName2=$p(str,",",2)
		s BodyPartName3=$p(str,",",3)
		s BodyPartName4=$p(str,",",4)
		s BodyPartName5=$p(str,",",5)
		s BodyPartName6=$p(str,",",6)
		s BodyPartName7=$p(str,",",7)
		
		if (BodyPartName1'="")
		{
			s Level2=BodyPartName1
		}
		if (BodyPartName2'="")
		{
			s Level3=BodyPartName2
		}
		if (BodyPartName3'="")
		{
			s Level4=BodyPartName3
		}
		if (BodyPartName4'="")
		{
			s Level5=BodyPartName4
		}
		if (BodyPartName5'="")
		{
			s Level6=BodyPartName5
		}
		if (BodyPartName6'="")
		{
			s Level7=BodyPartName6
		}
		
		s readcount=readcount+1
		
		if (BodyPartName1'="")
		{
			s TBodyPartName=BodyPartName1
			s Parent=""
			d SaveData
			
		}
		if (BodyPartName2'="")
		{
			s TBodyPartName=BodyPartName2
			s Parent=Level2
			d SaveData
		}
		if (BodyPartName3'="")
		{
			s TBodyPartName=BodyPartName3
			s Parent=Level3
			d SaveData
		}
		if (BodyPartName4'="")
		{
			s TBodyPartName=BodyPartName4
			s Parent=Level4
			d SaveData
		}
		if (BodyPartName5'="")
		{
			s TBodyPartName=BodyPartName5
			s Parent=Level5
			d SaveData
		}
		if (BodyPartName6'="")
		{
			s TBodyPartName=BodyPartName6
			s Parent=Level6
			d SaveData
		}
		if (BodyPartName7'="")
		{
			s TBodyPartName=BodyPartName7
			s Parent=Level7
			d SaveData
		}
			
	}
	
	q "{success:'true',readcount:'"_readcount_"',savecount:'"_savecount_"',nosavecount:'"_nosavecount_"',incount:'"_incount_"'}"
SaveData
	s RowID=$o(^CT.WDT.CDSS.BodyPartsLevelI("BodyPartDRIndex"," "_TBodyPartName,0))
	
	s BodyPartName=$zstrip(TBodyPartName,"<>W")			//去除两端空白
	s BodyPartDR=""
	s:BodyPartName'="" BodyPartDR=$o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_BodyPartName,""),-1)

	s BodyLastLevelDR=""
	s BodyLastLevelName=Parent		//父节点描述
	s BodyLastLevelName=$zstrip(BodyLastLevelName,"<>W")			//去除两端空白
	s:BodyLastLevelName'="" BodyLastLevelDR=$o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_BodyLastLevelName,""),-1) //父节点部位指针
	s BodyLastLevel=""
	s:BodyLastLevelDR'="" BodyLastLevel=$o(^CT.WDT.CDSS.BodyPartsLevelI("BodyPartDRIndex",BodyLastLevelDR,""),-1)
	

	if RowID=""
	{
		TS											//代码
		s obj = ##class(CT.WDT.CDSS.BodyPartsLevel).%New()
		
    	d obj.BodyPartDRSetObjectId(BodyPartDR)
    	d obj.BodyLastLevelSetObjectId(BodyLastLevel)
    	s obj.LevelType="0"
    	s obj.UseFlag="0"												//状态
    	s obj.UpdateUser="dhcc"											//编辑用户
		s obj.UpdateDate=$ZDT($H,3)										//编辑时间
		s obj.Remarks=""
		s sc=obj.%Save()
		d obj.%Close()
		if ($$$ISOK(sc))
		{
			TC
			s savecount=savecount+1
		}
		else
		{
			TRO
			s nosavecount=nosavecount+1	
		}		
	}
	else
	{
		
		s BodyLastLevel = $lg($g(^CT.WDT.CDSS.BodyPartsLevelD(RowID)),3)				//父节点DR  
		s BodyLastLevelDR =""
		s:BodyLastLevel'="" BodyLastLevelDR =$lg($g(^CT.WDT.CDSS.BodyPartsLevelD(BodyLastLevel)),2)	//父节点部位指针
		if BodyLastLevelName '=$lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyLastLevelDR)),3)	//父节点名称
		
		{
			TS											//代码
			s obj = ##class(CT.WDT.CDSS.BodyPartsLevel).%OpenId(RowID)
			//d obj.BodyPartDRSetObjectId(BodyPartDR)
    		d obj.BodyLastLevelSetObjectId(BodyLastLevel)
        	s obj.LevelType="0"
        	s obj.UseFlag="0"												//状态
        	s obj.UpdateUser="dhcc"											//编辑用户
			s obj.UpdateDate=$ZDT($H,3)										//编辑时间
			s obj.Remarks=""
			s sc=obj.%Save()
			d obj.%Close()
			if ($$$ISOK(sc))
			{
				TC
				s savecount=savecount+1
			}
			else
			{
				TRO
				s nosavecount=nosavecount+1	
			}		
		}
		else
		{
			s incount=incount+1	
		}
	}
}

/// Creator: 赵文伟
/// CreatDate: 2021-11-30
/// Description：处理数据[部位分层表-系统]（返回部位字典不存在的数据）
/// Table: CT.WDT.CDSS.BodyPartsLevel
/// Input：path(路径)
/// Return：
/// Other: w ##class(web.CDSS.CMKB.BodyPartsLevel).HandleSysData("D:\字典数据\部位分层字典-系统.csv")
ClassMethod HandleSysData(path)
{
	s readcount=0   	//读取总数
	s exist=0		//已存在数据总数
	s inexist=0 	//不存在数据总数
	s num=0
	
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	s Level2=""
	s Level3=""
	s Level4=""
	s Level5=""
	s Level6=""
	s Level7=""
	
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s readcount=readcount+1
		s BodyPartName1=$p(str,",",1)
		s BodyPartName2=$p(str,",",2)
		s BodyPartName3=$p(str,",",3)
		s BodyPartName4=$p(str,",",4)
		s BodyPartName5=$p(str,",",5)
		s BodyPartName6=$p(str,",",6)
		s BodyPartName7=$p(str,",",7)
		
		if (BodyPartName1'="")
		{
			s Level2=BodyPartName1
		}
		if (BodyPartName2'="")
		{
			s Level3=BodyPartName2
		}
		if (BodyPartName3'="")
		{
			s Level4=BodyPartName3
		}
		if (BodyPartName4'="")
		{
			s Level5=BodyPartName4
		}
		if (BodyPartName5'="")
		{
			s Level6=BodyPartName5
		}
		if (BodyPartName6'="")
		{
			s Level7=BodyPartName6
		}
		
		s readcount=readcount+1
		
		if (BodyPartName1'="")
		{
			s TBodyPartName=BodyPartName1
			s Parent=""
			d SaveData
			
		}
		if (BodyPartName2'="")
		{
			s TBodyPartName=BodyPartName2
			s Parent=Level2
			d SaveData
		}
		if (BodyPartName3'="")
		{
			s TBodyPartName=BodyPartName3
			s Parent=Level3
			d SaveData
		}
		if (BodyPartName4'="")
		{
			s TBodyPartName=BodyPartName4
			s Parent=Level4
			d SaveData
		}
		if (BodyPartName5'="")
		{
			s TBodyPartName=BodyPartName5
			s Parent=Level5
			d SaveData
		}
		if (BodyPartName6'="")
		{
			s TBodyPartName=BodyPartName6
			s Parent=Level6
			d SaveData
		}
		if (BodyPartName7'="")
		{
			s TBodyPartName=BodyPartName7
			s Parent=Level7
			d SaveData
		}
			
	}
	//}
	q "{success:'true',readcount:'"_readcount_"',exist'"_exist_"',inexist'"_inexist_"'}"
SaveData
	s RowID=$o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_TBodyPartName,0))
	
	if RowID=""
	{
		w TBodyPartName,!
		s inexist=inexist+1
	}
	else
	{
		s exist=exist+1
	}
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.BodyPartsLevel
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.BodyPartsLevel).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.BodyPartsLevelD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.BodyPartsLevelD(RowId)),5)       
		if (UseFlag'="")
		{
			if (UseFlag=0){
				s editcount=editcount+1
			} elseif (UseFlag=2){
				s auditcount=auditcount+1
			}
		}	 
		s totalcount=editcount+auditcount	
	}
	q totalcount_"^"_editcount_"^"_auditcount_"^"_unauditcount
}

/// Creator:赵文伟
/// CreatDate:2022-11-10
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BodyPartsLevel","GetLogList","20")
Query GetLogList(RowId As %String) As %Query(ROWSPEC = "LogID,UpdateDate,UpdateTime,UpdateUserName,Operation")
{
}

ClassMethod GetLogListExecute(ByRef qHandle As %Binary, RowId As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s str=""
 	if (RowId'="")
 	{
		s LogID=""
	    for
	    {
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.BodyPartsLevel",RowId,LogID),-1) q:LogID=""
	    	s UpdateUserName=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),7)
	    	s UpdateDate=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),8)
	    	s UpdateDate=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(UpdateDate)
          	s UpdateTime=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),9)
          	s UpdateTime=##class(web.DHCBL.BDP.FunLib).TimeLogicalToHtml(UpdateTime)
          	s ObjectDesc=$LISTGET($G(^CF.WDT.CDSS.DataChangeLogD(LogID)),13)   //新增对象描述
          	if (ObjectDesc["&&")
          	{
	          	s Operation=$p(ObjectDesc,"&&",2)
          	}
         	else
         	{
          		s Operation="编辑"
         	}
         	d OutputRowLog
	    }
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowLog
	set Data=$lb(LogID,UpdateDate,UpdateTime,UpdateUserName,Operation)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetLogListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLogListExecute ]
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

ClassMethod GetLogListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLogListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：赵文伟 
/// CreatDate: 2023-04-25
/// Description：根据描述获取DR
/// Table: CT.WDT.CDSS.BodyPartsLevel
/// Output: 
/// Other: w ##class(web.CDSS.CMKB.BodyPartsLevel).GetBodyPartDR("QWE") 
ClassMethod GetBodyPartDR(desc) As %String
{
	s ID=""
	s:desc'="" ID=$o(^CT.WDT.CDSS.BodyPartsDictI("DescIndex"," "_desc,0))
	q ID
}

/// Creator：赵文伟 
/// CreatDate: 2023-04-25
/// Description：根据ID取状态
/// Table: CT.WDT.CDSS.BodyPartsDict
/// Output: 
/// Other: w ##class(web.CDSS.CMKB.BodyPartsLevel).GetUseFlag("") 
ClassMethod GetUseFlag(id) As %String
{
	s UseFlag=""
	s:id'="" UseFlag= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(id)),4)
	q UseFlag
}

/// Creator:赵文伟
/// CreatDate:2022-01-28
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.BodyPartsLevel
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.BodyPartsLevel","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
	 	s BodyPartDR= $lg($g(^CT.WDT.CDSS.BodyPartsLevelD(id)),2)
		s Alias= $lg($g(^CT.WDT.CDSS.BodyPartsDictD(BodyPartDR)),8)
		s Len=$Length(Alias,",")
		for i=1:1:Len{
			s Desc=$p(Alias,",",i)
			continue:(Desc="")
			d OutputRowKeyWords
		}
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowKeyWords
	set Data=$lb(Desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetAliasListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAliasListExecute ]
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

ClassMethod GetAliasListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAliasListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
