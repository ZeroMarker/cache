/// 名称:识别词项目字典表V2.0
/// 描述:包含增删改查
/// 编写者:基础平台组 - xuwenhu
/// 编写日期:2021-01-12
Class web.CDSS.CMKB.WordsItem Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：徐文虎 		
/// CreatDate: 2021-01-12
/// Description：查询数据 
/// Table:CT.WDT.CDSS.WordsItem 识别词项目字典
/// Input:id-表ID,code-识别词项目代码, desc-识别词项目描述,
/// Output:ID,WordsItemCode,WordsItemDesc,ParentDR,ParentDesc,ItemType,TableName,FiledName,UseFlag,UpdateUser,UpdateDate,Remarks
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.WordsItem","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,WordsItemCode,WordsItemDesc,ParentDR,ParentDesc,ItemType,TableName,FiledName,UseFlag,UpdateUser,UpdateDate,Remarks,ItemCategory")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s WordsItemCode= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),2)		//识别词项目编码
		s WordsItemDesc= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),3)		//识别词项目名称
		s ParentDR= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),4)			//父节点DR
		s ParentDesc=""
		s:ParentDR'="" ParentDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(ParentDR)),3)
		s ItemType=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),5)			//项目类型（诊断/手术/检查/检验/护理/输血/症状/体征/等）
		s TableName=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),6)		//关联表名
		s FiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),7)		//关联字段名
		s UseFlag=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),8)			//使用标志(0在用，1停用)
		s UpdateUser=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),9)		//编辑人员	
		s UpdateDate=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),10)		//编辑时间
		s Remarks=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),11)		//备注
		s ItemCategory=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),12)	//项目类别（中医、西医）
		d OutputRow
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.WordsItemD(ID))
			q:ID=""
			s WordsItemCode= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),2)		//识别词项目编码
			s WordsItemDesc= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),3)		//识别词项目名称
			s ParentDR= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),4)			//父节点DR
			s ParentDesc=""
			s:ParentDR'="" ParentDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(ParentDR)),3)
			s ItemType=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),5)			//项目类型（诊断/手术/检查/检验/护理/输血/症状/体征/等）
			s TableName=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),6)		//关联表名
			s FiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),7)		//关联字段名
			s UseFlag=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),8)			//使用标志(0在用，1停用)
			s UpdateUser=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),9)		//编辑人员	
			s UpdateDate=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),10)		//编辑时间
			s Remarks=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),11)		//备注
			s ItemCategory=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),12)	//项目类别（中医、西医）
			if (desc'="")           					//描述不为空
			{
				;需要对描述或者别名进行检索 
				s AliasFlag=0     
				s PINYINFlag=""
				s PINYINCODE=""   
		        s PINYINFlag=##class(web.DHCBL.BDP.BDPAlias).GetPINYINFlag(desc) 
		        if (PINYINFlag=1)		// 是拼音 才去转换拼音码
		        {
		          s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(WordsItemDesc) 
		        }
				if (($ZCONVERT(WordsItemDesc,"U")[desc)||(PINYINCODE[desc))  	//过滤描述
				{
					s AliasFlag= 1	
				} 
			}
			else
			{
				s AliasFlag= 1
			} 
			if ($ZCONVERT(WordsItemCode,"U")[code)&&(AliasFlag=1) //过滤代码
			{
				d OutputRow
			}
			
		}
						
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,WordsItemCode,WordsItemDesc,ParentDR,ParentDesc,ItemType,TableName,FiledName,UseFlag,UpdateUser,UpdateDate,Remarks,ItemCategory)
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

/// Creator:徐文虎
/// CreatDate:2021-01-12
/// Description：查询页面数据 
/// Table：CT.WDT.CDSS.WordsItem
/// Input：父节点
/// Return：treegrid格式数据串
/// Other:w ##class(web.CDSS.CMKB.WordsItem).GetJsonList("")
ClassMethod GetJsonList(id As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	s myJsonStr=""

	//输出菜单JSON串
	s myJsonStr=myJsonStr_"["
	s ID=0
	s count=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.WordsItemI("ParCatIdx",parentcatdr,ID)) 
		q:ID=""
		s count=count+1
		s WordsItemCode= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),2)		//识别词项目编码
		s WordsItemDesc= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),3)		//识别词项目名称
		s ParentDR= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),4)			//父节点DR
		s ParentDesc=""
		s:ParentDR'="" ParentDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(ParentDR)),3)
		s ItemType=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),5)			//项目类型（诊断/手术/检查/检验/护理/输血/症状/体征/等）
		s TableName=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),6)		//关联表名
		s FiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),7)		//关联字段名
		s FiledName=$replace(FiledName,"""","''")
		s UseFlag=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),8)			//使用标志(0在用，1停用)
		s UpdateUser=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),9)		//编辑人员	
		s UpdateDate=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),10)		//编辑时间
		s Remarks=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),11)		//备注
		s ItemCategory=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),12)	//项目类别（中医、西医）
		s Remarks=$replace(Remarks,"""","''")
		if (UseFlag'="")
		{
			s:UseFlag=1 UseFlag="停用"
			s:UseFlag=0 UseFlag="在用"
		}
		//s:UpdateDate'="" UpdateDate=$zd(UpdateDate,3) //转换日期格式
		if count>1 s myJsonStr=myJsonStr_","	
		s myJsonStr=myJsonStr_"{""id"":"""_ID_""""
		s myJsonStr=myJsonStr_",""ID"":"""_ID_""",""WordsItemCode"":"""_WordsItemCode_""",""WordsItemDesc"":"""_WordsItemDesc_""",""ParentDR"":"""_ParentDR_""",""ParentDesc"":"""_ParentDesc_""",""ItemType"":"""_ItemType_""",""TableName"":"""_TableName_""",""FiledName"":"""_FiledName_""",""UseFlag"":"""_UseFlag_""",""UpdateUser"":"""_UpdateUser_""",""UpdateDate"":"""_UpdateDate_""",""Remarks"":"""_Remarks_""",""ItemCategory"":"""_ItemCategory_""""
		s myChildFlag=$d(^CT.WDT.CDSS.WordsItemI("ParCatIdx",ID))
        if (myChildFlag) //有子菜单不是叶子节点
        {
	        s myChildFlag=1     
        }
	    else  //叶子节点
	    {
		    s myChildFlag=0
	    }
		if (myChildFlag=1)
		{
			//一次性加载   
			s myJsonStr=myJsonStr_",""state"":""open"""   //closed节点不展开,open节点展开
			s myJsonStr=myJsonStr_",""children"":"
			s myJsonStr=myJsonStr_..GetJsonList(ID)
		}
		else
		{
			s myJsonStr=myJsonStr_",""state"":""open"""
		}
		s myJsonStr=myJsonStr_"}"
	}

	s myJsonStr=myJsonStr_"]"
	s myJsonStr=myJsonStr_""
	q myJsonStr
}

/// Creator:徐文虎
/// CreatDate:2021-01-12
/// Description：修改时打开的数据
/// Table：CT.WDT.CDSS.WordsItem
/// Input：id-识别词项目字典的rowid
/// Return:Json格式的字符串{}
/// Other: w ##class(web.CDSS.CMKB.WordsItem).OpenDataJSON("9")
ClassMethod OpenDataJSON(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.CDSSEntity.CMKB.WordsItem).%New()
    s eobj.ID=id
   
   	s eobj.WordsItemCode= $lg($g(^CT.WDT.CDSS.WordsItemD(id)),2)		//识别词项目编码
	s eobj.WordsItemDesc= $lg($g(^CT.WDT.CDSS.WordsItemD(id)),3)		//识别词项目名称
	s eobj.ParentDR=$lg($g(^CT.WDT.CDSS.WordsItemD(id)),4)			//父节点DR
	//s:ParentDR'="" ParentDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(ParentDR)),3)
	s eobj.ItemType=$lg($g(^CT.WDT.CDSS.WordsItemD(id)),5)			//项目类型（诊断/手术/检查/检验/护理/输血/症状/体征/等）
	s eobj.TableName=$lg($g(^CT.WDT.CDSS.WordsItemD(id)),6)		//关联表名
	s eobj.FiledName=$lg($g(^CT.WDT.CDSS.WordsItemD(id)),7)		//关联字段名
	s eobj.UseFlag=$lg($g(^CT.WDT.CDSS.WordsItemD(id)),8)			//使用标志(0在用，1停用)
	s eobj.UpdateUser=$lg($g(^CT.WDT.CDSS.WordsItemD(id)),9)		//编辑人员	
	//s eobj.UpdateDate=$lg($g(^CT.WDT.CDSS.WordsItemD(id)),10)		//编辑时间
	s eobj.Remarks=$lg($g(^CT.WDT.CDSS.WordsItemD(id)),11)		//备注
	s eobj.ItemCategory=$lg($g(^CT.WDT.CDSS.WordsItemD(id)),12)	//项目类别（中医、西医）
    s str= eobj.JsonS()    
    d eobj.%Close()
    //s str = "{list:["_str_"]}"
    q str
}

/// Creator：徐文虎
/// CreatDate:2021-01-12
/// Description：数据重复验证方法，由js调用
/// Table：CT.WDT.CDSS.WordsItem
/// Input：id-识别词项目字典的rowid, code-识别词项目字典的代码
/// Return："1"(数据重复),"0"(数据不重复)
/// other:w ##class(web.CDSS.CMKB.WordsItem).FormValidate("","")
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s flag="",flagc=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.WordsItemI("CodeIndex",code))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:code'="" idc=$o(^CT.WDT.CDSS.WordsItemI("CodeIndex",code,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:徐文虎
/// CreatDate:2021-01-12
/// Description：保存识别词项目字典表的内容
/// Table：CT.WDT.CDSS.WordsItem
/// Input：web.CDSSEntity.CMKB.WordsItem实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.WordsItem).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.WordsItem) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..FormValidate(eobj.ID,eobj.WordsItemCode)  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		else
		{
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.WordsItem).%New()
                //s UpdateDate=$ZDateTime($H,3)			//编辑时间
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.WordsItem).%OpenId(eobj.ID)
                //s UpdateDate=$ZDateTime($H,3)						//编辑时间
                
                s bobj = ##class(web.CDSSEntity.CMKB.WordsItem).%New()
                s bobj.ID=eobj.ID
				s bobj.WordsItemCode=obj.WordsItemCode     			//功能代码
				s bobj.WordsItemDesc =obj.WordsItemDesc 			//功能名称
				s:obj.ParentDR'="" bobj.ParentDR = obj.ParentDR.%Id() 	//父节点
				s bobj.ItemType=obj.ItemType 						//项目类型
				s bobj.TableName=obj.TableName 						//关联表名
				s bobj.FiledName=obj.FiledName 						//关联字段名
				s bobj.UseFlag=obj.UseFlag							//使用标志（0在用，1停用）
				s bobj.UpdateUser=obj.UpdateUser					//编辑用户
				s bobj.UpdateDate=obj.UpdateDate					//编辑时间
				s bobj.Remarks=obj.Remarks							//备注
				s bobj.ItemCategory=obj.ItemCategory				//项目类别（中医、西医）
               
            }
            Ts	
            s obj.WordsItemCode=eobj.WordsItemCode					//功能代码
            s obj.WordsItemDesc=eobj.WordsItemDesc					//功能名称
            d obj.ParentDRSetObjectId(eobj.ParentDR)				//父节点
            s obj.ItemType=eobj.ItemType							//项目类型
            s obj.TableName=eobj.TableName							//关联表名
            s obj.FiledName=eobj.FiledName							//关联字段名
            s:eobj.UseFlag="" eobj.UseFlag=0							//使用标志（0在用，1停用）
            s obj.UseFlag=eobj.UseFlag
            s obj.UpdateUser=eobj.UpdateUser						//编辑用户
            s obj.UpdateDate=$ZDateTime($H,3)						//编辑时间
            s obj.Remarks=eobj.Remarks								//备注
            s obj.ItemCategory=eobj.ItemCategory					//项目类别（中医、西医）
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsItem","CT.WDT.CDSS.WordsItem","识别词项目字典表",id,eobj.WordsItemDesc,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsItem","CT.WDT.CDSS.WordsItem","识别词项目字典表",eobj.ID,eobj.WordsItemDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词项目字典表","web.CDSS.CMKB.WordsItem","SaveData",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词项目字典表","web.CDSS.CMKB.WordsItem","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:徐文虎
/// CreatDate:2021-01-12
/// Description：根据ID删除识别词项目字典表的内容
/// Table：CT.WDT.CDSS.WordsItem
/// Input：id-识别词项目字典表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.CMKB.WordsItem).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
	s result = "",flag=""
	s flag=$d(^CT.WDT.CDSS.WordsItemI("ParCatIdx",id)) //判断该菜单是否被引用
	if (flag>0)
	{
		s result = "{success:'false',info:'该数据下已有子节点,禁止删除！'}"   
	}
	else
	{
		s obj=##class(CT.WDT.CDSS.WordsItem).%OpenId(id)    
        s bobj = ##class(web.CDSSEntity.CMKB.WordsItem).%New()
        s bobj.ID=id
		s bobj.WordsItemCode=obj.WordsItemCode					//功能代码
        s bobj.WordsItemDesc=obj.WordsItemDesc					//功能名称
        s:obj.ParentDR'="" bobj.ParentDR = obj.ParentDR.%Id() 	//父节点
        s bobj.ItemType=obj.ItemType							//项目类型
        s bobj.TableName=obj.TableName							//关联表名
        s bobj.FiledName=obj.FiledName							//关联字段名
        s bobj.UseFlag=obj.UseFlag								//使用标志（0在用，1停用）
        s bobj.UpdateUser=obj.UpdateUser						//编辑用户
        s bobj.UpdateDate=bobj.UpdateDate						//编辑时间
        s bobj.Remarks=obj.Remarks								//备注
        s bobj.ItemCategory=obj.ItemCategory					//项目类别（中医、西医）
		d obj.%Close()
        k obj
		
		Tstart
		s sc=##class(CT.WDT.CDSS.WordsItem).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tcommit
			s result = "{success:'true',info:'删除成功！'}" 
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.WordsItem","CT.WDT.CDSS.WordsItem","识别词项目字典表",id,bobj.ID,"D",bobj)
            d bobj.%Close()
		}
		else 
		{
			Trollback
			s result ="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorText(sc)_"'}"
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("识别词项目字典表","web.CDSS.CMKB.WordsItem","DeleteData",bobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator：徐文虎   
/// CreatDate: 2021-01-12
/// Description：查询数据  下拉框
/// Table：CT.WDT.CDSS.WordsItem
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.CMKB.WordsItem).GetJsonDataForCmb("")
ClassMethod GetJsonDataForCmb(parentcatdr As %String) As %String
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
		s myRowID=$o(^CT.WDT.CDSS.WordsItemI("ParCatIdx",parentcatdr,myRowID)) q:myRowID=""
		
		s count=count+1
		s WordsItemCode=$LISTGET($G(^CT.WDT.CDSS.WordsItemD(myRowID)),2)   //代码
		s WordsItemDesc=$LISTGET($G(^CT.WDT.CDSS.WordsItemD(myRowID)),3)   //描述
		//s UseFlag=$LISTGET($G(^CT.WDT.CDSS.WordsItemD(myRowID)),8) 
		/*if (UseFlag=1)
		{
			continue
		}*/
		if count>1 w ","
		
		w "{""id"":"""_myRowID_""",""text"":"""_WordsItemDesc_""""
		
		s childStr=..GetChildOrderedIDStr(myRowID)
		if childStr'=""
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

/// Creator：徐文虎
/// CreatDate:2021-01-12
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：CT.WDT.CDSS.WordsItem
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.CDSS.CMKB.WordsItem).GetChildOrderedIDStr("")
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
		s myRowID=$o(^CT.WDT.CDSS.WordsItemI("ParCatIdx",LastLevel,myRowID)) q:myRowID=""
		s childStr=..GetChildOrderedIDStr(myRowID)
		s:childStr'="" childStr=myRowID_"^"_childStr
		s:childStr="" childStr=myRowID
		s:IDStr="" IDStr=childStr
		s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// Creator：徐文虎 		
/// CreatDate: 2021-01-19
/// Description：获取所有根节点
/// Table:CT.WDT.CDSS.WordsItem 识别词项目字典
/// Input:id-表ID,
/// Output:ID,WordsItemDesc
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.WordsItem","GetRootList","","中医")
Query GetRootList(rowid As %String, type As %String) As %Query(ROWSPEC = "ID,WordsItemDesc")
{
}

ClassMethod GetRootListExecute(ByRef qHandle As %Binary, rowid As %String, type As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	//s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	//s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	if (rowid'="") //根据rowid返回该条记录
	{
		s ID=rowid
		s WordsItemCode= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),2)		//识别词项目编码
		s WordsItemDesc= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),3)		//识别词项目名称
		s ParentDR= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),4)			//父节点DR
		s ParentDesc=""
		s:ParentDR'="" ParentDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(ParentDR)),3)
		d OutputRow
	}
	else
	{
		s ID=0
		for 
		{
			s ID=$o(^CT.WDT.CDSS.WordsItemD(ID))
			q:ID=""
			s WordsItemCode= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),2)		//识别词项目编码
			s WordsItemDesc= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),3)		//识别词项目名称
			s ParentDR= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),4)			//父节点DR
			s ParentDesc=""
			s:ParentDR'="" ParentDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(ParentDR)),3)
			continue:(ParentDR'="")
			s UseFlag=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),8)				//使用标志
			continue:(UseFlag=1)
			s ItemCategory=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),12)		//项目类别
			
			if (ItemCategory=type){
				d OutputRow
			}
			
		}
						
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,WordsItemDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetRootListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRootListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRootListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRootListExecute ]
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

/// Creator：徐文虎 		
/// CreatDate: 2021-01-19
/// Description：根据根节点id获取子节点
/// Table:CT.WDT.CDSS.WordsItem 识别词项目字典
/// Input:id-根节点ID,
/// Output:ID,WordsItemDesc
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.WordsItem","GetChildList","")
Query GetChildList(parentid As %String) As %Query(ROWSPEC = "ID,WordsItemDesc")
{
}

ClassMethod GetChildListExecute(ByRef qHandle As %Binary, parentid As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	q:parentid=""
	
	s ID=0
	for 
	{
		s ID=$o(^CT.WDT.CDSS.WordsItemI("ParCatIdx",parentid,ID)) 
		q:ID=""
		s WordsItemCode= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),2)		//识别词项目编码
		s WordsItemDesc= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),3)		//识别词项目名称
		s ParentDR= $lg($g(^CT.WDT.CDSS.WordsItemD(ID)),4)			//父节点DR
		s ParentDesc=""
		s:ParentDR'="" ParentDesc=$lg($g(^CT.WDT.CDSS.WordsItemD(ParentDR)),3)
		//continue:(ParentDR'="")
		s UseFlag=$lg($g(^CT.WDT.CDSS.WordsItemD(ID)),8)				//使用标志
		continue:(UseFlag=1)
		d OutputRow		
	}				
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,WordsItemDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetChildListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetChildListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetChildListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetChildListExecute ]
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

/// Creator:Xuwenhu
/// CreatDate:2022-02-10
/// Description:数据统计
/// Table:CT.WDT.CDSS.WordsItem
/// Input:
/// Return:总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Others:w ##class(web.CDSS.CMKB.WordsItem).CountData()
ClassMethod CountData() As %String
{
	s (EditNum,AuditNum,StayNum,AllNum)=0
	s SQL="SELECT UseFlag AS state,Count(*) AS num FROM CT_WDT_CDSS.WordsItem GROUP BY UseFlag"
	s tStatement=##class(%SQL.Statement).%New()
	s qStatus = tStatement.%Prepare(SQL)
	if qStatus '= 1 
	{
		w "%Prepare failed:"
		d $System.status.DisplayError(qStatus)
		q
	}
	s rset = tStatement.%Execute()
	while rset.%Next() 
	{
		if rset.state="0"
		{
			s AuditNum=AuditNum+rset.num		
		}
		s AllNum=AllNum+rset.num
	}
	q AllNum_"^"_EditNum_"^"_AuditNum_"^"_StayNum
}

/// Creator:赵文伟
/// CreatDate:2022-06-27
/// Description:更项目类别（中医、西医）数据
/// Table:CT.WDT.CDSS.WordsItem
/// Input:
/// Return:
/// Others:d ##class(web.CDSS.CMKB.WordsItem).UpdateCategoryData()
ClassMethod UpdateCategoryData() As %String
{
	s count=0
	s RowId=0
	for 
	{
		s RowId=$o(^CT.WDT.CDSS.WordsItemD(RowId)) q:RowId=""
		s obj=##class(CT.WDT.CDSS.WordsItem).%OpenId(RowId)
		s ItemType=obj.ItemType							//项目类型
		if ((ItemType["中医")||(ItemType["中药")){
			s ItemCategory="中医"
		} else{
			s ItemCategory="西医"
		}
        s obj.ItemCategory=ItemCategory					//项目类别（中医、西医）
        TS
        s sc=obj.%Save()
		d obj.%Close()
        k obj
        If $$$ISOK(sc)
        {
	       TC
	       s count=count+1
	    } else{
		    TRO
		}
	}
	w !,"数据保存完成："_count_"!"
}

}
