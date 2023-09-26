Class web.DHCBL.KB.DHCPHExtFreq Extends %RegisteredObject
{

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：查询频率字典表内容
/// Table：User.DHCPHExtFreq
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtFreq","GetList","","","","","")
Query GetList(rowid, code, desc) As %Query(ROWSPEC = "PHEFRowId,PHEFCode,PHEFDesc,PHEFActiveFlag,PHEFSysFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid, code, desc) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权Json
    s AuStr=##class(web.DHCBL.Authorize.DHCPHExtFreq).DHCGetDataByDefaultSession()
    ;这地方加个方法---获取基本配置中未授权的情况下是否显示数据
    ;假设未授权情况下默认全部显示数据
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHEFRowId=rowid
        s PHEFCode=$p($g(^DHCPHEFR(PHEFRowId)),"^",1)  //代码
        s PHEFDesc=$p($g(^DHCPHEFR(PHEFRowId)),"^",2)  //描述
        s PHEFActiveFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",3)  //是否可用
        s PHEFSysFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",4)  //是否系统标识
        s:PHEFActiveFlag="" PHEFActiveFlag="Y"
        s:PHEFSysFlag="" PHEFSysFlag="Y"
        
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s PHEFRowId=0
        for  
        {   
            s PHEFRowId=$o(^DHCPHEFR(PHEFRowId)) q:PHEFRowId="" 
            s strRowId = "{ID:"_PHEFRowId_"}"
            i (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据，如果未授权情况下筛选无效
            {
                s PHEFCode=$p($g(^DHCPHEFR(PHEFRowId)),"^",1)  //代码
                s PHEFCodeU=$ZCONVERT(PHEFCode,"U")
                s PHEFDesc=$p($g(^DHCPHEFR(PHEFRowId)),"^",2)  //描述
                s PHEFDescU=$ZCONVERT(PHEFDesc,"U")
                s PHEFActiveFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",3)  //是否可用
                
                s PHEFSysFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",4)  //是否系统标识
                s:PHEFActiveFlag="" PHEFActiveFlag="Y"
        		s:PHEFSysFlag="" PHEFSysFlag="Y"
        
                
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEFDescU))
                i (PHEFCodeU[code)&((PHEFDescU[desc)||(PINYIN[desc))   //条件
                {
                    d OutputRow
                }       
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHEFRowId,PHEFCode,PHEFDesc,PHEFActiveFlag,PHEFSysFlag)
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

/// Creator:丁亚男
/// CreatDate:2018-09-05
/// Description:查询 频率 
/// Input:desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtFreq","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "PHEFRowId:%String,PHEFDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PHEFRowId=rowid
        s PHEFDesc=$p($g(^DHCPHEFR(PHEFRowId)),"^",2)  //描述
        s PHEFActiveFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",3)  //是否可用
        d:PHEFActiveFlag="Y" OutputRowCmb
    }
    else
    {

        s:desc'="" desc=$ZCONVERT(desc,"U")
        
        s AuStr=##class(web.DHCBL.Authorize.DHCPHExtFreq).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s PHEFRowId=0
        for
        {
            s PHEFRowId=$o(^DHCPHEFR(PHEFRowId)) q:PHEFRowId=""
            s strRowId="{ID:"_PHEFRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s PHEFActiveFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",3)  //是否可用
                continue:PHEFActiveFlag="N"
                s PHEFDesc=$p($g(^DHCPHEFR(PHEFRowId)),"^",2)  //描述
                s PHEFDesc1=$ZCONVERT(PHEFDesc,"U")
                s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($$ALPHAUP^SSUTIL4(PHEFDesc1))
                i (PHEFDesc1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHEFRowId,PHEFDesc)
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

/// Creator：高姗姗
/// CreatDate: 2014-12-26
/// Description：查询用药频率中未选列表内容
/// Table：User.DHCPHExtFreq
/// Input：rowid, code, desc, lib
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtFreq","GetUnSelectList","","12","Form","2")
Query GetUnSelectList(TypeDr, GenDr, PointerType, PointerDr) As %Query(ROWSPEC = "PHEFRowId,PHEFCode,PHEFDesc,PHEFActiveFlag,PHEFSysFlag")
{
}

ClassMethod GetUnSelectListExecute(ByRef qHandle As %Binary, TypeDr, GenDr, PointerType, PointerDr) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    	s AuStr=##class(web.DHCBL.Authorize.DHCPHExtFreq).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        
        s selectStr = ##class(web.DHCBL.KB.DHCPHDiseaseFreq).GetFreqDr(TypeDr, GenDr, PointerType, PointerDr)
        s PHEFRowId=0
        for  
        {   
            s PHEFRowId=$o(^DHCPHEFR(PHEFRowId)) q:PHEFRowId=""
             
            s strRowId = "{ID:"_PHEFRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
	            s PHEFCode=$p($g(^DHCPHEFR(PHEFRowId)),"^",1)  //代码
	            s Code = "<"_PHEFCode_">"
	            s PHEFDesc=$p($g(^DHCPHEFR(PHEFRowId)),"^",2)  //描述
	            s PHEFActiveFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",3)  //是否可用
	            continue:PHEFActiveFlag="N"
	            s PHEFSysFlag=$p($g(^DHCPHEFR(PHEFRowId)),"^",4)  //是否系统标识
	            i '(selectStr[Code)   //条件
	            {
	                d OutputRowUnSel
	            }   
            }
        }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowUnSel
    set Data=$lb(PHEFRowId,PHEFCode,PHEFDesc,PHEFActiveFlag,PHEFSysFlag)
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

/// Function:用于实现数据校验功能的方法
/// Creator:基础数据平台组 高姗姗
/// CreateDate:2014-10-30    
/// w ##class(web.DHCBL.KB.DHCPHExtFreq).FormValidate("","","")
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHEFRi(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHEFRi(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHEFRi(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHEFRi(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Creator：高姗姗
/// CreatDate: 2014-10-30
/// Description：保存修改内容
/// Table：User.DHCPHExtFreq
/// Input：web.Entity.KB.DHCPHExtFreq 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHExtFreq) As %String
{
    
    s result = ""
    if $IsObject(eobj)
    {
        
        
        s flag=..FormValidate(eobj.PHEFRowId,eobj.PHEFCode,eobj.PHEFDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在'}"
        }
        else
        {
            if (eobj.PHEFRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHExtFreq).%New()
            }
            else  //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHExtFreq).%OpenId(eobj.PHEFRowId)
                
                s re=##class(web.DHCBL.KB.DHCPHExtFreq).GetRefFlag(eobj.PHEFRowId)
                s RefFlag=$p(re,"^",1)
                s str=$p(re,"^",2)
                if (RefFlag=1)&(str["<频率对照>"){
                    s result = "{success:'false',errorinfo:'在频率对照中被引用，不能修改!'}"  //返回错误信息
                    q result
                }
                
                s bobj = ##class(web.Entity.KB.DHCPHExtFreq).%New()
                s bobj.PHEFRowId = eobj.PHEFRowId
                s bobj.PHEFCode = obj.PHEFCode
                s bobj.PHEFDesc = obj.PHEFDesc
                s bobj.PHEFActiveFlag= obj.PHEFActiveFlag
                s bobj.PHEFSysFlag = obj.PHEFSysFlag
            }
    
            s obj.PHEFCode = eobj.PHEFCode
            s obj.PHEFDesc = eobj.PHEFDesc
            i eobj.PHEFActiveFlag="Y"
            {
                s obj.PHEFActiveFlag = "Y"
            }
            else
            {
                s obj.PHEFActiveFlag = "N"
            }
            i eobj.PHEFSysFlag="Y"
            {
                s obj.PHEFSysFlag = "Y"
            }
            else
            {
                s obj.PHEFSysFlag = "N"
            }
            Ts
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc){
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}" //返回RowId
                d:eobj.PHEFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtFreq","User.DHCPHExtFreq","频率字典",id,eobj.PHEFDesc,"A",eobj)
                d:eobj.PHEFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtFreq","User.DHCPHExtFreq","频率字典",eobj.PHEFRowId,eobj.PHEFDesc,"U",eobj,bobj)
            }else{
                Trollback
                s result = "{success:'false',errorinfo:'"_$zconvert(sc,"O","JS")_"'}"   //返回错误信息
                s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("频率字典","web.DHCBL.KB.DHCPHExtFreq","SaveData",eobj)
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
/// Table：User.DHCPHExtFreq
/// Other: d ##class(web.DHCBL.KB.DHCPHExtFreq).OpenData()
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtFreq).%New()
    s pobj = ##class(User.DHCPHExtFreq).%OpenId(id)
    s eobj.PHEFRowId = id
    s eobj.PHEFCode = pobj.PHEFCode
    s eobj.PHEFDesc = pobj.PHEFDesc
    s:pobj.PHEFActiveFlag="Y" eobj.PHEFActiveFlag="true"
    s:pobj.PHEFSysFlag="Y" eobj.PHEFSysFlag="true"  

    s str = eobj.JsonS()    
    s str = "{data:["_str_"]}"
    q str
}

/// Creator：丁亚男
/// CreatDate: 2018-08-07
/// Description：获取修改时的记录
/// Table：User.DHCPHExtFreq
/// Other: d ##class(web.DHCBL.KB.DHCPHExtFreq).NewOpenData()
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtFreq).%New()
    s pobj = ##class(User.DHCPHExtFreq).%OpenId(id)
    s eobj.PHEFRowId = id
    s eobj.PHEFCode = pobj.PHEFCode
    s eobj.PHEFDesc = pobj.PHEFDesc
    s eobj.PHEFActiveFlag=pobj.PHEFActiveFlag
    s eobj.PHEFSysFlag=pobj.PHEFSysFlag
	s:eobj.PHEFActiveFlag="" eobj.PHEFActiveFlag="Y"
    s:eobj.PHEFSysFlag="" eobj.PHEFSysFlag="Y"  
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
    
    s PDFRowId=0,flag=0
    for
    {
        s PDFRowId=$o(^DHCPHDISFR(PDFRowId)) q:(PDFRowId="")||(flag=1)  d
        s PDFFreqDR=$p($g(^DHCPHDISFR(PDFRowId)),"^",2)
        i PDFFreqDR=id
        {
            s flag=1
            s myInfo=myInfo_"<用药频率业务表>"
        }
    }   
    
    s flag=0
    s PHEFCode=$p($g(^DHCPHEFR(id)),"^",1) 
    s PHFCTRowId=0
    for  
    {   
        s PHFCTRowId=$o(^DHCPHFRCON(PHFCTRowId)) q:PHFCTRowId=""||(flag=1)  d 
        s PHFCTCode=$p($g(^DHCPHFRCON(PHFCTRowId)),"^",1)  //his代码
        i (PHFCTCode=PHEFCode){
            s flag=1
            s myInfo=myInfo_"<频率对照>"    
        }   
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

/// Creator:高姗姗
/// CreatDate:2014-10-30
/// Description:根据id删除
/// Table:User.DHCPHExtFreq
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.KB.DHCPHExtFreq).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s return="",myInfo=""
    s re=##class(web.DHCBL.KB.DHCPHExtFreq).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        Tstart
        s eobj = ##class(web.Entity.KB.DHCPHExtFreq).%New()
        s pobj = ##class(User.DHCPHExtFreq).%OpenId(id)
        s eobj.PHEFRowId = id
        s eobj.PHEFCode = pobj.PHEFCode
        s eobj.PHEFDesc = pobj.PHEFDesc
        s eobj.PHEFActiveFlag = pobj.PHEFActiveFlag
        s eobj.PHEFSysFlag = pobj.PHEFSysFlag
    
        s sc=##class(User.DHCPHExtFreq).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtFreq","User.DHCPHExtFreq","频率字典",id,eobj.PHEFDesc,"D",eobj)
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("频率字典","web.DHCBL.KB.DHCPHExtFreq","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=$zconvert(sc,"O","JS")
        }
    }
    q result
}

}
