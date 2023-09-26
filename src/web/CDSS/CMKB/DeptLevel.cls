/// 描述:科室分层 
/// 描述:包含增删改查
/// 编写者:赵文伟
/// 编写日期:2023-01-04
Class web.CDSS.CMKB.DeptLevel Extends %RegisteredObject
{

/// Creator:赵文伟
/// CreatDate:2023-01-04
/// Description：查询页面数据
/// Table： CT.WDT.CDSS.DiseaseDeptDict
/// Input：父节点
/// Return：treegrid格式数据串
/// Other:w ##class(web.CDSS.CMKB.DeptLevel).GetJsonList("26")
ClassMethod GetJsonList(id As %String = "") As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s myJsonStr=""	
	//输出菜单JSON串
	s myJsonStr=myJsonStr_"["
	s RowId=0
	s count=0
	
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",parentcatdr,RowId))
		q:RowId=""
		s count=count+1
		s DeptCode= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),2)		//编码
		s DeptName= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),3)		//名称
		s FatherCodeDR= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),4)	//父级科室
		s FatherCodeDRName=""
		s:FatherCodeDR'="" FatherCodeDRName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(FatherCodeDR)),3)
		s DeptGrade= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),5)		//科室分级
		s DeptGrade=$case(DeptGrade,1:"一级",2:"二级",3:"三级",:"")
		s DeptClass= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),6)		//科室分类
		
		s UseFlag= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),7)			//状态（0编辑中，1已弃用，2已审核）
	    s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"编辑中") 
	    s CreateUserID= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),9) 	//操作人员
	    s CreateDate= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),8)		//操作时间
	    s Remarks= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),10)        //备注
	    s DeptAlias=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),11)		//别名
		
		if count>1 s myJsonStr=myJsonStr_","
		s myJsonStr=myJsonStr_"{""id"":"""_RowId_""""
		s myJsonStr=myJsonStr_",""RowId"":"""_RowId_""",""DeptCode"":"""_DeptCode_""",""DeptName"":"""_DeptName_""",""FatherCodeDR"":"""_FatherCodeDR_""",""FatherCodeDRName"":"""_FatherCodeDRName
				_""",""DeptAlias"":"""_DeptAlias_""",""DeptGrade"":"""_DeptGrade_""",""DeptClass"":"""_DeptClass_""",""UseFlag"":"""_UseFlag_""",""CreateUserID"":"""_CreateUserID_""",""CreateDate"":"""_CreateDate_""",""Remarks"":"""_Remarks_""""
		s myChildFlag=$d(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",RowId))
        if (myChildFlag) //有子菜单不是叶子节点
        {
	        //一次性加载   
			s myJsonStr=myJsonStr_",""state"":""open"""   //closed节点不展开,open节点展开
			s myJsonStr=myJsonStr_",""children"":"
			s myJsonStr=myJsonStr_..GetJsonList(RowId)
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
/// CreatDate:2023-01-04
/// Description：修改时打开的数据
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Input：id-科室分层的rowid
/// Return:Json格式的字符串{}
/// Other: w ##class(web.CDSS.CMKB.DeptLevel).OpenDataJSON("")
ClassMethod OpenDataJSON(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
    s eobj.RowId=id
    
    s eobj.DeptCode= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(id)),2)		//编码
	s eobj.DeptName= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(id)),3)		//名称
	s eobj.FatherCodeDR= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(id)),4)	//父级科室
	s eobj.FatherCodeDRName=""
	s:eobj.FatherCodeDR'="" eobj.FatherCodeDRName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(eobj.FatherCodeDR)),3)
	s eobj.DeptGrade= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(id)),5)		//科室分级
	s eobj.DeptClass= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(id)),6)		//科室分类
	s eobj.UseFlag= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(id)),7)			//状态（0编辑中，1已弃用，2已审核）
	s eobj.CreateUserID= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(id)),9) 	//操作人员
	s eobj.CreateDate= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(id)),8)		//操作时间
	s eobj.Remarks= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(id)),10)       //备注
	s eobj.DeptAlias=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(id)),11)		//别名
    
    s str= eobj.JsonS()
    d eobj.%Close()
    q str
}

/// Creator:赵文伟
/// CreatDate:2023-01-04
/// Description：重复校验
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.CDSS.CMKB.DeptLevel).Validate("","","")
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
	s flag="",flagc="",flagd=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.DiseaseDeptDictI("CodeIndex",code))
	s:desc'="" flagd=$d(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex",desc))
	if (id="") //如果为空，增加时的重复判断
	{
		if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc="",idd=""
		s:code'="" idc=$o(^CT.WDT.CDSS.DiseaseDeptDictI("CodeIndex",code,0))
		s:desc'="" idd=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex",desc,0))
		
		if (((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0))) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志

	}
	q flag
}

/// Other: d ##class(web.CDSS.CMKB.DeptLevel).TestSaveData()
ClassMethod TestSaveData() As %String
{
	s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
	s eobj.RowId=57
	s eobj.DeptCode="adasd"
	s eobj.DeptName="测试测"
	s eobj.FatherCodeDR=1
	s eobj.DeptGrade=3
	s eobj.DeptClass="qqq"
	s eobj.DeptAlias="AA,BB,CC"
	
	s re=..SaveData(eobj)
	b ;4
	q re
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.DeptLevel).ValidateAlias("","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod ValidateAlias(id As %String, name As %String, aliasStr As %String) As %String
{
	s flag=0
	s len = $l(aliasStr,",")
	for i=1:1:len
	{
		s Alias=$p(aliasStr,",",i)
		if (Alias="") continue  //别名为空，则跳过
		if (Alias=name)
		{
			s flag=1  //如果别名=名称，则数据重复
			q
		}
		
		s Alias=" "_$ZCONVERT(Alias,"U") //别名转换成大写
	    s flagA="",flagN=""
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.DiseaseDeptDict",Alias))
	    s flagN=$d(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex",Alias))
	    if (id="")	//如果为空，增加时的重复判断
	    {
	        if ((flagA>0)||(flagN>0)) 
	        {
		        s flag=1  //返回重复标志
		        q
	        }
	    }
	    else 	//如果不为空，修改时的重复判断
	    {
	        s idA="",idN=""
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.DiseaseDeptDict",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator:赵文伟
/// CreatDate:2023-01-04
/// Description：保存科室分层表的内容
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Input：web.CDSSEntity.CMKB.DiseaseDeptDict实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.DeptLevel).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DiseaseDeptDict) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
    	
    	s flag=..Validate(eobj.RowId,eobj.DeptCode,eobj.DeptName)  //重复校验
		q:flag=1 "{success:'false',errorinfo:'该记录已经存在'}"
		
		s flagAlias=..ValidateAlias(eobj.RowId,eobj.DeptName,eobj.DeptAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		
        if (eobj.RowId="")  //如果RowId未赋值则增加
        {
            s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%New()
        }
        else         	//如果RowId已赋值则修改
        {
            s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%OpenId(eobj.RowId)
            s bobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
            s bobj.RowId=eobj.RowId

            s bobj.DeptCode= obj.DeptCode		//编码
			s bobj.DeptName= obj.DeptName		//名称
			s:obj.FatherCodeDR'="" bobj.FatherCodeDR= obj.FatherCodeDR.%Id()	//父级科室
				
			s bobj.FatherCodeDRName=""
			s:bobj.FatherCodeDR'="" bobj.FatherCodeDRName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(bobj.FatherCodeDR)),3)
			s bobj.DeptGrade= obj.DeptGrade		//科室分级
			s bobj.DeptClass= obj.DeptClass		//科室分类
			s bobj.UseFlag= obj.UseFlag			//状态（0编辑中，1已弃用，2已审核）
			s bobj.CreateUserID= obj.CreateUserID 	//操作人员
			s bobj.CreateDate= obj.CreateDate		//操作时间
			s bobj.Remarks= obj.Remarks       //备注
			s bobj.DeptAlias=obj.DeptAlias		//别名
				
        }
        s obj.DeptCode= eobj.DeptCode		//编码
		s obj.DeptName= eobj.DeptName		//名称
		d obj.FatherCodeDRSetObjectId(eobj.FatherCodeDR)	//父级科室
		s obj.DeptGrade= eobj.DeptGrade		//科室分级
		s obj.DeptClass= eobj.DeptClass		//科室分类
		s obj.UseFlag= eobj.UseFlag			//状态（0编辑中，1已弃用，2已审核）
		s:eobj.CreateUserID'="" obj.CreateUserID= eobj.CreateUserID 	//操作人员
			
		if (eobj.CreateDate="")	//操作时间
		{
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s obj.CreateDate=eobj.CreateDate
		}
		else
		{
			s obj.CreateDate=eobj.CreateDate
		}
		s obj.Remarks= eobj.Remarks       //备注
		s obj.DeptAlias=eobj.DeptAlias		//别名
           
        Ts
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                
            //保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDeptDict","CT.WDT.CDSS.DiseaseDeptDict","科室分层字典",id,eobj.DeptName,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDeptDict","CT.WDT.CDSS.DiseaseDeptDict","科室分层字典",eobj.RowId,eobj.DeptName,"U",eobj,bobj)
           	//同步修改对照数据
			d:eobj.RowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("科室",bobj.DeptCode_"[A]"_bobj.DeptName,eobj.DeptCode_"[A]"_eobj.DeptName)
			//同步修改识别词项目数据
            d:eobj.RowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("会诊科室",eobj.DeptName,bobj.DeptName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
	        if ((eobj.RowId="")&&(eobj.DeptName'=""))||((eobj.RowId'="")&&(eobj.DeptAlias'=bobj.DeptAlias))
	        {
	            d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DiseaseDeptDict",id,eobj.DeptAlias)
	        }
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("科室分层字典","web.CDSS.CMKB.DeptLevel","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }        
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("科室分层字典","web.CDSS.CMKB.DeptLevel","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate:2023-01-11
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.CDSS.CMKB.DeptLevel).GetRefFlag("97")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    s flag=0,count=0
    
    if ($d(^CT.WDT.CDSS.AssConDeptI("DeptIndex",id)))
    {
	    s DeptID=0
	    for
	    {
	        s DeptID=$o(^CT.WDT.CDSS.AssConDeptI("DeptIndex",id,DeptID)) q:(DeptID="")||(count=3)
            s AssDR=$lg($g(^CT.WDT.CDSS.AssConDeptD(DeptID)),2)
            s AssName=""
            s:AssDR'="" AssName=$lg($g(^CT.WDT.CDSS.AssBaseD(AssDR)),3)
            s count=count+1
            s flag=1
            s myInfo=myInfo_"<评估量表关联科室:"_AssName_">"
	        
	    }
    }
    //if (count=3) s myInfo=myInfo_"..."

    //字典对照引用接口
    s DeptName=$LISTGET($G(^CT.WDT.CDSS.DiseaseDeptDictD(id)),3)
	s Mappinginfo=##class(web.CDSS.IMP.DictMappingInfo).GetRefFlag("科室",DeptName)
    s myInfo=myInfo_Mappinginfo
    
    //识别词项目引用接口
    s DeptName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(id)),3)
    s IWordsStr=##class(web.CDSS.CMKB.WordsCondition).GetRefFlag("会诊科室",DeptName)
    if IWordsStr'="" s myInfo=myInfo_IWordsStr

    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:赵文伟
/// CreatDate:2023-01-04
/// Description：根据ID删除科室分层表的内容
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Input：id-科室分层表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.CMKB.DeptLevel).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
	s result = "",flag=""
	s flag=$d(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",id)) //判断该菜单是否被引用
	if (flag>0)
	{
		s result = "{success:'false',info:'该数据下已有子节点,禁止删除！'}"   
	}
	else
	{
		s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%OpenId(id)    
        s bobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
        s bobj.RowId=id
        
        s bobj.DeptCode= obj.DeptName		//编码
		s bobj.DeptName= obj.DeptName		//名称
		s:obj.FatherCodeDR'="" bobj.FatherCodeDR= obj.FatherCodeDR.%Id()	//父级科室
		s bobj.FatherCodeDRName=""
		s:bobj.FatherCodeDR'="" bobj.FatherCodeDRName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(bobj.FatherCodeDR)),3)
		s bobj.DeptGrade= obj.DeptGrade		//科室分级
		s bobj.DeptClass= obj.DeptClass		//科室分类
		s bobj.UseFlag= obj.UseFlag			//状态（0编辑中，1已弃用，2已审核）
		s bobj.CreateUserID= obj.CreateUserID 	//操作人员
		s bobj.CreateDate= obj.CreateDate		//操作时间
		s bobj.Remarks= obj.Remarks         //备注
		s bobj.DeptAlias=obj.DeptAlias		//别名
        
		d obj.%Close()
        k obj
		
		Tstart
		s sc=##class(CT.WDT.CDSS.DiseaseDeptDict).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tcommit
			s result = "{success:'true',info:'删除成功！'}" 
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDeptDict","CT.WDT.CDSS.DiseaseDeptDict","科室分层字典",id,bobj.DeptName,"D",bobj)
            //删除别名通用表中数据 
            d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.DiseaseDeptDict",id)
            d bobj.%Close()
		}
		else 
		{
			Trollback
			s result ="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorText(sc)_"'}"
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("科室分层字典","web.CDSS.CMKB.DeptLevel","DeleteData",bobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator：赵文伟   
/// CreatDate: 2023-01-05
/// Description：查询数据  下拉框
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.CMKB.DeptLevel).GetJsonDataForCmb("1")
ClassMethod GetJsonDataForCmb(parentcatdr As %String = "") As %String
{
	s IDStr=""
	if (parentcatdr="") s parentcatdr=-100000000000000
	s myJsonStr=""

	//输出菜单JSON串
	s RowId=0
	s childStr=""
	w "["
	s count=0
	for {
		s RowId=$o(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",parentcatdr,RowId)) q:RowId=""
		
		s count=count+1
		s DeptName= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),3)		//名称
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),7)
		continue:(UseFlag=1)
		if count>1 w ","
		
		w "{""id"":"""_RowId_""",""text"":"""_DeptName_""""
		
		s childStr=..GetChildOrderedIDStr(RowId)
		if childStr'=""
		{
			w ",""state"":""open"""
			w ",""children"":"
			w ..GetJsonDataForCmb(RowId)	
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
/// CreatDate: 2023-01-31
/// Description：查询数据  下拉框【id,text均返回描述】
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.CMKB.DeptLevel).GetJsonDataForCmb1("1")
ClassMethod GetJsonDataForCmb1(parentcatdr As %String = "") As %String
{
	s IDStr=""
	if (parentcatdr="") s parentcatdr=-100000000000000
	s myJsonStr=""

	//输出菜单JSON串
	s RowId=0
	s childStr=""
	w "["
	s count=0
	for {
		s RowId=$o(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",parentcatdr,RowId)) q:RowId=""
		
		s count=count+1
		s DeptName= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),3)		//名称
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),7)
		continue:(UseFlag=1)
		if count>1 w ","
		
		w "{""id"":"""_DeptName_""",""text"":"""_DeptName_""""
		
		s childStr=..GetChildOrderedIDStr(RowId)
		if childStr'=""
		{
			w ",""state"":""open"""
			w ",""children"":"
			w ..GetJsonDataForCmb1(RowId)	
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
/// CreatDate:2023-01-05
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.CDSS.CMKB.DeptLevel).GetChildOrderedIDStr("")
ClassMethod GetChildOrderedIDStr(FatherDR As %String) As %String
{
	s IDStr=""
	if (FatherDR="") s FatherDR=-100000000000000
	s myJsonStr=""
	
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	for {
		s myRowID=$o(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",FatherDR,myRowID)) q:myRowID=""
		s childStr=..GetChildOrderedIDStr(myRowID)
		s:childStr'="" childStr=myRowID_"^"_childStr
		s:childStr="" childStr=myRowID
		s:IDStr="" IDStr=childStr
		s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// Creator：赵文伟
/// CreatDate: 2023-01-05
/// Description:状态修改
/// Input:id useflag(0编辑中,1已删除,2已审核)
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Other: w ##class(web.CDSS.CMKB.DeptLevel).UpdateUseFlag(1,"弃用")
ClassMethod UpdateUseFlag(RowId, Operation) As %String
{
	s result=""
	if (Operation="弃用")
	{
		s flag=$d(^CT.WDT.CDSS.DiseaseDeptDictI("ParentIndex",RowId)) //判断该数据是否被引用
		
		if (flag>0)
		{
			q "{success:'false',info:'该数据下已有子节点,禁止弃用！'}"  
		}	
	}
	s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
	
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.CreateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.CreateUserID=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
	s bobj.UseFlag=obj.UseFlag
	s bobj.CreateDate=obj.CreateDate
	s bobj.CreateUserID=obj.CreateUserID
	
	s obj.UseFlag=eobj.UseFlag
 	s obj.CreateDate=eobj.CreateDate
 	s obj.CreateUserID=eobj.CreateUserID
 	Ts
 	s sc=obj.%Save()
	d obj.%Close()
	If $$$ISOK(sc)
	{
		Tc
		s id = obj.%Id()
		s result = "{success:'true',id:'"_id_"'}" //返回RowId
		//同步删除对照数据 
		if (obj.UseFlag= 1)||(obj.UseFlag=0){  
			d ##class(web.CDSS.IMP.DictMappingInfo).DelMappings("科室",obj.DeptCode_"[A]"_obj.DeptName)
		}
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDeptDict","CT.WDT.CDSS.DiseaseDeptDict","科室分层字典",RowId,obj.DeptName_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/// Creator:赵文伟
/// CreatDate:2023-01-05
/// Description：导出数据
/// Other:w ##class(web.CDSS.CMKB.DeptLevel).ExportData()
ClassMethod ExportData(desc As %String) As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"科室分层字典数据.txt"		
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
	w "RowId	科室编码	科室名称	别名	父节点	科室分级	科室分类	状态	操作时间	操作人员	备注"
	s:desc'="" desc=$ZCONVERT(desc,"U") 
	//s parentdr=-100000000000000
	s RowId=0
	for{
		s RowId=$o(^CT.WDT.CDSS.DiseaseDeptDictD(RowId))
		q:RowId=""
		s DeptCode= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),2)		//编码
		s DeptName= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),3)		//名称
		continue:(desc'="")&&($ZCONVERT(DeptName,"U")'[desc)
		s FatherCodeDR= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),4)	//父级科室
		s FatherCodeDRName=""
		s:FatherCodeDR'="" FatherCodeDRName=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(FatherCodeDR)),3)
		s DeptGrade= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),5)		//科室分级
		s DeptGrade=$case(DeptGrade,1:"一级",2:"二级",3:"三级",:"")
		s DeptClass= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),6)		//科室分类
		
		s UseFlag= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),7)			//状态（0编辑中，1已弃用，2已审核）
	    s UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"编辑中") 
	    s CreateUserID= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),9) 	//操作人员
	    s CreateDate= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),8)		//操作时间
	    s Remarks= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),10)        //备注
	    s DeptAlias=$lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),11)		//别名
		
		
		w !,RowId_"	"_DeptCode_"	"_DeptName_"	"_DeptAlias_"	"_FatherCodeDRName_"	"_DeptGrade_"	"_DeptClass_"	"_UseFlag_"	"_CreateDate_"	"_CreateUserID_"	"_Remarks
	}
	
	c file
	q fileName
}

/// Creator: 赵文伟 
/// CreatDate: 2023-01-05
/// Description: 批量通过
/// Table: CT.WDT.CDSS.DiseaseDeptDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.DeptLevel).ChangeStatusPass("131,132")
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
/// CreatDate: 2023-01-05
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.DiseaseDeptDict
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.DeptLevel).ChangeStatusBack("131,132")
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

/// Creator：赵文伟 
/// CreatDate: 2023-01-05
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.DiseaseDeptDict
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.DeptLevel).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DiseaseDeptDictD(RowId))
		q:RowId=""
		s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),7)       
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
/// CreatDate:2023-01-05
/// Description:获得操作日志
/// Table: 
/// Input: RowId
/// Return:返回日志
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DeptLevel","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.DiseaseDeptDict",RowId,LogID),-1) q:LogID=""
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

/// Creator:赵文伟
/// CreatDate:2023-01-05
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.DiseaseDeptDict
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DeptLevel","GetAliasList","1")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		
		s DeptAlias=$LISTGET($G(^CT.WDT.CDSS.DiseaseDeptDictD(id)),11)
		s Len=$Length(DeptAlias,",")
		for i=1:1:Len{
			s Desc=$p(DeptAlias,",",i)
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

/// Creator：赵文伟
/// CreatDate: 2023-01-05
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.NursingDict
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.DeptLevel).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.DiseaseDeptDict) As %String
{
	
	 s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
    	
        s flag=..Validate(eobj.RowId,eobj.DeptCode,eobj.DeptName)  //重复校验
		q:flag=1 "{success:'false',errorinfo:'该记录已经存在'}"
		s flagAlias=..ValidateAlias(eobj.RowId,eobj.DeptName,eobj.DeptAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
        if (eobj.RowId="")  //如果RowId未赋值则增加
        {
            s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%New()
        }
        else         	//如果RowId已赋值则修改
        {
            s obj=##class(CT.WDT.CDSS.DiseaseDeptDict).%OpenId(eobj.RowId)
            s bobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
            s bobj.RowId=eobj.RowId

            s bobj.DeptCode= obj.DeptCode		//编码
			s bobj.DeptName= obj.DeptName		//名称
			s bobj.CreateUserID= obj.CreateUserID 	//操作人员
			s bobj.CreateDate= obj.CreateDate		//操作时间
			s bobj.DeptAlias=obj.DeptAlias		//别名
				
        }
        s obj.DeptCode= eobj.DeptCode		//编码
		s obj.DeptName= eobj.DeptName		//名称
		s obj.CreateUserID= eobj.CreateUserID 	//操作人员
		if (eobj.CreateDate="")	//操作时间
		{
			s eobj.CreateDate=$ZDATETIME($HOROLOG,3)
			s obj.CreateDate=eobj.CreateDate
		}
		else
		{
			s obj.CreateDate=eobj.CreateDate
		}
		s obj.DeptAlias=eobj.DeptAlias		//别名
           
        Ts
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                
            //保存日志
			d:eobj.RowId="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDeptDict","CT.WDT.CDSS.DiseaseDeptDict","科室分层字典",id,eobj.DeptName,"A",eobj)
			d:eobj.RowId'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DiseaseDeptDict","CT.WDT.CDSS.DiseaseDeptDict","科室分层字典",eobj.RowId,eobj.DeptName,"U",eobj,bobj)
           	//同步修改对照数据
			d:eobj.RowId'="" ##class(web.CDSS.IMP.DictMappingInfo).UpdateMappings("科室",bobj.DeptCode_"[A]"_bobj.DeptName,eobj.DeptCode_"[A]"_eobj.DeptName)
			//同步修改识别词项目数据
            d:eobj.RowId'="" ##class(web.CDSS.CMKB.WordsCondition).SynchroDictWord("会诊科室",eobj.DeptName,bobj.DeptName)
			//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
	        if ((eobj.RowId="")&&(eobj.DeptName'=""))||((eobj.RowId'="")&&(eobj.DeptAlias'=bobj.DeptAlias))
	        {
	            d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DiseaseDeptDict",id,eobj.DeptAlias)
	        }
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("科室分层字典","web.CDSS.CMKB.DeptLevel","SaveData",eobj)
       	    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }       
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("科室分层字典","web.CDSS.CMKB.DeptLevel","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:赵文伟
/// CreatDate: 2023-01-11
/// Description：别名数据转存到别名通用表中
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Other: w ##class(web.CDSS.CMKB.DeptLevel).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DiseaseDeptDictD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(RowId)),11)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DiseaseDeptDict",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator:赵文伟
/// CreatDate: 2023-01-11
/// Description：新版与旧版对照数据处理
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Other: w ##class(web.CDSS.CMKB.DeptLevel).ProcessContrastData("D:\ZWW\科室新旧数据对照.csv")
ClassMethod ProcessContrastData(path As %String) As %String
{
	s readcount=0
	s savecount=0
	s nosavecount=0
	
	TS

	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)

	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		
  		s OldCode=$p(str,",",1)			//旧编码
		s OldName=$p(str,",",2)			//旧名称
		s NewCode=$p(str,",",3)			//新编码
		s NewName=$p(str,",",4)			//新名称
		s NewAlias=$p(str,",",5)		//新别名
		
		
		//去除两端空白
		s OldCode=$Zstrip(OldCode,"<>W")
		s OldName=$Zstrip(OldName,"<>W")
		s NewCode=$zstrip(NewCode,"<>W")
		s NewName=$zstrip(NewName,"<>W")
		s NewAlias=$zstrip(NewAlias,"<>W")
		
		s readcount=readcount+1
		s RowId=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_$ZCONVERT(OldName,"U"),0))
		if (RowId'="")&&(NewName'=""){
			
			s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
			s eobj.RowId=RowId
			s eobj.DeptCode=NewCode
			s eobj.DeptName=NewName
			s eobj.DeptAlias=NewAlias	
			s eobj.CreateDate=$zdt($h,3)
	
			s result=..SaveData(eobj)
			if ((result'["false"))
			{
				s savecount=savecount+1
			}
			else
			{
				s nosavecount=nosavecount+1
			}
		}
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	TC
	q "{success:'true'}"
}

/// Creator:赵文伟
/// CreatDate: 2023-01-11
/// Description：新版新增数据导入及已有数据【修改父节点】处理
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Other: w ##class(web.CDSS.CMKB.DeptLevel).ImportNewData("D:\ZWW\科室分层数据.csv")
ClassMethod ImportNewData(path As %String) As %String
{
	s readcount=0
	s savecount=0		//新增保存成功数
	s nosavecount=0		//新增保存失败数
	s updatecount=0		//修改保存成功数
	s noupdatecount=0	//修改保存失败数
	s other=0
	
	TS
	if '##class(%File).Exists(path) 
	{
   		q "文件不存在"
    }
	s file=##class(%File).%New(path)

	d file.Open("RS")
	d file.ReadLine()
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		
		s Code=$p(str,",",1)			//编码
		s Name=$p(str,",",2)			//名称
		s Alias=$p(str,",",3)		//别名
		s Parent=$p(str,",",4)		//父节点
		
		//去除两端空白
		s Code=$Zstrip(Code,"<>W")
		s Name=$Zstrip(Name,"<>W")
		s Alias=$zstrip(Alias,"<>W")
		s Parent=$zstrip(Parent,"<>W")
		
		s readcount=readcount+1
		s FatherCodeDR=""
		s:Parent'="" FatherCodeDR=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_$ZCONVERT(Parent,"U"),0))
		s RowId=$o(^CT.WDT.CDSS.DiseaseDeptDictI("NameIndex"," "_$ZCONVERT(Name,"U"),0))
		if (RowId=""){		//新增
			s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
			s eobj.RowId=""
			s eobj.DeptCode=Code
			s eobj.DeptName=Name
			s:FatherCodeDR'="" eobj.FatherCodeDR=FatherCodeDR
			s eobj.DeptAlias=Alias	
			s eobj.UseFlag="0"
			s eobj.CreateUserID="dhcc"
			s eobj.CreateDate=$zdt($h,3)
			
			s result=..SaveData(eobj)
			if ((result'["false"))
			{
				s savecount=savecount+1
			}
			else
			{
				s nosavecount=nosavecount+1
			}
		}elseif (RowId'="")&&(Name'="")&&(FatherCodeDR'=""){		//修改【父节点】
			
			s eobj = ##class(web.CDSSEntity.CMKB.DiseaseDeptDict).%New()
			s eobj.RowId=RowId
			s eobj.DeptCode=Code
			s eobj.DeptName=Name
			s:FatherCodeDR'="" eobj.FatherCodeDR=FatherCodeDR
			s eobj.CreateDate=$zdt($h,3)
	
			s result=..SaveData(eobj)
			if ((result'["false"))
			{
				s updatecount=updatecount+1
			}
			else
			{
				s noupdatecount=noupdatecount+1
			}
		}else{
			s other=other+1
			}
	}
	w "readcount："_readcount,!
	w "savecount："_savecount,!
	w "nosavecount:"_nosavecount,!
	w "updatecount："_updatecount,!
	w "noupdatecount:"_noupdatecount,!
	w "other:"_other,!
	TC
	q "{success:'true'}"
}

/// Creator：赵文伟·
/// CreatDate: 2023-03-10
/// Description：查询 科室
/// Table：CT.WDT.CDSS.DiseaseDeptDict
/// Input：rowid, desc
/// Other: d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DeptLevel","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String, q As %String) As %Query(ROWSPEC = "DeptDR:%String,DeptName:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, q As %String) As %Status
{
	
 s repid=$I(^CacheTemp)
 s ind=1
 if (rowid'="") //根据rowid返回该条记录
 {
  s DeptDR=rowid
  s DeptName=$LISTGET($G(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
  d OutputRowCmb
 }
 else
 {
	
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s:q'="" q=$ZCONVERT(q,"U") //转换成大写
  s DeptDR=""
  for{  
	s DeptDR=$o(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR),-1) q:DeptDR=""  
	s DeptName=$LISTGET($G(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),3)
	s UseFlag = $lg($g(^CT.WDT.CDSS.DiseaseDeptDictD(DeptDR)),7)
	s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(DeptName)
	if (($ZCONVERT(DeptName,"U")[desc)||(PINYIN[desc))&($ZCONVERT(DeptName,"U")[q)||($ZCONVERT(DeptName,"U")[q)&(UseFlag=2)
	{
		d OutputRowCmb
	}
	continue:(desc'=""||(q'=""))
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(DeptDR,DeptName)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
