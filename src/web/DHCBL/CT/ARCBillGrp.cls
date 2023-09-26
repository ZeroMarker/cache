/// CreateDate:2012-08-13
/// Creator:基础数据平台 ，孙凤超
/// Function:帐单组维护
/// Tables:ARC_BillGrp   
Class web.DHCBL.CT.ARCBillGrp Extends %RegisteredObject [ ProcedureBlock ]
{

Parameter SQLTableName = "ARC_BillGrp";

/// Function:进行数据检索，查询账单组的信息
/// CreateDate:2012-08-13
/// Creator:基础数据平台组 孙凤超
/// Tables:  ARC_BillGrp
/// Input: rowid, code, desc, query
/// Output:ARCBG_RowId，ARCBG_Code，ARCBG_Desc，ARCBG_Abbrev
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCBillGrp", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "ARCBGRowId:%String,ARCBGCode:%String,ARCBGDesc:%String,ARCBGAbbrev:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
{
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   
   s AuStr=##class(web.DHCBL.Authorize.ARCBillGrp).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
   if (rowid'="")  
   {
     s ARCBGRowId=rowid
     s ARCBGCode=$p($g(^ARCBG(ARCBGRowId)),"^",1)
     s ARCBGDesc=$p($g(^ARCBG(ARCBGRowId)),"^",2) 
     s ARCBGAbbrev=$p($g(^ARCBG(ARCBGRowId)),"^",3)
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_BillGrp",ARCBGRowId)
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
     s ARCBGRowId=0
     for
     {
       s ARCBGRowId=$o(^ARCBG(ARCBGRowId))  
       q:(ARCBGRowId="")||(ARCBGRowId="SG_Abbr")||(ARCBGRowId="SG_Code")||(ARCBGRowId="SG_Desc") 
       s strARCBGRowId="{ID:"_ARCBGRowId_"}"
       if (AuStr[strARCBGRowId)||(AuFlag=1) 
       { 
       	 s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCBGRowId,hospid)
	     continue:showflag="N"	
         s ARCBGCode=$p($g(^ARCBG(ARCBGRowId)),"^",1)
         s ARCBGDesc=$p($g(^ARCBG(ARCBGRowId)),"^",2)  
         s ARCBGAbbrev=$p($g(^ARCBG(ARCBGRowId)),"^",3)
         s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc="" ,BDPInternalValue="" 
         s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("ARC_BillGrp",ARCBGRowId)
         s BDPInternalCode =$p($g(resultStr),"^",1)       
         s BDPInternalDesc = $p($g(resultStr),"^",2)  
         s BDPHospNationalCode=$p($g(resultStr),"^",3)         
         s BDPHospNationalDesc = $p($g(resultStr),"^",4)
         if (desc'="")
         {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_BillGrp",ARCBGRowId,ARCBGDesc,desc)
         }
         else
         {
          s AliasFlag= 1   
         }  
         if (($ZCVT(ARCBGCode,"U")[code))&(AliasFlag= 1)   
         {
           d OutputRow
         }    
      }
   }  
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ARCBGRowId,ARCBGCode,ARCBGDesc,ARCBGAbbrev,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索，为comb提供查询账单组信息的接口
/// CreateDate:2013-5-14
/// Creator:基础数据平台组 孙凤超
/// Table： ARC_BillGrp
/// Input:  code, desc 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.ARCBillGrp","GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "ARCBGRowId:%String,ARCBGCode:%String,ARCBGDesc:%String")
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

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, hospid As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  s:code'="" code=$ZCVT(code,"U")  
  s:desc'="" desc=$ZCVT(desc,"U") 
  s AuStr= ##class(web.DHCBL.Authorize.ARCBillGrp).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
    s ARCBGRowId=rowid
    s ARCBGCode=$p($g(^ARCBG(ARCBGRowId)),"^",1)
    s ARCBGDesc=$p($g(^ARCBG(ARCBGRowId)),"^",2)
    d OutputRowCmb
   }
 else
 {
   s ARCBGRowId=0
   for
   {
      s ARCBGRowId=$o(^ARCBG(ARCBGRowId))  q:(ARCBGRowId="")||(ARCBGRowId="SG_Abbr")  
      s strARCBGRowId="{ID:"_ARCBGRowId_"}"
      if (AuStr[strARCBGRowId)||(AuFlag=1) 
      { 
       s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,ARCBGRowId,hospid)
	   continue:showflag="N"
       s ARCBGCode=$p($g(^ARCBG(ARCBGRowId)),"^",1)
       s ARCBGDesc=$p($g(^ARCBG(ARCBGRowId)),"^",2)
       if (desc'="")
       {
          ;需要对描述或者别名进行检索      
          s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("ARC_BillGrp",ARCBGRowId,ARCBGDesc,desc)
       }
       else
       {
          s AliasFlag= 1   
       }  
       if ((ARCBGCode[code)||($ZCVT(ARCBGCode,"U")[code))&(AliasFlag=1) 
       {
          d OutputRowCmb
       }
     }
   }  
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
   
  set Data=$lb(ARCBGRowId,ARCBGCode,ARCBGDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:显示账单组信息的打开窗口
/// CreateDate:2012-08-13
/// Creator:基础数据平台组 孙凤超
/// Input:输入id
/// Tables: ARC_BillGrp
/// Other:w ##class(web.DHCBL.CT.ARCBillGrp).OpenData("47")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.ARCBillGrp).%OpenId(id)
 s eobj = ##class(web.Entity.CT.ARCBillGrp).%New()
 s eobj.ARCBGRowId=id
 s eobj.ARCBGCode = pobj.ARCBGCode
 s eobj.ARCBGDesc= pobj.ARCBGDesc
 s eobj.ARCBGAbbrev = pobj.ARCBGAbbrev
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Creator：孙凤超
/// CreatDate: 2012-12-7
/// Description：数据重复校验
/// Table： ARC_BillGrp
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// w ##class(web.DHCBL.CT.ARCBillGrp).FormValidate("98","23","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String = "") As %String
{
	s flag=0
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s idc=0
		for
		{
			s idc=$o(^ARCBG(0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
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
	
			s idd=$o(^ARCBG(0,"DESC",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""
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

/// Function:用于数据删除时的逻辑判断
/// CreateDate:2013-6-28
/// Ctreator:BDP-Sunfengchao
/// Input:rowid 
/// Output:返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
ClassMethod GetRefFlag(id As %String) As %String
{
    s return="", myInfo=""
    s SESSRowId=0,found1=0
    s ind=$o(^ARCIM(0,"ARCSG_DR",+id_"||0"))
    if (ind[(+id_"||"))  s found1=1
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

/// Function:实现对账单组信息的删除操作
/// Creator:孙凤超
/// CreateDate:2012-08-13
/// Desc:通过输入id号来删除付款人的信息 
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables: ARC_BillGrp 
/// Others:d ##class(web.DHCBL.CT.ARCBillGrp).DeleteData("70")
ClassMethod DeleteData(id) As %String
{
  s result="",flag="",browerinfo=""
  s eobj = ##class(web.Entity.CT.ARCBillGrp).%New()
  s obj = ##class(User.ARCBillGrp).%OpenId(id)
  s eobj.ARCBGRowId=id
  s eobj.ARCBGCode = obj.ARCBGCode
  s eobj.ARCBGDesc= obj.ARCBGDesc
  s eobj.ARCBGAbbrev = obj.ARCBGAbbrev
  s re=##class(web.DHCBL.CT.ARCBillGrp).GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag=1)
  {
    s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("账单组","web.DHCBL.CT.ARCBillGrp","DeleteData",eobj)
    s ^ERRORLOGINFO(logid)=  "删除失败:<医嘱项>表里被引用,不能删除!"
  }
  else
  {
    TStart
    s sc= ##class(User.ARCBillGrp).%DeleteId(id)
    if $$$ISOK(sc)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_BillGrp","User.ARCBillGrp","账单组",id,eobj.ARCBGDesc,"D",eobj)
      d eobj.%Close()
    }
   else
   {
      Trollback
      s result= "{success:'false',info:'删除失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("账单组","web.DHCBL.CT.ARCBillGrp","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   } 
 }
 q result
}

/// CreateDate:2012-08-13
/// Creator:基础数据平台组 孙凤超
/// Function:对账单组数据进行修改
/// Table: ARC_BillGrp
/// Input：web.Entity.CT.ARCBillGrp
/// Return：成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other: d ##class(web.DHCBL.CT.ARCBillGrp).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.CT.ARCBillGrp) As %String
{
 s $zt="ERROE"
 s result="" 
 if (eobj.ARCBGRowId="")   
 {
    s obj = ##class(User.ARCBillGrp).%New()
 }
 else                    
 {
    s obj=##class(User.ARCBillGrp).%OpenId(eobj.ARCBGRowId)
    s bobj=##class(web.Entity.CT.ARCBillGrp).%New()
    s bobj.ARCBGRowId=eobj.ARCBGRowId
    s bobj.ARCBGCode = obj.ARCBGCode          
    s bobj.ARCBGDesc = obj.ARCBGDesc           
    s bobj.ARCBGAbbrev = obj.ARCBGAbbrev  
 }                    
 s obj.ARCBGCode = eobj.ARCBGCode          
 s obj.ARCBGDesc = eobj.ARCBGDesc           
 s obj.ARCBGAbbrev = eobj.ARCBGAbbrev   
 Tstart
 s sc = obj.%Save()
 d obj.%Close()
 If $$$ISOK(sc)
 {
   Tcommit
   s id = obj.%Id()
   s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
   d:eobj.ARCBGRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_BillGrp","User.ARCBillGrp","账单组",id,eobj.ARCBGDesc,"A",eobj)
   d:eobj.ARCBGRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("ARC_BillGrp","User.ARCBillGrp","账单组",eobj.ARCBGRowId,eobj.ARCBGDesc,"U",eobj,bobj)
 }
 else
 {
    Trollback  
    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
    s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("账单组","web.DHCBL.CT.ARCBillGrp","SaveEntity",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
ERROE
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("账单组","web.DHCBL.CT.ARCBillGrp","SaveEntity",eobj)
  s ^ERRORLOGINFO(logid)=$ze
  q "{success:'false',errorinfo:'"_$ze_"'}"
}

}
