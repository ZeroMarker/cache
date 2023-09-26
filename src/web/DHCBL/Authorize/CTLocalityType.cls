/// Function: 地理信息- 街道 授权类
/// Creator:  sunfengchao
/// CreateDate: 2015-11-12
Class web.DHCBL.Authorize.CTLocalityType Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "CT_LocalityType";

Parameter EntityClassName = "web.Entity.CT.CTLocalityType";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.ARCTariff).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
  s strAutMenu=##class(web.DHCBL.Authorize.CTLocalityType).DHCGetDataByReference(ObjectType,ObjectReference)
  q strAutMenu
}

ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK) As %String
{
 if (ParentID="menuTreeRoot") s ParentID=-100000000000000
 s myJsonStr=""
 s myImage=""
 //获取授权JSON
 s AuStr=##class(web.DHCBL.Authorize.CTLocalityType).DHCGetDataByReference(ObjectType,ObjectReference)    
 s count=0
 s end=start+limit
 s rowid=0
 for{
   s rowid=$o(^CT("LOCTYPE",rowid))
   q:rowid=""  
     
   s AuStr2="{ID:"_rowid_"}"
   if (FilterCK="checked")
   {
     if (AuStr[AuStr2) 
     else  continue
   }
   elseif (FilterCK="unchecked") 
   {
     if (AuStr[AuStr2) continue
     else  
  }
     
  s type=$p($g(^CT("LOCTYPE",rowid)),"^",4)
  if ($zcvt(type,"U")'="S") 
  {
     continue
  }
   else 
   { 
     s desc=$p($g(^CT("LOCTYPE",rowid)),"^",2)
     if (desc'="")&($ZCONVERT(desc,"U")[$ZCONVERT(query,"U")){
     s count=count+1
     if ((count>start) & (count<=end)) || (end=0)
     {
       s AuStr2="{ID:"_rowid_"}"
       if (AuStr[AuStr2) s myEnable=1
       else  s myEnable=0
    
       s:(myJsonStr'="") myJsonStr=myJsonStr_","
       s myJsonStr=myJsonStr_"{"
       s myJsonStr=myJsonStr_"""id"":"""_""_rowid_""",""text"":"""_desc_""","
    
       if (+myEnable)
       {
         s myJsonStr=myJsonStr_"""checked"":true,"
       }
       else
       {
         s myJsonStr=myJsonStr_"""checked"":false,"
        }
       s myJsonStr=myJsonStr_"""leaf"":true"
       s myJsonStr=myJsonStr_"}"
    }
  }  
 }
}
  s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"
  q myJsonStr
}

}
