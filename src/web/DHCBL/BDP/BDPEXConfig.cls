Import SQLUser

/// 名称:导出配置
/// 编写者：谷雪萍
/// 编写日期: 2016-1-28
Class web.DHCBL.BDP.BDPEXConfig Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：修改时打开的数据
/// Table：User.BDPMenu
/// Input：id
ClassMethod OpenData(ID As %String) As %String
{
 	s str="" 
 	s eobj = ##class(web.Entity.BDP.BDPEXConfig).%New()
 	s eobj.ID = ID
	s eobj.EXCTableDesc=$LISTGET($G(^User.BDPEXConfigD(ID)),2)
	s eobj.EXCTableName=$LISTGET($G(^User.BDPEXConfigD(ID)),3)
	s eobj.EXCIDName=$LISTGET($G(^User.BDPEXConfigD(ID)),4)
	s eobj.EXCXGlobal=$LISTGET($G(^User.BDPEXConfigD(ID)),5)
	s eobj.EXCLinkGofDr=$LISTGET($G(^User.BDPEXConfigD(ID)),6)
	s eobj.EXCLinkExcelDr=$LISTGET($G(^User.BDPEXConfigD(ID)),7)
	s eobj.EXCIsChildTable=$LISTGET($G(^User.BDPEXConfigD(ID)),8)
	s eobj.EXCParRefGlobal=$LISTGET($G(^User.BDPEXConfigD(ID)),9)
	 //s str = eobj.JsonS() 
	s str="{EXCTableDesc:'"_eobj.EXCTableDesc_"',EXCTableName:'"_eobj.EXCTableName_"',EXCIDName:'"_eobj.EXCIDName_"',ID:'"_eobj.ID_"',EXCXGlobal:'"_eobj.EXCXGlobal_"',EXCLinkGofDr:'"_eobj.EXCLinkGofDr_"',EXCLinkExcelDr:'"_eobj.EXCLinkExcelDr_"',EXCIsChildTable:'"_eobj.EXCIsChildTable_"',EXCParRefGlobal:'"_eobj.EXCParRefGlobal_"'}"
	d eobj.%Close()
	s str = "{list:["_str_"]}"
	q str
}

/// Table：User.BDPEXConfig
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPEXConfig","GetList","","","","")
Query GetList(RowId As %String, desc As %String, name As %String) As %Query(ROWSPEC = "ID:%String,EXCTableDesc:%String,EXCTableName:%String,EXCIDName:%String,EXCXGlobal:%String,EXCLinkGofDr:%String,EXCLinkExcelDr:%String,LinkGofDr:%String,LinkExcelDr:%String,EXCIsChildTable:%String,EXCParRefGlobal:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, RowId As %String, desc As %String, name As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (RowId'="") //根据rowid返回该条记录
 {
  s ID=RowId
  s EXCTableDesc=$LISTGET($G(^User.BDPEXConfigD(ID)),2)
  s EXCTableName=$LISTGET($G(^User.BDPEXConfigD(ID)),3)
  s EXCIDName=$LISTGET($G(^User.BDPEXConfigD(ID)),4)
  s EXCXGlobal=$LISTGET($G(^User.BDPEXConfigD(ID)),5)
  s EXCIsChildTable=$LISTGET($G(^User.BDPEXConfigD(ID)),8)
  s EXCParRefGlobal=$LISTGET($G(^User.BDPEXConfigD(ID)),9)
  s LinkGofDr=$LISTGET($G(^User.BDPEXConfigD(ID)),6)
  if (LinkGofDr'="") {
	s EXCLinkGofDr=$listget($g(^User.BDPEILinkD(LinkGofDr)),2)
  }
  else {
	s EXCLinkGofDr=""
  }
  s LinkExcelDr=$LISTGET($G(^User.BDPEXConfigD(ID)),7)
  if (LinkExcelDr'="") {
	s EXCLinkExcelDr=$listget($g(^User.BDPEILinkD(LinkExcelDr)),2)
  }
  else {
	s EXCLinkExcelDr=""
  }
  d OutputRow
 }
 else
 {
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s:name'="" name=$ZCONVERT(name,"U") //转换成大写
  s ID=0
  for{  
      s ID=$o(^User.BDPEXConfigD(ID)) 
   	  q:ID="" 
	  s EXCTableDesc=$LISTGET($G(^User.BDPEXConfigD(ID)),2)
	  s EXCTableName=$LISTGET($G(^User.BDPEXConfigD(ID)),3)
	  s EXCIDName=$LISTGET($G(^User.BDPEXConfigD(ID)),4)
	  s EXCXGlobal=$LISTGET($G(^User.BDPEXConfigD(ID)),5)
	  s EXCIsChildTable=$LISTGET($G(^User.BDPEXConfigD(ID)),8)
	  s EXCParRefGlobal=$LISTGET($G(^User.BDPEXConfigD(ID)),9)
	  s LinkGofDr=$LISTGET($G(^User.BDPEXConfigD(ID)),6)
	  if (LinkGofDr'="") {
		s EXCLinkGofDr=$listget($g(^User.BDPEILinkD(LinkGofDr)),2)
	  }
	  else {
		s EXCLinkGofDr=""
	  }
	  s LinkExcelDr=$LISTGET($G(^User.BDPEXConfigD(ID)),7)
	  if (LinkExcelDr'="") {
		s EXCLinkExcelDr=$listget($g(^User.BDPEILinkD(LinkExcelDr)),2)
	  }
	  else {
		s EXCLinkExcelDr=""
	  }
	  
	  s EXCTableDescU=$ZCONVERT(EXCTableDesc,"U")
	  s PINYIN=""
	  s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(EXCTableDescU)
	  if ((EXCTableDescU[desc)||(PINYIN[desc))&($ZCONVERT(EXCTableName,"U")[name) {
	  	d OutputRow
	  }
  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ID,EXCTableDesc,EXCTableName,EXCIDName,EXCXGlobal,EXCLinkGofDr,EXCLinkExcelDr,LinkGofDr,LinkExcelDr,EXCIsChildTable,EXCParRefGlobal)
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

/// 去掉末尾的空格
ClassMethod trim(str) As %String
{
  While($e(str,*)=" ")
  {
    s str=$e(str,1,*-1)
  }
  q str
}

/// Description：数据重复验证方法，由js调用
/// Table：User.BDPEXConfig
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, name As %String, desc As %String) As %String
{
  s:name'="" name=$ZCONVERT(name,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s flag="",flagc="",flagd=""
  s:name'="" flagc=$d(^User.BDPEXConfigI("UniqueTableName"," "_name))
  s:desc'="" flagd=$d(^User.BDPEXConfigI("UniqueTableDesc"," "_desc))
  if (id="") //如果为空，增加时的重复判断
  {
    if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
  }
  else //如果不为空，修改时的重复判断
  {
    s idc="",idd=""
    s:name'="" idc=$o(^User.BDPEXConfigI("UniqueTableName"," "_name,0))
    s:desc'="" idd=$o(^User.BDPEXConfigI("UniqueTableDesc"," "_desc,0))
    if (desc="")
    {
      if (idc'=id)&(flagc>0) s flag=1  //返回重复标志
      else  s flag=0 //返回不重复标志
    }
    elseif (name="")
    {
      if (idd'=id)&(flagd>0) s flag=1  //返回重复标志
      else  s flag=0 //返回不重复标志
    }
  }
  q flag
}

/// Description：保存
/// Table：User.BDPEXConfig
/// Return:成功返回true，失败返回false
/// Debug: d ##class(web.DHCBL.BDP.BDPEXConfig).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPEXConfig) As %String
{
  
  s result="",ClassFlag=""
  s ValidateFlag=""
  if $IsObject(eobj)
  {
  s flag=..Validate(eobj.ID,eobj.EXCTableName,eobj.EXCTableDesc)   
    if (flag=1)
    {
      s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
  
     if (eobj.ID="")  //如果RowId未赋值则增加
     { 
       s obj=##class(User.BDPEXConfig).%New()
     }
     else   //如果RowId已赋值则修改
     {
       s obj=##class(User.BDPEXConfig).%OpenId(eobj.ID)
       s bobj=##class(web.Entity.BDP.BDPEXConfig).%New()
       s bobj.ID=eobj.ID  
       s bobj.EXCTableDesc = obj.EXCTableDesc 
       s bobj.EXCTableName = obj.EXCTableName                                      
       s bobj.EXCIDName=obj.EXCIDName
       s bobj.EXCXGlobal=obj.EXCXGlobal     
       s:obj.EXCLinkGofDr'="" bobj.EXCLinkGofDr=obj.EXCLinkGofDr.%Id()
       s:obj.EXCLinkExcelDr'="" bobj.EXCLinkExcelDr=obj.EXCLinkExcelDr.%Id()
       s bobj.EXCIsChildTable=obj.EXCIsChildTable
       s bobj.EXCParRefGlobal=obj.EXCParRefGlobal
     }
     //s:eobj.EXCTableDesc'="" eobj.EXCTableDesc=$tr(eobj.EXCTableDesc," ","")   ; 去除空格
     s eobj.EXCTableDesc=..trim(eobj.EXCTableDesc)   ; 去除空格
     s eobj.EXCTableName=..trim(eobj.EXCTableName)   ; 去除空格
     
     s obj.EXCTableDesc = eobj.EXCTableDesc
     s obj.EXCTableName = eobj.EXCTableName                                      
     s obj.EXCIDName=eobj.EXCIDName
     s obj.EXCXGlobal=eobj.EXCXGlobal
     d obj.EXCLinkGofDrSetObjectId(eobj.EXCLinkGofDr)
     d obj.EXCLinkExcelDrSetObjectId(eobj.EXCLinkExcelDr)
     s:eobj.EXCIsChildTable="" eobj.EXCIsChildTable ="N" 
     s obj.EXCIsChildTable=eobj.EXCIsChildTable
     s obj.EXCParRefGlobal=eobj.EXCParRefGlobal
     Ts
     s sc=obj.%Save()
     d obj.%Close()
     If $$$ISOK(sc)
     {
       Tc
       s id = obj.%Id()
       s result = "{success:'true',id:'"_id_"'}"         //返回RowId
       //保存日志
       d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPEXConfig","User.BDPEXConfig","导出配置管理",id,eobj.EXCTableDesc,"A",eobj)
       d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPEXConfig","User.BDPEXConfig","导出配置管理",eobj.ID,eobj.EXCTableDesc,"U",eobj,bobj)
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
/// Table：User.BDPEXConfig
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
  s result=""
  s eobj=##class(web.Entity.BDP.BDPEXConfig).%New()
  s eobj.ID=id
  s eobj.EXCTableDesc=$LISTGET($G(^User.BDPEXConfigD(id)),2)
  s eobj.EXCTableName=$LISTGET($G(^User.BDPEXConfigD(id)),3)
  s eobj.EXCIDName=$LISTGET($G(^User.BDPEXConfigD(id)),4)
  s eobj.EXCXGlobal=$LISTGET($G(^User.BDPEXConfigD(id)),5)
  s eobj.EXCLinkGofDr=$LISTGET($G(^User.BDPEXConfigD(id)),6)
  s eobj.EXCLinkExcelDr=$LISTGET($G(^User.BDPEXConfigD(id)),7)
  s eobj.EXCIsChildTable=$LISTGET($G(^User.BDPEXConfigD(id)),8)
  s eobj.EXCParRefGlobal=$LISTGET($G(^User.BDPEXConfigD(id)),9)
  
  Tstart
  s sc=##class(User.BDPEXConfig).%DeleteId(id)
  IF $$$ISOK(sc) {    
    Tc
    s result="{success:'true',info:'删除成功！'}"
    //保存日志
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPEXConfig","User.BDPEXConfig","导出配置管理",id,eobj.EXCTableDesc,"D",eobj)
    d eobj.%Close()
  }else {
    Trollback
    s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
  }
 
 q result
}

}
