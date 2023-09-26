Class web.DHCBL.KB.DHCPHProName Extends %RegisteredObject
{

/// Creator：石萧伟
/// CreatDate: 2018-08-11
/// Description：获取修改时的记录
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHProName).OpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHProName).%New()
    s pobj = ##class(User.DHCPHProName).%OpenId(id)
    s eobj.PHNRowId = id
    s eobj.PHNCode = pobj.PHNCode
    s eobj.PHNDesc = pobj.PHNDesc
    s eobj.PHNActiveFlag = pobj.PHNActiveFlag
    s eobj.PHNSysFlag = pobj.PHNSysFlag
    s eobj.PHNWholeFlag = pobj.PHNWholeFlag
    s:pobj.PHNActiveFlag="" eobj.PHNActiveFlag="Y"
    s:pobj.PHNSysFlag="" eobj.PHNSysFlag="Y"
    //s pobj.PHNWholeFlag=eobj.PHNWholeFlag    
    s eobj.PHNFactory = pobj.PHNFactory
    if $IsObject(pobj.PHNFormDr){
        s eobj.PHNFormDr = pobj.PHNFormDr.%Id() 
    }
    if $IsObject(pobj.PHNGenericDr){
        s eobj.PHNGenericDr = pobj.PHNGenericDr.%Id() 
    }
    if $IsObject(pobj.PHNToxicity){
        s eobj.PHNToxicity = pobj.PHNToxicity.%Id() 
    }
    if $IsObject(pobj.PHNManfDR){
        s eobj.PHNManfDR = pobj.PHNManfDR.%Id() 
    }
    s str = eobj.JsonS()    
    //s str = "{data:["_str_"]}"
    q str
}

/// Creator：谷雪萍
/// CreatDate: 2016-9-30
/// Description：查询药品商品名字典表内容
/// Table：User.DHCPHProName
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHProName","GetList","","","","","")
Query GetList(rowid, code, desc, form) As %Query(ROWSPEC = "PHNRowId,PHNCode,PHNDesc,PHNFormDr,PHNFactory,PHNActiveFlag,PHNSysFlag,PHNGenericDr,PHNToxicity,PHNManfDR,PHNWholeFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc, form) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHProName).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHNRowId=rowid 
        s PHNCode=$p($g(^DHCPHPNA(PHNRowId)),"^",1)  //代码
        s PHNDesc=$p($g(^DHCPHPNA(PHNRowId)),"^",2)  //描述
        s PHNActiveFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",3)  //是否可用
        s PHNSysFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",4)  //是否系统标识
        s:PHNActiveFlag="" PHNActiveFlag="Y"
        s:PHNSysFlag="" PHNSysFlag="Y"
        s PHNFormDr=$p($g(^DHCPHPNA(PHNRowId)),"^",5)  //剂型
        s:PHNFormDr'="" PHNFormDr=$p($g(^DHCPHEF(PHNFormDr)),"^",2) 
        s PHNFactory=$p($g(^DHCPHPNA(PHNRowId)),"^",6)  //厂家
        s PHNGenericDr=$p($g(^DHCPHPNA(PHNRowId)),"^",7)  //通用名
        s:PHNGenericDr'="" PHNGenericDr=$p($g(^DHCPHEGEN(PHNGenericDr)),"^",2) 
        s PHNToxicity=$p($g(^DHCPHPNA(PHNRowId)),"^",8)  //毒性
        s:PHNToxicity'="" PHNToxicity=$p($g(^DHCPHTOX(PHNToxicity)),"^",2) 
        s PHNManfDR = $p($g(^DHCPHPNA(PHNRowId)),"^",10) //厂家字典
        s:PHNManfDR'="" PHNManfDR=$p($g(^DHCPHMANF(PHNManfDR)),"^",2)
        s PHNWholeFlag = $p($g(^DHCPHPNA(PHNRowId)),"^",9) //是否整支
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s PHNRowId=0
        for  
        {   
            s PHNRowId=$o(^DHCPHPNA(PHNRowId)) q:PHNRowId="" 
            s strRowId = "{ID:"_PHNRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s PHNCode=$p($g(^DHCPHPNA(PHNRowId)),"^",1)  //代码
                s PHNCodeU=$ZCONVERT(PHNCode,"U")
                s PHNDesc=$p($g(^DHCPHPNA(PHNRowId)),"^",2)  //描述
                s PHNDescU=$ZCONVERT(PHNDesc,"U")
                s PHNActiveFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",3)  //是否可用
                s PHNSysFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",4)  //是否系统标识
                s:PHNActiveFlag="" PHNActiveFlag="Y"
        		s:PHNSysFlag="" PHNSysFlag="Y"
        
                s FormDr=$p($g(^DHCPHPNA(PHNRowId)),"^",5)  //剂型
                s PHNFormDr=""
                s:FormDr'="" PHNFormDr=$p($g(^DHCPHEF(FormDr)),"^",2) 
                s PHNFactory=$p($g(^DHCPHPNA(PHNRowId)),"^",6)  //厂家
                s PHNGenericDr=$p($g(^DHCPHPNA(PHNRowId)),"^",7)  //通用名
                s:PHNGenericDr'="" PHNGenericDr=$p($g(^DHCPHEGEN(PHNGenericDr)),"^",2) 
                s PHNToxicity=$p($g(^DHCPHPNA(PHNRowId)),"^",8)  //毒性
                s:PHNToxicity'="" PHNToxicity=$p($g(^DHCPHTOX(PHNToxicity)),"^",2) 
                s PHNManfDR = $p($g(^DHCPHPNA(PHNRowId)),"^",10) //厂家字典
                s:PHNManfDR'="" PHNManfDR=$p($g(^DHCPHMANF(PHNManfDR)),"^",2)
                s PHNWholeFlag = $p($g(^DHCPHPNA(PHNRowId)),"^",9) //是否整支
                //别名查询
                s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","DHC_PHProName",PHNRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                    
                }
                
                s PINYIN=""
                if ((ALIASText1="")&(desc'=""))
                {
                    s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHNDescU))
                }
                i (PHNCodeU[code)&((PHNDescU[desc)||(PINYIN[desc)||(ALIASText1[desc))&((FormDr=form)||(form=""))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHNRowId,PHNCode,PHNDesc,PHNFormDr,PHNFactory,PHNActiveFlag,PHNSysFlag,PHNGenericDr,PHNToxicity,PHNManfDR,PHNWholeFlag)
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

/// Creator：谷雪萍
/// CreatDate: 2018-02-13
/// Description：药品说明书编辑器-药品商品名列表
/// Table：User.DHCPHProName
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHProName","GetDataForCmb2","","","","","")
Query GetDataForCmb2(rowid, code, desc, form) As %Query(ROWSPEC = "PHNRowId,PHNDesc,PHNFormDr,PHNFactory,PHNToxicity,PHNManfDR")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid, code, desc, form) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHProName).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHNRowId=rowid 
        s PHNCode=$p($g(^DHCPHPNA(PHNRowId)),"^",1)  //代码
        s PHNDesc=$p($g(^DHCPHPNA(PHNRowId)),"^",2)  //描述
        s PHNActiveFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",3)  //是否可用
        s PHNFactory=$p($g(^DHCPHPNA(PHNRowId)),"^",6)  //厂家
        s PHNToxicity=$p($g(^DHCPHPNA(PHNRowId)),"^",8)  //毒性
        s:PHNToxicity'="" PHNToxicity=$p($g(^DHCPHTOX(PHNToxicity)),"^",2) 
        s PHNManfDR = $p($g(^DHCPHPNA(PHNRowId)),"^",10) //厂家字典
        s:PHNManfDR'="" PHNManfDR=$p($g(^DHCPHMANF(PHNManfDR)),"^",2)
        d OutputRowCmb2
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s PHNRowId=0
        for  
        {   
            s PHNRowId=$o(^DHCPHPNA(PHNRowId)) q:PHNRowId="" 
            s strRowId = "{ID:"_PHNRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s PHNCode=$p($g(^DHCPHPNA(PHNRowId)),"^",1)  //代码
                s PHNCodeU=$ZCONVERT(PHNCode,"U")
                s PHNDesc=$p($g(^DHCPHPNA(PHNRowId)),"^",2)  //描述
                s PHNDescU=$ZCONVERT(PHNDesc,"U")
                s PHNActiveFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",3)  //是否可用
                continue:PHNActiveFlag="N"
                s FormDr=$p($g(^DHCPHPNA(PHNRowId)),"^",5)  //剂型
                s PHNFormDr=""
                s:FormDr'="" PHNFormDr=$p($g(^DHCPHEF(FormDr)),"^",2) 
                s PHNFactory=$p($g(^DHCPHPNA(PHNRowId)),"^",6)  //厂家
                s PHNToxicity=$p($g(^DHCPHPNA(PHNRowId)),"^",8)  //毒性
                s:PHNToxicity'="" PHNToxicity=$p($g(^DHCPHTOX(PHNToxicity)),"^",2) 
                s PHNManfDR = $p($g(^DHCPHPNA(PHNRowId)),"^",10) //厂家字典
                s:PHNManfDR'="" PHNManfDR=$p($g(^DHCPHMANF(PHNManfDR)),"^",2)
                //别名查询
                s ALIASText1=""
                s AliasRowId=0
                for{
                    s AliasRowId=$o(^User.BDPAliasI("DataRef","DHC_PHProName",PHNRowId,AliasRowId))
                    q:AliasRowId=""
                    S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
                    s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
                    
                }
                
                s PINYIN=""
                if ((ALIASText1="")&(desc'=""))
                {
                    s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHNDescU))
                }
                i (PHNCodeU[code)&((PHNDescU[desc)||(PINYIN[desc)||(ALIASText1[desc))&((FormDr=form)||(form=""))   //条件
                {
                    d OutputRowCmb2
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb2
    set Data=$lb(PHNRowId,PHNDesc,PHNFormDr,PHNFactory,PHNToxicity,PHNManfDR)
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
/// CreatDate:2014-12-4
/// Description:查询 单位
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHProName","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "PHNRowId:%String,PHNDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHProName).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1    
    if (rowid'="")
    {
        s PHNRowId=rowid
        s PHNDesc=$p($g(^DHCPHPNA(PHNRowId)),"^",2)
        s PHNActiveFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",3)  //是否可用
        d:PHNActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s PHNRowId=0
        for
        {
            s PHNRowId=$o(^DHCPHPNA(PHNRowId)) q:PHNRowId=""
            s strRowId = "{ID:"_PHNRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
	            s PHNActiveFlag=$p($g(^DHCPHPNA(PHNRowId)),"^",3)  //是否可用
	            continue:PHNActiveFlag="N"
	            s PHNDesc=$p($g(^DHCPHPNA(PHNRowId)),"^",2)
	            s PHNDesc1=$ZCONVERT(PHNDesc,"U")
	            s PINYIN=""
	            s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHNDesc1))
	            i ((PHNDesc1[desc)||(PINYIN[desc))
	            {
	                d OutputRowCmb
	            }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHNRowId,PHNDesc)
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
/// CreateDate:2016-9-30    
/// w ##class(web.DHCBL.KB.DHCPHProName).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHPNA(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHPNA(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHPNA(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHPNA(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：谷雪萍
/// CreatDate: 2016-9-30
/// Description：保存修改内容
/// Table：User.DHCPHProName
/// Input：web.Entity.KB.DHCPHProName 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHProName, hacom As %String) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
                
        s flag=..FormValidate(eobj.PHNRowId,eobj.PHNCode,eobj.PHNDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.PHNRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHProName).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHProName).%OpenId(eobj.PHNRowId)             
                s bobj = ##class(web.Entity.KB.DHCPHProName).%New()
                s bobj.PHNRowId = eobj.PHNRowId
                s bobj.PHNCode = obj.PHNCode
                s bobj.PHNDesc = obj.PHNDesc
                s bobj.PHNActiveFlag= obj.PHNActiveFlag
                s bobj.PHNSysFlag = obj.PHNSysFlag
                s bobj.PHNWholeFlag = obj.PHNWholeFlag
                if $IsObject(obj.PHNFormDr){
                    s bobj.PHNFormDr = obj.PHNFormDr.%Id() 
                }
                s bobj.PHNFactory=obj.PHNFactory
                if $IsObject(obj.PHNGenericDr){
                    s bobj.PHNGenericDr = obj.PHNGenericDr.%Id() 
                }
                if $IsObject(obj.PHNToxicity){
                    s bobj.PHNToxicity = obj.PHNToxicity.%Id() 
                }
                if $IsObject(obj.PHNManfDR){
                    s bobj.PHNManfDR = obj.PHNManfDR.%Id() 
                }
            }
    
            s obj.PHNCode = eobj.PHNCode
            s obj.PHNDesc = eobj.PHNDesc
            i eobj.PHNActiveFlag="Y"
            {
                s obj.PHNActiveFlag = "Y"
            }
            else
            {
                s obj.PHNActiveFlag = "N"
            }
            i eobj.PHNSysFlag="Y"
            {
                s obj.PHNSysFlag = "Y"
            }
            else
            {
                s obj.PHNSysFlag = "N"
            }
            i eobj.PHNWholeFlag="Y"
            {
                s obj.PHNWholeFlag = "Y"
            }
            else
            {
                s obj.PHNWholeFlag = "N"
            }
            d obj.PHNFormDrSetObjectId(eobj.PHNFormDr)
            s obj.PHNFactory=eobj.PHNFactory
            d obj.PHNGenericDrSetObjectId(eobj.PHNGenericDr)
            d obj.PHNToxicitySetObjectId(eobj.PHNToxicity)
            d obj.PHNManfDRSetObjectId(eobj.PHNManfDR)

            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.PHNRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHProName","User.DHCPHProName","药品商品名字典",id,eobj.PHNDesc,"A",eobj)
                d:eobj.PHNRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHProName","User.DHCPHProName","药品商品名字典",eobj.PHNRowId,eobj.PHNDesc,"U",eobj,bobj)
                if ((eobj.PHNRowId="")&(hacom'="Y"))
                {
                    s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(eobj.PHNDesc))
                    s listData="^DHC_PHProName^"_PINYIN_"^"_id
                    d ##class(web.DHCBL.BDP.BDPAlias).SaveEntity(listData)
                }
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品商品名字典","web.DHCBL.KB.DHCPHProName","SaveData",eobj)
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
/// CreatDate: 2016-9-30
/// Description：获取修改时的记录
/// Table：User.DHCPHExtIngr
/// Other: d ##class(web.DHCBL.KB.DHCPHProName).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHProName).%New()
    s pobj = ##class(User.DHCPHProName).%OpenId(id)
    s eobj.PHNRowId = id
    s eobj.PHNCode = pobj.PHNCode
    s eobj.PHNDesc = pobj.PHNDesc
    s:pobj.PHNActiveFlag="Y" eobj.PHNActiveFlag="true"
    s:pobj.PHNSysFlag="Y" eobj.PHNSysFlag="true"
    s:pobj.PHNWholeFlag="Y" eobj.PHNWholeFlag="true"    
    s eobj.PHNFactory = pobj.PHNFactory
    if $IsObject(pobj.PHNFormDr){
        s eobj.PHNFormDr = pobj.PHNFormDr.%Id() 
    }
    if $IsObject(pobj.PHNGenericDr){
        s eobj.PHNGenericDr = pobj.PHNGenericDr.%Id() 
    }
    if $IsObject(pobj.PHNToxicity){
        s eobj.PHNToxicity = pobj.PHNToxicity.%Id() 
    }
    if $IsObject(pobj.PHNManfDR){
        s eobj.PHNManfDR = pobj.PHNManfDR.%Id() 
    }
    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHProName).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    
    s flag=0
    s PHNCode=$p($g(^DHCPHPNA(id)),"^",1) 
    s PHPCRowId=0
    for  
    {   
        s PHPCRowId=$o(^DHCPHPCO(PHPCRowId)) q:PHPCRowId=""||(flag=1)  d 
        s PHUCTCode=$p($g(^DHCPHPCO(PHPCRowId)),"^",1)  //his代码
        i (PHUCTCode=PHNCode){
            s flag=1
            s myInfo=myInfo_"<商品名与His对照>"   
        }   
    }
    i $d(^DHCPHMITi(0,"Drug",+id)) s myInfo=myInfo_"<溶媒分类明细表>"
    ;User.DHCPHDiseaseInteract
    s RowId=0,flag=0
    for
    {
        s RowId=$o(^DHCPHDINTER(RowId)) q:(RowId="")||(flag=1)  d
        s DrugDr=$p($g(^DHCPHDINTER(RowId)),"^",6)
        i DrugDr=id
        {
            s flag=1
            s myInfo=myInfo_"<药品说明书编辑器-相互作用或配伍禁忌>"
        }
    }
    ;User.DHCPHDrgSolvent
    s RowId=0,flag=0
    for
    {
        s RowId=$o(^DHCPHDST(RowId)) q:(RowId="")||(flag=1)  d
        s DrugDr=$p($g(^DHCPHDST(RowId)),"^",2)
        i DrugDr=id
        {
            s flag=1
            s myInfo=myInfo_"<药品说明书编辑器-浓度>"
        }
    }

    ;User.DHCPHDrgAlone
    s RowId=0,flag=0
    for
    {
        s RowId=$o(^DHCPHDAL(RowId)) q:(RowId="")||(flag=1)  d
        s DrugDr=$p($g(^DHCPHDAL(RowId)),"^",1)
        i DrugDr=id
        {
            s flag=1
            s myInfo=myInfo_"<药品说明书编辑器-可配伍药品>"
        }
    }
    
    ;User.DHCPHMustDrug
    s RowId=0,flag=0
    for
    {
        s RowId=$o(^DHCPHMD(RowId)) q:(RowId="")||(flag=1)  d
        s DrugDr1=$p($g(^DHCPHMD(RowId)),"^",2)
        s DrugDr2=$p($g(^DHCPHMD(RowId)),"^",3)
        i (DrugDr1=id)||(DrugDr2=id)
        {
            s flag=1
            s myInfo=myInfo_"<药品说明书编辑器-联合用药>"
        }
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Creator:谷雪萍
/// CreatDate:2016-9-30
/// Description:根据id删除
/// Table:User.DHCPHExtIngr
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHProName).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    s re=##class(web.DHCBL.KB.DHCPHProName).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCPHProName).%New()
        s pobj = ##class(User.DHCPHProName).%OpenId(id)
        s eobj.PHNRowId = id
        s eobj.PHNCode = pobj.PHNCode
        s eobj.PHNDesc = pobj.PHNDesc
        s eobj.PHNActiveFlag = pobj.PHNActiveFlag
        s eobj.PHNSysFlag = pobj.PHNSysFlag
        s eobj.PHNFactory = pobj.PHNFactory
        s eobj.PHNWholeFlag = pobj.PHNWholeFlag
        if $IsObject(pobj.PHNFormDr){
            s eobj.PHNFormDr = pobj.PHNFormDr.%Id() 
        }
        if $IsObject(pobj.PHNManfDR){
            s eobj.PHNManfDR = pobj.PHNManfDR.%Id() 
        }
        if $IsObject(pobj.PHNGenericDr){
            s eobj.PHNGenericDr = pobj.PHNGenericDr.%Id() 
        }
        if $IsObject(pobj.PHNToxicity){
            s eobj.PHNToxicity = pobj.PHNToxicity.%Id() 
        }
        s sc=##class(User.DHCPHProName).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHProName","User.DHCPHProName","药品商品名字典",id,eobj.PHNDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("药品商品名字典","web.DHCBL.KB.DHCPHProName","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    q result
}

/// Other:d ##class(web.DHCBL.KB.DHCPHProName).SaveProNameAlise()
ClassMethod SaveProNameAlise() As %String
{
    s result=""
    s PHNRowId=0
    for  
    {   
        s PHNRowId=$o(^DHCPHPNA(PHNRowId)) q:PHNRowId="" 
        s PHNDesc=$p($g(^DHCPHPNA(PHNRowId)),"^",2)  //描述
        s hasalise=$d(^User.BDPAliasI("DataRef","DHC_PHProName",PHNRowId))
        continue:(hasalise>0)
        s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHNDesc))
        s listData="^DHC_PHProName^"_PINYIN_"^"_PHNRowId
        s str= ##class(web.DHCBL.BDP.BDPAlias).SaveEntity(listData)
        if (str["失败"){
            s result=result_"^"_PHNRowId
        }       
    }
    q result
}

/// Creator:谷雪萍
/// CreatDate:2017-9-7
/// Description:商品名中有多少已经维护了数据
/// Table:User.DHCPHProName
/// Return:返回已经维护数据的商品名数目^商品名总的数目。
/// Other:w ##class(web.DHCBL.KB.DHCPHProName).GetProBusCount()
ClassMethod GetProBusCount() As %String
{
    s count=0
    s total=0
    s PHNRowId=0
    for  
    {   
        s PHNRowId=$o(^DHCPHPNA(PHNRowId)) q:PHNRowId="" 
        s PointerType="ProName"
        s PointerDr="0"
        s total=total+1
        if ($d(^DHCPHINSTRUC("0","GP",PHNRowId,PointerType,PointerDr)))
        {
            s count=count+1
        }
        
    }
    q "已维护"_count_"条，共"_total_"条"
}

/// Creator：谷雪萍
/// CreatDate: 2017-11-10
/// Description：写查询江苏省医药品适应病症的方法。
/// Table：User.DHCPHProName
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHProName","GetDiseaseList","","","","","")
Query GetDiseaseList(rowid, code, desc, form) As %Query(ROWSPEC = "drugDesc,PHDDDiseaDr")
{
}

ClassMethod GetDiseaseListExecute(ByRef qHandle As %Binary, rowid, code, desc, form) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    

    s PHDDRowId=0
    for  
    {   
        s PHDDRowId=$o(^DHCPHDDIS(PHDDRowId)) q:PHDDRowId="" 

        s PHDDInstDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",1)  //主索引表id
        s PHINSTGenDr=$p($g(^DHCPHINSTRUC(PHDDInstDr)),"^",3)  //通用名id
        s PHINSTPointerDr=$p($g(^DHCPHINSTRUC(PHDDInstDr)),"^",4)  //机型id
        s PHINSTPointerType=$p($g(^DHCPHINSTRUC(PHDDInstDr)),"^",5)  //类型
        s drugDesc=""
        if (PHINSTPointerType="ProName")
        {
            s drugDesc=$p($g(^DHCPHPNA(PHINSTGenDr)),"^",2)  //描述   
        }
        else
        {
            s drugDesc=$p($g(^DHCPHEGEN(PHINSTGenDr)),"^",2)  //描述
        }
        
        s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3)  //诊断id
        s:PHDDDiseaDr'="" PHDDDiseaDr=$p($g(^DHCPHDISL(PHDDDiseaDr)),"^",2)
        s PHDDMode=$p($g(^DHCPHDDIS(PHDDRowId)),"^",4)  //类型
        
        if (PHDDDiseaDr'="")&(drugDesc'="")
        {
            d OutputRowDia
        }   
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowDia
    set Data=$lb(drugDesc,PHDDDiseaDr)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDiseaseListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDiseaseListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetDiseaseListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDiseaseListExecute ]
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
