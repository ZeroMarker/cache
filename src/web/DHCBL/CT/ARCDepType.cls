Class web.DHCBL.CT.ARCDepType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-8-2
/// Description：查询押金类型
/// Table： ARC_DepType
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCDepType", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ARCDTRowId:%String,ARCDTCode:%String,ARCDTDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 s AuStr=##class(web.DHCBL.Authorize.ARCDepType).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 if (rowid'="")  
 {
  s ARCDTRowId=rowid
  s ARCDTCode=$p($g(^ARC("ARCDT",ARCDTRowId)),"^",1)
  s ARCDTDesc=$p($g(^ARC("ARCDT",ARCDTRowId)),"^",2)
  s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" 
  s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_DepType",ARCDTRowId)
  s BDPInternalCode =$p($g(resultStr),"^",1)       
  s BDPInternalDesc = $p($g(resultStr),"^",2)  
  s BDPHospNationalCode=$p($g(resultStr),"^",3)         
  s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
  d OutputRow
 }
 else
 {
  s:code'="" code=$ZCVT(code,"U")  
  s:desc'="" desc=$ZCVT(desc,"U")  
  s ARCDTRowId=0
  for
  { 
    s ARCDTRowId=$o(^ARC("ARCDT",ARCDTRowId)) q:ARCDTRowId=""   
    s strARCDTRowId="{ID:"_ARCDTRowId_"}"
    if (AuStr[strARCDTRowId)||(AuFlag=1) 
    { 
      s ARCDTCode=$p($g(^ARC("ARCDT",ARCDTRowId)),"^",1)
      s ARCDTDesc=$p($g(^ARC("ARCDT",ARCDTRowId)),"^",2)
      s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_DepType",ARCDTRowId)
      s BDPInternalCode =$p($g(resultStr),"^",1)       
      s BDPInternalDesc = $p($g(resultStr),"^",2)  
      s BDPHospNationalCode=$p($g(resultStr),"^",3)         
      s BDPHospNationalDesc = $p($g(resultStr),"^",4) 
      if (desc'="")
      {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_DepType",ARCDTRowId,ARCDTDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }  
      if (($ZCVT(ARCDTCode,"U")[code))&(AliasFlag= 1) 
     {
       d OutputRow
     }
   }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ARCDTRowId,ARCDTCode,ARCDTDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索,为combo提供查押金类型的接口
/// CreateDate:2012-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:ARC_DepType
/// Input:  code，desc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCDepType", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ARCDTRowId:%String,ARCDTCode:%String,ARCDTDesc:%String")
{
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
  If ind="" {    // if there are no more rows, finish fetching
      Set AtEnd=1
      Set Row=""
  }
  Else      {    // fetch row
   Set Row=^CacheTemp(repid,ind)
  }
  s qHandle=$lb(AtEnd,repid,ind)
  Quit $$$OK
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1  
  s:code'="" code=$ZCVT(code,"U")  
  s:desc'="" desc=$ZCVT(desc,"U")
  s AuStr=##class(web.DHCBL.Authorize.ARCDepType).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
  if (rowid'="")  
  {
    s ARCDTRowId=rowid
    s ARCDTCode=$p($g(^ARC("ARCDT",ARCDTRowId)),"^",1)
    s ARCDTDesc=$p($g(^ARC("ARCDT",ARCDTRowId)),"^",2)
    d OutputRow2
 }
 else
 {
   s ARCDTRowId=0
   for
  { 
    s ARCDTRowId=$o(^ARC("ARCDT",ARCDTRowId)) q:ARCDTRowId=""   
    s strARCDTRowId="{ID:"_ARCDTRowId_"}"
    if (AuStr[strARCDTRowId)||(AuFlag=1) 
    { 
      s ARCDTCode=$p($g(^ARC("ARCDT",ARCDTRowId)),"^",1)
      s ARCDTDesc=$p($g(^ARC("ARCDT",ARCDTRowId)),"^",2)
      if (desc'="")
      {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_DepType",ARCDTRowId,ARCDTDesc,desc)
      }
      else
      {
         s AliasFlag= 1   
      }  
      if (($ZCVT(ARCDTCode,"U")[code))&(AliasFlag= 1) {
         d OutputRow2
      }
    }
  }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
  set Data=$lb(ARCDTRowId,ARCDTCode,ARCDTDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2012-12-7
/// Description：数据重复校验
/// Table：ARC_DepType
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
  s flag="",flagc="", flagd=""
  s:code'="" code=$$ALPHAUP^SSUTIL4(code) //此处用于转换成大写
  s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) //此处用于转换成大写
  s:code'="" flagc=$d(^ARC("ARCDT",0,"Code",code))
  s:desc'="" flagd=$d(^ARC("ARCDT",0,"Desc",desc))
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
  s:code'="" idc=$o(^ARC("ARCDT",0,"Code",code,0))
  s:desc'="" idd=$o(^ARC("ARCDT",0,"Desc",desc,0))
  if (desc="")
  {
   if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
  else
  {
   if (code="")
   {
    if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
   }
   else
   {
    ;if ((idc'=id)||(idd'=id))&((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
    if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
   }
  }
 }
 q flag
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2012-8-3
/// Description：双击时打开押金类型
/// Table：ARC_DepType
/// Others:d ##class(web.DHCBL.CT.ARCDepType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str = ""
    s prbj = ##class(User.ARCDepType).%OpenId(id)
    s eobj = ##class(web.Entity.CT.ARCDepType).%New()
    s eobj.ARCDTRowId = id
    s eobj.ARCDTCode  = prbj.ARCDTCode
    s eobj.ARCDTDesc = prbj.ARCDTDesc
    kill prbj
    s str = eobj.JsonS()
    s str = "{list:["_str_"]}"
    q str
}

/// Creator：基础数据平台组
/// CreatDate: 2012-8-3
/// Description：保存修改押金类型内容
/// Table： ARC_DepType
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCDepType) As %String
{
  s $zt="EEROE"
  s result="" 
  if ((eobj.ARCDTRowId)="")                             
  { 
    s obj=##class(User.ARCDepType).%New()
  }
  else                                                  
  {
   s obj=##class(User.ARCDepType).%OpenId(eobj.ARCDTRowId) 
   s bobj=##class(web.Entity.CT.ARCDepType).%New()
   s bobj.ARCDTRowId=eobj.ARCDTRowId
   s bobj.ARCDTCode = obj.ARCDTCode                     
   s bobj.ARCDTDesc = obj.ARCDTDesc   
  } 
  s obj.ARCDTCode = eobj.ARCDTCode                     
  s obj.ARCDTDesc = eobj.ARCDTDesc                      
  
  TSTART
  s sc=obj.%Save() 
  If $$$ISOK(sc){
   TCOMMIT
   s id = obj.%Id()
   s result = "{success:'true',id:'"_id_"'}"    //返回RowId
   d:eobj.ARCDTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_DepType","User.ARCDepType","押金类型",id,eobj.ARCDTDesc,"A",eobj)
   d:eobj.ARCDTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_DepType","User.ARCDepType","押金类型",eobj.ARCDTRowId,eobj.ARCDTDesc,"U",eobj,bobj)
  }
  else
  {
   Trollback
   s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("押金类型","web.DHCBL.CT.ARCDepType","SaveEntity",eobj)
   s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
  }   
 d obj.%Close()
 q result
EEROE
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("押金类型","web.DHCBL.CT.ARCDepType","SaveEntity",eobj,browerinfo)
  s ^ERRORLOGINFO(logid)=$ze
  q "{success:'false',errorinfo:'"_$ze_"'}"
}

/// Function:用于数据删除时的逻辑判断
/// CreateDate:2015-5-13
/// Ctreator:Sunfengchao
/// Input:rowid  ^RB("RES",0,"EQ",{RES_EQ_DR},{RES_CTLOC_DR},{RES_RowId})
/// Output:返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
/// debug: w ##class(web.DHCBL.CT.ARCDepType).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
  s return="",myInfo=""
  s found1=0
  s rowid=0
  for
  {
   s rowid=$O(^DHCJFSSGRPDEPTYPECONFIG(rowid))
   q:rowid=""
   s GrpDepTypeDr=""
   s GrpDepTypeDr=$p($g(^DHCJFSSGRPDEPTYPECONFIG(rowid)),"^",2)
   if (GrpDepTypeDr=id)
   {
    s found1=1
   }
  }   
  if (found1=1)  s myInfo=myInfo_"<安全组与押金类型配置>"
  
   //2 对已被其他业务引用过的押金类型（在dhc_sfprintdetail  住院押金表  ），不允许删除 
  if $d(^DHCSFPRINTDETAIL(0,"DepType",id)) s myInfo=myInfo_"<住院押金表>"
  
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

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2012-8-3
/// Description：删除押金类型内容
/// Table： ARC_DepType
ClassMethod DeleteData(id) As %String
{
  s result="",flag="",RefFlag=""
  s re=..GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag=1)
  {
    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
  }
  else
  {
    Tstart
    s obj=##class(User.ARCDepType).%OpenId(id)
    s eobj = ##class(web.Entity.CT.ARCDepType).%New()
    s eobj.ARCDTRowId = id
    s eobj.ARCDTCode  = obj.ARCDTCode
    s eobj.ARCDTDesc = obj.ARCDTDesc

    s sc=##class(User.ARCDepType).%DeleteId(id)
    IF $$$ISOK(sc)
    {
       Tc
       s result="{success:'true',info:'删除成功！'}"
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_DepType","User.ARCDepType","押金类型",id,eobj.ARCDTDesc,"D",eobj)
    }
    else
    {
       Trollback
       s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("押金类型","web.DHCBL.CT.ARCDepType","DeleteData",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   }
  }
 q result
}

}
