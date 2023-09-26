Import SQLUser

/// 名称:导入配置
/// 编写者：谷雪萍
/// 编写日期: 2016-1-28
Class web.DHCBL.BDP.BDPIMConfig Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Description：修改时打开的数据
/// Table：User.BDPMenu
/// Input：id
ClassMethod OpenData(ID As %String) As %String
{
 s str="" 
 s eobj = ##class(web.Entity.BDP.BDPIMConfig).%New()
 s eobj.ID = ID
 s eobj.IMCTableDesc=$LISTGET($G(^User.BDPIMConfigD(ID)),2)
 s eobj.IMCTableName=$LISTGET($G(^User.BDPIMConfigD(ID)),3)
 s eobj.IMCIDName=$LISTGET($G(^User.BDPIMConfigD(ID)),4)
 s eobj.IMCSaveClass=$LISTGET($G(^User.BDPIMConfigD(ID)),5)
 s eobj.IMCSaveMethod=$LISTGET($G(^User.BDPIMConfigD(ID)),6)
 s eobj.IMCSaveEntity=$LISTGET($G(^User.BDPIMConfigD(ID)),7)
 s eobj.IMCGetRowId=$LISTGET($G(^User.BDPIMConfigD(ID)),8)
 s eobj.IMCLinkGofDr=$LISTGET($G(^User.BDPIMConfigD(ID)),9)
 s eobj.IMCLinkExcelDr=$LISTGET($G(^User.BDPIMConfigD(ID)),10)
 s eobj.IMCParentDr=$LISTGET($G(^User.BDPIMConfigD(ID)),11)
 s eobj.IMCText=$LISTGET($G(^User.BDPIMConfigD(ID)),12)
 s eobj.EXCXGlobal=$LISTGET($G(^User.BDPIMConfigD(ID)),13)
 s eobj.EXCIsChildTable=$LISTGET($G(^User.BDPIMConfigD(ID)),14)
 s eobj.EXCParRefGlobal=$LISTGET($G(^User.BDPIMConfigD(ID)),15)
 
 s:eobj.EXCIsChildTable="Y" eobj.EXCIsChildTable="true"
 //s str = eobj.JsonS() 
 s str="{IMCTableDesc:'"_eobj.IMCTableDesc_"',IMCTableName:'"_eobj.IMCTableName_"',IMCIDName:'"_eobj.IMCIDName_"',ID:'"_eobj.ID_"',IMCSaveClass:'"_eobj.IMCSaveClass_"',IMCSaveMethod:'"_eobj.IMCSaveMethod_"',IMCSaveEntity:'"_eobj.IMCSaveEntity_"',IMCGetRowId:'"_eobj.IMCGetRowId_"',IMCLinkGofDr:'"_eobj.IMCLinkGofDr_"',IMCLinkExcelDr:'"_eobj.IMCLinkExcelDr_"',IMCParentDr:'"_eobj.IMCParentDr_"',IMCText:'"_eobj.IMCText_"',EXCXGlobal:'"_eobj.EXCXGlobal_"',EXCIsChildTable:'"_eobj.EXCIsChildTable_"',EXCParRefGlobal:'"_eobj.EXCParRefGlobal_"'}"
 d eobj.%Close()
 s str=$tr(str,$c(10),"")
 s str = "{list:["_str_"]}"
 q str
}

/// Table：User.BDPIMConfig
/// Dubug: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPIMConfig","GetList","","","","")
Query GetList(RowId As %String, desc As %String, name As %String) As %Query(ROWSPEC = "ID:%String,IMCTableDesc:%String,IMCTableName:%String,IMCIDName:%String,IMCSaveClass:%String,IMCSaveMethod:%String,IMCSaveEntity:%String,IMCGetRowId:%String,IMCLinkGofDr:%String,IMCLinkExcelDr:%String,IMCParentDr:%String,IMCText:%String,LinkGofDr:%String,LinkExcelDr:%String,ParentDr:%String,EXCXGlobal:%String,EXCIsChildTable:%String,EXCParRefGlobal:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, RowId As %String, desc As %String, name As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (RowId'="") //根据rowid返回该条记录
 {
	  s ID=RowId
	  s IMCTableDesc=$LISTGET($G(^User.BDPIMConfigD(ID)),2)
	  s IMCTableName=$LISTGET($G(^User.BDPIMConfigD(ID)),3)
	  s IMCIDName=$LISTGET($G(^User.BDPIMConfigD(ID)),4)
	  s IMCSaveClass=$LISTGET($G(^User.BDPIMConfigD(ID)),5)
	  s IMCSaveMethod=$LISTGET($G(^User.BDPIMConfigD(ID)),6)
	  s IMCSaveEntity=$LISTGET($G(^User.BDPIMConfigD(ID)),7)
	  s IMCGetRowId=$LISTGET($G(^User.BDPIMConfigD(ID)),8)
	  s LinkGofDr=$LISTGET($G(^User.BDPIMConfigD(ID)),9)
	  if (LinkGofDr'="") {
		s IMCLinkGofDr=$listget($g(^User.BDPEILinkD(LinkGofDr)),2)
	  }
	  else {
		s IMCLinkGofDr=""
	  }
	  s LinkExcelDr=$LISTGET($G(^User.BDPIMConfigD(ID)),10)
	  if (LinkExcelDr'="") {
		s IMCLinkExcelDr=$listget($g(^User.BDPEILinkD(LinkExcelDr)),2)
	  }
	  else {
		s IMCLinkExcelDr=""
	  }
	  s ParentDr=$LISTGET($G(^User.BDPIMConfigD(ID)),11)

	  if (ParentDr'="") {
		s IMCParentDr=$listget($g(^User.BDPIMConfigD(ParentDr)),2)
	  }
	  else {
		s IMCParentDr=""
	  }
	  s IMCText=$LISTGET($G(^User.BDPIMConfigD(ID)),12)
	  s EXCXGlobal=$LISTGET($G(^User.BDPIMConfigD(ID)),13)
	  s EXCIsChildTable=$LISTGET($G(^User.BDPIMConfigD(ID)),14)
	  s EXCParRefGlobal=$LISTGET($G(^User.BDPIMConfigD(ID)),15)
	  d OutputRow
 }
 else
 {
	  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	  s:name'="" name=$ZCONVERT(name,"U") //转换成大写
	  s ID=0
	  for{
	   	  s ID=$o(^User.BDPIMConfigD(ID)) 
	  	  q:ID="" 
		  s IMCTableDesc=$LISTGET($G(^User.BDPIMConfigD(ID)),2)
		  s IMCTableName=$LISTGET($G(^User.BDPIMConfigD(ID)),3)
		  s IMCIDName=$LISTGET($G(^User.BDPIMConfigD(ID)),4)
		  s IMCSaveClass=$LISTGET($G(^User.BDPIMConfigD(ID)),5)
		  s IMCSaveMethod=$LISTGET($G(^User.BDPIMConfigD(ID)),6)
		  s IMCSaveEntity=$LISTGET($G(^User.BDPIMConfigD(ID)),7)
		  s IMCGetRowId=$LISTGET($G(^User.BDPIMConfigD(ID)),8)
		  s LinkGofDr=$LISTGET($G(^User.BDPIMConfigD(ID)),9)
		  if (LinkGofDr'="") {
			s IMCLinkGofDr=$listget($g(^User.BDPEILinkD(LinkGofDr)),2)
		  }
		  else {
			s IMCLinkGofDr=""
		  }
		  s LinkExcelDr=$LISTGET($G(^User.BDPIMConfigD(ID)),10)
		  if (LinkExcelDr'="") {
			s IMCLinkExcelDr=$listget($g(^User.BDPEILinkD(LinkExcelDr)),2)
		  }
		  else {
			s IMCLinkExcelDr=""
		  }
		  s ParentDr=$LISTGET($G(^User.BDPIMConfigD(ID)),11)
  
		  if (ParentDr'="") {
			s IMCParentDr=$listget($g(^User.BDPIMConfigD(ParentDr)),2)
		  }
		  else {
			s IMCParentDr=""
		  }
		  s IMCText=$LISTGET($G(^User.BDPIMConfigD(ID)),12)
		  s EXCXGlobal=$LISTGET($G(^User.BDPIMConfigD(ID)),13)
		  s EXCIsChildTable=$LISTGET($G(^User.BDPIMConfigD(ID)),14)
		  s EXCParRefGlobal=$LISTGET($G(^User.BDPIMConfigD(ID)),15)
		  
		  s IMCTableDescU=$ZCONVERT(IMCTableDesc,"U")
		  s PINYIN=""
		  s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(IMCTableDescU)
		  if ((IMCTableDescU[desc)||(PINYIN[desc))&($ZCONVERT(IMCTableName,"U")[name){
		 	 d OutputRow
		  }
	  }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(ID,IMCTableDesc,IMCTableName,IMCIDName,IMCSaveClass,IMCSaveMethod,IMCSaveEntity,IMCGetRowId,IMCLinkGofDr,IMCLinkExcelDr,IMCParentDr,IMCText,LinkGofDr,LinkExcelDr,ParentDr,EXCXGlobal,EXCIsChildTable,EXCParRefGlobal)
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

/// Description：数据重复验证方法，由js调用
/// Table：User.BDPIMConfig
/// Input：id, desc
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(id As %String, name As %String, desc As %String) As %String
{
  s:name'="" name=$ZCONVERT(name,"U") //转换成大写
  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  s flag="",flagc="",flagd=""
  s:name'="" flagc=$d(^User.BDPIMConfigI("UniqueTableName"," "_name))
  s:desc'="" flagd=$d(^User.BDPIMConfigI("UniqueTableDesc"," "_desc))
  if (id="") //如果为空，增加时的重复判断
  {
    if ((flagc>0)||(flagd>0)) s flag=1  //返回重复标志
    else  s flag=0 //返回不重复标志
  }
  else //如果不为空，修改时的重复判断
  {
    s idc="",idd=""
    s:name'="" idc=$o(^User.BDPIMConfigI("UniqueTableName"," "_name,0))
    s:desc'="" idd=$o(^User.BDPIMConfigI("UniqueTableDesc"," "_desc,0))
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

/// 去掉末尾的空格
ClassMethod trim(str) As %String
{
  While($e(str,*)=" ")
  {
    s str=$e(str,1,*-1)
  }
  q str
}

/// Description：保存
/// Table：User.BDPIMConfig
/// Return:成功返回true，失败返回false
/// Debug: d ##class(web.DHCBL.BDP.BDPIMConfig).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPIMConfig) As %String
{
  
  s result="",ClassFlag=""
  s ValidateFlag=""
  s:eobj.EXCIsChildTable="" eobj.EXCIsChildTable="N"
  if $IsObject(eobj)
  {
  s flag=..Validate(eobj.ID,eobj.IMCTableName,eobj.IMCTableDesc)   
    if (flag=1)
    {
      s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
  
     if (eobj.ID="")  //如果RowId未赋值则增加
     { 
       s obj=##class(User.BDPIMConfig).%New()
     }
     else   //如果RowId已赋值则修改
     {
       s obj=##class(User.BDPIMConfig).%OpenId(eobj.ID)
       s bobj=##class(web.Entity.BDP.BDPIMConfig).%New()
       s bobj.ID=eobj.ID  
       s bobj.IMCTableDesc = obj.IMCTableDesc 
       s bobj.IMCTableName = obj.IMCTableName                                      
       s bobj.IMCIDName=obj.IMCIDName
       s bobj.IMCSaveClass=obj.IMCSaveClass     
       s bobj.IMCSaveMethod=eobj.IMCSaveMethod
       s bobj.IMCSaveEntity=eobj.IMCSaveEntity  
       s bobj.IMCGetRowId=eobj.IMCGetRowId
       s bobj.IMCText=eobj.IMCText
       s bobj.EXCXGlobal=eobj.EXCXGlobal
       s bobj.EXCIsChildTable=eobj.EXCIsChildTable
       s bobj.EXCParRefGlobal=eobj.EXCParRefGlobal
       s:obj.IMCLinkGofDr'="" bobj.IMCLinkGofDr=obj.IMCLinkGofDr.%Id()
       s:obj.IMCLinkExcelDr'="" bobj.IMCLinkExcelDr=obj.IMCLinkExcelDr.%Id()
       s:obj.IMCParentDr'="" bobj.IMCParentDr=obj.IMCParentDr.%Id()
     }
     //s:eobj.IMCTableDesc'="" eobj.IMCTableDesc=$tr(eobj.IMCTableDesc," ","")   ; 去除空格
     s eobj.IMCTableDesc=..trim(eobj.IMCTableDesc)   ; 去除空格
     s eobj.IMCTableName=..trim(eobj.IMCTableName)   ; 去除空格
     
     s obj.IMCTableDesc = eobj.IMCTableDesc
     s obj.IMCTableName = eobj.IMCTableName                                      
     s obj.IMCIDName=eobj.IMCIDName
     s obj.IMCSaveClass=eobj.IMCSaveClass
     s obj.IMCSaveMethod=eobj.IMCSaveMethod
     s obj.IMCSaveEntity=eobj.IMCSaveEntity
     s obj.IMCGetRowId=eobj.IMCGetRowId
  	 s obj.IMCText=eobj.IMCText
  	 s obj.EXCXGlobal=eobj.EXCXGlobal
  	 s:eobj.EXCIsChildTable="" eobj.EXCIsChildTable ="N" 
	 s obj.EXCIsChildTable=eobj.EXCIsChildTable
  	 s obj.EXCParRefGlobal=eobj.EXCParRefGlobal
     d obj.IMCLinkGofDrSetObjectId(eobj.IMCLinkGofDr)
     d obj.IMCLinkExcelDrSetObjectId(eobj.IMCLinkExcelDr)
     d obj.IMCParentDrSetObjectId(eobj.IMCParentDr)
     Ts
     s sc=obj.%Save()
     d obj.%Close()
     If $$$ISOK(sc)
     {
       Tc
       s id = obj.%Id()
       s result = "{success:'true',id:'"_id_"'}"         //返回RowId
       //保存日志
       d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPIMConfig","User.BDPIMConfig","导入配置管理",id,eobj.IMCTableDesc,"A",eobj)
       d:eobj.ID'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPIMConfig","User.BDPIMConfig","导入配置管理",eobj.ID,eobj.IMCTableDesc,"U",eobj,bobj)
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

/// Description：保存
/// Table：User.BDPIMConfig
/// Return:成功返回true，失败返回false
/// Debug: d ##class(web.DHCBL.BDP.BDPIMConfig).SaveInheritEntity()
ClassMethod SaveInheritEntity(eobj As web.Entity.BDP.BDPIMConfig) As %String
{
  
  s result="",ClassFlag=""
  s ValidateFlag=""
  if $IsObject(eobj)
  {
  	s flag=..Validate(eobj.ID,eobj.IMCTableName,eobj.IMCTableDesc)   
    if (flag=1)
    {
      s result = "{success:'false',errorinfo:'该记录已经存在！'}"
    }
    else
    {
      s obj=##class(User.BDPIMConfig).%New()

     //s:eobj.IMCTableDesc'="" eobj.IMCTableDesc=$tr(eobj.IMCTableDesc," ","")   ; 去除空格
     s eobj.IMCTableDesc=..trim(eobj.IMCTableDesc)   ; 去除空格
     s eobj.IMCTableName=..trim(eobj.IMCTableName)   ; 去除空格
     
     s obj.IMCTableDesc = eobj.IMCTableDesc
     s obj.IMCTableName = eobj.IMCTableName                                      
     s obj.IMCIDName=eobj.IMCIDName
     s obj.IMCSaveClass=eobj.IMCSaveClass
     s obj.IMCSaveMethod=eobj.IMCSaveMethod
     s obj.IMCSaveEntity=eobj.IMCSaveEntity
     s obj.IMCGetRowId=eobj.IMCGetRowId
     s obj.IMCText=eobj.IMCText
     s obj.EXCXGlobal=eobj.EXCXGlobal
     s obj.EXCIsChildTable=eobj.EXCIsChildTable
     s obj.EXCParRefGlobal=eobj.EXCParRefGlobal
     d obj.IMCLinkGofDrSetObjectId(eobj.IMCLinkGofDr)
     d obj.IMCLinkExcelDrSetObjectId(eobj.IMCLinkExcelDr)
     d obj.IMCParentDrSetObjectId(eobj.IMCParentDr)
     Ts
     s sc=obj.%Save()
     d obj.%Close()
     If $$$ISOK(sc)
     {
       s id = obj.%Id()
       s result=result_"^"_1 	
       
       //保存扩展表字段	
       s ID=0
       s ParRef=eobj.IMCParentDr
       if (ParRef'="")
       {
       	for
       	{  
	      	s ID=$o(^User.BDPIMConfigD(ParRef,"ChildField",ID)) q:ID=""  
	      	s eobjf=##class(web.Entity.BDP.BDPIMFieldConfig).%New()
	      	s eobjf.FieldRowId=""
		  	s eobjf.ParRef=id
		  	s eobjf.IMFCFieldName=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),3)
		  	s eobjf.IMFCFieldDesc=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),2)
		  	s eobjf.IMFCFieldType=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),4)
		  	s eobjf.IMFCCodeToID=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),5)
		  	s eobjf.IMFCConTable=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),6)
		  	s eobjf.IMFCInheritFlag="Y"
		  	s eobjf.IMFCUnique=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),8)
  			s eobjf.IMFCRequired=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),9)
  			s eobjf.IMFCImport=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),10)
  			s eobjf.IMFCOrder=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),11)  //2019-03-09
		  	s estr=##class(web.DHCBL.BDP.BDPIMFieldConfig).SaveEntity(eobjf)
			//b ;estrn
			if (estr["success:'true'")
			{
				 s result=result_"^"_1 				
			}
			if (estr["success:'false'")
			{
				s result=result_"^"_0				
			}
		  
       	}
       	
       }
       //扩展时把代码和描述同步到导入导出菜单维护
       s TableName=$LISTGET($G(^User.BDPIMConfigD(ParRef)),3)
       s menuid=""
       s:TableName'="" menuid=$o(^User.BDPEIMenuI("TableNameIdx",TableName,0))
       if (menuid'="")
       {
	       s objmenu=##class(User.BDPEIMenu).%OpenId(menuid)
	       s objmenu.Code=eobj.IMCTableName 
	       s objmenu.Caption=eobj.IMCTableDesc
	       s scmenu=objmenu.%Save()
		   d objmenu.%Close()
		   If $$$ISOK(scmenu)
		   {
			   s result=result_"^"_1
		   }
		   else
		   {
			   s result=result_"^"_0
		   }
       }
       
     }
     else
     {
	     s result =result_"^"_0	
     }
     if (result[0)
     {
	     Trollback
	     s result = "{success:'false',errorinfo:'保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
     }
     else
     {
	     Tc
	     s result = "{success:'true',id:'"_id_"'}"         //返回RowId
	     //保存日志
       	 d:eobj.ID="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPIMConfig","User.BDPIMConfig","导入配置管理",id,eobj.IMCTableDesc,"A",eobj)

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
/// Table：User.BDPIMConfig
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
  s result=""
  s eobj=##class(web.Entity.BDP.BDPIMConfig).%New()
  s eobj.ID=id
  s eobj.IMCTableDesc=$LISTGET($G(^User.BDPIMConfigD(id)),2)
  s eobj.IMCTableName=$LISTGET($G(^User.BDPIMConfigD(id)),3)
  s eobj.IMCIDName=$LISTGET($G(^User.BDPIMConfigD(id)),4)
  s eobj.IMCSaveClass=$LISTGET($G(^User.BDPIMConfigD(id)),5)
  s eobj.IMCSaveMethod=$LISTGET($G(^User.BDPIMConfigD(id)),6)
  s eobj.IMCSaveEntity=$LISTGET($G(^User.BDPIMConfigD(id)),7)
  s eobj.IMCGetRowId=$LISTGET($G(^User.BDPIMConfigD(id)),8)
  s eobj.IMCLinkGofDr=$LISTGET($G(^User.BDPIMConfigD(id)),9)
  s eobj.IMCLinkExcelDr=$LISTGET($G(^User.BDPIMConfigD(id)),10)
  s eobj.IMCParentDr=$LISTGET($G(^User.BDPIMConfigD(id)),11)
  s eobj.IMCText=$LISTGET($G(^User.BDPIMConfigD(id)),12)
  s eobj.EXCXGlobal=$LISTGET($G(^User.BDPIMConfigD(id)),13)
  s eobj.EXCIsChildTable=$LISTGET($G(^User.BDPIMConfigD(id)),14)
  s eobj.EXCParRefGlobal=$LISTGET($G(^User.BDPIMConfigD(id)),15)
  
  Tstart
  s sc=##class(User.BDPIMConfig).%DeleteId(id)
  IF $$$ISOK(sc) {    
    Tc
    s result="{success:'true',info:'删除成功！'}"
    //保存日志
    d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPIMConfig","User.BDPIMConfig","导入配置管理",id,eobj.IMCTableDesc,"D",eobj)
    d eobj.%Close()
  }else {
    Trollback
    s result= "{success:'false',info:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"  //返回错误信息
  }
 
 q result
}

/// 判断是否进行过导入扩展
/// Debug: w ##class(web.DHCBL.BDP.BDPIMConfig).HasExpand()
ClassMethod HasExpand(id) As %String
{
  s flag=0
  if ($d(^User.BDPIMConfigI("ParIdx",id)))
  {
	  s flag=1
  }
  q flag
}

/// d ##class(web.DHCBL.BDP.BDPIMConfig).KillBDPIMConfig()
ClassMethod KillBDPIMConfig()
{
  s ID=141
  for
  {
    s ID=$o(^User.BDPIMConfigD(ID))
    q:ID=""  
    s ChildID=0, RowID=""
    for
    {
      s ChildID=$o(^User.BDPIMConfigD(ID,"ChildField",ChildID))
      q:ChildID="" 
      
      k ^User.BDPIMFieldConfigI
      k ^User.BDPIMConfigD(ID,"ChildField")  
     
    }
     k ^User.BDPIMConfigD(ID)
     k ^User.BDPIMConfigI
     d ##class(User.BDPIMConfig).%BuildIndices()  
     d ##class(User.BDPIMFieldConfig).%BuildIndices()  
  }
}

/// Function: 根据表结构登记的数据批量添加导入配置表的数据
/// Creator:  sunfengchao
/// CreateDate:2016-3-15
/// debug:   d ##class(web.DHCBL.BDP.BDPIMConfig).MultiSaveData()
ClassMethod MultiSaveData() As %String
{
  ; 循环遍历表结构登记的数据
  s ID=141
  for
  {
    s ID=$o(^User.BDPTableListD(ID))
    q:ID=""  
    s ClassName=$LISTGET($G(^User.BDPTableListD(ID)),2)
    s TableDesc=$LISTGET($G(^User.BDPTableListD(ID)),3) ; 中文描述
    s XCode=$LISTGET($G(^User.BDPTableListD(ID)),4)     ;获取global
    s TableName=$LISTGET($G(^User.BDPTableListD(ID)),8) ;表名称
    
    if (XCode'="")
    {
      s GlobalName=$p($g(XCode),"$g(",2)  ;^CTPCP(RowId,1)),"^",2)
      s GlobalName=$p($p($g(GlobalName),"),",1),",",1)  ;;^CTPCP(RowId 
      if (GlobalName'="")
      {
        s GlobalName="$o("_GlobalName_",xrowid))"
      }
      else
      {
         s GlobalName="" ;; "$o("_GlobalName_",xrowid))" 
      }
    }
    else
    {
      s GlobalName="" 
    }
    s myItems="", Property="",myCount=""
    s ChildID=0
    for 
    {
       s ChildID=$O(^User.BDPTableListD(ID,"ChildField",ChildID))
       q:ChildID="" 
       s FieldDesc=$LISTGET($G(^User.BDPTableListD(ID,"ChildField",ChildID)),2)
       if (FieldDesc["RowId")
       {
        k ^tmp("IMport","RowID")
        s FieldName=$LISTGET($G(^User.BDPTableListD(ID,"ChildField",ChildID)),3)
        s ^tmp("IMport","RowID")=FieldName
        q
       } 
       else  
       {
         continue
       }
    }
    s ClassN="web.Entity.CT."_$p($LISTGET($G(^User.BDPTableListD(ID)),2),"User.",2)
    s eobj=##class(web.Entity.BDP.BDPIMConfig).%New()
    s eobj.IMCTableDesc= TableDesc
    s eobj.IMCTableName=TableName
    s eobj.IMCIDName=$g(^tmp("IMport","RowID"))  
    s eobj.IMCSaveEntity=ClassN
    s eobj.IMCSaveClass="web.DHCBL.CT."_$p($LISTGET($G(^User.BDPTableListD(ID)),2),"User.",2)
    s eobj.IMCSaveMethod="SaveEntity"
    s eobj.IMCLinkExcelDr="3"
    s eobj.IMCLinkGofDr="1"
    d ..SaveEntity(eobj)
  }
}

/// Function: 批量添加导入配置表的字段数据
/// Creator:  sunfengchao
/// CreateDate:2016-3-15
///   d ##class(web.DHCBL.BDP.BDPIMConfig).MultiSaveBDPEXField()
ClassMethod MultiSaveBDPEXField() As %String
{
  s ID=141
  for
  {
    s ID=$o(^User.BDPIMConfigD(ID))
    q:ID=""  
    s TableName=$LISTGET($G(^User.BDPIMConfigD(ID)),3) ;表名称
    s TableDesc=$LISTGET($G(^User.BDPIMConfigD(ID)),2) ; 中文描述
    s TableNameI=" "_$zcvt(TableName,"U")
    s idc=0
    s idc=$o(^User.BDPTableListI("NameIndex",TableNameI,0))  
    q:idc=""
    
    s ChildID=0, RowID=""    
    for
    { 
      s ChildID=$o(^User.BDPTableListD(idc,"ChildField",ChildID))
      q:ChildID=""   
      s FieldRowId=idc_"||"_ChildID
      s FieldParRef=ID
      s eobj=##class(web.Entity.BDP.BDPIMFieldConfig).%New()
      s eobj.ParRef=ID
      s eobj.IMFCFieldName=$LISTGET($G(^User.BDPTableListD(idc,"ChildField",ChildID)),3)
      s eobj.IMFCFieldDesc=$LISTGET($G(^User.BDPTableListD(idc,"ChildField",ChildID)),2)
      s eobj.IMFCFieldType=$LISTGET($G(^User.BDPTableListD(idc,"ChildField",ChildID)),5)
      s FieldDescU=$ZCONVERT(eobj.IMFCFieldDesc,"U")
      continue:FieldDescU="ROWID"     
      w ID_" "_idc_" "_TableName_" "_TableDesc_"  "_ChildID_ " " _eobj.IMFCFieldName_"^"_eobj.IMFCFieldDesc ,!
      d ##class(web.DHCBL.BDP.BDPIMFieldConfig).SaveEntity(eobj)
    }   
  }
}

/// d ##class(web.DHCBL.BDP.BDPIMConfig).KillBDPIMFieldConfig()
ClassMethod KillBDPIMFieldConfig()
{
  s ID=141
  for
  {
    s ID=$o(^User.BDPIMConfigD(ID))
    q:ID=""  
    s ChildID=0, RowID=""
    for
    {
      s ChildID=$o(^User.BDPIMConfigD(ID,"ChildField",ChildID))
      q:ChildID="" 
      k ^User.BDPIMFieldConfigI
      k ^User.BDPIMConfigD(ID,"ChildField")  
      d ##class(User.BDPIMFieldConfig).%BuildIndices()  
    }
  }
}

}
