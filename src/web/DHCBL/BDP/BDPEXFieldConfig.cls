Import SQLUser

/// 名称:导出配置表字段维护 
/// 描述:包含增删改查功能
/// 编写者：谷雪萍
/// 编写日期: 2016-1-29
Class web.DHCBL.BDP.BDPEXFieldConfig Extends %RegisteredObject [ ProcedureBlock ]
{

/// Table：User.BDPEXFieldConfig
/// Input：ParRef
/// Debug: d ##class(%ResultSet).RunQuery("web.DHCBL.BDP.BDPEXFieldConfig","GetList","","","","")
Query GetList(ParRef As %String, RowId As %String, code As %String, desc As %String) As %Query(ROWSPEC = "FieldRowId:%String,EXFCFieldName:%String,EXFCFieldDesc:%String,FieldParRef:%String,EXFCFieldType:%String,EXFCIDToCode:%String,EXFCGetField:%String,EXFCIDToCodeName:%String,EXFCExport:%String,EXFCOrder:%String")
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
  s EXFCFieldName=$LISTGET($G(^User.BDPEXConfigD(FieldParRef,"ChildField",ID)),3)
  s EXFCFieldDesc=$LISTGET($G(^User.BDPEXConfigD(FieldParRef,"ChildField",ID)),2)
  s EXFCFieldType=$LISTGET($G(^User.BDPEXConfigD(FieldParRef,"ChildField",ID)),4)
  s EXFCIDToCode=$LISTGET($G(^User.BDPEXConfigD(FieldParRef,"ChildField",ID)),5)
  s EXFCGetField=$LISTGET($G(^User.BDPEXConfigD(FieldParRef,"ChildField",ID)),6)
  s EXFCIDToCodeName=$LISTGET($G(^User.BDPEXConfigD(FieldParRef,"ChildField",ID)),7)
  s EXFCExport=$LISTGET($G(^User.BDPEXConfigD(FieldParRef,"ChildField",ID)),8)
  s EXFCOrder=$LISTGET($G(^User.BDPEXConfigD(FieldParRef,"ChildField",ID)),9)
  d OutputRow
 }
 else
 {
	  if ParRef'=""
	 {
	  s:code'="" code=$ZCONVERT(code,"U") //转换成大写
	  s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
	  s ID=0
	  f  s ID=$o(^User.BDPEXConfigD(ParRef,"ChildField",ID)) q:ID=""  d
	  .s FieldRowId=ParRef_"||"_ID
	  .s FieldParRef=ParRef
	  .s EXFCFieldName=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",ID)),3)
	  .s EXFCFieldDesc=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",ID)),2)
	  .s EXFCFieldType=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",ID)),4)
	  .s EXFCIDToCode=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",ID)),5)
	  .s EXFCGetField=$LISTGET($G(^User.BDPEXConfigD(FieldParRef,"ChildField",ID)),6)
	  .s EXFCIDToCodeName=$LISTGET($G(^User.BDPEXConfigD(FieldParRef,"ChildField",ID)),7)
	  .s EXFCExport=$LISTGET($G(^User.BDPEXConfigD(FieldParRef,"ChildField",ID)),8)
	  .s EXFCOrder=$LISTGET($G(^User.BDPEXConfigD(FieldParRef,"ChildField",ID)),9)
	  .s EXFCFieldDescU=$ZCONVERT(EXFCFieldDesc,"U")
	  .s PINYIN=""
	  .s:desc'="" PINYIN= ##class(web.DHCBL.BDP.FunLib).GetPYCODE(EXFCFieldDescU)
	  .i ($ZCONVERT(EXFCFieldName,"U")[code)&((EXFCFieldDescU[desc)||(PINYIN[desc)) d
	  ..d OutputRow
	 }
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(FieldRowId,EXFCFieldName,EXFCFieldDesc,FieldParRef,EXFCFieldType,EXFCIDToCode,EXFCGetField,EXFCIDToCodeName,EXFCExport,EXFCOrder)
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
/// Table：User.BDPEXFieldConfig
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(ParentRowId As %String, id As %String, code As %String) As %String
{
 s:code'="" code=$ZCONVERT(code,"U") //转换成大写
 s flag=""
 if (id="") //如果为空，增加时的重复判断
 {
  s flagc=""
  s:code'="" flagc=$d(^User.BDPEXFieldConfigI("FieldNameUniqueI"," "_code,ParentRowId))
  if (flagc>0) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s ParRef=$p(id,"||",1)
  s subId=$p(id,"||",2)
  s flagc=""
  s:code'="" flagc=$d(^User.BDPEXFieldConfigI("FieldNameUniqueI"," "_code,ParRef))
  s idc=""
  s:code'="" idc=$o(^User.BDPEXFieldConfigI("FieldNameUniqueI"," "_code,ParRef,0))
  if ((idc'=subId)&(flagc>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Description：保存
/// Table：User.BDPEXFieldConfig
/// Return:成功返回true，失败返回false
/// Others: d ##class(web.DHCBL.BDP.BDPEXFieldConfig).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPEXFieldConfig) As %String
{
   
 s $zt="EEROE"
 s result=""
 if $IsObject(eobj)
 {
  s flag=..Validate(eobj.ParRef,eobj.FieldRowId,eobj.EXFCFieldName)  //调用重复验证
  if (flag=1)
  {
  	 	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
	   if (eobj.FieldRowId="")       //如果RowId未赋值则增加
	   {
	    s obj=##class(User.BDPEXFieldConfig).%New(eobj.ParRef)
  
	   }
	   else                                                  //如果RowId已赋值则修改
	   {
	   	 s obj=##class(User.BDPEXFieldConfig).%OpenId(eobj.FieldRowId)
	   	 s bobj=##class(web.Entity.BDP.BDPEXFieldConfig).%New()
	   	 s bobj.FieldRowId=eobj.FieldRowId
	   	 s bobj.ParRef=eobj.ParRef
	     s bobj.EXFCFieldName= obj.EXFCFieldName
	     s bobj.EXFCFieldDesc= obj.EXFCFieldDesc
	     s bobj.EXFCIDToCode = obj.EXFCIDToCode
	     s bobj.EXFCFieldType = obj.EXFCFieldType
	     s bobj.EXFCGetField = obj.EXFCGetField
	     s bobj.EXFCIDToCodeName = obj.EXFCIDToCodeName
	     s bobj.EXFCExport = obj.EXFCExport
	     s bobj.EXFCOrder = obj.EXFCOrder
	     
	   }
	   Ts        
	   d:eobj.ParRef'="" obj.ParRefSetObjectId(eobj.ParRef) //修改数据时ParRef为空
	   s eobj.EXFCFieldName=##class(web.DHCBL.BDP.BDPEXConfig).trim(eobj.EXFCFieldName)  ; 去除空格
	   s eobj.EXFCFieldDesc=##class(web.DHCBL.BDP.BDPEXConfig).trim(eobj.EXFCFieldDesc)  ; 去除空格
	   s obj.EXFCFieldName= eobj.EXFCFieldName
	   s obj.EXFCFieldDesc= eobj.EXFCFieldDesc
	   s obj.EXFCIDToCode = eobj.EXFCIDToCode
	   s obj.EXFCFieldType = eobj.EXFCFieldType
	   s obj.EXFCGetField = eobj.EXFCGetField
	   s obj.EXFCIDToCodeName = eobj.EXFCIDToCodeName
	   s obj.EXFCExport = eobj.EXFCExport
	   s obj.EXFCOrder = eobj.EXFCOrder
	   s sc=obj.%Save()
	   d obj.%Close()
	   If $$$ISOK(sc){
		    Tc
		    s id = obj.%Id()
		    s result = "{success:'true',id:'"_id_"'}"         //返回RowId
		    //保存日志
		    d:eobj.FieldRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPEXFieldConfig","User.BDPEXFieldConfig","导出配置表字段",id,eobj.EXFCFieldDesc,"A",eobj)
		    d:eobj.FieldRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPEXFieldConfig","User.BDPEXFieldConfig","导出配置表字段",eobj.FieldRowId,eobj.EXFCFieldDesc,"U",eobj,bobj)
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
/// Table：User.BDPEXFieldConfig
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
 s result = ""
 s eobj=##class(web.Entity.BDP.BDPEXFieldConfig).%New()
 s ParRef=$p(id,"||",1)
 s ChildSub=$p(id,"||",2)
 s eobj.FieldRowId=id
 s eobj.EXFCFieldName=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",ChildSub)),3)
 s eobj.EXFCFieldDesc=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",ChildSub)),2)
 s eobj.EXFCFieldType=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",ChildSub)),4)
 s eobj.EXFCIDToCode=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",ChildSub)),5) 
 s eobj.EXFCGetField=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",ChildSub)),6)
 s eobj.EXFCIDToCodeName=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",ChildSub)),7)
 s eobj.EXFCExport=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",ChildSub)),8)
 s eobj.EXFCOrder=$LISTGET($G(^User.BDPEXConfigD(ParRef,"ChildField",ChildSub)),9)
 
 s sc=##class(User.BDPEXFieldConfig).%DeleteId(id)
 if $$$ISOK(sc)
 {   
  s result = "{success:'true',info:'删除成功！'}"
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPEXFieldConfig","User.BDPEXFieldConfig","导出配置表字段",id,eobj.EXFCFieldDesc,"D",eobj)
  d eobj.%Close()
 }
 else
 {
  s result="{success:'false',info:'删除失败！'}"
 }
 q result
}

/// Function: 处理导入和导入配置，将导入配置里的导出配置增加或更新到导出配置表里。
/// Creator:  chenying
/// CreateDate:2022-1-21
/// debug:   w ##class(web.DHCBL.BDP.BDPEXFieldConfig).MultiUpdateEXConfigData()
ClassMethod MultiUpdateEXConfigData() As %String
{
	k ^tmpcy
	s ID=0
	for
	{
		s ID=$o(^User.BDPIMConfigD(ID)) q:ID=""
		s IMCTableDesc=$LISTGET($G(^User.BDPIMConfigD(ID)),2)  //描述
		s IMCTableName=$LISTGET($G(^User.BDPIMConfigD(ID)),3)   //代码
		s IMCIDName=$LISTGET($G(^User.BDPIMConfigD(ID)),4)
		S EIMenuID=$o(^User.BDPEIMenuI("UniqueCodeIndex"," "_$zcvt(IMCTableName,"u"),0))
		continue:EIMenuID=""
		w IMCTableName_","_IMCTableName,!
		S EXCONFIGID=$o(^User.BDPEXConfigI("UniqueTableName"," "_$zcvt(IMCTableName,"u"),0))
		IF EXCONFIGID=""
		{
			w "没找到对应的导出配置,"_IMCTableDesc_","_IMCTableName_","_EXCONFIGID,!
			s ^tmpcy("error",ID)="没找到对应的导出配置,"_IMCTableDesc_","_IMCTableName_","_EXCONFIGID
			continue
		}

		s EXCTableDesc=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),2) //描述
		s EXCTableName=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID)),3) //代码

		if (IMCTableDesc'=EXCTableDesc)||(IMCTableName'=EXCTableName)
		{
			w "父表代码或者描述不匹配,"_IMCTableDesc_","_IMCTableName_","_EXCTableDesc_","_EXCTableName_","_EXCONFIGID,!
			s ^tmpcy("error",ID)="父表代码或者描述不匹配,"_IMCTableDesc_","_IMCTableName_","_EXCTableDesc_","_EXCTableName_","_EXCONFIGID
			//continue
		}

		s IMFieldChildSub=0
		for
		{
			s IMFieldChildSub=$o(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)) q:IMFieldChildSub=""

			s IMFCFieldName=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),3)
			s IMFCFieldDesc=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),2)
			s IMFCFieldType=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),4)
			s IMFCCodeToID=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),5)
			s IMFCConTable=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),6)
			s IMFCInheritFlag=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),7)
			s IMFCUnique=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),8)
			s IMFCRequired=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),9)
			s IMFCImport=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),10)
			s IMFCOrder=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),11)
			s EXFCIDToCode=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),12)
			s EXFCGetField=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),13)
			s IMFCExport=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),14)
			continue:IMFCExport="N"
			s EXFCFieldType=$LISTGET($G(^User.BDPIMConfigD(ID,"ChildField",IMFieldChildSub)),15)


			S EXFIELDCONFIGSub=$o(^User.BDPEXFieldConfigI("FieldNameUniqueI"," "_$zcvt(IMFCFieldName,"u"),EXCONFIGID,0))
			IF EXFIELDCONFIGSub=""
			{
				//b ;1
				w "没找到对应的字段导出配置,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc,!
				s ^tmpcy("error",ID,IMFieldChildSub)="没找到对应的字段导出配置,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc

				s FIELDobj=##class(User.BDPEXFieldConfig).%New(EXCONFIGID)
				d FIELDobj.ParRefSetObjectId(EXCONFIGID)
				
			
			}
			else
			{
				s EXFCFieldName=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),3)   //字段描述
				s EXFCFieldDesc=$LISTGET($G(^User.BDPEXConfigD(EXCONFIGID,"ChildField",EXFIELDCONFIGSub)),2)  //字段代码

				if (IMFCFieldDesc'=EXFCFieldDesc)||(IMFCFieldName'=EXFCFieldName)
				{
					//b ;2
					w "代码或者描述不匹配,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_","_EXFCFieldDesc_","_EXFCFieldName,!
					s ^tmpcy("error",ID,IMFieldChildSub)="代码或者描述不匹配,"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_","_EXFCFieldDesc_","_EXFCFieldName
					//continue
				}
				s FIELDobj=##class(User.BDPEXFieldConfig).%OpenId(EXCONFIGID_"||"_EXFIELDCONFIGSub)
			}
			s FIELDobj.EXFCFieldName= IMFCFieldName
			s FIELDobj.EXFCFieldDesc= IMFCFieldDesc
			s FIELDobj.EXFCIDToCode = EXFCIDToCode
			s FIELDobj.EXFCFieldType = EXFCFieldType
			s FIELDobj.EXFCGetField = EXFCGetField
			s FIELDobj.EXFCExport = IMFCExport
			s FIELDobj.EXFCOrder = IMFCOrder
			s sc=FIELDobj.%Save()
			d FIELDobj.%Close()
			If $$$ISOK(sc)
			{
				s id = FIELDobj.%Id()
				//w "保存成功!"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc,!
				
			}
			else
			{
				w "保存失败!"_IMCTableDesc_","_IMCTableName_","_IMFCFieldName_","_IMFCFieldDesc_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc),!
				s ^tmpcy("error",ID,IMFieldChildSub)="保存失败!"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
				continue
			}



		}
	}
	q "1"
}

}
