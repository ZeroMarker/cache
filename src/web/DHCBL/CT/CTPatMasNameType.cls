/// Function: 病人姓名类型
/// CreateDate:2022-07-14
/// Creator:sunfengchao
Class web.DHCBL.CT.CTPatMasNameType Extends %RegisteredObject
{

/// Function：  信息查询
/// Creator:    sunfengchao
/// CreatDate:  2022-07-14
/// Table：     CT_BDP_CT.CTPatMasNameType   
/// Other:      d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTPatMasNameType","GetList","","","")
Query GetList(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID,CTPMNTCode,CTPMNTDesc,CTPMNTDateFrom,CTPMNTDateTo")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1
    
    if (rowid'="") //根据rowid返回该条记录
    { 
        s ID=rowid
        s CTPMNTCode =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),2) /// 代码 
        s CTPMNTDesc =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),3) /// 描述
        s CTPMNTDateFrom =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),4) /// 开始日期
        s:CTPMNTDateFrom'="" CTPMNTDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPMNTDateFrom)
        s CTPMNTDateTo =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),5) /// 结束日期
        s:CTPMNTDateTo'="" CTPMNTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPMNTDateTo)
        d OutputRow
    }
    else
    {  
        s ID=0
        for 
        {
            s ID=$o(^CT.BDP.CT.CTPatMasNameTypeD(ID))
            q:ID="" 
            s CTPMNTCode =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),2) /// 代码 
            s CTPMNTDesc =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),3) /// 描述
            s CTPMNTDateFrom =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),4) /// 开始日期
            s:CTPMNTDateFrom'="" CTPMNTDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPMNTDateFrom)
            s CTPMNTDateTo =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),5) /// 结束日期
            s:CTPMNTDateTo'="" CTPMNTDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(CTPMNTDateTo)
            if (($zcvt(CTPMNTCode,"U")[$zcvt(code,"U"))||(CTPMNTCode=""))&(($zcvt(CTPMNTDesc,"U")[$zcvt(desc,"U"))||(desc=""))
            {
                d OutputRow
            }  
        }
    }
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
OutputRow  
    set Data=$lb(ID,CTPMNTCode,CTPMNTDesc,CTPMNTDateFrom,CTPMNTDateTo)
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
/// Creator:  sunfengchao
/// CreatDate:2022-07-14
/// Tables: CT_BDP_CT.CTPatMasNameType
/// Input:  code,desc  
/// Others: d ##class(%ResultSet).RunQuery("web.DHCBL.CT.CTPatMasNameType", "GetDataForCmb1","","","")
Query GetDataForCmb1(rowid As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,CTPMNTDesc:%String")
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
    s CTPMNTCode =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),2) /// 代码 
    s CTPMNTDesc =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),3) /// 描述
    d OutputRow2
  }
  else
  {
    s ID=0
    for 
    {
       s ID=$o(^CT.BDP.CT.CTPatMasNameTypeD(ID))
       q:ID=""  
       s CTPMNTDateFrom =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),4) /// 开始日期
       continue:(CTPMNTDateFrom'="")&&(CTPMNTDateFrom>+$h)
       s CTPMNTDateTo =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),5) /// 结束日期 
       continue:(CTPMNTDateTo'="")&&(CTPMNTDateTo<+$h)
       s CTPMNTCode =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),2) /// 代码 
       s CTPMNTDesc =$listget($g(^CT.BDP.CT.CTPatMasNameTypeD(ID)),3) /// 描述
       if (desc'="")
       {
         ;需要对描述或者别名进行检索      
         s AliasFlag=##class(web.DHCBL.BDP.BDPAlias).GetAlisForQuery("CT_BDP_CT.CTPatMasNameType",ID,CTPMNTDesc,desc)
       }
       else
       {
         s AliasFlag= 1   
       }   
       if (($ZCVT(CTPMNTCode,"U")[code))&(AliasFlag=1) 
       {
         d OutputRow2
       }
    }
  } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2   
 set Data=$lb(ID,CTPMNTDesc)
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
/// Creator:   sunfengchao
/// CreatDate: 2020-07-08
/// Input：    id    
/// Other:     w ##class(web.DHCBL.CT.CTPatMasNameType).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
    s str=""    
    s eobj = ##class(web.Entity.CT.CTPatMasNameType).%New()
    s obj = ##class(CT.BDP.CT.CTPatMasNameType).%OpenId(id)
    s eobj.ID=id
    s eobj.CTPMNTCode=obj.CTPMNTCode 
    s eobj.CTPMNTDesc= obj.CTPMNTDesc   
    s:obj.CTPMNTDateFrom'="" eobj.CTPMNTDateFrom= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.CTPMNTDateFrom) 
    s:obj.CTPMNTDateTo'="" eobj.CTPMNTDateTo= ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(obj.CTPMNTDateTo) 
    s str = eobj.JsonS()    
    d eobj.%Close()
    d obj.%Close()
    q str
}

/// Function：数据重复验证方法 
/// Creator:  sunfengchao
/// CreatDate:2022-07-14
/// Table：   CT.BDP.CT.CTPatMasNameType
/// Input：   id-rowid, code-代码,desc-描述
/// Return：  "1"(数据重复),"0"(数据不重复)
/// Other:    d ##class(web.DHCBL.CT.CTPatMasNameType).FormValidate("","","")
ClassMethod FormValidate(id As %String, code As %String, desc As %String) As %String
{
    s flag="",flagc="",flagd=""
    s:code'="" flagc=$d(^CT.BDP.CT.CTPatMasNameTypeI("CodeIndex",code))
    s:desc'="" flagd=$d(^CT.BDP.CT.CTPatMasNameTypeI("DescIndex",desc))
    if (id="") //如果为空，增加时的重复判断
    {
        if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    else //如果不为空，修改时的重复判断
    {
        s idc="",idd=""
        s:code'="" idc=$o(^CT.BDP.CT.CTPatMasNameTypeI("CodeIndex",code,0))
        s:desc'="" idd=$o(^CT.BDP.CT.CTPatMasNameTypeI("DescIndex",desc,0))
        if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    }
    q flag
}

/// Function    保存内容
/// Creator:    sunfengchao
/// CreatDate:  2022-07-14
/// Table：     CT.BDP.CT.CTPatMasNameType
/// Input：     web.Entity.CT.CTPatMasNameType  
/// Return：    成功返回success:'true'和新增或修改的数据RowId；失败返回success:'false'和失败原因
/// Other:      d ##class(web.DHCBL.CT.CTPatMasNameType).SaveData(eobj)
ClassMethod SaveData(eobj As web.Entity.CT.CTPatMasNameType) As %String
{
 
    s result="" 
    s:eobj.CTPMNTDateFrom'="" eobj.CTPMNTDateFrom= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTPMNTDateFrom) 
    s:eobj.CTPMNTDateTo'="" eobj.CTPMNTDateTo= ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.CTPMNTDateTo) 
    s flag=  ..FormValidate(eobj.ID,eobj.CTPMNTCode,eobj.CTPMNTDesc)  //调用重复验证
    if (flag=1)
    {
        s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
        if (eobj.ID="")  
        {
            s obj=##class(CT.BDP.CT.CTPatMasNameType).%New()
        }
        else              
        {
            s obj=##class(CT.BDP.CT.CTPatMasNameType).%OpenId(eobj.ID)
            s bobj=##class(web.Entity.CT.CTPatMasNameType).%New()
            s bobj.ID=eobj.ID 
            s bobj.CTPMNTCode=eobj.CTPMNTCode
            s bobj.CTPMNTDesc= obj.CTPMNTDesc  
            s bobj.CTPMNTDateFrom= obj.CTPMNTDateFrom
            s bobj.CTPMNTDateTo= obj.CTPMNTDateTo 
        }
        TSTART 
        s obj.CTPMNTCode = eobj.CTPMNTCode 
        s obj.CTPMNTDesc=eobj.CTPMNTDesc   
        s obj.CTPMNTDateFrom=eobj.CTPMNTDateFrom   
        s obj.CTPMNTDateTo=eobj.CTPMNTDateTo   
        
        s sc=obj.%Save()
        d obj.%Close()
        If $$$ISOK(sc)
        {
            TCOMMIT
            s id = obj.%Id()
            s result = "{success:'true',id:'"_id_"'}"  //返回RowId  
            d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.CTPatMasNameType","CT.BDP.CT.CTPatMasNameType","多类型姓名",id,eobj.CTPMNTDesc,"A",eobj)
            d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.CTPatMasNameType","CT.BDP.CT.CTPatMasNameType","多类型姓名",eobj.ID,eobj.CTPMNTDesc,"U",eobj,bobj)
        }
        else
        {
            Trollback
            s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
            s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("多类型姓名","web.DHCBL.CT.CTPatMasNameType","SaveData",eobj)
            s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
        }
    }  
     q result
}

/// Creator:sunfengchao
/// CreatDate:2014-10-30
/// Description：根据ID删除特殊人群的内容
/// Table：CT.BDP.CT.CTPatMasNameType
/// Input：id-知识库标识字典的rowid
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
/// Other:w ##class(web.DHCBL.CT.CTPatMasNameType).DeleteData("7")
ClassMethod DeleteData(id As %String) As %String
{
    s result="" 
    //new Entity对象，用于保存日志
    s pobj = ##class(CT.BDP.CT.CTPatMasNameType).%OpenId(id)
    s eobj = ##class(web.Entity.CT.CTPatMasNameType).%New()
    s eobj.ID = id
    s eobj.CTPMNTCode=pobj.CTPMNTCode
    s eobj.CTPMNTDesc=pobj.CTPMNTDesc
    s eobj.CTPMNTDateFrom= pobj.CTPMNTDateFrom
    s eobj.CTPMNTDateTo= pobj.CTPMNTDateTo 
    d pobj.%Close()
    k pobj
    Tstart
    s sc=##class(CT.BDP.CT.CTPatMasNameType).%DeleteId(id)
    if $$$ISOK(sc)
    {
        Tcommit
        s result = "{success:'true',info:'删除成功！'}"  
        //保存日志
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("CT_BDP_CT.CTPatMasNameType","CT.BDP.CT.CTPatMasNameType","多类型姓名",id,eobj.CTPMNTDesc,"D",eobj)
        d eobj.%Close()
    }
    else 
    {
        Trollback
        s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
        s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("多类型姓名","web.DHCBL.CT.CTPatMasNameType","DeleteData",eobj)
        s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
    } 
    q result
}

}
