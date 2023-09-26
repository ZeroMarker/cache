/// 描述:药物剂型分类表 
/// 描述:包含增删改查
/// 编写者:基础平台组 - Xuwenhu
/// 编写日期:2021-08-27
Class web.CDSS.CMKB.DosageForm Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:Xuwenhu
/// CreatDate:2021-08-27
/// Description：查询页面数据 
/// Table：CT.WDT.CDSS.DosageForm
/// Input：父节点
/// Return：treegrid格式数据串
/// Other:w ##class(web.CDSS.CMKB.DosageForm).GetJsonList("")
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
		s ID=$o(^CT.WDT.CDSS.DosageFormI("ParCatIdx",parentcatdr,ID)) 
		q:ID=""
		s count=count+1
		s DosageFormCode= $lg($g(^CT.WDT.CDSS.DosageFormD(ID)),2)		//剂型编码
		s DosageFormDesc= $lg($g(^CT.WDT.CDSS.DosageFormD(ID)),3)		//剂型名称
		
		s ParentDR= $lg($g(^CT.WDT.CDSS.DosageFormD(ID)),4)				//父节点DR
		s ParentDesc=""
		s:ParentDR'="" ParentDesc=$lg($g(^CT.WDT.CDSS.DosageFormD(ParentDR)),3)
		s UseFlag=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),5)				//状态（0编辑中，1已删除，2已审核）
		s:UseFlag'="" UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核",:"编辑中")
		s UpdateUser=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),6)			//编辑人员
		s UpdateDate=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),7)			//编辑时间
		s Remarks=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),8)				//备注
		s DosageAlias= $lg($g(^CT.WDT.CDSS.DosageFormD(ID)),9)		//剂型名称
		s Remarks=$replace(Remarks,"""","''")
		if count>1 s myJsonStr=myJsonStr_","
		s myJsonStr=myJsonStr_"{""id"":"""_ID_""""
		s myJsonStr=myJsonStr_",""ID"":"""_ID_""",""DosageFormCode"":"""_DosageFormCode_""",""DosageFormDesc"":"""_DosageFormDesc_""",""ParentDR"":"""_ParentDR_""",""ParentDesc"":"""_ParentDesc_""",""UseFlag"":"""_UseFlag_""",""UpdateUser"":"""_UpdateUser_""",""UpdateDate"":"""_UpdateDate_""",""Remarks"":"""_Remarks_""",""DosageAlias"":"""_DosageAlias_""""
		s myChildFlag=$d(^CT.WDT.CDSS.DosageFormI("ParCatIdx",ID))
        if (myChildFlag) //有子菜单不是叶子节点
        {
	        //一次性加载   
			s myJsonStr=myJsonStr_",""state"":""open"""   //closed节点不展开,open节点展开
			s myJsonStr=myJsonStr_",""children"":"
			s myJsonStr=myJsonStr_..GetJsonList(ID)
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

/// Creator:Xuwenhu
/// CreatDate:2021-08-27
/// Description：修改时打开的数据
/// Table：CT.WDT.CDSS.DosageForm
/// Input：id-药物剂型分类的rowid
/// Return:Json格式的字符串{}
/// Other: w ##class(web.CDSS.CMKB.DosageForm).OpenDataJSON("9")
ClassMethod OpenDataJSON(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.CDSSEntity.CMKB.DosageForm).%New()
    s eobj.ID=id
   	s eobj.DosageFormCode= $lg($g(^CT.WDT.CDSS.DosageFormD(id)),2)		//剂型编码
	s eobj.DosageFormDesc= $lg($g(^CT.WDT.CDSS.DosageFormD(id)),3)		//剂型描述
	s eobj.ParentDR=$lg($g(^CT.WDT.CDSS.DosageFormD(id)),4)				//父节点DR
	s:eobj.ParentDR'="" eobj.ParentDRName=$lg($g(^CT.WDT.CDSS.DosageFormD(eobj.ParentDR)),3)
	s eobj.UseFlag=$lg($g(^CT.WDT.CDSS.DosageFormD(id)),5)				//状态（0编辑中，1已删除，2已审核）
	s eobj.UpdateUser=$lg($g(^CT.WDT.CDSS.DosageFormD(id)),6)			//编辑人员	
	//s eobj.UpdateDate=$lg($g(^CT.WDT.CDSS.DosageFormD(id)),7)		//编辑时间
	s eobj.Remarks=$lg($g(^CT.WDT.CDSS.DosageFormD(id)),8)				//备注
	s eobj.DosageAlias=$lg($g(^CT.WDT.CDSS.DosageFormD(id)),9)				//别名
    s str= eobj.JsonS()    
    d eobj.%Close()
    //s str = "{list:["_str_"]}"
    q str
}

/// Creator：Xuwenhu
/// CreatDate:2021-08-27
/// Description：数据重复验证方法，由js调用
/// Table：CT.WDT.CDSS.DosageForm
/// Input：id-药物剂型分类表的rowid, code-药物剂型分类表的代码
/// Return："1"(数据重复),"0"(数据不重复)
/// other:w ##class(web.CDSS.CMKB.DosageForm).FormValidate("","")
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s flag="",flagc=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.DosageFormI("CodeIndex",code))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:code'="" idc=$o(^CT.WDT.CDSS.DosageFormI("CodeIndex",code,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:赵文伟
/// CreateDate:2023-03-09   
/// Description:校验别名【新增别名与表中所有名称及别名重复校验】
/// w ##class(web.CDSS.CMKB.DosageForm).ValidateAlias("","")
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
	    s flagA=$d(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.DosageForm",Alias))
	    s flagN=$d(^CT.WDT.CDSS.DosageFormI("DescIndex",Alias))
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
	        s idA=$o(^CT.WDT.CDSS.AliasI("UPAliasIndex","CT.WDT.CDSS.DosageForm",Alias,0))	//用别名表中别名数据校验别名重复
	        s idN=$o(^CT.WDT.CDSS.DosageFormI("DescIndex",Alias,0))  						//字典表的名称来校验别名重复
	        if ((idA'="")&(idA'=id)&(flagA>0))||((flagN'="")&(idN'=id)&(flagN>0))
	        {
		         s flag=1  //返回重复标志
		         q
	        }
	    }
	}
	q flag
}

/// Creator:Xuwenhu
/// CreatDate:2021-08-27
/// Description：保存药物剂型分类表的内容
/// Table：CT.WDT.CDSS.DosageForm
/// Input：web.CDSSEntity.CMKB.WordsItem实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.DosageForm).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.DosageForm) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
    	
        s flag=..FormValidate(eobj.ID,eobj.DosageFormCode)  //调用重复验证
		if (flag=1)
		{
			q result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		s flagAlias=..ValidateAlias(eobj.ID,eobj.DosageFormDesc,eobj.DosageAlias)		//调用别名重复验证
		if (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.DosageForm).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.DosageForm).%OpenId(eobj.ID)
                
                s bobj = ##class(web.CDSSEntity.CMKB.DosageForm).%New()
                s bobj.ID=eobj.ID
				s bobj.DosageFormCode=obj.DosageFormCode     		//剂型编码
				s bobj.DosageFormDesc =obj.DosageFormDesc 			//剂型描述
				s:obj.ParentDR'="" bobj.ParentDR = obj.ParentDR.%Id() 	//父节点
				s bobj.UseFlag=obj.UseFlag							//状态（0编辑中，1已删除，2已审核）
				s bobj.UpdateUser=obj.UpdateUser					//编辑用户
				s bobj.UpdateDate=obj.UpdateDate					//编辑时间
				s bobj.Remarks=obj.Remarks							//备注
				s bobj.DosageAlias=obj.DosageAlias
               
            }
            Ts	
            s obj.DosageFormCode=eobj.DosageFormCode				//剂型编码
            s obj.DosageFormDesc=eobj.DosageFormDesc				//剂型描述
            d obj.ParentDRSetObjectId(eobj.ParentDR)				//父节点
            s:eobj.UseFlag="" eobj.UseFlag=0						//状态（0编辑中，1已删除，2已审核）
            s obj.UseFlag=eobj.UseFlag
            s obj.UpdateUser=eobj.UpdateUser						//编辑用户
            s eobj.UpdateDate=$ZDateTime($H,3)						//编辑时间
            s obj.UpdateDate=eobj.UpdateDate
            s obj.Remarks=eobj.Remarks								//备注
            s obj.DosageAlias=eobj.DosageAlias
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("DosageForm","CT.WDT.CDSS.DosageForm","药物剂型字典",id,eobj.DosageFormDesc,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("DosageForm","CT.WDT.CDSS.DosageForm","药物剂型字典",eobj.ID,eobj.DosageFormDesc,"U",eobj,bobj)
            	
            	//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            	if ((eobj.ID="")&&(eobj.DosageAlias'=""))||((eobj.ID'="")&&(eobj.DosageAlias'=bobj.DosageAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DosageForm",id,eobj.DosageAlias)
            	}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("药物剂型字典","web.CDSS.CMKB.DosageForm","SaveData",eobj)
       	    	s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
                       
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("药物剂型字典","web.CDSS.CMKB.DosageForm","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:Xuwenhu
/// CreatDate:2021-08-27
/// Description：根据ID删除药物剂型分类表的内容
/// Table：CT.WDT.CDSS.DosageForm
/// Input：id-药物剂型分类表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.CMKB.DosageForm).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
	s result = "",flag=""
	s flag=$d(^CT.WDT.CDSS.DosageFormI("ParCatIdx",id)) //判断该菜单是否被引用
	if (flag>0)
	{
		s result = "{success:'false',info:'该数据下已有子节点,禁止删除！'}"   
	}
	else
	{
		s obj=##class(CT.WDT.CDSS.DosageForm).%OpenId(id)    
        s bobj = ##class(web.CDSSEntity.CMKB.DosageForm).%New()
        s bobj.ID=id
		s bobj.DosageFormCode=obj.DosageFormCode				//功能代码
        s bobj.DosageFormDesc=obj.DosageFormDesc				//功能描述
        s:obj.ParentDR'="" bobj.ParentDR = obj.ParentDR.%Id() 	//父节点
        s bobj.UseFlag=obj.UseFlag								//状态（0编辑中，1已删除，2已审核）
        s bobj.UpdateUser=obj.UpdateUser						//编辑用户
        s bobj.UpdateDate=bobj.UpdateDate						//编辑时间
        s bobj.Remarks=obj.Remarks								//备注
		s bobj.DosageAlias=obj.DosageAlias	
		d obj.%Close()
        k obj
		
		Tstart
		s sc=##class(CT.WDT.CDSS.DosageForm).%DeleteId(id)
		if $$$ISOK(sc)
		{
			Tcommit
			s result = "{success:'true',info:'删除成功！'}" 
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DosageForm","CT.WDT.CDSS.DosageForm","药物剂型字典",id,bobj.DosageFormDesc,"D",bobj)
            //同步删除别名通用表中数据 
			d ##class(web.CDSS.CMKB.Alias).DeleteAlias("CT.WDT.CDSS.DosageForm",id)
            d bobj.%Close()
		}
		else 
		{
			Trollback
			s result ="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorText(sc)_"'}"
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("药物剂型字典","web.CDSS.CMKB.DosageForm","DeleteData",bobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
		}
	}
	q result
}

/// Creator：Xuwenhu   
/// CreatDate: 2021-08-27
/// Description：查询数据  下拉框
/// Table：CT.WDT.CDSS.DosageForm
/// Input：父节点 
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.CMKB.DosageForm).GetJsonDataForCmb("")
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
		s myRowID=$o(^CT.WDT.CDSS.DosageFormI("ParCatIdx",parentcatdr,myRowID)) q:myRowID=""
		
		s count=count+1
		s DosageFormCode=$LISTGET($G(^CT.WDT.CDSS.DosageFormD(myRowID)),2)   //代码
		s DosageFormDesc=$LISTGET($G(^CT.WDT.CDSS.DosageFormD(myRowID)),3)   //描述
		s UseFlag=$LISTGET($G(^CT.WDT.CDSS.DosageFormD(myRowID)),8) 
		if (UseFlag=1)
		{
			continue
		}
		if count>1 w ","
		
		w "{""id"":"""_myRowID_""",""text"":"""_DosageFormDesc_""""
		
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

/// Creator：Xuwenhu
/// CreatDate:2021-08-27
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：CT.WDT.CDSS.DosageForm
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.CDSS.CMKB.DosageForm).GetChildOrderedIDStr("")
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
		s myRowID=$o(^CT.WDT.CDSS.DosageFormI("ParCatIdx",LastLevel,myRowID)) q:myRowID=""
		s childStr=..GetChildOrderedIDStr(myRowID)
		s:childStr'="" childStr=myRowID_"^"_childStr
		s:childStr="" childStr=myRowID
		s:IDStr="" IDStr=childStr
		s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// Creator:Xuwenhu
/// CreatDate:2021-08-30
/// Description:代码自动生成  
/// Input：
/// Return： code
/// Other:w ##class(web.CDSS.CMKB.DosageForm).GetCode()
ClassMethod GetCode() As %String
{
  	s Code=""
  	s DeptID=0
	s Code=$o(^CT.WDT.CDSS.DosageFormD(""),-1)
	if (Code="")
	{
		s:Code="" Code="1"
	}
	else
	{
		s Code=Code+1
	}
	q Code
}

/// Creator：Xuwenhu
/// CreatDate: 2021-11-30
/// Description:状态修改
/// Input:id useflag(0编辑中,1已删除,2已审核)
/// Table：CT.WDT.CDSS.DosageForm
/// Other: w ##class(web.CDSS.CMKB.DosageForm).UpdateUseFlag(1,1)
ClassMethod UpdateUseFlag(RowId, Operation) As %String
{
	s result=""
	if (Operation="弃用")
	{
		s flag=$d(^CT.WDT.CDSS.DosageFormI("ParCatIdx",RowId)) //判断该菜单是否被引用
		if (flag>0)
		{
			q "{success:'false',info:'该数据下已有子节点,禁止弃用！'}"  
		}	
	}
	
	s eobj = ##class(web.CDSSEntity.CMKB.DosageForm).%New()
	s:Operation="通过" eobj.UseFlag="2"	//已审核
	s:Operation="弃用" eobj.UseFlag="1"	//已弃用
	s:Operation="恢复" eobj.UseFlag="0"	//编辑中
	s:Operation="驳回" eobj.UseFlag="0"	//编辑中
	s eobj.UpdateDate=$zdt($h,3)
	if ($d(%session)) {s eobj.UpdateUser=$g(%session.Data("LOGON.USERNAME"))}
	
	s obj=##class(CT.WDT.CDSS.DosageForm).%OpenId(RowId)
	s bobj = ##class(web.CDSSEntity.CMKB.DosageForm).%New()
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
		
		d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.DosageForm","CT.WDT.CDSS.DosageForm","药物剂型字典",RowId,obj.DosageFormDesc_"&&"_Operation,"U",eobj,bobj)	
	}
	else
	{
		Trollback
		s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
		
	}
	q result
}

/*
/// Creator:Xuwenhu
/// CreatDate:2021-08-30
/// Description：导出数据
/// Other:w ##class(web.CDSS.CMKB.DosageForm).ExportData("","","","","","")
ClassMethod ExportData(desc As %String, user As %String, state As %String, starttime As %String, endtime As %String, remarks As %String) As %String
{
	s Path=##class(%File).GetDirectory()
	s Disk=$p(Path,":",1) //截取盘符
	s fileName="药物剂型字典数据.txt"
	s file=Disk_":\DtHealth\app\dthis\web\scripts\bdp\CDSS\DataExport\"_fileName
	o file:"NWS"
	u file
	w "剂型编码	剂型名称	父节点	操作人员	操作时间	备注	状态"
	
	//s parentdr=-100000000000000
	s ID=0
	for{
		s ID=$o(^CT.WDT.CDSS.DosageFormD(ID))
		q:ID=""
		//s ID=$o(^CT.WDT.CDSS.DosageFormI("ParCatIdx",parentdr,ID)) q:(ID="")
		
		s DosageFormCode= $lg($g(^CT.WDT.CDSS.DosageFormD(ID)),2)		//剂型编码
		s DosageFormDesc= $lg($g(^CT.WDT.CDSS.DosageFormD(ID)),3)		//剂型名称
		continue:((desc'="")&&(DosageFormDesc'[desc))
		s ParentDR= $lg($g(^CT.WDT.CDSS.DosageFormD(ID)),4)				//父节点DR
		s ParentDesc=""
		s:ParentDR'="" ParentDesc=$lg($g(^CT.WDT.CDSS.DosageFormD(ParentDR)),3)
		s UseFlag=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),5)				//状态（0编辑中，1已删除，2已审核）
		s:UseFlag="" UseFlag=0
		if (state=""){
			continue:(UseFlag="1")			
		}
		else{
			continue:((state'="")&&(UseFlag'=state))
		}
		s:UseFlag'="" UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核")
		s UpdateUser=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),6)			//编辑人员
		continue:(user'="")&&($ZCONVERT(UpdateUser,"U")'[user)	
		s UpdateDate=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),7)			//编辑时间
		continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
        continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
		s Remarks=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),8)				//备注
		continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
		s Remarks=$replace(Remarks,"""","''")
		
		w !,DosageFormCode_"	"_DosageFormDesc_"	"_ParentDesc_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks_"	"_UseFlag
	}
	
	c file
	q fileName
}
*/
/// Creator:Xuwenhu
/// CreatDate:2021-08-30
/// Description：导出数据
/// Other:w ##class(web.CDSS.CMKB.DosageForm).ExportDosageFormData()
ClassMethod ExportDosageFormData() As %String
{
	s time=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(+$h)
	
	Set Path = ##class(ext.util.String).GetPhysicalPath("")
	s fileName=time_"药物剂型字典数据.txt"		
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
	w "剂型编码	剂型名称	别名	父节点	操作人员	操作时间	备注	状态"
	
	//s parentdr=-100000000000000
	s ID=0
	for{
		s ID=$o(^CT.WDT.CDSS.DosageFormD(ID))
		q:ID=""
		//s ID=$o(^CT.WDT.CDSS.DosageFormI("ParCatIdx",parentdr,ID)) q:(ID="")
		
		s DosageFormCode= $lg($g(^CT.WDT.CDSS.DosageFormD(ID)),2)		//剂型编码
		s DosageFormDesc= $lg($g(^CT.WDT.CDSS.DosageFormD(ID)),3)		//剂型名称
		//continue:((desc'="")&&(DosageFormDesc'[desc))
		s ParentDR= $lg($g(^CT.WDT.CDSS.DosageFormD(ID)),4)				//父节点DR
		s ParentDesc=""
		s:ParentDR'="" ParentDesc=$lg($g(^CT.WDT.CDSS.DosageFormD(ParentDR)),3)
		s UseFlag=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),5)				//状态（0编辑中，1已删除，2已审核）
		s:UseFlag="" UseFlag=0
		
		s:UseFlag'="" UseFlag=$case(UseFlag,0:"编辑中",1:"已弃用",2:"已审核")
		s UpdateUser=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),6)			//编辑人员
		//continue:(user'="")&&($ZCONVERT(UpdateUser,"U")'[user)	
		s UpdateDate=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),7)			//编辑时间
		//continue:((starttime'="")&&($ZDH(starttime,3)>$ZDH(UpdateDate,3)))
        //continue:((endtime'="")&&($ZDH(endtime,3)<$ZDH(UpdateDate,3)))
		s Remarks=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),8)				//备注
		//continue:((remarks'="")&&($ZCONVERT(Remarks,"U")'[remarks))
		s Remarks=$replace(Remarks,"""","''")
		s DosageAlias=$lg($g(^CT.WDT.CDSS.DosageFormD(ID)),9)				//别名
		
		w !,DosageFormCode_"	"_DosageFormDesc_"	"_DosageAlias_"	"_ParentDesc_"	"_UpdateUser_"	"_UpdateDate_"	"_Remarks_"	"_UseFlag
	}
	
	c file
	q fileName
}

/// Creator: Xuwenhu
/// CreatDate: 2021-08-30
/// Description：导入数据
/// Table: CT.WDT.CDSS.DosageForm
/// Input：path(路径)
/// Return：
/// Other: w ##class(web.CDSS.CMKB.DosageForm).ImportData("D:\Works\药物剂型分类表.csv")
ClassMethod ImportData(path)
{
	s readcount=0   	//读取总数
	s savecount=0		//导入成功总数
	s nosavecount=0 	//导入失败总数
	s incount=0			//已存在总数
	s num=0
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		for i=1:1:$l(str,",")
		{
			s Desc=$p(str,",",i)				//描述
			s ParentDR=""
			s ParentDesc=$p(str,",",i-1)		//父节点描述
			s:ParentDesc'="" ParentDR=$o(^CT.WDT.CDSS.DosageFormI("DescIndex"," "_ParentDesc,""),-1)
			s Desc=$zstrip(Desc,"<>W")			//去除两端空白
			s readcount=readcount+1
			
			s RowID=$o(^CT.WDT.CDSS.DosageFormI("DescIndex"," "_Desc,0))
			if RowID=""
			{
				TS											//代码
				s obj = ##class(CT.WDT.CDSS.DosageForm).%New()
				s obj.DosageFormCode=$o(^CT.WDT.CDSS.DosageFormD(""),-1)+1										//功能代码
	        	s obj.DosageFormDesc=Desc										//功能名称
	        	d obj.ParentDRSetObjectId(ParentDR)
	        	s obj.UseFlag="2"												//状态
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
				s ParentDR1=$lg($g(^CT.WDT.CDSS.DosageFormD(RowID)),4)
				continue:(ParentDR1="")
				if ParentDesc'=$lg($g(^CT.WDT.CDSS.DosageFormD(ParentDR1)),3)
				{
					TS											//代码
					s obj = ##class(CT.WDT.CDSS.DosageForm).%New()
					s obj.DosageFormCode=$o(^CT.WDT.CDSS.DosageFormD(""),-1)+1										//功能代码
		        	s obj.DosageFormDesc=Desc										//功能名称
		        	d obj.ParentDRSetObjectId(ParentDR)
		        	s obj.UseFlag="2"												//状态
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
	}
	q "{success:'true',readcount:'"_readcount_"',savecount:'"_savecount_"',nosavecount:'"_nosavecount_"',incount:'"_incount_"'}"
}

/// Creator: 赵文伟 
/// CreatDate: 2021-10-21
/// Description: 批量通过
/// Table: CT.WDT.CDSS.DosageForm
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.DosageForm).ChangeStatusPass("131,132")
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
/// CreatDate: 2021-10-21
/// Description: 批量驳回
/// Table: CT.WDT.CDSS.DosageForm
/// Input: RowIdStr id串
/// Return: true/false
/// Other: w ##class(web.CDSS.CMKB.DosageForm).ChangeStatusBack("131,132")
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

/// Creator:赵文伟
/// CreatDate:2022-01-21
/// Description:获得别名列表
/// Table: CT.WDT.CDSS.DosageForm
/// Input: id
/// Return:返回别名列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DosageForm","GetAliasList","2")
Query GetAliasList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetAliasListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s DosageAlias = $lg($g(^CT.WDT.CDSS.DosageFormD(id)),9)
		s Len=$Length(DosageAlias,",")
		for i=1:1:Len{
			s Desc=$p(DosageAlias,",",i)
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
/// CreatDate: 2022-01-21
/// Description：别名数据转存到别名通用表中
/// Table: CT.WDT.CDSS.DosageForm
/// Other: w ##class(web.CDSS.CMKB.DosageForm).TransferAliasData() 
ClassMethod TransferAliasData() As %String
{
	s RowId=0
	s count=0
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DosageFormD(RowId))
		q:RowId=""
		s Alias= $lg($g(^CT.WDT.CDSS.DosageFormD(RowId)),9)        
		if Alias'=""
		{
			//s Alias=$replace(Alias,"，",",")
			d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DosageForm",RowId,Alias)
			s count=count+1
		}	 	
	}
	q "success!savecount:"_count
}

/// Creator：赵文伟 
/// CreatDate: 2022-01-24
/// Description：数据统计方法
/// Table: CT.WDT.CDSS.DosageForm
/// Output: 总数据量^编辑中的数据量^已审核的数据量(审核通过+已上线)^待审核的数据量
/// Other: w ##class(web.CDSS.CMKB.DosageForm).CountData() 
ClassMethod CountData() As %String
{
	s RowId=0
	s totalcount=0		//总数据量
	s editcount=0		//编辑中的数据量
	s auditcount=0		//已审核的数据量
	s unauditcount=0	//待审核的数据量
	for
	{
		s RowId=$o(^CT.WDT.CDSS.DosageFormD(RowId))
		q:RowId=""
		//s totalcount=totalcount+1
		s UseFlag = $lg($g(^CT.WDT.CDSS.DosageFormD(RowId)),5)       
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
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.DosageForm","GetLogList","20")
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
	    	s LogID=$o(^CF.WDT.CDSS.DataChangeLogI("ObjectReferIndex","CT.WDT.CDSS.DosageForm",RowId,LogID),-1) q:LogID=""
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
/// CreatDate: 2023-01-17
/// Description：修正数据保存方法
/// Table：CT.WDT.CDSS.DosageForm
/// Input：eobj
/// Return:成功返回true，失败返回false
/// Other: d ##class(web.CDSS.CMKB.DosageForm).SaveAmendData()
ClassMethod SaveAmendData(eobj As web.CDSSEntity.CMKB.DosageForm) As %String
{
	s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
    	
        s flag=..FormValidate(eobj.ID,eobj.DosageFormCode)  //调用重复验证
        s flagAlias=..ValidateAlias(eobj.ID,eobj.DosageFormDesc,eobj.DosageAlias)		//调用别名重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该记录已经存在！'}"
		}
		elseif (flagAlias=1)
		{
			q "{success:'false',errorinfo:'新增别名与已有名称或别名重复！'}"
		}
		else
		{
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.DosageForm).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.DosageForm).%OpenId(eobj.ID)
                
                s bobj = ##class(web.CDSSEntity.CMKB.DosageForm).%New()
                s bobj.ID=eobj.ID
				s bobj.DosageFormCode=obj.DosageFormCode     		//剂型编码
				s bobj.DosageFormDesc =obj.DosageFormDesc 			//剂型描述
				s bobj.UpdateUser=obj.UpdateUser					//编辑用户
				s bobj.Remarks=obj.Remarks							//备注
				s bobj.DosageAlias=obj.DosageAlias
               
            }
            Ts	
            s obj.DosageFormCode=eobj.DosageFormCode				//剂型编码
            s obj.DosageFormDesc=eobj.DosageFormDesc				//剂型描述
			s eobj.UpdateUser = $g(%session.Data("LOGON.USERNAME")) 
            s obj.UpdateUser=eobj.UpdateUser						//编辑用户
            s eobj.UpdateDate=$ZDateTime($H,3)						//编辑时间
            s obj.UpdateDate=eobj.UpdateDate
            s obj.DosageAlias=eobj.DosageAlias
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("DosageForm","CT.WDT.CDSS.DosageForm","药物剂型字典",id,eobj.DosageFormDesc,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("DosageForm","CT.WDT.CDSS.DosageForm","药物剂型字典",eobj.ID,eobj.DosageFormDesc,"U",eobj,bobj)
            	
            	//如果是新增且别名不为空，或者修改且别名有了变动，则保存别名到别名通用表
            	if ((eobj.ID="")&&(eobj.DosageAlias'=""))||((eobj.ID'="")&&(eobj.DosageAlias'=bobj.DosageAlias))
            	{
            		d ##class(web.CDSS.CMKB.Alias).SaveAlias("CT.WDT.CDSS.DosageForm",id,eobj.DosageAlias)
            	}
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("药物剂型字典","web.CDSS.CMKB.DosageForm","SaveData",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("药物剂型字典","web.CDSS.CMKB.DosageForm","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

}
