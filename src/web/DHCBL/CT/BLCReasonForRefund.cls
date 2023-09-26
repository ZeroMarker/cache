/// 名称: 退款原因维护功能 
/// 描述: 退款原因维护，包含增删改查功能
/// 编写者：基础平台组 孙凤超
/// 编写日期: 2013-5-13
Class web.DHCBL.CT.BLCReasonForRefund Extends %RegisteredObject
{

Parameter SQLTableName = "BLC_ReasonForRefund";

/// Creator：孙凤超
/// CreatDate:2013-5-12
/// Description：查询退款原因
/// Table： BLC_ReasonForRefund
/// Input：rowid, code, desc
/// Output：RFRRowId, RFRCode, RFRDesc
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BLCReasonForRefund", "GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "RFRRowId:%String,RFRCode:%String,RFRDesc:%String,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc")
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
   s AuStr=##class(web.DHCBL.Authorize.BLCReasonForRefund).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1
   if (rowid'="")  
   {
     s RFRRowId=rowid
     s RFRCode=$p($g(^BLC("RFR",RFRRowId)),"^",1)
     s RFRDesc=$p($g(^BLC("RFR",RFRRowId)),"^",2)
     s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPHospNationalDesc=""  
     s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("BLC_ReasonForRefund",RFRRowId)
     s BDPInternalCode =$p($g(resultStr),"^",1)       
     s BDPInternalDesc = $p($g(resultStr),"^",2)  
     S BDPHospNationalCode=$p($g(resultStr),"^",3)         
     s BDPHospNationalDesc = $p($g(resultStr),"^",4)
     d OutputRow
   }
    else
    {
      s:code'="" code=$zcvt(code,"U")  
      s:desc'="" desc=$zcvt(desc,"U") 
      s RFRRowId=0
      for
      {
         s RFRRowId=$o(^BLC("RFR",RFRRowId)) q:RFRRowId=""   
         s strRFRRowId="{ID:"_RFRRowId_"}"
         if (AuStr[strRFRRowId)||(AuFlag=1) 
         { 
         	s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,RFRRowId,hospid)
			continue:showflag="N" 
           s RFRCode=$p($g(^BLC("RFR",RFRRowId)),"^",1)
           s RFRDesc=$p($g(^BLC("RFR",RFRRowId)),"^",2) 
           s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("BLC_ReasonForRefund",RFRRowId)
           s BDPInternalCode =$p($g(resultStr),"^",1)       
           s BDPInternalDesc = $p($g(resultStr),"^",2)  
           S BDPHospNationalCode=$p($g(resultStr),"^",3)         
           s BDPHospNationalDesc = $p($g(resultStr),"^",4)
           if (desc'="")
           {
                ;需要对描述或者别名进行检索      
                s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("BLC_ReasonForRefund",RFRRowId,RFRDesc,desc)
           }
           else
           {
                s AliasFlag= 1   
           }   
           if (($zcvt(RFRCode,"U")[code))&(AliasFlag=1) 
           {
             d OutputRow
           }
        }
    }
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(RFRRowId,RFRCode,RFRDesc,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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

/// Function:进行数据检索,为combo提供退款原因查询的接口
/// CreateDate:2013-5-13
/// Creator:基础数据平台公共产品组 孙凤超
/// Table:  User.BLCReasonForRefund 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BLCReasonForRefund", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, hospid As %String) As %Query(ROWSPEC = "RFRRowId:%String,RFRCode:%String,RFRDesc:%String")
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
  s:code'="" code=$zcvt(code,"U")  
  s:desc'="" desc=$zcvt(desc,"U")  
  s AuStr=##class(web.DHCBL.Authorize.BLCReasonForRefund).DHCGetDataByDefaultSession()
  s AuFlag=0
  ;未授权情况下，默认显示全部数据
  if (AuStr="")||(AuStr["limited:0") s AuFlag=1
  if (rowid'="")  
  {
    s RFRRowId=rowid
    s RFRCode=$p($g(^BLC("RFR",RFRRowId)),"^",1)
    s RFRDesc=$p($g(^BLC("RFR",RFRRowId)),"^",2)
    d OutputRow2
  }
 else
 {
   s RFRRowId=0
   for
   {
     s RFRRowId=$o(^BLC("RFR",RFRRowId)) q:RFRRowId=""   
     s strRFRRowId="{ID:"_RFRRowId_"}"
     if (AuStr[strRFRRowId)||(AuFlag=1) 
     { 
       s showflag =##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag(..#SQLTableName,RFRRowId,hospid)
	   continue:showflag="N" 
       s RFRCode=$p($g(^BLC("RFR",RFRRowId)),"^",1)
       s RFRDesc=$p($g(^BLC("RFR",RFRRowId)),"^",2)
       if (desc'="")
       {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("BLC_ReasonForRefund",RFRRowId,RFRDesc,desc)
       }
       else
       {
           s AliasFlag= 1   
       }   
       if (($zcvt(RFRCode,"U")[code))&(AliasFlag=1)  
       {
         d OutputRow2
       }
      }
    }
   }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
 set Data=$lb(RFRRowId,RFRCode,RFRDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:增加和修改数据
/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-5-13
/// Description：新增退款原因的内容
/// Table：User.BLCReasonForRefund
/// Input：web.Entity.CT.BLCReasonForRefund 实体类 
/// Return：成功返回success:'true'和新增数据的RFRRowId；失败返回success:'false'和错误信息
ClassMethod SaveEntity(eobj As web.Entity.CT.BLCReasonForRefund) As %String
{
   
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 {
  if (eobj.RFRRowId="")       
  {
   //RowId未赋值,增加
   s obj=##class(User.BLCReasonForRefund).%New()
  }else                           
  {
   //RowId已存在,修改
   s obj=##class(User.BLCReasonForRefund).%OpenId(eobj.RFRRowId)
   s bobj=##class(web.Entity.CT.BLCReasonForRefund).%New()
   s bobj.RFRRowId=eobj.RFRRowId
   s bobj.RFRCode = obj.RFRCode                  
   s bobj.RFRDesc= obj.RFRDesc 
  }
   s obj.RFRCode = eobj.RFRCode                      //修改代码
   s obj.RFRDesc= eobj.RFRDesc                      //修改描述
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc){
    Tcommit
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //保存数据后,通过RowId返回到这条数据
    d:eobj.RFRRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BLC_ReasonForRefund","User.BLCReasonForRefund","退款原因",eobj.RFRRowId,eobj.RFRDesc,"U",eobj,bobj)
    d:eobj.RFRRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BLC_ReasonForRefund","User.BLCReasonForRefund","退款原因",id,eobj.RFRDesc,"A",eobj)
   }
   else
   {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("退款原因","web.DHCBL.CT.BLCReasonForRefund","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   } 
 }
 else
 {
     s result = "{success:'false',errorinfo:'对象不存在！'}"
     s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("退款原因","web.DHCBL.CT.BLCReasonForRefund","DeleteData","")
     s ^ERRORLOGINFO(logid)="对象不存在！"
 } 
  q result
ERROR
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("退款原因","web.DHCBL.CT.BLCReasonForRefund","DeleteD",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

/// Function:用于数据删除时的逻辑判断  （在Dhc_PhaRetRequest、DHC_phrequest 表中），不允许删除 
/// CreateDate:2015-5-13
/// Ctreator:Sunfengchao
/// Input:  ^ARRCP({AR_Receipts.ARRCP_RowId},"PAYM",{PAYM_Childsub})
/// Output:返回一个标志位，0为未被引用，表示可以被删除，1表示已经被引用了，不能被删除
/// debug: w ##class(web.DHCBL.CT.ARCInsuranceType).GetRefFlag("")
ClassMethod GetRefFlag(id As %String) As %String
{
  s return="",myInfo=""
  s found1=0
  s ARRCPRowId=0
  for
  {
    s ARRCPRowId=$O(^ARRCP(ARRCPRowId)) q:ARRCPRowId=""
    s PAYMChildsub=0
    for
    {
        s PAYMChildsub =$O(^ARRCP(ARRCPRowId,"PAYM",PAYMChildsub)) q:PAYMChildsub=""
        s PAYMCMBankDR=""
        s PAYMCMBankDR=$p($g(^ARRCP(ARRCPRowId,"PAYM",PAYMChildsub)),"^",2)
        if (PAYMCMBankDR=id)
        {
          s found1=1
          q
        }
    }   
  }
  if (found1=1)  s myInfo=myInfo_"<AR_RcptPayMode>"  
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

/// Function:删除数据
/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-5-13
/// Description：根据id删除退款原因的内容
/// Table：User.BLCReasonForRefund
/// Input：id(BLCReasonForRefund的rowid)
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(id) As %String
{
    s result="",flag=""
    Tstart
    s pobj = ##class(User.BLCReasonForRefund).%OpenId(id)
    s eobj = ##class(web.Entity.CT.BLCReasonForRefund).%New()
    s eobj.RFRRowId=id
    s eobj.RFRCode= pobj.RFRCode
    s eobj.RFRDesc = pobj.RFRDesc
    
    s sc= ##class(User.BLCReasonForRefund).%DeleteId(id)
    IF $$$ISOK(sc)
    {
      Tc
      s result="{success:'true',info:'删除成功！'}"
      d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BLC_ReasonForRefund","User.BLCReasonForRefund","退款原因",id,eobj.RFRDesc,"D",eobj)
      d eobj.%Close()
    }
    else
    {
      Trollback
      s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("退款原因","web.DHCBL.CT.BLCReasonForRefund","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
    q result
}

/// Creator：基础数据平台组 孙凤超
/// CreatDate: 2013-5-13
/// Description：数据重复校验
/// Table：User.BLCReasonForRefund
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String, desc As %String, hospid As %String) As %String
{
	s flag=0
	if $$ALPHAUP^SSUTIL4(code)'=""
	{
		s idc=0
		for
		{
			s idc=$o(^BLC("RFR",0,"Code",$$ALPHAUP^SSUTIL4(code),idc)) q:idc=""
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
			s idd=$o(^BLC("RFR",0,"Desc",$$ALPHAUP^SSUTIL4(desc),idd)) q:idd=""	
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

/// Function:双击时显示数据信息
/// CreateDate:2013-05-13
/// Creator:基础数据平台公共产品组 孙凤超
/// Input:id
/// Table:User.BLCReasonForRefund  
/// Others:w ##class(web.DHCBL.CT.BLCReasonForRefund).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.BLCReasonForRefund).%OpenId(id)
 s eobj = ##class(web.Entity.CT.BLCReasonForRefund).%New()
 s eobj.RFRRowId=id
 s eobj.RFRCode= pobj.RFRCode
 s eobj.RFRDesc = pobj.RFRDesc
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}" 
 q str
}

}
