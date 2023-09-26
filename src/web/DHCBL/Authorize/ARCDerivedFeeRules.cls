Class web.DHCBL.Authorize.ARCDerivedFeeRules Extends web.BDP.sys.ExtPreferences
{

/// 数据授权
/// w ##class(web.DHCBL.Authorize.ARCDerivedFeeRules).GetAuthorizeTreeJson("menuTreeRoot","G","1")
Parameter ParaAppKey = "BD";

Parameter ParaAppSubKey = "ARC_DerivedFeeRules";

Parameter EntityClassName = "web.Entity.CT.ARCDerivedFeeRules";

Parameter DataSplitString = "JSON";

/// 获取授权的Data
/// w ##class(web.DHCBL.Authorize.ARCDerivedFeeRules).GetAutJson("","")
ClassMethod GetAutJson(ObjectType As %String, ObjectReference As %String) As %String
{
 s strAutMenu=##class(web.DHCBL.Authorize.ARCDerivedFeeRules).DHCGetDataByReference(ObjectType,ObjectReference)
 q strAutMenu
}

/// 一级授权中获取Tree类型的json串
/// ParentID： 父ID
/// ObjectType: 需要显示的优先级类别
/// ObjectReference： 在界面上 选择的 Group或者User或者CTLoc(登录科室)
/// d ##class(web.DHCBL.Authorize.ARCDerivedFeeRules).GetTreeJson("G","","")
ClassMethod GetTreeJson(ParentID As %String, ObjectType As %String, ObjectReference As %String, start, limit, query, FilterCK) As %String
{
 if (ParentID="menuTreeRoot") s ParentID=-100000000000000
 
 s myJsonStr=""
 s myImage=""
 
 //获取授权JSON
 s AuStr=##class(web.DHCBL.Authorize.ARCDerivedFeeRules).DHCGetDataByReference(ObjectType,ObjectReference)    
 
 s DFRRowId=0
 s count=0
 s end=start+limit
 
 for{
   s DFRRowId=$o(^ARC("DFR",DFRRowId))
   q:DFRRowId=""  
   //过滤已选、未选
   s AuStr2="{ID:"_DFRRowId_"}"
   if (FilterCK="checked") {
   if (AuStr[AuStr2) 
    else  continue
  }
   elseif (FilterCK="unchecked") {
   if (AuStr[AuStr2) continue
   else  
  }
   s DFRDesc=$p($g(^ARC("DFR",DFRRowId)),"^",2)
 
   if ($ZCONVERT(DFRDesc,"U")[$ZCONVERT(query,"U")){
   s count=count+1
   if ((count>start) & (count<=end)) || (end=0){
    s AuStr2="{ID:"_DFRRowId_"}"
    if (AuStr[AuStr2) s myEnable=1
    else  s myEnable=0
    
    s:(myJsonStr'="") myJsonStr=myJsonStr_","
    s myJsonStr=myJsonStr_"{"
    s myJsonStr=myJsonStr_"""id"":"""_""_DFRRowId_""",""text"":"""_DFRDesc_""","
    
    if (+myEnable){
     s myJsonStr=myJsonStr_"""checked"":true,"
    }else{
     s myJsonStr=myJsonStr_"""checked"":false,"
    }
    s myJsonStr=myJsonStr_"""leaf"":true"
    s myJsonStr=myJsonStr_"}"
   }
  }
 }
 s myJsonStr="{data:["_myJsonStr_"],totalCount:"_count_"}"
 
 q myJsonStr
}

}
