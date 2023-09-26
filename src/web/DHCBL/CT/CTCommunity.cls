/// 名称:地理信息 - 社区/村 维护
/// 描述:包含增删改查功能
/// 编写者: sunfengchao
/// 编写日期:2016-5-11
Class web.DHCBL.CT.CTCommunity Extends %RegisteredObject [ ProcedureBlock ]
{

/// Table: CT_Community
/// Return: CTCMUNTRowId,CTCMUNTCode,CTCMUNTDesc,CTCMUNTNationalCode,CTCMUNTActiveFlag,CTCMUNTDateFrom,CTCMUNTDateTo
/// Other: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCommunity","GetList","","","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, provincedr As %String, start As %String, limit As %String) As %Query(ROWSPEC = "CTCMUNTRowId,CTCMUNTCode,CTCMUNTDesc,CTCMUNTNationalCode,CTCMUNTActiveFlag ")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, provincedr As %String, start As %String, limit As %String) As %Status
{
  s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
  s ind=1
  if (rowid'="")
  { 
    s CTCMUNTRowId=rowid
    s CTCMUNTCode=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",1)
    s CTCMUNTDesc=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",2)
    s CTRowId="",CTCMUNTNationalCode=""
    s CTCMUNTNationalCode =$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",3)
  
    if ($d(^CT("LOCTYPE",0,"Code",$zcvt(CTCMUNTNationalCode,"U")))>0)
    {  
        s CTRowId=$o(^CT("LOCTYPE",0,"Code",$zcvt(CTCMUNTNationalCode,"U"),0))
        s:CTRowId'="" CTCMUNTNationalCode=$p($g(^CT("LOCTYPE",CTRowId)),"^",2)
    }
    else
    {
         s CTCMUNTNationalCode=""
    }
    s CTCMUNTActiveFlag=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",4)
    s:CTCMUNTActiveFlag="" CTCMUNTActiveFlag="N"
    d OutputRow
  }
  else
  {
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    
    s AuStr= ##class(web.DHCBL.Authorize.CTCommunity).DHCGetDataByDefaultSession()
    s AuFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
    s CTCMUNTRowId=0
    for
    {
      s CTCMUNTRowId=$o(^CT("CTCMUNT",CTCMUNTRowId)) q:CTCMUNTRowId=""    
      s strRowId="{ID:"_CTCMUNTRowId_"}"
      if ((AuStr[strRowId)||(AuFlag=1)) ;用来筛选授权数据
      {
        s CTCMUNTCode=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",1)
        s CTCMUNTDesc=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",2)
        s CTRowId="",CTCMUNTNationalCode=""
        s CTCMUNTNationalCode =$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",3)
    
        if ($d(^CT("LOCTYPE",0,"Code",$zcvt(CTCMUNTNationalCode,"U")))>0)
        {  
            s CTRowId=$o(^CT("LOCTYPE",0,"Code",$zcvt(CTCMUNTNationalCode,"U"),0))
            s:CTRowId'="" CTCMUNTNationalCode=$p($g(^CT("LOCTYPE",CTRowId)),"^",2)
        }
        else{
            s CTCMUNTNationalCode=""
        }
        s CTCMUNTActiveFlag=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",4) 
        s:CTCMUNTActiveFlag="" CTCMUNTActiveFlag="N" 
       
        //别名查询
        s ALIASText1=""
        s AliasRowId=0
        for
        {
          s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Community",CTCMUNTRowId,AliasRowId))
          q:AliasRowId=""
          S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
          s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
        }
        if ((code="")||($zcvt(CTCMUNTCode,"U")[code))&(($zcvt(CTCMUNTDesc,"U")[desc)||(ALIASText1[desc)) 
        {
          d OutputRow
        } 
      }
    }
  }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRow
    set Data=$lb(CTCMUNTRowId,CTCMUNTCode,CTCMUNTDesc,CTCMUNTNationalCode,CTCMUNTActiveFlag)
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

/// Function: 后台分页 解决字符超长的问题
/// Table:    CT_Community
/// Return:   CTCMUNTRowId,CTCMUNTCode,CTCMUNTDesc,CTCMUNTNationalCode,CTCMUNTActiveFlag,CTCMUNTDateFrom,CTCMUNTDateTo
/// Other:    d ##class(web.DHCBL.CT.CTCommunity).GetQuery("","","","","","")
ClassMethod GetQuery(rowid As %String, code As %String, desc As %String, provincedr As %String, start As %String, limit As %String, streetdr As %String) As %String
{
  s count=0
  if (rowid'="")
  { 
    s CTRowId="",CTCMUNTNationalCode=""
    s CTCMUNTRowId=rowid
    s CTCMUNTCode=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",1)
    s CTCMUNTDesc=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",2)
    s CTCMUNTNationalCode =$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",3) 
    if (CTCMUNTNationalCode'="")
    {
        if ($d(^CT("LOCTYPE",0,"Code",$zcvt(CTCMUNTNationalCode,"U")))>0)
        {  
            s CTRowId=$o(^CT("LOCTYPE",0,"Code",$zcvt(CTCMUNTNationalCode,"U"),0))
            s:CTRowId'="" CTCMUNTNationalCode=$p($g(^CT("LOCTYPE",CTRowId)),"^",2)
        }
        else
        {
             s CTCMUNTNationalCode=""
        }
    }
    s CTCMUNTActiveFlag=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",4)
    s:CTCMUNTActiveFlag="" CTCMUNTActiveFlag="N"
    s count=1
    w "{""CTCMUNTRowId"":"""_CTCMUNTRowId_""",""CTCMUNTCode"":"""_CTCMUNTCode_""",""CTCMUNTDesc"":"""_CTCMUNTDesc_""",""CTCMUNTNationalCode"":"""_CTCMUNTNationalCode_""",""CTCMUNTActiveFlag"":"""_CTCMUNTActiveFlag_"""}"  
  }
  else
  {
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
    if start="" s start=0
    if limit="" s limit=20
    s start=start+1
    s AuStr= ##class(web.DHCBL.Authorize.CTCommunity).DHCGetDataByDefaultSession()
    s AuFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
    s CTCMUNTRowId=0
    for
    {
      s CTCMUNTRowId=$o(^CT("CTCMUNT",CTCMUNTRowId)) q:CTCMUNTRowId=""    
      s strRowId="{ID:"_CTCMUNTRowId_"}"
      
      if ((AuStr[strRowId)||(AuFlag=1)) ;用来筛选授权数据
      {
        s CTCMUNTCode=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",1)
        s CTCMUNTDesc=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",2)
         //别名查询
        s ALIASText1=""
        s AliasRowId=0
        for
        {
          s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_Community",CTCMUNTRowId,AliasRowId))
          q:AliasRowId=""
          S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
          s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
        }
       s:desc'="" PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTCMUNTDesc)  
       
       s CTCMUNTNationalCode =$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",3)
       
       if (($zcvt(CTCMUNTCode,"U")[code)||(code=""))&(($zcvt(CTCMUNTDesc,"U")[desc)||(ALIASText1[desc)||(PINYINCODE[desc)||(desc=""))&((CTCMUNTNationalCode=streetdr)||(streetdr=""))  // &(CTCMUNTDesc="Y") 
        {
           k ^Temp("web.CTCommunity","Count",$j)
           s count=count+1
           if (count<start) continue
           if (count<(start+limit))
           {
                s CTRowId="",CTCMUNTNationalCode=""
                s CTCMUNTNationalCode =$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",3)
                if (CTCMUNTNationalCode'="")
                {
                    if ($d(^CT("LOCTYPE",0,"Code",$zcvt(CTCMUNTNationalCode,"U")))>0)
                    {  
                        s CTRowId=$o(^CT("LOCTYPE",0,"Code",$zcvt(CTCMUNTNationalCode,"U"),0))
                        s:CTRowId'="" CTCMUNTNationalCode=$p($g(^CT("LOCTYPE",CTRowId)),"^",2)
                    }
                    else
                    {
                         s CTCMUNTNationalCode=""
                    }
                }
                s CTCMUNTActiveFlag=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",4) 
                s:CTCMUNTActiveFlag="" CTCMUNTActiveFlag="N" 
                if ((count#limit)=1)
                {
                   w "{""CTCMUNTRowId"":"""_CTCMUNTRowId_""",""CTCMUNTCode"":"""_CTCMUNTCode_""",""CTCMUNTDesc"":"""_CTCMUNTDesc_""",""CTCMUNTNationalCode"":"""_CTCMUNTNationalCode_""",""CTCMUNTActiveFlag"":"""_CTCMUNTActiveFlag_"""}"  
                }
                else
                {
                   w ",{""CTCMUNTRowId"":"""_CTCMUNTRowId_""",""CTCMUNTCode"":"""_CTCMUNTCode_""",""CTCMUNTDesc"":"""_CTCMUNTDesc_""",""CTCMUNTNationalCode"":"""_CTCMUNTNationalCode_""",""CTCMUNTActiveFlag"":"""_CTCMUNTActiveFlag_"""}"    
                }
              }
           }
         }       
     }  
  }  
  s ^Temp("web.CTCommunity","Count",$j)=count
}

/// Function: 调csp时拼装json串
/// CreateDate:2017-3-14
/// Creator:  sunfengchao
ClassMethod GetList(rowid As %String, code As %String, desc As %String, provincedr As %String, start As %String, limit As %String, streetdr As %String) As %String
{
  ;new (rowid,code,desc,provincedr,start,limit,%Session)
  s count=0
  w "{""success"":""true"",""data"":[" 
  d ..GetQuery(rowid,code,desc,provincedr,start,limit,streetdr)
  w "]" 
  s count=$g(^Temp("web.CTCommunity","Count",$j))
  w ",total:"_count
  w "}"
}

/// Function:为combobox查询取数据
/// Input:code,desc
/// Return: CTCMUNTRowId,CTCMUNTCode,CTCMUNTDesc
/// Other:  d ##class(web.DHCBL.CT.CTCommunity).GetDataCmb("","","","",0,10)
ClassMethod GetDataCmb(rowid As %String, code As %String, desc As %String, CommunityDr As %String, start As %String, limit As %String) As %String
{
  s count=0
  if start="" s start=0
  if limit="" s limit=20
  if (rowid'="")
  { 
    s CTCMUNTRowId=rowid
    s CTCMUNTDesc=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",2)
    w "{""CTCMUNTRowId"":"""_CTCMUNTRowId_""",""CTCMUNTDesc"":"""_CTCMUNTDesc_"""}"  
  }
  else
  {
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
   
    s start=start+1
    s AuStr= ##class(web.DHCBL.Authorize.CTCommunity).DHCGetDataByDefaultSession()
    s AuFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1 
     
    s CTCMUNTRowId=0
    for
    {
      s CTCMUNTRowId=$o(^CT("CTCMUNT",CTCMUNTRowId)) 
      q:CTCMUNTRowId=""    
      s strRowId="{ID:"_CTCMUNTRowId_"}"
      if ((AuStr[strRowId)||(AuFlag=1)) ;用来筛选授权数据
      {
        s CTCMUNTDesc=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",2)
        if (desc'="")
        {
           ;需要对描述或者别名进行检索      
           s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_Community",CTCMUNTRowId,CTCMUNTDesc,desc)
        }
        else
        {
           s AliasFlag= 1   
        } 
        s CTCMUNTNationalCode =$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",3)
        s:CTCMUNTNationalCode'="" CTCMUNTNationalCode=$tr(CTCMUNTNationalCode," ","")
        s CTRowId=""
        s:CTCMUNTNationalCode'="" CTRowId=$o(^CT("LOCTYPE",0,"Code",$zcvt(CTCMUNTNationalCode,"U"),0))
        s CTCMUNTActiveFlag=$p($g(^CT("CTCMUNT",CTCMUNTRowId)),"^",4)
       
        if (AliasFlag=1)&((CTRowId=CommunityDr)||(CommunityDr=""))&(CTCMUNTActiveFlag="Y") 
        {
                k ^TMP("web.Locality","GetDataCmb1Count")
                s count=count+1
                if (count<start) continue
                if (count<(start+limit))
                {
                   if ((count#limit)=1)
                   {
                      w "{""CTCMUNTRowId"":"""_CTCMUNTRowId_""",""CTCMUNTDesc"":"""_CTCMUNTDesc_"""}"   
                   }  
                   else
                   {
                      w ",{""CTCMUNTRowId"":"""_CTCMUNTRowId_""",""CTCMUNTDesc"":"""_CTCMUNTDesc_"""}"  
                   }              
                }
        } 
      }
    }
  }
  s ^TMP("web.Locality","GetDataCmb1Count")=count
}

/// d ##class(web.DHCBL.CT.CTCommunity).GetDataForCmb1("","","",1,0,10)
ClassMethod GetDataForCmb1(rowid As %String, code As %String, desc As %String, CommunityDr As %String, start As %String, limit As %String) As %String
{
 
  s count=0 
  w "{""success"":""true"",""data"":[" 
  d ..GetDataCmb(rowid,code,desc,CommunityDr,start,limit)
  w "]" 
  s count=$g(^TMP("web.Locality","GetDataCmb1Count")) 
  w ",total:"_count
  w "}"
}

/// Function:数据重复验证方法,js调用
/// Creator:sunfengchao
/// CreatDate:2016-5-11
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:d ##class(web.DHCBL.CT.CTCommunity).FormValidate("","")
ClassMethod FormValidate(id As %String, code As %String) As %String
{
	s flag=""
	if ($$ALPHAUP^SSUTIL4(code)'="")
	{
		s idc=$o(^CT("CTCMUNT",0,"Code",$$ALPHAUP^SSUTIL4(code),0))
		if ((idc'="")&&(idc'=id)) s flag=1  //返回重复标志
		else  s flag=0 //返回不重复标志
	}
	q flag
}

/// Function:双击修改时,从后台取数据
/// Creator:sunfengchao
/// CreatDate:2016-5-11
/// Table: CT_Community
/// Input:id
/// Return:Json格式的字符串str={list:[CTCMUNTCode,CTCMUNTDesc,CTCITProvinceDR,CTCMUNTDateFrom,CTCMUNTDateTo,CTCMUNTRowId]}
/// Other:d ##class(web.DHCBL.CT.CTCommunity).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
  s str=""
  s pobj = ##class(User.CTCommunity).%OpenId(id)
  s eobj = ##class(web.Entity.CT.CTCommunity).%New()
  s eobj.CTCMUNTRowId = id
  s eobj.CTCMUNTCode = pobj.CTCMUNTCode
  s eobj.CTCMUNTDesc = pobj.CTCMUNTDesc
  s eobj.CTCMUNTNationalCode=pobj.CTCMUNTNationalCode
  if (eobj.CTCMUNTNationalCode'="")
  {
    if ($d(^CT("LOCTYPE",0,"Code",$zcvt(eobj.CTCMUNTNationalCode,"U")))>0)
    {  
      s eobj.CTCMUNTNationalCode=$o(^CT("LOCTYPE",0,"Code",$$ALPHAUP^SSUTIL4(eobj.CTCMUNTNationalCode),0))
    }
  }
  s eobj.CTCMUNTActiveFlag=pobj.CTCMUNTActiveFlag
  s:eobj.CTCMUNTActiveFlag="Y" eobj.CTCMUNTActiveFlag="true"
  s:((eobj.CTCMUNTActiveFlag="")||(eobj.CTCMUNTActiveFlag="N")) eobj.CTCMUNTActiveFlag="false"
  d pobj.%Close()
  k pobj
  s str = eobj.JsonS()
  s str = "{list:["_str_"]}"
  q str
}

/// Creator:sunfengchao
/// CreatDate:2016-5-11
/// Input:web.Entity.CT.CTCommunity
/// Return:成功返回success:'true'和新增或修改的数据的CTCMUNTRowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.CTCommunity) As %String
{
    s result=""
    if (eobj.CTCMUNTRowId="")       
    {
      s obj=##class(User.CTCommunity).%New()
    }
    else                           
    {
      s obj=##class(User.CTCommunity).%OpenId(eobj.CTCMUNTRowId)
      s bobj=##class(web.Entity.CT.CTCommunity).%New()
      s bobj.CTCMUNTRowId = eobj.CTCMUNTRowId
      s bobj.CTCMUNTCode = obj.CTCMUNTCode
      s bobj.CTCMUNTDesc = obj.CTCMUNTDesc
      s bobj.CTCMUNTActiveFlag=obj.CTCMUNTActiveFlag
      s:bobj.CTCMUNTActiveFlag="" bobj.CTCMUNTActiveFlag="N"
      s bobj.CTCMUNTNationalCode=obj.CTCMUNTNationalCode
     
    }
    s obj.CTCMUNTCode = eobj.CTCMUNTCode
    s obj.CTCMUNTDesc = eobj.CTCMUNTDesc 
    if (eobj.CTCMUNTNationalCode'="")
    {
      if ($d(^CT("LOCTYPE",eobj.CTCMUNTNationalCode))>0)
      { 
        s eobj.CTCMUNTNationalCode=$p($g(^CT("LOCTYPE",eobj.CTCMUNTNationalCode)),"^",1)
      }
    }
    s obj.CTCMUNTNationalCode = eobj.CTCMUNTNationalCode
    s:eobj.CTCMUNTActiveFlag="" eobj.CTCMUNTActiveFlag="N"
    s obj.CTCMUNTActiveFlag = eobj.CTCMUNTActiveFlag 
    Tstart
    s sc=obj.%Save()
    do obj.%Close()
    if $$$ISOK(sc)
    {
      Tcommit
      s id = obj.%Id()
      if (eobj.CTCMUNTRowId="")  //新增时加别名
      {
	      s Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(obj.CTCMUNTDesc)
		  s listData ="^"_"CT_Community"_"^"_Alias_"^"_id
		  s ret=##class(web.DHCBL.BDP.BDPAlias).SaveEntity(listData)
      }
      s result = "{success:'true',id:'"_id_"'}"
      d:eobj.CTCMUNTRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Community","User.CTCommunity","社区/村",id,eobj.CTCMUNTDesc,"A",eobj)
      d:eobj.CTCMUNTRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Community","User.CTCommunity","社区/村",id,eobj.CTCMUNTDesc,"U",eobj,bobj)
    }
    else
    {
      Trollback
      s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("社区/村","web.DHCBL.CT.CTCommunity","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
    }
  q result
}

/// CreatDate:2013-8-21
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
   s return="",myInfo=""
   if ($d(^CT("ADD",0,"Community",id))) 
   {
      s myInfo=myInfo_"<地址>"
      s return="1^在"_myInfo_"表里被引用,不能删除!"
   }
   else
   {
       s return="0^未被引用可删除！"
   }   
    q return
}

/// Function:根据id删除社区/村数据
/// Table:User.CTCommunity
/// Input:id(CTCommunity的CTCMUNTRowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.CTCommunity).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
  s result=""
  s re=##class(web.DHCBL.CT.CTCommunity).GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag=0){
  s pobj = ##class(User.CTCommunity).%OpenId(id)
  s eobj = ##class(web.Entity.CT.CTCommunity).%New()
  s eobj.CTCMUNTRowId = id
  s eobj.CTCMUNTCode = pobj.CTCMUNTCode
  s eobj.CTCMUNTDesc = pobj.CTCMUNTDesc
  s eobj.CTCMUNTActiveFlag=pobj.CTCMUNTActiveFlag
  s eobj.CTCMUNTNationalCode=pobj.CTCMUNTNationalCode 
  d pobj.%Close()
  k pobj
  Tstart
  s sc=##class(User.CTCommunity).%DeleteId(id)
  if $$$ISOK(sc)
  {
    Tcommit
    s result="{success:'true',info:'删除成功！'}"
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_Community","User.CTCommunity","社区/村",id,eobj.CTCMUNTDesc,"D",eobj)
  }
  else
  {
    Trollback
    s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("社区/村","web.DHCBL.CT.CTCommunity","DeleteData",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
  }
  }
  else{
    s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
  }
  q result
}

}
