Class web.DHCWL.V1.BKCDQry.BaseDataServ Extends %RegisteredObject
{

ClassMethod GetBDQObj() As %String
{
	s qryName="%DynamicQuery:SQL"  //固定写法
	s sql="SELECT ID,Code,Name,Descript,DataSrcDr->Name AS DSName,DataSrcDr->Type AS DSType"
	s sql=sql_" FROM DHCWL_BaseDataQuery.QryObj"
	//上面是固定写法 
	//////////////////////////////////////////
	s start=0,end=0,page=1

	s jsonPro="ID,Code,Name,Descript,DSName,DSType"
	
	s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)

	w json.GetHead()
	d{
		s obj=json.Next()
		w obj
	}while(obj'="")
	i json.GetCount()=0 w "]}"
			
	q ""
}

/// d ##class(%ResultSet).RunQuery("web.DHCWL.V1.BKCDQry.BaseDataServ","QryBDQObj")
Query QryBDQObj() As %Query(ROWSPEC = "ID:%String,Name:%String,Descript:%String,ThemeName:%String")
{
}

ClassMethod QryBDQObjExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	s lstObj=##class(DHCWL.BaseDataQuery.QueryObj).GetAll()
	
	s lstCnt=lstObj.Count() 
	f pos=1:1:lstCnt {
		s ID=lstObj.GetAt(pos).%Id()
		s Name=lstObj.GetAt(pos).BaseObjName
		s Descript=lstObj.GetAt(pos).BaseObjDesc
		s themePath=lstObj.GetAt(pos).ThemeBaseID
		
		s ThemeName=""
		if themePath'="" {
			s themeObj=##class(DHCWL.DM.T.ThemeBase).GetByPath(themePath)
			s ThemeName=themeObj.Name
		}
		s Data=$lb(ID,Name,Descript,ThemeName)
		Do OutRow
	}	
	
	
    Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QryBDQObjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBDQObjExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBDQObjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBDQObjExecute ]
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

ClassMethod GetDSItems(DSID As %String) As %String
{
	s ds=##class(DHCWL.BaseDataQuery.DS).%OpenId(DSID)

	//得到维度数据+度量数据
	//s lstFields=ds.GetFields()
	s lstFields=ds.GetDims()
	//w "{""curPage"":1,""total"":1,""rows"":[{""DSCode"":""Workload_flag"",""DSName"":""Workload_flag"",""DSDesc"":""标准"",""DSType"":""维度"",""DSCreateType"":""System"",""Exp"":""""}]}"
	s start=0, end=0
	s page=1
	
	s jsonPro="Code,Name"
	s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByList(lstFields,start,end,jsonPro,page)

	w json.GetHead()
	d{
		s obj=json.Next()
		w obj
	}while(obj'="")
	i json.GetCount()=0 w "]}"
			
	q 0
}

ClassMethod GetDS(DSType As %String, DSName As %String) As %String
{
	//w "{""curPage"":1,""total"":1,""rows"":[{""Code"":""pbDhcworkload"",""Name"":""pbDhcworkload"",""Desc"":""综合查询收入""}]}"


	s qryName="%DynamicQuery:SQL"  //固定写法
	s end=0
	s start=0
	s page=1
	//上面是固定写法 
	//////////////////////////////////////////

	s sql="SELECT ID,Code,Name,Descript,Type FROM DHCWL_BaseDataQuery.DS"
	s jsonPro="ID,Code,Name,Descript,Type"	
	s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
	
	w json.GetHead()
	d{
		s obj=json.Next()
		w obj
	}while(obj'="")
	i json.GetCount()=0 w "]}"









	q 1
}

Query QryDSFields(DSID As %String) As %Query(ROWSPEC = "Code:%String,Name:%String,Descript:%String,Type:%String,CreateType:%String,DataType:%String")
{
}

ClassMethod QryDSFieldsExecute(ByRef qHandle As %Binary, DSID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if DSID'="" {
		s ds=##class(DHCWL.BaseDataQuery.DS).%OpenId(DSID)

		//维度数据
		s lstFields=ds.GetDims()
		s lstCnt=lstFields.Count()
		s ID=""
		f pos=1:1:lstCnt {
			s Code=lstFields.GetAt(pos).Code
			s Name=lstFields.GetAt(pos).Name
			s Descript=lstFields.GetAt(pos).Description
			
			s DataType=lstFields.GetAt(pos).DataType
			if $ISOBJECT(DataType) s DataType=DataType.JDBCTypeCodeNum	
					
			S Type="维度"
			s CreateType="系统"
			s Data=$lb(Code,Name,Descript,Type,CreateType,DataType)		
			Do OutRow
		}
		//度量数据
		s lstFields=ds.GetMetrics()
		s lstCnt=lstFields.Count()
		f pos=1:1:lstCnt {
			s Code=lstFields.GetAt(pos).Code
			s Name=lstFields.GetAt(pos).Name
			s Descript=lstFields.GetAt(pos).Description
			
			s DataType=lstFields.GetAt(pos).DataType
			if $ISOBJECT(DataType) s DataType=DataType.JDBCTypeCodeNum	
			
			S Type="度量"
			s CreateType="系统"
			s Data=$lb(Code,Name,Descript,Type,CreateType,DataType)		
			Do OutRow
		}	
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutRow
	;set Data=$lb(Values,Desc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryDSFieldsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDSFieldsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDSFieldsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDSFieldsExecute ]
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

ClassMethod InsertQryObj(QryObj As %String, QryItems As %String)
{
	Set $ZT="SQLErr"
	s inParam("qryObjCode")=$p(QryObj,"^",1)
	s inParam("qryObjName")=$p(QryObj,"^",2)
	s inParam("qryObjDesc")=$p(QryObj,"^",3)
	s inParam("qryObjDSID")=$p(QryObj,"^",4)
	
	s inParam("itemCodes")=$p(QryItems,$C(2),1)
	s inParam("itemNames")=$p(QryItems,$C(2),2)
	s inParam("itemDescripts")=$p(QryItems,$C(2),3)
	s inParam("itemTypes")=$p(QryItems,$C(2),4)
	s inParam("itemCreateT")=$p(QryItems,$C(2),5)
	s inParam("itemExps")=$p(QryItems,$C(2),6)
	s inParam("itemDataTypes")=$p(QryItems,$C(2),7)
	TSTART
	s ret=##class(DHCWL.BaseDataQuery.QryObj).Insert(.inParam,.outParam)
	if ret'="" {
		TROLLBACK
		w "{""msg"":"""_ret_""",""success"":""0""}"
		q
	}
	
	s ret=##class(DHCWL.BaseDataQuery.QryItem).Insert(.inParam,.outParam)
	if ret'="" {
		TROLLBACK
		w "{""msg"":"""_ret_""",""success"":""0""}"
	}
	
	TCOMMIT
	
	w "{""msg"":""操作成功"",""success"":""1""}"
	//w "{""msg"":""已存在相同的配置！请修改报表名称后再尝试保存。"",""success"":""0""}"
	q
SQLErr
	Set ret=$ZE
	w "{""msg"":"""_ret_""",""success"":""0""}"
	TROLLBACK
	q
}

/// Creator：      王峥
/// CreatDate：    2018-7
/// Description:：   获取所有qryObjItem表的字段
/// Table：       	qryObjItem
/// Input：            查询对象ID
/// Output：          QryItem所有字段
/// Return：         0
/// Others：        
ClassMethod GetQryItems(QryObjID) As %String
{
	s qryName="%DynamicQuery:SQL"  //固定写法
	
	s sql="SELECT ID,Code,Name,Descript,Type,CreateType,Exp,DataType "
	s sql=sql_"FROM DHCWL_BaseDataQuery.QryItem WHERE QryObjDr = "_QryObjID
	//上面是固定写法 
	//////////////////////////////////////////
	//w !,sql
	s start=0,end=0,page=1
	s jsonPro="ID,Code,Name,Descript,Type,CreateType,Exp,DataType"
	s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)

	w json.GetHead()
	d{
		s obj=json.Next()
		w obj
	}while(obj'="")
	i json.GetCount()=0 w "]}"
			
	q 0
}

/// Creator：      王峥
/// CreatDate：    2018-7
/// Description:：   获取所有qryObjItem表的字段
/// Table：       	qryObjItem
/// Input：            查询对象ID
/// Output：          QryItem所有字段
/// Return：         0
/// Others：        
ClassMethod UpdateQryItem(itemData As %String) As %String
{
	Set $ZT="SQLErr"
	//rowData.ID+"^"+rowData.Name+"^"+rowData.Descript
	s inParam("ID")=$p(itemData,"^",1) 
	s inParam("Name")=$p(itemData,"^",2) 
	s inParam("Descript")=$p(itemData,"^",3) 

	s ret=##class(DHCWL.BaseDataQuery.QryItem).Update(.inParam,.outParam)
	if ret'="" {
		w "{""msg"":"""_ret_""",""success"":""0""}"
		q
	}
	

	
	w "{""msg"":""操作成功"",""success"":""1""}"
	//w "{""msg"":""已存在相同的配置！请修改报表名称后再尝试保存。"",""success"":""0""}"
	q
SQLErr
	Set ret=$ZE
	w "{""msg"":"""_ret_""",""success"":""0""}"
	q
}

ClassMethod GetTreeChildren(QryObjID As %String) As %String
{
	k ^||TEMPDHCWL("treeNode")
	
	if QryObjID="" q "{}"
	//q "{""data"":{""QryObjID"":"""_QryObjID_"""}}"
	//q "{""data"":[{""QryObjID"":"""_QryObjID_"""}]}"
	//q "[{""QryObjID"":"""_QryObjID_"""}]"
	//^||TEMPDHCWL("treeNode","dimChild",order,ItemID)=Name
	//^||TEMPDHCWL("treeNode","dimChild",order,ItemID,"property",order,propertyCode)=propertyName
	//^||TEMPDHCWL("treeNode","measureChild",order,ItemID)=Name
	s qryObj=##class(DHCWL.BaseDataQuery.QryObj).GetById(QryObjID)
	s lstDim=qryObj.GetItems("维度")
	s lstMeasure=qryObj.GetItems("度量")
	s ds=qryObj.DataSrcDr	//数据源
	s lstCnt=lstDim.Count()
	s ID=""
	
	s dimNodeStr=""
	
	f pos=1:1:lstCnt {
	//f pos=1:1:30 {
		s Code=lstDim.GetAt(pos).Code
		s Name=lstDim.GetAt(pos).Name
		if Name="" s Name=Code
		S Type="维度"
		s ID=lstDim.GetAt(pos).%Id()
		s ^||TEMPDHCWL("treeNode","dimChild",pos,ID)=Code_"^"_Name
		////{""text"":""维度"",""id"":""dimChild"",""state"":""closed""}
		if dimNodeStr'="" s dimNodeStr=dimNodeStr_","
		s dimNodeStr=dimNodeStr_"{""text"":"""_Name_""",""id"":"""_ID_""",""attributes"":{""code"":"""_Code_"""}"
		
		s lstPro=ds.GetPropertys(Code)
		s lstProCnt=lstPro.Count()
		if lstProCnt>0 {
			s dimNodeStr=dimNodeStr_",""state"":""closed"",""children"":["
			f proInx=1:1:lstProCnt {
				if 0 {	//取主题维度属性
					s dimProObj=lstPro.GetAt(proInx)
					s proCode=dimProObj.Code
					s proName=dimProObj.Name
					if proName="" s proName=proCode
					s proID=dimProObj.%Id()
				}else{
					s dimProObj=lstPro.GetAt(proInx)
					s proCode=dimProObj.GetValue("Code")
					s proName=dimProObj.GetValue("Name")
					if proName="" s proName=proCode
					s proID=dimProObj.GetValue("ID")				
				}
				
				s ^||TEMPDHCWL("treeNode","dimChild",pos,ID,"property",proInx)=proCode_"^"_proName_"^"_proID
				s dimNodeStr=dimNodeStr_"{""text"":"""_proName_""",""id"":"""_proID_""",""attributes"":{""code"":"""_proCode_"""}}"
				if proInx=lstProCnt s dimNodeStr=dimNodeStr_"]"
				else  s dimNodeStr=dimNodeStr_","
			}			
			
		}else{
		}
	
		s dimNodeStr=dimNodeStr_"}"	
	}	

	s measureNodeStr=""
	s lstCnt=lstMeasure.Count()

	f pos=1:1:lstCnt {
	//f pos=1:1:2 {
		s Code=lstMeasure.GetAt(pos).Code
		s Name=lstMeasure.GetAt(pos).Name
		if Name="" s Name=Code
		S Type="度量"
		s ID=lstMeasure.GetAt(pos).%Id()
		s ^||TEMPDHCWL("treeNode","measureChild",pos,ID)=Code_"^"_Name
		if measureNodeStr'="" s measureNodeStr=measureNodeStr_","
		s measureNodeStr=measureNodeStr_"{""text"":"""_Name_""",""id"":"""_ID_""",""attributes"":{""code"":"""_Code_"""}}"
		
	}
	
	s nodeStr=""
	
	if dimNodeStr'="" {
		//{""text"":""维度"",""id"":""dimChild"",""state"":""closed""}
		s nodeStr="{""text"":""维度"",""id"":""dimChild"",""state"":""closed"",""children"":["_dimNodeStr_"]}"
	}
	
	if nodeStr'="" s nodeStr=nodeStr_","
	if measureNodeStr'="" {
		//{""text"":""维度"",""id"":""dimChild"",""state"":""closed""}
		s nodeStr=nodeStr_"{""text"":""度量"",""id"":""measureChild"",""state"":""closed"",""children"":["_measureNodeStr_"]}"
	}	
	
	s nodeStr="["_nodeStr_"]"
	/*
	f nodeType="dimChild","measureChild" {
		s pos="" 
		f {
			s pos=$o(^||TEMPDHCWL("treeNode",nodeType,pos))
			q:pos=""
			s ID=""
			f {
				s ID=$o(^||TEMPDHCWL("treeNode",nodeType,pos,ID))
				q:ID=""
				s Code=$p(^||TEMPDHCWL("treeNode",nodeType,pos,ID),"^",1)
				s Name=$p(^||TEMPDHCWL("treeNode",nodeType,pos,ID),"^",2)
				if $d(^||TEMPDHCWL("treeNode",nodeType,pos,ID,"property")) {
					
					
				}
			}	
		}
	}
	
	
	
	
	
	zw ^||TEMPDHCWL("treeNode")
	*/
	
	/*
	
	//{""text"":""维度"",""id"":""dimChild"",""state"":""closed""}
	s qryName="%DynamicQuery:SQL"  //固定写法
	
	if nodeID="dimChild" {
		s sql="SELECT Name As text,ID As id,'closed' As state FROM DHCWL_BaseDataQuery.QryItem where Type='维度' and QryObjDr="_QryObjID
	}elseif nodeID="measureChild" {
		s sql="SELECT Name As text,ID As id,'open' As state FROM DHCWL_BaseDataQuery.QryItem where Type='度量' and QryObjDr="_QryObjID
	} 
	//上面是固定写法 
	//////////////////////////////////////////
	s start=0,end=0,page=1

	s jsonPro="text,id,state"
	
	s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)

	w json.GetJsonBody()
	*/
	q nodeStr
}

ClassMethod GetItemByDataType(qryObjID As %String, dataType As %String) As %String
{
	s qryObj=##class(DHCWL.BaseDataQuery.QryObj).GetById(qryObjID)
	s lstDim=qryObj.GetItems("维度")
	s lstMeasure=qryObj.GetItems("度量")
	s dsdr=qryObj.DataSrcDr	//数据源

	s sysDT=dsdr.GetDataTypeCodeByDesc(dataType)
	s lstCnt=lstDim.Count()
	s dataStr=""
	f pos=1:1:lstCnt {
		s Code=lstDim.GetAt(pos).Code
		s Name=lstDim.GetAt(pos).Name
		s CreateType=lstDim.GetAt(pos).CreateType
		s DT=lstDim.GetAt(pos).DataType
		if Name="" s Name=Code
		
		if CreateType="系统" && (sysDT=DT) {
			//value
			//text
			if dataStr'="" s dataStr=dataStr_","
			s dataStr=dataStr_"{""value"":"""_Code_""",""text"":"""_Name_"""}"

		}elseif CreateType="自定义" && (dataType=DT) {
			if dataStr'="" s dataStr=dataStr_","
			s dataStr=dataStr_"{""value"":"""_Code_""",""text"":"""_Name_"""}"
		}
	}
	
	s lstCnt=lstMeasure.Count()
	f pos=1:1:lstCnt {
		s Code=lstMeasure.GetAt(pos).Code
		s Name=lstMeasure.GetAt(pos).Name
		s CreateType=lstMeasure.GetAt(pos).CreateType
		s DT=lstMeasure.GetAt(pos).DataType
		
		if CreateType="系统" && (sysDT=DT) {
			if dataStr'="" s dataStr=dataStr_","
			s dataStr=dataStr_"{""value"":"""_Code_""",""text"":"""_Name_"""}"

		}elseif CreateType="自定义" && (dataType=DT) {
			if dataStr'="" s dataStr=dataStr_","
			s dataStr=dataStr_"{""value"":"""_Code_""",""text"":"""_Name_"""}"
		}
	}	
	
	s dataStr="["_dataStr_"]"
	q dataStr
}

ClassMethod InsertRpt(colStr As %String, filterStr As %String, orderStr As %String, querycondStr As %String, rowStr As %String, crossStr As %String, saveType As %String, code As %String, name As %String, descript As %String, qryObjID As %String, showType As %String, creator As %String, businessType As %String, dateItemCode As %String) As %String
{
	//1、校验过滤串
	s qryObj=##class(DHCWL.BaseDataQuery.QryObj).GetById(qryObjID)
		
	if filterStr'="" && (qryObj.DataSrcDr.Type="主题") {
		s ret=qryObj.DataSrcDr.CheckFilterStr(filterStr)
		if ret'="" {
			s ret="过滤配置是错误的！"
			w "{""msg"":"""_ret_""",""success"":""0""}"
			q ""
		}
	}

		
	
	Set $ZT="SQLErr"

	s inParam("colStr")=colStr
	s inParam("filterStr")=filterStr
	s inParam("orderStr")=orderStr
	s inParam("querycondStr")=querycondStr
	s inParam("saveType")=saveType
	s inParam("rptCode")=code
	s inParam("rptName")=name
	s inParam("QryObjID")=qryObjID
	s inParam("showType")=showType
	s inParam("creator")=creator
	s inParam("dateItemCode")=dateItemCode
	s inParam("businessType")=businessType
	s inParam("rptDesc")=descript	
	s inParam("rowStr")=rowStr
	s inParam("crossStr")=crossStr
	TSTART
	
	if saveType="saveAs" {		//另存
		//插入
		s ret=##class(DHCWL.BaseDataQuery.Rpt).Insert(.inParam,.outParam)
		if ret'="" {
			TROLLBACK
			w "{""msg"":"""_ret_""",""success"":""0""}"
			q
		}
	}elseif saveType="save" {	//保存
		s exist=##class(DHCWL.BaseDataQuery.Rpt).GetByCode(inParam("rptCode"))
		if $ISOBJECT(exist) {
			s inParam("ROWID")=exist.%Id() 
			//删除报表项
			s ret=##class(DHCWL.BaseDataQuery.RptItem).DelByRptID(inParam("ROWID"))
			if ret'="" {
				w "{""msg"":"""_ret_""",""success"":""0""}"
				TROLLBACK
				q
			}
			//更新主表
			s ret=##class(DHCWL.BaseDataQuery.Rpt).Update(.inParam,.outParam)
			if ret'="" {
				w "{""msg"":"""_ret_""",""success"":""0""}"
				TROLLBACK
				q
			}
			
		}else{
			w "{""msg"":"""_"更新的报表不存在"_""",""success"":""0""}"
			TROLLBACK

			q	
		}
	}
	/*elseif saveType="preview" {	//预览
		s exist=##class(DHCWL.BaseDataQuery.Rpt).GetByCode(inParam("rptCode"))
		if $ISOBJECT(exist) {
			s inParam("ROWID")=exist.%Id() 
			//删除报表项
			s ret=##class(DHCWL.BaseDataQuery.RptItem).DelByRptID(inParam("ROWID"))
			if ret'="" {
				w "{""msg"":"""_ret_""",""success"":""0""}"
				TROLLBACK
				q
			}
			//更新主表
			s ret=##class(DHCWL.BaseDataQuery.Rpt).Update(.inParam,.outParam)
			if ret'="" {
				w "{""msg"":"""_ret_""",""success"":""0""}"
				TROLLBACK
				q
			}			
		}else{
			s ret=##class(DHCWL.BaseDataQuery.Rpt).Insert(.inParam,.outParam)
			if ret'="" {
				TROLLBACK
				w "{""msg"":"""_ret_""",""success"":""0""}"
				q
			}

		}
	}
	*/
	
	
	//插入报表项
	s ret=##class(DHCWL.BaseDataQuery.RptItem).Insert(.inParam,.outParam)
	if ret'="" {
		TROLLBACK
		w "{""msg"":"""_ret_""",""success"":""0""}"
	}
	
	TCOMMIT
	
	///w "{""msg"":""操作成功"",""success"":""1,rptObj:""}"
	w "{""msg"":""操作成功"",""success"":""1"",""rptCode"":"""_code_""",""rptName"":"""_name_""",""rptId"":"""_inParam("ROWID")_"""}"
	q
SQLErr
	Set ret=$ZE
	w "{""msg"":"""_ret_""",""success"":""0""}"
	TROLLBACK
	q
}

ClassMethod GetRptIdByCode(rptCode) As %String
{
	
	s ret=##class(DHCWL.BaseDataQuery.Rpt).GetByCode(rptCode)
	w "{""ID"":"""_ret_""",""success"":""1""}"
	q ""
}

ClassMethod GetRptCfg(searchV As %String, creator As %String, page As %Integer, rows As %Integer)
{
		s start=((page-1)*rows)
		s limit=rows
		s qryName="%DynamicQuery:SQL"  //固定写法
		s end=start+limit
		s start=start+1

		//上面是固定写法 
		//////////////////////////////////////////

		s sql="SELECT * FROM (SELECT ID,Code,Name,Descript,BusinessType,DateItemDr->name as DateItem ,ID||Code||Name||Descript||ShowType||BusinessType||DateItemDr->name AS f1  FROM DHCWL_BaseDataQuery.Rpt "
		s sql=sql_"WHERE IsActive=1 AND ShowType='row' and Creator="_creator_")"
		
		if searchV'="" s sql=sql_"where f1 LIKE '%"_searchV_"%'"
		
		//w !,sql
		s jsonPro="ID,Code,Name,Descript,BusinessType,DateItem"
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
		
		w json.GetHead()
		d{
			s obj=json.Next()
			w obj
		}while(obj'="")
		
		i json.GetCount()=0 w "]}"
}

ClassMethod GetRptCfgData(rptID As %String) As %String
{
	s rptObj=##class(DHCWL.BaseDataQuery.Rpt).GetById(rptID)
	///1、查询对象
	if 0 {
		s qryObj=rptObj.QryObjDr
		s qryJSon=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByObject(qryObj)
	}else {
	///
		s qryName="%DynamicQuery:SQL"  //固定写法
		s sql="SELECT ID,Code,DataSrcDr->Type As DSType,Descript,Name FROM DHCWL_BaseDataQuery.Qryobj WHERE ID = "_rptObj.QryObjDr.%Id()
			//上面是固定写法 
		//////////////////////////////////////////
		s start=0,end=0,page=1
		s jsonPro="ID,Code,DSType,Descript,Name"
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
		s qryJSon=json.GetJsonBody()
	}
	
	///2、统计项
	if 0 {
		s colJson=""
		s list=rptObj.GetItemsByType("col")
		s cnt=list.Count() 
		f i=1:1:cnt {
			s obj=list.GetAt(i)	
			s JSon=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByObject(obj)
			if colJson'="" s colJson=colJson_","
			s colJson=colJson_JSon
		}
		s colJson="["_colJson_"]"
	}else{
		s qryName="%DynamicQuery:SQL"  //固定写法
		s sql="SELECT t1.ID,t1.Code,t1.Name,t3.Type  AS QryItemType ,t2.Format "
		s sql=sql_"FROM DHCWL_BaseDataQuery.RptItem t1 LEFT JOIN DHCWL_BaseDataQuery.RItemFm t2 ON t1.ID=t2.ItemDr, "
		s sql=sql_"DHCWL_BaseDataQuery.QryItem t3  "
		s sql=sql_"WHERE t1.RptDr->QryObjDr=t3.QryObjDr  "
		s sql=sql_"AND $PIECE(t1.Code,'->',1)=t3.Code  "
		s sql=sql_"and t1.Type='col'  "
		s sql=sql_"and t1.RptDr= "_rptID
			//上面是固定写法 
		//////////////////////////////////////////
		s start=0,end=0,page=1
		s jsonPro="ID,Code,Name,QryItemType,Format"
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
		s colJson=json.GetJsonBody()		
	}
	
	
	///3、过滤项
	s filterJson=""
	s list=rptObj.GetItemsByType("filter")
	s cnt=list.Count() 
	f i=1:1:cnt {
		s obj=list.GetAt(i)	
		s JSon=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByObject(obj)
		if filterJson'="" s filterJson=filterJson_","
		s filterJson=filterJson_JSon
	}
	s filterJson="["_filterJson_"]"	
	
	///4、排序项
	s orderJson=""
	s list=rptObj.GetItemsByType("order")
	s cnt=list.Count() 
	f i=1:1:cnt {
		s obj=list.GetAt(i)	
		s JSon=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByObject(obj)
		if orderJson'="" s orderJson=orderJson_","
		s orderJson=orderJson_JSon
	}
	s orderJson="["_orderJson_"]"		


	///5、统计条件项
	s queryconfJson=""
	s list=rptObj.GetItemsByType("queryconf")
	s cnt=list.Count() 
	f i=1:1:cnt {
		s obj=list.GetAt(i)	
		s JSon=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByObject(obj)
		if queryconfJson'="" s queryconfJson=queryconfJson_","
		s queryconfJson=queryconfJson_JSon
	}
	s queryconfJson="["_queryconfJson_"]"	
	
	///6、报表
	s qryName="%DynamicQuery:SQL"  //固定写法
	s sql="SELECT Code,Name,ID,DateItemDr->Code AS DateItemCode FROM DHCWL_BaseDataQuery.Rpt where ID="_rptID
		//上面是固定写法 
	//////////////////////////////////////////
	s start=0,end=0,page=1
	s jsonPro="Code,Name,ID,DateItemCode"
	s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
	s rptJson=json.GetJsonBody()
	
	///7、报表行
	s rowJson=""
	s list=rptObj.GetItemsByType("row")
	s cnt=list.Count() 
	f i=1:1:cnt {
		s obj=list.GetAt(i)	
		s JSon=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByObject(obj)
		if rowJson'="" s rowJson=rowJson_","
		s rowJson=rowJson_JSon
	}
	s rowJson="["_rowJson_"]"
	
	///8、交叉汇总
	if 0 {
		s crossJson=""
		s list=rptObj.GetItemsByType("cross")
		s cnt=list.Count() 
		f i=1:1:cnt {
			s obj=list.GetAt(i)	
			s JSon=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByObject(obj)
			if crossJson'="" s crossJson=crossJson_","
			s crossJson=crossJson_JSon
		}
		s crossJson="["_crossJson_"]"
	}else{
		s qryName="%DynamicQuery:SQL"  //固定写法
		s sql="SELECT Code,Descript,Exp,Name,RptDr,Type,t2.Format FROM DHCWL_BaseDataQuery.RptItem t1 "
		s sql=sql_"LEFT JOIN DHCWL_BaseDataQuery.RItemFm t2 ON t1.ID=t2.ItemDr  WHERE Type='cross' AND RptDr= "_rptID
			//上面是固定写法 
		//////////////////////////////////////////
		s start=0,end=0,page=1
		s jsonPro="Code,Descript,Exp,Name,RptDr,Type,Format"
		s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
		s crossJson=json.GetJsonBody()
		
	} 
		
	w "{""success"":""1"",""qryData"":"_qryJSon_",""colData"":"_colJson_",""filterData"":"_filterJson_",""orderData"":"_orderJson_",""queryconfData"":"_queryconfJson_",""rptData"":"_rptJson_",""rowData"":"_rowJson_",""crossData"":"_crossJson_"}"
	
	//w "{""success"":""1"",""qryData"":"_qryJSon_",""colData"":"_colJson_",""filterData"":"_filterJson_",""orderData"":"_orderJson_",""queryconfData"":"_queryconfJson_",""rptData"":"_rptJson_"}"
	
	q ""
}

/// ##class(web.DHCWL.V1.BKCDQry.BaseDataServ).GetAggItem(5)
ClassMethod GetSysMetrics(qryObjID As %String) As %String
{
	//SELECT Code,Name FROM DHCWL_BaseDataQuery.QryItem WHERE CreateType='系统' AND QryObjDr="_qryObjID
	s qryName="%DynamicQuery:SQL"  //固定写法
	s sql="SELECT Code,IFNULL(Name,Code,Name) AS Name FROM DHCWL_BaseDataQuery.QryItem WHERE CreateType='系统' and Type='度量'  AND QryObjDr="_qryObjID
		//上面是固定写法 
	//////////////////////////////////////////
	s start=0,end=0,page=1
	s jsonPro="Code,Name"
	s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
	s sysMetrStr=json.GetJsonBody()
	
	q sysMetrStr
}

ClassMethod saveCustomMetrics(code As %String, name As %String, descript As %String, exp As %String, qryObjID As %String, itemID As %String) As %String
{
	s inParam("Code")=code
	s inParam("Name")=name
	s inParam("Descript")=descript
	s inParam("Exp")=exp
	s inParam("ROWID")=qryObjID
	s inParam("ItemID")=itemID
	if itemID="" {
		s ret=##class(DHCWL.BaseDataQuery.QryItem).InsertCustomMetrics(.inParam,.outParam)
	}else{
		s ret=##class(DHCWL.BaseDataQuery.QryItem).UpdateCustomMetrics(.inParam,.outParam)
	}
	if ret'="" {
		w "{""msg"":"""_ret_""",""success"":""0""}"
		q ""
	}
	w "{""msg"":""操作成功"",""success"":""1""}"
	q ""
}

ClassMethod DelQryItem(itemID)
{
	s ret=""
	//删除之前先判断该统计项是否被使用
	s ret=##class(DHCWL.BaseDataQuery.QryItem).BeUsedByRpt(itemID)
	if ret'="" {
		s ret="该统计项被下面报表使用[ "_ret_" ],请先在这些报表中删除该统计项后，执行删除操作！"
		w "{""msg"":"""_ret_""",""success"":""0""}"
		q ""		
	}
		
	s sc=##class(DHCWL.BaseDataQuery.QryItem).%DeleteId(itemID)

	If $$$ISERR(sc) {
		s ret="新建报表对象失败:"_$System.Status.GetErrorText(sc)
		q ret
 	}
 	
	if ret'="" {
		w "{""msg"":"""_ret_""",""success"":""0""}"
		q ""
	} 	
	w "{""msg"":""操作成功"",""success"":""1""}"
	q ""
}

ClassMethod GetBdqCfgList(searchV As %String, page As %Integer, rows As %Integer) As %String
{
	if 1 {
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
	s sql="SELECT ID,Code,Name, Descript, BusinessType, SSUSR_Name,QryObjDr->Code AS QryCode,QryObjDr->Name AS QryName,showType,QryObjDr->DataSrcDr->Type As DSType"
	s sql=sql_" FROM DHCWL_BaseDataQuery.Rpt t1,ss_user t2 WHERE t1.Creator=t2.SSUSR_RowId"	
	if searchV'="" s sql=sql_" AND (Code LIKE '%"_searchV_"%' OR Name LIKE '%"_searchV_"%' OR Descript LIKE '%"_searchV_"%' OR BusinessType LIKE '%"_searchV_"%' OR  SSUSR_Name LIKE '%"_searchV_"%' OR  QryObjDr->Code LIKE '%"_searchV_"%' OR  QryObjDr->Name LIKE '%"_searchV_"%' )" 



	
	//w !,sql
	s jsonPro="ID,Code,Name,Descript,BusinessType,SSUSR_Name,QryCode,QryName,ShowType,DSType"
	s json=##class(web.DHCWL.V1.CommonUtil.JsonUtil).GetJsonByQry(qryName,"",sql,start,end,jsonPro,page)
	
	w json.GetHead()
	d{
		s obj=json.Next()
		w obj
	}while(obj'="")
	
	i json.GetCount()=0 w "]}"
}

ClassMethod DelRpt(rptID As %String) As %String
{
	if $d(^DHCWL.PerMis.RGMapI("InxRG","bdq",rptID)) {
		s ret="该报表已被关联了权限，请先在“权限管理>报表-组配置”配置中删除关联后再操作。"
		w "{""msg"":"""_ret_""",""success"":""0""}"
		q ""		
		
	}
	
	TSTART
	s ret=##class(DHCWL.BaseDataQuery.Rpt).DelRpt(rptID)
	if ret'="" {
		TROLLBACK
		w "{""msg"":"""_ret_""",""success"":""0""}"
		q ""
		
		
	}
	s ret=##class(DHCWL.BaseDataQuery.RptItem).DelByRptID(rptID)
	if ret'="" {
		TROLLBACK
		w "{""msg"":"""_ret_""",""success"":""0""}"
		q ""
	}	
	TCOMMIT
	w "{""msg"":""操作成功"",""success"":""1""}"
	q ""
}

ClassMethod DelQryObj(qryObjID As %String) As %String
{
	//1、判断查询对象是否被使用，如果有报表使用就退出
	//2、删除查询对象
	s ret=""
	if $d(^DHCWL.BaseDataQuery.RptI("InxQry",qryObjID)) {
		s ret="已有报表使用了该查询对象，请先删除使用了该查询对象的报表再删除查询对象！"
		w "{""msg"":"""_ret_""",""success"":""0""}"
		q ""	
	}else{
		TSTART
		s ret=##class(DHCWL.BaseDataQuery.QryObj).%DeleteId(qryObjID)
		
		if $$$ISOK(ret) {
			s ret=##class(DHCWL.BaseDataQuery.QryItem).DelByQryID(qryObjID)
			if ret="" {
				TCOMMIT
				w "{""msg"":"""_ret_""",""success"":""1""}"
			}else{
				TROLLBACK
				w "{""msg"":"""_ret_""",""success"":""0""}"
				q ""	
			}
			
		}else{
			TROLLBACK
			s ret="删除查询对象失败"
			w "{""msg"":"""_ret_""",""success"":""0""}"
			q ""	
		}
	}
}

/// s ret=##class(web.DHCWL.V1.BKCDQry.BaseDtaServ).CheckFilterStr("ID:0^Code:WorkLoad_ARPBL_DR^logical:^Name:帐单号^Relational:=^V1:1^V2:",10)
ClassMethod CheckFilterStr(filterStr As %String, qryObjID As %String)
{
	s qryObj=##class(DHCWL.BaseDataQuery.QryObj).GetById(qryObjID)
	s ret=qryObj.DataSrcDr.CheckFilterStr(filterStr)
	if ret="" {
		
			w "{""msg"":"""_ret_""",""success"":""1""}"
	}else{
		s ret="过滤配置是错误的！"
			w "{""msg"":"""_ret_""",""success"":""0""}"
	}
	q ""
}

ClassMethod GetShowTypeByRptID(rptID As %String)
{
	s rptObj=##class(DHCWL.BaseDataQuery.Rpt).GetById(rptID)
	s showType=rptObj.ShowType
	
	w "{""ShowType"":"""_showType_""",""success"":""1""}"
	q ""
}

ClassMethod SaveRecentRptList(rptID As %String, rptTool As %String, userID As %String) As %String
{
	s ret=""
	if rptTool="CommonDataQuery" {
		s rptTool="cdq"
	}elseif rptTool="BaseDataQuery" {
		s rptTool="bdq"
	}elseif rptTool="KpiDataQuery" {	//指标数据查询和基础数据查询合并了。
		s rptTool="bdq"
	}
	s inParam("RptTool")=rptTool
	s inParam("UserID")=userID
	s inParam("RptID")=rptID
	if $d(^DHCWL.BaseDataQuery.RecentLTI("InxMain",rptTool,userID,rptID)) {
		s ret=##class(DHCWL.BaseDataQuery.RecentLT).Update(.inParam,.outParam)
	}else{
		s ret=##class(DHCWL.BaseDataQuery.RecentLT).Insert(.inParam,.outParam)
	}
	
	if ret="" {
			w "{""msg"":"""_ret_""",""success"":""1""}"
	}else{
			w "{""msg"":"""_ret_""",""success"":""0""}"
	}
	q ""
}

/// i am a test
/// d ##class(%ResultSet).RunQuery("web.DHCWL.V1.BKCDQry.BaseDataServ","QryAgesex")
Query QryAgesex(startDate As %String, endDate As %String) As %Query(ROWSPEC = "ageScope:%String,sex:%String,grNum:%Integer")
{
}

ClassMethod QryAgesexExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	

	s Data=$lb("0-10岁","男",1)
	Do OutRow
	s Data=$lb("11-18岁","男",2)
	Do OutRow	
	s Data=$lb("19-28岁","男",3)
	Do OutRow		
	s Data=$lb("29-38岁","男",4)
	Do OutRow		
	s Data=$lb("39-48岁","男",5)
	Do OutRow
	s Data=$lb("49-58岁","男",6)
	Do OutRow	
	s Data=$lb("59-68岁","男",7)
	Do OutRow		
	s Data=$lb("69-78岁","男",8)
	Do OutRow
	s Data=$lb("0-10岁","女",10)
	Do OutRow
	s Data=$lb("11-18岁","女",20)
	Do OutRow	
	s Data=$lb("19-28岁","女",30)
	Do OutRow		
	s Data=$lb("29-38岁","女",40)
	Do OutRow		
	s Data=$lb("39-480岁","女",50)
	Do OutRow
	s Data=$lb("49-58岁","女",60)
	Do OutRow	
	s Data=$lb("59-68岁","女",70)
	Do OutRow		
	s Data=$lb("69-78岁","女",80)
	Do OutRow
		
	Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QryAgesexClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAgesexExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAgesexFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAgesexExecute ]
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

Query QryDiagnosis(startDate As %String, endDate As %String) As %Query(ROWSPEC = "diagnosedResult:%String,grNum:%Integer")
{
}

ClassMethod QryDiagnosisExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	
	

	s Data=$lb("感染前健康",1)
	Do OutRow
	s Data=$lb("肺部并发症",2)
	Do OutRow	
	s Data=$lb("糖尿病并发症",3)
	Do OutRow		
	s Data=$lb("肾病并发症",4)
	Do OutRow		
	s Data=$lb("二种并发症",5)
	Do OutRow
	s Data=$lb("三种并发症",6)
	Do OutRow	
	s Data=$lb("多种并发症",7)
	Do OutRow		
			
	Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QryDiagnosisClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiagnosisExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDiagnosisFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiagnosisExecute ]
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

Query QryDiseaselevel(startDate As %String, endDate As %String) As %Query(ROWSPEC = "qzNum:%Integer,zzNum:%Integer,bwNum:%Integer,swNum:%Integer")
{
}

ClassMethod QryDiseaselevelExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Data=$lb(1,2,3,4)
	Do OutRow
				
			
	Set qHandle=$lb(0,repid,0)
    k ^TEMPDHCWL($j)
 	Quit $$$OK
OutRow
    //s LocDesc=$p(^CTLOC(locdr),"^",2)
    s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod QryDiseaselevelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDiseaselevelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryDiseaselevelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDiseaselevelExecute ]
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

}
