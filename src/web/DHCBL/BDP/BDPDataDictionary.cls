/// Function: 数据字典
/// Creator:  sunfengchao
/// CreateDate:2018-08-23
Class web.DHCBL.BDP.BDPDataDictionary Extends %RegisteredObject [ ProcedureBlock ]
{

/// Function:查找目录所在层级
/// Creator:sunfengchao
/// CreateDate:2018-08-30
/// Debug:  w ##class(web.DHCBL.BDP.BDPDataDictionary).GetMenuDR(77)
ClassMethod GetMenuDR(dictorydr As %String) As %String
{
   quit:dictorydr="" ""
   s result=""
   s parentdr=-100000000000000
   for
   {
       s parentdr=$O(^User.BDPDataDictionaryI("BDPParentMenuDrI",parentdr))
       q:parentdr=""
       s ID=0
       for
       {
           s ID= $O(^User.BDPDataDictionaryI("BDPParentMenuDrI",parentdr,ID)) 
           q:(ID="")
           if (ID=dictorydr)
           {
                s result=parentdr
           }
       }
   } 
   q result
}

/// Function: 为combo提供数据
/// CreateDate:2018-09-11
/// Creator:  sunfengchao
/// Tables:   BDP_DataDictionary
/// Input:    rowid code  desc
/// Output:   ID:%String,TableDesc:%String 
/// Others:   d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataDictionary","GetDataForCmb1","","","")
Query GetDataForCmb1(parentcatdr As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,TableDesc:%String ")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, parentcatdr As %String, code As %String, desc As %String) As %Status
{
    Set repid=$I(^CacheTemp)
    s ind=1
     
    //生成索引数组
    s ParentDR=0
    for
    {
        s ParentDR=$o(^User.BDPDataDictionaryI("DicDRI",ParentDR))
        q:ParentDR="" 
        s BDPParentDr=$LISTGET($G(^User.BDPDataDictionaryD(ParentDR)),32)   
        s ID=ParentDR
        s TableDesc=$LISTGET($G(^User.BDPDataDictionaryD(ParentDR)),3)   //描述
        if ($zcvt(TableDesc,"U")[($zcvt(desc,"U")))
        {
            d OutputRowCmb
        }    
    } 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRowCmb   
 set Data=$lb(ID,TableDesc)
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

/// Function:查询表结构登记的combo数据
/// CreateDate:2018-09-11
/// Creator:  sunfengchao 
/// Input:    rowid code  desc
/// Output:   ID:%String,TableDesc:%String 
/// Table：   User.BDPTableList
/// Dubug:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataDictionary","GetTableList","","","")
Query GetTableList(RowId As %String, code As %String, desc As %String) As %Query(ROWSPEC = "ID:%String,TableDesc:%String")
{
}

ClassMethod GetTableListExecute(ByRef qHandle As %Binary, RowId As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (RowId'="") //根据rowid返回该条记录
 {
  s ID=RowId
  s TableName=$LISTGET($G(^User.BDPTableListD(ID)),2)
  s TableDesc=$LISTGET($G(^User.BDPTableListD(ID)),3)
  d OutputRow
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U") 
  s:desc'="" desc=$ZCONVERT(desc,"U") 
  s ID=0
  for
  {
       s ID=$o(^User.BDPTableListD(ID)) 
       q:ID=""  
       s TableName=$LISTGET($G(^User.BDPTableListD(ID)),2)
       s TableDesc=$LISTGET($G(^User.BDPTableListD(ID)),3)
       s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(TableDesc)
       if ($ZCONVERT(TableName,"U")[code)&(($ZCONVERT(TableDesc,"U")[desc)||(PINYIN[desc)) 
       {
           d OutputRow
       }
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ID,TableDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetTableListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTableListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod GetTableListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTableListExecute ]
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

/// Function：查询树形列表
/// Creator： sunfengchao
/// CreatDate: 2018-09-13 
/// Input：  parentcatdr 父节点 
/// Return： treegrid格式数据串
/// Debug:   w ##class(web.DHCBL.BDP.BDPDataDictionary).GetDictionaryTreeList("")
ClassMethod GetDictionaryTreeList(parentcatdr As %String) As %String
{
    s IDStr=""
    if (parentcatdr="") s parentcatdr=-100000000000000
    
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
        s myRowID=$o(^User.BDPDataDictionaryI("BDPParentMenuDrI",parentcatdr,myRowID)) 
        q:myRowID=""
        s BDPDictionaryDR=$listget(^User.BDPDataDictionaryD(myRowID),4)
        continue:BDPDictionaryDR'=""
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
        s count=count+1
        s Code=$LISTGET($G(^User.BDPDataDictionaryD(myRowID)),2)   //代码
        s Caption=$LISTGET($G(^User.BDPDataDictionaryD(myRowID)),3)   //描述
        if count>1 w ","
        w "{""id"":"""_myRowID_""",""text"":"""_Caption_"""" 
        s actMenuBDP=""  
        s childStr=..GetChildOrderedIDStr(myRowID)
        if childStr'=""
        {
            w ",""state"":""open"""
            w ",""children"":"
            w ..GetDictionaryTreeList(myRowID)  
        }
        else
        {
            w ",""state"":""open"""
        }
        w "}"  
    }
    w "]"
    q ""
}

/// Function：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Creator： sunfengchao
/// CreatDate: 2018-10-13 
/// Table：   BDP_DataDictionary
/// Input：   LastLevel
/// Return： 所有子节点 用^连接
/// w ##class(web.DHCBL.BDP.BDPDataDictionary).GetChildOrderedIDStr("")
ClassMethod GetChildOrderedIDStr(LastLevel As %String) As %String
{
    s IDStr=""
    if (LastLevel="") s LastLevel=-100000000000000
    s myCount=0
    k myArray 
    //生成菜单索引数组
    s myRowID=0 
    for
    {
        s myRowID=$o(^User.BDPDataDictionaryI("BDPParentMenuDrI",LastLevel,myRowID)) 
        q:myRowID="" 
        s BDPDictionaryDR=$listget(^User.BDPDataDictionaryD(myRowID),4)
        continue:BDPDictionaryDR'=""
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

/// Function ： 数据所属目录的列表
/// Creator：  sunfengchao
/// CreatDate: 2018-08-27 
/// Table：    BDP_DataDictionary
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataDictionary", "GetCategoryList","","")
Query GetCategoryList(code As %String, desc As %String) As %Query(ROWSPEC = "BDPDictionaryRowId,BDPDictionaryCode,BDPDictionaryDesc")
{
}

ClassMethod GetCategoryListExecute(ByRef qHandle As %Binary, code As %String, desc As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    s SubNote="-100000000000000"
  
    s BDPDictionaryRowId=0
    for
    { 
          s BDPDictionaryRowId=$o(^User.BDPDataDictionaryI("DicDRI",SubNote,BDPDictionaryRowId)) 
          q:BDPDictionaryRowId=""  
       
          s str= $g(^User.BDPDataDictionaryD(BDPDictionaryRowId))   
          s BDPDictionaryCode = $listget(str,2)
          s BDPDictionaryDesc=$listget(str,3) 
          d CategoryOutputRow  
    }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
CategoryOutputRow
    set Data=$lb(BDPDictionaryRowId,BDPDictionaryCode,BDPDictionaryDesc)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetCategoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCategoryListExecute ]
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

ClassMethod GetCategoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCategoryListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function：查询 所属目录 的树形列表, 只能显示 右侧没数据的目录; 有数据就是一个字典,而不是目录
/// Creator： sunfengchao
/// CreatDate: 2018-10-26 
/// Input：  parentcatdr 父节点 
/// Return： treegrid格式数据串
/// Debug:   w ##class(web.DHCBL.BDP.BDPDataDictionary).GetComboTreeList("")
ClassMethod GetComboTreeList(parentcatdr As %String) As %String
{
    s IDStr=""
    if (parentcatdr="") s parentcatdr=-100000000000000
    
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
        s myRowID=$o(^User.BDPDataDictionaryI("BDPParentMenuDrI",parentcatdr,myRowID)) 
        q:myRowID=""
        s result=##class(web.DHCBL.BDP.BDPDataDictionary).AllowAddNexNode(myRowID)
        continue:result=1
        s BDPDictionaryDR=$listget(^User.BDPDataDictionaryD(myRowID),4)
        continue:BDPDictionaryDR'=""
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
        s Code=$LISTGET($G(^User.BDPDataDictionaryD(myRowID)),2)   //代码
        s Caption=$LISTGET($G(^User.BDPDataDictionaryD(myRowID)),3)   //描述
        if count>1 w ","
        w "{""id"":"""_myRowID_""",""text"":"""_Caption_"""" 
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
    w "]"
    q ""
}

/// Function：获取某个父节点下的所有子节点 用^连接，并按照顺序排列  
/// Creator： sunfengchao
/// CreatDate: 2018-10-13 
/// Table：   BDP_DataDictionary
/// Input：   LastLevel
/// Return： 所有子节点 用^连接
/// w ##class(web.DHCBL.BDP.BDPDataDictionary).GetChildOrderedIDStr("")
/// Function ： 查询字典数据列表 (右侧grid列表)
/// Creator：  sunfengchao
/// CreatDate: 2018-08-23 
/// Table：    BDP_DataDictionary
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataDictionary", "GetList","","18","","")
Query GetList(rowid As %String, dictorydr As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BDPDictionaryCode,BDPDictionaryDesc,BDPDictionaryDateFrom,BDPDictionaryDateTo,BDPDictionaryText1,BDPDictionaryText2,BDPDictionaryText3,BDPDictionaryText4,BDPDictionaryText5,BDPDictionaryText6,BDPDictionaryText7,BDPDictionaryText8,BDPDictionaryText9,BDPDictionaryText10,BDPDictionaryText11,BDPDictionaryText12,BDPDictionaryText13,BDPDictionaryText14,BDPDictionaryText15,BDPDictionaryText16,BDPDictionaryText17,BDPDictionaryText18,BDPDictionaryText19,BDPDictionaryText20,BDPDictionaryText21,BDPDictionaryText22,BDPDictionaryText23,BDPDictionaryText24,BDPDictionaryText25,BDPDictionaryRowId:%String,BDPDictionaryDR")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, dictorydr As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1  
 if (rowid'="")  
 {
      s str= $g(^User.BDPDataDictionaryD(rowid)) 
      s BDPDictionaryRowId=rowid 
      s BDPDictionaryCode = $listget(str,2)
      s BDPDictionaryDesc=$listget(str,3)
      s BDPDictionaryDR=  $listget(str,4) 
      s BDPDictionaryDateFrom=$listget(str,5)
      s BDPDictionaryDateTo=$listget(str,6) 
      s:BDPDictionaryDateFrom'="" BDPDictionaryDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BDPDictionaryDateFrom)   
      s:BDPDictionaryDateTo'="" BDPDictionaryDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BDPDictionaryDateTo)   
      s BDPDictionaryText1 =$listget(str,7) 
      s BDPDictionaryText2 =$listget(str,8) 
      s BDPDictionaryText3 =$listget(str,9) 
      s BDPDictionaryText4 =$listget(str,10) 
      s BDPDictionaryText5 =$listget(str,11) 
      s BDPDictionaryText6 =$listget(str,12) 
      s BDPDictionaryText7 =$listget(str,13) 
      s BDPDictionaryText8 =$listget(str,14) 
      s BDPDictionaryText9 =$listget(str,15) 
      s BDPDictionaryText10 =$listget(str,16)  
      s BDPDictionaryText11 =$listget(str,17) 
      s BDPDictionaryText12=$listget(str,18) 
      s BDPDictionaryText13=$listget(str,19) 
      s BDPDictionaryText14=$listget(str,20) 
      s BDPDictionaryText15 =$listget(str,21)
      s BDPDictionaryText16 =$listget(str,22) 
      s BDPDictionaryText17 =$listget(str,23)  
      s BDPDictionaryText18 =$listget(str,24) 
      s BDPDictionaryText19=$listget(str,25) 
      s BDPDictionaryText20=$listget(str,26) 
      s BDPDictionaryText21=$listget(str,27) 
      s BDPDictionaryText22 =$listget(str,28)
      s BDPDictionaryText23=$listget(str,29) 
      s BDPDictionaryText24=$listget(str,30) 
      s BDPDictionaryText25 =$listget(str,31)   
      d ListOutputRow
 }
 else
 {   
     if (dictorydr="") 
     {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK
     }
     else
     {  
         s BDPDictionaryRowId=0
         for
         { 
              s BDPDictionaryRowId=$o(^User.BDPDataDictionaryD(BDPDictionaryRowId)) 
              q:BDPDictionaryRowId=""
               
              s str= $g(^User.BDPDataDictionaryD(BDPDictionaryRowId))  
              s BDPDictionaryDR=$listget(str,4) 
              if (BDPDictionaryDR=dictorydr)
              {  
                     s BDPDictionaryCode = $listget(str,2)
                     s BDPDictionaryDesc=$listget(str,3)
                     s BDPDictionaryDR=$listget(str,4)
                     s BDPDictionaryDateFrom=$listget(str,5)
                     s BDPDictionaryDateTo=$listget(str,6) 
                     s:BDPDictionaryDateFrom'="" BDPDictionaryDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BDPDictionaryDateFrom)   
                     s:BDPDictionaryDateTo'="" BDPDictionaryDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(BDPDictionaryDateTo)   
                    
                  
                      ///  字典的数据有 BDPDictionaryDR 需要对dr进行转换 
                      s BDPDictionaryText1 =$listget(str,7) 
                      s BDPDictionaryText2 =$listget(str,8) 
                      s BDPDictionaryText3 =$listget(str,9) 
                      s BDPDictionaryText4 =$listget(str,10) 
                      s BDPDictionaryText5 =$listget(str,11) 
                      s BDPDictionaryText6 =$listget(str,12) 
                      s BDPDictionaryText7 =$listget(str,13) 
                      s BDPDictionaryText8 =$listget(str,14) 
                      s BDPDictionaryText9 =$listget(str,15) 
                      s BDPDictionaryText10 =$listget(str,16)  
                      s BDPDictionaryText11 =$listget(str,17) 
                      s BDPDictionaryText12=$listget(str,18) 
                      s BDPDictionaryText13=$listget(str,19) 
                      s BDPDictionaryText14=$listget(str,20) 
                      s BDPDictionaryText15 =$listget(str,21) 
                      s BDPDictionaryText16 =$listget(str,22) 
                      s BDPDictionaryText17 =$listget(str,23)  
                      s BDPDictionaryText18 =$listget(str,24) 
                      s BDPDictionaryText19=$listget(str,25) 
                      s BDPDictionaryText20=$listget(str,26) 
                      s BDPDictionaryText21=$listget(str,27) 
                      s BDPDictionaryText22 =$listget(str,28)
                      s BDPDictionaryText23=$listget(str,29) 
                      s BDPDictionaryText24=$listget(str,30) 
                      s BDPDictionaryText25 =$listget(str,31) 
                      
                      if (BDPDictionaryDR'="")
                      { 
                          s BDPComboDRStr=##class(web.DHCBL.BDP.BDPDictionaryConfig).GetDRValue(BDPDictionaryRowId) 
                          for j=1:1:$l(BDPComboDRStr,"#")
                          {
                             s BDPComStr=$P(BDPComboDRStr,"#",j)
                             s BDPComstr2=$P(BDPComStr,"^",2)_"^"_$P(BDPComStr,"^",3)_"^"_$P(BDPComStr,"^",4)
                             s index=$P(BDPComStr,"^",1) 
                             s Data=##class(web.DHCBL.BDP.BDPDictionaryConfig).GetDRByClassName(BDPComstr2) 
                             if (index=1) s BDPDictionaryText1 =Data 
                             if (index=2) s BDPDictionaryText2=Data  
                             if (index=3) s BDPDictionaryText3 =Data 
                             if (index=4) s BDPDictionaryText4=Data  
                             if (index=5) s BDPDictionaryText5 =Data 
                             if (index=6) s BDPDictionaryText6=Data  
                             if (index=7) s BDPDictionaryText7 =Data 
                             if (index=8) s BDPDictionaryText8=Data  
                             if (index=9) s BDPDictionaryText9 =Data 
                             if (index=10) s BDPDictionaryText10=Data  
                             if (index=11) s BDPDictionaryText11 =Data 
                             if (index=12) s BDPDictionaryText12=Data  
                             if (index=13) s BDPDictionaryText13 =Data 
                             if (index=14) s BDPDictionaryText14=Data  
                             if (index=15) s BDPDictionaryText15 =Data 
                             if (index=16) s BDPDictionaryText16=Data  
                             if (index=17) s BDPDictionaryText17 =Data 
                             if (index=18) s BDPDictionaryText18=Data  
                             if (index=19) s BDPDictionaryText19 =Data 
                             if (index=20) s BDPDictionaryText20=Data  
                             if (index=21) s BDPDictionaryText21 =Data 
                             if (index=22) s BDPDictionaryText22=Data  
                             if (index=23) s BDPDictionaryText23 =Data 
                             if (index=24) s BDPDictionaryText24=Data 
                             if (index=25) s BDPDictionaryText25=Data    
                      } 
                  } 
                  if ($zcvt(BDPDictionaryCode,"U")[($zcvt(code,"U")))&($zcvt(BDPDictionaryDesc,"U")[($zcvt(desc,"U")))
                  { 
                    d ListOutputRow
                  }
              }
            } 
        } 
 }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
ListOutputRow
    set Data=$lb(BDPDictionaryCode,BDPDictionaryDesc,BDPDictionaryDateFrom,BDPDictionaryDateTo,BDPDictionaryText1,BDPDictionaryText2,BDPDictionaryText3,BDPDictionaryText4,BDPDictionaryText5,BDPDictionaryText6,BDPDictionaryText7,BDPDictionaryText8,BDPDictionaryText9,BDPDictionaryText10,BDPDictionaryText11,BDPDictionaryText12,BDPDictionaryText13,BDPDictionaryText14,BDPDictionaryText15,BDPDictionaryText16,BDPDictionaryText17,BDPDictionaryText18,BDPDictionaryText19,BDPDictionaryText20,BDPDictionaryText21,BDPDictionaryText22,BDPDictionaryText23,BDPDictionaryText24,BDPDictionaryText25,BDPDictionaryRowId,BDPDictionaryDR)
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

/// Function ：查询字典定义时的扩展字段
/// Creator：  sunfengchao
/// CreatDate: 2018-10-11 
/// Table：    BDP_DataDictionary
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataDictionary", "GetPropertyConfigList","1")
Query GetPropertyConfigList(dictorydr As %String) As %Query(ROWSPEC = "BDPRowId,BDPCode,BDPValue,BDPPropertyType,BDPDRSource,BDPDRCode")
{
}

ClassMethod GetPropertyConfigListExecute(ByRef qHandle As %Binary, dictorydr As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    s list=""
    
    for BDPRowId=1:1:25
    { 
        s BDPCode="BDPDictionaryText"_BDPRowId
        if (dictorydr'="")
        {
            s str= $g(^User.BDPDataDictionaryD(dictorydr)) 
            s BDPValue=  $listget(str,+BDPRowId+6)   // 数据  
            ; 查询配置表
            s BDPConfigID=""
            s configstr="" 
            s BDPPropertyType=""
            s BDPDRCode=""
            if ($d(^User.BDPDictionaryConfigI("DictionaryDRIndex",dictorydr)))
            {
                s BDPConfigID=$O(^User.BDPDictionaryConfigI("DictionaryDRIndex",dictorydr,0))
                s configstr=$g(^User.BDPDictionaryConfigD(BDPConfigID)) 
                s BDPPropertyType=$listget(configstr,+BDPRowId+2)   // 数据 
                s BDPDRSource="" 
                if (BDPPropertyType["DR")
                { 
                    s BDPDRSource=$p(BDPPropertyType,"^",2)  
                    s BDPPropertyType =$p(BDPPropertyType,"^",1) 
                }
                s BDPDRCode=$listget(configstr,+BDPRowId+27)   
                if (BDPPropertyType["DR")  s BDPDRCode=##class(web.DHCBL.BDP.BDPDictionaryConfig).GetPropertySourceTable(BDPDRSource,BDPDRCode)
                if (BDPDRSource="BDPTableList") s BDPDRSource ="表结构登记"
                if (BDPDRSource="BDPDictionary") s BDPDRSource ="通用字典" 
            } 
        } 
        else
        {
            ; 新增数据时的情况 或者修改时没有扩展列 需要手动添加的情况
            s BDPValue= ""
            s BDPPropertyType=""
            s BDPDRSource=""
            s BDPDRCode=""
        }  
       d PropertyOutputRow       
     }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
PropertyOutputRow
    set Data=$lb(BDPRowId,BDPCode,BDPValue,BDPPropertyType,BDPDRSource,BDPDRCode)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPropertyConfigListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPropertyConfigListExecute ]
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

ClassMethod GetPropertyConfigListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPropertyConfigListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function ：查询字典数据时的字段值
/// Creator：  sunfengchao
/// CreatDate: 2018-10-11 
/// Table：    BDP_CoverageRatio
/// Others:    d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPDataDictionary", "GetPropertyList","1")
Query GetPropertyList(dictorydr As %String, rowid As %String) As %Query(ROWSPEC = "BDPRowId,BDPCode,BDPValue,BDPPropertyType,BDPDataSource,BDPPropertyDRCode")
{
}

ClassMethod GetPropertyListExecute(ByRef qHandle As %Binary, dictorydr As %String, rowid As %String) As %Status
{
    s repid=$I(^CacheTemp)
    s ind=1 
    if (dictorydr="")
    {
        Set qHandle=$lb(0,repid,0)
        Quit $$$OK 
    }
    s list=""
    s list=##class(web.DHCBL.BDP.BDPDictionaryConfig).GetColumnName(dictorydr)
    s len= $length(list,"^")  
 
    for BDPRowId=1:1:len
    { 
        s BDPCode=$p(list,"^",BDPRowId) 
        
        if (BDPCode'="")
        {
            if (rowid="")
            {
                s BDPValue=""  // 目录
                s flag=$d(^User.BDPDictionaryConfigI("DictionaryDRIndex",dictorydr)) 
                if (flag>0)
                {
                    s BDPConfigID=$O(^User.BDPDictionaryConfigI("DictionaryDRIndex",dictorydr,0))  
                    s BDPPropertyType=$listget($g(^User.BDPDictionaryConfigD(BDPConfigID)),+BDPRowId+2)
                    s BDPDataSource=""
                    if (BDPPropertyType["DR") 
                    {
                        s BDPDataSource=$p(BDPPropertyType,"^",2) 
                        s BDPPropertyType =$p(BDPPropertyType,"^",1) 
                    } 
                    s BDPPropertyDRCode=$listget($g(^User.BDPDictionaryConfigD(BDPConfigID)),+BDPRowId+27)
                }
            }
            else
            { 
                s str= $g(^User.BDPDataDictionaryD(rowid)) 
                s BDPValue= $listget(str,+BDPRowId+6)   // 数据   
                s BDPComboDRStr=##class(web.DHCBL.BDP.BDPDictionaryConfig).GetDRValue(rowid) 
                for j=1:1:$l(BDPComboDRStr,"#")
                {
                     s BDPComStr=$P(BDPComboDRStr,"#",j)
                     s BDPComstr2=$P(BDPComStr,"^",2)_"^"_$P(BDPComStr,"^",3)_"^"_$P(BDPComStr,"^",4)
                     s index=$P(BDPComStr,"^",1)
                     s Data=##class(web.DHCBL.BDP.BDPDictionaryConfig).GetDRByClassName(BDPComstr2) 
                     if (index=BDPRowId) s BDPValue =Data    
                } 
                s BDPPropertyType=""
                s BDPConfigID=""
                s flag=$d(^User.BDPDictionaryConfigI("DictionaryDRIndex",dictorydr)) 
                if (flag>0)
                {
                    s BDPConfigID=$O(^User.BDPDictionaryConfigI("DictionaryDRIndex",dictorydr,0))  
                    s BDPPropertyType=$listget($g(^User.BDPDictionaryConfigD(BDPConfigID)),+BDPRowId+2)
                    s BDPDataSource=""
                    if (BDPPropertyType["DR") 
                    {
                         s BDPDataSource=$p(BDPPropertyType,"^",2)  
                         s BDPPropertyType =$p(BDPPropertyType,"^",1)  
                    }
                    s BDPPropertyDRCode=$listget($g(^User.BDPDictionaryConfigD(BDPConfigID)),+BDPRowId+27)
                }
            }
           d PropertyListOutputRow
        }          
     }
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
PropertyListOutputRow
    set Data=$lb(BDPRowId,BDPCode,BDPValue,BDPPropertyType,BDPDataSource,BDPPropertyDRCode)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetPropertyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPropertyListExecute ]
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

ClassMethod GetPropertyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPropertyListExecute ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// Function：数据重复验证方法
/// Creator:sunfengchao
/// CreatDate:2018-09-05
/// Table:BDP_DataDictionary
/// Input：id-rowid, code-代码,desc-描述
/// Return："1"(数据重复),"0"(数据不重复)
/// Other: w ##class(web.DHCBL.BDP.BDPDataDictionary).FormValidate("55","110","d","d")
ClassMethod FormValidate(dictorydr As %String, id As %String, code As %String, desc As %String) As %String
{
    if dictorydr=""  s dictorydr=-100000000000000
    s:code'="" code=" "_$ZCONVERT(code,"U") //转换成大写
    s:desc'="" desc=" "_$ZCONVERT(desc,"U") //转换成大写
    s flag="",flagc="",flagd=""
    if ($d(^User.BDPDataDictionaryI("BDPDicCodeI",dictorydr)))
    { 
        s:code'="" flagc=$d(^User.BDPDataDictionaryI("BDPDicCodeI",dictorydr,code))
        s:desc'="" flagd=$d(^User.BDPDataDictionaryI("BDPDicDescI",dictorydr,desc))
        if (id="") //如果为空，增加时的重复判断
        {
            if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
            else  s flag=0 //返回不重复标志
        }
        else //如果不为空，修改时的重复判断
        {
            s idc="",idd=""
            s:code'="" idc=$o(^User.BDPDataDictionaryI("BDPDicCodeI",dictorydr,code,0))
            s:desc'="" idd=$o(^User.BDPDataDictionaryI("BDPDicDescI",dictorydr,desc,0)) 
            if ((idc'="")&(idc'=id)&(flagc>0))||((idd'="")&(idd'=id)&(flagd>0)) s flag=1  //返回重复标志
            else  s flag=0 //返回不重复标志
        }
    }
    q flag
}

/// Creator：   sunfengchao
/// CreatDate:  2018-06-05
/// Description 保存实体类数据
/// Table：     BDP_DataDictionary 
/// Others:     w ##class(web.DHCBL.BDP.BDPDataDictionary).SaveData("1")
ClassMethod SaveData(eobj As web.Entity.BDP.BDPDataDictionary, datalist As %String = "") As %String
{
  s result="",jsonstr=""   
  ; 需要判断 所属目录是否符合要求；选择的目录不能是 有数据的字典节点 ,也不可以是它本身节点及下一级节点 
  if (eobj.BDPDictionaryRowId'="")
  {
      if (eobj.BDPParentMenuDr=eobj.BDPDictionaryRowId) 
      {
        s result= "{success:'false',errorinfo:'不能将所属目录设置为本节点！'}"
        q result
      }
      s result=##class(web.DHCBL.BDP.BDPDataDictionary).CompareNextNode(eobj.BDPDictionaryRowId,eobj.BDPParentMenuDr)
      if (result=1)
      {
         s result= "{success:'false',errorinfo:'不能将所属目录设置为本节点的下级节点！'}"
         q result
      }
  }  
  s flag=..FormValidate(eobj.BDPDictionaryDR,eobj.BDPDictionaryRowId,eobj.BDPDictionaryCode,eobj.BDPDictionaryDesc)
  if (flag=1)
  {
      s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
        if (eobj.BDPDictionaryRowId="")                             
        { 
            s obj=##class(User.BDPDataDictionary).%New()
        }
        else                                                  
        { 
               s obj=##class(User.BDPDataDictionary).%OpenId(eobj.BDPDictionaryRowId)  
               s bobj=##class(web.Entity.BDP.BDPDataDictionary).%New()
               s bobj.BDPDictionaryRowId=eobj.BDPDictionaryRowId  
               s bobj.BDPDictionaryCode= obj.BDPDictionaryCode
               s bobj.BDPDictionaryDesc= obj.BDPDictionaryDesc 
               s bobj.BDPDictionaryDateFrom= obj.BDPDictionaryDateFrom
               s bobj.BDPDictionaryDateTo= obj.BDPDictionaryDateTo
               s:obj.BDPDictionaryDR'="" bobj.BDPDictionaryDR= obj.BDPDictionaryDR.%Id() 
            } 
          s:eobj.BDPDictionaryDateFrom'="" eobj.BDPDictionaryDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BDPDictionaryDateFrom)
          s:eobj.BDPDictionaryDateTo'="" eobj.BDPDictionaryDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BDPDictionaryDateTo)
                       
          s obj.BDPDictionaryCode= eobj.BDPDictionaryCode
          s obj.BDPDictionaryDesc= eobj.BDPDictionaryDesc   
          d:eobj.BDPParentMenuDr'="" obj.BDPParentMenuDrSetObjectId(eobj.BDPParentMenuDr) /// 所属目录
          d:eobj.BDPDictionaryDR'="" obj.BDPDictionaryDRSetObjectId(eobj.BDPDictionaryDR) 
          s obj.BDPDictionaryDateFrom= eobj.BDPDictionaryDateFrom
          s obj.BDPDictionaryDateTo= eobj.BDPDictionaryDateTo 
          ; 同时保存扩展出来的字段 
          if (eobj.BDPExtMenuDr'="")
          {     
            d obj.BDPExtMenuDrSetObjectId(eobj.BDPExtMenuDr)
            s liststr=""
            s liststr=##class(web.DHCBL.BDP.BDPDataDictionary).GetPropertyByTable(eobj.BDPExtMenuDr) 
           
            if (liststr'="")
            { 
                s listlen= $Length(liststr,"^")
                for i=1:1:listlen
                {
                    s data=$p(liststr,"^",i)  
                  
                    if i=1 s obj.BDPDictionaryText1=data 
                    if i=2 s obj.BDPDictionaryText2=data 
                    if i=3 s obj.BDPDictionaryText3=data 
                    if i=4 s obj.BDPDictionaryText4=data 
                    if i=5 s obj.BDPDictionaryText5=data 
                    if i=6 s obj.BDPDictionaryText6=data 
                    if i=7 s obj.BDPDictionaryText7=data 
                    if i=8 s obj.BDPDictionaryText8=data 
                    if i=9 s obj.BDPDictionaryText9=data 
                    if i=10 s obj.BDPDictionaryText10=data 
                    if i=11 s obj.BDPDictionaryText11=data 
                    if i=12 s obj.BDPDictionaryText12=data 
                    if i=13 s obj.BDPDictionaryText13=data 
                    if i=14 s obj.BDPDictionaryText14=data 
                    if i=15 s obj.BDPDictionaryText15=data 
                    if i=16 s obj.BDPDictionaryText16=data 
                    if i=17 s obj.BDPDictionaryText17=data 
                    if i=18 s obj.BDPDictionaryText18=data 
                    if i=19 s obj.BDPDictionaryText19=data 
                    if i=20 s obj.BDPDictionaryText20=data 
                    if i=21 s obj.BDPDictionaryText21=data 
                    if i=22 s obj.BDPDictionaryText22=data 
                    if i=23 s obj.BDPDictionaryText23=data 
                    if i=24 s obj.BDPDictionaryText24=data 
                    if i=25 s obj.BDPDictionaryText25=data    
                  } 
              }   
        }  
        else
        {
            if (datalist'="")
            {
                s datastr=""
                s listlen= $Length(datalist,"#")
                for i=1:1:listlen
                {
                    s datastr=$p(datalist,"#",i) 
                    s id=$P(datastr,"^",1) 
                    s data=$P(datastr,"^",2) 
                    if id=1 s obj.BDPDictionaryText1=data 
                    if id=2 s obj.BDPDictionaryText2=data 
                    if id=3 s obj.BDPDictionaryText3=data 
                    if id=4 s obj.BDPDictionaryText4=data 
                    if id=5 s obj.BDPDictionaryText5=data 
                    if id=6 s obj.BDPDictionaryText6=data 
                    if id=7 s obj.BDPDictionaryText7=data 
                    if id=8 s obj.BDPDictionaryText8=data 
                    if id=9 s obj.BDPDictionaryText9=data 
                    if id=10 s obj.BDPDictionaryText10=data 
                    if id=11 s obj.BDPDictionaryText11=data 
                    if id=12 s obj.BDPDictionaryText12=data 
                    if id=13 s obj.BDPDictionaryText13=data 
                    if id=14 s obj.BDPDictionaryText14=data 
                    if id=15 s obj.BDPDictionaryText15=data 
                    if i=16 s obj.BDPDictionaryText16=data 
                    if i=17 s obj.BDPDictionaryText17=data 
                    if i=18 s obj.BDPDictionaryText18=data 
                    if i=19 s obj.BDPDictionaryText19=data 
                    if i=20 s obj.BDPDictionaryText20=data 
                    if i=21 s obj.BDPDictionaryText21=data 
                    if i=22 s obj.BDPDictionaryText22=data 
                    if i=23 s obj.BDPDictionaryText23=data 
                    if i=24 s obj.BDPDictionaryText24=data 
                    if i=25 s obj.BDPDictionaryText25=data    
               }   
            }
        }
      Tstart
      s sc=obj.%Save() 
      d obj.%Close()
      If $$$ISOK(sc){
      Tc
      s id = obj.%Id()
      s result = "{success:'true',id:'"_id_"'}"  
      ; 同时保存字段的配置信息
      if ((eobj.BDPConfigFlag="Y")&(eobj.BDPExtMenuDr'=""))
      {   
        ;需要保存 配置字段的类型和指向表 
         d ##class(web.DHCBL.BDP.BDPDictionaryConfig).AutoSaveConfigInfo(id)
      }
      else
      {
        if ($p(datalist,"^",3)'="")
        {
          d ##class(web.DHCBL.BDP.BDPDictionaryConfig).SaveConfigInfo(id,datalist)  
        }  
      }
       d:eobj.BDPDictionaryRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_DataDictionary","User.BDPDataDictionary","通用数据字典",id,eobj.BDPDictionaryDesc,"A",eobj)
       d:eobj.BDPDictionaryRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_DataDictionary","User.BDPDataDictionary","通用数据字典",eobj.BDPDictionaryRowId,eobj.BDPDictionaryDesc,"U",eobj,bobj)
       
      }
      else
      {
       Trollback
       s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用数据字典","web.DHCBL.BDP.BDPDataDictionary","SaveEntity",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
      }  
     }  
  q result
}

/// Creator： sunfengchao
/// CreatDate: 2018-08-28
/// Description：删除 
/// Table：  w ##class(i).DeleteData(26)
ClassMethod DeleteData(id As %String) As %String
{
    s result=""  
    Tstart
    s obj=##class(User.BDPDataDictionary).%OpenId(id)
    s bobj = ##class(web.Entity.BDP.BDPDataDictionary).%New() 
    s bobj.BDPDictionaryRowId=id
    s bobj.BDPDictionaryCode= obj.BDPDictionaryCode
    s bobj.BDPDictionaryDesc= obj.BDPDictionaryDesc 
    s bobj.BDPDictionaryDateFrom= obj.BDPDictionaryDateFrom
    s bobj.BDPDictionaryDateTo= obj.BDPDictionaryDateTo
    s:obj.BDPDictionaryDR'="" bobj.BDPDictionaryDR= obj.BDPDictionaryDR.%Id() 
    s:obj.BDPParentMenuDr'="" bobj.BDPParentMenuDr= obj.BDPParentMenuDr.%Id() 
    s:obj.BDPExtMenuDr'="" bobj.BDPExtMenuDr=obj.BDPExtMenuDr.%Id()
    s sc=obj.%DeleteId(id)
    IF $$$ISOK(sc)
    {
       Tc
       s result="{success:'true',info:'删除成功！'}"
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_DataDictionary","User.BDPDataDictionary","通用字典",id,bobj.BDPDictionaryDesc,"D",bobj)
    }
    else
    {
       Trollback
       s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用字典","web.DHCBL.BDP.BDPDataDictionary","DeleteData",bobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   } 
    q result
}

/// Creator： sunfengchao
/// CreatDate: 2018-08-28
/// Description：删除字典数据,同时删除对应字典下的数据
/// Table：  w ##class(web.DHCBL.BDP.BDPDataDictionary).DeleteDicData(26)
ClassMethod DeleteDicData(id As %String) As %String
{
    s result=""  
    Tstart
    s obj=##class(User.BDPDataDictionary).%OpenId(id)
    s bobj = ##class(web.Entity.BDP.BDPDataDictionary).%New() 
    s bobj.BDPDictionaryRowId=id
    s bobj.BDPDictionaryCode= obj.BDPDictionaryCode
    s bobj.BDPDictionaryDesc= obj.BDPDictionaryDesc 
    s bobj.BDPDictionaryDateFrom= obj.BDPDictionaryDateFrom
    s bobj.BDPDictionaryDateTo= obj.BDPDictionaryDateTo
    s:obj.BDPDictionaryDR'="" bobj.BDPDictionaryDR= obj.BDPDictionaryDR.%Id()  
    s sc=obj.%DeleteId(id)
    IF $$$ISOK(sc)
    {
       ; 同时删除 字典数据
       s DicRowId=0
       for
       {
          s DicRowId= $O(^User.BDPDataDictionaryI("DicDRI",id,DicRowId))
          q:DicRowId=""
          s sc=..DeleteData(DicRowId)
       }
       Tc
       s result="{success:'true',info:'删除成功！'}"
       d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_DataDictionary","User.BDPDataDictionary",obj.BDPDictionaryDesc,id,bobj.BDPDictionaryDesc,"D",bobj)
    }
    else
    {
       Trollback
       s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
       s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用字典","web.DHCBL.BDP.BDPDataDictionary","DeleteData",bobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
   } 
    q result
}

/// Creator:    sunfengchao
/// CreatDate:  2018-08-29
/// Description：修改时打开的数据
/// Input：     id 
/// Return:Json格式的字符串{"CTSPECRActiveFlag":"Y","CTSPECRCode":"PUBLIC","CTSPECRDesc":"公共","CTSPECRRowId":"9"}
/// Other: w ##class(web.DHCBL.BDP.BDPDataDictionary).NewOpenData("9")
ClassMethod NewOpenData(id As %String) As %String
{
    s str="" 
    s obj = ##class(User.BDPDataDictionary).%OpenId(id)
    s bobj = ##class(web.Entity.BDP.BDPDataDictionary).%New() 
    s bobj.BDPDictionaryRowId=id
    s bobj.BDPDictionaryCode= obj.BDPDictionaryCode
    s bobj.BDPDictionaryDesc= obj.BDPDictionaryDesc 
    s bobj.BDPDictionaryDateFrom= obj.BDPDictionaryDateFrom
    s bobj.BDPDictionaryDateTo= obj.BDPDictionaryDateTo
    s:bobj.BDPDictionaryDateFrom'="" bobj.BDPDictionaryDateFrom=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(bobj.BDPDictionaryDateFrom)  
    s:bobj.BDPDictionaryDateTo'="" bobj.BDPDictionaryDateTo=##class(web.DHCBL.BDP.FunLib).DateLogicalToHtml(bobj.BDPDictionaryDateTo)  
    s:obj.BDPDictionaryDR'="" bobj.BDPDictionaryDR= obj.BDPDictionaryDR.%Id() 
    s:obj.BDPParentMenuDr'="" bobj.BDPParentMenuDr= obj.BDPParentMenuDr.%Id() 
    s bobj.BDPExtMenuDr=$LISTGET($G(^User.BDPDataDictionaryD(id)),33) 
    s str = bobj.JsonS()    
    d bobj.%Close()
    d obj.%Close()
    q str
}

/// Function: 通过表结构登记来获取字段 用于新增字典时
/// Creator:  sunfengchao
/// CreateDate:2018-08-30
/// Debug:    w ##class(web.DHCBL.BDP.BDPDataDictionary).GetPropertyByTable("CTTitle")
ClassMethod GetPropertyByTable(tableid As %String)
{
  if tableid="" quit ""
  set resultstr="" 
  set ParRef=tableid 
  s ID=0
  for
  {
    s ID=$o(^User.BDPTableListD(ParRef,"ChildField",ID)) 
    q:ID=""  
    s FieldRowId=ParRef_"||"_ID
    s FieldParRef=ParRef
    s FieldName=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),3)
    s FieldDesc=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),2)
    
    if ((FieldDesc["RowId")||($ZCONVERT(FieldDesc,"U")["开始日期")||($ZCONVERT(FieldDesc,"U")["结束日期")||($ZCONVERT(FieldDesc,"U")["代码")||($ZCONVERT(FieldDesc,"U")["描述"))||(FieldName["Desc") 
    { 
        continue
    }
    else
    {    
        if resultstr=""
        {
            set resultstr=FieldDesc
        }
        else
        {
            set resultstr=resultstr_"^"_FieldDesc
        }  
    }   
   }
   quit resultstr
}

/// Function: 通过表结构登记来获取字段类型  
/// Creator:  sunfengchao
/// CreateDate:2018-09-08
/// Debug:    w ##class(web.DHCBL.BDP.BDPDataDictionary).GetExtendPropertyType(81)
ClassMethod GetExtendPropertyType(tableid As %String)
{
  if tableid="" quit ""
  set resultstr="" 
  set ParRef=tableid 
  s ID=0
  for
  {
    s ID=$o(^User.BDPTableListD(ParRef,"ChildField",ID)) 
    q:ID=""  
    s FieldRowId=ParRef_"||"_ID
    s FieldParRef=ParRef
    s FieldName=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),3)
    s FieldDesc=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),2) 
    if ((FieldDesc["RowId")||($ZCONVERT(FieldDesc,"U")["开始日期")||($ZCONVERT(FieldDesc,"U")["结束日期")||($ZCONVERT(FieldDesc,"U")["代码")||($ZCONVERT(FieldDesc,"U")["描述"))||(FieldName["Desc") 
    { 
        continue
    }
    else
    {    
        s FieldTabCode=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),4)
        s FieldType=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),5)
        if resultstr=""
        {
            set resultstr=FieldType_"^"_FieldTabCode
        }
        else
        {
            set resultstr=resultstr_"#"_FieldType_"^"_FieldTabCode
        }  
    }   
   }
   quit resultstr
}

/// Function:获取字典表的字段列表和字段类型
/// Creator: sunfengchao
/// CreateDate:2018-09-06
/// Debug:   w ##class(web.DHCBL.BDP.BDPDataDictionary).GetPropertyList()
ClassMethod GetPropertyList(dictorydr As %String) As %String
{
     s result=""
     if dictorydr="" q "" 
     s str= $g(^User.BDPDataDictionaryD(dictorydr))
     if str="" q ""  
     ; 查看是关联的哪个表
     s BDPExtMenuDr =$listget(^User.BDPDataDictionaryD(dictorydr),23)  // 表结构登记的数据ID 
     for i=1:1:25
     {
       s BDPValue=  $listget(str,+i+6)   // 数据 
       s BDPType="^"
       if (BDPExtMenuDr'="")
       {
         s BDPType= ..FindPropertyType(dictorydr,BDPValue)
       }
       if (result="")
       {
            s result=BDPType
       }
       else
       {
            s result=result_"#"_BDPType
       }
     }
     q result
}

/// Function: 根据字段描述去查询表结构 找到字段的类型
/// Creator: sunfengchao
/// CreateDate:2018-09-06
/// Debug:   w ##class(web.DHCBL.BDP.BDPDataDictionary).FindPropertyType("15","代码")
ClassMethod FindPropertyType(dictorydr As %String, PropertyDesc As %String) As %String
{
    s RowId="" 
    s result=""
    s FieldType=""
    s FieldTabCode="" 
    q:PropertyDesc="" ""
    s PropertyDesc=" "_$zcvt(PropertyDesc,"U")  
    s BDPExtMenuDr =$listget(^User.BDPDataDictionaryD(dictorydr),23)  // 表结构登记的数据ID 
    s RowId=$o(^User.BDPTableFieldI("DescIndex",PropertyDesc,BDPExtMenuDr,0))
    if RowId="" q "" 
    s FieldType=$LISTGET($G(^User.BDPTableListD(BDPExtMenuDr,"ChildField",RowId)),5)
    s FieldTabCode=$LISTGET($G(^User.BDPTableListD(BDPExtMenuDr,"ChildField",RowId)),4)  ///DR 执向哪个表  
    s result=FieldType_"^"_FieldTabCode
    q result
}

/// Function:判断左侧字典目录是否可以新增右侧列表里的数据
/// Creator: sunfengchao
/// CreateDate:2018-09-17
/// Debug:  w ##class(web.DHCBL.BDP.BDPDataDictionary).AllowAddDataFlag()
ClassMethod AllowAddDataFlag(id As %String) As %String
{
    if id="" q ""
    s result=""
    s SubNote="-100000000000000"
    ;ParentMenuDr 为空 且 DictionaryDr 为空 则不允许新增数据
    if ($d(^User.BDPDataDictionaryI("DicDRI",SubNote,id)))  
    {
        if ($d(^User.BDPDataDictionaryI("BDPParentMenuDrI",id))) 
        {
            s result=1  ///不允许新增 右侧的数据
        }
        else
        {   
            s result=0
        }
    }
    else
    {
       s result=0 
    }
    q result
}

/// Function:判断是否可以新增 同级或者下级目录
/// Creator: sunfengchao
/// CreateDate:2018-09-17
/// Debug:  w ##class(web.DHCBL.BDP.BDPDataDictionary).AllowAddDictionFlag()
ClassMethod AllowAddDictionFlag(id As %String) As %String
{
    if id="" q ""
    s result="" 
    ;ParentMenuDr 为空 且 DictionaryDr 为空 则不允许下级目录
    if ($d(^User.BDPDataDictionaryI("DicDRI","-100000000000000",id)))  
    {  
       if ($d(^User.BDPDataDictionaryI("BDPParentMenuDrI",-100000000000000,id)))
       {
            s result=1 
       }
       else
       {
           if ($d(^User.BDPDataDictionaryI("BDPParentMenuDrI",id))) 
           { 
              s result=1 /// 允许新增 下一级
           }
           else
           {   
             s result=0 /// 不允许 新增 下一级
           }
       }  
      q result
    }
}

/// Function:比较日期大小
/// CreateDate:2018-10-19
/// Creator: sunfengchao
ClassMethod CompareDate(DateFrom As %String, DateTo As %String)
{
    s result=0
    s:DateFrom'="" DateFrom=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(DateFrom)
    s:DateTo'="" DateTo=##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(DateTo)
    s result=DateFrom>DateTo
    q result
}

/// Function: 判断字典是否具有数据,用于控制右键菜单的权限控制,当字典有数据时则不允许增加下一级菜单
/// Creator:  sunfengchao
/// CraeteDate:2018-10-24
/// return:   0: 允许 1 不允许
/// Debug:    w ##class(web.DHCBL.BDP.BDPDataDictionary).AllowAddNexNode()
ClassMethod AllowAddNexNode(nodeid As %String) As %String
{
    s result=""
    q:nodeid="" ""
    s flag=0
    s flag=$d(^User.BDPDataDictionaryI("DicDRI",nodeid))
    if (flag>0) s result=1
    else  s result=0
    q result
}

/// Function:根据rowid获取表名称
/// Creator: sunfengchao
/// CreateDate:2018-10-26
/// Debug:   w ##class(web.DHCBL.BDP.BDPDataDictionary).GetDescByRowId()
ClassMethod GetDescByRowId(DataSource As %String, DataValue As %String) As %String
{
    q:(DataSource=""||DataValue="") ""
    s result="" 
    if (DataSource="BDPTableList")
    {
        ; 根据 值id去表结构登记里找数据的描述 
        s result=$LISTGET($G(^User.BDPTableListD(DataValue)),3) 
    }
    elseif (DataSource="BDPDictionary")
    {
         s result=$LISTGET($G(^User.BDPDataDictionaryD(DataValue)),3) 
    } 
    q result
}

/// Function:判断该节点是不是本节点的下级节点
/// Creator: sunfengchao
/// CreateDate:2018-10-26
/// Output : 0  不是下级节点 1 是下级节点
/// Debug:   w ##class(web.DHCBL.BDP.BDPDataDictionary).CompareNextNode()
ClassMethod CompareNextNode(nodeid As %String, CompareNodeid As %String)
{
    q:(nodeid=""||CompareNodeid="") ""
    s result=0
    s flag=$d(^User.BDPDataDictionaryI("BDPParentMenuDrI",nodeid))  
    if (flag>0)
    {
        s NextNode=0
        for
        {
            s NextNode =$O(^User.BDPDataDictionaryI("BDPParentMenuDrI",nodeid,NextNode))
            q:NextNode=""
            if (NextNode=CompareNodeid)
            {
                s result=1
            }
            else
            {
                continue
            }
        }
    }
    else
    {
        s result=0 
    }
    q result
}

/// Creator：   sunfengchao
/// CreatDate:  2018-06-05
/// Description 保存实体类数据
/// Table：     BDP_DataDictionary 
/// Others:     w ##class(web.DHCBL.BDP.BDPDataDictionary).ImportData("1")
ClassMethod ImportData(eobj As web.Entity.BDP.BDPDataDictionary, datalist As %String = "") As %String
{
  s result="",jsonstr=""   
  ; 需要判断 所属目录是否符合要求；选择的目录不能是 有数据的字典节点 ,也不可以是它本身节点及下一级节点 
  if (eobj.BDPDictionaryRowId'="")
  {
      if (eobj.BDPParentMenuDr=eobj.BDPDictionaryRowId) 
      {
        s result= "{success:'false',errorinfo:'不能将所属目录设置为本节点！'}"
        q result
      }
      s result=##class(web.DHCBL.BDP.BDPDataDictionary).CompareNextNode(eobj.BDPDictionaryRowId,eobj.BDPParentMenuDr)
      if (result=1)
      {
         s result= "{success:'false',errorinfo:'不能将所属目录设置为本节点的下级节点！'}"
         q result
      }
  }  
  s flag=..FormValidate(eobj.BDPDictionaryDR,eobj.BDPDictionaryRowId,eobj.BDPDictionaryCode,eobj.BDPDictionaryDesc)
  if (flag=1)
  {
      s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
        if (eobj.BDPDictionaryRowId="")                             
        { 
            s obj=##class(User.BDPDataDictionary).%New()
        }
        else                                                  
        { 
           s obj=##class(User.BDPDataDictionary).%OpenId(eobj.BDPDictionaryRowId)  
           s bobj=##class(web.Entity.BDP.BDPDataDictionary).%New()
           s bobj.BDPDictionaryRowId=eobj.BDPDictionaryRowId  
           s bobj.BDPDictionaryCode= obj.BDPDictionaryCode
           s bobj.BDPDictionaryDesc= obj.BDPDictionaryDesc 
           s bobj.BDPDictionaryDateFrom= obj.BDPDictionaryDateFrom
           s bobj.BDPDictionaryDateTo= obj.BDPDictionaryDateTo
           s:obj.BDPDictionaryDR'="" bobj.BDPDictionaryDR= obj.BDPDictionaryDR.%Id() 
        } 
      s:eobj.BDPDictionaryDateFrom'="" eobj.BDPDictionaryDateFrom = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BDPDictionaryDateFrom)
      s:eobj.BDPDictionaryDateTo'="" eobj.BDPDictionaryDateTo = ##class(web.DHCBL.BDP.FunLib).DateHtmlToLogical(eobj.BDPDictionaryDateTo)
                   
      s obj.BDPDictionaryCode= eobj.BDPDictionaryCode
      s obj.BDPDictionaryDesc= eobj.BDPDictionaryDesc   
      d:eobj.BDPParentMenuDr'="" obj.BDPParentMenuDrSetObjectId(eobj.BDPParentMenuDr) /// 所属目录
      d:eobj.BDPDictionaryDR'="" obj.BDPDictionaryDRSetObjectId(eobj.BDPDictionaryDR) 
      s obj.BDPDictionaryDateFrom= eobj.BDPDictionaryDateFrom
      s obj.BDPDictionaryDateTo= eobj.BDPDictionaryDateTo 
          
          
      ; 同时保存扩展出来的字段 
      d obj.BDPExtMenuDrSetObjectId(eobj.BDPExtMenuDr) 
      s obj.BDPDictionaryText1=eobj.BDPDictionaryText1 
      s obj.BDPDictionaryText2=eobj.BDPDictionaryText2 
      s obj.BDPDictionaryText3=eobj.BDPDictionaryText3
      s obj.BDPDictionaryText4=eobj.BDPDictionaryText4
      s obj.BDPDictionaryText5= eobj.BDPDictionaryText5 
      s obj.BDPDictionaryText6=eobj.BDPDictionaryText6
      s obj.BDPDictionaryText7=eobj.BDPDictionaryText7
      s obj.BDPDictionaryText8=eobj.BDPDictionaryText8 
      s obj.BDPDictionaryText9=eobj.BDPDictionaryText9
      s obj.BDPDictionaryText10=eobj.BDPDictionaryText10
      s obj.BDPDictionaryText11=eobj.BDPDictionaryText11 
      s obj.BDPDictionaryText12=eobj.BDPDictionaryText12 
      s obj.BDPDictionaryText13=eobj.BDPDictionaryText13  
      s obj.BDPDictionaryText14=eobj.BDPDictionaryText14  
      s obj.BDPDictionaryText15=eobj.BDPDictionaryText15   
        
      Tstart
      s sc=obj.%Save() 
      d obj.%Close()
      If $$$ISOK(sc){
      Tc
      s id = obj.%Id()
      s result = "{success:'true',id:'"_id_"'}"   
       d:eobj.BDPDictionaryRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_DataDictionary","User.BDPDataDictionary","通用数据字典",id,eobj.BDPDictionaryDesc,"A",eobj)
       d:eobj.BDPDictionaryRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_DataDictionary","User.BDPDataDictionary","通用数据字典",eobj.BDPDictionaryRowId,eobj.BDPDictionaryDesc,"U",eobj,bobj)
       
      }
      else
      {
       Trollback
       s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("通用数据字典","web.DHCBL.BDP.BDPDataDictionary","SaveEntity",eobj)
       s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
      }  
     }  
  q result
}

/// Function:判断左侧字典 节点是不是存在
/// Creator: sunfengchao
/// CreateDate:2022-10-13
/// Output : 0  不存在 1 存在
/// Debug:   w ##class(web.DHCBL.BDP.BDPDataDictionary).IfNodeExist()
ClassMethod IfNodeExist(nodeid As %String)
{
    q:nodeid="" "" 
    s flag=$d(^User.BDPDataDictionaryD(nodeid))  
    if (flag>0)
    {
        s result=1
    }
    else
    {
        s result=0 
    }
    q result
}

}
