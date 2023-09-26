/// / Function：医疗单元授权类
Class web.DHCBL.Authorize.DHCCTLocMedUnit Extends web.BDP.sys.ExtPreferences
{

Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "DHC_CTLoc_MedUnit";

Parameter EntityClassName = "web.Entity.CT.DHCCTLocMedUnit";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.DHCCTLocMedUnit).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
  s strAutMenu=##class(web.DHCBL.Authorize.DHCCTLocMedUnit).DHCGetDataByReference(ObjectType,ObjectReference)
  q strAutMenu
}

/// 一级授权中获取Tree类型的json串
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
/// d ##class(web.DHCBL.Authorize.DHCCTLocMedUnit).GetTreeJson("G","","")
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK) As %String
{
 if (ParentID="menuTreeRoot") s ParentID=-100000000000000
 s myJsonStr=""
 s myImage=""
 //获取授权JSON
 s AuStr=##class(web.DHCBL.Authorize.DHCCTLocMedUnit).DHCGetDataByReference(ObjectType,ObjectReference)    
 s count=0
 s end=start+limit
 
 s CTLocDr="0"
 for
 {
      s CTLocDr=$o(^CTLOC(CTLocDr)) 
      q:CTLocDr=""  
      s CTChildsub=0                                                                                   
      for
      {
        s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub))  
        q:CTChildsub=""    
        s MURowId=CTLocDr_"||"_CTChildsub
        s AuStr2="{ID:"_MURowId_"}"
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
        s CTMUCode=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",1)                   
        s CTMUDesc=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",2)  
       if (CTMUDesc'="")&($ZCONVERT(CTMUDesc,"U")[$ZCONVERT(query,"U")){
       s count=count+1
       if ((count>start) & (count<=end)) || (end=0)
       {
         s AuStr2="{ID:"_MURowId_"}"
         if (AuStr[AuStr2) s myEnable=1
         else  s myEnable=0
    
         s:(myJsonStr'="") myJsonStr=myJsonStr_","
         s myJsonStr=myJsonStr_"{"
         s myJsonStr=myJsonStr_"""id"":"""_""_MURowId_""",""text"":"""_CTMUDesc_""","
    
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
