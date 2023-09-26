/// Function:通过参数对getlist进行排序
/// Creator: sunfengchao
/// CreateDate:2016-7-1
Class web.DHCBL.BDP.BDPSortByParams Extends %RegisteredObject
{

/// Function: 根据拼音码生成索引 用于排序
/// Creator: sunfengchao
/// CreateDate:2016-7-1
///  d ##class(web.DHCBL.BDP.BDPSortByParams).GetSortbyParams()
ClassMethod GetSortbyParams(className, desc, rowid)
{
 
   s ^TMP("BDPSortByParams","sort",className,desc,rowid)=className_"^"_desc_"^"_rowid
   q ""
}

/// Function: 获取排序后的数据id,用于getlist排序
/// Creator: sunfengchao
/// CreateDate:2016-7-1
///  w ##class(web.DHCBL.BDP.BDPSortByParams).GetSortDataId("web.DHCBL.CT.ARCBillGrp")
ClassMethod GetSortDataId(className As %String)
{
  s PinYin="",IDStr=""
  for
  {
    s PinYin=$o(^TMP("BDPSortByParams","sort",className,PinYin))
    q:PinYin=""
    if ($e(PinYin,1)=0)
    {
      s ID=0
      for
      {
        s ID=$o(^TMP("BDPSortByParams","sort",className,PinYin,ID))  
        q:ID=""
        if (IDStr=""){
          s IDStr= ID  
        }
        else
        {
          s IDStr=IDStr_"^"_ID  
        }
      }
     }
     else
     {
       continue
     }
    }
    
   s PinYin="" 
   for
   {
    s PinYin=$o(^TMP("BDPSortByParams","sort",className,PinYin))
    q:PinYin=""
    if ($e(PinYin,1)'=0)
    {
    s ID=0
    for
    {
      s ID=$o(^TMP("BDPSortByParams","sort",className,PinYin,ID))  
      q:ID=""
      if (IDStr=""){
        s IDStr= ID  
      }
      else
      {
        s IDStr=IDStr_"^"_ID  
      }
    }
   }
   else{
        continue 
      }
  }
  q IDStr
}

/// Function: 获取排序后的数据id,用于getlist排序 用于ID数据超长的处理
/// Creator: sunfengchao
/// CreateDate:2016-9-2
///  w ##class(web.DHCBL.BDP.BDPSortByParams).GetSortDataIDS("web.DHCBL.CT.SSUser")
ClassMethod GetSortDataIDS(className As %String) As %Library.ListOfDataTypes
{
  s PinYin=""
  Set PLIST = ##class(%Library.ListOfDataTypes).%New()
  for
  {
    s PinYin=$o(^TMP("BDPSortByParams","sort",className,PinYin))
    q:PinYin=""
    if ($e(PinYin,1)=0)
    {
      s ID=0
      for
      {
        s ID=$o(^TMP("BDPSortByParams","sort",className,PinYin,ID))  
        q:ID=""
        d PLIST.Insert("'"_ID_"'")  
      }    
    }
    else
    {
      continue
    }
  }
   s PinYin="" 
   for
   {
    s PinYin=$o(^TMP("BDPSortByParams","sort",className,PinYin))
    q:PinYin=""
    if ($e(PinYin,1)'=0)
    {
        s ID=0
        for
        {
          s ID=$o(^TMP("BDPSortByParams","sort",className,PinYin,ID))  
          q:ID=""
          d PLIST.Insert("'"_ID_"'")
        }
   }
   else{
        continue 
      }
  }
  
  q PLIST
}

}
