/// Description: 通用字典的字段配置信息
/// Creator:  sunfengchao
/// CreateDate:2018-09-06
Class web.DHCBL.BDP.BDPDictionaryConfig Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description: 判断类是否存在
/// Input:    classAllName
/// Return:   存在1,不存在0
/// Other:    w ##class(web.DHCBL.BDP.FindTableStructure).ClassExistOrNot("User.CTLoc") 
ClassMethod ClassExistOrNot(classAllName As %String)
{
    n (classAllName,%session)
    s i=0
    set dcd = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
    if (dcd'="") 
    {
        s i=1
    }   
    q i
}

/// Description:判断类方法是否存在 1:存在 0:不存在
/// Creator:    sunfengchao
/// CreateDate: 2016-2-3
/// Debug：     w ##class(web.DHCBL.BDP.BDPDataChangeLog).IsValidMethodName("web.DHCBL.CT.CTTitle","SaveEntity")
ClassMethod IsValidMethodName(classname As %String, methodname As %String) As %Library.Boolean
{
  n (%session,classname,methodname)
  q:((classname="")||(methodname="")) 0
  s myobj=##class(%Dictionary.CompiledMethod).%OpenId(classname_"||"_methodname)
  s myrtn=0
  i ($IsObject(myobj))
  {
    s myobj=""
    s myrtn = 1
  }
  q myrtn
}

/// Description: %CacheSQLStorage 得到索引 
/// Input:      subScripts
/// Return:     subString:   (0,"BillDate",{PBDO_BillDate},{PBDO_RowId})
/// Other:      w ##class(web.DHCBL.BDP.FindTableStructure).getIndexSubStr("")  
ClassMethod getIndexSubStr(subScripts)
{
    new (subScripts)
    s subString=""
    s subCnt=subScripts.Count(),subString="("
    for k=1:1:subCnt {
        set subScript=subScripts.GetAt(k)   
        set expr=subScript.Expression
        set subString=subString_""_expr_","
    }
    set $e(subString,$l(subString))=""   //去掉最后的逗号
    s subString=subString_")"
    q subString
}

/// Description: CacheSQLStorage 得到Desc索引 
/// Creator:    sunfengchao
/// CreateDate: 2016-2-3
/// debug:      w ##class(web.DHCBL.BDP.BDPDictionaryConfig).SelectMaster("","CTTitle")
ClassMethod SelectMaster(packageName As %String, className As %String) As %String
{
    new (packageName,className)
    s result=""
    if packageName="" s packageName ="User"  //默认User 
    set classAllName=packageName_"."_className
    set dcd = ##class(%Dictionary.ClassDefinition).%OpenId(classAllName,0)
    if (dcd="") q ""
    set dsd=dcd.Storages
    set dsdCount=dsd.Count()
    ;s storageType="%CacheSQLStorage"
    for j=1:1:dsdCount
    {  
        s storage = dsd.GetAt(j)
        s storageType = storage.Type 
        s sqlMapsID = storage.SQLMaps  ///%CacheSQLStorage ,%Library.CacheSQLStorage
        s sqlMapsCount=sqlMapsID.Count()
        for i=1:1:sqlMapsCount
        {
            set sqlMapID=sqlMapsID.GetAt(i)
            set type=sqlMapID.Type
            set indexName=sqlMapID.Name
            set indexSub=..getIndexSubStr(sqlMapID.Subscripts)
            set indexMasterData=sqlMapID.Global_indexSub 
            if ($g(indexName)["Desc"){ 
                 s result= $g(indexMasterData)
            }
        } 
    } 
    q result
}

/// Description:通过desc去查询数据的rowid
/// Table:      BDP_DictionaryConfig
/// Creator:    sunfengchao
/// CreateDate: 2018-09-10
/// debug:     w ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetRowIdByDesc("User.RBCEquipment","CT")
ClassMethod GetRowIdByDesc(className As %String, desc As %String) As %String
{
    n (className,desc,%session)
    s rowid="" 
    ; 需要根据 code的索引去找 rowid 
    s Package=$p(className,".",1)
    s TableName=$p(className,".",2)
    s DescIndex =##class(web.DHCBL.BDP.BDPDictionaryConfig).SelectMaster(Package,TableName)  //查找实体类表的表结构 
    if (DescIndex'=""){
         if (DescIndex["$$ALPHAUP"){
             s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) 
             s DescIndex= $p(DescIndex,"$$ALPHAUP",1)
             s str="s rowid=$O("_DescIndex_""""_desc_""""_",0))"  
         }
         elseif (DescIndex["$$UPPER"){
             s:desc'="" desc=$$ALPHAUP^SSUTIL4(desc) 
             s DescIndex= $p(DescIndex,"$$UPPER",1)
             s str="s rowid=$O("_DescIndex_""""_desc_""""_",0))"   
         }
         else{
             s DescIndex= $p(DescIndex,"Desc",1)
             s str="s rowid=$O("_DescIndex_"Desc"""_","""_desc_""""_",0))"   
         } 
         x str 
    } 
    q rowid
}

/// Description:根据rowid获取值信息
/// Table:    BDP_DictionaryConfig
/// Creator: sunfengchao
/// CreateDate:2018-10-26
/// Debug:   w ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetValueDescByRowId("BDPDictionary","4","2")
ClassMethod GetValueDescByRowId(BDPDataSource As %String, BDPPropertyDRCode As %String, BDPValue As %String) As %String
{
    new (%session,BDPDataSource,BDPPropertyDRCode,BDPValue)
    q:(BDPDataSource=""||BDPPropertyDRCode=""||BDPValue="") ""
    s result=""  
    if (BDPDataSource="BDPTableList")
    {
        ; 根据 值id去表结构登记里找数据的描述   
        s descstr=##class(web.DHCBL.BDP.BDPDictionaryConfig).GetDescGlobal(BDPPropertyDRCode)  
        s xrowidstr="s xrowid="_BDPValue
        x xrowidstr 
        s DescXStr="s result="_$P(descstr,",",1)_","_xrowid_")),"_$P(descstr,",",3)_","_$P(descstr,",",4)  
        x DescXStr   
    }
    elseif (BDPDataSource="BDPDictionary")
    {
        s result=$LISTGET($G(^User.BDPDataDictionaryD(BDPValue)),3)   
    }  
    q result
}

/// Description: 查询下拉框里的数据 动态查询
/// Creator： sunfengchao
/// CreateDate:2018-09-10
/// Table：  User.BDPTableList
/// Dubug:   d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDictionaryConfig","GetComboDataList","BDPTableList","1","")
Query GetComboDataList(DataSource As %String, TableID As %String, desc As %String = "") As %Query(ROWSPEC = "ID:%String,PropertyDesc:%String")
{
}

ClassMethod GetComboDataListExecute(ByRef qHandle As %Binary, DataSource As %String, TableID As %String, desc As %String = "") As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1 
 if (TableID="")
 { 
    Set qHandle=$lb(0,repid,0)
    Quit $$$OK
 }
 else
 { 
  s:desc'="" desc=$ZCONVERT(desc,"U") 
  if (DataSource="BDPTableList") 
  {
    ; 根据表结构去查询数据 
    s ClassName=$LISTGET($G(^User.BDPTableListD(TableID)),8)
    ; 去导出配置表里寻找rowid遍历 
    s ExportID=$O(^User.BDPEXConfigI("UniqueTableName"," "_$zcvt(ClassName,"U"),0)) 

    if (ExportID'="")
    { 
        s EXCXGlobal=$LISTGET($G(^User.BDPEXConfigD(ExportID)),5) 
        s descstr=##class(web.DHCBL.BDP.BDPDictionaryConfig).GetDescGlobal(ExportID)  
        s xrowidstr="s xrowid="_EXCXGlobal
        s xrowid=0
        for 
        {   
             x xrowidstr  
             q:xrowid=""    
             s ID=xrowid 
             s PropertyDesc=""
             s xdescstr="s PropertyDesc="_descstr 
             x xdescstr  
             if ($zcvt(PropertyDesc,"U")[$zcvt(desc,"U"))||(desc="")
             { 
               d OutputRow2 
             }
        }
    }
  }
  elseif (DataSource="BDPDictionary") /// 去取字典表里的数据
  {
       s ID=0
       for
       {
          s ID=$O(^User.BDPDataDictionaryI("DicDRI",TableID,ID))
          q:ID=""
          s str= $g(^User.BDPDataDictionaryD(ID))   
          s PropertyDesc=$listget(str,3)
          if ($zcvt(PropertyDesc,"U")[$zcvt(desc,"U"))||(desc="")
          { 
               d OutputRow2 
          }
       }
  }
}
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow2
    set Data=$lb(ID,PropertyDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetComboDataListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComboDataListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetComboDataListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComboDataListExecute ]
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

/// Description:获取列表的扩展字段名称
/// Table:    BDP_DictionaryConfig
/// Creator: sunfengchao
/// CreateDate:2018-08-23
/// Debug:   w ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetColumnName("1")
ClassMethod GetColumnName(dictorydr As %String) As %String
{
      new (dictorydr)
      s resultstr="" 
      for i=1:1:25
      {
          s Param="BDPDictionaryText"_i
          s BDPTextStr="s Param =$listget($g(^User.BDPDataDictionaryD("_dictorydr_")),"_(i+6)_") " 
          x BDPTextStr
          if (Param'="")
          {
              if (resultstr="")
              {
                   s resultstr=Param
              }
              else
              {
                   s resultstr=resultstr_"^"_Param
              }
          }
      } 
      quit resultstr
}

/// Description:描述字段如何去取
/// Table:      BDP_DictionaryConfig
/// Creator：   sunfengchao
/// CreateDate: 2018-09-10
/// Debug:      w ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetDescGlobal(2)
ClassMethod GetDescGlobal(ParRef As %String) As %String
{
    new (ParRef)
    q:ParRef="" ""
    s result=""
    s childsub=0
    for
    {
        s childsub=$O(^User.BDPEXConfigD(ParRef,"ChildField",childsub))
        q:childsub=""
        s EXFCIDToDesc=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",childsub)),2)  
        if (EXFCIDToDesc["描述")
        {
            s result= $LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",childsub)),6) 
        } 
    }
    
    if (result="")
    {
        s childsub=0
        for
        {
            s childsub=$O(^User.BDPEXConfigD(ParRef,"ChildField",childsub))
            q:childsub=""
            s EXFCIDToDesc=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",childsub)),2)  
            if (EXFCIDToDesc["名称")
            {
                s result= $LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",childsub)),6) 
            } 
        }
    }
    q result
}

/// Description: 保存 自动配置 信息
/// Table:    BDP_DictionaryConfig
/// Creator： sunfengchao
/// CreateDate:2018-09-10
/// Debug: w ##class(web.DHCBL.BDP.BDPDictionaryConfig).AutoSaveConfigInfo(81)  
ClassMethod AutoSaveConfigInfo(id As %String) As %String
{
    new (id)
    s BDPExtMenuDr=$listget($g(^User.BDPDataDictionaryD(id)),33) 
    q:BDPExtMenuDr="" "" 
    if ($d(^User.BDPDictionaryConfigI("DictionaryDRIndex",id)))
    {
        s BDPConfigID=$O(^User.BDPDictionaryConfigI("DictionaryDRIndex",id,0))
        if (BDPConfigID'="")
        { 
            x "s obj= ##class(User.BDPDictionaryConfig).%OpenId("_""""_BDPConfigID_""""_")" 
        }
    }
    else
    { 
        x "s obj= ##class(User.BDPDictionaryConfig).%New()" 
    } 
    x "d obj.BDPDictionaryDRSetObjectId("_id_")"
    s datalist= ##class(web.DHCBL.BDP.BDPDataDictionary).GetExtendPropertyType(BDPExtMenuDr) 
    for i=1:1:$length(datalist,"#")
    {
        s typestr=$p(datalist,"#",i)
        s BDPPropertyType=$p(typestr,"^",1)
        s BDPPropertyDRCode= $p(typestr,"^",2)
        s order=i
        s BDPDictionaryText="BDPDictionaryText"_order_"Type"
        s str="s obj."_BDPDictionaryText_"="_""""_BDPPropertyType_""""
        x str
        s BDPPropertyDR="BDPDictionaryText"_order_"DRCode"
        s str="s obj."_BDPPropertyDR_"="_""""_BDPPropertyDRCode_""""
        x str   
        TSTART
        x "s flag= obj.%Save()" 
        x "s ^TMP(""BDPDictionConfig2"")=flag" 
        s flag=$g(^TMP("BDPDictionConfig2"))
        if (flag=1)
        {
           TCOMMIT 
        }
        else
        {
           Trollback
       } 
    }
    q 1
}

/// Description:获取扩展表配置字段对应的字典id
/// Table:    BDP_DictionaryConfig
/// Creator:  sunfengchao
/// CreateDate:2022-11-03
/// Debug:    w ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetTableIdByDesc("民族","BDPDataDictionary")
ClassMethod GetTableIdByDesc(TableDesc As %String, Type As %String) As %String
{
    q:(TableDesc="")||(Type="") ""
    s RowId=""
    if (Type="BDPTableList")
    {
        &SQL(SELECT %id  into :RowId FROM SQLUser.BDP_TableList WHERE  TableDesc =:TableDesc)
    }
    if (Type="BDPDictionary")
    {
       &SQL(SELECT %id  into :RowId FROM SQLUser.BDP_DataDictionary WHERE  BDP_DictionaryDesc =:TableDesc)   
    }
    q RowId
}

/// Description: 保存通用字典的字段配置信息
/// Table:    BDP_DictionaryConfig
/// Creator:  sunfengchao
/// CreateDate:2018-09-06
/// Debug:    w ##class(web.DHCBL.BDP.BDPDictionaryConfig).SaveConfigInfo("14","3^a^String^#4^b^Date^#5^c^Time^#6^d^Float^")
ClassMethod SaveConfigInfo(dictorydr As %String, datalist As %String) As %String
{
    new (dictorydr,datalist)
    s datastr="" 
    if (datalist="") q ""
    s strlen= $Length(datalist,"#")
   
  
    if (datalist["表结构登记") s datalist=$replace(datalist,"表结构登记","BDPTableList")
    if (datalist["通用字典") s datalist=$replace(datalist,"通用字典","BDPDictionary")
    ; s ^TMPBDPPropertyDRCode33=datalist   ;;; : 1^232^DR^BDPTableList^4
    ; 需要判断是新增配置还是修改配置信息
    s BDPConfigID=""
    if ($d(^User.BDPDictionaryConfigI("DictionaryDRIndex",dictorydr)))
    {
        s BDPConfigID=$O(^User.BDPDictionaryConfigI("DictionaryDRIndex",dictorydr,0))
        if (BDPConfigID'="")
        { 
            x "s obj= ##class(User.BDPDictionaryConfig).%OpenId("_""""_BDPConfigID_""""_")" 
        }
    }
    else
    { 
        x "s obj= ##class(User.BDPDictionaryConfig).%New()" 
    } 
    x "d obj.BDPDictionaryDRSetObjectId("_dictorydr_")" 
    for i=1:1:strlen
    {
        s datastr =$p(datalist,"#",i)
        s order=$P(datastr,"^",1)
        s BDPPropertyType=$P(datastr,"^",3)
        s BDPDRSource=$P(datastr,"^",4)
        s BDPPropertyDRCode=$P(datastr,"^",5)
        s ^TMPBDPPropertyDRCode="BDPPropertyDRCode:"_BDPPropertyDRCode
        if (BDPPropertyDRCode'="")&(+BDPPropertyDRCode=0) 
        {   
            s BDPPropertyDRCode=##class(web.DHCBL.BDP.BDPDictionaryConfig).GetTableIdByDesc(BDPPropertyDRCode,BDPDRSource)  
        }
        ; s ^TMPBDPPropertyDRCode2="BDPPropertyDRCode:"_BDPPropertyDRCode
       ;;  s $p(datalist,"^",5)=BDPPropertyDRCode
        
        s BDPDictionaryText="BDPDictionaryText"_order_"Type"
        if ((BDPPropertyType="DR")&(BDPDRSource'="")) s BDPPropertyType=BDPPropertyType_"^"_BDPDRSource  /// DR 指向  取自哪里+数据user表
        s str="s obj."_BDPDictionaryText_"="_""""_BDPPropertyType_""""
        x str
        s BDPPropertyDR="BDPDictionaryText"_order_"DRCode" 
        
        s str="s obj."_BDPPropertyDR_"="_""""_BDPPropertyDRCode_""""
        x str  
        TSTART
        x "s flag= obj.%Save()" 
        x "s ^TMP(""BDPDictionConfig"")=flag" 
        s flag=$g(^TMP("BDPDictionConfig"))
        if (flag=1)
        {
           TCOMMIT 
        }
        else
        {
           Trollback
       } 
    }
    q 1
}

/// Description: 移除字段
/// Table:    BDP_DictionaryConfig
/// Creator:  sunfengchao
/// CreateDate:2018-09-08
/// /Others:   移除字段相当于对字段进行了修改,要同时在配置表里删除字段配置
/// Debug:    w ##class(web.DHCBL.BDP.BDPDictionaryConfig).RemoveProperty("24^1")
ClassMethod RemoveProperty(idstr As %String) As %String
{
    new (idstr)
    if (idstr="")  q ""
    s id=$p(idstr,"^",1)
    s index=$p(idstr,"^",2)  
    if ($d(^User.BDPDictionaryConfigI("DictionaryDRIndex",id)))
    {
        s BDPConfigID=$O(^User.BDPDictionaryConfigI("DictionaryDRIndex",id,0))
        if (BDPConfigID'="")
        {  
             s cobj= ##class(User.BDPDictionaryConfig).%OpenId(BDPConfigID)
             s PropertyTypeName="BDPDictionaryText"_index_"Type"
             s str="s cobj."_PropertyTypeName_"="""""
             x str
             s PropertyDRName="BDPDictionaryText"_index_"DRCode"
             s str="s cobj."_PropertyDRName_"="""""
             x str
             s flag=cobj.%Save()
             if (flag=1)
             {
                   Tstart
                   s obj =##class(User.BDPDataDictionary).%OpenId(id)
                   if (obj)
                   {
                      s PropertyName=""
                      s PropertyName="BDPDictionaryText"_index
                      s str="s obj."_PropertyName_"="""""
                      x str
                      s sc=obj.%Save()
                      if (sc=1)
                      {
                          Tcommit
                          s result = "{success:'true',info:'删除成功！'}"  
                      }
                      else
                      {
                          Trollback
                          s result = "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
                      }
                    }   
            }
        }   
    } 
   q result
}

/// Description: 获取dr的字符串
/// Table:    BDP_DictionaryConfig
/// Creator:  sunfengchao
/// CreateDate:2018-09-08 
/// Debug:    w ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetDRByClassName("8^26^BDPDictionary")
ClassMethod GetDRByClassName(DataStr As %String) As %String
{
     new (DataStr)
     s result=""  
     s BDPId=$p(DataStr,"^",1)
     s rowid=$p(DataStr,"^",2)
     s BDPSource=$p(DataStr,"^",3)
     q:rowid="" "" 
     if (BDPId'="")
     {
        if (BDPSource="BDPTableList")
        {   
             s XCode= $LISTGET($G(^User.BDPTableListD(BDPId)),4) 
             s RowId=rowid
             if (XCode'="")
             {
                 s str=$p(XCode,"=",2)
                 s xstr="s BDPDesc="_str
                 x xstr
                 s result=BDPDesc
             }
        }
        elseif (BDPSource="BDPDictionary")
        {  
           s result=$listget($g(^User.BDPDataDictionaryD(rowid)),3) 
        }
     }
     q result
}

/// Description: 根据数据的rowid获取字段是DR指向的 字段dr字符串
/// Table:    BDP_DictionaryConfig
/// Creator:  sunfengchao
/// CreateDate:2018-09-08   
/// Debug:    w ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetDRValue()
ClassMethod GetDRValue(id As %String) As %String
{
     new (id)
     s result="" 
     s dictionaryid =$listget($g(^User.BDPDataDictionaryD(id)),4)  
     if (dictionaryid'="")
     {
         if ($d(^User.BDPDictionaryConfigI("DictionaryDRIndex",dictionaryid)))
         {
            s BDPConfigID=$O(^User.BDPDictionaryConfigI("DictionaryDRIndex",dictionaryid,0)) 
            if (BDPConfigID'="")
            {  
                for i=1:1:20
                {
                    s BDPType =$listget($g(^User.BDPDictionaryConfigD(BDPConfigID)),+i+2)  
                    if (BDPType'="")
                    {  
                         s RowId=i
                         s BDPValue=""
                         s BDPDRCode=""
                         s BDPDRCode= $listget($g(^User.BDPDictionaryConfigD(BDPConfigID)),+i+27)   
                         if (BDPType["ComboBox")||(BDPType["DR")
                         {  
                           s BDPSource=$p(BDPType,"^",2)
                           s BDPValue= $listget(^User.BDPDataDictionaryD(id),+i+6)  
                           s BDPProperty= $listget(^User.BDPDataDictionaryD(dictionaryid),+i+6)  /// 字典字段名称
                           s PropertyDesc=" "_$zcvt(BDPProperty,"U") 
                           if (result="")
                           { 
                                s result=RowId_"^"_BDPDRCode_"^"_BDPValue_"^"_BDPSource
                           }
                           else
                           {
                                s result=result_"#"_RowId_"^"_BDPDRCode_"^"_BDPValue_"^"_BDPSource
                           }   
                         }   
                    }
                }
            }
         } 
     } 
     q result
}

/// Description: 根据 哪些字段是DR 指向
/// Table:    BDP_DictionaryConfig
/// Creator:  sunfengchao
/// CreateDate:2018-09-08   
/// Debug:    w ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetDRByDicDr(46)
ClassMethod GetDRByDicDr(dictionarydr) As %String
{
     n (dictionarydr)
     s result="" 
     s dictionaryid =dictionarydr
     if (dictionaryid'="")
     {
         if ($d(^User.BDPDictionaryConfigI("DictionaryDRIndex",dictionaryid)))
         {
            s BDPConfigID=$O(^User.BDPDictionaryConfigI("DictionaryDRIndex",dictionaryid,0)) 
            if (BDPConfigID'="")
            {  
                for i=1:1:25
                {
                    s BDPType =$listget($g(^User.BDPDictionaryConfigD(BDPConfigID)),+i+2)  
                    if (BDPType'="")
                    {  
                         s RowId=i
                         s BDPValue=""
                         s BDPDRCode=""
                         s BDPDRCode= $listget($g(^User.BDPDictionaryConfigD(BDPConfigID)),+i+27)   
                         if (BDPType["DR")
                         {   
                           s BDPDataSource=$p(BDPType,"^",2)
                           s BDPProperty= $listget(^User.BDPDataDictionaryD(dictionaryid),+i+6)  /// 字典字段名称
                           s PropertyDesc=" "_$zcvt(BDPProperty,"U") 
                           if (result="")
                           { 
                                s result=RowId_"^"_BDPDRCode_"^"_BDPDataSource
                           }
                           else
                           {
                                s result=result_"#"_RowId_"^"_BDPDRCode_"^"_BDPDataSource
                           }   
                         }   
                    }
                }
            }
         } 
     } 
     q result
}

/// Description: 获取 字典里的DR字段是指向了哪个表
/// Table:    BDP_DictionaryConfig
/// Creator:  sunfengchao
/// CreateDate:2018-09-12
/// Debug:   w ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetPropertySourceTable("BDPTableList","2")   
ClassMethod GetPropertySourceTable(BDPDRSource, BDPDRCode)
{
    new (BDPDRSource,BDPDRCode)
    s result=""
    if (BDPDRSource="BDPTableList")
    {
        ; 取表名称
       s result= $LISTGET($G(^User.BDPTableListD(BDPDRCode)),3) 
    }
    elseif (BDPDRSource="BDPDictionary")
    {
        s result = $listget($g(^User.BDPDataDictionaryD(BDPDRCode)) ,3) 
    }
    q result
}

/// Description: 通用字典数据导入程序
/// Table:    BDP_DictionaryConfig
/// Creator:  sunfengchao
/// CreateDate:2018-09-10 
/// Debug      w ##class(web.DHCBL.BDP.BDPDictionaryConfig).ImportExcel(46,"XWY0002#2232#2012/01/21#2012/01/30")  
ClassMethod ImportExcel(dictionarydr As %String, dataStr As %String) As %String
{
    new (dictionarydr,dataStr)
    s ^TMP("dataStr")=dataStr
    q:dataStr="" ""
    s result =0  
    s flag=0         
    s len=$length(dataStr,"&%")
    s BDPDictionaryCode =$p(dataStr,"&%",1)  
    s BDPDictionaryDesc=$p(dataStr,"&%",2)   
    if (BDPDictionaryCode="")||(BDPDictionaryDesc="")
    {   
        s result=0  
        q "{success:'false'}" 
    }
    else
    {
      tstart 
      s:BDPDictionaryCode'="" BDPDictionaryCodeI=" "_$ZCONVERT(BDPDictionaryCode,"U")   
      s BDPDictionaryRowId= $o(^User.BDPDataDictionaryI("BDPDicCodeI",dictionarydr,BDPDictionaryCodeI,0)) 
      if (BDPDictionaryRowId'="")
      {
          s bobj=##class(User.BDPDataDictionary).%OpenId(BDPDictionaryRowId)
      }  
      else
      {
        s bobj=##class(User.BDPDataDictionary).%New() 
      }
      s flag=##class(web.DHCBL.BDP.BDPDataDictionary).FormValidate(dictionarydr,BDPDictionaryRowId,BDPDictionaryCode,BDPDictionaryDesc)
  
      if (flag=1)
      {
           s result = "{success:'false',errorinfo:'该记录已经存在！'}" 
      }
      else
      {   
        s result=1 
        s DRStr =""
        s ColumnList= ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetColumnName(dictionarydr)
        s ColumnLen = $Length(ColumnList,"^") 
        s BDPDictionaryDateFrom=$p(dataStr,"&%",3)  
        s BDPDictionaryDateTo=$p(dataStr,"&%",4) 
        s BDPDictionaryText1="" ,BDPDictionaryText2="",BDPDictionaryText3="",BDPDictionaryText4="",BDPDictionaryText5=""
        s BDPDictionaryText6="",BDPDictionaryText7="",BDPDictionaryText8="",BDPDictionaryText9="",BDPDictionaryText10=""
        s BDPDictionaryText11="",BDPDictionaryText12="",BDPDictionaryText13="",BDPDictionaryText14="",BDPDictionaryText15=""
        s BDPDictionaryText16="",BDPDictionaryText17="",BDPDictionaryText18="",BDPDictionaryText19="",BDPDictionaryText20=""
        s BDPDictionaryText21="",BDPDictionaryText22="",BDPDictionaryText23="",BDPDictionaryText24="",BDPDictionaryText25=""
        for m=1:1:ColumnLen
        {
            s xstr="s BDPDictionaryText"_m_"=$p(dataStr,""&%""," _(4+m)_")"     
            x xstr  
        } 
        if (BDPDictionaryText1'="")
        {
            /// 获取到所有的dr   2^50^BDPTableList
            s DRStr=##class(web.DHCBL.BDP.BDPDictionaryConfig).GetDRByDicDr(dictionarydr)
            s len =$length(DRStr,"#")
            for k=1:1:len
            {
                s IDstr=$P(DRStr,"&%",k)
                s index =$P(IDstr,"^",1) ///第几个扩展字段
                s typecode =$P(IDstr,"^",2) /// 指向表的数据ID
                s BDPDRSource =$P(IDstr,"^",3) ///  数据来源  
                s codedr=""  
                if (BDPDRSource="BDPTableList")
                {
                    ; 取表名称
                    s UserClass= $LISTGET($G(^User.BDPTableListD(typecode)),2)   
                    s str="s codedr= ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetRowIdByDesc("_""""_UserClass_""""_","_"BDPDictionaryText"_index_")" 
                    x str
                }
                elseif (BDPDRSource="BDPDictionary")
                {
                    ; 根据描述去取 通用字典的ID 
                     s:typecode'="" typecode=" "_$ZCONVERT(typecode,"U")
                     s codedr= $o(^User.BDPDataDictionaryI("BDPDicCodeI",dictionarydr,typecode,0))
                } 
                if (codedr'="")
                {
                    s str="s BDPDictionaryText"_index_"="_""_codedr_"" 
                    x str  
                } 
            }  
        }   
       s bobj.BDPDictionaryCode=BDPDictionaryCode 
       s bobj.BDPDictionaryDesc =BDPDictionaryDesc 
       if (dictionarydr'="")
       { 
          d bobj.BDPDictionaryDRSetObjectId(dictionarydr)
       }
       s bobj.BDPDictionaryDateFrom =##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(BDPDictionaryDateFrom)   
       s bobj.BDPDictionaryDateTo =##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(BDPDictionaryDateTo)  
         
       for m=1:1:ColumnLen
        {
            s xstr="s bobj.BDPDictionaryText"_m_"=BDPDictionaryText"_m_""  
            x xstr  
        }   
       s sc = bobj.%Save()  
       if (sc=1)
       {
           tc
           s id = bobj.%Id()
           s result=result_"^"_1
           s result = "{success:'true',info:'成功！'}" 
        }
       else
       {
            tro
            s result=result_"^"_0
            s result = "{success:'false',errorinfo:'失败！'}" 
        }    
      } 
      q result
    }
}

/// Description: 生成数据模板
/// Table:      BDP_DictionaryConfig
/// Creator:    sunfengchao
/// CreateDate: 2017-6-6   
/// Debug:      w ##class(web.DHCBL.BDP.BDPDictionaryConfig).ProductTemplate("a","8")
ClassMethod ProductTemplate1(ExcelName, p1)
{
    New rs,File
    New pcount Set pcount=$zutil(141)-3
    k BDPDICTEXT
    s ColumnList= ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetColumnName(p1)
    s ColumnLen = $Length(ColumnList,"^")
    s BDPDICTEXT(1)="代码"
    s BDPDICTEXT(2)="描述"
    s BDPDICTEXT(3)="开始日期"
    s BDPDICTEXT(4)="结束日期"
    for j=1:1:ColumnLen+4
    {
        s BDPDICTEXT(j+4)=$P(ColumnList,"^",j)
    }      
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
    
    For i=1:1:ColumnLen+4 
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

/// Description:导出Query的结果成excel,返回Excel文件目录  
/// Creator:    sunfengchao
/// CreateDate: 2017-6-6   
/// Debug:      w ##class(web.DHCBL.BDP.BDPDictionaryConfig).ExportToExcel("a","web.DHCBL.BDP.BDPDataDictionary","GetList","8")
ClassMethod ExportToExcel(ExcelName, ClassName, QueryName, p1)
{
    New rs,File
    New pcount Set pcount=$zutil(141)-3
    k BDPDICTEXT
    s ColumnList= ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetColumnName(p1)
    s ColumnLen = $Length(ColumnList,"^")
    s BDPDICTEXT(1)="代码"
    s BDPDICTEXT(2)="描述"
    s BDPDICTEXT(3)="开始日期"
    s BDPDICTEXT(4)="结束日期"
    for j=1:1:ColumnLen+4
    {
        s BDPDICTEXT(j+4)=$P(ColumnList,"^",j)
    }    
    // 老版的ajax方法会把p1-p16都设置上空,会影响query入参判断, 从query入参校正一下
    Set Spec = ##class(websys.Query).GetFormalSpecParsed(ClassName,QueryName)
    if pcount>$l(Spec,",") set pcount=$l(Spec,",")   
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
    Set rs = ##class(%ResultSet).%New(ClassName_":"_QueryName)
    Set %sc = rs.Execute("",p1,"","")
    If $$$ISERR(%sc) Do DisplayError^%apiOBJ(%sc) Quit ""
    Set columns=rs.GetColumnCount()
    For i=1:1:ColumnLen+4 
    {
        d File.Write(BDPDICTEXT(i)_",")           
    }    
    For  Quit:rs.Next(.%sc)=0  if $$$ISOK(%sc) { d File.WriteLine("") For i=1:1:ColumnLen+4  d File.Write(rs.GetData(i)_",") } else { quit }
    if $$$ISERR(%sc) do $system.OBJ.DisplayError(%sc)
    Do File.Flush()
    Do File.%Save()
    Do File.Close()
    Set File=""
    Set rs =""
    Quit "dhc.bdp.bdp.fileload.csp?act=download&filename="_ExcelName_"&dirname="_PhyDir
}

/// Description: 清除数据(导入数据之前使用)
/// CreateDate:2018-09-20
/// Creator:  sunfengchao
/// Debug:    w ##class(web.DHCBL.BDP.BDPDictionaryConfig).ClearData()
ClassMethod ClearData(dictionarydr As %String) As %String
{
   new (dictionarydr)
   if (dictionarydr="") q 0
   ; 同时删除 字典数据
   s DicDataRowId=0
   for
   {
      s DicDataRowId= $O(^User.BDPDataDictionaryI("DicDRI",dictionarydr,DicDataRowId))
      q:DicDataRowId=""
      s sc=##class(web.DHCBL.BDP.BDPDataDictionary).DeleteData(DicDataRowId)
   }
   q 1
}

/// Description:获取列表的扩展字段名称
/// Table:    BDP_DictionaryConfig
/// Creator: sunfengchao
/// CreateDate:2018-08-23
/// Debug:   w ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetColumnName("1")
ClassMethod GetColumnInfo(dictorydr As %String) As %String
{
      new (dictorydr)
      s resultstr="" 
      for i=1:1:25
      {
          s Param="BDPDictionaryText"_i
          s BDPTextStr="s Param =$listget($g(^User.BDPDataDictionaryD("_dictorydr_")),"_(i+6)_") " 
          x BDPTextStr
          if (Param'="")
          {
              if (resultstr="")
              {
                   s resultstr=Param_"^"_"BDPDictionaryText"_i_"^N"
              }
              else
              {
                   s resultstr=resultstr_"&#"_Param_"^"_"BDPDictionaryText"_i_"^N"
              }
          }
      } 
      quit resultstr
}

/// Description: 生成数据模板
/// Table:      BDP_DictionaryConfig
/// Creator:    sunfengchao
/// CreateDate: 2017-6-6   
/// Debug:      w ##class(web.DHCBL.BDP.BDPDictionaryConfig).ProductTemplate("71")
ClassMethod ProductTemplate(TreeId As %String) As %String
{
    New (TreeId) 
    q:TreeId="" ""
    s ColumnList= ##class(web.DHCBL.BDP.BDPDictionaryConfig).GetColumnInfo(TreeId) 
    s SheetName= $LISTGET($G(^User.BDPDataDictionaryD(TreeId)),3)   //描述
    s result= SheetName_"&%代码^BDPDictionaryCode^Y&#描述^BDPDictionaryDesc^Y&#开始日期^BDPDictionaryDateFrom^Y&#结束日期^BDPDictionaryDateTo^N&#"_ColumnList  
    Quit result
}

}
