/// 名称:病人管理 -  病人位置分组   
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期:2016-8-4
Class web.DHCBL.CT.PACBroadPatientGroup Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2016-8-4
/// Description:查询 病人位置分组
/// Table:User.PACBroadPatientGroup
/// Input:rowid,code,desc
/// Return:BPGRowId,BPGCode,BPGDesc,BPGDateFrom,BPGDateTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBroadPatientGroup","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BPGRowId:%String,BPGCode:%String,BPGDesc:%String,BPGDateFrom:%String,BPGDateTo:%String,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    
    if (rowid'="")
    {
        s BPGRowId=rowid
        s BPGCode=$p($g(^PAC("BPG",BPGRowId)),"^",1)
        s BPGDesc=$p($g(^PAC("BPG",BPGRowId)),"^",2)
        s BPGDateFrom=$p($g(^PAC("BPG",BPGRowId)),"^",3)
        s BPGDateTo=$p($g(^PAC("BPG",BPGRowId)),"^",4)
        s:BPGDateFrom'="" BPGDateFrom=$zd(BPGDateFrom,1)
        s:BPGDateTo'="" BPGDateTo=$zd(BPGDateTo,1)
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_BroadPatientGroup",BPGRowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
        d OutputRow
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s AuStr=##class(web.DHCBL.Authorize.PACBroadPatientGroup).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        s BPGRowId=0
        for
        {
            s BPGRowId=$o(^PAC("BPG",BPGRowId)) q:BPGRowId=""
            s strRowId="{ID:"_BPGRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s BPGCode=$p($g(^PAC("BPG",BPGRowId)),"^",1)
                s BPGDesc=$p($g(^PAC("BPG",BPGRowId)),"^",2)
                s BPGDateFrom=$p($g(^PAC("BPG",BPGRowId)),"^",3)
                s BPGDateTo=$p($g(^PAC("BPG",BPGRowId)),"^",4)
                s:BPGDateFrom'="" BPGDateFrom=$zd(BPGDateFrom,1)
                s:BPGDateTo'="" BPGDateTo=$zd(BPGDateTo,1)
                s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
                s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_BroadPatientGroup",BPGRowId)
                s BDPInternalCode =$p($g(resultStr),"^",1)       
                s BDPInternalDesc = $p($g(resultStr),"^",2)  
                s BDPHospNationalCode=$p($g(resultStr),"^",3)         
                s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
                if (desc'="")           
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_BroadPatientGroup",BPGRowId,BPGDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                } 
                i ($zcvt(BPGCode,"u")[code)&(AliasFlag=1)
                {
                    d OutputRow
                }
            }
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow
    set Data=$lb(BPGRowId,BPGCode,BPGDesc,BPGDateFrom,BPGDateTo,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
    Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)
    Quit $$$OK
}

/// Creator:陈莹
/// CreatDate:2016-8-4
/// Description:为combobox查询取数据
/// Table:User.PACBroadPatientGroup
/// Input:code,desc
/// Return:BPGRowId,BPGCode,BPGDesc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACBroadPatientGroup","GetDataForCmb1","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BPGRowId:%String,BPGCode:%String,BPGDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
    s ind=1
    if (rowid'="")
    {
        s BPGRowId=rowid
        s BPGCode=$p($g(^PAC("BPG",BPGRowId)),"^",1)
        s BPGDesc=$p($g(^PAC("BPG",BPGRowId)),"^",2)
        d OutputRowCmb
    }
    else
    {
        s:code'="" code=$ZCONVERT(code,"U")
        s:desc'="" desc=$ZCONVERT(desc,"U")
        s AuStr=##class(web.DHCBL.Authorize.PACBroadPatientGroup).DHCGetDataByDefaultSession()
        s AuFlag=0
        ;未授权情况下，默认显示全部数据
        if (AuStr="")||(AuStr["limited:0") s AuFlag=1
        s BPGRowId=0
        for
        {
            s BPGRowId=$o(^PAC("BPG",BPGRowId)) q:BPGRowId=""
            s strRowId="{ID:"_BPGRowId_"}"
            if (AuStr[strRowId)||(AuFlag=1) ;用来筛选授权数据
            {
                s BPGCode=$p($g(^PAC("BPG",BPGRowId)),"^",1)
                s BPGDesc=$p($g(^PAC("BPG",BPGRowId)),"^",2)
                s BPGDateFrom=$p($g(^PAC("BPG",BPGRowId)),"^",3)
                continue:(BPGDateFrom'="")&&(BPGDateFrom>+$h)
                s BPGDateTo=$p($g(^PAC("BPG",BPGRowId)),"^",4) 
                continue:(BPGDateTo'="")&&(BPGDateTo<+$h)
                if (desc'="")           
                {
                    ;需要对描述或者别名进行检索      
                    s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_BroadPatientGroup",BPGRowId,BPGDesc,desc)
                }
                else
                {
                    s AliasFlag= 1   
                } 
                i ($zcvt(BPGCode,"u")[code)&(AliasFlag=1)
                {
                    d OutputRowCmb
                }
            }
        }
    }
    
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRowCmb
    set Data=$lb(BPGRowId,BPGCode,BPGDesc)
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

/// Creator:陈莹
/// CreatDate:2016-8-4
/// Description:数据重复验证方法,js调用
/// Table:User.PACBroadPatientGroup
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.PACBroadPatientGroup).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    new (id,code,desc)
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //$ZCONVERT(code,"U")
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //$ZCONVERT(desc,"U")
    s flag=""
    s flagc=""
    s flagd=""
    s:code'="" flagc=$d(^PAC("BPG",0,"Code",code))
    s:desc'="" flagd=$d(^PAC("BPG",0,"Desc",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0))
        {
            s flag=1  //返回重复标志
        }
        else
        {
            s flag=0 //返回不重复标志
        }
    }
    else //如果不为空，修改时的重复判断
    {
        s idc=""
        s idd=""
        s:code'="" idc=$o(^PAC("BPG",0,"Code",code,0))
        s:desc'="" idd=$o(^PAC("BPG",0,"Desc",desc,0))
    
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
            
    }
    q flag
}

/// Creator:陈莹
/// CreatDate:2016-8-4
/// Description:双击修改时,从后台取数据
/// Table:User.PACBroadPatientGroup
/// Input:id
/// Return:Json格式的字符串str={list:[BPGCode,BPGDesc,BPGDateFrom,BPGDateTo,BPGRowId]}
/// Other:d ##class(web.DHCBL.CT.PACBroadPatientGroup).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    new (id)
    s str=""
    s pobj = ##class(User.PACBroadPatientGroup).%OpenId(id)
    s eobj = ##class(web.Entity.CT.PACBroadPatientGroup).%New()
    s eobj.BPGRowId = id
    s eobj.BPGCode = pobj.BPGCode
    s eobj.BPGDesc = pobj.BPGDesc
    s eobj.BPGDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.BPGDateFrom)
    s eobj.BPGDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.BPGDateTo)
    d pobj.%Close()
    k pobj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator:陈莹
/// CreatDate:2016-8-4
/// Description:增加/修改 病人位置分组
/// Table:User.PACBroadPatientGroup
/// Input:web.Entity.CT.PACBroadPatientGroup
/// Return:成功返回success:'true'和新增或修改的数据的BPGRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.PACBroadPatientGroup) As %String
{
    new (eobj,%session)
    s $zt="ERROR"
    s result=""
    if $IsObject(eobj)
    {
        s:eobj.BPGDateFrom'="" eobj.BPGDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BPGDateFrom)
        s:eobj.BPGDateTo'="" eobj.BPGDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BPGDateTo)
        s:eobj.BPGDateFrom="" eobj.BPGDateFrom = +$h
        s flag=..FormValidate(eobj.BPGRowId,eobj.BPGCode,eobj.BPGDesc)  //调用重复验证
        if (flag=1)
        {
            q "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        if (eobj.BPGRowId="")       
        {
            s obj=##class(User.PACBroadPatientGroup).%New()
        }
        else                           
        {
            s obj=##class(User.PACBroadPatientGroup).%OpenId(eobj.BPGRowId)
            s bobj = ##class(web.Entity.CT.PACBroadPatientGroup).%New()
            s bobj.BPGRowId = eobj.BPGRowId
            s bobj.BPGCode = obj.BPGCode
            s bobj.BPGDesc = obj.BPGDesc
            s bobj.BPGDateFrom=obj.BPGDateFrom
            s bobj.BPGDateTo=obj.BPGDateTo
            
        }

        s obj.BPGCode = eobj.BPGCode
        s obj.BPGDesc = eobj.BPGDesc
        s obj.BPGDateFrom=eobj.BPGDateFrom
        s obj.BPGDateTo=eobj.BPGDateTo
        
        Tstart
        s sc=obj.%Save()
        do obj.%Close()
        if $$$ISOK(sc){
            Tcommit
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"
            d:eobj.BPGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BroadPatientGroup","User.PACBroadPatientGroup","病人位置分组",id,eobj.BPGDesc,"A",eobj)
            d:eobj.BPGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BroadPatientGroup","User.PACBroadPatientGroup","病人位置分组",id,eobj.BPGDesc,"U",eobj,bobj)
        }else{
            Trollback
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病人位置分组","web.DHCBL.CT.PACBroadPatientGroup","SaveEntity",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
        }   
                    
    }
    else
    {
        s result = "{success:'false',errorinfo:'对象不存在！'}"
    }   
    q result
ERROR
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病人位置分组","web.DHCBL.CT.PACBroadPatientGroup","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator:陈莹
/// CreatDate:2016-8-4
/// Description:根据id删除 病人位置分组
/// Table:User.PACBroadPatientGroup
/// Input:id(PACBroadPatientGroup的BPGRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}";失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.PACBroadPatientGroup).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result=""
    s re=##class(web.DHCBL.CT.PACBroadPatientGroup).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag'=0){
        s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        s pobj = ##class(User.PACBroadPatientGroup).%OpenId(id)
        s eobj = ##class(web.Entity.CT.PACBroadPatientGroup).%New()
        s eobj.BPGRowId = id
        s eobj.BPGCode = pobj.BPGCode
        s eobj.BPGDesc = pobj.BPGDesc
        s eobj.BPGDateFrom = pobj.BPGDateFrom 
        s eobj.BPGDateTo = pobj.BPGDateTo 
        d pobj.%Close()
        k pobj
        Tstart
        s sc=##class(User.PACBroadPatientGroup).%DeleteId(id)
        if $$$ISOK(sc){
            Tcommit
            s result="{success:'true',info:'删除成功！'}"
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_BroadPatientGroup","User.PACBroadPatientGroup","病人位置分组",id,eobj.BPGDesc,"D",eobj)
        }
        else{
            Trollback
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("病人位置分组","web.DHCBL.CT.PACBroadPatientGroup","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        }
    }
    q result
}

/// Creator:陈莹
/// CreatDate:2016-8-4
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    
    s return="0^未被引用可删除！"
    
    s flag=0
    s CTLOCRowID=0
    for  
    {
        s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""
        s CTLOCBroadPatientGroupDR=$p($g(^CTLOC(CTLOCRowID)),"^",33)    //病人位置分组
        i CTLOCBroadPatientGroupDR=id s flag=1
    }
    if (flag) s myInfo=myInfo_"<科室/病区表>"   ;CTLoc

    
    i myInfo="" s return="0^未被引用可删除!"
    else  s return="1^在"_myInfo_"表里被引用,不能删除!"
    q return
}

}
