Import SQLUser

/// 名称:Ext组件基本元素维护 
/// 描述:基本元素维护，包含增删改查功能
/// 编写者：基础平台组 
/// 编写日期: 2012-12-5
Class web.DHCBL.BDP.BDPExtExecItem Extends %RegisteredObject [ ProcedureBlock ]
{

/// Creator：孙凤超
/// CreatDate: 2013-5-23
/// Description：查询‘基本元素’内容，同时将其显示到grid中
/// Table：User.BDPExtExecItem
/// Input：ParRef
/// Debug: d ##class(%ResultSet).RunQuery("","","","")
Query GetList(ParRef As %String, RowId As %String, code As %String, desc As %String) As %Query(ROWSPEC = "BDEFRowId:%String,BDEFCode:%String,BDEFName:%String,BDEFBDETParRef:%String,BDEFAllowBlank:%String,BDEFAutoShow,BDEFEditable,BDEFHandler,BDEFHidden,BDEFHiddenName,BDEFIconCls,BDEFReadOnly,BDEFRegex,BDEFRegexText,BDEFToolTip,BDEFToolTipType,BDEFType,BDEFValidator,BDEFValueGet,BDEFXType,BDEFValueSet")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String, RowId As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (RowId'="") //根据rowid返回该条记录
 {
  s ID=$p(RowId,"||",2)
  s BDEFRowId=RowId
  s BDEFBDETParRef=$p(RowId,"||",1)
  s BDEFCode=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),20)
  s BDEFName=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),37)
  s BDEFAllowBlank=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),18)
  s BDEFAutoShow=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),19)
  s BDEFEditable=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),22)
  s BDEFHandler=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),23)
  s BDEFHidden=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),24)
  s BDEFHiddenName=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),25)
  s BDEFIconCls=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),26)
  s BDEFReadOnly=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),27)
  s BDEFRegex=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),28)
  s BDEFRegexText=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),29)
  s BDEFToolTip=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),30)
  s BDEFToolTipType=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),31)
  s BDEFType=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),32)
  s BDEFValidator=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),33)
  s BDEFValueGet=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),35)
  s BDEFXType=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),34)
  s BDEFValueSet=$LISTGET($G(^User.BDPExecutablesD(BDEFBDETParRef,"ChildExtExecItem",ID)),36)
  d OutputRow
 }
 else
 {
  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  q:ParRef="" $$$OK
  s ID=0
  f  s ID=$o(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)) q:ID=""  d
  .s BDEFRowId=ParRef_"||"_ID
  .s BDEFBDETParRef=ParRef
  .s BDEFCode=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),20)
  .s BDEFName=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),37)
  .s BDEFAllowBlank=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),18)
  .s BDEFAutoShow=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),19)
  .s BDEFEditable=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),22)
  .s BDEFHandler=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),23)
  .s BDEFHidden=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),24)
  .s BDEFHiddenName=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),25)
  .s BDEFIconCls=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),26)
  .s BDEFReadOnly=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),27)
  .s BDEFRegex=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),28)
  .s BDEFRegexText=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),29)
  .s BDEFToolTip=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),30)
  .s BDEFToolTipType=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),31)
  .s BDEFType=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),32)
  .s BDEFValidator=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),33)
  .s BDEFValueGet=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),35)
  .s BDEFXType=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),34)
  .s BDEFValueSet=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ID)),36)
  .s PINYINCODE=##class(web.DHCBL.BDP.FunLib).GetPYCODE(BDEFName)  
  .i ($ZCONVERT(BDEFCode,"U")[code)&(($ZCONVERT(BDEFName,"U")[desc)||(PINYINCODE[desc)) d
  ..d OutputRow
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(BDEFRowId,BDEFCode,BDEFName,BDEFBDETParRef,BDEFAllowBlank,BDEFAutoShow,BDEFEditable,BDEFHandler,BDEFHidden,BDEFHiddenName,BDEFIconCls,BDEFReadOnly,BDEFRegex,BDEFRegexText,BDEFToolTip,BDEFToolTipType,BDEFType,BDEFValidator,BDEFValueGet,BDEFXType,BDEFValueSet)
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

/// Creator： sunfengchao
/// CreatDate: 2013-9-25
/// Description：数据重复验证方法
/// Table：User.BDPExtExecItem
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
/// Debugs: w ##class(web.DHCBL.BDP.BDPExtExecItem).Validate()
ClassMethod Validate(ParentRowId As %String, id As %String, code As %String, desc As %String) As %String
{
 s:code'="" code=$ZCONVERT(code,"U")
 s:desc'="" desc=$zcvt(desc,"U")
 s flag=""
 if (id="") //如果为空，增加时的重复判断
 {
  s flagc="",flagD=0
  s:code'="" flagc=$d(^User.BDPExtExecItemI("CodeIndex"," "_code,ParentRowId))
  s ID=0
  for
  {
    s ID=$o(^User.BDPExecutablesD(ParentRowId,"ChildExtExecItem",ID)) 
    q:ID=""  
    s BDEFName=$LISTGET($G(^User.BDPExecutablesD(ParentRowId,"ChildExtExecItem",ID)),37)
    if ($zcvt(BDEFName,"U")=desc) s flagD=1
    else  continue
  }
  if (flagc>0)  s flagc=1
 }
 else //如果不为空，修改时的重复判断
 {
  s ParRef=$p(id,"||",1)
  s subId=$p(id,"||",2)
  s flagc=0
  s:code'="" flagc=$d(^User.BDPExtExecItemI("CodeIndex"," "_code,ParRef))
  s idc=""
  s:code'="" idc=$o(^User.BDPExtExecItemI("CodeIndex"," "_code,ParRef,0))
  s ID=0,flagD=0
  for
  {
    s ID=$o(^User.BDPExecutablesD(ParentRowId,"ChildExtExecItem",ID)) 
    q:ID=""  
    s BDEFName=$LISTGET($G(^User.BDPExecutablesD(ParentRowId,"ChildExtExecItem",ID)),37)
    s BDEFRowId=ParentRowId_"||"_ID
    if ($zcvt(BDEFName,"U")=desc)&(BDEFRowId'=id) s flagD=1
    else  continue
  }
  if ((idc'=subId)&(flagc>0))
  {
    s flagc=1
  }
  else
  {
    s flagc=0
  }
 }
 s flag=flagc_"^"_ flagD
 q flag
}

/// Creator：sunfengchao
/// CreatDate: 2013-5-23
/// Description：保存‘基本元素’内容，对应form中的保存按钮
/// Table：User.BDPExtExecItem
/// Return:成功返回true，失败返回false
/// Others: d ##class(web.DHCBL.BDP.BDPExtExecItem).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPExtExecItem) As %String
{
   
 s $zt="EEROE"
 s result="",codeflag=0,descflag=0
 if $IsObject(eobj)
 {
  s flag=..Validate(eobj.BDEFBDETParRef,eobj.BDEFRowId,eobj.BDEFCode,eobj.BDEFName)  //调用重复验证
  if (flag="1^1")||(flag="0^1")||(flag="1^0")
  {
    s codeflag=$p(flag,"^",1)
    s descflag=$p(flag,"^",2)
    if (codeflag=1)&(descflag=0){
      s result = "{success:'false',errorinfo:'该条记录代码重复！'}"
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基本元素","web.DHCBL.CT.BDPExtExecItem","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)="该条记录代码重复！" 
    }
    if (codeflag=0)&(descflag=1){
      s result = "{success:'false',errorinfo:'该条记录描述重复！'}"
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基本元素","web.DHCBL.CT.BDPExtExecItem","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)="该条记录描述重复！" 
    }
    if (codeflag=1)&(descflag=1){
      s result = "{success:'false',errorinfo:'该条记录代码和描述重复！'}"
      s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基本元素","web.DHCBL.CT.BDPExtExecItem","SaveEntity",eobj)
      s ^ERRORLOGINFO(logid)="该条记录代码和描述重复！" 
    }
  }
  else
  {
   if (eobj.BDEFRowId="")     
   {
    s obj=##class(User.BDPExtExecItem).%New(eobj.BDEFBDETParRef)
   }
   else                                     
   {
    s obj=##class(User.BDPExtExecItem).%OpenId(eobj.BDEFRowId)
    s bobj=##class(web.Entity.BDP.BDPExtExecItem).%New(eobj.BDEFBDETParRef)
    s bobj.BDEFCode = obj.Code
    s bobj.BDEFName = obj.Name 
    s bobj.BDEFAllowBlank = obj.AllowBlank
    s bobj.BDEFAutoShow = obj.AutoShow
    s bobj.BDEFEditable = obj.Editable
    s bobj.BDEFHandler = obj.Handler
    s bobj.BDEFHidden = obj.Hidden
    s bobj.BDEFHiddenName = obj.HiddenName
    s bobj.BDEFIconCls = obj.IconCls
    s bobj.BDEFReadOnly = obj.ReadOnly
    s bobj.BDEFRegex = obj.Regex
    s bobj.BDEFRegexText = obj.RegexText
    s bobj.BDEFToolTip = obj.ToolTip
    s bobj.BDEFToolTipType = obj.ToolTipType
    s bobj.BDEFType = obj.Type
    s bobj.BDEFXType = obj.XType
    s bobj.BDEFValidator = obj.Validator
    s bobj.BDEFValueGet = obj.ValueGet
    s bobj.BDEFRowId=eobj.BDEFRowId
    s bobj.BDEFBDETParRef=eobj.BDEFBDETParRef
   }
   Ts        
   d:eobj.BDEFBDETParRef'="" obj.ParRefSetObjectId(eobj.BDEFBDETParRef) //修改数据时BDEFBDETParRef为空
   s obj.Code = eobj.BDEFCode
   s obj.Name = eobj.BDEFName
   s obj.AllowBlank = eobj.BDEFAllowBlank
   s obj.AutoShow = eobj.BDEFAutoShow
   s obj.Editable = eobj.BDEFEditable
   s obj.Handler = eobj.BDEFHandler
   s obj.Hidden = eobj.BDEFHidden
   s obj.HiddenName = eobj.BDEFHiddenName
   s obj.IconCls = eobj.BDEFIconCls
   s obj.ReadOnly = eobj.BDEFReadOnly
   s obj.Regex = eobj.BDEFRegex
   s obj.RegexText = eobj.BDEFRegexText
   s obj.ToolTip = eobj.BDEFToolTip
   s obj.ToolTipType = eobj.BDEFToolTipType
   s obj.Type = eobj.BDEFType
   s obj.XType = eobj.BDEFXType
   s obj.Validator = eobj.BDEFValidator
   s obj.ValueGet = eobj.BDEFValueGet
   s obj.ValueSet = eobj.BDEFValueSet
   s sc=obj.%Save()
   d obj.%Close()
   If $$$ISOK(sc)
   {
    Tc
    s id = obj.%Id()
    s result = "{success:'true',id:'"_id_"'}"         //返回RowId
    //保存日志
    d:eobj.BDEFRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPExtExecItem","User.BDPExtExecItem","基本元素",id,eobj.BDEFName,"A",eobj)
    d:eobj.BDEFRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPExtExecItem","User.BDPExtExecItem","基本元素",eobj.BDEFRowId,eobj.BDEFName,"U",eobj,bobj)
   }
   else
   {
     Trollback
     s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"   
     s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基本元素","web.DHCBL.CT.BDPExtExecItem","SaveEntity",eobj)
     s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)   
   }
  }
 }
 else
 {
   s result = "{success:'false',errorinfo:'对象不存在！'}"
   s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基本元素","web.DHCBL.CT.BDPExtExecItem","SaveEntity","")
   s ^ERRORLOGINFO(logid)="对象不存在！" 
 } 
 q result
EEROE
 s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基本元素","web.DHCBL.CT.BDPExtExecItem","SaveEntity",eobj)
 s ^ERRORLOGINFO(logid)=$ze 
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Creator：sunfengchao
/// CreatDate: 2013-5-23
/// Description：根据id删除‘基本元素’的内容
/// Table：User.BDPExtExecItem
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
 s result = ""
 s eobj=##class(web.Entity.BDP.BDPExtExecItem).%New()
 s ParRef=$p(id,"||",1)
 s ChildSub=$p(id,"||",2)
 s eobj.BDEFRowId=id
 s eobj.BDEFCode=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),20)
 s eobj.BDEFName=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),37)
 s eobj.BDEFAllowBlank=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),18)
 s eobj.BDEFAutoShow=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),19)
 s eobj.BDEFEditable=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),22)
 s eobj.BDEFHandler=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),23)
 s eobj.BDEFHidden=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),24)
 s eobj.BDEFHiddenName=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),25)
 s eobj.BDEFIconCls=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),26)
 s eobj.BDEFReadOnly=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),27)
 s eobj.BDEFRegex=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),28)
 s eobj.BDEFRegexText=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),29)
 s eobj.BDEFToolTip=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),30)
 s eobj.BDEFToolTipType=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),31)
 s eobj.BDEFType=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),32)
 s eobj.BDEFValidator=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),33)
 s eobj.BDEFValueGet=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),35)
 s eobj.BDEFXType=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),34)
 s eobj.BDEFValueSet=$LISTGET($G(^User.BDPExecutablesD(ParRef,"ChildExtExecItem",ChildSub)),36)
 Tstart
 s sc=##class(User.BDPExtExecItem).%DeleteId(id)
 if $$$ISOK(sc)
 {  
  Tcommit 
  s result = "{success:'true',info:'删除成功！'}"
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPExtExecItem","User.BDPExtExecItem","基本元素",id,eobj.BDEFName,"D",eobj)
  d eobj.%Close()
 }
 else
 {
  Trollback
  s result="{success:'false',info:'删除失败！'}"
  s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("基本元素","web.DHCBL.CT.BDPExtExecItem","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc) 
 }
 q result
}

}
