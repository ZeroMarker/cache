Import SQLUser

/// 名称:表字段维护 
/// 描述:包含增删改查功能
/// 编写者：谷雪萍
/// 编写日期: 2015-2-11
Class web.DHCBL.BDP.BDPTableField Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Table：User.BDPTableField
/// Input：ParRef		filterflag 为"Y"时，过滤不可翻译字段 2020-4-27 钟荣枫
/// Debug: d ##class(%ResultSet).RunQuery("","","","")
Query GetList(ParRef As %String, RowId As %String, code As %String, desc As %String, filterflag As %String) As %Query(ROWSPEC = "FieldRowId:%String,FieldName:%String,FieldDesc:%String,FieldParRef:%String,FieldTabCode:%String,FieldType:%String,FieldTranslation:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ParRef As %String, RowId As %String, code As %String, desc As %String, filterflag As %String) As %Status
{
 s repid=$I(^CacheTemp)
 s ind=1
 
 if (RowId'="") //根据rowid返回该条记录
 {
  s ID=$p(RowId,"||",2)
  s FieldRowId=RowId
  s FieldParRef=$p(RowId,"||",1)
  s FieldName=$LISTGET($G(^User.BDPTableListD(FieldParRef,"ChildField",ID)),3)
  s FieldDesc=$LISTGET($G(^User.BDPTableListD(FieldParRef,"ChildField",ID)),2)
  s FieldTabCode=$LISTGET($G(^User.BDPTableListD(FieldParRef,"ChildField",ID)),4)
  s FieldType=$LISTGET($G(^User.BDPTableListD(FieldParRef,"ChildField",ID)),5)
  s FieldTranslation=$LISTGET($G(^User.BDPTableListD(FieldParRef,"ChildField",ID)),6)
  d OutputRow
 }
 else
 {
  	s:code'="" code=$ZCONVERT(code,"U") //转换成大写
  	s:desc'="" desc=$ZCONVERT(desc,"U") //转换成大写
  	if (ParRef'="")
  	{
	  	s ID=0
	 	for 
	 	{
		 	s ID=$o(^User.BDPTableListD(ParRef,"ChildField",ID)) q:ID=""
		 	s FieldRowId=ParRef_"||"_ID
		 	s FieldParRef=ParRef
	  		s FieldName=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),3)
	 		s FieldDesc=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),2)
	 		s FieldTabCode=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),4)
	 		s FieldType=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),5)
	 		s FieldTranslation=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ID)),6)
	 		continue:(filterflag="Y")&&((FieldTranslation'="Y")||(FieldType'="String"))	//过滤不可翻译字段 2020-4-27 钟荣枫
	 		s PINYIN=##class(web.DHCBL.BDP.FunLib).GetPYCODE(FieldDesc)
	 		if ($ZCONVERT(FieldName,"U")[code)&(($ZCONVERT(FieldDesc,"U")[desc)||(PINYIN[desc)) 
	 		{
		 		d OutputRow
	 		}
 		
 		}
  	}
  
 }
 
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK
OutputRow
    set Data=$lb(FieldRowId,FieldName,FieldDesc,FieldParRef,FieldTabCode,FieldType,FieldTranslation)
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
/// Table：User.BDPTableField
/// Input：id, code
/// Return："1"(数据重复),"0"(数据不重复)
ClassMethod Validate(ParentRowId As %String, id As %String, code As %String) As %String
{
 s:code'="" code=$ZCONVERT(code,"U") //转换成大写
 s flag=""
 if (id="") //如果为空，增加时的重复判断
 {
  s flagc=""
  s:code'="" flagc=$d(^User.BDPTableFieldI("NameIndex"," "_code,ParentRowId))
  if (flagc>0) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 else //如果不为空，修改时的重复判断
 {
  s ParRef=$p(id,"||",1)
  s subId=$p(id,"||",2)
  s flagc=""
  s:code'="" flagc=$d(^User.BDPTableFieldI("NameIndex"," "_code,ParRef))
  s idc=""
  s:code'="" idc=$o(^User.BDPTableFieldI("NameIndex"," "_code,ParRef,0))
  if ((idc'=subId)&(flagc>0)) s flag=1  //返回重复标志
  else  s flag=0 //返回不重复标志
 }
 q flag
}

/// Description：保存
/// Table：User.BDPTableField
/// Return:成功返回true，失败返回false
/// Others: d ##class(web.DHCBL.BDP.BDPTableField).SaveEntity()
ClassMethod SaveEntity(eobj As web.Entity.BDP.BDPTableField) As %String
{
   
 s $zt="EEROE"
 s result=""
 if $IsObject(eobj)
 {
  s flag=..Validate(eobj.ParRef,eobj.FieldRowId,eobj.FieldName)  //调用重复验证
  if (flag=1)
  {
  	 	s result = "{success:'false',errorinfo:'该记录已经存在！'}"
  }
  else
  {
	   if ((eobj.FieldTabCode'="")&((eobj.FieldTabCode'["^")))
       {
         s ClassFlag=##class(web.DHCBL.BDP.FindTableStructure).ClassExistOrNot(eobj.FieldTabCode) 
         if (ClassFlag=0)
         {
           s result= "{success:'false',errorinfo:'实体类不存在，请重新填写指向表!'}"
           q result
         }
       }
	   if (eobj.FieldRowId="")       //如果RowId未赋值则增加
	   {
	    s obj=##class(User.BDPTableField).%New(eobj.ParRef)
  
	   }
	   else                                                  //如果RowId已赋值则修改
	   {
	   	 s obj=##class(User.BDPTableField).%OpenId(eobj.FieldRowId)
	   	 s bobj=##class(web.Entity.BDP.BDPTableField).%New()
	   	 s bobj.FieldRowId=eobj.FieldRowId
	   	 s bobj.ParRef=eobj.ParRef
	     s bobj.FieldName= obj.FieldName
	     s bobj.FieldDesc= obj.FieldDesc
	     s bobj.FieldType = obj.FieldType
	     s bobj.FieldTabCode = obj.FieldTabCode
	     s bobj.FieldTranslation = obj.FieldTranslation	
	   }
	   Ts        
	   d:eobj.ParRef'="" obj.ParRefSetObjectId(eobj.ParRef) //修改数据时ParRef为空
	   s obj.FieldName= eobj.FieldName
	   s obj.FieldDesc= eobj.FieldDesc
	   s obj.FieldType = eobj.FieldType
	   s obj.FieldTabCode = eobj.FieldTabCode
	   s obj.FieldTranslation = eobj.FieldTranslation
	   s sc=obj.%Save()
	   d obj.%Close()
	   If $$$ISOK(sc){
		    Tc
		    s id = obj.%Id()
		    s result = "{success:'true',id:'"_id_"'}"         //返回RowId
		    //保存日志
		    d:eobj.FieldRowId="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPTableField","User.BDPTableField","表字段",id,eobj.FieldDesc,"A",eobj)
		    d:eobj.FieldRowId'="" ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPTableField","User.BDPTableField","表字段",eobj.FieldRowId,eobj.FieldDesc,"U",eobj,bobj)
	   }else{
		    Trollback
		    s result = "{success:'false',errorinfo:'"_##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)_"'}"    //返回错误信息
   			s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("表字段","web.DHCBL.BDP.BDPTableField","SaveEntity",eobj)
 			s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
	   }
  }
 }
 else
 {
  s result = "{success:'false',errorinfo:'对象不存在！'}"
 } 
 q result
EEROE
	s logid=##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("表字段","web.DHCBL.BDP.BDPTableField","SaveEntity",eobj)
	s ^ERRORLOGINFO(logid)=$ze
 q result= "{success:'false',errorinfo:'保存失败！'}"
}

/// Description：根据id删除‘表字段’的内容
/// Table：User.BDPTableField
/// Input：id 
/// Return：成功返回true，失败返回false和失败原因
ClassMethod DeleteData(id) As %String
{
 s result = ""
 s eobj=##class(web.Entity.BDP.BDPTableField).%New()
 s ParRef=$p(id,"||",1)
 s ChildSub=$p(id,"||",2)
 s eobj.FieldRowId=id
 s eobj.FieldName=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ChildSub)),3)
 s eobj.FieldDesc=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ChildSub)),2)
 s eobj.FieldTabCode=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ChildSub)),4)
 s eobj.FieldType=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ChildSub)),5)
 s eobj.FieldTranslation=$LISTGET($G(^User.BDPTableListD(ParRef,"ChildField",ChildSub)),6)  
 s sc=##class(User.BDPTableField).%DeleteId(id)
 if $$$ISOK(sc)
 {   
  s result = "{success:'true',info:'删除成功！'}"
  //保存日志
  d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLog("BDPTableField","User.BDPTableField","表字段",id,eobj.FieldDesc,"D",eobj)
  d eobj.%Close()
 }
 else
 {
  s result="{success:'false',info:'删除失败！'}"
  s logid= ##class(web.DHCBL.BDP.BDPSysErrorLog).SaveLog("表字段","web.DHCBL.BDP.BDPTableField","DeleteData",eobj)
  s ^ERRORLOGINFO(logid)=##class(web.DHCBL.BDP.FunLib).GetErrorInfo(sc)
 }
 q result
}

/// 基础数据平台-likefan
/// 2022-03-28
/// 获取导出数据条数，记录global
/// w ##class(web.DHCBL.BDP.BDPTableField).GetItemsCount()
ClassMethod GetItemsCount() As %String
{
	k ^TMPITEMSCOUNT
	s count=0
	q:$o(^TEMPTableImport(0))="" 0
	s ID=0
	for
	{
		s ID=$o(^TEMPTableImport(ID)) q:ID=""
		s count=count+1
		s ^TMPITEMSCOUNT(count)=ID
		s sub=0
		for
		{
			s sub=$o(^User.BDPTableListD(ID,"ChildField",sub))  q:sub=""
			s count=count+1
			s ^TMPITEMSCOUNT(count)=ID_"#"_sub
		}
	}
	q count
}

/// /w ##class(web.DHCBL.BDP.BDPTableField).GetItemInfo("2681")
ClassMethod GetItemInfo(i) As %String
{
	n (i)
	s str=""
	S idstr=$g(^TMPITEMSCOUNT(i))
	s ID=$p(idstr,"#",1)
	s sub=$p(idstr,"#",2)
	q:(ID="") ""
    s TableName=$LISTGET($G(^User.BDPTableListD(ID)),2)
    s ClassName=$LISTGET($G(^User.BDPTableListD(ID)),8)
    s TableDesc=$LISTGET($G(^User.BDPTableListD(ID)),3)
    s Attribute=$LISTGET($G(^User.BDPTableListD(ID)),14)
    s DataType=$LISTGET($G(^User.BDPTableListD(ID)),10)
    s MappingHospFlag=$LISTGET($G(^User.BDPTableListD(ID)),12)
    s Type=$LISTGET($G(^User.BDPTableListD(ID)),5)
    s VersionFlag=$LISTGET($G(^User.BDPTableListD(ID)),11)
    s Sources=$LISTGET($G(^User.BDPTableListD(ID)),7)
    s TableGlobal=$LISTGET($G(^User.BDPTableListD(ID)),9)
    s DescPropertyName=$LISTGET($G(^User.BDPTableListD(ID)),15)
    s CodePropertyName=$LISTGET($G(^User.BDPTableListD(ID)),16)
    //8.5后
    //s StandardDataType=$LISTGET($G(^User.BDPTableListD(ID)),17)		//标准数据类型
  	//s StandardDataVersion=$LISTGET($G(^User.BDPTableListD(ID)),18)	//标准数据版本
    
  	s str=TableName_"#"_ClassName_"#"_TableDesc_"#"_Attribute_"#"_DataType_"#"_MappingHospFlag_"#"_Type_"#"_VersionFlag_"#"_Sources_"#"_TableGlobal_"#"_DescPropertyName_"#"_CodePropertyName_"#"_""_"#"_""_"#"_""_"#"_""_"#"_""	//_"#"_StandardDataType_"#"_StandardDataVersion
  	
  	if (sub'="")
  	{
	  s FieldName=$LISTGET($G(^User.BDPTableListD(ID,"ChildField",sub)),3)
	  s FieldDesc=$LISTGET($G(^User.BDPTableListD(ID,"ChildField",sub)),2)
	  s FieldType=$LISTGET($G(^User.BDPTableListD(ID,"ChildField",sub)),5)
	  s FieldTabCode=$LISTGET($G(^User.BDPTableListD(ID,"ChildField",sub)),4)
	  s FieldTranslation=$LISTGET($G(^User.BDPTableListD(ID,"ChildField",sub)),6)
  	  s str=TableName_"#"_ClassName_"#"_TableDesc_"#"_Attribute_"#"_DataType_"#"_MappingHospFlag_"#"_Type_"#"_VersionFlag_"#"_Sources_"#"_TableGlobal_"#"_DescPropertyName_"#"_CodePropertyName_"#"_FieldName_"#"_FieldDesc_"#"_FieldType_"#"_FieldTabCode_"#"_FieldTranslation	//_"#"_StandardDataType_"#"_StandardDataVersion
	
  	}
  	
	q str
}

/// Creator:李得原
/// CreatDate:2018-11-1
/// Description:把前台传回来的excel中的数据保存到数据库中
/// Table:BDPTableList  BDPTableField
/// Input:
/// Return: 0 为保存失败 1为保存成功
/// w ##class(web.DHCBL.BDP.ImportExcel).ImportExcel()
ClassMethod ImportExcel(tempStr) As %String
{
	s result =0
	q:tempStr="" 0
	s TableName=$p(tempStr,"#",1)
	q:TableName="" result
	s TableName1=$zstrip(TableName,"<>W")
	s flag=$d(^User.BDPTableListI("UqIndex"," "_$zcvt(TableName1,"U")))
	if (flag>0)       ///表结构已存在
	{
		s id=$o(^User.BDPTableListI("UqIndex"," "_$zcvt(TableName1,"U"),0))
		if ($p(tempStr,"#",9)="")      ///第九列为空
		{
			s oobj=##class(User.BDPTableList).%OpenId(id)
			////判断是否和原数据一样，一样则不修改
			
			s cstrnew="{list:[{TableName:"""_$p(tempStr,"#",1)_""",ClassName:"""_$p(tempStr,"#",2)_""",TableGlobal:"""_$p(tempStr,"#",3)_""",TableDesc:"""_$p(tempStr,"#",4)_""",Xcode:"""_$p(tempStr,"#",5)_""",XCode2:"""_$p(tempStr,"#",6)_""",Type:"""_$p(tempStr,"#",7)_""",Sources:"""_$p(tempStr,"#",8)_""",ID:"""_id_"""}]}"
			s cstrold="{list:[{TableName:"""_oobj.TableName_""",ClassName:"""_oobj.ClassName_""",TableGlobal:"""_oobj.TableGlobal_""",TableDesc:"""_oobj.TableDesc_""",Xcode:"""_oobj.XCode_""",XCode2:"""_oobj.XCode2_""",Type:"""_oobj.Type_""",Sources:"""_oobj.Sources_""",ID:"""_id_"""}]}"
			d oobj.%Close()
			if (cstrnew=cstrold)
			{
	   			s result=2 ///跳过修改
			}
			else
			{
	   			///修改
	   			s eobj=##class(web.Entity.BDP.BDPTableList).%New()
				s eobj.ID=id
				s eobj.TableName = $p(tempStr,"#",1)
				s eobj.ClassName = $p(tempStr,"#",2)
				s eobj.TableGlobal = $p(tempStr,"#",3)
				s eobj.TableDesc = $p(tempStr,"#",4)
				s eobj.XCode = $p(tempStr,"#",5)
				s eobj.XCode2 = $p(tempStr,"#",6)
				s eobj.Type = $p(tempStr,"#",7)
				s eobj.Sources = $p(tempStr,"#",8)
				s estr=##class(web.DHCBL.BDP.BDPTableList).SaveEntity(eobj)
				if (estr["success:'true'")
				{
					 s result=1
				}
				if (estr["success:'false'")
				{
					s result=0
					s ^TMPTABLELISTERROR($p(tempStr,"#",1),$p(tempStr,"#",2))=tempStr
				} 
			}
		}
		else             ///excel中第九列有值，则修改或增加表字段数据
		{
			s FieldName = $p(tempStr,"#",9)
			q:FieldName="" result 
			S FieldName1=$zstrip(FieldName,"<>W")    
			s idd=$o(^User.BDPTableFieldI("NameIndex"," "_$zcvt(FieldName1,"U"),id,0))
			if (idd>0)
			{
				s FIELDID=id_"||"_idd
				s fieldoobj=##class(User.BDPTableField).%OpenId(FIELDID)
				////判断是否和原数据一样，一样则不修改
				s fieldnew="{list:[{FieldName:"""_$p(tempStr,"#",9)_""",FieldDesc:"""_$p(tempStr,"#",10)_""",FieldType:"""_$p(tempStr,"#",11)_""",FieldTabCode:"""_$p(tempStr,"#",12)_""",FieldTranslation:"""_$p(tempStr,"#",13)_"""}]}"
	   			s fieldold="{list:[{FieldName:"""_fieldoobj.FieldName_""",FieldDesc:"""_fieldoobj.FieldDesc_""",FieldType:"""_fieldoobj.FieldType_""",FieldTabCode:"""_fieldoobj.FieldTabCode_""",FieldTranslation:"""_fieldoobj.FieldTranslation_"""}]}"
	   			d fieldoobj.%Close()
	   			if (fieldnew=fieldold)
	   			{
		   			s result=2 ///数据相同，跳过
	   			}
	   			else
	   			{
	   			 //字段数据不同，修改
	   				s eobj1=##class(web.Entity.BDP.BDPTableField).%New()
	   				s eobj1.ParRef=id
	   				s eobj1.FieldName=$p(tempStr,"#",9)
					s eobj1.FieldDesc=$p(tempStr,"#",10)
					s eobj1.FieldRowId=FIELDID
					s eobj1.FieldType=$p(tempStr,"#",11)
					s eobj1.FieldTabCode=$p(tempStr,"#",12)
					s eobj1.FieldTranslation=$p(tempStr,"#",13)
					s estr1=##class(web.DHCBL.BDP.BDPTableField).SaveEntity(eobj1)
					if (estr1["success:'true'")
					{
	   					 s result=1
					}
					if (estr1["success:'false'")
					{
						s result=0
						s ^TMPTABLEFIELDERROR($p(tempStr,"#",1),$p(tempStr,"#",9))=tempStr
					}
		   		}
			}
			else
			{
				//字段新增
				s eobj1=##class(web.Entity.BDP.BDPTableField).%New()
				s eobj1.FieldRowId=""
				s eobj1.ParRef=id
				s eobj1.FieldName=$p(tempStr,"#",9)
				s eobj1.FieldDesc=$p(tempStr,"#",10)
				s eobj1.FieldType=$p(tempStr,"#",11)
				s eobj1.FieldTabCode=$p(tempStr,"#",12)
				s eobj1.FieldTranslation=$p(tempStr,"#",13)

				s estr1=##class(web.DHCBL.BDP.BDPTableField).SaveEntity(eobj1)
				
				if (estr1["success:'true'")
				{
	   				 s result=1
				}
				if (estr1["success:'false'")
				{
					s result=0
					s ^TMPTABLEFIELDERROR($p(tempStr,"#",1),$p(tempStr,"#",9))=tempStr
				}	
			}
		}
		
	}
	else   ///表结构不存在则新增
	{
		s eobj1=##class(web.Entity.BDP.BDPTableList).%New()
		s eobj1.ID=""
		s eobj1.TableName = $p(tempStr,"#",1)
		s eobj1.ClassName = $p(tempStr,"#",2)
		s eobj1.TableGlobal = $p(tempStr,"#",3)
		s eobj1.TableDesc = $p(tempStr,"#",4)
		s eobj1.XCode = $p(tempStr,"#",5)
		s eobj1.XCode2 = $p(tempStr,"#",6)
		s eobj1.Type = $p(tempStr,"#",7)
		s eobj1.Sources = $p(tempStr,"#",8)
		s estr=##class(web.DHCBL.BDP.BDPTableList).SaveEntity(eobj1)
		if (estr["success:'true'")
		{
			 s result=1
		}
		if (estr["success:'false'")
		{
			s result=0
			s ^TMPTABLELISTERROR($p(tempStr,"#",1),$p(tempStr,"#",2))=tempStr
		} 
		
	}
	quit result
}

}
