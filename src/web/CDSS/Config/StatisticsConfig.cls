/// 名称: 数据统计配置
/// 描述: 数据统计配置
/// 编写者：石萧伟
/// 编写日期: 2022-01-19
Class web.CDSS.Config.StatisticsConfig Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator:石萧伟
/// CreatDate:2021-01-120
/// Description：导入菜单数据
/// Table：CF.WDT.CDSS.StatisticsConfig
/// Input：
/// Output：
/// w ##class(web.CDSS.Config.StatisticsConfig).ImpotMenuData("","")
ClassMethod ImpotMenuData(id, configParId)
{

	s parentcatdr=id
	s IDStr=""
	if (parentcatdr="") s parentcatdr=2840

	s myJsonStr=""
	s ID=0
	
	s mySeq=0
	k myArray
	k a
	//生成索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^CT.WDT.MKB.MenuI("ParSeqIdx",parentcatdr,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s ID=0
		for {
			s ID=$o(^CT.WDT.MKB.MenuI("ParSeqIdx",parentcatdr," "_mySeq,ID)) q:(ID="")
			s myCount=myCount+1
			s myArray(myCount)=ID
		}
	}
	//输出菜单JSON串
	s ID=0
	s mySeq=0
	for 
	{
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s ID=$g(myArray(mySeq))
		if ((configParId'="67")&&(configParId'="83")){
			s obj=##class(CF.WDT.CDSS.StatisticsConfig).%New() 
			s obj.SCCode=$LISTGET($G(^CT.WDT.MKB.MenuD(ID)),2)
			s obj.SCDesc=$LISTGET($G(^CT.WDT.MKB.MenuD(ID)),3)
			d obj.SCParentDrSetObjectId(configParId)
			s sc=obj.%Save()
			d obj.%Close()
			s ParId = obj.%Id()
		}

		s childStr=##class(web.DHCBL.MKB.Menu).GetChildOrderedIDStr(ID)
		if childStr'=""
		{
			w ..ImpotMenuData(ID,ParId)
		}
	}
	q ""
}

/// Creator：石萧伟
/// CreatDate: 2022-01-17
/// Description：获取下拉框数据数据  
/// Table：CF.WDT.CDSS.StatisticsConfig
/// Input：id(父节点 )
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.Config.StatisticsConfig).GetTreeComboJson("")
ClassMethod GetTreeComboJson(id As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s myJsonStr=""
	s myRowID=0

	s childStr=""
	w "["
	s count=0
	for 
	{
		s myRowID=$o(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",parentcatdr,myRowID)) q:(myRowID="")
		s count=count+1
		if count>1 w ","
		s SCDesc=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(myRowID)),3)   //描述
		w "{""id"":"""_myRowID_""""
		w ",""text"":"""_SCDesc_""""
		if $d(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",myRowID))
		{
			w ",""state"":""open"""   //closed节点不展开,open节点展开
			w ",""children"":"
			w ..GetTreeComboJson(myRowID)
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

/// Creator：石萧伟
/// CreatDate: 2022-01-17
/// Description：查询页面数据  
/// Table：CF.WDT.CDSS.StatisticsConfig
/// Input：id(父节点 )
/// Return：treegrid格式数据串
/// w ##class(web.CDSS.Config.StatisticsConfig).GetJsonList("")
ClassMethod GetJsonList(id As %String) As %String
{
	s parentcatdr=id
	if (parentcatdr="") s parentcatdr=-100000000000000
	
	s myJsonStr=""
	s myRowID=0

	s childStr=""
	w "["
	s count=0
	for 
	{
		s myRowID=$o(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",parentcatdr,myRowID)) q:(myRowID="")
		s count=count+1
		if count>1 w ","
		s SCCode=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(myRowID)),2)   //代码
		s SCDesc=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(myRowID)),3)   //描述
		s SCParentDr=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(myRowID)),4)    //父菜单
		if SCParentDr'="" s SCParentDr=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(SCParentDr)),3)   //父菜单描述
		s SCInfo=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(myRowID)),5)   //统计接口
		s SCInfo=$tr(SCInfo,"""","'")
		s SCHomeFlag=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(myRowID)),6)   //是否在首页展示
		s SCShowName=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(myRowID)),7)   //展示名
		s SCActiveFlag=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(myRowID)),8)   //是否激活
		s SCRemark=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(myRowID)),9)   //备注
		s AliasInfo=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(myRowID)),10)   //别名接口
		
		w "{""id"":"""_myRowID_""""
		w ",""SCCode"":"""_SCCode_""",""SCDesc"":"""_SCDesc_""",""SCParentDr"":"""_SCParentDr_""",""SCInfo"":"""_SCInfo_""",""SCHomeFlag"":"""_SCHomeFlag_""",""SCShowName"":"""_SCShowName_""""
		w ",""SCActiveFlag"":"""_SCActiveFlag_""",""SCRemark"":"""_SCRemark_""",""AliasInfo"":"""_AliasInfo
		w """"
		if $d(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",myRowID))
		{
			w ",""state"":""open"""   //closed节点不展开,open节点展开
			w ",""children"":"
			w ..GetJsonList(myRowID)
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

/// Creator：石萧伟   ---HISUI
/// CreatDate: 2022-01-19
/// Description：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Table：CF.WDT.CDSS.StatisticsConfig
/// Input：父节点
/// Return：所有子节点 用^连接
/// w ##class(web.CDSS.Config.StatisticsConfig).GetChildOrderedIDStr("")
ClassMethod GetChildOrderedIDStr(LastLevel As %String) As %String
{
	s IDStr=""
	if (LastLevel="") s LastLevel=-100000000000000
	
	s myJsonStr=""
	s myRowID=0
	
	s mySeq=0
	k myArray
	k a
	//生成菜单索引数组
	s mySeq=0
	s n=0
	for {
		s mySeq=$o(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",LastLevel,mySeq)) q:(mySeq="")
		s n=n+1
		s a(n)= $p(mySeq," ",2)
	}
	set left=1,right=n
	d:$d(a) ##class(web.DHCBL.BDP.FunLib).QuickSort(.a,left,right) //排序

	s n=0
	s mySeq=0
	s myCount=0
	for {
		s n=$o(a(n)) q:(n="")
		s mySeq=$g(a(n))
		s myRowID=0
		for {
			s myRowID=$o(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",LastLevel,myRowID)) q:(myRowID="")
			s myCount=myCount+1
			s myArray(myCount)=myRowID
		}
	}
	//输出菜单JSON串
	s myRowID=0
	s mySeq=0
	s childStr=""
	for {
		s mySeq=$o(myArray(mySeq)) q:(mySeq="")
		s myRowID=$g(myArray(mySeq))
		
		s childStr=..GetChildOrderedIDStr(myRowID)
		if childStr'="" s childStr=myRowID_"^"_childStr
		if childStr="" s childStr=myRowID
		
		if IDStr="" s IDStr=childStr
		else  s IDStr=IDStr_"^"_childStr
	}
	q IDStr
}

/// Creator：石萧伟
/// CreatDate: 2022-01-19
/// Description：新增和修改
/// Table：CF.WDT.CDSS.StatisticsConfig
/// w ##class(web.CDSS.Config.StatisticsConfig).SaveData()
ClassMethod SaveData(eobj As web.CDSSEntity.Config.StatisticsConfig) As %String
{
    s result = ""
    if $IsObject(eobj)
    {
        if (eobj.ID="")  //如果不存在菜单则增加
        {
            s obj=##class(CF.WDT.CDSS.StatisticsConfig).%New()
            
        }
        else  //如果RowId已赋值则修改
        {
            s obj=##class(CF.WDT.CDSS.StatisticsConfig).%OpenId(eobj.ID)
            s bobj = ##class(web.CDSSEntity.Config.StatisticsConfig).%New()
            s bobj.ID = eobj.ID
            s bobj.SCCode = obj.SCCode
            s bobj.SCDesc = obj.SCDesc
            s bobj.SCParentDr = obj.SCParentDr.%Id()
            s bobj.SCInfo = obj.SCInfo   
            s bobj.SCHomeFlag = obj.SCHomeFlag        
            s bobj.SCShowName = obj.SCShowName     
            s bobj.SCActiveFlag = obj.SCActiveFlag        
            s bobj.SCRemark = obj.SCRemark        
			s bobj.AliasInfo=obj.AliasInfo
        }
        d obj.SCParentDrSetObjectId(eobj.SCParentDr)
        s obj.SCCode = eobj.SCCode
        s obj.SCDesc = eobj.SCDesc
        s obj.SCInfo = eobj.SCInfo
        s obj.SCHomeFlag = eobj.SCHomeFlag
        s obj.SCShowName = eobj.SCShowName
        s obj.SCActiveFlag = eobj.SCActiveFlag
        s obj.SCRemark = eobj.SCRemark
        s obj.AliasInfo=eobj.AliasInfo
        
        Ts
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc){
            Tc
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}" //返回RowId
        }else{
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
        }
    }   
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在'}"
    }
    
    q result
}

/// Creator：石萧伟
/// CreatDate: 2021-01-19
/// Input:对象id
/// Description：修改时打开的对象数据
/// return:对象json串
/// w ##class(web.CDSS.Config.StatisticsConfig).OpenData(2851)
ClassMethod OpenData(ID As %String) As %String
{
    s str=""    
    s eobj = ##class(web.CDSSEntity.Config.StatisticsConfig).%New()
    s pobj = ##class(CF.WDT.CDSS.StatisticsConfig).%OpenId(ID)
    s eobj.ID = ID
    s:pobj.SCParentDr'="" eobj.SCParentDr = pobj.SCParentDr.%Id()
    s eobj.SCCode = pobj.SCCode
    s eobj.SCDesc = pobj.SCDesc
    s eobj.SCInfo = pobj.SCInfo
    s eobj.SCHomeFlag = pobj.SCHomeFlag
    s eobj.SCShowName = pobj.SCShowName
    s eobj.SCActiveFlag = pobj.SCActiveFlag
    s eobj.SCRemark = pobj.SCRemark
	s eobj.AliasInfo=pobj.AliasInfo

    d pobj.%Close() 
    k pobj  

    s str = eobj.JsonS()    
   //s str = "{data:["_str_"]}"
    q str
}

/// Creator:石萧伟
/// CreatDate:2021-01-22
/// Description:根据id删除
/// Table:CF.WDT.CDSS.StatisticsConfig
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.Config.StatisticsConfig).DeleteData("85")
ClassMethod DeleteData(id As %String) As %String
{
	s result = "",flag=""
	s flag=$d(^CF.WDT.CDSS.StatisticsConfigI("ParentDrIndex",id)) //判断该菜单是否被引用
	if (flag>0)
	{
		s result = "{success:'false',info:'该数据下已有子节点,禁止删除！'}"   
	}
	else
	{
		s eobj = ##class(web.CDSSEntity.Config.StatisticsConfig).%New()
	    s eobj.ID = id
	    s eobj.SCParentDr = $LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(id)),4)    //父菜单
	    s eobj.SCCode = $LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(id)),2)   //代码
	    s eobj.SCDesc = $LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(id)),3)   //描述
	    s eobj.SCInfo = $LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(id)),5)   //统计接口
	    s eobj.SCHomeFlag = $LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(id)),6)   //是否在首页展示
	    s eobj.SCShowName = $LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(id)),7)   //展示名
	    s eobj.SCActiveFlag = $LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(id)),8)   //是否激活
	    s eobj.SCRemark = $LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(id)),9)   //备注
	    s eobj.AliasInfo=$LISTGET($G(^CF.WDT.CDSS.StatisticsConfigD(id)),10)   //备注
		ts
		s sc=##class(CF.WDT.CDSS.StatisticsConfig).%DeleteId(id)
		if $$$ISOK(sc)
		{
			tc
			s result = "{success:'true',info:'删除成功！'}" 
			//保存日志
			d ##class(web.CDSS.Config.DataChangeLog).SaveLog("CF_WDT_CDSS.StatisticsConfig","CF.WDT.CDSS.StatisticsConfig","数据统计配置",id,eobj.SCDesc,"D",eobj)
			d eobj.%Close()
		}
		else 
		{
			tro
			s logid= ##class(web.CDSS.Config.SysErrorLog).SaveLog("数据统计配置","CF.WDT.CDSS.StatisticsConfig","DeleteData",eobj)
    		s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
			s result ="{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
		}
	}
	q result
}

/// Creator:Xuwenhu
/// CreatDate:2021-01-28
/// Description:根据id删除
/// Table:CF.WDT.CDSS.StatisticsConfig
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.CDSS.Config.StatisticsConfig).ImportData("D:\Works\menu.csv")
ClassMethod ImportData(Path As %String) As %String
{
	s readcount=0   	//读取总数
	s savecount=0		//导入成功总数
	s nosavecount=0 	//导入失败总数
	s incount=0			//已存在总数
	s num=0
	s file=##class(%File).%New(Path)
	d file.Open("RS")
	d file.ReadLine()		//读取第一行
	while 'file.AtEnd
	{
		s str=file.ReadLine()
		continue:str=""
		s num=num+1
		s SCInfo=$p(str,",",1)				//接口名称
		s MenuName=$p(str,",",2)			//菜单名
		s Alias=$p(str,",",3)				//别名接口
		//去除两端空白
		s SCInfo=$zstrip(SCInfo,"<>W")
		s MenuName=$zstrip(MenuName,"<>W")
		s Alias=$zstrip(Alias,"<>W")
		s readcount=readcount+1
		s RowID=$o(^CF.WDT.CDSS.StatisticsConfigI("DescIndex"," "_MenuName,0))
		if (RowID'="")
		{
			s obj=##class(CF.WDT.CDSS.StatisticsConfig).%OpenId(RowID)
			s bobj = ##class(web.CDSSEntity.Config.StatisticsConfig).%New()
			s bobj.ID = RowID
			s bobj.SCCode = obj.SCCode
            s bobj.SCDesc = obj.SCDesc
            s bobj.SCParentDr = obj.SCParentDr.%Id()
            s bobj.SCInfo = SCInfo   
            s bobj.SCHomeFlag = obj.SCHomeFlag        
            s bobj.SCShowName = obj.SCShowName     
            s bobj.SCActiveFlag = obj.SCActiveFlag        
            s bobj.SCRemark = obj.SCRemark 
            s bobj.AliasInfo=Alias    
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
	}
	q "{success:'true',readcount:'"_readcount_"',savecount:'"_savecount_"',nosavecount:'"_nosavecount_"',incount:'"_incount_"'}"
}

}
