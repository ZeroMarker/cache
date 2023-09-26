/// 名称:评估表关联评估结果条件设置表
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - 徐文虎
/// 编写日期:2021-10-18
Class web.CDSS.Access.AssConResCondi Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：Xuwenhu		
/// CreatDate: 2021-10-18
/// Description：查询数据 
/// Table:CT.WDT.CDSS.AssConResCondi 
/// Input:assdr-评估表指针
/// Output:ID,AssDR,DataType,CalculateMethod,CondiContent,ShowContent,Remark
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.Access.AssConResCondi","GetList","","")
Query GetList(rowid As %String, assdr As %String) As %Query(ROWSPEC = "ID,AssDR,DataType,CalculateMethod,CondiContent,ShowContent,Remark")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, assdr As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryAssessel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ID=rowid
        s AssDR=$lg($g(^CT.WDT.CDSS.AssConResCondiD(ID)),2) 				//评估表指针
        s DataType=$lg($g(^CT.WDT.CDSS.AssConResCondiD(ID)),3) 			//类型（总分、结论、描述）
        s CalculateMethod=$lg($g(^CT.WDT.CDSS.AssConResCondiD(ID)),4) 	//计算方式（累加、平均值、最大值、最小值、公式、特殊）
        s CondiContent=$lg($g(^CT.WDT.CDSS.AssConResCondiD(ID)),5) 		//公式/特殊条件
        s ShowContent=$lg($g(^CT.WDT.CDSS.AssConResCondiD(ID)),6) 		//显示内容
        s Remark=$lg($g(^CT.WDT.CDSS.AssConResCondiD(ID)),7) 			//备注
        d OutputRow
    }
    else
    {
        s ID=0
        for {
            s ID=$o(^CT.WDT.CDSS.AssConResCondiI("AssIndex",assdr,ID))
			q:ID=""
	        s AssDR=$lg($g(^CT.WDT.CDSS.AssConResCondiD(ID)),2) 				//评估表指针
	        s DataType=$lg($g(^CT.WDT.CDSS.AssConResCondiD(ID)),3) 			//类型（总分、结论、描述）
	        s CalculateMethod=$lg($g(^CT.WDT.CDSS.AssConResCondiD(ID)),4) 	//计算方式（累加、平均值、最大值、最小值、公式、特殊）
	        s CondiContent=$lg($g(^CT.WDT.CDSS.AssConResCondiD(ID)),5) 		//公式/特殊条件
	        s ShowContent=$lg($g(^CT.WDT.CDSS.AssConResCondiD(ID)),6) 		//显示内容
	        s Remark=$lg($g(^CT.WDT.CDSS.AssConResCondiD(ID)),7) 			//备注
			d OutputRow
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,AssDR,DataType,CalculateMethod,CondiContent,ShowContent,Remark)
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

/// Creator：Xuwenhu
/// CreatDate:2021-10-18
/// Description：数据重复验证方法
/// Table：CT.WDT.CDSS.AssConResCondi 
/// Input：id,assdr-评估表指针,datatype-类型,calculatemethod-计算方式
/// Return："1"(数据重复),"0"(数据不重复)
/// other:w ##class(web.CDSS.Access.AssConResCondi).FormValidate("","158","累加")
ClassMethod FormValidate(id As %String, assdr As %String, datatype As %String, calculatemethod As %String) As %String
{
	n (id,assdr,datatype,calculatemethod)
	s flag=0,flagc=""		//默认不重复
	s:assdr'="" flagc=$d(^CT.WDT.CDSS.AssConResCondiI("AssCalMetIndex",assdr,datatype,calculatemethod))
	if (id="") 		//如果为空，增加时的重复判断
	{
		if ((calculatemethod'="公式")&(calculatemethod'="特殊"))		
		{
			if (flagc>0) s flag=1  			//返回重复标志
		}
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:assdr'="" idc=$o(^CT.WDT.CDSS.AssConResCondiI("AssCalMetIndex",assdr,datatype,calculatemethod,0))
		if (idc'=id)&(flagc>0)
		{
			if ((calculatemethod'="公式")&(calculatemethod'="特殊")) s flag=1  			//返回重复标志
		}
	}
	q flag
}

/// Creator:Xuwenhu
/// CreatDate:2021-10-18
/// Description：保存评估表关联评估结果条件设置表的内容
/// Table：CT.WDT.CDSS.AssConResCondi
/// Entity: web.CDSSEntity.Access.AssConResCondi 实体类
/// Return: 成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.Access.AssConResCondi).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.Access.AssConResCondi) As %String
{
	n (eobj)
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..FormValidate(eobj.ID,eobj.AssDR,eobj.DataType,eobj.CalculateMethod)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.AssConResCondi).%New()                
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.AssConResCondi).%OpenId(eobj.ID) 				
                
                s bobj = ##class(web.CDSSEntity.Access.AssConResCondi).%New()
                s bobj.ID=eobj.ID
				s bobj.AssDR=obj.AssDR.%Id()				//评估表指针
				s bobj.DataType =obj.DataType				//类型（总分、结论、描述）
				s bobj.CalculateMethod=obj.CalculateMethod	//计算方式（累加、平均值、最大值、最小值、公式、特殊）
				s bobj.CondiContent=obj.CondiContent		//公式/特殊条件
				s bobj.ShowContent=obj.ShowContent			//显示内容
				s bobj.Remark=obj.Remark					//备注
                
            }
            Ts
            d obj.AssDRSetObjectId(eobj.AssDR)				//评估表指针
			s obj.DataType=eobj.DataType					//名称
			s obj.CalculateMethod=eobj.CalculateMethod		//计算方式（累加、平均值、最大值、最小值、公式、特殊）
			s obj.CondiContent=eobj.CondiContent			//公式/特殊条件
			s obj.ShowContent=eobj.ShowContent				//显示内容
			s obj.Remark=eobj.Remark						//备注
			
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssConResCondi","CT.WDT.CDSS.AssConResCondi","评估表关联评估结果条件设置表",id,eobj.AssDR,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssConResCondi","CT.WDT.CDSS.AssConResCondi","评估表关联评估结果条件设置表",eobj.ID,eobj.AssDR,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表关联评估结果条件设置表","web.CDSS.Access.AssConResCondi","SaveData",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表关联评估结果条件设置表","web.CDSS.Access.AssConResCondi","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:Xuwenhu
/// CreatDate:2021-10—18
/// Description: 根据ID删除评估表关联评估结果条件设置表的内容
/// Table: CT.WDT.CDSS.AssConResCondi
/// Input: id-评估表关联评估结果条件设置表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.Access.AssConResCondi).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
	n (id)	
    s result="" 
    s obj=##class(CT.WDT.CDSS.AssConResCondi).%OpenId(id)      
    s bobj = ##class(web.CDSSEntity.Access.AssConResCondi).%New()
    s bobj.ID=id
	s bobj.AssDR=obj.AssDR.%Id()				//评估表指针
	s bobj.DataType =obj.DataType				//类型（总分、结论、描述）
	s bobj.CalculateMethod=obj.CalculateMethod	//计算方式（累加、平均值、最大值、最小值、公式、特殊）
	s bobj.CondiContent=obj.CondiContent		//公式/特殊条件
	s bobj.ShowContent=obj.ShowContent			//显示内容
	s bobj.Remark=obj.Remark					//备注
	d obj.%Close()
    k obj
    Tstart
    s sc=##class(CT.WDT.CDSS.AssConResCondi).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.AssConResCondi","CT.WDT.CDSS.AssConResCondi","评估表关联评估结果条件设置表",id,bobj.ID,"D",bobj)
        d bobj.%Close()
           
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("评估表关联评估结果条件设置表","web.CDSS.Access.AssConResCondi","DeleteData",bobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
     q result
}

/// Creator:Xuwenhu
/// CreatDate:2021-10—18
/// Description: 根据ID删除评估表关联评估结果条件设置表的内容
/// Table: CT.WDT.CDSS.AssConResCondi
/// Input: id-评估表关联评估结果条件设置表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.Access.AssConResCondi).OpenData("28")
ClassMethod OpenData(id As %String) As %String
{
	n (id)
	s str=""	
	s obj=##class(CT.WDT.CDSS.AssConResCondi).%OpenId(id)  
    /*s bobj = ##class(web.CDSSEntity.Access.AssConResCondi).%New()
    s bobj.ID=id
	s bobj.AssDR=obj.AssDR.%Id()				//评估表指针
	s bobj.DataType=obj.DataType				//类型（总分、结论、描述）
	s bobj.CalculateMethod=obj.CalculateMethod	//计算方式（累加、平均值、最大值、最小值、公式、特殊）
	s bobj.CondiContent=obj.CondiContent		//公式/特殊条件
	s bobj.ShowContent=obj.ShowContent			//显示内容
	s bobj.Remark=obj.Remark					//备注*/
	
	s str="{""ID"":"""_id_""""_",""AssDR"":"""_obj.AssDR.%Id()_""",""DataType"":"""_obj.DataType_""",""CalculateMethod"":"""_obj.CalculateMethod_""",""CondiContent"":"""_$replace(obj.CondiContent,"""","\""")_""",""ShowContent"":"""_$replace(obj.ShowContent,"""","\""")_""",""Remark"":"""_obj.Remark_"""}"
	/*d obj.%Close()		
	k obj
	s str = bobj.JsonS()	
	q str*/
	q str
}

/// Creator:Xuwenhu
/// CreatDate:2021-10—26
/// Description: 根据配置获取总分/结论/描述
/// Table: CT.WDT.CDSS.AssConResCondi
/// Input: id-评估表id,type-类型,resjson-前台传过来的结果信息串
/// Return：
/// Other:w ##class(web.CDSS.Access.AssConResCondi).GetResByConf("513","结论",^TMP("XWH"))
ClassMethod GetResByConf(id, type, resjson) As %String
{
	n (id,type,resjson)
	s Result=""
	s CondiID=0
	k All
	s json=[].%FromJSON(resjson)
	for i=1:1:json.%Size()
	{
		s ChildQ="s Q"_i_"="""_json.%Get("Q"_i)_""""
		x ChildQ
		x "s All(i)=Q"_i
	}
	for
	{
		s flag=0
		s CondiID=$o(^CT.WDT.CDSS.AssConResCondiI("AssTypeIndex",id,type,CondiID))
		q:CondiID=""
		s CalculateMethod=$lg($g(^CT.WDT.CDSS.AssConResCondiD(CondiID)),4) 		//计算方式（累加、平均值、最大值、最小值、公式、特殊）
		s CondiContent=$lg($g(^CT.WDT.CDSS.AssConResCondiD(CondiID)),5) 			//公式/特殊条件
		s ShowContent=$lg($g(^CT.WDT.CDSS.AssConResCondiD(CondiID)),6) 			//显示内容
		s Remark=$lg($g(^CT.WDT.CDSS.AssConResCondiD(CondiID)),7) 				//备注
		
		//((Q1>3)&(Q2>4))!(Q3>20)
		if CalculateMethod="特殊"
		{
			try
			{
				x "if ("_CondiContent_") s flag=1" 
			}
			catch
			{
				s Result=""
				continue	
			}
			if (flag=1)
			{
				if (ShowContent["}")
				{
					s p=0
					for
					{
						q:p>$l(ShowContent)
						s p1=$locate(ShowContent,"\{",p)
						s p2=$locate(ShowContent,"\}",p)
						q:p1=0
						s ChildExp=$e(ShowContent,p1,p2)
						s p=p1+1
						s ChildExp=$p($p(ShowContent,"}"),"{",2)	//取出表达式
						if $match(ChildExp,"(?i)^s\w?\s[a-z]?[0-9]?=.*")
						{
							x ChildExp
							s ShowContent=$replace(ShowContent,"{"_ChildExp_"}","") 	
						}
						else
						{
							x "s Val="_ChildExp
							if (($a(Val)>=49)&($a(Val)<=57))
							{
								s ShowContent=$replace(ShowContent,"{"_ChildExp_"}",$fn(Val,"N")) 
							}
							else
							{
								s ShowContent=$replace(ShowContent,"{"_ChildExp_"}",Val) 
							}
						}
					}	
				}
				if Result=""
				{
					s Result=ShowContent	
				}
				else
				{
					s Result=Result_","_ShowContent
				}
			}
		}
		else
		{
			//公式		P1=(Q1+Q2+Q3)*21/100,P2=(Q4+Q5+Q6)*22/100 || P1=(Q1)*0.2+(Q2)*0.1
			for i=1:1:$l(CondiContent,",")
			{
			    s Probability=$p(CondiContent,",",i)
			    s PName=$p(Probability,"=",1)		//概率P1
			    s Exp=$p(Probability,"=",2)			//表达式{...}
			    if Exp["eX"							//指数计算
				{
					s Exp=$replace(Exp,"eX","$ZEXP(X)")
				}
				if Exp["Max"
				{
					s num=$p($p(Exp,"(",2),")")
					x "s SortA="""_..Max(.All,num,json.%Size())_""""
					s SortA=$re(SortA)
					for j=1:1:$l(SortA,",")
					{						
						x "s "_PName_j_"="_$p(SortA,",",j)	
					}
					continue
				}
				if Exp["Min"
				{
					s num=$p($p(Exp,"(",2),")")
					x "s SortA="""_..Min(.All,num,json.%Size())_""""
					for j=1:1:$l(SortA,",")
					{
						x "s "_PName_j_"="_$p(SortA,",",j)	
					}
					continue
				}
				//Sort(Q1&Q2&Q2&Q4&Q5^2)
				if Exp["Sort"
				{
					k AllChild
					s qus=$p($p(Exp,"(",2),")")
					s para=$p(qus,"^",1)
					s num=$p(qus,"^",2)
					for j=1:1:$l(para,"&")
					{
						x "s AllChild(j)="_$p(para,"&",j)	
					}
					x "s SortA="""_..Sort(.AllChild,num,j)_""""
					s SortA=$re(SortA)
					for z=1:1:$l(SortA,",")
					{
						x "s "_PName_z_"="_$p(SortA,",",z)	
					}
					continue
				}
				try
				{
				    x "s "_PName_"="_Exp
				    x "s CVal="_Exp
				}
				catch e
				{
					s ShowContent=""
					continue	
				}
			    if (ShowContent[PName)
			    {
				    s ShowContent=$replace(ShowContent,PName,CVal)
					if (ShowContent["}")
					{
						s ChildExp=$p($p(ShowContent,"}"),"{",2)	//取出表达式
						x "s Val="_ChildExp
						/*if ((Val<1)&(Val>0))
						{
							s Val="0"_Val	
						}*/
						s ShowContent=$replace(ShowContent,"{"_ChildExp_"}",$fn(Val,"N")) 	
					}
				}
			}
			if Result=""
			{
				s Result=ShowContent	
			}
			else
			{
				s Result=Result_","_ShowContent
			}
		}
	}
	q Result
}

/// Creator:Xuwenhu
/// CreatDate:2021-11—12
/// Description: 排序-最大值
/// Table: CT.WDT.CDSS.AssConResCondi
/// Input: arr-分值数组,num-取最大值的个数,n-题目总数
/// Return：分数串
/// Other:w ##class(web.CDSS.Access.AssConResCondi).Max(.arr,type,n)
ClassMethod Max(ByRef arr, num, n) As %String
{
	n (arr,num,n)
	s result=""
	d ##class(web.DHCBL.BDP.FunLib).QuickSort(.arr,1,n)		//排序
	for i=n-num+1:1:n
	{
		if result=""
		{
			s result=arr(i)
		}
		else
		{
			s result=result_","_arr(i)
		}
	}
	q result
}

/// Creator:Xuwenhu
/// CreatDate:2021-11—12
/// Description: 排序-最小值
/// Table: CT.WDT.CDSS.AssConResCondi
/// Input: arr-分值数组,num-取最大值的个数,n-题目总数
/// Return：分数串
/// Other:w ##class(web.CDSS.Access.AssConResCondi).Min(.arr,type,n)
ClassMethod Min(ByRef arr, num, n) As %String
{
	n (arr,num,n)
	s result=""
	d ##class(web.DHCBL.BDP.FunLib).QuickSort(.arr,1,n)		//排序
	for i=1:1:num
	{
		if result=""
		{
			s result=arr(i)
		}
		else
		{
			s result=result_","_arr(i)
		}
	}
	q result
}

/// Creator:Xuwenhu
/// CreatDate:2022-03—21
/// Description: 指定题目排序-最大值
/// Table: CT.WDT.CDSS.AssConResCondi
/// Input: arr-分值数组,num-取最大值的个数,n-题目总数
/// Return：分数串
/// Other:w ##class(web.CDSS.Access.AssConResCondi).Sort(.arr,num,n)
ClassMethod Sort(ByRef arr, num, n) As %String
{
	n (arr,num,n)
	s result=""
	d ##class(web.DHCBL.BDP.FunLib).QuickSort(.arr,1,n)		//排序
	for i=n-num+1:1:n
	{
		if result=""
		{
			s result=arr(i)
		}
		else
		{
			s result=result_","_arr(i)
		}
	}
	q result
}

}
