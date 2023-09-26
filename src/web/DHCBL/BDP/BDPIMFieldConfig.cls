Import SQLUser

/// 名称:导入配置表字段维护 
/// 描述:包含增删改查功能
/// 编写者：谷雪萍
/// 编写日期: 2016-1-28
Class web.DHCBL.BDP.BDPIMFieldConfig Extends %RegisteredObject [ ProcedureBlock ]
{

/// Table：User.BDPIMFieldConfig
/// Input：ParRef
/// Debug: d ##class(%ResultSet).RunQuery("","","","")
Query GetList(ParRef As %String, RowId As %String, code As %String, desc As %String) As %Query(ROWSPEC = "FieldRowId:%String,IMFCFieldName:%String,IMFCFieldDesc:%String,FieldParRef:%String,IMFCFieldType:%String,IMFCCodeToID:%String,IMFCConTable:%String,IMFCInheritFlag:%String,IMFCUnique:%String,IMFCRequired:%String,IMFCImport:%String,IMFCOrder:%String,EXFCIDToCode:%String,EXFCGetField:%String,IMFCExport:%String,EXFCFieldType:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String, RowId As %String, code As %String, desc As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (RowId'="") //根据rowid返回该条记录
 {
  s ID=$p(RowId,"||",2)
  s FieldRowId=RowId
  s FieldParRef=$p(RowId,"||",1)
  s IMFCFieldName=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),3)
  s IMFCFieldDesc=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),2)
  s IMFCFieldType=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),4)
  s IMFCCodeToID=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),5)
  s IMFCConTable=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),6)
  s IMFCInheritFlag=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),7)
  s IMFCUnique=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),8)
  s IMFCRequired=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),9)
  s IMFCImport=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),10)
  s IMFCOrder=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),11)
  s EXFCIDToCode=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),12)
  s EXFCGetField=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),13)
  s IMFCExport=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),14)
  s EXFCFieldType=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),15)
  d OutputRow
 }
 else
 {
	 if ParRef'=""
	 {
	  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	  s ID=0
	  f  s ID=$o(^User.BDPIMConfigD(ParRef,"ChildField",ID)) q:ID=""  d
	  .s FieldRowId=ParRef_"||"_ID
	  .s FieldParRef=ParRef
	  .s IMFCFieldName=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),3)
	  .s IMFCFieldDesc=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),2)
	  .s IMFCFieldType=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),4)
	  .s IMFCCodeToID=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),5)
	  .s IMFCConTable=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),6)
	  .s IMFCInheritFlag=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ID)),7)
	  .s IMFCUnique=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),8)
	  .s IMFCRequired=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),9)
	  .s IMFCImport=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),10)
	  .s IMFCOrder=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),11)
	  .s EXFCIDToCode=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),12)
	  .s EXFCGetField=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),13)
	  .s IMFCExport=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),14)
	  .s EXFCFieldType=$LISTGET($G(^User.BDPIMConfigD(FieldParRef,"ChildField",ID)),15)
	  .s PINYIN=""
	  .s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE($ZCONVERT(IMFCFieldDesc,"U"))

	  .i ($ZCONVERT(IMFCFieldName,"U")[code)&(($ZCONVERT(IMFCFieldDesc,"U")[desc)||(PINYIN[desc)) d
	  ..d OutputRow
	 }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(FieldRowId,IMFCFieldName,IMFCFieldDesc,FieldParRef,IMFCFieldType,IMFCCodeToID,IMFCConTable,IMFCInheritFlag,IMFCUnique,IMFCRequired,IMFCImport,IMFCOrder,EXFCIDToCode,EXFCGetField,IMFCExport,EXFCFieldType)
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
/// Table：User.BDPIMFieldConfig
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(ParentRowId As %String, id As %String, code As %String) As %String
{
 s:code'="" code=$ZCONVERT(code,"U") //转换成大写
 s flag=""
 if (id="") //如果为空，增加时的重复判断
 {
  s flagc=""
  s:code'="" flagc=$d(^User.BDPIMFieldConfigI("FieldNameUniqueI"," "_code,ParentRowId))
  if (flagc>0) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s ParRef=$p(id,"||",1)
  s subId=$p(id,"||",2)
  s flagc=""
  s:code'="" flagc=$d(^User.BDPIMFieldConfigI("FieldNameUniqueI"," "_code,ParRef))
  s idc=""
  s:code'="" idc=$o(^User.BDPIMFieldConfigI("FieldNameUniqueI"," "_code,ParRef,0))
  if ((idc'=subId)&(flagc>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Description：保存
/// Table：User.BDPIMFieldConfig
/// Return:成功返回true，失败返回false
/// Others: d ##class(web.DHCBL.BDP.BDPIMFieldConfig).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPIMFieldConfig) As %String
{
   
 s $zt="EEROE"
 s result=""
 s:eobj.IMFCExport="" eobj.IMFCExport="N"
 if $IsObject(eobj)
 {
  s flag=..Validate(eobj.ParRef,eobj.FieldRowId,eobj.IMFCFieldName)  //调用重复验证
  if (flag=1)
  {
  	 	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
	   if (eobj.FieldRowId="")       //如果RowId未赋值则增加
	   {
	    s obj=##class(User.BDPIMFieldConfig).%New(eobj.ParRef)
  
	   }
	   else                                                  //如果RowId已赋值则修改
	   {
	   	 s obj=##class(User.BDPIMFieldConfig).%OpenId(eobj.FieldRowId)
	   	 s bobj=##class(web.Entity.BDP.BDPIMFieldConfig).%New()
	   	 s bobj.FieldRowId=eobj.FieldRowId
	   	 s bobj.ParRef=eobj.ParRef
	   	 s bobj.IMFCFieldName= obj.IMFCFieldName
	     s bobj.IMFCFieldDesc= obj.IMFCFieldDesc
	     s bobj.IMFCCodeToID = obj.IMFCCodeToID
	     s bobj.IMFCFieldType = obj.IMFCFieldType
	     s bobj.IMFCConTable = obj.IMFCConTable
	     s bobj.IMFCInheritFlag = obj.IMFCInheritFlag
	     s bobj.IMFCUnique = obj.IMFCUnique
	     s bobj.IMFCRequired = obj.IMFCRequired
	     s bobj.IMFCImport = obj.IMFCImport
	     s bobj.IMFCOrder=obj.IMFCOrder
	     s bobj.EXFCIDToCode=obj.EXFCIDToCode
	     s bobj.EXFCGetField=obj.EXFCGetField
	     s bobj.IMFCExport=obj.IMFCExport
	     s bobj.EXFCFieldType=obj.EXFCFieldType
	
	   }
	   Ts        
	   d:eobj.ParRef'="" obj.ParRefSetObjectId(eobj.ParRef) //修改数据时ParRef为空
	   s eobj.IMFCFieldName=##class(web.DHCBL.BDP.BDPIMConfig).trim(eobj.IMFCFieldName)  ; 去除空格
	   s eobj.IMFCFieldDesc=##class(web.DHCBL.BDP.BDPIMConfig).trim(eobj.IMFCFieldDesc)  ; 去除空格
	   
	   s obj.IMFCFieldName= eobj.IMFCFieldName
	   s obj.IMFCFieldDesc= eobj.IMFCFieldDesc
	   s obj.IMFCCodeToID = eobj.IMFCCodeToID
	   s obj.IMFCFieldType = eobj.IMFCFieldType
	   s obj.IMFCConTable = eobj.IMFCConTable
	   s:eobj.IMFCInheritFlag="" eobj.IMFCInheritFlag ="N" 
	   s obj.IMFCInheritFlag=eobj.IMFCInheritFlag
	   s:eobj.IMFCUnique="" eobj.IMFCUnique ="N" 
	   s obj.IMFCUnique=eobj.IMFCUnique
	   s:eobj.IMFCRequired="" eobj.IMFCRequired ="N" 
	   s obj.IMFCRequired=eobj.IMFCRequired
	   s:eobj.IMFCImport="" eobj.IMFCImport ="N" 
	   s obj.IMFCImport=eobj.IMFCImport
	   s obj.IMFCOrder=eobj.IMFCOrder
	   s obj.EXFCIDToCode=eobj.EXFCIDToCode
	   s obj.EXFCGetField=eobj.EXFCGetField
	   s:eobj.IMFCExport="" eobj.IMFCExport ="N" 
	   s obj.IMFCExport=eobj.IMFCExport
	   s obj.EXFCFieldType=eobj.EXFCFieldType
	   s sc=obj.%Save()
	   d obj.%Close()
	   If $$$ISOK(sc){
		    Tc
		    s id = obj.%Id()
		    s result = "{success:'true',id:'"_id_"'}"         //返回RowId
		    //保存日志
		    d:eobj.FieldRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPIMFieldConfig","User.BDPIMFieldConfig","导入配置表字段",id,eobj.IMFCFieldDesc,"A",eobj)
		    d:eobj.FieldRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPIMFieldConfig","User.BDPIMFieldConfig","导入配置表字段",eobj.FieldRowId,eobj.IMFCFieldDesc,"U",eobj,bobj)
	   }else{
		    Trollback
		    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
	   }
  }
 }
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
 q result
EEROE
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Description：根据id删除‘表字段’的内容
/// Table：User.BDPIMFieldConfig
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
 s result = ""
 s eobj=##class(web.Entity.BDP.BDPIMFieldConfig).%New()
 s ParRef=$p(id,"||",1)
 s ChildSub=$p(id,"||",2)
 s eobj.FieldRowId=id
 s eobj.IMFCFieldName=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),3)
 s eobj.IMFCFieldDesc=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),2)
 s eobj.IMFCFieldType=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),4)
 s eobj.IMFCCodeToID=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),5)
 s eobj.IMFCConTable=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),6)  
 s eobj.IMFCInheritFlag=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),7)
 s eobj.IMFCUnique=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),8)
 s eobj.IMFCRequired=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),9)
 s eobj.IMFCImport=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),10)
 s eobj.IMFCOrder=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),11)
 s eobj.EXFCIDToCode=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),12)
 s eobj.EXFCGetField=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),13)
 s eobj.IMFCExport=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),14)
 s eobj.EXFCFieldType=$LISTGET($G(^User.BDPIMConfigD(ParRef,"ChildField",ChildSub)),15)
 q:eobj.IMFCInheritFlag="Y" "{success:'false',info:'继承的字段不能删除！'}"
 s sc=##class(User.BDPIMFieldConfig).%DeleteId(id)
 if $$$ISOK(sc)
 {   
  s result = "{success:'true',info:'删除成功！'}"
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPIMFieldConfig","User.BDPIMFieldConfig","导入配置表字段",id,eobj.IMFCFieldDesc,"D",eobj)
  d eobj.%Close()
 }
 else
 {
  s result="{success:'false',info:'删除失败！'}"
 }
 q result
}

}
