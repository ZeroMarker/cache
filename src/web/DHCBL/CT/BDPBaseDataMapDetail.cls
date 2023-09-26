/// Function:数据对照详情表
/// CreateDate:2020-01-03
/// Creator: sunfengchao
Class web.DHCBL.CT.BDPBaseDataMapDetail Extends %RegisteredObject
{

/// Function: 查询对照详情 
/// CreateDate:2019-05-21
/// Creator: sunfengchao
/// Tables:  BDPBaseDataMapDetail 
/// Input:   NodeId:所属字典
/// Output:  BDPMapDRowId  BDPMapDBaseTabNameDR   BDPMapDHisDicCode    BDPMapDHisDicDesc   BDPMapDExtDicCode   BDPMapDExtDicDesc   BDPMapDActive  BDPMapDDateFrom   BDPMapDExtDicDateTo  BDPMapDHisFlag 
/// Others:  d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPBaseDataMapDetail", "GetList","1","","","","","")
Query GetList(NodeId As %String, rowid As %String, HisCode As %String, HisDesc As %String, ExtCode As %String, ExtDesc As %String) As %Query(ROWSPEC = "BDPMapDRowId,BDPBaseDMCode,BDPBaseDMDesc,BDPMapDTableCode,BDPMapDBaseTabNameDR,BDPMapDHisDicCode,BDPMapDHisDicDesc,BDPMapDExtDicCode,BDPMapDExtDicDesc,BDPMapDActive,BDPMapDHisFlag")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, NodeId As %String, rowid As %String, HisCode As %String, HisDesc As %String, ExtCode As %String, ExtDesc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1  
 if (NodeId'="")  
 {
    // BDPMapDRowId  BDPMapDBaseTabNameDR   BDPMapDHisDicCode    BDPMapDHisDicDesc   BDPMapDExtDicCode   BDPMapDExtDicDesc   BDPMapDActive  BDPMapDDateFrom   BDPMapDExtDicDateTo  BDPMapDHisFlag 
    if (rowid'="")
    {  
        s BDPMapDBaseTabNameDR=NodeId 
        s BDPBaseDMDesc =$lg($g(^User.BDPBaseDataMapD(NodeId)),3) 
        s BDPBaseDMParentDR = $lg($g(^User.BDPBaseDataMapD(NodeId)),4)
        if (BDPBaseDMParentDR'="")||(BDPBaseDMParentDR'=-10000) s BDPBaseDMCode= $lg($g(^User.BDPBaseDataMapD(BDPBaseDMParentDR)),3)
        s BDPMapDRowId=rowid
        s BDPMapDTableCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),11) // 字典表或者文本字段的 代码
        s BDPMapDHisDicCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),3)
        s BDPMapDHisDicDesc=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),4)
        s BDPMapDExtDicCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),5)
        s BDPMapDExtDicDesc=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),6)   
        s BDPMapDHisFlag=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),9) 
        s BDPMapDActive=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),10) 
    }
    else
    { 
        s BDPMapDRowId=0
        for
        {
            s BDPMapDRowId=$O(^User.BDPBaseDataMapDetailI("BaseTabNameDRIdx",NodeId,BDPMapDRowId)) 
            q:BDPMapDRowId=""  
            s BDPMapDBaseTabNameDR=NodeId  
            s BDPBaseDMDesc =$lg($g(^User.BDPBaseDataMapD(NodeId)),3) 
            s BDPBaseDMParentDR = $lg($g(^User.BDPBaseDataMapD(NodeId)),4)
            if (BDPBaseDMParentDR'="")||(BDPBaseDMParentDR'=-10000) s BDPBaseDMCode= $lg($g(^User.BDPBaseDataMapD(BDPBaseDMParentDR)),3)
            s BDPMapDTableCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),11) // 字典表或者文本字段的 代码
            s BDPMapDHisDicCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),3)
            s BDPMapDHisDicDesc=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),4)
            s BDPMapDExtDicCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),5)
            s BDPMapDExtDicDesc=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),6) 
            s BDPMapDHisFlag=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),9) 
            s BDPMapDActive=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),10) 
            if ((BDPMapDHisDicCode[HisCode)||(HisCode=""))&((BDPMapDHisDicDesc[HisDesc)||(HisDesc=""))&((BDPMapDExtDicCode[ExtCode)||(ExtCode=""))&((BDPMapDExtDicDesc[ExtDesc)||(ExtDesc=""))
            { 
                d OutputRow
            }
        }
    } 
 }
 else
 {   
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK 
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(BDPMapDRowId,BDPBaseDMCode,BDPBaseDMDesc,BDPMapDTableCode,BDPMapDBaseTabNameDR,BDPMapDHisDicCode,BDPMapDHisDicDesc,BDPMapDExtDicCode,BDPMapDExtDicDesc,BDPMapDActive,BDPMapDHisFlag)
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

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetList(NodeId As %String, rowid As %String, HisCode As %String, HisDesc As %String, ExtCode As %String, ExtDesc As %String, start As %String, limit As %String) As %Status
{
 if (NodeId'="")  
 {
    // BDPMapDRowId  BDPMapDBaseTabNameDR   BDPMapDHisDicCode    BDPMapDHisDicDesc   BDPMapDExtDicCode   BDPMapDExtDicDesc   BDPMapDActive  BDPMapDDateFrom   BDPMapDExtDicDateTo  BDPMapDHisFlag 
    if (rowid'="")
    {  
        s BDPMapDBaseTabNameDR=NodeId 
        s BDPBaseDMDesc =$lg($g(^User.BDPBaseDataMapD(NodeId)),3) 
        s BDPBaseDMParentDR = $lg($g(^User.BDPBaseDataMapD(NodeId)),4)
        if (BDPBaseDMParentDR'="")||(BDPBaseDMParentDR'=-10000) s BDPBaseDMCode= $lg($g(^User.BDPBaseDataMapD(BDPBaseDMParentDR)),3)
        s BDPMapDRowId=rowid
        s BDPMapDTableCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),11) // 字典表或者文本字段的 代码
        s BDPMapDHisDicCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),3)
        s BDPMapDHisDicDesc=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),4)
        s BDPMapDExtDicCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),5)
        s BDPMapDExtDicDesc=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),6)   
        s BDPMapDHisFlag=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),9) 
        s BDPMapDActive=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),10)
        s count=1
        w "{""BDPMapDRowId"":"""_BDPMapDRowId_""",""BDPMapDTableCode"":"""_BDPMapDTableCode_""",""BDPMapDHisDicCode"":"""_BDPMapDHisDicCode_""",""BDPMapDHisDicDesc"":"""_BDPMapDHisDicDesc_""",""BDPMapDExtDicCode"":"""_BDPMapDExtDicDesc_""",""BDPMapDExtDicDesc"":"""_BDPMapDHisDicDesc_""",""BDPMapDHisFlag"":"""_BDPMapDHisFlag_""",""BDPMapDActive"":"""_BDPMapDActive_"""}"  
        w "],total:"_count_"}"
    }
    else
    { 
        if start="" s start=0
        if limit="" s limit=20
        s start=start+1
        s BDPMapDRowId=0
        for
        {
            s BDPMapDRowId=$O(^User.BDPBaseDataMapDetailI("BaseTabNameDRIdx",NodeId,BDPMapDRowId)) 
            q:BDPMapDRowId=""  
            s BDPMapDBaseTabNameDR=NodeId  
            s BDPBaseDMDesc =$lg($g(^User.BDPBaseDataMapD(NodeId)),3) 
            s BDPBaseDMParentDR = $lg($g(^User.BDPBaseDataMapD(NodeId)),4)
            if (BDPBaseDMParentDR'="")||(BDPBaseDMParentDR'=-10000) s BDPBaseDMCode= $lg($g(^User.BDPBaseDataMapD(BDPBaseDMParentDR)),3)
            s BDPMapDTableCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),11) // 字典表或者文本字段的 代码
            s BDPMapDHisDicCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),3)
            s BDPMapDHisDicDesc=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),4)
            s BDPMapDExtDicCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),5)
            s BDPMapDExtDicDesc=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),6) 
            s BDPMapDHisFlag=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),9) 
            s BDPMapDActive=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),10) 
            if ((BDPMapDHisDicCode[HisCode)||(HisCode=""))&((BDPMapDHisDicDesc[HisDesc)||(HisDesc=""))&((BDPMapDExtDicCode[ExtCode)||(ExtCode=""))&((BDPMapDExtDicDesc[ExtDesc)||(ExtDesc=""))
            { 
               s count=count+1
               if (count<start) continue
               if (count<(start+limit))
               {
                    if ((count#limit)=1)
                    {
                       w "{""BDPMapDRowId"":"""_BDPMapDRowId_""",""BDPMapDTableCode"":"""_BDPMapDTableCode_""",""BDPMapDHisDicCode"":"""_BDPMapDHisDicCode_""",""BDPMapDHisDicDesc"":"""_BDPMapDHisDicDesc_""",""BDPMapDExtDicCode"":"""_BDPMapDExtDicDesc_""",""BDPMapDExtDicDesc"":"""_BDPMapDHisDicDesc_""",""BDPMapDHisFlag"":"""_BDPMapDHisFlag_""",""BDPMapDActive"":"""_BDPMapDActive_"""}"  
                    }
                    else
                    {
                       w ",{""BDPMapDRowId"":"""_BDPMapDRowId_""",""BDPMapDTableCode"":"""_BDPMapDTableCode_""",""BDPMapDHisDicCode"":"""_BDPMapDHisDicCode_""",""BDPMapDHisDicDesc"":"""_BDPMapDHisDicDesc_""",""BDPMapDExtDicCode"":"""_BDPMapDExtDicDesc_""",""BDPMapDExtDicDesc"":"""_BDPMapDHisDicDesc_""",""BDPMapDHisFlag"":"""_BDPMapDHisFlag_""",""BDPMapDActive"":"""_BDPMapDActive_"""}"  
                    }  
               }
            }
            
        }
       w "],total:"_count_"}"
    }  
 }
}

/// Function: 修改时显示信息
/// Creator:  sunfengchao
/// CreateDate:2019-01-04 
/// Input:    id
/// Tables:   BDP_BaseDataMapDetail 
/// Others:   w ##class(web.DHCBL.CT.BDPBaseDataMapDetail).OpenData(14)
ClassMethod OpenData(id As %String) As %String
{
 s str=""
 s pobj = ##class(User.BDPBaseDataMapDetail).%OpenId(id)
 s eobj = ##class(web.Entity.CT.BDPBaseDataMapDetail).%New() 
 s eobj.BDPMapDRowId=id
 s:pobj.BDPMapDBaseTabNameDR'="" eobj.BDPMapDBaseTabNameDR= pobj.BDPMapDBaseTabNameDR.%Id()
 s eobj.BDPMapDHisDicCode=pobj.BDPMapDHisDicCode
 s eobj.BDPMapDHisDicDesc=pobj.BDPMapDHisDicDesc
 s eobj.BDPMapDExtDicCode=pobj.BDPMapDExtDicCode
 s eobj.BDPMapDExtDicDesc=pobj.BDPMapDExtDicDesc  
 s eobj.BDPMapDActive=pobj.BDPMapDActive
 s eobj.BDPMapDHisFlag=pobj.BDPMapDHisFlag 
 d pobj.%Close()
 k pobj
 s str = eobj.JsonS()
 q str
}

/// Function:实现删除操作
/// Creator: sunfengchao
/// CreateDate:2013-07-04 
/// Output:success:'true',info:'删除成功！ 失败时输出删除成功！
/// Tables:  BDP_BaseDataMapDetail 
/// Others:  w ##class(web.DHCBL.CT.BDPBaseDataMapDetail).DeleteData("1")
ClassMethod DeleteData(id As %String) As %String
{
  s result="" 
  Tstart
  s pobj = ##class(User.BDPBaseDataMapDetail).%OpenId(id)
  s eobj = ##class(web.Entity.CT.BDPBaseDataMapDetail).%New()
  
  s:pobj.BDPMapDBaseTabNameDR'="" eobj.BDPMapDBaseTabNameDR= pobj.BDPMapDBaseTabNameDR.%Id()
  s eobj.BDPMapDHisDicCode=pobj.BDPMapDHisDicCode
  s eobj.BDPMapDHisDicDesc=pobj.BDPMapDHisDicDesc
  s eobj.BDPMapDExtDicCode=pobj.BDPMapDExtDicCode
  s eobj.BDPMapDExtDicDesc=pobj.BDPMapDExtDicDesc
  s eobj.BDPMapDHisFlag=pobj.BDPMapDHisFlag   
  s sc=##class(User.BDPBaseDataMapDetail).%DeleteId(id)
  if $$$ISOK(sc)
  {
    Tc
    s result="{success:'true',info:'删除成功！'}"
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_BaseDataMapDetail","User.BDPBaseDataMapDetail","基础数据对照",id,eobj.BDPMapDHisDicDesc,"D",eobj)
    d eobj.%Close()
  }
  else
  {
      Trollback
      s result= "{success:'false',info:'"_$system.OBJ.DisplayError(sc)_"'}"  
      s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基础数据对照","web.DHCBL.CT.BDPBaseDataMapDetail","DeleteData",eobj)
      s ^ERRORLOGINFO(logid)=$system.OBJ.DisplayError(sc)
  }
    q result
}

/// Creator：孙凤超
/// CreatDate: 2013-07-04
/// Description：数据重复校验
/// Table：BDP_BaseDataMapDetail 
/// Input：id, code, desc
/// Return："1"(数据重复),"0"(数据不重复)
/// Debug:  w ##class(web.DHCBL.CT.BDPBaseDataMapDetail).FormValidate("","01","045","A09.007","")
ClassMethod FormValidate(id As %String, SystemCode As %String, TableCode As %String, code As %String, desc As %String) As %String
{
 s flag=""
 s flagc=""
 s flagd=""  
 q:(SystemCode="")||(TableCode="") 1
 s:code'="" flagc=$d(^User.BDPBaseDataMapDetailI("HisCodeIdx",SystemCode,TableCode,code))
 s:desc'="" flagd=$d(^User.BDPBaseDataMapDetailI("HisDescIdx",SystemCode,TableCode,desc))  
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
  s:code'="" idc=$o(^User.BDPBaseDataMapDetailI("HisCodeIdx",SystemCode,TableCode,code,0))
  s:desc'="" idd=$o(^User.BDPBaseDataMapDetailI("HisDescIdx",SystemCode,TableCode,desc,0))
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
    if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1 //返回重复标志
    else  s flag=0 //返回不重复标志
   }
  }
 }
 q flag
}

/// Function:修改增加操作
/// Creator: sunfengchao
/// CreateDate:2020-01-14
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: BDP_BaseDataMapDetail 
ClassMethod SaveEntity(eobj As web.Entity.CT.BDPBaseDataMapDetail) As %String
{
  s result="" 
  ; s ^TMP11=eobj.BDPMapDRowId_"^"_eobj.BDPMapDHisDicCode_"^"_eobj.BDPMapDHisDicDesc_"^"_eobj.BDPMapDExtDicCode_"^"_eobj.BDPMapDExtDicDesc_"^"_eobj.BDPMapDActive_"^"_eobj.BDPMapDHisFlag
  s:eobj.BDPMapDActive="" eobj.BDPMapDActive="N"
  s:eobj.BDPMapDHisFlag="" eobj.BDPMapDHisFlag="N"
  s:eobj.BDPMapDSystemCode'="" eobj.BDPMapDRowId=$o(^User.BDPBaseDataMapDetailI("HisCodeIdx",eobj.BDPMapDSystemCode,eobj.BDPMapDTableCode,eobj.BDPMapDHisDicCode,0)) // 用于数据导入时 
  if (eobj.BDPMapDRowId="")       
  {
    s obj=##class(User.BDPBaseDataMapDetail).%New()
  }
  else                           
  {
      s obj=##class(User.BDPBaseDataMapDetail).%OpenId(eobj.BDPMapDRowId)
      s bboj=##class(web.Entity.CT.BDPBaseDataMapDetail).%New()
      s bboj.BDPMapDRowId=eobj.BDPMapDRowId 
      s:obj.BDPMapDBaseTabNameDR'="" bboj.BDPMapDBaseTabNameDR= obj.BDPMapDBaseTabNameDR.%Id()
      s bboj.BDPMapDHisDicCode=obj.BDPMapDHisDicCode
      s bboj.BDPMapDHisDicDesc=obj.BDPMapDHisDicDesc
      s bboj.BDPMapDExtDicCode=obj.BDPMapDExtDicCode
      s bboj.BDPMapDExtDicDesc=obj.BDPMapDExtDicDesc 
      s bboj.BDPMapDActive=obj.BDPMapDActive
      s bboj.BDPMapDHisFlag=obj.BDPMapDHisFlag 
      s bboj.BDPMapDTableCode=obj.BDPMapDTableCode 
  } 
  s BDPMapDTableCode=""
  s BDPMapParentDR=""
  s BDPMapDSystemCode=""  /// 所属系统
  s BMObj=##class(User.BDPBaseDataMap).%OpenId(eobj.BDPMapDBaseTabNameDR)
  if ($ISOBJECT(BMObj))
  {
      s BDPMapDTableCode =BMObj.BDPBaseDMCode  
      s BDPMapParentDR= ##class(web.DHCBL.CT.BDPBaseDataMap).GetMenuDR(eobj.BDPMapDBaseTabNameDR)
      s:BDPMapParentDR'="" BDPMapDSystemCode=$lg($g(^User.BDPBaseDataMapD(BDPMapParentDR)),2)   
  }
  q:(BDPMapDSystemCode="")||(BDPMapDTableCode="") "{success:'false',errorinfo:'所属系统或字典或者文本的代码为空'}" 
  s VFlag=..FormValidate(eobj.BDPMapDRowId,BDPMapDSystemCode,BDPMapDTableCode,eobj.BDPMapDHisDicCode,eobj.BDPMapDHisDicDesc)
  if (VFlag=1)
  {
    s Error="该数据已经对照"
    s result = "{success:'false',errorinfo:'"_Error_"'}"    
  }
  else
  { 
      d obj.BDPMapDBaseTabNameDRSetObjectId(eobj.BDPMapDBaseTabNameDR)  
      s obj.BDPMapDSystemCode=BDPMapDSystemCode
      s obj.BDPMapDTableCode=BDPMapDTableCode // 字典或 文本 code 
      s obj.BDPMapDHisDicCode=eobj.BDPMapDHisDicCode
      s obj.BDPMapDHisDicDesc=eobj.BDPMapDHisDicDesc
      s obj.BDPMapDExtDicCode=eobj.BDPMapDExtDicCode
      s obj.BDPMapDExtDicDesc=eobj.BDPMapDExtDicDesc  
      s obj.BDPMapDActive=eobj.BDPMapDActive 
      s obj.BDPMapDHisFlag=eobj.BDPMapDHisFlag 
       
      Tstart
      s sc=  obj.%Save()  
      if $$$ISOK(sc)
      {
        Tcommit
        s id = obj.%Id() 
        s result = "{success:'true',id:'"_id_"'}"       
        d:eobj.BDPMapDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_BaseDataMapDetail ","User.BDPBaseDataMapDetail","基础数据对照",eobj.BDPMapDRowId,eobj.BDPMapDHisDicDesc,"U",eobj,bboj)
        d:eobj.BDPMapDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_BaseDataMapDetail","User.BDPBaseDataMapDetail","基础数据对照",id,eobj.BDPMapDHisDicDesc,"A",eobj)
       }
       else
       {  
         Trollback
         s result = "{success:'false',errorinfo:'"_$system.OBJ.DisplayError(sc)_"'}"    
         s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基础数据对照","web.DHCBL.CT.BDPBaseDataMapDetail","SaveEntity",eobj)
         s ^TMPERRORLOGINFO=$system.OBJ.DisplayError(sc)
         s ^ERRORLOGINFO(logid)=$system.OBJ.DisplayError(sc)
       } 
  }  
  q result
}

/// Function:   生成数据模板
/// Creator:    sunfengchao
/// CreateDate: 2017-6-6   
/// Debug:      w ##class(web.DHCBL.CT.BDPBaseDataMapDetail).ProductTemplate("a","8")
ClassMethod ProductTemplate(ExcelName, p1)
{
    //New rs,File
   // New pcount Set pcount=$zutil(141)-3
    k BDPDICTEXT
    s ColumnList= ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetColumnName(p1)
    s ColumnLen = $Length(ColumnList,"^")
    s BDPDICTEXT(1)="所属系统"
    s BDPDICTEXT(2)="表名称"
    s BDPDICTEXT(3)="HIS代码"
    s BDPDICTEXT(4)="HIS名称"
    s BDPDICTEXT(5)="外部代码"
    s BDPDICTEXT(6)="外部名称"
    s BDPDICTEXT(7)="开始日期"
    s BDPDICTEXT(8)="结束日期"
    s BDPDICTEXT(9)="外部到HIS对照(Y/N)"
    s BDPDICTEXT(10)="有效标志(Y/N)" 
    Set excelDir = "\temp\excel\"
    if ($p(ExcelName,".",$l(ExcelName,"."))="csv") {    
    }else{
        Set ExcelName = ExcelName_".csv"
    }
    Set PhyDir = ##class(ext.util.String).GetPhysicalPath("",excelDir)
    if ('##class(%File).DirectoryExists(PhyDir)){
        d ##class(%File).CreateDirectory(PhyDir)
    }
    Set File = ##class(%File).%New(PhyDir_ExcelName)
    do File.Open("NWRS") 
    
    For i=1:1:10
    {
        d File.Write(BDPDICTEXT(i)_",")                 
    }  
    Do File.Flush()
    Do File.%Save()
    Do File.Close()
    Set File=""
    Set rs =""
    Quit "dhc.bdp.bdp.fileload.csp?act=download&filename="_ExcelName_"&dirname="_PhyDir
}

/// Function: 通用字典数据导入程序
/// Creator:  sunfengchao
/// CreateDate:2018-09-10 
/// Debug      w ##class(web.DHCBL.CT.BDPBaseDataMapDetail).ImportExcel(^TMP("dataStr"))  
ClassMethod ImportExcel(dataStr As %String) As %String
{
    s ^TMP("dataStr")=dataStr
    q:dataStr="" ""
    s result =0  
    s flag=0         
    s len=$length(dataStr,"#")
    s BDPMapDBaseTabNameDR =$p(dataStr,"#",2) //字典
    s BDPMapDBaseTabNameDR=$O(^User.BDPBaseDataMapI("DescI",BDPMapDBaseTabNameDR,0))  
    s BDPMapDHisDicCode =$p(dataStr,"#",3)  
    s BDPMapDHisDicDesc=$p(dataStr,"#",4)   
    s BDPMapDExtDicCode =$p(dataStr,"#",5)  
    s BDPMapDExtDicDesc=$p(dataStr,"#",6)   
    s BDPMapDActive =$p(dataStr,"#",7)  
    s BDPMapDHisFlag=$p(dataStr,"#",8)   
    s bboj=##class(web.Entity.CT.BDPBaseDataMapDetail).%New()
    s bboj.BDPMapDBaseTabNameDR= BDPMapDBaseTabNameDR
    s bboj.BDPMapDHisDicCode=BDPMapDHisDicCode
    s bboj.BDPMapDHisDicDesc=BDPMapDHisDicDesc
    s bboj.BDPMapDExtDicCode=BDPMapDExtDicCode
    s bboj.BDPMapDExtDicDesc=BDPMapDExtDicDesc  
    s bboj.BDPMapDActive=BDPMapDActive
    s bboj.BDPMapDHisFlag=BDPMapDHisFlag  
    TSTART
    s sc=..SaveEntity(bboj)
    if (sc["true")
    {
       TCOMMIT 
       s result=result_"^"_1
       s result = "{success:'true',info:'成功！'}" 
   }
   else
   {
        TROLLBACK 
        s result=result_"^"_0
        s result = "{success:'false',errorinfo:'失败！'}" 
  }  
  q result
}

/// Function:修改增加操作
/// Creator: sunfengchao
/// CreateDate:2020-01-14
/// Output: success:'true',info:'添加成功！' 失败时输出添加失败！
///         success:'false',info:'修改成功' 失败时输出修改失败！
/// Tables: BDP_BaseDataMapDetail 
ClassMethod ImportEntity(eobj As web.Entity.CT.BDPBaseDataMapDetail) As %String
{
  s result="" 
   s ^TMP11=eobj.BDPMapDRowId_"^"_eobj.BDPMapDHisDicCode_"^"_eobj.BDPMapDHisDicDesc_"^"_eobj.BDPMapDExtDicCode_"^"_eobj.BDPMapDExtDicDesc_"^"_eobj.BDPMapDActive_"^"_eobj.BDPMapDHisFlag
  s:eobj.BDPMapDActive="" eobj.BDPMapDActive="N"
  s:eobj.BDPMapDHisFlag="" eobj.BDPMapDHisFlag="N"
  if (eobj.BDPMapDRowId="")       
  {
    s obj=##class(User.BDPBaseDataMapDetail).%New()
  }
  else                           
  {
      s obj=##class(User.BDPBaseDataMapDetail).%OpenId(eobj.BDPMapDRowId)
      s bboj=##class(web.Entity.CT.BDPBaseDataMapDetail).%New()
      s bboj.BDPMapDRowId=eobj.BDPMapDRowId 
      s:obj.BDPMapDBaseTabNameDR'="" bboj.BDPMapDBaseTabNameDR= obj.BDPMapDBaseTabNameDR.%Id()
      s bboj.BDPMapDHisDicCode=obj.BDPMapDHisDicCode
      s bboj.BDPMapDHisDicDesc=obj.BDPMapDHisDicDesc
      s bboj.BDPMapDExtDicCode=obj.BDPMapDExtDicCode
      s bboj.BDPMapDExtDicDesc=obj.BDPMapDExtDicDesc 
      s bboj.BDPMapDActive=obj.BDPMapDActive
      s bboj.BDPMapDHisFlag=obj.BDPMapDHisFlag 
      s bboj.BDPMapDTableCode=obj.BDPMapDTableCode 
  } 
 
  
  q:(eobj.BDPMapDSystemCode="")||(eobj.BDPMapDTableCode="") "{success:'false',errorinfo:'所属系统或字典、文本的代码为空'}" 
  s TableDR=""
  s TableDR=$O(^User.BDPBaseDataMapI("CodeI",eobj.BDPMapDTableCode,0)) /// 根据 表名找id
  q:TableDR="" "{success:'false',errorinfo:'所属字典、文本不存在'}" 
  s BDPTableCode=$lg((^User.BDPBaseDataMapD(TableDR)),2)
  s SystemDR=""
  s SystemDR=$O(^User.BDPBaseDataMapI("CodeI",eobj.BDPMapDSystemCode,0)) 
  q:SystemDR="" "{success:'false',errorinfo:'所属系统不存在'}" 
  s BDPMapDSystemCode=$lg(^User.BDPBaseDataMapD(SystemDR),2) 
 
  s VFlag=..FormValidate(eobj.BDPMapDRowId,BDPTableCode,BDPMapDSystemCode,eobj.BDPMapDHisDicCode,eobj.BDPMapDHisDicDesc)
  if (VFlag=1)
  {
    s Error="该数据已经对照"
    s result = "{success:'false',errorinfo:'"_Error_"'}"    
  }
  else
  { 
      s eobj.BDPMapDSystemCode=BDPMapDSystemCode  /// 系统
      s eobj.BDPMapDBaseTabNameDR=$O(^User.BDPBaseDataMapI("DescI",eobj.BDPMapDTableCode,0))  //  名称  科室 
      d obj.BDPMapDBaseTabNameDRSetObjectId(TableDR)  
      s obj.BDPMapDSystemCode=eobj.BDPMapDSystemCode 
      s obj.BDPMapDTableCode=BDPTableCode // 字典或 文本 code 
      s obj.BDPMapDHisDicCode=eobj.BDPMapDHisDicCode
      s obj.BDPMapDHisDicDesc=eobj.BDPMapDHisDicDesc
      s obj.BDPMapDExtDicCode=eobj.BDPMapDExtDicCode
      s obj.BDPMapDExtDicDesc=eobj.BDPMapDExtDicDesc  
      s obj.BDPMapDActive=eobj.BDPMapDActive 
      s obj.BDPMapDHisFlag=eobj.BDPMapDHisFlag 
       
      Tstart
      s sc=  obj.%Save()  
      if $$$ISOK(sc)
      {
        Tcommit
        s id = obj.%Id() 
        s result = "{success:'true',id:'"_id_"'}"       
        d:eobj.BDPMapDRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_BaseDataMapDetail ","User.BDPBaseDataMapDetail","基础数据对照",eobj.BDPMapDRowId,eobj.BDPMapDHisDicDesc,"U",eobj,bboj)
        d:eobj.BDPMapDRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_BaseDataMapDetail","User.BDPBaseDataMapDetail","基础数据对照",id,eobj.BDPMapDHisDicDesc,"A",eobj)
       }
       else
       {  
         Trollback
         s result = "{success:'false',errorinfo:'"_$system.OBJ.DisplayError(sc)_"'}"    
         s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基础数据对照","web.DHCBL.CT.BDPBaseDataMapDetail","SaveEntity",eobj)
         s ^TMPERRORLOGINFO=$system.OBJ.DisplayError(sc)
         s ^ERRORLOGINFO(logid)=$system.OBJ.DisplayError(sc)
       } 
  }  
  q result
}

/*
医生站的对照界面，提供了统一的接口取转换后对照数据
w ##Class(DHCDoc.GetInfo.iReminder.Methods).ConvertData("PHCINSTRUC","口服1")
公共接口还需完善以下内容：
1)需判断字典的有效标志、开始日期、结束日期，对照关系的有效标志
2)输出代码或描述应可选择。
3)字典上可定义“HIS给第三方”或“第三方给HIS”，接口应判断此标记输出正确内容。
*/
/// Function:对照界面，提供了统一的接口取转换后对照数据 
/// Input： SystemCode: 所属系统  TableCode:字典或者文本代码  Code:转换前代码  
/// Output：转换后  代码  描述
/// w ##Class(web.DHCBL.CT.BDPBaseDataMapDetail).ConvertData("01","CT_Coutry","01")
ClassMethod ConvertData(SystemCode As %String, TableCode As %String, Code As %String) As %String
{
    q:(SystemCode="")||(TableCode="")||(Code="") "所属系统、表名或者转换前代码不能为空"
    s return="^^"
    ; ^User.BDPBaseDataMapDetailI("BDPMapDTableCodeIdx","BA","CT_Sex",44)="
    q:'$d(^User.BDPBaseDataMapDetailI("BDPMapDTableCodeIdx",SystemCode,TableCode)) return
    s BDPMapDRowId=$O(^User.BDPBaseDataMapDetailI("BDPMapDTableCodeIdx",SystemCode,TableCode,0))
    q:BDPMapDRowId="" return
    
    s BDPMapDHisFlag =$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),9)  
    if (BDPMapDHisFlag="Y") //  转换关系为第三方 -> HIS
    {
        ;^User.BDPBaseDataMapDetailI("ExtCodeIdx","01","CT_Sex","M",41)
        s BDPMapDetailRowId = $O(^User.BDPBaseDataMapDetailI("ExtCodeIdx",SystemCode,TableCode,Code,0))
        q:BDPMapDetailRowId="" return
        s TransDicCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDetailRowId)),3)
        s TransDicDesc=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDetailRowId)),4) 
        s BDPMapDActive=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),10) 
    }
    else /// 转换关系为HIS -> 第三方
    {
         s BDPMapDetailRowId = $O(^User.BDPBaseDataMapDetailI("HisCodeIdx",SystemCode,TableCode,Code,0))
         q:BDPMapDetailRowId="" return
         s TransDicCode=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDetailRowId)),5)
         s TransDicDesc=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDetailRowId)),6) 
         s BDPMapDActive=$lg($g(^User.BDPBaseDataMapDetailD(BDPMapDRowId)),10) 
    }   
    if (BDPMapDActive="Y")
    { 
        s return=BDPMapDHisFlag_"^"_TransDicCode_"^"_TransDicDesc
    }
    q return
}

}
