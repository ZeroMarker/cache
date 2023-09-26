Class web.DHCBL.KB.DHCPHBTOrganism Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2018-08-07
/// Description：获取修改时的记录
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHBTOrganism).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHBTOrganism).%New()
    s pobj = ##class(User.DHCPHBTOrganism).%OpenId(id)
    s eobj.BTORowId = id
    s eobj.BTOCode = pobj.BTOCode
    s eobj.BTODesc = pobj.BTODesc
    s eobj.BTOWhoNet=pobj.BTOWhoNet
    s eobj.BTOActiveFlag=pobj.BTOActiveFlag
    s eobj.BTOSysFlag=pobj.BTOSysFlag
    s:pobj.BTOActiveFlag="" eobj.BTOActiveFlag="Y"
    s:pobj.BTOSysFlag="" eobj.BTOSysFlag="Y"    

    s str = eobj.JsonS()    
   // s str = "{data:["_str_"]}"
    q str
}

/// Creator：谷雪萍
/// CreatDate: 2017-04-10
/// Description：查询细菌字典表内容
/// Table：User.DHCPHBTOrganism
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHBTOrganism","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "BTORowId,BTOCode,BTODesc,BTOWhoNet,BTOActiveFlag,BTOSysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHBTOrganism).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s BTORowId=rowid 
        s BTOCode=$p($g(^DHCPHBTORG(BTORowId)),"^",1)  //代码
        s BTODesc=$p($g(^DHCPHBTORG(BTORowId)),"^",2)  //描述
        s BTOWhoNet=$p($g(^DHCPHBTORG(BTORowId)),"^",3)  //Whonet码
        s BTOActiveFlag=$p($g(^DHCPHBTORG(BTORowId)),"^",4)  //是否可用
        s BTOSysFlag=$p($g(^DHCPHBTORG(BTORowId)),"^",5)  //是否系统标识
        s:BTOActiveFlag="" BTOActiveFlag="Y"
        s:BTOSysFlag="" BTOSysFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s BTORowId=0
        for  
        {   
            s BTORowId=$o(^DHCPHBTORG(BTORowId)) q:BTORowId="" 
            s strRowId = "{ID:"_BTORowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s BTOCode=$p($g(^DHCPHBTORG(BTORowId)),"^",1)  //代码
                s BTOCodeU=$ZCONVERT(BTOCode,"U")
                s BTODesc=$p($g(^DHCPHBTORG(BTORowId)),"^",2)  //描述
                s BTODescU=$ZCONVERT(BTODesc,"U")
                s BTOWhoNet=$p($g(^DHCPHBTORG(BTORowId)),"^",3)  //Whonet码
                s BTOActiveFlag=$p($g(^DHCPHBTORG(BTORowId)),"^",4)  //是否可用
                s BTOSysFlag=$p($g(^DHCPHBTORG(BTORowId)),"^",5)  //是否系统标识
                s:BTOActiveFlag="" BTOActiveFlag="Y"
        		s:BTOSysFlag="" BTOSysFlag="Y"
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(BTODescU))
                i (BTOCodeU[code)&((BTODescU[desc)||(PINYIN[desc))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(BTORowId,BTOCode,BTODesc,BTOWhoNet,BTOActiveFlag,BTOSysFlag)
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
/// CreatDate:2017-04-10
/// Description:查询 细菌
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHBTOrganism","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "BTORowId:%String,BTODesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s BTORowId=rowid
        s BTODesc=$p($g(^DHCPHBTORG(BTORowId)),"^",2)
        s BTOActiveFlag=$p($g(^DHCPHBTORG(BTORowId)),"^",4)  //是否可用
        d:BTOActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCPHBTOrganism).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s BTORowId=0
        for
        {
            s BTORowId=$o(^DHCPHBTORG(BTORowId)) q:BTORowId=""
            s strRowId="{ID:"_BTORowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s BTOActiveFlag=$p($g(^DHCPHBTORG(BTORowId)),"^",4)  //是否可用
                continue:BTOActiveFlag="N"
                s BTODesc=$p($g(^DHCPHBTORG(BTORowId)),"^",2)
                s BTODesc1=$ZCONVERT(BTODesc,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(BTODesc1))
                i (BTODesc1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(BTORowId,BTODesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set AtEnd=$LIST(qHandle,1)
    Set repid=$LIST(qHandle,2)
    Set ind=$LIST(qHandle,3)
    
    Set ind=$o(^CacheTemp(repid,ind))
    If ind=""
    {
        //if there are no more rows,finish fetching
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

ClassMethod GetDataForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb1Execute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 谷雪萍
/// CreateDate:2014-10-30    
/// w ##class(web.DHCBL.KB.DHCPHBTOrganism).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHBTORGi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHBTORGi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHBTORGi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHBTORGi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：谷雪萍
/// CreatDate: 2017-04-10
/// Description：保存修改内容
/// Table：User.DHCPHBTOrganism
/// Input：web.Entity.KB.DHCPHBTOrganism 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHBTOrganism) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.BTORowId,eobj.BTOCode,eobj.BTODesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.BTORowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHBTOrganism).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHBTOrganism).%OpenId(eobj.BTORowId)
                
                s bobj = ##class(web.Entity.KB.DHCPHBTOrganism).%New()
                s bobj.BTORowId = eobj.BTORowId
                s bobj.BTOCode = obj.BTOCode
                s bobj.BTODesc = obj.BTODesc
                s bobj.BTOWhoNet=obj.BTOWhoNet
                s bobj.BTOActiveFlag= obj.BTOActiveFlag
                s bobj.BTOSysFlag = obj.BTOSysFlag
            }
    
            s obj.BTOCode = eobj.BTOCode
            s obj.BTODesc = eobj.BTODesc
            s obj.BTOWhoNet=eobj.BTOWhoNet
            i eobj.BTOActiveFlag="Y"
            {
                s obj.BTOActiveFlag = "Y"
            }
            else
            {
                s obj.BTOActiveFlag = "N"
            }
            i eobj.BTOSysFlag="Y"
            {
                s obj.BTOSysFlag = "Y"
            }
            else
            {
                s obj.BTOSysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.BTORowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHBTOrganism","User.DHCPHBTOrganism","细菌字典",id,eobj.BTODesc,"A",eobj)
                d:eobj.BTORowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHBTOrganism","User.DHCPHBTOrganism","细菌字典",eobj.BTORowId,eobj.BTODesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("细菌字典","web.DHCBL.KB.DHCPHBTOrganism","SaveData",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
        }   
    }   

    else
    {
        s result = "{success:'false',errorinfo:'对象不存在'}"
    }
    
    q result
}

/// Creator：谷雪萍
/// CreatDate: 2017-04-10
/// Description：获取修改时的记录
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHBTOrganism).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHBTOrganism).%New()
    s pobj = ##class(User.DHCPHBTOrganism).%OpenId(id)
    s eobj.BTORowId = id
    s eobj.BTOCode = pobj.BTOCode
    s eobj.BTODesc = pobj.BTODesc
    s eobj.BTOWhoNet=pobj.BTOWhoNet
    s:pobj.BTOActiveFlag="Y" eobj.BTOActiveFlag="true"
    s:pobj.BTOSysFlag="Y" eobj.BTOSysFlag="true"    

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHBTOrganism).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    
    s RowId=0,flag=0
    for
    {
        s RowId=$o(^DHCPHORGBUS(RowId)) q:(RowId="")||(flag=1)  d
        s OrgDr=$p($g(^DHCPHORGBUS(RowId)),"^",2)
        i OrgDr=id
        {
            s flag=1
            s myInfo=myInfo_"<细菌业务表>"
        }
    }
    
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Creator:谷雪萍
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCPHExtIngr
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHBTOrganism).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    s re=##class(web.DHCBL.KB.DHCPHBTOrganism).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCPHBTOrganism).%New()
        s pobj = ##class(User.DHCPHBTOrganism).%OpenId(id)
        s eobj.BTORowId = id
        s eobj.BTOCode = pobj.BTOCode
        s eobj.BTODesc = pobj.BTODesc
        s eobj.BTOWhoNet=pobj.BTOWhoNet
        s eobj.BTOActiveFlag = pobj.BTOActiveFlag
        s eobj.BTOSysFlag = pobj.BTOSysFlag
    
        s sc=##class(User.DHCPHBTOrganism).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHBTOrganism","User.DHCPHBTOrganism","细菌字典",id,eobj.BTODesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("细菌字典","web.DHCBL.KB.DHCPHBTOrganism","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    q result
}

/// Description：获取适应证中已选细菌的串
/// Other: w ##class(web.DHCBL.KB.DHCPHBTOrganism).GetOrganismDr(67)
ClassMethod GetOrganismDr(InstId As %String) As %String
{
     s str=""
     if (InstId'="")
     {
        s PHORGRowId=0
        for
        {
            s PHORGRowId=$o(^DHCPHORGBUS(0,"Inst",InstId,PHORGRowId)) q:PHORGRowId=""
            s PHORGOrgDr=$p(^DHCPHORGBUS(PHORGRowId),"^",2) //细菌Dr
            s BTOCode=$p($g(^DHCPHBTORG(PHORGOrgDr)),"^",1) //细菌代码 
            s str="<"_BTOCode_">^"_str
        }
     }
     q str
}

/// 查询适应症中细菌已选列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHBTOrganism","GetOrganism","37")
Query GetOrganism(InstId) As %Query(ROWSPEC = "PHORGRowId,PHORGOrgDr,BTOCode,BTODesc")
{
}

ClassMethod GetOrganismExecute(ByRef qHandle As %Binary, InstId) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    if (InstId'="")
    {
        s PHORGRowId=0
        for
        {
            s PHORGRowId=$o(^DHCPHORGBUS(0,"Inst",InstId,PHORGRowId)) q:PHORGRowId=""
            s PHORGOrgDr=$p(^DHCPHORGBUS(PHORGRowId),"^",2) //细菌Dr
            s BTOCode="",BTODesc=""
            if (PHORGOrgDr'="") 
            {
                s BTOCode=$p($g(^DHCPHBTORG(PHORGOrgDr)),"^",1) //细菌代码 
                s BTODesc=$p($g(^DHCPHBTORG(PHORGOrgDr)),"^",2) //细菌描述          
                d OutputRowOrganism
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowOrganism
    set Data=$lb(PHORGRowId,PHORGOrgDr,BTOCode,BTODesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetOrganismClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOrganismExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetOrganismFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOrganismExecute ]
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

/// Description:根据细菌id删除细菌
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHBTOrganism).DeleteOrganismData("121")
ClassMethod DeleteOrganismData(id As %String) As %String
{
    s result=""
    if (id'="")
    {
        s sc=##class(User.DHCPHOrganismBus).%DeleteId(id)
        if $$$ISOK(sc)
        {
            s result="{success:'true',info:'删除成功！'}"
        }
        else
        {
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        }
    }
    else
    {
        s result= "{success:'false',info:'没有选中行'}"  //返回错误信息
    }
    q result
}

/// Description：查询未选细菌字典的列表内容
/// Table：User.DHCPHOrganismseList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHBTOrganism","GetUnSelOrganism","34")
Query GetUnSelOrganism(InstId As %String, OrganismStr As %String, desc As %String) As %Query(ROWSPEC = "BTORowId:%String,BTOCode:%String,BTODesc:%String")
{
}

ClassMethod GetUnSelOrganismExecute(ByRef qHandle As %Binary, InstId As %String, OrganismStr As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1

	s AuStr=##class(web.DHCBL.Authorize.DHCPHBTOrganism).DHCGetDataByDefaultSession()
	s AuFlag=0
	;未授权情况下，默认显示全部数据
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
		    
    s selectStr = ##class(web.DHCBL.KB.DHCPHBTOrganism).GetOrganismDr(InstId)
    s:desc'="" desc=$ZCONVERT(desc,"U")
    s BTORowId=0
    for {
        s BTORowId=$o(^DHCPHBTORG(BTORowId))
        q:BTORowId=""
		s strRowId="{ID:"_BTORowId_"}"
		if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
		{        
	        s BTOActiveFlag=$p($g(^DHCPHBTORG(BTORowId)),"^",4)  //是否可用
	        continue:BTOActiveFlag="N"
	        s BTOCode=$p($g(^DHCPHBTORG(BTORowId)),"^",1)
	        s Code = "<"_BTOCode_">"
	        s BTODesc=$p($g(^DHCPHBTORG(BTORowId)),"^",2)
	        s BTODescU=$ZCONVERT(BTODesc,"U")
	        s PINYIN=""
	        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BTODescU)
	        if ('(selectStr[Code))&('(OrganismStr[Code))&((BTODescU[desc)||(PINYIN[desc)) //2016-08-09
	        {
	            d OutputRowUn
	        }
		}
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowUn
    set Data=$lb(BTORowId,BTOCode,BTODesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelOrganismClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelOrganismExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetUnSelOrganismFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelOrganismExecute ]
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

}
