Import SQLUser

/// 名称:Ext功能大表 
/// 描述:Ext功能大表维护，包含增删改查功能
/// 编写者：基础平台组 
/// 编写日期: 2012-12-5
Class web.DHCBL.BDP.BDPExecutables Extends %RegisteredObject
{

/// Creator：sunfengchao
/// CreatDate: 2013-5-23 
/// Update: 2014-8-14 sunfengchao
/// Table：BDP_Executables
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPExecutables","GetList","","","")
Query GetList(RowId As %String, code As %String, caption As %String) As %Query(ROWSPEC = "ID:%String,Code:%String,Caption:%String,Description:%String,JavaScriptFile:%String,BDAJavaScriptFile:%String,ClassName:%String,PropertyName:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, RowId As %String, code As %String, caption As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (RowId'="") //根据rowid返回该条记录
 {
  s ID=RowId
  s Code=$LISTGET($G(^User.BDPExecutablesD(ID)),4)
  s Caption=$LISTGET($G(^User.BDPExecutablesD(ID)),3)
  s Description=$LISTGET($G(^User.BDPExecutablesD(ID)),5)
  s JavaScriptFile=$LISTGET($G(^User.BDPExecutablesD(ID)),6)
  s BDAJavaScriptFile=$LISTGET($G(^User.BDPExecutablesD(ID)),7)
  s ClassName=$LISTGET($G(^User.BDPExecutablesD(ID)),9)
  s PropertyName=$LISTGET($G(^User.BDPExecutablesD(ID)),10)
  d OutputRow
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
  s:caption'="" caption=$ZCONVERT(caption,"U") //转换成大写
  s ID=0
  f  s ID=$o(^User.BDPExecutablesD(ID)) q:ID=""  d
  .s Code=$LISTGET($G(^User.BDPExecutablesD(ID)),4)
  .s Caption=$LISTGET($G(^User.BDPExecutablesD(ID)),3)
  .s Description=$LISTGET($G(^User.BDPExecutablesD(ID)),5)
  .s JavaScriptFile=$LISTGET($G(^User.BDPExecutablesD(ID)),6)
  .s BDAJavaScriptFile=$LISTGET($G(^User.BDPExecutablesD(ID)),7)
  .s ClassName=$LISTGET($G(^User.BDPExecutablesD(ID)),9)
  .s PropertyName=$LISTGET($G(^User.BDPExecutablesD(ID)),10)
  .s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(Caption)  
  .if ($ZCONVERT(Code,"U")[code)&(($ZCONVERT(Caption,"U")[caption)||(PINYINCODE[caption)) d
  ..d OutputRow
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ID,Code,Caption,Description,JavaScriptFile,BDAJavaScriptFile,ClassName,PropertyName)
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

/// Function:用于提供一个接口，取描述
/// Input: code代码
/// Output: caption
/// CreateDate:2013-7-3 
/// Creator: sunfengchao
/// Debug:  d ##class(%ResultSet).RunQuery("web.DBCBL.BDP.BDPExecutables","GetDataForCmb1","","")
Query GetDataForCmb1(RowId As %String, caption As %String) As %Query(ROWSPEC = "ID:%String,Caption:%String")
{
}

ClassMethod GetDataForCmb1Execute(ByRef qHandle As %Binary, RowId As %String, caption As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (RowId'="") //根据rowid返回该条记录
 {
  s ID=RowId
  s Caption=$LISTGET($G(^User.BDPExecutablesD(ID)),3)
  d OutputRow
 }
 else
 {
  s:caption'="" caption=$ZCONVERT(caption,"U") //转换成大写
  s ID=0
  f  s ID=$o(^User.BDPExecutablesD(ID)) q:ID=""  d
  .s Caption=$LISTGET($G(^User.BDPExecutablesD(ID)),3)
  .i ($ZCONVERT(Caption,"U")[caption) d
  ..d OutputRow
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ID,Caption)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
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

/// Creator：李森
/// CreatDate: 2013-9-25
/// Description：数据重复验证方法
/// Table：User.BDPExecutables
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String) As %String
{
   s:code'="" code=$ZCONVERT(code,"U") //转换成大写
   s flag="",flagc=""
   s:code'="" flagc=$d(^User.BDPExecutablesI("CodeIndex"," "_code))
   if (id="") //如果为空，增加时的重复判断
   {
     if (flagc>0) s flag=1  //返回重复标志
     else  s flag=0 //返回不重复标志
   }
  else //如果不为空，修改时的重复判断
  {
   s idc=""
   s:code'="" idc=$o(^User.BDPExecutablesI("CodeIndex"," "_code,0))
   if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 q flag
}

/// CreatDate: 2012-12-5
/// UpdateDate: 2014-8-14
/// creator: sunfengchao 
/// Description：保存‘Ext功能大表’内容，对应form中的保存按钮
/// Table：BDP_Executables
/// Return:成功返回true，失败返回false
/// Debug: d ##class(web.DHCBL.BDP.BDPExecutables).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPExecutables) As %String
{
  s result="",ClassFlag=""
  s ValidateFlag=""
  if $IsObject(eobj)
  { 
    s flag=..Validate(eobj.ID,eobj.Code)   
    if (flag=1)
    {
      s result = "{success:'false',errorinfo:'该记录已经存在！'}"
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("BDP功能大表","web.DHCBL.CT.BDPExecutables","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)="该记录已经存在！"
    }
    else
    {
     if ((eobj.PropertyName'="")&&(eobj.ClassName =""))
     {
       s result= "{success:'false',errorinfo:'显示字段名非空时,类名不能为空!'}"
       s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("BDP功能大表","web.DHCBL.CT.BDPExecutables","SaveEntity",eobj)
       s ^ERRORLOGINFO(logid)="显示字段名非空时,类名不能为空!"
       q result
     }
     else
     {
       if ((eobj.ClassName'="")&(eobj.ClassName'["^"))
       {
         s ClassFlag=##class(web.DHCBL.BDP.FindTableStructure).ClassExistOrNot(eobj.ClassName) 
         if (ClassFlag=0)
         {
           s result= "{success:'false',errorinfo:'实体类不存在,请重新填写类名称!'}"
           s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("BDP功能大表","web.DHCBL.CT.BDPExecutables","SaveEntity",eobj)
           s ^ERRORLOGINFO(logid)="实体类不存在,请重新填写类名称!"
           q result
         }
        else
        {
         s ValidateFlag=##class(web.DHCBL.BDP.FindTableStructure).PropertyExistOrNot(eobj.ClassName,eobj.PropertyName) 
         if (ValidateFlag=0)
         {
           s result= "{success:'false',errorinfo:'显示字段名在类中不存在,请核查显示字段名是否正确!'}"
           s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("BDP功能大表","web.DHCBL.CT.BDPExecutables","SaveEntity",eobj)
           s ^ERRORLOGINFO(logid)="显示字段名在类中不存在,请核查显示字段名是否正确!"
           q result
         }
       }
   }
}
 
   if (eobj.ID="")  //如果RowId未赋值则增加
   { 
     s obj=##class(User.BDPExecutables).%New()
   }
   else   //如果RowId已赋值则修改
   {
     s obj=##class(User.BDPExecutables).%OpenId(eobj.ID)
     s bobj=##class(web.Entity.BDP.BDPExecutables).%New()
     s bobj.Code = obj.Code                      
     s bobj.Caption = obj.Caption                      
     s bobj.JavaScriptFile = obj.JavaScriptFile   
     s bobj.Description = obj.Description                  
     s bobj.BDAJavaScriptFile = obj.BDAJavaScriptFile
     s bobj.ClassName= obj.ClassName                  
     s bobj.PropertyName=obj.PropertyName
     s bobj.ID=eobj.ID    
     s bobj.PackageName=obj.PackageName
     s bobj.ActiveFlag=obj.ActiveFlag
     s:bobj.ActiveFlag=1 bobj.ActiveFlag="Y"
     s:bobj.ActiveFlag=0 bobj.ActiveFlag="N"
   }
   s:eobj.Code'="" eobj.Code=$tr(eobj.Code," ","")   ; 去除空格
   s:eobj.JavaScriptFile'="" eobj.JavaScriptFile=$tr(eobj.JavaScriptFile," ","")
   s:eobj.BDAJavaScriptFile'="" eobj.BDAJavaScriptFile=$tr(eobj.BDAJavaScriptFile," ","")
   s:eobj.ActiveFlag="Y" eobj.ActiveFlag=1  ///ActiveFlag 为 布尔类型： 0 或 1
   s:eobj.ActiveFlag="N" eobj.ActiveFlag=0
   s:eobj.ActiveFlag="" eobj.ActiveFlag=0
   s obj.Code = eobj.Code                      
   s obj.Caption = eobj.Caption                      //修改描述
   s obj.JavaScriptFile = eobj.JavaScriptFile  //JS文件及路径
   s obj.Description = eobj.Description        // 功能描述
   s obj.BDAJavaScriptFile = eobj.BDAJavaScriptFile  /// 基础数据授权 js 路径
   s obj.ClassName= eobj.ClassName          /// 类名              
   s obj.PropertyName=eobj.PropertyName     ////显示字段名称
   s obj.PackageName=eobj.PackageName  /// 包名称
   s obj.ActiveFlag=eobj.ActiveFlag  /// 有效
   Ts
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
     Tc
     s id = obj.%Id()
     s result = "{success:'true',id:'"_id_"'}"         
     //保存日志
     d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Executables","User.BDPExecutables","BDP功能大表",id,eobj.Caption,"A",eobj)
     d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Executables","User.BDPExecutables","BDP功能大表",eobj.ID,eobj.Caption,"U",eobj,bobj)
   }
   else
   {
      Trollback
      s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("BDP功能大表","web.DHCBL.CT.BDPExecutables","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
   }
  }
 }
 else
 {
   s result = "{success:'false',errorinfo:'对象不存在！'}"
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("BDP功能大表","web.DHCBL.CT.BDPExecutables","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！"   
 } 
  q result
}

/// Function: 删除时验证数据是否被引用
/// CreateDate: 2013-12-30 by sunfengchao
ClassMethod GetRefFlag(id As %String) As %String
{
 s return="",myInfo=""
 
 //1 是否被"菜单维护"引用
 s ID=0
 for {
  s ID=$o(^User.BDPMenuD(ID))
  q:ID=""
  s LinkFuntionDR=$LISTGET($G(^User.BDPMenuD(ID)),4)
  if (LinkFuntionDR=id) {
   s myInfo=myInfo_"<菜单维护>"
   q
  }
 }
 
 i myInfo="" s return="0^未被引用可删除!"
  else  s return="1^在"_myInfo_"表里被引用,不能删除!"
 q return
}

/// Function：根据id删除‘Ext功能大表’的内容
/// CreatDate: 2012-12-5
/// UpdateDate: 2014-08-14 by sunfengchao
/// Table：BDP_Executables
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
 s result=""
 //验证是否被引用
  s re=..GetRefFlag(id)
 if ($p(re,"^",1)) {
  s result= "{success:'false',info:'"_$p(re,"^",2)_"'}"
 }
 else
 {
  s eobj=##class(web.Entity.BDP.BDPExecutables).%New()
  s eobj.ID=id
  s eobj.ActiveFlag=$LISTGET($G(^User.BDPExecutablesD(id)),2)
  s eobj.Caption=$LISTGET($G(^User.BDPExecutablesD(id)),3)
  s eobj.Code=$LISTGET($G(^User.BDPExecutablesD(id)),4)
  s eobj.Description=$LISTGET($G(^User.BDPExecutablesD(id)),5)
  s eobj.JavaScriptFile=$LISTGET($G(^User.BDPExecutablesD(id)),6)
  s eobj.BDAJavaScriptFile=$LISTGET($G(^User.BDPExecutablesD(id)),7)
  s eobj.ClassName=$LISTGET($G(^User.BDPExecutablesD(id)),9)
  s eobj.PropertyName=$LISTGET($G(^User.BDPExecutablesD(id)),10)
  
  Tstart
  s sc=##class(User.BDPExecutables).%DeleteId(id)
  IF $$$ISOK(sc) {
   Tc
   s result="{success:'true',info:'删除成功！'}"
   //保存日志
   d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDP_Executables","User.BDPExecutables","BDP功能大表",id,eobj.Caption,"D",eobj)
   d eobj.%Close()
  }
  else 
  {
     Trollback
     s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("BDP功能大表","web.DHCBL.CT.BDPExecutables","DeleteData",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
  }
 }
 q result
}

/// Function: 用于提供一个接口 取 类名,属性名
/// Creator:  sunfengchao
/// Input:    code代码
/// Output:   ClassName^PropertyName
/// Debugs:   w ##class(web.DHCBL.BDP.BDPExecutables).GetClassInfoByCode("CT_Title")
ClassMethod GetClassInfoByCode(code As %String)
{
   q:code="" "^"
   s result="" 
   s ID=""
   s ClassName=""
   s PropertyName="" 
   s ID=$o(^User.BDPExecutablesI("CodeIndex"," "_$zcvt(code,"U"),0))
   if (ID'="")
   {
    s ClassName=$LISTGET($G(^User.BDPExecutablesD(ID)),9)
    s PropertyName=$LISTGET($G(^User.BDPExecutablesD(ID)),10)
   }
   s result=ClassName_"^"_PropertyName
   q result
}

/// Function: 根据 code 获取 功能大表的 名称caption
/// CreateDate: 2014-9-1 
/// Creator: sunfengchao
/// Debugs: w ##class(web.DHCBL.BDP.BDPExecutables).GetExtCaptionByCode("CT_Title")
ClassMethod GetExtCaptionByCode(code As %String) As %String
{
 
   q:code="" ""
   s ID=""
   s Caption=""
   s:code'="" ID=$o(^User.BDPExecutablesI("CodeIndex"," "_$zcvt(code,"U"),0))
   if (ID'="") s Caption=$LISTGET($G(^User.BDPExecutablesD(ID)),3) 
   q Caption
}

/*
ClassMethod BuildAryByCode(code As %String) As %String
{
 s code = $ZCONVERT(code,"U")
 s rowid = $o(^User.BDPExecutablesI("CodeIndex"," "_code,""))
 q:rowid=""
 s ItemStr=##class(web.DHCBL.Authorize.Executables).DHCGetDataByDefaultSession(code)
 s falg = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPDisableDel") //判断是否默认禁用删除按钮
 
 s id = 0
 w !
 w !,"<script type=""text/javascript"">",!
  ;w " Ext.BDP.FunLib.Component.DisableArray = new Array();",!
 
 f  s id = $o(^User.BDPExecutablesD(rowid,"ChildExtExecItem",id)) q:(id="")  d 
 .s id1 = rowid_"||"_id
 .s ItemStr2="{ID:"_id1_"}"
 .s obj=##class(User.BDPExtExecItem).%OpenId(id1)  
 .s obj.Code=##class(web.BDP.util.String).Replace(obj.Code,$c(32), "") //去掉code中的空格
 .if ((obj.Type ="D") & (falg = "Y")) & (ItemStr="") d //判断是否默认禁用删除按钮，如果默认禁用，在没授权时删除按钮都为禁用
 ..w " Ext.BDP.FunLib.Component.DisableArray["""_obj.Code_"""]='N';",!
 
 .if (ItemStr[ItemStr2) d //判断是否有权限
 ..;s obj=##class(User.BDPExtExecItem).%OpenId(id1)
 ..;s obj.Code=##class(web.BDP.util.String).Replace(obj.Code,$c(32), "") //去掉code中的空格
 ..w " Ext.BDP.FunLib.Component.DisableArray["""_obj.Code_"""]='N';",!
 ..d obj.%Close()
  
  w "</script>"
  w !
} */

/*
ClassMethod BuildAutAry(code As %String) As %String
{
 // 用于返回是控件否可编辑Flag,将Funlib中的函数提取，抛弃Ext元素，兼容Jquery和Ext等前台脚本使用 
 w !,"<script type=""text/javascript"">",!
 w "function BDPAutDisableFlag(ControlId){",!
 w "  if(typeof(BDPDisableArray) != 'undefined')",!
 w "  {",!
 w "    if((BDPDisableArray[ControlId] == 'N'))",!
 w "    {   ",!
 w "      return true;",!
 w "    }",!
 w "    else ",!
 w "    {",!
 w "      return false;",!
 w "    }",!
 w "  }",!
 w "  else",!
 w "  {",!
 w "    return false;",!
 w "  }",!
 w "};",!
 w "</script>"
 w !
 
 s code = $ZCONVERT(code,"U")
 s rowid = $o(^User.BDPExecutablesI("CodeIndex"," "_code,""))
 q:rowid=""
 s ItemStr=##class(web.DHCBL.Authorize.Executables).DHCGetDataByDefaultSession(code)
 s falg = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPDisableDel") //判断是否默认禁用删除按钮
 s id = 0
 w !
 w !,"<script type=""text/javascript"">",!
 w !,"var BDPDisableArray = new Array();",!
 f  s id = $o(^User.BDPExecutablesD(rowid,"ChildExtExecItem",id)) q:(id="")  d 
 .s id1 = rowid_"||"_id
 .s ItemStr2="{ID:"_id1_"}"
 .s obj=##class(User.BDPExtExecItem).%OpenId(id1)
 .s obj.Code=##class(web.BDP.util.String).Replace(obj.Code,$c(32), "") //去掉code中的空格
 
 .if ((obj.Type ="D") & (falg = "Y")) & (ItemStr="") d //判断是否默认禁用删除按钮，如果默认禁用，在没授权时删除按钮都为禁用
 ..w "BDPDisableArray["""_obj.Code_"""]='N';",!
 
 .if (ItemStr[ItemStr2) d //判断是否有权限
 ..w "BDPDisableArray["""_obj.Code_"""]='N';",!
 ..d obj.%Close()
 
 w "</script>"
 w !
}  */
/// d ##class(web.DHCBL.BDP.BDPExecutables).BuildAryByCode("CT_Acuity")
/// 2013-5-14 by lisen
/// 2014-10-20 by chz
/// d ##class(web.DHCBL.BDP.BDPExecutables).BuildAutAry("CT_Acuity")
/// 2014-7-21 by caihz
/// 用于产品组调用，功能元素授权。
///   Function: 返回搜索工具条文本的id  
///   CreateDate: 2016-7-7
///   Creator:  sunfengchao 
///   w ##class(web.DHCBL.BDP.BDPExecutables).GetEnterItems1("ARC_BillGrp")
ClassMethod GetEnterItems1(code As %String) As %String
{
   s reslutstr="" 
   s code = $ZCONVERT(code,"U")
   s rowid = $o(^User.BDPExecutablesI("CodeIndex"," "_code,""))
   q:rowid="" ""
  
   s id = 0
   for
   {
     s id = $o(^User.BDPExecutablesD(rowid,"ChildExtExecItem",id)) 
     q:id=""  
     s id1 = rowid_"||"_id
     s obj=##class(User.BDPExtExecItem).%OpenId(id1)  
     s obj.Code=##class(web.BDP.util.String).Replace(obj.Code,$c(32), "") //去掉code中的空格
     if ($zcvt(obj.Type,"U")["T") 
     { 
         if (reslutstr="")
         {
           s reslutstr=obj.Code
         }
         else
         {
           s reslutstr=reslutstr_"^"_obj.Code
         }
      }
   } 
    q reslutstr
}

/// Function: 根据cmb id 获取type
/// CreateDate: 2016-7-9
/// Creator:  sunfengchao
/// Debug:    w ##class(web.DHCBL.BDP.BDPExecutables).GetCmbTypeByID("ARC_BillGrp","TextCode")
ClassMethod GetCmbTypeByID(code As %String, cmbid As %String)
{
   s reslutstr=""
   s code = $ZCONVERT(code,"U")
   s rowid = $o(^User.BDPExecutablesI("CodeIndex"," "_code,""))
   q:rowid="" ""
  
   s id = 0
   for
   {
     s id = $o(^User.BDPExecutablesD(rowid,"ChildExtExecItem",id)) 
     q:id=""
 
     s id1=rowid_"||"_id
     s obj=##class(User.BDPExtExecItem).%OpenId(id1)  
   
   
     if (##class(web.BDP.util.String).Replace(obj.Code,$c(32), "") =cmbid)
     {   
      s obj.Type=$zcvt(##class(web.BDP.util.String).Replace(obj.Type,$c(32), ""),"U") 
      s reslutstr=obj.Type
     }
   }
     q reslutstr
}

/// Function:　根据T1去查找S1 R1 S2 R2
/// CreateDate:2016-7-9
/// Creator:   sunfengchao
/// Debug:     w ##class(web.DHCBL.BDP.BDPExecutables).FindSeachByT("ARC_BillGrp","TextCode")
ClassMethod FindSeachByT(code As %String, cmbid As %String)
{
   s reslutstr=""
   s code = $ZCONVERT(code,"U")
   s type= ##class(web.DHCBL.BDP.BDPExecutables).GetCmbTypeByID(code,cmbid)
   s rowid = $o(^User.BDPExecutablesI("CodeIndex"," "_code,""))
   q:rowid="" ""
  
   s id = 0
   for
   {
     s id = $o(^User.BDPExecutablesD(rowid,"ChildExtExecItem",id)) 
     q:id=""  
     s id1 = rowid_"||"_id
     s obj=##class(User.BDPExtExecItem).%OpenId(id1)  
     s obj.Type=$zcvt(##class(web.BDP.util.String).Replace(obj.Type,$c(32), ""),"U") //去掉code中的空格
     if (type="T")  
     {   
        if (obj.Type ="S"){
          s reslutstr=obj.Code
        }   
     }
     else
     {
         if ($p(type,"T",2)>0)
         {
          
           if (type=("T"_$p(type,"T",2))) 
           { 
            
             if (obj.Type =("S"_$p(type,"T",2))) 
             {   
                s reslutstr=obj.Code
             }        
          }
       }
     }
   }  
  q reslutstr
}

/// Function:　根据T1去查找  R1
/// CreateDate:2016-7-9
/// Creator:  sunfengchao
/// Debug:    w ##class(web.DHCBL.BDP.BDPExecutables).FindResetIDByT("SS_User","MUCPParRef")
ClassMethod FindResetIDByT(code As %String, cmbid As %String)
{
   s reslutstr=""
   s code = $ZCONVERT(code,"U")
   s type= ##class(web.DHCBL.BDP.BDPExecutables).GetCmbTypeByID(code,cmbid)
   s rowid = $o(^User.BDPExecutablesI("CodeIndex"," "_code,""))
   q:rowid="" ""
  
   s id = 0
   for
   {
     s id = $o(^User.BDPExecutablesD(rowid,"ChildExtExecItem",id)) 
     q:(id="")  
     s id1 = rowid_"||"_id
     s obj=##class(User.BDPExtExecItem).%OpenId(id1)  
     s obj.Type=$zcvt(##class(web.BDP.util.String).Replace(obj.Type,$c(32), ""),"U") //去掉code中的空格
     if (type="T")  
     {   
        if (obj.Type ="R"){
          s reslutstr=obj.Code
        }   
     }
     else
     { 
         if ($p(type,"T",2)>0)
         {
           if (type=("T"_$p(type,"T",2))) 
           { 
            
             if (obj.Type =("R"_$p(type,"T",2))) 
             {   
                s reslutstr=obj.Code
             }        
          }
       }
     }
   }  
  q reslutstr
}

/// Function: 系统级设置日期为当前日期的配置
/// CreateDate: 2016-7-9
/// Creator:  sunfengchao
/// w ##class(web.DHCBL.BDP.BDPExecutables).GetDateFromID("PAC_PregStatus")
ClassMethod GetDateFromID(code As %String) As %String
{
   s reslutstr=""
   s code = $ZCONVERT(code,"U")
   s rowid = $o(^User.BDPExecutablesI("CodeIndex"," "_code,""))
   q:rowid="" ""
  
   s id = 0
   for
   {
     s id = $o(^User.BDPExecutablesD(rowid,"ChildExtExecItem",id)) 
     q:(id="")  
     s id1 = rowid_"||"_id
     s obj=##class(User.BDPExtExecItem).%OpenId(id1)  
     s obj.Type=##class(web.BDP.util.String).Replace(obj.Type,$c(32), "") //去掉code中的空格
     if (obj.Type ="DF") 
     { 
         if (reslutstr="")
         {
           s reslutstr=obj.Code
         }
         else
         {
           s reslutstr=reslutstr_"^"_obj.Code
         }
      }
   }  
  q reslutstr
}

/// Function: 通过功能大表里的table来找到菜单维护里的菜单名
/// CreateDate:2016-9-27
/// Creator:  sunfengchao
/// debug:    w ##class(web.DHCBL.BDP.BDPExecutables).GetMenuNameByTable()
ClassMethod GetMenuNameByTable(table As %String)
{
  s result=""
  if (table'="")
  {
     s table=$zcvt(table,"U")  
     if ($d(^User.BDPExecutablesI("CodeIndex"," "_table))>0)
     {
       s ExecuteID=0
       s ExecuteID=$o(^User.BDPExecutablesI("CodeIndex"," "_table,0))
       q:ExecuteID="" ""
       s Caption=$LISTGET($G(^User.BDPExecutablesD(ExecuteID)),3)  
       s ID=0
       for
       {
         s ID=$o(^User.BDPMenuD(ID)) 
         q:ID=""  
         s Code=$LISTGET($G(^User.BDPMenuD(ID)),2)
         s MenuCaption=$LISTGET($G(^User.BDPMenuD(ID)),3) 
         if (MenuCaption=Caption) 
         {
           s result=$zcvt(Code,"U")
           if (result="DHC.BDP.CARE")&(MenuCaption="医护人员") s result="DHC.BDP.CARE.CTCAREPROV"
           if (result="DHC.BDP.DOC.DHCCTLOCMEDUNIT")&(MenuCaption="医疗单元") s result="DHC.BDP.DHCCTLOCMEDUNIT"
           q  
         }
         else
         {
           continue
         }
        }
      }
    }
   q result
}

/// Descption: 更改功能子表里元素的类型 
/// CreateDate: 2021-8-26
/// Creator:  sunfengchao 
/// w ##class(web.DHCBL.BDP.BDPExecutables).UpdateBDPItems()
ClassMethod UpdateBDPItems() As %String
{
 
   s rowid=0
   for
   { 
       s rowid = $o(^User.BDPExecutablesD(rowid)) q:rowid=""  
       s id = 0
       for
       {
         s id = $o(^User.BDPExecutablesD(rowid,"ChildExtExecItem",id))  q:id=""
         s id1 = rowid_"||"_id
         s obj=##class(User.BDPExtExecItem).%OpenId(id1)  
         s obj.Code=##class(web.BDP.util.String).Replace(obj.Code,$c(32), "") //去掉code中的空格
         if ($zcvt(obj.Code,"U")["ADD")||((obj.Code="rMenu2")&(obj.Name["添加")) s obj.Type="A"  //新增按钮
         if ($zcvt(obj.Code,"U")["UPDATE")||((obj.Code="rMenu3")&(obj.Name["修改")) s obj.Type="U"  //修改按钮 
         s sc=obj.%Save()
      }
   } 
    q "操作完成"
}

/// d ##class(web.DHCBL.BDP.BDPExecutables).BuildAryByCode("CT_Acuity")
/// 2013-5-14 by lisen
/// 2014-10-20 by chz
/// d ##class(web.DHCBL.BDP.BDPExecutables).BuildAryByCode("CT_Acuity")
/// 2013-5-14 by lisen
/// 2014-10-20 by chz
/// 2022-05-09 by sunfengchao  增加了 表结构登记里的标准数据限制
ClassMethod BuildAryByCode(code As %String) As %String
{
 s codeI = $ZCONVERT(code,"U")
 s rowid = $o(^User.BDPExecutablesI("CodeIndex"," "_codeI,""))
 q:rowid=""
 s ItemStr=##class(web.DHCBL.Authorize.Executables).DHCGetDataByDefaultSession(codeI) 
 s falg = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPDisableDel") //判断是否默认禁用删除按钮
 s StandardAutStr= ##class(web.DHCBL.BDP.BDPTableList).GetTableAUDRights(code)  // 调用接口   "1#U"  //
 ;s ^TMPItemStr=ItemStr_"  "_StandardAutStr
 s StandardFlag=$p(StandardAutStr,"#") // 是否标准数据类型
 s StandardAut=$p(StandardAutStr,"#",2) 
 s id = 0
 w !
 w !,"<script type=""text/javascript"">",!
  ;w " Ext.BDP.FunLib.Component.DisableArray = new Array();",!
 
 f  s id = $o(^User.BDPExecutablesD(rowid,"ChildExtExecItem",id)) q:(id="")  d 
 .s id1 = rowid_"||"_id
 .s ItemStr2="{ID:"_id1_"}"
 .s obj=##class(User.BDPExtExecItem).%OpenId(id1)  
 .s obj.Code=##class(web.BDP.util.String).Replace(obj.Code,$c(32), "") //去掉code中的空格
   
 .if (StandardFlag=1) d ///  标准数据 需要在表结构登记里取 是否可以增删改的权限 然后再跟功能元素授权一起控制
 ..if ((obj.Type ="D")||(obj.Type="A")||(obj.Type ="U")) d  ; 默认表结构登记里只控制 主表字典的按钮，对应类型为D A U ,不限制 A1 D1 U1
 ...if (StandardAut[obj.Type)||(ItemStr[ItemStr2) d  /// 是标准数据 并且做过授权 才禁用
 ....w " Ext.BDP.FunLib.Component.DisableArray["""_obj.Code_"""]='N';",!
 ..else  d  // D1  A1 U1 的情况
 ...if ((obj.Type ["D")&(obj.Type'="DF")&(falg = "Y"))&(ItemStr="") d //判断是否默认禁用删除按钮，如果默认禁用，在没授权时删除按钮都为禁用
 ....w " Ext.BDP.FunLib.Component.DisableArray["""_obj.Code_"""]='N';",!
 
 ...if (ItemStr[ItemStr2) d //判断是否有权限
 ....w " Ext.BDP.FunLib.Component.DisableArray["""_obj.Code_"""]='N';",!
  
 .else  d  ///非标准数据 
 ..if ((obj.Type ["D")&(obj.Type'="DF")&(falg = "Y"))&(ItemStr="") d //判断是否默认禁用删除按钮，如果默认禁用，在没授权时删除按钮都为禁用
 ...w " Ext.BDP.FunLib.Component.DisableArray["""_obj.Code_"""]='N';",!
 
 ..if (ItemStr[ItemStr2) d //判断是否有权限
 ...w " Ext.BDP.FunLib.Component.DisableArray["""_obj.Code_"""]='N';",!
   
 ..d obj.%Close()
  
  w "</script>"
  w !
}

/// d ##class(web.DHCBL.BDP.BDPExecutables).BuildAutAry("CT_Acuity")
/// 2014-7-21 by caihz
/// 用于产品组调用，功能元素授权。
ClassMethod BuildAutAry(code As %String) As %String
{
 //"/**用于返回是控件否可编辑Flag,将Funlib中的函数提取，抛弃Ext元素，兼容Jquery和Ext等前台脚本使用**/
 w !,"<script type=""text/javascript"">",!
 w "function BDPAutDisableFlag(ControlId){",!
 w "  if(typeof(BDPDisableArray) != 'undefined')",!
 w "  {",!
 w "    if((BDPDisableArray[ControlId] == 'N'))",!
 w "    {   ",!
 w "      return true;",!
 w "    }",!
 w "    else ",!
 w "    {",!
 w "      return false;",!
 w "    }",!
 w "  }",!
 w "  else",!
 w "  {",!
 w "    return false;",!
 w "  }",!
 w "};",!
 w "</script>"
 w !
 
 s code = $ZCONVERT(code,"U")
 s rowid = $o(^User.BDPExecutablesI("CodeIndex"," "_code,""))
 q:rowid=""
 s ItemStr=##class(web.DHCBL.Authorize.Executables).DHCGetDataByDefaultSession(code)
 s falg = ##class(web.DHCBL.BDP.BDPConfig).GetConfigValue("BDPDisableDel") //判断是否默认禁用删除按钮
 s id = 0
 w !
 w !,"<script type=""text/javascript"">",!
 w !,"var BDPDisableArray = new Array();",!
 f  s id = $o(^User.BDPExecutablesD(rowid,"ChildExtExecItem",id)) q:(id="")  d 
 .s id1 = rowid_"||"_id
 .s ItemStr2="{ID:"_id1_"}"
 .s obj=##class(User.BDPExtExecItem).%OpenId(id1)
 .s obj.Code=##class(web.BDP.util.String).Replace(obj.Code,$c(32), "") //去掉code中的空格
 
 .if ((obj.Type["D")&(obj.Type'="DF")&(falg = "Y"))&(ItemStr="") d //判断是否默认禁用删除按钮，如果默认禁用，在没授权时删除按钮都为禁用
 ..w "BDPDisableArray["""_obj.Code_"""]='N';",!
 
 .if (ItemStr[ItemStr2) d //判断是否有权限
 ..w "BDPDisableArray["""_obj.Code_"""]='N';",!
 ..d obj.%Close()
 
 w "</script>"
 w !
}

}
