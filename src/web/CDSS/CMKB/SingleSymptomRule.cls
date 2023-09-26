/// 名称:推荐疑似疾病中单一规则维护方法类
/// 描述:包含增删改查功能
/// 编写者:基础平台组 - xuwenhu
/// 编写日期:2021-06-02
Class web.CDSS.CMKB.SingleSymptomRule Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：xuwenhu		
/// CreatDate: 2021-06-02
/// Description：查询数据 
/// Table:CT.WDT.CDSS.SingleSymptomRule 
/// Input:rulecode-规则编码, symptom-症状名称, minage-年龄最小值, maxage-年龄最大值, disease-疾病描述
/// Output:ID,RuleCode,RuleTotal,RuleSymptom,MinAge,MinAgeOpera,MaxAge,MaxAgeOpera,Gender,RuleDiseases,MinAgeUnit,MaxAgeUnit
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.SingleSymptomRule","GetList","","","","","")
Query GetList(rowid As %String, rulecode As %String, symptom As %String, minage As %String, maxage As %String, disease As %String) As %Query(ROWSPEC = "ID,RuleCode,RuleTotal,RuleSymptom,MinAge,MinAgeOpera,MaxAge,MaxAgeOpera,Gender,RuleDiseases,MinAgeUnit,MaxAgeUnit")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, rulecode As %String, symptom As %String, minage As %String, maxage As %String, disease As %String) As %Status
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
        s RuleCode=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),2) 		//规则编码
        s RuleTotal=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),3) 		//一条规则共几行
       	s i=1
        s RuleSymptom=""
        for
        {
       		s RuleSymptomStr=$lg($lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),4),i) 	//症状名称
       		q:RuleSymptomStr=""
       		if (i>1)
       		{ 
       			s RuleSymptom=RuleSymptom_","_RuleSymptomStr
       		}
       		else
       		{ 
       			s RuleSymptom=RuleSymptomStr
       		}
       		s i=i+1     		 
        }
        s MinAge=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),5) 			//年龄最小值
        s MinAgeOpera=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),6) 	//最小值操作符
        s MaxAge=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),7) 			//年龄最大值
        s MaxAgeOpera=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),8) 	//最大值操作符
		s Gender=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),9) 			//性别
		s j=1
		s RuleDiseases=""
		for
		{
			s Disease=$lg($lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),10),j) 	//疾病列表
       		q:Disease=""
       		if (j>1)
       		{ 
       			s RuleDiseases=RuleDiseases_","_$lg($g(^CT.WDT.CDSS.DiseaseDictD(Disease)),3)
       		}
       		else
       		{ 
       			s RuleDiseases=$lg($g(^CT.WDT.CDSS.DiseaseDictD(Disease)),3)
       		}
       		s j=j+1	
		}
		s MinAgeUnit=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),11) 	//年龄最小值单位
		s MaxAgeUnit=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),12) 	//年龄最大值单位
        d OutputRow
    }
    else
    {
		s:rulecode'="" rulecode=$ZCONVERT(rulecode,"U") //转换成大写
		s:symptom'="" symptom=$ZCONVERT(symptom,"U") //转换成大写
		s:disease'="" disease=$ZCONVERT(disease,"U") //转换成大写
		
        s ID=0
        for 
        {
            s ID=$o(^CT.WDT.CDSS.SingleSymptomRuleD(ID))
			q:ID=""
		    s RuleCode=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),2) 		//规则编码
		    continue:((rulecode'="")&&($ZCONVERT(RuleCode,"U")'[rulecode))
	        s RuleTotal=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),3) 		//一条规则共几行
	        s i=1
	        s RuleSymptom=""
	        for
	        {
	       		s RuleSymptomStr=$lg($lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),4),i) 	//症状名称
	       		q:RuleSymptomStr=""
	       		if (i>1)
	       		{ 
	       			s RuleSymptom=RuleSymptom_","_RuleSymptomStr
	       		}
	       		else
	       		{ 
	       			s RuleSymptom=RuleSymptomStr
	       		}
	       		s i=i+1     		 
	        }
	        continue:((symptom'="")&&($ZCONVERT(RuleSymptom,"U")'[symptom))
	        s MinAge=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),5) 			//年龄最小值
	        continue:((minage'="")&&(MinAge<minage))
	        continue:((maxage'="")&&(MinAge>maxage))
	        s MinAgeOpera=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),6) 	//最小值操作符
	        s MaxAge=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),7) 			//年龄最大值
	        //continue:((maxage'="")&&(MaxAge>maxage))
	        //continue:((minage'="")&&(MaxAge<minage))
	        s MaxAgeOpera=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),8) 	//最大值操作符
			s Gender=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),9) 			//性别
			s j=1
			s RuleDiseases=""
			for
			{
				s Disease=$lg($lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),10),j) 	//疾病列表
	       		q:Disease=""
	       		if (j>1)
	       		{ 
	       			s RuleDiseases=RuleDiseases_","_$lg($g(^CT.WDT.CDSS.DiseaseDictD(Disease)),3)
	       		}
	       		else
	       		{ 
	       			s RuleDiseases=$lg($g(^CT.WDT.CDSS.DiseaseDictD(Disease)),3)
	       		}
	       		s j=j+1	
			}
			continue:((disease'="")&&($ZCONVERT(RuleDiseases,"U")'[disease))
			s MinAgeUnit=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),11) 	//年龄最小值单位
			s MaxAgeUnit=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),12) 	//年龄最大值单位
        	
			d OutputRow
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,RuleCode,RuleTotal,RuleSymptom,MinAge,MinAgeOpera,MaxAge,MaxAgeOpera,Gender,RuleDiseases,MinAgeUnit,MaxAgeUnit)
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

/// Creator：xuwenhu
/// CreatDate:2021-06-02
/// Description：数据重复验证方法
/// Table:CT.WDT.CDSS.SingleSymptomRule
/// Input：id,desc(描述)
/// Return："1"(数据重复),"0"(数据不重复)
/// other:w ##class(web.CDSS.CMKB.SingleSymptomRule).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, total As %String) As %String
{
	s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
	s flag="",flagc=""
	s:code'="" flagc=$d(^CT.WDT.CDSS.SingleSymptomRuleI("CodeIndex",code,total))
	if (id="") //如果为空，增加时的重复判断
	{
		if (flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	else //如果不为空，修改时的重复判断
	{
		s idc=""
		s:code'="" idc=$o(^CT.WDT.CDSS.SingleSymptomRuleI("CodeIndex",code,total,0))
		if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:xuwenhu
/// CreatDate:2021-06-02
/// Description：保存单双症状规则表数据
/// Table:CT.WDT.CDSS.SingleSymptomRule
/// Input：web.CDSSEntity.CMKB.SingleSymptomRule 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.CDSS.CMKB.SingleSymptomRule).SaveData(eobj)
ClassMethod SaveData(eobj As web.CDSSEntity.CMKB.SingleSymptomRule) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..FormValidate(eobj.ID,$zstrip(eobj.RuleCode,"<>W"),eobj.RuleTotal)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.ID="")  //如果RowId未赋值则增加
            {
                s obj=##class(CT.WDT.CDSS.SingleSymptomRule).%New()                
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(CT.WDT.CDSS.SingleSymptomRule).%OpenId(eobj.ID) 				
                s bobj = ##class(web.CDSSEntity.CMKB.SingleSymptomRule).%New()
				s bobj.RuleCode=obj.RuleCode				//规则编码
				s bobj.RuleTotal =obj.RuleTotal				//一条规则共几行
				s bobj.RuleSymptom=obj.RuleSymptom			//症状名称
				s bobj.MinAge=obj.MinAge					//年龄最小值
				s bobj.MinAgeOpera=obj.MinAgeOpera			//最小值操作符
				s bobj.MaxAge=obj.MaxAge					//年龄最大值
                s bobj.MaxAgeOpera=obj.MaxAgeOpera			//最大值操作符
        		s bobj.Gender=obj.Gender					//性别
        		s bobj.RuleDiseases=obj.RuleDiseases		//疾病列表
        		s bobj.MinAgeUnit=obj.MinAgeUnit			//年龄最小值单位
        		s bobj.MaxAgeUnit=obj.MaxAgeUnit			//年龄最大值单位
            }
            Ts
           	s obj.RuleCode=eobj.RuleCode				//规则编码
			s obj.RuleTotal=eobj.RuleTotal				//一条规则共几行
			d obj.RuleSymptom.Clear()					//先清空在插入
			for i=1:1:$l(eobj.RuleSymptom,",")
			{
				s symptom=$p(eobj.RuleSymptom,",",i)
				d obj.RuleSymptom.InsertAt(symptom,i)
			}											//症状名称
			s obj.MinAge=eobj.MinAge					//年龄最小值
			s obj.MinAgeOpera=eobj.MinAgeOpera			//最小值操作符
			s obj.MaxAge=eobj.MaxAge					//年龄最大值
            s obj.MaxAgeOpera=eobj.MaxAgeOpera			//最大值操作符
    		s obj.Gender=eobj.Gender					//性别	
    		d obj.RuleDiseases.Clear()					//先清空在插入
    		for j=1:1:$l(eobj.RuleDiseases,",")			//疾病列表
			{
				s DiseaseName=$p(eobj.RuleDiseases,",",j)
				s DiseaseDR=$o(^CT.WDT.CDSS.DiseaseDictI("NameIndex"," "_DiseaseName,0))
				continue:(DiseaseDR="")
				d obj.RuleDiseases.Insert(DiseaseDR)
			}
    		s obj.MinAgeUnit=eobj.MinAgeUnit			//年龄最小值单位
    		s obj.MaxAgeUnit=eobj.MaxAgeUnit			//年龄最大值单位
			
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //保存日志
				d:eobj.ID="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.SingleSymptomRule","CT.WDT.CDSS.SingleSymptomRule","单双症状规则表",id,eobj.RuleCode,"A",eobj)
				d:eobj.ID'="" ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.SingleSymptomRule","CT.WDT.CDSS.SingleSymptomRule","单双症状规则表",eobj.ID,eobj.RuleCode,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("单双症状规则表","web.CDSS.CMKB.SingleSymptomRule","SaveData",eobj)
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
	s logid=##class(web.CDSS.Config.SysErrorLog).SaveLog("单双症状规则表","web.CDSS.CMKB.SingleSymptomRule","SaveData",eobj)
 	s ^ERRORLOGINFO(logid)=$ze 
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:xuwenhu
/// CreatDate:2021-06—02
/// Description：根据ID删除单双症状规则表的内容
/// Table:CT.WDT.CDSS.SingleSymptomRule
/// Input：id-单双症状规则表的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.CDSS.CMKB.SingleSymptomRule).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
	
    s result="" 
    s obj=##class(CT.WDT.CDSS.SingleSymptomRule).%OpenId(id)      
    s bobj = ##class(web.CDSSEntity.CMKB.SingleSymptomRule).%New()
    s bobj.ID=id
	s bobj.RuleCode=obj.RuleCode				//规则编码
	s bobj.RuleTotal =obj.RuleTotal				//一条规则共几行
	s bobj.RuleSymptom=obj.RuleSymptom			//症状名称
	s bobj.MinAge=obj.MinAge					//年龄最小值
	s bobj.MinAgeOpera=obj.MinAgeOpera			//最小值操作符
	s bobj.MaxAge=obj.MaxAge					//年龄最大值
    s bobj.MaxAgeOpera=obj.MaxAgeOpera			//最大值操作符
	s bobj.Gender=obj.Gender					//性别
	s bobj.RuleDiseases=obj.RuleDiseases		//疾病列表
	s bobj.MinAgeUnit=obj.MinAgeUnit			//年龄最小值单位
	s bobj.MaxAgeUnit=obj.MaxAgeUnit			//年龄最大值单位
	d obj.%Close()
    k obj
    Tstart
    s sc=##class(CT.WDT.CDSS.SingleSymptomRule).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CT_WDT_CDSS.SingleSymptomRule","CT.WDT.CDSS.SingleSymptomRule","单双症状规则表",id,bobj.ID,"D",bobj)
        d bobj.%Close()
           
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("单双症状规则表","web.CDSS.CMKB.SingleSymptomRule","DeleteData",bobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
     q result
}

/// Creator：xuwenhu 
/// CreatDate: 2021-06-02
/// Description：新增，修改时打开Form，根据ID查询
/// Table:CT.WDT.CDSS.SingleSymptomRule
/// Input：id
/// Return：json串 
/// Other: w ##class(web.CDSS.CMKB.SingleSymptomRule).OpenData(1)
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
	s pobj = ##class(CT.WDT.CDSS.SingleSymptomRule).%OpenId(id) 
	s eobj = ##class(web.CDSSEntity.CMKB.SingleSymptomRule).%New() 
	s eobj.ID = id
	s eobj.RuleCode=pobj.RuleCode				//规则编码
	s eobj.RuleTotal =pobj.RuleTotal			//一条规则共几行
	s RuleSymptomStr=""
	for i=1:1:pobj.RuleSymptom.Count()
	{
		if (RuleSymptomStr="")
		{
			s RuleSymptomStr=pobj.RuleSymptom.GetAt(i)
		}
		else
		{
			s RuleSymptomStr=RuleSymptomStr_","_pobj.RuleSymptom.GetAt(i)
		}
	}
	s eobj.RuleSymptom=RuleSymptomStr			//症状名称
	s eobj.MinAge=pobj.MinAge					//年龄最小值
	s eobj.MinAgeOpera=pobj.MinAgeOpera			//最小值操作符
	s eobj.MaxAge=pobj.MaxAge					//年龄最大值
    s eobj.MaxAgeOpera=pobj.MaxAgeOpera			//最大值操作符
	s eobj.Gender=pobj.Gender					//性别
	s DiseasesStr=""
	for i=1:1:pobj.RuleDiseases.Count()
	{
		if (DiseasesStr="")
		{
			s DiseasesStr=$lg($g(^CT.WDT.CDSS.DiseaseDictD(pobj.RuleDiseases.GetAt(i))),3)
		}
		else
		{
			s DiseasesStr=DiseasesStr_","_$lg($g(^CT.WDT.CDSS.DiseaseDictD(pobj.RuleDiseases.GetAt(i))),3)
		}
	}
	s eobj.RuleDiseases=DiseasesStr				//疾病列表
	s eobj.MinAgeUnit=pobj.MinAgeUnit			//年龄最小值单位
	s eobj.MaxAgeUnit=pobj.MaxAgeUnit			//年龄最大值单位
	
	kill pobj
	s str = eobj.JsonS()
	q str
}

/// Creator：xuwenhu		
/// CreatDate: 2021-06-02
/// Description：查询数据下拉框，JS调用 
/// Table:CT.WDT.CDSS.SingleSymptomRule 
/// Input:rowid-表ID,q-hisui下拉框查询参数
/// Output:ID,AssessResultCode,AssessResultDesc
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.SingleSymptomRule","GetDataForCmb1","")
Query GetDataForCmb1(rowid As %String, q As %String) As %Query(ROWSPEC = "ID,RuleCode,RuleTotal")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, q As %String) As %Status
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
        s RuleCode=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),2) 		//规则编码
        s RuleTotal=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),3) 		//一条规则共几行
        d OutputRow
    }
    else
    {
	   	s:q'="" q=$ZCONVERT(q,"U") //转换成大写 
        s ID=0
        for {
            s ID=$o(^CT.WDT.CDSS.SingleSymptomRuleD(ID))
            q:ID=""
	        s RuleCode=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),2) 		//规则编码
	        continue:((q'="")&&(q'=$ZCONVERT(RuleCode,"U")))
        	s RuleTotal=$lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(ID)),3) 		//一条规则共几行
			d OutputRow
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ID,RuleCode,RuleTotal)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator:xuwenhu
/// CreatDate:2021-06—02
/// Description：导入数据
/// Table:CT.WDT.CDSS.SingleSymptomRule
/// Input：path-txt文件路径
/// Return：success
/// Other:w ##class(web.CDSS.CMKB.SingleSymptomRule).ImportData("D:\Works\任务\智能分诊\yisizhenduan.txt")
ClassMethod ImportData(path As %String) As %String
{
	s readcount=0   	//读取总数
	s savecount=0		//导入成功总数
	s nosavecount=0 	//导入失败总数
	s incount=0			//已存在总数
	s file=##class(%File).%New(path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s RuleCode=..GetCode()
		s RuleSymptom=$p(str,"	",1)			//症状名称
		s RuleTotal=$l(RuleSymptom,"+")			//一条规则共几行
		s MinAge=$p(str,"	",2)				//年龄最小值
		s MinAgeUnit=$p(str,"	",3)			//年龄最小值单位
		s MinAgeOpera=$p(str,"	",4)			//最小值操作符
		s MaxAge=$p(str,"	",5)				//年龄最大值
		s MaxAgeUnit=$p(str,"	",6)			//年龄最大值单位
		s MaxAgeOpera=$p(str,"	",7)			//最大值操作符
		s Gender=$p(str,"	",8)				//性别
		s RuleDiseases=$p(str,"	",8)
		s RuleDiseases=$tr($p(str,"	",9),"["," ")		//疾病列表
		s RuleDiseases=$tr(RuleDiseases,"]"," ")
		
		//去除两端空白
		s RuleSymptom=$zstrip(RuleSymptom,"<>W")
		s MinAge=$zstrip(MinAge,"<>W")
		s MinAgeOpera=$zstrip(MinAgeOpera,"<>W")
		s MaxAge=$zstrip(MaxAge,"<>W")
		s MaxAgeOpera=$zstrip(MaxAgeOpera,"<>W")
		s Gender=$zstrip(Gender,"<>W")
		s RuleDiseases=$zstrip(RuleDiseases,"<>W")
		s MinAgeUnit=$zstrip(MinAgeUnit,"<>W")
		s MaxAgeUnit=$zstrip(MaxAgeUnit,"<>W")
		s readcount=readcount+1
		
		s RowID=$o(^CT.WDT.CDSS.SingleSymptomRuleI("CodeIndex",RuleCode,RuleTotal,0))
		if (RowID="")
		{
			s bobj = ##class(web.CDSSEntity.CMKB.SingleSymptomRule).%New()
			s bobj.ID = ""
			s bobj.RuleCode=RuleCode				//规则编码
			s bobj.RuleTotal=RuleTotal				//一条规则共几行
			s bobj.RuleSymptom=$tr(RuleSymptom,"+",",")			//症状名称
			s bobj.MinAge=MinAge					//年龄最小值
			s bobj.MinAgeOpera=MinAgeOpera			//最小值操作符
			s bobj.MaxAge=MaxAge					//年龄最大值
		    s bobj.MaxAgeOpera=MaxAgeOpera			//最大值操作符
			s bobj.Gender=Gender					//性别
			s bobj.RuleDiseases=RuleDiseases		//疾病列表
			s bobj.MinAgeUnit=MinAgeUnit			//年龄最小值单位
			s bobj.MaxAgeUnit=MaxAgeUnit			//年龄最大值单位
			
			s re=..SaveData(bobj)
			if (re["true")
			{
				s savecount=savecount+1
				
			}
			else
			{
				s nosavecount=nosavecount+1	
			}
				
		}
		else
		{
			s incount=incount+1
			continue	
		}
		
	}
	q "{success:'true',readcount:'"_readcount_"',savecount:'"_savecount_"',nosavecount:'"_nosavecount_"',incount:'"_incount_"'}"
}

/// Creator:xuwenhu
/// CreatDate:2021-06-02
/// Description:代码自动生成  
/// Input：
/// Return：code
/// Other:w ##class(web.CDSS.CMKB.SingleSymptomRule).GetCode()
ClassMethod GetCode() As %String
{
  	s Code=""
	s Code=$o(^CT.WDT.CDSS.SingleSymptomRuleD(""),-1)
	
	if (Code="")
	{
		s:Code="" Code="SINGLERULE00000"
	}
	else
	{
		s Code=##class(web.DHCBL.BDP.FunLib).AddZEROToStr(Code+1,6)	//补0
		s Code="SINGLERULE"_Code
	}
  
	q Code
}

/// Creator:xuwenhu
/// CreatDate:2021-06-03
/// Description:获得症状列表
/// Table:CT.WDT.CDSS.SingleSymptomRule
/// Input: id-表id
/// Return:返回症状列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.SingleSymptomRule","GetSympList","2")
Query GetSympList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetSympListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'=""){
		s RuleSymptom = $lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(id)),4)
		s i=1
		for
		{
			s Desc=$lg(RuleSymptom,i)
			q:Desc=""
			d OutputRowKeyWords
			s i=i+1
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

ClassMethod GetSympListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSympListExecute ]
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

ClassMethod GetSympListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSympListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator:xuwenhu
/// CreatDate:2021-06-03
/// Description:获得疾病列表
/// Table:CT.WDT.CDSS.SingleSymptomRule
/// Input: id-疾病表id
/// Return:返回疾病列表
/// Other:d ##class(%ResultSet).RunQuery("web.CDSS.CMKB.SingleSymptomRule","GetDiseList","2")
Query GetDiseList(id) As %Query(ROWSPEC = "Desc")
{
}

ClassMethod GetDiseListExecute(ByRef qHandle As %Binary, id) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
 	if (id'="")
 	{
		s DiseaseList = $lg($g(^CT.WDT.CDSS.SingleSymptomRuleD(id)),10)
		s i=1
		for
		{
			s DR=$lg(DiseaseList,i)
			q:DR=""
			s Desc=$lg($g(^CT.WDT.CDSS.DiseaseDictD(DR)),3)
			d OutputRowKeyWords
			s i=i+1
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

ClassMethod GetDiseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiseListExecute ]
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

ClassMethod GetDiseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiseListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
