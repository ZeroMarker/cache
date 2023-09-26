Import SQLUser

/// 名称:地理信息 - 6 城市区域
/// 描述:包含增删改查功能
/// 编写者:基础数据平台组 - 陈莹
/// 编写日期: 2013-12-24
Class web.DHCBL.CT.CTCityArea Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator:陈莹
/// CreatDate:2013-12-24
/// Description:查询 城市区域
/// Table:User.CTCityArea
/// Input:rowid,code,desc,citydr
/// Return:CITAREARowId,CITAREACode,CITAREADesc,CITAREACityDR,CITAREADateFrom,CITAREADateTo
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCityArea","GetList","","","","")
Query GetList(rowid As %String, code As %String, desc As %String, citydr As %String) As %Query(ROWSPEC = "CITAREARowId:%String,CITAREACode:%String,CITAREADesc:%String,CITAREACityDR:%String,CITAREADateFrom:%String,CITAREADateTo:%String ,CITAREARomanCode,CITAREARomanDesc,CITAREAActivity,CITAREASeqNo,CITAREAPYCode,CITAREAWBCode,CITAREAMark,BDPInternalCode:%String,BDPInternalDesc:%String,BDPHospNationalCode:%String,BDPHospNationalDesc:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, citydr As %String) As %Status
{
  s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
  s ind=1
  
  if (rowid'="")
  {
    s CITAREARowId=rowid
    s CITAREACode=$p($g(^CT("CITAREA",CITAREARowId)),"^",1)
    s CITAREADesc=$p($g(^CT("CITAREA",CITAREARowId)),"^",2)
    s CTCITRowId=$p($g(^CT("CITAREA",CITAREARowId)),"^",3)
    i CTCITRowId'=""
    {
      s CITAREACityDR=$p($g(^CT("CIT",CTCITRowId)),"^",2)
      s PROVRowId=$p($g(^CT("CIT",CTCITRowId)),"^",4)
      s PROVDesc=""
      s:PROVRowId'="" PROVDesc=$p($g(^CT("PROV",PROVRowId)),"^",2)  
      s:PROVDesc'="" CITAREACityDR=CITAREACityDR_"-"_PROVDesc
    }
    else
    {
      s CITAREACityDR=""
    }
    s CITAREADateFrom=$p($g(^CT("CITAREA",CITAREARowId)),"^",4)
    s CITAREADateTo=$p($g(^CT("CITAREA",CITAREARowId)),"^",5)
    s:CITAREADateFrom'="" CITAREADateFrom=$zd(CITAREADateFrom,1)
    s:CITAREADateTo'="" CITAREADateTo=$zd(CITAREADateTo,1)
    s CITAREARomanCode=$p($g(^CT("CITAREA",CITAREARowId)),"^",7)		//县级行政区罗马代码
    s CITAREARomanDesc=$p($g(^CT("CITAREA",CITAREARowId)),"^",8)		//县级行政区罗马名称
    
    s CITAREAActivity=$p($g(^CT("CITAREA",CITAREARowId)),"^",9)		//是否有效(Y/N)
    s:CITAREAActivity="" CITAREAActivity="Y"
    s CITAREASeqNo=$p($g(^CT("CITAREA",CITAREARowId)),"^",13)		//系统排序号
	s CITAREAPYCode=$p($g(^CT("CITAREA",CITAREARowId)),"^",17)	//拼音码
	s CITAREAWBCode=$p($g(^CT("CITAREA",CITAREARowId)),"^",18)		//五笔码
	s CITAREAMark=$p($g(^CT("CITAREA",CITAREARowId)),"^",19)		//备注
	
    s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
    s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_CityArea",CITAREARowId)
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
    s AuStr=##class(web.DHCBL.Authorize.CTCityArea).DHCGetDataByDefaultSession()
    s AuFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
     s CITAREACityDRAuStr=##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
    s CITAREACityDRAuFlag=0
    ;未授权情况下，默认显示全部数据
    if (CITAREACityDRAuStr="")||(CITAREACityDRAuStr["limited:0") s CITAREACityDRAuFlag=1
    s CITAREARowId=0
    for
    {
      s CITAREARowId=$o(^CT("CITAREA",CITAREARowId)) q:CITAREARowId=""
      s CITAREACityDR=$p($g(^CT("CITAREA",CITAREARowId)),"^",3)
      s strRowId="{ID:"_CITAREARowId_"}"
      s CITAREACityDRstrRowId="{ID:"_CITAREACityDR_"}"
      if ((AuStr[strRowId)||(AuFlag=1))&&((CITAREACityDRAuStr[CITAREACityDRstrRowId)||(CITAREACityDRAuFlag=1)) ;用来筛选授权数据
      {
        s CITAREACode=$p($g(^CT("CITAREA",CITAREARowId)),"^",1)
        s CITAREADesc=$p($g(^CT("CITAREA",CITAREARowId)),"^",2)
        s CITAREACode1=$ZCONVERT(CITAREACode,"U")
        s CITAREADesc1=$ZCONVERT(CITAREADesc,"U")
        s CTCITRowId=CITAREACityDR
        i CITAREACityDR'=""
        {
          s CITAREACityDR=$p($g(^CT("CIT",CITAREACityDR)),"^",2)
          s PROVRowId=$p($g(^CT("CIT",CTCITRowId)),"^",4)
          s PROVDesc=""
          s:PROVRowId'="" PROVDesc=$p($g(^CT("PROV",PROVRowId)),"^",2)  
          s:PROVDesc'="" CITAREACityDR=CITAREACityDR_"-"_PROVDesc
        }
        s CITAREADateFrom=$p($g(^CT("CITAREA",CITAREARowId)),"^",4)
        s CITAREADateTo=$p($g(^CT("CITAREA",CITAREARowId)),"^",5)
        s:CITAREADateFrom'="" CITAREADateFrom=$zd(CITAREADateFrom,1)
        s:CITAREADateTo'="" CITAREADateTo=$zd(CITAREADateTo,1)
        s CITAREARomanCode=$p($g(^CT("CITAREA",CITAREARowId)),"^",7)		//县级行政区罗马代码
	    s CITAREARomanDesc=$p($g(^CT("CITAREA",CITAREARowId)),"^",8)		//县级行政区罗马名称
	    
	    s CITAREAActivity=$p($g(^CT("CITAREA",CITAREARowId)),"^",9)		//是否有效(Y/N)
	    s:CITAREAActivity="" CITAREAActivity="Y"
	    s CITAREASeqNo=$p($g(^CT("CITAREA",CITAREARowId)),"^",13)		//系统排序号
		s CITAREAPYCode=$p($g(^CT("CITAREA",CITAREARowId)),"^",17)	//拼音码
		s CITAREAWBCode=$p($g(^CT("CITAREA",CITAREARowId)),"^",18)		//五笔码
		s CITAREAMark=$p($g(^CT("CITAREA",CITAREARowId)),"^",19)		//备注
	
        s BDPInternalCode="",BDPInternalDesc="",BDPHospNationalCode="",BDPPHospNationalDesc=""  
        s resultStr=##class(web.DHCBL.BDP.BDPStandardCode).GetStandardCode("CT_CityArea",CITAREARowId)
        s BDPInternalCode =$p($g(resultStr),"^",1)
        s BDPInternalDesc = $p($g(resultStr),"^",2)
        s BDPHospNationalCode=$p($g(resultStr),"^",3)  
        s BDPHospNationalDesc = $p($g(resultStr),"^",4)
        //别名查询
        if (desc'="")
        {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_CityArea",CITAREARowId,CITAREADesc,desc)
        }
        else
        {
            s AliasFlag= 1   
        }  
        if (CITAREACode1[code) &(AliasFlag=1)&((CTCITRowId=citydr)||(citydr=""))
        {
          d OutputRow
        } 
        
      }
    }
  }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRow
    set Data=$lb(CITAREARowId,CITAREACode,CITAREADesc,CITAREACityDR,CITAREADateFrom,CITAREADateTo,CITAREARomanCode,CITAREARomanDesc,CITAREAActivity,CITAREASeqNo,CITAREAPYCode,CITAREAWBCode,CITAREAMark,BDPInternalCode,BDPInternalDesc,BDPHospNationalCode,BDPHospNationalDesc)
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
/// CreatDate:2013-12-24
/// Description:为combobox查询取数据
/// Table:User.CTCityArea
/// Input:code,desc,citydr
/// Return:CITAREARowId,CITAREACode,CITAREADesc
/// Other:d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCityArea","GetDataForCmb1","","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String, citydr As %String) As %Query(ROWSPEC = "CITAREARowId:%String,CITAREACode:%String,CITAREADesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, citydr As %String) As %Status
{
  s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
  s ind=1
  
  if (rowid'="")
  {
    s CITAREARowId=rowid
    s CITAREACode=$p($g(^CT("CITAREA",CITAREARowId)),"^",1)
    s CITAREADesc=$p($g(^CT("CITAREA",CITAREARowId)),"^",2)
    d OutputRowCmb
  }
  else
  {
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
     s AuStr=##class(web.DHCBL.Authorize.CTCityArea).DHCGetDataByDefaultSession()
    s AuFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
     s CITAREACityDRAuStr=##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
    s CITAREACityDRAuFlag=0
    ;未授权情况下，默认显示全部数据
    if (CITAREACityDRAuStr="")||(CITAREACityDRAuStr["limited:0") s CITAREACityDRAuFlag=1
    s CITAREARowId=0
    for
    {
      s CITAREARowId=$o(^CT("CITAREA",CITAREARowId)) q:CITAREARowId=""
      s CITAREACityDR=$p($g(^CT("CITAREA",CITAREARowId)),"^",3)
      s strRowId="{ID:"_CITAREARowId_"}"
      s CITAREACityDRstrRowId="{ID:"_CITAREACityDR_"}"
      if ((AuStr[strRowId)||(AuFlag=1))&&((CITAREACityDRAuStr[CITAREACityDRstrRowId)||(CITAREACityDRAuFlag=1)) ;用来筛选授权数据
      {
        s CITAREACode=$p($g(^CT("CITAREA",CITAREARowId)),"^",1)
        s CITAREADesc=$p($g(^CT("CITAREA",CITAREARowId)),"^",2)
        s CITAREADateFrom=$p($g(^CT("CITAREA",CITAREARowId)),"^",4)
        continue:(CITAREADateFrom'="")&&(CITAREADateFrom>+$h)
        s CITAREADateTo=$p($g(^CT("CITAREA",CITAREARowId)),"^",5) 
        continue:(CITAREADateTo'="")&&(CITAREADateTo<+$h)
        s CTCITRowId=$p($g(^CT("CITAREA",CITAREARowId)),"^",3)
        s:CITAREACityDR'="" CITAREACityDR=$p($g(^CT("CIT",CITAREACityDR)),"^",2)
        s:CITAREACityDR'="" CITAREADesc=CITAREADesc_"-"_CITAREACityDR
        //别名查询
        if (desc'="")
        {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_CityArea",CITAREARowId,CITAREADesc,desc)
        }
        else
        {
            s AliasFlag= 1   
        }  
        if ($ZCONVERT(CITAREACode,"U")[code)&(AliasFlag=1)&((CTCITRowId=citydr)||(citydr=""))
        { 
          d OutputRowCmb
        }
      }
    }
  }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRowCmb
    set Data=$lb(CITAREARowId,CITAREACode,CITAREADesc)
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

/// /d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTCityArea","GetDataForCmb2","","","","")
Query GetDataForCmb2(rowid As %String, code As %String, desc As %String, citydr As %String) As %Query(ROWSPEC = "CITAREARowId:%String,CITAREACode:%String,CITAREADesc:%String")
{
}

ClassMethod GetDataForCmb2Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String, citydr As %String) As %Status
{
  s repid=$I(^CacheTemp) ;取最大节点,避免和别人重复使用globals
  s ind=1
  
  if (rowid'="")
  {
    s CITAREARowId=rowid
    s CITAREACode=$p($g(^CT("CITAREA",CITAREARowId)),"^",1)
    s CITAREADesc=$p($g(^CT("CITAREA",CITAREARowId)),"^",2)
    d OutputRowCmb2
  }
  else
  { 
    s:code'="" code=$ZCONVERT(code,"U")
    s:desc'="" desc=$ZCONVERT(desc,"U")
     s AuStr="" ;##class(web.DHCBL.Authorize.CTCityArea).DHCGetDataByDefaultSession()
    s AuFlag=0
    ;未授权情况下，默认显示全部数据
    if (AuStr="")||(AuStr["limited:0") s AuFlag=1
    s CITAREACityDRAuStr="" ;##class(web.DHCBL.Authorize.CTCity).DHCGetDataByDefaultSession()
    s CITAREACityDRAuFlag=0
    ;未授权情况下，默认显示全部数据
    if (CITAREACityDRAuStr="")||(CITAREACityDRAuStr["limited:0") s CITAREACityDRAuFlag=1
    s CITAREARowId=0
    for
    {
      s CITAREARowId=$o(^CT("CITAREA",CITAREARowId)) q:CITAREARowId=""
      s CITAREACityDR=$p($g(^CT("CITAREA",CITAREARowId)),"^",3)
      s strRowId="{ID:"_CITAREARowId_"}"
      s CITAREACityDRstrRowId="{ID:"_CITAREACityDR_"}"
      if ((AuStr[strRowId)||(AuFlag=1))&&((CITAREACityDRAuStr[CITAREACityDRstrRowId)||(CITAREACityDRAuFlag=1)) ;用来筛选授权数据
      {
         
        s CITAREACode=$p($g(^CT("CITAREA",CITAREARowId)),"^",1)
        s CITAREADesc=$p($g(^CT("CITAREA",CITAREARowId)),"^",2)
        s CITAREADateFrom=$p($g(^CT("CITAREA",CITAREARowId)),"^",4)
        s CITAREADateTo=$p($g(^CT("CITAREA",CITAREARowId)),"^",5)
        continue:(CITAREADateTo'="")&&(CITAREADateTo<+$h)
        s CTCITRowId=$p($g(^CT("CITAREA",CITAREARowId)),"^",3)
        
        //别名查询
       /* s ALIASText1=""
        s AliasRowId=0
        for{
          s AliasRowId=$o(^User.BDPAliasI("DataRef","CT_CityArea",CITAREARowId,AliasRowId))
          q:AliasRowId=""
          S ALIASText=$LISTGET($g(^User.BDPAliasD(AliasRowId)),2)
          s ALIASText1=ALIASText1_"^"_$ZCONVERT(ALIASText,"U")
          
        }
        s PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(CITAREADesc)
        i ($ZCONVERT(CITAREACode,"U")[code)&(($ZCONVERT(CITAREADesc,"U")[desc)||(PINYIN[desc)||(ALIASText1[desc))&(CTCITRowId=citydr)*/
        if (desc'="")
        {
            ;需要对描述或者别名进行检索      
            s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_CityArea",CITAREARowId,CITAREADesc,desc)
        }
        else
        {
            s AliasFlag= 1   
        }  
        if ($ZCONVERT(CITAREACode,"U")[code)&(AliasFlag=1)&(CTCITRowId=citydr)
        { 
          d OutputRowCmb2
        }
      }
    }
    
  }
  Set qHandle=$lb(0,repid,0)
  Quit $$$OK
OutputRowCmb2
    set Data=$lb(CITAREARowId,CITAREACode,CITAREADesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetDataForCmb2Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
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

ClassMethod GetDataForCmb2Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDataForCmb2Execute ]
{
  Set repid=$LIST(qHandle,2)
  Kill ^CacheTemp(repid)
  Quit $$$OK
}

// CITAREA_City_DR->CT_City

/// Creator:陈莹
/// CreatDate:2013-12-24
/// Description:数据重复验证方法,js调用
/// Table:User.CTCityArea
/// Input:id, code, desc
/// Return:"1"(数据重复),"0"(数据不重复)
/// Other:w ##class(web.DHCBL.CT.CTCityArea).FormValidate("","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String = "", cityDR As %String = "") As %String
{
	new (id,code,desc,cityDR)
	s flag=0
	if ($$ALPHAUP^SSUTIL4(code)'="")
    {
	    s CITAREARowId=0
        for
        {
			s CITAREARowId=$o(^CT("CITAREA",0,"Code",$$ALPHAUP^SSUTIL4(code),CITAREARowId)) q:CITAREARowId=""      
			s CITAREADateTo=$p($g(^CT("CITAREA",CITAREARowId)),"^",5)
			continue:(CITAREADateTo'="")
			if (CITAREARowId'=id)
			{
				s flag=1
			}
        }
	    
    }
    if ($$ALPHAUP^SSUTIL4(desc)'="")
    {
	    s CITAREARowId=0
        for
        {
			s CITAREARowId=$o(^CT("CITAREA",0,"Desc",$$ALPHAUP^SSUTIL4(desc),CITAREARowId)) q:CITAREARowId=""      
			s CITAREADateTo=$p($g(^CT("CITAREA",CITAREARowId)),"^",5)
			continue:(CITAREADateTo'="")
			s CITAREACityDR=$p($g(^CT("CITAREA",CITAREARowId)),"^",3)
			if (CITAREARowId'=id)&&(CITAREACityDR=cityDR)
			{
				s flag=1
			}
        } 
    }
  q flag
}

/// Creator:陈莹
/// CreatDate:2013-12-24
/// Description:双击修改时,从后台取数据
/// Table:User.CTCityArea
/// Input:id
/// Return:Json格式的字符串str={list:[CITAREACode,CITAREADesc,CITAREACityDR,CITAREADateFrom,CITAREADateTo,CITAREARowId]}
/// Other:d ##class(web.DHCBL.CT.CTCityArea).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
  n (id)
  s str=""
  s pobj = ##class(User.CTCityArea).%OpenId(id)
  s eobj = ##class(web.Entity.CT.CTCityArea).%New()
  s eobj.CITAREARowId = id
  s eobj.CITAREACode = pobj.CITAREACode
  s eobj.CITAREADesc = pobj.CITAREADesc
  if $IsObject(pobj.CITAREACityDR){
    s eobj.CITAREACityDR = pobj.CITAREACityDR.%Id() 
    }
  s eobj.CITAREADateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CITAREADateFrom)
  s eobj.CITAREADateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.CITAREADateTo)
  
  	s eobj.CITAREARomanCode=pobj.CITAREARomanCode		//县级行政区罗马代码
    s eobj.CITAREARomanDesc=pobj.CITAREARomanDesc		//县级行政区罗马名称
    
    s eobj.CITAREAActivity=pobj.CITAREAActivity		//是否有效(Y/N)
    s:((eobj.CITAREAActivity="Y")||(eobj.CITAREAActivity="")) eobj.CITAREAActivity="true"
    s eobj.CITAREASeqNo=pobj.CITAREASeqNo		//系统排序号
	s eobj.CITAREAPYCode=pobj.CITAREAPYCode		//拼音码
	s eobj.CITAREAWBCode=pobj.CITAREAWBCode		//五笔码
	s eobj.CITAREAMark=pobj.CITAREAMark		//备注
				
  d pobj.%Close()
  k pobj
  s str = eobj.JsonS()
  s str = "{list:["_str_"]}"
  q str
}

/// Creator:陈莹
/// CreatDate:2013-12-24
/// Description:增加/修改 城市区域
/// Table:User.CTCityArea
/// Input:web.Entity.CT.CTCityArea
/// Return:成功返回success:'true'和新增或修改的数据的CITAREARowId;失败返回success:'false'和失败原因
ClassMethod SaveEntity(eobj As web.Entity.CT.CTCityArea) As %String
{
	new (eobj,%session)
	s result=""
	s UserID=""
	if ($d(%session)>0)
	{
		s UserID=$g(%session.Data("LOGON.USERID"))  
	}
	if $IsObject(eobj)
	{
		s:eobj.CITAREAActivity="" eobj.CITAREAActivity="N"
		s:eobj.CITAREALastUpdateDate="" eobj.CITAREALastUpdateDate=+$h		//系统最后更新日期
		s:eobj.CITAREALastUpdateTime="" eobj.CITAREALastUpdateTime=$p($h,",",2)		//系统最后更新时间
		s:eobj.CITAREALastUpdateUser="" eobj.CITAREALastUpdateUser=UserID	//系统最新更新人  
		s flag=..FormValidate(eobj.CITAREARowId,eobj.CITAREACode,"","")  //调用重复验证
		if (flag=1)
		{
			s result = "{success:'false',errorinfo:'该代码已经存在！'}"
		}
		else
		{

			s flag=..FormValidate(eobj.CITAREARowId,"",eobj.CITAREADesc,eobj.CITAREACityDR)  //调用重复验证
			if (flag=1)
			{
				s result = "{success:'false',errorinfo:'一个城市下不能有两个相同的城市区域！'}"
			}
			else
			{
				s:eobj.CITAREADateFrom'="" eobj.CITAREADateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CITAREADateFrom)
				s:eobj.CITAREADateTo'="" eobj.CITAREADateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CITAREADateTo)
				s:eobj.CITAREADateFrom="" eobj.CITAREADateFrom=+$h
				if (eobj.CITAREARowId="")       
				{
					s obj=##class(User.CTCityArea).%New()
					s:eobj.CITAREACreateDate="" eobj.CITAREACreateDate=+$h	//系统创建日期默认当前日期
					s:eobj.CITAREACreateTime="" eobj.CITAREACreateTime=$p($h,",",2)	//系统创建时间默认当前时间
					s:eobj.CITAREACreateUser="" eobj.CITAREACreateUser= UserID		//系统创建人默认当前登录人员
					s obj.CITAREACreateDate=eobj.CITAREACreateDate		//系统创建日期
					s obj.CITAREACreateTime=eobj.CITAREACreateTime		//系统创建时间
					d obj.CITAREACreateUserSetObjectId(eobj.CITAREACreateUser)	//系统创建人
				}
				else                           
				{
					s obj=##class(User.CTCityArea).%OpenId(eobj.CITAREARowId)
					s bobj=##class(web.Entity.CT.CTCityArea).%New()
					s bobj.CITAREARowId = eobj.CITAREARowId
					s bobj.CITAREACode = obj.CITAREACode
					s bobj.CITAREADesc = obj.CITAREADesc
					if $IsObject(obj.CITAREACityDR){
						s bobj.CITAREACityDR = obj.CITAREACityDR.%Id() 
					}
					s bobj.CITAREADateFrom = obj.CITAREADateFrom
					s bobj.CITAREADateTo   = obj.CITAREADateTo

					s bobj.CITAREARomanCode=obj.CITAREARomanCode		//县级行政区罗马代码
					s bobj.CITAREARomanDesc=obj.CITAREARomanDesc		//县级行政区罗马名称

					s bobj.CITAREAActivity=obj.CITAREAActivity		//是否有效(Y/N)
					s bobj.CITAREACreateDate=obj.CITAREACreateDate		//系统创建日期
					s bobj.CITAREACreateTime=obj.CITAREACreateTime		//系统创建时间
					if $IsObject(obj.CITAREACreateUser){
						s bobj.CITAREACreateUser = obj.CITAREACreateUser.%Id() 		//系统创建人
					}
					s bobj.CITAREASeqNo=obj.CITAREASeqNo		//系统排序号
					s bobj.CITAREALastUpdateDate=obj.CITAREALastUpdateDate		//系统最后更新日期
					s bobj.CITAREALastUpdateTime=obj.CITAREALastUpdateTime		//系统最后更新时间
					if $IsObject(obj.CITAREALastUpdateUser){
						s bobj.CITAREALastUpdateUser = obj.CITAREALastUpdateUser.%Id() 	//系统最新更新人
					}
					s bobj.CITAREAPYCode=obj.CITAREAPYCode		//拼音码
					s bobj.CITAREAWBCode=obj.CITAREAWBCode		//五笔码
					s bobj.CITAREAMark=obj.CITAREAMark		//备注

				}
				s obj.CITAREACode = eobj.CITAREACode
				s obj.CITAREADesc = eobj.CITAREADesc
				d obj.CITAREACityDRSetObjectId(eobj.CITAREACityDR)
				s obj.CITAREADateFrom = eobj.CITAREADateFrom
				s obj.CITAREADateTo   = eobj.CITAREADateTo

				s obj.CITAREARomanCode=eobj.CITAREARomanCode		//县级行政区罗马代码
				s obj.CITAREARomanDesc=eobj.CITAREARomanDesc		//县级行政区罗马名称

				s obj.CITAREAActivity=eobj.CITAREAActivity		//是否有效(Y/N)
				s obj.CITAREASeqNo=eobj.CITAREASeqNo		//系统排序号
				s obj.CITAREALastUpdateDate=eobj.CITAREALastUpdateDate		//系统最后更新日期
				s obj.CITAREALastUpdateTime=eobj.CITAREALastUpdateTime		//系统最后更新时间
				d obj.CITAREALastUpdateUserSetObjectId(eobj.CITAREALastUpdateUser) 	//系统最新更新人
				s:eobj.CITAREAPYCode="" eobj.CITAREAPYCode=##class(web.DHCBL.BDP.FunLib).GetPYCODE(eobj.CITAREADesc)
				s obj.CITAREAPYCode=eobj.CITAREAPYCode		//拼音码
				s:eobj.CITAREAWBCode="" eobj.CITAREAWBCode=##class(web.DHCBL.BDP.FunLib).GetSWBCODE(eobj.CITAREADesc,1)
				s obj.CITAREAWBCode=eobj.CITAREAWBCode		//五笔码
				s obj.CITAREAMark=eobj.CITAREAMark		//备注

				Tstart
				s sc=obj.%Save()
				do obj.%Close()
				if $$$ISOK(sc)
				{
					Tcommit
					s id = obj.%Id()
					if (eobj.CITAREARowId="")  //新增时加别名
					{
						s Alias=##class(web.DHCBL.BDP.FunLib).GetPYCODE(obj.CITAREADesc)
						s listData ="^"_"CT_CityArea"_"^"_Alias_"^"_id
						s ret=##class(web.DHCBL.BDP.BDPAlias).SaveEntity(listData)
					}
					s result = "{success:'true',id:'"_id_"'}"
					d:eobj.CITAREARowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CityArea","User.CTCityArea","城市区域",id,eobj.CITAREADesc,"A",eobj)
					d:eobj.CITAREARowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CityArea","User.CTCityArea","城市区域",id,eobj.CITAREADesc,"U",eobj,bobj)
				}
				else
				{
					Trollback
					s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
					s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("城市区域","web.DHCBL.CT.CTCityArea","SaveEntity",eobj)
					s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				}
			}
		}
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	} 
	q result
}

/// Creator:陈莹
/// CreatDate:2013-12-24
/// Description:删除限制
/// Return:1-被引用不可删除,0-未被引用可删除
ClassMethod GetRefFlag(id As %String) As %String
{
  s return="",myInfo=""
  
  if $d(^CT("ZIP",0,"CityArea",id)){
    s myInfo=myInfo_"<邮编>"
  }
  if $d(^CT("ADD",0,"CityArea",id)){
    s myInfo=myInfo_"<地址>"
  }

  s LOCTYPERowId=0
  for
  {  
    s LOCTYPERowId=$o(^CT("LOCTYPE",LOCTYPERowId)) 
    q:LOCTYPERowId="" 
    s LOCTYPENationalCode=$p($g(^CT("LOCTYPE",LOCTYPERowId)),"^",3)
    if (LOCTYPENationalCode="") continue
    s rowid=""
    s rowid=$o(^CT("CITAREA",0,"Code",$zcvt(LOCTYPENationalCode,"U"),0))
    if (rowid=id)
    {
       s myInfo=myInfo_"<街道>"
       q 
    }
  }
  if $d(^CT.BDP.CT.HOSOrganizationI("IndexDISTRCode",id)){
	    s myInfo=myInfo_"<组织机构树>"
	}
	if $d(^CT.BDP.CT.HOSPersonI("IndexNPDISTRCode",id)){
	    s myInfo=myInfo_"<组织人员>"
	}
	if $d(^CT.BDP.CT.HOSPersonI("IndexAddrDISTRCode",id)){
	    s myInfo=myInfo_"<组织人员>"
	}
    
  if myInfo="" s return="0^未被引用可删除！"
  else  s return="1^在"_myInfo_"表里被引用,不能删除！"
  
  q return
}

/// Creator:陈莹
/// CreatDate:2013-12-24
/// Description:根据id删除 城市区域
/// Table:User.CTCityArea
/// Input:id(CTCityArea的CITAREARowId) 
/// Return:成功返回"{success:'true',info:'删除成功！'}",失败返回"{success:'false'和失败原因}
/// Other:d ##class(web.DHCBL.CT.CTCityArea).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
  s result=""
  s re=##class(web.DHCBL.CT.CTCityArea).GetRefFlag(id)
  s RefFlag=$p(re,"^",1)
  if (RefFlag=0){
  s pobj = ##class(User.CTCityArea).%OpenId(id)
  s eobj = ##class(web.Entity.CT.CTCityArea).%New()
  s eobj.CITAREARowId = id
  s eobj.CITAREACode = pobj.CITAREACode
  s eobj.CITAREADesc = pobj.CITAREADesc
  if $IsObject(pobj.CITAREACityDR){
    s eobj.CITAREACityDR = pobj.CITAREACityDR.%Id() 
    }
  s eobj.CITAREADateFrom =pobj.CITAREADateFrom
  s eobj.CITAREADateTo = pobj.CITAREADateTo
  //s:pobj.CITAREADateFrom'="" eobj.CITAREADateFrom =$zd(pobj.CITAREADateFrom,1)
  //s:pobj.CITAREADateTo'="" eobj.CITAREADateTo = $zd(pobj.CITAREADateTo,1)
  s eobj.CITAREARomanCode=pobj.CITAREARomanCode		//县级行政区罗马代码
    s eobj.CITAREARomanDesc=pobj.CITAREARomanDesc		//县级行政区罗马名称
    
    s eobj.CITAREAActivity=pobj.CITAREAActivity		//是否有效(Y/N)
    s eobj.CITAREASeqNo=pobj.CITAREASeqNo		//系统排序号
	s eobj.CITAREAPYCode=pobj.CITAREAPYCode		//拼音码
	s eobj.CITAREAWBCode=pobj.CITAREAWBCode		//五笔码
	s eobj.CITAREAMark=pobj.CITAREAMark		//备注
  d pobj.%Close()
  k pobj
  Tstart
  s sc=##class(User.CTCityArea).%DeleteId(id)
  if $$$ISOK(sc){
    Tcommit
    s result="{success:'true',info:'删除成功！'}"
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_CityArea","User.CTCityArea","城市区域",id,eobj.CITAREADesc,"D",eobj)
  }
  else{
    Trollback
    s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
    s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("城市区域","web.DHCBL.CT.CTCityArea","DeleteData",eobj)
    s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
  }
  }
  else{
    s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
  }
  q result
}

}
