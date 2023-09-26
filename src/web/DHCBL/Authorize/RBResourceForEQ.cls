/// Function: 资源预约-指定资源到科室 授权类
/// Creator:  sunfengchao
/// CreateDate: 2015-4-10
Class web.DHCBL.Authorize.RBResourceForEQ Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "RB_Resource";

Parameter EntityClassName = "web.Entity.CT.RBResource";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.RBResourceForEQ).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
  s strAutMenu=##class(web.DHCBL.Authorize.RBResourceForEQ).DHCGetDataByReference(ObjectType,ObjectReference)
  q strAutMenu
}

/// 一级授权中获取Tree类型的json串
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
/// d ##class(web.DHCBL.Authorize.ARCDepType).GetTreeJson("G","","")
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK) As %String
{
 if (ParentID="menuTreeRoot") s ParentID=-100000000000000
 s myJsonStr=""
 s myImage=""
 //获取授权JSON
 s AuStr=##class(web.DHCBL.Authorize.RBResourceForEQ).DHCGetDataByReference(ObjectType,ObjectReference)    
 s count=0
 s end=start+limit
 s RESRowId1=0
 for{
   s RESRowId1=$o(^RB("RES",RESRowId1)) 
   q:RESRowId1=""  
     
   s AuStr2="{ID:"_RESRowId1_"}"
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
   s RESEQDR=$p($g(^RB("RES",RESRowId1)),"^",3) 
   if (RESEQDR="") 
   {
      continue
   }
   else 
   { 
     s RESDesc=$p($g(^RBC("EQ",RESEQDR)),"^",2)
     if (RESDesc'="")&($ZCONVERT(RESDesc,"U")[$ZCONVERT(query,"U")){
     s count=count+1
     if ((count>start) & (count<=end)) || (end=0)
     {
       s AuStr2="{ID:"_RESRowId1_"}"
       if (AuStr[AuStr2) s myEnable=1
       else  s myEnable=0
    
       s:(myJsonStr'="") myJsonStr=myJsonStr_","
       s myJsonStr=myJsonStr_"{"
       s myJsonStr=myJsonStr_"""id"":"""_""_RESRowId1_""",""text"":"""_RESDesc_""","
    
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
