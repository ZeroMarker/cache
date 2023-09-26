Class web.DHCWL.V1.BKCDQry.CommonDataServ Extends %RegisteredObject
{

ClassMethod GetCdqCfgList(searchV As %String) As %String
{
	if 0 {
		s start=((page-1)*rows)
		s limit=rows
		s end=start+limit
		s start=start+1
	}else{
		s start=0
		s end=0
		s start=0	
		s page=1	
	}	

	s qryName="%DynamicQuery:SQL"  //固定写法
	s sql="SELECT ID,NameSpace,Routine,Fun,OtherParam,Code,RptName,Descript,UserDr->SSUSR_Name as SSUSR_Name ,PdtType"
	s sql=sql_" FROM DHCWL_CommonDataQry.RptCfg "	
	if searchV'="" {
		s sql=sql_" where (NameSpace LIKE '%"_searchV_"%' OR Routine LIKE '%"_searchV_"%' "
		s sql=sql_"OR Fun LIKE '%"_searchV_"%' OR OtherParam LIKE '%"_searchV_"%' OR Code LIKE '%"_searchV_"%' "
		s sql=sql_"OR RptName LIKE '%"_searchV_"%' OR Descript LIKE '%"_searchV_"%' OR UserDr->SSUSR_Name LIKE '%"_searchV_"%'  OR PdtType LIKE '%"_searchV_"%' )"
	}
	
	//w !,sql
	s jsonPro="ID,NameSpace,Routine,Fun,OtherParam,Code,RptName,Descript,SSUSR_Name,PdtType"
	s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
	
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
/// w ##class(web.DHCWL.V1.BKCDQry.BKCUIServ).GetCommonRptConfigs("",1,100)
ClassMethod LoadCDQRptCfg(rptID As %String)
{
	if 0 {
		s start=((page-1)*rows)
		s limit=rows
		s end=start+limit
		s start=start+1
	}else{
		s start=0
		s end=0
		s start=0	
		s page=1	
	}
			
	s qryName="%DynamicQuery:SQL"  //固定写法

	//上面是固定写法 
	//////////////////////////////////////////
	s sql="SELECT ID,NameSpace,Routine,Fun,OtherParam,Code,RptName,Descript,UserDr->SSUSR_Name,PdtType FROM DHCWL_CommonDataQry.RptCfg where ID="_rptID
	s jsonPro="ID,NameSpace,Routine,Fun,OtherParam,Code,RptName,Descript,SSUSR_Name,PdtType"	
	s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
	
	s body=json.GetJsonBody()
	//w "{""msg"":""操作成功"",""success"":""1""}"
	w "{""msg"":""操作成功"",""success"":""1"",""rows"":"_body_"}"
}

ClassMethod SaveRpt(actType As %String, ID As %String, Routine As %String, Fun As %String, NameSpace As %String, OtherParam As %String, Code As %String, UserID As %String, PdtType As %String, Descript As %String, RptName As %String)
{
	s ret=""
	s inParam("rowID")=ID
	s inParam("Code")=Code
	s inParam("NameSpace")=NameSpace
	s inParam("Routine")=Routine
	s inParam("Function")=Fun
	s inParam("OtherParam")=OtherParam
	s inParam("UserID")=UserID
	s inParam("PdtType")=PdtType
	s inParam("Descript")=Descript
	s inParam("RptName")=RptName
	
	if actType="InsertRpt" {
		s ret= ##class(DHCWL.CommonDataQry.RptCfg).Insert(.inParam,.outParam)
		s ID=inParam("rowID")
	}elseif actType="UpdateRpt"{
		s ret= ##class(DHCWL.CommonDataQry.RptCfg).Update(.inParam,.outParam)
	}
	if ret="" {
		s ret="操作成功！"
		w "{""msg"":"""_ret_""",""rowid"":"""_ID_""",""success"":""1""}"
	}else{
		w "{""msg"":"""_ret_""",""success"":""0""}"
		
	}
	q
}

ClassMethod DelRpt(rptID)
{
	if $d(^DHCWL.PerMis.RGMapI("InxRG","cdq",rptID)) {
		s ret="该报表已被关联了权限，请先在“权限管理>报表-组配置”配置中删除关联后再操作。"
		w "{""msg"":"""_ret_""",""success"":""0""}"
		q ""		
		
	}
	
	s ret=##class(DHCWL.CommonDataQry.RptCfg).DelRpt(rptID)
	if ret'="" {
		w "{""msg"":"""_ret_""",""success"":""0""}"
		q ""
		
		
	}
	w "{""msg"":""操作成功"",""success"":""1""}"
	q ""
}

/// Creator：      王峥
/// CreatDate：    2018-7-24
/// Description:：   插入
/// Table：       qryObj
/// Input：            inParam:插入的信息
/// Output：          outParam:插入成功后的ROWID
/// Return：         "":成功；其他：错误信息
/// Others：        其它说明
/// s ret=##class(DHCWL.BaseDataQuery.Rpt)Insert(,)
ClassMethod GetRptIdByCode(rptCode) As %String
{
	s ret=""
	if $d(^DHCWL.CommonDataQry.RptCfgI("InxCode",rptCode)) {
		s ret=$o(^DHCWL.CommonDataQry.RptCfgI("InxCode",rptCode,""))
	}
	w "{""ID"":"""_ret_""",""success"":""1""}"
	q ""
}

}
