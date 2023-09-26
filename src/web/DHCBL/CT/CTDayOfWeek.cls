/// Function: 资源预约- 星期维护
/// Creator: sunfengchao
/// CreateDate: 2015-5-28 
Class web.DHCBL.CT.CTDayOfWeek Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function：查询资源预约- 星期的数据
/// Creator:  sunfengchao
/// CreateDate: 2015-5-28 
/// Table：   CT_DayOfWeek
/// Debug:    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTDayOfWeek","GetList","","","")
Query GetList(rowid As %String, desc As %String) As %Query(ROWSPEC = "DOWRowId,DOWDay,DOWName,DOWSequence,DOWChecked,DOWWeekend,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   s AuStr=##class(web.DHCBL.Authorize.CTDayOfWeek).DHCGetDataByDefaultSession()
   s AuFlag=0
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示 
   if (rowid'="") 
   { 
     s DOWRowId=rowid 
     s DOWDay=rowid 
     s DOWName=$p($g(^CT("DOW",1,rowid)),"^",1)
     s DOWSequence= $p($g(^CT("DOW",1,rowid)),"^",2)
     s DOWChecked=$p($g(^CT("DOW",1,rowid)),"^",3)
     s DOWWeekend=$p($g(^CT("DOW",1,rowid)),"^",4)
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_DayOfWeek",DOWRowId)
     s BDPInternalCode =$p($g(resultStr),"^",1)       
     s BDPInternalDesc = $p($g(resultStr),"^",2)  
     s BDPHospNationalCode=$p($g(resultStr),"^",3)         
     s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     d OutputRow
   }
   else
   {
     s:desc'="" desc=$ZCONVERT(desc,"U")  
     s DOWRowId=0
     for 
     {
        s DOWRowId=$o(^CT("DOW",1,DOWRowId))
        q:DOWRowId=""
        s strRowId="{ID:"_DOWRowId_"}"
        if (AuStr[strRowId)||(AuFlag=1) 
        {  
          s DOWDay=DOWRowId 
          s DOWName=$p($g(^CT("DOW",1,DOWRowId)),"^",1) 
          s DOWSequence= $p($g(^CT("DOW",1,DOWRowId)),"^",2)
          s DOWChecked=$p($g(^CT("DOW",1,DOWRowId)),"^",3)
          s DOWWeekend=$p($g(^CT("DOW",1,DOWRowId)),"^",4)
          s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
          s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_DayOfWeek",DOWRowId)
          s BDPInternalCode =$p($g(resultStr),"^",1)       
          s BDPInternalDesc = $p($g(resultStr),"^",2)  
          s BDPHospNationalCode=$p($g(resultStr),"^",3)         
          s BDPHospNationalDesc = $p($g(resultStr),"^",4)
          if (desc'="")
          {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_DayOfWeek",DOWRowId,DOWName,desc)
          }
          else
          {
            s AliasFlag= 1   
          }  
          if (AliasFlag=1)
          {
            d OutputRow
          }
       }
     }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb( DOWRowId,DOWDay,DOWName,DOWSequence,DOWChecked,DOWWeekend,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function: 查询数据的接口
/// Creator:  sunfengchao
/// CreateDate: 2015-5-29
/// Table:   CTDayOfWeek
/// Others:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTDayOfWeek","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, desc As %String) As %Query(ROWSPEC = "DOWRowId,DOWDay,DOWName")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   s AuStr=##class(web.DHCBL.Authorize.CTDayOfWeek).DHCGetDataByDefaultSession()
   s AuFlag=0
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 //判断是否有授权,如果没有则全部显示 
   
   if (rowid'="") 
   {   
     s DOWRowId=rowid 
     s DOWDay=rowid 
     s DOWName=$p($g(^CT("DOW",1,rowid)),"^",1)
     d OutputRowCmb
   }
   else
   {
     s:desc'="" descI=$ZCONVERT(desc,"U")  
     s DOWRowId=0
     for 
     {
        s DOWRowId=$o(^CT("DOW",1,DOWRowId))
        q:DOWRowId=""
        s strRowId="{ID:"_DOWRowId_"}"
        if (AuStr[strRowId)||(AuFlag=1) 
        {   
          s DOWDay=DOWRowId 
          s DOWName=$p($g(^CT("DOW",1,DOWRowId)),"^",1)
          if (desc'="")
          {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_DayOfWeek",DOWRowId,DOWName,desc)
          }
          else
          {
            s AliasFlag= 1   
          }  
          if (AliasFlag=1) 
          {
             d OutputRowCmb
          }
       }
     }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb
    set Data=$lb(DOWRowId,DOWDay,DOWName)
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

/// Function： 根据ID删除资源预约-星期的数据
/// Creator：  Sunfengchao
/// CreatDate: 2015-5-29
/// Table：    CT_DayOfWeek
/// Input：    id
/// Return：   成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id As %String) As %String
{
 s result = ""
 s eobj = ##class(web.Entity.CT.CTDayOfWeek).%New()
 s obj=##class(User.CTDayOfWeek).%OpenId(id)
 s eobj.DOWRowId = id
 s eobj.DOWChecked=obj.DOWChecked
 s eobj.DOWDay=obj.DOWDay
 s eobj.DOWName=obj.DOWName
 s eobj.DOWSequence=obj.DOWSequence
 s eobj.DOWWeekend=obj.DOWWeekend
 s sc=##class(User.CTDayOfWeek).%DeleteId(id)
 if $$$ISOK(sc)
 {
  s result = "{success:'true',info:'删除成功！'}" 
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_DayOfWeek","User.CTDayOfWeek)","星期",id,eobj.DOWName,"D",eobj)
  d eobj.%Close()
 }
 else 
 {
  s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}" 
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("星期","web.DHCBL.CT.CTDayOfWeek","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
 }
 q result
}

/// Function：修改时打开数据
/// Creator：sunfengchao
/// CreatDate: 2015-5-28
/// Table： CT_DayOfWeek
/// debug: w ##class(web.DHCBL.CT.CTDayOfWeek).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.CT.CTDayOfWeek).%New()
 s obj=##class(User.CTDayOfWeek).%OpenId(id)
 s eobj.DOWRowId = id
 s eobj.DOWDay=obj.DOWDay
 s eobj.DOWName=obj.DOWName
 s eobj.DOWSequence=obj.DOWSequence
 s eobj.DOWChecked=obj.DOWChecked
 s eobj.DOWWeekend=obj.DOWWeekend
 s:eobj.DOWChecked="Y" eobj.DOWChecked="true"
 s:eobj.DOWChecked="N" eobj.DOWChecked="false"
 s:eobj.DOWWeekend="Y" eobj.DOWWeekend="true" 
 s:eobj.DOWWeekend="N" eobj.DOWWeekend="false"
 s str = eobj.JsonS() 
 d eobj.%Close()
 s str = "{list:["_str_"]}"
 q str
}

/// Function： 数据重复验证方法，由js调用
/// Creator：  sunfengchao
/// CreatDate: 2015-3-3
/// Table：   CT_DayOfWeek
/// Input：    id, code, desc
/// Return：   "1"(数据重复),"0"(数据不重复)
ClassMethod FormValidateForCode(id As %String, code As %String) As %String
{
 s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写 
 s flag=0 
 if (id="") //增加时的重复判断
 {
   s DOWRowId=0
   for 
   {
     s DOWRowId=$o(^CT("DOW",1,DOWRowId))
     q:DOWRowId=""
     s DOWDay=DOWRowId
     if (DOWDay=code) 
     { 
       s flag=1
     }
     else 
     {
        continue
     }
   }
 }
 else //修改时的重复判断
 { 
    s DOWRowId=0
    for 
    {
      s DOWRowId=$o(^CT("DOW",1,DOWRowId))
      q:DOWRowId=""
      s DOWDay=DOWRowId
      if (DOWDay=code)&(DOWRowId'=id)
      {
       s flag=1
      }
      else 
     {
        continue
     }
    }
 }
 q flag
}

/// Function： 数据重复验证方法，由js调用
/// Creator：  sunfengchao
/// CreatDate: 2015-3-3
/// Table：   CT_DayOfWeek
/// Input：    id, code, desc
/// Return：   "1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, desc As %String) As %String
{
 s:desc'="" desc=$ZCONVERT(desc,"U")  
 s flag=0 
 if (id="") //增加时的重复判断
 {
   s DOWRowId=0
   for 
   {
     s DOWRowId=$o(^CT("DOW",1,DOWRowId))
     q:DOWRowId=""
     s DOWName=$p($g(^CT("DOW",1,DOWRowId)),"^",1)
     if ($zcvt(DOWName,"U")=desc) 
     { 
       s flag=1
     }
     else 
     {
        continue
     }
   }
 }
 else //修改时的重复判断
 { 
    s DOWRowId=0
    for 
    {
      s DOWRowId=$o(^CT("DOW",1,DOWRowId))
      q:DOWRowId=""
      s DOWName=$p($g(^CT("DOW",1,DOWRowId)),"^",1)
      if ($zcvt(DOWName,"U")=desc)&(DOWRowId'=id)
      {
       s flag=1
      }
      else 
     {
        continue
     }
    }
 }
 q flag
}

/// Function:实现添加修改操作
/// Creator: sunfengchao
/// CreateDate:2015-5-29
/// Desc:通过rowid来资源修改添加数据
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
ClassMethod SaveEntity(eobj As web.Entity.CT.CTDayOfWeek) As %String
{
  s result=""
  if (eobj.DOWRowId="")       
  {
    s obj=##class(User.CTDayOfWeek).%New()
  }else                           
  {
    s obj=##class(User.CTDayOfWeek).%OpenId(eobj.DOWRowId)
    s bobj=##class(web.Entity.CT.CTDayOfWeek).%New()
    s bobj.DOWRowId= eobj.DOWRowId
    s bobj.DOWChecked = obj.DOWChecked                      
    s bobj.DOWDay= obj.DOWDay                      
    s bobj.DOWName=obj.DOWName  
    s bobj.DOWSequence=obj.DOWSequence 
    s bobj.DOWWeekend=obj.DOWWeekend
  }
   s obj.DOWDay = eobj.DOWDay                      
   s obj.DOWName= eobj.DOWName  
   s obj.DOWSequence=eobj.DOWSequence                   
   s:eobj.DOWChecked="" eobj.DOWChecked="N"
   s obj.DOWChecked=eobj.DOWChecked
   s:eobj.DOWWeekend="" eobj.DOWWeekend="N"
   s obj.DOWWeekend=eobj.DOWWeekend 
 
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
     Tcommit
     s id = obj.%Id()
     s result = "{success:'true',id:'"_id_"'}"          
     d:eobj.DOWRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_DayOfWeek","User.CTDayOfWeek","星期",eobj.DOWRowId,eobj.DOWName,"U",eobj,bobj)
     d:eobj.DOWRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_DayOfWeek","User.CTDayOfWeek","星期",id,eobj.DOWName,"A",eobj)
   }
   else
   {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"     
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("星期","web.DHCBL.CT.CTDayOfWeek","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }   
  q result
}

}
