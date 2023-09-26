Class web.DHCWL.V1.BKCDQry.BKCUIServ Extends %RegisteredObject
{

/*


	返回：报表工具编码，报表ID，报表名称，报表描述，报表标题，作者
	w ##class(web.DHCWL.V1.BKCDQry.BKCUIServ).GetBKCRptList()
*/
ClassMethod GetBKCRptList()
{
		s qryName="%DynamicQuery:SQL"  //固定写法

		//上面是固定写法 
		//////////////////////////////////////////
		/*
		s sql="SELECT 'CommonDataQry' AS toolName,ID ,RptName As name,descript,rptTitle AS title, t2.SSUSR_Name AS author "
		s sql=sql_"	FROM DHCWL_CommonDataQry.RptCfg t1 LEFT JOIN ss_user t2 ON t1.UserID = t2.SSUSR_RowId"
		*/
		
		s sql="SELECT 'CommonDataQry' AS toolName,ID ,RptName As name,descript,rptTitle AS title, t2.SSUSR_Name AS author ,"
		s sql=sql_"	pdttype AS BusinessType"
		s sql=sql_"	FROM DHCWL_CommonDataQry.RptCfg t1 LEFT JOIN ss_user t2 ON t1.UserID = t2.SSUSR_RowId"
		s sql=sql_"	UNION"
		s sql=sql_"	SELECT 'BaseDataQuery' AS toolName,ID , name,descript,name AS title, t2.SSUSR_Name AS author ,t1.BusinessType"
		s sql=sql_"		FROM DHCWL_BaseDataQuery.Rpt t1 LEFT JOIN ss_user t2 ON t1.creator = t2.SSUSR_RowId		"
		
		s jsonPro="toolName,ID,name,descript,title,author,BusinessType"	
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,0,0,jsonPro,1)
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		i json.GetCount()=0 w "]}"
}

/// w ##class(web.DHCWL.V1.BKCDQry.BKCUIServ).GetSearchCondData(1,1)
ClassMethod GetSearchCondData(rptID As %String, rptTool As %String)
{
	//////////////////////////////////////////////////////////
	//所有报表的公用部分
	/*s tempPros="name^value^group^editor"
	s deli="^"
	s page=1
	s json=##class(web.DHCWL.V1.CommonUtil.Json).Json(tempPros,,,deli,page)
	s values="""开始日期""^""""^""1""^""datebox"""
	d json.Insert(values)
	s values="""结束日期""^""""^""1""^""datebox"""
	d json.Insert(values)
	*/
	
	s aryData("header")="name,value,group,editor,code"
	s aryData("NO-Data",1)="开始日期,,1,datebox,startDate"
	s aryData("NO-Data",2)="结束日期,,1,datebox,endDate"

	////////////////////////////////////////////////
	//基础数据查询
	s NO=3
	if rptTool="BaseDataQuery" {
		s rptObj=##class(DHCWL.BaseDataQuery.Rpt).GetById(rptID)
		s list=rptObj.GetItemsByType("queryconf")
		s cnt=list.Count()
		f i=1:1:cnt {
			s code=list.GetAt(i).Code
			s name=list.GetAt(i).Name
			s aryData("NO-Data",NO)=name_",,1,text,"_code
			s NO=NO+1
		}
	}
	
	
	
	s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByArray(.aryData)
	
	w json.GetHead()
	d{
		s obj=json.Next()
		w obj
	}while(obj'="")
	i json.GetCount()=0 w "]}"
}

/// Creator：      		wangzheng
/// CreatDate：    		2018-05-24
/// Description:：   	返回报表配置信息
/// Table：       
/// Input：            	rptID：报表ID；rptTool：配置报表的工具，
/// 						包括：通用简单查询-CommonDataQry;
/// Output：          	无
/// Return：         	返回JSON格式数据。
/// Others：        		无
/// w ##class(web.DHCWL.V1.BKCDQry.BKCUIServ).GetRptConfigs(3,"BaseDataQuery")
ClassMethod GetRptConfigs(rptID As %String, rptTool As %String)
{
	s tempPros="name,value,group,editor,code"
	s deli=","
	s page=1
	s json=##class(web.DHCWL.V1.CommonUtil.Json).Json(tempPros,,,deli,page)
	s num=0
	
	if rptTool="CommonDataQuery" {
		//s tempPros="name,value,group,editor,code"

		s newObj=##class(DHCWL.CommonDataQry.RptCfg).%OpenId(rptID)
		s nameSpace=newObj.NameSpace
		s fun=newObj.Fun
		s qryName=newObj.QryName
		s routine=newObj.Routine
		s code=newObj.Code
		s otherParam=newObj.OtherParam
		s name=newObj.RptName
		
		s values="""报表名称"","""_name_""",""总览"","""",""name"""
		d json.Insert(values)
		s values="""NameSpace"","""_nameSpace_""",""总览"","""",""nameSpace"""
		d json.Insert(values)
		s values="""Routine"","""_routine_""",""总览"","""",""routine"""
		d json.Insert(values)
		s values="""Function"","""_fun_""",""总览"","""",""fun"""
		d json.Insert(values)
		s values="""编码"","""_code_""",""总览"","""",""code"""
		d json.Insert(values)

		s num=5
		d json.SetTotalNum(num)
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		i json.GetCount()=0 w "]}"
	}elseif rptTool="BaseDataQuery" || (rptTool="KpiDataQuery") {
		
		s aryData("header")="name,value,group,editor,code"

		//总览
		s rptObj=##class(DHCWL.BaseDataQuery.Rpt).GetById(rptID)
		s NO=1
		s aryData("NO-Data",NO)="名称"_$C(2)_rptObj.Name_$C(2)_"总览"_$C(2)_$C(2)
		s NO=NO+1	
		s aryData("NO-Data",NO)="编码"_$C(2)_rptObj.Code_$C(2)_"总览"_$C(2)_$C(2)
		s NO=NO+1	
		s aryData("NO-Data",NO)="业务类型"_$C(2)_rptObj.BusinessType_$C(2)_"总览"_$C(2)_$C(2)
		//报表项
		//s list=rptObj.GetItemsByType("queryconf")
		s list=rptObj.GetItemsByType("col")
		s cnt=list.Count()
		f i=1:1:cnt {
			s Code=list.GetAt(i).Code
			s Name=list.GetAt(i).Name
			s NO=NO+1
			s aryData("NO-Data",NO)="列名称"_$C(2)_Name_$C(2)_"报表列"_$C(2)_$C(2)
		}		
		//过滤
		s DS=rptObj.QryObjDr.DataSrcDr
		s list=rptObj.GetItemsByType("filter")
		s cnt=list.Count()
		f i=1:1:cnt {
			s Code=list.GetAt(i).Code
			s Name=list.GetAt(i).Name
			s Exp=list.GetAt(i).Exp
			d DS.ParseItemExp(Exp,.aryExp)
			
			s NO=NO+1
			s value=aryExp("logical")_" "_Name_" "_aryExp("Relational")_" "_aryExp("V1")
			if aryExp("Relational")="between" s value=value_" "_aryExp("V2")
			s aryData("NO-Data",NO)="过滤"_$C(2)_value_$C(2)_"过滤"_$C(2)_$C(2)
		}		
		//排序
		s DS=rptObj.QryObjDr.DataSrcDr
		s list=rptObj.GetItemsByType("order")
		s cnt=list.Count()
		f i=1:1:cnt {
			s Code=list.GetAt(i).Code
			s Name=list.GetAt(i).Name
			s Exp=list.GetAt(i).Exp
			d DS.ParseItemExp(Exp,.aryExp)
			
			s NO=NO+1
			s aryData("NO-Data",NO)=Name_$C(2)_aryExp("Type")_$C(2)_"排序"_$C(2)_$C(2)
		}				
		

	
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByArray(.aryData,$C(2))
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		i json.GetCount()=0 w "]}"		
	}/*elseif rptTool="KpiDataQuery" {
		
		
	}*/
}

/// Creator：      		wangzheng
/// CreatDate：    		2018-05-24
/// Description:：   	返回报表配置信息
/// Table：       
/// Input：            	rptID：报表ID；rptTool：配置报表的工具，
/// 						包括：通用简单查询-CommonDataQry;
/// Output：          	无
/// Return：         	返回JSON格式数据。
/// Others：        		无
/// w ##class(web.DHCWL.V1.BKCDQry.BKCUIServ).GetCommonRptConfigs("",1,100)
ClassMethod GetCommonRptConfigs(searchValue As %String, page As %Integer, rows As %Integer)
{
		s start=((page-1)*rows)
		s limit=rows
		s end=start+limit
		s start=start+1
			
		s qryName="%DynamicQuery:SQL"  //固定写法

		//上面是固定写法 
		//////////////////////////////////////////


		s sql="SELECT ID,QryName,NameSpace,Routine,Fun,OtherParam,RptTitle,RptName,UserID,Descript FROM DHCWL_CommonDataQry.RptCfg"
		s sqlConf=""
		if searchValue'="" {
			s sqlConf=" WHERE Fun LIKE '%"_searchValue_"%' OR NameSpace LIKE '%"_searchValue_"%' OR OtherParam LIKE '%"_searchValue_"%' OR QryName LIKE '%"_searchValue_"%' OR Routine LIKE '%"_searchValue_"%' OR RptTitle LIKE '%"_searchValue_"%'"
		}
		s sql=sql_sqlConf
		s jsonPro="ID,QryName,NameSpace,Routine,Fun,OtherParam,RptTitle,RptName,UserID,Descript"	
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		i json.GetCount()=0 w "]}"
}

ClassMethod SaveCfg(ID As %String, Routine As %String, Fun As %String, NameSpace As %String, OtherParam As %String, RptTitle As %String, QryName As %String, PdtType As %String, Descript As %String, RptName As %String)
{
	s ret=""
	s inParam("rowID")=ID
	s inParam("QryName")=QryName
	s inParam("NameSpace")=NameSpace
	s inParam("Routine")=Routine
	s inParam("Function")=Fun
	s inParam("OtherParam")=OtherParam
	s inParam("RptTitle")=RptTitle
	s inParam("PdtType")=PdtType
	s inParam("Descript")=Descript
	s inParam("RptName")=RptName
	s exist= ##class(DHCWL.CommonDataQry.RptCfg).IsExistRec(.inParam,.outParam)

	if ID=0 {
		if exist=1 {
			w "{""msg"":""已存在相同的配置！请修改报表名称后再尝试保存。"",""success"":""0""}"
			q
		}
		s ret= ##class(DHCWL.CommonDataQry.RptCfg).Insert(.inParam,.outParam)
		s ID=inParam("rowID")
	}else{
		if exist=1 && (outParam("existRowID")'=ID)  {
			w "{""msg"":""已存在相同的配置！请修改报表名称后再尝试保存。"",""success"":""0""}"
			q
		}		//existRowID
		s ret= ##class(DHCWL.CommonDataQry.RptCfg).Update(.inParam,.outParam)
	}
	if ret="" s ret="操作成功！"
	w "{""msg"":"""_ret_""",""rowid"":"""_ID_""",""success"":""1""}"
	q
}

}
