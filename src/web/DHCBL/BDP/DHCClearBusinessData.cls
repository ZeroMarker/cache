Import SQLUser

/// 名称:清业务数据维护信息
/// 描述:清业务数据维护信息，包含增删改查功能
/// 编写者：谷雪萍
/// 编写日期: 2015-9-15
Class web.DHCBL.BDP.DHCClearBusinessData Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：修改时打开的数据
/// Other: w ##class(web.DHCBL.BDP.DHCClearBusinessData).OpenData("1")
ClassMethod OpenData(id As %String) As %String
{
	s str=""	
	s eobj = ##class(web.Entity.BDP.DHCClearBusinessData).%New()
	s eobj.ClearRowID = id
	s eobj.ClearProductGroup=$listget($g(^User.DHCClearBusinessDataD(id)),2)
	s eobj.ClearGlobal=$listget($g(^User.DHCClearBusinessDataD(id)),3)
	s eobj.ClearGlobalTable=$listget($g(^User.DHCClearBusinessDataD(id)),4)
	s eobj.ClearDesc=$listget($g(^User.DHCClearBusinessDataD(id)),5)
	s eobj.ClearStatus=$listget($g(^User.DHCClearBusinessDataD(id)),6)
	s eobj.ClearNamespace=$listget($g(^User.DHCClearBusinessDataD(id)),7)
	s str = eobj.JsonS()	
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Table：User.DHCClearBusinessData
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.DHCClearBusinessData","GetList","","","","")
Query GetList(rowid As %String, group As %String, global As %String, desc As %String) As %Query(ROWSPEC = "ClearRowID:%String,ClearProductGroup:%String,ClearGlobal:%String,ClearGlobalTable:%String,ClearDesc:%String,ClearStatus:%String,ClearNamespace:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, rowid As %String, group As %String, global As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (rowid'="") //根据rowid返回该条记录
 {
  s ClearRowID=rowid
  s ClearProductGroup=$LISTGET($G(^User.DHCClearBusinessDataD(ClearRowID)),2)
  s ClearGlobal=$LISTGET($G(^User.DHCClearBusinessDataD(ClearRowID)),3)
  s ClearGlobalTable=$LISTGET($G(^User.DHCClearBusinessDataD(ClearRowID)),4)
  s ClearDesc=$LISTGET($G(^User.DHCClearBusinessDataD(ClearRowID)),5)
  s ClearStatus=$LISTGET($G(^User.DHCClearBusinessDataD(ClearRowID)),6)
  s ClearNamespace=$listget($g(^User.DHCClearBusinessDataD(ClearRowID)),7)

  d OutputRow
 }
 else
 {
  s:group'="" group=$ZCONVERT(group,"U") //转换成大写
  s:global'="" global=$ZCONVERT(global,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s ClearRowID=0
  f  s ClearRowID=$o(^User.DHCClearBusinessDataD(ClearRowID)) q:ClearRowID=""  d
  .s ClearProductGroup=$LISTGET($G(^User.DHCClearBusinessDataD(ClearRowID)),2)
  .s ClearGlobal=$LISTGET($G(^User.DHCClearBusinessDataD(ClearRowID)),3)
  .s ClearGlobalTable=$LISTGET($G(^User.DHCClearBusinessDataD(ClearRowID)),4)
  .s ClearDesc=$LISTGET($G(^User.DHCClearBusinessDataD(ClearRowID)),5)
  .s ClearStatus=$LISTGET($G(^User.DHCClearBusinessDataD(ClearRowID)),6)
  .s ClearNamespace=$listget($g(^User.DHCClearBusinessDataD(ClearRowID)),7)
  .if ($ZCONVERT(ClearProductGroup,"U")[group)&($ZCONVERT(ClearGlobal,"U")[global)&($ZCONVERT(ClearDesc,"U")[desc) d
  ..d OutputRow
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ClearRowID,ClearProductGroup,ClearGlobal,ClearGlobalTable,ClearDesc,ClearStatus,ClearNamespace)
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

/// Description：数据重复验证方法
/// Table：User.DHCClearBusinessData
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, code As %String) As %String
{
   s:code'="" code=$ZCONVERT(code,"U") //转换成大写
   s flag="",flagc=""
   s:code'="" flagc=$d(^User.DHCClearBusinessDataI("ClearGlobalI"," "_code))
   if (id="") //如果为空，增加时的重复判断
   {
     if (flagc>0) s flag=1  //返回重复标志
     else  s flag=0 //返回不重复标志
   }
  else //如果不为空，修改时的重复判断
  {
   s idc=""
   s:code'="" idc=$o(^User.DHCClearBusinessDataI("ClearGlobalI"," "_code,0))
   if ((idc'=id)&(flagc>0)) s flag=1  //返回重复标志
   else  s flag=0 //返回不重复标志
  }
 q flag
}

/// Description：保存
/// Table：User.DHCClearBusinessData
/// Return:成功返回true，失败返回false
/// Debug: d ##class(web.DHCBL.BDP.DHCClearBusinessData).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.BDP.DHCClearBusinessData) As %String
{
  
  s result=""
  if $IsObject(eobj)
  {
	s flag=..Validate(eobj.ClearRowID,eobj.ClearGlobal)   
  	if (flag=1)
    {
     	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
  
	   if (eobj.ClearRowID="")  //如果RowId未赋值则增加
	   { 
	     s obj=##class(User.DHCClearBusinessData).%New()
	   }
	   else   //如果RowId已赋值则修改
	   {
	     s obj=##class(User.DHCClearBusinessData).%OpenId(eobj.ClearRowID)
	     s bobj=##class(web.Entity.BDP.DHCClearBusinessData).%New()
	     s bobj.ClearProductGroup = obj.ClearProductGroup 
	     s bobj.ClearGlobal = obj.ClearGlobal                                      
	     s bobj.ClearGlobalTable=obj.ClearGlobalTable
	     s bobj.ClearDesc=obj.ClearDesc
	     s bobj.ClearStatus=obj.ClearStatus
	     s bobj.ClearNamespace=obj.ClearNamespace
	     s bobj.ClearRowID=eobj.ClearRowID    
	   }
	   s obj.ClearProductGroup = eobj.ClearProductGroup
	  // s:eobj.ClearGlobal'="" eobj.ClearGlobal=$replace(eobj.ClearGlobal," ","")   ; 去除空格
	   s obj.ClearGlobal = eobj.ClearGlobal                                      
	   s obj.ClearGlobalTable=eobj.ClearGlobalTable
	   s obj.ClearDesc=eobj.ClearDesc
	   s obj.ClearStatus=eobj.ClearStatus
	   s obj.ClearNamespace=eobj.ClearNamespace
	   Ts
	   s sc=obj.%Save()
	   d obj.%Close()
	   If $$$ISOK(sc)
	   {
	     Tc
	     s id = obj.%Id()
	     s result = "{success:'true',id:'"_id_"'}"         //返回RowId
	     //保存日志
	     d:eobj.ClearRowID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ClearBusinessData","User.DHCClearBusinessData","清业务数据维护信息",id,eobj.ClearGlobal,"A",eobj)
	     d:eobj.ClearRowID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ClearBusinessData","User.DHCClearBusinessData","清业务数据维护信息",id,eobj.ClearGlobal,"U",eobj,bobj)
	   }
	   else
	   {
	      Trollback
	      s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
	   }
  }
 }
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
  q result
}

/// Function：根据id删除
/// Table：User.DHCClearBusinessData
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
  s result=""
  
	s pobj = ##class(User.DHCClearBusinessData).%OpenId(id)
	s eobj = ##class(web.Entity.BDP.DHCClearBusinessData).%New()
	s eobj.ClearRowID = id
	s eobj.ClearProductGroup = pobj.ClearProductGroup
	s eobj.ClearGlobal = pobj.ClearGlobal
	s eobj.ClearGlobalTable =pobj.ClearGlobalTable
	s eobj.ClearDesc =pobj.ClearDesc
	s eobj.ClearStatus =pobj.ClearStatus
	s eobj.ClearNamespace =pobj.ClearNamespace
	d pobj.%Close()
	k pobj
	Tstart
	s sc=##class(User.DHCClearBusinessData).%DeleteId(id)
  IF $$$ISOK(sc) {	  
	  Tc
	  s result="{success:'true',info:'删除成功！'}"
	  //保存日志
	  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("DHC_ClearBusinessData","User.DHCClearBusinessData","清业务数据维护信息",id,eobj.ClearGlobal,"D",eobj)
	  d eobj.%Close()
  }else {
	  Trollback
	  s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
  }
 
 q result
}

}
