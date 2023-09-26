Import SQLUser

/// 名称: 检查部位字典维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-谷雪萍
/// 编写日期: 2014-11-4
Class web.DHCBL.KB.DHCPHExtPart Extends %RegisteredObject
{

/// Description：修改时打开的数据
/// Table：User.DHCPHExtPart
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHExtPart).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtPart).%New()
    s eobj.PHEPRowId=id
    s eobj.PHEPCode=$p($g(^DHCPHEPA(id)),"^",1)
    s eobj.PHEPDesc=$p($g(^DHCPHEPA(id)),"^",2)
    s eobj.PHEPAcitveFlag=$p($g(^DHCPHEPA(id)),"^",3)
    s eobj.PHEPSysFlag=$p($g(^DHCPHEPA(id)),"^",4)
    
    s:eobj.PHEPAcitveFlag="Y" eobj.PHEPAcitveFlag="true" 
    s:eobj.PHEPSysFlag="Y" eobj.PHEPSysFlag="true" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    s str = "{list:["_str_"]}"
    q str
}

/// Description：修改时打开的数据
/// Table：User.DHCPHExtPart
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHExtPart).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHExtPart).%New()
    s eobj.PHEPRowId=id
    s eobj.PHEPCode=$p($g(^DHCPHEPA(id)),"^",1)
    s eobj.PHEPDesc=$p($g(^DHCPHEPA(id)),"^",2)
    s eobj.PHEPAcitveFlag=$p($g(^DHCPHEPA(id)),"^",3)
    s eobj.PHEPSysFlag=$p($g(^DHCPHEPA(id)),"^",4)
    
    s:eobj.PHEPAcitveFlag'="N" eobj.PHEPAcitveFlag="Y"
    s:eobj.PHEPSysFlag'="N" eobj.PHEPSysFlag="Y"
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    //s str = "{list:["_str_"]}"
    q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCPHExtPart
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHEPA(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHEPA(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHEPA(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHEPA(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description：保存检查部位字典的内容
/// Table：User.DHCPHExtPart
/// Input：web.Entity.KB.DHCPHExtPart 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHExtPart).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHExtPart) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.PHEPRowId,eobj.PHEPCode,eobj.PHEPDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.PHEPRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHExtPart).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s re=##class(web.DHCBL.KB.DHCPHExtPart).GetRefFlag(eobj.PHEPRowId)
                s RefFlag=$p(re,"^",1)
                s info=$p(re,"^",2)
                if (RefFlag=1)&(info["<检查部位和HIS部位对照>"){
                    q "{success:'false',errorinfo:'在【检查部位和HIS部位对照表】中被引用，不能修改！'}"  //返回错误信息
                    
                }else{
                s obj=##class(User.DHCPHExtPart).%OpenId(eobj.PHEPRowId)
                s bobj=##class(web.Entity.KB.DHCPHExtPart).%New()
                s bobj.PHEPRowId=eobj.PHEPRowId
                s bobj.PHEPCode=obj.PHEPCode
                s bobj.PHEPDesc = obj.PHEPDesc          //修改描述
                s bobj.PHEPAcitveFlag = obj.PHEPAcitveFlag 
                s bobj.PHEPSysFlag = obj.PHEPSysFlag
                }
            }
            Ts

            s obj.PHEPCode = eobj.PHEPCode
            s obj.PHEPDesc = eobj.PHEPDesc          //修改描述
            s:eobj.PHEPAcitveFlag="" eobj.PHEPAcitveFlag ="N" 
            s obj.PHEPAcitveFlag = eobj.PHEPAcitveFlag 
            s:eobj.PHEPSysFlag="" eobj.PHEPSysFlag ="N" 
            s obj.PHEPSysFlag = eobj.PHEPSysFlag    
                    
            s sc=obj.%Save()
            d obj.%Close()
            
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.PHEPRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtPart","User.DHCPHExtPart","检查部位字典",id,eobj.PHEPDesc,"A",eobj)
                //修改时，日志
                d:eobj.PHEPRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtPart","User.DHCPHExtPart","检查部位字典",eobj.PHEPRowId,eobj.PHEPDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检查部位字典","web.DHCBL.KB.DHCPHExtPart","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检查部位字典","web.DHCBL.KB.DHCPHExtPart","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description：查询检查部位字典的内容
/// Table：User.DHCPHExtPart
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtPart","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHEPRowId:%String,PHEPCode:%String,PHEPDesc:%String,PHEPAcitveFlag:%String,PHEPSysFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHEPRowId=rowid
        s PHEPCode=$p($g(^DHCPHEPA(PHEPRowId)),"^",1)
        s PHEPDesc=$p($g(^DHCPHEPA(PHEPRowId)),"^",2)
        s PHEPAcitveFlag=$p($g(^DHCPHEPA(PHEPRowId)),"^",3)
        s PHEPSysFlag=$p($g(^DHCPHEPA(PHEPRowId)),"^",4)
        s:PHEPAcitveFlag'="N" PHEPAcitveFlag="Y"
        s:PHEPSysFlag'="N" PHEPSysFlag="Y"
    
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
		s AuStr=##class(web.DHCBL.Authorize.DHCPHExtPart).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1        
        s PHEPRowId=0
        for {
            s PHEPRowId=$o(^DHCPHEPA(PHEPRowId))
            q:PHEPRowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_PHEPRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s PHEPCode=$p($g(^DHCPHEPA(PHEPRowId)),"^",1)
                s PHEPDesc=$p($g(^DHCPHEPA(PHEPRowId)),"^",2)
                s PHEPAcitveFlag=$p($g(^DHCPHEPA(PHEPRowId)),"^",3)
                s PHEPSysFlag=$p($g(^DHCPHEPA(PHEPRowId)),"^",4)
                s:PHEPAcitveFlag'="N" PHEPAcitveFlag="Y"
        		s:PHEPSysFlag'="N" PHEPSysFlag="Y"
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHEPDesc)
                if ($ZCONVERT(PHEPCode,"U")[code)&(($ZCONVERT(PHEPDesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRow
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHEPRowId,PHEPCode,PHEPDesc,PHEPAcitveFlag,PHEPSysFlag)
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

/// CreatDate:2014-11-25
/// Description:查询 检查部位
/// Input:desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHExtPart","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "PHEPRowId:%String,PHEPDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s PHEPRowId=rowid
        s PHEPDesc=$p($g(^DHCPHEPA(PHEPRowId)),"^",2)
        s PHEPAcitveFlag=$p($g(^DHCPHEPA(PHEPRowId)),"^",3)
        d:PHEPAcitveFlag="Y" OutputRowCmb
    }
    else
    {
        s:desc'="" desc=$ZCONVERT(desc,"U")
        
		s AuStr=##class(web.DHCBL.Authorize.DHCPHExtPart).DHCGetDataByDefaultSession()
		s AuFlag=0
		;未授权情况下，默认显示全部数据
		if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
        
        s PHEPRowId=0
        for
        {
            s PHEPRowId=$o(^DHCPHEPA(PHEPRowId)) q:PHEPRowId=""
            s strRowId="{ID:"_PHEPRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s PHEPAcitveFlag=$p($g(^DHCPHEPA(PHEPRowId)),"^",3)
                continue:PHEPAcitveFlag="N"
                s PHEPDesc=$p($g(^DHCPHEPA(PHEPRowId)),"^",2)
                s PHEPDesc1=$ZCONVERT(PHEPDesc,"U")
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHEPDesc)
                i (PHEPDesc1[desc)||(PINYIN[desc)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHEPRowId,PHEPDesc)
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

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// w ##class(web.DHCBL.KB.DHCPHExtPart).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    s PartRowId=0,flag=0
    for
    {
        s PartRowId=$o(^DHCGENLINP(PartRowId)) q:(PartRowId="")||(flag=1)  d
        s ExtPartDr=$p($g(^DHCGENLINP(PartRowId)),"^",2)
        
        s GlPGenDr=$p($g(^DHCGENLINP(PartRowId)),"^",1)  //通用名Dr    
        s PHLICode=""   
        s PHEGLibDr=$p($g(^DHCPHEGEN(GlPGenDr)),"^",7) 
        s:PHEGLibDr'="" PHLICode=$p($g(^DHCPHLIBL(PHEGLibDr)),"^",1) //知识库标识 部位
        s PHLICode1=$ZCONVERT(PHLICode,"U")
        i (ExtPartDr=id)&((PHLICode1="CHECK")||(PHLICode1="ELECT")||(PHLICode1="ULTR")||(PHLICode1="RADI")||(PHLICode1="ENDO"))
        {
            s flag=1
            s myInfo=myInfo_"<通用名和部位关联>"
        }
    }
    s PHEPCode=$p($g(^DHCPHEPA(id)),"^",1)
    s PHEPRowId=0,flag=0
    for
    {
        s PHEPRowId=$o(^DHCPHPACON(PHEPRowId)) q:(PHEPRowId="")||(flag=1)  d
        s PHEPPartCode=$p($g(^DHCPHPACON(PHEPRowId)),"^",1)  //代码
        i PHEPCode=PHEPPartCode
        {
            s flag=1
            s myInfo=myInfo_"<检查部位和HIS部位对照>"
        }
    }

    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Description：根据ID删除检查部位字典的内容
/// Table：User.DHCPHExtPart
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
    s result = ""
    s re=##class(web.DHCBL.KB.DHCPHExtPart).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
        s pobj = ##class(User.DHCPHExtPart).%OpenId(id)
        s eobj = ##class(web.Entity.KB.DHCPHExtPart).%New()
        s eobj.PHEPRowId = id
        s eobj.PHEPCode=pobj.PHEPCode
        s eobj.PHEPDesc=pobj.PHEPDesc
        s eobj.PHEPAcitveFlag=pobj.PHEPAcitveFlag
        s eobj.PHEPSysFlag=pobj.PHEPSysFlag
        d pobj.%Close()
        k pobj
        Tstart
        s sc=##class(User.DHCPHExtPart).%DeleteId(id)
        if $$$ISOK(sc)
        {
            Tcommit
            s result = "{success:'true',info:'删除成功！'}"  
            //保存日志
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHExtPart","User.DHCPHExtPart","检查部位字典",id,eobj.PHEPDesc,"D",eobj)
            d eobj.%Close()
        }
        else 
        {
            Trollback
            s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("检查部位字典","web.DHCBL.KB.DHCPHExtPart","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    q result
}

}
