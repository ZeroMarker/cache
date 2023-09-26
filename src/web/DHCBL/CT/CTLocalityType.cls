/// Function:  地理信息-街道/乡镇
/// Creator:   sunfengchao
/// CreatDate: 2015-11-25
/// Table：    CT_LocalityType
Class web.DHCBL.CT.CTLocalityType Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:  地理信息-街道/乡镇维护 查询grid数据列表 
/// Creator:   sunfengchao
/// CreatDate: 2017-08-01
/// Table：    CT_LocalityType
/// Input：    rowid,code,desc ,type 
/// Debug：    d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocalityType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "LOCTYPERowId:%String,LOCTYPECode:%String,LOCTYPEDesc:%String,LOCTYPENationalCode:%String,LOCTYPEType:%String,LOCTYPEActiveFlag:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
   s repid=$I(^CacheTemp)
   s ind=1
   
   s AuStr= ##class(web.DHCBL.Authorize.CTLocalityType).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
   if (rowid'="")  
   { 
     s LOCTYPERowId=rowid
     s LOCTYPEType=$p($g(^CT("LOCTYPE",rowid)),"^",4) 
     s:LOCTYPEType="S" LOCTYPEType="Street"
     if (LOCTYPEType="Street")
     {
      s LOCTYPECode=$p($g(^CT("LOCTYPE",rowid)),"^",1)
      s LOCTYPEDesc=$p($g(^CT("LOCTYPE",rowid)),"^",2)
      s LOCTYPENationalCode=$p($g(^CT("LOCTYPE",rowid)),"^",3)
      s:LOCTYPENationalCode'="" LOCTYPENationalCode=$o(^CT("CITAREA",0,"Code",$zcvt(LOCTYPENationalCode,"U"),0))
      s:LOCTYPENationalCode'="" LOCTYPENationalCode=$p($g(^CT("CITAREA",LOCTYPENationalCode)),"^",2) 
      s LOCTYPEActiveFlag=$p($g(^CT("LOCTYPE",rowid)),"^",5)
      s:LOCTYPEActiveFlag="" LOCTYPEActiveFlag="N" 
      d OutputRow
    }
   }
   else
   {
     s:code'="" code=$zcvt(code,"U")
     s:desc'="" desc=$zcvt(desc,"U")  
     s LOCTYPERowId=0
     for
     {  
        s LOCTYPERowId=$o(^CT("LOCTYPE",LOCTYPERowId)) 
        q:LOCTYPERowId="" 
        s LOCTYPEType=""   
        s strLOCTYPERowId="{ID:"_LOCTYPERowId_"}"
       
        if (AuStr[strLOCTYPERowId)||(AuFlag=1) 
        {  
           s LOCTYPECode=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",1)
           s LOCTYPEDesc=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",2) 
           s LOCTYPENationalCode=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",3)
           s LOCTYPEType=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",4)
           s:LOCTYPEType="S" LOCTYPEType="Street"
      
           s:LOCTYPENationalCode'="" LOCTYPENationalCode=$o(^CT("CITAREA",0,"Code",$zcvt(LOCTYPENationalCode,"U"),0))
           s:LOCTYPENationalCode'="" LOCTYPENationalCode=$p($g(^CT("CITAREA",LOCTYPENationalCode)),"^",2)      
           s LOCTYPEActiveFlag=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",5)
           s:LOCTYPEActiveFlag="" LOCTYPEActiveFlag="N"
           if (desc'="")
           {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_LocalityType",LOCTYPERowId,LOCTYPEDesc,desc)
           }
           else
           {
              s AliasFlag= 1   
           }  
           if ($zcvt(LOCTYPECode,"U")[code)&(AliasFlag=1)&(LOCTYPEType="Street")  
           {
              d OutputRow
           }
         }
    }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(LOCTYPERowId,LOCTYPECode,LOCTYPEDesc,LOCTYPENationalCode,LOCTYPEType,LOCTYPEActiveFlag)
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

/// Function: 分页查询
/// CreateDate:2017-3-14
/// Creator:  sunfengchao
/// debug:    d ##class(web.DHCBL.CT.CTLocalityType).GetQuery("","","",0,10)
ClassMethod GetQuery(rowid As %String, code As %String, desc As %String, start As %String, limit As %String, cityareacode As %String) As %String
{
   ;new (rowid,code,desc,start,limit,%Session)
   s count=0
   s AuStr= ##class(web.DHCBL.Authorize.CTLocalityType).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
   if (rowid'="")  
   { 
     s LOCTYPERowId=rowid
     s LOCTYPEType=$p($g(^CT("LOCTYPE",rowid)),"^",4) 
     s:LOCTYPEType="S" LOCTYPEType="Street"
     if (LOCTYPEType="Street")
     {
      s LOCTYPECode=$p($g(^CT("LOCTYPE",rowid)),"^",1)
      s LOCTYPEDesc=$p($g(^CT("LOCTYPE",rowid)),"^",2)
      s LOCTYPENationalCode=$p($g(^CT("LOCTYPE",rowid)),"^",3)
      s:LOCTYPENationalCode'="" LOCTYPENationalCode=$o(^CT("CITAREA",0,"Code",$zcvt(LOCTYPENationalCode,"U"),0))
      s:LOCTYPENationalCode'="" LOCTYPENationalCode=$p($g(^CT("CITAREA",LOCTYPENationalCode)),"^",2) 
      s LOCTYPEActiveFlag=$p($g(^CT("LOCTYPE",rowid)),"^",5)
      s:LOCTYPEActiveFlag="" LOCTYPEActiveFlag="N"
     }
      s count=1
      w "{""LOCTYPERowId"":"""_LOCTYPERowId_""",""LOCTYPECode"":"""_LOCTYPECode_""",""LOCTYPEDesc"":"""_LOCTYPEDesc_""",""LOCTYPENationalCode"":"""_LOCTYPENationalCode_""",""LOCTYPEActiveFlag"":"""_LOCTYPEActiveFlag_""",""LOCTYPEType"":"""_LOCTYPEType_"""}" 
   }
   else
   {
     s:code'="" code=$zcvt(code,"U")
     s:desc'="" desc=$zcvt(desc,"U")  
     if start="" s start=0
     if limit="" s limit=20
     s start=start+1
     s LOCTYPERowId=0
     for
     {  
        s LOCTYPERowId=$o(^CT("LOCTYPE",LOCTYPERowId)) 
        q:LOCTYPERowId="" 
        
        s LOCTYPEType=""   
        s strLOCTYPERowId="{ID:"_LOCTYPERowId_"}"
        if (AuStr[strLOCTYPERowId)||(AuFlag=1) 
        {  
           s LOCTYPECode=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",1)
           s LOCTYPEDesc=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",2) 
           s LOCTYPEType=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",4)
           s LOCTYPENationalCode=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",3)  //
           if (desc'="")
           {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_LocalityType",LOCTYPERowId,LOCTYPEDesc,desc)
           }
           else
           {
              s AliasFlag= 1   
           }   
           if ((($zcvt(LOCTYPECode,"U")[code)||(code=""))&(AliasFlag=1)&(LOCTYPEType="S"))&((LOCTYPENationalCode=cityareacode)||(cityareacode=""))
           {
                k ^TMP("web.Locality","Count",$j)
                s count=count+1
                if (count<start) continue
                if (count<(start+limit))
                {
                   //s LOCTYPENationalCode=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",3)
                   s:LOCTYPEType="S" LOCTYPEType="Street"
      
                   s:LOCTYPENationalCode'="" LOCTYPENationalCode=$o(^CT("CITAREA",0,"Code",$zcvt(LOCTYPENationalCode,"U"),0))
                   s:LOCTYPENationalCode'="" LOCTYPENationalCode=$p($g(^CT("CITAREA",LOCTYPENationalCode)),"^",2)      
                   s LOCTYPEActiveFlag=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",5)
                   s:LOCTYPEActiveFlag="" LOCTYPEActiveFlag="N"
                   if ((count#limit)=1)
                   {
                      w "{""LOCTYPERowId"":"""_LOCTYPERowId_""",""LOCTYPECode"":"""_LOCTYPECode_""",""LOCTYPEDesc"":"""_LOCTYPEDesc_""",""LOCTYPENationalCode"":"""_LOCTYPENationalCode_""",""LOCTYPEActiveFlag"":"""_LOCTYPEActiveFlag_""",""LOCTYPEType"":"""_LOCTYPEType_"""}"
                   }
                   else
                   {
                      w ",{""LOCTYPERowId"":"""_LOCTYPERowId_""",""LOCTYPECode"":"""_LOCTYPECode_""",""LOCTYPEDesc"":"""_LOCTYPEDesc_""",""LOCTYPENationalCode"":"""_LOCTYPENationalCode_""",""LOCTYPEActiveFlag"":"""_LOCTYPEActiveFlag_""",""LOCTYPEType"":"""_LOCTYPEType_"""}"
                   }
                }
           }
         } 
      }
    }  
     s ^Temp("web.Locality","Count",$j)=count
}

/// Function: 调csp时拼装json串
/// CreateDate:2017-3-14
/// Creator:  sunfengchao
ClassMethod GetList(rowid As %String, code As %String, desc As %String, start As %String, limit As %String, cityareacode As %String) As %String
{
 ; new (rowid,code,desc,start,limit,%Session)
  s count=0
  w "{""success"":""true"",""data"":[" 
  d ..GetQuery(rowid,code,desc,start,limit,cityareacode)
  w "]" 
  s count=$g(^Temp("web.Locality","Count",$j))
  w ",total:"_count
  w "}"
}

/// Creator:  sunfengchao
/// Function: 地理信息-街道/乡镇维护  添加修改时的弹出窗口显示信息
/// Debug: w ##class(web.DHCBL.CT.CTLocalityType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.CTLocalityType).%OpenId(id)
 s eobj = ##class(web.Entity.CT.CTLocalityType).%New()
 s eobj.LOCTYPERowId=id
 s eobj.LOCTYPECode= pobj.LOCTYPECode
 s eobj.LOCTYPEDesc = pobj.LOCTYPEDesc
 s eobj.LOCTYPENationalCode=pobj.LOCTYPENationalCode
 s:eobj.LOCTYPENationalCode'="" eobj.LOCTYPENationalCode=$o(^CT("CITAREA",0,"Code",$zcvt(eobj.LOCTYPENationalCode,"U"),0))
 s eobj.LOCTYPEType=pobj.LOCTYPEType
 s:eobj.LOCTYPEType="S" eobj.LOCTYPEType="Street"
 s eobj.LOCTYPEActiveFlag=pobj.LOCTYPEActiveFlag
 s:eobj.LOCTYPEActiveFlag="Y" eobj.LOCTYPEActiveFlag="true"
 s:eobj.LOCTYPEActiveFlag="" eobj.LOCTYPEActiveFlag="false"

 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 s str = "{list:["_str_"]}"
 q str
}

/// Function：街道/乡镇重复校验
/// Creator：sunfengchao
/// CreatDate: 2015-11-12
/// Table：  CT_LocalityType
/// Return："1"(数据重复),"0"(数据不重复)
/// ^CT("LOCTYPE",0,"S","Code", 
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s flag=""
	if ($$ALPHAUP^SSUTIL4(code)'="")
	{
		s idc=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
		if ((idc'="")&&(idc'=id)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Creator:  sunfengchao
/// CreatDate:2015-11-25
/// Description: 地理信息-街道/乡镇维护  删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
/// Others:w ##class(web.DHCBL.CT.CTLocalityType).GetRefFlag("37")
ClassMethod GetRefFlag(id As %String) As %String
{
	s return="",myInfo=""
	/// 街道/乡镇中是否被引用
	if ($d(^CT("ADD",0,"Street",id)))  s myInfo=myInfo_"<地址>"
	
	If (myInfo="")
	{
		s found=0
		s LOCTYPECode=$p($g(^CT("LOCTYPE",id)),"^",1)
		/// 社区中是否被引用  ; 循环遍历社区CT_Community
		s CTCMUNTRowId=0
		for
		{
			s CTCMUNTRowId=$o(^CT("CTCMUNT",CTCMUNTRowId)) q:(CTCMUNTRowId="")||(fount=1) 
			s CTCMUNTNationalCode =$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",3)
			if (CTCMUNTNationalCode=LOCTYPECode)
			{
				s found=1
				s myInfo=myInfo_"<社区>"
				q
			} 
		}
	}
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

/// Function:地理信息-街道/乡镇维护  实现对街道/乡镇的删除操作
/// Creator: sunfengchao
/// Others:d ##class(web.DHCBL.CT.CTLocalityType).DeleteData("4")
ClassMethod DeleteData(id As %String) As %String
{
    s result="",flag=""
    s re=##class(web.DHCBL.CT.CTLocalityType).GetRefFlag(id)
    s RefFlag=$p(re,"^",1)
    if (RefFlag=1)
    {
       s result="{success:'false',info:'"_$p(re,"^",2)_"'}"
    }
    else
    {
       Tstart
       s eobj = ##class(web.Entity.CT.CTLocalityType).%New()
       s obj = ##class(User.CTLocalityType).%OpenId(id)
       s eobj.LOCTYPERowId=id
       s eobj.LOCTYPECode= obj.LOCTYPECode
       s eobj.LOCTYPEDesc = obj.LOCTYPEDesc
       s eobj.LOCTYPENationalCode=obj.LOCTYPENationalCode
       s eobj.LOCTYPEType=obj.LOCTYPEType
       s:eobj.LOCTYPEType="S" eobj.LOCTYPEType="Street"
       s eobj.LOCTYPEActiveFlag=obj.LOCTYPEActiveFlag
       s:eobj.LOCTYPEActiveFlag="Y" eobj.LOCTYPEActiveFlag="true"
       s:eobj.LOCTYPEActiveFlag="N" eobj.LOCTYPEActiveFlag="false"
       s sc=##class(User.CTLocalityType).%DeleteId(id)
       IF $$$ISOK(sc)
       {
         Tc
         s result="{success:'true',info:'删除成功！'}"
         d:eobj.LOCTYPEType="Street" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocalityType","User.CTLocalityType","街道/乡镇",id,eobj.LOCTYPEDesc,"D",eobj)
         d eobj.%Close()
       }
      else
      {
        Trollback
        s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"
        s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("街道/乡镇","web.DHCBL.CT.CTLocalityType","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
      }
    }
     q result
}

/// Creator：    sunfengchao
/// CreatDate:   2015-11-12
/// Description：地理信息-街道/乡镇维护  保存修改街道/乡镇 
/// Table：      User.CTLocalityType
/// Input：      web.Entity.CT.CTLocalityType 实体类
/// Others:      d ##class(web.DHCBL.CT.CTLocalityType).SaveEntity()
/// Return：     成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.CTLocalityType) As %String
{
  s result=""
  s flag=..FormValidate(eobj.LOCTYPERowId,eobj.LOCTYPECode)  //调用重复验证
  if (flag=1)
  {
   s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
  if (eobj.LOCTYPERowId="")       
  {
   s obj=##class(User.CTLocalityType).%New()
  }
  else                           
  {   
    s obj=##class(User.CTLocalityType).%OpenId(eobj.LOCTYPERowId)
    s bobj=##class(web.Entity.CT.CTLocalityType).%New()
    s bobj.LOCTYPERowId=eobj.LOCTYPERowId
    s bobj.LOCTYPECode = obj.LOCTYPECode                      
    s bobj.LOCTYPEDesc= obj.LOCTYPEDesc                     
    s bobj.LOCTYPENationalCode = obj.LOCTYPENationalCode 
    s bobj.LOCTYPEType=obj.LOCTYPEType 
    s:bobj.LOCTYPEType="S" bobj.LOCTYPEType="Street"
    s bobj.LOCTYPEActiveFlag=obj.LOCTYPEActiveFlag
   
  }
   s obj.LOCTYPECode = eobj.LOCTYPECode                      
   s obj.LOCTYPEDesc= eobj.LOCTYPEDesc   
   s:eobj.LOCTYPENationalCode'="" eobj.LOCTYPENationalCode=$p($g(^CT("CITAREA",eobj.LOCTYPENationalCode)),"^",1)                   
   s obj.LOCTYPENationalCode = eobj.LOCTYPENationalCode 
   s obj.LOCTYPEType="S"
   s eobj.LOCTYPEType="S"
   s:eobj.LOCTYPEActiveFlag="true" eobj.LOCTYPEActiveFlag="Y"
   s:eobj.LOCTYPEActiveFlag="false" eobj.LOCTYPEActiveFlag="N"
   s:eobj.LOCTYPEActiveFlag="" eobj.LOCTYPEActiveFlag="N"
   s obj.LOCTYPEActiveFlag=eobj.LOCTYPEActiveFlag
   Tstart
   s sc=obj.%Save()
   if $$$ISOK(sc)
   {
     Tcommit
     s id = obj.%Id()
     if (eobj.LOCTYPERowId="")  //新增时加别名
     {
	     s Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(obj.LOCTYPEDesc)
	     s listData ="^"_"CT_LocalityType"_"^"_Alias_"^"_id
	     s ret=##class(web.DHCBL.BDP.BDPAlias).SaveEntity(listData)
     }
     s result = "{success:'true',id:'"_id_"'}"     
     d:eobj.LOCTYPERowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocalityType","User.CTLocalityType","街道/乡镇",id,eobj.LOCTYPEDesc,"A",eobj)
     d:eobj.LOCTYPERowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_LocalityType","User.CTLocalityType","街道/乡镇",eobj.LOCTYPERowId,eobj.LOCTYPEDesc,"U",eobj,bobj)
   }
   else
   {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("街道/乡镇","web.DHCBL.CT.CTLocalityType","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
   } 
  } 
  q result
}

/// Function:  地理信息-街道/乡镇维护  查询数据列表为combo提供街道/乡镇的接口 
/// Creator:   sunfengchao
/// CreatDate: 2015-11-12
/// Table：    CT_LocalityType
/// Input：    rowid,code,desc ,type 
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTLocalityType", "GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, type As %String, code As %String, desc As %String, nationalcode As %String, CommunityDr As %String) As %Query(ROWSPEC = "LOCTYPERowId:%String,LOCTYPECode:%String,LOCTYPEDesc:%String")
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

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, type As %String, code As %String, desc As %String, nationalcode As %String, CommunityDr As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   s ind=1  
   s AuStr=##class(web.DHCBL.Authorize.CTLocalityType).DHCGetDataByDefaultSession()
   s AuFlag=0
   ;未授权情况下，默认显示全部数据
   if (AuStr="")||(AuStr["limited:0") s AuFlag=1  
   if (rowid'="")  
   { 
     s LOCTYPERowId=rowid
     s LOCTYPECode=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",1)
     s LOCTYPEDesc=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",2)
     s LOCTYPENationalCode=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",3)
     s LOCTYPEType=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",4)
     s LOCTYPEActiveFlag=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",5)
     s:LOCTYPEActiveFlag="" LOCTYPEActiveFlag="N"
     s:LOCTYPEType="S" LOCTYPEType="Street"
     d OutputCmbRow
   }
   else
   {
     s:code'="" code=$zcvt(code,"U")
     s:desc'="" desc=$zcvt(desc,"U")  
     s CityAreaCode=""
     s LOCTYPERowId=0
     for
     {  
        s LOCTYPERowId=$o(^CT("LOCTYPE",LOCTYPERowId)) q:LOCTYPERowId="" 
        s LOCTYPEType=""   
        s strLOCTYPERowId="{ID:"_LOCTYPERowId_"}"
       
        if (AuStr[strLOCTYPERowId)||(AuFlag=1) 
        { 
           s LOCTYPECode=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",1)
           s LOCTYPEDesc=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",2)
           if (desc'="")
           {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_LocalityType",LOCTYPERowId,LOCTYPEDesc,desc)
           }
           else
           {
              s AliasFlag= 1   
           }    
           s LOCTYPENationalCode=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",3)
           s LOCTYPEType=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",4)
           s LOCTYPEActiveFlag=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",5)
           s:LOCTYPEType="S" LOCTYPEType="Street"
           
           s:nationalcode'="" CityAreaCode=$p($g(^CT("CITAREA",nationalcode)),"^",1)
           s CommunityCode=""
           s:CommunityDr'="" CommunityCode=$p($g(^CT("LOCTYPE",CommunityDr)),"^",1)
          
           if ($zcvt(LOCTYPECode,"U")[code)&(AliasFlag=1)&((LOCTYPEType=type)||(type=""))&((LOCTYPENationalCode=CityAreaCode)||(nationalcode=""))&((CommunityCode=LOCTYPENationalCode)||(CommunityDr=""))
           {  
              d OutputCmbRow
           }
        }
    }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputCmbRow
  set Data=$lb(LOCTYPERowId,LOCTYPECode,LOCTYPEDesc)  
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
}

/// Function:为combobox查询取数据
/// Input:code,desc
/// Return: CTCMUNTRowId,CTCMUNTCode,CTCMUNTDesc
/// Other:  d ##class(web.DHCBL.CT.CTLocalityType).GetDataCmb("","","","","","",0,10)
ClassMethod GetDataCmb(rowid As %String, type As %String, code As %String, desc As %String, nationalcode As %String, CommunityDr As %String, start As %String, limit As %String) As %String
{
  s count=0
  if (rowid'="")
  { 
     s LOCTYPERowId=rowid
     s LOCTYPEDesc=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",2)
     w "{""LOCTYPERowId"":"""_LOCTYPERowId_""",""LOCTYPEDesc"":"""_LOCTYPEDesc_"""}"  
  }
  else
  {
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    if start="" s start=0
    if limit="" s limit=20
    s start=start+1
    s AuStr= ##class(web.DHCBL.Authorize.CTLocalityType).DHCGetDataByDefaultSession()
    s AuFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
     
     s CityAreaCode=""
     s LOCTYPERowId=0
     for
     {  
        s LOCTYPERowId=$o(^CT("LOCTYPE",LOCTYPERowId)) 
        q:LOCTYPERowId="" 
        s LOCTYPEType=""   
        s strLOCTYPERowId="{ID:"_LOCTYPERowId_"}"
       
        if (AuStr[strLOCTYPERowId)||(AuFlag=1) 
        { 
        	s LOCTYPECode=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",1)
           s LOCTYPEDesc=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",2)
           if (desc'="")
           {
              ;需要对描述或者别名进行检索      
              s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_LocalityType",LOCTYPERowId,LOCTYPEDesc,desc)
           }
           else
           {
              s AliasFlag= 1   
           }    
           s LOCTYPENationalCode=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",3)
           s LOCTYPEType=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",4)
           s LOCTYPEActiveFlag=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",5)
           s:LOCTYPEType="S" LOCTYPEType="Street"
           s:nationalcode'="" CityAreaCode=$p($g(^CT("CITAREA",nationalcode)),"^",1)
           s CommunityCode=""
           s:CommunityDr'="" CommunityCode=$p($g(^CT("LOCTYPE",CommunityDr)),"^",1)
           s LOCTYPEActiveFlag=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",5)
           if ((AliasFlag=1)&((LOCTYPEType=type)||(type=""))&((LOCTYPENationalCode=CityAreaCode)||(nationalcode=""))&((CommunityCode=LOCTYPENationalCode)||(CommunityDr=""))&(LOCTYPEActiveFlag="Y"))
           {   
                k ^Temp("web.Locality","GetDataCmb1Count",$j)
                s count=count+1
                if (count<start) continue
                if (count<(start+limit))
                {
                   if ((count#limit)=1)
                   {
                      w "{""LOCTYPERowId"":"""_LOCTYPERowId_""",""LOCTYPEDesc"":"""_LOCTYPEDesc_""",""LOCTYPECode"":"""_LOCTYPECode_"""}"   //多加一个输出：代码
                   }  
                   else
                   {
                      w ",{""LOCTYPERowId"":"""_LOCTYPERowId_""",""LOCTYPEDesc"":"""_LOCTYPEDesc_""",""LOCTYPECode"":"""_LOCTYPECode_"""}"    
                   }              
             }
        } 
      }
    }
  }
  s ^Temp("web.Locality","GetDataCmb1Count",$j)=count
}

/// d ##class(web.DHCBL.CT.CTLocalityType).GetDataForCmb1("","","","","","",0,10)
ClassMethod GetDataForCmb1(rowid As %String, type As %String, code As %String, desc As %String, nationalcode As %String, CommunityDr As %String, start As %String, limit As %String) As %String
{
  s count=0
  w "{""success"":""true"",""data"":[" 
  d ..GetDataCmb(rowid,type,code,desc,nationalcode,CommunityDr,start,limit)
  w "]" 
  s count=$g(^Temp("web.Locality","GetDataCmb1Count",$j))
  w ",total:"_count_"}"
}

}
