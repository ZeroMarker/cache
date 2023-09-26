Import SQLUser

/// 名称: 患者费别维护
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-31
Class web.DHCBL.CT.PACAdmReason Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "PAC_AdmReason";

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.PACAdmReason
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
    s str="" 
    s eobj = ##class(web.Entity.CT.PACAdmReason).%New()
    s eobj.REARowId = id
    s eobj.REACode=$p($g(^PAC("ADMREA",eobj.REARowId)),"^",1)
    s eobj.READesc=$p($g(^PAC("ADMREA",eobj.REARowId)),"^",2)
    s eobj.READateFrom=$p($g(^PAC("ADMREA",eobj.REARowId)),"^",3)
    s eobj.READateTo=$p($g(^PAC("ADMREA",eobj.REARowId)),"^",4)
    s eobj.REANationalCode=$p($g(^PAC("ADMREA",eobj.REARowId)),"^",5)
    s eobj.REAAdmSource=$p($g(^PAC("ADMREA",eobj.REARowId)),"^",9)
    s:eobj.READateFrom'="" eobj.READateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.READateFrom) //转换日期格式
    s:eobj.READateTo'="" eobj.READateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(eobj.READateTo) //转换日期格式

    s str = eobj.JsonS() 
    d eobj.%Close()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.PACAdmReason
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
    s flag=0
    if $$ALPHAUP^SSUTIL4(code)'=""
    {
        s idc=0
        for
        {
            s idc=$o(^PAC("ADMREA",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
            if (idc'=id)
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idc,hospid)
                continue:showflag="N"
                s flag=1
            }
        }
    }
    
    if $$ALPHAUP^SSUTIL4(desc)'=""
    {
        s idd=0
        for
        {
    
            s idd=$o(^PAC("ADMREA",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
            if (idd'=id)
            {
                s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,idd,hospid)
                continue:showflag="N"
                s flag=1
            }
        }
    }
    q flag
}

/// CreatDate: 2012-8-31
/// Description：保存修改患者费别的内容
/// Table：User.PACAdmReason
/// Input：web.Entity.CT.PACAdmReason 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACAdmReason).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACAdmReason) As %String
{
    s $zt="ERROE"
    s result=""
    if $IsObject(eobj)
    {
        s:eobj.READateFrom'="" eobj.READateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.READateFrom)  //转换日期
        s:eobj.READateTo'="" eobj.READateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.READateTo)      //转换日期
        s:eobj.READateFrom="" eobj.READateFrom=+$h
        s flag=..FormValidate(eobj.REARowId,eobj.REACode,eobj.READesc,eobj.LinkHospId)  //调用重复验证
        if (flag=1)
        {
            s result = "{success:'false',errorinfo:'该记录已经存在！'}"
        }
        else
        {
            if (eobj.REARowId="")  //如果RowId未赋值则增加
            {
                s obj=##class(User.PACAdmReason).%New()
            }
            else                   //如果RowId已赋值则修改
            {
                s obj=##class(User.PACAdmReason).%OpenId(eobj.REARowId)
                s bobj=##class(web.Entity.CT.PACAdmReason).%New()
                s bobj.REARowId=eobj.REARowId
                s bobj.REACode = obj.REACode          
                s bobj.READesc = obj.READesc          
                s bobj.READateFrom = obj.READateFrom   
                s bobj.READateTo = obj.READateTo      
                s bobj.REAAdmSource = obj.REAAdmSource
                s bobj.REANationalCode=obj.REANationalCode 
            }
            Ts         
            s obj.REACode = eobj.REACode          //修改代码
            s obj.READesc = eobj.READesc          //修改描述
            s obj.READateFrom = eobj.READateFrom  //修改开始日期
            s obj.READateTo = eobj.READateTo      //修改结束日期
            s obj.REAAdmSource = eobj.REAAdmSource
            s obj.REANationalCode=eobj.REANationalCode
            s sc=obj.%Save()
            d obj.%Close()
            If $$$ISOK(sc)
            {
                Tc
                s id = obj.%Id()
                s result= "{success:'true',id:'"_id_"'}"         //返回RowId
                //保存日志
                d:eobj.REARowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmReason","User.PACAdmReason","患者费别",id,eobj.READesc,"A",eobj)
                d:eobj.REARowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmReason","User.PACAdmReason","患者费别",eobj.REARowId,eobj.READesc,"U",eobj,bobj)
            }
            else
            {
                Trollback
                s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
                s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者费别","web.DHCBL.CT.PACAdmReason","SaveEntity",eobj)
                s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
            }
        }  
    }
    else
    {
        s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者费别","web.DHCBL.CT.PACAdmReason","SaveEntity","")
        s ^ERRORLOGINFO(logid)="对象不存在！"
        s result= "{success:'false',errorinfo:'对象不存在！'}"
    }
    q result
ERROE
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者费别","web.DHCBL.CT.PACAdmReason","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=$ze
    q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Function:用于数据删除时的逻辑判断
/// CreateDate:2015-5-13
/// Ctreator:Sunfengchao
/// Input:rowid 
/// Output:返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
/// debug: w ##class(web.DHCBL.CT.PACAdmReason).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="",myInfo=""
    if $d(^DHCTARIi("Type",id)) s myInfo=myInfo_"<收费项目价格表>"   //DHC_TarItemPrice
    if $d(^DHCPACADM(0,"AdmReason",id)) s myInfo=myInfo_"<病人类型与费别对照>"   //DHC_PACADM 
    if $d(^DHCSOPADMRExpi(0,"ADMR",id)) s myInfo=myInfo_"<收费类别与发票类型配置>"   // DHC_SOPADMReasonExp
    if $d(^DHCTARF(0,"ADMTYPE",id)) s myInfo=myInfo_"<User.DHCTarFactor>"   // DHC_SOPADMReasonExp
    
    s found1=0
    s ADMRowId=0
    For  
    {
        Set ADMRowId=$o(^PAC("ADMCAT",ADMRowId)) 
        Quit:ADMRowId="" 
        if $d(^DHCJFARREARS(0,"AdmReason",ADMRowId,id)) s found1=1
        quit:found1=1 
    } 
    if (found1=1) s myInfo=myInfo_"<欠费额度设置>"  
    
   
    s found1=0
    s rowid=0
    for
    {
        s rowid=$O(^DHCJFSSGRPADMREASONCONFIG(rowid))
        q:rowid=""
        s GrpReaAdmReasonDr=""
        s GrpReaAdmReasonDr=$p($g(^DHCJFSSGRPADMREASONCONFIG(rowid)),"^",2)
        if (GrpReaAdmReasonDr=id)
        {
            s found1=1
        }
    }
    if (found1=1)  s myInfo=myInfo_"<安全组与病人类型配置>" 
    
    s PTRowid=0
    for
    {
        s PTRowid=$O(^DHCPrescriptType(PTRowid))
        q:PTRowid=""
        s PTType=""
        s PTType=$p($g(^DHCPrescriptType(PTRowid)),"^",9)
        if (PTType=id)
        {
            s found1=1
        }
    }
    if (found1=1)  s myInfo=myInfo_"<处方类型>"  
    
    // User.DHCPACADM   费别与处方对照
    s AILBillRowid=0
    for
    {
        s AILBillRowid=$O(^DHCPAADMPrescType(AILBillRowid))
        q:AILBillRowid=""
        s AILBillType=""
        s AILBillType=$p($g(^DHCPAADMPrescType(AILBillRowid)),"^",2)
        if (AILBillType=id)
        {
            s found1=1
        }
    }
    if (found1=1)  s myInfo=myInfo_"<费别与处方对照>" 
     
     // User.DHCTarPara   系统配置参数
    s TMDefaultRowid=0
    for
    {
        s TMDefaultRowid=$O(^DHCTarC("CF",TMDefaultRowid))
        q:TMDefaultRowid=""
        s TMDefaultInsType=""
        s TMDefaultInsType=$p($g(^DHCTarC("CF",TMDefaultRowid)),"^",3)
        if (TMDefaultInsType=id)
        {
            s found1=1
        }
    }
    if (found1=1)  s myInfo=myInfo_"<系统配置参数>" 
     
    if (myInfo="")
    {
        s return="0^未被引用可删除！"
    }
    else 
    {
        s return="1^在"_myInfo_"表里被引用,不能删除!"
    }
    q return
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：根据ID删除患者费别的内容
/// Table：User.PACAdmReason
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag="",RefFlag="",re=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=1)
    {
        s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
        s eobj = ##class(web.Entity.CT.PACAdmReason).%New()
        s eobj.REARowId = id
        s eobj.REACode=$p($g(^PAC("ADMREA",eobj.REARowId)),"^",1)
        s eobj.READesc=$p($g(^PAC("ADMREA",eobj.REARowId)),"^",2)
        s eobj.READateFrom=$p($g(^PAC("ADMREA",eobj.REARowId)),"^",3)
        s eobj.READateTo=$p($g(^PAC("ADMREA",eobj.REARowId)),"^",4)
        s eobj.REANationalCode=$p($g(^PAC("ADMREA",eobj.REARowId)),"^",5)
        s eobj.REAAdmSource=$p($g(^PAC("ADMREA",eobj.REARowId)),"^",9)

        s sc=##class(User.PACAdmReason).%DeleteId(id)
        if $$$ISOK(sc)
        {
            s result= "{success:'true',info:'删除成功！'}" 
            //保存日志
            d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_AdmReason","User.PACAdmReason","患者费别",id,eobj.READesc,"D",eobj)
            d eobj.%Close()
        }
        else 
        {
            s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
            s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("患者费别","web.DHCBL.CT.PACAdmReason","DeleteData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
        }
    }
    q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-31
/// Description：查询患者费别的内容
/// Table： PAC_AdmReason
/// Input：rowid,code,desc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAdmReason","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "REARowId:%String,REACode:%String,READesc:%String,READateFrom:%String,READateTo:%String,REANationalCode:%String,REAAdmSource:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACAdmReason).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
   s REARowId=rowid
   s REACode=$p($g(^PAC("ADMREA",REARowId)),"^",1)
   s READesc=$p($g(^PAC("ADMREA",REARowId)),"^",2)
   s READateFrom=$p($g(^PAC("ADMREA",REARowId)),"^",3)
   s READateTo=$p($g(^PAC("ADMREA",REARowId)),"^",4)
   s REANationalCode=$p($g(^PAC("ADMREA",REARowId)),"^",5)
   s REAAdmSource=$p($g(^PAC("ADMREA",REARowId)),"^",9)
   s:READateFrom'="" READateFrom=$zd(READateFrom,1)  
   s:READateTo'="" READateTo=$zd(READateTo,1)  
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AdmReason",REARowId)
   s BDPInternalCode =$p($g(resultStr),"^",1)       
   s BDPInternalDesc = $p($g(resultStr),"^",2)  
   s BDPHospNationalCode=$p($g(resultStr),"^",3)         
   s BDPHospNationalDesc = $p($g(resultStr),"^",4)
   d OutputRow
 }
 else
 {
   s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
   s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
   s REARowId=0
   for 
   {
     s REARowId=$o(^PAC("ADMREA",REARowId))
     q:REARowId=""
     ;筛选授权后的数据
     s strRowId="{ID:"_REARowId_"}"
     if (AuStr[strRowId)||(AuFlag=1) 
     {
        s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,REARowId,hospid)
        continue:showflag="N"
        s REACode=$p($g(^PAC("ADMREA",REARowId)),"^",1)
        s READesc=$p($g(^PAC("ADMREA",REARowId)),"^",2)
        s READateFrom=$p($g(^PAC("ADMREA",REARowId)),"^",3)
        s READateTo=$p($g(^PAC("ADMREA",REARowId)),"^",4)
        s REANationalCode=$p($g(^PAC("ADMREA",REARowId)),"^",5)
        s REAAdmSource=$p($g(^PAC("ADMREA",REARowId)),"^",9)
        s:READateFrom'="" READateFrom=$zd(READateFrom,1)  
        s:READateTo'="" READateTo=$zd(READateTo,1)  
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_AdmReason",REARowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)       
        s BDPInternalDesc = $p($g(resultStr),"^",2)  
        s BDPHospNationalCode=$p($g(resultStr),"^",3)         
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        if (desc'="")
        {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AdmReason",REARowId,READesc,desc)
        }
        else
        {
            s AliasFlag= 1   
        }    
        if ($ZCVT(REACode,"U")[code)&(AliasFlag=1)   
        {
            d OutputRow
        }
      }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(REARowId,REACode,READesc,READateFrom,READateTo,REANationalCode,REAAdmSource,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Creator：sunfengchao
/// CreatDate: 2012-12-10
/// Description：查询患者费别的内容,用于combox查询
/// Table：User.PACAdmReason
/// Input：rowid,code,desc
/// Return：REARowId,REACode,READesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACAdmReason","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "REARowId:%String,REACode:%String,READesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACAdmReason).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s REARowId=rowid
  s REACode=$p($g(^PAC("ADMREA",REARowId)),"^",1)
  s READesc=$p($g(^PAC("ADMREA",REARowId)),"^",2)
  d OutputRow2
 }
 else
 {
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
  s REARowId=0
  for
  {
   s REARowId=$o(^PAC("ADMREA",REARowId))
   q:REARowId=""
   s READateFrom=$p($g(^PAC("ADMREA",REARowId)),"^",3)
   continue:(READateFrom'="")&&(READateFrom>+$h)
   s READateTo=$p($g(^PAC("ADMREA",REARowId)),"^",4) 
   continue:(READateTo'="")&&(READateTo<+$h)
   //筛选授权后的数据
   s strRowId="{ID:"_REARowId_"}"
   if (AuStr[strRowId)||(AuFlag=1) 
   {
     s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,REARowId,hospid)
     continue:showflag="N"
     
     s REACode=$p($g(^PAC("ADMREA",REARowId)),"^",1)
     s READesc=$p($g(^PAC("ADMREA",REARowId)),"^",2)
     if (desc'="")
     {
        ;需要对描述或者别名进行检索      
        s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_AdmReason",REARowId,READesc,desc)
     }
     else
     {
        s AliasFlag= 1   
     }    
     if ($ZCVT(REACode,"U")[code)&(AliasFlag=1)  
     {
      d OutputRow2
     }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(REARowId,REACode,READesc)
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

}
