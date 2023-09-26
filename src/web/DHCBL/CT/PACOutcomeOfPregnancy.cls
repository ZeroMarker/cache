/// 名称: 妊娠结果
/// 描述: 包含增\删\改\查功能
/// 编写者：基础数据平台组-sunfengchao
/// 编写日期: 2012-8-29
Class web.DHCBL.CT.PACOutcomeOfPregnancy Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：修改时打开的数据
/// Table：User.PACOutcomeOfPregnancy
/// Input：id
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.PACOutcomeOfPregnancy).%New()
 s eobj.OPREGRowId = id
 s eobj.OPREGCode=$p($g(^PAC("OPREG",id)),"^",1)
 s eobj.OPREGDesc=$p($g(^PAC("OPREG",id)),"^",2)
 s eobj.OPREGNationalCode=$p($g(^PAC("OPREG",id)),"^",3)
 s eobj.OPREGUseForPara=$p($g(^PAC("OPREG",id)),"^",5)
 s eobj.OPREGOutcomeType=$p($g(^PAC("OPREG",id)),"^",4)
 s eobj.OPREGAutoRegister=$p($g(^PAC("OPREG",id)),"^",6)
 s eobj.OPREGAutoAdmit=$p($g(^PAC("OPREG",id)),"^",7)
 
 s:eobj.OPREGUseForPara="Y" eobj.OPREGUseForPara="true" 
 s:eobj.OPREGAutoRegister="Y" eobj.OPREGAutoRegister="true"
 s:eobj.OPREGAutoAdmit="Y" eobj.OPREGAutoAdmit="true"
 
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：sunfengchao
/// CreatDate: 2012-12-3
/// Description：数据重复验证方法,js调用
/// Table：User.PACOutcomeOfPregnancy
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("OPREG",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("OPREG",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("OPREG",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("OPREG",0,"Desc",desc,0))
  if (desc="")
  {
   if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
  elseif (code="")
  {
   if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-11-7
/// Description：数据重复验证方法
/// Table：User.PACOutcomeOfPregnancy
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
 s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
 s flag="",flagc="",flagd=""
 s:code'="" flagc=$d(^PAC("OPREG",0,"Code",code))
 s:desc'="" flagd=$d(^PAC("OPREG",0,"Desc",desc))
 if (id="") //如果为空，增加时的重复判断
 {
  if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s idc="",idd=""
  s:code'="" idc=$o(^PAC("OPREG",0,"Code",code,0))
  s:desc'="" idd=$o(^PAC("OPREG",0,"Desc",desc,0))
  if ((idc'=id)&(flagc>0))||((idd'=id)&(flagd>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：保存修改妊娠结果的内容
/// Table：User.PACOutcomeOfPregnancy
/// Input：web.Entity.CT.PACOutcomeOfPregnancy 实体类
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.PACOutcomeOfPregnancy).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.PACOutcomeOfPregnancy) As %String
{
 s $zt="ERROE"
 s result=""
 if $IsObject(eobj)
 {
  s:eobj.OPREGUseForPara="" eobj.OPREGUseForPara="N"
  s:eobj.OPREGAutoRegister="" eobj.OPREGAutoRegister="N"
  s:eobj.OPREGAutoAdmit="" eobj.OPREGAutoAdmit="N"
  
  s flag=..Validate(eobj.OPREGRowId,eobj.OPREGCode,eobj.OPREGDesc)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
   if (eobj.OPREGRowId="")  //如果RowId未赋值则增加
   {
    s obj=##class(User.PACOutcomeOfPregnancy).%New()
   }
   else                    
   {
     s obj=##class(User.PACOutcomeOfPregnancy).%OpenId(eobj.OPREGRowId)
     s bobj=##class(web.Entity.CT.PACOutcomeOfPregnancy).%New()
     s bobj.OPREGRowId=eobj.OPREGRowId
     s bobj.OPREGCode = obj.OPREGCode          
     s bobj.OPREGDesc = obj.OPREGDesc          
     s bobj.OPREGNationalCode=obj.OPREGNationalCode
     s bobj.OPREGUseForPara=obj.OPREGUseForPara
     s bobj.OPREGOutcomeType=obj.OPREGOutcomeType
     s bobj.OPREGAutoRegister = obj.OPREGAutoRegister
     s bobj.OPREGAutoAdmit = obj.OPREGAutoAdmit  
   }
   Ts                    
   s obj.OPREGCode = eobj.OPREGCode          
   s obj.OPREGDesc = eobj.OPREGDesc          
   s obj.OPREGNationalCode=eobj.OPREGNationalCode
   s obj.OPREGUseForPara=eobj.OPREGUseForPara
   s obj.OPREGOutcomeType=eobj.OPREGOutcomeType
   s obj.OPREGAutoRegister = eobj.OPREGAutoRegister
   s obj.OPREGAutoAdmit = eobj.OPREGAutoAdmit  
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result= "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.OPREGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_OutcomeOfPregnancy","User.PACOutcomeOfPregnancy","妊娠结果",id,eobj.OPREGDesc,"A",eobj)
    d:eobj.OPREGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_OutcomeOfPregnancy","User.PACOutcomeOfPregnancy","妊娠结果",eobj.OPREGRowId,eobj.OPREGDesc,"U",eobj,bobj)
   }
   else
   {
    Trollback
    s result= "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("妊娠结果","web.DHCBL.CT.PACOutcomeOfPregnancy","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }  
 }
 else
 {
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("妊娠结果","web.DHCBL.CT.PACOutcomeOfPregnancy","SaveEntity","")
  s ^ERRORLOGINFO(logid)="对象不存在！"
  s result= "{success:'false',errorinfo:'对象不存在！'}"
 }
 q result
ERROE
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("妊娠结果","web.DHCBL.CT.PACOutcomeOfPregnancy","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'ERROR保存失败！'}"
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：根据ID删除妊娠结果的内容
/// Table：User.PACOutcomeOfPregnancy
/// Input：Id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result=""
 s eobj = ##class(web.Entity.CT.PACOutcomeOfPregnancy).%New()
 s eobj.OPREGRowId = id
 s eobj.OPREGCode=$p($g(^PAC("OPREG",id)),"^",1)
 s eobj.OPREGDesc=$p($g(^PAC("OPREG",id)),"^",2)
 s eobj.OPREGNationalCode=$p($g(^PAC("OPREG",id)),"^",3)
 s eobj.OPREGUseForPara=$p($g(^PAC("OPREG",id)),"^",5)
 s eobj.OPREGOutcomeType=$p($g(^PAC("OPREG",id)),"^",4)
 s eobj.OPREGAutoRegister=$p($g(^PAC("OPREG",id)),"^",6)
 s eobj.OPREGAutoAdmit=$p($g(^PAC("OPREG",id)),"^",7)
 
 s sc=##class(User.PACOutcomeOfPregnancy).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result= "{success:'true',info:'删除成功！'}"
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("PAC_OutcomeOfPregnancy","User.PACOutcomeOfPregnancy","妊娠结果",id,eobj.OPREGDesc,"D",eobj)
  d eobj.%Close()
 }
 else
 {
  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("妊娠结果","web.DHCBL.CT.PACOutcomeOfPregnancy","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
}

/// Creator：sunfengchao
/// CreatDate: 2012-8-29
/// Description：查询妊娠结果的内容
/// Table： PAC_OutcomeOfPregnancy
/// Input：rowid,code,desc
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACOutcomeOfPregnancy","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, OutcomeType As %String) As %Query(ROWSPEC = "OPREGRowId:%String,OPREGCode:%String,OPREGDesc:%String,OPREGNationalCode:%String,OPREGUseForPara:%String,OPREGOutcomeType:%String,OPREGAutoRegister:%String,OPREGAutoAdmit:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, OutcomeType As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACOutcomeOfPregnancy).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") 
 {
   s OPREGRowId=rowid
   s OPREGCode=$p($g(^PAC("OPREG",OPREGRowId)),"^",1)
   s OPREGDesc=$p($g(^PAC("OPREG",OPREGRowId)),"^",2)
   s OPREGNationalCode=$p($g(^PAC("OPREG",OPREGRowId)),"^",3)
   s OPREGUseForPara=$p($g(^PAC("OPREG",OPREGRowId)),"^",5)
   s OPREGOutcomeType=$p($g(^PAC("OPREG",OPREGRowId)),"^",4)
   s OPREGAutoRegister=$p($g(^PAC("OPREG",OPREGRowId)),"^",6)
   s OPREGAutoAdmit=$p($g(^PAC("OPREG",OPREGRowId)),"^",7)
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_OutcomeOfPregnancy",OPREGRowId)
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
   s OPREGRowId=0
   for
   {
     s OPREGRowId=$o(^PAC("OPREG",OPREGRowId))
     q:OPREGRowId=""
     ;筛选授权后的数据
     s strRowId="{ID:"_OPREGRowId_"}"
     if (AuStr[strRowId)||(AuFlag=1) 
     {
       s OPREGCode=$p($g(^PAC("OPREG",OPREGRowId)),"^",1)
       s OPREGDesc=$p($g(^PAC("OPREG",OPREGRowId)),"^",2)   
       s OPREGNationalCode=$p($g(^PAC("OPREG",OPREGRowId)),"^",3)
       s OPREGUseForPara=$p($g(^PAC("OPREG",OPREGRowId)),"^",5)
       s OPREGOutcomeType=$p($g(^PAC("OPREG",OPREGRowId)),"^",4)
       s OPREGAutoRegister=$p($g(^PAC("OPREG",OPREGRowId)),"^",6)
       s OPREGAutoAdmit=$p($g(^PAC("OPREG",OPREGRowId)),"^",7) 
       s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
       s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("PAC_OutcomeOfPregnancy",OPREGRowId)
       s BDPInternalCode =$p($g(resultStr),"^",1)       
       s BDPInternalDesc = $p($g(resultStr),"^",2)  
       s BDPHospNationalCode=$p($g(resultStr),"^",3)         
       s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
       if (desc'="")
       {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_OutcomeOfPregnancy",OPREGRowId,OPREGDesc,desc)
       }
       else
       {
         s AliasFlag=1   
       } 
       if ($ZCVT(OPREGCode,"U")[code)&(AliasFlag=1)&((OPREGOutcomeType=OutcomeType)||(OutcomeType="")) 
       {
         d OutputRow
       }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(OPREGRowId,OPREGCode,OPREGDesc,OPREGNationalCode,OPREGUseForPara,OPREGOutcomeType,OPREGAutoRegister,OPREGAutoAdmit,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc )
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
/// Description：查询妊娠结果的内容,用于combox查询
/// Table：User.PACOutcomeOfPregnancy
/// Input：rowid,code,desc
/// Return：OPREGRowId,OPREGCode,OPREGDesc
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.PACOutcomeOfPregnancy","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "OPREGRowId:%String,OPREGCode:%String,OPREGDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 //获取授权Json
 s AuStr=##class(web.DHCBL.Authorize.PACOutcomeOfPregnancy).DHCGetDataByDefaultSession()
 s AuFlag=0
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s OPREGRowId=rowid
  s OPREGCode=$p($g(^PAC("OPREG",OPREGRowId)),"^",1)
  s OPREGDesc=$p($g(^PAC("OPREG",OPREGRowId)),"^",2)
  d OutputRow2
 }
 else
 {
    s:code'="" code=$$ALPHAUP^SSUTIL4(code) //转换成大写
    s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //转换成大写
    s OPREGRowId=0
    for
    {
      s OPREGRowId=$o(^PAC("OPREG",OPREGRowId))
      q:OPREGRowId=""
       //筛选授权后的数据
      s strRowId="{ID:"_OPREGRowId_"}"
      if (AuStr[strRowId)||(AuFlag=1) 
      {
        s OPREGCode=$p($g(^PAC("OPREG",OPREGRowId)),"^",1)
        s OPREGDesc=$p($g(^PAC("OPREG",OPREGRowId)),"^",2)
        if (desc'="")
        {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("PAC_OutcomeOfPregnancy",OPREGRowId,OPREGDesc,desc)
        }
        else
        {
         s AliasFlag=1   
        } 
        if ($ZCVT(OPREGCode,"U")[code)&(AliasFlag=1)
        {
          d OutputRow2
        }
     }
   }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(OPREGRowId,OPREGCode,OPREGDesc)
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
