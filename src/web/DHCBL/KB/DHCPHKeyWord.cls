Class web.DHCBL.KB.DHCPHKeyWord Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2018-07-25
/// Description：获取修改时的记录
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHKeyWord).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHKeyWord).%New()
    s pobj = ##class(User.DHCPHKeyWord).%OpenId(id)
    s eobj.PHKWRowId = id
    s eobj.PHKWCode = pobj.PHKWCode
    s eobj.PHKWDesc = pobj.PHKWDesc
    s eobj.PHKWActiveFlag = pobj.PHKWActiveFlag
    s eobj.PHKWSysFlag = pobj.PHKWSysFlag
    s:pobj.PHKWActiveFlag="" eobj.PHKWActiveFlag="Y"
    s:pobj.PHKWSysFlag="" eobj.PHKWSysFlag="Y"  
    s eobj.PHKWTypeFlag = pobj.PHKWTypeFlag
    s str = eobj.JsonS()    
    //s str = "{data:["_str_"]}"
    q str
}

/// Creator：谷雪萍
/// CreatDate: 2017-3-23
/// Description：查询知识库关键表内容
/// Table：User.DHCPHKeyWord
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHKeyWord","GetList","","","","","")
Query GetList(rowid, code, desc, type) As %Query(ROWSPEC = "PHKWRowId,PHKWCode,PHKWDesc,PHKWTypeFlag,PHKWActiveFlag,PHKWSysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc, type) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHKeyWord).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHKWRowId=rowid 
        s PHKWCode=$p($g(^DHCPHKW(PHKWRowId)),"^",1)  //代码
        s PHKWDesc=$p($g(^DHCPHKW(PHKWRowId)),"^",2)  //描述
        s PHKWActiveFlag=$p($g(^DHCPHKW(PHKWRowId)),"^",3)  //是否可用
        s PHKWSysFlag=$p($g(^DHCPHKW(PHKWRowId)),"^",4)  //是否系统标识
        s PHKWTypeFlag=$p($g(^DHCPHKW(PHKWRowId)),"^",5)  //分类标识
        s:PHKWActiveFlag="" PHKWActiveFlag="Y"
        s:PHKWSysFlag="" PHKWSysFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s PHKWRowId=0
        for  
        {   
            s PHKWRowId=$o(^DHCPHKW(PHKWRowId)) q:PHKWRowId="" 
            s strRowId = "{ID:"_PHKWRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s PHKWCode=$p($g(^DHCPHKW(PHKWRowId)),"^",1)  //代码
                s PHKWCodeU=$ZCONVERT(PHKWCode,"U")
                s PHKWDesc=$p($g(^DHCPHKW(PHKWRowId)),"^",2)  //描述
                s PHKWDescU=$ZCONVERT(PHKWDesc,"U")
                s PHKWActiveFlag=$p($g(^DHCPHKW(PHKWRowId)),"^",3)  //是否可用
                s PHKWSysFlag=$p($g(^DHCPHKW(PHKWRowId)),"^",4)  //是否系统标识
                s PHKWTypeFlag=$p($g(^DHCPHKW(PHKWRowId)),"^",5)  //分类标识
                s:PHKWActiveFlag="" PHKWActiveFlag="Y"
        		s:PHKWSysFlag="" PHKWSysFlag="Y"
        
                s PINYIN=""
                if (desc'="")
                {
                    s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHKWDescU)
                }
                i (PHKWCodeU[code)&((PHKWDescU[desc)||(PINYIN[desc))&((PHKWTypeFlag=type)||(type=""))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHKWRowId,PHKWCode,PHKWDesc,PHKWTypeFlag,PHKWActiveFlag,PHKWSysFlag)
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
/// CreatDate:2014-12-4
/// Description:查询 单位
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHKeyWord","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String, type As %String) As %Query(ROWSPEC = "PHKWRowId:%String,PHKWDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String, type As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHKeyWord).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    if (rowid'="")
    {
        s PHKWRowId=rowid
        s PHKWDesc=$p($g(^DHCPHKW(PHKWRowId)),"^",2)
        s PHKWTypeFlag=$p($g(^DHCPHKW(PHKWRowId)),"^",5)  //分类标识
        s PHKWActiveFlag=$p($g(^DHCPHKW(PHKWRowId)),"^",3)  //是否可用
        d:PHKWActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s PHKWRowId=0
        for
        {
            s PHKWRowId=$o(^DHCPHKW(PHKWRowId)) q:PHKWRowId=""
            s strRowId="{ID:"_PHKWRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
	            s PHKWActiveFlag=$p($g(^DHCPHKW(PHKWRowId)),"^",3)  //是否可用
	            continue:PHKWActiveFlag="N"
	            s PHKWDesc=$p($g(^DHCPHKW(PHKWRowId)),"^",2)
	            s PHKWTypeFlag=$p($g(^DHCPHKW(PHKWRowId)),"^",5)  //分类标识
	            s PHKWDesc1=$ZCONVERT(PHKWDesc,"U")
	            s PINYIN=""
	            s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHKWDesc1)
	            i ((PHKWDesc1[desc)||(PINYIN[desc))&((PHKWTypeFlag=type)||(type=""))
	            {
	                d OutputRowCmb
	            }
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHKWRowId,PHKWDesc)
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
/// CreateDate:2017-3-23    
/// w ##class(web.DHCBL.KB.DHCPHKeyWord).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String, type As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    if (type'="")
    {
        s:code'="" flagc=$d(^DHCPHKWi(0,"Code",type,code))
        s:desc'="" flagd=$d(^DHCPHKWi(0,"Desc",type,desc))
        if (id="") //如果为空，增加时的重复判断
        {
            if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
            else  s flag=0 //返回不重复标志
        }
        else //如果不为空，修改时的重复判断
        {
            s idc="",idd=""
            s:code'="" idc=$o(^DHCPHKWi(0,"Code",type,code,0))
            s:desc'="" idd=$o(^DHCPHKWi(0,"Desc",type,desc,0))
            if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
            else  s flag=0 //返回不重复标志
        }
    }
    q flag
}

/// Creator：谷雪萍
/// CreatDate: 2017-3-23
/// Description：保存修改内容
/// Table：User.DHCPHKeyWord
/// Input：web.Entity.KB.DHCPHKeyWord 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHKeyWord) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
                
        s flag=..FormValidate(eobj.PHKWRowId,eobj.PHKWCode,eobj.PHKWDesc,eobj.PHKWTypeFlag)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.PHKWRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHKeyWord).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHKeyWord).%OpenId(eobj.PHKWRowId)                
                s bobj = ##class(web.Entity.KB.DHCPHKeyWord).%New()
                s bobj.PHKWRowId = eobj.PHKWRowId
                s bobj.PHKWCode = obj.PHKWCode
                s bobj.PHKWDesc = obj.PHKWDesc
                s bobj.PHKWActiveFlag= obj.PHKWActiveFlag
                s bobj.PHKWSysFlag = obj.PHKWSysFlag
                s bobj.PHKWTypeFlag=obj.PHKWTypeFlag
            }
    
            s obj.PHKWCode = eobj.PHKWCode
            s obj.PHKWDesc = eobj.PHKWDesc
            i eobj.PHKWActiveFlag="Y"
            {
                s obj.PHKWActiveFlag = "Y"
            }
            else
            {
                s obj.PHKWActiveFlag = "N"
            }
            i eobj.PHKWSysFlag="Y"
            {
                s obj.PHKWSysFlag = "Y"
            }
            else
            {
                s obj.PHKWSysFlag = "N"
            }

            s obj.PHKWTypeFlag=eobj.PHKWTypeFlag
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
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库关键表","web.DHCBL.KB.DHCPHKeyWord","SaveData",eobj)
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
/// CreatDate: 2017-3-23
/// Description：获取修改时的记录
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHKeyWord).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHKeyWord).%New()
    s pobj = ##class(User.DHCPHKeyWord).%OpenId(id)
    s eobj.PHKWRowId = id
    s eobj.PHKWCode = pobj.PHKWCode
    s eobj.PHKWDesc = pobj.PHKWDesc
    s:pobj.PHKWActiveFlag="Y" eobj.PHKWActiveFlag="true"
    s:pobj.PHKWSysFlag="Y" eobj.PHKWSysFlag="true"  
    s eobj.PHKWTypeFlag = pobj.PHKWTypeFlag
    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHKeyWord).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    
    ;User.DHCPHDrgAlone
    s RowId=0,flag=0
    for
    {
        s RowId=$o(^DHCPHCU(RowId)) q:(RowId="")||(flag=1)  d
        s keyDr=$p($g(^DHCPHCU(RowId)),"^",2)
        i keyDr=id
        {
            s flag=1
            s myInfo=myInfo_"<药品说明书编辑器-治疗手术业务表>"
        }
    }
    
    ;User.DHCPHMustDrug
    s RowId=0,flag=0
    for
    {
        s RowId=$o(^DHCPHSYM(RowId)) q:(RowId="")||(flag=1)  d
        s keyDr=$p($g(^DHCPHSYM(RowId)),"^",2)
        i (keyDr=id)
        {
            s flag=1
            s myInfo=myInfo_"<药品说明书编辑器-症状业务表>"
        }
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Creator:谷雪萍
/// CreatDate:2017-3-23
/// Description:根据id删除
/// Table:User.DHCPHExtIngr
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHKeyWord).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    s re=##class(web.DHCBL.KB.DHCPHKeyWord).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        
        s eobj = ##class(web.Entity.KB.DHCPHKeyWord).%New()
        s pobj = ##class(User.DHCPHKeyWord).%OpenId(id)
        s eobj.PHKWRowId = id
        s eobj.PHKWCode = pobj.PHKWCode
        s eobj.PHKWDesc = pobj.PHKWDesc
        s eobj.PHKWActiveFlag = pobj.PHKWActiveFlag
        s eobj.PHKWSysFlag = pobj.PHKWSysFlag
        s eobj.PHKWTypeFlag = pobj.PHKWTypeFlag

        Tstart
        s sc=##class(User.DHCPHKeyWord).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHKeyWord","User.DHCPHKeyWord","知识库关键表",id,eobj.PHKWDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("知识库关键表","web.DHCBL.KB.DHCPHKeyWord","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    q result
}

/// Description：获取用法用量中已选病症的串
/// Other: w ##class(web.DHCBL.KB.DHCPHKeyWord).GetKeyDr(67)
ClassMethod GetKeyDr(InstId As %String, type As %String) As %String
{
 s str=""
 if (InstId'="")
 {
    if (type="1")
    {
        s BusRowId=0
        for
        {
            s BusRowId=$o(^DHCPHCU(0,"Inst",InstId,BusRowId)) q:BusRowId=""
            s KeyDr=$p(^DHCPHCU(BusRowId),"^",2) //病症Dr
            s str="<"_KeyDr_">^"_str
        }
    }
    if (type="0")
    {
        s BusRowId=0
        for
        {
            s BusRowId=$o(^DHCPHSYM(0,"Inst",InstId,BusRowId)) q:BusRowId=""
            s KeyDr=$p(^DHCPHSYM(BusRowId),"^",2) //病症Dr
            s str="<"_KeyDr_">^"_str
        }
    }
 }
 q str
}

/// 查询适应症中病症已选列表
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHKeyWord","GetKeyList","37")
Query GetKeyList(InstId, type) As %Query(ROWSPEC = "BusRowId,KeyDr,KeyCode,KeyDesc")
{
}

ClassMethod GetKeyListExecute(ByRef qHandle As %Binary, InstId, type) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    if (InstId'="")
    {
        if (type="1") //治疗手术业务表
        {
            s BusRowId=0
            for
            {
                s BusRowId=$o(^DHCPHCU(0,"Inst",InstId,BusRowId)) q:BusRowId=""
                s KeyDr=$p(^DHCPHCU(BusRowId),"^",2) //病症Dr
                s KeyCode="",KeyDesc=""
                if (KeyDr'="") 
                {
                    s KeyCode=$p($g(^DHCPHKW(KeyDr)),"^",1) //病症代码 
                    s KeyDesc=$p($g(^DHCPHKW(KeyDr)),"^",2) //病症描述          
                    d OutputRowKey
                }
            }
        }
        if (type="0") //症状业务表
        {
            s BusRowId=0
            for
            {
                s BusRowId=$o(^DHCPHSYM(0,"Inst",InstId,BusRowId)) q:BusRowId=""
                s KeyDr=$p(^DHCPHSYM(BusRowId),"^",2) //病症Dr
                s KeyCode="",KeyDesc=""
                if (KeyDr'="") 
                {
                    s KeyCode=$p($g(^DHCPHKW(KeyDr)),"^",1) //病症代码 
                    s KeyDesc=$p($g(^DHCPHKW(KeyDr)),"^",2) //病症描述          
                    d OutputRowKey
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowKey
    set Data=$lb(BusRowId,KeyDr,KeyCode,KeyDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetKeyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetKeyListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetKeyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetKeyListExecute ]
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

/// Description:根据病症id删除病症
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHKeyWord).DeleteKeyData("121")
ClassMethod DeleteKeyData(id As %String, type As %String) As %String
{
    s result=""
    
    if (id'="")
    {
        s sc=""
        if (type="1")
        {
            s sc=##class(User.DHCPHCure).%DeleteId(id)
        }
        if (type="0")
        {
            s sc=##class(User.DHCPHSymptomBus).%DeleteId(id)
        }
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

/// Description：查询未选病症字典的列表内容
/// Table：User.DHCPHKeyWord
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHKeyWord","GetUnSelKeyList","3356","","","0")
Query GetUnSelKeyList(InstId As %String, KeyStr As %String, desc As %String, type As %String) As %Query(ROWSPEC = "KeyRowId:%String,KeyCode:%String,KeyDesc:%String")
{
}

ClassMethod GetUnSelKeyListExecute(ByRef qHandle As %Binary, InstId As %String, KeyStr As %String, desc As %String, type As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHKeyWord).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1    
    s:desc'="" desc=$ZCONVERT(desc,"U")
    if (type'="")
    {
        s selectStr = ##class(web.DHCBL.KB.DHCPHKeyWord).GetKeyDr(InstId,type)
        s KeyRowId=0
        for
        {
            s KeyRowId=$o(^DHCPHKWi(0,"Type",type,KeyRowId))
            q:KeyRowId=""
            s strRowId="{ID:"_KeyRowId_"}"
			if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
			{
	            s PHKWActiveFlag=$p($g(^DHCPHKW(KeyRowId)),"^",3)  //是否可用
	            continue:PHKWActiveFlag="N"
	            s strRowId = "<"_KeyRowId_">"
	            s KeyCode=$p($g(^DHCPHKW(KeyRowId)),"^",1)  
	            s KeyDesc=$p($g(^DHCPHKW(KeyRowId)),"^",2)
	            s KeyFlag=$p($g(^DHCPHKW(KeyRowId)),"^",5)  //分类标识
	            s KeyDescU=$ZCONVERT(KeyDesc,"U")
	            s:desc'="" PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(KeyDescU)
	            if ('(selectStr[strRowId))&('(KeyStr[strRowId))&((KeyDescU[desc)||(PINYIN[desc)) //2016-08-09
	            {
	                d OutputRowUn
	            }
			}
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowUn
    set Data=$lb(KeyRowId,KeyCode,KeyDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelKeyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelKeyListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetUnSelKeyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelKeyListExecute ]
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
