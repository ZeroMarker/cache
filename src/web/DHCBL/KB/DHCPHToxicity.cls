Import SQLUser

/// 名称: 草药毒性字典表维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-07-19
Class web.DHCBL.KB.DHCPHToxicity Extends %RegisteredObject
{

/// Creator:石萧伟
/// CreatDate:2014-08-07
/// Description：修改时打开的数据
/// Table：User.DHCPHToxicity
/// Input：id-草药毒性字典的rowid
/// Return:Json格式的字符串{list:[{ToxActiveFlag:"true",ToxCode:"PUBLIC",ToxDesc:"公共",ToxRowId:"9"}]}
/// Other: w ##class(web.DHCBL.KB.DHCPHToxicity).OpenData("9")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHToxicity).%New()
    s eobj.ToxRowId=id
    s eobj.ToxCode=$p($g(^DHCPHTOX(id)),"^",1)
    s eobj.ToxDesc=$p($g(^DHCPHTOX(id)),"^",2)
    s eobj.ToxActiveFlag=$p($g(^DHCPHTOX(id)),"^",3)    
    s:eobj.ToxActiveFlag="" eobj.ToxActiveFlag="Y"  
    s str = eobj.JsonS()    
    d eobj.%Close()
   // s str = "{list:["_str_"]}"
    q str
}

/// Creator:谷雪萍
/// CreatDate:2014-07-19
/// Description：修改时打开的数据
/// Table：User.DHCPHToxicity
/// Input：id-草药毒性字典的rowid
/// Return:Json格式的字符串{list:[{ToxActiveFlag:"true",ToxCode:"PUBLIC",ToxDesc:"公共",ToxRowId:"9"}]}
/// Other: w ##class(web.DHCBL.KB.DHCPHToxicity).OpenData("9")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHToxicity).%New()
    s eobj.ToxRowId=id
    s eobj.ToxCode=$p($g(^DHCPHTOX(id)),"^",1)
    s eobj.ToxDesc=$p($g(^DHCPHTOX(id)),"^",2)
    s eobj.ToxActiveFlag=$p($g(^DHCPHTOX(id)),"^",3)    
    s:eobj.ToxActiveFlag="Y" eobj.ToxActiveFlag="true"  
    s str = eobj.JsonS()    
    d eobj.%Close()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator:谷雪萍
/// CreatDate:2014-07-19
/// Description：数据重复验证方法，由js调用
/// Table：User.DHCPHToxicity
/// Input：id-rowid, code-代码,desc-描述
/// Return："1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.CTCity).FormValidate("","","")
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHTOXi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHTOXi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHTOXi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHTOXi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator:谷雪萍
/// CreatDate:2014-07-19
/// Description：保存草药毒性字典表的内容
/// Table：User.DHCPHToxicity
/// Input：web.Entity.KB.DHCPHToxicity 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHToxicity).SaveData(eobj)
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHToxicity) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.ToxRowId,eobj.ToxCode,eobj.ToxDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.ToxRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHToxicity).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHToxicity).%OpenId(eobj.ToxRowId)
                s bobj=##class(web.Entity.KB.DHCPHToxicity).%New()
                s bobj.ToxRowId=eobj.ToxRowId
                s bobj.ToxCode=obj.ToxCode
                s bobj.ToxDesc = obj.ToxDesc          //修改描述
                s bobj.ToxActiveFlag = obj.ToxActiveFlag 
            }
            Ts
            s obj.ToxCode = eobj.ToxCode
            s obj.ToxDesc = eobj.ToxDesc          //修改描述
            s:eobj.ToxActiveFlag="" eobj.ToxActiveFlag ="N" 
            s obj.ToxActiveFlag = eobj.ToxActiveFlag 
                    
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.ToxRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHToxicity","User.DHCPHToxicity","草药毒性字典表",id,eobj.ToxDesc,"A",eobj)
                //修改时，日志
                d:eobj.ToxRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHToxicity","User.DHCPHToxicity","草药毒性字典表",eobj.ToxRowId,eobj.ToxDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("草药毒性字典表","web.DHCBL.KB.DHCPHToxicity","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("草药毒性字典表","web.DHCBL.KB.DHCPHToxicity","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator:谷雪萍
/// CreatDate:2014-07-19
/// Description：查询草药毒性字典表的内容
/// Table：User.DHCPHToxicity
/// Input：rowid,code,desc
/// Return: ToxRowId:ToxCode:ToxDesc:ToxActiveFlag:
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHToxicity","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ToxRowId:%String,ToxCode:%String,ToxDesc:%String,ToxActiveFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHToxicity).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ToxRowId=rowid
        s ToxCode=$p($g(^DHCPHTOX(ToxRowId)),"^",1)
        s ToxDesc=$p($g(^DHCPHTOX(ToxRowId)),"^",2)
        s ToxActiveFlag=$p($g(^DHCPHTOX(ToxRowId)),"^",3)
        s:ToxActiveFlag="" ToxActiveFlag="Y"
    
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s ToxRowId=0
        for {
            s ToxRowId=$o(^DHCPHTOX(ToxRowId))
            q:ToxRowId=""
			s strRowId="{ID:"_ToxRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
	            s ToxCode=$p($g(^DHCPHTOX(ToxRowId)),"^",1)
	            s ToxDesc=$p($g(^DHCPHTOX(ToxRowId)),"^",2)
	            s ToxActiveFlag=$p($g(^DHCPHTOX(ToxRowId)),"^",3)
	             s:ToxActiveFlag="" ToxActiveFlag="Y"
	            
	            s uToxDesc=$ZCONVERT(ToxDesc,"U") //转换成大写
	            s PINYIN=""
	            s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(uToxDesc)         
	            if ($ZCONVERT(ToxCode,"U")[code)&((uToxDesc[desc)||(PINYIN[desc))
	            {
	                d OutputRow
	            }
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(ToxRowId,ToxCode,ToxDesc,ToxActiveFlag)
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
/// CreatDate:2014-07-19
/// Description:为combobox查询取数据
/// Table：User.DHCPHToxicity
/// Input：rowid,code,desc
/// Return: ToxRowId:ToxCode:ToxDesc:
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHToxicity","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ToxRowId:%String,ToxCode:%String,ToxDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHToxicity).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s ToxRowId=rowid
        s ToxCode=$p($g(^DHCPHTOX(ToxRowId)),"^",1)
        s ToxDesc=$p($g(^DHCPHTOX(ToxRowId)),"^",2)
        s ToxActiveFlag=$p($g(^DHCPHTOX(ToxRowId)),"^",3)
        d:ToxActiveFlag="Y" OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s ToxRowId=0
        for {
            s ToxRowId=$o(^DHCPHTOX(ToxRowId))
            q:ToxRowId=""
            s strRowId="{ID:"_ToxRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
	            s ToxActiveFlag=$p($g(^DHCPHTOX(ToxRowId)),"^",3)
	            continue:ToxActiveFlag="N"
	            s ToxCode=$p($g(^DHCPHTOX(ToxRowId)),"^",1)
	            s ToxDesc=$p($g(^DHCPHTOX(ToxRowId)),"^",2)
	            s uToxDesc=$ZCONVERT(ToxDesc,"U") //转换成大写
	            s PINYIN=""
	            s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(uToxDesc)
	            if ($ZCONVERT(ToxCode,"U")[code)&((uToxDesc[desc)||(PINYIN[desc))
	            {
	                d OutputRowCmb
	            }
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(ToxRowId,ToxCode,ToxDesc)
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
/// CreatDate:2014-07-19
/// Description:删除限制
/// Input：id-草药毒性字典的rowid
/// Return:1-在哪些表被引用不可删除,0-未被引用可删除
/// Other:w ##class(web.DHCBL.KB.DHCPHToxicity).GetRefFlag("7")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    
    //判断是否在药品商品名字典中被引用
    s flag=0,RowId=0
    for
    {
        s RowId=$o(^DHCPHPNA(RowId)) q:(RowId="")||(flag=1)  d
        s PHNToxicity=$p($g(^DHCPHPNA(RowId)),"^",8)
        i PHNToxicity=id
        {
            s flag=1
            s myInfo=myInfo_"<药品商品名字典>"
        }
    }

    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Creator:谷雪萍
/// CreatDate:2014-07-19
/// Description：根据ID删除草药毒性字典表的内容
/// Table：User.DHCPHToxicity
/// Input：id-草药毒性字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.KB.DHCPHToxicity).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    s re=##class(web.DHCBL.KB.DHCPHToxicity).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
        //new Entity对象，用于保存日志
        s pobj = ##class(User.DHCPHToxicity).%OpenId(id)
        s eobj = ##class(web.Entity.KB.DHCPHToxicity).%New()
        s eobj.ToxRowId = id
        s eobj.ToxCode=pobj.ToxCode
        s eobj.ToxDesc=pobj.ToxDesc
        s eobj.ToxActiveFlag=pobj.ToxActiveFlag
        d pobj.%Close()
        k pobj
        Tstart
        s sc=##class(User.DHCPHToxicity).%DeleteId(id)
        if $$$ISOK(sc)
        {
            Tcommit
            s result = "{success:'true',info:'删除成功！'}"  
            //保存日志
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHToxicity","User.DHCPHToxicity","草药毒性字典表",id,eobj.ToxDesc,"D",eobj)
            d eobj.%Close()
        }
        else 
        {
            Trollback
            s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("草药毒性字典表","web.DHCBL.KB.DHCPHToxicity","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)

        }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    
    q result
}

}
