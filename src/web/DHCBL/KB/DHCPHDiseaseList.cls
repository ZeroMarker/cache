Import SQLUser

/// 名称: 病症字典维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-石萧伟
/// 编写日期: 2014-11-5
Class web.DHCBL.KB.DHCPHDiseaseList Extends %RegisteredObject
{

/// 石萧伟
/// Description：修改时打开的数据
/// Table：User.DHCPHDiseaseList
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseList).OpenData("1")
ClassMethod NewOpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHDiseaseList).%New()
    s eobj.PHDISLRowId=id
    s eobj.PHDISLDiseaCode=$p($g(^DHCPHDISL(id)),"^",1)
    s eobj.PHDISLDiseaDesc=$p($g(^DHCPHDISL(id)),"^",2)
    s eobj.PHDISLActiveFlag=$p($g(^DHCPHDISL(id)),"^",3)
    s eobj.PHDISLSysFlag=$p($g(^DHCPHDISL(id)),"^",4)
    s eobj.PHDISLRemark=$p($g(^DHCPHDISL(id)),"^",5)
    s keyid=$o(^DHCPHDISKEYi(0,"Dis","M",id,0))
    s eobj.PHDISLKey=""
    s:keyid'="" eobj.PHDISLKey=$p($g(^DHCPHDISKEY(keyid)),"^",3)
    s:eobj.PHDISLActiveFlag="" eobj.PHDISLActiveFlag="Y" 
    s:eobj.PHDISLSysFlag="" eobj.PHDISLSysFlag="Y" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    //s str = "{list:["_str_"]}"
    q str
}

/// Description:为combobox查询取数据
/// Table：User.DHCPHDiseaseList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseList","GetDataForCmb1","","","")
Query GetNewDataForCmb1(rowid As %String, code As %String, q As %String) As %Query(ROWSPEC = "PHDISLRowId:%String,PHDISLDiseaCode:%String,PHDISLDiseaDesc:%String")
{
}

ClassMethod GetNewDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, q As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHDiseaseList).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHDISLRowId=rowid
        s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
        s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2) 
        s PHDISLActiveFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",3)
        d:PHDISLActiveFlag="Y" OutputRowCmbNew
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:q'="" q=$ZCONVERT(q,"U") //转换成大写
        s PHDISLRowId=0
        for {
            s PHDISLRowId=$o(^DHCPHDISL(PHDISLRowId))
            q:PHDISLRowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_PHDISLRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s PHDISLActiveFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",3)
                continue:PHDISLActiveFlag="N"
                s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
                s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2)
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHDISLDiseaDesc)
                if ($ZCONVERT(PHDISLDiseaCode,"U")[code)&(($ZCONVERT(PHDISLDiseaDesc,"U")[q)||(PINYIN[q))
                {
                    d OutputRowCmbNew
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmbNew
    set Data=$lb(PHDISLRowId,PHDISLDiseaCode,PHDISLDiseaDesc)
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

/// Description：修改时打开的数据
/// Table：User.DHCPHDiseaseList
/// Input：id
/// Other: w ##class(web.DHCBL.KB.DHCPHDiseaseList).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.KB.DHCPHDiseaseList).%New()
    s eobj.PHDISLRowId=id
    s eobj.PHDISLDiseaCode=$p($g(^DHCPHDISL(id)),"^",1)
    s eobj.PHDISLDiseaDesc=$p($g(^DHCPHDISL(id)),"^",2)
    s eobj.PHDISLActiveFlag=$p($g(^DHCPHDISL(id)),"^",3)
    s eobj.PHDISLSysFlag=$p($g(^DHCPHDISL(id)),"^",4)
    s eobj.PHDISLRemark=$p($g(^DHCPHDISL(id)),"^",5)
    s keyid=$o(^DHCPHDISKEYi(0,"Dis","M",id,0))
    s eobj.PHDISLKey=""
    s:keyid'="" eobj.PHDISLKey=$p($g(^DHCPHDISKEY(keyid)),"^",3)
    s:eobj.PHDISLActiveFlag="Y" eobj.PHDISLActiveFlag="true" 
    s:eobj.PHDISLSysFlag="Y" eobj.PHDISLSysFlag="true" 
    
    s str = eobj.JsonS()    
    d eobj.%Close()
    s str = "{list:["_str_"]}"
    q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.DHCPHDiseaseList
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^DHCPHDISL(0,"Code",code))
    s:desc'="" flagd=$d(^DHCPHDISL(0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^DHCPHDISL(0,"Code",code,0))
        s:desc'="" idd=$o(^DHCPHDISL(0,"Desc",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Description：保存病症字典的内容
/// Table：User.DHCPHDiseaseList
/// Input：web.Entity.KB.DHCPHDiseaseList 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.KB.DHCPHDiseaseList).SaveData()
ClassMethod SaveData(eobj As web.Entity.KB.DHCPHDiseaseList) As %String
{
    s $zt="ERROE"
    s result="",flag=""
    if $IsObject(eobj)
    {   
        s flag=..Validate(eobj.PHDISLRowId,eobj.PHDISLDiseaCode,eobj.PHDISLDiseaDesc)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.PHDISLRowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.DHCPHDiseaseList).%New()
            }
            else                     //如果RowId已赋值则修改
            {
                s obj=##class(User.DHCPHDiseaseList).%OpenId(eobj.PHDISLRowId)
                s bobj=##class(web.Entity.KB.DHCPHDiseaseList).%New()
                s bobj.PHDISLRowId=eobj.PHDISLRowId
                s bobj.PHDISLDiseaCode=obj.PHDISLDiseaCode
                s bobj.PHDISLDiseaDesc = obj.PHDISLDiseaDesc          //修改描述
                s bobj.PHDISLActiveFlag = obj.PHDISLActiveFlag 
                s bobj.PHDISLSysFlag = obj.PHDISLSysFlag
                s bobj.PHDISLRemark = obj.PHDISLRemark              
                
            }
            Ts
            
            s obj.PHDISLDiseaCode = eobj.PHDISLDiseaCode
            s obj.PHDISLDiseaDesc = eobj.PHDISLDiseaDesc          //修改描述
            s:eobj.PHDISLActiveFlag="" eobj.PHDISLActiveFlag ="N" 
            s obj.PHDISLActiveFlag = eobj.PHDISLActiveFlag 
            s:eobj.PHDISLSysFlag="" eobj.PHDISLSysFlag ="N" 
            s obj.PHDISLSysFlag = eobj.PHDISLSysFlag    
            s obj.PHDISLRemark = eobj.PHDISLRemark  
                    
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s keyid=$o(^DHCPHDISKEYi(0,"Dis","M",id,0))
                if (keyid="")
                {
                    s objkey=##class(User.DHCPHDiseaseKey).%New()
                }
                else
                {
                    s objkey=##class(User.DHCPHDiseaseKey).%OpenId(keyid)
                }
                s:eobj.PHDISLKey="" eobj.PHDISLKey=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.PHDISLDiseaDesc)
                s objkey.PHDKDesc=eobj.PHDISLKey
                s objkey.PHDKDisDr=id
                s objkey.PHDKType="M"
                
                s sckey=objkey.%Save()
                d objkey.%Close()
                
                s result = "{success:'true',id:'"_id_"'}"  //返回RowId
                //新增时，日志
                d:eobj.PHDISLRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseList","User.DHCPHDiseaseList","病症字典",id,eobj.PHDISLDiseaDesc,"A",eobj)
                //修改时，日志
                d:eobj.PHDISLRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseList","User.DHCPHDiseaseList","病症字典",eobj.PHDISLRowId,eobj.PHDISLDiseaDesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病症字典","web.DHCBL.KB.DHCPHDiseaseList","SaveData",eobj)
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
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病症字典","web.DHCBL.KB.DHCPHDiseaseList","SaveData",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Description:获取病症的常用名(C)或别名(A)||拼音码
/// w ##class(web.DHCBL.KB.DHCPHDiseaseList).GetComOrAlias("1","A")
ClassMethod GetComOrAlias(dis As %String, type As %String) As %String
{
    s str="",keyStr=""
    s PHDCLRowId=0
    for 
    {
        S PHDCLRowId=$o(^DHCPHDISCOMLi(0,"Dis",dis,type,PHDCLRowId)) q:PHDCLRowId=""
        s PHDCLDesc=$p($g(^DHCPHDISCOML(PHDCLRowId)),"^",3)

        s:str'="" str=str_","_PHDCLDesc
        s:str="" str=PHDCLDesc
        
        s keyid=$o(^DHCPHDISKEYi(0,"Dis",type,PHDCLRowId,0))
        s PHDCLKey=""
        s:keyid'="" PHDCLKey=$p($g(^DHCPHDISKEY(keyid)),"^",3)
        
        s:keyStr'="" keyStr=keyStr_","_PHDCLKey
        s:keyStr="" keyStr=PHDCLKey
    }
    q str_"||"_keyStr
}

/// Description：查询病症字典的内容
/// Table：User.DHCPHDiseaseList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseList","GetList","","Y","q")
Query GetList(rowid As %String, allEn As %String, desc As %String) As %Query(ROWSPEC = "PHDISLRowId:%String,PHDISLDiseaCode:%String,PHDISLDiseaDesc:%String,PHDISLActiveFlag:%String,PHDISLSysFlag:%String,PHDISLKey:%String,PHDISLAlias:%String,PHDISLCom:%String,PHDISLRemark:%String,comKey:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, allEn As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHDiseaseList).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHDISLRowId=rowid
        s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
        s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2)
        s PHDISLActiveFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",3)
        s PHDISLSysFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",4)
        s:PHDISLActiveFlag="" PHDISLActiveFlag="Y"
        s:PHDISLSysFlag="" PHDISLSysFlag="Y"
        s PHDISLRemark=$p($g(^DHCPHDISL(PHDISLRowId)),"^",5)
        s keyid=$o(^DHCPHDISKEYi(0,"Dis","M",PHDISLRowId,0))
        s PHDISLKey=""
        s:keyid'="" PHDISLKey=$p($g(^DHCPHDISKEY(keyid)),"^",3)
        s strAlias=..GetComOrAlias(PHDISLRowId,"A")
        s PHDISLAlias=$p(strAlias,"||",1)
        s aliasKey=$p(strAlias,"||",2)
        s strCom=..GetComOrAlias(PHDISLRowId,"C")
        s PHDISLCom=$p(strCom,"||",1)
        s comKey=$p(strCom,"||",2)
    
        d OutputRow
    }
    else
    {
        if (desc="")
        {
            s PHDISLRowId=""
            for {
                s PHDISLRowId=$o(^DHCPHDISL(PHDISLRowId),-1)
                q:PHDISLRowId=0
                //筛选授权后的数据
				s strRowId="{ID:"_PHDISLRowId_"}"
				if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
				{
                    s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
                    s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2)
                    s PHDISLActiveFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",3)
                    s PHDISLSysFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",4)
                    s:PHDISLActiveFlag="" PHDISLActiveFlag="Y"
        			s:PHDISLSysFlag="" PHDISLSysFlag="Y"
        
                    s PHDISLRemark=$p($g(^DHCPHDISL(PHDISLRowId)),"^",5)
                    s keyid=$o(^DHCPHDISKEYi(0,"Dis","M",PHDISLRowId,0))
                    s PHDISLKey=""
                    s:keyid'="" PHDISLKey=$p($g(^DHCPHDISKEY(keyid)),"^",3)
                    s strAlias=..GetComOrAlias(PHDISLRowId,"A")
                    s PHDISLAlias=$p(strAlias,"||",1)
                    s aliasKey=$p(strAlias,"||",2)
                    s strCom=..GetComOrAlias(PHDISLRowId,"C")
                    s PHDISLCom=$p(strCom,"||",1)
                    s comKey=$p(strCom,"||",2)          
            
                        d OutputRow
				}
            }
        }
        else  //(desc'="")
        {
        //s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        //s:com'="" com=$ZCONVERT(com,"U") //转换成大写
        //s:alias'="" alias=$ZCONVERT(alias,"U") //转换成大写
        s strDesc1="",strCom1="",strAlias1="",strSearch=""
        s PHDISLRowId=""
        for //把搜索到的常用名，描述，别名拼串
        {
            s PHDISLRowId=$o(^DHCPHDISL(PHDISLRowId),-1)
            q:PHDISLRowId=0

            s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2)
            s keyid=$o(^DHCPHDISKEYi(0,"Dis","M",PHDISLRowId,0))
            s PHDISLKey=""
            s:keyid'="" PHDISLKey=$p($g(^DHCPHDISKEY(keyid)),"^",3)
            s strAlias=..GetComOrAlias(PHDISLRowId,"A")
            s PHDISLAlias=$p(strAlias,"||",1)
            s aliasKey=$p(strAlias,"||",2)
            s strCom=..GetComOrAlias(PHDISLRowId,"C")
            s PHDISLCom=$p(strCom,"||",1)
            s comKey=$p(strCom,"||",2)  
            
            s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHDISLDiseaDesc)
            s PINYINCom=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHDISLCom)
            s PINYINAlias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHDISLAlias)      
        
            s isCom=($ZCONVERT(PHDISLCom,"U")[desc)       //常用名
            s isComKey=($ZCONVERT(comKey,"U")[desc)||(PINYINCom[desc)
            s isAlias=($ZCONVERT(PHDISLAlias,"U")[desc)   //别名
            s isAliasKey=($ZCONVERT(aliasKey,"U")[desc)||(PINYINAlias[desc)  
            s isDesc=($ZCONVERT(PHDISLDiseaDesc,"U")[desc)  //描述
            s isDescKey=(($ZCONVERT(PHDISLKey,"U")[desc)||(PINYIN[desc))
            
            if (allEn="")
            {
            
                if (isCom)
                {                   
                    s:strCom1'="" strCom1=strCom1_"^"_PHDISLRowId
                    s:strCom1="" strCom1=PHDISLRowId
                }
                else
                {
                    if (isDesc)
                    {
                        s:strDesc1'="" strDesc1=strDesc1_"^"_PHDISLRowId
                        s:strDesc1="" strDesc1=PHDISLRowId
                    }
                    else
                    {
                        if (isAlias)
                        {
                            s:strAlias1'="" strAlias1=strAlias1_"^"_PHDISLRowId
                            s:strAlias1="" strAlias1=PHDISLRowId
                        }
                    }
                }
            }
            else  //(allEn'="")
            {
                if (isComKey)
                {
                    s:strCom1'="" strCom1=strCom1_"^"_PHDISLRowId
                    s:strCom1="" strCom1=PHDISLRowId
                }
                else
                {
                    if (isDescKey)
                    {                           
                        s:strDesc1'="" strDesc1=strDesc1_"^"_PHDISLRowId
                        s:strDesc1="" strDesc1=PHDISLRowId

                    }
                    else
                    {
                        if (isAliasKey)
                        {
                            s:strAlias1'="" strAlias1=strAlias1_"^"_PHDISLRowId
                            s:strAlias1="" strAlias1=PHDISLRowId
                
                        }
                    }
                }                   
            }
        }  //(for完)
        //优先级常用名>描述>别名
        s:strCom1'="" strSearch=strCom1
        if (strDesc1'="") {
            s:strSearch'="" strSearch=strSearch_"^"_strDesc1
            s:strSearch="" strSearch=strDesc1
        }
        if (strAlias1'="") {
            s:strSearch'="" strSearch=strSearch_"^"_strAlias1
            s:strSearch="" strSearch=strAlias1
        }
        ;b ;strSearch
        if (strSearch'="")  //如果查询结果不为空
        {
            s strLen=$Length(strSearch,"^")
            for i=1:1:strLen        
            {
                s PHDISLRowId=$p(strSearch,"^",i)

                s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
                s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2)
                s PHDISLActiveFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",3)
                s PHDISLSysFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",4)
                s:PHDISLActiveFlag="" PHDISLActiveFlag="Y"
       			s:PHDISLSysFlag="" PHDISLSysFlag="Y"
        
                s PHDISLRemark=$p($g(^DHCPHDISL(PHDISLRowId)),"^",5)
                s keyid=$o(^DHCPHDISKEYi(0,"Dis","M",PHDISLRowId,0))
                s PHDISLKey=""
                s:keyid'="" PHDISLKey=$p($g(^DHCPHDISKEY(keyid)),"^",3)
                s strAlias=..GetComOrAlias(PHDISLRowId,"A")
                s PHDISLAlias=$p(strAlias,"||",1)
                s aliasKey=$p(strAlias,"||",2)
                s strCom=..GetComOrAlias(PHDISLRowId,"C")
                s PHDISLCom=$p(strCom,"||",1)
                s comKey=$p(strCom,"||",2)  
                d OutputRow     
            }
        }
        }
        
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(PHDISLRowId,PHDISLDiseaCode,PHDISLDiseaDesc,PHDISLActiveFlag,PHDISLSysFlag,PHDISLKey,PHDISLAlias,PHDISLCom,PHDISLRemark,comKey)
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

/// Description:为combobox查询取数据
/// Table：User.DHCPHDiseaseList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseList","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "PHDISLRowId:%String,PHDISLDiseaCode:%String,PHDISLDiseaDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    //获取授权
    s AuStr=##class(web.DHCBL.Authorize.DHCPHDiseaseList).DHCGetDataByDefaultSession()
    s AuFlag=0
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
    
    if (rowid'="") //根据rowid返回该条记录
    {
        s PHDISLRowId=rowid
        s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
        s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2) 
        s PHDISLActiveFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",3)
        d:PHDISLActiveFlag="Y" OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U") //转换成大写
        s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
        s PHDISLRowId=0
        for {
            s PHDISLRowId=$o(^DHCPHDISL(PHDISLRowId))
            q:PHDISLRowId=""
            //筛选授权后的数据
            s strRowId="{ID:"_PHDISLRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) {
                s PHDISLActiveFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",3)
                continue:PHDISLActiveFlag="N"
                s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
                s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2)
                s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHDISLDiseaDesc)
                if ($ZCONVERT(PHDISLDiseaCode,"U")[code)&(($ZCONVERT(PHDISLDiseaDesc,"U")[desc)||(PINYIN[desc))
                {
                    d OutputRowCmb
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(PHDISLRowId,PHDISLDiseaCode,PHDISLDiseaDesc)
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

/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除DHCPHDiseaseList
/// w ##class(web.DHCBL.KB.DHCPHDiseaseList).GetRefFlag("2")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    i $d(^DHCSPEP(0,"DIS",id)){
        s myInfo=myInfo_"<特殊人群与病症关联表>"
    }
    s PHDDRowId=0,flag=0
    for
    {
        s PHDDRowId=$o(^DHCPHDDIS(PHDDRowId)) q:(PHDDRowId="")||(flag=1)  d
        s PHDDDiseaDr=$p($g(^DHCPHDDIS(PHDDRowId)),"^",3)
        i PHDDDiseaDr=id
        {
            s flag=1
            s myInfo=myInfo_"<知识库编辑器>"
        }
    }
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"里被引用,不能删除!"
    q return
}

/// Description：根据ID删除病症字典的内容
/// Table：User.DHCPHDiseaseList
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.KB.DHCPHDiseaseList).DeleteData("225")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=##class(web.DHCBL.KB.DHCPHDiseaseList).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=0){
        s pobj = ##class(User.DHCPHDiseaseList).%OpenId(id)
        s eobj = ##class(web.Entity.KB.DHCPHDiseaseList).%New()
        s eobj.PHDISLRowId = id
        s eobj.PHDISLDiseaCode=pobj.PHDISLDiseaCode
        s eobj.PHDISLDiseaDesc=pobj.PHDISLDiseaDesc
        s eobj.PHDISLActiveFlag=pobj.PHDISLActiveFlag
        s eobj.PHDISLSysFlag=pobj.PHDISLSysFlag
        s eobj.PHDISLRemark=pobj.PHDISLRemark

        d pobj.%Close()
        k pobj
        Tstart
        s sc=##class(User.DHCPHDiseaseList).%DeleteId(id)
        
        s keyid=$o(^DHCPHDISKEYi(0,"Dis","M",id,0))
        if (keyid'="")
        {
            s sckey=##class(User.DHCPHDiseaseKey).%DeleteId(keyid)
        }

        if ($$$ISOK(sc)&$$$ISOK(sckey)){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_PHDiseaseList","User.DHCPHDiseaseList","病症字典",id,eobj.PHDISLDiseaDesc,"D",eobj)
            d eobj.%Close()
        }
        else{
            Trollback
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病症字典","web.DHCBL.KB.DHCPHDiseaseList","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    else{
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }   
    q result
}

/// Description：查询未选病症字典的列表内容
/// Table：User.DHCPHDiseaseList
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.KB.DHCPHDiseaseList","GetUnSelDiseaList","782","<XJGR>^<SH>^","")
Query GetUnSelDiseaList(InstId As %String, diseaStr As %String, desc As %String) As %Query(ROWSPEC = "PHDISLRowId:%String,PHDISLDiseaCode:%String,PHDISLDiseaDesc:%String,PHDISLActiveFlag:%String,PHDISLSysFlag:%String,PHDISLRemark:%String")
{
}

ClassMethod GetUnSelDiseaListExecute(ByRef qHandle As %Binary, InstId As %String, diseaStr As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
	s AuStr=##class(web.DHCBL.Authorize.DHCPHDiseaseList).DHCGetDataByDefaultSession()
	s AuFlag=0
	;未授权情况下，默认显示全部数据
	if (AuStr="")||(AuStr["limited:0") s AuFlag=1
	
    s selectStr = ##class(web.DHCBL.KB.DHCPHDrugDisease).GetDiseaDr(InstId)
    s:desc'="" desc=$ZCONVERT(desc,"U")
    s PHDISLRowId=0
    for {
        s PHDISLRowId=$o(^DHCPHDISL(PHDISLRowId))
        q:PHDISLRowId=""
        s strRowId="{ID:"_PHDISLRowId_"}"
		if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
		{
            s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
            s Code = "<"_PHDISLDiseaCode_">"
            s PHDISLDiseaDesc=$p($g(^DHCPHDISL(PHDISLRowId)),"^",2)
            s PHDISLDiseaDescU=$ZCONVERT(PHDISLDiseaDesc,"U")
            s PHDISLActiveFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",3)
            continue:PHDISLActiveFlag="N"
            s PHDISLSysFlag=$p($g(^DHCPHDISL(PHDISLRowId)),"^",4)
            s PHDISLRemark=$p($g(^DHCPHDISL(PHDISLRowId)),"^",5)
            s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(PHDISLDiseaDesc)
            if ('(selectStr[Code))&('(diseaStr[Code))&((PHDISLDiseaDescU[desc)||(PINYIN[desc)) //2016-08-09
            {
                d OutputRowUn
            }
		}
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowUn
    set Data=$lb(PHDISLRowId,PHDISLDiseaCode,PHDISLDiseaDesc,PHDISLActiveFlag,PHDISLSysFlag,PHDISLRemark)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetUnSelDiseaListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnSelDiseaListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod GetUnSelDiseaListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnSelDiseaListExecute ]
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

/// Description:代码自动生成  ZD0000000 代码最大值加1
/// Table：User.DHCPHDiseaseList
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// w ##class(web.DHCBL.KB.DHCPHDiseaseList).GetLastCode()
ClassMethod GetLastCode() As %String
{
    s AutoCode=$g(^TMPAUTOCODE("AutoCode"))  //是否手动输入
    s CodeLen=$g(^TMPAUTOCODE("CodeLen"))    //代码长度
    s StartCode=$g(^TMPAUTOCODE("StartCode"))  //代码起始字符
    s code=""
    if (AutoCode="false")  //自动生成代码
    {
        s StartCodeLen=$Length(StartCode)
        s PHDISLRowId=0, preCode=""    //寻找符合规则的最大的代码
        for {
            s PHDISLRowId=$o(^DHCPHDISL(PHDISLRowId))
            q:PHDISLRowId=""
            //筛选授权后的数据
            s PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)
            if ($e(PHDISLDiseaCode,1,StartCodeLen)=StartCode)
            {
                s preCode=PHDISLDiseaCode
            }
            
        }
        //b ;1
        if (preCode="")   //如果没有符合规则的代码，则生成第一个
        {
            s zeroLen=CodeLen-StartCodeLen
            s zeroStr=""
            s count=0
            for
            {
                s count=count+1
                q:count>zeroLen
                s zeroStr=zeroStr_"0"
            }
            s preCode=StartCode_zeroStr
        }
        //b ;2
        s CodeNum=$p(preCode,StartCode,2)+1     //ZD后的数字+1
        s CodeNumLen=$Length(CodeNum)     //数字的长度
        s code=$e(preCode,1,CodeLen-CodeNumLen)_CodeNum  //组合
        //b ;3
        
        //s PHDISLDiseaCode="ZD0000000"
        /*s PHDISLDiseaCode=""
        s PHDISLRowId=$o(^DHCPHDISL(""),-1)
        s:PHDISLRowId'="" PHDISLDiseaCode=$p($g(^DHCPHDISL(PHDISLRowId)),"^",1)    //获得最大的代码
        s:PHDISLRowId="" PHDISLDiseaCode="ZD0000000"
        s CodeNum=$p(PHDISLDiseaCode,"ZD",2)+1     //ZD后的数字+1
        s CodeNumLen=$Length(CodeNum)     //数字的长度
        s code=$e("ZD0000000",1,9-CodeNumLen)_CodeNum  //组合
        s:CodeNumLen>7 code=""*/
    }
    else  //手动输入代码
    {
        s code=""
    }
    q code
}

/// 保存代码生成规则
/// Others:w ##class(web.DHCBL.KB.DHCPHDiseaseList).SaveAutoCode()
ClassMethod SaveAutoCode(AutoCode, CodeLen, StartCode) As %String
{
 
   k ^TMPAUTOCODE
   s result=""
   if ($Length(StartCode)>=CodeLen)
   {
       s result=2
       s ^TMPAUTOCODE("AutoCode")="true"
       s ^TMPAUTOCODE("CodeLen")=""
       s ^TMPAUTOCODE("StartCode")=""
   } 
   else
   {
       if (AutoCode="")||(AutoCode="0")   //自动生成代码
       {
        s ^TMPAUTOCODE("AutoCode")="false"
        s ^TMPAUTOCODE("CodeLen")=CodeLen
        s ^TMPAUTOCODE("StartCode")=StartCode
       }
       else    //手动输入代码
       {
        s ^TMPAUTOCODE("AutoCode")="true"
        s ^TMPAUTOCODE("CodeLen")=""
        s ^TMPAUTOCODE("StartCode")=""
       }
        s result=1
   }
   q result
}

/// 给表单赋值
/// Others:w ##class(web.DHCBL.KB.DHCPHDiseaseList).ShowAutoCode("AutoCode")
ClassMethod ShowAutoCode(code) As %String
{
 
   s result=""
   s result=$g(^TMPAUTOCODE(code))
   q result
}

}
