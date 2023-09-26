Class web.DHCWL.V1.RptMgmt Extends %RegisteredObject
{

ClassMethod getSavedMgmt2(searchValue As %String, page As %Integer, rows As %Integer)
{
		s start=((page-1)*rows)
		s limit=rows
		s qryName="DHCWL.RptMgmt.Serv:QryRptMgmtDataUsedLike"
		s end=start+limit
		s start=start+1

		//上面是固定写法 
		//////////////////////////////////////////

		s qryName="DHCWL.RptMgmt.Serv:QryRptMgmtDataUsedLike"
		s arguments=searchValue
		s jsonPro="ID,AdvUser,AuxiliaryMenuName,CSPName,CreateDate,"
		s jsonPro=jsonPro_"Demo,DepMaintainer,Filter,HisTableName,KPIName,"
		s jsonPro=jsonPro_"MenuName,ProMaintainer,ProgramLogic,QueryName,RaqName," 
		s jsonPro=jsonPro_"RowColShow,Spec,UPdateDate,UsedByDep,CellSubgrpMap"	
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,arguments,"",start,end,jsonPro,page)
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		i json.GetCount()=0 w "]}"
}

ClassMethod AddMgmtRec(ID As %String, MenuName As %String, RaqName As %String, CSPName As %String, QueryName As %String, AuxiliaryMenuName As %String, Spec As %String, HisTableName As %String, KPIName As %String, Filter As %String, RowColShow As %String, ProgramLogic As %String, AdvUser As %String, ProMaintainer As %String, DepMaintainer As %String, Demo As %String, UsedByDep As %String, CellSubgrpMap As %String) As %String
{
	s inParam("ID")=ID
	s inParam("MenuName")=MenuName
	s inParam("RaqName")=RaqName
	s inParam("CSPName")=CSPName
	s inParam("QueryName")=QueryName
	s inParam("AuxiliaryMenuName")=AuxiliaryMenuName
	s inParam("Spec")=Spec
	s inParam("HisTableName")=HisTableName
	s inParam("KPIName")=KPIName
	s inParam("Filter")=Filter
	s inParam("RowColShow")=RowColShow
	s inParam("ProgramLogic")=ProgramLogic
	s inParam("AdvUser")=AdvUser
	s inParam("ProMaintainer")=ProMaintainer	
	s inParam("DepMaintainer")=DepMaintainer
	s inParam("Demo")=Demo	
	
	s inParam("UsedByDep")=UsedByDep
	s inParam("CellSubgrpMap")=CellSubgrpMap
	
	if ID'="" {
		s ret=##class(DHCWL.RptMgmt.RptCfg).Update(.inParam,.outParam)
	}else{
		
		s ret=##class(DHCWL.RptMgmt.RptCfg).Insert(.inParam,.outParam)
	}

	if ret'="" {
		//w "{success:true,tip:'false',MSG:'"_ret_"'}"	

		q ret		
	}
	
	//w "ok"
	q "ok"
}

ClassMethod GetMenuCfg(MenuName As %String, RaqName As %String, CSPName As %String, page As %Integer, rows As %Integer)
{
		s start=((page-1)*rows)
		s limit=rows
		s qryName="%DynamicQuery:SQL"  //固定写法
		s end=start+limit
		s start=start+1

		//上面是固定写法 
		//////////////////////////////////////////

		s sql="SELECT Caption As MenuName, $PIECE($PIECE(ValueExpression,'&reportName=',2),'.raq')||'.raq'  As RaqName, LinkUrl As CSPName "
		s sql=sql_"from websys.Menu WHERE ($FIND(%SQLUPPER(ValueExpression),'RAQ')>0 or ValueExpression IS NULL ) "
		s sql=sql_"AND ($FIND(%SQLUPPER(LinkUrl),'CSP')>0 or LinkUrl IS NULL ) "
		s sql=sql_"AND Type='SideMenu' "
		s sqlConf=""
		if MenuName'="" {
			s sqlConf="Caption like '%"_MenuName_"%'"
		}
		if RaqName'="" {
			if sqlConf'="" s sqlConf=sqlConf_" and "
			s sqlConf=sqlConf_"%SQLUPPER(ValueExpression) like %SQLUPPER('%"_RaqName_"%')"
		}		
		if CSPName'="" {
			if sqlConf'="" s sqlConf=sqlConf_" and "
			s sqlConf=sqlConf_"LinkUrl like '%"_CSPName_"%'"
		}	
			
		if sqlConf'="" s sql=sql_"and "_sqlConf
		//w !,sql

		s jsonPro="MenuName,RaqName,CSPName"	
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		i json.GetCount()=0 w "]}"
}

ClassMethod getSavedMgmt(MenuName As %String, RaqName As %String, CSPName As %String, page As %Integer, rows As %Integer)
{
		s start=((page-1)*rows)
		s limit=rows
		s qryName="%DynamicQuery:SQL"  //固定写法
		s end=start+limit
		s start=start+1
		if rows=0 {
			s start=0
			s end=0
		}

		//上面是固定写法 
		//////////////////////////////////////////

		s sql="SELECT ID, AdvUser, AuxiliaryMenuName, CSPName, CreateDate, "
		s sql=sql_"Demo, DepMaintainer, Filter, HisTableName, KPIName, "
		s sql=sql_"MenuName, ProMaintainer, ProgramLogic, QueryName, RaqName," 
		s sql=sql_"RowColShow, Spec, UPdateDate,UsedByDep FROM DHCWL_RptMgmt.RptCfg "
		s sqlConf=""
		if MenuName'="" {
			s sqlConf="MenuName like '%"_MenuName_"%'"
		}
		if RaqName'="" {
			if sqlConf'="" s sqlConf=sqlConf_" and "
			s sqlConf=sqlConf_"RaqName like '%"_RaqName_"%'"
		}		
		if CSPName'="" {
			if sqlConf'="" s sqlConf=sqlConf_" and "
			s sqlConf=sqlConf_"CSPName like '%"_CSPName_"%'"
		}	
			
		if sqlConf'="" s sql=sql_"WHERE "_sqlConf
		//w !,sql

		s jsonPro="ID,AdvUser,AuxiliaryMenuName,CSPName,CreateDate,"
		s jsonPro=jsonPro_"Demo,DepMaintainer,Filter,HisTableName,KPIName,"
		s jsonPro=jsonPro_"MenuName,ProMaintainer,ProgramLogic,QueryName,RaqName," 
		s jsonPro=jsonPro_"RowColShow,Spec,UPdateDate,UsedByDep"



		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		i json.GetCount()=0 w "]}"
}

Query QryExpExcel(ExpIDs As %String) As %Query(ROWSPEC = "AdvUser:%String,AuxiliaryMenuName:%String,CSPName:%String,CreateDate:%String,Demo:%String,DepMaintainer:%String,Filter:%String,HisTableName:%String,KPIName:%String,MenuName:%String,ProMaintainer:%String,ProgramLogic:%String,QueryName:%String,RaqName:%String,RowColShow:%String,Spec:%String,UPdateDate:%String,UsedByDep:%String,CellSubgrpMap:%String")
{
}

ClassMethod QryExpExcelExecute(ByRef qHandle As %Binary, ExpIDs As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1

	s aryFields(1,"AdvUser")="高级客户"
	s aryFields(2,"AuxiliaryMenuName")="当前页面名称"
	s aryFields(3,"CSPName")="CSP名称"
	s aryFields(4,"CreateDate")="创建日期"
	s aryFields(5,"Demo")="备注"	
	s aryFields(6,"DepMaintainer")="开发工程师"
	s aryFields(7,"Filter")="数据条件"
	s aryFields(8,"HisTableName")="业务表"
	s aryFields(9,"KPIName")="指标"
	s aryFields(10,"MenuName")="菜单名称"	
	s aryFields(11,"ProMaintainer")="项目工程师"
	s aryFields(12,"ProgramLogic")="逻辑说明"
	s aryFields(13,"QueryName")="主程序query"
	s aryFields(14,"RaqName")="raq名称"	
	s aryFields(15,"RowColShow")="显示条件"
	s aryFields(16,"Spec")="统计口径"
	s aryFields(17,"UPdateDate")="更新日期"
	s aryFields(18,"UsedByDep")="使用科室"
	s aryFields(19,"CellSubgrpMap")="单元格-统计子组对应关系"

	s sql="SELECT AdvUser, AuxiliaryMenuName, CSPName, CreateDate, "
	s sql=sql_"Demo, DepMaintainer, Filter, HisTableName, KPIName, "
	s sql=sql_"MenuName, ProMaintainer, ProgramLogic, QueryName, RaqName," 
	s sql=sql_"RowColShow, Spec, UPdateDate,UsedByDep,CellSubgrpMap FROM DHCWL_RptMgmt.RptCfg "
	s sqlConf=" where id in ("_ExpIDs_")"
	
	s sql=sql_sqlConf
		
		
	s qryName="%DynamicQuery:SQL"	
	s rs=##class(%Library.ResultSet).%New(qryName)
	d rs.Prepare(sql)
	d rs.Execute()
	
	s Data=$LB("")
	s inx=0
	
	f {
		s inx=$o(aryFields(inx))
		q:inx=""
		s fieldName=$o(aryFields(inx,""))
		s $LI(Data,inx)=aryFields(inx,fieldName)
		//s inx=inx+1
	}	
	Do OutRow
	
	While(rs.Next()){
		s inx=0
		s Data=$LB("")
		s fieldName=""
		f {
			s inx=$o(aryFields(inx))
			q:inx=""
			s fieldName=$o(aryFields(inx,""))
			s $LI(Data,inx)=""""_rs.Data(fieldName)_""""
			//s inx=inx+1
		}
		Do OutRow
	}

	s sc=rs.Close()

		
    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QryExpExcelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryExpExcelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryExpExcelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryExpExcelExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ImpChk(inputList)
{
		k outParam
		s inputList=$g(%request.Data("inputList",1))
		//w !,inputList
		s listCnt=$l(inputList,",")/4
		s RCParam=""
		f inx=1:1:listCnt {
			s pos=(inx-1)*4
			s RaqName=$p(inputList,",",pos+2)
			s CSPName=$p(inputList,",",pos+3)
			s AuxiliaryMenuName=$p(inputList,",",pos+4)
			s inParam(RaqName_"^"_CSPName_"^"_AuxiliaryMenuName)=""
		}
		
		//zw inParam
		s ret=##class(DHCWL.RptMgmt.RptCfg).CheckRepeat(.inParam,.outParam)

		if ret="" {
			s num=0
			w "{success:true,tip:'ok',root:["
			s repData=""
			f {
				s repData=$o(outParam(repData))
				q:repData=""
				i num>0 w ","
				w "{repData:'"_repData_"'}"
				s num=num+1

			}
			w "],totalNum:"_num_"}"			
			
		}else{
			w "{success:true,tip:'false',MSG:'"_ret_"'}"
		}
}

ClassMethod impFromExl(fieldNames, inputList)
{
		k inParam
		k outParam
		//w !,inputList
		s fieldlength=$l(fieldNames,",")
		s dataLength=$l(inputList,$c(2))
		s recsLength=dataLength/fieldlength
		
		s ret=""
		TSTART
		f i=1:1:recsLength{
			k inParam
			f j=1:1:fieldlength{
				s field=$p(fieldNames,",",j)
				s pos=+(i-1)*fieldlength
				s data=$p(inputList,$c(2),pos+j)
				s inParam(field)=data
			}

			//已存在就更新	
			if $d(^DHCWL.RptMgmt.RptCfgI("InxRaqCspTitle",($g(inParam("RaqName"))_"|"_$g(inParam("CSPName"))_"|"_$g(inParam("AuxiliaryMenuName"))))) {
				s inParam("ID")=$o(^DHCWL.RptMgmt.RptCfgI("InxRaqCspTitle",$g(inParam("RaqName"))_"|"_$g(inParam("CSPName"))_"|"_$g(inParam("AuxiliaryMenuName")),""))
				s ret=##class(DHCWL.RptMgmt.RptCfg).Update(.inParam,.outParam)
				if ret'="" {
					//w "{success:true,tip:'false',MSG:'"_ret_"'}"	
					Trollback
							
				}	
			}else{	//不存在就插入
				s ret=##class(DHCWL.RptMgmt.RptCfg).Insert(.inParam,.outParam)
				if ret'="" {
					//w "{success:true,tip:'false',MSG:'"_ret_"'}"	
					Trollback
							
				}				
			}
			if ret'="" q 
		}
		if ret="" {
			TCOMMIT	
			q "ok"
			//w "{success:true,tip:'ok',MSG:'操作成功'}"
		}else{
			q ret
		}
}

}
