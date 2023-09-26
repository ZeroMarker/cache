Import SQLUSER

/// CreateDate:2014-12-11
/// Creator:基础数据平台孙凤超
/// Function: 费用标准
/// Tables:  ARC_DerivedFeeRules
Class web.DHCBL.CT.ARCDerivedFeeRules Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "ARC_DerivedFeeRules";

/// Function:进行数据检索，查询费用标准
/// CreateDate:2014-12-11
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  ARC_DerivedFeeRules
/// Output: DFRRowId DFRCode  DFRDesc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCDerivedFeeRules", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DFRRowId:%String,DFRCode:%String,DFRDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
 s AuStr= ##class(web.DHCBL.Authorize.ARCDerivedFeeRules).DHCGetDataByDefaultSession()
 s AuFlag=0
 ;未授权情况下，默认显示全部数据
 if (AuStr="")||(AuStr["limited:0") s AuFlag=1
 
 if (rowid'="")  
 {
   s DFRRowId=rowid
   s DFRCode=$p($g(^ARC("DFR",rowid)),"^",1)
   s DFRDesc=$p($g(^ARC("DFR",rowid)),"^",2)
   s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
   s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_DerivedFeeRules",DFRRowId)
   s BDPInternalCode =$p($g(resultStr),"^",1)       
   s BDPInternalDesc = $p($g(resultStr),"^",2)  
   s BDPHospNationalCode=$p($g(resultStr),"^",3)         
   s BDPHospNationalDesc = $p($g(resultStr),"^",4)  
   d OutputRow
 }
 else
 {
   s:code'="" code=$zcvt(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U") 
   s DFRRowId=0
   for
   {
       s DFRRowId=$o(^ARC("DFR",DFRRowId)) q:DFRRowId="" 
       s strDFRRowId="{ID:"_DFRRowId_"}"
       if (AuStr[strDFRRowId)||(AuFlag=1) 
       {
	       	s DFRCode=$p($g(^ARC("DFR",DFRRowId)),"^",1)
            s DFRDesc=$p($g(^ARC("DFR",DFRRowId)),"^",2) 
            s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
            s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_DerivedFeeRules",DFRRowId)
            s BDPInternalCode =$p($g(resultStr),"^",1)       
            s BDPInternalDesc = $p($g(resultStr),"^",2)  
            s BDPHospNationalCode=$p($g(resultStr),"^",3)         
            s BDPHospNationalDesc = $p($g(resultStr),"^",4)
            if (desc'="")
            {
                ;需要对描述或者别名进行检索      
                s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_DerivedFeeRules",DFRRowId,DFRDesc,desc)
            }
            else
            {
                s AliasFlag= 1   
            }   
            if ($$ALPHAUP^SSUTIL4(DFRCode)[code)&(AliasFlag= 1) 
            {
              d OutputRow
            }
     }
  }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(DFRRowId,DFRCode,DFRDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索,为combo提供查询费用标准的接口
/// CreateDate:2014-12-11
/// Creator:基础数据平台公共产品组 孙凤超
/// Tables:  ARC_DerivedFeeRules
/// Input: rowid，code，desc
/// Output: DFRRowId ，DFRCode,DFRDesc,  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCDerivedFeeRules", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "DFRRowId:%String,DFRCode:%String,DFRDesc:%String")
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
  s:code'="" code=$zcvt(code,"U")  
  s:desc'="" desc=$ZCVT(desc,"U") 
  s AuStr=##class(web.DHCBL.Authorize.ARCDerivedFeeRules).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
   s DFRRowId=rowid
   s DFRCode=$p($g(^ARC("DFR",rowid)),"^",1)
   s DFRDesc=$p($g(^ARC("DFR",rowid)),"^",2)
   d OutputRow2
  }
  else
  {
   s:code'="" code=$zcvt(code,"U")  
   s:desc'="" desc=$ZCVT(desc,"U") 
   s DFRRowId=0
   for
   {
       s DFRRowId=$o(^ARC("DFR",DFRRowId)) q:DFRRowId="" 
       s strDFRRowId="{ID:"_DFRRowId_"}"
       if (AuStr[strDFRRowId)||(AuFlag=1) 
       {
	    s DFRCode=$p($g(^ARC("DFR",DFRRowId)),"^",1)
        s DFRDesc=$p($g(^ARC("DFR",DFRRowId)),"^",2)
        if (desc'="")
        {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_DerivedFeeRules",DFRRowId,DFRDesc,desc)
        }
        else
        {
            s AliasFlag= 1   
        }   
        if ($$ALPHAUP^SSUTIL4(DFRCode)[code)&(AliasFlag= 1)  
        {
           d OutputRow2
        }
     }
  }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
 set Data=$lb(DFRRowId,DFRCode,DFRDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:双击时显示费用标准数据
/// CreateDate:2014-12-10
/// Creator:基础数据平台公共产品组 孙凤超
/// Input: id
/// Tables: ARC_DerivedFeeRules
/// Others:w ##class(web.DHCBL.CT.ARCDerivedFeeRules).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.ARCDerivedFeeRules).%OpenId(id)
 s eobj = ##class(web.Entity.CT.ARCDerivedFeeRules).%New()
 s eobj.DFRRowId=id
 s eobj.DFRCode= pobj.DFRCode
 s eobj.DFRDesc = pobj.DFRDesc
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function:  用于数据删除时的逻辑判断
/// CreateDate:2015-3-31
/// Ctreator:  BDP-Sunfengchao
/// Input:     rowid   
/// Output:    返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
/// Debug      w ##class(web.DHCBL.CT.CTHealthCareRegion).GetRefFlag("3")
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    s found1=0
    s ARCIMSubscript=0
    for {
     s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript))
     q:ARCIMSubscript=""
     q:found1  
     s ARCIMVersion=0
     for 
     {
        s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))
        q:ARCIMVersion=""
        q:found1  
        s ARCIMDerFeeRulesDR=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,8)),"^",19)
        if ARCIMDerFeeRulesDR=id s found1=1
     }
    }
   if (found1=1)  s myInfo=myInfo_"<医嘱项>"
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

/// Function:实现对费用标准的删除操作
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2013-07-04
/// Desc:通过rowid号来删除费用标准
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:  ARC_DerivedFeeRules
/// Others:d ##class(web.DHCBL.CT.ARCDerivedFeeRules).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    s re=..GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    s pobj = ##class(User.ARCDerivedFeeRules).%OpenId(id)
    s eobj = ##class(web.Entity.CT.ARCDerivedFeeRules).%New()
    s eobj.DFRRowId=id
    s eobj.DFRCode= pobj.DFRCode
    s eobj.DFRDesc = pobj.DFRDesc
    if (RefFlag=1)
    {
      s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("费用标准","web.DHCBL.CT.ARCDerivedFeeRules","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)="删除失败:<医嘱项>表里被引用,不能删除!"
    }
    else
    {
     Tstart
     s sc=##class(User.ARCDerivedFeeRules).%DeleteId(id)
     if $$$ISOK(sc)
     {
       Tc
       s result="{success:'true',info:'删除成功！'}"
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_DerivedFeeRules","User.ARCDerivedFeeRules","费用标准",id,eobj.DFRDesc,"D",eobj)
       d eobj.%Close()
    }
     else
     {
       Trollback
       s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("费用标准","web.DHCBL.CT.ARCDerivedFeeRules","DeleteData",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
     }
   }
    q result
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2014-12-10
/// Description：数据重复校验
/// Table： ARC_DerivedFeeRules
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
	s flag=0
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s idc=0
		for
		{
			s idc=$o(^ARC("DFR",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
			if (idc'=id)
			{
				s flag=1
			}
		}
	}
	
	if $$ALPHAUP^SSUTIL4(desc)'=""
	{
		s idd=0
		for
		{
	
			s idd=$o(^ARC("DFR",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
			if (idd'=id)
			{
				s flag=1
			}
		}
	}
	q flag
}

/// Function:实现对费用标准的修改增加操作
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2014-12-10
/// Desc:通过rowid来修改或者添加费用标准
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: ARC_DerivedFeeRules
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCDerivedFeeRules) As %String
{
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  
  if (eobj.DFRRowId="")       
  {
   s obj=##class(User.ARCDerivedFeeRules).%New()
  }else                           
  {
   s obj=##class(User.ARCDerivedFeeRules).%OpenId(eobj.DFRRowId)
   s bboj=##class(web.Entity.CT.ARCDerivedFeeRules).%New()
   s bboj.DFRRowId=eobj.DFRRowId
   s bboj.DFRCode = obj.DFRCode                    
   s bboj.DFRDesc= obj.DFRDesc                      
  }
   s obj.DFRCode = eobj.DFRCode                    
   s obj.DFRDesc= eobj.DFRDesc                      
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
      Tcommit
      s id = obj.%Id()
      s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
      d:eobj.DFRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_DerivedFeeRules","User.ARCDerivedFeeRules","费用标准",eobj.DFRRowId,eobj.DFRDesc,"U",eobj,bboj)
      d:eobj.DFRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_DerivedFeeRules","User.ARCDerivedFeeRules","费用标准",id,eobj.DFRDesc,"A",eobj)
   }
   else
   {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("费用标准","web.DHCBL.CT.ARCDerivedFeeRules","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   } 
 }
 else
 {
   s result = "{success:'false',errorinfo:'对象不存在！'}"
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("费用标准","web.DHCBL.CT.ARCDerivedFeeRules","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"
 } 
 q result
ERROR
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("费用标准","web.DHCBL.CT.ARCDerivedFeeRules","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

}
