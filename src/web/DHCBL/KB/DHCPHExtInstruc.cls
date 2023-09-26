Class web.DHCBL.KB.DHCPHExtInstruc Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：查询用法字典表内容
/// Table：User.DHCPHExtInstruc
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtInstruc","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "PHEINRowId,PHEINCode,PHEINDesc,PHEINActiveFlag,PHEINSysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHExtInstruc).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHEINRowId=rowid 
        s PHEINCode=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",1)  //代码
        s PHEINDesc=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",2)  //描述
        s PHEINActiveFlag=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",3)  //是否可用
        s PHEINSysFlag=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",4)  //是否系统标识
        s:PHEINActiveFlag="" PHEINActiveFlag="Y"
        s:PHEINSysFlag="" PHEINSysFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s PHEINRowId=0
        for  
        {   
            s PHEINRowId=$o(^DHCPHEINSTR(PHEINRowId)) q:PHEINRowId="" 
            s strRowId = "{ID:"_PHEINRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s PHEINCode=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",1)  //代码
                s PHEINCodeU=$ZCONVERT(PHEINCode,"U")
                s PHEINDesc=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",2)  //描述
                s PHEINDescU=$ZCONVERT(PHEINDesc,"U")
                s PHEINActiveFlag=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",3)  //是否可用
                s PHEINSysFlag=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",4)  //是否系统标识
                s:PHEINActiveFlag="" PHEINActiveFlag="Y"
        		s:PHEINSysFlag="" PHEINSysFlag="Y"
        
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEINDescU))
                i (PHEINCodeU[code)&((PHEINDescU[desc)||(PINYIN[desc))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHEINRowId,PHEINCode,PHEINDesc,PHEINActiveFlag,PHEINSysFlag)
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

/// Creator：高姗姗
/// CreatDate: 2014-12-26
/// Description：查询用药方法中已选列表内容
/// Table：User.DHCPHExtInstruc
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtInstruc","GetUnSelectList","","21","Form","2")
Query GetUnSelectList(TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHEINRowId,PHEINCode,PHEINDesc,PHEINActiveFlag,PHEINSysFlag")
{
}

ClassMethod GetUnSelectListExecute(ByRef qHandle As %Binary, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHExtInstruc).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    s selectStr = ##class(web.DHCBL.KB.DHCPHDiseaseUse).GetUseDR(TypeDr, GenDr, PointerType, PointerDr)
    s PHEINRowId=0
    for  
    {   
        s PHEINRowId=$o(^DHCPHEINSTR(PHEINRowId)) q:PHEINRowId="" 
        s strRowId = "{ID:"_PHEINRowId_"}"
        i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
        {
	        s PHEINCode=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",1)  //代码
	        s Code = "<"_PHEINCode_">"
	        s PHEINDesc=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",2)  //描述
	        s PHEINActiveFlag=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",3)  //是否可用
	        s PHEINSysFlag=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",4)  //是否系统标识
	        i '(selectStr[Code)   //条件
	        {
	            d OutputRowUnSel
	        } 
        }      
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowUnSel
    set Data=$lb(PHEINRowId,PHEINCode,PHEINDesc,PHEINActiveFlag,PHEINSysFlag)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelectListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelectListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetUnSelectListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelectListExecute ]
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

/// Creator:高姗姗
/// CreatDate:2014-12-3
/// Description:查询 用法 
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtInstruc","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "PHEINRowId:%String,PHEINDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PHEINRowId=rowid
        s PHEINDesc=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",2)
        s PHEINActiveFlag=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",3)  //是否可用
        d:PHEINActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCPHExtInstruc).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s PHEINRowId=0
        for
        {
            s PHEINRowId=$o(^DHCPHEINSTR(PHEINRowId)) q:PHEINRowId=""
            s strRowId="{ID:"_PHEINRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s PHEINActiveFlag=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",3)  //是否可用
                continue:PHEINActiveFlag="N"
                s PHEINDesc=$p($g(^DHCPHEINSTR(PHEINRowId)),"^",2)
                s PHEINDesc1=$ZCONVERT(PHEINDesc,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEINDesc1))
                i (PHEINDesc1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHEINRowId,PHEINDesc)
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
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2014-10-30    
/// w ##class(web.DHCBL.KB.DHCPHExtInstruc).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHEINSTRi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHEINSTRi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHEINSTRi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHEINSTRi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCPHExtInstruc
/// Input：web.Entity.KB.DHCPHExtInstruc 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHExtInstruc) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.PHEINRowId,eobj.PHEINCode,eobj.PHEINDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.PHEINRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHExtInstruc).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHExtInstruc).%OpenId(eobj.PHEINRowId)
                
                s re=##class(web.DHCBL.KB.DHCPHExtInstruc).GetRefFlag(eobj.PHEINRowId)
                s RefFlag=$p(re,"^",1)
                s str=$p(re,"^",2)
                if (RefFlag=1)&(str["<用法对照>"){
                    s result = "{success:'false',errorinfo:'在用法对照中被引用，不能修改!'}"  //返回错误信息
                    q result
                }
                
                s bobj = ##class(web.Entity.KB.DHCPHExtInstruc).%New()
                s bobj.PHEINRowId = eobj.PHEINRowId
                s bobj.PHEINCode = obj.PHEINCode
                s bobj.PHEINDesc = obj.PHEINDesc
                s bobj.PHEINActiveFlag= obj.PHEINActiveFlag
                s bobj.PHEINSysFlag = obj.PHEINSysFlag
            }
    
            s obj.PHEINCode = eobj.PHEINCode
            s obj.PHEINDesc = eobj.PHEINDesc
            i eobj.PHEINActiveFlag="Y"
            {
                s obj.PHEINActiveFlag = "Y"
            }
            else
            {
                s obj.PHEINActiveFlag = "N"
            }
            i eobj.PHEINSysFlag="Y"
            {
                s obj.PHEINSysFlag = "Y"
            }
            else
            {
                s obj.PHEINSysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.PHEINRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtInstruc","User.DHCPHExtInstruc","用法字典",id,eobj.PHEINDesc,"A",eobj)
                d:eobj.PHEINRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtInstruc","User.DHCPHExtInstruc","用法字典",eobj.PHEINRowId,eobj.PHEINDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用法字典","web.DHCBL.KB.DHCPHExtInstruc","SaveData",eobj)
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

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：获取修改时的记录
/// Table：User.DHCPHExtInstruc
/// Other: d ##class(web.DHCBL.KB.DHCPHExtInstruc).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtInstruc).%New()
    s pobj = ##class(User.DHCPHExtInstruc).%OpenId(id)
    s eobj.PHEINRowId = id
    s eobj.PHEINCode = pobj.PHEINCode
    s eobj.PHEINDesc = pobj.PHEINDesc
    s:pobj.PHEINActiveFlag="Y" eobj.PHEINActiveFlag="true"
    s:pobj.PHEINSysFlag="Y" eobj.PHEINSysFlag="true"    

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Creator：丁亚男
/// CreatDate: 2018-08-07
/// Description：获取修改时的记录
/// Table：User.DHCPHExtInstruc
/// Other: d ##class(web.DHCBL.KB.DHCPHExtInstruc).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtInstruc).%New()
    s pobj = ##class(User.DHCPHExtInstruc).%OpenId(id)
    s eobj.PHEINRowId = id
    s eobj.PHEINCode = pobj.PHEINCode
    s eobj.PHEINDesc = pobj.PHEINDesc
    s eobj.PHEINActiveFlag=pobj.PHEINActiveFlag
    s eobj.PHEINSysFlag=pobj.PHEINSysFlag
    s:eobj.PHEINActiveFlag="" eobj.PHEINActiveFlag="Y"
    s:eobj.PHEINSysFlag="" eobj.PHEINSysFlag="Y"    

    s str = eobj.JsonS()    
    ;s str = "{data:["_str_"]}"
    q str
}

/// Creator:高姗姗
/// CreatDate:2014-12-9
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    s PDIRowId=0,flag=0
    for
    {
        s PDIRowId=$o(^DHCPHDISUSE(PDIRowId)) q:(PDIRowId="")||(flag=1)  d
        s PDIUseDR=$p($g(^DHCPHDISUSE(PDIRowId)),"^",2)
        i PDIUseDR=id
        {
            s flag=1
            s myInfo=myInfo_"<用药方法业务表>"
        }
    }
    
    s flag=0
    s PHEINCode=$p($g(^DHCPHEINSTR(id)),"^",1) 
    s PHICTRowId=0
    for  
    {   
        s PHICTRowId=$o(^DHCPHINSTCON(PHICTRowId)) q:PHICTRowId=""||(flag=1)  d 
        s PHICTCode=$p($g(^DHCPHINSTCON(PHICTRowId)),"^",1)  //his代码
        i (PHICTCode=PHEINCode){
            s flag=1
            s myInfo=myInfo_"<用法对照>"    
        }   
    }   
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCPHExtInstruc
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHExtInstruc).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    s re=##class(web.DHCBL.KB.DHCPHExtInstruc).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCPHExtInstruc).%New()
        s pobj = ##class(User.DHCPHExtInstruc).%OpenId(id)
        s eobj.PHEINRowId = id
        s eobj.PHEINCode = pobj.PHEINCode
        s eobj.PHEINDesc = pobj.PHEINDesc
        s eobj.PHEINActiveFlag = pobj.PHEINActiveFlag
        s eobj.PHEINSysFlag = pobj.PHEINSysFlag
    
        s sc=##class(User.DHCPHExtInstruc).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtInstruc","User.DHCPHExtInstruc","用法字典",id,eobj.PHEINDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("用法字典","web.DHCBL.KB.DHCPHExtInstruc","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    q result
}

/// Creator：石萧伟
/// CreatDate: 2018-02-02
/// Description：根据id获取描述
/// Input：rowid
/// Return:描述
/// Other: d ##class(web.DHCBL.KB.DHCPHExtInstruc).FindDeseById()
ClassMethod FindDeseById(rowid As %String) As %String
{
	 quit:rowid="" ""
	 s PHEINDesc=$p($g(^DHCPHEINSTR(rowid)),"^",2)
	 q PHEINDesc
}

}
