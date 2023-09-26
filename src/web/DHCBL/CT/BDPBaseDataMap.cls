/// Function:定义第三方系统、字典
/// Creator: sunfengchao
/// CreateDate:2019-12-26
Class web.DHCBL.CT.BDPBaseDataMap Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Function:比较日期大小
/// CreateDate:2018-10-19
/// Creator: sunfengchao
ClassMethod CompareDate(DateFrom As %String, DateTo As %String)
{
    new (DateFrom,DateTo,%session)
    s result=0
    s:DateFrom'="" DateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(DateFrom)
    s:DateTo'="" DateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(DateTo)
    s result=DateFrom>DateTo
    q result
}

/// Function: 查询 左侧目录 的数据 
/// CreateDate:2020-01-13
/// Creator: sunfengchao
/// Tables:  BDPTableList 
/// Input:   nodeid 表结构登记的id 
/// Others:  d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPBaseDataMap","GetTableListForCmb1","1")
Query GetTableListForCmb1(nodeid As %String, ACode As %String) As %Query(ROWSPEC = "RowId,BDPBaseDMTableCode,BDPBaseDMTableDesc")
{
}

ClassMethod GetTableListForCmb1Execute(ByRef qHandle As %Binary, nodeid As %String, ACode As %String) As %Status
{
 
  new (qHandle,nodeid,ACode,%session)
  s repid=$I(^CacheTemp)
  s ind=1 
  s TableListID=""
  if nodeid'="" s TableListID= $lg($g(^User.BDPBaseDataMapD(nodeid)),7)  // 表结构登记指向dr
  if (nodeid="")||(TableListID="")
  {
     Set qHandle=$lb(0,repid,0)
     Quit $$$OK 
  } 
  s XCode=$LISTGET($G(^User.BDPTableListD(TableListID)),4)
  s tableName=$LISTGET($G(^User.BDPTableListD(TableListID)),8)
  s XCode2=$LISTGET($G(^User.BDPTableListD(TableListID)),6) 
 
  if (tableName="ARC_ItmMast")
  {
        s ARCIMSubscript=0
        for
        {
            s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")
            s ARCIMVersion=0
            for 
            {
                s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))
                q:(ARCIMVersion="")
                s RowId=ARCIMSubscript_"||"_ARCIMVersion
                s code=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)  
                s str=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
                s code =$tr(code,"""","")
                s code =$p(code,$c(13,10),1)
                s str =$tr(str,"""","")
                s str =$p(str,$c(13,10),1)
                
                if ($zcvt(code,"U")[$zcvt(ACode,"U"))
                {
                    s BDPBaseDMTableCode = code 
                    s BDPBaseDMTableDesc = str 
                    d OutputRow 
                }   
            }
        }
    } 
    else
    { 
      S IIIFFF=$p($p(XCode,"^",2),"RowId",1)
      if (IIIFFF="")
      {
         Set qHandle=$lb(0,repid,0)
         Quit $$$OK 
      }
      s oxstr="s RowId=$o(^"_IIIFFF_"RowId"_"))"
    
      S RowId=0
      for
      {
            x oxstr q:RowId="" 
            if XCode2="" s XCode2=$tr(XCode,2,1)   
            if XCode2'="" s XCode2="s code="_$p(XCode2,"=",2)  
            x XCode
            x XCode2
            if ($zcvt(code,"U")[$zcvt(ACode,"U"))
            {  
                s BDPBaseDMTableCode = code 
                s BDPBaseDMTableDesc = str  
                d OutputRow 
            }  
      } 
   } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set ^CacheTemp(repid,ind)=$lb(RowId,BDPBaseDMTableCode,BDPBaseDMTableDesc)
    Set ind=ind+1
    quit
}

ClassMethod GetTableListForCmb1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTableListForCmb1Execute ]
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

ClassMethod GetTableListForCmb1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTableListForCmb1Execute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function:判断字典数据是否已全部对照
/// Creator: sunfengchao
/// CreateDate:2020-01-17
/// OutPut:  1 全部对照 0 未完全对照
/// w ##class(web.DHCBL.CT.BDPBaseDataMap).GetDataMapFlag("01","CT_Sex")
ClassMethod GetDataMapFlag(SystemCode As %String, TableCode As %String) As %String
{
  q:(SystemCode="")||(TableCode="") 1
  s nodeid=$O(^User.BDPBaseDataMapI("CodeI",TableCode,0)) 
  s TableListID=""  
  if nodeid'="" s TableListID= $lg($g(^User.BDPBaseDataMapD(nodeid)),7)  // 表结构登记指向dr
  q:(nodeid="")||(TableListID="") 1  
  s XCode=$LISTGET($G(^User.BDPTableListD(TableListID)),4)
  s tableName=$LISTGET($G(^User.BDPTableListD(TableListID)),8)
  s XCode2=$LISTGET($G(^User.BDPTableListD(TableListID)),6)  
  s VFlag=""
  if (tableName="ARC_ItmMast")
  {
        s ARCIMSubscript=0
        for
        {
            s ARCIMSubscript=$o(^ARCIM(ARCIMSubscript)) q:(ARCIMSubscript="")
            s ARCIMVersion=0
            for 
            {
                s ARCIMVersion=$o(^ARCIM(ARCIMSubscript,ARCIMVersion))
                q:(ARCIMVersion="")||(VFlag=0)
                s RowId=ARCIMSubscript_"||"_ARCIMVersion
                s code=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",1)  
                s str=$p($g(^ARCIM(ARCIMSubscript,ARCIMVersion,1)),"^",2)
                s code =$tr(code,"""","")
                s code =$p(code,$c(13,10),1)
                s str =$tr(str,"""","")
                s str =$p(str,$c(13,10),1) 
                s BDPBaseDMTableCode = code  
                s VFlag= $d(^User.BDPBaseDataMapDetailI("HisCodeIdx",SystemCode,TableCode,BDPBaseDMTableCode))
                continue:VFlag=1
                q:VFlag=0   
            }
        }
    } 
    else
    { 
      S IIIFFF=$p($p(XCode,"^",2),"RowId",1)
      if (IIIFFF="")
      {
         Set qHandle=$lb(0,repid,0)
         Quit $$$OK 
      }
      s oxstr="s RowId=$o(^"_IIIFFF_"RowId"_"))"
    
      S RowId=0
      for
      {
            x oxstr q:RowId="" 
            if XCode2="" s XCode2=$tr(XCode,2,1)   
            if XCode2'="" s XCode2="s code="_$p(XCode2,"=",2)  
            x XCode
            x XCode2
            
            s BDPBaseDMTableCode = code 
            s BDPBaseDMTableDesc = str   
            s VFlag= $d(^User.BDPBaseDataMapDetailI("HisCodeIdx",SystemCode,TableCode,BDPBaseDMTableCode)) 
            continue:VFlag=1
            q:VFlag=0
           
      } 
   } 
   if VFlag=0 s return=0
   else  s return=1
   q return
}

/// Function: 双击时 显示 
/// Creator:sunfengchao
/// CreateDate:2013-07-04 
/// Input:  id
/// Tables: BDPBaseDataMap 
/// Others: w ##class(web.DHCBL.CT.BDPBaseDataMap).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
 new (id,%session)
 s str=""
 s pobj = ##class(User.BDPBaseDataMap).%OpenId(id)
 s eobj = ##class(web.Entity.CT.BDPBaseDataMap).%New()
 s eobj.BDPBaseDMRowId=id
 s eobj.BDPBaseDMCode= pobj.BDPBaseDMCode
 s eobj.BDPBaseDMDesc = pobj.BDPBaseDMDesc 
 s:pobj.BDPBaseDMDateFrom'="" eobj.BDPBaseDMDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.BDPBaseDMDateFrom)
 s:pobj.BDPBaseDMDateTo'="" eobj.BDPBaseDMDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.BDPBaseDMDateTo)
 s:pobj.BDPBaseDMParentDR'="" eobj.BDPBaseDMParentDR=pobj.BDPBaseDMParentDR.%Id() 
 s:pobj.BDPBaseDMTableDR'="" eobj.BDPBaseDMTableDR=pobj.BDPBaseDMTableDR.%Id() 
 s eobj.DPBaseDMType=pobj.DPBaseDMType
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 q str
}

/// Function：对字典或者文本型代码的重复校验
/// Creator： sunfengchao
/// CreatDate: 2020-01-14
/// Table：  BDPBaseDataMap 
/// Input：  id, code
/// Return： "1"(数据重复),"0"(数据不重复)
ClassMethod FormValidate(id As %String, code As %String) As %String
{
 new (id,code,%session)
 s flag="", flagc="", flagd="" 
 s:code'="" flagc=$d(^User.BDPBaseDataMapI("CodeI",code))
 if (id="")&(flagc>0) //如果为空，增加时的重复判断
 {
  if (flagc>0)  s flag=1  //返回重复标志 
  else  s flag=0 //返回不重复标志 
 }
 else //如果不为空，修改时的重复判断
 { 
    s idd=""
    s:code'="" idc=$o(^User.BDPBaseDataMapI("CodeI",code,0))  
    if (code="")
    {
        if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
        else  s flag=0 //返回不重复标志
    } 
 }
 q flag
}

/// Function:实现对基础数据对照-字典维护的修改增加操作
/// Creator:基础数据平台组 孙凤超
/// CreateDate:2013-07-04
/// Desc:通过rowid来修改基础数据对照-字典维护，或者添加基础数据对照-字典维护维护
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: BDPBaseDataMap 
ClassMethod SaveEntity(eobj As web.Entity.CT.BDPBaseDataMap) As %String
{
 new (eobj,%session)
 s $zt="ERROR"
 s result=""
 if $IsObject(eobj)
 { 
  s ValidateFlag=..FormValidate(eobj.BDPBaseDMRowId,eobj.BDPBaseDMCode)
  if (ValidateFlag=1)
  {
      s ErrorInfo="代码重复"
      s result = "{success:'false',errorinfo:'"_ErrorInfo_"'}"    
  }
  else
  {
      s:eobj.BDPBaseDMDateFrom'="" eobj.BDPBaseDMDateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BDPBaseDMDateFrom)   
      s:eobj.BDPBaseDMDateTo'="" eobj.BDPBaseDMDateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BDPBaseDMDateTo)      
      s:eobj.BDPBaseDMDateFrom="" eobj.BDPBaseDMDateFrom=+$h 
      s:eobj.BDPBaseDMParentDR="" eobj.BDPBaseDMParentDR=-10000 
      if (eobj.BDPBaseDMRowId="")       
      {
       s obj=##class(User.BDPBaseDataMap).%New()
      }
      else                           
      {
       s obj=##class(User.BDPBaseDataMap).%OpenId(eobj.BDPBaseDMRowId)
       s bboj=##class(web.Entity.CT.BDPBaseDataMap).%New()
       s bboj.BDPBaseDMRowId=eobj.BDPBaseDMRowId
       s bboj.BDPBaseDMCode = obj.BDPBaseDMCode                    
       s bboj.BDPBaseDMDesc= obj.BDPBaseDMDesc         
       s bboj.BDPBaseDMDateFrom = obj.BDPBaseDMDateFrom 
       s bboj.BDPBaseDMDateTo=obj.BDPBaseDMDateTo
       s:obj.BDPBaseDMParentDR'="" bboj.BDPBaseDMParentDR=obj.BDPBaseDMParentDR.%Id()
       s:obj.BDPBaseDMTableDR'="" bboj.BDPBaseDMTableDR=obj.BDPBaseDMTableDR.%Id() 
      }   
      s obj.BDPBaseDMCode = eobj.BDPBaseDMCode                    
      s obj.BDPBaseDMDesc= eobj.BDPBaseDMDesc                 
      s obj.BDPBaseDMDateFrom = eobj.BDPBaseDMDateFrom 
      s obj.BDPBaseDMDateTo=eobj.BDPBaseDMDateTo  
      d obj.BDPBaseDMParentDRSetObjectId(eobj.BDPBaseDMParentDR)
      d obj.BDPBaseDMTableDRSetObjectId(eobj.BDPBaseDMTableDR)
      s obj.DPBaseDMType=eobj.DPBaseDMType
       Tstart
       s sc=obj.%Save() 
       if $$$ISOK(sc)
       {
        Tcommit
        s id = obj.%Id()  
        s result = "{success:'true',id:'"_id_"'}"        
        d:eobj.BDPBaseDMRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_BaseDataMap ","User.BDPBaseDataMap","基础数据对照-字典维护",eobj.BDPBaseDMRowId,eobj.BDPBaseDMDesc,"U",eobj,bboj)
        d:eobj.BDPBaseDMRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_BaseDataMap ","User.BDPBaseDataMap","基础数据对照-字典维护",id,eobj.BDPBaseDMDesc,"A",eobj)
       }
       else
       {
         Trollback  
         s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    
         s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基础数据对照-字典维护","web.DHCBL.CT.BDPBaseDataMap","SaveEntity",eobj)
         s ^TMPERRORLOGINFO=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
         s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
       } 
  }
 }
 else
 {
   s result = "{success:'false',errorinfo:'对象不存在！'}"
   s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基础数据对照-字典维护","web.DHCBL.CT.BDPBaseDataMap","SaveEntity",eobj)
   s ^ERRORLOGINFO(logid)="对象不存在！"
 } 
 q result
ERROR
 s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基础数据对照-字典维护","web.DHCBL.CT.BDPBaseDataMap","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze
 q "{success:'false',errorinfo:'保存失败！'}"
}

/// Function：查询树形列表
/// Creator： sunfengchao
/// CreatDate: 2018-09-13 
/// Input：  parentcatdr 父节点 
/// Return： treegrid格式数据串
/// Debug:   w ##class(web.DHCBL.CT.BDPBaseDataMap).GetTreeList("","病案")
ClassMethod GetTreeList(parentcatdr As %String, query As %String = "") As %String
{
    new (parentcatdr,query,%session)
    s IDStr=""
    if (parentcatdr="") s parentcatdr=-10000  
    s ^TMPquery=query
    s myJsonStr=""
    s myRowID=0
    s myCount=0
    s mySeq=0
    k myArray
    k a
    //生成索引数组 ^User.BDPBaseDataMapI("BDPParentMenuDrI",1,2)
    s myRowID=0
    s n=0
    for 
    {    
        s myRowID=$o(^User.BDPBaseDataMapI("BDPParentMenuDrI",parentcatdr,myRowID)) 
        q:myRowID="" 
        s myCount=myCount+1
        s myArray(myCount)=myRowID
    }
     
    //输出菜单JSON串
    s myRowID=0
    s mySeq=0
    s childStr=""
    w "["
    s count=0
    for 
    {
        s mySeq=$o(myArray(mySeq)) q:(mySeq="")
        s myRowID=$g(myArray(mySeq))
       
        s BDPBaseDMCode=$lg($g(^User.BDPBaseDataMapD(myRowID)),2)   
        s BDPBaseDMDesc =$lg($g(^User.BDPBaseDataMapD(myRowID)),3)  
        if ($zcvt(BDPBaseDMDesc,"U")[($zcvt(query,"U")))||(query="")
        {
            s count=count+1
            s DPBaseDMType=$lg($g(^User.BDPBaseDataMapD(myRowID)),8) 
            s ParentDr=$O(^User.BDPBaseDataMapI("BDPCodeParentIdx",BDPBaseDMCode,0))  
            if (ParentDr'="")
            {
                s SysCode=$lg($g(^User.BDPBaseDataMapD(ParentDr)),2)   
                s flag= ##class(web.DHCBL.CT.BDPBaseDataMap).GetDataMapFlag(SysCode,BDPBaseDMCode) 
                if (flag=0) s BDPBaseDMDesc="<font color='red'>"_BDPBaseDMDesc_"</font>"  
            } 
            if count>1 w ","
            w "{""id"":"""_myRowID_""",""text"":"""_BDPBaseDMDesc_""",""DPBaseDMType"":"""_DPBaseDMType_"""" 
            s actMenuBDP=""  
            s childStr=..GetChildOrderedIDStr(myRowID)
            if childStr'=""
            {
                w ",""state"":""open"""
                w ",""children"":"
                w ..GetTreeList(myRowID)  
            }
            else
            {
                w ",""state"":""open"""
            }
            w "}"  
        }
     }
    w "]" 
    q ""
}

/// Function：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Creator： sunfengchao
/// CreatDate: 2018-10-13 
/// Table：   BDPBaseDataMap
/// Input：   LastLevel
/// Return： 所有子节点 用^连接
/// w ##class(web.DHCBL.CT.BDPBaseDataMap).GetChildOrderedIDStr("")
ClassMethod GetChildOrderedIDStr(LastLevel As %String) As %String
{
    new (LastLevel,%session)
    s IDStr=""
    if (LastLevel="") s LastLevel=-10000
    s myCount=0
    k myArray 
    //生成菜单索引数组
    s myRowID=0 
    for
    {
        s myRowID=$o(^User.BDPBaseDataMapI("BDPParentMenuDrI",LastLevel,myRowID)) 
        q:myRowID=""  
        s myCount=myCount+1
        s myArray(myCount)=myRowID 
    }
    //输出菜单JSON串
    s myRowID=0
    s mySeq=0
    s childStr=""
    for 
    {
        s mySeq=$o(myArray(mySeq)) 
        q:(mySeq="")
        s myRowID=$g(myArray(mySeq)) 
        s childStr=..GetChildOrderedIDStr(myRowID)
        if childStr'="" s childStr=myRowID_"^"_childStr
        if childStr="" s childStr=myRowID
        
        if IDStr="" s IDStr=childStr
        else  s IDStr=IDStr_"^"_childStr
    }
    q IDStr
}

/// Function：查询 所属目录 的树形列表,  
/// Creator： sunfengchao
/// CreatDate: 2018-10-26 
/// Input：  parentcatdr 父节点 
/// Return： treegrid格式数据串
/// Debug:   w ##class(web.DHCBL.CT.BDPBaseDataMap).GetComboTreeList("")
ClassMethod GetComboTreeList(parentcatdr As %String, query As %String = "") As %String
{
    new (parentcatdr,query,%session)
    s IDStr=""
    if (parentcatdr="") s parentcatdr=-10000
    
    s myJsonStr=""
    s myRowID=0
    s myCount=0
    s mySeq=0
    k myArray
    k a
    //生成索引数组
    s myRowID=0
    s n=0
    for 
    {
        s myRowID=$o(^User.BDPBaseDataMapI("BDPParentMenuDrI",parentcatdr,myRowID))    
        q:myRowID=""
      
        s myCount=myCount+1
        s myArray(myCount)=myRowID
    }
     
    //输出菜单JSON串
    s myRowID=0
    s mySeq=0
    s childStr=""
    w "["
    s count=0
    for 
    {
        s mySeq=$o(myArray(mySeq)) 
        q:(mySeq="")
        s myRowID=$g(myArray(mySeq))
        s count=count+1
        s BDPBaseDMCode=$lg($g(^User.BDPBaseDataMapD(myRowID)),2)   
        s BDPBaseDMDesc =$lg($g(^User.BDPBaseDataMapD(myRowID)),3) 
        if ($zcvt(BDPBaseDMCode,"U")[($zcvt(query,"U")))||(query="")||($zcvt(BDPBaseDMDesc,"U")[($zcvt(query,"U")))
        {
            if count>1 w ","
            w "{""id"":"""_myRowID_""",""text"":"""_BDPBaseDMDesc_"""" 
            s actMenuBDP=""  
            s childStr=..GetChildOrderedIDStr(myRowID)
            if childStr'=""
            {
                w ",""state"":""open"""
                w ",""children"":"
                w ..GetComboTreeList(myRowID)  
            }
            else
            {
                w ",""state"":""open"""
            }
            w "}"   
        }
       
     }
     w "]"
     q ""
}

/// Function:查找目录所在层级
/// Creator:sunfengchao
/// CreateDate:2018-08-30
/// Debug:  w ##class(web.DHCBL.CT.BDPBaseDataMap).GetMenuDR(6)
ClassMethod GetMenuDR(dictorydr As %String) As %String
{
   new (dictorydr,%session)
   quit:dictorydr="" ""
   s result=""
   s parentdr=-10000
   for
   {
       s parentdr=$O(^User.BDPBaseDataMapI("BDPParentMenuDrI",parentdr))  // ^User.BDPBaseDataMapI("BDPParentMenuDrI",1,2)
       q:parentdr=""
       s ID=0
       for
       {
           s ID= $O(^User.BDPBaseDataMapI("BDPParentMenuDrI",parentdr,ID)) 
           q:ID=""
           if (ID=dictorydr)
           {
                s result=parentdr
           }
       }
   } 
   q result
}

/// Function:判断左侧字典目录是否可以新增右侧列表里的数据
/// Creator: sunfengchao
/// CreateDate:2018-09-17
/// Debug:  w ##class(web.DHCBL.CT.BDPBaseDataMap).AllowAddDataFlag()
ClassMethod AllowAddDataFlag(id As %String) As %String
{
    if id="" q ""
    s result=""
    if ($d(^User.BDPBaseDataMapI("BDPParentMenuDrI",id))) 
    {
        s result=1  ///不允许新增 右侧的数据
    }
    else
    {   
        s result=0
    }
    q result
}

/// Function:实现删除操作
/// Creator: sunfengchao
/// CreateDate:2013-07-04 
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:  BDPBaseDataMap 
/// Others:d ##class(web.DHCBL.CT.BDPBaseDataMap).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
  new (id,%session)
  s result=""  
  s pobj = ##class(User.BDPBaseDataMap).%OpenId(id)
  if (pobj)
  { 
      s eobj = ##class(web.Entity.CT.BDPBaseDataMap).%New()
      s eobj.BDPBaseDMRowId=id
      s eobj.BDPBaseDMCode= pobj.BDPBaseDMCode
      s eobj.BDPBaseDMDesc = pobj.BDPBaseDMDesc 
      s:pobj.BDPBaseDMDateFrom'="" eobj.BDPBaseDMDateFrom = ##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.BDPBaseDMDateFrom)
      s:pobj.BDPBaseDMDateTo'="" eobj.BDPBaseDMDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(pobj.BDPBaseDMDateTo)
      s:pobj.BDPBaseDMParentDR'="" eobj.BDPBaseDMParentDR=pobj.BDPBaseDMParentDR.%Id()
      s:pobj.BDPBaseDMTableDR'="" eobj.BDPBaseDMTableDR=pobj.BDPBaseDMTableDR.%Id() 
      s eobj.DPBaseDMType=pobj.DPBaseDMType
      Tstart
      s sc=##class(User.BDPBaseDataMap).%DeleteId(id)
      if $$$ISOK(sc)
      { 
        d ##class(web.DHCBL.CT.BDPBaseDataMap).DeleteDeatilAll(id)
        Tcommit
        s result="{success:'true',info:'删除成功！'}"
        d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_BaseDataMap","User.BDPBaseDataMap","基础数据对照-字典维护",id,eobj.BDPBaseDMDesc,"D",eobj)
        d eobj.%Close()
      }
      else
      {
          Trollback
          s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
          s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基础数据对照-字典维护","web.DHCBL.CT.BDPBaseDataMap","DeleteData",eobj)
          s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
      }
  }
  q result
}

/// Function:删除目录时同时删除对应的数据 包含删除一级目录,把下面的子目录及对应表数据删除
/// Creator: sunfengchao
/// CreateDate:2020-02-13
/// Debug:  w ##class(web.DHCBL.CT.BDPBaseDataMap).DeleteDeatilAll()
ClassMethod DeleteDeatilAll(ParentId As %String) As %String
{
    if ParentId="" q 0 
    if ($d(^User.BDPBaseDataMapI("BDPParentMenuDrI",ParentId)))  /// 是上级目录 需要把下面的目录及表数据都删除
    { 
        s SubParentID=0
        for
        {
            s SubParentID=$O(^User.BDPBaseDataMapI("BDPParentMenuDrI",ParentId,SubParentID))
            q:SubParentID=""  
            d ..DeleteData(SubParentID)  
            if ($d(^User.BDPBaseDataMapDetailI("BaseTabNameDRIdx",SubParentID))) 
            { 
                s id=0
                for
                {
                    s id=$O(^User.BDPBaseDataMapDetailI("BaseTabNameDRIdx",SubParentID,id))
                    q:id=""   
                    d ##class(web.DHCBL.CT.BDPBaseDataMapDetail).DeleteData(id)  
                }
            } 
        }  
    }
    else
    { 
        /// 字典 ,  需要删除对应 表数据
        if ($d(^User.BDPBaseDataMapDetailI("BaseTabNameDRIdx",ParentId))) 
        { 
            s id=0
            for
            {
                s id=$O(^User.BDPBaseDataMapDetailI("BaseTabNameDRIdx",ParentId,id))
                q:id="" 
                d ##class(web.DHCBL.CT.BDPBaseDataMapDetail).DeleteData(id)   
            } 
        } 
    }
    q 1
}

/// Function:返回 左侧字典数据
/// Creator: sunfengchao
/// CreateDate:2022-10-14
/// OutPut:   
/// w ##class(web.DHCBL.CT.BDPBaseDataMap).GetMapData("20")
ClassMethod GetMapData(nodeid As %String) As %String
{
    new (nodeid,%session)
    q:nodeid="" ""
    s BDPBaseDMCode=$lg($g(^User.BDPBaseDataMapD(nodeid)),2) 
    s BDPBaseDMDesc =$lg($g(^User.BDPBaseDataMapD(nodeid)),3) 
    s BDPBaseDMTableDR=$lg($g(^User.BDPBaseDataMapD(nodeid)),7) 
    s BDPBaseDMType=$lg($g(^User.BDPBaseDataMapD(nodeid)),8)  
    s result=BDPBaseDMCode_"^"_BDPBaseDMDesc_"^"_BDPBaseDMType_"^"_BDPBaseDMTableDR
    q result
}

/// Function:判断左侧字典是否存在右侧的对照数据
/// Creator: sunfengchao
/// CreateDate:2022-10-13
/// OutPut:  1 对照 0 未对照
/// w ##class(web.DHCBL.CT.BDPBaseDataMap).GetIfDataMap("20")
ClassMethod GetIfDataMap(nodeid As %String) As %String
{
 
  new (nodeid,%session)
  s return=0
  q:nodeid="" return 
  s TableCode =$lg($g(^User.BDPBaseDataMapD(nodeid)),2)  
  q:TableCode="" return
  s ParentDr=$O(^User.BDPBaseDataMapI("BDPCodeParentIdx",TableCode,0))   
  q:ParentDr="" return
  s SystemCode=$lg($g(^User.BDPBaseDataMapD(ParentDr)),2) 
  q:SystemCode="" return
  s VFlag=$d(^User.BDPBaseDataMapDetailI("BDPMapDTableCodeIdx",SystemCode,TableCode))  
  if VFlag=0 s return=0
  else  s return=1 
  q return
}

}
