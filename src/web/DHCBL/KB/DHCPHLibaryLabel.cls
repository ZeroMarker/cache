Import SQLUser

/// 名称: 知识库标识字典表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-10-30
Class web.DHCBL.KB.DHCPHLibaryLabel Extends %RegisteredObject
{

/// Creator:石萧伟
/// CreatDate:2018-07-31
/// Description:为combobox查询取数据
/// Table：User.DHCPHLibaryLabel
/// Input：rowid,code,desc
/// Return: PHLIRowId:PHLICode:PHLIDesc:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHLibaryLabel","GetDataForCmb1","","","")
Query GetNewDataForCmb1(rowid As %String, code As %String, q As %String) As %Query(ROWSPEC = "PHLIRowId:%String,PHLICode:%String,PHLIDesc:%String")
{
}

ClassMethod GetNewDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, q As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHLIRowId=rowid
        s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)
        s PHLIDesc=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)  
        s PHLIActiveFlag=$p($g(^DHCPHLIBL(PHLIRowId)),"^",3)
        d:PHLIActiveFlag'="Y" OutputRowCmbNew
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:q'="" q=$ZCONVERT(q,"U") //转换成大写
        s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        s PHLIRowId=0
        for {
            s PHLIRowId=$o(^DHCPHLIBL(PHLIRowId))
            q:PHLIRowId=""
			s strRowId="{ID:"_PHLIRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
	            s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)
	            s PHLIDesc=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)
	            s PHLIActiveFlag=$p($g(^DHCPHLIBL(PHLIRowId)),"^",3)
	            continue:PHLIActiveFlag="N"
	            s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHLIDesc)
	            if ($ZCONVERT(PHLICode,"U")[code)&(($ZCONVERT(PHLIDesc,"U")[q)||(PINYIN[q))
	            {
	                d OutputRowCmbNew
	            }
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmbNew
    set Data=$lb(PHLIRowId,PHLICode,PHLIDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetNewDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetNewDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
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

/// Creator:石萧伟
/// CreatDate:2018-01-30
/// Description：修改时打开的数据
/// Table：User.DHCPHLibaryLabel
/// Input：id-知识库标识字典的rowid
/// Return:Json格式的字符串{"PHLIActiveFlag":"Y","PHLICode":"PUBLIC","PHLIDesc":"公共","PHLIRowId":"9"}
/// Other: w ##class(web.DHCBL.KB.DHCPHLibaryLabel).NewOpenData("9")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHLibaryLabel).%New()
    s eobj.PHLIRowId=id
    s eobj.PHLICode=$p($g(^DHCPHLIBL(id)),"^",1)
    s eobj.PHLIDesc=$p($g(^DHCPHLIBL(id)),"^",2)
    s eobj.PHLIActiveFlag=$p($g(^DHCPHLIBL(id)),"^",3)  
    s:eobj.PHLIActiveFlag'="N" eobj.PHLIActiveFlag="Y"    
    s str = eobj.JsonS()    
    d eobj.%Close()
    //s str = "{list:["_str_"]}"
    q str
}

/// Creator:谷雪萍
/// CreatDate:2014-10-30
/// Description：修改时打开的数据
/// Table：User.DHCPHLibaryLabel
/// Input：id-知识库标识字典的rowid
/// Return:Json格式的字符串{list:[{PHLIActiveFlag:"true",PHLICode:"PUBLIC",PHLIDesc:"公共",PHLIRowId:"9"}]}
/// Other: w ##class(web.DHCBL.KB.DHCPHLibaryLabel).OpenData("9")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHLibaryLabel).%New()
    s eobj.PHLIRowId=id
    s eobj.PHLICode=$p($g(^DHCPHLIBL(id)),"^",1)
    s eobj.PHLIDesc=$p($g(^DHCPHLIBL(id)),"^",2)
    s eobj.PHLIActiveFlag=$p($g(^DHCPHLIBL(id)),"^",3)  
    s:eobj.PHLIActiveFlag'="N" eobj.PHLIActiveFlag="true"    
    s str = eobj.JsonS()    
    d eobj.%Close()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator:谷雪萍
/// CreatDate:2014-10-30
/// Description：数据重复验证方法，由js调用
/// Table：User.DHCPHLibaryLabel
/// Input：id-rowid, code-代码,desc-描述
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.CTCity).FormValidate("","","")
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHLIBL(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHLIBL(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHLIBL(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHLIBL(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator:谷雪萍
/// CreatDate:2014-10-30
/// Description：保存知识库标识字典表的内容
/// Table：User.DHCPHLibaryLabel
/// Input：web.Entity.KB.DHCPHLibaryLabel 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHLibaryLabel).SaveData(eobj)
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHLibaryLabel) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.PHLIRowId,eobj.PHLICode,eobj.PHLIDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.PHLIRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHLibaryLabel).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHLibaryLabel).%OpenId(eobj.PHLIRowId)
                s bobj=##class(web.Entity.KB.DHCPHLibaryLabel).%New()
                s bobj.PHLIRowId=eobj.PHLIRowId
                s bobj.PHLICode=obj.PHLICode
                s bobj.PHLIDesc = obj.PHLIDesc          //修改描述
                s bobj.PHLIActiveFlag = obj.PHLIActiveFlag 
            }
            Ts
            s obj.PHLICode = eobj.PHLICode
            s obj.PHLIDesc = eobj.PHLIDesc          //修改描述
            s:eobj.PHLIActiveFlag="" eobj.PHLIActiveFlag ="N" 
            s obj.PHLIActiveFlag = eobj.PHLIActiveFlag 
                    
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.PHLIRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHLibaryLabel","User.DHCPHLibaryLabel","知识库标识字典表",id,eobj.PHLIDesc,"A",eobj)
                //修改时，日志
                d:eobj.PHLIRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHLibaryLabel","User.DHCPHLibaryLabel","知识库标识字典表",eobj.PHLIRowId,eobj.PHLIDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库标识字典表","web.DHCBL.KB.DHCPHLibaryLabel","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库标识字典表","web.DHCBL.KB.DHCPHLibaryLabel","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:谷雪萍
/// CreatDate:2014-10-30
/// Description：查询知识库标识字典表的内容
/// Table：User.DHCPHLibaryLabel
/// Input：rowid,code,desc
/// Return: PHLIRowId:PHLICode:PHLIDesc:PHLIActiveFlag:
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHLibaryLabel","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHLIRowId:%String,PHLICode:%String,PHLIDesc:%String,PHLIActiveFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHLIRowId=rowid
        s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)
        s PHLIDesc=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)
        s PHLIActiveFlag=$p($g(^DHCPHLIBL(PHLIRowId)),"^",3)
    	s:PHLIActiveFlag'="N" PHLIActiveFlag="Y"
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1        
        s PHLIRowId=0
        for {
            s PHLIRowId=$o(^DHCPHLIBL(PHLIRowId))
            q:PHLIRowId=""
            
			s strRowId="{ID:"_PHLIRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
				
	            s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)
	            s PHLIDesc=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)
	            s PHLIActiveFlag=$p($g(^DHCPHLIBL(PHLIRowId)),"^",3)
	            s:PHLIActiveFlag'="N" PHLIActiveFlag="Y"
	            s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHLIDesc)
	            
	            if ($ZCONVERT(PHLICode,"U")[code)&(($ZCONVERT(PHLIDesc,"U")[desc)||(PINYIN[desc))
	            {
	                d OutputRow
	            }
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHLIRowId,PHLICode,PHLIDesc,PHLIActiveFlag)
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

/// Creator:谷雪萍
/// CreatDate:2014-10-30
/// Description:为combobox查询取数据
/// Table：User.DHCPHLibaryLabel
/// Input：rowid,code,desc
/// Return: PHLIRowId:PHLICode:PHLIDesc:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHLibaryLabel","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHLIRowId:%String,PHLICode:%String,PHLIDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
    //s AuFlag=0
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHLIRowId=rowid
        s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)
        s PHLIDesc=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)  
        s PHLIActiveFlag=$p($g(^DHCPHLIBL(PHLIRowId)),"^",3)
        d:PHLIActiveFlag'="N" OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
        s PHLIRowId=0
        for {
            s PHLIRowId=$o(^DHCPHLIBL(PHLIRowId))
            q:PHLIRowId=""
            
			s strRowId="{ID:"_PHLIRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
	            s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)
	            s PHLIDesc=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)
	            s PHLIActiveFlag=$p($g(^DHCPHLIBL(PHLIRowId)),"^",3)
	            continue:PHLIActiveFlag="N"
	            s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHLIDesc)
	            if ($ZCONVERT(PHLICode,"U")[code)&(($ZCONVERT(PHLIDesc,"U")[desc)||(PINYIN[desc))
	            {
	                d OutputRowCmb
	            }

			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHLIRowId,PHLICode,PHLIDesc)
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

/// Creator:谷雪萍
/// CreatDate:2014-11-18
/// Description:为combobox查询取数据,用于分类类型字典检验项目、检验标本同取检验项目数据
/// Table：User.DHCPHLibaryLabel
/// Input：rowid,code,desc
/// Return: PHLIRowId:PHLICode:PHLIDesc:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHLibaryLabel","GetDataForCmb2","","","")
Query GetDataForCmb2(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHLIRowId:%String,PHLICode:%String,PHLIDesc:%String")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHLIRowId=rowid
        s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)
        s PHLIDesc=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)  
        s PHLIActiveFlag=$p($g(^DHCPHLIBL(PHLIRowId)),"^",3)
        d:PHLIActiveFlag'="N" OutputRowCmb2
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s AuStr=##class(web.DHCBL.Authorize.DHCPHLibaryLabel).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        s PHLIRowId=0
        for {
            s PHLIRowId=$o(^DHCPHLIBL(PHLIRowId))
            q:PHLIRowId=""
            s strRowId="{ID:"_PHLIRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
                s PHLICode=$p($g(^DHCPHLIBL(PHLIRowId)),"^",1)
                s PHLIDesc=$p($g(^DHCPHLIBL(PHLIRowId)),"^",2)
                
                s PHLIActiveFlag=$p($g(^DHCPHLIBL(PHLIRowId)),"^",3)
                continue:PHLIActiveFlag="N"
                
                if (PHLICode="LAB"){
                    s PHLIDesc = "检验"               
                }
                if (PHLICode="SPEC"){   
                    continue    
                }
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHLIDesc)
                if ($ZCONVERT(PHLICode,"U")[code)&(($ZCONVERT(PHLIDesc,"U")[desc)||(PINYIN[desc))
                {   
                    d OutputRowCmb2 
                }
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb2
    set Data=$lb(PHLIRowId,PHLICode,PHLIDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
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

/// Creator:谷雪萍
/// CreatDate:2014-10-30
/// Description:删除限制
/// Input：id-知识库标识字典的rowid
/// Return:1-在哪些表被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.DHCBL.KB.DHCPHLibaryLabel).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    
    //判断是否在特殊人群表中被引用
    s flag=0,SPERowId=0
    for
    {
        s SPERowId=$o(^DHCSPEP(SPERowId)) q:(SPERowId="")||(flag=1)  d
        s SPELibDr=$p($g(^DHCSPEP(SPERowId)),"^",4)
        i SPELibDr=id
        {
            s flag=1
            s myInfo=myInfo_"<特殊人群列表>"
        }
    }
    //判断是否在通用名字典表中被引用
    s flag=0,PHEGRowId=0
    for
    {
        s PHEGRowId=$o(^DHCPHEGEN(PHEGRowId)) q:(PHEGRowId="")||(flag=1)  d
        s PHEGLibDr=$p($g(^DHCPHEGEN(PHEGRowId)),"^",7)
        i PHEGLibDr=id
        {
            s flag=1
            s myInfo=myInfo_"<通用名字典>"
        }
    }
    //判断是否在通用名别名字典表中被引用
    s flag=0,PHEGAlRowId=0
    for
    {
        s PHEGAlRowId=$o(^DHCPHEGAL(PHEGAlRowId)) q:(PHEGAlRowId="")||(flag=1)  d
        s PHEGAlLibDr=$p($g(^DHCPHEGAL(PHEGAlRowId)),"^",3)
        i PHEGAlLibDr=id
        {
            s flag=1
            s myInfo=myInfo_"<通用名别名字典表>"
        }
    }
    //判断是否在分类/类型字典表表中被引用
    s flag=0,PHlCRowId=0
    for
    {
        s PHlCRowId=$o(^DHCPHLCAT(PHlCRowId)) q:(PHlCRowId="")||(flag=1)  d
        s PHlCLibDr=$p($g(^DHCPHLCAT(PHlCRowId)),"^",5)
        i PHlCLibDr=id
        {
            s flag=1
            s myInfo=myInfo_"<分类/类型字典表>"
        }
    }
    //判断是否在检查结果字典表中被引用
    s flag=0,ExaRowId=0
    for
    {
        s ExaRowId=$o(^DHCEXAMINE(ExaRowId)) q:(ExaRowId="")||(flag=1)  d
        s ExaLibDr=$p($g(^DHCEXAMINE(ExaRowId)),"^",3)
        i ExaLibDr=id
        {
            s flag=1
            s myInfo=myInfo_"<检查结果字典表>"
        }
    }
    //判断是否在知识库目录字典表中被引用
    s flag=0,PINLRowId=0
    for
    {
        s PINLRowId=$o(^DHCPHPINL(PINLRowId)) q:(PINLRowId="")||(flag=1)  d
        s PINLLabelDr=$p($g(^DHCPHPINL(PINLRowId)),"^",5)
        i PINLLabelDr=id
        {
            s flag=1
            s myInfo=myInfo_"<知识库目录字典表>"
        }
    }
    //判断是否在知识库标识与HIS科室对照表中被引用
    s flag=0,PHLCRowId=0
    for
    {
        s PHLCRowId=$o(^DHCPHLIBC(PHLCRowId)) q:(PHLCRowId="")||(flag=1)  d
        s PHLCLibCode=$p($g(^DHCPHLIBC(PHLCRowId)),"^",1)
        s code=$p($g(^DHCPHLIBL(id)),"^",1)
        i PHLCLibCode=code
        {
            s flag=1
            s myInfo=myInfo_"<知识库标识与HIS科室对照>"
        }
    }
    //判断是否在知识库规则配置中被引用
    s flag=0, ruledr=0
    for  
    {
        s ruledr=$o(^DHCPHLIBRULE(ruledr)) q:(ruledr="")||(ruledr=0)||(flag=1)  d
        s libdr=$p(^DHCPHLIBRULE(ruledr),"^",1)
        i libdr=id
        {
            s flag=1
            s myInfo=myInfo_"<知识库规则配置>"
        }
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Creator:谷雪萍
/// CreatDate:2014-10-30
/// Description：根据ID删除知识库标识字典表的内容
/// Table：User.DHCPHLibaryLabel
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCPHLibaryLabel).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=##class(web.DHCBL.KB.DHCPHLibaryLabel).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
        //new Entity对象，用于保存日志
        s pobj = ##class(User.DHCPHLibaryLabel).%OpenId(id)
        s eobj = ##class(web.Entity.KB.DHCPHLibaryLabel).%New()
        s eobj.PHLIRowId = id
        s eobj.PHLICode=pobj.PHLICode
        s eobj.PHLIDesc=pobj.PHLIDesc
        s eobj.PHLIActiveFlag=pobj.PHLIActiveFlag
        d pobj.%Close()
        k pobj
        Tstart
        s sc=##class(User.DHCPHLibaryLabel).%DeleteId(id)
        if $$$ISOK(sc)
        {
            Tcommit
            s result = "{success:'true',info:'删除成功！'}"  
            //保存日志
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHLibaryLabel","User.DHCPHLibaryLabel","知识库标识字典表",id,eobj.PHLIDesc,"D",eobj)
            d eobj.%Close()
        }
        else 
        {
            Trollback
            s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库标识字典表","web.DHCBL.KB.DHCPHLibaryLabel","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)

        }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    
    q result
}

}
