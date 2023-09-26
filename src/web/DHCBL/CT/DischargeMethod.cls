/// Function: 出院方式
/// CreateDate:2022-09-05
/// Creator:钟荣枫
Class web.DHCBL.CT.DischargeMethod Extends %RegisteredObject
{

/// Function：  信息查询
/// Creator:    钟荣枫
/// CreatDate:  2022-09-05
/// Table：     CT.BDP.CT.DischargeMethod   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DischargeMethod","GetList","","","yz")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,CTDMCode,CTDMDesc,CTDMDateFrom,CTDMDateTo")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s CTDMCode =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),2) /// 代码 
        s CTDMDesc =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),3) /// 描述
        s CTDMDateFrom =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),4) /// 开始日期
        s:CTDMDateFrom'="" CTDMDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTDMDateFrom)
        s CTDMDateTo =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),5) /// 结束日期
        s:CTDMDateTo'="" CTDMDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTDMDateTo)
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.DischargeMethodD(ID))
            q:ID="" 
            s CTDMCode =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),2) /// 代码 
            s CTDMDesc =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),3) /// 描述
            s CTDMDateFrom =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),4) /// 开始日期
            s:CTDMDateFrom'="" CTDMDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTDMDateFrom)
            s CTDMDateTo =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),5) /// 结束日期
            s:CTDMDateTo'="" CTDMDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTDMDateTo)
            s PINYINCODE=""
            s:desc'="" PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTDMDesc) 
            if ((($ZCONVERT(CTDMDesc,"U")[desc)||(PINYINCODE[desc))&&($ZCONVERT(CTDMCode,"U")[code)) 
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,CTDMCode,CTDMDesc,CTDMDateFrom,CTDMDateTo)
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

/// Function: combox查询提供接口 
/// Creator:  钟荣枫
/// CreatDate:2022-09-05
/// Tables: CT.BDP.CT.DischargeMethod
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.DischargeMethod", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,CTDMDesc:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
  Set repid=$I(^CacheTemp)
  s ind=1
  
  s:code'="" code=$zcvt(code,"U")  
  s:desc'="" desc=$zcvt(desc,"U")  
  if (rowid'="")  
  {
	  
       s ID=rowid
    s CTDMCode =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),2) /// 代码 
    s CTDMDesc =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),3) /// 描述
    d OutputRow2
  }
  else
  {
    s ID=0
    for 
    {
       s ID=$o(^CT.BDP.CT.DischargeMethodD(ID))
       q:ID=""  
       s CTDMDateFrom =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),4) /// 开始日期
       continue:(CTDMDateFrom'="")&&(CTDMDateFrom>+$h)
       s CTDMDateTo =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),5) /// 结束日期 
       continue:(CTDMDateTo'="")&&(CTDMDateTo<+$h)
       s CTDMCode =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),2) /// 代码 
       s CTDMDesc =$listget($g(^CT.BDP.CT.DischargeMethodD(ID)),3) /// 描述
       s PINYINCODE=""
	  	s:desc'="" PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(CTDMDesc) 
    	if ((($ZCONVERT(CTDMDesc,"U")[desc)||(PINYINCODE[desc))&&($ZCONVERT(CTDMCode,"U")[code)) 
    	{
        	d OutputRow2
    	}
       
    }
  } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
 set Data=$lb(ID,CTDMDesc)
  Set ^CacheTemp(repid,ind)=Data
  Set ind=ind+1
  q
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

/// Function： 修改时打开的数据
/// Creator:   钟荣枫
/// CreatDate: 2020-07-08
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.DischargeMethod).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.DischargeMethod).%New()
    s obj = ##class(CT.BDP.CT.DischargeMethod).%OpenId(id)
    s eobj.ID=id
    s eobj.CTDMCode=obj.CTDMCode 
    s eobj.CTDMDesc= obj.CTDMDesc   
    s:obj.CTDMDateFrom'="" eobj.CTDMDateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.CTDMDateFrom) 
    s:obj.CTDMDateTo'="" eobj.CTDMDateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.CTDMDateTo) 
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  钟荣枫
/// CreatDate:2022-09-05
/// Table：   CT.BDP.CT.DischargeMethod
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.DischargeMethod).FormValidate("","1","医嘱离院")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^CT.BDP.CT.DischargeMethodI("CodeIndex",code))
    s:desc'="" flagd=$d(^CT.BDP.CT.DischargeMethodI("DescIndex",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^CT.BDP.CT.DischargeMethodI("CodeIndex",code,0))
        s:desc'="" idd=$o(^CT.BDP.CT.DischargeMethodI("DescIndex",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Function    保存内容
/// Creator:    钟荣枫
/// CreatDate:  2022-09-05
/// Table：     CT.BDP.CT.DischargeMethod
/// Input：     web.Entity.CT.DischargeMethod  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.DischargeMethod).SaveData(eobj)
ClassMethod SaveData(eobj As web.Entity.CT.DischargeMethod) As %String
{
 
    s result=""
    if $IsObject(eobj)
	{
	    s:eobj.CTDMDateFrom'="" eobj.CTDMDateFrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTDMDateFrom) 
	    s:eobj.CTDMDateTo'="" eobj.CTDMDateTo= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTDMDateTo) 
	    s:eobj.CTDMDateFrom="" eobj.CTDMDateFrom=+$h
	    s flag=  ..FormValidate(eobj.ID,eobj.CTDMCode,eobj.CTDMDesc)  //调用重复验证
	    if (flag=1)
	    {
	        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
	    }
	    else
	    {
	        if (eobj.ID="")  
	        {
	            s obj=##class(CT.BDP.CT.DischargeMethod).%New()
	        }
	        else              
	        {
	            s obj=##class(CT.BDP.CT.DischargeMethod).%OpenId(eobj.ID)
	            s bobj=##class(web.Entity.CT.DischargeMethod).%New()
	            s bobj.ID=eobj.ID 
	            s bobj.CTDMCode=eobj.CTDMCode
	            s bobj.CTDMDesc= obj.CTDMDesc  
	            s bobj.CTDMDateFrom= obj.CTDMDateFrom
	            s bobj.CTDMDateTo= obj.CTDMDateTo 
	        }
	        TSTART 
	        s obj.CTDMCode = eobj.CTDMCode 
	        s obj.CTDMDesc=eobj.CTDMDesc   
	        s obj.CTDMDateFrom= eobj.CTDMDateFrom
	        s obj.CTDMDateTo= eobj.CTDMDateTo
	        s sc=obj.%Save()
	        d obj.%Close()
	        If $$$ISOK(sc)
	        {
	            TCOMMIT
	            s id = obj.%Id()
	            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
	            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT.BDP.CT.DischargeMethod","CT.BDP.CT.DischargeMethod","出院方式",id,eobj.CTDMDesc,"A",eobj)
	            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT.BDP.CT.DischargeMethod","CT.BDP.CT.DischargeMethod","出院方式",eobj.ID,eobj.CTDMDesc,"U",eobj,bobj)
	        }
	        else
	        {
	            Trollback
	            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
	            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("出院方式","web.DHCBL.CT.DischargeMethod","SaveData",eobj)
	            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
	        }
    	}  
	}
	else
	{
		s result = "{success:'false',errorinfo:'对象不存在！'}"
	} 
     q result
}

/// Creator:钟荣枫
/// CreatDate:2014-10-30
/// Description：根据ID删除出院方式
/// Table：CT.BDP.CT.DischargeMethod
/// Input：id
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.DischargeMethod).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.DischargeMethod).%OpenId(id)
    s eobj = ##class(web.Entity.CT.DischargeMethod).%New()
    s eobj.ID = id
    s eobj.CTDMCode=pobj.CTDMCode
    s eobj.CTDMDesc=pobj.CTDMDesc
    s eobj.CTDMDateFrom= pobj.CTDMDateFrom
    s eobj.CTDMDateTo= pobj.CTDMDateTo 
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.DischargeMethod).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT.BDP.CT.DischargeMethod","CT.BDP.CT.DischargeMethod","出院方式",id,eobj.CTDMDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("出院方式","web.DHCBL.CT.DischargeMethod","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}
