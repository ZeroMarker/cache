Class web.DHCBL.KB.DHCPHBtGenus Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2018-07-25
/// Description：获取修改时的记录
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHBtGenus).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHBtGenus).%New()
    s pobj = ##class(User.DHCPHBtGenus).%OpenId(id)
    s eobj.BTGERowId = id
    s eobj.BTGECode = pobj.BTGECode
    s eobj.BTGEDesc = pobj.BTGEDesc
    s eobj.BTGEActiveFlag = pobj.BTGEActiveFlag
    s eobj.BTGESysFlag = pobj.BTGESysFlag
    s:pobj.BTGEActiveFlag="" eobj.BTGEActiveFlag="Y"
    s:pobj.BTGESysFlag="" eobj.BTGESysFlag="Y"  

    s str = eobj.JsonS()    
    //s str = "{data:["_str_"]}"
    q str
}

/// Creator：谷雪萍
/// CreatDate: 2017-04-10
/// Description：查询菌属字典表内容
/// Table：User.DHCPHBtGenus
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHBtGenus","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "BTGERowId,BTGECode,BTGEDesc,BTGEActiveFlag,BTGESysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHBtGenus).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s BTGERowId=rowid 
        s BTGECode=$p($g(^DHCPHBTGE(BTGERowId)),"^",1)  //代码
        s BTGEDesc=$p($g(^DHCPHBTGE(BTGERowId)),"^",2)  //描述
        s BTGEActiveFlag=$p($g(^DHCPHBTGE(BTGERowId)),"^",3)  //是否可用
        s BTGESysFlag=$p($g(^DHCPHBTGE(BTGERowId)),"^",4)  //是否系统标识
        s:BTGEActiveFlag="" BTGEActiveFlag="Y"
        s:BTGESysFlag="" BTGESysFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s BTGERowId=0
        for  
        {   
            s BTGERowId=$o(^DHCPHBTGE(BTGERowId)) q:BTGERowId="" 
            s strRowId = "{ID:"_BTGERowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s BTGECode=$p($g(^DHCPHBTGE(BTGERowId)),"^",1)  //代码
                s BTGECodeU=$ZCONVERT(BTGECode,"U")
                s BTGEDesc=$p($g(^DHCPHBTGE(BTGERowId)),"^",2)  //描述
                s BTGEDescU=$ZCONVERT(BTGEDesc,"U")
                s BTGEActiveFlag=$p($g(^DHCPHBTGE(BTGERowId)),"^",3)  //是否可用
                s BTGESysFlag=$p($g(^DHCPHBTGE(BTGERowId)),"^",4)  //是否系统标识
                s:BTGEActiveFlag="" BTGEActiveFlag="Y"
        		s:BTGESysFlag="" BTGESysFlag="Y"
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(BTGEDescU))
                i (BTGECodeU[code)&((BTGEDescU[desc)||(PINYIN[desc))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(BTGERowId,BTGECode,BTGEDesc,BTGEActiveFlag,BTGESysFlag)
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
/// Description:查询 菌属
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHBtGenus","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "BTGERowId:%String,BTGEDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s BTGERowId=rowid
        s BTGEDesc=$p($g(^DHCPHBTGE(BTGERowId)),"^",2)
        s BTGEActiveFlag=$p($g(^DHCPHBTGE(BTGERowId)),"^",3)  //是否可用
        d:BTGEActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCPHBtGenus).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s BTGERowId=0
        for
        {
            s BTGERowId=$o(^DHCPHBTGE(BTGERowId)) q:BTGERowId=""
            s strRowId="{ID:"_BTGERowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s BTGEActiveFlag=$p($g(^DHCPHBTGE(BTGERowId)),"^",3)  //是否可用
                continue:BTGEActiveFlag="N"
                s BTGEDesc=$p($g(^DHCPHBTGE(BTGERowId)),"^",2)
                s BTGEDesc1=$ZCONVERT(BTGEDesc,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(BTGEDesc1))
                i (BTGEDesc1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(BTGERowId,BTGEDesc)
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
/// w ##class(web.DHCBL.KB.DHCPHBtGenus).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHBTGEi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHBTGEi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHBTGEi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHBTGEi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：谷雪萍
/// CreatDate: 2017-04-10
/// Description：保存修改内容
/// Table：User.DHCPHBtGenus
/// Input：web.Entity.KB.DHCPHBtGenus 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHBtGenus) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.BTGERowId,eobj.BTGECode,eobj.BTGEDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.BTGERowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHBtGenus).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHBtGenus).%OpenId(eobj.BTGERowId)
                
                s re=##class(web.DHCBL.KB.DHCPHBtGenus).GetRefFlag(eobj.BTGERowId)
                s RefFlag=$p(re,"^",1)
                s str=$p(re,"^",2)
                if (RefFlag=1)&(str["<菌属对照表>"){
                    s result = "{success:'false',errorinfo:'在菌属对照表中被引用，不能修改!'}"  //返回错误信息
                    q result
                }
                
                s bobj = ##class(web.Entity.KB.DHCPHBtGenus).%New()
                s bobj.BTGERowId = eobj.BTGERowId
                s bobj.BTGECode = obj.BTGECode
                s bobj.BTGEDesc = obj.BTGEDesc
                s bobj.BTGEActiveFlag= obj.BTGEActiveFlag
                s bobj.BTGESysFlag = obj.BTGESysFlag
            }
    
            s obj.BTGECode = eobj.BTGECode
            s obj.BTGEDesc = eobj.BTGEDesc
            i eobj.BTGEActiveFlag="Y"
            {
                s obj.BTGEActiveFlag = "Y"
            }
            else
            {
                s obj.BTGEActiveFlag = "N"
            }
            i eobj.BTGESysFlag="Y"
            {
                s obj.BTGESysFlag = "Y"
            }
            else
            {
                s obj.BTGESysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.BTGERowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHBtGenus","User.DHCPHBtGenus","菌属字典",id,eobj.BTGEDesc,"A",eobj)
                d:eobj.BTGERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHBtGenus","User.DHCPHBtGenus","菌属字典",eobj.BTGERowId,eobj.BTGEDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("菌属字典","web.DHCBL.KB.DHCPHBtGenus","SaveData",eobj)
                s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
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
/// Other: d ##class(web.DHCBL.KB.DHCPHBtGenus).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHBtGenus).%New()
    s pobj = ##class(User.DHCPHBtGenus).%OpenId(id)
    s eobj.BTGERowId = id
    s eobj.BTGECode = pobj.BTGECode
    s eobj.BTGEDesc = pobj.BTGEDesc
    s:pobj.BTGEActiveFlag="Y" eobj.BTGEActiveFlag="true"
    s:pobj.BTGESysFlag="Y" eobj.BTGESysFlag="true"  

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHBtGenus).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    
    s flag=0
    s BTGECode=$p($g(^DHCPHBTGE(id)),"^",1) 
    if ($d(^DHCPHGENUSCON(0,"Code",BTGECode))>0)
    {
        s myInfo=myInfo_"<菌属对照表>"
    }
    
    s PHGENRowId=0,flag=0
    for
    {
        s PHGENRowId=$o(^DHCPHGENUSBUS(PHGENRowId)) q:(PHGENRowId="")||(flag=1)  d
        s PHGENGenusDr=$p($g(^DHCPHGENUSBUS(PHGENRowId)),"^",2)
        i PHGENGenusDr=id
        {
            s flag=1
            s myInfo=myInfo_"<菌属业务表>"
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
/// Other:d ##class(web.DHCBL.KB.DHCPHBtGenus).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    s re=##class(web.DHCBL.KB.DHCPHBtGenus).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCPHBtGenus).%New()
        s pobj = ##class(User.DHCPHBtGenus).%OpenId(id)
        s eobj.BTGERowId = id
        s eobj.BTGECode = pobj.BTGECode
        s eobj.BTGEDesc = pobj.BTGEDesc
        s eobj.BTGEActiveFlag = pobj.BTGEActiveFlag
        s eobj.BTGESysFlag = pobj.BTGESysFlag
    
        s sc=##class(User.DHCPHBtGenus).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHBtGenus","User.DHCPHBtGenus","菌属字典",id,eobj.BTGEDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("菌属字典","web.DHCBL.KB.DHCPHBtGenus","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    q result
}

/// Description：获取用法用量中已选菌属的串
/// Other: w ##class(web.DHCBL.KB.DHCPHBtGenus).GetGenusDr(67)
ClassMethod GetGenusDr(InstId As %String) As %String
{
     s str=""
     if (InstId'="")
     {
        s PHGENRowId=0
        for
        {
            s PHGENRowId=$o(^DHCPHGENUSBUS(0,"Inst",InstId,PHGENRowId)) q:PHGENRowId=""
            s PHGENGenusDr=$p(^DHCPHGENUSBUS(PHGENRowId),"^",2) //菌属Dr
            s BTGECode=$p($g(^DHCPHBTGE(PHGENGenusDr)),"^",1) //菌属代码 
            s str="<"_BTGECode_">^"_str
        }
     }
     q str
}

/// 查询适应症中菌属已选列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHBtGenus","GetGenus","37")
Query GetGenus(InstId) As %Query(ROWSPEC = "PHGENRowId,PHGENGenusDr,BTGECode,BTGEDesc")
{
}

ClassMethod GetGenusExecute(ByRef qHandle As %Binary, InstId) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    //s AuStr=##class(web.DHCBL.Authorize.DHCPHBtGenus).DHCGetDataByDefaultSession()
    //s AuFlag=0
    ;未授权情况下，默认显示全部数据
    //if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    if (InstId'="")
    {
        s PHGENRowId=0
        for
        {
            s PHGENRowId=$o(^DHCPHGENUSBUS(0,"Inst",InstId,PHGENRowId)) q:PHGENRowId=""
            s PHGENGenusDr=$p(^DHCPHGENUSBUS(PHGENRowId),"^",2) //菌属Dr
           // s strRowId="{ID:"_PHGENGenusDr_"}"
			//if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			//{
	            s BTGECode="",BTGEDesc=""
	            if (PHGENGenusDr'="") 
	            {
	                s BTGECode=$p($g(^DHCPHBTGE(PHGENGenusDr)),"^",1) //菌属代码 
	                s BTGEDesc=$p($g(^DHCPHBTGE(PHGENGenusDr)),"^",2) //菌属描述            
	                d OutputRowGenus
	            }
			//}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowGenus
    set Data=$lb(PHGENRowId,PHGENGenusDr,BTGECode,BTGEDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetGenusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetGenusExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetGenusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetGenusExecute ]
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

/// Description:根据菌属id删除菌属
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHBtGenus).DeleteGenusData("121")
ClassMethod DeleteGenusData(id As %String) As %String
{
    s result=""
    if (id'="")
    {
        s sc=##class(User.DHCPHGenusBus).%DeleteId(id)
        if $$$ISOK(sc)
        {
            s result="{success:'true',info:'删除成功！'}"
        }
        else
        {
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
        }
    }
    else
    {
        s result= "{success:'false',info:'没有选中行'}"  //返回错误信息
    }
    q result
}

/// Description：查询未选菌属字典的列表内容
/// Table：User.DHCPHGenusseList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHBtGenus","GetUnSelGenus","34")
Query GetUnSelGenus(InstId As %String, GenusStr As %String, desc As %String) As %Query(ROWSPEC = "BTGERowId:%String,BTGECode:%String,BTGEDesc:%String")
{
}

ClassMethod GetUnSelGenusExecute(ByRef qHandle As %Binary, InstId As %String, GenusStr As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s AuStr=##class(web.DHCBL.Authorize.DHCPHBtGenus).DHCGetDataByDefaultSession()
    s AuFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1    
    s selectStr = ##class(web.DHCBL.KB.DHCPHBtGenus).GetGenusDr(InstId)
    s:desc'="" desc=$ZCONVERT(desc,"U")
    s BTGERowId=0
    for {
        s BTGERowId=$o(^DHCPHBTGE(BTGERowId))
        q:BTGERowId=""
		s strRowId="{ID:"_BTGERowId_"}"
		if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
		{        
	        s BTGEActiveFlag=$p($g(^DHCPHBTGE(BTGERowId)),"^",3)  //是否可用
	        continue:BTGEActiveFlag="N"
	        s BTGECode=$p($g(^DHCPHBTGE(BTGERowId)),"^",1)
	        s Code = "<"_BTGECode_">"
	        s BTGEDesc=$p($g(^DHCPHBTGE(BTGERowId)),"^",2)
	        s BTGEDescU=$ZCONVERT(BTGEDesc,"U")
	        s PINYIN=""
	        s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BTGEDescU)
	        if ('(selectStr[Code))&('(GenusStr[Code))&((BTGEDescU[desc)||(PINYIN[desc)) //2016-08-09
	        {
	            d OutputRowUn
	        }
		}    
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowUn
    set Data=$lb(BTGERowId,BTGECode,BTGEDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelGenusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelGenusExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetUnSelGenusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelGenusExecute ]
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
